From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 17/19] crypto: arm64/crc32-ce - yield NEON every 16 blocks of input
Date: Mon,  4 Dec 2017 12:26:43 +0000
Message-ID: <20171204122645.31535-18-ard.biesheuvel@linaro.org>
References: <20171204122645.31535-1-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Dave Martin <Dave.Martin@arm.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-rt-users@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:40343 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753330AbdLDM1s (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Dec 2017 07:27:48 -0500
Received: by mail-wr0-f196.google.com with SMTP id q9so17063198wre.7
        for <linux-crypto@vger.kernel.org>; Mon, 04 Dec 2017 04:27:48 -0800 (PST)
In-Reply-To: <20171204122645.31535-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Avoid excessive scheduling delays under a preemptible kernel by
yielding the NEON every 16 blocks of input.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/crc32-ce-core.S | 55 +++++++++++++++-----
 1 file changed, 43 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/crypto/crc32-ce-core.S b/arch/arm64/crypto/crc32-ce-core.S
index 18f5a8442276..bca3d22fae7b 100644
--- a/arch/arm64/crypto/crc32-ce-core.S
+++ b/arch/arm64/crypto/crc32-ce-core.S
@@ -100,9 +100,9 @@
 	dCONSTANT	.req	d0
 	qCONSTANT	.req	q0
 
-	BUF		.req	x0
-	LEN		.req	x1
-	CRC		.req	x2
+	BUF		.req	x19
+	LEN		.req	x20
+	CRC		.req	x21
 
 	vzr		.req	v9
 
@@ -116,13 +116,27 @@
 	 *                     size_t len, uint crc32)
 	 */
 ENTRY(crc32_pmull_le)
-	adr		x3, .Lcrc32_constants
+	stp		x29, x30, [sp, #-112]!
+	mov		x29, sp
+	stp		x19, x20, [sp, #16]
+	stp		x21, x22, [sp, #32]
+
+	adr		x22, .Lcrc32_constants
 	b		0f
 
 ENTRY(crc32c_pmull_le)
-	adr		x3, .Lcrc32c_constants
+	stp		x29, x30, [sp, #-112]!
+	mov		x29, sp
+	stp		x19, x20, [sp, #16]
+	stp		x21, x22, [sp, #32]
+
+	adr		x22, .Lcrc32c_constants
 
-0:	bic		LEN, LEN, #15
+0:	mov		BUF, x0
+	mov		LEN, x1
+	mov		CRC, x2
+
+	bic		LEN, LEN, #15
 	ld1		{v1.16b-v4.16b}, [BUF], #0x40
 	movi		vzr.16b, #0
 	fmov		dCONSTANT, CRC
@@ -131,7 +145,7 @@ ENTRY(crc32c_pmull_le)
 	cmp		LEN, #0x40
 	b.lt		less_64
 
-	ldr		qCONSTANT, [x3]
+	ldr		qCONSTANT, [x22]
 
 loop_64:		/* 64 bytes Full cache line folding */
 	sub		LEN, LEN, #0x40
@@ -161,10 +175,24 @@ loop_64:		/* 64 bytes Full cache line folding */
 	eor		v4.16b, v4.16b, v8.16b
 
 	cmp		LEN, #0x40
-	b.ge		loop_64
+	b.lt		less_64
+
+	yield_neon_pre	LEN, 4, 64, loop_64		// yield every 16 blocks
+	stp		q1, q2, [sp, #48]
+	stp		q3, q4, [sp, #80]
+	yield_neon_post	2f
+	b		loop_64
+
+	.subsection	1
+2:	ldp		q1, q2, [sp, #48]
+	ldp		q3, q4, [sp, #80]
+	ldr		qCONSTANT, [x22]
+	movi		vzr.16b, #0
+	b		loop_64
+	.previous
 
 less_64:		/* Folding cache line into 128bit */
-	ldr		qCONSTANT, [x3, #16]
+	ldr		qCONSTANT, [x22, #16]
 
 	pmull2		v5.1q, v1.2d, vCONSTANT.2d
 	pmull		v1.1q, v1.1d, vCONSTANT.1d
@@ -203,8 +231,8 @@ fold_64:
 	eor		v1.16b, v1.16b, v2.16b
 
 	/* final 32-bit fold */
-	ldr		dCONSTANT, [x3, #32]
-	ldr		d3, [x3, #40]
+	ldr		dCONSTANT, [x22, #32]
+	ldr		d3, [x22, #40]
 
 	ext		v2.16b, v1.16b, vzr.16b, #4
 	and		v1.16b, v1.16b, v3.16b
@@ -212,7 +240,7 @@ fold_64:
 	eor		v1.16b, v1.16b, v2.16b
 
 	/* Finish up with the bit-reversed barrett reduction 64 ==> 32 bits */
-	ldr		qCONSTANT, [x3, #48]
+	ldr		qCONSTANT, [x22, #48]
 
 	and		v2.16b, v1.16b, v3.16b
 	ext		v2.16b, vzr.16b, v2.16b, #8
@@ -222,6 +250,9 @@ fold_64:
 	eor		v1.16b, v1.16b, v2.16b
 	mov		w0, v1.s[1]
 
+	ldp		x19, x20, [sp, #16]
+	ldp		x21, x22, [sp, #32]
+	ldp		x29, x30, [sp], #112
 	ret
 ENDPROC(crc32_pmull_le)
 ENDPROC(crc32c_pmull_le)
-- 
2.11.0
