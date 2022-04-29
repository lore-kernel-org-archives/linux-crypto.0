Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02B6DC433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Apr 2022 14:07:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376829AbiD2OK2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Apr 2022 10:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377144AbiD2OKH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Apr 2022 10:10:07 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE6F45045
        for <linux-crypto@vger.kernel.org>; Fri, 29 Apr 2022 07:04:11 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1nkRE1-00007q-V2; Fri, 29 Apr 2022 16:04:02 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nkRE1-005xiI-FO; Fri, 29 Apr 2022 16:04:00 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nkRDz-006Qza-3C; Fri, 29 Apr 2022 16:03:59 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de
Subject: [PATCH] crypto: atmel-i2c - Simplify return code in probe function
Date:   Fri, 29 Apr 2022 16:03:49 +0200
Message-Id: <20220429140349.215732-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=725; h=from:subject; bh=eM8sK1lOooBZsSLyekvsy/75kXT47PM9viuwYVyFGWQ=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBia/BAkoS2DcXmPKLjxF8QXaMJl2Yp7ZcuBKi2Jmlg XsfmGXOJATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCYmvwQAAKCRDB/BR4rcrsCQVXB/ 9UHZZ96g/RFZpzHnQLcZqKeEurjjk6hwsRlWu0/wRRHKN/Qx+MIQ3OPVg+D+h1WjPHlypIsa1A8xnD tqmSvCPMToSbyg5n47PjTM7B8wfj9K+2TJURTJ+BNFXFutUbppxEHu3s6lDIHwxghWy5styWiLPGls THbxIyAdHHVkIxxpZ3jv6J2AK8HnWksZ6BhosfYlKBYgPwGmsZ/hGUbOh19g65LTS/Uks4lpivuRpf SyWV1VLbgf7RQIYsVx7scNIysdFpAbk7ubem9d3NlKzLp29l2R/GRr54KYvzvmZ3Vs8eIVzKef4T4s 2y4BL1Gb8F2U1AOwWC229+l2Ta0WNx
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

There is no semantical change introduced by this change.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/crypto/atmel-i2c.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
index 6fd3e969211d..384865ef96ce 100644
--- a/drivers/crypto/atmel-i2c.c
+++ b/drivers/crypto/atmel-i2c.c
@@ -364,11 +364,7 @@ int atmel_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 	i2c_set_clientdata(client, i2c_priv);
 
-	ret = device_sanity_check(client);
-	if (ret)
-		return ret;
-
-	return 0;
+	return device_sanity_check(client);
 }
 EXPORT_SYMBOL(atmel_i2c_probe);
 
-- 
2.35.1

