Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F046222584;
	Sat, 19 Jul 2025 22:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752965456; cv=none; b=ugIyD49KjWauVewefE3SN+O3zElA8ecEVdme+CeyEP15SaHrF+IJwAtLOzvs/lBO/3wNart7CAambxALLgH+WGxy/RIppY/CU7lm5j0lOcYCd1p6QtO4LTe+RiNqq+TMjcTzcqbFyHSAMWRxsUBgfw2xGIDF/skOR53DuotdTO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752965456; c=relaxed/simple;
	bh=T851OTAn3mzzOHSJds25QvPE5eqSng/9Bgm4W+cG/0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jYzdMngq8B5bHo2fVtHwULjo00whMYMn7GtODwSm5yqXlsalzD9ZoarS5gUWqZl1D5GkmOoNRJ+4eE7+IlvkkDykXlwpxrHrPSqoZE6aHOl5pdt6JIMS6YYgO2psFqTd+Q6ZONBfA53hDbMo4NHyyTqSSeqSW7C84MlRVrrhMG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uFOi5JzO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uFOi5JzO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D37D9C4CEF4;
	Sat, 19 Jul 2025 22:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752965456;
	bh=T851OTAn3mzzOHSJds25QvPE5eqSng/9Bgm4W+cG/0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uFOi5JzOiVJvQoUxd+zvRHPAfCHNDSyzwnpmzv6JRF4dZqQdsAV+Ve+KcDMvqp+92
	 dVc66S+h7FyITlApngI+BOmp9Y7AjEt/LNOv05VzHrv/4h7Yzw48T7ZxctWKJb7aPb
	 oER/XTrqsxwkZfkm9S4DXd0u370V0fgLQ4CrZ2bI7HLqO72dKqNysD/cBfCyl/h8cm
	 UWvlaeqSYd7ZDFkKXQ7axiF5XpMO6DgjSe7Jz2wHLYRRhFY8UpSRJhgURcavKy1/PR
	 ZK3WQUTr72bls5hjwrqflUgExvhEEIA3gWP1RylDfsxIg2YkhL170GYl0Q6Y+3ron2
	 BCAhfJLYALTjA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 1/2] lib/crc: x86: Reorganize crc-pclmul static_call initialization
Date: Sat, 19 Jul 2025 15:49:37 -0700
Message-ID: <20250719224938.126512-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250719224938.126512-1-ebiggers@kernel.org>
References: <20250719224938.126512-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reorganize the crc-pclmul static_call initialization to place more of
the logic in the *_mod_init_arch() functions instead of in the
INIT_CRC_PCLMUL macro.  This provides the flexibility to do more than a
single static_call update for each CPU feature check.  Right away,
optimize crc64_mod_init_arch() to check the CPU features just once
instead of twice, doing both the crc64_lsb and crc64_msb static_call
updates together.  A later commit will also use this to initialize an
additional static_key when crc32_lsb_vpclmul_avx512() is enabled.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crc/x86/crc-pclmul-template.h | 31 ++++++++++++++-----------------
 lib/crc/x86/crc-t10dif.h          |  9 ++++++++-
 lib/crc/x86/crc32.h               | 10 +++++++++-
 lib/crc/x86/crc64.h               | 15 +++++++++++++--
 4 files changed, 44 insertions(+), 21 deletions(-)

diff --git a/lib/crc/x86/crc-pclmul-template.h b/lib/crc/x86/crc-pclmul-template.h
index 51cba520a7dbd..35c950d7010c2 100644
--- a/lib/crc/x86/crc-pclmul-template.h
+++ b/lib/crc/x86/crc-pclmul-template.h
@@ -23,27 +23,24 @@ crc_t prefix##_vpclmul_avx2(crc_t crc, const u8 *p, size_t len,		\
 			    const void *consts_ptr);			\
 crc_t prefix##_vpclmul_avx512(crc_t crc, const u8 *p, size_t len,	\
 			      const void *consts_ptr);			\
 DEFINE_STATIC_CALL(prefix##_pclmul, prefix##_pclmul_sse)
 
-#define INIT_CRC_PCLMUL(prefix)						\
-do {									\
-	if (boot_cpu_has(X86_FEATURE_VPCLMULQDQ) &&			\
-	    boot_cpu_has(X86_FEATURE_AVX2) &&				\
-	    cpu_has_xfeatures(XFEATURE_MASK_YMM, NULL)) {		\
-		if (boot_cpu_has(X86_FEATURE_AVX512BW) &&		\
-		    boot_cpu_has(X86_FEATURE_AVX512VL) &&		\
-		    !boot_cpu_has(X86_FEATURE_PREFER_YMM) &&		\
-		    cpu_has_xfeatures(XFEATURE_MASK_AVX512, NULL)) {	\
-			static_call_update(prefix##_pclmul,		\
-					   prefix##_vpclmul_avx512);	\
-		} else {						\
-			static_call_update(prefix##_pclmul,		\
-					   prefix##_vpclmul_avx2);	\
-		}							\
-	}								\
-} while (0)
+static inline bool have_vpclmul(void)
+{
+	return boot_cpu_has(X86_FEATURE_VPCLMULQDQ) &&
+	       boot_cpu_has(X86_FEATURE_AVX2) &&
+	       cpu_has_xfeatures(XFEATURE_MASK_YMM, NULL);
+}
+
+static inline bool have_avx512(void)
+{
+	return boot_cpu_has(X86_FEATURE_AVX512BW) &&
+	       boot_cpu_has(X86_FEATURE_AVX512VL) &&
+	       !boot_cpu_has(X86_FEATURE_PREFER_YMM) &&
+	       cpu_has_xfeatures(XFEATURE_MASK_AVX512, NULL);
+}
 
 /*
  * Call a [V]PCLMULQDQ optimized CRC function if the data length is at least 16
  * bytes, the CPU has PCLMULQDQ support, and the current context may use SIMD.
  *
diff --git a/lib/crc/x86/crc-t10dif.h b/lib/crc/x86/crc-t10dif.h
index eb1f23db4daa1..2a02a3026f3f8 100644
--- a/lib/crc/x86/crc-t10dif.h
+++ b/lib/crc/x86/crc-t10dif.h
@@ -21,8 +21,15 @@ static inline u16 crc_t10dif_arch(u16 crc, const u8 *p, size_t len)
 #define crc_t10dif_mod_init_arch crc_t10dif_mod_init_arch
 static inline void crc_t10dif_mod_init_arch(void)
 {
 	if (boot_cpu_has(X86_FEATURE_PCLMULQDQ)) {
 		static_branch_enable(&have_pclmulqdq);
-		INIT_CRC_PCLMUL(crc16_msb);
+		if (have_vpclmul()) {
+			if (have_avx512())
+				static_call_update(crc16_msb_pclmul,
+						   crc16_msb_vpclmul_avx512);
+			else
+				static_call_update(crc16_msb_pclmul,
+						   crc16_msb_vpclmul_avx2);
+		}
 	}
 }
diff --git a/lib/crc/x86/crc32.h b/lib/crc/x86/crc32.h
index 28451d5769c3a..ba4dacf23340c 100644
--- a/lib/crc/x86/crc32.h
+++ b/lib/crc/x86/crc32.h
@@ -75,11 +75,19 @@ static inline void crc32_mod_init_arch(void)
 {
 	if (boot_cpu_has(X86_FEATURE_XMM4_2))
 		static_branch_enable(&have_crc32);
 	if (boot_cpu_has(X86_FEATURE_PCLMULQDQ)) {
 		static_branch_enable(&have_pclmulqdq);
-		INIT_CRC_PCLMUL(crc32_lsb);
+		if (have_vpclmul()) {
+			if (have_avx512()) {
+				static_call_update(crc32_lsb_pclmul,
+						   crc32_lsb_vpclmul_avx512);
+			} else {
+				static_call_update(crc32_lsb_pclmul,
+						   crc32_lsb_vpclmul_avx2);
+			}
+		}
 	}
 }
 
 static inline u32 crc32_optimizations_arch(void)
 {
diff --git a/lib/crc/x86/crc64.h b/lib/crc/x86/crc64.h
index 54aca3a9475c9..aea64409e4193 100644
--- a/lib/crc/x86/crc64.h
+++ b/lib/crc/x86/crc64.h
@@ -29,9 +29,20 @@ static inline u64 crc64_nvme_arch(u64 crc, const u8 *p, size_t len)
 #define crc64_mod_init_arch crc64_mod_init_arch
 static inline void crc64_mod_init_arch(void)
 {
 	if (boot_cpu_has(X86_FEATURE_PCLMULQDQ)) {
 		static_branch_enable(&have_pclmulqdq);
-		INIT_CRC_PCLMUL(crc64_msb);
-		INIT_CRC_PCLMUL(crc64_lsb);
+		if (have_vpclmul()) {
+			if (have_avx512()) {
+				static_call_update(crc64_lsb_pclmul,
+						   crc64_lsb_vpclmul_avx512);
+				static_call_update(crc64_msb_pclmul,
+						   crc64_msb_vpclmul_avx512);
+			} else {
+				static_call_update(crc64_lsb_pclmul,
+						   crc64_lsb_vpclmul_avx2);
+				static_call_update(crc64_msb_pclmul,
+						   crc64_msb_vpclmul_avx2);
+			}
+		}
 	}
 }

base-commit: 9b0236f4efb889869f7d4f3f084f508cc0433ec9
-- 
2.50.1

