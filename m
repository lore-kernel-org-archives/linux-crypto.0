From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 9/19] [CRYPTO] skcipher: Add skcipher_geniv_alloc/skcipher_geniv_free
Date: Tue, 11 Dec 2007 12:03:00 +0800
Message-ID: <E1J1wKi-0002kC-00@gondolin.me.apana.org.au>
References: <20071211040215.GA10360@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1922 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751899AbXLKEDI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Dec 2007 23:03:08 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J1wKk-00062h-Lh
	for <linux-crypto@vger.kernel.org>; Tue, 11 Dec 2007 15:03:03 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] skcipher: Add skcipher_geniv_alloc/skcipher_geniv_free

This patch creates the infrastructure to help the construction of givcipher
templates that wrap around existing blkcipher/ablkcipher algorithms by adding
an IV generator to them.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ablkcipher.c                |   10 +-
 crypto/blkcipher.c                 |  183 ++++++++++++++++++++++++++++++++++++-
 include/crypto/internal/skcipher.h |   18 +++
 include/linux/crypto.h             |   18 ++-
 4 files changed, 223 insertions(+), 6 deletions(-)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index 76801c4..1c15722 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -80,6 +80,7 @@ static int crypto_init_ablkcipher_ops(struct crypto_tfm *tfm, u32 type,
 	crt->setkey = setkey;
 	crt->encrypt = alg->encrypt;
 	crt->decrypt = alg->decrypt;
+	crt->base = __crypto_ablkcipher_cast(tfm);
 	crt->ivsize = alg->ivsize;
 
 	return 0;
@@ -122,11 +123,13 @@ static int crypto_init_givcipher_ops(struct crypto_tfm *tfm, u32 type,
 	if (alg->ivsize > PAGE_SIZE / 8)
 		return -EINVAL;
 
-	crt->setkey = setkey;
+	crt->setkey = tfm->__crt_alg->cra_flags & CRYPTO_ALG_GENIV ?
+		      alg->setkey : setkey;
 	crt->encrypt = alg->encrypt;
 	crt->decrypt = alg->decrypt;
 	crt->givencrypt = alg->givencrypt;
 	crt->givdecrypt = alg->givdecrypt ?: no_givdecrypt;
+	crt->base = __crypto_ablkcipher_cast(tfm);
 	crt->ivsize = alg->ivsize;
 
 	return 0;
@@ -155,6 +158,11 @@ const struct crypto_type crypto_givcipher_type = {
 };
 EXPORT_SYMBOL_GPL(crypto_givcipher_type);
 
+const char *crypto_default_geniv(const struct crypto_alg *alg)
+{
+	return alg->cra_flags & CRYPTO_ALG_ASYNC ? "eseqiv" : "chainiv";
+}
+
 int crypto_grab_skcipher(struct crypto_skcipher_spawn *spawn, const char *name,
 			 u32 type, u32 mask)
 {
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 7a3e1a3..2ef5b10 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -14,8 +14,8 @@
  *
  */
 
+#include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
-#include <linux/crypto.h>
 #include <linux/errno.h>
 #include <linux/hardirq.h>
 #include <linux/kernel.h>
@@ -450,6 +450,7 @@ static int crypto_init_blkcipher_ops_async(struct crypto_tfm *tfm)
 	crt->setkey = async_setkey;
 	crt->encrypt = async_encrypt;
 	crt->decrypt = async_decrypt;
+	crt->base = __crypto_ablkcipher_cast(tfm);
 	crt->ivsize = alg->ivsize;
 
 	return 0;
@@ -509,5 +510,185 @@ const struct crypto_type crypto_blkcipher_type = {
 };
 EXPORT_SYMBOL_GPL(crypto_blkcipher_type);
 
+static int crypto_grab_nivcipher(struct crypto_skcipher_spawn *spawn,
+				const char *name, u32 type, u32 mask)
+{
+	struct crypto_alg *alg;
+	int err;
+
+	alg = crypto_alg_mod_lookup(name, crypto_skcipher_type(type),
+				    crypto_skcipher_mask(mask) |
+				    CRYPTO_ALG_GENIV);
+	if (IS_ERR(alg))
+		return PTR_ERR(alg);
+
+	err = crypto_init_spawn(&spawn->base, alg, spawn->base.inst, mask);
+	crypto_mod_put(alg);
+	return err;
+}
+
+struct crypto_instance *skcipher_geniv_alloc(struct crypto_template *tmpl,
+					     struct rtattr **tb, u32 type,
+					     u32 mask)
+{
+	struct {
+		int (*setkey)(struct crypto_ablkcipher *tfm, const u8 *key,
+			      unsigned int keylen);
+		int (*encrypt)(struct ablkcipher_request *req);
+		int (*decrypt)(struct ablkcipher_request *req);
+
+		unsigned int min_keysize;
+		unsigned int max_keysize;
+		unsigned int ivsize;
+
+		const char *geniv;
+	} balg;
+	const char *name;
+	struct crypto_skcipher_spawn *spawn;
+	struct crypto_attr_type *algt;
+	struct crypto_instance *inst;
+	struct crypto_alg *alg;
+	int err;
+
+	algt = crypto_get_attr_type(tb);
+	err = PTR_ERR(algt);
+	if (IS_ERR(algt))
+		return ERR_PTR(err);
+
+	if ((algt->type ^ (CRYPTO_ALG_TYPE_GIVCIPHER | CRYPTO_ALG_GENIV)) &
+	    algt->mask)
+		return ERR_PTR(-EINVAL);
+
+	name = crypto_attr_alg_name(tb[1]);
+	err = PTR_ERR(name);
+	if (IS_ERR(name))
+		return ERR_PTR(err);
+
+	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
+	if (!inst)
+		return ERR_PTR(-ENOMEM);
+
+	spawn = crypto_instance_ctx(inst);
+
+	/* Ignore async algorithms if necessary. */
+	mask |= (algt->type ^ CRYPTO_ALG_ASYNC) & algt->mask;
+
+	crypto_set_skcipher_spawn(spawn, inst);
+	err = crypto_grab_nivcipher(spawn, name, type, mask);
+	if (err)
+		goto err_free_inst;
+
+	alg = crypto_skcipher_spawn_alg(spawn);
+
+	if ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
+	    CRYPTO_ALG_TYPE_BLKCIPHER) {
+		balg.ivsize = alg->cra_blkcipher.ivsize;
+		balg.min_keysize = alg->cra_blkcipher.min_keysize;
+		balg.max_keysize = alg->cra_blkcipher.max_keysize;
+
+		balg.setkey = async_setkey;
+		balg.encrypt = async_encrypt;
+		balg.decrypt = async_decrypt;
+
+		balg.geniv = alg->cra_blkcipher.geniv;
+	} else {
+		balg.ivsize = alg->cra_ablkcipher.ivsize;
+		balg.min_keysize = alg->cra_ablkcipher.min_keysize;
+		balg.max_keysize = alg->cra_ablkcipher.max_keysize;
+
+		balg.setkey = alg->cra_ablkcipher.setkey;
+		balg.encrypt = alg->cra_ablkcipher.encrypt;
+		balg.decrypt = alg->cra_ablkcipher.decrypt;
+
+		balg.geniv = alg->cra_ablkcipher.geniv;
+	}
+
+	err = -EAGAIN;
+	if (!balg.ivsize)
+		goto err_drop_alg;
+
+	/*
+	 * This is only true if we're constructing an algorithm with its
+	 * default IV generator.  For the default generator we elide the
+	 * template name and double-check the IV generator.
+	 */
+	if (algt->mask & CRYPTO_ALG_GENIV) {
+		if (!balg.geniv)
+			balg.geniv = crypto_default_geniv(alg);
+		if (strcmp(tmpl->name, balg.geniv))
+			goto err_drop_alg;
+
+		memcpy(inst->alg.cra_name, alg->cra_name, CRYPTO_MAX_ALG_NAME);
+		memcpy(inst->alg.cra_driver_name, alg->cra_driver_name,
+		       CRYPTO_MAX_ALG_NAME);
+	} else {
+		err = -ENAMETOOLONG;
+		if (snprintf(inst->alg.cra_name, CRYPTO_MAX_ALG_NAME,
+			     "%s(%s)", tmpl->name, alg->cra_name) >=
+		    CRYPTO_MAX_ALG_NAME)
+			goto err_drop_alg;
+		if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
+			     "%s(%s)", tmpl->name, alg->cra_driver_name) >=
+		    CRYPTO_MAX_ALG_NAME)
+			goto err_drop_alg;
+	}
+
+	inst->alg.cra_flags = CRYPTO_ALG_TYPE_GIVCIPHER | CRYPTO_ALG_GENIV;
+	inst->alg.cra_flags |= alg->cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.cra_priority = alg->cra_priority;
+	inst->alg.cra_blocksize = alg->cra_blocksize;
+	inst->alg.cra_alignmask = alg->cra_alignmask;
+	inst->alg.cra_type = &crypto_givcipher_type;
+
+	inst->alg.cra_ablkcipher.ivsize = balg.ivsize;
+	inst->alg.cra_ablkcipher.min_keysize = balg.min_keysize;
+	inst->alg.cra_ablkcipher.max_keysize = balg.max_keysize;
+	inst->alg.cra_ablkcipher.geniv = balg.geniv;
+
+	inst->alg.cra_ablkcipher.setkey = balg.setkey;
+	inst->alg.cra_ablkcipher.encrypt = balg.encrypt;
+	inst->alg.cra_ablkcipher.decrypt = balg.decrypt;
+
+out:
+	return inst;
+
+err_drop_alg:
+	crypto_drop_skcipher(spawn);
+err_free_inst:
+	kfree(inst);
+	inst = ERR_PTR(err);
+	goto out;
+}
+EXPORT_SYMBOL_GPL(skcipher_geniv_alloc);
+
+void skcipher_geniv_free(struct crypto_instance *inst)
+{
+	crypto_drop_skcipher(crypto_instance_ctx(inst));
+	kfree(inst);
+}
+EXPORT_SYMBOL_GPL(skcipher_geniv_free);
+
+int skcipher_geniv_init(struct crypto_tfm *tfm)
+{
+	struct crypto_instance *inst = (void *)tfm->__crt_alg;
+	struct crypto_ablkcipher *cipher;
+
+	cipher = crypto_spawn_skcipher(crypto_instance_ctx(inst));
+	if (IS_ERR(cipher))
+		return PTR_ERR(cipher);
+
+	tfm->crt_ablkcipher.base = cipher;
+	tfm->crt_ablkcipher.reqsize += crypto_ablkcipher_reqsize(cipher);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(skcipher_geniv_init);
+
+void skcipher_geniv_exit(struct crypto_tfm *tfm)
+{
+	crypto_free_ablkcipher(tfm->crt_ablkcipher.base);
+}
+EXPORT_SYMBOL_GPL(skcipher_geniv_exit);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Generic block chaining cipher type");
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index c9402dd..07e7c82 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -15,6 +15,9 @@
 
 #include <crypto/algapi.h>
 #include <crypto/skcipher.h>
+#include <linux/types.h>
+
+struct rtattr;
 
 struct crypto_skcipher_spawn {
 	struct crypto_spawn base;
@@ -50,6 +53,21 @@ static inline struct crypto_ablkcipher *crypto_spawn_skcipher(
 				 crypto_skcipher_mask(0)));
 }
 
+const char *crypto_default_geniv(const struct crypto_alg *alg);
+
+struct crypto_instance *skcipher_geniv_alloc(struct crypto_template *tmpl,
+					     struct rtattr **tb, u32 type,
+					     u32 mask);
+void skcipher_geniv_free(struct crypto_instance *inst);
+int skcipher_geniv_init(struct crypto_tfm *tfm);
+void skcipher_geniv_exit(struct crypto_tfm *tfm);
+
+static inline struct crypto_ablkcipher *skcipher_geniv_cipher(
+	struct crypto_ablkcipher *geniv)
+{
+	return crypto_ablkcipher_crt(geniv)->base;
+}
+
 static inline void *skcipher_givcrypt_reqctx(
 	struct skcipher_givcrypt_request *req)
 {
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index facafa1..fa7afa9 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -53,6 +53,12 @@
 #define CRYPTO_ALG_NEED_FALLBACK	0x00000100
 
 /*
+ * This bit is set for symmetric key ciphers that have already been wrapped
+ * with a generic IV generator to prevent them from being wrapped again.
+ */
+#define CRYPTO_ALG_GENIV		0x00000200
+
+/*
  * Transform masks and values (for crt_flags).
  */
 #define CRYPTO_TFM_REQ_MASK		0x000fff00
@@ -331,6 +337,8 @@ struct ablkcipher_tfm {
 	int (*givencrypt)(struct skcipher_givcrypt_request *req);
 	int (*givdecrypt)(struct skcipher_givcrypt_request *req);
 
+	struct crypto_ablkcipher *base;
+
 	unsigned int ivsize;
 	unsigned int reqsize;
 };
@@ -541,14 +549,14 @@ static inline struct crypto_ablkcipher *__crypto_ablkcipher_cast(
 
 static inline u32 crypto_skcipher_type(u32 type)
 {
-	type &= ~CRYPTO_ALG_TYPE_MASK;
+	type &= ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV);
 	type |= CRYPTO_ALG_TYPE_BLKCIPHER;
 	return type;
 }
 
 static inline u32 crypto_skcipher_mask(u32 mask)
 {
-	mask &= ~CRYPTO_ALG_TYPE_MASK;
+	mask &= ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV);
 	mask |= CRYPTO_ALG_TYPE_BLKCIPHER_MASK;
 	return mask;
 }
@@ -623,7 +631,9 @@ static inline void crypto_ablkcipher_clear_flags(struct crypto_ablkcipher *tfm,
 static inline int crypto_ablkcipher_setkey(struct crypto_ablkcipher *tfm,
 					   const u8 *key, unsigned int keylen)
 {
-	return crypto_ablkcipher_crt(tfm)->setkey(tfm, key, keylen);
+	struct ablkcipher_tfm *crt = crypto_ablkcipher_crt(tfm);
+
+	return crt->setkey(crt->base, key, keylen);
 }
 
 static inline struct crypto_ablkcipher *crypto_ablkcipher_reqtfm(
@@ -655,7 +665,7 @@ static inline unsigned int crypto_ablkcipher_reqsize(
 static inline void ablkcipher_request_set_tfm(
 	struct ablkcipher_request *req, struct crypto_ablkcipher *tfm)
 {
-	req->base.tfm = crypto_ablkcipher_tfm(tfm);
+	req->base.tfm = crypto_ablkcipher_tfm(crypto_ablkcipher_crt(tfm)->base);
 }
 
 static inline struct ablkcipher_request *ablkcipher_request_cast(
