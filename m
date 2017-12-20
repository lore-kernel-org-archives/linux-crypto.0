From: Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH] crypto: stm32 - Use standard CONFIG name
Date: Wed, 20 Dec 2017 18:19:32 +0000
Message-ID: <1513793972-11173-1-git-send-email-clabbe@baylibre.com>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        mcoquelin.stm32@gmail.com, alexandre.torgue@st.com,
        lionel.debieve@st.com, fabien.dessenne@st.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

All hardware crypto devices have their CONFIG names using the following
convention:
CRYPTO_DEV_name_algo

This patch apply this conventions on STM32 CONFIG names.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/stm32/Kconfig  | 6 +++---
 drivers/crypto/stm32/Makefile | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/stm32/Kconfig b/drivers/crypto/stm32/Kconfig
index 61ef00b6bf45..63aa78c0b12b 100644
--- a/drivers/crypto/stm32/Kconfig
+++ b/drivers/crypto/stm32/Kconfig
@@ -1,4 +1,4 @@
-config CRC_DEV_STM32
+config CRYPTO_DEV_STM32_CRC
 	tristate "Support for STM32 crc accelerators"
 	depends on ARCH_STM32
 	select CRYPTO_HASH
@@ -6,7 +6,7 @@ config CRC_DEV_STM32
           This enables support for the CRC32 hw accelerator which can be found
 	  on STMicroelectronics STM32 SOC.
 
-config HASH_DEV_STM32
+config CRYPTO_DEV_STM32_HASH
 	tristate "Support for STM32 hash accelerators"
 	depends on ARCH_STM32
 	depends on HAS_DMA
@@ -19,7 +19,7 @@ config HASH_DEV_STM32
           This enables support for the HASH hw accelerator which can be found
 	  on STMicroelectronics STM32 SOC.
 
-config CRYP_DEV_STM32
+config CRYPTO_DEV_STM32_CRYP
 	tristate "Support for STM32 cryp accelerators"
 	depends on ARCH_STM32
 	select CRYPTO_HASH
diff --git a/drivers/crypto/stm32/Makefile b/drivers/crypto/stm32/Makefile
index 2c19fc155bfd..53d1bb94b221 100644
--- a/drivers/crypto/stm32/Makefile
+++ b/drivers/crypto/stm32/Makefile
@@ -1,3 +1,3 @@
-obj-$(CONFIG_CRC_DEV_STM32) += stm32_crc32.o
-obj-$(CONFIG_HASH_DEV_STM32) += stm32-hash.o
-obj-$(CONFIG_CRYP_DEV_STM32) += stm32-cryp.o
+obj-$(CONFIG_CRYPTO_DEV_STM32_CRC) += stm32_crc32.o
+obj-$(CONFIG_CRYPTO_DEV_STM32_HASH) += stm32-hash.o
+obj-$(CONFIG_CRYPTO_DEV_STM32_CRYP) += stm32-cryp.o
-- 
2.13.6
