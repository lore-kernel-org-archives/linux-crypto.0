From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [patch/rfc] crypto: padlock-aes use crypto API
Date: Thu, 2 Aug 2007 10:10:09 +0200
Message-ID: <20070802081009.GA24488@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:49662 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751638AbXHBIKL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Aug 2007 04:10:11 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

It seems that the driver uses something like crypto_.*_ctx_aligned() of his own.
Replace it with the API's functions. Compile tested.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>

--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -297,30 +297,10 @@ aes_hw_extkey_available(uint8_t key_len)
 	return 0;
 }
 
-static inline struct aes_ctx *aes_ctx_common(void *ctx)
-{
-	unsigned long addr = (unsigned long)ctx;
-	unsigned long align = PADLOCK_ALIGNMENT;
-
-	if (align <= crypto_tfm_ctx_alignment())
-		align = 1;
-	return (struct aes_ctx *)ALIGN(addr, align);
-}
-
-static inline struct aes_ctx *aes_ctx(struct crypto_tfm *tfm)
-{
-	return aes_ctx_common(crypto_tfm_ctx(tfm));
-}
-
-static inline struct aes_ctx *blk_aes_ctx(struct crypto_blkcipher *tfm)
-{
-	return aes_ctx_common(crypto_blkcipher_ctx(tfm));
-}
-
 static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 		       unsigned int key_len)
 {
-	struct aes_ctx *ctx = aes_ctx(tfm);
+	struct aes_ctx *ctx = crypto_tfm_ctx_aligned(tfm);
 	const __le32 *key = (const __le32 *)in_key;
 	u32 *flags = &tfm->crt_flags;
 	uint32_t i, t, u, v, w;
@@ -442,13 +422,13 @@ static inline u8 *padlock_xcrypt_cbc(con
 
 static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
-	struct aes_ctx *ctx = aes_ctx(tfm);
+	struct aes_ctx *ctx = crypto_tfm_ctx_aligned(tfm);
 	padlock_xcrypt_ecb(in, out, ctx->E, &ctx->cword.encrypt, 1);
 }
 
 static void aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
-	struct aes_ctx *ctx = aes_ctx(tfm);
+	struct aes_ctx *ctx = crypto_tfm_ctx_aligned(tfm);
 	padlock_xcrypt_ecb(in, out, ctx->D, &ctx->cword.decrypt, 1);
 }
 
@@ -477,7 +457,7 @@ static int ecb_aes_encrypt(struct blkcip
 			   struct scatterlist *dst, struct scatterlist *src,
 			   unsigned int nbytes)
 {
-	struct aes_ctx *ctx = blk_aes_ctx(desc->tfm);
+	struct aes_ctx *ctx = crypto_blkcipher_ctx_aligned(desc->tfm);
 	struct blkcipher_walk walk;
 	int err;
 
@@ -499,7 +479,7 @@ static int ecb_aes_decrypt(struct blkcip
 			   struct scatterlist *dst, struct scatterlist *src,
 			   unsigned int nbytes)
 {
-	struct aes_ctx *ctx = blk_aes_ctx(desc->tfm);
+	struct aes_ctx *ctx = crypto_blkcipher_ctx_aligned(desc->tfm);
 	struct blkcipher_walk walk;
 	int err;
 
@@ -543,7 +523,7 @@ static int cbc_aes_encrypt(struct blkcip
 			   struct scatterlist *dst, struct scatterlist *src,
 			   unsigned int nbytes)
 {
-	struct aes_ctx *ctx = blk_aes_ctx(desc->tfm);
+	struct aes_ctx *ctx = crypto_blkcipher_ctx_aligned(desc->tfm);
 	struct blkcipher_walk walk;
 	int err;
 
@@ -567,7 +547,7 @@ static int cbc_aes_decrypt(struct blkcip
 			   struct scatterlist *dst, struct scatterlist *src,
 			   unsigned int nbytes)
 {
-	struct aes_ctx *ctx = blk_aes_ctx(desc->tfm);
+	struct aes_ctx *ctx = crypto_blkcipher_ctx_aligned(desc->tfm);
 	struct blkcipher_walk walk;
 	int err;
 
