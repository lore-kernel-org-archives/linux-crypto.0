Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E94DCDB474
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:56:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376463AbjJTH4y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376472AbjJTH4n (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:56:43 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 206E2D6A
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:42 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN4-0003SF-9o; Fri, 20 Oct 2023 09:56:38 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN3-002yVk-1k; Fri, 20 Oct 2023 09:56:37 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN2-002OJx-Ou; Fri, 20 Oct 2023 09:56:36 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 28/42] crypto: n2_core - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:55:50 +0200
Message-ID: <20231020075521.2121571-72-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2526; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=T4Bo9aTX+eT4XZxS9Uehb5DGE6qoa9vfLkG/lQm8P1E=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlMjKKp+r8wGWeqt4VxnCEQ9YZACBc7wPHtBPkm kRXZyTwAs6JATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZTIyigAKCRCPgPtYfRL+ TvgbCACSH5chw0ZKkC5YttaWCAz0z59H0nBEzc3DIYKZIwiWniZ05ijUkV9nMcd/oFBbdHuvOCF W7xAhlFdBHu4d79xUI6UxPiYJeF7Qcz3bN80LxZ+w6n82xsPwDcnaBXyPpHzC9T9iS/uuASxH6M 0SH+/XHcXUkBB/GWC59LGZ+/0AL/O+AhX1sZKHeJm6X3Q9GGZAlhTnH8ygH4Je+Egyj+659E6QT iKctioi0qMeQ1C/F3TaWCZrfhid9U65wxW0seOoJVYy14TZJHgAIl3k/KwdpvaZrC7h90des3+e //lnphFKS/TTI8kS2hVD1vnmxFIym58Urigf1RcEvt4IEavY
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
 drivers/crypto/n2_core.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index d5a32d71a3e9..caea98622c33 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -2011,7 +2011,7 @@ static int n2_crypto_probe(struct platform_device *dev)
 	return err;
 }
 
-static int n2_crypto_remove(struct platform_device *dev)
+static void n2_crypto_remove(struct platform_device *dev)
 {
 	struct n2_crypto *np = dev_get_drvdata(&dev->dev);
 
@@ -2022,8 +2022,6 @@ static int n2_crypto_remove(struct platform_device *dev)
 	release_global_resources();
 
 	free_n2cp(np);
-
-	return 0;
 }
 
 static struct n2_mau *alloc_ncp(void)
@@ -2109,7 +2107,7 @@ static int n2_mau_probe(struct platform_device *dev)
 	return err;
 }
 
-static int n2_mau_remove(struct platform_device *dev)
+static void n2_mau_remove(struct platform_device *dev)
 {
 	struct n2_mau *mp = dev_get_drvdata(&dev->dev);
 
@@ -2118,8 +2116,6 @@ static int n2_mau_remove(struct platform_device *dev)
 	release_global_resources();
 
 	free_ncp(mp);
-
-	return 0;
 }
 
 static const struct of_device_id n2_crypto_match[] = {
@@ -2146,7 +2142,7 @@ static struct platform_driver n2_crypto_driver = {
 		.of_match_table	=	n2_crypto_match,
 	},
 	.probe		=	n2_crypto_probe,
-	.remove		=	n2_crypto_remove,
+	.remove_new	=	n2_crypto_remove,
 };
 
 static const struct of_device_id n2_mau_match[] = {
@@ -2173,7 +2169,7 @@ static struct platform_driver n2_mau_driver = {
 		.of_match_table	=	n2_mau_match,
 	},
 	.probe		=	n2_mau_probe,
-	.remove		=	n2_mau_remove,
+	.remove_new	=	n2_mau_remove,
 };
 
 static struct platform_driver * const drivers[] = {
-- 
2.42.0

