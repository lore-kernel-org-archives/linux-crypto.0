From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 3/8] crypto: omap-sham: rename sgl to sgl_tmp for deprecation
Date: Mon, 19 Sep 2016 18:22:14 +0300
Message-ID: <1474298539-23897-4-git-send-email-t-kristo@ti.com>
References: <1474298539-23897-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>
To: <herbert@gondor.apana.org.au>, <lokeshvutla@ti.com>,
        <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:53479 "EHLO comal.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932115AbcISPXN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Sep 2016 11:23:13 -0400
In-Reply-To: <1474298539-23897-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The current usage of sgl will be deprecated, and will be replaced by an
array required by the sg based driver implementation. Rename the existing
variable as sgl_tmp so that it can be removed from the driver easily later.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 drivers/crypto/omap-sham.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 3f2bf98..33bea52 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -151,7 +151,7 @@ struct omap_sham_reqctx {
 
 	/* walk state */
 	struct scatterlist	*sg;
-	struct scatterlist	sgl;
+	struct scatterlist	sgl_tmp;
 	unsigned int		offset;	/* offset in current sg */
 	unsigned int		total;	/* total request */
 
@@ -583,18 +583,19 @@ static int omap_sham_xmit_dma(struct omap_sham_dev *dd, dma_addr_t dma_addr,
 	if (is_sg) {
 		/*
 		 * The SG entry passed in may not have the 'length' member
-		 * set correctly so use a local SG entry (sgl) with the
+		 * set correctly so use a local SG entry (sgl_tmp) with the
 		 * proper value for 'length' instead.  If this is not done,
 		 * the dmaengine may try to DMA the incorrect amount of data.
 		 */
-		sg_init_table(&ctx->sgl, 1);
-		sg_assign_page(&ctx->sgl, sg_page(ctx->sg));
-		ctx->sgl.offset = ctx->sg->offset;
-		sg_dma_len(&ctx->sgl) = len32;
-		sg_dma_address(&ctx->sgl) = sg_dma_address(ctx->sg);
-
-		tx = dmaengine_prep_slave_sg(dd->dma_lch, &ctx->sgl, 1,
-			DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+		sg_init_table(&ctx->sgl_tmp, 1);
+		sg_assign_page(&ctx->sgl_tmp, sg_page(ctx->sg));
+		ctx->sgl_tmp.offset = ctx->sg->offset;
+		sg_dma_len(&ctx->sgl_tmp) = len32;
+		sg_dma_address(&ctx->sgl_tmp) = sg_dma_address(ctx->sg);
+
+		tx = dmaengine_prep_slave_sg(dd->dma_lch, &ctx->sgl_tmp, 1,
+					     DMA_MEM_TO_DEV,
+					     DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	} else {
 		tx = dmaengine_prep_slave_single(dd->dma_lch, dma_addr, len32,
 			DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
-- 
1.9.1
