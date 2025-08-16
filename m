Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9DAF510;
	Sat, 16 Aug 2025 02:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755309837; cv=none; b=SBCIR2bOIbr+9DIEn7fyQwc+mEOJakQd+SnnsppElKGRVU9i6cAegTB6ukedHNdpyL0Vf0LwtyUFmLS7Vl1dXQr9tovclpkGv634rkD8OfTNqJ3vunWPzxuhBBoecmMk7yZovoxWsiue/YCpzlBU/YIaOF1VL7rU7R8dSBMHl4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755309837; c=relaxed/simple;
	bh=L6lWjJJwc8bgffBLWg+hBeCxJ55dx52UWhoZMWTF6As=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c3Ogb1PgWK5Q36sEPCbw4a7IgjGlC0AAFcCYhmZLAAdJ9K3HSgtpX2hXoixYDzaY7+9StLBrXyt8XZH09B2X5NRgyxFa3S3g7JHS61w5U77ts7shNIyj1XhKiyKs69iDPJEYqXBOfL7mt7fmuQxxFj+dJxCym0BIyMIx7wgEWTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EA4rCL85; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EA4rCL85"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 424C8C4CEEB;
	Sat, 16 Aug 2025 02:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755309837;
	bh=L6lWjJJwc8bgffBLWg+hBeCxJ55dx52UWhoZMWTF6As=;
	h=From:To:Cc:Subject:Date:From;
	b=EA4rCL85+GcNH5CbgS5zzGjAqRZex4ARzqUCwA5e/y4oqx1VMXvLz+5ZnColTkQd7
	 8lQAfHMLJilXxjnhHuSu3C2O5OWN4vO9hm2hKcvTUcCa6d/N2tt34lg8yh8AIIUc0H
	 GSD2hLaKwfL+XKtRR0uWSPnNLwmaWdl/rQD023CdOqfTv3DAXyYuQ+8yQtc7Vhtc2j
	 ii+SfD/zQFikSkWYoxdeVFBePYXueLdZuSFNBAwwpRJAYyT7KV7d9N/nlzENbpSU24
	 sGoBjQFhcJT5Wc7/+kfvNZGwS2O93p6kmfDZ0NkTTgrI6bt+X9brenuomK5c0yB01J
	 2RDHmxUgwHGfw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crc: Drop inline from all *_mod_init_arch() functions
Date: Fri, 15 Aug 2025 19:02:40 -0700
Message-ID: <20250816020240.431545-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Drop 'inline' from all the *_mod_init_arch() functions so that the
compiler will warn about any bugs where they are unused due to not being
wired up properly.  (There are no such bugs currently, so this just
establishes a more robust convention for the future.  Of course, these
functions also tend to get inlined anyway, regardless of the keyword.)

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crc/arm/crc-t10dif.h     | 2 +-
 lib/crc/arm/crc32.h          | 2 +-
 lib/crc/arm64/crc-t10dif.h   | 2 +-
 lib/crc/loongarch/crc32.h    | 2 +-
 lib/crc/mips/crc32.h         | 2 +-
 lib/crc/powerpc/crc-t10dif.h | 2 +-
 lib/crc/powerpc/crc32.h      | 2 +-
 lib/crc/sparc/crc32.h        | 2 +-
 lib/crc/x86/crc-t10dif.h     | 2 +-
 lib/crc/x86/crc32.h          | 2 +-
 lib/crc/x86/crc64.h          | 2 +-
 11 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/lib/crc/arm/crc-t10dif.h b/lib/crc/arm/crc-t10dif.h
index 2edf7e9681d05..9644a6e268162 100644
--- a/lib/crc/arm/crc-t10dif.h
+++ b/lib/crc/arm/crc-t10dif.h
@@ -43,11 +43,11 @@ static inline u16 crc_t10dif_arch(u16 crc, const u8 *data, size_t length)
 	}
 	return crc_t10dif_generic(crc, data, length);
 }
 
 #define crc_t10dif_mod_init_arch crc_t10dif_mod_init_arch
-static inline void crc_t10dif_mod_init_arch(void)
+static void crc_t10dif_mod_init_arch(void)
 {
 	if (elf_hwcap & HWCAP_NEON) {
 		static_branch_enable(&have_neon);
 		if (elf_hwcap2 & HWCAP2_PMULL)
 			static_branch_enable(&have_pmull);
diff --git a/lib/crc/arm/crc32.h b/lib/crc/arm/crc32.h
index 018007e162a2b..30afa79531e0f 100644
--- a/lib/crc/arm/crc32.h
+++ b/lib/crc/arm/crc32.h
@@ -83,11 +83,11 @@ static inline u32 crc32c_arch(u32 crc, const u8 *p, size_t len)
 }
 
 #define crc32_be_arch crc32_be_base /* not implemented on this arch */
 
 #define crc32_mod_init_arch crc32_mod_init_arch
-static inline void crc32_mod_init_arch(void)
+static void crc32_mod_init_arch(void)
 {
 	if (elf_hwcap2 & HWCAP2_CRC32)
 		static_branch_enable(&have_crc32);
 	if (elf_hwcap2 & HWCAP2_PMULL)
 		static_branch_enable(&have_pmull);
diff --git a/lib/crc/arm64/crc-t10dif.h b/lib/crc/arm64/crc-t10dif.h
index c4521a7f1ee9b..96d6514f1de9f 100644
--- a/lib/crc/arm64/crc-t10dif.h
+++ b/lib/crc/arm64/crc-t10dif.h
@@ -45,11 +45,11 @@ static inline u16 crc_t10dif_arch(u16 crc, const u8 *data, size_t length)
 	}
 	return crc_t10dif_generic(crc, data, length);
 }
 
 #define crc_t10dif_mod_init_arch crc_t10dif_mod_init_arch
-static inline void crc_t10dif_mod_init_arch(void)
+static void crc_t10dif_mod_init_arch(void)
 {
 	if (cpu_have_named_feature(ASIMD)) {
 		static_branch_enable(&have_asimd);
 		if (cpu_have_named_feature(PMULL))
 			static_branch_enable(&have_pmull);
diff --git a/lib/crc/loongarch/crc32.h b/lib/crc/loongarch/crc32.h
index 6de5c96594afc..d34fa4c686325 100644
--- a/lib/crc/loongarch/crc32.h
+++ b/lib/crc/loongarch/crc32.h
@@ -99,11 +99,11 @@ static inline u32 crc32c_arch(u32 crc, const u8 *p, size_t len)
 }
 
 #define crc32_be_arch crc32_be_base /* not implemented on this arch */
 
 #define crc32_mod_init_arch crc32_mod_init_arch
-static inline void crc32_mod_init_arch(void)
+static void crc32_mod_init_arch(void)
 {
 	if (cpu_has_crc32)
 		static_branch_enable(&have_crc32);
 }
 
diff --git a/lib/crc/mips/crc32.h b/lib/crc/mips/crc32.h
index 11cb272c63a69..3100354a049eb 100644
--- a/lib/crc/mips/crc32.h
+++ b/lib/crc/mips/crc32.h
@@ -146,11 +146,11 @@ static inline u32 crc32c_arch(u32 crc, const u8 *p, size_t len)
 }
 
 #define crc32_be_arch crc32_be_base /* not implemented on this arch */
 
 #define crc32_mod_init_arch crc32_mod_init_arch
-static inline void crc32_mod_init_arch(void)
+static void crc32_mod_init_arch(void)
 {
 	if (cpu_have_feature(cpu_feature(MIPS_CRC32)))
 		static_branch_enable(&have_crc32);
 }
 
diff --git a/lib/crc/powerpc/crc-t10dif.h b/lib/crc/powerpc/crc-t10dif.h
index 59e16804a6eae..3dd1895ea68a9 100644
--- a/lib/crc/powerpc/crc-t10dif.h
+++ b/lib/crc/powerpc/crc-t10dif.h
@@ -59,11 +59,11 @@ static inline u16 crc_t10dif_arch(u16 crci, const u8 *p, size_t len)
 
 	return crc & 0xffff;
 }
 
 #define crc_t10dif_mod_init_arch crc_t10dif_mod_init_arch
-static inline void crc_t10dif_mod_init_arch(void)
+static void crc_t10dif_mod_init_arch(void)
 {
 	if (cpu_has_feature(CPU_FTR_ARCH_207S) &&
 	    (cur_cpu_spec->cpu_user_features2 & PPC_FEATURE2_VEC_CRYPTO))
 		static_branch_enable(&have_vec_crypto);
 }
diff --git a/lib/crc/powerpc/crc32.h b/lib/crc/powerpc/crc32.h
index 811cc2e6ed24d..0cbd25c0c06eb 100644
--- a/lib/crc/powerpc/crc32.h
+++ b/lib/crc/powerpc/crc32.h
@@ -52,11 +52,11 @@ static inline u32 crc32c_arch(u32 crc, const u8 *p, size_t len)
 
 	return crc;
 }
 
 #define crc32_mod_init_arch crc32_mod_init_arch
-static inline void crc32_mod_init_arch(void)
+static void crc32_mod_init_arch(void)
 {
 	if (cpu_has_feature(CPU_FTR_ARCH_207S) &&
 	    (cur_cpu_spec->cpu_user_features2 & PPC_FEATURE2_VEC_CRYPTO))
 		static_branch_enable(&have_vec_crypto);
 }
diff --git a/lib/crc/sparc/crc32.h b/lib/crc/sparc/crc32.h
index 60f2765ac0157..df7c350acd7b5 100644
--- a/lib/crc/sparc/crc32.h
+++ b/lib/crc/sparc/crc32.h
@@ -42,11 +42,11 @@ static inline u32 crc32c_arch(u32 crc, const u8 *data, size_t len)
 		crc = crc32c_base(crc, data, len);
 	return crc;
 }
 
 #define crc32_mod_init_arch crc32_mod_init_arch
-static inline void crc32_mod_init_arch(void)
+static void crc32_mod_init_arch(void)
 {
 	unsigned long cfr;
 
 	if (!(sparc64_elf_hwcap & HWCAP_SPARC_CRYPTO))
 		return;
diff --git a/lib/crc/x86/crc-t10dif.h b/lib/crc/x86/crc-t10dif.h
index 2a02a3026f3f8..8ee8824da551c 100644
--- a/lib/crc/x86/crc-t10dif.h
+++ b/lib/crc/x86/crc-t10dif.h
@@ -17,11 +17,11 @@ static inline u16 crc_t10dif_arch(u16 crc, const u8 *p, size_t len)
 		   have_pclmulqdq);
 	return crc_t10dif_generic(crc, p, len);
 }
 
 #define crc_t10dif_mod_init_arch crc_t10dif_mod_init_arch
-static inline void crc_t10dif_mod_init_arch(void)
+static void crc_t10dif_mod_init_arch(void)
 {
 	if (boot_cpu_has(X86_FEATURE_PCLMULQDQ)) {
 		static_branch_enable(&have_pclmulqdq);
 		if (have_vpclmul()) {
 			if (have_avx512())
diff --git a/lib/crc/x86/crc32.h b/lib/crc/x86/crc32.h
index cea2c96d08d09..7ac7096177a7e 100644
--- a/lib/crc/x86/crc32.h
+++ b/lib/crc/x86/crc32.h
@@ -104,11 +104,11 @@ static inline u32 crc32c_arch(u32 crc, const u8 *p, size_t len)
 }
 
 #define crc32_be_arch crc32_be_base /* not implemented on this arch */
 
 #define crc32_mod_init_arch crc32_mod_init_arch
-static inline void crc32_mod_init_arch(void)
+static void crc32_mod_init_arch(void)
 {
 	if (boot_cpu_has(X86_FEATURE_XMM4_2))
 		static_branch_enable(&have_crc32);
 	if (boot_cpu_has(X86_FEATURE_PCLMULQDQ)) {
 		static_branch_enable(&have_pclmulqdq);
diff --git a/lib/crc/x86/crc64.h b/lib/crc/x86/crc64.h
index fde1222c4c584..7d45993193436 100644
--- a/lib/crc/x86/crc64.h
+++ b/lib/crc/x86/crc64.h
@@ -25,11 +25,11 @@ static inline u64 crc64_nvme_arch(u64 crc, const u8 *p, size_t len)
 		   have_pclmulqdq);
 	return crc64_nvme_generic(crc, p, len);
 }
 
 #define crc64_mod_init_arch crc64_mod_init_arch
-static inline void crc64_mod_init_arch(void)
+static void crc64_mod_init_arch(void)
 {
 	if (boot_cpu_has(X86_FEATURE_PCLMULQDQ)) {
 		static_branch_enable(&have_pclmulqdq);
 		if (have_vpclmul()) {
 			if (have_avx512()) {

base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
-- 
2.50.1

