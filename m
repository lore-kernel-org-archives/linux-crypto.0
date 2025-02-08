Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76C414F9D9;
	Sat,  8 Feb 2025 02:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738982963; cv=none; b=tFpYtaRUElG8MkVpyy7xbbetsuKtTjjZqjUPIG72mjWaCoCkv301Br2m43wHony2qt9msvB+9Rh7UxnkNsnh5CKi1UoLJoc83pbH5svPuc+LheeVxLNc1scULFXoyHv/ctwlHmlYiOT1NL1FrXLidS9nvZhWKZZoPE9YIze2NkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738982963; c=relaxed/simple;
	bh=pg7pn03qgdZnaIVA+IRdsp6/W/WhJZLwaxEK8sNdGdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dpMSotRiAqRTSi1HZgN7IZt9SA1PdhNj/1b/APEd2W87oNRk2Reorkb+s3loyC/Z5MgI+8avzDG4vGQUCqoB6vsUZaBRDDQ8Dw+vTTZt9jOZ6RhdvjGkOHeuGK53w1TG/iraakMLpBLvs5BrvybdGl7dJ21jSYLaaEeK6B1G8UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M4py47nr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M4py47nr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AEBCC4CEE8;
	Sat,  8 Feb 2025 02:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738982963;
	bh=pg7pn03qgdZnaIVA+IRdsp6/W/WhJZLwaxEK8sNdGdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M4py47nrrv508wFzYOQ1gR6K7JpARbBoBMUlgAni34wZ2dyLy5PCrqoldJeOnO3vg
	 /kadusUb/lcjyhecsD1QgMRFs6e8s6Rn6aqwB5uzGmVdVvGvxqPCXNBstwsrtLCoHa
	 Rcm/Ji80YbzG3QLdN5sYKmlAcKLfVc8xQmrAw7n3sJ/NGe+dWd+qkAfISEwGqR+K6A
	 PLqb+42M7cibPLnNkPsUwDkYsruWQnRUVgXgFdoX3FnuYJgIUA+J2H90yKo/OwlMJR
	 SsmEaFfPq8TRhEWfezm8SBMxoh3cyFzOsbTyQdLmQYvko0MS0x0mlIVRZU6313Y8og
	 3GkR+eIKqB4TQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v2 3/6] lib/crc32: don't bother with pure and const function attributes
Date: Fri,  7 Feb 2025 18:49:08 -0800
Message-ID: <20250208024911.14936-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250208024911.14936-1-ebiggers@kernel.org>
References: <20250208024911.14936-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Drop the use of __pure and __attribute_const__ from the CRC32 library
functions that had them.  Both of these are unusual optimizations that
don't help properly written code.  They seem more likely to cause
problems than have any real benefit.

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm64/lib/crc32-glue.c  |  6 +++---
 arch/riscv/lib/crc32-riscv.c | 13 ++++++-------
 include/linux/crc32.h        | 22 +++++++++++-----------
 lib/crc32.c                  | 15 +++++++--------
 4 files changed, 27 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/lib/crc32-glue.c b/arch/arm64/lib/crc32-glue.c
index 15c4c9db573ec..265fbf36914b6 100644
--- a/arch/arm64/lib/crc32-glue.c
+++ b/arch/arm64/lib/crc32-glue.c
@@ -20,11 +20,11 @@ asmlinkage u32 crc32_be_arm64(u32 crc, unsigned char const *p, size_t len);
 
 asmlinkage u32 crc32_le_arm64_4way(u32 crc, unsigned char const *p, size_t len);
 asmlinkage u32 crc32c_le_arm64_4way(u32 crc, unsigned char const *p, size_t len);
 asmlinkage u32 crc32_be_arm64_4way(u32 crc, unsigned char const *p, size_t len);
 
-u32 __pure crc32_le_arch(u32 crc, const u8 *p, size_t len)
+u32 crc32_le_arch(u32 crc, const u8 *p, size_t len)
 {
 	if (!alternative_has_cap_likely(ARM64_HAS_CRC32))
 		return crc32_le_base(crc, p, len);
 
 	if (len >= min_len && cpu_have_named_feature(PMULL) && crypto_simd_usable()) {
@@ -41,11 +41,11 @@ u32 __pure crc32_le_arch(u32 crc, const u8 *p, size_t len)
 
 	return crc32_le_arm64(crc, p, len);
 }
 EXPORT_SYMBOL(crc32_le_arch);
 
-u32 __pure crc32c_le_arch(u32 crc, const u8 *p, size_t len)
+u32 crc32c_le_arch(u32 crc, const u8 *p, size_t len)
 {
 	if (!alternative_has_cap_likely(ARM64_HAS_CRC32))
 		return crc32c_le_base(crc, p, len);
 
 	if (len >= min_len && cpu_have_named_feature(PMULL) && crypto_simd_usable()) {
@@ -62,11 +62,11 @@ u32 __pure crc32c_le_arch(u32 crc, const u8 *p, size_t len)
 
 	return crc32c_le_arm64(crc, p, len);
 }
 EXPORT_SYMBOL(crc32c_le_arch);
 
-u32 __pure crc32_be_arch(u32 crc, const u8 *p, size_t len)
+u32 crc32_be_arch(u32 crc, const u8 *p, size_t len)
 {
 	if (!alternative_has_cap_likely(ARM64_HAS_CRC32))
 		return crc32_be_base(crc, p, len);
 
 	if (len >= min_len && cpu_have_named_feature(PMULL) && crypto_simd_usable()) {
diff --git a/arch/riscv/lib/crc32-riscv.c b/arch/riscv/lib/crc32-riscv.c
index 53d56ab422c72..a50f8e010417d 100644
--- a/arch/riscv/lib/crc32-riscv.c
+++ b/arch/riscv/lib/crc32-riscv.c
@@ -173,14 +173,13 @@ static inline u32 crc32_le_unaligned(u32 crc, unsigned char const *p,
 	crc ^= crc_low;
 
 	return crc;
 }
 
-static inline u32 __pure crc32_le_generic(u32 crc, unsigned char const *p,
-					  size_t len, u32 poly,
-					  unsigned long poly_qt,
-					  fallback crc_fb)
+static inline u32 crc32_le_generic(u32 crc, unsigned char const *p, size_t len,
+				   u32 poly, unsigned long poly_qt,
+				   fallback crc_fb)
 {
 	size_t offset, head_len, tail_len;
 	unsigned long const *p_ul;
 	unsigned long s;
 
@@ -216,18 +215,18 @@ static inline u32 __pure crc32_le_generic(u32 crc, unsigned char const *p,
 
 legacy:
 	return crc_fb(crc, p, len);
 }
 
-u32 __pure crc32_le_arch(u32 crc, const u8 *p, size_t len)
+u32 crc32_le_arch(u32 crc, const u8 *p, size_t len)
 {
 	return crc32_le_generic(crc, p, len, CRC32_POLY_LE, CRC32_POLY_QT_LE,
 				crc32_le_base);
 }
 EXPORT_SYMBOL(crc32_le_arch);
 
-u32 __pure crc32c_le_arch(u32 crc, const u8 *p, size_t len)
+u32 crc32c_le_arch(u32 crc, const u8 *p, size_t len)
 {
 	return crc32_le_generic(crc, p, len, CRC32C_POLY_LE,
 				CRC32C_POLY_QT_LE, crc32c_le_base);
 }
 EXPORT_SYMBOL(crc32c_le_arch);
@@ -254,11 +253,11 @@ static inline u32 crc32_be_unaligned(u32 crc, unsigned char const *p,
 	crc ^= crc_low;
 
 	return crc;
 }
 
-u32 __pure crc32_be_arch(u32 crc, const u8 *p, size_t len)
+u32 crc32_be_arch(u32 crc, const u8 *p, size_t len)
 {
 	size_t offset, head_len, tail_len;
 	unsigned long const *p_ul;
 	unsigned long s;
 
diff --git a/include/linux/crc32.h b/include/linux/crc32.h
index e70977014cfdc..61a7ec29d6338 100644
--- a/include/linux/crc32.h
+++ b/include/linux/crc32.h
@@ -6,33 +6,33 @@
 #define _LINUX_CRC32_H
 
 #include <linux/types.h>
 #include <linux/bitrev.h>
 
-u32 __pure crc32_le_arch(u32 crc, const u8 *p, size_t len);
-u32 __pure crc32_le_base(u32 crc, const u8 *p, size_t len);
-u32 __pure crc32_be_arch(u32 crc, const u8 *p, size_t len);
-u32 __pure crc32_be_base(u32 crc, const u8 *p, size_t len);
-u32 __pure crc32c_le_arch(u32 crc, const u8 *p, size_t len);
-u32 __pure crc32c_le_base(u32 crc, const u8 *p, size_t len);
+u32 crc32_le_arch(u32 crc, const u8 *p, size_t len);
+u32 crc32_le_base(u32 crc, const u8 *p, size_t len);
+u32 crc32_be_arch(u32 crc, const u8 *p, size_t len);
+u32 crc32_be_base(u32 crc, const u8 *p, size_t len);
+u32 crc32c_le_arch(u32 crc, const u8 *p, size_t len);
+u32 crc32c_le_base(u32 crc, const u8 *p, size_t len);
 
-static inline u32 __pure crc32_le(u32 crc, const void *p, size_t len)
+static inline u32 crc32_le(u32 crc, const void *p, size_t len)
 {
 	if (IS_ENABLED(CONFIG_CRC32_ARCH))
 		return crc32_le_arch(crc, p, len);
 	return crc32_le_base(crc, p, len);
 }
 
-static inline u32 __pure crc32_be(u32 crc, const void *p, size_t len)
+static inline u32 crc32_be(u32 crc, const void *p, size_t len)
 {
 	if (IS_ENABLED(CONFIG_CRC32_ARCH))
 		return crc32_be_arch(crc, p, len);
 	return crc32_be_base(crc, p, len);
 }
 
 /* TODO: leading underscores should be dropped once callers have been updated */
-static inline u32 __pure __crc32c_le(u32 crc, const void *p, size_t len)
+static inline u32 __crc32c_le(u32 crc, const void *p, size_t len)
 {
 	if (IS_ENABLED(CONFIG_CRC32_ARCH))
 		return crc32c_le_arch(crc, p, len);
 	return crc32c_le_base(crc, p, len);
 }
@@ -68,11 +68,11 @@ static inline u32 crc32_optimizations(void) { return 0; }
  * 	   the crc32_le() value of seq_full, then crc_full ==
  * 	   crc32_le_combine(crc1, crc2, len2) when crc_full was seeded
  * 	   with the same initializer as crc1, and crc2 seed was 0. See
  * 	   also crc32_combine_test().
  */
-u32 __attribute_const__ crc32_le_shift(u32 crc, size_t len);
+u32 crc32_le_shift(u32 crc, size_t len);
 
 static inline u32 crc32_le_combine(u32 crc1, u32 crc2, size_t len2)
 {
 	return crc32_le_shift(crc1, len2) ^ crc2;
 }
@@ -93,11 +93,11 @@ static inline u32 crc32_le_combine(u32 crc1, u32 crc2, size_t len2)
  * 	   the __crc32c_le() value of seq_full, then crc_full ==
  * 	   __crc32c_le_combine(crc1, crc2, len2) when crc_full was
  * 	   seeded with the same initializer as crc1, and crc2 seed
  * 	   was 0. See also crc32c_combine_test().
  */
-u32 __attribute_const__ __crc32c_le_shift(u32 crc, size_t len);
+u32 __crc32c_le_shift(u32 crc, size_t len);
 
 static inline u32 __crc32c_le_combine(u32 crc1, u32 crc2, size_t len2)
 {
 	return __crc32c_le_shift(crc1, len2) ^ crc2;
 }
diff --git a/lib/crc32.c b/lib/crc32.c
index ede6131f66fc4..3c080cda5e1c9 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -35,19 +35,19 @@
 
 MODULE_AUTHOR("Matt Domsch <Matt_Domsch@dell.com>");
 MODULE_DESCRIPTION("Various CRC32 calculations");
 MODULE_LICENSE("GPL");
 
-u32 __pure crc32_le_base(u32 crc, const u8 *p, size_t len)
+u32 crc32_le_base(u32 crc, const u8 *p, size_t len)
 {
 	while (len--)
 		crc = (crc >> 8) ^ crc32table_le[(crc & 255) ^ *p++];
 	return crc;
 }
 EXPORT_SYMBOL(crc32_le_base);
 
-u32 __pure crc32c_le_base(u32 crc, const u8 *p, size_t len)
+u32 crc32c_le_base(u32 crc, const u8 *p, size_t len)
 {
 	while (len--)
 		crc = (crc >> 8) ^ crc32ctable_le[(crc & 255) ^ *p++];
 	return crc;
 }
@@ -56,11 +56,11 @@ EXPORT_SYMBOL(crc32c_le_base);
 /*
  * This multiplies the polynomials x and y modulo the given modulus.
  * This follows the "little-endian" CRC convention that the lsbit
  * represents the highest power of x, and the msbit represents x^0.
  */
-static u32 __attribute_const__ gf2_multiply(u32 x, u32 y, u32 modulus)
+static u32 gf2_multiply(u32 x, u32 y, u32 modulus)
 {
 	u32 product = x & 1 ? y : 0;
 	int i;
 
 	for (i = 0; i < 31; i++) {
@@ -82,12 +82,11 @@ static u32 __attribute_const__ gf2_multiply(u32 x, u32 y, u32 modulus)
  * over separate ranges of a buffer, then summing them.
  * This shifts the given CRC by 8*len bits (i.e. produces the same effect
  * as appending len bytes of zero to the data), in time proportional
  * to log(len).
  */
-static u32 __attribute_const__ crc32_generic_shift(u32 crc, size_t len,
-						   u32 polynomial)
+static u32 crc32_generic_shift(u32 crc, size_t len, u32 polynomial)
 {
 	u32 power = polynomial;	/* CRC of x^32 */
 	int i;
 
 	/* Shift up to 32 bits in the simple linear way */
@@ -112,23 +111,23 @@ static u32 __attribute_const__ crc32_generic_shift(u32 crc, size_t len,
 	}
 
 	return crc;
 }
 
-u32 __attribute_const__ crc32_le_shift(u32 crc, size_t len)
+u32 crc32_le_shift(u32 crc, size_t len)
 {
 	return crc32_generic_shift(crc, len, CRC32_POLY_LE);
 }
 
-u32 __attribute_const__ __crc32c_le_shift(u32 crc, size_t len)
+u32 __crc32c_le_shift(u32 crc, size_t len)
 {
 	return crc32_generic_shift(crc, len, CRC32C_POLY_LE);
 }
 EXPORT_SYMBOL(crc32_le_shift);
 EXPORT_SYMBOL(__crc32c_le_shift);
 
-u32 __pure crc32_be_base(u32 crc, const u8 *p, size_t len)
+u32 crc32_be_base(u32 crc, const u8 *p, size_t len)
 {
 	while (len--)
 		crc = (crc << 8) ^ crc32table_be[(crc >> 24) ^ *p++];
 	return crc;
 }
-- 
2.48.1

