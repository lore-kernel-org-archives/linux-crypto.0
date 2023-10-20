Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D78B3C07480
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:57:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376518AbjJTH5b (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376517AbjJTH5A (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:57:00 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE1610C9
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:46 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN2-0003N1-PL; Fri, 20 Oct 2023 09:56:36 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN2-002yVY-CL; Fri, 20 Oct 2023 09:56:36 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN2-002OJl-3N; Fri, 20 Oct 2023 09:56:36 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Declan Murphy <declan.murphy@intel.com>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 25/42] crypto: intel/keembay-ocs-hcu - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:55:47 +0200
Message-ID: <20231020075521.2121571-69-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2078; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=AtYRt9Lgbk2X8ie83TNT0+RrJhu72yEL46Pi6Bon1Gk=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlMjKG1TpZh51pkvN52fSb+bnVcCtm2Ll7MgvTK S2shPXXA72JATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZTIyhgAKCRCPgPtYfRL+ TvUfB/43IsQ4yCezOIUofXy78bcHjR2igQAcvtoHBD3Obw6YIlQia6bt2SkEjMwLif6/oIajPxi d/l6zbJovLTVocvPuzYWbeGYIVZRJg/OE6bcnoA3TCc9OV8lYfXnl0kpORzRaRmbDRI5wKFCiFl 0Ve9C5seKsFFPKb7CLw34LYqM/8bKztY/VM25zSCj1suZmk24OCySDFlmdHF883kb67TbA0IOSD svcIjqV7ZfPPBlYl84PgJ38IOr3hrvchd5WweyjkpDaTsm+nl1ZrqdijnbIbm79OscVNjiPytdJ CI9ex/i0hVozzJK7vkZ9PaPL9p3C5wrSdlQHW/12mM4w6o9e
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
 drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c b/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
index 8a39f959bb53..c2dfca73fe4e 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
@@ -1151,7 +1151,7 @@ static const struct of_device_id kmb_ocs_hcu_of_match[] = {
 	{}
 };
 
-static int kmb_ocs_hcu_remove(struct platform_device *pdev)
+static void kmb_ocs_hcu_remove(struct platform_device *pdev)
 {
 	struct ocs_hcu_dev *hcu_dev = platform_get_drvdata(pdev);
 
@@ -1162,8 +1162,6 @@ static int kmb_ocs_hcu_remove(struct platform_device *pdev)
 	spin_lock_bh(&ocs_hcu.lock);
 	list_del(&hcu_dev->list);
 	spin_unlock_bh(&ocs_hcu.lock);
-
-	return 0;
 }
 
 static int kmb_ocs_hcu_probe(struct platform_device *pdev)
@@ -1244,7 +1242,7 @@ static int kmb_ocs_hcu_probe(struct platform_device *pdev)
 /* The OCS driver is a platform device. */
 static struct platform_driver kmb_ocs_hcu_driver = {
 	.probe = kmb_ocs_hcu_probe,
-	.remove = kmb_ocs_hcu_remove,
+	.remove_new = kmb_ocs_hcu_remove,
 	.driver = {
 			.name = DRV_NAME,
 			.of_match_table = kmb_ocs_hcu_of_match,
-- 
2.42.0

