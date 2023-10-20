Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E713C001DF
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:57:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376489AbjJTH47 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376494AbjJTH4r (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:56:47 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 235A9D61
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:43 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN4-0003Xi-TD; Fri, 20 Oct 2023 09:56:38 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN3-002yVu-NX; Fri, 20 Oct 2023 09:56:37 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN3-002OKE-EP; Fri, 20 Oct 2023 09:56:37 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 31/42] crypto: omap-sham - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:55:53 +0200
Message-ID: <20231020075521.2121571-75-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1743; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=eE5FmpD4VkhilJ2UozoC4CPBw/DQyfZFnxmpvFi/8GU=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlMjKNKHy7ORltp/8iBKZ/mUKFSlOQJoZ5gPMTu COQYTAgnBaJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZTIyjQAKCRCPgPtYfRL+ TiWIB/0UeEKpHSux8TLGIXhVVku6FatGM+0GXA9gTludVWbgEROfC9KXR0C8GJJ5uVOCYYiOdIh 99fp2kK1ycZC9B6GuvJjC26D98OMxTvrmqaB//Z2JCFk1i0oBpE4NKCJJgaVgPYkZ7CD3RG1Zkx kq2X36/v1DsVlm5jdBG+7ab57s17eonng31U7Co11RbUXo9eCiO4EEkav3w7PnRro0z7Zt3psH8 L3Dh3Gqx0n9EAYA6ZFmZ+v7qI99efcAvFdkUkMPmEd6rzYKCAteULniy9hkyLxqxGhF+9uep5Ny G7bs5h9vLO8T01E1pvMosZQRmhmPF8Tw0fkPAVLw2J3zENd5
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
 drivers/crypto/omap-sham.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index a6b4a0b3ace3..496602f7caa5 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -2200,7 +2200,7 @@ static int omap_sham_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int omap_sham_remove(struct platform_device *pdev)
+static void omap_sham_remove(struct platform_device *pdev)
 {
 	struct omap_sham_dev *dd;
 	int i, j;
@@ -2224,13 +2224,11 @@ static int omap_sham_remove(struct platform_device *pdev)
 		dma_release_channel(dd->dma_lch);
 
 	sysfs_remove_group(&dd->dev->kobj, &omap_sham_attr_group);
-
-	return 0;
 }
 
 static struct platform_driver omap_sham_driver = {
 	.probe	= omap_sham_probe,
-	.remove	= omap_sham_remove,
+	.remove_new = omap_sham_remove,
 	.driver	= {
 		.name	= "omap-sham",
 		.of_match_table	= omap_sham_of_match,
-- 
2.42.0

