From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 02/20] crypto: caam - fix input job ring element dma mapping size
Date: Fri, 22 Jun 2012 19:42:36 -0500
Message-ID: <1340412174-1784-3-git-send-email-kim.phillips@freescale.com>
References: <1340412174-1784-1-git-send-email-kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Kim Phillips <kim.phillips@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:53429
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756689Ab2FWApC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jun 2012 20:45:02 -0400
In-Reply-To: <1340412174-1784-1-git-send-email-kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

SEC4 h/w gets configured in 32- vs. 36-bit physical
addressing modes depending on the size of dma_addr_t,
which is not always equal to sizeof(u32 *).

Also fixed alignment of a dma_unmap call whilst in there.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/jr.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 340fa32..6ce4c41 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -376,7 +376,7 @@ static int caam_jr_init(struct device *dev)
 
 	/* Setup rings */
 	inpbusaddr = dma_map_single(dev, jrp->inpring,
-				    sizeof(u32 *) * JOBR_DEPTH,
+				    sizeof(dma_addr_t) * JOBR_DEPTH,
 				    DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(dev, inpbusaddr)) {
 		dev_err(dev, "caam_jr_init(): can't map input ring\n");
@@ -391,9 +391,9 @@ static int caam_jr_init(struct device *dev)
 				    DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(dev, outbusaddr)) {
 		dev_err(dev, "caam_jr_init(): can't map output ring\n");
-			dma_unmap_single(dev, inpbusaddr,
-					 sizeof(u32 *) * JOBR_DEPTH,
-					 DMA_BIDIRECTIONAL);
+		dma_unmap_single(dev, inpbusaddr,
+				 sizeof(dma_addr_t) * JOBR_DEPTH,
+				 DMA_BIDIRECTIONAL);
 		kfree(jrp->inpring);
 		kfree(jrp->outring);
 		kfree(jrp->entinfo);
@@ -447,7 +447,7 @@ int caam_jr_shutdown(struct device *dev)
 	dma_unmap_single(dev, outbusaddr,
 			 sizeof(struct jr_outentry) * JOBR_DEPTH,
 			 DMA_BIDIRECTIONAL);
-	dma_unmap_single(dev, inpbusaddr, sizeof(u32 *) * JOBR_DEPTH,
+	dma_unmap_single(dev, inpbusaddr, sizeof(dma_addr_t) * JOBR_DEPTH,
 			 DMA_BIDIRECTIONAL);
 	kfree(jrp->outring);
 	kfree(jrp->inpring);
-- 
1.7.11.1
