From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 5/6] crypto: aes - add meaningful help text to the various AES drivers
Date: Fri, 16 Jun 2017 13:17:48 +0200
Message-ID: <1497611869-6126-6-git-send-email-ard.biesheuvel@linaro.org>
References: <1497611869-6126-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, nico@linaro.org, ebiggers3@gmail.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:38513 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752603AbdFPLSG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Jun 2017 07:18:06 -0400
Received: by mail-wm0-f50.google.com with SMTP id u195so9197585wmd.1
        for <linux-crypto@vger.kernel.org>; Fri, 16 Jun 2017 04:18:05 -0700 (PDT)
In-Reply-To: <1497611869-6126-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove the duplicated boilerplate help text and add a bit of explanation
about the nature of the various AES implementations that exist for ARM
and x86.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/Kconfig   |  4 +-
 arch/arm64/crypto/Kconfig |  7 ++
 crypto/Kconfig            | 68 +++-----------------
 3 files changed, 18 insertions(+), 61 deletions(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index 3a6994ada2d1..24d70d74ae51 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -66,7 +66,9 @@ config CRYPTO_AES_ARM
 	select CRYPTO_ALGAPI
 	select CRYPTO_AES_GENERIC
 	help
-	  Use optimized AES assembler routines for ARM platforms.
+	  Use optimized AES assembler routines for ARM platforms. This
+	  implementation is table based, and thus not time invariant.
+	  It reuses the tables exposed by the generic AES driver.
 
 config CRYPTO_AES_ARM_BS
 	tristate "Bit sliced AES using NEON instructions"
diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index 7ffe88267943..48404ae2a11a 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -44,11 +44,18 @@ config CRYPTO_CRC32_ARM64_CE
 config CRYPTO_AES_ARM64
 	tristate "AES core cipher using scalar instructions"
 	select CRYPTO_AES_GENERIC
+	help
+	  Use optimized AES assembler routines for ARM platforms. This
+	  implementation is table based, and thus not time invariant.
+	  It reuses the tables exposed by the generic AES driver.
 
 config CRYPTO_AES_ARM64_CE
 	tristate "AES core cipher using ARMv8 Crypto Extensions"
 	depends on ARM64 && KERNEL_MODE_NEON
 	select CRYPTO_ALGAPI
+	help
+	  Assembler implementation for arm64 of AES using special dedicated
+	  instructions. This implementation is time invariant.
 
 config CRYPTO_AES_ARM64_CE_CCM
 	tristate "AES in CCM mode using ARMv8 Crypto Extensions"
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 9ae3dade4b2b..f33c0d9136cf 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -906,21 +906,10 @@ config CRYPTO_AES_GENERIC
 	select CRYPTO_ALGAPI
 	select CRYPTO_AES_CORE
 	help
-	  AES cipher algorithms (FIPS-197). AES uses the Rijndael
-	  algorithm.
-
-	  Rijndael appears to be consistently a very good performer in
-	  both hardware and software across a wide range of computing
-	  environments regardless of its use in feedback or non-feedback
-	  modes. Its key setup time is excellent, and its key agility is
-	  good. Rijndael's very low memory requirements make it very well
-	  suited for restricted-space environments, in which it also
-	  demonstrates excellent performance. Rijndael's operations are
-	  among the easiest to defend against power and timing attacks.
-
-	  The AES specifies three key sizes: 128, 192 and 256 bits
-
-	  See <http://csrc.nist.gov/CryptoToolkit/aes/> for more information.
+	  Generic table based implementation of AES. This is the fastest
+	  implementation in C, but may be susceptible to known plaintext
+	  attacks on the key due to the correlation between the processing
+	  time and the input of the first round.
 
 config CRYPTO_AES_TI
 	tristate "Fixed time AES cipher"
@@ -946,44 +935,18 @@ config CRYPTO_AES_586
 	select CRYPTO_ALGAPI
 	select CRYPTO_AES_GENERIC
 	help
-	  AES cipher algorithms (FIPS-197). AES uses the Rijndael
+	  Assembler implementation for 32-bit x86 of the table based AES
 	  algorithm.
 
-	  Rijndael appears to be consistently a very good performer in
-	  both hardware and software across a wide range of computing
-	  environments regardless of its use in feedback or non-feedback
-	  modes. Its key setup time is excellent, and its key agility is
-	  good. Rijndael's very low memory requirements make it very well
-	  suited for restricted-space environments, in which it also
-	  demonstrates excellent performance. Rijndael's operations are
-	  among the easiest to defend against power and timing attacks.
-
-	  The AES specifies three key sizes: 128, 192 and 256 bits
-
-	  See <http://csrc.nist.gov/encryption/aes/> for more information.
-
 config CRYPTO_AES_X86_64
 	tristate "AES cipher algorithms (x86_64)"
 	depends on (X86 || UML_X86) && 64BIT
 	select CRYPTO_ALGAPI
 	select CRYPTO_AES_GENERIC
 	help
-	  AES cipher algorithms (FIPS-197). AES uses the Rijndael
+	  Assembler implementation for 64-bit x86 of the table based AES
 	  algorithm.
 
-	  Rijndael appears to be consistently a very good performer in
-	  both hardware and software across a wide range of computing
-	  environments regardless of its use in feedback or non-feedback
-	  modes. Its key setup time is excellent, and its key agility is
-	  good. Rijndael's very low memory requirements make it very well
-	  suited for restricted-space environments, in which it also
-	  demonstrates excellent performance. Rijndael's operations are
-	  among the easiest to defend against power and timing attacks.
-
-	  The AES specifies three key sizes: 128, 192 and 256 bits
-
-	  See <http://csrc.nist.gov/encryption/aes/> for more information.
-
 config CRYPTO_AES_NI_INTEL
 	tristate "AES cipher algorithms (AES-NI)"
 	depends on X86
@@ -994,23 +957,8 @@ config CRYPTO_AES_NI_INTEL
 	select CRYPTO_GLUE_HELPER_X86 if 64BIT
 	select CRYPTO_SIMD
 	help
-	  Use Intel AES-NI instructions for AES algorithm.
-
-	  AES cipher algorithms (FIPS-197). AES uses the Rijndael
-	  algorithm.
-
-	  Rijndael appears to be consistently a very good performer in
-	  both hardware and software across a wide range of computing
-	  environments regardless of its use in feedback or non-feedback
-	  modes. Its key setup time is excellent, and its key agility is
-	  good. Rijndael's very low memory requirements make it very well
-	  suited for restricted-space environments, in which it also
-	  demonstrates excellent performance. Rijndael's operations are
-	  among the easiest to defend against power and timing attacks.
-
-	  The AES specifies three key sizes: 128, 192 and 256 bits
-
-	  See <http://csrc.nist.gov/encryption/aes/> for more information.
+	  Assembler implementation for x86 of AES using special dedicated
+	  instructions. This implementation is time invariant.
 
 	  In addition to AES cipher algorithm support, the acceleration
 	  for some popular block cipher mode is supported too, including
-- 
2.7.4
