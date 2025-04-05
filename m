Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA28CEAE7
	for <linux-crypto@vger.kernel.org>; Sat,  5 Apr 2025 04:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743826267; cv=none; b=IRMzoBs8B+wiulj67Vo2fMMpC6qzNbN1l+yxgTlYJiJRFHoYh+VxT+QzX0cy7QJ3RVJoR/zFulZXR8tVA9nu0tSfcZo8Gsr25lBy8cLOLFSo44+ZLWdnB//ElbwkzF/iZXuJslfKUOtdt7NXdOTUblaFfoi+KQd15JMfj/X+6Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743826267; c=relaxed/simple;
	bh=6byRzH5S05FEsk94kw8poguVYjqX/eNesb9u2miSkdE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NXlc1iNwKJwxQDUADlbY+ZM1EFrr3wc0kvq1G8xV7VLWbOncInLjqw/VL5eFwgz+GJPWxd+ntcL11yib4CakCslLXn8QBPnasjImy2FAhOZy9OdBppJmYb6R2Nb5J5P1BN4ht3WFlHIPTOViQf1bMSF0hpw+rQXK3d1ygy2CLlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lwv6/qAO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lwv6/qAO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C51DC4CEE5;
	Sat,  5 Apr 2025 04:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743826267;
	bh=6byRzH5S05FEsk94kw8poguVYjqX/eNesb9u2miSkdE=;
	h=From:To:Cc:Subject:Date:From;
	b=lwv6/qAOl4Lq6zgwr1o04EEzaJgf33zQhS3IaCM+k6IlRse4qJhUZkX163pDXjz3d
	 BSqwikp7lGyhOh7VVyU3uIQ9xNAQR7N90tzSxU42x1rM2mDVXmyKhldee2PaEAQ1Rr
	 MiHkBPgQIPKG2mY3KrhRQdCkQZgROZcwRQ2nN+Lrnt8T7v+MzRqYkIfRufX97VRABl
	 M4MTmc/ZJ8IAjhRqPeVjzoEaXPNdVUbi/lYH/9Cbq7AsgQLIZqhu/Na6Tlye+8nNEp
	 LpkV9cs1gWTuOhX6fXr+Ygr6UKCOG6/HSJVSwA+N3ymf7ONc+gEk+j2QIvvmfICmqS
	 O5AG4LWX9661Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org
Subject: [PATCH] crypto: x86/aes-xts - optimize _compute_first_set_of_tweaks for AVX-512
Date: Fri,  4 Apr 2025 21:09:30 -0700
Message-ID: <20250405040930.297079-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Optimize the AVX-512 version of _compute_first_set_of_tweaks by using
vectorized shifts to compute the first vector of tweak blocks, and by
using byte-aligned shifts when multiplying by x^8.

AES-XTS performance on AMD Ryzen 9 9950X (Zen 5) improves by about 2%
for 4096-byte messages or 6% for 512-byte messages.  AES-XTS performance
on Intel Sapphire Rapids improves by about 1% for 4096-byte messages or
3% for 512-byte messages.  Code size decreases by 75 bytes which
outweighs the increase in rodata size of 16 bytes.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---

This applies to current mainline (a52a3c18cdf369a7) plus the patch
"crypto: x86/aes - drop the avx10_256 AES-XTS and AES-CTR code"
(https://lore.kernel.org/linux-crypto/20250402002420.89233-2-ebiggers@kernel.org/)

 arch/x86/crypto/aes-xts-avx-x86_64.S | 90 +++++++++++++++++++---------
 1 file changed, 62 insertions(+), 28 deletions(-)

diff --git a/arch/x86/crypto/aes-xts-avx-x86_64.S b/arch/x86/crypto/aes-xts-avx-x86_64.S
index bbeaccbd1c51f..db79cdf815881 100644
--- a/arch/x86/crypto/aes-xts-avx-x86_64.S
+++ b/arch/x86/crypto/aes-xts-avx-x86_64.S
@@ -98,10 +98,21 @@
 	//
 	// The high 64 bits of this value is just the internal carry bit that
 	// exists when there's a carry out of the low 64 bits of the tweak.
 	.quad	0x87, 1
 
+	// These are the shift amounts that are needed when multiplying by [x^0,
+	// x^1, x^2, x^3] to compute the first vector of tweaks when VL=64.
+	//
+	// The right shifts by 64 are expected to zeroize the destination.
+	// 'vpsrlvq' is indeed defined to do that; i.e. it doesn't truncate the
+	// amount to 64 & 63 = 0 like the 'shr' scalar shift instruction would.
+.Lrshift_amounts:
+	.byte	64, 64, 63, 63, 62, 62, 61, 61
+.Llshift_amounts:
+	.byte	0, 0, 1, 1, 2, 2, 3, 3
+
 	// This table contains constants for vpshufb and vpblendvb, used to
 	// handle variable byte shifts and blending during ciphertext stealing
 	// on CPUs that don't support AVX512-style masking.
 .Lcts_permute_table:
 	.byte	0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
@@ -292,56 +303,79 @@
 .endm
 
 // Given the first XTS tweak at (TWEAK), compute the first set of tweaks and
 // store them in the vector registers TWEAK0-TWEAK3.  Clobbers V0-V5.
 .macro	_compute_first_set_of_tweaks
-	vmovdqu		(TWEAK), TWEAK0_XMM
-	_vbroadcast128	.Lgf_poly(%rip), GF_POLY
 .if VL == 16
-	// With VL=16, multiplying by x serially is fastest.
+	vmovdqu		(TWEAK), TWEAK0_XMM
+	vmovdqu		.Lgf_poly(%rip), GF_POLY
 	_next_tweak	TWEAK0, %xmm0, TWEAK1
 	_next_tweak	TWEAK1, %xmm0, TWEAK2
 	_next_tweak	TWEAK2, %xmm0, TWEAK3
-.else
-.if VL == 32
-	// Compute the second block of TWEAK0.
+.elseif VL == 32
+	vmovdqu		(TWEAK), TWEAK0_XMM
+	vbroadcasti128	.Lgf_poly(%rip), GF_POLY
+
+	// Compute the first vector of tweaks.
 	_next_tweak	TWEAK0_XMM, %xmm0, %xmm1
 	vinserti128	$1, %xmm1, TWEAK0, TWEAK0
-.elseif VL == 64
-	// Compute the remaining blocks of TWEAK0.
-	_next_tweak	TWEAK0_XMM, %xmm0, %xmm1
-	_next_tweak	%xmm1, %xmm0, %xmm2
-	_next_tweak	%xmm2, %xmm0, %xmm3
-	vinserti32x4	$1, %xmm1, TWEAK0, TWEAK0
-	vinserti32x4	$2, %xmm2, TWEAK0, TWEAK0
-	vinserti32x4	$3, %xmm3, TWEAK0, TWEAK0
-.endif
-	// Compute TWEAK[1-3] from TWEAK0.
-	vpsrlq		$64 - 1*VL/16, TWEAK0, V0
-	vpsrlq		$64 - 2*VL/16, TWEAK0, V2
-	vpsrlq		$64 - 3*VL/16, TWEAK0, V4
+
+	// Compute the next three vectors of tweaks:
+	//	TWEAK1 = TWEAK0 * [x^2, x^2]
+	//	TWEAK2 = TWEAK0 * [x^4, x^4]
+	//	TWEAK3 = TWEAK0 * [x^6, x^6]
+	vpsrlq		$64 - 2, TWEAK0, V0
+	vpsrlq		$64 - 4, TWEAK0, V2
+	vpsrlq		$64 - 6, TWEAK0, V4
 	vpclmulqdq	$0x01, GF_POLY, V0, V1
 	vpclmulqdq	$0x01, GF_POLY, V2, V3
 	vpclmulqdq	$0x01, GF_POLY, V4, V5
 	vpslldq		$8, V0, V0
 	vpslldq		$8, V2, V2
 	vpslldq		$8, V4, V4
-	vpsllq		$1*VL/16, TWEAK0, TWEAK1
-	vpsllq		$2*VL/16, TWEAK0, TWEAK2
-	vpsllq		$3*VL/16, TWEAK0, TWEAK3
-.if USE_AVX512
-	vpternlogd	$0x96, V0, V1, TWEAK1
-	vpternlogd	$0x96, V2, V3, TWEAK2
-	vpternlogd	$0x96, V4, V5, TWEAK3
-.else
+	vpsllq		$2, TWEAK0, TWEAK1
+	vpsllq		$4, TWEAK0, TWEAK2
+	vpsllq		$6, TWEAK0, TWEAK3
 	vpxor		V0, TWEAK1, TWEAK1
 	vpxor		V2, TWEAK2, TWEAK2
 	vpxor		V4, TWEAK3, TWEAK3
 	vpxor		V1, TWEAK1, TWEAK1
 	vpxor		V3, TWEAK2, TWEAK2
 	vpxor		V5, TWEAK3, TWEAK3
-.endif
+.else
+	vbroadcasti32x4	(TWEAK), TWEAK0
+	vbroadcasti32x4	.Lgf_poly(%rip), GF_POLY
+
+	// Compute the first vector of tweaks:
+	//	TWEAK0 = broadcast128(TWEAK) * [x^0, x^1, x^2, x^3]
+	vpmovzxbq	.Lrshift_amounts(%rip), V4
+	vpsrlvq		V4, TWEAK0, V0
+	vpclmulqdq	$0x01, GF_POLY, V0, V1
+	vpmovzxbq	.Llshift_amounts(%rip), V4
+	vpslldq		$8, V0, V0
+	vpsllvq		V4, TWEAK0, TWEAK0
+	vpternlogd	$0x96, V0, V1, TWEAK0
+
+	// Compute the next three vectors of tweaks:
+	//	TWEAK1 = TWEAK0 * [x^4, x^4, x^4, x^4]
+	//	TWEAK2 = TWEAK0 * [x^8, x^8, x^8, x^8]
+	//	TWEAK3 = TWEAK0 * [x^12, x^12, x^12, x^12]
+	// x^8 only needs byte-aligned shifts, so optimize accordingly.
+	vpsrlq		$64 - 4, TWEAK0, V0
+	vpsrldq		$(64 - 8) / 8, TWEAK0, V2
+	vpsrlq		$64 - 12, TWEAK0, V4
+	vpclmulqdq	$0x01, GF_POLY, V0, V1
+	vpclmulqdq	$0x01, GF_POLY, V2, V3
+	vpclmulqdq	$0x01, GF_POLY, V4, V5
+	vpslldq		$8, V0, V0
+	vpslldq		$8, V4, V4
+	vpsllq		$4, TWEAK0, TWEAK1
+	vpslldq		$8 / 8, TWEAK0, TWEAK2
+	vpsllq		$12, TWEAK0, TWEAK3
+	vpternlogd	$0x96, V0, V1, TWEAK1
+	vpxord		V3, TWEAK2, TWEAK2
+	vpternlogd	$0x96, V4, V5, TWEAK3
 .endif
 .endm
 
 // Do one step in computing the next set of tweaks using the method of just
 // multiplying by x repeatedly (the same method _next_tweak uses).
-- 
2.49.0

