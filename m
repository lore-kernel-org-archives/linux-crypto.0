Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795403625;
	b=2rEx2hsJkfT8vJJHXm7/sxl195JsAD5zafLjFcGnfe37M4tZ/G55rohNVbuvBX9BFn7S
	 ZKKNXnMbdLbCEHM8/K2XJOKKhtKDyGLX2R2uYWQhS2h39D3JApfTvfyqapfDDpyOhMSZC
	 VStgLeeOD+GH47auEzJhu53A96XXwZ5PTM2m41S40WKEOKe8xucN34jdJRrt0Bv/dRCNA
	 kjYOXovKu2e7EeCl6zxBLdGofgrpOkBPWRZxHgBGaAwlYqLXlO2Jc8Kt4PUwxEtxK5TPi
	 OQBWHl5npjYmB9i0obrcvjn+sXx30/HRFUEOVPjZHaRJPvktlhyT/BHrSlB/91Z6iVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795403625;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=ZAGtl2vdiVGdRnYr+l60OqEFcUr9HNILlSICcb7VYMg=;
	b=uvz9/rvVmpqlPi6oWoXMSYJ4EWujOHFNsKyVffD6Uc9kXZdXNgIscMDxCVHjPPcomKr6
	 18j6v9bsxjocW7plcDSHwmzB0BYAqJXrRxXXHN2Hy+8oghue21bZEcP+QQW+U1IH9f6hR
	 rpKQhfdF3tz/WywHRE1vvHciHsiue02Ho6JrlysW3L7E9H9wkPxwEw/Gk4zD8pHuXBier
	 ywsb+hNLKF55BGirxncbjQIcuuJ/etkggj5xg1vBlpWtKR4oyfUHT/pJ2UWQV62Vq6dmA
	 YKrN8ODOLs3Dg5+Vx64O/jY0gS68eTsPSzI5YG/1dncXiuSLFVMGra80QPwMb0M59Ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i+tIlSuA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC608606A31A
	for <linux-crypto@vger.kernel.org>; Mon, 23 Nov 2026 03:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i+tIlSuA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AFA11F000C6;
	Mon, 23 Nov 2026 03:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795403625;
	bh=ZAGtl2vdiVGdRnYr+l60OqEFcUr9HNILlSICcb7VYMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i+tIlSuAI5csRAoozx3ZiIrS+xhxUgvpO2XYbC3jPwLMiC96njcweXbcdjSExUSnE
	 /CYgOpjMjEhYXD+ZzPGBW4RqrSvUNIMVK2YPXtbuenwyuUSlQsSzCoY4R5lbmhh8sC
	 empvO1dV3U+lPxPJN+xvNCb+MWYMpLJzPiMPErKDq0bE2PzAUkmjpq8hafV2UdZa1H
	 JgeiaQ7tirIIIFdIHXUjIZsqZmCvxHLNNShKSkZgFreO8DFSepO6PM+cqzbisz7UfD
	 da5tegSweEOvyiWZrKBCE5xTY/eeuGRPjI465BNpPkt9FYn+zIMReuC0vICrblHDro
	 JPC0spSQZ+8Bw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 3/4] lib/crypto: x86/sha512-avx2: Factor out SHA512_Round
Date: Sun, 22 Nov 2026 19:13:20 -0800
Message-ID: <20261123031321.403308-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261123031321.403308-1-ebiggers@kernel.org>
References: <20261123031321.403308-1-ebiggers@kernel.org>
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

FOUR_ROUNDS_AND_SCHED and DO_4ROUNDS open-code 8 slightly varied copies
of the same 27-instruction scalar SHA-512 compression round.  Because
the vector message-schedule instructions in FOUR_ROUNDS_AND_SCHED are
already grouped between rounds rather than interleaved inside them, all
8 round instances can share a single SHA512_Round macro.

Schedule the e-side operations (Ch and S1(e)) at the start of
SHA512_Round before reading 'a', which provides the same separation
from the previous round's 'h' update that DO_4ROUNDS previously sought
via 'old_h' without carrying live temporaries across RotateState.

This removes ~260 lines of duplicated assembly with no change in
generated code size and prepares for optimizing the scalar round logic.
Also fix the rorx comments to say 'ror' rather than '>>'.

This commit makes SHA-512 about 1% faster on AMD Ryzen 9 9950X (Zen 5)
and about 3% faster on Intel Sapphire Rapids.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/sha512-avx2-asm.S | 355 ++++---------------------------
 1 file changed, 47 insertions(+), 308 deletions(-)

diff --git a/lib/crypto/x86/sha512-avx2-asm.S b/lib/crypto/x86/sha512-avx2-asm.S
index 32b2b9c0fcd6e..f64ef3adcd6c1 100644
--- a/lib/crypto/x86/sha512-avx2-asm.S
+++ b/lib/crypto/x86/sha512-avx2-asm.S
@@ -96,7 +96,6 @@ b     = %rbx
 f     = %r9
 g     = %r10
 h     = %r11
-old_h = %r11
 
 T1    = %r12 # clobbers CTX2
 y0    = %r13
@@ -142,7 +141,6 @@ frame_size = frame_CTX + CTX_SIZE
 # RotateState
 .macro RotateState
 	# Rotate symbols a..h right
-	old_h  = h
 	TMP_   = h
 	h      = g
 	g      = f
@@ -161,6 +159,45 @@ frame_size = frame_CTX + CTX_SIZE
 	vpalignr	$\RVAL, \YSRC2, \YDST, \YDST	# YDST = {YSRC1, YSRC2} >> RVAL*8
 .endm
 
+# Do one SHA-512 round using the state a-h and \wk = W[t] + K[t].  Updates a-h
+# and rotates their aliases to match what the next round expects.
+.macro SHA512_Round wk
+	mov	f, y2		# y2 = f
+	rorx	$41, e, y0	# y0 = e ror 41
+	rorx	$18, e, y1	# y1 = e ror 18
+	xor	g, y2		# y2 = f ^ g
+	add	\wk, h		# h = h + w + k
+
+	xor	y1, y0		# y0 = (e ror 41) ^ (e ror 18)
+	rorx	$14, e, y1	# y1 = e ror 14
+	and	e, y2		# y2 = (f ^ g) & e
+	add	h, d		# d = d + h + w + k
+
+	xor	y1, y0		# y0 = S1(e)
+	xor	g, y2		# y2 = Ch(e, f, g) = ((f ^ g) & e) ^ g
+	rorx	$34, a, T1	# T1 = a ror 34
+	rorx	$39, a, y1	# y1 = a ror 39
+	mov	a, y3		# y3 = a
+
+	xor	T1, y1		# y1 = (a ror 39) ^ (a ror 34)
+	rorx	$28, a, T1	# T1 = a ror 28
+	or	c, y3		# y3 = a | c
+
+	xor	T1, y1		# y1 = S0(a)
+	mov	a, T1		# T1 = a
+	and	b, y3		# y3 = (a | c) & b
+	and	c, T1		# T1 = a & c
+	add	y0, y2		# y2 = S1(e) + Ch(e, f, g)
+
+	or	T1, y3		# y3 = Maj(a, b, c) = ((a | c) & b) | (a & c)
+	add	y1, h		# h = h + w + k + S0(a)
+	add	y2, d		# d = d + t1
+	add	y2, h		# h = t1 + S0(a)
+	add	y3, h		# h = t1 + S0(a) + Maj(a, b, c)
+
+	RotateState
+.endm
+
 # Compute 4 rounds (t-16..t-13) using W+K from frame_XFER while scheduling
 # W[t..t+3] into Y_0 (then rotated to Y_3).  Vector comments show the low qword
 # lane unless all lanes are written out as {q3, q2, q1, q0}.
@@ -176,42 +213,7 @@ frame_size = frame_CTX + CTX_SIZE
 	vpor		YTMP2, YTMP3, YTMP3		# YTMP3 = W[t-15] ror 1
 	vpsrlq		$7, YTMP1, YTMP4		# YTMP4 = W[t-15] >> 7
 
-	mov	a, y3		# y3 = a                                # MAJA
-	rorx	$41, e, y0	# y0 = e >> 41				# S1A
-	rorx	$18, e, y1	# y1 = e >> 18				# S1B
-	add	frame_XFER(%rsp),h		# h = k + w + h         # --
-	or	c, y3		# y3 = a|c                              # MAJA
-	mov	f, y2		# y2 = f                                # CH
-	rorx	$34, a, T1	# T1 = a >> 34				# S0B
-
-	xor	y1, y0		# y0 = (e>>41) ^ (e>>18)		# S1
-	xor	g, y2		# y2 = f^g                              # CH
-	rorx	$14, e, y1	# y1 = (e >> 14)			# S1
-
-	and	e, y2		# y2 = (f^g)&e                          # CH
-	xor	y1, y0		# y0 = (e>>41) ^ (e>>18) ^ (e>>14)	# S1
-	rorx	$39, a, y1	# y1 = a >> 39				# S0A
-	add	h, d		# d = k + w + h + d                     # --
-
-	and	b, y3		# y3 = (a|c)&b                          # MAJA
-	xor	T1, y1		# y1 = (a>>39) ^ (a>>34)		# S0
-	rorx	$28, a, T1	# T1 = (a >> 28)			# S0
-
-	xor	g, y2		# y2 = CH = ((f^g)&e)^g                 # CH
-	xor	T1, y1		# y1 = (a>>39) ^ (a>>34) ^ (a>>28)	# S0
-	mov	a, T1		# T1 = a                                # MAJB
-	and	c, T1		# T1 = a&c                              # MAJB
-
-	add	y0, y2		# y2 = S1 + CH                          # --
-	or	T1, y3		# y3 = MAJ = (a|c)&b)|(a&c)             # MAJ
-	add	y1, h		# h = k + w + h + S0                    # --
-
-	add	y2, d		# d = k + w + h + d + S1 + CH = d + t1  # --
-
-	add	y2, h		# h = k + w + h + S0 + S1 + CH = t1 + S0# --
-	add	y3, h		# h = t1 + S0 + MAJ                     # --
-
-	RotateState
+	SHA512_Round	0*8+frame_XFER(%rsp)
 
 ################################### Round t-15 ########################################
 
@@ -224,44 +226,7 @@ frame_size = frame_CTX + CTX_SIZE
 	vextracti128	$1, Y_3, XTMP2			# XTMP2 = {W[t-1], W[t-2]}
 	vpsrlq		$6, XTMP2, XTMP4		# XTMP4 = W[t-2] >> 6
 
-	mov	a, y3		# y3 = a                                # MAJA
-	rorx	$41, e, y0	# y0 = e >> 41				# S1A
-	rorx	$18, e, y1	# y1 = e >> 18				# S1B
-	add	1*8+frame_XFER(%rsp), h		# h = k + w + h         # --
-	or	c, y3		# y3 = a|c                              # MAJA
-
-
-	mov	f, y2		# y2 = f                                # CH
-	rorx	$34, a, T1	# T1 = a >> 34				# S0B
-	xor	y1, y0		# y0 = (e>>41) ^ (e>>18)		# S1
-	xor	g, y2		# y2 = f^g                              # CH
-
-
-	rorx	$14, e, y1	# y1 = (e >> 14)			# S1
-	xor	y1, y0		# y0 = (e>>41) ^ (e>>18) ^ (e>>14)	# S1
-	rorx	$39, a, y1	# y1 = a >> 39				# S0A
-	and	e, y2		# y2 = (f^g)&e                          # CH
-	add	h, d		# d = k + w + h + d                     # --
-
-	and	b, y3		# y3 = (a|c)&b                          # MAJA
-	xor	T1, y1		# y1 = (a>>39) ^ (a>>34)		# S0
-
-	rorx	$28, a, T1	# T1 = (a >> 28)			# S0
-	xor	g, y2		# y2 = CH = ((f^g)&e)^g                 # CH
-
-	xor	T1, y1		# y1 = (a>>39) ^ (a>>34) ^ (a>>28)	# S0
-	mov	a, T1		# T1 = a                                # MAJB
-	and	c, T1		# T1 = a&c                              # MAJB
-	add	y0, y2		# y2 = S1 + CH                          # --
-
-	or	T1, y3		# y3 = MAJ = (a|c)&b)|(a&c)             # MAJ
-	add	y1, h		# h = k + w + h + S0                    # --
-
-	add	y2, d		# d = k + w + h + d + S1 + CH = d + t1  # --
-	add	y2, h		# h = k + w + h + S0 + S1 + CH = t1 + S0# --
-	add	y3, h		# h = t1 + S0 + MAJ                     # --
-
-	RotateState
+	SHA512_Round	1*8+frame_XFER(%rsp)
 
 ################################### Round t-14 ########################################
 
@@ -278,43 +243,7 @@ frame_size = frame_CTX + CTX_SIZE
 	# Compute s1({W[t+1], W[t]}) for {W[t+3], W[t+2]}
 	vpsrlq		$6, X_0, XTMP4			# XTMP4 = W[t] >> 6
 
-	mov	a, y3		# y3 = a                                # MAJA
-	rorx	$41, e, y0	# y0 = e >> 41				# S1A
-	add	2*8+frame_XFER(%rsp), h		# h = k + w + h         # --
-
-	rorx	$18, e, y1	# y1 = e >> 18				# S1B
-	or	c, y3		# y3 = a|c                              # MAJA
-	mov	f, y2		# y2 = f                                # CH
-	xor	g, y2		# y2 = f^g                              # CH
-
-	rorx	$34, a, T1	# T1 = a >> 34				# S0B
-	xor	y1, y0		# y0 = (e>>41) ^ (e>>18)		# S1
-	and	e, y2		# y2 = (f^g)&e                          # CH
-
-	rorx	$14, e, y1	# y1 = (e >> 14)			# S1
-	add	h, d		# d = k + w + h + d                     # --
-	and	b, y3		# y3 = (a|c)&b                          # MAJA
-
-	xor	y1, y0		# y0 = (e>>41) ^ (e>>18) ^ (e>>14)	# S1
-	rorx	$39, a, y1	# y1 = a >> 39				# S0A
-	xor	g, y2		# y2 = CH = ((f^g)&e)^g                 # CH
-
-	xor	T1, y1		# y1 = (a>>39) ^ (a>>34)		# S0
-	rorx	$28, a, T1	# T1 = (a >> 28)			# S0
-
-	xor	T1, y1		# y1 = (a>>39) ^ (a>>34) ^ (a>>28)	# S0
-	mov	a, T1		# T1 = a                                # MAJB
-	and	c, T1		# T1 = a&c                              # MAJB
-	add	y0, y2		# y2 = S1 + CH                          # --
-
-	or	T1, y3		# y3 = MAJ = (a|c)&b)|(a&c)             # MAJ
-	add	y1, h		# h = k + w + h + S0                    # --
-	add	y2, d		# d = k + w + h + d + S1 + CH = d + t1  # --
-	add	y2, h		# h = k + w + h + S0 + S1 + CH = t1 + S0# --
-
-	add	y3, h		# h = t1 + S0 + MAJ                     # --
-
-	RotateState
+	SHA512_Round	2*8+frame_XFER(%rsp)
 
 ################################### Round t-13 ########################################
 
@@ -331,206 +260,16 @@ frame_size = frame_CTX + CTX_SIZE
 	vperm2i128	$0x08, YTMP4, YTMP4, YTMP4	# YTMP4 = {s1(W[t+1]), s1(W[t]), 0, 0}
 	vpaddq		Y_0, YTMP4, Y_0			# Y_0 = {W[t+3], W[t+2], W[t+1], W[t]}
 
-	mov	a, y3		# y3 = a                                # MAJA
-	rorx	$41, e, y0	# y0 = e >> 41				# S1A
-	rorx	$18, e, y1	# y1 = e >> 18				# S1B
-	add	3*8+frame_XFER(%rsp), h		# h = k + w + h         # --
-	or	c, y3		# y3 = a|c                              # MAJA
-
-
-	mov	f, y2		# y2 = f                                # CH
-	rorx	$34, a, T1	# T1 = a >> 34				# S0B
-	xor	y1, y0		# y0 = (e>>41) ^ (e>>18)		# S1
-	xor	g, y2		# y2 = f^g                              # CH
-
-
-	rorx	$14, e, y1	# y1 = (e >> 14)			# S1
-	and	e, y2		# y2 = (f^g)&e                          # CH
-	add	h, d		# d = k + w + h + d                     # --
-	and	b, y3		# y3 = (a|c)&b                          # MAJA
-
-	xor	y1, y0		# y0 = (e>>41) ^ (e>>18) ^ (e>>14)	# S1
-	xor	g, y2		# y2 = CH = ((f^g)&e)^g                 # CH
-
-	rorx	$39, a, y1	# y1 = a >> 39				# S0A
-	add	y0, y2		# y2 = S1 + CH                          # --
-
-	xor	T1, y1		# y1 = (a>>39) ^ (a>>34)		# S0
-	add	y2, d		# d = k + w + h + d + S1 + CH = d + t1  # --
-
-	rorx	$28, a, T1	# T1 = (a >> 28)			# S0
-
-	xor	T1, y1		# y1 = (a>>39) ^ (a>>34) ^ (a>>28)	# S0
-	mov	a, T1		# T1 = a                                # MAJB
-	and	c, T1		# T1 = a&c                              # MAJB
-	or	T1, y3		# y3 = MAJ = (a|c)&b)|(a&c)             # MAJ
-
-	add	y1, h		# h = k + w + h + S0                    # --
-	add	y2, h		# h = k + w + h + S0 + S1 + CH = t1 + S0# --
-	add	y3, h		# h = t1 + S0 + MAJ                     # --
-
-	RotateState
+	SHA512_Round	3*8+frame_XFER(%rsp)
 
 	rotate_Ys
 .endm
 
 .macro DO_4ROUNDS
-
-################################### RND N + 0 #########################################
-
-	mov	f, y2		# y2 = f                                # CH
-	rorx	$41, e, y0	# y0 = e >> 41				# S1A
-	rorx	$18, e, y1	# y1 = e >> 18				# S1B
-	xor	g, y2		# y2 = f^g                              # CH
-
-	xor	y1, y0		# y0 = (e>>41) ^ (e>>18)		# S1
-	rorx	$14, e, y1	# y1 = (e >> 14)			# S1
-	and	e, y2		# y2 = (f^g)&e                          # CH
-
-	xor	y1, y0		# y0 = (e>>41) ^ (e>>18) ^ (e>>14)	# S1
-	rorx	$34, a, T1	# T1 = a >> 34				# S0B
-	xor	g, y2		# y2 = CH = ((f^g)&e)^g                 # CH
-	rorx	$39, a, y1	# y1 = a >> 39				# S0A
-	mov	a, y3		# y3 = a                                # MAJA
-
-	xor	T1, y1		# y1 = (a>>39) ^ (a>>34)		# S0
-	rorx	$28, a, T1	# T1 = (a >> 28)			# S0
-	add	frame_XFER(%rsp), h		# h = k + w + h         # --
-	or	c, y3		# y3 = a|c                              # MAJA
-
-	xor	T1, y1		# y1 = (a>>39) ^ (a>>34) ^ (a>>28)	# S0
-	mov	a, T1		# T1 = a                                # MAJB
-	and	b, y3		# y3 = (a|c)&b                          # MAJA
-	and	c, T1		# T1 = a&c                              # MAJB
-	add	y0, y2		# y2 = S1 + CH                          # --
-
-	add	h, d		# d = k + w + h + d                     # --
-	or	T1, y3		# y3 = MAJ = (a|c)&b)|(a&c)             # MAJ
-	add	y1, h		# h = k + w + h + S0                    # --
-
-	add	y2, d		# d = k + w + h + d + S1 + CH = d + t1  # --
-
-	RotateState
-
-################################### RND N + 1 #########################################
-
-	add	y2, old_h	# h = k + w + h + S0 + S1 + CH = t1 + S0# --
-	mov	f, y2		# y2 = f                                # CH
-	rorx	$41, e, y0	# y0 = e >> 41				# S1A
-	rorx	$18, e, y1	# y1 = e >> 18				# S1B
-	xor	g, y2		# y2 = f^g                              # CH
-
-	xor	y1, y0		# y0 = (e>>41) ^ (e>>18)		# S1
-	rorx	$14, e, y1	# y1 = (e >> 14)			# S1
-	and	e, y2		# y2 = (f^g)&e                          # CH
-	add	y3, old_h	# h = t1 + S0 + MAJ                     # --
-
-	xor	y1, y0		# y0 = (e>>41) ^ (e>>18) ^ (e>>14)	# S1
-	rorx	$34, a, T1	# T1 = a >> 34				# S0B
-	xor	g, y2		# y2 = CH = ((f^g)&e)^g                 # CH
-	rorx	$39, a, y1	# y1 = a >> 39				# S0A
-	mov	a, y3		# y3 = a                                # MAJA
-
-	xor	T1, y1		# y1 = (a>>39) ^ (a>>34)		# S0
-	rorx	$28, a, T1	# T1 = (a >> 28)			# S0
-	add	8*1+frame_XFER(%rsp), h		# h = k + w + h         # --
-	or	c, y3		# y3 = a|c                              # MAJA
-
-	xor	T1, y1		# y1 = (a>>39) ^ (a>>34) ^ (a>>28)	# S0
-	mov	a, T1		# T1 = a                                # MAJB
-	and	b, y3		# y3 = (a|c)&b                          # MAJA
-	and	c, T1		# T1 = a&c                              # MAJB
-	add	y0, y2		# y2 = S1 + CH                          # --
-
-	add	h, d		# d = k + w + h + d                     # --
-	or	T1, y3		# y3 = MAJ = (a|c)&b)|(a&c)             # MAJ
-	add	y1, h		# h = k + w + h + S0                    # --
-
-	add	y2, d		# d = k + w + h + d + S1 + CH = d + t1  # --
-
-	RotateState
-
-################################### RND N + 2 #########################################
-
-	add	y2, old_h	# h = k + w + h + S0 + S1 + CH = t1 + S0# --
-	mov	f, y2		# y2 = f                                # CH
-	rorx	$41, e, y0	# y0 = e >> 41				# S1A
-	rorx	$18, e, y1	# y1 = e >> 18				# S1B
-	xor	g, y2		# y2 = f^g                              # CH
-
-	xor	y1, y0		# y0 = (e>>41) ^ (e>>18)		# S1
-	rorx	$14, e, y1	# y1 = (e >> 14)			# S1
-	and	e, y2		# y2 = (f^g)&e                          # CH
-	add	y3, old_h	# h = t1 + S0 + MAJ                     # --
-
-	xor	y1, y0		# y0 = (e>>41) ^ (e>>18) ^ (e>>14)	# S1
-	rorx	$34, a, T1	# T1 = a >> 34				# S0B
-	xor	g, y2		# y2 = CH = ((f^g)&e)^g                 # CH
-	rorx	$39, a, y1	# y1 = a >> 39				# S0A
-	mov	a, y3		# y3 = a                                # MAJA
-
-	xor	T1, y1		# y1 = (a>>39) ^ (a>>34)		# S0
-	rorx	$28, a, T1	# T1 = (a >> 28)			# S0
-	add	8*2+frame_XFER(%rsp), h		# h = k + w + h         # --
-	or	c, y3		# y3 = a|c                              # MAJA
-
-	xor	T1, y1		# y1 = (a>>39) ^ (a>>34) ^ (a>>28)	# S0
-	mov	a, T1		# T1 = a                                # MAJB
-	and	b, y3		# y3 = (a|c)&b                          # MAJA
-	and	c, T1		# T1 = a&c                              # MAJB
-	add	y0, y2		# y2 = S1 + CH                          # --
-
-	add	h, d		# d = k + w + h + d                     # --
-	or	T1, y3		# y3 = MAJ = (a|c)&b)|(a&c)             # MAJ
-	add	y1, h		# h = k + w + h + S0                    # --
-
-	add	y2, d		# d = k + w + h + d + S1 + CH = d + t1  # --
-
-	RotateState
-
-################################### RND N + 3 #########################################
-
-	add	y2, old_h	# h = k + w + h + S0 + S1 + CH = t1 + S0# --
-	mov	f, y2		# y2 = f                                # CH
-	rorx	$41, e, y0	# y0 = e >> 41				# S1A
-	rorx	$18, e, y1	# y1 = e >> 18				# S1B
-	xor	g, y2		# y2 = f^g                              # CH
-
-	xor	y1, y0		# y0 = (e>>41) ^ (e>>18)		# S1
-	rorx	$14, e, y1	# y1 = (e >> 14)			# S1
-	and	e, y2		# y2 = (f^g)&e                          # CH
-	add	y3, old_h	# h = t1 + S0 + MAJ                     # --
-
-	xor	y1, y0		# y0 = (e>>41) ^ (e>>18) ^ (e>>14)	# S1
-	rorx	$34, a, T1	# T1 = a >> 34				# S0B
-	xor	g, y2		# y2 = CH = ((f^g)&e)^g                 # CH
-	rorx	$39, a, y1	# y1 = a >> 39				# S0A
-	mov	a, y3		# y3 = a                                # MAJA
-
-	xor	T1, y1		# y1 = (a>>39) ^ (a>>34)		# S0
-	rorx	$28, a, T1	# T1 = (a >> 28)			# S0
-	add	8*3+frame_XFER(%rsp), h		# h = k + w + h         # --
-	or	c, y3		# y3 = a|c                              # MAJA
-
-	xor	T1, y1		# y1 = (a>>39) ^ (a>>34) ^ (a>>28)	# S0
-	mov	a, T1		# T1 = a                                # MAJB
-	and	b, y3		# y3 = (a|c)&b                          # MAJA
-	and	c, T1		# T1 = a&c                              # MAJB
-	add	y0, y2		# y2 = S1 + CH                          # --
-
-
-	add	h, d		# d = k + w + h + d                     # --
-	or	T1, y3		# y3 = MAJ = (a|c)&b)|(a&c)             # MAJ
-	add	y1, h		# h = k + w + h + S0                    # --
-
-	add	y2, d		# d = k + w + h + d + S1 + CH = d + t1  # --
-
-	add	y2, h		# h = k + w + h + S0 + S1 + CH = t1 + S0# --
-
-	add	y3, h		# h = t1 + S0 + MAJ                     # --
-
-	RotateState
-
+	SHA512_Round	0*8+frame_XFER(%rsp)
+	SHA512_Round	1*8+frame_XFER(%rsp)
+	SHA512_Round	2*8+frame_XFER(%rsp)
+	SHA512_Round	3*8+frame_XFER(%rsp)
 .endm
 
 ########################################################################
-- 
2.56.1

