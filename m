From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 1/4] crypto: talitos: dma_map_sg can handle chained SG
Date: Wed, 23 Sep 2015 13:55:25 +0200
Message-ID: <1443009328-12478-2-git-send-email-clabbe.montjoie@gmail.com>
References: <1443009328-12478-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	LABBE Corentin <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1443009328-12478-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The talitos driver use two dma_map_sg path
according to SG are chained or not.
Since dma_map_sg can handle both case, clean the code with all
references to sg chained.

Thus removing talitos_map_sg, talitos_unmap_sg_chain
and sg_count functions.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/talitos.c | 104 ++++++++---------------------------------------
 1 file changed, 18 insertions(+), 86 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 3b20a1b..46f531e 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -857,8 +857,6 @@ badkey:
  * talitos_edesc - s/w-extended descriptor
  * @src_nents: number of segments in input scatterlist
  * @dst_nents: number of segments in output scatterlist
- * @src_chained: whether src is chained or not
- * @dst_chained: whether dst is chained or not
  * @icv_ool: whether ICV is out-of-line
  * @iv_dma: dma address of iv for checking continuity and link table
  * @dma_len: length of dma mapped link_tbl space
@@ -874,8 +872,6 @@ badkey:
 struct talitos_edesc {
 	int src_nents;
 	int dst_nents;
-	bool src_chained;
-	bool dst_chained;
 	bool icv_ool;
 	dma_addr_t iv_dma;
 	int dma_len;
@@ -887,29 +883,6 @@ struct talitos_edesc {
 	};
 };
 
-static int talitos_map_sg(struct device *dev, struct scatterlist *sg,
-			  unsigned int nents, enum dma_data_direction dir,
-			  bool chained)
-{
-	if (unlikely(chained))
-		while (sg) {
-			dma_map_sg(dev, sg, 1, dir);
-			sg = sg_next(sg);
-		}
-	else
-		dma_map_sg(dev, sg, nents, dir);
-	return nents;
-}
-
-static void talitos_unmap_sg_chain(struct device *dev, struct scatterlist *sg,
-				   enum dma_data_direction dir)
-{
-	while (sg) {
-		dma_unmap_sg(dev, sg, 1, dir);
-		sg = sg_next(sg);
-	}
-}
-
 static void talitos_sg_unmap(struct device *dev,
 			     struct talitos_edesc *edesc,
 			     struct scatterlist *src,
@@ -919,24 +892,13 @@ static void talitos_sg_unmap(struct device *dev,
 	unsigned int dst_nents = edesc->dst_nents ? : 1;
 
 	if (src != dst) {
-		if (edesc->src_chained)
-			talitos_unmap_sg_chain(dev, src, DMA_TO_DEVICE);
-		else
-			dma_unmap_sg(dev, src, src_nents, DMA_TO_DEVICE);
+		dma_unmap_sg(dev, src, src_nents, DMA_TO_DEVICE);
 
 		if (dst) {
-			if (edesc->dst_chained)
-				talitos_unmap_sg_chain(dev, dst,
-						       DMA_FROM_DEVICE);
-			else
-				dma_unmap_sg(dev, dst, dst_nents,
-					     DMA_FROM_DEVICE);
+			dma_unmap_sg(dev, dst, dst_nents, DMA_FROM_DEVICE);
 		}
 	} else
-		if (edesc->src_chained)
-			talitos_unmap_sg_chain(dev, src, DMA_BIDIRECTIONAL);
-		else
-			dma_unmap_sg(dev, src, src_nents, DMA_BIDIRECTIONAL);
+		dma_unmap_sg(dev, src, src_nents, DMA_BIDIRECTIONAL);
 }
 
 static void ipsec_esp_unmap(struct device *dev,
@@ -1118,10 +1080,9 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	map_single_talitos_ptr(dev, &desc->ptr[0], ctx->authkeylen, &ctx->key,
 			       DMA_TO_DEVICE);
 
-	sg_count = talitos_map_sg(dev, areq->src, edesc->src_nents ?: 1,
-				  (areq->src == areq->dst) ? DMA_BIDIRECTIONAL
-							   : DMA_TO_DEVICE,
-				  edesc->src_chained);
+	sg_count = dma_map_sg(dev, areq->src, edesc->src_nents ?: 1,
+			      (areq->src == areq->dst) ? DMA_BIDIRECTIONAL
+							   : DMA_TO_DEVICE);
 
 	/* hmac data */
 	desc->ptr[1].len = cpu_to_be16(areq->assoclen);
@@ -1185,9 +1146,8 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	desc->ptr[5].j_extent = authsize;
 
 	if (areq->src != areq->dst)
-		sg_count = talitos_map_sg(dev, areq->dst,
-					  edesc->dst_nents ? : 1,
-					  DMA_FROM_DEVICE, edesc->dst_chained);
+		sg_count = dma_map_sg(dev, areq->dst, edesc->dst_nents ? : 1,
+				      DMA_FROM_DEVICE);
 
 	edesc->icv_ool = false;
 
@@ -1234,26 +1194,6 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 }
 
 /*
- * derive number of elements in scatterlist
- */
-static int sg_count(struct scatterlist *sg_list, int nbytes, bool *chained)
-{
-	struct scatterlist *sg = sg_list;
-	int sg_nents = 0;
-
-	*chained = false;
-	while (nbytes > 0 && sg) {
-		sg_nents++;
-		nbytes -= sg->length;
-		if (!sg_is_last(sg) && (sg + 1)->length == 0)
-			*chained = true;
-		sg = sg_next(sg);
-	}
-
-	return sg_nents;
-}
-
-/*
  * allocate and map the extended descriptor
  */
 static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
@@ -1270,7 +1210,6 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 {
 	struct talitos_edesc *edesc;
 	int src_nents, dst_nents, alloc_len, dma_len;
-	bool src_chained = false, dst_chained = false;
 	dma_addr_t iv_dma = 0;
 	gfp_t flags = cryptoflags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
 		      GFP_ATOMIC;
@@ -1287,18 +1226,16 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 		iv_dma = dma_map_single(dev, iv, ivsize, DMA_TO_DEVICE);
 
 	if (!dst || dst == src) {
-		src_nents = sg_count(src, assoclen + cryptlen + authsize,
-				     &src_chained);
+		src_nents = sg_nents_for_len(src,
+					     assoclen + cryptlen + authsize);
 		src_nents = (src_nents == 1) ? 0 : src_nents;
 		dst_nents = dst ? src_nents : 0;
 	} else { /* dst && dst != src*/
-		src_nents = sg_count(src, assoclen + cryptlen +
-					  (encrypt ? 0 : authsize),
-				     &src_chained);
+		src_nents = sg_nents_for_len(src, assoclen + cryptlen +
+						 (encrypt ? 0 : authsize));
 		src_nents = (src_nents == 1) ? 0 : src_nents;
-		dst_nents = sg_count(dst, assoclen + cryptlen +
-					  (encrypt ? authsize : 0),
-				     &dst_chained);
+		dst_nents = sg_nents_for_len(dst, assoclen + cryptlen +
+						 (encrypt ? authsize : 0));
 		dst_nents = (dst_nents == 1) ? 0 : dst_nents;
 	}
 
@@ -1332,8 +1269,6 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 
 	edesc->src_nents = src_nents;
 	edesc->dst_nents = dst_nents;
-	edesc->src_chained = src_chained;
-	edesc->dst_chained = dst_chained;
 	edesc->iv_dma = iv_dma;
 	edesc->dma_len = dma_len;
 	if (dma_len)
@@ -1518,8 +1453,7 @@ int map_sg_in_talitos_ptr(struct device *dev, struct scatterlist *src,
 	} else {
 		to_talitos_ptr_extent_clear(ptr, is_sec1);
 
-		sg_count = talitos_map_sg(dev, src, edesc->src_nents ? : 1, dir,
-					  edesc->src_chained);
+		sg_count = dma_map_sg(dev, src, edesc->src_nents ? : 1, dir);
 
 		if (sg_count == 1) {
 			to_talitos_ptr(ptr, sg_dma_address(src), is_sec1);
@@ -1552,8 +1486,7 @@ void map_sg_out_talitos_ptr(struct device *dev, struct scatterlist *dst,
 	bool is_sec1 = has_ftr_sec1(priv);
 
 	if (dir != DMA_NONE)
-		sg_count = talitos_map_sg(dev, dst, edesc->dst_nents ? : 1,
-					  dir, edesc->dst_chained);
+		sg_count = dma_map_sg(dev, dst, edesc->dst_nents ? : 1, dir);
 
 	to_talitos_ptr_len(ptr, len, is_sec1);
 
@@ -1897,12 +1830,11 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 	unsigned int nbytes_to_hash;
 	unsigned int to_hash_later;
 	unsigned int nsg;
-	bool chained;
 
 	if (!req_ctx->last && (nbytes + req_ctx->nbuf <= blocksize)) {
 		/* Buffer up to one whole block */
 		sg_copy_to_buffer(areq->src,
-				  sg_count(areq->src, nbytes, &chained),
+				  sg_nents_for_len(areq->src, nbytes),
 				  req_ctx->buf + req_ctx->nbuf, nbytes);
 		req_ctx->nbuf += nbytes;
 		return 0;
@@ -1935,7 +1867,7 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 		req_ctx->psrc = areq->src;
 
 	if (to_hash_later) {
-		int nents = sg_count(areq->src, nbytes, &chained);
+		int nents = sg_nents_for_len(areq->src, nbytes);
 		sg_pcopy_to_buffer(areq->src, nents,
 				      req_ctx->bufnext,
 				      to_hash_later,
-- 
2.4.9
