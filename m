From: Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 1/2] crypto: sahara: Use devm_ioremap_resource()
Date: Sat, 22 Feb 2014 16:55:34 +0400
Message-ID: <1393073735-16092-1-git-send-email-shc_work@mail.ru>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Shawn Guo <shawn.guo@linaro.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	Alexander Shiyan <shc_work@mail.ru>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from fallback3.mail.ru ([94.100.176.58]:40354 "EHLO
	fallback3.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaBVM4H (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 22 Feb 2014 07:56:07 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use devm_ioremap_resource() in order to make the code simpler and
it gives proper codes on errors.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/crypto/sahara.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 785a9de..894468f 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -885,22 +885,9 @@ static int sahara_probe(struct platform_device *pdev)
 
 	/* Get the base address */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "failed to get memory region resource\n");
-		return -ENODEV;
-	}
-
-	if (devm_request_mem_region(&pdev->dev, res->start,
-			resource_size(res), SAHARA_NAME) == NULL) {
-		dev_err(&pdev->dev, "failed to request memory region\n");
-		return -ENOENT;
-	}
-	dev->regs_base = devm_ioremap(&pdev->dev, res->start,
-				      resource_size(res));
-	if (!dev->regs_base) {
-		dev_err(&pdev->dev, "failed to ioremap address region\n");
-		return -ENOENT;
-	}
+	dev->regs_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(dev->regs_base))
+		return PTR_ERR(dev->regs_base);
 
 	/* Get the IRQ */
 	irq = platform_get_irq(pdev,  0);
-- 
1.8.3.2
