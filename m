Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC1D1C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Feb 2022 07:58:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346665AbiBUH7B (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Feb 2022 02:59:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346664AbiBUH64 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Feb 2022 02:58:56 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B66A511A2F;
        Sun, 20 Feb 2022 23:58:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1645430312; x=1676966312;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9DmYH6VExId9ntaWhJNRnc2b1ZNu8Cgo16IxS2usahI=;
  b=XeiomlDADzcl3jK86uIIsP5NIGqwc/Fa0CYw+1f4MMe0dd2dn8KETV/w
   98yWlG0ICrjgPbfAxEt0i4HsaYvH2dMqpNQFjMEUAhoxKluFQGZLN+R8H
   OQQ1KMMZ2P5mzAc7hgbWfyy96zV4CQnThBJ9K8cRmCBsxNfjiiX7wHwsQ
   PztUXJ/GwXXTFTCkOhxEfqtjW2iz8OQSTlMTNS2THS0jjEgwDnx/SthNW
   82XVeGZdJUNgOfD7UCFJDV94G2Km77aahg7NrtRZBtxLxXIQONCfTxsZh
   kIUyp2fR7E9rfVPh1paN5nn7YK+9TW6VK5PaI3HKhaOu90f2cBo9qvlNV
   A==;
X-IronPort-AV: E=Sophos;i="5.88,385,1635231600"; 
   d="scan'208";a="86422656"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Feb 2022 00:58:31 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 21 Feb 2022 00:58:31 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 21 Feb 2022 00:58:29 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <mpm@selenic.com>, <herbert@gondor.apana.org.au>,
        <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH v2 4/7] hwrng: atmel - move set of TRNG_HALFR in atmel_trng_init()
Date:   Mon, 21 Feb 2022 09:59:25 +0200
Message-ID: <20220221075928.563806-5-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220221075928.563806-1-claudiu.beznea@microchip.com>
References: <20220221075928.563806-1-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Move set of TRNG_HALFR in atmel_trng_init() as this function is
also called on resume path. In case of SAMA7G5 where backup and
self-refresh PM mode is available most of the SoC parts are
powered of (including TRNG) when entering suspend. In that case
on resuming path TRNG_HALFR should also be re-configured.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/char/hw_random/atmel-rng.c | 49 +++++++++++++++---------------
 1 file changed, 25 insertions(+), 24 deletions(-)

diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/atmel-rng.c
index 17f02049c112..ef49dbe681cf 100644
--- a/drivers/char/hw_random/atmel-rng.c
+++ b/drivers/char/hw_random/atmel-rng.c
@@ -36,6 +36,7 @@ struct atmel_trng {
 	struct clk *clk;
 	void __iomem *base;
 	struct hwrng rng;
+	bool has_half_rate;
 };
 
 static bool atmel_trng_wait_ready(struct atmel_trng *trng, bool wait)
@@ -74,14 +75,32 @@ static int atmel_trng_read(struct hwrng *rng, void *buf, size_t max,
 	return ret;
 }
 
-static void atmel_trng_init(struct atmel_trng *trng)
+static int atmel_trng_init(struct atmel_trng *trng)
 {
+	unsigned long rate;
+	int ret;
+
+	ret = clk_prepare_enable(trng->clk);
+	if (ret)
+		return ret;
+
+	if (trng->has_half_rate) {
+		rate = clk_get_rate(trng->clk);
+
+		/* if peripheral clk is above 100MHz, set HALFR */
+		if (rate > 100000000)
+			writel(TRNG_HALFR, trng->base + TRNG_MR);
+	}
+
 	writel(TRNG_KEY | 1, trng->base + TRNG_CR);
+
+	return 0;
 }
 
 static void atmel_trng_cleanup(struct atmel_trng *trng)
 {
 	writel(TRNG_KEY, trng->base + TRNG_CR);
+	clk_disable_unprepare(trng->clk);
 }
 
 static int atmel_trng_probe(struct platform_device *pdev)
@@ -105,22 +124,14 @@ static int atmel_trng_probe(struct platform_device *pdev)
 	if (!data)
 		return -ENODEV;
 
-	if (data->has_half_rate) {
-		unsigned long rate = clk_get_rate(trng->clk);
-
-		/* if peripheral clk is above 100MHz, set HALFR */
-		if (rate > 100000000)
-			writel(TRNG_HALFR, trng->base + TRNG_MR);
-	}
+	trng->has_half_rate = data->has_half_rate;
+	trng->rng.name = pdev->name;
+	trng->rng.read = atmel_trng_read;
 
-	ret = clk_prepare_enable(trng->clk);
+	ret = atmel_trng_init(trng);
 	if (ret)
 		return ret;
 
-	atmel_trng_init(trng);
-	trng->rng.name = pdev->name;
-	trng->rng.read = atmel_trng_read;
-
 	ret = devm_hwrng_register(&pdev->dev, &trng->rng);
 	if (ret)
 		goto err_register;
@@ -130,7 +141,6 @@ static int atmel_trng_probe(struct platform_device *pdev)
 	return 0;
 
 err_register:
-	clk_disable_unprepare(trng->clk);
 	atmel_trng_cleanup(trng);
 	return ret;
 }
@@ -141,7 +151,6 @@ static int atmel_trng_remove(struct platform_device *pdev)
 
 
 	atmel_trng_cleanup(trng);
-	clk_disable_unprepare(trng->clk);
 
 	return 0;
 }
@@ -152,7 +161,6 @@ static int atmel_trng_suspend(struct device *dev)
 	struct atmel_trng *trng = dev_get_drvdata(dev);
 
 	atmel_trng_cleanup(trng);
-	clk_disable_unprepare(trng->clk);
 
 	return 0;
 }
@@ -160,15 +168,8 @@ static int atmel_trng_suspend(struct device *dev)
 static int atmel_trng_resume(struct device *dev)
 {
 	struct atmel_trng *trng = dev_get_drvdata(dev);
-	int ret;
 
-	ret = clk_prepare_enable(trng->clk);
-	if (ret)
-		return ret;
-
-	atmel_trng_init(trng);
-
-	return 0;
+	return atmel_trng_init(trng);
 }
 
 static const struct dev_pm_ops atmel_trng_pm_ops = {
-- 
2.32.0

