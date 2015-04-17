From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v3 14/17] crypto: talitos - implement scatter/gather copy for
 SEC1
Date: Fri, 17 Apr 2015 16:32:15 +0200 (CEST)
Message-ID: <20150417143215.F2C851A242C@localhost.localdomain>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David S Miller <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

SEC1 doesn't support scatter/gather, SEC1 doesn't handle link tables.
Therefore, for SEC1 we have to do it by SW. For that, we reserve
space at the end of the extended descriptor, in lieu of the space
reserved for the link tables on SEC2, and we perform sg_copy() when
preparing the descriptors

We also adapt the max buffer size which is only 32k on SEC1 while it
is 64k on SEC2+

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 138 ++++++++++++++++++++++++++++++++++-------------
 drivers/crypto/talitos.h |   3 +-
 2 files changed, 103 insertions(+), 38 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 1265405..dddf4b3 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -866,9 +866,10 @@ badkey:
  * @dst_chained: whether dst is chained or not
  * @iv_dma: dma address of iv for checking continuity and link table
  * @dma_len: length of dma mapped link_tbl space
- * @dma_link_tbl: bus physical address of link_tbl
+ * @dma_link_tbl: bus physical address of link_tbl/buf
  * @desc: h/w descriptor
- * @link_tbl: input and output h/w link tables (if {src,dst}_nents > 1)
+ * @link_tbl: input and output h/w link tables (if {src,dst}_nents > 1) (SEC2)
+ * @buf: input and output buffeur (if {src,dst}_nents > 1) (SEC1)
  *
  * if decrypting (with authcheck), or either one of src_nents or dst_nents
  * is greater than 1, an integrity check value is concatenated to the end
@@ -885,7 +886,10 @@ struct talitos_edesc {
 	int dma_len;
 	dma_addr_t dma_link_tbl;
 	struct talitos_desc desc;
-	struct talitos_ptr link_tbl[0];
+	union {
+		struct talitos_ptr link_tbl[0];
+		u8 buf[0];
+	};
 };
 
 static int talitos_map_sg(struct device *dev, struct scatterlist *sg,
@@ -1282,8 +1286,11 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 	dma_addr_t iv_dma = 0;
 	gfp_t flags = cryptoflags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
 		      GFP_ATOMIC;
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	bool is_sec1 = has_ftr_sec1(priv);
+	int max_len = is_sec1 ? TALITOS1_MAX_DATA_LEN : TALITOS2_MAX_DATA_LEN;
 
-	if (cryptlen + authsize > TALITOS_MAX_DATA_LEN) {
+	if (cryptlen + authsize > max_len) {
 		dev_err(dev, "length exceeds h/w max limit\n");
 		return ERR_PTR(-EINVAL);
 	}
@@ -1327,8 +1334,12 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 	 */
 	alloc_len = sizeof(struct talitos_edesc);
 	if (assoc_nents || src_nents || dst_nents) {
-		dma_len = (src_nents + dst_nents + 2 + assoc_nents) *
-			  sizeof(struct talitos_ptr) + authsize;
+		if (is_sec1)
+			dma_len = src_nents ? cryptlen : 0 +
+				  dst_nents ? cryptlen : 0;
+		else
+			dma_len = (src_nents + dst_nents + 2 + assoc_nents) *
+				  sizeof(struct talitos_ptr) + authsize;
 		alloc_len += dma_len;
 	} else {
 		dma_len = 0;
@@ -1485,7 +1496,27 @@ static void unmap_sg_talitos_ptr(struct device *dev, struct scatterlist *src,
 				 struct scatterlist *dst, unsigned int len,
 				 struct talitos_edesc *edesc)
 {
-	talitos_sg_unmap(dev, edesc, src, dst);
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
 }
 
 static void common_nonsnoop_unmap(struct device *dev,
@@ -1528,25 +1559,42 @@ int map_sg_in_talitos_ptr(struct device *dev, struct scatterlist *src,
 	bool is_sec1 = has_ftr_sec1(priv);
 
 	to_talitos_ptr_len(ptr, len, is_sec1);
-	to_talitos_ptr_extent_clear(ptr, is_sec1);
 
-	sg_count = talitos_map_sg(dev, src, edesc->src_nents ? : 1, dir,
-				  edesc->src_chained);
+	if (is_sec1) {
+		sg_count = edesc->src_nents ? : 1;
 
-	if (sg_count == 1) {
-		to_talitos_ptr(ptr, sg_dma_address(src), is_sec1);
-	} else {
-		sg_count = sg_to_link_tbl(src, sg_count, len,
-					  &edesc->link_tbl[0]);
-		if (sg_count > 1) {
-			to_talitos_ptr(ptr, edesc->dma_link_tbl, 0);
-			ptr->j_extent |= DESC_PTR_LNKTBL_JUMP;
-			dma_sync_single_for_device(dev, edesc->dma_link_tbl,
-						   edesc->dma_len,
-						   DMA_BIDIRECTIONAL);
+		if (sg_count == 1) {
+			dma_map_sg(dev, src, 1, dir);
+			to_talitos_ptr(ptr, sg_dma_address(src), is_sec1);
 		} else {
-			/* Only one segment now, so no link tbl needed */
+			sg_copy_to_buffer(src, sg_count, edesc->buf, len);
+			to_talitos_ptr(ptr, edesc->dma_link_tbl, is_sec1);
+			dma_sync_single_for_device(dev, edesc->dma_link_tbl,
+						   len, DMA_TO_DEVICE);
+		}
+	} else {
+		to_talitos_ptr_extent_clear(ptr, is_sec1);
+
+		sg_count = talitos_map_sg(dev, src, edesc->src_nents ? : 1, dir,
+					  edesc->src_chained);
+
+		if (sg_count == 1) {
 			to_talitos_ptr(ptr, sg_dma_address(src), is_sec1);
+		} else {
+			sg_count = sg_to_link_tbl(src, sg_count, len,
+						  &edesc->link_tbl[0]);
+			if (sg_count > 1) {
+				to_talitos_ptr(ptr, edesc->dma_link_tbl, 0);
+				ptr->j_extent |= DESC_PTR_LNKTBL_JUMP;
+				dma_sync_single_for_device(dev,
+							   edesc->dma_link_tbl,
+							   edesc->dma_len,
+							   DMA_BIDIRECTIONAL);
+			} else {
+				/* Only one segment now, so no link tbl needed*/
+				to_talitos_ptr(ptr, sg_dma_address(src),
+					       is_sec1);
+			}
 		}
 	}
 	return sg_count;
@@ -1560,26 +1608,42 @@ void map_sg_out_talitos_ptr(struct device *dev, struct scatterlist *dst,
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	bool is_sec1 = has_ftr_sec1(priv);
 
-	to_talitos_ptr_len(ptr, len, is_sec1);
-	to_talitos_ptr_extent_clear(ptr, is_sec1);
-
 	if (dir != DMA_NONE)
 		sg_count = talitos_map_sg(dev, dst, edesc->dst_nents ? : 1,
 					  dir, edesc->dst_chained);
 
-	if (sg_count == 1) {
-		to_talitos_ptr(ptr, sg_dma_address(dst), is_sec1);
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
 	} else {
-		struct talitos_ptr *link_tbl_ptr =
-			&edesc->link_tbl[edesc->src_nents + 1];
-
-		to_talitos_ptr(ptr, edesc->dma_link_tbl +
-					      (edesc->src_nents + 1) *
-					      sizeof(struct talitos_ptr), 0);
-		ptr->j_extent |= DESC_PTR_LNKTBL_JUMP;
-		sg_count = sg_to_link_tbl(dst, sg_count, len, link_tbl_ptr);
-		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
-					   edesc->dma_len, DMA_BIDIRECTIONAL);
+		to_talitos_ptr_extent_clear(ptr, is_sec1);
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
+			ptr->j_extent |= DESC_PTR_LNKTBL_JUMP;
+			sg_count = sg_to_link_tbl(dst, sg_count, len,
+						  link_tbl_ptr);
+			dma_sync_single_for_device(dev, edesc->dma_link_tbl,
+						   edesc->dma_len,
+						   DMA_BIDIRECTIONAL);
+		}
 	}
 }
 
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 9507c4f..314daf5 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -29,7 +29,8 @@
  */
 
 #define TALITOS_TIMEOUT 100000
-#define TALITOS_MAX_DATA_LEN 65535
+#define TALITOS1_MAX_DATA_LEN 32768
+#define TALITOS2_MAX_DATA_LEN 65535
 
 #define DESC_TYPE(desc_hdr) ((be32_to_cpu(desc_hdr) >> 3) & 0x1f)
 #define PRIMARY_EU(desc_hdr) ((be32_to_cpu(desc_hdr) >> 28) & 0xf)
-- 
2.1.0
