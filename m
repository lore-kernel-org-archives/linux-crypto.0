From: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH RESEND v2 1/4] hwrng: atmel: use clk_prepapre_enable/_disable_unprepare
Date: Thu, 20 Nov 2014 10:43:22 +0100
Message-ID: <691ea59c733142d240b7ec7c6deb1607ff150744.1416475860.git.nicolas.ferre@atmel.com>
References: <cover.1416475860.git.nicolas.ferre@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-kernel@vger.kernel.org>, <mpm@selenic.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Alexandre Belloni <alexandre.belloni@free-electrons.com>,
	Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
	<robh+dt@kernel.org>, <mark.rutland@arm.com>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<peter@korsgaard.com>
To: <linux-arm-kernel@lists.infradead.org>,
	<herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:38792 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757346AbaKTJnt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 Nov 2014 04:43:49 -0500
In-Reply-To: <cover.1416475860.git.nicolas.ferre@atmel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Boris Brezillon <boris.brezillon@free-electrons.com>

Use clk_prepare_enable/_disable_unprepare instead of clk_enable/disable
to work properly with the CCF.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Acked-by: Peter Korsgaard <peter@korsgaard.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/char/hw_random/atmel-rng.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/atmel-rng.c
index 851bc7e20ad2..644ec4882206 100644
--- a/drivers/char/hw_random/atmel-rng.c
+++ b/drivers/char/hw_random/atmel-rng.c
@@ -67,7 +67,7 @@ static int atmel_trng_probe(struct platform_device *pdev)
 	if (IS_ERR(trng->clk))
 		return PTR_ERR(trng->clk);
 
-	ret = clk_enable(trng->clk);
+	ret = clk_prepare_enable(trng->clk);
 	if (ret)
 		return ret;
 
@@ -95,7 +95,7 @@ static int atmel_trng_remove(struct platform_device *pdev)
 	hwrng_unregister(&trng->rng);
 
 	writel(TRNG_KEY, trng->base + TRNG_CR);
-	clk_disable(trng->clk);
+	clk_disable_unprepare(trng->clk);
 
 	return 0;
 }
@@ -105,7 +105,7 @@ static int atmel_trng_suspend(struct device *dev)
 {
 	struct atmel_trng *trng = dev_get_drvdata(dev);
 
-	clk_disable(trng->clk);
+	clk_disable_unprepare(trng->clk);
 
 	return 0;
 }
@@ -114,7 +114,7 @@ static int atmel_trng_resume(struct device *dev)
 {
 	struct atmel_trng *trng = dev_get_drvdata(dev);
 
-	return clk_enable(trng->clk);
+	return clk_prepare_enable(trng->clk);
 }
 
 static const struct dev_pm_ops atmel_trng_pm_ops = {
-- 
2.1.3
