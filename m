Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43FF1C433E6
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 17:24:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D195223E4
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 17:24:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgLaRYg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Dec 2020 12:24:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:54722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726540AbgLaRYg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Dec 2020 12:24:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2B60223E4;
        Thu, 31 Dec 2020 17:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609435435;
        bh=UUW+iE+Q72l+r3IpvgOdswPBKdJpAeXzpkMms7XMhY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dKzjqP0kcy3Y3q2OwWB2YxSxUHYF7Hp77Q10A/3v3EKnM703DC6xjxUBm6Pxc487R
         VS7T1Gg0MjFQaNg5XfokhKnuZHFu7kWlQam1m8ravgL8+wAi/uXhBXJxRd021Ts9hM
         09HNoVS3j32p0BB81fk5LEADwSTRKYNi3tZqlyHEIsoXkJ0LWYqlWqFF6YC4xV78c+
         Zerf6M5F+MruZbW9qRkYg5kbGxEqJ/aoExs1ZHdEb2IPRhrJ7OQU0vt9gFQ7Pea2IE
         WlN1LomTEXj8DiOlxCGtobU0qNoxQ56XZft/6htpvZlUngBmz043cpl8UWl6S7QOK+
         ePINAzBF3G9Tg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 02/21] crypto: x86/cast6 - switch to XTS template
Date:   Thu, 31 Dec 2020 18:23:18 +0100
Message-Id: <20201231172337.23073-3-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201231172337.23073-1-ardb@kernel.org>
References: <20201231172337.23073-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Now that the XTS template can wrap accelerated ECB modes, it can be
used to implement CAST6 in XTS mode as well, which turns out to
be at least as fast, and sometimes even faster

Acked-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S | 56 -----------
 arch/x86/crypto/cast6_avx_glue.c          | 98 --------------------
 crypto/Kconfig                            |  2 +-
 3 files changed, 1 insertion(+), 155 deletions(-)

diff --git a/arch/x86/crypto/cast6-avx-x86_64-asm_64.S b/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
index 932a3ce32a88..0c1ea836215a 100644
--- a/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
@@ -212,8 +212,6 @@
 
 .section	.rodata.cst16, "aM", @progbits, 16
 .align 16
-.Lxts_gf128mul_and_shl1_mask:
-	.byte 0x87, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0
 .Lbswap_mask:
 	.byte 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12
 .Lbswap128_mask:
@@ -440,57 +438,3 @@ SYM_FUNC_START(cast6_ctr_8way)
 	FRAME_END
 	ret;
 SYM_FUNC_END(cast6_ctr_8way)
-
-SYM_FUNC_START(cast6_xts_enc_8way)
-	/* input:
-	 *	%rdi: ctx, CTX
-	 *	%rsi: dst
-	 *	%rdx: src
-	 *	%rcx: iv (t ⊕ αⁿ ∈ GF(2¹²⁸))
-	 */
-	FRAME_BEGIN
-	pushq %r15;
-
-	movq %rdi, CTX
-	movq %rsi, %r11;
-
-	/* regs <= src, dst <= IVs, regs <= regs xor IVs */
-	load_xts_8way(%rcx, %rdx, %rsi, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2,
-		      RX, RKR, RKM, .Lxts_gf128mul_and_shl1_mask);
-
-	call __cast6_enc_blk8;
-
-	/* dst <= regs xor IVs(in dst) */
-	store_xts_8way(%r11, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
-
-	popq %r15;
-	FRAME_END
-	ret;
-SYM_FUNC_END(cast6_xts_enc_8way)
-
-SYM_FUNC_START(cast6_xts_dec_8way)
-	/* input:
-	 *	%rdi: ctx, CTX
-	 *	%rsi: dst
-	 *	%rdx: src
-	 *	%rcx: iv (t ⊕ αⁿ ∈ GF(2¹²⁸))
-	 */
-	FRAME_BEGIN
-	pushq %r15;
-
-	movq %rdi, CTX
-	movq %rsi, %r11;
-
-	/* regs <= src, dst <= IVs, regs <= regs xor IVs */
-	load_xts_8way(%rcx, %rdx, %rsi, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2,
-		      RX, RKR, RKM, .Lxts_gf128mul_and_shl1_mask);
-
-	call __cast6_dec_blk8;
-
-	/* dst <= regs xor IVs(in dst) */
-	store_xts_8way(%r11, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
-
-	popq %r15;
-	FRAME_END
-	ret;
-SYM_FUNC_END(cast6_xts_dec_8way)
diff --git a/arch/x86/crypto/cast6_avx_glue.c b/arch/x86/crypto/cast6_avx_glue.c
index 48e0f37796fa..5a21d3e9041c 100644
--- a/arch/x86/crypto/cast6_avx_glue.c
+++ b/arch/x86/crypto/cast6_avx_glue.c
@@ -15,7 +15,6 @@
 #include <crypto/algapi.h>
 #include <crypto/cast6.h>
 #include <crypto/internal/simd.h>
-#include <crypto/xts.h>
 #include <asm/crypto/glue_helper.h>
 
 #define CAST6_PARALLEL_BLOCKS 8
@@ -27,27 +26,12 @@ asmlinkage void cast6_cbc_dec_8way(const void *ctx, u8 *dst, const u8 *src);
 asmlinkage void cast6_ctr_8way(const void *ctx, u8 *dst, const u8 *src,
 			       le128 *iv);
 
-asmlinkage void cast6_xts_enc_8way(const void *ctx, u8 *dst, const u8 *src,
-				   le128 *iv);
-asmlinkage void cast6_xts_dec_8way(const void *ctx, u8 *dst, const u8 *src,
-				   le128 *iv);
-
 static int cast6_setkey_skcipher(struct crypto_skcipher *tfm,
 				 const u8 *key, unsigned int keylen)
 {
 	return cast6_setkey(&tfm->base, key, keylen);
 }
 
-static void cast6_xts_enc(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
-{
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv, __cast6_encrypt);
-}
-
-static void cast6_xts_dec(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
-{
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv, __cast6_decrypt);
-}
-
 static void cast6_crypt_ctr(const void *ctx, u8 *d, const u8 *s, le128 *iv)
 {
 	be128 ctrblk;
@@ -87,19 +71,6 @@ static const struct common_glue_ctx cast6_ctr = {
 	} }
 };
 
-static const struct common_glue_ctx cast6_enc_xts = {
-	.num_funcs = 2,
-	.fpu_blocks_limit = CAST6_PARALLEL_BLOCKS,
-
-	.funcs = { {
-		.num_blocks = CAST6_PARALLEL_BLOCKS,
-		.fn_u = { .xts = cast6_xts_enc_8way }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .xts = cast6_xts_enc }
-	} }
-};
-
 static const struct common_glue_ctx cast6_dec = {
 	.num_funcs = 2,
 	.fpu_blocks_limit = CAST6_PARALLEL_BLOCKS,
@@ -126,19 +97,6 @@ static const struct common_glue_ctx cast6_dec_cbc = {
 	} }
 };
 
-static const struct common_glue_ctx cast6_dec_xts = {
-	.num_funcs = 2,
-	.fpu_blocks_limit = CAST6_PARALLEL_BLOCKS,
-
-	.funcs = { {
-		.num_blocks = CAST6_PARALLEL_BLOCKS,
-		.fn_u = { .xts = cast6_xts_dec_8way }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .xts = cast6_xts_dec }
-	} }
-};
-
 static int ecb_encrypt(struct skcipher_request *req)
 {
 	return glue_ecb_req_128bit(&cast6_enc, req);
@@ -164,48 +122,6 @@ static int ctr_crypt(struct skcipher_request *req)
 	return glue_ctr_req_128bit(&cast6_ctr, req);
 }
 
-struct cast6_xts_ctx {
-	struct cast6_ctx tweak_ctx;
-	struct cast6_ctx crypt_ctx;
-};
-
-static int xts_cast6_setkey(struct crypto_skcipher *tfm, const u8 *key,
-			    unsigned int keylen)
-{
-	struct cast6_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
-	int err;
-
-	err = xts_verify_key(tfm, key, keylen);
-	if (err)
-		return err;
-
-	/* first half of xts-key is for crypt */
-	err = __cast6_setkey(&ctx->crypt_ctx, key, keylen / 2);
-	if (err)
-		return err;
-
-	/* second half of xts-key is for tweak */
-	return __cast6_setkey(&ctx->tweak_ctx, key + keylen / 2, keylen / 2);
-}
-
-static int xts_encrypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct cast6_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	return glue_xts_req_128bit(&cast6_enc_xts, req, __cast6_encrypt,
-				   &ctx->tweak_ctx, &ctx->crypt_ctx, false);
-}
-
-static int xts_decrypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct cast6_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	return glue_xts_req_128bit(&cast6_dec_xts, req, __cast6_encrypt,
-				   &ctx->tweak_ctx, &ctx->crypt_ctx, true);
-}
-
 static struct skcipher_alg cast6_algs[] = {
 	{
 		.base.cra_name		= "__ecb(cast6)",
@@ -249,20 +165,6 @@ static struct skcipher_alg cast6_algs[] = {
 		.setkey			= cast6_setkey_skcipher,
 		.encrypt		= ctr_crypt,
 		.decrypt		= ctr_crypt,
-	}, {
-		.base.cra_name		= "__xts(cast6)",
-		.base.cra_driver_name	= "__xts-cast6-avx",
-		.base.cra_priority	= 200,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
-		.base.cra_blocksize	= CAST6_BLOCK_SIZE,
-		.base.cra_ctxsize	= sizeof(struct cast6_xts_ctx),
-		.base.cra_module	= THIS_MODULE,
-		.min_keysize		= 2 * CAST6_MIN_KEY_SIZE,
-		.max_keysize		= 2 * CAST6_MAX_KEY_SIZE,
-		.ivsize			= CAST6_BLOCK_SIZE,
-		.setkey			= xts_cast6_setkey,
-		.encrypt		= xts_encrypt,
-		.decrypt		= xts_decrypt,
 	},
 };
 
diff --git a/crypto/Kconfig b/crypto/Kconfig
index b9ea4e262ebe..03e8468e57df 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1394,7 +1394,7 @@ config CRYPTO_CAST6_AVX_X86_64
 	select CRYPTO_CAST_COMMON
 	select CRYPTO_GLUE_HELPER_X86
 	select CRYPTO_SIMD
-	select CRYPTO_XTS
+	imply CRYPTO_XTS
 	help
 	  The CAST6 encryption algorithm (synonymous with CAST-256) is
 	  described in RFC2612.
-- 
2.17.1

