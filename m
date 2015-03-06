From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v2 04/17] crypto: talitos - Refactor the sg in/out chain allocation
Date: Fri,  6 Mar 2015 17:38:45 +0100 (CET)
Message-ID: <20150306163845.9F2AB1A241C@localhost.localdomain>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:53987 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbbCFQis (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Mar 2015 11:38:48 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch refactors the handling of the input and output data that is quite
similar in several functions

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
 drivers/crypto/talitos.c | 163 ++++++++++++++++++++++++-----------------------
 1 file changed, 85 insertions(+), 78 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index de4d93b..3165364 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1339,16 +1339,26 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *cipher,
 	return 0;
 }
 
+static void unmap_sg_talitos_ptr(struct device *dev, struct scatterlist *src,
+				 struct scatterlist *dst, unsigned int len,
+				 struct talitos_edesc *edesc,
+				 struct talitos_ptr *ptr_in,
+				 struct talitos_ptr *ptr_out)
+{
+	talitos_sg_unmap(dev, edesc, src, dst);
+}
+
 static void common_nonsnoop_unmap(struct device *dev,
 				  struct talitos_edesc *edesc,
 				  struct ablkcipher_request *areq)
 {
 	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[5], DMA_FROM_DEVICE);
+
+	unmap_sg_talitos_ptr(dev, areq->src, areq->dst, areq->nbytes, edesc,
+			     &edesc->desc.ptr[3], &edesc->desc.ptr[4]);
 	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[2], DMA_TO_DEVICE);
 	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[1], DMA_TO_DEVICE);
 
-	talitos_sg_unmap(dev, edesc, areq->src, areq->dst);
-
 	if (edesc->dma_len)
 		dma_unmap_single(dev, edesc->dma_link_tbl, edesc->dma_len,
 				 DMA_BIDIRECTIONAL);
@@ -1370,6 +1380,65 @@ static void ablkcipher_done(struct device *dev,
 	areq->base.complete(&areq->base, err);
 }
 
+int map_sg_in_talitos_ptr(struct device *dev, struct scatterlist *src,
+			  unsigned int len, struct talitos_edesc *edesc,
+			  enum dma_data_direction dir, struct talitos_ptr *ptr)
+{
+	int sg_count;
+
+	ptr->len = cpu_to_be16(len);
+	ptr->j_extent = 0;
+
+	sg_count = talitos_map_sg(dev, src, edesc->src_nents ? : 1, dir,
+				  edesc->src_chained);
+
+	if (sg_count == 1) {
+		to_talitos_ptr(ptr, sg_dma_address(src));
+	} else {
+		sg_count = sg_to_link_tbl(src, sg_count, len,
+					  &edesc->link_tbl[0]);
+		if (sg_count > 1) {
+			to_talitos_ptr(ptr, edesc->dma_link_tbl);
+			ptr->j_extent |= DESC_PTR_LNKTBL_JUMP;
+			dma_sync_single_for_device(dev, edesc->dma_link_tbl,
+						   edesc->dma_len,
+						   DMA_BIDIRECTIONAL);
+		} else {
+			/* Only one segment now, so no link tbl needed */
+			to_talitos_ptr(ptr, sg_dma_address(src));
+		}
+	}
+	return sg_count;
+}
+
+void map_sg_out_talitos_ptr(struct device *dev, struct scatterlist *dst,
+			    unsigned int len, struct talitos_edesc *edesc,
+			    enum dma_data_direction dir,
+			    struct talitos_ptr *ptr, int sg_count)
+{
+	ptr->len = cpu_to_be16(len);
+	ptr->j_extent = 0;
+
+	if (dir != DMA_NONE)
+		sg_count = talitos_map_sg(dev, dst, edesc->dst_nents ? : 1,
+					  dir, edesc->dst_chained);
+
+	if (sg_count == 1) {
+		to_talitos_ptr(ptr, sg_dma_address(dst));
+	} else {
+		struct talitos_ptr *link_tbl_ptr =
+			&edesc->link_tbl[edesc->src_nents + 1];
+
+		to_talitos_ptr(ptr, edesc->dma_link_tbl +
+					      (edesc->src_nents + 1) *
+					      sizeof(struct talitos_ptr));
+		ptr->j_extent |= DESC_PTR_LNKTBL_JUMP;
+		sg_count = sg_to_link_tbl(dst, sg_count, len, link_tbl_ptr);
+		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
+					   edesc->dma_len, DMA_BIDIRECTIONAL);
+	}
+}
+
 static int common_nonsnoop(struct talitos_edesc *edesc,
 			   struct ablkcipher_request *areq,
 			   void (*callback) (struct device *dev,
@@ -1399,56 +1468,16 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 	/*
 	 * cipher in
 	 */
-	desc->ptr[3].len = cpu_to_be16(cryptlen);
-	desc->ptr[3].j_extent = 0;
-
-	sg_count = talitos_map_sg(dev, areq->src, edesc->src_nents ? : 1,
-				  (areq->src == areq->dst) ? DMA_BIDIRECTIONAL
-							   : DMA_TO_DEVICE,
-				  edesc->src_chained);
-
-	if (sg_count == 1) {
-		to_talitos_ptr(&desc->ptr[3], sg_dma_address(areq->src));
-	} else {
-		sg_count = sg_to_link_tbl(areq->src, sg_count, cryptlen,
-					  &edesc->link_tbl[0]);
-		if (sg_count > 1) {
-			to_talitos_ptr(&desc->ptr[3], edesc->dma_link_tbl);
-			desc->ptr[3].j_extent |= DESC_PTR_LNKTBL_JUMP;
-			dma_sync_single_for_device(dev, edesc->dma_link_tbl,
-						   edesc->dma_len,
-						   DMA_BIDIRECTIONAL);
-		} else {
-			/* Only one segment now, so no link tbl needed */
-			to_talitos_ptr(&desc->ptr[3],
-				       sg_dma_address(areq->src));
-		}
-	}
+	sg_count = map_sg_in_talitos_ptr(dev, areq->src, cryptlen, edesc,
+			      (areq->src == areq->dst) ? DMA_BIDIRECTIONAL
+						       : DMA_TO_DEVICE,
+			      &desc->ptr[3]);
 
 	/* cipher out */
-	desc->ptr[4].len = cpu_to_be16(cryptlen);
-	desc->ptr[4].j_extent = 0;
-
-	if (areq->src != areq->dst)
-		sg_count = talitos_map_sg(dev, areq->dst,
-					  edesc->dst_nents ? : 1,
-					  DMA_FROM_DEVICE, edesc->dst_chained);
-
-	if (sg_count == 1) {
-		to_talitos_ptr(&desc->ptr[4], sg_dma_address(areq->dst));
-	} else {
-		struct talitos_ptr *link_tbl_ptr =
-			&edesc->link_tbl[edesc->src_nents + 1];
-
-		to_talitos_ptr(&desc->ptr[4], edesc->dma_link_tbl +
-					      (edesc->src_nents + 1) *
-					      sizeof(struct talitos_ptr));
-		desc->ptr[4].j_extent |= DESC_PTR_LNKTBL_JUMP;
-		sg_count = sg_to_link_tbl(areq->dst, sg_count, cryptlen,
-					  link_tbl_ptr);
-		dma_sync_single_for_device(ctx->dev, edesc->dma_link_tbl,
-					   edesc->dma_len, DMA_BIDIRECTIONAL);
-	}
+	map_sg_out_talitos_ptr(dev, areq->dst, cryptlen, edesc,
+			      (areq->src == areq->dst) ? DMA_NONE
+						       : DMA_FROM_DEVICE,
+			      &desc->ptr[4], sg_count);
 
 	/* iv out */
 	map_single_talitos_ptr(dev, &desc->ptr[5], ivsize, ctx->iv, 0,
@@ -1518,6 +1547,9 @@ static void common_nonsnoop_hash_unmap(struct device *dev,
 
 	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[5], DMA_FROM_DEVICE);
 
+	unmap_sg_talitos_ptr(dev, req_ctx->psrc, NULL, 0, edesc,
+			     &edesc->desc.ptr[3], NULL);
+
 	/* When using hashctx-in, must unmap it. */
 	if (edesc->desc.ptr[1].len)
 		unmap_single_talitos_ptr(dev, &edesc->desc.ptr[1],
@@ -1527,8 +1559,6 @@ static void common_nonsnoop_hash_unmap(struct device *dev,
 		unmap_single_talitos_ptr(dev, &edesc->desc.ptr[2],
 					 DMA_TO_DEVICE);
 
-	talitos_sg_unmap(dev, edesc, req_ctx->psrc, NULL);
-
 	if (edesc->dma_len)
 		dma_unmap_single(dev, edesc->dma_link_tbl, edesc->dma_len,
 				 DMA_BIDIRECTIONAL);
@@ -1567,7 +1597,7 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 	struct device *dev = ctx->dev;
 	struct talitos_desc *desc = &edesc->desc;
-	int sg_count, ret;
+	int ret;
 
 	/* first DWORD empty */
 	desc->ptr[0] = zero_entry;
@@ -1595,31 +1625,8 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 	/*
 	 * data in
 	 */
-	desc->ptr[3].len = cpu_to_be16(length);
-	desc->ptr[3].j_extent = 0;
-
-	sg_count = talitos_map_sg(dev, req_ctx->psrc,
-				  edesc->src_nents ? : 1,
-				  DMA_TO_DEVICE, edesc->src_chained);
-
-	if (sg_count == 1) {
-		to_talitos_ptr(&desc->ptr[3], sg_dma_address(req_ctx->psrc));
-	} else {
-		sg_count = sg_to_link_tbl(req_ctx->psrc, sg_count, length,
-					  &edesc->link_tbl[0]);
-		if (sg_count > 1) {
-			desc->ptr[3].j_extent |= DESC_PTR_LNKTBL_JUMP;
-			to_talitos_ptr(&desc->ptr[3], edesc->dma_link_tbl);
-			dma_sync_single_for_device(ctx->dev,
-						   edesc->dma_link_tbl,
-						   edesc->dma_len,
-						   DMA_BIDIRECTIONAL);
-		} else {
-			/* Only one segment now, so no link tbl needed */
-			to_talitos_ptr(&desc->ptr[3],
-				       sg_dma_address(req_ctx->psrc));
-		}
-	}
+	map_sg_in_talitos_ptr(dev, req_ctx->psrc, length, edesc,
+			      DMA_TO_DEVICE, &desc->ptr[3]);
 
 	/* fifth DWORD empty */
 	desc->ptr[4] = zero_entry;
-- 
2.1.0
