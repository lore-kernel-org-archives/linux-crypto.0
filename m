Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 170DFCDB474
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:57:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376578AbjJTH53 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376497AbjJTH5A (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:57:00 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6B9D46
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:46 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN3-0003Mu-3l; Fri, 20 Oct 2023 09:56:37 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN2-002yVV-5W; Fri, 20 Oct 2023 09:56:36 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN1-002OJh-So; Fri, 20 Oct 2023 09:56:35 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Prabhjot Khurana <prabhjot.khurana@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 24/42] crypto: intel/keembay-ocs-ecc - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:55:46 +0200
Message-ID: <20231020075521.2121571-68-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1977; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=5gQx1ZgYhOtO1HCzwRB6ysrkrDC4Kp1bds3Fg2Zwn/E=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlMjKFEqIrecwxCmDD5/MZRXVrNEOkFqbO6sujG Q5grOwuyR+JATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZTIyhQAKCRCPgPtYfRL+ TrVFB/9dJjTivaXF4uL1LNFMM6GURMZeoHZ2xf2cKA5LHQfjrLBfAytwaoFsg8LN7KfnnP0vnDB EDdofShIZ6Y4lwmopF9OUNYV1V+lpdeNBo8f3uIWfR25SFfBxcZGfK29kkwpABxmcNQLfFYgUnX d1iv72yaqK6FopSthwXZHNf0sJWPysFGZynS9lpNnM5jdXnhxirhgVxZI64ShczYUfsPUqYW7X9 /87BfEWYDKIr6UYpFYccXzZmHUiL7UetYP2NBVrs3OXjcWCRJkhzQEJf9EX4U+5Fz0txxoWKjmk d4IjrSua/SRsu55hNE6KzPc43nHCTBs2RLS/oGTJYKL14gRE
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
 drivers/crypto/intel/keembay/keembay-ocs-ecc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/intel/keembay/keembay-ocs-ecc.c b/drivers/crypto/intel/keembay/keembay-ocs-ecc.c
index fb95deed9057..5e24f2d8affc 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-ecc.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-ecc.c
@@ -964,7 +964,7 @@ static int kmb_ocs_ecc_probe(struct platform_device *pdev)
 	return rc;
 }
 
-static int kmb_ocs_ecc_remove(struct platform_device *pdev)
+static void kmb_ocs_ecc_remove(struct platform_device *pdev)
 {
 	struct ocs_ecc_dev *ecc_dev;
 
@@ -978,8 +978,6 @@ static int kmb_ocs_ecc_remove(struct platform_device *pdev)
 	spin_unlock(&ocs_ecc.lock);
 
 	crypto_engine_exit(ecc_dev->engine);
-
-	return 0;
 }
 
 /* Device tree driver match. */
@@ -993,7 +991,7 @@ static const struct of_device_id kmb_ocs_ecc_of_match[] = {
 /* The OCS driver is a platform device. */
 static struct platform_driver kmb_ocs_ecc_driver = {
 	.probe = kmb_ocs_ecc_probe,
-	.remove = kmb_ocs_ecc_remove,
+	.remove_new = kmb_ocs_ecc_remove,
 	.driver = {
 			.name = DRV_NAME,
 			.of_match_table = kmb_ocs_ecc_of_match,
-- 
2.42.0

