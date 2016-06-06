From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v2 1/7] crypto: talitos - using helpers for all talitos_ptr
 operations
Date: Mon,  6 Jun 2016 13:20:34 +0200 (CEST)
Message-ID: <1eeaac6b81603fae2a272a357fc7f4e6952437d6.1464390094.git.christophe.leroy@c-s.fr>
References: <cover.1464390094.git.christophe.leroy@c-s.fr>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@arm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David S Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:19145 "EHLO pegase1.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbcFFNDm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Jun 2016 09:03:42 -0400
In-Reply-To: <cover.1464390094.git.christophe.leroy@c-s.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use helper for all modifications to talitos_ptr in preparation to
the implementation of AEAD for SEC1

to_talitos_ptr_extent_clear() has been removed in favor of
to_talitos_ptr_ext_set() to set any value and
to_talitos_ptr_ext_or() to or the extent field with a value
name has been shorten to help keeping single lines of 80 chars

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 59 ++++++++++++++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 25 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index b7ee8d3..a92aa37 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -91,10 +91,17 @@ static unsigned short from_talitos_ptr_len(struct talitos_ptr *ptr,
 		return be16_to_cpu(ptr->len);
 }
 
-static void to_talitos_ptr_extent_clear(struct talitos_ptr *ptr, bool is_sec1)
+static void to_talitos_ptr_ext_set(struct talitos_ptr *ptr, u8 val,
+				   bool is_sec1)
 {
 	if (!is_sec1)
-		ptr->j_extent = 0;
+		ptr->j_extent = val;
+}
+
+static void to_talitos_ptr_ext_or(struct talitos_ptr *ptr, u8 val, bool is_sec1)
+{
+	if (!is_sec1)
+		ptr->j_extent |= val;
 }
 
 /*
@@ -111,7 +118,7 @@ static void map_single_talitos_ptr(struct device *dev,
 
 	to_talitos_ptr_len(ptr, len, is_sec1);
 	to_talitos_ptr(ptr, dma_addr, is_sec1);
-	to_talitos_ptr_extent_clear(ptr, is_sec1);
+	to_talitos_ptr_ext_set(ptr, 0, is_sec1);
 }
 
 /*
@@ -1050,8 +1057,8 @@ static int sg_to_link_tbl_offset(struct scatterlist *sg, int sg_count,
 
 		to_talitos_ptr(link_tbl_ptr + count,
 			       sg_dma_address(sg) + offset, 0);
-		link_tbl_ptr[count].len = cpu_to_be16(len);
-		link_tbl_ptr[count].j_extent = 0;
+		to_talitos_ptr_len(link_tbl_ptr + count, len, 0);
+		to_talitos_ptr_ext_set(link_tbl_ptr + count, 0, 0);
 		count++;
 		cryptlen -= len;
 		offset = 0;
@@ -1062,7 +1069,8 @@ next:
 
 	/* tag end of link table */
 	if (count > 0)
-		link_tbl_ptr[count - 1].j_extent = DESC_PTR_LNKTBL_RETURN;
+		to_talitos_ptr_ext_set(link_tbl_ptr + count - 1,
+				       DESC_PTR_LNKTBL_RETURN, 0);
 
 	return count;
 }
@@ -1102,14 +1110,14 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 			      (areq->src == areq->dst) ? DMA_BIDIRECTIONAL
 							   : DMA_TO_DEVICE);
 	/* hmac data */
-	desc->ptr[1].len = cpu_to_be16(areq->assoclen);
+	to_talitos_ptr_len(&desc->ptr[1], areq->assoclen, 0);
 	if (sg_count > 1 &&
 	    (ret = sg_to_link_tbl_offset(areq->src, sg_count, 0,
 					 areq->assoclen,
 					 &edesc->link_tbl[tbl_off])) > 1) {
 		to_talitos_ptr(&desc->ptr[1], edesc->dma_link_tbl + tbl_off *
 			       sizeof(struct talitos_ptr), 0);
-		desc->ptr[1].j_extent = DESC_PTR_LNKTBL_JUMP;
+		to_talitos_ptr_ext_set(&desc->ptr[1], DESC_PTR_LNKTBL_JUMP, 0);
 
 		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
 					   edesc->dma_len, DMA_BIDIRECTIONAL);
@@ -1117,13 +1125,13 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 		tbl_off += ret;
 	} else {
 		to_talitos_ptr(&desc->ptr[1], sg_dma_address(areq->src), 0);
-		desc->ptr[1].j_extent = 0;
+		to_talitos_ptr_ext_set(&desc->ptr[1], 0, 0);
 	}
 
 	/* cipher iv */
 	to_talitos_ptr(&desc->ptr[2], edesc->iv_dma, 0);
-	desc->ptr[2].len = cpu_to_be16(ivsize);
-	desc->ptr[2].j_extent = 0;
+	to_talitos_ptr_len(&desc->ptr[2], ivsize, 0);
+	to_talitos_ptr_ext_set(&desc->ptr[2], 0, 0);
 
 	/* cipher key */
 	map_single_talitos_ptr(dev, &desc->ptr[3], ctx->enckeylen,
@@ -1136,8 +1144,8 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	 * extent is bytes of HMAC postpended to ciphertext,
 	 * typically 12 for ipsec
 	 */
-	desc->ptr[4].len = cpu_to_be16(cryptlen);
-	desc->ptr[4].j_extent = authsize;
+	to_talitos_ptr_len(&desc->ptr[4], cryptlen, 0);
+	to_talitos_ptr_ext_set(&desc->ptr[4], authsize, 0);
 
 	sg_link_tbl_len = cryptlen;
 	if (edesc->desc.hdr & DESC_HDR_MODE1_MDEU_CICV)
@@ -1150,7 +1158,7 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 						areq->assoclen, sg_link_tbl_len,
 						&edesc->link_tbl[tbl_off])) >
 		   1) {
-		desc->ptr[4].j_extent |= DESC_PTR_LNKTBL_JUMP;
+		to_talitos_ptr_ext_or(&desc->ptr[4], DESC_PTR_LNKTBL_JUMP, 0);
 		to_talitos_ptr(&desc->ptr[4], edesc->dma_link_tbl +
 					      tbl_off *
 					      sizeof(struct talitos_ptr), 0);
@@ -1163,8 +1171,8 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	}
 
 	/* cipher out */
-	desc->ptr[5].len = cpu_to_be16(cryptlen);
-	desc->ptr[5].j_extent = authsize;
+	to_talitos_ptr_len(&desc->ptr[5], cryptlen, 0);
+	to_talitos_ptr_ext_set(&desc->ptr[5], authsize, 0);
 
 	if (areq->src != areq->dst)
 		sg_count = dma_map_sg(dev, areq->dst, edesc->dst_nents ? : 1,
@@ -1186,17 +1194,17 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 
 		/* Add an entry to the link table for ICV data */
 		tbl_ptr += sg_count - 1;
-		tbl_ptr->j_extent = 0;
+		to_talitos_ptr_ext_set(tbl_ptr, 0, 0);
 		tbl_ptr++;
-		tbl_ptr->j_extent = DESC_PTR_LNKTBL_RETURN;
-		tbl_ptr->len = cpu_to_be16(authsize);
+		to_talitos_ptr_ext_set(tbl_ptr, DESC_PTR_LNKTBL_RETURN, 0);
+		to_talitos_ptr_len(tbl_ptr, authsize, 0);
 
 		/* icv data follows link tables */
 		to_talitos_ptr(tbl_ptr, edesc->dma_link_tbl +
 					(edesc->src_nents + edesc->dst_nents +
 					 2) * sizeof(struct talitos_ptr) +
 					authsize, 0);
-		desc->ptr[5].j_extent |= DESC_PTR_LNKTBL_JUMP;
+		to_talitos_ptr_ext_or(&desc->ptr[5], DESC_PTR_LNKTBL_JUMP, 0);
 		dma_sync_single_for_device(ctx->dev, edesc->dma_link_tbl,
 					   edesc->dma_len, DMA_BIDIRECTIONAL);
 
@@ -1493,7 +1501,7 @@ int map_sg_in_talitos_ptr(struct device *dev, struct scatterlist *src,
 						   len, DMA_TO_DEVICE);
 		}
 	} else {
-		to_talitos_ptr_extent_clear(ptr, is_sec1);
+		to_talitos_ptr_ext_set(ptr, 0, is_sec1);
 
 		sg_count = dma_map_sg(dev, src, edesc->src_nents ? : 1, dir);
 
@@ -1504,7 +1512,8 @@ int map_sg_in_talitos_ptr(struct device *dev, struct scatterlist *src,
 						  &edesc->link_tbl[0]);
 			if (sg_count > 1) {
 				to_talitos_ptr(ptr, edesc->dma_link_tbl, 0);
-				ptr->j_extent |= DESC_PTR_LNKTBL_JUMP;
+				to_talitos_ptr_ext_or(ptr, DESC_PTR_LNKTBL_JUMP,
+						      0);
 				dma_sync_single_for_device(dev,
 							   edesc->dma_link_tbl,
 							   edesc->dma_len,
@@ -1544,7 +1553,7 @@ void map_sg_out_talitos_ptr(struct device *dev, struct scatterlist *dst,
 						   len, DMA_FROM_DEVICE);
 		}
 	} else {
-		to_talitos_ptr_extent_clear(ptr, is_sec1);
+		to_talitos_ptr_ext_set(ptr, 0, is_sec1);
 
 		if (sg_count == 1) {
 			to_talitos_ptr(ptr, sg_dma_address(dst), is_sec1);
@@ -1555,7 +1564,7 @@ void map_sg_out_talitos_ptr(struct device *dev, struct scatterlist *dst,
 			to_talitos_ptr(ptr, edesc->dma_link_tbl +
 					    (edesc->src_nents + 1) *
 					     sizeof(struct talitos_ptr), 0);
-			ptr->j_extent |= DESC_PTR_LNKTBL_JUMP;
+			to_talitos_ptr_ext_or(ptr, DESC_PTR_LNKTBL_JUMP, 0);
 			sg_to_link_tbl(dst, sg_count, len, link_tbl_ptr);
 			dma_sync_single_for_device(dev, edesc->dma_link_tbl,
 						   edesc->dma_len,
@@ -1586,7 +1595,7 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 	/* cipher iv */
 	to_talitos_ptr(&desc->ptr[1], edesc->iv_dma, is_sec1);
 	to_talitos_ptr_len(&desc->ptr[1], ivsize, is_sec1);
-	to_talitos_ptr_extent_clear(&desc->ptr[1], is_sec1);
+	to_talitos_ptr_ext_set(&desc->ptr[1], 0, is_sec1);
 
 	/* cipher key */
 	map_single_talitos_ptr(dev, &desc->ptr[2], ctx->keylen,
-- 
2.1.0
