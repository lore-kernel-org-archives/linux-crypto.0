Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793852679;
	b=2Gq/u1MGrgGPSHmCiFFjtSEtKrKWPvNkh8aGXbKThoUdk32ZgqvB/irp8/wcU/3bPz6A
	 mYaqhQV1f79XVE5dFZDUKmLjj4BR6EPwzfS3fuwckQ1ROAe5l3NDbwUoYrDonZwuDjW29
	 8XIfFQWy2ID58KVRFzPrVv9U2w1p0XyOFJdxZ6O36dGk0O9kRTgrK07obURSqc6iwMMoE
	 sSncQiES3odUFhGNmIGH1LUEDXrvDeMXLi1uW3FZ/NikL/e1SpsQZ4B8IkfksWQ+iRFLZ
	 FCqH2BmT+BH6Plce1f6yYdN22fOEuB85kj/c88ya99uYcXrKb+JQUiEpn1VbAfFocGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793852679;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/TR8Xwdq1PpFrakKIMDSNlwwkCAg8XLQg7oJ1W7ubTo=;
	b=oU8QxUQOSCKUlKitgWbiIoii9aJWWMXr8WDu+mCqsSwSyABjh8rPFV1vh2snRWvDHkBy
	 UsgxXXq1xgluyfqWnDVr/wSa6BqP2ftfqByOWsgUQih3XZ6mejJpXtJ9EWIdHKTqDn2pe
	 JKjb2+5mkcZ9bi09FHNhaGami32tkzo2chVeHbwSXaJ3vT6yxJesiCf1xe6r6VT4IMZe3
	 4mQCpOnV0YyiVIwTYv6SHu6ojHjlVuLaHG9eyaGL9+3/n7oLh6URzZwdnJrjk6qgXncnK
	 RYiPUgoqX9FfQR8Nx8LY0WEWuP9GfHfHIL57tyl9LL5g26LKLgE91JYx3OhYBU+ltDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BFXjvs1r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26B6606A31B
	for <linux-crypto@vger.kernel.org>; Thu,  5 Nov 2026 04:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BFXjvs1r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375561F000C1;
	Thu,  5 Nov 2026 04:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793852678;
	bh=/TR8Xwdq1PpFrakKIMDSNlwwkCAg8XLQg7oJ1W7ubTo=;
	h=From:To:Cc:Subject:Date;
	b=BFXjvs1r9WAqlZ53TuHFDr0NE3u9yTD2mWD1alT6C8wNG9MgMxq/f8+LxNThSEWEM
	 QcRXo5tmWSUQN737d6aKOdy9GoixHbsWG432doE3GiKtNYg3WeoT495s7pHL/QdYHl
	 bT/PQqoFXZWORPjQPAtb9jKtBN5gf/vomxtWB5NP0gQ683utS4oBGtYR4fc+wV700t
	 XTW6YdUA7mSgODNX9uKi0sL+DyObsjf/TuRW9Ajqgu2fEdJKao4FmZwyLVLhjLC7JE
	 oU9G+m+ubjEktoDmFT6iAVqd7u/dxUhx3/pBwsTFAK4FdoK+dwh9uDbsheI85r0HTF
	 cM+iRQDa5K8uA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: x86/nh: Optimize nh_sse2()
Date: Wed,  4 Nov 2026 20:24:27 -0800
Message-ID: <20261105042427.307868-1-ebiggers@kernel.org>
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

Various microoptimizations for nh_sse2().  Nothing too exciting:

- Instead of adding the message words to the key words and then
  permuting both, do the following: permute both when loading, add the
  permuted words, and multiply together adjacent pairs.  This saves two
  pshufd instructions per 16 bytes processed, and the ones that remain
  are now better separated in the flow.

- Reassign register aliases to put the most frequently used variables in
  %xmm0-%xmm7, which take fewer bytes to encode in many instructions.

- Replace the unnecessary T7 with T0.

- Replace the 'add $0x30, KEY' with base+displacement addressing, which
  was already being used anyway in most cases.

nh_sse2() shrinks from 1038 bytes to 913 bytes, and a quick benchmark
(with AVX2 support disabled) shows 3% faster Adiantum encryption.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/nh-sse2.S | 60 +++++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 29 deletions(-)

diff --git a/lib/crypto/x86/nh-sse2.S b/lib/crypto/x86/nh-sse2.S
index d36c0e6d5556..b3f17e1dfbdb 100644
--- a/lib/crypto/x86/nh-sse2.S
+++ b/lib/crypto/x86/nh-sse2.S
@@ -9,22 +9,21 @@
 
 #include <linux/linkage.h>
 
-#define		PASS0_SUMS	%xmm0
-#define		PASS1_SUMS	%xmm1
-#define		PASS2_SUMS	%xmm2
-#define		PASS3_SUMS	%xmm3
-#define		K0		%xmm4
-#define		K1		%xmm5
-#define		K2		%xmm6
-#define		K3		%xmm7
-#define		T0		%xmm8
-#define		T1		%xmm9
-#define		T2		%xmm10
-#define		T3		%xmm11
-#define		T4		%xmm12
-#define		T5		%xmm13
-#define		T6		%xmm14
-#define		T7		%xmm15
+#define		K0		%xmm0
+#define		K1		%xmm1
+#define		K2		%xmm2
+#define		K3		%xmm3
+#define		T0		%xmm4
+#define		T1		%xmm5
+#define		T2		%xmm6
+#define		T3		%xmm7
+#define		T4		%xmm8
+#define		T5		%xmm9
+#define		T6		%xmm10
+#define		PASS0_SUMS	%xmm11
+#define		PASS1_SUMS	%xmm12
+#define		PASS2_SUMS	%xmm13
+#define		PASS3_SUMS	%xmm14
 #define		KEY		%rdi
 #define		MESSAGE		%rsi
 #define		MESSAGE_LEN	%rdx
@@ -36,9 +35,14 @@
 	movdqu		\offset(MESSAGE), T1
 
 	// Load next key stride
-	movdqu		\offset(KEY), \k3
+	movdqu		\offset+0x30(KEY), \k3
 
-	// Add message words to key words
+	// Permute message and key words from (0, 1, 2, 3) to (0, 2, 1, 3).
+	// This puts the words that NH multiplies together next to each other.
+	pshufd		$0xd8, T1, T1
+	pshufd		$0xd8, \k3, \k3
+
+	// Add permuted message words to permuted key words
 	movdqa		T1, T2
 	movdqa		T1, T3
 	paddd		T1, \k0    // reuse k0 to avoid a move
@@ -46,19 +50,15 @@
 	paddd		\k2, T2
 	paddd		\k3, T3
 
-	// Multiply 32x32 => 64 and accumulate
-	pshufd		$0x10, \k0, T4
-	pshufd		$0x32, \k0, \k0
-	pshufd		$0x10, T1, T5
-	pshufd		$0x32, T1, T1
-	pshufd		$0x10, T2, T6
-	pshufd		$0x32, T2, T2
-	pshufd		$0x10, T3, T7
-	pshufd		$0x32, T3, T3
+	// Multiply 32x32 (adjacent pairs) => 64 and accumulate
+	pshufd		$0x31, \k0, T4
+	pshufd		$0x31, T1, T5
+	pshufd		$0x31, T2, T6
+	pshufd		$0x31, T3, T0
 	pmuludq		T4, \k0
 	pmuludq		T5, T1
 	pmuludq		T6, T2
-	pmuludq		T7, T3
+	pmuludq		T0, T3
 	paddq		\k0, PASS0_SUMS
 	paddq		T1, PASS1_SUMS
 	paddq		T2, PASS2_SUMS
@@ -76,7 +76,9 @@ SYM_FUNC_START(nh_sse2)
 	movdqu		0x00(KEY), K0
 	movdqu		0x10(KEY), K1
 	movdqu		0x20(KEY), K2
-	add		$0x30, KEY
+	pshufd		$0xd8, K0, K0
+	pshufd		$0xd8, K1, K1
+	pshufd		$0xd8, K2, K2
 	pxor		PASS0_SUMS, PASS0_SUMS
 	pxor		PASS1_SUMS, PASS1_SUMS
 	pxor		PASS2_SUMS, PASS2_SUMS

base-commit: 9fbbbaefd5f95551da18426c200cf41e1b4255a1
-- 
2.56.0

