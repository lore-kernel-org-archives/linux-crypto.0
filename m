Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CC723C8A1;
	Sun,  2 Nov 2025 23:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762127043; cv=none; b=ZYk3lrQp3Szv+a9w3ALhbig/8eUKSql8sysPb9MF2pVhOXoQA7OfrwvHUNtD0VxNGa6fqmprsCuteGHvvJ8jnCZgOoJqr5+R1/aUL13w4Uuk/4EQxEOORKFNVBmNZ50h/SbjDRQBBCZAfhHi8IOiq+FyJi+m7PTOwcp6xBXb/pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762127043; c=relaxed/simple;
	bh=ulGxQA65b9Ah8iXpW7oz06s75Ru03GK8D6CllcJfxuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/k40YVLGPA4bFQkSEuorMPYxilRfs5xdMePa1aUiB3qPnMN03QjoWxRAKL2US0JykhM7yg1yBcZORo0G3pd5+NnhNl8fIykSHVhKD4THHCHn45XbbLQ+zVFs4uJOW0MOYp/YAohCtrPagSC+0boWp83Oa2rhIwUlQhY6Wnbe7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d+bylABq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d+bylABq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9CBC19422;
	Sun,  2 Nov 2025 23:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762127043;
	bh=ulGxQA65b9Ah8iXpW7oz06s75Ru03GK8D6CllcJfxuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d+bylABqZRcKnX36PL0C+kE5HBR+/FnEdOsDtnWu0IzXJpmsc52oLI261no+nQYyR
	 WPB/lAtzNXgQtqkyf/RWUi6qxMtDPmsX5s0BnLkGGBBokuB/hpp5Kp2h3czzyUOOPd
	 nBBztcgYWOXrM3nMpLNxMDwjtGNKlZvbnFCoJluSYrNDR0wZmZantNzbLLOVMp2mua
	 zZnbroDt2RPZ3hjkG6dpx0MRmBrZ4qVlmy/xf1SeVPHjvzPMLQReklF8MjWy1Q7PSg
	 g2MWwC9gS9mPbO9JvRZVmxJ5ToYph42vEOKXUYW2Fgydzi8i0b1HFd/z3urca5WRdb
	 cWVODLbh9GXsw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Samuel Neves <sneves@dei.uc.pt>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 3/6] lib/crypto: x86/blake2s: Use local labels for data
Date: Sun,  2 Nov 2025 15:42:06 -0800
Message-ID: <20251102234209.62133-4-ebiggers@kernel.org>
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

Following the usual practice, prefix the names of the data labels with
".L" so that the assembler treats them as truly local.  This more
clearly expresses the intent and is less error-prone.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/blake2s-core.S | 45 ++++++++++++++++++++---------------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff --git a/lib/crypto/x86/blake2s-core.S b/lib/crypto/x86/blake2s-core.S
index aee13b97cc34..14e487559c09 100644
--- a/lib/crypto/x86/blake2s-core.S
+++ b/lib/crypto/x86/blake2s-core.S
@@ -4,36 +4,43 @@
  * Copyright (C) 2017-2019 Samuel Neves <sneves@dei.uc.pt>. All Rights Reserved.
  */
 
 #include <linux/linkage.h>
 
-.section .rodata.cst32.BLAKE2S_IV, "aM", @progbits, 32
+.section .rodata.cst32.iv, "aM", @progbits, 32
 .align 32
-IV:	.octa 0xA54FF53A3C6EF372BB67AE856A09E667
+.Liv:
+	.octa 0xA54FF53A3C6EF372BB67AE856A09E667
 	.octa 0x5BE0CD191F83D9AB9B05688C510E527F
-.section .rodata.cst16.ROT16, "aM", @progbits, 16
+
+.section .rodata.cst16.ror16, "aM", @progbits, 16
 .align 16
-ROT16:	.octa 0x0D0C0F0E09080B0A0504070601000302
-.section .rodata.cst16.ROR328, "aM", @progbits, 16
+.Lror16:
+	.octa 0x0D0C0F0E09080B0A0504070601000302
+
+.section .rodata.cst16.ror8, "aM", @progbits, 16
 .align 16
-ROR328:	.octa 0x0C0F0E0D080B0A090407060500030201
-.section .rodata.cst64.BLAKE2S_SIGMA, "aM", @progbits, 160
+.Lror8:
+	.octa 0x0C0F0E0D080B0A090407060500030201
+
+.section .rodata.cst64.sigma, "aM", @progbits, 160
 .align 64
-SIGMA:
+.Lsigma:
 .byte  0,  2,  4,  6,  1,  3,  5,  7, 14,  8, 10, 12, 15,  9, 11, 13
 .byte 14,  4,  9, 13, 10,  8, 15,  6,  5,  1,  0, 11,  3, 12,  2,  7
 .byte 11, 12,  5, 15,  8,  0,  2, 13,  9, 10,  3,  7,  4, 14,  6,  1
 .byte  7,  3, 13, 11,  9,  1, 12, 14, 15,  2,  5,  4,  8,  6, 10,  0
 .byte  9,  5,  2, 10,  0,  7,  4, 15,  3, 14, 11,  6, 13,  1, 12,  8
 .byte  2,  6,  0,  8, 12, 10, 11,  3,  1,  4,  7, 15,  9, 13,  5, 14
 .byte 12,  1, 14,  4,  5, 15, 13, 10,  8,  0,  6,  9, 11,  7,  3,  2
 .byte 13,  7, 12,  3, 11, 14,  1,  9,  2,  5, 15,  8, 10,  0,  4,  6
 .byte  6, 14, 11,  0, 15,  9,  3,  8, 10, 12, 13,  1,  5,  2,  7,  4
 .byte 10,  8,  7,  1,  2,  4,  6,  5, 13, 15,  9,  3,  0, 11, 14, 12
-.section .rodata.cst64.BLAKE2S_SIGMA2, "aM", @progbits, 160
+
+.section .rodata.cst64.sigma2, "aM", @progbits, 160
 .align 64
-SIGMA2:
+.Lsigma2:
 .byte  0,  2,  4,  6,  1,  3,  5,  7, 14,  8, 10, 12, 15,  9, 11, 13
 .byte  8,  2, 13, 15, 10,  9, 12,  3,  6,  4,  0, 14,  5, 11,  1,  7
 .byte 11, 13,  8,  6,  5, 10, 14,  3,  2,  4, 12, 15,  1,  0,  7,  9
 .byte 11, 10,  7,  0,  8, 15,  1, 13,  3,  6,  2, 12,  4, 14,  9,  5
 .byte  4, 10,  9, 14, 15,  0, 11,  8,  1,  7,  3, 13,  2,  5,  6, 12
@@ -45,25 +52,25 @@ SIGMA2:
 
 .text
 SYM_FUNC_START(blake2s_compress_ssse3)
 	movdqu		(%rdi),%xmm0
 	movdqu		0x10(%rdi),%xmm1
-	movdqa		ROT16(%rip),%xmm12
-	movdqa		ROR328(%rip),%xmm13
+	movdqa		.Lror16(%rip),%xmm12
+	movdqa		.Lror8(%rip),%xmm13
 	movdqu		0x20(%rdi),%xmm14
 	movd		%ecx,%xmm15
-	leaq		SIGMA+0xa0(%rip),%r8
+	leaq		.Lsigma+0xa0(%rip),%r8
 	jmp		.Lbeginofloop
 	.align		32
 .Lbeginofloop:
 	movdqa		%xmm0,%xmm10
 	movdqa		%xmm1,%xmm11
 	paddq		%xmm15,%xmm14
-	movdqa		IV(%rip),%xmm2
+	movdqa		.Liv(%rip),%xmm2
 	movdqa		%xmm14,%xmm3
-	pxor		IV+0x10(%rip),%xmm3
-	leaq		SIGMA(%rip),%rcx
+	pxor		.Liv+0x10(%rip),%xmm3
+	leaq		.Lsigma(%rip),%rcx
 .Lroundloop:
 	movzbl		(%rcx),%eax
 	movd		(%rsi,%rax,4),%xmm4
 	movzbl		0x1(%rcx),%eax
 	movd		(%rsi,%rax,4),%xmm5
@@ -172,12 +179,12 @@ SYM_FUNC_END(blake2s_compress_ssse3)
 SYM_FUNC_START(blake2s_compress_avx512)
 	vmovdqu		(%rdi),%xmm0
 	vmovdqu		0x10(%rdi),%xmm1
 	vmovdqu		0x20(%rdi),%xmm4
 	vmovd		%ecx,%xmm5
-	vmovdqa		IV(%rip),%xmm14
-	vmovdqa		IV+16(%rip),%xmm15
+	vmovdqa		.Liv(%rip),%xmm14
+	vmovdqa		.Liv+16(%rip),%xmm15
 	jmp		.Lblake2s_compress_avx512_mainloop
 .align 32
 .Lblake2s_compress_avx512_mainloop:
 	vmovdqa		%xmm0,%xmm10
 	vmovdqa		%xmm1,%xmm11
@@ -185,11 +192,11 @@ SYM_FUNC_START(blake2s_compress_avx512)
 	vmovdqa		%xmm14,%xmm2
 	vpxor		%xmm15,%xmm4,%xmm3
 	vmovdqu		(%rsi),%ymm6
 	vmovdqu		0x20(%rsi),%ymm7
 	addq		$0x40,%rsi
-	leaq		SIGMA2(%rip),%rax
+	leaq		.Lsigma2(%rip),%rax
 	movb		$0xa,%cl
 .Lblake2s_compress_avx512_roundloop:
 	vpmovzxbd	(%rax),%ymm8
 	vpmovzxbd	0x8(%rax),%ymm9
 	addq		$0x10,%rax
-- 
2.51.2

