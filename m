Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CB6296BBC;
	Thu,  2 Oct 2025 02:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759372447; cv=none; b=VsIO2eYD4VwxJCCAlXuuewWZ1KcGM9HdNpvpDmL8xaF69Yt0JgXt5nC4JLMIyiN6VKw19aw4tMG0eP0yryZE3PTh20RSvHlrZDjArksfDZAMlwnmiJTmwCVMuNoXmztrhME6mXUrMJQLUyHbYc6btLSv9zfHZ6BQ9XbqEbcLK1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759372447; c=relaxed/simple;
	bh=bC6Mhb4hEJMITzOZFEW3KyaCiV7FCkDleYI4bJAccCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8ibxGZoz4lW8YkXmo2K28Qr4McxmKv4647xn1+pjSaroGsRuZWEPMT2vef4tbMZkxeTNhAtknpn+gmaNQ43eVNVVChlaFBHhnrJqqf23Za8uVGY+61lIRLznLtTY4wrH279Bxuympk/miG8NiEchRyTZxolG32o9AmRYNelcA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u9bGz4yy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u9bGz4yy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936FBC4CEFD;
	Thu,  2 Oct 2025 02:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759372446;
	bh=bC6Mhb4hEJMITzOZFEW3KyaCiV7FCkDleYI4bJAccCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u9bGz4yydzHCcZDnRneGmDuMhU2c2JYK5MHcc1gLaoWm42RDP70L4GuPoowbsqRBv
	 ss2tI4xOmy60xz5lTMvZfexhW5voLEiEr2Zj8DoCVpJPfal5hq2hbMs7qOKsmxRvq+
	 Oknu9Xc7Pta1hCg6f/O3mRGzuGsQi4IsOjpJtEr+fh+QyMbY7z0O5zSi32FADhikWD
	 DgNy9V6eu23cW9KFTF4AP6qKx2uB5oNaePmaICHQSKPfRDLCmgiEK3X9vBJcrQvysm
	 slzFOHSZcP0+ndgADDcWfPbsjPFFDSodH/ZP7n53fldHGe3hHQ0GO456WO8JwSuxRl
	 OWr4/LKKx41CQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5/8] crypto: x86/aes-gcm - reorder AVX512 precompute and aad_update functions
Date: Wed,  1 Oct 2025 19:31:14 -0700
Message-ID: <20251002023117.37504-6-ebiggers@kernel.org>
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

Now that the _aes_gcm_precompute macro is instantiated only once,
replace it directly with a function definition.

Also, move aes_gcm_aad_update_vaes_avx512() to a different location in
the file so that it's consistent with aes-gcm-vaes-avx2.S and also the
BoringSSL port of this code.

No functional changes.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/x86/crypto/aes-gcm-vaes-avx512.S | 187 +++++++++++++-------------
 1 file changed, 92 insertions(+), 95 deletions(-)

diff --git a/arch/x86/crypto/aes-gcm-vaes-avx512.S b/arch/x86/crypto/aes-gcm-vaes-avx512.S
index 3edf829c2ce07..81a8a027cff8e 100644
--- a/arch/x86/crypto/aes-gcm-vaes-avx512.S
+++ b/arch/x86/crypto/aes-gcm-vaes-avx512.S
@@ -266,11 +266,11 @@
 // subkey and initializes |key->ghash_key_powers| with powers of it.
 //
 // The number of key powers initialized is NUM_H_POWERS, and they are stored in
 // the order H^NUM_H_POWERS to H^1.  The zeroized padding blocks after the key
 // powers themselves are also initialized.
-.macro	_aes_gcm_precompute
+SYM_FUNC_START(aes_gcm_precompute_vaes_avx512)
 
 	// Function arguments
 	.set	KEY,		%rdi
 
 	// Additional local variables.
@@ -359,20 +359,20 @@
 
 	// Compute and store the remaining key powers.
 	// Repeatedly multiply [H^(i+3), H^(i+2), H^(i+1), H^i] by
 	// [H^4, H^4, H^4, H^4] to get [H^(i+7), H^(i+6), H^(i+5), H^(i+4)].
 	mov		$3, %eax
-.Lprecompute_next\@:
+.Lprecompute_next:
 	sub		$64, POWERS_PTR
 	_ghash_mul	H_INC, H_CUR, H_CUR, GFPOLY, %zmm0, %zmm1, %zmm2
 	vmovdqu8	H_CUR, (POWERS_PTR)
 	dec		%eax
-	jnz		.Lprecompute_next\@
+	jnz		.Lprecompute_next
 
 	vzeroupper	// This is needed after using ymm or zmm registers.
 	RET
-.endm
+SYM_FUNC_END(aes_gcm_precompute_vaes_avx512)
 
 // XOR together the 128-bit lanes of \src (whose low lane is \src_xmm) and store
 // the result in \dst_xmm.  This implicitly zeroizes the other lanes of dst.
 .macro	_horizontal_xor	src, src_xmm, dst_xmm, t0_xmm, t1_xmm, t2_xmm
 	vextracti32x4	$1, \src, \t0_xmm
@@ -461,10 +461,98 @@
 	_horizontal_xor	GHASH_ACC, GHASH_ACC_XMM, GHASH_ACC_XMM, \
 			GHASHDATA0_XMM, GHASHDATA1_XMM, GHASHDATA2_XMM
 .endif
 .endm
 
+// void aes_gcm_aad_update_vaes_avx512(const struct aes_gcm_key_vaes_avx512 *key,
+//				       u8 ghash_acc[16],
+//				       const u8 *aad, int aadlen);
+//
+// This function processes the AAD (Additional Authenticated Data) in GCM.
+// Using the key |key|, it updates the GHASH accumulator |ghash_acc| with the
+// data given by |aad| and |aadlen|.  |key->ghash_key_powers| must have been
+// initialized.  On the first call, |ghash_acc| must be all zeroes.  |aadlen|
+// must be a multiple of 16, except on the last call where it can be any length.
+// The caller must do any buffering needed to ensure this.
+//
+// AES-GCM is almost always used with small amounts of AAD, less than 32 bytes.
+// Therefore, for AAD processing we currently only provide this implementation
+// which uses 256-bit vectors (ymm registers) and only has a 1x-wide loop.  This
+// keeps the code size down, and it enables some micro-optimizations, e.g. using
+// VEX-coded instructions instead of EVEX-coded to save some instruction bytes.
+// To optimize for large amounts of AAD, we could implement a 4x-wide loop and
+// provide a version using 512-bit vectors, but that doesn't seem to be useful.
+SYM_FUNC_START(aes_gcm_aad_update_vaes_avx512)
+
+	// Function arguments
+	.set	KEY,		%rdi
+	.set	GHASH_ACC_PTR,	%rsi
+	.set	AAD,		%rdx
+	.set	AADLEN,		%ecx
+	.set	AADLEN64,	%rcx	// Zero-extend AADLEN before using!
+
+	// Additional local variables.
+	// %rax, %ymm0-%ymm3, and %k1 are used as temporary registers.
+	.set	BSWAP_MASK,	%ymm4
+	.set	GFPOLY,		%ymm5
+	.set	GHASH_ACC,	%ymm6
+	.set	GHASH_ACC_XMM,	%xmm6
+	.set	H_POW1,		%ymm7
+
+	// Load some constants.
+	vbroadcasti128	.Lbswap_mask(%rip), BSWAP_MASK
+	vbroadcasti128	.Lgfpoly(%rip), GFPOLY
+
+	// Load the GHASH accumulator.
+	vmovdqu		(GHASH_ACC_PTR), GHASH_ACC_XMM
+
+	// Update GHASH with 32 bytes of AAD at a time.
+	//
+	// Pre-subtracting 32 from AADLEN saves an instruction from the loop and
+	// also ensures that at least one write always occurs to AADLEN,
+	// zero-extending it and allowing AADLEN64 to be used later.
+	sub		$32, AADLEN
+	jl		.Laad_loop_1x_done
+	vmovdqu8	OFFSETOFEND_H_POWERS-32(KEY), H_POW1	// [H^2, H^1]
+.Laad_loop_1x:
+	vmovdqu		(AAD), %ymm0
+	vpshufb		BSWAP_MASK, %ymm0, %ymm0
+	vpxor		%ymm0, GHASH_ACC, GHASH_ACC
+	_ghash_mul	H_POW1, GHASH_ACC, GHASH_ACC, GFPOLY, \
+			%ymm0, %ymm1, %ymm2
+	vextracti128	$1, GHASH_ACC, %xmm0
+	vpxor		%xmm0, GHASH_ACC_XMM, GHASH_ACC_XMM
+	add		$32, AAD
+	sub		$32, AADLEN
+	jge		.Laad_loop_1x
+.Laad_loop_1x_done:
+	add		$32, AADLEN
+	jz		.Laad_done
+
+	// Update GHASH with the remaining 1 <= AADLEN < 32 bytes of AAD.
+	mov		$-1, %eax
+	bzhi		AADLEN, %eax, %eax
+	kmovd		%eax, %k1
+	vmovdqu8	(AAD), %ymm0{%k1}{z}
+	neg		AADLEN64
+	and		$~15, AADLEN64  // -round_up(AADLEN, 16)
+	vmovdqu8	OFFSETOFEND_H_POWERS(KEY,AADLEN64), H_POW1
+	vpshufb		BSWAP_MASK, %ymm0, %ymm0
+	vpxor		%ymm0, GHASH_ACC, GHASH_ACC
+	_ghash_mul	H_POW1, GHASH_ACC, GHASH_ACC, GFPOLY, \
+			%ymm0, %ymm1, %ymm2
+	vextracti128	$1, GHASH_ACC, %xmm0
+	vpxor		%xmm0, GHASH_ACC_XMM, GHASH_ACC_XMM
+
+.Laad_done:
+	// Store the updated GHASH accumulator back to memory.
+	vmovdqu		GHASH_ACC_XMM, (GHASH_ACC_PTR)
+
+	vzeroupper	// This is needed after using ymm or zmm registers.
+	RET
+SYM_FUNC_END(aes_gcm_aad_update_vaes_avx512)
+
 // Do one non-last round of AES encryption on the blocks in %zmm[0-3] using the
 // round key that has been broadcast to all 128-bit lanes of \round_key.
 .macro	_vaesenc_4x	round_key
 	vaesenc		\round_key, %zmm0, %zmm0
 	vaesenc		\round_key, %zmm1, %zmm1
@@ -999,108 +1087,17 @@
 .endif
 	// No need for vzeroupper here, since only used xmm registers were used.
 	RET
 .endm
 
-SYM_FUNC_START(aes_gcm_precompute_vaes_avx512)
-	_aes_gcm_precompute
-SYM_FUNC_END(aes_gcm_precompute_vaes_avx512)
 SYM_FUNC_START(aes_gcm_enc_update_vaes_avx512)
 	_aes_gcm_update	1
 SYM_FUNC_END(aes_gcm_enc_update_vaes_avx512)
 SYM_FUNC_START(aes_gcm_dec_update_vaes_avx512)
 	_aes_gcm_update	0
 SYM_FUNC_END(aes_gcm_dec_update_vaes_avx512)
 
-// void aes_gcm_aad_update_vaes_avx512(const struct aes_gcm_key_vaes_avx512 *key,
-//				       u8 ghash_acc[16],
-//				       const u8 *aad, int aadlen);
-//
-// This function processes the AAD (Additional Authenticated Data) in GCM.
-// Using the key |key|, it updates the GHASH accumulator |ghash_acc| with the
-// data given by |aad| and |aadlen|.  |key->ghash_key_powers| must have been
-// initialized.  On the first call, |ghash_acc| must be all zeroes.  |aadlen|
-// must be a multiple of 16, except on the last call where it can be any length.
-// The caller must do any buffering needed to ensure this.
-//
-// AES-GCM is almost always used with small amounts of AAD, less than 32 bytes.
-// Therefore, for AAD processing we currently only provide this implementation
-// which uses 256-bit vectors (ymm registers) and only has a 1x-wide loop.  This
-// keeps the code size down, and it enables some micro-optimizations, e.g. using
-// VEX-coded instructions instead of EVEX-coded to save some instruction bytes.
-// To optimize for large amounts of AAD, we could implement a 4x-wide loop and
-// provide a version using 512-bit vectors, but that doesn't seem to be useful.
-SYM_FUNC_START(aes_gcm_aad_update_vaes_avx512)
-
-	// Function arguments
-	.set	KEY,		%rdi
-	.set	GHASH_ACC_PTR,	%rsi
-	.set	AAD,		%rdx
-	.set	AADLEN,		%ecx
-	.set	AADLEN64,	%rcx	// Zero-extend AADLEN before using!
-
-	// Additional local variables.
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
-
-	// Load the GHASH accumulator.
-	vmovdqu		(GHASH_ACC_PTR), GHASH_ACC_XMM
-
-	// Update GHASH with 32 bytes of AAD at a time.
-	//
-	// Pre-subtracting 32 from AADLEN saves an instruction from the loop and
-	// also ensures that at least one write always occurs to AADLEN,
-	// zero-extending it and allowing AADLEN64 to be used later.
-	sub		$32, AADLEN
-	jl		.Laad_loop_1x_done
-	vmovdqu8	OFFSETOFEND_H_POWERS-32(KEY), H_POW1	// [H^2, H^1]
-.Laad_loop_1x:
-	vmovdqu		(AAD), %ymm0
-	vpshufb		BSWAP_MASK, %ymm0, %ymm0
-	vpxor		%ymm0, GHASH_ACC, GHASH_ACC
-	_ghash_mul	H_POW1, GHASH_ACC, GHASH_ACC, GFPOLY, \
-			%ymm0, %ymm1, %ymm2
-	vextracti128	$1, GHASH_ACC, %xmm0
-	vpxor		%xmm0, GHASH_ACC_XMM, GHASH_ACC_XMM
-	add		$32, AAD
-	sub		$32, AADLEN
-	jge		.Laad_loop_1x
-.Laad_loop_1x_done:
-	add		$32, AADLEN
-	jz		.Laad_done
-
-	// Update GHASH with the remaining 1 <= AADLEN < 32 bytes of AAD.
-	mov		$-1, %eax
-	bzhi		AADLEN, %eax, %eax
-	kmovd		%eax, %k1
-	vmovdqu8	(AAD), %ymm0{%k1}{z}
-	neg		AADLEN64
-	and		$~15, AADLEN64  // -round_up(AADLEN, 16)
-	vmovdqu8	OFFSETOFEND_H_POWERS(KEY,AADLEN64), H_POW1
-	vpshufb		BSWAP_MASK, %ymm0, %ymm0
-	vpxor		%ymm0, GHASH_ACC, GHASH_ACC
-	_ghash_mul	H_POW1, GHASH_ACC, GHASH_ACC, GFPOLY, \
-			%ymm0, %ymm1, %ymm2
-	vextracti128	$1, GHASH_ACC, %xmm0
-	vpxor		%xmm0, GHASH_ACC_XMM, GHASH_ACC_XMM
-
-.Laad_done:
-	// Store the updated GHASH accumulator back to memory.
-	vmovdqu		GHASH_ACC_XMM, (GHASH_ACC_PTR)
-
-	vzeroupper	// This is needed after using ymm or zmm registers.
-	RET
-SYM_FUNC_END(aes_gcm_aad_update_vaes_avx512)
-
 SYM_FUNC_START(aes_gcm_enc_final_vaes_avx512)
 	_aes_gcm_final	1
 SYM_FUNC_END(aes_gcm_enc_final_vaes_avx512)
 SYM_FUNC_START(aes_gcm_dec_final_vaes_avx512)
 	_aes_gcm_final	0
-- 
2.51.0

