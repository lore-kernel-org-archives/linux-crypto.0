Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9DF7EB64D9
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Jul 2023 07:08:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbjGGHIh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Jul 2023 03:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbjGGHIg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Jul 2023 03:08:36 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278F11BF4
        for <linux-crypto@vger.kernel.org>; Fri,  7 Jul 2023 00:08:36 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qHfZQ-0000Pt-Jq; Fri, 07 Jul 2023 09:08:00 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qHfZN-00CgDT-2h; Fri, 07 Jul 2023 09:07:57 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qHfZM-002weU-Ej; Fri, 07 Jul 2023 09:07:56 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Jia Jie Ho <jiajie.ho@starfivetech.com>,
        William Qiu <william.qiu@starfivetech.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH] crypto: starfive - Convert to platform remove callback returning void
Date:   Fri,  7 Jul 2023 09:07:53 +0200
Message-Id: <20230707070753.3393606-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2052; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=pXGqumi1enzh5iIuwvdO5AywTdmY3HhU1FQ5rWxS6RY=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkp7nI1sd4RZIHnvZa2m8OXf/N5HayOmuymXIuy yOOUwbD6uuJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZKe5yAAKCRCPgPtYfRL+ Tj0cB/48M/kMNHOgDlveMWDD663aHRSqeaWZaHtE/KX7Y8AIxWXh+8ulZTJUjg2PfY8hTuWcTPB +W3GvOQWT6ZQ62ZhCjmW9xBeLkiaeng/trw9oqkxdfaYYgApLwVzN/cEYzNoaMPjbqvU0zaZnD5 htFQk9iKqkWoT3ycN1eKRy8HDRP4VXXlRACdrwaeCU1H4+D8lPaVMtcQIbltJQYwbtC6c5HMIkU /HDryJtWhjjipi8035d5TvyNNxe/urOoj5TxLmvR4xLLO14gcMOzSgjpKjK12pp8+/mGqRne0KF ace6rwyaHKdO8UhZuhmnce2Pr6Vt7+E2W44JzaSqWCpZA78m
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
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
.remove_new() which already returns void. Eventually after all drivers
are converted, .remove_new() is renamed to .remove().

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/crypto/starfive/jh7110-cryp.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/starfive/jh7110-cryp.c b/drivers/crypto/starfive/jh7110-cryp.c
index cc43556b6c80..e573c097a4a0 100644
--- a/drivers/crypto/starfive/jh7110-cryp.c
+++ b/drivers/crypto/starfive/jh7110-cryp.c
@@ -212,7 +212,7 @@ static int starfive_cryp_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int starfive_cryp_remove(struct platform_device *pdev)
+static void starfive_cryp_remove(struct platform_device *pdev)
 {
 	struct starfive_cryp_dev *cryp = platform_get_drvdata(pdev);
 
@@ -233,8 +233,6 @@ static int starfive_cryp_remove(struct platform_device *pdev)
 	clk_disable_unprepare(cryp->hclk);
 	clk_disable_unprepare(cryp->ahb);
 	reset_control_assert(cryp->rst);
-
-	return 0;
 }
 
 static const struct of_device_id starfive_dt_ids[] __maybe_unused = {
@@ -245,7 +243,7 @@ MODULE_DEVICE_TABLE(of, starfive_dt_ids);
 
 static struct platform_driver starfive_cryp_driver = {
 	.probe  = starfive_cryp_probe,
-	.remove = starfive_cryp_remove,
+	.remove_new = starfive_cryp_remove,
 	.driver = {
 		.name           = DRIVER_NAME,
 		.of_match_table = starfive_dt_ids,

base-commit: 5133c9e51de41bfa902153888e11add3342ede18
-- 
2.39.2

