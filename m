From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 1/5] crypto/arm: move ARM specific Kconfig definitions to a dedicated file
Date: Tue, 10 Mar 2015 09:47:44 +0100
Message-ID: <1425977268-27835-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1425977268-27835-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: nico@linaro.org, will.deacon@arm.com,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: herbert@gondor.apana.org.au, jussi.kivilinna@iki.fi,
	linux-crypto@vger.kernel.org, linux@arm.linux.org.uk,
	linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:46287 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbbCJIsB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Mar 2015 04:48:01 -0400
Received: by wesk11 with SMTP id k11so48457wes.13
        for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2015 01:48:00 -0700 (PDT)
In-Reply-To: <1425977268-27835-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This moves all Kconfig symbols defined in crypto/Kconfig that depend
on CONFIG_ARM to a dedicated Kconfig file in arch/arm/crypto, which is
where the code that implements those features resides as well.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/Kconfig        |  3 ++
 arch/arm/crypto/Kconfig | 85 +++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/Kconfig          | 75 -------------------------------------------
 3 files changed, 88 insertions(+), 75 deletions(-)
 create mode 100644 arch/arm/crypto/Kconfig

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 9f1f09a2bc9b..e60da5ab8aec 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -2167,6 +2167,9 @@ source "arch/arm/Kconfig.debug"
 source "security/Kconfig"
 
 source "crypto/Kconfig"
+if CRYPTO
+source "arch/arm/crypto/Kconfig"
+endif
 
 source "lib/Kconfig"
 
diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
new file mode 100644
index 000000000000..66fe82857e99
--- /dev/null
+++ b/arch/arm/crypto/Kconfig
@@ -0,0 +1,85 @@
+
+menuconfig ARM_CRYPTO
+	bool "ARM Accelerated Cryptographic Algorithms"
+	depends on ARM
+	help
+	  Say Y here to choose from a selection of cryptographic algorithms
+	  implemented using ARM specific CPU features or instructions.
+
+if ARM_CRYPTO
+
+config CRYPTO_SHA1_ARM
+	tristate "SHA1 digest algorithm (ARM-asm)"
+	select CRYPTO_SHA1
+	select CRYPTO_HASH
+	help
+	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2) implemented
+	  using optimized ARM assembler.
+
+config CRYPTO_SHA1_ARM_NEON
+	tristate "SHA1 digest algorithm (ARM NEON)"
+	depends on KERNEL_MODE_NEON
+	select CRYPTO_SHA1_ARM
+	select CRYPTO_SHA1
+	select CRYPTO_HASH
+	help
+	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2) implemented
+	  using optimized ARM NEON assembly, when NEON instructions are
+	  available.
+
+config CRYPTO_SHA512_ARM_NEON
+	tristate "SHA384 and SHA512 digest algorithm (ARM NEON)"
+	depends on KERNEL_MODE_NEON
+	select CRYPTO_SHA512
+	select CRYPTO_HASH
+	help
+	  SHA-512 secure hash standard (DFIPS 180-2) implemented
+	  using ARM NEON instructions, when available.
+
+	  This version of SHA implements a 512 bit hash with 256 bits of
+	  security against collision attacks.
+
+	  This code also includes SHA-384, a 384 bit hash with 192 bits
+	  of security against collision attacks.
+
+config CRYPTO_AES_ARM
+	tristate "AES cipher algorithms (ARM-asm)"
+	depends on ARM
+	select CRYPTO_ALGAPI
+	select CRYPTO_AES
+	help
+	  Use optimized AES assembler routines for ARM platforms.
+
+	  AES cipher algorithms (FIPS-197). AES uses the Rijndael
+	  algorithm.
+
+	  Rijndael appears to be consistently a very good performer in
+	  both hardware and software across a wide range of computing
+	  environments regardless of its use in feedback or non-feedback
+	  modes. Its key setup time is excellent, and its key agility is
+	  good. Rijndael's very low memory requirements make it very well
+	  suited for restricted-space environments, in which it also
+	  demonstrates excellent performance. Rijndael's operations are
+	  among the easiest to defend against power and timing attacks.
+
+	  The AES specifies three key sizes: 128, 192 and 256 bits
+
+	  See <http://csrc.nist.gov/encryption/aes/> for more information.
+
+config CRYPTO_AES_ARM_BS
+	tristate "Bit sliced AES using NEON instructions"
+	depends on KERNEL_MODE_NEON
+	select CRYPTO_ALGAPI
+	select CRYPTO_AES_ARM
+	select CRYPTO_ABLK_HELPER
+	help
+	  Use a faster and more secure NEON based implementation of AES in CBC,
+	  CTR and XTS modes
+
+	  Bit sliced AES gives around 45% speedup on Cortex-A15 for CTR mode
+	  and for XTS mode encryption, CBC and XTS mode decryption speedup is
+	  around 25%. (CBC encryption speed is not affected by this driver.)
+	  This implementation does not rely on any lookup tables so it is
+	  believed to be invulnerable to cache timing attacks.
+
+endif
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 50f4da44a304..c50900b467c8 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -555,26 +555,6 @@ config CRYPTO_SHA1_SPARC64
 	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2) implemented
 	  using sparc64 crypto instructions, when available.
 
-config CRYPTO_SHA1_ARM
-	tristate "SHA1 digest algorithm (ARM-asm)"
-	depends on ARM
-	select CRYPTO_SHA1
-	select CRYPTO_HASH
-	help
-	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2) implemented
-	  using optimized ARM assembler.
-
-config CRYPTO_SHA1_ARM_NEON
-	tristate "SHA1 digest algorithm (ARM NEON)"
-	depends on ARM && KERNEL_MODE_NEON
-	select CRYPTO_SHA1_ARM
-	select CRYPTO_SHA1
-	select CRYPTO_HASH
-	help
-	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2) implemented
-	  using optimized ARM NEON assembly, when NEON instructions are
-	  available.
-
 config CRYPTO_SHA1_PPC
 	tristate "SHA1 digest algorithm (powerpc)"
 	depends on PPC
@@ -640,21 +620,6 @@ config CRYPTO_SHA512_SPARC64
 	  SHA-512 secure hash standard (DFIPS 180-2) implemented
 	  using sparc64 crypto instructions, when available.
 
-config CRYPTO_SHA512_ARM_NEON
-	tristate "SHA384 and SHA512 digest algorithm (ARM NEON)"
-	depends on ARM && KERNEL_MODE_NEON
-	select CRYPTO_SHA512
-	select CRYPTO_HASH
-	help
-	  SHA-512 secure hash standard (DFIPS 180-2) implemented
-	  using ARM NEON instructions, when available.
-
-	  This version of SHA implements a 512 bit hash with 256 bits of
-	  security against collision attacks.
-
-	  This code also includes SHA-384, a 384 bit hash with 192 bits
-	  of security against collision attacks.
-
 config CRYPTO_TGR192
 	tristate "Tiger digest algorithms"
 	select CRYPTO_HASH
@@ -817,46 +782,6 @@ config CRYPTO_AES_SPARC64
 	  for some popular block cipher mode is supported too, including
 	  ECB and CBC.
 
-config CRYPTO_AES_ARM
-	tristate "AES cipher algorithms (ARM-asm)"
-	depends on ARM
-	select CRYPTO_ALGAPI
-	select CRYPTO_AES
-	help
-	  Use optimized AES assembler routines for ARM platforms.
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
-
-config CRYPTO_AES_ARM_BS
-	tristate "Bit sliced AES using NEON instructions"
-	depends on ARM && KERNEL_MODE_NEON
-	select CRYPTO_ALGAPI
-	select CRYPTO_AES_ARM
-	select CRYPTO_ABLK_HELPER
-	help
-	  Use a faster and more secure NEON based implementation of AES in CBC,
-	  CTR and XTS modes
-
-	  Bit sliced AES gives around 45% speedup on Cortex-A15 for CTR mode
-	  and for XTS mode encryption, CBC and XTS mode decryption speedup is
-	  around 25%. (CBC encryption speed is not affected by this driver.)
-	  This implementation does not rely on any lookup tables so it is
-	  believed to be invulnerable to cache timing attacks.
-
 config CRYPTO_ANUBIS
 	tristate "Anubis cipher algorithm"
 	select CRYPTO_ALGAPI
-- 
1.8.3.2
