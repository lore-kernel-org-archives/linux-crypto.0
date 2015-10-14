From: Daniel Thompson <daniel.thompson@linaro.org>
Subject: [PATCH v3 2/3] hwrng: stm32 - add support for STM32 HW RNG
Date: Wed, 14 Oct 2015 16:55:24 +0100
Message-ID: <1444838125-3422-3-git-send-email-daniel.thompson@linaro.org>
References: <1443904519-24012-1-git-send-email-daniel.thompson@linaro.org>
 <1444838125-3422-1-git-send-email-daniel.thompson@linaro.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@linaro.org, linaro-kernel@lists.linaro.org,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Linus Walleij <linus.walleij@linaro.org>
To: Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:33355 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932602AbbJNPzp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Oct 2015 11:55:45 -0400
Received: by wijp11 with SMTP id p11so156366wij.0
        for <linux-crypto@vger.kernel.org>; Wed, 14 Oct 2015 08:55:44 -0700 (PDT)
In-Reply-To: <1444838125-3422-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add support for STMicroelectronics STM32 random number generator.

The config value defaults to N, reflecting the fact that STM32 is a
very low resource microcontroller platform and unlikely to be targeted
by any "grown up" defconfigs.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/char/hw_random/Kconfig     |  12 +++
 drivers/char/hw_random/Makefile    |   1 +
 drivers/char/hw_random/stm32-rng.c | 202 +++++++++++++++++++++++++++++++++++++
 3 files changed, 215 insertions(+)
 create mode 100644 drivers/char/hw_random/stm32-rng.c

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index f48cf11c655e..7930cc9b719c 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -359,6 +359,18 @@ config HW_RANDOM_XGENE
 
 	  If unsure, say Y.
 
+config HW_RANDOM_STM32
+	tristate "STMicroelectronics STM32 random number generator"
+	depends on HW_RANDOM && (ARCH_STM32 || COMPILE_TEST)
+	help
+	  This driver provides kernel-side support for the Random Number
+	  Generator hardware found on STM32 microcontrollers.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called stm32-rng.
+
+	  If unsure, say N.
+
 endif # HW_RANDOM
 
 config UML_RANDOM
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index 055bb01510ad..8b49c0f7abb1 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -31,3 +31,4 @@ obj-$(CONFIG_HW_RANDOM_BCM2835) += bcm2835-rng.o
 obj-$(CONFIG_HW_RANDOM_IPROC_RNG200) += iproc-rng200.o
 obj-$(CONFIG_HW_RANDOM_MSM) += msm-rng.o
 obj-$(CONFIG_HW_RANDOM_XGENE) += xgene-rng.o
+obj-$(CONFIG_HW_RANDOM_STM32) += stm32-rng.o
diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
new file mode 100644
index 000000000000..92a810648bd0
--- /dev/null
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -0,0 +1,202 @@
+/*
+ * Copyright (c) 2015, Daniel Thompson
+ *
+ * This file is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This file is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/hw_random.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+
+#define RNG_CR 0x00
+#define RNG_CR_RNGEN BIT(2)
+
+#define RNG_SR 0x04
+#define RNG_SR_SEIS BIT(6)
+#define RNG_SR_CEIS BIT(5)
+#define RNG_SR_DRDY BIT(0)
+
+#define RNG_DR 0x08
+
+/*
+ * It takes 40 cycles @ 48MHz to generate each random number (e.g. <1us).
+ * At the time of writing STM32 parts max out at ~200MHz meaning a timeout
+ * of 500 leaves us a very comfortable margin for error. The loop to which
+ * the timeout applies takes at least 4 instructions per iteration so the
+ * timeout is enough to take us up to multi-GHz parts!
+ */
+#define RNG_TIMEOUT 500
+
+struct stm32_rng_private {
+	struct hwrng rng;
+	void __iomem *base;
+	struct clk *clk;
+};
+
+static int stm32_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
+{
+	struct stm32_rng_private *priv =
+	    container_of(rng, struct stm32_rng_private, rng);
+	u32 sr;
+	int retval = 0;
+
+	pm_runtime_get_sync((struct device *) priv->rng.priv);
+
+	while (max > sizeof(u32)) {
+		sr = readl_relaxed(priv->base + RNG_SR);
+		if (!sr && wait) {
+			unsigned int timeout = RNG_TIMEOUT;
+
+			do {
+				cpu_relax();
+				sr = readl_relaxed(priv->base + RNG_SR);
+			} while (!sr && --timeout);
+		}
+
+		/* If error detected or data not ready... */
+		if (sr != RNG_SR_DRDY)
+			break;
+
+		*(u32 *)data = readl_relaxed(priv->base + RNG_DR);
+
+		retval += sizeof(u32);
+		data += sizeof(u32);
+		max -= sizeof(u32);
+	}
+
+	if (WARN_ONCE(sr & (RNG_SR_SEIS | RNG_SR_CEIS),
+		      "bad RNG status - %x\n", sr))
+		writel_relaxed(0, priv->base + RNG_SR);
+
+	pm_runtime_mark_last_busy((struct device *) priv->rng.priv);
+	pm_runtime_put_sync_autosuspend((struct device *) priv->rng.priv);
+
+	return retval || !wait ? retval : -EIO;
+}
+
+static int stm32_rng_init(struct hwrng *rng)
+{
+	struct stm32_rng_private *priv =
+	    container_of(rng, struct stm32_rng_private, rng);
+	int err;
+
+	err = clk_prepare_enable(priv->clk);
+	if (err)
+		return err;
+
+	writel_relaxed(RNG_CR_RNGEN, priv->base + RNG_CR);
+
+	/* clear error indicators */
+	writel_relaxed(0, priv->base + RNG_SR);
+
+	return 0;
+}
+
+static void stm32_rng_cleanup(struct hwrng *rng)
+{
+	struct stm32_rng_private *priv =
+	    container_of(rng, struct stm32_rng_private, rng);
+
+	writel_relaxed(0, priv->base + RNG_CR);
+	clk_disable_unprepare(priv->clk);
+}
+
+static int stm32_rng_probe(struct platform_device *ofdev)
+{
+	struct device *dev = &ofdev->dev;
+	struct device_node *np = ofdev->dev.of_node;
+	struct stm32_rng_private *priv;
+	struct resource res;
+	int err;
+
+	priv = devm_kzalloc(dev, sizeof(struct stm32_rng_private), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	err = of_address_to_resource(np, 0, &res);
+	if (err)
+		return err;
+
+	priv->base = devm_ioremap_resource(dev, &res);
+	if (IS_ERR(priv->base))
+		return PTR_ERR(priv->base);
+
+	priv->clk = devm_clk_get(&ofdev->dev, NULL);
+	if (IS_ERR(priv->clk))
+		return PTR_ERR(priv->clk);
+
+	dev_set_drvdata(dev, priv);
+
+	priv->rng.name = dev_driver_string(dev),
+#ifndef CONFIG_PM
+	priv->rng.init = stm32_rng_init,
+	priv->rng.cleanup = stm32_rng_cleanup,
+#endif
+	priv->rng.read = stm32_rng_read,
+	priv->rng.priv = (unsigned long) dev;
+
+	pm_runtime_set_autosuspend_delay(dev, 100);
+	pm_runtime_use_autosuspend(dev);
+	pm_runtime_enable(dev);
+
+	return devm_hwrng_register(dev, &priv->rng);
+}
+
+#ifdef CONFIG_PM
+static int stm32_rng_runtime_suspend(struct device *dev)
+{
+	struct stm32_rng_private *priv = dev_get_drvdata(dev);
+
+	stm32_rng_cleanup(&priv->rng);
+
+	return 0;
+}
+
+static int stm32_rng_runtime_resume(struct device *dev)
+{
+	struct stm32_rng_private *priv = dev_get_drvdata(dev);
+
+	return stm32_rng_init(&priv->rng);
+}
+#endif
+
+static UNIVERSAL_DEV_PM_OPS(stm32_rng_pm_ops, stm32_rng_runtime_suspend,
+			    stm32_rng_runtime_resume, NULL);
+
+static const struct of_device_id stm32_rng_match[] = {
+	{
+		.compatible = "st,stm32-rng",
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, stm32_rng_match);
+
+static struct platform_driver stm32_rng_driver = {
+	.driver = {
+		.name = "stm32-rng",
+		.pm = &stm32_rng_pm_ops,
+		.of_match_table = stm32_rng_match,
+	},
+	.probe = stm32_rng_probe,
+};
+
+module_platform_driver(stm32_rng_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Daniel Thompson <daniel.thompson@linaro.org>");
+MODULE_DESCRIPTION("STMicroelectronics STM32 RNG device driver");
-- 
2.4.3
