Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CC98CE7A89
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Sep 2023 10:08:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbjIWKId (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 23 Sep 2023 06:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbjIWKIc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 23 Sep 2023 06:08:32 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850AD19E
        for <linux-crypto@vger.kernel.org>; Sat, 23 Sep 2023 03:08:26 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qjzYe-0001jZ-NX; Sat, 23 Sep 2023 12:08:16 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qjzYb-008NfB-RV; Sat, 23 Sep 2023 12:08:13 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qjzYb-0047za-I6; Sat, 23 Sep 2023 12:08:13 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Declan Murphy <declan.murphy@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 1/2] crypto: keembay - Don't pass errors to the caller in .remove()
Date:   Sat, 23 Sep 2023 12:08:05 +0200
Message-Id: <20230923100806.1762943-2-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230923100806.1762943-1-u.kleine-koenig@pengutronix.de>
References: <20230923100806.1762943-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1890; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=LhjfIChNQG3YZGP0Qkc6j8igCZe2ZQXcjnKCah+AcqY=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlDrkB/sjl5G4bSzBgL224F3Hkk1ZN2IxrcsPxd sMmJl+0LIeJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZQ65AQAKCRCPgPtYfRL+ Tu/mB/96jxmK2pulSGLsHXibSRYoCx+vSr8yvFCh7BTiNNSw3+bl6Tm7lQlM+hajzJYPMmZejn+ 0A+AojrbdQEAfLrr2/tFNnhBW6YqJtqUyT3apEawYp1ZCmnNspsYV4gydzzsI7dt81cyD6gyBLU qYsZxtb02/F9y3rA5bgJBKm9Ba6U/+a6XSutL6z4pf22X4XTgRXrfM72UptLd1CzmX3aMbZROWu JaDejq4ngFI2lQvw5BXYzgD0OVOblwyWTmyPvvS4ZeCgnrUiYvW4IBzlfV8rgwS+kEnFU1EC178 mRG2cKtT4th/X1YPC1f8KnKwPLTe6myYti19odGIqHCO8xNO
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Returning an error code in the remove function of a platform device has
no effect (compared to returning zero) apart from an error message, that
the error is ignored. Then the device is removed irrespective of the
returned value.

As kmb_ocs_hcu_remove is only called after kmb_ocs_hcu_probe() returned
successfully, platform_get_drvdata() never returns NULL and so the
respective check can just be dropped.

crypto_engine_exit() might return an error code but already emits an
error message in that case, so better return zero in
kmb_ocs_hcu_remove() even in this case to suppress another error
message. All other crypto drivers also ignore the return value of
crypto_engine_exit().

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c b/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
index daba8ca05dbe..8a39f959bb53 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
@@ -1153,22 +1153,17 @@ static const struct of_device_id kmb_ocs_hcu_of_match[] = {
 
 static int kmb_ocs_hcu_remove(struct platform_device *pdev)
 {
-	struct ocs_hcu_dev *hcu_dev;
-	int rc;
-
-	hcu_dev = platform_get_drvdata(pdev);
-	if (!hcu_dev)
-		return -ENODEV;
+	struct ocs_hcu_dev *hcu_dev = platform_get_drvdata(pdev);
 
 	crypto_engine_unregister_ahashes(ocs_hcu_algs, ARRAY_SIZE(ocs_hcu_algs));
 
-	rc = crypto_engine_exit(hcu_dev->engine);
+	crypto_engine_exit(hcu_dev->engine);
 
 	spin_lock_bh(&ocs_hcu.lock);
 	list_del(&hcu_dev->list);
 	spin_unlock_bh(&ocs_hcu.lock);
 
-	return rc;
+	return 0;
 }
 
 static int kmb_ocs_hcu_probe(struct platform_device *pdev)
-- 
2.40.1

