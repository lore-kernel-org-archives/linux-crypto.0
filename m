Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB43BC43331
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 17:25:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C12072246B
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 17:25:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgLaRZT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Dec 2020 12:25:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:55082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727008AbgLaRZT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Dec 2020 12:25:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 493D122483;
        Thu, 31 Dec 2020 17:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609435455;
        bh=LZJ5rT51wGaVrRzcx+bBG8RjvAZl7QeBAeeLpY6Y61o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ti9uoHWu5lLCiytbQe7648trnlnImnJaLzb3VgQisH6cz2Uw5hfwz0EU3zV+HS+io
         QYEWe3KmUp8fvb20kFmS8KLjEb6xGcm2GO381EE8OEo/98tF20qSUL/luYIcGr8Jb5
         5dv1mED0Z50+Tz+uErLVfCxuYbtS3fvNjrp4SLjYFQL3WjLpHy19QrdSfAWdcH7WZs
         Sb66yWssAppPibT9ohWmooT4FvQEpfaMnraG5IerAehFLQUXjzVMAeBCUU7jY5ATZc
         OM32xNFw+OphRNLs9beD7POuf1snqCxgwM58j3uwQCYQ7q4dZ4UyNWOkcABJYLUwlt
         MjSEVMcUZHwdA==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 11/21] crypto: x86/glue-helper - drop CTR helper routines
Date:   Thu, 31 Dec 2020 18:23:27 +0100
Message-Id: <20201231172337.23073-12-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201231172337.23073-1-ardb@kernel.org>
References: <20201231172337.23073-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The glue helper's CTR routines are no longer used, so drop them.

Acked-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/glue_helper-asm-avx.S     | 45 ------------
 arch/x86/crypto/glue_helper-asm-avx2.S    | 58 ----------------
 arch/x86/crypto/glue_helper.c             | 72 --------------------
 arch/x86/include/asm/crypto/glue_helper.h | 32 ---------
 4 files changed, 207 deletions(-)

diff --git a/arch/x86/crypto/glue_helper-asm-avx.S b/arch/x86/crypto/glue_helper-asm-avx.S
index a94511432803..3da385271227 100644
--- a/arch/x86/crypto/glue_helper-asm-avx.S
+++ b/arch/x86/crypto/glue_helper-asm-avx.S
@@ -34,48 +34,3 @@
 	vpxor (5*16)(src), x6, x6; \
 	vpxor (6*16)(src), x7, x7; \
 	store_8way(dst, x0, x1, x2, x3, x4, x5, x6, x7);
-
-#define inc_le128(x, minus_one, tmp) \
-	vpcmpeqq minus_one, x, tmp; \
-	vpsubq minus_one, x, x; \
-	vpslldq $8, tmp, tmp; \
-	vpsubq tmp, x, x;
-
-#define load_ctr_8way(iv, bswap, x0, x1, x2, x3, x4, x5, x6, x7, t0, t1, t2) \
-	vpcmpeqd t0, t0, t0; \
-	vpsrldq $8, t0, t0; /* low: -1, high: 0 */ \
-	vmovdqa bswap, t1; \
-	\
-	/* load IV and byteswap */ \
-	vmovdqu (iv), x7; \
-	vpshufb t1, x7, x0; \
-	\
-	/* construct IVs */ \
-	inc_le128(x7, t0, t2); \
-	vpshufb t1, x7, x1; \
-	inc_le128(x7, t0, t2); \
-	vpshufb t1, x7, x2; \
-	inc_le128(x7, t0, t2); \
-	vpshufb t1, x7, x3; \
-	inc_le128(x7, t0, t2); \
-	vpshufb t1, x7, x4; \
-	inc_le128(x7, t0, t2); \
-	vpshufb t1, x7, x5; \
-	inc_le128(x7, t0, t2); \
-	vpshufb t1, x7, x6; \
-	inc_le128(x7, t0, t2); \
-	vmovdqa x7, t2; \
-	vpshufb t1, x7, x7; \
-	inc_le128(t2, t0, t1); \
-	vmovdqu t2, (iv);
-
-#define store_ctr_8way(src, dst, x0, x1, x2, x3, x4, x5, x6, x7) \
-	vpxor (0*16)(src), x0, x0; \
-	vpxor (1*16)(src), x1, x1; \
-	vpxor (2*16)(src), x2, x2; \
-	vpxor (3*16)(src), x3, x3; \
-	vpxor (4*16)(src), x4, x4; \
-	vpxor (5*16)(src), x5, x5; \
-	vpxor (6*16)(src), x6, x6; \
-	vpxor (7*16)(src), x7, x7; \
-	store_8way(dst, x0, x1, x2, x3, x4, x5, x6, x7);
diff --git a/arch/x86/crypto/glue_helper-asm-avx2.S b/arch/x86/crypto/glue_helper-asm-avx2.S
index 456bface1e5d..c77e9049431f 100644
--- a/arch/x86/crypto/glue_helper-asm-avx2.S
+++ b/arch/x86/crypto/glue_helper-asm-avx2.S
@@ -37,61 +37,3 @@
 	vpxor (5*32+16)(src), x6, x6; \
 	vpxor (6*32+16)(src), x7, x7; \
 	store_16way(dst, x0, x1, x2, x3, x4, x5, x6, x7);
-
-#define inc_le128(x, minus_one, tmp) \
-	vpcmpeqq minus_one, x, tmp; \
-	vpsubq minus_one, x, x; \
-	vpslldq $8, tmp, tmp; \
-	vpsubq tmp, x, x;
-
-#define add2_le128(x, minus_one, minus_two, tmp1, tmp2) \
-	vpcmpeqq minus_one, x, tmp1; \
-	vpcmpeqq minus_two, x, tmp2; \
-	vpsubq minus_two, x, x; \
-	vpor tmp2, tmp1, tmp1; \
-	vpslldq $8, tmp1, tmp1; \
-	vpsubq tmp1, x, x;
-
-#define load_ctr_16way(iv, bswap, x0, x1, x2, x3, x4, x5, x6, x7, t0, t0x, t1, \
-		       t1x, t2, t2x, t3, t3x, t4, t5) \
-	vpcmpeqd t0, t0, t0; \
-	vpsrldq $8, t0, t0; /* ab: -1:0 ; cd: -1:0 */ \
-	vpaddq t0, t0, t4; /* ab: -2:0 ; cd: -2:0 */\
-	\
-	/* load IV and byteswap */ \
-	vmovdqu (iv), t2x; \
-	vmovdqa t2x, t3x; \
-	inc_le128(t2x, t0x, t1x); \
-	vbroadcasti128 bswap, t1; \
-	vinserti128 $1, t2x, t3, t2; /* ab: le0 ; cd: le1 */ \
-	vpshufb t1, t2, x0; \
-	\
-	/* construct IVs */ \
-	add2_le128(t2, t0, t4, t3, t5); /* ab: le2 ; cd: le3 */ \
-	vpshufb t1, t2, x1; \
-	add2_le128(t2, t0, t4, t3, t5); \
-	vpshufb t1, t2, x2; \
-	add2_le128(t2, t0, t4, t3, t5); \
-	vpshufb t1, t2, x3; \
-	add2_le128(t2, t0, t4, t3, t5); \
-	vpshufb t1, t2, x4; \
-	add2_le128(t2, t0, t4, t3, t5); \
-	vpshufb t1, t2, x5; \
-	add2_le128(t2, t0, t4, t3, t5); \
-	vpshufb t1, t2, x6; \
-	add2_le128(t2, t0, t4, t3, t5); \
-	vpshufb t1, t2, x7; \
-	vextracti128 $1, t2, t2x; \
-	inc_le128(t2x, t0x, t3x); \
-	vmovdqu t2x, (iv);
-
-#define store_ctr_16way(src, dst, x0, x1, x2, x3, x4, x5, x6, x7) \
-	vpxor (0*32)(src), x0, x0; \
-	vpxor (1*32)(src), x1, x1; \
-	vpxor (2*32)(src), x2, x2; \
-	vpxor (3*32)(src), x3, x3; \
-	vpxor (4*32)(src), x4, x4; \
-	vpxor (5*32)(src), x5, x5; \
-	vpxor (6*32)(src), x6, x6; \
-	vpxor (7*32)(src), x7, x7; \
-	store_16way(dst, x0, x1, x2, x3, x4, x5, x6, x7);
diff --git a/arch/x86/crypto/glue_helper.c b/arch/x86/crypto/glue_helper.c
index 786ffda1caf4..895d34150c3f 100644
--- a/arch/x86/crypto/glue_helper.c
+++ b/arch/x86/crypto/glue_helper.c
@@ -6,8 +6,6 @@
  *
  * CBC & ECB parts based on code (crypto/cbc.c,ecb.c) by:
  *   Copyright (c) 2006 Herbert Xu <herbert@gondor.apana.org.au>
- * CTR part based on code (crypto/ctr.c) by:
- *   (C) Copyright IBM Corp. 2007 - Joy Latten <latten@us.ibm.com>
  */
 
 #include <linux/module.h>
@@ -154,74 +152,4 @@ int glue_cbc_decrypt_req_128bit(const struct common_glue_ctx *gctx,
 }
 EXPORT_SYMBOL_GPL(glue_cbc_decrypt_req_128bit);
 
-int glue_ctr_req_128bit(const struct common_glue_ctx *gctx,
-			struct skcipher_request *req)
-{
-	void *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
-	const unsigned int bsize = 128 / 8;
-	struct skcipher_walk walk;
-	bool fpu_enabled = false;
-	unsigned int nbytes;
-	int err;
-
-	err = skcipher_walk_virt(&walk, req, false);
-
-	while ((nbytes = walk.nbytes) >= bsize) {
-		const u128 *src = walk.src.virt.addr;
-		u128 *dst = walk.dst.virt.addr;
-		unsigned int func_bytes, num_blocks;
-		unsigned int i;
-		le128 ctrblk;
-
-		fpu_enabled = glue_fpu_begin(bsize, gctx->fpu_blocks_limit,
-					     &walk, fpu_enabled, nbytes);
-
-		be128_to_le128(&ctrblk, (be128 *)walk.iv);
-
-		for (i = 0; i < gctx->num_funcs; i++) {
-			num_blocks = gctx->funcs[i].num_blocks;
-			func_bytes = bsize * num_blocks;
-
-			if (nbytes < func_bytes)
-				continue;
-
-			/* Process multi-block batch */
-			do {
-				gctx->funcs[i].fn_u.ctr(ctx, (u8 *)dst,
-							(const u8 *)src,
-							&ctrblk);
-				src += num_blocks;
-				dst += num_blocks;
-				nbytes -= func_bytes;
-			} while (nbytes >= func_bytes);
-
-			if (nbytes < bsize)
-				break;
-		}
-
-		le128_to_be128((be128 *)walk.iv, &ctrblk);
-		err = skcipher_walk_done(&walk, nbytes);
-	}
-
-	glue_fpu_end(fpu_enabled);
-
-	if (nbytes) {
-		le128 ctrblk;
-		u128 tmp;
-
-		be128_to_le128(&ctrblk, (be128 *)walk.iv);
-		memcpy(&tmp, walk.src.virt.addr, nbytes);
-		gctx->funcs[gctx->num_funcs - 1].fn_u.ctr(ctx, (u8 *)&tmp,
-							  (const u8 *)&tmp,
-							  &ctrblk);
-		memcpy(walk.dst.virt.addr, &tmp, nbytes);
-		le128_to_be128((be128 *)walk.iv, &ctrblk);
-
-		err = skcipher_walk_done(&walk, 0);
-	}
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(glue_ctr_req_128bit);
-
 MODULE_LICENSE("GPL");
diff --git a/arch/x86/include/asm/crypto/glue_helper.h b/arch/x86/include/asm/crypto/glue_helper.h
index 62680775d189..23e09efd2aa6 100644
--- a/arch/x86/include/asm/crypto/glue_helper.h
+++ b/arch/x86/include/asm/crypto/glue_helper.h
@@ -9,19 +9,15 @@
 #include <crypto/internal/skcipher.h>
 #include <linux/kernel.h>
 #include <asm/fpu/api.h>
-#include <crypto/b128ops.h>
 
 typedef void (*common_glue_func_t)(const void *ctx, u8 *dst, const u8 *src);
 typedef void (*common_glue_cbc_func_t)(const void *ctx, u8 *dst, const u8 *src);
-typedef void (*common_glue_ctr_func_t)(const void *ctx, u8 *dst, const u8 *src,
-				       le128 *iv);
 
 struct common_glue_func_entry {
 	unsigned int num_blocks; /* number of blocks that @fn will process */
 	union {
 		common_glue_func_t ecb;
 		common_glue_cbc_func_t cbc;
-		common_glue_ctr_func_t ctr;
 	} fn_u;
 };
 
@@ -66,31 +62,6 @@ static inline void glue_fpu_end(bool fpu_enabled)
 		kernel_fpu_end();
 }
 
-static inline void le128_to_be128(be128 *dst, const le128 *src)
-{
-	dst->a = cpu_to_be64(le64_to_cpu(src->a));
-	dst->b = cpu_to_be64(le64_to_cpu(src->b));
-}
-
-static inline void be128_to_le128(le128 *dst, const be128 *src)
-{
-	dst->a = cpu_to_le64(be64_to_cpu(src->a));
-	dst->b = cpu_to_le64(be64_to_cpu(src->b));
-}
-
-static inline void le128_inc(le128 *i)
-{
-	u64 a = le64_to_cpu(i->a);
-	u64 b = le64_to_cpu(i->b);
-
-	b++;
-	if (!b)
-		a++;
-
-	i->a = cpu_to_le64(a);
-	i->b = cpu_to_le64(b);
-}
-
 extern int glue_ecb_req_128bit(const struct common_glue_ctx *gctx,
 			       struct skcipher_request *req);
 
@@ -100,7 +71,4 @@ extern int glue_cbc_encrypt_req_128bit(const common_glue_func_t fn,
 extern int glue_cbc_decrypt_req_128bit(const struct common_glue_ctx *gctx,
 				       struct skcipher_request *req);
 
-extern int glue_ctr_req_128bit(const struct common_glue_ctx *gctx,
-			       struct skcipher_request *req);
-
 #endif /* _CRYPTO_GLUE_HELPER_H */
-- 
2.17.1

