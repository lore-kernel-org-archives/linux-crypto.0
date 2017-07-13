From: Lionel Debieve <lionel.debieve@st.com>
Subject: [PATCH 3/3] crypto: stm32 - Rename module to use generic crypto
Date: Thu, 13 Jul 2017 15:06:33 +0200
Message-ID: <709e171911529fda19a611e6c01dc161a0166901.1499950409.git.lionel.debieve@st.com>
References: <cover.1499950409.git.lionel.debieve@st.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Benjamin Gaignard <benjamin.gaignard@st.com>,
        Fabien Dessenne <fabien.dessenne@st.com>,
        Ludovic Barre <ludovic.barre@st.com>,
        Lionel Debieve <lionel.debieve@st.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1499950409.git.lionel.debieve@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The complete stm32 module is rename as crypto
in order to use generic naming

Signed-off-by: Lionel Debieve <lionel.debieve@st.com>
Reviewed-by: Fabien Dessenne <fabien.dessenne@st.com>
---
 drivers/crypto/Makefile       | 2 +-
 drivers/crypto/stm32/Kconfig  | 6 +++---
 drivers/crypto/stm32/Makefile | 3 +--
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 463f335..d4d69cec 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -32,7 +32,7 @@ obj-$(CONFIG_CRYPTO_DEV_QCE) += qce/
 obj-$(CONFIG_CRYPTO_DEV_ROCKCHIP) += rockchip/
 obj-$(CONFIG_CRYPTO_DEV_S5P) += s5p-sss.o
 obj-$(CONFIG_CRYPTO_DEV_SAHARA) += sahara.o
-obj-$(CONFIG_CRYPTO_DEV_STM32) += stm32/
+obj-$(CONFIG_ARCH_STM32) += stm32/
 obj-$(CONFIG_CRYPTO_DEV_SUN4I_SS) += sunxi-ss/
 obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
 obj-$(CONFIG_CRYPTO_DEV_UX500) += ux500/
diff --git a/drivers/crypto/stm32/Kconfig b/drivers/crypto/stm32/Kconfig
index 09b4ec8..7dd14f8 100644
--- a/drivers/crypto/stm32/Kconfig
+++ b/drivers/crypto/stm32/Kconfig
@@ -1,7 +1,7 @@
-config CRYPTO_DEV_STM32
-	tristate "Support for STM32 crypto accelerators"
+config CRC_DEV_STM32
+	tristate "Support for STM32 crc accelerators"
 	depends on ARCH_STM32
 	select CRYPTO_HASH
 	help
           This enables support for the CRC32 hw accelerator which can be found
-	  on STMicroelectronis STM32 SOC.
+	  on STMicroelectronics STM32 SOC.
diff --git a/drivers/crypto/stm32/Makefile b/drivers/crypto/stm32/Makefile
index 73b4c6e..4db2f28 100644
--- a/drivers/crypto/stm32/Makefile
+++ b/drivers/crypto/stm32/Makefile
@@ -1,2 +1 @@
-obj-$(CONFIG_CRYPTO_DEV_STM32) += stm32_cryp.o
-stm32_cryp-objs := stm32_crc32.o
+obj-$(CONFIG_CRC_DEV_STM32) += stm32_crc32.o
-- 
2.7.4
