From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 1/8] drivers/crypto/Kconfig: drop bogus CRYPTO_AES dependencies
Date: Tue, 18 Jul 2017 13:06:38 +0100
Message-ID: <20170718120645.15880-2-ard.biesheuvel@linaro.org>
References: <20170718120645.15880-1-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        nico@linaro.org, ebiggers@google.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:36856 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751322AbdGRMG5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 08:06:57 -0400
Received: by mail-wr0-f171.google.com with SMTP id y43so26220548wrd.3
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jul 2017 05:06:57 -0700 (PDT)
In-Reply-To: <20170718120645.15880-1-ard.biesheuvel@linaro.org>
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
index 5b5393f1b87a..46a48ea99fb9 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -432,7 +432,6 @@ config CRYPTO_DEV_S5P
 	tristate "Support for Samsung S5PV210/Exynos crypto accelerator"
 	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
 	depends on HAS_IOMEM && HAS_DMA
-	select CRYPTO_AES
 	select CRYPTO_BLKCIPHER
 	help
 	  This option allows you to have support for S5P crypto acceleration.
@@ -486,7 +485,6 @@ config CRYPTO_DEV_ATMEL_AES
 	tristate "Support for Atmel AES hw accelerator"
 	depends on HAS_DMA
 	depends on ARCH_AT91 || COMPILE_TEST
-	select CRYPTO_AES
 	select CRYPTO_AEAD
 	select CRYPTO_BLKCIPHER
 	help
@@ -618,7 +616,6 @@ config CRYPTO_DEV_SUN4I_SS
 	depends on ARCH_SUNXI && !64BIT
 	select CRYPTO_MD5
 	select CRYPTO_SHA1
-	select CRYPTO_AES
 	select CRYPTO_DES
 	select CRYPTO_BLKCIPHER
 	help
@@ -641,7 +638,6 @@ config CRYPTO_DEV_SUN4I_SS_PRNG
 config CRYPTO_DEV_ROCKCHIP
 	tristate "Rockchip's Cryptographic Engine driver"
 	depends on OF && ARCH_ROCKCHIP
-	select CRYPTO_AES
 	select CRYPTO_DES
 	select CRYPTO_MD5
 	select CRYPTO_SHA1
@@ -657,7 +653,6 @@ config CRYPTO_DEV_MEDIATEK
 	tristate "MediaTek's EIP97 Cryptographic Engine driver"
 	depends on HAS_DMA
 	depends on (ARM && ARCH_MEDIATEK) || COMPILE_TEST
-	select CRYPTO_AES
 	select CRYPTO_AEAD
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_CTR
-- 
2.9.3
