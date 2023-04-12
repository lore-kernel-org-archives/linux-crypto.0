Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 586DAC77B6E
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Apr 2023 11:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjDLLA6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Apr 2023 07:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjDLLAz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Apr 2023 07:00:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 128CB6EAD
        for <linux-crypto@vger.kernel.org>; Wed, 12 Apr 2023 04:00:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 839F762889
        for <linux-crypto@vger.kernel.org>; Wed, 12 Apr 2023 11:00:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A09C4339E;
        Wed, 12 Apr 2023 11:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681297251;
        bh=mPiYY79mrBdPcJSB+Lsy+wY627fy3181XFaLtnuKu5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hAeYX4yUEGV7RoHrUzJYtIrZX+gSYmK/pzgcyRhLIB9v4rqDdaP8RKg9k1GdQgUTW
         piOWHVTg5gnokZE4aBgfYBjABrx8+1T88npplEupBvToYoUYPCbCMKAisxxfxiH6Tq
         UVGeebr0Ld/PYuZkq1XWx23ZHsFB9ShVB3ay5N9HPxwKbIyqmY5zY5AxnrvU8Dmdbh
         gWMUlMwPopoP295mjndq9RK8YYk/xBYgBGN5I8qDGfpuIz8GSW+qZHPkh7L/qo/yEM
         MIipNTjUDocdfBPG5L3VCZm0TKhdMnnvUb/wKy2kNYZRYCqD4SIlVk8jYnO2GQ8AaI
         U5w1N9hJVmMoA==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 03/13] crypto: x86/aria - Use RIP-relative addressing
Date:   Wed, 12 Apr 2023 13:00:25 +0200
Message-Id: <20230412110035.361447-4-ardb@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230412110035.361447-1-ardb@kernel.org>
References: <20230412110035.361447-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7533; i=ardb@kernel.org; h=from:subject; bh=mPiYY79mrBdPcJSB+Lsy+wY627fy3181XFaLtnuKu5s=; b=owGbwMvMwCFmkMcZplerG8N4Wi2JIcWs31VUdMnKu8c/HrL9kHczKWKjwxwBqzUmUs/nRzprG 2ot1K/tKGVhEONgkBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABOJyGdkOHx9+2rZo4a2XyZX e8ts3ZSq9sGELzlx1+KOjc4pyl+arzAytBl9KA7YKqtcI7V51XNjXb0AhasvXN6/YlUsaewsk/n NBwA=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Prefer RIP-relative addressing where possible, which removes the need
for boot time relocation fixups.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/aria-aesni-avx-asm_64.S   | 28 ++++++++++----------
 arch/x86/crypto/aria-aesni-avx2-asm_64.S  | 28 ++++++++++----------
 arch/x86/crypto/aria-gfni-avx512-asm_64.S | 24 ++++++++---------
 3 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/arch/x86/crypto/aria-aesni-avx-asm_64.S b/arch/x86/crypto/aria-aesni-avx-asm_64.S
index 9243f6289d34bfbf..7c1abc513f34621e 100644
--- a/arch/x86/crypto/aria-aesni-avx-asm_64.S
+++ b/arch/x86/crypto/aria-aesni-avx-asm_64.S
@@ -80,7 +80,7 @@
 	transpose_4x4(c0, c1, c2, c3, a0, a1);		\
 	transpose_4x4(d0, d1, d2, d3, a0, a1);		\
 							\
-	vmovdqu .Lshufb_16x16b, a0;			\
+	vmovdqu .Lshufb_16x16b(%rip), a0;		\
 	vmovdqu st1, a1;				\
 	vpshufb a0, a2, a2;				\
 	vpshufb a0, a3, a3;				\
@@ -132,7 +132,7 @@
 	transpose_4x4(c0, c1, c2, c3, a0, a1);		\
 	transpose_4x4(d0, d1, d2, d3, a0, a1);		\
 							\
-	vmovdqu .Lshufb_16x16b, a0;			\
+	vmovdqu .Lshufb_16x16b(%rip), a0;		\
 	vmovdqu st1, a1;				\
 	vpshufb a0, a2, a2;				\
 	vpshufb a0, a3, a3;				\
@@ -300,11 +300,11 @@
 			    x4, x5, x6, x7,		\
 			    t0, t1, t2, t3,		\
 			    t4, t5, t6, t7)		\
-	vmovdqa .Ltf_s2_bitmatrix, t0;			\
-	vmovdqa .Ltf_inv_bitmatrix, t1;			\
-	vmovdqa .Ltf_id_bitmatrix, t2;			\
-	vmovdqa .Ltf_aff_bitmatrix, t3;			\
-	vmovdqa .Ltf_x2_bitmatrix, t4;			\
+	vmovdqa .Ltf_s2_bitmatrix(%rip), t0;		\
+	vmovdqa .Ltf_inv_bitmatrix(%rip), t1;		\
+	vmovdqa .Ltf_id_bitmatrix(%rip), t2;		\
+	vmovdqa .Ltf_aff_bitmatrix(%rip), t3;		\
+	vmovdqa .Ltf_x2_bitmatrix(%rip), t4;		\
 	vgf2p8affineinvqb $(tf_s2_const), t0, x1, x1;	\
 	vgf2p8affineinvqb $(tf_s2_const), t0, x5, x5;	\
 	vgf2p8affineqb $(tf_inv_const), t1, x2, x2;	\
@@ -324,13 +324,13 @@
 		       x4, x5, x6, x7,			\
 		       t0, t1, t2, t3,			\
 		       t4, t5, t6, t7)			\
-	vmovdqa .Linv_shift_row, t0;			\
-	vmovdqa .Lshift_row, t1;			\
-	vbroadcastss .L0f0f0f0f, t6;			\
-	vmovdqa .Ltf_lo__inv_aff__and__s2, t2;		\
-	vmovdqa .Ltf_hi__inv_aff__and__s2, t3;		\
-	vmovdqa .Ltf_lo__x2__and__fwd_aff, t4;		\
-	vmovdqa .Ltf_hi__x2__and__fwd_aff, t5;		\
+	vmovdqa .Linv_shift_row(%rip), t0;		\
+	vmovdqa .Lshift_row(%rip), t1;			\
+	vbroadcastss .L0f0f0f0f(%rip), t6;		\
+	vmovdqa .Ltf_lo__inv_aff__and__s2(%rip), t2;	\
+	vmovdqa .Ltf_hi__inv_aff__and__s2(%rip), t3;	\
+	vmovdqa .Ltf_lo__x2__and__fwd_aff(%rip), t4;	\
+	vmovdqa .Ltf_hi__x2__and__fwd_aff(%rip), t5;	\
 							\
 	vaesenclast t7, x0, x0;				\
 	vaesenclast t7, x4, x4;				\
diff --git a/arch/x86/crypto/aria-aesni-avx2-asm_64.S b/arch/x86/crypto/aria-aesni-avx2-asm_64.S
index 82a14b4ad920f792..c60fa2980630379b 100644
--- a/arch/x86/crypto/aria-aesni-avx2-asm_64.S
+++ b/arch/x86/crypto/aria-aesni-avx2-asm_64.S
@@ -96,7 +96,7 @@
 	transpose_4x4(c0, c1, c2, c3, a0, a1);		\
 	transpose_4x4(d0, d1, d2, d3, a0, a1);		\
 							\
-	vbroadcasti128 .Lshufb_16x16b, a0;		\
+	vbroadcasti128 .Lshufb_16x16b(%rip), a0;	\
 	vmovdqu st1, a1;				\
 	vpshufb a0, a2, a2;				\
 	vpshufb a0, a3, a3;				\
@@ -148,7 +148,7 @@
 	transpose_4x4(c0, c1, c2, c3, a0, a1);		\
 	transpose_4x4(d0, d1, d2, d3, a0, a1);		\
 							\
-	vbroadcasti128 .Lshufb_16x16b, a0;		\
+	vbroadcasti128 .Lshufb_16x16b(%rip), a0;	\
 	vmovdqu st1, a1;				\
 	vpshufb a0, a2, a2;				\
 	vpshufb a0, a3, a3;				\
@@ -307,11 +307,11 @@
 			    x4, x5, x6, x7,		\
 			    t0, t1, t2, t3,		\
 			    t4, t5, t6, t7)		\
-	vpbroadcastq .Ltf_s2_bitmatrix, t0;		\
-	vpbroadcastq .Ltf_inv_bitmatrix, t1;		\
-	vpbroadcastq .Ltf_id_bitmatrix, t2;		\
-	vpbroadcastq .Ltf_aff_bitmatrix, t3;		\
-	vpbroadcastq .Ltf_x2_bitmatrix, t4;		\
+	vpbroadcastq .Ltf_s2_bitmatrix(%rip), t0;	\
+	vpbroadcastq .Ltf_inv_bitmatrix(%rip), t1;	\
+	vpbroadcastq .Ltf_id_bitmatrix(%rip), t2;	\
+	vpbroadcastq .Ltf_aff_bitmatrix(%rip), t3;	\
+	vpbroadcastq .Ltf_x2_bitmatrix(%rip), t4;	\
 	vgf2p8affineinvqb $(tf_s2_const), t0, x1, x1;	\
 	vgf2p8affineinvqb $(tf_s2_const), t0, x5, x5;	\
 	vgf2p8affineqb $(tf_inv_const), t1, x2, x2;	\
@@ -332,12 +332,12 @@
 		       t4, t5, t6, t7)			\
 	vpxor t7, t7, t7;				\
 	vpxor t6, t6, t6;				\
-	vbroadcasti128 .Linv_shift_row, t0;		\
-	vbroadcasti128 .Lshift_row, t1;			\
-	vbroadcasti128 .Ltf_lo__inv_aff__and__s2, t2;	\
-	vbroadcasti128 .Ltf_hi__inv_aff__and__s2, t3;	\
-	vbroadcasti128 .Ltf_lo__x2__and__fwd_aff, t4;	\
-	vbroadcasti128 .Ltf_hi__x2__and__fwd_aff, t5;	\
+	vbroadcasti128 .Linv_shift_row(%rip), t0;	\
+	vbroadcasti128 .Lshift_row(%rip), t1;		\
+	vbroadcasti128 .Ltf_lo__inv_aff__and__s2(%rip), t2; \
+	vbroadcasti128 .Ltf_hi__inv_aff__and__s2(%rip), t3; \
+	vbroadcasti128 .Ltf_lo__x2__and__fwd_aff(%rip), t4; \
+	vbroadcasti128 .Ltf_hi__x2__and__fwd_aff(%rip), t5; \
 							\
 	vextracti128 $1, x0, t6##_x;			\
 	vaesenclast t7##_x, x0##_x, x0##_x;		\
@@ -369,7 +369,7 @@
 	vaesdeclast t7##_x, t6##_x, t6##_x;		\
 	vinserti128 $1, t6##_x, x6, x6;			\
 							\
-	vpbroadcastd .L0f0f0f0f, t6;			\
+	vpbroadcastd .L0f0f0f0f(%rip), t6;		\
 							\
 	/* AES inverse shift rows */			\
 	vpshufb t0, x0, x0;				\
diff --git a/arch/x86/crypto/aria-gfni-avx512-asm_64.S b/arch/x86/crypto/aria-gfni-avx512-asm_64.S
index 3193f07014506655..860887e5d02ed6ef 100644
--- a/arch/x86/crypto/aria-gfni-avx512-asm_64.S
+++ b/arch/x86/crypto/aria-gfni-avx512-asm_64.S
@@ -80,7 +80,7 @@
 	transpose_4x4(c0, c1, c2, c3, a0, a1);		\
 	transpose_4x4(d0, d1, d2, d3, a0, a1);		\
 							\
-	vbroadcasti64x2 .Lshufb_16x16b, a0;		\
+	vbroadcasti64x2 .Lshufb_16x16b(%rip), a0;	\
 	vmovdqu64 st1, a1;				\
 	vpshufb a0, a2, a2;				\
 	vpshufb a0, a3, a3;				\
@@ -132,7 +132,7 @@
 	transpose_4x4(c0, c1, c2, c3, a0, a1);		\
 	transpose_4x4(d0, d1, d2, d3, a0, a1);		\
 							\
-	vbroadcasti64x2 .Lshufb_16x16b, a0;		\
+	vbroadcasti64x2 .Lshufb_16x16b(%rip), a0;	\
 	vmovdqu64 st1, a1;				\
 	vpshufb a0, a2, a2;				\
 	vpshufb a0, a3, a3;				\
@@ -308,11 +308,11 @@
 			    x4, x5, x6, x7,		\
 			    t0, t1, t2, t3,		\
 			    t4, t5, t6, t7)		\
-	vpbroadcastq .Ltf_s2_bitmatrix, t0;		\
-	vpbroadcastq .Ltf_inv_bitmatrix, t1;		\
-	vpbroadcastq .Ltf_id_bitmatrix, t2;		\
-	vpbroadcastq .Ltf_aff_bitmatrix, t3;		\
-	vpbroadcastq .Ltf_x2_bitmatrix, t4;		\
+	vpbroadcastq .Ltf_s2_bitmatrix(%rip), t0;	\
+	vpbroadcastq .Ltf_inv_bitmatrix(%rip), t1;	\
+	vpbroadcastq .Ltf_id_bitmatrix(%rip), t2;	\
+	vpbroadcastq .Ltf_aff_bitmatrix(%rip), t3;	\
+	vpbroadcastq .Ltf_x2_bitmatrix(%rip), t4;	\
 	vgf2p8affineinvqb $(tf_s2_const), t0, x1, x1;	\
 	vgf2p8affineinvqb $(tf_s2_const), t0, x5, x5;	\
 	vgf2p8affineqb $(tf_inv_const), t1, x2, x2;	\
@@ -332,11 +332,11 @@
 			     y4, y5, y6, y7,		\
 			     t0, t1, t2, t3,		\
 			     t4, t5, t6, t7)		\
-	vpbroadcastq .Ltf_s2_bitmatrix, t0;		\
-	vpbroadcastq .Ltf_inv_bitmatrix, t1;		\
-	vpbroadcastq .Ltf_id_bitmatrix, t2;		\
-	vpbroadcastq .Ltf_aff_bitmatrix, t3;		\
-	vpbroadcastq .Ltf_x2_bitmatrix, t4;		\
+	vpbroadcastq .Ltf_s2_bitmatrix(%rip), t0;	\
+	vpbroadcastq .Ltf_inv_bitmatrix(%rip), t1;	\
+	vpbroadcastq .Ltf_id_bitmatrix(%rip), t2;	\
+	vpbroadcastq .Ltf_aff_bitmatrix(%rip), t3;	\
+	vpbroadcastq .Ltf_x2_bitmatrix(%rip), t4;	\
 	vgf2p8affineinvqb $(tf_s2_const), t0, x1, x1;	\
 	vgf2p8affineinvqb $(tf_s2_const), t0, x5, x5;	\
 	vgf2p8affineqb $(tf_inv_const), t1, x2, x2;	\
-- 
2.39.2

