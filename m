From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 1/6] drivers/crypto/Kconfig: drop bogus CRYPTO_AES dependencies
Date: Fri, 16 Jun 2017 13:17:44 +0200
Message-ID: <1497611869-6126-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1497611869-6126-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, nico@linaro.org, ebiggers3@gmail.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:38469 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752603AbdFPLSA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Jun 2017 07:18:00 -0400
Received: by mail-wm0-f45.google.com with SMTP id u195so9195582wmd.1
        for <linux-crypto@vger.kernel.org>; Fri, 16 Jun 2017 04:18:00 -0700 (PDT)
In-Reply-To: <1497611869-6126-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In preparation of fine tuning the dependency relations between the
accelerated AES drivers and the core support code, let's remove the
dependency declarations that are false. None of these modules have
link time dependencies on the generic AES code, nor do they declare
any AES algos with CRYPTO_ALG_NEED_FALLBACK, so they can function
perfectly fine without crypto/aes_generic.o loaded.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/Kconfig | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 0528a62a39a6..7a737c1c669e 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -419,7 +419,6 @@ config CRYPTO_DEV_S5P
 	tristate "Support for Samsung S5PV210/Exynos crypto accelerator"
 	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
 	depends on HAS_IOMEM && HAS_DMA
-	select CRYPTO_AES
 	select CRYPTO_BLKCIPHER
 	help
 	  This option allows you to have support for S5P crypto acceleration.
@@ -473,7 +472,6 @@ config CRYPTO_DEV_ATMEL_AES
 	tristate "Support for Atmel AES hw accelerator"
 	depends on HAS_DMA
 	depends on ARCH_AT91 || COMPILE_TEST
-	select CRYPTO_AES
 	select CRYPTO_AEAD
 	select CRYPTO_BLKCIPHER
 	help
@@ -591,7 +589,6 @@ config CRYPTO_DEV_SUN4I_SS
 	depends on ARCH_SUNXI && !64BIT
 	select CRYPTO_MD5
 	select CRYPTO_SHA1
-	select CRYPTO_AES
 	select CRYPTO_DES
 	select CRYPTO_BLKCIPHER
 	help
@@ -606,7 +603,6 @@ config CRYPTO_DEV_SUN4I_SS
 config CRYPTO_DEV_ROCKCHIP
 	tristate "Rockchip's Cryptographic Engine driver"
 	depends on OF && ARCH_ROCKCHIP
-	select CRYPTO_AES
 	select CRYPTO_DES
 	select CRYPTO_MD5
 	select CRYPTO_SHA1
@@ -622,7 +618,6 @@ config CRYPTO_DEV_MEDIATEK
 	tristate "MediaTek's EIP97 Cryptographic Engine driver"
 	depends on HAS_DMA
 	depends on (ARM && ARCH_MEDIATEK) || COMPILE_TEST
-	select CRYPTO_AES
 	select CRYPTO_AEAD
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_CTR
-- 
2.7.4
