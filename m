Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40B95C001DF
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:57:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376537AbjJTH5x (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376535AbjJTH5O (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:57:14 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1551B10D8
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:51 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN1-0003GA-QE; Fri, 20 Oct 2023 09:56:35 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkMy-002yUK-8R; Fri, 20 Oct 2023 09:56:32 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkMx-002OIS-V6; Fri, 20 Oct 2023 09:56:31 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Neal Liu <neal_liu@aspeedtech.com>, Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@codeconstruct.com.au>,
        linux-aspeed@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: [PATCH 06/42] crypto: aspeed-acry - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:55:28 +0200
Message-ID: <20231020075521.2121571-50-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1920; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=54Ov1wDXU3uWdC2nv6ZV9WOkI/eETqggVxDYU5WHQUI=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlMjJwuPF2/dtX0EWI11lNIxKHUdyZpTjmxblJa OoyE3K9YGuJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZTIycAAKCRCPgPtYfRL+ TjFXB/9s890zmNZddoqEknLAT6f8vBqFGRsKwmrh8nmgWbqnCPGyjgBSCQXmGlBcjCpXpffTGIB G6nzkPrlnNgJrDyfIkwvE9/f+o3UDW+6ZG24Hb3R6EMx/VB/hqd01NIHL62KOB+HIWIMPa8p7gA xcsvni3f0bUqL0julx0F3hYyX1UNBT8n4usY8wrC/TCL7tzwVmIO0mnkvIvwGTvn0N3FySsu2wZ HSg2Zy4X4kMmuhpSh3Yxw2W9wR9SaG3z8hMgG1FOrydkC4FZ34TNKBL3U34qrpRUn8TvjCIecYb aWZ5/CBuh521VBdzssPXGoI9nox8jac2KYnnyL3E9fo7o9or
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
 drivers/crypto/aspeed/aspeed-acry.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/aspeed/aspeed-acry.c b/drivers/crypto/aspeed/aspeed-acry.c
index 247c568aa8df..b4613bd4ad96 100644
--- a/drivers/crypto/aspeed/aspeed-acry.c
+++ b/drivers/crypto/aspeed/aspeed-acry.c
@@ -794,7 +794,7 @@ static int aspeed_acry_probe(struct platform_device *pdev)
 	return rc;
 }
 
-static int aspeed_acry_remove(struct platform_device *pdev)
+static void aspeed_acry_remove(struct platform_device *pdev)
 {
 	struct aspeed_acry_dev *acry_dev = platform_get_drvdata(pdev);
 
@@ -802,15 +802,13 @@ static int aspeed_acry_remove(struct platform_device *pdev)
 	crypto_engine_exit(acry_dev->crypt_engine_rsa);
 	tasklet_kill(&acry_dev->done_task);
 	clk_disable_unprepare(acry_dev->clk);
-
-	return 0;
 }
 
 MODULE_DEVICE_TABLE(of, aspeed_acry_of_matches);
 
 static struct platform_driver aspeed_acry_driver = {
 	.probe		= aspeed_acry_probe,
-	.remove		= aspeed_acry_remove,
+	.remove_new	= aspeed_acry_remove,
 	.driver		= {
 		.name   = KBUILD_MODNAME,
 		.of_match_table = aspeed_acry_of_matches,
-- 
2.42.0

