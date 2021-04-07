Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 864BAC43460
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Apr 2021 14:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56D0461279
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Apr 2021 14:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348216AbhDGOSs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Apr 2021 10:18:48 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:16814 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243747AbhDGOSs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Apr 2021 10:18:48 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FFmfK3S03z940b;
        Wed,  7 Apr 2021 22:16:25 +0800 (CST)
Received: from localhost (10.174.179.96) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.498.0; Wed, 7 Apr 2021
 22:18:29 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next 3/5] crypto: ux500 - Remove redundant dev_err calls
Date:   Wed, 7 Apr 2021 22:18:17 +0800
Message-ID: <20210407141819.32588-4-yuehaibing@huawei.com>
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

There is a error message within devm_ioremap_resource
already, so remove the dev_err call to avoid redundant
error message.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/crypto/ux500/cryp/cryp_core.c | 1 -
 drivers/crypto/ux500/hash/hash_core.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index 10fcd682988b..30cdd5253929 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -1291,7 +1291,6 @@ static int ux500_cryp_probe(struct platform_device *pdev)
 	device_data->phybase = res->start;
 	device_data->base = devm_ioremap_resource(dev, res);
 	if (IS_ERR(device_data->base)) {
-		dev_err(dev, "[%s]: ioremap failed!", __func__);
 		ret = PTR_ERR(device_data->base);
 		goto out;
 	}
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 7db15258475f..ecb7412e84e3 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -1676,7 +1676,6 @@ static int ux500_hash_probe(struct platform_device *pdev)
 	device_data->phybase = res->start;
 	device_data->base = devm_ioremap_resource(dev, res);
 	if (IS_ERR(device_data->base)) {
-		dev_err(dev, "%s: ioremap() failed!\n", __func__);
 		ret = PTR_ERR(device_data->base);
 		goto out;
 	}
-- 
2.17.1

