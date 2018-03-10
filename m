From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 15/23] crypto: arm64/aes-blk - yield NEON after every block
 of input
Date: Sat, 10 Mar 2018 15:22:00 +0000
Message-ID: <20180310152208.10369-16-ard.biesheuvel@linaro.org>
References: <20180310152208.10369-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Mark Rutland <mark.rutland@arm.com>, herbert@gondor.apana.org.au,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Will Deacon <will.deacon@arm.com>,
 Russell King - ARM Linux <linux@armlinux.org.uk>,
 Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-rt-users@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180310152208.10369-1-ard.biesheuvel@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

Avoid excessive scheduling delays under a preemptible kernel by
conditionally yielding the NEON after every block of input.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-ce.S    |  15 +-
 arch/arm64/crypto/aes-modes.S | 331 ++++++++++++--------
 2 files changed, 216 insertions(+), 130 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce.S b/arch/arm64/crypto/aes-ce.S
index 50330f5c3adc..623e74ed1c67 100644
--- a/arch/arm64/crypto/aes-ce.S
+++ b/arch/arm64/crypto/aes-ce.S
@@ -30,18 +30,21 @@
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
index a68412e1e3a4..483a7130cf0e 100644
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
 
@@ -31,57 +31,71 @@ ENDPROC(aes_decrypt_block4x)
 	 */
 
 AES_ENTRY(aes_ecb_encrypt)
-	stp		x29, x30, [sp, #-16]!
-	mov		x29, sp
+	frame_push	5
 
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
+	cond_yield_neon	.Lecbencrestart
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
+	frame_pop
 	ret
 AES_ENDPROC(aes_ecb_encrypt)
 
 
 AES_ENTRY(aes_ecb_decrypt)
-	stp		x29, x30, [sp, #-16]!
-	mov		x29, sp
+	frame_push	5
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
+	cond_yield_neon	.Lecbdecrestart
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
+	frame_pop
 	ret
 AES_ENDPROC(aes_ecb_decrypt)
 
@@ -94,78 +108,100 @@ AES_ENDPROC(aes_ecb_decrypt)
 	 */
 
 AES_ENTRY(aes_cbc_encrypt)
-	ld1		{v4.16b}, [x5]			/* get iv */
-	enc_prepare	w3, x2, x6
+	frame_push	6
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
+	cond_yield_neon	.Lcbcencrestart
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
+	frame_pop
 	ret
 AES_ENDPROC(aes_cbc_encrypt)
 
 
 AES_ENTRY(aes_cbc_decrypt)
-	stp		x29, x30, [sp, #-16]!
-	mov		x29, sp
+	frame_push	6
+
+	mov		x19, x0
+	mov		x20, x1
+	mov		x21, x2
+	mov		x22, x3
+	mov		x23, x4
+	mov		x24, x5
 
-	ld1		{v7.16b}, [x5]			/* get iv */
-	dec_prepare	w3, x2, x6
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
+	cond_yield_neon	.Lcbcdecrestart
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
+	frame_pop
 	ret
 AES_ENDPROC(aes_cbc_decrypt)
 
@@ -176,19 +212,26 @@ AES_ENDPROC(aes_cbc_decrypt)
 	 */
 
 AES_ENTRY(aes_ctr_encrypt)
-	stp		x29, x30, [sp, #-16]!
-	mov		x29, sp
+	frame_push	6
 
-	enc_prepare	w3, x2, x6
-	ld1		{v4.16b}, [x5]
+	mov		x19, x0
+	mov		x20, x1
+	mov		x21, x2
+	mov		x22, x3
+	mov		x23, x4
+	mov		x24, x5
+
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
@@ -200,25 +243,27 @@ AES_ENTRY(aes_ctr_encrypt)
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
+	cond_yield_neon	.Lctrrestart
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
@@ -226,22 +271,22 @@ AES_ENTRY(aes_ctr_encrypt)
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
+	frame_pop
 	ret
 
 .Lctrtailblock:
-	st1		{v0.16b}, [x0]
-	ldp		x29, x30, [sp], #16
-	ret
+	st1		{v0.16b}, [x19]
+	b		.Lctrret
 
 .Lctrcarry:
 	umov		x7, v4.d[0]		/* load upper word of ctr  */
@@ -274,10 +319,16 @@ CPU_LE(	.quad		1, 0x87		)
 CPU_BE(	.quad		0x87, 1		)
 
 AES_ENTRY(aes_xts_encrypt)
-	stp		x29, x30, [sp, #-16]!
-	mov		x29, sp
+	frame_push	6
+
+	mov		x19, x0
+	mov		x20, x1
+	mov		x21, x2
+	mov		x22, x3
+	mov		x23, x4
+	mov		x24, x6
 
-	ld1		{v4.16b}, [x6]
+	ld1		{v4.16b}, [x24]
 	cbz		w7, .Lxtsencnotfirst
 
 	enc_prepare	w3, x5, x8
@@ -286,15 +337,17 @@ AES_ENTRY(aes_xts_encrypt)
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
@@ -307,35 +360,43 @@ AES_ENTRY(aes_xts_encrypt)
 	eor		v0.16b, v0.16b, v4.16b
 	eor		v1.16b, v1.16b, v5.16b
 	eor		v2.16b, v2.16b, v6.16b
-	st1		{v0.16b-v3.16b}, [x0], #64
+	st1		{v0.16b-v3.16b}, [x19], #64
 	mov		v4.16b, v7.16b
-	cbz		w4, .Lxtsencout
+	cbz		w23, .Lxtsencout
+	st1		{v4.16b}, [x24]
+	cond_yield_neon	.Lxtsencrestart
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
+	frame_pop
 	ret
 AES_ENDPROC(aes_xts_encrypt)
 
 
 AES_ENTRY(aes_xts_decrypt)
-	stp		x29, x30, [sp, #-16]!
-	mov		x29, sp
+	frame_push	6
 
-	ld1		{v4.16b}, [x6]
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
@@ -344,15 +405,17 @@ AES_ENTRY(aes_xts_decrypt)
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
@@ -365,26 +428,28 @@ AES_ENTRY(aes_xts_decrypt)
 	eor		v0.16b, v0.16b, v4.16b
 	eor		v1.16b, v1.16b, v5.16b
 	eor		v2.16b, v2.16b, v6.16b
-	st1		{v0.16b-v3.16b}, [x0], #64
+	st1		{v0.16b-v3.16b}, [x19], #64
 	mov		v4.16b, v7.16b
-	cbz		w4, .Lxtsdecout
+	cbz		w23, .Lxtsdecout
+	st1		{v4.16b}, [x24]
+	cond_yield_neon	.Lxtsdecrestart
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
+	frame_pop
 	ret
 AES_ENDPROC(aes_xts_decrypt)
 
@@ -393,43 +458,61 @@ AES_ENDPROC(aes_xts_decrypt)
 	 *		  int blocks, u8 dg[], int enc_before, int enc_after)
 	 */
 AES_ENTRY(aes_mac_update)
-	ld1		{v0.16b}, [x4]			/* get dg */
+	frame_push	6
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
+	cond_yield_neon	.Lmacrestart
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
+	frame_pop
 	ret
+
+.Lmacrestart:
+	ld1		{v0.16b}, [x23]			/* get dg */
+	enc_prepare	w21, x20, x0
+	b		.Lmacloop4x
 AES_ENDPROC(aes_mac_update)
-- 
2.15.1
