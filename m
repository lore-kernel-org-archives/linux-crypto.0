Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8A27C004C0
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:56:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376407AbjJTH4s (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376469AbjJTH4l (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:56:41 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85E9D6E
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:38 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN0-0003H0-7P; Fri, 20 Oct 2023 09:56:34 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkMz-002yUe-Bf; Fri, 20 Oct 2023 09:56:33 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkMz-002OIr-2L; Fri, 20 Oct 2023 09:56:33 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Jesper Nilsson <jesper.nilsson@axis.com>,
        Lars Persson <lars.persson@axis.com>,
        linux-arm-kernel@axis.com, linux-crypto@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH 11/42] crypto: axis/artpec6 - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:55:33 +0200
Message-ID: <20231020075521.2121571-55-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1866; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=A9UYMuzGRTiRfFrmuWK1VZNAdlqB7uazUzrs/y2kONU=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlMjJ2XUru5TuAhNgyQ9BJ3pMSIY3neVWMCTiM5 mOwZj0KqJOJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZTIydgAKCRCPgPtYfRL+ TnMnB/4itlTpse9ngMh3F/2o+x8ALU5Au8ndvV+ziW+Uik6hLdn2vuQ7StCtgkvDWdN3V+guLLp sKq0N2fmv/QdI+TMvc08Tt7XSjUii+dN4oY7APPsRlcaQcduR+xEIhkAjMpn8fWaVSllUbsLOIt gMBhGB1XwFsBojouMy7FNlQbhq/uONPjC1eUi7EdUfzEU9/6JjOku7w6UHkZwkM1IDJLT1uTHyd S7WTSvUMYGYONzbnX/qSn7ZCTE27iiZdm5k9ajwEtFVYl1eQPRMBeVFZsMNIB8wrqfCwYZInLYr ULxZYV6Rg5QCGTygWbg26Kk3xombHq0ijAAXay94jT3zX782
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
 drivers/crypto/axis/artpec6_crypto.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index 8493a45e1bd4..07996b6c3446 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -2957,7 +2957,7 @@ static int artpec6_crypto_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int artpec6_crypto_remove(struct platform_device *pdev)
+static void artpec6_crypto_remove(struct platform_device *pdev)
 {
 	struct artpec6_crypto *ac = platform_get_drvdata(pdev);
 	int irq = platform_get_irq(pdev, 0);
@@ -2977,12 +2977,11 @@ static int artpec6_crypto_remove(struct platform_device *pdev)
 #ifdef CONFIG_DEBUG_FS
 	artpec6_crypto_free_debugfs();
 #endif
-	return 0;
 }
 
 static struct platform_driver artpec6_crypto_driver = {
 	.probe   = artpec6_crypto_probe,
-	.remove  = artpec6_crypto_remove,
+	.remove_new = artpec6_crypto_remove,
 	.driver  = {
 		.name  = "artpec6-crypto",
 		.of_match_table = artpec6_crypto_of_match,
-- 
2.42.0

