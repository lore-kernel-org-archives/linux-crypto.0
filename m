Return-Path: <SRS0=vxh5=N7=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from sitav-80046.hsr.ch ([152.96.80.46]:39059 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729050AbeKUDBA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Nov 2018 22:01:00 -0500
From: Martin Willi <martin@strongswan.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, x86@kernel.org
Subject: [PATCH 2/3] crypto: x86/chacha20 - Add a 2-block AVX-512VL variant
Date: Tue, 20 Nov 2018 17:30:49 +0100
Message-Id: <20181120163050.22251-3-martin@strongswan.org>
In-Reply-To: <20181120163050.22251-1-martin@strongswan.org>
References: <20181120163050.22251-1-martin@strongswan.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This version uses the same principle as the AVX2 version. It benefits
from the AVX-512VL rotate instructions and the more efficient partial
block handling using "vmovdqu8", resulting in a speedup of ~20%.

Unlike the AVX2 version, it is faster than the single block SSSE3 version
to process a single block. Hence we engage that function for (partial)
single block lengths as well.

Signed-off-by: Martin Willi <martin@strongswan.org>
---
 arch/x86/crypto/chacha20-avx512vl-x86_64.S | 171 +++++++++++++++++++++
 arch/x86/crypto/chacha20_glue.c            |   7 +
 2 files changed, 178 insertions(+)

diff --git a/arch/x86/crypto/chacha20-avx512vl-x86_64.S b/arch/x86/crypto/chacha20-avx512vl-x86_64.S
index e1877afcaa73..261097578715 100644
--- a/arch/x86/crypto/chacha20-avx512vl-x86_64.S
+++ b/arch/x86/crypto/chacha20-avx512vl-x86_64.S
@@ -7,6 +7,11 @@
 
 #include <linux/linkage.h>
 
+.section	.rodata.cst32.CTR2BL, "aM", @progbits, 32
+.align 32
+CTR2BL:	.octa 0x00000000000000000000000000000000
+	.octa 0x00000000000000000000000000000001
+
 .section	.rodata.cst32.CTR8BL, "aM", @progbits, 32
 .align 32
 CTR8BL:	.octa 0x00000003000000020000000100000000
@@ -14,6 +19,172 @@ CTR8BL:	.octa 0x00000003000000020000000100000000
 
 .text
 
+ENTRY(chacha20_2block_xor_avx512vl)
+	# %rdi: Input state matrix, s
+	# %rsi: up to 2 data blocks output, o
+	# %rdx: up to 2 data blocks input, i
+	# %rcx: input/output length in bytes
+
+	# This function encrypts two ChaCha20 blocks by loading the state
+	# matrix twice across four AVX registers. It performs matrix operations
+	# on four words in each matrix in parallel, but requires shuffling to
+	# rearrange the words after each round.
+
+	vzeroupper
+
+	# x0..3[0-2] = s0..3
+	vbroadcasti128	0x00(%rdi),%ymm0
+	vbroadcasti128	0x10(%rdi),%ymm1
+	vbroadcasti128	0x20(%rdi),%ymm2
+	vbroadcasti128	0x30(%rdi),%ymm3
+
+	vpaddd		CTR2BL(%rip),%ymm3,%ymm3
+
+	vmovdqa		%ymm0,%ymm8
+	vmovdqa		%ymm1,%ymm9
+	vmovdqa		%ymm2,%ymm10
+	vmovdqa		%ymm3,%ymm11
+
+	mov		$10,%rax
+
+.Ldoubleround:
+
+	# x0 += x1, x3 = rotl32(x3 ^ x0, 16)
+	vpaddd		%ymm1,%ymm0,%ymm0
+	vpxord		%ymm0,%ymm3,%ymm3
+	vprold		$16,%ymm3,%ymm3
+
+	# x2 += x3, x1 = rotl32(x1 ^ x2, 12)
+	vpaddd		%ymm3,%ymm2,%ymm2
+	vpxord		%ymm2,%ymm1,%ymm1
+	vprold		$12,%ymm1,%ymm1
+
+	# x0 += x1, x3 = rotl32(x3 ^ x0, 8)
+	vpaddd		%ymm1,%ymm0,%ymm0
+	vpxord		%ymm0,%ymm3,%ymm3
+	vprold		$8,%ymm3,%ymm3
+
+	# x2 += x3, x1 = rotl32(x1 ^ x2, 7)
+	vpaddd		%ymm3,%ymm2,%ymm2
+	vpxord		%ymm2,%ymm1,%ymm1
+	vprold		$7,%ymm1,%ymm1
+
+	# x1 = shuffle32(x1, MASK(0, 3, 2, 1))
+	vpshufd		$0x39,%ymm1,%ymm1
+	# x2 = shuffle32(x2, MASK(1, 0, 3, 2))
+	vpshufd		$0x4e,%ymm2,%ymm2
+	# x3 = shuffle32(x3, MASK(2, 1, 0, 3))
+	vpshufd		$0x93,%ymm3,%ymm3
+
+	# x0 += x1, x3 = rotl32(x3 ^ x0, 16)
+	vpaddd		%ymm1,%ymm0,%ymm0
+	vpxord		%ymm0,%ymm3,%ymm3
+	vprold		$16,%ymm3,%ymm3
+
+	# x2 += x3, x1 = rotl32(x1 ^ x2, 12)
+	vpaddd		%ymm3,%ymm2,%ymm2
+	vpxord		%ymm2,%ymm1,%ymm1
+	vprold		$12,%ymm1,%ymm1
+
+	# x0 += x1, x3 = rotl32(x3 ^ x0, 8)
+	vpaddd		%ymm1,%ymm0,%ymm0
+	vpxord		%ymm0,%ymm3,%ymm3
+	vprold		$8,%ymm3,%ymm3
+
+	# x2 += x3, x1 = rotl32(x1 ^ x2, 7)
+	vpaddd		%ymm3,%ymm2,%ymm2
+	vpxord		%ymm2,%ymm1,%ymm1
+	vprold		$7,%ymm1,%ymm1
+
+	# x1 = shuffle32(x1, MASK(2, 1, 0, 3))
+	vpshufd		$0x93,%ymm1,%ymm1
+	# x2 = shuffle32(x2, MASK(1, 0, 3, 2))
+	vpshufd		$0x4e,%ymm2,%ymm2
+	# x3 = shuffle32(x3, MASK(0, 3, 2, 1))
+	vpshufd		$0x39,%ymm3,%ymm3
+
+	dec		%rax
+	jnz		.Ldoubleround
+
+	# o0 = i0 ^ (x0 + s0)
+	vpaddd		%ymm8,%ymm0,%ymm7
+	cmp		$0x10,%rcx
+	jl		.Lxorpart2
+	vpxord		0x00(%rdx),%xmm7,%xmm6
+	vmovdqu		%xmm6,0x00(%rsi)
+	vextracti128	$1,%ymm7,%xmm0
+	# o1 = i1 ^ (x1 + s1)
+	vpaddd		%ymm9,%ymm1,%ymm7
+	cmp		$0x20,%rcx
+	jl		.Lxorpart2
+	vpxord		0x10(%rdx),%xmm7,%xmm6
+	vmovdqu		%xmm6,0x10(%rsi)
+	vextracti128	$1,%ymm7,%xmm1
+	# o2 = i2 ^ (x2 + s2)
+	vpaddd		%ymm10,%ymm2,%ymm7
+	cmp		$0x30,%rcx
+	jl		.Lxorpart2
+	vpxord		0x20(%rdx),%xmm7,%xmm6
+	vmovdqu		%xmm6,0x20(%rsi)
+	vextracti128	$1,%ymm7,%xmm2
+	# o3 = i3 ^ (x3 + s3)
+	vpaddd		%ymm11,%ymm3,%ymm7
+	cmp		$0x40,%rcx
+	jl		.Lxorpart2
+	vpxord		0x30(%rdx),%xmm7,%xmm6
+	vmovdqu		%xmm6,0x30(%rsi)
+	vextracti128	$1,%ymm7,%xmm3
+
+	# xor and write second block
+	vmovdqa		%xmm0,%xmm7
+	cmp		$0x50,%rcx
+	jl		.Lxorpart2
+	vpxord		0x40(%rdx),%xmm7,%xmm6
+	vmovdqu		%xmm6,0x40(%rsi)
+
+	vmovdqa		%xmm1,%xmm7
+	cmp		$0x60,%rcx
+	jl		.Lxorpart2
+	vpxord		0x50(%rdx),%xmm7,%xmm6
+	vmovdqu		%xmm6,0x50(%rsi)
+
+	vmovdqa		%xmm2,%xmm7
+	cmp		$0x70,%rcx
+	jl		.Lxorpart2
+	vpxord		0x60(%rdx),%xmm7,%xmm6
+	vmovdqu		%xmm6,0x60(%rsi)
+
+	vmovdqa		%xmm3,%xmm7
+	cmp		$0x80,%rcx
+	jl		.Lxorpart2
+	vpxord		0x70(%rdx),%xmm7,%xmm6
+	vmovdqu		%xmm6,0x70(%rsi)
+
+.Ldone2:
+	vzeroupper
+	ret
+
+.Lxorpart2:
+	# xor remaining bytes from partial register into output
+	mov		%rcx,%rax
+	and		$0xf,%rcx
+	jz		.Ldone8
+	mov		%rax,%r9
+	and		$~0xf,%r9
+
+	mov		$1,%rax
+	shld		%cl,%rax,%rax
+	sub		$1,%rax
+	kmovq		%rax,%k1
+
+	vmovdqu8	(%rdx,%r9),%xmm1{%k1}{z}
+	vpxord		%xmm7,%xmm1,%xmm1
+	vmovdqu8	%xmm1,(%rsi,%r9){%k1}
+
+	jmp		.Ldone2
+
+ENDPROC(chacha20_2block_xor_avx512vl)
+
 ENTRY(chacha20_8block_xor_avx512vl)
 	# %rdi: Input state matrix, s
 	# %rsi: up to 8 data blocks output, o
diff --git a/arch/x86/crypto/chacha20_glue.c b/arch/x86/crypto/chacha20_glue.c
index 6a67e70bc82a..d6a95a6a324e 100644
--- a/arch/x86/crypto/chacha20_glue.c
+++ b/arch/x86/crypto/chacha20_glue.c
@@ -32,6 +32,8 @@ asmlinkage void chacha20_8block_xor_avx2(u32 *state, u8 *dst, const u8 *src,
 					 unsigned int len);
 static bool chacha20_use_avx2;
 #ifdef CONFIG_AS_AVX512
+asmlinkage void chacha20_2block_xor_avx512vl(u32 *state, u8 *dst, const u8 *src,
+					     unsigned int len);
 asmlinkage void chacha20_8block_xor_avx512vl(u32 *state, u8 *dst, const u8 *src,
 					     unsigned int len);
 static bool chacha20_use_avx512vl;
@@ -62,6 +64,11 @@ static void chacha20_dosimd(u32 *state, u8 *dst, const u8 *src,
 			state[12] += chacha20_advance(bytes, 8);
 			return;
 		}
+		if (bytes) {
+			chacha20_2block_xor_avx512vl(state, dst, src, bytes);
+			state[12] += chacha20_advance(bytes, 2);
+			return;
+		}
 	}
 #endif
 	if (chacha20_use_avx2) {
-- 
2.17.1
