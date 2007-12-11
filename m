From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 13/19] [CRYPTO] skcipher: Create default givcipher instances
Date: Tue, 11 Dec 2007 12:05:41 +0800
Message-ID: <E1J1wNJ-0002l1-00@gondolin.me.apana.org.au>
References: <20071211040215.GA10360@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1965 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751935AbXLKEFs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Dec 2007 23:05:48 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J1wNK-00067y-UD
	for <linux-crypto@vger.kernel.org>; Tue, 11 Dec 2007 15:05:43 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] skcipher: Create default givcipher instances

This patch makes crypto_alloc_ablkcipher/crypto_grab_skcipher always
return algorithms that are capable of generating their own IVs through
givencrypt and givdecrypt.  Each algorithm may specify its default IV
generator through the geniv field.

For algorithms that do not set the geniv field, the blkcipher layer will
pick a default.  Currently it's chainiv for synchronous algorithms and
eseqiv for asynchronous algorithms.  Note that if these wrappers do not
work on an algorithm then that algorithm must specify its own geniv or
it can't be used at all.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ablkcipher.c    |  142 ++++++++++++++++++++++++++++++++++++++++++++++++-
 crypto/api.c           |   19 ++++--
 crypto/internal.h      |    2 
 include/linux/crypto.h |    9 ---
 4 files changed, 158 insertions(+), 14 deletions(-)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index 1c15722..d3fc416 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -18,6 +18,8 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/rtnetlink.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
 
@@ -163,14 +165,115 @@ const char *crypto_default_geniv(const struct crypto_alg *alg)
 	return alg->cra_flags & CRYPTO_ALG_ASYNC ? "eseqiv" : "chainiv";
 }
 
+static int crypto_givcipher_default(struct crypto_alg *alg, u32 type, u32 mask)
+{
+	struct rtattr *tb[3];
+	struct {
+		struct rtattr attr;
+		struct crypto_attr_type data;
+	} ptype;
+	struct {
+		struct rtattr attr;
+		struct crypto_attr_alg data;
+	} palg;
+	struct crypto_template *tmpl;
+	struct crypto_instance *inst;
+	struct crypto_alg *larval;
+	const char *geniv;
+	int err;
+
+	larval = crypto_larval_lookup(alg->cra_driver_name,
+				      CRYPTO_ALG_TYPE_GIVCIPHER,
+				      CRYPTO_ALG_TYPE_MASK);
+	err = PTR_ERR(larval);
+	if (IS_ERR(larval))
+		goto out;
+
+	err = -EAGAIN;
+	if (!crypto_is_larval(larval))
+		goto out;
+
+	ptype.attr.rta_len = sizeof(ptype);
+	ptype.attr.rta_type = CRYPTOA_TYPE;
+	ptype.data.type = type | CRYPTO_ALG_GENIV;
+	/* GENIV tells the template that we're making a default geniv. */
+	ptype.data.mask = mask | CRYPTO_ALG_GENIV;
+	tb[0] = &ptype.attr;
+
+	palg.attr.rta_len = sizeof(palg);
+	palg.attr.rta_type = CRYPTOA_ALG;
+	/* Must use the exact name to locate ourselves. */
+	memcpy(palg.data.name, alg->cra_driver_name, CRYPTO_MAX_ALG_NAME);
+	tb[1] = &palg.attr;
+
+	tb[2] = NULL;
+
+	if ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
+	    CRYPTO_ALG_TYPE_BLKCIPHER)
+		geniv = alg->cra_blkcipher.geniv;
+	else
+		geniv = alg->cra_ablkcipher.geniv;
+
+	if (!geniv)
+		geniv = crypto_default_geniv(alg);
+
+	tmpl = crypto_lookup_template(geniv);
+	err = -ENOENT;
+	if (!tmpl)
+		goto kill_larval;
+
+	inst = tmpl->alloc(tb);
+	err = PTR_ERR(inst);
+	if (IS_ERR(inst))
+		goto put_tmpl;
+
+	if ((err = crypto_register_instance(tmpl, inst))) {
+		tmpl->free(inst);
+		goto put_tmpl;
+	}
+
+	/* Redo the lookup to use the instance we just registered. */
+	err = -EAGAIN;
+
+put_tmpl:
+	crypto_tmpl_put(tmpl);
+kill_larval:
+	crypto_mod_put(larval);
+	crypto_larval_kill(larval);
+out:
+	crypto_mod_put(alg);
+	return err;
+}
+
+static struct crypto_alg *crypto_lookup_skcipher(const char *name, u32 type,
+						 u32 mask)
+{
+	struct crypto_alg *alg;
+
+	alg = crypto_alg_mod_lookup(name, crypto_skcipher_type(type),
+				    crypto_skcipher_mask(mask));
+	if (IS_ERR(alg))
+		return alg;
+
+	if ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
+	    CRYPTO_ALG_TYPE_GIVCIPHER)
+		return alg;
+
+	if (!((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
+	      CRYPTO_ALG_TYPE_BLKCIPHER ? alg->cra_blkcipher.ivsize :
+					  alg->cra_ablkcipher.ivsize))
+		return alg;
+
+	return ERR_PTR(crypto_givcipher_default(alg, type, mask));
+}
+
 int crypto_grab_skcipher(struct crypto_skcipher_spawn *spawn, const char *name,
 			 u32 type, u32 mask)
 {
 	struct crypto_alg *alg;
 	int err;
 
-	alg = crypto_alg_mod_lookup(name, crypto_skcipher_type(type),
-				    crypto_skcipher_mask(mask));
+	alg = crypto_lookup_skcipher(name, type, mask);
 	if (IS_ERR(alg))
 		return PTR_ERR(alg);
 
@@ -180,5 +283,40 @@ int crypto_grab_skcipher(struct crypto_skcipher_spawn *spawn, const char *name,
 }
 EXPORT_SYMBOL_GPL(crypto_grab_skcipher);
 
+struct crypto_ablkcipher *crypto_alloc_ablkcipher(const char *alg_name,
+						  u32 type, u32 mask)
+{
+	struct crypto_tfm *tfm;
+	int err;
+
+	for (;;) {
+		struct crypto_alg *alg;
+
+		alg = crypto_lookup_skcipher(alg_name, type, mask);
+		if (IS_ERR(alg)) {
+			err = PTR_ERR(alg);
+			goto err;
+		}
+
+		tfm = __crypto_alloc_tfm(alg, type, mask);
+		if (!IS_ERR(tfm))
+			return __crypto_ablkcipher_cast(tfm);
+
+		crypto_mod_put(alg);
+		err = PTR_ERR(tfm);
+
+err:
+		if (err != -EAGAIN)
+			break;
+		if (signal_pending(current)) {
+			err = -EINTR;
+			break;
+		}
+	}
+
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL_GPL(crypto_alloc_ablkcipher);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Asynchronous block chaining cipher type");
diff --git a/crypto/api.c b/crypto/api.c
index 1f5c724..a2496d1 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -137,7 +137,7 @@ static struct crypto_alg *crypto_larval_alloc(const char *name, u32 type,
 	return alg;
 }
 
-static void crypto_larval_kill(struct crypto_alg *alg)
+void crypto_larval_kill(struct crypto_alg *alg)
 {
 	struct crypto_larval *larval = (void *)alg;
 
@@ -147,6 +147,7 @@ static void crypto_larval_kill(struct crypto_alg *alg)
 	complete_all(&larval->completion);
 	crypto_alg_put(alg);
 }
+EXPORT_SYMBOL_GPL(crypto_larval_kill);
 
 static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg)
 {
@@ -176,11 +177,9 @@ static struct crypto_alg *crypto_alg_lookup(const char *name, u32 type,
 	return alg;
 }
 
-struct crypto_alg *crypto_alg_mod_lookup(const char *name, u32 type, u32 mask)
+struct crypto_alg *crypto_larval_lookup(const char *name, u32 type, u32 mask)
 {
 	struct crypto_alg *alg;
-	struct crypto_alg *larval;
-	int ok;
 
 	if (!name)
 		return ERR_PTR(-ENOENT);
@@ -193,7 +192,17 @@ struct crypto_alg *crypto_alg_mod_lookup(const char *name, u32 type, u32 mask)
 	if (alg)
 		return crypto_is_larval(alg) ? crypto_larval_wait(alg) : alg;
 
-	larval = crypto_larval_alloc(name, type, mask);
+	return crypto_larval_alloc(name, type, mask);
+}
+EXPORT_SYMBOL_GPL(crypto_larval_lookup);
+
+struct crypto_alg *crypto_alg_mod_lookup(const char *name, u32 type, u32 mask)
+{
+	struct crypto_alg *alg;
+	struct crypto_alg *larval;
+	int ok;
+
+	larval = crypto_larval_lookup(name, type, mask);
 	if (IS_ERR(larval) || !crypto_is_larval(larval))
 		return larval;
 
diff --git a/crypto/internal.h b/crypto/internal.h
index cb13952..32f4c21 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -93,6 +93,8 @@ void crypto_exit_digest_ops(struct crypto_tfm *tfm);
 void crypto_exit_cipher_ops(struct crypto_tfm *tfm);
 void crypto_exit_compress_ops(struct crypto_tfm *tfm);
 
+void crypto_larval_kill(struct crypto_alg *alg);
+struct crypto_alg *crypto_larval_lookup(const char *name, u32 type, u32 mask);
 void crypto_larval_error(const char *name, u32 type, u32 mask);
 
 void crypto_shoot_alg(struct crypto_alg *alg);
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index fa7afa9..835dcaf 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -561,13 +561,8 @@ static inline u32 crypto_skcipher_mask(u32 mask)
 	return mask;
 }
 
-static inline struct crypto_ablkcipher *crypto_alloc_ablkcipher(
-	const char *alg_name, u32 type, u32 mask)
-{
-	return __crypto_ablkcipher_cast(
-		crypto_alloc_base(alg_name, crypto_skcipher_type(type),
-				  crypto_skcipher_mask(mask)));
-}
+struct crypto_ablkcipher *crypto_alloc_ablkcipher(const char *alg_name,
+						  u32 type, u32 mask);
 
 static inline struct crypto_tfm *crypto_ablkcipher_tfm(
 	struct crypto_ablkcipher *tfm)
