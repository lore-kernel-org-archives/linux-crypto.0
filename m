From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/7] drivers/crypto/Kconfig: drop bogus CRYPTO_AES dependencies
Date: Sun, 26 Mar 2017 19:49:02 +0100
Message-ID: <1490554148-10953-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1490554148-10953-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: nico@linaro.org, ebiggers3@gmail.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:36412 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751571AbdCZSzj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 26 Mar 2017 14:55:39 -0400
Received: by mail-wr0-f180.google.com with SMTP id w11so15630074wrc.3
        for <linux-crypto@vger.kernel.org>; Sun, 26 Mar 2017 11:55:38 -0700 (PDT)
In-Reply-To: <1490554148-10953-1-git-send-email-ard.biesheuvel@linaro.org>
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
index 1a60626937e4..0cbc5b33d92d 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -392,7 +392,6 @@ config CRYPTO_DEV_S5P
 	tristate "Support for Samsung S5PV210/Exynos crypto accelerator"
 	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
 	depends on HAS_IOMEM && HAS_DMA
-	select CRYPTO_AES
 	select CRYPTO_BLKCIPHER
 	help
 	  This option allows you to have support for S5P crypto acceleration.
@@ -446,7 +445,6 @@ config CRYPTO_DEV_ATMEL_AES
 	tristate "Support for Atmel AES hw accelerator"
 	depends on HAS_DMA
 	depends on ARCH_AT91 || COMPILE_TEST
-	select CRYPTO_AES
 	select CRYPTO_AEAD
 	select CRYPTO_BLKCIPHER
 	help
@@ -563,7 +561,6 @@ config CRYPTO_DEV_SUN4I_SS
 	depends on ARCH_SUNXI && !64BIT
 	select CRYPTO_MD5
 	select CRYPTO_SHA1
-	select CRYPTO_AES
 	select CRYPTO_DES
 	select CRYPTO_BLKCIPHER
 	help
@@ -578,7 +575,6 @@ config CRYPTO_DEV_SUN4I_SS
 config CRYPTO_DEV_ROCKCHIP
 	tristate "Rockchip's Cryptographic Engine driver"
 	depends on OF && ARCH_ROCKCHIP
-	select CRYPTO_AES
 	select CRYPTO_DES
 	select CRYPTO_MD5
 	select CRYPTO_SHA1
@@ -594,7 +590,6 @@ config CRYPTO_DEV_MEDIATEK
 	tristate "MediaTek's EIP97 Cryptographic Engine driver"
 	depends on HAS_DMA
 	depends on (ARM && ARCH_MEDIATEK) || COMPILE_TEST
-	select CRYPTO_AES
 	select CRYPTO_AEAD
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_CTR
-- 
2.7.4
