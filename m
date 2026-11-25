Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795581150;
	b=vc7MZPrhzIQzL7J2+8yhyjxkrWc4ghGCz3a+ADin+dcpwn2XlU0parwYjNXeYJnvQ66K
	 g4x4hURCytNTQBbagrZzIolhO6dPFBgrwZpQLQKzuR9GDdvBjkb2XuBmLJzLy4mmMTxwH
	 LS8yeIo/wn2HQyHw4hDUiYWtmx3zycBO/5pXzyXnyP7F4B27v+u0g7vUAD/1mvR2AsaLr
	 DP92D5YiC1YMkbqUEAH5KBVHsJ/mpcFtMX2KsywI16fessFtvdMJLCeOy0pyHZkOO9mHO
	 D9UIOWJz3rFD6arFVtSjMNp/0fODo0H4s/s7OFyA6V/YzfwfIPebLu8LVWe96T0gmZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795581150;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mg3TrRz553/lUUn8Q+mmiUj5bIi4dS0hcxCVNVQnLeI=;
	b=SPm9geze8j8mVUIdtsTJ+9z9L/+uZDQAYHzlAt5P2FyYfSHb5GL5+1oKhPucNUCs+mEB
	 tlioXgbi4hRF5MPBQOPXFKgJIvwkhaoe2A9TQpS5KknN+ZczuSmLtDmDdlb53opjWVkeU
	 5nhoaRJtkH+vXg7qlwQlIaPItOseVjNKIkMkH2Bbj0Bf78QOVF1RrsXBeOySPctCCnuPq
	 kbFGJWT6Wgu5NPt0s2oGaobtVSJK2pgYeQkc9MN/oLmg8Yn7rSln9SxIVzGn/ETirxCAz
	 jD+tJAKfVgMTeA2P4g60QklS0wNKAhDpUmHJzpe/0z179GLNrVY+buDu514aWETU/CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mee4vhat;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E8D606A321
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 04:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mee4vhat
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69E21F000C6;
	Wed, 25 Nov 2026 04:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795581150;
	bh=Mg3TrRz553/lUUn8Q+mmiUj5bIi4dS0hcxCVNVQnLeI=;
	h=From:To:Cc:Subject:Date;
	b=Mee4vhat5Y7Rt4K+GG5XtW+qMm7iuJvL64+ytDvOt6bs6Vut1jUyyvjRvJ1VcwTpc
	 mmHG+pHDZs2QWxqGx84i/uvxwynKBASyBZr6yRT2j3YpsaZblzERsvbCXU3gpKtkBu
	 mHQm8IHBjLlyyx0mZDjKiX6d8PbkRKNcO96dm2MgiVobsQGjXopfznLEb9g1a5v+/W
	 EHmDEiRCb0kQNJZ8ABIV15a9Ubd4knR40HROqSlUF0KGe3TIC7N1RIgJqsgUJTl/qs
	 3f06SouSyQVlGxGa/Gp12N4PBiv6FtinV0zTtMrJCaC8g/jbEkNCSVMbXJllo8aFfE
	 XLWrtL7HZH9Tg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: x86/sha512-ssse3: Roll up rounds and reduce stack usage
Date: Tue, 24 Nov 2026 20:31:59 -0800
Message-ID: <20261125043159.192004-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.1
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
producing 13.4 KB of text.  It also stores all 80 message schedule words
in a 640-byte stack buffer, which wasn't being zeroized on exit either.

Shrink both of these to more reasonable sizes (4.7 KB of text, and a
136-byte stack buffer that's zeroized on exit) by doing rounds 14
through 77 in a loop that does 4 iterations of 16 rounds each, and by
using a circular buffer to hold the message schedule words.

The circular buffer works well because each message schedule word in
SHA-512 is computed only from words in the last 16 words.  The number of
rounds per iteration is set to 16 to match the circular buffer size.
(It's also a multiple of 8, which is how often the state cycles around.)

The message schedule could also be stored in XMM registers, but that
approach was found to add additional overhead on older CPUs.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This is an alternative to the series
https://lore.kernel.org/linux-crypto/20261122022030.296468-1-ebiggers@kernel.org/
It does 16 rounds per iteration instead of 8, and it replaces the huge
on-stack buffer with a circular buffer instead of with XMM registers.
This hopefully avoids any measurable regression on older CPUs, while
still achieving the two main cleanups.

 lib/crypto/x86/sha512-ssse3-asm.S | 157 +++++++++++++++++-------------
 1 file changed, 92 insertions(+), 65 deletions(-)

diff --git a/lib/crypto/x86/sha512-ssse3-asm.S b/lib/crypto/x86/sha512-ssse3-asm.S
index 1a37b7a735cf9..d6e87bb6173c9 100644
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
@@ -69,15 +70,20 @@ f_64 =		%r14
 g_64 =		%r15
 h_64 =		%rbx
 tmp0 =		%rax
+# Used in the rounds 14-77 loop, while digest and msglen are spilled
+kptr =		%rdi	# Pointer to K512[t] for the current 16-round iteration
+loop_cnt =	%edx	# Remaining 16-round iterations in .Lsched_loop
 
 # Local variables (stack frame)
 
-W_SIZE = 80*8
+W_SIZE = 17*8		# 16-QWORD circular buffer + 1 duplicate of W_t(0)
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
@@ -92,11 +98,11 @@ frame_size = frame_WK + WK_SIZE
 # SHA Constants (static mem)
 #define K_t(i)    8*i+K512(%rip)
 
-# Message Schedule (stack frame)
-#define W_t(i)    8*i+frame_W(%rsp)
+# Message Schedule circular buffer (stack frame)
+#define W_t(i)    8*(i)+frame_W(%rsp)
 
 # W[t]+K[t] (stack frame)
-#define WK_2(i)   8*((i%2))+frame_WK(%rsp)
+#define WK_2(i)   8*(((i)%2))+frame_WK(%rsp)
 
 .macro RotateState
 	# Rotate symbols a..h right
@@ -121,8 +127,7 @@ frame_size = frame_WK + WK_SIZE
 	and	e_64, T1          # T1 = (f ^ g) & e
 	xor	e_64, tmp0        # tmp = (e ror 23) ^ e
 	xor	g_64, T1          # T1 = ((f ^ g) & e) ^ g = CH(e,f,g)
-	idx = \rnd
-	add	WK_2(idx), T1     # W[t] + K[t] from message scheduler
+	add	WK_2(\rnd), T1    # W[t] + K[t] from message scheduler
 	ror	$4, tmp0  # 18    # tmp = ((e ror 23) ^ e) ror 4
 	xor	e_64, tmp0        # tmp = (((e ror 23) ^ e) ror 4) ^ e
 	mov	a_64, T2          # T2 = a
@@ -146,37 +151,35 @@ frame_size = frame_WK + WK_SIZE
 	RotateState
 .endm
 
-.macro SHA512_2Sched_2Round_sse rnd
+.macro SHA512_2Sched_2Round_sse idx
 
 	# Compute rounds t-2 and t-1
 	# Compute message schedule QWORDS t and t+1
+	# \idx is t mod 16 and must be even.
 
 	#   Two rounds are computed based on the values for K[t-2]+W[t-2] and
 	# K[t-1]+W[t-1] which were previously stored at WK_2 by the message
 	# scheduler.
-	#   The two new schedule QWORDS are stored at [W_t(%%t)] and [W_t(%%t+1)].
-	# They are then added to their respective SHA512 constants at
-	# [K_t(%%t)] and [K_t(%%t+1)] and stored at dqword [WK_2(%%t)]
-	#   For brievity, the comments following vectored instructions only refer to
+	#   The two new schedule QWORDS are stored in the 16-QWORD circular
+	# buffer at W_t(\idx) and W_t(\idx + 1).  When \idx == 0, W[t] is also
+	# mirrored at W_t(16) so that odd-indexed wrap-around loads at W_t(15)
+	# read {W_t(15), W_t(0)} with a single unaligned load.
+	#   They are then added to their respective SHA512 constants at
+	# (8*\idx)(kptr) and (8*\idx + 8)(kptr) and stored at dqword WK_2(0).
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
+	movdqa	W_t((\idx - 2) & 15), %xmm2 # XMM2 = W[t-2]
 	xor	g_64, T1
 	and	e_64, T1
 	movdqa	%xmm2, %xmm0	            # XMM0 = W[t-2]
 	xor	g_64, T1
-	idx = \rnd
-	add	WK_2(idx), T1
-	idx = \rnd - 15
-	movdqu	W_t(idx), %xmm5		    # XMM5 = W[t-15]
+	add	WK_2(0), T1
+	movdqu	W_t((\idx - 15) & 15), %xmm5 # XMM5 = W[t-15]
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
@@ -240,24 +242,24 @@ frame_size = frame_WK + WK_SIZE
 	pxor	%xmm1, %xmm0		    # XMM0 = s1(W[t-2])
 	mov	a_64, tmp0
 	and	c_64, tmp0
-	idx = \rnd - 7
-	movdqu	W_t(idx), %xmm1		    # XMM1 = W[t-7]
+	movdqu	W_t((\idx - 7) & 15), %xmm1 # XMM1 = W[t-7]
 	xor	tmp0, T2
 	pxor	%xmm4, %xmm3                # XMM3 = s0(W[t-15])
 	mov	a_64, tmp0
 	paddq	%xmm3, %xmm0		    # XMM0 = s1(W[t-2]) + s0(W[t-15])
 	ror	$5, tmp0 # 39
-	idx =\rnd-16
-	paddq	W_t(idx), %xmm0		    # XMM0 = s1(W[t-2]) + s0(W[t-15]) + W[t-16]
+	paddq	W_t(\idx), %xmm0	    # XMM0 = s1(W[t-2]) + s0(W[t-15]) + W[t-16]
 	xor	a_64, tmp0
-	paddq	%xmm1, %xmm0	            # XMM0 = s1(W[t-2]) + W[t-7] + s0(W[t-15]) + W[t-16]
+	paddq	%xmm1, %xmm0		    # XMM0 = s1(W[t-2]) + W[t-7] + s0(W[t-15]) + W[t-16]
 	ror	$6, tmp0 # 34
-	movdqa	%xmm0, W_t(\rnd)	    # Store scheduled qwords
+	movdqa	%xmm0, W_t(\idx)	    # Store scheduled qwords
+	.if \idx == 0
+	movq	%xmm0, W_t(16)		    # Mirror W[t] for wrap-around loads at W_t(15)
+	.endif
 	xor	a_64, tmp0
-	paddq	K_t(\rnd), %xmm0	    # Compute W[t]+K[t]
+	paddq	(8*\idx)(kptr), %xmm0	    # Compute W[t]+K[t]
 	ror	$28, tmp0 # 28
-	idx = \rnd
-	movdqa	%xmm0, WK_2(idx)	    # Store W[t]+K[t] for next rounds
+	movdqa	%xmm0, WK_2(0)		    # Store W[t]+K[t] for next rounds
 	add	tmp0, T2
 	add	T1, d_64
 	lea	(T1, T2), h_64
@@ -289,9 +291,13 @@ SYM_FUNC_START(sha512_transform_ssse3)
 	sub	$frame_size, %rsp
 	and	$~(0x20 - 1), %rsp
 
+	# Spill digest and msglen to free up %rdi and %rdx for kptr and loop_cnt.
+	mov	digest, frame_digest(%rsp)
+	mov	msglen, frame_msglen(%rsp)
+
 .Lupdateblock:
 
-# Load state variables
+	# Load state variables
 	mov	DIGEST(0), a_64
 	mov	DIGEST(1), b_64
 	mov	DIGEST(2), c_64
@@ -301,39 +307,52 @@ SYM_FUNC_START(sha512_transform_ssse3)
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
+	# Rounds 0 - 13: BSWAP W[0..15] into W_t(0..15) and compute rounds 0..13.
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
+	# rolled into 4 iterations of 16 rounds each using the 16-QWORD
+	# circular stack buffer W_t(0..15) (plus mirror W_t(16) = W_t(0)).
+	lea	K512+16*8(%rip), kptr
+	mov	$4, loop_cnt
+
+.align 16
+.Lsched_loop:
+	SHA512_2Sched_2Round_sse 0
+	SHA512_2Sched_2Round_sse 2
+	SHA512_2Sched_2Round_sse 4
+	SHA512_2Sched_2Round_sse 6
+	SHA512_2Sched_2Round_sse 8
+	SHA512_2Sched_2Round_sse 10
+	SHA512_2Sched_2Round_sse 12
+	SHA512_2Sched_2Round_sse 14
+
+	add	$16*8, kptr
+	dec	loop_cnt
+	jnz	.Lsched_loop
+
+	# Rounds 78 - 79
+	SHA512_Round 78
+	SHA512_Round 79
+
 	# Update digest
+	mov	frame_digest(%rsp), digest
 	add	a_64, DIGEST(0)
 	add	b_64, DIGEST(1)
 	add	c_64, DIGEST(2)
@@ -345,9 +364,17 @@ SYM_FUNC_START(sha512_transform_ssse3)
 
 	# Advance to next message block
 	add	$16*8, msg
-	dec	msglen
+	decq	frame_msglen(%rsp)
 	jnz	.Lupdateblock
 
+	# Zeroize frame_WK and frame_W before returning.
+	pxor	%xmm0, %xmm0
+	movdqa	%xmm0, WK_2(0)
+	.irp i, 0,2,4,6,8,10,12,14
+		movdqa	%xmm0, W_t(\i)
+	.endr
+	movq	%xmm0, W_t(16)
+
 	# Deallocate Stack Space
 	lea	-40(%rbp), %rsp
 

base-commit: 545e1d3be5c67dc538d973fb8eec6cc9aa929ce5
-- 
2.56.1

