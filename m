From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 6/7] crypto: aes - add meaningful help text to the various AES drivers
Date: Tue, 20 Jun 2017 11:28:59 +0200
Message-ID: <1497950940-24243-7-git-send-email-ard.biesheuvel@linaro.org>
References: <1497950940-24243-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, nico@linaro.org, ebiggers3@gmail.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:38785 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751078AbdFTJ3M (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jun 2017 05:29:12 -0400
Received: by mail-wm0-f41.google.com with SMTP id u195so14359167wmd.1
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jun 2017 02:29:11 -0700 (PDT)
In-Reply-To: <1497950940-24243-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove the duplicated boilerplate help text and add a bit of
explanation about the nature of the various AES implementations that
exist for various architectures. In particular, highlight the time
variant nature of some implementations, and the fact that they can be
omitted if required.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/Kconfig   |  16 ++-
 arch/arm64/crypto/Kconfig |  30 +++-
 crypto/Kconfig            | 144 +++++++-------------
 3 files changed, 92 insertions(+), 98 deletions(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index 3a6994ada2d1..d8f3336bfc88 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -62,11 +62,23 @@ config CRYPTO_SHA512_ARM
 	  using optimized ARM assembler and NEON, when available.
 
 config CRYPTO_AES_ARM
-	tristate "Scalar AES cipher for ARM"
+	tristate "Table based AES cipher for 32-bit ARM"
 	select CRYPTO_ALGAPI
 	select CRYPTO_AES_GENERIC
 	help
-	  Use optimized AES assembler routines for ARM platforms.
+	  Table based implementation in 32-bit ARM assembler of the FIPS-197
+	  Advanced Encryption Standard (AES) symmetric cipher algorithm. This
+	  driver reuses the tables exposed by the generic AES driver.
+
+	  For CPUs that lack the special ARMv8-CE instructions, this is the
+	  fastest implementation available of the core cipher, but it may be
+	  susceptible to known-plaintext attacks on the key due to the
+	  correlation between the processing time and the input of the first
+	  round. Therefore, it is recommended to also enable the time invariant
+	  NEON based driver below (CRYPTO_AES_ARM_BS), which will supersede
+	  this driver on NEON capable CPUs when using AES in CBC, CTR and XTS
+	  modes. If time invariance is a requirement, this driver should not
+	  be enabled.
 
 config CRYPTO_AES_ARM_BS
 	tristate "Bit sliced AES using NEON instructions"
diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index 7ffe88267943..4fb3e519b43f 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -42,13 +42,37 @@ config CRYPTO_CRC32_ARM64_CE
 	select CRYPTO_HASH
 
 config CRYPTO_AES_ARM64
-	tristate "AES core cipher using scalar instructions"
+	tristate "Table based AES cipher for 64-bit ARM"
 	select CRYPTO_AES_GENERIC
+	help
+	  Table based implementation in 64-bit ARM assembler of the FIPS-197
+	  Advanced Encryption Standard (AES) symmetric cipher algorithm. This
+	  driver reuses the tables exposed by the generic AES driver.
+
+	  For CPUs that lack the special ARMv8-CE instructions, this is the
+	  fastest implementation available of the core cipher, but it may be
+	  susceptible to known-plaintext attacks on the key due to the
+	  correlation between the processing time and the input of the first
+	  round. Therefore, it is recommended to also enable the time invariant
+	  drivers below (CRYPTO_AES_ARM64_NEON_BLK and CRYPTO_AES_ARM64_BS),
+	  which will supersede this driver when using AES in the specific modes
+	  that they implement. If time invariance is a requirement, this driver
+	  should not be enabled.
 
 config CRYPTO_AES_ARM64_CE
-	tristate "AES core cipher using ARMv8 Crypto Extensions"
-	depends on ARM64 && KERNEL_MODE_NEON
+	tristate "AES cipher using ARMv8 Crypto Extensions"
+	depends on KERNEL_MODE_NEON
 	select CRYPTO_ALGAPI
+	help
+	  Implementation in assembler of the FIPS-197 Advanced Encryption
+	  Standard (AES) symmetric cipher algorithm, using instructions from
+	  ARM's optional ARMv8 Crypto Extensions. This implementation is time
+	  invariant, and is by far the preferred option for CPUs that support
+	  this extension.
+
+	  If in doubt, enable as a module: it will be loaded automatically on
+	  CPUs that support it, and supersede other implementations of the AES
+	  cipher.
 
 config CRYPTO_AES_ARM64_CE_CCM
 	tristate "AES in CCM mode using ARMv8 Crypto Extensions"
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 9ae3dade4b2b..87d9e03dcb74 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -902,37 +902,31 @@ config CRYPTO_AES
 	select CRYPTO_AES_GENERIC
 
 config CRYPTO_AES_GENERIC
-	tristate "AES cipher algorithms"
+	tristate "Generic table based AES cipher"
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
+	  Generic table based implementation of the FIPS-197 Advanced
+	  Encryption Standard (AES) symmetric cipher algorithm. This is
+	  the fastest implementation in C, but may be susceptible to known
+	  plaintext attacks on the key due to the correlation between the
+	  processing time and the input of the first round. If time
+	  invariance is a requirement, this driver should not be enabled,
+	  and the fixed time variant below (CRYPTO_AES_TI) should be selected
+	  instead.
 
 config CRYPTO_AES_TI
-	tristate "Fixed time AES cipher"
+	tristate "Generic fixed time AES cipher"
 	select CRYPTO_ALGAPI
 	select CRYPTO_AES_CORE
 	help
-	  This is a generic implementation of AES that attempts to eliminate
-	  data dependent latencies as much as possible without affecting
-	  performance too much. It is intended for use by the generic CCM
-	  and GCM drivers, and other CTR or CMAC/XCBC based modes that rely
-	  solely on encryption (although decryption is supported as well, but
-	  with a more dramatic performance hit)
+	  Alternative generic implementation of the FIPS-197 Advanced
+	  Encryption Standard (AES) symmetric cipher algorithm, offering a
+	  different tradeoff between security, performance and memory and
+	  D-cache footprint. Most notably, decryption is substantially slower
+	  than encryption when using this driver, which makes it more suitable
+	  for AES based stream ciphers and MAC algorithms (which rely on
+	  encryption only) than for block ciphers such as CBC or XTS.
 
 	  Instead of using 16 lookup tables of 1 KB each, (8 for encryption and
 	  8 for decryption), this implementation only uses just two S-boxes of
@@ -941,51 +935,37 @@ config CRYPTO_AES_TI
 	  block.
 
 config CRYPTO_AES_586
-	tristate "AES cipher algorithms (i586)"
+	tristate "Table based AES cipher for 32-bit x86"
 	depends on (X86 || UML_X86) && !64BIT
 	select CRYPTO_ALGAPI
 	select CRYPTO_AES_GENERIC
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
-	  See <http://csrc.nist.gov/encryption/aes/> for more information.
+	  Table based implementation in 32-bit x86 assembler of the FIPS-197
+	  Advanced Encryption Standard (AES) symmetric cipher algorithm. For
+	  older 32-bit x86 CPUs that lack the special AES-NI instructions, it
+	  is the fastest implementation available, but it may be susceptible to
+	  known-plaintext attacks on the key due to the correlation between the
+	  processing time and the input of the first round. It reuses the
+	  tables exposed by the generic AES driver. If time invariance is a
+	  requirement, this driver should not be enabled.
 
 config CRYPTO_AES_X86_64
-	tristate "AES cipher algorithms (x86_64)"
+	tristate "Table based AES cipher for 64-bit x86"
 	depends on (X86 || UML_X86) && 64BIT
 	select CRYPTO_ALGAPI
 	select CRYPTO_AES_GENERIC
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
-	  See <http://csrc.nist.gov/encryption/aes/> for more information.
+	  Table based implementation in 64-bit x86 assembler of the FIPS-197
+	  Advanced Encryption Standard (AES) symmetric cipher algorithm. For
+	  older 64-bit x86 CPUs that lack the special AES-NI instructions, it
+	  is the fastest implementation available, but it may be susceptible to
+	  known-plaintext attacks on the key due to the correlation between the
+	  processing time and the input of the first round. It reuses the
+	  tables exposed by the generic AES driver. If time invariance is a
+	  requirement, this driver should not be enabled.
 
 config CRYPTO_AES_NI_INTEL
-	tristate "AES cipher algorithms (AES-NI)"
+	tristate "AES cipher for x86 using AES-NI instructions"
 	depends on X86
 	select CRYPTO_AEAD
 	select CRYPTO_AES_CORE
@@ -994,52 +974,29 @@ config CRYPTO_AES_NI_INTEL
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
+	  Implementation in x86 assembler of the FIPS-197 Advanced Encryption
+	  Standard (AES) symmetric cipher algorithm, using instructions from
+	  Intel's optional AES-NI ISA extension. This implementation is time
+	  invariant, and is by far the preferred option for CPUs that support
+	  this extension.
 
 	  In addition to AES cipher algorithm support, the acceleration
 	  for some popular block cipher mode is supported too, including
 	  ECB, CBC, LRW, PCBC, XTS. The 64 bit version has additional
 	  acceleration for CTR.
 
+	  If in doubt, enable as a module: it will be loaded automatically on
+	  CPUs that support it, and supersede other implementations of the AES
+	  cipher.
+
 config CRYPTO_AES_SPARC64
-	tristate "AES cipher algorithms (SPARC64)"
+	tristate "AES cipher for SPARC64 using crypto opcodes"
 	depends on SPARC64
 	select CRYPTO_CRYPTD
 	select CRYPTO_ALGAPI
 	help
-	  Use SPARC64 crypto opcodes for AES algorithm.
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
+	  Implementation of the FIPS-197 Advanced Encryption Standard (AES)
+	  symmetric cipher algorithm, using SPARC64 crypto opcodes.
 
 	  In addition to AES cipher algorithm support, the acceleration
 	  for some popular block cipher mode is supported too, including
@@ -1049,8 +1006,9 @@ config CRYPTO_AES_PPC_SPE
 	tristate "AES cipher algorithms (PPC SPE)"
 	depends on PPC && SPE
 	help
-	  AES cipher algorithms (FIPS-197). Additionally the acceleration
-	  for popular block cipher modes ECB, CBC, CTR and XTS is supported.
+	  Implementation of the FIPS-197 Advanced Encryption Standard (AES)
+	  symmetric cipher algorithm. Additionally, the acceleration for
+	  popular block cipher modes ECB, CBC, CTR and XTS is supported.
 	  This module should only be used for low power (router) devices
 	  without hardware AES acceleration (e.g. caam crypto). It reduces the
 	  size of the AES tables from 16KB to 8KB + 256 bytes and mitigates
-- 
2.7.4
