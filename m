Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75E17C4361B
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 17:04:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4387C23B2F
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 17:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732138AbgLRRD4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Dec 2020 12:03:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:54300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725797AbgLRRDz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Dec 2020 12:03:55 -0500
From:   Ard Biesheuvel <ardb@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Dave Martin <dave.martin@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: [RFC PATCH 3/5] crypto: arm64/gcm-aes-ce - add NEON yield support
Date:   Fri, 18 Dec 2020 18:01:04 +0100
Message-Id: <20201218170106.23280-4-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201218170106.23280-1-ardb@kernel.org>
References: <20201218170106.23280-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

GCM mode is typically used for IPsec, but is now also used for software
kTLS, which means that we may end up operating on much larger inputs.

So let's wire up conditional NEON yield support for this driver, to ensure
that it does not cause scheduling blackouts when used with large inputs.

Given that GCM executes at 1-2 cycles per bytes and operates on 64 byte
chunks, doing a yield check every iteration should limit the scheduling
(or softirq) latency to < 200 cycles, which is a very conservative upper
bound.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/ghash-ce-core.S | 115 ++++++++++++--------
 1 file changed, 67 insertions(+), 48 deletions(-)

diff --git a/arch/arm64/crypto/ghash-ce-core.S b/arch/arm64/crypto/ghash-ce-core.S
index 7868330dd54e..533cfb810232 100644
--- a/arch/arm64/crypto/ghash-ce-core.S
+++ b/arch/arm64/crypto/ghash-ce-core.S
@@ -435,14 +435,23 @@ SYM_FUNC_END(pmull_ghash_update_p8)
 
 	.align		6
 	.macro		pmull_gcm_do_crypt, enc
-	stp		x29, x30, [sp, #-32]!
-	mov		x29, sp
-	str		x19, [sp, #24]
+	frame_push	8
 
-	load_round_keys	x7, x6, x8
+	mov		x19, x0
+	mov		x20, x1
+	mov		x21, x2
+	mov		x22, x3
+	mov		x23, x4
+	mov		x24, x5
+	mov		x25, x6
+	mov		x26, x7
 
-	ld1		{SHASH.2d}, [x3], #16
-	ld1		{HH.2d-HH4.2d}, [x3]
+.Lrestart\enc:
+	load_round_keys	x26, x25, x8
+
+	add		x0, x22, #16
+	ld1		{SHASH.2d}, [x22]
+	ld1		{HH.2d-HH4.2d}, [x0]
 
 	trn1		SHASH2.2d, SHASH.2d, HH.2d
 	trn2		T1.2d, SHASH.2d, HH.2d
@@ -452,23 +461,23 @@ SYM_FUNC_END(pmull_ghash_update_p8)
 	trn2		T1.2d, HH3.2d, HH4.2d
 	eor		HH34.16b, HH34.16b, T1.16b
 
-	ld1		{XL.2d}, [x4]
+	ld1		{XL.2d}, [x23]
 
-	cbz		x0, 3f				// tag only?
+	cbz		x19, 3f				// tag only?
 
-	ldr		w8, [x5, #12]			// load lower counter
+	ldr		w8, [x24, #12]			// load lower counter
 CPU_LE(	rev		w8, w8		)
 
 0:	mov		w9, #4				// max blocks per round
-	add		x10, x0, #0xf
+	add		x10, x19, #0xf
 	lsr		x10, x10, #4			// remaining blocks
 
-	subs		x0, x0, #64
+	subs		x19, x19, #64
 	csel		w9, w10, w9, mi
 	add		w8, w8, w9
 
 	bmi		1f
-	ld1		{INP0.16b-INP3.16b}, [x2], #64
+	ld1		{INP0.16b-INP3.16b}, [x21], #64
 	.subsection	1
 	/*
 	 * Populate the four input registers right to left with up to 63 bytes
@@ -487,30 +496,30 @@ CPU_LE(	rev		w8, w8		)
 	 * input size is < 16 bytes)
 	 */
 1:	mov		x15, #16
-	ands		x19, x0, #0xf
-	csel		x19, x19, x15, ne
+	ands		x0, x19, #0xf
+	csel		x0, x0, x15, ne
 	adr_l		x17, .Lpermute_table + 16
 
-	sub		x11, x15, x19
+	sub		x11, x15, x0
 	add		x12, x17, x11
 	sub		x17, x17, x11
 	ld1		{T1.16b}, [x12]
-	sub		x10, x1, x11
-	sub		x11, x2, x11
+	sub		x10, x20, x11
+	sub		x11, x21, x11
 
-	cmp		x0, #-16
+	cmp		x19, #-16
 	csel		x14, x15, xzr, gt
-	cmp		x0, #-32
+	cmp		x19, #-32
 	csel		x15, x15, xzr, gt
-	cmp		x0, #-48
-	csel		x16, x19, xzr, gt
-	csel		x1, x1, x10, gt
-	csel		x2, x2, x11, gt
-
-	ld1		{INP0.16b}, [x2], x14
-	ld1		{INP1.16b}, [x2], x15
-	ld1		{INP2.16b}, [x2], x16
-	ld1		{INP3.16b}, [x2]
+	cmp		x19, #-48
+	csel		x16, x0, xzr, gt
+	csel		x20, x20, x10, gt
+	csel		x21, x21, x11, gt
+
+	ld1		{INP0.16b}, [x21], x14
+	ld1		{INP1.16b}, [x21], x15
+	ld1		{INP2.16b}, [x21], x16
+	ld1		{INP3.16b}, [x21]
 	tbl		INP3.16b, {INP3.16b}, T1.16b
 	b		2f
 	.previous
@@ -521,14 +530,24 @@ CPU_LE(	rev		w8, w8		)
 
 	bl		pmull_gcm_enc_4x
 
-	tbnz		x0, #63, 6f
-	st1		{INP0.16b-INP3.16b}, [x1], #64
+	tbnz		x19, #63, 6f
+	st1		{INP0.16b-INP3.16b}, [x20], #64
 	.if		\enc == 1
 	bl		pmull_gcm_ghash_4x
 	.endif
-	bne		0b
 
-3:	ldp		x19, x10, [sp, #24]
+	beq		3f
+
+	if_will_cond_yield_neon
+CPU_LE(	rev		w8, w8		)
+	str		w8, [x24, #12]			// store lower counter
+	st1		{XL.2d}, [x23]
+	do_cond_yield_neon
+	b		.Lrestart\enc
+	endif_yield_neon
+	b		0b
+
+3:	ldr		x10, [sp, #.Lframe_local_offset]
 	cbz		x10, 5f				// output tag?
 
 	ld1		{INP3.16b}, [x10]		// load lengths[]
@@ -536,10 +555,10 @@ CPU_LE(	rev		w8, w8		)
 	bl		pmull_gcm_ghash_4x
 
 	mov		w11, #(0x1 << 24)		// BE '1U'
-	ld1		{KS0.16b}, [x5]
+	ld1		{KS0.16b}, [x24]
 	mov		KS0.s[3], w11
 
-	enc_block	KS0, x7, x6, x12
+	enc_block	KS0, x26, x25, x12
 
 	ext		XL.16b, XL.16b, XL.16b, #8
 	rev64		XL.16b, XL.16b
@@ -548,7 +567,7 @@ CPU_LE(	rev		w8, w8		)
 	.if		\enc == 1
 	st1		{XL.16b}, [x10]			// store tag
 	.else
-	ldp		x11, x12, [sp, #40]		// load tag pointer and authsize
+	ldp		x11, x12, [sp, #.Lframe_local_offset + 8] // load tag pointer and authsize
 	adr_l		x17, .Lpermute_table
 	ld1		{KS0.16b}, [x11]		// load supplied tag
 	add		x17, x17, x12
@@ -561,33 +580,33 @@ CPU_LE(	rev		w8, w8		)
 	smov		w0, v0.b[0]			// return b0
 	.endif
 
-4:	ldp		x29, x30, [sp], #32
+4:	frame_pop
 	ret
 
 5:
 CPU_LE(	rev		w8, w8		)
-	str		w8, [x5, #12]			// store lower counter
-	st1		{XL.2d}, [x4]
+	str		w8, [x24, #12]			// store lower counter
+	st1		{XL.2d}, [x23]
 	b		4b
 
 6:	ld1		{T1.16b-T2.16b}, [x17], #32	// permute vectors
-	sub		x17, x17, x19, lsl #1
+	sub		x17, x17, x0, lsl #1
 
 	cmp		w9, #1
 	beq		7f
 	.subsection	1
-7:	ld1		{INP2.16b}, [x1]
+7:	ld1		{INP2.16b}, [x20]
 	tbx		INP2.16b, {INP3.16b}, T1.16b
 	mov		INP3.16b, INP2.16b
 	b		8f
 	.previous
 
-	st1		{INP0.16b}, [x1], x14
-	st1		{INP1.16b}, [x1], x15
-	st1		{INP2.16b}, [x1], x16
+	st1		{INP0.16b}, [x20], x14
+	st1		{INP1.16b}, [x20], x15
+	st1		{INP2.16b}, [x20], x16
 	tbl		INP3.16b, {INP3.16b}, T1.16b
 	tbx		INP3.16b, {INP2.16b}, T2.16b
-8:	st1		{INP3.16b}, [x1]
+8:	st1		{INP3.16b}, [x20]
 
 	.if		\enc == 1
 	ld1		{T1.16b}, [x17]
@@ -699,7 +718,7 @@ SYM_FUNC_START_LOCAL(pmull_gcm_ghash_4x)
 SYM_FUNC_END(pmull_gcm_ghash_4x)
 
 SYM_FUNC_START_LOCAL(pmull_gcm_enc_4x)
-	ld1		{KS0.16b}, [x5]			// load upper counter
+	ld1		{KS0.16b}, [x24]		// load upper counter
 	sub		w10, w8, #4
 	sub		w11, w8, #3
 	sub		w12, w8, #2
@@ -716,13 +735,13 @@ SYM_FUNC_START_LOCAL(pmull_gcm_enc_4x)
 	ins		KS2.s[3], w12
 	ins		KS3.s[3], w13
 
-	add		x10, x6, #96			// round key pointer
+	add		x10, x25, #96			// round key pointer
 	ld1		{K6.4s-K7.4s}, [x10], #32
 	.irp		key, K0, K1, K2, K3, K4, K5
 	enc_qround	KS0, KS1, KS2, KS3, \key
 	.endr
 
-	tbnz		x7, #2, .Lnot128
+	tbnz		x26, #2, .Lnot128
 	.subsection	1
 .Lnot128:
 	ld1		{K8.4s-K9.4s}, [x10], #32
@@ -733,7 +752,7 @@ SYM_FUNC_START_LOCAL(pmull_gcm_enc_4x)
 	.irp		key, K8, K9
 	enc_qround	KS0, KS1, KS2, KS3, \key
 	.endr
-	tbz		x7, #1, .Lout192
+	tbz		x26, #1, .Lout192
 	b		.Lout256
 	.previous
 
-- 
2.17.1

