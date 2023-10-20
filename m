Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9ADCC001DF
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:57:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376481AbjJTH5S (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376508AbjJTH45 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:56:57 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066CED7A
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:44 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN6-0003dM-Mo; Fri, 20 Oct 2023 09:56:40 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN4-002yWG-Pg; Fri, 20 Oct 2023 09:56:38 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN4-002OKX-Ga; Fri, 20 Oct 2023 09:56:38 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 36/42] crypto: sa2ul - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:55:58 +0200
Message-ID: <20231020075521.2121571-80-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1686; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=Aq3je/SuIFI0BUC/13Ds8/g4ZpAP1by27NY2YIFlN6Q=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlMjKTXY1jCFSa5bsS59e3knZYxtJ8qeIoRr195 BTcqfhshoCJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZTIykwAKCRCPgPtYfRL+ TjZsB/0QSrCYq9FWZarcHBDbAOZtbTKic7kNHj+liJ0TKBXoRj5HG4iHG9drMQvZB8LuXHrLhwF MZMGNJACtpBacQjQiAmr+awzGeEI+0xVZvNy//zFVgQaF1Id/raxyrzFInAuMFI5MZPCntZ2YjK vmR7Sf91+cbSw/BIoUJcEG5ev6ZXAWgk4ViS9WgOF9bXlxJyPPkb7A2l9PYsAWNNI9q3zqTHeIh oqca3DTdtH3NvrQgdw3PzCGvCDzLTK1VTCzmvcoJVBvsxzO2oX32zY4X/+fLV7LLrIxW28Ini/e wGdjxmV1AW2nEHNenxei7HzYJM5CrGXvFa71yM3vej7vYtAq
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
 drivers/crypto/sa2ul.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 6238d34f8db2..6846a8429574 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -2468,7 +2468,7 @@ static int sa_ul_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int sa_ul_remove(struct platform_device *pdev)
+static void sa_ul_remove(struct platform_device *pdev)
 {
 	struct sa_crypto_data *dev_data = platform_get_drvdata(pdev);
 
@@ -2486,13 +2486,11 @@ static int sa_ul_remove(struct platform_device *pdev)
 
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-
-	return 0;
 }
 
 static struct platform_driver sa_ul_driver = {
 	.probe = sa_ul_probe,
-	.remove = sa_ul_remove,
+	.remove_new = sa_ul_remove,
 	.driver = {
 		   .name = "saul-crypto",
 		   .of_match_table = of_match,
-- 
2.42.0

