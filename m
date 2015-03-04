From: Scott Branden <sbranden@broadcom.com>
Subject: [PATCH v3 2/2] hwrng: iproc-rng200 - Add Broadcom IPROC RNG driver
Date: Wed, 4 Mar 2015 12:42:14 -0800
Message-ID: <1425501734-14025-3-git-send-email-sbranden@broadcom.com>
References: <Scott Branden <sbranden@broadcom.com>
 <1425501734-14025-1-git-send-email-sbranden@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Ray Jui <rjui@broadcom.com>,
	Jonathan Richardson <jonathar@broadcom.com>,
	Dmitry Torokhov <dtor@google.com>,
	Anatol Pomazao <anatol@google.com>,
	<devicetree@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	Scott Branden <sbranden@broadcom.com>
To: <bcm-kernel-feedback-list@broadcom.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	"Ian Campbell" <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Grant Likely <grant.likely@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425501734-14025-1-git-send-email-sbranden@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This adds a driver for random number generator present on Broadcom
IPROC devices.

Reviewed-by: Ray Jui <rjui@broadcom.com>
Signed-off-by: Scott Branden <sbranden@broadcom.com>
---
 drivers/char/hw_random/Kconfig        |  13 ++
 drivers/char/hw_random/Makefile       |   1 +
 drivers/char/hw_random/iproc-rng200.c | 254 ++++++++++++++++++++++++++++++++++
 3 files changed, 268 insertions(+)
 create mode 100644 drivers/char/hw_random/iproc-rng200.c

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index de57b38..f48cf11 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -101,6 +101,19 @@ config HW_RANDOM_BCM2835
 
 	  If unsure, say Y.
 
+config HW_RANDOM_IPROC_RNG200
+	tristate "Broadcom iProc RNG200 support"
+	depends on ARCH_BCM_IPROC
+	default HW_RANDOM
+	---help---
+	  This driver provides kernel-side support for the RNG200
+	  hardware found on the Broadcom iProc SoCs.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called iproc-rng200
+
+	  If unsure, say Y.
+
 config HW_RANDOM_GEODE
 	tristate "AMD Geode HW Random Number Generator support"
 	depends on X86_32 && PCI
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index 0b4cd57..055bb01 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -28,5 +28,6 @@ obj-$(CONFIG_HW_RANDOM_POWERNV) += powernv-rng.o
 obj-$(CONFIG_HW_RANDOM_EXYNOS)	+= exynos-rng.o
 obj-$(CONFIG_HW_RANDOM_TPM) += tpm-rng.o
 obj-$(CONFIG_HW_RANDOM_BCM2835) += bcm2835-rng.o
+obj-$(CONFIG_HW_RANDOM_IPROC_RNG200) += iproc-rng200.o
 obj-$(CONFIG_HW_RANDOM_MSM) += msm-rng.o
 obj-$(CONFIG_HW_RANDOM_XGENE) += xgene-rng.o
diff --git a/drivers/char/hw_random/iproc-rng200.c b/drivers/char/hw_random/iproc-rng200.c
new file mode 100644
index 0000000..276cb8a
--- /dev/null
+++ b/drivers/char/hw_random/iproc-rng200.c
@@ -0,0 +1,254 @@
+/*
+* Copyright (C) 2015 Broadcom Corporation
+*
+* This program is free software; you can redistribute it and/or
+* modify it under the terms of the GNU General Public License as
+* published by the Free Software Foundation version 2.
+*
+* This program is distributed "as is" WITHOUT ANY WARRANTY of any
+* kind, whether express or implied; without even the implied warranty
+* of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*/
+/*
+ * DESCRIPTION: The Broadcom iProc RNG200 Driver
+ */
+
+#include <linux/hw_random.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <linux/delay.h>
+
+/* Registers */
+#define RNG_CTRL_OFFSET					0x00
+#define RNG_CTRL_RNG_RBGEN_MASK				0x00001FFF
+#define RNG_CTRL_RNG_RBGEN_ENABLE			0x00000001
+#define RNG_CTRL_RNG_RBGEN_DISABLE			0x00000000
+
+#define RNG_SOFT_RESET_OFFSET				0x04
+#define RNG_SOFT_RESET					0x00000001
+
+#define RBG_SOFT_RESET_OFFSET				0x08
+#define RBG_SOFT_RESET					0x00000001
+
+#define RNG_INT_STATUS_OFFSET				0x18
+#define RNG_INT_STATUS_MASTER_FAIL_LOCKOUT_IRQ_MASK	0x80000000
+#define RNG_INT_STATUS_STARTUP_TRANSITIONS_MET_IRQ_MASK	0x00020000
+#define RNG_INT_STATUS_NIST_FAIL_IRQ_MASK		0x00000020
+#define RNG_INT_STATUS_TOTAL_BITS_COUNT_IRQ_MASK	0x00000001
+
+#define RNG_FIFO_DATA_OFFSET				0x20
+
+#define RNG_FIFO_COUNT_OFFSET				0x24
+#define RNG_FIFO_COUNT_RNG_FIFO_COUNT_MASK		0x000000FF
+
+struct iproc_rng200_dev {
+	void __iomem			*base;
+};
+
+static void iproc_rng200_restart(void __iomem *rng_base)
+{
+	uint32_t val;
+
+	/* Disable RBG */
+	val = ioread32(rng_base + RNG_CTRL_OFFSET);
+	val &= ~RNG_CTRL_RNG_RBGEN_MASK;
+	val |= RNG_CTRL_RNG_RBGEN_DISABLE;
+	iowrite32(val, rng_base + RNG_CTRL_OFFSET);
+
+	/* Clear all interrupt status */
+	iowrite32(0xFFFFFFFFUL, rng_base + RNG_INT_STATUS_OFFSET);
+
+	/* Reset RNG and RBG */
+	val = ioread32(rng_base + RBG_SOFT_RESET_OFFSET);
+	val |= RBG_SOFT_RESET;
+	iowrite32(val, rng_base + RBG_SOFT_RESET_OFFSET);
+
+	val = ioread32(rng_base + RNG_SOFT_RESET_OFFSET);
+	val |= RNG_SOFT_RESET;
+	iowrite32(val, rng_base + RNG_SOFT_RESET_OFFSET);
+
+	val = ioread32(rng_base + RNG_SOFT_RESET_OFFSET);
+	val &= ~RNG_SOFT_RESET;
+	iowrite32(val, rng_base + RNG_SOFT_RESET_OFFSET);
+
+	val = ioread32(rng_base + RBG_SOFT_RESET_OFFSET);
+	val &= ~RBG_SOFT_RESET;
+	iowrite32(val, rng_base + RBG_SOFT_RESET_OFFSET);
+
+	/* Enable RBG */
+	val = ioread32(rng_base + RNG_CTRL_OFFSET);
+	val &= ~RNG_CTRL_RNG_RBGEN_MASK;
+	val |= RNG_CTRL_RNG_RBGEN_ENABLE;
+	iowrite32(val, rng_base + RNG_CTRL_OFFSET);
+}
+
+static int iproc_rng200_read(struct hwrng *rng, void *buf, size_t max,
+			       bool wait)
+{
+	uint32_t status;
+	uint32_t num_remaining = max;
+	struct iproc_rng200_dev *priv = (struct iproc_rng200_dev *)rng->priv;
+
+	#define MAX_RESETS_PER_READ	1
+	uint32_t num_resets = 0;
+
+	#define MAX_IDLE_TIME	(1 * HZ)
+	unsigned long idle_endtime = jiffies + MAX_IDLE_TIME;
+
+	while ((num_remaining > 0) && time_before(jiffies, idle_endtime)) {
+
+		/* Is RNG sane? If not, reset it. */
+		status = ioread32(priv->base + RNG_INT_STATUS_OFFSET);
+		if ((status & (RNG_INT_STATUS_MASTER_FAIL_LOCKOUT_IRQ_MASK |
+			RNG_INT_STATUS_NIST_FAIL_IRQ_MASK)) != 0) {
+
+			if (num_resets >= MAX_RESETS_PER_READ)
+				return max - num_remaining;
+
+			iproc_rng200_restart(priv->base);
+			num_resets++;
+		}
+
+		/* Are there any random numbers available? */
+		if ((ioread32(priv->base + RNG_FIFO_COUNT_OFFSET) &
+				RNG_FIFO_COUNT_RNG_FIFO_COUNT_MASK) > 0) {
+
+			if (num_remaining >= sizeof(uint32_t)) {
+				/* Buffer has room to store entire word */
+				*(uint32_t *)buf = ioread32(priv->base +
+							RNG_FIFO_DATA_OFFSET);
+				buf += sizeof(uint32_t);
+				num_remaining -= sizeof(uint32_t);
+			} else {
+				/* Buffer can only store partial word */
+				uint32_t rnd_number = ioread32(priv->base +
+							RNG_FIFO_DATA_OFFSET);
+				memcpy(buf, &rnd_number, num_remaining);
+				buf += num_remaining;
+				num_remaining = 0;
+			}
+
+			/* Reset the IDLE timeout */
+			idle_endtime = jiffies + MAX_IDLE_TIME;
+		} else {
+			if (!wait)
+				/* Cannot wait, return immediately */
+				return max - num_remaining;
+
+			/* Can wait, give others chance to run */
+			usleep_range(min(num_remaining * 10, 500U), 500);
+		}
+	}
+
+	return max - num_remaining;
+}
+
+static int iproc_rng200_init(struct hwrng *rng)
+{
+	uint32_t val;
+	struct iproc_rng200_dev *priv;
+
+	priv = (struct iproc_rng200_dev *)rng->priv;
+
+	/* Setup RNG. */
+	val = ioread32(priv->base + RNG_CTRL_OFFSET);
+	val &= ~RNG_CTRL_RNG_RBGEN_MASK;
+	val |= RNG_CTRL_RNG_RBGEN_ENABLE;
+	iowrite32(val, priv->base + RNG_CTRL_OFFSET);
+
+	return 0;
+}
+
+static void iproc_rng200_cleanup(struct hwrng *rng)
+{
+	uint32_t val;
+	struct iproc_rng200_dev *priv;
+
+	priv = (struct iproc_rng200_dev *)rng->priv;
+
+	/* Disable RNG hardware */
+	val = ioread32(priv->base + RNG_CTRL_OFFSET);
+	val &= ~RNG_CTRL_RNG_RBGEN_MASK;
+	val |= RNG_CTRL_RNG_RBGEN_DISABLE;
+	iowrite32(val, priv->base + RNG_CTRL_OFFSET);
+}
+
+static struct hwrng iproc_rng200_ops = {
+	.name		= "iproc-rng200",
+	.read		= iproc_rng200_read,
+	.init		= iproc_rng200_init,
+	.cleanup	= iproc_rng200_cleanup,
+};
+
+static int iproc_rng200_probe(struct platform_device *pdev)
+{
+	struct iproc_rng200_dev *priv;
+	struct resource *res;
+	struct device *dev = &pdev->dev;
+	int ret;
+
+	priv = devm_kzalloc(dev, sizeof(struct iproc_rng200_dev), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	iproc_rng200_ops.priv = (unsigned long)priv;
+	platform_set_drvdata(pdev, priv);
+
+	/* Map peripheral */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(dev, "failed to get rng resources\n");
+		return -EINVAL;
+	}
+
+	priv->base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(priv->base)) {
+		dev_err(dev, "failed to remap rng regs\n");
+		return PTR_ERR(priv->base);
+	}
+
+	/* Register driver */
+	ret = hwrng_register(&iproc_rng200_ops);
+	if (ret) {
+		dev_err(dev, "hwrng registration failed\n");
+		return ret;
+	}
+
+	dev_info(dev, "hwrng registered\n");
+
+	return 0;
+}
+
+static int iproc_rng200_remove(struct platform_device *pdev)
+{
+	/* Unregister driver */
+	hwrng_unregister(&iproc_rng200_ops);
+
+	return 0;
+}
+
+static const struct of_device_id iproc_rng200_of_match[] = {
+	{ .compatible = "brcm,iproc-rng200", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, iproc_rng200_of_match);
+
+static struct platform_driver iproc_rng200_driver = {
+	.driver = {
+		.name		= "iproc-rng200",
+		.of_match_table = iproc_rng200_of_match,
+	},
+	.probe		= iproc_rng200_probe,
+	.remove		= iproc_rng200_remove,
+};
+module_platform_driver(iproc_rng200_driver);
+
+MODULE_AUTHOR("Broadcom");
+MODULE_DESCRIPTION("iProc RNG200 Random Number Generator driver");
+MODULE_LICENSE("GPL v2");
-- 
2.3.0
