Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12CE22C36B
	for <linux-crypto@vger.kernel.org>; Tue, 10 Dec 2024 23:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733875149; cv=none; b=FY3RSRupgY6Mo70XkqiLGZ2VD6xVPM32PelY0KPIijFB677TkbCWpbDhZ5GNGrtZnSq9g21Dj2CqS33yXgo40nUK7+MnoTxnZcG7KmcbAsv/9xc4REaNe6eKwRhpRwOHRpe921K8YsZ8pe72kaMFrZVw3vVXjs/EvoGEsg5/bgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733875149; c=relaxed/simple;
	bh=LBJA3XyLgyAElFN5tiUy0YDumdSdf3apuk7wD3unCkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vv5JBCwT/HMx4wV9fB5FYIQUQwdcQs3GAhz2bx9XlYR/fz310VGHA/nJccbiQxh4lX32SVxh8NuRVey5FXyB7df92D7GxA5YBznEA/Lyxkza3lMaZs9D1DeEf/gYx3IgM6HzLaTaOUc2r7lD6I6hBv712/UXlF6hgi3NfYTttmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q6BfAYQ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q6BfAYQ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A31CC4CEE0;
	Tue, 10 Dec 2024 23:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733875149;
	bh=LBJA3XyLgyAElFN5tiUy0YDumdSdf3apuk7wD3unCkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q6BfAYQ/A4sRnVcGGbICFFFFjF8zD17E1XVNZQT/rOl1LPwtevI8ciY4tB+1vfvOS
	 bZ+rYBdE+E+rtUF77996ztXeg1/N34j28EFGEiPjd0lmIOuN6UkzLkPZ8LvKw3oCg7
	 USgQ97oFUXt7KpLaN7lFHPCsVyPXByLWF8y2cPFbvNDFSuFBksxjRRkDTJ26RjwTbV
	 4Yu0sP6If0iSGWpwjNyrZsiyV5NEU2/XTKK2wN4kMaVx39A2bLjjvWJYopEIQb/gJS
	 tlZoDhxL9sVxcR8rQash2xPHLX1H04ZOJSYkyyjND+StKvsfp4C9wQvB91IIadPX9g
	 +sszOwXfaiv5g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org
Subject: [PATCH 1/7] crypto: x86/aes-gcm - code size optimization
Date: Tue, 10 Dec 2024 15:58:28 -0800
Message-ID: <20241210235834.40862-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241210235834.40862-1-ebiggers@kernel.org>
References: <20241210235834.40862-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Prefer immediates of -128 to 128, since the former fits in a signed
byte, saving 3 bytes per instruction.  Also replace a vpand and vpxor
with a vpternlogd.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aes-gcm-avx10-x86_64.S | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/crypto/aes-gcm-avx10-x86_64.S b/arch/x86/crypto/aes-gcm-avx10-x86_64.S
index 97e0ee515fc5f..8989bf9b8384d 100644
--- a/arch/x86/crypto/aes-gcm-avx10-x86_64.S
+++ b/arch/x86/crypto/aes-gcm-avx10-x86_64.S
@@ -382,12 +382,12 @@
 	// wide shift instruction, so instead double each of the two 64-bit
 	// halves and incorporate the internal carry bit into the value XOR'd.
 	vpshufd		$0xd3, H_CUR_XMM, %xmm0
 	vpsrad		$31, %xmm0, %xmm0
 	vpaddq		H_CUR_XMM, H_CUR_XMM, H_CUR_XMM
-	vpand		.Lgfpoly_and_internal_carrybit(%rip), %xmm0, %xmm0
-	vpxor		%xmm0, H_CUR_XMM, H_CUR_XMM
+	// H_CUR_XMM ^= xmm0 & gfpoly_and_internal_carrybit
+	vpternlogd	$0x78, .Lgfpoly_and_internal_carrybit(%rip), %xmm0, H_CUR_XMM
 
 	// Load the gfpoly constant.
 	vbroadcasti32x4	.Lgfpoly(%rip), GFPOLY
 
 	// Square H^1 to get H^2.
@@ -711,11 +711,11 @@
 	// that processes 4*VL bytes of data at a time.  Otherwise skip it.
 	//
 	// Pre-subtracting 4*VL from DATALEN saves an instruction from the main
 	// loop and also ensures that at least one write always occurs to
 	// DATALEN, zero-extending it and allowing DATALEN64 to be used later.
-	sub		$4*VL, DATALEN
+	add		$-4*VL, DATALEN  // shorter than 'sub 4*VL' when VL=32
 	jl		.Lcrypt_loop_4x_done\@
 
 	// Load powers of the hash key.
 	vmovdqu8	OFFSETOFEND_H_POWERS-4*VL(KEY), H_POW4
 	vmovdqu8	OFFSETOFEND_H_POWERS-3*VL(KEY), H_POW3
@@ -758,13 +758,13 @@
 	vaesenclast	RNDKEYLAST3, V3, GHASHDATA3
 	vmovdqu8	GHASHDATA0, 0*VL(DST)
 	vmovdqu8	GHASHDATA1, 1*VL(DST)
 	vmovdqu8	GHASHDATA2, 2*VL(DST)
 	vmovdqu8	GHASHDATA3, 3*VL(DST)
-	add		$4*VL, SRC
-	add		$4*VL, DST
-	sub		$4*VL, DATALEN
+	sub		$-4*VL, SRC  // shorter than 'add 4*VL' when VL=32
+	sub		$-4*VL, DST
+	add		$-4*VL, DATALEN
 	jl		.Lghash_last_ciphertext_4x\@
 .endif
 
 	// Cache as many additional AES round keys as possible.
 .irp i, 9,8,7,6,5
@@ -838,13 +838,13 @@
 	vmovdqu8	GHASHDATA0, 0*VL(DST)
 	vmovdqu8	GHASHDATA1, 1*VL(DST)
 	vmovdqu8	GHASHDATA2, 2*VL(DST)
 	vmovdqu8	GHASHDATA3, 3*VL(DST)
 
-	add		$4*VL, SRC
-	add		$4*VL, DST
-	sub		$4*VL, DATALEN
+	sub		$-4*VL, SRC  // shorter than 'add 4*VL' when VL=32
+	sub		$-4*VL, DST
+	add		$-4*VL, DATALEN
 	jge		.Lcrypt_loop_4x\@
 
 .if \enc
 .Lghash_last_ciphertext_4x\@:
 	// Update GHASH with the last set of ciphertext blocks.
@@ -854,11 +854,11 @@
 .endif
 
 .Lcrypt_loop_4x_done\@:
 
 	// Undo the extra subtraction by 4*VL and check whether data remains.
-	add		$4*VL, DATALEN
+	sub		$-4*VL, DATALEN  // shorter than 'add 4*VL' when VL=32
 	jz		.Ldone\@
 
 	// The data length isn't a multiple of 4*VL.  Process the remaining data
 	// of length 1 <= DATALEN < 4*VL, up to one vector (VL bytes) at a time.
 	// Going one vector at a time may seem inefficient compared to having
-- 
2.47.1

