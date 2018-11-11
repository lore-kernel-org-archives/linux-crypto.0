Return-Path: <SRS0=7Tml=NW=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from sitav-80046.hsr.ch ([152.96.80.46]:33527 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727408AbeKKTYw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 11 Nov 2018 14:24:52 -0500
From: Martin Willi <martin@strongswan.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, x86@kernel.org
Subject: [PATCH 6/6] crypto: x86/chacha20 - Add a 4-block AVX2 variant
Date: Sun, 11 Nov 2018 10:36:30 +0100
Message-Id: <20181111093630.28107-7-martin@strongswan.org>
In-Reply-To: <20181111093630.28107-1-martin@strongswan.org>
References: <20181111093630.28107-1-martin@strongswan.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This variant builds upon the idea of the 2-block AVX2 variant that
shuffles words after each round. The shuffling has a rather high latency,
so the arithmetic units are not optimally used.

Given that we have plenty of registers in AVX, this version parallelizes
the 2-block variant to do four blocks. While the first two blocks are
shuffling, the CPU can do the XORing on the second two blocks and
vice-versa, which makes this version much faster than the SSSE3 variant
for four blocks. The latter is now mostly for systems that do not have
AVX2, but there it is the work-horse, so we keep it in place.

The partial XORing function trailer is very similar to the AVX2 2-block
variant. While it could be shared, that code segment is rather short;
profiling is also easier with the trailer integrated, so we keep it per
function.

Signed-off-by: Martin Willi <martin@strongswan.org>
---
 arch/x86/crypto/chacha20-avx2-x86_64.S | 310 +++++++++++++++++++++++++
 arch/x86/crypto/chacha20_glue.c        |   7 +
 2 files changed, 317 insertions(+)

diff --git a/arch/x86/crypto/chacha20-avx2-x86_64.S b/arch/x86/crypto/chacha20-avx2-x86_64.S
index 8247076b0ba7..b6ab082be657 100644
--- a/arch/x86/crypto/chacha20-avx2-x86_64.S
+++ b/arch/x86/crypto/chacha20-avx2-x86_64.S
@@ -31,6 +31,11 @@ CTRINC:	.octa 0x00000003000000020000000100000000
 CTR2BL:	.octa 0x00000000000000000000000000000000
 	.octa 0x00000000000000000000000000000001
 
+.section	.rodata.cst32.CTR4BL, "aM", @progbits, 32
+.align 32
+CTR4BL:	.octa 0x00000000000000000000000000000002
+	.octa 0x00000000000000000000000000000003
+
 .text
 
 ENTRY(chacha20_2block_xor_avx2)
@@ -225,6 +230,311 @@ ENTRY(chacha20_2block_xor_avx2)
 
 ENDPROC(chacha20_2block_xor_avx2)
 
+ENTRY(chacha20_4block_xor_avx2)
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
+	vmovdqa		ROT8(%rip),%ymm8
+	vmovdqa		ROT16(%rip),%ymm9
+
+	mov		%rcx,%rax
+	mov		$10,%ecx
+
+.Ldoubleround4:
+
+	# x0 += x1, x3 = rotl32(x3 ^ x0, 16)
+	vpaddd		%ymm1,%ymm0,%ymm0
+	vpxor		%ymm0,%ymm3,%ymm3
+	vpshufb		%ymm9,%ymm3,%ymm3
+
+	vpaddd		%ymm5,%ymm4,%ymm4
+	vpxor		%ymm4,%ymm7,%ymm7
+	vpshufb		%ymm9,%ymm7,%ymm7
+
+	# x2 += x3, x1 = rotl32(x1 ^ x2, 12)
+	vpaddd		%ymm3,%ymm2,%ymm2
+	vpxor		%ymm2,%ymm1,%ymm1
+	vmovdqa		%ymm1,%ymm10
+	vpslld		$12,%ymm10,%ymm10
+	vpsrld		$20,%ymm1,%ymm1
+	vpor		%ymm10,%ymm1,%ymm1
+
+	vpaddd		%ymm7,%ymm6,%ymm6
+	vpxor		%ymm6,%ymm5,%ymm5
+	vmovdqa		%ymm5,%ymm10
+	vpslld		$12,%ymm10,%ymm10
+	vpsrld		$20,%ymm5,%ymm5
+	vpor		%ymm10,%ymm5,%ymm5
+
+	# x0 += x1, x3 = rotl32(x3 ^ x0, 8)
+	vpaddd		%ymm1,%ymm0,%ymm0
+	vpxor		%ymm0,%ymm3,%ymm3
+	vpshufb		%ymm8,%ymm3,%ymm3
+
+	vpaddd		%ymm5,%ymm4,%ymm4
+	vpxor		%ymm4,%ymm7,%ymm7
+	vpshufb		%ymm8,%ymm7,%ymm7
+
+	# x2 += x3, x1 = rotl32(x1 ^ x2, 7)
+	vpaddd		%ymm3,%ymm2,%ymm2
+	vpxor		%ymm2,%ymm1,%ymm1
+	vmovdqa		%ymm1,%ymm10
+	vpslld		$7,%ymm10,%ymm10
+	vpsrld		$25,%ymm1,%ymm1
+	vpor		%ymm10,%ymm1,%ymm1
+
+	vpaddd		%ymm7,%ymm6,%ymm6
+	vpxor		%ymm6,%ymm5,%ymm5
+	vmovdqa		%ymm5,%ymm10
+	vpslld		$7,%ymm10,%ymm10
+	vpsrld		$25,%ymm5,%ymm5
+	vpor		%ymm10,%ymm5,%ymm5
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
+	vpxor		%ymm0,%ymm3,%ymm3
+	vpshufb		%ymm9,%ymm3,%ymm3
+
+	vpaddd		%ymm5,%ymm4,%ymm4
+	vpxor		%ymm4,%ymm7,%ymm7
+	vpshufb		%ymm9,%ymm7,%ymm7
+
+	# x2 += x3, x1 = rotl32(x1 ^ x2, 12)
+	vpaddd		%ymm3,%ymm2,%ymm2
+	vpxor		%ymm2,%ymm1,%ymm1
+	vmovdqa		%ymm1,%ymm10
+	vpslld		$12,%ymm10,%ymm10
+	vpsrld		$20,%ymm1,%ymm1
+	vpor		%ymm10,%ymm1,%ymm1
+
+	vpaddd		%ymm7,%ymm6,%ymm6
+	vpxor		%ymm6,%ymm5,%ymm5
+	vmovdqa		%ymm5,%ymm10
+	vpslld		$12,%ymm10,%ymm10
+	vpsrld		$20,%ymm5,%ymm5
+	vpor		%ymm10,%ymm5,%ymm5
+
+	# x0 += x1, x3 = rotl32(x3 ^ x0, 8)
+	vpaddd		%ymm1,%ymm0,%ymm0
+	vpxor		%ymm0,%ymm3,%ymm3
+	vpshufb		%ymm8,%ymm3,%ymm3
+
+	vpaddd		%ymm5,%ymm4,%ymm4
+	vpxor		%ymm4,%ymm7,%ymm7
+	vpshufb		%ymm8,%ymm7,%ymm7
+
+	# x2 += x3, x1 = rotl32(x1 ^ x2, 7)
+	vpaddd		%ymm3,%ymm2,%ymm2
+	vpxor		%ymm2,%ymm1,%ymm1
+	vmovdqa		%ymm1,%ymm10
+	vpslld		$7,%ymm10,%ymm10
+	vpsrld		$25,%ymm1,%ymm1
+	vpor		%ymm10,%ymm1,%ymm1
+
+	vpaddd		%ymm7,%ymm6,%ymm6
+	vpxor		%ymm6,%ymm5,%ymm5
+	vmovdqa		%ymm5,%ymm10
+	vpslld		$7,%ymm10,%ymm10
+	vpsrld		$25,%ymm5,%ymm5
+	vpor		%ymm10,%ymm5,%ymm5
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
+	dec		%ecx
+	jnz		.Ldoubleround4
+
+	# o0 = i0 ^ (x0 + s0), first block
+	vpaddd		%ymm11,%ymm0,%ymm10
+	cmp		$0x10,%rax
+	jl		.Lxorpart4
+	vpxor		0x00(%rdx),%xmm10,%xmm9
+	vmovdqu		%xmm9,0x00(%rsi)
+	vextracti128	$1,%ymm10,%xmm0
+	# o1 = i1 ^ (x1 + s1), first block
+	vpaddd		%ymm12,%ymm1,%ymm10
+	cmp		$0x20,%rax
+	jl		.Lxorpart4
+	vpxor		0x10(%rdx),%xmm10,%xmm9
+	vmovdqu		%xmm9,0x10(%rsi)
+	vextracti128	$1,%ymm10,%xmm1
+	# o2 = i2 ^ (x2 + s2), first block
+	vpaddd		%ymm13,%ymm2,%ymm10
+	cmp		$0x30,%rax
+	jl		.Lxorpart4
+	vpxor		0x20(%rdx),%xmm10,%xmm9
+	vmovdqu		%xmm9,0x20(%rsi)
+	vextracti128	$1,%ymm10,%xmm2
+	# o3 = i3 ^ (x3 + s3), first block
+	vpaddd		%ymm14,%ymm3,%ymm10
+	cmp		$0x40,%rax
+	jl		.Lxorpart4
+	vpxor		0x30(%rdx),%xmm10,%xmm9
+	vmovdqu		%xmm9,0x30(%rsi)
+	vextracti128	$1,%ymm10,%xmm3
+
+	# xor and write second block
+	vmovdqa		%xmm0,%xmm10
+	cmp		$0x50,%rax
+	jl		.Lxorpart4
+	vpxor		0x40(%rdx),%xmm10,%xmm9
+	vmovdqu		%xmm9,0x40(%rsi)
+
+	vmovdqa		%xmm1,%xmm10
+	cmp		$0x60,%rax
+	jl		.Lxorpart4
+	vpxor		0x50(%rdx),%xmm10,%xmm9
+	vmovdqu		%xmm9,0x50(%rsi)
+
+	vmovdqa		%xmm2,%xmm10
+	cmp		$0x70,%rax
+	jl		.Lxorpart4
+	vpxor		0x60(%rdx),%xmm10,%xmm9
+	vmovdqu		%xmm9,0x60(%rsi)
+
+	vmovdqa		%xmm3,%xmm10
+	cmp		$0x80,%rax
+	jl		.Lxorpart4
+	vpxor		0x70(%rdx),%xmm10,%xmm9
+	vmovdqu		%xmm9,0x70(%rsi)
+
+	# o0 = i0 ^ (x0 + s0), third block
+	vpaddd		%ymm11,%ymm4,%ymm10
+	cmp		$0x90,%rax
+	jl		.Lxorpart4
+	vpxor		0x80(%rdx),%xmm10,%xmm9
+	vmovdqu		%xmm9,0x80(%rsi)
+	vextracti128	$1,%ymm10,%xmm4
+	# o1 = i1 ^ (x1 + s1), third block
+	vpaddd		%ymm12,%ymm5,%ymm10
+	cmp		$0xa0,%rax
+	jl		.Lxorpart4
+	vpxor		0x90(%rdx),%xmm10,%xmm9
+	vmovdqu		%xmm9,0x90(%rsi)
+	vextracti128	$1,%ymm10,%xmm5
+	# o2 = i2 ^ (x2 + s2), third block
+	vpaddd		%ymm13,%ymm6,%ymm10
+	cmp		$0xb0,%rax
+	jl		.Lxorpart4
+	vpxor		0xa0(%rdx),%xmm10,%xmm9
+	vmovdqu		%xmm9,0xa0(%rsi)
+	vextracti128	$1,%ymm10,%xmm6
+	# o3 = i3 ^ (x3 + s3), third block
+	vpaddd		%ymm15,%ymm7,%ymm10
+	cmp		$0xc0,%rax
+	jl		.Lxorpart4
+	vpxor		0xb0(%rdx),%xmm10,%xmm9
+	vmovdqu		%xmm9,0xb0(%rsi)
+	vextracti128	$1,%ymm10,%xmm7
+
+	# xor and write fourth block
+	vmovdqa		%xmm4,%xmm10
+	cmp		$0xd0,%rax
+	jl		.Lxorpart4
+	vpxor		0xc0(%rdx),%xmm10,%xmm9
+	vmovdqu		%xmm9,0xc0(%rsi)
+
+	vmovdqa		%xmm5,%xmm10
+	cmp		$0xe0,%rax
+	jl		.Lxorpart4
+	vpxor		0xd0(%rdx),%xmm10,%xmm9
+	vmovdqu		%xmm9,0xd0(%rsi)
+
+	vmovdqa		%xmm6,%xmm10
+	cmp		$0xf0,%rax
+	jl		.Lxorpart4
+	vpxor		0xe0(%rdx),%xmm10,%xmm9
+	vmovdqu		%xmm9,0xe0(%rsi)
+
+	vmovdqa		%xmm7,%xmm10
+	cmp		$0x100,%rax
+	jl		.Lxorpart4
+	vpxor		0xf0(%rdx),%xmm10,%xmm9
+	vmovdqu		%xmm9,0xf0(%rsi)
+
+.Ldone4:
+	vzeroupper
+	ret
+
+.Lxorpart4:
+	# xor remaining bytes from partial register into output
+	mov		%rax,%r9
+	and		$0x0f,%r9
+	jz		.Ldone4
+	and		$~0x0f,%rax
+
+	mov		%rsi,%r11
+
+	lea		8(%rsp),%r10
+	sub		$0x10,%rsp
+	and		$~31,%rsp
+
+	lea		(%rdx,%rax),%rsi
+	mov		%rsp,%rdi
+	mov		%r9,%rcx
+	rep movsb
+
+	vpxor		0x00(%rsp),%xmm10,%xmm10
+	vmovdqa		%xmm10,0x00(%rsp)
+
+	mov		%rsp,%rsi
+	lea		(%r11,%rax),%rdi
+	mov		%r9,%rcx
+	rep movsb
+
+	lea		-8(%r10),%rsp
+	jmp		.Ldone4
+
+ENDPROC(chacha20_4block_xor_avx2)
+
 ENTRY(chacha20_8block_xor_avx2)
 	# %rdi: Input state matrix, s
 	# %rsi: up to 8 data blocks output, o
diff --git a/arch/x86/crypto/chacha20_glue.c b/arch/x86/crypto/chacha20_glue.c
index 82e46589a189..9fd84fe6ec09 100644
--- a/arch/x86/crypto/chacha20_glue.c
+++ b/arch/x86/crypto/chacha20_glue.c
@@ -26,6 +26,8 @@ asmlinkage void chacha20_4block_xor_ssse3(u32 *state, u8 *dst, const u8 *src,
 #ifdef CONFIG_AS_AVX2
 asmlinkage void chacha20_2block_xor_avx2(u32 *state, u8 *dst, const u8 *src,
 					 unsigned int len);
+asmlinkage void chacha20_4block_xor_avx2(u32 *state, u8 *dst, const u8 *src,
+					 unsigned int len);
 asmlinkage void chacha20_8block_xor_avx2(u32 *state, u8 *dst, const u8 *src,
 					 unsigned int len);
 static bool chacha20_use_avx2;
@@ -54,6 +56,11 @@ static void chacha20_dosimd(u32 *state, u8 *dst, const u8 *src,
 			state[12] += chacha20_advance(bytes, 8);
 			return;
 		}
+		if (bytes > CHACHA20_BLOCK_SIZE * 2) {
+			chacha20_4block_xor_avx2(state, dst, src, bytes);
+			state[12] += chacha20_advance(bytes, 4);
+			return;
+		}
 		if (bytes > CHACHA20_BLOCK_SIZE) {
 			chacha20_2block_xor_avx2(state, dst, src, bytes);
 			state[12] += chacha20_advance(bytes, 2);
-- 
2.17.1
