From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7/8] crypto: talitos - Convert to new AEAD interface
Date: Thu, 30 Jul 2015 17:53:22 +0800
Message-ID: <E1ZKkWg-0004CN-0l@gondolin.me.apana.org.au>
References: <20150730094138.GA15941@gondor.apana.org.au>
Cc: Horia Geanta <horia.geanta@freescale.com>,
	Christophe Leroy <christophe.leroy@c-s.fr>,
	Cristian Stoica <cristian.stoica@freescale.com>,
	Kim Phillips <kim.phillips@freescale.com>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41395 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973AbbG3Jx1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Jul 2015 05:53:27 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts talitos to the new AEAD interface.  IV generation
has been removed since it's equivalent to a software implementation.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/talitos.c |  606 +++++++++++++++++++++--------------------------
 1 file changed, 277 insertions(+), 329 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 83aca95..43727c9 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -799,7 +799,6 @@ struct talitos_ctx {
 	unsigned int keylen;
 	unsigned int enckeylen;
 	unsigned int authkeylen;
-	unsigned int authsize;
 };
 
 #define HASH_MAX_BLOCK_SIZE		SHA512_BLOCK_SIZE
@@ -819,16 +818,6 @@ struct talitos_ahash_req_ctx {
 	struct scatterlist *psrc;
 };
 
-static int aead_setauthsize(struct crypto_aead *authenc,
-			    unsigned int authsize)
-{
-	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
-
-	ctx->authsize = authsize;
-
-	return 0;
-}
-
 static int aead_setkey(struct crypto_aead *authenc,
 		       const u8 *key, unsigned int keylen)
 {
@@ -857,12 +846,11 @@ badkey:
 
 /*
  * talitos_edesc - s/w-extended descriptor
- * @assoc_nents: number of segments in associated data scatterlist
  * @src_nents: number of segments in input scatterlist
  * @dst_nents: number of segments in output scatterlist
- * @assoc_chained: whether assoc is chained or not
  * @src_chained: whether src is chained or not
  * @dst_chained: whether dst is chained or not
+ * @icv_ool: whether ICV is out-of-line
  * @iv_dma: dma address of iv for checking continuity and link table
  * @dma_len: length of dma mapped link_tbl space
  * @dma_link_tbl: bus physical address of link_tbl/buf
@@ -875,12 +863,11 @@ badkey:
  * of link_tbl data
  */
 struct talitos_edesc {
-	int assoc_nents;
 	int src_nents;
 	int dst_nents;
-	bool assoc_chained;
 	bool src_chained;
 	bool dst_chained;
+	bool icv_ool;
 	dma_addr_t iv_dma;
 	int dma_len;
 	dma_addr_t dma_link_tbl;
@@ -952,14 +939,6 @@ static void ipsec_esp_unmap(struct device *dev,
 	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[2], DMA_TO_DEVICE);
 	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[0], DMA_TO_DEVICE);
 
-	if (edesc->assoc_chained)
-		talitos_unmap_sg_chain(dev, areq->assoc, DMA_TO_DEVICE);
-	else if (areq->assoclen)
-		/* assoc_nents counts also for IV in non-contiguous cases */
-		dma_unmap_sg(dev, areq->assoc,
-			     edesc->assoc_nents ? edesc->assoc_nents - 1 : 1,
-			     DMA_TO_DEVICE);
-
 	talitos_sg_unmap(dev, edesc, areq->src, areq->dst);
 
 	if (edesc->dma_len)
@@ -976,7 +955,7 @@ static void ipsec_esp_encrypt_done(struct device *dev,
 {
 	struct aead_request *areq = context;
 	struct crypto_aead *authenc = crypto_aead_reqtfm(areq);
-	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
+	unsigned int authsize = crypto_aead_authsize(authenc);
 	struct talitos_edesc *edesc;
 	struct scatterlist *sg;
 	void *icvdata;
@@ -986,13 +965,12 @@ static void ipsec_esp_encrypt_done(struct device *dev,
 	ipsec_esp_unmap(dev, edesc, areq);
 
 	/* copy the generated ICV to dst */
-	if (edesc->dst_nents) {
+	if (edesc->icv_ool) {
 		icvdata = &edesc->link_tbl[edesc->src_nents +
-					   edesc->dst_nents + 2 +
-					   edesc->assoc_nents];
+					   edesc->dst_nents + 2];
 		sg = sg_last(areq->dst, edesc->dst_nents);
-		memcpy((char *)sg_virt(sg) + sg->length - ctx->authsize,
-		       icvdata, ctx->authsize);
+		memcpy((char *)sg_virt(sg) + sg->length - authsize,
+		       icvdata, authsize);
 	}
 
 	kfree(edesc);
@@ -1006,10 +984,10 @@ static void ipsec_esp_decrypt_swauth_done(struct device *dev,
 {
 	struct aead_request *req = context;
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
-	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
+	unsigned int authsize = crypto_aead_authsize(authenc);
 	struct talitos_edesc *edesc;
 	struct scatterlist *sg;
-	void *icvdata;
+	char *oicv, *icv;
 
 	edesc = container_of(desc, struct talitos_edesc, desc);
 
@@ -1017,16 +995,18 @@ static void ipsec_esp_decrypt_swauth_done(struct device *dev,
 
 	if (!err) {
 		/* auth check */
-		if (edesc->dma_len)
-			icvdata = &edesc->link_tbl[edesc->src_nents +
-						   edesc->dst_nents + 2 +
-						   edesc->assoc_nents];
-		else
-			icvdata = &edesc->link_tbl[0];
-
 		sg = sg_last(req->dst, edesc->dst_nents ? : 1);
-		err = memcmp(icvdata, (char *)sg_virt(sg) + sg->length -
-			     ctx->authsize, ctx->authsize) ? -EBADMSG : 0;
+		icv = (char *)sg_virt(sg) + sg->length - authsize;
+
+		if (edesc->dma_len) {
+			oicv = (char *)&edesc->link_tbl[edesc->src_nents +
+							edesc->dst_nents + 2];
+			if (edesc->icv_ool)
+				icv = oicv + authsize;
+		} else
+			oicv = (char *)&edesc->link_tbl[0];
+
+		err = memcmp(oicv, icv, authsize) ? -EBADMSG : 0;
 	}
 
 	kfree(edesc);
@@ -1059,53 +1039,69 @@ static void ipsec_esp_decrypt_hwauth_done(struct device *dev,
  * convert scatterlist to SEC h/w link table format
  * stop at cryptlen bytes
  */
-static int sg_to_link_tbl(struct scatterlist *sg, int sg_count,
-			   int cryptlen, struct talitos_ptr *link_tbl_ptr)
+static int sg_to_link_tbl_offset(struct scatterlist *sg, int sg_count,
+				 unsigned int offset, int cryptlen,
+				 struct talitos_ptr *link_tbl_ptr)
 {
 	int n_sg = sg_count;
+	int count = 0;
 
-	while (sg && n_sg--) {
-		to_talitos_ptr(link_tbl_ptr, sg_dma_address(sg), 0);
-		link_tbl_ptr->len = cpu_to_be16(sg_dma_len(sg));
-		link_tbl_ptr->j_extent = 0;
-		link_tbl_ptr++;
-		cryptlen -= sg_dma_len(sg);
-		sg = sg_next(sg);
-	}
+	while (cryptlen && sg && n_sg--) {
+		unsigned int len = sg_dma_len(sg);
 
-	/* adjust (decrease) last one (or two) entry's len to cryptlen */
-	link_tbl_ptr--;
-	while (be16_to_cpu(link_tbl_ptr->len) <= (-cryptlen)) {
-		/* Empty this entry, and move to previous one */
-		cryptlen += be16_to_cpu(link_tbl_ptr->len);
-		link_tbl_ptr->len = 0;
-		sg_count--;
-		link_tbl_ptr--;
+		if (offset >= len) {
+			offset -= len;
+			goto next;
+		}
+
+		len -= offset;
+
+		if (len > cryptlen)
+			len = cryptlen;
+
+		to_talitos_ptr(link_tbl_ptr + count,
+			       sg_dma_address(sg) + offset, 0);
+		link_tbl_ptr[count].len = cpu_to_be16(len);
+		link_tbl_ptr[count].j_extent = 0;
+		count++;
+		cryptlen -= len;
+		offset = 0;
+
+next:
+		sg = sg_next(sg);
 	}
-	link_tbl_ptr->len = cpu_to_be16(be16_to_cpu(link_tbl_ptr->len)
-					+ cryptlen);
 
 	/* tag end of link table */
-	link_tbl_ptr->j_extent = DESC_PTR_LNKTBL_RETURN;
+	if (count > 0)
+		link_tbl_ptr[count - 1].j_extent = DESC_PTR_LNKTBL_RETURN;
 
-	return sg_count;
+	return count;
+}
+
+static inline int sg_to_link_tbl(struct scatterlist *sg, int sg_count,
+				 int cryptlen,
+				 struct talitos_ptr *link_tbl_ptr)
+{
+	return sg_to_link_tbl_offset(sg, sg_count, 0, cryptlen,
+				     link_tbl_ptr);
 }
 
 /*
  * fill in and submit ipsec_esp descriptor
  */
 static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
-		     u64 seq, void (*callback) (struct device *dev,
-						struct talitos_desc *desc,
-						void *context, int error))
+		     void (*callback)(struct device *dev,
+				      struct talitos_desc *desc,
+				      void *context, int error))
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(areq);
+	unsigned int authsize = crypto_aead_authsize(aead);
 	struct talitos_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *dev = ctx->dev;
 	struct talitos_desc *desc = &edesc->desc;
 	unsigned int cryptlen = areq->cryptlen;
-	unsigned int authsize = ctx->authsize;
 	unsigned int ivsize = crypto_aead_ivsize(aead);
+	int tbl_off = 0;
 	int sg_count, ret;
 	int sg_link_tbl_len;
 
@@ -1113,36 +1109,27 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	map_single_talitos_ptr(dev, &desc->ptr[0], ctx->authkeylen, &ctx->key,
 			       DMA_TO_DEVICE);
 
+	sg_count = talitos_map_sg(dev, areq->src, edesc->src_nents ?: 1,
+				  (areq->src == areq->dst) ? DMA_BIDIRECTIONAL
+							   : DMA_TO_DEVICE,
+				  edesc->src_chained);
+
 	/* hmac data */
-	desc->ptr[1].len = cpu_to_be16(areq->assoclen + ivsize);
-	if (edesc->assoc_nents) {
-		int tbl_off = edesc->src_nents + edesc->dst_nents + 2;
-		struct talitos_ptr *tbl_ptr = &edesc->link_tbl[tbl_off];
+	desc->ptr[1].len = cpu_to_be16(areq->assoclen);
+	if (sg_count > 1 &&
+	    (ret = sg_to_link_tbl_offset(areq->src, sg_count, 0,
+					 areq->assoclen,
+					 &edesc->link_tbl[tbl_off])) > 1) {
+		tbl_off += ret;
 
 		to_talitos_ptr(&desc->ptr[1], edesc->dma_link_tbl + tbl_off *
 			       sizeof(struct talitos_ptr), 0);
 		desc->ptr[1].j_extent = DESC_PTR_LNKTBL_JUMP;
 
-		/* assoc_nents - 1 entries for assoc, 1 for IV */
-		sg_count = sg_to_link_tbl(areq->assoc, edesc->assoc_nents - 1,
-					  areq->assoclen, tbl_ptr);
-
-		/* add IV to link table */
-		tbl_ptr += sg_count - 1;
-		tbl_ptr->j_extent = 0;
-		tbl_ptr++;
-		to_talitos_ptr(tbl_ptr, edesc->iv_dma, 0);
-		tbl_ptr->len = cpu_to_be16(ivsize);
-		tbl_ptr->j_extent = DESC_PTR_LNKTBL_RETURN;
-
 		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
 					   edesc->dma_len, DMA_BIDIRECTIONAL);
 	} else {
-		if (areq->assoclen)
-			to_talitos_ptr(&desc->ptr[1],
-				       sg_dma_address(areq->assoc), 0);
-		else
-			to_talitos_ptr(&desc->ptr[1], edesc->iv_dma, 0);
+		to_talitos_ptr(&desc->ptr[1], sg_dma_address(areq->src), 0);
 		desc->ptr[1].j_extent = 0;
 	}
 
@@ -1150,8 +1137,6 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	to_talitos_ptr(&desc->ptr[2], edesc->iv_dma, 0);
 	desc->ptr[2].len = cpu_to_be16(ivsize);
 	desc->ptr[2].j_extent = 0;
-	/* Sync needed for the aead_givencrypt case */
-	dma_sync_single_for_device(dev, edesc->iv_dma, ivsize, DMA_TO_DEVICE);
 
 	/* cipher key */
 	map_single_talitos_ptr(dev, &desc->ptr[3], ctx->enckeylen,
@@ -1167,33 +1152,24 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	desc->ptr[4].len = cpu_to_be16(cryptlen);
 	desc->ptr[4].j_extent = authsize;
 
-	sg_count = talitos_map_sg(dev, areq->src, edesc->src_nents ? : 1,
-				  (areq->src == areq->dst) ? DMA_BIDIRECTIONAL
-							   : DMA_TO_DEVICE,
-				  edesc->src_chained);
-
-	if (sg_count == 1) {
+	sg_link_tbl_len = cryptlen;
+	if (edesc->desc.hdr & DESC_HDR_MODE1_MDEU_CICV)
+		sg_link_tbl_len += authsize;
+
+	if (sg_count > 1 &&
+	    (ret = sg_to_link_tbl_offset(areq->src, sg_count, areq->assoclen,
+					 sg_link_tbl_len,
+					 &edesc->link_tbl[tbl_off])) > 1) {
+		tbl_off += ret;
+		desc->ptr[4].j_extent |= DESC_PTR_LNKTBL_JUMP;
+		to_talitos_ptr(&desc->ptr[4], edesc->dma_link_tbl +
+					      tbl_off *
+					      sizeof(struct talitos_ptr), 0);
+		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
+					   edesc->dma_len,
+					   DMA_BIDIRECTIONAL);
+	} else
 		to_talitos_ptr(&desc->ptr[4], sg_dma_address(areq->src), 0);
-	} else {
-		sg_link_tbl_len = cryptlen;
-
-		if (edesc->desc.hdr & DESC_HDR_MODE1_MDEU_CICV)
-			sg_link_tbl_len = cryptlen + authsize;
-
-		sg_count = sg_to_link_tbl(areq->src, sg_count, sg_link_tbl_len,
-					  &edesc->link_tbl[0]);
-		if (sg_count > 1) {
-			desc->ptr[4].j_extent |= DESC_PTR_LNKTBL_JUMP;
-			to_talitos_ptr(&desc->ptr[4], edesc->dma_link_tbl, 0);
-			dma_sync_single_for_device(dev, edesc->dma_link_tbl,
-						   edesc->dma_len,
-						   DMA_BIDIRECTIONAL);
-		} else {
-			/* Only one segment now, so no link tbl needed */
-			to_talitos_ptr(&desc->ptr[4],
-				       sg_dma_address(areq->src), 0);
-		}
-	}
 
 	/* cipher out */
 	desc->ptr[5].len = cpu_to_be16(cryptlen);
@@ -1204,16 +1180,17 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 					  edesc->dst_nents ? : 1,
 					  DMA_FROM_DEVICE, edesc->dst_chained);
 
-	if (sg_count == 1) {
-		to_talitos_ptr(&desc->ptr[5], sg_dma_address(areq->dst), 0);
-	} else {
-		int tbl_off = edesc->src_nents + 1;
+	edesc->icv_ool = false;
+
+	if (sg_count > 1 &&
+	    (sg_count = sg_to_link_tbl_offset(areq->dst, sg_count,
+					      areq->assoclen, cryptlen,
+					      &edesc->link_tbl[tbl_off])) >
+	    1) {
 		struct talitos_ptr *tbl_ptr = &edesc->link_tbl[tbl_off];
 
 		to_talitos_ptr(&desc->ptr[5], edesc->dma_link_tbl +
 			       tbl_off * sizeof(struct talitos_ptr), 0);
-		sg_count = sg_to_link_tbl(areq->dst, sg_count, cryptlen,
-					  tbl_ptr);
 
 		/* Add an entry to the link table for ICV data */
 		tbl_ptr += sg_count - 1;
@@ -1224,13 +1201,16 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 
 		/* icv data follows link tables */
 		to_talitos_ptr(tbl_ptr, edesc->dma_link_tbl +
-			       (tbl_off + edesc->dst_nents + 1 +
-				edesc->assoc_nents) *
-			       sizeof(struct talitos_ptr), 0);
+					(edesc->src_nents + edesc->dst_nents +
+					 2) * sizeof(struct talitos_ptr) +
+					authsize, 0);
 		desc->ptr[5].j_extent |= DESC_PTR_LNKTBL_JUMP;
 		dma_sync_single_for_device(ctx->dev, edesc->dma_link_tbl,
 					   edesc->dma_len, DMA_BIDIRECTIONAL);
-	}
+
+		edesc->icv_ool = true;
+	} else
+		to_talitos_ptr(&desc->ptr[5], sg_dma_address(areq->dst), 0);
 
 	/* iv out */
 	map_single_talitos_ptr(dev, &desc->ptr[6], ivsize, ctx->iv,
@@ -1268,7 +1248,6 @@ static int sg_count(struct scatterlist *sg_list, int nbytes, bool *chained)
  * allocate and map the extended descriptor
  */
 static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
-						 struct scatterlist *assoc,
 						 struct scatterlist *src,
 						 struct scatterlist *dst,
 						 u8 *iv,
@@ -1281,8 +1260,8 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 						 bool encrypt)
 {
 	struct talitos_edesc *edesc;
-	int assoc_nents = 0, src_nents, dst_nents, alloc_len, dma_len;
-	bool assoc_chained = false, src_chained = false, dst_chained = false;
+	int src_nents, dst_nents, alloc_len, dma_len;
+	bool src_chained = false, dst_chained = false;
 	dma_addr_t iv_dma = 0;
 	gfp_t flags = cryptoflags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
 		      GFP_ATOMIC;
@@ -1298,48 +1277,35 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 	if (ivsize)
 		iv_dma = dma_map_single(dev, iv, ivsize, DMA_TO_DEVICE);
 
-	if (assoclen) {
-		/*
-		 * Currently it is assumed that iv is provided whenever assoc
-		 * is.
-		 */
-		BUG_ON(!iv);
-
-		assoc_nents = sg_count(assoc, assoclen, &assoc_chained);
-		talitos_map_sg(dev, assoc, assoc_nents, DMA_TO_DEVICE,
-			       assoc_chained);
-		assoc_nents = (assoc_nents == 1) ? 0 : assoc_nents;
-
-		if (assoc_nents || sg_dma_address(assoc) + assoclen != iv_dma)
-			assoc_nents = assoc_nents ? assoc_nents + 1 : 2;
-	}
-
 	if (!dst || dst == src) {
-		src_nents = sg_count(src, cryptlen + authsize, &src_chained);
+		src_nents = sg_count(src, assoclen + cryptlen + authsize,
+				     &src_chained);
 		src_nents = (src_nents == 1) ? 0 : src_nents;
 		dst_nents = dst ? src_nents : 0;
 	} else { /* dst && dst != src*/
-		src_nents = sg_count(src, cryptlen + (encrypt ? 0 : authsize),
+		src_nents = sg_count(src, assoclen + cryptlen +
+					  (encrypt ? 0 : authsize),
 				     &src_chained);
 		src_nents = (src_nents == 1) ? 0 : src_nents;
-		dst_nents = sg_count(dst, cryptlen + (encrypt ? authsize : 0),
+		dst_nents = sg_count(dst, assoclen + cryptlen +
+					  (encrypt ? authsize : 0),
 				     &dst_chained);
 		dst_nents = (dst_nents == 1) ? 0 : dst_nents;
 	}
 
 	/*
 	 * allocate space for base edesc plus the link tables,
-	 * allowing for two separate entries for ICV and generated ICV (+ 2),
-	 * and the ICV data itself
+	 * allowing for two separate entries for AD and generated ICV (+ 2),
+	 * and space for two sets of ICVs (stashed and generated)
 	 */
 	alloc_len = sizeof(struct talitos_edesc);
-	if (assoc_nents || src_nents || dst_nents) {
+	if (src_nents || dst_nents) {
 		if (is_sec1)
 			dma_len = (src_nents ? cryptlen : 0) +
 				  (dst_nents ? cryptlen : 0);
 		else
-			dma_len = (src_nents + dst_nents + 2 + assoc_nents) *
-				  sizeof(struct talitos_ptr) + authsize;
+			dma_len = (src_nents + dst_nents + 2) *
+				  sizeof(struct talitos_ptr) + authsize * 2;
 		alloc_len += dma_len;
 	} else {
 		dma_len = 0;
@@ -1348,13 +1314,6 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 
 	edesc = kmalloc(alloc_len, GFP_DMA | flags);
 	if (!edesc) {
-		if (assoc_chained)
-			talitos_unmap_sg_chain(dev, assoc, DMA_TO_DEVICE);
-		else if (assoclen)
-			dma_unmap_sg(dev, assoc,
-				     assoc_nents ? assoc_nents - 1 : 1,
-				     DMA_TO_DEVICE);
-
 		if (iv_dma)
 			dma_unmap_single(dev, iv_dma, ivsize, DMA_TO_DEVICE);
 
@@ -1362,10 +1321,8 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 		return ERR_PTR(-ENOMEM);
 	}
 
-	edesc->assoc_nents = assoc_nents;
 	edesc->src_nents = src_nents;
 	edesc->dst_nents = dst_nents;
-	edesc->assoc_chained = assoc_chained;
 	edesc->src_chained = src_chained;
 	edesc->dst_chained = dst_chained;
 	edesc->iv_dma = iv_dma;
@@ -1382,12 +1339,13 @@ static struct talitos_edesc *aead_edesc_alloc(struct aead_request *areq, u8 *iv,
 					      int icv_stashing, bool encrypt)
 {
 	struct crypto_aead *authenc = crypto_aead_reqtfm(areq);
+	unsigned int authsize = crypto_aead_authsize(authenc);
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
 	unsigned int ivsize = crypto_aead_ivsize(authenc);
 
-	return talitos_edesc_alloc(ctx->dev, areq->assoc, areq->src, areq->dst,
+	return talitos_edesc_alloc(ctx->dev, areq->src, areq->dst,
 				   iv, areq->assoclen, areq->cryptlen,
-				   ctx->authsize, ivsize, icv_stashing,
+				   authsize, ivsize, icv_stashing,
 				   areq->base.flags, encrypt);
 }
 
@@ -1405,14 +1363,14 @@ static int aead_encrypt(struct aead_request *req)
 	/* set encrypt */
 	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_MODE0_ENCRYPT;
 
-	return ipsec_esp(edesc, req, 0, ipsec_esp_encrypt_done);
+	return ipsec_esp(edesc, req, ipsec_esp_encrypt_done);
 }
 
 static int aead_decrypt(struct aead_request *req)
 {
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
+	unsigned int authsize = crypto_aead_authsize(authenc);
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
-	unsigned int authsize = ctx->authsize;
 	struct talitos_private *priv = dev_get_drvdata(ctx->dev);
 	struct talitos_edesc *edesc;
 	struct scatterlist *sg;
@@ -1437,7 +1395,7 @@ static int aead_decrypt(struct aead_request *req)
 		/* reset integrity check result bits */
 		edesc->desc.hdr_lo = 0;
 
-		return ipsec_esp(edesc, req, 0, ipsec_esp_decrypt_hwauth_done);
+		return ipsec_esp(edesc, req, ipsec_esp_decrypt_hwauth_done);
 	}
 
 	/* Have to check the ICV with software */
@@ -1445,40 +1403,16 @@ static int aead_decrypt(struct aead_request *req)
 
 	/* stash incoming ICV for later cmp with ICV generated by the h/w */
 	if (edesc->dma_len)
-		icvdata = &edesc->link_tbl[edesc->src_nents +
-					   edesc->dst_nents + 2 +
-					   edesc->assoc_nents];
+		icvdata = (char *)&edesc->link_tbl[edesc->src_nents +
+						   edesc->dst_nents + 2];
 	else
 		icvdata = &edesc->link_tbl[0];
 
 	sg = sg_last(req->src, edesc->src_nents ? : 1);
 
-	memcpy(icvdata, (char *)sg_virt(sg) + sg->length - ctx->authsize,
-	       ctx->authsize);
-
-	return ipsec_esp(edesc, req, 0, ipsec_esp_decrypt_swauth_done);
-}
-
-static int aead_givencrypt(struct aead_givcrypt_request *req)
-{
-	struct aead_request *areq = &req->areq;
-	struct crypto_aead *authenc = crypto_aead_reqtfm(areq);
-	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
-	struct talitos_edesc *edesc;
-
-	/* allocate extended descriptor */
-	edesc = aead_edesc_alloc(areq, req->giv, 0, true);
-	if (IS_ERR(edesc))
-		return PTR_ERR(edesc);
+	memcpy(icvdata, (char *)sg_virt(sg) + sg->length - authsize, authsize);
 
-	/* set encrypt */
-	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_MODE0_ENCRYPT;
-
-	memcpy(req->giv, ctx->iv, crypto_aead_ivsize(authenc));
-	/* avoid consecutive packets going out with same IV */
-	*(__be64 *)req->giv ^= cpu_to_be64(req->seq);
-
-	return ipsec_esp(edesc, areq, req->seq, ipsec_esp_encrypt_done);
+	return ipsec_esp(edesc, req, ipsec_esp_decrypt_swauth_done);
 }
 
 static int ablkcipher_setkey(struct crypto_ablkcipher *cipher,
@@ -1710,7 +1644,7 @@ static struct talitos_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request *
 	struct talitos_ctx *ctx = crypto_ablkcipher_ctx(cipher);
 	unsigned int ivsize = crypto_ablkcipher_ivsize(cipher);
 
-	return talitos_edesc_alloc(ctx->dev, NULL, areq->src, areq->dst,
+	return talitos_edesc_alloc(ctx->dev, areq->src, areq->dst,
 				   areq->info, 0, areq->nbytes, 0, ivsize, 0,
 				   areq->base.flags, encrypt);
 }
@@ -1895,7 +1829,7 @@ static struct talitos_edesc *ahash_edesc_alloc(struct ahash_request *areq,
 	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 
-	return talitos_edesc_alloc(ctx->dev, NULL, req_ctx->psrc, NULL, NULL, 0,
+	return talitos_edesc_alloc(ctx->dev, req_ctx->psrc, NULL, NULL, 0,
 				   nbytes, 0, 0, 0, areq->base.flags, false);
 }
 
@@ -2161,6 +2095,7 @@ struct talitos_alg_template {
 	union {
 		struct crypto_alg crypto;
 		struct ahash_alg hash;
+		struct aead_alg aead;
 	} alg;
 	__be32 desc_hdr_template;
 };
@@ -2168,15 +2103,16 @@ struct talitos_alg_template {
 static struct talitos_alg_template driver_algs[] = {
 	/* AEAD algorithms.  These use a single-pass ipsec_esp descriptor */
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.crypto = {
-			.cra_name = "authenc(hmac(sha1),cbc(aes))",
-			.cra_driver_name = "authenc-hmac-sha1-cbc-aes-talitos",
-			.cra_blocksize = AES_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
-			.cra_aead = {
-				.ivsize = AES_BLOCK_SIZE,
-				.maxauthsize = SHA1_DIGEST_SIZE,
-			}
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha1),cbc(aes))",
+				.cra_driver_name = "authenc-hmac-sha1-"
+						   "cbc-aes-talitos",
+				.cra_blocksize = AES_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC,
+			},
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA1_DIGEST_SIZE,
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
 			             DESC_HDR_SEL0_AESU |
@@ -2187,15 +2123,17 @@ static struct talitos_alg_template driver_algs[] = {
 		                     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.crypto = {
-			.cra_name = "authenc(hmac(sha1),cbc(des3_ede))",
-			.cra_driver_name = "authenc-hmac-sha1-cbc-3des-talitos",
-			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
-			.cra_aead = {
-				.ivsize = DES3_EDE_BLOCK_SIZE,
-				.maxauthsize = SHA1_DIGEST_SIZE,
-			}
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha1),"
+					    "cbc(des3_ede))",
+				.cra_driver_name = "authenc-hmac-sha1-"
+						   "cbc-3des-talitos",
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC,
+			},
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = SHA1_DIGEST_SIZE,
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
 			             DESC_HDR_SEL0_DEU |
@@ -2207,15 +2145,16 @@ static struct talitos_alg_template driver_algs[] = {
 		                     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
 	},
 	{       .type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.crypto = {
-			.cra_name = "authenc(hmac(sha224),cbc(aes))",
-			.cra_driver_name = "authenc-hmac-sha224-cbc-aes-talitos",
-			.cra_blocksize = AES_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
-			.cra_aead = {
-				.ivsize = AES_BLOCK_SIZE,
-				.maxauthsize = SHA224_DIGEST_SIZE,
-			}
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha224),cbc(aes))",
+				.cra_driver_name = "authenc-hmac-sha224-"
+						   "cbc-aes-talitos",
+				.cra_blocksize = AES_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC,
+			},
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA224_DIGEST_SIZE,
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
 				     DESC_HDR_SEL0_AESU |
@@ -2226,15 +2165,17 @@ static struct talitos_alg_template driver_algs[] = {
 				     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.crypto = {
-			.cra_name = "authenc(hmac(sha224),cbc(des3_ede))",
-			.cra_driver_name = "authenc-hmac-sha224-cbc-3des-talitos",
-			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
-			.cra_aead = {
-				.ivsize = DES3_EDE_BLOCK_SIZE,
-				.maxauthsize = SHA224_DIGEST_SIZE,
-			}
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha224),"
+					    "cbc(des3_ede))",
+				.cra_driver_name = "authenc-hmac-sha224-"
+						   "cbc-3des-talitos",
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC,
+			},
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = SHA224_DIGEST_SIZE,
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
 			             DESC_HDR_SEL0_DEU |
@@ -2246,15 +2187,16 @@ static struct talitos_alg_template driver_algs[] = {
 		                     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.crypto = {
-			.cra_name = "authenc(hmac(sha256),cbc(aes))",
-			.cra_driver_name = "authenc-hmac-sha256-cbc-aes-talitos",
-			.cra_blocksize = AES_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
-			.cra_aead = {
-				.ivsize = AES_BLOCK_SIZE,
-				.maxauthsize = SHA256_DIGEST_SIZE,
-			}
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha256),cbc(aes))",
+				.cra_driver_name = "authenc-hmac-sha256-"
+						   "cbc-aes-talitos",
+				.cra_blocksize = AES_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC,
+			},
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA256_DIGEST_SIZE,
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
 			             DESC_HDR_SEL0_AESU |
@@ -2265,15 +2207,17 @@ static struct talitos_alg_template driver_algs[] = {
 		                     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.crypto = {
-			.cra_name = "authenc(hmac(sha256),cbc(des3_ede))",
-			.cra_driver_name = "authenc-hmac-sha256-cbc-3des-talitos",
-			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
-			.cra_aead = {
-				.ivsize = DES3_EDE_BLOCK_SIZE,
-				.maxauthsize = SHA256_DIGEST_SIZE,
-			}
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha256),"
+					    "cbc(des3_ede))",
+				.cra_driver_name = "authenc-hmac-sha256-"
+						   "cbc-3des-talitos",
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC,
+			},
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = SHA256_DIGEST_SIZE,
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
 			             DESC_HDR_SEL0_DEU |
@@ -2285,15 +2229,16 @@ static struct talitos_alg_template driver_algs[] = {
 		                     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.crypto = {
-			.cra_name = "authenc(hmac(sha384),cbc(aes))",
-			.cra_driver_name = "authenc-hmac-sha384-cbc-aes-talitos",
-			.cra_blocksize = AES_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
-			.cra_aead = {
-				.ivsize = AES_BLOCK_SIZE,
-				.maxauthsize = SHA384_DIGEST_SIZE,
-			}
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha384),cbc(aes))",
+				.cra_driver_name = "authenc-hmac-sha384-"
+						   "cbc-aes-talitos",
+				.cra_blocksize = AES_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC,
+			},
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA384_DIGEST_SIZE,
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
 			             DESC_HDR_SEL0_AESU |
@@ -2304,15 +2249,17 @@ static struct talitos_alg_template driver_algs[] = {
 		                     DESC_HDR_MODE1_MDEUB_SHA384_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.crypto = {
-			.cra_name = "authenc(hmac(sha384),cbc(des3_ede))",
-			.cra_driver_name = "authenc-hmac-sha384-cbc-3des-talitos",
-			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
-			.cra_aead = {
-				.ivsize = DES3_EDE_BLOCK_SIZE,
-				.maxauthsize = SHA384_DIGEST_SIZE,
-			}
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha384),"
+					    "cbc(des3_ede))",
+				.cra_driver_name = "authenc-hmac-sha384-"
+						   "cbc-3des-talitos",
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC,
+			},
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = SHA384_DIGEST_SIZE,
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
 			             DESC_HDR_SEL0_DEU |
@@ -2324,15 +2271,16 @@ static struct talitos_alg_template driver_algs[] = {
 		                     DESC_HDR_MODE1_MDEUB_SHA384_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.crypto = {
-			.cra_name = "authenc(hmac(sha512),cbc(aes))",
-			.cra_driver_name = "authenc-hmac-sha512-cbc-aes-talitos",
-			.cra_blocksize = AES_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
-			.cra_aead = {
-				.ivsize = AES_BLOCK_SIZE,
-				.maxauthsize = SHA512_DIGEST_SIZE,
-			}
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha512),cbc(aes))",
+				.cra_driver_name = "authenc-hmac-sha512-"
+						   "cbc-aes-talitos",
+				.cra_blocksize = AES_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC,
+			},
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA512_DIGEST_SIZE,
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
 			             DESC_HDR_SEL0_AESU |
@@ -2343,15 +2291,17 @@ static struct talitos_alg_template driver_algs[] = {
 		                     DESC_HDR_MODE1_MDEUB_SHA512_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.crypto = {
-			.cra_name = "authenc(hmac(sha512),cbc(des3_ede))",
-			.cra_driver_name = "authenc-hmac-sha512-cbc-3des-talitos",
-			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
-			.cra_aead = {
-				.ivsize = DES3_EDE_BLOCK_SIZE,
-				.maxauthsize = SHA512_DIGEST_SIZE,
-			}
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha512),"
+					    "cbc(des3_ede))",
+				.cra_driver_name = "authenc-hmac-sha512-"
+						   "cbc-3des-talitos",
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC,
+			},
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = SHA512_DIGEST_SIZE,
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
 			             DESC_HDR_SEL0_DEU |
@@ -2363,15 +2313,16 @@ static struct talitos_alg_template driver_algs[] = {
 		                     DESC_HDR_MODE1_MDEUB_SHA512_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.crypto = {
-			.cra_name = "authenc(hmac(md5),cbc(aes))",
-			.cra_driver_name = "authenc-hmac-md5-cbc-aes-talitos",
-			.cra_blocksize = AES_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
-			.cra_aead = {
-				.ivsize = AES_BLOCK_SIZE,
-				.maxauthsize = MD5_DIGEST_SIZE,
-			}
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(md5),cbc(aes))",
+				.cra_driver_name = "authenc-hmac-md5-"
+						   "cbc-aes-talitos",
+				.cra_blocksize = AES_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC,
+			},
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = MD5_DIGEST_SIZE,
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
 			             DESC_HDR_SEL0_AESU |
@@ -2382,15 +2333,16 @@ static struct talitos_alg_template driver_algs[] = {
 		                     DESC_HDR_MODE1_MDEU_MD5_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.crypto = {
-			.cra_name = "authenc(hmac(md5),cbc(des3_ede))",
-			.cra_driver_name = "authenc-hmac-md5-cbc-3des-talitos",
-			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
-			.cra_aead = {
-				.ivsize = DES3_EDE_BLOCK_SIZE,
-				.maxauthsize = MD5_DIGEST_SIZE,
-			}
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(md5),cbc(des3_ede))",
+				.cra_driver_name = "authenc-hmac-md5-"
+						   "cbc-3des-talitos",
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC,
+			},
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = MD5_DIGEST_SIZE,
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
 			             DESC_HDR_SEL0_DEU |
@@ -2658,15 +2610,9 @@ static int talitos_cra_init(struct crypto_tfm *tfm)
 	return 0;
 }
 
-static int talitos_cra_init_aead(struct crypto_tfm *tfm)
+static int talitos_cra_init_aead(struct crypto_aead *tfm)
 {
-	struct talitos_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	talitos_cra_init(tfm);
-
-	/* random first IV */
-	get_random_bytes(ctx->iv, TALITOS_MAX_IV_LENGTH);
-
+	talitos_cra_init(crypto_aead_tfm(tfm));
 	return 0;
 }
 
@@ -2713,9 +2659,9 @@ static int talitos_remove(struct platform_device *ofdev)
 	list_for_each_entry_safe(t_alg, n, &priv->alg_list, entry) {
 		switch (t_alg->algt.type) {
 		case CRYPTO_ALG_TYPE_ABLKCIPHER:
-		case CRYPTO_ALG_TYPE_AEAD:
-			crypto_unregister_alg(&t_alg->algt.alg.crypto);
 			break;
+		case CRYPTO_ALG_TYPE_AEAD:
+			crypto_unregister_aead(&t_alg->algt.alg.aead);
 		case CRYPTO_ALG_TYPE_AHASH:
 			crypto_unregister_ahash(&t_alg->algt.alg.hash);
 			break;
@@ -2774,15 +2720,12 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 		alg->cra_ablkcipher.geniv = "eseqiv";
 		break;
 	case CRYPTO_ALG_TYPE_AEAD:
-		alg = &t_alg->algt.alg.crypto;
-		alg->cra_init = talitos_cra_init_aead;
-		alg->cra_type = &crypto_aead_type;
-		alg->cra_aead.setkey = aead_setkey;
-		alg->cra_aead.setauthsize = aead_setauthsize;
-		alg->cra_aead.encrypt = aead_encrypt;
-		alg->cra_aead.decrypt = aead_decrypt;
-		alg->cra_aead.givencrypt = aead_givencrypt;
-		alg->cra_aead.geniv = "<built-in>";
+		alg = &t_alg->algt.alg.aead.base;
+		alg->cra_flags |= CRYPTO_ALG_AEAD_NEW;
+		t_alg->algt.alg.aead.init = talitos_cra_init_aead;
+		t_alg->algt.alg.aead.setkey = aead_setkey;
+		t_alg->algt.alg.aead.encrypt = aead_encrypt;
+		t_alg->algt.alg.aead.decrypt = aead_decrypt;
 		break;
 	case CRYPTO_ALG_TYPE_AHASH:
 		alg = &t_alg->algt.alg.hash.halg.base;
@@ -3041,7 +2984,7 @@ static int talitos_probe(struct platform_device *ofdev)
 	for (i = 0; i < ARRAY_SIZE(driver_algs); i++) {
 		if (hw_supports(dev, driver_algs[i].desc_hdr_template)) {
 			struct talitos_crypto_alg *t_alg;
-			char *name = NULL;
+			struct crypto_alg *alg = NULL;
 
 			t_alg = talitos_alg_alloc(dev, &driver_algs[i]);
 			if (IS_ERR(t_alg)) {
@@ -3053,21 +2996,26 @@ static int talitos_probe(struct platform_device *ofdev)
 
 			switch (t_alg->algt.type) {
 			case CRYPTO_ALG_TYPE_ABLKCIPHER:
-			case CRYPTO_ALG_TYPE_AEAD:
 				err = crypto_register_alg(
 						&t_alg->algt.alg.crypto);
-				name = t_alg->algt.alg.crypto.cra_driver_name;
+				alg = &t_alg->algt.alg.crypto;
 				break;
+
+			case CRYPTO_ALG_TYPE_AEAD:
+				err = crypto_register_aead(
+					&t_alg->algt.alg.aead);
+				alg = &t_alg->algt.alg.aead.base;
+				break;
+
 			case CRYPTO_ALG_TYPE_AHASH:
 				err = crypto_register_ahash(
 						&t_alg->algt.alg.hash);
-				name =
-				 t_alg->algt.alg.hash.halg.base.cra_driver_name;
+				alg = &t_alg->algt.alg.hash.halg.base;
 				break;
 			}
 			if (err) {
 				dev_err(dev, "%s alg registration failed\n",
-					name);
+					alg->cra_driver_name);
 				kfree(t_alg);
 			} else
 				list_add_tail(&t_alg->entry, &priv->alg_list);
