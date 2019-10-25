Return-Path: <SRS0=9dQ/=YS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 323D2CA9EA0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 19:45:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2BE521D71
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 19:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572032728;
	bh=l/mUS8kzmJFvxIuUJ+YVRIUkldNG7HpJkqp6TA5zXi4=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=SMsFxEQN7C/NgncLJjyYryZboQLgVM33qV7fECBfT9L7yCDaNI3eHpxJj2Eh36ecw
	 aUykAj5NPmBIDANdkuPlJfx4IcU4PqnYq90FXtfHwqapCrVSdWlLeyIeN8TfjCPusq
	 XfrwH3pkYQJyXLE8nhXaGhw6yYkWbpnF1++pxBGY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727546AbfJYTp1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Oct 2019 15:45:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727550AbfJYTp0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Oct 2019 15:45:26 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F92721D71
        for <linux-crypto@vger.kernel.org>; Fri, 25 Oct 2019 19:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572032724;
        bh=l/mUS8kzmJFvxIuUJ+YVRIUkldNG7HpJkqp6TA5zXi4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=GcT+KSqTtXTWNCr4si+GxV2Q9dGZDRxYEVkc7yrh9t2N96Ub1OUKLS5WJcM0zorXW
         Yvt+zHVMbawmAhoof1bum6+8wK8owUg0pG0cgn8rkpkFWR/4J02/L/+KcylQvWVwdI
         q7YN1Sbll6iQ6z+mnhI6eIEs1/ENkdSRKxcM4TzU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 5/5] crypto: rename the crypto_blkcipher module and kconfig option
Date:   Fri, 25 Oct 2019 12:41:13 -0700
Message-Id: <20191025194113.217451-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191025194113.217451-1-ebiggers@kernel.org>
References: <20191025194113.217451-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Now that the blkcipher algorithm type has been removed in favor of
skcipher, rename the crypto_blkcipher kernel module to crypto_skcipher,
and rename the config options accordingly:

	CONFIG_CRYPTO_BLKCIPHER => CONFIG_CRYPTO_SKCIPHER
	CONFIG_CRYPTO_BLKCIPHER2 => CONFIG_CRYPTO_SKCIPHER2

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm/crypto/Kconfig              |  6 +-
 arch/arm64/crypto/Kconfig            |  8 +--
 crypto/Kconfig                       | 84 ++++++++++++++--------------
 crypto/Makefile                      |  6 +-
 drivers/crypto/Kconfig               | 52 ++++++++---------
 drivers/crypto/amlogic/Kconfig       |  2 +-
 drivers/crypto/caam/Kconfig          |  6 +-
 drivers/crypto/cavium/nitrox/Kconfig |  2 +-
 drivers/crypto/ccp/Kconfig           |  2 +-
 drivers/crypto/hisilicon/Kconfig     |  2 +-
 drivers/crypto/qat/Kconfig           |  2 +-
 drivers/crypto/ux500/Kconfig         |  2 +-
 drivers/crypto/virtio/Kconfig        |  2 +-
 drivers/net/wireless/cisco/Kconfig   |  2 +-
 net/bluetooth/Kconfig                |  2 +-
 net/rxrpc/Kconfig                    |  2 +-
 net/xfrm/Kconfig                     |  2 +-
 17 files changed, 92 insertions(+), 92 deletions(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index 9f257c1bf32b..c618c379449f 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -81,7 +81,7 @@ config CRYPTO_AES_ARM
 config CRYPTO_AES_ARM_BS
 	tristate "Bit sliced AES using NEON instructions"
 	depends on KERNEL_MODE_NEON
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_AES
 	select CRYPTO_SIMD
 	help
@@ -97,7 +97,7 @@ config CRYPTO_AES_ARM_BS
 config CRYPTO_AES_ARM_CE
 	tristate "Accelerated AES using ARMv8 Crypto Extensions"
 	depends on KERNEL_MODE_NEON && (CC_IS_CLANG || GCC_VERSION >= 40800)
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_SIMD
 	help
 	  Use an implementation of AES in CBC, CTR and XTS modes that uses
@@ -130,7 +130,7 @@ config CRYPTO_CRC32_ARM_CE
 config CRYPTO_CHACHA20_NEON
 	tristate "NEON accelerated ChaCha stream cipher algorithms"
 	depends on KERNEL_MODE_NEON
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_CHACHA20
 
 config CRYPTO_NHPOLY1305_NEON
diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index 4922c4451e7c..286e3514d34c 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -86,7 +86,7 @@ config CRYPTO_AES_ARM64_CE_CCM
 config CRYPTO_AES_ARM64_CE_BLK
 	tristate "AES in ECB/CBC/CTR/XTS modes using ARMv8 Crypto Extensions"
 	depends on KERNEL_MODE_NEON
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_AES_ARM64_CE
 	select CRYPTO_AES_ARM64
 	select CRYPTO_SIMD
@@ -94,7 +94,7 @@ config CRYPTO_AES_ARM64_CE_BLK
 config CRYPTO_AES_ARM64_NEON_BLK
 	tristate "AES in ECB/CBC/CTR/XTS modes using NEON instructions"
 	depends on KERNEL_MODE_NEON
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_AES_ARM64
 	select CRYPTO_LIB_AES
 	select CRYPTO_SIMD
@@ -102,7 +102,7 @@ config CRYPTO_AES_ARM64_NEON_BLK
 config CRYPTO_CHACHA20_NEON
 	tristate "ChaCha20, XChaCha20, and XChaCha12 stream ciphers using NEON instructions"
 	depends on KERNEL_MODE_NEON
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_CHACHA20
 
 config CRYPTO_NHPOLY1305_NEON
@@ -113,7 +113,7 @@ config CRYPTO_NHPOLY1305_NEON
 config CRYPTO_AES_ARM64_BS
 	tristate "AES in ECB/CBC/CTR/XTS modes using bit-sliced NEON algorithm"
 	depends on KERNEL_MODE_NEON
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_AES_ARM64_NEON_BLK
 	select CRYPTO_AES_ARM64
 	select CRYPTO_LIB_AES
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 320548b4dfa9..44a47f1bb59e 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -52,12 +52,12 @@ config CRYPTO_AEAD2
 	select CRYPTO_NULL2
 	select CRYPTO_RNG2
 
-config CRYPTO_BLKCIPHER
+config CRYPTO_SKCIPHER
 	tristate
-	select CRYPTO_BLKCIPHER2
+	select CRYPTO_SKCIPHER2
 	select CRYPTO_ALGAPI
 
-config CRYPTO_BLKCIPHER2
+config CRYPTO_SKCIPHER2
 	tristate
 	select CRYPTO_ALGAPI2
 	select CRYPTO_RNG2
@@ -123,7 +123,7 @@ config CRYPTO_MANAGER2
 	def_tristate CRYPTO_MANAGER || (CRYPTO_MANAGER!=n && CRYPTO_ALGAPI=y)
 	select CRYPTO_AEAD2
 	select CRYPTO_HASH2
-	select CRYPTO_BLKCIPHER2
+	select CRYPTO_SKCIPHER2
 	select CRYPTO_AKCIPHER2
 	select CRYPTO_KPP2
 	select CRYPTO_ACOMP2
@@ -169,7 +169,7 @@ config CRYPTO_NULL
 config CRYPTO_NULL2
 	tristate
 	select CRYPTO_ALGAPI2
-	select CRYPTO_BLKCIPHER2
+	select CRYPTO_SKCIPHER2
 	select CRYPTO_HASH2
 
 config CRYPTO_PCRYPT
@@ -184,7 +184,7 @@ config CRYPTO_PCRYPT
 
 config CRYPTO_CRYPTD
 	tristate "Software async crypto daemon"
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_HASH
 	select CRYPTO_MANAGER
 	help
@@ -195,7 +195,7 @@ config CRYPTO_CRYPTD
 config CRYPTO_AUTHENC
 	tristate "Authenc support"
 	select CRYPTO_AEAD
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_MANAGER
 	select CRYPTO_HASH
 	select CRYPTO_NULL
@@ -217,7 +217,7 @@ config CRYPTO_SIMD
 config CRYPTO_GLUE_HELPER_X86
 	tristate
 	depends on X86
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 
 config CRYPTO_ENGINE
 	tristate
@@ -323,7 +323,7 @@ config CRYPTO_AEGIS128_AESNI_SSE2
 config CRYPTO_SEQIV
 	tristate "Sequence Number IV Generator"
 	select CRYPTO_AEAD
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_NULL
 	select CRYPTO_RNG_DEFAULT
 	select CRYPTO_MANAGER
@@ -346,7 +346,7 @@ comment "Block modes"
 
 config CRYPTO_CBC
 	tristate "CBC support"
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_MANAGER
 	help
 	  CBC: Cipher Block Chaining mode
@@ -354,7 +354,7 @@ config CRYPTO_CBC
 
 config CRYPTO_CFB
 	tristate "CFB support"
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_MANAGER
 	help
 	  CFB: Cipher FeedBack mode
@@ -362,7 +362,7 @@ config CRYPTO_CFB
 
 config CRYPTO_CTR
 	tristate "CTR support"
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_SEQIV
 	select CRYPTO_MANAGER
 	help
@@ -371,7 +371,7 @@ config CRYPTO_CTR
 
 config CRYPTO_CTS
 	tristate "CTS support"
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_MANAGER
 	help
 	  CTS: Cipher Text Stealing
@@ -386,7 +386,7 @@ config CRYPTO_CTS
 
 config CRYPTO_ECB
 	tristate "ECB support"
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_MANAGER
 	help
 	  ECB: Electronic CodeBook mode
@@ -395,7 +395,7 @@ config CRYPTO_ECB
 
 config CRYPTO_LRW
 	tristate "LRW support"
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_MANAGER
 	select CRYPTO_GF128MUL
 	help
@@ -407,7 +407,7 @@ config CRYPTO_LRW
 
 config CRYPTO_OFB
 	tristate "OFB support"
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_MANAGER
 	help
 	  OFB: the Output Feedback mode makes a block cipher into a synchronous
@@ -419,7 +419,7 @@ config CRYPTO_OFB
 
 config CRYPTO_PCBC
 	tristate "PCBC support"
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_MANAGER
 	help
 	  PCBC: Propagating Cipher Block Chaining mode
@@ -427,7 +427,7 @@ config CRYPTO_PCBC
 
 config CRYPTO_XTS
 	tristate "XTS support"
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_MANAGER
 	select CRYPTO_ECB
 	help
@@ -437,7 +437,7 @@ config CRYPTO_XTS
 
 config CRYPTO_KEYWRAP
 	tristate "Key wrapping support"
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_MANAGER
 	help
 	  Support for key wrapping (NIST SP800-38F / RFC3394) without
@@ -1068,7 +1068,7 @@ config CRYPTO_AES_NI_INTEL
 	select CRYPTO_AEAD
 	select CRYPTO_LIB_AES
 	select CRYPTO_ALGAPI
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_GLUE_HELPER_X86 if 64BIT
 	select CRYPTO_SIMD
 	help
@@ -1098,7 +1098,7 @@ config CRYPTO_AES_NI_INTEL
 config CRYPTO_AES_SPARC64
 	tristate "AES cipher algorithms (SPARC64)"
 	depends on SPARC64
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	help
 	  Use SPARC64 crypto opcodes for AES algorithm.
 
@@ -1125,7 +1125,7 @@ config CRYPTO_AES_SPARC64
 config CRYPTO_AES_PPC_SPE
 	tristate "AES cipher algorithms (PPC SPE)"
 	depends on PPC && SPE
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	help
 	  AES cipher algorithms (FIPS-197). Additionally the acceleration
 	  for popular block cipher modes ECB, CBC, CTR and XTS is supported.
@@ -1155,7 +1155,7 @@ config CRYPTO_LIB_ARC4
 
 config CRYPTO_ARC4
 	tristate "ARC4 cipher algorithm"
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_ARC4
 	help
 	  ARC4 cipher algorithm.
@@ -1191,7 +1191,7 @@ config CRYPTO_BLOWFISH_COMMON
 config CRYPTO_BLOWFISH_X86_64
 	tristate "Blowfish cipher algorithm (x86_64)"
 	depends on X86 && 64BIT
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_BLOWFISH_COMMON
 	help
 	  Blowfish cipher algorithm (x86_64), by Bruce Schneier.
@@ -1222,7 +1222,7 @@ config CRYPTO_CAMELLIA_X86_64
 	tristate "Camellia cipher algorithm (x86_64)"
 	depends on X86 && 64BIT
 	depends on CRYPTO
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_GLUE_HELPER_X86
 	help
 	  Camellia cipher algorithm module (x86_64).
@@ -1239,7 +1239,7 @@ config CRYPTO_CAMELLIA_AESNI_AVX_X86_64
 	tristate "Camellia cipher algorithm (x86_64/AES-NI/AVX)"
 	depends on X86 && 64BIT
 	depends on CRYPTO
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_CAMELLIA_X86_64
 	select CRYPTO_GLUE_HELPER_X86
 	select CRYPTO_SIMD
@@ -1276,7 +1276,7 @@ config CRYPTO_CAMELLIA_SPARC64
 	depends on SPARC64
 	depends on CRYPTO
 	select CRYPTO_ALGAPI
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	help
 	  Camellia cipher algorithm module (SPARC64).
 
@@ -1305,7 +1305,7 @@ config CRYPTO_CAST5
 config CRYPTO_CAST5_AVX_X86_64
 	tristate "CAST5 (CAST-128) cipher algorithm (x86_64/AVX)"
 	depends on X86 && 64BIT
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_CAST5
 	select CRYPTO_CAST_COMMON
 	select CRYPTO_SIMD
@@ -1327,7 +1327,7 @@ config CRYPTO_CAST6
 config CRYPTO_CAST6_AVX_X86_64
 	tristate "CAST6 (CAST-256) cipher algorithm (x86_64/AVX)"
 	depends on X86 && 64BIT
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_CAST6
 	select CRYPTO_CAST_COMMON
 	select CRYPTO_GLUE_HELPER_X86
@@ -1355,7 +1355,7 @@ config CRYPTO_DES_SPARC64
 	depends on SPARC64
 	select CRYPTO_ALGAPI
 	select CRYPTO_LIB_DES
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	help
 	  DES cipher algorithm (FIPS 46-2), and Triple DES EDE (FIPS 46-3),
 	  optimized using SPARC64 crypto opcodes.
@@ -1363,7 +1363,7 @@ config CRYPTO_DES_SPARC64
 config CRYPTO_DES3_EDE_X86_64
 	tristate "Triple DES EDE cipher algorithm (x86-64)"
 	depends on X86 && 64BIT
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_DES
 	help
 	  Triple DES EDE (FIPS 46-3) algorithm.
@@ -1376,7 +1376,7 @@ config CRYPTO_DES3_EDE_X86_64
 config CRYPTO_FCRYPT
 	tristate "FCrypt cipher algorithm"
 	select CRYPTO_ALGAPI
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	help
 	  FCrypt algorithm used by RxRPC.
 
@@ -1395,7 +1395,7 @@ config CRYPTO_KHAZAD
 
 config CRYPTO_SALSA20
 	tristate "Salsa20 stream cipher algorithm"
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	help
 	  Salsa20 stream cipher algorithm.
 
@@ -1407,7 +1407,7 @@ config CRYPTO_SALSA20
 
 config CRYPTO_CHACHA20
 	tristate "ChaCha stream cipher algorithms"
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	help
 	  The ChaCha20, XChaCha20, and XChaCha12 stream cipher algorithms.
 
@@ -1429,7 +1429,7 @@ config CRYPTO_CHACHA20
 config CRYPTO_CHACHA20_X86_64
 	tristate "ChaCha stream cipher algorithms (x86_64/SSSE3/AVX2/AVX-512VL)"
 	depends on X86 && 64BIT
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_CHACHA20
 	help
 	  SSSE3, AVX2, and AVX-512VL optimized implementations of the ChaCha20,
@@ -1465,7 +1465,7 @@ config CRYPTO_SERPENT
 config CRYPTO_SERPENT_SSE2_X86_64
 	tristate "Serpent cipher algorithm (x86_64/SSE2)"
 	depends on X86 && 64BIT
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_GLUE_HELPER_X86
 	select CRYPTO_SERPENT
 	select CRYPTO_SIMD
@@ -1484,7 +1484,7 @@ config CRYPTO_SERPENT_SSE2_X86_64
 config CRYPTO_SERPENT_SSE2_586
 	tristate "Serpent cipher algorithm (i586/SSE2)"
 	depends on X86 && !64BIT
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_GLUE_HELPER_X86
 	select CRYPTO_SERPENT
 	select CRYPTO_SIMD
@@ -1503,7 +1503,7 @@ config CRYPTO_SERPENT_SSE2_586
 config CRYPTO_SERPENT_AVX_X86_64
 	tristate "Serpent cipher algorithm (x86_64/AVX)"
 	depends on X86 && 64BIT
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_GLUE_HELPER_X86
 	select CRYPTO_SERPENT
 	select CRYPTO_SIMD
@@ -1634,7 +1634,7 @@ config CRYPTO_TWOFISH_X86_64
 config CRYPTO_TWOFISH_X86_64_3WAY
 	tristate "Twofish cipher algorithm (x86_64, 3-way parallel)"
 	depends on X86 && 64BIT
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_TWOFISH_COMMON
 	select CRYPTO_TWOFISH_X86_64
 	select CRYPTO_GLUE_HELPER_X86
@@ -1655,7 +1655,7 @@ config CRYPTO_TWOFISH_X86_64_3WAY
 config CRYPTO_TWOFISH_AVX_X86_64
 	tristate "Twofish cipher algorithm (x86_64/AVX)"
 	depends on X86 && 64BIT
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_GLUE_HELPER_X86
 	select CRYPTO_SIMD
 	select CRYPTO_TWOFISH_COMMON
@@ -1806,7 +1806,7 @@ config CRYPTO_USER_API_HASH
 config CRYPTO_USER_API_SKCIPHER
 	tristate "User-space interface for symmetric key cipher algorithms"
 	depends on NET
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_USER_API
 	help
 	  This option enables the user-spaces interface for symmetric
@@ -1825,7 +1825,7 @@ config CRYPTO_USER_API_AEAD
 	tristate "User-space interface for AEAD cipher algorithms"
 	depends on NET
 	select CRYPTO_AEAD
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_NULL
 	select CRYPTO_USER_API
 	help
diff --git a/crypto/Makefile b/crypto/Makefile
index 220d86271923..1e7ab34fead1 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -15,9 +15,9 @@ obj-$(CONFIG_CRYPTO_ALGAPI2) += crypto_algapi.o
 
 obj-$(CONFIG_CRYPTO_AEAD2) += aead.o
 
-crypto_blkcipher-y := ablkcipher.o
-crypto_blkcipher-y += skcipher.o
-obj-$(CONFIG_CRYPTO_BLKCIPHER2) += crypto_blkcipher.o
+crypto_skcipher-y := ablkcipher.o
+crypto_skcipher-y += skcipher.o
+obj-$(CONFIG_CRYPTO_SKCIPHER2) += crypto_skcipher.o
 obj-$(CONFIG_CRYPTO_SEQIV) += seqiv.o
 obj-$(CONFIG_CRYPTO_ECHAINIV) += echainiv.o
 
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 23d3fd97f678..13fbad8e940e 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -26,7 +26,7 @@ config CRYPTO_DEV_PADLOCK
 config CRYPTO_DEV_PADLOCK_AES
 	tristate "PadLock driver for AES algorithm"
 	depends on CRYPTO_DEV_PADLOCK
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_AES
 	help
 	  Use VIA PadLock for AES algorithm.
@@ -54,7 +54,7 @@ config CRYPTO_DEV_GEODE
 	tristate "Support for the Geode LX AES engine"
 	depends on X86_32 && PCI
 	select CRYPTO_ALGAPI
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	help
 	  Say 'Y' here to use the AMD Geode LX processor on-board AES
 	  engine for the CryptoAPI AES algorithm.
@@ -107,7 +107,7 @@ config CRYPTO_PAES_S390
 	depends on ZCRYPT
 	depends on PKEY
 	select CRYPTO_ALGAPI
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	help
 	  This is the s390 hardware accelerated implementation of the
 	  AES cipher algorithms for use with protected key.
@@ -169,7 +169,7 @@ config CRYPTO_DES_S390
 	tristate "DES and Triple DES cipher algorithms"
 	depends on S390
 	select CRYPTO_ALGAPI
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_DES
 	help
 	  This is the s390 hardware accelerated implementation of the
@@ -182,7 +182,7 @@ config CRYPTO_AES_S390
 	tristate "AES cipher algorithms"
 	depends on S390
 	select CRYPTO_ALGAPI
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	help
 	  This is the s390 hardware accelerated implementation of the
 	  AES cipher algorithms (FIPS-197).
@@ -236,7 +236,7 @@ config CRYPTO_DEV_MARVELL_CESA
 	depends on PLAT_ORION || ARCH_MVEBU
 	select CRYPTO_LIB_AES
 	select CRYPTO_LIB_DES
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_HASH
 	select SRAM
 	help
@@ -248,7 +248,7 @@ config CRYPTO_DEV_MARVELL_CESA
 config CRYPTO_DEV_NIAGARA2
        tristate "Niagara2 Stream Processing Unit driver"
        select CRYPTO_LIB_DES
-       select CRYPTO_BLKCIPHER
+       select CRYPTO_SKCIPHER
        select CRYPTO_HASH
        select CRYPTO_MD5
        select CRYPTO_SHA1
@@ -265,7 +265,7 @@ config CRYPTO_DEV_NIAGARA2
 config CRYPTO_DEV_HIFN_795X
 	tristate "Driver HIFN 795x crypto accelerator chips"
 	select CRYPTO_LIB_DES
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select HW_RANDOM if CRYPTO_DEV_HIFN_795X_RNG
 	depends on PCI
 	depends on !ARCH_DMA_ADDR_T_64BIT
@@ -285,7 +285,7 @@ config CRYPTO_DEV_TALITOS
 	tristate "Talitos Freescale Security Engine (SEC)"
 	select CRYPTO_AEAD
 	select CRYPTO_AUTHENC
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_HASH
 	select HW_RANDOM
 	depends on FSL_SOC
@@ -323,7 +323,7 @@ config CRYPTO_DEV_IXP4XX
 	select CRYPTO_LIB_DES
 	select CRYPTO_AEAD
 	select CRYPTO_AUTHENC
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	help
 	  Driver for the IXP4xx NPE crypto engine.
 
@@ -336,7 +336,7 @@ config CRYPTO_DEV_PPC4XX
 	select CRYPTO_CCM
 	select CRYPTO_CTR
 	select CRYPTO_GCM
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	help
 	  This option allows you to have support for AMCC crypto acceleration.
 
@@ -373,7 +373,7 @@ config CRYPTO_DEV_OMAP_AES
 	tristate "Support for OMAP AES hw engine"
 	depends on ARCH_OMAP2 || ARCH_OMAP3 || ARCH_OMAP2PLUS
 	select CRYPTO_AES
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_ENGINE
 	select CRYPTO_CBC
 	select CRYPTO_ECB
@@ -387,7 +387,7 @@ config CRYPTO_DEV_OMAP_DES
 	tristate "Support for OMAP DES/3DES hw engine"
 	depends on ARCH_OMAP2PLUS
 	select CRYPTO_LIB_DES
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_ENGINE
 	help
 	  OMAP processors have DES/3DES module accelerator. Select this if you
@@ -403,7 +403,7 @@ config CRYPTO_DEV_PICOXCELL
 	select CRYPTO_AEAD
 	select CRYPTO_AES
 	select CRYPTO_AUTHENC
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_DES
 	select CRYPTO_CBC
 	select CRYPTO_ECB
@@ -418,7 +418,7 @@ config CRYPTO_DEV_PICOXCELL
 config CRYPTO_DEV_SAHARA
 	tristate "Support for SAHARA crypto accelerator"
 	depends on ARCH_MXC && OF
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_AES
 	select CRYPTO_ECB
 	help
@@ -445,7 +445,7 @@ config CRYPTO_DEV_S5P
 	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
 	depends on HAS_IOMEM
 	select CRYPTO_AES
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	help
 	  This option allows you to have support for S5P crypto acceleration.
 	  Select this to offload Samsung S5PV210 or S5PC110, Exynos from AES
@@ -505,7 +505,7 @@ config CRYPTO_DEV_ATMEL_AES
 	depends on ARCH_AT91 || COMPILE_TEST
 	select CRYPTO_AES
 	select CRYPTO_AEAD
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	help
 	  Some Atmel processors have AES hw accelerator.
 	  Select this if you want to use the Atmel module for
@@ -518,7 +518,7 @@ config CRYPTO_DEV_ATMEL_TDES
 	tristate "Support for Atmel DES/TDES hw accelerator"
 	depends on ARCH_AT91 || COMPILE_TEST
 	select CRYPTO_LIB_DES
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	help
 	  Some Atmel processors have DES/TDES hw accelerator.
 	  Select this if you want to use the Atmel module for
@@ -590,7 +590,7 @@ config CRYPTO_DEV_MXS_DCP
 	select CRYPTO_CBC
 	select CRYPTO_ECB
 	select CRYPTO_AES
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_HASH
 	help
 	  The Freescale i.MX23/i.MX28 has SHA1/SHA256 and AES128 CBC/ECB
@@ -620,7 +620,7 @@ config CRYPTO_DEV_QCE
 	select CRYPTO_CBC
 	select CRYPTO_XTS
 	select CRYPTO_CTR
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	help
 	  This driver supports Qualcomm crypto engine accelerator
 	  hardware. To compile this driver as a module, choose M here. The
@@ -665,7 +665,7 @@ config CRYPTO_DEV_SUN4I_SS
 	select CRYPTO_SHA1
 	select CRYPTO_AES
 	select CRYPTO_LIB_DES
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	help
 	  Some Allwinner SoC have a crypto accelerator named
 	  Security System. Select this if you want to use it.
@@ -692,7 +692,7 @@ config CRYPTO_DEV_ROCKCHIP
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
 	select CRYPTO_HASH
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 
 	help
 	  This driver interfaces with the hardware crypto accelerator.
@@ -703,7 +703,7 @@ config CRYPTO_DEV_MEDIATEK
 	depends on (ARM && ARCH_MEDIATEK) || COMPILE_TEST
 	select CRYPTO_AES
 	select CRYPTO_AEAD
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_CTR
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
@@ -741,7 +741,7 @@ config CRYPTO_DEV_SAFEXCEL
 	depends on OF || PCI || COMPILE_TEST
 	select CRYPTO_LIB_AES
 	select CRYPTO_AUTHENC
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_DES
 	select CRYPTO_HASH
 	select CRYPTO_HMAC
@@ -765,7 +765,7 @@ config CRYPTO_DEV_ARTPEC6
 	select CRYPTO_AEAD
 	select CRYPTO_AES
 	select CRYPTO_ALGAPI
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_CTR
 	select CRYPTO_HASH
 	select CRYPTO_SHA1
@@ -782,7 +782,7 @@ config CRYPTO_DEV_CCREE
 	depends on CRYPTO && CRYPTO_HW && OF && HAS_DMA
 	default n
 	select CRYPTO_HASH
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_DES
 	select CRYPTO_AEAD
 	select CRYPTO_AUTHENC
diff --git a/drivers/crypto/amlogic/Kconfig b/drivers/crypto/amlogic/Kconfig
index 5c81a4ad0fae..b90850d18965 100644
--- a/drivers/crypto/amlogic/Kconfig
+++ b/drivers/crypto/amlogic/Kconfig
@@ -1,7 +1,7 @@
 config CRYPTO_DEV_AMLOGIC_GXL
 	tristate "Support for amlogic cryptographic offloader"
 	default y if ARCH_MESON
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_ENGINE
 	select CRYPTO_ECB
 	select CRYPTO_CBC
diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
index 137ed3df0c74..87053e46c788 100644
--- a/drivers/crypto/caam/Kconfig
+++ b/drivers/crypto/caam/Kconfig
@@ -97,7 +97,7 @@ config CRYPTO_DEV_FSL_CAAM_CRYPTO_API
 	select CRYPTO_DEV_FSL_CAAM_CRYPTO_API_DESC
 	select CRYPTO_AEAD
 	select CRYPTO_AUTHENC
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_DES
 	help
 	  Selecting this will offload crypto for users of the
@@ -110,7 +110,7 @@ config CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI
 	default y
 	select CRYPTO_DEV_FSL_CAAM_CRYPTO_API_DESC
 	select CRYPTO_AUTHENC
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_DES
 	help
 	  Selecting this will use CAAM Queue Interface (QI) for sending
@@ -158,7 +158,7 @@ config CRYPTO_DEV_FSL_DPAA2_CAAM
 	select CRYPTO_DEV_FSL_CAAM_COMMON
 	select CRYPTO_DEV_FSL_CAAM_CRYPTO_API_DESC
 	select CRYPTO_DEV_FSL_CAAM_AHASH_API_DESC
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_AUTHENC
 	select CRYPTO_AEAD
 	select CRYPTO_HASH
diff --git a/drivers/crypto/cavium/nitrox/Kconfig b/drivers/crypto/cavium/nitrox/Kconfig
index 7b1e751bb9cd..7dc008332a81 100644
--- a/drivers/crypto/cavium/nitrox/Kconfig
+++ b/drivers/crypto/cavium/nitrox/Kconfig
@@ -4,7 +4,7 @@
 #
 config CRYPTO_DEV_NITROX
 	tristate
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_AES
 	select CRYPTO_LIB_DES
 	select FW_LOADER
diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
index 8fec733f567f..e0a8bd15aa74 100644
--- a/drivers/crypto/ccp/Kconfig
+++ b/drivers/crypto/ccp/Kconfig
@@ -27,7 +27,7 @@ config CRYPTO_DEV_CCP_CRYPTO
 	depends on CRYPTO_DEV_CCP_DD
 	depends on CRYPTO_DEV_SP_CCP
 	select CRYPTO_HASH
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_AUTHENC
 	select CRYPTO_RSA
 	select CRYPTO_LIB_AES
diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
index a71f2bfaf084..1598468286be 100644
--- a/drivers/crypto/hisilicon/Kconfig
+++ b/drivers/crypto/hisilicon/Kconfig
@@ -2,7 +2,7 @@
 
 config CRYPTO_DEV_HISI_SEC
 	tristate "Support for Hisilicon SEC crypto block cipher accelerator"
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_ALGAPI
 	select CRYPTO_LIB_DES
 	select SG_SPLIT
diff --git a/drivers/crypto/qat/Kconfig b/drivers/crypto/qat/Kconfig
index 6ab7e5a88756..2006322345de 100644
--- a/drivers/crypto/qat/Kconfig
+++ b/drivers/crypto/qat/Kconfig
@@ -3,7 +3,7 @@ config CRYPTO_DEV_QAT
 	tristate
 	select CRYPTO_AEAD
 	select CRYPTO_AUTHENC
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_AKCIPHER
 	select CRYPTO_DH
 	select CRYPTO_HMAC
diff --git a/drivers/crypto/ux500/Kconfig b/drivers/crypto/ux500/Kconfig
index b1c6f739f77b..b731895aa241 100644
--- a/drivers/crypto/ux500/Kconfig
+++ b/drivers/crypto/ux500/Kconfig
@@ -8,7 +8,7 @@ config CRYPTO_DEV_UX500_CRYP
 	tristate "UX500 crypto driver for CRYP block"
 	depends on CRYPTO_DEV_UX500
 	select CRYPTO_ALGAPI
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_DES
 	help
         This selects the crypto driver for the UX500_CRYP hardware. It supports
diff --git a/drivers/crypto/virtio/Kconfig b/drivers/crypto/virtio/Kconfig
index 01b625e4e5ad..fb294174e408 100644
--- a/drivers/crypto/virtio/Kconfig
+++ b/drivers/crypto/virtio/Kconfig
@@ -3,7 +3,7 @@ config CRYPTO_DEV_VIRTIO
 	tristate "VirtIO crypto driver"
 	depends on VIRTIO
 	select CRYPTO_AEAD
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_ENGINE
 	default m
 	help
diff --git a/drivers/net/wireless/cisco/Kconfig b/drivers/net/wireless/cisco/Kconfig
index 01e173ede894..7a3b3bb2ce15 100644
--- a/drivers/net/wireless/cisco/Kconfig
+++ b/drivers/net/wireless/cisco/Kconfig
@@ -17,7 +17,7 @@ config AIRO
 	depends on CFG80211 && ISA_DMA_API && (PCI || BROKEN)
 	select WIRELESS_EXT
 	select CRYPTO
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select WEXT_SPY
 	select WEXT_PRIV
 	---help---
diff --git a/net/bluetooth/Kconfig b/net/bluetooth/Kconfig
index 3803135c88ff..165148c7c4ce 100644
--- a/net/bluetooth/Kconfig
+++ b/net/bluetooth/Kconfig
@@ -9,7 +9,7 @@ menuconfig BT
 	depends on RFKILL || !RFKILL
 	select CRC16
 	select CRYPTO
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_AES
 	imply CRYPTO_AES
 	select CRYPTO_CMAC
diff --git a/net/rxrpc/Kconfig b/net/rxrpc/Kconfig
index 05610c3a3d25..57ebb29c26ad 100644
--- a/net/rxrpc/Kconfig
+++ b/net/rxrpc/Kconfig
@@ -49,7 +49,7 @@ config RXKAD
 	depends on AF_RXRPC
 	select CRYPTO
 	select CRYPTO_MANAGER
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_PCBC
 	select CRYPTO_FCRYPT
 	help
diff --git a/net/xfrm/Kconfig b/net/xfrm/Kconfig
index 51bb6018f3bf..3981bc0d9e6c 100644
--- a/net/xfrm/Kconfig
+++ b/net/xfrm/Kconfig
@@ -16,7 +16,7 @@ config XFRM_ALGO
 	select XFRM
 	select CRYPTO
 	select CRYPTO_HASH
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 
 if INET
 config XFRM_USER
-- 
2.23.0

