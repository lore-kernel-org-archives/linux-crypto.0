Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A076AC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Apr 2022 17:12:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234695AbiD1RPe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Apr 2022 13:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234884AbiD1RPd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Apr 2022 13:15:33 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D615B3EA
        for <linux-crypto@vger.kernel.org>; Thu, 28 Apr 2022 10:12:18 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1nk7gX-0006Be-Tu; Thu, 28 Apr 2022 19:12:09 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nk7gX-005nMB-Ip; Thu, 28 Apr 2022 19:12:08 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nk7gV-006FUT-Gw; Thu, 28 Apr 2022 19:12:07 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de
Subject: [PATCH 2/2] crypto: atmel-sha204a: Suppress duplicate error message
Date:   Thu, 28 Apr 2022 19:11:46 +0200
Message-Id: <20220428171146.188331-2-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220428171146.188331-1-u.kleine-koenig@pengutronix.de>
References: <20220428171146.188331-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1421; h=from:subject; bh=dULXhhIy46nVMYAUp2LhjGfrO/i/Y09zX1dcnzPKoGU=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBiasrPq0XoXAKagHpsB8sM6G3iYsdiN2oez9DR0LWA jRJ5CRaJATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCYmrKzwAKCRDB/BR4rcrsCQ8cB/ 4szPgonLJVifD33+nyLWfuPUnHfaAyipo+rST3nVh3ajJ3YOgQTzZMU+eFaqkK6mJGTo5VOmax4Q8c INhjwyyntxHu014xmHHpRpqdT89MrsufBzIDQOE5DuhSxmHEEqmxj1O2Y8pPk4/0pkEV/OVmGRNtAJ OwGNFOf6TaXRjCKfGt9dt1kwVLwKzcxyxi8R2q1gCzIc7A5GjEwatgsNNG2PtEFqU4Vq8LMwwZ9XGD nnNg+ZrIBV/WJ2GD2FYvGo9V33xPHRtMdR4bCwMHZZRkv6RzUpc7XvwJaW2SxbWYZSsnKnzE9WDSbB j/jtw6GOvqx8hDpgMgRZHabbn/9Rz5
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Returning an error value in an i2c remove callback results in an error
message being emitted by the i2c core, but otherwise it doesn't make a
difference. The device goes away anyhow and the devm cleanups are
called.

As atmel_sha204a_remove already emits an error message ant the additional
error message by the i2c core doesn't add any useful information, change
the return value to zero to suppress this error message.

Note that after atmel_sha204a_remove() returns *i2c_priv is freed, so there
is trouble ahead because atmel_sha204a_rng_done() might be called after
that freeing. So make the error message a bit more frightening.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/crypto/atmel-sha204a.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index c71fc86eb849..fecc56b19ba6 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -121,8 +121,8 @@ static int atmel_sha204a_remove(struct i2c_client *client)
 	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
 
 	if (atomic_read(&i2c_priv->tfm_count)) {
-		dev_err(&client->dev, "Device is busy\n");
-		return -EBUSY;
+		dev_emerg(&client->dev, "Device is busy, will remove it anyhow\n");
+		return 0;
 	}
 
 	kfree((void *)i2c_priv->hwrng.priv);
-- 
2.35.1

