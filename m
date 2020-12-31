Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B305C433DB
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 17:25:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 690F422473
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 17:25:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgLaRZR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Dec 2020 12:25:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:55066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726540AbgLaRZR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Dec 2020 12:25:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BBE422475;
        Thu, 31 Dec 2020 17:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609435450;
        bh=3Vhg56eWWqr7CVwxIZSbNWU/dThl7owwJz4vEc1demQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jjzoa9nUflNaSYVqhXl/5Y18BRnLZvZTf7hoVa2I1oXGJqK7V3hGc7/Cma+AYDmV7
         ub33rs2dzTdQU8SL4Bb0bziXYxS2Y8xy3OCa551TupS/qv6Y+dmbtsq/W5dKHJRQYI
         zJFvftSqJE2GhN/XGEfmn8ylMDCeb8UQOU5y+vSBISN1ysTvyZYkbKzBnijUU/stjV
         GmHcbF+cZIH6YlhE8K4wPoqnfjlvnORJKwuZYc75z0RyJRh2LJR0l1KFjtEvmOY5FT
         hhQQMY/lgGzxDQN46+5nAmf7b8apXeaPZ45+THxAYjun/7EVXhnhJcIApMUfTBm3h5
         523bDvz31eQMA==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 09/21] crypto: x86/cast6 - drop CTR mode implementation
Date:   Thu, 31 Dec 2020 18:23:25 +0100
Message-Id: <20201231172337.23073-10-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201231172337.23073-1-ardb@kernel.org>
References: <20201231172337.23073-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

CAST6 in CTR mode is never used by the kernel directly, and is highly
unlikely to be relied upon by dm-crypt or algif_skcipher. So let's drop
the accelerated CTR mode implementation, and instead, rely on the CTR
template and the bare cipher.

Acked-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S | 28 ------------
 arch/x86/crypto/cast6_avx_glue.c          | 48 --------------------
 crypto/Kconfig                            |  1 +
 3 files changed, 1 insertion(+), 76 deletions(-)

diff --git a/arch/x86/crypto/cast6-avx-x86_64-asm_64.S b/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
index 0c1ea836215a..fbddcecc3e3f 100644
--- a/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
@@ -410,31 +410,3 @@ SYM_FUNC_START(cast6_cbc_dec_8way)
 	FRAME_END
 	ret;
 SYM_FUNC_END(cast6_cbc_dec_8way)
-
-SYM_FUNC_START(cast6_ctr_8way)
-	/* input:
-	 *	%rdi: ctx, CTX
-	 *	%rsi: dst
-	 *	%rdx: src
-	 *	%rcx: iv (little endian, 128bit)
-	 */
-	FRAME_BEGIN
-	pushq %r12;
-	pushq %r15
-
-	movq %rdi, CTX;
-	movq %rsi, %r11;
-	movq %rdx, %r12;
-
-	load_ctr_8way(%rcx, .Lbswap128_mask, RA1, RB1, RC1, RD1, RA2, RB2, RC2,
-		      RD2, RX, RKR, RKM);
-
-	call __cast6_enc_blk8;
-
-	store_ctr_8way(%r12, %r11, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
-
-	popq %r15;
-	popq %r12;
-	FRAME_END
-	ret;
-SYM_FUNC_END(cast6_ctr_8way)
diff --git a/arch/x86/crypto/cast6_avx_glue.c b/arch/x86/crypto/cast6_avx_glue.c
index 5a21d3e9041c..790efcb6df3b 100644
--- a/arch/x86/crypto/cast6_avx_glue.c
+++ b/arch/x86/crypto/cast6_avx_glue.c
@@ -23,8 +23,6 @@ asmlinkage void cast6_ecb_enc_8way(const void *ctx, u8 *dst, const u8 *src);
 asmlinkage void cast6_ecb_dec_8way(const void *ctx, u8 *dst, const u8 *src);
 
 asmlinkage void cast6_cbc_dec_8way(const void *ctx, u8 *dst, const u8 *src);
-asmlinkage void cast6_ctr_8way(const void *ctx, u8 *dst, const u8 *src,
-			       le128 *iv);
 
 static int cast6_setkey_skcipher(struct crypto_skcipher *tfm,
 				 const u8 *key, unsigned int keylen)
@@ -32,19 +30,6 @@ static int cast6_setkey_skcipher(struct crypto_skcipher *tfm,
 	return cast6_setkey(&tfm->base, key, keylen);
 }
 
-static void cast6_crypt_ctr(const void *ctx, u8 *d, const u8 *s, le128 *iv)
-{
-	be128 ctrblk;
-	u128 *dst = (u128 *)d;
-	const u128 *src = (const u128 *)s;
-
-	le128_to_be128(&ctrblk, iv);
-	le128_inc(iv);
-
-	__cast6_encrypt(ctx, (u8 *)&ctrblk, (u8 *)&ctrblk);
-	u128_xor(dst, src, (u128 *)&ctrblk);
-}
-
 static const struct common_glue_ctx cast6_enc = {
 	.num_funcs = 2,
 	.fpu_blocks_limit = CAST6_PARALLEL_BLOCKS,
@@ -58,19 +43,6 @@ static const struct common_glue_ctx cast6_enc = {
 	} }
 };
 
-static const struct common_glue_ctx cast6_ctr = {
-	.num_funcs = 2,
-	.fpu_blocks_limit = CAST6_PARALLEL_BLOCKS,
-
-	.funcs = { {
-		.num_blocks = CAST6_PARALLEL_BLOCKS,
-		.fn_u = { .ctr = cast6_ctr_8way }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .ctr = cast6_crypt_ctr }
-	} }
-};
-
 static const struct common_glue_ctx cast6_dec = {
 	.num_funcs = 2,
 	.fpu_blocks_limit = CAST6_PARALLEL_BLOCKS,
@@ -117,11 +89,6 @@ static int cbc_decrypt(struct skcipher_request *req)
 	return glue_cbc_decrypt_req_128bit(&cast6_dec_cbc, req);
 }
 
-static int ctr_crypt(struct skcipher_request *req)
-{
-	return glue_ctr_req_128bit(&cast6_ctr, req);
-}
-
 static struct skcipher_alg cast6_algs[] = {
 	{
 		.base.cra_name		= "__ecb(cast6)",
@@ -150,21 +117,6 @@ static struct skcipher_alg cast6_algs[] = {
 		.setkey			= cast6_setkey_skcipher,
 		.encrypt		= cbc_encrypt,
 		.decrypt		= cbc_decrypt,
-	}, {
-		.base.cra_name		= "__ctr(cast6)",
-		.base.cra_driver_name	= "__ctr-cast6-avx",
-		.base.cra_priority	= 200,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
-		.base.cra_blocksize	= 1,
-		.base.cra_ctxsize	= sizeof(struct cast6_ctx),
-		.base.cra_module	= THIS_MODULE,
-		.min_keysize		= CAST6_MIN_KEY_SIZE,
-		.max_keysize		= CAST6_MAX_KEY_SIZE,
-		.ivsize			= CAST6_BLOCK_SIZE,
-		.chunksize		= CAST6_BLOCK_SIZE,
-		.setkey			= cast6_setkey_skcipher,
-		.encrypt		= ctr_crypt,
-		.decrypt		= ctr_crypt,
 	},
 };
 
diff --git a/crypto/Kconfig b/crypto/Kconfig
index fed73fff5a65..3f51c5dfc2a9 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1397,6 +1397,7 @@ config CRYPTO_CAST6_AVX_X86_64
 	select CRYPTO_GLUE_HELPER_X86
 	select CRYPTO_SIMD
 	imply CRYPTO_XTS
+	imply CRYPTO_CTR
 	help
 	  The CAST6 encryption algorithm (synonymous with CAST-256) is
 	  described in RFC2612.
-- 
2.17.1

