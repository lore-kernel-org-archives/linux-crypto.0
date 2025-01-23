Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBD41CBE9D;
	Thu, 23 Jan 2025 21:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737667987; cv=none; b=nVnS57ODdaPXGvBrCni4gJyECICVbEXz2SmDkY1RxqZlbmS0hnM27XD0K1ozA6LYYfBNGfiloncPynzwoDJGtoPhq0OFHz45zzO75WW+UHvHSir7kvW6lsCrfZSNvnrBFMUvV8g1bfggU0uVmMSEBNkTY6bJDXtswGHWBCtEj8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737667987; c=relaxed/simple;
	bh=/PbaVwJWYdZ0a63pn236jVnAnCQSSkddXgTwXel8vv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfJnjx3ZbrZK8KshtEIPfb5dI53hYZ1cRuQeeERHbMo87E8CXhWtyZyFKwErFAJU8G7Ppz4Iv9UTOXtFUDeZdt/B99tbg9hj2Bd4lYyEx7wTk9gnuquIeuXaNkBUSdhbiMdBb+nuxZAEDIhqPwqWef3QwNqJtRUokKiluwR3uzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Su/QuQ7m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Su/QuQ7m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA5BC4CEE4;
	Thu, 23 Jan 2025 21:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737667987;
	bh=/PbaVwJWYdZ0a63pn236jVnAnCQSSkddXgTwXel8vv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Su/QuQ7mo8b1btyR40mK/FiixAJL/ClrnzO79pEXFnz4bGFJ266kxTR/LzXLiy+N3
	 fOx7pYmgkItbpcO5R5B9RbqM6DrkUUaqc1dTDdz014JgHP1kHszdzHxzn4hkmAjy+l
	 rbZkEnRGpK1PgtuJe3dqAa06tlob4GOcnjgjxBonaxyIcqma/dFstVuKK44Z88Wh8K
	 ngLn0iinfluCO0eTrsdd+sI9J7H+uCYNzVE/m3GTScfXvJIzk+XkJE5zo0j63ldDTm
	 OFabKjo0clx6Kcl0SeQWV43FoF3hy/A7HMqW3/wLbcwjDL6MDsdcc1MzMx2mK0ONR6
	 bsGVyVnCdK8zg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Chao Yu <chao@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Theodore Ts'o <tytso@mit.edu>,
	Vinicius Peixoto <vpeixoto@lkcamp.dev>,
	WangYuli <wangyuli@uniontech.com>
Subject: [PATCH 2/2] lib/crc32: remove other generic implementations
Date: Thu, 23 Jan 2025 13:29:04 -0800
Message-ID: <20250123212904.118683-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250123212904.118683-1-ebiggers@kernel.org>
References: <20250123212904.118683-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Now that we've standardized on the byte-by-byte implementation of CRC32
as the only generic implementation (see previous commit for the
rationale), remove the code for the other implementations.

Tested with crc_kunit.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 lib/Kconfig          |   4 -
 lib/crc32.c          | 225 ++-----------------------------------------
 lib/crc32defs.h      |  59 ------------
 lib/gen_crc32table.c | 113 ++++++----------------
 4 files changed, 40 insertions(+), 361 deletions(-)
 delete mode 100644 lib/crc32defs.h

diff --git a/lib/Kconfig b/lib/Kconfig
index e08b26e8e03f..dccb61b7d698 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -187,11 +187,10 @@ config CRC_ITU_T
 
 config CRC32
 	tristate "CRC32/CRC32c functions"
 	default y
 	select BITREVERSE
-	select CRC32_SARWATE
 	help
 	  This option is provided for the case where no in-kernel-tree
 	  modules require CRC32/CRC32c functions, but a module built outside
 	  the kernel tree does. Such modules that use library CRC32/CRC32c
 	  functions require M here.
@@ -201,13 +200,10 @@ config ARCH_HAS_CRC32
 
 config CRC32_ARCH
 	tristate
 	default CRC32 if ARCH_HAS_CRC32 && CRC_OPTIMIZATIONS
 
-config CRC32_SARWATE
-	bool
-
 config CRC64
 	tristate "CRC64 functions"
 	help
 	  This option is provided for the case where no in-kernel-tree
 	  modules require CRC64 functions, but a module built outside
diff --git a/lib/crc32.c b/lib/crc32.c
index 47151624332e..ede6131f66fc 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -28,182 +28,31 @@
 
 #include <linux/crc32.h>
 #include <linux/crc32poly.h>
 #include <linux/module.h>
 #include <linux/types.h>
-#include <linux/sched.h>
-#include "crc32defs.h"
-
-#if CRC_LE_BITS > 8
-# define tole(x) ((__force u32) cpu_to_le32(x))
-#else
-# define tole(x) (x)
-#endif
-
-#if CRC_BE_BITS > 8
-# define tobe(x) ((__force u32) cpu_to_be32(x))
-#else
-# define tobe(x) (x)
-#endif
 
 #include "crc32table.h"
 
 MODULE_AUTHOR("Matt Domsch <Matt_Domsch@dell.com>");
 MODULE_DESCRIPTION("Various CRC32 calculations");
 MODULE_LICENSE("GPL");
 
-#if CRC_LE_BITS > 8 || CRC_BE_BITS > 8
-
-/* implements slicing-by-4 or slicing-by-8 algorithm */
-static inline u32 __pure
-crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
-{
-# ifdef __LITTLE_ENDIAN
-#  define DO_CRC(x) crc = t0[(crc ^ (x)) & 255] ^ (crc >> 8)
-#  define DO_CRC4 (t3[(q) & 255] ^ t2[(q >> 8) & 255] ^ \
-		   t1[(q >> 16) & 255] ^ t0[(q >> 24) & 255])
-#  define DO_CRC8 (t7[(q) & 255] ^ t6[(q >> 8) & 255] ^ \
-		   t5[(q >> 16) & 255] ^ t4[(q >> 24) & 255])
-# else
-#  define DO_CRC(x) crc = t0[((crc >> 24) ^ (x)) & 255] ^ (crc << 8)
-#  define DO_CRC4 (t0[(q) & 255] ^ t1[(q >> 8) & 255] ^ \
-		   t2[(q >> 16) & 255] ^ t3[(q >> 24) & 255])
-#  define DO_CRC8 (t4[(q) & 255] ^ t5[(q >> 8) & 255] ^ \
-		   t6[(q >> 16) & 255] ^ t7[(q >> 24) & 255])
-# endif
-	const u32 *b;
-	size_t    rem_len;
-# ifdef CONFIG_X86
-	size_t i;
-# endif
-	const u32 *t0=tab[0], *t1=tab[1], *t2=tab[2], *t3=tab[3];
-# if CRC_LE_BITS != 32
-	const u32 *t4 = tab[4], *t5 = tab[5], *t6 = tab[6], *t7 = tab[7];
-# endif
-	u32 q;
-
-	/* Align it */
-	if (unlikely((long)buf & 3 && len)) {
-		do {
-			DO_CRC(*buf++);
-		} while ((--len) && ((long)buf)&3);
-	}
-
-# if CRC_LE_BITS == 32
-	rem_len = len & 3;
-	len = len >> 2;
-# else
-	rem_len = len & 7;
-	len = len >> 3;
-# endif
-
-	b = (const u32 *)buf;
-# ifdef CONFIG_X86
-	--b;
-	for (i = 0; i < len; i++) {
-# else
-	for (--b; len; --len) {
-# endif
-		q = crc ^ *++b; /* use pre increment for speed */
-# if CRC_LE_BITS == 32
-		crc = DO_CRC4;
-# else
-		crc = DO_CRC8;
-		q = *++b;
-		crc ^= DO_CRC4;
-# endif
-	}
-	len = rem_len;
-	/* And the last few bytes */
-	if (len) {
-		u8 *p = (u8 *)(b + 1) - 1;
-# ifdef CONFIG_X86
-		for (i = 0; i < len; i++)
-			DO_CRC(*++p); /* use pre increment for speed */
-# else
-		do {
-			DO_CRC(*++p); /* use pre increment for speed */
-		} while (--len);
-# endif
-	}
-	return crc;
-#undef DO_CRC
-#undef DO_CRC4
-#undef DO_CRC8
-}
-#endif
-
-
-/**
- * crc32_le_generic() - Calculate bitwise little-endian Ethernet AUTODIN II
- *			CRC32/CRC32C
- * @crc: seed value for computation.  ~0 for Ethernet, sometimes 0 for other
- *	 uses, or the previous crc32/crc32c value if computing incrementally.
- * @p: pointer to buffer over which CRC32/CRC32C is run
- * @len: length of buffer @p
- * @tab: little-endian Ethernet table
- * @polynomial: CRC32/CRC32c LE polynomial
- */
-static inline u32 __pure crc32_le_generic(u32 crc, unsigned char const *p,
-					  size_t len, const u32 (*tab)[256],
-					  u32 polynomial)
+u32 __pure crc32_le_base(u32 crc, const u8 *p, size_t len)
 {
-#if CRC_LE_BITS == 1
-	int i;
-	while (len--) {
-		crc ^= *p++;
-		for (i = 0; i < 8; i++)
-			crc = (crc >> 1) ^ ((crc & 1) ? polynomial : 0);
-	}
-# elif CRC_LE_BITS == 2
-	while (len--) {
-		crc ^= *p++;
-		crc = (crc >> 2) ^ tab[0][crc & 3];
-		crc = (crc >> 2) ^ tab[0][crc & 3];
-		crc = (crc >> 2) ^ tab[0][crc & 3];
-		crc = (crc >> 2) ^ tab[0][crc & 3];
-	}
-# elif CRC_LE_BITS == 4
-	while (len--) {
-		crc ^= *p++;
-		crc = (crc >> 4) ^ tab[0][crc & 15];
-		crc = (crc >> 4) ^ tab[0][crc & 15];
-	}
-# elif CRC_LE_BITS == 8
-	/* aka Sarwate algorithm */
-	while (len--) {
-		crc ^= *p++;
-		crc = (crc >> 8) ^ tab[0][crc & 255];
-	}
-# else
-	crc = (__force u32) __cpu_to_le32(crc);
-	crc = crc32_body(crc, p, len, tab);
-	crc = __le32_to_cpu((__force __le32)crc);
-#endif
+	while (len--)
+		crc = (crc >> 8) ^ crc32table_le[(crc & 255) ^ *p++];
 	return crc;
 }
+EXPORT_SYMBOL(crc32_le_base);
 
-#if CRC_LE_BITS == 1
-u32 __pure crc32_le_base(u32 crc, const u8 *p, size_t len)
-{
-	return crc32_le_generic(crc, p, len, NULL, CRC32_POLY_LE);
-}
-u32 __pure crc32c_le_base(u32 crc, const u8 *p, size_t len)
-{
-	return crc32_le_generic(crc, p, len, NULL, CRC32C_POLY_LE);
-}
-#else
-u32 __pure crc32_le_base(u32 crc, const u8 *p, size_t len)
-{
-	return crc32_le_generic(crc, p, len, crc32table_le, CRC32_POLY_LE);
-}
 u32 __pure crc32c_le_base(u32 crc, const u8 *p, size_t len)
 {
-	return crc32_le_generic(crc, p, len, crc32ctable_le, CRC32C_POLY_LE);
+	while (len--)
+		crc = (crc >> 8) ^ crc32ctable_le[(crc & 255) ^ *p++];
+	return crc;
 }
-#endif
-EXPORT_SYMBOL(crc32_le_base);
 EXPORT_SYMBOL(crc32c_le_base);
 
 /*
  * This multiplies the polynomials x and y modulo the given modulus.
  * This follows the "little-endian" CRC convention that the lsbit
@@ -275,66 +124,12 @@ u32 __attribute_const__ __crc32c_le_shift(u32 crc, size_t len)
 	return crc32_generic_shift(crc, len, CRC32C_POLY_LE);
 }
 EXPORT_SYMBOL(crc32_le_shift);
 EXPORT_SYMBOL(__crc32c_le_shift);
 
-/**
- * crc32_be_generic() - Calculate bitwise big-endian Ethernet AUTODIN II CRC32
- * @crc: seed value for computation.  ~0 for Ethernet, sometimes 0 for
- *	other uses, or the previous crc32 value if computing incrementally.
- * @p: pointer to buffer over which CRC32 is run
- * @len: length of buffer @p
- * @tab: big-endian Ethernet table
- * @polynomial: CRC32 BE polynomial
- */
-static inline u32 __pure crc32_be_generic(u32 crc, unsigned char const *p,
-					  size_t len, const u32 (*tab)[256],
-					  u32 polynomial)
-{
-#if CRC_BE_BITS == 1
-	int i;
-	while (len--) {
-		crc ^= *p++ << 24;
-		for (i = 0; i < 8; i++)
-			crc =
-			    (crc << 1) ^ ((crc & 0x80000000) ? polynomial :
-					  0);
-	}
-# elif CRC_BE_BITS == 2
-	while (len--) {
-		crc ^= *p++ << 24;
-		crc = (crc << 2) ^ tab[0][crc >> 30];
-		crc = (crc << 2) ^ tab[0][crc >> 30];
-		crc = (crc << 2) ^ tab[0][crc >> 30];
-		crc = (crc << 2) ^ tab[0][crc >> 30];
-	}
-# elif CRC_BE_BITS == 4
-	while (len--) {
-		crc ^= *p++ << 24;
-		crc = (crc << 4) ^ tab[0][crc >> 28];
-		crc = (crc << 4) ^ tab[0][crc >> 28];
-	}
-# elif CRC_BE_BITS == 8
-	while (len--) {
-		crc ^= *p++ << 24;
-		crc = (crc << 8) ^ tab[0][crc >> 24];
-	}
-# else
-	crc = (__force u32) __cpu_to_be32(crc);
-	crc = crc32_body(crc, p, len, tab);
-	crc = __be32_to_cpu((__force __be32)crc);
-# endif
-	return crc;
-}
-
-#if CRC_BE_BITS == 1
-u32 __pure crc32_be_base(u32 crc, const u8 *p, size_t len)
-{
-	return crc32_be_generic(crc, p, len, NULL, CRC32_POLY_BE);
-}
-#else
 u32 __pure crc32_be_base(u32 crc, const u8 *p, size_t len)
 {
-	return crc32_be_generic(crc, p, len, crc32table_be, CRC32_POLY_BE);
+	while (len--)
+		crc = (crc << 8) ^ crc32table_be[(crc >> 24) ^ *p++];
+	return crc;
 }
-#endif
 EXPORT_SYMBOL(crc32_be_base);
diff --git a/lib/crc32defs.h b/lib/crc32defs.h
deleted file mode 100644
index 0c8fb5923e7e..000000000000
--- a/lib/crc32defs.h
+++ /dev/null
@@ -1,59 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-
-/* Try to choose an implementation variant via Kconfig */
-#ifdef CONFIG_CRC32_SLICEBY8
-# define CRC_LE_BITS 64
-# define CRC_BE_BITS 64
-#endif
-#ifdef CONFIG_CRC32_SLICEBY4
-# define CRC_LE_BITS 32
-# define CRC_BE_BITS 32
-#endif
-#ifdef CONFIG_CRC32_SARWATE
-# define CRC_LE_BITS 8
-# define CRC_BE_BITS 8
-#endif
-#ifdef CONFIG_CRC32_BIT
-# define CRC_LE_BITS 1
-# define CRC_BE_BITS 1
-#endif
-
-/*
- * How many bits at a time to use.  Valid values are 1, 2, 4, 8, 32 and 64.
- * For less performance-sensitive, use 4 or 8 to save table size.
- * For larger systems choose same as CPU architecture as default.
- * This works well on X86_64, SPARC64 systems. This may require some
- * elaboration after experiments with other architectures.
- */
-#ifndef CRC_LE_BITS
-#  ifdef CONFIG_64BIT
-#  define CRC_LE_BITS 64
-#  else
-#  define CRC_LE_BITS 32
-#  endif
-#endif
-#ifndef CRC_BE_BITS
-#  ifdef CONFIG_64BIT
-#  define CRC_BE_BITS 64
-#  else
-#  define CRC_BE_BITS 32
-#  endif
-#endif
-
-/*
- * Little-endian CRC computation.  Used with serial bit streams sent
- * lsbit-first.  Be sure to use cpu_to_le32() to append the computed CRC.
- */
-#if CRC_LE_BITS > 64 || CRC_LE_BITS < 1 || CRC_LE_BITS == 16 || \
-	CRC_LE_BITS & CRC_LE_BITS-1
-# error "CRC_LE_BITS must be one of {1, 2, 4, 8, 32, 64}"
-#endif
-
-/*
- * Big-endian CRC computation.  Used with serial bit streams sent
- * msbit-first.  Be sure to use cpu_to_be32() to append the computed CRC.
- */
-#if CRC_BE_BITS > 64 || CRC_BE_BITS < 1 || CRC_BE_BITS == 16 || \
-	CRC_BE_BITS & CRC_BE_BITS-1
-# error "CRC_BE_BITS must be one of {1, 2, 4, 8, 32, 64}"
-#endif
diff --git a/lib/gen_crc32table.c b/lib/gen_crc32table.c
index f755b997b967..6d03425b849e 100644
--- a/lib/gen_crc32table.c
+++ b/lib/gen_crc32table.c
@@ -1,60 +1,33 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <stdio.h>
 #include "../include/linux/crc32poly.h"
 #include "../include/generated/autoconf.h"
-#include "crc32defs.h"
 #include <inttypes.h>
 
-#define ENTRIES_PER_LINE 4
-
-#if CRC_LE_BITS > 8
-# define LE_TABLE_ROWS (CRC_LE_BITS/8)
-# define LE_TABLE_SIZE 256
-#else
-# define LE_TABLE_ROWS 1
-# define LE_TABLE_SIZE (1 << CRC_LE_BITS)
-#endif
-
-#if CRC_BE_BITS > 8
-# define BE_TABLE_ROWS (CRC_BE_BITS/8)
-# define BE_TABLE_SIZE 256
-#else
-# define BE_TABLE_ROWS 1
-# define BE_TABLE_SIZE (1 << CRC_BE_BITS)
-#endif
-
-static uint32_t crc32table_le[LE_TABLE_ROWS][256];
-static uint32_t crc32table_be[BE_TABLE_ROWS][256];
-static uint32_t crc32ctable_le[LE_TABLE_ROWS][256];
+static uint32_t crc32table_le[256];
+static uint32_t crc32table_be[256];
+static uint32_t crc32ctable_le[256];
 
 /**
  * crc32init_le() - allocate and initialize LE table data
  *
  * crc is the crc of the byte i; other entries are filled in based on the
  * fact that crctable[i^j] = crctable[i] ^ crctable[j].
  *
  */
-static void crc32init_le_generic(const uint32_t polynomial,
-				 uint32_t (*tab)[256])
+static void crc32init_le_generic(const uint32_t polynomial, uint32_t tab[256])
 {
 	unsigned i, j;
 	uint32_t crc = 1;
 
-	tab[0][0] = 0;
+	tab[0] = 0;
 
-	for (i = LE_TABLE_SIZE >> 1; i; i >>= 1) {
+	for (i = 128; i; i >>= 1) {
 		crc = (crc >> 1) ^ ((crc & 1) ? polynomial : 0);
-		for (j = 0; j < LE_TABLE_SIZE; j += 2 * i)
-			tab[0][i + j] = crc ^ tab[0][j];
-	}
-	for (i = 0; i < LE_TABLE_SIZE; i++) {
-		crc = tab[0][i];
-		for (j = 1; j < LE_TABLE_ROWS; j++) {
-			crc = tab[0][crc & 0xff] ^ (crc >> 8);
-			tab[j][i] = crc;
-		}
+		for (j = 0; j < 256; j += 2 * i)
+			tab[i + j] = crc ^ tab[j];
 	}
 }
 
 static void crc32init_le(void)
 {
@@ -72,71 +45,45 @@ static void crc32cinit_le(void)
 static void crc32init_be(void)
 {
 	unsigned i, j;
 	uint32_t crc = 0x80000000;
 
-	crc32table_be[0][0] = 0;
+	crc32table_be[0] = 0;
 
-	for (i = 1; i < BE_TABLE_SIZE; i <<= 1) {
+	for (i = 1; i < 256; i <<= 1) {
 		crc = (crc << 1) ^ ((crc & 0x80000000) ? CRC32_POLY_BE : 0);
 		for (j = 0; j < i; j++)
-			crc32table_be[0][i + j] = crc ^ crc32table_be[0][j];
-	}
-	for (i = 0; i < BE_TABLE_SIZE; i++) {
-		crc = crc32table_be[0][i];
-		for (j = 1; j < BE_TABLE_ROWS; j++) {
-			crc = crc32table_be[0][(crc >> 24) & 0xff] ^ (crc << 8);
-			crc32table_be[j][i] = crc;
-		}
+			crc32table_be[i + j] = crc ^ crc32table_be[j];
 	}
 }
 
-static void output_table(uint32_t (*table)[256], int rows, int len, char *trans)
+static void output_table(const uint32_t table[256])
 {
-	int i, j;
-
-	for (j = 0 ; j < rows; j++) {
-		printf("{");
-		for (i = 0; i < len - 1; i++) {
-			if (i % ENTRIES_PER_LINE == 0)
-				printf("\n");
-			printf("%s(0x%8.8xL), ", trans, table[j][i]);
-		}
-		printf("%s(0x%8.8xL)},\n", trans, table[j][len - 1]);
+	int i;
+
+	for (i = 0; i < 256; i += 4) {
+		printf("\t0x%08x, 0x%08x, 0x%08x, 0x%08x,\n",
+		       table[i], table[i + 1], table[i + 2], table[i + 3]);
 	}
 }
 
 int main(int argc, char** argv)
 {
 	printf("/* this file is generated - do not edit */\n\n");
 
-	if (CRC_LE_BITS > 1) {
-		crc32init_le();
-		printf("static const u32 ____cacheline_aligned "
-		       "crc32table_le[%d][%d] = {",
-		       LE_TABLE_ROWS, LE_TABLE_SIZE);
-		output_table(crc32table_le, LE_TABLE_ROWS,
-			     LE_TABLE_SIZE, "tole");
-		printf("};\n");
-	}
+	crc32init_le();
+	printf("static const u32 ____cacheline_aligned crc32table_le[256] = {\n");
+	output_table(crc32table_le);
+	printf("};\n");
 
-	if (CRC_BE_BITS > 1) {
-		crc32init_be();
-		printf("static const u32 ____cacheline_aligned "
-		       "crc32table_be[%d][%d] = {",
-		       BE_TABLE_ROWS, BE_TABLE_SIZE);
-		output_table(crc32table_be, LE_TABLE_ROWS,
-			     BE_TABLE_SIZE, "tobe");
-		printf("};\n");
-	}
-	if (CRC_LE_BITS > 1) {
-		crc32cinit_le();
-		printf("static const u32 ____cacheline_aligned "
-		       "crc32ctable_le[%d][%d] = {",
-		       LE_TABLE_ROWS, LE_TABLE_SIZE);
-		output_table(crc32ctable_le, LE_TABLE_ROWS,
-			     LE_TABLE_SIZE, "tole");
-		printf("};\n");
-	}
+	crc32init_be();
+	printf("static const u32 ____cacheline_aligned crc32table_be[256] = {\n");
+	output_table(crc32table_be);
+	printf("};\n");
+
+	crc32cinit_le();
+	printf("static const u32 ____cacheline_aligned crc32ctable_le[256] = {\n");
+	output_table(crc32ctable_le);
+	printf("};\n");
 
 	return 0;
 }
-- 
2.48.1

