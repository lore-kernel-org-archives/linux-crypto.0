From: Martin Willi <martin@strongswan.org>
Subject: [PATCH 05/10] crypto: chacha20 - Add an eight block AVX2 variant for x86_64
Date: Tue,  7 Jul 2015 21:36:51 +0200
Message-ID: <1436297816-16414-6-git-send-email-martin@strongswan.org>
References: <1436297816-16414-1-git-send-email-martin@strongswan.org>
Cc: x86@kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from revosec.ch ([5.148.177.19]:44654 "EHLO revosec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933253AbbGGThV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jul 2015 15:37:21 -0400
In-Reply-To: <1436297816-16414-1-git-send-email-martin@strongswan.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Extends the x86_64 ChaCha20 implementation by a function processing eight
ChaCha20 blocks in parallel using AVX2.

For large messages, throughput increases by ~55-70% compared to four block
SSSE3:

testing speed of chacha20 (chacha20-simd) encryption
test 0 (256 bit key, 16 byte blocks): 4164293 operations in 1 seconds (66628688 bytes)
test 1 (256 bit key, 64 byte blocks): 4545912 operations in 1 seconds (290938368 bytes)
test 2 (256 bit key, 256 byte blocks): 3238241 operations in 1 seconds (828989696 bytes)
test 3 (256 bit key, 1024 byte blocks): 1120664 operations in 1 seconds (1147559936 bytes)
test 4 (256 bit key, 8192 byte blocks): 140107 operations in 1 seconds (1147756544 bytes)

testing speed of chacha20 (chacha20-simd) encryption
test 0 (256 bit key, 16 byte blocks): 4166978 operations in 1 seconds (66671648 bytes)
test 1 (256 bit key, 64 byte blocks): 4557525 operations in 1 seconds (291681600 bytes)
test 2 (256 bit key, 256 byte blocks): 3231026 operations in 1 seconds (827142656 bytes)
test 3 (256 bit key, 1024 byte blocks): 1929946 operations in 1 seconds (1976264704 bytes)
test 4 (256 bit key, 8192 byte blocks): 218037 operations in 1 seconds (1786159104 bytes)

Benchmark results from a Core i5-4670T.

Signed-off-by: Martin Willi <martin@strongswan.org>
---
 arch/x86/crypto/Makefile               |   1 +
 arch/x86/crypto/chacha20-avx2-x86_64.S | 443 +++++++++++++++++++++++++++++++++
 arch/x86/crypto/chacha20_glue.c        |  19 ++
 crypto/Kconfig                         |   2 +-
 4 files changed, 464 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/crypto/chacha20-avx2-x86_64.S

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index b09e9a4..ce39b3c 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -77,6 +77,7 @@ endif
 
 ifeq ($(avx2_supported),yes)
 	camellia-aesni-avx2-y := camellia-aesni-avx2-asm_64.o camellia_aesni_avx2_glue.o
+	chacha20-x86_64-y += chacha20-avx2-x86_64.o
 	serpent-avx2-y := serpent-avx2-asm_64.o serpent_avx2_glue.o
 endif
 
diff --git a/arch/x86/crypto/chacha20-avx2-x86_64.S b/arch/x86/crypto/chacha20-avx2-x86_64.S
new file mode 100644
index 0000000..16694e6
--- /dev/null
+++ b/arch/x86/crypto/chacha20-avx2-x86_64.S
@@ -0,0 +1,443 @@
+/*
+ * ChaCha20 256-bit cipher algorithm, RFC7539, x64 AVX2 functions
+ *
+ * Copyright (C) 2015 Martin Willi
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/linkage.h>
+
+.data
+.align 32
+
+ROT8:	.octa 0x0e0d0c0f0a09080b0605040702010003
+	.octa 0x0e0d0c0f0a09080b0605040702010003
+ROT16:	.octa 0x0d0c0f0e09080b0a0504070601000302
+	.octa 0x0d0c0f0e09080b0a0504070601000302
+CTRINC:	.octa 0x00000003000000020000000100000000
+	.octa 0x00000007000000060000000500000004
+
+.text
+
+ENTRY(chacha20_8block_xor_avx2)
+	# %rdi: Input state matrix, s
+	# %rsi: 8 data blocks output, o
+	# %rdx: 8 data blocks input, i
+
+	# This function encrypts eight consecutive ChaCha20 blocks by loading
+	# the state matrix in AVX registers eight times. As we need some
+	# scratch registers, we save the first four registers on the stack. The
+	# algorithm performs each operation on the corresponding word of each
+	# state matrix, hence requires no word shuffling. For final XORing step
+	# we transpose the matrix by interleaving 32-, 64- and then 128-bit
+	# words, which allows us to do XOR in AVX registers. 8/16-bit word
+	# rotation is done with the slightly better performing byte shuffling,
+	# 7/12-bit word rotation uses traditional shift+OR.
+
+	vzeroupper
+	# 4 * 32 byte stack, 32-byte aligned
+	mov		%rsp, %r8
+	and		$~31, %rsp
+	sub		$0x80, %rsp
+
+	# x0..15[0-7] = s[0..15]
+	vpbroadcastd	0x00(%rdi),%ymm0
+	vpbroadcastd	0x04(%rdi),%ymm1
+	vpbroadcastd	0x08(%rdi),%ymm2
+	vpbroadcastd	0x0c(%rdi),%ymm3
+	vpbroadcastd	0x10(%rdi),%ymm4
+	vpbroadcastd	0x14(%rdi),%ymm5
+	vpbroadcastd	0x18(%rdi),%ymm6
+	vpbroadcastd	0x1c(%rdi),%ymm7
+	vpbroadcastd	0x20(%rdi),%ymm8
+	vpbroadcastd	0x24(%rdi),%ymm9
+	vpbroadcastd	0x28(%rdi),%ymm10
+	vpbroadcastd	0x2c(%rdi),%ymm11
+	vpbroadcastd	0x30(%rdi),%ymm12
+	vpbroadcastd	0x34(%rdi),%ymm13
+	vpbroadcastd	0x38(%rdi),%ymm14
+	vpbroadcastd	0x3c(%rdi),%ymm15
+	# x0..3 on stack
+	vmovdqa		%ymm0,0x00(%rsp)
+	vmovdqa		%ymm1,0x20(%rsp)
+	vmovdqa		%ymm2,0x40(%rsp)
+	vmovdqa		%ymm3,0x60(%rsp)
+
+	vmovdqa		CTRINC(%rip),%ymm1
+	vmovdqa		ROT8(%rip),%ymm2
+	vmovdqa		ROT16(%rip),%ymm3
+
+	# x12 += counter values 0-3
+	vpaddd		%ymm1,%ymm12,%ymm12
+
+	mov		$10,%ecx
+
+.Ldoubleround8:
+	# x0 += x4, x12 = rotl32(x12 ^ x0, 16)
+	vpaddd		0x00(%rsp),%ymm4,%ymm0
+	vmovdqa		%ymm0,0x00(%rsp)
+	vpxor		%ymm0,%ymm12,%ymm12
+	vpshufb		%ymm3,%ymm12,%ymm12
+	# x1 += x5, x13 = rotl32(x13 ^ x1, 16)
+	vpaddd		0x20(%rsp),%ymm5,%ymm0
+	vmovdqa		%ymm0,0x20(%rsp)
+	vpxor		%ymm0,%ymm13,%ymm13
+	vpshufb		%ymm3,%ymm13,%ymm13
+	# x2 += x6, x14 = rotl32(x14 ^ x2, 16)
+	vpaddd		0x40(%rsp),%ymm6,%ymm0
+	vmovdqa		%ymm0,0x40(%rsp)
+	vpxor		%ymm0,%ymm14,%ymm14
+	vpshufb		%ymm3,%ymm14,%ymm14
+	# x3 += x7, x15 = rotl32(x15 ^ x3, 16)
+	vpaddd		0x60(%rsp),%ymm7,%ymm0
+	vmovdqa		%ymm0,0x60(%rsp)
+	vpxor		%ymm0,%ymm15,%ymm15
+	vpshufb		%ymm3,%ymm15,%ymm15
+
+	# x8 += x12, x4 = rotl32(x4 ^ x8, 12)
+	vpaddd		%ymm12,%ymm8,%ymm8
+	vpxor		%ymm8,%ymm4,%ymm4
+	vpslld		$12,%ymm4,%ymm0
+	vpsrld		$20,%ymm4,%ymm4
+	vpor		%ymm0,%ymm4,%ymm4
+	# x9 += x13, x5 = rotl32(x5 ^ x9, 12)
+	vpaddd		%ymm13,%ymm9,%ymm9
+	vpxor		%ymm9,%ymm5,%ymm5
+	vpslld		$12,%ymm5,%ymm0
+	vpsrld		$20,%ymm5,%ymm5
+	vpor		%ymm0,%ymm5,%ymm5
+	# x10 += x14, x6 = rotl32(x6 ^ x10, 12)
+	vpaddd		%ymm14,%ymm10,%ymm10
+	vpxor		%ymm10,%ymm6,%ymm6
+	vpslld		$12,%ymm6,%ymm0
+	vpsrld		$20,%ymm6,%ymm6
+	vpor		%ymm0,%ymm6,%ymm6
+	# x11 += x15, x7 = rotl32(x7 ^ x11, 12)
+	vpaddd		%ymm15,%ymm11,%ymm11
+	vpxor		%ymm11,%ymm7,%ymm7
+	vpslld		$12,%ymm7,%ymm0
+	vpsrld		$20,%ymm7,%ymm7
+	vpor		%ymm0,%ymm7,%ymm7
+
+	# x0 += x4, x12 = rotl32(x12 ^ x0, 8)
+	vpaddd		0x00(%rsp),%ymm4,%ymm0
+	vmovdqa		%ymm0,0x00(%rsp)
+	vpxor		%ymm0,%ymm12,%ymm12
+	vpshufb		%ymm2,%ymm12,%ymm12
+	# x1 += x5, x13 = rotl32(x13 ^ x1, 8)
+	vpaddd		0x20(%rsp),%ymm5,%ymm0
+	vmovdqa		%ymm0,0x20(%rsp)
+	vpxor		%ymm0,%ymm13,%ymm13
+	vpshufb		%ymm2,%ymm13,%ymm13
+	# x2 += x6, x14 = rotl32(x14 ^ x2, 8)
+	vpaddd		0x40(%rsp),%ymm6,%ymm0
+	vmovdqa		%ymm0,0x40(%rsp)
+	vpxor		%ymm0,%ymm14,%ymm14
+	vpshufb		%ymm2,%ymm14,%ymm14
+	# x3 += x7, x15 = rotl32(x15 ^ x3, 8)
+	vpaddd		0x60(%rsp),%ymm7,%ymm0
+	vmovdqa		%ymm0,0x60(%rsp)
+	vpxor		%ymm0,%ymm15,%ymm15
+	vpshufb		%ymm2,%ymm15,%ymm15
+
+	# x8 += x12, x4 = rotl32(x4 ^ x8, 7)
+	vpaddd		%ymm12,%ymm8,%ymm8
+	vpxor		%ymm8,%ymm4,%ymm4
+	vpslld		$7,%ymm4,%ymm0
+	vpsrld		$25,%ymm4,%ymm4
+	vpor		%ymm0,%ymm4,%ymm4
+	# x9 += x13, x5 = rotl32(x5 ^ x9, 7)
+	vpaddd		%ymm13,%ymm9,%ymm9
+	vpxor		%ymm9,%ymm5,%ymm5
+	vpslld		$7,%ymm5,%ymm0
+	vpsrld		$25,%ymm5,%ymm5
+	vpor		%ymm0,%ymm5,%ymm5
+	# x10 += x14, x6 = rotl32(x6 ^ x10, 7)
+	vpaddd		%ymm14,%ymm10,%ymm10
+	vpxor		%ymm10,%ymm6,%ymm6
+	vpslld		$7,%ymm6,%ymm0
+	vpsrld		$25,%ymm6,%ymm6
+	vpor		%ymm0,%ymm6,%ymm6
+	# x11 += x15, x7 = rotl32(x7 ^ x11, 7)
+	vpaddd		%ymm15,%ymm11,%ymm11
+	vpxor		%ymm11,%ymm7,%ymm7
+	vpslld		$7,%ymm7,%ymm0
+	vpsrld		$25,%ymm7,%ymm7
+	vpor		%ymm0,%ymm7,%ymm7
+
+	# x0 += x5, x15 = rotl32(x15 ^ x0, 16)
+	vpaddd		0x00(%rsp),%ymm5,%ymm0
+	vmovdqa		%ymm0,0x00(%rsp)
+	vpxor		%ymm0,%ymm15,%ymm15
+	vpshufb		%ymm3,%ymm15,%ymm15
+	# x1 += x6, x12 = rotl32(x12 ^ x1, 16)%ymm0
+	vpaddd		0x20(%rsp),%ymm6,%ymm0
+	vmovdqa		%ymm0,0x20(%rsp)
+	vpxor		%ymm0,%ymm12,%ymm12
+	vpshufb		%ymm3,%ymm12,%ymm12
+	# x2 += x7, x13 = rotl32(x13 ^ x2, 16)
+	vpaddd		0x40(%rsp),%ymm7,%ymm0
+	vmovdqa		%ymm0,0x40(%rsp)
+	vpxor		%ymm0,%ymm13,%ymm13
+	vpshufb		%ymm3,%ymm13,%ymm13
+	# x3 += x4, x14 = rotl32(x14 ^ x3, 16)
+	vpaddd		0x60(%rsp),%ymm4,%ymm0
+	vmovdqa		%ymm0,0x60(%rsp)
+	vpxor		%ymm0,%ymm14,%ymm14
+	vpshufb		%ymm3,%ymm14,%ymm14
+
+	# x10 += x15, x5 = rotl32(x5 ^ x10, 12)
+	vpaddd		%ymm15,%ymm10,%ymm10
+	vpxor		%ymm10,%ymm5,%ymm5
+	vpslld		$12,%ymm5,%ymm0
+	vpsrld		$20,%ymm5,%ymm5
+	vpor		%ymm0,%ymm5,%ymm5
+	# x11 += x12, x6 = rotl32(x6 ^ x11, 12)
+	vpaddd		%ymm12,%ymm11,%ymm11
+	vpxor		%ymm11,%ymm6,%ymm6
+	vpslld		$12,%ymm6,%ymm0
+	vpsrld		$20,%ymm6,%ymm6
+	vpor		%ymm0,%ymm6,%ymm6
+	# x8 += x13, x7 = rotl32(x7 ^ x8, 12)
+	vpaddd		%ymm13,%ymm8,%ymm8
+	vpxor		%ymm8,%ymm7,%ymm7
+	vpslld		$12,%ymm7,%ymm0
+	vpsrld		$20,%ymm7,%ymm7
+	vpor		%ymm0,%ymm7,%ymm7
+	# x9 += x14, x4 = rotl32(x4 ^ x9, 12)
+	vpaddd		%ymm14,%ymm9,%ymm9
+	vpxor		%ymm9,%ymm4,%ymm4
+	vpslld		$12,%ymm4,%ymm0
+	vpsrld		$20,%ymm4,%ymm4
+	vpor		%ymm0,%ymm4,%ymm4
+
+	# x0 += x5, x15 = rotl32(x15 ^ x0, 8)
+	vpaddd		0x00(%rsp),%ymm5,%ymm0
+	vmovdqa		%ymm0,0x00(%rsp)
+	vpxor		%ymm0,%ymm15,%ymm15
+	vpshufb		%ymm2,%ymm15,%ymm15
+	# x1 += x6, x12 = rotl32(x12 ^ x1, 8)
+	vpaddd		0x20(%rsp),%ymm6,%ymm0
+	vmovdqa		%ymm0,0x20(%rsp)
+	vpxor		%ymm0,%ymm12,%ymm12
+	vpshufb		%ymm2,%ymm12,%ymm12
+	# x2 += x7, x13 = rotl32(x13 ^ x2, 8)
+	vpaddd		0x40(%rsp),%ymm7,%ymm0
+	vmovdqa		%ymm0,0x40(%rsp)
+	vpxor		%ymm0,%ymm13,%ymm13
+	vpshufb		%ymm2,%ymm13,%ymm13
+	# x3 += x4, x14 = rotl32(x14 ^ x3, 8)
+	vpaddd		0x60(%rsp),%ymm4,%ymm0
+	vmovdqa		%ymm0,0x60(%rsp)
+	vpxor		%ymm0,%ymm14,%ymm14
+	vpshufb		%ymm2,%ymm14,%ymm14
+
+	# x10 += x15, x5 = rotl32(x5 ^ x10, 7)
+	vpaddd		%ymm15,%ymm10,%ymm10
+	vpxor		%ymm10,%ymm5,%ymm5
+	vpslld		$7,%ymm5,%ymm0
+	vpsrld		$25,%ymm5,%ymm5
+	vpor		%ymm0,%ymm5,%ymm5
+	# x11 += x12, x6 = rotl32(x6 ^ x11, 7)
+	vpaddd		%ymm12,%ymm11,%ymm11
+	vpxor		%ymm11,%ymm6,%ymm6
+	vpslld		$7,%ymm6,%ymm0
+	vpsrld		$25,%ymm6,%ymm6
+	vpor		%ymm0,%ymm6,%ymm6
+	# x8 += x13, x7 = rotl32(x7 ^ x8, 7)
+	vpaddd		%ymm13,%ymm8,%ymm8
+	vpxor		%ymm8,%ymm7,%ymm7
+	vpslld		$7,%ymm7,%ymm0
+	vpsrld		$25,%ymm7,%ymm7
+	vpor		%ymm0,%ymm7,%ymm7
+	# x9 += x14, x4 = rotl32(x4 ^ x9, 7)
+	vpaddd		%ymm14,%ymm9,%ymm9
+	vpxor		%ymm9,%ymm4,%ymm4
+	vpslld		$7,%ymm4,%ymm0
+	vpsrld		$25,%ymm4,%ymm4
+	vpor		%ymm0,%ymm4,%ymm4
+
+	dec		%ecx
+	jnz		.Ldoubleround8
+
+	# x0..15[0-3] += s[0..15]
+	vpbroadcastd	0x00(%rdi),%ymm0
+	vpaddd		0x00(%rsp),%ymm0,%ymm0
+	vmovdqa		%ymm0,0x00(%rsp)
+	vpbroadcastd	0x04(%rdi),%ymm0
+	vpaddd		0x20(%rsp),%ymm0,%ymm0
+	vmovdqa		%ymm0,0x20(%rsp)
+	vpbroadcastd	0x08(%rdi),%ymm0
+	vpaddd		0x40(%rsp),%ymm0,%ymm0
+	vmovdqa		%ymm0,0x40(%rsp)
+	vpbroadcastd	0x0c(%rdi),%ymm0
+	vpaddd		0x60(%rsp),%ymm0,%ymm0
+	vmovdqa		%ymm0,0x60(%rsp)
+	vpbroadcastd	0x10(%rdi),%ymm0
+	vpaddd		%ymm0,%ymm4,%ymm4
+	vpbroadcastd	0x14(%rdi),%ymm0
+	vpaddd		%ymm0,%ymm5,%ymm5
+	vpbroadcastd	0x18(%rdi),%ymm0
+	vpaddd		%ymm0,%ymm6,%ymm6
+	vpbroadcastd	0x1c(%rdi),%ymm0
+	vpaddd		%ymm0,%ymm7,%ymm7
+	vpbroadcastd	0x20(%rdi),%ymm0
+	vpaddd		%ymm0,%ymm8,%ymm8
+	vpbroadcastd	0x24(%rdi),%ymm0
+	vpaddd		%ymm0,%ymm9,%ymm9
+	vpbroadcastd	0x28(%rdi),%ymm0
+	vpaddd		%ymm0,%ymm10,%ymm10
+	vpbroadcastd	0x2c(%rdi),%ymm0
+	vpaddd		%ymm0,%ymm11,%ymm11
+	vpbroadcastd	0x30(%rdi),%ymm0
+	vpaddd		%ymm0,%ymm12,%ymm12
+	vpbroadcastd	0x34(%rdi),%ymm0
+	vpaddd		%ymm0,%ymm13,%ymm13
+	vpbroadcastd	0x38(%rdi),%ymm0
+	vpaddd		%ymm0,%ymm14,%ymm14
+	vpbroadcastd	0x3c(%rdi),%ymm0
+	vpaddd		%ymm0,%ymm15,%ymm15
+
+	# x12 += counter values 0-3
+	vpaddd		%ymm1,%ymm12,%ymm12
+
+	# interleave 32-bit words in state n, n+1
+	vmovdqa		0x00(%rsp),%ymm0
+	vmovdqa		0x20(%rsp),%ymm1
+	vpunpckldq	%ymm1,%ymm0,%ymm2
+	vpunpckhdq	%ymm1,%ymm0,%ymm1
+	vmovdqa		%ymm2,0x00(%rsp)
+	vmovdqa		%ymm1,0x20(%rsp)
+	vmovdqa		0x40(%rsp),%ymm0
+	vmovdqa		0x60(%rsp),%ymm1
+	vpunpckldq	%ymm1,%ymm0,%ymm2
+	vpunpckhdq	%ymm1,%ymm0,%ymm1
+	vmovdqa		%ymm2,0x40(%rsp)
+	vmovdqa		%ymm1,0x60(%rsp)
+	vmovdqa		%ymm4,%ymm0
+	vpunpckldq	%ymm5,%ymm0,%ymm4
+	vpunpckhdq	%ymm5,%ymm0,%ymm5
+	vmovdqa		%ymm6,%ymm0
+	vpunpckldq	%ymm7,%ymm0,%ymm6
+	vpunpckhdq	%ymm7,%ymm0,%ymm7
+	vmovdqa		%ymm8,%ymm0
+	vpunpckldq	%ymm9,%ymm0,%ymm8
+	vpunpckhdq	%ymm9,%ymm0,%ymm9
+	vmovdqa		%ymm10,%ymm0
+	vpunpckldq	%ymm11,%ymm0,%ymm10
+	vpunpckhdq	%ymm11,%ymm0,%ymm11
+	vmovdqa		%ymm12,%ymm0
+	vpunpckldq	%ymm13,%ymm0,%ymm12
+	vpunpckhdq	%ymm13,%ymm0,%ymm13
+	vmovdqa		%ymm14,%ymm0
+	vpunpckldq	%ymm15,%ymm0,%ymm14
+	vpunpckhdq	%ymm15,%ymm0,%ymm15
+
+	# interleave 64-bit words in state n, n+2
+	vmovdqa		0x00(%rsp),%ymm0
+	vmovdqa		0x40(%rsp),%ymm2
+	vpunpcklqdq	%ymm2,%ymm0,%ymm1
+	vpunpckhqdq	%ymm2,%ymm0,%ymm2
+	vmovdqa		%ymm1,0x00(%rsp)
+	vmovdqa		%ymm2,0x40(%rsp)
+	vmovdqa		0x20(%rsp),%ymm0
+	vmovdqa		0x60(%rsp),%ymm2
+	vpunpcklqdq	%ymm2,%ymm0,%ymm1
+	vpunpckhqdq	%ymm2,%ymm0,%ymm2
+	vmovdqa		%ymm1,0x20(%rsp)
+	vmovdqa		%ymm2,0x60(%rsp)
+	vmovdqa		%ymm4,%ymm0
+	vpunpcklqdq	%ymm6,%ymm0,%ymm4
+	vpunpckhqdq	%ymm6,%ymm0,%ymm6
+	vmovdqa		%ymm5,%ymm0
+	vpunpcklqdq	%ymm7,%ymm0,%ymm5
+	vpunpckhqdq	%ymm7,%ymm0,%ymm7
+	vmovdqa		%ymm8,%ymm0
+	vpunpcklqdq	%ymm10,%ymm0,%ymm8
+	vpunpckhqdq	%ymm10,%ymm0,%ymm10
+	vmovdqa		%ymm9,%ymm0
+	vpunpcklqdq	%ymm11,%ymm0,%ymm9
+	vpunpckhqdq	%ymm11,%ymm0,%ymm11
+	vmovdqa		%ymm12,%ymm0
+	vpunpcklqdq	%ymm14,%ymm0,%ymm12
+	vpunpckhqdq	%ymm14,%ymm0,%ymm14
+	vmovdqa		%ymm13,%ymm0
+	vpunpcklqdq	%ymm15,%ymm0,%ymm13
+	vpunpckhqdq	%ymm15,%ymm0,%ymm15
+
+	# interleave 128-bit words in state n, n+4
+	vmovdqa		0x00(%rsp),%ymm0
+	vperm2i128	$0x20,%ymm4,%ymm0,%ymm1
+	vperm2i128	$0x31,%ymm4,%ymm0,%ymm4
+	vmovdqa		%ymm1,0x00(%rsp)
+	vmovdqa		0x20(%rsp),%ymm0
+	vperm2i128	$0x20,%ymm5,%ymm0,%ymm1
+	vperm2i128	$0x31,%ymm5,%ymm0,%ymm5
+	vmovdqa		%ymm1,0x20(%rsp)
+	vmovdqa		0x40(%rsp),%ymm0
+	vperm2i128	$0x20,%ymm6,%ymm0,%ymm1
+	vperm2i128	$0x31,%ymm6,%ymm0,%ymm6
+	vmovdqa		%ymm1,0x40(%rsp)
+	vmovdqa		0x60(%rsp),%ymm0
+	vperm2i128	$0x20,%ymm7,%ymm0,%ymm1
+	vperm2i128	$0x31,%ymm7,%ymm0,%ymm7
+	vmovdqa		%ymm1,0x60(%rsp)
+	vperm2i128	$0x20,%ymm12,%ymm8,%ymm0
+	vperm2i128	$0x31,%ymm12,%ymm8,%ymm12
+	vmovdqa		%ymm0,%ymm8
+	vperm2i128	$0x20,%ymm13,%ymm9,%ymm0
+	vperm2i128	$0x31,%ymm13,%ymm9,%ymm13
+	vmovdqa		%ymm0,%ymm9
+	vperm2i128	$0x20,%ymm14,%ymm10,%ymm0
+	vperm2i128	$0x31,%ymm14,%ymm10,%ymm14
+	vmovdqa		%ymm0,%ymm10
+	vperm2i128	$0x20,%ymm15,%ymm11,%ymm0
+	vperm2i128	$0x31,%ymm15,%ymm11,%ymm15
+	vmovdqa		%ymm0,%ymm11
+
+	# xor with corresponding input, write to output
+	vmovdqa		0x00(%rsp),%ymm0
+	vpxor		0x0000(%rdx),%ymm0,%ymm0
+	vmovdqu		%ymm0,0x0000(%rsi)
+	vmovdqa		0x20(%rsp),%ymm0
+	vpxor		0x0080(%rdx),%ymm0,%ymm0
+	vmovdqu		%ymm0,0x0080(%rsi)
+	vmovdqa		0x40(%rsp),%ymm0
+	vpxor		0x0040(%rdx),%ymm0,%ymm0
+	vmovdqu		%ymm0,0x0040(%rsi)
+	vmovdqa		0x60(%rsp),%ymm0
+	vpxor		0x00c0(%rdx),%ymm0,%ymm0
+	vmovdqu		%ymm0,0x00c0(%rsi)
+	vpxor		0x0100(%rdx),%ymm4,%ymm4
+	vmovdqu		%ymm4,0x0100(%rsi)
+	vpxor		0x0180(%rdx),%ymm5,%ymm5
+	vmovdqu		%ymm5,0x00180(%rsi)
+	vpxor		0x0140(%rdx),%ymm6,%ymm6
+	vmovdqu		%ymm6,0x0140(%rsi)
+	vpxor		0x01c0(%rdx),%ymm7,%ymm7
+	vmovdqu		%ymm7,0x01c0(%rsi)
+	vpxor		0x0020(%rdx),%ymm8,%ymm8
+	vmovdqu		%ymm8,0x0020(%rsi)
+	vpxor		0x00a0(%rdx),%ymm9,%ymm9
+	vmovdqu		%ymm9,0x00a0(%rsi)
+	vpxor		0x0060(%rdx),%ymm10,%ymm10
+	vmovdqu		%ymm10,0x0060(%rsi)
+	vpxor		0x00e0(%rdx),%ymm11,%ymm11
+	vmovdqu		%ymm11,0x00e0(%rsi)
+	vpxor		0x0120(%rdx),%ymm12,%ymm12
+	vmovdqu		%ymm12,0x0120(%rsi)
+	vpxor		0x01a0(%rdx),%ymm13,%ymm13
+	vmovdqu		%ymm13,0x01a0(%rsi)
+	vpxor		0x0160(%rdx),%ymm14,%ymm14
+	vmovdqu		%ymm14,0x0160(%rsi)
+	vpxor		0x01e0(%rdx),%ymm15,%ymm15
+	vmovdqu		%ymm15,0x01e0(%rsi)
+
+	vzeroupper
+	mov		%r8,%rsp
+	ret
+ENDPROC(chacha20_8block_xor_avx2)
diff --git a/arch/x86/crypto/chacha20_glue.c b/arch/x86/crypto/chacha20_glue.c
index 4d677c3..effe216 100644
--- a/arch/x86/crypto/chacha20_glue.c
+++ b/arch/x86/crypto/chacha20_glue.c
@@ -21,12 +21,27 @@
 
 asmlinkage void chacha20_block_xor_ssse3(u32 *state, u8 *dst, const u8 *src);
 asmlinkage void chacha20_4block_xor_ssse3(u32 *state, u8 *dst, const u8 *src);
+#ifdef CONFIG_AS_AVX2
+asmlinkage void chacha20_8block_xor_avx2(u32 *state, u8 *dst, const u8 *src);
+static bool chacha20_use_avx2;
+#endif
 
 static void chacha20_dosimd(u32 *state, u8 *dst, const u8 *src,
 			    unsigned int bytes)
 {
 	u8 buf[CHACHA20_BLOCK_SIZE];
 
+#ifdef CONFIG_AS_AVX2
+	if (chacha20_use_avx2) {
+		while (bytes >= CHACHA20_BLOCK_SIZE * 8) {
+			chacha20_8block_xor_avx2(state, dst, src);
+			bytes -= CHACHA20_BLOCK_SIZE * 8;
+			src += CHACHA20_BLOCK_SIZE * 8;
+			dst += CHACHA20_BLOCK_SIZE * 8;
+			state[12] += 8;
+		}
+	}
+#endif
 	while (bytes >= CHACHA20_BLOCK_SIZE * 4) {
 		chacha20_4block_xor_ssse3(state, dst, src);
 		bytes -= CHACHA20_BLOCK_SIZE * 4;
@@ -113,6 +128,10 @@ static int __init chacha20_simd_mod_init(void)
 	if (!cpu_has_ssse3)
 		return -ENODEV;
 
+#ifdef CONFIG_AS_AVX2
+	chacha20_use_avx2 = cpu_has_avx && cpu_has_avx2 &&
+			    cpu_has_xfeatures(XSTATE_SSE | XSTATE_YMM, NULL);
+#endif
 	return crypto_register_alg(&alg);
 }
 
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 8f24185..82caab0 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1214,7 +1214,7 @@ config CRYPTO_CHACHA20
 	  <http://cr.yp.to/chacha/chacha-20080128.pdf>
 
 config CRYPTO_CHACHA20_X86_64
-	tristate "ChaCha20 cipher algorithm (x86_64/SSSE3)"
+	tristate "ChaCha20 cipher algorithm (x86_64/SSSE3/AVX2)"
 	depends on X86 && 64BIT
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_CHACHA20
-- 
1.9.1
