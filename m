From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v2 3/7] crypto: talitos - making mapping helpers more generic
Date: Mon,  6 Jun 2016 13:20:38 +0200 (CEST)
Message-ID: <3d875b72b76cd004c47f93816e50d7184f5d8c20.1464390095.git.christophe.leroy@c-s.fr>
References: <cover.1464390094.git.christophe.leroy@c-s.fr>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@arm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David S Miller <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1464390094.git.christophe.leroy@c-s.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

In preparation of IPSEC for SEC1, first step is to make the mapping
helpers more generic so that they can also be used by AEAD functions.

First, the functions are moved before IPSEC functions in talitos.c

talitos_sg_unmap() and unmap_sg_talitos_ptr() are merged as they
are quite similar, the second one handling the SEC1 case an calling
the first one for SEC2

map_sg_in_talitos_ptr() and map_sg_out_talitos_ptr() are merged
into talitos_sg_map() and enhenced to support offseted zones
as used for AEAD. The actual mapping is now performed outside that
helper. The DMA sync is also done outside to not make it several
times.

talitos_edesc_alloc() size calculation are fixed to also take into
account AEAD specific parts also for SEC1

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 230 +++++++++++++++++++----------------------------
 1 file changed, 93 insertions(+), 137 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index beb369e..b0d3c24 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -911,45 +911,28 @@ struct talitos_edesc {
 static void talitos_sg_unmap(struct device *dev,
 			     struct talitos_edesc *edesc,
 			     struct scatterlist *src,
-			     struct scatterlist *dst)
+			     struct scatterlist *dst,
+			     unsigned int len, unsigned int offset)
 {
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	bool is_sec1 = has_ftr_sec1(priv);
 	unsigned int src_nents = edesc->src_nents ? : 1;
 	unsigned int dst_nents = edesc->dst_nents ? : 1;
 
+	if (is_sec1 && dst && dst_nents > 1) {
+		dma_sync_single_for_device(dev, edesc->dma_link_tbl + offset,
+					   len, DMA_FROM_DEVICE);
+		sg_pcopy_from_buffer(dst, dst_nents, edesc->buf + offset, len,
+				     offset);
+	}
 	if (src != dst) {
-		dma_unmap_sg(dev, src, src_nents, DMA_TO_DEVICE);
+		if (src_nents == 1 || !is_sec1)
+			dma_unmap_sg(dev, src, src_nents, DMA_TO_DEVICE);
 
-		if (dst) {
+		if (dst && (dst_nents == 1 || !is_sec1))
 			dma_unmap_sg(dev, dst, dst_nents, DMA_FROM_DEVICE);
-		}
-	} else
+	} else if (src_nents == 1 || !is_sec1) {
 		dma_unmap_sg(dev, src, src_nents, DMA_BIDIRECTIONAL);
-}
-
-static void unmap_sg_talitos_ptr(struct device *dev, struct scatterlist *src,
-				 struct scatterlist *dst, unsigned int len,
-				 struct talitos_edesc *edesc)
-{
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	bool is_sec1 = has_ftr_sec1(priv);
-
-	if (is_sec1) {
-		if (!edesc->src_nents) {
-			dma_unmap_sg(dev, src, 1,
-				     dst != src ? DMA_TO_DEVICE
-						: DMA_BIDIRECTIONAL);
-		}
-		if (dst && edesc->dst_nents) {
-			dma_sync_single_for_device(dev,
-						   edesc->dma_link_tbl + len,
-						   len, DMA_FROM_DEVICE);
-			sg_copy_from_buffer(dst, edesc->dst_nents ? : 1,
-					    edesc->buf + len, len);
-		} else if (dst && dst != src) {
-			dma_unmap_sg(dev, dst, 1, DMA_FROM_DEVICE);
-		}
-	} else {
-		talitos_sg_unmap(dev, edesc, src, dst);
 	}
 }
 
@@ -962,7 +945,8 @@ static void ipsec_esp_unmap(struct device *dev,
 	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[2], DMA_TO_DEVICE);
 	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[0], DMA_TO_DEVICE);
 
-	talitos_sg_unmap(dev, edesc, areq->src, areq->dst);
+	talitos_sg_unmap(dev, edesc, areq->src, areq->dst, areq->cryptlen,
+			 areq->assoclen);
 
 	if (edesc->dma_len)
 		dma_unmap_single(dev, edesc->dma_link_tbl, edesc->dma_len,
@@ -1110,99 +1094,37 @@ static inline int sg_to_link_tbl(struct scatterlist *sg, int sg_count,
 				     link_tbl_ptr);
 }
 
-int map_sg_in_talitos_ptr(struct device *dev, struct scatterlist *src,
-			  unsigned int len, struct talitos_edesc *edesc,
-			  enum dma_data_direction dir, struct talitos_ptr *ptr)
+int talitos_sg_map(struct device *dev, struct scatterlist *src,
+		   unsigned int len, struct talitos_edesc *edesc,
+		   struct talitos_ptr *ptr,
+		   int sg_count, unsigned int offset, int tbl_off)
 {
-	int sg_count;
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	bool is_sec1 = has_ftr_sec1(priv);
 
 	to_talitos_ptr_len(ptr, len, is_sec1);
+	to_talitos_ptr_ext_set(ptr, 0, is_sec1);
 
-	if (is_sec1) {
-		sg_count = edesc->src_nents ? : 1;
-
-		if (sg_count == 1) {
-			dma_map_sg(dev, src, 1, dir);
-			to_talitos_ptr(ptr, sg_dma_address(src), is_sec1);
-		} else {
-			sg_copy_to_buffer(src, sg_count, edesc->buf, len);
-			to_talitos_ptr(ptr, edesc->dma_link_tbl, is_sec1);
-			dma_sync_single_for_device(dev, edesc->dma_link_tbl,
-						   len, DMA_TO_DEVICE);
-		}
-	} else {
-		to_talitos_ptr_ext_set(ptr, 0, is_sec1);
-
-		sg_count = dma_map_sg(dev, src, edesc->src_nents ? : 1, dir);
-
-		if (sg_count == 1) {
-			to_talitos_ptr(ptr, sg_dma_address(src), is_sec1);
-		} else {
-			sg_count = sg_to_link_tbl(src, sg_count, len,
-						  &edesc->link_tbl[0]);
-			if (sg_count > 1) {
-				to_talitos_ptr(ptr, edesc->dma_link_tbl, 0);
-				to_talitos_ptr_ext_or(ptr, DESC_PTR_LNKTBL_JUMP,
-						      0);
-				dma_sync_single_for_device(dev,
-							   edesc->dma_link_tbl,
-							   edesc->dma_len,
-							   DMA_BIDIRECTIONAL);
-			} else {
-				/* Only one segment now, so no link tbl needed*/
-				to_talitos_ptr(ptr, sg_dma_address(src),
-					       is_sec1);
-			}
-		}
+	if (sg_count == 1) {
+		to_talitos_ptr(ptr, sg_dma_address(src) + offset, is_sec1);
+		return sg_count;
 	}
-	return sg_count;
-}
-
-void map_sg_out_talitos_ptr(struct device *dev, struct scatterlist *dst,
-			    unsigned int len, struct talitos_edesc *edesc,
-			    enum dma_data_direction dir,
-			    struct talitos_ptr *ptr, int sg_count)
-{
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	bool is_sec1 = has_ftr_sec1(priv);
-
-	if (dir != DMA_NONE)
-		sg_count = dma_map_sg(dev, dst, edesc->dst_nents ? : 1, dir);
-
-	to_talitos_ptr_len(ptr, len, is_sec1);
-
 	if (is_sec1) {
-		if (sg_count == 1) {
-			if (dir != DMA_NONE)
-				dma_map_sg(dev, dst, 1, dir);
-			to_talitos_ptr(ptr, sg_dma_address(dst), is_sec1);
-		} else {
-			to_talitos_ptr(ptr, edesc->dma_link_tbl + len, is_sec1);
-			dma_sync_single_for_device(dev,
-						   edesc->dma_link_tbl + len,
-						   len, DMA_FROM_DEVICE);
-		}
-	} else {
-		to_talitos_ptr_ext_set(ptr, 0, is_sec1);
-
-		if (sg_count == 1) {
-			to_talitos_ptr(ptr, sg_dma_address(dst), is_sec1);
-		} else {
-			struct talitos_ptr *link_tbl_ptr =
-				&edesc->link_tbl[edesc->src_nents + 1];
-
-			to_talitos_ptr(ptr, edesc->dma_link_tbl +
-					    (edesc->src_nents + 1) *
-					     sizeof(struct talitos_ptr), 0);
-			to_talitos_ptr_ext_or(ptr, DESC_PTR_LNKTBL_JUMP, 0);
-			sg_to_link_tbl(dst, sg_count, len, link_tbl_ptr);
-			dma_sync_single_for_device(dev, edesc->dma_link_tbl,
-						   edesc->dma_len,
-						   DMA_BIDIRECTIONAL);
-		}
+		to_talitos_ptr(ptr, edesc->dma_link_tbl + offset, is_sec1);
+		return sg_count;
 	}
+	sg_count = sg_to_link_tbl_offset(src, sg_count, offset, len,
+					 &edesc->link_tbl[tbl_off]);
+	if (sg_count == 1) {
+		/* Only one segment now, so no link tbl needed*/
+		copy_talitos_ptr(ptr, &edesc->link_tbl[tbl_off], is_sec1);
+		return sg_count;
+	}
+	to_talitos_ptr(ptr, edesc->dma_link_tbl +
+			    tbl_off * sizeof(struct talitos_ptr), is_sec1);
+	to_talitos_ptr_ext_or(ptr, DESC_PTR_LNKTBL_JUMP, is_sec1);
+
+	return sg_count;
 }
 
 /*
@@ -1363,7 +1285,7 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 						 bool encrypt)
 {
 	struct talitos_edesc *edesc;
-	int src_nents, dst_nents, alloc_len, dma_len;
+	int src_nents, dst_nents, alloc_len, dma_len, src_len, dst_len;
 	dma_addr_t iv_dma = 0;
 	gfp_t flags = cryptoflags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
 		      GFP_ATOMIC;
@@ -1381,8 +1303,8 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 		iv_dma = dma_map_single(dev, iv, ivsize, DMA_TO_DEVICE);
 
 	if (!dst || dst == src) {
-		src_nents = sg_nents_for_len(src,
-					     assoclen + cryptlen + authsize);
+		src_len = assoclen + cryptlen + authsize;
+		src_nents = sg_nents_for_len(src, src_len);
 		if (src_nents < 0) {
 			dev_err(dev, "Invalid number of src SG.\n");
 			err = ERR_PTR(-EINVAL);
@@ -1390,17 +1312,18 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 		}
 		src_nents = (src_nents == 1) ? 0 : src_nents;
 		dst_nents = dst ? src_nents : 0;
+		dst_len = 0;
 	} else { /* dst && dst != src*/
-		src_nents = sg_nents_for_len(src, assoclen + cryptlen +
-						 (encrypt ? 0 : authsize));
+		src_len = assoclen + cryptlen + (encrypt ? 0 : authsize);
+		src_nents = sg_nents_for_len(src, src_len);
 		if (src_nents < 0) {
 			dev_err(dev, "Invalid number of src SG.\n");
 			err = ERR_PTR(-EINVAL);
 			goto error_sg;
 		}
 		src_nents = (src_nents == 1) ? 0 : src_nents;
-		dst_nents = sg_nents_for_len(dst, assoclen + cryptlen +
-						 (encrypt ? authsize : 0));
+		dst_len = assoclen + cryptlen + (encrypt ? authsize : 0);
+		dst_nents = sg_nents_for_len(dst, dst_len);
 		if (dst_nents < 0) {
 			dev_err(dev, "Invalid number of dst SG.\n");
 			err = ERR_PTR(-EINVAL);
@@ -1417,8 +1340,8 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 	alloc_len = sizeof(struct talitos_edesc);
 	if (src_nents || dst_nents) {
 		if (is_sec1)
-			dma_len = (src_nents ? cryptlen : 0) +
-				  (dst_nents ? cryptlen : 0);
+			dma_len = (src_nents ? src_len : 0) +
+				  (dst_nents ? dst_len : 0);
 		else
 			dma_len = (src_nents + dst_nents + 2) *
 				  sizeof(struct talitos_ptr) + authsize * 2;
@@ -1548,7 +1471,7 @@ static void common_nonsnoop_unmap(struct device *dev,
 {
 	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[5], DMA_FROM_DEVICE);
 
-	unmap_sg_talitos_ptr(dev, areq->src, areq->dst, areq->nbytes, edesc);
+	talitos_sg_unmap(dev, edesc, areq->src, areq->dst, areq->nbytes, 0);
 	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[2], DMA_TO_DEVICE);
 	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[1], DMA_TO_DEVICE);
 
@@ -1586,6 +1509,7 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 	unsigned int cryptlen = areq->nbytes;
 	unsigned int ivsize = crypto_ablkcipher_ivsize(cipher);
 	int sg_count, ret;
+	bool sync_needed = false;
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	bool is_sec1 = has_ftr_sec1(priv);
 
@@ -1601,19 +1525,33 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 	map_single_talitos_ptr(dev, &desc->ptr[2], ctx->keylen,
 			       (char *)&ctx->key, DMA_TO_DEVICE);
 
+	sg_count = edesc->src_nents ?: 1;
+	if (is_sec1 && sg_count > 1)
+		sg_copy_to_buffer(areq->src, sg_count, edesc->buf,
+				  cryptlen);
+	else
+		sg_count = dma_map_sg(dev, areq->src, sg_count,
+				      (areq->src == areq->dst) ?
+				      DMA_BIDIRECTIONAL : DMA_TO_DEVICE);
 	/*
 	 * cipher in
 	 */
-	sg_count = map_sg_in_talitos_ptr(dev, areq->src, cryptlen, edesc,
-					 (areq->src == areq->dst) ?
-					  DMA_BIDIRECTIONAL : DMA_TO_DEVICE,
-					  &desc->ptr[3]);
+	sg_count = talitos_sg_map(dev, areq->src, cryptlen, edesc,
+				  &desc->ptr[3], sg_count, 0, 0);
+	if (sg_count > 1)
+		sync_needed = true;
 
 	/* cipher out */
-	map_sg_out_talitos_ptr(dev, areq->dst, cryptlen, edesc,
-			       (areq->src == areq->dst) ? DMA_NONE
-							: DMA_FROM_DEVICE,
-			       &desc->ptr[4], sg_count);
+	if (areq->src != areq->dst) {
+		sg_count = edesc->dst_nents ? : 1;
+		if (!is_sec1 || sg_count == 1)
+			dma_map_sg(dev, areq->dst, sg_count, DMA_FROM_DEVICE);
+	}
+
+	ret = talitos_sg_map(dev, areq->dst, cryptlen, edesc, &desc->ptr[4],
+			     sg_count, 0, (edesc->src_nents + 1));
+	if (ret > 1)
+		sync_needed = true;
 
 	/* iv out */
 	map_single_talitos_ptr(dev, &desc->ptr[5], ivsize, ctx->iv,
@@ -1622,6 +1560,10 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 	/* last DWORD empty */
 	desc->ptr[6] = zero_entry;
 
+	if (sync_needed)
+		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
+					   edesc->dma_len, DMA_BIDIRECTIONAL);
+
 	ret = talitos_submit(dev, ctx->ch, desc, callback, areq);
 	if (ret != -EINPROGRESS) {
 		common_nonsnoop_unmap(dev, edesc, areq);
@@ -1685,7 +1627,7 @@ static void common_nonsnoop_hash_unmap(struct device *dev,
 
 	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[5], DMA_FROM_DEVICE);
 
-	unmap_sg_talitos_ptr(dev, req_ctx->psrc, NULL, 0, edesc);
+	talitos_sg_unmap(dev, edesc, req_ctx->psrc, NULL, 0, 0);
 
 	/* When using hashctx-in, must unmap it. */
 	if (from_talitos_ptr_len(&edesc->desc.ptr[1], is_sec1))
@@ -1756,8 +1698,10 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 	struct device *dev = ctx->dev;
 	struct talitos_desc *desc = &edesc->desc;
 	int ret;
+	bool sync_needed = false;
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	bool is_sec1 = has_ftr_sec1(priv);
+	int sg_count;
 
 	/* first DWORD empty */
 	desc->ptr[0] = zero_entry;
@@ -1782,11 +1726,19 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 	else
 		desc->ptr[2] = zero_entry;
 
+	sg_count = edesc->src_nents ?: 1;
+	if (is_sec1 && sg_count > 1)
+		sg_copy_to_buffer(areq->src, sg_count, edesc->buf, length);
+	else
+		sg_count = dma_map_sg(dev, req_ctx->psrc, sg_count,
+				      DMA_TO_DEVICE);
 	/*
 	 * data in
 	 */
-	map_sg_in_talitos_ptr(dev, req_ctx->psrc, length, edesc,
-			      DMA_TO_DEVICE, &desc->ptr[3]);
+	sg_count = talitos_sg_map(dev, req_ctx->psrc, length, edesc,
+				  &desc->ptr[3], sg_count, 0, 0);
+	if (sg_count > 1)
+		sync_needed = true;
 
 	/* fifth DWORD empty */
 	desc->ptr[4] = zero_entry;
@@ -1807,6 +1759,10 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 	if (is_sec1 && from_talitos_ptr_len(&desc->ptr[3], true) == 0)
 		talitos_handle_buggy_hash(ctx, edesc, &desc->ptr[3]);
 
+	if (sync_needed)
+		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
+					   edesc->dma_len, DMA_BIDIRECTIONAL);
+
 	ret = talitos_submit(dev, ctx->ch, desc, callback, areq);
 	if (ret != -EINPROGRESS) {
 		common_nonsnoop_hash_unmap(dev, edesc, areq);
-- 
2.1.0
