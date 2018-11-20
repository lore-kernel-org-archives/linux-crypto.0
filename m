Return-Path: <SRS0=vxh5=N7=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from sitav-80046.hsr.ch ([152.96.80.46]:39055 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727783AbeKUDBB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Nov 2018 22:01:01 -0500
From: Martin Willi <martin@strongswan.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, x86@kernel.org
Subject: [PATCH 1/3] crypto: x86/chacha20 - Add a 8-block AVX-512VL variant
Date: Tue, 20 Nov 2018 17:30:48 +0100
Message-Id: <20181120163050.22251-2-martin@strongswan.org>
In-Reply-To: <20181120163050.22251-1-martin@strongswan.org>
References: <20181120163050.22251-1-martin@strongswan.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This variant is similar to the AVX2 version, but benefits from the AVX-512
rotate instructions and the additional registers, so it can operate without
any data on the stack. It uses ymm registers only to avoid the massive core
throttling on Skylake-X platforms. Nontheless does it bring a ~30% speed
improvement compared to the AVX2 variant for random encryption lengths.

The AVX2 version uses "rep movsb" for partial block XORing via the stack.
With AVX-512, the new "vmovdqu8" can do this much more efficiently. The
associated "kmov" instructions to work with dynamic masks is not part of
the AVX-512VL instruction set, hence we depend on AVX-512BW as well. Given
that the major AVX-512VL architectures provide AVX-512BW and this extension
does not affect core clocking, this seems to be no problem at least for
now.

Signed-off-by: Martin Willi <martin@strongswan.org>
---
 arch/x86/crypto/Makefile                   |   5 +
 arch/x86/crypto/chacha20-avx512vl-x86_64.S | 396 +++++++++++++++++++++
 arch/x86/crypto/chacha20_glue.c            |  26 ++
 3 files changed, 427 insertions(+)
 create mode 100644 arch/x86/crypto/chacha20-avx512vl-x86_64.S

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index a4b0007a54e1..ce4e43642984 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -8,6 +8,7 @@ OBJECT_FILES_NON_STANDARD := y
 avx_supported := $(call as-instr,vpxor %xmm0$(comma)%xmm0$(comma)%xmm0,yes,no)
 avx2_supported := $(call as-instr,vpgatherdd %ymm0$(comma)(%eax$(comma)%ymm1\
 				$(comma)4)$(comma)%ymm2,yes,no)
+avx512_supported :=$(call as-instr,vpmovm2b %k1$(comma)%zmm5,yes,no)
 sha1_ni_supported :=$(call as-instr,sha1msg1 %xmm0$(comma)%xmm1,yes,no)
 sha256_ni_supported :=$(call as-instr,sha256msg1 %xmm0$(comma)%xmm1,yes,no)
 
@@ -103,6 +104,10 @@ ifeq ($(avx2_supported),yes)
 	morus1280-avx2-y := morus1280-avx2-asm.o morus1280-avx2-glue.o
 endif
 
+ifeq ($(avx512_supported),yes)
+	chacha20-x86_64-y += chacha20-avx512vl-x86_64.o
+endif
+
 aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o
 aesni-intel-$(CONFIG_64BIT) += aesni-intel_avx-x86_64.o aes_ctrby8_avx-x86_64.o
 ghash-clmulni-intel-y := ghash-clmulni-intel_asm.o ghash-clmulni-intel_glue.o
diff --git a/arch/x86/crypto/chacha20-avx512vl-x86_64.S b/arch/x86/crypto/chacha20-avx512vl-x86_64.S
new file mode 100644
index 000000000000..e1877afcaa73
--- /dev/null
+++ b/arch/x86/crypto/chacha20-avx512vl-x86_64.S
@@ -0,0 +1,396 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * ChaCha20 256-bit cipher algorithm, RFC7539, x64 AVX-512VL functions
+ *
+ * Copyright (C) 2018 Martin Willi
+ */
+
+#include <linux/linkage.h>
+
+.section	.rodata.cst32.CTR8BL, "aM", @progbits, 32
+.align 32
+CTR8BL:	.octa 0x00000003000000020000000100000000
+	.octa 0x00000007000000060000000500000004
+
+.text
+
+ENTRY(chacha20_8block_xor_avx512vl)
+	# %rdi: Input state matrix, s
+	# %rsi: up to 8 data blocks output, o
+	# %rdx: up to 8 data blocks input, i
+	# %rcx: input/output length in bytes
+
+	# This function encrypts eight consecutive ChaCha20 blocks by loading
+	# the state matrix in AVX registers eight times. Compared to AVX2, this
+	# mostly benefits from the new rotate instructions in VL and the
+	# additional registers.
+
+	vzeroupper
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
+
+	# x12 += counter values 0-3
+	vpaddd		CTR8BL(%rip),%ymm12,%ymm12
+
+	vmovdqa64	%ymm0,%ymm16
+	vmovdqa64	%ymm1,%ymm17
+	vmovdqa64	%ymm2,%ymm18
+	vmovdqa64	%ymm3,%ymm19
+	vmovdqa64	%ymm4,%ymm20
+	vmovdqa64	%ymm5,%ymm21
+	vmovdqa64	%ymm6,%ymm22
+	vmovdqa64	%ymm7,%ymm23
+	vmovdqa64	%ymm8,%ymm24
+	vmovdqa64	%ymm9,%ymm25
+	vmovdqa64	%ymm10,%ymm26
+	vmovdqa64	%ymm11,%ymm27
+	vmovdqa64	%ymm12,%ymm28
+	vmovdqa64	%ymm13,%ymm29
+	vmovdqa64	%ymm14,%ymm30
+	vmovdqa64	%ymm15,%ymm31
+
+	mov		$10,%eax
+
+.Ldoubleround8:
+	# x0 += x4, x12 = rotl32(x12 ^ x0, 16)
+	vpaddd		%ymm0,%ymm4,%ymm0
+	vpxord		%ymm0,%ymm12,%ymm12
+	vprold		$16,%ymm12,%ymm12
+	# x1 += x5, x13 = rotl32(x13 ^ x1, 16)
+	vpaddd		%ymm1,%ymm5,%ymm1
+	vpxord		%ymm1,%ymm13,%ymm13
+	vprold		$16,%ymm13,%ymm13
+	# x2 += x6, x14 = rotl32(x14 ^ x2, 16)
+	vpaddd		%ymm2,%ymm6,%ymm2
+	vpxord		%ymm2,%ymm14,%ymm14
+	vprold		$16,%ymm14,%ymm14
+	# x3 += x7, x15 = rotl32(x15 ^ x3, 16)
+	vpaddd		%ymm3,%ymm7,%ymm3
+	vpxord		%ymm3,%ymm15,%ymm15
+	vprold		$16,%ymm15,%ymm15
+
+	# x8 += x12, x4 = rotl32(x4 ^ x8, 12)
+	vpaddd		%ymm12,%ymm8,%ymm8
+	vpxord		%ymm8,%ymm4,%ymm4
+	vprold		$12,%ymm4,%ymm4
+	# x9 += x13, x5 = rotl32(x5 ^ x9, 12)
+	vpaddd		%ymm13,%ymm9,%ymm9
+	vpxord		%ymm9,%ymm5,%ymm5
+	vprold		$12,%ymm5,%ymm5
+	# x10 += x14, x6 = rotl32(x6 ^ x10, 12)
+	vpaddd		%ymm14,%ymm10,%ymm10
+	vpxord		%ymm10,%ymm6,%ymm6
+	vprold		$12,%ymm6,%ymm6
+	# x11 += x15, x7 = rotl32(x7 ^ x11, 12)
+	vpaddd		%ymm15,%ymm11,%ymm11
+	vpxord		%ymm11,%ymm7,%ymm7
+	vprold		$12,%ymm7,%ymm7
+
+	# x0 += x4, x12 = rotl32(x12 ^ x0, 8)
+	vpaddd		%ymm0,%ymm4,%ymm0
+	vpxord		%ymm0,%ymm12,%ymm12
+	vprold		$8,%ymm12,%ymm12
+	# x1 += x5, x13 = rotl32(x13 ^ x1, 8)
+	vpaddd		%ymm1,%ymm5,%ymm1
+	vpxord		%ymm1,%ymm13,%ymm13
+	vprold		$8,%ymm13,%ymm13
+	# x2 += x6, x14 = rotl32(x14 ^ x2, 8)
+	vpaddd		%ymm2,%ymm6,%ymm2
+	vpxord		%ymm2,%ymm14,%ymm14
+	vprold		$8,%ymm14,%ymm14
+	# x3 += x7, x15 = rotl32(x15 ^ x3, 8)
+	vpaddd		%ymm3,%ymm7,%ymm3
+	vpxord		%ymm3,%ymm15,%ymm15
+	vprold		$8,%ymm15,%ymm15
+
+	# x8 += x12, x4 = rotl32(x4 ^ x8, 7)
+	vpaddd		%ymm12,%ymm8,%ymm8
+	vpxord		%ymm8,%ymm4,%ymm4
+	vprold		$7,%ymm4,%ymm4
+	# x9 += x13, x5 = rotl32(x5 ^ x9, 7)
+	vpaddd		%ymm13,%ymm9,%ymm9
+	vpxord		%ymm9,%ymm5,%ymm5
+	vprold		$7,%ymm5,%ymm5
+	# x10 += x14, x6 = rotl32(x6 ^ x10, 7)
+	vpaddd		%ymm14,%ymm10,%ymm10
+	vpxord		%ymm10,%ymm6,%ymm6
+	vprold		$7,%ymm6,%ymm6
+	# x11 += x15, x7 = rotl32(x7 ^ x11, 7)
+	vpaddd		%ymm15,%ymm11,%ymm11
+	vpxord		%ymm11,%ymm7,%ymm7
+	vprold		$7,%ymm7,%ymm7
+
+	# x0 += x5, x15 = rotl32(x15 ^ x0, 16)
+	vpaddd		%ymm0,%ymm5,%ymm0
+	vpxord		%ymm0,%ymm15,%ymm15
+	vprold		$16,%ymm15,%ymm15
+	# x1 += x6, x12 = rotl32(x12 ^ x1, 16)
+	vpaddd		%ymm1,%ymm6,%ymm1
+	vpxord		%ymm1,%ymm12,%ymm12
+	vprold		$16,%ymm12,%ymm12
+	# x2 += x7, x13 = rotl32(x13 ^ x2, 16)
+	vpaddd		%ymm2,%ymm7,%ymm2
+	vpxord		%ymm2,%ymm13,%ymm13
+	vprold		$16,%ymm13,%ymm13
+	# x3 += x4, x14 = rotl32(x14 ^ x3, 16)
+	vpaddd		%ymm3,%ymm4,%ymm3
+	vpxord		%ymm3,%ymm14,%ymm14
+	vprold		$16,%ymm14,%ymm14
+
+	# x10 += x15, x5 = rotl32(x5 ^ x10, 12)
+	vpaddd		%ymm15,%ymm10,%ymm10
+	vpxord		%ymm10,%ymm5,%ymm5
+	vprold		$12,%ymm5,%ymm5
+	# x11 += x12, x6 = rotl32(x6 ^ x11, 12)
+	vpaddd		%ymm12,%ymm11,%ymm11
+	vpxord		%ymm11,%ymm6,%ymm6
+	vprold		$12,%ymm6,%ymm6
+	# x8 += x13, x7 = rotl32(x7 ^ x8, 12)
+	vpaddd		%ymm13,%ymm8,%ymm8
+	vpxord		%ymm8,%ymm7,%ymm7
+	vprold		$12,%ymm7,%ymm7
+	# x9 += x14, x4 = rotl32(x4 ^ x9, 12)
+	vpaddd		%ymm14,%ymm9,%ymm9
+	vpxord		%ymm9,%ymm4,%ymm4
+	vprold		$12,%ymm4,%ymm4
+
+	# x0 += x5, x15 = rotl32(x15 ^ x0, 8)
+	vpaddd		%ymm0,%ymm5,%ymm0
+	vpxord		%ymm0,%ymm15,%ymm15
+	vprold		$8,%ymm15,%ymm15
+	# x1 += x6, x12 = rotl32(x12 ^ x1, 8)
+	vpaddd		%ymm1,%ymm6,%ymm1
+	vpxord		%ymm1,%ymm12,%ymm12
+	vprold		$8,%ymm12,%ymm12
+	# x2 += x7, x13 = rotl32(x13 ^ x2, 8)
+	vpaddd		%ymm2,%ymm7,%ymm2
+	vpxord		%ymm2,%ymm13,%ymm13
+	vprold		$8,%ymm13,%ymm13
+	# x3 += x4, x14 = rotl32(x14 ^ x3, 8)
+	vpaddd		%ymm3,%ymm4,%ymm3
+	vpxord		%ymm3,%ymm14,%ymm14
+	vprold		$8,%ymm14,%ymm14
+
+	# x10 += x15, x5 = rotl32(x5 ^ x10, 7)
+	vpaddd		%ymm15,%ymm10,%ymm10
+	vpxord		%ymm10,%ymm5,%ymm5
+	vprold		$7,%ymm5,%ymm5
+	# x11 += x12, x6 = rotl32(x6 ^ x11, 7)
+	vpaddd		%ymm12,%ymm11,%ymm11
+	vpxord		%ymm11,%ymm6,%ymm6
+	vprold		$7,%ymm6,%ymm6
+	# x8 += x13, x7 = rotl32(x7 ^ x8, 7)
+	vpaddd		%ymm13,%ymm8,%ymm8
+	vpxord		%ymm8,%ymm7,%ymm7
+	vprold		$7,%ymm7,%ymm7
+	# x9 += x14, x4 = rotl32(x4 ^ x9, 7)
+	vpaddd		%ymm14,%ymm9,%ymm9
+	vpxord		%ymm9,%ymm4,%ymm4
+	vprold		$7,%ymm4,%ymm4
+
+	dec		%eax
+	jnz		.Ldoubleround8
+
+	# x0..15[0-3] += s[0..15]
+	vpaddd		%ymm16,%ymm0,%ymm0
+	vpaddd		%ymm17,%ymm1,%ymm1
+	vpaddd		%ymm18,%ymm2,%ymm2
+	vpaddd		%ymm19,%ymm3,%ymm3
+	vpaddd		%ymm20,%ymm4,%ymm4
+	vpaddd		%ymm21,%ymm5,%ymm5
+	vpaddd		%ymm22,%ymm6,%ymm6
+	vpaddd		%ymm23,%ymm7,%ymm7
+	vpaddd		%ymm24,%ymm8,%ymm8
+	vpaddd		%ymm25,%ymm9,%ymm9
+	vpaddd		%ymm26,%ymm10,%ymm10
+	vpaddd		%ymm27,%ymm11,%ymm11
+	vpaddd		%ymm28,%ymm12,%ymm12
+	vpaddd		%ymm29,%ymm13,%ymm13
+	vpaddd		%ymm30,%ymm14,%ymm14
+	vpaddd		%ymm31,%ymm15,%ymm15
+
+	# interleave 32-bit words in state n, n+1
+	vpunpckldq	%ymm1,%ymm0,%ymm16
+	vpunpckhdq	%ymm1,%ymm0,%ymm17
+	vpunpckldq	%ymm3,%ymm2,%ymm18
+	vpunpckhdq	%ymm3,%ymm2,%ymm19
+	vpunpckldq	%ymm5,%ymm4,%ymm20
+	vpunpckhdq	%ymm5,%ymm4,%ymm21
+	vpunpckldq	%ymm7,%ymm6,%ymm22
+	vpunpckhdq	%ymm7,%ymm6,%ymm23
+	vpunpckldq	%ymm9,%ymm8,%ymm24
+	vpunpckhdq	%ymm9,%ymm8,%ymm25
+	vpunpckldq	%ymm11,%ymm10,%ymm26
+	vpunpckhdq	%ymm11,%ymm10,%ymm27
+	vpunpckldq	%ymm13,%ymm12,%ymm28
+	vpunpckhdq	%ymm13,%ymm12,%ymm29
+	vpunpckldq	%ymm15,%ymm14,%ymm30
+	vpunpckhdq	%ymm15,%ymm14,%ymm31
+
+	# interleave 64-bit words in state n, n+2
+	vpunpcklqdq	%ymm18,%ymm16,%ymm0
+	vpunpcklqdq	%ymm19,%ymm17,%ymm1
+	vpunpckhqdq	%ymm18,%ymm16,%ymm2
+	vpunpckhqdq	%ymm19,%ymm17,%ymm3
+	vpunpcklqdq	%ymm22,%ymm20,%ymm4
+	vpunpcklqdq	%ymm23,%ymm21,%ymm5
+	vpunpckhqdq	%ymm22,%ymm20,%ymm6
+	vpunpckhqdq	%ymm23,%ymm21,%ymm7
+	vpunpcklqdq	%ymm26,%ymm24,%ymm8
+	vpunpcklqdq	%ymm27,%ymm25,%ymm9
+	vpunpckhqdq	%ymm26,%ymm24,%ymm10
+	vpunpckhqdq	%ymm27,%ymm25,%ymm11
+	vpunpcklqdq	%ymm30,%ymm28,%ymm12
+	vpunpcklqdq	%ymm31,%ymm29,%ymm13
+	vpunpckhqdq	%ymm30,%ymm28,%ymm14
+	vpunpckhqdq	%ymm31,%ymm29,%ymm15
+
+	# interleave 128-bit words in state n, n+4
+	# xor/write first four blocks
+	vmovdqa64	%ymm0,%ymm16
+	vperm2i128	$0x20,%ymm4,%ymm0,%ymm0
+	cmp		$0x0020,%rcx
+	jl		.Lxorpart8
+	vpxord		0x0000(%rdx),%ymm0,%ymm0
+	vmovdqu64	%ymm0,0x0000(%rsi)
+	vmovdqa64	%ymm16,%ymm0
+	vperm2i128	$0x31,%ymm4,%ymm0,%ymm4
+
+	vperm2i128	$0x20,%ymm12,%ymm8,%ymm0
+	cmp		$0x0040,%rcx
+	jl		.Lxorpart8
+	vpxord		0x0020(%rdx),%ymm0,%ymm0
+	vmovdqu64	%ymm0,0x0020(%rsi)
+	vperm2i128	$0x31,%ymm12,%ymm8,%ymm12
+
+	vperm2i128	$0x20,%ymm6,%ymm2,%ymm0
+	cmp		$0x0060,%rcx
+	jl		.Lxorpart8
+	vpxord		0x0040(%rdx),%ymm0,%ymm0
+	vmovdqu64	%ymm0,0x0040(%rsi)
+	vperm2i128	$0x31,%ymm6,%ymm2,%ymm6
+
+	vperm2i128	$0x20,%ymm14,%ymm10,%ymm0
+	cmp		$0x0080,%rcx
+	jl		.Lxorpart8
+	vpxord		0x0060(%rdx),%ymm0,%ymm0
+	vmovdqu64	%ymm0,0x0060(%rsi)
+	vperm2i128	$0x31,%ymm14,%ymm10,%ymm14
+
+	vperm2i128	$0x20,%ymm5,%ymm1,%ymm0
+	cmp		$0x00a0,%rcx
+	jl		.Lxorpart8
+	vpxord		0x0080(%rdx),%ymm0,%ymm0
+	vmovdqu64	%ymm0,0x0080(%rsi)
+	vperm2i128	$0x31,%ymm5,%ymm1,%ymm5
+
+	vperm2i128	$0x20,%ymm13,%ymm9,%ymm0
+	cmp		$0x00c0,%rcx
+	jl		.Lxorpart8
+	vpxord		0x00a0(%rdx),%ymm0,%ymm0
+	vmovdqu64	%ymm0,0x00a0(%rsi)
+	vperm2i128	$0x31,%ymm13,%ymm9,%ymm13
+
+	vperm2i128	$0x20,%ymm7,%ymm3,%ymm0
+	cmp		$0x00e0,%rcx
+	jl		.Lxorpart8
+	vpxord		0x00c0(%rdx),%ymm0,%ymm0
+	vmovdqu64	%ymm0,0x00c0(%rsi)
+	vperm2i128	$0x31,%ymm7,%ymm3,%ymm7
+
+	vperm2i128	$0x20,%ymm15,%ymm11,%ymm0
+	cmp		$0x0100,%rcx
+	jl		.Lxorpart8
+	vpxord		0x00e0(%rdx),%ymm0,%ymm0
+	vmovdqu64	%ymm0,0x00e0(%rsi)
+	vperm2i128	$0x31,%ymm15,%ymm11,%ymm15
+
+	# xor remaining blocks, write to output
+	vmovdqa64	%ymm4,%ymm0
+	cmp		$0x0120,%rcx
+	jl		.Lxorpart8
+	vpxord		0x0100(%rdx),%ymm0,%ymm0
+	vmovdqu64	%ymm0,0x0100(%rsi)
+
+	vmovdqa64	%ymm12,%ymm0
+	cmp		$0x0140,%rcx
+	jl		.Lxorpart8
+	vpxord		0x0120(%rdx),%ymm0,%ymm0
+	vmovdqu64	%ymm0,0x0120(%rsi)
+
+	vmovdqa64	%ymm6,%ymm0
+	cmp		$0x0160,%rcx
+	jl		.Lxorpart8
+	vpxord		0x0140(%rdx),%ymm0,%ymm0
+	vmovdqu64	%ymm0,0x0140(%rsi)
+
+	vmovdqa64	%ymm14,%ymm0
+	cmp		$0x0180,%rcx
+	jl		.Lxorpart8
+	vpxord		0x0160(%rdx),%ymm0,%ymm0
+	vmovdqu64	%ymm0,0x0160(%rsi)
+
+	vmovdqa64	%ymm5,%ymm0
+	cmp		$0x01a0,%rcx
+	jl		.Lxorpart8
+	vpxord		0x0180(%rdx),%ymm0,%ymm0
+	vmovdqu64	%ymm0,0x0180(%rsi)
+
+	vmovdqa64	%ymm13,%ymm0
+	cmp		$0x01c0,%rcx
+	jl		.Lxorpart8
+	vpxord		0x01a0(%rdx),%ymm0,%ymm0
+	vmovdqu64	%ymm0,0x01a0(%rsi)
+
+	vmovdqa64	%ymm7,%ymm0
+	cmp		$0x01e0,%rcx
+	jl		.Lxorpart8
+	vpxord		0x01c0(%rdx),%ymm0,%ymm0
+	vmovdqu64	%ymm0,0x01c0(%rsi)
+
+	vmovdqa64	%ymm15,%ymm0
+	cmp		$0x0200,%rcx
+	jl		.Lxorpart8
+	vpxord		0x01e0(%rdx),%ymm0,%ymm0
+	vmovdqu64	%ymm0,0x01e0(%rsi)
+
+.Ldone8:
+	vzeroupper
+	ret
+
+.Lxorpart8:
+	# xor remaining bytes from partial register into output
+	mov		%rcx,%rax
+	and		$0x1f,%rcx
+	jz		.Ldone8
+	mov		%rax,%r9
+	and		$~0x1f,%r9
+
+	mov		$1,%rax
+	shld		%cl,%rax,%rax
+	sub		$1,%rax
+	kmovq		%rax,%k1
+
+	vmovdqu8	(%rdx,%r9),%ymm1{%k1}{z}
+	vpxord		%ymm0,%ymm1,%ymm1
+	vmovdqu8	%ymm1,(%rsi,%r9){%k1}
+
+	jmp		.Ldone8
+
+ENDPROC(chacha20_8block_xor_avx512vl)
diff --git a/arch/x86/crypto/chacha20_glue.c b/arch/x86/crypto/chacha20_glue.c
index 1e9e66509226..6a67e70bc82a 100644
--- a/arch/x86/crypto/chacha20_glue.c
+++ b/arch/x86/crypto/chacha20_glue.c
@@ -31,6 +31,11 @@ asmlinkage void chacha20_4block_xor_avx2(u32 *state, u8 *dst, const u8 *src,
 asmlinkage void chacha20_8block_xor_avx2(u32 *state, u8 *dst, const u8 *src,
 					 unsigned int len);
 static bool chacha20_use_avx2;
+#ifdef CONFIG_AS_AVX512
+asmlinkage void chacha20_8block_xor_avx512vl(u32 *state, u8 *dst, const u8 *src,
+					     unsigned int len);
+static bool chacha20_use_avx512vl;
+#endif
 #endif
 
 static unsigned int chacha20_advance(unsigned int len, unsigned int maxblocks)
@@ -43,6 +48,22 @@ static void chacha20_dosimd(u32 *state, u8 *dst, const u8 *src,
 			    unsigned int bytes)
 {
 #ifdef CONFIG_AS_AVX2
+#ifdef CONFIG_AS_AVX512
+	if (chacha20_use_avx512vl) {
+		while (bytes >= CHACHA_BLOCK_SIZE * 8) {
+			chacha20_8block_xor_avx512vl(state, dst, src, bytes);
+			bytes -= CHACHA_BLOCK_SIZE * 8;
+			src += CHACHA_BLOCK_SIZE * 8;
+			dst += CHACHA_BLOCK_SIZE * 8;
+			state[12] += 8;
+		}
+		if (bytes > CHACHA_BLOCK_SIZE * 4) {
+			chacha20_8block_xor_avx512vl(state, dst, src, bytes);
+			state[12] += chacha20_advance(bytes, 8);
+			return;
+		}
+	}
+#endif
 	if (chacha20_use_avx2) {
 		while (bytes >= CHACHA_BLOCK_SIZE * 8) {
 			chacha20_8block_xor_avx2(state, dst, src, bytes);
@@ -149,6 +170,11 @@ static int __init chacha20_simd_mod_init(void)
 	chacha20_use_avx2 = boot_cpu_has(X86_FEATURE_AVX) &&
 			    boot_cpu_has(X86_FEATURE_AVX2) &&
 			    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL);
+#ifdef CONFIG_AS_AVX512
+	chacha20_use_avx512vl = chacha20_use_avx2 &&
+				boot_cpu_has(X86_FEATURE_AVX512VL) &&
+				boot_cpu_has(X86_FEATURE_AVX512BW); /* kmovq */
+#endif
 #endif
 	return crypto_register_skcipher(&alg);
 }
-- 
2.17.1
