Return-Path: <SRS0=QLPS=3J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 583B7C33CA1
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jan 2020 15:11:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 252B422525
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jan 2020 15:11:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=neuralgames.com header.i=@neuralgames.com header.b="niHiNp1Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbgATPLy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Jan 2020 10:11:54 -0500
Received: from kross.rwserver.com ([69.13.37.146]:37030 "EHLO
        kross2019.rwserver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727071AbgATPLr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Jan 2020 10:11:47 -0500
X-Greylist: delayed 612 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Jan 2020 10:11:46 EST
Received: from localhost (localhost [127.0.0.1])
        by kross2019.rwserver.com (Postfix) with ESMTP id 5E510B362B;
        Mon, 20 Jan 2020 09:01:43 -0600 (CST)
Authentication-Results: kross2019.rwserver.com (amavisd-new);
        dkim=pass (1024-bit key) reason="pass (just generated, assumed good)"
        header.d=neuralgames.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=neuralgames.com;
         h=references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from; s=default; t=1579532500; x=1581346901; bh=hH
        Gwj1XUCUplDUXciEWu79hj1me+hkL2GV0rDiO7gvk=; b=niHiNp1QMDrorTOlNJ
        oEQNzsgNQlsJYki/JwePMbh/iTpkUI8ujQZWT19jw5IJhEKq6Qb0pyC1zBGUYJsq
        KtGfz4V4AxwS1LLm6bzGFcSoCaD9pkEH78A6Gwgh9nxkqFbGWPagqCkNtmOAUyLh
        4ZZ9usm6W7Yx5HHWBkDWwQ9b0=
X-Virus-Scanned: Debian amavisd-new at kross2019.rwserver.com
Received: from kross2019.rwserver.com ([127.0.0.1])
        by localhost (kross2019.rwserver.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id UofDVlugeru7; Mon, 20 Jan 2020 09:01:40 -0600 (CST)
Received: from localhost (ZT-GROUP-IN.bear1.Houston1.Level3.net [4.14.58.158])
        (Authenticated sender: linux@neuralgames.com)
        by kross2019.rwserver.com (Postfix) with ESMTPSA id A9161B362A;
        Mon, 20 Jan 2020 09:01:40 -0600 (CST)
From:   Oscar A Perez <linux@neuralgames.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oscar A Perez <linux@neuralgames.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Weili Qian <qianweili@huawei.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] hwrng: Add support for ASPEED RNG
Date:   Mon, 20 Jan 2020 15:01:09 +0000
Message-Id: <20200120150113.2565-2-linux@neuralgames.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200120150113.2565-1-linux@neuralgames.com>
References: <20200120150113.2565-1-linux@neuralgames.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This minimal driver adds support for the Hardware Random Number Generator
that comes with the AST2400/AST2500/AST2600 SOCs from AspeedTech.

The HRNG on these SOCs uses Ring Oscillators working together to generate
a stream of random bits that can be read by the platform via a 32bit data
register.

Signed-off-by: Oscar A Perez <linux@neuralgames.com>
---
 drivers/char/hw_random/Kconfig      |  13 ++
 drivers/char/hw_random/Makefile     |   1 +
 drivers/char/hw_random/aspeed-rng.c | 294 ++++++++++++++++++++++++++++
 3 files changed, 308 insertions(+)
 create mode 100644 drivers/char/hw_random/aspeed-rng.c

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 8486c29d8324..d4275e1cbce0 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -466,6 +466,19 @@ config HW_RANDOM_NPCM
 
  	  If unsure, say Y.
 
+config HW_RANDOM_ASPEED
+	tristate "Aspeed Hardware Random Number Generator support"
+	depends on ARCH_ASPEED || COMPILE_TEST
+	default HW_RANDOM
+	help
+	  If you say yes to this option, support will be included for the
+	  Hardware Random Number Generator that comes with Aspeed SoCs.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called aspeed-rng.
+
+	 If unsure, say Y.
+
 endif # HW_RANDOM
 
 config UML_RANDOM
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index a7801b49ce6c..ff70994efde9 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -41,3 +41,4 @@ obj-$(CONFIG_HW_RANDOM_S390) += s390-trng.o
 obj-$(CONFIG_HW_RANDOM_KEYSTONE) += ks-sa-rng.o
 obj-$(CONFIG_HW_RANDOM_OPTEE) += optee-rng.o
 obj-$(CONFIG_HW_RANDOM_NPCM) += npcm-rng.o
+obj-$(CONFIG_HW_RANDOM_ASPEED) += aspeed-rng.o
diff --git a/drivers/char/hw_random/aspeed-rng.c b/drivers/char/hw_random/aspeed-rng.c
new file mode 100644
index 000000000000..794d8e044bbe
--- /dev/null
+++ b/drivers/char/hw_random/aspeed-rng.c
@@ -0,0 +1,294 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * drivers/char/hw_random/aspeed-rng.c
+ *
+ * Copyright (C) 2020 Oscar A. Perez <linux@neuralgames.com>
+ *
+ * Derived from drivers/char/hw_random/timeriomem-rng.c
+ *   Copyright (C) 2009 Alexander Clouter <alex@digriz.org.uk>
+ *
+ *   Derived from drivers/char/hw_random/omap-rng.c
+ *     Copyright 2005 (c) MontaVista Software, Inc.
+ *     Author: Deepak Saxena <dsaxena@plexity.net>
+ *
+ * Overview:
+ *   This driver is meant for SOCs like the AST2400/AST2500/AST2600 from
+ *   AspeedTech that integrate non-deterministic Random Number Generators
+ *   based on Ring Oscillators (a.k.a. RO-based HRNG).
+ *   According to AspeedTech, the random number generators on these SOCs
+ *   contain four free-run ROs that can be configured in eight different
+ *   modes. The modes are just logic combinations of these four ROs that
+ *   together generate a stream of random bits. These random bits are read
+ *   from a 32bit data register and, new random data becomes available on
+ *   this 32bit data register every one microsecond.
+ *
+ *   All the platform has to do is to provide to the driver the 'quality'
+ *   entropy value, the 'mode' in which the combining ROs will generate
+ *   the stream of random bits and, the 'period' value that is used as a
+ *   wait-time between reads from the 32bit data register.
+ *
+ */
+
+#include <linux/completion.h>
+#include <linux/delay.h>
+#include <linux/hrtimer.h>
+#include <linux/hw_random.h>
+#include <linux/io.h>
+#include <linux/ktime.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/time.h>
+
+#define HRNG_CONTROL_REG_OFFSET		0x00
+#define HRNG_OUTPUT_DATA_OFFSET		0x04
+#define HRNG_CONTROL_ENABLE		BIT(0)
+#define HRNG_CONTROL_MODE_MASK		GENMASK(3, 1)
+#define HRNG_CONTROL_MODE_SHIFT		1
+
+struct aspeed_hrng_data {
+	void __iomem            *address;
+
+	/* measures in usecs */
+	unsigned int            period;
+
+	/* bits of entropy per 1024 bits read */
+	unsigned int            quality;
+};
+
+struct aspeed_hrng_private {
+	struct device		*dev;
+	void __iomem		*io_base;
+	ktime_t			period;
+	unsigned int		present:1;
+	unsigned int		ro_mode:7;
+
+	struct hrtimer		timer;
+	struct completion	completion;
+
+	struct hwrng		rng_ops;
+};
+
+static int aspeed_hrng_read(struct hwrng *hwrng, void *data,
+			    size_t max, bool wait)
+{
+	struct aspeed_hrng_private
+		*priv =	container_of(hwrng,
+				     struct aspeed_hrng_private,
+				     rng_ops);
+	int retval = 0;
+	int period_us = ktime_to_us(priv->period);
+
+	/*
+	 * There may not have been enough time for new data to be generated
+	 * since the last request.  If the caller doesn't want to wait, let them
+	 * bail out.  Otherwise, wait for the completion.  If the new data has
+	 * already been generated, the completion should already be available.
+	 */
+	if (!wait && !priv->present)
+		return 0;
+
+	wait_for_completion(&priv->completion);
+
+	do {
+		/*
+		 * After the first read, all additional reads will need to wait
+		 * for the RNG to generate new data.  Since the period can have
+		 * a wide range of values (1us to 1s have been observed), allow
+		 * for 1% tolerance in the sleep time rather than a fixed value.
+		 */
+		if (retval > 0)
+			usleep_range(period_us,
+				     period_us + min(1, period_us / 100));
+
+		*(u32 *)data = readl(priv->io_base + HRNG_OUTPUT_DATA_OFFSET);
+
+		retval += sizeof(u32);
+		data += sizeof(u32);
+		max -= sizeof(u32);
+	} while (wait && max >= sizeof(u32));
+
+	/*
+	 * Block any new callers until the RNG has had time to generate new
+	 * data.
+	 */
+	priv->present = 0;
+	reinit_completion(&priv->completion);
+	hrtimer_forward_now(&priv->timer, priv->period);
+	hrtimer_restart(&priv->timer);
+
+	return retval;
+}
+
+static enum hrtimer_restart aspeed_hrng_trigger(struct hrtimer *timer)
+{
+	struct aspeed_hrng_private *priv =
+			container_of(timer, struct aspeed_hrng_private, timer);
+
+	priv->present = 1;
+	complete(&priv->completion);
+
+	return HRTIMER_NORESTART;
+}
+
+static void aspeed_hrng_enable(struct aspeed_hrng_private *priv)
+{
+	u32 regval;
+
+	regval = readl(priv->io_base + HRNG_CONTROL_REG_OFFSET);
+	regval &= ~HRNG_CONTROL_ENABLE;
+	writel(regval, priv->io_base + HRNG_CONTROL_REG_OFFSET);
+}
+
+static void aspeed_hrng_disable(struct aspeed_hrng_private *priv)
+{
+	u32 regval;
+
+	regval = readl(priv->io_base + HRNG_CONTROL_REG_OFFSET);
+	regval |= HRNG_CONTROL_ENABLE;
+	writel(regval, priv->io_base + HRNG_CONTROL_REG_OFFSET);
+}
+
+static void aspeed_hrng_set_mode(struct aspeed_hrng_private *priv)
+{
+	u32 regval;
+
+	aspeed_hrng_disable(priv);
+	regval = readl(priv->io_base + HRNG_CONTROL_REG_OFFSET);
+	regval &= ~HRNG_CONTROL_MODE_MASK;
+	regval |= (priv->ro_mode << HRNG_CONTROL_MODE_SHIFT) &
+		  HRNG_CONTROL_MODE_MASK;
+	writel(regval, priv->io_base + HRNG_CONTROL_REG_OFFSET);
+	aspeed_hrng_enable(priv);
+}
+
+static int aspeed_hrng_probe(struct platform_device *pdev)
+{
+	struct aspeed_hrng_data *pdata = pdev->dev.platform_data;
+	struct aspeed_hrng_private *priv;
+	struct resource *res;
+	int err = 0;
+	int period;
+
+	if (!pdev->dev.of_node && !pdata) {
+		dev_err(&pdev->dev, "aspeed_hrng_data is missing\n");
+		return -EINVAL;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENXIO;
+
+	if (res->start % 4 != 0 || resource_size(res) != 8) {
+		dev_err(&pdev->dev,
+			"address space must be eight bytes wide and 32-bit aligned\n");
+		return -EINVAL;
+	}
+
+	/* Allocate memory for the device structure (and zero it) */
+	priv = devm_kzalloc(&pdev->dev,
+			    sizeof(struct aspeed_hrng_private), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, priv);
+
+	priv->dev = &pdev->dev;
+
+	if (pdev->dev.of_node) {
+		int i;
+
+		if (!of_property_read_u32(pdev->dev.of_node, "period", &i)) {
+			period = i;
+		} else {
+			dev_err(&pdev->dev, "missing period property\n");
+			return -EINVAL;
+		}
+
+		if (!of_property_read_u32(pdev->dev.of_node, "quality", &i)) {
+			priv->rng_ops.quality = i;
+		} else {
+			dev_info(&pdev->dev,
+				 "missing quality property. Using default value of 0\n");
+			priv->rng_ops.quality = 0;
+		}
+
+		if (!of_property_read_u32(pdev->dev.of_node, "mode", &i)) {
+			priv->ro_mode = (i & 0x7);
+		} else {
+			dev_info(&pdev->dev,
+				 "missing mode property. Using default mode 0x7\n");
+			priv->ro_mode = 0x7;
+		}
+	} else {
+		period = pdata->period;
+		priv->rng_ops.quality = pdata->quality;
+		priv->ro_mode = 0x7; /* default mode for the Ring Oscillators */
+	}
+
+	priv->period = ns_to_ktime(period * NSEC_PER_USEC);
+	init_completion(&priv->completion);
+	hrtimer_init(&priv->timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+	priv->timer.function = aspeed_hrng_trigger;
+
+	priv->rng_ops.name = dev_name(&pdev->dev);
+	priv->rng_ops.read = aspeed_hrng_read;
+
+	priv->io_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(priv->io_base))
+		return PTR_ERR(priv->io_base);
+
+	/* By default, RO RNG is set to mode 7 and RNG is enabled */
+	dev_dbg(&pdev->dev, "setting RO RNG to mode %u\n", priv->ro_mode);
+	aspeed_hrng_set_mode(priv);
+
+	/* Assume random data is already available. */
+	priv->present = 1;
+	complete(&priv->completion);
+
+	err = hwrng_register(&priv->rng_ops);
+	if (err) {
+		dev_err(&pdev->dev, "problem registering\n");
+		return err;
+	}
+
+	dev_info(&pdev->dev, "RO-based RNG registered: mode %u @ %dus\n",
+		 priv->ro_mode, period);
+
+	return 0;
+}
+
+static int aspeed_hrng_remove(struct platform_device *pdev)
+{
+	struct aspeed_hrng_private *priv = platform_get_drvdata(pdev);
+
+	aspeed_hrng_disable(priv);
+	hwrng_unregister(&priv->rng_ops);
+	hrtimer_cancel(&priv->timer);
+
+	return 0;
+}
+
+static const struct of_device_id aspeed_hrng_match[] = {
+	{ .compatible = "aspeed,ast2400-rng" },
+	{ .compatible = "aspeed,ast2500-rng" },
+	{ .compatible = "aspeed,ast2600-rng" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, aspeed_hrng_match);
+
+static struct platform_driver aspeed_hrng_driver = {
+	.driver = {
+		.name		= "aspeed-rng",
+		.of_match_table	= aspeed_hrng_match,
+	},
+	.probe		= aspeed_hrng_probe,
+	.remove		= aspeed_hrng_remove,
+};
+
+module_platform_driver(aspeed_hrng_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Oscar A Perez <oscar.perez@ztsystems.com>");
+MODULE_DESCRIPTION("Aspeed Ring Oscillator Random Number Generator driver");
-- 
2.17.1

