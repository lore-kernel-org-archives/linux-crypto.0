Return-Path: <SRS0=0npx=CW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08135C43461
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Sep 2020 16:12:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBF1422207
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Sep 2020 16:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725960AbgIMQMG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Sep 2020 12:12:06 -0400
Received: from out28-123.mail.aliyun.com ([115.124.28.123]:36061 "EHLO
        out28-123.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgIMQL3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Sep 2020 12:11:29 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07436401|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_alarm|0.0204487-0.000512333-0.979039;FP=0|0|0|0|0|-1|-1|-1;HT=e02c03267;MF=zhouyanjie@wanyeetech.com;NM=1;PH=DS;RN=25;RT=25;SR=0;TI=SMTPD_---.IWac2C6_1600013452;
Received: from localhost.localdomain(mailfrom:zhouyanjie@wanyeetech.com fp:SMTPD_---.IWac2C6_1600013452)
          by smtp.aliyun-inc.com(10.147.41.187);
          Mon, 14 Sep 2020 00:11:02 +0800
From:   =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20=28Zhou=20Yanjie=29?= 
        <zhouyanjie@wanyeetech.com>
To:     arnd@arndb.de, gregkh@linuxfoundation.org, mpm@selenic.com,
        herbert@gondor.apana.org.au, robh+dt@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, hadar.gat@arm.com,
        geert+renesas@glider.be, krzk@kernel.org, wahrenst@gmx.net,
        masahiroy@kernel.org, tmaimon77@gmail.com, rdunlap@infradead.org,
        qianweili@huawei.com, daniel.thompson@linaro.org,
        xuzaibo@huawei.com, olivier.sobrie@silexinsight.com,
        dongsheng.qiu@ingenic.com, aric.pzqi@ingenic.com,
        rick.tyliu@ingenic.com, yanfei.li@ingenic.com,
        sernia.zhou@foxmail.com, zhenwenjin@gmail.com
Subject: [PATCH 2/2] crypto: Ingenic: Add hardware TRNG for Ingenic X1830.
Date:   Mon, 14 Sep 2020 00:10:21 +0800
Message-Id: <20200913161021.120226-3-zhouyanjie@wanyeetech.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200913161021.120226-1-zhouyanjie@wanyeetech.com>
References: <20200913161021.120226-1-zhouyanjie@wanyeetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add X1830 SoC digital true random number generator driver.

Tested-by: 周正 (Zhou Zheng) <sernia.zhou@foxmail.com>
Co-developed-by: 漆鹏振 (Qi Pengzhen) <aric.pzqi@ingenic.com>
Signed-off-by: 漆鹏振 (Qi Pengzhen) <aric.pzqi@ingenic.com>
Signed-off-by: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
---
 drivers/char/hw_random/Kconfig        |  14 +++
 drivers/char/hw_random/Makefile       |   1 +
 drivers/char/hw_random/ingenic-trng.c | 161 ++++++++++++++++++++++++++++++++++
 3 files changed, 176 insertions(+)
 create mode 100644 drivers/char/hw_random/ingenic-trng.c

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index f976a49e1fb5..1232ca9a455c 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -282,6 +282,20 @@ config HW_RANDOM_INGENIC_RNG
 
 	  If unsure, say Y.
 
+config HW_RANDOM_INGENIC_TRNG
+	tristate "Ingenic True Random Number Generator support"
+	depends on HW_RANDOM
+	depends on MACH_X1830
+	default HW_RANDOM
+	help
+	  This driver provides kernel-side support for the True Random Number Generator
+	  hardware found in ingenic X1830 SoC. YSH & ATIL CU1830-Neo uses X1830 SoC.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ingenic-trng.
+
+	  If unsure, say Y.
+
 config HW_RANDOM_NOMADIK
 	tristate "ST-Ericsson Nomadik Random Number Generator support"
 	depends on ARCH_NOMADIK
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index 26ae06844f09..8821d1c6f415 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -24,6 +24,7 @@ obj-$(CONFIG_HW_RANDOM_TX4939) += tx4939-rng.o
 obj-$(CONFIG_HW_RANDOM_MXC_RNGA) += mxc-rnga.o
 obj-$(CONFIG_HW_RANDOM_IMX_RNGC) += imx-rngc.o
 obj-$(CONFIG_HW_RANDOM_INGENIC_RNG) += ingenic-rng.o
+obj-$(CONFIG_HW_RANDOM_INGENIC_TRNG) += ingenic-trng.o
 obj-$(CONFIG_HW_RANDOM_OCTEON) += octeon-rng.o
 obj-$(CONFIG_HW_RANDOM_NOMADIK) += nomadik-rng.o
 obj-$(CONFIG_HW_RANDOM_PSERIES) += pseries-rng.o
diff --git a/drivers/char/hw_random/ingenic-trng.c b/drivers/char/hw_random/ingenic-trng.c
new file mode 100644
index 000000000000..954a8411d67d
--- /dev/null
+++ b/drivers/char/hw_random/ingenic-trng.c
@@ -0,0 +1,161 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Ingenic True Random Number Generator driver
+ * Copyright (c) 2019 漆鹏振 (Qi Pengzhen) <aric.pzqi@ingenic.com>
+ * Copyright (c) 2020 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
+ */
+
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/hw_random.h>
+#include <linux/io.h>
+#include <linux/iopoll.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+/* DTRNG register offsets */
+#define TRNG_REG_CFG_OFFSET			0x00
+#define TRNG_REG_RANDOMNUM_OFFSET	0x04
+#define TRNG_REG_STATUS_OFFSET		0x08
+
+/* bits within the CFG register */
+#define CFG_RDY_CLR					BIT(12)
+#define CFG_INT_MASK				BIT(11)
+#define CFG_GEN_EN					BIT(0)
+
+/* bits within the STATUS register */
+#define STATUS_RANDOM_RDY			BIT(0)
+
+struct ingenic_trng {
+	void __iomem *base;
+	struct clk *clk;
+	struct hwrng rng;
+};
+
+static int ingenic_trng_init(struct hwrng *rng)
+{
+	struct ingenic_trng *trng = container_of(rng, struct ingenic_trng, rng);
+	unsigned int ctrl;
+
+	ctrl = readl(trng->base + TRNG_REG_CFG_OFFSET);
+	ctrl |= CFG_GEN_EN;
+	writel(ctrl, trng->base + TRNG_REG_CFG_OFFSET);
+
+	return 0;
+}
+
+static void ingenic_trng_cleanup(struct hwrng *rng)
+{
+	struct ingenic_trng *trng = container_of(rng, struct ingenic_trng, rng);
+	unsigned int ctrl;
+
+	ctrl = readl(trng->base + TRNG_REG_CFG_OFFSET);
+	ctrl &= ~CFG_GEN_EN;
+	writel(ctrl, trng->base + TRNG_REG_CFG_OFFSET);
+}
+
+static int ingenic_trng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
+{
+	struct ingenic_trng *trng = container_of(rng, struct ingenic_trng, rng);
+	u32 *data = buf;
+	u32 status;
+	int ret;
+
+	ret = readl_poll_timeout(trng->base + TRNG_REG_STATUS_OFFSET, status,
+				 status & STATUS_RANDOM_RDY, 10, 1000);
+	if (ret == -ETIMEDOUT) {
+		pr_err("%s: Wait for DTRNG data ready timeout\n", __func__);
+		return ret;
+	}
+
+	*data = readl(trng->base + TRNG_REG_RANDOMNUM_OFFSET);
+
+	return 4;
+}
+
+static int ingenic_trng_probe(struct platform_device *pdev)
+{
+	struct ingenic_trng *trng;
+	int ret;
+
+	trng = devm_kzalloc(&pdev->dev, sizeof(*trng), GFP_KERNEL);
+	if (!trng)
+		return -ENOMEM;
+
+	trng->base = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(trng->base)) {
+		pr_err("%s: Failed to map DTRNG registers\n", __func__);
+		ret = PTR_ERR(trng->base);
+		return PTR_ERR(trng->base);
+	}
+
+	trng->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(trng->clk)) {
+		ret = PTR_ERR(trng->clk);
+		pr_crit("%s: Cannot get DTRNG clock\n", __func__);
+		return PTR_ERR(trng->clk);
+	}
+
+	ret = clk_prepare_enable(trng->clk);
+	if (ret) {
+		pr_crit("%s: Unable to enable DTRNG clock\n", __func__);
+		return ret;
+	}
+
+	trng->rng.name = pdev->name;
+	trng->rng.init = ingenic_trng_init;
+	trng->rng.cleanup = ingenic_trng_cleanup;
+	trng->rng.read = ingenic_trng_read;
+
+	ret = hwrng_register(&trng->rng);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to register hwrng\n");
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, trng);
+
+	dev_info(&pdev->dev, "Ingenic DTRNG driver registered\n");
+	return 0;
+}
+
+static int ingenic_trng_remove(struct platform_device *pdev)
+{
+	struct ingenic_trng *trng = platform_get_drvdata(pdev);
+	unsigned int ctrl;
+
+	hwrng_unregister(&trng->rng);
+
+	ctrl = readl(trng->base + TRNG_REG_CFG_OFFSET);
+	ctrl &= ~CFG_GEN_EN;
+	writel(ctrl, trng->base + TRNG_REG_CFG_OFFSET);
+
+	clk_disable_unprepare(trng->clk);
+
+	return 0;
+}
+
+static const struct of_device_id ingenic_trng_of_match[] = {
+	{ .compatible = "ingenic,x1830-dtrng" },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, ingenic_trng_of_match);
+
+static struct platform_driver ingenic_trng_driver = {
+	.probe		= ingenic_trng_probe,
+	.remove		= ingenic_trng_remove,
+	.driver		= {
+		.name	= "ingenic-trng",
+		.of_match_table = ingenic_trng_of_match,
+	},
+};
+
+module_platform_driver(ingenic_trng_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("漆鹏振 (Qi Pengzhen) <aric.pzqi@ingenic.com>");
+MODULE_AUTHOR("周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>");
+MODULE_DESCRIPTION("Ingenic True Random Number Generator driver");
-- 
2.11.0

