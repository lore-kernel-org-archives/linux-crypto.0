From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/2] crypto: CRYPTO_DEV_ATMEL_TDES and CRYPTO_DEV_ATMEL_SHA should depend on HAS_DMA
Date: Fri, 24 Feb 2017 11:27:38 +0100
Message-ID: <1487932059-31522-1-git-send-email-geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

If NO_DMA=y:

    ERROR: "bad_dma_ops" [drivers/crypto/atmel-tdes.ko] undefined!
    ERROR: "bad_dma_ops" [drivers/crypto/atmel-sha.ko] undefined!

Add dependencies on HAS_DMA to fix this.

Fixes: ceb4afb3086ab08f ("crypto: atmel - refine Kconfig dependencies")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/crypto/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 2cac445b02fde0f6..69f7fc0dc84dc3b9 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -445,6 +445,7 @@ config CRYPTO_DEV_ATMEL_AES
 
 config CRYPTO_DEV_ATMEL_TDES
 	tristate "Support for Atmel DES/TDES hw accelerator"
+	depends on HAS_DMA
 	depends on ARCH_AT91 || COMPILE_TEST
 	select CRYPTO_DES
 	select CRYPTO_BLKCIPHER
@@ -458,6 +459,7 @@ config CRYPTO_DEV_ATMEL_TDES
 
 config CRYPTO_DEV_ATMEL_SHA
 	tristate "Support for Atmel SHA hw accelerator"
+	depends on HAS_DMA
 	depends on ARCH_AT91 || COMPILE_TEST
 	select CRYPTO_HASH
 	help
-- 
2.7.4
