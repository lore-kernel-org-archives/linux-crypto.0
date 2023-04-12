Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE262C77B71
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Apr 2023 11:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjDLLA7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Apr 2023 07:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjDLLA5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Apr 2023 07:00:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4C26583
        for <linux-crypto@vger.kernel.org>; Wed, 12 Apr 2023 04:00:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F2E1632EC
        for <linux-crypto@vger.kernel.org>; Wed, 12 Apr 2023 11:00:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2378C433EF;
        Wed, 12 Apr 2023 11:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681297255;
        bh=ZwHHUi68L0/HwbVdVnggFFtQQ/3/Z1k/X5PTHCX4P2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ubqwvkFnkGECPmccX0ZS7iufy9eP17n2J0P5Lef1q8aOEP7v7kZP1y1/mQDU8BX4T
         ll1jf9npj1XR633bvvoRG+rwGhy+nJmy6UY30aXOG8gHz6st2JFB1zK5Z0cHrwrway
         GQXunJF8TlW/EaZysBMnyTC/sa9he5F1gg0mIaKqNsh8rGy8c2ZppoMjqpzMQtgDK7
         6AHDGVEjeFmDa61VoanEZJan1V9LN2aFHyzHoXlHO4cWZxFAy6I0G5TjbOsVQHSn0Q
         DQIMTENbB9a8my9Ou8JqDetyCYrRzNqmdokY/nif9PP14A+T+xLAeMyDb41viIX9XY
         saMmUYNGRxlWw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 05/13] crypto: x86/cast5 - Use RIP-relative addressing
Date:   Wed, 12 Apr 2023 13:00:27 +0200
Message-Id: <20230412110035.361447-6-ardb@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230412110035.361447-1-ardb@kernel.org>
References: <20230412110035.361447-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3646; i=ardb@kernel.org; h=from:subject; bh=ZwHHUi68L0/HwbVdVnggFFtQQ/3/Z1k/X5PTHCX4P2E=; b=owGbwMvMwCFmkMcZplerG8N4Wi2JIcWs3yPH8rCt/+sJQX+cDN/rvJeMP2LBUSv1saHpVnSid evh+D8dpSwMYhwMsmKKLAKz/77beXqiVK3zLFmYOaxMIEMYuDgFYCIRvIwMX8LCanh6OC8k2wpP Sbddxcf59o+A/edbZw4snPzujNrFQEaGLXXrPMWzjE6+M3zU9SNYbGPPt8C1Ysws0q++VeZvVm/ iAAA=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Prefer RIP-relative addressing where possible, which removes the need
for boot time relocation fixups.

Co-developed-by: Thomas Garnier <thgarnie@chromium.org>
Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/cast5-avx-x86_64-asm_64.S | 38 +++++++++++---------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/arch/x86/crypto/cast5-avx-x86_64-asm_64.S b/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
index 0326a01503c3a554..b4e460a87f18ddaa 100644
--- a/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
@@ -84,15 +84,19 @@
 
 #define lookup_32bit(src, dst, op1, op2, op3, interleave_op, il_reg) \
 	movzbl		src ## bh,     RID1d;    \
+	leaq		s1(%rip),      RID2;     \
+	movl		(RID2,RID1,4), dst ## d; \
 	movzbl		src ## bl,     RID2d;    \
+	leaq		s2(%rip),      RID1;     \
+	op1		(RID1,RID2,4), dst ## d; \
 	shrq $16,	src;                     \
-	movl		s1(, RID1, 4), dst ## d; \
-	op1		s2(, RID2, 4), dst ## d; \
 	movzbl		src ## bh,     RID1d;    \
+	leaq		s3(%rip),      RID2;     \
+	op2		(RID2,RID1,4), dst ## d; \
 	movzbl		src ## bl,     RID2d;    \
 	interleave_op(il_reg);			 \
-	op2		s3(, RID1, 4), dst ## d; \
-	op3		s4(, RID2, 4), dst ## d;
+	leaq		s4(%rip),      RID1;     \
+	op3		(RID1,RID2,4), dst ## d;
 
 #define dummy(d) /* do nothing */
 
@@ -151,15 +155,15 @@
 	subround(l ## 3, r ## 3, l ## 4, r ## 4, f);
 
 #define enc_preload_rkr() \
-	vbroadcastss	.L16_mask,                RKR;      \
+	vbroadcastss	.L16_mask(%rip),          RKR;      \
 	/* add 16-bit rotation to key rotations (mod 32) */ \
 	vpxor		kr(CTX),                  RKR, RKR;
 
 #define dec_preload_rkr() \
-	vbroadcastss	.L16_mask,                RKR;      \
+	vbroadcastss	.L16_mask(%rip),          RKR;      \
 	/* add 16-bit rotation to key rotations (mod 32) */ \
 	vpxor		kr(CTX),                  RKR, RKR; \
-	vpshufb		.Lbswap128_mask,          RKR, RKR;
+	vpshufb		.Lbswap128_mask(%rip),    RKR, RKR;
 
 #define transpose_2x4(x0, x1, t0, t1) \
 	vpunpckldq		x1, x0, t0; \
@@ -235,9 +239,9 @@ SYM_FUNC_START_LOCAL(__cast5_enc_blk16)
 
 	movq %rdi, CTX;
 
-	vmovdqa .Lbswap_mask, RKM;
-	vmovd .Lfirst_mask, R1ST;
-	vmovd .L32_mask, R32;
+	vmovdqa .Lbswap_mask(%rip), RKM;
+	vmovd .Lfirst_mask(%rip), R1ST;
+	vmovd .L32_mask(%rip), R32;
 	enc_preload_rkr();
 
 	inpack_blocks(RL1, RR1, RTMP, RX, RKM);
@@ -271,7 +275,7 @@ SYM_FUNC_START_LOCAL(__cast5_enc_blk16)
 	popq %rbx;
 	popq %r15;
 
-	vmovdqa .Lbswap_mask, RKM;
+	vmovdqa .Lbswap_mask(%rip), RKM;
 
 	outunpack_blocks(RR1, RL1, RTMP, RX, RKM);
 	outunpack_blocks(RR2, RL2, RTMP, RX, RKM);
@@ -308,9 +312,9 @@ SYM_FUNC_START_LOCAL(__cast5_dec_blk16)
 
 	movq %rdi, CTX;
 
-	vmovdqa .Lbswap_mask, RKM;
-	vmovd .Lfirst_mask, R1ST;
-	vmovd .L32_mask, R32;
+	vmovdqa .Lbswap_mask(%rip), RKM;
+	vmovd .Lfirst_mask(%rip), R1ST;
+	vmovd .L32_mask(%rip), R32;
 	dec_preload_rkr();
 
 	inpack_blocks(RL1, RR1, RTMP, RX, RKM);
@@ -341,7 +345,7 @@ SYM_FUNC_START_LOCAL(__cast5_dec_blk16)
 	round(RL, RR, 1, 2);
 	round(RR, RL, 0, 1);
 
-	vmovdqa .Lbswap_mask, RKM;
+	vmovdqa .Lbswap_mask(%rip), RKM;
 	popq %rbx;
 	popq %r15;
 
@@ -504,8 +508,8 @@ SYM_FUNC_START(cast5_ctr_16way)
 
 	vpcmpeqd RKR, RKR, RKR;
 	vpaddq RKR, RKR, RKR; /* low: -2, high: -2 */
-	vmovdqa .Lbswap_iv_mask, R1ST;
-	vmovdqa .Lbswap128_mask, RKM;
+	vmovdqa .Lbswap_iv_mask(%rip), R1ST;
+	vmovdqa .Lbswap128_mask(%rip), RKM;
 
 	/* load IV and byteswap */
 	vmovq (%rcx), RX;
-- 
2.39.2

