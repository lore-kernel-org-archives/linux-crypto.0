From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 06/11] crypto: serpent-avx: remove duplicated glue code and
 use shared glue code from glue_helper
Date: Mon, 18 Jun 2012 14:07:24 +0300
Message-ID: <20120618110724.28985.89866.stgit@localhost6.localdomain6>
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
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:58439 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab2FRLH1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jun 2012 07:07:27 -0400
In-Reply-To: <20120618110652.28985.70075.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Now that shared glue code is available, convert serpent-avx to use it.

Cc: Johannes Goetzfried <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/serpent_avx_glue.c |  398 +++++++++---------------------------
 crypto/Kconfig                     |    1 
 2 files changed, 95 insertions(+), 304 deletions(-)

diff --git a/arch/x86/crypto/serpent_avx_glue.c b/arch/x86/crypto/serpent_avx_glue.c
index 31eb567..c61b91a 100644
--- a/arch/x86/crypto/serpent_avx_glue.c
+++ b/arch/x86/crypto/serpent_avx_glue.c
@@ -36,357 +36,147 @@
 #include <crypto/ctr.h>
 #include <crypto/lrw.h>
 #include <crypto/xts.h>
-#include <asm/i387.h>
 #include <asm/xcr.h>
 #include <asm/xsave.h>
 #include <asm/serpent-avx.h>
 #include <asm/crypto/ablk_helper.h>
-#include <crypto/scatterwalk.h>
-#include <linux/workqueue.h>
-#include <linux/spinlock.h>
+#include <asm/crypto/glue_helper.h>
 
-static inline bool serpent_fpu_begin(bool fpu_enabled, unsigned int nbytes)
+static void serpent_decrypt_cbc_xway(void *ctx, u128 *dst, const u128 *src)
 {
-	if (fpu_enabled)
-		return true;
-
-	/* AVX is only used when chunk to be processed is large enough, so
-	 * do not enable FPU until it is necessary.
-	 */
-	if (nbytes < SERPENT_BLOCK_SIZE * SERPENT_PARALLEL_BLOCKS)
-		return false;
-
-	kernel_fpu_begin();
-	return true;
-}
-
-static inline void serpent_fpu_end(bool fpu_enabled)
-{
-	if (fpu_enabled)
-		kernel_fpu_end();
-}
-
-static int ecb_crypt(struct blkcipher_desc *desc, struct blkcipher_walk *walk,
-		     bool enc)
-{
-	bool fpu_enabled = false;
-	struct serpent_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	const unsigned int bsize = SERPENT_BLOCK_SIZE;
-	unsigned int nbytes;
-	int err;
+	u128 ivs[SERPENT_PARALLEL_BLOCKS - 1];
+	unsigned int j;
 
-	err = blkcipher_walk_virt(desc, walk);
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	for (j = 0; j < SERPENT_PARALLEL_BLOCKS - 1; j++)
+		ivs[j] = src[j];
 
-	while ((nbytes = walk->nbytes)) {
-		u8 *wsrc = walk->src.virt.addr;
-		u8 *wdst = walk->dst.virt.addr;
-
-		fpu_enabled = serpent_fpu_begin(fpu_enabled, nbytes);
-
-		/* Process multi-block batch */
-		if (nbytes >= bsize * SERPENT_PARALLEL_BLOCKS) {
-			do {
-				if (enc)
-					serpent_enc_blk_xway(ctx, wdst, wsrc);
-				else
-					serpent_dec_blk_xway(ctx, wdst, wsrc);
-
-				wsrc += bsize * SERPENT_PARALLEL_BLOCKS;
-				wdst += bsize * SERPENT_PARALLEL_BLOCKS;
-				nbytes -= bsize * SERPENT_PARALLEL_BLOCKS;
-			} while (nbytes >= bsize * SERPENT_PARALLEL_BLOCKS);
-
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
-
-			wsrc += bsize;
-			wdst += bsize;
-			nbytes -= bsize;
-		} while (nbytes >= bsize);
-
-done:
-		err = blkcipher_walk_done(desc, walk, nbytes);
-	}
+	serpent_dec_blk_xway(ctx, (u8 *)dst, (u8 *)src);
 
-	serpent_fpu_end(fpu_enabled);
-	return err;
+	for (j = 0; j < SERPENT_PARALLEL_BLOCKS - 1; j++)
+		u128_xor(dst + (j + 1), dst + (j + 1), ivs + j);
 }
 
-static int ecb_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
-		       struct scatterlist *src, unsigned int nbytes)
+static void serpent_crypt_ctr(void *ctx, u128 *dst, const u128 *src, u128 *iv)
 {
-	struct blkcipher_walk walk;
-
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return ecb_crypt(desc, &walk, true);
-}
+	be128 ctrblk;
 
-static int ecb_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
-		       struct scatterlist *src, unsigned int nbytes)
-{
-	struct blkcipher_walk walk;
+	u128_to_be128(&ctrblk, iv);
+	u128_inc(iv);
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return ecb_crypt(desc, &walk, false);
+	__serpent_encrypt(ctx, (u8 *)&ctrblk, (u8 *)&ctrblk);
+	u128_xor(dst, src, (u128 *)&ctrblk);
 }
 
-static unsigned int __cbc_encrypt(struct blkcipher_desc *desc,
-				  struct blkcipher_walk *walk)
+static void serpent_crypt_ctr_xway(void *ctx, u128 *dst, const u128 *src,
+				   u128 *iv)
 {
-	struct serpent_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	const unsigned int bsize = SERPENT_BLOCK_SIZE;
-	unsigned int nbytes = walk->nbytes;
-	u128 *src = (u128 *)walk->src.virt.addr;
-	u128 *dst = (u128 *)walk->dst.virt.addr;
-	u128 *iv = (u128 *)walk->iv;
-
-	do {
-		u128_xor(dst, src, iv);
-		__serpent_encrypt(ctx, (u8 *)dst, (u8 *)dst);
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
+	be128 ctrblks[SERPENT_PARALLEL_BLOCKS];
+	unsigned int i;
 
-static int cbc_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
-		       struct scatterlist *src, unsigned int nbytes)
-{
-	struct blkcipher_walk walk;
-	int err;
-
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
+	for (i = 0; i < SERPENT_PARALLEL_BLOCKS; i++) {
+		if (dst != src)
+			dst[i] = src[i];
 
-	while ((nbytes = walk.nbytes)) {
-		nbytes = __cbc_encrypt(desc, &walk);
-		err = blkcipher_walk_done(desc, &walk, nbytes);
+		u128_to_be128(&ctrblks[i], iv);
+		u128_inc(iv);
 	}
 
-	return err;
+	serpent_enc_blk_xway_xor(ctx, (u8 *)dst, (u8 *)ctrblks);
 }
 
-static unsigned int __cbc_decrypt(struct blkcipher_desc *desc,
-				  struct blkcipher_walk *walk)
-{
-	struct serpent_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	const unsigned int bsize = SERPENT_BLOCK_SIZE;
-	unsigned int nbytes = walk->nbytes;
-	u128 *src = (u128 *)walk->src.virt.addr;
-	u128 *dst = (u128 *)walk->dst.virt.addr;
-	u128 ivs[SERPENT_PARALLEL_BLOCKS - 1];
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
-	if (nbytes >= bsize * SERPENT_PARALLEL_BLOCKS) {
-		do {
-			nbytes -= bsize * (SERPENT_PARALLEL_BLOCKS - 1);
-			src -= SERPENT_PARALLEL_BLOCKS - 1;
-			dst -= SERPENT_PARALLEL_BLOCKS - 1;
-
-			for (i = 0; i < SERPENT_PARALLEL_BLOCKS - 1; i++)
-				ivs[i] = src[i];
-
-			serpent_dec_blk_xway(ctx, (u8 *)dst, (u8 *)src);
-
-			for (i = 0; i < SERPENT_PARALLEL_BLOCKS - 1; i++)
-				u128_xor(dst + (i + 1), dst + (i + 1), ivs + i);
-
-			nbytes -= bsize;
-			if (nbytes < bsize)
-				goto done;
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
 
-		u128_xor(dst, dst, src - 1);
-		src -= 1;
-		dst -= 1;
-	}
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
 
-done:
-	u128_xor(dst, dst, (u128 *)walk->iv);
-	*(u128 *)walk->iv = last_iv;
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
 
-	return nbytes;
-}
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
 
-static int cbc_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+static int ecb_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
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
-		fpu_enabled = serpent_fpu_begin(fpu_enabled, nbytes);
-		nbytes = __cbc_decrypt(desc, &walk);
-		err = blkcipher_walk_done(desc, &walk, nbytes);
-	}
-
-	serpent_fpu_end(fpu_enabled);
-	return err;
+	return glue_ecb_crypt_128bit(&serpent_enc, desc, dst, src, nbytes);
 }
 
-static inline void u128_to_be128(be128 *dst, const u128 *src)
+static int ecb_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
 {
-	dst->a = cpu_to_be64(src->a);
-	dst->b = cpu_to_be64(src->b);
+	return glue_ecb_crypt_128bit(&serpent_dec, desc, dst, src, nbytes);
 }
 
-static inline void be128_to_u128(u128 *dst, const be128 *src)
+static int cbc_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
 {
-	dst->a = be64_to_cpu(src->a);
-	dst->b = be64_to_cpu(src->b);
+	return glue_cbc_encrypt_128bit(GLUE_FUNC_CAST(__serpent_encrypt), desc,
+				     dst, src, nbytes);
 }
 
-static inline void u128_inc(u128 *i)
+static int cbc_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
 {
-	i->b++;
-	if (!i->b)
-		i->a++;
+	return glue_cbc_decrypt_128bit(&serpent_dec_cbc, desc, dst, src,
+				       nbytes);
 }
 
-static void ctr_crypt_final(struct blkcipher_desc *desc,
-			    struct blkcipher_walk *walk)
+static int ctr_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		     struct scatterlist *src, unsigned int nbytes)
 {
-	struct serpent_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	u8 *ctrblk = walk->iv;
-	u8 keystream[SERPENT_BLOCK_SIZE];
-	u8 *src = walk->src.virt.addr;
-	u8 *dst = walk->dst.virt.addr;
-	unsigned int nbytes = walk->nbytes;
-
-	__serpent_encrypt(ctx, keystream, ctrblk);
-	crypto_xor(keystream, src, nbytes);
-	memcpy(dst, keystream, nbytes);
-
-	crypto_inc(ctrblk, SERPENT_BLOCK_SIZE);
+	return glue_ctr_crypt_128bit(&serpent_ctr, desc, dst, src, nbytes);
 }
 
-static unsigned int __ctr_crypt(struct blkcipher_desc *desc,
-				struct blkcipher_walk *walk)
+static inline bool serpent_fpu_begin(bool fpu_enabled, unsigned int nbytes)
 {
-	struct serpent_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	const unsigned int bsize = SERPENT_BLOCK_SIZE;
-	unsigned int nbytes = walk->nbytes;
-	u128 *src = (u128 *)walk->src.virt.addr;
-	u128 *dst = (u128 *)walk->dst.virt.addr;
-	u128 ctrblk;
-	be128 ctrblocks[SERPENT_PARALLEL_BLOCKS];
-	int i;
-
-	be128_to_u128(&ctrblk, (be128 *)walk->iv);
-
-	/* Process multi-block batch */
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
-
-			serpent_enc_blk_xway_xor(ctx, (u8 *)dst,
-						 (u8 *)ctrblocks);
-
-			src += SERPENT_PARALLEL_BLOCKS;
-			dst += SERPENT_PARALLEL_BLOCKS;
-			nbytes -= bsize * SERPENT_PARALLEL_BLOCKS;
-		} while (nbytes >= bsize * SERPENT_PARALLEL_BLOCKS);
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
-		__serpent_encrypt(ctx, (u8 *)ctrblocks, (u8 *)ctrblocks);
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
+	return glue_fpu_begin(SERPENT_BLOCK_SIZE, SERPENT_PARALLEL_BLOCKS,
+			      NULL, fpu_enabled, nbytes);
 }
 
-static int ctr_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
-		     struct scatterlist *src, unsigned int nbytes)
+static inline void serpent_fpu_end(bool fpu_enabled)
 {
-	bool fpu_enabled = false;
-	struct blkcipher_walk walk;
-	int err;
-
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt_block(desc, &walk, SERPENT_BLOCK_SIZE);
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
-
-	while ((nbytes = walk.nbytes) >= SERPENT_BLOCK_SIZE) {
-		fpu_enabled = serpent_fpu_begin(fpu_enabled, nbytes);
-		nbytes = __ctr_crypt(desc, &walk);
-		err = blkcipher_walk_done(desc, &walk, nbytes);
-	}
-
-	serpent_fpu_end(fpu_enabled);
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
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 92b4697..a86c2fb 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -842,6 +842,7 @@ config CRYPTO_SERPENT_AVX_X86_64
 	select CRYPTO_ALGAPI
 	select CRYPTO_CRYPTD
 	select CRYPTO_ABLK_HELPER_X86
+	select CRYPTO_GLUE_HELPER_X86
 	select CRYPTO_SERPENT
 	select CRYPTO_LRW
 	select CRYPTO_XTS
