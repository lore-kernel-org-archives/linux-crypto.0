From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v2 4/7] crypto: talitos - Implement AEAD for SEC1 using
 HMAC_SNOOP_NO_AFEU
Date: Mon,  6 Jun 2016 13:20:40 +0200 (CEST)
Message-ID: <44eaf332c48a5c3a73ea89848bb65d56188d41c2.1464390096.git.christophe.leroy@c-s.fr>
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

This patchs enhances the IPSEC_ESP related functions for them to
also supports the same operations with descriptor type
HMAC_SNOOP_NO_AFEU.

The differences between the two descriptor types are:
* pointeurs 2 and 3 are swaped (Confidentiality key and
    Primary EU Context IN)
* HMAC_SNOOP_NO_AFEU has CICV out in pointer 6
* HMAC_SNOOP_NO_AFEU has no primary EU context out so we get it
from the end of data out

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 209 ++++++++++++++++++++++++++++-------------------
 1 file changed, 124 insertions(+), 85 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index b0d3c24..4ff03c3 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -940,7 +940,13 @@ static void ipsec_esp_unmap(struct device *dev,
 			    struct talitos_edesc *edesc,
 			    struct aead_request *areq)
 {
-	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[6], DMA_FROM_DEVICE);
+	struct crypto_aead *aead = crypto_aead_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_aead_ctx(aead);
+	unsigned int ivsize = crypto_aead_ivsize(aead);
+
+	if (edesc->desc.hdr & DESC_HDR_TYPE_IPSEC_ESP)
+		unmap_single_talitos_ptr(dev, &edesc->desc.ptr[6],
+					 DMA_FROM_DEVICE);
 	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[3], DMA_TO_DEVICE);
 	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[2], DMA_TO_DEVICE);
 	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[0], DMA_TO_DEVICE);
@@ -951,6 +957,13 @@ static void ipsec_esp_unmap(struct device *dev,
 	if (edesc->dma_len)
 		dma_unmap_single(dev, edesc->dma_link_tbl, edesc->dma_len,
 				 DMA_BIDIRECTIONAL);
+
+	if (!(edesc->desc.hdr & DESC_HDR_TYPE_IPSEC_ESP)) {
+		unsigned int dst_nents = edesc->dst_nents ? : 1;
+
+		sg_pcopy_to_buffer(areq->dst, dst_nents, ctx->iv, ivsize,
+				   areq->assoclen + areq->cryptlen - ivsize);
+	}
 }
 
 /*
@@ -960,6 +973,8 @@ static void ipsec_esp_encrypt_done(struct device *dev,
 				   struct talitos_desc *desc, void *context,
 				   int err)
 {
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	bool is_sec1 = has_ftr_sec1(priv);
 	struct aead_request *areq = context;
 	struct crypto_aead *authenc = crypto_aead_reqtfm(areq);
 	unsigned int authsize = crypto_aead_authsize(authenc);
@@ -973,8 +988,11 @@ static void ipsec_esp_encrypt_done(struct device *dev,
 
 	/* copy the generated ICV to dst */
 	if (edesc->icv_ool) {
-		icvdata = &edesc->link_tbl[edesc->src_nents +
-					   edesc->dst_nents + 2];
+		if (is_sec1)
+			icvdata = edesc->buf + areq->assoclen + areq->cryptlen;
+		else
+			icvdata = &edesc->link_tbl[edesc->src_nents +
+						   edesc->dst_nents + 2];
 		sg = sg_last(areq->dst, edesc->dst_nents);
 		memcpy((char *)sg_virt(sg) + sg->length - authsize,
 		       icvdata, authsize);
@@ -995,6 +1013,8 @@ static void ipsec_esp_decrypt_swauth_done(struct device *dev,
 	struct talitos_edesc *edesc;
 	struct scatterlist *sg;
 	char *oicv, *icv;
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	bool is_sec1 = has_ftr_sec1(priv);
 
 	edesc = container_of(desc, struct talitos_edesc, desc);
 
@@ -1006,7 +1026,12 @@ static void ipsec_esp_decrypt_swauth_done(struct device *dev,
 		icv = (char *)sg_virt(sg) + sg->length - authsize;
 
 		if (edesc->dma_len) {
-			oicv = (char *)&edesc->link_tbl[edesc->src_nents +
+			if (is_sec1)
+				oicv = (char *)&edesc->dma_link_tbl +
+					       req->assoclen + req->cryptlen;
+			else
+				oicv = (char *)
+				       &edesc->link_tbl[edesc->src_nents +
 							edesc->dst_nents + 2];
 			if (edesc->icv_ool)
 				icv = oicv + authsize;
@@ -1145,42 +1170,52 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	int tbl_off = 0;
 	int sg_count, ret;
 	int sg_link_tbl_len;
+	bool sync_needed = false;
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	bool is_sec1 = has_ftr_sec1(priv);
 
 	/* hmac key */
 	map_single_talitos_ptr(dev, &desc->ptr[0], ctx->authkeylen, &ctx->key,
 			       DMA_TO_DEVICE);
 
-	sg_count = dma_map_sg(dev, areq->src, edesc->src_nents ?: 1,
-			      (areq->src == areq->dst) ? DMA_BIDIRECTIONAL
-							   : DMA_TO_DEVICE);
-	/* hmac data */
-	to_talitos_ptr_len(&desc->ptr[1], areq->assoclen, 0);
-	if (sg_count > 1 &&
-	    (ret = sg_to_link_tbl_offset(areq->src, sg_count, 0,
-					 areq->assoclen,
-					 &edesc->link_tbl[tbl_off])) > 1) {
-		to_talitos_ptr(&desc->ptr[1], edesc->dma_link_tbl + tbl_off *
-			       sizeof(struct talitos_ptr), 0);
-		to_talitos_ptr_ext_set(&desc->ptr[1], DESC_PTR_LNKTBL_JUMP, 0);
+	sg_count = edesc->src_nents ?: 1;
+	if (is_sec1 && sg_count > 1)
+		sg_copy_to_buffer(areq->src, sg_count, edesc->buf,
+				  areq->assoclen + cryptlen);
+	else
+		sg_count = dma_map_sg(dev, areq->src, sg_count,
+				      (areq->src == areq->dst) ?
+				      DMA_BIDIRECTIONAL : DMA_TO_DEVICE);
 
-		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
-					   edesc->dma_len, DMA_BIDIRECTIONAL);
+	/* hmac data */
+	ret = talitos_sg_map(dev, areq->src, areq->assoclen, edesc,
+			     &desc->ptr[1], sg_count, 0, tbl_off);
 
+	if (ret > 1) {
 		tbl_off += ret;
-	} else {
-		to_talitos_ptr(&desc->ptr[1], sg_dma_address(areq->src), 0);
-		to_talitos_ptr_ext_set(&desc->ptr[1], 0, 0);
+		sync_needed = true;
 	}
 
 	/* cipher iv */
-	to_talitos_ptr(&desc->ptr[2], edesc->iv_dma, 0);
-	to_talitos_ptr_len(&desc->ptr[2], ivsize, 0);
-	to_talitos_ptr_ext_set(&desc->ptr[2], 0, 0);
+	if (desc->hdr & DESC_HDR_TYPE_IPSEC_ESP) {
+		to_talitos_ptr(&desc->ptr[2], edesc->iv_dma, is_sec1);
+		to_talitos_ptr_len(&desc->ptr[2], ivsize, is_sec1);
+		to_talitos_ptr_ext_set(&desc->ptr[2], 0, is_sec1);
+	} else {
+		to_talitos_ptr(&desc->ptr[3], edesc->iv_dma, is_sec1);
+		to_talitos_ptr_len(&desc->ptr[3], ivsize, is_sec1);
+		to_talitos_ptr_ext_set(&desc->ptr[3], 0, is_sec1);
+	}
 
 	/* cipher key */
-	map_single_talitos_ptr(dev, &desc->ptr[3], ctx->enckeylen,
-			       (char *)&ctx->key + ctx->authkeylen,
-			       DMA_TO_DEVICE);
+	if (desc->hdr & DESC_HDR_TYPE_IPSEC_ESP)
+		map_single_talitos_ptr(dev, &desc->ptr[3], ctx->enckeylen,
+				       (char *)&ctx->key + ctx->authkeylen,
+				       DMA_TO_DEVICE);
+	else
+		map_single_talitos_ptr(dev, &desc->ptr[2], ctx->enckeylen,
+				       (char *)&ctx->key + ctx->authkeylen,
+				       DMA_TO_DEVICE);
 
 	/*
 	 * cipher in
@@ -1188,78 +1223,82 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	 * extent is bytes of HMAC postpended to ciphertext,
 	 * typically 12 for ipsec
 	 */
-	to_talitos_ptr_len(&desc->ptr[4], cryptlen, 0);
-	to_talitos_ptr_ext_set(&desc->ptr[4], authsize, 0);
+	to_talitos_ptr_len(&desc->ptr[4], cryptlen, is_sec1);
+	to_talitos_ptr_ext_set(&desc->ptr[4], 0, is_sec1);
 
 	sg_link_tbl_len = cryptlen;
-	if (edesc->desc.hdr & DESC_HDR_MODE1_MDEU_CICV)
-		sg_link_tbl_len += authsize;
 
-	if (sg_count == 1) {
-		to_talitos_ptr(&desc->ptr[4], sg_dma_address(areq->src) +
-			       areq->assoclen, 0);
-	} else if ((ret = sg_to_link_tbl_offset(areq->src, sg_count,
-						areq->assoclen, sg_link_tbl_len,
-						&edesc->link_tbl[tbl_off])) >
-		   1) {
-		to_talitos_ptr_ext_or(&desc->ptr[4], DESC_PTR_LNKTBL_JUMP, 0);
-		to_talitos_ptr(&desc->ptr[4], edesc->dma_link_tbl +
-					      tbl_off *
-					      sizeof(struct talitos_ptr), 0);
-		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
-					   edesc->dma_len,
-					   DMA_BIDIRECTIONAL);
-		tbl_off += ret;
-	} else {
-		copy_talitos_ptr(&desc->ptr[4], &edesc->link_tbl[tbl_off], 0);
+	if (desc->hdr & DESC_HDR_TYPE_IPSEC_ESP) {
+		to_talitos_ptr_ext_set(&desc->ptr[4], authsize, is_sec1);
+
+		if (edesc->desc.hdr & DESC_HDR_MODE1_MDEU_CICV)
+			sg_link_tbl_len += authsize;
 	}
 
-	/* cipher out */
-	to_talitos_ptr_len(&desc->ptr[5], cryptlen, 0);
-	to_talitos_ptr_ext_set(&desc->ptr[5], authsize, 0);
+	sg_count = talitos_sg_map(dev, areq->src, cryptlen, edesc,
+				  &desc->ptr[4], sg_count, areq->assoclen,
+				  tbl_off);
+
+	if (sg_count > 1) {
+		tbl_off += sg_count;
+		sync_needed = true;
+	}
 
-	if (areq->src != areq->dst)
-		sg_count = dma_map_sg(dev, areq->dst, edesc->dst_nents ? : 1,
-				      DMA_FROM_DEVICE);
+	/* cipher out */
+	if (areq->src != areq->dst) {
+		sg_count = edesc->dst_nents ? : 1;
+		if (!is_sec1 || sg_count == 1)
+			dma_map_sg(dev, areq->dst, sg_count, DMA_FROM_DEVICE);
+	}
 
-	edesc->icv_ool = false;
+	sg_count = talitos_sg_map(dev, areq->dst, cryptlen, edesc,
+				  &desc->ptr[5], sg_count, areq->assoclen,
+				  tbl_off);
 
-	if (sg_count == 1) {
-		to_talitos_ptr(&desc->ptr[5], sg_dma_address(areq->dst) +
-			       areq->assoclen, 0);
-	} else if ((sg_count =
-			sg_to_link_tbl_offset(areq->dst, sg_count,
-					      areq->assoclen, cryptlen,
-					      &edesc->link_tbl[tbl_off])) > 1) {
-		struct talitos_ptr *tbl_ptr = &edesc->link_tbl[tbl_off];
-
-		to_talitos_ptr(&desc->ptr[5], edesc->dma_link_tbl +
-			       tbl_off * sizeof(struct talitos_ptr), 0);
-
-		/* Add an entry to the link table for ICV data */
-		tbl_ptr += sg_count - 1;
-		to_talitos_ptr_ext_set(tbl_ptr, 0, 0);
-		tbl_ptr++;
-		to_talitos_ptr_ext_set(tbl_ptr, DESC_PTR_LNKTBL_RETURN, 0);
-		to_talitos_ptr_len(tbl_ptr, authsize, 0);
-
-		/* icv data follows link tables */
-		to_talitos_ptr(tbl_ptr, edesc->dma_link_tbl +
-					(edesc->src_nents + edesc->dst_nents +
-					 2) * sizeof(struct talitos_ptr) +
-					authsize, 0);
-		to_talitos_ptr_ext_or(&desc->ptr[5], DESC_PTR_LNKTBL_JUMP, 0);
-		dma_sync_single_for_device(ctx->dev, edesc->dma_link_tbl,
-					   edesc->dma_len, DMA_BIDIRECTIONAL);
+	if (desc->hdr & DESC_HDR_TYPE_IPSEC_ESP)
+		to_talitos_ptr_ext_or(&desc->ptr[5], authsize, is_sec1);
 
+	if (sg_count > 1) {
 		edesc->icv_ool = true;
+		sync_needed = true;
+
+		if (desc->hdr & DESC_HDR_TYPE_IPSEC_ESP) {
+			struct talitos_ptr *tbl_ptr = &edesc->link_tbl[tbl_off];
+			int offset = (edesc->src_nents + edesc->dst_nents + 2) *
+				     sizeof(struct talitos_ptr) + authsize;
+
+			/* Add an entry to the link table for ICV data */
+			tbl_ptr += sg_count - 1;
+			to_talitos_ptr_ext_set(tbl_ptr, 0, is_sec1);
+			tbl_ptr++;
+			to_talitos_ptr_ext_set(tbl_ptr, DESC_PTR_LNKTBL_RETURN,
+					       is_sec1);
+			to_talitos_ptr_len(tbl_ptr, authsize, is_sec1);
+
+			/* icv data follows link tables */
+			to_talitos_ptr(tbl_ptr, edesc->dma_link_tbl + offset,
+				       is_sec1);
+		}
 	} else {
-		copy_talitos_ptr(&desc->ptr[5], &edesc->link_tbl[tbl_off], 0);
+		edesc->icv_ool = false;
+	}
+
+	/* ICV data */
+	if (!(desc->hdr & DESC_HDR_TYPE_IPSEC_ESP)) {
+		to_talitos_ptr_len(&desc->ptr[6], authsize, is_sec1);
+		to_talitos_ptr(&desc->ptr[6], edesc->dma_link_tbl +
+			       areq->assoclen + cryptlen, is_sec1);
 	}
 
 	/* iv out */
-	map_single_talitos_ptr(dev, &desc->ptr[6], ivsize, ctx->iv,
-			       DMA_FROM_DEVICE);
+	if (desc->hdr & DESC_HDR_TYPE_IPSEC_ESP)
+		map_single_talitos_ptr(dev, &desc->ptr[6], ivsize, ctx->iv,
+				       DMA_FROM_DEVICE);
+
+	if (sync_needed)
+		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
+					   edesc->dma_len,
+					   DMA_BIDIRECTIONAL);
 
 	ret = talitos_submit(dev, ctx->ch, desc, callback, areq);
 	if (ret != -EINPROGRESS) {
-- 
2.1.0
