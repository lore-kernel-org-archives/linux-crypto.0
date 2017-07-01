From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFT PATCH] crypto: arm/ghash - add NEON accelerated fallback for vmull.p64
Date: Sat,  1 Jul 2017 15:17:40 +0000
Message-ID: <20170701151740.9513-1-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37228 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751952AbdGAPRz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 1 Jul 2017 11:17:55 -0400
Received: by mail-wm0-f51.google.com with SMTP id i127so70987403wma.0
        for <linux-crypto@vger.kernel.org>; Sat, 01 Jul 2017 08:17:54 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Implement a NEON fallback for systems that do support NEON but have
no support for the optional 64x64->128 polynomial multiplication
instruction that is part of the ARMv8 Crypto Extensions. It is based
on the paper "Fast Software Polynomial Multiplication on ARM Processors
Using the NEON Engine" by Danilo Camara, Conrado Gouvea, Julio Lopez and
Ricardo Dahab (https://hal.inria.fr/hal-01506572)

On a 32-bit guest executing under KVM on a Cortex-A57, the new code is
not only >3x faster than the generic table based GHASH driver, it is also
time invariant. (Note that the existing vmull.p64 code is 16x faster on
this core).

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---

Raw numbers for a 2 GHz AMD Seattle (A57 r1p2) after the patch.

 arch/arm/crypto/Kconfig         |   5 +-
 arch/arm/crypto/ghash-ce-core.S | 110 +++++++++++++++++---
 arch/arm/crypto/ghash-ce-glue.c |  24 ++++-
 3 files changed, 119 insertions(+), 20 deletions(-)

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
index f6ab8bcc9efe..a017a9213f7e 100644
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
@@ -20,26 +20,90 @@
 	XM		.req	q6
 	XH		.req	q7
 	IN1		.req	q7
+	T3		.req	q8
 
 	SHASH_L		.req	d0
 	SHASH_H		.req	d1
 	SHASH2_L	.req	d2
 	T1_L		.req	d4
+	T2_L		.req	d6
 	MASK_L		.req	d8
 	XL_L		.req	d10
 	XL_H		.req	d11
 	XM_L		.req	d12
 	XM_H		.req	d13
 	XH_L		.req	d14
+	T3_L		.req	d16
+
+	k16		.req	d21
+	k32		.req	d22
+	k48		.req	d23
+
+	t0l		.req	d24
+	t0h		.req	d25
+	t1l		.req	d26
+	t1h		.req	d27
+	t2l		.req	d28
+	t2h		.req	d29
+	t3l		.req	d30
+	t3h		.req	d31
+
+	t0q		.req	q12
+	t1q		.req	q13
+	t2q		.req	q14
+	t3q		.req	q15
 
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
 	 */
-ENTRY(pmull_ghash_update)
+	.macro		vmull_p64, rq, ad, bd
+	vext.8		t0l, \ad, \ad, #1	@ A1
+	vmull.p8	t0q, t0l, \bd		@ F = A1*B
+	vext.8		\rq\()_L, \bd, \bd, #1	@ B1
+	vmull.p8	\rq, \ad, \rq\()_L	@ E = A*B1
+	vext.8		t1l, \ad, \ad, #2	@ A2
+	vmull.p8	t1q, t1l, \bd		@ H = A2*B
+	vext.8		t3l, \bd, \bd, #2	@ B2
+	vmull.p8	t3q, \ad, t3l		@ G = A*B2
+	vext.8		t2l, \ad, \ad, #3	@ A3
+	vmull.p8	t2q, t2l, \bd		@ J = A3*B
+	veor		t0q, t0q, \rq		@ L = E + F
+	vext.8		\rq\()_L, \bd, \bd, #3	@ B3
+	vmull.p8	\rq, \ad, \rq\()_L	@ I = A*B3
+	veor		t1q, t1q, t3q		@ M = G + H
+	vext.8		t3l, \bd, \bd, #4	@ B4
+	vmull.p8	t3q, \ad, t3l		@ K = A*B4
+	veor		t0l, t0l, t0h		@ t0 = (L) (P0 + P1) << 8
+	vand		t0h, t0h, k48
+	veor		t1l, t1l, t1h		@ t1 = (M) (P2 + P3) << 16
+	vand		t1h, t1h, k32
+	veor		t2q, t2q, \rq		@ N = I + J
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
+	.macro		ghash_update, vp64
 	vld1.64		{SHASH}, [r3]
 	vld1.64		{XL}, [r1]
 	vmov.i8		MASK, #0xe1
@@ -67,28 +131,44 @@ ENTRY(pmull_ghash_update)
 	veor		T1, T1, T2
 	veor		XL, XL, IN1
 
-	vmull.p64	XH, SHASH_H, XL_H		@ a1 * b1
+	\vp64		XH, SHASH_H, XL_H		@ a1 * b1
 	veor		T1, T1, XL
-	vmull.p64	XL, SHASH_L, XL_L		@ a0 * b0
-	vmull.p64	XM, SHASH2_L, T1_L		@ (a1 + a0)(b1 + b0)
+	\vp64		T3, SHASH_L, XL_L		@ a0 * b0
+	\vp64		XM, SHASH2_L, T1_L		@ (a1 + a0)(b1 + b0)
 
-	vext.8		T1, XL, XH, #8
-	veor		T2, XL, XH
+	vext.8		T1, T3, XH, #8
+	veor		T2, T3, XH
 	veor		XM, XM, T1
 	veor		XM, XM, T2
-	vmull.p64	T2, XL_L, MASK_L
+	\vp64		T2, T3_L, MASK_L
 
 	vmov		XH_L, XM_H
-	vmov		XM_H, XL_L
+	vmov		XM_H, T3_L
 
 	veor		XL, XM, T2
 	vext.8		T2, XL, XL, #8
-	vmull.p64	XL, XL_L, MASK_L
+	\vp64		T1, XL_L, MASK_L
 	veor		T2, T2, XH
-	veor		XL, XL, T2
+	veor		XL, T1, T2
 
 	bne		0b
 
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
+	ghash_update	vmull.p64
+ENDPROC(pmull_ghash_update_p64)
+
+ENTRY(pmull_ghash_update_p8)
+	vmov.i64	k16, #0xffff
+	vmov.i64	k32, #0xffffffff
+	vmov.i64	k48, #0xffffffffffff
+
+	ghash_update	vmull_p64
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

Generic
-------
 0 (  1 x   16 =   16 bytes): 2935029 opers/sec,  46960464 bytes/sec
 1 (  4 x   16 =   64 bytes):  755992 opers/sec,  48383488 bytes/sec
 2 (  1 x   64 =   64 bytes):  885186 opers/sec,  56651904 bytes/sec
 3 ( 16 x   16 =  256 bytes):  194153 opers/sec,  49703168 bytes/sec
 4 (  4 x   64 =  256 bytes):  224917 opers/sec,  57578752 bytes/sec
 5 (  1 x  256 =  256 bytes):  241253 opers/sec,  61760768 bytes/sec
 6 ( 64 x   16 = 1024 bytes):   49550 opers/sec,  50739200 bytes/sec
 7 (  4 x  256 = 1024 bytes):   60396 opers/sec,  61845504 bytes/sec
 8 (  1 x 1024 = 1024 bytes):   61320 opers/sec,  62791680 bytes/sec
 9 (128 x   16 = 2048 bytes):   24809 opers/sec,  50808832 bytes/sec
10 (  8 x  256 = 2048 bytes):   30236 opers/sec,  61923328 bytes/sec
11 (  2 x 1024 = 2048 bytes):   30654 opers/sec,  62779392 bytes/sec
12 (  1 x 2048 = 2048 bytes):   30791 opers/sec,  63059968 bytes/sec
13 (256 x   16 = 4096 bytes):   12402 opers/sec,  50798592 bytes/sec
14 ( 16 x  256 = 4096 bytes):   15128 opers/sec,  61964288 bytes/sec
15 (  4 x 1024 = 4096 bytes):   15334 opers/sec,  62808064 bytes/sec
16 (  1 x 4096 = 4096 bytes):   15400 opers/sec,  63078400 bytes/sec
17 (512 x   16 = 8192 bytes):    6199 opers/sec,  50782208 bytes/sec
18 ( 32 x  256 = 8192 bytes):    7566 opers/sec,  61980672 bytes/sec
19 (  8 x 1024 = 8192 bytes):    7672 opers/sec,  62849024 bytes/sec
20 (  2 x 4096 = 8192 bytes):    7710 opers/sec,  63160320 bytes/sec
21 (  1 x 8192 = 8192 bytes):    7088 opers/sec,  58064896 bytes/sec


vmull.p8
--------
 0 (  1 x   16 =   16 bytes): 3677447 opers/sec,  58839152 bytes/sec
 1 (  4 x   16 =   64 bytes):  998104 opers/sec,  63878656 bytes/sec
 2 (  1 x   64 =   64 bytes): 1968136 opers/sec, 125960704 bytes/sec
 3 ( 16 x   16 =  256 bytes):  263350 opers/sec,  67417600 bytes/sec
 4 (  4 x   64 =  256 bytes):  500690 opers/sec, 128176640 bytes/sec
 5 (  1 x  256 =  256 bytes):  673571 opers/sec, 172434176 bytes/sec
 6 ( 64 x   16 = 1024 bytes):   65698 opers/sec,  67274752 bytes/sec
 7 (  4 x  256 = 1024 bytes):  171073 opers/sec, 175178752 bytes/sec
 8 (  1 x 1024 = 1024 bytes):  185430 opers/sec, 189880320 bytes/sec
 9 (128 x   16 = 2048 bytes):   33761 opers/sec,  69142528 bytes/sec
10 (  8 x  256 = 2048 bytes):   86010 opers/sec, 176148480 bytes/sec
11 (  2 x 1024 = 2048 bytes):   92724 opers/sec, 189898752 bytes/sec
12 (  1 x 2048 = 2048 bytes):   95416 opers/sec, 195411968 bytes/sec
13 (256 x   16 = 4096 bytes):   16887 opers/sec,  69169152 bytes/sec
14 ( 16 x  256 = 4096 bytes):   43145 opers/sec, 176721920 bytes/sec
15 (  4 x 1024 = 4096 bytes):   46462 opers/sec, 190308352 bytes/sec
16 (  1 x 4096 = 4096 bytes):   47651 opers/sec, 195178496 bytes/sec
17 (512 x   16 = 8192 bytes):    8452 opers/sec,  69238784 bytes/sec
18 ( 32 x  256 = 8192 bytes):   21581 opers/sec, 176791552 bytes/sec
19 (  8 x 1024 = 8192 bytes):   23264 opers/sec, 190578688 bytes/sec
20 (  2 x 4096 = 8192 bytes):   23896 opers/sec, 195756032 bytes/sec
21 (  1 x 8192 = 8192 bytes):   22950 opers/sec, 188006400 bytes/sec

vmull.p64
---------
 0 (  1 x   16 =   16 bytes): 4896330 opers/sec,  78341280 bytes/sec
 1 (  4 x   16 =   64 bytes): 1340210 opers/sec,  85773440 bytes/sec
 2 (  1 x   64 =   64 bytes): 3646331 opers/sec, 233365184 bytes/sec
 3 ( 16 x   16 =  256 bytes):  364655 opers/sec,  93351680 bytes/sec
 4 (  4 x   64 =  256 bytes): 1054796 opers/sec, 270027776 bytes/sec
 5 (  1 x  256 =  256 bytes): 2196935 opers/sec, 562415360 bytes/sec
 6 ( 64 x   16 = 1024 bytes):   93104 opers/sec,  95338496 bytes/sec
 7 (  4 x  256 = 1024 bytes):  575183 opers/sec, 588987392 bytes/sec
 8 (  1 x 1024 = 1024 bytes):  801655 opers/sec, 820894720 bytes/sec
 9 (128 x   16 = 2048 bytes):   46715 opers/sec,  95672320 bytes/sec
10 (  8 x  256 = 2048 bytes):  293469 opers/sec, 601024512 bytes/sec
11 (  2 x 1024 = 2048 bytes):  401675 opers/sec, 822630400 bytes/sec
12 (  1 x 2048 = 2048 bytes):  434725 opers/sec, 890316800 bytes/sec
13 (256 x   16 = 4096 bytes):   23353 opers/sec,  95653888 bytes/sec
14 ( 16 x  256 = 4096 bytes):  148155 opers/sec, 606842880 bytes/sec
15 (  4 x 1024 = 4096 bytes):  203664 opers/sec, 834207744 bytes/sec
16 (  1 x 4096 = 4096 bytes):  226047 opers/sec, 925888512 bytes/sec
17 (512 x   16 = 8192 bytes):   11695 opers/sec,  95805440 bytes/sec
18 ( 32 x  256 = 8192 bytes):   74366 opers/sec, 609206272 bytes/sec
19 (  8 x 1024 = 8192 bytes):  102665 opers/sec, 841031680 bytes/sec
20 (  2 x 4096 = 8192 bytes):  113337 opers/sec, 928456704 bytes/sec
21 (  1 x 8192 = 8192 bytes):  113695 opers/sec, 931389440 bytes/sec
