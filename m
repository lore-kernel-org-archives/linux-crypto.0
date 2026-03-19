Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984FF34D923;
	Thu, 19 Mar 2026 06:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773901157; cv=none; b=tTEWlY48/7uRO0qbVPFg0Ib6CSFlxbodoPLncTGYXZ29QLPCU4ghhf0xb0pI9vl2RMeZUAzYpbE2YzcUCTuQl+YQMyhCY9J19KGQSCgJggAMK0hDLuSCnzcykhpKLSEQCTJc3p8uy+ziu1yxjPUQbmEtp82ulS0uYJk/OBvryj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773901157; c=relaxed/simple;
	bh=V2j6hPx45gvxh0kD2ugA9ZQq+RDxK4vT1DIHz7d+PX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o7RpOuSfotlBJnrTRQB/+snhdq2nZKtcF4vEh8BHIGBnHUuStwkeWRA8kohP/QZny8OVzBHtnmeddp+28wZZSccEFV7BrZ5K+Kyo2RhlFg/9eblvNmwjmBDYflBPQdzJTZHB+k5VFyOIqp/jJQwZo0nB2iqXMzYUhgGDEL/5XKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d8TTmcAi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d8TTmcAi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB32C2BCB0;
	Thu, 19 Mar 2026 06:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773901157;
	bh=V2j6hPx45gvxh0kD2ugA9ZQq+RDxK4vT1DIHz7d+PX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d8TTmcAiFzhKSiHPR+WkM8CA6ky0KX2q3kPE3nwbJyewHZyMixuvB6X7fm9EZk9SJ
	 t93dNZFdBMtGNa4fkJSJyx4bY6DicytwSb7/HdnKtrq5pWkvH0bnHuzB6rkv9ieG7A
	 DdopRLVS+mLHrpWt6qhNXQxULA55S/4OGeXyBcIrBAQC7vuMQ8WDcxgJZi2k5Q6Vow
	 uVBZCFKQyz6Thxst9LgukjuoVA9uECrZC7fGQNsEMoF1uPmUfgkcyLBQ5Pc/rkbDhR
	 fZIbppcMdMQ+bl5l1xRzcnEagqDeIzv5gTO+LPZEZ+ucVt4GqtwA/Hod2eNr/OeAJI
	 iGe4zZbaGC2SQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 06/19] crypto: arm/ghash - Move NEON GHASH assembly into its own file
Date: Wed, 18 Mar 2026 23:17:07 -0700
Message-ID: <20260319061723.1140720-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260319061723.1140720-1-ebiggers@kernel.org>
References: <20260319061723.1140720-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

arch/arm/crypto/ghash-ce-core.S implements pmull_ghash_update_p8(),
which is used only by a crypto_shash implementation of GHASH.  It also
implements other functions, including pmull_ghash_update_p64() and
others, which are used only by a crypto_aead implementation of AES-GCM.

While some code is shared between pmull_ghash_update_p8() and
pmull_ghash_update_p64(), it's not very much.  Since
pmull_ghash_update_p8() will also need to be migrated into lib/crypto/
to achieve parity in the standalone GHASH support, let's move it into a
separate file ghash-neon-core.S.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/arm/crypto/Makefile          |   2 +-
 arch/arm/crypto/ghash-ce-core.S   | 171 ++----------------------
 arch/arm/crypto/ghash-neon-core.S | 207 ++++++++++++++++++++++++++++++
 3 files changed, 222 insertions(+), 158 deletions(-)
 create mode 100644 arch/arm/crypto/ghash-neon-core.S

diff --git a/arch/arm/crypto/Makefile b/arch/arm/crypto/Makefile
index e73099e120b3..cedce94d5ee5 100644
--- a/arch/arm/crypto/Makefile
+++ b/arch/arm/crypto/Makefile
@@ -8,6 +8,6 @@ obj-$(CONFIG_CRYPTO_AES_ARM_BS) += aes-arm-bs.o
 obj-$(CONFIG_CRYPTO_AES_ARM_CE) += aes-arm-ce.o
 obj-$(CONFIG_CRYPTO_GHASH_ARM_CE) += ghash-arm-ce.o
 
 aes-arm-bs-y	:= aes-neonbs-core.o aes-neonbs-glue.o
 aes-arm-ce-y	:= aes-ce-core.o aes-ce-glue.o
-ghash-arm-ce-y	:= ghash-ce-core.o ghash-ce-glue.o
+ghash-arm-ce-y	:= ghash-ce-core.o ghash-ce-glue.o ghash-neon-core.o
diff --git a/arch/arm/crypto/ghash-ce-core.S b/arch/arm/crypto/ghash-ce-core.S
index 858c0d66798b..a449525d61f8 100644
--- a/arch/arm/crypto/ghash-ce-core.S
+++ b/arch/arm/crypto/ghash-ce-core.S
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * Accelerated GHASH implementation with NEON/ARMv8 vmull.p8/64 instructions.
+ * Accelerated AES-GCM implementation with ARMv8 Crypto Extensions.
  *
  * Copyright (C) 2015 - 2017 Linaro Ltd.
  * Copyright (C) 2023 Google LLC. <ardb@google.com>
  */
 
@@ -27,43 +27,14 @@
 	XL_H		.req	d5
 	XM_L		.req	d6
 	XM_H		.req	d7
 	XH_L		.req	d8
 
-	t0l		.req	d10
-	t0h		.req	d11
-	t1l		.req	d12
-	t1h		.req	d13
-	t2l		.req	d14
-	t2h		.req	d15
-	t3l		.req	d16
-	t3h		.req	d17
-	t4l		.req	d18
-	t4h		.req	d19
-
-	t0q		.req	q5
-	t1q		.req	q6
-	t2q		.req	q7
-	t3q		.req	q8
-	t4q		.req	q9
 	XH2		.req	q9
 
-	s1l		.req	d20
-	s1h		.req	d21
-	s2l		.req	d22
-	s2h		.req	d23
-	s3l		.req	d24
-	s3h		.req	d25
-	s4l		.req	d26
-	s4h		.req	d27
-
 	MASK		.req	d28
-	SHASH2_p8	.req	d28
 
-	k16		.req	d29
-	k32		.req	d30
-	k48		.req	d31
 	SHASH2_p64	.req	d31
 
 	HH		.req	q10
 	HH3		.req	q11
 	HH4		.req	q12
@@ -91,76 +62,10 @@
 	T3_L		.req	d16
 	T3_H		.req	d17
 
 	.text
 
-	.macro		__pmull_p64, rd, rn, rm, b1, b2, b3, b4
-	vmull.p64	\rd, \rn, \rm
-	.endm
-
-	/*
-	 * This implementation of 64x64 -> 128 bit polynomial multiplication
-	 * using vmull.p8 instructions (8x8 -> 16) is taken from the paper
-	 * "Fast Software Polynomial Multiplication on ARM Processors Using
-	 * the NEON Engine" by Danilo Camara, Conrado Gouvea, Julio Lopez and
-	 * Ricardo Dahab (https://hal.inria.fr/hal-01506572)
-	 *
-	 * It has been slightly tweaked for in-order performance, and to allow
-	 * 'rq' to overlap with 'ad' or 'bd'.
-	 */
-	.macro		__pmull_p8, rq, ad, bd, b1=t4l, b2=t3l, b3=t4l, b4=t3l
-	vext.8		t0l, \ad, \ad, #1	@ A1
-	.ifc		\b1, t4l
-	vext.8		t4l, \bd, \bd, #1	@ B1
-	.endif
-	vmull.p8	t0q, t0l, \bd		@ F = A1*B
-	vext.8		t1l, \ad, \ad, #2	@ A2
-	vmull.p8	t4q, \ad, \b1		@ E = A*B1
-	.ifc		\b2, t3l
-	vext.8		t3l, \bd, \bd, #2	@ B2
-	.endif
-	vmull.p8	t1q, t1l, \bd		@ H = A2*B
-	vext.8		t2l, \ad, \ad, #3	@ A3
-	vmull.p8	t3q, \ad, \b2		@ G = A*B2
-	veor		t0q, t0q, t4q		@ L = E + F
-	.ifc		\b3, t4l
-	vext.8		t4l, \bd, \bd, #3	@ B3
-	.endif
-	vmull.p8	t2q, t2l, \bd		@ J = A3*B
-	veor		t0l, t0l, t0h		@ t0 = (L) (P0 + P1) << 8
-	veor		t1q, t1q, t3q		@ M = G + H
-	.ifc		\b4, t3l
-	vext.8		t3l, \bd, \bd, #4	@ B4
-	.endif
-	vmull.p8	t4q, \ad, \b3		@ I = A*B3
-	veor		t1l, t1l, t1h		@ t1 = (M) (P2 + P3) << 16
-	vmull.p8	t3q, \ad, \b4		@ K = A*B4
-	vand		t0h, t0h, k48
-	vand		t1h, t1h, k32
-	veor		t2q, t2q, t4q		@ N = I + J
-	veor		t0l, t0l, t0h
-	veor		t1l, t1l, t1h
-	veor		t2l, t2l, t2h		@ t2 = (N) (P4 + P5) << 24
-	vand		t2h, t2h, k16
-	veor		t3l, t3l, t3h		@ t3 = (K) (P6 + P7) << 32
-	vmov.i64	t3h, #0
-	vext.8		t0q, t0q, t0q, #15
-	veor		t2l, t2l, t2h
-	vext.8		t1q, t1q, t1q, #14
-	vmull.p8	\rq, \ad, \bd		@ D = A*B
-	vext.8		t2q, t2q, t2q, #13
-	vext.8		t3q, t3q, t3q, #12
-	veor		t0q, t0q, t1q
-	veor		t2q, t2q, t3q
-	veor		\rq, \rq, t0q
-	veor		\rq, \rq, t2q
-	.endm
-
-	//
-	// PMULL (64x64->128) based reduction for CPUs that can do
-	// it in a single instruction.
-	//
 	.macro		__pmull_reduce_p64
 	vmull.p64	T1, XL_L, MASK
 
 	veor		XH_L, XH_L, XM_H
 	vext.8		T1, T1, T1, #8
@@ -168,34 +73,11 @@
 	veor		T1, T1, XL
 
 	vmull.p64	XL, T1_H, MASK
 	.endm
 
-	//
-	// Alternative reduction for CPUs that lack support for the
-	// 64x64->128 PMULL instruction
-	//
-	.macro		__pmull_reduce_p8
-	veor		XL_H, XL_H, XM_L
-	veor		XH_L, XH_L, XM_H
-
-	vshl.i64	T1, XL, #57
-	vshl.i64	T2, XL, #62
-	veor		T1, T1, T2
-	vshl.i64	T2, XL, #63
-	veor		T1, T1, T2
-	veor		XL_H, XL_H, T1_L
-	veor		XH_L, XH_L, T1_H
-
-	vshr.u64	T1, XL, #1
-	veor		XH, XH, XL
-	veor		XL, XL, T1
-	vshr.u64	T1, T1, #6
-	vshr.u64	XL, XL, #1
-	.endm
-
-	.macro		ghash_update, pn, enc, aggregate=1, head=1
+	.macro		ghash_update, enc, aggregate=1, head=1
 	vld1.64		{XL}, [r1]
 
 	.if		\head
 	/* do the head block first, if supplied */
 	ldr		ip, [sp]
@@ -204,12 +86,11 @@
 	vld1.64		{T1}, [ip]
 	teq		r0, #0
 	b		3f
 	.endif
 
-0:	.ifc		\pn, p64
-	.if		\aggregate
+0:	.if		\aggregate
 	tst		r0, #3			// skip until #blocks is a
 	bne		2f			// round multiple of 4
 
 	vld1.8		{XL2-XM2}, [r2]!
 1:	vld1.8		{T2-T3}, [r2]!
@@ -286,11 +167,10 @@
 	veor		T1, T1, XH
 	veor		XL, XL, T1
 
 	b		1b
 	.endif
-	.endif
 
 2:	vld1.8		{T1}, [r2]!
 
 	.ifnb		\enc
 	\enc\()_1x	T1
@@ -306,29 +186,29 @@
 
 	vext.8		IN1, T1, T1, #8
 	veor		T1_L, T1_L, XL_H
 	veor		XL, XL, IN1
 
-	__pmull_\pn	XH, XL_H, SHASH_H, s1h, s2h, s3h, s4h	@ a1 * b1
+	vmull.p64	XH, XL_H, SHASH_H		@ a1 * b1
 	veor		T1, T1, XL
-	__pmull_\pn	XL, XL_L, SHASH_L, s1l, s2l, s3l, s4l	@ a0 * b0
-	__pmull_\pn	XM, T1_L, SHASH2_\pn			@ (a1+a0)(b1+b0)
+	vmull.p64	XL, XL_L, SHASH_L		@ a0 * b0
+	vmull.p64	XM, T1_L, SHASH2_p64		@ (a1+a0)(b1+b0)
 
 4:	veor		T1, XL, XH
 	veor		XM, XM, T1
 
-	__pmull_reduce_\pn
+	__pmull_reduce_p64
 
 	veor		T1, T1, XH
 	veor		XL, XL, T1
 
 	bne		0b
 	.endm
 
 	/*
-	 * void pmull_ghash_update(int blocks, u64 dg[], const char *src,
-	 *			   struct ghash_key const *k, const char *head)
+	 * void pmull_ghash_update_p64(int blocks, u64 dg[], const char *src,
+	 *			       u64 const h[4][2], const char *head)
 	 */
 ENTRY(pmull_ghash_update_p64)
 	vld1.64		{SHASH}, [r3]!
 	vld1.64		{HH}, [r3]!
 	vld1.64		{HH3-HH4}, [r3]
@@ -339,39 +219,16 @@ ENTRY(pmull_ghash_update_p64)
 	veor		HH34_H, HH4_L, HH4_H
 
 	vmov.i8		MASK, #0xe1
 	vshl.u64	MASK, MASK, #57
 
-	ghash_update	p64
+	ghash_update
 	vst1.64		{XL}, [r1]
 
 	bx		lr
 ENDPROC(pmull_ghash_update_p64)
 
-ENTRY(pmull_ghash_update_p8)
-	vld1.64		{SHASH}, [r3]
-	veor		SHASH2_p8, SHASH_L, SHASH_H
-
-	vext.8		s1l, SHASH_L, SHASH_L, #1
-	vext.8		s2l, SHASH_L, SHASH_L, #2
-	vext.8		s3l, SHASH_L, SHASH_L, #3
-	vext.8		s4l, SHASH_L, SHASH_L, #4
-	vext.8		s1h, SHASH_H, SHASH_H, #1
-	vext.8		s2h, SHASH_H, SHASH_H, #2
-	vext.8		s3h, SHASH_H, SHASH_H, #3
-	vext.8		s4h, SHASH_H, SHASH_H, #4
-
-	vmov.i64	k16, #0xffff
-	vmov.i64	k32, #0xffffffff
-	vmov.i64	k48, #0xffffffffffff
-
-	ghash_update	p8
-	vst1.64		{XL}, [r1]
-
-	bx		lr
-ENDPROC(pmull_ghash_update_p8)
-
 	e0		.req	q9
 	e1		.req	q10
 	e2		.req	q11
 	e3		.req	q12
 	e0l		.req	d18
@@ -534,11 +391,11 @@ ENTRY(pmull_gcm_encrypt)
 	ldrd		r4, r5, [sp, #24]
 	ldrd		r6, r7, [sp, #32]
 
 	vld1.64		{SHASH}, [r3]
 
-	ghash_update	p64, enc, head=0
+	ghash_update	enc, head=0
 	vst1.64		{XL}, [r1]
 
 	pop		{r4-r8, pc}
 ENDPROC(pmull_gcm_encrypt)
 
@@ -552,11 +409,11 @@ ENTRY(pmull_gcm_decrypt)
 	ldrd		r4, r5, [sp, #24]
 	ldrd		r6, r7, [sp, #32]
 
 	vld1.64		{SHASH}, [r3]
 
-	ghash_update	p64, dec, head=0
+	ghash_update	dec, head=0
 	vst1.64		{XL}, [r1]
 
 	pop		{r4-r8, pc}
 ENDPROC(pmull_gcm_decrypt)
 
@@ -601,11 +458,11 @@ ENTRY(pmull_gcm_enc_final)
 	vmov.i8		MASK, #0xe1
 	veor		SHASH2_p64, SHASH_L, SHASH_H
 	vshl.u64	MASK, MASK, #57
 	mov		r0, #1
 	bne		3f			// process head block first
-	ghash_update	p64, aggregate=0, head=0
+	ghash_update	aggregate=0, head=0
 
 	vrev64.8	XL, XL
 	vext.8		XL, XL, XL, #8
 	veor		XL, XL, e1
 
@@ -658,11 +515,11 @@ ENTRY(pmull_gcm_dec_final)
 	vmov.i8		MASK, #0xe1
 	veor		SHASH2_p64, SHASH_L, SHASH_H
 	vshl.u64	MASK, MASK, #57
 	mov		r0, #1
 	bne		3f			// process head block first
-	ghash_update	p64, aggregate=0, head=0
+	ghash_update	aggregate=0, head=0
 
 	vrev64.8	XL, XL
 	vext.8		XL, XL, XL, #8
 	veor		XL, XL, e1
 
diff --git a/arch/arm/crypto/ghash-neon-core.S b/arch/arm/crypto/ghash-neon-core.S
new file mode 100644
index 000000000000..bdf6fb6d063c
--- /dev/null
+++ b/arch/arm/crypto/ghash-neon-core.S
@@ -0,0 +1,207 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Accelerated GHASH implementation with NEON vmull.p8 instructions.
+ *
+ * Copyright (C) 2015 - 2017 Linaro Ltd.
+ * Copyright (C) 2023 Google LLC. <ardb@google.com>
+ */
+
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+
+	.fpu		neon
+
+	SHASH		.req	q0
+	T1		.req	q1
+	XL		.req	q2
+	XM		.req	q3
+	XH		.req	q4
+	IN1		.req	q4
+
+	SHASH_L		.req	d0
+	SHASH_H		.req	d1
+	T1_L		.req	d2
+	T1_H		.req	d3
+	XL_L		.req	d4
+	XL_H		.req	d5
+	XM_L		.req	d6
+	XM_H		.req	d7
+	XH_L		.req	d8
+
+	t0l		.req	d10
+	t0h		.req	d11
+	t1l		.req	d12
+	t1h		.req	d13
+	t2l		.req	d14
+	t2h		.req	d15
+	t3l		.req	d16
+	t3h		.req	d17
+	t4l		.req	d18
+	t4h		.req	d19
+
+	t0q		.req	q5
+	t1q		.req	q6
+	t2q		.req	q7
+	t3q		.req	q8
+	t4q		.req	q9
+
+	s1l		.req	d20
+	s1h		.req	d21
+	s2l		.req	d22
+	s2h		.req	d23
+	s3l		.req	d24
+	s3h		.req	d25
+	s4l		.req	d26
+	s4h		.req	d27
+
+	SHASH2_p8	.req	d28
+
+	k16		.req	d29
+	k32		.req	d30
+	k48		.req	d31
+
+	T2		.req	q7
+
+	.text
+
+	/*
+	 * This implementation of 64x64 -> 128 bit polynomial multiplication
+	 * using vmull.p8 instructions (8x8 -> 16) is taken from the paper
+	 * "Fast Software Polynomial Multiplication on ARM Processors Using
+	 * the NEON Engine" by Danilo Camara, Conrado Gouvea, Julio Lopez and
+	 * Ricardo Dahab (https://hal.inria.fr/hal-01506572)
+	 *
+	 * It has been slightly tweaked for in-order performance, and to allow
+	 * 'rq' to overlap with 'ad' or 'bd'.
+	 */
+	.macro		__pmull_p8, rq, ad, bd, b1=t4l, b2=t3l, b3=t4l, b4=t3l
+	vext.8		t0l, \ad, \ad, #1	@ A1
+	.ifc		\b1, t4l
+	vext.8		t4l, \bd, \bd, #1	@ B1
+	.endif
+	vmull.p8	t0q, t0l, \bd		@ F = A1*B
+	vext.8		t1l, \ad, \ad, #2	@ A2
+	vmull.p8	t4q, \ad, \b1		@ E = A*B1
+	.ifc		\b2, t3l
+	vext.8		t3l, \bd, \bd, #2	@ B2
+	.endif
+	vmull.p8	t1q, t1l, \bd		@ H = A2*B
+	vext.8		t2l, \ad, \ad, #3	@ A3
+	vmull.p8	t3q, \ad, \b2		@ G = A*B2
+	veor		t0q, t0q, t4q		@ L = E + F
+	.ifc		\b3, t4l
+	vext.8		t4l, \bd, \bd, #3	@ B3
+	.endif
+	vmull.p8	t2q, t2l, \bd		@ J = A3*B
+	veor		t0l, t0l, t0h		@ t0 = (L) (P0 + P1) << 8
+	veor		t1q, t1q, t3q		@ M = G + H
+	.ifc		\b4, t3l
+	vext.8		t3l, \bd, \bd, #4	@ B4
+	.endif
+	vmull.p8	t4q, \ad, \b3		@ I = A*B3
+	veor		t1l, t1l, t1h		@ t1 = (M) (P2 + P3) << 16
+	vmull.p8	t3q, \ad, \b4		@ K = A*B4
+	vand		t0h, t0h, k48
+	vand		t1h, t1h, k32
+	veor		t2q, t2q, t4q		@ N = I + J
+	veor		t0l, t0l, t0h
+	veor		t1l, t1l, t1h
+	veor		t2l, t2l, t2h		@ t2 = (N) (P4 + P5) << 24
+	vand		t2h, t2h, k16
+	veor		t3l, t3l, t3h		@ t3 = (K) (P6 + P7) << 32
+	vmov.i64	t3h, #0
+	vext.8		t0q, t0q, t0q, #15
+	veor		t2l, t2l, t2h
+	vext.8		t1q, t1q, t1q, #14
+	vmull.p8	\rq, \ad, \bd		@ D = A*B
+	vext.8		t2q, t2q, t2q, #13
+	vext.8		t3q, t3q, t3q, #12
+	veor		t0q, t0q, t1q
+	veor		t2q, t2q, t3q
+	veor		\rq, \rq, t0q
+	veor		\rq, \rq, t2q
+	.endm
+
+	.macro		__pmull_reduce_p8
+	veor		XL_H, XL_H, XM_L
+	veor		XH_L, XH_L, XM_H
+
+	vshl.i64	T1, XL, #57
+	vshl.i64	T2, XL, #62
+	veor		T1, T1, T2
+	vshl.i64	T2, XL, #63
+	veor		T1, T1, T2
+	veor		XL_H, XL_H, T1_L
+	veor		XH_L, XH_L, T1_H
+
+	vshr.u64	T1, XL, #1
+	veor		XH, XH, XL
+	veor		XL, XL, T1
+	vshr.u64	T1, T1, #6
+	vshr.u64	XL, XL, #1
+	.endm
+
+	.macro		ghash_update
+	vld1.64		{XL}, [r1]
+
+	/* do the head block first, if supplied */
+	ldr		ip, [sp]
+	teq		ip, #0
+	beq		0f
+	vld1.64		{T1}, [ip]
+	teq		r0, #0
+	b		3f
+
+0:
+	vld1.8		{T1}, [r2]!
+	subs		r0, r0, #1
+
+3:	/* multiply XL by SHASH in GF(2^128) */
+	vrev64.8	T1, T1
+
+	vext.8		IN1, T1, T1, #8
+	veor		T1_L, T1_L, XL_H
+	veor		XL, XL, IN1
+
+	__pmull_p8	XH, XL_H, SHASH_H, s1h, s2h, s3h, s4h	@ a1 * b1
+	veor		T1, T1, XL
+	__pmull_p8	XL, XL_L, SHASH_L, s1l, s2l, s3l, s4l	@ a0 * b0
+	__pmull_p8	XM, T1_L, SHASH2_p8			@ (a1+a0)(b1+b0)
+
+	veor		T1, XL, XH
+	veor		XM, XM, T1
+
+	__pmull_reduce_p8
+
+	veor		T1, T1, XH
+	veor		XL, XL, T1
+
+	bne		0b
+	.endm
+
+	/*
+	 * void pmull_ghash_update_p8(int blocks, u64 dg[], const char *src,
+	 *			      u64 const h[1][2], const char *head)
+	 */
+ENTRY(pmull_ghash_update_p8)
+	vld1.64		{SHASH}, [r3]
+	veor		SHASH2_p8, SHASH_L, SHASH_H
+
+	vext.8		s1l, SHASH_L, SHASH_L, #1
+	vext.8		s2l, SHASH_L, SHASH_L, #2
+	vext.8		s3l, SHASH_L, SHASH_L, #3
+	vext.8		s4l, SHASH_L, SHASH_L, #4
+	vext.8		s1h, SHASH_H, SHASH_H, #1
+	vext.8		s2h, SHASH_H, SHASH_H, #2
+	vext.8		s3h, SHASH_H, SHASH_H, #3
+	vext.8		s4h, SHASH_H, SHASH_H, #4
+
+	vmov.i64	k16, #0xffff
+	vmov.i64	k32, #0xffffffff
+	vmov.i64	k48, #0xffffffffffff
+
+	ghash_update
+	vst1.64		{XL}, [r1]
+
+	bx		lr
+ENDPROC(pmull_ghash_update_p8)
-- 
2.53.0

