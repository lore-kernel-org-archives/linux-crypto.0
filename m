From: =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Subject: [PATCH v2 2/3] hwrng: exynos - add Samsung Exynos True RNG driver
Date: Mon, 27 Nov 2017 10:58:03 +0100
Message-ID: <20171127095804.7128-3-l.stelmach@samsung.com>
References: <20171127095804.7128-1-l.stelmach@samsung.com>
        <CGME20171127095809eucas1p27b7d5c44c564bb553342f5fab40d0bac@eucas1p2.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: "Andrew F. Davis" <afd@ti.com>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        devicetree@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-reply-to: <20171127095804.7128-1-l.stelmach@samsung.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add support for True Random Number Generator found in Samsung Exynos
5250+ SoCs.

Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
---
 MAINTAINERS                          |   7 +
 drivers/char/hw_random/Kconfig       |  12 ++
 drivers/char/hw_random/Makefile      |   1 +
 drivers/char/hw_random/exynos-trng.c | 245 +++++++++++++++++++++++++++++++++++
 4 files changed, 265 insertions(+)
 create mode 100644 drivers/char/hw_random/exynos-trng.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 2811a211632c..992074cca612 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11780,6 +11780,13 @@ S:	Maintained
 F:	drivers/crypto/exynos-rng.c
 F:	Documentation/devicetree/bindings/rng/samsung,exynos-rng4.txt
 
+SAMSUNG EXYNOS TRUE RANDOM NUMBER GENERATOR (TRNG) DRIVER
+M:	Łukasz Stelmach <l.stelmach@samsung.com>
+L:	linux-samsung-soc@vger.kernel.org
+S:	Maintained
+F:	drivers/char/hw_random/exynos-trng.c
+F:	Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt
+
 SAMSUNG FRAMEBUFFER DRIVER
 M:	Jingoo Han <jingoohan1@gmail.com>
 L:	linux-fbdev@vger.kernel.org
diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 95a031e9eced..292e6b36d493 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -449,6 +449,18 @@ config HW_RANDOM_S390
 
 	  If unsure, say Y.
 
+config HW_RANDOM_EXYNOS
+	tristate "Samsung Exynos True Random Number Generator support"
+	depends on ARCH_EXYNOS || COMPILE_TEST
+	default HW_RANDOM
+	---help---
+	  This driver provides support for the True Random Number
+	  Generator available in Exynos SoCs.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called exynos-trng.
+
+	  If unsure, say Y.
 endif # HW_RANDOM
 
 config UML_RANDOM
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index f3728d008fff..5595df97da7a 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_HW_RANDOM_GEODE) += geode-rng.o
 obj-$(CONFIG_HW_RANDOM_N2RNG) += n2-rng.o
 n2-rng-y := n2-drv.o n2-asm.o
 obj-$(CONFIG_HW_RANDOM_VIA) += via-rng.o
+obj-$(CONFIG_HW_RANDOM_EXYNOS) += exynos-trng.o
 obj-$(CONFIG_HW_RANDOM_IXP4XX) += ixp4xx-rng.o
 obj-$(CONFIG_HW_RANDOM_OMAP) += omap-rng.o
 obj-$(CONFIG_HW_RANDOM_OMAP3_ROM) += omap3-rom-rng.o
diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_random/exynos-trng.c
new file mode 100644
index 000000000000..91b2ddb249fa
--- /dev/null
+++ b/drivers/char/hw_random/exynos-trng.c
@@ -0,0 +1,245 @@
+/*
+ * RNG driver for Exynos TRNGs
+ *
+ * Author: Łukasz Stelmach <l.stelmach@samsung.com>
+ *
+ * Copyright 2017 (c) Samsung Electronics Software, Inc.
+ *
+ * Based on the Exynos PRNG driver drivers/crypto/exynos-rng by
+ * Krzysztof Kozłowski <krzk@kernel.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation;
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/clk.h>
+#include <linux/crypto.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/hw_random.h>
+#include <linux/io.h>
+#include <linux/iopoll.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+
+#define EXYNOS_TRNG_CLKDIV         (0x0)
+#define EXYNOS_TRNG_CTRL           (0x20)
+#define EXYNOS_TRNG_POST_CTRL      (0x30)
+#define EXYNOS_TRNG_ONLINE_CTRL    (0x40)
+#define EXYNOS_TRNG_ONLINE_STAT    (0x44)
+#define EXYNOS_TRNG_ONLINE_MAXCHI2 (0x48)
+#define EXYNOS_TRNG_FIFO_CTRL      (0x50)
+#define EXYNOS_TRNG_FIFO_0         (0x80)
+#define EXYNOS_TRNG_FIFO_1         (0x84)
+#define EXYNOS_TRNG_FIFO_2         (0x88)
+#define EXYNOS_TRNG_FIFO_3         (0x8c)
+#define EXYNOS_TRNG_FIFO_4         (0x90)
+#define EXYNOS_TRNG_FIFO_5         (0x94)
+#define EXYNOS_TRNG_FIFO_6         (0x98)
+#define EXYNOS_TRNG_FIFO_7         (0x9c)
+#define EXYNOS_TRNG_FIFO_LEN       (8)
+#define EXYNOS_TRNG_CLOCK_RATE     (500000)
+
+#define TRNG_CTRL_RGNEN            BIT(31)
+
+struct exynos_trng_dev {
+	struct device    *dev;
+	void __iomem     *mem;
+	struct clk       *clk;
+	struct hwrng rng;
+};
+
+static int exynos_trng_do_read(struct hwrng *rng, void *data, size_t max,
+			       bool wait)
+{
+	struct exynos_trng_dev *trng;
+	u32 val;
+
+	max = min_t(size_t, max, (EXYNOS_TRNG_FIFO_LEN * 4));
+
+	trng = (struct exynos_trng_dev *)rng->priv;
+
+	__raw_writel(max * 8, trng->mem + EXYNOS_TRNG_FIFO_CTRL);
+	val = readl_poll_timeout(trng->mem + EXYNOS_TRNG_FIFO_CTRL, val,
+				 val == 0, 200, 1000000);
+	if (val < 0)
+		return val;
+
+	memcpy_fromio(data, trng->mem + EXYNOS_TRNG_FIFO_0, max);
+
+	return max;
+}
+
+static int exynos_trng_init(struct hwrng *rng)
+{
+	struct exynos_trng_dev *trng = (struct exynos_trng_dev *)rng->priv;
+	unsigned long sss_rate;
+	u32 val;
+
+	sss_rate = clk_get_rate(trng->clk);
+
+	/*
+	 * For most TRNG circuits the clock frequency of under 500 kHz
+	 * is safe.
+	 */
+	val = sss_rate / (EXYNOS_TRNG_CLOCK_RATE * 2);
+	if (val > 0x7fff) {
+		dev_err(trng->dev, "clock divider too large: %d", val);
+		return -ERANGE;
+	}
+	val = val << 1;
+	__raw_writel(val, trng->mem + EXYNOS_TRNG_CLKDIV);
+
+	/* Enable the generator. */
+	val = TRNG_CTRL_RGNEN;
+	__raw_writel(val, trng->mem + EXYNOS_TRNG_CTRL);
+
+	/*
+	 * Disable post-processing. /dev/hwrng is supposed to deliver
+	 * unprocessed data.
+	 */
+	__raw_writel(0, trng->mem + EXYNOS_TRNG_POST_CTRL);
+
+	return 0;
+}
+
+static int exynos_trng_probe(struct platform_device *pdev)
+{
+	struct exynos_trng_dev *trng;
+	struct resource *res;
+	int ret = -ENOMEM;
+
+	trng = devm_kzalloc(&pdev->dev, sizeof(*trng), GFP_KERNEL);
+	if (!trng)
+		return ret;
+
+	trng->rng.name = devm_kstrdup(&pdev->dev, dev_name(&pdev->dev),
+				      GFP_KERNEL);
+	if (!trng->rng.name)
+		return ret;
+
+	trng->rng.init = exynos_trng_init;
+	trng->rng.read = exynos_trng_do_read;
+	trng->rng.priv = (unsigned long) trng;
+
+	platform_set_drvdata(pdev, trng);
+	trng->dev = &pdev->dev;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	trng->mem = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(trng->mem)) {
+		ret = PTR_ERR(trng->mem);
+		dev_err(&pdev->dev, "Could not map IO resources.\n");
+		goto err_ioremap;
+	}
+
+	pm_runtime_enable(&pdev->dev);
+	ret = pm_runtime_get_sync(&pdev->dev);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Could not get runtime PM.\n");
+		goto err_pm_get;
+	}
+
+	trng->clk = devm_clk_get(&pdev->dev, "secss");
+	if (IS_ERR(trng->clk)) {
+		ret = PTR_ERR(trng->clk);
+		dev_err(&pdev->dev, "Could not get clock.\n");
+		goto err_clock;
+	}
+
+	ret = clk_prepare_enable(trng->clk);
+	if (ret) {
+		dev_err(&pdev->dev, "Could not enable the clk.\n");
+		goto err_clock;
+	}
+
+	ret = hwrng_register(&trng->rng);
+	if (ret) {
+		dev_err(&pdev->dev, "Could not register hwrng device.\n");
+		goto err_register;
+	}
+
+	dev_info(&pdev->dev, "Exynos True Random Number Generator.\n");
+
+	return 0;
+
+err_register:
+	clk_disable_unprepare(trng->clk);
+
+err_clock:
+	pm_runtime_put_sync(&pdev->dev);
+
+err_pm_get:
+	pm_runtime_disable(&pdev->dev);
+
+err_ioremap:
+	return ret;
+}
+
+static int exynos_trng_remove(struct platform_device *pdev)
+{
+	struct exynos_trng_dev *trng =  platform_get_drvdata(pdev);
+
+	hwrng_unregister(&trng->rng);
+	clk_disable_unprepare(trng->clk);
+
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+
+	return 0;
+}
+
+static int __maybe_unused exynos_trng_suspend(struct device *dev)
+{
+	pm_runtime_put_sync(dev);
+
+	return 0;
+}
+
+static int __maybe_unused exynos_trng_resume(struct device *dev)
+{
+	int ret;
+
+	ret = pm_runtime_get_sync(dev);
+	if (ret < 0) {
+		dev_err(dev, "Could not get runtime PM.\n");
+		pm_runtime_put_noidle(dev);
+		return ret;
+	}
+
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(exynos_trng_pm_ops, exynos_trng_suspend,
+			 exynos_trng_resume);
+
+static const struct of_device_id exynos_trng_dt_match[] = {
+	{
+		.compatible = "samsung,exynos5250-trng",
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, exynos_rng_dt_match);
+
+static struct platform_driver exynos_trng_driver = {
+	.driver = {
+		.name = "exynos-trng",
+		.pm = &exynos_trng_pm_ops,
+		.of_match_table = exynos_trng_dt_match,
+	},
+	.probe = exynos_trng_probe,
+	.remove = exynos_trng_remove,
+};
+
+module_platform_driver(exynos_trng_driver);
+MODULE_AUTHOR("Łukasz Stelmach");
+MODULE_DESCRIPTION("H/W TRNG driver for Exynos chips");
+MODULE_LICENSE("GPL");
-- 
2.11.0
