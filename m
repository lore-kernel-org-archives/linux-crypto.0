Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA98EC001DE
	for <linux-crypto@archiver.kernel.org>; Mon, 31 Jul 2023 16:55:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233606AbjGaQzb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 31 Jul 2023 12:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233586AbjGaQzW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jul 2023 12:55:22 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F18119A1
        for <linux-crypto@vger.kernel.org>; Mon, 31 Jul 2023 09:55:13 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qQWAk-0006a4-1k; Mon, 31 Jul 2023 18:55:06 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qQWAg-000AQb-7G; Mon, 31 Jul 2023 18:55:02 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qQWAf-009NYm-3Y; Mon, 31 Jul 2023 18:55:01 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Thomas Bourgoin <thomas.bourgoin@foss.st.com>,
        Lionel Debieve <lionel.debieve@foss.st.com>
Cc:     linux-crypto@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: [PATCH 3/3] crypto: stm32/hash - Convert to platform remove callback returning void
Date:   Mon, 31 Jul 2023 18:54:56 +0200
Message-Id: <20230731165456.799784-4-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230731165456.799784-1-u.kleine-koenig@pengutronix.de>
References: <20230731165456.799784-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1852; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=weXYsfSF7xFoniTuItnSSSLl15yxpaIv25+29WYAieU=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkx+dc01wufPbTmMWiQXWAlti1lzx1ITCUGCOCk 8fb57m4hmeJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZMfnXAAKCRCPgPtYfRL+ Tqk7B/4qrncfgNDwVNAaX+W2udErsMXbzc+cVKDsdoeZsK8enbimuxgaQ9flTyvMS5dufmGAD88 F5v+PB4tmbSzbdVghRhb4qfwaElxQrBTQhRbGUFKyc41a6gWqubUNgjnkEfbuhZlS5Ncl+kje5V 3SseaZ2UL238lOPIFQg74Nj7cOLBgeXvkDb4nxAfG3BCM9F8kW+PGmjj/NanJRRLBL55iHcSbvd LDbHjXLld9W3lMMsQtPpSKmYfzOBbiXLTDdgnGrGYFoThHkUgJ1UNRvz53ut2gdsi2dztr42tqe 8MeMVJN2N9ys6J5IkRPO4Gr3rP0z5M3VOei0Hrt7RcisCvE0
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
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
.remove_new() which already returns void. Eventually after all drivers
are converted, .remove_new() is renamed to .remove().

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/crypto/stm32/stm32-hash.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index b10243035584..68c52eeaa6b1 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -2112,7 +2112,7 @@ static int stm32_hash_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int stm32_hash_remove(struct platform_device *pdev)
+static void stm32_hash_remove(struct platform_device *pdev)
 {
 	struct stm32_hash_dev *hdev = platform_get_drvdata(pdev);
 	int ret;
@@ -2135,8 +2135,6 @@ static int stm32_hash_remove(struct platform_device *pdev)
 
 	if (ret >= 0)
 		clk_disable_unprepare(hdev->clk);
-
-	return 0;
 }
 
 #ifdef CONFIG_PM
@@ -2173,7 +2171,7 @@ static const struct dev_pm_ops stm32_hash_pm_ops = {
 
 static struct platform_driver stm32_hash_driver = {
 	.probe		= stm32_hash_probe,
-	.remove		= stm32_hash_remove,
+	.remove_new	= stm32_hash_remove,
 	.driver		= {
 		.name	= "stm32-hash",
 		.pm = &stm32_hash_pm_ops,
-- 
2.39.2

