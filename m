From: Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 2/2] crypto: sahara: Use return value of devm_request_irq() on error
Date: Sat, 22 Feb 2014 16:55:35 +0400
Message-ID: <1393073735-16092-2-git-send-email-shc_work@mail.ru>
References: <1393073735-16092-1-git-send-email-shc_work@mail.ru>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Shawn Guo <shawn.guo@linaro.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	Alexander Shiyan <shc_work@mail.ru>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from fallback7.mail.ru ([94.100.176.135]:47638 "EHLO
	fallback7.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaBVM4B (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 22 Feb 2014 07:56:01 -0500
In-Reply-To: <1393073735-16092-1-git-send-email-shc_work@mail.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/crypto/sahara.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 894468f..07a5987 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -896,10 +896,11 @@ static int sahara_probe(struct platform_device *pdev)
 		return irq;
 	}
 
-	if (devm_request_irq(&pdev->dev, irq, sahara_irq_handler,
-		0, SAHARA_NAME, dev) < 0) {
+	err = devm_request_irq(&pdev->dev, irq, sahara_irq_handler,
+			       0, dev_name(&pdev->dev), dev);
+	if (err) {
 		dev_err(&pdev->dev, "failed to request irq\n");
-		return -ENOENT;
+		return err;
 	}
 
 	/* clocks */
-- 
1.8.3.2
