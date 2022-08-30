Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2590ECAAD2
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Aug 2022 03:02:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiH3DCy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Aug 2022 23:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbiH3DCi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Aug 2022 23:02:38 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11287A1D6D;
        Mon, 29 Aug 2022 20:02:32 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MGsSH3HYMzYcnL;
        Tue, 30 Aug 2022 10:58:07 +0800 (CST)
Received: from kwepemm600010.china.huawei.com (7.193.23.86) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 30 Aug 2022 11:02:30 +0800
Received: from huawei.com (10.175.127.227) by kwepemm600010.china.huawei.com
 (7.193.23.86) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 30 Aug
 2022 11:02:29 +0800
From:   Sun Ke <sunke32@huawei.com>
To:     <neal_liu@aspeedtech.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <joel@jms.id.au>
CC:     <linux-aspeed@lists.ozlabs.org>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kernel-janitors@vger.kernel.org>, <sunke32@huawei.com>
Subject: [PATCH] crypto: aspeed: fix return value check in aspeed_hace_probe()
Date:   Tue, 30 Aug 2022 11:13:47 +0800
Message-ID: <20220830031347.810217-1-sunke32@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600010.china.huawei.com (7.193.23.86)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In case of error, the function devm_ioremap_resource() returns
ERR_PTR() not NULL. The NULL test in the return value check must be
replaced with IS_ERR().

Fixes: 108713a713c7 ("crypto: aspeed - Add HACE hash driver")
Signed-off-by: Sun Ke <sunke32@huawei.com>
---
 drivers/crypto/aspeed/aspeed-hace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/aspeed/aspeed-hace.c b/drivers/crypto/aspeed/aspeed-hace.c
index 4fefc9e69d72..3f880aafb6a2 100644
--- a/drivers/crypto/aspeed/aspeed-hace.c
+++ b/drivers/crypto/aspeed/aspeed-hace.c
@@ -123,9 +123,9 @@ static int aspeed_hace_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, hace_dev);
 
 	hace_dev->regs = devm_ioremap_resource(&pdev->dev, res);
-	if (!hace_dev->regs) {
+	if (IS_ERR(hace_dev->regs)) {
 		dev_err(&pdev->dev, "Failed to map resources\n");
-		return -ENOMEM;
+		return PTR_ERR(hace_dev->regs);
 	}
 
 	/* Get irq number and register it */
-- 
2.31.1

