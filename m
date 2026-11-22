Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795314068;
	b=PEKEXa/5CGuZFu9/+r42iP/Y2hqzGt/fWrCMRsJkVFDeeF+UtReigVu4NHo1AiaT05yF
	 6R/gSne4x4fnMLPNyk+1e3t9LlukfQ1N3QRYK79B+tfDsesdObSgXYc5orbDYGzjZ//bH
	 XG5UQ9azJFxJmMpNGbWBqBjd70Wk9bnjZQwntI1zB1uKsRr9wWqri/5lLSPzUVzhZNH5n
	 S9z5DAzznj1JM7FquwaKfY/aC7M1cpedGIXkBDSqrEqWDR56aTLn8y7824WbHSYNFuO9P
	 vd6HTvzCqfHZiGYqsZxFpdiAIirxBgXyHncCMR9SZEcBqCK4QYhAjE1DRYwNha9iM/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795314068;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=KY/fgESyNprI3wvMbZFX0mYTx73nGXPIxHfGmFTqIK8=;
	b=v1MCGpDE0jr8FvWkXeeGHH0w3025noBSAAqC1ODPYoMirgebOF7KQrxMnWGiSjePVNlF
	 VHvkqZS8ZTNnWHp6Bw7Fl6chvCwnClY3MvRU7AKhrY22leKvU9hMZugQPry1gaqi20OCM
	 CaknVpjxknjSNrJVK7GllIlG/uVQghcxKyw00rToX0Kkim9gmFvHvoT4rddsXnqNCk3CR
	 5G6uxYcQ8dkmAiCMHhRaX7mlG7GGqrx43oaiHHKbyAenRLFoWe/uUfqIPaspEP6LqcW6H
	 +2luDrs9kshaHb3qP+0EMqWKMDaIAYgEHZfeAs4MpSeOKlENtK05ofGdXvBI6qPuNLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="HKJmFp6/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73500606A330
	for <linux-crypto@vger.kernel.org>; Sun, 22 Nov 2026 02:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HKJmFp6/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7161F000C0;
	Sun, 22 Nov 2026 02:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795314068;
	bh=KY/fgESyNprI3wvMbZFX0mYTx73nGXPIxHfGmFTqIK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HKJmFp6/ybV7sc6ltPAHoloQBszQoG3UE64PJ4HotpC84c4WG4RzzYxOSr77NztgS
	 9D7XOWH/5d8PVQZehGM0RXOlhVI5A7mP5QGgfrexX3H49xJi6MEhWvvbBt2hVw2JnZ
	 lFGnhMjjgMMNNi2INbAJzOr/7+I42qD79zRrTahnxhxwy+wkV71nBskJxSzh1XE/u7
	 oV2r0B+/S9EUySqTi3vJP674n2b2Xi9UxClOLybDcmHyk0y9Fhg279TOIe9ETq+ulu
	 t3gFyo5fZXT/3PpR+ypHixnucXTUDo5Lmgj7Yf4Wl88xmWkgC7iBHaQFkas3lfwwNH
	 3u0a3JVRgY9OA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5/8] lib/crypto: x86/sha512: Use pshufb for ror64(x, 8) in SSSE3 s0
Date: Sat, 21 Nov 2026 18:20:27 -0800
Message-ID: <20261122022030.296468-6-ebiggers@kernel.org>
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

In the SHA-512 message schedule, s0(x) = ror64(x, 1) ^ ror64(x, 8) ^ (x
>> 7) was previously computed using two factored shift-and-XOR chains:

  - right-shift chain: ((((x >> 1) ^ x) >> 6) ^ x) >> 1
                       = (x >> 8) ^ (x >> 7) ^ (x >> 1)
  - left-shift chain:  ((x << 7) ^ x) << 56
                       = (x << 63) ^ (x << 56)

Instead, compute ror64(x, 8) directly with pshufb (keeping the shuffle
mask in the free register %xmm15 across blocks).  With the >> 8 and
<< 56 terms handled by pshufb, the factored chains are no longer needed,
so restructure the remaining terms directly as x << 63, x >> 1, and (x
>> 1) >> 6 (= x >> 7), and XOR them into the pshufb result.

Using pshufb is the standard way to implement 8-bit and other
byte-aligned rotations with SSSE3, as done elsewhere such as in the
ChaCha code.

This reduces s0 from 11 instructions to 9 instructions and shortens its
dependency chain.  This is likely to be a modest performance
improvement, or at worst neutral, on the CPUs that use this code.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/sha512-ssse3-asm.S | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/lib/crypto/x86/sha512-ssse3-asm.S b/lib/crypto/x86/sha512-ssse3-asm.S
index d40a3361aefeb..f96ce3c083ea7 100644
--- a/lib/crypto/x86/sha512-ssse3-asm.S
+++ b/lib/crypto/x86/sha512-ssse3-asm.S
@@ -86,6 +86,7 @@ XW5 =		%xmm11
 XW6 =		%xmm12
 XW7 =		%xmm13
 XBSWAP =	%xmm14	# XMM_QWORD_BSWAP
+XROR8 =		%xmm15	# XMM_QWORD_ROR8
 
 # Useful QWORD "arrays" for simpler memory references
 # MSG, DIGEST, K_t are arrays
@@ -201,31 +202,31 @@ XBSWAP =	%xmm14	# XMM_QWORD_BSWAP
 	psrlq	$61-19, %xmm0		    # XMM0 = W[t-2] >> 42
 	xor	e_64, tmp0
 	ror	$14, tmp0 # 14
-	psrlq	$(8-7), %xmm3		    # XMM3 = W[t-15] >> 1
+	pshufb	XROR8, %xmm3		    # XMM3 = W[t-15] ror 8
 	add	tmp0, T1
 	add	h_64, T1
 	pxor	XW7, %xmm0		    # XMM0 = (W[t-2] >> 42) ^ W[t-2]
 	mov	a_64, T2
 	xor	c_64, T2
-	pxor	%xmm2, %xmm3                # XMM3 = (W[t-15] >> 1) ^ W[t-15]
+	movdqa	%xmm2, %xmm4		    # XMM4 = W[t-15]
 	and	b_64, T2
 	mov	a_64, tmp0
 	psrlq	$(19-6), %xmm0		    # XMM0 = ((W[t-2]>>42)^W[t-2])>>13
 	and	c_64, tmp0
 	xor	tmp0, T2
-	psrlq	$(7-1), %xmm3		    # XMM3 = ((W[t-15]>>1)^W[t-15])>>6
+	psllq	$63, %xmm4		    # XMM4 = W[t-15] << 63
 	mov	a_64, tmp0
 	ror	$5, tmp0 # 39
 	pxor	XW7, %xmm0		    # XMM0 = (((W[t-2]>>42)^W[t-2])>>13)^W[t-2]
 	xor	a_64, tmp0
 	ror	$6, tmp0 # 34
-	pxor	%xmm2, %xmm3                # XMM3 = (((W[t-15]>>1)^W[t-15])>>6)^W[t-15]
+	psrlq	$1, %xmm2		    # XMM2 = W[t-15] >> 1
 	xor	a_64, tmp0
 	ror	$28, tmp0 # 28
 	psrlq	$6, %xmm0                   # XMM0 = ((((W[t-2]>>42)^W[t-2])>>13)^W[t-2])>>6
 	add	tmp0, T2
 	add	T1, d_64
-	psrlq	$1, %xmm3                   # XMM3 = (((W[t-15]>>1)^W[t-15])>>6)^W[t-15]>>1
+	pxor	%xmm4, %xmm3                # XMM3 = (W[t-15] ror 8) ^ (W[t-15] << 63)
 	lea	(T1, T2), h_64
 	RotateState
 	psrldq	$8, XWK
@@ -233,25 +234,24 @@ XBSWAP =	%xmm14	# XMM_QWORD_BSWAP
 	movdqa	XW7, %xmm1		    # XMM1 = W[t-2]
 	mov	f_64, T1
 	xor	g_64, T1
-	movdqa	%xmm2, %xmm4		    # XMM4 = W[t-15]
+	pxor	%xmm2, %xmm3		    # XMM3 = (W[t-15] ror 8) ^ (W[t-15] ror 1)
 	and	e_64, T1
 	xor	g_64, T1
 	psllq	$(64-19)-(64-61) , %xmm1    # XMM1 = W[t-2] << 42
 	add	T2, T1
 	mov	e_64, tmp0
-	psllq	$(64-1)-(64-8), %xmm4	    # XMM4 = W[t-15] << 7
+	psrlq	$6, %xmm2		    # XMM2 = W[t-15] >> 7
 	ror	$23, tmp0 # 41
 	xor	e_64, tmp0
 	pxor	XW7, %xmm1		    # XMM1 = (W[t-2] << 42)^W[t-2]
 	ror	$4, tmp0 # 18
 	xor	e_64, tmp0
-	pxor	%xmm2, %xmm4		    # XMM4 = (W[t-15]<<7)^W[t-15]
+	pxor	%xmm2, %xmm3		    # XMM3 = s0(W[t-15])
 	ror	$14, tmp0 # 14
 	add	tmp0, T1
 	psllq	$(64-61), %xmm1		    # XMM1 = ((W[t-2] << 42)^W[t-2])<<3
 	add	h_64, T1
 	mov	a_64, T2
-	psllq	$(64-8), %xmm4		    # XMM4 = ((W[t-15]<<7)^W[t-15])<<56
 	xor	c_64, T2
 	and	b_64, T2
 	pxor	%xmm1, %xmm0		    # XMM0 = s1(W[t-2])
@@ -259,7 +259,6 @@ XBSWAP =	%xmm14	# XMM_QWORD_BSWAP
 	and	c_64, tmp0
 	movdqa	XW5, %xmm1		    # XMM1 = W[t-6]
 	xor	tmp0, T2
-	pxor	%xmm4, %xmm3                # XMM3 = s0(W[t-15])
 	mov	a_64, tmp0
 	paddq	%xmm3, %xmm0		    # XMM0 = s1(W[t-2]) + s0(W[t-15])
 	ror	$5, tmp0 # 39
@@ -303,6 +302,7 @@ SYM_FUNC_START(sha512_transform_ssse3)
 	push	digest
 
 	movdqa	XMM_QWORD_BSWAP(%rip), XBSWAP
+	movdqa	XMM_QWORD_ROR8(%rip), XROR8
 
 .Lupdateblock:
 
@@ -411,6 +411,12 @@ SYM_FUNC_END(sha512_transform_ssse3)
 XMM_QWORD_BSWAP:
 	.octa 0x08090a0b0c0d0e0f0001020304050607
 
+.section	.rodata.cst16.XMM_QWORD_ROR8, "aM", @progbits, 16
+.align 16
+# Mask for rotating each qword in an XMM register right by 8 bits using pshufb.
+XMM_QWORD_ROR8:
+	.octa 0x080f0e0d0c0b0a090007060504030201
+
 # Mergeable 640-byte rodata section. This allows linker to merge the table
 # with other, exactly the same 640-byte fragment of another rodata section
 # (if such section exists).
-- 
2.56.1

