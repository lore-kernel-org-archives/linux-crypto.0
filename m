Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49AE4C004C0
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:56:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376492AbjJTH45 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376489AbjJTH4p (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:56:45 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91FFF115
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:42 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN4-0003Wl-Jo; Fri, 20 Oct 2023 09:56:38 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN3-002yVr-GC; Fri, 20 Oct 2023 09:56:37 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN3-002OK5-7A; Fri, 20 Oct 2023 09:56:37 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 30/42] crypto: omap-des - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:55:52 +0200
Message-ID: <20231020075521.2121571-74-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1861; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=7jd/KTl/DuQ/eWYNI6pmYZCSZAZtYSaW3wam/creYY0=; b=owGbwMvMwMXY3/A7olbonx/jabUkhlQjox6ud9yeQksnXPHlcIwMt+BK+5Hpkn6yVSt7ZsQDv TVvcn52MhqzMDByMciKKbLYN67JtKqSi+xc++8yzCBWJpApDFycAjCRgh3sf/iWnpRXeFrVUd10 TVuUUX59iM9pEQ4JXWtF5l7v5xeuMZf366yS0d5Tt33N6efLe6ecfB8u/HrBNCudKUt+GeRW7ns 1a0+ofXxOnZbWz4uGXQIf2Q8FCBsrczJsPub21+kN31aFD4tP5L5VEXSdd+re/jhh+zi7JPf2nO oahbQ116eLnhWWNI7RnLd6ToNmr5n/zY67Ru7rVsrFVIS8ZLtuF61wgdXhtHf8bRbD24dubpsQO cGqerG9YWCJaXBU34rCabvPvL97SXHbvX/PBBg6zspefrZU+oqLX4ZEzqmMTMP9z2P1ZoRw271k UuLOdxKdNykzZr2P9/cfdT9+9kSmiH1gdH680lFh56RaAA==
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.

To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new(), which already returns void. Eventually after all drivers
are converted, .remove_new() will be renamed to .remove().

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/crypto/omap-des.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 089dd45eaedd..209d3dc03a9b 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -1072,7 +1072,7 @@ static int omap_des_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int omap_des_remove(struct platform_device *pdev)
+static void omap_des_remove(struct platform_device *pdev)
 {
 	struct omap_des_dev *dd = platform_get_drvdata(pdev);
 	int i, j;
@@ -1089,8 +1089,6 @@ static int omap_des_remove(struct platform_device *pdev)
 	tasklet_kill(&dd->done_task);
 	omap_des_dma_cleanup(dd);
 	pm_runtime_disable(dd->dev);
-
-	return 0;
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -1117,7 +1115,7 @@ static SIMPLE_DEV_PM_OPS(omap_des_pm_ops, omap_des_suspend, omap_des_resume);
 
 static struct platform_driver omap_des_driver = {
 	.probe	= omap_des_probe,
-	.remove	= omap_des_remove,
+	.remove_new = omap_des_remove,
 	.driver	= {
 		.name	= "omap-des",
 		.pm	= &omap_des_pm_ops,
-- 
2.42.0

