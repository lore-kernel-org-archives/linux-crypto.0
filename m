Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F989C5519F
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Nov 2020 09:05:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45C342220B
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Nov 2020 09:05:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgKTJF4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Nov 2020 04:05:56 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7710 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbgKTJF4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Nov 2020 04:05:56 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CcrHG5yRgzkcPy;
        Fri, 20 Nov 2020 17:05:30 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Fri, 20 Nov 2020 17:04:56 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <mpm@selenic.com>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>,
        Weili Qian <qianweili@huawei.com>
Subject: [PATCH 1/4] hwrng: hisi - remove HiSilicon TRNG driver
Date:   Fri, 20 Nov 2020 17:02:31 +0800
Message-ID: <1605862954-38300-1-git-send-email-qianweili@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Driver of HiSilicon true random number generator(TRNG)
is removed from 'drivers/char/hw_random'.

Both 'Kunpeng 920' and 'Kunpeng 930' chips have TRNG,
however, PRNG is only supported by 'Kunpeng 930'.
So, this driver is moved to 'drivers/crypto/hisilicon/trng/'
in the next to enable the two's TRNG better.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/char/hw_random/Kconfig        | 13 -----
 drivers/char/hw_random/Makefile       |  1 -
 drivers/char/hw_random/hisi-trng-v2.c | 99 -----------------------------------
 3 files changed, 113 deletions(-)
 delete mode 100644 drivers/char/hw_random/hisi-trng-v2.c

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index e92c4d9..eb0d51a 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -348,19 +348,6 @@ config HW_RANDOM_HISI
 
 	  If unsure, say Y.
 
-config HW_RANDOM_HISI_V2
-	tristate "HiSilicon True Random Number Generator V2 support"
-	depends on HW_RANDOM && ARM64 && ACPI
-	default HW_RANDOM
-	help
-	  This driver provides kernel-side support for the True Random Number
-	  Generator V2 hardware found on HiSilicon Hi1620 SoC.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called hisi-trng-v2.
-
-	  If unsure, say Y.
-
 config HW_RANDOM_ST
 	tristate "ST Microelectronics HW Random Number Generator support"
 	depends on HW_RANDOM && ARCH_STI
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index 5da3445..8933fad 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -30,7 +30,6 @@ obj-$(CONFIG_HW_RANDOM_NOMADIK) += nomadik-rng.o
 obj-$(CONFIG_HW_RANDOM_PSERIES) += pseries-rng.o
 obj-$(CONFIG_HW_RANDOM_POWERNV) += powernv-rng.o
 obj-$(CONFIG_HW_RANDOM_HISI)	+= hisi-rng.o
-obj-$(CONFIG_HW_RANDOM_HISI_V2) += hisi-trng-v2.o
 obj-$(CONFIG_HW_RANDOM_BCM2835) += bcm2835-rng.o
 obj-$(CONFIG_HW_RANDOM_IPROC_RNG200) += iproc-rng200.o
 obj-$(CONFIG_HW_RANDOM_ST) += st-rng.o
diff --git a/drivers/char/hw_random/hisi-trng-v2.c b/drivers/char/hw_random/hisi-trng-v2.c
deleted file mode 100644
index 6a65b82..0000000
--- a/drivers/char/hw_random/hisi-trng-v2.c
+++ /dev/null
@@ -1,99 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/* Copyright (c) 2019 HiSilicon Limited. */
-
-#include <linux/acpi.h>
-#include <linux/err.h>
-#include <linux/hw_random.h>
-#include <linux/io.h>
-#include <linux/iopoll.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/platform_device.h>
-#include <linux/random.h>
-
-#define HISI_TRNG_REG		0x00F0
-#define HISI_TRNG_BYTES		4
-#define HISI_TRNG_QUALITY	512
-#define SLEEP_US		10
-#define TIMEOUT_US		10000
-
-struct hisi_trng {
-	void __iomem *base;
-	struct hwrng rng;
-};
-
-static int hisi_trng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
-{
-	struct hisi_trng *trng;
-	int currsize = 0;
-	u32 val = 0;
-	u32 ret;
-
-	trng = container_of(rng, struct hisi_trng, rng);
-
-	do {
-		ret = readl_poll_timeout(trng->base + HISI_TRNG_REG, val,
-					 val, SLEEP_US, TIMEOUT_US);
-		if (ret)
-			return currsize;
-
-		if (max - currsize >= HISI_TRNG_BYTES) {
-			memcpy(buf + currsize, &val, HISI_TRNG_BYTES);
-			currsize += HISI_TRNG_BYTES;
-			if (currsize == max)
-				return currsize;
-			continue;
-		}
-
-		/* copy remaining bytes */
-		memcpy(buf + currsize, &val, max - currsize);
-		currsize = max;
-	} while (currsize < max);
-
-	return currsize;
-}
-
-static int hisi_trng_probe(struct platform_device *pdev)
-{
-	struct hisi_trng *trng;
-	int ret;
-
-	trng = devm_kzalloc(&pdev->dev, sizeof(*trng), GFP_KERNEL);
-	if (!trng)
-		return -ENOMEM;
-
-	trng->base = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(trng->base))
-		return PTR_ERR(trng->base);
-
-	trng->rng.name = pdev->name;
-	trng->rng.read = hisi_trng_read;
-	trng->rng.quality = HISI_TRNG_QUALITY;
-
-	ret = devm_hwrng_register(&pdev->dev, &trng->rng);
-	if (ret)
-		dev_err(&pdev->dev, "failed to register hwrng!\n");
-
-	return ret;
-}
-
-static const struct acpi_device_id hisi_trng_acpi_match[] = {
-	{ "HISI02B3", 0 },
-	{ }
-};
-MODULE_DEVICE_TABLE(acpi, hisi_trng_acpi_match);
-
-static struct platform_driver hisi_trng_driver = {
-	.probe		= hisi_trng_probe,
-	.driver		= {
-		.name	= "hisi-trng-v2",
-		.acpi_match_table = ACPI_PTR(hisi_trng_acpi_match),
-	},
-};
-
-module_platform_driver(hisi_trng_driver);
-
-MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR("Weili Qian <qianweili@huawei.com>");
-MODULE_AUTHOR("Zaibo Xu <xuzaibo@huawei.com>");
-MODULE_DESCRIPTION("HiSilicon true random number generator V2 driver");
-- 
2.8.1

