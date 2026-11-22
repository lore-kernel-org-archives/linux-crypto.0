Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795314066;
	b=LxqihFLu4GBTlnJXZYfbwQqi0T8dCeCXzLRd5x+zC9m7dh/rrzKjjqM9Smw3MphEhRvm
	 fONb/c/ylCac0NjGdBrW9unzL2F3pfbHQq4EK+y+bp6iAWBOYx2hzNObKeDVFZSb2Zcxr
	 u2FhU1g2QWVlA4q5C6wSQU3Ws1iHelAc9YS22GfTgZadhybpWW0LnWptbeRhG5rBMAtT3
	 NoWRGVu+O0Ze/Xr3jXu5ebxedWCujxusoyhmlyWRsV9Z4Dr+JPn6xD8r+DCbedClfmyWw
	 guD1/k1wyqyGixPM8nGr1jC0vHMWmsjfgrt3/dOQq4f1S0y8UIIXl0IC3yJlKd9vJTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795314066;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=4mxUpdtTdMfPCWuiSgkelKZvO+63hcTN6GERCvsI2oQ=;
	b=l/CQGEe3f8Rrdv8MJQqOF6Gy5w/13FAWvdO41B2ZG7tW9yE9E3Arm0ZN9Or6ArIzHYE7
	 iWDgSm+CpYvFaR8U4Jlqqms8222iFDr0CBVKz+msi9/jpLgxkIDl/UwD402XYLQyonXMm
	 dErOhslIi/dhyXXWncX6/qg9+jOWnQlCPbcPbCLTZlwcMs76dZhDUWvJi6tMcVWFsS2Ig
	 kuAH0ufLTuyKdMD2xZ6RFZTKNNDTgIg+bYPMqlBnJeAm5r6STPQH9m3J+H8HmUBDk2sbb
	 zHAmGanELsvWT50FZw6i52IgfH/24wa0EcxLDb5dJf2qRtXI7mZUMbZW4ZQzl6tvWrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AUgCI8MZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD926606A331
	for <linux-crypto@vger.kernel.org>; Sun, 22 Nov 2026 02:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AUgCI8MZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 803751F000C0;
	Sun, 22 Nov 2026 02:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795314066;
	bh=4mxUpdtTdMfPCWuiSgkelKZvO+63hcTN6GERCvsI2oQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AUgCI8MZtAiMrra+VU59bnsHRXVrTXI9lYqxz5AG5ClCmwO9GNSp3Kzf9+Ai32Ti6
	 0Kz4HoWEwjIjgarin2CGJibcyGBsGr3IVjxLkG4dhUr1uwja1Sk31819naVny4iJuP
	 Qx4jp0La91rHTIzU4K3ooH4iFaIklwBVdZh14Pl2bG9cbZ/xMONf2hajqs9KI+I+Fd
	 r+4OHDc4z5h4/kA7jfZ5WlHDhCc8LUZmxwJ6kgce2ewP4sgQVE0RAfc/9C7i2hrq9C
	 0bmDgnkUCpGZaEBOACkEhNCS4be8LW+id5Ey4kj/gtGWD/y6wHDUrjMq9aojiap2DJ
	 U2vk7s5+bTOUQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 1/8] lib/crypto: x86/sha512: Partially roll up sha512_transform_ssse3()
Date: Sat, 21 Nov 2026 18:20:23 -0800
Message-ID: <20261122022030.296468-2-ebiggers@kernel.org>
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

Currently, sha512_transform_ssse3() unrolls all 80 SHA-512 rounds,
generating 13.4 KB of text.  This is wasted on most systems, which
execute the AVX2 code anyway.  And it's also likely to be harmful on
systems that do run this code, due to cache pollution.

Roll up rounds 14 through 77 into 8 groups of 8 rounds.  This requires
some additional GPRs, as the offsets into the message schedule words and
round constants are no longer immediates.  Therefore, free up two GPRs
by spilling the 'digest' and 'msglen' arguments to the stack; use them
to store a pointer to the round constants and an offset into it.

This reduces the text size from 13.4 KB to 3.3 KB.  (For some
perspective, the 10.1 KB saved is greater than the size of all four
variants of the AES-XTS assembly code combined at 7.5 KB.)

I also ran the sha512 benchmark on a Haswell system (the oldest I could
easily get access to) with the AVX and AVX2 code disabled.  SHA-512
throughput actually increased by 5% as a result of this commit, likely
as a result of the code fitting much better into caches.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/sha512-ssse3-asm.S | 124 ++++++++++++++++--------------
 1 file changed, 67 insertions(+), 57 deletions(-)

diff --git a/lib/crypto/x86/sha512-ssse3-asm.S b/lib/crypto/x86/sha512-ssse3-asm.S
index 1a37b7a735cf9..0d24fec04d635 100644
--- a/lib/crypto/x86/sha512-ssse3-asm.S
+++ b/lib/crypto/x86/sha512-ssse3-asm.S
@@ -69,15 +69,20 @@ f_64 =		%r14
 g_64 =		%r15
 h_64 =		%rbx
 tmp0 =		%rax
+# Used in the rounds 14-77 loop, while digest and msglen are spilled
+kptr =		%rdi	# Pointer to K512[72]
+toff =		%rdx	# 8*(t - 80), where W[t] is the first QWORD scheduled in the iteration.
 
 # Local variables (stack frame)
 
 W_SIZE = 80*8
 WK_SIZE = 2*8
 
-frame_W = 0
-frame_WK = frame_W + W_SIZE
-frame_size = frame_WK + WK_SIZE
+frame_WK = 0
+frame_W = frame_WK + WK_SIZE
+frame_digest = frame_W + W_SIZE
+frame_msglen = frame_digest + 8
+frame_size = frame_msglen + 8
 
 # Useful QWORD "arrays" for simpler memory references
 # MSG, DIGEST, K_t, W_t are arrays
@@ -146,37 +151,35 @@ frame_size = frame_WK + WK_SIZE
 	RotateState
 .endm
 
-.macro SHA512_2Sched_2Round_sse rnd
+.macro SHA512_2Sched_2Round_sse offset
 
 	# Compute rounds t-2 and t-1
 	# Compute message schedule QWORDS t and t+1
+	# where t = 80 + (toff + \offset) / 8
 
 	#   Two rounds are computed based on the values for K[t-2]+W[t-2] and
 	# K[t-1]+W[t-1] which were previously stored at WK_2 by the message
 	# scheduler.
-	#   The two new schedule QWORDS are stored at [W_t(%%t)] and [W_t(%%t+1)].
+	#   The two new schedule QWORDS are stored at
+	# (frame_W + W_SIZE + \offset)(%rsp, toff) and
+	# (frame_W + W_SIZE + \offset + 8)(%rsp, toff).
 	# They are then added to their respective SHA512 constants at
-	# [K_t(%%t)] and [K_t(%%t+1)] and stored at dqword [WK_2(%%t)]
-	#   For brievity, the comments following vectored instructions only refer to
+	# (\offset + 64)(kptr, toff) and (\offset + 72)(kptr, toff) and stored at
+	# dqword WK_2(0).
+	#   For brevity, the comments following vectored instructions only refer to
 	# the first of a pair of QWORDS.
 	# Eg. XMM2=W[t-2] really means XMM2={W[t-2]|W[t-1]}
 	#   The computation of the message schedule and the rounds are tightly
 	# stitched to take advantage of instruction-level parallelism.
-	# For clarity, integer instructions (for the rounds calculation) are indented
-	# by one tab. Vectored instructions (for the message scheduler) are indented
-	# by two tabs.
 
 	mov	f_64, T1
-	idx = \rnd -2
-	movdqa	W_t(idx), %xmm2		    # XMM2 = W[t-2]
+	movdqa	(frame_W + W_SIZE + \offset - 16)(%rsp, toff), %xmm2	    # XMM2 = W[t-2]
 	xor	g_64, T1
 	and	e_64, T1
 	movdqa	%xmm2, %xmm0	            # XMM0 = W[t-2]
 	xor	g_64, T1
-	idx = \rnd
-	add	WK_2(idx), T1
-	idx = \rnd - 15
-	movdqu	W_t(idx), %xmm5		    # XMM5 = W[t-15]
+	add	WK_2(0), T1
+	movdqu	(frame_W + W_SIZE + \offset - 120)(%rsp, toff), %xmm5	    # XMM5 = W[t-15]
 	mov	e_64, tmp0
 	ror	$23, tmp0 # 41
 	movdqa	%xmm5, %xmm3	            # XMM3 = W[t-15]
@@ -219,8 +222,7 @@ frame_size = frame_WK + WK_SIZE
 	and	e_64, T1
 	xor	g_64, T1
 	psllq	$(64-19)-(64-61) , %xmm1    # XMM1 = W[t-2] << 42
-	idx = \rnd + 1
-	add	WK_2(idx), T1
+	add	WK_2(1), T1
 	mov	e_64, tmp0
 	psllq	$(64-1)-(64-8), %xmm4	    # XMM4 = W[t-15] << 7
 	ror	$23, tmp0 # 41
@@ -240,24 +242,21 @@ frame_size = frame_WK + WK_SIZE
 	pxor	%xmm1, %xmm0		    # XMM0 = s1(W[t-2])
 	mov	a_64, tmp0
 	and	c_64, tmp0
-	idx = \rnd - 7
-	movdqu	W_t(idx), %xmm1		    # XMM1 = W[t-7]
+	movdqu	(frame_W + W_SIZE + \offset - 56)(%rsp, toff), %xmm1 # XMM1 = W[t-7]
 	xor	tmp0, T2
 	pxor	%xmm4, %xmm3                # XMM3 = s0(W[t-15])
 	mov	a_64, tmp0
 	paddq	%xmm3, %xmm0		    # XMM0 = s1(W[t-2]) + s0(W[t-15])
 	ror	$5, tmp0 # 39
-	idx =\rnd-16
-	paddq	W_t(idx), %xmm0		    # XMM0 = s1(W[t-2]) + s0(W[t-15]) + W[t-16]
+	paddq	(frame_W + W_SIZE + \offset - 128)(%rsp, toff), %xmm0 # XMM0 = s1(W[t-2]) + s0(W[t-15]) + W[t-16]
 	xor	a_64, tmp0
 	paddq	%xmm1, %xmm0	            # XMM0 = s1(W[t-2]) + W[t-7] + s0(W[t-15]) + W[t-16]
 	ror	$6, tmp0 # 34
-	movdqa	%xmm0, W_t(\rnd)	    # Store scheduled qwords
+	movdqa	%xmm0, (frame_W + W_SIZE + \offset)(%rsp, toff)	    # Store scheduled qwords
 	xor	a_64, tmp0
-	paddq	K_t(\rnd), %xmm0	    # Compute W[t]+K[t]
+	paddq	(\offset + 64)(kptr, toff), %xmm0  # Compute W[t]+K[t]
 	ror	$28, tmp0 # 28
-	idx = \rnd
-	movdqa	%xmm0, WK_2(idx)	    # Store W[t]+K[t] for next rounds
+	movdqa	%xmm0, WK_2(0)		    # Store W[t]+K[t] for next rounds
 	add	tmp0, T2
 	add	T1, d_64
 	lea	(T1, T2), h_64
@@ -289,9 +288,13 @@ SYM_FUNC_START(sha512_transform_ssse3)
 	sub	$frame_size, %rsp
 	and	$~(0x20 - 1), %rsp
 
+	# Spill digest and msglen to free up %rdi and %rdx for kptr and toff.
+	mov	digest, frame_digest(%rsp)
+	mov	msglen, frame_msglen(%rsp)
+
 .Lupdateblock:
 
-# Load state variables
+	# Load state variables
 	mov	DIGEST(0), a_64
 	mov	DIGEST(1), b_64
 	mov	DIGEST(2), c_64
@@ -301,39 +304,46 @@ SYM_FUNC_START(sha512_transform_ssse3)
 	mov	DIGEST(6), g_64
 	mov	DIGEST(7), h_64
 
-	t = 0
-	.rept 80/2 + 1
-	# (80 rounds) / (2 rounds/iteration) + (1 iteration)
-	# +1 iteration because the scheduler leads hashing by 1 iteration
-		.if t < 2
-			# BSWAP 2 QWORDS
-			movdqa	XMM_QWORD_BSWAP(%rip), %xmm1
-			movdqu	MSG(t), %xmm0
-			pshufb	%xmm1, %xmm0	# BSWAP
-			movdqa	%xmm0, W_t(t)	# Store Scheduled Pair
-			paddq	K_t(t), %xmm0	# Compute W[t]+K[t]
-			movdqa	%xmm0, WK_2(t)	# Store into WK for rounds
-		.elseif t < 16
-			# BSWAP 2 QWORDS# Compute 2 Rounds
-			movdqu	MSG(t), %xmm0
-			pshufb	%xmm1, %xmm0	# BSWAP
-			SHA512_Round t-2	# Round t-2
-			movdqa	%xmm0, W_t(t)	# Store Scheduled Pair
-			paddq	K_t(t), %xmm0	# Compute W[t]+K[t]
-			SHA512_Round t-1	# Round t-1
-			movdqa	%xmm0, WK_2(t)	# Store W[t]+K[t] into WK
-		.elseif t < 79
-			# Schedule 2 QWORDS# Compute 2 Rounds
-			SHA512_2Sched_2Round_sse t
-		.else
-			# Compute 2 Rounds
-			SHA512_Round t-2
-			SHA512_Round t-1
-		.endif
+	# Rounds 0 - 13: BSWAP W[0..15] and compute rounds 0..13.
+	movdqa	XMM_QWORD_BSWAP(%rip), %xmm1
+	movdqu	MSG(0), %xmm0
+	pshufb	%xmm1, %xmm0	# BSWAP
+	movdqa	%xmm0, W_t(0)	# Store Scheduled Pair
+	paddq	K_t(0), %xmm0	# Compute W[t]+K[t]
+	movdqa	%xmm0, WK_2(0)	# Store into WK for rounds
+	t = 2
+	.rept 7
+		movdqu	MSG(t), %xmm0
+		pshufb	%xmm1, %xmm0	# BSWAP
+		SHA512_Round (t-2)	# Round t-2
+		movdqa	%xmm0, W_t(t)	# Store Scheduled Pair
+		paddq	K_t(t), %xmm0	# Compute W[t]+K[t]
+		SHA512_Round (t-1)	# Round t-1
+		movdqa	%xmm0, WK_2(t)	# Store W[t]+K[t] into WK
 		t = t+2
 	.endr
 
+	# Rounds 14 - 77: Schedule W[16..79] and compute rounds 14..77,
+	# rolled into 8 iterations of 8 rounds each.
+	lea	K512+72*8(%rip), kptr
+	mov	$-(80-16)*8, toff
+
+.align 16
+.Lsched_loop:
+	SHA512_2Sched_2Round_sse 0
+	SHA512_2Sched_2Round_sse 16
+	SHA512_2Sched_2Round_sse 32
+	SHA512_2Sched_2Round_sse 48
+
+	add	$8*8, toff
+	jnz	.Lsched_loop
+
+	# Compute last 2 Rounds
+	SHA512_Round 78
+	SHA512_Round 79
+
 	# Update digest
+	mov	frame_digest(%rsp), digest
 	add	a_64, DIGEST(0)
 	add	b_64, DIGEST(1)
 	add	c_64, DIGEST(2)
@@ -345,7 +355,7 @@ SYM_FUNC_START(sha512_transform_ssse3)
 
 	# Advance to next message block
 	add	$16*8, msg
-	dec	msglen
+	decq	frame_msglen(%rsp)
 	jnz	.Lupdateblock
 
 	# Deallocate Stack Space
-- 
2.56.1

