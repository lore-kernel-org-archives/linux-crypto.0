Return-Path: <SRS0=7Tml=NW=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from sitav-80046.hsr.ch ([152.96.80.46]:33526 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727386AbeKKTYv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 11 Nov 2018 14:24:51 -0500
From: Martin Willi <martin@strongswan.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, x86@kernel.org
Subject: [PATCH 5/6] crypto: x86/chacha20 - Add a 2-block AVX2 variant
Date: Sun, 11 Nov 2018 10:36:29 +0100
Message-Id: <20181111093630.28107-6-martin@strongswan.org>
In-Reply-To: <20181111093630.28107-1-martin@strongswan.org>
References: <20181111093630.28107-1-martin@strongswan.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This variant uses the same principle as the single block SSSE3 variant
by shuffling the state matrix after each round. With the wider AVX
registers, we can do two blocks in parallel, though.

This function can increase performance and efficiency significantly for
lengths that would otherwise require a 4-block function.

Signed-off-by: Martin Willi <martin@strongswan.org>
---
 arch/x86/crypto/chacha20-avx2-x86_64.S | 197 +++++++++++++++++++++++++
 arch/x86/crypto/chacha20_glue.c        |   7 +
 2 files changed, 204 insertions(+)

diff --git a/arch/x86/crypto/chacha20-avx2-x86_64.S b/arch/x86/crypto/chacha20-avx2-x86_64.S
index 7b62d55bee3d..8247076b0ba7 100644
--- a/arch/x86/crypto/chacha20-avx2-x86_64.S
+++ b/arch/x86/crypto/chacha20-avx2-x86_64.S
@@ -26,8 +26,205 @@ ROT16:	.octa 0x0d0c0f0e09080b0a0504070601000302
 CTRINC:	.octa 0x00000003000000020000000100000000
 	.octa 0x00000007000000060000000500000004
 
+.section	.rodata.cst32.CTR2BL, "aM", @progbits, 32
+.align 32
+CTR2BL:	.octa 0x00000000000000000000000000000000
+	.octa 0x00000000000000000000000000000001
+
 .text
 
+ENTRY(chacha20_2block_xor_avx2)
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
+	vmovdqa		ROT8(%rip),%ymm4
+	vmovdqa		ROT16(%rip),%ymm5
+
+	mov		%rcx,%rax
+	mov		$10,%ecx
+
+.Ldoubleround:
+
+	# x0 += x1, x3 = rotl32(x3 ^ x0, 16)
+	vpaddd		%ymm1,%ymm0,%ymm0
+	vpxor		%ymm0,%ymm3,%ymm3
+	vpshufb		%ymm5,%ymm3,%ymm3
+
+	# x2 += x3, x1 = rotl32(x1 ^ x2, 12)
+	vpaddd		%ymm3,%ymm2,%ymm2
+	vpxor		%ymm2,%ymm1,%ymm1
+	vmovdqa		%ymm1,%ymm6
+	vpslld		$12,%ymm6,%ymm6
+	vpsrld		$20,%ymm1,%ymm1
+	vpor		%ymm6,%ymm1,%ymm1
+
+	# x0 += x1, x3 = rotl32(x3 ^ x0, 8)
+	vpaddd		%ymm1,%ymm0,%ymm0
+	vpxor		%ymm0,%ymm3,%ymm3
+	vpshufb		%ymm4,%ymm3,%ymm3
+
+	# x2 += x3, x1 = rotl32(x1 ^ x2, 7)
+	vpaddd		%ymm3,%ymm2,%ymm2
+	vpxor		%ymm2,%ymm1,%ymm1
+	vmovdqa		%ymm1,%ymm7
+	vpslld		$7,%ymm7,%ymm7
+	vpsrld		$25,%ymm1,%ymm1
+	vpor		%ymm7,%ymm1,%ymm1
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
+	vpxor		%ymm0,%ymm3,%ymm3
+	vpshufb		%ymm5,%ymm3,%ymm3
+
+	# x2 += x3, x1 = rotl32(x1 ^ x2, 12)
+	vpaddd		%ymm3,%ymm2,%ymm2
+	vpxor		%ymm2,%ymm1,%ymm1
+	vmovdqa		%ymm1,%ymm6
+	vpslld		$12,%ymm6,%ymm6
+	vpsrld		$20,%ymm1,%ymm1
+	vpor		%ymm6,%ymm1,%ymm1
+
+	# x0 += x1, x3 = rotl32(x3 ^ x0, 8)
+	vpaddd		%ymm1,%ymm0,%ymm0
+	vpxor		%ymm0,%ymm3,%ymm3
+	vpshufb		%ymm4,%ymm3,%ymm3
+
+	# x2 += x3, x1 = rotl32(x1 ^ x2, 7)
+	vpaddd		%ymm3,%ymm2,%ymm2
+	vpxor		%ymm2,%ymm1,%ymm1
+	vmovdqa		%ymm1,%ymm7
+	vpslld		$7,%ymm7,%ymm7
+	vpsrld		$25,%ymm1,%ymm1
+	vpor		%ymm7,%ymm1,%ymm1
+
+	# x1 = shuffle32(x1, MASK(2, 1, 0, 3))
+	vpshufd		$0x93,%ymm1,%ymm1
+	# x2 = shuffle32(x2, MASK(1, 0, 3, 2))
+	vpshufd		$0x4e,%ymm2,%ymm2
+	# x3 = shuffle32(x3, MASK(0, 3, 2, 1))
+	vpshufd		$0x39,%ymm3,%ymm3
+
+	dec		%ecx
+	jnz		.Ldoubleround
+
+	# o0 = i0 ^ (x0 + s0)
+	vpaddd		%ymm8,%ymm0,%ymm7
+	cmp		$0x10,%rax
+	jl		.Lxorpart2
+	vpxor		0x00(%rdx),%xmm7,%xmm6
+	vmovdqu		%xmm6,0x00(%rsi)
+	vextracti128	$1,%ymm7,%xmm0
+	# o1 = i1 ^ (x1 + s1)
+	vpaddd		%ymm9,%ymm1,%ymm7
+	cmp		$0x20,%rax
+	jl		.Lxorpart2
+	vpxor		0x10(%rdx),%xmm7,%xmm6
+	vmovdqu		%xmm6,0x10(%rsi)
+	vextracti128	$1,%ymm7,%xmm1
+	# o2 = i2 ^ (x2 + s2)
+	vpaddd		%ymm10,%ymm2,%ymm7
+	cmp		$0x30,%rax
+	jl		.Lxorpart2
+	vpxor		0x20(%rdx),%xmm7,%xmm6
+	vmovdqu		%xmm6,0x20(%rsi)
+	vextracti128	$1,%ymm7,%xmm2
+	# o3 = i3 ^ (x3 + s3)
+	vpaddd		%ymm11,%ymm3,%ymm7
+	cmp		$0x40,%rax
+	jl		.Lxorpart2
+	vpxor		0x30(%rdx),%xmm7,%xmm6
+	vmovdqu		%xmm6,0x30(%rsi)
+	vextracti128	$1,%ymm7,%xmm3
+
+	# xor and write second block
+	vmovdqa		%xmm0,%xmm7
+	cmp		$0x50,%rax
+	jl		.Lxorpart2
+	vpxor		0x40(%rdx),%xmm7,%xmm6
+	vmovdqu		%xmm6,0x40(%rsi)
+
+	vmovdqa		%xmm1,%xmm7
+	cmp		$0x60,%rax
+	jl		.Lxorpart2
+	vpxor		0x50(%rdx),%xmm7,%xmm6
+	vmovdqu		%xmm6,0x50(%rsi)
+
+	vmovdqa		%xmm2,%xmm7
+	cmp		$0x70,%rax
+	jl		.Lxorpart2
+	vpxor		0x60(%rdx),%xmm7,%xmm6
+	vmovdqu		%xmm6,0x60(%rsi)
+
+	vmovdqa		%xmm3,%xmm7
+	cmp		$0x80,%rax
+	jl		.Lxorpart2
+	vpxor		0x70(%rdx),%xmm7,%xmm6
+	vmovdqu		%xmm6,0x70(%rsi)
+
+.Ldone2:
+	vzeroupper
+	ret
+
+.Lxorpart2:
+	# xor remaining bytes from partial register into output
+	mov		%rax,%r9
+	and		$0x0f,%r9
+	jz		.Ldone2
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
+	vpxor		0x00(%rsp),%xmm7,%xmm7
+	vmovdqa		%xmm7,0x00(%rsp)
+
+	mov		%rsp,%rsi
+	lea		(%r11,%rax),%rdi
+	mov		%r9,%rcx
+	rep movsb
+
+	lea		-8(%r10),%rsp
+	jmp		.Ldone2
+
+ENDPROC(chacha20_2block_xor_avx2)
+
 ENTRY(chacha20_8block_xor_avx2)
 	# %rdi: Input state matrix, s
 	# %rsi: up to 8 data blocks output, o
diff --git a/arch/x86/crypto/chacha20_glue.c b/arch/x86/crypto/chacha20_glue.c
index b541da71f11e..82e46589a189 100644
--- a/arch/x86/crypto/chacha20_glue.c
+++ b/arch/x86/crypto/chacha20_glue.c
@@ -24,6 +24,8 @@ asmlinkage void chacha20_block_xor_ssse3(u32 *state, u8 *dst, const u8 *src,
 asmlinkage void chacha20_4block_xor_ssse3(u32 *state, u8 *dst, const u8 *src,
 					  unsigned int len);
 #ifdef CONFIG_AS_AVX2
+asmlinkage void chacha20_2block_xor_avx2(u32 *state, u8 *dst, const u8 *src,
+					 unsigned int len);
 asmlinkage void chacha20_8block_xor_avx2(u32 *state, u8 *dst, const u8 *src,
 					 unsigned int len);
 static bool chacha20_use_avx2;
@@ -52,6 +54,11 @@ static void chacha20_dosimd(u32 *state, u8 *dst, const u8 *src,
 			state[12] += chacha20_advance(bytes, 8);
 			return;
 		}
+		if (bytes > CHACHA20_BLOCK_SIZE) {
+			chacha20_2block_xor_avx2(state, dst, src, bytes);
+			state[12] += chacha20_advance(bytes, 2);
+			return;
+		}
 	}
 #endif
 	while (bytes >= CHACHA20_BLOCK_SIZE * 4) {
-- 
2.17.1
