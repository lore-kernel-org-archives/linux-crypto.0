Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5514BC433B4
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Apr 2021 14:18:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1874061359
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Apr 2021 14:18:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348192AbhDGOSs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Apr 2021 10:18:48 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15159 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344321AbhDGOSs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Apr 2021 10:18:48 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FFmdd6xXszpW59;
        Wed,  7 Apr 2021 22:15:49 +0800 (CST)
Received: from localhost (10.174.179.96) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.498.0; Wed, 7 Apr 2021
 22:18:28 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next 2/5] crypto: img-hash - Remove redundant dev_err call in img_hash_probe()
Date:   Wed, 7 Apr 2021 22:18:16 +0800
Message-ID: <20210407141819.32588-3-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
In-Reply-To: <20210407141819.32588-1-yuehaibing@huawei.com>
References: <20210407141819.32588-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.96]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

devm_platform_ioremap_resource() and devm_ioremap_resource()
will print err msg while failing, so the redundant dev_err call
can be removed.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/crypto/img-hash.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index e813115d5432..aa4c7b2af3e2 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -963,8 +963,6 @@ static int img_hash_probe(struct platform_device *pdev)
 	hdev->io_base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(hdev->io_base)) {
 		err = PTR_ERR(hdev->io_base);
-		dev_err(dev, "can't ioremap, returned %d\n", err);
-
 		goto res_err;
 	}
 
@@ -972,7 +970,6 @@ static int img_hash_probe(struct platform_device *pdev)
 	hash_res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	hdev->cpu_addr = devm_ioremap_resource(dev, hash_res);
 	if (IS_ERR(hdev->cpu_addr)) {
-		dev_err(dev, "can't ioremap write port\n");
 		err = PTR_ERR(hdev->cpu_addr);
 		goto res_err;
 	}
-- 
2.17.1

