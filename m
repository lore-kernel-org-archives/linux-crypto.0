From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 24/24] crypto: aead - Convert top level interface to new style
Date: Mon, 11 May 2015 17:48:12 +0800
Message-ID: <E1YrkJo-0001Gr-F8@gondolin.me.apana.org.au>
References: <20150511094444.GA4260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51514 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbbEKJsT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 05:48:19 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YrkJp-0000NB-FV
	for <linux-crypto@vger.kernel.org>; Mon, 11 May 2015 19:48:13 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts the top-level aead interface to the new style.
All user-level AEAD interface code have been moved into crypto/aead.h.

The allocation/free functions have switched over to the new way of
allocating tfms.

This patch also removes the double indrection on setkey so the
indirection now exists only at the alg level.

Apart from these there are no user-visible changes.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/aead.c                  |  161 ++++----------
 include/crypto/aead.h          |  436 ++++++++++++++++++++++++++++++++++++++++
 include/crypto/algapi.h        |   33 ---
 include/crypto/internal/aead.h |   38 +++
 include/linux/crypto.h         |  442 -----------------------------------------
 5 files changed, 516 insertions(+), 594 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index d6ad0c6..717b2f6 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -26,6 +26,9 @@
 
 #include "internal.h"
 
+static int aead_null_givencrypt(struct aead_givcrypt_request *req);
+static int aead_null_givdecrypt(struct aead_givcrypt_request *req);
+
 static int setkey_unaligned(struct crypto_aead *tfm, const u8 *key,
 			    unsigned int keylen)
 {
@@ -48,63 +51,63 @@ static int setkey_unaligned(struct crypto_aead *tfm, const u8 *key,
 	return ret;
 }
 
-static int setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
+int crypto_aead_setkey(struct crypto_aead *tfm,
+		       const u8 *key, unsigned int keylen)
 {
 	struct aead_alg *aead = crypto_aead_alg(tfm);
 	unsigned long alignmask = crypto_aead_alignmask(tfm);
 
+	tfm = tfm->child;
+
 	if ((unsigned long)key & alignmask)
 		return setkey_unaligned(tfm, key, keylen);
 
 	return aead->setkey(tfm, key, keylen);
 }
+EXPORT_SYMBOL_GPL(crypto_aead_setkey);
 
 int crypto_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
 {
-	struct aead_tfm *crt = crypto_aead_crt(tfm);
 	int err;
 
 	if (authsize > crypto_aead_alg(tfm)->maxauthsize)
 		return -EINVAL;
 
 	if (crypto_aead_alg(tfm)->setauthsize) {
-		err = crypto_aead_alg(tfm)->setauthsize(crt->base, authsize);
+		err = crypto_aead_alg(tfm)->setauthsize(tfm->child, authsize);
 		if (err)
 			return err;
 	}
 
-	crypto_aead_crt(crt->base)->authsize = authsize;
-	crt->authsize = authsize;
+	tfm->child->authsize = authsize;
+	tfm->authsize = authsize;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(crypto_aead_setauthsize);
 
-static unsigned int crypto_aead_ctxsize(struct crypto_alg *alg, u32 type,
-					u32 mask)
-{
-	return alg->cra_ctxsize;
-}
-
 static int no_givcrypt(struct aead_givcrypt_request *req)
 {
 	return -ENOSYS;
 }
 
-static int crypto_init_aead_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
+static int crypto_aead_init_tfm(struct crypto_tfm *tfm)
 {
 	struct aead_alg *alg = &tfm->__crt_alg->cra_aead;
-	struct aead_tfm *crt = &tfm->crt_aead;
+	struct crypto_aead *crt = __crypto_aead_cast(tfm);
 
 	if (max(alg->maxauthsize, alg->ivsize) > PAGE_SIZE / 8)
 		return -EINVAL;
 
-	crt->setkey = tfm->__crt_alg->cra_flags & CRYPTO_ALG_GENIV ?
-		      alg->setkey : setkey;
 	crt->encrypt = alg->encrypt;
 	crt->decrypt = alg->decrypt;
-	crt->givencrypt = alg->givencrypt ?: no_givcrypt;
-	crt->givdecrypt = alg->givdecrypt ?: no_givcrypt;
-	crt->base = __crypto_aead_cast(tfm);
+	if (alg->ivsize) {
+		crt->givencrypt = alg->givencrypt ?: no_givcrypt;
+		crt->givdecrypt = alg->givdecrypt ?: no_givcrypt;
+	} else {
+		crt->givencrypt = aead_null_givencrypt;
+		crt->givdecrypt = aead_null_givdecrypt;
+	}
+	crt->child = __crypto_aead_cast(tfm);
 	crt->ivsize = alg->ivsize;
 	crt->authsize = alg->maxauthsize;
 
@@ -155,12 +158,17 @@ static void crypto_aead_show(struct seq_file *m, struct crypto_alg *alg)
 }
 
 const struct crypto_type crypto_aead_type = {
-	.ctxsize = crypto_aead_ctxsize,
-	.init = crypto_init_aead_ops,
+	.extsize = crypto_alg_extsize,
+	.init_tfm = crypto_aead_init_tfm,
 #ifdef CONFIG_PROC_FS
 	.show = crypto_aead_show,
 #endif
 	.report = crypto_aead_report,
+	.lookup = crypto_lookup_aead,
+	.maskclear = ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV),
+	.maskset = CRYPTO_ALG_TYPE_MASK,
+	.type = CRYPTO_ALG_TYPE_AEAD,
+	.tfmsize = offsetof(struct crypto_aead, base),
 };
 EXPORT_SYMBOL_GPL(crypto_aead_type);
 
@@ -174,28 +182,6 @@ static int aead_null_givdecrypt(struct aead_givcrypt_request *req)
 	return crypto_aead_decrypt(&req->areq);
 }
 
-static int crypto_init_nivaead_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
-{
-	struct aead_alg *alg = &tfm->__crt_alg->cra_aead;
-	struct aead_tfm *crt = &tfm->crt_aead;
-
-	if (max(alg->maxauthsize, alg->ivsize) > PAGE_SIZE / 8)
-		return -EINVAL;
-
-	crt->setkey = setkey;
-	crt->encrypt = alg->encrypt;
-	crt->decrypt = alg->decrypt;
-	if (!alg->ivsize) {
-		crt->givencrypt = aead_null_givencrypt;
-		crt->givdecrypt = aead_null_givdecrypt;
-	}
-	crt->base = __crypto_aead_cast(tfm);
-	crt->ivsize = alg->ivsize;
-	crt->authsize = alg->maxauthsize;
-
-	return 0;
-}
-
 #ifdef CONFIG_NET
 static int crypto_nivaead_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
@@ -241,32 +227,24 @@ static void crypto_nivaead_show(struct seq_file *m, struct crypto_alg *alg)
 }
 
 const struct crypto_type crypto_nivaead_type = {
-	.ctxsize = crypto_aead_ctxsize,
-	.init = crypto_init_nivaead_ops,
+	.extsize = crypto_alg_extsize,
+	.init_tfm = crypto_aead_init_tfm,
 #ifdef CONFIG_PROC_FS
 	.show = crypto_nivaead_show,
 #endif
 	.report = crypto_nivaead_report,
+	.maskclear = ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV),
+	.maskset = CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV,
+	.type = CRYPTO_ALG_TYPE_AEAD,
+	.tfmsize = offsetof(struct crypto_aead, base),
 };
 EXPORT_SYMBOL_GPL(crypto_nivaead_type);
 
 static int crypto_grab_nivaead(struct crypto_aead_spawn *spawn,
 			       const char *name, u32 type, u32 mask)
 {
-	struct crypto_alg *alg;
-	int err;
-
-	type &= ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV);
-	type |= CRYPTO_ALG_TYPE_AEAD;
-	mask |= CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV;
-
-	alg = crypto_alg_mod_lookup(name, type, mask);
-	if (IS_ERR(alg))
-		return PTR_ERR(alg);
-
-	err = crypto_init_spawn(&spawn->base, alg, spawn->base.inst, mask);
-	crypto_mod_put(alg);
-	return err;
+	spawn->base.frontend = &crypto_nivaead_type;
+	return crypto_grab_spawn(&spawn->base, name, type, mask);
 }
 
 struct crypto_instance *aead_geniv_alloc(struct crypto_template *tmpl,
@@ -374,14 +352,17 @@ EXPORT_SYMBOL_GPL(aead_geniv_free);
 int aead_geniv_init(struct crypto_tfm *tfm)
 {
 	struct crypto_instance *inst = (void *)tfm->__crt_alg;
+	struct crypto_aead *child;
 	struct crypto_aead *aead;
 
-	aead = crypto_spawn_aead(crypto_instance_ctx(inst));
-	if (IS_ERR(aead))
-		return PTR_ERR(aead);
+	aead = __crypto_aead_cast(tfm);
 
-	tfm->crt_aead.base = aead;
-	tfm->crt_aead.reqsize += crypto_aead_reqsize(aead);
+	child = crypto_spawn_aead(crypto_instance_ctx(inst));
+	if (IS_ERR(child))
+		return PTR_ERR(child);
+
+	aead->child = child;
+	aead->reqsize += crypto_aead_reqsize(child);
 
 	return 0;
 }
@@ -389,7 +370,7 @@ EXPORT_SYMBOL_GPL(aead_geniv_init);
 
 void aead_geniv_exit(struct crypto_tfm *tfm)
 {
-	crypto_free_aead(tfm->crt_aead.base);
+	crypto_free_aead(__crypto_aead_cast(tfm)->child);
 }
 EXPORT_SYMBOL_GPL(aead_geniv_exit);
 
@@ -505,60 +486,14 @@ EXPORT_SYMBOL_GPL(crypto_lookup_aead);
 int crypto_grab_aead(struct crypto_aead_spawn *spawn, const char *name,
 		     u32 type, u32 mask)
 {
-	struct crypto_alg *alg;
-	int err;
-
-	type &= ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV);
-	type |= CRYPTO_ALG_TYPE_AEAD;
-	mask &= ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV);
-	mask |= CRYPTO_ALG_TYPE_MASK;
-
-	alg = crypto_lookup_aead(name, type, mask);
-	if (IS_ERR(alg))
-		return PTR_ERR(alg);
-
-	err = crypto_init_spawn(&spawn->base, alg, spawn->base.inst, mask);
-	crypto_mod_put(alg);
-	return err;
+	spawn->base.frontend = &crypto_aead_type;
+	return crypto_grab_spawn(&spawn->base, name, type, mask);
 }
 EXPORT_SYMBOL_GPL(crypto_grab_aead);
 
 struct crypto_aead *crypto_alloc_aead(const char *alg_name, u32 type, u32 mask)
 {
-	struct crypto_tfm *tfm;
-	int err;
-
-	type &= ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV);
-	type |= CRYPTO_ALG_TYPE_AEAD;
-	mask &= ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV);
-	mask |= CRYPTO_ALG_TYPE_MASK;
-
-	for (;;) {
-		struct crypto_alg *alg;
-
-		alg = crypto_lookup_aead(alg_name, type, mask);
-		if (IS_ERR(alg)) {
-			err = PTR_ERR(alg);
-			goto err;
-		}
-
-		tfm = __crypto_alloc_tfm(alg, type, mask);
-		if (!IS_ERR(tfm))
-			return __crypto_aead_cast(tfm);
-
-		crypto_mod_put(alg);
-		err = PTR_ERR(tfm);
-
-err:
-		if (err != -EAGAIN)
-			break;
-		if (signal_pending(current)) {
-			err = -EINTR;
-			break;
-		}
-	}
-
-	return ERR_PTR(err);
+	return crypto_alloc_tfm(alg_name, &crypto_aead_type, type, mask);
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_aead);
 
diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index 94b19be..dbcad08 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -18,6 +18,62 @@
 #include <linux/slab.h>
 
 /**
+ * DOC: Authenticated Encryption With Associated Data (AEAD) Cipher API
+ *
+ * The AEAD cipher API is used with the ciphers of type CRYPTO_ALG_TYPE_AEAD
+ * (listed as type "aead" in /proc/crypto)
+ *
+ * The most prominent examples for this type of encryption is GCM and CCM.
+ * However, the kernel supports other types of AEAD ciphers which are defined
+ * with the following cipher string:
+ *
+ *	authenc(keyed message digest, block cipher)
+ *
+ * For example: authenc(hmac(sha256), cbc(aes))
+ *
+ * The example code provided for the asynchronous block cipher operation
+ * applies here as well. Naturally all *ablkcipher* symbols must be exchanged
+ * the *aead* pendants discussed in the following. In addtion, for the AEAD
+ * operation, the aead_request_set_assoc function must be used to set the
+ * pointer to the associated data memory location before performing the
+ * encryption or decryption operation. In case of an encryption, the associated
+ * data memory is filled during the encryption operation. For decryption, the
+ * associated data memory must contain data that is used to verify the integrity
+ * of the decrypted data. Another deviation from the asynchronous block cipher
+ * operation is that the caller should explicitly check for -EBADMSG of the
+ * crypto_aead_decrypt. That error indicates an authentication error, i.e.
+ * a breach in the integrity of the message. In essence, that -EBADMSG error
+ * code is the key bonus an AEAD cipher has over "standard" block chaining
+ * modes.
+ */
+
+/**
+ *	struct aead_request - AEAD request
+ *	@base: Common attributes for async crypto requests
+ *	@assoclen: Length in bytes of associated data for authentication
+ *	@cryptlen: Length of data to be encrypted or decrypted
+ *	@iv: Initialisation vector
+ *	@assoc: Associated data
+ *	@src: Source data
+ *	@dst: Destination data
+ *	@__ctx: Start of private context data
+ */
+struct aead_request {
+	struct crypto_async_request base;
+
+	unsigned int assoclen;
+	unsigned int cryptlen;
+
+	u8 *iv;
+
+	struct scatterlist *assoc;
+	struct scatterlist *src;
+	struct scatterlist *dst;
+
+	void *__ctx[] CRYPTO_MINALIGN_ATTR;
+};
+
+/**
  *	struct aead_givcrypt_request - AEAD request with IV generation
  *	@seq: Sequence number for IV generation
  *	@giv: Space for generated IV
@@ -30,6 +86,380 @@ struct aead_givcrypt_request {
 	struct aead_request areq;
 };
 
+struct crypto_aead {
+	int (*encrypt)(struct aead_request *req);
+	int (*decrypt)(struct aead_request *req);
+	int (*givencrypt)(struct aead_givcrypt_request *req);
+	int (*givdecrypt)(struct aead_givcrypt_request *req);
+
+	struct crypto_aead *child;
+
+	unsigned int ivsize;
+	unsigned int authsize;
+	unsigned int reqsize;
+
+	struct crypto_tfm base;
+};
+
+static inline struct crypto_aead *__crypto_aead_cast(struct crypto_tfm *tfm)
+{
+	return container_of(tfm, struct crypto_aead, base);
+}
+
+/**
+ * crypto_alloc_aead() - allocate AEAD cipher handle
+ * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
+ *	     AEAD cipher
+ * @type: specifies the type of the cipher
+ * @mask: specifies the mask for the cipher
+ *
+ * Allocate a cipher handle for an AEAD. The returned struct
+ * crypto_aead is the cipher handle that is required for any subsequent
+ * API invocation for that AEAD.
+ *
+ * Return: allocated cipher handle in case of success; IS_ERR() is true in case
+ *	   of an error, PTR_ERR() returns the error code.
+ */
+struct crypto_aead *crypto_alloc_aead(const char *alg_name, u32 type, u32 mask);
+
+static inline struct crypto_tfm *crypto_aead_tfm(struct crypto_aead *tfm)
+{
+	return &tfm->base;
+}
+
+/**
+ * crypto_free_aead() - zeroize and free aead handle
+ * @tfm: cipher handle to be freed
+ */
+static inline void crypto_free_aead(struct crypto_aead *tfm)
+{
+	crypto_destroy_tfm(tfm, crypto_aead_tfm(tfm));
+}
+
+static inline struct crypto_aead *crypto_aead_crt(struct crypto_aead *tfm)
+{
+	return tfm;
+}
+
+/**
+ * crypto_aead_ivsize() - obtain IV size
+ * @tfm: cipher handle
+ *
+ * The size of the IV for the aead referenced by the cipher handle is
+ * returned. This IV size may be zero if the cipher does not need an IV.
+ *
+ * Return: IV size in bytes
+ */
+static inline unsigned int crypto_aead_ivsize(struct crypto_aead *tfm)
+{
+	return tfm->ivsize;
+}
+
+/**
+ * crypto_aead_authsize() - obtain maximum authentication data size
+ * @tfm: cipher handle
+ *
+ * The maximum size of the authentication data for the AEAD cipher referenced
+ * by the AEAD cipher handle is returned. The authentication data size may be
+ * zero if the cipher implements a hard-coded maximum.
+ *
+ * The authentication data may also be known as "tag value".
+ *
+ * Return: authentication data size / tag size in bytes
+ */
+static inline unsigned int crypto_aead_authsize(struct crypto_aead *tfm)
+{
+	return tfm->authsize;
+}
+
+/**
+ * crypto_aead_blocksize() - obtain block size of cipher
+ * @tfm: cipher handle
+ *
+ * The block size for the AEAD referenced with the cipher handle is returned.
+ * The caller may use that information to allocate appropriate memory for the
+ * data returned by the encryption or decryption operation
+ *
+ * Return: block size of cipher
+ */
+static inline unsigned int crypto_aead_blocksize(struct crypto_aead *tfm)
+{
+	return crypto_tfm_alg_blocksize(crypto_aead_tfm(tfm));
+}
+
+static inline unsigned int crypto_aead_alignmask(struct crypto_aead *tfm)
+{
+	return crypto_tfm_alg_alignmask(crypto_aead_tfm(tfm));
+}
+
+static inline u32 crypto_aead_get_flags(struct crypto_aead *tfm)
+{
+	return crypto_tfm_get_flags(crypto_aead_tfm(tfm));
+}
+
+static inline void crypto_aead_set_flags(struct crypto_aead *tfm, u32 flags)
+{
+	crypto_tfm_set_flags(crypto_aead_tfm(tfm), flags);
+}
+
+static inline void crypto_aead_clear_flags(struct crypto_aead *tfm, u32 flags)
+{
+	crypto_tfm_clear_flags(crypto_aead_tfm(tfm), flags);
+}
+
+/**
+ * crypto_aead_setkey() - set key for cipher
+ * @tfm: cipher handle
+ * @key: buffer holding the key
+ * @keylen: length of the key in bytes
+ *
+ * The caller provided key is set for the AEAD referenced by the cipher
+ * handle.
+ *
+ * Note, the key length determines the cipher type. Many block ciphers implement
+ * different cipher modes depending on the key size, such as AES-128 vs AES-192
+ * vs. AES-256. When providing a 16 byte key for an AES cipher handle, AES-128
+ * is performed.
+ *
+ * Return: 0 if the setting of the key was successful; < 0 if an error occurred
+ */
+int crypto_aead_setkey(struct crypto_aead *tfm,
+		       const u8 *key, unsigned int keylen);
+
+/**
+ * crypto_aead_setauthsize() - set authentication data size
+ * @tfm: cipher handle
+ * @authsize: size of the authentication data / tag in bytes
+ *
+ * Set the authentication data size / tag size. AEAD requires an authentication
+ * tag (or MAC) in addition to the associated data.
+ *
+ * Return: 0 if the setting of the key was successful; < 0 if an error occurred
+ */
+int crypto_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize);
+
+static inline struct crypto_aead *crypto_aead_reqtfm(struct aead_request *req)
+{
+	return __crypto_aead_cast(req->base.tfm);
+}
+
+/**
+ * crypto_aead_encrypt() - encrypt plaintext
+ * @req: reference to the aead_request handle that holds all information
+ *	 needed to perform the cipher operation
+ *
+ * Encrypt plaintext data using the aead_request handle. That data structure
+ * and how it is filled with data is discussed with the aead_request_*
+ * functions.
+ *
+ * IMPORTANT NOTE The encryption operation creates the authentication data /
+ *		  tag. That data is concatenated with the created ciphertext.
+ *		  The ciphertext memory size is therefore the given number of
+ *		  block cipher blocks + the size defined by the
+ *		  crypto_aead_setauthsize invocation. The caller must ensure
+ *		  that sufficient memory is available for the ciphertext and
+ *		  the authentication tag.
+ *
+ * Return: 0 if the cipher operation was successful; < 0 if an error occurred
+ */
+static inline int crypto_aead_encrypt(struct aead_request *req)
+{
+	return crypto_aead_reqtfm(req)->encrypt(req);
+}
+
+/**
+ * crypto_aead_decrypt() - decrypt ciphertext
+ * @req: reference to the ablkcipher_request handle that holds all information
+ *	 needed to perform the cipher operation
+ *
+ * Decrypt ciphertext data using the aead_request handle. That data structure
+ * and how it is filled with data is discussed with the aead_request_*
+ * functions.
+ *
+ * IMPORTANT NOTE The caller must concatenate the ciphertext followed by the
+ *		  authentication data / tag. That authentication data / tag
+ *		  must have the size defined by the crypto_aead_setauthsize
+ *		  invocation.
+ *
+ *
+ * Return: 0 if the cipher operation was successful; -EBADMSG: The AEAD
+ *	   cipher operation performs the authentication of the data during the
+ *	   decryption operation. Therefore, the function returns this error if
+ *	   the authentication of the ciphertext was unsuccessful (i.e. the
+ *	   integrity of the ciphertext or the associated data was violated);
+ *	   < 0 if an error occurred.
+ */
+static inline int crypto_aead_decrypt(struct aead_request *req)
+{
+	if (req->cryptlen < crypto_aead_authsize(crypto_aead_reqtfm(req)))
+		return -EINVAL;
+
+	return crypto_aead_reqtfm(req)->decrypt(req);
+}
+
+/**
+ * DOC: Asynchronous AEAD Request Handle
+ *
+ * The aead_request data structure contains all pointers to data required for
+ * the AEAD cipher operation. This includes the cipher handle (which can be
+ * used by multiple aead_request instances), pointer to plaintext and
+ * ciphertext, asynchronous callback function, etc. It acts as a handle to the
+ * aead_request_* API calls in a similar way as AEAD handle to the
+ * crypto_aead_* API calls.
+ */
+
+/**
+ * crypto_aead_reqsize() - obtain size of the request data structure
+ * @tfm: cipher handle
+ *
+ * Return: number of bytes
+ */
+static inline unsigned int crypto_aead_reqsize(struct crypto_aead *tfm)
+{
+	return tfm->reqsize;
+}
+
+/**
+ * aead_request_set_tfm() - update cipher handle reference in request
+ * @req: request handle to be modified
+ * @tfm: cipher handle that shall be added to the request handle
+ *
+ * Allow the caller to replace the existing aead handle in the request
+ * data structure with a different one.
+ */
+static inline void aead_request_set_tfm(struct aead_request *req,
+					struct crypto_aead *tfm)
+{
+	req->base.tfm = crypto_aead_tfm(tfm->child);
+}
+
+/**
+ * aead_request_alloc() - allocate request data structure
+ * @tfm: cipher handle to be registered with the request
+ * @gfp: memory allocation flag that is handed to kmalloc by the API call.
+ *
+ * Allocate the request data structure that must be used with the AEAD
+ * encrypt and decrypt API calls. During the allocation, the provided aead
+ * handle is registered in the request data structure.
+ *
+ * Return: allocated request handle in case of success; IS_ERR() is true in case
+ *	   of an error, PTR_ERR() returns the error code.
+ */
+static inline struct aead_request *aead_request_alloc(struct crypto_aead *tfm,
+						      gfp_t gfp)
+{
+	struct aead_request *req;
+
+	req = kmalloc(sizeof(*req) + crypto_aead_reqsize(tfm), gfp);
+
+	if (likely(req))
+		aead_request_set_tfm(req, tfm);
+
+	return req;
+}
+
+/**
+ * aead_request_free() - zeroize and free request data structure
+ * @req: request data structure cipher handle to be freed
+ */
+static inline void aead_request_free(struct aead_request *req)
+{
+	kzfree(req);
+}
+
+/**
+ * aead_request_set_callback() - set asynchronous callback function
+ * @req: request handle
+ * @flags: specify zero or an ORing of the flags
+ *	   CRYPTO_TFM_REQ_MAY_BACKLOG the request queue may back log and
+ *	   increase the wait queue beyond the initial maximum size;
+ *	   CRYPTO_TFM_REQ_MAY_SLEEP the request processing may sleep
+ * @compl: callback function pointer to be registered with the request handle
+ * @data: The data pointer refers to memory that is not used by the kernel
+ *	  crypto API, but provided to the callback function for it to use. Here,
+ *	  the caller can provide a reference to memory the callback function can
+ *	  operate on. As the callback function is invoked asynchronously to the
+ *	  related functionality, it may need to access data structures of the
+ *	  related functionality which can be referenced using this pointer. The
+ *	  callback function can access the memory via the "data" field in the
+ *	  crypto_async_request data structure provided to the callback function.
+ *
+ * Setting the callback function that is triggered once the cipher operation
+ * completes
+ *
+ * The callback function is registered with the aead_request handle and
+ * must comply with the following template
+ *
+ *	void callback_function(struct crypto_async_request *req, int error)
+ */
+static inline void aead_request_set_callback(struct aead_request *req,
+					     u32 flags,
+					     crypto_completion_t compl,
+					     void *data)
+{
+	req->base.complete = compl;
+	req->base.data = data;
+	req->base.flags = flags;
+}
+
+/**
+ * aead_request_set_crypt - set data buffers
+ * @req: request handle
+ * @src: source scatter / gather list
+ * @dst: destination scatter / gather list
+ * @cryptlen: number of bytes to process from @src
+ * @iv: IV for the cipher operation which must comply with the IV size defined
+ *      by crypto_aead_ivsize()
+ *
+ * Setting the source data and destination data scatter / gather lists.
+ *
+ * For encryption, the source is treated as the plaintext and the
+ * destination is the ciphertext. For a decryption operation, the use is
+ * reversed - the source is the ciphertext and the destination is the plaintext.
+ *
+ * IMPORTANT NOTE AEAD requires an authentication tag (MAC). For decryption,
+ *		  the caller must concatenate the ciphertext followed by the
+ *		  authentication tag and provide the entire data stream to the
+ *		  decryption operation (i.e. the data length used for the
+ *		  initialization of the scatterlist and the data length for the
+ *		  decryption operation is identical). For encryption, however,
+ *		  the authentication tag is created while encrypting the data.
+ *		  The destination buffer must hold sufficient space for the
+ *		  ciphertext and the authentication tag while the encryption
+ *		  invocation must only point to the plaintext data size. The
+ *		  following code snippet illustrates the memory usage
+ *		  buffer = kmalloc(ptbuflen + (enc ? authsize : 0));
+ *		  sg_init_one(&sg, buffer, ptbuflen + (enc ? authsize : 0));
+ *		  aead_request_set_crypt(req, &sg, &sg, ptbuflen, iv);
+ */
+static inline void aead_request_set_crypt(struct aead_request *req,
+					  struct scatterlist *src,
+					  struct scatterlist *dst,
+					  unsigned int cryptlen, u8 *iv)
+{
+	req->src = src;
+	req->dst = dst;
+	req->cryptlen = cryptlen;
+	req->iv = iv;
+}
+
+/**
+ * aead_request_set_assoc() - set the associated data scatter / gather list
+ * @req: request handle
+ * @assoc: associated data scatter / gather list
+ * @assoclen: number of bytes to process from @assoc
+ *
+ * For encryption, the memory is filled with the associated data. For
+ * decryption, the memory must point to the associated data.
+ */
+static inline void aead_request_set_assoc(struct aead_request *req,
+					  struct scatterlist *assoc,
+					  unsigned int assoclen)
+{
+	req->assoc = assoc;
+	req->assoclen = assoclen;
+}
+
 static inline struct crypto_aead *aead_givcrypt_reqtfm(
 	struct aead_givcrypt_request *req)
 {
@@ -38,14 +468,12 @@ static inline struct crypto_aead *aead_givcrypt_reqtfm(
 
 static inline int crypto_aead_givencrypt(struct aead_givcrypt_request *req)
 {
-	struct aead_tfm *crt = crypto_aead_crt(aead_givcrypt_reqtfm(req));
-	return crt->givencrypt(req);
+	return aead_givcrypt_reqtfm(req)->givencrypt(req);
 };
 
 static inline int crypto_aead_givdecrypt(struct aead_givcrypt_request *req)
 {
-	struct aead_tfm *crt = crypto_aead_crt(aead_givcrypt_reqtfm(req));
-	return crt->givdecrypt(req);
+	return aead_givcrypt_reqtfm(req)->givdecrypt(req);
 };
 
 static inline void aead_givcrypt_set_tfm(struct aead_givcrypt_request *req,
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index a949bf7..d4ebf6e 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -17,6 +17,7 @@
 #include <linux/kernel.h>
 #include <linux/skbuff.h>
 
+struct crypto_aead;
 struct module;
 struct rtattr;
 struct seq_file;
@@ -126,7 +127,6 @@ struct ablkcipher_walk {
 };
 
 extern const struct crypto_type crypto_ablkcipher_type;
-extern const struct crypto_type crypto_aead_type;
 extern const struct crypto_type crypto_blkcipher_type;
 
 void crypto_mod_put(struct crypto_alg *alg);
@@ -241,22 +241,6 @@ static inline void *crypto_ablkcipher_ctx_aligned(struct crypto_ablkcipher *tfm)
 	return crypto_tfm_ctx_aligned(&tfm->base);
 }
 
-static inline struct aead_alg *crypto_aead_alg(struct crypto_aead *tfm)
-{
-	return &crypto_aead_tfm(tfm)->__crt_alg->cra_aead;
-}
-
-static inline void *crypto_aead_ctx(struct crypto_aead *tfm)
-{
-	return crypto_tfm_ctx(&tfm->base);
-}
-
-static inline struct crypto_instance *crypto_aead_alg_instance(
-	struct crypto_aead *aead)
-{
-	return crypto_tfm_alg_instance(&aead->base);
-}
-
 static inline struct crypto_blkcipher *crypto_spawn_blkcipher(
 	struct crypto_spawn *spawn)
 {
@@ -365,21 +349,6 @@ static inline int ablkcipher_tfm_in_queue(struct crypto_queue *queue,
 	return crypto_tfm_in_queue(queue, crypto_ablkcipher_tfm(tfm));
 }
 
-static inline void *aead_request_ctx(struct aead_request *req)
-{
-	return req->__ctx;
-}
-
-static inline void aead_request_complete(struct aead_request *req, int err)
-{
-	req->base.complete(&req->base, err);
-}
-
-static inline u32 aead_request_flags(struct aead_request *req)
-{
-	return req->base.flags;
-}
-
 static inline struct crypto_alg *crypto_get_attr_alg(struct rtattr **tb,
 						     u32 type, u32 mask)
 {
diff --git a/include/crypto/internal/aead.h b/include/crypto/internal/aead.h
index 750948c..a2d104a 100644
--- a/include/crypto/internal/aead.h
+++ b/include/crypto/internal/aead.h
@@ -23,8 +23,40 @@ struct crypto_aead_spawn {
 	struct crypto_spawn base;
 };
 
+extern const struct crypto_type crypto_aead_type;
 extern const struct crypto_type crypto_nivaead_type;
 
+static inline struct aead_alg *crypto_aead_alg(struct crypto_aead *tfm)
+{
+	return &crypto_aead_tfm(tfm)->__crt_alg->cra_aead;
+}
+
+static inline void *crypto_aead_ctx(struct crypto_aead *tfm)
+{
+	return crypto_tfm_ctx(&tfm->base);
+}
+
+static inline struct crypto_instance *crypto_aead_alg_instance(
+	struct crypto_aead *aead)
+{
+	return crypto_tfm_alg_instance(&aead->base);
+}
+
+static inline void *aead_request_ctx(struct aead_request *req)
+{
+	return req->__ctx;
+}
+
+static inline void aead_request_complete(struct aead_request *req, int err)
+{
+	req->base.complete(&req->base, err);
+}
+
+static inline u32 aead_request_flags(struct aead_request *req)
+{
+	return req->base.flags;
+}
+
 static inline void crypto_set_aead_spawn(
 	struct crypto_aead_spawn *spawn, struct crypto_instance *inst)
 {
@@ -50,9 +82,7 @@ static inline struct crypto_alg *crypto_aead_spawn_alg(
 static inline struct crypto_aead *crypto_spawn_aead(
 	struct crypto_aead_spawn *spawn)
 {
-	return __crypto_aead_cast(
-		crypto_spawn_tfm(&spawn->base, CRYPTO_ALG_TYPE_AEAD,
-				 CRYPTO_ALG_TYPE_MASK));
+	return crypto_spawn_tfm2(&spawn->base);
 }
 
 struct crypto_instance *aead_geniv_alloc(struct crypto_template *tmpl,
@@ -64,7 +94,7 @@ void aead_geniv_exit(struct crypto_tfm *tfm);
 
 static inline struct crypto_aead *aead_geniv_base(struct crypto_aead *geniv)
 {
-	return crypto_aead_crt(geniv)->base;
+	return geniv->child;
 }
 
 static inline void *aead_givcrypt_reqctx(struct aead_givcrypt_request *req)
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index ee14140..59ca408 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -140,6 +140,7 @@ struct crypto_blkcipher;
 struct crypto_hash;
 struct crypto_tfm;
 struct crypto_type;
+struct aead_request;
 struct aead_givcrypt_request;
 struct skcipher_givcrypt_request;
 
@@ -174,32 +175,6 @@ struct ablkcipher_request {
 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
 };
 
-/**
- *	struct aead_request - AEAD request
- *	@base: Common attributes for async crypto requests
- *	@assoclen: Length in bytes of associated data for authentication
- *	@cryptlen: Length of data to be encrypted or decrypted
- *	@iv: Initialisation vector
- *	@assoc: Associated data
- *	@src: Source data
- *	@dst: Destination data
- *	@__ctx: Start of private context data
- */
-struct aead_request {
-	struct crypto_async_request base;
-
-	unsigned int assoclen;
-	unsigned int cryptlen;
-
-	u8 *iv;
-
-	struct scatterlist *assoc;
-	struct scatterlist *src;
-	struct scatterlist *dst;
-
-	void *__ctx[] CRYPTO_MINALIGN_ATTR;
-};
-
 struct blkcipher_desc {
 	struct crypto_blkcipher *tfm;
 	void *info;
@@ -572,21 +547,6 @@ struct ablkcipher_tfm {
 	unsigned int reqsize;
 };
 
-struct aead_tfm {
-	int (*setkey)(struct crypto_aead *tfm, const u8 *key,
-	              unsigned int keylen);
-	int (*encrypt)(struct aead_request *req);
-	int (*decrypt)(struct aead_request *req);
-	int (*givencrypt)(struct aead_givcrypt_request *req);
-	int (*givdecrypt)(struct aead_givcrypt_request *req);
-
-	struct crypto_aead *base;
-
-	unsigned int ivsize;
-	unsigned int authsize;
-	unsigned int reqsize;
-};
-
 struct blkcipher_tfm {
 	void *iv;
 	int (*setkey)(struct crypto_tfm *tfm, const u8 *key,
@@ -626,7 +586,6 @@ struct compress_tfm {
 };
 
 #define crt_ablkcipher	crt_u.ablkcipher
-#define crt_aead	crt_u.aead
 #define crt_blkcipher	crt_u.blkcipher
 #define crt_cipher	crt_u.cipher
 #define crt_hash	crt_u.hash
@@ -638,7 +597,6 @@ struct crypto_tfm {
 	
 	union {
 		struct ablkcipher_tfm ablkcipher;
-		struct aead_tfm aead;
 		struct blkcipher_tfm blkcipher;
 		struct cipher_tfm cipher;
 		struct hash_tfm hash;
@@ -656,10 +614,6 @@ struct crypto_ablkcipher {
 	struct crypto_tfm base;
 };
 
-struct crypto_aead {
-	struct crypto_tfm base;
-};
-
 struct crypto_blkcipher {
 	struct crypto_tfm base;
 };
@@ -1152,400 +1106,6 @@ static inline void ablkcipher_request_set_crypt(
 }
 
 /**
- * DOC: Authenticated Encryption With Associated Data (AEAD) Cipher API
- *
- * The AEAD cipher API is used with the ciphers of type CRYPTO_ALG_TYPE_AEAD
- * (listed as type "aead" in /proc/crypto)
- *
- * The most prominent examples for this type of encryption is GCM and CCM.
- * However, the kernel supports other types of AEAD ciphers which are defined
- * with the following cipher string:
- *
- *	authenc(keyed message digest, block cipher)
- *
- * For example: authenc(hmac(sha256), cbc(aes))
- *
- * The example code provided for the asynchronous block cipher operation
- * applies here as well. Naturally all *ablkcipher* symbols must be exchanged
- * the *aead* pendants discussed in the following. In addtion, for the AEAD
- * operation, the aead_request_set_assoc function must be used to set the
- * pointer to the associated data memory location before performing the
- * encryption or decryption operation. In case of an encryption, the associated
- * data memory is filled during the encryption operation. For decryption, the
- * associated data memory must contain data that is used to verify the integrity
- * of the decrypted data. Another deviation from the asynchronous block cipher
- * operation is that the caller should explicitly check for -EBADMSG of the
- * crypto_aead_decrypt. That error indicates an authentication error, i.e.
- * a breach in the integrity of the message. In essence, that -EBADMSG error
- * code is the key bonus an AEAD cipher has over "standard" block chaining
- * modes.
- */
-
-static inline struct crypto_aead *__crypto_aead_cast(struct crypto_tfm *tfm)
-{
-	return (struct crypto_aead *)tfm;
-}
-
-/**
- * crypto_alloc_aead() - allocate AEAD cipher handle
- * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
- *	     AEAD cipher
- * @type: specifies the type of the cipher
- * @mask: specifies the mask for the cipher
- *
- * Allocate a cipher handle for an AEAD. The returned struct
- * crypto_aead is the cipher handle that is required for any subsequent
- * API invocation for that AEAD.
- *
- * Return: allocated cipher handle in case of success; IS_ERR() is true in case
- *	   of an error, PTR_ERR() returns the error code.
- */
-struct crypto_aead *crypto_alloc_aead(const char *alg_name, u32 type, u32 mask);
-
-static inline struct crypto_tfm *crypto_aead_tfm(struct crypto_aead *tfm)
-{
-	return &tfm->base;
-}
-
-/**
- * crypto_free_aead() - zeroize and free aead handle
- * @tfm: cipher handle to be freed
- */
-static inline void crypto_free_aead(struct crypto_aead *tfm)
-{
-	crypto_free_tfm(crypto_aead_tfm(tfm));
-}
-
-static inline struct aead_tfm *crypto_aead_crt(struct crypto_aead *tfm)
-{
-	return &crypto_aead_tfm(tfm)->crt_aead;
-}
-
-/**
- * crypto_aead_ivsize() - obtain IV size
- * @tfm: cipher handle
- *
- * The size of the IV for the aead referenced by the cipher handle is
- * returned. This IV size may be zero if the cipher does not need an IV.
- *
- * Return: IV size in bytes
- */
-static inline unsigned int crypto_aead_ivsize(struct crypto_aead *tfm)
-{
-	return crypto_aead_crt(tfm)->ivsize;
-}
-
-/**
- * crypto_aead_authsize() - obtain maximum authentication data size
- * @tfm: cipher handle
- *
- * The maximum size of the authentication data for the AEAD cipher referenced
- * by the AEAD cipher handle is returned. The authentication data size may be
- * zero if the cipher implements a hard-coded maximum.
- *
- * The authentication data may also be known as "tag value".
- *
- * Return: authentication data size / tag size in bytes
- */
-static inline unsigned int crypto_aead_authsize(struct crypto_aead *tfm)
-{
-	return crypto_aead_crt(tfm)->authsize;
-}
-
-/**
- * crypto_aead_blocksize() - obtain block size of cipher
- * @tfm: cipher handle
- *
- * The block size for the AEAD referenced with the cipher handle is returned.
- * The caller may use that information to allocate appropriate memory for the
- * data returned by the encryption or decryption operation
- *
- * Return: block size of cipher
- */
-static inline unsigned int crypto_aead_blocksize(struct crypto_aead *tfm)
-{
-	return crypto_tfm_alg_blocksize(crypto_aead_tfm(tfm));
-}
-
-static inline unsigned int crypto_aead_alignmask(struct crypto_aead *tfm)
-{
-	return crypto_tfm_alg_alignmask(crypto_aead_tfm(tfm));
-}
-
-static inline u32 crypto_aead_get_flags(struct crypto_aead *tfm)
-{
-	return crypto_tfm_get_flags(crypto_aead_tfm(tfm));
-}
-
-static inline void crypto_aead_set_flags(struct crypto_aead *tfm, u32 flags)
-{
-	crypto_tfm_set_flags(crypto_aead_tfm(tfm), flags);
-}
-
-static inline void crypto_aead_clear_flags(struct crypto_aead *tfm, u32 flags)
-{
-	crypto_tfm_clear_flags(crypto_aead_tfm(tfm), flags);
-}
-
-/**
- * crypto_aead_setkey() - set key for cipher
- * @tfm: cipher handle
- * @key: buffer holding the key
- * @keylen: length of the key in bytes
- *
- * The caller provided key is set for the AEAD referenced by the cipher
- * handle.
- *
- * Note, the key length determines the cipher type. Many block ciphers implement
- * different cipher modes depending on the key size, such as AES-128 vs AES-192
- * vs. AES-256. When providing a 16 byte key for an AES cipher handle, AES-128
- * is performed.
- *
- * Return: 0 if the setting of the key was successful; < 0 if an error occurred
- */
-static inline int crypto_aead_setkey(struct crypto_aead *tfm, const u8 *key,
-				     unsigned int keylen)
-{
-	struct aead_tfm *crt = crypto_aead_crt(tfm);
-
-	return crt->setkey(crt->base, key, keylen);
-}
-
-/**
- * crypto_aead_setauthsize() - set authentication data size
- * @tfm: cipher handle
- * @authsize: size of the authentication data / tag in bytes
- *
- * Set the authentication data size / tag size. AEAD requires an authentication
- * tag (or MAC) in addition to the associated data.
- *
- * Return: 0 if the setting of the key was successful; < 0 if an error occurred
- */
-int crypto_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize);
-
-static inline struct crypto_aead *crypto_aead_reqtfm(struct aead_request *req)
-{
-	return __crypto_aead_cast(req->base.tfm);
-}
-
-/**
- * crypto_aead_encrypt() - encrypt plaintext
- * @req: reference to the aead_request handle that holds all information
- *	 needed to perform the cipher operation
- *
- * Encrypt plaintext data using the aead_request handle. That data structure
- * and how it is filled with data is discussed with the aead_request_*
- * functions.
- *
- * IMPORTANT NOTE The encryption operation creates the authentication data /
- *		  tag. That data is concatenated with the created ciphertext.
- *		  The ciphertext memory size is therefore the given number of
- *		  block cipher blocks + the size defined by the
- *		  crypto_aead_setauthsize invocation. The caller must ensure
- *		  that sufficient memory is available for the ciphertext and
- *		  the authentication tag.
- *
- * Return: 0 if the cipher operation was successful; < 0 if an error occurred
- */
-static inline int crypto_aead_encrypt(struct aead_request *req)
-{
-	return crypto_aead_crt(crypto_aead_reqtfm(req))->encrypt(req);
-}
-
-/**
- * crypto_aead_decrypt() - decrypt ciphertext
- * @req: reference to the ablkcipher_request handle that holds all information
- *	 needed to perform the cipher operation
- *
- * Decrypt ciphertext data using the aead_request handle. That data structure
- * and how it is filled with data is discussed with the aead_request_*
- * functions.
- *
- * IMPORTANT NOTE The caller must concatenate the ciphertext followed by the
- *		  authentication data / tag. That authentication data / tag
- *		  must have the size defined by the crypto_aead_setauthsize
- *		  invocation.
- *
- *
- * Return: 0 if the cipher operation was successful; -EBADMSG: The AEAD
- *	   cipher operation performs the authentication of the data during the
- *	   decryption operation. Therefore, the function returns this error if
- *	   the authentication of the ciphertext was unsuccessful (i.e. the
- *	   integrity of the ciphertext or the associated data was violated);
- *	   < 0 if an error occurred.
- */
-static inline int crypto_aead_decrypt(struct aead_request *req)
-{
-	if (req->cryptlen < crypto_aead_authsize(crypto_aead_reqtfm(req)))
-		return -EINVAL;
-
-	return crypto_aead_crt(crypto_aead_reqtfm(req))->decrypt(req);
-}
-
-/**
- * DOC: Asynchronous AEAD Request Handle
- *
- * The aead_request data structure contains all pointers to data required for
- * the AEAD cipher operation. This includes the cipher handle (which can be
- * used by multiple aead_request instances), pointer to plaintext and
- * ciphertext, asynchronous callback function, etc. It acts as a handle to the
- * aead_request_* API calls in a similar way as AEAD handle to the
- * crypto_aead_* API calls.
- */
-
-/**
- * crypto_aead_reqsize() - obtain size of the request data structure
- * @tfm: cipher handle
- *
- * Return: number of bytes
- */
-static inline unsigned int crypto_aead_reqsize(struct crypto_aead *tfm)
-{
-	return crypto_aead_crt(tfm)->reqsize;
-}
-
-/**
- * aead_request_set_tfm() - update cipher handle reference in request
- * @req: request handle to be modified
- * @tfm: cipher handle that shall be added to the request handle
- *
- * Allow the caller to replace the existing aead handle in the request
- * data structure with a different one.
- */
-static inline void aead_request_set_tfm(struct aead_request *req,
-					struct crypto_aead *tfm)
-{
-	req->base.tfm = crypto_aead_tfm(crypto_aead_crt(tfm)->base);
-}
-
-/**
- * aead_request_alloc() - allocate request data structure
- * @tfm: cipher handle to be registered with the request
- * @gfp: memory allocation flag that is handed to kmalloc by the API call.
- *
- * Allocate the request data structure that must be used with the AEAD
- * encrypt and decrypt API calls. During the allocation, the provided aead
- * handle is registered in the request data structure.
- *
- * Return: allocated request handle in case of success; IS_ERR() is true in case
- *	   of an error, PTR_ERR() returns the error code.
- */
-static inline struct aead_request *aead_request_alloc(struct crypto_aead *tfm,
-						      gfp_t gfp)
-{
-	struct aead_request *req;
-
-	req = kmalloc(sizeof(*req) + crypto_aead_reqsize(tfm), gfp);
-
-	if (likely(req))
-		aead_request_set_tfm(req, tfm);
-
-	return req;
-}
-
-/**
- * aead_request_free() - zeroize and free request data structure
- * @req: request data structure cipher handle to be freed
- */
-static inline void aead_request_free(struct aead_request *req)
-{
-	kzfree(req);
-}
-
-/**
- * aead_request_set_callback() - set asynchronous callback function
- * @req: request handle
- * @flags: specify zero or an ORing of the flags
- *	   CRYPTO_TFM_REQ_MAY_BACKLOG the request queue may back log and
- *	   increase the wait queue beyond the initial maximum size;
- *	   CRYPTO_TFM_REQ_MAY_SLEEP the request processing may sleep
- * @compl: callback function pointer to be registered with the request handle
- * @data: The data pointer refers to memory that is not used by the kernel
- *	  crypto API, but provided to the callback function for it to use. Here,
- *	  the caller can provide a reference to memory the callback function can
- *	  operate on. As the callback function is invoked asynchronously to the
- *	  related functionality, it may need to access data structures of the
- *	  related functionality which can be referenced using this pointer. The
- *	  callback function can access the memory via the "data" field in the
- *	  crypto_async_request data structure provided to the callback function.
- *
- * Setting the callback function that is triggered once the cipher operation
- * completes
- *
- * The callback function is registered with the aead_request handle and
- * must comply with the following template
- *
- *	void callback_function(struct crypto_async_request *req, int error)
- */
-static inline void aead_request_set_callback(struct aead_request *req,
-					     u32 flags,
-					     crypto_completion_t compl,
-					     void *data)
-{
-	req->base.complete = compl;
-	req->base.data = data;
-	req->base.flags = flags;
-}
-
-/**
- * aead_request_set_crypt - set data buffers
- * @req: request handle
- * @src: source scatter / gather list
- * @dst: destination scatter / gather list
- * @cryptlen: number of bytes to process from @src
- * @iv: IV for the cipher operation which must comply with the IV size defined
- *      by crypto_aead_ivsize()
- *
- * Setting the source data and destination data scatter / gather lists.
- *
- * For encryption, the source is treated as the plaintext and the
- * destination is the ciphertext. For a decryption operation, the use is
- * reversed - the source is the ciphertext and the destination is the plaintext.
- *
- * IMPORTANT NOTE AEAD requires an authentication tag (MAC). For decryption,
- *		  the caller must concatenate the ciphertext followed by the
- *		  authentication tag and provide the entire data stream to the
- *		  decryption operation (i.e. the data length used for the
- *		  initialization of the scatterlist and the data length for the
- *		  decryption operation is identical). For encryption, however,
- *		  the authentication tag is created while encrypting the data.
- *		  The destination buffer must hold sufficient space for the
- *		  ciphertext and the authentication tag while the encryption
- *		  invocation must only point to the plaintext data size. The
- *		  following code snippet illustrates the memory usage
- *		  buffer = kmalloc(ptbuflen + (enc ? authsize : 0));
- *		  sg_init_one(&sg, buffer, ptbuflen + (enc ? authsize : 0));
- *		  aead_request_set_crypt(req, &sg, &sg, ptbuflen, iv);
- */
-static inline void aead_request_set_crypt(struct aead_request *req,
-					  struct scatterlist *src,
-					  struct scatterlist *dst,
-					  unsigned int cryptlen, u8 *iv)
-{
-	req->src = src;
-	req->dst = dst;
-	req->cryptlen = cryptlen;
-	req->iv = iv;
-}
-
-/**
- * aead_request_set_assoc() - set the associated data scatter / gather list
- * @req: request handle
- * @assoc: associated data scatter / gather list
- * @assoclen: number of bytes to process from @assoc
- *
- * For encryption, the memory is filled with the associated data. For
- * decryption, the memory must point to the associated data.
- */
-static inline void aead_request_set_assoc(struct aead_request *req,
-					  struct scatterlist *assoc,
-					  unsigned int assoclen)
-{
-	req->assoc = assoc;
-	req->assoclen = assoclen;
-}
-
-/**
  * DOC: Synchronous Block Cipher API
  *
  * The synchronous block cipher API is used with the ciphers of type
