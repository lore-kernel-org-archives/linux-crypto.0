Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C0D3C433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Mar 2021 02:44:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3320964E09
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Mar 2021 02:44:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbhCACnq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 28 Feb 2021 21:43:46 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:13011 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbhCACnp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 28 Feb 2021 21:43:45 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DpkzP2DpTzjTZb;
        Mon,  1 Mar 2021 10:41:21 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Mon, 1 Mar 2021 10:42:58 +0800
From:   Tian Tao <tiantao6@hisilicon.com>
To:     <hadar.gat@arm.com>, <mpm@selenic.com>,
        <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>
Subject: [PATCH] hwrng: cctrng - Use device-managed registration API
Date:   Mon, 1 Mar 2021 10:43:48 +0800
Message-ID: <1614566628-52886-1-git-send-email-tiantao6@hisilicon.com>
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
 drivers/char/hw_random/cctrng.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cctrng.c
index 7a293f2..0efb37a 100644
--- a/drivers/char/hw_random/cctrng.c
+++ b/drivers/char/hw_random/cctrng.c
@@ -585,7 +585,7 @@ static int cctrng_probe(struct platform_device *pdev)
 	atomic_set(&drvdata->pending_hw, 1);
 
 	/* registration of the hwrng device */
-	rc = hwrng_register(&drvdata->rng);
+	rc = devm_hwrng_register(dev, &drvdata->rng);
 	if (rc) {
 		dev_err(dev, "Could not register hwrng device.\n");
 		goto post_pm_err;
@@ -618,8 +618,6 @@ static int cctrng_remove(struct platform_device *pdev)
 
 	dev_dbg(dev, "Releasing cctrng resources...\n");
 
-	hwrng_unregister(&drvdata->rng);
-
 	cc_trng_pm_fini(drvdata);
 
 	cc_trng_clk_fini(drvdata);
-- 
2.7.4

