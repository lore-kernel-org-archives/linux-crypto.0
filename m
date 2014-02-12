From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 1/4] crypto: picoxcell - Use devm_ioremap_resource()
Date: Wed, 12 Feb 2014 13:22:06 +0900
Message-ID: <000301cf27a9$fd5c61c0$f8152540$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: 'David Miller' <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	'Jingoo Han' <jg1.han@samsung.com>,
	'Mathias Krause' <mathias.krause@secunet.com>,
	'Jamie Iles' <jamie@jamieiles.com>
To: 'Herbert Xu' <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:13544 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaBLEWL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Feb 2014 23:22:11 -0500
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N0V00KGN84VUZ80@mailout4.samsung.com> for
 linux-crypto@vger.kernel.org; Wed, 12 Feb 2014 13:22:07 +0900 (KST)
Content-language: ko
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>From c0c9c31eba90635cac93f3d5e5311beb10afafb7 Mon Sep 17 00:00:00 2001
From: Jingoo Han <jg1.han@samsung.com>
Date: Wed, 12 Feb 2014 13:08:54 +0900
Subject: [PATCH 1/4] crypto: picoxcell - Use devm_ioremap_resource()

Use devm_ioremap_resource() in order to make the code simpler,
and remove redundant return value check of platform_get_resource()
because the value is checked by devm_ioremap_resource().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/crypto/picoxcell_crypto.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index a6175ba..5da5b98 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1720,22 +1720,16 @@ static int spacc_probe(struct platform_device *pdev)
 	engine->name = dev_name(&pdev->dev);
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	engine->regs = devm_ioremap_resource(&pdev->dev, mem);
+	if (IS_ERR(engine->regs))
+		return PTR_ERR(engine->regs);
+
 	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (!mem || !irq) {
+	if (!irq) {
 		dev_err(&pdev->dev, "no memory/irq resource for engine\n");
 		return -ENXIO;
 	}
 
-	if (!devm_request_mem_region(&pdev->dev, mem->start, resource_size(mem),
-				     engine->name))
-		return -ENOMEM;
-
-	engine->regs = devm_ioremap(&pdev->dev, mem->start, resource_size(mem));
-	if (!engine->regs) {
-		dev_err(&pdev->dev, "memory map failed\n");
-		return -ENOMEM;
-	}
-
 	if (devm_request_irq(&pdev->dev, irq->start, spacc_spacc_irq, 0,
 			     engine->name, engine)) {
 		dev_err(engine->dev, "failed to request IRQ\n");
-- 
1.7.10.4
