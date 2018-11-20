Return-Path: <SRS0=vxh5=N7=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from sitav-80046.hsr.ch ([152.96.80.46]:39062 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729117AbeKUDBB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Nov 2018 22:01:01 -0500
From: Martin Willi <martin@strongswan.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, x86@kernel.org
Subject: [PATCH 3/3] crypto: x86/chacha20 - Add a 4-block AVX-512VL variant
Date: Tue, 20 Nov 2018 17:30:50 +0100
Message-Id: <20181120163050.22251-4-martin@strongswan.org>
In-Reply-To: <20181120163050.22251-1-martin@strongswan.org>
References: <20181120163050.22251-1-martin@strongswan.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This version uses the same principle as the AVX2 version by scheduling the
operations for two block pairs in parallel. It benefits from the AVX-512VL
rotate instructions and the more efficient partial block handling using
"vmovdqu8", resulting in a speedup of the raw block function of ~20%.

Signed-off-by: Martin Willi <martin@strongswan.org>
---
 arch/x86/crypto/chacha20-avx512vl-x86_64.S | 272 +++++++++++++++++++++
 arch/x86/crypto/chacha20_glue.c            |   7 +
 2 files changed, 279 insertions(+)

diff --git a/arch/x86/crypto/chacha20-avx512vl-x86_64.S b/arch/x86/crypto/chacha20-avx512vl-x86_64.S
index 261097578715..55d34de29e3e 100644
--- a/arch/x86/crypto/chacha20-avx512vl-x86_64.S
+++ b/arch/x86/crypto/chacha20-avx512vl-x86_64.S
@@ -12,6 +12,11 @@
 CTR2BL:	.octa 0x00000000000000000000000000000000
 	.octa 0x00000000000000000000000000000001
 
+.section	.rodata.cst32.CTR4BL, "aM", @progbits, 32
+.align 32
+CTR4BL:	.octa 0x00000000000000000000000000000002
+	.octa 0x00000000000000000000000000000003
+
 .section	.rodata.cst32.CTR8BL, "aM", @progbits, 32
 .align 32
 CTR8BL:	.octa 0x00000003000000020000000100000000
@@ -185,6 +190,273 @@ ENTRY(chacha20_2block_xor_avx512vl)
 
 ENDPROC(chacha20_2block_xor_avx512vl)
 
+ENTRY(chacha20_4block_xor_avx512vl)
+	# %rdi: Input state matrix, s
+	# %rsi: up to 4 data blocks output, o
+	# %rdx: up to 4 data blocks input, i
+	# %rcx: input/output length in bytes
+
+	# This function encrypts four ChaCha20 block by loading the state
+	# matrix four times across eight AVX registers. It performs matrix
+	# operations on four words in two matrices in parallel, sequentially
+	# to the operations on the four words of the other two matrices. The
+	# required word shuffling has a rather high latency, we can do the
+	# arithmetic on two matrix-pairs without much slowdown.
+
+	vzeroupper
+
+	# x0..3[0-4] = s0..3
+	vbroadcasti128	0x00(%rdi),%ymm0
+	vbroadcasti128	0x10(%rdi),%ymm1
+	vbroadcasti128	0x20(%rdi),%ymm2
+	vbroadcasti128	0x30(%rdi),%ymm3
+
+	vmovdqa		%ymm0,%ymm4
+	vmovdqa		%ymm1,%ymm5
+	vmovdqa		%ymm2,%ymm6
+	vmovdqa		%ymm3,%ymm7
+
+	vpaddd		CTR2BL(%rip),%ymm3,%ymm3
+	vpaddd		CTR4BL(%rip),%ymm7,%ymm7
+
+	vmovdqa		%ymm0,%ymm11
+	vmovdqa		%ymm1,%ymm12
+	vmovdqa		%ymm2,%ymm13
+	vmovdqa		%ymm3,%ymm14
+	vmovdqa		%ymm7,%ymm15
+
+	mov		$10,%rax
+
+.Ldoubleround4:
+
+	# x0 += x1, x3 = rotl32(x3 ^ x0, 16)
+	vpaddd		%ymm1,%ymm0,%ymm0
+	vpxord		%ymm0,%ymm3,%ymm3
+	vprold		$16,%ymm3,%ymm3
+
+	vpaddd		%ymm5,%ymm4,%ymm4
+	vpxord		%ymm4,%ymm7,%ymm7
+	vprold		$16,%ymm7,%ymm7
+
+	# x2 += x3, x1 = rotl32(x1 ^ x2, 12)
+	vpaddd		%ymm3,%ymm2,%ymm2
+	vpxord		%ymm2,%ymm1,%ymm1
+	vprold		$12,%ymm1,%ymm1
+
+	vpaddd		%ymm7,%ymm6,%ymm6
+	vpxord		%ymm6,%ymm5,%ymm5
+	vprold		$12,%ymm5,%ymm5
+
+	# x0 += x1, x3 = rotl32(x3 ^ x0, 8)
+	vpaddd		%ymm1,%ymm0,%ymm0
+	vpxord		%ymm0,%ymm3,%ymm3
+	vprold		$8,%ymm3,%ymm3
+
+	vpaddd		%ymm5,%ymm4,%ymm4
+	vpxord		%ymm4,%ymm7,%ymm7
+	vprold		$8,%ymm7,%ymm7
+
+	# x2 += x3, x1 = rotl32(x1 ^ x2, 7)
+	vpaddd		%ymm3,%ymm2,%ymm2
+	vpxord		%ymm2,%ymm1,%ymm1
+	vprold		$7,%ymm1,%ymm1
+
+	vpaddd		%ymm7,%ymm6,%ymm6
+	vpxord		%ymm6,%ymm5,%ymm5
+	vprold		$7,%ymm5,%ymm5
+
+	# x1 = shuffle32(x1, MASK(0, 3, 2, 1))
+	vpshufd		$0x39,%ymm1,%ymm1
+	vpshufd		$0x39,%ymm5,%ymm5
+	# x2 = shuffle32(x2, MASK(1, 0, 3, 2))
+	vpshufd		$0x4e,%ymm2,%ymm2
+	vpshufd		$0x4e,%ymm6,%ymm6
+	# x3 = shuffle32(x3, MASK(2, 1, 0, 3))
+	vpshufd		$0x93,%ymm3,%ymm3
+	vpshufd		$0x93,%ymm7,%ymm7
+
+	# x0 += x1, x3 = rotl32(x3 ^ x0, 16)
+	vpaddd		%ymm1,%ymm0,%ymm0
+	vpxord		%ymm0,%ymm3,%ymm3
+	vprold		$16,%ymm3,%ymm3
+
+	vpaddd		%ymm5,%ymm4,%ymm4
+	vpxord		%ymm4,%ymm7,%ymm7
+	vprold		$16,%ymm7,%ymm7
+
+	# x2 += x3, x1 = rotl32(x1 ^ x2, 12)
+	vpaddd		%ymm3,%ymm2,%ymm2
+	vpxord		%ymm2,%ymm1,%ymm1
+	vprold		$12,%ymm1,%ymm1
+
+	vpaddd		%ymm7,%ymm6,%ymm6
+	vpxord		%ymm6,%ymm5,%ymm5
+	vprold		$12,%ymm5,%ymm5
+
+	# x0 += x1, x3 = rotl32(x3 ^ x0, 8)
+	vpaddd		%ymm1,%ymm0,%ymm0
+	vpxord		%ymm0,%ymm3,%ymm3
+	vprold		$8,%ymm3,%ymm3
+
+	vpaddd		%ymm5,%ymm4,%ymm4
+	vpxord		%ymm4,%ymm7,%ymm7
+	vprold		$8,%ymm7,%ymm7
+
+	# x2 += x3, x1 = rotl32(x1 ^ x2, 7)
+	vpaddd		%ymm3,%ymm2,%ymm2
+	vpxord		%ymm2,%ymm1,%ymm1
+	vprold		$7,%ymm1,%ymm1
+
+	vpaddd		%ymm7,%ymm6,%ymm6
+	vpxord		%ymm6,%ymm5,%ymm5
+	vprold		$7,%ymm5,%ymm5
+
+	# x1 = shuffle32(x1, MASK(2, 1, 0, 3))
+	vpshufd		$0x93,%ymm1,%ymm1
+	vpshufd		$0x93,%ymm5,%ymm5
+	# x2 = shuffle32(x2, MASK(1, 0, 3, 2))
+	vpshufd		$0x4e,%ymm2,%ymm2
+	vpshufd		$0x4e,%ymm6,%ymm6
+	# x3 = shuffle32(x3, MASK(0, 3, 2, 1))
+	vpshufd		$0x39,%ymm3,%ymm3
+	vpshufd		$0x39,%ymm7,%ymm7
+
+	dec		%rax
+	jnz		.Ldoubleround4
+
+	# o0 = i0 ^ (x0 + s0), first block
+	vpaddd		%ymm11,%ymm0,%ymm10
+	cmp		$0x10,%rcx
+	jl		.Lxorpart4
+	vpxord		0x00(%rdx),%xmm10,%xmm9
+	vmovdqu		%xmm9,0x00(%rsi)
+	vextracti128	$1,%ymm10,%xmm0
+	# o1 = i1 ^ (x1 + s1), first block
+	vpaddd		%ymm12,%ymm1,%ymm10
+	cmp		$0x20,%rcx
+	jl		.Lxorpart4
+	vpxord		0x10(%rdx),%xmm10,%xmm9
+	vmovdqu		%xmm9,0x10(%rsi)
+	vextracti128	$1,%ymm10,%xmm1
+	# o2 = i2 ^ (x2 + s2), first block
+	vpaddd		%ymm13,%ymm2,%ymm10
+	cmp		$0x30,%rcx
+	jl		.Lxorpart4
+	vpxord		0x20(%rdx),%xmm10,%xmm9
+	vmovdqu		%xmm9,0x20(%rsi)
+	vextracti128	$1,%ymm10,%xmm2
+	# o3 = i3 ^ (x3 + s3), first block
+	vpaddd		%ymm14,%ymm3,%ymm10
+	cmp		$0x40,%rcx
+	jl		.Lxorpart4
+	vpxord		0x30(%rdx),%xmm10,%xmm9
+	vmovdqu		%xmm9,0x30(%rsi)
+	vextracti128	$1,%ymm10,%xmm3
+
+	# xor and write second block
+	vmovdqa		%xmm0,%xmm10
+	cmp		$0x50,%rcx
+	jl		.Lxorpart4
+	vpxord		0x40(%rdx),%xmm10,%xmm9
+	vmovdqu		%xmm9,0x40(%rsi)
+
+	vmovdqa		%xmm1,%xmm10
+	cmp		$0x60,%rcx
+	jl		.Lxorpart4
+	vpxord		0x50(%rdx),%xmm10,%xmm9
+	vmovdqu		%xmm9,0x50(%rsi)
+
+	vmovdqa		%xmm2,%xmm10
+	cmp		$0x70,%rcx
+	jl		.Lxorpart4
+	vpxord		0x60(%rdx),%xmm10,%xmm9
+	vmovdqu		%xmm9,0x60(%rsi)
+
+	vmovdqa		%xmm3,%xmm10
+	cmp		$0x80,%rcx
+	jl		.Lxorpart4
+	vpxord		0x70(%rdx),%xmm10,%xmm9
+	vmovdqu		%xmm9,0x70(%rsi)
+
+	# o0 = i0 ^ (x0 + s0), third block
+	vpaddd		%ymm11,%ymm4,%ymm10
+	cmp		$0x90,%rcx
+	jl		.Lxorpart4
+	vpxord		0x80(%rdx),%xmm10,%xmm9
+	vmovdqu		%xmm9,0x80(%rsi)
+	vextracti128	$1,%ymm10,%xmm4
+	# o1 = i1 ^ (x1 + s1), third block
+	vpaddd		%ymm12,%ymm5,%ymm10
+	cmp		$0xa0,%rcx
+	jl		.Lxorpart4
+	vpxord		0x90(%rdx),%xmm10,%xmm9
+	vmovdqu		%xmm9,0x90(%rsi)
+	vextracti128	$1,%ymm10,%xmm5
+	# o2 = i2 ^ (x2 + s2), third block
+	vpaddd		%ymm13,%ymm6,%ymm10
+	cmp		$0xb0,%rcx
+	jl		.Lxorpart4
+	vpxord		0xa0(%rdx),%xmm10,%xmm9
+	vmovdqu		%xmm9,0xa0(%rsi)
+	vextracti128	$1,%ymm10,%xmm6
+	# o3 = i3 ^ (x3 + s3), third block
+	vpaddd		%ymm15,%ymm7,%ymm10
+	cmp		$0xc0,%rcx
+	jl		.Lxorpart4
+	vpxord		0xb0(%rdx),%xmm10,%xmm9
+	vmovdqu		%xmm9,0xb0(%rsi)
+	vextracti128	$1,%ymm10,%xmm7
+
+	# xor and write fourth block
+	vmovdqa		%xmm4,%xmm10
+	cmp		$0xd0,%rcx
+	jl		.Lxorpart4
+	vpxord		0xc0(%rdx),%xmm10,%xmm9
+	vmovdqu		%xmm9,0xc0(%rsi)
+
+	vmovdqa		%xmm5,%xmm10
+	cmp		$0xe0,%rcx
+	jl		.Lxorpart4
+	vpxord		0xd0(%rdx),%xmm10,%xmm9
+	vmovdqu		%xmm9,0xd0(%rsi)
+
+	vmovdqa		%xmm6,%xmm10
+	cmp		$0xf0,%rcx
+	jl		.Lxorpart4
+	vpxord		0xe0(%rdx),%xmm10,%xmm9
+	vmovdqu		%xmm9,0xe0(%rsi)
+
+	vmovdqa		%xmm7,%xmm10
+	cmp		$0x100,%rcx
+	jl		.Lxorpart4
+	vpxord		0xf0(%rdx),%xmm10,%xmm9
+	vmovdqu		%xmm9,0xf0(%rsi)
+
+.Ldone4:
+	vzeroupper
+	ret
+
+.Lxorpart4:
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
+	vpxord		%xmm10,%xmm1,%xmm1
+	vmovdqu8	%xmm1,(%rsi,%r9){%k1}
+
+	jmp		.Ldone4
+
+ENDPROC(chacha20_4block_xor_avx512vl)
+
 ENTRY(chacha20_8block_xor_avx512vl)
 	# %rdi: Input state matrix, s
 	# %rsi: up to 8 data blocks output, o
diff --git a/arch/x86/crypto/chacha20_glue.c b/arch/x86/crypto/chacha20_glue.c
index d6a95a6a324e..773d075a1483 100644
--- a/arch/x86/crypto/chacha20_glue.c
+++ b/arch/x86/crypto/chacha20_glue.c
@@ -34,6 +34,8 @@ static bool chacha20_use_avx2;
 #ifdef CONFIG_AS_AVX512
 asmlinkage void chacha20_2block_xor_avx512vl(u32 *state, u8 *dst, const u8 *src,
 					     unsigned int len);
+asmlinkage void chacha20_4block_xor_avx512vl(u32 *state, u8 *dst, const u8 *src,
+					     unsigned int len);
 asmlinkage void chacha20_8block_xor_avx512vl(u32 *state, u8 *dst, const u8 *src,
 					     unsigned int len);
 static bool chacha20_use_avx512vl;
@@ -64,6 +66,11 @@ static void chacha20_dosimd(u32 *state, u8 *dst, const u8 *src,
 			state[12] += chacha20_advance(bytes, 8);
 			return;
 		}
+		if (bytes > CHACHA_BLOCK_SIZE * 2) {
+			chacha20_4block_xor_avx512vl(state, dst, src, bytes);
+			state[12] += chacha20_advance(bytes, 4);
+			return;
+		}
 		if (bytes) {
 			chacha20_2block_xor_avx512vl(state, dst, src, bytes);
 			state[12] += chacha20_advance(bytes, 2);
-- 
2.17.1
