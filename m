From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH] crypto: keywrap - simplify code
Date: Sun, 01 Oct 2017 17:19:43 +0200
Message-ID: <83738816.byIHpQSsDj@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34600 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751247AbdJAPTz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 1 Oct 2017 11:19:55 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The code is simplified by using two u64 values for the operation instead
of using two arrays of u8. This allows to get rid of the memory
alignment code. In addition, the crypto_xor can be replaced with a
native XOR operation. Finally, the definition of the variables is
re-arranged such that the data structures come before simple variables
to potentially reduce memory space.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/keywrap.c | 86 ++++++++++++++++++++------------------------------------
 1 file changed, 30 insertions(+), 56 deletions(-)

diff --git a/crypto/keywrap.c b/crypto/keywrap.c
index 72014f963ba7..ce7a36fc6de4 100644
--- a/crypto/keywrap.c
+++ b/crypto/keywrap.c
@@ -93,18 +93,10 @@ struct crypto_kw_ctx {
 
 struct crypto_kw_block {
 #define SEMIBSIZE 8
-	u8 A[SEMIBSIZE];
-	u8 R[SEMIBSIZE];
+	u64 A;
+	u64 R;
 };
 
-/* convert 64 bit integer into its string representation */
-static inline void crypto_kw_cpu_to_be64(u64 val, u8 *buf)
-{
-	__be64 *a = (__be64 *)buf;
-
-	*a = cpu_to_be64(val);
-}
-
 /*
  * Fast forward the SGL to the "end" length minus SEMIBSIZE.
  * The start in the SGL defined by the fast-forward is returned with
@@ -139,17 +131,10 @@ static int crypto_kw_decrypt(struct blkcipher_desc *desc,
 	struct crypto_blkcipher *tfm = desc->tfm;
 	struct crypto_kw_ctx *ctx = crypto_blkcipher_ctx(tfm);
 	struct crypto_cipher *child = ctx->child;
-
-	unsigned long alignmask = max_t(unsigned long, SEMIBSIZE,
-					crypto_cipher_alignmask(child));
-	unsigned int i;
-
-	u8 blockbuf[sizeof(struct crypto_kw_block) + alignmask];
-	struct crypto_kw_block *block = (struct crypto_kw_block *)
-					PTR_ALIGN(blockbuf + 0, alignmask + 1);
-
-	u64 t = 6 * ((nbytes) >> 3);
+	struct crypto_kw_block block;
 	struct scatterlist *lsrc, *ldst;
+	u64 t = 6 * ((nbytes) >> 3);
+	unsigned int i;
 	int ret = 0;
 
 	/*
@@ -160,7 +145,7 @@ static int crypto_kw_decrypt(struct blkcipher_desc *desc,
 		return -EINVAL;
 
 	/* Place the IV into block A */
-	memcpy(block->A, desc->info, SEMIBSIZE);
+	memcpy(&block.A, desc->info, SEMIBSIZE);
 
 	/*
 	 * src scatterlist is read-only. dst scatterlist is r/w. During the
@@ -171,32 +156,30 @@ static int crypto_kw_decrypt(struct blkcipher_desc *desc,
 	ldst = dst;
 
 	for (i = 0; i < 6; i++) {
-		u8 tbe_buffer[SEMIBSIZE + alignmask];
-		/* alignment for the crypto_xor and the _to_be64 operation */
-		u8 *tbe = PTR_ALIGN(tbe_buffer + 0, alignmask + 1);
-		unsigned int tmp_nbytes = nbytes;
 		struct scatter_walk src_walk, dst_walk;
+		__be64 tbe;
+		unsigned int tmp_nbytes = nbytes;
 
 		while (tmp_nbytes) {
 			/* move pointer by tmp_nbytes in the SGL */
 			crypto_kw_scatterlist_ff(&src_walk, lsrc, tmp_nbytes);
 			/* get the source block */
-			scatterwalk_copychunks(block->R, &src_walk, SEMIBSIZE,
+			scatterwalk_copychunks(&block.R, &src_walk, SEMIBSIZE,
 					       false);
 
 			/* perform KW operation: get counter as byte string */
-			crypto_kw_cpu_to_be64(t, tbe);
+			tbe = cpu_to_be64(t);
 			/* perform KW operation: modify IV with counter */
-			crypto_xor(block->A, tbe, SEMIBSIZE);
+			block.A ^= tbe;
 			t--;
 			/* perform KW operation: decrypt block */
-			crypto_cipher_decrypt_one(child, (u8*)block,
-						  (u8*)block);
+			crypto_cipher_decrypt_one(child, (u8*)&block,
+						  (u8*)&block);
 
 			/* move pointer by tmp_nbytes in the SGL */
 			crypto_kw_scatterlist_ff(&dst_walk, ldst, tmp_nbytes);
 			/* Copy block->R into place */
-			scatterwalk_copychunks(block->R, &dst_walk, SEMIBSIZE,
+			scatterwalk_copychunks(&block.R, &dst_walk, SEMIBSIZE,
 					       true);
 
 			tmp_nbytes -= SEMIBSIZE;
@@ -208,11 +191,10 @@ static int crypto_kw_decrypt(struct blkcipher_desc *desc,
 	}
 
 	/* Perform authentication check */
-	if (crypto_memneq("\xA6\xA6\xA6\xA6\xA6\xA6\xA6\xA6", block->A,
-			  SEMIBSIZE))
+	if (block.A != 0xa6a6a6a6a6a6a6a6)
 		ret = -EBADMSG;
 
-	memzero_explicit(block, sizeof(struct crypto_kw_block));
+	memzero_explicit(&block, sizeof(struct crypto_kw_block));
 
 	return ret;
 }
@@ -224,17 +206,10 @@ static int crypto_kw_encrypt(struct blkcipher_desc *desc,
 	struct crypto_blkcipher *tfm = desc->tfm;
 	struct crypto_kw_ctx *ctx = crypto_blkcipher_ctx(tfm);
 	struct crypto_cipher *child = ctx->child;
-
-	unsigned long alignmask = max_t(unsigned long, SEMIBSIZE,
-					crypto_cipher_alignmask(child));
-	unsigned int i;
-
-	u8 blockbuf[sizeof(struct crypto_kw_block) + alignmask];
-	struct crypto_kw_block *block = (struct crypto_kw_block *)
-					PTR_ALIGN(blockbuf + 0, alignmask + 1);
-
-	u64 t = 1;
+	struct crypto_kw_block block;
 	struct scatterlist *lsrc, *ldst;
+	u64 t = 1;
+	unsigned int i;
 
 	/*
 	 * Require at least 2 semiblocks (note, the 3rd semiblock that is
@@ -249,7 +224,7 @@ static int crypto_kw_encrypt(struct blkcipher_desc *desc,
 	 * Place the predefined IV into block A -- for encrypt, the caller
 	 * does not need to provide an IV, but he needs to fetch the final IV.
 	 */
-	memcpy(block->A, "\xA6\xA6\xA6\xA6\xA6\xA6\xA6\xA6", SEMIBSIZE);
+	block.A = 0xa6a6a6a6a6a6a6a6;
 
 	/*
 	 * src scatterlist is read-only. dst scatterlist is r/w. During the
@@ -260,30 +235,29 @@ static int crypto_kw_encrypt(struct blkcipher_desc *desc,
 	ldst = dst;
 
 	for (i = 0; i < 6; i++) {
-		u8 tbe_buffer[SEMIBSIZE + alignmask];
-		u8 *tbe = PTR_ALIGN(tbe_buffer + 0, alignmask + 1);
-		unsigned int tmp_nbytes = nbytes;
 		struct scatter_walk src_walk, dst_walk;
+		__be64 tbe;
+		unsigned int tmp_nbytes = nbytes;
 
 		scatterwalk_start(&src_walk, lsrc);
 		scatterwalk_start(&dst_walk, ldst);
 
 		while (tmp_nbytes) {
 			/* get the source block */
-			scatterwalk_copychunks(block->R, &src_walk, SEMIBSIZE,
+			scatterwalk_copychunks(&block.R, &src_walk, SEMIBSIZE,
 					       false);
 
 			/* perform KW operation: encrypt block */
-			crypto_cipher_encrypt_one(child, (u8 *)block,
-						  (u8 *)block);
+			crypto_cipher_encrypt_one(child, (u8 *)&block,
+						  (u8 *)&block);
 			/* perform KW operation: get counter as byte string */
-			crypto_kw_cpu_to_be64(t, tbe);
+			tbe = cpu_to_be64(t);
 			/* perform KW operation: modify IV with counter */
-			crypto_xor(block->A, tbe, SEMIBSIZE);
+			block.A ^= tbe;
 			t++;
 
 			/* Copy block->R into place */
-			scatterwalk_copychunks(block->R, &dst_walk, SEMIBSIZE,
+			scatterwalk_copychunks(&block.R, &dst_walk, SEMIBSIZE,
 					       true);
 
 			tmp_nbytes -= SEMIBSIZE;
@@ -295,9 +269,9 @@ static int crypto_kw_encrypt(struct blkcipher_desc *desc,
 	}
 
 	/* establish the IV for the caller to pick up */
-	memcpy(desc->info, block->A, SEMIBSIZE);
+	memcpy(desc->info, &block.A, SEMIBSIZE);
 
-	memzero_explicit(block, sizeof(struct crypto_kw_block));
+	memzero_explicit(&block, sizeof(struct crypto_kw_block));
 
 	return 0;
 }
-- 
2.13.5
