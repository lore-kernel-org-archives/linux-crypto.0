From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH] crypto: talitos - corrrectly handle zero-length assoc data
Date: Tue, 19 Nov 2013 14:57:49 +0200
Message-ID: <1384865869-24802-1-git-send-email-horia.geanta@freescale.com>
References: <1348080820-22250-4-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Kim Phillips <kim.phillips@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:4304
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752119Ab3KSNES (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Nov 2013 08:04:18 -0500
In-Reply-To: <1348080820-22250-4-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

talitos does not handle well zero-length assoc data. From dmesg:
talitos ffe30000.crypto: master data transfer error
talitos ffe30000.crypto: gather return/length error

Check whether assoc data is provided by inspecting assoclen,
not assoc pointer.
This is needed in order to pass testmgr tests.

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
This patch was submitted late in the 3.6 cycle, but has not
showed up - neither in 3.6 nor in 3.7. Please apply.

 drivers/crypto/talitos.c |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index f6f7c68..af3e7dc 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -788,7 +788,7 @@ static void ipsec_esp_unmap(struct device *dev,
 
 	if (edesc->assoc_chained)
 		talitos_unmap_sg_chain(dev, areq->assoc, DMA_TO_DEVICE);
-	else
+	else if (areq->assoclen)
 		/* assoc_nents counts also for IV in non-contiguous cases */
 		dma_unmap_sg(dev, areq->assoc,
 			     edesc->assoc_nents ? edesc->assoc_nents - 1 : 1,
@@ -971,7 +971,11 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
 					   edesc->dma_len, DMA_BIDIRECTIONAL);
 	} else {
-		to_talitos_ptr(&desc->ptr[1], sg_dma_address(areq->assoc));
+		if (areq->assoclen)
+			to_talitos_ptr(&desc->ptr[1],
+				       sg_dma_address(areq->assoc));
+		else
+			to_talitos_ptr(&desc->ptr[1], edesc->iv_dma);
 		desc->ptr[1].j_extent = 0;
 	}
 
@@ -1120,10 +1124,10 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 		return ERR_PTR(-EINVAL);
 	}
 
-	if (iv)
+	if (ivsize)
 		iv_dma = dma_map_single(dev, iv, ivsize, DMA_TO_DEVICE);
 
-	if (assoc) {
+	if (assoclen) {
 		/*
 		 * Currently it is assumed that iv is provided whenever assoc
 		 * is.
@@ -1171,9 +1175,16 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 
 	edesc = kmalloc(alloc_len, GFP_DMA | flags);
 	if (!edesc) {
-		talitos_unmap_sg_chain(dev, assoc, DMA_TO_DEVICE);
+		if (assoc_chained)
+			talitos_unmap_sg_chain(dev, assoc, DMA_TO_DEVICE);
+		else if (assoclen)
+			dma_unmap_sg(dev, assoc,
+				     assoc_nents ? assoc_nents - 1 : 1,
+				     DMA_TO_DEVICE);
+
 		if (iv_dma)
 			dma_unmap_single(dev, iv_dma, ivsize, DMA_TO_DEVICE);
+
 		dev_err(dev, "could not allocate edescriptor\n");
 		return ERR_PTR(-ENOMEM);
 	}
-- 
1.7.7.6
