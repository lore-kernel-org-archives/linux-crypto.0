Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FAF2C433E0
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jan 2021 16:50:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E0AF22CBB
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jan 2021 16:50:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728418AbhAEQuL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Jan 2021 11:50:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:44034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728499AbhAEQuL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Jan 2021 11:50:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDA1922D00;
        Tue,  5 Jan 2021 16:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609865338;
        bh=61mvMHq0AsNIhYbOTt+l55NM/1lXzwpdo+RutssceJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=riC315/Ts7q7b3QafHSLwOrqE6yDxLjSRldP/lG7yt8OfOFYv7+wmPD+htQpYgonL
         O6sON61awLnT6yKUCiq1vN5Ee9fynCLVmGyYx62y04+7APbuskXhVcec1vrF09an/2
         3zIbl3Rxg9JB6Y2d9lsSygi4CSMXJ3PWQ+9ghCR5Y8yFGy6JszNtVAh9uRcs6qEIJJ
         viK8wEbTa3NEP5EmJj/4bG/IWl50VqMO938eMruh28J1nqfn4QV9qJQCoJpKb1NYLc
         Hl75acqLvQeIKnuJ7bh7RMLDEzL7h+S/ZdDSfFDsPmpDE3S19btPvkTBPYAZYogFhM
         4rmEeoZnSyu4A==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 05/21] crypto: x86/glue-helper - drop XTS helper routines
Date:   Tue,  5 Jan 2021 17:47:53 +0100
Message-Id: <20210105164809.8594-6-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210105164809.8594-1-ardb@kernel.org>
References: <20210105164809.8594-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The glue helper's XTS routines are no longer used, so drop them.

Acked-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/glue_helper-asm-avx.S     |  59 --------
 arch/x86/crypto/glue_helper-asm-avx2.S    |  78 ----------
 arch/x86/crypto/glue_helper.c             | 154 --------------------
 arch/x86/include/asm/crypto/glue_helper.h |  12 --
 4 files changed, 303 deletions(-)

diff --git a/arch/x86/crypto/glue_helper-asm-avx.S b/arch/x86/crypto/glue_helper-asm-avx.S
index d08fc575ef7f..a94511432803 100644
--- a/arch/x86/crypto/glue_helper-asm-avx.S
+++ b/arch/x86/crypto/glue_helper-asm-avx.S
@@ -79,62 +79,3 @@
 	vpxor (6*16)(src), x6, x6; \
 	vpxor (7*16)(src), x7, x7; \
 	store_8way(dst, x0, x1, x2, x3, x4, x5, x6, x7);
-
-#define gf128mul_x_ble(iv, mask, tmp) \
-	vpsrad $31, iv, tmp; \
-	vpaddq iv, iv, iv; \
-	vpshufd $0x13, tmp, tmp; \
-	vpand mask, tmp, tmp; \
-	vpxor tmp, iv, iv;
-
-#define load_xts_8way(iv, src, dst, x0, x1, x2, x3, x4, x5, x6, x7, tiv, t0, \
-		      t1, xts_gf128mul_and_shl1_mask) \
-	vmovdqa xts_gf128mul_and_shl1_mask, t0; \
-	\
-	/* load IV */ \
-	vmovdqu (iv), tiv; \
-	vpxor (0*16)(src), tiv, x0; \
-	vmovdqu tiv, (0*16)(dst); \
-	\
-	/* construct and store IVs, also xor with source */ \
-	gf128mul_x_ble(tiv, t0, t1); \
-	vpxor (1*16)(src), tiv, x1; \
-	vmovdqu tiv, (1*16)(dst); \
-	\
-	gf128mul_x_ble(tiv, t0, t1); \
-	vpxor (2*16)(src), tiv, x2; \
-	vmovdqu tiv, (2*16)(dst); \
-	\
-	gf128mul_x_ble(tiv, t0, t1); \
-	vpxor (3*16)(src), tiv, x3; \
-	vmovdqu tiv, (3*16)(dst); \
-	\
-	gf128mul_x_ble(tiv, t0, t1); \
-	vpxor (4*16)(src), tiv, x4; \
-	vmovdqu tiv, (4*16)(dst); \
-	\
-	gf128mul_x_ble(tiv, t0, t1); \
-	vpxor (5*16)(src), tiv, x5; \
-	vmovdqu tiv, (5*16)(dst); \
-	\
-	gf128mul_x_ble(tiv, t0, t1); \
-	vpxor (6*16)(src), tiv, x6; \
-	vmovdqu tiv, (6*16)(dst); \
-	\
-	gf128mul_x_ble(tiv, t0, t1); \
-	vpxor (7*16)(src), tiv, x7; \
-	vmovdqu tiv, (7*16)(dst); \
-	\
-	gf128mul_x_ble(tiv, t0, t1); \
-	vmovdqu tiv, (iv);
-
-#define store_xts_8way(dst, x0, x1, x2, x3, x4, x5, x6, x7) \
-	vpxor (0*16)(dst), x0, x0; \
-	vpxor (1*16)(dst), x1, x1; \
-	vpxor (2*16)(dst), x2, x2; \
-	vpxor (3*16)(dst), x3, x3; \
-	vpxor (4*16)(dst), x4, x4; \
-	vpxor (5*16)(dst), x5, x5; \
-	vpxor (6*16)(dst), x6, x6; \
-	vpxor (7*16)(dst), x7, x7; \
-	store_8way(dst, x0, x1, x2, x3, x4, x5, x6, x7);
diff --git a/arch/x86/crypto/glue_helper-asm-avx2.S b/arch/x86/crypto/glue_helper-asm-avx2.S
index d84508c85c13..456bface1e5d 100644
--- a/arch/x86/crypto/glue_helper-asm-avx2.S
+++ b/arch/x86/crypto/glue_helper-asm-avx2.S
@@ -95,81 +95,3 @@
 	vpxor (6*32)(src), x6, x6; \
 	vpxor (7*32)(src), x7, x7; \
 	store_16way(dst, x0, x1, x2, x3, x4, x5, x6, x7);
-
-#define gf128mul_x_ble(iv, mask, tmp) \
-	vpsrad $31, iv, tmp; \
-	vpaddq iv, iv, iv; \
-	vpshufd $0x13, tmp, tmp; \
-	vpand mask, tmp, tmp; \
-	vpxor tmp, iv, iv;
-
-#define gf128mul_x2_ble(iv, mask1, mask2, tmp0, tmp1) \
-	vpsrad $31, iv, tmp0; \
-	vpaddq iv, iv, tmp1; \
-	vpsllq $2, iv, iv; \
-	vpshufd $0x13, tmp0, tmp0; \
-	vpsrad $31, tmp1, tmp1; \
-	vpand mask2, tmp0, tmp0; \
-	vpshufd $0x13, tmp1, tmp1; \
-	vpxor tmp0, iv, iv; \
-	vpand mask1, tmp1, tmp1; \
-	vpxor tmp1, iv, iv;
-
-#define load_xts_16way(iv, src, dst, x0, x1, x2, x3, x4, x5, x6, x7, tiv, \
-		       tivx, t0, t0x, t1, t1x, t2, t2x, t3, \
-		       xts_gf128mul_and_shl1_mask_0, \
-		       xts_gf128mul_and_shl1_mask_1) \
-	vbroadcasti128 xts_gf128mul_and_shl1_mask_0, t1; \
-	\
-	/* load IV and construct second IV */ \
-	vmovdqu (iv), tivx; \
-	vmovdqa tivx, t0x; \
-	gf128mul_x_ble(tivx, t1x, t2x); \
-	vbroadcasti128 xts_gf128mul_and_shl1_mask_1, t2; \
-	vinserti128 $1, tivx, t0, tiv; \
-	vpxor (0*32)(src), tiv, x0; \
-	vmovdqu tiv, (0*32)(dst); \
-	\
-	/* construct and store IVs, also xor with source */ \
-	gf128mul_x2_ble(tiv, t1, t2, t0, t3); \
-	vpxor (1*32)(src), tiv, x1; \
-	vmovdqu tiv, (1*32)(dst); \
-	\
-	gf128mul_x2_ble(tiv, t1, t2, t0, t3); \
-	vpxor (2*32)(src), tiv, x2; \
-	vmovdqu tiv, (2*32)(dst); \
-	\
-	gf128mul_x2_ble(tiv, t1, t2, t0, t3); \
-	vpxor (3*32)(src), tiv, x3; \
-	vmovdqu tiv, (3*32)(dst); \
-	\
-	gf128mul_x2_ble(tiv, t1, t2, t0, t3); \
-	vpxor (4*32)(src), tiv, x4; \
-	vmovdqu tiv, (4*32)(dst); \
-	\
-	gf128mul_x2_ble(tiv, t1, t2, t0, t3); \
-	vpxor (5*32)(src), tiv, x5; \
-	vmovdqu tiv, (5*32)(dst); \
-	\
-	gf128mul_x2_ble(tiv, t1, t2, t0, t3); \
-	vpxor (6*32)(src), tiv, x6; \
-	vmovdqu tiv, (6*32)(dst); \
-	\
-	gf128mul_x2_ble(tiv, t1, t2, t0, t3); \
-	vpxor (7*32)(src), tiv, x7; \
-	vmovdqu tiv, (7*32)(dst); \
-	\
-	vextracti128 $1, tiv, tivx; \
-	gf128mul_x_ble(tivx, t1x, t2x); \
-	vmovdqu tivx, (iv);
-
-#define store_xts_16way(dst, x0, x1, x2, x3, x4, x5, x6, x7) \
-	vpxor (0*32)(dst), x0, x0; \
-	vpxor (1*32)(dst), x1, x1; \
-	vpxor (2*32)(dst), x2, x2; \
-	vpxor (3*32)(dst), x3, x3; \
-	vpxor (4*32)(dst), x4, x4; \
-	vpxor (5*32)(dst), x5, x5; \
-	vpxor (6*32)(dst), x6, x6; \
-	vpxor (7*32)(dst), x7, x7; \
-	store_16way(dst, x0, x1, x2, x3, x4, x5, x6, x7);
diff --git a/arch/x86/crypto/glue_helper.c b/arch/x86/crypto/glue_helper.c
index d3d91a0abf88..786ffda1caf4 100644
--- a/arch/x86/crypto/glue_helper.c
+++ b/arch/x86/crypto/glue_helper.c
@@ -12,10 +12,8 @@
 
 #include <linux/module.h>
 #include <crypto/b128ops.h>
-#include <crypto/gf128mul.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
-#include <crypto/xts.h>
 #include <asm/crypto/glue_helper.h>
 
 int glue_ecb_req_128bit(const struct common_glue_ctx *gctx,
@@ -226,156 +224,4 @@ int glue_ctr_req_128bit(const struct common_glue_ctx *gctx,
 }
 EXPORT_SYMBOL_GPL(glue_ctr_req_128bit);
 
-static unsigned int __glue_xts_req_128bit(const struct common_glue_ctx *gctx,
-					  void *ctx,
-					  struct skcipher_walk *walk)
-{
-	const unsigned int bsize = 128 / 8;
-	unsigned int nbytes = walk->nbytes;
-	u128 *src = walk->src.virt.addr;
-	u128 *dst = walk->dst.virt.addr;
-	unsigned int num_blocks, func_bytes;
-	unsigned int i;
-
-	/* Process multi-block batch */
-	for (i = 0; i < gctx->num_funcs; i++) {
-		num_blocks = gctx->funcs[i].num_blocks;
-		func_bytes = bsize * num_blocks;
-
-		if (nbytes >= func_bytes) {
-			do {
-				gctx->funcs[i].fn_u.xts(ctx, (u8 *)dst,
-							(const u8 *)src,
-							walk->iv);
-
-				src += num_blocks;
-				dst += num_blocks;
-				nbytes -= func_bytes;
-			} while (nbytes >= func_bytes);
-
-			if (nbytes < bsize)
-				goto done;
-		}
-	}
-
-done:
-	return nbytes;
-}
-
-int glue_xts_req_128bit(const struct common_glue_ctx *gctx,
-			struct skcipher_request *req,
-			common_glue_func_t tweak_fn, void *tweak_ctx,
-			void *crypt_ctx, bool decrypt)
-{
-	const bool cts = (req->cryptlen % XTS_BLOCK_SIZE);
-	const unsigned int bsize = 128 / 8;
-	struct skcipher_request subreq;
-	struct skcipher_walk walk;
-	bool fpu_enabled = false;
-	unsigned int nbytes, tail;
-	int err;
-
-	if (req->cryptlen < XTS_BLOCK_SIZE)
-		return -EINVAL;
-
-	if (unlikely(cts)) {
-		struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-
-		tail = req->cryptlen % XTS_BLOCK_SIZE + XTS_BLOCK_SIZE;
-
-		skcipher_request_set_tfm(&subreq, tfm);
-		skcipher_request_set_callback(&subreq,
-					      crypto_skcipher_get_flags(tfm),
-					      NULL, NULL);
-		skcipher_request_set_crypt(&subreq, req->src, req->dst,
-					   req->cryptlen - tail, req->iv);
-		req = &subreq;
-	}
-
-	err = skcipher_walk_virt(&walk, req, false);
-	nbytes = walk.nbytes;
-	if (err)
-		return err;
-
-	/* set minimum length to bsize, for tweak_fn */
-	fpu_enabled = glue_fpu_begin(bsize, gctx->fpu_blocks_limit,
-				     &walk, fpu_enabled,
-				     nbytes < bsize ? bsize : nbytes);
-
-	/* calculate first value of T */
-	tweak_fn(tweak_ctx, walk.iv, walk.iv);
-
-	while (nbytes) {
-		nbytes = __glue_xts_req_128bit(gctx, crypt_ctx, &walk);
-
-		err = skcipher_walk_done(&walk, nbytes);
-		nbytes = walk.nbytes;
-	}
-
-	if (unlikely(cts)) {
-		u8 *next_tweak, *final_tweak = req->iv;
-		struct scatterlist *src, *dst;
-		struct scatterlist s[2], d[2];
-		le128 b[2];
-
-		dst = src = scatterwalk_ffwd(s, req->src, req->cryptlen);
-		if (req->dst != req->src)
-			dst = scatterwalk_ffwd(d, req->dst, req->cryptlen);
-
-		if (decrypt) {
-			next_tweak = memcpy(b, req->iv, XTS_BLOCK_SIZE);
-			gf128mul_x_ble(b, b);
-		} else {
-			next_tweak = req->iv;
-		}
-
-		skcipher_request_set_crypt(&subreq, src, dst, XTS_BLOCK_SIZE,
-					   next_tweak);
-
-		err = skcipher_walk_virt(&walk, req, false) ?:
-		      skcipher_walk_done(&walk,
-				__glue_xts_req_128bit(gctx, crypt_ctx, &walk));
-		if (err)
-			goto out;
-
-		scatterwalk_map_and_copy(b, dst, 0, XTS_BLOCK_SIZE, 0);
-		memcpy(b + 1, b, tail - XTS_BLOCK_SIZE);
-		scatterwalk_map_and_copy(b, src, XTS_BLOCK_SIZE,
-					 tail - XTS_BLOCK_SIZE, 0);
-		scatterwalk_map_and_copy(b, dst, 0, tail, 1);
-
-		skcipher_request_set_crypt(&subreq, dst, dst, XTS_BLOCK_SIZE,
-					   final_tweak);
-
-		err = skcipher_walk_virt(&walk, req, false) ?:
-		      skcipher_walk_done(&walk,
-				__glue_xts_req_128bit(gctx, crypt_ctx, &walk));
-	}
-
-out:
-	glue_fpu_end(fpu_enabled);
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(glue_xts_req_128bit);
-
-void glue_xts_crypt_128bit_one(const void *ctx, u8 *dst, const u8 *src,
-			       le128 *iv, common_glue_func_t fn)
-{
-	le128 ivblk = *iv;
-
-	/* generate next IV */
-	gf128mul_x_ble(iv, &ivblk);
-
-	/* CC <- T xor C */
-	u128_xor((u128 *)dst, (const u128 *)src, (u128 *)&ivblk);
-
-	/* PP <- D(Key2,CC) */
-	fn(ctx, dst, dst);
-
-	/* P <- T xor PP */
-	u128_xor((u128 *)dst, (u128 *)dst, (u128 *)&ivblk);
-}
-EXPORT_SYMBOL_GPL(glue_xts_crypt_128bit_one);
-
 MODULE_LICENSE("GPL");
diff --git a/arch/x86/include/asm/crypto/glue_helper.h b/arch/x86/include/asm/crypto/glue_helper.h
index 777c0f63418c..62680775d189 100644
--- a/arch/x86/include/asm/crypto/glue_helper.h
+++ b/arch/x86/include/asm/crypto/glue_helper.h
@@ -15,8 +15,6 @@ typedef void (*common_glue_func_t)(const void *ctx, u8 *dst, const u8 *src);
 typedef void (*common_glue_cbc_func_t)(const void *ctx, u8 *dst, const u8 *src);
 typedef void (*common_glue_ctr_func_t)(const void *ctx, u8 *dst, const u8 *src,
 				       le128 *iv);
-typedef void (*common_glue_xts_func_t)(const void *ctx, u8 *dst, const u8 *src,
-				       le128 *iv);
 
 struct common_glue_func_entry {
 	unsigned int num_blocks; /* number of blocks that @fn will process */
@@ -24,7 +22,6 @@ struct common_glue_func_entry {
 		common_glue_func_t ecb;
 		common_glue_cbc_func_t cbc;
 		common_glue_ctr_func_t ctr;
-		common_glue_xts_func_t xts;
 	} fn_u;
 };
 
@@ -106,13 +103,4 @@ extern int glue_cbc_decrypt_req_128bit(const struct common_glue_ctx *gctx,
 extern int glue_ctr_req_128bit(const struct common_glue_ctx *gctx,
 			       struct skcipher_request *req);
 
-extern int glue_xts_req_128bit(const struct common_glue_ctx *gctx,
-			       struct skcipher_request *req,
-			       common_glue_func_t tweak_fn, void *tweak_ctx,
-			       void *crypt_ctx, bool decrypt);
-
-extern void glue_xts_crypt_128bit_one(const void *ctx, u8 *dst,
-				      const u8 *src, le128 *iv,
-				      common_glue_func_t fn);
-
 #endif /* _CRYPTO_GLUE_HELPER_H */
-- 
2.17.1

