Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB8B0C4332B
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 17:25:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A5122246B
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 17:25:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgLaRZS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Dec 2020 12:25:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:55068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726917AbgLaRZR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Dec 2020 12:25:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4E1022482;
        Thu, 31 Dec 2020 17:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609435452;
        bh=MWJ+uVTwSBTinYo4I5XVzRSYZeX+sYaZRc5m+1X1ejs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aFTdPIhBuRYxHkC4+5wOEsBGTDIVrP5Ou67R4R1RyFAJYPlTQEg9KORT8D+ueHbMv
         8+nM9XrafwG3eCpIYkXhYq2q1abuaG2Ztt1mr4S4R5IhIn1wd+kdcDD8vZVKpaD1Ck
         A0zPc8lFJn56JfTvKvn2l+aXoykceAFPKjQC0vcQkVECI5kfEZesbnwoKjt7/PB9iy
         k+DjZPm/9Eej1w0+n8U2AQQB8S6EBDsX2ufMzW3FAyag56okDEuCmiWEzcWWOa33lS
         yRXlmmwVk+cJtw0Xl8F1AQzxw0vIqn9CoJEFqwS1auaetp+CT5gzb5xc30Jl2NUzim
         AfPix/1gT+tsg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 10/21] crypto: x86/twofish - drop CTR mode implementation
Date:   Thu, 31 Dec 2020 18:23:26 +0100
Message-Id: <20201231172337.23073-11-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201231172337.23073-1-ardb@kernel.org>
References: <20201231172337.23073-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Twofish in CTR mode is never used by the kernel directly, and is highly
unlikely to be relied upon by dm-crypt or algif_skcipher. So let's drop
the accelerated CTR mode implementation, and instead, rely on the CTR
template and the bare cipher.

Acked-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/twofish-avx-x86_64-asm_64.S | 27 -------
 arch/x86/crypto/twofish_avx_glue.c          | 38 ----------
 arch/x86/crypto/twofish_glue_3way.c         | 78 --------------------
 arch/x86/include/asm/crypto/twofish.h       |  4 -
 crypto/Kconfig                              |  2 +
 5 files changed, 2 insertions(+), 147 deletions(-)

diff --git a/arch/x86/crypto/twofish-avx-x86_64-asm_64.S b/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
index 84e61ef03638..37e63b3c664e 100644
--- a/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
@@ -374,30 +374,3 @@ SYM_FUNC_START(twofish_cbc_dec_8way)
 	FRAME_END
 	ret;
 SYM_FUNC_END(twofish_cbc_dec_8way)
-
-SYM_FUNC_START(twofish_ctr_8way)
-	/* input:
-	 *	%rdi: ctx, CTX
-	 *	%rsi: dst
-	 *	%rdx: src
-	 *	%rcx: iv (little endian, 128bit)
-	 */
-	FRAME_BEGIN
-
-	pushq %r12;
-
-	movq %rsi, %r11;
-	movq %rdx, %r12;
-
-	load_ctr_8way(%rcx, .Lbswap128_mask, RA1, RB1, RC1, RD1, RA2, RB2, RC2,
-		      RD2, RX0, RX1, RY0);
-
-	call __twofish_enc_blk8;
-
-	store_ctr_8way(%r12, %r11, RC1, RD1, RA1, RB1, RC2, RD2, RA2, RB2);
-
-	popq %r12;
-
-	FRAME_END
-	ret;
-SYM_FUNC_END(twofish_ctr_8way)
diff --git a/arch/x86/crypto/twofish_avx_glue.c b/arch/x86/crypto/twofish_avx_glue.c
index 7b539bbb108f..13f810b61034 100644
--- a/arch/x86/crypto/twofish_avx_glue.c
+++ b/arch/x86/crypto/twofish_avx_glue.c
@@ -25,8 +25,6 @@ asmlinkage void twofish_ecb_enc_8way(const void *ctx, u8 *dst, const u8 *src);
 asmlinkage void twofish_ecb_dec_8way(const void *ctx, u8 *dst, const u8 *src);
 
 asmlinkage void twofish_cbc_dec_8way(const void *ctx, u8 *dst, const u8 *src);
-asmlinkage void twofish_ctr_8way(const void *ctx, u8 *dst, const u8 *src,
-				 le128 *iv);
 
 static int twofish_setkey_skcipher(struct crypto_skcipher *tfm,
 				   const u8 *key, unsigned int keylen)
@@ -55,22 +53,6 @@ static const struct common_glue_ctx twofish_enc = {
 	} }
 };
 
-static const struct common_glue_ctx twofish_ctr = {
-	.num_funcs = 3,
-	.fpu_blocks_limit = TWOFISH_PARALLEL_BLOCKS,
-
-	.funcs = { {
-		.num_blocks = TWOFISH_PARALLEL_BLOCKS,
-		.fn_u = { .ctr = twofish_ctr_8way }
-	}, {
-		.num_blocks = 3,
-		.fn_u = { .ctr = twofish_enc_blk_ctr_3way }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .ctr = twofish_enc_blk_ctr }
-	} }
-};
-
 static const struct common_glue_ctx twofish_dec = {
 	.num_funcs = 3,
 	.fpu_blocks_limit = TWOFISH_PARALLEL_BLOCKS,
@@ -123,11 +105,6 @@ static int cbc_decrypt(struct skcipher_request *req)
 	return glue_cbc_decrypt_req_128bit(&twofish_dec_cbc, req);
 }
 
-static int ctr_crypt(struct skcipher_request *req)
-{
-	return glue_ctr_req_128bit(&twofish_ctr, req);
-}
-
 static struct skcipher_alg twofish_algs[] = {
 	{
 		.base.cra_name		= "__ecb(twofish)",
@@ -156,21 +133,6 @@ static struct skcipher_alg twofish_algs[] = {
 		.setkey			= twofish_setkey_skcipher,
 		.encrypt		= cbc_encrypt,
 		.decrypt		= cbc_decrypt,
-	}, {
-		.base.cra_name		= "__ctr(twofish)",
-		.base.cra_driver_name	= "__ctr-twofish-avx",
-		.base.cra_priority	= 400,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
-		.base.cra_blocksize	= 1,
-		.base.cra_ctxsize	= sizeof(struct twofish_ctx),
-		.base.cra_module	= THIS_MODULE,
-		.min_keysize		= TF_MIN_KEY_SIZE,
-		.max_keysize		= TF_MAX_KEY_SIZE,
-		.ivsize			= TF_BLOCK_SIZE,
-		.chunksize		= TF_BLOCK_SIZE,
-		.setkey			= twofish_setkey_skcipher,
-		.encrypt		= ctr_crypt,
-		.decrypt		= ctr_crypt,
 	},
 };
 
diff --git a/arch/x86/crypto/twofish_glue_3way.c b/arch/x86/crypto/twofish_glue_3way.c
index 768af6075479..88252370db0a 100644
--- a/arch/x86/crypto/twofish_glue_3way.c
+++ b/arch/x86/crypto/twofish_glue_3way.c
@@ -30,12 +30,6 @@ static inline void twofish_enc_blk_3way(const void *ctx, u8 *dst, const u8 *src)
 	__twofish_enc_blk_3way(ctx, dst, src, false);
 }
 
-static inline void twofish_enc_blk_xor_3way(const void *ctx, u8 *dst,
-					    const u8 *src)
-{
-	__twofish_enc_blk_3way(ctx, dst, src, true);
-}
-
 void twofish_dec_blk_cbc_3way(const void *ctx, u8 *d, const u8 *s)
 {
 	u128 ivs[2];
@@ -52,46 +46,6 @@ void twofish_dec_blk_cbc_3way(const void *ctx, u8 *d, const u8 *s)
 }
 EXPORT_SYMBOL_GPL(twofish_dec_blk_cbc_3way);
 
-void twofish_enc_blk_ctr(const void *ctx, u8 *d, const u8 *s, le128 *iv)
-{
-	be128 ctrblk;
-	u128 *dst = (u128 *)d;
-	const u128 *src = (const u128 *)s;
-
-	if (dst != src)
-		*dst = *src;
-
-	le128_to_be128(&ctrblk, iv);
-	le128_inc(iv);
-
-	twofish_enc_blk(ctx, (u8 *)&ctrblk, (u8 *)&ctrblk);
-	u128_xor(dst, dst, (u128 *)&ctrblk);
-}
-EXPORT_SYMBOL_GPL(twofish_enc_blk_ctr);
-
-void twofish_enc_blk_ctr_3way(const void *ctx, u8 *d, const u8 *s, le128 *iv)
-{
-	be128 ctrblks[3];
-	u128 *dst = (u128 *)d;
-	const u128 *src = (const u128 *)s;
-
-	if (dst != src) {
-		dst[0] = src[0];
-		dst[1] = src[1];
-		dst[2] = src[2];
-	}
-
-	le128_to_be128(&ctrblks[0], iv);
-	le128_inc(iv);
-	le128_to_be128(&ctrblks[1], iv);
-	le128_inc(iv);
-	le128_to_be128(&ctrblks[2], iv);
-	le128_inc(iv);
-
-	twofish_enc_blk_xor_3way(ctx, (u8 *)dst, (u8 *)ctrblks);
-}
-EXPORT_SYMBOL_GPL(twofish_enc_blk_ctr_3way);
-
 static const struct common_glue_ctx twofish_enc = {
 	.num_funcs = 2,
 	.fpu_blocks_limit = -1,
@@ -105,19 +59,6 @@ static const struct common_glue_ctx twofish_enc = {
 	} }
 };
 
-static const struct common_glue_ctx twofish_ctr = {
-	.num_funcs = 2,
-	.fpu_blocks_limit = -1,
-
-	.funcs = { {
-		.num_blocks = 3,
-		.fn_u = { .ctr = twofish_enc_blk_ctr_3way }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .ctr = twofish_enc_blk_ctr }
-	} }
-};
-
 static const struct common_glue_ctx twofish_dec = {
 	.num_funcs = 2,
 	.fpu_blocks_limit = -1,
@@ -164,11 +105,6 @@ static int cbc_decrypt(struct skcipher_request *req)
 	return glue_cbc_decrypt_req_128bit(&twofish_dec_cbc, req);
 }
 
-static int ctr_crypt(struct skcipher_request *req)
-{
-	return glue_ctr_req_128bit(&twofish_ctr, req);
-}
-
 static struct skcipher_alg tf_skciphers[] = {
 	{
 		.base.cra_name		= "ecb(twofish)",
@@ -195,20 +131,6 @@ static struct skcipher_alg tf_skciphers[] = {
 		.setkey			= twofish_setkey_skcipher,
 		.encrypt		= cbc_encrypt,
 		.decrypt		= cbc_decrypt,
-	}, {
-		.base.cra_name		= "ctr(twofish)",
-		.base.cra_driver_name	= "ctr-twofish-3way",
-		.base.cra_priority	= 300,
-		.base.cra_blocksize	= 1,
-		.base.cra_ctxsize	= sizeof(struct twofish_ctx),
-		.base.cra_module	= THIS_MODULE,
-		.min_keysize		= TF_MIN_KEY_SIZE,
-		.max_keysize		= TF_MAX_KEY_SIZE,
-		.ivsize			= TF_BLOCK_SIZE,
-		.chunksize		= TF_BLOCK_SIZE,
-		.setkey			= twofish_setkey_skcipher,
-		.encrypt		= ctr_crypt,
-		.decrypt		= ctr_crypt,
 	},
 };
 
diff --git a/arch/x86/include/asm/crypto/twofish.h b/arch/x86/include/asm/crypto/twofish.h
index 2c377a8042e1..12df400e6d53 100644
--- a/arch/x86/include/asm/crypto/twofish.h
+++ b/arch/x86/include/asm/crypto/twofish.h
@@ -17,9 +17,5 @@ asmlinkage void twofish_dec_blk_3way(const void *ctx, u8 *dst, const u8 *src);
 
 /* helpers from twofish_x86_64-3way module */
 extern void twofish_dec_blk_cbc_3way(const void *ctx, u8 *dst, const u8 *src);
-extern void twofish_enc_blk_ctr(const void *ctx, u8 *dst, const u8 *src,
-				le128 *iv);
-extern void twofish_enc_blk_ctr_3way(const void *ctx, u8 *dst, const u8 *src,
-				     le128 *iv);
 
 #endif /* ASM_X86_TWOFISH_H */
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 3f51c5dfc2a9..606f94079f05 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1680,6 +1680,7 @@ config CRYPTO_TWOFISH_586
 	depends on (X86 || UML_X86) && !64BIT
 	select CRYPTO_ALGAPI
 	select CRYPTO_TWOFISH_COMMON
+	imply CRYPTO_CTR
 	help
 	  Twofish cipher algorithm.
 
@@ -1696,6 +1697,7 @@ config CRYPTO_TWOFISH_X86_64
 	depends on (X86 || UML_X86) && 64BIT
 	select CRYPTO_ALGAPI
 	select CRYPTO_TWOFISH_COMMON
+	imply CRYPTO_CTR
 	help
 	  Twofish cipher algorithm (x86_64).
 
-- 
2.17.1

