Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AEC7C433DB
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Mar 2021 09:13:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDB4A64F53
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Mar 2021 09:13:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbhCEJNJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Mar 2021 04:13:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhCEJMj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Mar 2021 04:12:39 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA609C061574
        for <linux-crypto@vger.kernel.org>; Fri,  5 Mar 2021 01:12:38 -0800 (PST)
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28] helo=dude02.pengutronix.de.)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1lI6Vh-00049f-Jd; Fri, 05 Mar 2021 10:12:37 +0100
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     linux-crypto@vger.kernel.org
Cc:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] crypto: sun4i-ss - simplify optional reset handling
Date:   Fri,  5 Mar 2021 10:12:36 +0100
Message-Id: <20210305091236.22046-1-p.zabel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::28
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As of commit bb475230b8e5 ("reset: make optional functions really
optional"), the reset framework API calls use NULL pointers to describe
optional, non-present reset controls.

This allows to unconditionally return errors from
devm_reset_control_get_optional_exclusive.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 .../crypto/allwinner/sun4i-ss/sun4i-ss-core.c | 21 +++++++------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
index 709905ec4680..ef224d5e4903 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
@@ -288,8 +288,7 @@ static int sun4i_ss_pm_suspend(struct device *dev)
 {
 	struct sun4i_ss_ctx *ss = dev_get_drvdata(dev);
 
-	if (ss->reset)
-		reset_control_assert(ss->reset);
+	reset_control_assert(ss->reset);
 
 	clk_disable_unprepare(ss->ssclk);
 	clk_disable_unprepare(ss->busclk);
@@ -314,12 +313,10 @@ static int sun4i_ss_pm_resume(struct device *dev)
 		goto err_enable;
 	}
 
-	if (ss->reset) {
-		err = reset_control_deassert(ss->reset);
-		if (err) {
-			dev_err(ss->dev, "Cannot deassert reset control\n");
-			goto err_enable;
-		}
+	err = reset_control_deassert(ss->reset);
+	if (err) {
+		dev_err(ss->dev, "Cannot deassert reset control\n");
+		goto err_enable;
 	}
 
 	return err;
@@ -401,12 +398,10 @@ static int sun4i_ss_probe(struct platform_device *pdev)
 	dev_dbg(&pdev->dev, "clock ahb_ss acquired\n");
 
 	ss->reset = devm_reset_control_get_optional(&pdev->dev, "ahb");
-	if (IS_ERR(ss->reset)) {
-		if (PTR_ERR(ss->reset) == -EPROBE_DEFER)
-			return PTR_ERR(ss->reset);
+	if (IS_ERR(ss->reset))
+		return PTR_ERR(ss->reset);
+	if (!ss->reset)
 		dev_info(&pdev->dev, "no reset control found\n");
-		ss->reset = NULL;
-	}
 
 	/*
 	 * Check that clock have the correct rates given in the datasheet
-- 
2.29.2

