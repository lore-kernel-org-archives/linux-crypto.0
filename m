From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH 3/5] crypto: talitos - change type and name for [src|dst]_is_chained
Date: Thu, 2 Aug 2012 17:16:39 +0300
Message-ID: <1343917001-20001-3-git-send-email-horia.geanta@freescale.com>
References: <1343917001-20001-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Kim Phillips <kim.phillips@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:13330
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752669Ab2HBORm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Aug 2012 10:17:42 -0400
In-Reply-To: <1343917001-20001-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

It's more natural to think of these vars as bool rather than int.

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/talitos.c |   41 ++++++++++++++++++++---------------------
 1 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 940b09d..0ec8894 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -716,6 +716,8 @@ badkey:
  * talitos_edesc - s/w-extended descriptor
  * @src_nents: number of segments in input scatterlist
  * @dst_nents: number of segments in output scatterlist
+ * @src_chained: whether src is chained or not
+ * @dst_chained: whether dst is chained or not
  * @dma_len: length of dma mapped link_tbl space
  * @dma_link_tbl: bus physical address of link_tbl
  * @desc: h/w descriptor
@@ -728,8 +730,8 @@ badkey:
 struct talitos_edesc {
 	int src_nents;
 	int dst_nents;
-	int src_is_chained;
-	int dst_is_chained;
+	bool src_chained;
+	bool dst_chained;
 	int dma_len;
 	dma_addr_t dma_link_tbl;
 	struct talitos_desc desc;
@@ -738,7 +740,7 @@ struct talitos_edesc {
 
 static int talitos_map_sg(struct device *dev, struct scatterlist *sg,
 			  unsigned int nents, enum dma_data_direction dir,
-			  int chained)
+			  bool chained)
 {
 	if (unlikely(chained))
 		while (sg) {
@@ -768,13 +770,13 @@ static void talitos_sg_unmap(struct device *dev,
 	unsigned int dst_nents = edesc->dst_nents ? : 1;
 
 	if (src != dst) {
-		if (edesc->src_is_chained)
+		if (edesc->src_chained)
 			talitos_unmap_sg_chain(dev, src, DMA_TO_DEVICE);
 		else
 			dma_unmap_sg(dev, src, src_nents, DMA_TO_DEVICE);
 
 		if (dst) {
-			if (edesc->dst_is_chained)
+			if (edesc->dst_chained)
 				talitos_unmap_sg_chain(dev, dst,
 						       DMA_FROM_DEVICE);
 			else
@@ -782,7 +784,7 @@ static void talitos_sg_unmap(struct device *dev,
 					     DMA_FROM_DEVICE);
 		}
 	} else
-		if (edesc->src_is_chained)
+		if (edesc->src_chained)
 			talitos_unmap_sg_chain(dev, src, DMA_BIDIRECTIONAL);
 		else
 			dma_unmap_sg(dev, src, src_nents, DMA_BIDIRECTIONAL);
@@ -974,7 +976,7 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	sg_count = talitos_map_sg(dev, areq->src, edesc->src_nents ? : 1,
 				  (areq->src == areq->dst) ? DMA_BIDIRECTIONAL
 							   : DMA_TO_DEVICE,
-				  edesc->src_is_chained);
+				  edesc->src_chained);
 
 	if (sg_count == 1) {
 		to_talitos_ptr(&desc->ptr[4], sg_dma_address(areq->src));
@@ -1006,8 +1008,7 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	if (areq->src != areq->dst)
 		sg_count = talitos_map_sg(dev, areq->dst,
 					  edesc->dst_nents ? : 1,
-					  DMA_FROM_DEVICE,
-					  edesc->dst_is_chained);
+					  DMA_FROM_DEVICE, edesc->dst_chained);
 
 	if (sg_count == 1) {
 		to_talitos_ptr(&desc->ptr[5], sg_dma_address(areq->dst));
@@ -1053,17 +1054,17 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 /*
  * derive number of elements in scatterlist
  */
-static int sg_count(struct scatterlist *sg_list, int nbytes, int *chained)
+static int sg_count(struct scatterlist *sg_list, int nbytes, bool *chained)
 {
 	struct scatterlist *sg = sg_list;
 	int sg_nents = 0;
 
-	*chained = 0;
+	*chained = false;
 	while (nbytes > 0) {
 		sg_nents++;
 		nbytes -= sg->length;
 		if (!sg_is_last(sg) && (sg + 1)->length == 0)
-			*chained = 1;
+			*chained = true;
 		sg = scatterwalk_sg_next(sg);
 	}
 
@@ -1141,7 +1142,7 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 {
 	struct talitos_edesc *edesc;
 	int src_nents, dst_nents, alloc_len, dma_len;
-	int src_chained, dst_chained = 0;
+	bool src_chained, dst_chained = false;
 	gfp_t flags = cryptoflags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
 		      GFP_ATOMIC;
 
@@ -1188,8 +1189,8 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 
 	edesc->src_nents = src_nents;
 	edesc->dst_nents = dst_nents;
-	edesc->src_is_chained = src_chained;
-	edesc->dst_is_chained = dst_chained;
+	edesc->src_chained = src_chained;
+	edesc->dst_chained = dst_chained;
 	edesc->dma_len = dma_len;
 	if (dma_len)
 		edesc->dma_link_tbl = dma_map_single(dev, &edesc->link_tbl[0],
@@ -1381,7 +1382,7 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 	sg_count = talitos_map_sg(dev, areq->src, edesc->src_nents ? : 1,
 				  (areq->src == areq->dst) ? DMA_BIDIRECTIONAL
 							   : DMA_TO_DEVICE,
-				  edesc->src_is_chained);
+				  edesc->src_chained);
 
 	if (sg_count == 1) {
 		to_talitos_ptr(&desc->ptr[3], sg_dma_address(areq->src));
@@ -1408,8 +1409,7 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 	if (areq->src != areq->dst)
 		sg_count = talitos_map_sg(dev, areq->dst,
 					  edesc->dst_nents ? : 1,
-					  DMA_FROM_DEVICE,
-					  edesc->dst_is_chained);
+					  DMA_FROM_DEVICE, edesc->dst_chained);
 
 	if (sg_count == 1) {
 		to_talitos_ptr(&desc->ptr[4], sg_dma_address(areq->dst));
@@ -1577,8 +1577,7 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 
 	sg_count = talitos_map_sg(dev, req_ctx->psrc,
 				  edesc->src_nents ? : 1,
-				  DMA_TO_DEVICE,
-				  edesc->src_is_chained);
+				  DMA_TO_DEVICE, edesc->src_chained);
 
 	if (sg_count == 1) {
 		to_talitos_ptr(&desc->ptr[3], sg_dma_address(req_ctx->psrc));
@@ -1689,7 +1688,7 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 	unsigned int nbytes_to_hash;
 	unsigned int to_hash_later;
 	unsigned int nsg;
-	int chained;
+	bool chained;
 
 	if (!req_ctx->last && (nbytes + req_ctx->nbuf <= blocksize)) {
 		/* Buffer up to one whole block */
-- 
1.7.3.4
