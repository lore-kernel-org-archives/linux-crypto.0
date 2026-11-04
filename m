Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793772781;
	b=XkhpTPGUZn7aOAsA8uwI7keIXGiUCu6po1Gc9JUiRkSu4C7mJ0Znhx1mK9BkVDWWYToS
	 jPK6eJjj3eSd/V0ysopJUNH+orMKDWRDEmDEFfG8u1ND4V9ac5ewHpxGIImv8JKxpflv9
	 At+X0PHTwxjTAHmyBTDPK/MD7e3fXswZrxhwfV0FqWon+rPWRiDolfUXP3jbxbAKPQlm/
	 EB07xL/9Wa/J7nz4BR+aJe5B/aZC+X/0Kqw7gxunD3CocQCefcVi9CuaoO1ys/xPDbAnP
	 iuOADJLX/mmPl4zNY+bGoi7vt0xFwtdipViBzfjXrQUWYCPSyJnMDoOH0rb1SfJO48Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793772781;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/nxu4F+3pYkAz6GViSKXLdmxtL+dRDmn27jmi2r5e9w=;
	b=vNMurc2rvmlkAoNsdTfVxobWf5V7yDX1Gfy8xrH7789tSGLzdQQTJhR3+RCl7BZ/2kOc
	 9JxGOuNMsh9QFi5SVNc4AdlPCk50qRZt0q2afNDGXJS+EkcXfzSb95BJAXXYRVO+hQtcq
	 GRqVvDEA4uoayL9b/QpoCaCoY6xYQFFXSXQ9GpirCs3nb0AxU34l5QpCXuCUo7vFFyMYY
	 oXNbyirGRFDwECt/ShUIxMouM4f7m3XnTdYN/jzjG2v7gxe6vUGB1XX3Q4ehwcx9T5EDY
	 zfkFQ7Bjwdw8b3nUa+JHNhkSG0G6Av60/821S7rWailHzZqAuq6YsXfs7ZlHCE2OJNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ao7TncCG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E07606A31B
	for <linux-crypto@vger.kernel.org>; Wed,  4 Nov 2026 06:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ao7TncCG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBDAB1F000C1;
	Wed,  4 Nov 2026 06:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793772781;
	bh=/nxu4F+3pYkAz6GViSKXLdmxtL+dRDmn27jmi2r5e9w=;
	h=From:To:Cc:Subject:Date;
	b=Ao7TncCGgi1p8xC7QS0YSYBrQU7O/vySKQb8sfZMlvDeN9stFyu3dcM2WGyqF4T0a
	 4rbzH6QawWsucvFyId0ag19/j7lj1BtA9hkDhxbAPKXDiGFVGGZ/SudRIwrDIrsHnr
	 cv6ZJQu+p3iTtVPmvsk0uvXntH00ePwsy2vrsPbEP3v6Svl7q0/4G7RRYgoOlljdxB
	 j9iCtydgCAAq8RKpqECOuIuuo1UBHPSjyJJEHhuKQOYzoiRbPgp3VXPtcg6hI7kGDq
	 HPQNi+TOdZhaj/rxvQutVyxrdPdis6fdtPEbu40hR+apIeDQo8dDcS6fvB3tGO7PZP
	 aGWf//42xbOoQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Martin Willi <martin@strongswan.org>,
	Antonio Quartulli <antonio@mandelbit.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: x86/chacha: Improve interleaving in chacha_8block_xor_avx512vl()
Date: Tue,  3 Nov 2026 22:12:09 -0800
Message-ID: <20261104061209.143901-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
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

The 'VL == 64' case has an optimization that eliminates some 'vmovdqa64'
instructions, but it was not carried over to the 'VL == 32' case.  Do
so, and make most of the code that interleaves 64-bit words shared.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/chacha-avx512-x86_64.S | 77 ++++++++++-----------------
 1 file changed, 27 insertions(+), 50 deletions(-)

diff --git a/lib/crypto/x86/chacha-avx512-x86_64.S b/lib/crypto/x86/chacha-avx512-x86_64.S
index ffdfe005cba6..bfa708c5e3ee 100644
--- a/lib/crypto/x86/chacha-avx512-x86_64.S
+++ b/lib/crypto/x86/chacha-avx512-x86_64.S
@@ -699,152 +699,129 @@ SYM_FUNC_END(chacha_4block_xor_avx512vl)
 	vpunpckldq	V15,V14,V30
 	vpunpckhdq	V15,V14,V31
 
-.if VL == 32
 	# interleave 64-bit words in state n, n+2
+.if VL == 32
+	vpunpckhqdq	V18,V16,V1
+	vpunpcklqdq	V18,V16,V16 # leave V0 free to use as temporary register
+.else
 	vpunpcklqdq	V18,V16,V0
-	vpunpcklqdq	V19,V17,V1
-	vpunpckhqdq	V18,V16,V2
+	vpunpckhqdq	V18,V16,V1
+.endif
+	vpunpcklqdq	V19,V17,V2
 	vpunpckhqdq	V19,V17,V3
 	vpunpcklqdq	V22,V20,V4
-	vpunpcklqdq	V23,V21,V5
-	vpunpckhqdq	V22,V20,V6
+	vpunpckhqdq	V22,V20,V5
+	vpunpcklqdq	V23,V21,V6
 	vpunpckhqdq	V23,V21,V7
 	vpunpcklqdq	V26,V24,V8
-	vpunpcklqdq	V27,V25,V9
-	vpunpckhqdq	V26,V24,V10
+	vpunpckhqdq	V26,V24,V9
+	vpunpcklqdq	V27,V25,V10
 	vpunpckhqdq	V27,V25,V11
 	vpunpcklqdq	V30,V28,V12
-	vpunpcklqdq	V31,V29,V13
-	vpunpckhqdq	V30,V28,V14
+	vpunpckhqdq	V30,V28,V13
+	vpunpcklqdq	V31,V29,V14
 	vpunpckhqdq	V31,V29,V15
 
+.if VL == 32
 	# interleave 128-bit words in state n, n+4
 	# xor/write first four blocks
-	vmovdqa64	V0,V16
-	vperm2i128	$0x20,V4,V0,V0
+	vshufi64x2	$0x0,V4,V16,V0
 	cmp		$0x0020,%rcx
 	jl		.Lxorpart\@
 	vpxord		0x0000(%rdx),V0,V0
 	vmovdqu64	V0,0x0000(%rsi)
-	vmovdqa64	V16,V0
-	vperm2i128	$0x31,V4,V0,V4
 
 	vperm2i128	$0x20,V12,V8,V0
 	cmp		$0x0040,%rcx
 	jl		.Lxorpart\@
 	vpxord		0x0020(%rdx),V0,V0
 	vmovdqu64	V0,0x0020(%rsi)
-	vperm2i128	$0x31,V12,V8,V12
 
-	vperm2i128	$0x20,V6,V2,V0
+	vperm2i128	$0x20,V5,V1,V0
 	cmp		$0x0060,%rcx
 	jl		.Lxorpart\@
 	vpxord		0x0040(%rdx),V0,V0
 	vmovdqu64	V0,0x0040(%rsi)
-	vperm2i128	$0x31,V6,V2,V6
 
-	vperm2i128	$0x20,V14,V10,V0
+	vperm2i128	$0x20,V13,V9,V0
 	cmp		$0x0080,%rcx
 	jl		.Lxorpart\@
 	vpxord		0x0060(%rdx),V0,V0
 	vmovdqu64	V0,0x0060(%rsi)
-	vperm2i128	$0x31,V14,V10,V14
 
-	vperm2i128	$0x20,V5,V1,V0
+	vperm2i128	$0x20,V6,V2,V0
 	cmp		$0x00a0,%rcx
 	jl		.Lxorpart\@
 	vpxord		0x0080(%rdx),V0,V0
 	vmovdqu64	V0,0x0080(%rsi)
-	vperm2i128	$0x31,V5,V1,V5
 
-	vperm2i128	$0x20,V13,V9,V0
+	vperm2i128	$0x20,V14,V10,V0
 	cmp		$0x00c0,%rcx
 	jl		.Lxorpart\@
 	vpxord		0x00a0(%rdx),V0,V0
 	vmovdqu64	V0,0x00a0(%rsi)
-	vperm2i128	$0x31,V13,V9,V13
 
 	vperm2i128	$0x20,V7,V3,V0
 	cmp		$0x00e0,%rcx
 	jl		.Lxorpart\@
 	vpxord		0x00c0(%rdx),V0,V0
 	vmovdqu64	V0,0x00c0(%rsi)
-	vperm2i128	$0x31,V7,V3,V7
 
 	vperm2i128	$0x20,V15,V11,V0
 	cmp		$0x0100,%rcx
 	jl		.Lxorpart\@
 	vpxord		0x00e0(%rdx),V0,V0
 	vmovdqu64	V0,0x00e0(%rsi)
-	vperm2i128	$0x31,V15,V11,V15
 
 	# xor remaining blocks, write to output
-	vmovdqa64	V4,V0
+	vshufi64x2	$0x3,V4,V16,V0
 	cmp		$0x0120,%rcx
 	jl		.Lxorpart\@
 	vpxord		0x0100(%rdx),V0,V0
 	vmovdqu64	V0,0x0100(%rsi)
 
-	vmovdqa64	V12,V0
+	vperm2i128	$0x31,V12,V8,V0
 	cmp		$0x0140,%rcx
 	jl		.Lxorpart\@
 	vpxord		0x0120(%rdx),V0,V0
 	vmovdqu64	V0,0x0120(%rsi)
 
-	vmovdqa64	V6,V0
+	vperm2i128	$0x31,V5,V1,V0
 	cmp		$0x0160,%rcx
 	jl		.Lxorpart\@
 	vpxord		0x0140(%rdx),V0,V0
 	vmovdqu64	V0,0x0140(%rsi)
 
-	vmovdqa64	V14,V0
+	vperm2i128	$0x31,V13,V9,V0
 	cmp		$0x0180,%rcx
 	jl		.Lxorpart\@
 	vpxord		0x0160(%rdx),V0,V0
 	vmovdqu64	V0,0x0160(%rsi)
 
-	vmovdqa64	V5,V0
+	vperm2i128	$0x31,V6,V2,V0
 	cmp		$0x01a0,%rcx
 	jl		.Lxorpart\@
 	vpxord		0x0180(%rdx),V0,V0
 	vmovdqu64	V0,0x0180(%rsi)
 
-	vmovdqa64	V13,V0
+	vperm2i128	$0x31,V14,V10,V0
 	cmp		$0x01c0,%rcx
 	jl		.Lxorpart\@
 	vpxord		0x01a0(%rdx),V0,V0
 	vmovdqu64	V0,0x01a0(%rsi)
 
-	vmovdqa64	V7,V0
+	vperm2i128	$0x31,V7,V3,V0
 	cmp		$0x01e0,%rcx
 	jl		.Lxorpart\@
 	vpxord		0x01c0(%rdx),V0,V0
 	vmovdqu64	V0,0x01c0(%rsi)
 
-	vmovdqa64	V15,V0
+	vperm2i128	$0x31,V15,V11,V0
 	cmp		$0x0200,%rcx
 	jl		.Lxorpart\@
 	vpxord		0x01e0(%rdx),V0,V0
 	vmovdqu64	V0,0x01e0(%rsi)
 .else
-	# interleave 64-bit words in state n, n+2 -> zmm0..15
-	vpunpcklqdq	V18,V16,V0
-	vpunpckhqdq	V18,V16,V1
-	vpunpcklqdq	V19,V17,V2
-	vpunpckhqdq	V19,V17,V3
-	vpunpcklqdq	V22,V20,V4
-	vpunpckhqdq	V22,V20,V5
-	vpunpcklqdq	V23,V21,V6
-	vpunpckhqdq	V23,V21,V7
-	vpunpcklqdq	V26,V24,V8
-	vpunpckhqdq	V26,V24,V9
-	vpunpcklqdq	V27,V25,V10
-	vpunpckhqdq	V27,V25,V11
-	vpunpcklqdq	V30,V28,V12
-	vpunpckhqdq	V30,V28,V13
-	vpunpcklqdq	V31,V29,V14
-	vpunpckhqdq	V31,V29,V15
-
 	# interleave 128-bit lanes in state n, n+4 -> zmm16..31
 	vshufi64x2	$0x88,V4,V0,V16
 	vshufi64x2	$0x88,V12,V8,V20

base-commit: 9fbbbaefd5f95551da18426c200cf41e1b4255a1
prerequisite-patch-id: 890b33260038bff2e3adfe7867af5919666677fc
prerequisite-patch-id: 36cadf8c358a9778d745637c00368df82a93ce0d
-- 
2.56.0

