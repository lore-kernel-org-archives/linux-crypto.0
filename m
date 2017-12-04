From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 14/19] crypto: arm64/aes-blk - yield after processing a fixed chunk of input
Date: Mon,  4 Dec 2017 12:26:40 +0000
Message-ID: <20171204122645.31535-15-ard.biesheuvel@linaro.org>
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

Currently, the AES block code may keep preemption disabled for as long
as it takes to process each contigous chunk of input, which could be as
large as a page or skb, depending on the context.

For this code to be useable in RT context, it needs to operate on fixed
chunks of limited size. So let's add a yield after each 16 blocks (for
the CE case) or after every block (for the pure NEON case), which will
disable and re-enable kernel mode NEON if a reschedule is pending.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-ce.S    |  17 +-
 arch/arm64/crypto/aes-modes.S | 379 +++++++++++++-------
 arch/arm64/crypto/aes-neon.S  |   2 +
 3 files changed, 272 insertions(+), 126 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce.S b/arch/arm64/crypto/aes-ce.S
index 50330f5c3adc..ccb17b65005a 100644
--- a/arch/arm64/crypto/aes-ce.S
+++ b/arch/arm64/crypto/aes-ce.S
@@ -15,6 +15,8 @@
 #define AES_ENTRY(func)		ENTRY(ce_ ## func)
 #define AES_ENDPROC(func)	ENDPROC(ce_ ## func)
 
+#define AES_YIELD_ORDER		4
+
 	.arch		armv8-a+crypto
 
 	/* preload all round keys */
@@ -30,18 +32,21 @@
 	.endm
 
 	/* prepare for encryption with key in rk[] */
-	.macro		enc_prepare, rounds, rk, ignore
-	load_round_keys	\rounds, \rk
+	.macro		enc_prepare, rounds, rk, temp
+	mov		\temp, \rk
+	load_round_keys	\rounds, \temp
 	.endm
 
 	/* prepare for encryption (again) but with new key in rk[] */
-	.macro		enc_switch_key, rounds, rk, ignore
-	load_round_keys	\rounds, \rk
+	.macro		enc_switch_key, rounds, rk, temp
+	mov		\temp, \rk
+	load_round_keys	\rounds, \temp
 	.endm
 
 	/* prepare for decryption with key in rk[] */
-	.macro		dec_prepare, rounds, rk, ignore
-	load_round_keys	\rounds, \rk
+	.macro		dec_prepare, rounds, rk, temp
+	mov		\temp, \rk
+	load_round_keys	\rounds, \temp
 	.endm
 
 	.macro		do_enc_Nx, de, mc, k, i0, i1, i2, i3
diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
index a68412e1e3a4..6fcdf82fa295 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -14,12 +14,12 @@
 	.align		4
 
 aes_encrypt_block4x:
-	encrypt_block4x	v0, v1, v2, v3, w3, x2, x8, w7
+	encrypt_block4x	v0, v1, v2, v3, w22, x21, x8, w7
 	ret
 ENDPROC(aes_encrypt_block4x)
 
 aes_decrypt_block4x:
-	decrypt_block4x	v0, v1, v2, v3, w3, x2, x8, w7
+	decrypt_block4x	v0, v1, v2, v3, w22, x21, x8, w7
 	ret
 ENDPROC(aes_decrypt_block4x)
 
@@ -31,57 +31,85 @@ ENDPROC(aes_decrypt_block4x)
 	 */
 
 AES_ENTRY(aes_ecb_encrypt)
-	stp		x29, x30, [sp, #-16]!
+	stp		x29, x30, [sp, #-64]!
 	mov		x29, sp
+	stp		x19, x20, [sp, #16]
+	stp		x21, x22, [sp, #32]
+	str		x23, [sp, #48]
 
-	enc_prepare	w3, x2, x5
+	mov		x19, x0
+	mov		x20, x1
+	mov		x21, x2
+	mov		x22, x3
+	mov		x23, x4
+
+.Lecbencrestart:
+	enc_prepare	w22, x21, x5
 
 .LecbencloopNx:
-	subs		w4, w4, #4
+	subs		w23, w23, #4
 	bmi		.Lecbenc1x
-	ld1		{v0.16b-v3.16b}, [x1], #64	/* get 4 pt blocks */
+	ld1		{v0.16b-v3.16b}, [x20], #64	/* get 4 pt blocks */
 	bl		aes_encrypt_block4x
-	st1		{v0.16b-v3.16b}, [x0], #64
+	st1		{v0.16b-v3.16b}, [x19], #64
+	yield_neon	.Lecbencrestart, w23, AES_YIELD_ORDER, 4, .LecbencloopNx
 	b		.LecbencloopNx
 .Lecbenc1x:
-	adds		w4, w4, #4
+	adds		w23, w23, #4
 	beq		.Lecbencout
 .Lecbencloop:
-	ld1		{v0.16b}, [x1], #16		/* get next pt block */
-	encrypt_block	v0, w3, x2, x5, w6
-	st1		{v0.16b}, [x0], #16
-	subs		w4, w4, #1
+	ld1		{v0.16b}, [x20], #16		/* get next pt block */
+	encrypt_block	v0, w22, x21, x5, w6
+	st1		{v0.16b}, [x19], #16
+	subs		w23, w23, #1
 	bne		.Lecbencloop
 .Lecbencout:
-	ldp		x29, x30, [sp], #16
+	ldp		x19, x20, [sp, #16]
+	ldp		x21, x22, [sp, #32]
+	ldr		x23, [sp, #48]
+	ldp		x29, x30, [sp], #64
 	ret
 AES_ENDPROC(aes_ecb_encrypt)
 
 
 AES_ENTRY(aes_ecb_decrypt)
-	stp		x29, x30, [sp, #-16]!
+	stp		x29, x30, [sp, #-64]!
 	mov		x29, sp
+	stp		x19, x20, [sp, #16]
+	stp		x21, x22, [sp, #32]
+	str		x23, [sp, #48]
+
+	mov		x19, x0
+	mov		x20, x1
+	mov		x21, x2
+	mov		x22, x3
+	mov		x23, x4
 
-	dec_prepare	w3, x2, x5
+.Lecbdecrestart:
+	dec_prepare	w22, x21, x5
 
 .LecbdecloopNx:
-	subs		w4, w4, #4
+	subs		w23, w23, #4
 	bmi		.Lecbdec1x
-	ld1		{v0.16b-v3.16b}, [x1], #64	/* get 4 ct blocks */
+	ld1		{v0.16b-v3.16b}, [x20], #64	/* get 4 ct blocks */
 	bl		aes_decrypt_block4x
-	st1		{v0.16b-v3.16b}, [x0], #64
+	st1		{v0.16b-v3.16b}, [x19], #64
+	yield_neon	.Lecbdecrestart, w23, AES_YIELD_ORDER, 4, .LecbdecloopNx
 	b		.LecbdecloopNx
 .Lecbdec1x:
-	adds		w4, w4, #4
+	adds		w23, w23, #4
 	beq		.Lecbdecout
 .Lecbdecloop:
-	ld1		{v0.16b}, [x1], #16		/* get next ct block */
-	decrypt_block	v0, w3, x2, x5, w6
-	st1		{v0.16b}, [x0], #16
-	subs		w4, w4, #1
+	ld1		{v0.16b}, [x20], #16		/* get next ct block */
+	decrypt_block	v0, w22, x21, x5, w6
+	st1		{v0.16b}, [x19], #16
+	subs		w23, w23, #1
 	bne		.Lecbdecloop
 .Lecbdecout:
-	ldp		x29, x30, [sp], #16
+	ldp		x19, x20, [sp, #16]
+	ldp		x21, x22, [sp, #32]
+	ldr		x23, [sp, #48]
+	ldp		x29, x30, [sp], #64
 	ret
 AES_ENDPROC(aes_ecb_decrypt)
 
@@ -94,78 +122,114 @@ AES_ENDPROC(aes_ecb_decrypt)
 	 */
 
 AES_ENTRY(aes_cbc_encrypt)
-	ld1		{v4.16b}, [x5]			/* get iv */
-	enc_prepare	w3, x2, x6
+	stp		x29, x30, [sp, #-64]!
+	mov		x29, sp
+	stp		x19, x20, [sp, #16]
+	stp		x21, x22, [sp, #32]
+	stp		x23, x24, [sp, #48]
+
+	mov		x19, x0
+	mov		x20, x1
+	mov		x21, x2
+	mov		x22, x3
+	mov		x23, x4
+	mov		x24, x5
+
+.Lcbcencrestart:
+	ld1		{v4.16b}, [x24]			/* get iv */
+	enc_prepare	w22, x21, x6
 
 .Lcbcencloop4x:
-	subs		w4, w4, #4
+	subs		w23, w23, #4
 	bmi		.Lcbcenc1x
-	ld1		{v0.16b-v3.16b}, [x1], #64	/* get 4 pt blocks */
+	ld1		{v0.16b-v3.16b}, [x20], #64	/* get 4 pt blocks */
 	eor		v0.16b, v0.16b, v4.16b		/* ..and xor with iv */
-	encrypt_block	v0, w3, x2, x6, w7
+	encrypt_block	v0, w22, x21, x6, w7
 	eor		v1.16b, v1.16b, v0.16b
-	encrypt_block	v1, w3, x2, x6, w7
+	encrypt_block	v1, w22, x21, x6, w7
 	eor		v2.16b, v2.16b, v1.16b
-	encrypt_block	v2, w3, x2, x6, w7
+	encrypt_block	v2, w22, x21, x6, w7
 	eor		v3.16b, v3.16b, v2.16b
-	encrypt_block	v3, w3, x2, x6, w7
-	st1		{v0.16b-v3.16b}, [x0], #64
+	encrypt_block	v3, w22, x21, x6, w7
+	st1		{v0.16b-v3.16b}, [x19], #64
 	mov		v4.16b, v3.16b
+	st1		{v4.16b}, [x24]			/* return iv */
+	yield_neon	.Lcbcencrestart, w23, AES_YIELD_ORDER, 4, .Lcbcencloop4x
 	b		.Lcbcencloop4x
 .Lcbcenc1x:
-	adds		w4, w4, #4
+	adds		w23, w23, #4
 	beq		.Lcbcencout
 .Lcbcencloop:
-	ld1		{v0.16b}, [x1], #16		/* get next pt block */
+	ld1		{v0.16b}, [x20], #16		/* get next pt block */
 	eor		v4.16b, v4.16b, v0.16b		/* ..and xor with iv */
-	encrypt_block	v4, w3, x2, x6, w7
-	st1		{v4.16b}, [x0], #16
-	subs		w4, w4, #1
+	encrypt_block	v4, w22, x21, x6, w7
+	st1		{v4.16b}, [x19], #16
+	subs		w23, w23, #1
 	bne		.Lcbcencloop
 .Lcbcencout:
-	st1		{v4.16b}, [x5]			/* return iv */
+	st1		{v4.16b}, [x24]			/* return iv */
+	ldp		x19, x20, [sp, #16]
+	ldp		x21, x22, [sp, #32]
+	ldp		x23, x24, [sp, #48]
+	ldp		x29, x30, [sp], #64
 	ret
 AES_ENDPROC(aes_cbc_encrypt)
 
 
 AES_ENTRY(aes_cbc_decrypt)
-	stp		x29, x30, [sp, #-16]!
+	stp		x29, x30, [sp, #-64]!
 	mov		x29, sp
+	stp		x19, x20, [sp, #16]
+	stp		x21, x22, [sp, #32]
+	stp		x23, x24, [sp, #48]
 
-	ld1		{v7.16b}, [x5]			/* get iv */
-	dec_prepare	w3, x2, x6
+	mov		x19, x0
+	mov		x20, x1
+	mov		x21, x2
+	mov		x22, x3
+	mov		x23, x4
+	mov		x24, x5
+
+.Lcbcdecrestart:
+	ld1		{v7.16b}, [x24]			/* get iv */
+	dec_prepare	w22, x21, x6
 
 .LcbcdecloopNx:
-	subs		w4, w4, #4
+	subs		w23, w23, #4
 	bmi		.Lcbcdec1x
-	ld1		{v0.16b-v3.16b}, [x1], #64	/* get 4 ct blocks */
+	ld1		{v0.16b-v3.16b}, [x20], #64	/* get 4 ct blocks */
 	mov		v4.16b, v0.16b
 	mov		v5.16b, v1.16b
 	mov		v6.16b, v2.16b
 	bl		aes_decrypt_block4x
-	sub		x1, x1, #16
+	sub		x20, x20, #16
 	eor		v0.16b, v0.16b, v7.16b
 	eor		v1.16b, v1.16b, v4.16b
-	ld1		{v7.16b}, [x1], #16		/* reload 1 ct block */
+	ld1		{v7.16b}, [x20], #16		/* reload 1 ct block */
 	eor		v2.16b, v2.16b, v5.16b
 	eor		v3.16b, v3.16b, v6.16b
-	st1		{v0.16b-v3.16b}, [x0], #64
+	st1		{v0.16b-v3.16b}, [x19], #64
+	st1		{v7.16b}, [x24]			/* return iv */
+	yield_neon	.Lcbcdecrestart, w23, AES_YIELD_ORDER, 4, .LcbcdecloopNx
 	b		.LcbcdecloopNx
 .Lcbcdec1x:
-	adds		w4, w4, #4
+	adds		w23, w23, #4
 	beq		.Lcbcdecout
 .Lcbcdecloop:
-	ld1		{v1.16b}, [x1], #16		/* get next ct block */
+	ld1		{v1.16b}, [x20], #16		/* get next ct block */
 	mov		v0.16b, v1.16b			/* ...and copy to v0 */
-	decrypt_block	v0, w3, x2, x6, w7
+	decrypt_block	v0, w22, x21, x6, w7
 	eor		v0.16b, v0.16b, v7.16b		/* xor with iv => pt */
 	mov		v7.16b, v1.16b			/* ct is next iv */
-	st1		{v0.16b}, [x0], #16
-	subs		w4, w4, #1
+	st1		{v0.16b}, [x19], #16
+	subs		w23, w23, #1
 	bne		.Lcbcdecloop
 .Lcbcdecout:
-	st1		{v7.16b}, [x5]			/* return iv */
-	ldp		x29, x30, [sp], #16
+	st1		{v7.16b}, [x24]			/* return iv */
+	ldp		x19, x20, [sp, #16]
+	ldp		x21, x22, [sp, #32]
+	ldp		x23, x24, [sp, #48]
+	ldp		x29, x30, [sp], #64
 	ret
 AES_ENDPROC(aes_cbc_decrypt)
 
@@ -176,19 +240,30 @@ AES_ENDPROC(aes_cbc_decrypt)
 	 */
 
 AES_ENTRY(aes_ctr_encrypt)
-	stp		x29, x30, [sp, #-16]!
+	stp		x29, x30, [sp, #-64]!
 	mov		x29, sp
+	stp		x19, x20, [sp, #16]
+	stp		x21, x22, [sp, #32]
+	stp		x23, x24, [sp, #48]
+
+	mov		x19, x0
+	mov		x20, x1
+	mov		x21, x2
+	mov		x22, x3
+	mov		x23, x4
+	mov		x24, x5
 
-	enc_prepare	w3, x2, x6
-	ld1		{v4.16b}, [x5]
+.Lctrrestart:
+	enc_prepare	w22, x21, x6
+	ld1		{v4.16b}, [x24]
 
 	umov		x6, v4.d[1]		/* keep swabbed ctr in reg */
 	rev		x6, x6
-	cmn		w6, w4			/* 32 bit overflow? */
-	bcs		.Lctrloop
 .LctrloopNx:
-	subs		w4, w4, #4
+	subs		w23, w23, #4
 	bmi		.Lctr1x
+	cmn		w6, #4			/* 32 bit overflow? */
+	bcs		.Lctr1x
 	ldr		q8, =0x30000000200000001	/* addends 1,2,3[,0] */
 	dup		v7.4s, w6
 	mov		v0.16b, v4.16b
@@ -200,25 +275,27 @@ AES_ENTRY(aes_ctr_encrypt)
 	mov		v1.s[3], v8.s[0]
 	mov		v2.s[3], v8.s[1]
 	mov		v3.s[3], v8.s[2]
-	ld1		{v5.16b-v7.16b}, [x1], #48	/* get 3 input blocks */
+	ld1		{v5.16b-v7.16b}, [x20], #48	/* get 3 input blocks */
 	bl		aes_encrypt_block4x
 	eor		v0.16b, v5.16b, v0.16b
-	ld1		{v5.16b}, [x1], #16		/* get 1 input block  */
+	ld1		{v5.16b}, [x20], #16		/* get 1 input block  */
 	eor		v1.16b, v6.16b, v1.16b
 	eor		v2.16b, v7.16b, v2.16b
 	eor		v3.16b, v5.16b, v3.16b
-	st1		{v0.16b-v3.16b}, [x0], #64
+	st1		{v0.16b-v3.16b}, [x19], #64
 	add		x6, x6, #4
 	rev		x7, x6
 	ins		v4.d[1], x7
-	cbz		w4, .Lctrout
+	cbz		w23, .Lctrout
+	st1		{v4.16b}, [x24]		/* return next CTR value */
+	yield_neon	.Lctrrestart, w23, AES_YIELD_ORDER, 4, .LctrloopNx
 	b		.LctrloopNx
 .Lctr1x:
-	adds		w4, w4, #4
+	adds		w23, w23, #4
 	beq		.Lctrout
 .Lctrloop:
 	mov		v0.16b, v4.16b
-	encrypt_block	v0, w3, x2, x8, w7
+	encrypt_block	v0, w22, x21, x8, w7
 
 	adds		x6, x6, #1		/* increment BE ctr */
 	rev		x7, x6
@@ -226,22 +303,25 @@ AES_ENTRY(aes_ctr_encrypt)
 	bcs		.Lctrcarry		/* overflow? */
 
 .Lctrcarrydone:
-	subs		w4, w4, #1
+	subs		w23, w23, #1
 	bmi		.Lctrtailblock		/* blocks <0 means tail block */
-	ld1		{v3.16b}, [x1], #16
+	ld1		{v3.16b}, [x20], #16
 	eor		v3.16b, v0.16b, v3.16b
-	st1		{v3.16b}, [x0], #16
+	st1		{v3.16b}, [x19], #16
 	bne		.Lctrloop
 
 .Lctrout:
-	st1		{v4.16b}, [x5]		/* return next CTR value */
-	ldp		x29, x30, [sp], #16
+	st1		{v4.16b}, [x24]		/* return next CTR value */
+.Lctrret:
+	ldp		x19, x20, [sp, #16]
+	ldp		x21, x22, [sp, #32]
+	ldp		x23, x24, [sp, #48]
+	ldp		x29, x30, [sp], #64
 	ret
 
 .Lctrtailblock:
-	st1		{v0.16b}, [x0]
-	ldp		x29, x30, [sp], #16
-	ret
+	st1		{v0.16b}, [x19]
+	b		.Lctrret
 
 .Lctrcarry:
 	umov		x7, v4.d[0]		/* load upper word of ctr  */
@@ -274,10 +354,20 @@ CPU_LE(	.quad		1, 0x87		)
 CPU_BE(	.quad		0x87, 1		)
 
 AES_ENTRY(aes_xts_encrypt)
-	stp		x29, x30, [sp, #-16]!
+	stp		x29, x30, [sp, #-64]!
 	mov		x29, sp
-
-	ld1		{v4.16b}, [x6]
+	stp		x19, x20, [sp, #16]
+	stp		x21, x22, [sp, #32]
+	stp		x23, x24, [sp, #48]
+
+	mov		x19, x0
+	mov		x20, x1
+	mov		x21, x2
+	mov		x22, x3
+	mov		x23, x4
+	mov		x24, x6
+
+	ld1		{v4.16b}, [x24]
 	cbz		w7, .Lxtsencnotfirst
 
 	enc_prepare	w3, x5, x8
@@ -286,15 +376,17 @@ AES_ENTRY(aes_xts_encrypt)
 	ldr		q7, .Lxts_mul_x
 	b		.LxtsencNx
 
+.Lxtsencrestart:
+	ld1		{v4.16b}, [x24]
 .Lxtsencnotfirst:
-	enc_prepare	w3, x2, x8
+	enc_prepare	w22, x21, x8
 .LxtsencloopNx:
 	ldr		q7, .Lxts_mul_x
 	next_tweak	v4, v4, v7, v8
 .LxtsencNx:
-	subs		w4, w4, #4
+	subs		w23, w23, #4
 	bmi		.Lxtsenc1x
-	ld1		{v0.16b-v3.16b}, [x1], #64	/* get 4 pt blocks */
+	ld1		{v0.16b-v3.16b}, [x20], #64	/* get 4 pt blocks */
 	next_tweak	v5, v4, v7, v8
 	eor		v0.16b, v0.16b, v4.16b
 	next_tweak	v6, v5, v7, v8
@@ -307,35 +399,50 @@ AES_ENTRY(aes_xts_encrypt)
 	eor		v0.16b, v0.16b, v4.16b
 	eor		v1.16b, v1.16b, v5.16b
 	eor		v2.16b, v2.16b, v6.16b
-	st1		{v0.16b-v3.16b}, [x0], #64
+	st1		{v0.16b-v3.16b}, [x19], #64
 	mov		v4.16b, v7.16b
-	cbz		w4, .Lxtsencout
+	cbz		w23, .Lxtsencout
+	st1		{v4.16b}, [x24]
+	yield_neon	.Lxtsencrestart, w23, AES_YIELD_ORDER, 4, .LxtsencloopNx
 	b		.LxtsencloopNx
 .Lxtsenc1x:
-	adds		w4, w4, #4
+	adds		w23, w23, #4
 	beq		.Lxtsencout
 .Lxtsencloop:
-	ld1		{v1.16b}, [x1], #16
+	ld1		{v1.16b}, [x20], #16
 	eor		v0.16b, v1.16b, v4.16b
-	encrypt_block	v0, w3, x2, x8, w7
+	encrypt_block	v0, w22, x21, x8, w7
 	eor		v0.16b, v0.16b, v4.16b
-	st1		{v0.16b}, [x0], #16
-	subs		w4, w4, #1
+	st1		{v0.16b}, [x19], #16
+	subs		w23, w23, #1
 	beq		.Lxtsencout
 	next_tweak	v4, v4, v7, v8
 	b		.Lxtsencloop
 .Lxtsencout:
-	st1		{v4.16b}, [x6]
-	ldp		x29, x30, [sp], #16
+	st1		{v4.16b}, [x24]
+	ldp		x19, x20, [sp, #16]
+	ldp		x21, x22, [sp, #32]
+	ldp		x23, x24, [sp, #48]
+	ldp		x29, x30, [sp], #64
 	ret
 AES_ENDPROC(aes_xts_encrypt)
 
 
 AES_ENTRY(aes_xts_decrypt)
-	stp		x29, x30, [sp, #-16]!
+	stp		x29, x30, [sp, #-64]!
 	mov		x29, sp
-
-	ld1		{v4.16b}, [x6]
+	stp		x19, x20, [sp, #16]
+	stp		x21, x22, [sp, #32]
+	stp		x23, x24, [sp, #48]
+
+	mov		x19, x0
+	mov		x20, x1
+	mov		x21, x2
+	mov		x22, x3
+	mov		x23, x4
+	mov		x24, x6
+
+	ld1		{v4.16b}, [x24]
 	cbz		w7, .Lxtsdecnotfirst
 
 	enc_prepare	w3, x5, x8
@@ -344,15 +451,17 @@ AES_ENTRY(aes_xts_decrypt)
 	ldr		q7, .Lxts_mul_x
 	b		.LxtsdecNx
 
+.Lxtsdecrestart:
+	ld1		{v4.16b}, [x24]
 .Lxtsdecnotfirst:
-	dec_prepare	w3, x2, x8
+	dec_prepare	w22, x21, x8
 .LxtsdecloopNx:
 	ldr		q7, .Lxts_mul_x
 	next_tweak	v4, v4, v7, v8
 .LxtsdecNx:
-	subs		w4, w4, #4
+	subs		w23, w23, #4
 	bmi		.Lxtsdec1x
-	ld1		{v0.16b-v3.16b}, [x1], #64	/* get 4 ct blocks */
+	ld1		{v0.16b-v3.16b}, [x20], #64	/* get 4 ct blocks */
 	next_tweak	v5, v4, v7, v8
 	eor		v0.16b, v0.16b, v4.16b
 	next_tweak	v6, v5, v7, v8
@@ -365,26 +474,31 @@ AES_ENTRY(aes_xts_decrypt)
 	eor		v0.16b, v0.16b, v4.16b
 	eor		v1.16b, v1.16b, v5.16b
 	eor		v2.16b, v2.16b, v6.16b
-	st1		{v0.16b-v3.16b}, [x0], #64
+	st1		{v0.16b-v3.16b}, [x19], #64
 	mov		v4.16b, v7.16b
-	cbz		w4, .Lxtsdecout
+	cbz		w23, .Lxtsdecout
+	st1		{v4.16b}, [x24]
+	yield_neon	.Lxtsdecrestart, w23, AES_YIELD_ORDER, 4, .LxtsdecloopNx
 	b		.LxtsdecloopNx
 .Lxtsdec1x:
-	adds		w4, w4, #4
+	adds		w23, w23, #4
 	beq		.Lxtsdecout
 .Lxtsdecloop:
-	ld1		{v1.16b}, [x1], #16
+	ld1		{v1.16b}, [x20], #16
 	eor		v0.16b, v1.16b, v4.16b
-	decrypt_block	v0, w3, x2, x8, w7
+	decrypt_block	v0, w22, x21, x8, w7
 	eor		v0.16b, v0.16b, v4.16b
-	st1		{v0.16b}, [x0], #16
-	subs		w4, w4, #1
+	st1		{v0.16b}, [x19], #16
+	subs		w23, w23, #1
 	beq		.Lxtsdecout
 	next_tweak	v4, v4, v7, v8
 	b		.Lxtsdecloop
 .Lxtsdecout:
-	st1		{v4.16b}, [x6]
-	ldp		x29, x30, [sp], #16
+	st1		{v4.16b}, [x24]
+	ldp		x19, x20, [sp, #16]
+	ldp		x21, x22, [sp, #32]
+	ldp		x23, x24, [sp, #48]
+	ldp		x29, x30, [sp], #64
 	ret
 AES_ENDPROC(aes_xts_decrypt)
 
@@ -393,43 +507,68 @@ AES_ENDPROC(aes_xts_decrypt)
 	 *		  int blocks, u8 dg[], int enc_before, int enc_after)
 	 */
 AES_ENTRY(aes_mac_update)
-	ld1		{v0.16b}, [x4]			/* get dg */
+	stp		x29, x30, [sp, #-64]!
+	mov		x29, sp
+	stp		x19, x20, [sp, #16]
+	stp		x21, x22, [sp, #32]
+	stp		x23, x24, [sp, #48]
+
+	mov		x19, x0
+	mov		x20, x1
+	mov		x21, x2
+	mov		x22, x3
+	mov		x23, x4
+	mov		x24, x6
+
+	ld1		{v0.16b}, [x23]			/* get dg */
 	enc_prepare	w2, x1, x7
 	cbz		w5, .Lmacloop4x
 
 	encrypt_block	v0, w2, x1, x7, w8
 
 .Lmacloop4x:
-	subs		w3, w3, #4
+	subs		w22, w22, #4
 	bmi		.Lmac1x
-	ld1		{v1.16b-v4.16b}, [x0], #64	/* get next pt block */
+	ld1		{v1.16b-v4.16b}, [x19], #64	/* get next pt block */
 	eor		v0.16b, v0.16b, v1.16b		/* ..and xor with dg */
-	encrypt_block	v0, w2, x1, x7, w8
+	encrypt_block	v0, w21, x20, x7, w8
 	eor		v0.16b, v0.16b, v2.16b
-	encrypt_block	v0, w2, x1, x7, w8
+	encrypt_block	v0, w21, x20, x7, w8
 	eor		v0.16b, v0.16b, v3.16b
-	encrypt_block	v0, w2, x1, x7, w8
+	encrypt_block	v0, w21, x20, x7, w8
 	eor		v0.16b, v0.16b, v4.16b
-	cmp		w3, wzr
-	csinv		x5, x6, xzr, eq
+	cmp		w22, wzr
+	csinv		x5, x24, xzr, eq
 	cbz		w5, .Lmacout
-	encrypt_block	v0, w2, x1, x7, w8
+	encrypt_block	v0, w21, x20, x7, w8
+	st1		{v0.16b}, [x23]			/* return dg */
+	yield_neon	.Lmacrestart, w22, AES_YIELD_ORDER, 4, .Lmacloop4x
 	b		.Lmacloop4x
 .Lmac1x:
-	add		w3, w3, #4
+	add		w22, w22, #4
 .Lmacloop:
-	cbz		w3, .Lmacout
-	ld1		{v1.16b}, [x0], #16		/* get next pt block */
+	cbz		w22, .Lmacout
+	ld1		{v1.16b}, [x19], #16		/* get next pt block */
 	eor		v0.16b, v0.16b, v1.16b		/* ..and xor with dg */
 
-	subs		w3, w3, #1
-	csinv		x5, x6, xzr, eq
+	subs		w22, w22, #1
+	csinv		x5, x24, xzr, eq
 	cbz		w5, .Lmacout
 
-	encrypt_block	v0, w2, x1, x7, w8
+.Lmacenc:
+	encrypt_block	v0, w21, x20, x7, w8
 	b		.Lmacloop
 
 .Lmacout:
-	st1		{v0.16b}, [x4]			/* return dg */
+	st1		{v0.16b}, [x23]			/* return dg */
+	ldp		x19, x20, [sp, #16]
+	ldp		x21, x22, [sp, #32]
+	ldp		x23, x24, [sp, #48]
+	ldp		x29, x30, [sp], #64
 	ret
+
+.Lmacrestart:
+	ld1		{v0.16b}, [x23]			/* get dg */
+	enc_prepare	w21, x20, x0
+	b		.Lmacloop4x
 AES_ENDPROC(aes_mac_update)
diff --git a/arch/arm64/crypto/aes-neon.S b/arch/arm64/crypto/aes-neon.S
index f1e3aa2732f9..dab7be7d3628 100644
--- a/arch/arm64/crypto/aes-neon.S
+++ b/arch/arm64/crypto/aes-neon.S
@@ -14,6 +14,8 @@
 #define AES_ENTRY(func)		ENTRY(neon_ ## func)
 #define AES_ENDPROC(func)	ENDPROC(neon_ ## func)
 
+#define AES_YIELD_ORDER		0
+
 	/* multiply by polynomial 'x' in GF(2^8) */
 	.macro		mul_by_x, out, in, temp, const
 	sshr		\temp, \in, #7
-- 
2.11.0

