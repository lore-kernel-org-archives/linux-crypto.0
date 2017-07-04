From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 1/2] crypto: arm/ghash - add NEON accelerated fallback for vmull.p64
Date: Wed,  5 Jul 2017 00:43:18 +0100
Message-ID: <20170704234319.8398-1-ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, steve.capper@Linaro.org,
        herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:32832 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752346AbdGDXn3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Jul 2017 19:43:29 -0400
Received: by mail-wm0-f46.google.com with SMTP id t70so201231wmt.0
        for <linux-crypto@vger.kernel.org>; Tue, 04 Jul 2017 16:43:28 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Implement a NEON fallback for systems that do support NEON but have
no support for the optional 64x64->128 polynomial multiplication
instruction that is part of the ARMv8 Crypto Extensions. It is based
on the paper "Fast Software Polynomial Multiplication on ARM Processors
Using the NEON Engine" by Danilo Camara, Conrado Gouvea, Julio Lopez and
Ricardo Dahab (https://hal.inria.fr/hal-01506572)

On a 32-bit guest executing under KVM on a Cortex-A57, the new code is
not only 4x faster than the generic table based GHASH driver, it is also
time invariant. (Note that the existing vmull.p64 code is 16x faster on
this core).

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
v2:
- use alternative reduction

 arch/arm/crypto/Kconfig         |   5 +-
 arch/arm/crypto/ghash-ce-core.S | 132 ++++++++++++++++++--
 arch/arm/crypto/ghash-ce-glue.c |  24 +++-
 3 files changed, 145 insertions(+), 16 deletions(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index d8f3336bfc88..0b960ed124ae 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -106,14 +106,15 @@ config CRYPTO_AES_ARM_CE
 	  ARMv8 Crypto Extensions
 
 config CRYPTO_GHASH_ARM_CE
-	tristate "PMULL-accelerated GHASH using ARMv8 Crypto Extensions"
+	tristate "PMULL-accelerated GHASH using NEON/ARMv8 Crypto Extensions"
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_HASH
 	select CRYPTO_CRYPTD
 	help
 	  Use an implementation of GHASH (used by the GCM AEAD chaining mode)
 	  that uses the 64x64 to 128 bit polynomial multiplication (vmull.p64)
-	  that is part of the ARMv8 Crypto Extensions
+	  that is part of the ARMv8 Crypto Extensions, or a slower variant that
+	  uses the vmull.p8 instruction that is part of the basic NEON ISA.
 
 config CRYPTO_CRCT10DIF_ARM_CE
 	tristate "CRCT10DIF digest algorithm using PMULL instructions"
diff --git a/arch/arm/crypto/ghash-ce-core.S b/arch/arm/crypto/ghash-ce-core.S
index f6ab8bcc9efe..7c7ee9be14ff 100644
--- a/arch/arm/crypto/ghash-ce-core.S
+++ b/arch/arm/crypto/ghash-ce-core.S
@@ -1,7 +1,7 @@
 /*
- * Accelerated GHASH implementation with ARMv8 vmull.p64 instructions.
+ * Accelerated GHASH implementation with NEON/ARMv8 vmull.p8/64 instructions.
  *
- * Copyright (C) 2015 Linaro Ltd. <ard.biesheuvel@linaro.org>
+ * Copyright (C) 2015 - 2017 Linaro Ltd. <ard.biesheuvel@linaro.org>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License version 2 as published
@@ -25,6 +25,8 @@
 	SHASH_H		.req	d1
 	SHASH2_L	.req	d2
 	T1_L		.req	d4
+	T2_L		.req	d6
+	T2_H		.req	d7
 	MASK_L		.req	d8
 	XL_L		.req	d10
 	XL_H		.req	d11
@@ -32,14 +34,85 @@
 	XM_H		.req	d13
 	XH_L		.req	d14
 
+	k16		.req	d19
+	k32		.req	d20
+	k48		.req	d21
+
+	t0l		.req	d22
+	t0h		.req	d23
+	t1l		.req	d24
+	t1h		.req	d25
+	t2l		.req	d26
+	t2h		.req	d27
+	t3l		.req	d28
+	t3h		.req	d29
+	t4l		.req	d30
+	t4h		.req	d31
+
+	t0q		.req	q11
+	t1q		.req	q12
+	t2q		.req	q13
+	t3q		.req	q14
+	t4q		.req	q15
+
 	.text
 	.fpu		crypto-neon-fp-armv8
 
 	/*
-	 * void pmull_ghash_update(int blocks, u64 dg[], const char *src,
-	 *			   struct ghash_key const *k, const char *head)
+	 * This implementation of 64x64 -> 128 bit polynomial multiplication
+	 * using vmull.p8 instructions (8x8 -> 16) is taken from the paper
+	 * "Fast Software Polynomial Multiplication on ARM Processors Using
+	 * the NEON Engine" by Danilo Camara, Conrado Gouvea, Julio Lopez and
+	 * Ricardo Dahab (https://hal.inria.fr/hal-01506572)
+	 *
+	 * It has been slightly tweaked for in-order performance, and to allow
+	 * 'rq' to overlap with 'ad' or 'bd'.
 	 */
-ENTRY(pmull_ghash_update)
+	.macro		__pmull_p8, rq, ad, bd
+	vext.8		t0l, \ad, \ad, #1	@ A1
+	vext.8		t4l, \bd, \bd, #1	@ B1
+	vmull.p8	t0q, t0l, \bd		@ F = A1*B
+	vext.8		t1l, \ad, \ad, #2	@ A2
+	vmull.p8	t4q, \ad, t4l		@ E = A*B1
+	vext.8		t3l, \bd, \bd, #2	@ B2
+	vmull.p8	t1q, t1l, \bd		@ H = A2*B
+	vext.8		t2l, \ad, \ad, #3	@ A3
+	vmull.p8	t3q, \ad, t3l		@ G = A*B2
+	veor		t0q, t0q, t4q		@ L = E + F
+	vext.8		t4l, \bd, \bd, #3	@ B3
+	vmull.p8	t2q, t2l, \bd		@ J = A3*B
+	veor		t0l, t0l, t0h		@ t0 = (L) (P0 + P1) << 8
+	veor		t1q, t1q, t3q		@ M = G + H
+	vext.8		t3l, \bd, \bd, #4	@ B4
+	vmull.p8	t4q, \ad, t4l		@ I = A*B3
+	veor		t1l, t1l, t1h		@ t1 = (M) (P2 + P3) << 16
+	vmull.p8	t3q, \ad, t3l		@ K = A*B4
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
+	.macro		__pmull_p64, rd, rn, rm
+	vmull.p64	\rd, \rn, \rm
+	.endm
+
+	.macro		ghash_update, pn
 	vld1.64		{SHASH}, [r3]
 	vld1.64		{XL}, [r1]
 	vmov.i8		MASK, #0xe1
@@ -67,15 +140,17 @@ ENTRY(pmull_ghash_update)
 	veor		T1, T1, T2
 	veor		XL, XL, IN1
 
-	vmull.p64	XH, SHASH_H, XL_H		@ a1 * b1
+	__pmull_\pn	XH, SHASH_H, XL_H		@ a1 * b1
 	veor		T1, T1, XL
-	vmull.p64	XL, SHASH_L, XL_L		@ a0 * b0
-	vmull.p64	XM, SHASH2_L, T1_L		@ (a1 + a0)(b1 + b0)
+	__pmull_\pn	XL, SHASH_L, XL_L		@ a0 * b0
+	__pmull_\pn	XM, SHASH2_L, T1_L		@ (a1 + a0)(b1 + b0)
 
-	vext.8		T1, XL, XH, #8
 	veor		T2, XL, XH
-	veor		XM, XM, T1
 	veor		XM, XM, T2
+
+	.ifc		\pn, p64
+	vext.8		T1, XL, XH, #8
+	veor		XM, XM, T1
 	vmull.p64	T2, XL_L, MASK_L
 
 	vmov		XH_L, XM_H
@@ -84,6 +159,25 @@ ENTRY(pmull_ghash_update)
 	veor		XL, XM, T2
 	vext.8		T2, XL, XL, #8
 	vmull.p64	XL, XL_L, MASK_L
+	.else
+	veor		XL_H, XL_H, XM_L
+	veor		XH_L, XH_L, XM_H
+
+	vshl.i64	T2, XL, #1
+	veor		T2, T2, XL
+	vshl.i64	T2, T2, #5
+	veor		T2, T2, XL
+	vshl.i64	T2, T2, #57
+	veor		XL_H, XL_H, T2_L
+	veor		XH_L, XH_L, T2_H
+
+	vshr.u64	T2, XL, #5
+	veor		T2, T2, XL
+	vshr.u64	T2, T2, #1
+	veor		T2, T2, XL
+	vshr.u64	T2, T2, #1
+	.endif
+
 	veor		T2, T2, XH
 	veor		XL, XL, T2
 
@@ -91,4 +185,20 @@ ENTRY(pmull_ghash_update)
 
 	vst1.64		{XL}, [r1]
 	bx		lr
-ENDPROC(pmull_ghash_update)
+	.endm
+
+	/*
+	 * void pmull_ghash_update(int blocks, u64 dg[], const char *src,
+	 *			   struct ghash_key const *k, const char *head)
+	 */
+ENTRY(pmull_ghash_update_p64)
+	ghash_update	p64
+ENDPROC(pmull_ghash_update_p64)
+
+ENTRY(pmull_ghash_update_p8)
+	vmov.i64	k16, #0xffff
+	vmov.i64	k32, #0xffffffff
+	vmov.i64	k48, #0xffffffffffff
+
+	ghash_update	p8
+ENDPROC(pmull_ghash_update_p8)
diff --git a/arch/arm/crypto/ghash-ce-glue.c b/arch/arm/crypto/ghash-ce-glue.c
index 6bac8bea9f1e..d9bb52cae2ac 100644
--- a/arch/arm/crypto/ghash-ce-glue.c
+++ b/arch/arm/crypto/ghash-ce-glue.c
@@ -22,6 +22,7 @@
 MODULE_DESCRIPTION("GHASH secure hash using ARMv8 Crypto Extensions");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
+MODULE_ALIAS_CRYPTO("ghash");
 
 #define GHASH_BLOCK_SIZE	16
 #define GHASH_DIGEST_SIZE	16
@@ -41,8 +42,17 @@ struct ghash_async_ctx {
 	struct cryptd_ahash *cryptd_tfm;
 };
 
-asmlinkage void pmull_ghash_update(int blocks, u64 dg[], const char *src,
-				   struct ghash_key const *k, const char *head);
+asmlinkage void pmull_ghash_update_p64(int blocks, u64 dg[], const char *src,
+				       struct ghash_key const *k,
+				       const char *head);
+
+asmlinkage void pmull_ghash_update_p8(int blocks, u64 dg[], const char *src,
+				      struct ghash_key const *k,
+				      const char *head);
+
+static void (*pmull_ghash_update)(int blocks, u64 dg[], const char *src,
+				  struct ghash_key const *k,
+				  const char *head);
 
 static int ghash_init(struct shash_desc *desc)
 {
@@ -312,6 +322,14 @@ static int __init ghash_ce_mod_init(void)
 {
 	int err;
 
+	if (!(elf_hwcap & HWCAP_NEON))
+		return -ENODEV;
+
+	if (elf_hwcap2 & HWCAP2_PMULL)
+		pmull_ghash_update = pmull_ghash_update_p64;
+	else
+		pmull_ghash_update = pmull_ghash_update_p8;
+
 	err = crypto_register_shash(&ghash_alg);
 	if (err)
 		return err;
@@ -332,5 +350,5 @@ static void __exit ghash_ce_mod_exit(void)
 	crypto_unregister_shash(&ghash_alg);
 }
 
-module_cpu_feature_match(PMULL, ghash_ce_mod_init);
+module_init(ghash_ce_mod_init);
 module_exit(ghash_ce_mod_exit);
-- 
2.9.3
