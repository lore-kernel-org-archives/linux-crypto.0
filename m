From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 8/8] crypto: aes - add meaningful help text to the various AES drivers
Date: Tue, 18 Jul 2017 13:06:45 +0100
Message-ID: <20170718120645.15880-9-ard.biesheuvel@linaro.org>
References: <20170718120645.15880-1-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        nico@linaro.org, ebiggers@google.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:35035 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751386AbdGRMHQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 08:07:16 -0400
Received: by mail-wr0-f180.google.com with SMTP id w4so25821627wrb.2
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jul 2017 05:07:15 -0700 (PDT)
In-Reply-To: <20170718120645.15880-1-ard.biesheuvel@linaro.org>
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
 arch/arm64/crypto/Kconfig |  30 +++++-
 crypto/Kconfig            | 104 +++++++-------------
 3 files changed, 75 insertions(+), 75 deletions(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index b9adedcc5b2e..f611127c5ef9 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -62,11 +62,23 @@ config CRYPTO_SHA512_ARM
 	  using optimized ARM assembler and NEON, when available.
 
 config CRYPTO_AES_ARM
-	tristate "Scalar AES cipher for ARM"
+	tristate "Table based AES cipher for 32-bit ARM"
 	select CRYPTO_ALGAPI
 	select CRYPTO_AES
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
index d92293747d63..bf38680a2dbb 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -42,13 +42,37 @@ config CRYPTO_CRC32_ARM64_CE
 	select CRYPTO_HASH
 
 config CRYPTO_AES_ARM64
-	tristate "AES core cipher using scalar instructions"
+	tristate "Table based AES cipher for 64-bit ARM"
 	select CRYPTO_AES
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
index 8f4b9f3381e2..9bec9f7a81d9 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -909,51 +909,37 @@ config CRYPTO_AES
 	  block.
 
 config CRYPTO_AES_586
-	tristate "AES cipher algorithms (i586)"
+	tristate "Table based AES cipher for 32-bit x86"
 	depends on (X86 || UML_X86) && !64BIT
 	select CRYPTO_ALGAPI
 	select CRYPTO_AES
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
 	select CRYPTO_AES
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
@@ -962,52 +948,29 @@ config CRYPTO_AES_NI_INTEL
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
@@ -1017,8 +980,9 @@ config CRYPTO_AES_PPC_SPE
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
2.9.3
