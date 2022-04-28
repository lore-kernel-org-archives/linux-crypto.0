Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5DF6C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Apr 2022 17:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234884AbiD1RPg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Apr 2022 13:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234974AbiD1RPd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Apr 2022 13:15:33 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F335B3FD
        for <linux-crypto@vger.kernel.org>; Thu, 28 Apr 2022 10:12:18 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1nk7gX-0006Bd-Tu; Thu, 28 Apr 2022 19:12:09 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nk7gX-005nM8-Hi; Thu, 28 Apr 2022 19:12:08 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nk7gV-006FUQ-Bv; Thu, 28 Apr 2022 19:12:07 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de
Subject: [PATCH 1/2] crypto: atmel-sha204a: Remove useless check
Date:   Thu, 28 Apr 2022 19:11:45 +0200
Message-Id: <20220428171146.188331-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=754; h=from:subject; bh=5UtBiNq04rrWOgahVSom57KYQrZi//mrUJR010snr00=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBiasrLufiK4i8o/uBVsU7ZNsvsSjVD/ZkdkHl/lmt9 ILJxUxOJATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCYmrKywAKCRDB/BR4rcrsCcbdB/ 0QBY9tqIC/lwjitWZy37WyxgUBBF/yotPWZ88h1NZqtwnZ73t/jQzVLgY77+rK+mn0Jnjm0oSDh1er bOLMWVHAdb2aY58vR4Vf4/uInMEorDbicVxCfx/QvW0322xxhWCnl6iUuJy7OlEuwVCJQQoU7WuXmO kq7CdDjW5Bifue5ycXFxQJIXj4KbWS5wC4zABirof9mr53OKL52r25+bjB6RJ+PiAbNlTfWzRbpTmc GOmnQc912K+rtew+dPL74LiKMt/xjSwGZR9aMHxwrP05RpuYTKW3sFM3LBMKZZYgXx6eXygRLFVoxd wIKBoQaEefs78d5o6j6Fc7HGgfYXa2
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

kfree(NULL) is a noop, so there is no win in checking a pointer before
kfreeing it.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/crypto/atmel-sha204a.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index c96c14e7dab1..c71fc86eb849 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -125,8 +125,7 @@ static int atmel_sha204a_remove(struct i2c_client *client)
 		return -EBUSY;
 	}
 
-	if (i2c_priv->hwrng.priv)
-		kfree((void *)i2c_priv->hwrng.priv);
+	kfree((void *)i2c_priv->hwrng.priv);
 
 	return 0;
 }

base-commit: 3123109284176b1532874591f7c81f3837bbdc17
-- 
2.35.1

