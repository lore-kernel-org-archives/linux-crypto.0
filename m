Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D35FC4332F
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Nov 2022 06:51:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiKXGvb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Nov 2022 01:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKXGva (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Nov 2022 01:51:30 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D410AE6763
        for <linux-crypto@vger.kernel.org>; Wed, 23 Nov 2022 22:51:28 -0800 (PST)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NHpYC5dbmzRpRB;
        Thu, 24 Nov 2022 14:50:55 +0800 (CST)
Received: from huawei.com (10.175.100.227) by kwepemi500016.china.huawei.com
 (7.221.188.220) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 24 Nov
 2022 14:51:26 +0800
From:   Shang XiaoJing <shangxiaojing@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <mgreer@animalcreek.com>, <linux-crypto@vger.kernel.org>
CC:     <shangxiaojing@huawei.com>
Subject: [PATCH] crypto: omap-sham - Use pm_runtime_resume_and_get() in omap_sham_probe()
Date:   Thu, 24 Nov 2022 14:49:40 +0800
Message-ID: <20221124064940.19845-1-shangxiaojing@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.227]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

omap_sham_probe() calls pm_runtime_get_sync() and calls
pm_runtime_put_sync() latter to put usage_counter. However,
pm_runtime_get_sync() will increment usage_counter even it failed. Fix
it by replacing it with pm_runtime_resume_and_get() to keep usage
counter balanced.

Fixes: b359f034c8bf ("crypto: omap-sham - Convert to use pm_runtime API")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
---
 drivers/crypto/omap-sham.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 655a7f5a406a..cbeda59c6b19 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -2114,7 +2114,7 @@ static int omap_sham_probe(struct platform_device *pdev)
 
 	pm_runtime_enable(dev);
 
-	err = pm_runtime_get_sync(dev);
+	err = pm_runtime_resume_and_get(dev);
 	if (err < 0) {
 		dev_err(dev, "failed to get sync: %d\n", err);
 		goto err_pm;
-- 
2.17.1

