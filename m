From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6/6] crypto: hash - Remove crypto_hash interface
Date: Mon, 01 Feb 2016 21:36:54 +0800
Message-ID: <E1aQEf0-0002pv-UU@gondolin.me.apana.org.au>
References: <20160201133405.GA10754@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49561 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932274AbcBANg5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Feb 2016 08:36:57 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1aQEf1-0002Iy-2B
	for <linux-crypto@vger.kernel.org>; Tue, 02 Feb 2016 00:36:55 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch removes all traces of the crypto_hash interface, now
that everyone has switched over to shash or ahash.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 Documentation/DocBook/crypto-API.tmpl |   13 -
 crypto/ahash.c                        |   18 --
 crypto/shash.c                        |  147 -------------------
 include/crypto/algapi.h               |   18 --
 include/crypto/internal/hash.h        |    3 
 include/linux/crypto.h                |  251 ----------------------------------
 6 files changed, 450 deletions(-)

diff --git a/Documentation/DocBook/crypto-API.tmpl b/Documentation/DocBook/crypto-API.tmpl
index 07df23e..866ff08 100644
--- a/Documentation/DocBook/crypto-API.tmpl
+++ b/Documentation/DocBook/crypto-API.tmpl
@@ -1762,19 +1762,6 @@ read(opfd, out, outlen);
 !Finclude/linux/crypto.h crypto_cipher_encrypt_one
 !Finclude/linux/crypto.h crypto_cipher_decrypt_one
    </sect1>
-   <sect1><title>Synchronous Message Digest API</title>
-!Pinclude/linux/crypto.h Synchronous Message Digest API
-!Finclude/linux/crypto.h crypto_alloc_hash
-!Finclude/linux/crypto.h crypto_free_hash
-!Finclude/linux/crypto.h crypto_has_hash
-!Finclude/linux/crypto.h crypto_hash_blocksize
-!Finclude/linux/crypto.h crypto_hash_digestsize
-!Finclude/linux/crypto.h crypto_hash_init
-!Finclude/linux/crypto.h crypto_hash_update
-!Finclude/linux/crypto.h crypto_hash_final
-!Finclude/linux/crypto.h crypto_hash_digest
-!Finclude/linux/crypto.h crypto_hash_setkey
-   </sect1>
    <sect1><title>Message Digest Algorithm Definitions</title>
 !Pinclude/crypto/hash.h Message Digest Algorithm Definitions
 !Finclude/crypto/hash.h hash_alg_common
diff --git a/crypto/ahash.c b/crypto/ahash.c
index 8b08a59..5fc1f17 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -166,24 +166,6 @@ int crypto_ahash_walk_first(struct ahash_request *req,
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_walk_first);
 
-int crypto_hash_walk_first_compat(struct hash_desc *hdesc,
-				  struct crypto_hash_walk *walk,
-				  struct scatterlist *sg, unsigned int len)
-{
-	walk->total = len;
-
-	if (!walk->total) {
-		walk->entrylen = 0;
-		return 0;
-	}
-
-	walk->alignmask = crypto_hash_alignmask(hdesc->tfm);
-	walk->sg = sg;
-	walk->flags = hdesc->flags & CRYPTO_TFM_REQ_MASK;
-
-	return hash_walk_new_entry(walk);
-}
-
 static int ahash_setkey_unaligned(struct crypto_ahash *tfm, const u8 *key,
 				unsigned int keylen)
 {
diff --git a/crypto/shash.c b/crypto/shash.c
index 88a27de..472bc14 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -369,151 +369,6 @@ int crypto_init_shash_ops_async(struct crypto_tfm *tfm)
 	return 0;
 }
 
-static int shash_compat_setkey(struct crypto_hash *tfm, const u8 *key,
-			       unsigned int keylen)
-{
-	struct shash_desc **descp = crypto_hash_ctx(tfm);
-	struct shash_desc *desc = *descp;
-
-	return crypto_shash_setkey(desc->tfm, key, keylen);
-}
-
-static int shash_compat_init(struct hash_desc *hdesc)
-{
-	struct shash_desc **descp = crypto_hash_ctx(hdesc->tfm);
-	struct shash_desc *desc = *descp;
-
-	desc->flags = hdesc->flags;
-
-	return crypto_shash_init(desc);
-}
-
-static int shash_compat_update(struct hash_desc *hdesc, struct scatterlist *sg,
-			       unsigned int len)
-{
-	struct shash_desc **descp = crypto_hash_ctx(hdesc->tfm);
-	struct shash_desc *desc = *descp;
-	struct crypto_hash_walk walk;
-	int nbytes;
-
-	for (nbytes = crypto_hash_walk_first_compat(hdesc, &walk, sg, len);
-	     nbytes > 0; nbytes = crypto_hash_walk_done(&walk, nbytes))
-		nbytes = crypto_shash_update(desc, walk.data, nbytes);
-
-	return nbytes;
-}
-
-static int shash_compat_final(struct hash_desc *hdesc, u8 *out)
-{
-	struct shash_desc **descp = crypto_hash_ctx(hdesc->tfm);
-
-	return crypto_shash_final(*descp, out);
-}
-
-static int shash_compat_digest(struct hash_desc *hdesc, struct scatterlist *sg,
-			       unsigned int nbytes, u8 *out)
-{
-	unsigned int offset = sg->offset;
-	int err;
-
-	if (nbytes < min(sg->length, ((unsigned int)(PAGE_SIZE)) - offset)) {
-		struct shash_desc **descp = crypto_hash_ctx(hdesc->tfm);
-		struct shash_desc *desc = *descp;
-		void *data;
-
-		desc->flags = hdesc->flags;
-
-		data = kmap_atomic(sg_page(sg));
-		err = crypto_shash_digest(desc, data + offset, nbytes, out);
-		kunmap_atomic(data);
-		crypto_yield(desc->flags);
-		goto out;
-	}
-
-	err = shash_compat_init(hdesc);
-	if (err)
-		goto out;
-
-	err = shash_compat_update(hdesc, sg, nbytes);
-	if (err)
-		goto out;
-
-	err = shash_compat_final(hdesc, out);
-
-out:
-	return err;
-}
-
-static void crypto_exit_shash_ops_compat(struct crypto_tfm *tfm)
-{
-	struct shash_desc **descp = crypto_tfm_ctx(tfm);
-	struct shash_desc *desc = *descp;
-
-	crypto_free_shash(desc->tfm);
-	kzfree(desc);
-}
-
-static int crypto_init_shash_ops_compat(struct crypto_tfm *tfm)
-{
-	struct hash_tfm *crt = &tfm->crt_hash;
-	struct crypto_alg *calg = tfm->__crt_alg;
-	struct shash_alg *alg = __crypto_shash_alg(calg);
-	struct shash_desc **descp = crypto_tfm_ctx(tfm);
-	struct crypto_shash *shash;
-	struct shash_desc *desc;
-
-	if (!crypto_mod_get(calg))
-		return -EAGAIN;
-
-	shash = crypto_create_tfm(calg, &crypto_shash_type);
-	if (IS_ERR(shash)) {
-		crypto_mod_put(calg);
-		return PTR_ERR(shash);
-	}
-
-	desc = kmalloc(sizeof(*desc) + crypto_shash_descsize(shash),
-		       GFP_KERNEL);
-	if (!desc) {
-		crypto_free_shash(shash);
-		return -ENOMEM;
-	}
-
-	*descp = desc;
-	desc->tfm = shash;
-	tfm->exit = crypto_exit_shash_ops_compat;
-
-	crt->init = shash_compat_init;
-	crt->update = shash_compat_update;
-	crt->final  = shash_compat_final;
-	crt->digest = shash_compat_digest;
-	crt->setkey = shash_compat_setkey;
-
-	crt->digestsize = alg->digestsize;
-
-	return 0;
-}
-
-static int crypto_init_shash_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
-{
-	switch (mask & CRYPTO_ALG_TYPE_MASK) {
-	case CRYPTO_ALG_TYPE_HASH_MASK:
-		return crypto_init_shash_ops_compat(tfm);
-	}
-
-	return -EINVAL;
-}
-
-static unsigned int crypto_shash_ctxsize(struct crypto_alg *alg, u32 type,
-					 u32 mask)
-{
-	switch (mask & CRYPTO_ALG_TYPE_MASK) {
-	case CRYPTO_ALG_TYPE_HASH_MASK:
-		return sizeof(struct shash_desc *);
-	}
-
-	return 0;
-}
-
 static int crypto_shash_init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_shash *hash = __crypto_shash_cast(tfm);
@@ -560,9 +415,7 @@ static void crypto_shash_show(struct seq_file *m, struct crypto_alg *alg)
 }
 
 static const struct crypto_type crypto_shash_type = {
-	.ctxsize = crypto_shash_ctxsize,
 	.extsize = crypto_alg_extsize,
-	.init = crypto_init_shash_ops,
 	.init_tfm = crypto_shash_init_tfm,
 #ifdef CONFIG_PROC_FS
 	.show = crypto_shash_show,
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index c9fe145..f343c06 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -275,24 +275,6 @@ static inline struct cipher_alg *crypto_cipher_alg(struct crypto_cipher *tfm)
 	return &crypto_cipher_tfm(tfm)->__crt_alg->cra_cipher;
 }
 
-static inline struct crypto_hash *crypto_spawn_hash(struct crypto_spawn *spawn)
-{
-	u32 type = CRYPTO_ALG_TYPE_HASH;
-	u32 mask = CRYPTO_ALG_TYPE_HASH_MASK;
-
-	return __crypto_hash_cast(crypto_spawn_tfm(spawn, type, mask));
-}
-
-static inline void *crypto_hash_ctx(struct crypto_hash *tfm)
-{
-	return crypto_tfm_ctx(&tfm->base);
-}
-
-static inline void *crypto_hash_ctx_aligned(struct crypto_hash *tfm)
-{
-	return crypto_tfm_ctx_aligned(&tfm->base);
-}
-
 static inline void blkcipher_walk_init(struct blkcipher_walk *walk,
 				       struct scatterlist *dst,
 				       struct scatterlist *src,
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 3b4af1d..49dae16 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -57,9 +57,6 @@ int crypto_hash_walk_first(struct ahash_request *req,
 			   struct crypto_hash_walk *walk);
 int crypto_ahash_walk_first(struct ahash_request *req,
 			   struct crypto_hash_walk *walk);
-int crypto_hash_walk_first_compat(struct hash_desc *hdesc,
-				  struct crypto_hash_walk *walk,
-				  struct scatterlist *sg, unsigned int len);
 
 static inline int crypto_ahash_walk_done(struct crypto_hash_walk *walk,
 					 int err)
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index ab2a745..99c9489 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -136,7 +136,6 @@ struct scatterlist;
 struct crypto_ablkcipher;
 struct crypto_async_request;
 struct crypto_blkcipher;
-struct crypto_hash;
 struct crypto_tfm;
 struct crypto_type;
 struct skcipher_givcrypt_request;
@@ -186,11 +185,6 @@ struct cipher_desc {
 	void *info;
 };
 
-struct hash_desc {
-	struct crypto_hash *tfm;
-	u32 flags;
-};
-
 /**
  * DOC: Block Cipher Algorithm Definitions
  *
@@ -518,18 +512,6 @@ struct cipher_tfm {
 	void (*cit_decrypt_one)(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
 };
 
-struct hash_tfm {
-	int (*init)(struct hash_desc *desc);
-	int (*update)(struct hash_desc *desc,
-		      struct scatterlist *sg, unsigned int nsg);
-	int (*final)(struct hash_desc *desc, u8 *out);
-	int (*digest)(struct hash_desc *desc, struct scatterlist *sg,
-		      unsigned int nsg, u8 *out);
-	int (*setkey)(struct crypto_hash *tfm, const u8 *key,
-		      unsigned int keylen);
-	unsigned int digestsize;
-};
-
 struct compress_tfm {
 	int (*cot_compress)(struct crypto_tfm *tfm,
 	                    const u8 *src, unsigned int slen,
@@ -542,7 +524,6 @@ struct compress_tfm {
 #define crt_ablkcipher	crt_u.ablkcipher
 #define crt_blkcipher	crt_u.blkcipher
 #define crt_cipher	crt_u.cipher
-#define crt_hash	crt_u.hash
 #define crt_compress	crt_u.compress
 
 struct crypto_tfm {
@@ -553,7 +534,6 @@ struct crypto_tfm {
 		struct ablkcipher_tfm ablkcipher;
 		struct blkcipher_tfm blkcipher;
 		struct cipher_tfm cipher;
-		struct hash_tfm hash;
 		struct compress_tfm compress;
 	} crt_u;
 
@@ -580,10 +560,6 @@ struct crypto_comp {
 	struct crypto_tfm base;
 };
 
-struct crypto_hash {
-	struct crypto_tfm base;
-};
-
 enum {
 	CRYPTOA_UNSPEC,
 	CRYPTOA_ALG,
@@ -1576,233 +1552,6 @@ static inline void crypto_cipher_decrypt_one(struct crypto_cipher *tfm,
 						dst, src);
 }
 
-/**
- * DOC: Synchronous Message Digest API
- *
- * The synchronous message digest API is used with the ciphers of type
- * CRYPTO_ALG_TYPE_HASH (listed as type "hash" in /proc/crypto)
- */
-
-static inline struct crypto_hash *__crypto_hash_cast(struct crypto_tfm *tfm)
-{
-	return (struct crypto_hash *)tfm;
-}
-
-static inline struct crypto_hash *crypto_hash_cast(struct crypto_tfm *tfm)
-{
-	BUG_ON((crypto_tfm_alg_type(tfm) ^ CRYPTO_ALG_TYPE_HASH) &
-	       CRYPTO_ALG_TYPE_HASH_MASK);
-	return __crypto_hash_cast(tfm);
-}
-
-/**
- * crypto_alloc_hash() - allocate synchronous message digest handle
- * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
- *	      message digest cipher
- * @type: specifies the type of the cipher
- * @mask: specifies the mask for the cipher
- *
- * Allocate a cipher handle for a message digest. The returned struct
- * crypto_hash is the cipher handle that is required for any subsequent
- * API invocation for that message digest.
- *
- * Return: allocated cipher handle in case of success; IS_ERR() is true in case
- * of an error, PTR_ERR() returns the error code.
- */
-static inline struct crypto_hash *crypto_alloc_hash(const char *alg_name,
-						    u32 type, u32 mask)
-{
-	type &= ~CRYPTO_ALG_TYPE_MASK;
-	mask &= ~CRYPTO_ALG_TYPE_MASK;
-	type |= CRYPTO_ALG_TYPE_HASH;
-	mask |= CRYPTO_ALG_TYPE_HASH_MASK;
-
-	return __crypto_hash_cast(crypto_alloc_base(alg_name, type, mask));
-}
-
-static inline struct crypto_tfm *crypto_hash_tfm(struct crypto_hash *tfm)
-{
-	return &tfm->base;
-}
-
-/**
- * crypto_free_hash() - zeroize and free message digest handle
- * @tfm: cipher handle to be freed
- */
-static inline void crypto_free_hash(struct crypto_hash *tfm)
-{
-	crypto_free_tfm(crypto_hash_tfm(tfm));
-}
-
-/**
- * crypto_has_hash() - Search for the availability of a message digest
- * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
- *	      message digest cipher
- * @type: specifies the type of the cipher
- * @mask: specifies the mask for the cipher
- *
- * Return: true when the message digest cipher is known to the kernel crypto
- *	   API; false otherwise
- */
-static inline int crypto_has_hash(const char *alg_name, u32 type, u32 mask)
-{
-	type &= ~CRYPTO_ALG_TYPE_MASK;
-	mask &= ~CRYPTO_ALG_TYPE_MASK;
-	type |= CRYPTO_ALG_TYPE_HASH;
-	mask |= CRYPTO_ALG_TYPE_HASH_MASK;
-
-	return crypto_has_alg(alg_name, type, mask);
-}
-
-static inline struct hash_tfm *crypto_hash_crt(struct crypto_hash *tfm)
-{
-	return &crypto_hash_tfm(tfm)->crt_hash;
-}
-
-/**
- * crypto_hash_blocksize() - obtain block size for message digest
- * @tfm: cipher handle
- *
- * The block size for the message digest cipher referenced with the cipher
- * handle is returned.
- *
- * Return: block size of cipher
- */
-static inline unsigned int crypto_hash_blocksize(struct crypto_hash *tfm)
-{
-	return crypto_tfm_alg_blocksize(crypto_hash_tfm(tfm));
-}
-
-static inline unsigned int crypto_hash_alignmask(struct crypto_hash *tfm)
-{
-	return crypto_tfm_alg_alignmask(crypto_hash_tfm(tfm));
-}
-
-/**
- * crypto_hash_digestsize() - obtain message digest size
- * @tfm: cipher handle
- *
- * The size for the message digest created by the message digest cipher
- * referenced with the cipher handle is returned.
- *
- * Return: message digest size
- */
-static inline unsigned int crypto_hash_digestsize(struct crypto_hash *tfm)
-{
-	return crypto_hash_crt(tfm)->digestsize;
-}
-
-static inline u32 crypto_hash_get_flags(struct crypto_hash *tfm)
-{
-	return crypto_tfm_get_flags(crypto_hash_tfm(tfm));
-}
-
-static inline void crypto_hash_set_flags(struct crypto_hash *tfm, u32 flags)
-{
-	crypto_tfm_set_flags(crypto_hash_tfm(tfm), flags);
-}
-
-static inline void crypto_hash_clear_flags(struct crypto_hash *tfm, u32 flags)
-{
-	crypto_tfm_clear_flags(crypto_hash_tfm(tfm), flags);
-}
-
-/**
- * crypto_hash_init() - (re)initialize message digest handle
- * @desc: cipher request handle that to be filled by caller --
- *	  desc.tfm is filled with the hash cipher handle;
- *	  desc.flags is filled with either CRYPTO_TFM_REQ_MAY_SLEEP or 0.
- *
- * The call (re-)initializes the message digest referenced by the hash cipher
- * request handle. Any potentially existing state created by previous
- * operations is discarded.
- *
- * Return: 0 if the message digest initialization was successful; < 0 if an
- *	   error occurred
- */
-static inline int crypto_hash_init(struct hash_desc *desc)
-{
-	return crypto_hash_crt(desc->tfm)->init(desc);
-}
-
-/**
- * crypto_hash_update() - add data to message digest for processing
- * @desc: cipher request handle
- * @sg: scatter / gather list pointing to the data to be added to the message
- *      digest
- * @nbytes: number of bytes to be processed from @sg
- *
- * Updates the message digest state of the cipher handle pointed to by the
- * hash cipher request handle with the input data pointed to by the
- * scatter/gather list.
- *
- * Return: 0 if the message digest update was successful; < 0 if an error
- *	   occurred
- */
-static inline int crypto_hash_update(struct hash_desc *desc,
-				     struct scatterlist *sg,
-				     unsigned int nbytes)
-{
-	return crypto_hash_crt(desc->tfm)->update(desc, sg, nbytes);
-}
-
-/**
- * crypto_hash_final() - calculate message digest
- * @desc: cipher request handle
- * @out: message digest output buffer -- The caller must ensure that the out
- *	 buffer has a sufficient size (e.g. by using the crypto_hash_digestsize
- *	 function).
- *
- * Finalize the message digest operation and create the message digest
- * based on all data added to the cipher handle. The message digest is placed
- * into the output buffer.
- *
- * Return: 0 if the message digest creation was successful; < 0 if an error
- *	   occurred
- */
-static inline int crypto_hash_final(struct hash_desc *desc, u8 *out)
-{
-	return crypto_hash_crt(desc->tfm)->final(desc, out);
-}
-
-/**
- * crypto_hash_digest() - calculate message digest for a buffer
- * @desc: see crypto_hash_final()
- * @sg: see crypto_hash_update()
- * @nbytes:  see crypto_hash_update()
- * @out: see crypto_hash_final()
- *
- * This function is a "short-hand" for the function calls of crypto_hash_init,
- * crypto_hash_update and crypto_hash_final. The parameters have the same
- * meaning as discussed for those separate three functions.
- *
- * Return: 0 if the message digest creation was successful; < 0 if an error
- *	   occurred
- */
-static inline int crypto_hash_digest(struct hash_desc *desc,
-				     struct scatterlist *sg,
-				     unsigned int nbytes, u8 *out)
-{
-	return crypto_hash_crt(desc->tfm)->digest(desc, sg, nbytes, out);
-}
-
-/**
- * crypto_hash_setkey() - set key for message digest
- * @hash: cipher handle
- * @key: buffer holding the key
- * @keylen: length of the key in bytes
- *
- * The caller provided key is set for the message digest cipher. The cipher
- * handle must point to a keyed hash in order for this function to succeed.
- *
- * Return: 0 if the setting of the key was successful; < 0 if an error occurred
- */
-static inline int crypto_hash_setkey(struct crypto_hash *hash,
-				     const u8 *key, unsigned int keylen)
-{
-	return crypto_hash_crt(hash)->setkey(hash, key, keylen);
-}
-
 static inline struct crypto_comp *__crypto_comp_cast(struct crypto_tfm *tfm)
 {
 	return (struct crypto_comp *)tfm;
