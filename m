Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A2BFC43334
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jul 2022 20:52:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbiGEUwR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Jul 2022 16:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiGEUwP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Jul 2022 16:52:15 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8972C12AB7
        for <linux-crypto@vger.kernel.org>; Tue,  5 Jul 2022 13:52:13 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1o8pWW-0000tU-FA; Tue, 05 Jul 2022 22:51:56 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1o8pWR-004dB1-7r; Tue, 05 Jul 2022 22:51:54 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1o8pWU-003Drn-0L; Tue, 05 Jul 2022 22:51:54 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de
Subject: [PATCH 1/7] crypto: atmel-aes: Drop if with an always false condition
Date:   Tue,  5 Jul 2022 22:51:38 +0200
Message-Id: <20220705205144.131702-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=949; h=from:subject; bh=bvVGcxJkIlGRVNmIhFGFH6gXMQJmfXDlOVZ0OZksjRM=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBixKRGUTOHzCJtEaCXv0bWPCdHhqgHNqvqFTB5/8OL mxgzy2WJATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCYsSkRgAKCRDB/BR4rcrsCXdEB/ 46LKv+vBM92XIvMrZ6u7nsFkYjQuOXn1cMgd+NKXyV3JRf4k3gms1IEOSLDGucKKcq66W46CETUCa3 hZZefQszB4r4V+Ya5fPZEb3C4uenIt+qOsEngR38gA6ffF59FDm1p7VTqqOQJg4IuKFMNBzGVeqrR8 IHshp3++6QjUZ5upY8qHK1z29gZiqVhBtskjMWjPzWMS81z2XQDLgLsbBCGM+mEtrt4r2UoLlu4adq b4pGD28xOQpKzOheH6Ajx5haO53ZdrrqcD3IUarySCgECvkYHu/lNE62KWTcuObJBsZhnCHF1bnSSw j/RxK/c9BPN+uLmlRb9nXUg9iAV1xC
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The remove callback is only called after probe completed successfully.
In this case platform_set_drvdata() was called with a non-NULL argument
and so aes_dd is never NULL.

This is a preparation for making platform remove callbacks return void.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/crypto/atmel-aes.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index f72c6b3e4ad8..886bf258544c 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -2669,8 +2669,7 @@ static int atmel_aes_remove(struct platform_device *pdev)
 	struct atmel_aes_dev *aes_dd;
 
 	aes_dd = platform_get_drvdata(pdev);
-	if (!aes_dd)
-		return -ENODEV;
+
 	spin_lock(&atmel_aes.lock);
 	list_del(&aes_dd->list);
 	spin_unlock(&atmel_aes.lock);

base-commit: f2906aa863381afb0015a9eb7fefad885d4e5a56
-- 
2.36.1

