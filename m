Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38F3CC433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 17:25:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F176C223E4
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 17:25:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726848AbgLaRZO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Dec 2020 12:25:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:55028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726821AbgLaRZO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Dec 2020 12:25:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4925F22472;
        Thu, 31 Dec 2020 17:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609435443;
        bh=Bncq3p07y4vzXMssM3usmQCyxP0h3Sn+wWGRLBMj1aA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GenncMWXmDfK15ggwJdz5ydkQtyPRo7p3wDpEob6rst9XG1ZtxhTOwwqhQw9hLlCR
         OhMNpdVx66IJDjeL8TTN1k6pStdbN9pUmDEih7YXqg1jpKr3ZjxN4zzpLem2R1szD4
         nIAcY2lJRkOq2Z43w++dI8bmoEHuD6m7CPYLEfhZtKH5qlJheX2sCyhOosEOD9Pin5
         tBOAGtN5bV12WXd3U5PkRrAnJXiTD6GnVYYaxRc9sGpY7WiWFTz4t8rumm49TI9lTJ
         qinH6i//8FHCrnTVR8VARzWdjQYnzRItm0+DuL8clO3LlibaiyhFQGGLDQG/9qIhom
         EordeDltVvVcA==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 06/21] crypto: x86/camellia - drop CTR mode implementation
Date:   Thu, 31 Dec 2020 18:23:22 +0100
Message-Id: <20201231172337.23073-7-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201231172337.23073-1-ardb@kernel.org>
References: <20201231172337.23073-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Camellia in CTR mode is never used by the kernel directly, and is highly
unlikely to be relied upon by dm-crypt or algif_skcipher. So let's drop
the accelerated CTR mode implementation, and instead, rely on the CTR
template and the bare cipher.

Acked-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/camellia-aesni-avx-asm_64.S  | 117 ----------------
 arch/x86/crypto/camellia-aesni-avx2-asm_64.S | 144 --------------------
 arch/x86/crypto/camellia_aesni_avx2_glue.c   |  41 ------
 arch/x86/crypto/camellia_aesni_avx_glue.c    |  40 ------
 arch/x86/crypto/camellia_glue.c              |  68 ---------
 arch/x86/include/asm/crypto/camellia.h       |   6 -
 crypto/Kconfig                               |   1 +
 7 files changed, 1 insertion(+), 416 deletions(-)

diff --git a/arch/x86/crypto/camellia-aesni-avx-asm_64.S b/arch/x86/crypto/camellia-aesni-avx-asm_64.S
index 471c34e6cac2..e2a0e0f4bf9d 100644
--- a/arch/x86/crypto/camellia-aesni-avx-asm_64.S
+++ b/arch/x86/crypto/camellia-aesni-avx-asm_64.S
@@ -588,10 +588,6 @@ SYM_FUNC_END(roundsm16_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
 	.long 0x80808080
 	.long 0x80808080
 
-/* For CTR-mode IV byteswap */
-.Lbswap128_mask:
-	.byte 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
-
 /*
  * pre-SubByte transform
  *
@@ -993,116 +989,3 @@ SYM_FUNC_START(camellia_cbc_dec_16way)
 	FRAME_END
 	ret;
 SYM_FUNC_END(camellia_cbc_dec_16way)
-
-#define inc_le128(x, minus_one, tmp) \
-	vpcmpeqq minus_one, x, tmp; \
-	vpsubq minus_one, x, x; \
-	vpslldq $8, tmp, tmp; \
-	vpsubq tmp, x, x;
-
-SYM_FUNC_START(camellia_ctr_16way)
-	/* input:
-	 *	%rdi: ctx, CTX
-	 *	%rsi: dst (16 blocks)
-	 *	%rdx: src (16 blocks)
-	 *	%rcx: iv (little endian, 128bit)
-	 */
-	FRAME_BEGIN
-
-	subq $(16 * 16), %rsp;
-	movq %rsp, %rax;
-
-	vmovdqa .Lbswap128_mask, %xmm14;
-
-	/* load IV and byteswap */
-	vmovdqu (%rcx), %xmm0;
-	vpshufb %xmm14, %xmm0, %xmm15;
-	vmovdqu %xmm15, 15 * 16(%rax);
-
-	vpcmpeqd %xmm15, %xmm15, %xmm15;
-	vpsrldq $8, %xmm15, %xmm15; /* low: -1, high: 0 */
-
-	/* construct IVs */
-	inc_le128(%xmm0, %xmm15, %xmm13);
-	vpshufb %xmm14, %xmm0, %xmm13;
-	vmovdqu %xmm13, 14 * 16(%rax);
-	inc_le128(%xmm0, %xmm15, %xmm13);
-	vpshufb %xmm14, %xmm0, %xmm13;
-	vmovdqu %xmm13, 13 * 16(%rax);
-	inc_le128(%xmm0, %xmm15, %xmm13);
-	vpshufb %xmm14, %xmm0, %xmm12;
-	inc_le128(%xmm0, %xmm15, %xmm13);
-	vpshufb %xmm14, %xmm0, %xmm11;
-	inc_le128(%xmm0, %xmm15, %xmm13);
-	vpshufb %xmm14, %xmm0, %xmm10;
-	inc_le128(%xmm0, %xmm15, %xmm13);
-	vpshufb %xmm14, %xmm0, %xmm9;
-	inc_le128(%xmm0, %xmm15, %xmm13);
-	vpshufb %xmm14, %xmm0, %xmm8;
-	inc_le128(%xmm0, %xmm15, %xmm13);
-	vpshufb %xmm14, %xmm0, %xmm7;
-	inc_le128(%xmm0, %xmm15, %xmm13);
-	vpshufb %xmm14, %xmm0, %xmm6;
-	inc_le128(%xmm0, %xmm15, %xmm13);
-	vpshufb %xmm14, %xmm0, %xmm5;
-	inc_le128(%xmm0, %xmm15, %xmm13);
-	vpshufb %xmm14, %xmm0, %xmm4;
-	inc_le128(%xmm0, %xmm15, %xmm13);
-	vpshufb %xmm14, %xmm0, %xmm3;
-	inc_le128(%xmm0, %xmm15, %xmm13);
-	vpshufb %xmm14, %xmm0, %xmm2;
-	inc_le128(%xmm0, %xmm15, %xmm13);
-	vpshufb %xmm14, %xmm0, %xmm1;
-	inc_le128(%xmm0, %xmm15, %xmm13);
-	vmovdqa %xmm0, %xmm13;
-	vpshufb %xmm14, %xmm0, %xmm0;
-	inc_le128(%xmm13, %xmm15, %xmm14);
-	vmovdqu %xmm13, (%rcx);
-
-	/* inpack16_pre: */
-	vmovq (key_table)(CTX), %xmm15;
-	vpshufb .Lpack_bswap, %xmm15, %xmm15;
-	vpxor %xmm0, %xmm15, %xmm0;
-	vpxor %xmm1, %xmm15, %xmm1;
-	vpxor %xmm2, %xmm15, %xmm2;
-	vpxor %xmm3, %xmm15, %xmm3;
-	vpxor %xmm4, %xmm15, %xmm4;
-	vpxor %xmm5, %xmm15, %xmm5;
-	vpxor %xmm6, %xmm15, %xmm6;
-	vpxor %xmm7, %xmm15, %xmm7;
-	vpxor %xmm8, %xmm15, %xmm8;
-	vpxor %xmm9, %xmm15, %xmm9;
-	vpxor %xmm10, %xmm15, %xmm10;
-	vpxor %xmm11, %xmm15, %xmm11;
-	vpxor %xmm12, %xmm15, %xmm12;
-	vpxor 13 * 16(%rax), %xmm15, %xmm13;
-	vpxor 14 * 16(%rax), %xmm15, %xmm14;
-	vpxor 15 * 16(%rax), %xmm15, %xmm15;
-
-	call __camellia_enc_blk16;
-
-	addq $(16 * 16), %rsp;
-
-	vpxor 0 * 16(%rdx), %xmm7, %xmm7;
-	vpxor 1 * 16(%rdx), %xmm6, %xmm6;
-	vpxor 2 * 16(%rdx), %xmm5, %xmm5;
-	vpxor 3 * 16(%rdx), %xmm4, %xmm4;
-	vpxor 4 * 16(%rdx), %xmm3, %xmm3;
-	vpxor 5 * 16(%rdx), %xmm2, %xmm2;
-	vpxor 6 * 16(%rdx), %xmm1, %xmm1;
-	vpxor 7 * 16(%rdx), %xmm0, %xmm0;
-	vpxor 8 * 16(%rdx), %xmm15, %xmm15;
-	vpxor 9 * 16(%rdx), %xmm14, %xmm14;
-	vpxor 10 * 16(%rdx), %xmm13, %xmm13;
-	vpxor 11 * 16(%rdx), %xmm12, %xmm12;
-	vpxor 12 * 16(%rdx), %xmm11, %xmm11;
-	vpxor 13 * 16(%rdx), %xmm10, %xmm10;
-	vpxor 14 * 16(%rdx), %xmm9, %xmm9;
-	vpxor 15 * 16(%rdx), %xmm8, %xmm8;
-	write_output(%xmm7, %xmm6, %xmm5, %xmm4, %xmm3, %xmm2, %xmm1, %xmm0,
-		     %xmm15, %xmm14, %xmm13, %xmm12, %xmm11, %xmm10, %xmm9,
-		     %xmm8, %rsi);
-
-	FRAME_END
-	ret;
-SYM_FUNC_END(camellia_ctr_16way)
diff --git a/arch/x86/crypto/camellia-aesni-avx2-asm_64.S b/arch/x86/crypto/camellia-aesni-avx2-asm_64.S
index 9561dee52de0..782e9712a1ec 100644
--- a/arch/x86/crypto/camellia-aesni-avx2-asm_64.S
+++ b/arch/x86/crypto/camellia-aesni-avx2-asm_64.S
@@ -624,10 +624,6 @@ SYM_FUNC_END(roundsm32_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
 .section	.rodata.cst16, "aM", @progbits, 16
 .align 16
 
-/* For CTR-mode IV byteswap */
-.Lbswap128_mask:
-	.byte 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
-
 /*
  * pre-SubByte transform
  *
@@ -1054,143 +1050,3 @@ SYM_FUNC_START(camellia_cbc_dec_32way)
 	FRAME_END
 	ret;
 SYM_FUNC_END(camellia_cbc_dec_32way)
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
-SYM_FUNC_START(camellia_ctr_32way)
-	/* input:
-	 *	%rdi: ctx, CTX
-	 *	%rsi: dst (32 blocks)
-	 *	%rdx: src (32 blocks)
-	 *	%rcx: iv (little endian, 128bit)
-	 */
-	FRAME_BEGIN
-
-	vzeroupper;
-
-	movq %rsp, %r10;
-	cmpq %rsi, %rdx;
-	je .Lctr_use_stack;
-
-	/* dst can be used as temporary storage, src is not overwritten. */
-	movq %rsi, %rax;
-	jmp .Lctr_continue;
-
-.Lctr_use_stack:
-	subq $(16 * 32), %rsp;
-	movq %rsp, %rax;
-
-.Lctr_continue:
-	vpcmpeqd %ymm15, %ymm15, %ymm15;
-	vpsrldq $8, %ymm15, %ymm15; /* ab: -1:0 ; cd: -1:0 */
-	vpaddq %ymm15, %ymm15, %ymm12; /* ab: -2:0 ; cd: -2:0 */
-
-	/* load IV and byteswap */
-	vmovdqu (%rcx), %xmm0;
-	vmovdqa %xmm0, %xmm1;
-	inc_le128(%xmm0, %xmm15, %xmm14);
-	vbroadcasti128 .Lbswap128_mask, %ymm14;
-	vinserti128 $1, %xmm0, %ymm1, %ymm0;
-	vpshufb %ymm14, %ymm0, %ymm13;
-	vmovdqu %ymm13, 15 * 32(%rax);
-
-	/* construct IVs */
-	add2_le128(%ymm0, %ymm15, %ymm12, %ymm11, %ymm13); /* ab:le2 ; cd:le3 */
-	vpshufb %ymm14, %ymm0, %ymm13;
-	vmovdqu %ymm13, 14 * 32(%rax);
-	add2_le128(%ymm0, %ymm15, %ymm12, %ymm11, %ymm13);
-	vpshufb %ymm14, %ymm0, %ymm13;
-	vmovdqu %ymm13, 13 * 32(%rax);
-	add2_le128(%ymm0, %ymm15, %ymm12, %ymm11, %ymm13);
-	vpshufb %ymm14, %ymm0, %ymm13;
-	vmovdqu %ymm13, 12 * 32(%rax);
-	add2_le128(%ymm0, %ymm15, %ymm12, %ymm11, %ymm13);
-	vpshufb %ymm14, %ymm0, %ymm13;
-	vmovdqu %ymm13, 11 * 32(%rax);
-	add2_le128(%ymm0, %ymm15, %ymm12, %ymm11, %ymm13);
-	vpshufb %ymm14, %ymm0, %ymm10;
-	add2_le128(%ymm0, %ymm15, %ymm12, %ymm11, %ymm13);
-	vpshufb %ymm14, %ymm0, %ymm9;
-	add2_le128(%ymm0, %ymm15, %ymm12, %ymm11, %ymm13);
-	vpshufb %ymm14, %ymm0, %ymm8;
-	add2_le128(%ymm0, %ymm15, %ymm12, %ymm11, %ymm13);
-	vpshufb %ymm14, %ymm0, %ymm7;
-	add2_le128(%ymm0, %ymm15, %ymm12, %ymm11, %ymm13);
-	vpshufb %ymm14, %ymm0, %ymm6;
-	add2_le128(%ymm0, %ymm15, %ymm12, %ymm11, %ymm13);
-	vpshufb %ymm14, %ymm0, %ymm5;
-	add2_le128(%ymm0, %ymm15, %ymm12, %ymm11, %ymm13);
-	vpshufb %ymm14, %ymm0, %ymm4;
-	add2_le128(%ymm0, %ymm15, %ymm12, %ymm11, %ymm13);
-	vpshufb %ymm14, %ymm0, %ymm3;
-	add2_le128(%ymm0, %ymm15, %ymm12, %ymm11, %ymm13);
-	vpshufb %ymm14, %ymm0, %ymm2;
-	add2_le128(%ymm0, %ymm15, %ymm12, %ymm11, %ymm13);
-	vpshufb %ymm14, %ymm0, %ymm1;
-	add2_le128(%ymm0, %ymm15, %ymm12, %ymm11, %ymm13);
-	vextracti128 $1, %ymm0, %xmm13;
-	vpshufb %ymm14, %ymm0, %ymm0;
-	inc_le128(%xmm13, %xmm15, %xmm14);
-	vmovdqu %xmm13, (%rcx);
-
-	/* inpack32_pre: */
-	vpbroadcastq (key_table)(CTX), %ymm15;
-	vpshufb .Lpack_bswap, %ymm15, %ymm15;
-	vpxor %ymm0, %ymm15, %ymm0;
-	vpxor %ymm1, %ymm15, %ymm1;
-	vpxor %ymm2, %ymm15, %ymm2;
-	vpxor %ymm3, %ymm15, %ymm3;
-	vpxor %ymm4, %ymm15, %ymm4;
-	vpxor %ymm5, %ymm15, %ymm5;
-	vpxor %ymm6, %ymm15, %ymm6;
-	vpxor %ymm7, %ymm15, %ymm7;
-	vpxor %ymm8, %ymm15, %ymm8;
-	vpxor %ymm9, %ymm15, %ymm9;
-	vpxor %ymm10, %ymm15, %ymm10;
-	vpxor 11 * 32(%rax), %ymm15, %ymm11;
-	vpxor 12 * 32(%rax), %ymm15, %ymm12;
-	vpxor 13 * 32(%rax), %ymm15, %ymm13;
-	vpxor 14 * 32(%rax), %ymm15, %ymm14;
-	vpxor 15 * 32(%rax), %ymm15, %ymm15;
-
-	call __camellia_enc_blk32;
-
-	movq %r10, %rsp;
-
-	vpxor 0 * 32(%rdx), %ymm7, %ymm7;
-	vpxor 1 * 32(%rdx), %ymm6, %ymm6;
-	vpxor 2 * 32(%rdx), %ymm5, %ymm5;
-	vpxor 3 * 32(%rdx), %ymm4, %ymm4;
-	vpxor 4 * 32(%rdx), %ymm3, %ymm3;
-	vpxor 5 * 32(%rdx), %ymm2, %ymm2;
-	vpxor 6 * 32(%rdx), %ymm1, %ymm1;
-	vpxor 7 * 32(%rdx), %ymm0, %ymm0;
-	vpxor 8 * 32(%rdx), %ymm15, %ymm15;
-	vpxor 9 * 32(%rdx), %ymm14, %ymm14;
-	vpxor 10 * 32(%rdx), %ymm13, %ymm13;
-	vpxor 11 * 32(%rdx), %ymm12, %ymm12;
-	vpxor 12 * 32(%rdx), %ymm11, %ymm11;
-	vpxor 13 * 32(%rdx), %ymm10, %ymm10;
-	vpxor 14 * 32(%rdx), %ymm9, %ymm9;
-	vpxor 15 * 32(%rdx), %ymm8, %ymm8;
-	write_output(%ymm7, %ymm6, %ymm5, %ymm4, %ymm3, %ymm2, %ymm1, %ymm0,
-		     %ymm15, %ymm14, %ymm13, %ymm12, %ymm11, %ymm10, %ymm9,
-		     %ymm8, %rsi);
-
-	vzeroupper;
-
-	FRAME_END
-	ret;
-SYM_FUNC_END(camellia_ctr_32way)
diff --git a/arch/x86/crypto/camellia_aesni_avx2_glue.c b/arch/x86/crypto/camellia_aesni_avx2_glue.c
index d956d0473668..8f25a2a6222e 100644
--- a/arch/x86/crypto/camellia_aesni_avx2_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx2_glue.c
@@ -22,8 +22,6 @@ asmlinkage void camellia_ecb_enc_32way(const void *ctx, u8 *dst, const u8 *src);
 asmlinkage void camellia_ecb_dec_32way(const void *ctx, u8 *dst, const u8 *src);
 
 asmlinkage void camellia_cbc_dec_32way(const void *ctx, u8 *dst, const u8 *src);
-asmlinkage void camellia_ctr_32way(const void *ctx, u8 *dst, const u8 *src,
-				   le128 *iv);
 
 static const struct common_glue_ctx camellia_enc = {
 	.num_funcs = 4,
@@ -44,25 +42,6 @@ static const struct common_glue_ctx camellia_enc = {
 	} }
 };
 
-static const struct common_glue_ctx camellia_ctr = {
-	.num_funcs = 4,
-	.fpu_blocks_limit = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-
-	.funcs = { {
-		.num_blocks = CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS,
-		.fn_u = { .ctr = camellia_ctr_32way }
-	}, {
-		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .ctr = camellia_ctr_16way }
-	}, {
-		.num_blocks = 2,
-		.fn_u = { .ctr = camellia_crypt_ctr_2way }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .ctr = camellia_crypt_ctr }
-	} }
-};
-
 static const struct common_glue_ctx camellia_dec = {
 	.num_funcs = 4,
 	.fpu_blocks_limit = CAMELLIA_AESNI_PARALLEL_BLOCKS,
@@ -127,11 +106,6 @@ static int cbc_decrypt(struct skcipher_request *req)
 	return glue_cbc_decrypt_req_128bit(&camellia_dec_cbc, req);
 }
 
-static int ctr_crypt(struct skcipher_request *req)
-{
-	return glue_ctr_req_128bit(&camellia_ctr, req);
-}
-
 static struct skcipher_alg camellia_algs[] = {
 	{
 		.base.cra_name		= "__ecb(camellia)",
@@ -160,21 +134,6 @@ static struct skcipher_alg camellia_algs[] = {
 		.setkey			= camellia_setkey,
 		.encrypt		= cbc_encrypt,
 		.decrypt		= cbc_decrypt,
-	}, {
-		.base.cra_name		= "__ctr(camellia)",
-		.base.cra_driver_name	= "__ctr-camellia-aesni-avx2",
-		.base.cra_priority	= 500,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
-		.base.cra_blocksize	= 1,
-		.base.cra_ctxsize	= sizeof(struct camellia_ctx),
-		.base.cra_module	= THIS_MODULE,
-		.min_keysize		= CAMELLIA_MIN_KEY_SIZE,
-		.max_keysize		= CAMELLIA_MAX_KEY_SIZE,
-		.ivsize			= CAMELLIA_BLOCK_SIZE,
-		.chunksize		= CAMELLIA_BLOCK_SIZE,
-		.setkey			= camellia_setkey,
-		.encrypt		= ctr_crypt,
-		.decrypt		= ctr_crypt,
 	},
 };
 
diff --git a/arch/x86/crypto/camellia_aesni_avx_glue.c b/arch/x86/crypto/camellia_aesni_avx_glue.c
index 44614f8a452c..22a89cdfedfb 100644
--- a/arch/x86/crypto/camellia_aesni_avx_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx_glue.c
@@ -26,10 +26,6 @@ EXPORT_SYMBOL_GPL(camellia_ecb_dec_16way);
 asmlinkage void camellia_cbc_dec_16way(const void *ctx, u8 *dst, const u8 *src);
 EXPORT_SYMBOL_GPL(camellia_cbc_dec_16way);
 
-asmlinkage void camellia_ctr_16way(const void *ctx, u8 *dst, const u8 *src,
-				   le128 *iv);
-EXPORT_SYMBOL_GPL(camellia_ctr_16way);
-
 static const struct common_glue_ctx camellia_enc = {
 	.num_funcs = 3,
 	.fpu_blocks_limit = CAMELLIA_AESNI_PARALLEL_BLOCKS,
@@ -46,22 +42,6 @@ static const struct common_glue_ctx camellia_enc = {
 	} }
 };
 
-static const struct common_glue_ctx camellia_ctr = {
-	.num_funcs = 3,
-	.fpu_blocks_limit = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-
-	.funcs = { {
-		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .ctr = camellia_ctr_16way }
-	}, {
-		.num_blocks = 2,
-		.fn_u = { .ctr = camellia_crypt_ctr_2way }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .ctr = camellia_crypt_ctr }
-	} }
-};
-
 static const struct common_glue_ctx camellia_dec = {
 	.num_funcs = 3,
 	.fpu_blocks_limit = CAMELLIA_AESNI_PARALLEL_BLOCKS,
@@ -120,11 +100,6 @@ static int cbc_decrypt(struct skcipher_request *req)
 	return glue_cbc_decrypt_req_128bit(&camellia_dec_cbc, req);
 }
 
-static int ctr_crypt(struct skcipher_request *req)
-{
-	return glue_ctr_req_128bit(&camellia_ctr, req);
-}
-
 static struct skcipher_alg camellia_algs[] = {
 	{
 		.base.cra_name		= "__ecb(camellia)",
@@ -153,21 +128,6 @@ static struct skcipher_alg camellia_algs[] = {
 		.setkey			= camellia_setkey,
 		.encrypt		= cbc_encrypt,
 		.decrypt		= cbc_decrypt,
-	}, {
-		.base.cra_name		= "__ctr(camellia)",
-		.base.cra_driver_name	= "__ctr-camellia-aesni",
-		.base.cra_priority	= 400,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
-		.base.cra_blocksize	= 1,
-		.base.cra_ctxsize	= sizeof(struct camellia_ctx),
-		.base.cra_module	= THIS_MODULE,
-		.min_keysize		= CAMELLIA_MIN_KEY_SIZE,
-		.max_keysize		= CAMELLIA_MAX_KEY_SIZE,
-		.ivsize			= CAMELLIA_BLOCK_SIZE,
-		.chunksize		= CAMELLIA_BLOCK_SIZE,
-		.setkey			= camellia_setkey,
-		.encrypt		= ctr_crypt,
-		.decrypt		= ctr_crypt,
 	}
 };
 
diff --git a/arch/x86/crypto/camellia_glue.c b/arch/x86/crypto/camellia_glue.c
index 242c056e5fa8..fefeedf2b33d 100644
--- a/arch/x86/crypto/camellia_glue.c
+++ b/arch/x86/crypto/camellia_glue.c
@@ -1274,42 +1274,6 @@ void camellia_decrypt_cbc_2way(const void *ctx, u8 *d, const u8 *s)
 }
 EXPORT_SYMBOL_GPL(camellia_decrypt_cbc_2way);
 
-void camellia_crypt_ctr(const void *ctx, u8 *d, const u8 *s, le128 *iv)
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
-	camellia_enc_blk_xor(ctx, (u8 *)dst, (u8 *)&ctrblk);
-}
-EXPORT_SYMBOL_GPL(camellia_crypt_ctr);
-
-void camellia_crypt_ctr_2way(const void *ctx, u8 *d, const u8 *s, le128 *iv)
-{
-	be128 ctrblks[2];
-	u128 *dst = (u128 *)d;
-	const u128 *src = (const u128 *)s;
-
-	if (dst != src) {
-		dst[0] = src[0];
-		dst[1] = src[1];
-	}
-
-	le128_to_be128(&ctrblks[0], iv);
-	le128_inc(iv);
-	le128_to_be128(&ctrblks[1], iv);
-	le128_inc(iv);
-
-	camellia_enc_blk_xor_2way(ctx, (u8 *)dst, (u8 *)ctrblks);
-}
-EXPORT_SYMBOL_GPL(camellia_crypt_ctr_2way);
-
 static const struct common_glue_ctx camellia_enc = {
 	.num_funcs = 2,
 	.fpu_blocks_limit = -1,
@@ -1323,19 +1287,6 @@ static const struct common_glue_ctx camellia_enc = {
 	} }
 };
 
-static const struct common_glue_ctx camellia_ctr = {
-	.num_funcs = 2,
-	.fpu_blocks_limit = -1,
-
-	.funcs = { {
-		.num_blocks = 2,
-		.fn_u = { .ctr = camellia_crypt_ctr_2way }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .ctr = camellia_crypt_ctr }
-	} }
-};
-
 static const struct common_glue_ctx camellia_dec = {
 	.num_funcs = 2,
 	.fpu_blocks_limit = -1,
@@ -1382,11 +1333,6 @@ static int cbc_decrypt(struct skcipher_request *req)
 	return glue_cbc_decrypt_req_128bit(&camellia_dec_cbc, req);
 }
 
-static int ctr_crypt(struct skcipher_request *req)
-{
-	return glue_ctr_req_128bit(&camellia_ctr, req);
-}
-
 static struct crypto_alg camellia_cipher_alg = {
 	.cra_name		= "camellia",
 	.cra_driver_name	= "camellia-asm",
@@ -1433,20 +1379,6 @@ static struct skcipher_alg camellia_skcipher_algs[] = {
 		.setkey			= camellia_setkey_skcipher,
 		.encrypt		= cbc_encrypt,
 		.decrypt		= cbc_decrypt,
-	}, {
-		.base.cra_name		= "ctr(camellia)",
-		.base.cra_driver_name	= "ctr-camellia-asm",
-		.base.cra_priority	= 300,
-		.base.cra_blocksize	= 1,
-		.base.cra_ctxsize	= sizeof(struct camellia_ctx),
-		.base.cra_module	= THIS_MODULE,
-		.min_keysize		= CAMELLIA_MIN_KEY_SIZE,
-		.max_keysize		= CAMELLIA_MAX_KEY_SIZE,
-		.ivsize			= CAMELLIA_BLOCK_SIZE,
-		.chunksize		= CAMELLIA_BLOCK_SIZE,
-		.setkey			= camellia_setkey_skcipher,
-		.encrypt		= ctr_crypt,
-		.decrypt		= ctr_crypt,
 	}
 };
 
diff --git a/arch/x86/include/asm/crypto/camellia.h b/arch/x86/include/asm/crypto/camellia.h
index 0e5f82adbaf9..1dcea79e8f8e 100644
--- a/arch/x86/include/asm/crypto/camellia.h
+++ b/arch/x86/include/asm/crypto/camellia.h
@@ -38,8 +38,6 @@ asmlinkage void camellia_ecb_enc_16way(const void *ctx, u8 *dst, const u8 *src);
 asmlinkage void camellia_ecb_dec_16way(const void *ctx, u8 *dst, const u8 *src);
 
 asmlinkage void camellia_cbc_dec_16way(const void *ctx, u8 *dst, const u8 *src);
-asmlinkage void camellia_ctr_16way(const void *ctx, u8 *dst, const u8 *src,
-				   le128 *iv);
 
 static inline void camellia_enc_blk(const void *ctx, u8 *dst, const u8 *src)
 {
@@ -65,9 +63,5 @@ static inline void camellia_enc_blk_xor_2way(const void *ctx, u8 *dst,
 
 /* glue helpers */
 extern void camellia_decrypt_cbc_2way(const void *ctx, u8 *dst, const u8 *src);
-extern void camellia_crypt_ctr(const void *ctx, u8 *dst, const u8 *src,
-			       le128 *iv);
-extern void camellia_crypt_ctr_2way(const void *ctx, u8 *dst, const u8 *src,
-				    le128 *iv);
 
 #endif /* ASM_X86_CAMELLIA_H */
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 7ad9bf84f4a0..ea788cab8c7d 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1286,6 +1286,7 @@ config CRYPTO_CAMELLIA_X86_64
 	depends on CRYPTO
 	select CRYPTO_SKCIPHER
 	select CRYPTO_GLUE_HELPER_X86
+	imply CRYPTO_CTR
 	help
 	  Camellia cipher algorithm module (x86_64).
 
-- 
2.17.1

