Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D70ECC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Jul 2022 21:29:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbiGNV3R (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Jul 2022 17:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbiGNV3Q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Jul 2022 17:29:16 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5CE46DAC
        for <linux-crypto@vger.kernel.org>; Thu, 14 Jul 2022 14:29:15 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1oC6Nu-00064J-PQ; Thu, 14 Jul 2022 23:28:34 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1oC6Np-000zHj-UQ; Thu, 14 Jul 2022 23:28:29 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1oC6Np-005Dgh-32; Thu, 14 Jul 2022 23:28:29 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Prabhjot Khurana <prabhjot.khurana@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH] crypto: keembay-ocs-ecc: Drop if with an always false condition
Date:   Thu, 14 Jul 2022 23:28:20 +0200
Message-Id: <20220714212820.59237-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=996; h=from:subject; bh=HrGb7k9nlrRZDlkX2uq05bo5OX9GT8KSBgbj2aZh7w4=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBi0IpwqJt/WG1Wa3/H6KqBTBAqlFNtQcEwoS2KMLeF Yg6KK2yJATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCYtCKcAAKCRDB/BR4rcrsCdYUCA Cd8+4oYge3T+yfRYCEPmbRSJ0vzqkz85SXvo2FTTLltCXWVwZs18MLwqMVkHUvw1MyNy7dnyChgCIA B3BUMRGLndJ47JckDkdzA/ziNIoJTFZ4oksi5ywDDR4XGyw1DC0Hvi+FP2upGEMrVbbD7/RbIroCM8 nC2x7iXiVt0mEHObJ0Oa8hUely/w75z3zGHsdkskWcL4XcoFhCzipCkg8lK1nTP9NsdB0jJix5aLav zaKkwUfpbBILz1mYFj3yb91hq9CfmxBlLZW3Kz8W+PLMMZ9ittqSPo4kNwW10xwCxNzXSq4fcF6Nip oMmJvP3zr2FcAnCjBYywsa3ZDsBD/T
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
and so ecc_dev is never NULL.

This is a preparation for making platform remove callbacks return void.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/crypto/keembay/keembay-ocs-ecc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/keembay/keembay-ocs-ecc.c b/drivers/crypto/keembay/keembay-ocs-ecc.c
index 5d0785d3f1b5..2269df17514c 100644
--- a/drivers/crypto/keembay/keembay-ocs-ecc.c
+++ b/drivers/crypto/keembay/keembay-ocs-ecc.c
@@ -976,8 +976,6 @@ static int kmb_ocs_ecc_remove(struct platform_device *pdev)
 	struct ocs_ecc_dev *ecc_dev;
 
 	ecc_dev = platform_get_drvdata(pdev);
-	if (!ecc_dev)
-		return -ENODEV;
 
 	crypto_unregister_kpp(&ocs_ecdh_p384);
 	crypto_unregister_kpp(&ocs_ecdh_p256);

base-commit: f2906aa863381afb0015a9eb7fefad885d4e5a56
-- 
2.36.1

