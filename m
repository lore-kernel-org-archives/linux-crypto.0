Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2D825A63D;
	Sun,  2 Nov 2025 23:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762127046; cv=none; b=DuNkrY2tCVpKC59xQRGjQR+WKQgEZti4TJj7Ah0IbGAlqNi50ep8xyftg6FKkcamnYxrow4DJoeUeLoBB0kBCGAPPsIoerP6z3lRAEmstyaZXedDvc9QUey9LW1Y/wVIhkPtkHLGph21qTR0VixefVjA48VgwyvrlUotQ8GpXog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762127046; c=relaxed/simple;
	bh=51qIKkW5HOnlBeN2ABSyez+jNgIlah/y7uNFW97oB4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5KMt31ofAYb0oCkshjIAiSobcIecD4G+wNKk1mzbIrWIGhguchl555Rds02YD2trEP0+K+kDIubvljY1oMmfpGfrGwQF93wYZkqlmXlTOhc0dmL64z8ikFA2X2K7rPRX8v97aDppgsVghi7fqdRfQNoM2Sko/75yQ9LP0zhx3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N4WlSSKr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N4WlSSKr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D24C116B1;
	Sun,  2 Nov 2025 23:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762127044;
	bh=51qIKkW5HOnlBeN2ABSyez+jNgIlah/y7uNFW97oB4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N4WlSSKrJKO1O1riujpcl5kKgV6PxdxxN27kNKgUsK5+ILrgGJgyaJ1mD3fyNKDBo
	 s5KnCVUMb4r2Vtp1o1B3CGB9HcePuSUJ3VW6xj/d7VFVEzQCS+kFwaHwUWs2kMa3iw
	 Bv1VQLsG/y1jGOFIPaBihlNS5VEYCFDDDYnbmqK518aUyykN9ZRBKcXqmWrcZ+Fdb2
	 63ANv1LJU9D4nU8lDdGR0nE4CcyHAnq57DlGPADBF//Pb/otSbxv56CWenC36fwEKy
	 wI5IZaigdAyMLkBbvnXezvyjLWJF7rbuJ/i5M5VK06ZbIIMZhimo5TqD8hXG2vS8qz
	 7c5pDukr87Q4w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Samuel Neves <sneves@dei.uc.pt>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 4/6] lib/crypto: x86/blake2s: Improve readability
Date: Sun,  2 Nov 2025 15:42:07 -0800
Message-ID: <20251102234209.62133-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251102234209.62133-1-ebiggers@kernel.org>
References: <20251102234209.62133-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Various cleanups for readability.  No change to the generated code:

- Add some comments
- Add #defines for arguments
- Rename some labels
- Use decimal constants instead of hex where it makes sense.
  (The pshufd immediates intentionally remain as hex.)
- Add blank lines when there's a logical break

The round loop still could use some work, but this is at least a start.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/blake2s-core.S | 231 ++++++++++++++++++++--------------
 1 file changed, 134 insertions(+), 97 deletions(-)

diff --git a/lib/crypto/x86/blake2s-core.S b/lib/crypto/x86/blake2s-core.S
index 14e487559c09..f805a49c590d 100644
--- a/lib/crypto/x86/blake2s-core.S
+++ b/lib/crypto/x86/blake2s-core.S
@@ -48,209 +48,246 @@
 .byte  4,  8, 15,  9, 14, 11, 13,  5,  3,  2,  1, 12,  6, 10,  7,  0
 .byte  6, 13,  0, 14, 12,  2,  1, 11, 15,  4,  5,  8,  7,  9,  3, 10
 .byte 15,  5,  4, 13, 10,  7,  3, 11, 12,  2,  0,  6,  9,  8,  1, 14
 .byte  8,  7, 14, 11, 13, 15,  0, 12, 10,  4,  5,  6,  3,  2,  1,  9
 
+#define CTX		%rdi
+#define DATA		%rsi
+#define NBLOCKS		%rdx
+#define INC		%ecx
+
 .text
+//
+// void blake2s_compress_ssse3(struct blake2s_ctx *ctx,
+//			       const u8 *data, size_t nblocks, u32 inc);
+//
+// Only the first three fields of struct blake2s_ctx are used:
+//	u32 h[8];	(inout)
+//	u32 t[2];	(inout)
+//	u32 f[2];	(in)
+//
 SYM_FUNC_START(blake2s_compress_ssse3)
-	movdqu		(%rdi),%xmm0
-	movdqu		0x10(%rdi),%xmm1
+	movdqu		(CTX),%xmm0		// Load h[0..3]
+	movdqu		16(CTX),%xmm1		// Load h[4..7]
 	movdqa		.Lror16(%rip),%xmm12
 	movdqa		.Lror8(%rip),%xmm13
-	movdqu		0x20(%rdi),%xmm14
-	movd		%ecx,%xmm15
-	leaq		.Lsigma+0xa0(%rip),%r8
-	jmp		.Lbeginofloop
+	movdqu		32(CTX),%xmm14		// Load t and f
+	movd		INC,%xmm15		// Load inc
+	leaq		.Lsigma+160(%rip),%r8
+	jmp		.Lssse3_mainloop
+
 	.align		32
-.Lbeginofloop:
-	movdqa		%xmm0,%xmm10
-	movdqa		%xmm1,%xmm11
-	paddq		%xmm15,%xmm14
-	movdqa		.Liv(%rip),%xmm2
+.Lssse3_mainloop:
+	// Main loop: each iteration processes one 64-byte block.
+	movdqa		%xmm0,%xmm10		// Save h[0..3] and let v[0..3] = h[0..3]
+	movdqa		%xmm1,%xmm11		// Save h[4..7] and let v[4..7] = h[4..7]
+	paddq		%xmm15,%xmm14		// t += inc (64-bit addition)
+	movdqa		.Liv(%rip),%xmm2	// v[8..11] = iv[0..3]
 	movdqa		%xmm14,%xmm3
-	pxor		.Liv+0x10(%rip),%xmm3
+	pxor		.Liv+16(%rip),%xmm3	// v[12..15] = iv[4..7] ^ [t, f]
 	leaq		.Lsigma(%rip),%rcx
-.Lroundloop:
+
+.Lssse3_roundloop:
+	// Round loop: each iteration does 1 round (of 10 rounds total).
 	movzbl		(%rcx),%eax
-	movd		(%rsi,%rax,4),%xmm4
-	movzbl		0x1(%rcx),%eax
-	movd		(%rsi,%rax,4),%xmm5
-	movzbl		0x2(%rcx),%eax
-	movd		(%rsi,%rax,4),%xmm6
-	movzbl		0x3(%rcx),%eax
-	movd		(%rsi,%rax,4),%xmm7
+	movd		(DATA,%rax,4),%xmm4
+	movzbl		1(%rcx),%eax
+	movd		(DATA,%rax,4),%xmm5
+	movzbl		2(%rcx),%eax
+	movd		(DATA,%rax,4),%xmm6
+	movzbl		3(%rcx),%eax
+	movd		(DATA,%rax,4),%xmm7
 	punpckldq	%xmm5,%xmm4
 	punpckldq	%xmm7,%xmm6
 	punpcklqdq	%xmm6,%xmm4
 	paddd		%xmm4,%xmm0
 	paddd		%xmm1,%xmm0
 	pxor		%xmm0,%xmm3
 	pshufb		%xmm12,%xmm3
 	paddd		%xmm3,%xmm2
 	pxor		%xmm2,%xmm1
 	movdqa		%xmm1,%xmm8
-	psrld		$0xc,%xmm1
-	pslld		$0x14,%xmm8
+	psrld		$12,%xmm1
+	pslld		$20,%xmm8
 	por		%xmm8,%xmm1
-	movzbl		0x4(%rcx),%eax
-	movd		(%rsi,%rax,4),%xmm5
-	movzbl		0x5(%rcx),%eax
-	movd		(%rsi,%rax,4),%xmm6
-	movzbl		0x6(%rcx),%eax
-	movd		(%rsi,%rax,4),%xmm7
-	movzbl		0x7(%rcx),%eax
-	movd		(%rsi,%rax,4),%xmm4
+	movzbl		4(%rcx),%eax
+	movd		(DATA,%rax,4),%xmm5
+	movzbl		5(%rcx),%eax
+	movd		(DATA,%rax,4),%xmm6
+	movzbl		6(%rcx),%eax
+	movd		(DATA,%rax,4),%xmm7
+	movzbl		7(%rcx),%eax
+	movd		(DATA,%rax,4),%xmm4
 	punpckldq	%xmm6,%xmm5
 	punpckldq	%xmm4,%xmm7
 	punpcklqdq	%xmm7,%xmm5
 	paddd		%xmm5,%xmm0
 	paddd		%xmm1,%xmm0
 	pxor		%xmm0,%xmm3
 	pshufb		%xmm13,%xmm3
 	paddd		%xmm3,%xmm2
 	pxor		%xmm2,%xmm1
 	movdqa		%xmm1,%xmm8
-	psrld		$0x7,%xmm1
-	pslld		$0x19,%xmm8
+	psrld		$7,%xmm1
+	pslld		$25,%xmm8
 	por		%xmm8,%xmm1
 	pshufd		$0x93,%xmm0,%xmm0
 	pshufd		$0x4e,%xmm3,%xmm3
 	pshufd		$0x39,%xmm2,%xmm2
-	movzbl		0x8(%rcx),%eax
-	movd		(%rsi,%rax,4),%xmm6
-	movzbl		0x9(%rcx),%eax
-	movd		(%rsi,%rax,4),%xmm7
-	movzbl		0xa(%rcx),%eax
-	movd		(%rsi,%rax,4),%xmm4
-	movzbl		0xb(%rcx),%eax
-	movd		(%rsi,%rax,4),%xmm5
+	movzbl		8(%rcx),%eax
+	movd		(DATA,%rax,4),%xmm6
+	movzbl		9(%rcx),%eax
+	movd		(DATA,%rax,4),%xmm7
+	movzbl		10(%rcx),%eax
+	movd		(DATA,%rax,4),%xmm4
+	movzbl		11(%rcx),%eax
+	movd		(DATA,%rax,4),%xmm5
 	punpckldq	%xmm7,%xmm6
 	punpckldq	%xmm5,%xmm4
 	punpcklqdq	%xmm4,%xmm6
 	paddd		%xmm6,%xmm0
 	paddd		%xmm1,%xmm0
 	pxor		%xmm0,%xmm3
 	pshufb		%xmm12,%xmm3
 	paddd		%xmm3,%xmm2
 	pxor		%xmm2,%xmm1
 	movdqa		%xmm1,%xmm8
-	psrld		$0xc,%xmm1
-	pslld		$0x14,%xmm8
+	psrld		$12,%xmm1
+	pslld		$20,%xmm8
 	por		%xmm8,%xmm1
-	movzbl		0xc(%rcx),%eax
-	movd		(%rsi,%rax,4),%xmm7
-	movzbl		0xd(%rcx),%eax
-	movd		(%rsi,%rax,4),%xmm4
-	movzbl		0xe(%rcx),%eax
-	movd		(%rsi,%rax,4),%xmm5
-	movzbl		0xf(%rcx),%eax
-	movd		(%rsi,%rax,4),%xmm6
+	movzbl		12(%rcx),%eax
+	movd		(DATA,%rax,4),%xmm7
+	movzbl		13(%rcx),%eax
+	movd		(DATA,%rax,4),%xmm4
+	movzbl		14(%rcx),%eax
+	movd		(DATA,%rax,4),%xmm5
+	movzbl		15(%rcx),%eax
+	movd		(DATA,%rax,4),%xmm6
 	punpckldq	%xmm4,%xmm7
 	punpckldq	%xmm6,%xmm5
 	punpcklqdq	%xmm5,%xmm7
 	paddd		%xmm7,%xmm0
 	paddd		%xmm1,%xmm0
 	pxor		%xmm0,%xmm3
 	pshufb		%xmm13,%xmm3
 	paddd		%xmm3,%xmm2
 	pxor		%xmm2,%xmm1
 	movdqa		%xmm1,%xmm8
-	psrld		$0x7,%xmm1
-	pslld		$0x19,%xmm8
+	psrld		$7,%xmm1
+	pslld		$25,%xmm8
 	por		%xmm8,%xmm1
 	pshufd		$0x39,%xmm0,%xmm0
 	pshufd		$0x4e,%xmm3,%xmm3
 	pshufd		$0x93,%xmm2,%xmm2
-	addq		$0x10,%rcx
+	addq		$16,%rcx
 	cmpq		%r8,%rcx
-	jnz		.Lroundloop
+	jnz		.Lssse3_roundloop
+
+	// Compute the new h: h[0..7] ^= v[0..7] ^ v[8..15]
 	pxor		%xmm2,%xmm0
 	pxor		%xmm3,%xmm1
 	pxor		%xmm10,%xmm0
 	pxor		%xmm11,%xmm1
-	addq		$0x40,%rsi
-	decq		%rdx
-	jnz		.Lbeginofloop
-	movdqu		%xmm0,(%rdi)
-	movdqu		%xmm1,0x10(%rdi)
-	movdqu		%xmm14,0x20(%rdi)
+	addq		$64,DATA
+	decq		NBLOCKS
+	jnz		.Lssse3_mainloop
+
+	movdqu		%xmm0,(CTX)		// Store new h[0..3]
+	movdqu		%xmm1,16(CTX)		// Store new h[4..7]
+	movdqu		%xmm14,32(CTX)		// Store new t and f
 	RET
 SYM_FUNC_END(blake2s_compress_ssse3)
 
+//
+// void blake2s_compress_avx512(struct blake2s_ctx *ctx,
+//				const u8 *data, size_t nblocks, u32 inc);
+//
+// Only the first three fields of struct blake2s_ctx are used:
+//	u32 h[8];	(inout)
+//	u32 t[2];	(inout)
+//	u32 f[2];	(in)
+//
 SYM_FUNC_START(blake2s_compress_avx512)
-	vmovdqu		(%rdi),%xmm0
-	vmovdqu		0x10(%rdi),%xmm1
-	vmovdqu		0x20(%rdi),%xmm4
-	vmovd		%ecx,%xmm5
-	vmovdqa		.Liv(%rip),%xmm14
-	vmovdqa		.Liv+16(%rip),%xmm15
-	jmp		.Lblake2s_compress_avx512_mainloop
-.align 32
-.Lblake2s_compress_avx512_mainloop:
-	vmovdqa		%xmm0,%xmm10
-	vmovdqa		%xmm1,%xmm11
-	vpaddq		%xmm5,%xmm4,%xmm4
-	vmovdqa		%xmm14,%xmm2
-	vpxor		%xmm15,%xmm4,%xmm3
-	vmovdqu		(%rsi),%ymm6
-	vmovdqu		0x20(%rsi),%ymm7
-	addq		$0x40,%rsi
+	vmovdqu		(CTX),%xmm0		// Load h[0..3]
+	vmovdqu		16(CTX),%xmm1		// Load h[4..7]
+	vmovdqu		32(CTX),%xmm4		// Load t and f
+	vmovd		INC,%xmm5		// Load inc
+	vmovdqa		.Liv(%rip),%xmm14	// Load iv[0..3]
+	vmovdqa		.Liv+16(%rip),%xmm15	// Load iv[4..7]
+	jmp		.Lavx512_mainloop
+
+	.align		32
+.Lavx512_mainloop:
+	// Main loop: each iteration processes one 64-byte block.
+	vmovdqa		%xmm0,%xmm10		// Save h[0..3] and let v[0..3] = h[0..3]
+	vmovdqa		%xmm1,%xmm11		// Save h[4..7] and let v[4..7] = h[4..7]
+	vpaddq		%xmm5,%xmm4,%xmm4	// t += inc (64-bit addition)
+	vmovdqa		%xmm14,%xmm2		// v[8..11] = iv[0..3]
+	vpxor		%xmm15,%xmm4,%xmm3	// v[12..15] = iv[4..7] ^ [t, f]
+	vmovdqu		(DATA),%ymm6		// Load first 8 data words
+	vmovdqu		32(DATA),%ymm7		// Load second 8 data words
+	addq		$64,DATA
 	leaq		.Lsigma2(%rip),%rax
-	movb		$0xa,%cl
-.Lblake2s_compress_avx512_roundloop:
+	movb		$10,%cl			// Set num rounds remaining
+
+.Lavx512_roundloop:
+	// Round loop: each iteration does 1 round (of 10 rounds total).
 	vpmovzxbd	(%rax),%ymm8
-	vpmovzxbd	0x8(%rax),%ymm9
-	addq		$0x10,%rax
+	vpmovzxbd	8(%rax),%ymm9
+	addq		$16,%rax
 	vpermi2d	%ymm7,%ymm6,%ymm8
 	vpermi2d	%ymm7,%ymm6,%ymm9
 	vmovdqa		%ymm8,%ymm6
 	vmovdqa		%ymm9,%ymm7
 	vpaddd		%xmm8,%xmm0,%xmm0
 	vpaddd		%xmm1,%xmm0,%xmm0
 	vpxor		%xmm0,%xmm3,%xmm3
-	vprord		$0x10,%xmm3,%xmm3
+	vprord		$16,%xmm3,%xmm3
 	vpaddd		%xmm3,%xmm2,%xmm2
 	vpxor		%xmm2,%xmm1,%xmm1
-	vprord		$0xc,%xmm1,%xmm1
-	vextracti128	$0x1,%ymm8,%xmm8
+	vprord		$12,%xmm1,%xmm1
+	vextracti128	$1,%ymm8,%xmm8
 	vpaddd		%xmm8,%xmm0,%xmm0
 	vpaddd		%xmm1,%xmm0,%xmm0
 	vpxor		%xmm0,%xmm3,%xmm3
-	vprord		$0x8,%xmm3,%xmm3
+	vprord		$8,%xmm3,%xmm3
 	vpaddd		%xmm3,%xmm2,%xmm2
 	vpxor		%xmm2,%xmm1,%xmm1
-	vprord		$0x7,%xmm1,%xmm1
+	vprord		$7,%xmm1,%xmm1
 	vpshufd		$0x93,%xmm0,%xmm0
 	vpshufd		$0x4e,%xmm3,%xmm3
 	vpshufd		$0x39,%xmm2,%xmm2
 	vpaddd		%xmm9,%xmm0,%xmm0
 	vpaddd		%xmm1,%xmm0,%xmm0
 	vpxor		%xmm0,%xmm3,%xmm3
-	vprord		$0x10,%xmm3,%xmm3
+	vprord		$16,%xmm3,%xmm3
 	vpaddd		%xmm3,%xmm2,%xmm2
 	vpxor		%xmm2,%xmm1,%xmm1
-	vprord		$0xc,%xmm1,%xmm1
-	vextracti128	$0x1,%ymm9,%xmm9
+	vprord		$12,%xmm1,%xmm1
+	vextracti128	$1,%ymm9,%xmm9
 	vpaddd		%xmm9,%xmm0,%xmm0
 	vpaddd		%xmm1,%xmm0,%xmm0
 	vpxor		%xmm0,%xmm3,%xmm3
-	vprord		$0x8,%xmm3,%xmm3
+	vprord		$8,%xmm3,%xmm3
 	vpaddd		%xmm3,%xmm2,%xmm2
 	vpxor		%xmm2,%xmm1,%xmm1
-	vprord		$0x7,%xmm1,%xmm1
+	vprord		$7,%xmm1,%xmm1
 	vpshufd		$0x39,%xmm0,%xmm0
 	vpshufd		$0x4e,%xmm3,%xmm3
 	vpshufd		$0x93,%xmm2,%xmm2
 	decb		%cl
-	jne		.Lblake2s_compress_avx512_roundloop
+	jne		.Lavx512_roundloop
+
+	// Compute the new h: h[0..7] ^= v[0..7] ^ v[8..15]
 	vpxor		%xmm10,%xmm0,%xmm0
 	vpxor		%xmm11,%xmm1,%xmm1
 	vpxor		%xmm2,%xmm0,%xmm0
 	vpxor		%xmm3,%xmm1,%xmm1
-	decq		%rdx
-	jne		.Lblake2s_compress_avx512_mainloop
-	vmovdqu		%xmm0,(%rdi)
-	vmovdqu		%xmm1,0x10(%rdi)
-	vmovdqu		%xmm4,0x20(%rdi)
+	decq		NBLOCKS
+	jne		.Lavx512_mainloop
+
+	vmovdqu		%xmm0,(CTX)		// Store new h[0..3]
+	vmovdqu		%xmm1,16(CTX)		// Store new h[4..7]
+	vmovdqu		%xmm4,32(CTX)		// Store new t and f
 	vzeroupper
 	RET
 SYM_FUNC_END(blake2s_compress_avx512)
-- 
2.51.2

