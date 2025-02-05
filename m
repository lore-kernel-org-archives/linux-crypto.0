Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62468227BA3;
	Wed,  5 Feb 2025 00:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738716929; cv=none; b=reqGMd05Xurlr6QROwaZ6qrxiyz4Uge1JOuvxKDLH4jTVkR1skb+uSa1ppPZsg+0i6uR21XctF+2F1yXDydjk6BekLnC1RGO+2Llvg58CwefamQapeG0EJgIYy+/7K8IiB9eMSnyDpEmesBN6zLhcQ7WLMpBR+OIW6gzMHjoC2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738716929; c=relaxed/simple;
	bh=c8Y3wEjgGTUthsDjeZYGqYPDHe6vpLTA8SDN8GPONRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a65YWiv0o+VisHMH7FGeJPXcJL/ZI2mPFh98y6ZWV16ioLcktJLkBglmz5+ka31C4fqGI134vSzXD6pMZs1pDFTqgnPA1dHd8ViCEEbCVeGwiJ7QP+4c/Yiv/PF5bzyK/jubq4bLAxd8PboGi/rspQMt446xHO5m9jSRMI3XfYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fx+SAjrB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fx+SAjrB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF74C4CEE5;
	Wed,  5 Feb 2025 00:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738716928;
	bh=c8Y3wEjgGTUthsDjeZYGqYPDHe6vpLTA8SDN8GPONRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fx+SAjrB5V/VdvXmTNc4LoEtLfVHKOGj//BijWAHtZ04707OAhAIPVxm9heYq/0mG
	 K/OBRo8z6dXCvjgKc5V+M5dy/Vnfftk+0vdC13gB48vBJhPV3aCgbMTOmV5FVBn/yN
	 IpJdWhqZYhNLvJlTSqsB9ln3g4nlR7sXfhpA/Hz9/EcBgm0PUN3cODN/CQ3f6mWKK4
	 K28kL5Qdp3/1PW7D5DiC864TkA/I007DwxOtHhLkfmF1a0Ae44sw61Ct7ixbuoOqMl
	 kcpZta8gpb4bK1RCdrmMlmmNso2wHjcs7utYzuAWtRCJ6vG08aiIWy/mIYEWfwMZt3
	 Lf7iJf2FVKcRg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 2/5] lib/crc32: don't bother with pure and const function attributes
Date: Tue,  4 Feb 2025 16:54:00 -0800
Message-ID: <20250205005403.136082-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205005403.136082-1-ebiggers@kernel.org>
References: <20250205005403.136082-1-ebiggers@kernel.org>
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

