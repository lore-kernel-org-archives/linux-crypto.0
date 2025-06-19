Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A9C17D2;
	Thu, 19 Jun 2025 18:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750358128; cv=none; b=UhDHeGizylqoFwaD3u+AkJ9NXtU/wR5sDAQNN+riBZwVG02mozaWvaH0DULCbPuaJxvEyUpxigWv8l+HOQfYzV8QfbgPvV+zrdge+fSt981N4017++2x79JZF802BgEbiZFbhe1WoT9PC/ys2n68GsQ8oUbhncUqkhs6VK+XKPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750358128; c=relaxed/simple;
	bh=u8F2O3yQvUMm1VsGqiHsVAu86kDAFhtXcvh5K6FStJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N78E3eTBymvCtIbUXpDbE9eEi4Ee0LJDHQWnWIsE521K9FSkZdj0JzSvSmhuukedzOEMnJnAtsJsYMPZPsTPd2OG8uNoRPAcGQvcLc3SsVSL7RJJELtqU2R3AT3ecoOmUN1hwPT54mG6SrFwKe0utVVxqWWZi1QjNjqCYjQV4zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uocEu9pC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uocEu9pC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1DAC4CEF1;
	Thu, 19 Jun 2025 18:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750358128;
	bh=u8F2O3yQvUMm1VsGqiHsVAu86kDAFhtXcvh5K6FStJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uocEu9pCR/OSb/9XPIO4To+kA8rPC+3Rl+VZOdDLxK1LzsUOPyH7FxokAUgWDH7gs
	 iDI8ZnG2kyKXJ7/OKqUVotqJsMcoicis9uL6+HgEgqIVr3ZuaFqxYaST4WhwdsSMDV
	 wDS6SN9Zv2fj+/wAgstyadcFlAfPm+x1tDVa1U2tU0eA8/EwsmNXLlTk6iZvMLUGhW
	 nVVN6EzzYKSzUvRQ/+WtWS9h7vYTLlEzOTN16UuTJJEQ2jjIhnDujQrrA0PzFw0LTG
	 m0BpvqU1vBM3YO7MTqz4thgiqDdZ1hcO+PuJuKE9/GWs2eHcdGbY2qXNakgUPAYbot
	 J2mC/vBVBc2YA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org
Subject: [PATCH 1/3] lib/crc/crc32: document crc32_le(), crc32_be(), and crc32c()
Date: Thu, 19 Jun 2025 11:34:12 -0700
Message-ID: <20250619183414.100082-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250619183414.100082-1-ebiggers@kernel.org>
References: <20250619183414.100082-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Document these widely used functions.

Update kernel-api.rst to point to the correct place, instead of to
crc32-main.c which no longer contains kerneldoc comments.

Simplify the documentation in crc32poly.h to just point to the
corresponding functions, now that they are properly documented.  Change
the value of CRC32C_POLY_LE to lower case, for consistency.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/core-api/kernel-api.rst |  4 +-
 include/linux/crc32.h                 | 66 +++++++++++++++++++++++++++
 include/linux/crc32poly.h             | 16 ++-----
 3 files changed, 73 insertions(+), 13 deletions(-)

diff --git a/Documentation/core-api/kernel-api.rst b/Documentation/core-api/kernel-api.rst
index 9c8370891a39b..0096463c7d7f7 100644
--- a/Documentation/core-api/kernel-api.rst
+++ b/Documentation/core-api/kernel-api.rst
@@ -146,18 +146,18 @@ CRC Functions
    :export:
 
 .. kernel-doc:: lib/crc/crc16.c
    :export:
 
-.. kernel-doc:: lib/crc/crc32-main.c
-
 .. kernel-doc:: lib/crc/crc-ccitt.c
    :export:
 
 .. kernel-doc:: lib/crc/crc-itu-t.c
    :export:
 
+.. kernel-doc:: include/linux/crc32.h
+
 Base 2 log and power Functions
 ------------------------------
 
 .. kernel-doc:: include/linux/log2.h
    :internal:
diff --git a/include/linux/crc32.h b/include/linux/crc32.h
index 22dbe7144eb44..f9c173206d4d1 100644
--- a/include/linux/crc32.h
+++ b/include/linux/crc32.h
@@ -3,12 +3,78 @@
 #define _LINUX_CRC32_H
 
 #include <linux/types.h>
 #include <linux/bitrev.h>
 
+/**
+ * crc32_le() - Compute least-significant-bit-first IEEE CRC-32
+ * @crc: Initial CRC value.  ~0 (recommended) or 0 for a new CRC computation, or
+ *	 the previous CRC value if computing incrementally.
+ * @p: Pointer to the data buffer
+ * @len: Length of data in bytes
+ *
+ * This implements the CRC variant that is often known as the IEEE CRC-32, or
+ * simply CRC-32, and is widely used in Ethernet and other applications:
+ *
+ * - Polynomial: x^32 + x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 +
+ *		 x^7 + x^5 + x^4 + x^2 + x^1 + x^0
+ * - Bit order: Least-significant-bit-first
+ * - Polynomial in integer form: 0xedb88320
+ *
+ * This does *not* invert the CRC at the beginning or end.  The caller is
+ * expected to do that if it needs to.  Inverting at both ends is recommended.
+ *
+ * For new applications, prefer to use CRC-32C instead.  See crc32c().
+ *
+ * Context: Any context
+ * Return: The new CRC value
+ */
 u32 crc32_le(u32 crc, const void *p, size_t len);
+
+/**
+ * crc32_be() - Compute most-significant-bit-first IEEE CRC-32
+ * @crc: Initial CRC value.  ~0 (recommended) or 0 for a new CRC computation, or
+ *	 the previous CRC value if computing incrementally.
+ * @p: Pointer to the data buffer
+ * @len: Length of data in bytes
+ *
+ * crc32_be() is the same as crc32_le() except that crc32_be() computes the
+ * *most-significant-bit-first* variant of the CRC.  I.e., within each byte, the
+ * most significant bit is processed first (treated as highest order polynomial
+ * coefficient).  The same bit order is also used for the CRC value itself:
+ *
+ * - Polynomial: x^32 + x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 +
+ *		 x^7 + x^5 + x^4 + x^2 + x^1 + x^0
+ * - Bit order: Most-significant-bit-first
+ * - Polynomial in integer form: 0x04c11db7
+ *
+ * Context: Any context
+ * Return: The new CRC value
+ */
 u32 crc32_be(u32 crc, const void *p, size_t len);
+
+/**
+ * crc32c() - Compute CRC-32C
+ * @crc: Initial CRC value.  ~0 (recommended) or 0 for a new CRC computation, or
+ *	 the previous CRC value if computing incrementally.
+ * @p: Pointer to the data buffer
+ * @len: Length of data in bytes
+ *
+ * This implements CRC-32C, i.e. the Castagnoli CRC.  This is the recommended
+ * CRC variant to use in new applications that want a 32-bit CRC.
+ *
+ * - Polynomial: x^32 + x^28 + x^27 + x^26 + x^25 + x^23 + x^22 + x^20 + x^19 +
+ *		 x^18 + x^14 + x^13 + x^11 + x^10 + x^9 + x^8 + x^6 + x^0
+ * - Bit order: Least-significant-bit-first
+ * - Polynomial in integer form: 0x82f63b78
+ *
+ * This does *not* invert the CRC at the beginning or end.  The caller is
+ * expected to do that if it needs to.  Inverting at both ends is recommended.
+ *
+ * Context: Any context
+ * Return: The new CRC value
+ */
 u32 crc32c(u32 crc, const void *p, size_t len);
 
 /*
  * crc32_optimizations() returns flags that indicate which CRC32 library
  * functions are using architecture-specific optimizations.  Unlike
diff --git a/include/linux/crc32poly.h b/include/linux/crc32poly.h
index 62c4b7790a285..ccab711295fab 100644
--- a/include/linux/crc32poly.h
+++ b/include/linux/crc32poly.h
@@ -1,20 +1,14 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _LINUX_CRC32_POLY_H
 #define _LINUX_CRC32_POLY_H
 
-/*
- * There are multiple 16-bit CRC polynomials in common use, but this is
- * *the* standard CRC-32 polynomial, first popularized by Ethernet.
- * x^32+x^26+x^23+x^22+x^16+x^12+x^11+x^10+x^8+x^7+x^5+x^4+x^2+x^1+x^0
- */
+/* The polynomial used by crc32_le(), in integer form.  See crc32_le(). */
 #define CRC32_POLY_LE 0xedb88320
+
+/* The polynomial used by crc32_be(), in integer form.  See crc32_be(). */
 #define CRC32_POLY_BE 0x04c11db7
 
-/*
- * This is the CRC32c polynomial, as outlined by Castagnoli.
- * x^32+x^28+x^27+x^26+x^25+x^23+x^22+x^20+x^19+x^18+x^14+x^13+x^11+x^10+x^9+
- * x^8+x^6+x^0
- */
-#define CRC32C_POLY_LE 0x82F63B78
+/* The polynomial used by crc32c(), in integer form.  See crc32c(). */
+#define CRC32C_POLY_LE 0x82f63b78
 
 #endif /* _LINUX_CRC32_POLY_H */
-- 
2.50.0

