Return-Path: <SRS0=WqbL=AT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59AF1C433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 09:11:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35A232065D
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 09:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594199491;
	bh=MsPWQm5ohWcbdClWca9y89ayh8RlnZSGk4Tybo7Yg3o=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=EkDJNS1p6f9sJGY9KUfdonRjDD2LJ/PJa1ilSo5U4Fky/Celt+kC82wLRtB62i8ro
	 Iifb2wiL5eBBH0cHuKAFFJ/KDjro77cn3ef/K1tCfClan0C741ANGEY5pwRZ0+l5ge
	 byPHWoUp9hJXX62FPNK+px9BxBda4182vPdKBiHg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgGHJLa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jul 2020 05:11:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:55192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgGHJLa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jul 2020 05:11:30 -0400
Received: from e123331-lin.nice.arm.com (adsl-70.109.242.21.tellas.gr [109.242.21.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D11E2064C;
        Wed,  8 Jul 2020 09:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594199489;
        bh=MsPWQm5ohWcbdClWca9y89ayh8RlnZSGk4Tybo7Yg3o=;
        h=From:To:Cc:Subject:Date:From;
        b=aYUGRuPaRqJqEbDfLDRLav+iWnehlnscZsjVv5QgIg/YjwcMSam/jWnmqX4wEey6T
         8Ru+0ITjR3gRCt1kyyedkfs3lZ4tC1WSsq1BqnjVHfN/zPN0agHm/v4bHTij2zC0uw
         4e0prpXInxdAvM4Yf7grk3dCJ0M4fAF3eBd9wQO0=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] crypto: x86/chacha-sse3 - use unaligned loads for state array
Date:   Wed,  8 Jul 2020 12:11:18 +0300
Message-Id: <20200708091118.1389-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Due to the fact that the x86 port does not support allocating objects
on the stack with an alignment that exceeds 8 bytes, we have a rather
ugly hack in the x86 code for ChaCha to ensure that the state array is
aligned to 16 bytes, allowing the SSE3 implementation of the algorithm
to use aligned loads.

Given that the performance benefit of using of aligned loads appears to
be limited (~0.25% for 1k blocks using tcrypt on a Corei7-8650U), and
the fact that this hack has leaked into generic ChaCha code, let's just
remove it.

Cc: Martin Willi <martin@strongswan.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/chacha-ssse3-x86_64.S | 16 ++++++++--------
 arch/x86/crypto/chacha_glue.c         | 17 ++---------------
 include/crypto/chacha.h               |  4 ----
 3 files changed, 10 insertions(+), 27 deletions(-)

diff --git a/arch/x86/crypto/chacha-ssse3-x86_64.S b/arch/x86/crypto/chacha-ssse3-x86_64.S
index a38ab2512a6f..ca1788bfee16 100644
--- a/arch/x86/crypto/chacha-ssse3-x86_64.S
+++ b/arch/x86/crypto/chacha-ssse3-x86_64.S
@@ -120,10 +120,10 @@ SYM_FUNC_START(chacha_block_xor_ssse3)
 	FRAME_BEGIN
 
 	# x0..3 = s0..3
-	movdqa		0x00(%rdi),%xmm0
-	movdqa		0x10(%rdi),%xmm1
-	movdqa		0x20(%rdi),%xmm2
-	movdqa		0x30(%rdi),%xmm3
+	movdqu		0x00(%rdi),%xmm0
+	movdqu		0x10(%rdi),%xmm1
+	movdqu		0x20(%rdi),%xmm2
+	movdqu		0x30(%rdi),%xmm3
 	movdqa		%xmm0,%xmm8
 	movdqa		%xmm1,%xmm9
 	movdqa		%xmm2,%xmm10
@@ -205,10 +205,10 @@ SYM_FUNC_START(hchacha_block_ssse3)
 	# %edx: nrounds
 	FRAME_BEGIN
 
-	movdqa		0x00(%rdi),%xmm0
-	movdqa		0x10(%rdi),%xmm1
-	movdqa		0x20(%rdi),%xmm2
-	movdqa		0x30(%rdi),%xmm3
+	movdqu		0x00(%rdi),%xmm0
+	movdqu		0x10(%rdi),%xmm1
+	movdqu		0x20(%rdi),%xmm2
+	movdqu		0x30(%rdi),%xmm3
 
 	mov		%edx,%r8d
 	call		chacha_permute
diff --git a/arch/x86/crypto/chacha_glue.c b/arch/x86/crypto/chacha_glue.c
index 22250091cdbe..e67a59130025 100644
--- a/arch/x86/crypto/chacha_glue.c
+++ b/arch/x86/crypto/chacha_glue.c
@@ -14,8 +14,6 @@
 #include <linux/module.h>
 #include <asm/simd.h>
 
-#define CHACHA_STATE_ALIGN 16
-
 asmlinkage void chacha_block_xor_ssse3(u32 *state, u8 *dst, const u8 *src,
 				       unsigned int len, int nrounds);
 asmlinkage void chacha_4block_xor_ssse3(u32 *state, u8 *dst, const u8 *src,
@@ -124,8 +122,6 @@ static void chacha_dosimd(u32 *state, u8 *dst, const u8 *src,
 
 void hchacha_block_arch(const u32 *state, u32 *stream, int nrounds)
 {
-	state = PTR_ALIGN(state, CHACHA_STATE_ALIGN);
-
 	if (!static_branch_likely(&chacha_use_simd) || !crypto_simd_usable()) {
 		hchacha_block_generic(state, stream, nrounds);
 	} else {
@@ -138,8 +134,6 @@ EXPORT_SYMBOL(hchacha_block_arch);
 
 void chacha_init_arch(u32 *state, const u32 *key, const u8 *iv)
 {
-	state = PTR_ALIGN(state, CHACHA_STATE_ALIGN);
-
 	chacha_init_generic(state, key, iv);
 }
 EXPORT_SYMBOL(chacha_init_arch);
@@ -147,8 +141,6 @@ EXPORT_SYMBOL(chacha_init_arch);
 void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
 		       int nrounds)
 {
-	state = PTR_ALIGN(state, CHACHA_STATE_ALIGN);
-
 	if (!static_branch_likely(&chacha_use_simd) || !crypto_simd_usable() ||
 	    bytes <= CHACHA_BLOCK_SIZE)
 		return chacha_crypt_generic(state, dst, src, bytes, nrounds);
@@ -170,15 +162,12 @@ EXPORT_SYMBOL(chacha_crypt_arch);
 static int chacha_simd_stream_xor(struct skcipher_request *req,
 				  const struct chacha_ctx *ctx, const u8 *iv)
 {
-	u32 *state, state_buf[16 + 2] __aligned(8);
+	u32 state[CHACHA_STATE_WORDS] __aligned(8);
 	struct skcipher_walk walk;
 	int err;
 
 	err = skcipher_walk_virt(&walk, req, false);
 
-	BUILD_BUG_ON(CHACHA_STATE_ALIGN != 16);
-	state = PTR_ALIGN(state_buf + 0, CHACHA_STATE_ALIGN);
-
 	chacha_init_generic(state, ctx->key, iv);
 
 	while (walk.nbytes > 0) {
@@ -217,12 +206,10 @@ static int xchacha_simd(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
-	u32 *state, state_buf[16 + 2] __aligned(8);
+	u32 state[CHACHA_STATE_WORDS] __aligned(8);
 	struct chacha_ctx subctx;
 	u8 real_iv[16];
 
-	BUILD_BUG_ON(CHACHA_STATE_ALIGN != 16);
-	state = PTR_ALIGN(state_buf + 0, CHACHA_STATE_ALIGN);
 	chacha_init_generic(state, ctx->key, req->iv);
 
 	if (req->cryptlen > CHACHA_BLOCK_SIZE && crypto_simd_usable()) {
diff --git a/include/crypto/chacha.h b/include/crypto/chacha.h
index 2676f4fbd4c1..3a1c72fdb7cf 100644
--- a/include/crypto/chacha.h
+++ b/include/crypto/chacha.h
@@ -25,11 +25,7 @@
 #define CHACHA_BLOCK_SIZE	64
 #define CHACHAPOLY_IV_SIZE	12
 
-#ifdef CONFIG_X86_64
-#define CHACHA_STATE_WORDS	((CHACHA_BLOCK_SIZE + 12) / sizeof(u32))
-#else
 #define CHACHA_STATE_WORDS	(CHACHA_BLOCK_SIZE / sizeof(u32))
-#endif
 
 /* 192-bit nonce, then 64-bit stream position */
 #define XCHACHA_IV_SIZE		32
-- 
2.17.1

