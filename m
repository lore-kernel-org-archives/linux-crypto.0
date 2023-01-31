Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE543C6379F
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Jan 2023 08:14:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbjAaIOb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 31 Jan 2023 03:14:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbjAaIOa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Jan 2023 03:14:30 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66BC52FCC0
        for <linux-crypto@vger.kernel.org>; Tue, 31 Jan 2023 00:14:28 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pMlm9-0006LX-25; Tue, 31 Jan 2023 09:13:57 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pMlm8-001eFc-BD; Tue, 31 Jan 2023 09:13:55 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pMlm6-00HHHl-Bx; Tue, 31 Jan 2023 09:13:54 +0100
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
Subject: [PATCH] crypto: atmel-i2c: Drop unused id parameter from atmel_i2c_probe()
Date:   Tue, 31 Jan 2023 09:13:51 +0100
Message-Id: <20230131081351.165235-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2811; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=RlwnWuVIIpRybU88j7KMHkdk6doB4l9M+k7cgJOSprg=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBj2M276DqXefzpaxUi9jOoCA+C1yinbOvxC5xPD6gi /VemPDKJATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCY9jNuwAKCRDB/BR4rcrsCYm6B/ 92ACNrrj6Um+7c0e4I8SWx54yj4YMJOGCxUBG/DX4QV2UHjG8jGyt+7yJdV/M1m8Cxq3i+NLV5a8iB 74MwUkqmeDSHPdQGcnDF7qIEyf0RlTRMmRVP47JSg8cSxlMagy+WlEdNfodAzjazOWbyhbQclIrl0c uTl7BUlEnMk9cLW9gnRK4XQC45DYacujO2vJMuRU2BasOXlidewvnv7N+lb04IbTszUV2d4SPLa8Q/ zatCYBxJf4i4Vwofucg+yddTQdayPDDUtM+Zs4FdmFxdQkIesNiBBCPczyZPHwrXtq3/8SonG0zSU0 tSseBTj4oJ0Ndb0FQkzWRXZgK5bKdp
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

id is unused in atmel_i2c_probe() and the callers have extra efforts to
determine the right parameter. So drop the parameter simplifying both
atmel_i2c_probe() and its callers.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

just found a nice optimisation while grepping for something else in the
tree ...

Best regards
Uwe

 drivers/crypto/atmel-ecc.c     | 3 +--
 drivers/crypto/atmel-i2c.c     | 2 +-
 drivers/crypto/atmel-i2c.h     | 2 +-
 drivers/crypto/atmel-sha204a.c | 3 +--
 4 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 12205e2b53b4..aac64b555204 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -313,11 +313,10 @@ static struct kpp_alg atmel_ecdh_nist_p256 = {
 
 static int atmel_ecc_probe(struct i2c_client *client)
 {
-	const struct i2c_device_id *id = i2c_client_get_device_id(client);
 	struct atmel_i2c_client_priv *i2c_priv;
 	int ret;
 
-	ret = atmel_i2c_probe(client, id);
+	ret = atmel_i2c_probe(client);
 	if (ret)
 		return ret;
 
diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
index 66e27f71e37e..83a9093eff25 100644
--- a/drivers/crypto/atmel-i2c.c
+++ b/drivers/crypto/atmel-i2c.c
@@ -324,7 +324,7 @@ static int device_sanity_check(struct i2c_client *client)
 	return ret;
 }
 
-int atmel_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id)
+int atmel_i2c_probe(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv;
 	struct device *dev = &client->dev;
diff --git a/drivers/crypto/atmel-i2c.h b/drivers/crypto/atmel-i2c.h
index c1fdc04eac07..c0bd429ee2c7 100644
--- a/drivers/crypto/atmel-i2c.h
+++ b/drivers/crypto/atmel-i2c.h
@@ -167,7 +167,7 @@ struct atmel_i2c_work_data {
 	struct atmel_i2c_cmd cmd;
 };
 
-int atmel_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id);
+int atmel_i2c_probe(struct i2c_client *client);
 
 void atmel_i2c_enqueue(struct atmel_i2c_work_data *work_data,
 		       void (*cbk)(struct atmel_i2c_work_data *work_data,
diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 272a06f0b588..4403dbb0f0b1 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -93,11 +93,10 @@ static int atmel_sha204a_rng_read(struct hwrng *rng, void *data, size_t max,
 
 static int atmel_sha204a_probe(struct i2c_client *client)
 {
-	const struct i2c_device_id *id = i2c_client_get_device_id(client);
 	struct atmel_i2c_client_priv *i2c_priv;
 	int ret;
 
-	ret = atmel_i2c_probe(client, id);
+	ret = atmel_i2c_probe(client);
 	if (ret)
 		return ret;
 

base-commit: f160a0e64f0f80a82f797ea7aa007e41ba8ed441
-- 
2.39.0

