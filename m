From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 12/19] crypto: arm64/sha1-ce - yield every 8 blocks of input
Date: Mon,  4 Dec 2017 12:26:38 +0000
Message-ID: <20171204122645.31535-13-ard.biesheuvel@linaro.org>
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
Received: from mail-wm0-f67.google.com ([74.125.82.67]:44559 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753260AbdLDM1c (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Dec 2017 07:27:32 -0500
Received: by mail-wm0-f67.google.com with SMTP id t8so5455482wmc.3
        for <linux-crypto@vger.kernel.org>; Mon, 04 Dec 2017 04:27:31 -0800 (PST)
In-Reply-To: <20171204122645.31535-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Avoid excessive scheduling delays under a preemptible kernel by
yielding the NEON every 8 blocks of input.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/sha1-ce-core.S | 45 ++++++++++++++------
 1 file changed, 32 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/crypto/sha1-ce-core.S b/arch/arm64/crypto/sha1-ce-core.S
index 8550408735a0..7ae0dd369e0a 100644
--- a/arch/arm64/crypto/sha1-ce-core.S
+++ b/arch/arm64/crypto/sha1-ce-core.S
@@ -70,31 +70,40 @@
 	 *			  int blocks)
 	 */
 ENTRY(sha1_ce_transform)
+	stp		x29, x30, [sp, #-48]!
+	mov		x29, sp
+	stp		x19, x20, [sp, #16]
+	str		x21, [sp, #32]
+
+	mov		x19, x0
+	mov		x20, x1
+	mov		x21, x2
+
 	/* load round constants */
-	adr		x6, .Lsha1_rcon
+0:	adr		x6, .Lsha1_rcon
 	ld1r		{k0.4s}, [x6], #4
 	ld1r		{k1.4s}, [x6], #4
 	ld1r		{k2.4s}, [x6], #4
 	ld1r		{k3.4s}, [x6]
 
 	/* load state */
-	ld1		{dgav.4s}, [x0]
-	ldr		dgb, [x0, #16]
+	ld1		{dgav.4s}, [x19]
+	ldr		dgb, [x19, #16]
 
 	/* load sha1_ce_state::finalize */
 	ldr_l		w4, sha1_ce_offsetof_finalize, x4
-	ldr		w4, [x0, x4]
+	ldr		w4, [x19, x4]
 
 	/* load input */
-0:	ld1		{v8.4s-v11.4s}, [x1], #64
-	sub		w2, w2, #1
+1:	ld1		{v8.4s-v11.4s}, [x20], #64
+	sub		w21, w21, #1
 
 CPU_LE(	rev32		v8.16b, v8.16b		)
 CPU_LE(	rev32		v9.16b, v9.16b		)
 CPU_LE(	rev32		v10.16b, v10.16b	)
 CPU_LE(	rev32		v11.16b, v11.16b	)
 
-1:	add		t0.4s, v8.4s, k0.4s
+2:	add		t0.4s, v8.4s, k0.4s
 	mov		dg0v.16b, dgav.16b
 
 	add_update	c, ev, k0,  8,  9, 10, 11, dgb
@@ -125,16 +134,23 @@ CPU_LE(	rev32		v11.16b, v11.16b	)
 	add		dgbv.2s, dgbv.2s, dg1v.2s
 	add		dgav.4s, dgav.4s, dg0v.4s
 
-	cbnz		w2, 0b
+	cbz		w21, 3f
+
+	yield_neon_pre	w21, 3, 1, 1b			// yield every 8 blocks
+	st1		{dgav.4s}, [x19]
+	str		dgb, [x19, #16]
+	yield_neon_post	0b
+
+	b		1b
 
 	/*
 	 * Final block: add padding and total bit count.
 	 * Skip if the input size was not a round multiple of the block size,
 	 * the padding is handled by the C code in that case.
 	 */
-	cbz		x4, 3f
+3:	cbz		x4, 4f
 	ldr_l		w4, sha1_ce_offsetof_count, x4
-	ldr		x4, [x0, x4]
+	ldr		x4, [x19, x4]
 	movi		v9.2d, #0
 	mov		x8, #0x80000000
 	movi		v10.2d, #0
@@ -143,10 +159,13 @@ CPU_LE(	rev32		v11.16b, v11.16b	)
 	mov		x4, #0
 	mov		v11.d[0], xzr
 	mov		v11.d[1], x7
-	b		1b
+	b		2b
 
 	/* store new state */
-3:	st1		{dgav.4s}, [x0]
-	str		dgb, [x0, #16]
+4:	st1		{dgav.4s}, [x19]
+	str		dgb, [x19, #16]
+	ldp		x19, x20, [sp, #16]
+	ldr		x21, [sp, #32]
+	ldp		x29, x30, [sp], #48
 	ret
 ENDPROC(sha1_ce_transform)
-- 
2.11.0
