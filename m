From: Joshua Henderson <joshua.henderson@microchip.com>
Subject: [PATCH v2 2/2] rng: pic32-rng: Add PIC32 RNG hardware driver
Date: Mon, 8 Feb 2016 14:17:53 -0700
Message-ID: <1454966283-14965-2-git-send-email-joshua.henderson@microchip.com>
References: <1454966283-14965-1-git-send-email-joshua.henderson@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Joshua Henderson <joshua.henderson@microchip.com>,
	Purna Chandra Mandal <purna.mandal@microchip.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Kieran Bingham <kieranbingham@gmail.com>,
	Lee Jones <lee.jones@linaro.org>,
	Pankaj Dev <pankaj.dev@st.com>,
	Scott Branden <sbranden@broadcom.com>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Ray Jui <rjui@broadcom.com>, <linux-crypto@vger.kernel.org>
To: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454966283-14965-1-git-send-email-joshua.henderson@microchip.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add support for the hardware true random number generator
peripheral found on PIC32.

Signed-off-by: Joshua Henderson <joshua.henderson@microchip.com>
Signed-off-by: Purna Chandra Mandal <purna.mandal@microchip.com>
---
Changes since v1:
	- Reorder includes to be alphabetic.
	- Drop use of PRNG and only use TRNG.
	- Fix dangling clock ref in error condition.
	- Remove unecessary error handling and fix other cases.
---
 drivers/char/hw_random/Kconfig     |   13 +++
 drivers/char/hw_random/Makefile    |    1 +
 drivers/char/hw_random/pic32-rng.c |  155 ++++++++++++++++++++++++++++++++++++
 3 files changed, 169 insertions(+)
 create mode 100644 drivers/char/hw_random/pic32-rng.c

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index dbf2271..3ab0c46 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -381,6 +381,19 @@ config HW_RANDOM_STM32
 
 	  If unsure, say N.
 
+config HW_RANDOM_PIC32
+	tristate "Microchip PIC32 Random Number Generator support"
+	depends on HW_RANDOM && MACH_PIC32
+	default y
+	---help---
+	  This driver provides kernel-side support for the Random Number
+	  Generator hardware found on a PIC32.
+
+	  To compile this driver as a module, choose M here. the
+	  module will be called pic32-rng.
+
+	  If unsure, say Y.
+
 endif # HW_RANDOM
 
 config UML_RANDOM
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index 5ad3976..f5a6fa7 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -33,3 +33,4 @@ obj-$(CONFIG_HW_RANDOM_MSM) += msm-rng.o
 obj-$(CONFIG_HW_RANDOM_ST) += st-rng.o
 obj-$(CONFIG_HW_RANDOM_XGENE) += xgene-rng.o
 obj-$(CONFIG_HW_RANDOM_STM32) += stm32-rng.o
+obj-$(CONFIG_HW_RANDOM_PIC32) += pic32-rng.o
diff --git a/drivers/char/hw_random/pic32-rng.c b/drivers/char/hw_random/pic32-rng.c
new file mode 100644
index 0000000..108897b
--- /dev/null
+++ b/drivers/char/hw_random/pic32-rng.c
@@ -0,0 +1,155 @@
+/*
+ * PIC32 RNG driver
+ *
+ * Joshua Henderson <joshua.henderson@microchip.com>
+ * Copyright (C) 2016 Microchip Technology Inc.  All rights reserved.
+ *
+ * This program is free software; you can distribute it and/or modify it
+ * under the terms of the GNU General Public License (Version 2) as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ */
+
+#include <linux/clk.h>
+#include <linux/clkdev.h>
+#include <linux/err.h>
+#include <linux/hw_random.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+#define RNGCON		0x04
+#define  TRNGEN		BIT(8)
+#define  PRNGEN		BIT(9)
+#define  PRNGCONT	BIT(10)
+#define  TRNGMOD	BIT(11)
+#define  SEEDLOAD	BIT(12)
+#define RNGPOLY1	0x08
+#define RNGPOLY2	0x0C
+#define RNGNUMGEN1	0x10
+#define RNGNUMGEN2	0x14
+#define RNGSEED1	0x18
+#define RNGSEED2	0x1C
+#define RNGRCNT		0x20
+#define  RCNT_MASK	0x7F
+
+struct pic32_rng {
+	void __iomem	*base;
+	struct hwrng	rng;
+	struct clk	*clk;
+};
+
+/*
+ * The TRNG can generate up to 24Mbps. This is a timeout that should be safe
+ * enough given the instructions in the loop and that the TRNG may not always
+ * be at maximum rate.
+ */
+#define RNG_TIMEOUT 500
+
+static int pic32_rng_read(struct hwrng *rng, void *buf, size_t max,
+			  bool wait)
+{
+	struct pic32_rng *priv = container_of(rng, struct pic32_rng, rng);
+	u64 *data = buf;
+	u32 t;
+	unsigned int timeout = RNG_TIMEOUT;
+
+	if (max < 8)
+		return 0;
+
+	do {
+		t = readl(priv->base + RNGRCNT) & RCNT_MASK;
+		if (t == 64) {
+			/* TRNG value comes through the seed registers */
+			*data = ((u64)readl(priv->base + RNGSEED2) << 32) +
+				readl(priv->base + RNGSEED1);
+			return 8;
+		}
+	} while (wait && --timeout);
+
+	return -EIO;
+}
+
+static int pic32_rng_probe(struct platform_device *pdev)
+{
+	struct pic32_rng *priv;
+	struct resource *res;
+	u32 v;
+	int ret;
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	priv->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(priv->base))
+		return PTR_ERR(priv->base);
+
+	priv->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(priv->clk))
+		return PTR_ERR(priv->clk);
+
+	ret = clk_prepare_enable(priv->clk);
+	if (ret)
+		return ret;
+
+	/* enable TRNG in enhanced mode */
+	v = TRNGEN | TRNGMOD;
+	writel(v, priv->base + RNGCON);
+
+	priv->rng.name = pdev->name;
+	priv->rng.read = pic32_rng_read;
+
+	ret = hwrng_register(&priv->rng);
+	if (ret)
+		goto err_register;
+
+	platform_set_drvdata(pdev, priv);
+
+	return 0;
+
+err_register:
+	clk_disable_unprepare(priv->clk);
+	return ret;
+}
+
+static int pic32_rng_remove(struct platform_device *pdev)
+{
+	struct pic32_rng *rng = platform_get_drvdata(pdev);
+
+	hwrng_unregister(&rng->rng);
+	writel(0, rng->base + RNGCON);
+	clk_disable_unprepare(rng->clk);
+	return 0;
+}
+
+static const struct of_device_id pic32_rng_of_match[] = {
+	{ .compatible	= "microchip,pic32mzda-rng", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, pic32_rng_of_match);
+
+static struct platform_driver pic32_rng_driver = {
+	.probe		= pic32_rng_probe,
+	.remove		= pic32_rng_remove,
+	.driver		= {
+		.name	= "pic32-rng",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(pic32_rng_of_match),
+	},
+};
+
+module_platform_driver(pic32_rng_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Joshua Henderson <joshua.henderson@microchip.com>");
+MODULE_DESCRIPTION("Microchip PIC32 RNG Driver");
-- 
1.7.9.5
