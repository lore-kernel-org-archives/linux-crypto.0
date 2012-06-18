From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 08/11] crypto: twofish-x86_64-3way - remove duplicated glue
 code and use shared glue code from glue_helper
Date: Mon, 18 Jun 2012 14:07:34 +0300
Message-ID: <20120618110734.28985.87191.stgit@localhost6.localdomain6>
References: <20120618110652.28985.70075.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:58481 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab2FRLHh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jun 2012 07:07:37 -0400
In-Reply-To: <20120618110652.28985.70075.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Now that shared glue code is available, convert twofish-x86_64-3way to use it.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/twofish_glue_3way.c |  365 +++++++++--------------------------
 crypto/Kconfig                      |    1 
 2 files changed, 94 insertions(+), 272 deletions(-)

diff --git a/arch/x86/crypto/twofish_glue_3way.c b/arch/x86/crypto/twofish_glue_3way.c
index 77e4e55..25bf5e9 100644
--- a/arch/x86/crypto/twofish_glue_3way.c
+++ b/arch/x86/crypto/twofish_glue_3way.c
@@ -3,11 +3,6 @@
  *
  * Copyright (c) 2011 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
  *
- * CBC & ECB parts based on code (crypto/cbc.c,ecb.c) by:
- *   Copyright (c) 2006 Herbert Xu <herbert@gondor.apana.org.au>
- * CTR part based on code (crypto/ctr.c) by:
- *   (C) Copyright IBM Corp. 2007 - Joy Latten <latten@us.ibm.com>
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
@@ -33,6 +28,7 @@
 #include <crypto/algapi.h>
 #include <crypto/twofish.h>
 #include <crypto/b128ops.h>
+#include <asm/crypto/glue_helper.h>
 #include <crypto/lrw.h>
 #include <crypto/xts.h>
 
@@ -62,311 +58,136 @@ static inline void twofish_enc_blk_xor_3way(struct twofish_ctx *ctx, u8 *dst,
 	__twofish_enc_blk_3way(ctx, dst, src, true);
 }
 
-static int ecb_crypt(struct blkcipher_desc *desc, struct blkcipher_walk *walk,
-		     void (*fn)(struct twofish_ctx *, u8 *, const u8 *),
-		     void (*fn_3way)(struct twofish_ctx *, u8 *, const u8 *))
+static void twofish_dec_blk_cbc_3way(void *ctx, u128 *dst, const u128 *src)
 {
-	struct twofish_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	unsigned int bsize = TF_BLOCK_SIZE;
-	unsigned int nbytes;
-	int err;
-
-	err = blkcipher_walk_virt(desc, walk);
-
-	while ((nbytes = walk->nbytes)) {
-		u8 *wsrc = walk->src.virt.addr;
-		u8 *wdst = walk->dst.virt.addr;
-
-		/* Process three block batch */
-		if (nbytes >= bsize * 3) {
-			do {
-				fn_3way(ctx, wdst, wsrc);
+	u128 ivs[2];
 
-				wsrc += bsize * 3;
-				wdst += bsize * 3;
-				nbytes -= bsize * 3;
-			} while (nbytes >= bsize * 3);
+	ivs[0] = src[0];
+	ivs[1] = src[1];
 
-			if (nbytes < bsize)
-				goto done;
-		}
-
-		/* Handle leftovers */
-		do {
-			fn(ctx, wdst, wsrc);
-
-			wsrc += bsize;
-			wdst += bsize;
-			nbytes -= bsize;
-		} while (nbytes >= bsize);
-
-done:
-		err = blkcipher_walk_done(desc, walk, nbytes);
-	}
+	twofish_dec_blk_3way(ctx, (u8 *)dst, (u8 *)src);
 
-	return err;
+	u128_xor(&dst[1], &dst[1], &ivs[0]);
+	u128_xor(&dst[2], &dst[2], &ivs[1]);
 }
 
-static int ecb_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
-		       struct scatterlist *src, unsigned int nbytes)
+static void twofish_enc_blk_ctr(void *ctx, u128 *dst, const u128 *src, u128 *iv)
 {
-	struct blkcipher_walk walk;
+	be128 ctrblk;
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return ecb_crypt(desc, &walk, twofish_enc_blk, twofish_enc_blk_3way);
-}
+	if (dst != src)
+		*dst = *src;
 
-static int ecb_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
-		       struct scatterlist *src, unsigned int nbytes)
-{
-	struct blkcipher_walk walk;
+	u128_to_be128(&ctrblk, iv);
+	u128_inc(iv);
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return ecb_crypt(desc, &walk, twofish_dec_blk, twofish_dec_blk_3way);
+	twofish_enc_blk(ctx, (u8 *)&ctrblk, (u8 *)&ctrblk);
+	u128_xor(dst, dst, (u128 *)&ctrblk);
 }
 
-static unsigned int __cbc_encrypt(struct blkcipher_desc *desc,
-				  struct blkcipher_walk *walk)
+static void twofish_enc_blk_ctr_3way(void *ctx, u128 *dst, const u128 *src,
+				     u128 *iv)
 {
-	struct twofish_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	unsigned int bsize = TF_BLOCK_SIZE;
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
-}
+	be128 ctrblks[3];
 
-static int cbc_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
-		       struct scatterlist *src, unsigned int nbytes)
-{
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
-	unsigned int bsize = TF_BLOCK_SIZE;
-	unsigned int nbytes = walk->nbytes;
-	u128 *src = (u128 *)walk->src.virt.addr;
-	u128 *dst = (u128 *)walk->dst.virt.addr;
-	u128 ivs[3 - 1];
-	u128 last_iv;
-
-	/* Start of the last block. */
-	src += nbytes / bsize - 1;
-	dst += nbytes / bsize - 1;
-
-	last_iv = *src;
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
+	if (dst != src) {
+		dst[0] = src[0];
+		dst[1] = src[1];
+		dst[2] = src[2];
 	}
 
-done:
-	u128_xor(dst, dst, (u128 *)walk->iv);
-	*(u128 *)walk->iv = last_iv;
+	u128_to_be128(&ctrblks[0], iv);
+	u128_inc(iv);
+	u128_to_be128(&ctrblks[1], iv);
+	u128_inc(iv);
+	u128_to_be128(&ctrblks[2], iv);
+	u128_inc(iv);
 
-	return nbytes;
+	twofish_enc_blk_xor_3way(ctx, (u8 *)dst, (u8 *)ctrblks);
 }
 
-static int cbc_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
-		       struct scatterlist *src, unsigned int nbytes)
-{
-	struct blkcipher_walk walk;
-	int err;
-
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
+static const struct common_glue_ctx twofish_enc = {
+	.num_funcs = 2,
+	.fpu_blocks_limit = -1,
+
+	.funcs = { {
+		.num_blocks = 3,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_enc_blk_3way) }
+	}, {
+		.num_blocks = 1,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_enc_blk) }
+	} }
+};
 
-	while ((nbytes = walk.nbytes)) {
-		nbytes = __cbc_decrypt(desc, &walk);
-		err = blkcipher_walk_done(desc, &walk, nbytes);
-	}
+static const struct common_glue_ctx twofish_ctr = {
+	.num_funcs = 2,
+	.fpu_blocks_limit = -1,
+
+	.funcs = { {
+		.num_blocks = 3,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_enc_blk_ctr_3way) }
+	}, {
+		.num_blocks = 1,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_enc_blk_ctr) }
+	} }
+};
 
-	return err;
-}
+static const struct common_glue_ctx twofish_dec = {
+	.num_funcs = 2,
+	.fpu_blocks_limit = -1,
+
+	.funcs = { {
+		.num_blocks = 3,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_dec_blk_3way) }
+	}, {
+		.num_blocks = 1,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_dec_blk) }
+	} }
+};
 
-static inline void u128_to_be128(be128 *dst, const u128 *src)
-{
-	dst->a = cpu_to_be64(src->a);
-	dst->b = cpu_to_be64(src->b);
-}
+static const struct common_glue_ctx twofish_dec_cbc = {
+	.num_funcs = 2,
+	.fpu_blocks_limit = -1,
+
+	.funcs = { {
+		.num_blocks = 3,
+		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(twofish_dec_blk_cbc_3way) }
+	}, {
+		.num_blocks = 1,
+		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(twofish_dec_blk) }
+	} }
+};
 
-static inline void be128_to_u128(u128 *dst, const be128 *src)
+static int ecb_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
 {
-	dst->a = be64_to_cpu(src->a);
-	dst->b = be64_to_cpu(src->b);
+	return glue_ecb_crypt_128bit(&twofish_enc, desc, dst, src, nbytes);
 }
 
-static inline void u128_inc(u128 *i)
+static int ecb_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
 {
-	i->b++;
-	if (!i->b)
-		i->a++;
+	return glue_ecb_crypt_128bit(&twofish_dec, desc, dst, src, nbytes);
 }
 
-static void ctr_crypt_final(struct blkcipher_desc *desc,
-			    struct blkcipher_walk *walk)
+static int cbc_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
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
+	return glue_cbc_encrypt_128bit(GLUE_FUNC_CAST(twofish_enc_blk), desc,
+				       dst, src, nbytes);
 }
 
-static unsigned int __ctr_crypt(struct blkcipher_desc *desc,
-				struct blkcipher_walk *walk)
+static int cbc_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
 {
-	struct twofish_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	unsigned int bsize = TF_BLOCK_SIZE;
-	unsigned int nbytes = walk->nbytes;
-	u128 *src = (u128 *)walk->src.virt.addr;
-	u128 *dst = (u128 *)walk->dst.virt.addr;
-	u128 ctrblk;
-	be128 ctrblocks[3];
-
-	be128_to_u128(&ctrblk, (be128 *)walk->iv);
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
-			twofish_enc_blk_xor_3way(ctx, (u8 *)dst,
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
+	return glue_cbc_decrypt_128bit(&twofish_dec_cbc, desc, dst, src,
+				       nbytes);
 }
 
 static int ctr_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 		     struct scatterlist *src, unsigned int nbytes)
 {
-	struct blkcipher_walk walk;
-	int err;
-
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt_block(desc, &walk, TF_BLOCK_SIZE);
-
-	while ((nbytes = walk.nbytes) >= TF_BLOCK_SIZE) {
-		nbytes = __ctr_crypt(desc, &walk);
-		err = blkcipher_walk_done(desc, &walk, nbytes);
-	}
-
-	if (walk.nbytes) {
-		ctr_crypt_final(desc, &walk);
-		err = blkcipher_walk_done(desc, &walk, 0);
-	}
-
-	return err;
+	return glue_ctr_crypt_128bit(&twofish_ctr, desc, dst, src, nbytes);
 }
 
 static void encrypt_callback(void *priv, u8 *srcdst, unsigned int nbytes)
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 72828fa..fc559ca 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -935,6 +935,7 @@ config CRYPTO_TWOFISH_X86_64_3WAY
 	select CRYPTO_ALGAPI
 	select CRYPTO_TWOFISH_COMMON
 	select CRYPTO_TWOFISH_X86_64
+	select CRYPTO_GLUE_HELPER_X86
 	select CRYPTO_LRW
 	select CRYPTO_XTS
 	help
