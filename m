From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 09/11] crypto: twofish-avx - remove duplicated glue code and
 use shared glue code from glue_helper
Date: Mon, 18 Jun 2012 14:07:39 +0300
Message-ID: <20120618110739.28985.4925.stgit@localhost6.localdomain6>
References: <20120618110652.28985.70075.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Johannes Goetzfried
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:60102 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab2FRLHq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jun 2012 07:07:46 -0400
In-Reply-To: <20120618110652.28985.70075.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Now that shared glue code is available, convert twofish-avx to use it.

Cc: Johannes Goetzfried <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/twofish_avx_glue.c    |  556 ++++++---------------------------
 arch/x86/crypto/twofish_glue_3way.c   |   46 +--
 arch/x86/include/asm/crypto/twofish.h |   46 +++
 crypto/Kconfig                        |    1 
 4 files changed, 162 insertions(+), 487 deletions(-)
 create mode 100644 arch/x86/include/asm/crypto/twofish.h

diff --git a/arch/x86/crypto/twofish_avx_glue.c b/arch/x86/crypto/twofish_avx_glue.c
index cabe058..782b67d 100644
--- a/arch/x86/crypto/twofish_avx_glue.c
+++ b/arch/x86/crypto/twofish_avx_glue.c
@@ -4,9 +4,6 @@
  * Copyright (C) 2012 Johannes Goetzfried
  *     <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
  *
- * Glue code based on serpent_sse2_glue.c by:
- *  Copyright (C) 2011 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
@@ -39,38 +36,21 @@
 #include <asm/i387.h>
 #include <asm/xcr.h>
 #include <asm/xsave.h>
+#include <asm/crypto/twofish.h>
 #include <asm/crypto/ablk_helper.h>
+#include <asm/crypto/glue_helper.h>
 #include <crypto/scatterwalk.h>
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
 
-
 #define TWOFISH_PARALLEL_BLOCKS 8
 
-/* regular block cipher functions from twofish_x86_64 module */
-asmlinkage void twofish_enc_blk(struct twofish_ctx *ctx, u8 *dst,
-				const u8 *src);
-asmlinkage void twofish_dec_blk(struct twofish_ctx *ctx, u8 *dst,
-				const u8 *src);
-
-/* 3-way parallel cipher functions from twofish_x86_64-3way module */
-asmlinkage void __twofish_enc_blk_3way(struct twofish_ctx *ctx, u8 *dst,
-				       const u8 *src, bool xor);
-asmlinkage void twofish_dec_blk_3way(struct twofish_ctx *ctx, u8 *dst,
-				     const u8 *src);
-
 static inline void twofish_enc_blk_3way(struct twofish_ctx *ctx, u8 *dst,
 					const u8 *src)
 {
 	__twofish_enc_blk_3way(ctx, dst, src, false);
 }
 
-static inline void twofish_enc_blk_3way_xor(struct twofish_ctx *ctx, u8 *dst,
-					    const u8 *src)
-{
-	__twofish_enc_blk_3way(ctx, dst, src, true);
-}
-
 /* 8-way parallel cipher functions */
 asmlinkage void __twofish_enc_blk_8way(struct twofish_ctx *ctx, u8 *dst,
 				       const u8 *src, bool xor);
@@ -95,423 +75,142 @@ static inline void twofish_dec_blk_xway(struct twofish_ctx *ctx, u8 *dst,
 	twofish_dec_blk_8way(ctx, dst, src);
 }
 
-
-static inline bool twofish_fpu_begin(bool fpu_enabled, unsigned int nbytes)
+static void twofish_dec_blk_cbc_xway(void *ctx, u128 *dst, const u128 *src)
 {
-	if (fpu_enabled)
-		return true;
+	u128 ivs[TWOFISH_PARALLEL_BLOCKS - 1];
+	unsigned int j;
 
-	/* AVX is only used when chunk to be processed is large enough, so
-	 * do not enable FPU until it is necessary.
-	 */
-	if (nbytes < TF_BLOCK_SIZE * TWOFISH_PARALLEL_BLOCKS)
-		return false;
+	for (j = 0; j < TWOFISH_PARALLEL_BLOCKS - 1; j++)
+		ivs[j] = src[j];
 
-	kernel_fpu_begin();
-	return true;
-}
+	twofish_dec_blk_xway(ctx, (u8 *)dst, (u8 *)src);
 
-static inline void twofish_fpu_end(bool fpu_enabled)
-{
-	if (fpu_enabled)
-		kernel_fpu_end();
+	for (j = 0; j < TWOFISH_PARALLEL_BLOCKS - 1; j++)
+		u128_xor(dst + (j + 1), dst + (j + 1), ivs + j);
 }
 
-static int ecb_crypt(struct blkcipher_desc *desc, struct blkcipher_walk *walk,
-		     bool enc)
+static void twofish_enc_blk_ctr_xway(void *ctx, u128 *dst, const u128 *src,
+				     u128 *iv)
 {
-	bool fpu_enabled = false;
-	struct twofish_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	const unsigned int bsize = TF_BLOCK_SIZE;
-	unsigned int nbytes;
-	int err;
+	be128 ctrblks[TWOFISH_PARALLEL_BLOCKS];
+	unsigned int i;
 
-	err = blkcipher_walk_virt(desc, walk);
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	for (i = 0; i < TWOFISH_PARALLEL_BLOCKS; i++) {
+		if (dst != src)
+			dst[i] = src[i];
 
-	while ((nbytes = walk->nbytes)) {
-		u8 *wsrc = walk->src.virt.addr;
-		u8 *wdst = walk->dst.virt.addr;
-
-		fpu_enabled = twofish_fpu_begin(fpu_enabled, nbytes);
-
-		/* Process multi-block batch */
-		if (nbytes >= bsize * TWOFISH_PARALLEL_BLOCKS) {
-			do {
-				if (enc)
-					twofish_enc_blk_xway(ctx, wdst, wsrc);
-				else
-					twofish_dec_blk_xway(ctx, wdst, wsrc);
-
-				wsrc += bsize * TWOFISH_PARALLEL_BLOCKS;
-				wdst += bsize * TWOFISH_PARALLEL_BLOCKS;
-				nbytes -= bsize * TWOFISH_PARALLEL_BLOCKS;
-			} while (nbytes >= bsize * TWOFISH_PARALLEL_BLOCKS);
-
-			if (nbytes < bsize)
-				goto done;
-		}
-
-		/* Process three block batch */
-		if (nbytes >= bsize * 3) {
-			do {
-				if (enc)
-					twofish_enc_blk_3way(ctx, wdst, wsrc);
-				else
-					twofish_dec_blk_3way(ctx, wdst, wsrc);
-
-				wsrc += bsize * 3;
-				wdst += bsize * 3;
-				nbytes -= bsize * 3;
-			} while (nbytes >= bsize * 3);
-
-			if (nbytes < bsize)
-				goto done;
-		}
-
-		/* Handle leftovers */
-		do {
-			if (enc)
-				twofish_enc_blk(ctx, wdst, wsrc);
-			else
-				twofish_dec_blk(ctx, wdst, wsrc);
-
-			wsrc += bsize;
-			wdst += bsize;
-			nbytes -= bsize;
-		} while (nbytes >= bsize);
-
-done:
-		err = blkcipher_walk_done(desc, walk, nbytes);
+		u128_to_be128(&ctrblks[i], iv);
+		u128_inc(iv);
 	}
 
-	twofish_fpu_end(fpu_enabled);
-	return err;
+	twofish_enc_blk_xway_xor(ctx, (u8 *)dst, (u8 *)ctrblks);
 }
 
+static const struct common_glue_ctx twofish_enc = {
+	.num_funcs = 3,
+	.fpu_blocks_limit = TWOFISH_PARALLEL_BLOCKS,
+
+	.funcs = { {
+		.num_blocks = TWOFISH_PARALLEL_BLOCKS,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_enc_blk_xway) }
+	}, {
+		.num_blocks = 3,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_enc_blk_3way) }
+	}, {
+		.num_blocks = 1,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_enc_blk) }
+	} }
+};
+
+static const struct common_glue_ctx twofish_ctr = {
+	.num_funcs = 3,
+	.fpu_blocks_limit = TWOFISH_PARALLEL_BLOCKS,
+
+	.funcs = { {
+		.num_blocks = TWOFISH_PARALLEL_BLOCKS,
+		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(twofish_enc_blk_ctr_xway) }
+	}, {
+		.num_blocks = 3,
+		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(twofish_enc_blk_ctr_3way) }
+	}, {
+		.num_blocks = 1,
+		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(twofish_enc_blk_ctr) }
+	} }
+};
+
+static const struct common_glue_ctx twofish_dec = {
+	.num_funcs = 3,
+	.fpu_blocks_limit = TWOFISH_PARALLEL_BLOCKS,
+
+	.funcs = { {
+		.num_blocks = TWOFISH_PARALLEL_BLOCKS,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_dec_blk_xway) }
+	}, {
+		.num_blocks = 3,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_dec_blk_3way) }
+	}, {
+		.num_blocks = 1,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_dec_blk) }
+	} }
+};
+
+static const struct common_glue_ctx twofish_dec_cbc = {
+	.num_funcs = 3,
+	.fpu_blocks_limit = TWOFISH_PARALLEL_BLOCKS,
+
+	.funcs = { {
+		.num_blocks = TWOFISH_PARALLEL_BLOCKS,
+		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(twofish_dec_blk_cbc_xway) }
+	}, {
+		.num_blocks = 3,
+		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(twofish_dec_blk_cbc_3way) }
+	}, {
+		.num_blocks = 1,
+		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(twofish_dec_blk) }
+	} }
+};
+
 static int ecb_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 		       struct scatterlist *src, unsigned int nbytes)
 {
-	struct blkcipher_walk walk;
-
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return ecb_crypt(desc, &walk, true);
+	return glue_ecb_crypt_128bit(&twofish_enc, desc, dst, src, nbytes);
 }
 
 static int ecb_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 		       struct scatterlist *src, unsigned int nbytes)
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
-	struct twofish_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	const unsigned int bsize = TF_BLOCK_SIZE;
-	unsigned int nbytes = walk->nbytes;
-	u128 *src = (u128 *)walk->src.virt.addr;
-	u128 *dst = (u128 *)walk->dst.virt.addr;
-	u128 *iv = (u128 *)walk->iv;
-
-	do {
-		u128_xor(dst, src, iv);
-		twofish_enc_blk(ctx, (u8 *)dst, (u8 *)dst);
-		iv = dst;
-
-		src += 1;
-		dst += 1;
-		nbytes -= bsize;
-	} while (nbytes >= bsize);
-
-	u128_xor((u128 *)walk->iv, (u128 *)walk->iv, iv);
-	return nbytes;
+	return glue_ecb_crypt_128bit(&twofish_dec, desc, dst, src, nbytes);
 }
 
 static int cbc_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 		       struct scatterlist *src, unsigned int nbytes)
 {
-	struct blkcipher_walk walk;
-	int err;
-
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
-
-	while ((nbytes = walk.nbytes)) {
-		nbytes = __cbc_encrypt(desc, &walk);
-		err = blkcipher_walk_done(desc, &walk, nbytes);
-	}
-
-	return err;
-}
-
-static unsigned int __cbc_decrypt(struct blkcipher_desc *desc,
-				  struct blkcipher_walk *walk)
-{
-	struct twofish_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	const unsigned int bsize = TF_BLOCK_SIZE;
-	unsigned int nbytes = walk->nbytes;
-	u128 *src = (u128 *)walk->src.virt.addr;
-	u128 *dst = (u128 *)walk->dst.virt.addr;
-	u128 ivs[TWOFISH_PARALLEL_BLOCKS - 1];
-	u128 last_iv;
-	int i;
-
-	/* Start of the last block. */
-	src += nbytes / bsize - 1;
-	dst += nbytes / bsize - 1;
-
-	last_iv = *src;
-
-	/* Process multi-block batch */
-	if (nbytes >= bsize * TWOFISH_PARALLEL_BLOCKS) {
-		do {
-			nbytes -= bsize * (TWOFISH_PARALLEL_BLOCKS - 1);
-			src -= TWOFISH_PARALLEL_BLOCKS - 1;
-			dst -= TWOFISH_PARALLEL_BLOCKS - 1;
-
-			for (i = 0; i < TWOFISH_PARALLEL_BLOCKS - 1; i++)
-				ivs[i] = src[i];
-
-			twofish_dec_blk_xway(ctx, (u8 *)dst, (u8 *)src);
-
-			for (i = 0; i < TWOFISH_PARALLEL_BLOCKS - 1; i++)
-				u128_xor(dst + (i + 1), dst + (i + 1), ivs + i);
-
-			nbytes -= bsize;
-			if (nbytes < bsize)
-				goto done;
-
-			u128_xor(dst, dst, src - 1);
-			src -= 1;
-			dst -= 1;
-		} while (nbytes >= bsize * TWOFISH_PARALLEL_BLOCKS);
-
-		if (nbytes < bsize)
-			goto done;
-	}
-
-	/* Process three block batch */
-	if (nbytes >= bsize * 3) {
-		do {
-			nbytes -= bsize * (3 - 1);
-			src -= 3 - 1;
-			dst -= 3 - 1;
-
-			ivs[0] = src[0];
-			ivs[1] = src[1];
-
-			twofish_dec_blk_3way(ctx, (u8 *)dst, (u8 *)src);
-
-			u128_xor(dst + 1, dst + 1, ivs + 0);
-			u128_xor(dst + 2, dst + 2, ivs + 1);
-
-			nbytes -= bsize;
-			if (nbytes < bsize)
-				goto done;
-
-			u128_xor(dst, dst, src - 1);
-			src -= 1;
-			dst -= 1;
-		} while (nbytes >= bsize * 3);
-
-		if (nbytes < bsize)
-			goto done;
-	}
-
-	/* Handle leftovers */
-	for (;;) {
-		twofish_dec_blk(ctx, (u8 *)dst, (u8 *)src);
-
-		nbytes -= bsize;
-		if (nbytes < bsize)
-			break;
-
-		u128_xor(dst, dst, src - 1);
-		src -= 1;
-		dst -= 1;
-	}
-
-done:
-	u128_xor(dst, dst, (u128 *)walk->iv);
-	*(u128 *)walk->iv = last_iv;
-
-	return nbytes;
+	return glue_cbc_encrypt_128bit(GLUE_FUNC_CAST(twofish_enc_blk), desc,
+				       dst, src, nbytes);
 }
 
 static int cbc_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 		       struct scatterlist *src, unsigned int nbytes)
 {
-	bool fpu_enabled = false;
-	struct blkcipher_walk walk;
-	int err;
-
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
-
-	while ((nbytes = walk.nbytes)) {
-		fpu_enabled = twofish_fpu_begin(fpu_enabled, nbytes);
-		nbytes = __cbc_decrypt(desc, &walk);
-		err = blkcipher_walk_done(desc, &walk, nbytes);
-	}
-
-	twofish_fpu_end(fpu_enabled);
-	return err;
-}
-
-static inline void u128_to_be128(be128 *dst, const u128 *src)
-{
-	dst->a = cpu_to_be64(src->a);
-	dst->b = cpu_to_be64(src->b);
+	return glue_cbc_decrypt_128bit(&twofish_dec_cbc, desc, dst, src,
+				       nbytes);
 }
 
-static inline void be128_to_u128(u128 *dst, const be128 *src)
-{
-	dst->a = be64_to_cpu(src->a);
-	dst->b = be64_to_cpu(src->b);
-}
-
-static inline void u128_inc(u128 *i)
+static int ctr_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		     struct scatterlist *src, unsigned int nbytes)
 {
-	i->b++;
-	if (!i->b)
-		i->a++;
+	return glue_ctr_crypt_128bit(&twofish_ctr, desc, dst, src, nbytes);
 }
 
-static void ctr_crypt_final(struct blkcipher_desc *desc,
-			    struct blkcipher_walk *walk)
+static inline bool twofish_fpu_begin(bool fpu_enabled, unsigned int nbytes)
 {
-	struct twofish_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	u8 *ctrblk = walk->iv;
-	u8 keystream[TF_BLOCK_SIZE];
-	u8 *src = walk->src.virt.addr;
-	u8 *dst = walk->dst.virt.addr;
-	unsigned int nbytes = walk->nbytes;
-
-	twofish_enc_blk(ctx, keystream, ctrblk);
-	crypto_xor(keystream, src, nbytes);
-	memcpy(dst, keystream, nbytes);
-
-	crypto_inc(ctrblk, TF_BLOCK_SIZE);
+	return glue_fpu_begin(TF_BLOCK_SIZE, TWOFISH_PARALLEL_BLOCKS, NULL,
+			      fpu_enabled, nbytes);
 }
 
-static unsigned int __ctr_crypt(struct blkcipher_desc *desc,
-				struct blkcipher_walk *walk)
-{
-	struct twofish_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	const unsigned int bsize = TF_BLOCK_SIZE;
-	unsigned int nbytes = walk->nbytes;
-	u128 *src = (u128 *)walk->src.virt.addr;
-	u128 *dst = (u128 *)walk->dst.virt.addr;
-	u128 ctrblk;
-	be128 ctrblocks[TWOFISH_PARALLEL_BLOCKS];
-	int i;
-
-	be128_to_u128(&ctrblk, (be128 *)walk->iv);
-
-	/* Process multi-block batch */
-	if (nbytes >= bsize * TWOFISH_PARALLEL_BLOCKS) {
-		do {
-			/* create ctrblks for parallel encrypt */
-			for (i = 0; i < TWOFISH_PARALLEL_BLOCKS; i++) {
-				if (dst != src)
-					dst[i] = src[i];
-
-				u128_to_be128(&ctrblocks[i], &ctrblk);
-				u128_inc(&ctrblk);
-			}
-
-			twofish_enc_blk_xway_xor(ctx, (u8 *)dst,
-						 (u8 *)ctrblocks);
-
-			src += TWOFISH_PARALLEL_BLOCKS;
-			dst += TWOFISH_PARALLEL_BLOCKS;
-			nbytes -= bsize * TWOFISH_PARALLEL_BLOCKS;
-		} while (nbytes >= bsize * TWOFISH_PARALLEL_BLOCKS);
-
-		if (nbytes < bsize)
-			goto done;
-	}
-
-	/* Process three block batch */
-	if (nbytes >= bsize * 3) {
-		do {
-			if (dst != src) {
-				dst[0] = src[0];
-				dst[1] = src[1];
-				dst[2] = src[2];
-			}
-
-			/* create ctrblks for parallel encrypt */
-			u128_to_be128(&ctrblocks[0], &ctrblk);
-			u128_inc(&ctrblk);
-			u128_to_be128(&ctrblocks[1], &ctrblk);
-			u128_inc(&ctrblk);
-			u128_to_be128(&ctrblocks[2], &ctrblk);
-			u128_inc(&ctrblk);
-
-			twofish_enc_blk_3way_xor(ctx, (u8 *)dst,
-						 (u8 *)ctrblocks);
-
-			src += 3;
-			dst += 3;
-			nbytes -= bsize * 3;
-		} while (nbytes >= bsize * 3);
-
-		if (nbytes < bsize)
-			goto done;
-	}
-
-	/* Handle leftovers */
-	do {
-		if (dst != src)
-			*dst = *src;
-
-		u128_to_be128(&ctrblocks[0], &ctrblk);
-		u128_inc(&ctrblk);
-
-		twofish_enc_blk(ctx, (u8 *)ctrblocks, (u8 *)ctrblocks);
-		u128_xor(dst, dst, (u128 *)ctrblocks);
-
-		src += 1;
-		dst += 1;
-		nbytes -= bsize;
-	} while (nbytes >= bsize);
-
-done:
-	u128_to_be128((be128 *)walk->iv, &ctrblk);
-	return nbytes;
-}
-
-static int ctr_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
-		     struct scatterlist *src, unsigned int nbytes)
+static inline void twofish_fpu_end(bool fpu_enabled)
 {
-	bool fpu_enabled = false;
-	struct blkcipher_walk walk;
-	int err;
-
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt_block(desc, &walk, TF_BLOCK_SIZE);
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
-
-	while ((nbytes = walk.nbytes) >= TF_BLOCK_SIZE) {
-		fpu_enabled = twofish_fpu_begin(fpu_enabled, nbytes);
-		nbytes = __ctr_crypt(desc, &walk);
-		err = blkcipher_walk_done(desc, &walk, nbytes);
-	}
-
-	twofish_fpu_end(fpu_enabled);
-
-	if (walk.nbytes) {
-		ctr_crypt_final(desc, &walk);
-		err = blkcipher_walk_done(desc, &walk, 0);
-	}
-
-	return err;
+	glue_fpu_end(fpu_enabled);
 }
 
 struct crypt_priv {
@@ -563,26 +262,6 @@ static void decrypt_callback(void *priv, u8 *srcdst, unsigned int nbytes)
 		twofish_dec_blk(ctx->ctx, srcdst, srcdst);
 }
 
-struct twofish_lrw_ctx {
-	struct lrw_table_ctx lrw_table;
-	struct twofish_ctx twofish_ctx;
-};
-
-static int lrw_twofish_setkey(struct crypto_tfm *tfm, const u8 *key,
-			      unsigned int keylen)
-{
-	struct twofish_lrw_ctx *ctx = crypto_tfm_ctx(tfm);
-	int err;
-
-	err = __twofish_setkey(&ctx->twofish_ctx, key,
-				keylen - TF_BLOCK_SIZE, &tfm->crt_flags);
-	if (err)
-		return err;
-
-	return lrw_init_table(&ctx->lrw_table, key + keylen -
-						TF_BLOCK_SIZE);
-}
-
 static int lrw_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 		       struct scatterlist *src, unsigned int nbytes)
 {
@@ -635,43 +314,6 @@ static int lrw_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 	return ret;
 }
 
-static void lrw_exit_tfm(struct crypto_tfm *tfm)
-{
-	struct twofish_lrw_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	lrw_free_table(&ctx->lrw_table);
-}
-
-struct twofish_xts_ctx {
-	struct twofish_ctx tweak_ctx;
-	struct twofish_ctx crypt_ctx;
-};
-
-static int xts_twofish_setkey(struct crypto_tfm *tfm, const u8 *key,
-			      unsigned int keylen)
-{
-	struct twofish_xts_ctx *ctx = crypto_tfm_ctx(tfm);
-	u32 *flags = &tfm->crt_flags;
-	int err;
-
-	/* key consists of keys of equal size concatenated, therefore
-	 * the length must be even
-	 */
-	if (keylen % 2) {
-		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
-		return -EINVAL;
-	}
-
-	/* first half of xts-key is for crypt */
-	err = __twofish_setkey(&ctx->crypt_ctx, key, keylen / 2, flags);
-	if (err)
-		return err;
-
-	/* second half of xts-key is for tweak */
-	return __twofish_setkey(&ctx->tweak_ctx,
-				key + keylen / 2, keylen / 2, flags);
-}
-
 static int xts_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 		       struct scatterlist *src, unsigned int nbytes)
 {
@@ -798,7 +440,7 @@ static struct crypto_alg twofish_algs[10] = { {
 	.cra_type		= &crypto_blkcipher_type,
 	.cra_module		= THIS_MODULE,
 	.cra_list		= LIST_HEAD_INIT(twofish_algs[3].cra_list),
-	.cra_exit		= lrw_exit_tfm,
+	.cra_exit		= lrw_twofish_exit_tfm,
 	.cra_u = {
 		.blkcipher = {
 			.min_keysize	= TF_MIN_KEY_SIZE +
diff --git a/arch/x86/crypto/twofish_glue_3way.c b/arch/x86/crypto/twofish_glue_3way.c
index 25bf5e9..15f9347 100644
--- a/arch/x86/crypto/twofish_glue_3way.c
+++ b/arch/x86/crypto/twofish_glue_3way.c
@@ -28,22 +28,12 @@
 #include <crypto/algapi.h>
 #include <crypto/twofish.h>
 #include <crypto/b128ops.h>
+#include <asm/crypto/twofish.h>
 #include <asm/crypto/glue_helper.h>
 #include <crypto/lrw.h>
 #include <crypto/xts.h>
 
-/* regular block cipher functions from twofish_x86_64 module */
-asmlinkage void twofish_enc_blk(struct twofish_ctx *ctx, u8 *dst,
-				const u8 *src);
-asmlinkage void twofish_dec_blk(struct twofish_ctx *ctx, u8 *dst,
-				const u8 *src);
-
-/* 3-way parallel cipher functions */
-asmlinkage void __twofish_enc_blk_3way(struct twofish_ctx *ctx, u8 *dst,
-				       const u8 *src, bool xor);
 EXPORT_SYMBOL_GPL(__twofish_enc_blk_3way);
-asmlinkage void twofish_dec_blk_3way(struct twofish_ctx *ctx, u8 *dst,
-				     const u8 *src);
 EXPORT_SYMBOL_GPL(twofish_dec_blk_3way);
 
 static inline void twofish_enc_blk_3way(struct twofish_ctx *ctx, u8 *dst,
@@ -58,7 +48,7 @@ static inline void twofish_enc_blk_xor_3way(struct twofish_ctx *ctx, u8 *dst,
 	__twofish_enc_blk_3way(ctx, dst, src, true);
 }
 
-static void twofish_dec_blk_cbc_3way(void *ctx, u128 *dst, const u128 *src)
+void twofish_dec_blk_cbc_3way(void *ctx, u128 *dst, const u128 *src)
 {
 	u128 ivs[2];
 
@@ -70,8 +60,9 @@ static void twofish_dec_blk_cbc_3way(void *ctx, u128 *dst, const u128 *src)
 	u128_xor(&dst[1], &dst[1], &ivs[0]);
 	u128_xor(&dst[2], &dst[2], &ivs[1]);
 }
+EXPORT_SYMBOL_GPL(twofish_dec_blk_cbc_3way);
 
-static void twofish_enc_blk_ctr(void *ctx, u128 *dst, const u128 *src, u128 *iv)
+void twofish_enc_blk_ctr(void *ctx, u128 *dst, const u128 *src, u128 *iv)
 {
 	be128 ctrblk;
 
@@ -84,8 +75,9 @@ static void twofish_enc_blk_ctr(void *ctx, u128 *dst, const u128 *src, u128 *iv)
 	twofish_enc_blk(ctx, (u8 *)&ctrblk, (u8 *)&ctrblk);
 	u128_xor(dst, dst, (u128 *)&ctrblk);
 }
+EXPORT_SYMBOL_GPL(twofish_enc_blk_ctr);
 
-static void twofish_enc_blk_ctr_3way(void *ctx, u128 *dst, const u128 *src,
+void twofish_enc_blk_ctr_3way(void *ctx, u128 *dst, const u128 *src,
 				     u128 *iv)
 {
 	be128 ctrblks[3];
@@ -105,6 +97,7 @@ static void twofish_enc_blk_ctr_3way(void *ctx, u128 *dst, const u128 *src,
 
 	twofish_enc_blk_xor_3way(ctx, (u8 *)dst, (u8 *)ctrblks);
 }
+EXPORT_SYMBOL_GPL(twofish_enc_blk_ctr_3way);
 
 static const struct common_glue_ctx twofish_enc = {
 	.num_funcs = 2,
@@ -220,13 +213,8 @@ static void decrypt_callback(void *priv, u8 *srcdst, unsigned int nbytes)
 		twofish_dec_blk(ctx, srcdst, srcdst);
 }
 
-struct twofish_lrw_ctx {
-	struct lrw_table_ctx lrw_table;
-	struct twofish_ctx twofish_ctx;
-};
-
-static int lrw_twofish_setkey(struct crypto_tfm *tfm, const u8 *key,
-			      unsigned int keylen)
+int lrw_twofish_setkey(struct crypto_tfm *tfm, const u8 *key,
+		       unsigned int keylen)
 {
 	struct twofish_lrw_ctx *ctx = crypto_tfm_ctx(tfm);
 	int err;
@@ -238,6 +226,7 @@ static int lrw_twofish_setkey(struct crypto_tfm *tfm, const u8 *key,
 
 	return lrw_init_table(&ctx->lrw_table, key + keylen - TF_BLOCK_SIZE);
 }
+EXPORT_SYMBOL_GPL(lrw_twofish_setkey);
 
 static int lrw_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 		       struct scatterlist *src, unsigned int nbytes)
@@ -273,20 +262,16 @@ static int lrw_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 	return lrw_crypt(desc, dst, src, nbytes, &req);
 }
 
-static void lrw_exit_tfm(struct crypto_tfm *tfm)
+void lrw_twofish_exit_tfm(struct crypto_tfm *tfm)
 {
 	struct twofish_lrw_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	lrw_free_table(&ctx->lrw_table);
 }
+EXPORT_SYMBOL_GPL(lrw_twofish_exit_tfm);
 
-struct twofish_xts_ctx {
-	struct twofish_ctx tweak_ctx;
-	struct twofish_ctx crypt_ctx;
-};
-
-static int xts_twofish_setkey(struct crypto_tfm *tfm, const u8 *key,
-			      unsigned int keylen)
+int xts_twofish_setkey(struct crypto_tfm *tfm, const u8 *key,
+		       unsigned int keylen)
 {
 	struct twofish_xts_ctx *ctx = crypto_tfm_ctx(tfm);
 	u32 *flags = &tfm->crt_flags;
@@ -309,6 +294,7 @@ static int xts_twofish_setkey(struct crypto_tfm *tfm, const u8 *key,
 	return __twofish_setkey(&ctx->tweak_ctx, key + keylen / 2, keylen / 2,
 				flags);
 }
+EXPORT_SYMBOL_GPL(xts_twofish_setkey);
 
 static int xts_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 		       struct scatterlist *src, unsigned int nbytes)
@@ -419,7 +405,7 @@ static struct crypto_alg tf_algs[5] = { {
 	.cra_type		= &crypto_blkcipher_type,
 	.cra_module		= THIS_MODULE,
 	.cra_list		= LIST_HEAD_INIT(tf_algs[3].cra_list),
-	.cra_exit		= lrw_exit_tfm,
+	.cra_exit		= lrw_twofish_exit_tfm,
 	.cra_u = {
 		.blkcipher = {
 			.min_keysize	= TF_MIN_KEY_SIZE + TF_BLOCK_SIZE,
diff --git a/arch/x86/include/asm/crypto/twofish.h b/arch/x86/include/asm/crypto/twofish.h
new file mode 100644
index 0000000..9d2c514
--- /dev/null
+++ b/arch/x86/include/asm/crypto/twofish.h
@@ -0,0 +1,46 @@
+#ifndef ASM_X86_TWOFISH_H
+#define ASM_X86_TWOFISH_H
+
+#include <linux/crypto.h>
+#include <crypto/twofish.h>
+#include <crypto/lrw.h>
+#include <crypto/b128ops.h>
+
+struct twofish_lrw_ctx {
+	struct lrw_table_ctx lrw_table;
+	struct twofish_ctx twofish_ctx;
+};
+
+struct twofish_xts_ctx {
+	struct twofish_ctx tweak_ctx;
+	struct twofish_ctx crypt_ctx;
+};
+
+/* regular block cipher functions from twofish_x86_64 module */
+asmlinkage void twofish_enc_blk(struct twofish_ctx *ctx, u8 *dst,
+				const u8 *src);
+asmlinkage void twofish_dec_blk(struct twofish_ctx *ctx, u8 *dst,
+				const u8 *src);
+
+/* 3-way parallel cipher functions */
+asmlinkage void __twofish_enc_blk_3way(struct twofish_ctx *ctx, u8 *dst,
+				       const u8 *src, bool xor);
+asmlinkage void twofish_dec_blk_3way(struct twofish_ctx *ctx, u8 *dst,
+				     const u8 *src);
+
+/* helpers from twofish_x86_64-3way module */
+extern void twofish_dec_blk_cbc_3way(void *ctx, u128 *dst, const u128 *src);
+extern void twofish_enc_blk_ctr(void *ctx, u128 *dst, const u128 *src,
+				u128 *iv);
+extern void twofish_enc_blk_ctr_3way(void *ctx, u128 *dst, const u128 *src,
+				     u128 *iv);
+
+extern int lrw_twofish_setkey(struct crypto_tfm *tfm, const u8 *key,
+			      unsigned int keylen);
+
+extern void lrw_twofish_exit_tfm(struct crypto_tfm *tfm);
+
+extern int xts_twofish_setkey(struct crypto_tfm *tfm, const u8 *key,
+			      unsigned int keylen);
+
+#endif /* ASM_X86_TWOFISH_H */
diff --git a/crypto/Kconfig b/crypto/Kconfig
index fc559ca..02e3037 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -958,6 +958,7 @@ config CRYPTO_TWOFISH_AVX_X86_64
 	select CRYPTO_ALGAPI
 	select CRYPTO_CRYPTD
 	select CRYPTO_ABLK_HELPER_X86
+	select CRYPTO_GLUE_HELPER_X86
 	select CRYPTO_TWOFISH_COMMON
 	select CRYPTO_TWOFISH_X86_64
 	select CRYPTO_TWOFISH_X86_64_3WAY
