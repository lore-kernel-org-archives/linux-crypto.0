From: Christian Lamparter <chunkeey@googlemail.com>
Subject: Re: crash in ppc4xx-rng on canyonland
Date: Sat, 09 Apr 2016 00:28:03 +0200
Message-ID: <2508973.j7LtCUZRGZ@debian64>
References: <20160405121118.GA12591@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:36093 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757932AbcDHW2I (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Apr 2016 18:28:08 -0400
Received: by mail-wm0-f44.google.com with SMTP id v188so30910860wme.1
        for <linux-crypto@vger.kernel.org>; Fri, 08 Apr 2016 15:28:07 -0700 (PDT)
In-Reply-To: <20160405121118.GA12591@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tuesday, April 05, 2016 08:11:19 PM Herbert Xu wrote:
> Christian Lamparter <chunkeey@googlemail.com> wrote:
> >
> > The crash is caused by a bad read in ppc4xx_rng_enable [0]. From what I
> > can tell, the driver is mapping the crypto control registers. The
> > problem is that they are claimed by the main crypto driver: crypto4xx [1].
> > 
> > I'm not sure what to do in this case. In my opinion the crypto4xx driver
> > should just initialize the trng [see patch]. I would like to move the
> > trng into the crypto-ppc4xx, but given that this breaks some of the DTS
> > out there I'm not sure.
> 
> I think you'll also need to ensure that the crypto module is
> successfully loaded before the RNG is accessed.
> 
> It's probably easier to just merge the two drivers but still
> maintaining the original driver names.

I tried to move ppc4xx-rng into crypto4xx (see attachment - patch #1).
The driver works as is. But I can't come up with a way to attach the
crypto4xx driver to the ppc4xx-rng OF node cleanly. Basically,
I'm looking for a way to have one driver (with one context) be 
in charge of two different OF nodes (ppc4xx-rng and ppc4xx-crypto).
Is there any solution to this? Because otherwise, I would add a
bool ppc4xx_trng variable in crypto4xx_core.c and use EXPORT_SYMBOL...
[see patch #2]


---
Patch #1

>From 156bcb0eb06361c1668237ed2d0c3227b0837ff3 Mon Sep 17 00:00:00 2001
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Fri, 25 Mar 2016 19:00:05 +0100
Subject: [PATCH] crypto4xx: integrate ppc4xx-rng into crypto4xx

This patch integrates the ppc4xx-rng driver into the existing
crypto4xx. This is because the true random number generator
is controlled and part of the security core.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/char/hw_random/Kconfig          |  13 ---
 drivers/char/hw_random/Makefile         |   1 -
 drivers/char/hw_random/ppc4xx-rng.c     | 147 --------------------------------
 drivers/crypto/Kconfig                  |   8 ++
 drivers/crypto/amcc/Makefile            |   1 +
 drivers/crypto/amcc/crypto4xx_core.c    |   7 +-
 drivers/crypto/amcc/crypto4xx_core.h    |   4 +
 drivers/crypto/amcc/crypto4xx_reg_def.h |   1 +
 drivers/crypto/amcc/crypto4xx_trng.c    | 128 +++++++++++++++++++++++++++
 drivers/crypto/amcc/crypto4xx_trng.h    |  34 ++++++++
 10 files changed, 181 insertions(+), 163 deletions(-)
 delete mode 100644 drivers/char/hw_random/ppc4xx-rng.c
 create mode 100644 drivers/crypto/amcc/crypto4xx_trng.c
 create mode 100644 drivers/crypto/amcc/crypto4xx_trng.h

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 67ee8b0..a6d7b9b 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -268,19 +268,6 @@ config HW_RANDOM_NOMADIK
 
 	  If unsure, say Y.
 
-config HW_RANDOM_PPC4XX
-	tristate "PowerPC 4xx generic true random number generator support"
-	depends on PPC && 4xx
-	default HW_RANDOM
-	---help---
-	 This driver provides the kernel-side support for the TRNG hardware
-	 found in the security function of some PowerPC 4xx SoCs.
-
-	 To compile this driver as a module, choose M here: the
-	 module will be called ppc4xx-rng.
-
-	 If unsure, say N.
-
 config HW_RANDOM_PSERIES
 	tristate "pSeries HW Random Number Generator support"
 	depends on PPC64 && IBMVIO
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index f5a6fa7..079745f 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -22,7 +22,6 @@ obj-$(CONFIG_HW_RANDOM_TX4939) += tx4939-rng.o
 obj-$(CONFIG_HW_RANDOM_MXC_RNGA) += mxc-rnga.o
 obj-$(CONFIG_HW_RANDOM_OCTEON) += octeon-rng.o
 obj-$(CONFIG_HW_RANDOM_NOMADIK) += nomadik-rng.o
-obj-$(CONFIG_HW_RANDOM_PPC4XX) += ppc4xx-rng.o
 obj-$(CONFIG_HW_RANDOM_PSERIES) += pseries-rng.o
 obj-$(CONFIG_HW_RANDOM_POWERNV) += powernv-rng.o
 obj-$(CONFIG_HW_RANDOM_EXYNOS)	+= exynos-rng.o
diff --git a/drivers/char/hw_random/ppc4xx-rng.c b/drivers/char/hw_random/ppc4xx-rng.c
deleted file mode 100644
index c0db438..0000000
--- a/drivers/char/hw_random/ppc4xx-rng.c
+++ /dev/null
@@ -1,147 +0,0 @@
-/*
- * Generic PowerPC 44x RNG driver
- *
- * Copyright 2011 IBM Corporation
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the
- * Free Software Foundation; version 2 of the License.
- */
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/platform_device.h>
-#include <linux/hw_random.h>
-#include <linux/delay.h>
-#include <linux/of_address.h>
-#include <linux/of_platform.h>
-#include <asm/io.h>
-
-#define PPC4XX_TRNG_DEV_CTRL 0x60080
-
-#define PPC4XX_TRNGE 0x00020000
-#define PPC4XX_TRNG_CTRL 0x0008
-#define PPC4XX_TRNG_CTRL_DALM 0x20
-#define PPC4XX_TRNG_STAT 0x0004
-#define PPC4XX_TRNG_STAT_B 0x1
-#define PPC4XX_TRNG_DATA 0x0000
-
-#define MODULE_NAME "ppc4xx_rng"
-
-static int ppc4xx_rng_data_present(struct hwrng *rng, int wait)
-{
-	void __iomem *rng_regs = (void __iomem *) rng->priv;
-	int busy, i, present = 0;
-
-	for (i = 0; i < 20; i++) {
-		busy = (in_le32(rng_regs + PPC4XX_TRNG_STAT) & PPC4XX_TRNG_STAT_B);
-		if (!busy || !wait) {
-			present = 1;
-			break;
-		}
-		udelay(10);
-	}
-	return present;
-}
-
-static int ppc4xx_rng_data_read(struct hwrng *rng, u32 *data)
-{
-	void __iomem *rng_regs = (void __iomem *) rng->priv;
-	*data = in_le32(rng_regs + PPC4XX_TRNG_DATA);
-	return 4;
-}
-
-static int ppc4xx_rng_enable(int enable)
-{
-	struct device_node *ctrl;
-	void __iomem *ctrl_reg;
-	int err = 0;
-	u32 val;
-
-	/* Find the main crypto device node and map it to turn the TRNG on */
-	ctrl = of_find_compatible_node(NULL, NULL, "amcc,ppc4xx-crypto");
-	if (!ctrl)
-		return -ENODEV;
-
-	ctrl_reg = of_iomap(ctrl, 0);
-	if (!ctrl_reg) {
-		err = -ENODEV;
-		goto out;
-	}
-
-	val = in_le32(ctrl_reg + PPC4XX_TRNG_DEV_CTRL);
-
-	if (enable)
-		val |= PPC4XX_TRNGE;
-	else
-		val = val & ~PPC4XX_TRNGE;
-
-	out_le32(ctrl_reg + PPC4XX_TRNG_DEV_CTRL, val);
-	iounmap(ctrl_reg);
-
-out:
-	of_node_put(ctrl);
-
-	return err;
-}
-
-static struct hwrng ppc4xx_rng = {
-	.name = MODULE_NAME,
-	.data_present = ppc4xx_rng_data_present,
-	.data_read = ppc4xx_rng_data_read,
-};
-
-static int ppc4xx_rng_probe(struct platform_device *dev)
-{
-	void __iomem *rng_regs;
-	int err = 0;
-
-	rng_regs = of_iomap(dev->dev.of_node, 0);
-	if (!rng_regs)
-		return -ENODEV;
-
-	err = ppc4xx_rng_enable(1);
-	if (err)
-		return err;
-
-	out_le32(rng_regs + PPC4XX_TRNG_CTRL, PPC4XX_TRNG_CTRL_DALM);
-	ppc4xx_rng.priv = (unsigned long) rng_regs;
-
-	err = hwrng_register(&ppc4xx_rng);
-
-	return err;
-}
-
-static int ppc4xx_rng_remove(struct platform_device *dev)
-{
-	void __iomem *rng_regs = (void __iomem *) ppc4xx_rng.priv;
-
-	hwrng_unregister(&ppc4xx_rng);
-	ppc4xx_rng_enable(0);
-	iounmap(rng_regs);
-
-	return 0;
-}
-
-static const struct of_device_id ppc4xx_rng_match[] = {
-	{ .compatible = "ppc4xx-rng", },
-	{ .compatible = "amcc,ppc460ex-rng", },
-	{ .compatible = "amcc,ppc440epx-rng", },
-	{},
-};
-MODULE_DEVICE_TABLE(of, ppc4xx_rng_match);
-
-static struct platform_driver ppc4xx_rng_driver = {
-	.driver = {
-		.name = MODULE_NAME,
-		.of_match_table = ppc4xx_rng_match,
-	},
-	.probe = ppc4xx_rng_probe,
-	.remove = ppc4xx_rng_remove,
-};
-
-module_platform_driver(ppc4xx_rng_driver);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Josh Boyer <jwboyer@linux.vnet.ibm.com>");
-MODULE_DESCRIPTION("HW RNG driver for PPC 4xx processors");
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 477fffd..55cef158 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -279,6 +279,14 @@ config CRYPTO_DEV_PPC4XX
 	help
 	  This option allows you to have support for AMCC crypto acceleration.
 
+config HW_RANDOM_PPC4XX
+	bool "PowerPC 4xx generic true random number generator support"
+	depends on CRYPTO_DEV_PPC4XX && HW_RANDOM
+	default y
+	---help---
+	 This option provides the kernel-side support for the TRNG hardware
+	 found in the security function of some PowerPC 4xx SoCs.
+
 config CRYPTO_DEV_OMAP_SHAM
 	tristate "Support for OMAP MD5/SHA1/SHA2 hw accelerator"
 	depends on ARCH_OMAP2PLUS
diff --git a/drivers/crypto/amcc/Makefile b/drivers/crypto/amcc/Makefile
index 5c0c62b..b955399 100644
--- a/drivers/crypto/amcc/Makefile
+++ b/drivers/crypto/amcc/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_CRYPTO_DEV_PPC4XX) += crypto4xx.o
 crypto4xx-y :=  crypto4xx_core.o crypto4xx_alg.o crypto4xx_sa.o
+crypto4xx-$(CONFIG_HW_RANDOM_PPC4XX) += crypto4xx_trng.o
diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 62134c8..dae1e39 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -40,6 +40,7 @@
 #include "crypto4xx_reg_def.h"
 #include "crypto4xx_core.h"
 #include "crypto4xx_sa.h"
+#include "crypto4xx_trng.h"
 
 #define PPC4XX_SEC_VERSION_STR			"0.5"
 
@@ -1225,6 +1226,7 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 	if (rc)
 		goto err_start_dev;
 
+	ppc4xx_trng_probe(core_dev);
 	return 0;
 
 err_start_dev:
@@ -1252,6 +1254,8 @@ static int crypto4xx_remove(struct platform_device *ofdev)
 	struct device *dev = &ofdev->dev;
 	struct crypto4xx_core_device *core_dev = dev_get_drvdata(dev);
 
+	ppc4xx_trng_remove(core_dev);
+
 	free_irq(core_dev->irq, dev);
 	irq_dispose_mapping(core_dev->irq);
 
@@ -1272,7 +1276,7 @@ MODULE_DEVICE_TABLE(of, crypto4xx_match);
 
 static struct platform_driver crypto4xx_driver = {
 	.driver = {
-		.name = "crypto4xx",
+		.name = MODULE_NAME,
 		.of_match_table = crypto4xx_match,
 	},
 	.probe		= crypto4xx_probe,
@@ -1284,4 +1288,3 @@ module_platform_driver(crypto4xx_driver);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("James Hsiao <jhsiao@amcc.com>");
 MODULE_DESCRIPTION("Driver for AMCC PPC4xx crypto accelerator");
-
diff --git a/drivers/crypto/amcc/crypto4xx_core.h b/drivers/crypto/amcc/crypto4xx_core.h
index bac0bde..ecfdcfe 100644
--- a/drivers/crypto/amcc/crypto4xx_core.h
+++ b/drivers/crypto/amcc/crypto4xx_core.h
@@ -24,6 +24,8 @@
 
 #include <crypto/internal/hash.h>
 
+#define MODULE_NAME "crypto4xx"
+
 #define PPC460SX_SDR0_SRST                      0x201
 #define PPC405EX_SDR0_SRST                      0x200
 #define PPC460EX_SDR0_SRST                      0x201
@@ -72,6 +74,7 @@ struct crypto4xx_device {
 	char *name;
 	u64  ce_phy_address;
 	void __iomem *ce_base;
+	void __iomem *trng_base;
 
 	void *pdr;			/* base address of packet
 					descriptor ring */
@@ -106,6 +109,7 @@ struct crypto4xx_core_device {
 	struct device *device;
 	struct platform_device *ofdev;
 	struct crypto4xx_device *dev;
+	struct hwrng *trng;
 	u32 int_status;
 	u32 irq;
 	struct tasklet_struct tasklet;
diff --git a/drivers/crypto/amcc/crypto4xx_reg_def.h b/drivers/crypto/amcc/crypto4xx_reg_def.h
index 5f5fbc0..46fe57c 100644
--- a/drivers/crypto/amcc/crypto4xx_reg_def.h
+++ b/drivers/crypto/amcc/crypto4xx_reg_def.h
@@ -125,6 +125,7 @@
 #define PPC4XX_INTERRUPT_CLR			0x3ffff
 #define PPC4XX_PRNG_CTRL_AUTO_EN		0x3
 #define PPC4XX_DC_3DES_EN			1
+#define PPC4XX_TRNG_EN				0x00020000
 #define PPC4XX_INT_DESCR_CNT			4
 #define PPC4XX_INT_TIMEOUT_CNT			0
 #define PPC4XX_INT_CFG				1
diff --git a/drivers/crypto/amcc/crypto4xx_trng.c b/drivers/crypto/amcc/crypto4xx_trng.c
new file mode 100644
index 0000000..5ae5b82
--- /dev/null
+++ b/drivers/crypto/amcc/crypto4xx_trng.c
@@ -0,0 +1,128 @@
+/*
+ * Generic PowerPC 44x RNG driver
+ *
+ * Copyright 2011 IBM Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; version 2 of the License.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/hw_random.h>
+#include <linux/delay.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
+#include <linux/io.h>
+
+#include "crypto4xx_core.h"
+#include "crypto4xx_trng.h"
+#include "crypto4xx_reg_def.h"
+
+#define PPC4XX_TRNG_CTRL	0x0008
+#define PPC4XX_TRNG_CTRL_DALM	0x20
+#define PPC4XX_TRNG_STAT	0x0004
+#define PPC4XX_TRNG_STAT_B	0x1
+#define PPC4XX_TRNG_DATA	0x0000
+
+static int ppc4xx_trng_data_present(struct hwrng *rng, int wait)
+{
+	struct crypto4xx_device *dev = (void *)rng->priv;
+	int busy, i, present = 0;
+
+	for (i = 0; i < 20; i++) {
+		busy = (in_le32(dev->trng_base + PPC4XX_TRNG_STAT) &
+			PPC4XX_TRNG_STAT_B);
+		if (!busy || !wait) {
+			present = 1;
+			break;
+		}
+		udelay(10);
+	}
+	return present;
+}
+
+static int ppc4xx_trng_data_read(struct hwrng *rng, u32 *data)
+{
+	struct crypto4xx_device *dev = (void *)rng->priv;
+	*data = in_le32(dev->trng_base + PPC4XX_TRNG_DATA);
+	return 4;
+}
+
+static void ppc4xx_trng_enable(struct crypto4xx_device *dev, bool enable)
+{
+	u32 device_ctrl;
+
+	device_ctrl = readl(dev->ce_base + CRYPTO4XX_DEVICE_CTRL);
+	if (enable)
+		device_ctrl |= PPC4XX_TRNG_EN;
+	else
+		device_ctrl &= ~PPC4XX_TRNG_EN;
+	writel(device_ctrl, dev->ce_base + CRYPTO4XX_DEVICE_CTRL);
+}
+
+static const struct of_device_id ppc4xx_trng_match[] = {
+	{ .compatible = "ppc4xx-rng", },
+	{ .compatible = "amcc,ppc460ex-rng", },
+	{ .compatible = "amcc,ppc440epx-rng", },
+	{},
+};
+
+void ppc4xx_trng_probe(struct crypto4xx_core_device *core_dev)
+{
+	struct crypto4xx_device *dev = core_dev->dev;
+	struct device_node *trng = NULL;
+	struct hwrng *rng = NULL;
+	int err;
+
+	/* Find the TRNG device node and map it */
+	trng = of_find_matching_node(NULL, ppc4xx_trng_match);
+	if (!trng)
+		return;
+
+	dev->trng_base = of_iomap(trng, 0);
+	of_node_put(trng);
+	if (!dev->trng_base)
+		goto err_out;
+
+	rng = kzalloc(sizeof(*rng), GFP_KERNEL);
+	if (!rng)
+		goto err_out;
+
+	rng->name = MODULE_NAME;
+	rng->data_present = ppc4xx_trng_data_present;
+	rng->data_read = ppc4xx_trng_data_read;
+	rng->priv = (unsigned long) dev;
+	core_dev->trng = rng;
+	ppc4xx_trng_enable(dev, true);
+	out_le32(dev->trng_base + PPC4XX_TRNG_CTRL, PPC4XX_TRNG_CTRL_DALM);
+	err = devm_hwrng_register(core_dev->device, core_dev->trng);
+	if (err) {
+		dev_err(core_dev->device, "failed to register hwrng (%d).\n",
+			err);
+		goto err_out;
+	}
+	return;
+
+err_out:
+	of_node_put(trng);
+	iounmap(dev->trng_base);
+	kfree(rng);
+	dev->trng_base = NULL;
+	core_dev->trng = NULL;
+}
+
+void ppc4xx_trng_remove(struct crypto4xx_core_device *core_dev)
+{
+	struct crypto4xx_device *dev = core_dev->dev;
+
+	devm_hwrng_unregister(core_dev->device, core_dev->trng);
+	ppc4xx_trng_enable(dev, false);
+	iounmap(dev->trng_base);
+	kfree(core_dev->trng);
+}
+
+MODULE_ALIAS("ppc4xx_rng");
diff --git a/drivers/crypto/amcc/crypto4xx_trng.h b/drivers/crypto/amcc/crypto4xx_trng.h
new file mode 100644
index 0000000..931d225
--- /dev/null
+++ b/drivers/crypto/amcc/crypto4xx_trng.h
@@ -0,0 +1,34 @@
+/**
+ * AMCC SoC PPC4xx Crypto Driver
+ *
+ * Copyright (c) 2008 Applied Micro Circuits Corporation.
+ * All rights reserved. James Hsiao <jhsiao@amcc.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * This file defines the security context
+ * associate format.
+ */
+
+#ifndef __CRYPTO4XX_TRNG_H__
+#define __CRYPTO4XX_TRNG_H__
+
+#ifdef CONFIG_HW_RANDOM_PPC4XX
+void ppc4xx_trng_probe(struct crypto4xx_core_device *core_dev);
+void ppc4xx_trng_remove(struct crypto4xx_core_device *core_dev);
+#else
+static inline void ppc4xx_trng_probe(
+	struct crypto4xx_device *dev __maybe_unused) { }
+static inline void ppc4xx_trng_remove(
+	struct crypto4xx_device *dev __maybe_unused) { }
+#endif
+
+#endif
---


And here's the second patch

---

Patch #2

>From 0138eeb265fd63b71535c8de306839c966aec76d Mon Sep 17 00:00:00 2001
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Fri, 25 Mar 2016 19:00:05 +0100
Subject: [PATCH] ppc4xx-rng: fix crash during init

This patch fixes a crash that happens in the ppc4xx-rng driver
when accessing the main crypto core to enable the true random
number generator. The ppc4xx-rng driver now depends on the
crypto4xx driver to initialize the true random number generator.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/char/hw_random/ppc4xx-rng.c     | 47 ++++-----------------------------
 drivers/crypto/amcc/crypto4xx_core.c    |  7 +++++
 drivers/crypto/amcc/crypto4xx_reg_def.h |  1 +
 3 files changed, 13 insertions(+), 42 deletions(-)

diff --git a/drivers/char/hw_random/ppc4xx-rng.c b/drivers/char/hw_random/ppc4xx-rng.c
index c0db438..b977056 100644
--- a/drivers/char/hw_random/ppc4xx-rng.c
+++ b/drivers/char/hw_random/ppc4xx-rng.c
@@ -17,9 +17,6 @@
 #include <linux/of_platform.h>
 #include <asm/io.h>
 
-#define PPC4XX_TRNG_DEV_CTRL 0x60080
-
-#define PPC4XX_TRNGE 0x00020000
 #define PPC4XX_TRNG_CTRL 0x0008
 #define PPC4XX_TRNG_CTRL_DALM 0x20
 #define PPC4XX_TRNG_STAT 0x0004
@@ -28,11 +25,16 @@
 
 #define MODULE_NAME "ppc4xx_rng"
 
+extern bool ppc4xx_trng;
+
 static int ppc4xx_rng_data_present(struct hwrng *rng, int wait)
 {
 	void __iomem *rng_regs = (void __iomem *) rng->priv;
 	int busy, i, present = 0;
 
+	if (!ppc4xx_trng)
+		return 0;
+
 	for (i = 0; i < 20; i++) {
 		busy = (in_le32(rng_regs + PPC4XX_TRNG_STAT) & PPC4XX_TRNG_STAT_B);
 		if (!busy || !wait) {
@@ -51,40 +53,6 @@ static int ppc4xx_rng_data_read(struct hwrng *rng, u32 *data)
 	return 4;
 }
 
-static int ppc4xx_rng_enable(int enable)
-{
-	struct device_node *ctrl;
-	void __iomem *ctrl_reg;
-	int err = 0;
-	u32 val;
-
-	/* Find the main crypto device node and map it to turn the TRNG on */
-	ctrl = of_find_compatible_node(NULL, NULL, "amcc,ppc4xx-crypto");
-	if (!ctrl)
-		return -ENODEV;
-
-	ctrl_reg = of_iomap(ctrl, 0);
-	if (!ctrl_reg) {
-		err = -ENODEV;
-		goto out;
-	}
-
-	val = in_le32(ctrl_reg + PPC4XX_TRNG_DEV_CTRL);
-
-	if (enable)
-		val |= PPC4XX_TRNGE;
-	else
-		val = val & ~PPC4XX_TRNGE;
-
-	out_le32(ctrl_reg + PPC4XX_TRNG_DEV_CTRL, val);
-	iounmap(ctrl_reg);
-
-out:
-	of_node_put(ctrl);
-
-	return err;
-}
-
 static struct hwrng ppc4xx_rng = {
 	.name = MODULE_NAME,
 	.data_present = ppc4xx_rng_data_present,
@@ -100,10 +68,6 @@ static int ppc4xx_rng_probe(struct platform_device *dev)
 	if (!rng_regs)
 		return -ENODEV;
 
-	err = ppc4xx_rng_enable(1);
-	if (err)
-		return err;
-
 	out_le32(rng_regs + PPC4XX_TRNG_CTRL, PPC4XX_TRNG_CTRL_DALM);
 	ppc4xx_rng.priv = (unsigned long) rng_regs;
 
@@ -117,7 +81,6 @@ static int ppc4xx_rng_remove(struct platform_device *dev)
 	void __iomem *rng_regs = (void __iomem *) ppc4xx_rng.priv;
 
 	hwrng_unregister(&ppc4xx_rng);
-	ppc4xx_rng_enable(0);
 	iounmap(rng_regs);
 
 	return 0;
diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 62134c8..bd56b11 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -43,6 +43,9 @@
 
 #define PPC4XX_SEC_VERSION_STR			"0.5"
 
+bool ppc4xx_trng;
+EXPORT_SYMBOL_GPL(ppc4xx_trng);
+
 /**
  * PPC4xx Crypto Engine Initialization Routine
  */
@@ -90,6 +93,7 @@ static void crypto4xx_hw_init(struct crypto4xx_device *dev)
 	writel(ring_ctrl.w, dev->ce_base + CRYPTO4XX_RING_CTRL);
 	device_ctrl = readl(dev->ce_base + CRYPTO4XX_DEVICE_CTRL);
 	device_ctrl |= PPC4XX_DC_3DES_EN;
+	device_ctrl |= PPC4XX_TRNGE;
 	writel(device_ctrl, dev->ce_base + CRYPTO4XX_DEVICE_CTRL);
 	writel(dev->gdr_pa, dev->ce_base + CRYPTO4XX_GATH_RING_BASE);
 	writel(dev->sdr_pa, dev->ce_base + CRYPTO4XX_SCAT_RING_BASE);
@@ -1219,6 +1223,9 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 	/* need to setup pdr, rdr, gdr and sdr before this */
 	crypto4xx_hw_init(core_dev->dev);
 
+	/* mark the true random number generator as ready */
+	ppc4xx_trng = true;
+
 	/* Register security algorithms with Linux CryptoAPI */
 	rc = crypto4xx_register_alg(core_dev->dev, crypto4xx_alg,
 			       ARRAY_SIZE(crypto4xx_alg));
diff --git a/drivers/crypto/amcc/crypto4xx_reg_def.h b/drivers/crypto/amcc/crypto4xx_reg_def.h
index 5f5fbc0..914efc6 100644
--- a/drivers/crypto/amcc/crypto4xx_reg_def.h
+++ b/drivers/crypto/amcc/crypto4xx_reg_def.h
@@ -124,6 +124,7 @@
 #define PPC4XX_BYTE_ORDER			0x22222
 #define PPC4XX_INTERRUPT_CLR			0x3ffff
 #define PPC4XX_PRNG_CTRL_AUTO_EN		0x3
+#define PPC4XX_TRNGE				0x00020000
 #define PPC4XX_DC_3DES_EN			1
 #define PPC4XX_INT_DESCR_CNT			4
 #define PPC4XX_INT_TIMEOUT_CNT			0
-- 
2.8.0.rc3
