Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9234528852B;
	Thu,  2 Oct 2025 02:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759372446; cv=none; b=FI9KxDNX/sJDD6LRpyjCPBRXGL+UmbHkmq3Rd2bERyFELGKINXN5/GWqCdASx4yBuuRm2BCIpfGJ85uI3JJtcz3j72QUVt3BlhLzjCwqCspStwoBMBIl7NdL8PY0/0InRxtChCQ27PzTiDRPHYhRTJScyoQqA5t7wFoBmku9ItY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759372446; c=relaxed/simple;
	bh=9atZnW0GjvJQyEA66hB6/CC6ThE1KiFzsG5104bcf+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cnikmCGQIPLuSFeJvxirGGq6CEJ/1m+iFSHZpr9lTDnBJQT2haENAJNSb/pEPHwQoGRL5Wrk7bi2rc5RdZFljzWSHa5OvtVFhiA663jA/+qJCrE4fF8EqVPJwgYY8xxEBGq0MbhXPslMmJrtu1nhNVofs8hY1v9KGJe/fnNzJ9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p3UwFv41; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p3UwFv41"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40FF3C4CEFA;
	Thu,  2 Oct 2025 02:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759372446;
	bh=9atZnW0GjvJQyEA66hB6/CC6ThE1KiFzsG5104bcf+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p3UwFv412l+Xj21StQ5AKrjEUcr3M05mTIU9TSvfCWAbbV5yFiIkgSQo0+XK67x0k
	 cYgnSi5M/cB+vsZOpkV5Gg3V+j1uSXNP2HmY/pVn7bSsB4XQO9eIR0cjLmNfsgPDSv
	 ETyyeY8kppxZ95qmFnb4Fg80OdOG4a7FJTXjBLmBwTsHfa0ZEb5X10dDenocoz7q4y
	 A7U1YgCXYPWLOfkGp/tBz8r5dT9YlJunFOcz7iNDJJsZhyJxSH6L6qULnZmliuwXR0
	 YL8MDP9PUJ029bsq16yDFCUNaTa7DpY3s7p1gIHkbwGnPb8IrHgXvqH/6+dM57BCF8
	 5frCl59X7lX9A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 4/8] crypto: x86/aes-gcm - clean up AVX512 code to assume 512-bit vectors
Date: Wed,  1 Oct 2025 19:31:13 -0700
Message-ID: <20251002023117.37504-5-ebiggers@kernel.org>
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

aes-gcm-vaes-avx512.S (originally aes-gcm-avx10-x86_64.S) was designed
to support multiple maximum vector lengths, while still utilizing AVX512
/ AVX10 features such as the increased number of vector registers.
However, the support for multiple maximum vector lengths turned out to
not be useful.  Support for maximum vector lengths other than 512 bits
was removed from the AVX10 specification, which leaves "avoiding
overly-eager downclocking" as the only remaining use case for limiting
AVX512 / AVX10 code to 256-bit vectors.  But this issue has gone away in
new CPUs, and the separate VAES+AVX2 code which I ended up having to
write anyway provides nearly as good 256-bit support.

Therefore, clean up this code to not be written in terms of a generic
vector length, but rather just assume 512-bit vectors.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/x86/crypto/aes-gcm-vaes-avx512.S | 353 +++++++++++---------------
 1 file changed, 153 insertions(+), 200 deletions(-)

diff --git a/arch/x86/crypto/aes-gcm-vaes-avx512.S b/arch/x86/crypto/aes-gcm-vaes-avx512.S
index be5c14d33acc7..3edf829c2ce07 100644
--- a/arch/x86/crypto/aes-gcm-vaes-avx512.S
+++ b/arch/x86/crypto/aes-gcm-vaes-avx512.S
@@ -68,20 +68,18 @@
 
 	// Same as above, but with the (1 << 64) bit set.
 .Lgfpoly_and_internal_carrybit:
 	.octa	0xc2000000000000010000000000000001
 
-	// The below constants are used for incrementing the counter blocks.
-	// ctr_pattern points to the four 128-bit values [0, 1, 2, 3].
-	// inc_2blocks and inc_4blocks point to the single 128-bit values 2 and
-	// 4.  Note that the same '2' is reused in ctr_pattern and inc_2blocks.
+	// Values needed to prepare the initial vector of counter blocks.
 .Lctr_pattern:
 	.octa	0
 	.octa	1
-.Linc_2blocks:
 	.octa	2
 	.octa	3
+
+	// The number of AES blocks per vector, as a 128-bit value.
 .Linc_4blocks:
 	.octa	4
 
 // Number of powers of the hash key stored in the key struct.  The powers are
 // stored from highest (H^NUM_H_POWERS) to lowest (H^1).
@@ -94,33 +92,17 @@
 #define OFFSETOF_H_POWERS	512
 
 // Offset to end of hash key powers array in the key struct.
 //
 // This is immediately followed by three zeroized padding blocks, which are
-// included so that partial vectors can be handled more easily.  E.g. if VL=64
-// and two blocks remain, we load the 4 values [H^2, H^1, 0, 0].  The most
-// padding blocks needed is 3, which occurs if [H^1, 0, 0, 0] is loaded.
+// included so that partial vectors can be handled more easily.  E.g. if two
+// blocks remain, we load the 4 values [H^2, H^1, 0, 0].  The most padding
+// blocks needed is 3, which occurs if [H^1, 0, 0, 0] is loaded.
 #define OFFSETOFEND_H_POWERS	(OFFSETOF_H_POWERS + (NUM_H_POWERS * 16))
 
 .text
 
-// Set the vector length in bytes.  This sets the VL variable and defines
-// register aliases V0-V31 that map to the ymm or zmm registers.
-.macro	_set_veclen	vl
-	.set	VL,	\vl
-.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15, \
-	16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
-.if VL == 32
-	.set	V\i,	%ymm\i
-.elseif VL == 64
-	.set	V\i,	%zmm\i
-.else
-	.error "Unsupported vector length"
-.endif
-.endr
-.endm
-
 // The _ghash_mul_step macro does one step of GHASH multiplication of the
 // 128-bit lanes of \a by the corresponding 128-bit lanes of \b and storing the
 // reduced products in \dst.  \t0, \t1, and \t2 are temporary registers of the
 // same size as \a and \b.  To complete all steps, this must invoked with \i=0
 // through \i=9.  The division into steps allows users of this macro to
@@ -284,35 +266,31 @@
 // subkey and initializes |key->ghash_key_powers| with powers of it.
 //
 // The number of key powers initialized is NUM_H_POWERS, and they are stored in
 // the order H^NUM_H_POWERS to H^1.  The zeroized padding blocks after the key
 // powers themselves are also initialized.
-//
-// This macro supports both VL=32 and VL=64.  _set_veclen must have been invoked
-// with the desired length.  In the VL=32 case, the function computes twice as
-// many key powers than are actually used by the VL=32 GCM update functions.
-// This is done to keep the key format the same regardless of vector length.
 .macro	_aes_gcm_precompute
 
 	// Function arguments
 	.set	KEY,		%rdi
 
-	// Additional local variables.  V0-V2 and %rax are used as temporaries.
+	// Additional local variables.
+	// %zmm[0-2] and %rax are used as temporaries.
 	.set	POWERS_PTR,	%rsi
 	.set	RNDKEYLAST_PTR,	%rdx
-	.set	H_CUR,		V3
+	.set	H_CUR,		%zmm3
 	.set	H_CUR_YMM,	%ymm3
 	.set	H_CUR_XMM,	%xmm3
-	.set	H_INC,		V4
+	.set	H_INC,		%zmm4
 	.set	H_INC_YMM,	%ymm4
 	.set	H_INC_XMM,	%xmm4
-	.set	GFPOLY,		V5
+	.set	GFPOLY,		%zmm5
 	.set	GFPOLY_YMM,	%ymm5
 	.set	GFPOLY_XMM,	%xmm5
 
 	// Get pointer to lowest set of key powers (located at end of array).
-	lea		OFFSETOFEND_H_POWERS-VL(KEY), POWERS_PTR
+	lea		OFFSETOFEND_H_POWERS-64(KEY), POWERS_PTR
 
 	// Encrypt an all-zeroes block to get the raw hash subkey.
 	movl		OFFSETOF_AESKEYLEN(KEY), %eax
 	lea		6*16(KEY,%rax,4), RNDKEYLAST_PTR
 	vmovdqu		(KEY), %xmm0  // Zero-th round key XOR all-zeroes block
@@ -327,12 +305,12 @@
 	// Reflect the bytes of the raw hash subkey.
 	vpshufb		.Lbswap_mask(%rip), %xmm0, H_CUR_XMM
 
 	// Zeroize the padding blocks.
 	vpxor		%xmm0, %xmm0, %xmm0
-	vmovdqu		%ymm0, VL(POWERS_PTR)
-	vmovdqu		%xmm0, VL+2*16(POWERS_PTR)
+	vmovdqu		%ymm0, 64(POWERS_PTR)
+	vmovdqu		%xmm0, 64+2*16(POWERS_PTR)
 
 	// Finish preprocessing the first key power, H^1.  Since this GHASH
 	// implementation operates directly on values with the backwards bit
 	// order specified by the GCM standard, it's necessary to preprocess the
 	// raw key as follows.  First, reflect its bytes.  Second, multiply it
@@ -368,29 +346,26 @@
 
 	// Create H_CUR_YMM = [H^2, H^1] and H_INC_YMM = [H^2, H^2].
 	vinserti128	$1, H_CUR_XMM, H_INC_YMM, H_CUR_YMM
 	vinserti128	$1, H_INC_XMM, H_INC_YMM, H_INC_YMM
 
-.if VL == 64
 	// Create H_CUR = [H^4, H^3, H^2, H^1] and H_INC = [H^4, H^4, H^4, H^4].
 	_ghash_mul	H_INC_YMM, H_CUR_YMM, H_INC_YMM, GFPOLY_YMM, \
 			%ymm0, %ymm1, %ymm2
 	vinserti64x4	$1, H_CUR_YMM, H_INC, H_CUR
 	vshufi64x2	$0, H_INC, H_INC, H_INC
-.endif
 
 	// Store the lowest set of key powers.
 	vmovdqu8	H_CUR, (POWERS_PTR)
 
-	// Compute and store the remaining key powers.  With VL=32, repeatedly
-	// multiply [H^(i+1), H^i] by [H^2, H^2] to get [H^(i+3), H^(i+2)].
-	// With VL=64, repeatedly multiply [H^(i+3), H^(i+2), H^(i+1), H^i] by
+	// Compute and store the remaining key powers.
+	// Repeatedly multiply [H^(i+3), H^(i+2), H^(i+1), H^i] by
 	// [H^4, H^4, H^4, H^4] to get [H^(i+7), H^(i+6), H^(i+5), H^(i+4)].
-	mov		$(NUM_H_POWERS*16/VL) - 1, %eax
+	mov		$3, %eax
 .Lprecompute_next\@:
-	sub		$VL, POWERS_PTR
-	_ghash_mul	H_INC, H_CUR, H_CUR, GFPOLY, V0, V1, V2
+	sub		$64, POWERS_PTR
+	_ghash_mul	H_INC, H_CUR, H_CUR, GFPOLY, %zmm0, %zmm1, %zmm2
 	vmovdqu8	H_CUR, (POWERS_PTR)
 	dec		%eax
 	jnz		.Lprecompute_next\@
 
 	vzeroupper	// This is needed after using ymm or zmm registers.
@@ -399,20 +374,14 @@
 
 // XOR together the 128-bit lanes of \src (whose low lane is \src_xmm) and store
 // the result in \dst_xmm.  This implicitly zeroizes the other lanes of dst.
 .macro	_horizontal_xor	src, src_xmm, dst_xmm, t0_xmm, t1_xmm, t2_xmm
 	vextracti32x4	$1, \src, \t0_xmm
-.if VL == 32
-	vpxord		\t0_xmm, \src_xmm, \dst_xmm
-.elseif VL == 64
 	vextracti32x4	$2, \src, \t1_xmm
 	vextracti32x4	$3, \src, \t2_xmm
 	vpxord		\t0_xmm, \src_xmm, \dst_xmm
 	vpternlogd	$0x96, \t1_xmm, \t2_xmm, \dst_xmm
-.else
-	.error "Unsupported vector length"
-.endif
 .endm
 
 // Do one step of the GHASH update of the data blocks given in the vector
 // registers GHASHDATA[0-3].  \i specifies the step to do, 0 through 9.  The
 // division into steps allows users of this macro to optionally interleave the
@@ -422,29 +391,25 @@
 // GHASHTMP[0-2] as temporaries.  This macro handles the byte-reflection of the
 // data blocks.  The parameter registers must be preserved across steps.
 //
 // The GHASH update does: GHASH_ACC = H_POW4*(GHASHDATA0 + GHASH_ACC) +
 // H_POW3*GHASHDATA1 + H_POW2*GHASHDATA2 + H_POW1*GHASHDATA3, where the
-// operations are vectorized operations on vectors of 16-byte blocks.  E.g.,
-// with VL=32 there are 2 blocks per vector and the vectorized terms correspond
-// to the following non-vectorized terms:
-//
-//	H_POW4*(GHASHDATA0 + GHASH_ACC) => H^8*(blk0 + GHASH_ACC_XMM) and H^7*(blk1 + 0)
-//	H_POW3*GHASHDATA1 => H^6*blk2 and H^5*blk3
-//	H_POW2*GHASHDATA2 => H^4*blk4 and H^3*blk5
-//	H_POW1*GHASHDATA3 => H^2*blk6 and H^1*blk7
+// operations are vectorized operations on 512-bit vectors of 128-bit blocks.
+// The vectorized terms correspond to the following non-vectorized terms:
 //
-// With VL=64, we use 4 blocks/vector, H^16 through H^1, and blk0 through blk15.
+//       H_POW4*(GHASHDATA0 + GHASH_ACC) => H^16*(blk0 + GHASH_ACC_XMM),
+//              H^15*(blk1 + 0), H^14*(blk2 + 0), and H^13*(blk3 + 0)
+//       H_POW3*GHASHDATA1 => H^12*blk4, H^11*blk5, H^10*blk6, and H^9*blk7
+//       H_POW2*GHASHDATA2 => H^8*blk8,  H^7*blk9,  H^6*blk10, and H^5*blk11
+//       H_POW1*GHASHDATA3 => H^4*blk12, H^3*blk13, H^2*blk14, and H^1*blk15
 //
 // More concretely, this code does:
 //   - Do vectorized "schoolbook" multiplications to compute the intermediate
 //     256-bit product of each block and its corresponding hash key power.
-//     There are 4*VL/16 of these intermediate products.
-//   - Sum (XOR) the intermediate 256-bit products across vectors.  This leaves
-//     VL/16 256-bit intermediate values.
+//   - Sum (XOR) the intermediate 256-bit products across vectors.
 //   - Do a vectorized reduction of these 256-bit intermediate values to
-//     128-bits each.  This leaves VL/16 128-bit intermediate values.
+//     128-bits each.
 //   - Sum (XOR) these values and store the 128-bit result in GHASH_ACC_XMM.
 //
 // See _ghash_mul_step for the full explanation of the operations performed for
 // each individual finite field multiplication and reduction.
 .macro	_ghash_step_4x	i
@@ -496,78 +461,76 @@
 	_horizontal_xor	GHASH_ACC, GHASH_ACC_XMM, GHASH_ACC_XMM, \
 			GHASHDATA0_XMM, GHASHDATA1_XMM, GHASHDATA2_XMM
 .endif
 .endm
 
-// Do one non-last round of AES encryption on the counter blocks in V0-V3 using
-// the round key that has been broadcast to all 128-bit lanes of \round_key.
+// Do one non-last round of AES encryption on the blocks in %zmm[0-3] using the
+// round key that has been broadcast to all 128-bit lanes of \round_key.
 .macro	_vaesenc_4x	round_key
-	vaesenc		\round_key, V0, V0
-	vaesenc		\round_key, V1, V1
-	vaesenc		\round_key, V2, V2
-	vaesenc		\round_key, V3, V3
+	vaesenc		\round_key, %zmm0, %zmm0
+	vaesenc		\round_key, %zmm1, %zmm1
+	vaesenc		\round_key, %zmm2, %zmm2
+	vaesenc		\round_key, %zmm3, %zmm3
 .endm
 
 // Start the AES encryption of four vectors of counter blocks.
 .macro	_ctr_begin_4x
 
 	// Increment LE_CTR four times to generate four vectors of little-endian
-	// counter blocks, swap each to big-endian, and store them in V0-V3.
-	vpshufb		BSWAP_MASK, LE_CTR, V0
+	// counter blocks, swap each to big-endian, and store them in %zmm[0-3].
+	vpshufb		BSWAP_MASK, LE_CTR, %zmm0
 	vpaddd		LE_CTR_INC, LE_CTR, LE_CTR
-	vpshufb		BSWAP_MASK, LE_CTR, V1
+	vpshufb		BSWAP_MASK, LE_CTR, %zmm1
 	vpaddd		LE_CTR_INC, LE_CTR, LE_CTR
-	vpshufb		BSWAP_MASK, LE_CTR, V2
+	vpshufb		BSWAP_MASK, LE_CTR, %zmm2
 	vpaddd		LE_CTR_INC, LE_CTR, LE_CTR
-	vpshufb		BSWAP_MASK, LE_CTR, V3
+	vpshufb		BSWAP_MASK, LE_CTR, %zmm3
 	vpaddd		LE_CTR_INC, LE_CTR, LE_CTR
 
 	// AES "round zero": XOR in the zero-th round key.
-	vpxord		RNDKEY0, V0, V0
-	vpxord		RNDKEY0, V1, V1
-	vpxord		RNDKEY0, V2, V2
-	vpxord		RNDKEY0, V3, V3
+	vpxord		RNDKEY0, %zmm0, %zmm0
+	vpxord		RNDKEY0, %zmm1, %zmm1
+	vpxord		RNDKEY0, %zmm2, %zmm2
+	vpxord		RNDKEY0, %zmm3, %zmm3
 .endm
 
-// Do the last AES round for four vectors of counter blocks V0-V3, XOR source
-// data with the resulting keystream, and write the result to DST and
+// Do the last AES round for four vectors of counter blocks %zmm[0-3], XOR
+// source data with the resulting keystream, and write the result to DST and
 // GHASHDATA[0-3].  (Implementation differs slightly, but has the same effect.)
 .macro	_aesenclast_and_xor_4x
 	// XOR the source data with the last round key, saving the result in
 	// GHASHDATA[0-3].  This reduces latency by taking advantage of the
 	// property vaesenclast(key, a) ^ b == vaesenclast(key ^ b, a).
-	vpxord		0*VL(SRC), RNDKEYLAST, GHASHDATA0
-	vpxord		1*VL(SRC), RNDKEYLAST, GHASHDATA1
-	vpxord		2*VL(SRC), RNDKEYLAST, GHASHDATA2
-	vpxord		3*VL(SRC), RNDKEYLAST, GHASHDATA3
+	vpxord		0*64(SRC), RNDKEYLAST, GHASHDATA0
+	vpxord		1*64(SRC), RNDKEYLAST, GHASHDATA1
+	vpxord		2*64(SRC), RNDKEYLAST, GHASHDATA2
+	vpxord		3*64(SRC), RNDKEYLAST, GHASHDATA3
 
 	// Do the last AES round.  This handles the XOR with the source data
 	// too, as per the optimization described above.
-	vaesenclast	GHASHDATA0, V0, GHASHDATA0
-	vaesenclast	GHASHDATA1, V1, GHASHDATA1
-	vaesenclast	GHASHDATA2, V2, GHASHDATA2
-	vaesenclast	GHASHDATA3, V3, GHASHDATA3
+	vaesenclast	GHASHDATA0, %zmm0, GHASHDATA0
+	vaesenclast	GHASHDATA1, %zmm1, GHASHDATA1
+	vaesenclast	GHASHDATA2, %zmm2, GHASHDATA2
+	vaesenclast	GHASHDATA3, %zmm3, GHASHDATA3
 
 	// Store the en/decrypted data to DST.
-	vmovdqu8	GHASHDATA0, 0*VL(DST)
-	vmovdqu8	GHASHDATA1, 1*VL(DST)
-	vmovdqu8	GHASHDATA2, 2*VL(DST)
-	vmovdqu8	GHASHDATA3, 3*VL(DST)
+	vmovdqu8	GHASHDATA0, 0*64(DST)
+	vmovdqu8	GHASHDATA1, 1*64(DST)
+	vmovdqu8	GHASHDATA2, 2*64(DST)
+	vmovdqu8	GHASHDATA3, 3*64(DST)
 .endm
 
 // void aes_gcm_{enc,dec}_update_vaes_avx512(const struct aes_gcm_key_vaes_avx512 *key,
 //					     const u32 le_ctr[4], u8 ghash_acc[16],
 //					     const u8 *src, u8 *dst, int datalen);
 //
 // This macro generates a GCM encryption or decryption update function with the
-// above prototype (with \enc selecting which one).  This macro supports both
-// VL=32 and VL=64.  _set_veclen must have been invoked with the desired length.
-//
-// This function computes the next portion of the CTR keystream, XOR's it with
-// |datalen| bytes from |src|, and writes the resulting encrypted or decrypted
-// data to |dst|.  It also updates the GHASH accumulator |ghash_acc| using the
-// next |datalen| ciphertext bytes.
+// above prototype (with \enc selecting which one).  The function computes the
+// next portion of the CTR keystream, XOR's it with |datalen| bytes from |src|,
+// and writes the resulting encrypted or decrypted data to |dst|.  It also
+// updates the GHASH accumulator |ghash_acc| using the next |datalen| ciphertext
+// bytes.
 //
 // |datalen| must be a multiple of 16, except on the last call where it can be
 // any length.  The caller must do any buffering needed to ensure this.  Both
 // in-place and out-of-place en/decryption are supported.
 //
@@ -598,73 +561,73 @@
 	.set	AESKEYLEN64,	%r10
 
 	// Pointer to the last AES round key for the chosen AES variant
 	.set	RNDKEYLAST_PTR,	%r11
 
-	// In the main loop, V0-V3 are used as AES input and output.  Elsewhere
-	// they are used as temporary registers.
+	// In the main loop, %zmm[0-3] are used as AES input and output.
+	// Elsewhere they are used as temporary registers.
 
 	// GHASHDATA[0-3] hold the ciphertext blocks and GHASH input data.
-	.set	GHASHDATA0,	V4
+	.set	GHASHDATA0,	%zmm4
 	.set	GHASHDATA0_XMM,	%xmm4
-	.set	GHASHDATA1,	V5
+	.set	GHASHDATA1,	%zmm5
 	.set	GHASHDATA1_XMM,	%xmm5
-	.set	GHASHDATA2,	V6
+	.set	GHASHDATA2,	%zmm6
 	.set	GHASHDATA2_XMM,	%xmm6
-	.set	GHASHDATA3,	V7
+	.set	GHASHDATA3,	%zmm7
 
 	// BSWAP_MASK is the shuffle mask for byte-reflecting 128-bit values
 	// using vpshufb, copied to all 128-bit lanes.
-	.set	BSWAP_MASK,	V8
+	.set	BSWAP_MASK,	%zmm8
 
 	// RNDKEY temporarily holds the next AES round key.
-	.set	RNDKEY,		V9
+	.set	RNDKEY,		%zmm9
 
 	// GHASH_ACC is the accumulator variable for GHASH.  When fully reduced,
 	// only the lowest 128-bit lane can be nonzero.  When not fully reduced,
 	// more than one lane may be used, and they need to be XOR'd together.
-	.set	GHASH_ACC,	V10
+	.set	GHASH_ACC,	%zmm10
 	.set	GHASH_ACC_XMM,	%xmm10
 
 	// LE_CTR_INC is the vector of 32-bit words that need to be added to a
 	// vector of little-endian counter blocks to advance it forwards.
-	.set	LE_CTR_INC,	V11
+	.set	LE_CTR_INC,	%zmm11
 
 	// LE_CTR contains the next set of little-endian counter blocks.
-	.set	LE_CTR,		V12
+	.set	LE_CTR,		%zmm12
 
 	// RNDKEY0, RNDKEYLAST, and RNDKEY_M[9-1] contain cached AES round keys,
 	// copied to all 128-bit lanes.  RNDKEY0 is the zero-th round key,
 	// RNDKEYLAST the last, and RNDKEY_M\i the one \i-th from the last.
-	.set	RNDKEY0,	V13
-	.set	RNDKEYLAST,	V14
-	.set	RNDKEY_M9,	V15
-	.set	RNDKEY_M8,	V16
-	.set	RNDKEY_M7,	V17
-	.set	RNDKEY_M6,	V18
-	.set	RNDKEY_M5,	V19
-	.set	RNDKEY_M4,	V20
-	.set	RNDKEY_M3,	V21
-	.set	RNDKEY_M2,	V22
-	.set	RNDKEY_M1,	V23
+	.set	RNDKEY0,	%zmm13
+	.set	RNDKEYLAST,	%zmm14
+	.set	RNDKEY_M9,	%zmm15
+	.set	RNDKEY_M8,	%zmm16
+	.set	RNDKEY_M7,	%zmm17
+	.set	RNDKEY_M6,	%zmm18
+	.set	RNDKEY_M5,	%zmm19
+	.set	RNDKEY_M4,	%zmm20
+	.set	RNDKEY_M3,	%zmm21
+	.set	RNDKEY_M2,	%zmm22
+	.set	RNDKEY_M1,	%zmm23
 
 	// GHASHTMP[0-2] are temporary variables used by _ghash_step_4x.  These
 	// cannot coincide with anything used for AES encryption, since for
 	// performance reasons GHASH and AES encryption are interleaved.
-	.set	GHASHTMP0,	V24
-	.set	GHASHTMP1,	V25
-	.set	GHASHTMP2,	V26
+	.set	GHASHTMP0,	%zmm24
+	.set	GHASHTMP1,	%zmm25
+	.set	GHASHTMP2,	%zmm26
 
-	// H_POW[4-1] contain the powers of the hash key H^(4*VL/16)...H^1.  The
+	// H_POW[4-1] contain the powers of the hash key H^16...H^1.  The
 	// descending numbering reflects the order of the key powers.
-	.set	H_POW4,		V27
-	.set	H_POW3,		V28
-	.set	H_POW2,		V29
-	.set	H_POW1,		V30
+	.set	H_POW4,		%zmm27
+	.set	H_POW3,		%zmm28
+	.set	H_POW2,		%zmm29
+	.set	H_POW1,		%zmm30
 
 	// GFPOLY contains the .Lgfpoly constant, copied to all 128-bit lanes.
-	.set	GFPOLY,		V31
+	.set	GFPOLY,		%zmm31
 
 	// Load some constants.
 	vbroadcasti32x4	.Lbswap_mask(%rip), BSWAP_MASK
 	vbroadcasti32x4	.Lgfpoly(%rip), GFPOLY
 
@@ -683,33 +646,27 @@
 	vbroadcasti32x4	(RNDKEYLAST_PTR), RNDKEYLAST
 
 	// Finish initializing LE_CTR by adding [0, 1, ...] to its low words.
 	vpaddd		.Lctr_pattern(%rip), LE_CTR, LE_CTR
 
-	// Initialize LE_CTR_INC to contain VL/16 in all 128-bit lanes.
-.if VL == 32
-	vbroadcasti32x4	.Linc_2blocks(%rip), LE_CTR_INC
-.elseif VL == 64
+	// Load 4 into all 128-bit lanes of LE_CTR_INC.
 	vbroadcasti32x4	.Linc_4blocks(%rip), LE_CTR_INC
-.else
-	.error "Unsupported vector length"
-.endif
 
-	// If there are at least 4*VL bytes of data, then continue into the loop
-	// that processes 4*VL bytes of data at a time.  Otherwise skip it.
+	// If there are at least 256 bytes of data, then continue into the loop
+	// that processes 256 bytes of data at a time.  Otherwise skip it.
 	//
-	// Pre-subtracting 4*VL from DATALEN saves an instruction from the main
+	// Pre-subtracting 256 from DATALEN saves an instruction from the main
 	// loop and also ensures that at least one write always occurs to
 	// DATALEN, zero-extending it and allowing DATALEN64 to be used later.
-	add		$-4*VL, DATALEN  // shorter than 'sub 4*VL' when VL=32
+	sub		$256, DATALEN
 	jl		.Lcrypt_loop_4x_done\@
 
 	// Load powers of the hash key.
-	vmovdqu8	OFFSETOFEND_H_POWERS-4*VL(KEY), H_POW4
-	vmovdqu8	OFFSETOFEND_H_POWERS-3*VL(KEY), H_POW3
-	vmovdqu8	OFFSETOFEND_H_POWERS-2*VL(KEY), H_POW2
-	vmovdqu8	OFFSETOFEND_H_POWERS-1*VL(KEY), H_POW1
+	vmovdqu8	OFFSETOFEND_H_POWERS-4*64(KEY), H_POW4
+	vmovdqu8	OFFSETOFEND_H_POWERS-3*64(KEY), H_POW3
+	vmovdqu8	OFFSETOFEND_H_POWERS-2*64(KEY), H_POW2
+	vmovdqu8	OFFSETOFEND_H_POWERS-1*64(KEY), H_POW1
 
 	// Main loop: en/decrypt and hash 4 vectors at a time.
 	//
 	// When possible, interleave the AES encryption of the counter blocks
 	// with the GHASH update of the ciphertext blocks.  This improves
@@ -734,13 +691,13 @@
 	_vaesenc_4x	RNDKEY
 	add		$16, %rax
 	cmp		%rax, RNDKEYLAST_PTR
 	jne		1b
 	_aesenclast_and_xor_4x
-	sub		$-4*VL, SRC  // shorter than 'add 4*VL' when VL=32
-	sub		$-4*VL, DST
-	add		$-4*VL, DATALEN
+	add		$256, SRC
+	add		$256, DST
+	sub		$256, DATALEN
 	jl		.Lghash_last_ciphertext_4x\@
 .endif
 
 	// Cache as many additional AES round keys as possible.
 .irp i, 9,8,7,6,5,4,3,2,1
@@ -750,14 +707,14 @@
 .Lcrypt_loop_4x\@:
 
 	// If decrypting, load more ciphertext blocks into GHASHDATA[0-3].  If
 	// encrypting, GHASHDATA[0-3] already contain the previous ciphertext.
 .if !\enc
-	vmovdqu8	0*VL(SRC), GHASHDATA0
-	vmovdqu8	1*VL(SRC), GHASHDATA1
-	vmovdqu8	2*VL(SRC), GHASHDATA2
-	vmovdqu8	3*VL(SRC), GHASHDATA3
+	vmovdqu8	0*64(SRC), GHASHDATA0
+	vmovdqu8	1*64(SRC), GHASHDATA1
+	vmovdqu8	2*64(SRC), GHASHDATA2
+	vmovdqu8	3*64(SRC), GHASHDATA3
 .endif
 
 	// Start the AES encryption of the counter blocks.
 	_ctr_begin_4x
 	cmp		$24, AESKEYLEN
@@ -773,21 +730,22 @@
 	_vaesenc_4x	RNDKEY
 	vbroadcasti32x4	-10*16(RNDKEYLAST_PTR), RNDKEY
 	_vaesenc_4x	RNDKEY
 128:
 
-	// Finish the AES encryption of the counter blocks in V0-V3, interleaved
-	// with the GHASH update of the ciphertext blocks in GHASHDATA[0-3].
+	// Finish the AES encryption of the counter blocks in %zmm[0-3],
+	// interleaved with the GHASH update of the ciphertext blocks in
+	// GHASHDATA[0-3].
 .irp i, 9,8,7,6,5,4,3,2,1
 	_ghash_step_4x  (9 - \i)
 	_vaesenc_4x	RNDKEY_M\i
 .endr
 	_ghash_step_4x	9
 	_aesenclast_and_xor_4x
-	sub		$-4*VL, SRC  // shorter than 'add 4*VL' when VL=32
-	sub		$-4*VL, DST
-	add		$-4*VL, DATALEN
+	add		$256, SRC
+	add		$256, DST
+	sub		$256, DATALEN
 	jge		.Lcrypt_loop_4x\@
 
 .if \enc
 .Lghash_last_ciphertext_4x\@:
 	// Update GHASH with the last set of ciphertext blocks.
@@ -796,25 +754,26 @@
 .endr
 .endif
 
 .Lcrypt_loop_4x_done\@:
 
-	// Undo the extra subtraction by 4*VL and check whether data remains.
-	sub		$-4*VL, DATALEN  // shorter than 'add 4*VL' when VL=32
+	// Undo the extra subtraction by 256 and check whether data remains.
+	add		$256, DATALEN
 	jz		.Ldone\@
 
-	// The data length isn't a multiple of 4*VL.  Process the remaining data
-	// of length 1 <= DATALEN < 4*VL, up to one vector (VL bytes) at a time.
-	// Going one vector at a time may seem inefficient compared to having
-	// separate code paths for each possible number of vectors remaining.
-	// However, using a loop keeps the code size down, and it performs
-	// surprising well; modern CPUs will start executing the next iteration
-	// before the previous one finishes and also predict the number of loop
-	// iterations.  For a similar reason, we roll up the AES rounds.
+	// The data length isn't a multiple of 256 bytes.  Process the remaining
+	// data of length 1 <= DATALEN < 256, up to one 64-byte vector at a
+	// time.  Going one vector at a time may seem inefficient compared to
+	// having separate code paths for each possible number of vectors
+	// remaining.  However, using a loop keeps the code size down, and it
+	// performs surprising well; modern CPUs will start executing the next
+	// iteration before the previous one finishes and also predict the
+	// number of loop iterations.  For a similar reason, we roll up the AES
+	// rounds.
 	//
-	// On the last iteration, the remaining length may be less than VL.
-	// Handle this using masking.
+	// On the last iteration, the remaining length may be less than 64
+	// bytes.  Handle this using masking.
 	//
 	// Since there are enough key powers available for all remaining data,
 	// there is no need to do a GHASH reduction after each iteration.
 	// Instead, multiply each remaining block by its own key power, and only
 	// do a GHASH reduction at the very end.
@@ -839,69 +798,64 @@
 	vpxor		HI_XMM, HI_XMM, HI_XMM
 
 .Lcrypt_loop_1x\@:
 
 	// Select the appropriate mask for this iteration: all 1's if
-	// DATALEN >= VL, otherwise DATALEN 1's.  Do this branchlessly using the
+	// DATALEN >= 64, otherwise DATALEN 1's.  Do this branchlessly using the
 	// bzhi instruction from BMI2.  (This relies on DATALEN <= 255.)
-.if VL < 64
-	mov		$-1, %eax
-	bzhi		DATALEN, %eax, %eax
-	kmovd		%eax, %k1
-.else
 	mov		$-1, %rax
 	bzhi		DATALEN64, %rax, %rax
 	kmovq		%rax, %k1
-.endif
 
 	// Encrypt a vector of counter blocks.  This does not need to be masked.
-	vpshufb		BSWAP_MASK, LE_CTR, V0
+	vpshufb		BSWAP_MASK, LE_CTR, %zmm0
 	vpaddd		LE_CTR_INC, LE_CTR, LE_CTR
-	vpxord		RNDKEY0, V0, V0
+	vpxord		RNDKEY0, %zmm0, %zmm0
 	lea		16(KEY), %rax
 1:
 	vbroadcasti32x4	(%rax), RNDKEY
-	vaesenc		RNDKEY, V0, V0
+	vaesenc		RNDKEY, %zmm0, %zmm0
 	add		$16, %rax
 	cmp		%rax, RNDKEYLAST_PTR
 	jne		1b
-	vaesenclast	RNDKEYLAST, V0, V0
+	vaesenclast	RNDKEYLAST, %zmm0, %zmm0
 
 	// XOR the data with the appropriate number of keystream bytes.
-	vmovdqu8	(SRC), V1{%k1}{z}
-	vpxord		V1, V0, V0
-	vmovdqu8	V0, (DST){%k1}
+	vmovdqu8	(SRC), %zmm1{%k1}{z}
+	vpxord		%zmm1, %zmm0, %zmm0
+	vmovdqu8	%zmm0, (DST){%k1}
 
 	// Update GHASH with the ciphertext block(s), without reducing.
 	//
-	// In the case of DATALEN < VL, the ciphertext is zero-padded to VL.
-	// (If decrypting, it's done by the above masked load.  If encrypting,
-	// it's done by the below masked register-to-register move.)  Note that
-	// if DATALEN <= VL - 16, there will be additional padding beyond the
-	// padding of the last block specified by GHASH itself; i.e., there may
-	// be whole block(s) that get processed by the GHASH multiplication and
-	// reduction instructions but should not actually be included in the
+	// In the case of DATALEN < 64, the ciphertext is zero-padded to 64
+	// bytes.  (If decrypting, it's done by the above masked load.  If
+	// encrypting, it's done by the below masked register-to-register move.)
+	// Note that if DATALEN <= 48, there will be additional padding beyond
+	// the padding of the last block specified by GHASH itself; i.e., there
+	// may be whole block(s) that get processed by the GHASH multiplication
+	// and reduction instructions but should not actually be included in the
 	// GHASH.  However, any such blocks are all-zeroes, and the values that
 	// they're multiplied with are also all-zeroes.  Therefore they just add
 	// 0 * 0 = 0 to the final GHASH result, which makes no difference.
 	vmovdqu8	(POWERS_PTR), H_POW1
 .if \enc
-	vmovdqu8	V0, V1{%k1}{z}
+	vmovdqu8	%zmm0, %zmm1{%k1}{z}
 .endif
-	vpshufb		BSWAP_MASK, V1, V0
-	vpxord		GHASH_ACC, V0, V0
-	_ghash_mul_noreduce	H_POW1, V0, LO, MI, HI, GHASHDATA3, V1, V2, V3
+	vpshufb		BSWAP_MASK, %zmm1, %zmm0
+	vpxord		GHASH_ACC, %zmm0, %zmm0
+	_ghash_mul_noreduce	H_POW1, %zmm0, LO, MI, HI, \
+				GHASHDATA3, %zmm1, %zmm2, %zmm3
 	vpxor		GHASH_ACC_XMM, GHASH_ACC_XMM, GHASH_ACC_XMM
 
-	add		$VL, POWERS_PTR
-	add		$VL, SRC
-	add		$VL, DST
-	sub		$VL, DATALEN
+	add		$64, POWERS_PTR
+	add		$64, SRC
+	add		$64, DST
+	sub		$64, DATALEN
 	jg		.Lcrypt_loop_1x\@
 
 	// Finally, do the GHASH reduction.
-	_ghash_reduce	LO, MI, HI, GFPOLY, V0
+	_ghash_reduce	LO, MI, HI, GFPOLY, %zmm0
 	_horizontal_xor	HI, HI_XMM, GHASH_ACC_XMM, %xmm0, %xmm1, %xmm2
 
 .Ldone\@:
 	// Store the updated GHASH accumulator back to memory.
 	vmovdqu		GHASH_ACC_XMM, (GHASH_ACC_PTR)
@@ -1045,11 +999,10 @@
 .endif
 	// No need for vzeroupper here, since only used xmm registers were used.
 	RET
 .endm
 
-_set_veclen 64
 SYM_FUNC_START(aes_gcm_precompute_vaes_avx512)
 	_aes_gcm_precompute
 SYM_FUNC_END(aes_gcm_precompute_vaes_avx512)
 SYM_FUNC_START(aes_gcm_enc_update_vaes_avx512)
 	_aes_gcm_update	1
-- 
2.51.0

