Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53B5AC19F5C
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:56:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376473AbjJTH4u (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376476AbjJTH4m (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:56:42 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2108F114
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:39 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN0-0003I6-4X; Fri, 20 Oct 2023 09:56:34 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkMz-002yUh-Ii; Fri, 20 Oct 2023 09:56:33 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkMz-002OIv-9V; Fri, 20 Oct 2023 09:56:33 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh@kernel.org>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 12/42] crypto: bcm/cipher - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:55:34 +0200
Message-ID: <20231020075521.2121571-56-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1774; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=grsiWToFgT6aQoiICp8JLE2vEIHkNwFngoCYVPgmLpg=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlMjJ3rwVHycQzpTPs6O7dSCJ74PKOpigSje2jE DW34UykAL2JATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZTIydwAKCRCPgPtYfRL+ TorZCACumE4O8oGA0K0qr8CjCoL6N5SVA2my3TmXdJZ63tzqaIW/B/zz9zIvUKJVQHjQ4E8qo73 0wZVXoAlj57im73vIdbBA7ueKQb2kdaSZKxBz8+FpXU9mEy5UFwZpfvGN6r+Pvl0pyKPL2xC7Al pw8f0YhiYmFSaPRoQR5yg7lMTtfQ6GpsNbUcyIguKeVKtdW2ebBcnhtlWzPIprsjRfP8D4r5OQu EcEmuw6KXov6NmBQIFtX1Izxr1sviDeAG5lkDnzzefXPTNh0T2askvf8hNwQgYMS79jXNA+0axJ ZN8z1MV/PfJXM5ZadLannYXlCGGDFV7RZzK/U4Zqp16Kc8eR
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
 drivers/crypto/bcm/cipher.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index 689be70d69c1..10968ddb146b 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -4713,7 +4713,7 @@ static int bcm_spu_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int bcm_spu_remove(struct platform_device *pdev)
+static void bcm_spu_remove(struct platform_device *pdev)
 {
 	int i;
 	struct device *dev = &pdev->dev;
@@ -4751,7 +4751,6 @@ static int bcm_spu_remove(struct platform_device *pdev)
 	}
 	spu_free_debugfs();
 	spu_mb_release(pdev);
-	return 0;
 }
 
 /* ===== Kernel Module API ===== */
@@ -4762,7 +4761,7 @@ static struct platform_driver bcm_spu_pdriver = {
 		   .of_match_table = of_match_ptr(bcm_spu_dt_ids),
 		   },
 	.probe = bcm_spu_probe,
-	.remove = bcm_spu_remove,
+	.remove_new = bcm_spu_remove,
 };
 module_platform_driver(bcm_spu_pdriver);
 
-- 
2.42.0

