From: Martin Kaiser <martin@kaiser.cx>
Subject: [PATCH v5 3/3] hwrng: mxc-fsl - add support for Freescale RNGC
Date: Thu, 20 Jul 2017 22:27:27 +0200
Message-ID: <1500582447-28607-3-git-send-email-martin@kaiser.cx>
References: <1457705200-16951-1-git-send-email-s.trumtrar@pengutronix.de>
 <1500582447-28607-1-git-send-email-martin@kaiser.cx>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de,
        Fabio Estevam <festevam@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Martin Kaiser <martin@kaiser.cx>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1500582447-28607-1-git-send-email-martin@kaiser.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Steffen Trumtrar <s.trumtrar@pengutronix.de>

The driver is ported from Freescales Linux git and can be
found in the

	vendor/freescale/imx_2.6.35_maintain

branch.

According to that code, the RNGC is found on Freescales i.MX3/5 SoCs.
The i.MX2x actually has an RNGB, which has no driver implementation
in Freescales kernel. However as it turns out, the driver for the RNGC
works fine on the (at least) i.MX25. So, they seem to be somewhat
compatible.

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Reviewed-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
---
Changes in v5:
  - use only one completion for self test and seeding

Changes in v4:
  - use readl, writel instead of the __raw versions
  - move the self test to a separate function
  - remove the error checks before the self test,
    it'll fail when there are errors
  - run the self test in the probe function, add a parameter to skip it
  - read the error status register before we clear irq and error
  - rewrite the irq handler to read and store error status
  - helper functions for irq mask, unmask
  - remove some more unused defines
  - fix a bounds check in the read function
  - read function: check status before the fifo level
  - clean up the file header, add myself to the copyright notice

Changes in v3:
   - use pdev->dev to request the irq, rngc->dev is not yet initialized
   - remove unused defines for registers and fields
   - use module_platform_driver_probe()
   - clean up the error handling in the probe function,
     disable the clock if necessary
   - self-test must succeed in the first run
   - check for errors after seeding, exit for errors unrelated to
statistics
   - set a timeout when waiting for a completion

Changes in v2:
  - remove irq variable from private struct
  - move devm_request_irq from mxc_rngc_init to probe
  - return irq in case of error
  - handle irq 0 as error

 drivers/char/hw_random/Kconfig    |  13 ++
 drivers/char/hw_random/Makefile   |   1 +
 drivers/char/hw_random/mxc-rngc.c | 331 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 345 insertions(+)
 create mode 100644 drivers/char/hw_random/mxc-rngc.c

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 1b223c3..ef057b7 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -255,6 +255,19 @@ config HW_RANDOM_MXC_RNGA
 
 	  If unsure, say Y.
 
+config HW_RANDOM_MXC_RNGC
+	tristate "Freescale i.MX RNGC Random Number Generator"
+	depends on ARCH_MXC
+	default HW_RANDOM
+	---help---
+	  This driver provides kernel-side support for the Random Number
+	  Generator hardware found on some Freescale i.MX processors.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called mxc-rngc.
+
+	  If unsure, say Y.
+
 config HW_RANDOM_NOMADIK
 	tristate "ST-Ericsson Nomadik Random Number Generator support"
 	depends on ARCH_NOMADIK
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index b085975..043b71d 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_HW_RANDOM_PASEMI) += pasemi-rng.o
 obj-$(CONFIG_HW_RANDOM_VIRTIO) += virtio-rng.o
 obj-$(CONFIG_HW_RANDOM_TX4939) += tx4939-rng.o
 obj-$(CONFIG_HW_RANDOM_MXC_RNGA) += mxc-rnga.o
+obj-$(CONFIG_HW_RANDOM_MXC_RNGC) += mxc-rngc.o
 obj-$(CONFIG_HW_RANDOM_OCTEON) += octeon-rng.o
 obj-$(CONFIG_HW_RANDOM_NOMADIK) += nomadik-rng.o
 obj-$(CONFIG_HW_RANDOM_PSERIES) += pseries-rng.o
diff --git a/drivers/char/hw_random/mxc-rngc.c b/drivers/char/hw_random/mxc-rngc.c
new file mode 100644
index 0000000..aec1894
--- /dev/null
+++ b/drivers/char/hw_random/mxc-rngc.c
@@ -0,0 +1,331 @@
+/*
+ * RNG driver for Freescale RNGC
+ *
+ * Copyright (C) 2008-2012 Freescale Semiconductor, Inc.
+ * Copyright (C) 2017 Martin Kaiser <martin@kaiser.cx>
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/hw_random.h>
+#include <linux/completion.h>
+#include <linux/io.h>
+
+#define RNGC_COMMAND			0x0004
+#define RNGC_CONTROL			0x0008
+#define RNGC_STATUS			0x000C
+#define RNGC_ERROR			0x0010
+#define RNGC_FIFO			0x0014
+
+#define RNGC_CMD_CLR_ERR		0x00000020
+#define RNGC_CMD_CLR_INT		0x00000010
+#define RNGC_CMD_SEED			0x00000002
+#define RNGC_CMD_SELF_TEST		0x00000001
+
+#define RNGC_CTRL_MASK_ERROR		0x00000040
+#define RNGC_CTRL_MASK_DONE		0x00000020
+
+#define RNGC_STATUS_ERROR		0x00010000
+#define RNGC_STATUS_FIFO_LEVEL_MASK	0x00000f00
+#define RNGC_STATUS_FIFO_LEVEL_SHIFT	8
+#define RNGC_STATUS_SEED_DONE		0x00000020
+#define RNGC_STATUS_ST_DONE		0x00000010
+
+#define RNGC_ERROR_STATUS_STAT_ERR	0x00000008
+
+#define RNGC_TIMEOUT  3000 /* 3 sec */
+
+
+static bool self_test = true;
+module_param(self_test, bool, 0);
+
+struct mxc_rngc {
+	struct device		*dev;
+	struct clk		*clk;
+	void __iomem		*base;
+	struct hwrng		rng;
+	struct completion	rng_op_done;
+	/*
+	 * err_reg is written only by the irq handler and read only
+	 * when interrupts are masked, we need no spinlock
+	 */
+	u32			err_reg;
+};
+
+
+static inline void mxc_rngc_irq_mask_clear(struct mxc_rngc *rngc)
+{
+	u32 ctrl, cmd;
+
+	/* mask interrupts */
+	ctrl = readl(rngc->base + RNGC_CONTROL);
+	ctrl |= RNGC_CTRL_MASK_DONE | RNGC_CTRL_MASK_ERROR;
+	writel(ctrl, rngc->base + RNGC_CONTROL);
+
+	/*
+	 * CLR_INT clears the interrupt only if there's no error
+	 * CLR_ERR clear the interrupt and the error register if there
+	 * is an error
+	 */
+	cmd = readl(rngc->base + RNGC_COMMAND);
+	cmd |= RNGC_CMD_CLR_INT | RNGC_CMD_CLR_ERR;
+	writel(cmd, rngc->base + RNGC_COMMAND);
+}
+
+static inline void mxc_rngc_irq_unmask(struct mxc_rngc *rngc)
+{
+	u32 ctrl;
+
+	ctrl = readl(rngc->base + RNGC_CONTROL);
+	ctrl &= ~(RNGC_CTRL_MASK_DONE | RNGC_CTRL_MASK_ERROR);
+	writel(ctrl, rngc->base + RNGC_CONTROL);
+}
+
+static int mxc_rngc_self_test(struct mxc_rngc *rngc)
+{
+	u32 cmd;
+	int ret;
+
+	mxc_rngc_irq_unmask(rngc);
+
+	/* run self test */
+	cmd = readl(rngc->base + RNGC_COMMAND);
+	writel(cmd | RNGC_CMD_SELF_TEST, rngc->base + RNGC_COMMAND);
+
+	ret = wait_for_completion_timeout(&rngc->rng_op_done, RNGC_TIMEOUT);
+	if (!ret) {
+		mxc_rngc_irq_mask_clear(rngc);
+		return -ETIMEDOUT;
+	}
+
+	if (rngc->err_reg != 0)
+		return -EIO;
+
+	return 0;
+}
+
+static int mxc_rngc_read(struct hwrng *rng, void *data, size_t max, bool wait)
+{
+	struct mxc_rngc *rngc = container_of(rng, struct mxc_rngc, rng);
+	unsigned int status;
+	unsigned int level;
+	int retval = 0;
+
+	while (max >= sizeof(u32)) {
+		status = readl(rngc->base + RNGC_STATUS);
+
+		/* is there some error while reading this random number? */
+		if (status & RNGC_STATUS_ERROR)
+			break;
+
+		/* how many random numbers are in FIFO? [0-16] */
+		level = (status & RNGC_STATUS_FIFO_LEVEL_MASK) >>
+			RNGC_STATUS_FIFO_LEVEL_SHIFT;
+
+		if (level) {
+			/* retrieve a random number from FIFO */
+			*(u32 *)data = readl(rngc->base + RNGC_FIFO);
+
+			retval += sizeof(u32);
+			data += sizeof(u32);
+			max -= sizeof(u32);
+		}
+	}
+
+	return retval ? retval : -EIO;
+}
+
+static irqreturn_t mxc_rngc_irq(int irq, void *priv)
+{
+	struct mxc_rngc *rngc = (struct mxc_rngc *)priv;
+	u32 status;
+
+	/*
+	 * clearing the interrupt will also clear the error register
+	 * read error and status before clearing
+	 */
+	status = readl(rngc->base + RNGC_STATUS);
+	rngc->err_reg = readl(rngc->base + RNGC_ERROR);
+
+	mxc_rngc_irq_mask_clear(rngc);
+
+	if (status & (RNGC_STATUS_SEED_DONE | RNGC_STATUS_ST_DONE))
+		complete(&rngc->rng_op_done);
+
+	return IRQ_HANDLED;
+}
+
+static int mxc_rngc_init(struct hwrng *rng)
+{
+	struct mxc_rngc *rngc = container_of(rng, struct mxc_rngc, rng);
+	u32 cmd;
+	int ret;
+
+	/* clear error */
+	cmd = readl(rngc->base + RNGC_COMMAND);
+	writel(cmd | RNGC_CMD_CLR_ERR, rngc->base + RNGC_COMMAND);
+
+	/* create seed, repeat while there is some statistical error */
+	do {
+		mxc_rngc_irq_unmask(rngc);
+
+		/* seed creation */
+		cmd = readl(rngc->base + RNGC_COMMAND);
+		writel(cmd | RNGC_CMD_SEED, rngc->base + RNGC_COMMAND);
+
+		ret = wait_for_completion_timeout(&rngc->rng_op_done,
+				RNGC_TIMEOUT);
+
+		if (!ret) {
+			mxc_rngc_irq_mask_clear(rngc);
+			return -ETIMEDOUT;
+		}
+
+	} while (rngc->err_reg == RNGC_ERROR_STATUS_STAT_ERR);
+
+	return rngc->err_reg ? -EIO : 0;
+}
+
+static int mxc_rngc_probe(struct platform_device *pdev)
+{
+	struct mxc_rngc *rngc;
+	struct resource *res;
+	int ret;
+	int irq;
+
+	rngc = devm_kzalloc(&pdev->dev, sizeof(*rngc), GFP_KERNEL);
+	if (!rngc)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	rngc->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(rngc->base))
+		return PTR_ERR(rngc->base);
+
+	rngc->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(rngc->clk)) {
+		dev_err(&pdev->dev, "Can not get rng_clk\n");
+		return PTR_ERR(rngc->clk);
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq <= 0) {
+		dev_err(&pdev->dev, "Couldn't get irq %d\n", irq);
+		return irq;
+	}
+
+	ret = clk_prepare_enable(rngc->clk);
+	if (ret)
+		return ret;
+
+	ret = devm_request_irq(&pdev->dev,
+			irq, mxc_rngc_irq, 0, pdev->name, (void *)rngc);
+	if (ret) {
+		dev_err(rngc->dev, "Can't get interrupt working.\n");
+		goto err;
+	}
+
+	init_completion(&rngc->rng_op_done);
+
+	rngc->rng.name = pdev->name;
+	rngc->rng.init = mxc_rngc_init;
+	rngc->rng.read = mxc_rngc_read;
+
+	rngc->dev = &pdev->dev;
+	platform_set_drvdata(pdev, rngc);
+
+	mxc_rngc_irq_mask_clear(rngc);
+
+	if (self_test) {
+		ret = mxc_rngc_self_test(rngc);
+		if (ret) {
+			dev_err(rngc->dev, "FSL RNGC self test failed.\n");
+			goto err;
+		}
+	}
+
+	ret = hwrng_register(&rngc->rng);
+	if (ret) {
+		dev_err(&pdev->dev, "FSL RNGC registering failed (%d)\n", ret);
+		goto err;
+	}
+
+	dev_info(&pdev->dev, "Freescale RNGC registered.\n");
+	return 0;
+
+err:
+	clk_disable_unprepare(rngc->clk);
+
+	return ret;
+}
+
+static int __exit mxc_rngc_remove(struct platform_device *pdev)
+{
+	struct mxc_rngc *rngc = platform_get_drvdata(pdev);
+
+	hwrng_unregister(&rngc->rng);
+
+	clk_disable_unprepare(rngc->clk);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int mxc_rngc_suspend(struct device *dev)
+{
+	struct mxc_rngc *rngc = dev_get_drvdata(dev);
+
+	clk_disable_unprepare(rngc->clk);
+
+	return 0;
+}
+
+static int mxc_rngc_resume(struct device *dev)
+{
+	struct mxc_rngc *rngc = dev_get_drvdata(dev);
+
+	clk_prepare_enable(rngc->clk);
+
+	return 0;
+}
+
+static const struct dev_pm_ops mxc_rngc_pm_ops = {
+	.suspend	= mxc_rngc_suspend,
+	.resume		= mxc_rngc_resume,
+};
+#endif
+
+static const struct of_device_id mxc_rngc_dt_ids[] = {
+	{ .compatible = "fsl,imx25-rng", .data = NULL, },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, mxc_rngc_dt_ids);
+
+static struct platform_driver mxc_rngc_driver = {
+	.driver = {
+		.name = "mxc_rngc",
+#ifdef CONFIG_PM
+		.pm = &mxc_rngc_pm_ops,
+#endif
+		.of_match_table = mxc_rngc_dt_ids,
+	},
+	.remove = __exit_p(mxc_rngc_remove),
+};
+
+module_platform_driver_probe(mxc_rngc_driver, mxc_rngc_probe);
+
+MODULE_AUTHOR("Freescale Semiconductor, Inc.");
+MODULE_DESCRIPTION("H/W RNGC driver for i.MX");
+MODULE_LICENSE("GPL");
-- 
2.1.4
