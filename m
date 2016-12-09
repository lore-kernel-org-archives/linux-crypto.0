From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto: arm/aes-neonbs - process 8 blocks in parallel if we can
Date: Fri,  9 Dec 2016 13:47:26 +0000
Message-ID: <1481291246-20216-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wj0-f170.google.com ([209.85.210.170]:33192 "EHLO
        mail-wj0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932955AbcLINre (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Dec 2016 08:47:34 -0500
Received: by mail-wj0-f170.google.com with SMTP id xy5so15116164wjc.0
        for <linux-crypto@vger.kernel.org>; Fri, 09 Dec 2016 05:47:33 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The bit-sliced NEON implementation of AES only performs optimally if
it can process 8 blocks of input in parallel. This is due to the nature
of bit slicing, where the n-th bit of each byte of AES state of each input
block is collected into NEON register 'n', for registers q0 - q7.

This implies that the amount of work for the transform is fixed,
regardless of whether we are handling just one block or 8 in parallel.

So let's try a bit harder to iterate over the input in suitably sized
chunks, by increasing the chunksize to 8 * AES_BLOCK_SIZE, and tweaking
the loops to only process multiples of the chunk size, unless we are
handling the last chunk in the input stream.

Note that the skcipher walk API guarantees that a step in the walk never
returns less that 'chunksize' bytes if there are at least that many bytes
of input still available. However, it does *not* guarantee that those steps
produce an exact multiple of the chunk size.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/aesbs-glue.c | 68 +++++++++++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 30 deletions(-)

diff --git a/arch/arm/crypto/aesbs-glue.c b/arch/arm/crypto/aesbs-glue.c
index d8e06de72ef3..938d1e1bf9a3 100644
--- a/arch/arm/crypto/aesbs-glue.c
+++ b/arch/arm/crypto/aesbs-glue.c
@@ -121,39 +121,26 @@ static int aesbs_cbc_encrypt(struct skcipher_request *req)
 	return crypto_cbc_encrypt_walk(req, aesbs_encrypt_one);
 }
 
-static inline void aesbs_decrypt_one(struct crypto_skcipher *tfm,
-				     const u8 *src, u8 *dst)
-{
-	struct aesbs_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	AES_decrypt(src, dst, &ctx->dec.rk);
-}
-
 static int aesbs_cbc_decrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct aesbs_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct skcipher_walk walk;
-	unsigned int nbytes;
 	int err;
 
-	for (err = skcipher_walk_virt(&walk, req, false);
-	     (nbytes = walk.nbytes); err = skcipher_walk_done(&walk, nbytes)) {
-		u32 blocks = nbytes / AES_BLOCK_SIZE;
-		u8 *dst = walk.dst.virt.addr;
-		u8 *src = walk.src.virt.addr;
-		u8 *iv = walk.iv;
-
-		if (blocks >= 8) {
-			kernel_neon_begin();
-			bsaes_cbc_encrypt(src, dst, nbytes, &ctx->dec, iv);
-			kernel_neon_end();
-			nbytes %= AES_BLOCK_SIZE;
-			continue;
-		}
+	err = skcipher_walk_virt(&walk, req, false);
+
+	while (walk.nbytes) {
+		unsigned int nbytes = walk.nbytes;
+
+		if (nbytes < walk.total)
+			nbytes = round_down(nbytes, walk.chunksize);
 
-		nbytes = crypto_cbc_decrypt_blocks(&walk, tfm,
-						   aesbs_decrypt_one);
+		kernel_neon_begin();
+		bsaes_cbc_encrypt(walk.src.virt.addr, walk.dst.virt.addr,
+				  nbytes, &ctx->dec, walk.iv);
+		kernel_neon_end();
+		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
 	}
 	return err;
 }
@@ -186,6 +173,12 @@ static int aesbs_ctr_encrypt(struct skcipher_request *req)
 		__be32 *ctr = (__be32 *)walk.iv;
 		u32 headroom = UINT_MAX - be32_to_cpu(ctr[3]);
 
+		if (walk.nbytes < walk.total) {
+			blocks = round_down(blocks,
+					    walk.chunksize / AES_BLOCK_SIZE);
+			tail = walk.nbytes - blocks * AES_BLOCK_SIZE;
+		}
+
 		/* avoid 32 bit counter overflow in the NEON code */
 		if (unlikely(headroom < blocks)) {
 			blocks = headroom + 1;
@@ -198,6 +191,9 @@ static int aesbs_ctr_encrypt(struct skcipher_request *req)
 		kernel_neon_end();
 		inc_be128_ctr(ctr, blocks);
 
+		if (tail > 0 && tail < AES_BLOCK_SIZE)
+			break;
+
 		err = skcipher_walk_done(&walk, tail);
 	}
 	if (walk.nbytes) {
@@ -227,11 +223,16 @@ static int aesbs_xts_encrypt(struct skcipher_request *req)
 	AES_encrypt(walk.iv, walk.iv, &ctx->twkey);
 
 	while (walk.nbytes) {
+		unsigned int nbytes = walk.nbytes;
+
+		if (nbytes < walk.total)
+			nbytes = round_down(nbytes, walk.chunksize);
+
 		kernel_neon_begin();
 		bsaes_xts_encrypt(walk.src.virt.addr, walk.dst.virt.addr,
-				  walk.nbytes, &ctx->enc, walk.iv);
+				  nbytes, &ctx->enc, walk.iv);
 		kernel_neon_end();
-		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
+		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
 	}
 	return err;
 }
@@ -249,11 +250,16 @@ static int aesbs_xts_decrypt(struct skcipher_request *req)
 	AES_encrypt(walk.iv, walk.iv, &ctx->twkey);
 
 	while (walk.nbytes) {
+		unsigned int nbytes = walk.nbytes;
+
+		if (nbytes < walk.total)
+			nbytes = round_down(nbytes, walk.chunksize);
+
 		kernel_neon_begin();
 		bsaes_xts_decrypt(walk.src.virt.addr, walk.dst.virt.addr,
-				  walk.nbytes, &ctx->dec, walk.iv);
+				  nbytes, &ctx->dec, walk.iv);
 		kernel_neon_end();
-		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
+		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
 	}
 	return err;
 }
@@ -272,6 +278,7 @@ static struct skcipher_alg aesbs_algs[] = { {
 	.min_keysize	= AES_MIN_KEY_SIZE,
 	.max_keysize	= AES_MAX_KEY_SIZE,
 	.ivsize		= AES_BLOCK_SIZE,
+	.chunksize	= 8 * AES_BLOCK_SIZE,
 	.setkey		= aesbs_cbc_set_key,
 	.encrypt	= aesbs_cbc_encrypt,
 	.decrypt	= aesbs_cbc_decrypt,
@@ -289,7 +296,7 @@ static struct skcipher_alg aesbs_algs[] = { {
 	.min_keysize	= AES_MIN_KEY_SIZE,
 	.max_keysize	= AES_MAX_KEY_SIZE,
 	.ivsize		= AES_BLOCK_SIZE,
-	.chunksize	= AES_BLOCK_SIZE,
+	.chunksize	= 8 * AES_BLOCK_SIZE,
 	.setkey		= aesbs_ctr_set_key,
 	.encrypt	= aesbs_ctr_encrypt,
 	.decrypt	= aesbs_ctr_encrypt,
@@ -307,6 +314,7 @@ static struct skcipher_alg aesbs_algs[] = { {
 	.min_keysize	= 2 * AES_MIN_KEY_SIZE,
 	.max_keysize	= 2 * AES_MAX_KEY_SIZE,
 	.ivsize		= AES_BLOCK_SIZE,
+	.chunksize	= 8 * AES_BLOCK_SIZE,
 	.setkey		= aesbs_xts_set_key,
 	.encrypt	= aesbs_xts_encrypt,
 	.decrypt	= aesbs_xts_decrypt,
-- 
2.7.4
