Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0E5BC433E0
	for <linux-crypto@archiver.kernel.org>; Sun,  7 Feb 2021 02:40:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F9AF64E8C
	for <linux-crypto@archiver.kernel.org>; Sun,  7 Feb 2021 02:40:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhBGCkM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 6 Feb 2021 21:40:12 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:12441 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhBGCkM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 6 Feb 2021 21:40:12 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DYCy73XbczjGmF;
        Sun,  7 Feb 2021 10:38:23 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Sun, 7 Feb 2021 10:39:28 +0800
From:   Tian Tao <tiantao6@hisilicon.com>
To:     <mpm@selenic.com>, <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>
Subject: [PATCH] hw_random: timeriomem_rng: Use device-managed registration API
Date:   Sun, 7 Feb 2021 10:39:05 +0800
Message-ID: <1612665545-43612-1-git-send-email-tiantao6@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use devm_hwrng_register to get rid of manual unregistration.

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
---
 drivers/char/hw_random/timeriomem-rng.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/timeriomem-rng.c b/drivers/char/hw_random/timeriomem-rng.c
index e262445..9c237a0 100644
--- a/drivers/char/hw_random/timeriomem-rng.c
+++ b/drivers/char/hw_random/timeriomem-rng.c
@@ -169,7 +169,7 @@ static int timeriomem_rng_probe(struct platform_device *pdev)
 	priv->present = 1;
 	complete(&priv->completion);
 
-	err = hwrng_register(&priv->rng_ops);
+	err = devm_hwrng_register(&pdev->dev, &priv->rng_ops);
 	if (err) {
 		dev_err(&pdev->dev, "problem registering\n");
 		return err;
@@ -185,7 +185,6 @@ static int timeriomem_rng_remove(struct platform_device *pdev)
 {
 	struct timeriomem_rng_private *priv = platform_get_drvdata(pdev);
 
-	hwrng_unregister(&priv->rng_ops);
 	hrtimer_cancel(&priv->timer);
 
 	return 0;
-- 
2.7.4

