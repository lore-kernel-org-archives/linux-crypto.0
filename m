Return-Path: <SRS0=rMEF=NS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:47506 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbeKGTJ6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Nov 2018 14:09:58 -0500
From: Vladimir Murzin <vladimir.murzin@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: yamada.masahiro@socionext.com, linux-crypto@vger.kernel.org,
        linux-kbuild@vger.kernel.org, kbuild-all@01.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 4/4] ARM: crypto: expose dependency on gas via Kconfig
Date: Wed,  7 Nov 2018 09:40:08 +0000
Message-Id: <1541583608-26375-5-git-send-email-vladimir.murzin@arm.com>
In-Reply-To: <1541583608-26375-1-git-send-email-vladimir.murzin@arm.com>
References: <1541583608-26375-1-git-send-email-vladimir.murzin@arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

So we can advertise only those entries which dependency is satisfied.

Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 arch/arm/crypto/Kconfig  | 31 +++++++++++++++++++++----------
 arch/arm/crypto/Makefile | 31 ++++++-------------------------
 2 files changed, 27 insertions(+), 35 deletions(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index ef0c7fe..f437a91f 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -9,6 +9,12 @@ menuconfig ARM_CRYPTO
 
 if ARM_CRYPTO
 
+config ARM_AS_HAS_CE
+	def_bool $(as-instr,.fpu crypto-neon-fp-armv8)
+
+config ARM_AS_HAS_CRC
+	def_bool $(as-instr,.arch armv8-a\n.arch_extension crc)
+
 config CRYPTO_SHA1_ARM
 	tristate "SHA1 digest algorithm (ARM-asm)"
 	select CRYPTO_SHA1
@@ -30,21 +36,21 @@ config CRYPTO_SHA1_ARM_NEON
 
 config CRYPTO_SHA1_ARM_CE
 	tristate "SHA1 digest algorithm (ARM v8 Crypto Extensions)"
-	depends on KERNEL_MODE_NEON
+	depends on KERNEL_MODE_NEON && ARM_AS_HAS_CE
 	select CRYPTO_SHA1_ARM
 	select CRYPTO_HASH
 	help
 	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2) implemented
-	  using special ARMv8 Crypto Extensions.
+	  using special ARMv8 Crypto Extensions (need binutils 2.23 or higher).
 
 config CRYPTO_SHA2_ARM_CE
 	tristate "SHA-224/256 digest algorithm (ARM v8 Crypto Extensions)"
-	depends on KERNEL_MODE_NEON
+	depends on KERNEL_MODE_NEON && ARM_AS_HAS_CE
 	select CRYPTO_SHA256_ARM
 	select CRYPTO_HASH
 	help
 	  SHA-256 secure hash standard (DFIPS 180-2) implemented
-	  using special ARMv8 Crypto Extensions.
+	  using special ARMv8 Crypto Extensions (need binutils 2.23 or higher).
 
 config CRYPTO_SHA256_ARM
 	tristate "SHA-224/256 digest algorithm (ARM-asm and NEON)"
@@ -87,16 +93,16 @@ config CRYPTO_AES_ARM_BS
 
 config CRYPTO_AES_ARM_CE
 	tristate "Accelerated AES using ARMv8 Crypto Extensions"
-	depends on KERNEL_MODE_NEON
+	depends on KERNEL_MODE_NEON && ARM_AS_HAS_CE
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_SIMD
 	help
 	  Use an implementation of AES in CBC, CTR and XTS modes that uses
-	  ARMv8 Crypto Extensions
+	  ARMv8 Crypto Extensions (need binutils 2.23 or higher)
 
 config CRYPTO_GHASH_ARM_CE
 	tristate "PMULL-accelerated GHASH using NEON/ARMv8 Crypto Extensions"
-	depends on KERNEL_MODE_NEON
+	depends on KERNEL_MODE_NEON && ARM_AS_HAS_CE
 	select CRYPTO_HASH
 	select CRYPTO_CRYPTD
 	select CRYPTO_GF128MUL
@@ -104,17 +110,22 @@ config CRYPTO_GHASH_ARM_CE
 	  Use an implementation of GHASH (used by the GCM AEAD chaining mode)
 	  that uses the 64x64 to 128 bit polynomial multiplication (vmull.p64)
 	  that is part of the ARMv8 Crypto Extensions, or a slower variant that
-	  uses the vmull.p8 instruction that is part of the basic NEON ISA.
+	  uses the vmull.p8 instruction that is part of the basic NEON ISA (need
+	  binutils 2.23 or higher).
 
 config CRYPTO_CRCT10DIF_ARM_CE
 	tristate "CRCT10DIF digest algorithm using PMULL instructions"
-	depends on KERNEL_MODE_NEON && CRC_T10DIF
+	depends on KERNEL_MODE_NEON && CRC_T10DIF  && ARM_AS_HAS_CE
 	select CRYPTO_HASH
+	help
+	  Need binutils 2.23 or higher
 
 config CRYPTO_CRC32_ARM_CE
 	tristate "CRC32(C) digest algorithm using CRC and/or PMULL instructions"
-	depends on KERNEL_MODE_NEON && CRC32
+	depends on KERNEL_MODE_NEON && CRC32 && ARM_AS_HAS_CRC
 	select CRYPTO_HASH
+	help
+	  Need binutils 2.23 or higher
 
 config CRYPTO_CHACHA20_NEON
 	tristate "NEON accelerated ChaCha20 symmetric cipher"
diff --git a/arch/arm/crypto/Makefile b/arch/arm/crypto/Makefile
index bd5bcee..e897327 100644
--- a/arch/arm/crypto/Makefile
+++ b/arch/arm/crypto/Makefile
@@ -11,32 +11,13 @@ obj-$(CONFIG_CRYPTO_SHA256_ARM) += sha256-arm.o
 obj-$(CONFIG_CRYPTO_SHA512_ARM) += sha512-arm.o
 obj-$(CONFIG_CRYPTO_CHACHA20_NEON) += chacha20-neon.o
 
-ce-obj-$(CONFIG_CRYPTO_AES_ARM_CE) += aes-arm-ce.o
-ce-obj-$(CONFIG_CRYPTO_SHA1_ARM_CE) += sha1-arm-ce.o
-ce-obj-$(CONFIG_CRYPTO_SHA2_ARM_CE) += sha2-arm-ce.o
-ce-obj-$(CONFIG_CRYPTO_GHASH_ARM_CE) += ghash-arm-ce.o
-ce-obj-$(CONFIG_CRYPTO_CRCT10DIF_ARM_CE) += crct10dif-arm-ce.o
-crc-obj-$(CONFIG_CRYPTO_CRC32_ARM_CE) += crc32-arm-ce.o
+obj-$(CONFIG_CRYPTO_AES_ARM_CE) += aes-arm-ce.o
+obj-$(CONFIG_CRYPTO_SHA1_ARM_CE) += sha1-arm-ce.o
+obj-$(CONFIG_CRYPTO_SHA2_ARM_CE) += sha2-arm-ce.o
+obj-$(CONFIG_CRYPTO_GHASH_ARM_CE) += ghash-arm-ce.o
+obj-$(CONFIG_CRYPTO_CRCT10DIF_ARM_CE) += crct10dif-arm-ce.o
 
-ifneq ($(crc-obj-y)$(crc-obj-m),)
-ifeq ($(call as-instr,.arch armv8-a\n.arch_extension crc,y,n),y)
-ce-obj-y += $(crc-obj-y)
-ce-obj-m += $(crc-obj-m)
-else
-$(warning These CRC Extensions modules need binutils 2.23 or higher)
-$(warning $(crc-obj-y) $(crc-obj-m))
-endif
-endif
-
-ifneq ($(ce-obj-y)$(ce-obj-m),)
-ifeq ($(call as-instr,.fpu crypto-neon-fp-armv8,y,n),y)
-obj-y += $(ce-obj-y)
-obj-m += $(ce-obj-m)
-else
-$(warning These ARMv8 Crypto Extensions modules need binutils 2.23 or higher)
-$(warning $(ce-obj-y) $(ce-obj-m))
-endif
-endif
+obj-$(CONFIG_CRYPTO_CRC32_ARM_CE) += crc32-arm-ce.o
 
 aes-arm-y	:= aes-cipher-core.o aes-cipher-glue.o
 aes-arm-bs-y	:= aes-neonbs-core.o aes-neonbs-glue.o
-- 
1.9.1
