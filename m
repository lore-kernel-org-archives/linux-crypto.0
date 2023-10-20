Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4B88CDB47E
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:57:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376514AbjJTH5Y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376511AbjJTH45 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:56:57 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87BC10C1
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:45 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN7-0003iY-FY; Fri, 20 Oct 2023 09:56:41 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN5-002yWT-NK; Fri, 20 Oct 2023 09:56:39 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN5-002OKo-E6; Fri, 20 Oct 2023 09:56:39 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 40/42] crypto: talitos - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:56:02 +0200
Message-ID: <20231020075521.2121571-84-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1884; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=R/W5Ggr2lsK+y2USJhl+aFdinr2wIRMDyAi6MKUWmjU=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlMjKXAedL836rvPh9UPV637nn8dO4yPShep9bx I/sr6xTOi2JATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZTIylwAKCRCPgPtYfRL+ TgB/B/973+eh4pE50jmCU9dWenziAGPSvskOHrb3+I1m/olsqMJghDjWMrfKbgRCM63CLu5yDbf LmIeH8v9b94L6nirYBIdcXuYOPTAzK3aQdnfKB+Qxv/alp1k3M2TBOChjhWqibqy5NVYn9/v76M xXpKl8fsFXQGGaxxAJgFg7nvi/bfK+/JRJRGdCtHGDd1E+QkTeCTrgljIILUe3BB17MMPmHYr8l UcFqq8pKghT2cTDfv3cqcmvrjRs3f/U6QxIA6m7HvP4o/am+mf1zXnrWfeSAMVkBdpvTW1HUhVm aTNsNjVJanmBZbLs4iDV9MXdDC6Owhoqu6xL9Ip2cDw+skQO
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
 drivers/crypto/talitos.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 4ca4fbd227bc..e603c0f2abca 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3136,7 +3136,7 @@ static int hw_supports(struct device *dev, __be32 desc_hdr_template)
 	return ret;
 }
 
-static int talitos_remove(struct platform_device *ofdev)
+static void talitos_remove(struct platform_device *ofdev)
 {
 	struct device *dev = &ofdev->dev;
 	struct talitos_private *priv = dev_get_drvdata(dev);
@@ -3170,8 +3170,6 @@ static int talitos_remove(struct platform_device *ofdev)
 	tasklet_kill(&priv->done_task[0]);
 	if (priv->irq[1])
 		tasklet_kill(&priv->done_task[1]);
-
-	return 0;
 }
 
 static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
@@ -3559,7 +3557,7 @@ static struct platform_driver talitos_driver = {
 		.of_match_table = talitos_match,
 	},
 	.probe = talitos_probe,
-	.remove = talitos_remove,
+	.remove_new = talitos_remove,
 };
 
 module_platform_driver(talitos_driver);
-- 
2.42.0

