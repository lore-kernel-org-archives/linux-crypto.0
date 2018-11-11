Return-Path: <SRS0=7Tml=NW=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from sitav-80046.hsr.ch ([152.96.80.46]:33514 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727376AbeKKTYs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 11 Nov 2018 14:24:48 -0500
From: Martin Willi <martin@strongswan.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, x86@kernel.org
Subject: [PATCH 1/6] crypto: x86/chacha20 - Support partial lengths in 1-block SSSE3 variant
Date: Sun, 11 Nov 2018 10:36:25 +0100
Message-Id: <20181111093630.28107-2-martin@strongswan.org>
In-Reply-To: <20181111093630.28107-1-martin@strongswan.org>
References: <20181111093630.28107-1-martin@strongswan.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add a length argument to the single block function for SSSE3, so the
block function may XOR only a partial length of the full block. Given
that the setup code is rather cheap, the function does not process more
than one block; this allows us to keep the block function selection in
the C glue code.

The required branching does not negatively affect performance for full
block sizes. The partial XORing uses simple "rep movsb" to copy the
data before and after doing XOR in SSE. This is rather efficient on
modern processors; movsw can be slightly faster, but the additional
complexity is probably not worth it.

Signed-off-by: Martin Willi <martin@strongswan.org>
---
 arch/x86/crypto/chacha20-ssse3-x86_64.S | 74 ++++++++++++++++++++-----
 arch/x86/crypto/chacha20_glue.c         | 11 ++--
 2 files changed, 63 insertions(+), 22 deletions(-)

diff --git a/arch/x86/crypto/chacha20-ssse3-x86_64.S b/arch/x86/crypto/chacha20-ssse3-x86_64.S
index 512a2b500fd1..98d130b5e4ab 100644
--- a/arch/x86/crypto/chacha20-ssse3-x86_64.S
+++ b/arch/x86/crypto/chacha20-ssse3-x86_64.S
@@ -25,12 +25,13 @@ CTRINC:	.octa 0x00000003000000020000000100000000
 
 ENTRY(chacha20_block_xor_ssse3)
 	# %rdi: Input state matrix, s
-	# %rsi: 1 data block output, o
-	# %rdx: 1 data block input, i
+	# %rsi: up to 1 data block output, o
+	# %rdx: up to 1 data block input, i
+	# %rcx: input/output length in bytes
 
 	# This function encrypts one ChaCha20 block by loading the state matrix
 	# in four SSE registers. It performs matrix operation on four words in
-	# parallel, but requireds shuffling to rearrange the words after each
+	# parallel, but requires shuffling to rearrange the words after each
 	# round. 8/16-bit word rotation is done with the slightly better
 	# performing SSSE3 byte shuffling, 7/12-bit word rotation uses
 	# traditional shift+OR.
@@ -48,7 +49,8 @@ ENTRY(chacha20_block_xor_ssse3)
 	movdqa		ROT8(%rip),%xmm4
 	movdqa		ROT16(%rip),%xmm5
 
-	mov	$10,%ecx
+	mov		%rcx,%rax
+	mov		$10,%ecx
 
 .Ldoubleround:
 
@@ -122,27 +124,69 @@ ENTRY(chacha20_block_xor_ssse3)
 	jnz		.Ldoubleround
 
 	# o0 = i0 ^ (x0 + s0)
-	movdqu		0x00(%rdx),%xmm4
 	paddd		%xmm8,%xmm0
+	cmp		$0x10,%rax
+	jl		.Lxorpart
+	movdqu		0x00(%rdx),%xmm4
 	pxor		%xmm4,%xmm0
 	movdqu		%xmm0,0x00(%rsi)
 	# o1 = i1 ^ (x1 + s1)
-	movdqu		0x10(%rdx),%xmm5
 	paddd		%xmm9,%xmm1
-	pxor		%xmm5,%xmm1
-	movdqu		%xmm1,0x10(%rsi)
+	movdqa		%xmm1,%xmm0
+	cmp		$0x20,%rax
+	jl		.Lxorpart
+	movdqu		0x10(%rdx),%xmm0
+	pxor		%xmm1,%xmm0
+	movdqu		%xmm0,0x10(%rsi)
 	# o2 = i2 ^ (x2 + s2)
-	movdqu		0x20(%rdx),%xmm6
 	paddd		%xmm10,%xmm2
-	pxor		%xmm6,%xmm2
-	movdqu		%xmm2,0x20(%rsi)
+	movdqa		%xmm2,%xmm0
+	cmp		$0x30,%rax
+	jl		.Lxorpart
+	movdqu		0x20(%rdx),%xmm0
+	pxor		%xmm2,%xmm0
+	movdqu		%xmm0,0x20(%rsi)
 	# o3 = i3 ^ (x3 + s3)
-	movdqu		0x30(%rdx),%xmm7
 	paddd		%xmm11,%xmm3
-	pxor		%xmm7,%xmm3
-	movdqu		%xmm3,0x30(%rsi)
-
+	movdqa		%xmm3,%xmm0
+	cmp		$0x40,%rax
+	jl		.Lxorpart
+	movdqu		0x30(%rdx),%xmm0
+	pxor		%xmm3,%xmm0
+	movdqu		%xmm0,0x30(%rsi)
+
+.Ldone:
 	ret
+
+.Lxorpart:
+	# xor remaining bytes from partial register into output
+	mov		%rax,%r9
+	and		$0x0f,%r9
+	jz		.Ldone
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
+	pxor		0x00(%rsp),%xmm0
+	movdqa		%xmm0,0x00(%rsp)
+
+	mov		%rsp,%rsi
+	lea		(%r11,%rax),%rdi
+	mov		%r9,%rcx
+	rep movsb
+
+	lea		-8(%r10),%rsp
+	jmp		.Ldone
+
 ENDPROC(chacha20_block_xor_ssse3)
 
 ENTRY(chacha20_4block_xor_ssse3)
diff --git a/arch/x86/crypto/chacha20_glue.c b/arch/x86/crypto/chacha20_glue.c
index dce7c5d39c2f..cc4571736ce8 100644
--- a/arch/x86/crypto/chacha20_glue.c
+++ b/arch/x86/crypto/chacha20_glue.c
@@ -19,7 +19,8 @@
 
 #define CHACHA20_STATE_ALIGN 16
 
-asmlinkage void chacha20_block_xor_ssse3(u32 *state, u8 *dst, const u8 *src);
+asmlinkage void chacha20_block_xor_ssse3(u32 *state, u8 *dst, const u8 *src,
+					 unsigned int len);
 asmlinkage void chacha20_4block_xor_ssse3(u32 *state, u8 *dst, const u8 *src);
 #ifdef CONFIG_AS_AVX2
 asmlinkage void chacha20_8block_xor_avx2(u32 *state, u8 *dst, const u8 *src);
@@ -29,8 +30,6 @@ static bool chacha20_use_avx2;
 static void chacha20_dosimd(u32 *state, u8 *dst, const u8 *src,
 			    unsigned int bytes)
 {
-	u8 buf[CHACHA20_BLOCK_SIZE];
-
 #ifdef CONFIG_AS_AVX2
 	if (chacha20_use_avx2) {
 		while (bytes >= CHACHA20_BLOCK_SIZE * 8) {
@@ -50,16 +49,14 @@ static void chacha20_dosimd(u32 *state, u8 *dst, const u8 *src,
 		state[12] += 4;
 	}
 	while (bytes >= CHACHA20_BLOCK_SIZE) {
-		chacha20_block_xor_ssse3(state, dst, src);
+		chacha20_block_xor_ssse3(state, dst, src, bytes);
 		bytes -= CHACHA20_BLOCK_SIZE;
 		src += CHACHA20_BLOCK_SIZE;
 		dst += CHACHA20_BLOCK_SIZE;
 		state[12]++;
 	}
 	if (bytes) {
-		memcpy(buf, src, bytes);
-		chacha20_block_xor_ssse3(state, buf, buf);
-		memcpy(dst, buf, bytes);
+		chacha20_block_xor_ssse3(state, dst, src, bytes);
 	}
 }
 
-- 
2.17.1
