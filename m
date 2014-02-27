From: chandramouli narayanan <mouli@linux.intel.com>
Subject: [PATCH 2/2] SHA1 transform: x86_64 AVX2 optimization - glue & build
Date: Thu, 27 Feb 2014 09:07:00 -0800
Message-ID: <1393520820.7495.89.camel@pegasus.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: ilya.albrekht@intel.com, maxim.locktykhin@intel.com,
	ronen.zohar@intel.com, wajdi.k.feghali@intel.com,
	tim.c.chen@linux.intel.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net, hpa@zytor.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:55884 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbaB0RGV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Feb 2014 12:06:21 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This git patch adds the glue, build and configuration changes
to include x86_64 AVX2 optimization of SHA1 transform to
crypto support. The patch has been tested with 3.14.0-rc1
kernel.

On a Haswell desktop, with turbo disabled and all cpus running
at maximum frequency, tcrypt shows AVX2 performance improvement
from 3% for 256 bytes update to 16% for 1024 bytes update over
AVX implementation. 

Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 6ba54d6..61d6e28 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -79,6 +79,9 @@ aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o fpu.o
 aesni-intel-$(CONFIG_64BIT) += aesni-intel_avx-x86_64.o
 ghash-clmulni-intel-y := ghash-clmulni-intel_asm.o ghash-clmulni-intel_glue.o
 sha1-ssse3-y := sha1_ssse3_asm.o sha1_ssse3_glue.o
+ifeq ($(avx2_supported),yes)
+sha1-ssse3-y += sha1_avx2_x86_64_asm.o
+endif
 crc32c-intel-y := crc32c-intel_glue.o
 crc32c-intel-$(CONFIG_64BIT) += crc32c-pcl-intel-asm_64.o
 crc32-pclmul-y := crc32-pclmul_asm.o crc32-pclmul_glue.o
diff --git a/arch/x86/crypto/sha1_ssse3_glue.c b/arch/x86/crypto/sha1_ssse3_glue.c
index 4a11a9d..3dd5ec9 100644
--- a/arch/x86/crypto/sha1_ssse3_glue.c
+++ b/arch/x86/crypto/sha1_ssse3_glue.c
@@ -10,6 +10,7 @@
  * Copyright (c) Andrew McDonald <andrew@mcdonald.org.uk>
  * Copyright (c) Jean-Francois Dive <jef@linuxbe.org>
  * Copyright (c) Mathias Krause <minipli@googlemail.com>
+ * Copyright (c) Chandramouli Narayanan <mouli@linux.intel.com>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
@@ -39,6 +40,12 @@ asmlinkage void sha1_transform_ssse3(u32 *digest, const char *data,
 asmlinkage void sha1_transform_avx(u32 *digest, const char *data,
 				   unsigned int rounds);
 #endif
+#ifdef CONFIG_AS_AVX2
+#define SHA1_AVX2_BLOCK_OPTSIZE	4	/* optimal 4*64 bytes of SHA1 blocks */
+
+asmlinkage void sha1_transform_avx2(u32 *digest, const char *data,
+				unsigned int rounds);
+#endif
 
 static asmlinkage void (*sha1_transform_asm)(u32 *, const char *, unsigned int);
 
@@ -165,6 +172,19 @@ static int sha1_ssse3_import(struct shash_desc *desc, const void *in)
 	return 0;
 }
 
+#ifdef CONFIG_AS_AVX2
+static void __sha1_transform_avx2(u32 *digest, const char *data,
+				unsigned int rounds)
+{
+
+	/* Select the optimal transform based on data block size */
+	if (rounds >= SHA1_AVX2_BLOCK_OPTSIZE)
+		sha1_transform_avx2(digest, data, rounds);
+	else
+		sha1_transform_avx(digest, data, rounds);
+}
+#endif
+
 static struct shash_alg alg = {
 	.digestsize	=	SHA1_DIGEST_SIZE,
 	.init		=	sha1_ssse3_init,
@@ -189,7 +209,11 @@ static bool __init avx_usable(void)
 {
 	u64 xcr0;
 
+#if defined(CONFIG_X86_64) && defined(CONFIG_AS_AVX2)
+	if (!cpu_has_avx || !cpu_has_avx2 || !cpu_has_osxsave)
+#else
 	if (!cpu_has_avx || !cpu_has_osxsave)
+#endif
 		return false;
 
 	xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
@@ -205,23 +229,35 @@ static bool __init avx_usable(void)
 
 static int __init sha1_ssse3_mod_init(void)
 {
+	char *algo_name;
 	/* test for SSSE3 first */
-	if (cpu_has_ssse3)
+	if (cpu_has_ssse3) {
 		sha1_transform_asm = sha1_transform_ssse3;
+		algo_name = "SSSE3";
+	}
 
 #ifdef CONFIG_AS_AVX
 	/* allow AVX to override SSSE3, it's a little faster */
-	if (avx_usable())
-		sha1_transform_asm = sha1_transform_avx;
+	if (avx_usable()) {
+		if (cpu_has_avx) {
+			sha1_transform_asm = sha1_transform_avx;
+			algo_name = "AVX";
+		}
+#ifdef CONFIG_AS_AVX2
+		if (cpu_has_avx2) {
+			/* allow AVX2 to override AVX, it's a little faster */
+			sha1_transform_asm = __sha1_transform_avx2;
+			algo_name = "AVX2";
+		}
+#endif
+	}
 #endif
 
 	if (sha1_transform_asm) {
-		pr_info("Using %s optimized SHA-1 implementation\n",
-		        sha1_transform_asm == sha1_transform_ssse3 ? "SSSE3"
-		                                                   : "AVX");
+		pr_info("Using %s optimized SHA-1 implementation\n", algo_name);
 		return crypto_register_shash(&alg);
 	}
-	pr_info("Neither AVX nor SSSE3 is available/usable.\n");
+	pr_info("Neither AVX nor AVX2 nor SSSE3 is available/usable.\n");
 
 	return -ENODEV;
 }
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 7bcb70d..ce4012a 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -491,14 +491,14 @@ config CRYPTO_SHA1
 	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2).
 
 config CRYPTO_SHA1_SSSE3
-	tristate "SHA1 digest algorithm (SSSE3/AVX)"
+	tristate "SHA1 digest algorithm (SSSE3/AVX/AVX2)"
 	depends on X86 && 64BIT
 	select CRYPTO_SHA1
 	select CRYPTO_HASH
 	help
 	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2) implemented
 	  using Supplemental SSE3 (SSSE3) instructions or Advanced Vector
-	  Extensions (AVX), when available.
+	  Extensions (AVX/AVX2), when available.
 
 config CRYPTO_SHA256_SSSE3
 	tristate "SHA256 digest algorithm (SSSE3/AVX/AVX2)"
