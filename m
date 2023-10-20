Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CC0BCDB47E
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:56:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376482AbjJTH4w (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376479AbjJTH4m (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:56:42 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0AD9D51
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:39 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN0-0003IY-J1; Fri, 20 Oct 2023 09:56:34 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkMz-002yUn-PH; Fri, 20 Oct 2023 09:56:33 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkMz-002OIz-G4; Fri, 20 Oct 2023 09:56:33 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     =?utf-8?q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 13/42] crypto: caam/jr - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:55:35 +0200
Message-ID: <20231020075521.2121571-57-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2921; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=qu9dDWFjqPcQnsiAS4jgPDl6gmnSq0j6ktjgMno2TbE=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlMjJ5pFMIl6dHUho0hbeN5kyGWnTaBBjOotTgJ imDRSeh9aSJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZTIyeQAKCRCPgPtYfRL+ TushB/9IRcXV5VTYIhfRSh7WUwCOQpYdoc7XrQ8EDKKUWpOVSyq1/iC691EmyHtR05lFQ0ZKUu/ LFTjeoJBMSFKfkSnIt5w8Z+pH8JRftgoKKqZbgK9t/WYgO1zIXSC3IHUZKAyIM63IVUWf7TlT4O Uj51KqB9JiKldbZq5cf2UUznQdbkFakpszHvNzbTRckJlBxx19Au0wYxHhPdJgKZSX/UrPT0jrg 7sQkfpHag6NyH2WvIwyCITgNpjuR0lJlrSEwSgAOjqeYeW4JqIwieg/3xsCjDL6wrjhkObJe6Be 8XRsByGIbY143XfoaT4jENQMMuNRQ3Iygcbumv6Zswcwdex9
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
 drivers/crypto/caam/jr.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index b1f1b393b98e..26eba7de3fb0 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -180,7 +180,7 @@ static int caam_jr_shutdown(struct device *dev)
 	return ret;
 }
 
-static int caam_jr_remove(struct platform_device *pdev)
+static void caam_jr_remove(struct platform_device *pdev)
 {
 	int ret;
 	struct device *jrdev;
@@ -193,11 +193,14 @@ static int caam_jr_remove(struct platform_device *pdev)
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
+		dev_alert(jrdev, "Device is busy; consumers might start to crash\n");
+		return;
 	}
 
 	/* Unregister JR-based RNG & crypto algorithms */
@@ -212,13 +215,6 @@ static int caam_jr_remove(struct platform_device *pdev)
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
@@ -823,8 +819,8 @@ static struct platform_driver caam_jr_driver = {
 		.pm = pm_ptr(&caam_jr_pm_ops),
 	},
 	.probe       = caam_jr_probe,
-	.remove      = caam_jr_remove,
-	.shutdown    = caam_jr_platform_shutdown,
+	.remove_new  = caam_jr_remove,
+	.shutdown    = caam_jr_remove,
 };
 
 static int __init jr_driver_init(void)
-- 
2.42.0

