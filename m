Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3690AC05027
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Mar 2023 18:23:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjCNSXx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Mar 2023 14:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbjCNSXw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Mar 2023 14:23:52 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD61A0F16
        for <linux-crypto@vger.kernel.org>; Tue, 14 Mar 2023 11:23:51 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pc9JI-000434-DW; Tue, 14 Mar 2023 19:23:44 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pc9JG-0048Ri-RQ; Tue, 14 Mar 2023 19:23:42 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pc9JF-004sp8-RQ; Tue, 14 Mar 2023 19:23:41 +0100
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH] crypto: keembay-ocs-aes: Drop if with an always false condition
Date:   Tue, 14 Mar 2023 19:23:38 +0100
Message-Id: <20230314182338.2869452-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1027; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=fx+2I/+SMdGKFsrzEnui61yOOSC/vB9ODzv8JgWN5X0=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBkELunfBfvK/yK0RBpZx9CfficoYgm5v6i2GVUR z00m1b3vZeJATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCZBC7pwAKCRDB/BR4rcrs CR5cB/9javJWtVD/4SM9g7xesBaHEUJjYL6Jnc1bRfQPidu7117eN9JPlRrwgX6hAD7c7pd4yf9 AG/Kf8HaaEl+092BFm+EeKbiQ83FzSYgFuqkZ+bQzvo7RZpelZqCjNJTU6rrfa1VYiHSwWRd7JB LoU/JFZ5TLioOh2vFd3qvpLl3NrmS6ju6MR7ijtfyXhqCPb/rPbnCHINF/6fDcFs60pH6/a/pzW 3OfUnBvmg8RzX2pWUgWdcyrM+WdpARu0fhkGxZwmHFVM8mAnQxvquDD+YT7qz5Dx/rr1K3H8PhO 3yljs17SEA5m1dt7QUxE5H63/WYikv0mMmtm6IDhcCBNniFu
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

A platform device's remove callback is only ever called after the probe
callback returned success.

In the case of kmb_ocs_aes_remove() this means that kmb_ocs_aes_probe()
succeeded before and so platform_set_drvdata() was called with a
non-zero argument and platform_get_drvdata() returns non-NULL.

This prepares making remove callbacks return void.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/crypto/keembay/keembay-ocs-aes-core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/keembay/keembay-ocs-aes-core.c b/drivers/crypto/keembay/keembay-ocs-aes-core.c
index 9953f5590ac4..ae31be00357a 100644
--- a/drivers/crypto/keembay/keembay-ocs-aes-core.c
+++ b/drivers/crypto/keembay/keembay-ocs-aes-core.c
@@ -1580,8 +1580,6 @@ static int kmb_ocs_aes_remove(struct platform_device *pdev)
 	struct ocs_aes_dev *aes_dev;
 
 	aes_dev = platform_get_drvdata(pdev);
-	if (!aes_dev)
-		return -ENODEV;
 
 	unregister_aes_algs(aes_dev);
 
-- 
2.39.2

