Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74FB81D6DC8
	for <linux-crypto@vger.kernel.org>; Thu, 12 Dec 2024 21:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734038955; cv=none; b=n4Rrk4jVE+8zUddYYZphKW9i3bzCohFecpPdONHJwXnK8B2JEzk7/RQoWde923L0mXf1E8YX+OVFIPlcepZEZbJFFHSEvqjcj5MsTWcJQniHpbCRf3pJt39OxnJq6JI0DirAKvOdjqHzQwT9T0iKSiF9VAP4ctwFkbUzuSO+2zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734038955; c=relaxed/simple;
	bh=Deqd9Udw9e4M29yPDW2Z4eSvU6e0HfZyfV/z7xPajj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CHDZ+K6jHohLHB22cD2F+Ottm1+YOrkaHS+cwfk/KMcKshoIPHmPvLNS9giXHVSy5XasHs4MGErjaKgblO01yE3HQd/PHXWbNiwhyR/C88d6J718Yo2pnWg5RcqAmJh+wSCuUkHZqXBwn1kDY7Wp08rYGSryeMIY0pjtT/GXsK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=atdpu3/Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="atdpu3/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFCF1C4CED3;
	Thu, 12 Dec 2024 21:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734038955;
	bh=Deqd9Udw9e4M29yPDW2Z4eSvU6e0HfZyfV/z7xPajj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=atdpu3/YK52uFuqVJkG3M9CuCClaDBovS/JDBt7PnezTkDELgWIpmliR5301c0pa2
	 OdsR9t4dHOim6aJEpjytAiqXdow9nKribi66VJk5YJoXYYqw/Zr94wjPCMuqnJPd+F
	 l5ieQf1Qbp1YlwFKgFEomm4UXj0X/LT+JuFrGaCSLKyo+iMMNMmC0lnExxWPfFHl0O
	 RR2fPjhZkFlE0d0spqiNv00BrGQTNXksUNwVez/2rUMjvxdBNr0WXb/nD5MloGS0V6
	 gM8ONZ7UFjWg+tG9U42z7ufg49X/S+cemX829kelo8nsnyA0+OJEaAJbj5d0nbdWZ/
	 ykizcfymVOPhQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org
Subject: [PATCH v2 1/8] crypto: x86/aes-gcm - code size optimization
Date: Thu, 12 Dec 2024 13:28:38 -0800
Message-ID: <20241212212845.40333-2-ebiggers@kernel.org>
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
byte, saving 3 bytes per instruction.  Also replace a vpand and vpxor
with a vpternlogd.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aes-gcm-avx10-x86_64.S | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/crypto/aes-gcm-avx10-x86_64.S b/arch/x86/crypto/aes-gcm-avx10-x86_64.S
index 97e0ee515fc5..8989bf9b8384 100644
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

