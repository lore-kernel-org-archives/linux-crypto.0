Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795403625;
	b=WwwKRVE2tfNsQ5RVz7u7iW3MFF/on/BHHzaZaCQr4JGGocVDG+7EM8EmjZ043D6auMOa
	 IAopuEfdW39RPBN+z5mvXDgalhlqJWfKbNnm6IMtbWlKen+w7BKQbd/CMBsCXS54auYOq
	 0FmlAvHPZ3lUxt1+/dcpxfSrh/s33B3Z5lGXxP+yQmgv1W16yUHpnoPEts34b2otU9wiT
	 9yrFhkiRKR7IYDR4ucWy6H3v1BIwTw8hBlkNR7TQfvBNrFRJ3Mv/3XXPogvznjwPoZfO3
	 eXf+JZvZgRIoSEAy8I31qHOoQM5lF5g+YjvpiqSHSMdI6QQv41XxEanQdMyT9uO2UgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795403625;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Ga08VS8+NC39doj8Jk/a+ThMgSZtbKSFFLHmsOn0w/c=;
	b=PiFgpnGTYHBPFHSvwLK4eRZXWhQLiLfRC2wYTRefOv6/xKEgIMYimFvopDldG2KUkxhw
	 F062v9BmoE6UdRAfOe2flHi4gmOsQT/HiY20QDdhrodM+ZC8FB0/mALroaWV5EzFO053y
	 BRRCfF297XQg0NnKfyqsnT6+nZ5bVCrCxVVrNU1TFwfHo7ghZKxwwAECdQ46HpZKJUIBh
	 gWWj47KN9Urq9PFm0y5Z9+xezgbacx1q5pRoiTAfe0PE2ZsZLdM87AUY+BzysW04RZmrS
	 wbfgE9manjmQwGslWrQCDyLp30sNOtq4kDXosQJQSdjzj8PNDHknH3fNe6ZK08oF01A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A58ppIUz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6C5606A331
	for <linux-crypto@vger.kernel.org>; Mon, 23 Nov 2026 03:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A58ppIUz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59D21F000C0;
	Mon, 23 Nov 2026 03:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795403625;
	bh=Ga08VS8+NC39doj8Jk/a+ThMgSZtbKSFFLHmsOn0w/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A58ppIUzr/2p0Zta59sJRfMz6isCCxGDvaPthfipYJv6kV+Ayebr2gpDIIVt98JQt
	 IKW5Hmlz4mQYzKSXDbamtvJC9m6yrk1eRozRf/ufPN89Yt1gsDsOKLE1V8bnugeQ+T
	 e7T+YHHdovzPE5m+I9lw2IdJcJM3Z2FwX673l0/03Jw0C+zDtxPoz681SPkaOPgGF6
	 JC/HTqlhx6HAcU3MkC5aUhn0ONts/04mTEnoGfVLb925v7tIGuWKCY6hLpjzIDwTI3
	 1iE+5gWvg4ZHvMDQYRWyRNE/WZPINvcgaT5ruNTHE9Gyz7ThBFx6Zt58KZK3h0F+ue
	 rZqs9ypuAtyyg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/4] lib/crypto: x86/sha512-avx2: Optimize message schedule
Date: Sun, 22 Nov 2026 19:13:19 -0800
Message-ID: <20261123031321.403308-3-ebiggers@kernel.org>
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

Optimize the SHA-512 message schedule in sha512-avx2-asm.S:

  1. Implement the 64-bit rotations by 8 with vpshufb instead of a
     sequence of two shifts and an OR.  This follows the standard
     optimization used elsewhere such as the ChaCha and Blake2s code.

  2. Prefer integer domain instructions (e.g. 'vperm2i128') to floating
     point domain ones (e.g. 'vperm2f128').  No effect in practice, but
     there's no reason to use the "wrong" ones.

  3. Eliminate unnecessary use of 256-bit instructions in the s1
     computation in FOUR_ROUNDS_AND_SCHED.

     s1(W[t-2]) uses the 64-bit word just 2 before the current one, so
     it can be computed on only 2 words at a time, i.e. 128 bits.
     However, previously the code ignored AVX's support for 128-bit
     instructions and instead used 256-bit instructions.  The extra
     width caused overhead on some CPUs, and extra work was being done
     to broadcast the inputs across both lanes and select the output.

     Instead, compute both s1 steps in XMM registers, and add each
     result into its target 128-bit half of Y_0.

  4. Improve comments: Fix wrong left-shift amounts, typos, and
     inconsistent terminology.

Overall, this eliminates 4 vector instructions and 1 memory load per 4
rounds (64 instructions per block), reduces the rodata size by 16 bytes,
and narrows some unnecessarily wide instructions.

There's no measurable change in SHA-512 speed on AMD Ryzen 9 9950X (Zen
5) or Intel Sapphire Rapids.  However, the narrowing to 128-bit is
likely to help on microarchitectures like AMD Zen 1 where 128-bit
operations are faster than 256-bit ones.  With the diffstat, text size,
and rodata size all being negative as well, this seems worthwhile.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/sha512-avx2-asm.S | 157 +++++++++++++++----------------
 1 file changed, 74 insertions(+), 83 deletions(-)

diff --git a/lib/crypto/x86/sha512-avx2-asm.S b/lib/crypto/x86/sha512-avx2-asm.S
index d5f3c0bcee653..32b2b9c0fcd6e 100644
--- a/lib/crypto/x86/sha512-avx2-asm.S
+++ b/lib/crypto/x86/sha512-avx2-asm.S
@@ -2,6 +2,7 @@
 # Implement fast SHA-512 with AVX2 instructions. (x86_64)
 #
 # Copyright (C) 2013 Intel Corporation.
+# Copyright 2026 Google LLC
 #
 # Authors:
 #     James Guilford <james.guilford@intel.com>
@@ -46,26 +47,33 @@
 # and search for that title.
 #
 ########################################################################
-# This code schedules 1 blocks at a time, with 4 lanes per block
-########################################################################
 
 #include <linux/linkage.h>
 
 .text
 
-# Virtual Registers
+# Rolling window of 16 scheduled message words W[t-16..t-1]
 Y_0 = %ymm4
 Y_1 = %ymm5
 Y_2 = %ymm6
 Y_3 = %ymm7
+X_0 = %xmm4
+X_1 = %xmm5
+X_2 = %xmm6
+X_3 = %xmm7
 
 YTMP0 = %ymm0
 YTMP1 = %ymm1
 YTMP2 = %ymm2
 YTMP3 = %ymm3
 YTMP4 = %ymm8
+XTMP1 = %xmm1
+XTMP2 = %xmm2
+XTMP3 = %xmm3
+XTMP4 = %xmm8
 XFER  = YTMP0
 YBSWAP = %ymm9
+YROR8 = %ymm10
 
 # 1st arg is %rdi, which is saved to the stack and accessed later via %r12
 CTX1        = %rdi
@@ -117,13 +125,18 @@ frame_size = frame_CTX + CTX_SIZE
 .endm
 
 # rotate_Ys
-# Rotate values of symbols Y0...Y3
+# Rotate values of symbols Y_0..Y_3 and X_0..X_3
 .macro rotate_Ys
-	Y_ = Y_0
+	Y_  = Y_0
 	Y_0 = Y_1
 	Y_1 = Y_2
 	Y_2 = Y_3
 	Y_3 = Y_
+	X_  = X_0
+	X_0 = X_1
+	X_1 = X_2
+	X_2 = X_3
+	X_3 = X_
 .endm
 
 # RotateState
@@ -144,28 +157,24 @@ frame_size = frame_CTX + CTX_SIZE
 # macro MY_VPALIGNR	YDST, YSRC1, YSRC2, RVAL
 # YDST = {YSRC1, YSRC2} >> RVAL*8
 .macro MY_VPALIGNR YDST YSRC1 YSRC2 RVAL
-	vperm2f128      $0x3, \YSRC2, \YSRC1, \YDST     # YDST = {YS1_LO, YS2_HI}
-	vpalignr        $\RVAL, \YSRC2, \YDST, \YDST    # YDST = {YDS1, YS2} >> RVAL*8
+	vperm2i128	$0x3, \YSRC2, \YSRC1, \YDST	# YDST = {YSRC1_LO, YSRC2_HI}
+	vpalignr	$\RVAL, \YSRC2, \YDST, \YDST	# YDST = {YSRC1, YSRC2} >> RVAL*8
 .endm
 
+# Compute 4 rounds (t-16..t-13) using W+K from frame_XFER while scheduling
+# W[t..t+3] into Y_0 (then rotated to Y_3).  Vector comments show the low qword
+# lane unless all lanes are written out as {q3, q2, q1, q0}.
 .macro FOUR_ROUNDS_AND_SCHED
-################################### RND N + 0 #########################################
-
-	# Extract w[t-7]
-	MY_VPALIGNR	YTMP0, Y_3, Y_2, 8		# YTMP0 = W[-7]
-	# Calculate w[t-16] + w[t-7]
-	vpaddq		Y_0, YTMP0, YTMP0		# YTMP0 = W[-7] + W[-16]
-	# Extract w[t-15]
-	MY_VPALIGNR	YTMP1, Y_1, Y_0, 8		# YTMP1 = W[-15]
-
-	# Calculate sigma0
+################################### Round t-16 ########################################
 
-	# Calculate w[t-15] ror 1
-	vpsrlq		$1, YTMP1, YTMP2
-	vpsllq		$(64-1), YTMP1, YTMP3
-	vpor		YTMP2, YTMP3, YTMP3		# YTMP3 = W[-15] ror 1
-	# Calculate w[t-15] shr 7
-	vpsrlq		$7, YTMP1, YTMP4		# YTMP4 = W[-15] >> 7
+	# Compute W[t-16] + W[t-7] + s0(W[t-15]) for W[t..t+3]
+	MY_VPALIGNR	YTMP0, Y_3, Y_2, 8		# YTMP0 = W[t-7]
+	vpaddq		Y_0, YTMP0, YTMP0		# YTMP0 = W[t-16] + W[t-7]
+	MY_VPALIGNR	YTMP1, Y_1, Y_0, 8		# YTMP1 = W[t-15]
+	vpsrlq		$1, YTMP1, YTMP2		# YTMP2 = W[t-15] >> 1
+	vpsllq		$(64-1), YTMP1, YTMP3		# YTMP3 = W[t-15] << 63
+	vpor		YTMP2, YTMP3, YTMP3		# YTMP3 = W[t-15] ror 1
+	vpsrlq		$7, YTMP1, YTMP4		# YTMP4 = W[t-15] >> 7
 
 	mov	a, y3		# y3 = a                                # MAJA
 	rorx	$41, e, y0	# y0 = e >> 41				# S1A
@@ -204,30 +213,16 @@ frame_size = frame_CTX + CTX_SIZE
 
 	RotateState
 
-################################### RND N + 1 #########################################
-
-	# Calculate w[t-15] ror 8
-	vpsrlq		$8, YTMP1, YTMP2
-	vpsllq		$(64-8), YTMP1, YTMP1
-	vpor		YTMP2, YTMP1, YTMP1		# YTMP1 = W[-15] ror 8
-	# XOR the three components
-	vpxor		YTMP4, YTMP3, YTMP3		# YTMP3 = W[-15] ror 1 ^ W[-15] >> 7
-	vpxor		YTMP1, YTMP3, YTMP1		# YTMP1 = s0
-
-
-	# Add three components, w[t-16], w[t-7] and sigma0
-	vpaddq		YTMP1, YTMP0, YTMP0		# YTMP0 = W[-16] + W[-7] + s0
-	# Move to appropriate lanes for calculating w[16] and w[17]
-	vperm2f128	$0x0, YTMP0, YTMP0, Y_0		# Y_0 = W[-16] + W[-7] + s0 {BABA}
-	# Move to appropriate lanes for calculating w[18] and w[19]
-	vpand		MASK_YMM_LO(%rip), YTMP0, YTMP0	# YTMP0 = W[-16] + W[-7] + s0 {DC00}
+################################### Round t-15 ########################################
 
-	# Calculate w[16] and w[17] in both 128 bit lanes
-
-	# Calculate sigma1 for w[16] and w[17] on both 128 bit lanes
-	vperm2f128	$0x11, Y_3, Y_3, YTMP2		# YTMP2 = W[-2] {BABA}
-	vpsrlq		$6, YTMP2, YTMP4		# YTMP4 = W[-2] >> 6 {BABA}
+	vpshufb		YROR8, YTMP1, YTMP1		# YTMP1 = W[t-15] ror 8
+	vpxor		YTMP4, YTMP3, YTMP3		# YTMP3 = (W[t-15] ror 1) ^ (W[t-15] >> 7)
+	vpxor		YTMP1, YTMP3, YTMP1		# YTMP1 = s0(W[t-15])
+	vpaddq		YTMP1, YTMP0, YTMP0		# YTMP0 = W[t-16] + W[t-7] + s0(W[t-15])
 
+	# Compute s1({W[t-1], W[t-2]}) for {W[t+1], W[t]}
+	vextracti128	$1, Y_3, XTMP2			# XTMP2 = {W[t-1], W[t-2]}
+	vpsrlq		$6, XTMP2, XTMP4		# XTMP4 = W[t-2] >> 6
 
 	mov	a, y3		# y3 = a                                # MAJA
 	rorx	$41, e, y0	# y0 = e >> 41				# S1A
@@ -268,24 +263,20 @@ frame_size = frame_CTX + CTX_SIZE
 
 	RotateState
 
+################################### Round t-14 ########################################
 
-################################### RND N + 2 #########################################
-
-	vpsrlq		$19, YTMP2, YTMP3		# YTMP3 = W[-2] >> 19 {BABA}
-	vpsllq		$(64-19), YTMP2, YTMP1		# YTMP1 = W[-2] << 19 {BABA}
-	vpor		YTMP1, YTMP3, YTMP3		# YTMP3 = W[-2] ror 19 {BABA}
-	vpxor		YTMP3, YTMP4, YTMP4		# YTMP4 = W[-2] ror 19 ^ W[-2] >> 6 {BABA}
-	vpsrlq		$61, YTMP2, YTMP3		# YTMP3 = W[-2] >> 61 {BABA}
-	vpsllq		$(64-61), YTMP2, YTMP1		# YTMP1 = W[-2] << 61 {BABA}
-	vpor		YTMP1, YTMP3, YTMP3		# YTMP3 = W[-2] ror 61 {BABA}
-	vpxor		YTMP3, YTMP4, YTMP4		# YTMP4 = s1 = (W[-2] ror 19) ^
-							#  (W[-2] ror 61) ^ (W[-2] >> 6) {BABA}
-
-	# Add sigma1 to the other compunents to get w[16] and w[17]
-	vpaddq		YTMP4, Y_0, Y_0			# Y_0 = {W[1], W[0], W[1], W[0]}
+	vpsrlq		$19, XTMP2, XTMP3		# XTMP3 = W[t-2] >> 19
+	vpsllq		$(64-19), XTMP2, XTMP1		# XTMP1 = W[t-2] << 45
+	vpor		XTMP1, XTMP3, XTMP3		# XTMP3 = W[t-2] ror 19
+	vpxor		XTMP3, XTMP4, XTMP4		# XTMP4 = (W[t-2] ror 19) ^ (W[t-2] >> 6)
+	vpsrlq		$61, XTMP2, XTMP3		# XTMP3 = W[t-2] >> 61
+	vpsllq		$(64-61), XTMP2, XTMP1		# XTMP1 = W[t-2] << 3
+	vpor		XTMP1, XTMP3, XTMP3		# XTMP3 = W[t-2] ror 61
+	vpxor		XTMP3, XTMP4, XTMP4		# YTMP4 = {0, 0, s1(W[t-1]), s1(W[t-2])}
+	vpaddq		YTMP0, YTMP4, Y_0		# Y_0 = {YTMP0[3..2], W[t+1], W[t]}
 
-	# Calculate sigma1 for w[18] and w[19] for upper 128 bit lane
-	vpsrlq		$6, Y_0, YTMP4			# YTMP4 = W[-2] >> 6 {DC--}
+	# Compute s1({W[t+1], W[t]}) for {W[t+3], W[t+2]}
+	vpsrlq		$6, X_0, XTMP4			# XTMP4 = W[t] >> 6
 
 	mov	a, y3		# y3 = a                                # MAJA
 	rorx	$41, e, y0	# y0 = e >> 41				# S1A
@@ -325,24 +316,20 @@ frame_size = frame_CTX + CTX_SIZE
 
 	RotateState
 
-################################### RND N + 3 #########################################
-
-	vpsrlq		$19, Y_0, YTMP3			# YTMP3 = W[-2] >> 19 {DC--}
-	vpsllq		$(64-19), Y_0, YTMP1		# YTMP1 = W[-2] << 19 {DC--}
-	vpor		YTMP1, YTMP3, YTMP3		# YTMP3 = W[-2] ror 19 {DC--}
-	vpxor		YTMP3, YTMP4, YTMP4		# YTMP4 = W[-2] ror 19 ^ W[-2] >> 6 {DC--}
-	vpsrlq		$61, Y_0, YTMP3			# YTMP3 = W[-2] >> 61 {DC--}
-	vpsllq		$(64-61), Y_0, YTMP1		# YTMP1 = W[-2] << 61 {DC--}
-	vpor		YTMP1, YTMP3, YTMP3		# YTMP3 = W[-2] ror 61 {DC--}
-	vpxor		YTMP3, YTMP4, YTMP4		# YTMP4 = s1 = (W[-2] ror 19) ^
-							#  (W[-2] ror 61) ^ (W[-2] >> 6) {DC--}
+################################### Round t-13 ########################################
 
-	# Add the sigma0 + w[t-7] + w[t-16] for w[18] and w[19]
-	# to newly calculated sigma1 to get w[18] and w[19]
-	vpaddq		YTMP4, YTMP0, YTMP2		# YTMP2 = {W[3], W[2], --, --}
+	vpsrlq		$19, X_0, XTMP3			# XTMP3 = W[t] >> 19
+	vpsllq		$(64-19), X_0, XTMP1		# XTMP1 = W[t] << 45
+	vpor		XTMP1, XTMP3, XTMP3		# XTMP3 = W[t] ror 19
+	vpxor		XTMP3, XTMP4, XTMP4		# XTMP4 = (W[t] ror 19) ^ (W[t] >> 6)
+	vpsrlq		$61, X_0, XTMP3			# XTMP3 = W[t] >> 61
+	vpsllq		$(64-61), X_0, XTMP1		# XTMP1 = W[t] << 3
+	vpor		XTMP1, XTMP3, XTMP3		# XTMP3 = W[t] ror 61
+	vpxor		XTMP3, XTMP4, XTMP4		# XTMP4 = {s1(W[t+1]), s1(W[t])}
 
-	# Form w[19, w[18], w17], w[16]
-	vpblendd		$0xF0, YTMP2, Y_0, Y_0		# Y_0 = {W[3], W[2], W[1], W[0]}
+	# Move s1 to bits 255:128 while zeroing bits 127:0, then add into Y_0
+	vperm2i128	$0x08, YTMP4, YTMP4, YTMP4	# YTMP4 = {s1(W[t+1]), s1(W[t]), 0, 0}
+	vpaddq		Y_0, YTMP4, Y_0			# Y_0 = {W[t+3], W[t+2], W[t+1], W[t]}
 
 	mov	a, y3		# y3 = a                                # MAJA
 	rorx	$41, e, y0	# y0 = e >> 41				# S1A
@@ -589,6 +576,7 @@ SYM_FUNC_START(sha512_transform_rorx)
 	mov	%rdi, frame_CTX(%rsp)
 
 	vbroadcasti128	.L_XMM_QWORD_BSWAP(%rip), YBSWAP
+	vbroadcasti128	.L_XMM_QWORD_ROR8(%rip), YROR8
 
 .Lloop0:
 	lea	K512(%rip), TBL
@@ -601,7 +589,8 @@ SYM_FUNC_START(sha512_transform_rorx)
 
 	mov	INP, frame_INP(%rsp)
 
-	## schedule 64 input dwords, by doing 12 rounds of 4 each
+	# Do rounds 0..63 and compute W[16..79] (interleaved) in four loop
+	# iterations, each of which does four groups of four rounds.
 	movq	$4, frame_SRND(%rsp)
 
 .align 16
@@ -626,6 +615,8 @@ SYM_FUNC_START(sha512_transform_rorx)
 	subq	$1, frame_SRND(%rsp)
 	jne	.Lloop1
 
+	# Do rounds 64..79 in two loop iterations, each of which does two groups
+	# of four rounds.
 	movq	$2, frame_SRND(%rsp)
 .Lloop2:
 	vpaddq	(TBL), Y_0, XFER
@@ -730,8 +721,8 @@ K512:
 .L_XMM_QWORD_BSWAP:
 	.octa 0x08090a0b0c0d0e0f0001020304050607
 
-.section	.rodata.cst32.MASK_YMM_LO, "aM", @progbits, 32
-.align 32
-MASK_YMM_LO:
-	.octa 0x00000000000000000000000000000000
-	.octa 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
+.section	.rodata.cst16.XMM_QWORD_ROR8, "aM", @progbits, 16
+.align 16
+# Mask for rotating each qword right by 8 bits using vpshufb
+.L_XMM_QWORD_ROR8:
+	.octa 0x080f0e0d0c0b0a090007060504030201
-- 
2.56.1

