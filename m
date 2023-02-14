Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BDBCC05027
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Feb 2023 16:29:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjBNQ3D (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Feb 2023 11:29:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbjBNQ3B (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Feb 2023 11:29:01 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D5B5B9F
        for <linux-crypto@vger.kernel.org>; Tue, 14 Feb 2023 08:28:55 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pRyAk-0007T1-CZ; Tue, 14 Feb 2023 17:28:50 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pRyAh-004v9W-A1; Tue, 14 Feb 2023 17:28:48 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pRyAh-003WdO-C5; Tue, 14 Feb 2023 17:28:47 +0100
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Olivia Mackall <olivia@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 1/3] hwrng: xgene - Simplify using dev_err_probe()
Date:   Tue, 14 Feb 2023 17:28:27 +0100
Message-Id: <20230214162829.113148-2-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230214162829.113148-1-u.kleine-koenig@pengutronix.de>
References: <20230214162829.113148-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2260; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=5rPibkTxgwk9CqlfvS5PEBSxCYiLpBJ60L3YMoK8eqE=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBj67ahOPmTyyVKxLd3FqyXP2vSwhjMUWov8sCtV IftREIs/pKJATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCY+u2oQAKCRDB/BR4rcrs CaCxB/9ysP09c2OzJhBi1iqJQO2uvNorgQ1aL2JqoukUjfsfNFVCq+1b8gSJNoW6F66JC7wU+HJ 5c3CheBZmul+U/U5pbQHgHbJAGoayHZjWH+5NXFi2LGzyew6jfiXV1cgoBaDVON3wWIg6dSADP+ 3E1jNm+Nl8OAPGicFKiQmtmwVDxb1Xz3wg8jibqlo1rn0rjQk8OjgpnlsBL9GubRvjUpxRpthUb Iy6nA2j84DdG3TC+5ptY6BXTwmqC1+WW0njvY+dq/mYKUWKlFAj9+LgwpP4mMz67/2FUEE6OgOx NPcFzjSsyZrfQphRG5qw89GK3/jDbdtnfuqFAt6sdJgPooqC
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

dev_err_probe simplifies the idiom:

	if (ret != -EPROBE_DEFER)
		dev_err(...)
	return ret;

, emits the error code in a human readable way and even yields a useful
entry in /sys/kernel/debug/devices_deferred in the EPROBE_DEFER case.

So simplify and at the same time improve the driver by using
dev_err_probe().

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/char/hw_random/xgene-rng.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/char/hw_random/xgene-rng.c b/drivers/char/hw_random/xgene-rng.c
index 008e6db9ce01..a6a30686a58b 100644
--- a/drivers/char/hw_random/xgene-rng.c
+++ b/drivers/char/hw_random/xgene-rng.c
@@ -337,10 +337,8 @@ static int xgene_rng_probe(struct platform_device *pdev)
 
 	rc = devm_request_irq(&pdev->dev, ctx->irq, xgene_rng_irq_handler, 0,
 				dev_name(&pdev->dev), ctx);
-	if (rc) {
-		dev_err(&pdev->dev, "Could not request RNG alarm IRQ\n");
-		return rc;
-	}
+	if (rc)
+		return dev_err_probe(&pdev->dev, rc, "Could not request RNG alarm IRQ\n");
 
 	/* Enable IP clock */
 	ctx->clk = devm_clk_get(&pdev->dev, NULL);
@@ -348,30 +346,25 @@ static int xgene_rng_probe(struct platform_device *pdev)
 		dev_warn(&pdev->dev, "Couldn't get the clock for RNG\n");
 	} else {
 		rc = clk_prepare_enable(ctx->clk);
-		if (rc) {
-			dev_warn(&pdev->dev,
-				 "clock prepare enable failed for RNG");
-			return rc;
-		}
+		if (rc)
+			return dev_err_probe(&pdev->dev, rc,
+					     "clock prepare enable failed for RNG");
 	}
 
 	xgene_rng_func.priv = (unsigned long) ctx;
 
 	rc = devm_hwrng_register(&pdev->dev, &xgene_rng_func);
 	if (rc) {
-		dev_err(&pdev->dev, "RNG registering failed error %d\n", rc);
 		if (!IS_ERR(ctx->clk))
 			clk_disable_unprepare(ctx->clk);
-		return rc;
+		return dev_err_probe(&pdev->dev, rc, "RNG registering failed\n");
 	}
 
 	rc = device_init_wakeup(&pdev->dev, 1);
 	if (rc) {
-		dev_err(&pdev->dev, "RNG device_init_wakeup failed error %d\n",
-			rc);
 		if (!IS_ERR(ctx->clk))
 			clk_disable_unprepare(ctx->clk);
-		return rc;
+		return dev_err_probe(&pdev->dev, rc, "RNG device_init_wakeup failed\n");
 	}
 
 	return 0;
-- 
2.39.1

