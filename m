Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 521F6C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Mar 2022 14:17:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233040AbiCNOS3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Mar 2022 10:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242233AbiCNOS2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Mar 2022 10:18:28 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8EC19C35
        for <linux-crypto@vger.kernel.org>; Mon, 14 Mar 2022 07:17:17 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1nTlVL-0004zT-8j; Mon, 14 Mar 2022 15:16:59 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nTlVL-000f2z-Gx; Mon, 14 Mar 2022 15:16:58 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nTlVJ-0097ao-2C; Mon, 14 Mar 2022 15:16:57 +0100
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-clk@vger.kernel.org, kernel@pengutronix.de,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Subject: [PATCH v8 05/16] hwrng: meson - Don't open-code devm_clk_get_optional_enabled()
Date:   Mon, 14 Mar 2022 15:16:32 +0100
Message-Id: <20220314141643.22184-6-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314141643.22184-1-u.kleine-koenig@pengutronix.de>
References: <20220314141643.22184-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1735; i=uwe@kleine-koenig.org; h=from:subject; bh=bfqnxylPnbbJXe+3GBtwLYLgZPhd+qJZuw2RI3jILYE=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBiL035AdG35VtGykFXO3us1e4Qyfe85laP1NXWH96B J/ooUYmJATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCYi9N+QAKCRDB/BR4rcrsCaXiCA CYQFfcviJ8XTZvDwlKW0nOhnqK5pTk5a0ilSqlNkH2f7pbLRUYz1rMgQTnxyx4mfi2x7jHSUvQ80ZT XrlFiSMUGotXPWPSjAUJtt/ZB9qpJIkDJquiChcWWfqfB93qxX7eOCzqjmM/C3k/uibRqKM6E2qaKK kEmkOLoBVbmGMXAlti6yjPpMx+ObbWu4w1cwFw1pLAaCuq8fgXcIjhi95Q/7JfLu+gadS6zU5a44LZ Eqie89qMyY4R8y4ZcWGjy+UHyrWlXdQ3RxglzdRGZHT3wAZb+gFSUfxq+FyiKjlwfM8XheHVut3VVz P3sPTI8D/NFV8C+7vxPxHB1zuDfQqZ
X-Developer-Key: i=uwe@kleine-koenig.org; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

devm_clk_get_enabled() returns a clock prepared and enabled and already
registers a devm exit handler to disable (and unprepare) the clock.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/char/hw_random/meson-rng.c | 20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff --git a/drivers/char/hw_random/meson-rng.c b/drivers/char/hw_random/meson-rng.c
index 8bb30282ca46..06db5a93e257 100644
--- a/drivers/char/hw_random/meson-rng.c
+++ b/drivers/char/hw_random/meson-rng.c
@@ -33,16 +33,10 @@ static int meson_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 	return sizeof(u32);
 }
 
-static void meson_rng_clk_disable(void *data)
-{
-	clk_disable_unprepare(data);
-}
-
 static int meson_rng_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct meson_rng_data *data;
-	int ret;
 
 	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
 	if (!data)
@@ -54,20 +48,10 @@ static int meson_rng_probe(struct platform_device *pdev)
 	if (IS_ERR(data->base))
 		return PTR_ERR(data->base);
 
-	data->core_clk = devm_clk_get_optional(dev, "core");
+	data->core_clk = devm_clk_get_optional_enabled(dev, "core");
 	if (IS_ERR(data->core_clk))
 		return dev_err_probe(dev, PTR_ERR(data->core_clk),
-				     "Failed to get core clock\n");
-
-	if (data->core_clk) {
-		ret = clk_prepare_enable(data->core_clk);
-		if (ret)
-			return ret;
-		ret = devm_add_action_or_reset(dev, meson_rng_clk_disable,
-					       data->core_clk);
-		if (ret)
-			return ret;
-	}
+				     "Failed to get enabled core clock\n");
 
 	data->rng.name = pdev->name;
 	data->rng.read = meson_rng_read;
-- 
2.35.1

