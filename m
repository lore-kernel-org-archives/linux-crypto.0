Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE1C8C433DB
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Feb 2021 01:36:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C702564E66
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Feb 2021 01:36:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhBIBgr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Feb 2021 20:36:47 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:12871 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbhBIBgq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Feb 2021 20:36:46 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DZQRd5CSSz7j8q;
        Tue,  9 Feb 2021 09:34:37 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Tue, 9 Feb 2021 09:35:58 +0800
From:   Tian Tao <tiantao6@hisilicon.com>
To:     <mpm@selenic.com>, <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>
Subject: [PATCH] hwrng: ba431 - Use device-managed registration
Date:   Tue, 9 Feb 2021 09:35:34 +0800
Message-ID: <1612834534-59383-1-git-send-email-tiantao6@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use device-managed registration, so we can delete the ba431_trng_remove.

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
---
 drivers/char/hw_random/ba431-rng.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/char/hw_random/ba431-rng.c b/drivers/char/hw_random/ba431-rng.c
index 410b50b..4f514e2 100644
--- a/drivers/char/hw_random/ba431-rng.c
+++ b/drivers/char/hw_random/ba431-rng.c
@@ -193,7 +193,7 @@ static int ba431_trng_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, ba431);
 
-	ret = hwrng_register(&ba431->rng);
+	ret = devm_hwrng_register(&pdev->dev, &ba431->rng);
 	if (ret) {
 		dev_err(&pdev->dev, "BA431 registration failed (%d)\n", ret);
 		return ret;
@@ -204,15 +204,6 @@ static int ba431_trng_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int ba431_trng_remove(struct platform_device *pdev)
-{
-	struct ba431_trng *ba431 = platform_get_drvdata(pdev);
-
-	hwrng_unregister(&ba431->rng);
-
-	return 0;
-}
-
 static const struct of_device_id ba431_trng_dt_ids[] = {
 	{ .compatible = "silex-insight,ba431-rng", .data = NULL },
 	{ /* sentinel */ }
@@ -225,7 +216,6 @@ static struct platform_driver ba431_trng_driver = {
 		.of_match_table = ba431_trng_dt_ids,
 	},
 	.probe = ba431_trng_probe,
-	.remove = ba431_trng_remove,
 };
 
 module_platform_driver(ba431_trng_driver);
-- 
2.7.4

