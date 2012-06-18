From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 07/11] crypto: camellia-x86_64 - remove duplicated glue code
 and use shared glue code from glue_helper
Date: Mon, 18 Jun 2012 14:07:29 +0300
Message-ID: <20120618110729.28985.8482.stgit@localhost6.localdomain6>
References: <20120618110652.28985.70075.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:50834 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab2FRLHh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jun 2012 07:07:37 -0400
In-Reply-To: <20120618110652.28985.70075.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Now that shared glue code is available, convert camellia-x86_64 to use it.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/camellia_glue.c |  355 +++++++++------------------------------
 crypto/Kconfig                  |    1 
 2 files changed, 87 insertions(+), 269 deletions(-)

diff --git a/arch/x86/crypto/camellia_glue.c b/arch/x86/crypto/camellia_glue.c
index 3306dc0..eeb2b3b 100644
--- a/arch/x86/crypto/camellia_glue.c
+++ b/arch/x86/crypto/camellia_glue.c
@@ -5,10 +5,6 @@
  *
  * Camellia parts based on code by:
  *  Copyright (C) 2006 NTT (Nippon Telegraph and Telephone Corporation)
- * CBC & ECB parts based on code (crypto/cbc.c,ecb.c) by:
- *   Copyright (c) 2006 Herbert Xu <herbert@gondor.apana.org.au>
- * CTR part based on code (crypto/ctr.c) by:
- *   (C) Copyright IBM Corp. 2007 - Joy Latten <latten@us.ibm.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -34,9 +30,9 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <crypto/algapi.h>
-#include <crypto/b128ops.h>
 #include <crypto/lrw.h>
 #include <crypto/xts.h>
+#include <asm/crypto/glue_helper.h>
 
 #define CAMELLIA_MIN_KEY_SIZE	16
 #define CAMELLIA_MAX_KEY_SIZE	32
@@ -1312,307 +1308,128 @@ static int camellia_setkey(struct crypto_tfm *tfm, const u8 *in_key,
 				 &tfm->crt_flags);
 }
 
-static int ecb_crypt(struct blkcipher_desc *desc, struct blkcipher_walk *walk,
-		     void (*fn)(struct camellia_ctx *, u8 *, const u8 *),
-		     void (*fn_2way)(struct camellia_ctx *, u8 *, const u8 *))
+static void camellia_decrypt_cbc_2way(void *ctx, u128 *dst, const u128 *src)
 {
-	struct camellia_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	unsigned int bsize = CAMELLIA_BLOCK_SIZE;
-	unsigned int nbytes;
-	int err;
-
-	err = blkcipher_walk_virt(desc, walk);
-
-	while ((nbytes = walk->nbytes)) {
-		u8 *wsrc = walk->src.virt.addr;
-		u8 *wdst = walk->dst.virt.addr;
-
-		/* Process two block batch */
-		if (nbytes >= bsize * 2) {
-			do {
-				fn_2way(ctx, wdst, wsrc);
-
-				wsrc += bsize * 2;
-				wdst += bsize * 2;
-				nbytes -= bsize * 2;
-			} while (nbytes >= bsize * 2);
-
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
-
-	return err;
-}
-
-static int ecb_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
-		       struct scatterlist *src, unsigned int nbytes)
-{
-	struct blkcipher_walk walk;
-
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return ecb_crypt(desc, &walk, camellia_enc_blk, camellia_enc_blk_2way);
-}
+	u128 iv = *src;
 
-static int ecb_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
-		       struct scatterlist *src, unsigned int nbytes)
-{
-	struct blkcipher_walk walk;
-
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return ecb_crypt(desc, &walk, camellia_dec_blk, camellia_dec_blk_2way);
-}
+	camellia_dec_blk_2way(ctx, (u8 *)dst, (u8 *)src);
 
-static unsigned int __cbc_encrypt(struct blkcipher_desc *desc,
-				  struct blkcipher_walk *walk)
-{
-	struct camellia_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	unsigned int bsize = CAMELLIA_BLOCK_SIZE;
-	unsigned int nbytes = walk->nbytes;
-	u128 *src = (u128 *)walk->src.virt.addr;
-	u128 *dst = (u128 *)walk->dst.virt.addr;
-	u128 *iv = (u128 *)walk->iv;
-
-	do {
-		u128_xor(dst, src, iv);
-		camellia_enc_blk(ctx, (u8 *)dst, (u8 *)dst);
-		iv = dst;
-
-		src += 1;
-		dst += 1;
-		nbytes -= bsize;
-	} while (nbytes >= bsize);
-
-	u128_xor((u128 *)walk->iv, (u128 *)walk->iv, iv);
-	return nbytes;
+	u128_xor(&dst[1], &dst[1], &iv);
 }
 
-static int cbc_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
-		       struct scatterlist *src, unsigned int nbytes)
+static void camellia_crypt_ctr(void *ctx, u128 *dst, const u128 *src, u128 *iv)
 {
-	struct blkcipher_walk walk;
-	int err;
+	be128 ctrblk;
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
+	if (dst != src)
+		*dst = *src;
 
-	while ((nbytes = walk.nbytes)) {
-		nbytes = __cbc_encrypt(desc, &walk);
-		err = blkcipher_walk_done(desc, &walk, nbytes);
-	}
+	u128_to_be128(&ctrblk, iv);
+	u128_inc(iv);
 
-	return err;
+	camellia_enc_blk_xor(ctx, (u8 *)dst, (u8 *)&ctrblk);
 }
 
-static unsigned int __cbc_decrypt(struct blkcipher_desc *desc,
-				  struct blkcipher_walk *walk)
+static void camellia_crypt_ctr_2way(void *ctx, u128 *dst, const u128 *src,
+				    u128 *iv)
 {
-	struct camellia_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	unsigned int bsize = CAMELLIA_BLOCK_SIZE;
-	unsigned int nbytes = walk->nbytes;
-	u128 *src = (u128 *)walk->src.virt.addr;
-	u128 *dst = (u128 *)walk->dst.virt.addr;
-	u128 ivs[2 - 1];
-	u128 last_iv;
+	be128 ctrblks[2];
 
-	/* Start of the last block. */
-	src += nbytes / bsize - 1;
-	dst += nbytes / bsize - 1;
-
-	last_iv = *src;
-
-	/* Process two block batch */
-	if (nbytes >= bsize * 2) {
-		do {
-			nbytes -= bsize * (2 - 1);
-			src -= 2 - 1;
-			dst -= 2 - 1;
-
-			ivs[0] = src[0];
-
-			camellia_dec_blk_2way(ctx, (u8 *)dst, (u8 *)src);
-
-			u128_xor(dst + 1, dst + 1, ivs + 0);
-
-			nbytes -= bsize;
-			if (nbytes < bsize)
-				goto done;
-
-			u128_xor(dst, dst, src - 1);
-			src -= 1;
-			dst -= 1;
-		} while (nbytes >= bsize * 2);
-
-		if (nbytes < bsize)
-			goto done;
+	if (dst != src) {
+		dst[0] = src[0];
+		dst[1] = src[1];
 	}
 
-	/* Handle leftovers */
-	for (;;) {
-		camellia_dec_blk(ctx, (u8 *)dst, (u8 *)src);
-
-		nbytes -= bsize;
-		if (nbytes < bsize)
-			break;
+	u128_to_be128(&ctrblks[0], iv);
+	u128_inc(iv);
+	u128_to_be128(&ctrblks[1], iv);
+	u128_inc(iv);
 
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
+	camellia_enc_blk_xor_2way(ctx, (u8 *)dst, (u8 *)ctrblks);
 }
 
-static int cbc_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
-		       struct scatterlist *src, unsigned int nbytes)
-{
-	struct blkcipher_walk walk;
-	int err;
-
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
+static const struct common_glue_ctx camellia_enc = {
+	.num_funcs = 2,
+	.fpu_blocks_limit = -1,
+
+	.funcs = { {
+		.num_blocks = 2,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_enc_blk_2way) }
+	}, {
+		.num_blocks = 1,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_enc_blk) }
+	} }
+};
 
-	while ((nbytes = walk.nbytes)) {
-		nbytes = __cbc_decrypt(desc, &walk);
-		err = blkcipher_walk_done(desc, &walk, nbytes);
-	}
+static const struct common_glue_ctx camellia_ctr = {
+	.num_funcs = 2,
+	.fpu_blocks_limit = -1,
+
+	.funcs = { {
+		.num_blocks = 2,
+		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(camellia_crypt_ctr_2way) }
+	}, {
+		.num_blocks = 1,
+		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(camellia_crypt_ctr) }
+	} }
+};
 
-	return err;
-}
+static const struct common_glue_ctx camellia_dec = {
+	.num_funcs = 2,
+	.fpu_blocks_limit = -1,
+
+	.funcs = { {
+		.num_blocks = 2,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_dec_blk_2way) }
+	}, {
+		.num_blocks = 1,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_dec_blk) }
+	} }
+};
 
-static inline void u128_to_be128(be128 *dst, const u128 *src)
-{
-	dst->a = cpu_to_be64(src->a);
-	dst->b = cpu_to_be64(src->b);
-}
+static const struct common_glue_ctx camellia_dec_cbc = {
+	.num_funcs = 2,
+	.fpu_blocks_limit = -1,
+
+	.funcs = { {
+		.num_blocks = 2,
+		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_decrypt_cbc_2way) }
+	}, {
+		.num_blocks = 1,
+		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_dec_blk) }
+	} }
+};
 
-static inline void be128_to_u128(u128 *dst, const be128 *src)
+static int ecb_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
 {
-	dst->a = be64_to_cpu(src->a);
-	dst->b = be64_to_cpu(src->b);
+	return glue_ecb_crypt_128bit(&camellia_enc, desc, dst, src, nbytes);
 }
 
-static inline void u128_inc(u128 *i)
+static int ecb_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
 {
-	i->b++;
-	if (!i->b)
-		i->a++;
+	return glue_ecb_crypt_128bit(&camellia_dec, desc, dst, src, nbytes);
 }
 
-static void ctr_crypt_final(struct blkcipher_desc *desc,
-			    struct blkcipher_walk *walk)
+static int cbc_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
 {
-	struct camellia_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	u8 keystream[CAMELLIA_BLOCK_SIZE];
-	u8 *src = walk->src.virt.addr;
-	u8 *dst = walk->dst.virt.addr;
-	unsigned int nbytes = walk->nbytes;
-	u128 ctrblk;
-
-	memcpy(keystream, src, nbytes);
-	camellia_enc_blk_xor(ctx, keystream, walk->iv);
-	memcpy(dst, keystream, nbytes);
-
-	be128_to_u128(&ctrblk, (be128 *)walk->iv);
-	u128_inc(&ctrblk);
-	u128_to_be128((be128 *)walk->iv, &ctrblk);
+	return glue_cbc_encrypt_128bit(GLUE_FUNC_CAST(camellia_enc_blk), desc,
+				       dst, src, nbytes);
 }
 
-static unsigned int __ctr_crypt(struct blkcipher_desc *desc,
-				struct blkcipher_walk *walk)
+static int cbc_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
 {
-	struct camellia_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	unsigned int bsize = CAMELLIA_BLOCK_SIZE;
-	unsigned int nbytes = walk->nbytes;
-	u128 *src = (u128 *)walk->src.virt.addr;
-	u128 *dst = (u128 *)walk->dst.virt.addr;
-	u128 ctrblk;
-	be128 ctrblocks[2];
-
-	be128_to_u128(&ctrblk, (be128 *)walk->iv);
-
-	/* Process two block batch */
-	if (nbytes >= bsize * 2) {
-		do {
-			if (dst != src) {
-				dst[0] = src[0];
-				dst[1] = src[1];
-			}
-
-			/* create ctrblks for parallel encrypt */
-			u128_to_be128(&ctrblocks[0], &ctrblk);
-			u128_inc(&ctrblk);
-			u128_to_be128(&ctrblocks[1], &ctrblk);
-			u128_inc(&ctrblk);
-
-			camellia_enc_blk_xor_2way(ctx, (u8 *)dst,
-						 (u8 *)ctrblocks);
-
-			src += 2;
-			dst += 2;
-			nbytes -= bsize * 2;
-		} while (nbytes >= bsize * 2);
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
-		camellia_enc_blk_xor(ctx, (u8 *)dst, (u8 *)ctrblocks);
-
-		src += 1;
-		dst += 1;
-		nbytes -= bsize;
-	} while (nbytes >= bsize);
-
-done:
-	u128_to_be128((be128 *)walk->iv, &ctrblk);
-	return nbytes;
+	return glue_cbc_decrypt_128bit(&camellia_dec_cbc, desc, dst, src,
+				       nbytes);
 }
 
 static int ctr_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 		     struct scatterlist *src, unsigned int nbytes)
 {
-	struct blkcipher_walk walk;
-	int err;
-
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt_block(desc, &walk, CAMELLIA_BLOCK_SIZE);
-
-	while ((nbytes = walk.nbytes) >= CAMELLIA_BLOCK_SIZE) {
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
+	return glue_ctr_crypt_128bit(&camellia_ctr, desc, dst, src, nbytes);
 }
 
 static void encrypt_callback(void *priv, u8 *srcdst, unsigned int nbytes)
diff --git a/crypto/Kconfig b/crypto/Kconfig
index a86c2fb..72828fa 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -671,6 +671,7 @@ config CRYPTO_CAMELLIA_X86_64
 	depends on X86 && 64BIT
 	depends on CRYPTO
 	select CRYPTO_ALGAPI
+	select CRYPTO_GLUE_HELPER_X86
 	select CRYPTO_LRW
 	select CRYPTO_XTS
 	help
