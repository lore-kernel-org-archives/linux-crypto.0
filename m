From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v2 2/7] crypto: talitos - move mapping helpers before IPSEC
 functions
Date: Mon,  6 Jun 2016 13:20:36 +0200 (CEST)
Message-ID: <7a625141dd94440aa6285346e7b7c033772358fb.1464390095.git.christophe.leroy@c-s.fr>
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

In order to be able to use the mapping/unmapping helpers for IPSEC
it needs to be move upper in the file

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 244 +++++++++++++++++++++++------------------------
 1 file changed, 122 insertions(+), 122 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index a92aa37..beb369e 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -926,6 +926,33 @@ static void talitos_sg_unmap(struct device *dev,
 		dma_unmap_sg(dev, src, src_nents, DMA_BIDIRECTIONAL);
 }
 
+static void unmap_sg_talitos_ptr(struct device *dev, struct scatterlist *src,
+				 struct scatterlist *dst, unsigned int len,
+				 struct talitos_edesc *edesc)
+{
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	bool is_sec1 = has_ftr_sec1(priv);
+
+	if (is_sec1) {
+		if (!edesc->src_nents) {
+			dma_unmap_sg(dev, src, 1,
+				     dst != src ? DMA_TO_DEVICE
+						: DMA_BIDIRECTIONAL);
+		}
+		if (dst && edesc->dst_nents) {
+			dma_sync_single_for_device(dev,
+						   edesc->dma_link_tbl + len,
+						   len, DMA_FROM_DEVICE);
+			sg_copy_from_buffer(dst, edesc->dst_nents ? : 1,
+					    edesc->buf + len, len);
+		} else if (dst && dst != src) {
+			dma_unmap_sg(dev, dst, 1, DMA_FROM_DEVICE);
+		}
+	} else {
+		talitos_sg_unmap(dev, edesc, src, dst);
+	}
+}
+
 static void ipsec_esp_unmap(struct device *dev,
 			    struct talitos_edesc *edesc,
 			    struct aead_request *areq)
@@ -1083,6 +1110,101 @@ static inline int sg_to_link_tbl(struct scatterlist *sg, int sg_count,
 				     link_tbl_ptr);
 }
 
+int map_sg_in_talitos_ptr(struct device *dev, struct scatterlist *src,
+			  unsigned int len, struct talitos_edesc *edesc,
+			  enum dma_data_direction dir, struct talitos_ptr *ptr)
+{
+	int sg_count;
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	bool is_sec1 = has_ftr_sec1(priv);
+
+	to_talitos_ptr_len(ptr, len, is_sec1);
+
+	if (is_sec1) {
+		sg_count = edesc->src_nents ? : 1;
+
+		if (sg_count == 1) {
+			dma_map_sg(dev, src, 1, dir);
+			to_talitos_ptr(ptr, sg_dma_address(src), is_sec1);
+		} else {
+			sg_copy_to_buffer(src, sg_count, edesc->buf, len);
+			to_talitos_ptr(ptr, edesc->dma_link_tbl, is_sec1);
+			dma_sync_single_for_device(dev, edesc->dma_link_tbl,
+						   len, DMA_TO_DEVICE);
+		}
+	} else {
+		to_talitos_ptr_ext_set(ptr, 0, is_sec1);
+
+		sg_count = dma_map_sg(dev, src, edesc->src_nents ? : 1, dir);
+
+		if (sg_count == 1) {
+			to_talitos_ptr(ptr, sg_dma_address(src), is_sec1);
+		} else {
+			sg_count = sg_to_link_tbl(src, sg_count, len,
+						  &edesc->link_tbl[0]);
+			if (sg_count > 1) {
+				to_talitos_ptr(ptr, edesc->dma_link_tbl, 0);
+				to_talitos_ptr_ext_or(ptr, DESC_PTR_LNKTBL_JUMP,
+						      0);
+				dma_sync_single_for_device(dev,
+							   edesc->dma_link_tbl,
+							   edesc->dma_len,
+							   DMA_BIDIRECTIONAL);
+			} else {
+				/* Only one segment now, so no link tbl needed*/
+				to_talitos_ptr(ptr, sg_dma_address(src),
+					       is_sec1);
+			}
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
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	bool is_sec1 = has_ftr_sec1(priv);
+
+	if (dir != DMA_NONE)
+		sg_count = dma_map_sg(dev, dst, edesc->dst_nents ? : 1, dir);
+
+	to_talitos_ptr_len(ptr, len, is_sec1);
+
+	if (is_sec1) {
+		if (sg_count == 1) {
+			if (dir != DMA_NONE)
+				dma_map_sg(dev, dst, 1, dir);
+			to_talitos_ptr(ptr, sg_dma_address(dst), is_sec1);
+		} else {
+			to_talitos_ptr(ptr, edesc->dma_link_tbl + len, is_sec1);
+			dma_sync_single_for_device(dev,
+						   edesc->dma_link_tbl + len,
+						   len, DMA_FROM_DEVICE);
+		}
+	} else {
+		to_talitos_ptr_ext_set(ptr, 0, is_sec1);
+
+		if (sg_count == 1) {
+			to_talitos_ptr(ptr, sg_dma_address(dst), is_sec1);
+		} else {
+			struct talitos_ptr *link_tbl_ptr =
+				&edesc->link_tbl[edesc->src_nents + 1];
+
+			to_talitos_ptr(ptr, edesc->dma_link_tbl +
+					    (edesc->src_nents + 1) *
+					     sizeof(struct talitos_ptr), 0);
+			to_talitos_ptr_ext_or(ptr, DESC_PTR_LNKTBL_JUMP, 0);
+			sg_to_link_tbl(dst, sg_count, len, link_tbl_ptr);
+			dma_sync_single_for_device(dev, edesc->dma_link_tbl,
+						   edesc->dma_len,
+						   DMA_BIDIRECTIONAL);
+		}
+	}
+}
+
 /*
  * fill in and submit ipsec_esp descriptor
  */
@@ -1420,33 +1542,6 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *cipher,
 	return 0;
 }
 
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
-	}
-}
-
 static void common_nonsnoop_unmap(struct device *dev,
 				  struct talitos_edesc *edesc,
 				  struct ablkcipher_request *areq)
@@ -1478,101 +1573,6 @@ static void ablkcipher_done(struct device *dev,
 	areq->base.complete(&areq->base, err);
 }
 
-int map_sg_in_talitos_ptr(struct device *dev, struct scatterlist *src,
-			  unsigned int len, struct talitos_edesc *edesc,
-			  enum dma_data_direction dir, struct talitos_ptr *ptr)
-{
-	int sg_count;
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	bool is_sec1 = has_ftr_sec1(priv);
-
-	to_talitos_ptr_len(ptr, len, is_sec1);
-
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
-	}
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
-	if (is_sec1) {
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
-	}
-}
-
 static int common_nonsnoop(struct talitos_edesc *edesc,
 			   struct ablkcipher_request *areq,
 			   void (*callback) (struct device *dev,
-- 
2.1.0
