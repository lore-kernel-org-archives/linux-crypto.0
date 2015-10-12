From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 1/2] crypto: atmel: use devm_xxx() managed function
Date: Mon, 12 Oct 2015 19:47:03 +0200
Message-ID: <1444672025-21757-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	LABBE Corentin <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37998 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbbJLRrs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Oct 2015 13:47:48 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Using the devm_xxx() managed function to stripdown the error and remove
code.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/atmel-aes.c  | 38 +++++++++-----------------------------
 drivers/crypto/atmel-sha.c  | 27 +++++++++------------------
 drivers/crypto/atmel-tdes.c | 29 +++++++----------------------
 3 files changed, 25 insertions(+), 69 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index de8f5da..fb16d81 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -1324,7 +1324,6 @@ static int atmel_aes_probe(struct platform_device *pdev)
 	struct crypto_platform_data *pdata;
 	struct device *dev = &pdev->dev;
 	struct resource *aes_res;
-	unsigned long aes_phys_size;
 	int err;
 
 	pdata = pdev->dev.platform_data;
@@ -1341,7 +1340,7 @@ static int atmel_aes_probe(struct platform_device *pdev)
 		goto aes_dd_err;
 	}
 
-	aes_dd = kzalloc(sizeof(struct atmel_aes_dev), GFP_KERNEL);
+	aes_dd = devm_kzalloc(&pdev->dev, sizeof(*aes_dd), GFP_KERNEL);
 	if (aes_dd == NULL) {
 		dev_err(dev, "unable to alloc data struct.\n");
 		err = -ENOMEM;
@@ -1372,36 +1371,35 @@ static int atmel_aes_probe(struct platform_device *pdev)
 		goto res_err;
 	}
 	aes_dd->phys_base = aes_res->start;
-	aes_phys_size = resource_size(aes_res);
 
 	/* Get the IRQ */
 	aes_dd->irq = platform_get_irq(pdev,  0);
 	if (aes_dd->irq < 0) {
 		dev_err(dev, "no IRQ resource info\n");
 		err = aes_dd->irq;
-		goto aes_irq_err;
+		goto res_err;
 	}
 
-	err = request_irq(aes_dd->irq, atmel_aes_irq, IRQF_SHARED, "atmel-aes",
-						aes_dd);
+	err = devm_request_irq(&pdev->dev, aes_dd->irq, atmel_aes_irq,
+			       IRQF_SHARED, "atmel-aes", aes_dd);
 	if (err) {
 		dev_err(dev, "unable to request aes irq.\n");
-		goto aes_irq_err;
+		goto res_err;
 	}
 
 	/* Initializing the clock */
-	aes_dd->iclk = clk_get(&pdev->dev, "aes_clk");
+	aes_dd->iclk = devm_clk_get(&pdev->dev, "aes_clk");
 	if (IS_ERR(aes_dd->iclk)) {
 		dev_err(dev, "clock initialization failed.\n");
 		err = PTR_ERR(aes_dd->iclk);
-		goto clk_err;
+		goto res_err;
 	}
 
-	aes_dd->io_base = ioremap(aes_dd->phys_base, aes_phys_size);
+	aes_dd->io_base = devm_ioremap_resource(&pdev->dev, aes_res);
 	if (!aes_dd->io_base) {
 		dev_err(dev, "can't ioremap\n");
 		err = -ENOMEM;
-		goto aes_io_err;
+		goto res_err;
 	}
 
 	atmel_aes_hw_version_init(aes_dd);
@@ -1438,17 +1436,9 @@ err_algs:
 err_aes_dma:
 	atmel_aes_buff_cleanup(aes_dd);
 err_aes_buff:
-	iounmap(aes_dd->io_base);
-aes_io_err:
-	clk_put(aes_dd->iclk);
-clk_err:
-	free_irq(aes_dd->irq, aes_dd);
-aes_irq_err:
 res_err:
 	tasklet_kill(&aes_dd->done_task);
 	tasklet_kill(&aes_dd->queue_task);
-	kfree(aes_dd);
-	aes_dd = NULL;
 aes_dd_err:
 	dev_err(dev, "initialization failed.\n");
 
@@ -1473,16 +1463,6 @@ static int atmel_aes_remove(struct platform_device *pdev)
 
 	atmel_aes_dma_cleanup(aes_dd);
 
-	iounmap(aes_dd->io_base);
-
-	clk_put(aes_dd->iclk);
-
-	if (aes_dd->irq > 0)
-		free_irq(aes_dd->irq, aes_dd);
-
-	kfree(aes_dd);
-	aes_dd = NULL;
-
 	return 0;
 }
 
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 5e6cf08..660d8c0 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -1349,11 +1349,9 @@ static int atmel_sha_probe(struct platform_device *pdev)
 	struct crypto_platform_data	*pdata;
 	struct device *dev = &pdev->dev;
 	struct resource *sha_res;
-	unsigned long sha_phys_size;
 	int err;
 
-	sha_dd = devm_kzalloc(&pdev->dev, sizeof(struct atmel_sha_dev),
-				GFP_KERNEL);
+	sha_dd = devm_kzalloc(&pdev->dev, sizeof(*sha_dd), GFP_KERNEL);
 	if (sha_dd == NULL) {
 		dev_err(dev, "unable to alloc data struct.\n");
 		err = -ENOMEM;
@@ -1382,7 +1380,6 @@ static int atmel_sha_probe(struct platform_device *pdev)
 		goto res_err;
 	}
 	sha_dd->phys_base = sha_res->start;
-	sha_phys_size = resource_size(sha_res);
 
 	/* Get the IRQ */
 	sha_dd->irq = platform_get_irq(pdev,  0);
@@ -1392,26 +1389,26 @@ static int atmel_sha_probe(struct platform_device *pdev)
 		goto res_err;
 	}
 
-	err = request_irq(sha_dd->irq, atmel_sha_irq, IRQF_SHARED, "atmel-sha",
-						sha_dd);
+	err = devm_request_irq(&pdev->dev, sha_dd->irq, atmel_sha_irq,
+			       IRQF_SHARED, "atmel-sha", sha_dd);
 	if (err) {
 		dev_err(dev, "unable to request sha irq.\n");
 		goto res_err;
 	}
 
 	/* Initializing the clock */
-	sha_dd->iclk = clk_get(&pdev->dev, "sha_clk");
+	sha_dd->iclk = devm_clk_get(&pdev->dev, "sha_clk");
 	if (IS_ERR(sha_dd->iclk)) {
 		dev_err(dev, "clock initialization failed.\n");
 		err = PTR_ERR(sha_dd->iclk);
-		goto clk_err;
+		goto res_err;
 	}
 
-	sha_dd->io_base = ioremap(sha_dd->phys_base, sha_phys_size);
+	sha_dd->io_base = devm_ioremap_resource(&pdev->dev, sha_res);
 	if (!sha_dd->io_base) {
 		dev_err(dev, "can't ioremap\n");
 		err = -ENOMEM;
-		goto sha_io_err;
+		goto res_err;
 	}
 
 	atmel_sha_hw_version_init(sha_dd);
@@ -1425,12 +1422,12 @@ static int atmel_sha_probe(struct platform_device *pdev)
 			if (IS_ERR(pdata)) {
 				dev_err(&pdev->dev, "platform data not available\n");
 				err = PTR_ERR(pdata);
-				goto err_pdata;
+				goto res_err;
 			}
 		}
 		if (!pdata->dma_slave) {
 			err = -ENXIO;
-			goto err_pdata;
+			goto res_err;
 		}
 		err = atmel_sha_dma_init(sha_dd, pdata);
 		if (err)
@@ -1461,12 +1458,6 @@ err_algs:
 	if (sha_dd->caps.has_dma)
 		atmel_sha_dma_cleanup(sha_dd);
 err_sha_dma:
-err_pdata:
-	iounmap(sha_dd->io_base);
-sha_io_err:
-	clk_put(sha_dd->iclk);
-clk_err:
-	free_irq(sha_dd->irq, sha_dd);
 res_err:
 	tasklet_kill(&sha_dd->done_task);
 sha_dd_err:
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 504e903..2c7a628 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -1359,7 +1359,6 @@ static int atmel_tdes_probe(struct platform_device *pdev)
 	struct crypto_platform_data	*pdata;
 	struct device *dev = &pdev->dev;
 	struct resource *tdes_res;
-	unsigned long tdes_phys_size;
 	int err;
 
 	tdes_dd = devm_kmalloc(&pdev->dev, sizeof(*tdes_dd), GFP_KERNEL);
@@ -1393,7 +1392,6 @@ static int atmel_tdes_probe(struct platform_device *pdev)
 		goto res_err;
 	}
 	tdes_dd->phys_base = tdes_res->start;
-	tdes_phys_size = resource_size(tdes_res);
 
 	/* Get the IRQ */
 	tdes_dd->irq = platform_get_irq(pdev,  0);
@@ -1403,26 +1401,26 @@ static int atmel_tdes_probe(struct platform_device *pdev)
 		goto res_err;
 	}
 
-	err = request_irq(tdes_dd->irq, atmel_tdes_irq, IRQF_SHARED,
-			"atmel-tdes", tdes_dd);
+	err = devm_request_irq(&pdev->dev, tdes_dd->irq, atmel_tdes_irq,
+			       IRQF_SHARED, "atmel-tdes", tdes_dd);
 	if (err) {
 		dev_err(dev, "unable to request tdes irq.\n");
-		goto tdes_irq_err;
+		goto res_err;
 	}
 
 	/* Initializing the clock */
-	tdes_dd->iclk = clk_get(&pdev->dev, "tdes_clk");
+	tdes_dd->iclk = devm_clk_get(&pdev->dev, "tdes_clk");
 	if (IS_ERR(tdes_dd->iclk)) {
 		dev_err(dev, "clock initialization failed.\n");
 		err = PTR_ERR(tdes_dd->iclk);
-		goto clk_err;
+		goto res_err;
 	}
 
-	tdes_dd->io_base = ioremap(tdes_dd->phys_base, tdes_phys_size);
+	tdes_dd->io_base = devm_ioremap_resource(&pdev->dev, tdes_res);
 	if (!tdes_dd->io_base) {
 		dev_err(dev, "can't ioremap\n");
 		err = -ENOMEM;
-		goto tdes_io_err;
+		goto res_err;
 	}
 
 	atmel_tdes_hw_version_init(tdes_dd);
@@ -1478,12 +1476,6 @@ err_tdes_dma:
 err_pdata:
 	atmel_tdes_buff_cleanup(tdes_dd);
 err_tdes_buff:
-	iounmap(tdes_dd->io_base);
-tdes_io_err:
-	clk_put(tdes_dd->iclk);
-clk_err:
-	free_irq(tdes_dd->irq, tdes_dd);
-tdes_irq_err:
 res_err:
 	tasklet_kill(&tdes_dd->done_task);
 	tasklet_kill(&tdes_dd->queue_task);
@@ -1514,13 +1506,6 @@ static int atmel_tdes_remove(struct platform_device *pdev)
 
 	atmel_tdes_buff_cleanup(tdes_dd);
 
-	iounmap(tdes_dd->io_base);
-
-	clk_put(tdes_dd->iclk);
-
-	if (tdes_dd->irq >= 0)
-		free_irq(tdes_dd->irq, tdes_dd);
-
 	return 0;
 }
 
-- 
2.4.9
