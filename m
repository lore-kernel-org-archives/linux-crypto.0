Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63A62C433E6
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 22:40:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E2A322571
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 22:40:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgLWWkZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Dec 2020 17:40:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:59404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbgLWWkZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Dec 2020 17:40:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B1DD2251F;
        Wed, 23 Dec 2020 22:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608763158;
        bh=rWHg6uK6Yo43tuWOk9tikvZnkxKpz4vFwHISQg56P88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rjp/K/jTbml4fDtglSnbtxVmAOxY2EUbO3JAqQhaIpES0MyfrGIukAN6sKJX1wiK3
         m7uwk6qit5tXE9tnFywvw1ij7xirVPDCWO6Gu40KP3+fAppZhseKw9QO2nEw6krQMP
         aQOkpsykRW+7E15EqXGtLtfvkPa8Z/0RX+BCl7XIU4O3KDeINZxGxxXSim4pBDc+h+
         yulyeXA/Ydh67NlXvFKer6ZzOSfHRmECIJIOcOQkeyhS/nfcwkndH73z4GZt57S7su
         bC4BPXPAmlGMgKSwWkAjhKlpu+5xUEllqFx4pdDFxtN+3Wo+lDS3mRHU1iZO7zyYuH
         qA9//7QhY+HWA==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     dm-devel@redhat.com, Ard Biesheuvel <ardb@kernel.org>,
        Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [RFC PATCH 07/10] crypto: x86/cast6 - drop CTR mode implementation
Date:   Wed, 23 Dec 2020 23:38:38 +0100
Message-Id: <20201223223841.11311-8-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201223223841.11311-1-ardb@kernel.org>
References: <20201223223841.11311-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

CAST6 in CTR mode is never used by the kernel directly*, and is highly
unlikely to be relied upon by dm-crypt or algif_skcipher. So let's drop
the accelerated CTR mode implementation, and instead, rely on the CTR
template and the bare cipher.

* it is not used at all, so we might remove the accelerated implementation
  entirely in a future patch.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S | 28 ------------
 arch/x86/crypto/cast6_avx_glue.c          | 48 --------------------
 2 files changed, 76 deletions(-)

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
 
-- 
2.17.1

