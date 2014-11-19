From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH RESEND 1/4] hwrng: atmel: use clk_prepapre_enable/_disable_unprepare
Date: Wed, 19 Nov 2014 17:07:55 +0100
Message-ID: <1416413278-10197-2-git-send-email-boris.brezillon@free-electrons.com>
References: <1416413278-10197-1-git-send-email-boris.brezillon@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Alexandre Belloni <alexandre.belloni@free-electrons.com>,
	Andrew Victor <linux@maxim.org.za>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	Boris Brezillon <boris.brezillon@free-electrons.com>
To: Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:39893 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932383AbaKSQID (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Nov 2014 11:08:03 -0500
In-Reply-To: <1416413278-10197-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use clk_prepare_enable/_disable_unprepare instead of clk_enable/disable
to work properly with the CCF.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Acked-by: Peter Korsgaard <peter@korsgaard.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/char/hw_random/atmel-rng.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/atmel-rng.c
index 851bc7e..644ec48 100644
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
1.9.1
