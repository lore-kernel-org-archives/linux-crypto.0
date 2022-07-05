Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26146C433EF
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jul 2022 20:52:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbiGEUwH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Jul 2022 16:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiGEUwG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Jul 2022 16:52:06 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C2DB71
        for <linux-crypto@vger.kernel.org>; Tue,  5 Jul 2022 13:52:06 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1o8pWW-0000tW-FB; Tue, 05 Jul 2022 22:51:56 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1o8pWR-004dBA-UZ; Tue, 05 Jul 2022 22:51:55 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1o8pWU-003Drq-62; Tue, 05 Jul 2022 22:51:54 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de
Subject: [PATCH 2/7] crypto: atmel-sha: Drop if with an always false condition
Date:   Tue,  5 Jul 2022 22:51:39 +0200
Message-Id: <20220705205144.131702-2-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220705205144.131702-1-u.kleine-koenig@pengutronix.de>
References: <20220705205144.131702-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=892; h=from:subject; bh=d7L4zvTQDHK/JlvhWg+4pn1/ATIKhpfrE0igWZ2Db5E=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBixKRKGs4L1hAyl3D7MbPH2xw18selDU4s5YpSqKO2 QgoIF+yJATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCYsSkSgAKCRDB/BR4rcrsCeTaB/ 44S82O/5T9T+5ayajji8qYsbbaZ4CRgvFTaYzmQ/cD6NVfIOXr5Gii5UmZLSYsyjoPezpowZ0+Uodc F/JknWe3ejAFDVY7Gx/svTPltWctyk6xBrs5YdjQYReKtPtI0Dv/nBRpkl19q5frgHYjf9Po9cBZ8Z gxnlOnpKae0zV46MOjWpzVCQy721wrQf49jmCbgMPMYnfuXiLYomuT6N1J3ksQ+Da9g2IrdVfhB8/z pc/3WqhvI8ljK2MKFMcKnfjPt42o3NRcKv3rJCk31Wslw/x+e/0xl13cp30suP+vGh63HrPkl3X3zo U2hM3IeBmABYW4B3M8LtA3JzJ88KgZ
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The remove callback is only called after probe completed successfully.
In this case platform_set_drvdata() was called with a non-NULL argument
and so sha_dd is never NULL.

This is a preparation for making platform remove callbacks return void.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/crypto/atmel-sha.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index d1628112dacc..e054e0ac6fc2 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -2669,8 +2669,7 @@ static int atmel_sha_remove(struct platform_device *pdev)
 	struct atmel_sha_dev *sha_dd;
 
 	sha_dd = platform_get_drvdata(pdev);
-	if (!sha_dd)
-		return -ENODEV;
+
 	spin_lock(&atmel_sha.lock);
 	list_del(&sha_dd->list);
 	spin_unlock(&atmel_sha.lock);
-- 
2.36.1

