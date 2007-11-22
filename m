From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 8/11] [CRYPTO] blkcipher: Create default givcipher instances
Date: Thu, 22 Nov 2007 16:48:46 +0800
Message-ID: <E1Iv7jq-00020x-00@gondolin.me.apana.org.au>
References: <20071122084758.GA7536@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1106 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751719AbXKVJCg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Nov 2007 04:02:36 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1Iv7jt-0008DG-RJ
	for <linux-crypto@vger.kernel.org>; Thu, 22 Nov 2007 19:48:51 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] blkcipher: Create default givcipher instances

This patch makes crypto_alloc_ablkcipher/crypto_spawn_ablkcipher always
return objects that are capable of generating their own IVs before encryption
through givcrypt.  Each algorithm may specify its default IV generator
through the geniv field.

For algorithms that do not set the geniv field, the blkcipher layer will
pick a default.  Currently it's chainiv for synchronous algorithms and
eseqiv for asynchronous algorithms.  Note that if these wrappers do not
work on an algorithm then that algorithm must specify its own geniv or
it can't be used at all.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ablkcipher.c |    4 ++
 crypto/api.c        |   19 ++++++++---
 crypto/blkcipher.c  |   83 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/internal.h   |    2 +
 4 files changed, 103 insertions(+), 5 deletions(-)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index 85e7875..47c152d 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -75,6 +75,10 @@ static int crypto_init_ablkcipher_ops(struct crypto_tfm *tfm, u32 type,
 	if (alg->ivsize > PAGE_SIZE / 8)
 		return -EINVAL;
 
+	if (alg->ivsize &&
+	    (mask & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_BLKCIPHER_MASK)
+		return crypto_blkcipher_type.init(tfm, type, mask);
+
 	crt->setkey = setkey;
 	crt->encrypt = alg->encrypt;
 	crt->decrypt = alg->decrypt;
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
 
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index bd34643..baff314 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -19,6 +19,7 @@
 #include <linux/hardirq.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/rtnetlink.h>
 #include <linux/scatterlist.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
@@ -474,13 +475,95 @@ static int crypto_init_blkcipher_ops_sync(struct crypto_tfm *tfm)
 	return 0;
 }
 
+static int crypto_givcipher_default(struct crypto_tfm *tfm)
+{
+	struct rtattr *tb[3];
+	struct {
+		struct rtattr attr;
+		struct crypto_attr_type data;
+	} type;
+	struct {
+		struct rtattr attr;
+		struct crypto_attr_alg data;
+	} alg;
+	struct crypto_template *tmpl;
+	struct crypto_instance *inst;
+	struct crypto_alg *larval;
+	const char *geniv;
+	int err;
+
+	larval = crypto_larval_lookup(crypto_tfm_alg_driver_name(tfm),
+				      CRYPTO_ALG_TYPE_GIVCIPHER,
+				      CRYPTO_ALG_TYPE_MASK);
+	if (IS_ERR(larval))
+		return PTR_ERR(larval);
+	if (!crypto_is_larval(larval))
+		return -EAGAIN;
+
+	type.attr.rta_len = sizeof(type);
+	type.attr.rta_type = CRYPTOA_TYPE;
+	type.data.type = 0;
+	/* A zero mask tells the template that we're making a default geniv. */
+	type.data.mask = 0;
+	tb[0] = &type.attr;
+
+	alg.attr.rta_len = sizeof(alg);
+	alg.attr.rta_type = CRYPTOA_ALG;
+	/* Must use the exact name to locate ourselves. */
+	memcpy(alg.data.name, crypto_tfm_alg_driver_name(tfm),
+	       CRYPTO_MAX_ALG_NAME);
+	tb[1] = &alg.attr;
+
+	tb[2] = NULL;
+
+	if (crypto_tfm_alg_type(tfm) == CRYPTO_ALG_TYPE_BLKCIPHER)
+		geniv = tfm->__crt_alg->cra_blkcipher.geniv;
+	else
+		geniv = tfm->__crt_alg->cra_ablkcipher.geniv;
+
+	if (!*geniv)
+		geniv = tfm->__crt_alg->cra_flags & CRYPTO_ALG_ASYNC ?
+			"eseqiv" : "chainiv";
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
+	crypto_larval_kill(larval);
+	return err;
+}
+
 static int crypto_init_blkcipher_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 {
 	struct blkcipher_alg *alg = &tfm->__crt_alg->cra_blkcipher;
 
+	if (crypto_tfm_alg_type(tfm) != CRYPTO_ALG_TYPE_BLKCIPHER)
+		return crypto_givcipher_default(tfm);
+
 	if (alg->ivsize > PAGE_SIZE / 8)
 		return -EINVAL;
 
+	if (alg->ivsize &&
+	    (mask & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_BLKCIPHER_MASK)
+		return crypto_givcipher_default(tfm);
+
 	if ((mask & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_MASK)
 		return crypto_init_blkcipher_ops_sync(tfm);
 	else
diff --git a/crypto/internal.h b/crypto/internal.h
index abb01f7..314b0c8 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -122,6 +122,8 @@ void crypto_exit_digest_ops(struct crypto_tfm *tfm);
 void crypto_exit_cipher_ops(struct crypto_tfm *tfm);
 void crypto_exit_compress_ops(struct crypto_tfm *tfm);
 
+void crypto_larval_kill(struct crypto_alg *alg);
+struct crypto_alg *crypto_larval_lookup(const char *name, u32 type, u32 mask);
 void crypto_larval_error(const char *name, u32 type, u32 mask);
 
 void crypto_shoot_alg(struct crypto_alg *alg);
