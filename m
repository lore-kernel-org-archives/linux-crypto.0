Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5FACC04FF3
	for <linux-crypto@archiver.kernel.org>; Mon, 24 May 2021 12:21:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84DC661261
	for <linux-crypto@archiver.kernel.org>; Mon, 24 May 2021 12:21:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbhEXMWe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 May 2021 08:22:34 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3929 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232300AbhEXMWd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 May 2021 08:22:33 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FpbpD6ZyDzBvQ4;
        Mon, 24 May 2021 20:18:12 +0800 (CST)
Received: from dggeme759-chm.china.huawei.com (10.3.19.105) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 24 May 2021 20:21:03 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggeme759-chm.china.huawei.com (10.3.19.105) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 24 May 2021 20:21:03 +0800
From:   Tian Tao <tiantao6@hisilicon.com>
To:     <dsaxena@plexity.net>, <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, Tian Tao <tiantao6@hisilicon.com>
Subject: [PATCH v2] hwrng: omap - Use pm_runtime_resume_and_get() to replace open coding
Date:   Mon, 24 May 2021 20:20:57 +0800
Message-ID: <1621858857-39242-1-git-send-email-tiantao6@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme759-chm.china.huawei.com (10.3.19.105)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

use pm_runtime_resume_and_get() to replace pm_runtime_get_sync and
pm_runtime_put_noidle. this change is just to simplify the code, no
actual functional changes.

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
---
v2: fix the problem of one missing change in patch
---
 drivers/char/hw_random/omap-rng.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index cede9f1..00ff967 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -454,10 +454,9 @@ static int omap_rng_probe(struct platform_device *pdev)
 	}
 
 	pm_runtime_enable(&pdev->dev);
-	ret = pm_runtime_get_sync(&pdev->dev);
+	ret = pm_runtime_resume_and_get(&pdev->dev);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to runtime_get device: %d\n", ret);
-		pm_runtime_put_noidle(&pdev->dev);
 		goto err_ioremap;
 	}
 
@@ -543,10 +542,9 @@ static int __maybe_unused omap_rng_resume(struct device *dev)
 	struct omap_rng_dev *priv = dev_get_drvdata(dev);
 	int ret;
 
-	ret = pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0) {
 		dev_err(dev, "Failed to runtime_get device: %d\n", ret);
-		pm_runtime_put_noidle(dev);
 		return ret;
 	}
 
-- 
2.7.4

