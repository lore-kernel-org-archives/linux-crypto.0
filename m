From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 02/12] crypto: caam - check return code of dma_set_mask_and_coherent()
Date: Fri, 10 Feb 2017 14:07:15 +0200
Message-ID: <1486728445-13047-3-git-send-email-horia.geanta@nxp.com>
References: <1486728445-13047-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Dan Douglass <dan.douglass@nxp.com>,
        Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
        "Cristian Stoica" <cristian.stoica@nxp.com>,
        <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-cys01nam02on0063.outbound.protection.outlook.com ([104.47.37.63]:35008
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753303AbdBJMHu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Feb 2017 07:07:50 -0500
In-Reply-To: <1486728445-13047-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Setting the dma mask could fail, thus make sure it succeeds
before going further.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/ctrl.c | 15 ++++++++++-----
 drivers/crypto/caam/jr.c   | 19 ++++++++++++++-----
 2 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 8957ec952212..f825e3765a4b 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -586,13 +586,18 @@ static int caam_probe(struct platform_device *pdev)
 			      JRSTART_JR1_START | JRSTART_JR2_START |
 			      JRSTART_JR3_START);
 
-	if (sizeof(dma_addr_t) == sizeof(u64))
+	if (sizeof(dma_addr_t) == sizeof(u64)) {
 		if (of_device_is_compatible(nprop, "fsl,sec-v5.0"))
-			dma_set_mask_and_coherent(dev, DMA_BIT_MASK(40));
+			ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(40));
 		else
-			dma_set_mask_and_coherent(dev, DMA_BIT_MASK(36));
-	else
-		dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
+			ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(36));
+	} else {
+		ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
+	}
+	if (ret) {
+		dev_err(dev, "dma_set_mask_and_coherent failed (%d)\n", ret);
+		goto iounmap_ctrl;
+	}
 
 	/*
 	 * Detect and enable JobRs
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index c8604dfadbf5..27631000b9f8 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -498,13 +498,22 @@ static int caam_jr_probe(struct platform_device *pdev)
 
 	jrpriv->rregs = (struct caam_job_ring __iomem __force *)ctrl;
 
-	if (sizeof(dma_addr_t) == sizeof(u64))
+	if (sizeof(dma_addr_t) == sizeof(u64)) {
 		if (of_device_is_compatible(nprop, "fsl,sec-v5.0-job-ring"))
-			dma_set_mask_and_coherent(jrdev, DMA_BIT_MASK(40));
+			error = dma_set_mask_and_coherent(jrdev,
+							  DMA_BIT_MASK(40));
 		else
-			dma_set_mask_and_coherent(jrdev, DMA_BIT_MASK(36));
-	else
-		dma_set_mask_and_coherent(jrdev, DMA_BIT_MASK(32));
+			error = dma_set_mask_and_coherent(jrdev,
+							  DMA_BIT_MASK(36));
+	} else {
+		error = dma_set_mask_and_coherent(jrdev, DMA_BIT_MASK(32));
+	}
+	if (error) {
+		dev_err(jrdev, "dma_set_mask_and_coherent failed (%d)\n",
+			error);
+		iounmap(ctrl);
+		return error;
+	}
 
 	/* Identify the interrupt */
 	jrpriv->irq = irq_of_parse_and_map(nprop, 0);
-- 
2.4.4
