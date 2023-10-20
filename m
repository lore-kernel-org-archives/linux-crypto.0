Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10D1CCDB47E
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:56:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376465AbjJTH4r (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376471AbjJTH4l (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:56:41 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192A4106
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:39 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN1-0003Je-2V; Fri, 20 Oct 2023 09:56:35 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN0-002yV1-LW; Fri, 20 Oct 2023 09:56:34 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN0-002OJF-C7; Fri, 20 Oct 2023 09:56:34 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Corentin Labbe <clabbe@baylibre.com>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH 17/42] crypto: gemini/sl3516-ce - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:55:39 +0200
Message-ID: <20231020075521.2121571-61-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1961; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=cXvwJBMSSvZhSYD9MgdQ+cRHZ7jrelKO3QFjEobXMJo=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlMjJ9nvUOgoLCk56fdwyR2BZYS0yfJPIGl4Cn1 tYTGUJzl0uJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZTIyfQAKCRCPgPtYfRL+ ToJACACmuQL+2F6OmzmzLgErfAu4Op4CwkMav8JTjBmlcMytcbXNWIEqLmiIWnotYuWJdg0n957 CReZ6D1nqu+DiLxFANS/1CN4cFn+6Ay3lToX67aYnWpMFvAubQMHkPS/oXgrC8/9TFWt0oEgX/c FRm2neaPsPwMeMIyj864BZIK6TfXenWQOH9HOB18ZjjSBCtPmN2w3lEDj3xi8dLoUvm7RSMYpiU Qygi7oTXu0nvIVlgwXSXRPh//D+ylX4+UJV4vgmlwnf942nxNx6N9zreWWAoHMjR+5YiGzfS3xw zsqFS0WzlWV/hDd5K+GmrTODrpMvg82mi838pUItUzgPpTZW
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
 drivers/crypto/gemini/sl3516-ce-core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/gemini/sl3516-ce-core.c b/drivers/crypto/gemini/sl3516-ce-core.c
index 0f43c6e39bb9..1d1a889599bb 100644
--- a/drivers/crypto/gemini/sl3516-ce-core.c
+++ b/drivers/crypto/gemini/sl3516-ce-core.c
@@ -505,7 +505,7 @@ static int sl3516_ce_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int sl3516_ce_remove(struct platform_device *pdev)
+static void sl3516_ce_remove(struct platform_device *pdev)
 {
 	struct sl3516_ce_dev *ce = platform_get_drvdata(pdev);
 
@@ -518,8 +518,6 @@ static int sl3516_ce_remove(struct platform_device *pdev)
 #ifdef CONFIG_CRYPTO_DEV_SL3516_DEBUG
 	debugfs_remove_recursive(ce->dbgfs_dir);
 #endif
-
-	return 0;
 }
 
 static const struct of_device_id sl3516_ce_crypto_of_match_table[] = {
@@ -530,7 +528,7 @@ MODULE_DEVICE_TABLE(of, sl3516_ce_crypto_of_match_table);
 
 static struct platform_driver sl3516_ce_driver = {
 	.probe		 = sl3516_ce_probe,
-	.remove		 = sl3516_ce_remove,
+	.remove_new	 = sl3516_ce_remove,
 	.driver		 = {
 		.name		= "sl3516-crypto",
 		.pm		= &sl3516_ce_pm_ops,
-- 
2.42.0

