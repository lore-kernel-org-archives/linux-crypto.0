Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9B51C004C0
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:57:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376535AbjJTH5y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376533AbjJTH5O (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:57:14 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A997C10CF
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:48 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN7-0003hX-Bo; Fri, 20 Oct 2023 09:56:41 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN5-002yWQ-Gz; Fri, 20 Oct 2023 09:56:39 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN5-002OKk-7g; Fri, 20 Oct 2023 09:56:39 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        nicolas.toromanoff@foss.st.com,
        Colin Ian King <colin.i.king@gmail.com>,
        Rob Herring <robh@kernel.org>, linux-crypto@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: [PATCH 39/42] crypto: stm32/cryp - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:56:01 +0200
Message-ID: <20231020075521.2121571-83-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2723; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=7A/4jfO5f6HPiPMVJM3k1eEGID7WdOBM8OghW+7z3ug=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlMjKWxBuHKyc8wcbd1mj6AxMptWcoLzYBnaw3U wg+jgwX8VSJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZTIylgAKCRCPgPtYfRL+ ThDwB/wK8d5usctRxniPVmWkOoFU/WfE+6gfYDF2lBAw5FKmcp0+xjRl5hPzamdDONa7wNHQggs vmLCxzAf9nSCzPtI4JlodbrDMzqLrJR2JHHxzh3pqh14ouxm6RsYMgUCK10LH07JW3eOtS3ZYNB MLRUbqq6zG2PI6MN8U4St7jnLxOJZ0Ry/idbzvxTD/Kq539lV98YNQYccHGjZziD5AQzMc9qosN X5tWmf9gRPJaaV2j5UoywSLzRCV3qveCSRxgZUIhdVgM/otC56pBRcSlxeWcyOqGREb7SYQOiKR UO+vpVfxREop/84pttO44tEJO6MF72B7eK4uFbPwzb7EXo9i
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

The driver adapted here suffered from this wrong assumption and had
several error paths resulting in resource leaks.

The check for cryp being non-NULL is harmless. This can never happen as
.remove() is only called after .probe() completed successfully and in
that case drvdata was set to a non-NULL value. So this check can just be
dropped.

If pm_runtime_get() fails, the other resources held by the device must
still be freed. Only clk_disable_unprepare() should be skipped as the
pm_runtime_get() failed to call clk_prepare_enable().

After these changes the remove function returns zero unconditionally and
can trivially be converted to the prototype required for .remove_new().

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/crypto/stm32/stm32-cryp.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index f095f0065428..c3cbc2673338 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -2084,17 +2084,12 @@ static int stm32_cryp_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int stm32_cryp_remove(struct platform_device *pdev)
+static void stm32_cryp_remove(struct platform_device *pdev)
 {
 	struct stm32_cryp *cryp = platform_get_drvdata(pdev);
 	int ret;
 
-	if (!cryp)
-		return -ENODEV;
-
-	ret = pm_runtime_resume_and_get(cryp->dev);
-	if (ret < 0)
-		return ret;
+	ret = pm_runtime_get_sync(cryp->dev);
 
 	if (cryp->caps->aeads_support)
 		crypto_engine_unregister_aeads(aead_algs, ARRAY_SIZE(aead_algs));
@@ -2109,9 +2104,8 @@ static int stm32_cryp_remove(struct platform_device *pdev)
 	pm_runtime_disable(cryp->dev);
 	pm_runtime_put_noidle(cryp->dev);
 
-	clk_disable_unprepare(cryp->clk);
-
-	return 0;
+	if (ret >= 0)
+		clk_disable_unprepare(cryp->clk);
 }
 
 #ifdef CONFIG_PM
@@ -2148,7 +2142,7 @@ static const struct dev_pm_ops stm32_cryp_pm_ops = {
 
 static struct platform_driver stm32_cryp_driver = {
 	.probe  = stm32_cryp_probe,
-	.remove = stm32_cryp_remove,
+	.remove_new = stm32_cryp_remove,
 	.driver = {
 		.name           = DRIVER_NAME,
 		.pm		= &stm32_cryp_pm_ops,
-- 
2.42.0

