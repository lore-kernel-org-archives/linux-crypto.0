Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795314067;
	b=LHbtfIjOPI2Ahqa1PHSr5hOzaR6TICZYZMSUSI2ErI8KuhzUU/sb+6ZVykzr3sGIfHSE
	 ALVf1XET8cnmZ1q9RNlOW7bhyg10VbIq6drtDhSnozay0osx3gCNOHaPNe6qzBwf2XhLh
	 I8l640oNyrqlaEmmjJfkS8vbSI8lpH07BbSlfIKgdulrih7cH7Tbn1HF62/Zq1Rp6JSF7
	 mhtwRkK/GwoRv7/TK8rGxMcGtQaUPn5VkZY5SUw9kFsjYVnYrQHoexJ0RY4oUYH63uyVb
	 t4Z+c9lKCXShgRg6kJHHwkYYfdM7pBqr5sXW0qeXiMW/h9xP5wznIL9RmnkR7AMra0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795314067;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=lSr1Ru1kTwBB7DiISWdUv8PJumumqnz7ZhJqeI0JajM=;
	b=gx/qJYgX1LLVj8HoUY3ee0Q/XZfkwE7myTqAqYjAAoqnXqZ4zb/c5oIo3qnKx3NTVk5N
	 Zb2S/n+qwd1n22R7IDQIpvlwOoK7g/onsndKBnz3aWp11DxqcMlZYNh3PiYA5O7Axzwsm
	 7B+i/I0oPkyMxGTY+eNjpXEyg2l6XqWpV93doKdDwBwCTddQvHtpFNS5mKHHFVbZAtVG+
	 n8peX+PVd2O60X1/6pjYHPq7xQPt60Zl6tIC7+d/vSld8oc1ySAKnW2sGvlxfsZdrHxiQ
	 /DWQ2bWORSmGQ72lMu2aWiryFzl+OcDwsNDbvSslV4fPPw8YNrVqpRM+NQq2n21dYmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ucv8ZPGj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872FC606A336
	for <linux-crypto@vger.kernel.org>; Sun, 22 Nov 2026 02:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ucv8ZPGj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF321F000D1;
	Sun, 22 Nov 2026 02:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795314067;
	bh=lSr1Ru1kTwBB7DiISWdUv8PJumumqnz7ZhJqeI0JajM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ucv8ZPGjWeYN66DVWpiY+yIxzNrfAwsco80sA5xI5xZvaPLX9zwhUO0k88Mx8i3b3
	 SZk9ZdRJWx3m/Za5SIBcj8J+Ujt5fRmgRscGlOS13Q+mZUvgYn6mdzIisaxGh0RlAR
	 C6GyNnhGR7x56NB/f3u1uvnOsHi8tVUe0pfVAfW2sDpc7rqP5dF69N63z3r6lZVB8x
	 rFWJ9xgUKFsL9aP/ckzAJuAL2GN+4PD3H+EibsIB5AWqzOiCfKL8cEw9TwfwFQ6HR5
	 AFj0jhQo2xiYnxyfnV8uw/ni8967lBBNl99sbGFVcZ6vSYWdITG1x3EkT1tVGEVOX1
	 JXPMXMO4AyxRg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/8] lib/crypto: x86/sha512: Keep message schedule in XMM registers
Date: Sat, 21 Nov 2026 18:20:24 -0800
Message-ID: <20261122022030.296468-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261122022030.296468-1-ebiggers@kernel.org>
References: <20261122022030.296468-1-ebiggers@kernel.org>
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

sha512_transform_ssse3() stores all 80 message schedule words W[0..79]
in a 640-byte stack buffer.  However, W[t] depends only on the previous
16 words, and enough XMM registers are free to hold 16 words.

Therefore, just keep a rolling window of W[t-16..t-1] in %xmm6-%xmm13
instead.  These contain even-indexed word pairs, so when an odd-indexed
pair is needed use palignr to extract it.

Cycling through all 8 registers would take 16 rounds, whereas the
current loop does 8 per iteration.  Prioritize code size (saving
~1.1 KB) by keeping it at 8 rounds per iteration and just doing the
needed series of moves at the end of each one.

This shrinks sha512_transform_ssse3()'s stack frame from a max of 744
bytes (which was large for a kernel function) to a max of 104 bytes.
This also is likely to be a modest performance improvement, or at worst
neutral, on the CPUs that use this code.

This also fixes the lack of zeroization of the message schedule buffer,
which included the input data itself, e.g. possibly an HMAC key.
('frame_WK' is not yet zeroized, but a later commit removes it.)

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/sha512-ssse3-asm.S | 108 +++++++++++++++++++++---------
 1 file changed, 75 insertions(+), 33 deletions(-)

diff --git a/lib/crypto/x86/sha512-ssse3-asm.S b/lib/crypto/x86/sha512-ssse3-asm.S
index 0d24fec04d635..fe72ceb6a2735 100644
--- a/lib/crypto/x86/sha512-ssse3-asm.S
+++ b/lib/crypto/x86/sha512-ssse3-asm.S
@@ -2,6 +2,7 @@
 # Implement fast SHA-512 with SSSE3 instructions. (x86_64)
 #
 # Copyright (C) 2013 Intel Corporation.
+# Copyright 2026 Google LLC
 #
 # Authors:
 #     James Guilford <james.guilford@intel.com>
@@ -73,19 +74,28 @@ tmp0 =		%rax
 kptr =		%rdi	# Pointer to K512[72]
 toff =		%rdx	# 8*(t - 80), where W[t] is the first QWORD scheduled in the iteration.
 
+# Rolling window of the last 16 message schedule QWORDs:
+# XW0 = {W[t-16], W[t-15]}, ..., XW7 = {W[t-2], W[t-1]}
+XW0 =		%xmm6
+XW1 =		%xmm7
+XW2 =		%xmm8
+XW3 =		%xmm9
+XW4 =		%xmm10
+XW5 =		%xmm11
+XW6 =		%xmm12
+XW7 =		%xmm13
+
 # Local variables (stack frame)
 
-W_SIZE = 80*8
 WK_SIZE = 2*8
 
 frame_WK = 0
-frame_W = frame_WK + WK_SIZE
-frame_digest = frame_W + W_SIZE
+frame_digest = frame_WK + WK_SIZE
 frame_msglen = frame_digest + 8
 frame_size = frame_msglen + 8
 
 # Useful QWORD "arrays" for simpler memory references
-# MSG, DIGEST, K_t, W_t are arrays
+# MSG, DIGEST, K_t are arrays
 # WK_2(t) points to 1 of 2 qwords at frame.WK depending on t being odd/even
 
 # Input message (arg1)
@@ -97,12 +107,22 @@ frame_size = frame_msglen + 8
 # SHA Constants (static mem)
 #define K_t(i)    8*i+K512(%rip)
 
-# Message Schedule (stack frame)
-#define W_t(i)    8*i+frame_W(%rsp)
-
 # W[t]+K[t] (stack frame)
 #define WK_2(i)   8*((i%2))+frame_WK(%rsp)
 
+.macro RotateXW
+	# Rotate symbols XW0..XW7 left
+	XWTMP = XW0
+	XW0   = XW1
+	XW1   = XW2
+	XW2   = XW3
+	XW3   = XW4
+	XW4   = XW5
+	XW5   = XW6
+	XW6   = XW7
+	XW7   = XWTMP
+.endm
+
 .macro RotateState
 	# Rotate symbols a..h right
 	TMP   = h_64
@@ -160,26 +180,25 @@ frame_size = frame_msglen + 8
 	#   Two rounds are computed based on the values for K[t-2]+W[t-2] and
 	# K[t-1]+W[t-1] which were previously stored at WK_2 by the message
 	# scheduler.
-	#   The two new schedule QWORDS are stored at
-	# (frame_W + W_SIZE + \offset)(%rsp, toff) and
-	# (frame_W + W_SIZE + \offset + 8)(%rsp, toff).
+	#   The two new schedule QWORDS are stored in XW0 (which previously held
+	# W[t-16] and W[t-15], and is rotated to XW7 at the end of the macro).
 	# They are then added to their respective SHA512 constants at
 	# (\offset + 64)(kptr, toff) and (\offset + 72)(kptr, toff) and stored at
 	# dqword WK_2(0).
 	#   For brevity, the comments following vectored instructions only refer to
 	# the first of a pair of QWORDS.
-	# Eg. XMM2=W[t-2] really means XMM2={W[t-2]|W[t-1]}
+	# Eg. XW7=W[t-2] really means XW7={W[t-2]|W[t-1]}
 	#   The computation of the message schedule and the rounds are tightly
 	# stitched to take advantage of instruction-level parallelism.
 
 	mov	f_64, T1
-	movdqa	(frame_W + W_SIZE + \offset - 16)(%rsp, toff), %xmm2	    # XMM2 = W[t-2]
+	movdqa	XW1, %xmm5		    # XMM5 = W[t-14]
 	xor	g_64, T1
 	and	e_64, T1
-	movdqa	%xmm2, %xmm0	            # XMM0 = W[t-2]
+	movdqa	XW7, %xmm0		    # XMM0 = W[t-2]
 	xor	g_64, T1
 	add	WK_2(0), T1
-	movdqu	(frame_W + W_SIZE + \offset - 120)(%rsp, toff), %xmm5	    # XMM5 = W[t-15]
+	palignr	$8, XW0, %xmm5		    # XMM5 = W[t-15]
 	mov	e_64, tmp0
 	ror	$23, tmp0 # 41
 	movdqa	%xmm5, %xmm3	            # XMM3 = W[t-15]
@@ -191,7 +210,7 @@ frame_size = frame_msglen + 8
 	psrlq	$(8-7), %xmm3		    # XMM3 = W[t-15] >> 1
 	add	tmp0, T1
 	add	h_64, T1
-	pxor	%xmm2, %xmm0                # XMM0 = (W[t-2] >> 42) ^ W[t-2]
+	pxor	XW7, %xmm0		    # XMM0 = (W[t-2] >> 42) ^ W[t-2]
 	mov	a_64, T2
 	xor	c_64, T2
 	pxor	%xmm5, %xmm3                # XMM3 = (W[t-15] >> 1) ^ W[t-15]
@@ -203,7 +222,7 @@ frame_size = frame_msglen + 8
 	psrlq	$(7-1), %xmm3		    # XMM3 = ((W[t-15]>>1)^W[t-15])>>6
 	mov	a_64, tmp0
 	ror	$5, tmp0 # 39
-	pxor	%xmm2, %xmm0	            # XMM0 = (((W[t-2]>>42)^W[t-2])>>13)^W[t-2]
+	pxor	XW7, %xmm0		    # XMM0 = (((W[t-2]>>42)^W[t-2])>>13)^W[t-2]
 	xor	a_64, tmp0
 	ror	$6, tmp0 # 34
 	pxor	%xmm5, %xmm3                # XMM3 = (((W[t-15]>>1)^W[t-15])>>6)^W[t-15]
@@ -215,7 +234,7 @@ frame_size = frame_msglen + 8
 	psrlq	$1, %xmm3                   # XMM3 = (((W[t-15]>>1)^W[t-15])>>6)^W[t-15]>>1
 	lea	(T1, T2), h_64
 	RotateState
-	movdqa	%xmm2, %xmm1	            # XMM1 = W[t-2]
+	movdqa	XW7, %xmm1		    # XMM1 = W[t-2]
 	mov	f_64, T1
 	xor	g_64, T1
 	movdqa	%xmm5, %xmm4		    # XMM4 = W[t-15]
@@ -227,7 +246,7 @@ frame_size = frame_msglen + 8
 	psllq	$(64-1)-(64-8), %xmm4	    # XMM4 = W[t-15] << 7
 	ror	$23, tmp0 # 41
 	xor	e_64, tmp0
-	pxor	%xmm2, %xmm1		    # XMM1 = (W[t-2] << 42)^W[t-2]
+	pxor	XW7, %xmm1		    # XMM1 = (W[t-2] << 42)^W[t-2]
 	ror	$4, tmp0 # 18
 	xor	e_64, tmp0
 	pxor	%xmm5, %xmm4		    # XMM4 = (W[t-15]<<7)^W[t-15]
@@ -242,25 +261,27 @@ frame_size = frame_msglen + 8
 	pxor	%xmm1, %xmm0		    # XMM0 = s1(W[t-2])
 	mov	a_64, tmp0
 	and	c_64, tmp0
-	movdqu	(frame_W + W_SIZE + \offset - 56)(%rsp, toff), %xmm1 # XMM1 = W[t-7]
+	movdqa	XW5, %xmm1		    # XMM1 = W[t-6]
 	xor	tmp0, T2
 	pxor	%xmm4, %xmm3                # XMM3 = s0(W[t-15])
 	mov	a_64, tmp0
 	paddq	%xmm3, %xmm0		    # XMM0 = s1(W[t-2]) + s0(W[t-15])
 	ror	$5, tmp0 # 39
-	paddq	(frame_W + W_SIZE + \offset - 128)(%rsp, toff), %xmm0 # XMM0 = s1(W[t-2]) + s0(W[t-15]) + W[t-16]
+	palignr	$8, XW4, %xmm1		    # XMM1 = W[t-7]
 	xor	a_64, tmp0
-	paddq	%xmm1, %xmm0	            # XMM0 = s1(W[t-2]) + W[t-7] + s0(W[t-15]) + W[t-16]
+	paddq	XW0, %xmm0		    # XMM0 = s1(W[t-2]) + s0(W[t-15]) + W[t-16]
 	ror	$6, tmp0 # 34
-	movdqa	%xmm0, (frame_W + W_SIZE + \offset)(%rsp, toff)	    # Store scheduled qwords
+	paddq	%xmm1, %xmm0		    # XMM0 = s1(W[t-2]) + W[t-7] + s0(W[t-15]) + W[t-16]
 	xor	a_64, tmp0
-	paddq	(\offset + 64)(kptr, toff), %xmm0  # Compute W[t]+K[t]
+	movdqa	%xmm0, XW0		    # Store scheduled qwords
 	ror	$28, tmp0 # 28
-	movdqa	%xmm0, WK_2(0)		    # Store W[t]+K[t] for next rounds
+	paddq	(\offset + 64)(kptr, toff), %xmm0  # Compute W[t]+K[t]
 	add	tmp0, T2
+	movdqa	%xmm0, WK_2(0)		    # Store W[t]+K[t] for next rounds
 	add	T1, d_64
 	lea	(T1, T2), h_64
 	RotateState
+	RotateXW
 .endm
 
 ########################################################################
@@ -304,19 +325,19 @@ SYM_FUNC_START(sha512_transform_ssse3)
 	mov	DIGEST(6), g_64
 	mov	DIGEST(7), h_64
 
-	# Rounds 0 - 13: BSWAP W[0..15] and compute rounds 0..13.
+	# Rounds 0 - 13: BSWAP W[0..15] into XW0..XW7 and compute rounds 0..13.
 	movdqa	XMM_QWORD_BSWAP(%rip), %xmm1
-	movdqu	MSG(0), %xmm0
-	pshufb	%xmm1, %xmm0	# BSWAP
-	movdqa	%xmm0, W_t(0)	# Store Scheduled Pair
+	movdqu	MSG(0), XW0
+	pshufb	%xmm1, XW0	# BSWAP
+	movdqa	XW0, %xmm0
 	paddq	K_t(0), %xmm0	# Compute W[t]+K[t]
 	movdqa	%xmm0, WK_2(0)	# Store into WK for rounds
 	t = 2
-	.rept 7
-		movdqu	MSG(t), %xmm0
-		pshufb	%xmm1, %xmm0	# BSWAP
+	.irp reg, XW1,XW2,XW3,XW4,XW5,XW6,XW7
+		movdqu	MSG(t), \reg
+		pshufb	%xmm1, \reg	# BSWAP
 		SHA512_Round (t-2)	# Round t-2
-		movdqa	%xmm0, W_t(t)	# Store Scheduled Pair
+		movdqa	\reg, %xmm0
 		paddq	K_t(t), %xmm0	# Compute W[t]+K[t]
 		SHA512_Round (t-1)	# Round t-1
 		movdqa	%xmm0, WK_2(t)	# Store W[t]+K[t] into WK
@@ -324,7 +345,10 @@ SYM_FUNC_START(sha512_transform_ssse3)
 	.endr
 
 	# Rounds 14 - 77: Schedule W[16..79] and compute rounds 14..77,
-	# rolled into 8 iterations of 8 rounds each.
+	# rolled into 8 iterations of 8 rounds each.  Unrolling to 16 rounds per
+	# iteration would avoid the register swap below, but 8 rounds per
+	# iteration saves ~1.1 KB of code size, which is worthwhile for this
+	# fallback implementation and improves I-cache residency.
 	lea	K512+72*8(%rip), kptr
 	mov	$-(80-16)*8, toff
 
@@ -335,6 +359,24 @@ SYM_FUNC_START(sha512_transform_ssse3)
 	SHA512_2Sched_2Round_sse 32
 	SHA512_2Sched_2Round_sse 48
 
+	# Swap XW0..XW3 (%xmm10..%xmm13) and XW4..XW7 (%xmm6..%xmm9) so the
+	# rolling window is back in %xmm6..%xmm13 for the next 8-round iteration.
+	movdqa	%xmm6, %xmm0
+	movdqa	%xmm7, %xmm1
+	movdqa	%xmm8, %xmm2
+	movdqa	%xmm9, %xmm3
+	movdqa	%xmm10, %xmm6
+	movdqa	%xmm11, %xmm7
+	movdqa	%xmm12, %xmm8
+	movdqa	%xmm13, %xmm9
+	movdqa	%xmm0, %xmm10
+	movdqa	%xmm1, %xmm11
+	movdqa	%xmm2, %xmm12
+	movdqa	%xmm3, %xmm13
+	.rept 4
+		RotateXW
+	.endr
+
 	add	$8*8, toff
 	jnz	.Lsched_loop
 
-- 
2.56.1

