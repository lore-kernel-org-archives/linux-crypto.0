From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 3/5] crypto: talitos - whitespace/codingstyle/overrun lines
 cleanup
Date: Fri, 27 Mar 2009 22:57:34 -0500
Message-ID: <20090327225734.86450292.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, Lee Nipper <lee.nipper@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:44987 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209AbZC1DqO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Mar 2009 23:46:14 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

no functional changes.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/talitos.c |   95 +++++++++++++++++++++++-----------------------
 1 files changed, 48 insertions(+), 47 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index a0b0a63..a073e6b 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -341,7 +341,8 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 				status = error;
 
 		dma_unmap_single(dev, request->dma_desc,
-			sizeof(struct talitos_desc), DMA_BIDIRECTIONAL);
+				 sizeof(struct talitos_desc),
+				 DMA_BIDIRECTIONAL);
 
 		/* copy entries so we can call callback outside lock */
 		saved_req.desc = request->desc;
@@ -415,7 +416,8 @@ static struct talitos_desc *current_desc(struct device *dev, int ch)
 /*
  * user diagnostics; report root cause of error based on execution unit status
  */
-static void report_eu_error(struct device *dev, int ch, struct talitos_desc *desc)
+static void report_eu_error(struct device *dev, int ch,
+			    struct talitos_desc *desc)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	int i;
@@ -863,8 +865,8 @@ static void ipsec_esp_encrypt_done(struct device *dev,
 }
 
 static void ipsec_esp_decrypt_swauth_done(struct device *dev,
-				   struct talitos_desc *desc, void *context,
-				   int err)
+					  struct talitos_desc *desc,
+					  void *context, int err)
 {
 	struct aead_request *req = context;
 	struct talitos_edesc *edesc =
@@ -895,8 +897,8 @@ static void ipsec_esp_decrypt_swauth_done(struct device *dev,
 }
 
 static void ipsec_esp_decrypt_hwauth_done(struct device *dev,
-				   struct talitos_desc *desc, void *context,
-				   int err)
+					  struct talitos_desc *desc,
+					  void *context, int err)
 {
 	struct aead_request *req = context;
 	struct talitos_edesc *edesc =
@@ -905,10 +907,9 @@ static void ipsec_esp_decrypt_hwauth_done(struct device *dev,
 	ipsec_esp_unmap(dev, edesc, req);
 
 	/* check ICV auth status */
-	if (!err)
-		if ((desc->hdr_lo & DESC_HDR_LO_ICCR1_MASK) !=
-		    DESC_HDR_LO_ICCR1_PASS)
-			err = -EBADMSG;
+	if (!err && ((desc->hdr_lo & DESC_HDR_LO_ICCR1_MASK) !=
+		     DESC_HDR_LO_ICCR1_PASS))
+		err = -EBADMSG;
 
 	kfree(edesc);
 
@@ -996,10 +997,9 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	desc->ptr[4].len = cpu_to_be16(cryptlen);
 	desc->ptr[4].j_extent = authsize;
 
-	sg_count = talitos_map_sg(dev, areq->src,
-				  edesc->src_nents ? : 1,
-				  (areq->src == areq->dst) ? DMA_BIDIRECTIONAL :
-				      DMA_TO_DEVICE,
+	sg_count = talitos_map_sg(dev, areq->src, edesc->src_nents ? : 1,
+				  (areq->src == areq->dst) ? DMA_BIDIRECTIONAL
+							   : DMA_TO_DEVICE,
 				  edesc->src_is_chained);
 
 	if (sg_count == 1) {
@@ -1008,19 +1008,21 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 		sg_link_tbl_len = cryptlen;
 
 		if ((edesc->desc.hdr & DESC_HDR_MODE1_MDEU_CICV) &&
-			(edesc->desc.hdr & DESC_HDR_MODE0_ENCRYPT) == 0) {
+			(edesc->desc.hdr & DESC_HDR_MODE0_ENCRYPT) == 0)
 			sg_link_tbl_len = cryptlen + authsize;
-		}
+
 		sg_count = sg_to_link_tbl(areq->src, sg_count, sg_link_tbl_len,
 					  &edesc->link_tbl[0]);
 		if (sg_count > 1) {
 			desc->ptr[4].j_extent |= DESC_PTR_LNKTBL_JUMP;
 			desc->ptr[4].ptr = cpu_to_be32(edesc->dma_link_tbl);
-			dma_sync_single_for_device(ctx->dev, edesc->dma_link_tbl,
-						   edesc->dma_len, DMA_BIDIRECTIONAL);
+			dma_sync_single_for_device(dev, edesc->dma_link_tbl,
+						   edesc->dma_len,
+						   DMA_BIDIRECTIONAL);
 		} else {
 			/* Only one segment now, so no link tbl needed */
-			desc->ptr[4].ptr = cpu_to_be32(sg_dma_address(areq->src));
+			desc->ptr[4].ptr = cpu_to_be32(sg_dma_address(areq->
+								      src));
 		}
 	}
 
@@ -1028,12 +1030,11 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	desc->ptr[5].len = cpu_to_be16(cryptlen);
 	desc->ptr[5].j_extent = authsize;
 
-	if (areq->src != areq->dst) {
+	if (areq->src != areq->dst)
 		sg_count = talitos_map_sg(dev, areq->dst,
 					  edesc->dst_nents ? : 1,
 					  DMA_FROM_DEVICE,
 					  edesc->dst_is_chained);
-	}
 
 	if (sg_count == 1) {
 		desc->ptr[5].ptr = cpu_to_be32(sg_dma_address(areq->dst));
@@ -1078,7 +1079,6 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	return ret;
 }
 
-
 /*
  * derive number of elements in scatterlist
  */
@@ -1191,8 +1191,6 @@ static int aead_encrypt(struct aead_request *req)
 	return ipsec_esp(edesc, req, NULL, 0, ipsec_esp_encrypt_done);
 }
 
-
-
 static int aead_decrypt(struct aead_request *req)
 {
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
@@ -1211,38 +1209,38 @@ static int aead_decrypt(struct aead_request *req)
 		return PTR_ERR(edesc);
 
 	if ((priv->features & TALITOS_FTR_HW_AUTH_CHECK) &&
-	    (((!edesc->src_nents && !edesc->dst_nents) ||
-		priv->features & TALITOS_FTR_SRC_LINK_TBL_LEN_INCLUDES_EXTENT))) {
+	    ((!edesc->src_nents && !edesc->dst_nents) ||
+	     priv->features & TALITOS_FTR_SRC_LINK_TBL_LEN_INCLUDES_EXTENT)) {
 
 		/* decrypt and check the ICV */
-		edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_DIR_INBOUND |
+		edesc->desc.hdr = ctx->desc_hdr_template |
+				  DESC_HDR_DIR_INBOUND |
 				  DESC_HDR_MODE1_MDEU_CICV;
 
 		/* reset integrity check result bits */
 		edesc->desc.hdr_lo = 0;
 
-		return ipsec_esp(edesc, req, NULL, 0, ipsec_esp_decrypt_hwauth_done);
+		return ipsec_esp(edesc, req, NULL, 0,
+				 ipsec_esp_decrypt_hwauth_done);
 
-	} else {
-
-		/* Have to check the ICV with software */
+	}
 
-		edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_DIR_INBOUND;
+	/* Have to check the ICV with software */
+	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_DIR_INBOUND;
 
-		/* stash incoming ICV for later cmp with ICV generated by the h/w */
-		if (edesc->dma_len)
-			icvdata = &edesc->link_tbl[edesc->src_nents +
-						   edesc->dst_nents + 2];
-		else
-			icvdata = &edesc->link_tbl[0];
+	/* stash incoming ICV for later cmp with ICV generated by the h/w */
+	if (edesc->dma_len)
+		icvdata = &edesc->link_tbl[edesc->src_nents +
+					   edesc->dst_nents + 2];
+	else
+		icvdata = &edesc->link_tbl[0];
 
-		sg = sg_last(req->src, edesc->src_nents ? : 1);
+	sg = sg_last(req->src, edesc->src_nents ? : 1);
 
-		memcpy(icvdata, (char *)sg_virt(sg) + sg->length - ctx->authsize,
-		       ctx->authsize);
+	memcpy(icvdata, (char *)sg_virt(sg) + sg->length - ctx->authsize,
+	       ctx->authsize);
 
-		return ipsec_esp(edesc, req, NULL, 0, ipsec_esp_decrypt_swauth_done);
-	}
+	return ipsec_esp(edesc, req, NULL, 0, ipsec_esp_decrypt_swauth_done);
 }
 
 static int aead_givencrypt(struct aead_givcrypt_request *req)
@@ -1368,11 +1366,13 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 		if (sg_count > 1) {
 			desc->ptr[3].j_extent |= DESC_PTR_LNKTBL_JUMP;
 			desc->ptr[3].ptr = cpu_to_be32(edesc->dma_link_tbl);
-			dma_sync_single_for_device(ctx->dev, edesc->dma_link_tbl,
-						   edesc->dma_len, DMA_BIDIRECTIONAL);
+			dma_sync_single_for_device(dev, edesc->dma_link_tbl,
+						   edesc->dma_len,
+						   DMA_BIDIRECTIONAL);
 		} else {
 			/* Only one segment now, so no link tbl needed */
-			desc->ptr[3].ptr = cpu_to_be32(sg_dma_address(areq->src));
+			desc->ptr[3].ptr = cpu_to_be32(sg_dma_address(areq->
+								      src));
 		}
 	}
 
@@ -1419,7 +1419,8 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 	return ret;
 }
 
-static struct talitos_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request *areq)
+static struct talitos_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request *
+						    areq)
 {
 	struct crypto_ablkcipher *cipher = crypto_ablkcipher_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_ablkcipher_ctx(cipher);
-- 
1.6.1.3

