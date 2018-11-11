Return-Path: <SRS0=7Tml=NW=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from sitav-80046.hsr.ch ([152.96.80.46]:33516 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727334AbeKKTYs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 11 Nov 2018 14:24:48 -0500
From: Martin Willi <martin@strongswan.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, x86@kernel.org
Subject: [PATCH 2/6] crypto: x86/chacha20 - Support partial lengths in 4-block SSSE3 variant
Date: Sun, 11 Nov 2018 10:36:26 +0100
Message-Id: <20181111093630.28107-3-martin@strongswan.org>
In-Reply-To: <20181111093630.28107-1-martin@strongswan.org>
References: <20181111093630.28107-1-martin@strongswan.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add a length argument to the quad block function for SSSE3, so the
block function may XOR only a partial length of four blocks.

As we already have the stack set up, the partial XORing does not need
to. This gives a slightly different function trailer, so we keep that
separate from the 1-block function.

Signed-off-by: Martin Willi <martin@strongswan.org>
---
 arch/x86/crypto/chacha20-ssse3-x86_64.S | 163 ++++++++++++++++++------
 arch/x86/crypto/chacha20_glue.c         |   5 +-
 2 files changed, 128 insertions(+), 40 deletions(-)

diff --git a/arch/x86/crypto/chacha20-ssse3-x86_64.S b/arch/x86/crypto/chacha20-ssse3-x86_64.S
index 98d130b5e4ab..d8ac75bb448f 100644
--- a/arch/x86/crypto/chacha20-ssse3-x86_64.S
+++ b/arch/x86/crypto/chacha20-ssse3-x86_64.S
@@ -191,8 +191,9 @@ ENDPROC(chacha20_block_xor_ssse3)
 
 ENTRY(chacha20_4block_xor_ssse3)
 	# %rdi: Input state matrix, s
-	# %rsi: 4 data blocks output, o
-	# %rdx: 4 data blocks input, i
+	# %rsi: up to 4 data blocks output, o
+	# %rdx: up to 4 data blocks input, i
+	# %rcx: input/output length in bytes
 
 	# This function encrypts four consecutive ChaCha20 blocks by loading the
 	# the state matrix in SSE registers four times. As we need some scratch
@@ -207,6 +208,7 @@ ENTRY(chacha20_4block_xor_ssse3)
 	lea		8(%rsp),%r10
 	sub		$0x80,%rsp
 	and		$~63,%rsp
+	mov		%rcx,%rax
 
 	# x0..15[0-3] = s0..3[0..3]
 	movq		0x00(%rdi),%xmm1
@@ -617,58 +619,143 @@ ENTRY(chacha20_4block_xor_ssse3)
 
 	# xor with corresponding input, write to output
 	movdqa		0x00(%rsp),%xmm0
+	cmp		$0x10,%rax
+	jl		.Lxorpart4
 	movdqu		0x00(%rdx),%xmm1
 	pxor		%xmm1,%xmm0
 	movdqu		%xmm0,0x00(%rsi)
-	movdqa		0x10(%rsp),%xmm0
-	movdqu		0x80(%rdx),%xmm1
+
+	movdqu		%xmm4,%xmm0
+	cmp		$0x20,%rax
+	jl		.Lxorpart4
+	movdqu		0x10(%rdx),%xmm1
 	pxor		%xmm1,%xmm0
-	movdqu		%xmm0,0x80(%rsi)
+	movdqu		%xmm0,0x10(%rsi)
+
+	movdqu		%xmm8,%xmm0
+	cmp		$0x30,%rax
+	jl		.Lxorpart4
+	movdqu		0x20(%rdx),%xmm1
+	pxor		%xmm1,%xmm0
+	movdqu		%xmm0,0x20(%rsi)
+
+	movdqu		%xmm12,%xmm0
+	cmp		$0x40,%rax
+	jl		.Lxorpart4
+	movdqu		0x30(%rdx),%xmm1
+	pxor		%xmm1,%xmm0
+	movdqu		%xmm0,0x30(%rsi)
+
 	movdqa		0x20(%rsp),%xmm0
+	cmp		$0x50,%rax
+	jl		.Lxorpart4
 	movdqu		0x40(%rdx),%xmm1
 	pxor		%xmm1,%xmm0
 	movdqu		%xmm0,0x40(%rsi)
+
+	movdqu		%xmm6,%xmm0
+	cmp		$0x60,%rax
+	jl		.Lxorpart4
+	movdqu		0x50(%rdx),%xmm1
+	pxor		%xmm1,%xmm0
+	movdqu		%xmm0,0x50(%rsi)
+
+	movdqu		%xmm10,%xmm0
+	cmp		$0x70,%rax
+	jl		.Lxorpart4
+	movdqu		0x60(%rdx),%xmm1
+	pxor		%xmm1,%xmm0
+	movdqu		%xmm0,0x60(%rsi)
+
+	movdqu		%xmm14,%xmm0
+	cmp		$0x80,%rax
+	jl		.Lxorpart4
+	movdqu		0x70(%rdx),%xmm1
+	pxor		%xmm1,%xmm0
+	movdqu		%xmm0,0x70(%rsi)
+
+	movdqa		0x10(%rsp),%xmm0
+	cmp		$0x90,%rax
+	jl		.Lxorpart4
+	movdqu		0x80(%rdx),%xmm1
+	pxor		%xmm1,%xmm0
+	movdqu		%xmm0,0x80(%rsi)
+
+	movdqu		%xmm5,%xmm0
+	cmp		$0xa0,%rax
+	jl		.Lxorpart4
+	movdqu		0x90(%rdx),%xmm1
+	pxor		%xmm1,%xmm0
+	movdqu		%xmm0,0x90(%rsi)
+
+	movdqu		%xmm9,%xmm0
+	cmp		$0xb0,%rax
+	jl		.Lxorpart4
+	movdqu		0xa0(%rdx),%xmm1
+	pxor		%xmm1,%xmm0
+	movdqu		%xmm0,0xa0(%rsi)
+
+	movdqu		%xmm13,%xmm0
+	cmp		$0xc0,%rax
+	jl		.Lxorpart4
+	movdqu		0xb0(%rdx),%xmm1
+	pxor		%xmm1,%xmm0
+	movdqu		%xmm0,0xb0(%rsi)
+
 	movdqa		0x30(%rsp),%xmm0
+	cmp		$0xd0,%rax
+	jl		.Lxorpart4
 	movdqu		0xc0(%rdx),%xmm1
 	pxor		%xmm1,%xmm0
 	movdqu		%xmm0,0xc0(%rsi)
-	movdqu		0x10(%rdx),%xmm1
-	pxor		%xmm1,%xmm4
-	movdqu		%xmm4,0x10(%rsi)
-	movdqu		0x90(%rdx),%xmm1
-	pxor		%xmm1,%xmm5
-	movdqu		%xmm5,0x90(%rsi)
-	movdqu		0x50(%rdx),%xmm1
-	pxor		%xmm1,%xmm6
-	movdqu		%xmm6,0x50(%rsi)
+
+	movdqu		%xmm7,%xmm0
+	cmp		$0xe0,%rax
+	jl		.Lxorpart4
 	movdqu		0xd0(%rdx),%xmm1
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
+	pxor		%xmm1,%xmm0
+	movdqu		%xmm0,0xd0(%rsi)
+
+	movdqu		%xmm11,%xmm0
+	cmp		$0xf0,%rax
+	jl		.Lxorpart4
 	movdqu		0xe0(%rdx),%xmm1
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
+	pxor		%xmm1,%xmm0
+	movdqu		%xmm0,0xe0(%rsi)
+
+	movdqu		%xmm15,%xmm0
+	cmp		$0x100,%rax
+	jl		.Lxorpart4
 	movdqu		0xf0(%rdx),%xmm1
-	pxor		%xmm1,%xmm15
-	movdqu		%xmm15,0xf0(%rsi)
+	pxor		%xmm1,%xmm0
+	movdqu		%xmm0,0xf0(%rsi)
 
+.Ldone4:
 	lea		-8(%r10),%rsp
 	ret
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
+	lea		(%rdx,%rax),%rsi
+	mov		%rsp,%rdi
+	mov		%r9,%rcx
+	rep movsb
+
+	pxor		0x00(%rsp),%xmm0
+	movdqa		%xmm0,0x00(%rsp)
+
+	mov		%rsp,%rsi
+	lea		(%r11,%rax),%rdi
+	mov		%r9,%rcx
+	rep movsb
+
+	jmp		.Ldone4
+
 ENDPROC(chacha20_4block_xor_ssse3)
diff --git a/arch/x86/crypto/chacha20_glue.c b/arch/x86/crypto/chacha20_glue.c
index cc4571736ce8..8f1ef1a9ce5c 100644
--- a/arch/x86/crypto/chacha20_glue.c
+++ b/arch/x86/crypto/chacha20_glue.c
@@ -21,7 +21,8 @@
 
 asmlinkage void chacha20_block_xor_ssse3(u32 *state, u8 *dst, const u8 *src,
 					 unsigned int len);
-asmlinkage void chacha20_4block_xor_ssse3(u32 *state, u8 *dst, const u8 *src);
+asmlinkage void chacha20_4block_xor_ssse3(u32 *state, u8 *dst, const u8 *src,
+					  unsigned int len);
 #ifdef CONFIG_AS_AVX2
 asmlinkage void chacha20_8block_xor_avx2(u32 *state, u8 *dst, const u8 *src);
 static bool chacha20_use_avx2;
@@ -42,7 +43,7 @@ static void chacha20_dosimd(u32 *state, u8 *dst, const u8 *src,
 	}
 #endif
 	while (bytes >= CHACHA20_BLOCK_SIZE * 4) {
-		chacha20_4block_xor_ssse3(state, dst, src);
+		chacha20_4block_xor_ssse3(state, dst, src, bytes);
 		bytes -= CHACHA20_BLOCK_SIZE * 4;
 		src += CHACHA20_BLOCK_SIZE * 4;
 		dst += CHACHA20_BLOCK_SIZE * 4;
-- 
2.17.1
