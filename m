From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH 13/18] crypto: talitos - remove to_talitos_ptr_len()
Date: Fri,  6 Oct 2017 15:04:57 +0200 (CEST)
Message-ID: <20ca74ad4fc3417744baa6ff34dd4c16a2a60506.1507284818.git.christophe.leroy@c-s.fr>
References: <cover.1507284818.git.christophe.leroy@c-s.fr>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1507284818.git.christophe.leroy@c-s.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

to_talitos_ptr() and to_talitos_ptr_len() are always called together
in order to fully set a ptr, so lets merge them into a single
helper.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 56 ++++++++++++++++++------------------------------
 1 file changed, 21 insertions(+), 35 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index e7e1bada03df..7e96db75347a 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -56,28 +56,26 @@
 #include "talitos.h"
 
 static void to_talitos_ptr(struct talitos_ptr *ptr, dma_addr_t dma_addr,
-			   bool is_sec1)
+			   unsigned int len, bool is_sec1)
 {
 	ptr->ptr = cpu_to_be32(lower_32_bits(dma_addr));
-	if (!is_sec1)
+	if (is_sec1) {
+		ptr->len1 = cpu_to_be16(len);
+	} else {
+		ptr->len = cpu_to_be16(len);
 		ptr->eptr = upper_32_bits(dma_addr);
+	}
 }
 
 static void copy_talitos_ptr(struct talitos_ptr *dst_ptr,
 			     struct talitos_ptr *src_ptr, bool is_sec1)
 {
 	dst_ptr->ptr = src_ptr->ptr;
-	if (!is_sec1)
-		dst_ptr->eptr = src_ptr->eptr;
-}
-
-static void to_talitos_ptr_len(struct talitos_ptr *ptr, unsigned int len,
-			       bool is_sec1)
-{
 	if (is_sec1) {
-		ptr->len1 = cpu_to_be16(len);
+		dst_ptr->len1 = src_ptr->len1;
 	} else {
-		ptr->len = cpu_to_be16(len);
+		dst_ptr->len = src_ptr->len;
+		dst_ptr->eptr = src_ptr->eptr;
 	}
 }
 
@@ -115,8 +113,7 @@ static void map_single_talitos_ptr(struct device *dev,
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	bool is_sec1 = has_ftr_sec1(priv);
 
-	to_talitos_ptr_len(ptr, len, is_sec1);
-	to_talitos_ptr(ptr, dma_addr, is_sec1);
+	to_talitos_ptr(ptr, dma_addr, len, is_sec1);
 }
 
 /*
@@ -1090,8 +1087,7 @@ static int sg_to_link_tbl_offset(struct scatterlist *sg, int sg_count,
 			len = cryptlen;
 
 		to_talitos_ptr(link_tbl_ptr + count,
-			       sg_dma_address(sg) + offset, 0);
-		to_talitos_ptr_len(link_tbl_ptr + count, len, 0);
+			       sg_dma_address(sg) + offset, len, 0);
 		to_talitos_ptr_ext_set(link_tbl_ptr + count, 0, 0);
 		count++;
 		cryptlen -= len;
@@ -1117,14 +1113,12 @@ static int talitos_sg_map(struct device *dev, struct scatterlist *src,
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	bool is_sec1 = has_ftr_sec1(priv);
 
-	to_talitos_ptr_len(ptr, len, is_sec1);
-
 	if (sg_count == 1) {
-		to_talitos_ptr(ptr, sg_dma_address(src) + offset, is_sec1);
+		to_talitos_ptr(ptr, sg_dma_address(src) + offset, len, is_sec1);
 		return sg_count;
 	}
 	if (is_sec1) {
-		to_talitos_ptr(ptr, edesc->dma_link_tbl + offset, is_sec1);
+		to_talitos_ptr(ptr, edesc->dma_link_tbl + offset, len, is_sec1);
 		return sg_count;
 	}
 	sg_count = sg_to_link_tbl_offset(src, sg_count, offset, len,
@@ -1135,7 +1129,7 @@ static int talitos_sg_map(struct device *dev, struct scatterlist *src,
 		return sg_count;
 	}
 	to_talitos_ptr(ptr, edesc->dma_link_tbl +
-			    tbl_off * sizeof(struct talitos_ptr), is_sec1);
+			    tbl_off * sizeof(struct talitos_ptr), len, is_sec1);
 	to_talitos_ptr_ext_or(ptr, DESC_PTR_LNKTBL_JUMP, is_sec1);
 
 	return sg_count;
@@ -1186,13 +1180,10 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	}
 
 	/* cipher iv */
-	if (desc->hdr & DESC_HDR_TYPE_IPSEC_ESP) {
-		to_talitos_ptr(&desc->ptr[2], edesc->iv_dma, is_sec1);
-		to_talitos_ptr_len(&desc->ptr[2], ivsize, is_sec1);
-	} else {
-		to_talitos_ptr(&desc->ptr[3], edesc->iv_dma, is_sec1);
-		to_talitos_ptr_len(&desc->ptr[3], ivsize, is_sec1);
-	}
+	if (desc->hdr & DESC_HDR_TYPE_IPSEC_ESP)
+		to_talitos_ptr(&desc->ptr[2], edesc->iv_dma, ivsize, is_sec1);
+	else
+		to_talitos_ptr(&desc->ptr[3], edesc->iv_dma, ivsize, is_sec1);
 
 	/* cipher key */
 	if (desc->hdr & DESC_HDR_TYPE_IPSEC_ESP)
@@ -1210,8 +1201,6 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	 * extent is bytes of HMAC postpended to ciphertext,
 	 * typically 12 for ipsec
 	 */
-	to_talitos_ptr_len(&desc->ptr[4], cryptlen, is_sec1);
-
 	sg_link_tbl_len = cryptlen;
 
 	if (desc->hdr & DESC_HDR_TYPE_IPSEC_ESP) {
@@ -1257,11 +1246,10 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 			to_talitos_ptr_ext_set(tbl_ptr - 1, 0, is_sec1);
 			to_talitos_ptr_ext_set(tbl_ptr, DESC_PTR_LNKTBL_RETURN,
 					       is_sec1);
-			to_talitos_ptr_len(tbl_ptr, authsize, is_sec1);
 
 			/* icv data follows link tables */
 			to_talitos_ptr(tbl_ptr, edesc->dma_link_tbl + offset,
-				       is_sec1);
+				       authsize, is_sec1);
 		} else {
 			dma_addr_t addr = edesc->dma_link_tbl;
 
@@ -1270,8 +1258,7 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 			else
 				addr += sizeof(struct talitos_ptr) * tbl_off;
 
-			to_talitos_ptr(&desc->ptr[6], addr, is_sec1);
-			to_talitos_ptr_len(&desc->ptr[6], authsize, is_sec1);
+			to_talitos_ptr(&desc->ptr[6], addr, authsize, is_sec1);
 		}
 	} else if (!(desc->hdr & DESC_HDR_TYPE_IPSEC_ESP)) {
 		ret = talitos_sg_map(dev, areq->dst, authsize, edesc,
@@ -1567,8 +1554,7 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 	/* first DWORD empty */
 
 	/* cipher iv */
-	to_talitos_ptr(&desc->ptr[1], edesc->iv_dma, is_sec1);
-	to_talitos_ptr_len(&desc->ptr[1], ivsize, is_sec1);
+	to_talitos_ptr(&desc->ptr[1], edesc->iv_dma, ivsize, is_sec1);
 
 	/* cipher key */
 	map_single_talitos_ptr(dev, &desc->ptr[2], ctx->keylen,
-- 
2.13.3
