From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 2/4] crypto: sahara - Use devm_ioremap_resource()
Date: Wed, 12 Feb 2014 13:23:37 +0900
Message-ID: <000401cf27aa$339cee80$9ad6cb80$%han@samsung.com>
References: <000301cf27a9$fd5c61c0$f8152540$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: 'David Miller' <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	'Jingoo Han' <jg1.han@samsung.com>,
	'Javier Martin' <javier.martin@vista-silicon.com>
To: 'Herbert Xu' <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:64283 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaBLEXk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Feb 2014 23:23:40 -0500
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N0V00J3587EQK20@mailout3.samsung.com> for
 linux-crypto@vger.kernel.org; Wed, 12 Feb 2014 13:23:38 +0900 (KST)
In-reply-to: <000301cf27a9$fd5c61c0$f8152540$%han@samsung.com>
Content-language: ko
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use devm_ioremap_resource() in order to make the code simpler,
and remove redundant return value check of platform_get_resource()
because the value is checked by devm_ioremap_resource().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/crypto/sahara.c |   19 +++----------------
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
1.7.10.4
