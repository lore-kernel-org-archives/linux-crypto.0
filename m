Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90CE3288522;
	Thu,  2 Oct 2025 02:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759372446; cv=none; b=j0S5WfjWZ0z4MZpP973D50i6WsvyBjTRG5N+xqqTwp/xSZQ+wXVXRQi6Qq0hlvllHeEhHZyUVs/g6WAyY35h84yzwXMPhXLYxIkUS9qWh1lcLLADTG4gZTATI6/Lp+FGO95I6LlnUjNVRzp7iQeijlefgPyPFSEUBGdR5bmGZLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759372446; c=relaxed/simple;
	bh=XiD6uXMpoCOpbhOfCAVT/OxAxQSyBiklfdDgcjARBC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GuN9AYuQm9EwqSkgqYfZiVi/HlKmXAQELkOqhHVUISIQwv7TBIkScLYimAQZtzPT8l+siGY3Ay5p9NBT5YGXSxlkPRSjPtNsSSPKMWiAsDI4WTbFBzvgz2niSYY8rTUL4RraKQY7p+FE7q//A7K56sTTDduq6OF+yXWhF8IpNpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jFZkB3H1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jFZkB3H1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2FB5C4CEFC;
	Thu,  2 Oct 2025 02:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759372446;
	bh=XiD6uXMpoCOpbhOfCAVT/OxAxQSyBiklfdDgcjARBC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jFZkB3H1Io8LxRHQBQpqZaEO1Nz9VMCeMMmpwDRy+t6NSVJazRnQCKVhrKIIRDAN/
	 JoBnBFYZGfSErDCREK3sQhJJ8ajN5Wuhr0mjBixkMOJDK3yQxSa/6IbBPL7m7KNA6a
	 F6Y2DsNAAvNMKM6W61QpsaMKo92jUYYZ2JtNVJEjqMOmZnP0/B2gl5fLRaqkUL+DSh
	 FfAe0e5SYeTVZodV0ev58pyTaYUbRBockdlb7+kpSuA2fjRvRogSe4OLBe7dvTZFfD
	 gcM03Y8xBWwd9mbsERWsdZMRKMcskYKIAaJgd05PAjRCHiL5iDbJ9qX2wksc4qyuRK
	 EQ4tsmRvObBZA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 3/8] crypto: x86/aes-gcm - rename avx10 and avx10_512 to avx512
Date: Wed,  1 Oct 2025 19:31:12 -0700
Message-ID: <20251002023117.37504-4-ebiggers@kernel.org>
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

With the "avx10_256" code removed and the AVX10 specification having
been changed to basically just be a re-packaged AVX512, the "avx10_512"
name no longer makes sense.  Replace it with "avx512".

While doing this, also add the "vaes_" prefix in places that didn't
already have it.  The result is that the two VAES optimized
implementations are consistently called vaes_avx2 and vaes_avx512.
(Also drop the "-x86_64" part of the assembly filename, to keep it from
getting too long.  There's no 32-bit version of this code, and the fact
that it's 64-bit is unremarkable; it's the norm for new code.)

Note: although aes_gcm_aad_update_vaes_avx512() (previously called
aes_gcm_aad_update_vaes_avx10()) uses at most 256-bit vectors, it still
depends on the AVX512 CPU feature.  So its new name is still accurate.
Also, a later commit will make it sometimes use 512-bit vectors anyway.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/x86/crypto/Makefile                      |   4 +-
 arch/x86/crypto/aes-gcm-aesni-x86_64.S        |  12 +-
 arch/x86/crypto/aes-gcm-vaes-avx2.S           |  12 +-
 ...m-avx10-x86_64.S => aes-gcm-vaes-avx512.S} |  92 +++++--------
 arch/x86/crypto/aesni-intel_glue.c            | 123 +++++++++---------
 5 files changed, 105 insertions(+), 138 deletions(-)
 rename arch/x86/crypto/{aes-gcm-avx10-x86_64.S => aes-gcm-vaes-avx512.S} (92%)

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index f6f7b2b8b853e..6409e3009524c 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -45,12 +45,12 @@ aegis128-aesni-y := aegis128-aesni-asm.o aegis128-aesni-glue.o
 obj-$(CONFIG_CRYPTO_AES_NI_INTEL) += aesni-intel.o
 aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o
 aesni-intel-$(CONFIG_64BIT) += aes-ctr-avx-x86_64.o \
 			       aes-gcm-aesni-x86_64.o \
 			       aes-gcm-vaes-avx2.o \
-			       aes-xts-avx-x86_64.o \
-			       aes-gcm-avx10-x86_64.o
+			       aes-gcm-vaes-avx512.o \
+			       aes-xts-avx-x86_64.o
 
 obj-$(CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL) += ghash-clmulni-intel.o
 ghash-clmulni-intel-y := ghash-clmulni-intel_asm.o ghash-clmulni-intel_glue.o
 
 obj-$(CONFIG_CRYPTO_POLYVAL_CLMUL_NI) += polyval-clmulni.o
diff --git a/arch/x86/crypto/aes-gcm-aesni-x86_64.S b/arch/x86/crypto/aes-gcm-aesni-x86_64.S
index 45940e2883a0f..7c8a8a32bd3c6 100644
--- a/arch/x86/crypto/aes-gcm-aesni-x86_64.S
+++ b/arch/x86/crypto/aes-gcm-aesni-x86_64.S
@@ -59,19 +59,19 @@
 //
 // The specific CPU feature prerequisites are AES-NI and PCLMULQDQ, plus SSE4.1
 // for the *_aesni functions or AVX for the *_aesni_avx ones.  (But it seems
 // there are no CPUs that support AES-NI without also PCLMULQDQ and SSE4.1.)
 //
-// The design generally follows that of aes-gcm-avx10-x86_64.S, and that file is
+// The design generally follows that of aes-gcm-vaes-avx512.S, and that file is
 // more thoroughly commented.  This file has the following notable changes:
 //
 //    - The vector length is fixed at 128-bit, i.e. xmm registers.  This means
 //      there is only one AES block (and GHASH block) per register.
 //
-//    - Without AVX512 / AVX10, only 16 SIMD registers are available instead of
-//      32.  We work around this by being much more careful about using
-//      registers, relying heavily on loads to load values as they are needed.
+//    - Without AVX512, only 16 SIMD registers are available instead of 32.  We
+//      work around this by being much more careful about using registers,
+//      relying heavily on loads to load values as they are needed.
 //
 //    - Masking is not available either.  We work around this by implementing
 //      partial block loads and stores using overlapping scalar loads and stores
 //      combined with shifts and SSE4.1 insertion and extraction instructions.
 //
@@ -88,12 +88,12 @@
 //
 //    - We implement the GHASH multiplications in the main loop using Karatsuba
 //      multiplication instead of schoolbook multiplication.  This saves one
 //      pclmulqdq instruction per block, at the cost of one 64-bit load, one
 //      pshufd, and 0.25 pxors per block.  (This is without the three-argument
-//      XOR support that would be provided by AVX512 / AVX10, which would be
-//      more beneficial to schoolbook than Karatsuba.)
+//      XOR support that would be provided by AVX512, which would be more
+//      beneficial to schoolbook than Karatsuba.)
 //
 //      As a rough approximation, we can assume that Karatsuba multiplication is
 //      faster than schoolbook multiplication in this context if one pshufd and
 //      0.25 pxors are cheaper than a pclmulqdq.  (We assume that the 64-bit
 //      load is "free" due to running in parallel with arithmetic instructions.)
diff --git a/arch/x86/crypto/aes-gcm-vaes-avx2.S b/arch/x86/crypto/aes-gcm-vaes-avx2.S
index e628dbb33c0e7..5ccbd85383cdd 100644
--- a/arch/x86/crypto/aes-gcm-vaes-avx2.S
+++ b/arch/x86/crypto/aes-gcm-vaes-avx2.S
@@ -47,16 +47,16 @@
 // ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 // POSSIBILITY OF SUCH DAMAGE.
 //
 // -----------------------------------------------------------------------------
 //
-// This is similar to aes-gcm-avx10-x86_64.S, but it uses AVX2 instead of
-// AVX512.  This means it can only use 16 vector registers instead of 32, the
-// maximum vector length is 32 bytes, and some instructions such as vpternlogd
-// and masked loads/stores are unavailable.  However, it is able to run on CPUs
-// that have VAES without AVX512, namely AMD Zen 3 (including "Milan" server
-// CPUs), various Intel client CPUs such as Alder Lake, and Intel Sierra Forest.
+// This is similar to aes-gcm-vaes-avx512.S, but it uses AVX2 instead of AVX512.
+// This means it can only use 16 vector registers instead of 32, the maximum
+// vector length is 32 bytes, and some instructions such as vpternlogd and
+// masked loads/stores are unavailable.  However, it is able to run on CPUs that
+// have VAES without AVX512, namely AMD Zen 3 (including "Milan" server CPUs),
+// various Intel client CPUs such as Alder Lake, and Intel Sierra Forest.
 //
 // This implementation also uses Karatsuba multiplication instead of schoolbook
 // multiplication for GHASH in its main loop.  This does not help much on Intel,
 // but it improves performance by ~5% on AMD Zen 3.  Other factors weighing
 // slightly in favor of Karatsuba multiplication in this implementation are the
diff --git a/arch/x86/crypto/aes-gcm-avx10-x86_64.S b/arch/x86/crypto/aes-gcm-vaes-avx512.S
similarity index 92%
rename from arch/x86/crypto/aes-gcm-avx10-x86_64.S
rename to arch/x86/crypto/aes-gcm-vaes-avx512.S
index 4fb04506d7932..be5c14d33acc7 100644
--- a/arch/x86/crypto/aes-gcm-avx10-x86_64.S
+++ b/arch/x86/crypto/aes-gcm-vaes-avx512.S
@@ -1,8 +1,9 @@
 /* SPDX-License-Identifier: Apache-2.0 OR BSD-2-Clause */
 //
-// VAES and VPCLMULQDQ optimized AES-GCM for x86_64
+// AES-GCM implementation for x86_64 CPUs that support the following CPU
+// features: VAES && VPCLMULQDQ && AVX512BW && AVX512VL && BMI2
 //
 // Copyright 2024 Google LLC
 //
 // Author: Eric Biggers <ebiggers@google.com>
 //
@@ -43,45 +44,10 @@
 // SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 // INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 // CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 // ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 // POSSIBILITY OF SUCH DAMAGE.
-//
-//------------------------------------------------------------------------------
-//
-// This file implements AES-GCM (Galois/Counter Mode) for x86_64 CPUs that
-// support VAES (vector AES), VPCLMULQDQ (vector carryless multiplication), and
-// either AVX512 or AVX10.  Some of the functions, notably the encryption and
-// decryption update functions which are the most performance-critical, are
-// provided in two variants generated from a macro: one using 256-bit vectors
-// (suffix: vaes_avx10_256) and one using 512-bit vectors (vaes_avx10_512).  The
-// other, "shared" functions (vaes_avx10) use at most 256-bit vectors.
-//
-// The functions that use 512-bit vectors are intended for CPUs that support
-// 512-bit vectors *and* where using them doesn't cause significant
-// downclocking.  They require the following CPU features:
-//
-//	VAES && VPCLMULQDQ && BMI2 && ((AVX512BW && AVX512VL) || AVX10/512)
-//
-// The other functions require the following CPU features:
-//
-//	VAES && VPCLMULQDQ && BMI2 && ((AVX512BW && AVX512VL) || AVX10/256)
-//
-// All functions use the "System V" ABI.  The Windows ABI is not supported.
-//
-// Note that we use "avx10" in the names of the functions as a shorthand to
-// really mean "AVX10 or a certain set of AVX512 features".  Due to Intel's
-// introduction of AVX512 and then its replacement by AVX10, there doesn't seem
-// to be a simple way to name things that makes sense on all CPUs.
-//
-// Note that the macros that support both 256-bit and 512-bit vectors could
-// fairly easily be changed to support 128-bit too.  However, this would *not*
-// be sufficient to allow the code to run on CPUs without AVX512 or AVX10,
-// because the code heavily uses several features of these extensions other than
-// the vector length: the increase in the number of SIMD registers from 16 to
-// 32, masking support, and new instructions such as vpternlogd (which can do a
-// three-argument XOR).  These features are very useful for AES-GCM.
 
 #include <linux/linkage.h>
 
 .section .rodata
 .p2align 6
@@ -310,11 +276,11 @@
 	vpclmulqdq	$0x01, \mi, \gfpoly, \t0
 	vpshufd		$0x4e, \mi, \mi
 	vpternlogd	$0x96, \t0, \mi, \hi
 .endm
 
-// void aes_gcm_precompute_##suffix(struct aes_gcm_key_avx10 *key);
+// void aes_gcm_precompute_vaes_avx512(struct aes_gcm_key_vaes_avx512 *key);
 //
 // Given the expanded AES key |key->aes_key|, this function derives the GHASH
 // subkey and initializes |key->ghash_key_powers| with powers of it.
 //
 // The number of key powers initialized is NUM_H_POWERS, and they are stored in
@@ -586,13 +552,13 @@
 	vmovdqu8	GHASHDATA1, 1*VL(DST)
 	vmovdqu8	GHASHDATA2, 2*VL(DST)
 	vmovdqu8	GHASHDATA3, 3*VL(DST)
 .endm
 
-// void aes_gcm_{enc,dec}_update_##suffix(const struct aes_gcm_key_avx10 *key,
-//					  const u32 le_ctr[4], u8 ghash_acc[16],
-//					  const u8 *src, u8 *dst, int datalen);
+// void aes_gcm_{enc,dec}_update_vaes_avx512(const struct aes_gcm_key_vaes_avx512 *key,
+//					     const u32 le_ctr[4], u8 ghash_acc[16],
+//					     const u8 *src, u8 *dst, int datalen);
 //
 // This macro generates a GCM encryption or decryption update function with the
 // above prototype (with \enc selecting which one).  This macro supports both
 // VL=32 and VL=64.  _set_veclen must have been invoked with the desired length.
 //
@@ -942,18 +908,18 @@
 
 	vzeroupper	// This is needed after using ymm or zmm registers.
 	RET
 .endm
 
-// void aes_gcm_enc_final_vaes_avx10(const struct aes_gcm_key_avx10 *key,
-//				     const u32 le_ctr[4], u8 ghash_acc[16],
-//				     u64 total_aadlen, u64 total_datalen);
-// bool aes_gcm_dec_final_vaes_avx10(const struct aes_gcm_key_avx10 *key,
-//				     const u32 le_ctr[4],
-//				     const u8 ghash_acc[16],
-//				     u64 total_aadlen, u64 total_datalen,
-//				     const u8 tag[16], int taglen);
+// void aes_gcm_enc_final_vaes_avx512(const struct aes_gcm_key_vaes_avx512 *key,
+//				      const u32 le_ctr[4], u8 ghash_acc[16],
+//				      u64 total_aadlen, u64 total_datalen);
+// bool aes_gcm_dec_final_vaes_avx512(const struct aes_gcm_key_vaes_avx512 *key,
+//				      const u32 le_ctr[4],
+//				      const u8 ghash_acc[16],
+//				      u64 total_aadlen, u64 total_datalen,
+//				      const u8 tag[16], int taglen);
 //
 // This macro generates one of the above two functions (with \enc selecting
 // which one).  Both functions finish computing the GCM authentication tag by
 // updating GHASH with the lengths block and encrypting the GHASH accumulator.
 // |total_aadlen| and |total_datalen| must be the total length of the additional
@@ -1080,23 +1046,23 @@
 	// No need for vzeroupper here, since only used xmm registers were used.
 	RET
 .endm
 
 _set_veclen 64
-SYM_FUNC_START(aes_gcm_precompute_vaes_avx10_512)
+SYM_FUNC_START(aes_gcm_precompute_vaes_avx512)
 	_aes_gcm_precompute
-SYM_FUNC_END(aes_gcm_precompute_vaes_avx10_512)
-SYM_FUNC_START(aes_gcm_enc_update_vaes_avx10_512)
+SYM_FUNC_END(aes_gcm_precompute_vaes_avx512)
+SYM_FUNC_START(aes_gcm_enc_update_vaes_avx512)
 	_aes_gcm_update	1
-SYM_FUNC_END(aes_gcm_enc_update_vaes_avx10_512)
-SYM_FUNC_START(aes_gcm_dec_update_vaes_avx10_512)
+SYM_FUNC_END(aes_gcm_enc_update_vaes_avx512)
+SYM_FUNC_START(aes_gcm_dec_update_vaes_avx512)
 	_aes_gcm_update	0
-SYM_FUNC_END(aes_gcm_dec_update_vaes_avx10_512)
+SYM_FUNC_END(aes_gcm_dec_update_vaes_avx512)
 
-// void aes_gcm_aad_update_vaes_avx10(const struct aes_gcm_key_avx10 *key,
-//				      u8 ghash_acc[16],
-//				      const u8 *aad, int aadlen);
+// void aes_gcm_aad_update_vaes_avx512(const struct aes_gcm_key_vaes_avx512 *key,
+//				       u8 ghash_acc[16],
+//				       const u8 *aad, int aadlen);
 //
 // This function processes the AAD (Additional Authenticated Data) in GCM.
 // Using the key |key|, it updates the GHASH accumulator |ghash_acc| with the
 // data given by |aad| and |aadlen|.  |key->ghash_key_powers| must have been
 // initialized.  On the first call, |ghash_acc| must be all zeroes.  |aadlen|
@@ -1108,11 +1074,11 @@ SYM_FUNC_END(aes_gcm_dec_update_vaes_avx10_512)
 // which uses 256-bit vectors (ymm registers) and only has a 1x-wide loop.  This
 // keeps the code size down, and it enables some micro-optimizations, e.g. using
 // VEX-coded instructions instead of EVEX-coded to save some instruction bytes.
 // To optimize for large amounts of AAD, we could implement a 4x-wide loop and
 // provide a version using 512-bit vectors, but that doesn't seem to be useful.
-SYM_FUNC_START(aes_gcm_aad_update_vaes_avx10)
+SYM_FUNC_START(aes_gcm_aad_update_vaes_avx512)
 
 	// Function arguments
 	.set	KEY,		%rdi
 	.set	GHASH_ACC_PTR,	%rsi
 	.set	AAD,		%rdx
@@ -1176,13 +1142,13 @@ SYM_FUNC_START(aes_gcm_aad_update_vaes_avx10)
 	// Store the updated GHASH accumulator back to memory.
 	vmovdqu		GHASH_ACC_XMM, (GHASH_ACC_PTR)
 
 	vzeroupper	// This is needed after using ymm or zmm registers.
 	RET
-SYM_FUNC_END(aes_gcm_aad_update_vaes_avx10)
+SYM_FUNC_END(aes_gcm_aad_update_vaes_avx512)
 
-SYM_FUNC_START(aes_gcm_enc_final_vaes_avx10)
+SYM_FUNC_START(aes_gcm_enc_final_vaes_avx512)
 	_aes_gcm_final	1
-SYM_FUNC_END(aes_gcm_enc_final_vaes_avx10)
-SYM_FUNC_START(aes_gcm_dec_final_vaes_avx10)
+SYM_FUNC_END(aes_gcm_enc_final_vaes_avx512)
+SYM_FUNC_START(aes_gcm_dec_final_vaes_avx512)
 	_aes_gcm_final	0
-SYM_FUNC_END(aes_gcm_dec_final_vaes_avx10)
+SYM_FUNC_END(aes_gcm_dec_final_vaes_avx512)
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 1ed8513208d36..bb6e2c47ffc61 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -902,12 +902,12 @@ struct aes_gcm_key_vaes_avx2 {
 #define AES_GCM_KEY_VAES_AVX2(key) \
 	container_of((key), struct aes_gcm_key_vaes_avx2, base)
 #define AES_GCM_KEY_VAES_AVX2_SIZE \
 	(sizeof(struct aes_gcm_key_vaes_avx2) + (31 & ~(CRYPTO_MINALIGN - 1)))
 
-/* Key struct used by the VAES + AVX10 implementations of AES-GCM */
-struct aes_gcm_key_avx10 {
+/* Key struct used by the VAES + AVX512 implementation of AES-GCM */
+struct aes_gcm_key_vaes_avx512 {
 	/*
 	 * Common part of the key.  The assembly code prefers 16-byte alignment
 	 * for the round keys; we get this by them being located at the start of
 	 * the struct and the whole struct being 64-byte aligned.
 	 */
@@ -923,14 +923,14 @@ struct aes_gcm_key_avx10 {
 	u64 h_powers[16][2] __aligned(64);
 
 	/* Three padding blocks required by the assembly code */
 	u64 padding[3][2];
 };
-#define AES_GCM_KEY_AVX10(key)	\
-	container_of((key), struct aes_gcm_key_avx10, base)
-#define AES_GCM_KEY_AVX10_SIZE	\
-	(sizeof(struct aes_gcm_key_avx10) + (63 & ~(CRYPTO_MINALIGN - 1)))
+#define AES_GCM_KEY_VAES_AVX512(key) \
+	container_of((key), struct aes_gcm_key_vaes_avx512, base)
+#define AES_GCM_KEY_VAES_AVX512_SIZE \
+	(sizeof(struct aes_gcm_key_vaes_avx512) + (63 & ~(CRYPTO_MINALIGN - 1)))
 
 /*
  * These flags are passed to the AES-GCM helper functions to specify the
  * specific version of AES-GCM (RFC4106 or not), whether it's encryption or
  * decryption, and which assembly functions should be called.  Assembly
@@ -939,16 +939,16 @@ struct aes_gcm_key_avx10 {
  */
 #define FLAG_RFC4106	BIT(0)
 #define FLAG_ENC	BIT(1)
 #define FLAG_AVX	BIT(2)
 #define FLAG_VAES_AVX2	BIT(3)
-#define FLAG_AVX10_512	BIT(4)
+#define FLAG_VAES_AVX512 BIT(4)
 
 static inline struct aes_gcm_key *
 aes_gcm_key_get(struct crypto_aead *tfm, int flags)
 {
-	if (flags & FLAG_AVX10_512)
+	if (flags & FLAG_VAES_AVX512)
 		return PTR_ALIGN(crypto_aead_ctx(tfm), 64);
 	else if (flags & FLAG_VAES_AVX2)
 		return PTR_ALIGN(crypto_aead_ctx(tfm), 32);
 	else
 		return PTR_ALIGN(crypto_aead_ctx(tfm), 16);
@@ -959,16 +959,16 @@ aes_gcm_precompute_aesni(struct aes_gcm_key_aesni *key);
 asmlinkage void
 aes_gcm_precompute_aesni_avx(struct aes_gcm_key_aesni *key);
 asmlinkage void
 aes_gcm_precompute_vaes_avx2(struct aes_gcm_key_vaes_avx2 *key);
 asmlinkage void
-aes_gcm_precompute_vaes_avx10_512(struct aes_gcm_key_avx10 *key);
+aes_gcm_precompute_vaes_avx512(struct aes_gcm_key_vaes_avx512 *key);
 
 static void aes_gcm_precompute(struct aes_gcm_key *key, int flags)
 {
-	if (flags & FLAG_AVX10_512)
-		aes_gcm_precompute_vaes_avx10_512(AES_GCM_KEY_AVX10(key));
+	if (flags & FLAG_VAES_AVX512)
+		aes_gcm_precompute_vaes_avx512(AES_GCM_KEY_VAES_AVX512(key));
 	else if (flags & FLAG_VAES_AVX2)
 		aes_gcm_precompute_vaes_avx2(AES_GCM_KEY_VAES_AVX2(key));
 	else if (flags & FLAG_AVX)
 		aes_gcm_precompute_aesni_avx(AES_GCM_KEY_AESNI(key));
 	else
@@ -983,19 +983,19 @@ aes_gcm_aad_update_aesni_avx(const struct aes_gcm_key_aesni *key,
 			     u8 ghash_acc[16], const u8 *aad, int aadlen);
 asmlinkage void
 aes_gcm_aad_update_vaes_avx2(const struct aes_gcm_key_vaes_avx2 *key,
 			     u8 ghash_acc[16], const u8 *aad, int aadlen);
 asmlinkage void
-aes_gcm_aad_update_vaes_avx10(const struct aes_gcm_key_avx10 *key,
-			      u8 ghash_acc[16], const u8 *aad, int aadlen);
+aes_gcm_aad_update_vaes_avx512(const struct aes_gcm_key_vaes_avx512 *key,
+			       u8 ghash_acc[16], const u8 *aad, int aadlen);
 
 static void aes_gcm_aad_update(const struct aes_gcm_key *key, u8 ghash_acc[16],
 			       const u8 *aad, int aadlen, int flags)
 {
-	if (flags & FLAG_AVX10_512)
-		aes_gcm_aad_update_vaes_avx10(AES_GCM_KEY_AVX10(key), ghash_acc,
-					      aad, aadlen);
+	if (flags & FLAG_VAES_AVX512)
+		aes_gcm_aad_update_vaes_avx512(AES_GCM_KEY_VAES_AVX512(key),
+					       ghash_acc, aad, aadlen);
 	else if (flags & FLAG_VAES_AVX2)
 		aes_gcm_aad_update_vaes_avx2(AES_GCM_KEY_VAES_AVX2(key),
 					     ghash_acc, aad, aadlen);
 	else if (flags & FLAG_AVX)
 		aes_gcm_aad_update_aesni_avx(AES_GCM_KEY_AESNI(key), ghash_acc,
@@ -1016,13 +1016,13 @@ aes_gcm_enc_update_aesni_avx(const struct aes_gcm_key_aesni *key,
 asmlinkage void
 aes_gcm_enc_update_vaes_avx2(const struct aes_gcm_key_vaes_avx2 *key,
 			     const u32 le_ctr[4], u8 ghash_acc[16],
 			     const u8 *src, u8 *dst, int datalen);
 asmlinkage void
-aes_gcm_enc_update_vaes_avx10_512(const struct aes_gcm_key_avx10 *key,
-				  const u32 le_ctr[4], u8 ghash_acc[16],
-				  const u8 *src, u8 *dst, int datalen);
+aes_gcm_enc_update_vaes_avx512(const struct aes_gcm_key_vaes_avx512 *key,
+			       const u32 le_ctr[4], u8 ghash_acc[16],
+			       const u8 *src, u8 *dst, int datalen);
 
 asmlinkage void
 aes_gcm_dec_update_aesni(const struct aes_gcm_key_aesni *key,
 			 const u32 le_ctr[4], u8 ghash_acc[16],
 			 const u8 *src, u8 *dst, int datalen);
@@ -1033,25 +1033,25 @@ aes_gcm_dec_update_aesni_avx(const struct aes_gcm_key_aesni *key,
 asmlinkage void
 aes_gcm_dec_update_vaes_avx2(const struct aes_gcm_key_vaes_avx2 *key,
 			     const u32 le_ctr[4], u8 ghash_acc[16],
 			     const u8 *src, u8 *dst, int datalen);
 asmlinkage void
-aes_gcm_dec_update_vaes_avx10_512(const struct aes_gcm_key_avx10 *key,
-				  const u32 le_ctr[4], u8 ghash_acc[16],
-				  const u8 *src, u8 *dst, int datalen);
+aes_gcm_dec_update_vaes_avx512(const struct aes_gcm_key_vaes_avx512 *key,
+			       const u32 le_ctr[4], u8 ghash_acc[16],
+			       const u8 *src, u8 *dst, int datalen);
 
 /* __always_inline to optimize out the branches based on @flags */
 static __always_inline void
 aes_gcm_update(const struct aes_gcm_key *key,
 	       const u32 le_ctr[4], u8 ghash_acc[16],
 	       const u8 *src, u8 *dst, int datalen, int flags)
 {
 	if (flags & FLAG_ENC) {
-		if (flags & FLAG_AVX10_512)
-			aes_gcm_enc_update_vaes_avx10_512(AES_GCM_KEY_AVX10(key),
-							  le_ctr, ghash_acc,
-							  src, dst, datalen);
+		if (flags & FLAG_VAES_AVX512)
+			aes_gcm_enc_update_vaes_avx512(AES_GCM_KEY_VAES_AVX512(key),
+						       le_ctr, ghash_acc,
+						       src, dst, datalen);
 		else if (flags & FLAG_VAES_AVX2)
 			aes_gcm_enc_update_vaes_avx2(AES_GCM_KEY_VAES_AVX2(key),
 						     le_ctr, ghash_acc,
 						     src, dst, datalen);
 		else if (flags & FLAG_AVX)
@@ -1060,14 +1060,14 @@ aes_gcm_update(const struct aes_gcm_key *key,
 						     src, dst, datalen);
 		else
 			aes_gcm_enc_update_aesni(AES_GCM_KEY_AESNI(key), le_ctr,
 						 ghash_acc, src, dst, datalen);
 	} else {
-		if (flags & FLAG_AVX10_512)
-			aes_gcm_dec_update_vaes_avx10_512(AES_GCM_KEY_AVX10(key),
-							  le_ctr, ghash_acc,
-							  src, dst, datalen);
+		if (flags & FLAG_VAES_AVX512)
+			aes_gcm_dec_update_vaes_avx512(AES_GCM_KEY_VAES_AVX512(key),
+						       le_ctr, ghash_acc,
+						       src, dst, datalen);
 		else if (flags & FLAG_VAES_AVX2)
 			aes_gcm_dec_update_vaes_avx2(AES_GCM_KEY_VAES_AVX2(key),
 						     le_ctr, ghash_acc,
 						     src, dst, datalen);
 		else if (flags & FLAG_AVX)
@@ -1092,24 +1092,24 @@ aes_gcm_enc_final_aesni_avx(const struct aes_gcm_key_aesni *key,
 asmlinkage void
 aes_gcm_enc_final_vaes_avx2(const struct aes_gcm_key_vaes_avx2 *key,
 			    const u32 le_ctr[4], u8 ghash_acc[16],
 			    u64 total_aadlen, u64 total_datalen);
 asmlinkage void
-aes_gcm_enc_final_vaes_avx10(const struct aes_gcm_key_avx10 *key,
-			     const u32 le_ctr[4], u8 ghash_acc[16],
-			     u64 total_aadlen, u64 total_datalen);
+aes_gcm_enc_final_vaes_avx512(const struct aes_gcm_key_vaes_avx512 *key,
+			      const u32 le_ctr[4], u8 ghash_acc[16],
+			      u64 total_aadlen, u64 total_datalen);
 
 /* __always_inline to optimize out the branches based on @flags */
 static __always_inline void
 aes_gcm_enc_final(const struct aes_gcm_key *key,
 		  const u32 le_ctr[4], u8 ghash_acc[16],
 		  u64 total_aadlen, u64 total_datalen, int flags)
 {
-	if (flags & FLAG_AVX10_512)
-		aes_gcm_enc_final_vaes_avx10(AES_GCM_KEY_AVX10(key),
-					     le_ctr, ghash_acc,
-					     total_aadlen, total_datalen);
+	if (flags & FLAG_VAES_AVX512)
+		aes_gcm_enc_final_vaes_avx512(AES_GCM_KEY_VAES_AVX512(key),
+					      le_ctr, ghash_acc,
+					      total_aadlen, total_datalen);
 	else if (flags & FLAG_VAES_AVX2)
 		aes_gcm_enc_final_vaes_avx2(AES_GCM_KEY_VAES_AVX2(key),
 					    le_ctr, ghash_acc,
 					    total_aadlen, total_datalen);
 	else if (flags & FLAG_AVX)
@@ -1136,26 +1136,26 @@ asmlinkage bool __must_check
 aes_gcm_dec_final_vaes_avx2(const struct aes_gcm_key_vaes_avx2 *key,
 			    const u32 le_ctr[4], const u8 ghash_acc[16],
 			    u64 total_aadlen, u64 total_datalen,
 			    const u8 tag[16], int taglen);
 asmlinkage bool __must_check
-aes_gcm_dec_final_vaes_avx10(const struct aes_gcm_key_avx10 *key,
-			     const u32 le_ctr[4], const u8 ghash_acc[16],
-			     u64 total_aadlen, u64 total_datalen,
-			     const u8 tag[16], int taglen);
+aes_gcm_dec_final_vaes_avx512(const struct aes_gcm_key_vaes_avx512 *key,
+			      const u32 le_ctr[4], const u8 ghash_acc[16],
+			      u64 total_aadlen, u64 total_datalen,
+			      const u8 tag[16], int taglen);
 
 /* __always_inline to optimize out the branches based on @flags */
 static __always_inline bool __must_check
 aes_gcm_dec_final(const struct aes_gcm_key *key, const u32 le_ctr[4],
 		  u8 ghash_acc[16], u64 total_aadlen, u64 total_datalen,
 		  u8 tag[16], int taglen, int flags)
 {
-	if (flags & FLAG_AVX10_512)
-		return aes_gcm_dec_final_vaes_avx10(AES_GCM_KEY_AVX10(key),
-						    le_ctr, ghash_acc,
-						    total_aadlen, total_datalen,
-						    tag, taglen);
+	if (flags & FLAG_VAES_AVX512)
+		return aes_gcm_dec_final_vaes_avx512(AES_GCM_KEY_VAES_AVX512(key),
+						     le_ctr, ghash_acc,
+						     total_aadlen, total_datalen,
+						     tag, taglen);
 	else if (flags & FLAG_VAES_AVX2)
 		return aes_gcm_dec_final_vaes_avx2(AES_GCM_KEY_VAES_AVX2(key),
 						   le_ctr, ghash_acc,
 						   total_aadlen, total_datalen,
 						   tag, taglen);
@@ -1243,14 +1243,14 @@ static int gcm_setkey(struct crypto_aead *tfm, const u8 *raw_key,
 	BUILD_BUG_ON(offsetof(struct aes_gcm_key_aesni, h_times_x64) != 688);
 	BUILD_BUG_ON(offsetof(struct aes_gcm_key_vaes_avx2, base.aes_key.key_enc) != 0);
 	BUILD_BUG_ON(offsetof(struct aes_gcm_key_vaes_avx2, base.aes_key.key_length) != 480);
 	BUILD_BUG_ON(offsetof(struct aes_gcm_key_vaes_avx2, h_powers) != 512);
 	BUILD_BUG_ON(offsetof(struct aes_gcm_key_vaes_avx2, h_powers_xored) != 640);
-	BUILD_BUG_ON(offsetof(struct aes_gcm_key_avx10, base.aes_key.key_enc) != 0);
-	BUILD_BUG_ON(offsetof(struct aes_gcm_key_avx10, base.aes_key.key_length) != 480);
-	BUILD_BUG_ON(offsetof(struct aes_gcm_key_avx10, h_powers) != 512);
-	BUILD_BUG_ON(offsetof(struct aes_gcm_key_avx10, padding) != 768);
+	BUILD_BUG_ON(offsetof(struct aes_gcm_key_vaes_avx512, base.aes_key.key_enc) != 0);
+	BUILD_BUG_ON(offsetof(struct aes_gcm_key_vaes_avx512, base.aes_key.key_length) != 480);
+	BUILD_BUG_ON(offsetof(struct aes_gcm_key_vaes_avx512, h_powers) != 512);
+	BUILD_BUG_ON(offsetof(struct aes_gcm_key_vaes_avx512, padding) != 768);
 
 	if (likely(crypto_simd_usable())) {
 		err = aes_check_keylen(keylen);
 		if (err)
 			return err;
@@ -1279,12 +1279,13 @@ static int gcm_setkey(struct crypto_aead *tfm, const u8 *raw_key,
 		/* Compute H^1 * x^-1 */
 		h = h1;
 		gf128mul_lle(&h, (const be128 *)x_to_the_minus1);
 
 		/* Compute the needed key powers */
-		if (flags & FLAG_AVX10_512) {
-			struct aes_gcm_key_avx10 *k = AES_GCM_KEY_AVX10(key);
+		if (flags & FLAG_VAES_AVX512) {
+			struct aes_gcm_key_vaes_avx512 *k =
+				AES_GCM_KEY_VAES_AVX512(key);
 
 			for (i = ARRAY_SIZE(k->h_powers) - 1; i >= 0; i--) {
 				k->h_powers[i][0] = be64_to_cpu(h.b);
 				k->h_powers[i][1] = be64_to_cpu(h.a);
 				gf128mul_lle(&h, &h1);
@@ -1577,14 +1578,14 @@ DEFINE_GCM_ALGS(aesni_avx, FLAG_AVX,
 /* aes_gcm_algs_vaes_avx2 */
 DEFINE_GCM_ALGS(vaes_avx2, FLAG_VAES_AVX2,
 		"generic-gcm-vaes-avx2", "rfc4106-gcm-vaes-avx2",
 		AES_GCM_KEY_VAES_AVX2_SIZE, 600);
 
-/* aes_gcm_algs_vaes_avx10_512 */
-DEFINE_GCM_ALGS(vaes_avx10_512, FLAG_AVX10_512,
-		"generic-gcm-vaes-avx10_512", "rfc4106-gcm-vaes-avx10_512",
-		AES_GCM_KEY_AVX10_SIZE, 800);
+/* aes_gcm_algs_vaes_avx512 */
+DEFINE_GCM_ALGS(vaes_avx512, FLAG_VAES_AVX512,
+		"generic-gcm-vaes-avx512", "rfc4106-gcm-vaes-avx512",
+		AES_GCM_KEY_VAES_AVX512_SIZE, 800);
 
 static int __init register_avx_algs(void)
 {
 	int err;
 
@@ -1629,20 +1630,20 @@ static int __init register_avx_algs(void)
 	if (boot_cpu_has(X86_FEATURE_PREFER_YMM)) {
 		int i;
 
 		for (i = 0; i < ARRAY_SIZE(skcipher_algs_vaes_avx512); i++)
 			skcipher_algs_vaes_avx512[i].base.cra_priority = 1;
-		for (i = 0; i < ARRAY_SIZE(aes_gcm_algs_vaes_avx10_512); i++)
-			aes_gcm_algs_vaes_avx10_512[i].base.cra_priority = 1;
+		for (i = 0; i < ARRAY_SIZE(aes_gcm_algs_vaes_avx512); i++)
+			aes_gcm_algs_vaes_avx512[i].base.cra_priority = 1;
 	}
 
 	err = crypto_register_skciphers(skcipher_algs_vaes_avx512,
 					ARRAY_SIZE(skcipher_algs_vaes_avx512));
 	if (err)
 		return err;
-	err = crypto_register_aeads(aes_gcm_algs_vaes_avx10_512,
-				    ARRAY_SIZE(aes_gcm_algs_vaes_avx10_512));
+	err = crypto_register_aeads(aes_gcm_algs_vaes_avx512,
+				    ARRAY_SIZE(aes_gcm_algs_vaes_avx512));
 	if (err)
 		return err;
 
 	return 0;
 }
@@ -1659,11 +1660,11 @@ static void unregister_avx_algs(void)
 	unregister_skciphers(skcipher_algs_aesni_avx);
 	unregister_aeads(aes_gcm_algs_aesni_avx);
 	unregister_skciphers(skcipher_algs_vaes_avx2);
 	unregister_skciphers(skcipher_algs_vaes_avx512);
 	unregister_aeads(aes_gcm_algs_vaes_avx2);
-	unregister_aeads(aes_gcm_algs_vaes_avx10_512);
+	unregister_aeads(aes_gcm_algs_vaes_avx512);
 }
 #else /* CONFIG_X86_64 */
 static struct aead_alg aes_gcm_algs_aesni[0];
 
 static int __init register_avx_algs(void)
-- 
2.51.0

