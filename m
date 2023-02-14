Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3A0AC6379F
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Feb 2023 16:29:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjBNQ3C (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Feb 2023 11:29:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjBNQ3B (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Feb 2023 11:29:01 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B0DD222D4
        for <linux-crypto@vger.kernel.org>; Tue, 14 Feb 2023 08:28:55 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pRyAk-0007T2-CZ; Tue, 14 Feb 2023 17:28:50 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pRyAh-004v9Z-DH; Tue, 14 Feb 2023 17:28:48 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pRyAh-003WdR-I2; Tue, 14 Feb 2023 17:28:47 +0100
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Olivia Mackall <olivia@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 2/3] hwrng: xgene - Simplify using devm_clk_get_optional_enabled()
Date:   Tue, 14 Feb 2023 17:28:28 +0100
Message-Id: <20230214162829.113148-3-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230214162829.113148-1-u.kleine-koenig@pengutronix.de>
References: <20230214162829.113148-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=3077; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=Vz3yripQ3g4PiE359obAYzbKycP82MKb8z3KxYjldXo=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBj67aknU6qDqpESz/f84Lm2/tYIcKi/3MhsPQld jmVKgDt3rqJATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCY+u2pAAKCRDB/BR4rcrs CZYUB/4k5bxtW92/zBLgaUovrVwNfEXXSVl36024UgPceP6sczHoylIadQTZNOLlNboSDT8FBH/ xY1UjcpM25cCgp8SXC9VggLgNOiuIjOy0fLoNKe+L79nYGMVQT9GgYrIvSN3rx+ewsEyzUB6rdk 3EzpaV+mUgGtoCkZxWfeZG67oKhl07rqN5DbV9xKxMuuSivoIWp8p8t3Yr8kMbavKEPBxIWh3Br m6p7SnZkbPZTyl50xhvsxjw83ephZ/q2I3kVWpTeKuYKTCPscz2q3fCGVr5T7eLILfKIEUrimmv Q/nU2bV7xpHu7liM3XoM15HGnKtOJj5p/NCZgRJ3YzuikO0h
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of ignoring errors returned by devm_clk_get() and manually
enabling the clk for the whole lifetime of the bound device, use
devm_clk_get_optional_enabled(). This is simpler and also more correct
as it doesn't ignore errors. This is also more correct because now the
call to clk_disable_unprepare() can be dropped from xgene_rng_remove()
which happened while the hwrn device was still registered. With the devm
callback disabling the clk happens correctly only after
devm_hwrng_register() is undone.

As a result struct xgene_rng_dev::clk is only used in xgene_rng_probe, and
so the struct member can be replaced by a local variable.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/char/hw_random/xgene-rng.c | 27 ++++++---------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

diff --git a/drivers/char/hw_random/xgene-rng.c b/drivers/char/hw_random/xgene-rng.c
index a6a30686a58b..31662614a48f 100644
--- a/drivers/char/hw_random/xgene-rng.c
+++ b/drivers/char/hw_random/xgene-rng.c
@@ -84,7 +84,6 @@ struct xgene_rng_dev {
 	unsigned long failure_ts;/* First failure timestamp */
 	struct timer_list failure_timer;
 	struct device *dev;
-	struct clk *clk;
 };
 
 static void xgene_rng_expired_timer(struct timer_list *t)
@@ -314,6 +313,7 @@ static struct hwrng xgene_rng_func = {
 static int xgene_rng_probe(struct platform_device *pdev)
 {
 	struct xgene_rng_dev *ctx;
+	struct clk *clk;
 	int rc = 0;
 
 	ctx = devm_kzalloc(&pdev->dev, sizeof(*ctx), GFP_KERNEL);
@@ -341,45 +341,30 @@ static int xgene_rng_probe(struct platform_device *pdev)
 		return dev_err_probe(&pdev->dev, rc, "Could not request RNG alarm IRQ\n");
 
 	/* Enable IP clock */
-	ctx->clk = devm_clk_get(&pdev->dev, NULL);
-	if (IS_ERR(ctx->clk)) {
-		dev_warn(&pdev->dev, "Couldn't get the clock for RNG\n");
-	} else {
-		rc = clk_prepare_enable(ctx->clk);
-		if (rc)
-			return dev_err_probe(&pdev->dev, rc,
-					     "clock prepare enable failed for RNG");
-	}
+	clk = devm_clk_get_optional_enabled(&pdev->dev, NULL);
+	if (IS_ERR(clk))
+		return dev_err_probe(&pdev->dev, PTR_ERR(clk), "Couldn't get the clock for RNG\n");
 
 	xgene_rng_func.priv = (unsigned long) ctx;
 
 	rc = devm_hwrng_register(&pdev->dev, &xgene_rng_func);
-	if (rc) {
-		if (!IS_ERR(ctx->clk))
-			clk_disable_unprepare(ctx->clk);
+	if (rc)
 		return dev_err_probe(&pdev->dev, rc, "RNG registering failed\n");
-	}
 
 	rc = device_init_wakeup(&pdev->dev, 1);
-	if (rc) {
-		if (!IS_ERR(ctx->clk))
-			clk_disable_unprepare(ctx->clk);
+	if (rc)
 		return dev_err_probe(&pdev->dev, rc, "RNG device_init_wakeup failed\n");
-	}
 
 	return 0;
 }
 
 static int xgene_rng_remove(struct platform_device *pdev)
 {
-	struct xgene_rng_dev *ctx = platform_get_drvdata(pdev);
 	int rc;
 
 	rc = device_init_wakeup(&pdev->dev, 0);
 	if (rc)
 		dev_err(&pdev->dev, "RNG init wakeup failed error %d\n", rc);
-	if (!IS_ERR(ctx->clk))
-		clk_disable_unprepare(ctx->clk);
 
 	return rc;
 }
-- 
2.39.1

