Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795314069;
	b=eCEkksDTR7slQDTWil4ab43bSASCa1Hu/zuyQXwH3HRxGtvSOuOJTYElnIBChtfbomTo
	 cO70amde0cWx70IXbDMz7ZvT/ruKsuOa3Jq9jVBb4hcYG9XHZY01mZGCJVrYJ2KCvePcd
	 QCl/gGkOXsdsjBZgmRCGuOEZyb8Jj0hvT0TejFjF2RktRpfdoBabzgiDV0w+qwnriVVak
	 P7pl6plCb3JKk0QE2Ylu9n/14yDn9TEdqq0f8UdYBPTyCk9lNZ6Vfx+3pIiXhMwbmoilt
	 GtEqE2j9kVz5ZFL0R3hquAImjg/AK6R6ZmzpkI47fLpiPxO9TKUyNfn604g+8yHKBag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795314069;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=5JOBrlBdSRnXBHMuFXnL5DQ/Ejw8uLeobXvdT/HZsYY=;
	b=pRcHRYKbbUJRWxXfqu5JIvLhwU7uRysPPTGC7U269P/jnoZ2mU3jYAQH0H285BLAcqcy
	 YhmFwLCglQSR6D89OfKLxW1O0ZO0fLw0JgDVtJd2JFIaI4Rh/WrbSFY9LPmfVFQcUInUb
	 xUyKYJYKJt14vQm3i/VVv0l8utajehxRJUCTujnWw/bTlQaqjC4OhfXP9FpyHLPHPKyr5
	 Ig3Ns/OXobF4fc3O3kK9hA0UeK46FYqPUS20wtWRb+mEXBrKxfED2NP3kjZTL2CTLvv4Q
	 5i1UbGcRGKAWxlob6DgDnppycVc9L7FjO+MMRCAhtAhEae9Mk74YVA4xOsBp0VPJCHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BTShoFXg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5614B606A32A
	for <linux-crypto@vger.kernel.org>; Sun, 22 Nov 2026 02:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BTShoFXg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C101F000C4;
	Sun, 22 Nov 2026 02:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795314069;
	bh=5JOBrlBdSRnXBHMuFXnL5DQ/Ejw8uLeobXvdT/HZsYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BTShoFXg+jhsJHcq6tm+ncfFq6fB7R8ML/zZZ5J4vTl0bD8I/7KBhrOpEk/oyFqrC
	 xshwpWlZ103oqaYU+oU+8GXWBSpmRRiz6f50240HBvnB6xHuw5hNfvL9o7ln/oQSEm
	 Fd9NE5e4quDz4WsPYB0BFkWYFFtz5HGlZn+q2dYPVq7+JyMEqagOPYwgzy+ksyM2TR
	 aXl3ZJpNP5lkLAHGKWPgoQjjX83VYvvZZn1akxgY72L9YBZwpsHRD8cIfSTfzijXhy
	 L/s5YBrIkRmXV1+A7vsSEk6A3ehfdSespbBq4QQdtSZx4o5I8Es4aY0ti919Ymuitz
	 KmEh4aQw87WPQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 7/8] lib/crypto: x86/sha512: Shorten critical-path additions in SSSE3
Date: Sat, 21 Nov 2026 18:20:29 -0800
Message-ID: <20261122022030.296468-8-ebiggers@kernel.org>
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

In SHA512_2Sched_2Round_sse, T1 = Ch(e, f, g) + W[t] + K[t] is ready
well before S1(e) finishes in tmp0, yet 'add tmp0, T1' was executed
before 'add h_64, T1'.  Swap them so 'add h_64, T1' runs in parallel
with S1(e), matching SHA512_Round and removing 1 cycle per round from
the critical path.

Similarly, in SHA512_Round, T1 finishes later than both Maj(a, b, c)
and S0(a).  Add S0(a) into T2 before 'lea (T1, T2), h_64', matching
SHA512_2Sched_2Round_sse and removing 1 cycle from the T1 -> h_64 path.

Note that sha512-avx2-asm.S already structures its additions similarly
to avoid both of these serial dependencies on the critical path.

Also fix a few comments in the file.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/sha512-ssse3-asm.S | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/lib/crypto/x86/sha512-ssse3-asm.S b/lib/crypto/x86/sha512-ssse3-asm.S
index f7dade03c6527..62f1f5109f629 100644
--- a/lib/crypto/x86/sha512-ssse3-asm.S
+++ b/lib/crypto/x86/sha512-ssse3-asm.S
@@ -91,10 +91,10 @@ XROR8 =		%xmm15	# XMM_QWORD_ROR8
 # Useful QWORD "arrays" for simpler memory references
 # MSG, DIGEST, K_t are arrays
 
-# Input message (arg1)
+# Input message (arg2)
 #define MSG(i)    8*i(msg)
 
-# Output Digest (arg2)
+# Output Digest (arg1)
 #define DIGEST(i) 8*i(digest)
 
 # SHA Constants (static mem)
@@ -134,7 +134,7 @@ XROR8 =		%xmm15	# XMM_QWORD_ROR8
 
 .macro SHA512_Round rnd
 
-	# Compute Round %%t
+	# Compute Round \rnd
 	.if ((\rnd) % 2) == 0
 		movq	XWK, T2
 	.else
@@ -154,7 +154,7 @@ XROR8 =		%xmm15	# XMM_QWORD_ROR8
 	mov	a_64, T2          # T2 = a
 	add	h_64, T1          # T1 = CH(e,f,g) + W[t] + K[t] + h
 	ror	$14, tmp0 # 14    # tmp = ((((e ror23)^e)ror4)^e)ror14 = S1(e)
-	add	tmp0, T1          # T1 = CH(e,f,g) + W[t] + K[t] + S1(e)
+	add	tmp0, T1          # T1 = CH(e,f,g) + W[t] + K[t] + h + S1(e)
 	mov	a_64, tmp0        # tmp = a
 	xor	c_64, T2          # T2 = a ^ c
 	and	c_64, tmp0        # tmp = a & c
@@ -166,9 +166,9 @@ XROR8 =		%xmm15	# XMM_QWORD_ROR8
 	add	T1, d_64          # e(next_state) = d + T1
 	ror	$6, tmp0 # 34     # tmp = ((a ror 5) ^ a) ror 6
 	xor	a_64, tmp0        # tmp = (((a ror 5) ^ a) ror 6) ^ a
-	lea	(T1, T2), h_64    # a(next_state) = T1 + Maj(a,b,c)
 	ror	$28, tmp0 # 28    # tmp = ((((a ror5)^a)ror6)^a)ror28 = S0(a)
-	add	tmp0, h_64        # a(next_state) = T1 + Maj(a,b,c) S0(a)
+	add	tmp0, T2          # T2 = Maj(a,b,c) + S0(a)
+	lea	(T1, T2), h_64    # a(next_state) = T1 + Maj(a,b,c) + S0(a)
 	RotateState
 .endm
 
@@ -209,8 +209,8 @@ XROR8 =		%xmm15	# XMM_QWORD_ROR8
 	xor	e_64, tmp0
 	ror	$14, tmp0 # 14
 	pshufb	XROR8, %xmm3		    # XMM3 = W[t-15] ror 8
-	add	tmp0, T1
 	add	h_64, T1
+	add	tmp0, T1
 	pxor	XW7, %xmm0		    # XMM0 = (W[t-2] >> 42) ^ W[t-2]
 	mov	a_64, T2
 	xor	c_64, T2
@@ -254,9 +254,9 @@ XROR8 =		%xmm15	# XMM_QWORD_ROR8
 	xor	e_64, tmp0
 	pxor	%xmm2, %xmm3		    # XMM3 = s0(W[t-15])
 	ror	$14, tmp0 # 14
-	add	tmp0, T1
-	psllq	$(64-61), %xmm1		    # XMM1 = ((W[t-2] << 42)^W[t-2])<<3
 	add	h_64, T1
+	psllq	$(64-61), %xmm1		    # XMM1 = ((W[t-2] << 42)^W[t-2])<<3
+	add	tmp0, T1
 	mov	a_64, T2
 	xor	c_64, T2
 	and	b_64, T2
@@ -413,7 +413,7 @@ SYM_FUNC_END(sha512_transform_ssse3)
 
 .section	.rodata.cst16.XMM_QWORD_BSWAP, "aM", @progbits, 16
 .align 16
-# Mask for byte-swapping a couple of qwords in an XMM register using (v)pshufb.
+# Mask for byte-swapping a couple of qwords in an XMM register using pshufb.
 XMM_QWORD_BSWAP:
 	.octa 0x08090a0b0c0d0e0f0001020304050607
 
-- 
2.56.1

