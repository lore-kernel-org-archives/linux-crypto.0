Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7C11C001DF
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:56:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376476AbjJTH4v (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376483AbjJTH4m (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:56:42 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A093D115
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:39 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN1-0003Lm-TP; Fri, 20 Oct 2023 09:56:35 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN1-002yVH-GX; Fri, 20 Oct 2023 09:56:35 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN1-002OJV-7V; Fri, 20 Oct 2023 09:56:35 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Antoine Tenart <atenart@kernel.org>, linux-crypto@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH 21/42] crypto: inside-secure/safexcel - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:55:43 +0200
Message-ID: <20231020075521.2121571-65-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1990; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=kCiuHZVacrweSH3xcJRi29kZifyuONrttcMgh3aOsKE=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlMjKCgS/5r2l6PZCfzMfnrVkqyEDWL6eP4CyZ5 ZCzhJ4UorCJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZTIyggAKCRCPgPtYfRL+ Tp6MCAC37DMAx/xOb9sIzzeKkIztY5w2201ihTSVZTFv5G888xllwboRoeMgXkHfiD/be/9qu2p dMVu2Jyr0otiaAOGwgoYia/tbUMypHSJ85/fU2QZW3xNVfFyjB427kkfvMzfekLBjmd6P8BX26A iG6ZOAvR509TkWzmIfHAC+JyTE4vJQAnN/LZBECP2NHg8tivbxMZweilmOAce1VQfpuLnZ68MOt FouuaLW77aSzCFNj6NkptjDnbSmUWwQbT4MTBhdmPGmYbL+fIg2o7FKalAlJ4hSiIL7TnPbeGFs unjqenQkHqRsw0D5NmliZw6lWyYgBaH1/TZ1ICfrC5ySgSPx
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
 drivers/crypto/inside-secure/safexcel.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 9ff02b5abc4a..76da14af74b5 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1801,7 +1801,7 @@ static int safexcel_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int safexcel_remove(struct platform_device *pdev)
+static void safexcel_remove(struct platform_device *pdev)
 {
 	struct safexcel_crypto_priv *priv = platform_get_drvdata(pdev);
 	int i;
@@ -1816,8 +1816,6 @@ static int safexcel_remove(struct platform_device *pdev)
 		irq_set_affinity_hint(priv->ring[i].irq, NULL);
 		destroy_workqueue(priv->ring[i].workqueue);
 	}
-
-	return 0;
 }
 
 static const struct safexcel_priv_data eip97ies_mrvl_data = {
@@ -1874,7 +1872,7 @@ MODULE_DEVICE_TABLE(of, safexcel_of_match_table);
 
 static struct platform_driver  crypto_safexcel = {
 	.probe		= safexcel_probe,
-	.remove		= safexcel_remove,
+	.remove_new	= safexcel_remove,
 	.driver		= {
 		.name	= "crypto-safexcel",
 		.of_match_table = safexcel_of_match_table,
-- 
2.42.0

