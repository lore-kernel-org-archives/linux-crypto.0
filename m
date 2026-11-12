Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794472237;
	b=qZJSq94W70Q0iF3lgwhFCXyvfMwkH4LbnTrfeI9xTgdfvBQRMHR/Xhat+SS33JwIANs7
	 bSPV4rAbzN4uBsaV3iPtswtXwTKDI0alEbRk3/sSKsbzjTMKUJUPWAXmUDfeD6Rcc31wa
	 7wcFNIik3X23mZxdpVkrNj4J9BB2awXDvcD3MC0xr/UKPU/y5XtTTy4H8JyT2htNe/MNt
	 fgIwacmdZ/NZDENT6TwoCeUZYY1U0Yi1psMqg7rnpAU8Zow07aHDYWOOeZ/MYmh2qXCQU
	 fEZtakwDMUQN37vW25szMYVNDR5SFmJ217fL+uGAwhbNL0cqXqxBk21MPtj8SJdjiTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794472237;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=NuHjBeX5gc2vWc4Jh/lAUZwGlGLhhUL13+fMAmvZk7I=;
	b=IxFFoYnC2pfStec0FWOqR8/mW/6S0cnW8/c2R7fuo/RyVIDCkN8vIijnSS8vlDvm+Dxz
	 EgjXKAKg1AHPFkA3qptcLcjWd8GBGmoJ+kKqkRFboUq4XhRfwQoLwz87U+BUHGS9Ke7Bs
	 ws3IuaYb5EAVCaKbTgQ2WwDYKGmg1s/F3mdXl1Ehpb4lP3ksj+Oa3+jbMQqGL2B1Er1X4
	 y5v+PSwnw3NNpb8G3OJYV5V51rK9mDVNtrmMMJkE/JbwEEN7eSVusNlRumOxFT/HKx/m6
	 cIxZORJDi6+qZBzclNn4K11DPfw1SbzTF66NZOYHhAVYYXMP5jG2cOBkCtNDxU7ngMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="enWNi+/R";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE32606A330
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 08:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=enWNi+/R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B557A1F00A09;
	Thu, 12 Nov 2026 08:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794472236;
	bh=NuHjBeX5gc2vWc4Jh/lAUZwGlGLhhUL13+fMAmvZk7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=enWNi+/R7CWxvkj13vS5Z7hxEkTF7zQIN8yt//pFZ1eufit8HTIeroSlfpFCjBe80
	 O8EBNwRwWcMPhj1zC3Mwzalv+OaC7dQZRM5Wcyi0jskaIE/hyxhvoSMcKeXd0Kej5u
	 wUbo5XvETit9o8NFhT3eQ7y67Rs/pvg91CXyjIFevxe7ob/DEYFJ1SHpKOCWkxSiWe
	 2gu0YqvRlIEp8o8ZNt/8bblCAjfwB3JlBB28ltr9OvldGJarwlUiVFAOw4CsxbIhGU
	 7iC+dP9XQwSKqHwHWCevoOUXsfmVBWK9TgG0rHgrViw7+kwEF6PwfJetLvjNReo2my
	 jNW3MaWaUDT+g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/2] lib/crypto: x86/sha512: Partially roll up sha512_transform_ssse3()
Date: Thu, 12 Nov 2026 00:28:39 -0800
Message-ID: <20261112082839.414786-3-ebiggers@kernel.org>
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
 lib/crypto/x86/sha512-ssse3-asm.S | 126 ++++++++++++++++--------------
 1 file changed, 68 insertions(+), 58 deletions(-)

diff --git a/lib/crypto/x86/sha512-ssse3-asm.S b/lib/crypto/x86/sha512-ssse3-asm.S
index 1a37b7a735cf9..4eccce486ab60 100644
--- a/lib/crypto/x86/sha512-ssse3-asm.S
+++ b/lib/crypto/x86/sha512-ssse3-asm.S
@@ -69,15 +69,20 @@ f_64 =		%r14
 g_64 =		%r15
 h_64 =		%rbx
 tmp0 =		%rax
+# Used in the rounds 14-77 loop, while digest and msglen are spilled
+kptr =		%rdi	# Pointer to K512
+toff =		%rdx	# 8*t, where W[t] is the first QWORD scheduled in the iteration.
 
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
@@ -121,8 +126,7 @@ frame_size = frame_WK + WK_SIZE
 	and	e_64, T1          # T1 = (f ^ g) & e
 	xor	e_64, tmp0        # tmp = (e ror 23) ^ e
 	xor	g_64, T1          # T1 = ((f ^ g) & e) ^ g = CH(e,f,g)
-	idx = \rnd
-	add	WK_2(idx), T1     # W[t] + K[t] from message scheduler
+	add	WK_2(\rnd), T1    # W[t] + K[t] from message scheduler
 	ror	$4, tmp0  # 18    # tmp = ((e ror 23) ^ e) ror 4
 	xor	e_64, tmp0        # tmp = (((e ror 23) ^ e) ror 4) ^ e
 	mov	a_64, T2          # T2 = a
@@ -146,18 +150,21 @@ frame_size = frame_WK + WK_SIZE
 	RotateState
 .endm
 
-.macro SHA512_2Sched_2Round_sse rnd
+.macro SHA512_2Sched_2Round_sse offset
 
 	# Compute rounds t-2 and t-1
 	# Compute message schedule QWORDS t and t+1
+	# where t = (toff + \offset) / 8
 
 	#   Two rounds are computed based on the values for K[t-2]+W[t-2] and
-	# K[t-1]+W[t-1] which were previously stored at WK_2 by the message
+	# K[t-1]+W[t-1] which were previously stored at frame_WK by the message
 	# scheduler.
-	#   The two new schedule QWORDS are stored at [W_t(%%t)] and [W_t(%%t+1)].
+	#   The two new schedule QWORDS are stored at
+	# (frame_W + \offset)(%rsp, toff) and (frame_W + \offset + 8)(%rsp, toff).
 	# They are then added to their respective SHA512 constants at
-	# [K_t(%%t)] and [K_t(%%t+1)] and stored at dqword [WK_2(%%t)]
-	#   For brievity, the comments following vectored instructions only refer to
+	# \offset(kptr, toff) and (\offset + 8)(kptr, toff) and stored at
+	# dqword frame_WK(%rsp).
+	#   For brevity, the comments following vectored instructions only refer to
 	# the first of a pair of QWORDS.
 	# Eg. XMM2=W[t-2] really means XMM2={W[t-2]|W[t-1]}
 	#   The computation of the message schedule and the rounds are tightly
@@ -167,16 +174,13 @@ frame_size = frame_WK + WK_SIZE
 	# by two tabs.
 
 	mov	f_64, T1
-	idx = \rnd -2
-	movdqa	W_t(idx), %xmm2		    # XMM2 = W[t-2]
+	movdqa	(frame_W + \offset - 16)(%rsp, toff), %xmm2	    # XMM2 = W[t-2]
 	xor	g_64, T1
 	and	e_64, T1
 	movdqa	%xmm2, %xmm0	            # XMM0 = W[t-2]
 	xor	g_64, T1
-	idx = \rnd
-	add	WK_2(idx), T1
-	idx = \rnd - 15
-	movdqu	W_t(idx), %xmm5		    # XMM5 = W[t-15]
+	add	frame_WK(%rsp), T1
+	movdqu	(frame_W + \offset - 120)(%rsp, toff), %xmm5	    # XMM5 = W[t-15]
 	mov	e_64, tmp0
 	ror	$23, tmp0 # 41
 	movdqa	%xmm5, %xmm3	            # XMM3 = W[t-15]
@@ -219,8 +223,7 @@ frame_size = frame_WK + WK_SIZE
 	and	e_64, T1
 	xor	g_64, T1
 	psllq	$(64-19)-(64-61) , %xmm1    # XMM1 = W[t-2] << 42
-	idx = \rnd + 1
-	add	WK_2(idx), T1
+	add	frame_WK + 8(%rsp), T1
 	mov	e_64, tmp0
 	psllq	$(64-1)-(64-8), %xmm4	    # XMM4 = W[t-15] << 7
 	ror	$23, tmp0 # 41
@@ -240,24 +243,21 @@ frame_size = frame_WK + WK_SIZE
 	pxor	%xmm1, %xmm0		    # XMM0 = s1(W[t-2])
 	mov	a_64, tmp0
 	and	c_64, tmp0
-	idx = \rnd - 7
-	movdqu	W_t(idx), %xmm1		    # XMM1 = W[t-7]
+	movdqu	(frame_W + \offset - 56)(%rsp, toff), %xmm1 # XMM1 = W[t-7]
 	xor	tmp0, T2
 	pxor	%xmm4, %xmm3                # XMM3 = s0(W[t-15])
 	mov	a_64, tmp0
 	paddq	%xmm3, %xmm0		    # XMM0 = s1(W[t-2]) + s0(W[t-15])
 	ror	$5, tmp0 # 39
-	idx =\rnd-16
-	paddq	W_t(idx), %xmm0		    # XMM0 = s1(W[t-2]) + s0(W[t-15]) + W[t-16]
+	paddq	(frame_W + \offset - 128)(%rsp, toff), %xmm0 # XMM0 = s1(W[t-2]) + s0(W[t-15]) + W[t-16]
 	xor	a_64, tmp0
 	paddq	%xmm1, %xmm0	            # XMM0 = s1(W[t-2]) + W[t-7] + s0(W[t-15]) + W[t-16]
 	ror	$6, tmp0 # 34
-	movdqa	%xmm0, W_t(\rnd)	    # Store scheduled qwords
+	movdqa	%xmm0, (frame_W + \offset)(%rsp, toff)	    # Store scheduled qwords
 	xor	a_64, tmp0
-	paddq	K_t(\rnd), %xmm0	    # Compute W[t]+K[t]
+	paddq	\offset(kptr, toff), %xmm0  # Compute W[t]+K[t]
 	ror	$28, tmp0 # 28
-	idx = \rnd
-	movdqa	%xmm0, WK_2(idx)	    # Store W[t]+K[t] for next rounds
+	movdqa	%xmm0, frame_WK(%rsp)	    # Store W[t]+K[t] for next rounds
 	add	tmp0, T2
 	add	T1, d_64
 	lea	(T1, T2), h_64
@@ -289,9 +289,13 @@ SYM_FUNC_START(sha512_transform_ssse3)
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
@@ -301,39 +305,45 @@ SYM_FUNC_START(sha512_transform_ssse3)
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
-		t = t+2
+	# Rounds 0 - 13: BSWAP 2 QWORDS and compute 2 rounds
+	movdqa	XMM_QWORD_BSWAP(%rip), %xmm1
+	movdqu	MSG(0), %xmm0
+	pshufb	%xmm1, %xmm0	# BSWAP
+	movdqa	%xmm0, W_t(0)	# Store Scheduled Pair
+	paddq	K_t(0), %xmm0	# Compute W[t]+K[t]
+	movdqa	%xmm0, WK_2(0)	# Store into WK for rounds
+	.irp t, 2,4,6,8,10,12,14
+		movdqu	MSG(\t), %xmm0
+		pshufb	%xmm1, %xmm0	# BSWAP
+		SHA512_Round (\t-2)	# Round t-2
+		movdqa	%xmm0, W_t(\t)	# Store Scheduled Pair
+		paddq	K_t(\t), %xmm0	# Compute W[t]+K[t]
+		SHA512_Round (\t-1)	# Round t-1
+		movdqa	%xmm0, WK_2(\t)	# Store W[t]+K[t] into WK
 	.endr
 
+	# Rounds 14 - 77: Schedule 2 QWORDS and compute 2 rounds,
+	# rolled into 8 iterations of 8 rounds.
+	lea	K512(%rip), kptr
+	mov	$16*8, toff
+
+.p2align 4
+.Lsched_loop:
+	SHA512_2Sched_2Round_sse 0
+	SHA512_2Sched_2Round_sse 16
+	SHA512_2Sched_2Round_sse 32
+	SHA512_2Sched_2Round_sse 48
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

