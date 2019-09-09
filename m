Return-Path: <SRS0=QtXc=XE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13FB3C433EF
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 12:40:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCB0F21924
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 12:40:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbfIIMkM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Sep 2019 08:40:12 -0400
Received: from 212.199.177.27.static.012.net.il ([212.199.177.27]:42625 "EHLO
        herzl.nuvoton.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727828AbfIIMkM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Sep 2019 08:40:12 -0400
Received: from taln60.nuvoton.co.il (ntil-fw [212.199.177.25])
        by herzl.nuvoton.co.il (8.13.8/8.13.8) with ESMTP id x89CcfEp029014;
        Mon, 9 Sep 2019 15:38:41 +0300
Received: by taln60.nuvoton.co.il (Postfix, from userid 10070)
        id CB24462CAA; Mon,  9 Sep 2019 15:38:41 +0300 (IDT)
From:   Tomer Maimon <tmaimon77@gmail.com>
To:     mpm@selenic.com, herbert@gondor.apana.org.au, arnd@arndb.de,
        gregkh@linuxfoundation.org, robh+dt@kernel.org,
        mark.rutland@arm.com, avifishman70@gmail.com,
        tali.perry1@gmail.com, venture@google.com, yuenn@google.com,
        benjaminfair@google.com, sumit.garg@linaro.org,
        jens.wiklander@linaro.org, vkoul@kernel.org, tglx@linutronix.de,
        joel@jms.id.au
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, openbmc@lists.ozlabs.org,
        Tomer Maimon <tmaimon77@gmail.com>
Subject: [PATCH v2 2/2] hwrng: npcm: add NPCM RNG driver
Date:   Mon,  9 Sep 2019 15:38:40 +0300
Message-Id: <20190909123840.154745-3-tmaimon77@gmail.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20190909123840.154745-1-tmaimon77@gmail.com>
References: <20190909123840.154745-1-tmaimon77@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add Nuvoton NPCM BMC Random Number Generator(RNG) driver.

Signed-off-by: Tomer Maimon <tmaimon77@gmail.com>
---
 drivers/char/hw_random/Kconfig    |  13 ++
 drivers/char/hw_random/Makefile   |   1 +
 drivers/char/hw_random/npcm-rng.c | 203 ++++++++++++++++++++++++++++++
 3 files changed, 217 insertions(+)
 create mode 100644 drivers/char/hw_random/npcm-rng.c

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 59f25286befe..87a1c30e7958 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -440,6 +440,19 @@ config HW_RANDOM_OPTEE
 
 	  If unsure, say Y.
 
+config HW_RANDOM_NPCM
+	tristate "NPCM Random Number Generator support"
+	depends on ARCH_NPCM || COMPILE_TEST
+	default HW_RANDOM
+	help
+ 	  This driver provides support for the Random Number
+	  Generator hardware available in Nuvoton NPCM SoCs.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called npcm-rng.
+
+ 	  If unsure, say Y.
+
 endif # HW_RANDOM
 
 config UML_RANDOM
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index 7c9ef4a7667f..17b6d4e6d591 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -39,3 +39,4 @@ obj-$(CONFIG_HW_RANDOM_MTK)	+= mtk-rng.o
 obj-$(CONFIG_HW_RANDOM_S390) += s390-trng.o
 obj-$(CONFIG_HW_RANDOM_KEYSTONE) += ks-sa-rng.o
 obj-$(CONFIG_HW_RANDOM_OPTEE) += optee-rng.o
+obj-$(CONFIG_HW_RANDOM_NPCM) += npcm-rng.o
diff --git a/drivers/char/hw_random/npcm-rng.c b/drivers/char/hw_random/npcm-rng.c
new file mode 100644
index 000000000000..3ed396474563
--- /dev/null
+++ b/drivers/char/hw_random/npcm-rng.c
@@ -0,0 +1,203 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2019 Nuvoton Technology corporation.
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/iopoll.h>
+#include <linux/init.h>
+#include <linux/random.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/hw_random.h>
+#include <linux/delay.h>
+#include <linux/of_irq.h>
+#include <linux/pm_runtime.h>
+
+#define NPCM_RNGCS_REG		0x00	/* Control and status register */
+#define NPCM_RNGD_REG		0x04	/* Data register */
+#define NPCM_RNGMODE_REG	0x08	/* Mode register */
+
+#define NPCM_RNG_CLK_SET_25MHZ	GENMASK(4, 3) /* 20-25 MHz */
+#define NPCM_RNG_DATA_VALID	BIT(1)
+#define NPCM_RNG_ENABLE		BIT(0)
+#define NPCM_RNG_M1ROSEL	BIT(1)
+
+#define NPCM_RNG_TIMEOUT_USEC	20000
+#define NPCM_RNG_POLL_USEC	1000
+
+#define to_npcm_rng(p)	container_of(p, struct npcm_rng, rng)
+
+struct npcm_rng {
+	void __iomem *base;
+	struct hwrng rng;
+};
+
+static int npcm_rng_init(struct hwrng *rng)
+{
+	struct npcm_rng *priv = to_npcm_rng(rng);
+	u32 val;
+
+	val = readl(priv->base + NPCM_RNGCS_REG);
+	val |= NPCM_RNG_ENABLE;
+	writel(val, priv->base + NPCM_RNGCS_REG);
+
+	return 0;
+}
+
+static void npcm_rng_cleanup(struct hwrng *rng)
+{
+	struct npcm_rng *priv = to_npcm_rng(rng);
+	u32 val;
+
+	val = readl(priv->base + NPCM_RNGCS_REG);
+	val &= ~NPCM_RNG_ENABLE;
+	writel(val, priv->base + NPCM_RNGCS_REG);
+}
+
+static int npcm_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
+{
+	struct npcm_rng *priv = to_npcm_rng(rng);
+	int retval = 0;
+	int ready;
+
+	pm_runtime_get_sync((struct device *)priv->rng.priv);
+
+	while (max >= sizeof(u32)) {
+		ready = readl(priv->base + NPCM_RNGCS_REG) &
+			NPCM_RNG_DATA_VALID;
+		if (!ready) {
+			if (wait) {
+				if (readl_poll_timeout(priv->base + NPCM_RNGCS_REG,
+						       ready,
+						       ready & NPCM_RNG_DATA_VALID,
+						       NPCM_RNG_POLL_USEC,
+						       NPCM_RNG_TIMEOUT_USEC))
+					break;
+			} else {
+				break;
+			}
+		}
+
+		*(u32 *)buf = readl(priv->base + NPCM_RNGD_REG);
+		retval += sizeof(u32);
+		buf += sizeof(u32);
+		max -= sizeof(u32);
+	}
+
+	pm_runtime_mark_last_busy((struct device *)priv->rng.priv);
+	pm_runtime_put_sync_autosuspend((struct device *)priv->rng.priv);
+
+	return retval || !wait ? retval : -EIO;
+}
+
+static int npcm_rng_probe(struct platform_device *pdev)
+{
+	struct npcm_rng *priv;
+	struct resource *res;
+	bool pm_dis = false;
+	u32 quality;
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
+	priv->rng.name = pdev->name;
+#ifndef CONFIG_PM
+	pm_dis = true;
+	priv->rng.init = npcm_rng_init;
+	priv->rng.cleanup = npcm_rng_cleanup;
+#endif
+	priv->rng.read = npcm_rng_read;
+	priv->rng.priv = (unsigned long)&pdev->dev;
+	if (of_property_read_u32(pdev->dev.of_node, "quality", &quality))
+		priv->rng.quality = 1000;
+	else
+		priv->rng.quality = quality;
+
+	writel(NPCM_RNG_M1ROSEL, priv->base + NPCM_RNGMODE_REG);
+	if (pm_dis)
+		writel(NPCM_RNG_CLK_SET_25MHZ, priv->base + NPCM_RNGCS_REG);
+	else
+		writel(NPCM_RNG_CLK_SET_25MHZ | NPCM_RNG_ENABLE,
+		       priv->base + NPCM_RNGCS_REG);
+
+	ret = devm_hwrng_register(&pdev->dev, &priv->rng);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to register rng device: %d\n",
+			ret);
+		return ret;
+	}
+
+	dev_set_drvdata(&pdev->dev, priv);
+	pm_runtime_set_autosuspend_delay(&pdev->dev, 100);
+	pm_runtime_use_autosuspend(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+
+	return 0;
+}
+
+static int npcm_rng_remove(struct platform_device *pdev)
+{
+	struct npcm_rng *priv = platform_get_drvdata(pdev);
+
+	hwrng_unregister(&priv->rng);
+	pm_runtime_disable(&pdev->dev);
+	pm_runtime_set_suspended(&pdev->dev);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int npcm_rng_runtime_suspend(struct device *dev)
+{
+	struct npcm_rng *priv = dev_get_drvdata(dev);
+
+	npcm_rng_cleanup(&priv->rng);
+
+	return 0;
+}
+
+static int npcm_rng_runtime_resume(struct device *dev)
+{
+	struct npcm_rng *priv = dev_get_drvdata(dev);
+
+	return npcm_rng_init(&priv->rng);
+}
+#endif
+
+static const struct dev_pm_ops npcm_rng_pm_ops = {
+	SET_RUNTIME_PM_OPS(npcm_rng_runtime_suspend,
+			   npcm_rng_runtime_resume, NULL)
+	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
+				pm_runtime_force_resume)
+};
+
+static const struct of_device_id rng_dt_id[] = {
+	{ .compatible = "nuvoton,npcm750-rng",  },
+	{},
+};
+MODULE_DEVICE_TABLE(of, rng_dt_id);
+
+static struct platform_driver npcm_rng_driver = {
+	.driver = {
+		.name		= "npcm-rng",
+		.pm		= &npcm_rng_pm_ops,
+		.owner		= THIS_MODULE,
+		.of_match_table = of_match_ptr(rng_dt_id),
+	},
+	.probe		= npcm_rng_probe,
+	.remove		= npcm_rng_remove,
+};
+
+module_platform_driver(npcm_rng_driver);
+
+MODULE_DESCRIPTION("Nuvoton NPCM Random Number Generator Driver");
+MODULE_AUTHOR("Tomer Maimon <tomer.maimon@nuvoton.com>");
+MODULE_LICENSE("GPL v2");
-- 
2.18.0

