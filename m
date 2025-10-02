Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D712BE058;
	Thu,  2 Oct 2025 02:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759372448; cv=none; b=WmcwOyn2ZXP5MyMpnA1/UvYCz8bKgajiSoRPo+6UlPHF4YqcasxTFMaFjQo+xVY8nnkoK+1njhmcVIbx6CL1oTuquLjHaiCYtYSD1SWo7LByK9uUgmvmP9WBKnV1lTVqXPsMSCvFc9E+y7OyaBkgkcM1HrfLXchSF+wGlBZvPiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759372448; c=relaxed/simple;
	bh=7fZrYKmSuv6IY2eFxUYmZ5k9sEMnqtAn/61vVHPtZ1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QiaviQ8cQwVy3O0VzGZmSgW4iE7vnZ/QCe+8AJ8EH4MVkYVTgk8YN8v+lUDmzlfZGR3tBRp1ze8r9Do0LsSF/cuM6r9tWGJ5EqBK/x/lAV7sKMm2ENhmz6Iyd+qH8B8Zzv+qxUMMk3gaGprmRDgi/QeYscL8Mgf9vrPN9jMvv8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X5Pmg2OZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X5Pmg2OZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E08C4CEFA;
	Thu,  2 Oct 2025 02:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759372447;
	bh=7fZrYKmSuv6IY2eFxUYmZ5k9sEMnqtAn/61vVHPtZ1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X5Pmg2OZ0q8AfjeSoxHS4IpnTuONnoTWDi3XxLp+pUYTS3e0ysa4XPs+WkesFJbxf
	 SQ2EN2X7zyGm9wfv9IxW5xymCo00cHen+v1C9Mj5kCa5e42yi6i9XevX6iDoAtlTGb
	 5I/v5FeMbvLcVSfntdkx3gfCAhPVYvxXSMdNwdh+w4l4MMxw4P1I596OuAtwTAvxjL
	 44+FWdB4KLME1HKQ0x7kQUeG0oUEaGB0x7JdMX6chAPJLOU68ZdOzxlTIcf/i7a43j
	 4pp51zrq/1vkNf8cZRTZG5toL1yICv2e/nLow48MQ7ENfeXOFI290Q8WqnhIkFrgz3
	 P6k5BBFy70kaw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 8/8] crypto: x86/aes-gcm - optimize long AAD processing with AVX512
Date: Wed,  1 Oct 2025 19:31:17 -0700
Message-ID: <20251002023117.37504-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251002023117.37504-1-ebiggers@kernel.org>
References: <20251002023117.37504-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Improve the performance of aes_gcm_aad_update_vaes_avx512() on large AAD
(additional authenticated data) lengths by 4-8 times by making it use up
to 512-bit vectors and a 4-vector-wide loop.  Previously, it used only
256-bit vectors and a 1-vector-wide loop.

Originally, I assumed that the case of large AADLEN was unimportant.
When reviewing the users of BoringSSL's AES-GCM code, I found that some
callers use BoringSSL's AES-GCM API to just compute GMAC, using large
amounts of AAD with zero bytes en/decrypted.  Thus, I included a similar
optimization in the BoringSSL port of this code.  I believe it's wise to
include this optimization in the kernel port too for similar reasons,
and to align it more closely with the BoringSSL port.

Another reason this function originally used 256-bit vectors was so that
separate *_avx10_256 and *_avx10_512 versions of it wouldn't be needed.
However, that's no longer applicable.

To avoid a slight performance regression in the common case of AADLEN <=
16, also add a fast path for that case which uses 128-bit vectors.  In
fact, this case actually gets slightly faster too, since it saves a
couple instructions over the original 256-bit code.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/x86/crypto/aes-gcm-vaes-avx512.S | 146 +++++++++++++++++---------
 1 file changed, 99 insertions(+), 47 deletions(-)

diff --git a/arch/x86/crypto/aes-gcm-vaes-avx512.S b/arch/x86/crypto/aes-gcm-vaes-avx512.S
index 5c8301d275c66..06b71314d65cc 100644
--- a/arch/x86/crypto/aes-gcm-vaes-avx512.S
+++ b/arch/x86/crypto/aes-gcm-vaes-avx512.S
@@ -469,88 +469,142 @@ SYM_FUNC_END(aes_gcm_precompute_vaes_avx512)
 	_horizontal_xor	GHASH_ACC, GHASH_ACC_XMM, GHASH_ACC_XMM, \
 			GHASHDATA0_XMM, GHASHDATA1_XMM, GHASHDATA2_XMM
 .endif
 .endm
 
+// Update GHASH with four vectors of data blocks.  See _ghash_step_4x for full
+// explanation.
+.macro	_ghash_4x
+.irp i, 0,1,2,3,4,5,6,7,8,9
+	_ghash_step_4x	\i
+.endr
+.endm
+
 // void aes_gcm_aad_update_vaes_avx512(const struct aes_gcm_key_vaes_avx512 *key,
 //				       u8 ghash_acc[16],
 //				       const u8 *aad, int aadlen);
 //
 // This function processes the AAD (Additional Authenticated Data) in GCM.
 // Using the key |key|, it updates the GHASH accumulator |ghash_acc| with the
 // data given by |aad| and |aadlen|.  On the first call, |ghash_acc| must be all
 // zeroes.  |aadlen| must be a multiple of 16, except on the last call where it
 // can be any length.  The caller must do any buffering needed to ensure this.
 //
-// AES-GCM is almost always used with small amounts of AAD, less than 32 bytes.
-// Therefore, for AAD processing we currently only provide this implementation
-// which uses 256-bit vectors (ymm registers) and only has a 1x-wide loop.  This
-// keeps the code size down, and it enables some micro-optimizations, e.g. using
-// VEX-coded instructions instead of EVEX-coded to save some instruction bytes.
-// To optimize for large amounts of AAD, we could implement a 4x-wide loop and
-// provide a version using 512-bit vectors, but that doesn't seem to be useful.
+// This handles large amounts of AAD efficiently, while also keeping overhead
+// low for small amounts which is the common case.  TLS and IPsec use less than
+// one block of AAD, but (uncommonly) other use cases may use much more.
 SYM_FUNC_START(aes_gcm_aad_update_vaes_avx512)
 
 	// Function arguments
 	.set	KEY,		%rdi
 	.set	GHASH_ACC_PTR,	%rsi
 	.set	AAD,		%rdx
 	.set	AADLEN,		%ecx
 	.set	AADLEN64,	%rcx	// Zero-extend AADLEN before using!
 
 	// Additional local variables.
-	// %rax, %ymm0-%ymm3, and %k1 are used as temporary registers.
-	.set	BSWAP_MASK,	%ymm4
-	.set	GFPOLY,		%ymm5
-	.set	GHASH_ACC,	%ymm6
-	.set	GHASH_ACC_XMM,	%xmm6
-	.set	H_POW1,		%ymm7
-
-	// Load some constants.
-	vbroadcasti128	.Lbswap_mask(%rip), BSWAP_MASK
-	vbroadcasti128	.Lgfpoly(%rip), GFPOLY
+	// %rax and %k1 are used as temporary registers.
+	.set	GHASHDATA0,	%zmm0
+	.set	GHASHDATA0_XMM,	%xmm0
+	.set	GHASHDATA1,	%zmm1
+	.set	GHASHDATA1_XMM,	%xmm1
+	.set	GHASHDATA2,	%zmm2
+	.set	GHASHDATA2_XMM,	%xmm2
+	.set	GHASHDATA3,	%zmm3
+	.set	BSWAP_MASK,	%zmm4
+	.set	BSWAP_MASK_XMM,	%xmm4
+	.set	GHASH_ACC,	%zmm5
+	.set	GHASH_ACC_XMM,	%xmm5
+	.set	H_POW4,		%zmm6
+	.set	H_POW3,		%zmm7
+	.set	H_POW2,		%zmm8
+	.set	H_POW1,		%zmm9
+	.set	H_POW1_XMM,	%xmm9
+	.set	GFPOLY,		%zmm10
+	.set	GFPOLY_XMM,	%xmm10
+	.set	GHASHTMP0,	%zmm11
+	.set	GHASHTMP1,	%zmm12
+	.set	GHASHTMP2,	%zmm13
 
 	// Load the GHASH accumulator.
 	vmovdqu		(GHASH_ACC_PTR), GHASH_ACC_XMM
 
-	// Update GHASH with 32 bytes of AAD at a time.
-	//
-	// Pre-subtracting 32 from AADLEN saves an instruction from the loop and
-	// also ensures that at least one write always occurs to AADLEN,
-	// zero-extending it and allowing AADLEN64 to be used later.
-	sub		$32, AADLEN
+	// Check for the common case of AADLEN <= 16, as well as AADLEN == 0.
+	cmp		$16, AADLEN
+	jg		.Laad_more_than_16bytes
+	test		AADLEN, AADLEN
+	jz		.Laad_done
+
+	// Fast path: update GHASH with 1 <= AADLEN <= 16 bytes of AAD.
+	vmovdqu		.Lbswap_mask(%rip), BSWAP_MASK_XMM
+	vmovdqu		.Lgfpoly(%rip), GFPOLY_XMM
+	mov		$-1, %eax
+	bzhi		AADLEN, %eax, %eax
+	kmovd		%eax, %k1
+	vmovdqu8	(AAD), GHASHDATA0_XMM{%k1}{z}
+	vmovdqu		OFFSETOFEND_H_POWERS-16(KEY), H_POW1_XMM
+	vpshufb		BSWAP_MASK_XMM, GHASHDATA0_XMM, GHASHDATA0_XMM
+	vpxor		GHASHDATA0_XMM, GHASH_ACC_XMM, GHASH_ACC_XMM
+	_ghash_mul	H_POW1_XMM, GHASH_ACC_XMM, GHASH_ACC_XMM, GFPOLY_XMM, \
+			GHASHDATA0_XMM, GHASHDATA1_XMM, GHASHDATA2_XMM
+	jmp		.Laad_done
+
+.Laad_more_than_16bytes:
+	vbroadcasti32x4	.Lbswap_mask(%rip), BSWAP_MASK
+	vbroadcasti32x4	.Lgfpoly(%rip), GFPOLY
+
+	// If AADLEN >= 256, update GHASH with 256 bytes of AAD at a time.
+	sub		$256, AADLEN
+	jl		.Laad_loop_4x_done
+	vmovdqu8	OFFSETOFEND_H_POWERS-4*64(KEY), H_POW4
+	vmovdqu8	OFFSETOFEND_H_POWERS-3*64(KEY), H_POW3
+	vmovdqu8	OFFSETOFEND_H_POWERS-2*64(KEY), H_POW2
+	vmovdqu8	OFFSETOFEND_H_POWERS-1*64(KEY), H_POW1
+.Laad_loop_4x:
+	vmovdqu8	0*64(AAD), GHASHDATA0
+	vmovdqu8	1*64(AAD), GHASHDATA1
+	vmovdqu8	2*64(AAD), GHASHDATA2
+	vmovdqu8	3*64(AAD), GHASHDATA3
+	_ghash_4x
+	add		$256, AAD
+	sub		$256, AADLEN
+	jge		.Laad_loop_4x
+.Laad_loop_4x_done:
+
+	// If AADLEN >= 64, update GHASH with 64 bytes of AAD at a time.
+	add		$192, AADLEN
 	jl		.Laad_loop_1x_done
-	vmovdqu8	OFFSETOFEND_H_POWERS-32(KEY), H_POW1	// [H^2, H^1]
+	vmovdqu8	OFFSETOFEND_H_POWERS-1*64(KEY), H_POW1
 .Laad_loop_1x:
-	vmovdqu		(AAD), %ymm0
-	vpshufb		BSWAP_MASK, %ymm0, %ymm0
-	vpxor		%ymm0, GHASH_ACC, GHASH_ACC
+	vmovdqu8	(AAD), GHASHDATA0
+	vpshufb		BSWAP_MASK, GHASHDATA0, GHASHDATA0
+	vpxord		GHASHDATA0, GHASH_ACC, GHASH_ACC
 	_ghash_mul	H_POW1, GHASH_ACC, GHASH_ACC, GFPOLY, \
-			%ymm0, %ymm1, %ymm2
-	vextracti128	$1, GHASH_ACC, %xmm0
-	vpxor		%xmm0, GHASH_ACC_XMM, GHASH_ACC_XMM
-	add		$32, AAD
-	sub		$32, AADLEN
+			GHASHDATA0, GHASHDATA1, GHASHDATA2
+	_horizontal_xor GHASH_ACC, GHASH_ACC_XMM, GHASH_ACC_XMM, \
+			GHASHDATA0_XMM, GHASHDATA1_XMM, GHASHDATA2_XMM
+	add		$64, AAD
+	sub		$64, AADLEN
 	jge		.Laad_loop_1x
 .Laad_loop_1x_done:
-	add		$32, AADLEN
-	jz		.Laad_done
 
-	// Update GHASH with the remaining 1 <= AADLEN < 32 bytes of AAD.
-	mov		$-1, %eax
-	bzhi		AADLEN, %eax, %eax
-	kmovd		%eax, %k1
-	vmovdqu8	(AAD), %ymm0{%k1}{z}
+	// Update GHASH with the remaining 0 <= AADLEN < 64 bytes of AAD.
+	add		$64, AADLEN
+	jz		.Laad_done
+	mov		$-1, %rax
+	bzhi		AADLEN64, %rax, %rax
+	kmovq		%rax, %k1
+	vmovdqu8	(AAD), GHASHDATA0{%k1}{z}
 	neg		AADLEN64
 	and		$~15, AADLEN64  // -round_up(AADLEN, 16)
 	vmovdqu8	OFFSETOFEND_H_POWERS(KEY,AADLEN64), H_POW1
-	vpshufb		BSWAP_MASK, %ymm0, %ymm0
-	vpxor		%ymm0, GHASH_ACC, GHASH_ACC
+	vpshufb		BSWAP_MASK, GHASHDATA0, GHASHDATA0
+	vpxord		GHASHDATA0, GHASH_ACC, GHASH_ACC
 	_ghash_mul	H_POW1, GHASH_ACC, GHASH_ACC, GFPOLY, \
-			%ymm0, %ymm1, %ymm2
-	vextracti128	$1, GHASH_ACC, %xmm0
-	vpxor		%xmm0, GHASH_ACC_XMM, GHASH_ACC_XMM
+			GHASHDATA0, GHASHDATA1, GHASHDATA2
+	_horizontal_xor GHASH_ACC, GHASH_ACC_XMM, GHASH_ACC_XMM, \
+			GHASHDATA0_XMM, GHASHDATA1_XMM, GHASHDATA2_XMM
 
 .Laad_done:
 	// Store the updated GHASH accumulator back to memory.
 	vmovdqu		GHASH_ACC_XMM, (GHASH_ACC_PTR)
 
@@ -842,13 +896,11 @@ SYM_FUNC_END(aes_gcm_aad_update_vaes_avx512)
 	jge		.Lcrypt_loop_4x\@
 
 .if \enc
 .Lghash_last_ciphertext_4x\@:
 	// Update GHASH with the last set of ciphertext blocks.
-.irp i, 0,1,2,3,4,5,6,7,8,9
-	_ghash_step_4x	\i
-.endr
+	_ghash_4x
 .endif
 
 .Lcrypt_loop_4x_done\@:
 
 	// Undo the extra subtraction by 256 and check whether data remains.
-- 
2.51.0

