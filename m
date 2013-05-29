From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH 2/4] crypto: dcp: Use devm_* APIs
Date: Wed, 29 May 2013 17:09:10 +0530
Message-ID: <1369827552-28373-2-git-send-email-sachin.kamat@linaro.org>
References: <1369827552-28373-1-git-send-email-sachin.kamat@linaro.org>
Cc: herbert@gondor.apana.org.au, tobias.rauter@gmail.com,
	sachin.kamat@linaro.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:41163 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965418Ab3E2LxO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 May 2013 07:53:14 -0400
Received: by mail-pa0-f43.google.com with SMTP id hz10so85762pad.2
        for <linux-crypto@vger.kernel.org>; Wed, 29 May 2013 04:53:13 -0700 (PDT)
In-Reply-To: <1369827552-28373-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

devm_* APIs are device managed and make cleanup and exit
code simpler.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Tobias Rauter <tobias.rauter@gmail.com>
---
 drivers/crypto/dcp.c |   32 ++++++++++----------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/dcp.c b/drivers/crypto/dcp.c
index 83eaefc..9e91c2c 100644
--- a/drivers/crypto/dcp.c
+++ b/drivers/crypto/dcp.c
@@ -723,12 +723,10 @@ static int dcp_probe(struct platform_device *pdev)
 	struct resource *r;
 	int i, ret, j;
 
-	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-	if (dev == NULL) {
-		dev_err(&pdev->dev, "Failed to allocate structure\n");
-		ret = -ENOMEM;
-		goto err;
-	}
+	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+
 	global_dev = dev;
 	dev->dev = &pdev->dev;
 
@@ -737,11 +735,10 @@ static int dcp_probe(struct platform_device *pdev)
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!r) {
 		dev_err(&pdev->dev, "failed to get IORESOURCE_MEM\n");
-		ret = -ENXIO;
-		goto err_dev;
+		return -ENXIO;
 	}
-	dev->dcp_regs_base = ioremap(r->start, resource_size(r));
-
+	dev->dcp_regs_base = devm_ioremap(&pdev->dev, r->start,
+					  resource_size(r));
 
 	dcp_set(dev, DCP_CTRL_SFRST, DCP_REG_CTRL);
 	udelay(10);
@@ -762,15 +759,13 @@ static int dcp_probe(struct platform_device *pdev)
 	r = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!r) {
 		dev_err(&pdev->dev, "can't get IRQ resource (0)\n");
-		ret = -EIO;
-		goto err_unmap_mem;
+		return -EIO;
 	}
 	dev->dcp_vmi_irq = r->start;
 	ret = request_irq(dev->dcp_vmi_irq, dcp_vmi_irq, 0, "dcp", dev);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "can't request_irq (0)\n");
-		ret = -EIO;
-		goto err_unmap_mem;
+		return -EIO;
 	}
 
 	r = platform_get_resource(pdev, IORESOURCE_IRQ, 1);
@@ -863,11 +858,7 @@ err_free_irq1:
 	free_irq(dev->dcp_irq, dev);
 err_free_irq0:
 	free_irq(dev->dcp_vmi_irq, dev);
-err_unmap_mem:
-	iounmap((void *) dev->dcp_regs_base);
-err_dev:
-	kfree(dev);
-err:
+
 	return ret;
 }
 
@@ -890,14 +881,11 @@ static int dcp_remove(struct platform_device *pdev)
 	tasklet_kill(&dev->done_task);
 	tasklet_kill(&dev->queue_task);
 
-	iounmap((void *) dev->dcp_regs_base);
-
 	for (j = 0; j < ARRAY_SIZE(algs); j++)
 		crypto_unregister_alg(&algs[j]);
 
 	misc_deregister(&dev->dcp_bootstream_misc);
 
-	kfree(dev);
 	return 0;
 }
 
-- 
1.7.9.5
