Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B5514F9D9;
	Thu, 30 Jan 2025 03:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738209294; cv=none; b=L8ehVos36oIxkGsbJ1oB7q5ukJYpg5MAgooaRGo1JyRBh2Am14N0v70P0+DeUiWAlh0L6GccqZ5o/XqkaQR4gco0Tj+RoiW2asvzOn3KAjualVb9PbJ8R8RSg3Vcbw2DKEVZhCJgyo9t0nsjmRx5EVB3aGX4cd5N+XHUXAfX9Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738209294; c=relaxed/simple;
	bh=AqYuj9SoE3n/ZKGGUrD3nLUdyssqbzLnLipSo50wMhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rcC/TppSQLyYA1Xf6Suhj39dMEuG+GTlD+A8HGbOVxlfJ4ICmDOd02YaENc455e3aw72j/VYaFOi1wHFvoEDRyhwlqRYhW5yqtj5UduNeii2No7G22WwodP0cP+l2WcZUYZjeyolfBWZCf+VmO5/U8IGX+W6IbnDhX+aU2sgqjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p3GZf+NV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p3GZf+NV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DE35C4CEE3;
	Thu, 30 Jan 2025 03:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738209294;
	bh=AqYuj9SoE3n/ZKGGUrD3nLUdyssqbzLnLipSo50wMhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p3GZf+NVF6GXRtDf995AEnMEpRD9KPvRP1ChWgHJrmdWqW+xmeIlHfHhGAx+plbol
	 +W3unRaC30GX5mWNb9MP29A4CqV7YQMxHmBvLWCN5V8uPjDZXL5t8csL2WAaYACnAY
	 WFJS1IWIxvyAGtA59Ewvo1NNMoty707IpaZY9OCV01Ct+glvwQEzc4pwfsnX6CxARO
	 tb7hbk07kUmAulSz38HfXkdl5UY3f9mv9EN3968C7ZUgL+Ut63S8Emm4+xuCWUItGF
	 L54jJMI0z8t8ywzb6w5WbukjqIsCzrWbnfgoerpHqx1yJx3+QzUC5Ty1nHws8hPxIA
	 Jwt5z9s065sYg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	x86@kernel.org,
	linux-block@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 05/11] lib/crc64: add support for arch-optimized implementations
Date: Wed, 29 Jan 2025 19:51:24 -0800
Message-ID: <20250130035130.180676-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130035130.180676-1-ebiggers@kernel.org>
References: <20250130035130.180676-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Add support for architecture-optimized implementations of the CRC64
library functions, following the approach taken for the CRC32 and
CRC-T10DIF library functions.

Also take the opportunity to tweak the function prototypes:
- Use 'const void *' for the lib entry points (since this is easier for
  users) but 'const u8 *' for the underlying arch and generic functions
  (since this is easier for the implementations of these functions).
- Don't bother with __pure.  It's an unusual optimization that doesn't
  help properly written code.  It's a weird quirk we can do without.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/linux/crc64.h | 26 ++++++++++++++++++++++----
 lib/Kconfig           |  7 +++++++
 lib/crc64.c           | 36 ++++++++----------------------------
 3 files changed, 37 insertions(+), 32 deletions(-)

diff --git a/include/linux/crc64.h b/include/linux/crc64.h
index 17cf5af3e78e..41de30b907df 100644
--- a/include/linux/crc64.h
+++ b/include/linux/crc64.h
@@ -5,12 +5,28 @@
 #ifndef _LINUX_CRC64_H
 #define _LINUX_CRC64_H
 
 #include <linux/types.h>
 
-u64 __pure crc64_be(u64 crc, const void *p, size_t len);
-u64 __pure crc64_nvme_generic(u64 crc, const void *p, size_t len);
+u64 crc64_be_arch(u64 crc, const u8 *p, size_t len);
+u64 crc64_be_generic(u64 crc, const u8 *p, size_t len);
+u64 crc64_nvme_arch(u64 crc, const u8 *p, size_t len);
+u64 crc64_nvme_generic(u64 crc, const u8 *p, size_t len);
+
+/**
+ * crc64_be - Calculate bitwise big-endian ECMA-182 CRC64
+ * @crc: seed value for computation. 0 or (u64)~0 for a new CRC calculation,
+ *       or the previous crc64 value if computing incrementally.
+ * @p: pointer to buffer over which CRC64 is run
+ * @len: length of buffer @p
+ */
+static inline u64 crc64_be(u64 crc, const void *p, size_t len)
+{
+	if (IS_ENABLED(CONFIG_CRC64_ARCH))
+		return crc64_be_arch(crc, p, len);
+	return crc64_be_generic(crc, p, len);
+}
 
 /**
  * crc64_nvme - Calculate CRC64-NVME
  * @crc: seed value for computation. 0 for a new CRC calculation, or the
  *	 previous crc64 value if computing incrementally.
@@ -18,11 +34,13 @@ u64 __pure crc64_nvme_generic(u64 crc, const void *p, size_t len);
  * @len: length of buffer @p
  *
  * This computes the CRC64 defined in the NVME NVM Command Set Specification,
  * *including the bitwise inversion at the beginning and end*.
  */
-static inline u64 crc64_nvme(u64 crc, const u8 *p, size_t len)
+static inline u64 crc64_nvme(u64 crc, const void *p, size_t len)
 {
-	return crc64_nvme_generic(crc, p, len);
+	if (IS_ENABLED(CONFIG_CRC64_ARCH))
+		return ~crc64_nvme_arch(~crc, p, len);
+	return ~crc64_nvme_generic(~crc, p, len);
 }
 
 #endif /* _LINUX_CRC64_H */
diff --git a/lib/Kconfig b/lib/Kconfig
index da07fd39cf97..67bbf4f64dd9 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -199,10 +199,17 @@ config CRC64
 	  This option is provided for the case where no in-kernel-tree
 	  modules require CRC64 functions, but a module built outside
 	  the kernel tree does. Such modules that use library CRC64
 	  functions require M here.
 
+config ARCH_HAS_CRC64
+	bool
+
+config CRC64_ARCH
+	tristate
+	default CRC64 if ARCH_HAS_CRC64 && CRC_OPTIMIZATIONS
+
 config CRC4
 	tristate "CRC4 functions"
 	help
 	  This option is provided for the case where no in-kernel-tree
 	  modules require CRC4 functions, but a module built outside
diff --git a/lib/crc64.c b/lib/crc64.c
index d6f3f245eede..5b1b17057f0a 100644
--- a/lib/crc64.c
+++ b/lib/crc64.c
@@ -39,40 +39,20 @@
 #include "crc64table.h"
 
 MODULE_DESCRIPTION("CRC64 calculations");
 MODULE_LICENSE("GPL v2");
 
-/**
- * crc64_be - Calculate bitwise big-endian ECMA-182 CRC64
- * @crc: seed value for computation. 0 or (u64)~0 for a new CRC calculation,
- *       or the previous crc64 value if computing incrementally.
- * @p: pointer to buffer over which CRC64 is run
- * @len: length of buffer @p
- */
-u64 __pure crc64_be(u64 crc, const void *p, size_t len)
+u64 crc64_be_generic(u64 crc, const u8 *p, size_t len)
 {
-	size_t i, t;
-
-	const unsigned char *_p = p;
-
-	for (i = 0; i < len; i++) {
-		t = ((crc >> 56) ^ (*_p++)) & 0xFF;
-		crc = crc64table[t] ^ (crc << 8);
-	}
-
+	while (len--)
+		crc = (crc << 8) ^ crc64table[(crc >> 56) ^ *p++];
 	return crc;
 }
-EXPORT_SYMBOL_GPL(crc64_be);
+EXPORT_SYMBOL_GPL(crc64_be_generic);
 
-u64 __pure crc64_nvme_generic(u64 crc, const void *p, size_t len)
+u64 crc64_nvme_generic(u64 crc, const u8 *p, size_t len)
 {
-	const unsigned char *_p = p;
-	size_t i;
-
-	crc = ~crc;
-
-	for (i = 0; i < len; i++)
-		crc = (crc >> 8) ^ crc64nvmetable[(crc & 0xff) ^ *_p++];
-
-	return ~crc;
+	while (len--)
+		crc = (crc >> 8) ^ crc64nvmetable[(crc & 0xff) ^ *p++];
+	return crc;
 }
 EXPORT_SYMBOL_GPL(crc64_nvme_generic);
-- 
2.48.1

