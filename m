Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731111D88DD
	for <linux-crypto@vger.kernel.org>; Thu, 12 Dec 2024 21:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734038956; cv=none; b=mchiRQAI9EE+fkqk4EH4UiQxXxyuUJLTCWskjv+r/31JZUaxJz9zRipxfEyzYr+YXlIIc7FZ46oOoUfqhF/q01DjDRXIDWupvkhnUnUairPhTiuwgZKyixW70do7O2rtRg4s5a8sHicdQC4vISdayfACRoA6hX4/A5RgZpJpQh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734038956; c=relaxed/simple;
	bh=k2wxlfkrPJzpwypg33wSL3idasfAIk8ZbsJ9FQV2tN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CPwlWDFG/DctKji7AjdO03D/VdL/65oiMIB7Ok9rrciu0RQTjtv1/t80qlknyJxLK+nlYBubg5I5lCz528yP3k/k1UQXRozzIAL9ETcmKeZl2FnSFqwUnBGIedgIepip/gA63HIMmJZ6G+bfGUcUCzk/VVGxftebM7fc3ZYwGm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fAJI5dIw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fAJI5dIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 455E8C4CEDF;
	Thu, 12 Dec 2024 21:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734038956;
	bh=k2wxlfkrPJzpwypg33wSL3idasfAIk8ZbsJ9FQV2tN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fAJI5dIwADW97o04XD0Yp1TLndPHlnPuiO3YEThU5LN25gghS8QuHtjOHu9lztHd0
	 7N8sXQ2nZs4Ibh/XSB42rPQ25ThbyfR8YIk7EpDJiIAQFOUzjMFksfFjaUfa84p8Vs
	 tspHuiRkJfE/dxal475jpxx7bZkA2oLf89l7RYPCadx+B/kFQ3lbcIgETuFDAnpmzh
	 4qaZwvmwe5uO4kfVD4oPCkZ2x3m79TRyhtTz8+bM7ybAlS+TnLWPGZOZfcxbUeGSsX
	 QPpboz5pmZsR7eFaJtfvkTqVoDwCFtc808y3kh6cUdJjxMoZL4CdVcBvccoqLl8uZE
	 mCcQS+gnkfKPA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org
Subject: [PATCH v2 7/8] crypto: x86/aes-xts - more code size optimizations
Date: Thu, 12 Dec 2024 13:28:44 -0800
Message-ID: <20241212212845.40333-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212212845.40333-1-ebiggers@kernel.org>
References: <20241212212845.40333-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Prefer immediates of -128 to 128, since the former fits in a signed
byte, saving 3 bytes per instruction.  Also prefer VEX-coded
instructions to EVEX where this is easy to do.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aes-xts-avx-x86_64.S | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/arch/x86/crypto/aes-xts-avx-x86_64.S b/arch/x86/crypto/aes-xts-avx-x86_64.S
index c4e8ba6ed61d..0e6b9ae12e95 100644
--- a/arch/x86/crypto/aes-xts-avx-x86_64.S
+++ b/arch/x86/crypto/aes-xts-avx-x86_64.S
@@ -186,10 +186,11 @@
 .endif
 	// V30-V31 are currently unused.
 .endm
 
 // Move a vector between memory and a register.
+// The register operand must be in the first 16 vector registers.
 .macro	_vmovdqu	src, dst
 .if VL < 64
 	vmovdqu		\src, \dst
 .else
 	vmovdqu8	\src, \dst
@@ -206,15 +207,16 @@
 	vbroadcasti32x4	\src, \dst
 .endif
 .endm
 
 // XOR two vectors together.
+// Any register operands must be in the first 16 vector registers.
 .macro	_vpxor	src1, src2, dst
-.if USE_AVX10
-	vpxord		\src1, \src2, \dst
-.else
+.if VL < 64
 	vpxor		\src1, \src2, \dst
+.else
+	vpxord		\src1, \src2, \dst
 .endif
 .endm
 
 // XOR three vectors together.
 .macro	_xor3	src1, src2, src3_and_dst
@@ -553,22 +555,22 @@
 	_setup_round_keys	\enc
 
 	// Compute the first set of tweaks TWEAK[0-3].
 	_compute_first_set_of_tweaks
 
-	sub		$4*VL, LEN
+	add		$-4*VL, LEN  // shorter than 'sub 4*VL' when VL=32
 	jl		.Lhandle_remainder\@
 
 .Lmain_loop\@:
 	// This is the main loop, en/decrypting 4*VL bytes per iteration.
 
 	// XOR each source block with its tweak and the zero-th round key.
 .if USE_AVX10
-	vmovdqu8	0*VL(SRC), V0
-	vmovdqu8	1*VL(SRC), V1
-	vmovdqu8	2*VL(SRC), V2
-	vmovdqu8	3*VL(SRC), V3
+	_vmovdqu	0*VL(SRC), V0
+	_vmovdqu	1*VL(SRC), V1
+	_vmovdqu	2*VL(SRC), V2
+	_vmovdqu	3*VL(SRC), V3
 	vpternlogd	$0x96, TWEAK0, KEY0, V0
 	vpternlogd	$0x96, TWEAK1, KEY0, V1
 	vpternlogd	$0x96, TWEAK2, KEY0, V2
 	vpternlogd	$0x96, TWEAK3, KEY0, V3
 .else
@@ -610,13 +612,13 @@
 	_vmovdqu	V3, 3*VL(DST)
 
 	// Finish computing the next set of tweaks.
 	_tweak_step	1000
 
-	add		$4*VL, SRC
-	add		$4*VL, DST
-	sub		$4*VL, LEN
+	sub		$-4*VL, SRC  // shorter than 'add 4*VL' when VL=32
+	sub		$-4*VL, DST
+	add		$-4*VL, LEN
 	jge		.Lmain_loop\@
 
 	// Check for the uncommon case where the data length isn't a multiple of
 	// 4*VL.  Handle it out-of-line in order to optimize for the common
 	// case.  In the common case, just fall through to the ret.
-- 
2.47.1

