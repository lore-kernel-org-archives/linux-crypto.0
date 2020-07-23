Return-Path: <SRS0=6JMd=BC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F994C433EA
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jul 2020 06:25:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F42220888
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jul 2020 06:25:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725536AbgGWGZZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Jul 2020 02:25:25 -0400
Received: from out28-98.mail.aliyun.com ([115.124.28.98]:58460 "EHLO
        out28-98.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726667AbgGWGZY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Jul 2020 02:25:24 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07436651|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_alarm|0.0284585-0.000932928-0.970609;FP=11267283304491539706|1|1|13|0|-1|-1|-1;HT=e02c03298;MF=zhouyanjie@wanyeetech.com;NM=1;PH=DS;RN=22;RT=22;SR=0;TI=SMTPD_---.I6H7HEV_1595485508;
Received: from localhost.localdomain(mailfrom:zhouyanjie@wanyeetech.com fp:SMTPD_---.I6H7HEV_1595485508)
          by smtp.aliyun-inc.com(10.147.40.7);
          Thu, 23 Jul 2020 14:25:18 +0800
From:   =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20=28Zhou=20Yanjie=29?= 
        <zhouyanjie@wanyeetech.com>
To:     arnd@arndb.de, gregkh@linuxfoundation.org, mpm@selenic.com,
        herbert@gondor.apana.org.au, robh+dt@kernel.org
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, hadar.gat@arm.com,
        prasannatsmkumar@gmail.com, krzk@kernel.org, masahiroy@kernel.org,
        rdunlap@infradead.org, xuzaibo@huawei.com,
        daniel.thompson@linaro.org, tmaimon77@gmail.com,
        dongsheng.qiu@ingenic.com, aric.pzqi@ingenic.com,
        rick.tyliu@ingenic.com, yanfei.li@ingenic.com,
        sernia.zhou@foxmail.com, zhenwenjin@gmail.com
Subject: [PATCH v2 2/2] crypto: Ingenic: Add hardware RNG for Ingenic JZ4780 and X1000.
Date:   Thu, 23 Jul 2020 14:24:46 +0800
Message-Id: <20200723062446.84013-3-zhouyanjie@wanyeetech.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200723062446.84013-1-zhouyanjie@wanyeetech.com>
References: <20200723062446.84013-1-zhouyanjie@wanyeetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add JZ4780 SoC and X1000 SoC random number generator driver,
based on PrasannaKumar Muralidharan's JZ4780 RNG driver.

Tested-by: 周正 (Zhou Zheng) <sernia.zhou@foxmail.com>
Tested-by: Mathieu Malaterre <malat@debian.org>
Suggested-by: Jeffrey Walton <noloader@gmail.com>
Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Signed-off-by: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
---

Notes:
    v1->v2:
    Use "help" instead "---help---" in Kconfig.

 drivers/char/hw_random/Kconfig       |  15 ++++
 drivers/char/hw_random/Makefile      |   1 +
 drivers/char/hw_random/ingenic-rng.c | 154 +++++++++++++++++++++++++++++++++++
 3 files changed, 170 insertions(+)
 create mode 100644 drivers/char/hw_random/ingenic-rng.c

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 0ad17efc96df..2f5af6b9fbb7 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -257,6 +257,21 @@ config HW_RANDOM_IMX_RNGC
 
 	  If unsure, say Y.
 
+config HW_RANDOM_INGENIC_RNG
+	tristate "Ingenic Random Number Generator support"
+	depends on HW_RANDOM
+	depends on MACH_JZ4780 || MACH_X1000
+	default HW_RANDOM
+	help
+	  This driver provides kernel-side support for the Random Number Generator
+	  hardware found in ingenic JZ4780 and X1000 SoC. MIPS Creator CI20 uses
+	  JZ4780 SoC, YSH & ATIL CU1000-Neo uses X1000 SoC.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ingenic-rng.
+
+	  If unsure, say Y.
+
 config HW_RANDOM_NOMADIK
 	tristate "ST-Ericsson Nomadik Random Number Generator support"
 	depends on ARCH_NOMADIK
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index 2c6724735345..acb1a1978d23 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_HW_RANDOM_VIRTIO) += virtio-rng.o
 obj-$(CONFIG_HW_RANDOM_TX4939) += tx4939-rng.o
 obj-$(CONFIG_HW_RANDOM_MXC_RNGA) += mxc-rnga.o
 obj-$(CONFIG_HW_RANDOM_IMX_RNGC) += imx-rngc.o
+obj-$(CONFIG_HW_RANDOM_INGENIC_RNG) += ingenic-rng.o
 obj-$(CONFIG_HW_RANDOM_OCTEON) += octeon-rng.o
 obj-$(CONFIG_HW_RANDOM_NOMADIK) += nomadik-rng.o
 obj-$(CONFIG_HW_RANDOM_PSERIES) += pseries-rng.o
diff --git a/drivers/char/hw_random/ingenic-rng.c b/drivers/char/hw_random/ingenic-rng.c
new file mode 100644
index 000000000000..d704cef64b64
--- /dev/null
+++ b/drivers/char/hw_random/ingenic-rng.c
@@ -0,0 +1,154 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Ingenic Random Number Generator driver
+ * Copyright (c) 2017 PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
+ * Copyright (c) 2020 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
+ */
+
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
+/* RNG register offsets */
+#define RNG_REG_ERNG_OFFSET		0x0
+#define RNG_REG_RNG_OFFSET		0x4
+
+/* bits within the ERND register */
+#define ERNG_READY				BIT(31)
+#define ERNG_ENABLE				BIT(0)
+
+enum ingenic_rng_version {
+	ID_JZ4780,
+	ID_X1000,
+};
+
+/* Device associated memory */
+struct ingenic_rng {
+	enum ingenic_rng_version version;
+
+	void __iomem *base;
+	struct hwrng rng;
+};
+
+static int ingenic_rng_init(struct hwrng *rng)
+{
+	struct ingenic_rng *priv = container_of(rng, struct ingenic_rng, rng);
+
+	writel(ERNG_ENABLE, priv->base + RNG_REG_ERNG_OFFSET);
+
+	return 0;
+}
+
+static void ingenic_rng_cleanup(struct hwrng *rng)
+{
+	struct ingenic_rng *priv = container_of(rng, struct ingenic_rng, rng);
+
+	writel(0, priv->base + RNG_REG_ERNG_OFFSET);
+}
+
+static int ingenic_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
+{
+	struct ingenic_rng *priv = container_of(rng, struct ingenic_rng, rng);
+	u32 *data = buf;
+	u32 status;
+	int ret;
+
+	if (priv->version >= ID_X1000) {
+		ret = readl_poll_timeout(priv->base + RNG_REG_ERNG_OFFSET, status,
+					 status & ERNG_READY, 10, 1000);
+		if (ret == -ETIMEDOUT) {
+			pr_err("%s: Wait for RNG data ready timeout\n", __func__);
+			return ret;
+		}
+	} else {
+		/*
+		 * A delay is required so that the current RNG data is not bit shifted
+		 * version of previous RNG data which could happen if random data is
+		 * read continuously from this device.
+		 */
+		udelay(20);
+	}
+
+	*data = readl(priv->base + RNG_REG_RNG_OFFSET);
+
+	return 4;
+}
+
+static int ingenic_rng_probe(struct platform_device *pdev)
+{
+	struct ingenic_rng *priv;
+	int ret;
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->base = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(priv->base)) {
+		pr_err("%s: Failed to map RNG registers\n", __func__);
+		ret = PTR_ERR(priv->base);
+		goto err_free_rng;
+	}
+
+	priv->version = (enum ingenic_rng_version)of_device_get_match_data(&pdev->dev);
+
+	priv->rng.name = pdev->name;
+	priv->rng.init = ingenic_rng_init;
+	priv->rng.cleanup = ingenic_rng_cleanup;
+	priv->rng.read = ingenic_rng_read;
+
+	ret = hwrng_register(&priv->rng);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to register hwrng\n");
+		goto err_free_rng;
+	}
+
+	platform_set_drvdata(pdev, priv);
+
+	dev_info(&pdev->dev, "Ingenic RNG driver registered\n");
+	return 0;
+
+err_free_rng:
+	kfree(priv);
+	return ret;
+}
+
+static int ingenic_rng_remove(struct platform_device *pdev)
+{
+	struct ingenic_rng *priv = platform_get_drvdata(pdev);
+
+	hwrng_unregister(&priv->rng);
+
+	writel(0, priv->base + RNG_REG_ERNG_OFFSET);
+
+	return 0;
+}
+
+static const struct of_device_id ingenic_rng_of_match[] = {
+	{ .compatible = "ingenic,jz4780-rng", .data = (void *) ID_JZ4780 },
+	{ .compatible = "ingenic,x1000-rng", .data = (void *) ID_X1000 },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, ingenic_rng_of_match);
+
+static struct platform_driver ingenic_rng_driver = {
+	.probe		= ingenic_rng_probe,
+	.remove		= ingenic_rng_remove,
+	.driver		= {
+		.name	= "ingenic-rng",
+		.of_match_table = ingenic_rng_of_match,
+	},
+};
+
+module_platform_driver(ingenic_rng_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>");
+MODULE_AUTHOR("周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>");
+MODULE_DESCRIPTION("Ingenic Random Number Generator driver");
-- 
2.11.0

