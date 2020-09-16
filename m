Return-Path: <SRS0=gkSk=CZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF8ACC43461
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Sep 2020 19:05:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82931206B2
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Sep 2020 19:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600283145;
	bh=BnJn+ur9GqzFa4zwQue+QDarPbQWiUfb7hyWM/oKasw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=hMOGmnEDh/h1fTi/CKUrsjWtVGn03CGVeiDhMr9eI32OdM91ctxJ68LtCC1sEJBWK
	 nrFQIqPKrVV7CvoFmFobNBx5L6WYgpK9PaghJlG4YjVzXQWMxOteLu4bFyrCyE5hEJ
	 R8JXz87k0wXa6JbjDtKGx3tNKrZ2m0/V/vqddTXQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbgIPTFn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Sep 2020 15:05:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727430AbgIPRqT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Sep 2020 13:46:19 -0400
Received: from e123331-lin.nice.arm.com (adsl-245.46.190.88.tellas.gr [46.190.88.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 714C522226;
        Wed, 16 Sep 2020 12:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600259813;
        bh=BnJn+ur9GqzFa4zwQue+QDarPbQWiUfb7hyWM/oKasw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=USoUUYpvWuXTSLWLa71CN1jQmIZO4WPaOyoQddCVZngZUn05Y2xpr2rHzvsEFHVy/
         E2cwiBCOuKu1ckbUF08hLYZcbI3KX+AqSuDbJEsvG1d/dDMzxlFdwoPnEJamlNk1QM
         Phpbcs0Pt2cYHN5WfkjKJYqTCW57jmlFNo5uzbfM=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 1/3] crypto: arm/aes-neonbs - avoid hacks to prevent Thumb2 mode switches
Date:   Wed, 16 Sep 2020 15:36:40 +0300
Message-Id: <20200916123642.20805-2-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200916123642.20805-1-ardb@kernel.org>
References: <20200916123642.20805-1-ardb@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of using a homegrown macrofied version of the adr instruction
that sets the Thumb bit in the output value, only to ensure that any
bx instructions consuming that value will not switch out of Thumb mode
when branching, use non-interworking mov (to PC) instructions, which
achieve the same thing.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/crypto/aes-neonbs-core.S | 49 +++++++++-----------
 1 file changed, 22 insertions(+), 27 deletions(-)

diff --git a/arch/arm/crypto/aes-neonbs-core.S b/arch/arm/crypto/aes-neonbs-core.S
index cfaed4e67535..07cde1374bb0 100644
--- a/arch/arm/crypto/aes-neonbs-core.S
+++ b/arch/arm/crypto/aes-neonbs-core.S
@@ -77,11 +77,6 @@
 	vldr		\out\()h, \sym + 8
 	.endm
 
-	.macro		__adr, reg, lbl
-	adr		\reg, \lbl
-THUMB(	orr		\reg, \reg, #1		)
-	.endm
-
 	.macro		in_bs_ch, b0, b1, b2, b3, b4, b5, b6, b7
 	veor		\b2, \b2, \b1
 	veor		\b5, \b5, \b6
@@ -629,11 +624,11 @@ ENDPROC(aesbs_decrypt8)
 	push		{r4-r6, lr}
 	ldr		r5, [sp, #16]		// number of blocks
 
-99:	__adr		ip, 0f
+99:	adr		ip, 0f
 	and		lr, r5, #7
 	cmp		r5, #8
 	sub		ip, ip, lr, lsl #2
-	bxlt		ip			// computed goto if blocks < 8
+	movlt		pc, ip			// computed goto if blocks < 8
 
 	vld1.8		{q0}, [r1]!
 	vld1.8		{q1}, [r1]!
@@ -648,11 +643,11 @@ ENDPROC(aesbs_decrypt8)
 	mov		rounds, r3
 	bl		\do8
 
-	__adr		ip, 1f
+	adr		ip, 1f
 	and		lr, r5, #7
 	cmp		r5, #8
 	sub		ip, ip, lr, lsl #2
-	bxlt		ip			// computed goto if blocks < 8
+	movlt		pc, ip			// computed goto if blocks < 8
 
 	vst1.8		{\o0}, [r0]!
 	vst1.8		{\o1}, [r0]!
@@ -689,12 +684,12 @@ ENTRY(aesbs_cbc_decrypt)
 	push		{r4-r6, lr}
 	ldm		ip, {r5-r6}		// load args 4-5
 
-99:	__adr		ip, 0f
+99:	adr		ip, 0f
 	and		lr, r5, #7
 	cmp		r5, #8
 	sub		ip, ip, lr, lsl #2
 	mov		lr, r1
-	bxlt		ip			// computed goto if blocks < 8
+	movlt		pc, ip			// computed goto if blocks < 8
 
 	vld1.8		{q0}, [lr]!
 	vld1.8		{q1}, [lr]!
@@ -718,11 +713,11 @@ ENTRY(aesbs_cbc_decrypt)
 	vmov		q14, q8
 	vmov		q15, q8
 
-	__adr		ip, 1f
+	adr		ip, 1f
 	and		lr, r5, #7
 	cmp		r5, #8
 	sub		ip, ip, lr, lsl #2
-	bxlt		ip			// computed goto if blocks < 8
+	movlt		pc, ip			// computed goto if blocks < 8
 
 	vld1.8		{q9}, [r1]!
 	vld1.8		{q10}, [r1]!
@@ -733,9 +728,9 @@ ENTRY(aesbs_cbc_decrypt)
 	vld1.8		{q15}, [r1]!
 	W(nop)
 
-1:	__adr		ip, 2f
+1:	adr		ip, 2f
 	sub		ip, ip, lr, lsl #3
-	bxlt		ip			// computed goto if blocks < 8
+	movlt		pc, ip			// computed goto if blocks < 8
 
 	veor		q0, q0, q8
 	vst1.8		{q0}, [r0]!
@@ -804,13 +799,13 @@ ENTRY(aesbs_ctr_encrypt)
 	vmov		q6, q0
 	vmov		q7, q0
 
-	__adr		ip, 0f
+	adr		ip, 0f
 	sub		lr, r5, #1
 	and		lr, lr, #7
 	cmp		r5, #8
 	sub		ip, ip, lr, lsl #5
 	sub		ip, ip, lr, lsl #2
-	bxlt		ip			// computed goto if blocks < 8
+	movlt		pc, ip			// computed goto if blocks < 8
 
 	next_ctr	q1
 	next_ctr	q2
@@ -824,13 +819,13 @@ ENTRY(aesbs_ctr_encrypt)
 	mov		rounds, r3
 	bl		aesbs_encrypt8
 
-	__adr		ip, 1f
+	adr		ip, 1f
 	and		lr, r5, #7
 	cmp		r5, #8
 	movgt		r4, #0
 	ldrle		r4, [sp, #40]		// load final in the last round
 	sub		ip, ip, lr, lsl #2
-	bxlt		ip			// computed goto if blocks < 8
+	movlt		pc, ip			// computed goto if blocks < 8
 
 	vld1.8		{q8}, [r1]!
 	vld1.8		{q9}, [r1]!
@@ -843,10 +838,10 @@ ENTRY(aesbs_ctr_encrypt)
 1:	bne		2f
 	vld1.8		{q15}, [r1]!
 
-2:	__adr		ip, 3f
+2:	adr		ip, 3f
 	cmp		r5, #8
 	sub		ip, ip, lr, lsl #3
-	bxlt		ip			// computed goto if blocks < 8
+	movlt		pc, ip			// computed goto if blocks < 8
 
 	veor		q0, q0, q8
 	vst1.8		{q0}, [r0]!
@@ -900,12 +895,12 @@ __xts_prepare8:
 	vshr.u64	d30, d31, #7
 	vmov		q12, q14
 
-	__adr		ip, 0f
+	adr		ip, 0f
 	and		r4, r6, #7
 	cmp		r6, #8
 	sub		ip, ip, r4, lsl #5
 	mov		r4, sp
-	bxlt		ip			// computed goto if blocks < 8
+	movlt		pc, ip			// computed goto if blocks < 8
 
 	vld1.8		{q0}, [r1]!
 	next_tweak	q12, q14, q15, q13
@@ -973,12 +968,12 @@ ENDPROC(__xts_prepare8)
 	mov		rounds, r3
 	bl		\do8
 
-	__adr		ip, 0f
+	adr		ip, 0f
 	and		lr, r6, #7
 	cmp		r6, #8
 	sub		ip, ip, lr, lsl #2
 	mov		r4, sp
-	bxlt		ip			// computed goto if blocks < 8
+	movlt		pc, ip			// computed goto if blocks < 8
 
 	vld1.8		{q8}, [r4, :128]!
 	vld1.8		{q9}, [r4, :128]!
@@ -989,9 +984,9 @@ ENDPROC(__xts_prepare8)
 	vld1.8		{q14}, [r4, :128]!
 	vld1.8		{q15}, [r4, :128]
 
-0:	__adr		ip, 1f
+0:	adr		ip, 1f
 	sub		ip, ip, lr, lsl #3
-	bxlt		ip			// computed goto if blocks < 8
+	movlt		pc, ip			// computed goto if blocks < 8
 
 	veor		\o0, \o0, q8
 	vst1.8		{\o0}, [r0]!
-- 
2.17.1

