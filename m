Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCEF9C5519F
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Nov 2020 09:06:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CE2E221F9
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Nov 2020 09:06:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgKTJF4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Nov 2020 04:05:56 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7711 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbgKTJF4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Nov 2020 04:05:56 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CcrHG6VBhzkcQ0;
        Fri, 20 Nov 2020 17:05:30 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Fri, 20 Nov 2020 17:04:58 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <mpm@selenic.com>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>,
        Weili Qian <qianweili@huawei.com>
Subject: [PATCH 2/4] crypto: hisilicon/trng - add HiSilicon TRNG driver support
Date:   Fri, 20 Nov 2020 17:02:32 +0800
Message-ID: <1605862954-38300-2-git-send-email-qianweili@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1605862954-38300-1-git-send-email-qianweili@huawei.com>
References: <1605862954-38300-1-git-send-email-qianweili@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Move existing char/hw_random/hisi-trng-v2.c to crypto/hisilicon/trng.c.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
---
 arch/arm64/configs/defconfig           |  1 +
 drivers/crypto/hisilicon/Kconfig       |  7 +++
 drivers/crypto/hisilicon/Makefile      |  1 +
 drivers/crypto/hisilicon/trng/Makefile |  2 +
 drivers/crypto/hisilicon/trng/trng.c   | 99 ++++++++++++++++++++++++++++++++++
 5 files changed, 110 insertions(+)
 create mode 100644 drivers/crypto/hisilicon/trng/Makefile
 create mode 100644 drivers/crypto/hisilicon/trng/trng.c

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index 17a2df6..646c3b4 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -1081,6 +1081,7 @@ CONFIG_CRYPTO_DEV_CCREE=m
 CONFIG_CRYPTO_DEV_HISI_SEC2=m
 CONFIG_CRYPTO_DEV_HISI_ZIP=m
 CONFIG_CRYPTO_DEV_HISI_HPRE=m
+CONFIG_CRYPTO_DEV_HISI_TRNG=m
 CONFIG_CMA_SIZE_MBYTES=32
 CONFIG_PRINTK_TIME=y
 CONFIG_DEBUG_INFO=y
diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
index 9c3b3ca..2cd3298 100644
--- a/drivers/crypto/hisilicon/Kconfig
+++ b/drivers/crypto/hisilicon/Kconfig
@@ -71,3 +71,10 @@ config CRYPTO_DEV_HISI_HPRE
 	help
 	  Support for HiSilicon HPRE(High Performance RSA Engine)
 	  accelerator, which can accelerate RSA and DH algorithms.
+
+config CRYPTO_DEV_HISI_TRNG
+	tristate "Support for HISI TRNG Driver"
+	depends on ARM64 && ACPI
+	select HW_RANDOM
+	help
+	  Support for HiSilicon TRNG Driver.
diff --git a/drivers/crypto/hisilicon/Makefile b/drivers/crypto/hisilicon/Makefile
index 7f5f74c..1e89269 100644
--- a/drivers/crypto/hisilicon/Makefile
+++ b/drivers/crypto/hisilicon/Makefile
@@ -5,3 +5,4 @@ obj-$(CONFIG_CRYPTO_DEV_HISI_SEC2) += sec2/
 obj-$(CONFIG_CRYPTO_DEV_HISI_QM) += hisi_qm.o
 hisi_qm-objs = qm.o sgl.o
 obj-$(CONFIG_CRYPTO_DEV_HISI_ZIP) += zip/
+obj-$(CONFIG_CRYPTO_DEV_HISI_TRNG) += trng/
diff --git a/drivers/crypto/hisilicon/trng/Makefile b/drivers/crypto/hisilicon/trng/Makefile
new file mode 100644
index 0000000..d909079
--- /dev/null
+++ b/drivers/crypto/hisilicon/trng/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_CRYPTO_DEV_HISI_TRNG) += hisi-trng-v2.o
+hisi-trng-v2-objs = trng.o
diff --git a/drivers/crypto/hisilicon/trng/trng.c b/drivers/crypto/hisilicon/trng/trng.c
new file mode 100644
index 0000000..6a65b82
--- /dev/null
+++ b/drivers/crypto/hisilicon/trng/trng.c
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

