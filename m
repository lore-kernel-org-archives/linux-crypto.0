From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 14/20] crypto: caam - assign 40-bit masks on SEC v5.0 and above
Date: Fri, 22 Jun 2012 19:48:51 -0500
Message-ID: <1340412537-2325-9-git-send-email-kim.phillips@freescale.com>
References: <1340412174-1784-1-git-send-email-kim.phillips@freescale.com>
 <1340412537-2325-1-git-send-email-kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:46206
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756753Ab2FWAu4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jun 2012 20:50:56 -0400
In-Reply-To: <1340412537-2325-1-git-send-email-kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

SEC v4.x were only 36-bit, SEC v5+ are 40-bit capable.
Also set a DMA mask for any job ring devices created.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/ctrl.c | 9 +++++++--
 drivers/crypto/caam/jr.c   | 8 ++++++++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 77557eb..9a2db9c 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -82,13 +82,18 @@ static int caam_probe(struct platform_device *pdev)
 
 	/*
 	 * Enable DECO watchdogs and, if this is a PHYS_ADDR_T_64BIT kernel,
-	 * 36-bit pointers in master configuration register
+	 * long pointers in master configuration register
 	 */
 	setbits32(&topregs->ctrl.mcr, MCFGR_WDENABLE |
 		  (sizeof(dma_addr_t) == sizeof(u64) ? MCFGR_LONG_PTR : 0));
 
 	if (sizeof(dma_addr_t) == sizeof(u64))
-		dma_set_mask(dev, DMA_BIT_MASK(36));
+		if (of_device_is_compatible(nprop, "fsl,sec-v5.0"))
+			dma_set_mask(dev, DMA_BIT_MASK(40));
+		else
+			dma_set_mask(dev, DMA_BIT_MASK(36));
+	else
+		dma_set_mask(dev, DMA_BIT_MASK(32));
 
 	/*
 	 * Detect and enable JobRs
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 6ce4c41..9f16b2c 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -503,6 +503,14 @@ int caam_jr_probe(struct platform_device *pdev, struct device_node *np,
 	dev_set_drvdata(jrdev, jrpriv);
 	ctrlpriv->jrdev[ring] = jrdev;
 
+	if (sizeof(dma_addr_t) == sizeof(u64))
+		if (of_device_is_compatible(np, "fsl,sec-v5.0-job-ring"))
+			dma_set_mask(jrdev, DMA_BIT_MASK(40));
+		else
+			dma_set_mask(jrdev, DMA_BIT_MASK(36));
+	else
+		dma_set_mask(jrdev, DMA_BIT_MASK(32));
+
 	/* Identify the interrupt */
 	jrpriv->irq = of_irq_to_resource(np, 0, NULL);
 
-- 
1.7.11.1
