Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2BB5C43334
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jul 2022 20:52:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbiGEUwE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Jul 2022 16:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiGEUwD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Jul 2022 16:52:03 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4B6320
        for <linux-crypto@vger.kernel.org>; Tue,  5 Jul 2022 13:52:02 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1o8pWW-0000tY-HR; Tue, 05 Jul 2022 22:51:56 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1o8pWS-004dBH-A7; Tue, 05 Jul 2022 22:51:55 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1o8pWV-003Ds3-3V; Tue, 05 Jul 2022 22:51:55 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 6/7] crypto: omap-sham: Drop if with an always false condition
Date:   Tue,  5 Jul 2022 22:51:43 +0200
Message-Id: <20220705205144.131702-6-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220705205144.131702-1-u.kleine-koenig@pengutronix.de>
References: <20220705205144.131702-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=852; h=from:subject; bh=xqL6jh5OAMPzomOFtpqyo5nVq2HQ7FkPRSbtlRdZq5g=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBixKRX8hMfECGIeRcZ1s5PHDeA+gJFpyywkQp4HTWE VWvOrU2JATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCYsSkVwAKCRDB/BR4rcrsCUs/CA CZM0KNFhSXlLPrVt63vtn36E71ONTZbx+MfFZGQvAed01vPVOTEmKWmuDBYCnFQD7lGP4VQJvIl2aU cZvwyGP6ynHUFUzs3basbyViBRhfr8CTCpvsFHwA3M6dxSEFDQdxSMxny8/YqnDK57W0I8o7FJMEv3 j075xBHtFT21pFX0Rv3n0zQzaHEEwA/ZmM2gYcRApFdh/UiO3xp/1MFnKXa36Lq/kwhFo63OHui4Qj eRH7jY4wbRrMD3ZdmkdIOuuKCtkwYBX9Q6l0RG6O8mJ2tPatMityZ8Kqn2LMtxUP1/Duvzd+NEQE27 yvVufw/GdfBqOcKklLrYBw9v1tzvkE
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

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/crypto/omap-sham.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 4b37dc69a50c..655a7f5a406a 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -2197,8 +2197,7 @@ static int omap_sham_remove(struct platform_device *pdev)
 	int i, j;
 
 	dd = platform_get_drvdata(pdev);
-	if (!dd)
-		return -ENODEV;
+
 	spin_lock_bh(&sham.lock);
 	list_del(&dd->list);
 	spin_unlock_bh(&sham.lock);
-- 
2.36.1

