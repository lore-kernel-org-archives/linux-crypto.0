Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0F19C433DB
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 22:40:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 714C422571
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 22:40:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgLWWk1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Dec 2020 17:40:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:59406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726662AbgLWWk0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Dec 2020 17:40:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7AB82251E;
        Wed, 23 Dec 2020 22:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608763160;
        bh=yMEco4jB6uPO3oCF1nLy/Rr8w5NC9egUV5C3NnmzVCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sz+lShGkzXwrAfJ/3A9DizkviUJrcdZJ5V8N3llj111kY5+6hBilzxuFotvU3KkwW
         MZjY/ingR6jkr2mxPbQoR6R2Ov9uqiTOHjUhmjfhOGWLveySPme9EMllfQHWHwNJoN
         vU2TRSgewZnf5prlkB9w+6DEd5ItnUdKWK94ztBGtTVVcj9lEbVbszohOZLQ1JHPM5
         vhTIDtPRC1I5NO9AAKJzrb74AjRHo8GbiqGQqRBtVz+G8/iCCWTqtfUrqLVP+uy554
         kcJJb85SAMGOY3jkwb6tw/66M39gIU/U+N3DKdE1/qZO878g2tc++qeYaZOcLFexfz
         jU0IOFZmdBYjg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     dm-devel@redhat.com, Ard Biesheuvel <ardb@kernel.org>,
        Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [RFC PATCH 08/10] crypto: x86/serpent - drop CTR mode implementation
Date:   Wed, 23 Dec 2020 23:38:39 +0100
Message-Id: <20201223223841.11311-9-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201223223841.11311-1-ardb@kernel.org>
References: <20201223223841.11311-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Serpent in CTR mode is never used by the kernel directly, and is highly
unlikely to be relied upon by dm-crypt or algif_skcipher. So let's drop
the accelerated CTR mode implementation, and instead, rely on the CTR
template and the bare cipher.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/serpent-avx-x86_64-asm_64.S | 20 ------
 arch/x86/crypto/serpent-avx2-asm_64.S       | 25 --------
 arch/x86/crypto/serpent_avx2_glue.c         | 38 -----------
 arch/x86/crypto/serpent_avx_glue.c          | 51 ---------------
 arch/x86/crypto/serpent_sse2_glue.c         | 67 --------------------
 5 files changed, 201 deletions(-)

diff --git a/arch/x86/crypto/serpent-avx-x86_64-asm_64.S b/arch/x86/crypto/serpent-avx-x86_64-asm_64.S
index 6b41f46bcc76..b7ee24df7fba 100644
--- a/arch/x86/crypto/serpent-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/serpent-avx-x86_64-asm_64.S
@@ -711,23 +711,3 @@ SYM_FUNC_START(serpent_cbc_dec_8way_avx)
 	FRAME_END
 	ret;
 SYM_FUNC_END(serpent_cbc_dec_8way_avx)
-
-SYM_FUNC_START(serpent_ctr_8way_avx)
-	/* input:
-	 *	%rdi: ctx, CTX
-	 *	%rsi: dst
-	 *	%rdx: src
-	 *	%rcx: iv (little endian, 128bit)
-	 */
-	FRAME_BEGIN
-
-	load_ctr_8way(%rcx, .Lbswap128_mask, RA1, RB1, RC1, RD1, RA2, RB2, RC2,
-		      RD2, RK0, RK1, RK2);
-
-	call __serpent_enc_blk8_avx;
-
-	store_ctr_8way(%rdx, %rsi, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
-
-	FRAME_END
-	ret;
-SYM_FUNC_END(serpent_ctr_8way_avx)
diff --git a/arch/x86/crypto/serpent-avx2-asm_64.S b/arch/x86/crypto/serpent-avx2-asm_64.S
index a510a949f02f..9161b6e441f3 100644
--- a/arch/x86/crypto/serpent-avx2-asm_64.S
+++ b/arch/x86/crypto/serpent-avx2-asm_64.S
@@ -724,28 +724,3 @@ SYM_FUNC_START(serpent_cbc_dec_16way)
 	FRAME_END
 	ret;
 SYM_FUNC_END(serpent_cbc_dec_16way)
-
-SYM_FUNC_START(serpent_ctr_16way)
-	/* input:
-	 *	%rdi: ctx, CTX
-	 *	%rsi: dst (16 blocks)
-	 *	%rdx: src (16 blocks)
-	 *	%rcx: iv (little endian, 128bit)
-	 */
-	FRAME_BEGIN
-
-	vzeroupper;
-
-	load_ctr_16way(%rcx, .Lbswap128_mask, RA1, RB1, RC1, RD1, RA2, RB2, RC2,
-		       RD2, RK0, RK0x, RK1, RK1x, RK2, RK2x, RK3, RK3x, RNOT,
-		       tp);
-
-	call __serpent_enc_blk16;
-
-	store_ctr_16way(%rdx, %rsi, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
-
-	vzeroupper;
-
-	FRAME_END
-	ret;
-SYM_FUNC_END(serpent_ctr_16way)
diff --git a/arch/x86/crypto/serpent_avx2_glue.c b/arch/x86/crypto/serpent_avx2_glue.c
index 9cdf2c078e21..28e542c6512a 100644
--- a/arch/x86/crypto/serpent_avx2_glue.c
+++ b/arch/x86/crypto/serpent_avx2_glue.c
@@ -22,8 +22,6 @@ asmlinkage void serpent_ecb_enc_16way(const void *ctx, u8 *dst, const u8 *src);
 asmlinkage void serpent_ecb_dec_16way(const void *ctx, u8 *dst, const u8 *src);
 asmlinkage void serpent_cbc_dec_16way(const void *ctx, u8 *dst, const u8 *src);
 
-asmlinkage void serpent_ctr_16way(const void *ctx, u8 *dst, const u8 *src,
-				  le128 *iv);
 static int serpent_setkey_skcipher(struct crypto_skcipher *tfm,
 				   const u8 *key, unsigned int keylen)
 {
@@ -46,22 +44,6 @@ static const struct common_glue_ctx serpent_enc = {
 	} }
 };
 
-static const struct common_glue_ctx serpent_ctr = {
-	.num_funcs = 3,
-	.fpu_blocks_limit = 8,
-
-	.funcs = { {
-		.num_blocks = 16,
-		.fn_u = { .ctr = serpent_ctr_16way }
-	},  {
-		.num_blocks = 8,
-		.fn_u = { .ctr = serpent_ctr_8way_avx }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .ctr = __serpent_crypt_ctr }
-	} }
-};
-
 static const struct common_glue_ctx serpent_dec = {
 	.num_funcs = 3,
 	.fpu_blocks_limit = 8,
@@ -114,11 +96,6 @@ static int cbc_decrypt(struct skcipher_request *req)
 	return glue_cbc_decrypt_req_128bit(&serpent_dec_cbc, req);
 }
 
-static int ctr_crypt(struct skcipher_request *req)
-{
-	return glue_ctr_req_128bit(&serpent_ctr, req);
-}
-
 static struct skcipher_alg serpent_algs[] = {
 	{
 		.base.cra_name		= "__ecb(serpent)",
@@ -147,21 +124,6 @@ static struct skcipher_alg serpent_algs[] = {
 		.setkey			= serpent_setkey_skcipher,
 		.encrypt		= cbc_encrypt,
 		.decrypt		= cbc_decrypt,
-	}, {
-		.base.cra_name		= "__ctr(serpent)",
-		.base.cra_driver_name	= "__ctr-serpent-avx2",
-		.base.cra_priority	= 600,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
-		.base.cra_blocksize	= 1,
-		.base.cra_ctxsize	= sizeof(struct serpent_ctx),
-		.base.cra_module	= THIS_MODULE,
-		.min_keysize		= SERPENT_MIN_KEY_SIZE,
-		.max_keysize		= SERPENT_MAX_KEY_SIZE,
-		.ivsize			= SERPENT_BLOCK_SIZE,
-		.chunksize		= SERPENT_BLOCK_SIZE,
-		.setkey			= serpent_setkey_skcipher,
-		.encrypt		= ctr_crypt,
-		.decrypt		= ctr_crypt,
 	},
 };
 
diff --git a/arch/x86/crypto/serpent_avx_glue.c b/arch/x86/crypto/serpent_avx_glue.c
index b17a08b57a91..aa4605baf9d4 100644
--- a/arch/x86/crypto/serpent_avx_glue.c
+++ b/arch/x86/crypto/serpent_avx_glue.c
@@ -31,24 +31,6 @@ asmlinkage void serpent_cbc_dec_8way_avx(const void *ctx, u8 *dst,
 					 const u8 *src);
 EXPORT_SYMBOL_GPL(serpent_cbc_dec_8way_avx);
 
-asmlinkage void serpent_ctr_8way_avx(const void *ctx, u8 *dst, const u8 *src,
-				     le128 *iv);
-EXPORT_SYMBOL_GPL(serpent_ctr_8way_avx);
-
-void __serpent_crypt_ctr(const void *ctx, u8 *d, const u8 *s, le128 *iv)
-{
-	be128 ctrblk;
-	u128 *dst = (u128 *)d;
-	const u128 *src = (const u128 *)s;
-
-	le128_to_be128(&ctrblk, iv);
-	le128_inc(iv);
-
-	__serpent_encrypt(ctx, (u8 *)&ctrblk, (u8 *)&ctrblk);
-	u128_xor(dst, src, (u128 *)&ctrblk);
-}
-EXPORT_SYMBOL_GPL(__serpent_crypt_ctr);
-
 static int serpent_setkey_skcipher(struct crypto_skcipher *tfm,
 				   const u8 *key, unsigned int keylen)
 {
@@ -68,19 +50,6 @@ static const struct common_glue_ctx serpent_enc = {
 	} }
 };
 
-static const struct common_glue_ctx serpent_ctr = {
-	.num_funcs = 2,
-	.fpu_blocks_limit = SERPENT_PARALLEL_BLOCKS,
-
-	.funcs = { {
-		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .ctr = serpent_ctr_8way_avx }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .ctr = __serpent_crypt_ctr }
-	} }
-};
-
 static const struct common_glue_ctx serpent_dec = {
 	.num_funcs = 2,
 	.fpu_blocks_limit = SERPENT_PARALLEL_BLOCKS,
@@ -127,11 +96,6 @@ static int cbc_decrypt(struct skcipher_request *req)
 	return glue_cbc_decrypt_req_128bit(&serpent_dec_cbc, req);
 }
 
-static int ctr_crypt(struct skcipher_request *req)
-{
-	return glue_ctr_req_128bit(&serpent_ctr, req);
-}
-
 static struct skcipher_alg serpent_algs[] = {
 	{
 		.base.cra_name		= "__ecb(serpent)",
@@ -160,21 +124,6 @@ static struct skcipher_alg serpent_algs[] = {
 		.setkey			= serpent_setkey_skcipher,
 		.encrypt		= cbc_encrypt,
 		.decrypt		= cbc_decrypt,
-	}, {
-		.base.cra_name		= "__ctr(serpent)",
-		.base.cra_driver_name	= "__ctr-serpent-avx",
-		.base.cra_priority	= 500,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
-		.base.cra_blocksize	= 1,
-		.base.cra_ctxsize	= sizeof(struct serpent_ctx),
-		.base.cra_module	= THIS_MODULE,
-		.min_keysize		= SERPENT_MIN_KEY_SIZE,
-		.max_keysize		= SERPENT_MAX_KEY_SIZE,
-		.ivsize			= SERPENT_BLOCK_SIZE,
-		.chunksize		= SERPENT_BLOCK_SIZE,
-		.setkey			= serpent_setkey_skcipher,
-		.encrypt		= ctr_crypt,
-		.decrypt		= ctr_crypt,
 	},
 };
 
diff --git a/arch/x86/crypto/serpent_sse2_glue.c b/arch/x86/crypto/serpent_sse2_glue.c
index 4fed8d26b91a..9acb3bf28feb 100644
--- a/arch/x86/crypto/serpent_sse2_glue.c
+++ b/arch/x86/crypto/serpent_sse2_glue.c
@@ -10,8 +10,6 @@
  *
  * CBC & ECB parts based on code (crypto/cbc.c,ecb.c) by:
  *   Copyright (c) 2006 Herbert Xu <herbert@gondor.apana.org.au>
- * CTR part based on code (crypto/ctr.c) by:
- *   (C) Copyright IBM Corp. 2007 - Joy Latten <latten@us.ibm.com>
  */
 
 #include <linux/module.h>
@@ -47,38 +45,6 @@ static void serpent_decrypt_cbc_xway(const void *ctx, u8 *d, const u8 *s)
 		u128_xor(dst + (j + 1), dst + (j + 1), ivs + j);
 }
 
-static void serpent_crypt_ctr(const void *ctx, u8 *d, const u8 *s, le128 *iv)
-{
-	be128 ctrblk;
-	u128 *dst = (u128 *)d;
-	const u128 *src = (const u128 *)s;
-
-	le128_to_be128(&ctrblk, iv);
-	le128_inc(iv);
-
-	__serpent_encrypt(ctx, (u8 *)&ctrblk, (u8 *)&ctrblk);
-	u128_xor(dst, src, (u128 *)&ctrblk);
-}
-
-static void serpent_crypt_ctr_xway(const void *ctx, u8 *d, const u8 *s,
-				   le128 *iv)
-{
-	be128 ctrblks[SERPENT_PARALLEL_BLOCKS];
-	u128 *dst = (u128 *)d;
-	const u128 *src = (const u128 *)s;
-	unsigned int i;
-
-	for (i = 0; i < SERPENT_PARALLEL_BLOCKS; i++) {
-		if (dst != src)
-			dst[i] = src[i];
-
-		le128_to_be128(&ctrblks[i], iv);
-		le128_inc(iv);
-	}
-
-	serpent_enc_blk_xway_xor(ctx, (u8 *)dst, (u8 *)ctrblks);
-}
-
 static const struct common_glue_ctx serpent_enc = {
 	.num_funcs = 2,
 	.fpu_blocks_limit = SERPENT_PARALLEL_BLOCKS,
@@ -92,19 +58,6 @@ static const struct common_glue_ctx serpent_enc = {
 	} }
 };
 
-static const struct common_glue_ctx serpent_ctr = {
-	.num_funcs = 2,
-	.fpu_blocks_limit = SERPENT_PARALLEL_BLOCKS,
-
-	.funcs = { {
-		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .ctr = serpent_crypt_ctr_xway }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .ctr = serpent_crypt_ctr }
-	} }
-};
-
 static const struct common_glue_ctx serpent_dec = {
 	.num_funcs = 2,
 	.fpu_blocks_limit = SERPENT_PARALLEL_BLOCKS,
@@ -152,11 +105,6 @@ static int cbc_decrypt(struct skcipher_request *req)
 	return glue_cbc_decrypt_req_128bit(&serpent_dec_cbc, req);
 }
 
-static int ctr_crypt(struct skcipher_request *req)
-{
-	return glue_ctr_req_128bit(&serpent_ctr, req);
-}
-
 static struct skcipher_alg serpent_algs[] = {
 	{
 		.base.cra_name		= "__ecb(serpent)",
@@ -185,21 +133,6 @@ static struct skcipher_alg serpent_algs[] = {
 		.setkey			= serpent_setkey_skcipher,
 		.encrypt		= cbc_encrypt,
 		.decrypt		= cbc_decrypt,
-	}, {
-		.base.cra_name		= "__ctr(serpent)",
-		.base.cra_driver_name	= "__ctr-serpent-sse2",
-		.base.cra_priority	= 400,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
-		.base.cra_blocksize	= 1,
-		.base.cra_ctxsize	= sizeof(struct serpent_ctx),
-		.base.cra_module	= THIS_MODULE,
-		.min_keysize		= SERPENT_MIN_KEY_SIZE,
-		.max_keysize		= SERPENT_MAX_KEY_SIZE,
-		.ivsize			= SERPENT_BLOCK_SIZE,
-		.chunksize		= SERPENT_BLOCK_SIZE,
-		.setkey			= serpent_setkey_skcipher,
-		.encrypt		= ctr_crypt,
-		.decrypt		= ctr_crypt,
 	},
 };
 
-- 
2.17.1

