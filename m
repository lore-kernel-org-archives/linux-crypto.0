From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 5/6] crypto - Group Freescale/NXP ARM architecture Kconfig entires together
Date: Thu, 30 Aug 2018 19:15:38 +0200
Message-ID: <20180830171539.20008-6-krzk@kernel.org>
References: <20180830171539.20008-1-krzk@kernel.org>
To: Krzysztof Kozlowski <krzk@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Stefan Agner <stefan@agner.ch>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180830171539.20008-1-krzk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Group Freescale/NXP Kconfig entires for ARM architecture CPUs/SoCs
together to make it more consistent and easy to read.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/crypto/Kconfig | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index a8c4ce07fc9d..20314d7a7b58 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -402,6 +402,22 @@ config CRYPTO_DEV_MXC_SCC
 	  This option enables support for the Security Controller (SCC)
 	  found in Freescale i.MX25 chips.
 
+config CRYPTO_DEV_MXS_DCP
+	tristate "Support for Freescale MXS DCP"
+	depends on (ARCH_MXS || ARCH_MXC)
+	select STMP_DEVICE
+	select CRYPTO_CBC
+	select CRYPTO_ECB
+	select CRYPTO_AES
+	select CRYPTO_BLKCIPHER
+	select CRYPTO_HASH
+	help
+	  The Freescale i.MX23/i.MX28 has SHA1/SHA256 and AES128 CBC/ECB
+	  co-processor on the die.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called mxs-dcp.
+
 config CRYPTO_DEV_EXYNOS_RNG
 	tristate "EXYNOS HW pseudo random number generator support"
 	depends on ARCH_EXYNOS || COMPILE_TEST
@@ -542,22 +558,6 @@ if CRYPTO_DEV_CCP
 	source "drivers/crypto/ccp/Kconfig"
 endif
 
-config CRYPTO_DEV_MXS_DCP
-	tristate "Support for Freescale MXS DCP"
-	depends on (ARCH_MXS || ARCH_MXC)
-	select STMP_DEVICE
-	select CRYPTO_CBC
-	select CRYPTO_ECB
-	select CRYPTO_AES
-	select CRYPTO_BLKCIPHER
-	select CRYPTO_HASH
-	help
-	  The Freescale i.MX23/i.MX28 has SHA1/SHA256 and AES128 CBC/ECB
-	  co-processor on the die.
-
-	  To compile this driver as a module, choose M here: the module
-	  will be called mxs-dcp.
-
 source "drivers/crypto/qat/Kconfig"
 source "drivers/crypto/cavium/cpt/Kconfig"
 source "drivers/crypto/cavium/nitrox/Kconfig"
-- 
2.14.1
