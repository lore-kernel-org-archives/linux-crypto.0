Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 998C2C433E0
	for <linux-crypto@archiver.kernel.org>; Sat, 13 Mar 2021 01:42:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54F7464F8D
	for <linux-crypto@archiver.kernel.org>; Sat, 13 Mar 2021 01:42:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhCMBmI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Mar 2021 20:42:08 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:13914 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232223AbhCMBl7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Mar 2021 20:41:59 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Dy53X3wQHzkYJZ;
        Sat, 13 Mar 2021 09:40:24 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Sat, 13 Mar 2021 09:41:52 +0800
From:   Tian Tao <tiantao6@hisilicon.com>
To:     <herbert@gondor.apana.org.au>, <mpm@selenic.com>,
        <hadar.gat@arm.com>
CC:     <linux-crypto@vger.kernel.org>
Subject: [PATCH] hwrng: cctrn - use devm_platform_ioremap_resource() to simplify
Date:   Sat, 13 Mar 2021 09:42:35 +0800
Message-ID: <1615599755-28181-1-git-send-email-tiantao6@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use devm_platform_ioremap_resource() to simplify the code.

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
---
 drivers/char/hw_random/cctrng.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cctrng.c
index 7a293f2..e7f12953 100644
--- a/drivers/char/hw_random/cctrng.c
+++ b/drivers/char/hw_random/cctrng.c
@@ -486,7 +486,6 @@ static void cc_trng_clk_fini(struct cctrng_drvdata *drvdata)
 
 static int cctrng_probe(struct platform_device *pdev)
 {
-	struct resource *req_mem_cc_regs = NULL;
 	struct cctrng_drvdata *drvdata;
 	struct device *dev = &pdev->dev;
 	int rc = 0;
@@ -510,21 +509,12 @@ static int cctrng_probe(struct platform_device *pdev)
 
 	drvdata->circ.buf = (char *)drvdata->data_buf;
 
-	/* Get device resources */
-	/* First CC registers space */
-	req_mem_cc_regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	/* Map registers space */
-	drvdata->cc_base = devm_ioremap_resource(dev, req_mem_cc_regs);
+	drvdata->cc_base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(drvdata->cc_base)) {
 		dev_err(dev, "Failed to ioremap registers");
 		return PTR_ERR(drvdata->cc_base);
 	}
 
-	dev_dbg(dev, "Got MEM resource (%s): %pR\n", req_mem_cc_regs->name,
-		req_mem_cc_regs);
-	dev_dbg(dev, "CC registers mapped from %pa to 0x%p\n",
-		&req_mem_cc_regs->start, drvdata->cc_base);
-
 	/* Then IRQ */
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
-- 
2.7.4

