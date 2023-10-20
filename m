Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74DCEC25B45
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:57:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376484AbjJTH5T (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376507AbjJTH45 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:56:57 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0702AD7E
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:44 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN6-0003ca-Al; Fri, 20 Oct 2023 09:56:40 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN4-002yWC-JT; Fri, 20 Oct 2023 09:56:38 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN4-002OKU-AK; Fri, 20 Oct 2023 09:56:38 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH 35/42] crypto: s5p-sss - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:55:57 +0200
Message-ID: <20231020075521.2121571-79-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1699; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=S6+msUyByijcNmR/6dbk6gp1vCoevLnu2n8OjF7qHUs=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlMjKSyP7JzLsaTpPyE7o+SWp4NkvNMIemA+r3f Oye6U4jJcmJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZTIykgAKCRCPgPtYfRL+ TkQsB/45KMnx8+zk/dnRPDl1weTLeVz43FDYP8zbYjWn9Qk+Dt1WUDYhvmdm0hPX7PdBB4E7Ok4 J1rKXX89/U9xLDL1oU65+o5Pb8ZhlSDI/4kBSlKYZq806wM1NHBGRJcphoHGKqLf27JQTSAPmAq KjvU3HaitTZq3BTa98wNp3v6t8O2EK+8sHo13ATua4cT4BGKIZyV/CoXMD467nSqmA2bU3j6pyW 47qqG0Ckp/CuNfXBFLR4xHZlkfSb0DiNYkS/C1AjVBClNI1It1dQHiphjFskspkj06zgnUGo+w5 zLJXFjBZucs+HkJtFv3e6r9tFjmkxSmNnGY/+FFHIbFaiV9c
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
 drivers/crypto/s5p-sss.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index fe8cf9ba8005..9c02046971e3 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -2315,7 +2315,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int s5p_aes_remove(struct platform_device *pdev)
+static void s5p_aes_remove(struct platform_device *pdev)
 {
 	struct s5p_aes_dev *pdata = platform_get_drvdata(pdev);
 	int i;
@@ -2337,13 +2337,11 @@ static int s5p_aes_remove(struct platform_device *pdev)
 
 	clk_disable_unprepare(pdata->clk);
 	s5p_dev = NULL;
-
-	return 0;
 }
 
 static struct platform_driver s5p_aes_crypto = {
 	.probe	= s5p_aes_probe,
-	.remove	= s5p_aes_remove,
+	.remove_new = s5p_aes_remove,
 	.driver	= {
 		.name	= "s5p-secss",
 		.of_match_table = s5p_sss_dt_match,
-- 
2.42.0

