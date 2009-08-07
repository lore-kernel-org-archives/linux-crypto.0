From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 3/3] crypto: talitos - add support for 36 bit addressing
Date: Fri, 7 Aug 2009 18:40:43 -0500
Message-ID: <20090807184043.5aac4290.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@ozlabs.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:55416 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757099AbZHGXkt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Aug 2009 19:40:49 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Enabling extended addressing in the h/w requires we always assign the
extended address component (eptr) of the talitos h/w pointer.  This is
for e500 based platforms with large memories.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/talitos.c |   69 ++++++++++++++++++++++++++-------------------
 drivers/crypto/talitos.h |    1 +
 2 files changed, 41 insertions(+), 29 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 5013a2d..c47ffe8 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -146,6 +146,12 @@ struct talitos_private {
 #define TALITOS_FTR_SRC_LINK_TBL_LEN_INCLUDES_EXTENT 0x00000001
 #define TALITOS_FTR_HW_AUTH_CHECK 0x00000002
 
+static void to_talitos_ptr(struct talitos_ptr *talitos_ptr, dma_addr_t dma_addr)
+{
+	talitos_ptr->ptr = cpu_to_be32(lower_32_bits(dma_addr));
+	talitos_ptr->eptr = cpu_to_be32(upper_32_bits(dma_addr));
+}
+
 /*
  * map virtual single (contiguous) pointer to h/w descriptor pointer
  */
@@ -155,8 +161,10 @@ static void map_single_talitos_ptr(struct device *dev,
 				   unsigned char extent,
 				   enum dma_data_direction dir)
 {
+	dma_addr_t dma_addr = dma_map_single(dev, data, len, dir);
+
 	talitos_ptr->len = cpu_to_be16(len);
-	talitos_ptr->ptr = cpu_to_be32(dma_map_single(dev, data, len, dir));
+	to_talitos_ptr(talitos_ptr, dma_addr);
 	talitos_ptr->j_extent = extent;
 }
 
@@ -187,9 +195,9 @@ static int reset_channel(struct device *dev, int ch)
 		return -EIO;
 	}
 
-	/* set done writeback and IRQ */
-	setbits32(priv->reg + TALITOS_CCCR_LO(ch), TALITOS_CCCR_LO_CDWE |
-		  TALITOS_CCCR_LO_CDIE);
+	/* set 36-bit addressing, done writeback enable and done IRQ enable */
+	setbits32(priv->reg + TALITOS_CCCR_LO(ch), TALITOS_CCCR_LO_EAE |
+		  TALITOS_CCCR_LO_CDWE | TALITOS_CCCR_LO_CDIE);
 
 	/* and ICCR writeback, if available */
 	if (priv->features & TALITOS_FTR_HW_AUTH_CHECK)
@@ -312,7 +320,10 @@ static int talitos_submit(struct device *dev, struct talitos_desc *desc,
 
 	/* GO! */
 	wmb();
-	out_be32(priv->reg + TALITOS_FF_LO(ch), request->dma_desc);
+	out_be32(priv->reg + TALITOS_FF(ch),
+		 cpu_to_be32(upper_32_bits(request->dma_desc)));
+	out_be32(priv->reg + TALITOS_FF_LO(ch),
+		 cpu_to_be32(lower_32_bits(request->dma_desc)));
 
 	spin_unlock_irqrestore(&priv->chan[ch].head_lock, flags);
 
@@ -934,7 +945,7 @@ static int sg_to_link_tbl(struct scatterlist *sg, int sg_count,
 	int n_sg = sg_count;
 
 	while (n_sg--) {
-		link_tbl_ptr->ptr = cpu_to_be32(sg_dma_address(sg));
+		to_talitos_ptr(link_tbl_ptr, sg_dma_address(sg));
 		link_tbl_ptr->len = cpu_to_be16(sg_dma_len(sg));
 		link_tbl_ptr->j_extent = 0;
 		link_tbl_ptr++;
@@ -1009,7 +1020,7 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 				  edesc->src_is_chained);
 
 	if (sg_count == 1) {
-		desc->ptr[4].ptr = cpu_to_be32(sg_dma_address(areq->src));
+		to_talitos_ptr(&desc->ptr[4], sg_dma_address(areq->src));
 	} else {
 		sg_link_tbl_len = cryptlen;
 
@@ -1020,14 +1031,14 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 					  &edesc->link_tbl[0]);
 		if (sg_count > 1) {
 			desc->ptr[4].j_extent |= DESC_PTR_LNKTBL_JUMP;
-			desc->ptr[4].ptr = cpu_to_be32(edesc->dma_link_tbl);
+			to_talitos_ptr(&desc->ptr[4], edesc->dma_link_tbl);
 			dma_sync_single_for_device(dev, edesc->dma_link_tbl,
 						   edesc->dma_len,
 						   DMA_BIDIRECTIONAL);
 		} else {
 			/* Only one segment now, so no link tbl needed */
-			desc->ptr[4].ptr = cpu_to_be32(sg_dma_address(areq->
-								      src));
+			to_talitos_ptr(&desc->ptr[4],
+				       sg_dma_address(areq->src));
 		}
 	}
 
@@ -1042,14 +1053,14 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 					  edesc->dst_is_chained);
 
 	if (sg_count == 1) {
-		desc->ptr[5].ptr = cpu_to_be32(sg_dma_address(areq->dst));
+		to_talitos_ptr(&desc->ptr[5], sg_dma_address(areq->dst));
 	} else {
 		struct talitos_ptr *link_tbl_ptr =
 			&edesc->link_tbl[edesc->src_nents + 1];
 
-		desc->ptr[5].ptr = cpu_to_be32((struct talitos_ptr *)
-					       edesc->dma_link_tbl +
-					       edesc->src_nents + 1);
+		to_talitos_ptr(&desc->ptr[5], edesc->dma_link_tbl +
+			       (edesc->src_nents + 1) *
+			       sizeof(struct talitos_ptr));
 		sg_count = sg_to_link_tbl(areq->dst, sg_count, cryptlen,
 					  link_tbl_ptr);
 
@@ -1062,11 +1073,9 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 		link_tbl_ptr->len = cpu_to_be16(authsize);
 
 		/* icv data follows link tables */
-		link_tbl_ptr->ptr = cpu_to_be32((struct talitos_ptr *)
-						edesc->dma_link_tbl +
-					        edesc->src_nents +
-						edesc->dst_nents + 2);
-
+		to_talitos_ptr(link_tbl_ptr, edesc->dma_link_tbl +
+			       (edesc->src_nents + edesc->dst_nents + 2) *
+			       sizeof(struct talitos_ptr));
 		desc->ptr[5].j_extent |= DESC_PTR_LNKTBL_JUMP;
 		dma_sync_single_for_device(ctx->dev, edesc->dma_link_tbl,
 					   edesc->dma_len, DMA_BIDIRECTIONAL);
@@ -1341,7 +1350,7 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 
 	/* first DWORD empty */
 	desc->ptr[0].len = 0;
-	desc->ptr[0].ptr = 0;
+	to_talitos_ptr(&desc->ptr[0], 0);
 	desc->ptr[0].j_extent = 0;
 
 	/* cipher iv */
@@ -1365,20 +1374,20 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 				  edesc->src_is_chained);
 
 	if (sg_count == 1) {
-		desc->ptr[3].ptr = cpu_to_be32(sg_dma_address(areq->src));
+		to_talitos_ptr(&desc->ptr[3], sg_dma_address(areq->src));
 	} else {
 		sg_count = sg_to_link_tbl(areq->src, sg_count, cryptlen,
 					  &edesc->link_tbl[0]);
 		if (sg_count > 1) {
+			to_talitos_ptr(&desc->ptr[3], edesc->dma_link_tbl);
 			desc->ptr[3].j_extent |= DESC_PTR_LNKTBL_JUMP;
-			desc->ptr[3].ptr = cpu_to_be32(edesc->dma_link_tbl);
 			dma_sync_single_for_device(dev, edesc->dma_link_tbl,
 						   edesc->dma_len,
 						   DMA_BIDIRECTIONAL);
 		} else {
 			/* Only one segment now, so no link tbl needed */
-			desc->ptr[3].ptr = cpu_to_be32(sg_dma_address(areq->
-								      src));
+			to_talitos_ptr(&desc->ptr[3],
+				       sg_dma_address(areq->src));
 		}
 	}
 
@@ -1393,15 +1402,15 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 					  edesc->dst_is_chained);
 
 	if (sg_count == 1) {
-		desc->ptr[4].ptr = cpu_to_be32(sg_dma_address(areq->dst));
+		to_talitos_ptr(&desc->ptr[4], sg_dma_address(areq->dst));
 	} else {
 		struct talitos_ptr *link_tbl_ptr =
 			&edesc->link_tbl[edesc->src_nents + 1];
 
+		to_talitos_ptr(&desc->ptr[4], edesc->dma_link_tbl +
+					      (edesc->src_nents + 1) *
+					      sizeof(struct talitos_ptr));
 		desc->ptr[4].j_extent |= DESC_PTR_LNKTBL_JUMP;
-		desc->ptr[4].ptr = cpu_to_be32((struct talitos_ptr *)
-					       edesc->dma_link_tbl +
-					       edesc->src_nents + 1);
 		sg_count = sg_to_link_tbl(areq->dst, sg_count, cryptlen,
 					  link_tbl_ptr);
 		dma_sync_single_for_device(ctx->dev, edesc->dma_link_tbl,
@@ -1414,7 +1423,7 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 
 	/* last DWORD empty */
 	desc->ptr[6].len = 0;
-	desc->ptr[6].ptr = 0;
+	to_talitos_ptr(&desc->ptr[6], 0);
 	desc->ptr[6].j_extent = 0;
 
 	ret = talitos_submit(dev, desc, callback, areq);
@@ -1898,6 +1907,8 @@ static int talitos_probe(struct of_device *ofdev,
 		atomic_set(&priv->chan[i].submit_count,
 			   -(priv->chfifo_len - 1));
 
+	dma_set_mask(dev, DMA_BIT_MASK(36));
+
 	/* reset and initialize the h/w */
 	err = init_device(dev);
 	if (err) {
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 575981f..ff5a145 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -57,6 +57,7 @@
 #define   TALITOS_CCCR_RESET		0x1    /* channel reset */
 #define TALITOS_CCCR_LO(ch)		(ch * TALITOS_CH_STRIDE + 0x110c)
 #define   TALITOS_CCCR_LO_IWSE		0x80   /* chan. ICCR writeback enab. */
+#define   TALITOS_CCCR_LO_EAE		0x20   /* extended address enable */
 #define   TALITOS_CCCR_LO_CDWE		0x10   /* chan. done writeback enab. */
 #define   TALITOS_CCCR_LO_NT		0x4    /* notification type */
 #define   TALITOS_CCCR_LO_CDIE		0x2    /* channel done IRQ enable */
-- 
1.6.3

