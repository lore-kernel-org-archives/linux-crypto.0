From: Sonic Zhang <sonic.adi@gmail.com>
Subject: [PATCH] crypt: bfin_crc: Remove useless SSYNC instruction and cache flush to DMA coherent memory
Date: Wed, 26 Feb 2014 10:39:16 +0800
Message-ID: <1393382356-9422-1-git-send-email-sonic.adi@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
	<adi-buildroot-devel@lists.sourceforge.net>,
	Sonic Zhang <sonic.zhang@analog.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:6918
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751399AbaBZCgn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Feb 2014 21:36:43 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Sonic Zhang <sonic.zhang@analog.com>

1) SSYNC instruction is blackfin specific and takes no effect in this driver.
2) DMA descriptor and SG middle buffer are in DMA coherent memory. No need
to flush.
3) Turn kzalloc, ioremap and request_irq into managed device APIs respectively.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/crypto/bfin_crc.c | 45 +++++++++++----------------------------------
 1 file changed, 11 insertions(+), 34 deletions(-)

diff --git a/drivers/crypto/bfin_crc.c b/drivers/crypto/bfin_crc.c
index d797f31..c9ff298 100644
--- a/drivers/crypto/bfin_crc.c
+++ b/drivers/crypto/bfin_crc.c
@@ -139,7 +139,6 @@ static int bfin_crypto_crc_init_hw(struct bfin_crypto_crc *crc, u32 key)
 	/* setup CRC interrupts */
 	crc->regs->status = CMPERRI | DCNTEXPI;
 	crc->regs->intrenset = CMPERRI | DCNTEXPI;
-	SSYNC();
 
 	return 0;
 }
@@ -285,17 +284,12 @@ static void bfin_crypto_crc_config_dma(struct bfin_crypto_crc *crc)
 	if (i == 0)
 		return;
 
-	flush_dcache_range((unsigned int)crc->sg_cpu,
-			(unsigned int)crc->sg_cpu +
-			i * sizeof(struct dma_desc_array));
-
 	/* Set the last descriptor to stop mode */
 	crc->sg_cpu[i - 1].cfg &= ~(DMAFLOW | NDSIZE);
 	crc->sg_cpu[i - 1].cfg |= DI_EN;
 	set_dma_curr_desc_addr(crc->dma_ch, (unsigned long *)crc->sg_dma);
 	set_dma_x_count(crc->dma_ch, 0);
 	set_dma_x_modify(crc->dma_ch, 0);
-	SSYNC();
 	set_dma_config(crc->dma_ch, dma_config);
 }
 
@@ -415,7 +409,6 @@ finish_update:
 
 	/* finally kick off CRC operation */
 	crc->regs->control |= BLKEN;
-	SSYNC();
 
 	return -EINPROGRESS;
 }
@@ -539,7 +532,6 @@ static irqreturn_t bfin_crypto_crc_handler(int irq, void *dev_id)
 
 	if (crc->regs->status & DCNTEXP) {
 		crc->regs->status = DCNTEXP;
-		SSYNC();
 
 		/* prepare results */
 		put_unaligned_le32(crc->regs->result, crc->req->result);
@@ -594,7 +586,7 @@ static int bfin_crypto_crc_probe(struct platform_device *pdev)
 	unsigned int timeout = 100000;
 	int ret;
 
-	crc = kzalloc(sizeof(*crc), GFP_KERNEL);
+	crc = devm_kzalloc(dev, sizeof(*crc), GFP_KERNEL);
 	if (!crc) {
 		dev_err(&pdev->dev, "fail to malloc bfin_crypto_crc\n");
 		return -ENOMEM;
@@ -610,42 +602,39 @@ static int bfin_crypto_crc_probe(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res == NULL) {
 		dev_err(&pdev->dev, "Cannot get IORESOURCE_MEM\n");
-		ret = -ENOENT;
-		goto out_error_free_mem;
+		return -ENOENT;
 	}
 
-	crc->regs = ioremap(res->start, resource_size(res));
-	if (!crc->regs) {
+	crc->regs = devm_ioremap_resource(dev, res);
+	if (IS_ERR((void *)crc->regs)) {
 		dev_err(&pdev->dev, "Cannot map CRC IO\n");
-		ret = -ENXIO;
-		goto out_error_free_mem;
+		return PTR_ERR((void *)crc->regs);
 	}
 
 	crc->irq = platform_get_irq(pdev, 0);
 	if (crc->irq < 0) {
 		dev_err(&pdev->dev, "No CRC DCNTEXP IRQ specified\n");
-		ret = -ENOENT;
-		goto out_error_unmap;
+		return -ENOENT;
 	}
 
-	ret = request_irq(crc->irq, bfin_crypto_crc_handler, IRQF_SHARED, dev_name(dev), crc);
+	ret = devm_request_irq(dev, crc->irq, bfin_crypto_crc_handler,
+			IRQF_SHARED, dev_name(dev), crc);
 	if (ret) {
 		dev_err(&pdev->dev, "Unable to request blackfin crc irq\n");
-		goto out_error_unmap;
+		return ret;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_DMA, 0);
 	if (res == NULL) {
 		dev_err(&pdev->dev, "No CRC DMA channel specified\n");
-		ret = -ENOENT;
-		goto out_error_irq;
+		return -ENOENT;
 	}
 	crc->dma_ch = res->start;
 
 	ret = request_dma(crc->dma_ch, dev_name(dev));
 	if (ret) {
 		dev_err(&pdev->dev, "Unable to attach Blackfin CRC DMA channel\n");
-		goto out_error_irq;
+		return ret;
 	}
 
 	crc->sg_cpu = dma_alloc_coherent(&pdev->dev, PAGE_SIZE, &crc->sg_dma, GFP_KERNEL);
@@ -660,9 +649,7 @@ static int bfin_crypto_crc_probe(struct platform_device *pdev)
 	crc->sg_mid_buf = (u8 *)(crc->sg_cpu + ((CRC_MAX_DMA_DESC + 1) << 1));
 
 	crc->regs->control = 0;
-	SSYNC();
 	crc->regs->poly = crc->poly = (u32)pdev->dev.platform_data;
-	SSYNC();
 
 	while (!(crc->regs->status & LUTDONE) && (--timeout) > 0)
 		cpu_relax();
@@ -693,12 +680,6 @@ out_error_dma:
 	if (crc->sg_cpu)
 		dma_free_coherent(&pdev->dev, PAGE_SIZE, crc->sg_cpu, crc->sg_dma);
 	free_dma(crc->dma_ch);
-out_error_irq:
-	free_irq(crc->irq, crc);
-out_error_unmap:
-	iounmap((void *)crc->regs);
-out_error_free_mem:
-	kfree(crc);
 
 	return ret;
 }
@@ -721,10 +702,6 @@ static int bfin_crypto_crc_remove(struct platform_device *pdev)
 	crypto_unregister_ahash(&algs);
 	tasklet_kill(&crc->done_task);
 	free_dma(crc->dma_ch);
-	if (crc->irq > 0)
-		free_irq(crc->irq, crc);
-	iounmap((void *)crc->regs);
-	kfree(crc);
 
 	return 0;
 }
-- 
1.8.2.3
