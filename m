Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8CF2CCA47C
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jul 2022 20:52:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbiGEUwF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Jul 2022 16:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbiGEUwD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Jul 2022 16:52:03 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A22438D
        for <linux-crypto@vger.kernel.org>; Tue,  5 Jul 2022 13:52:02 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1o8pWX-0000tc-MM; Tue, 05 Jul 2022 22:51:57 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1o8pWS-004dBN-I2; Tue, 05 Jul 2022 22:51:56 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1o8pWV-003Ds7-9v; Tue, 05 Jul 2022 22:51:55 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH 7/7] crypto: s5p-sss: Drop if with an always false condition
Date:   Tue,  5 Jul 2022 22:51:44 +0200
Message-Id: <20220705205144.131702-7-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220705205144.131702-1-u.kleine-koenig@pengutronix.de>
References: <20220705205144.131702-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=853; h=from:subject; bh=bogHrLWOhtcmBuEz8mG/TmgQiUKVPwTBmiYKM67IJrE=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBixKRao/uc3yXouIxVSkn1OfxwsSKdJUfg3aNxeLh6 rrS1RlOJATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCYsSkWgAKCRDB/BR4rcrsCRWhB/ 0W08RBg8aZIfa5KTf034XdzCyDxQb3pqB2m60hY9sY81yVZV7kmvz4+HSgkUwT+QShLOiyD2qXxrAO FTPY5m4pv5fsr/N45hUagVGz7NiwW9QXKKLUvOfJMrGLFK/BMsGkR5wCAl7pvW6L/5cSQ+5BIE16OG nytNang79k98Bu5Z/G9oRQeoGE+BFEQAfb3vxHY47IJWTGnbVbBszMqdga7+qa1Qvc/+BugEjiIIXF EEZMoIxOfO61SZgXLEDvk0REWxXBY/MW191m+32alh8pM2BlFSN/R5dKFzRnefUUPbe72FRYBC25Mv ClSiAqodJd/AXREJ5dhm6V2al6Qq9C
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
and so pdata is never NULL.

This is a preparation for making platform remove callbacks return void.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/crypto/s5p-sss.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 7717e9e5977b..b79e49aa724f 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -2321,9 +2321,6 @@ static int s5p_aes_remove(struct platform_device *pdev)
 	struct s5p_aes_dev *pdata = platform_get_drvdata(pdev);
 	int i;
 
-	if (!pdata)
-		return -ENODEV;
-
 	for (i = 0; i < ARRAY_SIZE(algs); i++)
 		crypto_unregister_skcipher(&algs[i]);
 
-- 
2.36.1

