Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B09ECCDB474
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:56:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376474AbjJTH4o (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376466AbjJTH4l (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:56:41 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886A2D6C
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:38 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN0-0003JE-PO; Fri, 20 Oct 2023 09:56:34 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN0-002yUt-68; Fri, 20 Oct 2023 09:56:34 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkMz-002OJ7-TP; Fri, 20 Oct 2023 09:56:33 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 15/42] crypto: ccree/cc - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:55:37 +0200
Message-ID: <20231020075521.2121571-59-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1782; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=lejF1Bxw1Ws8DzMMotjuzFXNNQJMw121/Q+2EpVjQDA=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlMjJ7c43IbLjB7MZVAgapLEjLoYXSb8lH1ygZ2 dmMW5485+aJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZTIyewAKCRCPgPtYfRL+ Th1fB/wP9wWwCDsZVZAMTEXbbeZcUaxJYrdczFR5AxprEOdCbCEDWymqEBWZ4uGJsWs6GnQgZCH 8pSFKr/6O7p93H+KimqGqNFqPs/vBxDSS0JFsb9tfgfgwkTWKuL9n+GUZS6QcCQgfaWAGoz2lYg TI5kxCh37weuY4PbpemdiJFg3NE2vKdTia2d45TBNdIaGDmT3GlPDqzKno66g5YhCdSN3GKoPRD 3PJ/67vSQQPiT+FXstIY1OGQTSV9oe561SavpSNKXyFC1DvVLJhxB2u2JlciBU5k6thFvX9toSn NxCYPqvSAYT/ElGx04VqVs3UvSOycdmON4cgJLj9Ins7u9fc
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
 drivers/crypto/ccree/cc_driver.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index 0f0694037dd7..9177b54bb0f5 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -623,7 +623,7 @@ static int ccree_probe(struct platform_device *plat_dev)
 	return 0;
 }
 
-static int ccree_remove(struct platform_device *plat_dev)
+static void ccree_remove(struct platform_device *plat_dev)
 {
 	struct device *dev = &plat_dev->dev;
 
@@ -632,8 +632,6 @@ static int ccree_remove(struct platform_device *plat_dev)
 	cleanup_cc_resources(plat_dev);
 
 	dev_info(dev, "ARM ccree device terminated\n");
-
-	return 0;
 }
 
 static struct platform_driver ccree_driver = {
@@ -645,7 +643,7 @@ static struct platform_driver ccree_driver = {
 #endif
 	},
 	.probe = ccree_probe,
-	.remove = ccree_remove,
+	.remove_new = ccree_remove,
 };
 
 static int __init ccree_init(void)
-- 
2.42.0

