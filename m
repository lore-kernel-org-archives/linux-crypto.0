Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42D0CC6FA86
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Sep 2022 09:28:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiIWJ2x (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Sep 2022 05:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbiIWJ2Q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Sep 2022 05:28:16 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12FAF192E
        for <linux-crypto@vger.kernel.org>; Fri, 23 Sep 2022 02:27:54 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MYmwF6l4czHpkC;
        Fri, 23 Sep 2022 17:25:33 +0800 (CST)
Received: from kwepemm600008.china.huawei.com (7.193.23.88) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 23 Sep 2022 17:27:45 +0800
Received: from huawei.com (10.175.100.227) by kwepemm600008.china.huawei.com
 (7.193.23.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 23 Sep
 2022 17:27:44 +0800
From:   Shang XiaoJing <shangxiaojing@huawei.com>
To:     <neal_liu@aspeedtech.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <joel@jms.id.au>, <andrew@aj.id.au>,
        <linux-aspeed@lists.ozlabs.org>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <shangxiaojing@huawei.com>
Subject: [PATCH -next] crypto: aspeed - Remove redundant dev_err call
Date:   Fri, 23 Sep 2022 18:01:59 +0800
Message-ID: <20220923100159.15705-1-shangxiaojing@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.227]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600008.china.huawei.com (7.193.23.88)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

devm_ioremap_resource() prints error message in itself. Remove the
dev_err call to avoid redundant error message.

Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
---
 drivers/crypto/aspeed/aspeed-hace.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/aspeed/aspeed-hace.c b/drivers/crypto/aspeed/aspeed-hace.c
index 3f880aafb6a2..e05c32c31842 100644
--- a/drivers/crypto/aspeed/aspeed-hace.c
+++ b/drivers/crypto/aspeed/aspeed-hace.c
@@ -123,10 +123,8 @@ static int aspeed_hace_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, hace_dev);
 
 	hace_dev->regs = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(hace_dev->regs)) {
-		dev_err(&pdev->dev, "Failed to map resources\n");
+	if (IS_ERR(hace_dev->regs))
 		return PTR_ERR(hace_dev->regs);
-	}
 
 	/* Get irq number and register it */
 	hace_dev->irq = platform_get_irq(pdev, 0);
-- 
2.17.1

