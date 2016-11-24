From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4/4] crypto: arm/crct10dif - port x86 SSE implementation to ARM
Date: Thu, 24 Nov 2016 15:43:21 +0000
Message-ID: <1480002201-1427-5-git-send-email-ard.biesheuvel@linaro.org>
References: <1480002201-1427-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: steve.capper@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 yuehaibing@huawei.com, hanjun.guo@linaro.org, dingtianhong@huawei.com,
 yangshengkai@huawei.com
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
 linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
 will.deacon@arm.com, linux@arm.linux.org.uk
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1480002201-1427-1-git-send-email-ard.biesheuvel@linaro.org>
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

This is a straight transliteration of the Intel algorithm implemented
using SSE and PCLMULQDQ instructions that resides under in the file
arch/x86/crypto/crct10dif-pcl-asm_64.S.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/Kconfig                        |   5 +
 arch/arm/crypto/Makefile                       |   2 +
 arch/{arm64 => arm}/crypto/crct10dif-ce-core.S | 457 +++++++++++---------
 arch/{arm64 => arm}/crypto/crct10dif-ce-glue.c |  23 +-
 4 files changed, 277 insertions(+), 210 deletions(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index 27ed1b1cd1d7..fce801fa52a1 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -120,4 +120,9 @@ config CRYPTO_GHASH_ARM_CE
 	  that uses the 64x64 to 128 bit polynomial multiplication (vmull.p64)
 	  that is part of the ARMv8 Crypto Extensions
 
+config CRYPTO_CRCT10DIF_ARM_CE
+	tristate "CRCT10DIF digest algorithm using PMULL instructions"
+	depends on KERNEL_MODE_NEON && CRC_T10DIF
+	select CRYPTO_HASH
+
 endif
diff --git a/arch/arm/crypto/Makefile b/arch/arm/crypto/Makefile
index fc5150702b64..fc77265014b7 100644
--- a/arch/arm/crypto/Makefile
+++ b/arch/arm/crypto/Makefile
@@ -13,6 +13,7 @@ ce-obj-$(CONFIG_CRYPTO_AES_ARM_CE) += aes-arm-ce.o
 ce-obj-$(CONFIG_CRYPTO_SHA1_ARM_CE) += sha1-arm-ce.o
 ce-obj-$(CONFIG_CRYPTO_SHA2_ARM_CE) += sha2-arm-ce.o
 ce-obj-$(CONFIG_CRYPTO_GHASH_ARM_CE) += ghash-arm-ce.o
+ce-obj-$(CONFIG_CRYPTO_CRCT10DIF_ARM_CE) += crct10dif-arm-ce.o
 
 ifneq ($(ce-obj-y)$(ce-obj-m),)
 ifeq ($(call as-instr,.fpu crypto-neon-fp-armv8,y,n),y)
@@ -36,6 +37,7 @@ sha1-arm-ce-y	:= sha1-ce-core.o sha1-ce-glue.o
 sha2-arm-ce-y	:= sha2-ce-core.o sha2-ce-glue.o
 aes-arm-ce-y	:= aes-ce-core.o aes-ce-glue.o
 ghash-arm-ce-y	:= ghash-ce-core.o ghash-ce-glue.o
+crct10dif-arm-ce-y	:= crct10dif-ce-core.o crct10dif-ce-glue.o
 
 quiet_cmd_perl = PERL    $@
       cmd_perl = $(PERL) $(<) > $(@)
diff --git a/arch/arm64/crypto/crct10dif-ce-core.S b/arch/arm/crypto/crct10dif-ce-core.S
similarity index 60%
copy from arch/arm64/crypto/crct10dif-ce-core.S
copy to arch/arm/crypto/crct10dif-ce-core.S
index 9148ebd3470a..30168b0f8581 100644
--- a/arch/arm64/crypto/crct10dif-ce-core.S
+++ b/arch/arm/crypto/crct10dif-ce-core.S
@@ -1,5 +1,5 @@
 //
-// Accelerated CRC-T10DIF using arm64 NEON and Crypto Extensions instructions
+// Accelerated CRC-T10DIF using ARM NEON and Crypto Extensions instructions
 //
 // Copyright (C) 2016 Linaro Ltd <ard.biesheuvel@linaro.org>
 //
@@ -71,20 +71,43 @@
 #include <linux/linkage.h>
 #include <asm/assembler.h>
 
-	.text
-	.cpu		generic+crypto
-
-	arg1_low32	.req	w0
-	arg2		.req	x1
-	arg3		.req	x2
+#ifdef CONFIG_CPU_ENDIAN_BE8
+#define CPU_LE(code...)
+#else
+#define CPU_LE(code...)		code
+#endif
 
-	vzr		.req	v13
+	.text
+	.fpu		crypto-neon-fp-armv8
+
+	arg1_low32	.req	r0
+	arg2		.req	r1
+	arg3		.req	r2
+
+	qzr		.req	q13
+
+	q0l		.req	d0
+	q0h		.req	d1
+	q1l		.req	d2
+	q1h		.req	d3
+	q2l		.req	d4
+	q2h		.req	d5
+	q3l		.req	d6
+	q3h		.req	d7
+	q4l		.req	d8
+	q4h		.req	d9
+	q5l		.req	d10
+	q5h		.req	d11
+	q6l		.req	d12
+	q6h		.req	d13
+	q7l		.req	d14
+	q7h		.req	d15
 
 ENTRY(crc_t10dif_pmull)
-	stp		x29, x30, [sp, #-32]!
-	mov		x29, sp
+	push		{r4, lr}
+	sub		sp, sp, #0x10
 
-	movi		vzr.16b, #0		// init zero register
+	vmov.i8		qzr, #0			// init zero register
 
 	// adjust the 16-bit initial_crc value, scale it to 32 bits
 	lsl		arg1_low32, arg1_low32, #16
@@ -93,41 +116,44 @@ ENTRY(crc_t10dif_pmull)
 	cmp		arg3, #256
 
 	// for sizes less than 128, we can't fold 64B at a time...
-	b.lt		_less_than_128
+	blt		_less_than_128
 
 	// load the initial crc value
 	// crc value does not need to be byte-reflected, but it needs
 	// to be moved to the high part of the register.
 	// because data will be byte-reflected and will align with
 	// initial crc at correct place.
-	movi		v10.16b, #0
-	mov		v10.s[3], arg1_low32		// initial crc
+	vmov		s0, arg1_low32		// initial crc
+	vext.8		q10, qzr, q0, #4
 
 	// receive the initial 64B data, xor the initial crc value
-	ld1		{v0.2d-v3.2d}, [arg2], #0x40
-	ld1		{v4.2d-v7.2d}, [arg2], #0x40
-CPU_LE(	rev64		v0.16b, v0.16b		)
-CPU_LE(	rev64		v1.16b, v1.16b		)
-CPU_LE(	rev64		v2.16b, v2.16b		)
-CPU_LE(	rev64		v3.16b, v3.16b		)
-CPU_LE(	rev64		v4.16b, v4.16b		)
-CPU_LE(	rev64		v5.16b, v5.16b		)
-CPU_LE(	rev64		v6.16b, v6.16b		)
-CPU_LE(	rev64		v7.16b, v7.16b		)
-
-	ext		v0.16b, v0.16b, v0.16b, #8
-	ext		v1.16b, v1.16b, v1.16b, #8
-	ext		v2.16b, v2.16b, v2.16b, #8
-	ext		v3.16b, v3.16b, v3.16b, #8
-	ext		v4.16b, v4.16b, v4.16b, #8
-	ext		v5.16b, v5.16b, v5.16b, #8
-	ext		v6.16b, v6.16b, v6.16b, #8
-	ext		v7.16b, v7.16b, v7.16b, #8
+	vld1.64		{q0-q1}, [arg2]!
+	vld1.64		{q2-q3}, [arg2]!
+	vld1.64		{q4-q5}, [arg2]!
+	vld1.64		{q6-q7}, [arg2]!
+CPU_LE(	vrev64.8	q0, q0			)
+CPU_LE(	vrev64.8	q1, q1			)
+CPU_LE(	vrev64.8	q2, q2			)
+CPU_LE(	vrev64.8	q3, q3			)
+CPU_LE(	vrev64.8	q4, q4			)
+CPU_LE(	vrev64.8	q5, q5			)
+CPU_LE(	vrev64.8	q6, q6			)
+CPU_LE(	vrev64.8	q7, q7			)
+
+	vext.8		q0, q0, q0, #8
+	vext.8		q1, q1, q1, #8
+	vext.8		q2, q2, q2, #8
+	vext.8		q3, q3, q3, #8
+	vext.8		q4, q4, q4, #8
+	vext.8		q5, q5, q5, #8
+	vext.8		q6, q6, q6, #8
+	vext.8		q7, q7, q7, #8
 
 	// XOR the initial_crc value
-	eor		v0.16b, v0.16b, v10.16b
+	veor.8		q0, q0, q10
 
-	ldr		q10, rk3	// xmm10 has rk3 and rk4
+	adrl		ip, rk3
+	vld1.64		{q10}, [ip]	// xmm10 has rk3 and rk4
 					// type of pmull instruction
 					// will determine which constant to use
 
@@ -146,32 +172,32 @@ CPU_LE(	rev64		v7.16b, v7.16b		)
 _fold_64_B_loop:
 
 	.macro		fold64, reg1, reg2
-	ld1		{v11.2d-v12.2d}, [arg2], #0x20
-CPU_LE(	rev64		v11.16b, v11.16b	)
-CPU_LE(	rev64		v12.16b, v12.16b	)
-	ext		v11.16b, v11.16b, v11.16b, #8
-	ext		v12.16b, v12.16b, v12.16b, #8
-
-	pmull2		v8.1q, \reg1\().2d, v10.2d
-	pmull		\reg1\().1q, \reg1\().1d, v10.1d
-	pmull2		v9.1q, \reg2\().2d, v10.2d
-	pmull		\reg2\().1q, \reg2\().1d, v10.1d
-
-	eor		\reg1\().16b, \reg1\().16b, v11.16b
-	eor		\reg2\().16b, \reg2\().16b, v12.16b
-	eor		\reg1\().16b, \reg1\().16b, v8.16b
-	eor		\reg2\().16b, \reg2\().16b, v9.16b
+	vld1.64		{q11-q12}, [arg2]!
+CPU_LE(	vrev64.8	q11, q11		)
+CPU_LE(	vrev64.8	q12, q12		)
+	vext.8		q11, q11, q11, #8
+	vext.8		q12, q12, q12, #8
+
+	vmull.p64	q8, \reg1\()h, d21
+	vmull.p64	\reg1\(), \reg1\()l, d20
+	vmull.p64	q9, \reg2\()h, d21
+	vmull.p64	\reg2\(), \reg2\()l, d20
+
+	veor.8		\reg1, \reg1, q11
+	veor.8		\reg2, \reg2, q12
+	veor.8		\reg1, \reg1, q8
+	veor.8		\reg2, \reg2, q9
 	.endm
 
-	fold64		v0, v1
-	fold64		v2, v3
-	fold64		v4, v5
-	fold64		v6, v7
+	fold64		q0, q1
+	fold64		q2, q3
+	fold64		q4, q5
+	fold64		q6, q7
 
 	subs		arg3, arg3, #128
 
 	// check if there is another 64B in the buffer to be able to fold
-	b.ge		_fold_64_B_loop
+	bge		_fold_64_B_loop
 
 	// at this point, the buffer pointer is pointing at the last y Bytes
 	// of the buffer the 64B of folded data is in 4 of the vector
@@ -181,46 +207,47 @@ CPU_LE(	rev64		v12.16b, v12.16b	)
 	// constants
 
 	.macro		fold16, rk, reg
-	ldr		q10, \rk
-	pmull		v8.1q, \reg\().1d, v10.1d
-	pmull2		\reg\().1q, \reg\().2d, v10.2d
-	eor		v7.16b, v7.16b, v8.16b
-	eor		v7.16b, v7.16b, \reg\().16b
+	vldr		d20, \rk
+	vldr		d21, \rk + 8
+	vmull.p64	q8, \reg\()l, d20
+	vmull.p64	\reg\(), \reg\()h, d21
+	veor.8		q7, q7, q8
+	veor.8		q7, q7, \reg
 	.endm
 
-	fold16		rk9, v0
-	fold16		rk11, v1
-	fold16		rk13, v2
-	fold16		rk15, v3
-	fold16		rk17, v4
-	fold16		rk19, v5
-	fold16		rk1, v6
+	fold16		rk9, q0
+	fold16		rk11, q1
+	fold16		rk13, q2
+	fold16		rk15, q3
+	fold16		rk17, q4
+	fold16		rk19, q5
+	fold16		rk1, q6
 
 	// instead of 64, we add 48 to the loop counter to save 1 instruction
 	// from the loop instead of a cmp instruction, we use the negative
 	// flag with the jl instruction
 	adds		arg3, arg3, #(128-16)
-	b.lt		_final_reduction_for_128
+	blt		_final_reduction_for_128
 
 	// now we have 16+y bytes left to reduce. 16 Bytes is in register v7
 	// and the rest is in memory. We can fold 16 bytes at a time if y>=16
 	// continue folding 16B at a time
 
 _16B_reduction_loop:
-	pmull		v8.1q, v7.1d, v10.1d
-	pmull2		v7.1q, v7.2d, v10.2d
-	eor		v7.16b, v7.16b, v8.16b
-
-	ld1		{v0.2d}, [arg2], #16
-CPU_LE(	rev64		v0.16b, v0.16b		)
-	ext		v0.16b, v0.16b, v0.16b, #8
-	eor		v7.16b, v7.16b, v0.16b
+	vmull.p64	q8, d14, d20
+	vmull.p64	q7, d15, d21
+	veor.8		q7, q7, q8
+
+	vld1.64		{q0}, [arg2]!
+CPU_LE(	vrev64.8	q0, q0		)
+	vext.8		q0, q0, q0, #8
+	veor.8		q7, q7, q0
 	subs		arg3, arg3, #16
 
 	// instead of a cmp instruction, we utilize the flags with the
 	// jge instruction equivalent of: cmp arg3, 16-16
 	// check if there is any more 16B in the buffer to be able to fold
-	b.ge		_16B_reduction_loop
+	bge		_16B_reduction_loop
 
 	// now we have 16+z bytes left to reduce, where 0<= z < 16.
 	// first, we reduce the data in the xmm7 register
@@ -229,99 +256,104 @@ _final_reduction_for_128:
 	// check if any more data to fold. If not, compute the CRC of
 	// the final 128 bits
 	adds		arg3, arg3, #16
-	b.eq		_128_done
+	beq		_128_done
 
 	// here we are getting data that is less than 16 bytes.
 	// since we know that there was data before the pointer, we can
 	// offset the input pointer before the actual point, to receive
 	// exactly 16 bytes. after that the registers need to be adjusted.
 _get_last_two_regs:
-	mov		v2.16b, v7.16b
+	vmov		q2, q7
 
 	add		arg2, arg2, arg3
 	sub		arg2, arg2, #16
-	ld1		{v1.2d}, [arg2]
-CPU_LE(	rev64		v1.16b, v1.16b		)
-	ext		v1.16b, v1.16b, v1.16b, #8
+	vld1.64		{q1}, [arg2]
+CPU_LE(	vrev64.8	q1, q1			)
+	vext.8		q1, q1, q1, #8
 
 	// get rid of the extra data that was loaded before
 	// load the shift constant
-	adr		x4, tbl_shf_table + 16
-	sub		x4, x4, arg3
-	ld1		{v0.16b}, [x4]
+	adr		lr, tbl_shf_table + 16
+	sub		lr, lr, arg3
+	vld1.8		{q0}, [lr]
 
 	// shift v2 to the left by arg3 bytes
-	tbl		v2.16b, {v2.16b}, v0.16b
+	vmov		q9, q2
+	vtbl.8		d4, {d18-d19}, d0
+	vtbl.8		d5, {d18-d19}, d1
 
 	// shift v7 to the right by 16-arg3 bytes
-	movi		v9.16b, #0x80
-	eor		v0.16b, v0.16b, v9.16b
-	tbl		v7.16b, {v7.16b}, v0.16b
+	vmov.i8		q9, #0x80
+	veor.8		q0, q0, q9
+	vmov		q9, q7
+	vtbl.8		d14, {d18-d19}, d0
+	vtbl.8		d15, {d18-d19}, d1
 
 	// blend
-	sshr		v0.16b, v0.16b, #7	// convert to 8-bit mask
-	bsl		v0.16b, v2.16b, v1.16b
+	vshr.s8		q0, q0, #7		// convert to 8-bit mask
+	vbsl.8		q0, q2, q1
 
 	// fold 16 Bytes
-	pmull		v8.1q, v7.1d, v10.1d
-	pmull2		v7.1q, v7.2d, v10.2d
-	eor		v7.16b, v7.16b, v8.16b
-	eor		v7.16b, v7.16b, v0.16b
+	vmull.p64	q8, d14, d20
+	vmull.p64	q7, d15, d21
+	veor.8		q7, q7, q8
+	veor.8		q7, q7, q0
 
 _128_done:
 	// compute crc of a 128-bit value
-	ldr		q10, rk5		// rk5 and rk6 in xmm10
+	vldr		d20, rk5
+	vldr		d21, rk6		// rk5 and rk6 in xmm10
 
 	// 64b fold
-	mov		v0.16b, v7.16b
-	ext		v7.16b, v7.16b, v7.16b, #8
-	pmull		v7.1q, v7.1d, v10.1d
-	ext		v0.16b, vzr.16b, v0.16b, #8
-	eor		v7.16b, v7.16b, v0.16b
+	vmov		q0, q7
+	vmull.p64	q7, d15, d20
+	vext.8		q0, qzr, q0, #8
+	veor.8		q7, q7, q0
 
 	// 32b fold
-	mov		v0.16b, v7.16b
-	mov		v0.s[3], vzr.s[0]
-	ext		v7.16b, v7.16b, vzr.16b, #12
-	ext		v9.16b, v10.16b, v10.16b, #8
-	pmull		v7.1q, v7.1d, v9.1d
-	eor		v7.16b, v7.16b, v0.16b
+	veor.8		d1, d1, d1
+	vmov		d0, d14
+	vmov		s2, s30
+	vext.8		q7, q7, qzr, #12
+	vmull.p64	q7, d14, d21
+	veor.8		q7, q7, q0
 
 	// barrett reduction
 _barrett:
-	ldr		q10, rk7
-	mov		v0.16b, v7.16b
-	ext		v7.16b, v7.16b, v7.16b, #8
+	vldr		d20, rk7
+	vldr		d21, rk8
+	vmov.8		q0, q7
 
-	pmull		v7.1q, v7.1d, v10.1d
-	ext		v7.16b, vzr.16b, v7.16b, #12
-	pmull2		v7.1q, v7.2d, v10.2d
-	ext		v7.16b, vzr.16b, v7.16b, #12
-	eor		v7.16b, v7.16b, v0.16b
-	mov		w0, v7.s[1]
+	vmull.p64	q7, d15, d20
+	vext.8		q7, qzr, q7, #12
+	vmull.p64	q7, d15, d21
+	vext.8		q7, qzr, q7, #12
+	veor.8		q7, q7, q0
+	vmov		r0, s29
 
 _cleanup:
 	// scale the result back to 16 bits
-	lsr		x0, x0, #16
-	ldp		x29, x30, [sp], #32
-	ret
+	lsr		r0, r0, #16
+	add		sp, sp, #0x10
+	pop		{r4, pc}
 
 	.align		4
 _less_than_128:
 
 	// check if there is enough buffer to be able to fold 16B at a time
 	cmp		arg3, #32
-	b.lt		_less_than_32
+	blt		_less_than_32
 
 	// now if there is, load the constants
-	ldr		q10, rk1		// rk1 and rk2 in xmm10
+	vldr		d20, rk1
+	vldr		d21, rk2		// rk1 and rk2 in xmm10
 
-	movi		v0.16b, #0
-	mov		v0.s[3], arg1_low32	// get the initial crc value
-	ld1		{v7.2d}, [arg2], #0x10
-CPU_LE(	rev64		v7.16b, v7.16b		)
-	ext		v7.16b, v7.16b, v7.16b, #8
-	eor		v7.16b, v7.16b, v0.16b
+	vmov.i8		q0, #0
+	vmov		s3, arg1_low32		// get the initial crc value
+	vld1.64		{q7}, [arg2]!
+CPU_LE(	vrev64.8	q7, q7		)
+	vext.8		q7, q7, q7, #8
+	veor.8		q7, q7, q0
 
 	// update the counter. subtract 32 instead of 16 to save one
 	// instruction from the loop
@@ -331,21 +363,23 @@ CPU_LE(	rev64		v7.16b, v7.16b		)
 
 	.align		4
 _less_than_32:
-	cbz		arg3, _cleanup
+	teq		arg3, #0
+	beq		_cleanup
 
-	movi		v0.16b, #0
-	mov		v0.s[3], arg1_low32	// get the initial crc value
+	vmov.i8		q0, #0
+	vmov		s3, arg1_low32		// get the initial crc value
 
 	cmp		arg3, #16
-	b.eq		_exact_16_left
-	b.lt		_less_than_16_left
+	beq		_exact_16_left
+	blt		_less_than_16_left
 
-	ld1		{v7.2d}, [arg2], #0x10
-CPU_LE(	rev64		v7.16b, v7.16b		)
-	ext		v7.16b, v7.16b, v7.16b, #8
-	eor		v7.16b, v7.16b, v0.16b
+	vld1.64		{q7}, [arg2]!
+CPU_LE(	vrev64.8	q7, q7		)
+	vext.8		q7, q7, q7, #8
+	veor.8		q7, q7, q0
 	sub		arg3, arg3, #16
-	ldr		q10, rk1		// rk1 and rk2 in xmm10
+	vldr		d20, rk1
+	vldr		d21, rk2		// rk1 and rk2 in xmm10
 	b		_get_last_two_regs
 
 	.align		4
@@ -353,117 +387,124 @@ _less_than_16_left:
 	// use stack space to load data less than 16 bytes, zero-out
 	// the 16B in memory first.
 
-	add		x11, sp, #0x10
-	stp		xzr, xzr, [x11]
+	vst1.8		{qzr}, [sp]
+	mov		ip, sp
 
 	cmp		arg3, #4
-	b.lt		_only_less_than_4
+	blt		_only_less_than_4
 
 	// backup the counter value
-	mov		x9, arg3
-	tbz		arg3, #3, _less_than_8_left
+	mov		lr, arg3
+	cmp		arg3, #8
+	blt		_less_than_8_left
 
 	// load 8 Bytes
-	ldr		x0, [arg2], #8
-	str		x0, [x11], #8
+	ldr		r0, [arg2], #4
+	ldr		r3, [arg2], #4
+	str		r0, [ip], #4
+	str		r3, [ip], #4
 	sub		arg3, arg3, #8
 
 _less_than_8_left:
-	tbz		arg3, #2, _less_than_4_left
+	cmp		arg3, #4
+	blt		_less_than_4_left
 
 	// load 4 Bytes
-	ldr		w0, [arg2], #4
-	str		w0, [x11], #4
+	ldr		r0, [arg2], #4
+	str		r0, [ip], #4
 	sub		arg3, arg3, #4
 
 _less_than_4_left:
-	tbz		arg3, #1, _less_than_2_left
+	cmp		arg3, #2
+	blt		_less_than_2_left
 
 	// load 2 Bytes
-	ldrh		w0, [arg2], #2
-	strh		w0, [x11], #2
+	ldrh		r0, [arg2], #2
+	strh		r0, [ip], #2
 	sub		arg3, arg3, #2
 
 _less_than_2_left:
-	cbz		arg3, _zero_left
+	cmp		arg3, #1
+	blt		_zero_left
 
 	// load 1 Byte
-	ldrb		w0, [arg2]
-	strb		w0, [x11]
+	ldrb		r0, [arg2]
+	strb		r0, [ip]
 
 _zero_left:
-	add		x11, sp, #0x10
-	ld1		{v7.2d}, [x11]
-CPU_LE(	rev64		v7.16b, v7.16b		)
-	ext		v7.16b, v7.16b, v7.16b, #8
-	eor		v7.16b, v7.16b, v0.16b
+	vld1.64		{q7}, [sp]
+CPU_LE(	vrev64.8	q7, q7		)
+	vext.8		q7, q7, q7, #8
+	veor.8		q7, q7, q0
 
 	// shl r9, 4
-	adr		x0, tbl_shf_table + 16
-	sub		x0, x0, x9
-	ld1		{v0.16b}, [x0]
-	movi		v9.16b, #0x80
-	eor		v0.16b, v0.16b, v9.16b
-	tbl		v7.16b, {v7.16b}, v0.16b
+	adr		ip, tbl_shf_table + 16
+	sub		ip, ip, lr
+	vld1.8		{q0}, [ip]
+	vmov.i8		q9, #0x80
+	veor.8		q0, q0, q9
+	vmov		q9, q7
+	vtbl.8		d14, {d18-d19}, d0
+	vtbl.8		d15, {d18-d19}, d1
 
 	b		_128_done
 
 	.align		4
 _exact_16_left:
-	ld1		{v7.2d}, [arg2]
-CPU_LE(	rev64		v7.16b, v7.16b		)
-	ext		v7.16b, v7.16b, v7.16b, #8
-	eor		v7.16b, v7.16b, v0.16b	// xor the initial crc value
+	vld1.64		{q7}, [arg2]
+CPU_LE(	vrev64.8	q7, q7			)
+	vext.8		q7, q7, q7, #8
+	veor.8		q7, q7, q0		// xor the initial crc value
 
 	b		_128_done
 
 _only_less_than_4:
 	cmp		arg3, #3
-	b.lt		_only_less_than_3
+	blt		_only_less_than_3
 
 	// load 3 Bytes
-	ldrh		w0, [arg2]
-	strh		w0, [x11]
+	ldrh		r0, [arg2]
+	strh		r0, [ip]
 
-	ldrb		w0, [arg2, #2]
-	strb		w0, [x11, #2]
+	ldrb		r0, [arg2, #2]
+	strb		r0, [ip, #2]
 
-	ld1		{v7.2d}, [x11]
-CPU_LE(	rev64		v7.16b, v7.16b		)
-	ext		v7.16b, v7.16b, v7.16b, #8
-	eor		v7.16b, v7.16b, v0.16b
+	vld1.64		{q7}, [ip]
+CPU_LE(	vrev64.8	q7, q7			)
+	vext.8		q7, q7, q7, #8
+	veor.8		q7, q7, q0
 
-	ext		v7.16b, v7.16b, vzr.16b, #5
+	vext.8		q7, q7, qzr, #5
 	b		_barrett
 
 _only_less_than_3:
 	cmp		arg3, #2
-	b.lt		_only_less_than_2
+	blt		_only_less_than_2
 
 	// load 2 Bytes
-	ldrh		w0, [arg2]
-	strh		w0, [x11]
+	ldrh		r0, [arg2]
+	strh		r0, [ip]
 
-	ld1		{v7.2d}, [x11]
-CPU_LE(	rev64		v7.16b, v7.16b		)
-	ext		v7.16b, v7.16b, v7.16b, #8
-	eor		v7.16b, v7.16b, v0.16b
+	vld1.64		{q7}, [ip]
+CPU_LE(	vrev64.8	q7, q7			)
+	vext.8		q7, q7, q7, #8
+	veor.8		q7, q7, q0
 
-	ext		v7.16b, v7.16b, vzr.16b, #6
+	vext.8		q7, q7, qzr, #6
 	b		_barrett
 
 _only_less_than_2:
 
 	// load 1 Byte
-	ldrb		w0, [arg2]
-	strb		w0, [x11]
+	ldrb		r0, [arg2]
+	strb		r0, [ip]
 
-	ld1		{v7.2d}, [x11]
-CPU_LE(	rev64		v7.16b, v7.16b		)
-	ext		v7.16b, v7.16b, v7.16b, #8
-	eor		v7.16b, v7.16b, v0.16b
+	vld1.64		{q7}, [ip]
+CPU_LE(	vrev64.8	q7, q7			)
+	vext.8		q7, q7, q7, #8
+	veor.8		q7, q7, q0
 
-	ext		v7.16b, v7.16b, vzr.16b, #7
+	vext.8		q7, q7, qzr, #7
 	b		_barrett
 
 ENDPROC(crc_t10dif_pmull)
@@ -482,16 +523,26 @@ ENDPROC(crc_t10dif_pmull)
 // rk7 = floor(2^64/Q)
 // rk8 = Q
 
-rk1:	.octa		0x06df0000000000002d56000000000000
-rk3:	.octa		0x7cf50000000000009d9d000000000000
-rk5:	.octa		0x13680000000000002d56000000000000
-rk7:	.octa		0x000000018bb7000000000001f65a57f8
-rk9:	.octa		0xbfd6000000000000ceae000000000000
-rk11:	.octa		0x713c0000000000001e16000000000000
-rk13:	.octa		0x80a6000000000000f7f9000000000000
-rk15:	.octa		0xe658000000000000044c000000000000
-rk17:	.octa		0xa497000000000000ad18000000000000
-rk19:	.octa		0xe7b50000000000006ee3000000000000
+rk1:	.quad		0x2d56000000000000
+rk2:	.quad		0x06df000000000000
+rk3:	.quad		0x9d9d000000000000
+rk4:	.quad		0x7cf5000000000000
+rk5:	.quad		0x2d56000000000000
+rk6:	.quad		0x1368000000000000
+rk7:	.quad		0x00000001f65a57f8
+rk8:	.quad		0x000000018bb70000
+rk9:	.quad		0xceae000000000000
+rk10:	.quad		0xbfd6000000000000
+rk11:	.quad		0x1e16000000000000
+rk12:	.quad		0x713c000000000000
+rk13:	.quad		0xf7f9000000000000
+rk14:	.quad		0x80a6000000000000
+rk15:	.quad		0x044c000000000000
+rk16:	.quad		0xe658000000000000
+rk17:	.quad		0xad18000000000000
+rk18:	.quad		0xa497000000000000
+rk19:	.quad		0x6ee3000000000000
+rk20:	.quad		0xe7b5000000000000
 
 tbl_shf_table:
 // use these values for shift constants for the tbl/tbx instruction
diff --git a/arch/arm64/crypto/crct10dif-ce-glue.c b/arch/arm/crypto/crct10dif-ce-glue.c
similarity index 76%
copy from arch/arm64/crypto/crct10dif-ce-glue.c
copy to arch/arm/crypto/crct10dif-ce-glue.c
index d11f33dae79c..e717538d902c 100644
--- a/arch/arm64/crypto/crct10dif-ce-glue.c
+++ b/arch/arm/crypto/crct10dif-ce-glue.c
@@ -1,5 +1,5 @@
 /*
- * Accelerated CRC-T10DIF using arm64 NEON and Crypto Extensions instructions
+ * Accelerated CRC-T10DIF using ARM NEON and Crypto Extensions instructions
  *
  * Copyright (C) 2016 Linaro Ltd <ard.biesheuvel@linaro.org>
  *
@@ -8,7 +8,6 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/cpufeature.h>
 #include <linux/crc-t10dif.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -18,6 +17,7 @@
 #include <crypto/internal/hash.h>
 
 #include <asm/neon.h>
+#include <asm/simd.h>
 
 asmlinkage u16 crc_t10dif_pmull(u16 init_crc, const u8 buf[], u64 len);
 
@@ -34,9 +34,13 @@ static int crct10dif_update(struct shash_desc *desc, const u8 *data,
 {
 	u16 *crc = shash_desc_ctx(desc);
 
-	kernel_neon_begin_partial(14);
-	*crc = crc_t10dif_pmull(*crc, data, length);
-	kernel_neon_end();
+	if (may_use_simd()) {
+		kernel_neon_begin();
+		*crc = crc_t10dif_pmull(*crc, data, length);
+		kernel_neon_end();
+	} else {
+		*crc = crc_t10dif_generic(*crc, data, length);
+	}
 
 	return 0;
 }
@@ -57,7 +61,7 @@ static struct shash_alg crc_t10dif_alg = {
 
 	.descsize		= CRC_T10DIF_DIGEST_SIZE,
 	.base.cra_name		= "crct10dif",
-	.base.cra_driver_name	= "crct10dif-arm64-ce",
+	.base.cra_driver_name	= "crct10dif-arm-ce",
 	.base.cra_priority	= 200,
 	.base.cra_blocksize	= CRC_T10DIF_BLOCK_SIZE,
 	.base.cra_module	= THIS_MODULE,
@@ -65,6 +69,9 @@ static struct shash_alg crc_t10dif_alg = {
 
 static int __init crc_t10dif_mod_init(void)
 {
+	if (!(elf_hwcap2 & HWCAP2_PMULL))
+		return -ENODEV;
+
 	return crypto_register_shash(&crc_t10dif_alg);
 }
 
@@ -73,8 +80,10 @@ static void __exit crc_t10dif_mod_exit(void)
 	crypto_unregister_shash(&crc_t10dif_alg);
 }
 
-module_cpu_feature_match(PMULL, crc_t10dif_mod_init);
+module_init(crc_t10dif_mod_init);
 module_exit(crc_t10dif_mod_exit);
 
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
+MODULE_ALIAS_CRYPTO("crct10dif");
+MODULE_ALIAS_CRYPTO("crct10dif-arm-ce");
-- 
2.7.4
