Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 108DAC001DF
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:56:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376433AbjJTH4k (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376476AbjJTH4j (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:56:39 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72333D68
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:37 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkMz-0003Fn-2Y; Fri, 20 Oct 2023 09:56:33 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkMx-002yUE-QB; Fri, 20 Oct 2023 09:56:31 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkMx-002OIK-Gu; Fri, 20 Oct 2023 09:56:31 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Yu Zhe <yuzhe@nfschina.com>, linux-crypto@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH 04/42] crypto: amcc/crypto4xx - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:55:26 +0200
Message-ID: <20231020075521.2121571-48-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1954; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=XNKWDSvqkqQLMcdxWv9U873dzDpPTq15dIN6KaQ2cHY=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlMjJu5xmxHmauusKwyLpMFSQ0vnMn8R8fFUNCD rqa5YotQiiJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZTIybgAKCRCPgPtYfRL+ Tob1B/42u8oqciAR0/yso+MPyVaAZrdJOyhHGrQ2PU2hJO6wHRuCzVZgXTDuPhesLmMiufw3ebg InATn4KnISdfS7IBWUKjN3QalGh0bwWYs6tVxUH1qJ8f7UcZ6O3CfbRZCqKKbcJfUBwzN2U8UkH fPWlhpKR3vIqU7W0TH/cmHblgaWq/Z8Vqrt7jrkL35SR5YRuLJKv/7F/7NfAwI2ObSE+qIWSxaf k73RCV5aNgkwzwmqM06pYj1oyrMjSFc75wbU5xqvKqwXWjHK2AuLx5zbYNAtXluzUZS0+lL8LbI 0eSBy5hG8OWwov5Y7x44YJyaxw9AkzbXPh2cbouQ7sHuN7dF
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
 drivers/crypto/amcc/crypto4xx_core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index d553f3f1efbe..8d53372245ad 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1507,7 +1507,7 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 	return rc;
 }
 
-static int crypto4xx_remove(struct platform_device *ofdev)
+static void crypto4xx_remove(struct platform_device *ofdev)
 {
 	struct device *dev = &ofdev->dev;
 	struct crypto4xx_core_device *core_dev = dev_get_drvdata(dev);
@@ -1523,8 +1523,6 @@ static int crypto4xx_remove(struct platform_device *ofdev)
 	mutex_destroy(&core_dev->rng_lock);
 	/* Free all allocated memory */
 	crypto4xx_stop_all(core_dev);
-
-	return 0;
 }
 
 static const struct of_device_id crypto4xx_match[] = {
@@ -1539,7 +1537,7 @@ static struct platform_driver crypto4xx_driver = {
 		.of_match_table = crypto4xx_match,
 	},
 	.probe		= crypto4xx_probe,
-	.remove		= crypto4xx_remove,
+	.remove_new	= crypto4xx_remove,
 };
 
 module_platform_driver(crypto4xx_driver);
-- 
2.42.0

