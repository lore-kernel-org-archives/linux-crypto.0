Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794472237;
	b=ffi2i63ju2IWwOiAfsbqI9XGYiDfVII4j2XvUvDV9Qzyd1eBd+ir/ojAEAm8o1TEp1PS
	 KV/p5cEWeHjWd/27M+S4c5hlMxifQ/WY5kw6hvQORz6pMVUrdGVd7inELFpqWECGxZJM5
	 yJSmEqIC7oCugvBdlOBzDYYyYEsZ7v9BFzstMdfj9kbjlsOT9xKGcNtZWjNgCOwXZrLkm
	 FVHeYVLjx5YK0RPRkMfuB/0HC11u1lql/9ycWvr70CJUpLP5B7z6r4vq6KM2ju1c9G3p8
	 pqIEWAAvd3My4huSLy5JY1R0QAnKLpyeEKYUnFXHesIvZQ4H9XYCVn0We+8tuQ093MA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794472237;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=P9LTv2Z+ivoHkWSQg9eeDO726LSjkAqJE0PxpuMi++A=;
	b=cPSdm350aOKGt4krVm/jsW3fPv4RcVdHtIOs2hjDYAcqbQvXDqMWT2vwDrOyEZsuQxm3
	 NV0ahp1+pQ9XD2+QDVCUAHXq1i2STlP31GlH5whvO+pO7kM3/Y3uGhV/+z2T3kthKDRP5
	 hFZsBaQ1zR1BKbrW6XBg+RQnWpUARfpDJzSG7lu8DMzF0qSUC5OEWwHcUcIsccIkFe7ix
	 yrb5sAJ/jAXOH8v1BFUBl/q9MUqdFQV9Sy+l/+wemtUA3rP6AShNgd9+Pc80zO64IAMD9
	 ZNMKZ0PxWPuti+R6aZbviBC0VpgVeMpfocEZjhC8G/Jz8GovKZ/3Rm3wLntIL3W4R0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PjeVJKwL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC2D606A32A
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 08:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PjeVJKwL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651C91F00A0A;
	Thu, 12 Nov 2026 08:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794472236;
	bh=P9LTv2Z+ivoHkWSQg9eeDO726LSjkAqJE0PxpuMi++A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PjeVJKwLpG3rw9UxhNTYDfrkE95U+ys43W5HzgpeERgxL/1n0bFKN/GGYiH+I7PS0
	 uJMODEd5tdGtkkTYg0+vyqiBTtUCpyLNkCzlzL5qnRLPk2fyw/dZ1SljXgA3vBPuPp
	 jTlc1IYFWIIIFidVj4GcQPzq7OzjOUDa8Hwu9yt1kwko2+8uhRENIeUIba1wpeHJQ1
	 IAU7L7XhkXLAAD+G4oi+1WNRyveOB/ie+vFVV/WPSR0Gd66nsnV+Cd5FQ8XUO4ldgA
	 dBP6qX1oj0QUhqqnxJByWvXhrkLfIB9Pp0b7pHoF6d32IuCRQ7IEO8q/wu+TsoJp8q
	 CHejN9Gy8mM9Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 1/2] lib/crypto: x86/sha512: Partially roll up sha512_transform_avx()
Date: Thu, 12 Nov 2026 00:28:38 -0800
Message-ID: <20261112082839.414786-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261112082839.414786-1-ebiggers@kernel.org>
References: <20261112082839.414786-1-ebiggers@kernel.org>
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

Currently, sha512_transform_avx() unrolls all 80 SHA-512 rounds,
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
easily get access to) with the AVX2 code disabled.  SHA-512 throughput
actually increased by 8% as a result of this commit, likely as a result
of the code fitting much better into caches.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/sha512-avx-asm.S | 124 +++++++++++++++++---------------
 1 file changed, 67 insertions(+), 57 deletions(-)

diff --git a/lib/crypto/x86/sha512-avx-asm.S b/lib/crypto/x86/sha512-avx-asm.S
index a17dfedc1c519..b6c496fde8471 100644
--- a/lib/crypto/x86/sha512-avx-asm.S
+++ b/lib/crypto/x86/sha512-avx-asm.S
@@ -69,6 +69,9 @@ f_64	= %r14
 g_64	= %r15
 h_64	= %rbx
 tmp0	= %rax
+# Used in the rounds 14-77 loop, while digest and msglen are spilled
+kptr	= %rdi	# Pointer to K512
+toff	= %rdx	# 8*t, where W[t] is the first QWORD scheduled in the iteration.
 
 # Local variables (stack frame)
 
@@ -77,9 +80,11 @@ W_SIZE = 80*8
 # W[t] + K[t] | W[t+1] + K[t+1]
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
@@ -127,8 +132,7 @@ frame_size = frame_WK + WK_SIZE
 	and     e_64, T1          # T1 = (f ^ g) & e
 	xor     e_64, tmp0        # tmp = (e ror 23) ^ e
 	xor     g_64, T1          # T1 = ((f ^ g) & e) ^ g = CH(e,f,g)
-	idx = \rnd
-	add     WK_2(idx), T1     # W[t] + K[t] from message scheduler
+	add     WK_2(\rnd), T1    # W[t] + K[t] from message scheduler
 	RORQ    tmp0, 4   # 18    # tmp = ((e ror 23) ^ e) ror 4
 	xor     e_64, tmp0        # tmp = (((e ror 23) ^ e) ror 4) ^ e
 	mov     a_64, T2          # T2 = a
@@ -152,26 +156,27 @@ frame_size = frame_WK + WK_SIZE
 	RotateState
 .endm
 
-.macro SHA512_2Sched_2Round_avx rnd
+.macro SHA512_2Sched_2Round_avx offset
 	# Compute rounds t-2 and t-1
 	# Compute message schedule QWORDS t and t+1
+	# where t = (toff + \offset) / 8
 
 	#   Two rounds are computed based on the values for K[t-2]+W[t-2] and
-	# K[t-1]+W[t-1] which were previously stored at WK_2 by the message
+	# K[t-1]+W[t-1] which were previously stored at frame_WK by the message
 	# scheduler.
-	#   The two new schedule QWORDS are stored at [W_t(t)] and [W_t(t+1)].
+	#   The two new schedule QWORDS are stored at
+	# (frame_W + \offset)(%rsp, toff) and (frame_W + \offset + 8)(%rsp, toff).
 	# They are then added to their respective SHA512 constants at
-	# [K_t(t)] and [K_t(t+1)] and stored at dqword [WK_2(t)]
-	#   For brievity, the comments following vectored instructions only refer to
+	# \offset(kptr, toff) and (\offset + 8)(kptr, toff) and stored at
+	# dqword frame_WK(%rsp).
+	#   For brevity, the comments following vectored instructions only refer to
 	# the first of a pair of QWORDS.
 	# Eg. XMM4=W[t-2] really means XMM4={W[t-2]|W[t-1]}
 	#   The computation of the message schedule and the rounds are tightly
 	# stitched to take advantage of instruction-level parallelism.
 
-	idx = \rnd - 2
-	vmovdqa	W_t(idx), %xmm4		# XMM4 = W[t-2]
-	idx = \rnd - 15
-	vmovdqu	W_t(idx), %xmm5		# XMM5 = W[t-15]
+	vmovdqa	(frame_W + \offset - 16)(%rsp, toff), %xmm4	# XMM4 = W[t-2]
+	vmovdqu	(frame_W + \offset - 120)(%rsp, toff), %xmm5	# XMM5 = W[t-15]
 	mov	f_64, T1
 	vpsrlq	$61, %xmm4, %xmm0	# XMM0 = W[t-2]>>61
 	mov	e_64, tmp0
@@ -183,8 +188,7 @@ frame_size = frame_WK + WK_SIZE
 	xor	e_64, tmp0
 	vpxor	%xmm1, %xmm0, %xmm0	# XMM0 = W[t-2]>>61 ^ W[t-2]>>19
 	xor	g_64, T1
-	idx = \rnd
-	add	WK_2(idx), T1#
+	add	frame_WK(%rsp), T1
 	vpsrlq	$8, %xmm5, %xmm7	# XMM7 = W[t-15]>>8
 	RORQ	tmp0, 4 # 18
 	vpsrlq	$6, %xmm4, %xmm2	# XMM2 = W[t-2]>>6
@@ -223,17 +227,14 @@ frame_size = frame_WK + WK_SIZE
 	vpxor	%xmm2, %xmm0, %xmm0     # XMM0 = s1(W[t-2])
 	mov	e_64, tmp0
 	xor	g_64, T1
-	idx = \rnd - 16
-	vpaddq	W_t(idx), %xmm0, %xmm0  # XMM0 = s1(W[t-2]) + W[t-16]
-	idx = \rnd - 7
-	vmovdqu	W_t(idx), %xmm1		# XMM1 = W[t-7]
+	vpaddq	(frame_W + \offset - 128)(%rsp, toff), %xmm0, %xmm0  # XMM0 = s1(W[t-2]) + W[t-16]
+	vmovdqu	(frame_W + \offset - 56)(%rsp, toff), %xmm1	# XMM1 = W[t-7]
 	RORQ	tmp0, 23 # 41
 	and	e_64, T1
 	xor	e_64, tmp0
 	xor	g_64, T1
 	vpsllq	$(64-8), %xmm5, %xmm5   # XMM5 = W[t-15]<<56
-	idx = \rnd + 1
-	add	WK_2(idx), T1
+	add	frame_WK + 8(%rsp), T1
 	vpxor	%xmm5, %xmm6, %xmm6     # XMM6 = s0(W[t-15])
 	RORQ	tmp0, 4 # 18
 	vpaddq	%xmm6, %xmm0, %xmm0     # XMM0 = s1(W[t-2]) + W[t-16] + s0(W[t-15])
@@ -244,10 +245,9 @@ frame_size = frame_WK + WK_SIZE
 	add	h_64, T1
 	RORQ	tmp0, 14 # 14
 	add	tmp0, T1
-	idx = \rnd
-	vmovdqa	%xmm0, W_t(idx)		# Store W[t]
-	vpaddq	K_t(idx), %xmm0, %xmm0  # Compute W[t]+K[t]
-	vmovdqa	%xmm0, WK_2(idx)	# Store W[t]+K[t] for next rounds
+	vmovdqa	%xmm0, (frame_W + \offset)(%rsp, toff)	# Store W[t]
+	vpaddq	\offset(kptr, toff), %xmm0, %xmm0  # Compute W[t]+K[t]
+	vmovdqa	%xmm0, frame_WK(%rsp)	# Store W[t]+K[t] for next rounds
 	mov	a_64, tmp0
 	xor	c_64, T2
 	and	c_64, tmp0
@@ -290,6 +290,10 @@ SYM_FUNC_START(sha512_transform_avx)
 	sub     $frame_size, %rsp
 	and	$~(0x20 - 1), %rsp
 
+	# Spill digest and msglen to free up %rdi and %rdx for kptr and toff.
+	mov     digest, frame_digest(%rsp)
+	mov     msglen, frame_msglen(%rsp)
+
 .Lupdateblock:
 
 	# Load state variables
@@ -302,39 +306,45 @@ SYM_FUNC_START(sha512_transform_avx)
 	mov     DIGEST(6), g_64
 	mov     DIGEST(7), h_64
 
-	t = 0
-	.rept 80/2 + 1
-	# (80 rounds) / (2 rounds/iteration) + (1 iteration)
-	# +1 iteration because the scheduler leads hashing by 1 iteration
-		.if t < 2
-			# BSWAP 2 QWORDS
-			vmovdqa  XMM_QWORD_BSWAP(%rip), %xmm1
-			vmovdqu  MSG(t), %xmm0
-			vpshufb  %xmm1, %xmm0, %xmm0    # BSWAP
-			vmovdqa  %xmm0, W_t(t) # Store Scheduled Pair
-			vpaddq   K_t(t), %xmm0, %xmm0 # Compute W[t]+K[t]
-			vmovdqa  %xmm0, WK_2(t) # Store into WK for rounds
-		.elseif t < 16
-			# BSWAP 2 QWORDS# Compute 2 Rounds
-			vmovdqu  MSG(t), %xmm0
-			vpshufb  %xmm1, %xmm0, %xmm0    # BSWAP
-			SHA512_Round t-2    # Round t-2
-			vmovdqa  %xmm0, W_t(t) # Store Scheduled Pair
-			vpaddq   K_t(t), %xmm0, %xmm0 # Compute W[t]+K[t]
-			SHA512_Round t-1    # Round t-1
-			vmovdqa  %xmm0, WK_2(t)# Store W[t]+K[t] into WK
-		.elseif t < 79
-			# Schedule 2 QWORDS# Compute 2 Rounds
-			SHA512_2Sched_2Round_avx t
-		.else
-			# Compute 2 Rounds
-			SHA512_Round t-2
-			SHA512_Round t-1
-		.endif
-		t = t+2
+	# Rounds 0 - 13: BSWAP 2 QWORDS and compute 2 rounds
+	vmovdqa  XMM_QWORD_BSWAP(%rip), %xmm1
+	vmovdqu  MSG(0), %xmm0
+	vpshufb  %xmm1, %xmm0, %xmm0    # BSWAP
+	vmovdqa  %xmm0, W_t(0) # Store Scheduled Pair
+	vpaddq   K_t(0), %xmm0, %xmm0 # Compute W[t]+K[t]
+	vmovdqa  %xmm0, WK_2(0) # Store into WK for rounds
+	.irp t, 2,4,6,8,10,12,14
+		vmovdqu  MSG(\t), %xmm0
+		vpshufb  %xmm1, %xmm0, %xmm0    # BSWAP
+		SHA512_Round (\t-2)    # Round t-2
+		vmovdqa  %xmm0, W_t(\t) # Store Scheduled Pair
+		vpaddq   K_t(\t), %xmm0, %xmm0 # Compute W[t]+K[t]
+		SHA512_Round (\t-1)    # Round t-1
+		vmovdqa  %xmm0, WK_2(\t)# Store W[t]+K[t] into WK
 	.endr
 
+	# Rounds 14 - 77: Schedule 2 QWORDS and compute 2 rounds,
+	# rolled into 8 iterations of 8 rounds.
+	lea	K512(%rip), kptr
+	mov	$16*8, toff
+
+.p2align 4
+.Lsched_loop:
+	SHA512_2Sched_2Round_avx 0
+	SHA512_2Sched_2Round_avx 16
+	SHA512_2Sched_2Round_avx 32
+	SHA512_2Sched_2Round_avx 48
+
+	add	$8*8, toff
+	cmp	$80*8, toff
+	jne	.Lsched_loop
+
+	# Compute last 2 Rounds
+	SHA512_Round 78
+	SHA512_Round 79
+
 	# Update digest
+	mov     frame_digest(%rsp), digest
 	add     a_64, DIGEST(0)
 	add     b_64, DIGEST(1)
 	add     c_64, DIGEST(2)
@@ -346,7 +356,7 @@ SYM_FUNC_START(sha512_transform_avx)
 
 	# Advance to next message block
 	add     $16*8, msg
-	dec     msglen
+	decq    frame_msglen(%rsp)
 	jnz     .Lupdateblock
 
 	# Deallocate Stack Space
-- 
2.56.1

