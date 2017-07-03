From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFT PATCH] crypto: arm64/ghash - add NEON accelerated fallback for 64-bit PMULL
Date: Mon,  3 Jul 2017 11:29:19 +0100
Message-ID: <20170703102919.21714-1-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, will.deacon@arm.com,
        catalin.marinas@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:36981 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753018AbdGCK32 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jul 2017 06:29:28 -0400
Received: by mail-wm0-f47.google.com with SMTP id i127so103606668wma.0
        for <linux-crypto@vger.kernel.org>; Mon, 03 Jul 2017 03:29:27 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Implement a NEON fallback for systems that do support NEON but have
no support for the optional 64x64->128 polynomial multiplication
instruction that is part of the ARMv8 Crypto Extensions. It is based
on the paper "Fast Software Polynomial Multiplication on ARM Processors
Using the NEON Engine" by Danilo Camara, Conrado Gouvea, Julio Lopez and
Ricardo Dahab (https://hal.inria.fr/hal-01506572)

On a low-end core such as the Cortex-A53 found in the Raspberry Pi3, the
NEON based implementation is ~2.8x faster than the table based one, and
is time invariant as well, making it less vulnerable to timing attacks.
When combined with the bit-sliced NEON implementation of AES-CTR, the
AES-GCM performance increases by 75% (from 58 to 33 cycles per byte).

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
Note that this is the arm64 counterpart of the patch
"crypto: arm/ghash - add NEON accelerated fallback for vmull.p64"

Raw numbers for a 1.2 Ghz Cortex-A53 (Raspberry Pi3) after the patch.

This patch applies onto the patch "crypto: arm64/gcm - implement native
driver using v8 Crypto Extensions" which can be found here:
http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg26385.html

 arch/arm64/crypto/ghash-ce-core.S | 161 +++++++++++++++++---
 arch/arm64/crypto/ghash-ce-glue.c |  36 ++++-
 2 files changed, 170 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/crypto/ghash-ce-core.S b/arch/arm64/crypto/ghash-ce-core.S
index cb22459eba85..8a789f6154fc 100644
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
@@ -11,24 +11,119 @@
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
+	perm4		.req	v20
 
 	.text
 	.arch		armv8-a+crypto
 
-	/*
-	 * void pmull_ghash_update(int blocks, u64 dg[], const char *src,
-	 *			   struct ghash_key const *k, const char *head)
-	 */
-ENTRY(pmull_ghash_update)
+	.macro		__pmull_p64, rd, rn, rm, i
+	.ifb		\i
+	pmull		\rd\().1q, \rn\().1d, \rm\().1d
+	.else
+	pmull2		\rd\().1q, \rn\().2d, \rm\().2d
+	.endif
+	.endm
+
+	.macro		__pmull_p8, rq, ad, bd, i
+	.ifb		\i
+	ext		t4.8b, \ad\().8b, \ad\().8b, #1		// A1
+	ext		t8.8b, \bd\().8b, \bd\().8b, #1		// B1
+	ext		t5.8b, \ad\().8b, \ad\().8b, #2		// A2
+	ext		t7.8b, \bd\().8b, \bd\().8b, #2		// B2
+	ext		t6.8b, \ad\().8b, \ad\().8b, #3		// A3
+	ext		t9.8b, \bd\().8b, \bd\().8b, #3		// B3
+	ext		t3.8b, \bd\().8b, \bd\().8b, #4		// B4
+
+	pmull		t4.8h, t4.8b, \bd\().8b			// F = A1*B
+	pmull		t8.8h, \ad\().8b, t8.8b			// E = A*B1
+	pmull		t5.8h, t5.8b, \bd\().8b			// H = A2*B
+	pmull		t7.8h, \ad\().8b, t7.8b			// G = A*B2
+	pmull		t6.8h, t6.8b, \bd\().8b			// J = A3*B
+	pmull		t9.8h, \ad\().8b, t9.8b			// I = A*B3
+	pmull		t3.8h, \ad\().8b, t3.8b			// K = A*B4
+	pmull		\rq\().8h, \ad\().8b, \bd\().8b		// D = A*B
+	.else
+	tbl		t4.16b, {\ad\().16b}, perm1.16b		// A1
+	tbl		t8.16b, {\bd\().16b}, perm1.16b		// B1
+	tbl		t5.16b, {\ad\().16b}, perm2.16b		// A2
+	tbl		t7.16b, {\bd\().16b}, perm2.16b		// B2
+	tbl		t6.16b, {\ad\().16b}, perm3.16b		// A3
+	tbl		t9.16b, {\bd\().16b}, perm3.16b		// B3
+	tbl		t3.16b, {\bd\().16b}, perm4.16b		// B4
+
+	pmull2		t4.8h, t4.16b, \bd\().16b		// F = A1*B
+	pmull2		t8.8h, \ad\().16b, t8.16b		// E = A*B1
+	pmull2		t5.8h, t5.16b, \bd\().16b		// H = A2*B
+	pmull2		t7.8h, \ad\().16b, t7.16b		// G = A*B2
+	pmull2		t6.8h, t6.16b, \bd\().16b		// J = A3*B
+	pmull2		t9.8h, \ad\().16b, t9.16b		// I = A*B3
+	pmull2		t3.8h, \ad\().16b, t3.16b		// K = A*B4
+	pmull2		\rq\().8h, \ad\().16b, \bd\().16b	// D = A*B
+	.endif
+
+	eor		t4.16b, t4.16b, t8.16b			// L = E + F
+	eor		t5.16b, t5.16b, t7.16b			// M = G + H
+	eor		t6.16b, t6.16b, t9.16b			// N = I + J
+
+	uzp1		t8.2d, t4.2d, t5.2d
+	uzp2		t4.2d, t4.2d, t5.2d
+	uzp1		t7.2d, t6.2d, t3.2d
+	uzp2		t6.2d, t6.2d, t3.2d
+
+	// t4 = (L) (P0 + P1) << 8
+	// t5 = (M) (P2 + P3) << 16
+	eor		t8.16b, t8.16b, t4.16b
+	and		t4.16b, t4.16b, k32_48.16b
+
+	// t6 = (N) (P4 + P5) << 24
+	// t7 = (K) (P6 + P7) << 32
+	eor		t7.16b, t7.16b, t6.16b
+	and		t6.16b, t6.16b, k00_16.16b
+
+	eor		t8.16b, t8.16b, t4.16b
+	eor		t7.16b, t7.16b, t6.16b
+
+	zip2		t5.2d, t8.2d, t4.2d
+	zip1		t4.2d, t8.2d, t4.2d
+	zip2		t3.2d, t7.2d, t6.2d
+	zip1		t6.2d, t7.2d, t6.2d
+
+	ext		t4.16b, t4.16b, t4.16b, #15
+	ext		t5.16b, t5.16b, t5.16b, #14
+	ext		t6.16b, t6.16b, t6.16b, #13
+	ext		t3.16b, t3.16b, t3.16b, #12
+
+	eor		t4.16b, t4.16b, t5.16b
+	eor		t6.16b, t6.16b, t3.16b
+	eor		\rq\().16b, \rq\().16b, t4.16b
+	eor		\rq\().16b, \rq\().16b, t6.16b
+	.endm
+
+	.macro		__pmull_ghash, pm
 	ld1		{SHASH.2d}, [x3]
 	ld1		{XL.2d}, [x1]
 	movi		MASK.16b, #0xe1
@@ -52,23 +147,23 @@ CPU_LE(	rev64		T1.16b, T1.16b	)
 	eor		T1.16b, T1.16b, T2.16b
 	eor		XL.16b, XL.16b, IN1.16b
 
-	pmull2		XH.1q, SHASH.2d, XL.2d		// a1 * b1
+	\pm		XH, SHASH, XL, 2		// a1 * b1
 	eor		T1.16b, T1.16b, XL.16b
-	pmull		XL.1q, SHASH.1d, XL.1d		// a0 * b0
-	pmull		XM.1q, SHASH2.1d, T1.1d		// (a1 + a0)(b1 + b0)
+	\pm 		XL, SHASH, XL			// a0 * b0
+	\pm 		XM, SHASH2, T1			// (a1 + a0)(b1 + b0)
 
 	ext		T1.16b, XL.16b, XH.16b, #8
 	eor		T2.16b, XL.16b, XH.16b
 	eor		XM.16b, XM.16b, T1.16b
 	eor		XM.16b, XM.16b, T2.16b
-	pmull		T2.1q, XL.1d, MASK.1d
+	\pm		T2, XL, MASK
 
 	mov		XH.d[0], XM.d[1]
 	mov		XM.d[1], XL.d[0]
 
 	eor		XL.16b, XM.16b, T2.16b
 	ext		T2.16b, XL.16b, XL.16b, #8
-	pmull		XL.1q, XL.1d, MASK.1d
+	\pm		XL, XL, MASK
 	eor		T2.16b, T2.16b, XH.16b
 	eor		XL.16b, XL.16b, T2.16b
 
@@ -76,7 +171,31 @@ CPU_LE(	rev64		T1.16b, T1.16b	)
 
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
+	__pmull_ghash	__pmull_p64
+ENDPROC(pmull_ghash_update_p64)
+
+ENTRY(pmull_ghash_update_p8)
+	// k00_16 := 0x0000000000000000_000000000000ffff
+	// k32_48 := 0x00000000ffffffff_0000ffffffffffff
+	movi		k32_48.2d, #0xffffffff
+	mov		k32_48.h[2], k32_48.h[0]
+	ushr		k00_16.2d, k32_48.2d, #32
+
+	mov_q		x5, 0x080f0e0d0c0b0a09
+	dup		perm1.2d, x5
+	ext		perm2.16b, perm1.16b, perm1.16b, #1
+	ext		perm3.16b, perm1.16b, perm1.16b, #2
+	ext		perm4.16b, perm1.16b, perm1.16b, #3
+
+	__pmull_ghash	__pmull_p8
+ENDPROC(pmull_ghash_update_p8)
 
 	KS		.req	v8
 	CTR		.req	v9
diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
index 524dd5a5aca1..6bf08e4d84fe 100644
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
@@ -554,9 +564,18 @@ static int __init ghash_ce_mod_init(void)
 {
 	int ret;
 
-	ret = crypto_register_aead(&gcm_aes_alg);
-	if (ret)
-		return ret;
+	if (!(elf_hwcap & HWCAP_ASIMD))
+		return -ENODEV;
+
+	if (elf_hwcap & HWCAP_PMULL) {
+		pmull_ghash_update = pmull_ghash_update_p64;
+
+		ret = crypto_register_aead(&gcm_aes_alg);
+		if (ret)
+			return ret;
+	} else {
+		pmull_ghash_update = pmull_ghash_update_p8;
+	}
 
 	ret = crypto_register_shash(&ghash_alg);
 	if (ret)
@@ -570,5 +589,10 @@ static void __exit ghash_ce_mod_exit(void)
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

testing speed of async ghash-generic (ghash-generic)
 0 (  1 x   16 =   16 bytes): 1032792 opers/sec,  16524672 bytes/sec
 1 (  4 x   16 =   64 bytes):  303065 opers/sec,  19396160 bytes/sec
 2 (  1 x   64 =   64 bytes):  398480 opers/sec,  25502720 bytes/sec
 3 ( 16 x   16 =  256 bytes):   79072 opers/sec,  20242432 bytes/sec
 4 (  4 x   64 =  256 bytes):  105639 opers/sec,  27043584 bytes/sec
 5 (  1 x  256 =  256 bytes):  115866 opers/sec,  29661696 bytes/sec
 6 ( 64 x   16 = 1024 bytes):   20000 opers/sec,  20480000 bytes/sec
 7 (  4 x  256 = 1024 bytes):   29416 opers/sec,  30121984 bytes/sec
 8 (  1 x 1024 = 1024 bytes):   30202 opers/sec,  30926848 bytes/sec
 9 (128 x   16 = 2048 bytes):   10021 opers/sec,  20523008 bytes/sec
10 (  8 x  256 = 2048 bytes):   14749 opers/sec,  30205952 bytes/sec
11 (  2 x 1024 = 2048 bytes):   15124 opers/sec,  30973952 bytes/sec
12 (  1 x 2048 = 2048 bytes):   15204 opers/sec,  31137792 bytes/sec
13 (256 x   16 = 4096 bytes):    5010 opers/sec,  20520960 bytes/sec
14 ( 16 x  256 = 4096 bytes):    7391 opers/sec,  30273536 bytes/sec
15 (  4 x 1024 = 4096 bytes):    7575 opers/sec,  31027200 bytes/sec
16 (  1 x 4096 = 4096 bytes):    7620 opers/sec,  31211520 bytes/sec
17 (512 x   16 = 8192 bytes):    2507 opers/sec,  20537344 bytes/sec
18 ( 32 x  256 = 8192 bytes):    3698 opers/sec,  30294016 bytes/sec
19 (  8 x 1024 = 8192 bytes):    3791 opers/sec,  31055872 bytes/sec
20 (  2 x 4096 = 8192 bytes):    3815 opers/sec,  31252480 bytes/sec
21 (  1 x 8192 = 8192 bytes):    3813 opers/sec,  31236096 bytes/sec

testing speed of async ghash (ghash-ce)
 0 (  1 x   16 =   16 bytes): 1262369 opers/sec,  20197904 bytes/sec
 1 (  4 x   16 =   64 bytes):  374038 opers/sec,  23938432 bytes/sec
 2 (  1 x   64 =   64 bytes):  750298 opers/sec,  48019072 bytes/sec
 3 ( 16 x   16 =  256 bytes):   98520 opers/sec,  25221120 bytes/sec
 4 (  4 x   64 =  256 bytes):  206875 opers/sec,  52960000 bytes/sec
 5 (  1 x  256 =  256 bytes):  285419 opers/sec,  73067264 bytes/sec
 6 ( 64 x   16 = 1024 bytes):   24942 opers/sec,  25540608 bytes/sec
 7 (  4 x  256 = 1024 bytes):   73911 opers/sec,  75684864 bytes/sec
 8 (  1 x 1024 = 1024 bytes):   82371 opers/sec,  84347904 bytes/sec
 9 (128 x   16 = 2048 bytes):   12490 opers/sec,  25579520 bytes/sec
10 (  8 x  256 = 2048 bytes):   37233 opers/sec,  76253184 bytes/sec
11 (  2 x 1024 = 2048 bytes):   41424 opers/sec,  84836352 bytes/sec
12 (  1 x 2048 = 2048 bytes):   42277 opers/sec,  86583296 bytes/sec
13 (256 x   16 = 4096 bytes):    6255 opers/sec,  25620480 bytes/sec
14 ( 16 x  256 = 4096 bytes):   18676 opers/sec,  76496896 bytes/sec
15 (  4 x 1024 = 4096 bytes):   20785 opers/sec,  85135360 bytes/sec
16 (  1 x 4096 = 4096 bytes):   21369 opers/sec,  87527424 bytes/sec
17 (512 x   16 = 8192 bytes):    3132 opers/sec,  25657344 bytes/sec
18 ( 32 x  256 = 8192 bytes):    9356 opers/sec,  76644352 bytes/sec
19 (  8 x 1024 = 8192 bytes):   10394 opers/sec,  85147648 bytes/sec
20 (  2 x 4096 = 8192 bytes):   10701 opers/sec,  87662592 bytes/sec
21 (  1 x 8192 = 8192 bytes):   10702 opers/sec,  87670784 bytes/sec

testing speed of gcm(aes) (gcm_base(ctr-aes-neonbs,ghash-generic)) encryption
 0 (128 bit key,   16 byte blocks): 129339 opers/sec,  2069424 bytes/sec
 1 (128 bit key,   64 byte blocks): 106580 opers/sec,  6821120 bytes/sec
 2 (128 bit key,  256 byte blocks):  50794 opers/sec, 13003264 bytes/sec
 3 (128 bit key,  512 byte blocks):  31399 opers/sec, 16076288 bytes/sec
 4 (128 bit key, 1024 byte blocks):  17835 opers/sec, 18263040 bytes/sec
 5 (128 bit key, 2048 byte blocks):   9565 opers/sec, 19589120 bytes/sec
 6 (128 bit key, 4096 byte blocks):   4973 opers/sec, 20369408 bytes/sec
 7 (128 bit key, 8192 byte blocks):   2521 opers/sec, 20652032 bytes/sec
 8 (192 bit key,   16 byte blocks): 123632 opers/sec,  1978112 bytes/sec
 9 (192 bit key,   64 byte blocks): 102969 opers/sec,  6590016 bytes/sec
10 (192 bit key,  256 byte blocks):  48204 opers/sec, 12340224 bytes/sec
11 (192 bit key,  512 byte blocks):  29747 opers/sec, 15230464 bytes/sec
12 (192 bit key, 1024 byte blocks):  16873 opers/sec, 17277952 bytes/sec
13 (192 bit key, 2048 byte blocks):   9041 opers/sec, 18515968 bytes/sec
14 (192 bit key, 4096 byte blocks):   4700 opers/sec, 19251200 bytes/sec
15 (192 bit key, 8192 byte blocks):   2382 opers/sec, 19513344 bytes/sec
16 (256 bit key,   16 byte blocks): 118382 opers/sec,  1894112 bytes/sec
17 (256 bit key,   64 byte blocks):  98995 opers/sec,  6335680 bytes/sec
18 (256 bit key,  256 byte blocks):  45832 opers/sec, 11732992 bytes/sec
19 (256 bit key,  512 byte blocks):  28262 opers/sec, 14470144 bytes/sec
20 (256 bit key, 1024 byte blocks):  16006 opers/sec, 16390144 bytes/sec
21 (256 bit key, 2048 byte blocks):   8567 opers/sec, 17545216 bytes/sec
22 (256 bit key, 4096 byte blocks):   4447 opers/sec, 18214912 bytes/sec
23 (256 bit key, 8192 byte blocks):   2259 opers/sec, 18505728 bytes/sec

testing speed of gcm(aes) (gcm_base(ctr-aes-neonbs,ghash-ce)) encryption
 0 (128 bit key,   16 byte blocks): 139252 opers/sec,  2228032 bytes/sec
 1 (128 bit key,   64 byte blocks): 128819 opers/sec,  8244416 bytes/sec
 2 (128 bit key,  256 byte blocks):  71131 opers/sec, 18209536 bytes/sec
 3 (128 bit key,  512 byte blocks):  47844 opers/sec, 24496128 bytes/sec
 4 (128 bit key, 1024 byte blocks):  28988 opers/sec, 29683712 bytes/sec
 5 (128 bit key, 2048 byte blocks):  16196 opers/sec, 33169408 bytes/sec
 6 (128 bit key, 4096 byte blocks):   8613 opers/sec, 35278848 bytes/sec
 7 (128 bit key, 8192 byte blocks):   4401 opers/sec, 36052992 bytes/sec
 8 (192 bit key,   16 byte blocks): 132723 opers/sec,  2123568 bytes/sec
 9 (192 bit key,   64 byte blocks): 123025 opers/sec,  7873600 bytes/sec
10 (192 bit key,  256 byte blocks):  66083 opers/sec, 16917248 bytes/sec
11 (192 bit key,  512 byte blocks):  44115 opers/sec, 22586880 bytes/sec
12 (192 bit key, 1024 byte blocks):  26518 opers/sec, 27154432 bytes/sec
13 (192 bit key, 2048 byte blocks):  14753 opers/sec, 30214144 bytes/sec
14 (192 bit key, 4096 byte blocks):   7825 opers/sec, 32051200 bytes/sec
15 (192 bit key, 8192 byte blocks):   3996 opers/sec, 32735232 bytes/sec
16 (256 bit key,   16 byte blocks): 126708 opers/sec,  2027328 bytes/sec
17 (256 bit key,   64 byte blocks): 117968 opers/sec,  7549952 bytes/sec
18 (256 bit key,  256 byte blocks):  61776 opers/sec, 15814656 bytes/sec
19 (256 bit key,  512 byte blocks):  40926 opers/sec, 20954112 bytes/sec
20 (256 bit key, 1024 byte blocks):  24459 opers/sec, 25046016 bytes/sec
21 (256 bit key, 2048 byte blocks):  13541 opers/sec, 27731968 bytes/sec
22 (256 bit key, 4096 byte blocks):   7154 opers/sec, 29302784 bytes/sec
23 (256 bit key, 8192 byte blocks):   3659 opers/sec, 29974528 bytes/sec
