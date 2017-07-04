From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 2/2] crypto: arm64/ghash - add NEON accelerated fallback for 64-bit PMULL
Date: Wed,  5 Jul 2017 00:43:19 +0100
Message-ID: <20170704234319.8398-2-ard.biesheuvel@linaro.org>
References: <20170704234319.8398-1-ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, steve.capper@Linaro.org,
        herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:36027 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752346AbdGDXnb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Jul 2017 19:43:31 -0400
Received: by mail-wm0-f42.google.com with SMTP id 62so207658683wmw.1
        for <linux-crypto@vger.kernel.org>; Tue, 04 Jul 2017 16:43:31 -0700 (PDT)
In-Reply-To: <20170704234319.8398-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Implement a NEON fallback for systems that do support NEON but have
no support for the optional 64x64->128 polynomial multiplication
instruction that is part of the ARMv8 Crypto Extensions. It is based
on the paper "Fast Software Polynomial Multiplication on ARM Processors
Using the NEON Engine" by Danilo Camara, Conrado Gouvea, Julio Lopez and
Ricardo Dahab (https://hal.inria.fr/hal-01506572), but has been reworked
extensively for the AArch64 ISA.

On a low-end core such as the Cortex-A53 found in the Raspberry Pi3, the
NEON based implementation is 4x faster than the table based one, and
is time invariant as well, making it less vulnerable to timing attacks.
When combined with the bit-sliced NEON implementation of AES-CTR, the
AES-GCM performance increases by ~2x (from 58 to 30 cycles per byte).

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
v2:
- use alternative reduction and precomputed coefficients for loop invariants
- refactor asm macros for better legibility

 arch/arm64/crypto/ghash-ce-core.S | 251 +++++++++++++++++---
 arch/arm64/crypto/ghash-ce-glue.c |  40 +++-
 2 files changed, 255 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/crypto/ghash-ce-core.S b/arch/arm64/crypto/ghash-ce-core.S
index cb22459eba85..5d40b99ca3ac 100644
--- a/arch/arm64/crypto/ghash-ce-core.S
+++ b/arch/arm64/crypto/ghash-ce-core.S
@@ -1,7 +1,7 @@
 /*
  * Accelerated GHASH implementation with ARMv8 PMULL instructions.
  *
- * Copyright (C) 2014 Linaro Ltd. <ard.biesheuvel@linaro.org>
+ * Copyright (C) 2014 - 2017 Linaro Ltd. <ard.biesheuvel@linaro.org>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License version 2 as published
@@ -11,31 +11,219 @@
 #include <linux/linkage.h>
 #include <asm/assembler.h>
 
-	SHASH	.req	v0
-	SHASH2	.req	v1
-	T1	.req	v2
-	T2	.req	v3
-	MASK	.req	v4
-	XL	.req	v5
-	XM	.req	v6
-	XH	.req	v7
-	IN1	.req	v7
+	SHASH		.req	v0
+	SHASH2		.req	v1
+	T1		.req	v2
+	T2		.req	v3
+	MASK		.req	v4
+	XL		.req	v5
+	XM		.req	v6
+	XH		.req	v7
+	IN1		.req	v7
+
+	k00_16		.req	v8
+	k32_48		.req	v9
+
+	t3		.req	v10
+	t4		.req	v11
+	t5		.req	v12
+	t6		.req	v13
+	t7		.req	v14
+	t8		.req	v15
+	t9		.req	v16
+
+	perm1		.req	v17
+	perm2		.req	v18
+	perm3		.req	v19
+
+	sh1		.req	v20
+	sh2		.req	v21
+	sh3		.req	v22
+	sh4		.req	v23
+
+	ss1		.req	v24
+	ss2		.req	v25
+	ss3		.req	v26
+	ss4		.req	v27
+
+	VZR		.req	v28
 
 	.text
 	.arch		armv8-a+crypto
 
-	/*
-	 * void pmull_ghash_update(int blocks, u64 dg[], const char *src,
-	 *			   struct ghash_key const *k, const char *head)
-	 */
-ENTRY(pmull_ghash_update)
+	.macro		__pmull_p64, rd, rn, rm
+	pmull		\rd\().1q, \rn\().1d, \rm\().1d
+	.endm
+
+	.macro		__pmull2_p64, rd, rn, rm
+	pmull2		\rd\().1q, \rn\().2d, \rm\().2d
+	.endm
+
+	.macro		__pmull_p8, rq, ad, bd
+	ext		t3.8b, \ad\().8b, \ad\().8b, #1		// A1
+	ext		t5.8b, \ad\().8b, \ad\().8b, #2		// A2
+	ext		t7.8b, \ad\().8b, \ad\().8b, #3		// A3
+
+	__pmull_p8_\bd	\rq, \ad
+	.endm
+
+	.macro		__pmull2_p8, rq, ad, bd
+	tbl		t3.16b, {\ad\().16b}, perm1.16b		// A1
+	tbl		t5.16b, {\ad\().16b}, perm2.16b		// A2
+	tbl		t7.16b, {\ad\().16b}, perm3.16b		// A3
+
+	__pmull2_p8_\bd	\rq, \ad
+	.endm
+
+	.macro		__pmull_p8_SHASH, rq, ad
+	__pmull_p8_tail	\rq, \ad\().8b, SHASH.8b, 8b,, sh1, sh2, sh3, sh4
+	.endm
+
+	.macro		__pmull_p8_SHASH2, rq, ad
+	__pmull_p8_tail	\rq, \ad\().8b, SHASH2.8b, 8b,, ss1, ss2, ss3, ss4
+	.endm
+
+	.macro		__pmull2_p8_SHASH, rq, ad
+	__pmull_p8_tail	\rq, \ad\().16b, SHASH.16b, 16b, 2, sh1, sh2, sh3, sh4
+	.endm
+
+	.macro		__pmull_p8_tail, rq, ad, bd, nb, t, b1, b2, b3, b4
+	pmull\t		t3.8h, t3.\nb, \bd			// F = A1*B
+	pmull\t		t4.8h, \ad, \b1\().\nb			// E = A*B1
+	pmull\t		t5.8h, t5.\nb, \bd			// H = A2*B
+	pmull\t		t6.8h, \ad, \b2\().\nb			// G = A*B2
+	pmull\t		t7.8h, t7.\nb, \bd			// J = A3*B
+	pmull\t		t8.8h, \ad, \b3\().\nb			// I = A*B3
+	pmull\t		t9.8h, \ad, \b4\().\nb			// K = A*B4
+	pmull\t		\rq\().8h, \ad, \bd			// D = A*B
+
+	eor		t3.16b, t3.16b, t4.16b			// L = E + F
+	eor		t5.16b, t5.16b, t6.16b			// M = G + H
+	eor		t7.16b, t7.16b, t8.16b			// N = I + J
+
+	uzp1		t4.2d, t3.2d, t5.2d
+	uzp2		t3.2d, t3.2d, t5.2d
+	uzp1		t6.2d, t7.2d, t9.2d
+	uzp2		t7.2d, t7.2d, t9.2d
+
+	// t3 = (L) (P0 + P1) << 8
+	// t5 = (M) (P2 + P3) << 16
+	eor		t4.16b, t4.16b, t3.16b
+	and		t3.16b, t3.16b, k32_48.16b
+
+	// t7 = (N) (P4 + P5) << 24
+	// t9 = (K) (P6 + P7) << 32
+	eor		t6.16b, t6.16b, t7.16b
+	and		t7.16b, t7.16b, k00_16.16b
+
+	eor		t4.16b, t4.16b, t3.16b
+	eor		t6.16b, t6.16b, t7.16b
+
+	zip2		t5.2d, t4.2d, t3.2d
+	zip1		t3.2d, t4.2d, t3.2d
+	zip2		t9.2d, t6.2d, t7.2d
+	zip1		t7.2d, t6.2d, t7.2d
+
+	ext		t3.16b, t3.16b, t3.16b, #15
+	ext		t5.16b, t5.16b, t5.16b, #14
+	ext		t7.16b, t7.16b, t7.16b, #13
+	ext		t9.16b, t9.16b, t9.16b, #12
+
+	eor		t3.16b, t3.16b, t5.16b
+	eor		t7.16b, t7.16b, t9.16b
+	eor		\rq\().16b, \rq\().16b, t3.16b
+	eor		\rq\().16b, \rq\().16b, t7.16b
+	.endm
+
+	.macro		__pmull_pre_p64
+	movi		MASK.16b, #0xe1
+	shl		MASK.2d, MASK.2d, #57
+	.endm
+
+	.macro		__pmull_pre_p8
+	// k00_16 := 0x0000000000000000_000000000000ffff
+	// k32_48 := 0x00000000ffffffff_0000ffffffffffff
+	movi		k32_48.2d, #0xffffffff
+	mov		k32_48.h[2], k32_48.h[0]
+	ushr		k00_16.2d, k32_48.2d, #32
+
+	// prepare the permutation vectors
+	mov_q		x5, 0x080f0e0d0c0b0a09
+	movi		T1.8b, #8
+	dup		perm1.2d, x5
+	eor		perm1.16b, perm1.16b, T1.16b
+	ushr		perm2.2d, perm1.2d, #8
+	ushr		perm3.2d, perm1.2d, #16
+	ushr		T1.2d, perm1.2d, #24
+	sli		perm2.2d, perm1.2d, #56
+	sli		perm3.2d, perm1.2d, #48
+	sli		T1.2d, perm1.2d, #40
+
+	// precompute loop invariants
+	tbl		sh1.16b, {SHASH.16b}, perm1.16b
+	tbl		sh2.16b, {SHASH.16b}, perm2.16b
+	tbl		sh3.16b, {SHASH.16b}, perm3.16b
+	tbl		sh4.16b, {SHASH.16b}, T1.16b
+	ext		ss1.8b, SHASH2.8b, SHASH2.8b, #1
+	ext		ss2.8b, SHASH2.8b, SHASH2.8b, #2
+	ext		ss3.8b, SHASH2.8b, SHASH2.8b, #3
+	ext		ss4.8b, SHASH2.8b, SHASH2.8b, #4
+
+	movi		VZR.16b, #0
+	.endm
+
+	//
+	// PMULL (64x64->128) based reduction for CPUs that can do
+	// it in a single instruction.
+	//
+	.macro		__pmull_reduce_p64
+	ext		T1.16b, XL.16b, XH.16b, #8
+	pmull		T2.1q, XL.1d, MASK.1d
+	eor		XM.16b, XM.16b, T1.16b
+
+	mov		XH.d[0], XM.d[1]
+	mov		XM.d[1], XL.d[0]
+
+	eor		XL.16b, XM.16b, T2.16b
+	ext		T2.16b, XL.16b, XL.16b, #8
+	pmull		XL.1q, XL.1d, MASK.1d
+	.endm
+
+	//
+	// Alternative reduction for CPUs that lack support for the
+	// 64x64->128 PMULL instruction
+	//
+	.macro		__pmull_reduce_p8
+	ext		T2.16b, VZR.16b, XM.16b, #8
+	ext		XM.16b, XM.16b, VZR.16b, #8
+	eor		XL.16b, XL.16b, T2.16b
+	eor		XH.16b, XH.16b, XM.16b
+
+	shl		T2.2d, XL.2d, #1
+	eor		T2.16b, T2.16b, XL.16b
+	shl		T2.2d, T2.2d, #5
+	eor		T2.16b, T2.16b, XL.16b
+	shl		T2.2d, T2.2d, #57
+	ext		XM.16b, VZR.16b, T2.16b, #8
+	ext		T2.16b, T2.16b, VZR.16b, #8
+	eor		XL.16b, XL.16b, XM.16b
+	eor		XH.16b, XH.16b, T2.16b
+
+	ushr		T2.2d, XL.2d, #5
+	eor		T2.16b, T2.16b, XL.16b
+	ushr		T2.2d, T2.2d, #1
+	eor		T2.16b, T2.16b, XL.16b
+	ushr		T2.2d, T2.2d, #1
+	.endm
+
+	.macro		__pmull_ghash, pn
 	ld1		{SHASH.2d}, [x3]
 	ld1		{XL.2d}, [x1]
-	movi		MASK.16b, #0xe1
 	ext		SHASH2.16b, SHASH.16b, SHASH.16b, #8
-	shl		MASK.2d, MASK.2d, #57
 	eor		SHASH2.16b, SHASH2.16b, SHASH.16b
 
+	__pmull_pre_\pn
+
 	/* do the head block first, if supplied */
 	cbz		x4, 0f
 	ld1		{T1.2d}, [x4]
@@ -52,23 +240,16 @@ CPU_LE(	rev64		T1.16b, T1.16b	)
 	eor		T1.16b, T1.16b, T2.16b
 	eor		XL.16b, XL.16b, IN1.16b
 
-	pmull2		XH.1q, SHASH.2d, XL.2d		// a1 * b1
+	__pmull2_\pn	XH, XL, SHASH			// a1 * b1
 	eor		T1.16b, T1.16b, XL.16b
-	pmull		XL.1q, SHASH.1d, XL.1d		// a0 * b0
-	pmull		XM.1q, SHASH2.1d, T1.1d		// (a1 + a0)(b1 + b0)
+	__pmull_\pn 	XL, XL, SHASH			// a0 * b0
+	__pmull_\pn	XM, T1, SHASH2			// (a1 + a0)(b1 + b0)
 
-	ext		T1.16b, XL.16b, XH.16b, #8
 	eor		T2.16b, XL.16b, XH.16b
-	eor		XM.16b, XM.16b, T1.16b
 	eor		XM.16b, XM.16b, T2.16b
-	pmull		T2.1q, XL.1d, MASK.1d
 
-	mov		XH.d[0], XM.d[1]
-	mov		XM.d[1], XL.d[0]
+	__pmull_reduce_\pn
 
-	eor		XL.16b, XM.16b, T2.16b
-	ext		T2.16b, XL.16b, XL.16b, #8
-	pmull		XL.1q, XL.1d, MASK.1d
 	eor		T2.16b, T2.16b, XH.16b
 	eor		XL.16b, XL.16b, T2.16b
 
@@ -76,7 +257,19 @@ CPU_LE(	rev64		T1.16b, T1.16b	)
 
 	st1		{XL.2d}, [x1]
 	ret
-ENDPROC(pmull_ghash_update)
+	.endm
+
+	/*
+	 * void pmull_ghash_update(int blocks, u64 dg[], const char *src,
+	 *			   struct ghash_key const *k, const char *head)
+	 */
+ENTRY(pmull_ghash_update_p64)
+	__pmull_ghash	p64
+ENDPROC(pmull_ghash_update_p64)
+
+ENTRY(pmull_ghash_update_p8)
+	__pmull_ghash	p8
+ENDPROC(pmull_ghash_update_p8)
 
 	KS		.req	v8
 	CTR		.req	v9
diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
index 524dd5a5aca1..45d49d293d0d 100644
--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -26,6 +26,7 @@
 MODULE_DESCRIPTION("GHASH and AES-GCM using ARMv8 Crypto Extensions");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
+MODULE_ALIAS_CRYPTO("ghash");
 
 #define GHASH_BLOCK_SIZE	16
 #define GHASH_DIGEST_SIZE	16
@@ -48,8 +49,17 @@ struct gcm_aes_ctx {
 	struct ghash_key	ghash_key;
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
 
 asmlinkage void pmull_gcm_encrypt(int blocks, u64 dg[], u8 dst[],
 				  const u8 src[], struct ghash_key const *k,
@@ -554,13 +564,24 @@ static int __init ghash_ce_mod_init(void)
 {
 	int ret;
 
-	ret = crypto_register_aead(&gcm_aes_alg);
-	if (ret)
-		return ret;
+	if (!(elf_hwcap & HWCAP_ASIMD))
+		return -ENODEV;
+
+	if (elf_hwcap & HWCAP_PMULL)
+		pmull_ghash_update = pmull_ghash_update_p64;
+
+	else
+		pmull_ghash_update = pmull_ghash_update_p8;
 
 	ret = crypto_register_shash(&ghash_alg);
 	if (ret)
-		crypto_unregister_aead(&gcm_aes_alg);
+		return ret;
+
+	if (elf_hwcap & HWCAP_PMULL) {
+		ret = crypto_register_aead(&gcm_aes_alg);
+		if (ret)
+			crypto_unregister_shash(&ghash_alg);
+	}
 	return ret;
 }
 
@@ -570,5 +591,10 @@ static void __exit ghash_ce_mod_exit(void)
 	crypto_unregister_aead(&gcm_aes_alg);
 }
 
-module_cpu_feature_match(PMULL, ghash_ce_mod_init);
+static const struct cpu_feature ghash_cpu_feature[] = {
+	{ cpu_feature(PMULL) }, { }
+};
+MODULE_DEVICE_TABLE(cpu, ghash_cpu_feature);
+
+module_init(ghash_ce_mod_init);
 module_exit(ghash_ce_mod_exit);
-- 
2.9.3
