From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 19/47] crypto: remove blackfin CRC driver
Date: Wed, 14 Mar 2018 16:35:32 +0100
Message-ID: <20180314153603.3127932-20-arnd@arndb.de>
References: <20180314153603.3127932-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180314153603.3127932-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The blackfin architecture is getting removed, so this
driver won't be used any more.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/Kconfig    |   7 -
 drivers/crypto/Makefile   |   1 -
 drivers/crypto/bfin_crc.c | 753 ----------------------------------------------
 drivers/crypto/bfin_crc.h | 124 --------
 4 files changed, 885 deletions(-)
 delete mode 100644 drivers/crypto/bfin_crc.c
 delete mode 100644 drivers/crypto/bfin_crc.h

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 5c4106979cc9..d1ea1a07cecb 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -464,13 +464,6 @@ if CRYPTO_DEV_UX500
 	source "drivers/crypto/ux500/Kconfig"
 endif # if CRYPTO_DEV_UX500
 
-config CRYPTO_DEV_BFIN_CRC
-	tristate "Support for Blackfin CRC hardware"
-	depends on BF60x
-	help
-	  Newer Blackfin processors have CRC hardware. Select this if you
-	  want to use the Blackfin CRC module.
-
 config CRYPTO_DEV_ATMEL_AUTHENC
 	tristate "Support for Atmel IPSEC/SSL hw accelerator"
 	depends on HAS_DMA
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index ee5ec5c94383..7ae87b4f6c8d 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -3,7 +3,6 @@ obj-$(CONFIG_CRYPTO_DEV_ATMEL_AES) += atmel-aes.o
 obj-$(CONFIG_CRYPTO_DEV_ATMEL_SHA) += atmel-sha.o
 obj-$(CONFIG_CRYPTO_DEV_ATMEL_TDES) += atmel-tdes.o
 obj-$(CONFIG_CRYPTO_DEV_ATMEL_ECC) += atmel-ecc.o
-obj-$(CONFIG_CRYPTO_DEV_BFIN_CRC) += bfin_crc.o
 obj-$(CONFIG_CRYPTO_DEV_CAVIUM_ZIP) += cavium/
 obj-$(CONFIG_CRYPTO_DEV_CCP) += ccp/
 obj-$(CONFIG_CRYPTO_DEV_CCREE) += ccree/
diff --git a/drivers/crypto/bfin_crc.c b/drivers/crypto/bfin_crc.c
deleted file mode 100644
index cfc4d682d55a..000000000000
diff --git a/drivers/crypto/bfin_crc.h b/drivers/crypto/bfin_crc.h
deleted file mode 100644
index 786ef746d109..000000000000
-- 
2.9.0
