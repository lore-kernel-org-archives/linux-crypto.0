Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B384C43381
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 22:39:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31BAF22A99
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 22:39:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgLWWjt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Dec 2020 17:39:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:59262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725811AbgLWWjt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Dec 2020 17:39:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E9B2224B0;
        Wed, 23 Dec 2020 22:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608763148;
        bh=OUWcXmad/NIGPN5jhyvEV3boVxRZsxOIoCLaTRrVHPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IAQ7Xh5oTxmXx6AFbptW70q0STp9x1vcHXvPNFmt1FUUou40yrBz74NeMBDyN/aeS
         SBqFPTHgYNSj4sZ4IKLr40xRagE2F3kR/47YVJURjW3cLuF0W21sFxiVUm0t3anQHj
         pdFTMrvRFaLHvKQJ5RqJ8gPFGrnC4hBzU31JEdz1Jz7FZIxsQ8V/qM/3mfVEEi264w
         jqQ+BY+xl4o8e2BKS+8PZi6G+KbXhGwhe7hFWBhghDjy7kGK8gqrMQ5nivNTY1Wk8e
         4P3LTtQ+D/5bkKEv+UfqttpH4TKjCOt66N+rGHPcc4QOVPz8Sx6Sa+IC+aIQ+G/HDg
         7yQ8ExW7CQLdA==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     dm-devel@redhat.com, Ard Biesheuvel <ardb@kernel.org>,
        Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [RFC PATCH 03/10] crypto: x86/serpent- switch to XTS template
Date:   Wed, 23 Dec 2020 23:38:34 +0100
Message-Id: <20201223223841.11311-4-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201223223841.11311-1-ardb@kernel.org>
References: <20201223223841.11311-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Now that the XTS template can wrap accelerated ECB modes, it can be
used to implement Serpent in XTS mode as well, which turns out to
be at least as fast, and sometimes even faster

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/serpent-avx-x86_64-asm_64.S |  48 ----------
 arch/x86/crypto/serpent-avx2-asm_64.S       |  62 ------------
 arch/x86/crypto/serpent_avx2_glue.c         |  72 --------------
 arch/x86/crypto/serpent_avx_glue.c          | 101 --------------------
 arch/x86/include/asm/crypto/serpent-avx.h   |  21 ----
 5 files changed, 304 deletions(-)

diff --git a/arch/x86/crypto/serpent-avx-x86_64-asm_64.S b/arch/x86/crypto/serpent-avx-x86_64-asm_64.S
index ba9e4c1e7f5c..6b41f46bcc76 100644
--- a/arch/x86/crypto/serpent-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/serpent-avx-x86_64-asm_64.S
@@ -18,10 +18,6 @@
 .align 16
 .Lbswap128_mask:
 	.byte 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
-.section	.rodata.cst16.xts_gf128mul_and_shl1_mask, "aM", @progbits, 16
-.align 16
-.Lxts_gf128mul_and_shl1_mask:
-	.byte 0x87, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0
 
 .text
 
@@ -735,47 +731,3 @@ SYM_FUNC_START(serpent_ctr_8way_avx)
 	FRAME_END
 	ret;
 SYM_FUNC_END(serpent_ctr_8way_avx)
-
-SYM_FUNC_START(serpent_xts_enc_8way_avx)
-	/* input:
-	 *	%rdi: ctx, CTX
-	 *	%rsi: dst
-	 *	%rdx: src
-	 *	%rcx: iv (t ⊕ αⁿ ∈ GF(2¹²⁸))
-	 */
-	FRAME_BEGIN
-
-	/* regs <= src, dst <= IVs, regs <= regs xor IVs */
-	load_xts_8way(%rcx, %rdx, %rsi, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2,
-		      RK0, RK1, RK2, .Lxts_gf128mul_and_shl1_mask);
-
-	call __serpent_enc_blk8_avx;
-
-	/* dst <= regs xor IVs(in dst) */
-	store_xts_8way(%rsi, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
-
-	FRAME_END
-	ret;
-SYM_FUNC_END(serpent_xts_enc_8way_avx)
-
-SYM_FUNC_START(serpent_xts_dec_8way_avx)
-	/* input:
-	 *	%rdi: ctx, CTX
-	 *	%rsi: dst
-	 *	%rdx: src
-	 *	%rcx: iv (t ⊕ αⁿ ∈ GF(2¹²⁸))
-	 */
-	FRAME_BEGIN
-
-	/* regs <= src, dst <= IVs, regs <= regs xor IVs */
-	load_xts_8way(%rcx, %rdx, %rsi, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2,
-		      RK0, RK1, RK2, .Lxts_gf128mul_and_shl1_mask);
-
-	call __serpent_dec_blk8_avx;
-
-	/* dst <= regs xor IVs(in dst) */
-	store_xts_8way(%rsi, RC1, RD1, RB1, RE1, RC2, RD2, RB2, RE2);
-
-	FRAME_END
-	ret;
-SYM_FUNC_END(serpent_xts_dec_8way_avx)
diff --git a/arch/x86/crypto/serpent-avx2-asm_64.S b/arch/x86/crypto/serpent-avx2-asm_64.S
index c9648aeae705..a510a949f02f 100644
--- a/arch/x86/crypto/serpent-avx2-asm_64.S
+++ b/arch/x86/crypto/serpent-avx2-asm_64.S
@@ -20,16 +20,6 @@
 .Lbswap128_mask:
 	.byte 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
 
-.section	.rodata.cst16.xts_gf128mul_and_shl1_mask_0, "aM", @progbits, 16
-.align 16
-.Lxts_gf128mul_and_shl1_mask_0:
-	.byte 0x87, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0
-
-.section	.rodata.cst16.xts_gf128mul_and_shl1_mask_1, "aM", @progbits, 16
-.align 16
-.Lxts_gf128mul_and_shl1_mask_1:
-	.byte 0x0e, 1, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0
-
 .text
 
 #define CTX %rdi
@@ -759,55 +749,3 @@ SYM_FUNC_START(serpent_ctr_16way)
 	FRAME_END
 	ret;
 SYM_FUNC_END(serpent_ctr_16way)
-
-SYM_FUNC_START(serpent_xts_enc_16way)
-	/* input:
-	 *	%rdi: ctx, CTX
-	 *	%rsi: dst (16 blocks)
-	 *	%rdx: src (16 blocks)
-	 *	%rcx: iv (t ⊕ αⁿ ∈ GF(2¹²⁸))
-	 */
-	FRAME_BEGIN
-
-	vzeroupper;
-
-	load_xts_16way(%rcx, %rdx, %rsi, RA1, RB1, RC1, RD1, RA2, RB2, RC2,
-		       RD2, RK0, RK0x, RK1, RK1x, RK2, RK2x, RK3, RK3x, RNOT,
-		       .Lxts_gf128mul_and_shl1_mask_0,
-		       .Lxts_gf128mul_and_shl1_mask_1);
-
-	call __serpent_enc_blk16;
-
-	store_xts_16way(%rsi, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
-
-	vzeroupper;
-
-	FRAME_END
-	ret;
-SYM_FUNC_END(serpent_xts_enc_16way)
-
-SYM_FUNC_START(serpent_xts_dec_16way)
-	/* input:
-	 *	%rdi: ctx, CTX
-	 *	%rsi: dst (16 blocks)
-	 *	%rdx: src (16 blocks)
-	 *	%rcx: iv (t ⊕ αⁿ ∈ GF(2¹²⁸))
-	 */
-	FRAME_BEGIN
-
-	vzeroupper;
-
-	load_xts_16way(%rcx, %rdx, %rsi, RA1, RB1, RC1, RD1, RA2, RB2, RC2,
-		       RD2, RK0, RK0x, RK1, RK1x, RK2, RK2x, RK3, RK3x, RNOT,
-		       .Lxts_gf128mul_and_shl1_mask_0,
-		       .Lxts_gf128mul_and_shl1_mask_1);
-
-	call __serpent_dec_blk16;
-
-	store_xts_16way(%rsi, RC1, RD1, RB1, RE1, RC2, RD2, RB2, RE2);
-
-	vzeroupper;
-
-	FRAME_END
-	ret;
-SYM_FUNC_END(serpent_xts_dec_16way)
diff --git a/arch/x86/crypto/serpent_avx2_glue.c b/arch/x86/crypto/serpent_avx2_glue.c
index f973ace44ad3..9cdf2c078e21 100644
--- a/arch/x86/crypto/serpent_avx2_glue.c
+++ b/arch/x86/crypto/serpent_avx2_glue.c
@@ -12,7 +12,6 @@
 #include <crypto/algapi.h>
 #include <crypto/internal/simd.h>
 #include <crypto/serpent.h>
-#include <crypto/xts.h>
 #include <asm/crypto/glue_helper.h>
 #include <asm/crypto/serpent-avx.h>
 
@@ -25,11 +24,6 @@ asmlinkage void serpent_cbc_dec_16way(const void *ctx, u8 *dst, const u8 *src);
 
 asmlinkage void serpent_ctr_16way(const void *ctx, u8 *dst, const u8 *src,
 				  le128 *iv);
-asmlinkage void serpent_xts_enc_16way(const void *ctx, u8 *dst, const u8 *src,
-				      le128 *iv);
-asmlinkage void serpent_xts_dec_16way(const void *ctx, u8 *dst, const u8 *src,
-				      le128 *iv);
-
 static int serpent_setkey_skcipher(struct crypto_skcipher *tfm,
 				   const u8 *key, unsigned int keylen)
 {
@@ -68,22 +62,6 @@ static const struct common_glue_ctx serpent_ctr = {
 	} }
 };
 
-static const struct common_glue_ctx serpent_enc_xts = {
-	.num_funcs = 3,
-	.fpu_blocks_limit = 8,
-
-	.funcs = { {
-		.num_blocks = 16,
-		.fn_u = { .xts = serpent_xts_enc_16way }
-	}, {
-		.num_blocks = 8,
-		.fn_u = { .xts = serpent_xts_enc_8way_avx }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .xts = serpent_xts_enc }
-	} }
-};
-
 static const struct common_glue_ctx serpent_dec = {
 	.num_funcs = 3,
 	.fpu_blocks_limit = 8,
@@ -116,22 +94,6 @@ static const struct common_glue_ctx serpent_dec_cbc = {
 	} }
 };
 
-static const struct common_glue_ctx serpent_dec_xts = {
-	.num_funcs = 3,
-	.fpu_blocks_limit = 8,
-
-	.funcs = { {
-		.num_blocks = 16,
-		.fn_u = { .xts = serpent_xts_dec_16way }
-	}, {
-		.num_blocks = 8,
-		.fn_u = { .xts = serpent_xts_dec_8way_avx }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .xts = serpent_xts_dec }
-	} }
-};
-
 static int ecb_encrypt(struct skcipher_request *req)
 {
 	return glue_ecb_req_128bit(&serpent_enc, req);
@@ -157,26 +119,6 @@ static int ctr_crypt(struct skcipher_request *req)
 	return glue_ctr_req_128bit(&serpent_ctr, req);
 }
 
-static int xts_encrypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct serpent_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	return glue_xts_req_128bit(&serpent_enc_xts, req,
-				   __serpent_encrypt, &ctx->tweak_ctx,
-				   &ctx->crypt_ctx, false);
-}
-
-static int xts_decrypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct serpent_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	return glue_xts_req_128bit(&serpent_dec_xts, req,
-				   __serpent_encrypt, &ctx->tweak_ctx,
-				   &ctx->crypt_ctx, true);
-}
-
 static struct skcipher_alg serpent_algs[] = {
 	{
 		.base.cra_name		= "__ecb(serpent)",
@@ -220,20 +162,6 @@ static struct skcipher_alg serpent_algs[] = {
 		.setkey			= serpent_setkey_skcipher,
 		.encrypt		= ctr_crypt,
 		.decrypt		= ctr_crypt,
-	}, {
-		.base.cra_name		= "__xts(serpent)",
-		.base.cra_driver_name	= "__xts-serpent-avx2",
-		.base.cra_priority	= 600,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
-		.base.cra_blocksize	= SERPENT_BLOCK_SIZE,
-		.base.cra_ctxsize	= sizeof(struct serpent_xts_ctx),
-		.base.cra_module	= THIS_MODULE,
-		.min_keysize		= 2 * SERPENT_MIN_KEY_SIZE,
-		.max_keysize		= 2 * SERPENT_MAX_KEY_SIZE,
-		.ivsize			= SERPENT_BLOCK_SIZE,
-		.setkey			= xts_serpent_setkey,
-		.encrypt		= xts_encrypt,
-		.decrypt		= xts_decrypt,
 	},
 };
 
diff --git a/arch/x86/crypto/serpent_avx_glue.c b/arch/x86/crypto/serpent_avx_glue.c
index 7806d1cbe854..b17a08b57a91 100644
--- a/arch/x86/crypto/serpent_avx_glue.c
+++ b/arch/x86/crypto/serpent_avx_glue.c
@@ -15,7 +15,6 @@
 #include <crypto/algapi.h>
 #include <crypto/internal/simd.h>
 #include <crypto/serpent.h>
-#include <crypto/xts.h>
 #include <asm/crypto/glue_helper.h>
 #include <asm/crypto/serpent-avx.h>
 
@@ -36,14 +35,6 @@ asmlinkage void serpent_ctr_8way_avx(const void *ctx, u8 *dst, const u8 *src,
 				     le128 *iv);
 EXPORT_SYMBOL_GPL(serpent_ctr_8way_avx);
 
-asmlinkage void serpent_xts_enc_8way_avx(const void *ctx, u8 *dst,
-					 const u8 *src, le128 *iv);
-EXPORT_SYMBOL_GPL(serpent_xts_enc_8way_avx);
-
-asmlinkage void serpent_xts_dec_8way_avx(const void *ctx, u8 *dst,
-					 const u8 *src, le128 *iv);
-EXPORT_SYMBOL_GPL(serpent_xts_dec_8way_avx);
-
 void __serpent_crypt_ctr(const void *ctx, u8 *d, const u8 *s, le128 *iv)
 {
 	be128 ctrblk;
@@ -58,44 +49,12 @@ void __serpent_crypt_ctr(const void *ctx, u8 *d, const u8 *s, le128 *iv)
 }
 EXPORT_SYMBOL_GPL(__serpent_crypt_ctr);
 
-void serpent_xts_enc(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
-{
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv, __serpent_encrypt);
-}
-EXPORT_SYMBOL_GPL(serpent_xts_enc);
-
-void serpent_xts_dec(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
-{
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv, __serpent_decrypt);
-}
-EXPORT_SYMBOL_GPL(serpent_xts_dec);
-
 static int serpent_setkey_skcipher(struct crypto_skcipher *tfm,
 				   const u8 *key, unsigned int keylen)
 {
 	return __serpent_setkey(crypto_skcipher_ctx(tfm), key, keylen);
 }
 
-int xts_serpent_setkey(struct crypto_skcipher *tfm, const u8 *key,
-		       unsigned int keylen)
-{
-	struct serpent_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
-	int err;
-
-	err = xts_verify_key(tfm, key, keylen);
-	if (err)
-		return err;
-
-	/* first half of xts-key is for crypt */
-	err = __serpent_setkey(&ctx->crypt_ctx, key, keylen / 2);
-	if (err)
-		return err;
-
-	/* second half of xts-key is for tweak */
-	return __serpent_setkey(&ctx->tweak_ctx, key + keylen / 2, keylen / 2);
-}
-EXPORT_SYMBOL_GPL(xts_serpent_setkey);
-
 static const struct common_glue_ctx serpent_enc = {
 	.num_funcs = 2,
 	.fpu_blocks_limit = SERPENT_PARALLEL_BLOCKS,
@@ -122,19 +81,6 @@ static const struct common_glue_ctx serpent_ctr = {
 	} }
 };
 
-static const struct common_glue_ctx serpent_enc_xts = {
-	.num_funcs = 2,
-	.fpu_blocks_limit = SERPENT_PARALLEL_BLOCKS,
-
-	.funcs = { {
-		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .xts = serpent_xts_enc_8way_avx }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .xts = serpent_xts_enc }
-	} }
-};
-
 static const struct common_glue_ctx serpent_dec = {
 	.num_funcs = 2,
 	.fpu_blocks_limit = SERPENT_PARALLEL_BLOCKS,
@@ -161,19 +107,6 @@ static const struct common_glue_ctx serpent_dec_cbc = {
 	} }
 };
 
-static const struct common_glue_ctx serpent_dec_xts = {
-	.num_funcs = 2,
-	.fpu_blocks_limit = SERPENT_PARALLEL_BLOCKS,
-
-	.funcs = { {
-		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .xts = serpent_xts_dec_8way_avx }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .xts = serpent_xts_dec }
-	} }
-};
-
 static int ecb_encrypt(struct skcipher_request *req)
 {
 	return glue_ecb_req_128bit(&serpent_enc, req);
@@ -199,26 +132,6 @@ static int ctr_crypt(struct skcipher_request *req)
 	return glue_ctr_req_128bit(&serpent_ctr, req);
 }
 
-static int xts_encrypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct serpent_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	return glue_xts_req_128bit(&serpent_enc_xts, req,
-				   __serpent_encrypt, &ctx->tweak_ctx,
-				   &ctx->crypt_ctx, false);
-}
-
-static int xts_decrypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct serpent_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	return glue_xts_req_128bit(&serpent_dec_xts, req,
-				   __serpent_encrypt, &ctx->tweak_ctx,
-				   &ctx->crypt_ctx, true);
-}
-
 static struct skcipher_alg serpent_algs[] = {
 	{
 		.base.cra_name		= "__ecb(serpent)",
@@ -262,20 +175,6 @@ static struct skcipher_alg serpent_algs[] = {
 		.setkey			= serpent_setkey_skcipher,
 		.encrypt		= ctr_crypt,
 		.decrypt		= ctr_crypt,
-	}, {
-		.base.cra_name		= "__xts(serpent)",
-		.base.cra_driver_name	= "__xts-serpent-avx",
-		.base.cra_priority	= 500,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
-		.base.cra_blocksize	= SERPENT_BLOCK_SIZE,
-		.base.cra_ctxsize	= sizeof(struct serpent_xts_ctx),
-		.base.cra_module	= THIS_MODULE,
-		.min_keysize		= 2 * SERPENT_MIN_KEY_SIZE,
-		.max_keysize		= 2 * SERPENT_MAX_KEY_SIZE,
-		.ivsize			= SERPENT_BLOCK_SIZE,
-		.setkey			= xts_serpent_setkey,
-		.encrypt		= xts_encrypt,
-		.decrypt		= xts_decrypt,
 	},
 };
 
diff --git a/arch/x86/include/asm/crypto/serpent-avx.h b/arch/x86/include/asm/crypto/serpent-avx.h
index 251c2c89d7cf..23f3361a0e72 100644
--- a/arch/x86/include/asm/crypto/serpent-avx.h
+++ b/arch/x86/include/asm/crypto/serpent-avx.h
@@ -10,11 +10,6 @@ struct crypto_skcipher;
 
 #define SERPENT_PARALLEL_BLOCKS 8
 
-struct serpent_xts_ctx {
-	struct serpent_ctx tweak_ctx;
-	struct serpent_ctx crypt_ctx;
-};
-
 asmlinkage void serpent_ecb_enc_8way_avx(const void *ctx, u8 *dst,
 					 const u8 *src);
 asmlinkage void serpent_ecb_dec_8way_avx(const void *ctx, u8 *dst,
@@ -22,21 +17,5 @@ asmlinkage void serpent_ecb_dec_8way_avx(const void *ctx, u8 *dst,
 
 asmlinkage void serpent_cbc_dec_8way_avx(const void *ctx, u8 *dst,
 					 const u8 *src);
-asmlinkage void serpent_ctr_8way_avx(const void *ctx, u8 *dst, const u8 *src,
-				     le128 *iv);
-
-asmlinkage void serpent_xts_enc_8way_avx(const void *ctx, u8 *dst,
-					 const u8 *src, le128 *iv);
-asmlinkage void serpent_xts_dec_8way_avx(const void *ctx, u8 *dst,
-					 const u8 *src, le128 *iv);
-
-extern void __serpent_crypt_ctr(const void *ctx, u8 *dst, const u8 *src,
-				le128 *iv);
-
-extern void serpent_xts_enc(const void *ctx, u8 *dst, const u8 *src, le128 *iv);
-extern void serpent_xts_dec(const void *ctx, u8 *dst, const u8 *src, le128 *iv);
-
-extern int xts_serpent_setkey(struct crypto_skcipher *tfm, const u8 *key,
-			      unsigned int keylen);
 
 #endif
-- 
2.17.1

