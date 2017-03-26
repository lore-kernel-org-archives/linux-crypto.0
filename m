From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 7/7] crypto: aes - allow alternative AES drivers to fulfil AES dependency
Date: Sun, 26 Mar 2017 19:49:08 +0100
Message-ID: <1490554148-10953-8-git-send-email-ard.biesheuvel@linaro.org>
References: <1490554148-10953-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: nico@linaro.org, ebiggers3@gmail.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:36239 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751668AbdCZSvE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 26 Mar 2017 14:51:04 -0400
Received: by mail-wr0-f169.google.com with SMTP id w11so15508865wrc.3
        for <linux-crypto@vger.kernel.org>; Sun, 26 Mar 2017 11:49:34 -0700 (PDT)
In-Reply-To: <1490554148-10953-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Allow other AES drivers than crypto/aes_generic.o to fulfil soft
dependencies on AES. This allows CRYPTO_AES to be disabled if no
hard dependencies on it are enabled.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/Kconfig   | 1 +
 arch/arm64/crypto/Kconfig | 1 +
 crypto/Kconfig            | 9 ++++++++-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index 10c9d0c7e615..91b282cf7a99 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -65,6 +65,7 @@ config CRYPTO_AES_ARM
 	tristate "Scalar AES cipher for ARM"
 	select CRYPTO_ALGAPI
 	select CRYPTO_AES_CORE
+	select CRYPTO_HAVE_AES
 	help
 	  Use optimized AES assembler routines for ARM platforms.
 
diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index c5b04627a721..e1fbf8b78d7c 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -44,6 +44,7 @@ config CRYPTO_CRC32_ARM64_CE
 config CRYPTO_AES_ARM64
 	tristate "AES core cipher using scalar instructions"
 	select CRYPTO_AES_CORE
+	select CRYPTO_HAVE_AES
 
 config CRYPTO_AES_ARM64_CE
 	tristate "AES core cipher using ARMv8 Crypto Extensions"
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 1ba4e836077b..3a16e58992bc 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -896,7 +896,11 @@ comment "Ciphers"
 
 config CRYPTO_NEED_AES
 	tristate
-	select CRYPTO_AES
+	select CRYPTO_AES if (CRYPTO_NEED_AES=y && CRYPTO_HAVE_AES != y) || \
+			     (CRYPTO_NEED_AES=m && !CRYPTO_HAVE_AES)
+
+config CRYPTO_HAVE_AES
+	tristate
 
 config CRYPTO_AES
 	tristate "AES cipher algorithms"
@@ -927,6 +931,7 @@ config CRYPTO_AES_CORE
 config CRYPTO_AES_TI
 	tristate "Fixed time AES cipher"
 	select CRYPTO_ALGAPI
+	select CRYPTO_HAVE_AES
 	help
 	  This is a generic implementation of AES that attempts to eliminate
 	  data dependent latencies as much as possible without affecting
@@ -946,6 +951,7 @@ config CRYPTO_AES_586
 	depends on (X86 || UML_X86) && !64BIT
 	select CRYPTO_ALGAPI
 	select CRYPTO_AES_CORE
+	select CRYPTO_HAVE_AES
 	help
 	  AES cipher algorithms (FIPS-197). AES uses the Rijndael
 	  algorithm.
@@ -968,6 +974,7 @@ config CRYPTO_AES_X86_64
 	depends on (X86 || UML_X86) && 64BIT
 	select CRYPTO_ALGAPI
 	select CRYPTO_AES_CORE
+	select CRYPTO_HAVE_AES
 	help
 	  AES cipher algorithms (FIPS-197). AES uses the Rijndael
 	  algorithm.
-- 
2.7.4
