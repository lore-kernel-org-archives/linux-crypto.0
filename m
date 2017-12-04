From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 07/19] crypto: arm64/aes-blk - remove configurable interleave
Date: Mon,  4 Dec 2017 12:26:33 +0000
Message-ID: <20171204122645.31535-8-ard.biesheuvel@linaro.org>
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

The AES block mode implementation using Crypto Extensions or plain NEON
was written before real hardware existed, and so its interleave factor
was made build time configurable (as well as an option to instantiate
all interleaved sequences inline rather than as subroutines)

We ended up using INTERLEAVE=4 with inlining disabled for both flavors
of the core AES routines, so let's stick with that, and remove the option
to configure this at build time. This makes the code easier to modify,
which is nice now that we're adding yield support.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/Makefile    |   3 -
 arch/arm64/crypto/aes-modes.S | 237 ++++----------------
 2 files changed, 40 insertions(+), 200 deletions(-)

diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
index b5edc5918c28..aaf4e9afd750 100644
--- a/arch/arm64/crypto/Makefile
+++ b/arch/arm64/crypto/Makefile
@@ -50,9 +50,6 @@ aes-arm64-y := aes-cipher-core.o aes-cipher-glue.o
 obj-$(CONFIG_CRYPTO_AES_ARM64_BS) += aes-neon-bs.o
 aes-neon-bs-y := aes-neonbs-core.o aes-neonbs-glue.o
 
-AFLAGS_aes-ce.o		:= -DINTERLEAVE=4
-AFLAGS_aes-neon.o	:= -DINTERLEAVE=4
-
 CFLAGS_aes-glue-ce.o	:= -DUSE_V8_CRYPTO_EXTENSIONS
 
 $(obj)/aes-glue-%.o: $(src)/aes-glue.c FORCE
diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
index 65b273667b34..27a235b2ddee 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -13,44 +13,6 @@
 	.text
 	.align		4
 
-/*
- * There are several ways to instantiate this code:
- * - no interleave, all inline
- * - 2-way interleave, 2x calls out of line (-DINTERLEAVE=2)
- * - 2-way interleave, all inline (-DINTERLEAVE=2 -DINTERLEAVE_INLINE)
- * - 4-way interleave, 4x calls out of line (-DINTERLEAVE=4)
- * - 4-way interleave, all inline (-DINTERLEAVE=4 -DINTERLEAVE_INLINE)
- *
- * Macros imported by this code:
- * - enc_prepare	- setup NEON registers for encryption
- * - dec_prepare	- setup NEON registers for decryption
- * - enc_switch_key	- change to new key after having prepared for encryption
- * - encrypt_block	- encrypt a single block
- * - decrypt block	- decrypt a single block
- * - encrypt_block2x	- encrypt 2 blocks in parallel (if INTERLEAVE == 2)
- * - decrypt_block2x	- decrypt 2 blocks in parallel (if INTERLEAVE == 2)
- * - encrypt_block4x	- encrypt 4 blocks in parallel (if INTERLEAVE == 4)
- * - decrypt_block4x	- decrypt 4 blocks in parallel (if INTERLEAVE == 4)
- */
-
-#if defined(INTERLEAVE) && !defined(INTERLEAVE_INLINE)
-#define FRAME_PUSH	stp x29, x30, [sp,#-16]! ; mov x29, sp
-#define FRAME_POP	ldp x29, x30, [sp],#16
-
-#if INTERLEAVE == 2
-
-aes_encrypt_block2x:
-	encrypt_block2x	v0, v1, w3, x2, x8, w7
-	ret
-ENDPROC(aes_encrypt_block2x)
-
-aes_decrypt_block2x:
-	decrypt_block2x	v0, v1, w3, x2, x8, w7
-	ret
-ENDPROC(aes_decrypt_block2x)
-
-#elif INTERLEAVE == 4
-
 aes_encrypt_block4x:
 	encrypt_block4x	v0, v1, v2, v3, w3, x2, x8, w7
 	ret
@@ -61,48 +23,6 @@ aes_decrypt_block4x:
 	ret
 ENDPROC(aes_decrypt_block4x)
 
-#else
-#error INTERLEAVE should equal 2 or 4
-#endif
-
-	.macro		do_encrypt_block2x
-	bl		aes_encrypt_block2x
-	.endm
-
-	.macro		do_decrypt_block2x
-	bl		aes_decrypt_block2x
-	.endm
-
-	.macro		do_encrypt_block4x
-	bl		aes_encrypt_block4x
-	.endm
-
-	.macro		do_decrypt_block4x
-	bl		aes_decrypt_block4x
-	.endm
-
-#else
-#define FRAME_PUSH
-#define FRAME_POP
-
-	.macro		do_encrypt_block2x
-	encrypt_block2x	v0, v1, w3, x2, x8, w7
-	.endm
-
-	.macro		do_decrypt_block2x
-	decrypt_block2x	v0, v1, w3, x2, x8, w7
-	.endm
-
-	.macro		do_encrypt_block4x
-	encrypt_block4x	v0, v1, v2, v3, w3, x2, x8, w7
-	.endm
-
-	.macro		do_decrypt_block4x
-	decrypt_block4x	v0, v1, v2, v3, w3, x2, x8, w7
-	.endm
-
-#endif
-
 	/*
 	 * aes_ecb_encrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
 	 *		   int blocks)
@@ -111,28 +31,21 @@ ENDPROC(aes_decrypt_block4x)
 	 */
 
 AES_ENTRY(aes_ecb_encrypt)
-	FRAME_PUSH
+	stp		x29, x30, [sp, #-16]!
+	mov		x29, sp
 
 	enc_prepare	w3, x2, x5
 
 .LecbencloopNx:
-#if INTERLEAVE >= 2
-	subs		w4, w4, #INTERLEAVE
+	subs		w4, w4, #4
 	bmi		.Lecbenc1x
-#if INTERLEAVE == 2
-	ld1		{v0.16b-v1.16b}, [x1], #32	/* get 2 pt blocks */
-	do_encrypt_block2x
-	st1		{v0.16b-v1.16b}, [x0], #32
-#else
 	ld1		{v0.16b-v3.16b}, [x1], #64	/* get 4 pt blocks */
-	do_encrypt_block4x
+	bl		aes_encrypt_block4x
 	st1		{v0.16b-v3.16b}, [x0], #64
-#endif
 	b		.LecbencloopNx
 .Lecbenc1x:
-	adds		w4, w4, #INTERLEAVE
+	adds		w4, w4, #4
 	beq		.Lecbencout
-#endif
 .Lecbencloop:
 	ld1		{v0.16b}, [x1], #16		/* get next pt block */
 	encrypt_block	v0, w3, x2, x5, w6
@@ -140,34 +53,27 @@ AES_ENTRY(aes_ecb_encrypt)
 	subs		w4, w4, #1
 	bne		.Lecbencloop
 .Lecbencout:
-	FRAME_POP
+	ldp		x29, x30, [sp], #16
 	ret
 AES_ENDPROC(aes_ecb_encrypt)
 
 
 AES_ENTRY(aes_ecb_decrypt)
-	FRAME_PUSH
+	stp		x29, x30, [sp, #-16]!
+	mov		x29, sp
 
 	dec_prepare	w3, x2, x5
 
 .LecbdecloopNx:
-#if INTERLEAVE >= 2
-	subs		w4, w4, #INTERLEAVE
+	subs		w4, w4, #4
 	bmi		.Lecbdec1x
-#if INTERLEAVE == 2
-	ld1		{v0.16b-v1.16b}, [x1], #32	/* get 2 ct blocks */
-	do_decrypt_block2x
-	st1		{v0.16b-v1.16b}, [x0], #32
-#else
 	ld1		{v0.16b-v3.16b}, [x1], #64	/* get 4 ct blocks */
-	do_decrypt_block4x
+	bl		aes_decrypt_block4x
 	st1		{v0.16b-v3.16b}, [x0], #64
-#endif
 	b		.LecbdecloopNx
 .Lecbdec1x:
-	adds		w4, w4, #INTERLEAVE
+	adds		w4, w4, #4
 	beq		.Lecbdecout
-#endif
 .Lecbdecloop:
 	ld1		{v0.16b}, [x1], #16		/* get next ct block */
 	decrypt_block	v0, w3, x2, x5, w6
@@ -175,7 +81,7 @@ AES_ENTRY(aes_ecb_decrypt)
 	subs		w4, w4, #1
 	bne		.Lecbdecloop
 .Lecbdecout:
-	FRAME_POP
+	ldp		x29, x30, [sp], #16
 	ret
 AES_ENDPROC(aes_ecb_decrypt)
 
@@ -204,30 +110,20 @@ AES_ENDPROC(aes_cbc_encrypt)
 
 
 AES_ENTRY(aes_cbc_decrypt)
-	FRAME_PUSH
+	stp		x29, x30, [sp, #-16]!
+	mov		x29, sp
 
 	ld1		{v7.16b}, [x5]			/* get iv */
 	dec_prepare	w3, x2, x6
 
 .LcbcdecloopNx:
-#if INTERLEAVE >= 2
-	subs		w4, w4, #INTERLEAVE
+	subs		w4, w4, #4
 	bmi		.Lcbcdec1x
-#if INTERLEAVE == 2
-	ld1		{v0.16b-v1.16b}, [x1], #32	/* get 2 ct blocks */
-	mov		v2.16b, v0.16b
-	mov		v3.16b, v1.16b
-	do_decrypt_block2x
-	eor		v0.16b, v0.16b, v7.16b
-	eor		v1.16b, v1.16b, v2.16b
-	mov		v7.16b, v3.16b
-	st1		{v0.16b-v1.16b}, [x0], #32
-#else
 	ld1		{v0.16b-v3.16b}, [x1], #64	/* get 4 ct blocks */
 	mov		v4.16b, v0.16b
 	mov		v5.16b, v1.16b
 	mov		v6.16b, v2.16b
-	do_decrypt_block4x
+	bl		aes_decrypt_block4x
 	sub		x1, x1, #16
 	eor		v0.16b, v0.16b, v7.16b
 	eor		v1.16b, v1.16b, v4.16b
@@ -235,12 +131,10 @@ AES_ENTRY(aes_cbc_decrypt)
 	eor		v2.16b, v2.16b, v5.16b
 	eor		v3.16b, v3.16b, v6.16b
 	st1		{v0.16b-v3.16b}, [x0], #64
-#endif
 	b		.LcbcdecloopNx
 .Lcbcdec1x:
-	adds		w4, w4, #INTERLEAVE
+	adds		w4, w4, #4
 	beq		.Lcbcdecout
-#endif
 .Lcbcdecloop:
 	ld1		{v1.16b}, [x1], #16		/* get next ct block */
 	mov		v0.16b, v1.16b			/* ...and copy to v0 */
@@ -251,8 +145,8 @@ AES_ENTRY(aes_cbc_decrypt)
 	subs		w4, w4, #1
 	bne		.Lcbcdecloop
 .Lcbcdecout:
-	FRAME_POP
 	st1		{v7.16b}, [x5]			/* return iv */
+	ldp		x29, x30, [sp], #16
 	ret
 AES_ENDPROC(aes_cbc_decrypt)
 
@@ -263,34 +157,19 @@ AES_ENDPROC(aes_cbc_decrypt)
 	 */
 
 AES_ENTRY(aes_ctr_encrypt)
-	FRAME_PUSH
+	stp		x29, x30, [sp, #-16]!
+	mov		x29, sp
 
 	enc_prepare	w3, x2, x6
 	ld1		{v4.16b}, [x5]
 
 	umov		x6, v4.d[1]		/* keep swabbed ctr in reg */
 	rev		x6, x6
-#if INTERLEAVE >= 2
 	cmn		w6, w4			/* 32 bit overflow? */
 	bcs		.Lctrloop
 .LctrloopNx:
-	subs		w4, w4, #INTERLEAVE
+	subs		w4, w4, #4
 	bmi		.Lctr1x
-#if INTERLEAVE == 2
-	mov		v0.8b, v4.8b
-	mov		v1.8b, v4.8b
-	rev		x7, x6
-	add		x6, x6, #1
-	ins		v0.d[1], x7
-	rev		x7, x6
-	add		x6, x6, #1
-	ins		v1.d[1], x7
-	ld1		{v2.16b-v3.16b}, [x1], #32	/* get 2 input blocks */
-	do_encrypt_block2x
-	eor		v0.16b, v0.16b, v2.16b
-	eor		v1.16b, v1.16b, v3.16b
-	st1		{v0.16b-v1.16b}, [x0], #32
-#else
 	ldr		q8, =0x30000000200000001	/* addends 1,2,3[,0] */
 	dup		v7.4s, w6
 	mov		v0.16b, v4.16b
@@ -303,23 +182,21 @@ AES_ENTRY(aes_ctr_encrypt)
 	mov		v2.s[3], v8.s[1]
 	mov		v3.s[3], v8.s[2]
 	ld1		{v5.16b-v7.16b}, [x1], #48	/* get 3 input blocks */
-	do_encrypt_block4x
+	bl		aes_encrypt_block4x
 	eor		v0.16b, v5.16b, v0.16b
 	ld1		{v5.16b}, [x1], #16		/* get 1 input block  */
 	eor		v1.16b, v6.16b, v1.16b
 	eor		v2.16b, v7.16b, v2.16b
 	eor		v3.16b, v5.16b, v3.16b
 	st1		{v0.16b-v3.16b}, [x0], #64
-	add		x6, x6, #INTERLEAVE
-#endif
+	add		x6, x6, #4
 	rev		x7, x6
 	ins		v4.d[1], x7
 	cbz		w4, .Lctrout
 	b		.LctrloopNx
 .Lctr1x:
-	adds		w4, w4, #INTERLEAVE
+	adds		w4, w4, #4
 	beq		.Lctrout
-#endif
 .Lctrloop:
 	mov		v0.16b, v4.16b
 	encrypt_block	v0, w3, x2, x8, w7
@@ -339,12 +216,12 @@ AES_ENTRY(aes_ctr_encrypt)
 
 .Lctrout:
 	st1		{v4.16b}, [x5]		/* return next CTR value */
-	FRAME_POP
+	ldp		x29, x30, [sp], #16
 	ret
 
 .Lctrtailblock:
 	st1		{v0.16b}, [x0]
-	FRAME_POP
+	ldp		x29, x30, [sp], #16
 	ret
 
 .Lctrcarry:
@@ -378,7 +255,9 @@ CPU_LE(	.quad		1, 0x87		)
 CPU_BE(	.quad		0x87, 1		)
 
 AES_ENTRY(aes_xts_encrypt)
-	FRAME_PUSH
+	stp		x29, x30, [sp, #-16]!
+	mov		x29, sp
+
 	ld1		{v4.16b}, [x6]
 	cbz		w7, .Lxtsencnotfirst
 
@@ -394,25 +273,8 @@ AES_ENTRY(aes_xts_encrypt)
 	ldr		q7, .Lxts_mul_x
 	next_tweak	v4, v4, v7, v8
 .LxtsencNx:
-#if INTERLEAVE >= 2
-	subs		w4, w4, #INTERLEAVE
+	subs		w4, w4, #4
 	bmi		.Lxtsenc1x
-#if INTERLEAVE == 2
-	ld1		{v0.16b-v1.16b}, [x1], #32	/* get 2 pt blocks */
-	next_tweak	v5, v4, v7, v8
-	eor		v0.16b, v0.16b, v4.16b
-	eor		v1.16b, v1.16b, v5.16b
-	do_encrypt_block2x
-	eor		v0.16b, v0.16b, v4.16b
-	eor		v1.16b, v1.16b, v5.16b
-	st1		{v0.16b-v1.16b}, [x0], #32
-	cbz		w4, .LxtsencoutNx
-	next_tweak	v4, v5, v7, v8
-	b		.LxtsencNx
-.LxtsencoutNx:
-	mov		v4.16b, v5.16b
-	b		.Lxtsencout
-#else
 	ld1		{v0.16b-v3.16b}, [x1], #64	/* get 4 pt blocks */
 	next_tweak	v5, v4, v7, v8
 	eor		v0.16b, v0.16b, v4.16b
@@ -421,7 +283,7 @@ AES_ENTRY(aes_xts_encrypt)
 	eor		v2.16b, v2.16b, v6.16b
 	next_tweak	v7, v6, v7, v8
 	eor		v3.16b, v3.16b, v7.16b
-	do_encrypt_block4x
+	bl		aes_encrypt_block4x
 	eor		v3.16b, v3.16b, v7.16b
 	eor		v0.16b, v0.16b, v4.16b
 	eor		v1.16b, v1.16b, v5.16b
@@ -430,11 +292,9 @@ AES_ENTRY(aes_xts_encrypt)
 	mov		v4.16b, v7.16b
 	cbz		w4, .Lxtsencout
 	b		.LxtsencloopNx
-#endif
 .Lxtsenc1x:
-	adds		w4, w4, #INTERLEAVE
+	adds		w4, w4, #4
 	beq		.Lxtsencout
-#endif
 .Lxtsencloop:
 	ld1		{v1.16b}, [x1], #16
 	eor		v0.16b, v1.16b, v4.16b
@@ -447,13 +307,15 @@ AES_ENTRY(aes_xts_encrypt)
 	b		.Lxtsencloop
 .Lxtsencout:
 	st1		{v4.16b}, [x6]
-	FRAME_POP
+	ldp		x29, x30, [sp], #16
 	ret
 AES_ENDPROC(aes_xts_encrypt)
 
 
 AES_ENTRY(aes_xts_decrypt)
-	FRAME_PUSH
+	stp		x29, x30, [sp, #-16]!
+	mov		x29, sp
+
 	ld1		{v4.16b}, [x6]
 	cbz		w7, .Lxtsdecnotfirst
 
@@ -469,25 +331,8 @@ AES_ENTRY(aes_xts_decrypt)
 	ldr		q7, .Lxts_mul_x
 	next_tweak	v4, v4, v7, v8
 .LxtsdecNx:
-#if INTERLEAVE >= 2
-	subs		w4, w4, #INTERLEAVE
+	subs		w4, w4, #4
 	bmi		.Lxtsdec1x
-#if INTERLEAVE == 2
-	ld1		{v0.16b-v1.16b}, [x1], #32	/* get 2 ct blocks */
-	next_tweak	v5, v4, v7, v8
-	eor		v0.16b, v0.16b, v4.16b
-	eor		v1.16b, v1.16b, v5.16b
-	do_decrypt_block2x
-	eor		v0.16b, v0.16b, v4.16b
-	eor		v1.16b, v1.16b, v5.16b
-	st1		{v0.16b-v1.16b}, [x0], #32
-	cbz		w4, .LxtsdecoutNx
-	next_tweak	v4, v5, v7, v8
-	b		.LxtsdecNx
-.LxtsdecoutNx:
-	mov		v4.16b, v5.16b
-	b		.Lxtsdecout
-#else
 	ld1		{v0.16b-v3.16b}, [x1], #64	/* get 4 ct blocks */
 	next_tweak	v5, v4, v7, v8
 	eor		v0.16b, v0.16b, v4.16b
@@ -496,7 +341,7 @@ AES_ENTRY(aes_xts_decrypt)
 	eor		v2.16b, v2.16b, v6.16b
 	next_tweak	v7, v6, v7, v8
 	eor		v3.16b, v3.16b, v7.16b
-	do_decrypt_block4x
+	bl		aes_decrypt_block4x
 	eor		v3.16b, v3.16b, v7.16b
 	eor		v0.16b, v0.16b, v4.16b
 	eor		v1.16b, v1.16b, v5.16b
@@ -505,11 +350,9 @@ AES_ENTRY(aes_xts_decrypt)
 	mov		v4.16b, v7.16b
 	cbz		w4, .Lxtsdecout
 	b		.LxtsdecloopNx
-#endif
 .Lxtsdec1x:
-	adds		w4, w4, #INTERLEAVE
+	adds		w4, w4, #4
 	beq		.Lxtsdecout
-#endif
 .Lxtsdecloop:
 	ld1		{v1.16b}, [x1], #16
 	eor		v0.16b, v1.16b, v4.16b
@@ -522,7 +365,7 @@ AES_ENTRY(aes_xts_decrypt)
 	b		.Lxtsdecloop
 .Lxtsdecout:
 	st1		{v4.16b}, [x6]
-	FRAME_POP
+	ldp		x29, x30, [sp], #16
 	ret
 AES_ENDPROC(aes_xts_decrypt)
 
-- 
2.11.0

