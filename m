Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA66122FAF8
	for <linux-crypto@vger.kernel.org>; Tue, 10 Dec 2024 23:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733875150; cv=none; b=IFnrQg8ssjLvIQQnrva5RWF0CLqWOYVPsSyn1gHen69XqixS38Wc4iS9w5w+gpAlnKIiI3Th5lrzD4CxzJGJJd8BY7VJEdyYKJUU+nnaNeBpAkny8YO67tO07ME3nbfjYY0INpilGJAmC7KmDbT7zzyN3rQKcQ4phHWK1+tNhbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733875150; c=relaxed/simple;
	bh=1qTaI+eJVgg9YFidroahefGrOIsW8D3PuvSLnBlsGp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OmZiOHUEx5nDWSW9Of/UJ3GQAnH7FBUbQnaF2ojO9Q/Ws4Ptgggy3OykI8odVhYAGZ1haYMo/0ENt1k0D0tzb43AIK1dPJN0nR8U7BsKQaWY8OPkF7tzVfiJXn6W9VuoJKHUmRWO/4K3QqCcoXrcqKm0DWYXj8fx6QoSfcYPjls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sS8m/nQW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sS8m/nQW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75CDEC4CEE3;
	Tue, 10 Dec 2024 23:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733875150;
	bh=1qTaI+eJVgg9YFidroahefGrOIsW8D3PuvSLnBlsGp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sS8m/nQWJh5eqn3QvKVFEjBr5Np2PP+5t5hLCpntQTC+5eY3NyIMsksw8s4CgmTEs
	 woFDjy4Vi3qdQ+VmS0VMVESWO8IioTJT5Ac21naq7oiqk9dthPb8N5cNV6K64niJ8q
	 B0Z7gEhlBMzVElY5JVeCjv933VbbCcfFVi09awggR6XGoY5n9Z+4BuIr2KVw+dxTc2
	 0MPkBWrELESxACcECpU3foply9eF2qQ5NahHtL+73uZh8TfF9gXDqqY4FnOR1ZidTD
	 fgYWcKZXu/SE0UvrhNNeTgqELtDGT4cSQ3yz7iAKsa9lSakJ3ZKeWC56E5+N/3xHfB
	 9CweUEP9F3+hg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org
Subject: [PATCH 7/7] crypto: x86/aes-xts - more code size optimizations
Date: Tue, 10 Dec 2024 15:58:34 -0800
Message-ID: <20241210235834.40862-8-ebiggers@kernel.org>
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
byte, saving 3 bytes per instruction.  Also prefer VEX-coded
instructions to EVEX where this is easy to do.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aes-xts-avx-x86_64.S | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/arch/x86/crypto/aes-xts-avx-x86_64.S b/arch/x86/crypto/aes-xts-avx-x86_64.S
index bb3d0dfeca575..a49637f0a729d 100644
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
@@ -559,22 +561,22 @@
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
@@ -616,13 +618,13 @@
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

