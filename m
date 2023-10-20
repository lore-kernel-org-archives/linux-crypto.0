Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FA0CC001DF
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:56:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376466AbjJTH4q (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376465AbjJTH4l (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:56:41 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88391D6B
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:37 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkMz-0003Gr-IJ; Fri, 20 Oct 2023 09:56:33 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkMz-002yUX-5Q; Fri, 20 Oct 2023 09:56:33 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkMy-002OIn-SK; Fri, 20 Oct 2023 09:56:32 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@tuxon.dev>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de
Subject: [PATCH 10/42] crypto: atmel-tdes - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:55:32 +0200
Message-ID: <20231020075521.2121571-54-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1758; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=t+zZKF/41Pj8NMywr8APo/EkmnfD4TbA5Py4GmYqBb0=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlMjJ1UaIojh+TPeL0s6oCgZLQXSnzxlS5/leo5 9crqTgUZRiJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZTIydQAKCRCPgPtYfRL+ Tu0UB/9woJisdyYJBaNEYFOvHk+plPkoaERjrwAgYCgfR66po9nEO6WEfjW/KsPzb9bzv1qPhxE 5c/9j5TIgoMTL/pb+mJoaKAUwEapFYRBjjEX8YJFc7aUPgjq/Eei7XrruH5cyhDLaKlmMGzKZCd q1XuUmzJSNFAwWmDOzlLfijEvYQSJgvxe8glmA7C1Tw5ButatJGndx08FXn0G9OBPJfzUAOho2r 2k3ml3n4SK5u+bhnUrdVgF99Ldsimv250W5/haTEWFo719x04tkh1RtfBzrmKG3EDXH8IiUpsaC hvSHhdc10DUD0g+JxS2qQZAzZGw6fOQ1et1+vS4H1wQLESVo
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
 drivers/crypto/atmel-tdes.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 099b32a10dd7..27b7000e25bc 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -1246,7 +1246,7 @@ static int atmel_tdes_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int atmel_tdes_remove(struct platform_device *pdev)
+static void atmel_tdes_remove(struct platform_device *pdev)
 {
 	struct atmel_tdes_dev *tdes_dd = platform_get_drvdata(pdev);
 
@@ -1263,13 +1263,11 @@ static int atmel_tdes_remove(struct platform_device *pdev)
 		atmel_tdes_dma_cleanup(tdes_dd);
 
 	atmel_tdes_buff_cleanup(tdes_dd);
-
-	return 0;
 }
 
 static struct platform_driver atmel_tdes_driver = {
 	.probe		= atmel_tdes_probe,
-	.remove		= atmel_tdes_remove,
+	.remove_new	= atmel_tdes_remove,
 	.driver		= {
 		.name	= "atmel_tdes",
 		.of_match_table = atmel_tdes_dt_ids,
-- 
2.42.0

