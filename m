From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 18/20] crypto: arm64/crc32-ce - yield NEON after every block of input
Date: Wed,  6 Dec 2017 19:43:44 +0000
Message-ID: <20171206194346.24393-19-ard.biesheuvel@linaro.org>
References: <20171206194346.24393-1-ard.biesheuvel@linaro.org>
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
Return-path: <linux-rt-users-owner@vger.kernel.org>
In-Reply-To: <20171206194346.24393-1-ard.biesheuvel@linaro.org>
Sender: linux-rt-users-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Avoid excessive scheduling delays under a preemptible kernel by
yielding the NEON after every block of input.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/crc32-ce-core.S | 44 ++++++++++++++------
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/crypto/crc32-ce-core.S b/arch/arm64/crypto/crc32-ce-core.S
index 18f5a8442276..b4ddbb2027e5 100644
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
 
@@ -116,13 +116,21 @@
 	 *                     size_t len, uint crc32)
 	 */
 ENTRY(crc32_pmull_le)
-	adr		x3, .Lcrc32_constants
+	frame_push	4, 64
+
+	adr		x22, .Lcrc32_constants
 	b		0f
 
 ENTRY(crc32c_pmull_le)
-	adr		x3, .Lcrc32c_constants
+	frame_push	4, 64
+
+	adr		x22, .Lcrc32c_constants
+
+0:	mov		BUF, x0
+	mov		LEN, x1
+	mov		CRC, x2
 
-0:	bic		LEN, LEN, #15
+	bic		LEN, LEN, #15
 	ld1		{v1.16b-v4.16b}, [BUF], #0x40
 	movi		vzr.16b, #0
 	fmov		dCONSTANT, CRC
@@ -131,7 +139,7 @@ ENTRY(crc32c_pmull_le)
 	cmp		LEN, #0x40
 	b.lt		less_64
 
-	ldr		qCONSTANT, [x3]
+	ldr		qCONSTANT, [x22]
 
 loop_64:		/* 64 bytes Full cache line folding */
 	sub		LEN, LEN, #0x40
@@ -161,10 +169,21 @@ loop_64:		/* 64 bytes Full cache line folding */
 	eor		v4.16b, v4.16b, v8.16b
 
 	cmp		LEN, #0x40
-	b.ge		loop_64
+	b.lt		less_64
+
+	if_will_cond_yield_neon
+	stp		q1, q2, [sp, #48]
+	stp		q3, q4, [sp, #80]
+	do_cond_yield_neon
+	ldp		q1, q2, [sp, #48]
+	ldp		q3, q4, [sp, #80]
+	ldr		qCONSTANT, [x22]
+	movi		vzr.16b, #0
+	endif_yield_neon
+	b		loop_64
 
 less_64:		/* Folding cache line into 128bit */
-	ldr		qCONSTANT, [x3, #16]
+	ldr		qCONSTANT, [x22, #16]
 
 	pmull2		v5.1q, v1.2d, vCONSTANT.2d
 	pmull		v1.1q, v1.1d, vCONSTANT.1d
@@ -203,8 +222,8 @@ fold_64:
 	eor		v1.16b, v1.16b, v2.16b
 
 	/* final 32-bit fold */
-	ldr		dCONSTANT, [x3, #32]
-	ldr		d3, [x3, #40]
+	ldr		dCONSTANT, [x22, #32]
+	ldr		d3, [x22, #40]
 
 	ext		v2.16b, v1.16b, vzr.16b, #4
 	and		v1.16b, v1.16b, v3.16b
@@ -212,7 +231,7 @@ fold_64:
 	eor		v1.16b, v1.16b, v2.16b
 
 	/* Finish up with the bit-reversed barrett reduction 64 ==> 32 bits */
-	ldr		qCONSTANT, [x3, #48]
+	ldr		qCONSTANT, [x22, #48]
 
 	and		v2.16b, v1.16b, v3.16b
 	ext		v2.16b, vzr.16b, v2.16b, #8
@@ -222,6 +241,7 @@ fold_64:
 	eor		v1.16b, v1.16b, v2.16b
 	mov		w0, v1.s[1]
 
+	frame_pop	4, 64
 	ret
 ENDPROC(crc32_pmull_le)
 ENDPROC(crc32c_pmull_le)
-- 
2.11.0

