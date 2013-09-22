From: Fabio Estevam <festevam@gmail.com>
Subject: [PATCH 2/3] crypto: dcp: Use devm_request_irq()
Date: Sun, 22 Sep 2013 14:42:26 -0300
Message-ID: <1379871747-17570-2-git-send-email-festevam@gmail.com>
References: <1379871747-17570-1-git-send-email-festevam@gmail.com>
Cc: tobias.rauter@gmail.com, linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yh0-f53.google.com ([209.85.213.53]:43423 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab3IVRmh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 22 Sep 2013 13:42:37 -0400
Received: by mail-yh0-f53.google.com with SMTP id b20so991406yha.40
        for <linux-crypto@vger.kernel.org>; Sun, 22 Sep 2013 10:42:37 -0700 (PDT)
In-Reply-To: <1379871747-17570-1-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

Using Use devm_request_irq() can make the code smaller and simpler, as we do
not need to call free_irq() in the probe error path and in the remove function.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/crypto/dcp.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/dcp.c b/drivers/crypto/dcp.c
index 90a7cb7..93ab753 100644
--- a/drivers/crypto/dcp.c
+++ b/drivers/crypto/dcp.c
@@ -757,7 +757,8 @@ static int dcp_probe(struct platform_device *pdev)
 		return -EIO;
 	}
 	dev->dcp_vmi_irq = r->start;
-	ret = request_irq(dev->dcp_vmi_irq, dcp_vmi_irq, 0, "dcp", dev);
+	ret = devm_request_irq(&pdev->dev, dev->dcp_vmi_irq, dcp_vmi_irq, 0,
+			       "dcp", dev);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "can't request_irq (0)\n");
 		return -EIO;
@@ -766,15 +767,14 @@ static int dcp_probe(struct platform_device *pdev)
 	r = platform_get_resource(pdev, IORESOURCE_IRQ, 1);
 	if (!r) {
 		dev_err(&pdev->dev, "can't get IRQ resource (1)\n");
-		ret = -EIO;
-		goto err_free_irq0;
+		return -EIO;
 	}
 	dev->dcp_irq = r->start;
-	ret = request_irq(dev->dcp_irq, dcp_irq, 0, "dcp", dev);
+	ret = devm_request_irq(&pdev->dev, dev->dcp_irq, dcp_irq, 0, "dcp",
+			       dev);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "can't request_irq (1)\n");
-		ret = -EIO;
-		goto err_free_irq0;
+		return -EIO;
 	}
 
 	dev->hw_pkg[0] = dma_alloc_coherent(&pdev->dev,
@@ -783,8 +783,7 @@ static int dcp_probe(struct platform_device *pdev)
 			GFP_KERNEL);
 	if (!dev->hw_pkg[0]) {
 		dev_err(&pdev->dev, "Could not allocate hw descriptors\n");
-		ret = -ENOMEM;
-		goto err_free_irq1;
+		return -ENOMEM;
 	}
 
 	for (i = 1; i < DCP_MAX_PKG; i++) {
@@ -849,10 +848,6 @@ err_free_hw_packet:
 	dma_free_coherent(&pdev->dev, DCP_MAX_PKG *
 		sizeof(struct dcp_hw_packet), dev->hw_pkg[0],
 		dev->hw_phys_pkg);
-err_free_irq1:
-	free_irq(dev->dcp_irq, dev);
-err_free_irq0:
-	free_irq(dev->dcp_vmi_irq, dev);
 
 	return ret;
 }
@@ -870,9 +865,6 @@ static int dcp_remove(struct platform_device *pdev)
 	dma_free_coherent(&pdev->dev, 2 * AES_KEYSIZE_128, dev->payload_base,
 			dev->payload_base_dma);
 
-	free_irq(dev->dcp_irq, dev);
-	free_irq(dev->dcp_vmi_irq, dev);
-
 	tasklet_kill(&dev->done_task);
 	tasklet_kill(&dev->queue_task);
 
-- 
1.8.1.2
