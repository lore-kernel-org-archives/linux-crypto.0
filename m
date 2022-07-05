Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31BF9CCA47B
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jul 2022 20:52:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbiGEUwF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Jul 2022 16:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbiGEUwE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Jul 2022 16:52:04 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA8FB92
        for <linux-crypto@vger.kernel.org>; Tue,  5 Jul 2022 13:52:02 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1o8pWW-0000tZ-LP; Tue, 05 Jul 2022 22:51:56 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1o8pWS-004dBK-Dy; Tue, 05 Jul 2022 22:51:55 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1o8pWU-003Drw-Jm; Tue, 05 Jul 2022 22:51:54 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 4/7] crypto: omap-aes: Drop if with an always false condition
Date:   Tue,  5 Jul 2022 22:51:41 +0200
Message-Id: <20220705205144.131702-4-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220705205144.131702-1-u.kleine-koenig@pengutronix.de>
References: <20220705205144.131702-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1136; h=from:subject; bh=o2MYApuuvCDNzwceQmqrYdmJkw0O4+AiJdX63pchZAM=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBixKRRVLEduK3vzrAPIaOrN90LYNnohpN3u+rbGxoB 2SmrXSaJATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCYsSkUQAKCRDB/BR4rcrsCQv0B/ 9lI4iJG5MxBuvDPlVC9c4c2R8Qpy3glF4OlhNdt1zUUAeJNO5a7W0388CvVUWLp5H3O6vg0BdD/NYy 47YCEQTzN+LRKjIhr4xfpFtfQR0h37VVCiuEEaLPGM6XPMaRlS0vZjNJ3WhEnaa8wLNXa3pf5n25Xu A0KkWufTJxUbAv5YoJ/P0IEfeaJZVX9Nb20n+diujUqlMdj9f4AF+FG8khBlbVOSZ2RMB71WzsAA5r FLRNvscxyjQA/XMCF3z8hIBJAvyt9y6WbqNEQjliNhV6Fr1FYEOOrVjrziKmtoKLRyprZnO06/uofL 7dWQps1LtZqF4ksUvkZR3WNuY/2eee
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
and so dd is never NULL.

This is a preparation for making platform remove callbacks return void.

While touching this driver remove a stray empty line.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/crypto/omap-aes.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 581211a92628..67a99c760bc4 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -1261,9 +1261,6 @@ static int omap_aes_remove(struct platform_device *pdev)
 	struct aead_alg *aalg;
 	int i, j;
 
-	if (!dd)
-		return -ENODEV;
-
 	spin_lock_bh(&list_lock);
 	list_del(&dd->list);
 	spin_unlock_bh(&list_lock);
@@ -1279,7 +1276,6 @@ static int omap_aes_remove(struct platform_device *pdev)
 		aalg = &dd->pdata->aead_algs_info->algs_list[i];
 		crypto_unregister_aead(aalg);
 		dd->pdata->aead_algs_info->registered--;
-
 	}
 
 	crypto_engine_exit(dd->engine);
-- 
2.36.1

