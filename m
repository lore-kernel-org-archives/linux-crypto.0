From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 16/19] crypto: arm64/aes-ghash - yield after processing fixed number of blocks
Date: Mon,  4 Dec 2017 12:26:42 +0000
Message-ID: <20171204122645.31535-17-ard.biesheuvel@linaro.org>
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
Return-path: <linux-rt-users-owner@vger.kernel.org>
In-Reply-To: <20171204122645.31535-1-ard.biesheuvel@linaro.org>
Sender: linux-rt-users-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This updates both the core GHASH as well as the AES-GCM algorithm to
yield each time after processing a fixed chunk of input. For the GCM
driver, we align with the other AES/CE block mode drivers, and use
a block size of 64 bytes. The core GHASH is much shorter, so let's
use a block size of 128 bytes for that one.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/ghash-ce-core.S | 128 ++++++++++++++------
 1 file changed, 92 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/crypto/ghash-ce-core.S b/arch/arm64/crypto/ghash-ce-core.S
index 11ebf1ae248a..fbfd4681675d 100644
--- a/arch/arm64/crypto/ghash-ce-core.S
+++ b/arch/arm64/crypto/ghash-ce-core.S
@@ -212,23 +212,36 @@
 	ushr		XL.2d, XL.2d, #1
 	.endm
 
-	.macro		__pmull_ghash, pn
-	ld1		{SHASH.2d}, [x3]
-	ld1		{XL.2d}, [x1]
+	.macro		__pmull_ghash, pn, yield
+	stp		x29, x30, [sp, #-64]!
+	mov		x29, sp
+	stp		x19, x20, [sp, #16]
+	stp		x21, x22, [sp, #32]
+	str		x23, [sp, #48]
+
+	mov		x19, x0
+	mov		x20, x1
+	mov		x21, x2
+	mov		x22, x3
+	mov		x23, x4
+
+0:	ld1		{SHASH.2d}, [x22]
+	ld1		{XL.2d}, [x20]
 	ext		SHASH2.16b, SHASH.16b, SHASH.16b, #8
 	eor		SHASH2.16b, SHASH2.16b, SHASH.16b
 
 	__pmull_pre_\pn
 
 	/* do the head block first, if supplied */
-	cbz		x4, 0f
-	ld1		{T1.2d}, [x4]
-	b		1f
+	cbz		x23, 1f
+	ld1		{T1.2d}, [x23]
+	mov		x23, xzr
+	b		2f
 
-0:	ld1		{T1.2d}, [x2], #16
-	sub		w0, w0, #1
+1:	ld1		{T1.2d}, [x21], #16
+	sub		w19, w19, #1
 
-1:	/* multiply XL by SHASH in GF(2^128) */
+2:	/* multiply XL by SHASH in GF(2^128) */
 CPU_LE(	rev64		T1.16b, T1.16b	)
 
 	ext		T2.16b, XL.16b, XL.16b, #8
@@ -250,9 +263,19 @@ CPU_LE(	rev64		T1.16b, T1.16b	)
 	eor		T2.16b, T2.16b, XH.16b
 	eor		XL.16b, XL.16b, T2.16b
 
-	cbnz		w0, 0b
+	cbz		w19, 3f
 
-	st1		{XL.2d}, [x1]
+	yield_neon_pre	w19, \yield, 1, 1b
+	st1		{XL.2d}, [x20]
+	yield_neon_post	0b
+
+	b		1b
+
+3:	st1		{XL.2d}, [x20]
+	ldp		x19, x20, [sp, #16]
+	ldp		x21, x22, [sp, #32]
+	ldr		x23, [sp, #48]
+	ldp		x29, x30, [sp], #64
 	ret
 	.endm
 
@@ -261,11 +284,11 @@ CPU_LE(	rev64		T1.16b, T1.16b	)
 	 *			   struct ghash_key const *k, const char *head)
 	 */
 ENTRY(pmull_ghash_update_p64)
-	__pmull_ghash	p64
+	__pmull_ghash	p64, 5
 ENDPROC(pmull_ghash_update_p64)
 
 ENTRY(pmull_ghash_update_p8)
-	__pmull_ghash	p8
+	__pmull_ghash	p8, 2
 ENDPROC(pmull_ghash_update_p8)
 
 	KS		.req	v8
@@ -304,38 +327,56 @@ ENDPROC(pmull_ghash_update_p8)
 	.endm
 
 	.macro		pmull_gcm_do_crypt, enc
-	ld1		{SHASH.2d}, [x4]
-	ld1		{XL.2d}, [x1]
-	ldr		x8, [x5, #8]			// load lower counter
+	stp		x29, x30, [sp, #-96]!
+	mov		x29, sp
+	stp		x19, x20, [sp, #16]
+	stp		x21, x22, [sp, #32]
+	stp		x23, x24, [sp, #48]
+	stp		x25, x26, [sp, #64]
+	str		x27, [sp, #80]
+
+	mov		x19, x0
+	mov		x20, x1
+	mov		x21, x2
+	mov		x22, x3
+	mov		x23, x4
+	mov		x24, x5
+	mov		x25, x6
+	mov		x26, x7
+
+	ldr		x27, [x24, #8]			// load lower counter
+CPU_LE(	rev		x27, x27	)
+
+0:	ld1		{SHASH.2d}, [x23]
+	ld1		{XL.2d}, [x20]
 
 	movi		MASK.16b, #0xe1
 	ext		SHASH2.16b, SHASH.16b, SHASH.16b, #8
-CPU_LE(	rev		x8, x8		)
 	shl		MASK.2d, MASK.2d, #57
 	eor		SHASH2.16b, SHASH2.16b, SHASH.16b
 
 	.if		\enc == 1
-	ld1		{KS.16b}, [x7]
+	ld1		{KS.16b}, [x26]
 	.endif
 
-0:	ld1		{CTR.8b}, [x5]			// load upper counter
-	ld1		{INP.16b}, [x3], #16
-	rev		x9, x8
-	add		x8, x8, #1
-	sub		w0, w0, #1
+1:	ld1		{CTR.8b}, [x24]			// load upper counter
+	ld1		{INP.16b}, [x22], #16
+	rev		x9, x27
+	add		x27, x27, #1
+	sub		w19, w19, #1
 	ins		CTR.d[1], x9			// set lower counter
 
 	.if		\enc == 1
 	eor		INP.16b, INP.16b, KS.16b	// encrypt input
-	st1		{INP.16b}, [x2], #16
+	st1		{INP.16b}, [x21], #16
 	.endif
 
 	rev64		T1.16b, INP.16b
 
-	cmp		w6, #12
-	b.ge		2f				// AES-192/256?
+	cmp		w25, #12
+	b.ge		4f				// AES-192/256?
 
-1:	enc_round	CTR, v21
+2:	enc_round	CTR, v21
 
 	ext		T2.16b, XL.16b, XL.16b, #8
 	ext		IN1.16b, T1.16b, T1.16b, #8
@@ -390,27 +431,42 @@ CPU_LE(	rev		x8, x8		)
 
 	.if		\enc == 0
 	eor		INP.16b, INP.16b, KS.16b
-	st1		{INP.16b}, [x2], #16
+	st1		{INP.16b}, [x21], #16
 	.endif
 
-	cbnz		w0, 0b
+	cbz		w19, 3f
 
-CPU_LE(	rev		x8, x8		)
-	st1		{XL.2d}, [x1]
-	str		x8, [x5, #8]			// store lower counter
+	yield_neon_pre	w19, 8, 1, 1b			// yield every 8 blocks
+	st1		{XL.2d}, [x20]
+	.if		\enc == 1
+	st1		{KS.16b}, [x26]
+	.endif
+	yield_neon_post	0b
 
+	b		1b
+
+3:	st1		{XL.2d}, [x20]
 	.if		\enc == 1
-	st1		{KS.16b}, [x7]
+	st1		{KS.16b}, [x26]
 	.endif
 
+CPU_LE(	rev		x27, x27	)
+	str		x27, [x24, #8]			// store lower counter
+
+	ldp		x19, x20, [sp, #16]
+	ldp		x21, x22, [sp, #32]
+	ldp		x23, x24, [sp, #48]
+	ldp		x25, x26, [sp, #64]
+	ldr		x27, [sp, #80]
+	ldp		x29, x30, [sp], #96
 	ret
 
-2:	b.eq		3f				// AES-192?
+4:	b.eq		5f				// AES-192?
 	enc_round	CTR, v17
 	enc_round	CTR, v18
-3:	enc_round	CTR, v19
+5:	enc_round	CTR, v19
 	enc_round	CTR, v20
-	b		1b
+	b		2b
 	.endm
 
 	/*
-- 
2.11.0

