Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40220C43613
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 07:24:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 164AE20674
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 07:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbfFXHYh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 03:24:37 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:59104 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726719AbfFXHYh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 03:24:37 -0400
X-UUID: f99ff83372764d82ac28946816a925de-20190624
X-UUID: f99ff83372764d82ac28946816a925de-20190624
Received: from mtkmrs01.mediatek.inc [(172.21.131.159)] by mailgw01.mediatek.com
        (envelope-from <neal.liu@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 176232665; Mon, 24 Jun 2019 15:24:30 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 24 Jun 2019 15:24:29 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 24 Jun 2019 15:24:28 +0800
From:   Neal Liu <neal.liu@mediatek.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@kernel.org>
CC:     Neal Liu <neal.liu@mediatek.com>,
        Crystal Guo <Crystal.Guo@mediatek.com>,
        <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <wsd_upstream@mediatek.com>
Subject: [PATCH v4 3/3] hwrng: add mtk-sec-rng driver
Date:   Mon, 24 Jun 2019 15:24:12 +0800
Message-ID: <1561361052-13072-4-git-send-email-neal.liu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1561361052-13072-1-git-send-email-neal.liu@mediatek.com>
References: <1561361052-13072-1-git-send-email-neal.liu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

For MediaTek SoCs on ARMv8 with TrustZone enabled, peripherals like
entropy sources is not accessible from normal world (linux) and
rather accessible from secure world (ATF/TEE) only. This driver aims
to provide a generic interface to ATF rng service.

Signed-off-by: Neal Liu <neal.liu@mediatek.com>
---
 drivers/char/hw_random/Kconfig       |   16 ++++++
 drivers/char/hw_random/Makefile      |    1 +
 drivers/char/hw_random/mtk-sec-rng.c |   97 ++++++++++++++++++++++++++++++++++
 3 files changed, 114 insertions(+)
 create mode 100644 drivers/char/hw_random/mtk-sec-rng.c

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 25a7d8f..6c82a3b 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -398,6 +398,22 @@ config HW_RANDOM_MTK
 
 	  If unsure, say Y.
 
+config HW_RANDOM_MTK_SEC
+	tristate "MediaTek Security Random Number Generator support"
+	depends on HW_RANDOM
+	depends on ARCH_MEDIATEK || COMPILE_TEST
+	default HW_RANDOM
+	help
+	  This driver provides kernel-side support for the Random Number
+	  Generator hardware found on MediaTek SoCs. The difference with
+	  mtk-rng is the Random Number Generator hardware is secure
+	  access only.
+
+	  To compile this driver as a module, choose M here. the
+	  module will be called mtk-sec-rng.
+
+	  If unsure, say Y.
+
 config HW_RANDOM_S390
 	tristate "S390 True Random Number Generator support"
 	depends on S390
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index 7c9ef4a..0ae4993 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -36,6 +36,7 @@ obj-$(CONFIG_HW_RANDOM_PIC32) += pic32-rng.o
 obj-$(CONFIG_HW_RANDOM_MESON) += meson-rng.o
 obj-$(CONFIG_HW_RANDOM_CAVIUM) += cavium-rng.o cavium-rng-vf.o
 obj-$(CONFIG_HW_RANDOM_MTK)	+= mtk-rng.o
+obj-$(CONFIG_HW_RANDOM_MTK_SEC) += mtk-sec-rng.o
 obj-$(CONFIG_HW_RANDOM_S390) += s390-trng.o
 obj-$(CONFIG_HW_RANDOM_KEYSTONE) += ks-sa-rng.o
 obj-$(CONFIG_HW_RANDOM_OPTEE) += optee-rng.o
diff --git a/drivers/char/hw_random/mtk-sec-rng.c b/drivers/char/hw_random/mtk-sec-rng.c
new file mode 100644
index 0000000..ecd2e29
--- /dev/null
+++ b/drivers/char/hw_random/mtk-sec-rng.c
@@ -0,0 +1,97 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 MediaTek Inc.
+ */
+
+#include <linux/arm-smccc.h>
+#include <linux/hw_random.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/soc/mediatek/mtk_sip_svc.h>
+
+#define MT67XX_RNG_MAGIC	0x74726e67
+#define SMC_RET_NUM		4
+#define MTK_SEC_RND_SIZE	(sizeof(u32) * SMC_RET_NUM)
+
+struct mtk_sec_rng_priv {
+	struct hwrng rng;
+};
+
+static void mtk_sec_get_rnd(uint32_t *val)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_smc(MTK_SIP_KERNEL_GET_RND,
+		      MT67XX_RNG_MAGIC, 0, 0, 0, 0, 0, 0, &res);
+
+	val[0] = res.a0;
+	val[1] = res.a1;
+	val[2] = res.a2;
+	val[3] = res.a3;
+}
+
+static int mtk_sec_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
+{
+	u32 val[4] = {0};
+	int retval = 0;
+	int i;
+
+	while (max >= MTK_SEC_RND_SIZE) {
+		mtk_sec_get_rnd(val);
+
+		for (i = 0; i < SMC_RET_NUM; i++) {
+			*(u32 *)buf = val[i];
+			buf += sizeof(u32);
+		}
+
+		retval += MTK_SEC_RND_SIZE;
+		max -= MTK_SEC_RND_SIZE;
+	}
+
+	return retval;
+}
+
+static int mtk_sec_rng_probe(struct platform_device *pdev)
+{
+	struct mtk_sec_rng_priv *priv;
+	int ret;
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->rng.name = pdev->name;
+	priv->rng.read = mtk_sec_rng_read;
+	priv->rng.priv = (unsigned long)&pdev->dev;
+	priv->rng.quality = 900;
+
+	ret = devm_hwrng_register(&pdev->dev, &priv->rng);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to register rng device: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static const struct of_device_id mtk_sec_rng_match[] = {
+	{ .compatible = "mediatek,mtk-sec-rng", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, mtk_sec_rng_match);
+
+static struct platform_driver mtk_sec_rng_driver = {
+	.probe = mtk_sec_rng_probe,
+	.driver = {
+		.name = KBUILD_MODNAME,
+		.owner = THIS_MODULE,
+		.of_match_table = mtk_sec_rng_match,
+	},
+};
+
+module_platform_driver(mtk_sec_rng_driver);
+
+MODULE_DESCRIPTION("MediaTek Security Random Number Generator Driver");
+MODULE_AUTHOR("Neal Liu <neal.liu@mediatek.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.9.5

