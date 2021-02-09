Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 070A0C433E0
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Feb 2021 06:27:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA15E64E54
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Feb 2021 06:27:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbhBIG0i (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Feb 2021 01:26:38 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12532 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbhBIG0V (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Feb 2021 01:26:21 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DZXsP2GrnzMWrY;
        Tue,  9 Feb 2021 14:23:53 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Tue, 9 Feb 2021 14:25:35 +0800
From:   Tian Tao <tiantao6@hisilicon.com>
To:     <f.fainelli@gmail.com>, <rjui@broadcom.com>,
        <sbranden@broadcom.com>, <bcm-kernel-feedback-list@broadcom.com>
CC:     <linux-crypto@vger.kernel.org>,
        <linux-rpi-kernel@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH] hwrng: bcm2835 - remove redundant null check
Date:   Tue, 9 Feb 2021 14:25:11 +0800
Message-ID: <1612851911-57937-1-git-send-email-tiantao6@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

clk_prepare_enable() and clk_disable_unprepare() will check
NULL clock parameter, so It is not necessary to add additional checks.

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
---
 drivers/char/hw_random/bcm2835-rng.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
index 1a7c43b..ed0aa51 100644
--- a/drivers/char/hw_random/bcm2835-rng.c
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -88,11 +88,9 @@ static int bcm2835_rng_init(struct hwrng *rng)
 	int ret = 0;
 	u32 val;
 
-	if (!IS_ERR(priv->clk)) {
-		ret = clk_prepare_enable(priv->clk);
-		if (ret)
-			return ret;
-	}
+	ret = clk_prepare_enable(priv->clk);
+	if (ret)
+		return ret;
 
 	if (priv->mask_interrupts) {
 		/* mask the interrupt */
@@ -115,8 +113,7 @@ static void bcm2835_rng_cleanup(struct hwrng *rng)
 	/* disable rng hardware */
 	rng_writel(priv, 0, RNG_CTRL);
 
-	if (!IS_ERR(priv->clk))
-		clk_disable_unprepare(priv->clk);
+	clk_disable_unprepare(priv->clk);
 }
 
 struct bcm2835_rng_of_data {
-- 
2.7.4

