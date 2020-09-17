Return-Path: <SRS0=yTfj=C2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21227C433E2
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Sep 2020 07:52:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED39721D7F
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Sep 2020 07:52:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgIQHwM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Sep 2020 03:52:12 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:50526 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726311AbgIQHwJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Sep 2020 03:52:09 -0400
X-Greylist: delayed 975 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 03:52:07 EDT
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 114D39327DA449C22ECE;
        Thu, 17 Sep 2020 15:35:48 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Thu, 17 Sep 2020
 15:35:43 +0800
From:   Qilong Zhang <zhangqilong3@huawei.com>
To:     <bbrezillon@kernel.org>, <arno@natisbad.org>,
        <herbert@gondor.apana.org.au>, <schalla@marvell.com>,
        <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>
Subject: [PATCH -next] crypto: marvell/cesa - use devm_platform_ioremap_resource_byname
Date:   Thu, 17 Sep 2020 15:42:34 +0800
Message-ID: <20200917074234.114623-1-zhangqilong3@huawei.com>
X-Mailer: git-send-email 2.26.0.106.g9fadedd
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

Use the devm_platform_ioremap_resource_byname() helper instead of
calling platform_get_resource_byname() and devm_ioremap_resource()
separately.

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
---
 drivers/crypto/marvell/cesa/cesa.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/marvell/cesa/cesa.c b/drivers/crypto/marvell/cesa/cesa.c
index d63bca9718dc..06211858bf2e 100644
--- a/drivers/crypto/marvell/cesa/cesa.c
+++ b/drivers/crypto/marvell/cesa/cesa.c
@@ -437,7 +437,6 @@ static int mv_cesa_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct mv_cesa_dev *cesa;
 	struct mv_cesa_engine *engines;
-	struct resource *res;
 	int irq, ret, i, cpu;
 	u32 sram_size;
 
@@ -475,8 +474,7 @@ static int mv_cesa_probe(struct platform_device *pdev)
 
 	spin_lock_init(&cesa->lock);
 
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "regs");
-	cesa->regs = devm_ioremap_resource(dev, res);
+	cesa->regs = devm_platform_ioremap_resource_byname(pdev, "regs");
 	if (IS_ERR(cesa->regs))
 		return PTR_ERR(cesa->regs);
 
-- 
2.17.1

