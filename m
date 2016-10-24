From: Wenyou Yang <wenyou.yang@atmel.com>
Subject: [PATCH v1] char: hw_random: atmel-rng: disable TRNG during suspend
Date: Mon, 24 Oct 2016 16:03:28 +0800
Message-ID: <1477296208-28335-1-git-send-email-wenyou.yang@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
        Wenyou Yang <wenyou.yang@microchip.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Wenyou Yang <wenyou.yang@atmel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Matt Mackall <mpm@selenic.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:48391 "EHLO
        eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934130AbcJXIHG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Oct 2016 04:07:06 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

To fix the over consumption on the VDDCore due to the TRNG enabled,
disable the TRNG during suspend, not only disable the user interface
clock (which is controlled by PMC). Because the user interface clock
is independent from any clock that may be used in the entropy source
logic circuitry.

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---

 drivers/char/hw_random/atmel-rng.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/atmel-rng.c
index 0fcc9e6..2e2d09a 100644
--- a/drivers/char/hw_random/atmel-rng.c
+++ b/drivers/char/hw_random/atmel-rng.c
@@ -48,6 +48,16 @@ static int atmel_trng_read(struct hwrng *rng, void *buf, size_t max,
 		return 0;
 }
 
+static void atmel_trng_enable(struct atmel_trng *trng)
+{
+	writel(TRNG_KEY | 1, trng->base + TRNG_CR);
+}
+
+static void atmel_trng_disable(struct atmel_trng *trng)
+{
+	writel(TRNG_KEY, trng->base + TRNG_CR);
+}
+
 static int atmel_trng_probe(struct platform_device *pdev)
 {
 	struct atmel_trng *trng;
@@ -71,7 +81,7 @@ static int atmel_trng_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	writel(TRNG_KEY | 1, trng->base + TRNG_CR);
+	atmel_trng_enable(trng);
 	trng->rng.name = pdev->name;
 	trng->rng.read = atmel_trng_read;
 
@@ -94,7 +104,7 @@ static int atmel_trng_remove(struct platform_device *pdev)
 
 	hwrng_unregister(&trng->rng);
 
-	writel(TRNG_KEY, trng->base + TRNG_CR);
+	atmel_trng_disable(trng);
 	clk_disable_unprepare(trng->clk);
 
 	return 0;
@@ -105,6 +115,7 @@ static int atmel_trng_suspend(struct device *dev)
 {
 	struct atmel_trng *trng = dev_get_drvdata(dev);
 
+	atmel_trng_disable(trng);
 	clk_disable_unprepare(trng->clk);
 
 	return 0;
@@ -114,6 +125,7 @@ static int atmel_trng_resume(struct device *dev)
 {
 	struct atmel_trng *trng = dev_get_drvdata(dev);
 
+	atmel_trng_enable(trng);
 	return clk_prepare_enable(trng->clk);
 }
 
-- 
2.7.4
