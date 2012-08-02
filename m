From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH 4/5] crypto: talitos - support for assoc data provided as scatterlist
Date: Thu, 2 Aug 2012 17:16:40 +0300
Message-ID: <1343917001-20001-4-git-send-email-horia.geanta@freescale.com>
References: <1343917001-20001-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Kim Phillips <kim.phillips@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:55095
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752669Ab2HBORt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Aug 2012 10:17:49 -0400
In-Reply-To: <1343917001-20001-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Generate a link table in case assoc data is a scatterlist.
While at it, add support for handling non-contiguous assoc data and iv.

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/talitos.c |  176 ++++++++++++++++++++++++++++++++-------------
 1 files changed, 125 insertions(+), 51 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 0ec8894..a57fdcd 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -714,10 +714,13 @@ badkey:
 
 /*
  * talitos_edesc - s/w-extended descriptor
+ * @assoc_nents: number of segments in associated data scatterlist
  * @src_nents: number of segments in input scatterlist
  * @dst_nents: number of segments in output scatterlist
+ * @assoc_chained: whether assoc is chained or not
  * @src_chained: whether src is chained or not
  * @dst_chained: whether dst is chained or not
+ * @iv_dma: dma address of iv for checking continuity and link table
  * @dma_len: length of dma mapped link_tbl space
  * @dma_link_tbl: bus physical address of link_tbl
  * @desc: h/w descriptor
@@ -728,10 +731,13 @@ badkey:
  * of link_tbl data
  */
 struct talitos_edesc {
+	int assoc_nents;
 	int src_nents;
 	int dst_nents;
+	bool assoc_chained;
 	bool src_chained;
 	bool dst_chained;
+	dma_addr_t iv_dma;
 	int dma_len;
 	dma_addr_t dma_link_tbl;
 	struct talitos_desc desc;
@@ -799,7 +805,13 @@ static void ipsec_esp_unmap(struct device *dev,
 	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[2], DMA_TO_DEVICE);
 	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[0], DMA_TO_DEVICE);
 
-	dma_unmap_sg(dev, areq->assoc, 1, DMA_TO_DEVICE);
+	if (edesc->assoc_chained)
+		talitos_unmap_sg_chain(dev, areq->assoc, DMA_TO_DEVICE);
+	else
+		/* assoc_nents counts also for IV in non-contiguous cases */
+		dma_unmap_sg(dev, areq->assoc,
+			     edesc->assoc_nents ? edesc->assoc_nents - 1 : 1,
+			     DMA_TO_DEVICE);
 
 	talitos_sg_unmap(dev, edesc, areq->src, areq->dst);
 
@@ -829,7 +841,8 @@ static void ipsec_esp_encrypt_done(struct device *dev,
 	/* copy the generated ICV to dst */
 	if (edesc->dst_nents) {
 		icvdata = &edesc->link_tbl[edesc->src_nents +
-					   edesc->dst_nents + 2];
+					   edesc->dst_nents + 2 +
+					   edesc->assoc_nents];
 		sg = sg_last(areq->dst, edesc->dst_nents);
 		memcpy((char *)sg_virt(sg) + sg->length - ctx->authsize,
 		       icvdata, ctx->authsize);
@@ -859,7 +872,8 @@ static void ipsec_esp_decrypt_swauth_done(struct device *dev,
 		/* auth check */
 		if (edesc->dma_len)
 			icvdata = &edesc->link_tbl[edesc->src_nents +
-						   edesc->dst_nents + 2];
+						   edesc->dst_nents + 2 +
+						   edesc->assoc_nents];
 		else
 			icvdata = &edesc->link_tbl[0];
 
@@ -934,10 +948,9 @@ static int sg_to_link_tbl(struct scatterlist *sg, int sg_count,
  * fill in and submit ipsec_esp descriptor
  */
 static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
-		     u8 *giv, u64 seq,
-		     void (*callback) (struct device *dev,
-				       struct talitos_desc *desc,
-				       void *context, int error))
+		     u64 seq, void (*callback) (struct device *dev,
+						struct talitos_desc *desc,
+						void *context, int error))
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_aead_ctx(aead);
@@ -952,12 +965,42 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	/* hmac key */
 	map_single_talitos_ptr(dev, &desc->ptr[0], ctx->authkeylen, &ctx->key,
 			       0, DMA_TO_DEVICE);
+
 	/* hmac data */
-	map_single_talitos_ptr(dev, &desc->ptr[1], areq->assoclen + ivsize,
-			       sg_virt(areq->assoc), 0, DMA_TO_DEVICE);
+	desc->ptr[1].len = cpu_to_be16(areq->assoclen + ivsize);
+	if (edesc->assoc_nents) {
+		int tbl_off = edesc->src_nents + edesc->dst_nents + 2;
+		struct talitos_ptr *tbl_ptr = &edesc->link_tbl[tbl_off];
+
+		to_talitos_ptr(&desc->ptr[1], edesc->dma_link_tbl + tbl_off *
+			       sizeof(struct talitos_ptr));
+		desc->ptr[1].j_extent = DESC_PTR_LNKTBL_JUMP;
+
+		/* assoc_nents - 1 entries for assoc, 1 for IV */
+		sg_count = sg_to_link_tbl(areq->assoc, edesc->assoc_nents - 1,
+					  areq->assoclen, tbl_ptr);
+
+		/* add IV to link table */
+		tbl_ptr += sg_count - 1;
+		tbl_ptr->j_extent = 0;
+		tbl_ptr++;
+		to_talitos_ptr(tbl_ptr, edesc->iv_dma);
+		tbl_ptr->len = cpu_to_be16(ivsize);
+		tbl_ptr->j_extent = DESC_PTR_LNKTBL_RETURN;
+
+		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
+					   edesc->dma_len, DMA_BIDIRECTIONAL);
+	} else {
+		to_talitos_ptr(&desc->ptr[1], sg_dma_address(areq->assoc));
+		desc->ptr[1].j_extent = 0;
+	}
+
 	/* cipher iv */
-	map_single_talitos_ptr(dev, &desc->ptr[2], ivsize, giv ?: areq->iv, 0,
-			       DMA_TO_DEVICE);
+	to_talitos_ptr(&desc->ptr[2], edesc->iv_dma);
+	desc->ptr[2].len = cpu_to_be16(ivsize);
+	desc->ptr[2].j_extent = 0;
+	/* Sync needed for the aead_givencrypt case */
+	dma_sync_single_for_device(dev, edesc->iv_dma, ivsize, DMA_TO_DEVICE);
 
 	/* cipher key */
 	map_single_talitos_ptr(dev, &desc->ptr[3], ctx->enckeylen,
@@ -1013,26 +1056,25 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	if (sg_count == 1) {
 		to_talitos_ptr(&desc->ptr[5], sg_dma_address(areq->dst));
 	} else {
-		struct talitos_ptr *link_tbl_ptr =
-			&edesc->link_tbl[edesc->src_nents + 1];
+		int tbl_off = edesc->src_nents + 1;
+		struct talitos_ptr *tbl_ptr = &edesc->link_tbl[tbl_off];
 
 		to_talitos_ptr(&desc->ptr[5], edesc->dma_link_tbl +
-			       (edesc->src_nents + 1) *
-			       sizeof(struct talitos_ptr));
+			       tbl_off * sizeof(struct talitos_ptr));
 		sg_count = sg_to_link_tbl(areq->dst, sg_count, cryptlen,
-					  link_tbl_ptr);
+					  tbl_ptr);
 
 		/* Add an entry to the link table for ICV data */
-		link_tbl_ptr += sg_count - 1;
-		link_tbl_ptr->j_extent = 0;
-		sg_count++;
-		link_tbl_ptr++;
-		link_tbl_ptr->j_extent = DESC_PTR_LNKTBL_RETURN;
-		link_tbl_ptr->len = cpu_to_be16(authsize);
+		tbl_ptr += sg_count - 1;
+		tbl_ptr->j_extent = 0;
+		tbl_ptr++;
+		tbl_ptr->j_extent = DESC_PTR_LNKTBL_RETURN;
+		tbl_ptr->len = cpu_to_be16(authsize);
 
 		/* icv data follows link tables */
-		to_talitos_ptr(link_tbl_ptr, edesc->dma_link_tbl +
-			       (edesc->src_nents + edesc->dst_nents + 2) *
+		to_talitos_ptr(tbl_ptr, edesc->dma_link_tbl +
+			       (tbl_off + edesc->dst_nents + 1 +
+				edesc->assoc_nents) *
 			       sizeof(struct talitos_ptr));
 		desc->ptr[5].j_extent |= DESC_PTR_LNKTBL_JUMP;
 		dma_sync_single_for_device(ctx->dev, edesc->dma_link_tbl,
@@ -1133,16 +1175,21 @@ static size_t sg_copy_end_to_buffer(struct scatterlist *sgl, unsigned int nents,
  * allocate and map the extended descriptor
  */
 static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
+						 struct scatterlist *assoc,
 						 struct scatterlist *src,
 						 struct scatterlist *dst,
+						 u8 *iv,
+						 unsigned int assoclen,
 						 unsigned int cryptlen,
 						 unsigned int authsize,
+						 unsigned int ivsize,
 						 int icv_stashing,
 						 u32 cryptoflags)
 {
 	struct talitos_edesc *edesc;
-	int src_nents, dst_nents, alloc_len, dma_len;
-	bool src_chained, dst_chained = false;
+	int assoc_nents = 0, src_nents, dst_nents, alloc_len, dma_len;
+	bool assoc_chained = false, src_chained = false, dst_chained = false;
+	dma_addr_t iv_dma = 0;
 	gfp_t flags = cryptoflags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
 		      GFP_ATOMIC;
 
@@ -1151,6 +1198,25 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 		return ERR_PTR(-EINVAL);
 	}
 
+	if (iv)
+		iv_dma = dma_map_single(dev, iv, ivsize, DMA_TO_DEVICE);
+
+	if (assoc) {
+		/*
+		 * Currently it is assumed that iv is provided whenever assoc
+		 * is.
+		 */
+		BUG_ON(!iv);
+
+		assoc_nents = sg_count(assoc, assoclen, &assoc_chained);
+		talitos_map_sg(dev, assoc, assoc_nents, DMA_TO_DEVICE,
+			       assoc_chained);
+		assoc_nents = (assoc_nents == 1) ? 0 : assoc_nents;
+
+		if (assoc_nents || sg_dma_address(assoc) + assoclen != iv_dma)
+			assoc_nents = assoc_nents ? assoc_nents + 1 : 2;
+	}
+
 	src_nents = sg_count(src, cryptlen + authsize, &src_chained);
 	src_nents = (src_nents == 1) ? 0 : src_nents;
 
@@ -1172,9 +1238,9 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 	 * and the ICV data itself
 	 */
 	alloc_len = sizeof(struct talitos_edesc);
-	if (src_nents || dst_nents) {
-		dma_len = (src_nents + dst_nents + 2) *
-				 sizeof(struct talitos_ptr) + authsize;
+	if (assoc_nents || src_nents || dst_nents) {
+		dma_len = (src_nents + dst_nents + 2 + assoc_nents) *
+			  sizeof(struct talitos_ptr) + authsize;
 		alloc_len += dma_len;
 	} else {
 		dma_len = 0;
@@ -1183,14 +1249,20 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 
 	edesc = kmalloc(alloc_len, GFP_DMA | flags);
 	if (!edesc) {
+		talitos_unmap_sg_chain(dev, assoc, DMA_TO_DEVICE);
+		if (iv_dma)
+			dma_unmap_single(dev, iv_dma, ivsize, DMA_TO_DEVICE);
 		dev_err(dev, "could not allocate edescriptor\n");
 		return ERR_PTR(-ENOMEM);
 	}
 
+	edesc->assoc_nents = assoc_nents;
 	edesc->src_nents = src_nents;
 	edesc->dst_nents = dst_nents;
+	edesc->assoc_chained = assoc_chained;
 	edesc->src_chained = src_chained;
 	edesc->dst_chained = dst_chained;
+	edesc->iv_dma = iv_dma;
 	edesc->dma_len = dma_len;
 	if (dma_len)
 		edesc->dma_link_tbl = dma_map_single(dev, &edesc->link_tbl[0],
@@ -1200,14 +1272,16 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 	return edesc;
 }
 
-static struct talitos_edesc *aead_edesc_alloc(struct aead_request *areq,
+static struct talitos_edesc *aead_edesc_alloc(struct aead_request *areq, u8 *iv,
 					      int icv_stashing)
 {
 	struct crypto_aead *authenc = crypto_aead_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
+	unsigned int ivsize = crypto_aead_ivsize(authenc);
 
-	return talitos_edesc_alloc(ctx->dev, areq->src, areq->dst,
-				   areq->cryptlen, ctx->authsize, icv_stashing,
+	return talitos_edesc_alloc(ctx->dev, areq->assoc, areq->src, areq->dst,
+				   iv, areq->assoclen, areq->cryptlen,
+				   ctx->authsize, ivsize, icv_stashing,
 				   areq->base.flags);
 }
 
@@ -1218,14 +1292,14 @@ static int aead_encrypt(struct aead_request *req)
 	struct talitos_edesc *edesc;
 
 	/* allocate extended descriptor */
-	edesc = aead_edesc_alloc(req, 0);
+	edesc = aead_edesc_alloc(req, req->iv, 0);
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
 	/* set encrypt */
 	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_MODE0_ENCRYPT;
 
-	return ipsec_esp(edesc, req, NULL, 0, ipsec_esp_encrypt_done);
+	return ipsec_esp(edesc, req, 0, ipsec_esp_encrypt_done);
 }
 
 static int aead_decrypt(struct aead_request *req)
@@ -1241,7 +1315,7 @@ static int aead_decrypt(struct aead_request *req)
 	req->cryptlen -= authsize;
 
 	/* allocate extended descriptor */
-	edesc = aead_edesc_alloc(req, 1);
+	edesc = aead_edesc_alloc(req, req->iv, 1);
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
@@ -1257,9 +1331,7 @@ static int aead_decrypt(struct aead_request *req)
 		/* reset integrity check result bits */
 		edesc->desc.hdr_lo = 0;
 
-		return ipsec_esp(edesc, req, NULL, 0,
-				 ipsec_esp_decrypt_hwauth_done);
-
+		return ipsec_esp(edesc, req, 0, ipsec_esp_decrypt_hwauth_done);
 	}
 
 	/* Have to check the ICV with software */
@@ -1268,7 +1340,8 @@ static int aead_decrypt(struct aead_request *req)
 	/* stash incoming ICV for later cmp with ICV generated by the h/w */
 	if (edesc->dma_len)
 		icvdata = &edesc->link_tbl[edesc->src_nents +
-					   edesc->dst_nents + 2];
+					   edesc->dst_nents + 2 +
+					   edesc->assoc_nents];
 	else
 		icvdata = &edesc->link_tbl[0];
 
@@ -1277,7 +1350,7 @@ static int aead_decrypt(struct aead_request *req)
 	memcpy(icvdata, (char *)sg_virt(sg) + sg->length - ctx->authsize,
 	       ctx->authsize);
 
-	return ipsec_esp(edesc, req, NULL, 0, ipsec_esp_decrypt_swauth_done);
+	return ipsec_esp(edesc, req, 0, ipsec_esp_decrypt_swauth_done);
 }
 
 static int aead_givencrypt(struct aead_givcrypt_request *req)
@@ -1288,7 +1361,7 @@ static int aead_givencrypt(struct aead_givcrypt_request *req)
 	struct talitos_edesc *edesc;
 
 	/* allocate extended descriptor */
-	edesc = aead_edesc_alloc(areq, 0);
+	edesc = aead_edesc_alloc(areq, req->giv, 0);
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
@@ -1299,8 +1372,7 @@ static int aead_givencrypt(struct aead_givcrypt_request *req)
 	/* avoid consecutive packets going out with same IV */
 	*(__be64 *)req->giv ^= cpu_to_be64(req->seq);
 
-	return ipsec_esp(edesc, areq, req->giv, req->seq,
-			 ipsec_esp_encrypt_done);
+	return ipsec_esp(edesc, areq, req->seq, ipsec_esp_encrypt_done);
 }
 
 static int ablkcipher_setkey(struct crypto_ablkcipher *cipher,
@@ -1356,7 +1428,7 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 	struct device *dev = ctx->dev;
 	struct talitos_desc *desc = &edesc->desc;
 	unsigned int cryptlen = areq->nbytes;
-	unsigned int ivsize;
+	unsigned int ivsize = crypto_ablkcipher_ivsize(cipher);
 	int sg_count, ret;
 
 	/* first DWORD empty */
@@ -1365,9 +1437,9 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 	desc->ptr[0].j_extent = 0;
 
 	/* cipher iv */
-	ivsize = crypto_ablkcipher_ivsize(cipher);
-	map_single_talitos_ptr(dev, &desc->ptr[1], ivsize, areq->info, 0,
-			       DMA_TO_DEVICE);
+	to_talitos_ptr(&desc->ptr[1], edesc->iv_dma);
+	desc->ptr[1].len = cpu_to_be16(ivsize);
+	desc->ptr[1].j_extent = 0;
 
 	/* cipher key */
 	map_single_talitos_ptr(dev, &desc->ptr[2], ctx->keylen,
@@ -1449,9 +1521,11 @@ static struct talitos_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request *
 {
 	struct crypto_ablkcipher *cipher = crypto_ablkcipher_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_ablkcipher_ctx(cipher);
+	unsigned int ivsize = crypto_ablkcipher_ivsize(cipher);
 
-	return talitos_edesc_alloc(ctx->dev, areq->src, areq->dst, areq->nbytes,
-				   0, 0, areq->base.flags);
+	return talitos_edesc_alloc(ctx->dev, NULL, areq->src, areq->dst,
+				   areq->info, 0, areq->nbytes, 0, ivsize, 0,
+				   areq->base.flags);
 }
 
 static int ablkcipher_encrypt(struct ablkcipher_request *areq)
@@ -1629,8 +1703,8 @@ static struct talitos_edesc *ahash_edesc_alloc(struct ahash_request *areq,
 	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 
-	return talitos_edesc_alloc(ctx->dev, req_ctx->psrc, NULL, nbytes, 0, 0,
-				   areq->base.flags);
+	return talitos_edesc_alloc(ctx->dev, NULL, req_ctx->psrc, NULL, NULL, 0,
+				   nbytes, 0, 0, 0, areq->base.flags);
 }
 
 static int ahash_init(struct ahash_request *areq)
-- 
1.7.3.4
