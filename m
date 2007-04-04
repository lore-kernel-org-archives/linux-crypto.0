From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [1/2] [CRYPTO] api: Add async block cipher interface
Date: Wed, 4 Apr 2007 15:15:26 +1000
Message-ID: <20070404051525.GA31361@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2678 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992626AbXDDFP2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 Apr 2007 01:15:28 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1HYxqA-0001EQ-Hw
	for <linux-crypto@vger.kernel.org>; Wed, 04 Apr 2007 15:15:26 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1HYxqA-0008Aa-00
	for <linux-crypto@vger.kernel.org>; Wed, 04 Apr 2007 15:15:26 +1000
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi:

[CRYPTO] api: Add async block cipher interface

This patch adds the frontend interface for asynchronous block ciphers.
In addition to the usual block cipher parameters, there is a callback
function pointer and a data pointer.  The callback will be invoked only
if the encrypt/decrypt handlers return -EINPROGRESS.  In other words,
if the return value of zero the completion handler (or the equivalent
code) needs to be invoked by the caller.

The request structure is allocated and freed by the caller.  Its size
is determined by calling crypto_ablkcipher_reqsize().  The helpers
ablkcipher_request_alloc/ablkcipher_request_free can be used to manage
the memory for a request.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -349,13 +349,48 @@ static int setkey(struct crypto_tfm *tfm
 	return cipher->setkey(tfm, key, keylen);
 }
 
+static int async_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
+			unsigned int keylen)
+{
+	return setkey(crypto_ablkcipher_tfm(tfm), key, keylen);
+}
+
+static int async_encrypt(struct ablkcipher_request *req)
+{
+	struct crypto_tfm *tfm = req->base.tfm;
+	struct blkcipher_alg *alg = &tfm->__crt_alg->cra_blkcipher;
+	struct blkcipher_desc desc = {
+		.tfm = __crypto_blkcipher_cast(tfm),
+		.info = req->info,
+		.flags = req->base.flags,
+	};
+
+
+	return alg->encrypt(&desc, req->dst, req->src, req->nbytes);
+}
+
+static int async_decrypt(struct ablkcipher_request *req)
+{
+	struct crypto_tfm *tfm = req->base.tfm;
+	struct blkcipher_alg *alg = &tfm->__crt_alg->cra_blkcipher;
+	struct blkcipher_desc desc = {
+		.tfm = __crypto_blkcipher_cast(tfm),
+		.info = req->info,
+		.flags = req->base.flags,
+	};
+
+	return alg->decrypt(&desc, req->dst, req->src, req->nbytes);
+}
+
 static unsigned int crypto_blkcipher_ctxsize(struct crypto_alg *alg, u32 type,
 					     u32 mask)
 {
 	struct blkcipher_alg *cipher = &alg->cra_blkcipher;
 	unsigned int len = alg->cra_ctxsize;
 
-	if (cipher->ivsize) {
+	type ^= CRYPTO_ALG_ASYNC;
+	mask &= CRYPTO_ALG_ASYNC;
+	if ((type & mask) && cipher->ivsize) {
 		len = ALIGN(len, (unsigned long)alg->cra_alignmask + 1);
 		len += cipher->ivsize;
 	}
@@ -363,16 +398,26 @@ static unsigned int crypto_blkcipher_ctx
 	return len;
 }
 
-static int crypto_init_blkcipher_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
+static int crypto_init_blkcipher_ops_async(struct crypto_tfm *tfm)
+{
+	struct ablkcipher_tfm *crt = &tfm->crt_ablkcipher;
+	struct blkcipher_alg *alg = &tfm->__crt_alg->cra_blkcipher;
+
+	crt->setkey = async_setkey;
+	crt->encrypt = async_encrypt;
+	crt->decrypt = async_decrypt;
+	crt->ivsize = alg->ivsize;
+
+	return 0;
+}
+
+static int crypto_init_blkcipher_ops_sync(struct crypto_tfm *tfm)
 {
 	struct blkcipher_tfm *crt = &tfm->crt_blkcipher;
 	struct blkcipher_alg *alg = &tfm->__crt_alg->cra_blkcipher;
 	unsigned long align = crypto_tfm_alg_alignmask(tfm) + 1;
 	unsigned long addr;
 
-	if (alg->ivsize > PAGE_SIZE / 8)
-		return -EINVAL;
-
 	crt->setkey = setkey;
 	crt->encrypt = alg->encrypt;
 	crt->decrypt = alg->decrypt;
@@ -385,6 +430,21 @@ static int crypto_init_blkcipher_ops(str
 	return 0;
 }
 
+static int crypto_init_blkcipher_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
+{
+	struct blkcipher_alg *alg = &tfm->__crt_alg->cra_blkcipher;
+
+	if (alg->ivsize > PAGE_SIZE / 8)
+		return -EINVAL;
+
+	type ^= CRYPTO_ALG_ASYNC;
+	mask &= CRYPTO_ALG_ASYNC;
+	if (type & mask)
+		return crypto_init_blkcipher_ops_sync(tfm);
+	else
+		return crypto_init_blkcipher_ops_async(tfm);
+}
+
 static void crypto_blkcipher_show(struct seq_file *m, struct crypto_alg *alg)
 	__attribute__ ((unused));
 static void crypto_blkcipher_show(struct seq_file *m, struct crypto_alg *alg)
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -56,6 +56,7 @@
 
 #define CRYPTO_TFM_REQ_WEAK_KEY		0x00000100
 #define CRYPTO_TFM_REQ_MAY_SLEEP	0x00000200
+#define CRYPTO_TFM_REQ_MAY_BACKLOG	0x00000400
 #define CRYPTO_TFM_RES_WEAK_KEY		0x00100000
 #define CRYPTO_TFM_RES_BAD_KEY_LEN   	0x00200000
 #define CRYPTO_TFM_RES_BAD_KEY_SCHED 	0x00400000
@@ -88,11 +89,37 @@
 #endif
 
 struct scatterlist;
+struct crypto_ablkcipher;
+struct crypto_async_request;
 struct crypto_blkcipher;
 struct crypto_hash;
 struct crypto_tfm;
 struct crypto_type;
 
+typedef void (*crypto_completion_t)(struct crypto_async_request *req, int err);
+
+struct crypto_async_request {
+	struct list_head list;
+	crypto_completion_t complete;
+	void *data;
+	struct crypto_tfm *tfm;
+
+	u32 flags;
+};
+
+struct ablkcipher_request {
+	struct crypto_async_request base;
+
+	unsigned int nbytes;
+
+	void *info;
+
+	struct scatterlist *src;
+	struct scatterlist *dst;
+
+	void *__ctx[] CRYPTO_MINALIGN_ATTR;
+};
+
 struct blkcipher_desc {
 	struct crypto_blkcipher *tfm;
 	void *info;
@@ -232,6 +259,15 @@ static inline int crypto_has_alg(const c
  * crypto_free_*(), as well as the various helpers below.
  */
 
+struct ablkcipher_tfm {
+	int (*setkey)(struct crypto_ablkcipher *tfm, const u8 *key,
+	              unsigned int keylen);
+	int (*encrypt)(struct ablkcipher_request *req);
+	int (*decrypt)(struct ablkcipher_request *req);
+	unsigned int ivsize;
+	unsigned int reqsize;
+};
+
 struct blkcipher_tfm {
 	void *iv;
 	int (*setkey)(struct crypto_tfm *tfm, const u8 *key,
@@ -290,6 +326,7 @@ struct compress_tfm {
 	                      u8 *dst, unsigned int *dlen);
 };
 
+#define crt_ablkcipher	crt_u.ablkcipher
 #define crt_blkcipher	crt_u.blkcipher
 #define crt_cipher	crt_u.cipher
 #define crt_hash	crt_u.hash
@@ -300,6 +337,7 @@ struct crypto_tfm {
 	u32 crt_flags;
 	
 	union {
+		struct ablkcipher_tfm ablkcipher;
 		struct blkcipher_tfm blkcipher;
 		struct cipher_tfm cipher;
 		struct hash_tfm hash;
@@ -311,6 +349,10 @@ struct crypto_tfm {
 	void *__crt_ctx[] CRYPTO_MINALIGN_ATTR;
 };
 
+struct crypto_ablkcipher {
+	struct crypto_tfm base;
+};
+
 struct crypto_blkcipher {
 	struct crypto_tfm base;
 };
@@ -411,6 +453,155 @@ static inline unsigned int crypto_tfm_ct
 /*
  * API wrappers.
  */
+static inline struct crypto_ablkcipher *__crypto_ablkcipher_cast(
+	struct crypto_tfm *tfm)
+{
+	return (struct crypto_ablkcipher *)tfm;
+}
+
+static inline struct crypto_ablkcipher *crypto_alloc_ablkcipher(
+	const char *alg_name, u32 type, u32 mask)
+{
+	type &= ~CRYPTO_ALG_TYPE_MASK;
+	type |= CRYPTO_ALG_TYPE_BLKCIPHER;
+	mask |= CRYPTO_ALG_TYPE_MASK;
+
+	return __crypto_ablkcipher_cast(
+		crypto_alloc_base(alg_name, type, mask));
+}
+
+static inline struct crypto_tfm *crypto_ablkcipher_tfm(
+	struct crypto_ablkcipher *tfm)
+{
+	return &tfm->base;
+}
+
+static inline void crypto_free_ablkcipher(struct crypto_ablkcipher *tfm)
+{
+	crypto_free_tfm(crypto_ablkcipher_tfm(tfm));
+}
+
+static inline int crypto_has_ablkcipher(const char *alg_name, u32 type,
+					u32 mask)
+{
+	type &= ~CRYPTO_ALG_TYPE_MASK;
+	type |= CRYPTO_ALG_TYPE_BLKCIPHER;
+	mask |= CRYPTO_ALG_TYPE_MASK;
+
+	return crypto_has_alg(alg_name, type, mask);
+}
+
+static inline struct ablkcipher_tfm *crypto_ablkcipher_crt(
+	struct crypto_ablkcipher *tfm)
+{
+	return &crypto_ablkcipher_tfm(tfm)->crt_ablkcipher;
+}
+
+static inline unsigned int crypto_ablkcipher_ivsize(
+	struct crypto_ablkcipher *tfm)
+{
+	return crypto_ablkcipher_crt(tfm)->ivsize;
+}
+
+static inline unsigned int crypto_ablkcipher_blocksize(
+	struct crypto_ablkcipher *tfm)
+{
+	return crypto_tfm_alg_blocksize(crypto_ablkcipher_tfm(tfm));
+}
+
+static inline unsigned int crypto_ablkcipher_alignmask(
+	struct crypto_ablkcipher *tfm)
+{
+	return crypto_tfm_alg_alignmask(crypto_ablkcipher_tfm(tfm));
+}
+
+static inline u32 crypto_ablkcipher_get_flags(struct crypto_ablkcipher *tfm)
+{
+	return crypto_tfm_get_flags(crypto_ablkcipher_tfm(tfm));
+}
+
+static inline void crypto_ablkcipher_set_flags(struct crypto_ablkcipher *tfm,
+					       u32 flags)
+{
+	crypto_tfm_set_flags(crypto_ablkcipher_tfm(tfm), flags);
+}
+
+static inline void crypto_ablkcipher_clear_flags(struct crypto_ablkcipher *tfm,
+						 u32 flags)
+{
+	crypto_tfm_clear_flags(crypto_ablkcipher_tfm(tfm), flags);
+}
+
+static inline int crypto_ablkcipher_setkey(struct crypto_ablkcipher *tfm,
+					   const u8 *key, unsigned int keylen)
+{
+	return crypto_ablkcipher_crt(tfm)->setkey(tfm, key, keylen);
+}
+
+static inline struct crypto_ablkcipher *crypto_ablkcipher_reqtfm(
+	struct ablkcipher_request *req)
+{
+	return __crypto_ablkcipher_cast(req->base.tfm);
+}
+
+static inline int crypto_ablkcipher_encrypt(struct ablkcipher_request *req)
+{
+	struct ablkcipher_tfm *crt =
+		crypto_ablkcipher_crt(crypto_ablkcipher_reqtfm(req));
+	return crt->encrypt(req);
+}
+
+static inline int crypto_ablkcipher_decrypt(struct ablkcipher_request *req)
+{
+	struct ablkcipher_tfm *crt =
+		crypto_ablkcipher_crt(crypto_ablkcipher_reqtfm(req));
+	return crt->decrypt(req);
+}
+
+static inline int crypto_ablkcipher_reqsize(struct crypto_ablkcipher *tfm)
+{
+	return crypto_ablkcipher_crt(tfm)->reqsize;
+}
+
+static inline struct ablkcipher_request *ablkcipher_request_alloc(
+	struct crypto_ablkcipher *tfm, gfp_t gfp)
+{
+	struct ablkcipher_request *req;
+
+	req = kmalloc(sizeof(struct ablkcipher_request) +
+		      crypto_ablkcipher_reqsize(tfm), gfp);
+
+	if (likely(req))
+		req->base.tfm = crypto_ablkcipher_tfm(tfm);
+
+	return req;
+}
+
+static inline void ablkcipher_request_free(struct ablkcipher_request *req)
+{
+	kfree(req);
+}
+
+static inline void ablkcipher_request_set_callback(
+	struct ablkcipher_request *req,
+	u32 flags, crypto_completion_t complete, void *data)
+{
+	req->base.complete = complete;
+	req->base.data = data;
+	req->base.flags = flags;
+}
+
+static inline void ablkcipher_request_set_crypt(
+	struct ablkcipher_request *req,
+	struct scatterlist *src, struct scatterlist *dst,
+	unsigned int nbytes, void *iv)
+{
+	req->src = src;
+	req->dst = dst;
+	req->nbytes = nbytes;
+	req->info = iv;
+}
+
 static inline struct crypto_blkcipher *__crypto_blkcipher_cast(
 	struct crypto_tfm *tfm)
 {
@@ -427,9 +618,9 @@ static inline struct crypto_blkcipher *c
 static inline struct crypto_blkcipher *crypto_alloc_blkcipher(
 	const char *alg_name, u32 type, u32 mask)
 {
-	type &= ~CRYPTO_ALG_TYPE_MASK;
+	type &= ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_ASYNC);
 	type |= CRYPTO_ALG_TYPE_BLKCIPHER;
-	mask |= CRYPTO_ALG_TYPE_MASK;
+	mask |= CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_ASYNC;
 
 	return __crypto_blkcipher_cast(crypto_alloc_base(alg_name, type, mask));
 }
@@ -447,9 +638,9 @@ static inline void crypto_free_blkcipher
 
 static inline int crypto_has_blkcipher(const char *alg_name, u32 type, u32 mask)
 {
-	type &= ~CRYPTO_ALG_TYPE_MASK;
+	type &= ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_ASYNC);
 	type |= CRYPTO_ALG_TYPE_BLKCIPHER;
-	mask |= CRYPTO_ALG_TYPE_MASK;
+	mask |= CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_ASYNC;
 
 	return crypto_has_alg(alg_name, type, mask);
 }
