Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 054B3C004C0
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:57:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376499AbjJTH5a (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376518AbjJTH5A (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:57:00 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA76D51
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:45 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN7-0003gL-4A; Fri, 20 Oct 2023 09:56:41 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN5-002yWN-8V; Fri, 20 Oct 2023 09:56:39 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN4-002OKg-Ty; Fri, 20 Oct 2023 09:56:38 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        linux-crypto@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: [PATCH 38/42] crypto: stm32/crc32 - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:56:00 +0200
Message-ID: <20231020075521.2121571-82-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2434; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=ZSdL5qT5fdKkW9Pe3nwuWzBPi3/kxcjn33Eoon/bjiY=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlMjKVcsA+sPV86Y9njfUYUKL2nE/mN1rlIOD2i PhmFZ870pCJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZTIylQAKCRCPgPtYfRL+ TplEB/47NfS/xSFI1GP3PNeDNFXa2FAvxzpE7r6IO4SOZETJVdSmjn4CeyG+yIXfoAqN6qnnnE1 yrQJkFRUoy+O24ytc7I+Hz3ViZnQ+9znfTExxA6boeskmTSuQuJ92EKVv8coIHWFqJ0XzpVQ87B rO/KDO/EpWY8OqWQpVWa97GQNoAixLjM9+FrUwhjDsgykpJFwUkWeS/BkACG/bVkAf8uZs19Ya+ 2NWMcwVTR9v/qep5rhn5Pylt5dwTt1lXag5uBe+/rH16Rb7rT/WUYpNskHBVxg6AEtrUcmMJeWz pjqcSYZCOkC9gX2BhqKtgigQWPfFLsx062Kweb/Kph/hZpfz
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
returning an error code. However the value returned is (mostly) ignored
and this typically results in resource leaks. To improve here there is a
quest to make the remove callback return void. In the first step of this
quest all drivers are converted to .remove_new() which already returns
void.

The driver adapted here suffered from this wrong assumption and had an
error paths resulting in resource leaks.

If pm_runtime_get() fails, the other resources held by the device must
still be freed. Only clk_disable() should be skipped as the
pm_runtime_get() failed to call clk_enable().

After this change the remove function returns zero unconditionally and
can trivially be converted to the prototype required for .remove_new().

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/crypto/stm32/stm32-crc32.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-crc32.c b/drivers/crypto/stm32/stm32-crc32.c
index 90a920e7f664..5d1067c8cb0d 100644
--- a/drivers/crypto/stm32/stm32-crc32.c
+++ b/drivers/crypto/stm32/stm32-crc32.c
@@ -379,16 +379,11 @@ static int stm32_crc_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int stm32_crc_remove(struct platform_device *pdev)
+static void stm32_crc_remove(struct platform_device *pdev)
 {
 	struct stm32_crc *crc = platform_get_drvdata(pdev);
 	int ret = pm_runtime_get_sync(crc->dev);
 
-	if (ret < 0) {
-		pm_runtime_put_noidle(crc->dev);
-		return ret;
-	}
-
 	spin_lock(&crc_list.lock);
 	list_del(&crc->list);
 	spin_unlock(&crc_list.lock);
@@ -401,9 +396,9 @@ static int stm32_crc_remove(struct platform_device *pdev)
 	pm_runtime_disable(crc->dev);
 	pm_runtime_put_noidle(crc->dev);
 
-	clk_disable_unprepare(crc->clk);
-
-	return 0;
+	if (ret >= 0)
+		clk_disable(crc->clk);
+	clk_unprepare(crc->clk);
 }
 
 static int __maybe_unused stm32_crc_suspend(struct device *dev)
@@ -472,7 +467,7 @@ MODULE_DEVICE_TABLE(of, stm32_dt_ids);
 
 static struct platform_driver stm32_crc_driver = {
 	.probe  = stm32_crc_probe,
-	.remove = stm32_crc_remove,
+	.remove_new = stm32_crc_remove,
 	.driver = {
 		.name           = DRIVER_NAME,
 		.pm		= &stm32_crc_pm_ops,
-- 
2.42.0

