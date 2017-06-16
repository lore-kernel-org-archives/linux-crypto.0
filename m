From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 4/6] crypto: aes - repurpose CRYPTO_AES and introduce CRYPTO_AES_GENERIC
Date: Fri, 16 Jun 2017 13:17:47 +0200
Message-ID: <1497611869-6126-5-git-send-email-ard.biesheuvel@linaro.org>
References: <1497611869-6126-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, nico@linaro.org, ebiggers3@gmail.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:36352 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752636AbdFPLSF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Jun 2017 07:18:05 -0400
Received: by mail-wm0-f54.google.com with SMTP id m125so23233084wmm.1
        for <linux-crypto@vger.kernel.org>; Fri, 16 Jun 2017 04:18:04 -0700 (PDT)
In-Reply-To: <1497611869-6126-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Repurpose the Kconfig symbol CRYPTO_AES to signify that a 'select' or
'depends on' relationship on it can be satisfied by any driver that
exposes a "aes" cipher.

The existing generic AES code is now controlled by a new Kconfig symbol
CRYPTO_AES_GENERIC, and only dependencies on CRYPTO_AES that truly depend
on its exported lookup tables are updated accordingly.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/Kconfig   | 2 +-
 arch/arm64/crypto/Kconfig | 2 +-
 crypto/Kconfig            | 8 ++++++--
 crypto/Makefile           | 2 +-
 net/sunrpc/Kconfig        | 3 ++-
 5 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index fd77aebcb7a9..3a6994ada2d1 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -64,7 +64,7 @@ config CRYPTO_SHA512_ARM
 config CRYPTO_AES_ARM
 	tristate "Scalar AES cipher for ARM"
 	select CRYPTO_ALGAPI
-	select CRYPTO_AES
+	select CRYPTO_AES_GENERIC
 	help
 	  Use optimized AES assembler routines for ARM platforms.
 
diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index db55e069c17b..7ffe88267943 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -43,7 +43,7 @@ config CRYPTO_CRC32_ARM64_CE
 
 config CRYPTO_AES_ARM64
 	tristate "AES core cipher using scalar instructions"
-	select CRYPTO_AES
+	select CRYPTO_AES_GENERIC
 
 config CRYPTO_AES_ARM64_CE
 	tristate "AES core cipher using ARMv8 Crypto Extensions"
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 1e6e021fda10..9ae3dade4b2b 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -898,6 +898,10 @@ config CRYPTO_AES_CORE
 	tristate
 
 config CRYPTO_AES
+	tristate
+	select CRYPTO_AES_GENERIC
+
+config CRYPTO_AES_GENERIC
 	tristate "AES cipher algorithms"
 	select CRYPTO_ALGAPI
 	select CRYPTO_AES_CORE
@@ -940,7 +944,7 @@ config CRYPTO_AES_586
 	tristate "AES cipher algorithms (i586)"
 	depends on (X86 || UML_X86) && !64BIT
 	select CRYPTO_ALGAPI
-	select CRYPTO_AES
+	select CRYPTO_AES_GENERIC
 	help
 	  AES cipher algorithms (FIPS-197). AES uses the Rijndael
 	  algorithm.
@@ -962,7 +966,7 @@ config CRYPTO_AES_X86_64
 	tristate "AES cipher algorithms (x86_64)"
 	depends on (X86 || UML_X86) && 64BIT
 	select CRYPTO_ALGAPI
-	select CRYPTO_AES
+	select CRYPTO_AES_GENERIC
 	help
 	  AES cipher algorithms (FIPS-197). AES uses the Rijndael
 	  algorithm.
diff --git a/crypto/Makefile b/crypto/Makefile
index 0979ca461ddb..73395307bcea 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -97,7 +97,7 @@ obj-$(CONFIG_CRYPTO_TWOFISH_COMMON) += twofish_common.o
 obj-$(CONFIG_CRYPTO_SERPENT) += serpent_generic.o
 CFLAGS_serpent_generic.o := $(call cc-option,-fsched-pressure)  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=79149
 obj-$(CONFIG_CRYPTO_AES_CORE) += aes_core.o
-obj-$(CONFIG_CRYPTO_AES) += aes_generic.o
+obj-$(CONFIG_CRYPTO_AES_GENERIC) += aes_generic.o
 obj-$(CONFIG_CRYPTO_AES_TI) += aes_ti.o
 obj-$(CONFIG_CRYPTO_CAMELLIA) += camellia_generic.o
 obj-$(CONFIG_CRYPTO_CAST_COMMON) += cast_common.o
diff --git a/net/sunrpc/Kconfig b/net/sunrpc/Kconfig
index ac09ca803296..58aa2ada40b3 100644
--- a/net/sunrpc/Kconfig
+++ b/net/sunrpc/Kconfig
@@ -19,7 +19,8 @@ config RPCSEC_GSS_KRB5
 	tristate "Secure RPC: Kerberos V mechanism"
 	depends on SUNRPC && CRYPTO
 	depends on CRYPTO_MD5 && CRYPTO_DES && CRYPTO_CBC && CRYPTO_CTS
-	depends on CRYPTO_ECB && CRYPTO_HMAC && CRYPTO_SHA1 && CRYPTO_AES
+	depends on CRYPTO_ECB && CRYPTO_HMAC && CRYPTO_SHA1
+	select CRYPTO_AES
 	depends on CRYPTO_ARC4
 	default y
 	select SUNRPC_GSS
-- 
2.7.4
