From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCH 2/2] sec: Makefile/Kconfig update for omap sha1 md5 driver
Date: Wed, 17 Mar 2010 15:12:51 +0200
Message-ID: <da83b7432627c30ca062753a6f8abb0f6fe948d0.1268830685.git.dmitry.kasatkin@nokia.com>
References: <cover.1268830685.git.dmitry.kasatkin@nokia.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-omap-owner@vger.kernel.org>
In-Reply-To: <cover.1268830685.git.dmitry.kasatkin@nokia.com>
In-Reply-To: <cover.1268830685.git.dmitry.kasatkin@nokia.com>
References: <cover.1268830685.git.dmitry.kasatkin@nokia.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
---
 drivers/crypto/Kconfig  |    9 +++++++++
 drivers/crypto/Makefile |    2 ++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index b08403d..4cca798 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -222,4 +222,13 @@ config CRYPTO_DEV_PPC4XX
 	help
 	  This option allows you to have support for AMCC crypto acceleration.
 
+config OMAP_SHA1_MD5
+	tristate "Support for OMAP SHA1/MD5 hw engine"
+	depends on ARCH_OMAP24XX || ARCH_OMAP34XX
+	select CRYPTO_SHA1
+	select CRYPTO_MD5
+	help
+	  OMAP processors have SHA1/MD5 module accelerator. Select this if you
+	  want to use the OMAP module for SHA1/MD5 algorithms.
+
 endif # CRYPTO_HW
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 6ffcb3f..7e05a82 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -6,3 +6,5 @@ obj-$(CONFIG_CRYPTO_DEV_MV_CESA) += mv_cesa.o
 obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
 obj-$(CONFIG_CRYPTO_DEV_IXP4XX) += ixp4xx_crypto.o
 obj-$(CONFIG_CRYPTO_DEV_PPC4XX) += amcc/
+obj-$(CONFIG_OMAP_SHA1_MD5) += omap-sha1-md5.o
+
-- 
1.6.3.3

