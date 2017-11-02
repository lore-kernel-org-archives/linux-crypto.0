From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 12/12] hwrng: bcm63xx-rng: Remove since bcm2835-rng takes over
Date: Wed,  1 Nov 2017 18:04:08 -0700
Message-ID: <20171102010408.27736-13-f.fainelli@gmail.com>
References: <20171102010408.27736-1-f.fainelli@gmail.com>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:44028 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934131AbdKBBEo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Nov 2017 21:04:44 -0400
In-Reply-To: <20171102010408.27736-1-f.fainelli@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

bcm2835-rng is now capable of supporting the BCM63xx hardware, so remove
the driver which duplicates the same functionality.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/char/hw_random/Kconfig       |  13 ---
 drivers/char/hw_random/Makefile      |   1 -
 drivers/char/hw_random/bcm63xx-rng.c | 154 -----------------------------------
 3 files changed, 168 deletions(-)
 delete mode 100644 drivers/char/hw_random/bcm63xx-rng.c

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index d0689cc8c7fc..2d3775b9c0c7 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -73,19 +73,6 @@ config HW_RANDOM_ATMEL
 
 	  If unsure, say Y.
 
-config HW_RANDOM_BCM63XX
-	tristate "Broadcom BCM63xx Random Number Generator support"
-	depends on BCM63XX || BMIPS_GENERIC
-	default HW_RANDOM
-	---help---
-	  This driver provides kernel-side support for the Random Number
-	  Generator hardware found on the Broadcom BCM63xx SoCs.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called bcm63xx-rng
-
-	  If unusure, say Y.
-
 config HW_RANDOM_BCM2835
 	tristate "Broadcom BCM2835/BCM63xx Random Number Generator support"
 	depends on ARCH_BCM2835 || ARCH_BCM_NSP || ARCH_BCM_5301X || \
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index 39a67defac67..470ea14ed6b7 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -8,7 +8,6 @@ obj-$(CONFIG_HW_RANDOM_TIMERIOMEM) += timeriomem-rng.o
 obj-$(CONFIG_HW_RANDOM_INTEL) += intel-rng.o
 obj-$(CONFIG_HW_RANDOM_AMD) += amd-rng.o
 obj-$(CONFIG_HW_RANDOM_ATMEL) += atmel-rng.o
-obj-$(CONFIG_HW_RANDOM_BCM63XX)	+= bcm63xx-rng.o
 obj-$(CONFIG_HW_RANDOM_GEODE) += geode-rng.o
 obj-$(CONFIG_HW_RANDOM_N2RNG) += n2-rng.o
 n2-rng-y := n2-drv.o n2-asm.o
diff --git a/drivers/char/hw_random/bcm63xx-rng.c b/drivers/char/hw_random/bcm63xx-rng.c
deleted file mode 100644
index 5132c9cde50d..000000000000
--- a/drivers/char/hw_random/bcm63xx-rng.c
+++ /dev/null
@@ -1,154 +0,0 @@
-/*
- * Broadcom BCM63xx Random Number Generator support
- *
- * Copyright (C) 2011, Florian Fainelli <florian@openwrt.org>
- * Copyright (C) 2009, Broadcom Corporation
- *
- */
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/io.h>
-#include <linux/err.h>
-#include <linux/clk.h>
-#include <linux/platform_device.h>
-#include <linux/hw_random.h>
-#include <linux/of.h>
-
-#define RNG_CTRL			0x00
-#define RNG_EN				(1 << 0)
-
-#define RNG_STAT			0x04
-#define RNG_AVAIL_MASK			(0xff000000)
-
-#define RNG_DATA			0x08
-#define RNG_THRES			0x0c
-#define RNG_MASK			0x10
-
-struct bcm63xx_rng_priv {
-	struct hwrng rng;
-	struct clk *clk;
-	void __iomem *regs;
-};
-
-#define to_rng_priv(rng)	container_of(rng, struct bcm63xx_rng_priv, rng)
-
-static int bcm63xx_rng_init(struct hwrng *rng)
-{
-	struct bcm63xx_rng_priv *priv = to_rng_priv(rng);
-	u32 val;
-	int error;
-
-	error = clk_prepare_enable(priv->clk);
-	if (error)
-		return error;
-
-	val = __raw_readl(priv->regs + RNG_CTRL);
-	val |= RNG_EN;
-	__raw_writel(val, priv->regs + RNG_CTRL);
-
-	return 0;
-}
-
-static void bcm63xx_rng_cleanup(struct hwrng *rng)
-{
-	struct bcm63xx_rng_priv *priv = to_rng_priv(rng);
-	u32 val;
-
-	val = __raw_readl(priv->regs + RNG_CTRL);
-	val &= ~RNG_EN;
-	__raw_writel(val, priv->regs + RNG_CTRL);
-
-	clk_disable_unprepare(priv->clk);
-}
-
-static int bcm63xx_rng_data_present(struct hwrng *rng, int wait)
-{
-	struct bcm63xx_rng_priv *priv = to_rng_priv(rng);
-
-	return __raw_readl(priv->regs + RNG_STAT) & RNG_AVAIL_MASK;
-}
-
-static int bcm63xx_rng_data_read(struct hwrng *rng, u32 *data)
-{
-	struct bcm63xx_rng_priv *priv = to_rng_priv(rng);
-
-	*data = __raw_readl(priv->regs + RNG_DATA);
-
-	return 4;
-}
-
-static int bcm63xx_rng_probe(struct platform_device *pdev)
-{
-	struct resource *r;
-	int ret;
-	struct bcm63xx_rng_priv *priv;
-
-	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!r) {
-		dev_err(&pdev->dev, "no iomem resource\n");
-		return -ENXIO;
-	}
-
-	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
-
-	priv->rng.name = pdev->name;
-	priv->rng.init = bcm63xx_rng_init;
-	priv->rng.cleanup = bcm63xx_rng_cleanup;
-	priv->rng.data_present = bcm63xx_rng_data_present;
-	priv->rng.data_read = bcm63xx_rng_data_read;
-
-	priv->clk = devm_clk_get(&pdev->dev, "ipsec");
-	if (IS_ERR(priv->clk)) {
-		ret = PTR_ERR(priv->clk);
-		dev_err(&pdev->dev, "no clock for device: %d\n", ret);
-		return ret;
-	}
-
-	if (!devm_request_mem_region(&pdev->dev, r->start,
-					resource_size(r), pdev->name)) {
-		dev_err(&pdev->dev, "request mem failed");
-		return -EBUSY;
-	}
-
-	priv->regs = devm_ioremap_nocache(&pdev->dev, r->start,
-					resource_size(r));
-	if (!priv->regs) {
-		dev_err(&pdev->dev, "ioremap failed");
-		return -ENOMEM;
-	}
-
-	ret = devm_hwrng_register(&pdev->dev, &priv->rng);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to register rng device: %d\n",
-			ret);
-		return ret;
-	}
-
-	dev_info(&pdev->dev, "registered RNG driver\n");
-
-	return 0;
-}
-
-#ifdef CONFIG_OF
-static const struct of_device_id bcm63xx_rng_of_match[] = {
-	{ .compatible = "brcm,bcm6368-rng", },
-	{},
-};
-MODULE_DEVICE_TABLE(of, bcm63xx_rng_of_match);
-#endif
-
-static struct platform_driver bcm63xx_rng_driver = {
-	.probe		= bcm63xx_rng_probe,
-	.driver		= {
-		.name	= "bcm63xx-rng",
-		.of_match_table = of_match_ptr(bcm63xx_rng_of_match),
-	},
-};
-
-module_platform_driver(bcm63xx_rng_driver);
-
-MODULE_AUTHOR("Florian Fainelli <florian@openwrt.org>");
-MODULE_DESCRIPTION("Broadcom BCM63xx RNG driver");
-MODULE_LICENSE("GPL");
-- 
2.9.3
