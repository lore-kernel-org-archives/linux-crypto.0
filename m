Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5095BC07480
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:57:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376505AbjJTH5Q (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376483AbjJTH44 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:56:56 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC41D76
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:44 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN2-0003M4-Ai; Fri, 20 Oct 2023 09:56:36 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN1-002yVL-N0; Fri, 20 Oct 2023 09:56:35 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN1-002OJZ-Dq; Fri, 20 Oct 2023 09:56:35 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linusw@kernel.org>, Imre Kaloz <kaloz@openwrt.org>,
        Corentin Labbe <clabbe@baylibre.com>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH 22/42] crypto: intel/ixp4xx-crypto - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:55:44 +0200
Message-ID: <20231020075521.2121571-66-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1997; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=Uxql2rquVCiZ+9UkmiKbwvFNTTiK1gqP8jH4odY841c=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlMjKDeLUK/o9XlJoJpAG5kRilLG3GuxV1kSDdC 6zYuGrKmQ2JATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZTIygwAKCRCPgPtYfRL+ TkvtB/9XPdFWoz/axur5iZKozp63mwB7w6Po/JMSx8oPgw3CJZm66EESprwsMEnpWdB+hNt2InB TBPakAVhB6fdBeYyr2Vv2Q1LyBSWHJwOVEZyr5+MWtu3rTgr5R7aJFHJIEYWoWQg8AazGgOxiNe ePbA2s/9o8y4OiZ+yjn5QJD99IJ5t2sCVAPSd8Or78Q/OXsXlmevwyxb3ZKk9PwkG9oZ/aUUZbu Lb3KT9YOZKf/Td+5jlJZsi9V0sdldwC18eLX2oVCIktR5MqU324ofFkUN8SI07asRo7q0bNwg6j /UO0s0GupRCuM1QrqIqT+z4ZAbLs1ZGPQrFIzsuHZ3moa2nh
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
 drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c b/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
index 4a18095ae5d8..f8a77bff8844 100644
--- a/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
+++ b/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
@@ -1563,7 +1563,7 @@ static int ixp_crypto_probe(struct platform_device *_pdev)
 	return 0;
 }
 
-static int ixp_crypto_remove(struct platform_device *pdev)
+static void ixp_crypto_remove(struct platform_device *pdev)
 {
 	int num = ARRAY_SIZE(ixp4xx_algos);
 	int i;
@@ -1578,8 +1578,6 @@ static int ixp_crypto_remove(struct platform_device *pdev)
 			crypto_unregister_skcipher(&ixp4xx_algos[i].crypto);
 	}
 	release_ixp_crypto(&pdev->dev);
-
-	return 0;
 }
 static const struct of_device_id ixp4xx_crypto_of_match[] = {
 	{
@@ -1590,7 +1588,7 @@ static const struct of_device_id ixp4xx_crypto_of_match[] = {
 
 static struct platform_driver ixp_crypto_driver = {
 	.probe = ixp_crypto_probe,
-	.remove = ixp_crypto_remove,
+	.remove_new = ixp_crypto_remove,
 	.driver = {
 		.name = "ixp4xx_crypto",
 		.of_match_table = ixp4xx_crypto_of_match,
-- 
2.42.0

