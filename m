Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E5CEC07480
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:57:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376511AbjJTH5Z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376490AbjJTH47 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:56:59 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E84210C7
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:45 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkMz-0003Fm-50; Fri, 20 Oct 2023 09:56:33 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkMx-002yUB-KE; Fri, 20 Oct 2023 09:56:31 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkMx-002OIG-Ah; Fri, 20 Oct 2023 09:56:31 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Rob Herring <robh@kernel.org>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        kernel@pengutronix.de
Subject: [PATCH 03/42] crypto: sun8i-ss - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:55:25 +0200
Message-ID: <20231020075521.2121571-47-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1986; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=dt3UmLOLBBO2sbhm3wcuiJQjtHH5IgnIOJQ3j1q0V20=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlMjJtGu9EmhrcZ5waKFOIBGm5rNeS0MeowvAWl tQ7nDdLSv+JATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZTIybQAKCRCPgPtYfRL+ TogfB/9Kb+cay62DHxbG3K3kjHEidibrgd0CyjH0qk/8cHfHjZkKB53DJMDBKppljtKXEtU5jgP wqWL5n5C9C7wfSt+4P7uoHI//pWbYiHJbhqASPMGq+JmpPlj4MU5rjoNL85lHg3x8oIRsOsRsem tzHZMUMB6v2SBUDv0nekadLOLxdBSRfsniLbfFbY0NSAqShGH2N6sF7917Zb9hguy1HeAvqIOij hNgJneYtnFmnuVfDz7iMYGWLcNo6drvJp7vFztfqoB0V+8jr8HA6dj4aAhBL67C5StACIniMibH IpyvuSTeSdZPCduj6YweaeJx1G6cJdk+/+BR7CmcgneZdHHe
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
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
index 4a9587285c04..f14c60359d19 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
@@ -908,7 +908,7 @@ static int sun8i_ss_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int sun8i_ss_remove(struct platform_device *pdev)
+static void sun8i_ss_remove(struct platform_device *pdev)
 {
 	struct sun8i_ss_dev *ss = platform_get_drvdata(pdev);
 
@@ -921,8 +921,6 @@ static int sun8i_ss_remove(struct platform_device *pdev)
 	sun8i_ss_free_flows(ss, MAXFLOW - 1);
 
 	sun8i_ss_pm_exit(ss);
-
-	return 0;
 }
 
 static const struct of_device_id sun8i_ss_crypto_of_match_table[] = {
@@ -936,7 +934,7 @@ MODULE_DEVICE_TABLE(of, sun8i_ss_crypto_of_match_table);
 
 static struct platform_driver sun8i_ss_driver = {
 	.probe		 = sun8i_ss_probe,
-	.remove		 = sun8i_ss_remove,
+	.remove_new	 = sun8i_ss_remove,
 	.driver		 = {
 		.name		= "sun8i-ss",
 		.pm             = &sun8i_ss_pm_ops,
-- 
2.42.0

