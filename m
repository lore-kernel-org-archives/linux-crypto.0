Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1FF5C7EE29
	for <linux-crypto@archiver.kernel.org>; Thu, 25 May 2023 21:04:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233318AbjEYVEg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 May 2023 17:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbjEYVEe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 May 2023 17:04:34 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11370E76
        for <linux-crypto@vger.kernel.org>; Thu, 25 May 2023 14:04:06 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1q2I7n-0000OX-Il; Thu, 25 May 2023 23:03:55 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1q2I7k-002oFp-6i; Thu, 25 May 2023 23:03:52 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1q2I7j-007xgK-7K; Thu, 25 May 2023 23:03:51 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Tudor Ambarus <tudor.ambarus@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de
Subject: [PATCH] crypto: Switch i2c drivers back to use .probe()
Date:   Thu, 25 May 2023 23:03:47 +0200
Message-Id: <20230525210347.735106-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1568; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=eN2trPE3gZ7nPTXgYGpdpZ20mjW6yAXUQ2Hxhmr/nAU=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkb80ysZzv1I6Mfn2UzvnXz9ZiS+N/rAREzwmLl Iiji0FQFVGJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZG/NMgAKCRCPgPtYfRL+ TgojCAC5DAeyxB9/Uz519XrEvCGlU0ccuoiZcsuvgmZlVC17Sa68uJPEQTdROQ37MIjJGGsiPkh QiCKbYdzSKwmuj3hS/M2sV7KAynocokVK+X2/8wEa5r3gJ4gmT9LHVIUnuYxdpt/aWOno8yR/0O EAv9RkWsDsXeiDXrO9nB9R/31J0TVUw5DmVf7FtVlXcSXSnXGMxLDe6YNGNd1tPKW4OxQXGazG/ LU/O+5FnAYHrPpGAeykQeXl+Q+getBZVo7UFaDrNO6WgX8Gxkhte+hlF+w2uAdi/Uizm0Jqwq8n u/A5lodPyfkH8kcJ56SYmpu7Ai5vGUp6C2hqZmfq8pYZzB+H
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

After commit b8a1a4cd5a98 ("i2c: Provide a temporary .probe_new()
call-back type"), all drivers being converted to .probe_new() and then
03c835f498b5 ("i2c: Switch .probe() to not take an id parameter")
convert back to (the new) .probe() to be able to eventually drop
.probe_new() from struct i2c_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/crypto/atmel-ecc.c     | 2 +-
 drivers/crypto/atmel-sha204a.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index aac64b555204..432beabd79e6 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -389,7 +389,7 @@ static struct i2c_driver atmel_ecc_driver = {
 		.name	= "atmel-ecc",
 		.of_match_table = of_match_ptr(atmel_ecc_dt_ids),
 	},
-	.probe_new	= atmel_ecc_probe,
+	.probe		= atmel_ecc_probe,
 	.remove		= atmel_ecc_remove,
 	.id_table	= atmel_ecc_id,
 };
diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 44a185a84760..c77f482d2a97 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -141,7 +141,7 @@ static const struct i2c_device_id atmel_sha204a_id[] = {
 MODULE_DEVICE_TABLE(i2c, atmel_sha204a_id);
 
 static struct i2c_driver atmel_sha204a_driver = {
-	.probe_new		= atmel_sha204a_probe,
+	.probe			= atmel_sha204a_probe,
 	.remove			= atmel_sha204a_remove,
 	.id_table		= atmel_sha204a_id,
 

base-commit: ac9a78681b921877518763ba0e89202254349d1b
-- 
2.39.2

