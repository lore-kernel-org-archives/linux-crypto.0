From: Martin Willi <martin@strongswan.org>
Subject: [PATCH 04/10] crypto: chacha20 - Add a four block SSSE3 variant for x86_64
Date: Tue,  7 Jul 2015 21:36:50 +0200
Message-ID: <1436297816-16414-5-git-send-email-martin@strongswan.org>
References: <1436297816-16414-1-git-send-email-martin@strongswan.org>
Cc: x86@kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from revosec.ch ([5.148.177.19]:44661 "EHLO revosec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933251AbbGGThV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jul 2015 15:37:21 -0400
In-Reply-To: <1436297816-16414-1-git-send-email-martin@strongswan.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Extends the x86_64 SSSE3 ChaCha20 implementation by a function processing
four ChaCha20 blocks in parallel. This avoids the word shuffling needed
in the single block variant, further increasing throughput.

For large messages, throughput increases by ~110% compared to single block
SSSE3:

testing speed of chacha20 (chacha20-simd) encryption
test 0 (256 bit key, 16 byte blocks): 4154698 operations in 1 seconds (66475168 bytes)
test 1 (256 bit key, 64 byte blocks): 4593368 operations in 1 seconds (293975552 bytes)
test 2 (256 bit key, 256 byte blocks): 1796194 operations in 1 seconds (459825664 bytes)
test 3 (256 bit key, 1024 byte blocks): 519725 operations in 1 seconds (532198400 bytes)
test 4 (256 bit key, 8192 byte blocks): 67132 operations in 1 seconds (549945344 bytes)

testing speed of chacha20 (chacha20-simd) encryption
test 0 (256 bit key, 16 byte blocks): 4164293 operations in 1 seconds (66628688 bytes)
test 1 (256 bit key, 64 byte blocks): 4545912 operations in 1 seconds (290938368 bytes)
test 2 (256 bit key, 256 byte blocks): 3238241 operations in 1 seconds (828989696 bytes)
test 3 (256 bit key, 1024 byte blocks): 1120664 operations in 1 seconds (1147559936 bytes)
test 4 (256 bit key, 8192 byte blocks): 140107 operations in 1 seconds (1147756544 bytes)

Benchmark results from a Core i5-4670T.

Signed-off-by: Martin Willi <martin@strongswan.org>
---
 arch/x86/crypto/chacha20-ssse3-x86_64.S | 483 ++++++++++++++++++++++++++++++++
 arch/x86/crypto/chacha20_glue.c         |   8 +
 2 files changed, 491 insertions(+)

diff --git a/arch/x86/crypto/chacha20-ssse3-x86_64.S b/arch/x86/crypto/chacha20-ssse3-x86_64.S
index 1b97ad0..712b130 100644
--- a/arch/x86/crypto/chacha20-ssse3-x86_64.S
+++ b/arch/x86/crypto/chacha20-ssse3-x86_64.S
@@ -16,6 +16,7 @@
 
 ROT8:	.octa 0x0e0d0c0f0a09080b0605040702010003
 ROT16:	.octa 0x0d0c0f0e09080b0a0504070601000302
+CTRINC:	.octa 0x00000003000000020000000100000000
 
 .text
 
@@ -140,3 +141,485 @@ ENTRY(chacha20_block_xor_ssse3)
 
 	ret
 ENDPROC(chacha20_block_xor_ssse3)
+
+ENTRY(chacha20_4block_xor_ssse3)
+	# %rdi: Input state matrix, s
+	# %rsi: 4 data blocks output, o
+	# %rdx: 4 data blocks input, i
+
+	# This function encrypts four consecutive ChaCha20 blocks by loading the
+	# the state matrix in SSE registers four times. As we need some scratch
+	# registers, we save the first four registers on the stack. The
+	# algorithm performs each operation on the corresponding word of each
+	# state matrix, hence requires no word shuffling. For final XORing step
+	# we transpose the matrix by interleaving 32- and then 64-bit words,
+	# which allows us to do XOR in SSE registers. 8/16-bit word rotation is
+	# done with the slightly better performing SSSE3 byte shuffling,
+	# 7/12-bit word rotation uses traditional shift+OR.
+
+	sub		$0x40,%rsp
+
+	# x0..15[0-3] = s0..3[0..3]
+	movq		0x00(%rdi),%xmm1
+	pshufd		$0x00,%xmm1,%xmm0
+	pshufd		$0x55,%xmm1,%xmm1
+	movq		0x08(%rdi),%xmm3
+	pshufd		$0x00,%xmm3,%xmm2
+	pshufd		$0x55,%xmm3,%xmm3
+	movq		0x10(%rdi),%xmm5
+	pshufd		$0x00,%xmm5,%xmm4
+	pshufd		$0x55,%xmm5,%xmm5
+	movq		0x18(%rdi),%xmm7
+	pshufd		$0x00,%xmm7,%xmm6
+	pshufd		$0x55,%xmm7,%xmm7
+	movq		0x20(%rdi),%xmm9
+	pshufd		$0x00,%xmm9,%xmm8
+	pshufd		$0x55,%xmm9,%xmm9
+	movq		0x28(%rdi),%xmm11
+	pshufd		$0x00,%xmm11,%xmm10
+	pshufd		$0x55,%xmm11,%xmm11
+	movq		0x30(%rdi),%xmm13
+	pshufd		$0x00,%xmm13,%xmm12
+	pshufd		$0x55,%xmm13,%xmm13
+	movq		0x38(%rdi),%xmm15
+	pshufd		$0x00,%xmm15,%xmm14
+	pshufd		$0x55,%xmm15,%xmm15
+	# x0..3 on stack
+	movdqa		%xmm0,0x00(%rsp)
+	movdqa		%xmm1,0x10(%rsp)
+	movdqa		%xmm2,0x20(%rsp)
+	movdqa		%xmm3,0x30(%rsp)
+
+	movdqa		CTRINC(%rip),%xmm1
+	movdqa		ROT8(%rip),%xmm2
+	movdqa		ROT16(%rip),%xmm3
+
+	# x12 += counter values 0-3
+	paddd		%xmm1,%xmm12
+
+	mov		$10,%ecx
+
+.Ldoubleround4:
+	# x0 += x4, x12 = rotl32(x12 ^ x0, 16)
+	movdqa		0x00(%rsp),%xmm0
+	paddd		%xmm4,%xmm0
+	movdqa		%xmm0,0x00(%rsp)
+	pxor		%xmm0,%xmm12
+	pshufb		%xmm3,%xmm12
+	# x1 += x5, x13 = rotl32(x13 ^ x1, 16)
+	movdqa		0x10(%rsp),%xmm0
+	paddd		%xmm5,%xmm0
+	movdqa		%xmm0,0x10(%rsp)
+	pxor		%xmm0,%xmm13
+	pshufb		%xmm3,%xmm13
+	# x2 += x6, x14 = rotl32(x14 ^ x2, 16)
+	movdqa		0x20(%rsp),%xmm0
+	paddd		%xmm6,%xmm0
+	movdqa		%xmm0,0x20(%rsp)
+	pxor		%xmm0,%xmm14
+	pshufb		%xmm3,%xmm14
+	# x3 += x7, x15 = rotl32(x15 ^ x3, 16)
+	movdqa		0x30(%rsp),%xmm0
+	paddd		%xmm7,%xmm0
+	movdqa		%xmm0,0x30(%rsp)
+	pxor		%xmm0,%xmm15
+	pshufb		%xmm3,%xmm15
+
+	# x8 += x12, x4 = rotl32(x4 ^ x8, 12)
+	paddd		%xmm12,%xmm8
+	pxor		%xmm8,%xmm4
+	movdqa		%xmm4,%xmm0
+	pslld		$12,%xmm0
+	psrld		$20,%xmm4
+	por		%xmm0,%xmm4
+	# x9 += x13, x5 = rotl32(x5 ^ x9, 12)
+	paddd		%xmm13,%xmm9
+	pxor		%xmm9,%xmm5
+	movdqa		%xmm5,%xmm0
+	pslld		$12,%xmm0
+	psrld		$20,%xmm5
+	por		%xmm0,%xmm5
+	# x10 += x14, x6 = rotl32(x6 ^ x10, 12)
+	paddd		%xmm14,%xmm10
+	pxor		%xmm10,%xmm6
+	movdqa		%xmm6,%xmm0
+	pslld		$12,%xmm0
+	psrld		$20,%xmm6
+	por		%xmm0,%xmm6
+	# x11 += x15, x7 = rotl32(x7 ^ x11, 12)
+	paddd		%xmm15,%xmm11
+	pxor		%xmm11,%xmm7
+	movdqa		%xmm7,%xmm0
+	pslld		$12,%xmm0
+	psrld		$20,%xmm7
+	por		%xmm0,%xmm7
+
+	# x0 += x4, x12 = rotl32(x12 ^ x0, 8)
+	movdqa		0x00(%rsp),%xmm0
+	paddd		%xmm4,%xmm0
+	movdqa		%xmm0,0x00(%rsp)
+	pxor		%xmm0,%xmm12
+	pshufb		%xmm2,%xmm12
+	# x1 += x5, x13 = rotl32(x13 ^ x1, 8)
+	movdqa		0x10(%rsp),%xmm0
+	paddd		%xmm5,%xmm0
+	movdqa		%xmm0,0x10(%rsp)
+	pxor		%xmm0,%xmm13
+	pshufb		%xmm2,%xmm13
+	# x2 += x6, x14 = rotl32(x14 ^ x2, 8)
+	movdqa		0x20(%rsp),%xmm0
+	paddd		%xmm6,%xmm0
+	movdqa		%xmm0,0x20(%rsp)
+	pxor		%xmm0,%xmm14
+	pshufb		%xmm2,%xmm14
+	# x3 += x7, x15 = rotl32(x15 ^ x3, 8)
+	movdqa		0x30(%rsp),%xmm0
+	paddd		%xmm7,%xmm0
+	movdqa		%xmm0,0x30(%rsp)
+	pxor		%xmm0,%xmm15
+	pshufb		%xmm2,%xmm15
+
+	# x8 += x12, x4 = rotl32(x4 ^ x8, 7)
+	paddd		%xmm12,%xmm8
+	pxor		%xmm8,%xmm4
+	movdqa		%xmm4,%xmm0
+	pslld		$7,%xmm0
+	psrld		$25,%xmm4
+	por		%xmm0,%xmm4
+	# x9 += x13, x5 = rotl32(x5 ^ x9, 7)
+	paddd		%xmm13,%xmm9
+	pxor		%xmm9,%xmm5
+	movdqa		%xmm5,%xmm0
+	pslld		$7,%xmm0
+	psrld		$25,%xmm5
+	por		%xmm0,%xmm5
+	# x10 += x14, x6 = rotl32(x6 ^ x10, 7)
+	paddd		%xmm14,%xmm10
+	pxor		%xmm10,%xmm6
+	movdqa		%xmm6,%xmm0
+	pslld		$7,%xmm0
+	psrld		$25,%xmm6
+	por		%xmm0,%xmm6
+	# x11 += x15, x7 = rotl32(x7 ^ x11, 7)
+	paddd		%xmm15,%xmm11
+	pxor		%xmm11,%xmm7
+	movdqa		%xmm7,%xmm0
+	pslld		$7,%xmm0
+	psrld		$25,%xmm7
+	por		%xmm0,%xmm7
+
+	# x0 += x5, x15 = rotl32(x15 ^ x0, 16)
+	movdqa		0x00(%rsp),%xmm0
+	paddd		%xmm5,%xmm0
+	movdqa		%xmm0,0x00(%rsp)
+	pxor		%xmm0,%xmm15
+	pshufb		%xmm3,%xmm15
+	# x1 += x6, x12 = rotl32(x12 ^ x1, 16)
+	movdqa		0x10(%rsp),%xmm0
+	paddd		%xmm6,%xmm0
+	movdqa		%xmm0,0x10(%rsp)
+	pxor		%xmm0,%xmm12
+	pshufb		%xmm3,%xmm12
+	# x2 += x7, x13 = rotl32(x13 ^ x2, 16)
+	movdqa		0x20(%rsp),%xmm0
+	paddd		%xmm7,%xmm0
+	movdqa		%xmm0,0x20(%rsp)
+	pxor		%xmm0,%xmm13
+	pshufb		%xmm3,%xmm13
+	# x3 += x4, x14 = rotl32(x14 ^ x3, 16)
+	movdqa		0x30(%rsp),%xmm0
+	paddd		%xmm4,%xmm0
+	movdqa		%xmm0,0x30(%rsp)
+	pxor		%xmm0,%xmm14
+	pshufb		%xmm3,%xmm14
+
+	# x10 += x15, x5 = rotl32(x5 ^ x10, 12)
+	paddd		%xmm15,%xmm10
+	pxor		%xmm10,%xmm5
+	movdqa		%xmm5,%xmm0
+	pslld		$12,%xmm0
+	psrld		$20,%xmm5
+	por		%xmm0,%xmm5
+	# x11 += x12, x6 = rotl32(x6 ^ x11, 12)
+	paddd		%xmm12,%xmm11
+	pxor		%xmm11,%xmm6
+	movdqa		%xmm6,%xmm0
+	pslld		$12,%xmm0
+	psrld		$20,%xmm6
+	por		%xmm0,%xmm6
+	# x8 += x13, x7 = rotl32(x7 ^ x8, 12)
+	paddd		%xmm13,%xmm8
+	pxor		%xmm8,%xmm7
+	movdqa		%xmm7,%xmm0
+	pslld		$12,%xmm0
+	psrld		$20,%xmm7
+	por		%xmm0,%xmm7
+	# x9 += x14, x4 = rotl32(x4 ^ x9, 12)
+	paddd		%xmm14,%xmm9
+	pxor		%xmm9,%xmm4
+	movdqa		%xmm4,%xmm0
+	pslld		$12,%xmm0
+	psrld		$20,%xmm4
+	por		%xmm0,%xmm4
+
+	# x0 += x5, x15 = rotl32(x15 ^ x0, 8)
+	movdqa		0x00(%rsp),%xmm0
+	paddd		%xmm5,%xmm0
+	movdqa		%xmm0,0x00(%rsp)
+	pxor		%xmm0,%xmm15
+	pshufb		%xmm2,%xmm15
+	# x1 += x6, x12 = rotl32(x12 ^ x1, 8)
+	movdqa		0x10(%rsp),%xmm0
+	paddd		%xmm6,%xmm0
+	movdqa		%xmm0,0x10(%rsp)
+	pxor		%xmm0,%xmm12
+	pshufb		%xmm2,%xmm12
+	# x2 += x7, x13 = rotl32(x13 ^ x2, 8)
+	movdqa		0x20(%rsp),%xmm0
+	paddd		%xmm7,%xmm0
+	movdqa		%xmm0,0x20(%rsp)
+	pxor		%xmm0,%xmm13
+	pshufb		%xmm2,%xmm13
+	# x3 += x4, x14 = rotl32(x14 ^ x3, 8)
+	movdqa		0x30(%rsp),%xmm0
+	paddd		%xmm4,%xmm0
+	movdqa		%xmm0,0x30(%rsp)
+	pxor		%xmm0,%xmm14
+	pshufb		%xmm2,%xmm14
+
+	# x10 += x15, x5 = rotl32(x5 ^ x10, 7)
+	paddd		%xmm15,%xmm10
+	pxor		%xmm10,%xmm5
+	movdqa		%xmm5,%xmm0
+	pslld		$7,%xmm0
+	psrld		$25,%xmm5
+	por		%xmm0,%xmm5
+	# x11 += x12, x6 = rotl32(x6 ^ x11, 7)
+	paddd		%xmm12,%xmm11
+	pxor		%xmm11,%xmm6
+	movdqa		%xmm6,%xmm0
+	pslld		$7,%xmm0
+	psrld		$25,%xmm6
+	por		%xmm0,%xmm6
+	# x8 += x13, x7 = rotl32(x7 ^ x8, 7)
+	paddd		%xmm13,%xmm8
+	pxor		%xmm8,%xmm7
+	movdqa		%xmm7,%xmm0
+	pslld		$7,%xmm0
+	psrld		$25,%xmm7
+	por		%xmm0,%xmm7
+	# x9 += x14, x4 = rotl32(x4 ^ x9, 7)
+	paddd		%xmm14,%xmm9
+	pxor		%xmm9,%xmm4
+	movdqa		%xmm4,%xmm0
+	pslld		$7,%xmm0
+	psrld		$25,%xmm4
+	por		%xmm0,%xmm4
+
+	dec		%ecx
+	jnz		.Ldoubleround4
+
+	# x0[0-3] += s0[0]
+	# x1[0-3] += s0[1]
+	movq		0x00(%rdi),%xmm3
+	pshufd		$0x00,%xmm3,%xmm2
+	pshufd		$0x55,%xmm3,%xmm3
+	paddd		0x00(%rsp),%xmm2
+	movdqa		%xmm2,0x00(%rsp)
+	paddd		0x10(%rsp),%xmm3
+	movdqa		%xmm3,0x10(%rsp)
+	# x2[0-3] += s0[2]
+	# x3[0-3] += s0[3]
+	movq		0x08(%rdi),%xmm3
+	pshufd		$0x00,%xmm3,%xmm2
+	pshufd		$0x55,%xmm3,%xmm3
+	paddd		0x20(%rsp),%xmm2
+	movdqa		%xmm2,0x20(%rsp)
+	paddd		0x30(%rsp),%xmm3
+	movdqa		%xmm3,0x30(%rsp)
+
+	# x4[0-3] += s1[0]
+	# x5[0-3] += s1[1]
+	movq		0x10(%rdi),%xmm3
+	pshufd		$0x00,%xmm3,%xmm2
+	pshufd		$0x55,%xmm3,%xmm3
+	paddd		%xmm2,%xmm4
+	paddd		%xmm3,%xmm5
+	# x6[0-3] += s1[2]
+	# x7[0-3] += s1[3]
+	movq		0x18(%rdi),%xmm3
+	pshufd		$0x00,%xmm3,%xmm2
+	pshufd		$0x55,%xmm3,%xmm3
+	paddd		%xmm2,%xmm6
+	paddd		%xmm3,%xmm7
+
+	# x8[0-3] += s2[0]
+	# x9[0-3] += s2[1]
+	movq		0x20(%rdi),%xmm3
+	pshufd		$0x00,%xmm3,%xmm2
+	pshufd		$0x55,%xmm3,%xmm3
+	paddd		%xmm2,%xmm8
+	paddd		%xmm3,%xmm9
+	# x10[0-3] += s2[2]
+	# x11[0-3] += s2[3]
+	movq		0x28(%rdi),%xmm3
+	pshufd		$0x00,%xmm3,%xmm2
+	pshufd		$0x55,%xmm3,%xmm3
+	paddd		%xmm2,%xmm10
+	paddd		%xmm3,%xmm11
+
+	# x12[0-3] += s3[0]
+	# x13[0-3] += s3[1]
+	movq		0x30(%rdi),%xmm3
+	pshufd		$0x00,%xmm3,%xmm2
+	pshufd		$0x55,%xmm3,%xmm3
+	paddd		%xmm2,%xmm12
+	paddd		%xmm3,%xmm13
+	# x14[0-3] += s3[2]
+	# x15[0-3] += s3[3]
+	movq		0x38(%rdi),%xmm3
+	pshufd		$0x00,%xmm3,%xmm2
+	pshufd		$0x55,%xmm3,%xmm3
+	paddd		%xmm2,%xmm14
+	paddd		%xmm3,%xmm15
+
+	# x12 += counter values 0-3
+	paddd		%xmm1,%xmm12
+
+	# interleave 32-bit words in state n, n+1
+	movdqa		0x00(%rsp),%xmm0
+	movdqa		0x10(%rsp),%xmm1
+	movdqa		%xmm0,%xmm2
+	punpckldq	%xmm1,%xmm2
+	punpckhdq	%xmm1,%xmm0
+	movdqa		%xmm2,0x00(%rsp)
+	movdqa		%xmm0,0x10(%rsp)
+	movdqa		0x20(%rsp),%xmm0
+	movdqa		0x30(%rsp),%xmm1
+	movdqa		%xmm0,%xmm2
+	punpckldq	%xmm1,%xmm2
+	punpckhdq	%xmm1,%xmm0
+	movdqa		%xmm2,0x20(%rsp)
+	movdqa		%xmm0,0x30(%rsp)
+	movdqa		%xmm4,%xmm0
+	punpckldq	%xmm5,%xmm4
+	punpckhdq	%xmm5,%xmm0
+	movdqa		%xmm0,%xmm5
+	movdqa		%xmm6,%xmm0
+	punpckldq	%xmm7,%xmm6
+	punpckhdq	%xmm7,%xmm0
+	movdqa		%xmm0,%xmm7
+	movdqa		%xmm8,%xmm0
+	punpckldq	%xmm9,%xmm8
+	punpckhdq	%xmm9,%xmm0
+	movdqa		%xmm0,%xmm9
+	movdqa		%xmm10,%xmm0
+	punpckldq	%xmm11,%xmm10
+	punpckhdq	%xmm11,%xmm0
+	movdqa		%xmm0,%xmm11
+	movdqa		%xmm12,%xmm0
+	punpckldq	%xmm13,%xmm12
+	punpckhdq	%xmm13,%xmm0
+	movdqa		%xmm0,%xmm13
+	movdqa		%xmm14,%xmm0
+	punpckldq	%xmm15,%xmm14
+	punpckhdq	%xmm15,%xmm0
+	movdqa		%xmm0,%xmm15
+
+	# interleave 64-bit words in state n, n+2
+	movdqa		0x00(%rsp),%xmm0
+	movdqa		0x20(%rsp),%xmm1
+	movdqa		%xmm0,%xmm2
+	punpcklqdq	%xmm1,%xmm2
+	punpckhqdq	%xmm1,%xmm0
+	movdqa		%xmm2,0x00(%rsp)
+	movdqa		%xmm0,0x20(%rsp)
+	movdqa		0x10(%rsp),%xmm0
+	movdqa		0x30(%rsp),%xmm1
+	movdqa		%xmm0,%xmm2
+	punpcklqdq	%xmm1,%xmm2
+	punpckhqdq	%xmm1,%xmm0
+	movdqa		%xmm2,0x10(%rsp)
+	movdqa		%xmm0,0x30(%rsp)
+	movdqa		%xmm4,%xmm0
+	punpcklqdq	%xmm6,%xmm4
+	punpckhqdq	%xmm6,%xmm0
+	movdqa		%xmm0,%xmm6
+	movdqa		%xmm5,%xmm0
+	punpcklqdq	%xmm7,%xmm5
+	punpckhqdq	%xmm7,%xmm0
+	movdqa		%xmm0,%xmm7
+	movdqa		%xmm8,%xmm0
+	punpcklqdq	%xmm10,%xmm8
+	punpckhqdq	%xmm10,%xmm0
+	movdqa		%xmm0,%xmm10
+	movdqa		%xmm9,%xmm0
+	punpcklqdq	%xmm11,%xmm9
+	punpckhqdq	%xmm11,%xmm0
+	movdqa		%xmm0,%xmm11
+	movdqa		%xmm12,%xmm0
+	punpcklqdq	%xmm14,%xmm12
+	punpckhqdq	%xmm14,%xmm0
+	movdqa		%xmm0,%xmm14
+	movdqa		%xmm13,%xmm0
+	punpcklqdq	%xmm15,%xmm13
+	punpckhqdq	%xmm15,%xmm0
+	movdqa		%xmm0,%xmm15
+
+	# xor with corresponding input, write to output
+	movdqa		0x00(%rsp),%xmm0
+	movdqu		0x00(%rdx),%xmm1
+	pxor		%xmm1,%xmm0
+	movdqu		%xmm0,0x00(%rsi)
+	movdqa		0x10(%rsp),%xmm0
+	movdqu		0x80(%rdx),%xmm1
+	pxor		%xmm1,%xmm0
+	movdqu		%xmm0,0x80(%rsi)
+	movdqa		0x20(%rsp),%xmm0
+	movdqu		0x40(%rdx),%xmm1
+	pxor		%xmm1,%xmm0
+	movdqu		%xmm0,0x40(%rsi)
+	movdqa		0x30(%rsp),%xmm0
+	movdqu		0xc0(%rdx),%xmm1
+	pxor		%xmm1,%xmm0
+	movdqu		%xmm0,0xc0(%rsi)
+	movdqu		0x10(%rdx),%xmm1
+	pxor		%xmm1,%xmm4
+	movdqu		%xmm4,0x10(%rsi)
+	movdqu		0x90(%rdx),%xmm1
+	pxor		%xmm1,%xmm5
+	movdqu		%xmm5,0x90(%rsi)
+	movdqu		0x50(%rdx),%xmm1
+	pxor		%xmm1,%xmm6
+	movdqu		%xmm6,0x50(%rsi)
+	movdqu		0xd0(%rdx),%xmm1
+	pxor		%xmm1,%xmm7
+	movdqu		%xmm7,0xd0(%rsi)
+	movdqu		0x20(%rdx),%xmm1
+	pxor		%xmm1,%xmm8
+	movdqu		%xmm8,0x20(%rsi)
+	movdqu		0xa0(%rdx),%xmm1
+	pxor		%xmm1,%xmm9
+	movdqu		%xmm9,0xa0(%rsi)
+	movdqu		0x60(%rdx),%xmm1
+	pxor		%xmm1,%xmm10
+	movdqu		%xmm10,0x60(%rsi)
+	movdqu		0xe0(%rdx),%xmm1
+	pxor		%xmm1,%xmm11
+	movdqu		%xmm11,0xe0(%rsi)
+	movdqu		0x30(%rdx),%xmm1
+	pxor		%xmm1,%xmm12
+	movdqu		%xmm12,0x30(%rsi)
+	movdqu		0xb0(%rdx),%xmm1
+	pxor		%xmm1,%xmm13
+	movdqu		%xmm13,0xb0(%rsi)
+	movdqu		0x70(%rdx),%xmm1
+	pxor		%xmm1,%xmm14
+	movdqu		%xmm14,0x70(%rsi)
+	movdqu		0xf0(%rdx),%xmm1
+	pxor		%xmm1,%xmm15
+	movdqu		%xmm15,0xf0(%rsi)
+
+	add		$0x40,%rsp
+	ret
+ENDPROC(chacha20_4block_xor_ssse3)
diff --git a/arch/x86/crypto/chacha20_glue.c b/arch/x86/crypto/chacha20_glue.c
index 250de40..4d677c3 100644
--- a/arch/x86/crypto/chacha20_glue.c
+++ b/arch/x86/crypto/chacha20_glue.c
@@ -20,12 +20,20 @@
 #define CHACHA20_STATE_ALIGN 16
 
 asmlinkage void chacha20_block_xor_ssse3(u32 *state, u8 *dst, const u8 *src);
+asmlinkage void chacha20_4block_xor_ssse3(u32 *state, u8 *dst, const u8 *src);
 
 static void chacha20_dosimd(u32 *state, u8 *dst, const u8 *src,
 			    unsigned int bytes)
 {
 	u8 buf[CHACHA20_BLOCK_SIZE];
 
+	while (bytes >= CHACHA20_BLOCK_SIZE * 4) {
+		chacha20_4block_xor_ssse3(state, dst, src);
+		bytes -= CHACHA20_BLOCK_SIZE * 4;
+		src += CHACHA20_BLOCK_SIZE * 4;
+		dst += CHACHA20_BLOCK_SIZE * 4;
+		state[12] += 4;
+	}
 	while (bytes >= CHACHA20_BLOCK_SIZE) {
 		chacha20_block_xor_ssse3(state, dst, src);
 		bytes -= CHACHA20_BLOCK_SIZE;
-- 
1.9.1
