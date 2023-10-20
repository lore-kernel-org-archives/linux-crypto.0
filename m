Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6C54C25B47
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:57:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376507AbjJTH5X (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376509AbjJTH45 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:56:57 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06752D7B
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:44 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN7-0003eq-0Z; Fri, 20 Oct 2023 09:56:41 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN5-002yWJ-0l; Fri, 20 Oct 2023 09:56:39 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN4-002OKc-Nc; Fri, 20 Oct 2023 09:56:38 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 37/42] crypto: sahara - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:55:59 +0200
Message-ID: <20231020075521.2121571-81-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1678; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=IasulRNGt6hUp9eOT/ON/572KWT+hDQFEcV0wFuffAc=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlMjKUy64U3nQiv6h6xRWyHVOOSC2vgjfTB2OVY vXLy3iUgxCJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZTIylAAKCRCPgPtYfRL+ TgV+B/4jhV2EAsqgPvffQYyILW5lSt+VH76/zkYYSP3B7hWmZ1hoip1kVp5VJZy/v/7JlZtZBMp VrsQZkQmOwvTz35RcM7bylL3N/X1Xlrn0stlPXkf8W4BTsm8O7VmCW8fyqfU+diVzyr8ZstwrSJ +tqJPpmcNh79Seg6LyToHnn51aTznc7HfcHSjickZuZlRt/EHuxngsReqTqeKw79udjo7ddGEXi irf9ZGWywaZbnTF+HO8QoyCBPiYRTLX6LjtgjTfJhi84rt9doU6ssiCTmQ/5jSrT6jpaXsM0M1g RETiSKZ6kYroZ8pPLqyRdWCaCWmDKFklxiXKX+8+mPY4xzYw
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
 drivers/crypto/sahara.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 62d93526920f..02065131c300 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1510,7 +1510,7 @@ static int sahara_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int sahara_remove(struct platform_device *pdev)
+static void sahara_remove(struct platform_device *pdev)
 {
 	struct sahara_dev *dev = platform_get_drvdata(pdev);
 
@@ -1522,13 +1522,11 @@ static int sahara_remove(struct platform_device *pdev)
 	clk_disable_unprepare(dev->clk_ahb);
 
 	dev_ptr = NULL;
-
-	return 0;
 }
 
 static struct platform_driver sahara_driver = {
 	.probe		= sahara_probe,
-	.remove		= sahara_remove,
+	.remove_new	= sahara_remove,
 	.driver		= {
 		.name	= SAHARA_NAME,
 		.of_match_table = sahara_dt_ids,
-- 
2.42.0

