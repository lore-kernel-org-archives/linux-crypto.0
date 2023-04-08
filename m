Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 120ACC77B6E
	for <linux-crypto@archiver.kernel.org>; Sat,  8 Apr 2023 15:27:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbjDHP1w (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 8 Apr 2023 11:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbjDHP1v (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 8 Apr 2023 11:27:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F24A10276
        for <linux-crypto@vger.kernel.org>; Sat,  8 Apr 2023 08:27:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0643C601D6
        for <linux-crypto@vger.kernel.org>; Sat,  8 Apr 2023 15:27:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F2DC433A0;
        Sat,  8 Apr 2023 15:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680967664;
        bh=OZPzZnTNvPFIKgdxJ0AJMaRP90B0/M2z093EjzGHs4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q4ezQE7K6GiR3OqcTX5sfpOfBwBoX6LLUUcwO/HJz5RzQplBazzQkqJr1CGfhD7tH
         rEZWGt7Idx5VtHb6cuuOH3XXq5pX6H4tPocXkpvimVsqoB7oyr4ONVWZWxP1d4P58o
         9Qh4oI5Gerj7uurslLrvK2bVmQpamNG/a3DDArSEWcpx9vWUP2CzDBEfsuwntI+sjd
         09d3z2cHE7HuvH5ICIO7qwPTZTRnySJKV+FnPYk4WXNIFTzdM1fZd93i8tbTB5A/EO
         BUbDHPdnENoZL5eaIMmiOwLBnu0+GOirskshfe/+YbCDy6klE60dmK5ffCCgiUgZt8
         YGRwpq2IUO/Jw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 04/10] crypto: x86/camellia - Use RIP-relative addressing
Date:   Sat,  8 Apr 2023 17:27:16 +0200
Message-Id: <20230408152722.3975985-5-ardb@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230408152722.3975985-1-ardb@kernel.org>
References: <20230408152722.3975985-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7223; i=ardb@kernel.org; h=from:subject; bh=OZPzZnTNvPFIKgdxJ0AJMaRP90B0/M2z093EjzGHs4M=; b=owGbwMvMwCFmkMcZplerG8N4Wi2JIcWw/dKCO1v1fh3wvdw0d0/86nbh0v6rp401mD5k7V/9y +vMyo7nHaUsDGIcDLJiiiwCs/++23l6olSt8yxZmDmsTCBDGLg4BWAivq8Z/udnPrZ8VbNS3EM4 +7D0rL29QvVHAuR9895enOXndtw8xJKR4dXUfPl1LuzrZH+oNlz6N2vbMSEt07fWu6pEa5SebXQ KYAAA
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Prefer RIP-relative addressing where possible, which removes the need
for boot time relocation fixups.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/camellia-aesni-avx-asm_64.S  | 30 ++++++++++----------
 arch/x86/crypto/camellia-aesni-avx2-asm_64.S | 30 ++++++++++----------
 arch/x86/crypto/camellia-x86_64-asm_64.S     |  8 ++++--
 3 files changed, 35 insertions(+), 33 deletions(-)

diff --git a/arch/x86/crypto/camellia-aesni-avx-asm_64.S b/arch/x86/crypto/camellia-aesni-avx-asm_64.S
index 4a30618281ec2e9e..646477a13e110fed 100644
--- a/arch/x86/crypto/camellia-aesni-avx-asm_64.S
+++ b/arch/x86/crypto/camellia-aesni-avx-asm_64.S
@@ -52,10 +52,10 @@
 	/* \
 	 * S-function with AES subbytes \
 	 */ \
-	vmovdqa .Linv_shift_row, t4; \
-	vbroadcastss .L0f0f0f0f, t7; \
-	vmovdqa .Lpre_tf_lo_s1, t0; \
-	vmovdqa .Lpre_tf_hi_s1, t1; \
+	vmovdqa .Linv_shift_row(%rip), t4; \
+	vbroadcastss .L0f0f0f0f(%rip), t7; \
+	vmovdqa .Lpre_tf_lo_s1(%rip), t0; \
+	vmovdqa .Lpre_tf_hi_s1(%rip), t1; \
 	\
 	/* AES inverse shift rows */ \
 	vpshufb t4, x0, x0; \
@@ -68,8 +68,8 @@
 	vpshufb t4, x6, x6; \
 	\
 	/* prefilter sboxes 1, 2 and 3 */ \
-	vmovdqa .Lpre_tf_lo_s4, t2; \
-	vmovdqa .Lpre_tf_hi_s4, t3; \
+	vmovdqa .Lpre_tf_lo_s4(%rip), t2; \
+	vmovdqa .Lpre_tf_hi_s4(%rip), t3; \
 	filter_8bit(x0, t0, t1, t7, t6); \
 	filter_8bit(x7, t0, t1, t7, t6); \
 	filter_8bit(x1, t0, t1, t7, t6); \
@@ -83,8 +83,8 @@
 	filter_8bit(x6, t2, t3, t7, t6); \
 	\
 	/* AES subbytes + AES shift rows */ \
-	vmovdqa .Lpost_tf_lo_s1, t0; \
-	vmovdqa .Lpost_tf_hi_s1, t1; \
+	vmovdqa .Lpost_tf_lo_s1(%rip), t0; \
+	vmovdqa .Lpost_tf_hi_s1(%rip), t1; \
 	vaesenclast t4, x0, x0; \
 	vaesenclast t4, x7, x7; \
 	vaesenclast t4, x1, x1; \
@@ -95,16 +95,16 @@
 	vaesenclast t4, x6, x6; \
 	\
 	/* postfilter sboxes 1 and 4 */ \
-	vmovdqa .Lpost_tf_lo_s3, t2; \
-	vmovdqa .Lpost_tf_hi_s3, t3; \
+	vmovdqa .Lpost_tf_lo_s3(%rip), t2; \
+	vmovdqa .Lpost_tf_hi_s3(%rip), t3; \
 	filter_8bit(x0, t0, t1, t7, t6); \
 	filter_8bit(x7, t0, t1, t7, t6); \
 	filter_8bit(x3, t0, t1, t7, t6); \
 	filter_8bit(x6, t0, t1, t7, t6); \
 	\
 	/* postfilter sbox 3 */ \
-	vmovdqa .Lpost_tf_lo_s2, t4; \
-	vmovdqa .Lpost_tf_hi_s2, t5; \
+	vmovdqa .Lpost_tf_lo_s2(%rip), t4; \
+	vmovdqa .Lpost_tf_hi_s2(%rip), t5; \
 	filter_8bit(x2, t2, t3, t7, t6); \
 	filter_8bit(x5, t2, t3, t7, t6); \
 	\
@@ -443,7 +443,7 @@ SYM_FUNC_END(roundsm16_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
 	transpose_4x4(c0, c1, c2, c3, a0, a1); \
 	transpose_4x4(d0, d1, d2, d3, a0, a1); \
 	\
-	vmovdqu .Lshufb_16x16b, a0; \
+	vmovdqu .Lshufb_16x16b(%rip), a0; \
 	vmovdqu st1, a1; \
 	vpshufb a0, a2, a2; \
 	vpshufb a0, a3, a3; \
@@ -482,7 +482,7 @@ SYM_FUNC_END(roundsm16_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
 #define inpack16_pre(x0, x1, x2, x3, x4, x5, x6, x7, y0, y1, y2, y3, y4, y5, \
 		     y6, y7, rio, key) \
 	vmovq key, x0; \
-	vpshufb .Lpack_bswap, x0, x0; \
+	vpshufb .Lpack_bswap(%rip), x0, x0; \
 	\
 	vpxor 0 * 16(rio), x0, y7; \
 	vpxor 1 * 16(rio), x0, y6; \
@@ -533,7 +533,7 @@ SYM_FUNC_END(roundsm16_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
 	vmovdqu x0, stack_tmp0; \
 	\
 	vmovq key, x0; \
-	vpshufb .Lpack_bswap, x0, x0; \
+	vpshufb .Lpack_bswap(%rip), x0, x0; \
 	\
 	vpxor x0, y7, y7; \
 	vpxor x0, y6, y6; \
diff --git a/arch/x86/crypto/camellia-aesni-avx2-asm_64.S b/arch/x86/crypto/camellia-aesni-avx2-asm_64.S
index deaf62aa73a6b09c..a0eb94e53b1bb12d 100644
--- a/arch/x86/crypto/camellia-aesni-avx2-asm_64.S
+++ b/arch/x86/crypto/camellia-aesni-avx2-asm_64.S
@@ -64,12 +64,12 @@
 	/* \
 	 * S-function with AES subbytes \
 	 */ \
-	vbroadcasti128 .Linv_shift_row, t4; \
-	vpbroadcastd .L0f0f0f0f, t7; \
-	vbroadcasti128 .Lpre_tf_lo_s1, t5; \
-	vbroadcasti128 .Lpre_tf_hi_s1, t6; \
-	vbroadcasti128 .Lpre_tf_lo_s4, t2; \
-	vbroadcasti128 .Lpre_tf_hi_s4, t3; \
+	vbroadcasti128 .Linv_shift_row(%rip), t4; \
+	vpbroadcastd .L0f0f0f0f(%rip), t7; \
+	vbroadcasti128 .Lpre_tf_lo_s1(%rip), t5; \
+	vbroadcasti128 .Lpre_tf_hi_s1(%rip), t6; \
+	vbroadcasti128 .Lpre_tf_lo_s4(%rip), t2; \
+	vbroadcasti128 .Lpre_tf_hi_s4(%rip), t3; \
 	\
 	/* AES inverse shift rows */ \
 	vpshufb t4, x0, x0; \
@@ -115,8 +115,8 @@
 	vinserti128 $1, t2##_x, x6, x6; \
 	vextracti128 $1, x1, t3##_x; \
 	vextracti128 $1, x4, t2##_x; \
-	vbroadcasti128 .Lpost_tf_lo_s1, t0; \
-	vbroadcasti128 .Lpost_tf_hi_s1, t1; \
+	vbroadcasti128 .Lpost_tf_lo_s1(%rip), t0; \
+	vbroadcasti128 .Lpost_tf_hi_s1(%rip), t1; \
 	vaesenclast t4##_x, x2##_x, x2##_x; \
 	vaesenclast t4##_x, t6##_x, t6##_x; \
 	vinserti128 $1, t6##_x, x2, x2; \
@@ -131,16 +131,16 @@
 	vinserti128 $1, t2##_x, x4, x4; \
 	\
 	/* postfilter sboxes 1 and 4 */ \
-	vbroadcasti128 .Lpost_tf_lo_s3, t2; \
-	vbroadcasti128 .Lpost_tf_hi_s3, t3; \
+	vbroadcasti128 .Lpost_tf_lo_s3(%rip), t2; \
+	vbroadcasti128 .Lpost_tf_hi_s3(%rip), t3; \
 	filter_8bit(x0, t0, t1, t7, t6); \
 	filter_8bit(x7, t0, t1, t7, t6); \
 	filter_8bit(x3, t0, t1, t7, t6); \
 	filter_8bit(x6, t0, t1, t7, t6); \
 	\
 	/* postfilter sbox 3 */ \
-	vbroadcasti128 .Lpost_tf_lo_s2, t4; \
-	vbroadcasti128 .Lpost_tf_hi_s2, t5; \
+	vbroadcasti128 .Lpost_tf_lo_s2(%rip), t4; \
+	vbroadcasti128 .Lpost_tf_hi_s2(%rip), t5; \
 	filter_8bit(x2, t2, t3, t7, t6); \
 	filter_8bit(x5, t2, t3, t7, t6); \
 	\
@@ -475,7 +475,7 @@ SYM_FUNC_END(roundsm32_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
 	transpose_4x4(c0, c1, c2, c3, a0, a1); \
 	transpose_4x4(d0, d1, d2, d3, a0, a1); \
 	\
-	vbroadcasti128 .Lshufb_16x16b, a0; \
+	vbroadcasti128 .Lshufb_16x16b(%rip), a0; \
 	vmovdqu st1, a1; \
 	vpshufb a0, a2, a2; \
 	vpshufb a0, a3, a3; \
@@ -514,7 +514,7 @@ SYM_FUNC_END(roundsm32_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
 #define inpack32_pre(x0, x1, x2, x3, x4, x5, x6, x7, y0, y1, y2, y3, y4, y5, \
 		     y6, y7, rio, key) \
 	vpbroadcastq key, x0; \
-	vpshufb .Lpack_bswap, x0, x0; \
+	vpshufb .Lpack_bswap(%rip), x0, x0; \
 	\
 	vpxor 0 * 32(rio), x0, y7; \
 	vpxor 1 * 32(rio), x0, y6; \
@@ -565,7 +565,7 @@ SYM_FUNC_END(roundsm32_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
 	vmovdqu x0, stack_tmp0; \
 	\
 	vpbroadcastq key, x0; \
-	vpshufb .Lpack_bswap, x0, x0; \
+	vpshufb .Lpack_bswap(%rip), x0, x0; \
 	\
 	vpxor x0, y7, y7; \
 	vpxor x0, y6, y6; \
diff --git a/arch/x86/crypto/camellia-x86_64-asm_64.S b/arch/x86/crypto/camellia-x86_64-asm_64.S
index 347c059f59403d3c..b7c822d813a82772 100644
--- a/arch/x86/crypto/camellia-x86_64-asm_64.S
+++ b/arch/x86/crypto/camellia-x86_64-asm_64.S
@@ -77,11 +77,13 @@
 #define RXORbl %r9b
 
 #define xor2ror16(T0, T1, tmp1, tmp2, ab, dst) \
+	leaq T0(%rip), 			tmp1; \
 	movzbl ab ## bl,		tmp2 ## d; \
+	xorq (tmp1, tmp2, 8),		dst; \
+	leaq T1(%rip), 			tmp2; \
 	movzbl ab ## bh,		tmp1 ## d; \
-	rorq $16,			ab; \
-	xorq T0(, tmp2, 8),		dst; \
-	xorq T1(, tmp1, 8),		dst;
+	xorq (tmp2, tmp1, 8),		dst; \
+	rorq $16,			ab;
 
 /**********************************************************************
   1-way camellia
-- 
2.39.2

