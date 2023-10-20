Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 045A1C004C0
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:56:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376479AbjJTH4x (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376463AbjJTH4n (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:56:43 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C307D46
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:40 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN2-0003Me-O1; Fri, 20 Oct 2023 09:56:36 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN1-002yVR-U7; Fri, 20 Oct 2023 09:56:35 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN1-002OJd-L7; Fri, 20 Oct 2023 09:56:35 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 23/42] crypto: intel/keembay-ocs-aes - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:55:45 +0200
Message-ID: <20231020075521.2121571-67-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2028; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=6Iqa0rT+nQv07AkoPvD1/LNP6FLbiuHF+uJ0vL3pqrM=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlMjKEwgNJv+b+gyUgYmyCO58K6fuZtPxcrr/eV gLbWRsB2r2JATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZTIyhAAKCRCPgPtYfRL+ TsgGB/4smlNe2YNChQBHw42o9dXv3pZ47o9PYPPRXx4XDStqjqBt9g8VrFmIaiD9xG11MLirr/e s2jRCVE8Uy2K5TA0YxW6hRq7YQvVb+o/lNmkEkStIIteXX959EqAdvlZcCWor8CNPrZ5BSBGVu4 021sfwf/ilKEJNrnbZi5/YLtZupzNdOa95lRHRRQXURsc4AxGuiQZd1BSpftqy8QGxY1vF45pjK qlWa8V7tq5RLFS7moxL9lCAZtSIz81dT0r1UX97HJ/dL4ahOwUymhiL8xoctDZWyfuxAI6BZhjE 8vbCVnwgf0+BoI9rCRE8nrzDbadpNN5TCrYxv20bDOXLESrI
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.

To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new(), which already returns void. Eventually after all drivers
are converted, .remove_new() will be renamed to .remove().

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/crypto/intel/keembay/keembay-ocs-aes-core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c b/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
index 1e2fd9a754ec..9b2d098e5eb2 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
@@ -1562,7 +1562,7 @@ static const struct of_device_id kmb_ocs_aes_of_match[] = {
 	{}
 };
 
-static int kmb_ocs_aes_remove(struct platform_device *pdev)
+static void kmb_ocs_aes_remove(struct platform_device *pdev)
 {
 	struct ocs_aes_dev *aes_dev;
 
@@ -1575,8 +1575,6 @@ static int kmb_ocs_aes_remove(struct platform_device *pdev)
 	spin_unlock(&ocs_aes.lock);
 
 	crypto_engine_exit(aes_dev->engine);
-
-	return 0;
 }
 
 static int kmb_ocs_aes_probe(struct platform_device *pdev)
@@ -1658,7 +1656,7 @@ static int kmb_ocs_aes_probe(struct platform_device *pdev)
 /* The OCS driver is a platform device. */
 static struct platform_driver kmb_ocs_aes_driver = {
 	.probe = kmb_ocs_aes_probe,
-	.remove = kmb_ocs_aes_remove,
+	.remove_new = kmb_ocs_aes_remove,
 	.driver = {
 			.name = DRV_NAME,
 			.of_match_table = kmb_ocs_aes_of_match,
-- 
2.42.0

