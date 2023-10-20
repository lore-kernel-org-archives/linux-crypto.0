Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1F71C07480
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:57:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376533AbjJTH5y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376536AbjJTH5P (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:57:15 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767EE10D9
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:51 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN1-0003GE-QF; Fri, 20 Oct 2023 09:56:35 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkMy-002yUN-Gw; Fri, 20 Oct 2023 09:56:32 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkMy-002OIb-7Y; Fri, 20 Oct 2023 09:56:32 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Neal Liu <neal_liu@aspeedtech.com>, Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@codeconstruct.com.au>,
        linux-aspeed@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: [PATCH 07/42] crypto: aspeed-hace - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:55:29 +0200
Message-ID: <20231020075521.2121571-51-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1955; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=0YO0s5LXreauqMFpfEjyAZpLsQgNKr0gbAnyprV3vAo=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlMjJy3jnWIJF75wjEniVJf9lztk78hAUfW7ZhN wOsZS/iKt2JATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZTIycgAKCRCPgPtYfRL+ Ttg/CACG4iqbhG0quRs93JEgKLuQwHqCW3hwSPjBvbphXpp5VtHjN27w/YXL5Np2WoPUPNrVgmw hWLzG5LoZss8FnMu+acBo3Oii3QiqUEkSKilvJntZ0/QawkFoila0LMskRLAuP4yR7IdWqwBm4Y oILFwfy3jJOBMv6pHH4aF0H+4DBYRFYehXHwDtL9Z9bHNqn80SCQKYYhNYpH/FS8zqTrMfeIrPz KEQAkkcx7HcdAsnMF7LRMeoHVp2gEoxl0cD4T1+7J+mu6+yuIVgBC0KzFPtUBqqxNIUlWvovSwe HkQCQbp21lnyB0DNzw5OSg5BQ1vlwbBDeVRzsbUABsSTx5Bj
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
 drivers/crypto/aspeed/aspeed-hace.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/aspeed/aspeed-hace.c b/drivers/crypto/aspeed/aspeed-hace.c
index d9da04fb816e..062f2a66dd23 100644
--- a/drivers/crypto/aspeed/aspeed-hace.c
+++ b/drivers/crypto/aspeed/aspeed-hace.c
@@ -245,7 +245,7 @@ static int aspeed_hace_probe(struct platform_device *pdev)
 	return rc;
 }
 
-static int aspeed_hace_remove(struct platform_device *pdev)
+static void aspeed_hace_remove(struct platform_device *pdev)
 {
 	struct aspeed_hace_dev *hace_dev = platform_get_drvdata(pdev);
 	struct aspeed_engine_crypto *crypto_engine = &hace_dev->crypto_engine;
@@ -260,15 +260,13 @@ static int aspeed_hace_remove(struct platform_device *pdev)
 	tasklet_kill(&crypto_engine->done_task);
 
 	clk_disable_unprepare(hace_dev->clk);
-
-	return 0;
 }
 
 MODULE_DEVICE_TABLE(of, aspeed_hace_of_matches);
 
 static struct platform_driver aspeed_hace_driver = {
 	.probe		= aspeed_hace_probe,
-	.remove		= aspeed_hace_remove,
+	.remove_new	= aspeed_hace_remove,
 	.driver         = {
 		.name   = KBUILD_MODNAME,
 		.of_match_table = aspeed_hace_of_matches,
-- 
2.42.0

