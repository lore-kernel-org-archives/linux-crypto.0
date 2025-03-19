Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3EB61DF747;
	Wed, 19 Mar 2025 18:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742408124; cv=none; b=TLgz3FOFvzm+SdT5e4K3BoNTCBUNtBEfFvRwjfjh99pAJy4fA7qhfL/1qOp6RduQrmtMGTsDwwGnGJSRSrzJVY2k9hJRPBazs1pY8Wd5AlP3F75anbRyBwUUmg++sqy41GMryD7OiMVFw+ODhr3kaFxxeN8mB4pV631McJx9pbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742408124; c=relaxed/simple;
	bh=ZXilbN9jDvTOzafQDbp86jN9E8Evbp+LsnGKHYrnZYE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bR5LkSEkycYoHaxls8z365ctf6KBDh+hYquikPiyqj8ld8rDUwu89TvJptjKQmt2wY6CxQWh9UV8MaNulJh/GrQAy050APCmy/EJMKa8smHz8w7sQelzs8Utak9QaKR9CulNQ8Puxdt/zlfHaAzhZAy6MLW/1+90gLJBnlM8L7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=as0gSA2+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="as0gSA2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE1AC4CEE4;
	Wed, 19 Mar 2025 18:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742408124;
	bh=ZXilbN9jDvTOzafQDbp86jN9E8Evbp+LsnGKHYrnZYE=;
	h=From:To:Cc:Subject:Date:From;
	b=as0gSA2+0o0P9fMeL2uL4nbe3iz+MsO67DrZk/MwOoJ8IU09bZD7eIwzHKGE0ZUCX
	 L5Xe0RfH26Nk5+Gqxha9VgzavlSXw2w36U454VepwwmvI/wq1/r24JqF1X0MVe8t9r
	 nwSCIx3IYWXhxKRH4FCKc5ZwI2RHrJz44I+PAGZz3INiwH+e8nEZGcx42VJZvCDZ2O
	 peDnTaVDjkNWTQtRsyOCVEIiAk5tQeHtz3bNl0T+o1Dx5B48pXRj3UWBdui/cKNOA/
	 +uSaBKKaGkY89MemEb1H+T37uGXDoW5FuBz7RHSheaQs1hBNmPwqjfPcBeAtxL5EVo
	 43Wu928PbKgYQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	x86@kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86/crc: drop the avx10_256 functions and rename avx10_512 to avx512
Date: Wed, 19 Mar 2025 11:13:16 -0700
Message-ID: <20250319181316.91271-1-ebiggers@kernel.org>
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
is to avoid downclocking on older Intel CPUs.  But I already wrote
*_avx2 code too (primarily to support CPUs without AVX512), which
performs almost as well as *_avx10_256.  So we should just use that.

Therefore, remove the *_avx10_256 functions, and rename the *_avx10_512
functions to *_avx512.  Make Ice Lake and Tiger Lake use the *_avx2
functions instead of *_avx10_256 which they previously used.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/lib/crc-pclmul-template.S | 23 ++++++++---------------
 arch/x86/lib/crc-pclmul-template.h | 15 +++++----------
 2 files changed, 13 insertions(+), 25 deletions(-)

diff --git a/arch/x86/lib/crc-pclmul-template.S b/arch/x86/lib/crc-pclmul-template.S
index a19b730b642d3..ae0b6144c503c 100644
--- a/arch/x86/lib/crc-pclmul-template.S
+++ b/arch/x86/lib/crc-pclmul-template.S
@@ -136,11 +136,11 @@
 // is a vector register containing the needed fold constants, and \tmp is a
 // temporary vector register.  All arguments must be the same length.
 .macro	_fold_vec	acc, data, consts, tmp
 	_pclmulqdq	\consts, HI64_TERMS, \acc, HI64_TERMS, \tmp
 	_pclmulqdq	\consts, LO64_TERMS, \acc, LO64_TERMS, \acc
-.if AVX_LEVEL < 10
+.if AVX_LEVEL <= 2
 	_cond_vex pxor,	\data, \tmp, \tmp
 	_cond_vex pxor,	\tmp, \acc, \acc
 .else
 	vpternlogq	$0x96, \data, \tmp, \acc
 .endif
@@ -199,23 +199,20 @@
 // bit0 to x^0, bit1 to x^1, bit7 to x^7.
 //
 // \vl is the maximum length of vector register to use in bytes: 16, 32, or 64.
 //
 // \avx_level is the level of AVX support to use: 0 for SSE only, 2 for AVX2, or
-// 10 for AVX10 or AVX512.
+// 512 for AVX512.
 //
 // If \vl == 16 && \avx_level == 0, the generated code requires:
 // PCLMULQDQ && SSE4.1.  (Note: all known CPUs with PCLMULQDQ also have SSE4.1.)
 //
 // If \vl == 32 && \avx_level == 2, the generated code requires:
 // VPCLMULQDQ && AVX2.
 //
-// If \vl == 32 && \avx_level == 10, the generated code requires:
-// VPCLMULQDQ && (AVX10/256 || (AVX512BW && AVX512VL))
-//
-// If \vl == 64 && \avx_level == 10, the generated code requires:
-// VPCLMULQDQ && (AVX10/512 || (AVX512BW && AVX512VL))
+// If \vl == 64 && \avx_level == 512, the generated code requires:
+// VPCLMULQDQ && AVX512BW && AVX512VL.
 //
 // Other \vl and \avx_level combinations are either not supported or not useful.
 .macro	_crc_pclmul	n, lsb_crc, vl, avx_level
 	.set	LSB_CRC,	\lsb_crc
 	.set	VL,		\vl
@@ -532,11 +529,11 @@
 	// floor(t0 / G).  The most efficient way to do that is to move it to
 	// the physically high qword and use a ternlog to combine the two XORs.
 .if LSB_CRC && \n == 64
 	_cond_vex punpcklqdq,	%xmm1, %xmm2, %xmm2
 	_pclmulqdq		CONSTS_XMM, LO64_TERMS, %xmm1, HI64_TERMS, %xmm1
-    .if AVX_LEVEL < 10
+    .if AVX_LEVEL <= 2
 	_cond_vex pxor,		%xmm2, %xmm0, %xmm0
 	_cond_vex pxor,		%xmm1, %xmm0, %xmm0
     .else
 	vpternlogq		$0x96, %xmm2, %xmm1, %xmm0
     .endif
@@ -572,17 +569,13 @@ SYM_FUNC_END(prefix##_pclmul_sse);					\
 									\
 SYM_FUNC_START(prefix##_vpclmul_avx2);					\
 	_crc_pclmul	n=bits, lsb_crc=lsb, vl=32, avx_level=2;	\
 SYM_FUNC_END(prefix##_vpclmul_avx2);					\
 									\
-SYM_FUNC_START(prefix##_vpclmul_avx10_256);				\
-	_crc_pclmul	n=bits, lsb_crc=lsb, vl=32, avx_level=10;	\
-SYM_FUNC_END(prefix##_vpclmul_avx10_256);				\
-									\
-SYM_FUNC_START(prefix##_vpclmul_avx10_512);				\
-	_crc_pclmul	n=bits, lsb_crc=lsb, vl=64, avx_level=10;	\
-SYM_FUNC_END(prefix##_vpclmul_avx10_512);
+SYM_FUNC_START(prefix##_vpclmul_avx512);				\
+	_crc_pclmul	n=bits, lsb_crc=lsb, vl=64, avx_level=512;	\
+SYM_FUNC_END(prefix##_vpclmul_avx512);
 #else
 #define DEFINE_CRC_PCLMUL_FUNCS(prefix, bits, lsb)			\
 SYM_FUNC_START(prefix##_pclmul_sse);					\
 	_crc_pclmul	n=bits, lsb_crc=lsb, vl=16, avx_level=0;	\
 SYM_FUNC_END(prefix##_pclmul_sse);
diff --git a/arch/x86/lib/crc-pclmul-template.h b/arch/x86/lib/crc-pclmul-template.h
index 7b89f0edbc179..c5b3bfe11d8da 100644
--- a/arch/x86/lib/crc-pclmul-template.h
+++ b/arch/x86/lib/crc-pclmul-template.h
@@ -19,31 +19,26 @@
 #define DECLARE_CRC_PCLMUL_FUNCS(prefix, crc_t)				\
 crc_t prefix##_pclmul_sse(crc_t crc, const u8 *p, size_t len,		\
 			  const void *consts_ptr);			\
 crc_t prefix##_vpclmul_avx2(crc_t crc, const u8 *p, size_t len,		\
 			    const void *consts_ptr);			\
-crc_t prefix##_vpclmul_avx10_256(crc_t crc, const u8 *p, size_t len,	\
-				 const void *consts_ptr);		\
-crc_t prefix##_vpclmul_avx10_512(crc_t crc, const u8 *p, size_t len,	\
-				 const void *consts_ptr);		\
+crc_t prefix##_vpclmul_avx512(crc_t crc, const u8 *p, size_t len,	\
+			      const void *consts_ptr);			\
 DEFINE_STATIC_CALL(prefix##_pclmul, prefix##_pclmul_sse)
 
 #define INIT_CRC_PCLMUL(prefix)						\
 do {									\
 	if (IS_ENABLED(CONFIG_AS_VPCLMULQDQ) &&				\
 	    boot_cpu_has(X86_FEATURE_VPCLMULQDQ) &&			\
 	    boot_cpu_has(X86_FEATURE_AVX2) &&				\
 	    cpu_has_xfeatures(XFEATURE_MASK_YMM, NULL)) {		\
 		if (boot_cpu_has(X86_FEATURE_AVX512BW) &&		\
 		    boot_cpu_has(X86_FEATURE_AVX512VL) &&		\
+		    !boot_cpu_has(X86_FEATURE_PREFER_YMM) &&		\
 		    cpu_has_xfeatures(XFEATURE_MASK_AVX512, NULL)) {	\
-			if (boot_cpu_has(X86_FEATURE_PREFER_YMM))	\
-				static_call_update(prefix##_pclmul,	\
-						   prefix##_vpclmul_avx10_256); \
-			else						\
-				static_call_update(prefix##_pclmul,	\
-						   prefix##_vpclmul_avx10_512); \
+			static_call_update(prefix##_pclmul,		\
+					   prefix##_vpclmul_avx512);	\
 		} else {						\
 			static_call_update(prefix##_pclmul,		\
 					   prefix##_vpclmul_avx2);	\
 		}							\
 	}								\

base-commit: 981b39dc6da6dd11ec40824a224c1e0a7557b5ca
-- 
2.49.0

