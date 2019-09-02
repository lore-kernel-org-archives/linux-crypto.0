Return-Path: <SRS0=lOaP=W5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D990DC3A5A7
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Sep 2019 14:19:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B31AB2173E
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Sep 2019 14:19:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbfIBOTt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Sep 2019 10:19:49 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:59558 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726438AbfIBOTt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Sep 2019 10:19:49 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 323292FC0905CA677613;
        Mon,  2 Sep 2019 22:19:47 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Mon, 2 Sep 2019
 22:19:37 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <antoine.tenart@bootlin.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <pvanleeuwen@insidesecure.com>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] crypto: inside-secure - Fix build error without CONFIG_PCI
Date:   Mon, 2 Sep 2019 22:19:10 +0800
Message-ID: <20190902141910.1080-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If CONFIG_PCI is not set, building fails:

rivers/crypto/inside-secure/safexcel.c: In function safexcel_request_ring_irq:
drivers/crypto/inside-secure/safexcel.c:944:9: error: implicit declaration of function pci_irq_vector;
 did you mean rcu_irq_enter? [-Werror=implicit-function-declaration]
   irq = pci_irq_vector(pci_pdev, irqid);
         ^~~~~~~~~~~~~~

Use #ifdef block to guard this.

Fixes: 625f269a5a7a ("crypto: inside-secure - add support for PCI based FPGA development board")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/crypto/inside-secure/safexcel.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index e12a2a3..c23fe34 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -937,7 +937,8 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 	int ret, irq;
 	struct device *dev;
 
-	if (IS_ENABLED(CONFIG_PCI) && is_pci_dev) {
+#if IS_ENABLED(CONFIG_PCI)
+	if (is_pci_dev) {
 		struct pci_dev *pci_pdev = pdev;
 
 		dev = &pci_pdev->dev;
@@ -947,7 +948,10 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 				irqid, irq);
 			return irq;
 		}
-	} else if (IS_ENABLED(CONFIG_OF)) {
+	} else
+#endif
+	{
+#if IS_ENABLED(CONFIG_OF)
 		struct platform_device *plf_pdev = pdev;
 		char irq_name[6] = {0}; /* "ringX\0" */
 
@@ -960,6 +964,7 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 				irq_name, irq);
 			return irq;
 		}
+#endif
 	}
 
 	ret = devm_request_threaded_irq(dev, irq, handler,
@@ -1137,7 +1142,8 @@ static int safexcel_probe_generic(void *pdev,
 
 	safexcel_configure(priv);
 
-	if (IS_ENABLED(CONFIG_PCI) && priv->version == EIP197_DEVBRD) {
+#if IS_ENABLED(CONFIG_PCI)
+	if (priv->version == EIP197_DEVBRD) {
 		/*
 		 * Request MSI vectors for global + 1 per ring -
 		 * or just 1 for older dev images
@@ -1153,6 +1159,7 @@ static int safexcel_probe_generic(void *pdev,
 			return ret;
 		}
 	}
+#endif
 
 	/* Register the ring IRQ handlers and configure the rings */
 	priv->ring = devm_kcalloc(dev, priv->config.rings,
-- 
2.7.4


