From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 04/11] crypto: serpent-sse2 - prepare serpent-sse2 glue code
 into generic x86 glue code for 128bit block ciphers
Date: Mon, 18 Jun 2012 14:07:14 +0300
Message-ID: <20120618110713.28985.91225.stgit@localhost6.localdomain6>
References: <20120618110652.28985.70075.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:58420 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab2FRLHV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jun 2012 07:07:21 -0400
In-Reply-To: <20120618110652.28985.70075.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Block cipher implementations in arch/x86/crypto/ contain common glue code that
is currently duplicated in each module (camellia-x86_64, twofish-x86_64-3way,
twofish-avx, serpent-sse2 and serpent-avx). This patch prepares serpent-sse2
glue into generic glue code for all 128bit block ciphers to use in
arch/x86/crypto.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/serpent_sse2_glue.c |  466 +++++++++++++++++++++++------------
 1 file changed, 303 insertions(+), 163 deletions(-)

diff --git a/arch/x86/crypto/serpent_sse2_glue.c b/arch/x86/crypto/serpent_sse2_glue.c
index 805c91f..8c86239 100644
--- a/arch/x86/crypto/serpent_sse2_glue.c
+++ b/arch/x86/crypto/serpent_sse2_glue.c
@@ -48,105 +48,129 @@
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
 
-static inline bool serpent_fpu_begin(bool fpu_enabled, unsigned int nbytes)
+typedef void (*common_glue_func_t)(void *ctx, u8 *dst, const u8 *src);
+typedef void (*common_glue_cbc_func_t)(void *ctx, u128 *dst, const u128 *src);
+typedef void (*common_glue_ctr_func_t)(void *ctx, u128 *dst, const u128 *src,
+				       u128 *iv);
+
+#define GLUE_FUNC_CAST(fn) ((common_glue_func_t)(fn))
+#define GLUE_CBC_FUNC_CAST(fn) ((common_glue_cbc_func_t)(fn))
+#define GLUE_CTR_FUNC_CAST(fn) ((common_glue_ctr_func_t)(fn))
+
+struct common_glue_func_entry {
+	unsigned int num_blocks; /* number of blocks that @fn will process */
+	union {
+		common_glue_func_t ecb;
+		common_glue_cbc_func_t cbc;
+		common_glue_ctr_func_t ctr;
+	} fn_u;
+};
+
+struct common_glue_ctx {
+	unsigned int num_funcs;
+	int fpu_blocks_limit; /* -1 means fpu not needed at all */
+
+	/*
+	 * First funcs entry must have largest num_blocks and last funcs entry
+	 * must have num_blocks == 1!
+	 */
+	struct common_glue_func_entry funcs[];
+};
+
+static inline bool glue_fpu_begin(unsigned int bsize, int fpu_blocks_limit,
+				  struct blkcipher_desc *desc,
+				  bool fpu_enabled, unsigned int nbytes)
 {
+	if (likely(fpu_blocks_limit < 0))
+		return false;
+
 	if (fpu_enabled)
 		return true;
 
-	/* SSE2 is only used when chunk to be processed is large enough, so
-	 * do not enable FPU until it is necessary.
+	/*
+	 * Vector-registers are only used when chunk to be processed is large
+	 * enough, so do not enable FPU until it is necessary.
 	 */
-	if (nbytes < SERPENT_BLOCK_SIZE * SERPENT_PARALLEL_BLOCKS)
+	if (nbytes < bsize * (unsigned int)fpu_blocks_limit)
 		return false;
 
+	if (desc) {
+		/* prevent sleeping if FPU is in use */
+		desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	}
+
 	kernel_fpu_begin();
 	return true;
 }
 
-static inline void serpent_fpu_end(bool fpu_enabled)
+static inline void glue_fpu_end(bool fpu_enabled)
 {
 	if (fpu_enabled)
 		kernel_fpu_end();
 }
 
-static int ecb_crypt(struct blkcipher_desc *desc, struct blkcipher_walk *walk,
-		     bool enc)
+static int __glue_ecb_crypt_128bit(const struct common_glue_ctx *gctx,
+				   struct blkcipher_desc *desc,
+				   struct blkcipher_walk *walk)
 {
+	void *ctx = crypto_blkcipher_ctx(desc->tfm);
+	const unsigned int bsize = 128 / 8;
+	unsigned int nbytes, i, func_bytes;
 	bool fpu_enabled = false;
-	struct serpent_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	const unsigned int bsize = SERPENT_BLOCK_SIZE;
-	unsigned int nbytes;
 	int err;
 
 	err = blkcipher_walk_virt(desc, walk);
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	while ((nbytes = walk->nbytes)) {
 		u8 *wsrc = walk->src.virt.addr;
 		u8 *wdst = walk->dst.virt.addr;
 
-		fpu_enabled = serpent_fpu_begin(fpu_enabled, nbytes);
+		fpu_enabled = glue_fpu_begin(bsize, gctx->fpu_blocks_limit,
+					     desc, fpu_enabled, nbytes);
 
-		/* Process multi-block batch */
-		if (nbytes >= bsize * SERPENT_PARALLEL_BLOCKS) {
-			do {
-				if (enc)
-					serpent_enc_blk_xway(ctx, wdst, wsrc);
-				else
-					serpent_dec_blk_xway(ctx, wdst, wsrc);
+		for (i = 0; i < gctx->num_funcs; i++) {
+			func_bytes = bsize * gctx->funcs[i].num_blocks;
 
-				wsrc += bsize * SERPENT_PARALLEL_BLOCKS;
-				wdst += bsize * SERPENT_PARALLEL_BLOCKS;
-				nbytes -= bsize * SERPENT_PARALLEL_BLOCKS;
-			} while (nbytes >= bsize * SERPENT_PARALLEL_BLOCKS);
+			/* Process multi-block batch */
+			if (nbytes >= func_bytes) {
+				do {
+					gctx->funcs[i].fn_u.ecb(ctx, wdst,
+								wsrc);
 
-			if (nbytes < bsize)
-				goto done;
-		}
-
-		/* Handle leftovers */
-		do {
-			if (enc)
-				__serpent_encrypt(ctx, wdst, wsrc);
-			else
-				__serpent_decrypt(ctx, wdst, wsrc);
+					wsrc += func_bytes;
+					wdst += func_bytes;
+					nbytes -= func_bytes;
+				} while (nbytes >= func_bytes);
 
-			wsrc += bsize;
-			wdst += bsize;
-			nbytes -= bsize;
-		} while (nbytes >= bsize);
+				if (nbytes < bsize)
+					goto done;
+			}
+		}
 
 done:
 		err = blkcipher_walk_done(desc, walk, nbytes);
 	}
 
-	serpent_fpu_end(fpu_enabled);
+	glue_fpu_end(fpu_enabled);
 	return err;
 }
 
-static int ecb_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
-		       struct scatterlist *src, unsigned int nbytes)
+int glue_ecb_crypt_128bit(const struct common_glue_ctx *gctx,
+			  struct blkcipher_desc *desc, struct scatterlist *dst,
+			  struct scatterlist *src, unsigned int nbytes)
 {
 	struct blkcipher_walk walk;
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return ecb_crypt(desc, &walk, true);
+	return __glue_ecb_crypt_128bit(gctx, desc, &walk);
 }
 
-static int ecb_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
-		       struct scatterlist *src, unsigned int nbytes)
+static unsigned int __glue_cbc_encrypt_128bit(const common_glue_func_t fn,
+					      struct blkcipher_desc *desc,
+					      struct blkcipher_walk *walk)
 {
-	struct blkcipher_walk walk;
-
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return ecb_crypt(desc, &walk, false);
-}
-
-static unsigned int __cbc_encrypt(struct blkcipher_desc *desc,
-				  struct blkcipher_walk *walk)
-{
-	struct serpent_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	const unsigned int bsize = SERPENT_BLOCK_SIZE;
+	void *ctx = crypto_blkcipher_ctx(desc->tfm);
+	const unsigned int bsize = 128 / 8;
 	unsigned int nbytes = walk->nbytes;
 	u128 *src = (u128 *)walk->src.virt.addr;
 	u128 *dst = (u128 *)walk->dst.virt.addr;
@@ -154,7 +178,7 @@ static unsigned int __cbc_encrypt(struct blkcipher_desc *desc,
 
 	do {
 		u128_xor(dst, src, iv);
-		__serpent_encrypt(ctx, (u8 *)dst, (u8 *)dst);
+		fn(ctx, (u8 *)dst, (u8 *)dst);
 		iv = dst;
 
 		src += 1;
@@ -166,8 +190,10 @@ static unsigned int __cbc_encrypt(struct blkcipher_desc *desc,
 	return nbytes;
 }
 
-static int cbc_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
-		       struct scatterlist *src, unsigned int nbytes)
+int glue_cbc_encrypt_128bit(const common_glue_func_t fn,
+			    struct blkcipher_desc *desc,
+			    struct scatterlist *dst,
+			    struct scatterlist *src, unsigned int nbytes)
 {
 	struct blkcipher_walk walk;
 	int err;
@@ -176,24 +202,26 @@ static int cbc_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 	err = blkcipher_walk_virt(desc, &walk);
 
 	while ((nbytes = walk.nbytes)) {
-		nbytes = __cbc_encrypt(desc, &walk);
+		nbytes = __glue_cbc_encrypt_128bit(fn, desc, &walk);
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
 
 	return err;
 }
 
-static unsigned int __cbc_decrypt(struct blkcipher_desc *desc,
-				  struct blkcipher_walk *walk)
+static unsigned int
+__glue_cbc_decrypt_128bit(const struct common_glue_ctx *gctx,
+			  struct blkcipher_desc *desc,
+			  struct blkcipher_walk *walk)
 {
-	struct serpent_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	const unsigned int bsize = SERPENT_BLOCK_SIZE;
+	void *ctx = crypto_blkcipher_ctx(desc->tfm);
+	const unsigned int bsize = 128 / 8;
 	unsigned int nbytes = walk->nbytes;
 	u128 *src = (u128 *)walk->src.virt.addr;
 	u128 *dst = (u128 *)walk->dst.virt.addr;
-	u128 ivs[SERPENT_PARALLEL_BLOCKS - 1];
 	u128 last_iv;
-	int i;
+	unsigned int num_blocks, func_bytes;
+	unsigned int i;
 
 	/* Start of the last block. */
 	src += nbytes / bsize - 1;
@@ -201,45 +229,31 @@ static unsigned int __cbc_decrypt(struct blkcipher_desc *desc,
 
 	last_iv = *src;
 
-	/* Process multi-block batch */
-	if (nbytes >= bsize * SERPENT_PARALLEL_BLOCKS) {
-		do {
-			nbytes -= bsize * (SERPENT_PARALLEL_BLOCKS - 1);
-			src -= SERPENT_PARALLEL_BLOCKS - 1;
-			dst -= SERPENT_PARALLEL_BLOCKS - 1;
+	for (i = 0; i < gctx->num_funcs; i++) {
+		num_blocks = gctx->funcs[i].num_blocks;
+		func_bytes = bsize * num_blocks;
 
-			for (i = 0; i < SERPENT_PARALLEL_BLOCKS - 1; i++)
-				ivs[i] = src[i];
+		/* Process multi-block batch */
+		if (nbytes >= func_bytes) {
+			do {
+				nbytes -= func_bytes - bsize;
+				src -= num_blocks - 1;
+				dst -= num_blocks - 1;
+
+				gctx->funcs[i].fn_u.cbc(ctx, dst, src);
 
-			serpent_dec_blk_xway(ctx, (u8 *)dst, (u8 *)src);
+				nbytes -= bsize;
+				if (nbytes < bsize)
+					goto done;
 
-			for (i = 0; i < SERPENT_PARALLEL_BLOCKS - 1; i++)
-				u128_xor(dst + (i + 1), dst + (i + 1), ivs + i);
+				u128_xor(dst, dst, src - 1);
+				src -= 1;
+				dst -= 1;
+			} while (nbytes >= func_bytes);
 
-			nbytes -= bsize;
 			if (nbytes < bsize)
 				goto done;
-
-			u128_xor(dst, dst, src - 1);
-			src -= 1;
-			dst -= 1;
-		} while (nbytes >= bsize * SERPENT_PARALLEL_BLOCKS);
-
-		if (nbytes < bsize)
-			goto done;
-	}
-
-	/* Handle leftovers */
-	for (;;) {
-		__serpent_decrypt(ctx, (u8 *)dst, (u8 *)src);
-
-		nbytes -= bsize;
-		if (nbytes < bsize)
-			break;
-
-		u128_xor(dst, dst, src - 1);
-		src -= 1;
-		dst -= 1;
+		}
 	}
 
 done:
@@ -249,24 +263,27 @@ done:
 	return nbytes;
 }
 
-static int cbc_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
-		       struct scatterlist *src, unsigned int nbytes)
+int glue_cbc_decrypt_128bit(const struct common_glue_ctx *gctx,
+			    struct blkcipher_desc *desc,
+			    struct scatterlist *dst,
+			    struct scatterlist *src, unsigned int nbytes)
 {
+	const unsigned int bsize = 128 / 8;
 	bool fpu_enabled = false;
 	struct blkcipher_walk walk;
 	int err;
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	while ((nbytes = walk.nbytes)) {
-		fpu_enabled = serpent_fpu_begin(fpu_enabled, nbytes);
-		nbytes = __cbc_decrypt(desc, &walk);
+		fpu_enabled = glue_fpu_begin(bsize, gctx->fpu_blocks_limit,
+					     desc, fpu_enabled, nbytes);
+		nbytes = __glue_cbc_decrypt_128bit(gctx, desc, &walk);
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
 
-	serpent_fpu_end(fpu_enabled);
+	glue_fpu_end(fpu_enabled);
 	return err;
 }
 
@@ -289,109 +306,232 @@ static inline void u128_inc(u128 *i)
 		i->a++;
 }
 
-static void ctr_crypt_final(struct blkcipher_desc *desc,
-			    struct blkcipher_walk *walk)
+static void glue_ctr_crypt_final_128bit(const common_glue_ctr_func_t fn_ctr,
+					struct blkcipher_desc *desc,
+					struct blkcipher_walk *walk)
 {
-	struct serpent_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	u8 *ctrblk = walk->iv;
-	u8 keystream[SERPENT_BLOCK_SIZE];
-	u8 *src = walk->src.virt.addr;
-	u8 *dst = walk->dst.virt.addr;
+	void *ctx = crypto_blkcipher_ctx(desc->tfm);
+	u8 *src = (u8 *)walk->src.virt.addr;
+	u8 *dst = (u8 *)walk->dst.virt.addr;
 	unsigned int nbytes = walk->nbytes;
+	u128 ctrblk;
+	u128 tmp;
 
-	__serpent_encrypt(ctx, keystream, ctrblk);
-	crypto_xor(keystream, src, nbytes);
-	memcpy(dst, keystream, nbytes);
+	be128_to_u128(&ctrblk, (be128 *)walk->iv);
 
-	crypto_inc(ctrblk, SERPENT_BLOCK_SIZE);
+	memcpy(&tmp, src, nbytes);
+	fn_ctr(ctx, &tmp, &tmp, &ctrblk);
+	memcpy(dst, &tmp, nbytes);
+
+	u128_to_be128((be128 *)walk->iv, &ctrblk);
 }
 
-static unsigned int __ctr_crypt(struct blkcipher_desc *desc,
-				struct blkcipher_walk *walk)
+static unsigned int __glue_ctr_crypt_128bit(const struct common_glue_ctx *gctx,
+					    struct blkcipher_desc *desc,
+					    struct blkcipher_walk *walk)
 {
-	struct serpent_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	const unsigned int bsize = SERPENT_BLOCK_SIZE;
+	const unsigned int bsize = 128 / 8;
+	void *ctx = crypto_blkcipher_ctx(desc->tfm);
 	unsigned int nbytes = walk->nbytes;
 	u128 *src = (u128 *)walk->src.virt.addr;
 	u128 *dst = (u128 *)walk->dst.virt.addr;
 	u128 ctrblk;
-	be128 ctrblocks[SERPENT_PARALLEL_BLOCKS];
-	int i;
+	unsigned int num_blocks, func_bytes;
+	unsigned int i;
 
 	be128_to_u128(&ctrblk, (be128 *)walk->iv);
 
 	/* Process multi-block batch */
-	if (nbytes >= bsize * SERPENT_PARALLEL_BLOCKS) {
-		do {
-			/* create ctrblks for parallel encrypt */
-			for (i = 0; i < SERPENT_PARALLEL_BLOCKS; i++) {
-				if (dst != src)
-					dst[i] = src[i];
-
-				u128_to_be128(&ctrblocks[i], &ctrblk);
-				u128_inc(&ctrblk);
-			}
+	for (i = 0; i < gctx->num_funcs; i++) {
+		num_blocks = gctx->funcs[i].num_blocks;
+		func_bytes = bsize * num_blocks;
 
-			serpent_enc_blk_xway_xor(ctx, (u8 *)dst,
-						 (u8 *)ctrblocks);
+		if (nbytes >= func_bytes) {
+			do {
+				gctx->funcs[i].fn_u.ctr(ctx, dst, src, &ctrblk);
 
-			src += SERPENT_PARALLEL_BLOCKS;
-			dst += SERPENT_PARALLEL_BLOCKS;
-			nbytes -= bsize * SERPENT_PARALLEL_BLOCKS;
-		} while (nbytes >= bsize * SERPENT_PARALLEL_BLOCKS);
+				src += num_blocks;
+				dst += num_blocks;
+				nbytes -= func_bytes;
+			} while (nbytes >= func_bytes);
 
-		if (nbytes < bsize)
-			goto done;
+			if (nbytes < bsize)
+				goto done;
+		}
 	}
 
-	/* Handle leftovers */
-	do {
-		if (dst != src)
-			*dst = *src;
-
-		u128_to_be128(&ctrblocks[0], &ctrblk);
-		u128_inc(&ctrblk);
-
-		__serpent_encrypt(ctx, (u8 *)ctrblocks, (u8 *)ctrblocks);
-		u128_xor(dst, dst, (u128 *)ctrblocks);
-
-		src += 1;
-		dst += 1;
-		nbytes -= bsize;
-	} while (nbytes >= bsize);
-
 done:
 	u128_to_be128((be128 *)walk->iv, &ctrblk);
 	return nbytes;
 }
 
-static int ctr_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
-		     struct scatterlist *src, unsigned int nbytes)
+int glue_ctr_crypt_128bit(const struct common_glue_ctx *gctx,
+			  struct blkcipher_desc *desc, struct scatterlist *dst,
+			  struct scatterlist *src, unsigned int nbytes)
 {
+	const unsigned int bsize = 128 / 8;
 	bool fpu_enabled = false;
 	struct blkcipher_walk walk;
 	int err;
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt_block(desc, &walk, SERPENT_BLOCK_SIZE);
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	err = blkcipher_walk_virt_block(desc, &walk, bsize);
 
-	while ((nbytes = walk.nbytes) >= SERPENT_BLOCK_SIZE) {
-		fpu_enabled = serpent_fpu_begin(fpu_enabled, nbytes);
-		nbytes = __ctr_crypt(desc, &walk);
+	while ((nbytes = walk.nbytes) >= bsize) {
+		fpu_enabled = glue_fpu_begin(bsize, gctx->fpu_blocks_limit,
+					     desc, fpu_enabled, nbytes);
+		nbytes = __glue_ctr_crypt_128bit(gctx, desc, &walk);
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
 
-	serpent_fpu_end(fpu_enabled);
+	glue_fpu_end(fpu_enabled);
 
 	if (walk.nbytes) {
-		ctr_crypt_final(desc, &walk);
+		glue_ctr_crypt_final_128bit(
+			gctx->funcs[gctx->num_funcs - 1].fn_u.ctr, desc, &walk);
 		err = blkcipher_walk_done(desc, &walk, 0);
 	}
 
 	return err;
 }
 
+static void serpent_decrypt_cbc_xway(void *ctx, u128 *dst, const u128 *src)
+{
+	u128 ivs[SERPENT_PARALLEL_BLOCKS - 1];
+	unsigned int j;
+
+	for (j = 0; j < SERPENT_PARALLEL_BLOCKS - 1; j++)
+		ivs[j] = src[j];
+
+	serpent_dec_blk_xway(ctx, (u8 *)dst, (u8 *)src);
+
+	for (j = 0; j < SERPENT_PARALLEL_BLOCKS - 1; j++)
+		u128_xor(dst + (j + 1), dst + (j + 1), ivs + j);
+}
+
+static void serpent_crypt_ctr(void *ctx, u128 *dst, const u128 *src, u128 *iv)
+{
+	be128 ctrblk;
+
+	u128_to_be128(&ctrblk, iv);
+	u128_inc(iv);
+
+	__serpent_encrypt(ctx, (u8 *)&ctrblk, (u8 *)&ctrblk);
+	u128_xor(dst, src, (u128 *)&ctrblk);
+}
+
+static void serpent_crypt_ctr_xway(void *ctx, u128 *dst, const u128 *src,
+				   u128 *iv)
+{
+	be128 ctrblks[SERPENT_PARALLEL_BLOCKS];
+	unsigned int i;
+
+	for (i = 0; i < SERPENT_PARALLEL_BLOCKS; i++) {
+		if (dst != src)
+			dst[i] = src[i];
+
+		u128_to_be128(&ctrblks[i], iv);
+		u128_inc(iv);
+	}
+
+	serpent_enc_blk_xway_xor(ctx, (u8 *)dst, (u8 *)ctrblks);
+}
+
+static const struct common_glue_ctx serpent_enc = {
+	.num_funcs = 2,
+	.fpu_blocks_limit = SERPENT_PARALLEL_BLOCKS,
+
+	.funcs = { {
+		.num_blocks = SERPENT_PARALLEL_BLOCKS,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(serpent_enc_blk_xway) }
+	}, {
+		.num_blocks = 1,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(__serpent_encrypt) }
+	} }
+};
+
+static const struct common_glue_ctx serpent_ctr = {
+	.num_funcs = 2,
+	.fpu_blocks_limit = SERPENT_PARALLEL_BLOCKS,
+
+	.funcs = { {
+		.num_blocks = SERPENT_PARALLEL_BLOCKS,
+		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(serpent_crypt_ctr_xway) }
+	}, {
+		.num_blocks = 1,
+		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(serpent_crypt_ctr) }
+	} }
+};
+
+static const struct common_glue_ctx serpent_dec = {
+	.num_funcs = 2,
+	.fpu_blocks_limit = SERPENT_PARALLEL_BLOCKS,
+
+	.funcs = { {
+		.num_blocks = SERPENT_PARALLEL_BLOCKS,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(serpent_dec_blk_xway) }
+	}, {
+		.num_blocks = 1,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(__serpent_decrypt) }
+	} }
+};
+
+static const struct common_glue_ctx serpent_dec_cbc = {
+	.num_funcs = 2,
+	.fpu_blocks_limit = SERPENT_PARALLEL_BLOCKS,
+
+	.funcs = { {
+		.num_blocks = SERPENT_PARALLEL_BLOCKS,
+		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(serpent_decrypt_cbc_xway) }
+	}, {
+		.num_blocks = 1,
+		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(__serpent_decrypt) }
+	} }
+};
+
+static int ecb_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	return glue_ecb_crypt_128bit(&serpent_enc, desc, dst, src, nbytes);
+}
+
+static int ecb_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	return glue_ecb_crypt_128bit(&serpent_dec, desc, dst, src, nbytes);
+}
+
+static int cbc_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	return glue_cbc_encrypt_128bit(GLUE_FUNC_CAST(__serpent_encrypt), desc,
+				     dst, src, nbytes);
+}
+
+static int cbc_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	return glue_cbc_decrypt_128bit(&serpent_dec_cbc, desc, dst, src,
+				       nbytes);
+}
+
+static int ctr_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		     struct scatterlist *src, unsigned int nbytes)
+{
+	return glue_ctr_crypt_128bit(&serpent_ctr, desc, dst, src, nbytes);
+}
+
+static inline bool serpent_fpu_begin(bool fpu_enabled, unsigned int nbytes)
+{
+	return glue_fpu_begin(SERPENT_BLOCK_SIZE, SERPENT_PARALLEL_BLOCKS,
+			      NULL, fpu_enabled, nbytes);
+}
+
+static inline void serpent_fpu_end(bool fpu_enabled)
+{
+	glue_fpu_end(fpu_enabled);
+}
+
 struct crypt_priv {
 	struct serpent_ctx *ctx;
 	bool fpu_enabled;
