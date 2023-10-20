Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1E9AC07480
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:56:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376464AbjJTH4s (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376473AbjJTH4m (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:56:42 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8668FD55
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:38 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN1-0003LG-LY; Fri, 20 Oct 2023 09:56:35 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN1-002yVE-8y; Fri, 20 Oct 2023 09:56:35 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN0-002OJR-WC; Fri, 20 Oct 2023 09:56:35 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 20/42] crypto: img-hash - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:55:42 +0200
Message-ID: <20231020075521.2121571-64-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1804; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=XOlhP2cUnDue0y/xguD/NrllsbeYPsRQcuUgKsHTF74=; b=owGbwMvMwMXY3/A7olbonx/jabUkhlQjo4bbZ/kuG/P97Iuxnnx7jZffq2lrtxzPjp3MrBsTn 9sqlNLYyWjMwsDIxSArpshi37gm06pKLrJz7b/LMINYmUCmMHBxCsCNdmb/7/U7+5mR1kkR/oyL 4YV6W75Kzg3/vkzO6aXS4ft7Th3j3nDSf/mOaDO9m//PTL23dX1rn9EL+70pAUZzVvez1zn+uq/ cref09PevNM4t0SvT/HVyas4dN1x+zqHx1DXJ7G9109bHF0f3ZT+5c+CxlPTO8IfS+8NeZXrETt 1X8EmEOzE2qah6S9SrGm+hwx8LG5d57PKOb9eOb/mxxtS83XG6zaccnW5tnqzT3i6HL845oh4S8 i8pVy9ceXpWwuLyHeIK37wDNxWuqDjNpyN4aebK3Nd50f7bHMW2eTBpqcfrFcXtvt2xP4/PXnRW 3CFNUUMD5sVnxGcI8y3ImmIyb9bsa81edrwts+ssp94FAA==
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
 drivers/crypto/img-hash.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index 45063693859c..d269036bdaa3 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -1043,7 +1043,7 @@ static int img_hash_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int img_hash_remove(struct platform_device *pdev)
+static void img_hash_remove(struct platform_device *pdev)
 {
 	struct img_hash_dev *hdev;
 
@@ -1061,8 +1061,6 @@ static int img_hash_remove(struct platform_device *pdev)
 
 	clk_disable_unprepare(hdev->hash_clk);
 	clk_disable_unprepare(hdev->sys_clk);
-
-	return 0;
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -1101,7 +1099,7 @@ static const struct dev_pm_ops img_hash_pm_ops = {
 
 static struct platform_driver img_hash_driver = {
 	.probe		= img_hash_probe,
-	.remove		= img_hash_remove,
+	.remove_new	= img_hash_remove,
 	.driver		= {
 		.name	= "img-hash-accelerator",
 		.pm	= &img_hash_pm_ops,
-- 
2.42.0

