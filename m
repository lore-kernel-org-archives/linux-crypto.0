Return-Path: <SRS0=7Tml=NW=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from sitav-80046.hsr.ch ([152.96.80.46]:33518 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727386AbeKKTYs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 11 Nov 2018 14:24:48 -0500
From: Martin Willi <martin@strongswan.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, x86@kernel.org
Subject: [PATCH 3/6] crypto: x86/chacha20 - Support partial lengths in 8-block AVX2 variant
Date: Sun, 11 Nov 2018 10:36:27 +0100
Message-Id: <20181111093630.28107-4-martin@strongswan.org>
In-Reply-To: <20181111093630.28107-1-martin@strongswan.org>
References: <20181111093630.28107-1-martin@strongswan.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add a length argument to the eight block function for AVX2, so the
block function may XOR only a partial length of eight blocks.

To avoid unnecessary operations, we integrate XORing of the first four
blocks in the final lane interleaving; this also avoids some work in
the partial lengths path.

Signed-off-by: Martin Willi <martin@strongswan.org>
---
 arch/x86/crypto/chacha20-avx2-x86_64.S | 189 +++++++++++++++++--------
 arch/x86/crypto/chacha20_glue.c        |   5 +-
 2 files changed, 133 insertions(+), 61 deletions(-)

diff --git a/arch/x86/crypto/chacha20-avx2-x86_64.S b/arch/x86/crypto/chacha20-avx2-x86_64.S
index f3cd26f48332..7b62d55bee3d 100644
--- a/arch/x86/crypto/chacha20-avx2-x86_64.S
+++ b/arch/x86/crypto/chacha20-avx2-x86_64.S
@@ -30,8 +30,9 @@ CTRINC:	.octa 0x00000003000000020000000100000000
 
 ENTRY(chacha20_8block_xor_avx2)
 	# %rdi: Input state matrix, s
-	# %rsi: 8 data blocks output, o
-	# %rdx: 8 data blocks input, i
+	# %rsi: up to 8 data blocks output, o
+	# %rdx: up to 8 data blocks input, i
+	# %rcx: input/output length in bytes
 
 	# This function encrypts eight consecutive ChaCha20 blocks by loading
 	# the state matrix in AVX registers eight times. As we need some
@@ -48,6 +49,7 @@ ENTRY(chacha20_8block_xor_avx2)
 	lea		8(%rsp),%r10
 	and		$~31, %rsp
 	sub		$0x80, %rsp
+	mov		%rcx,%rax
 
 	# x0..15[0-7] = s[0..15]
 	vpbroadcastd	0x00(%rdi),%ymm0
@@ -375,74 +377,143 @@ ENTRY(chacha20_8block_xor_avx2)
 	vpunpckhqdq	%ymm15,%ymm0,%ymm15
 
 	# interleave 128-bit words in state n, n+4
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
+	# xor/write first four blocks
+	vmovdqa		0x00(%rsp),%ymm1
+	vperm2i128	$0x20,%ymm4,%ymm1,%ymm0
+	cmp		$0x0020,%rax
+	jl		.Lxorpart8
+	vpxor		0x0000(%rdx),%ymm0,%ymm0
+	vmovdqu		%ymm0,0x0000(%rsi)
+	vperm2i128	$0x31,%ymm4,%ymm1,%ymm4
+
 	vperm2i128	$0x20,%ymm12,%ymm8,%ymm0
+	cmp		$0x0040,%rax
+	jl		.Lxorpart8
+	vpxor		0x0020(%rdx),%ymm0,%ymm0
+	vmovdqu		%ymm0,0x0020(%rsi)
 	vperm2i128	$0x31,%ymm12,%ymm8,%ymm12
-	vmovdqa		%ymm0,%ymm8
-	vperm2i128	$0x20,%ymm13,%ymm9,%ymm0
-	vperm2i128	$0x31,%ymm13,%ymm9,%ymm13
-	vmovdqa		%ymm0,%ymm9
+
+	vmovdqa		0x40(%rsp),%ymm1
+	vperm2i128	$0x20,%ymm6,%ymm1,%ymm0
+	cmp		$0x0060,%rax
+	jl		.Lxorpart8
+	vpxor		0x0040(%rdx),%ymm0,%ymm0
+	vmovdqu		%ymm0,0x0040(%rsi)
+	vperm2i128	$0x31,%ymm6,%ymm1,%ymm6
+
 	vperm2i128	$0x20,%ymm14,%ymm10,%ymm0
+	cmp		$0x0080,%rax
+	jl		.Lxorpart8
+	vpxor		0x0060(%rdx),%ymm0,%ymm0
+	vmovdqu		%ymm0,0x0060(%rsi)
 	vperm2i128	$0x31,%ymm14,%ymm10,%ymm14
-	vmovdqa		%ymm0,%ymm10
-	vperm2i128	$0x20,%ymm15,%ymm11,%ymm0
-	vperm2i128	$0x31,%ymm15,%ymm11,%ymm15
-	vmovdqa		%ymm0,%ymm11
 
-	# xor with corresponding input, write to output
-	vmovdqa		0x00(%rsp),%ymm0
-	vpxor		0x0000(%rdx),%ymm0,%ymm0
-	vmovdqu		%ymm0,0x0000(%rsi)
-	vmovdqa		0x20(%rsp),%ymm0
+	vmovdqa		0x20(%rsp),%ymm1
+	vperm2i128	$0x20,%ymm5,%ymm1,%ymm0
+	cmp		$0x00a0,%rax
+	jl		.Lxorpart8
 	vpxor		0x0080(%rdx),%ymm0,%ymm0
 	vmovdqu		%ymm0,0x0080(%rsi)
-	vmovdqa		0x40(%rsp),%ymm0
-	vpxor		0x0040(%rdx),%ymm0,%ymm0
-	vmovdqu		%ymm0,0x0040(%rsi)
-	vmovdqa		0x60(%rsp),%ymm0
+	vperm2i128	$0x31,%ymm5,%ymm1,%ymm5
+
+	vperm2i128	$0x20,%ymm13,%ymm9,%ymm0
+	cmp		$0x00c0,%rax
+	jl		.Lxorpart8
+	vpxor		0x00a0(%rdx),%ymm0,%ymm0
+	vmovdqu		%ymm0,0x00a0(%rsi)
+	vperm2i128	$0x31,%ymm13,%ymm9,%ymm13
+
+	vmovdqa		0x60(%rsp),%ymm1
+	vperm2i128	$0x20,%ymm7,%ymm1,%ymm0
+	cmp		$0x00e0,%rax
+	jl		.Lxorpart8
 	vpxor		0x00c0(%rdx),%ymm0,%ymm0
 	vmovdqu		%ymm0,0x00c0(%rsi)
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
+	vperm2i128	$0x31,%ymm7,%ymm1,%ymm7
+
+	vperm2i128	$0x20,%ymm15,%ymm11,%ymm0
+	cmp		$0x0100,%rax
+	jl		.Lxorpart8
+	vpxor		0x00e0(%rdx),%ymm0,%ymm0
+	vmovdqu		%ymm0,0x00e0(%rsi)
+	vperm2i128	$0x31,%ymm15,%ymm11,%ymm15
+
+	# xor remaining blocks, write to output
+	vmovdqa		%ymm4,%ymm0
+	cmp		$0x0120,%rax
+	jl		.Lxorpart8
+	vpxor		0x0100(%rdx),%ymm0,%ymm0
+	vmovdqu		%ymm0,0x0100(%rsi)
 
+	vmovdqa		%ymm12,%ymm0
+	cmp		$0x0140,%rax
+	jl		.Lxorpart8
+	vpxor		0x0120(%rdx),%ymm0,%ymm0
+	vmovdqu		%ymm0,0x0120(%rsi)
+
+	vmovdqa		%ymm6,%ymm0
+	cmp		$0x0160,%rax
+	jl		.Lxorpart8
+	vpxor		0x0140(%rdx),%ymm0,%ymm0
+	vmovdqu		%ymm0,0x0140(%rsi)
+
+	vmovdqa		%ymm14,%ymm0
+	cmp		$0x0180,%rax
+	jl		.Lxorpart8
+	vpxor		0x0160(%rdx),%ymm0,%ymm0
+	vmovdqu		%ymm0,0x0160(%rsi)
+
+	vmovdqa		%ymm5,%ymm0
+	cmp		$0x01a0,%rax
+	jl		.Lxorpart8
+	vpxor		0x0180(%rdx),%ymm0,%ymm0
+	vmovdqu		%ymm0,0x0180(%rsi)
+
+	vmovdqa		%ymm13,%ymm0
+	cmp		$0x01c0,%rax
+	jl		.Lxorpart8
+	vpxor		0x01a0(%rdx),%ymm0,%ymm0
+	vmovdqu		%ymm0,0x01a0(%rsi)
+
+	vmovdqa		%ymm7,%ymm0
+	cmp		$0x01e0,%rax
+	jl		.Lxorpart8
+	vpxor		0x01c0(%rdx),%ymm0,%ymm0
+	vmovdqu		%ymm0,0x01c0(%rsi)
+
+	vmovdqa		%ymm15,%ymm0
+	cmp		$0x0200,%rax
+	jl		.Lxorpart8
+	vpxor		0x01e0(%rdx),%ymm0,%ymm0
+	vmovdqu		%ymm0,0x01e0(%rsi)
+
+.Ldone8:
 	vzeroupper
 	lea		-8(%r10),%rsp
 	ret
+
+.Lxorpart8:
+	# xor remaining bytes from partial register into output
+	mov		%rax,%r9
+	and		$0x1f,%r9
+	jz		.Ldone8
+	and		$~0x1f,%rax
+
+	mov		%rsi,%r11
+
+	lea		(%rdx,%rax),%rsi
+	mov		%rsp,%rdi
+	mov		%r9,%rcx
+	rep movsb
+
+	vpxor		0x00(%rsp),%ymm0,%ymm0
+	vmovdqa		%ymm0,0x00(%rsp)
+
+	mov		%rsp,%rsi
+	lea		(%r11,%rax),%rdi
+	mov		%r9,%rcx
+	rep movsb
+
+	jmp		.Ldone8
+
 ENDPROC(chacha20_8block_xor_avx2)
diff --git a/arch/x86/crypto/chacha20_glue.c b/arch/x86/crypto/chacha20_glue.c
index 8f1ef1a9ce5c..882e8bf5965a 100644
--- a/arch/x86/crypto/chacha20_glue.c
+++ b/arch/x86/crypto/chacha20_glue.c
@@ -24,7 +24,8 @@ asmlinkage void chacha20_block_xor_ssse3(u32 *state, u8 *dst, const u8 *src,
 asmlinkage void chacha20_4block_xor_ssse3(u32 *state, u8 *dst, const u8 *src,
 					  unsigned int len);
 #ifdef CONFIG_AS_AVX2
-asmlinkage void chacha20_8block_xor_avx2(u32 *state, u8 *dst, const u8 *src);
+asmlinkage void chacha20_8block_xor_avx2(u32 *state, u8 *dst, const u8 *src,
+					 unsigned int len);
 static bool chacha20_use_avx2;
 #endif
 
@@ -34,7 +35,7 @@ static void chacha20_dosimd(u32 *state, u8 *dst, const u8 *src,
 #ifdef CONFIG_AS_AVX2
 	if (chacha20_use_avx2) {
 		while (bytes >= CHACHA20_BLOCK_SIZE * 8) {
-			chacha20_8block_xor_avx2(state, dst, src);
+			chacha20_8block_xor_avx2(state, dst, src, bytes);
 			bytes -= CHACHA20_BLOCK_SIZE * 8;
 			src += CHACHA20_BLOCK_SIZE * 8;
 			dst += CHACHA20_BLOCK_SIZE * 8;
-- 
2.17.1
