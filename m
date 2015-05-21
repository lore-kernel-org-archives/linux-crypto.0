From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 10/16] crypto: aead - Add support for new AEAD implementations
Date: Thu, 21 May 2015 15:11:08 +0800
Message-ID: <E1YvKdI-0005fI-Qo@gondolin.me.apana.org.au>
References: <20150521070915.GA20997@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40760 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbbEUHLL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 May 2015 03:11:11 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YvKdJ-0002zD-07
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2015 17:11:09 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds the basic structure of the new AEAD type.  Unlike
the current version, there is no longer any concept of geniv.  IV
generation will still be carried out by wrappers but they will be
normal AEAD algorithms that simply take the IPsec sequence number
as the IV.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/aead.c                  |  152 ++++++++++++++++++++++++++++++++++++-----
 include/crypto/aead.h          |   44 +++++++++++
 include/crypto/internal/aead.h |   36 +++++++++
 3 files changed, 213 insertions(+), 19 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index ebc91ea..d231e28 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -33,7 +33,6 @@ static int aead_null_givdecrypt(struct aead_givcrypt_request *req);
 static int setkey_unaligned(struct crypto_aead *tfm, const u8 *key,
 			    unsigned int keylen)
 {
-	struct old_aead_alg *aead = crypto_old_aead_alg(tfm);
 	unsigned long alignmask = crypto_aead_alignmask(tfm);
 	int ret;
 	u8 *buffer, *alignbuffer;
@@ -46,7 +45,7 @@ static int setkey_unaligned(struct crypto_aead *tfm, const u8 *key,
 
 	alignbuffer = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
 	memcpy(alignbuffer, key, keylen);
-	ret = aead->setkey(tfm, alignbuffer, keylen);
+	ret = tfm->setkey(tfm, alignbuffer, keylen);
 	memset(alignbuffer, 0, keylen);
 	kfree(buffer);
 	return ret;
@@ -55,7 +54,6 @@ static int setkey_unaligned(struct crypto_aead *tfm, const u8 *key,
 int crypto_aead_setkey(struct crypto_aead *tfm,
 		       const u8 *key, unsigned int keylen)
 {
-	struct old_aead_alg *aead = crypto_old_aead_alg(tfm);
 	unsigned long alignmask = crypto_aead_alignmask(tfm);
 
 	tfm = tfm->child;
@@ -63,7 +61,7 @@ int crypto_aead_setkey(struct crypto_aead *tfm,
 	if ((unsigned long)key & alignmask)
 		return setkey_unaligned(tfm, key, keylen);
 
-	return aead->setkey(tfm, key, keylen);
+	return tfm->setkey(tfm, key, keylen);
 }
 EXPORT_SYMBOL_GPL(crypto_aead_setkey);
 
@@ -71,12 +69,11 @@ int crypto_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
 {
 	int err;
 
-	if (authsize > crypto_old_aead_alg(tfm)->maxauthsize)
+	if (authsize > tfm->maxauthsize)
 		return -EINVAL;
 
-	if (crypto_old_aead_alg(tfm)->setauthsize) {
-		err = crypto_old_aead_alg(tfm)->setauthsize(
-			tfm->child, authsize);
+	if (tfm->setauthsize) {
+		err = tfm->setauthsize(tfm->child, authsize);
 		if (err)
 			return err;
 	}
@@ -145,7 +142,7 @@ static int no_givcrypt(struct aead_givcrypt_request *req)
 	return -ENOSYS;
 }
 
-static int crypto_aead_init_tfm(struct crypto_tfm *tfm)
+static int crypto_old_aead_init_tfm(struct crypto_tfm *tfm)
 {
 	struct old_aead_alg *alg = &tfm->__crt_alg->cra_aead;
 	struct crypto_aead *crt = __crypto_aead_cast(tfm);
@@ -153,6 +150,8 @@ static int crypto_aead_init_tfm(struct crypto_tfm *tfm)
 	if (max(alg->maxauthsize, alg->ivsize) > PAGE_SIZE / 8)
 		return -EINVAL;
 
+	crt->setkey = alg->setkey;
+	crt->setauthsize = alg->setauthsize;
 	crt->encrypt = old_encrypt;
 	crt->decrypt = old_decrypt;
 	if (alg->ivsize) {
@@ -164,13 +163,34 @@ static int crypto_aead_init_tfm(struct crypto_tfm *tfm)
 	}
 	crt->child = __crypto_aead_cast(tfm);
 	crt->ivsize = alg->ivsize;
+	crt->maxauthsize = alg->maxauthsize;
 	crt->authsize = alg->maxauthsize;
 
 	return 0;
 }
 
+static int crypto_aead_init_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_aead *aead = __crypto_aead_cast(tfm);
+	struct aead_alg *alg = crypto_aead_alg(aead);
+
+	if (crypto_old_aead_alg(aead)->encrypt)
+		return crypto_old_aead_init_tfm(tfm);
+
+	aead->setkey = alg->setkey;
+	aead->setauthsize = alg->setauthsize;
+	aead->encrypt = alg->encrypt;
+	aead->decrypt = alg->decrypt;
+	aead->child = __crypto_aead_cast(tfm);
+	aead->ivsize = alg->ivsize;
+	aead->maxauthsize = alg->maxauthsize;
+	aead->authsize = alg->maxauthsize;
+
+	return 0;
+}
+
 #ifdef CONFIG_NET
-static int crypto_aead_report(struct sk_buff *skb, struct crypto_alg *alg)
+static int crypto_old_aead_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_aead raead;
 	struct old_aead_alg *aead = &alg->cra_aead;
@@ -191,15 +211,15 @@ nla_put_failure:
 	return -EMSGSIZE;
 }
 #else
-static int crypto_aead_report(struct sk_buff *skb, struct crypto_alg *alg)
+static int crypto_old_aead_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	return -ENOSYS;
 }
 #endif
 
-static void crypto_aead_show(struct seq_file *m, struct crypto_alg *alg)
+static void crypto_old_aead_show(struct seq_file *m, struct crypto_alg *alg)
 	__attribute__ ((unused));
-static void crypto_aead_show(struct seq_file *m, struct crypto_alg *alg)
+static void crypto_old_aead_show(struct seq_file *m, struct crypto_alg *alg)
 {
 	struct old_aead_alg *aead = &alg->cra_aead;
 
@@ -216,9 +236,9 @@ const struct crypto_type crypto_aead_type = {
 	.extsize = crypto_alg_extsize,
 	.init_tfm = crypto_aead_init_tfm,
 #ifdef CONFIG_PROC_FS
-	.show = crypto_aead_show,
+	.show = crypto_old_aead_show,
 #endif
-	.report = crypto_aead_report,
+	.report = crypto_old_aead_report,
 	.lookup = crypto_lookup_aead,
 	.maskclear = ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV),
 	.maskset = CRYPTO_ALG_TYPE_MASK,
@@ -227,6 +247,62 @@ const struct crypto_type crypto_aead_type = {
 };
 EXPORT_SYMBOL_GPL(crypto_aead_type);
 
+#ifdef CONFIG_NET
+static int crypto_aead_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_report_aead raead;
+	struct aead_alg *aead = container_of(alg, struct aead_alg, base);
+
+	strncpy(raead.type, "aead", sizeof(raead.type));
+	strncpy(raead.geniv, "<none>", sizeof(raead.geniv));
+
+	raead.blocksize = alg->cra_blocksize;
+	raead.maxauthsize = aead->maxauthsize;
+	raead.ivsize = aead->ivsize;
+
+	if (nla_put(skb, CRYPTOCFGA_REPORT_AEAD,
+		    sizeof(struct crypto_report_aead), &raead))
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+#else
+static int crypto_aead_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	return -ENOSYS;
+}
+#endif
+
+static void crypto_aead_show(struct seq_file *m, struct crypto_alg *alg)
+	__attribute__ ((unused));
+static void crypto_aead_show(struct seq_file *m, struct crypto_alg *alg)
+{
+	struct aead_alg *aead = container_of(alg, struct aead_alg, base);
+
+	seq_printf(m, "type         : aead\n");
+	seq_printf(m, "async        : %s\n", alg->cra_flags & CRYPTO_ALG_ASYNC ?
+					     "yes" : "no");
+	seq_printf(m, "blocksize    : %u\n", alg->cra_blocksize);
+	seq_printf(m, "ivsize       : %u\n", aead->ivsize);
+	seq_printf(m, "maxauthsize  : %u\n", aead->maxauthsize);
+	seq_printf(m, "geniv        : <none>\n");
+}
+
+static const struct crypto_type crypto_new_aead_type = {
+	.extsize = crypto_alg_extsize,
+	.init_tfm = crypto_aead_init_tfm,
+#ifdef CONFIG_PROC_FS
+	.show = crypto_aead_show,
+#endif
+	.report = crypto_aead_report,
+	.maskclear = ~CRYPTO_ALG_TYPE_MASK,
+	.maskset = CRYPTO_ALG_TYPE_MASK,
+	.type = CRYPTO_ALG_TYPE_AEAD,
+	.tfmsize = offsetof(struct crypto_aead, base),
+};
+
 static int aead_null_givencrypt(struct aead_givcrypt_request *req)
 {
 	return crypto_aead_encrypt(&req->areq);
@@ -552,5 +628,51 @@ struct crypto_aead *crypto_alloc_aead(const char *alg_name, u32 type, u32 mask)
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_aead);
 
+static int aead_prepare_alg(struct aead_alg *alg)
+{
+	struct crypto_alg *base = &alg->base;
+
+	if (max(alg->maxauthsize, alg->ivsize) > PAGE_SIZE / 8)
+		return -EINVAL;
+
+	base->cra_type = &crypto_new_aead_type;
+	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
+	base->cra_flags |= CRYPTO_ALG_TYPE_AEAD;
+
+	return 0;
+}
+
+int crypto_register_aead(struct aead_alg *alg)
+{
+	struct crypto_alg *base = &alg->base;
+	int err;
+
+	err = aead_prepare_alg(alg);
+	if (err)
+		return err;
+
+	return crypto_register_alg(base);
+}
+EXPORT_SYMBOL_GPL(crypto_register_aead);
+
+int crypto_unregister_aead(struct aead_alg *alg)
+{
+	return crypto_unregister_alg(&alg->base);
+}
+EXPORT_SYMBOL_GPL(crypto_unregister_aead);
+
+int aead_register_instance(struct crypto_template *tmpl,
+			   struct aead_instance *inst)
+{
+	int err;
+
+	err = aead_prepare_alg(&inst->alg);
+	if (err)
+		return err;
+
+	return crypto_register_instance(tmpl, aead_crypto_instance(inst));
+}
+EXPORT_SYMBOL_GPL(aead_register_instance);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Authenticated Encryption with Associated Data (AEAD)");
diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index aebf57d..177e6f4 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -17,8 +17,6 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 
-#define aead_alg old_aead_alg
-
 /**
  * DOC: Authenticated Encryption With Associated Data (AEAD) Cipher API
  *
@@ -92,7 +90,48 @@ struct aead_givcrypt_request {
 	struct aead_request areq;
 };
 
+/**
+ * struct aead_alg - AEAD cipher definition
+ * @maxauthsize: Set the maximum authentication tag size supported by the
+ *		 transformation. A transformation may support smaller tag sizes.
+ *		 As the authentication tag is a message digest to ensure the
+ *		 integrity of the encrypted data, a consumer typically wants the
+ *		 largest authentication tag possible as defined by this
+ *		 variable.
+ * @setauthsize: Set authentication size for the AEAD transformation. This
+ *		 function is used to specify the consumer requested size of the
+ * 		 authentication tag to be either generated by the transformation
+ *		 during encryption or the size of the authentication tag to be
+ *		 supplied during the decryption operation. This function is also
+ *		 responsible for checking the authentication tag size for
+ *		 validity.
+ * @setkey: see struct ablkcipher_alg
+ * @encrypt: see struct ablkcipher_alg
+ * @decrypt: see struct ablkcipher_alg
+ * @geniv: see struct ablkcipher_alg
+ * @ivsize: see struct ablkcipher_alg
+ *
+ * All fields except @ivsize is mandatory and must be filled.
+ */
+struct aead_alg {
+	int (*setkey)(struct crypto_aead *tfm, const u8 *key,
+	              unsigned int keylen);
+	int (*setauthsize)(struct crypto_aead *tfm, unsigned int authsize);
+	int (*encrypt)(struct aead_request *req);
+	int (*decrypt)(struct aead_request *req);
+
+	const char *geniv;
+
+	unsigned int ivsize;
+	unsigned int maxauthsize;
+
+	struct crypto_alg base;
+};
+
 struct crypto_aead {
+	int (*setkey)(struct crypto_aead *tfm, const u8 *key,
+	              unsigned int keylen);
+	int (*setauthsize)(struct crypto_aead *tfm, unsigned int authsize);
 	int (*encrypt)(struct aead_request *req);
 	int (*decrypt)(struct aead_request *req);
 	int (*givencrypt)(struct aead_givcrypt_request *req);
@@ -102,6 +141,7 @@ struct crypto_aead {
 
 	unsigned int ivsize;
 	unsigned int authsize;
+	unsigned int maxauthsize;
 	unsigned int reqsize;
 
 	struct crypto_tfm base;
diff --git a/include/crypto/internal/aead.h b/include/crypto/internal/aead.h
index 4614f79..6cd3151 100644
--- a/include/crypto/internal/aead.h
+++ b/include/crypto/internal/aead.h
@@ -19,6 +19,10 @@
 
 struct rtattr;
 
+struct aead_instance {
+	struct aead_alg alg;
+};
+
 struct crypto_aead_spawn {
 	struct crypto_spawn base;
 };
@@ -33,7 +37,8 @@ static inline struct old_aead_alg *crypto_old_aead_alg(struct crypto_aead *tfm)
 
 static inline struct aead_alg *crypto_aead_alg(struct crypto_aead *tfm)
 {
-	return &crypto_aead_tfm(tfm)->__crt_alg->cra_aead;
+	return container_of(crypto_aead_tfm(tfm)->__crt_alg,
+			    struct aead_alg, base);
 }
 
 static inline void *crypto_aead_ctx(struct crypto_aead *tfm)
@@ -47,6 +52,22 @@ static inline struct crypto_instance *crypto_aead_alg_instance(
 	return crypto_tfm_alg_instance(&aead->base);
 }
 
+static inline struct crypto_instance *aead_crypto_instance(
+	struct aead_instance *inst)
+{
+	return container_of(&inst->alg.base, struct crypto_instance, alg);
+}
+
+static inline struct aead_instance *aead_instance(struct crypto_instance *inst)
+{
+	return container_of(&inst->alg, struct aead_instance, alg.base);
+}
+
+static inline void *aead_instance_ctx(struct aead_instance *inst)
+{
+	return crypto_instance_ctx(aead_crypto_instance(inst));
+}
+
 static inline void *aead_request_ctx(struct aead_request *req)
 {
 	return req->__ctx;
@@ -84,6 +105,12 @@ static inline struct crypto_alg *crypto_aead_spawn_alg(
 	return spawn->base.alg;
 }
 
+static inline struct aead_alg *crypto_spawn_aead_alg(
+	struct crypto_aead_spawn *spawn)
+{
+	return container_of(spawn->base.alg, struct aead_alg, base);
+}
+
 static inline struct crypto_aead *crypto_spawn_aead(
 	struct crypto_aead_spawn *spawn)
 {
@@ -121,8 +148,13 @@ static inline void crypto_aead_set_reqsize(struct crypto_aead *aead,
 
 static inline unsigned int crypto_aead_maxauthsize(struct crypto_aead *aead)
 {
-	return crypto_old_aead_alg(aead)->maxauthsize;
+	return aead->maxauthsize;
 }
 
+int crypto_register_aead(struct aead_alg *alg);
+int crypto_unregister_aead(struct aead_alg *alg);
+int aead_register_instance(struct crypto_template *tmpl,
+			   struct aead_instance *inst);
+
 #endif	/* _CRYPTO_INTERNAL_AEAD_H */
 
