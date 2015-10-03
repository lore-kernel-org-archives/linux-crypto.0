From: Daniel Thompson <daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/3] hwrng: stm32 - add support for STM32 HW RNG
Date: Sat,  3 Oct 2015 21:35:18 +0100
Message-ID: <1443904519-24012-3-git-send-email-daniel.thompson@linaro.org>
References: <1443904519-24012-1-git-send-email-daniel.thompson@linaro.org>
Cc: Daniel Thompson <daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
	devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org,
	Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>,
	Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
	Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>,
	Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
To: Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443904519-24012-1-git-send-email-daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Add support for STMicroelectronics STM32 random number generator.

The config value defaults to N, reflecting the fact that STM32 is a
very low resource microcontroller platform and unlikely to be targeted
by any "grown up" defconfigs.

Signed-off-by: Daniel Thompson <daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/char/hw_random/Kconfig     |  12 +++
 drivers/char/hw_random/Makefile    |   1 +
 drivers/char/hw_random/stm32-rng.c | 192 +++++++++++++++++++++++++++++++++++++
 3 files changed, 205 insertions(+)
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
index 000000000000..37dfa5fca105
--- /dev/null
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -0,0 +1,192 @@
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
+ * the timeout applies takes at least 4 instructions per cycle so the
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
+	u32 cr, sr;
+	int retval = 0;
+
+	/* enable random number generation */
+	clk_enable(priv->clk);
+	cr = readl(priv->base + RNG_CR);
+	writel(cr | RNG_CR_RNGEN, priv->base + RNG_CR);
+
+	while (max > sizeof(u32)) {
+		sr = readl(priv->base + RNG_SR);
+		if (!sr && wait) {
+			unsigned int timeout = RNG_TIMEOUT;
+
+			do {
+				cpu_relax();
+				sr = readl(priv->base + RNG_SR);
+			} while (!sr && --timeout);
+		}
+
+		/* Has h/ware error dection been triggered? */
+		if (WARN_ON(sr & (RNG_SR_SEIS | RNG_SR_CEIS)))
+			break;
+
+		/* No data ready... */
+		if (!sr)
+			break;
+
+		*(u32 *)data = readl(priv->base + RNG_DR);
+
+		retval += sizeof(u32);
+		data += sizeof(u32);
+		max -= sizeof(u32);
+	}
+
+	/* disable the generator */
+	writel(cr, priv->base + RNG_CR);
+	clk_disable(priv->clk);
+
+	return retval || !wait ? retval : -EIO;
+}
+
+static int stm32_rng_init(struct hwrng *rng)
+{
+	struct stm32_rng_private *priv =
+	    container_of(rng, struct stm32_rng_private, rng);
+	int err;
+	u32 sr;
+
+	err = clk_prepare(priv->clk);
+	if (err)
+		return err;
+
+	/* clear error indicators */
+	sr = readl(priv->base + RNG_SR);
+	sr &= ~(RNG_SR_SEIS | RNG_SR_CEIS);
+	writel(sr, priv->base + RNG_SR);
+
+	return 0;
+}
+
+static void stm32_rng_cleanup(struct hwrng *rng)
+{
+	struct stm32_rng_private *priv =
+	    container_of(rng, struct stm32_rng_private, rng);
+
+	clk_unprepare(priv->clk);
+}
+
+static int stm32_rng_remove(struct platform_device *ofdev)
+{
+	struct device *dev = &ofdev->dev;
+	struct stm32_rng_private *priv = dev_get_drvdata(dev);
+
+	hwrng_unregister(&priv->rng);
+
+	return 0;
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
+	priv->rng.init = stm32_rng_init,
+	priv->rng.cleanup = stm32_rng_cleanup,
+	priv->rng.read = stm32_rng_read,
+	priv->rng.priv = (unsigned long) dev;
+
+	err = hwrng_register(&priv->rng);
+	if (err)
+		return err;
+
+	return 0;
+}
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
+		.name = "stm32_rng",
+		.of_match_table = stm32_rng_match,
+	},
+	.probe = stm32_rng_probe,
+	.remove = stm32_rng_remove,
+};
+
+module_platform_driver(stm32_rng_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Daniel Thompson <daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>");
+MODULE_DESCRIPTION("STMicroelectronics STM32 RNG device driver");
-- 
2.4.3

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
