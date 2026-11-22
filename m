Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795314067;
	b=HS5Otqr9DQR7A3BuiaB7T3G7eNYBWNFwqlWOnPBr49VkDZdVMb5N81qXl25Qo3xxzEZq
	 Vha75d2ehWN/YLU4FTAedW5ev5JznD/KCDYbn5tSTcEsGTZNdtH8EFhnAFhvUNeeyVpzR
	 XDJKNbNFb9QkkMzAvCDw+7qbleNDM/phECpB+e/4pLNq+/p5G8pT2EVRSSueM5qgDodXE
	 ybaU7385mautB2t13M9iurDDHu98PahFw0RCi7PFZtmIUT1oPPqv8OLglXVzr44O25x5c
	 5s5PcoOajHHjjpJcvUU00wdzjygyohFMkArMrSLa1AtnnFmmbNUel73XIQfTal1VswA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795314067;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=miH35ugc5QCHqGthZkhvAcooKQVDnv3MqWjrs40KKqg=;
	b=kng0CQO9dtN6IYnrnjT3rkZVskiK9Y4D0VWCXmibQFBh7pwJ0vvItpkEM9MpgqNRpkOb
	 Oqwfxa8rKtjs8cRuXEUrLmosgo6K8OzR39WHusqrx+SNwqZighIlAJQ9E4khDe3ZbLcaC
	 V5d9/7QdPikYh/UnCUlZ59TSUmQqDB0kBNQHw3nVdWfS9cs67nlqKFZLU5jfIIvKrGqXt
	 vwPl78zFUWR+w2jebqkbaSUwh2Xn0393+reUoH27xBFG6o977YbZ9jQrZe3IzDC/8O7Rg
	 UoMj/aoIqMAp180CfGaAho3szK7n1mZGUbH0tRrtyQrc5aOmtLupAsBJYu+SgYo+2+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BM+1prbu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5A9606A335
	for <linux-crypto@vger.kernel.org>; Sun, 22 Nov 2026 02:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BM+1prbu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4869C1F000D0;
	Sun, 22 Nov 2026 02:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795314067;
	bh=miH35ugc5QCHqGthZkhvAcooKQVDnv3MqWjrs40KKqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BM+1prbu7+Q+cs/PdZpvDfqBZ8k/bE51LoFkQgM1RmSpXq3TlcHRetsioE4NC4A2Z
	 i6Zp5+c3GBrehGuIWQIjSPjp+vVRiOePZ09w2Gj7SbrMe1BflgUO7WTWdXK/gXFit7
	 mwvv3MQwOZc9DTRRN8n54B3llnYetUBwOe6B2oVQsGTNrKr4E8mHI1uLGorggyBg/N
	 Q8GvSewKLJenHJRSE2RXCmAn0WPRsZQBhnWPtVbIUCVt7URYkLTaVsFlk7wdlkF1j7
	 ciKRCTHtEMoC39B7WBbAIhPJib6HDnSGv9WYox8t1ogNtiv+akfxRqdpBuG0ShAtyD
	 C0nyQXFzlnWAA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 3/8] lib/crypto: x86/sha512: Keep W[t]+K[t] in %xmm5 instead of stack
Date: Sat, 21 Nov 2026 18:20:25 -0800
Message-ID: <20261122022030.296468-4-ebiggers@kernel.org>
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

Instead of bouncing each pair of precomputed W[t] + K[t] values from XMM
to GPRs through a 16-byte stack buffer ('frame_WK'), keep the pair in
%xmm5 and transfer each word directly to a GPR using movq and psrldq.

This avoids stack round-trips, and it removes the remaining unzeroized
stack buffer that held input-derived data.  Moreover, it eliminates the
last use of the stack at all besides the (digest, msglen) pair which
don't require 16-byte alignment.  Thus the dynamic alignment and need to
maintain %rbp go away too, and we can eliminate the frame abstraction
entirely and just handle (digest, msglen) using pushes.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/sha512-ssse3-asm.S | 80 +++++++++++++------------------
 1 file changed, 33 insertions(+), 47 deletions(-)

diff --git a/lib/crypto/x86/sha512-ssse3-asm.S b/lib/crypto/x86/sha512-ssse3-asm.S
index fe72ceb6a2735..f2a43c4ac8bec 100644
--- a/lib/crypto/x86/sha512-ssse3-asm.S
+++ b/lib/crypto/x86/sha512-ssse3-asm.S
@@ -74,6 +74,7 @@ tmp0 =		%rax
 kptr =		%rdi	# Pointer to K512[72]
 toff =		%rdx	# 8*(t - 80), where W[t] is the first QWORD scheduled in the iteration.
 
+XWK =		%xmm5	# {W[t]+K[t], W[t+1]+K[t+1]} for the next two rounds
 # Rolling window of the last 16 message schedule QWORDs:
 # XW0 = {W[t-16], W[t-15]}, ..., XW7 = {W[t-2], W[t-1]}
 XW0 =		%xmm6
@@ -85,18 +86,8 @@ XW5 =		%xmm11
 XW6 =		%xmm12
 XW7 =		%xmm13
 
-# Local variables (stack frame)
-
-WK_SIZE = 2*8
-
-frame_WK = 0
-frame_digest = frame_WK + WK_SIZE
-frame_msglen = frame_digest + 8
-frame_size = frame_msglen + 8
-
 # Useful QWORD "arrays" for simpler memory references
 # MSG, DIGEST, K_t are arrays
-# WK_2(t) points to 1 of 2 qwords at frame.WK depending on t being odd/even
 
 # Input message (arg1)
 #define MSG(i)    8*i(msg)
@@ -107,9 +98,6 @@ frame_size = frame_msglen + 8
 # SHA Constants (static mem)
 #define K_t(i)    8*i+K512(%rip)
 
-# W[t]+K[t] (stack frame)
-#define WK_2(i)   8*((i%2))+frame_WK(%rsp)
-
 .macro RotateXW
 	# Rotate symbols XW0..XW7 left
 	XWTMP = XW0
@@ -139,6 +127,12 @@ frame_size = frame_msglen + 8
 .macro SHA512_Round rnd
 
 	# Compute Round %%t
+	.if ((\rnd) % 2) == 0
+		movq	XWK, T2
+	.else
+		psrldq	$8, XWK
+		movq	XWK, T2
+	.endif
 	mov	f_64, T1          # T1 = f
 	mov	e_64, tmp0        # tmp = e
 	xor	g_64, T1          # T1 = f ^ g
@@ -146,8 +140,7 @@ frame_size = frame_msglen + 8
 	and	e_64, T1          # T1 = (f ^ g) & e
 	xor	e_64, tmp0        # tmp = (e ror 23) ^ e
 	xor	g_64, T1          # T1 = ((f ^ g) & e) ^ g = CH(e,f,g)
-	idx = \rnd
-	add	WK_2(idx), T1     # W[t] + K[t] from message scheduler
+	add	T2, T1            # + W[t] + K[t] from message scheduler
 	ror	$4, tmp0  # 18    # tmp = ((e ror 23) ^ e) ror 4
 	xor	e_64, tmp0        # tmp = (((e ror 23) ^ e) ror 4) ^ e
 	mov	a_64, T2          # T2 = a
@@ -178,30 +171,30 @@ frame_size = frame_msglen + 8
 	# where t = 80 + (toff + \offset) / 8
 
 	#   Two rounds are computed based on the values for K[t-2]+W[t-2] and
-	# K[t-1]+W[t-1] which were previously stored at WK_2 by the message
+	# K[t-1]+W[t-1] which were previously stored in XWK by the message
 	# scheduler.
 	#   The two new schedule QWORDS are stored in XW0 (which previously held
 	# W[t-16] and W[t-15], and is rotated to XW7 at the end of the macro).
 	# They are then added to their respective SHA512 constants at
-	# (\offset + 64)(kptr, toff) and (\offset + 72)(kptr, toff) and stored at
-	# dqword WK_2(0).
+	# (\offset + 64)(kptr, toff) and (\offset + 72)(kptr, toff) and stored in XWK.
 	#   For brevity, the comments following vectored instructions only refer to
 	# the first of a pair of QWORDS.
 	# Eg. XW7=W[t-2] really means XW7={W[t-2]|W[t-1]}
 	#   The computation of the message schedule and the rounds are tightly
 	# stitched to take advantage of instruction-level parallelism.
 
+	movq	XWK, T2
 	mov	f_64, T1
-	movdqa	XW1, %xmm5		    # XMM5 = W[t-14]
+	movdqa	XW1, %xmm2		    # XMM2 = W[t-14]
 	xor	g_64, T1
 	and	e_64, T1
 	movdqa	XW7, %xmm0		    # XMM0 = W[t-2]
 	xor	g_64, T1
-	add	WK_2(0), T1
-	palignr	$8, XW0, %xmm5		    # XMM5 = W[t-15]
+	add	T2, T1
+	palignr	$8, XW0, %xmm2		    # XMM2 = W[t-15]
 	mov	e_64, tmp0
 	ror	$23, tmp0 # 41
-	movdqa	%xmm5, %xmm3	            # XMM3 = W[t-15]
+	movdqa	%xmm2, %xmm3	            # XMM3 = W[t-15]
 	xor	e_64, tmp0
 	ror	$4, tmp0 # 18
 	psrlq	$61-19, %xmm0		    # XMM0 = W[t-2] >> 42
@@ -213,7 +206,7 @@ frame_size = frame_msglen + 8
 	pxor	XW7, %xmm0		    # XMM0 = (W[t-2] >> 42) ^ W[t-2]
 	mov	a_64, T2
 	xor	c_64, T2
-	pxor	%xmm5, %xmm3                # XMM3 = (W[t-15] >> 1) ^ W[t-15]
+	pxor	%xmm2, %xmm3                # XMM3 = (W[t-15] >> 1) ^ W[t-15]
 	and	b_64, T2
 	mov	a_64, tmp0
 	psrlq	$(19-6), %xmm0		    # XMM0 = ((W[t-2]>>42)^W[t-2])>>13
@@ -225,7 +218,7 @@ frame_size = frame_msglen + 8
 	pxor	XW7, %xmm0		    # XMM0 = (((W[t-2]>>42)^W[t-2])>>13)^W[t-2]
 	xor	a_64, tmp0
 	ror	$6, tmp0 # 34
-	pxor	%xmm5, %xmm3                # XMM3 = (((W[t-15]>>1)^W[t-15])>>6)^W[t-15]
+	pxor	%xmm2, %xmm3                # XMM3 = (((W[t-15]>>1)^W[t-15])>>6)^W[t-15]
 	xor	a_64, tmp0
 	ror	$28, tmp0 # 28
 	psrlq	$6, %xmm0                   # XMM0 = ((((W[t-2]>>42)^W[t-2])>>13)^W[t-2])>>6
@@ -234,14 +227,16 @@ frame_size = frame_msglen + 8
 	psrlq	$1, %xmm3                   # XMM3 = (((W[t-15]>>1)^W[t-15])>>6)^W[t-15]>>1
 	lea	(T1, T2), h_64
 	RotateState
+	psrldq	$8, XWK
+	movq	XWK, T2
 	movdqa	XW7, %xmm1		    # XMM1 = W[t-2]
 	mov	f_64, T1
 	xor	g_64, T1
-	movdqa	%xmm5, %xmm4		    # XMM4 = W[t-15]
+	movdqa	%xmm2, %xmm4		    # XMM4 = W[t-15]
 	and	e_64, T1
 	xor	g_64, T1
 	psllq	$(64-19)-(64-61) , %xmm1    # XMM1 = W[t-2] << 42
-	add	WK_2(1), T1
+	add	T2, T1
 	mov	e_64, tmp0
 	psllq	$(64-1)-(64-8), %xmm4	    # XMM4 = W[t-15] << 7
 	ror	$23, tmp0 # 41
@@ -249,7 +244,7 @@ frame_size = frame_msglen + 8
 	pxor	XW7, %xmm1		    # XMM1 = (W[t-2] << 42)^W[t-2]
 	ror	$4, tmp0 # 18
 	xor	e_64, tmp0
-	pxor	%xmm5, %xmm4		    # XMM4 = (W[t-15]<<7)^W[t-15]
+	pxor	%xmm2, %xmm4		    # XMM4 = (W[t-15]<<7)^W[t-15]
 	ror	$14, tmp0 # 14
 	add	tmp0, T1
 	psllq	$(64-61), %xmm1		    # XMM1 = ((W[t-2] << 42)^W[t-2])<<3
@@ -277,7 +272,7 @@ frame_size = frame_msglen + 8
 	ror	$28, tmp0 # 28
 	paddq	(\offset + 64)(kptr, toff), %xmm0  # Compute W[t]+K[t]
 	add	tmp0, T2
-	movdqa	%xmm0, WK_2(0)		    # Store W[t]+K[t] for next rounds
+	movdqa	%xmm0, XWK		    # Save W[t]+K[t] for next rounds
 	add	T1, d_64
 	lea	(T1, T2), h_64
 	RotateState
@@ -295,9 +290,6 @@ frame_size = frame_msglen + 8
 ########################################################################
 SYM_FUNC_START(sha512_transform_ssse3)
 
-	push	%rbp
-	mov	%rsp, %rbp
-
 	# Save GPRs
 	push	%rbx
 	push	%r12
@@ -305,13 +297,9 @@ SYM_FUNC_START(sha512_transform_ssse3)
 	push	%r14
 	push	%r15
 
-	# Allocate Stack Space
-	sub	$frame_size, %rsp
-	and	$~(0x20 - 1), %rsp
-
 	# Spill digest and msglen to free up %rdi and %rdx for kptr and toff.
-	mov	digest, frame_digest(%rsp)
-	mov	msglen, frame_msglen(%rsp)
+	push	msglen
+	push	digest
 
 .Lupdateblock:
 
@@ -329,9 +317,8 @@ SYM_FUNC_START(sha512_transform_ssse3)
 	movdqa	XMM_QWORD_BSWAP(%rip), %xmm1
 	movdqu	MSG(0), XW0
 	pshufb	%xmm1, XW0	# BSWAP
-	movdqa	XW0, %xmm0
-	paddq	K_t(0), %xmm0	# Compute W[t]+K[t]
-	movdqa	%xmm0, WK_2(0)	# Store into WK for rounds
+	movdqa	XW0, XWK
+	paddq	K_t(0), XWK	# Compute W[0..1]+K[0..1]
 	t = 2
 	.irp reg, XW1,XW2,XW3,XW4,XW5,XW6,XW7
 		movdqu	MSG(t), \reg
@@ -340,7 +327,7 @@ SYM_FUNC_START(sha512_transform_ssse3)
 		movdqa	\reg, %xmm0
 		paddq	K_t(t), %xmm0	# Compute W[t]+K[t]
 		SHA512_Round (t-1)	# Round t-1
-		movdqa	%xmm0, WK_2(t)	# Store W[t]+K[t] into WK
+		movdqa	%xmm0, XWK	# Save W[t]+K[t] for next rounds
 		t = t+2
 	.endr
 
@@ -385,7 +372,7 @@ SYM_FUNC_START(sha512_transform_ssse3)
 	SHA512_Round 79
 
 	# Update digest
-	mov	frame_digest(%rsp), digest
+	mov	0(%rsp), digest
 	add	a_64, DIGEST(0)
 	add	b_64, DIGEST(1)
 	add	c_64, DIGEST(2)
@@ -395,13 +382,13 @@ SYM_FUNC_START(sha512_transform_ssse3)
 	add	g_64, DIGEST(6)
 	add	h_64, DIGEST(7)
 
-	# Advance to next message block
+	# Decrement msglen, and advance to next message block if needed
 	add	$16*8, msg
-	decq	frame_msglen(%rsp)
+	decq	8(%rsp)
 	jnz	.Lupdateblock
 
-	# Deallocate Stack Space
-	lea	-40(%rbp), %rsp
+	# Skip over digest and msglen
+	add	$16, %rsp
 
 	# Restore GPRs
 	pop	%r15
@@ -409,7 +396,6 @@ SYM_FUNC_START(sha512_transform_ssse3)
 	pop	%r13
 	pop	%r12
 	pop	%rbx
-	pop	%rbp
 
 	RET
 SYM_FUNC_END(sha512_transform_ssse3)
-- 
2.56.1

