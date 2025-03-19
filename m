Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9611E1C3F;
	Wed, 19 Mar 2025 19:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742412012; cv=none; b=fr/rP5qceHL0JHgjw9E5fDQKT8ENWuQsFMtjwkrL9wqmPxBdwJspkaRKySTUtC7hk3+mxxVWzPD/lbefm19wi4IsUFQSOs3NAOYoIVSfUbzj2n1FeOXNbRDQZFZFAevgvSltVxAKr8FB9XN1VTkTVpR6h4Yupl39ZhoCvaK86GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742412012; c=relaxed/simple;
	bh=WCneMrBcpmRVek5747ppOVp35Y8F8M+Bo0HVH6JXS6M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kVCVFdM6IBfZ6Ne9k0mj+pCJoh87QPFD+x8MuF4zgTm2FP5umSjsKoszKbnonRTUDj0YWX3B6JEldx4N9Xa/YtOn4+L+thTSrPWdBv3QscdBdTgurKTIbIWRCymq/g9xZxdDPCLXNUZyNoev7rj7WP5UVNwSDfW+LqL3pIkckk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D5QcI1G0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D5QcI1G0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0648AC4CEE4;
	Wed, 19 Mar 2025 19:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742412012;
	bh=WCneMrBcpmRVek5747ppOVp35Y8F8M+Bo0HVH6JXS6M=;
	h=From:To:Cc:Subject:Date:From;
	b=D5QcI1G0REJ5WoP8d6hDQZQKv8myXbFM3iTSPwpxXwoHvnX2b/Q9OtB3tnhWRccCZ
	 F7Ha8Adjea3OU7s8drA3BaFOOVA37EhHKVFNGQbwDNQ49wCllbJliT53qB4wBz7Cjg
	 duBO6nytFXVzlV+TXZycpBApZLP6QbDDbWtFtxhRUQaIHeaQO9pcrQMCIarEjHc1Mg
	 zcLsqzXiuVHbyptDAOLIBzNkg8giIF+yhryL2I8/QY6qN0S5HRDS4WRy+LTwWCtw+Y
	 9aBSucJ2QCY/he7rgjAy5inYf0sQaHK0V+eJP+3hvzepOPouR4LpKCxpth3EcInANF
	 Hu1hPGbRG9n5w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH] crypto: x86/aes - drop the avx10_256 AES-XTS and AES-CTR code
Date: Wed, 19 Mar 2025 12:17:53 -0700
Message-ID: <20250319191753.152096-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Intel made a late change to the AVX10 specification that removes support
for a 256-bit maximum vector length and enumeration of the maximum
vector length.  AVX10 will imply a maximum vector length of 512 bits.
I.e. there won't be any such thing as AVX10/256 or AVX10/512; there will
just be AVX10, and it will essentially just consolidate AVX512 features.

As a result of this new development, my strategy of providing both
*_avx10_256 and *_avx10_512 functions didn't turn out to be that useful.
The only remaining motivation for the 256-bit AVX512 / AVX10 functions
is to avoid downclocking on older Intel CPUs.  But in the case of
AES-XTS and AES-CTR, I already wrote *_avx2 code too (primarily to
support CPUs without AVX512), which performs almost as well as
*_avx10_256.  So we should just use that.

Therefore, remove the *_avx10_256 AES-XTS and AES-CTR functions and
algorithms, and rename the *_avx10_512 AES-XTS and AES-CTR functions and
algorithms to *_avx512.  Make Ice Lake and Tiger Lake use *_avx2 instead
of *_avx10_256 which they previously used.

I've left AES-GCM unchanged for now.  There is no VAES+AVX2 optimized
AES-GCM in the kernel yet, so the path forward for that is not as clear.
However, I did wrote a VAES+AVX2 optimized AES-GCM for BoringSSL.  So
one option is to port that to the kernel and then do the same cleanup.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aes-ctr-avx-x86_64.S |  47 ++++-------
 arch/x86/crypto/aes-xts-avx-x86_64.S | 118 ++++++++++++---------------
 arch/x86/crypto/aesni-intel_glue.c   |  30 +++----
 3 files changed, 74 insertions(+), 121 deletions(-)

diff --git a/arch/x86/crypto/aes-ctr-avx-x86_64.S b/arch/x86/crypto/aes-ctr-avx-x86_64.S
index 1685d8b24b2ca..bbbfd80f5a502 100644
--- a/arch/x86/crypto/aes-ctr-avx-x86_64.S
+++ b/arch/x86/crypto/aes-ctr-avx-x86_64.S
@@ -46,12 +46,11 @@
 //
 // This file contains x86_64 assembly implementations of AES-CTR and AES-XCTR
 // using the following sets of CPU features:
 //	- AES-NI && AVX
 //	- VAES && AVX2
-//	- VAES && (AVX10/256 || (AVX512BW && AVX512VL)) && BMI2
-//	- VAES && (AVX10/512 || (AVX512BW && AVX512VL)) && BMI2
+//	- VAES && AVX512BW && AVX512VL && BMI2
 //
 // See the function definitions at the bottom of the file for more information.
 
 #include <linux/linkage.h>
 #include <linux/cfi_types.h>
@@ -74,31 +73,29 @@
 	.quad	4, 0
 
 .text
 
 // Move a vector between memory and a register.
-// The register operand must be in the first 16 vector registers.
 .macro	_vmovdqu	src, dst
 .if VL < 64
 	vmovdqu		\src, \dst
 .else
 	vmovdqu8	\src, \dst
 .endif
 .endm
 
 // Move a vector between registers.
-// The registers must be in the first 16 vector registers.
 .macro	_vmovdqa	src, dst
 .if VL < 64
 	vmovdqa		\src, \dst
 .else
 	vmovdqa64	\src, \dst
 .endif
 .endm
 
 // Broadcast a 128-bit value from memory to all 128-bit lanes of a vector
-// register.  The register operand must be in the first 16 vector registers.
+// register.
 .macro	_vbroadcast128	src, dst
 .if VL == 16
 	vmovdqu		\src, \dst
 .elseif VL == 32
 	vbroadcasti128	\src, \dst
@@ -106,11 +103,10 @@
 	vbroadcasti32x4	\src, \dst
 .endif
 .endm
 
 // XOR two vectors together.
-// Any register operands must be in the first 16 vector registers.
 .macro	_vpxor	src1, src2, dst
 .if VL < 64
 	vpxor		\src1, \src2, \dst
 .else
 	vpxord		\src1, \src2, \dst
@@ -197,20 +193,20 @@
 
 // Prepare the next two vectors of AES inputs in AESDATA\i0 and AESDATA\i1, and
 // XOR each with the zero-th round key.  Also update LE_CTR if !\final.
 .macro	_prepare_2_ctr_vecs	is_xctr, i0, i1, final=0
 .if \is_xctr
-  .if USE_AVX10
-	_vmovdqa	LE_CTR, AESDATA\i0
+  .if USE_AVX512
+	vmovdqa64	LE_CTR, AESDATA\i0
 	vpternlogd	$0x96, XCTR_IV, RNDKEY0, AESDATA\i0
   .else
 	vpxor		XCTR_IV, LE_CTR, AESDATA\i0
 	vpxor		RNDKEY0, AESDATA\i0, AESDATA\i0
   .endif
 	vpaddq		LE_CTR_INC1, LE_CTR, AESDATA\i1
 
-  .if USE_AVX10
+  .if USE_AVX512
 	vpternlogd	$0x96, XCTR_IV, RNDKEY0, AESDATA\i1
   .else
 	vpxor		XCTR_IV, AESDATA\i1, AESDATA\i1
 	vpxor		RNDKEY0, AESDATA\i1, AESDATA\i1
   .endif
@@ -479,22 +475,16 @@
 	_vmovdqa	AESDATA3, AESDATA0
 
 .Lxor_tail_partial_vec_0\@:
 	// XOR the remaining 1 <= LEN < VL bytes.  It's easy if masked
 	// loads/stores are available; otherwise it's a bit harder...
-.if USE_AVX10
-  .if VL <= 32
-	mov		$-1, %eax
-	bzhi		LEN, %eax, %eax
-	kmovd		%eax, %k1
-  .else
+.if USE_AVX512
 	mov		$-1, %rax
 	bzhi		LEN64, %rax, %rax
 	kmovq		%rax, %k1
-  .endif
 	vmovdqu8	(SRC), AESDATA1{%k1}{z}
-	_vpxor		AESDATA1, AESDATA0, AESDATA0
+	vpxord		AESDATA1, AESDATA0, AESDATA0
 	vmovdqu8	AESDATA0, (DST){%k1}
 .else
   .if VL == 32
 	cmp		$16, LEN
 	jl		1f
@@ -552,41 +542,32 @@
 // with HCTR2" (https://eprint.iacr.org/2021/1441.pdf).  XCTR is an
 // easier-to-implement variant of CTR that uses little endian byte order and
 // eliminates carries.  |ctr| is the per-message block counter starting at 1.
 
 .set	VL, 16
-.set	USE_AVX10, 0
+.set	USE_AVX512, 0
 SYM_TYPED_FUNC_START(aes_ctr64_crypt_aesni_avx)
 	_aes_ctr_crypt	0
 SYM_FUNC_END(aes_ctr64_crypt_aesni_avx)
 SYM_TYPED_FUNC_START(aes_xctr_crypt_aesni_avx)
 	_aes_ctr_crypt	1
 SYM_FUNC_END(aes_xctr_crypt_aesni_avx)
 
 #if defined(CONFIG_AS_VAES) && defined(CONFIG_AS_VPCLMULQDQ)
 .set	VL, 32
-.set	USE_AVX10, 0
+.set	USE_AVX512, 0
 SYM_TYPED_FUNC_START(aes_ctr64_crypt_vaes_avx2)
 	_aes_ctr_crypt	0
 SYM_FUNC_END(aes_ctr64_crypt_vaes_avx2)
 SYM_TYPED_FUNC_START(aes_xctr_crypt_vaes_avx2)
 	_aes_ctr_crypt	1
 SYM_FUNC_END(aes_xctr_crypt_vaes_avx2)
 
-.set	VL, 32
-.set	USE_AVX10, 1
-SYM_TYPED_FUNC_START(aes_ctr64_crypt_vaes_avx10_256)
-	_aes_ctr_crypt	0
-SYM_FUNC_END(aes_ctr64_crypt_vaes_avx10_256)
-SYM_TYPED_FUNC_START(aes_xctr_crypt_vaes_avx10_256)
-	_aes_ctr_crypt	1
-SYM_FUNC_END(aes_xctr_crypt_vaes_avx10_256)
-
 .set	VL, 64
-.set	USE_AVX10, 1
-SYM_TYPED_FUNC_START(aes_ctr64_crypt_vaes_avx10_512)
+.set	USE_AVX512, 1
+SYM_TYPED_FUNC_START(aes_ctr64_crypt_vaes_avx512)
 	_aes_ctr_crypt	0
-SYM_FUNC_END(aes_ctr64_crypt_vaes_avx10_512)
-SYM_TYPED_FUNC_START(aes_xctr_crypt_vaes_avx10_512)
+SYM_FUNC_END(aes_ctr64_crypt_vaes_avx512)
+SYM_TYPED_FUNC_START(aes_xctr_crypt_vaes_avx512)
 	_aes_ctr_crypt	1
-SYM_FUNC_END(aes_xctr_crypt_vaes_avx10_512)
+SYM_FUNC_END(aes_xctr_crypt_vaes_avx512)
 #endif // CONFIG_AS_VAES && CONFIG_AS_VPCLMULQDQ
diff --git a/arch/x86/crypto/aes-xts-avx-x86_64.S b/arch/x86/crypto/aes-xts-avx-x86_64.S
index 93ba0ddbe0092..cbe7a2e3dad4f 100644
--- a/arch/x86/crypto/aes-xts-avx-x86_64.S
+++ b/arch/x86/crypto/aes-xts-avx-x86_64.S
@@ -50,36 +50,29 @@
  * This file implements AES-XTS for modern x86_64 CPUs.  To handle the
  * complexities of coding for x86 SIMD, e.g. where every vector length needs
  * different code, it uses a macro to generate several implementations that
  * share similar source code but are targeted at different CPUs, listed below:
  *
- * AES-NI + AVX
+ * AES-NI && AVX
  *    - 128-bit vectors (1 AES block per vector)
  *    - VEX-coded instructions
  *    - xmm0-xmm15
  *    - This is for older CPUs that lack VAES but do have AVX.
  *
- * VAES + VPCLMULQDQ + AVX2
+ * VAES && VPCLMULQDQ && AVX2
  *    - 256-bit vectors (2 AES blocks per vector)
  *    - VEX-coded instructions
  *    - ymm0-ymm15
- *    - This is for CPUs that have VAES but lack AVX512 or AVX10,
- *      e.g. Intel's Alder Lake and AMD's Zen 3.
+ *    - This is for CPUs that have VAES but either lack AVX512 (e.g. Intel's
+ *      Alder Lake and AMD's Zen 3) or downclock too eagerly when using zmm
+ *      registers (e.g. Intel's Ice Lake).
  *
- * VAES + VPCLMULQDQ + AVX10/256 + BMI2
- *    - 256-bit vectors (2 AES blocks per vector)
+ * VAES && VPCLMULQDQ && AVX512BW && AVX512VL
+ *    - 512-bit vectors (4 AES blocks per vector)
  *    - EVEX-coded instructions
- *    - ymm0-ymm31
- *    - This is for CPUs that have AVX512 but where using zmm registers causes
- *      downclocking, and for CPUs that have AVX10/256 but not AVX10/512.
- *    - By "AVX10/256" we really mean (AVX512BW + AVX512VL) || AVX10/256.
- *      To avoid confusion with 512-bit, we just write AVX10/256.
- *
- * VAES + VPCLMULQDQ + AVX10/512 + BMI2
- *    - Same as the previous one, but upgrades to 512-bit vectors
- *      (4 AES blocks per vector) in zmm0-zmm31.
- *    - This is for CPUs that have good AVX512 or AVX10/512 support.
+ *    - zmm0-zmm31
+ *    - This is for CPUs that have good AVX512 support.
  *
  * This file doesn't have an implementation for AES-NI alone (without AVX), as
  * the lack of VEX would make all the assembly code different.
  *
  * When we use VAES, we also use VPCLMULQDQ to parallelize the computation of
@@ -107,11 +100,11 @@
 	// exists when there's a carry out of the low 64 bits of the tweak.
 	.quad	0x87, 1
 
 	// This table contains constants for vpshufb and vpblendvb, used to
 	// handle variable byte shifts and blending during ciphertext stealing
-	// on CPUs that don't support AVX10-style masking.
+	// on CPUs that don't support AVX512-style masking.
 .Lcts_permute_table:
 	.byte	0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
 	.byte	0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
 	.byte	0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07
 	.byte	0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f
@@ -136,11 +129,11 @@
 	// are available, that map to the xmm, ymm, or zmm registers according
 	// to the selected Vector Length (VL).
 .irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
 	_define_Vi	\i
 .endr
-.if USE_AVX10
+.if USE_AVX512
 .irp i, 16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
 	_define_Vi	\i
 .endr
 .endif
 
@@ -191,11 +184,11 @@
 	// AES-128, AES-192, and AES-256 use different numbers of round keys.
 	// To allow handling all three variants efficiently, we align the round
 	// keys to the *end* of this register range.  I.e., AES-128 uses
 	// KEY5-KEY14, AES-192 uses KEY3-KEY14, and AES-256 uses KEY1-KEY14.
 	// (All also use KEY0 for the XOR-only "round" at the beginning.)
-.if USE_AVX10
+.if USE_AVX512
 	.set	KEY1_XMM,	%xmm16
 	.set	KEY1,		V16
 	.set	KEY2_XMM,	%xmm17
 	.set	KEY2,		V17
 	.set	KEY3_XMM,	%xmm18
@@ -225,43 +218,41 @@
 .endif
 	// V30-V31 are currently unused.
 .endm
 
 // Move a vector between memory and a register.
-// The register operand must be in the first 16 vector registers.
 .macro	_vmovdqu	src, dst
 .if VL < 64
 	vmovdqu		\src, \dst
 .else
 	vmovdqu8	\src, \dst
 .endif
 .endm
 
 // Broadcast a 128-bit value into a vector.
 .macro	_vbroadcast128	src, dst
-.if VL == 16 && !USE_AVX10
+.if VL == 16
 	vmovdqu		\src, \dst
-.elseif VL == 32 && !USE_AVX10
+.elseif VL == 32
 	vbroadcasti128	\src, \dst
 .else
 	vbroadcasti32x4	\src, \dst
 .endif
 .endm
 
 // XOR two vectors together.
-// Any register operands must be in the first 16 vector registers.
 .macro	_vpxor	src1, src2, dst
 .if VL < 64
 	vpxor		\src1, \src2, \dst
 .else
 	vpxord		\src1, \src2, \dst
 .endif
 .endm
 
 // XOR three vectors together.
 .macro	_xor3	src1, src2, src3_and_dst
-.if USE_AVX10
+.if USE_AVX512
 	// vpternlogd with immediate 0x96 is a three-argument XOR.
 	vpternlogd	$0x96, \src1, \src2, \src3_and_dst
 .else
 	vpxor		\src1, \src3_and_dst, \src3_and_dst
 	vpxor		\src2, \src3_and_dst, \src3_and_dst
@@ -272,11 +263,11 @@
 // (by multiplying by the polynomial 'x') and write it to \dst.
 .macro	_next_tweak	src, tmp, dst
 	vpshufd		$0x13, \src, \tmp
 	vpaddq		\src, \src, \dst
 	vpsrad		$31, \tmp, \tmp
-.if USE_AVX10
+.if USE_AVX512
 	vpternlogd	$0x78, GF_POLY_XMM, \tmp, \dst
 .else
 	vpand		GF_POLY_XMM, \tmp, \tmp
 	vpxor		\tmp, \dst, \dst
 .endif
@@ -335,11 +326,11 @@
 	vpslldq		$8, V2, V2
 	vpslldq		$8, V4, V4
 	vpsllq		$1*VL/16, TWEAK0, TWEAK1
 	vpsllq		$2*VL/16, TWEAK0, TWEAK2
 	vpsllq		$3*VL/16, TWEAK0, TWEAK3
-.if USE_AVX10
+.if USE_AVX512
 	vpternlogd	$0x96, V0, V1, TWEAK1
 	vpternlogd	$0x96, V2, V3, TWEAK2
 	vpternlogd	$0x96, V4, V5, TWEAK3
 .else
 	vpxor		V0, TWEAK1, TWEAK1
@@ -472,30 +463,30 @@
 	// interleave the AES rounds with the XTS tweak computation, and (c) it
 	// seems unwise to rely *too* heavily on the CPU's branch predictor.
 	lea		OFFS-16(KEY, KEYLEN64, 4), KEY
 
 	// If all 32 SIMD registers are available, cache all the round keys.
-.if USE_AVX10
+.if USE_AVX512
 	cmp		$24, KEYLEN
 	jl		.Laes128\@
 	je		.Laes192\@
-	_vbroadcast128	-6*16(KEY), KEY1
-	_vbroadcast128	-5*16(KEY), KEY2
+	vbroadcasti32x4	-6*16(KEY), KEY1
+	vbroadcasti32x4	-5*16(KEY), KEY2
 .Laes192\@:
-	_vbroadcast128	-4*16(KEY), KEY3
-	_vbroadcast128	-3*16(KEY), KEY4
+	vbroadcasti32x4	-4*16(KEY), KEY3
+	vbroadcasti32x4	-3*16(KEY), KEY4
 .Laes128\@:
-	_vbroadcast128	-2*16(KEY), KEY5
-	_vbroadcast128	-1*16(KEY), KEY6
-	_vbroadcast128	0*16(KEY), KEY7
-	_vbroadcast128	1*16(KEY), KEY8
-	_vbroadcast128	2*16(KEY), KEY9
-	_vbroadcast128	3*16(KEY), KEY10
-	_vbroadcast128	4*16(KEY), KEY11
-	_vbroadcast128	5*16(KEY), KEY12
-	_vbroadcast128	6*16(KEY), KEY13
-	_vbroadcast128	7*16(KEY), KEY14
+	vbroadcasti32x4	-2*16(KEY), KEY5
+	vbroadcasti32x4	-1*16(KEY), KEY6
+	vbroadcasti32x4	0*16(KEY), KEY7
+	vbroadcasti32x4	1*16(KEY), KEY8
+	vbroadcasti32x4	2*16(KEY), KEY9
+	vbroadcasti32x4	3*16(KEY), KEY10
+	vbroadcasti32x4	4*16(KEY), KEY11
+	vbroadcasti32x4	5*16(KEY), KEY12
+	vbroadcasti32x4	6*16(KEY), KEY13
+	vbroadcasti32x4	7*16(KEY), KEY14
 .endif
 .endm
 
 // Do a single non-last round of AES encryption (if \enc==1) or decryption (if
 // \enc==0) on the block(s) in \data using the round key(s) in \key.  The
@@ -519,11 +510,11 @@
 
 // Do a single non-last round of AES en/decryption on the block(s) in \data,
 // using the same key for all block(s).  The round key is loaded from the
 // appropriate register or memory location for round \i.  May clobber \tmp.
 .macro _vaes_1x		enc, i, xmm_suffix, data, tmp
-.if USE_AVX10
+.if USE_AVX512
 	_vaes		\enc, KEY\i\xmm_suffix, \data
 .else
 .ifnb \xmm_suffix
 	_vaes		\enc, (\i-7)*16(KEY), \data
 .else
@@ -536,11 +527,11 @@
 // Do a single non-last round of AES en/decryption on the blocks in registers
 // V0-V3, using the same key for all blocks.  The round key is loaded from the
 // appropriate register or memory location for round \i.  In addition, does two
 // steps of the computation of the next set of tweaks.  May clobber V4 and V5.
 .macro	_vaes_4x	enc, i
-.if USE_AVX10
+.if USE_AVX512
 	_tweak_step	(2*(\i-5))
 	_vaes		\enc, KEY\i, V0
 	_vaes		\enc, KEY\i, V1
 	_tweak_step	(2*(\i-5) + 1)
 	_vaes		\enc, KEY\i, V2
@@ -572,11 +563,11 @@
 	_vaes_1x	\enc, 4, \xmm_suffix, \data, tmp=\tmp
 .Laes128\@:
 .irp i, 5,6,7,8,9,10,11,12,13
 	_vaes_1x	\enc, \i, \xmm_suffix, \data, tmp=\tmp
 .endr
-.if USE_AVX10
+.if USE_AVX512
 	vpxord		KEY14\xmm_suffix, \tweak, \tmp
 .else
 .ifnb \xmm_suffix
 	vpxor		7*16(KEY), \tweak, \tmp
 .else
@@ -615,15 +606,15 @@
 
 .Lmain_loop\@:
 	// This is the main loop, en/decrypting 4*VL bytes per iteration.
 
 	// XOR each source block with its tweak and the zero-th round key.
-.if USE_AVX10
-	_vmovdqu	0*VL(SRC), V0
-	_vmovdqu	1*VL(SRC), V1
-	_vmovdqu	2*VL(SRC), V2
-	_vmovdqu	3*VL(SRC), V3
+.if USE_AVX512
+	vmovdqu8	0*VL(SRC), V0
+	vmovdqu8	1*VL(SRC), V1
+	vmovdqu8	2*VL(SRC), V2
+	vmovdqu8	3*VL(SRC), V3
 	vpternlogd	$0x96, TWEAK0, KEY0, V0
 	vpternlogd	$0x96, TWEAK1, KEY0, V1
 	vpternlogd	$0x96, TWEAK2, KEY0, V2
 	vpternlogd	$0x96, TWEAK3, KEY0, V3
 .else
@@ -652,11 +643,11 @@
 .endr
 	// Do the last AES round, then XOR the results with the tweaks again.
 	// Reduce latency by doing the XOR before the vaesenclast, utilizing the
 	// property vaesenclast(key, a) ^ b == vaesenclast(key ^ b, a)
 	// (and likewise for vaesdeclast).
-.if USE_AVX10
+.if USE_AVX512
 	_tweak_step	18
 	_tweak_step	19
 	vpxord		TWEAK0, KEY14, V4
 	vpxord		TWEAK1, KEY14, V5
 	_vaeslast	\enc, V4, V0
@@ -760,11 +751,11 @@
 	_next_tweak	TWEAK0_XMM, %xmm0, TWEAK1_XMM
 	vmovdqu		(SRC), %xmm0
 	_aes_crypt	\enc, _XMM, TWEAK1_XMM, %xmm0, tmp=%xmm1
 .endif
 
-.if USE_AVX10
+.if USE_AVX512
 	// Create a mask that has the first LEN bits set.
 	mov		$-1, %r9d
 	bzhi		LEN, %r9d, %r9d
 	kmovd		%r9d, %k1
 
@@ -809,11 +800,11 @@
 
 // void aes_xts_encrypt_iv(const struct crypto_aes_ctx *tweak_key,
 //			   u8 iv[AES_BLOCK_SIZE]);
 //
 // Encrypt |iv| using the AES key |tweak_key| to get the first tweak.  Assumes
-// that the CPU supports AES-NI and AVX, but not necessarily VAES or AVX10.
+// that the CPU supports AES-NI and AVX, but not necessarily VAES or AVX512.
 SYM_TYPED_FUNC_START(aes_xts_encrypt_iv)
 	.set	TWEAK_KEY,	%rdi
 	.set	IV,		%rsi
 	.set	KEYLEN,		%eax
 	.set	KEYLEN64,	%rax
@@ -851,41 +842,32 @@ SYM_FUNC_END(aes_xts_encrypt_iv)
 // incremental computation, but |len| must always be >= 16 (AES_BLOCK_SIZE), and
 // |len| must be a multiple of 16 except on the last call.  If |len| is a
 // multiple of 16, then this function updates |tweak| to contain the next tweak.
 
 .set	VL, 16
-.set	USE_AVX10, 0
+.set	USE_AVX512, 0
 SYM_TYPED_FUNC_START(aes_xts_encrypt_aesni_avx)
 	_aes_xts_crypt	1
 SYM_FUNC_END(aes_xts_encrypt_aesni_avx)
 SYM_TYPED_FUNC_START(aes_xts_decrypt_aesni_avx)
 	_aes_xts_crypt	0
 SYM_FUNC_END(aes_xts_decrypt_aesni_avx)
 
 #if defined(CONFIG_AS_VAES) && defined(CONFIG_AS_VPCLMULQDQ)
 .set	VL, 32
-.set	USE_AVX10, 0
+.set	USE_AVX512, 0
 SYM_TYPED_FUNC_START(aes_xts_encrypt_vaes_avx2)
 	_aes_xts_crypt	1
 SYM_FUNC_END(aes_xts_encrypt_vaes_avx2)
 SYM_TYPED_FUNC_START(aes_xts_decrypt_vaes_avx2)
 	_aes_xts_crypt	0
 SYM_FUNC_END(aes_xts_decrypt_vaes_avx2)
 
-.set	VL, 32
-.set	USE_AVX10, 1
-SYM_TYPED_FUNC_START(aes_xts_encrypt_vaes_avx10_256)
-	_aes_xts_crypt	1
-SYM_FUNC_END(aes_xts_encrypt_vaes_avx10_256)
-SYM_TYPED_FUNC_START(aes_xts_decrypt_vaes_avx10_256)
-	_aes_xts_crypt	0
-SYM_FUNC_END(aes_xts_decrypt_vaes_avx10_256)
-
 .set	VL, 64
-.set	USE_AVX10, 1
-SYM_TYPED_FUNC_START(aes_xts_encrypt_vaes_avx10_512)
+.set	USE_AVX512, 1
+SYM_TYPED_FUNC_START(aes_xts_encrypt_vaes_avx512)
 	_aes_xts_crypt	1
-SYM_FUNC_END(aes_xts_encrypt_vaes_avx10_512)
-SYM_TYPED_FUNC_START(aes_xts_decrypt_vaes_avx10_512)
+SYM_FUNC_END(aes_xts_encrypt_vaes_avx512)
+SYM_TYPED_FUNC_START(aes_xts_decrypt_vaes_avx512)
 	_aes_xts_crypt	0
-SYM_FUNC_END(aes_xts_decrypt_vaes_avx10_512)
+SYM_FUNC_END(aes_xts_decrypt_vaes_avx512)
 #endif /* CONFIG_AS_VAES && CONFIG_AS_VPCLMULQDQ */
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index e141b7995304d..d9194863e412f 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -842,12 +842,11 @@ static struct simd_skcipher_alg *					       \
 simd_skcipher_algs_##suffix[ARRAY_SIZE(skcipher_algs_##suffix)]
 
 DEFINE_AVX_SKCIPHER_ALGS(aesni_avx, "aesni-avx", 500);
 #if defined(CONFIG_AS_VAES) && defined(CONFIG_AS_VPCLMULQDQ)
 DEFINE_AVX_SKCIPHER_ALGS(vaes_avx2, "vaes-avx2", 600);
-DEFINE_AVX_SKCIPHER_ALGS(vaes_avx10_256, "vaes-avx10_256", 700);
-DEFINE_AVX_SKCIPHER_ALGS(vaes_avx10_512, "vaes-avx10_512", 800);
+DEFINE_AVX_SKCIPHER_ALGS(vaes_avx512, "vaes-avx512", 800);
 #endif
 
 /* The common part of the x86_64 AES-GCM key struct */
 struct aes_gcm_key {
 	/* Expanded AES key and the AES key length in bytes */
@@ -1610,33 +1609,28 @@ static int __init register_avx_algs(void)
 	    !boot_cpu_has(X86_FEATURE_BMI2) ||
 	    !cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM |
 			       XFEATURE_MASK_AVX512, NULL))
 		return 0;
 
-	err = simd_register_skciphers_compat(skcipher_algs_vaes_avx10_256,
-					     ARRAY_SIZE(skcipher_algs_vaes_avx10_256),
-					     simd_skcipher_algs_vaes_avx10_256);
-	if (err)
-		return err;
 	err = simd_register_aeads_compat(aes_gcm_algs_vaes_avx10_256,
 					 ARRAY_SIZE(aes_gcm_algs_vaes_avx10_256),
 					 aes_gcm_simdalgs_vaes_avx10_256);
 	if (err)
 		return err;
 
 	if (x86_match_cpu(zmm_exclusion_list)) {
 		int i;
 
-		for (i = 0; i < ARRAY_SIZE(skcipher_algs_vaes_avx10_512); i++)
-			skcipher_algs_vaes_avx10_512[i].base.cra_priority = 1;
+		for (i = 0; i < ARRAY_SIZE(skcipher_algs_vaes_avx512); i++)
+			skcipher_algs_vaes_avx512[i].base.cra_priority = 1;
 		for (i = 0; i < ARRAY_SIZE(aes_gcm_algs_vaes_avx10_512); i++)
 			aes_gcm_algs_vaes_avx10_512[i].base.cra_priority = 1;
 	}
 
-	err = simd_register_skciphers_compat(skcipher_algs_vaes_avx10_512,
-					     ARRAY_SIZE(skcipher_algs_vaes_avx10_512),
-					     simd_skcipher_algs_vaes_avx10_512);
+	err = simd_register_skciphers_compat(skcipher_algs_vaes_avx512,
+					     ARRAY_SIZE(skcipher_algs_vaes_avx512),
+					     simd_skcipher_algs_vaes_avx512);
 	if (err)
 		return err;
 	err = simd_register_aeads_compat(aes_gcm_algs_vaes_avx10_512,
 					 ARRAY_SIZE(aes_gcm_algs_vaes_avx10_512),
 					 aes_gcm_simdalgs_vaes_avx10_512);
@@ -1659,22 +1653,18 @@ static void unregister_avx_algs(void)
 #if defined(CONFIG_AS_VAES) && defined(CONFIG_AS_VPCLMULQDQ)
 	if (simd_skcipher_algs_vaes_avx2[0])
 		simd_unregister_skciphers(skcipher_algs_vaes_avx2,
 					  ARRAY_SIZE(skcipher_algs_vaes_avx2),
 					  simd_skcipher_algs_vaes_avx2);
-	if (simd_skcipher_algs_vaes_avx10_256[0])
-		simd_unregister_skciphers(skcipher_algs_vaes_avx10_256,
-					  ARRAY_SIZE(skcipher_algs_vaes_avx10_256),
-					  simd_skcipher_algs_vaes_avx10_256);
 	if (aes_gcm_simdalgs_vaes_avx10_256[0])
 		simd_unregister_aeads(aes_gcm_algs_vaes_avx10_256,
 				      ARRAY_SIZE(aes_gcm_algs_vaes_avx10_256),
 				      aes_gcm_simdalgs_vaes_avx10_256);
-	if (simd_skcipher_algs_vaes_avx10_512[0])
-		simd_unregister_skciphers(skcipher_algs_vaes_avx10_512,
-					  ARRAY_SIZE(skcipher_algs_vaes_avx10_512),
-					  simd_skcipher_algs_vaes_avx10_512);
+	if (simd_skcipher_algs_vaes_avx512[0])
+		simd_unregister_skciphers(skcipher_algs_vaes_avx512,
+					  ARRAY_SIZE(skcipher_algs_vaes_avx512),
+					  simd_skcipher_algs_vaes_avx512);
 	if (aes_gcm_simdalgs_vaes_avx10_512[0])
 		simd_unregister_aeads(aes_gcm_algs_vaes_avx10_512,
 				      ARRAY_SIZE(aes_gcm_algs_vaes_avx10_512),
 				      aes_gcm_simdalgs_vaes_avx10_512);
 #endif

base-commit: d2d072a313c1817a0d72d7b8301eaf29ce7f83fc
-- 
2.49.0

