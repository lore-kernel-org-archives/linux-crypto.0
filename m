Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B0E4C07480
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:56:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376472AbjJTH4z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376467AbjJTH4n (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:56:43 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFE4106
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:42 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN4-0003Tq-B7; Fri, 20 Oct 2023 09:56:38 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN3-002yVo-8G; Fri, 20 Oct 2023 09:56:37 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN2-002OK1-VP; Fri, 20 Oct 2023 09:56:36 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 29/42] crypto: omap-aes - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:55:51 +0200
Message-ID: <20231020075521.2121571-73-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1883; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=GKy4UtuJ6e6gFts6Mio5i90aXaN7ynJnTKASBctbdbs=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlMjKLdsXF/q9eHBxPHTnp52EtFzUFVr4FLpg7Z OUgTx2k+O2JATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZTIyiwAKCRCPgPtYfRL+ Tlj9CACGc7nSgwGQvGiiWoWFoVJqwKynGlf2xuChyVPdCam2bsQmssyCUSpA2fXw5elODXK9Gd+ WLJd6wTWQIc9PRCbzJrAnKW4KEmiopz9YAL4KV9RvV6ej0ng9nXa+r0MLkOltZvwXqqRqIaG8eH Xjzr7eRdtIqH3mR/DFAVqHcZzifMPk6jIFTHnT2AyAGZ8hrVEC9OUfZ/seJGOxc9iUv+F/sUO0/ R8AaekkED8axSUfyT+vsK346sC0EzTMKxpjoUla/mPxzvZKd7+CLv6zYYVwU/tDmVFY+N0D/RKk ge6cJRT7xOVC77NziC9A3nIvzxzMXPXLOHtTLXqYgGmUcT/r
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
 drivers/crypto/omap-aes.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index ed83023dd77a..bad1adacbc84 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -1255,7 +1255,7 @@ static int omap_aes_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int omap_aes_remove(struct platform_device *pdev)
+static void omap_aes_remove(struct platform_device *pdev)
 {
 	struct omap_aes_dev *dd = platform_get_drvdata(pdev);
 	struct aead_engine_alg *aalg;
@@ -1285,8 +1285,6 @@ static int omap_aes_remove(struct platform_device *pdev)
 	pm_runtime_disable(dd->dev);
 
 	sysfs_remove_group(&dd->dev->kobj, &omap_aes_attr_group);
-
-	return 0;
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -1307,7 +1305,7 @@ static SIMPLE_DEV_PM_OPS(omap_aes_pm_ops, omap_aes_suspend, omap_aes_resume);
 
 static struct platform_driver omap_aes_driver = {
 	.probe	= omap_aes_probe,
-	.remove	= omap_aes_remove,
+	.remove_new = omap_aes_remove,
 	.driver	= {
 		.name	= "omap-aes",
 		.pm	= &omap_aes_pm_ops,
-- 
2.42.0

