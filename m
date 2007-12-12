From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 8/10] [CRYPTO] aead: Create default givcipher instances
Date: Wed, 12 Dec 2007 20:30:58 +0800
Message-ID: <E1J2Qjq-0006dr-00@gondolin.me.apana.org.au>
References: <20071212122944.GA25381@gondor.apana.org.au>
To: Joy Latten <latten@austin.ibm.com>, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3740 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758186AbXLLMbF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Dec 2007 07:31:05 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] aead: Create default givcipher instances

This patch makes crypto_alloc_aead always return algorithms that is
capable of generating their own IVs through givencrypt and givdecrypt.
All existing AEAD algorithms already do.  New ones must either supply
their own or specify a generic IV generator with the geniv field.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/aead.c                  |  147 +++++++++++++++++++++++++++++++++++++++++
 include/crypto/internal/aead.h |    3 
 include/linux/crypto.h         |   10 --
 3 files changed, 151 insertions(+), 9 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index e26d8d5..68fa3d2 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -17,6 +17,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/rtnetlink.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
 
@@ -314,5 +315,151 @@ void aead_geniv_exit(struct crypto_tfm *tfm)
 }
 EXPORT_SYMBOL_GPL(aead_geniv_exit);
 
+static int crypto_nivaead_default(struct crypto_alg *alg, u32 type, u32 mask)
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
+				      CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_GENIV,
+				      CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV);
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
+	geniv = alg->cra_aead.geniv;
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
+static struct crypto_alg *crypto_lookup_aead(const char *name, u32 type,
+					     u32 mask)
+{
+	struct crypto_alg *alg;
+
+	alg = crypto_alg_mod_lookup(name, type, mask);
+	if (IS_ERR(alg))
+		return alg;
+
+	if (alg->cra_type == &crypto_aead_type)
+		return alg;
+
+	return ERR_PTR(crypto_nivaead_default(alg, type, mask));
+}
+
+int crypto_grab_aead(struct crypto_aead_spawn *spawn, const char *name,
+		     u32 type, u32 mask)
+{
+	struct crypto_alg *alg;
+	int err;
+
+	type &= ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV);
+	type |= CRYPTO_ALG_TYPE_AEAD;
+	mask |= CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV;
+
+	alg = crypto_lookup_aead(name, type, mask);
+	if (IS_ERR(alg))
+		return PTR_ERR(alg);
+
+	err = crypto_init_spawn(&spawn->base, alg, spawn->base.inst, mask);
+	crypto_mod_put(alg);
+	return err;
+}
+EXPORT_SYMBOL_GPL(crypto_grab_aead);
+
+struct crypto_aead *crypto_alloc_aead(const char *alg_name, u32 type, u32 mask)
+{
+	struct crypto_tfm *tfm;
+	int err;
+
+	type &= ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV);
+	type |= CRYPTO_ALG_TYPE_AEAD;
+	mask |= CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV;
+
+	for (;;) {
+		struct crypto_alg *alg;
+
+		alg = crypto_lookup_aead(alg_name, type, mask);
+		if (IS_ERR(alg)) {
+			err = PTR_ERR(alg);
+			goto err;
+		}
+
+		tfm = __crypto_alloc_tfm(alg, type, mask);
+		if (!IS_ERR(tfm))
+			return __crypto_aead_cast(tfm);
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
+EXPORT_SYMBOL_GPL(crypto_alloc_aead);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Authenticated Encryption with Associated Data (AEAD)");
diff --git a/include/crypto/internal/aead.h b/include/crypto/internal/aead.h
index eb4eee7..d838c94 100644
--- a/include/crypto/internal/aead.h
+++ b/include/crypto/internal/aead.h
@@ -31,6 +31,9 @@ static inline void crypto_set_aead_spawn(
 	crypto_set_spawn(&spawn->base, inst);
 }
 
+int crypto_grab_aead(struct crypto_aead_spawn *spawn, const char *name,
+		     u32 type, u32 mask);
+
 static inline void crypto_drop_aead(struct crypto_aead_spawn *spawn)
 {
 	crypto_drop_spawn(&spawn->base);
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index e26e648..4219b48 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -723,15 +723,7 @@ static inline struct crypto_aead *__crypto_aead_cast(struct crypto_tfm *tfm)
 	return (struct crypto_aead *)tfm;
 }
 
-static inline struct crypto_aead *crypto_alloc_aead(const char *alg_name,
-						    u32 type, u32 mask)
-{
-	type &= ~CRYPTO_ALG_TYPE_MASK;
-	type |= CRYPTO_ALG_TYPE_AEAD;
-	mask |= CRYPTO_ALG_TYPE_MASK;
-
-	return __crypto_aead_cast(crypto_alloc_base(alg_name, type, mask));
-}
+struct crypto_aead *crypto_alloc_aead(const char *alg_name, u32 type, u32 mask);
 
 static inline struct crypto_tfm *crypto_aead_tfm(struct crypto_aead *tfm)
 {
