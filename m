Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D58D8CDB474
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:56:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376462AbjJTH4k (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376474AbjJTH4j (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:56:39 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 336E3D5D
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:36 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkMy-0003G2-E3; Fri, 20 Oct 2023 09:56:32 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkMy-002yUH-0m; Fri, 20 Oct 2023 09:56:32 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkMx-002OIN-NT; Fri, 20 Oct 2023 09:56:31 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Corentin Labbe <clabbe@baylibre.com>, linux-crypto@vger.kernel.org,
        linux-amlogic@lists.infradead.org, kernel@pengutronix.de
Subject: [PATCH 05/42] crypto: amlogic-gxl-core - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:55:27 +0200
Message-ID: <20231020075521.2121571-49-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1994; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=hXDLzoMA+y5An9CnasWFkoxWoOYFEvCz++Cfy0XuFYo=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlMjJvvN0Q7PlqJK6xoRBrUxyKtBnx/kra+bF0y 8Nd+QigtyKJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZTIybwAKCRCPgPtYfRL+ ThQvB/9o/uBuSUqapZmm9Aei5FfC51JaCF1TbLTRTnkO6/NKxrj7pB47dHjpvhmlrNROqxLA++b iJM4e/jqun7RAwFIocihBaMNdl4PodtEAX/WRN74KskqYsboHZJFC6uKKsc55BOesAJluYyxpL7 F46lHV9GT+8VKwmgbx+jt9qCRsmNs5UYsjyPTsZ2jmw7tvrKVr6Bu1gpOqrxTFqHJPKHiFvnfuu jV+zWdEpxJaYtBJwaX4g0v8XTUW2iLnA5nCMdS3hqiG9QyCpU8mopgqiRW4efBYh0XwUTNFkXL8 +IlI6+pLxpMKB1AaQU6b1Y5ENcS13cyg86yELKIr/xUswT/Y
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
 drivers/crypto/amlogic/amlogic-gxl-core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index da6dfe0f9ac3..f54ab0d0b1e8 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -299,7 +299,7 @@ static int meson_crypto_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int meson_crypto_remove(struct platform_device *pdev)
+static void meson_crypto_remove(struct platform_device *pdev)
 {
 	struct meson_dev *mc = platform_get_drvdata(pdev);
 
@@ -312,7 +312,6 @@ static int meson_crypto_remove(struct platform_device *pdev)
 	meson_free_chanlist(mc, MAXFLOW - 1);
 
 	clk_disable_unprepare(mc->busclk);
-	return 0;
 }
 
 static const struct of_device_id meson_crypto_of_match_table[] = {
@@ -323,7 +322,7 @@ MODULE_DEVICE_TABLE(of, meson_crypto_of_match_table);
 
 static struct platform_driver meson_crypto_driver = {
 	.probe		 = meson_crypto_probe,
-	.remove		 = meson_crypto_remove,
+	.remove_new	 = meson_crypto_remove,
 	.driver		 = {
 		.name		   = "gxl-crypto",
 		.of_match_table	= meson_crypto_of_match_table,
-- 
2.42.0

