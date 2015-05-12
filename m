From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 6/8] async_tx: adding mult and sum_product flags
Date: Tue, 12 May 2015 17:37:41 +0200
Message-ID: <1431445063-20226-7-git-send-email-maxime.ripard@free-electrons.com>
References: <1431445063-20226-1-git-send-email-maxime.ripard@free-electrons.com>
Cc: dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Lior Amsalem <alior@marvell.com>,
	Thomas Petazzoni <thomas@free-electrons.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Gregory Clement <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:57315 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753338AbbELPkP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 May 2015 11:40:15 -0400
In-Reply-To: <1431445063-20226-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Lior Amsalem <alior@marvell.com>

Some engines (like Marvell mv_xor) do not support mult and sum_product
operations as part of the pq support.

This patch adds new flags: DMA_PREP_PQ_MULT & DMA_PREP_PQ_SUM_PRODUCT these
flags helps the driver identify such operations.

Signed-off-by: Lior Amsalem <alior@marvell.com>
Reviewed-by: Ofer Heifetz <oferh@marvell.com>
Reviewed-by: Nadav Haklai <nadavh@marvell.com>
Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 crypto/async_tx/async_raid6_recov.c | 4 ++--
 include/linux/dmaengine.h           | 4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/async_raid6_recov.c
index 934a84981495..2db5486fd873 100644
--- a/crypto/async_tx/async_raid6_recov.c
+++ b/crypto/async_tx/async_raid6_recov.c
@@ -47,7 +47,7 @@ async_sum_product(struct page *dest, struct page **srcs, unsigned char *coef,
 		struct device *dev = dma->dev;
 		dma_addr_t pq[2];
 		struct dma_async_tx_descriptor *tx;
-		enum dma_ctrl_flags dma_flags = DMA_PREP_PQ_DISABLE_P;
+		enum dma_ctrl_flags dma_flags = DMA_PREP_PQ_DISABLE_P | DMA_PREP_PQ_SUM_PRODUCT;
 
 		if (submit->flags & ASYNC_TX_FENCE)
 			dma_flags |= DMA_PREP_FENCE;
@@ -111,7 +111,7 @@ async_mult(struct page *dest, struct page *src, u8 coef, size_t len,
 		dma_addr_t dma_dest[2];
 		struct device *dev = dma->dev;
 		struct dma_async_tx_descriptor *tx;
-		enum dma_ctrl_flags dma_flags = DMA_PREP_PQ_DISABLE_P;
+		enum dma_ctrl_flags dma_flags = DMA_PREP_PQ_DISABLE_P | DMA_PREP_PQ_MULT;
 
 		if (submit->flags & ASYNC_TX_FENCE)
 			dma_flags |= DMA_PREP_FENCE;
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index ad419757241f..f19ecebb4d3f 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -174,6 +174,8 @@ struct dma_interleaved_template {
  *  operation it continues the calculation with new sources
  * @DMA_PREP_FENCE - tell the driver that subsequent operations depend
  *  on the result of this operation
+ * @DMA_PREP_PQ_MULT - tell the driver that this is a mult request
+ * @DMA_PREP_PQ_SUM_PRODUCT - tell the driver that this is a sum product request
  */
 enum dma_ctrl_flags {
 	DMA_PREP_INTERRUPT = (1 << 0),
@@ -182,6 +184,8 @@ enum dma_ctrl_flags {
 	DMA_PREP_PQ_DISABLE_Q = (1 << 3),
 	DMA_PREP_CONTINUE = (1 << 4),
 	DMA_PREP_FENCE = (1 << 5),
+	DMA_PREP_PQ_MULT = (1 << 10),
+	DMA_PREP_PQ_SUM_PRODUCT = (1 << 11),
 };
 
 /**
-- 
2.4.0
