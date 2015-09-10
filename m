From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH 4/4] crypto: [sha] Add build support for Intel SHA
 Extensions optimized SHA1 and SHA256
Date: Thu, 10 Sep 2015 15:27:26 -0700
Message-ID: <1441924046.4322.4.camel@schen9-desk2.jf.intel.com>
References: <cover.1441929717.git.tim.c.chen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Sean Gulley <sean.m.gulley@intel.com>,
	Chandramouli Narayanan <mouli_7982@yahoo.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:17003 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbbIJW12 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Sep 2015 18:27:28 -0400
In-Reply-To: <cover.1441929717.git.tim.c.chen@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


This patch provides the configuration and build support to
include and build the optimized SHA1 and SHA256 update transforms
for the kernel's crypto library.

Originally-by: Chandramouli Narayanan <mouli_7982@yahoo.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 arch/x86/Makefile        |  6 ++++--
 arch/x86/crypto/Makefile |  8 ++++++++
 crypto/Kconfig           | 10 ++++++----
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 747860c..a8009c7 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -165,9 +165,11 @@ asinstr += $(call as-instr,pshufb %xmm0$(comma)%xmm0,-DCONFIG_AS_SSSE3=1)
 asinstr += $(call as-instr,crc32l %eax$(comma)%eax,-DCONFIG_AS_CRC32=1)
 avx_instr := $(call as-instr,vxorps %ymm0$(comma)%ymm1$(comma)%ymm2,-DCONFIG_AS_AVX=1)
 avx2_instr :=$(call as-instr,vpbroadcastb %xmm0$(comma)%ymm1,-DCONFIG_AS_AVX2=1)
+sha1_ni_instr :=$(call as-instr,sha1msg1 %xmm0$(comma)%xmm1,-DCONFIG_AS_SHA1_NI=1)
+sha256_ni_instr :=$(call as-instr,sha256msg1 %xmm0$(comma)%xmm1,-DCONFIG_AS_SHA256_NI=1)
 
-KBUILD_AFLAGS += $(asinstr) $(avx_instr) $(avx2_instr)
-KBUILD_CFLAGS += $(asinstr) $(avx_instr) $(avx2_instr)
+KBUILD_AFLAGS += $(asinstr) $(avx_instr) $(avx2_instr) $(sha1_ni_instr) $(sha256_ni_instr)
+KBUILD_CFLAGS += $(asinstr) $(avx_instr) $(avx2_instr) $(sha1_ni_instr) $(sha256_ni_instr)
 
 LDFLAGS := -m elf_$(UTS_MACHINE)
 
diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 9a2838c..b9b912a 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -5,6 +5,8 @@
 avx_supported := $(call as-instr,vpxor %xmm0$(comma)%xmm0$(comma)%xmm0,yes,no)
 avx2_supported := $(call as-instr,vpgatherdd %ymm0$(comma)(%eax$(comma)%ymm1\
 				$(comma)4)$(comma)%ymm2,yes,no)
+sha1_ni_supported :=$(call as-instr,sha1msg1 %xmm0$(comma)%xmm1,yes,no)
+sha256_ni_supported :=$(call as-instr,sha256msg1 %xmm0$(comma)%xmm1,yes,no)
 
 obj-$(CONFIG_CRYPTO_GLUE_HELPER_X86) += glue_helper.o
 
@@ -91,9 +93,15 @@ ifeq ($(avx2_supported),yes)
 sha1-ssse3-y += sha1_avx2_x86_64_asm.o
 poly1305-x86_64-y += poly1305-avx2-x86_64.o
 endif
+ifeq ($(sha1_ni_supported),yes)
+sha1-ssse3-y += sha1_ni_asm.o
+endif
 crc32c-intel-y := crc32c-intel_glue.o
 crc32c-intel-$(CONFIG_64BIT) += crc32c-pcl-intel-asm_64.o
 crc32-pclmul-y := crc32-pclmul_asm.o crc32-pclmul_glue.o
 sha256-ssse3-y := sha256-ssse3-asm.o sha256-avx-asm.o sha256-avx2-asm.o sha256_ssse3_glue.o
+ifeq ($(sha256_ni_supported),yes)
+sha256-ssse3-y += sha256_ni_asm.o
+endif
 sha512-ssse3-y := sha512-ssse3-asm.o sha512-avx-asm.o sha512-avx2-asm.o sha512_ssse3_glue.o
 crct10dif-pclmul-y := crct10dif-pcl-asm_64.o crct10dif-pclmul_glue.o
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 48ee3e1..fc93444 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -597,17 +597,18 @@ config CRYPTO_SHA1
 	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2).
 
 config CRYPTO_SHA1_SSSE3
-	tristate "SHA1 digest algorithm (SSSE3/AVX/AVX2)"
+	tristate "SHA1 digest algorithm (SSSE3/AVX/AVX2/SHA-NI)"
 	depends on X86 && 64BIT
 	select CRYPTO_SHA1
 	select CRYPTO_HASH
 	help
 	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2) implemented
 	  using Supplemental SSE3 (SSSE3) instructions or Advanced Vector
-	  Extensions (AVX/AVX2), when available.
+	  Extensions (AVX/AVX2) or SHA-NI(SHA Extensions New Instructions),
+	  when available.
 
 config CRYPTO_SHA256_SSSE3
-	tristate "SHA256 digest algorithm (SSSE3/AVX/AVX2)"
+	tristate "SHA256 digest algorithm (SSSE3/AVX/AVX2/SHA-NI)"
 	depends on X86 && 64BIT
 	select CRYPTO_SHA256
 	select CRYPTO_HASH
@@ -615,7 +616,8 @@ config CRYPTO_SHA256_SSSE3
 	  SHA-256 secure hash standard (DFIPS 180-2) implemented
 	  using Supplemental SSE3 (SSSE3) instructions, or Advanced Vector
 	  Extensions version 1 (AVX1), or Advanced Vector Extensions
-	  version 2 (AVX2) instructions, when available.
+	  version 2 (AVX2) instructions, or SHA-NI (SHA Extensions New
+	  Instructions) when available.
 
 config CRYPTO_SHA512_SSSE3
 	tristate "SHA512 digest algorithm (SSSE3/AVX/AVX2)"
-- 
2.4.2
