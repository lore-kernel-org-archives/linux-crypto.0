Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793852686;
	b=ApaA1fPKIGhX4sGlXAhWzL4iJz8f88n/mdT6NhgABy8X4lZ9YoZ71P6SFpV3j+47mcFm
	 +cRUz3pQNyOl/Ocko4GzUuBrop6AFfq1FCr4rSiNH0VaeiHoctmUGMn82HU1OhAAzfmnR
	 9+FLLytQhIctyZLJgJKQtYZZhcAYyOCd+XwDh7qxLNXN6T9snCT2M8d7B+3pQQNSjNmd9
	 rraBPu4AM2Xi7CtyMLeQ3+DrhgEGNlBQ3yPCv9nl2GCkExvt13Izy/HUKSB5lItdfrBsR
	 XKRxSuT9I2upGbnrmpaHo5uQNKU0XvapQKQ+jvGOUOvJWo+VSIhBELUJDX0/KjK2MGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793852686;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KULSM/ptFA2jiWLBpbkBTOSrXDoTQx0lLvinntyec8Y=;
	b=y0JEuLZTlMuue3mfrlOzioVu45R9fBb6SrxAswd7Ca1/3CGiIoH4lzEFTdOyWu146bRv
	 cAfnv7x/mtewh2HzflGhe8xo0g/zfqIwga+UGwK8hpEtHjGv9itE5hWrW3FcUGQ2YCDcr
	 4Cb+i6fXdJCR8cfsxQ0SKL9p7oz/AL9iTGAJOn+qx0V3/H+l+9vtyGD7H1nHm5Jr4CXgM
	 ii6YFSCCMzzkL1SHpGJajgMESuddUyWP2/OOfbz4Z9frAJATgHhDhIkxj5UBuRmOqry9K
	 Eny1uh0p7jtd55gD3z+3+8yd/co6gCgX9sLqQM50pZ0XvEMK42r32ZE91MwSWU2JSWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZtdbzFVR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E456E606A328
	for <linux-crypto@vger.kernel.org>; Thu,  5 Nov 2026 04:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZtdbzFVR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657CB1F000C1;
	Thu,  5 Nov 2026 04:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793852685;
	bh=KULSM/ptFA2jiWLBpbkBTOSrXDoTQx0lLvinntyec8Y=;
	h=From:To:Cc:Subject:Date;
	b=ZtdbzFVRBBD/5MRMpIOydFx2qcaG85db7CLTYv5rI4YsP/AXk0HhFRNf9aAAg+X3f
	 c8iSveN9BpPudq0bwhwa7U1vx3lhf0NVmBAN59eXmAGyuNtsq7vscNr5HZrIWgU7WC
	 JDfdhJkMLvHzwf1vedJSxbSS6AbNd1Fvb5VYXIoOf8gAJncapy7h6pY56vd9n1GMvJ
	 zt0dPR9xBCI5EVWCnJbfLI0+KG2lqrmnEnh4/C1Zcjw9fcLWe9bWGHLpUX3ZYDBGw+
	 jFjYTt4WLRIPuiiPWlvBABxINP2wnOF5mPh+dqTPiTWMm/fJaSfUFMMRgMN9F8NhkW
	 uJJMQ4xFGnjWg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: x86/nh: Optimize nh_avx2()
Date: Wed,  4 Nov 2026 20:24:42 -0800
Message-ID: <20261105042442.308062-1-ebiggers@kernel.org>
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

Various microoptimizations for nh_avx2().  Nothing too exciting:

- Instead of adding the message words to the key words and then
  permuting both, do the following: permute both when loading, add the
  permuted words, and multiply together adjacent pairs.  This saves one
  vpshufd instruction per 32 bytes processed, and the ones that remain
  are now better separated in the flow.

- Reassign register aliases to put the most frequently used variables in
  %ymm0-%ymm7, which take fewer bytes to encode in many instructions.

- Update the registers used in _nh_2xstride() to match nh_sse2() and
  eliminate the need for T7.

- Replace the initial 'add $0x20, KEY' with base+displacement
  addressing, which was already being used anyway in most cases.

- Update the horizontal sum algorithm at the end of the function to save
  a couple instructions.

nh_avx2() shrinks from 664 bytes to 518 bytes, and a quick benchmark
shows 1% faster Adiantum encryption on x86_64.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/nh-avx2.S | 116 +++++++++++++++++++--------------------
 1 file changed, 57 insertions(+), 59 deletions(-)

diff --git a/lib/crypto/x86/nh-avx2.S b/lib/crypto/x86/nh-avx2.S
index 9c085a31b137..a2e9ed68dcd4 100644
--- a/lib/crypto/x86/nh-avx2.S
+++ b/lib/crypto/x86/nh-avx2.S
@@ -9,55 +9,55 @@
 
 #include <linux/linkage.h>
 
-#define		PASS0_SUMS	%ymm0
-#define		PASS1_SUMS	%ymm1
-#define		PASS2_SUMS	%ymm2
-#define		PASS3_SUMS	%ymm3
-#define		K0		%ymm4
-#define		K0_XMM		%xmm4
-#define		K1		%ymm5
-#define		K1_XMM		%xmm5
-#define		K2		%ymm6
-#define		K2_XMM		%xmm6
-#define		K3		%ymm7
-#define		K3_XMM		%xmm7
-#define		T0		%ymm8
-#define		T1		%ymm9
-#define		T2		%ymm10
-#define		T2_XMM		%xmm10
-#define		T3		%ymm11
-#define		T3_XMM		%xmm11
-#define		T4		%ymm12
-#define		T5		%ymm13
-#define		T6		%ymm14
-#define		T7		%ymm15
+#define		K0		%ymm0
+#define		K0_XMM		%xmm0
+#define		K1		%ymm1
+#define		K1_XMM		%xmm1
+#define		K2		%ymm2
+#define		K2_XMM		%xmm2
+#define		K3		%ymm3
+#define		K3_XMM		%xmm3
+#define		T0		%ymm4
+#define		T1		%ymm5
+#define		T2		%ymm6
+#define		T2_XMM		%xmm6
+#define		T3		%ymm7
+#define		T3_XMM		%xmm7
+#define		T4		%ymm8
+#define		T5		%ymm9
+#define		T6		%ymm10
+#define		PASS0_SUMS	%ymm11
+#define		PASS1_SUMS	%ymm12
+#define		PASS2_SUMS	%ymm13
+#define		PASS3_SUMS	%ymm14
 #define		KEY		%rdi
 #define		MESSAGE		%rsi
 #define		MESSAGE_LEN	%rdx
 #define		HASH		%rcx
 
+// Process 32 message bytes and accumulate the NH sums in PASS[0-3]_SUMS.  The
+// message words are expected in T3 and the key words in \k0-\k3.  Each group of
+// four message and key words must be in the order (0, 2, 1, 3), so that the
+// words multiplied by NH are next to each other.  This clobbers \k0 and T0-T6.
+// It leaves \k1-\k3 alone, since they're needed for the next 32 bytes.
 .macro _nh_2xstride	k0, k1, k2, k3
 
-	// Add message words to key words
-	vpaddd		\k0, T3, T0
+	// Add permuted message words to permuted key words
+	vpaddd		\k0, T3, \k0
 	vpaddd		\k1, T3, T1
 	vpaddd		\k2, T3, T2
 	vpaddd		\k3, T3, T3
 
-	// Multiply 32x32 => 64 and accumulate
-	vpshufd		$0x10, T0, T4
-	vpshufd		$0x32, T0, T0
-	vpshufd		$0x10, T1, T5
-	vpshufd		$0x32, T1, T1
-	vpshufd		$0x10, T2, T6
-	vpshufd		$0x32, T2, T2
-	vpshufd		$0x10, T3, T7
-	vpshufd		$0x32, T3, T3
-	vpmuludq	T4, T0, T0
-	vpmuludq	T5, T1, T1
-	vpmuludq	T6, T2, T2
-	vpmuludq	T7, T3, T3
-	vpaddq		T0, PASS0_SUMS, PASS0_SUMS
+	// Multiply 32x32 (adjacent pairs) => 64 and accumulate
+	vpshufd		$0x31, \k0, T4
+	vpshufd		$0x31, T1, T5
+	vpshufd		$0x31, T2, T6
+	vpshufd		$0x31, T3, T0
+	vpmuludq	\k0, T4, \k0
+	vpmuludq	T1, T5, T1
+	vpmuludq	T2, T6, T2
+	vpmuludq	T3, T0, T3
+	vpaddq		\k0, PASS0_SUMS, PASS0_SUMS
 	vpaddq		T1, PASS1_SUMS, PASS1_SUMS
 	vpaddq		T2, PASS2_SUMS, PASS2_SUMS
 	vpaddq		T3, PASS3_SUMS, PASS3_SUMS
@@ -71,9 +71,8 @@
  */
 SYM_FUNC_START(nh_avx2)
 
-	vmovdqu		0x00(KEY), K0
-	vmovdqu		0x10(KEY), K1
-	add		$0x20, KEY
+	vpshufd		$0xd8, 0x00(KEY), K0
+	vpshufd		$0xd8, 0x10(KEY), K1
 	vpxor		PASS0_SUMS, PASS0_SUMS, PASS0_SUMS
 	vpxor		PASS1_SUMS, PASS1_SUMS, PASS1_SUMS
 	vpxor		PASS2_SUMS, PASS2_SUMS, PASS2_SUMS
@@ -82,14 +81,14 @@ SYM_FUNC_START(nh_avx2)
 	sub		$0x40, MESSAGE_LEN
 	jl		.Lloop4_done
 .Lloop4:
-	vmovdqu		(MESSAGE), T3
-	vmovdqu		0x00(KEY), K2
-	vmovdqu		0x10(KEY), K3
+	vpshufd		$0xd8, (MESSAGE), T3
+	vpshufd		$0xd8, 0x20(KEY), K2
+	vpshufd		$0xd8, 0x30(KEY), K3
 	_nh_2xstride	K0, K1, K2, K3
 
-	vmovdqu		0x20(MESSAGE), T3
-	vmovdqu		0x20(KEY), K0
-	vmovdqu		0x30(KEY), K1
+	vpshufd		$0xd8, 0x20(MESSAGE), T3
+	vpshufd		$0xd8, 0x40(KEY), K0
+	vpshufd		$0xd8, 0x50(KEY), K1
 	_nh_2xstride	K2, K3, K0, K1
 
 	add		$0x40, MESSAGE
@@ -105,9 +104,9 @@ SYM_FUNC_START(nh_avx2)
 	jl		.Llast
 
 	// 2 or 3 strides remain; do 2 more.
-	vmovdqu		(MESSAGE), T3
-	vmovdqu		0x00(KEY), K2
-	vmovdqu		0x10(KEY), K3
+	vpshufd		$0xd8, (MESSAGE), T3
+	vpshufd		$0xd8, 0x20(KEY), K2
+	vpshufd		$0xd8, 0x30(KEY), K3
 	_nh_2xstride	K0, K1, K2, K3
 	add		$0x20, MESSAGE
 	add		$0x20, KEY
@@ -118,11 +117,11 @@ SYM_FUNC_START(nh_avx2)
 .Llast:
 	// Last stride.  Zero the high 128 bits of the message and keys so they
 	// don't affect the result when processing them like 2 strides.
-	vmovdqu		(MESSAGE), T3_XMM
+	vpshufd		$0xd8, (MESSAGE), T3_XMM
 	vmovdqa		K0_XMM, K0_XMM
 	vmovdqa		K1_XMM, K1_XMM
-	vmovdqu		0x00(KEY), K2_XMM
-	vmovdqu		0x10(KEY), K3_XMM
+	vpshufd		$0xd8, 0x20(KEY), K2_XMM
+	vpshufd		$0xd8, 0x30(KEY), K3_XMM
 	_nh_2xstride	K0, K1, K2, K3
 
 .Ldone:
@@ -144,14 +143,13 @@ SYM_FUNC_START(nh_avx2)
 	vpunpcklqdq	PASS3_SUMS, PASS2_SUMS, T2	// T2 = (2A 3A 2C 3C)
 	vpunpckhqdq	PASS3_SUMS, PASS2_SUMS, T3	// T3 = (2B 3B 2D 3D)
 
-	vinserti128	$0x1, T2_XMM, T0, T4		// T4 = (0A 1A 2A 3A)
-	vinserti128	$0x1, T3_XMM, T1, T5		// T5 = (0B 1B 2B 3B)
-	vperm2i128	$0x31, T2, T0, T0		// T0 = (0C 1C 2C 3C)
-	vperm2i128	$0x31, T3, T1, T1		// T1 = (0D 1D 2D 3D)
+	vpaddq		T1, T0, T0			// T0 = (0A+0B 1A+1B 0C+0D 1C+1D)
+	vpaddq		T3, T2, T2			// T2 = (2A+2B 3A+3B 2C+2D 3C+3D)
+
+	vinserti128	$0x1, T2_XMM, T0, T1		// T1 = (0A+0B 1A+1B 2A+2B 3A+3B)
+	vperm2i128	$0x31, T2, T0, T0		// T0 = (0C+0D 1C+1D 2C+2D 3C+3D)
 
-	vpaddq		T5, T4, T4
 	vpaddq		T1, T0, T0
-	vpaddq		T4, T0, T0
 	vmovdqu		T0, (HASH)
 	vzeroupper
 	RET

base-commit: 9fbbbaefd5f95551da18426c200cf41e1b4255a1
-- 
2.56.0

