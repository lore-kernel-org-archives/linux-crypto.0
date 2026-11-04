Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793832947;
	b=3Wm/M8OKqfRlbRyFmWVh9k/7piyxPZTttm9jrOUOAP7DVX4OdqbLIoZ5NoKtbBKHauhk
	 D2BbNidgUBGlAWDgJFOLy3zY6kwf4rT6IYp3FqD9sCBJSU6yh2NczoYJFNCURD+GYzygv
	 6Ctt52GJUawiATbPvXnuo8qcv4YKMlTRHHrmDZB2Ucwmo7KXx50DxfqV7FoYUQgLf+BZC
	 tvzdva94yxbRgkiY+zO2+dRn2sptUJ4x5ij3UcwpctZSOGMGiLqgRtm1RrodKyfQiamFK
	 4kdlOehgO5SqdI+/hXYTINg1NXIj+X5W/X81114/28/kqaY8NG8E7J2Icg92ds7Qotw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793832947;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ev1UXGGIYtELObftQs7EnnMQ4ucJsaG/h5eEvTkCAas=;
	b=dYsiVdJz9723oa3xezG27Y72Wmxz7cHqoYx00XKmgKTDw5Mlxyf2rrh5Y/9KM6A2tD/o
	 Jrjd+HrGhYl81JBGYyv0Bj3rrBk6zsLAwguI28fAyZJfbHHJc5TJmTvGlxmKBLQqZa+fz
	 qQ6fvCw9kxH2pcLkamF03R8oqynf5H6zQRC/ePdxrR7ZmBejXB2QhZP/ozL+3mjLQehjh
	 jU2HNWLjZm8/MFAoYBeXXxVQGqWBi2a66x5/lXYx8+v93jd40LWZSyY91MK/OkFK9a+Si
	 hRTiuCO7px0s/pdHs0WFfyNk/5jkR5x5fbPadtZdewfgnWW/QjHfC4+C71+44UyVePA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IS2DsbBF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA8B606A31B
	for <linux-crypto@vger.kernel.org>; Wed,  4 Nov 2026 22:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IS2DsbBF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A0A91F000C1;
	Wed,  4 Nov 2026 22:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793832946;
	bh=ev1UXGGIYtELObftQs7EnnMQ4ucJsaG/h5eEvTkCAas=;
	h=From:To:Cc:Subject:Date;
	b=IS2DsbBFxlJ9Scl3s0DGmCkBo7uYWZfLxOJ1THiYsx3fA35A5y198Lt86XTSAoFtO
	 HT4uH59YR87zHVo8PPpzr9mdaKzq4pCxKfWVS42rYKyYMkmG359Xrn2zcqVlzsovEa
	 3+mGbn1by4i9RbSUEZqUXMvf3OZudXxYtA1y4PVYeXRw8+I1OdJd+jVw4VsxmaKaEJ
	 tlDLrfOcT8VvlSn/uSbiN8d9Q8J2rET5sJYg8dVvbPD6Iqd1IWI812PdeSKPsfm74h
	 3N0Jhhvmsyhm93yUoiuOniq7BNUCvP2rbSP6dZRRCysOjidj22Cqv3Pp7mr56Urvpw
	 /hYqEqHNtJFkA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Martin Willi <martin@strongswan.org>,
	Antonio Quartulli <antonio@mandelbit.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: x86/chacha: Eliminate more never-taken branches
Date: Wed,  4 Nov 2026 14:55:26 -0800
Message-ID: <20261104225526.68557-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The x86_64 optimized ChaCha code has assembly functions that generate 1,
2, 4, 8, or 16 keystream blocks and XOR them with up to that number of
data blocks.

However, to avoid unnecessary overhead, the 4, 8, and 16-block
functions, and the AVX2 2-block function, are never called with a length
that is supported by the next-smaller function (that is, <= N/2 blocks,
or <= 1 block for the SSSE3 4-block function), since a smaller function
is called to handle such cases instead.

As a result, all the branches in those assembly functions that handle
XOR'ing fewer than that minimum number of data blocks are dead code.

Remove these branches to eliminate dead code and overhead.  Also rename
the assembly functions to make it clear which cases they handle.

Some register moves in chacha_1to4blocks_ssse3() are also eliminated, as
they were needed only because of the support for less than 1 block.

Note: many of the functions could use exclusive rather than inclusive
lower bounds.  Inclusive is used for simplicity.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/chacha-avx2-x86_64.S   | 73 +++++++--------------
 lib/crypto/x86/chacha-avx512-x86_64.S | 94 +++++++++------------------
 lib/crypto/x86/chacha-ssse3-x86_64.S  | 51 ++++++---------
 lib/crypto/x86/chacha.h               | 72 +++++++++++++-------
 4 files changed, 119 insertions(+), 171 deletions(-)

diff --git a/lib/crypto/x86/chacha-avx2-x86_64.S b/lib/crypto/x86/chacha-avx2-x86_64.S
index 8179a04a3027..18ae03e05074 100644
--- a/lib/crypto/x86/chacha-avx2-x86_64.S
+++ b/lib/crypto/x86/chacha-avx2-x86_64.S
@@ -34,11 +34,11 @@ CTR4BL:	.octa 0x00000000000000000000000000000002
 
 .text
 
-SYM_FUNC_START(chacha_2block_xor_avx2)
+SYM_FUNC_START(chacha_1to2blocks_avx2)
 	# %rdi: Input state matrix, s
-	# %rsi: up to 2 data blocks output, o
-	# %rdx: up to 2 data blocks input, i
-	# %rcx: input/output length in bytes
+	# %rsi: output data, o
+	# %rdx: input data, i
+	# %rcx: input/output data length in bytes: 1 to 2 blocks inclusive
 	# %r8d: nrounds
 
 	# This function encrypts two ChaCha blocks by loading the state
@@ -141,20 +141,16 @@ SYM_FUNC_START(chacha_2block_xor_avx2)
 	vpaddd		%ymm10,%ymm2,%ymm2
 	vpaddd		%ymm11,%ymm3,%ymm3
 
-	# xor the data with the keystream
-
+	# XOR the first data block with the generated keystream.
 	vperm2i128	$0x20, %ymm1, %ymm0, %ymm4
-	cmp		$1*32,%rax
-	jl		.Lxorpart2
 	vpxor		0*32(%rdx),%ymm4,%ymm4
 	vmovdqu		%ymm4,0*32(%rsi)
 
 	vperm2i128	$0x20, %ymm3, %ymm2, %ymm4
-	cmp		$2*32,%rax
-	jl		.Lxorpart2
 	vpxor		1*32(%rdx),%ymm4,%ymm4
 	vmovdqu		%ymm4,1*32(%rsi)
 
+	# XOR up to 1 additional data block with the generated keystream.
 	vperm2i128	$0x31, %ymm1, %ymm0, %ymm4
 	cmp		$3*32,%rax
 	jl		.Lxorpart2
@@ -200,13 +196,13 @@ SYM_FUNC_START(chacha_2block_xor_avx2)
 	lea		-8(%r10),%rsp
 	jmp		.Ldone2
 
-SYM_FUNC_END(chacha_2block_xor_avx2)
+SYM_FUNC_END(chacha_1to2blocks_avx2)
 
-SYM_FUNC_START(chacha_4block_xor_avx2)
+SYM_FUNC_START(chacha_2to4blocks_avx2)
 	# %rdi: Input state matrix, s
-	# %rsi: up to 4 data blocks output, o
-	# %rdx: up to 4 data blocks input, i
-	# %rcx: input/output length in bytes
+	# %rsi: output data, o
+	# %rdx: input data, i
+	# %rcx: input/output data length in bytes: 2 to 4 blocks inclusive
 	# %r8d: nrounds
 
 	# This function encrypts four ChaCha blocks by loading the state
@@ -372,32 +368,24 @@ SYM_FUNC_START(chacha_4block_xor_avx2)
 	vpaddd		%ymm13,%ymm6,%ymm6
 	vpaddd		%ymm15,%ymm7,%ymm7
 
-	# xor the data with the keystream
-
+	# XOR the first 2 data blocks with the generated keystream.
 	vperm2i128	$0x20, %ymm1, %ymm0, %ymm8
-	cmp		$1*32,%rax
-	jl		.Lxorpart4
 	vpxor		0*32(%rdx),%ymm8,%ymm8
 	vmovdqu		%ymm8,0*32(%rsi)
 
 	vperm2i128	$0x20, %ymm3, %ymm2, %ymm8
-	cmp		$2*32,%rax
-	jl		.Lxorpart4
 	vpxor		1*32(%rdx),%ymm8,%ymm8
 	vmovdqu		%ymm8,1*32(%rsi)
 
 	vperm2i128	$0x31, %ymm1, %ymm0, %ymm8
-	cmp		$3*32,%rax
-	jl		.Lxorpart4
 	vpxor		2*32(%rdx),%ymm8,%ymm8
 	vmovdqu		%ymm8,2*32(%rsi)
 
 	vperm2i128	$0x31, %ymm3, %ymm2, %ymm8
-	cmp		$4*32,%rax
-	jl		.Lxorpart4
 	vpxor		3*32(%rdx),%ymm8,%ymm8
 	vmovdqu		%ymm8,3*32(%rsi)
 
+	# XOR up to 2 additional data blocks with the generated keystream.
 	vperm2i128	$0x20, %ymm5, %ymm4, %ymm8
 	cmp		$5*32,%rax
 	jl		.Lxorpart4
@@ -455,13 +443,13 @@ SYM_FUNC_START(chacha_4block_xor_avx2)
 	lea		-8(%r10),%rsp
 	jmp		.Ldone4
 
-SYM_FUNC_END(chacha_4block_xor_avx2)
+SYM_FUNC_END(chacha_2to4blocks_avx2)
 
-SYM_FUNC_START(chacha_8block_xor_avx2)
+SYM_FUNC_START(chacha_4to8blocks_avx2)
 	# %rdi: Input state matrix, s
-	# %rsi: up to 8 data blocks output, o
-	# %rdx: up to 8 data blocks input, i
-	# %rcx: input/output length in bytes
+	# %rsi: output data, o
+	# %rdx: input data, i
+	# %rcx: input/output data length in bytes: 4 to 8 blocks inclusive
 	# %r8d: nrounds
 
 	# This function encrypts eight consecutive ChaCha blocks by loading
@@ -803,69 +791,54 @@ SYM_FUNC_START(chacha_8block_xor_avx2)
 	vpunpcklqdq	%ymm15,%ymm0,%ymm13
 	vpunpckhqdq	%ymm15,%ymm0,%ymm15
 
-	# interleave 128-bit words in state n, n+4
-	# xor/write first four blocks
+	# Do the final 128-bit interleave within the XOR sequence.
+
+	# XOR the first 4 data blocks with the generated keystream.
 	vmovdqa		0x00(%rsp),%ymm1
 	vperm2i128	$0x20,%ymm4,%ymm1,%ymm0
-	cmp		$0x0020,%rax
-	jl		.Lxorpart8
 	vpxor		0x0000(%rdx),%ymm0,%ymm0
 	vmovdqu		%ymm0,0x0000(%rsi)
 	vperm2i128	$0x31,%ymm4,%ymm1,%ymm4
 
 	vperm2i128	$0x20,%ymm12,%ymm8,%ymm0
-	cmp		$0x0040,%rax
-	jl		.Lxorpart8
 	vpxor		0x0020(%rdx),%ymm0,%ymm0
 	vmovdqu		%ymm0,0x0020(%rsi)
 	vperm2i128	$0x31,%ymm12,%ymm8,%ymm12
 
 	vmovdqa		0x40(%rsp),%ymm1
 	vperm2i128	$0x20,%ymm6,%ymm1,%ymm0
-	cmp		$0x0060,%rax
-	jl		.Lxorpart8
 	vpxor		0x0040(%rdx),%ymm0,%ymm0
 	vmovdqu		%ymm0,0x0040(%rsi)
 	vperm2i128	$0x31,%ymm6,%ymm1,%ymm6
 
 	vperm2i128	$0x20,%ymm14,%ymm10,%ymm0
-	cmp		$0x0080,%rax
-	jl		.Lxorpart8
 	vpxor		0x0060(%rdx),%ymm0,%ymm0
 	vmovdqu		%ymm0,0x0060(%rsi)
 	vperm2i128	$0x31,%ymm14,%ymm10,%ymm14
 
 	vmovdqa		0x20(%rsp),%ymm1
 	vperm2i128	$0x20,%ymm5,%ymm1,%ymm0
-	cmp		$0x00a0,%rax
-	jl		.Lxorpart8
 	vpxor		0x0080(%rdx),%ymm0,%ymm0
 	vmovdqu		%ymm0,0x0080(%rsi)
 	vperm2i128	$0x31,%ymm5,%ymm1,%ymm5
 
 	vperm2i128	$0x20,%ymm13,%ymm9,%ymm0
-	cmp		$0x00c0,%rax
-	jl		.Lxorpart8
 	vpxor		0x00a0(%rdx),%ymm0,%ymm0
 	vmovdqu		%ymm0,0x00a0(%rsi)
 	vperm2i128	$0x31,%ymm13,%ymm9,%ymm13
 
 	vmovdqa		0x60(%rsp),%ymm1
 	vperm2i128	$0x20,%ymm7,%ymm1,%ymm0
-	cmp		$0x00e0,%rax
-	jl		.Lxorpart8
 	vpxor		0x00c0(%rdx),%ymm0,%ymm0
 	vmovdqu		%ymm0,0x00c0(%rsi)
 	vperm2i128	$0x31,%ymm7,%ymm1,%ymm7
 
 	vperm2i128	$0x20,%ymm15,%ymm11,%ymm0
-	cmp		$0x0100,%rax
-	jl		.Lxorpart8
 	vpxor		0x00e0(%rdx),%ymm0,%ymm0
 	vmovdqu		%ymm0,0x00e0(%rsi)
 	vperm2i128	$0x31,%ymm15,%ymm11,%ymm15
 
-	# xor remaining blocks, write to output
+	# XOR up to 4 additional data blocks with the generated keystream.
 	vmovdqa		%ymm4,%ymm0
 	cmp		$0x0120,%rax
 	jl		.Lxorpart8
@@ -943,4 +916,4 @@ SYM_FUNC_START(chacha_8block_xor_avx2)
 
 	jmp		.Ldone8
 
-SYM_FUNC_END(chacha_8block_xor_avx2)
+SYM_FUNC_END(chacha_4to8blocks_avx2)
diff --git a/lib/crypto/x86/chacha-avx512-x86_64.S b/lib/crypto/x86/chacha-avx512-x86_64.S
index a0553decd9c5..127a94f1843b 100644
--- a/lib/crypto/x86/chacha-avx512-x86_64.S
+++ b/lib/crypto/x86/chacha-avx512-x86_64.S
@@ -43,11 +43,11 @@ CTRBL:	.octa 0x00000003000000020000000100000000
 .endr
 .endm
 
-SYM_FUNC_START(chacha_2block_xor_avx512vl)
+SYM_FUNC_START(chacha_0to2blocks_avx512vl)
 	# %rdi: Input state matrix, s
-	# %rsi: up to 2 data blocks output, o
-	# %rdx: up to 2 data blocks input, i
-	# %rcx: input/output length in bytes
+	# %rsi: output data, o
+	# %rdx: input data, i
+	# %rcx: input/output data length in bytes: 0 to 2 blocks inclusive
 	# %r8d: nrounds
 
 	# This function encrypts two ChaCha blocks by loading the state
@@ -133,8 +133,7 @@ SYM_FUNC_START(chacha_2block_xor_avx512vl)
 	vpaddd		%ymm10,%ymm2,%ymm2
 	vpaddd		%ymm11,%ymm3,%ymm3
 
-	# xor the data with the keystream
-
+	# XOR up to 2 data blocks with the generated keystream.
 	vperm2i128	$0x20, %ymm1, %ymm0, %ymm4
 	cmp		$1*32,%rcx
 	jl		.Lxorpart2
@@ -180,13 +179,13 @@ SYM_FUNC_START(chacha_2block_xor_avx512vl)
 
 	jmp		.Ldone2
 
-SYM_FUNC_END(chacha_2block_xor_avx512vl)
+SYM_FUNC_END(chacha_0to2blocks_avx512vl)
 
-SYM_FUNC_START(chacha_4block_xor_avx512vl)
+SYM_FUNC_START(chacha_2to4blocks_avx512vl)
 	# %rdi: Input state matrix, s
-	# %rsi: up to 4 data blocks output, o
-	# %rdx: up to 4 data blocks input, i
-	# %rcx: input/output length in bytes
+	# %rsi: output data, o
+	# %rdx: input data, i
+	# %rcx: input/output data length in bytes: 2 to 4 blocks inclusive
 	# %r8d: nrounds
 
 	# This function encrypts four ChaCha blocks by loading the state
@@ -323,32 +322,24 @@ SYM_FUNC_START(chacha_4block_xor_avx512vl)
 	vpaddd		%ymm13,%ymm6,%ymm6
 	vpaddd		%ymm15,%ymm7,%ymm7
 
-	# xor the data with the keystream
-
+	# XOR the first 2 data blocks with the generated keystream.
 	vperm2i128	$0x20, %ymm1, %ymm0, %ymm8
-	cmp		$1*32,%rcx
-	jl		.Lxorpart4
 	vpxor		0*32(%rdx),%ymm8,%ymm8
 	vmovdqu		%ymm8,0*32(%rsi)
 
 	vperm2i128	$0x20, %ymm3, %ymm2, %ymm8
-	cmp		$2*32,%rcx
-	jl		.Lxorpart4
 	vpxor		1*32(%rdx),%ymm8,%ymm8
 	vmovdqu		%ymm8,1*32(%rsi)
 
 	vperm2i128	$0x31, %ymm1, %ymm0, %ymm8
-	cmp		$3*32,%rcx
-	jl		.Lxorpart4
 	vpxor		2*32(%rdx),%ymm8,%ymm8
 	vmovdqu		%ymm8,2*32(%rsi)
 
 	vperm2i128	$0x31, %ymm3, %ymm2, %ymm8
-	cmp		$4*32,%rcx
-	jl		.Lxorpart4
 	vpxor		3*32(%rdx),%ymm8,%ymm8
 	vmovdqu		%ymm8,3*32(%rsi)
 
+	# XOR up to 2 additional data blocks with the generated keystream.
 	vperm2i128	$0x20, %ymm5, %ymm4, %ymm8
 	cmp		$5*32,%rcx
 	jl		.Lxorpart4
@@ -394,7 +385,7 @@ SYM_FUNC_START(chacha_4block_xor_avx512vl)
 
 	jmp		.Ldone4
 
-SYM_FUNC_END(chacha_4block_xor_avx512vl)
+SYM_FUNC_END(chacha_2to4blocks_avx512vl)
 
 .macro _chacha_words	vl
 	.set	VL,		\vl
@@ -402,9 +393,10 @@ SYM_FUNC_END(chacha_4block_xor_avx512vl)
 	_define_aliases
 
 	# %rdi: Input state matrix, s
-	# %rsi: up to VL/4 data blocks output, o
-	# %rdx: up to VL/4 data blocks input, i
-	# %rcx: input/output length in bytes
+	# %rsi: output data, o
+	# %rdx: input data, i
+	# %rcx: input/output data length in bytes: 4 to 8 blocks inclusive for
+	#       VL=32, or 8 to 16 blocks inclusive for VL=64.
 	# %r8d: nrounds
 
 	# This encrypts VL/4 consecutive ChaCha blocks by loading the state
@@ -653,57 +645,42 @@ SYM_FUNC_END(chacha_4block_xor_avx512vl)
 	vpunpckhqdq	V31,V29,V15
 
 .if VL == 32
-	# interleave 128-bit words in state n, n+4
-	# xor/write first four blocks
+	# Do the final 128-bit interleave within the XOR sequence.
+
+	# XOR the first 4 data blocks with the generated keystream.
 	vshufi64x2	$0x0,V4,V16,V0
-	cmp		$0x0020,%rcx
-	jl		.Lxorpart\@
 	vpxord		0x0000(%rdx),V0,V0
 	vmovdqu64	V0,0x0000(%rsi)
 
 	vperm2i128	$0x20,V12,V8,V0
-	cmp		$0x0040,%rcx
-	jl		.Lxorpart\@
 	vpxord		0x0020(%rdx),V0,V0
 	vmovdqu64	V0,0x0020(%rsi)
 
 	vperm2i128	$0x20,V5,V1,V0
-	cmp		$0x0060,%rcx
-	jl		.Lxorpart\@
 	vpxord		0x0040(%rdx),V0,V0
 	vmovdqu64	V0,0x0040(%rsi)
 
 	vperm2i128	$0x20,V13,V9,V0
-	cmp		$0x0080,%rcx
-	jl		.Lxorpart\@
 	vpxord		0x0060(%rdx),V0,V0
 	vmovdqu64	V0,0x0060(%rsi)
 
 	vperm2i128	$0x20,V6,V2,V0
-	cmp		$0x00a0,%rcx
-	jl		.Lxorpart\@
 	vpxord		0x0080(%rdx),V0,V0
 	vmovdqu64	V0,0x0080(%rsi)
 
 	vperm2i128	$0x20,V14,V10,V0
-	cmp		$0x00c0,%rcx
-	jl		.Lxorpart\@
 	vpxord		0x00a0(%rdx),V0,V0
 	vmovdqu64	V0,0x00a0(%rsi)
 
 	vperm2i128	$0x20,V7,V3,V0
-	cmp		$0x00e0,%rcx
-	jl		.Lxorpart\@
 	vpxord		0x00c0(%rdx),V0,V0
 	vmovdqu64	V0,0x00c0(%rsi)
 
 	vperm2i128	$0x20,V15,V11,V0
-	cmp		$0x0100,%rcx
-	jl		.Lxorpart\@
 	vpxord		0x00e0(%rdx),V0,V0
 	vmovdqu64	V0,0x00e0(%rsi)
 
-	# xor remaining blocks, write to output
+	# XOR up to 4 additional data blocks with the generated keystream.
 	vshufi64x2	$0x3,V4,V16,V0
 	cmp		$0x0120,%rcx
 	jl		.Lxorpart\@
@@ -770,55 +747,42 @@ SYM_FUNC_END(chacha_4block_xor_avx512vl)
 	vshufi64x2	$0xdd,V7,V3,V27
 	vshufi64x2	$0xdd,V15,V11,V31
 
-	# fuse the final 256-bit interleave into the xor/store ladder
+	# Do the final 256-bit interleave within the XOR sequence.
+
+	# XOR the first 8 data blocks with the generated keystream.
 	vshufi64x2	$0x88,V20,V16,V0
-	cmp		$0x0040,%rcx
-	jl		.Lxorpart\@
 	vpxord		0x0000(%rdx),V0,V0
 	vmovdqu64	V0,0x0000(%rsi)
 
 	vshufi64x2	$0x88,V21,V17,V0
-	cmp		$0x0080,%rcx
-	jl		.Lxorpart\@
 	vpxord		0x0040(%rdx),V0,V0
 	vmovdqu64	V0,0x0040(%rsi)
 
 	vshufi64x2	$0x88,V22,V18,V0
-	cmp		$0x00c0,%rcx
-	jl		.Lxorpart\@
 	vpxord		0x0080(%rdx),V0,V0
 	vmovdqu64	V0,0x0080(%rsi)
 
 	vshufi64x2	$0x88,V23,V19,V0
-	cmp		$0x0100,%rcx
-	jl		.Lxorpart\@
 	vpxord		0x00c0(%rdx),V0,V0
 	vmovdqu64	V0,0x00c0(%rsi)
 
 	vshufi64x2	$0x88,V28,V24,V0
-	cmp		$0x0140,%rcx
-	jl		.Lxorpart\@
 	vpxord		0x0100(%rdx),V0,V0
 	vmovdqu64	V0,0x0100(%rsi)
 
 	vshufi64x2	$0x88,V29,V25,V0
-	cmp		$0x0180,%rcx
-	jl		.Lxorpart\@
 	vpxord		0x0140(%rdx),V0,V0
 	vmovdqu64	V0,0x0140(%rsi)
 
 	vshufi64x2	$0x88,V30,V26,V0
-	cmp		$0x01c0,%rcx
-	jl		.Lxorpart\@
 	vpxord		0x0180(%rdx),V0,V0
 	vmovdqu64	V0,0x0180(%rsi)
 
 	vshufi64x2	$0x88,V31,V27,V0
-	cmp		$0x0200,%rcx
-	jl		.Lxorpart\@
 	vpxord		0x01c0(%rdx),V0,V0
 	vmovdqu64	V0,0x01c0(%rsi)
 
+	# XOR up to 8 additional data blocks with the generated keystream.
 	vshufi64x2	$0xdd,V20,V16,V0
 	cmp		$0x0240,%rcx
 	jl		.Lxorpart\@
@@ -890,10 +854,10 @@ SYM_FUNC_END(chacha_4block_xor_avx512vl)
 	jmp		.Ldone\@
 .endm
 
-SYM_FUNC_START(chacha_8block_xor_avx512vl)
+SYM_FUNC_START(chacha_4to8blocks_avx512vl)
 	_chacha_words	vl=32
-SYM_FUNC_END(chacha_8block_xor_avx512vl)
+SYM_FUNC_END(chacha_4to8blocks_avx512vl)
 
-SYM_FUNC_START(chacha_16block_xor_avx512)
+SYM_FUNC_START(chacha_8to16blocks_avx512)
 	_chacha_words	vl=64
-SYM_FUNC_END(chacha_16block_xor_avx512)
+SYM_FUNC_END(chacha_8to16blocks_avx512)
diff --git a/lib/crypto/x86/chacha-ssse3-x86_64.S b/lib/crypto/x86/chacha-ssse3-x86_64.S
index 7111949cd5b9..b9884ec979fa 100644
--- a/lib/crypto/x86/chacha-ssse3-x86_64.S
+++ b/lib/crypto/x86/chacha-ssse3-x86_64.S
@@ -111,11 +111,11 @@ SYM_FUNC_START_LOCAL(chacha_permute)
 	RET
 SYM_FUNC_END(chacha_permute)
 
-SYM_FUNC_START(chacha_block_xor_ssse3)
+SYM_FUNC_START(chacha_0to1blocks_ssse3)
 	# %rdi: Input state matrix, s
-	# %rsi: up to 1 data block output, o
-	# %rdx: up to 1 data block input, i
-	# %rcx: input/output length in bytes
+	# %rsi: output data, o
+	# %rdx: input data, i
+	# %rcx: input/output data length in bytes: 0 to 1 blocks inclusive
 	# %r8d: nrounds
 	FRAME_BEGIN
 
@@ -197,7 +197,7 @@ SYM_FUNC_START(chacha_block_xor_ssse3)
 	lea		-8(%r10),%rsp
 	jmp		.Ldone
 
-SYM_FUNC_END(chacha_block_xor_ssse3)
+SYM_FUNC_END(chacha_0to1blocks_ssse3)
 
 SYM_FUNC_START(hchacha_block_ssse3)
 	# %rdi: Input state matrix, s
@@ -220,11 +220,11 @@ SYM_FUNC_START(hchacha_block_ssse3)
 	RET
 SYM_FUNC_END(hchacha_block_ssse3)
 
-SYM_FUNC_START(chacha_4block_xor_ssse3)
+SYM_FUNC_START(chacha_1to4blocks_ssse3)
 	# %rdi: Input state matrix, s
-	# %rsi: up to 4 data blocks output, o
-	# %rdx: up to 4 data blocks input, i
-	# %rcx: input/output length in bytes
+	# %rsi: output data, o
+	# %rdx: input data, i
+	# %rcx: input/output data length in bytes: 1 to 4 blocks inclusive
 	# %r8d: nrounds
 
 	# This function encrypts four consecutive ChaCha blocks by loading the
@@ -647,35 +647,24 @@ SYM_FUNC_START(chacha_4block_xor_ssse3)
 	punpckhqdq	%xmm15,%xmm0
 	movdqa		%xmm0,%xmm15
 
-	# xor with corresponding input, write to output
-	movdqa		0x00(%rsp),%xmm0
-	cmp		$0x10,%rax
-	jl		.Lxorpart4
-	movdqu		0x00(%rdx),%xmm1
-	pxor		%xmm1,%xmm0
+	# XOR the first data block with the generated keystream.
+	movdqu		0x00(%rdx),%xmm0
+	pxor		0x00(%rsp),%xmm0
 	movdqu		%xmm0,0x00(%rsi)
 
-	movdqu		%xmm4,%xmm0
-	cmp		$0x20,%rax
-	jl		.Lxorpart4
 	movdqu		0x10(%rdx),%xmm1
-	pxor		%xmm1,%xmm0
-	movdqu		%xmm0,0x10(%rsi)
+	pxor		%xmm1,%xmm4
+	movdqu		%xmm4,0x10(%rsi)
 
-	movdqu		%xmm8,%xmm0
-	cmp		$0x30,%rax
-	jl		.Lxorpart4
 	movdqu		0x20(%rdx),%xmm1
-	pxor		%xmm1,%xmm0
-	movdqu		%xmm0,0x20(%rsi)
+	pxor		%xmm1,%xmm8
+	movdqu		%xmm8,0x20(%rsi)
 
-	movdqu		%xmm12,%xmm0
-	cmp		$0x40,%rax
-	jl		.Lxorpart4
 	movdqu		0x30(%rdx),%xmm1
-	pxor		%xmm1,%xmm0
-	movdqu		%xmm0,0x30(%rsi)
+	pxor		%xmm1,%xmm12
+	movdqu		%xmm12,0x30(%rsi)
 
+	# XOR up to 3 additional data blocks with the generated keystream.
 	movdqa		0x20(%rsp),%xmm0
 	cmp		$0x50,%rax
 	jl		.Lxorpart4
@@ -788,4 +777,4 @@ SYM_FUNC_START(chacha_4block_xor_ssse3)
 
 	jmp		.Ldone4
 
-SYM_FUNC_END(chacha_4block_xor_ssse3)
+SYM_FUNC_END(chacha_1to4blocks_ssse3)
diff --git a/lib/crypto/x86/chacha.h b/lib/crypto/x86/chacha.h
index 57d644f89431..96fe53e06285 100644
--- a/lib/crypto/x86/chacha.h
+++ b/lib/crypto/x86/chacha.h
@@ -10,36 +10,45 @@
 #include <linux/kernel.h>
 #include <linux/sizes.h>
 
-asmlinkage void chacha_block_xor_ssse3(const struct chacha_state *state,
-				       u8 *dst, const u8 *src, size_t len,
-				       int nrounds);
-asmlinkage void chacha_4block_xor_ssse3(const struct chacha_state *state,
+/* This supports lengths of 0 to 1 blocks inclusive. */
+asmlinkage void chacha_0to1blocks_ssse3(const struct chacha_state *state,
+					u8 *dst, const u8 *src, size_t len,
+					int nrounds);
+/* This supports lengths of 1 to 4 blocks inclusive. */
+asmlinkage void chacha_1to4blocks_ssse3(const struct chacha_state *state,
 					u8 *dst, const u8 *src, size_t len,
 					int nrounds);
 asmlinkage void hchacha_block_ssse3(const struct chacha_state *state,
 				    u32 out[HCHACHA_OUT_WORDS], int nrounds);
 
-asmlinkage void chacha_2block_xor_avx2(const struct chacha_state *state,
+/* This supports lengths of 1 to 2 blocks inclusive. */
+asmlinkage void chacha_1to2blocks_avx2(const struct chacha_state *state,
 				       u8 *dst, const u8 *src, size_t len,
 				       int nrounds);
-asmlinkage void chacha_4block_xor_avx2(const struct chacha_state *state,
+/* This supports lengths of 2 to 4 blocks inclusive. */
+asmlinkage void chacha_2to4blocks_avx2(const struct chacha_state *state,
 				       u8 *dst, const u8 *src, size_t len,
 				       int nrounds);
-asmlinkage void chacha_8block_xor_avx2(const struct chacha_state *state,
+/* This supports lengths of 4 to 8 blocks inclusive. */
+asmlinkage void chacha_4to8blocks_avx2(const struct chacha_state *state,
 				       u8 *dst, const u8 *src, size_t len,
 				       int nrounds);
 
-asmlinkage void chacha_2block_xor_avx512vl(const struct chacha_state *state,
+/* This supports lengths of 0 to 2 blocks inclusive. */
+asmlinkage void chacha_0to2blocks_avx512vl(const struct chacha_state *state,
 					   u8 *dst, const u8 *src, size_t len,
 					   int nrounds);
-asmlinkage void chacha_4block_xor_avx512vl(const struct chacha_state *state,
+/* This supports lengths of 2 to 4 blocks inclusive. */
+asmlinkage void chacha_2to4blocks_avx512vl(const struct chacha_state *state,
 					   u8 *dst, const u8 *src, size_t len,
 					   int nrounds);
-asmlinkage void chacha_8block_xor_avx512vl(const struct chacha_state *state,
+/* This supports lengths of 4 to 8 blocks inclusive. */
+asmlinkage void chacha_4to8blocks_avx512vl(const struct chacha_state *state,
 					   u8 *dst, const u8 *src, size_t len,
 					   int nrounds);
 
-asmlinkage void chacha_16block_xor_avx512(const struct chacha_state *state,
+/* This supports lengths of 8 to 16 blocks inclusive. */
+asmlinkage void chacha_8to16blocks_avx512(const struct chacha_state *state,
 					  u8 *dst, const u8 *src, size_t len,
 					  int nrounds);
 
@@ -48,13 +57,24 @@ static __ro_after_init DEFINE_STATIC_KEY_FALSE(chacha_use_avx2);
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(chacha_use_avx512vl);
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(chacha_use_avx512);
 
+/*
+ * Dispatch to the appropriate assembly functions, depending on the available
+ * CPU features and the data length.
+ *
+ * Each assembly function supports a specific range of lengths, e.g. 2 to 4
+ * blocks.  chacha_dosimd() ensures that it passes each assembly function a
+ * supported length.  It also makes sure not to call functions wider than
+ * needed; e.g., for 4 blocks it calls a 2to4 function rather than 4to8.
+ *
+ * The counter is always incremented here in the C code, not in the assembly.
+ */
 static void chacha_dosimd(struct chacha_state *state, u8 *dst, const u8 *src,
 			  size_t bytes, int nrounds)
 {
 	if (static_branch_likely(&chacha_use_avx512vl)) {
 		if (static_branch_likely(&chacha_use_avx512)) {
 			while (bytes >= CHACHA_BLOCK_SIZE * 16) {
-				chacha_16block_xor_avx512(
+				chacha_8to16blocks_avx512(
 					state, dst, src, CHACHA_BLOCK_SIZE * 16,
 					nrounds);
 				bytes -= CHACHA_BLOCK_SIZE * 16;
@@ -63,7 +83,7 @@ static void chacha_dosimd(struct chacha_state *state, u8 *dst, const u8 *src,
 				state->x[12] += 16;
 			}
 			if (bytes > CHACHA_BLOCK_SIZE * 8) {
-				chacha_16block_xor_avx512(state, dst, src,
+				chacha_8to16blocks_avx512(state, dst, src,
 							  bytes, nrounds);
 				state->x[12] +=
 					DIV_ROUND_UP(bytes, CHACHA_BLOCK_SIZE);
@@ -71,7 +91,7 @@ static void chacha_dosimd(struct chacha_state *state, u8 *dst, const u8 *src,
 			}
 		} else {
 			while (bytes >= CHACHA_BLOCK_SIZE * 8) {
-				chacha_8block_xor_avx512vl(
+				chacha_4to8blocks_avx512vl(
 					state, dst, src, CHACHA_BLOCK_SIZE * 8,
 					nrounds);
 				bytes -= CHACHA_BLOCK_SIZE * 8;
@@ -81,18 +101,18 @@ static void chacha_dosimd(struct chacha_state *state, u8 *dst, const u8 *src,
 			}
 		}
 		if (bytes > CHACHA_BLOCK_SIZE * 4)
-			chacha_8block_xor_avx512vl(state, dst, src, bytes,
+			chacha_4to8blocks_avx512vl(state, dst, src, bytes,
 						   nrounds);
 		else if (bytes > CHACHA_BLOCK_SIZE * 2)
-			chacha_4block_xor_avx512vl(state, dst, src, bytes,
+			chacha_2to4blocks_avx512vl(state, dst, src, bytes,
 						   nrounds);
 		else if (bytes)
-			chacha_2block_xor_avx512vl(state, dst, src, bytes,
+			chacha_0to2blocks_avx512vl(state, dst, src, bytes,
 						   nrounds);
 		state->x[12] += DIV_ROUND_UP(bytes, CHACHA_BLOCK_SIZE);
 	} else if (static_branch_likely(&chacha_use_avx2)) {
 		while (bytes >= CHACHA_BLOCK_SIZE * 8) {
-			chacha_8block_xor_avx2(state, dst, src,
+			chacha_4to8blocks_avx2(state, dst, src,
 					       CHACHA_BLOCK_SIZE * 8, nrounds);
 			bytes -= CHACHA_BLOCK_SIZE * 8;
 			src += CHACHA_BLOCK_SIZE * 8;
@@ -100,17 +120,18 @@ static void chacha_dosimd(struct chacha_state *state, u8 *dst, const u8 *src,
 			state->x[12] += 8;
 		}
 		if (bytes > CHACHA_BLOCK_SIZE * 4)
-			chacha_8block_xor_avx2(state, dst, src, bytes, nrounds);
+			chacha_4to8blocks_avx2(state, dst, src, bytes, nrounds);
 		else if (bytes > CHACHA_BLOCK_SIZE * 2)
-			chacha_4block_xor_avx2(state, dst, src, bytes, nrounds);
+			chacha_2to4blocks_avx2(state, dst, src, bytes, nrounds);
 		else if (bytes > CHACHA_BLOCK_SIZE)
-			chacha_2block_xor_avx2(state, dst, src, bytes, nrounds);
+			chacha_1to2blocks_avx2(state, dst, src, bytes, nrounds);
 		else if (bytes)
-			chacha_block_xor_ssse3(state, dst, src, bytes, nrounds);
+			chacha_0to1blocks_ssse3(state, dst, src, bytes,
+						nrounds);
 		state->x[12] += DIV_ROUND_UP(bytes, CHACHA_BLOCK_SIZE);
 	} else {
 		while (bytes >= CHACHA_BLOCK_SIZE * 4) {
-			chacha_4block_xor_ssse3(state, dst, src,
+			chacha_1to4blocks_ssse3(state, dst, src,
 						CHACHA_BLOCK_SIZE * 4, nrounds);
 			bytes -= CHACHA_BLOCK_SIZE * 4;
 			src += CHACHA_BLOCK_SIZE * 4;
@@ -118,10 +139,11 @@ static void chacha_dosimd(struct chacha_state *state, u8 *dst, const u8 *src,
 			state->x[12] += 4;
 		}
 		if (bytes > CHACHA_BLOCK_SIZE)
-			chacha_4block_xor_ssse3(state, dst, src, bytes,
+			chacha_1to4blocks_ssse3(state, dst, src, bytes,
 						nrounds);
 		else if (bytes)
-			chacha_block_xor_ssse3(state, dst, src, bytes, nrounds);
+			chacha_0to1blocks_ssse3(state, dst, src, bytes,
+						nrounds);
 		state->x[12] += DIV_ROUND_UP(bytes, CHACHA_BLOCK_SIZE);
 	}
 }

base-commit: 9fbbbaefd5f95551da18426c200cf41e1b4255a1
prerequisite-patch-id: 890b33260038bff2e3adfe7867af5919666677fc
prerequisite-patch-id: 36cadf8c358a9778d745637c00368df82a93ce0d
prerequisite-patch-id: b9ef92f4abcdfe8946d645db12187f6293a46381
prerequisite-patch-id: 85904a5ef5aa8a48c311b2e87ed4d2403bd9e351
prerequisite-patch-id: b2272c2d61bf0db8f678f393b3907a7bce7e99d6
-- 
2.56.0

