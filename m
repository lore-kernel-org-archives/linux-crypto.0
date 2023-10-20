Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5537C25B40
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:57:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376508AbjJTH5X (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376514AbjJTH45 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:56:57 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83A3D7F
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:45 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN6-0003bJ-Ci; Fri, 20 Oct 2023 09:56:40 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN4-002yW5-DU; Fri, 20 Oct 2023 09:56:38 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN4-002OKQ-47; Fri, 20 Oct 2023 09:56:38 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Corentin Labbe <clabbe@baylibre.com>,
        Heiko Stuebner <heiko@sntech.de>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, kernel@pengutronix.de
Subject: [PATCH 34/42] crypto: rockchip/rk3288 - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:55:56 +0200
Message-ID: <20231020075521.2121571-78-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1829; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=OSkAhDdh6kSQDLklGjL3p61jBuTD2vuCyW1G0nBc6KE=; b=owGbwMvMwMXY3/A7olbonx/jabUkhlQjowm3z2mLOVfsj9qseDcuU47JZLU/S4rYGs64R1+3G QvX7/XvZDRmYWDkYpAVU2Sxb1yTaVUlF9m59t9lmEGsTCBTGLg4BWAi7IkcDA3aYiz6ce961hiE fnQ/rRpn3Lb+WmXem0wrEe6KRRwbQs6wbpH46aaR2xKqmeN94pPaf2Umz7PG6ip7rJNa5pcYz5M 7xBPF1OH1Lmk3P/+3MwIrjoZt0Jcsuyv0fsZ60Sl5KvuKJyy8Fv21cesv6/XXMi+aX5hXwZ03T3 TzAYPFHjsS55xZVR16NWn62RTXl0VRqW/lBZr4Km10Fx07rRV69NWVg46R/BpeC132+yrf+XVwe Wr93wPn2a16p1ckB5mrbqpsqK3IuBxkrdzYs7mqqvlhzq7jefVaKpcYahI6biUJ23L8LtloXjCx QTs/LPNT7Mrnq1quP0s2mprkPd3rd8p5NY2fTD/X81UDAA==
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
 drivers/crypto/rockchip/rk3288_crypto.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
index 77d5705a5d96..70edf40bc523 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.c
+++ b/drivers/crypto/rockchip/rk3288_crypto.c
@@ -405,7 +405,7 @@ static int rk_crypto_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int rk_crypto_remove(struct platform_device *pdev)
+static void rk_crypto_remove(struct platform_device *pdev)
 {
 	struct rk_crypto_info *crypto_tmp = platform_get_drvdata(pdev);
 	struct rk_crypto_info *first;
@@ -424,12 +424,11 @@ static int rk_crypto_remove(struct platform_device *pdev)
 	}
 	rk_crypto_pm_exit(crypto_tmp);
 	crypto_engine_exit(crypto_tmp->engine);
-	return 0;
 }
 
 static struct platform_driver crypto_driver = {
 	.probe		= rk_crypto_probe,
-	.remove		= rk_crypto_remove,
+	.remove_new	= rk_crypto_remove,
 	.driver		= {
 		.name	= "rk3288-crypto",
 		.pm		= &rk_crypto_pm_ops,
-- 
2.42.0

