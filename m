From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 11/12] hwrng: bcm2835-rng: Enable BCM2835 RNG to work on BCM63xx platforms
Date: Tue,  7 Nov 2017 16:44:48 -0800
Message-ID: <20171108004449.32730-12-f.fainelli@gmail.com>
References: <20171108004449.32730-1-f.fainelli@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com (maintainer:BROADCOM
        BCM281XX/BCM11XXX/BCM216XX ARM ARCHITE...),
        Eric Anholt <eric@anholt.net>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Harald Freudenberger <freude@linux.vnet.ibm.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Martin Kaiser <martin@kaiser.cx>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        linux-crypto@vger.k
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171108004449.32730-1-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

We have now incorporated all necessary functionality for the BCM63xx
platforms to successfully migrate over bcm2835-rng, so add the final
bits: Kconfig selection and proper platform_device device type matching
to keep the same platform device name for registration to work.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/char/hw_random/Kconfig       |  7 ++++---
 drivers/char/hw_random/bcm2835-rng.c | 11 ++++++++++-
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 95a031e9eced..d0689cc8c7fc 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -87,12 +87,13 @@ config HW_RANDOM_BCM63XX
 	  If unusure, say Y.
 
 config HW_RANDOM_BCM2835
-	tristate "Broadcom BCM2835 Random Number Generator support"
-	depends on ARCH_BCM2835 || ARCH_BCM_NSP || ARCH_BCM_5301X
+	tristate "Broadcom BCM2835/BCM63xx Random Number Generator support"
+	depends on ARCH_BCM2835 || ARCH_BCM_NSP || ARCH_BCM_5301X || \
+		   ARCH_BCM_63XX || BCM63XX || BMIPS_GENERIC
 	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
-	  Generator hardware found on the Broadcom BCM2835 SoCs.
+	  Generator hardware found on the Broadcom BCM2835 and BCM63xx SoCs.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called bcm2835-rng
diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
index 6dd8f48701b5..25e56311a197 100644
--- a/drivers/char/hw_random/bcm2835-rng.c
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -134,6 +134,7 @@ static const struct of_device_id bcm2835_rng_of_match[] = {
 	{ .compatible = "brcm,bcm2835-rng"},
 	{ .compatible = "brcm,bcm-nsp-rng", .data = &nsp_rng_of_data },
 	{ .compatible = "brcm,bcm5301x-rng", .data = &nsp_rng_of_data },
+	{ .compatible = "brcm,bcm6368-rng"},
 	{},
 };
 
@@ -165,7 +166,7 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
 	/* Clock is optional on most platforms */
 	priv->clk = devm_clk_get(dev, NULL);
 
-	priv->rng.name = "bcm2835-rng";
+	priv->rng.name = pdev->name;
 	priv->rng.init = bcm2835_rng_init;
 	priv->rng.read = bcm2835_rng_read;
 	priv->rng.cleanup = bcm2835_rng_cleanup;
@@ -191,12 +192,20 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
 
 MODULE_DEVICE_TABLE(of, bcm2835_rng_of_match);
 
+static struct platform_device_id bcm2835_rng_devtype[] = {
+	{ .name = "bcm2835-rng" },
+	{ .name = "bcm63xx-rng" },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(platform, bcm2835_rng_devtype);
+
 static struct platform_driver bcm2835_rng_driver = {
 	.driver = {
 		.name = "bcm2835-rng",
 		.of_match_table = bcm2835_rng_of_match,
 	},
 	.probe		= bcm2835_rng_probe,
+	.id_table	= bcm2835_rng_devtype,
 };
 module_platform_driver(bcm2835_rng_driver);
 
-- 
2.9.3
