From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 13/20] crypto: arm64/sha2-ce - yield NEON after every block of input
Date: Wed,  6 Dec 2017 19:43:39 +0000
Message-ID: <20171206194346.24393-14-ard.biesheuvel@linaro.org>
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
 arch/arm64/crypto/sha2-ce-core.S | 37 ++++++++++++++------
 1 file changed, 26 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/crypto/sha2-ce-core.S b/arch/arm64/crypto/sha2-ce-core.S
index 679c6c002f4f..7709455dae92 100644
--- a/arch/arm64/crypto/sha2-ce-core.S
+++ b/arch/arm64/crypto/sha2-ce-core.S
@@ -77,30 +77,36 @@
 	 *			  int blocks)
 	 */
 ENTRY(sha2_ce_transform)
+	frame_push	3
+
+	mov		x19, x0
+	mov		x20, x1
+	mov		x21, x2
+
 	/* load round constants */
-	adr		x8, .Lsha2_rcon
+0:	adr		x8, .Lsha2_rcon
 	ld1		{ v0.4s- v3.4s}, [x8], #64
 	ld1		{ v4.4s- v7.4s}, [x8], #64
 	ld1		{ v8.4s-v11.4s}, [x8], #64
 	ld1		{v12.4s-v15.4s}, [x8]
 
 	/* load state */
-	ld1		{dgav.4s, dgbv.4s}, [x0]
+	ld1		{dgav.4s, dgbv.4s}, [x19]
 
 	/* load sha256_ce_state::finalize */
 	ldr_l		w4, sha256_ce_offsetof_finalize, x4
-	ldr		w4, [x0, x4]
+	ldr		w4, [x19, x4]
 
 	/* load input */
-0:	ld1		{v16.4s-v19.4s}, [x1], #64
-	sub		w2, w2, #1
+1:	ld1		{v16.4s-v19.4s}, [x20], #64
+	sub		w21, w21, #1
 
 CPU_LE(	rev32		v16.16b, v16.16b	)
 CPU_LE(	rev32		v17.16b, v17.16b	)
 CPU_LE(	rev32		v18.16b, v18.16b	)
 CPU_LE(	rev32		v19.16b, v19.16b	)
 
-1:	add		t0.4s, v16.4s, v0.4s
+2:	add		t0.4s, v16.4s, v0.4s
 	mov		dg0v.16b, dgav.16b
 	mov		dg1v.16b, dgbv.16b
 
@@ -129,16 +135,24 @@ CPU_LE(	rev32		v19.16b, v19.16b	)
 	add		dgbv.4s, dgbv.4s, dg1v.4s
 
 	/* handled all input blocks? */
-	cbnz		w2, 0b
+	cbz		w21, 3f
+
+	if_will_cond_yield_neon
+	st1		{dgav.4s, dgbv.4s}, [x19]
+	do_cond_yield_neon
+	b		0b
+	endif_yield_neon
+
+	b		1b
 
 	/*
 	 * Final block: add padding and total bit count.
 	 * Skip if the input size was not a round multiple of the block size,
 	 * the padding is handled by the C code in that case.
 	 */
-	cbz		x4, 3f
+3:	cbz		x4, 4f
 	ldr_l		w4, sha256_ce_offsetof_count, x4
-	ldr		x4, [x0, x4]
+	ldr		x4, [x19, x4]
 	movi		v17.2d, #0
 	mov		x8, #0x80000000
 	movi		v18.2d, #0
@@ -147,9 +161,10 @@ CPU_LE(	rev32		v19.16b, v19.16b	)
 	mov		x4, #0
 	mov		v19.d[0], xzr
 	mov		v19.d[1], x7
-	b		1b
+	b		2b
 
 	/* store new state */
-3:	st1		{dgav.4s, dgbv.4s}, [x0]
+4:	st1		{dgav.4s, dgbv.4s}, [x19]
+	frame_pop	3
 	ret
 ENDPROC(sha2_ce_transform)
-- 
2.11.0

