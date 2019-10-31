Return-Path: <SRS0=cgyY=YY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABFA8C47E49
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Oct 2019 08:38:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CF3D20873
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Oct 2019 08:38:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbfJaIiR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Oct 2019 04:38:17 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:41380 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726875AbfJaIiR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Oct 2019 04:38:17 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B6AA78FC0D05FF5C53EF;
        Thu, 31 Oct 2019 16:38:14 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Thu, 31 Oct 2019 16:38:03 +0800
From:   Zaibo Xu <xuzaibo@huawei.com>
To:     <herbert@gondor.apana.org.au>, <mpm@selenic.com>
CC:     <linux-crypto@vger.kernel.org>, <jonathan.cameron@huawei.com>,
        <wangzhou1@hisilicon.com>, <linuxarm@huawei.com>,
        <wangkefeng.wang@huawei.com>, <qianweili@huawei.com>,
        <forest.zhouchang@huawei.com>
Subject: [PATCH 1/2] hw_random: add HiSilicon TRNG driver support
Date:   Thu, 31 Oct 2019 16:34:29 +0800
Message-ID: <1572510870-40390-2-git-send-email-xuzaibo@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1572510870-40390-1-git-send-email-xuzaibo@huawei.com>
References: <1572510870-40390-1-git-send-email-xuzaibo@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series adds HiSilicon true random number generator(TRNG)
driver in hw_random subsystem.

Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/char/hw_random/Kconfig        | 13 +++++
 drivers/char/hw_random/Makefile       |  1 +
 drivers/char/hw_random/hisi-trng-v2.c | 99 +++++++++++++++++++++++++++++++++++
 3 files changed, 113 insertions(+)
 create mode 100644 drivers/char/hw_random/hisi-trng-v2.c

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 87a1c30..7c7fecf 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -308,6 +308,19 @@ config HW_RANDOM_HISI
 
 	  If unsure, say Y.
 
+config HW_RANDOM_HISI_V2
+	tristate "HiSilicon True Random Number Generator V2 support"
+	depends on HW_RANDOM && ARM64 && ACPI
+	default HW_RANDOM
+	help
+	  This driver provides kernel-side support for the True Random Number
+	  Generator V2 hardware found on HiSilicon Hi1620 SoC.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called hisi-trng-v2.
+
+	  If unsure, say Y.
+
 config HW_RANDOM_ST
 	tristate "ST Microelectronics HW Random Number Generator support"
 	depends on HW_RANDOM && ARCH_STI
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index 17b6d4e..a7801b4 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -27,6 +27,7 @@ obj-$(CONFIG_HW_RANDOM_NOMADIK) += nomadik-rng.o
 obj-$(CONFIG_HW_RANDOM_PSERIES) += pseries-rng.o
 obj-$(CONFIG_HW_RANDOM_POWERNV) += powernv-rng.o
 obj-$(CONFIG_HW_RANDOM_HISI)	+= hisi-rng.o
+obj-$(CONFIG_HW_RANDOM_HISI_V2) += hisi-trng-v2.o
 obj-$(CONFIG_HW_RANDOM_BCM2835) += bcm2835-rng.o
 obj-$(CONFIG_HW_RANDOM_IPROC_RNG200) += iproc-rng200.o
 obj-$(CONFIG_HW_RANDOM_ST) += st-rng.o
diff --git a/drivers/char/hw_random/hisi-trng-v2.c b/drivers/char/hw_random/hisi-trng-v2.c
new file mode 100644
index 0000000..6a65b82
--- /dev/null
+++ b/drivers/char/hw_random/hisi-trng-v2.c
@@ -0,0 +1,99 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 HiSilicon Limited. */
+
+#include <linux/acpi.h>
+#include <linux/err.h>
+#include <linux/hw_random.h>
+#include <linux/io.h>
+#include <linux/iopoll.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/random.h>
+
+#define HISI_TRNG_REG		0x00F0
+#define HISI_TRNG_BYTES		4
+#define HISI_TRNG_QUALITY	512
+#define SLEEP_US		10
+#define TIMEOUT_US		10000
+
+struct hisi_trng {
+	void __iomem *base;
+	struct hwrng rng;
+};
+
+static int hisi_trng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
+{
+	struct hisi_trng *trng;
+	int currsize = 0;
+	u32 val = 0;
+	u32 ret;
+
+	trng = container_of(rng, struct hisi_trng, rng);
+
+	do {
+		ret = readl_poll_timeout(trng->base + HISI_TRNG_REG, val,
+					 val, SLEEP_US, TIMEOUT_US);
+		if (ret)
+			return currsize;
+
+		if (max - currsize >= HISI_TRNG_BYTES) {
+			memcpy(buf + currsize, &val, HISI_TRNG_BYTES);
+			currsize += HISI_TRNG_BYTES;
+			if (currsize == max)
+				return currsize;
+			continue;
+		}
+
+		/* copy remaining bytes */
+		memcpy(buf + currsize, &val, max - currsize);
+		currsize = max;
+	} while (currsize < max);
+
+	return currsize;
+}
+
+static int hisi_trng_probe(struct platform_device *pdev)
+{
+	struct hisi_trng *trng;
+	int ret;
+
+	trng = devm_kzalloc(&pdev->dev, sizeof(*trng), GFP_KERNEL);
+	if (!trng)
+		return -ENOMEM;
+
+	trng->base = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(trng->base))
+		return PTR_ERR(trng->base);
+
+	trng->rng.name = pdev->name;
+	trng->rng.read = hisi_trng_read;
+	trng->rng.quality = HISI_TRNG_QUALITY;
+
+	ret = devm_hwrng_register(&pdev->dev, &trng->rng);
+	if (ret)
+		dev_err(&pdev->dev, "failed to register hwrng!\n");
+
+	return ret;
+}
+
+static const struct acpi_device_id hisi_trng_acpi_match[] = {
+	{ "HISI02B3", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(acpi, hisi_trng_acpi_match);
+
+static struct platform_driver hisi_trng_driver = {
+	.probe		= hisi_trng_probe,
+	.driver		= {
+		.name	= "hisi-trng-v2",
+		.acpi_match_table = ACPI_PTR(hisi_trng_acpi_match),
+	},
+};
+
+module_platform_driver(hisi_trng_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Weili Qian <qianweili@huawei.com>");
+MODULE_AUTHOR("Zaibo Xu <xuzaibo@huawei.com>");
+MODULE_DESCRIPTION("HiSilicon true random number generator V2 driver");
-- 
2.8.1

