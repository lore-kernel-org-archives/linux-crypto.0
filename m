From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net-next v5 18/20] crypto: port ChaCha20 to Zinc
Date: Tue, 18 Sep 2018 18:16:44 +0200
Message-ID: <20180918161646.19105-19-Jason@zx2c4.com>
References: <20180918161646.19105-1-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andy Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Eric Biggers <ebiggers@google.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180918161646.19105-1-Jason@zx2c4.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Now that ChaCha20 is in Zinc, we can have the crypto API code simply
call into it. The crypto API expects to have a stored key per instance
and independent nonces, so we follow suite and store the key and
initialize the nonce independently.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Samuel Neves <sneves@dei.uc.pt>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
Cc: Eric Biggers <ebiggers@google.com>
---
 arch/arm/configs/exynos_defconfig       |   1 -
 arch/arm/configs/multi_v7_defconfig     |   1 -
 arch/arm/configs/omap2plus_defconfig    |   1 -
 arch/arm/crypto/Kconfig                 |   6 -
 arch/arm/crypto/Makefile                |   2 -
 arch/arm/crypto/chacha20-neon-core.S    | 521 --------------------
 arch/arm/crypto/chacha20-neon-glue.c    | 127 -----
 arch/arm64/configs/defconfig            |   1 -
 arch/arm64/crypto/Kconfig               |   6 -
 arch/arm64/crypto/Makefile              |   3 -
 arch/arm64/crypto/chacha20-neon-core.S  | 450 -----------------
 arch/arm64/crypto/chacha20-neon-glue.c  | 133 -----
 arch/x86/crypto/Makefile                |   3 -
 arch/x86/crypto/chacha20-avx2-x86_64.S  | 448 -----------------
 arch/x86/crypto/chacha20-ssse3-x86_64.S | 630 ------------------------
 arch/x86/crypto/chacha20_glue.c         | 146 ------
 crypto/Kconfig                          |  17 +-
 crypto/Makefile                         |   2 +-
 crypto/chacha20_generic.c               | 136 -----
 crypto/chacha20_zinc.c                  | 100 ++++
 crypto/chacha20poly1305.c               |   2 +-
 include/crypto/chacha20.h               |  12 -
 22 files changed, 103 insertions(+), 2645 deletions(-)
 delete mode 100644 arch/arm/crypto/chacha20-neon-core.S
 delete mode 100644 arch/arm/crypto/chacha20-neon-glue.c
 delete mode 100644 arch/arm64/crypto/chacha20-neon-core.S
 delete mode 100644 arch/arm64/crypto/chacha20-neon-glue.c
 delete mode 100644 arch/x86/crypto/chacha20-avx2-x86_64.S
 delete mode 100644 arch/x86/crypto/chacha20-ssse3-x86_64.S
 delete mode 100644 arch/x86/crypto/chacha20_glue.c
 delete mode 100644 crypto/chacha20_generic.c
 create mode 100644 crypto/chacha20_zinc.c

diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos_defconfig
index 27ea6dfcf2f2..95929b5e7b10 100644
--- a/arch/arm/configs/exynos_defconfig
+++ b/arch/arm/configs/exynos_defconfig
@@ -350,7 +350,6 @@ CONFIG_CRYPTO_SHA1_ARM_NEON=m
 CONFIG_CRYPTO_SHA256_ARM=m
 CONFIG_CRYPTO_SHA512_ARM=m
 CONFIG_CRYPTO_AES_ARM_BS=m
-CONFIG_CRYPTO_CHACHA20_NEON=m
 CONFIG_CRC_CCITT=y
 CONFIG_FONTS=y
 CONFIG_FONT_7x14=y
diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index fc33444e94f0..63be07724db3 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -1000,4 +1000,3 @@ CONFIG_CRYPTO_AES_ARM_BS=m
 CONFIG_CRYPTO_AES_ARM_CE=m
 CONFIG_CRYPTO_GHASH_ARM_CE=m
 CONFIG_CRYPTO_CRC32_ARM_CE=m
-CONFIG_CRYPTO_CHACHA20_NEON=m
diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
index 6491419b1dad..f585a8ecc336 100644
--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -547,7 +547,6 @@ CONFIG_CRYPTO_SHA512_ARM=m
 CONFIG_CRYPTO_AES_ARM=m
 CONFIG_CRYPTO_AES_ARM_BS=m
 CONFIG_CRYPTO_GHASH_ARM_CE=m
-CONFIG_CRYPTO_CHACHA20_NEON=m
 CONFIG_CRC_CCITT=y
 CONFIG_CRC_T10DIF=y
 CONFIG_CRC_ITU_T=y
diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index 925d1364727a..fb80fd89f0e7 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -115,12 +115,6 @@ config CRYPTO_CRC32_ARM_CE
 	depends on KERNEL_MODE_NEON && CRC32
 	select CRYPTO_HASH
 
-config CRYPTO_CHACHA20_NEON
-	tristate "NEON accelerated ChaCha20 symmetric cipher"
-	depends on KERNEL_MODE_NEON
-	select CRYPTO_BLKCIPHER
-	select CRYPTO_CHACHA20
-
 config CRYPTO_SPECK_NEON
 	tristate "NEON accelerated Speck cipher algorithms"
 	depends on KERNEL_MODE_NEON
diff --git a/arch/arm/crypto/Makefile b/arch/arm/crypto/Makefile
index 8de542c48ade..bbfa98447063 100644
--- a/arch/arm/crypto/Makefile
+++ b/arch/arm/crypto/Makefile
@@ -9,7 +9,6 @@ obj-$(CONFIG_CRYPTO_SHA1_ARM) += sha1-arm.o
 obj-$(CONFIG_CRYPTO_SHA1_ARM_NEON) += sha1-arm-neon.o
 obj-$(CONFIG_CRYPTO_SHA256_ARM) += sha256-arm.o
 obj-$(CONFIG_CRYPTO_SHA512_ARM) += sha512-arm.o
-obj-$(CONFIG_CRYPTO_CHACHA20_NEON) += chacha20-neon.o
 obj-$(CONFIG_CRYPTO_SPECK_NEON) += speck-neon.o
 
 ce-obj-$(CONFIG_CRYPTO_AES_ARM_CE) += aes-arm-ce.o
@@ -53,7 +52,6 @@ aes-arm-ce-y	:= aes-ce-core.o aes-ce-glue.o
 ghash-arm-ce-y	:= ghash-ce-core.o ghash-ce-glue.o
 crct10dif-arm-ce-y	:= crct10dif-ce-core.o crct10dif-ce-glue.o
 crc32-arm-ce-y:= crc32-ce-core.o crc32-ce-glue.o
-chacha20-neon-y := chacha20-neon-core.o chacha20-neon-glue.o
 speck-neon-y := speck-neon-core.o speck-neon-glue.o
 
 ifdef REGENERATE_ARM_CRYPTO
diff --git a/arch/arm/crypto/chacha20-neon-core.S b/arch/arm/crypto/chacha20-neon-core.S
deleted file mode 100644
index 451a849ad518..000000000000
--- a/arch/arm/crypto/chacha20-neon-core.S
+++ /dev/null
@@ -1,521 +0,0 @@
-/*
- * ChaCha20 256-bit cipher algorithm, RFC7539, ARM NEON functions
- *
- * Copyright (C) 2016 Linaro, Ltd. <ard.biesheuvel@linaro.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * Based on:
- * ChaCha20 256-bit cipher algorithm, RFC7539, x64 SSE3 functions
- *
- * Copyright (C) 2015 Martin Willi
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <linux/linkage.h>
-
-	.text
-	.fpu		neon
-	.align		5
-
-ENTRY(chacha20_block_xor_neon)
-	// r0: Input state matrix, s
-	// r1: 1 data block output, o
-	// r2: 1 data block input, i
-
-	//
-	// This function encrypts one ChaCha20 block by loading the state matrix
-	// in four NEON registers. It performs matrix operation on four words in
-	// parallel, but requireds shuffling to rearrange the words after each
-	// round.
-	//
-
-	// x0..3 = s0..3
-	add		ip, r0, #0x20
-	vld1.32		{q0-q1}, [r0]
-	vld1.32		{q2-q3}, [ip]
-
-	vmov		q8, q0
-	vmov		q9, q1
-	vmov		q10, q2
-	vmov		q11, q3
-
-	mov		r3, #10
-
-.Ldoubleround:
-	// x0 += x1, x3 = rotl32(x3 ^ x0, 16)
-	vadd.i32	q0, q0, q1
-	veor		q3, q3, q0
-	vrev32.16	q3, q3
-
-	// x2 += x3, x1 = rotl32(x1 ^ x2, 12)
-	vadd.i32	q2, q2, q3
-	veor		q4, q1, q2
-	vshl.u32	q1, q4, #12
-	vsri.u32	q1, q4, #20
-
-	// x0 += x1, x3 = rotl32(x3 ^ x0, 8)
-	vadd.i32	q0, q0, q1
-	veor		q4, q3, q0
-	vshl.u32	q3, q4, #8
-	vsri.u32	q3, q4, #24
-
-	// x2 += x3, x1 = rotl32(x1 ^ x2, 7)
-	vadd.i32	q2, q2, q3
-	veor		q4, q1, q2
-	vshl.u32	q1, q4, #7
-	vsri.u32	q1, q4, #25
-
-	// x1 = shuffle32(x1, MASK(0, 3, 2, 1))
-	vext.8		q1, q1, q1, #4
-	// x2 = shuffle32(x2, MASK(1, 0, 3, 2))
-	vext.8		q2, q2, q2, #8
-	// x3 = shuffle32(x3, MASK(2, 1, 0, 3))
-	vext.8		q3, q3, q3, #12
-
-	// x0 += x1, x3 = rotl32(x3 ^ x0, 16)
-	vadd.i32	q0, q0, q1
-	veor		q3, q3, q0
-	vrev32.16	q3, q3
-
-	// x2 += x3, x1 = rotl32(x1 ^ x2, 12)
-	vadd.i32	q2, q2, q3
-	veor		q4, q1, q2
-	vshl.u32	q1, q4, #12
-	vsri.u32	q1, q4, #20
-
-	// x0 += x1, x3 = rotl32(x3 ^ x0, 8)
-	vadd.i32	q0, q0, q1
-	veor		q4, q3, q0
-	vshl.u32	q3, q4, #8
-	vsri.u32	q3, q4, #24
-
-	// x2 += x3, x1 = rotl32(x1 ^ x2, 7)
-	vadd.i32	q2, q2, q3
-	veor		q4, q1, q2
-	vshl.u32	q1, q4, #7
-	vsri.u32	q1, q4, #25
-
-	// x1 = shuffle32(x1, MASK(2, 1, 0, 3))
-	vext.8		q1, q1, q1, #12
-	// x2 = shuffle32(x2, MASK(1, 0, 3, 2))
-	vext.8		q2, q2, q2, #8
-	// x3 = shuffle32(x3, MASK(0, 3, 2, 1))
-	vext.8		q3, q3, q3, #4
-
-	subs		r3, r3, #1
-	bne		.Ldoubleround
-
-	add		ip, r2, #0x20
-	vld1.8		{q4-q5}, [r2]
-	vld1.8		{q6-q7}, [ip]
-
-	// o0 = i0 ^ (x0 + s0)
-	vadd.i32	q0, q0, q8
-	veor		q0, q0, q4
-
-	// o1 = i1 ^ (x1 + s1)
-	vadd.i32	q1, q1, q9
-	veor		q1, q1, q5
-
-	// o2 = i2 ^ (x2 + s2)
-	vadd.i32	q2, q2, q10
-	veor		q2, q2, q6
-
-	// o3 = i3 ^ (x3 + s3)
-	vadd.i32	q3, q3, q11
-	veor		q3, q3, q7
-
-	add		ip, r1, #0x20
-	vst1.8		{q0-q1}, [r1]
-	vst1.8		{q2-q3}, [ip]
-
-	bx		lr
-ENDPROC(chacha20_block_xor_neon)
-
-	.align		5
-ENTRY(chacha20_4block_xor_neon)
-	push		{r4-r6, lr}
-	mov		ip, sp			// preserve the stack pointer
-	sub		r3, sp, #0x20		// allocate a 32 byte buffer
-	bic		r3, r3, #0x1f		// aligned to 32 bytes
-	mov		sp, r3
-
-	// r0: Input state matrix, s
-	// r1: 4 data blocks output, o
-	// r2: 4 data blocks input, i
-
-	//
-	// This function encrypts four consecutive ChaCha20 blocks by loading
-	// the state matrix in NEON registers four times. The algorithm performs
-	// each operation on the corresponding word of each state matrix, hence
-	// requires no word shuffling. For final XORing step we transpose the
-	// matrix by interleaving 32- and then 64-bit words, which allows us to
-	// do XOR in NEON registers.
-	//
-
-	// x0..15[0-3] = s0..3[0..3]
-	add		r3, r0, #0x20
-	vld1.32		{q0-q1}, [r0]
-	vld1.32		{q2-q3}, [r3]
-
-	adr		r3, CTRINC
-	vdup.32		q15, d7[1]
-	vdup.32		q14, d7[0]
-	vld1.32		{q11}, [r3, :128]
-	vdup.32		q13, d6[1]
-	vdup.32		q12, d6[0]
-	vadd.i32	q12, q12, q11		// x12 += counter values 0-3
-	vdup.32		q11, d5[1]
-	vdup.32		q10, d5[0]
-	vdup.32		q9, d4[1]
-	vdup.32		q8, d4[0]
-	vdup.32		q7, d3[1]
-	vdup.32		q6, d3[0]
-	vdup.32		q5, d2[1]
-	vdup.32		q4, d2[0]
-	vdup.32		q3, d1[1]
-	vdup.32		q2, d1[0]
-	vdup.32		q1, d0[1]
-	vdup.32		q0, d0[0]
-
-	mov		r3, #10
-
-.Ldoubleround4:
-	// x0 += x4, x12 = rotl32(x12 ^ x0, 16)
-	// x1 += x5, x13 = rotl32(x13 ^ x1, 16)
-	// x2 += x6, x14 = rotl32(x14 ^ x2, 16)
-	// x3 += x7, x15 = rotl32(x15 ^ x3, 16)
-	vadd.i32	q0, q0, q4
-	vadd.i32	q1, q1, q5
-	vadd.i32	q2, q2, q6
-	vadd.i32	q3, q3, q7
-
-	veor		q12, q12, q0
-	veor		q13, q13, q1
-	veor		q14, q14, q2
-	veor		q15, q15, q3
-
-	vrev32.16	q12, q12
-	vrev32.16	q13, q13
-	vrev32.16	q14, q14
-	vrev32.16	q15, q15
-
-	// x8 += x12, x4 = rotl32(x4 ^ x8, 12)
-	// x9 += x13, x5 = rotl32(x5 ^ x9, 12)
-	// x10 += x14, x6 = rotl32(x6 ^ x10, 12)
-	// x11 += x15, x7 = rotl32(x7 ^ x11, 12)
-	vadd.i32	q8, q8, q12
-	vadd.i32	q9, q9, q13
-	vadd.i32	q10, q10, q14
-	vadd.i32	q11, q11, q15
-
-	vst1.32		{q8-q9}, [sp, :256]
-
-	veor		q8, q4, q8
-	veor		q9, q5, q9
-	vshl.u32	q4, q8, #12
-	vshl.u32	q5, q9, #12
-	vsri.u32	q4, q8, #20
-	vsri.u32	q5, q9, #20
-
-	veor		q8, q6, q10
-	veor		q9, q7, q11
-	vshl.u32	q6, q8, #12
-	vshl.u32	q7, q9, #12
-	vsri.u32	q6, q8, #20
-	vsri.u32	q7, q9, #20
-
-	// x0 += x4, x12 = rotl32(x12 ^ x0, 8)
-	// x1 += x5, x13 = rotl32(x13 ^ x1, 8)
-	// x2 += x6, x14 = rotl32(x14 ^ x2, 8)
-	// x3 += x7, x15 = rotl32(x15 ^ x3, 8)
-	vadd.i32	q0, q0, q4
-	vadd.i32	q1, q1, q5
-	vadd.i32	q2, q2, q6
-	vadd.i32	q3, q3, q7
-
-	veor		q8, q12, q0
-	veor		q9, q13, q1
-	vshl.u32	q12, q8, #8
-	vshl.u32	q13, q9, #8
-	vsri.u32	q12, q8, #24
-	vsri.u32	q13, q9, #24
-
-	veor		q8, q14, q2
-	veor		q9, q15, q3
-	vshl.u32	q14, q8, #8
-	vshl.u32	q15, q9, #8
-	vsri.u32	q14, q8, #24
-	vsri.u32	q15, q9, #24
-
-	vld1.32		{q8-q9}, [sp, :256]
-
-	// x8 += x12, x4 = rotl32(x4 ^ x8, 7)
-	// x9 += x13, x5 = rotl32(x5 ^ x9, 7)
-	// x10 += x14, x6 = rotl32(x6 ^ x10, 7)
-	// x11 += x15, x7 = rotl32(x7 ^ x11, 7)
-	vadd.i32	q8, q8, q12
-	vadd.i32	q9, q9, q13
-	vadd.i32	q10, q10, q14
-	vadd.i32	q11, q11, q15
-
-	vst1.32		{q8-q9}, [sp, :256]
-
-	veor		q8, q4, q8
-	veor		q9, q5, q9
-	vshl.u32	q4, q8, #7
-	vshl.u32	q5, q9, #7
-	vsri.u32	q4, q8, #25
-	vsri.u32	q5, q9, #25
-
-	veor		q8, q6, q10
-	veor		q9, q7, q11
-	vshl.u32	q6, q8, #7
-	vshl.u32	q7, q9, #7
-	vsri.u32	q6, q8, #25
-	vsri.u32	q7, q9, #25
-
-	vld1.32		{q8-q9}, [sp, :256]
-
-	// x0 += x5, x15 = rotl32(x15 ^ x0, 16)
-	// x1 += x6, x12 = rotl32(x12 ^ x1, 16)
-	// x2 += x7, x13 = rotl32(x13 ^ x2, 16)
-	// x3 += x4, x14 = rotl32(x14 ^ x3, 16)
-	vadd.i32	q0, q0, q5
-	vadd.i32	q1, q1, q6
-	vadd.i32	q2, q2, q7
-	vadd.i32	q3, q3, q4
-
-	veor		q15, q15, q0
-	veor		q12, q12, q1
-	veor		q13, q13, q2
-	veor		q14, q14, q3
-
-	vrev32.16	q15, q15
-	vrev32.16	q12, q12
-	vrev32.16	q13, q13
-	vrev32.16	q14, q14
-
-	// x10 += x15, x5 = rotl32(x5 ^ x10, 12)
-	// x11 += x12, x6 = rotl32(x6 ^ x11, 12)
-	// x8 += x13, x7 = rotl32(x7 ^ x8, 12)
-	// x9 += x14, x4 = rotl32(x4 ^ x9, 12)
-	vadd.i32	q10, q10, q15
-	vadd.i32	q11, q11, q12
-	vadd.i32	q8, q8, q13
-	vadd.i32	q9, q9, q14
-
-	vst1.32		{q8-q9}, [sp, :256]
-
-	veor		q8, q7, q8
-	veor		q9, q4, q9
-	vshl.u32	q7, q8, #12
-	vshl.u32	q4, q9, #12
-	vsri.u32	q7, q8, #20
-	vsri.u32	q4, q9, #20
-
-	veor		q8, q5, q10
-	veor		q9, q6, q11
-	vshl.u32	q5, q8, #12
-	vshl.u32	q6, q9, #12
-	vsri.u32	q5, q8, #20
-	vsri.u32	q6, q9, #20
-
-	// x0 += x5, x15 = rotl32(x15 ^ x0, 8)
-	// x1 += x6, x12 = rotl32(x12 ^ x1, 8)
-	// x2 += x7, x13 = rotl32(x13 ^ x2, 8)
-	// x3 += x4, x14 = rotl32(x14 ^ x3, 8)
-	vadd.i32	q0, q0, q5
-	vadd.i32	q1, q1, q6
-	vadd.i32	q2, q2, q7
-	vadd.i32	q3, q3, q4
-
-	veor		q8, q15, q0
-	veor		q9, q12, q1
-	vshl.u32	q15, q8, #8
-	vshl.u32	q12, q9, #8
-	vsri.u32	q15, q8, #24
-	vsri.u32	q12, q9, #24
-
-	veor		q8, q13, q2
-	veor		q9, q14, q3
-	vshl.u32	q13, q8, #8
-	vshl.u32	q14, q9, #8
-	vsri.u32	q13, q8, #24
-	vsri.u32	q14, q9, #24
-
-	vld1.32		{q8-q9}, [sp, :256]
-
-	// x10 += x15, x5 = rotl32(x5 ^ x10, 7)
-	// x11 += x12, x6 = rotl32(x6 ^ x11, 7)
-	// x8 += x13, x7 = rotl32(x7 ^ x8, 7)
-	// x9 += x14, x4 = rotl32(x4 ^ x9, 7)
-	vadd.i32	q10, q10, q15
-	vadd.i32	q11, q11, q12
-	vadd.i32	q8, q8, q13
-	vadd.i32	q9, q9, q14
-
-	vst1.32		{q8-q9}, [sp, :256]
-
-	veor		q8, q7, q8
-	veor		q9, q4, q9
-	vshl.u32	q7, q8, #7
-	vshl.u32	q4, q9, #7
-	vsri.u32	q7, q8, #25
-	vsri.u32	q4, q9, #25
-
-	veor		q8, q5, q10
-	veor		q9, q6, q11
-	vshl.u32	q5, q8, #7
-	vshl.u32	q6, q9, #7
-	vsri.u32	q5, q8, #25
-	vsri.u32	q6, q9, #25
-
-	subs		r3, r3, #1
-	beq		0f
-
-	vld1.32		{q8-q9}, [sp, :256]
-	b		.Ldoubleround4
-
-	// x0[0-3] += s0[0]
-	// x1[0-3] += s0[1]
-	// x2[0-3] += s0[2]
-	// x3[0-3] += s0[3]
-0:	ldmia		r0!, {r3-r6}
-	vdup.32		q8, r3
-	vdup.32		q9, r4
-	vadd.i32	q0, q0, q8
-	vadd.i32	q1, q1, q9
-	vdup.32		q8, r5
-	vdup.32		q9, r6
-	vadd.i32	q2, q2, q8
-	vadd.i32	q3, q3, q9
-
-	// x4[0-3] += s1[0]
-	// x5[0-3] += s1[1]
-	// x6[0-3] += s1[2]
-	// x7[0-3] += s1[3]
-	ldmia		r0!, {r3-r6}
-	vdup.32		q8, r3
-	vdup.32		q9, r4
-	vadd.i32	q4, q4, q8
-	vadd.i32	q5, q5, q9
-	vdup.32		q8, r5
-	vdup.32		q9, r6
-	vadd.i32	q6, q6, q8
-	vadd.i32	q7, q7, q9
-
-	// interleave 32-bit words in state n, n+1
-	vzip.32		q0, q1
-	vzip.32		q2, q3
-	vzip.32		q4, q5
-	vzip.32		q6, q7
-
-	// interleave 64-bit words in state n, n+2
-	vswp		d1, d4
-	vswp		d3, d6
-	vswp		d9, d12
-	vswp		d11, d14
-
-	// xor with corresponding input, write to output
-	vld1.8		{q8-q9}, [r2]!
-	veor		q8, q8, q0
-	veor		q9, q9, q4
-	vst1.8		{q8-q9}, [r1]!
-
-	vld1.32		{q8-q9}, [sp, :256]
-
-	// x8[0-3] += s2[0]
-	// x9[0-3] += s2[1]
-	// x10[0-3] += s2[2]
-	// x11[0-3] += s2[3]
-	ldmia		r0!, {r3-r6}
-	vdup.32		q0, r3
-	vdup.32		q4, r4
-	vadd.i32	q8, q8, q0
-	vadd.i32	q9, q9, q4
-	vdup.32		q0, r5
-	vdup.32		q4, r6
-	vadd.i32	q10, q10, q0
-	vadd.i32	q11, q11, q4
-
-	// x12[0-3] += s3[0]
-	// x13[0-3] += s3[1]
-	// x14[0-3] += s3[2]
-	// x15[0-3] += s3[3]
-	ldmia		r0!, {r3-r6}
-	vdup.32		q0, r3
-	vdup.32		q4, r4
-	adr		r3, CTRINC
-	vadd.i32	q12, q12, q0
-	vld1.32		{q0}, [r3, :128]
-	vadd.i32	q13, q13, q4
-	vadd.i32	q12, q12, q0		// x12 += counter values 0-3
-
-	vdup.32		q0, r5
-	vdup.32		q4, r6
-	vadd.i32	q14, q14, q0
-	vadd.i32	q15, q15, q4
-
-	// interleave 32-bit words in state n, n+1
-	vzip.32		q8, q9
-	vzip.32		q10, q11
-	vzip.32		q12, q13
-	vzip.32		q14, q15
-
-	// interleave 64-bit words in state n, n+2
-	vswp		d17, d20
-	vswp		d19, d22
-	vswp		d25, d28
-	vswp		d27, d30
-
-	vmov		q4, q1
-
-	vld1.8		{q0-q1}, [r2]!
-	veor		q0, q0, q8
-	veor		q1, q1, q12
-	vst1.8		{q0-q1}, [r1]!
-
-	vld1.8		{q0-q1}, [r2]!
-	veor		q0, q0, q2
-	veor		q1, q1, q6
-	vst1.8		{q0-q1}, [r1]!
-
-	vld1.8		{q0-q1}, [r2]!
-	veor		q0, q0, q10
-	veor		q1, q1, q14
-	vst1.8		{q0-q1}, [r1]!
-
-	vld1.8		{q0-q1}, [r2]!
-	veor		q0, q0, q4
-	veor		q1, q1, q5
-	vst1.8		{q0-q1}, [r1]!
-
-	vld1.8		{q0-q1}, [r2]!
-	veor		q0, q0, q9
-	veor		q1, q1, q13
-	vst1.8		{q0-q1}, [r1]!
-
-	vld1.8		{q0-q1}, [r2]!
-	veor		q0, q0, q3
-	veor		q1, q1, q7
-	vst1.8		{q0-q1}, [r1]!
-
-	vld1.8		{q0-q1}, [r2]
-	veor		q0, q0, q11
-	veor		q1, q1, q15
-	vst1.8		{q0-q1}, [r1]
-
-	mov		sp, ip
-	pop		{r4-r6, pc}
-ENDPROC(chacha20_4block_xor_neon)
-
-	.align		4
-CTRINC:	.word		0, 1, 2, 3
diff --git a/arch/arm/crypto/chacha20-neon-glue.c b/arch/arm/crypto/chacha20-neon-glue.c
deleted file mode 100644
index 59a7be08e80c..000000000000
--- a/arch/arm/crypto/chacha20-neon-glue.c
+++ /dev/null
@@ -1,127 +0,0 @@
-/*
- * ChaCha20 256-bit cipher algorithm, RFC7539, ARM NEON functions
- *
- * Copyright (C) 2016 Linaro, Ltd. <ard.biesheuvel@linaro.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * Based on:
- * ChaCha20 256-bit cipher algorithm, RFC7539, SIMD glue code
- *
- * Copyright (C) 2015 Martin Willi
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <crypto/algapi.h>
-#include <crypto/chacha20.h>
-#include <crypto/internal/skcipher.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-
-#include <asm/hwcap.h>
-#include <asm/neon.h>
-#include <asm/simd.h>
-
-asmlinkage void chacha20_block_xor_neon(u32 *state, u8 *dst, const u8 *src);
-asmlinkage void chacha20_4block_xor_neon(u32 *state, u8 *dst, const u8 *src);
-
-static void chacha20_doneon(u32 *state, u8 *dst, const u8 *src,
-			    unsigned int bytes)
-{
-	u8 buf[CHACHA20_BLOCK_SIZE];
-
-	while (bytes >= CHACHA20_BLOCK_SIZE * 4) {
-		chacha20_4block_xor_neon(state, dst, src);
-		bytes -= CHACHA20_BLOCK_SIZE * 4;
-		src += CHACHA20_BLOCK_SIZE * 4;
-		dst += CHACHA20_BLOCK_SIZE * 4;
-		state[12] += 4;
-	}
-	while (bytes >= CHACHA20_BLOCK_SIZE) {
-		chacha20_block_xor_neon(state, dst, src);
-		bytes -= CHACHA20_BLOCK_SIZE;
-		src += CHACHA20_BLOCK_SIZE;
-		dst += CHACHA20_BLOCK_SIZE;
-		state[12]++;
-	}
-	if (bytes) {
-		memcpy(buf, src, bytes);
-		chacha20_block_xor_neon(state, buf, buf);
-		memcpy(dst, buf, bytes);
-	}
-}
-
-static int chacha20_neon(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct chacha20_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct skcipher_walk walk;
-	u32 state[16];
-	int err;
-
-	if (req->cryptlen <= CHACHA20_BLOCK_SIZE || !may_use_simd())
-		return crypto_chacha20_crypt(req);
-
-	err = skcipher_walk_virt(&walk, req, true);
-
-	crypto_chacha20_init(state, ctx, walk.iv);
-
-	kernel_neon_begin();
-	while (walk.nbytes > 0) {
-		unsigned int nbytes = walk.nbytes;
-
-		if (nbytes < walk.total)
-			nbytes = round_down(nbytes, walk.stride);
-
-		chacha20_doneon(state, walk.dst.virt.addr, walk.src.virt.addr,
-				nbytes);
-		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
-	}
-	kernel_neon_end();
-
-	return err;
-}
-
-static struct skcipher_alg alg = {
-	.base.cra_name		= "chacha20",
-	.base.cra_driver_name	= "chacha20-neon",
-	.base.cra_priority	= 300,
-	.base.cra_blocksize	= 1,
-	.base.cra_ctxsize	= sizeof(struct chacha20_ctx),
-	.base.cra_module	= THIS_MODULE,
-
-	.min_keysize		= CHACHA20_KEY_SIZE,
-	.max_keysize		= CHACHA20_KEY_SIZE,
-	.ivsize			= CHACHA20_IV_SIZE,
-	.chunksize		= CHACHA20_BLOCK_SIZE,
-	.walksize		= 4 * CHACHA20_BLOCK_SIZE,
-	.setkey			= crypto_chacha20_setkey,
-	.encrypt		= chacha20_neon,
-	.decrypt		= chacha20_neon,
-};
-
-static int __init chacha20_simd_mod_init(void)
-{
-	if (!(elf_hwcap & HWCAP_NEON))
-		return -ENODEV;
-
-	return crypto_register_skcipher(&alg);
-}
-
-static void __exit chacha20_simd_mod_fini(void)
-{
-	crypto_unregister_skcipher(&alg);
-}
-
-module_init(chacha20_simd_mod_init);
-module_exit(chacha20_simd_mod_fini);
-
-MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
-MODULE_LICENSE("GPL v2");
-MODULE_ALIAS_CRYPTO("chacha20");
diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index db8d364f8476..6cc3c8a0ad88 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -709,5 +709,4 @@ CONFIG_CRYPTO_CRCT10DIF_ARM64_CE=m
 CONFIG_CRYPTO_CRC32_ARM64_CE=m
 CONFIG_CRYPTO_AES_ARM64_CE_CCM=y
 CONFIG_CRYPTO_AES_ARM64_CE_BLK=y
-CONFIG_CRYPTO_CHACHA20_NEON=m
 CONFIG_CRYPTO_AES_ARM64_BS=m
diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index e3fdb0fd6f70..9db6d775a880 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -105,12 +105,6 @@ config CRYPTO_AES_ARM64_NEON_BLK
 	select CRYPTO_AES
 	select CRYPTO_SIMD
 
-config CRYPTO_CHACHA20_NEON
-	tristate "NEON accelerated ChaCha20 symmetric cipher"
-	depends on KERNEL_MODE_NEON
-	select CRYPTO_BLKCIPHER
-	select CRYPTO_CHACHA20
-
 config CRYPTO_AES_ARM64_BS
 	tristate "AES in ECB/CBC/CTR/XTS modes using bit-sliced NEON algorithm"
 	depends on KERNEL_MODE_NEON
diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
index bcafd016618e..507c4bfb86e3 100644
--- a/arch/arm64/crypto/Makefile
+++ b/arch/arm64/crypto/Makefile
@@ -53,9 +53,6 @@ sha256-arm64-y := sha256-glue.o sha256-core.o
 obj-$(CONFIG_CRYPTO_SHA512_ARM64) += sha512-arm64.o
 sha512-arm64-y := sha512-glue.o sha512-core.o
 
-obj-$(CONFIG_CRYPTO_CHACHA20_NEON) += chacha20-neon.o
-chacha20-neon-y := chacha20-neon-core.o chacha20-neon-glue.o
-
 obj-$(CONFIG_CRYPTO_SPECK_NEON) += speck-neon.o
 speck-neon-y := speck-neon-core.o speck-neon-glue.o
 
diff --git a/arch/arm64/crypto/chacha20-neon-core.S b/arch/arm64/crypto/chacha20-neon-core.S
deleted file mode 100644
index 13c85e272c2a..000000000000
--- a/arch/arm64/crypto/chacha20-neon-core.S
+++ /dev/null
@@ -1,450 +0,0 @@
-/*
- * ChaCha20 256-bit cipher algorithm, RFC7539, arm64 NEON functions
- *
- * Copyright (C) 2016 Linaro, Ltd. <ard.biesheuvel@linaro.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * Based on:
- * ChaCha20 256-bit cipher algorithm, RFC7539, x64 SSSE3 functions
- *
- * Copyright (C) 2015 Martin Willi
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <linux/linkage.h>
-
-	.text
-	.align		6
-
-ENTRY(chacha20_block_xor_neon)
-	// x0: Input state matrix, s
-	// x1: 1 data block output, o
-	// x2: 1 data block input, i
-
-	//
-	// This function encrypts one ChaCha20 block by loading the state matrix
-	// in four NEON registers. It performs matrix operation on four words in
-	// parallel, but requires shuffling to rearrange the words after each
-	// round.
-	//
-
-	// x0..3 = s0..3
-	adr		x3, ROT8
-	ld1		{v0.4s-v3.4s}, [x0]
-	ld1		{v8.4s-v11.4s}, [x0]
-	ld1		{v12.4s}, [x3]
-
-	mov		x3, #10
-
-.Ldoubleround:
-	// x0 += x1, x3 = rotl32(x3 ^ x0, 16)
-	add		v0.4s, v0.4s, v1.4s
-	eor		v3.16b, v3.16b, v0.16b
-	rev32		v3.8h, v3.8h
-
-	// x2 += x3, x1 = rotl32(x1 ^ x2, 12)
-	add		v2.4s, v2.4s, v3.4s
-	eor		v4.16b, v1.16b, v2.16b
-	shl		v1.4s, v4.4s, #12
-	sri		v1.4s, v4.4s, #20
-
-	// x0 += x1, x3 = rotl32(x3 ^ x0, 8)
-	add		v0.4s, v0.4s, v1.4s
-	eor		v3.16b, v3.16b, v0.16b
-	tbl		v3.16b, {v3.16b}, v12.16b
-
-	// x2 += x3, x1 = rotl32(x1 ^ x2, 7)
-	add		v2.4s, v2.4s, v3.4s
-	eor		v4.16b, v1.16b, v2.16b
-	shl		v1.4s, v4.4s, #7
-	sri		v1.4s, v4.4s, #25
-
-	// x1 = shuffle32(x1, MASK(0, 3, 2, 1))
-	ext		v1.16b, v1.16b, v1.16b, #4
-	// x2 = shuffle32(x2, MASK(1, 0, 3, 2))
-	ext		v2.16b, v2.16b, v2.16b, #8
-	// x3 = shuffle32(x3, MASK(2, 1, 0, 3))
-	ext		v3.16b, v3.16b, v3.16b, #12
-
-	// x0 += x1, x3 = rotl32(x3 ^ x0, 16)
-	add		v0.4s, v0.4s, v1.4s
-	eor		v3.16b, v3.16b, v0.16b
-	rev32		v3.8h, v3.8h
-
-	// x2 += x3, x1 = rotl32(x1 ^ x2, 12)
-	add		v2.4s, v2.4s, v3.4s
-	eor		v4.16b, v1.16b, v2.16b
-	shl		v1.4s, v4.4s, #12
-	sri		v1.4s, v4.4s, #20
-
-	// x0 += x1, x3 = rotl32(x3 ^ x0, 8)
-	add		v0.4s, v0.4s, v1.4s
-	eor		v3.16b, v3.16b, v0.16b
-	tbl		v3.16b, {v3.16b}, v12.16b
-
-	// x2 += x3, x1 = rotl32(x1 ^ x2, 7)
-	add		v2.4s, v2.4s, v3.4s
-	eor		v4.16b, v1.16b, v2.16b
-	shl		v1.4s, v4.4s, #7
-	sri		v1.4s, v4.4s, #25
-
-	// x1 = shuffle32(x1, MASK(2, 1, 0, 3))
-	ext		v1.16b, v1.16b, v1.16b, #12
-	// x2 = shuffle32(x2, MASK(1, 0, 3, 2))
-	ext		v2.16b, v2.16b, v2.16b, #8
-	// x3 = shuffle32(x3, MASK(0, 3, 2, 1))
-	ext		v3.16b, v3.16b, v3.16b, #4
-
-	subs		x3, x3, #1
-	b.ne		.Ldoubleround
-
-	ld1		{v4.16b-v7.16b}, [x2]
-
-	// o0 = i0 ^ (x0 + s0)
-	add		v0.4s, v0.4s, v8.4s
-	eor		v0.16b, v0.16b, v4.16b
-
-	// o1 = i1 ^ (x1 + s1)
-	add		v1.4s, v1.4s, v9.4s
-	eor		v1.16b, v1.16b, v5.16b
-
-	// o2 = i2 ^ (x2 + s2)
-	add		v2.4s, v2.4s, v10.4s
-	eor		v2.16b, v2.16b, v6.16b
-
-	// o3 = i3 ^ (x3 + s3)
-	add		v3.4s, v3.4s, v11.4s
-	eor		v3.16b, v3.16b, v7.16b
-
-	st1		{v0.16b-v3.16b}, [x1]
-
-	ret
-ENDPROC(chacha20_block_xor_neon)
-
-	.align		6
-ENTRY(chacha20_4block_xor_neon)
-	// x0: Input state matrix, s
-	// x1: 4 data blocks output, o
-	// x2: 4 data blocks input, i
-
-	//
-	// This function encrypts four consecutive ChaCha20 blocks by loading
-	// the state matrix in NEON registers four times. The algorithm performs
-	// each operation on the corresponding word of each state matrix, hence
-	// requires no word shuffling. For final XORing step we transpose the
-	// matrix by interleaving 32- and then 64-bit words, which allows us to
-	// do XOR in NEON registers.
-	//
-	adr		x3, CTRINC		// ... and ROT8
-	ld1		{v30.4s-v31.4s}, [x3]
-
-	// x0..15[0-3] = s0..3[0..3]
-	mov		x4, x0
-	ld4r		{ v0.4s- v3.4s}, [x4], #16
-	ld4r		{ v4.4s- v7.4s}, [x4], #16
-	ld4r		{ v8.4s-v11.4s}, [x4], #16
-	ld4r		{v12.4s-v15.4s}, [x4]
-
-	// x12 += counter values 0-3
-	add		v12.4s, v12.4s, v30.4s
-
-	mov		x3, #10
-
-.Ldoubleround4:
-	// x0 += x4, x12 = rotl32(x12 ^ x0, 16)
-	// x1 += x5, x13 = rotl32(x13 ^ x1, 16)
-	// x2 += x6, x14 = rotl32(x14 ^ x2, 16)
-	// x3 += x7, x15 = rotl32(x15 ^ x3, 16)
-	add		v0.4s, v0.4s, v4.4s
-	add		v1.4s, v1.4s, v5.4s
-	add		v2.4s, v2.4s, v6.4s
-	add		v3.4s, v3.4s, v7.4s
-
-	eor		v12.16b, v12.16b, v0.16b
-	eor		v13.16b, v13.16b, v1.16b
-	eor		v14.16b, v14.16b, v2.16b
-	eor		v15.16b, v15.16b, v3.16b
-
-	rev32		v12.8h, v12.8h
-	rev32		v13.8h, v13.8h
-	rev32		v14.8h, v14.8h
-	rev32		v15.8h, v15.8h
-
-	// x8 += x12, x4 = rotl32(x4 ^ x8, 12)
-	// x9 += x13, x5 = rotl32(x5 ^ x9, 12)
-	// x10 += x14, x6 = rotl32(x6 ^ x10, 12)
-	// x11 += x15, x7 = rotl32(x7 ^ x11, 12)
-	add		v8.4s, v8.4s, v12.4s
-	add		v9.4s, v9.4s, v13.4s
-	add		v10.4s, v10.4s, v14.4s
-	add		v11.4s, v11.4s, v15.4s
-
-	eor		v16.16b, v4.16b, v8.16b
-	eor		v17.16b, v5.16b, v9.16b
-	eor		v18.16b, v6.16b, v10.16b
-	eor		v19.16b, v7.16b, v11.16b
-
-	shl		v4.4s, v16.4s, #12
-	shl		v5.4s, v17.4s, #12
-	shl		v6.4s, v18.4s, #12
-	shl		v7.4s, v19.4s, #12
-
-	sri		v4.4s, v16.4s, #20
-	sri		v5.4s, v17.4s, #20
-	sri		v6.4s, v18.4s, #20
-	sri		v7.4s, v19.4s, #20
-
-	// x0 += x4, x12 = rotl32(x12 ^ x0, 8)
-	// x1 += x5, x13 = rotl32(x13 ^ x1, 8)
-	// x2 += x6, x14 = rotl32(x14 ^ x2, 8)
-	// x3 += x7, x15 = rotl32(x15 ^ x3, 8)
-	add		v0.4s, v0.4s, v4.4s
-	add		v1.4s, v1.4s, v5.4s
-	add		v2.4s, v2.4s, v6.4s
-	add		v3.4s, v3.4s, v7.4s
-
-	eor		v12.16b, v12.16b, v0.16b
-	eor		v13.16b, v13.16b, v1.16b
-	eor		v14.16b, v14.16b, v2.16b
-	eor		v15.16b, v15.16b, v3.16b
-
-	tbl		v12.16b, {v12.16b}, v31.16b
-	tbl		v13.16b, {v13.16b}, v31.16b
-	tbl		v14.16b, {v14.16b}, v31.16b
-	tbl		v15.16b, {v15.16b}, v31.16b
-
-	// x8 += x12, x4 = rotl32(x4 ^ x8, 7)
-	// x9 += x13, x5 = rotl32(x5 ^ x9, 7)
-	// x10 += x14, x6 = rotl32(x6 ^ x10, 7)
-	// x11 += x15, x7 = rotl32(x7 ^ x11, 7)
-	add		v8.4s, v8.4s, v12.4s
-	add		v9.4s, v9.4s, v13.4s
-	add		v10.4s, v10.4s, v14.4s
-	add		v11.4s, v11.4s, v15.4s
-
-	eor		v16.16b, v4.16b, v8.16b
-	eor		v17.16b, v5.16b, v9.16b
-	eor		v18.16b, v6.16b, v10.16b
-	eor		v19.16b, v7.16b, v11.16b
-
-	shl		v4.4s, v16.4s, #7
-	shl		v5.4s, v17.4s, #7
-	shl		v6.4s, v18.4s, #7
-	shl		v7.4s, v19.4s, #7
-
-	sri		v4.4s, v16.4s, #25
-	sri		v5.4s, v17.4s, #25
-	sri		v6.4s, v18.4s, #25
-	sri		v7.4s, v19.4s, #25
-
-	// x0 += x5, x15 = rotl32(x15 ^ x0, 16)
-	// x1 += x6, x12 = rotl32(x12 ^ x1, 16)
-	// x2 += x7, x13 = rotl32(x13 ^ x2, 16)
-	// x3 += x4, x14 = rotl32(x14 ^ x3, 16)
-	add		v0.4s, v0.4s, v5.4s
-	add		v1.4s, v1.4s, v6.4s
-	add		v2.4s, v2.4s, v7.4s
-	add		v3.4s, v3.4s, v4.4s
-
-	eor		v15.16b, v15.16b, v0.16b
-	eor		v12.16b, v12.16b, v1.16b
-	eor		v13.16b, v13.16b, v2.16b
-	eor		v14.16b, v14.16b, v3.16b
-
-	rev32		v15.8h, v15.8h
-	rev32		v12.8h, v12.8h
-	rev32		v13.8h, v13.8h
-	rev32		v14.8h, v14.8h
-
-	// x10 += x15, x5 = rotl32(x5 ^ x10, 12)
-	// x11 += x12, x6 = rotl32(x6 ^ x11, 12)
-	// x8 += x13, x7 = rotl32(x7 ^ x8, 12)
-	// x9 += x14, x4 = rotl32(x4 ^ x9, 12)
-	add		v10.4s, v10.4s, v15.4s
-	add		v11.4s, v11.4s, v12.4s
-	add		v8.4s, v8.4s, v13.4s
-	add		v9.4s, v9.4s, v14.4s
-
-	eor		v16.16b, v5.16b, v10.16b
-	eor		v17.16b, v6.16b, v11.16b
-	eor		v18.16b, v7.16b, v8.16b
-	eor		v19.16b, v4.16b, v9.16b
-
-	shl		v5.4s, v16.4s, #12
-	shl		v6.4s, v17.4s, #12
-	shl		v7.4s, v18.4s, #12
-	shl		v4.4s, v19.4s, #12
-
-	sri		v5.4s, v16.4s, #20
-	sri		v6.4s, v17.4s, #20
-	sri		v7.4s, v18.4s, #20
-	sri		v4.4s, v19.4s, #20
-
-	// x0 += x5, x15 = rotl32(x15 ^ x0, 8)
-	// x1 += x6, x12 = rotl32(x12 ^ x1, 8)
-	// x2 += x7, x13 = rotl32(x13 ^ x2, 8)
-	// x3 += x4, x14 = rotl32(x14 ^ x3, 8)
-	add		v0.4s, v0.4s, v5.4s
-	add		v1.4s, v1.4s, v6.4s
-	add		v2.4s, v2.4s, v7.4s
-	add		v3.4s, v3.4s, v4.4s
-
-	eor		v15.16b, v15.16b, v0.16b
-	eor		v12.16b, v12.16b, v1.16b
-	eor		v13.16b, v13.16b, v2.16b
-	eor		v14.16b, v14.16b, v3.16b
-
-	tbl		v15.16b, {v15.16b}, v31.16b
-	tbl		v12.16b, {v12.16b}, v31.16b
-	tbl		v13.16b, {v13.16b}, v31.16b
-	tbl		v14.16b, {v14.16b}, v31.16b
-
-	// x10 += x15, x5 = rotl32(x5 ^ x10, 7)
-	// x11 += x12, x6 = rotl32(x6 ^ x11, 7)
-	// x8 += x13, x7 = rotl32(x7 ^ x8, 7)
-	// x9 += x14, x4 = rotl32(x4 ^ x9, 7)
-	add		v10.4s, v10.4s, v15.4s
-	add		v11.4s, v11.4s, v12.4s
-	add		v8.4s, v8.4s, v13.4s
-	add		v9.4s, v9.4s, v14.4s
-
-	eor		v16.16b, v5.16b, v10.16b
-	eor		v17.16b, v6.16b, v11.16b
-	eor		v18.16b, v7.16b, v8.16b
-	eor		v19.16b, v4.16b, v9.16b
-
-	shl		v5.4s, v16.4s, #7
-	shl		v6.4s, v17.4s, #7
-	shl		v7.4s, v18.4s, #7
-	shl		v4.4s, v19.4s, #7
-
-	sri		v5.4s, v16.4s, #25
-	sri		v6.4s, v17.4s, #25
-	sri		v7.4s, v18.4s, #25
-	sri		v4.4s, v19.4s, #25
-
-	subs		x3, x3, #1
-	b.ne		.Ldoubleround4
-
-	ld4r		{v16.4s-v19.4s}, [x0], #16
-	ld4r		{v20.4s-v23.4s}, [x0], #16
-
-	// x12 += counter values 0-3
-	add		v12.4s, v12.4s, v30.4s
-
-	// x0[0-3] += s0[0]
-	// x1[0-3] += s0[1]
-	// x2[0-3] += s0[2]
-	// x3[0-3] += s0[3]
-	add		v0.4s, v0.4s, v16.4s
-	add		v1.4s, v1.4s, v17.4s
-	add		v2.4s, v2.4s, v18.4s
-	add		v3.4s, v3.4s, v19.4s
-
-	ld4r		{v24.4s-v27.4s}, [x0], #16
-	ld4r		{v28.4s-v31.4s}, [x0]
-
-	// x4[0-3] += s1[0]
-	// x5[0-3] += s1[1]
-	// x6[0-3] += s1[2]
-	// x7[0-3] += s1[3]
-	add		v4.4s, v4.4s, v20.4s
-	add		v5.4s, v5.4s, v21.4s
-	add		v6.4s, v6.4s, v22.4s
-	add		v7.4s, v7.4s, v23.4s
-
-	// x8[0-3] += s2[0]
-	// x9[0-3] += s2[1]
-	// x10[0-3] += s2[2]
-	// x11[0-3] += s2[3]
-	add		v8.4s, v8.4s, v24.4s
-	add		v9.4s, v9.4s, v25.4s
-	add		v10.4s, v10.4s, v26.4s
-	add		v11.4s, v11.4s, v27.4s
-
-	// x12[0-3] += s3[0]
-	// x13[0-3] += s3[1]
-	// x14[0-3] += s3[2]
-	// x15[0-3] += s3[3]
-	add		v12.4s, v12.4s, v28.4s
-	add		v13.4s, v13.4s, v29.4s
-	add		v14.4s, v14.4s, v30.4s
-	add		v15.4s, v15.4s, v31.4s
-
-	// interleave 32-bit words in state n, n+1
-	zip1		v16.4s, v0.4s, v1.4s
-	zip2		v17.4s, v0.4s, v1.4s
-	zip1		v18.4s, v2.4s, v3.4s
-	zip2		v19.4s, v2.4s, v3.4s
-	zip1		v20.4s, v4.4s, v5.4s
-	zip2		v21.4s, v4.4s, v5.4s
-	zip1		v22.4s, v6.4s, v7.4s
-	zip2		v23.4s, v6.4s, v7.4s
-	zip1		v24.4s, v8.4s, v9.4s
-	zip2		v25.4s, v8.4s, v9.4s
-	zip1		v26.4s, v10.4s, v11.4s
-	zip2		v27.4s, v10.4s, v11.4s
-	zip1		v28.4s, v12.4s, v13.4s
-	zip2		v29.4s, v12.4s, v13.4s
-	zip1		v30.4s, v14.4s, v15.4s
-	zip2		v31.4s, v14.4s, v15.4s
-
-	// interleave 64-bit words in state n, n+2
-	zip1		v0.2d, v16.2d, v18.2d
-	zip2		v4.2d, v16.2d, v18.2d
-	zip1		v8.2d, v17.2d, v19.2d
-	zip2		v12.2d, v17.2d, v19.2d
-	ld1		{v16.16b-v19.16b}, [x2], #64
-
-	zip1		v1.2d, v20.2d, v22.2d
-	zip2		v5.2d, v20.2d, v22.2d
-	zip1		v9.2d, v21.2d, v23.2d
-	zip2		v13.2d, v21.2d, v23.2d
-	ld1		{v20.16b-v23.16b}, [x2], #64
-
-	zip1		v2.2d, v24.2d, v26.2d
-	zip2		v6.2d, v24.2d, v26.2d
-	zip1		v10.2d, v25.2d, v27.2d
-	zip2		v14.2d, v25.2d, v27.2d
-	ld1		{v24.16b-v27.16b}, [x2], #64
-
-	zip1		v3.2d, v28.2d, v30.2d
-	zip2		v7.2d, v28.2d, v30.2d
-	zip1		v11.2d, v29.2d, v31.2d
-	zip2		v15.2d, v29.2d, v31.2d
-	ld1		{v28.16b-v31.16b}, [x2]
-
-	// xor with corresponding input, write to output
-	eor		v16.16b, v16.16b, v0.16b
-	eor		v17.16b, v17.16b, v1.16b
-	eor		v18.16b, v18.16b, v2.16b
-	eor		v19.16b, v19.16b, v3.16b
-	eor		v20.16b, v20.16b, v4.16b
-	eor		v21.16b, v21.16b, v5.16b
-	st1		{v16.16b-v19.16b}, [x1], #64
-	eor		v22.16b, v22.16b, v6.16b
-	eor		v23.16b, v23.16b, v7.16b
-	eor		v24.16b, v24.16b, v8.16b
-	eor		v25.16b, v25.16b, v9.16b
-	st1		{v20.16b-v23.16b}, [x1], #64
-	eor		v26.16b, v26.16b, v10.16b
-	eor		v27.16b, v27.16b, v11.16b
-	eor		v28.16b, v28.16b, v12.16b
-	st1		{v24.16b-v27.16b}, [x1], #64
-	eor		v29.16b, v29.16b, v13.16b
-	eor		v30.16b, v30.16b, v14.16b
-	eor		v31.16b, v31.16b, v15.16b
-	st1		{v28.16b-v31.16b}, [x1]
-
-	ret
-ENDPROC(chacha20_4block_xor_neon)
-
-CTRINC:	.word		0, 1, 2, 3
-ROT8:	.word		0x02010003, 0x06050407, 0x0a09080b, 0x0e0d0c0f
diff --git a/arch/arm64/crypto/chacha20-neon-glue.c b/arch/arm64/crypto/chacha20-neon-glue.c
deleted file mode 100644
index 727579c93ded..000000000000
--- a/arch/arm64/crypto/chacha20-neon-glue.c
+++ /dev/null
@@ -1,133 +0,0 @@
-/*
- * ChaCha20 256-bit cipher algorithm, RFC7539, arm64 NEON functions
- *
- * Copyright (C) 2016 - 2017 Linaro, Ltd. <ard.biesheuvel@linaro.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * Based on:
- * ChaCha20 256-bit cipher algorithm, RFC7539, SIMD glue code
- *
- * Copyright (C) 2015 Martin Willi
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <crypto/algapi.h>
-#include <crypto/chacha20.h>
-#include <crypto/internal/skcipher.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-
-#include <asm/hwcap.h>
-#include <asm/neon.h>
-#include <asm/simd.h>
-
-asmlinkage void chacha20_block_xor_neon(u32 *state, u8 *dst, const u8 *src);
-asmlinkage void chacha20_4block_xor_neon(u32 *state, u8 *dst, const u8 *src);
-
-static void chacha20_doneon(u32 *state, u8 *dst, const u8 *src,
-			    unsigned int bytes)
-{
-	u8 buf[CHACHA20_BLOCK_SIZE];
-
-	while (bytes >= CHACHA20_BLOCK_SIZE * 4) {
-		kernel_neon_begin();
-		chacha20_4block_xor_neon(state, dst, src);
-		kernel_neon_end();
-		bytes -= CHACHA20_BLOCK_SIZE * 4;
-		src += CHACHA20_BLOCK_SIZE * 4;
-		dst += CHACHA20_BLOCK_SIZE * 4;
-		state[12] += 4;
-	}
-
-	if (!bytes)
-		return;
-
-	kernel_neon_begin();
-	while (bytes >= CHACHA20_BLOCK_SIZE) {
-		chacha20_block_xor_neon(state, dst, src);
-		bytes -= CHACHA20_BLOCK_SIZE;
-		src += CHACHA20_BLOCK_SIZE;
-		dst += CHACHA20_BLOCK_SIZE;
-		state[12]++;
-	}
-	if (bytes) {
-		memcpy(buf, src, bytes);
-		chacha20_block_xor_neon(state, buf, buf);
-		memcpy(dst, buf, bytes);
-	}
-	kernel_neon_end();
-}
-
-static int chacha20_neon(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct chacha20_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct skcipher_walk walk;
-	u32 state[16];
-	int err;
-
-	if (!may_use_simd() || req->cryptlen <= CHACHA20_BLOCK_SIZE)
-		return crypto_chacha20_crypt(req);
-
-	err = skcipher_walk_virt(&walk, req, false);
-
-	crypto_chacha20_init(state, ctx, walk.iv);
-
-	while (walk.nbytes > 0) {
-		unsigned int nbytes = walk.nbytes;
-
-		if (nbytes < walk.total)
-			nbytes = round_down(nbytes, walk.stride);
-
-		chacha20_doneon(state, walk.dst.virt.addr, walk.src.virt.addr,
-				nbytes);
-		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
-	}
-
-	return err;
-}
-
-static struct skcipher_alg alg = {
-	.base.cra_name		= "chacha20",
-	.base.cra_driver_name	= "chacha20-neon",
-	.base.cra_priority	= 300,
-	.base.cra_blocksize	= 1,
-	.base.cra_ctxsize	= sizeof(struct chacha20_ctx),
-	.base.cra_module	= THIS_MODULE,
-
-	.min_keysize		= CHACHA20_KEY_SIZE,
-	.max_keysize		= CHACHA20_KEY_SIZE,
-	.ivsize			= CHACHA20_IV_SIZE,
-	.chunksize		= CHACHA20_BLOCK_SIZE,
-	.walksize		= 4 * CHACHA20_BLOCK_SIZE,
-	.setkey			= crypto_chacha20_setkey,
-	.encrypt		= chacha20_neon,
-	.decrypt		= chacha20_neon,
-};
-
-static int __init chacha20_simd_mod_init(void)
-{
-	if (!(elf_hwcap & HWCAP_ASIMD))
-		return -ENODEV;
-
-	return crypto_register_skcipher(&alg);
-}
-
-static void __exit chacha20_simd_mod_fini(void)
-{
-	crypto_unregister_skcipher(&alg);
-}
-
-module_init(chacha20_simd_mod_init);
-module_exit(chacha20_simd_mod_fini);
-
-MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
-MODULE_LICENSE("GPL v2");
-MODULE_ALIAS_CRYPTO("chacha20");
diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index cf830219846b..419212c31246 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -23,7 +23,6 @@ obj-$(CONFIG_CRYPTO_CAMELLIA_X86_64) += camellia-x86_64.o
 obj-$(CONFIG_CRYPTO_BLOWFISH_X86_64) += blowfish-x86_64.o
 obj-$(CONFIG_CRYPTO_TWOFISH_X86_64) += twofish-x86_64.o
 obj-$(CONFIG_CRYPTO_TWOFISH_X86_64_3WAY) += twofish-x86_64-3way.o
-obj-$(CONFIG_CRYPTO_CHACHA20_X86_64) += chacha20-x86_64.o
 obj-$(CONFIG_CRYPTO_SERPENT_SSE2_X86_64) += serpent-sse2-x86_64.o
 obj-$(CONFIG_CRYPTO_AES_NI_INTEL) += aesni-intel.o
 obj-$(CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL) += ghash-clmulni-intel.o
@@ -76,7 +75,6 @@ camellia-x86_64-y := camellia-x86_64-asm_64.o camellia_glue.o
 blowfish-x86_64-y := blowfish-x86_64-asm_64.o blowfish_glue.o
 twofish-x86_64-y := twofish-x86_64-asm_64.o twofish_glue.o
 twofish-x86_64-3way-y := twofish-x86_64-asm_64-3way.o twofish_glue_3way.o
-chacha20-x86_64-y := chacha20-ssse3-x86_64.o chacha20_glue.o
 serpent-sse2-x86_64-y := serpent-sse2-x86_64-asm_64.o serpent_sse2_glue.o
 
 aegis128-aesni-y := aegis128-aesni-asm.o aegis128-aesni-glue.o
@@ -99,7 +97,6 @@ endif
 
 ifeq ($(avx2_supported),yes)
 	camellia-aesni-avx2-y := camellia-aesni-avx2-asm_64.o camellia_aesni_avx2_glue.o
-	chacha20-x86_64-y += chacha20-avx2-x86_64.o
 	serpent-avx2-y := serpent-avx2-asm_64.o serpent_avx2_glue.o
 
 	morus1280-avx2-y := morus1280-avx2-asm.o morus1280-avx2-glue.o
diff --git a/arch/x86/crypto/chacha20-avx2-x86_64.S b/arch/x86/crypto/chacha20-avx2-x86_64.S
deleted file mode 100644
index f3cd26f48332..000000000000
--- a/arch/x86/crypto/chacha20-avx2-x86_64.S
+++ /dev/null
@@ -1,448 +0,0 @@
-/*
- * ChaCha20 256-bit cipher algorithm, RFC7539, x64 AVX2 functions
- *
- * Copyright (C) 2015 Martin Willi
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <linux/linkage.h>
-
-.section	.rodata.cst32.ROT8, "aM", @progbits, 32
-.align 32
-ROT8:	.octa 0x0e0d0c0f0a09080b0605040702010003
-	.octa 0x0e0d0c0f0a09080b0605040702010003
-
-.section	.rodata.cst32.ROT16, "aM", @progbits, 32
-.align 32
-ROT16:	.octa 0x0d0c0f0e09080b0a0504070601000302
-	.octa 0x0d0c0f0e09080b0a0504070601000302
-
-.section	.rodata.cst32.CTRINC, "aM", @progbits, 32
-.align 32
-CTRINC:	.octa 0x00000003000000020000000100000000
-	.octa 0x00000007000000060000000500000004
-
-.text
-
-ENTRY(chacha20_8block_xor_avx2)
-	# %rdi: Input state matrix, s
-	# %rsi: 8 data blocks output, o
-	# %rdx: 8 data blocks input, i
-
-	# This function encrypts eight consecutive ChaCha20 blocks by loading
-	# the state matrix in AVX registers eight times. As we need some
-	# scratch registers, we save the first four registers on the stack. The
-	# algorithm performs each operation on the corresponding word of each
-	# state matrix, hence requires no word shuffling. For final XORing step
-	# we transpose the matrix by interleaving 32-, 64- and then 128-bit
-	# words, which allows us to do XOR in AVX registers. 8/16-bit word
-	# rotation is done with the slightly better performing byte shuffling,
-	# 7/12-bit word rotation uses traditional shift+OR.
-
-	vzeroupper
-	# 4 * 32 byte stack, 32-byte aligned
-	lea		8(%rsp),%r10
-	and		$~31, %rsp
-	sub		$0x80, %rsp
-
-	# x0..15[0-7] = s[0..15]
-	vpbroadcastd	0x00(%rdi),%ymm0
-	vpbroadcastd	0x04(%rdi),%ymm1
-	vpbroadcastd	0x08(%rdi),%ymm2
-	vpbroadcastd	0x0c(%rdi),%ymm3
-	vpbroadcastd	0x10(%rdi),%ymm4
-	vpbroadcastd	0x14(%rdi),%ymm5
-	vpbroadcastd	0x18(%rdi),%ymm6
-	vpbroadcastd	0x1c(%rdi),%ymm7
-	vpbroadcastd	0x20(%rdi),%ymm8
-	vpbroadcastd	0x24(%rdi),%ymm9
-	vpbroadcastd	0x28(%rdi),%ymm10
-	vpbroadcastd	0x2c(%rdi),%ymm11
-	vpbroadcastd	0x30(%rdi),%ymm12
-	vpbroadcastd	0x34(%rdi),%ymm13
-	vpbroadcastd	0x38(%rdi),%ymm14
-	vpbroadcastd	0x3c(%rdi),%ymm15
-	# x0..3 on stack
-	vmovdqa		%ymm0,0x00(%rsp)
-	vmovdqa		%ymm1,0x20(%rsp)
-	vmovdqa		%ymm2,0x40(%rsp)
-	vmovdqa		%ymm3,0x60(%rsp)
-
-	vmovdqa		CTRINC(%rip),%ymm1
-	vmovdqa		ROT8(%rip),%ymm2
-	vmovdqa		ROT16(%rip),%ymm3
-
-	# x12 += counter values 0-3
-	vpaddd		%ymm1,%ymm12,%ymm12
-
-	mov		$10,%ecx
-
-.Ldoubleround8:
-	# x0 += x4, x12 = rotl32(x12 ^ x0, 16)
-	vpaddd		0x00(%rsp),%ymm4,%ymm0
-	vmovdqa		%ymm0,0x00(%rsp)
-	vpxor		%ymm0,%ymm12,%ymm12
-	vpshufb		%ymm3,%ymm12,%ymm12
-	# x1 += x5, x13 = rotl32(x13 ^ x1, 16)
-	vpaddd		0x20(%rsp),%ymm5,%ymm0
-	vmovdqa		%ymm0,0x20(%rsp)
-	vpxor		%ymm0,%ymm13,%ymm13
-	vpshufb		%ymm3,%ymm13,%ymm13
-	# x2 += x6, x14 = rotl32(x14 ^ x2, 16)
-	vpaddd		0x40(%rsp),%ymm6,%ymm0
-	vmovdqa		%ymm0,0x40(%rsp)
-	vpxor		%ymm0,%ymm14,%ymm14
-	vpshufb		%ymm3,%ymm14,%ymm14
-	# x3 += x7, x15 = rotl32(x15 ^ x3, 16)
-	vpaddd		0x60(%rsp),%ymm7,%ymm0
-	vmovdqa		%ymm0,0x60(%rsp)
-	vpxor		%ymm0,%ymm15,%ymm15
-	vpshufb		%ymm3,%ymm15,%ymm15
-
-	# x8 += x12, x4 = rotl32(x4 ^ x8, 12)
-	vpaddd		%ymm12,%ymm8,%ymm8
-	vpxor		%ymm8,%ymm4,%ymm4
-	vpslld		$12,%ymm4,%ymm0
-	vpsrld		$20,%ymm4,%ymm4
-	vpor		%ymm0,%ymm4,%ymm4
-	# x9 += x13, x5 = rotl32(x5 ^ x9, 12)
-	vpaddd		%ymm13,%ymm9,%ymm9
-	vpxor		%ymm9,%ymm5,%ymm5
-	vpslld		$12,%ymm5,%ymm0
-	vpsrld		$20,%ymm5,%ymm5
-	vpor		%ymm0,%ymm5,%ymm5
-	# x10 += x14, x6 = rotl32(x6 ^ x10, 12)
-	vpaddd		%ymm14,%ymm10,%ymm10
-	vpxor		%ymm10,%ymm6,%ymm6
-	vpslld		$12,%ymm6,%ymm0
-	vpsrld		$20,%ymm6,%ymm6
-	vpor		%ymm0,%ymm6,%ymm6
-	# x11 += x15, x7 = rotl32(x7 ^ x11, 12)
-	vpaddd		%ymm15,%ymm11,%ymm11
-	vpxor		%ymm11,%ymm7,%ymm7
-	vpslld		$12,%ymm7,%ymm0
-	vpsrld		$20,%ymm7,%ymm7
-	vpor		%ymm0,%ymm7,%ymm7
-
-	# x0 += x4, x12 = rotl32(x12 ^ x0, 8)
-	vpaddd		0x00(%rsp),%ymm4,%ymm0
-	vmovdqa		%ymm0,0x00(%rsp)
-	vpxor		%ymm0,%ymm12,%ymm12
-	vpshufb		%ymm2,%ymm12,%ymm12
-	# x1 += x5, x13 = rotl32(x13 ^ x1, 8)
-	vpaddd		0x20(%rsp),%ymm5,%ymm0
-	vmovdqa		%ymm0,0x20(%rsp)
-	vpxor		%ymm0,%ymm13,%ymm13
-	vpshufb		%ymm2,%ymm13,%ymm13
-	# x2 += x6, x14 = rotl32(x14 ^ x2, 8)
-	vpaddd		0x40(%rsp),%ymm6,%ymm0
-	vmovdqa		%ymm0,0x40(%rsp)
-	vpxor		%ymm0,%ymm14,%ymm14
-	vpshufb		%ymm2,%ymm14,%ymm14
-	# x3 += x7, x15 = rotl32(x15 ^ x3, 8)
-	vpaddd		0x60(%rsp),%ymm7,%ymm0
-	vmovdqa		%ymm0,0x60(%rsp)
-	vpxor		%ymm0,%ymm15,%ymm15
-	vpshufb		%ymm2,%ymm15,%ymm15
-
-	# x8 += x12, x4 = rotl32(x4 ^ x8, 7)
-	vpaddd		%ymm12,%ymm8,%ymm8
-	vpxor		%ymm8,%ymm4,%ymm4
-	vpslld		$7,%ymm4,%ymm0
-	vpsrld		$25,%ymm4,%ymm4
-	vpor		%ymm0,%ymm4,%ymm4
-	# x9 += x13, x5 = rotl32(x5 ^ x9, 7)
-	vpaddd		%ymm13,%ymm9,%ymm9
-	vpxor		%ymm9,%ymm5,%ymm5
-	vpslld		$7,%ymm5,%ymm0
-	vpsrld		$25,%ymm5,%ymm5
-	vpor		%ymm0,%ymm5,%ymm5
-	# x10 += x14, x6 = rotl32(x6 ^ x10, 7)
-	vpaddd		%ymm14,%ymm10,%ymm10
-	vpxor		%ymm10,%ymm6,%ymm6
-	vpslld		$7,%ymm6,%ymm0
-	vpsrld		$25,%ymm6,%ymm6
-	vpor		%ymm0,%ymm6,%ymm6
-	# x11 += x15, x7 = rotl32(x7 ^ x11, 7)
-	vpaddd		%ymm15,%ymm11,%ymm11
-	vpxor		%ymm11,%ymm7,%ymm7
-	vpslld		$7,%ymm7,%ymm0
-	vpsrld		$25,%ymm7,%ymm7
-	vpor		%ymm0,%ymm7,%ymm7
-
-	# x0 += x5, x15 = rotl32(x15 ^ x0, 16)
-	vpaddd		0x00(%rsp),%ymm5,%ymm0
-	vmovdqa		%ymm0,0x00(%rsp)
-	vpxor		%ymm0,%ymm15,%ymm15
-	vpshufb		%ymm3,%ymm15,%ymm15
-	# x1 += x6, x12 = rotl32(x12 ^ x1, 16)%ymm0
-	vpaddd		0x20(%rsp),%ymm6,%ymm0
-	vmovdqa		%ymm0,0x20(%rsp)
-	vpxor		%ymm0,%ymm12,%ymm12
-	vpshufb		%ymm3,%ymm12,%ymm12
-	# x2 += x7, x13 = rotl32(x13 ^ x2, 16)
-	vpaddd		0x40(%rsp),%ymm7,%ymm0
-	vmovdqa		%ymm0,0x40(%rsp)
-	vpxor		%ymm0,%ymm13,%ymm13
-	vpshufb		%ymm3,%ymm13,%ymm13
-	# x3 += x4, x14 = rotl32(x14 ^ x3, 16)
-	vpaddd		0x60(%rsp),%ymm4,%ymm0
-	vmovdqa		%ymm0,0x60(%rsp)
-	vpxor		%ymm0,%ymm14,%ymm14
-	vpshufb		%ymm3,%ymm14,%ymm14
-
-	# x10 += x15, x5 = rotl32(x5 ^ x10, 12)
-	vpaddd		%ymm15,%ymm10,%ymm10
-	vpxor		%ymm10,%ymm5,%ymm5
-	vpslld		$12,%ymm5,%ymm0
-	vpsrld		$20,%ymm5,%ymm5
-	vpor		%ymm0,%ymm5,%ymm5
-	# x11 += x12, x6 = rotl32(x6 ^ x11, 12)
-	vpaddd		%ymm12,%ymm11,%ymm11
-	vpxor		%ymm11,%ymm6,%ymm6
-	vpslld		$12,%ymm6,%ymm0
-	vpsrld		$20,%ymm6,%ymm6
-	vpor		%ymm0,%ymm6,%ymm6
-	# x8 += x13, x7 = rotl32(x7 ^ x8, 12)
-	vpaddd		%ymm13,%ymm8,%ymm8
-	vpxor		%ymm8,%ymm7,%ymm7
-	vpslld		$12,%ymm7,%ymm0
-	vpsrld		$20,%ymm7,%ymm7
-	vpor		%ymm0,%ymm7,%ymm7
-	# x9 += x14, x4 = rotl32(x4 ^ x9, 12)
-	vpaddd		%ymm14,%ymm9,%ymm9
-	vpxor		%ymm9,%ymm4,%ymm4
-	vpslld		$12,%ymm4,%ymm0
-	vpsrld		$20,%ymm4,%ymm4
-	vpor		%ymm0,%ymm4,%ymm4
-
-	# x0 += x5, x15 = rotl32(x15 ^ x0, 8)
-	vpaddd		0x00(%rsp),%ymm5,%ymm0
-	vmovdqa		%ymm0,0x00(%rsp)
-	vpxor		%ymm0,%ymm15,%ymm15
-	vpshufb		%ymm2,%ymm15,%ymm15
-	# x1 += x6, x12 = rotl32(x12 ^ x1, 8)
-	vpaddd		0x20(%rsp),%ymm6,%ymm0
-	vmovdqa		%ymm0,0x20(%rsp)
-	vpxor		%ymm0,%ymm12,%ymm12
-	vpshufb		%ymm2,%ymm12,%ymm12
-	# x2 += x7, x13 = rotl32(x13 ^ x2, 8)
-	vpaddd		0x40(%rsp),%ymm7,%ymm0
-	vmovdqa		%ymm0,0x40(%rsp)
-	vpxor		%ymm0,%ymm13,%ymm13
-	vpshufb		%ymm2,%ymm13,%ymm13
-	# x3 += x4, x14 = rotl32(x14 ^ x3, 8)
-	vpaddd		0x60(%rsp),%ymm4,%ymm0
-	vmovdqa		%ymm0,0x60(%rsp)
-	vpxor		%ymm0,%ymm14,%ymm14
-	vpshufb		%ymm2,%ymm14,%ymm14
-
-	# x10 += x15, x5 = rotl32(x5 ^ x10, 7)
-	vpaddd		%ymm15,%ymm10,%ymm10
-	vpxor		%ymm10,%ymm5,%ymm5
-	vpslld		$7,%ymm5,%ymm0
-	vpsrld		$25,%ymm5,%ymm5
-	vpor		%ymm0,%ymm5,%ymm5
-	# x11 += x12, x6 = rotl32(x6 ^ x11, 7)
-	vpaddd		%ymm12,%ymm11,%ymm11
-	vpxor		%ymm11,%ymm6,%ymm6
-	vpslld		$7,%ymm6,%ymm0
-	vpsrld		$25,%ymm6,%ymm6
-	vpor		%ymm0,%ymm6,%ymm6
-	# x8 += x13, x7 = rotl32(x7 ^ x8, 7)
-	vpaddd		%ymm13,%ymm8,%ymm8
-	vpxor		%ymm8,%ymm7,%ymm7
-	vpslld		$7,%ymm7,%ymm0
-	vpsrld		$25,%ymm7,%ymm7
-	vpor		%ymm0,%ymm7,%ymm7
-	# x9 += x14, x4 = rotl32(x4 ^ x9, 7)
-	vpaddd		%ymm14,%ymm9,%ymm9
-	vpxor		%ymm9,%ymm4,%ymm4
-	vpslld		$7,%ymm4,%ymm0
-	vpsrld		$25,%ymm4,%ymm4
-	vpor		%ymm0,%ymm4,%ymm4
-
-	dec		%ecx
-	jnz		.Ldoubleround8
-
-	# x0..15[0-3] += s[0..15]
-	vpbroadcastd	0x00(%rdi),%ymm0
-	vpaddd		0x00(%rsp),%ymm0,%ymm0
-	vmovdqa		%ymm0,0x00(%rsp)
-	vpbroadcastd	0x04(%rdi),%ymm0
-	vpaddd		0x20(%rsp),%ymm0,%ymm0
-	vmovdqa		%ymm0,0x20(%rsp)
-	vpbroadcastd	0x08(%rdi),%ymm0
-	vpaddd		0x40(%rsp),%ymm0,%ymm0
-	vmovdqa		%ymm0,0x40(%rsp)
-	vpbroadcastd	0x0c(%rdi),%ymm0
-	vpaddd		0x60(%rsp),%ymm0,%ymm0
-	vmovdqa		%ymm0,0x60(%rsp)
-	vpbroadcastd	0x10(%rdi),%ymm0
-	vpaddd		%ymm0,%ymm4,%ymm4
-	vpbroadcastd	0x14(%rdi),%ymm0
-	vpaddd		%ymm0,%ymm5,%ymm5
-	vpbroadcastd	0x18(%rdi),%ymm0
-	vpaddd		%ymm0,%ymm6,%ymm6
-	vpbroadcastd	0x1c(%rdi),%ymm0
-	vpaddd		%ymm0,%ymm7,%ymm7
-	vpbroadcastd	0x20(%rdi),%ymm0
-	vpaddd		%ymm0,%ymm8,%ymm8
-	vpbroadcastd	0x24(%rdi),%ymm0
-	vpaddd		%ymm0,%ymm9,%ymm9
-	vpbroadcastd	0x28(%rdi),%ymm0
-	vpaddd		%ymm0,%ymm10,%ymm10
-	vpbroadcastd	0x2c(%rdi),%ymm0
-	vpaddd		%ymm0,%ymm11,%ymm11
-	vpbroadcastd	0x30(%rdi),%ymm0
-	vpaddd		%ymm0,%ymm12,%ymm12
-	vpbroadcastd	0x34(%rdi),%ymm0
-	vpaddd		%ymm0,%ymm13,%ymm13
-	vpbroadcastd	0x38(%rdi),%ymm0
-	vpaddd		%ymm0,%ymm14,%ymm14
-	vpbroadcastd	0x3c(%rdi),%ymm0
-	vpaddd		%ymm0,%ymm15,%ymm15
-
-	# x12 += counter values 0-3
-	vpaddd		%ymm1,%ymm12,%ymm12
-
-	# interleave 32-bit words in state n, n+1
-	vmovdqa		0x00(%rsp),%ymm0
-	vmovdqa		0x20(%rsp),%ymm1
-	vpunpckldq	%ymm1,%ymm0,%ymm2
-	vpunpckhdq	%ymm1,%ymm0,%ymm1
-	vmovdqa		%ymm2,0x00(%rsp)
-	vmovdqa		%ymm1,0x20(%rsp)
-	vmovdqa		0x40(%rsp),%ymm0
-	vmovdqa		0x60(%rsp),%ymm1
-	vpunpckldq	%ymm1,%ymm0,%ymm2
-	vpunpckhdq	%ymm1,%ymm0,%ymm1
-	vmovdqa		%ymm2,0x40(%rsp)
-	vmovdqa		%ymm1,0x60(%rsp)
-	vmovdqa		%ymm4,%ymm0
-	vpunpckldq	%ymm5,%ymm0,%ymm4
-	vpunpckhdq	%ymm5,%ymm0,%ymm5
-	vmovdqa		%ymm6,%ymm0
-	vpunpckldq	%ymm7,%ymm0,%ymm6
-	vpunpckhdq	%ymm7,%ymm0,%ymm7
-	vmovdqa		%ymm8,%ymm0
-	vpunpckldq	%ymm9,%ymm0,%ymm8
-	vpunpckhdq	%ymm9,%ymm0,%ymm9
-	vmovdqa		%ymm10,%ymm0
-	vpunpckldq	%ymm11,%ymm0,%ymm10
-	vpunpckhdq	%ymm11,%ymm0,%ymm11
-	vmovdqa		%ymm12,%ymm0
-	vpunpckldq	%ymm13,%ymm0,%ymm12
-	vpunpckhdq	%ymm13,%ymm0,%ymm13
-	vmovdqa		%ymm14,%ymm0
-	vpunpckldq	%ymm15,%ymm0,%ymm14
-	vpunpckhdq	%ymm15,%ymm0,%ymm15
-
-	# interleave 64-bit words in state n, n+2
-	vmovdqa		0x00(%rsp),%ymm0
-	vmovdqa		0x40(%rsp),%ymm2
-	vpunpcklqdq	%ymm2,%ymm0,%ymm1
-	vpunpckhqdq	%ymm2,%ymm0,%ymm2
-	vmovdqa		%ymm1,0x00(%rsp)
-	vmovdqa		%ymm2,0x40(%rsp)
-	vmovdqa		0x20(%rsp),%ymm0
-	vmovdqa		0x60(%rsp),%ymm2
-	vpunpcklqdq	%ymm2,%ymm0,%ymm1
-	vpunpckhqdq	%ymm2,%ymm0,%ymm2
-	vmovdqa		%ymm1,0x20(%rsp)
-	vmovdqa		%ymm2,0x60(%rsp)
-	vmovdqa		%ymm4,%ymm0
-	vpunpcklqdq	%ymm6,%ymm0,%ymm4
-	vpunpckhqdq	%ymm6,%ymm0,%ymm6
-	vmovdqa		%ymm5,%ymm0
-	vpunpcklqdq	%ymm7,%ymm0,%ymm5
-	vpunpckhqdq	%ymm7,%ymm0,%ymm7
-	vmovdqa		%ymm8,%ymm0
-	vpunpcklqdq	%ymm10,%ymm0,%ymm8
-	vpunpckhqdq	%ymm10,%ymm0,%ymm10
-	vmovdqa		%ymm9,%ymm0
-	vpunpcklqdq	%ymm11,%ymm0,%ymm9
-	vpunpckhqdq	%ymm11,%ymm0,%ymm11
-	vmovdqa		%ymm12,%ymm0
-	vpunpcklqdq	%ymm14,%ymm0,%ymm12
-	vpunpckhqdq	%ymm14,%ymm0,%ymm14
-	vmovdqa		%ymm13,%ymm0
-	vpunpcklqdq	%ymm15,%ymm0,%ymm13
-	vpunpckhqdq	%ymm15,%ymm0,%ymm15
-
-	# interleave 128-bit words in state n, n+4
-	vmovdqa		0x00(%rsp),%ymm0
-	vperm2i128	$0x20,%ymm4,%ymm0,%ymm1
-	vperm2i128	$0x31,%ymm4,%ymm0,%ymm4
-	vmovdqa		%ymm1,0x00(%rsp)
-	vmovdqa		0x20(%rsp),%ymm0
-	vperm2i128	$0x20,%ymm5,%ymm0,%ymm1
-	vperm2i128	$0x31,%ymm5,%ymm0,%ymm5
-	vmovdqa		%ymm1,0x20(%rsp)
-	vmovdqa		0x40(%rsp),%ymm0
-	vperm2i128	$0x20,%ymm6,%ymm0,%ymm1
-	vperm2i128	$0x31,%ymm6,%ymm0,%ymm6
-	vmovdqa		%ymm1,0x40(%rsp)
-	vmovdqa		0x60(%rsp),%ymm0
-	vperm2i128	$0x20,%ymm7,%ymm0,%ymm1
-	vperm2i128	$0x31,%ymm7,%ymm0,%ymm7
-	vmovdqa		%ymm1,0x60(%rsp)
-	vperm2i128	$0x20,%ymm12,%ymm8,%ymm0
-	vperm2i128	$0x31,%ymm12,%ymm8,%ymm12
-	vmovdqa		%ymm0,%ymm8
-	vperm2i128	$0x20,%ymm13,%ymm9,%ymm0
-	vperm2i128	$0x31,%ymm13,%ymm9,%ymm13
-	vmovdqa		%ymm0,%ymm9
-	vperm2i128	$0x20,%ymm14,%ymm10,%ymm0
-	vperm2i128	$0x31,%ymm14,%ymm10,%ymm14
-	vmovdqa		%ymm0,%ymm10
-	vperm2i128	$0x20,%ymm15,%ymm11,%ymm0
-	vperm2i128	$0x31,%ymm15,%ymm11,%ymm15
-	vmovdqa		%ymm0,%ymm11
-
-	# xor with corresponding input, write to output
-	vmovdqa		0x00(%rsp),%ymm0
-	vpxor		0x0000(%rdx),%ymm0,%ymm0
-	vmovdqu		%ymm0,0x0000(%rsi)
-	vmovdqa		0x20(%rsp),%ymm0
-	vpxor		0x0080(%rdx),%ymm0,%ymm0
-	vmovdqu		%ymm0,0x0080(%rsi)
-	vmovdqa		0x40(%rsp),%ymm0
-	vpxor		0x0040(%rdx),%ymm0,%ymm0
-	vmovdqu		%ymm0,0x0040(%rsi)
-	vmovdqa		0x60(%rsp),%ymm0
-	vpxor		0x00c0(%rdx),%ymm0,%ymm0
-	vmovdqu		%ymm0,0x00c0(%rsi)
-	vpxor		0x0100(%rdx),%ymm4,%ymm4
-	vmovdqu		%ymm4,0x0100(%rsi)
-	vpxor		0x0180(%rdx),%ymm5,%ymm5
-	vmovdqu		%ymm5,0x00180(%rsi)
-	vpxor		0x0140(%rdx),%ymm6,%ymm6
-	vmovdqu		%ymm6,0x0140(%rsi)
-	vpxor		0x01c0(%rdx),%ymm7,%ymm7
-	vmovdqu		%ymm7,0x01c0(%rsi)
-	vpxor		0x0020(%rdx),%ymm8,%ymm8
-	vmovdqu		%ymm8,0x0020(%rsi)
-	vpxor		0x00a0(%rdx),%ymm9,%ymm9
-	vmovdqu		%ymm9,0x00a0(%rsi)
-	vpxor		0x0060(%rdx),%ymm10,%ymm10
-	vmovdqu		%ymm10,0x0060(%rsi)
-	vpxor		0x00e0(%rdx),%ymm11,%ymm11
-	vmovdqu		%ymm11,0x00e0(%rsi)
-	vpxor		0x0120(%rdx),%ymm12,%ymm12
-	vmovdqu		%ymm12,0x0120(%rsi)
-	vpxor		0x01a0(%rdx),%ymm13,%ymm13
-	vmovdqu		%ymm13,0x01a0(%rsi)
-	vpxor		0x0160(%rdx),%ymm14,%ymm14
-	vmovdqu		%ymm14,0x0160(%rsi)
-	vpxor		0x01e0(%rdx),%ymm15,%ymm15
-	vmovdqu		%ymm15,0x01e0(%rsi)
-
-	vzeroupper
-	lea		-8(%r10),%rsp
-	ret
-ENDPROC(chacha20_8block_xor_avx2)
diff --git a/arch/x86/crypto/chacha20-ssse3-x86_64.S b/arch/x86/crypto/chacha20-ssse3-x86_64.S
deleted file mode 100644
index 512a2b500fd1..000000000000
--- a/arch/x86/crypto/chacha20-ssse3-x86_64.S
+++ /dev/null
@@ -1,630 +0,0 @@
-/*
- * ChaCha20 256-bit cipher algorithm, RFC7539, x64 SSSE3 functions
- *
- * Copyright (C) 2015 Martin Willi
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <linux/linkage.h>
-
-.section	.rodata.cst16.ROT8, "aM", @progbits, 16
-.align 16
-ROT8:	.octa 0x0e0d0c0f0a09080b0605040702010003
-.section	.rodata.cst16.ROT16, "aM", @progbits, 16
-.align 16
-ROT16:	.octa 0x0d0c0f0e09080b0a0504070601000302
-.section	.rodata.cst16.CTRINC, "aM", @progbits, 16
-.align 16
-CTRINC:	.octa 0x00000003000000020000000100000000
-
-.text
-
-ENTRY(chacha20_block_xor_ssse3)
-	# %rdi: Input state matrix, s
-	# %rsi: 1 data block output, o
-	# %rdx: 1 data block input, i
-
-	# This function encrypts one ChaCha20 block by loading the state matrix
-	# in four SSE registers. It performs matrix operation on four words in
-	# parallel, but requireds shuffling to rearrange the words after each
-	# round. 8/16-bit word rotation is done with the slightly better
-	# performing SSSE3 byte shuffling, 7/12-bit word rotation uses
-	# traditional shift+OR.
-
-	# x0..3 = s0..3
-	movdqa		0x00(%rdi),%xmm0
-	movdqa		0x10(%rdi),%xmm1
-	movdqa		0x20(%rdi),%xmm2
-	movdqa		0x30(%rdi),%xmm3
-	movdqa		%xmm0,%xmm8
-	movdqa		%xmm1,%xmm9
-	movdqa		%xmm2,%xmm10
-	movdqa		%xmm3,%xmm11
-
-	movdqa		ROT8(%rip),%xmm4
-	movdqa		ROT16(%rip),%xmm5
-
-	mov	$10,%ecx
-
-.Ldoubleround:
-
-	# x0 += x1, x3 = rotl32(x3 ^ x0, 16)
-	paddd		%xmm1,%xmm0
-	pxor		%xmm0,%xmm3
-	pshufb		%xmm5,%xmm3
-
-	# x2 += x3, x1 = rotl32(x1 ^ x2, 12)
-	paddd		%xmm3,%xmm2
-	pxor		%xmm2,%xmm1
-	movdqa		%xmm1,%xmm6
-	pslld		$12,%xmm6
-	psrld		$20,%xmm1
-	por		%xmm6,%xmm1
-
-	# x0 += x1, x3 = rotl32(x3 ^ x0, 8)
-	paddd		%xmm1,%xmm0
-	pxor		%xmm0,%xmm3
-	pshufb		%xmm4,%xmm3
-
-	# x2 += x3, x1 = rotl32(x1 ^ x2, 7)
-	paddd		%xmm3,%xmm2
-	pxor		%xmm2,%xmm1
-	movdqa		%xmm1,%xmm7
-	pslld		$7,%xmm7
-	psrld		$25,%xmm1
-	por		%xmm7,%xmm1
-
-	# x1 = shuffle32(x1, MASK(0, 3, 2, 1))
-	pshufd		$0x39,%xmm1,%xmm1
-	# x2 = shuffle32(x2, MASK(1, 0, 3, 2))
-	pshufd		$0x4e,%xmm2,%xmm2
-	# x3 = shuffle32(x3, MASK(2, 1, 0, 3))
-	pshufd		$0x93,%xmm3,%xmm3
-
-	# x0 += x1, x3 = rotl32(x3 ^ x0, 16)
-	paddd		%xmm1,%xmm0
-	pxor		%xmm0,%xmm3
-	pshufb		%xmm5,%xmm3
-
-	# x2 += x3, x1 = rotl32(x1 ^ x2, 12)
-	paddd		%xmm3,%xmm2
-	pxor		%xmm2,%xmm1
-	movdqa		%xmm1,%xmm6
-	pslld		$12,%xmm6
-	psrld		$20,%xmm1
-	por		%xmm6,%xmm1
-
-	# x0 += x1, x3 = rotl32(x3 ^ x0, 8)
-	paddd		%xmm1,%xmm0
-	pxor		%xmm0,%xmm3
-	pshufb		%xmm4,%xmm3
-
-	# x2 += x3, x1 = rotl32(x1 ^ x2, 7)
-	paddd		%xmm3,%xmm2
-	pxor		%xmm2,%xmm1
-	movdqa		%xmm1,%xmm7
-	pslld		$7,%xmm7
-	psrld		$25,%xmm1
-	por		%xmm7,%xmm1
-
-	# x1 = shuffle32(x1, MASK(2, 1, 0, 3))
-	pshufd		$0x93,%xmm1,%xmm1
-	# x2 = shuffle32(x2, MASK(1, 0, 3, 2))
-	pshufd		$0x4e,%xmm2,%xmm2
-	# x3 = shuffle32(x3, MASK(0, 3, 2, 1))
-	pshufd		$0x39,%xmm3,%xmm3
-
-	dec		%ecx
-	jnz		.Ldoubleround
-
-	# o0 = i0 ^ (x0 + s0)
-	movdqu		0x00(%rdx),%xmm4
-	paddd		%xmm8,%xmm0
-	pxor		%xmm4,%xmm0
-	movdqu		%xmm0,0x00(%rsi)
-	# o1 = i1 ^ (x1 + s1)
-	movdqu		0x10(%rdx),%xmm5
-	paddd		%xmm9,%xmm1
-	pxor		%xmm5,%xmm1
-	movdqu		%xmm1,0x10(%rsi)
-	# o2 = i2 ^ (x2 + s2)
-	movdqu		0x20(%rdx),%xmm6
-	paddd		%xmm10,%xmm2
-	pxor		%xmm6,%xmm2
-	movdqu		%xmm2,0x20(%rsi)
-	# o3 = i3 ^ (x3 + s3)
-	movdqu		0x30(%rdx),%xmm7
-	paddd		%xmm11,%xmm3
-	pxor		%xmm7,%xmm3
-	movdqu		%xmm3,0x30(%rsi)
-
-	ret
-ENDPROC(chacha20_block_xor_ssse3)
-
-ENTRY(chacha20_4block_xor_ssse3)
-	# %rdi: Input state matrix, s
-	# %rsi: 4 data blocks output, o
-	# %rdx: 4 data blocks input, i
-
-	# This function encrypts four consecutive ChaCha20 blocks by loading the
-	# the state matrix in SSE registers four times. As we need some scratch
-	# registers, we save the first four registers on the stack. The
-	# algorithm performs each operation on the corresponding word of each
-	# state matrix, hence requires no word shuffling. For final XORing step
-	# we transpose the matrix by interleaving 32- and then 64-bit words,
-	# which allows us to do XOR in SSE registers. 8/16-bit word rotation is
-	# done with the slightly better performing SSSE3 byte shuffling,
-	# 7/12-bit word rotation uses traditional shift+OR.
-
-	lea		8(%rsp),%r10
-	sub		$0x80,%rsp
-	and		$~63,%rsp
-
-	# x0..15[0-3] = s0..3[0..3]
-	movq		0x00(%rdi),%xmm1
-	pshufd		$0x00,%xmm1,%xmm0
-	pshufd		$0x55,%xmm1,%xmm1
-	movq		0x08(%rdi),%xmm3
-	pshufd		$0x00,%xmm3,%xmm2
-	pshufd		$0x55,%xmm3,%xmm3
-	movq		0x10(%rdi),%xmm5
-	pshufd		$0x00,%xmm5,%xmm4
-	pshufd		$0x55,%xmm5,%xmm5
-	movq		0x18(%rdi),%xmm7
-	pshufd		$0x00,%xmm7,%xmm6
-	pshufd		$0x55,%xmm7,%xmm7
-	movq		0x20(%rdi),%xmm9
-	pshufd		$0x00,%xmm9,%xmm8
-	pshufd		$0x55,%xmm9,%xmm9
-	movq		0x28(%rdi),%xmm11
-	pshufd		$0x00,%xmm11,%xmm10
-	pshufd		$0x55,%xmm11,%xmm11
-	movq		0x30(%rdi),%xmm13
-	pshufd		$0x00,%xmm13,%xmm12
-	pshufd		$0x55,%xmm13,%xmm13
-	movq		0x38(%rdi),%xmm15
-	pshufd		$0x00,%xmm15,%xmm14
-	pshufd		$0x55,%xmm15,%xmm15
-	# x0..3 on stack
-	movdqa		%xmm0,0x00(%rsp)
-	movdqa		%xmm1,0x10(%rsp)
-	movdqa		%xmm2,0x20(%rsp)
-	movdqa		%xmm3,0x30(%rsp)
-
-	movdqa		CTRINC(%rip),%xmm1
-	movdqa		ROT8(%rip),%xmm2
-	movdqa		ROT16(%rip),%xmm3
-
-	# x12 += counter values 0-3
-	paddd		%xmm1,%xmm12
-
-	mov		$10,%ecx
-
-.Ldoubleround4:
-	# x0 += x4, x12 = rotl32(x12 ^ x0, 16)
-	movdqa		0x00(%rsp),%xmm0
-	paddd		%xmm4,%xmm0
-	movdqa		%xmm0,0x00(%rsp)
-	pxor		%xmm0,%xmm12
-	pshufb		%xmm3,%xmm12
-	# x1 += x5, x13 = rotl32(x13 ^ x1, 16)
-	movdqa		0x10(%rsp),%xmm0
-	paddd		%xmm5,%xmm0
-	movdqa		%xmm0,0x10(%rsp)
-	pxor		%xmm0,%xmm13
-	pshufb		%xmm3,%xmm13
-	# x2 += x6, x14 = rotl32(x14 ^ x2, 16)
-	movdqa		0x20(%rsp),%xmm0
-	paddd		%xmm6,%xmm0
-	movdqa		%xmm0,0x20(%rsp)
-	pxor		%xmm0,%xmm14
-	pshufb		%xmm3,%xmm14
-	# x3 += x7, x15 = rotl32(x15 ^ x3, 16)
-	movdqa		0x30(%rsp),%xmm0
-	paddd		%xmm7,%xmm0
-	movdqa		%xmm0,0x30(%rsp)
-	pxor		%xmm0,%xmm15
-	pshufb		%xmm3,%xmm15
-
-	# x8 += x12, x4 = rotl32(x4 ^ x8, 12)
-	paddd		%xmm12,%xmm8
-	pxor		%xmm8,%xmm4
-	movdqa		%xmm4,%xmm0
-	pslld		$12,%xmm0
-	psrld		$20,%xmm4
-	por		%xmm0,%xmm4
-	# x9 += x13, x5 = rotl32(x5 ^ x9, 12)
-	paddd		%xmm13,%xmm9
-	pxor		%xmm9,%xmm5
-	movdqa		%xmm5,%xmm0
-	pslld		$12,%xmm0
-	psrld		$20,%xmm5
-	por		%xmm0,%xmm5
-	# x10 += x14, x6 = rotl32(x6 ^ x10, 12)
-	paddd		%xmm14,%xmm10
-	pxor		%xmm10,%xmm6
-	movdqa		%xmm6,%xmm0
-	pslld		$12,%xmm0
-	psrld		$20,%xmm6
-	por		%xmm0,%xmm6
-	# x11 += x15, x7 = rotl32(x7 ^ x11, 12)
-	paddd		%xmm15,%xmm11
-	pxor		%xmm11,%xmm7
-	movdqa		%xmm7,%xmm0
-	pslld		$12,%xmm0
-	psrld		$20,%xmm7
-	por		%xmm0,%xmm7
-
-	# x0 += x4, x12 = rotl32(x12 ^ x0, 8)
-	movdqa		0x00(%rsp),%xmm0
-	paddd		%xmm4,%xmm0
-	movdqa		%xmm0,0x00(%rsp)
-	pxor		%xmm0,%xmm12
-	pshufb		%xmm2,%xmm12
-	# x1 += x5, x13 = rotl32(x13 ^ x1, 8)
-	movdqa		0x10(%rsp),%xmm0
-	paddd		%xmm5,%xmm0
-	movdqa		%xmm0,0x10(%rsp)
-	pxor		%xmm0,%xmm13
-	pshufb		%xmm2,%xmm13
-	# x2 += x6, x14 = rotl32(x14 ^ x2, 8)
-	movdqa		0x20(%rsp),%xmm0
-	paddd		%xmm6,%xmm0
-	movdqa		%xmm0,0x20(%rsp)
-	pxor		%xmm0,%xmm14
-	pshufb		%xmm2,%xmm14
-	# x3 += x7, x15 = rotl32(x15 ^ x3, 8)
-	movdqa		0x30(%rsp),%xmm0
-	paddd		%xmm7,%xmm0
-	movdqa		%xmm0,0x30(%rsp)
-	pxor		%xmm0,%xmm15
-	pshufb		%xmm2,%xmm15
-
-	# x8 += x12, x4 = rotl32(x4 ^ x8, 7)
-	paddd		%xmm12,%xmm8
-	pxor		%xmm8,%xmm4
-	movdqa		%xmm4,%xmm0
-	pslld		$7,%xmm0
-	psrld		$25,%xmm4
-	por		%xmm0,%xmm4
-	# x9 += x13, x5 = rotl32(x5 ^ x9, 7)
-	paddd		%xmm13,%xmm9
-	pxor		%xmm9,%xmm5
-	movdqa		%xmm5,%xmm0
-	pslld		$7,%xmm0
-	psrld		$25,%xmm5
-	por		%xmm0,%xmm5
-	# x10 += x14, x6 = rotl32(x6 ^ x10, 7)
-	paddd		%xmm14,%xmm10
-	pxor		%xmm10,%xmm6
-	movdqa		%xmm6,%xmm0
-	pslld		$7,%xmm0
-	psrld		$25,%xmm6
-	por		%xmm0,%xmm6
-	# x11 += x15, x7 = rotl32(x7 ^ x11, 7)
-	paddd		%xmm15,%xmm11
-	pxor		%xmm11,%xmm7
-	movdqa		%xmm7,%xmm0
-	pslld		$7,%xmm0
-	psrld		$25,%xmm7
-	por		%xmm0,%xmm7
-
-	# x0 += x5, x15 = rotl32(x15 ^ x0, 16)
-	movdqa		0x00(%rsp),%xmm0
-	paddd		%xmm5,%xmm0
-	movdqa		%xmm0,0x00(%rsp)
-	pxor		%xmm0,%xmm15
-	pshufb		%xmm3,%xmm15
-	# x1 += x6, x12 = rotl32(x12 ^ x1, 16)
-	movdqa		0x10(%rsp),%xmm0
-	paddd		%xmm6,%xmm0
-	movdqa		%xmm0,0x10(%rsp)
-	pxor		%xmm0,%xmm12
-	pshufb		%xmm3,%xmm12
-	# x2 += x7, x13 = rotl32(x13 ^ x2, 16)
-	movdqa		0x20(%rsp),%xmm0
-	paddd		%xmm7,%xmm0
-	movdqa		%xmm0,0x20(%rsp)
-	pxor		%xmm0,%xmm13
-	pshufb		%xmm3,%xmm13
-	# x3 += x4, x14 = rotl32(x14 ^ x3, 16)
-	movdqa		0x30(%rsp),%xmm0
-	paddd		%xmm4,%xmm0
-	movdqa		%xmm0,0x30(%rsp)
-	pxor		%xmm0,%xmm14
-	pshufb		%xmm3,%xmm14
-
-	# x10 += x15, x5 = rotl32(x5 ^ x10, 12)
-	paddd		%xmm15,%xmm10
-	pxor		%xmm10,%xmm5
-	movdqa		%xmm5,%xmm0
-	pslld		$12,%xmm0
-	psrld		$20,%xmm5
-	por		%xmm0,%xmm5
-	# x11 += x12, x6 = rotl32(x6 ^ x11, 12)
-	paddd		%xmm12,%xmm11
-	pxor		%xmm11,%xmm6
-	movdqa		%xmm6,%xmm0
-	pslld		$12,%xmm0
-	psrld		$20,%xmm6
-	por		%xmm0,%xmm6
-	# x8 += x13, x7 = rotl32(x7 ^ x8, 12)
-	paddd		%xmm13,%xmm8
-	pxor		%xmm8,%xmm7
-	movdqa		%xmm7,%xmm0
-	pslld		$12,%xmm0
-	psrld		$20,%xmm7
-	por		%xmm0,%xmm7
-	# x9 += x14, x4 = rotl32(x4 ^ x9, 12)
-	paddd		%xmm14,%xmm9
-	pxor		%xmm9,%xmm4
-	movdqa		%xmm4,%xmm0
-	pslld		$12,%xmm0
-	psrld		$20,%xmm4
-	por		%xmm0,%xmm4
-
-	# x0 += x5, x15 = rotl32(x15 ^ x0, 8)
-	movdqa		0x00(%rsp),%xmm0
-	paddd		%xmm5,%xmm0
-	movdqa		%xmm0,0x00(%rsp)
-	pxor		%xmm0,%xmm15
-	pshufb		%xmm2,%xmm15
-	# x1 += x6, x12 = rotl32(x12 ^ x1, 8)
-	movdqa		0x10(%rsp),%xmm0
-	paddd		%xmm6,%xmm0
-	movdqa		%xmm0,0x10(%rsp)
-	pxor		%xmm0,%xmm12
-	pshufb		%xmm2,%xmm12
-	# x2 += x7, x13 = rotl32(x13 ^ x2, 8)
-	movdqa		0x20(%rsp),%xmm0
-	paddd		%xmm7,%xmm0
-	movdqa		%xmm0,0x20(%rsp)
-	pxor		%xmm0,%xmm13
-	pshufb		%xmm2,%xmm13
-	# x3 += x4, x14 = rotl32(x14 ^ x3, 8)
-	movdqa		0x30(%rsp),%xmm0
-	paddd		%xmm4,%xmm0
-	movdqa		%xmm0,0x30(%rsp)
-	pxor		%xmm0,%xmm14
-	pshufb		%xmm2,%xmm14
-
-	# x10 += x15, x5 = rotl32(x5 ^ x10, 7)
-	paddd		%xmm15,%xmm10
-	pxor		%xmm10,%xmm5
-	movdqa		%xmm5,%xmm0
-	pslld		$7,%xmm0
-	psrld		$25,%xmm5
-	por		%xmm0,%xmm5
-	# x11 += x12, x6 = rotl32(x6 ^ x11, 7)
-	paddd		%xmm12,%xmm11
-	pxor		%xmm11,%xmm6
-	movdqa		%xmm6,%xmm0
-	pslld		$7,%xmm0
-	psrld		$25,%xmm6
-	por		%xmm0,%xmm6
-	# x8 += x13, x7 = rotl32(x7 ^ x8, 7)
-	paddd		%xmm13,%xmm8
-	pxor		%xmm8,%xmm7
-	movdqa		%xmm7,%xmm0
-	pslld		$7,%xmm0
-	psrld		$25,%xmm7
-	por		%xmm0,%xmm7
-	# x9 += x14, x4 = rotl32(x4 ^ x9, 7)
-	paddd		%xmm14,%xmm9
-	pxor		%xmm9,%xmm4
-	movdqa		%xmm4,%xmm0
-	pslld		$7,%xmm0
-	psrld		$25,%xmm4
-	por		%xmm0,%xmm4
-
-	dec		%ecx
-	jnz		.Ldoubleround4
-
-	# x0[0-3] += s0[0]
-	# x1[0-3] += s0[1]
-	movq		0x00(%rdi),%xmm3
-	pshufd		$0x00,%xmm3,%xmm2
-	pshufd		$0x55,%xmm3,%xmm3
-	paddd		0x00(%rsp),%xmm2
-	movdqa		%xmm2,0x00(%rsp)
-	paddd		0x10(%rsp),%xmm3
-	movdqa		%xmm3,0x10(%rsp)
-	# x2[0-3] += s0[2]
-	# x3[0-3] += s0[3]
-	movq		0x08(%rdi),%xmm3
-	pshufd		$0x00,%xmm3,%xmm2
-	pshufd		$0x55,%xmm3,%xmm3
-	paddd		0x20(%rsp),%xmm2
-	movdqa		%xmm2,0x20(%rsp)
-	paddd		0x30(%rsp),%xmm3
-	movdqa		%xmm3,0x30(%rsp)
-
-	# x4[0-3] += s1[0]
-	# x5[0-3] += s1[1]
-	movq		0x10(%rdi),%xmm3
-	pshufd		$0x00,%xmm3,%xmm2
-	pshufd		$0x55,%xmm3,%xmm3
-	paddd		%xmm2,%xmm4
-	paddd		%xmm3,%xmm5
-	# x6[0-3] += s1[2]
-	# x7[0-3] += s1[3]
-	movq		0x18(%rdi),%xmm3
-	pshufd		$0x00,%xmm3,%xmm2
-	pshufd		$0x55,%xmm3,%xmm3
-	paddd		%xmm2,%xmm6
-	paddd		%xmm3,%xmm7
-
-	# x8[0-3] += s2[0]
-	# x9[0-3] += s2[1]
-	movq		0x20(%rdi),%xmm3
-	pshufd		$0x00,%xmm3,%xmm2
-	pshufd		$0x55,%xmm3,%xmm3
-	paddd		%xmm2,%xmm8
-	paddd		%xmm3,%xmm9
-	# x10[0-3] += s2[2]
-	# x11[0-3] += s2[3]
-	movq		0x28(%rdi),%xmm3
-	pshufd		$0x00,%xmm3,%xmm2
-	pshufd		$0x55,%xmm3,%xmm3
-	paddd		%xmm2,%xmm10
-	paddd		%xmm3,%xmm11
-
-	# x12[0-3] += s3[0]
-	# x13[0-3] += s3[1]
-	movq		0x30(%rdi),%xmm3
-	pshufd		$0x00,%xmm3,%xmm2
-	pshufd		$0x55,%xmm3,%xmm3
-	paddd		%xmm2,%xmm12
-	paddd		%xmm3,%xmm13
-	# x14[0-3] += s3[2]
-	# x15[0-3] += s3[3]
-	movq		0x38(%rdi),%xmm3
-	pshufd		$0x00,%xmm3,%xmm2
-	pshufd		$0x55,%xmm3,%xmm3
-	paddd		%xmm2,%xmm14
-	paddd		%xmm3,%xmm15
-
-	# x12 += counter values 0-3
-	paddd		%xmm1,%xmm12
-
-	# interleave 32-bit words in state n, n+1
-	movdqa		0x00(%rsp),%xmm0
-	movdqa		0x10(%rsp),%xmm1
-	movdqa		%xmm0,%xmm2
-	punpckldq	%xmm1,%xmm2
-	punpckhdq	%xmm1,%xmm0
-	movdqa		%xmm2,0x00(%rsp)
-	movdqa		%xmm0,0x10(%rsp)
-	movdqa		0x20(%rsp),%xmm0
-	movdqa		0x30(%rsp),%xmm1
-	movdqa		%xmm0,%xmm2
-	punpckldq	%xmm1,%xmm2
-	punpckhdq	%xmm1,%xmm0
-	movdqa		%xmm2,0x20(%rsp)
-	movdqa		%xmm0,0x30(%rsp)
-	movdqa		%xmm4,%xmm0
-	punpckldq	%xmm5,%xmm4
-	punpckhdq	%xmm5,%xmm0
-	movdqa		%xmm0,%xmm5
-	movdqa		%xmm6,%xmm0
-	punpckldq	%xmm7,%xmm6
-	punpckhdq	%xmm7,%xmm0
-	movdqa		%xmm0,%xmm7
-	movdqa		%xmm8,%xmm0
-	punpckldq	%xmm9,%xmm8
-	punpckhdq	%xmm9,%xmm0
-	movdqa		%xmm0,%xmm9
-	movdqa		%xmm10,%xmm0
-	punpckldq	%xmm11,%xmm10
-	punpckhdq	%xmm11,%xmm0
-	movdqa		%xmm0,%xmm11
-	movdqa		%xmm12,%xmm0
-	punpckldq	%xmm13,%xmm12
-	punpckhdq	%xmm13,%xmm0
-	movdqa		%xmm0,%xmm13
-	movdqa		%xmm14,%xmm0
-	punpckldq	%xmm15,%xmm14
-	punpckhdq	%xmm15,%xmm0
-	movdqa		%xmm0,%xmm15
-
-	# interleave 64-bit words in state n, n+2
-	movdqa		0x00(%rsp),%xmm0
-	movdqa		0x20(%rsp),%xmm1
-	movdqa		%xmm0,%xmm2
-	punpcklqdq	%xmm1,%xmm2
-	punpckhqdq	%xmm1,%xmm0
-	movdqa		%xmm2,0x00(%rsp)
-	movdqa		%xmm0,0x20(%rsp)
-	movdqa		0x10(%rsp),%xmm0
-	movdqa		0x30(%rsp),%xmm1
-	movdqa		%xmm0,%xmm2
-	punpcklqdq	%xmm1,%xmm2
-	punpckhqdq	%xmm1,%xmm0
-	movdqa		%xmm2,0x10(%rsp)
-	movdqa		%xmm0,0x30(%rsp)
-	movdqa		%xmm4,%xmm0
-	punpcklqdq	%xmm6,%xmm4
-	punpckhqdq	%xmm6,%xmm0
-	movdqa		%xmm0,%xmm6
-	movdqa		%xmm5,%xmm0
-	punpcklqdq	%xmm7,%xmm5
-	punpckhqdq	%xmm7,%xmm0
-	movdqa		%xmm0,%xmm7
-	movdqa		%xmm8,%xmm0
-	punpcklqdq	%xmm10,%xmm8
-	punpckhqdq	%xmm10,%xmm0
-	movdqa		%xmm0,%xmm10
-	movdqa		%xmm9,%xmm0
-	punpcklqdq	%xmm11,%xmm9
-	punpckhqdq	%xmm11,%xmm0
-	movdqa		%xmm0,%xmm11
-	movdqa		%xmm12,%xmm0
-	punpcklqdq	%xmm14,%xmm12
-	punpckhqdq	%xmm14,%xmm0
-	movdqa		%xmm0,%xmm14
-	movdqa		%xmm13,%xmm0
-	punpcklqdq	%xmm15,%xmm13
-	punpckhqdq	%xmm15,%xmm0
-	movdqa		%xmm0,%xmm15
-
-	# xor with corresponding input, write to output
-	movdqa		0x00(%rsp),%xmm0
-	movdqu		0x00(%rdx),%xmm1
-	pxor		%xmm1,%xmm0
-	movdqu		%xmm0,0x00(%rsi)
-	movdqa		0x10(%rsp),%xmm0
-	movdqu		0x80(%rdx),%xmm1
-	pxor		%xmm1,%xmm0
-	movdqu		%xmm0,0x80(%rsi)
-	movdqa		0x20(%rsp),%xmm0
-	movdqu		0x40(%rdx),%xmm1
-	pxor		%xmm1,%xmm0
-	movdqu		%xmm0,0x40(%rsi)
-	movdqa		0x30(%rsp),%xmm0
-	movdqu		0xc0(%rdx),%xmm1
-	pxor		%xmm1,%xmm0
-	movdqu		%xmm0,0xc0(%rsi)
-	movdqu		0x10(%rdx),%xmm1
-	pxor		%xmm1,%xmm4
-	movdqu		%xmm4,0x10(%rsi)
-	movdqu		0x90(%rdx),%xmm1
-	pxor		%xmm1,%xmm5
-	movdqu		%xmm5,0x90(%rsi)
-	movdqu		0x50(%rdx),%xmm1
-	pxor		%xmm1,%xmm6
-	movdqu		%xmm6,0x50(%rsi)
-	movdqu		0xd0(%rdx),%xmm1
-	pxor		%xmm1,%xmm7
-	movdqu		%xmm7,0xd0(%rsi)
-	movdqu		0x20(%rdx),%xmm1
-	pxor		%xmm1,%xmm8
-	movdqu		%xmm8,0x20(%rsi)
-	movdqu		0xa0(%rdx),%xmm1
-	pxor		%xmm1,%xmm9
-	movdqu		%xmm9,0xa0(%rsi)
-	movdqu		0x60(%rdx),%xmm1
-	pxor		%xmm1,%xmm10
-	movdqu		%xmm10,0x60(%rsi)
-	movdqu		0xe0(%rdx),%xmm1
-	pxor		%xmm1,%xmm11
-	movdqu		%xmm11,0xe0(%rsi)
-	movdqu		0x30(%rdx),%xmm1
-	pxor		%xmm1,%xmm12
-	movdqu		%xmm12,0x30(%rsi)
-	movdqu		0xb0(%rdx),%xmm1
-	pxor		%xmm1,%xmm13
-	movdqu		%xmm13,0xb0(%rsi)
-	movdqu		0x70(%rdx),%xmm1
-	pxor		%xmm1,%xmm14
-	movdqu		%xmm14,0x70(%rsi)
-	movdqu		0xf0(%rdx),%xmm1
-	pxor		%xmm1,%xmm15
-	movdqu		%xmm15,0xf0(%rsi)
-
-	lea		-8(%r10),%rsp
-	ret
-ENDPROC(chacha20_4block_xor_ssse3)
diff --git a/arch/x86/crypto/chacha20_glue.c b/arch/x86/crypto/chacha20_glue.c
deleted file mode 100644
index dce7c5d39c2f..000000000000
--- a/arch/x86/crypto/chacha20_glue.c
+++ /dev/null
@@ -1,146 +0,0 @@
-/*
- * ChaCha20 256-bit cipher algorithm, RFC7539, SIMD glue code
- *
- * Copyright (C) 2015 Martin Willi
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <crypto/algapi.h>
-#include <crypto/chacha20.h>
-#include <crypto/internal/skcipher.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <asm/fpu/api.h>
-#include <asm/simd.h>
-
-#define CHACHA20_STATE_ALIGN 16
-
-asmlinkage void chacha20_block_xor_ssse3(u32 *state, u8 *dst, const u8 *src);
-asmlinkage void chacha20_4block_xor_ssse3(u32 *state, u8 *dst, const u8 *src);
-#ifdef CONFIG_AS_AVX2
-asmlinkage void chacha20_8block_xor_avx2(u32 *state, u8 *dst, const u8 *src);
-static bool chacha20_use_avx2;
-#endif
-
-static void chacha20_dosimd(u32 *state, u8 *dst, const u8 *src,
-			    unsigned int bytes)
-{
-	u8 buf[CHACHA20_BLOCK_SIZE];
-
-#ifdef CONFIG_AS_AVX2
-	if (chacha20_use_avx2) {
-		while (bytes >= CHACHA20_BLOCK_SIZE * 8) {
-			chacha20_8block_xor_avx2(state, dst, src);
-			bytes -= CHACHA20_BLOCK_SIZE * 8;
-			src += CHACHA20_BLOCK_SIZE * 8;
-			dst += CHACHA20_BLOCK_SIZE * 8;
-			state[12] += 8;
-		}
-	}
-#endif
-	while (bytes >= CHACHA20_BLOCK_SIZE * 4) {
-		chacha20_4block_xor_ssse3(state, dst, src);
-		bytes -= CHACHA20_BLOCK_SIZE * 4;
-		src += CHACHA20_BLOCK_SIZE * 4;
-		dst += CHACHA20_BLOCK_SIZE * 4;
-		state[12] += 4;
-	}
-	while (bytes >= CHACHA20_BLOCK_SIZE) {
-		chacha20_block_xor_ssse3(state, dst, src);
-		bytes -= CHACHA20_BLOCK_SIZE;
-		src += CHACHA20_BLOCK_SIZE;
-		dst += CHACHA20_BLOCK_SIZE;
-		state[12]++;
-	}
-	if (bytes) {
-		memcpy(buf, src, bytes);
-		chacha20_block_xor_ssse3(state, buf, buf);
-		memcpy(dst, buf, bytes);
-	}
-}
-
-static int chacha20_simd(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct chacha20_ctx *ctx = crypto_skcipher_ctx(tfm);
-	u32 *state, state_buf[16 + 2] __aligned(8);
-	struct skcipher_walk walk;
-	int err;
-
-	BUILD_BUG_ON(CHACHA20_STATE_ALIGN != 16);
-	state = PTR_ALIGN(state_buf + 0, CHACHA20_STATE_ALIGN);
-
-	if (req->cryptlen <= CHACHA20_BLOCK_SIZE || !may_use_simd())
-		return crypto_chacha20_crypt(req);
-
-	err = skcipher_walk_virt(&walk, req, true);
-
-	crypto_chacha20_init(state, ctx, walk.iv);
-
-	kernel_fpu_begin();
-
-	while (walk.nbytes >= CHACHA20_BLOCK_SIZE) {
-		chacha20_dosimd(state, walk.dst.virt.addr, walk.src.virt.addr,
-				rounddown(walk.nbytes, CHACHA20_BLOCK_SIZE));
-		err = skcipher_walk_done(&walk,
-					 walk.nbytes % CHACHA20_BLOCK_SIZE);
-	}
-
-	if (walk.nbytes) {
-		chacha20_dosimd(state, walk.dst.virt.addr, walk.src.virt.addr,
-				walk.nbytes);
-		err = skcipher_walk_done(&walk, 0);
-	}
-
-	kernel_fpu_end();
-
-	return err;
-}
-
-static struct skcipher_alg alg = {
-	.base.cra_name		= "chacha20",
-	.base.cra_driver_name	= "chacha20-simd",
-	.base.cra_priority	= 300,
-	.base.cra_blocksize	= 1,
-	.base.cra_ctxsize	= sizeof(struct chacha20_ctx),
-	.base.cra_module	= THIS_MODULE,
-
-	.min_keysize		= CHACHA20_KEY_SIZE,
-	.max_keysize		= CHACHA20_KEY_SIZE,
-	.ivsize			= CHACHA20_IV_SIZE,
-	.chunksize		= CHACHA20_BLOCK_SIZE,
-	.setkey			= crypto_chacha20_setkey,
-	.encrypt		= chacha20_simd,
-	.decrypt		= chacha20_simd,
-};
-
-static int __init chacha20_simd_mod_init(void)
-{
-	if (!boot_cpu_has(X86_FEATURE_SSSE3))
-		return -ENODEV;
-
-#ifdef CONFIG_AS_AVX2
-	chacha20_use_avx2 = boot_cpu_has(X86_FEATURE_AVX) &&
-			    boot_cpu_has(X86_FEATURE_AVX2) &&
-			    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL);
-#endif
-	return crypto_register_skcipher(&alg);
-}
-
-static void __exit chacha20_simd_mod_fini(void)
-{
-	crypto_unregister_skcipher(&alg);
-}
-
-module_init(chacha20_simd_mod_init);
-module_exit(chacha20_simd_mod_fini);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Martin Willi <martin@strongswan.org>");
-MODULE_DESCRIPTION("chacha20 cipher algorithm, SIMD accelerated");
-MODULE_ALIAS_CRYPTO("chacha20");
-MODULE_ALIAS_CRYPTO("chacha20-simd");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 47859a0f8052..42dc48aa9b81 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1428,27 +1428,12 @@ config CRYPTO_SALSA20
 config CRYPTO_CHACHA20
 	tristate "ChaCha20 cipher algorithm"
 	select CRYPTO_BLKCIPHER
+	select ZINC_CHACHA20
 	help
 	  ChaCha20 cipher algorithm, RFC7539.
 
 	  ChaCha20 is a 256-bit high-speed stream cipher designed by Daniel J.
 	  Bernstein and further specified in RFC7539 for use in IETF protocols.
-	  This is the portable C implementation of ChaCha20.
-
-	  See also:
-	  <http://cr.yp.to/chacha/chacha-20080128.pdf>
-
-config CRYPTO_CHACHA20_X86_64
-	tristate "ChaCha20 cipher algorithm (x86_64/SSSE3/AVX2)"
-	depends on X86 && 64BIT
-	select CRYPTO_BLKCIPHER
-	select CRYPTO_CHACHA20
-	help
-	  ChaCha20 cipher algorithm, RFC7539.
-
-	  ChaCha20 is a 256-bit high-speed stream cipher designed by Daniel J.
-	  Bernstein and further specified in RFC7539 for use in IETF protocols.
-	  This is the x86_64 assembler implementation using SIMD instructions.
 
 	  See also:
 	  <http://cr.yp.to/chacha/chacha-20080128.pdf>
diff --git a/crypto/Makefile b/crypto/Makefile
index 5e60348d02e2..587103b87890 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -117,7 +117,7 @@ obj-$(CONFIG_CRYPTO_ANUBIS) += anubis.o
 obj-$(CONFIG_CRYPTO_SEED) += seed.o
 obj-$(CONFIG_CRYPTO_SPECK) += speck.o
 obj-$(CONFIG_CRYPTO_SALSA20) += salsa20_generic.o
-obj-$(CONFIG_CRYPTO_CHACHA20) += chacha20_generic.o
+obj-$(CONFIG_CRYPTO_CHACHA20) += chacha20_zinc.o
 obj-$(CONFIG_CRYPTO_POLY1305) += poly1305_zinc.o
 obj-$(CONFIG_CRYPTO_DEFLATE) += deflate.o
 obj-$(CONFIG_CRYPTO_MICHAEL_MIC) += michael_mic.o
diff --git a/crypto/chacha20_generic.c b/crypto/chacha20_generic.c
deleted file mode 100644
index e451c3cb6a56..000000000000
--- a/crypto/chacha20_generic.c
+++ /dev/null
@@ -1,136 +0,0 @@
-/*
- * ChaCha20 256-bit cipher algorithm, RFC7539
- *
- * Copyright (C) 2015 Martin Willi
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <asm/unaligned.h>
-#include <crypto/algapi.h>
-#include <crypto/chacha20.h>
-#include <crypto/internal/skcipher.h>
-#include <linux/module.h>
-
-static void chacha20_docrypt(u32 *state, u8 *dst, const u8 *src,
-			     unsigned int bytes)
-{
-	u32 stream[CHACHA20_BLOCK_WORDS];
-
-	if (dst != src)
-		memcpy(dst, src, bytes);
-
-	while (bytes >= CHACHA20_BLOCK_SIZE) {
-		chacha20_block(state, stream);
-		crypto_xor(dst, (const u8 *)stream, CHACHA20_BLOCK_SIZE);
-		bytes -= CHACHA20_BLOCK_SIZE;
-		dst += CHACHA20_BLOCK_SIZE;
-	}
-	if (bytes) {
-		chacha20_block(state, stream);
-		crypto_xor(dst, (const u8 *)stream, bytes);
-	}
-}
-
-void crypto_chacha20_init(u32 *state, struct chacha20_ctx *ctx, u8 *iv)
-{
-	state[0]  = 0x61707865; /* "expa" */
-	state[1]  = 0x3320646e; /* "nd 3" */
-	state[2]  = 0x79622d32; /* "2-by" */
-	state[3]  = 0x6b206574; /* "te k" */
-	state[4]  = ctx->key[0];
-	state[5]  = ctx->key[1];
-	state[6]  = ctx->key[2];
-	state[7]  = ctx->key[3];
-	state[8]  = ctx->key[4];
-	state[9]  = ctx->key[5];
-	state[10] = ctx->key[6];
-	state[11] = ctx->key[7];
-	state[12] = get_unaligned_le32(iv +  0);
-	state[13] = get_unaligned_le32(iv +  4);
-	state[14] = get_unaligned_le32(iv +  8);
-	state[15] = get_unaligned_le32(iv + 12);
-}
-EXPORT_SYMBOL_GPL(crypto_chacha20_init);
-
-int crypto_chacha20_setkey(struct crypto_skcipher *tfm, const u8 *key,
-			   unsigned int keysize)
-{
-	struct chacha20_ctx *ctx = crypto_skcipher_ctx(tfm);
-	int i;
-
-	if (keysize != CHACHA20_KEY_SIZE)
-		return -EINVAL;
-
-	for (i = 0; i < ARRAY_SIZE(ctx->key); i++)
-		ctx->key[i] = get_unaligned_le32(key + i * sizeof(u32));
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(crypto_chacha20_setkey);
-
-int crypto_chacha20_crypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct chacha20_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct skcipher_walk walk;
-	u32 state[16];
-	int err;
-
-	err = skcipher_walk_virt(&walk, req, true);
-
-	crypto_chacha20_init(state, ctx, walk.iv);
-
-	while (walk.nbytes > 0) {
-		unsigned int nbytes = walk.nbytes;
-
-		if (nbytes < walk.total)
-			nbytes = round_down(nbytes, walk.stride);
-
-		chacha20_docrypt(state, walk.dst.virt.addr, walk.src.virt.addr,
-				 nbytes);
-		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
-	}
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(crypto_chacha20_crypt);
-
-static struct skcipher_alg alg = {
-	.base.cra_name		= "chacha20",
-	.base.cra_driver_name	= "chacha20-generic",
-	.base.cra_priority	= 100,
-	.base.cra_blocksize	= 1,
-	.base.cra_ctxsize	= sizeof(struct chacha20_ctx),
-	.base.cra_module	= THIS_MODULE,
-
-	.min_keysize		= CHACHA20_KEY_SIZE,
-	.max_keysize		= CHACHA20_KEY_SIZE,
-	.ivsize			= CHACHA20_IV_SIZE,
-	.chunksize		= CHACHA20_BLOCK_SIZE,
-	.setkey			= crypto_chacha20_setkey,
-	.encrypt		= crypto_chacha20_crypt,
-	.decrypt		= crypto_chacha20_crypt,
-};
-
-static int __init chacha20_generic_mod_init(void)
-{
-	return crypto_register_skcipher(&alg);
-}
-
-static void __exit chacha20_generic_mod_fini(void)
-{
-	crypto_unregister_skcipher(&alg);
-}
-
-module_init(chacha20_generic_mod_init);
-module_exit(chacha20_generic_mod_fini);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Martin Willi <martin@strongswan.org>");
-MODULE_DESCRIPTION("chacha20 cipher algorithm");
-MODULE_ALIAS_CRYPTO("chacha20");
-MODULE_ALIAS_CRYPTO("chacha20-generic");
diff --git a/crypto/chacha20_zinc.c b/crypto/chacha20_zinc.c
new file mode 100644
index 000000000000..a59ff0c54933
--- /dev/null
+++ b/crypto/chacha20_zinc.c
@@ -0,0 +1,100 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright (C) 2018 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+ */
+
+#include <asm/unaligned.h>
+#include <crypto/algapi.h>
+#include <crypto/internal/skcipher.h>
+#include <zinc/chacha20.h>
+#include <linux/module.h>
+
+struct chacha20_key_ctx {
+	u32 key[8];
+};
+
+static int crypto_chacha20_setkey(struct crypto_skcipher *tfm, const u8 *key,
+				  unsigned int keysize)
+{
+	struct chacha20_key_ctx *key_ctx = crypto_skcipher_ctx(tfm);
+	int i;
+
+	if (keysize != CHACHA20_KEY_SIZE)
+		return -EINVAL;
+
+	for (i = 0; i < ARRAY_SIZE(key_ctx->key); ++i)
+		key_ctx->key[i] = get_unaligned_le32(key + i * sizeof(u32));
+
+	return 0;
+}
+
+static int crypto_chacha20_crypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct chacha20_key_ctx *key_ctx = crypto_skcipher_ctx(tfm);
+	struct chacha20_ctx ctx;
+	struct skcipher_walk walk;
+	simd_context_t simd_context;
+	int err, i;
+
+	err = skcipher_walk_virt(&walk, req, true);
+	if (unlikely(err))
+		return err;
+
+	memcpy(ctx.key, key_ctx->key, sizeof(ctx.key));
+	for (i = 0; i < ARRAY_SIZE(ctx.counter); ++i)
+		ctx.counter[i] = get_unaligned_le32(walk.iv + i * sizeof(u32));
+
+	simd_get(&simd_context);
+	while (walk.nbytes > 0) {
+		unsigned int nbytes = walk.nbytes;
+
+		if (nbytes < walk.total)
+			nbytes = round_down(nbytes, walk.stride);
+
+		chacha20(&ctx, walk.dst.virt.addr, walk.src.virt.addr, nbytes,
+			 &simd_context);
+
+		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
+		simd_relax(&simd_context);
+	}
+	simd_put(&simd_context);
+
+	return err;
+}
+
+static struct skcipher_alg alg = {
+	.base.cra_name		= "chacha20",
+	.base.cra_driver_name	= "chacha20-software",
+	.base.cra_priority	= 100,
+	.base.cra_blocksize	= 1,
+	.base.cra_ctxsize	= sizeof(struct chacha20_key_ctx),
+	.base.cra_module	= THIS_MODULE,
+
+	.min_keysize		= CHACHA20_KEY_SIZE,
+	.max_keysize		= CHACHA20_KEY_SIZE,
+	.ivsize			= CHACHA20_IV_SIZE,
+	.chunksize		= CHACHA20_BLOCK_SIZE,
+	.setkey			= crypto_chacha20_setkey,
+	.encrypt		= crypto_chacha20_crypt,
+	.decrypt		= crypto_chacha20_crypt,
+};
+
+static int __init chacha20_mod_init(void)
+{
+	return crypto_register_skcipher(&alg);
+}
+
+static void __exit chacha20_mod_exit(void)
+{
+	crypto_unregister_skcipher(&alg);
+}
+
+module_init(chacha20_mod_init);
+module_exit(chacha20_mod_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jason A. Donenfeld <Jason@zx2c4.com>");
+MODULE_DESCRIPTION("ChaCha20 stream cipher");
+MODULE_ALIAS_CRYPTO("chacha20");
+MODULE_ALIAS_CRYPTO("chacha20-software");
diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index bf523797bef3..b26adb9ed898 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -13,7 +13,7 @@
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
-#include <crypto/chacha20.h>
+#include <zinc/chacha20.h>
 #include <zinc/poly1305.h>
 #include <linux/err.h>
 #include <linux/init.h>
diff --git a/include/crypto/chacha20.h b/include/crypto/chacha20.h
index b83d66073db0..3b92f58f3891 100644
--- a/include/crypto/chacha20.h
+++ b/include/crypto/chacha20.h
@@ -6,23 +6,11 @@
 #ifndef _CRYPTO_CHACHA20_H
 #define _CRYPTO_CHACHA20_H
 
-#include <crypto/skcipher.h>
-#include <linux/types.h>
-#include <linux/crypto.h>
-
 #define CHACHA20_IV_SIZE	16
 #define CHACHA20_KEY_SIZE	32
 #define CHACHA20_BLOCK_SIZE	64
 #define CHACHA20_BLOCK_WORDS	(CHACHA20_BLOCK_SIZE / sizeof(u32))
 
-struct chacha20_ctx {
-	u32 key[8];
-};
-
 void chacha20_block(u32 *state, u32 *stream);
-void crypto_chacha20_init(u32 *state, struct chacha20_ctx *ctx, u8 *iv);
-int crypto_chacha20_setkey(struct crypto_skcipher *tfm, const u8 *key,
-			   unsigned int keysize);
-int crypto_chacha20_crypt(struct skcipher_request *req);
 
 #endif
-- 
2.19.0
