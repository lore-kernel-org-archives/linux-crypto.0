Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0538EC001DE
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jul 2023 08:08:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbjGZIIW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Jul 2023 04:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbjGZIHe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Jul 2023 04:07:34 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDCC730D7
        for <linux-crypto@vger.kernel.org>; Wed, 26 Jul 2023 00:59:48 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qOZQs-00061t-R5; Wed, 26 Jul 2023 09:59:42 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qOZQr-002BYz-0m; Wed, 26 Jul 2023 09:59:41 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qOZQp-007sRJ-Vl; Wed, 26 Jul 2023 09:59:39 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH] crypto: caam/jr - Convert to platform remove callback returning void
Date:   Wed, 26 Jul 2023 09:59:38 +0200
Message-Id: <20230726075938.448673-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=3348; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=NQC1IAtK5ynljTgAHm6y5tPdyrnjokGAndzNf8mbbbU=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkwNJpWdCswpin/KRi2YV8SWohKew6fst+tYOs/ sVZl3W4lLyJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZMDSaQAKCRCPgPtYfRL+ Tn5VB/0dCDg2nRAhey5ytJdXDRGiytLW1BmgKd4aKB85LMf7+5ndVyDIrhijAUVUBDLeK/vF+ak ly2oXQRUpjXwYcHWJSsU+PH+R+sIBNA9fBT3tkXdL5UjqIanwyi3Of+herH+aR5QULV6tRFG0bF ot/zURCOQ5NwLa7Sslse3XBgivUX2m9zJyF7RaNObT5dg9kvPN+Ovy0jeIzThczZIjdU0h2fFV5 ohwFAcYap3MBvKmP26Zh+q7WyOwGCAzuWREWmqjynPfKwKuFYBrSyihdjaIrzlftahAwyyknZuG ZJX4GGrAFYxKxnvSCumXwNngFcix58iaZL/B9DTynE/EEMMm
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
returning an error code. However the value returned is (mostly) ignored
and this typically results in resource leaks. To improve here there is a
quest to make the remove callback return void. In the first step of this
quest all drivers are converted to .remove_new() which already returns
void.

The driver adapted here suffers from this wrong assumption. Returning
-EBUSY if there are still users results in resource leaks and probably a
crash. Also further down passing the error code of caam_jr_shutdown() to
the caller only results in another error message and has no further
consequences compared to returning zero.

Still convert the driver to return no value in the remove callback. This
also allows to drop caam_jr_platform_shutdown() as the only function
called by it now has the same prototype.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

note that the problems described above and in the extended comment isn't
introduced by this patch. It's as old as
313ea293e9c4d1eabcaddd2c0800f083b03c2a2e at least.

Also orthogonal to this patch I wonder about the use of a shutdown
callback. What makes this driver special to require extra handling at
shutdown time?

Best regards
Uwe

 drivers/crypto/caam/jr.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 96dea5304d22..66b1eb3eb4a4 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -162,7 +162,7 @@ static int caam_jr_shutdown(struct device *dev)
 	return ret;
 }
 
-static int caam_jr_remove(struct platform_device *pdev)
+static void caam_jr_remove(struct platform_device *pdev)
 {
 	int ret;
 	struct device *jrdev;
@@ -175,11 +175,14 @@ static int caam_jr_remove(struct platform_device *pdev)
 		caam_rng_exit(jrdev->parent);
 
 	/*
-	 * Return EBUSY if job ring already allocated.
+	 * If a job ring is still allocated there is trouble ahead. Once
+	 * caam_jr_remove() returned, jrpriv will be freed and the registers
+	 * will get unmapped. So any user of such a job ring will probably
+	 * crash.
 	 */
 	if (atomic_read(&jrpriv->tfm_count)) {
-		dev_err(jrdev, "Device is busy\n");
-		return -EBUSY;
+		dev_warn(jrdev, "Device is busy, fasten your seat belts, a crash is ahead.\n");
+		return;
 	}
 
 	/* Unregister JR-based RNG & crypto algorithms */
@@ -194,13 +197,6 @@ static int caam_jr_remove(struct platform_device *pdev)
 	ret = caam_jr_shutdown(jrdev);
 	if (ret)
 		dev_err(jrdev, "Failed to shut down job ring\n");
-
-	return ret;
-}
-
-static void caam_jr_platform_shutdown(struct platform_device *pdev)
-{
-	caam_jr_remove(pdev);
 }
 
 /* Main per-ring interrupt handler */
@@ -657,8 +653,8 @@ static struct platform_driver caam_jr_driver = {
 		.of_match_table = caam_jr_match,
 	},
 	.probe       = caam_jr_probe,
-	.remove      = caam_jr_remove,
-	.shutdown    = caam_jr_platform_shutdown,
+	.remove_new  = caam_jr_remove,
+	.shutdown    = caam_jr_remove,
 };
 
 static int __init jr_driver_init(void)

base-commit: dd105461ad15ea930d88aec1e4fcfc1f3186da43
-- 
2.39.2

