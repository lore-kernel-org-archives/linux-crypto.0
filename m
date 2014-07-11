From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH 02/10] crypto: caam - set coherent_dma_mask
Date: Fri, 11 Jul 2014 15:34:47 +0300
Message-ID: <1405082095-30146-3-git-send-email-horia.geanta@freescale.com>
References: <1405082095-30146-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Ruchika Gupta <ruchika.gupta@freescale.com>,
	Vakul Garg <vakul@freescale.com>,
	Kim Phillips <kim.phillips@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:53551
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753508AbaGKMgO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Jul 2014 08:36:14 -0400
In-Reply-To: <1405082095-30146-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Replace dma_set_mask with dma_set_mask_and_coherent, since both
streaming and coherent DMA mappings are being used.

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/caam/ctrl.c | 6 +++---
 drivers/crypto/caam/jr.c   | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index c6e9d3b2d502..cedb56500b61 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -453,11 +453,11 @@ static int caam_probe(struct platform_device *pdev)
 
 	if (sizeof(dma_addr_t) == sizeof(u64))
 		if (of_device_is_compatible(nprop, "fsl,sec-v5.0"))
-			dma_set_mask(dev, DMA_BIT_MASK(40));
+			dma_set_mask_and_coherent(dev, DMA_BIT_MASK(40));
 		else
-			dma_set_mask(dev, DMA_BIT_MASK(36));
+			dma_set_mask_and_coherent(dev, DMA_BIT_MASK(36));
 	else
-		dma_set_mask(dev, DMA_BIT_MASK(32));
+		dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
 
 	/*
 	 * Detect and enable JobRs
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 1d80bd3636c5..50cd1b9af2ba 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -476,11 +476,11 @@ static int caam_jr_probe(struct platform_device *pdev)
 
 	if (sizeof(dma_addr_t) == sizeof(u64))
 		if (of_device_is_compatible(nprop, "fsl,sec-v5.0-job-ring"))
-			dma_set_mask(jrdev, DMA_BIT_MASK(40));
+			dma_set_mask_and_coherent(jrdev, DMA_BIT_MASK(40));
 		else
-			dma_set_mask(jrdev, DMA_BIT_MASK(36));
+			dma_set_mask_and_coherent(jrdev, DMA_BIT_MASK(36));
 	else
-		dma_set_mask(jrdev, DMA_BIT_MASK(32));
+		dma_set_mask_and_coherent(jrdev, DMA_BIT_MASK(32));
 
 	/* Identify the interrupt */
 	jrpriv->irq = irq_of_parse_and_map(nprop, 0);
-- 
1.8.3.1
