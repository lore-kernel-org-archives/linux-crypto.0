Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B5EBC25B40
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:57:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376506AbjJTH5Q (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376467AbjJTH44 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:56:56 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDDBD78
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:44 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkMz-0003Fl-51; Fri, 20 Oct 2023 09:56:33 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkMx-002yU8-CR; Fri, 20 Oct 2023 09:56:31 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkMx-002OIB-2m; Fri, 20 Oct 2023 09:56:31 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Rob Herring <robh@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        kernel@pengutronix.de
Subject: [PATCH 02/42] crypto: sun8i-ce - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:55:24 +0200
Message-ID: <20231020075521.2121571-46-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1980; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=Nebr98eqKliQQ56zYutJMWfjNsqSFr+3DgpmezAGlLM=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlMjJsLYW/WVE4mQ+vP/7oGaDrKl3iOmW1VL2xM DRAxq7RrkSJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZTIybAAKCRCPgPtYfRL+ Tu8EB/9GcPBQm9ZA0Z6VwcX8Yih8NfcDa3cOoRj+2aPbM4aEgU3HfMq6TuH6eFMe7zGBCnZtPkM urQuwMQz4csmb8FTp/BxM1fbD9Z1JkrcPH3P7vUvxxJY31wpSKG6N4m4yD9miNkjWtQdRPjaxH4 E7+9vAuY8XnSrtr9YlKqgDULr+uNuj3CEdMdAqiXf/4VTaShVT6Sgr/JtxPjGkgVaL0YyRIgYe5 QlgfthIKrwvI/oDbzMFsbC5qfh4FvanHlyONzr7xuRqi0keJRDtMsfgzBZ9SoS9nzyewTljcBvz gYGNIk1TwSVmqRrfcBYkY8JkDEgGnGly266gKziD0XVpYglU
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
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index d4ccd5254280..1741758e03eb 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -1071,7 +1071,7 @@ static int sun8i_ce_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int sun8i_ce_remove(struct platform_device *pdev)
+static void sun8i_ce_remove(struct platform_device *pdev)
 {
 	struct sun8i_ce_dev *ce = platform_get_drvdata(pdev);
 
@@ -1088,7 +1088,6 @@ static int sun8i_ce_remove(struct platform_device *pdev)
 	sun8i_ce_free_chanlist(ce, MAXFLOW - 1);
 
 	sun8i_ce_pm_exit(ce);
-	return 0;
 }
 
 static const struct of_device_id sun8i_ce_crypto_of_match_table[] = {
@@ -1110,7 +1109,7 @@ MODULE_DEVICE_TABLE(of, sun8i_ce_crypto_of_match_table);
 
 static struct platform_driver sun8i_ce_driver = {
 	.probe		 = sun8i_ce_probe,
-	.remove		 = sun8i_ce_remove,
+	.remove_new	 = sun8i_ce_remove,
 	.driver		 = {
 		.name		= "sun8i-ce",
 		.pm		= &sun8i_ce_pm_ops,
-- 
2.42.0

