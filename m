From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v3 10/17] crypto: talitos - fill in talitos descriptor iaw
 SEC1 or SEC2+
Date: Sat, 14 Mar 2015 14:06:06 +0100
Message-ID: <20150417142403.EF36E1A242C@localhost.localdomain>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David S Miller <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

talitos descriptor is slightly different for SEC1 and SEC2+, so
lets the helper function that fills the descriptor take into account
the type of SEC.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 105 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 67 insertions(+), 38 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index db95023..678b528 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -55,25 +55,38 @@
 
 #include "talitos.h"
 
-static void to_talitos_ptr(struct talitos_ptr *ptr, dma_addr_t dma_addr)
+static void to_talitos_ptr(struct talitos_ptr *ptr, dma_addr_t dma_addr,
+			   bool is_sec1)
 {
 	ptr->ptr = cpu_to_be32(lower_32_bits(dma_addr));
-	ptr->eptr = upper_32_bits(dma_addr);
+	if (!is_sec1)
+		ptr->eptr = upper_32_bits(dma_addr);
 }
 
-static void to_talitos_ptr_len(struct talitos_ptr *ptr, unsigned short len)
+static void to_talitos_ptr_len(struct talitos_ptr *ptr, unsigned short len,
+			       bool is_sec1)
 {
-	ptr->len = cpu_to_be16(len);
+	if (is_sec1) {
+		ptr->res = 0;
+		ptr->len1 = cpu_to_be16(len);
+	} else {
+		ptr->len = cpu_to_be16(len);
+	}
 }
 
-static unsigned short from_talitos_ptr_len(struct talitos_ptr *ptr)
+static unsigned short from_talitos_ptr_len(struct talitos_ptr *ptr,
+					   bool is_sec1)
 {
-	return be16_to_cpu(ptr->len);
+	if (is_sec1)
+		return be16_to_cpu(ptr->len1);
+	else
+		return be16_to_cpu(ptr->len);
 }
 
-static void to_talitos_ptr_extent_clear(struct talitos_ptr *ptr)
+static void to_talitos_ptr_extent_clear(struct talitos_ptr *ptr, bool is_sec1)
 {
-	ptr->j_extent = 0;
+	if (!is_sec1)
+		ptr->j_extent = 0;
 }
 
 /*
@@ -85,10 +98,12 @@ static void map_single_talitos_ptr(struct device *dev,
 				   enum dma_data_direction dir)
 {
 	dma_addr_t dma_addr = dma_map_single(dev, data, len, dir);
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	bool is_sec1 = has_ftr_sec1(priv);
 
-	to_talitos_ptr_len(ptr, len);
-	to_talitos_ptr(ptr, dma_addr);
-	to_talitos_ptr_extent_clear(ptr);
+	to_talitos_ptr_len(ptr, len, is_sec1);
+	to_talitos_ptr(ptr, dma_addr, is_sec1);
+	to_talitos_ptr_extent_clear(ptr, is_sec1);
 }
 
 /*
@@ -98,8 +113,11 @@ static void unmap_single_talitos_ptr(struct device *dev,
 				     struct talitos_ptr *ptr,
 				     enum dma_data_direction dir)
 {
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	bool is_sec1 = has_ftr_sec1(priv);
+
 	dma_unmap_single(dev, be32_to_cpu(ptr->ptr),
-			 from_talitos_ptr_len(ptr), dir);
+			 from_talitos_ptr_len(ptr, is_sec1), dir);
 }
 
 static int reset_channel(struct device *dev, int ch)
@@ -922,7 +940,7 @@ static int sg_to_link_tbl(struct scatterlist *sg, int sg_count,
 	int n_sg = sg_count;
 
 	while (n_sg--) {
-		to_talitos_ptr(link_tbl_ptr, sg_dma_address(sg));
+		to_talitos_ptr(link_tbl_ptr, sg_dma_address(sg), 0);
 		link_tbl_ptr->len = cpu_to_be16(sg_dma_len(sg));
 		link_tbl_ptr->j_extent = 0;
 		link_tbl_ptr++;
@@ -976,7 +994,7 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 		struct talitos_ptr *tbl_ptr = &edesc->link_tbl[tbl_off];
 
 		to_talitos_ptr(&desc->ptr[1], edesc->dma_link_tbl + tbl_off *
-			       sizeof(struct talitos_ptr));
+			       sizeof(struct talitos_ptr), 0);
 		desc->ptr[1].j_extent = DESC_PTR_LNKTBL_JUMP;
 
 		/* assoc_nents - 1 entries for assoc, 1 for IV */
@@ -987,7 +1005,7 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 		tbl_ptr += sg_count - 1;
 		tbl_ptr->j_extent = 0;
 		tbl_ptr++;
-		to_talitos_ptr(tbl_ptr, edesc->iv_dma);
+		to_talitos_ptr(tbl_ptr, edesc->iv_dma, 0);
 		tbl_ptr->len = cpu_to_be16(ivsize);
 		tbl_ptr->j_extent = DESC_PTR_LNKTBL_RETURN;
 
@@ -996,14 +1014,14 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	} else {
 		if (areq->assoclen)
 			to_talitos_ptr(&desc->ptr[1],
-				       sg_dma_address(areq->assoc));
+				       sg_dma_address(areq->assoc), 0);
 		else
-			to_talitos_ptr(&desc->ptr[1], edesc->iv_dma);
+			to_talitos_ptr(&desc->ptr[1], edesc->iv_dma, 0);
 		desc->ptr[1].j_extent = 0;
 	}
 
 	/* cipher iv */
-	to_talitos_ptr(&desc->ptr[2], edesc->iv_dma);
+	to_talitos_ptr(&desc->ptr[2], edesc->iv_dma, 0);
 	desc->ptr[2].len = cpu_to_be16(ivsize);
 	desc->ptr[2].j_extent = 0;
 	/* Sync needed for the aead_givencrypt case */
@@ -1029,7 +1047,7 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 				  edesc->src_chained);
 
 	if (sg_count == 1) {
-		to_talitos_ptr(&desc->ptr[4], sg_dma_address(areq->src));
+		to_talitos_ptr(&desc->ptr[4], sg_dma_address(areq->src), 0);
 	} else {
 		sg_link_tbl_len = cryptlen;
 
@@ -1040,14 +1058,14 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 					  &edesc->link_tbl[0]);
 		if (sg_count > 1) {
 			desc->ptr[4].j_extent |= DESC_PTR_LNKTBL_JUMP;
-			to_talitos_ptr(&desc->ptr[4], edesc->dma_link_tbl);
+			to_talitos_ptr(&desc->ptr[4], edesc->dma_link_tbl, 0);
 			dma_sync_single_for_device(dev, edesc->dma_link_tbl,
 						   edesc->dma_len,
 						   DMA_BIDIRECTIONAL);
 		} else {
 			/* Only one segment now, so no link tbl needed */
 			to_talitos_ptr(&desc->ptr[4],
-				       sg_dma_address(areq->src));
+				       sg_dma_address(areq->src), 0);
 		}
 	}
 
@@ -1061,13 +1079,13 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 					  DMA_FROM_DEVICE, edesc->dst_chained);
 
 	if (sg_count == 1) {
-		to_talitos_ptr(&desc->ptr[5], sg_dma_address(areq->dst));
+		to_talitos_ptr(&desc->ptr[5], sg_dma_address(areq->dst), 0);
 	} else {
 		int tbl_off = edesc->src_nents + 1;
 		struct talitos_ptr *tbl_ptr = &edesc->link_tbl[tbl_off];
 
 		to_talitos_ptr(&desc->ptr[5], edesc->dma_link_tbl +
-			       tbl_off * sizeof(struct talitos_ptr));
+			       tbl_off * sizeof(struct talitos_ptr), 0);
 		sg_count = sg_to_link_tbl(areq->dst, sg_count, cryptlen,
 					  tbl_ptr);
 
@@ -1082,7 +1100,7 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 		to_talitos_ptr(tbl_ptr, edesc->dma_link_tbl +
 			       (tbl_off + edesc->dst_nents + 1 +
 				edesc->assoc_nents) *
-			       sizeof(struct talitos_ptr));
+			       sizeof(struct talitos_ptr), 0);
 		desc->ptr[5].j_extent |= DESC_PTR_LNKTBL_JUMP;
 		dma_sync_single_for_device(ctx->dev, edesc->dma_link_tbl,
 					   edesc->dma_len, DMA_BIDIRECTIONAL);
@@ -1384,27 +1402,29 @@ int map_sg_in_talitos_ptr(struct device *dev, struct scatterlist *src,
 			  enum dma_data_direction dir, struct talitos_ptr *ptr)
 {
 	int sg_count;
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	bool is_sec1 = has_ftr_sec1(priv);
 
-	to_talitos_ptr_len(ptr, len);
-	to_talitos_ptr_extent_clear(ptr);
+	to_talitos_ptr_len(ptr, len, is_sec1);
+	to_talitos_ptr_extent_clear(ptr, is_sec1);
 
 	sg_count = talitos_map_sg(dev, src, edesc->src_nents ? : 1, dir,
 				  edesc->src_chained);
 
 	if (sg_count == 1) {
-		to_talitos_ptr(ptr, sg_dma_address(src));
+		to_talitos_ptr(ptr, sg_dma_address(src), is_sec1);
 	} else {
 		sg_count = sg_to_link_tbl(src, sg_count, len,
 					  &edesc->link_tbl[0]);
 		if (sg_count > 1) {
-			to_talitos_ptr(ptr, edesc->dma_link_tbl);
+			to_talitos_ptr(ptr, edesc->dma_link_tbl, 0);
 			ptr->j_extent |= DESC_PTR_LNKTBL_JUMP;
 			dma_sync_single_for_device(dev, edesc->dma_link_tbl,
 						   edesc->dma_len,
 						   DMA_BIDIRECTIONAL);
 		} else {
 			/* Only one segment now, so no link tbl needed */
-			to_talitos_ptr(ptr, sg_dma_address(src));
+			to_talitos_ptr(ptr, sg_dma_address(src), is_sec1);
 		}
 	}
 	return sg_count;
@@ -1415,22 +1435,25 @@ void map_sg_out_talitos_ptr(struct device *dev, struct scatterlist *dst,
 			    enum dma_data_direction dir,
 			    struct talitos_ptr *ptr, int sg_count)
 {
-	to_talitos_ptr_len(ptr, len);
-	to_talitos_ptr_extent_clear(ptr);
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	bool is_sec1 = has_ftr_sec1(priv);
+
+	to_talitos_ptr_len(ptr, len, is_sec1);
+	to_talitos_ptr_extent_clear(ptr, is_sec1);
 
 	if (dir != DMA_NONE)
 		sg_count = talitos_map_sg(dev, dst, edesc->dst_nents ? : 1,
 					  dir, edesc->dst_chained);
 
 	if (sg_count == 1) {
-		to_talitos_ptr(ptr, sg_dma_address(dst));
+		to_talitos_ptr(ptr, sg_dma_address(dst), is_sec1);
 	} else {
 		struct talitos_ptr *link_tbl_ptr =
 			&edesc->link_tbl[edesc->src_nents + 1];
 
 		to_talitos_ptr(ptr, edesc->dma_link_tbl +
 					      (edesc->src_nents + 1) *
-					      sizeof(struct talitos_ptr));
+					      sizeof(struct talitos_ptr), 0);
 		ptr->j_extent |= DESC_PTR_LNKTBL_JUMP;
 		sg_count = sg_to_link_tbl(dst, sg_count, len, link_tbl_ptr);
 		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
@@ -1451,14 +1474,16 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 	unsigned int cryptlen = areq->nbytes;
 	unsigned int ivsize = crypto_ablkcipher_ivsize(cipher);
 	int sg_count, ret;
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	bool is_sec1 = has_ftr_sec1(priv);
 
 	/* first DWORD empty */
 	desc->ptr[0] = zero_entry;
 
 	/* cipher iv */
-	to_talitos_ptr(&desc->ptr[1], edesc->iv_dma);
-	to_talitos_ptr_len(&desc->ptr[1], ivsize);
-	to_talitos_ptr_extent_clear(&desc->ptr[1]);
+	to_talitos_ptr(&desc->ptr[1], edesc->iv_dma, is_sec1);
+	to_talitos_ptr_len(&desc->ptr[1], ivsize, is_sec1);
+	to_talitos_ptr_extent_clear(&desc->ptr[1], is_sec1);
 
 	/* cipher key */
 	map_single_talitos_ptr(dev, &desc->ptr[2], ctx->keylen,
@@ -1543,17 +1568,19 @@ static void common_nonsnoop_hash_unmap(struct device *dev,
 				       struct ahash_request *areq)
 {
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	bool is_sec1 = has_ftr_sec1(priv);
 
 	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[5], DMA_FROM_DEVICE);
 
 	unmap_sg_talitos_ptr(dev, req_ctx->psrc, NULL, 0, edesc);
 
 	/* When using hashctx-in, must unmap it. */
-	if (from_talitos_ptr_len(&edesc->desc.ptr[1]))
+	if (from_talitos_ptr_len(&edesc->desc.ptr[1], is_sec1))
 		unmap_single_talitos_ptr(dev, &edesc->desc.ptr[1],
 					 DMA_TO_DEVICE);
 
-	if (from_talitos_ptr_len(&edesc->desc.ptr[2]))
+	if (from_talitos_ptr_len(&edesc->desc.ptr[2], is_sec1))
 		unmap_single_talitos_ptr(dev, &edesc->desc.ptr[2],
 					 DMA_TO_DEVICE);
 
@@ -1596,6 +1623,8 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 	struct device *dev = ctx->dev;
 	struct talitos_desc *desc = &edesc->desc;
 	int ret;
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	bool is_sec1 = has_ftr_sec1(priv);
 
 	/* first DWORD empty */
 	desc->ptr[0] = zero_entry;
-- 
2.1.0
