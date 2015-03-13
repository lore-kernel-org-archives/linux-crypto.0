From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH 3/4] crypto: talitos - move talitos_{edesc,request} to request private ctx
Date: Fri, 13 Mar 2015 19:16:04 +0200
Message-ID: <1426266964-31738-1-git-send-email-horia.geanta@freescale.com>
References: <1426266882-31626-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Kim Phillips <kim.phillips@freescale.com>
To: <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0120.outbound.protection.outlook.com ([65.55.169.120]:50050
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752090AbbCMRbq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Mar 2015 13:31:46 -0400
In-Reply-To: <1426266882-31626-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

talitos_edesc and talitos_request structures are moved to crypto
request private context.

This avoids allocating memory in the driver in the cases when data
(assoc, in, out) is not scattered.

It is also an intermediary step towards adding backlogging support.

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/talitos.c | 467 +++++++++++++++++++++++++----------------------
 drivers/crypto/talitos.h |  54 +++++-
 2 files changed, 294 insertions(+), 227 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 857414afa29a..c184987dfcc7 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -182,23 +182,23 @@ static int init_device(struct device *dev)
 	return 0;
 }
 
-/**
- * talitos_submit - submits a descriptor to the device for processing
- * @dev:	the SEC device to be used
- * @ch:		the SEC device channel to be used
- * @desc:	the descriptor to be processed by the device
- * @callback:	whom to call when processing is complete
- * @context:	a handle for use by caller (optional)
- *
- * desc must contain valid dma-mapped (bus physical) address pointers.
- * callback must check err and feedback in descriptor header
- * for device processing status.
- */
-int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
-		   void (*callback)(struct device *dev,
-				    struct talitos_desc *desc,
-				    void *context, int error),
-		   void *context)
+static struct talitos_request *to_talitos_req(struct crypto_async_request *areq)
+{
+	switch (crypto_tfm_alg_type(areq->tfm)) {
+	case CRYPTO_ALG_TYPE_ABLKCIPHER:
+		return ablkcipher_request_ctx(ablkcipher_request_cast(areq));
+	case CRYPTO_ALG_TYPE_AHASH:
+		return ahash_request_ctx(ahash_request_cast(areq));
+	case CRYPTO_ALG_TYPE_AEAD:
+		return aead_request_ctx(container_of(areq, struct aead_request,
+						     base));
+	default:
+		return ERR_PTR(-EINVAL);
+	}
+}
+
+int talitos_submit(struct device *dev, int ch,
+		   struct crypto_async_request *areq)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	struct talitos_request *request;
@@ -214,19 +214,20 @@ int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
 	}
 
 	head = priv->chan[ch].head;
-	request = &priv->chan[ch].fifo[head];
 
-	/* map descriptor and save caller data */
-	request->dma_desc = dma_map_single(dev, desc, sizeof(*desc),
+	request = to_talitos_req(areq);
+	if (IS_ERR(request))
+		return PTR_ERR(request);
+
+	request->dma_desc = dma_map_single(dev, request->desc,
+					   sizeof(*request->desc),
 					   DMA_BIDIRECTIONAL);
-	request->callback = callback;
-	request->context = context;
 
 	/* increment fifo head */
 	priv->chan[ch].head = (priv->chan[ch].head + 1) & (priv->fifo_len - 1);
 
 	smp_wmb();
-	request->desc = desc;
+	priv->chan[ch].fifo[head] = request;
 
 	/* GO! */
 	wmb();
@@ -247,15 +248,15 @@ EXPORT_SYMBOL(talitos_submit);
 static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
-	struct talitos_request *request, saved_req;
+	struct talitos_request *request;
 	unsigned long flags;
 	int tail, status;
 
 	spin_lock_irqsave(&priv->chan[ch].tail_lock, flags);
 
 	tail = priv->chan[ch].tail;
-	while (priv->chan[ch].fifo[tail].desc) {
-		request = &priv->chan[ch].fifo[tail];
+	while (priv->chan[ch].fifo[tail]) {
+		request = priv->chan[ch].fifo[tail];
 
 		/* descriptors with their done bits set don't get the error */
 		rmb();
@@ -271,14 +272,9 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 				 sizeof(struct talitos_desc),
 				 DMA_BIDIRECTIONAL);
 
-		/* copy entries so we can call callback outside lock */
-		saved_req.desc = request->desc;
-		saved_req.callback = request->callback;
-		saved_req.context = request->context;
-
 		/* release request entry in fifo */
 		smp_wmb();
-		request->desc = NULL;
+		priv->chan[ch].fifo[tail] = NULL;
 
 		/* increment fifo tail */
 		priv->chan[ch].tail = (tail + 1) & (priv->fifo_len - 1);
@@ -287,8 +283,8 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 
 		atomic_dec(&priv->chan[ch].submit_count);
 
-		saved_req.callback(dev, saved_req.desc, saved_req.context,
-				   status);
+		request->callback(dev, request->context, status);
+
 		/* channel may resume processing in single desc error case */
 		if (error && !reset_ch && status == error)
 			return;
@@ -352,7 +348,8 @@ static u32 current_desc_hdr(struct device *dev, int ch)
 	tail = priv->chan[ch].tail;
 
 	iter = tail;
-	while (priv->chan[ch].fifo[iter].dma_desc != cur_desc) {
+	while (priv->chan[ch].fifo[iter] &&
+	       priv->chan[ch].fifo[iter]->dma_desc != cur_desc) {
 		iter = (iter + 1) & (priv->fifo_len - 1);
 		if (iter == tail) {
 			dev_err(dev, "couldn't locate current descriptor\n");
@@ -360,7 +357,8 @@ static u32 current_desc_hdr(struct device *dev, int ch)
 		}
 	}
 
-	return priv->chan[ch].fifo[iter].desc->hdr;
+	return priv->chan[ch].fifo[iter] ?
+		priv->chan[ch].fifo[iter]->desc->hdr : 0;
 }
 
 /*
@@ -652,7 +650,33 @@ struct talitos_ctx {
 #define HASH_MAX_BLOCK_SIZE		SHA512_BLOCK_SIZE
 #define TALITOS_MDEU_MAX_CONTEXT_SIZE	TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512
 
+/*
+ * talitos_ablkcipher_req_ctx - talitos private context for ablkcipher request
+ * @req:	talitos request; must be first parameter in structure
+ * @edesc:	s/w-extended descriptor
+ */
+struct talitos_ablkcipher_req_ctx {
+	struct talitos_request req;
+	struct talitos_edesc edesc;
+};
+
+/*
+ * talitos_aead_req_ctx - talitos private context for aead request
+ * @req:	talitos request; must be first parameter in structure
+ * @edesc:	s/w-extended descriptor
+ */
+struct talitos_aead_req_ctx {
+	struct talitos_request req;
+	struct talitos_edesc edesc;
+};
+
+/*
+ * talitos_ahash_req_ctx - talitos private context for ahash request
+ * @req:	talitos request; must be first parameter in structure
+ * @edesc:	s/w-extended descriptor
+ */
 struct talitos_ahash_req_ctx {
+	struct talitos_request req;
 	u32 hw_context[TALITOS_MDEU_MAX_CONTEXT_SIZE / sizeof(u32)];
 	unsigned int hw_context_size;
 	u8 buf[HASH_MAX_BLOCK_SIZE];
@@ -664,6 +688,7 @@ struct talitos_ahash_req_ctx {
 	u64 nbuf;
 	struct scatterlist bufsl[2];
 	struct scatterlist *psrc;
+	struct talitos_edesc edesc;
 };
 
 static int aead_setauthsize(struct crypto_aead *authenc,
@@ -702,38 +727,6 @@ badkey:
 	return -EINVAL;
 }
 
-/*
- * talitos_edesc - s/w-extended descriptor
- * @assoc_nents: number of segments in associated data scatterlist
- * @src_nents: number of segments in input scatterlist
- * @dst_nents: number of segments in output scatterlist
- * @assoc_chained: whether assoc is chained or not
- * @src_chained: whether src is chained or not
- * @dst_chained: whether dst is chained or not
- * @iv_dma: dma address of iv for checking continuity and link table
- * @dma_len: length of dma mapped link_tbl space
- * @dma_link_tbl: bus physical address of link_tbl
- * @desc: h/w descriptor
- * @link_tbl: input and output h/w link tables (if {src,dst}_nents > 1)
- *
- * if decrypting (with authcheck), or either one of src_nents or dst_nents
- * is greater than 1, an integrity check value is concatenated to the end
- * of link_tbl data
- */
-struct talitos_edesc {
-	int assoc_nents;
-	int src_nents;
-	int dst_nents;
-	bool assoc_chained;
-	bool src_chained;
-	bool dst_chained;
-	dma_addr_t iv_dma;
-	int dma_len;
-	dma_addr_t dma_link_tbl;
-	struct talitos_desc desc;
-	struct talitos_ptr link_tbl[0];
-};
-
 static int talitos_map_sg(struct device *dev, struct scatterlist *sg,
 			  unsigned int nents, enum dma_data_direction dir,
 			  bool chained)
@@ -813,19 +806,16 @@ static void ipsec_esp_unmap(struct device *dev,
 /*
  * ipsec_esp descriptor callbacks
  */
-static void ipsec_esp_encrypt_done(struct device *dev,
-				   struct talitos_desc *desc, void *context,
-				   int err)
+static void ipsec_esp_encrypt_done(struct device *dev, void *context, int err)
 {
 	struct aead_request *areq = context;
 	struct crypto_aead *authenc = crypto_aead_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
-	struct talitos_edesc *edesc;
+	struct talitos_aead_req_ctx *req_ctx = aead_request_ctx(areq);
+	struct talitos_edesc *edesc = &req_ctx->edesc;
 	struct scatterlist *sg;
 	void *icvdata;
 
-	edesc = container_of(desc, struct talitos_edesc, desc);
-
 	ipsec_esp_unmap(dev, edesc, areq);
 
 	/* copy the generated ICV to dst */
@@ -838,24 +828,22 @@ static void ipsec_esp_encrypt_done(struct device *dev,
 		       icvdata, ctx->authsize);
 	}
 
-	kfree(edesc);
+	kfree(edesc->link_tbl);
 
 	aead_request_complete(areq, err);
 }
 
-static void ipsec_esp_decrypt_swauth_done(struct device *dev,
-					  struct talitos_desc *desc,
-					  void *context, int err)
+static void ipsec_esp_decrypt_swauth_done(struct device *dev, void *context,
+					  int err)
 {
 	struct aead_request *req = context;
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
-	struct talitos_edesc *edesc;
+	struct talitos_aead_req_ctx *req_ctx = aead_request_ctx(req);
+	struct talitos_edesc *edesc = &req_ctx->edesc;
 	struct scatterlist *sg;
 	void *icvdata;
 
-	edesc = container_of(desc, struct talitos_edesc, desc);
-
 	ipsec_esp_unmap(dev, edesc, req);
 
 	if (!err) {
@@ -865,35 +853,33 @@ static void ipsec_esp_decrypt_swauth_done(struct device *dev,
 						   edesc->dst_nents + 2 +
 						   edesc->assoc_nents];
 		else
-			icvdata = &edesc->link_tbl[0];
+			icvdata = edesc->link_tbl;
 
 		sg = sg_last(req->dst, edesc->dst_nents ? : 1);
 		err = memcmp(icvdata, (char *)sg_virt(sg) + sg->length -
 			     ctx->authsize, ctx->authsize) ? -EBADMSG : 0;
 	}
 
-	kfree(edesc);
+	kfree(edesc->link_tbl);
 
 	aead_request_complete(req, err);
 }
 
-static void ipsec_esp_decrypt_hwauth_done(struct device *dev,
-					  struct talitos_desc *desc,
-					  void *context, int err)
+static void ipsec_esp_decrypt_hwauth_done(struct device *dev, void *context,
+					  int err)
 {
 	struct aead_request *req = context;
-	struct talitos_edesc *edesc;
-
-	edesc = container_of(desc, struct talitos_edesc, desc);
+	struct talitos_aead_req_ctx *req_ctx = aead_request_ctx(req);
+	struct talitos_edesc *edesc = &req_ctx->edesc;
 
 	ipsec_esp_unmap(dev, edesc, req);
 
 	/* check ICV auth status */
-	if (!err && ((desc->hdr_lo & DESC_HDR_LO_ICCR1_MASK) !=
+	if (!err && ((edesc->desc.hdr_lo & DESC_HDR_LO_ICCR1_MASK) !=
 		     DESC_HDR_LO_ICCR1_PASS))
 		err = -EBADMSG;
 
-	kfree(edesc);
+	kfree(edesc->link_tbl);
 
 	aead_request_complete(req, err);
 }
@@ -936,14 +922,15 @@ static int sg_to_link_tbl(struct scatterlist *sg, int sg_count,
 /*
  * fill in and submit ipsec_esp descriptor
  */
-static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
-		     u64 seq, void (*callback) (struct device *dev,
-						struct talitos_desc *desc,
-						void *context, int error))
+static int ipsec_esp(struct aead_request *areq, u64 seq,
+		     void (*callback)(struct device *dev,
+				      void *context, int error))
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *dev = ctx->dev;
+	struct talitos_aead_req_ctx *req_ctx = aead_request_ctx(areq);
+	struct talitos_edesc *edesc = &req_ctx->edesc;
 	struct talitos_desc *desc = &edesc->desc;
 	unsigned int cryptlen = areq->cryptlen;
 	unsigned int authsize = ctx->authsize;
@@ -1023,7 +1010,7 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 			sg_link_tbl_len = cryptlen + authsize;
 
 		sg_count = sg_to_link_tbl(areq->src, sg_count, sg_link_tbl_len,
-					  &edesc->link_tbl[0]);
+					  edesc->link_tbl);
 		if (sg_count > 1) {
 			desc->ptr[4].j_extent |= DESC_PTR_LNKTBL_JUMP;
 			to_talitos_ptr(&desc->ptr[4], edesc->dma_link_tbl);
@@ -1078,10 +1065,13 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	map_single_talitos_ptr(dev, &desc->ptr[6], ivsize, ctx->iv, 0,
 			       DMA_FROM_DEVICE);
 
-	ret = talitos_submit(dev, ctx->ch, desc, callback, areq);
+	req_ctx->req.desc = desc;
+	req_ctx->req.callback = callback;
+	req_ctx->req.context = areq;
+	ret = talitos_submit(dev, ctx->ch, &areq->base);
 	if (ret != -EINPROGRESS) {
 		ipsec_esp_unmap(dev, edesc, areq);
-		kfree(edesc);
+		kfree(edesc->link_tbl);
 	}
 	return ret;
 }
@@ -1107,22 +1097,22 @@ static int sg_count(struct scatterlist *sg_list, int nbytes, bool *chained)
 }
 
 /*
- * allocate and map the extended descriptor
+ * allocate and map variable part of the extended descriptor
  */
-static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
-						 struct scatterlist *assoc,
-						 struct scatterlist *src,
-						 struct scatterlist *dst,
-						 u8 *iv,
-						 unsigned int assoclen,
-						 unsigned int cryptlen,
-						 unsigned int authsize,
-						 unsigned int ivsize,
-						 int icv_stashing,
-						 u32 cryptoflags,
-						 bool encrypt)
-{
-	struct talitos_edesc *edesc;
+static int talitos_edesc_alloc(struct device *dev,
+			       struct talitos_edesc *edesc,
+			       struct scatterlist *assoc,
+			       struct scatterlist *src,
+			       struct scatterlist *dst,
+			       u8 *iv,
+			       unsigned int assoclen,
+			       unsigned int cryptlen,
+			       unsigned int authsize,
+			       unsigned int ivsize,
+			       int icv_stashing,
+			       u32 cryptoflags,
+			       bool encrypt)
+{
 	int assoc_nents = 0, src_nents, dst_nents, alloc_len, dma_len;
 	bool assoc_chained = false, src_chained = false, dst_chained = false;
 	dma_addr_t iv_dma = 0;
@@ -1131,7 +1121,7 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 
 	if (cryptlen + authsize > TALITOS_MAX_DATA_LEN) {
 		dev_err(dev, "length exceeds h/w max limit\n");
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
 	}
 
 	if (ivsize)
@@ -1167,22 +1157,35 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 	}
 
 	/*
-	 * allocate space for base edesc plus the link tables,
+	 * allocate space for the link tables
 	 * allowing for two separate entries for ICV and generated ICV (+ 2),
 	 * and the ICV data itself
 	 */
-	alloc_len = sizeof(struct talitos_edesc);
 	if (assoc_nents || src_nents || dst_nents) {
 		dma_len = (src_nents + dst_nents + 2 + assoc_nents) *
 			  sizeof(struct talitos_ptr) + authsize;
-		alloc_len += dma_len;
+		alloc_len = dma_len;
 	} else {
 		dma_len = 0;
-		alloc_len += icv_stashing ? authsize : 0;
+		alloc_len = icv_stashing ? authsize : 0;
 	}
 
-	edesc = kmalloc(alloc_len, GFP_DMA | flags);
-	if (!edesc) {
+	edesc->assoc_nents = assoc_nents;
+	edesc->src_nents = src_nents;
+	edesc->dst_nents = dst_nents;
+	edesc->assoc_chained = assoc_chained;
+	edesc->src_chained = src_chained;
+	edesc->dst_chained = dst_chained;
+	edesc->iv_dma = iv_dma;
+	edesc->dma_len = dma_len;
+
+	if (!alloc_len) {
+		edesc->link_tbl = NULL;
+		return 0;
+	}
+
+	edesc->link_tbl = kmalloc(alloc_len, GFP_DMA | flags);
+	if (!edesc->link_tbl) {
 		if (assoc_chained)
 			talitos_unmap_sg_chain(dev, assoc, DMA_TO_DEVICE);
 		else if (assoclen)
@@ -1194,53 +1197,47 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 			dma_unmap_single(dev, iv_dma, ivsize, DMA_TO_DEVICE);
 
 		dev_err(dev, "could not allocate edescriptor\n");
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 	}
 
-	edesc->assoc_nents = assoc_nents;
-	edesc->src_nents = src_nents;
-	edesc->dst_nents = dst_nents;
-	edesc->assoc_chained = assoc_chained;
-	edesc->src_chained = src_chained;
-	edesc->dst_chained = dst_chained;
-	edesc->iv_dma = iv_dma;
-	edesc->dma_len = dma_len;
 	if (dma_len)
-		edesc->dma_link_tbl = dma_map_single(dev, &edesc->link_tbl[0],
+		edesc->dma_link_tbl = dma_map_single(dev, edesc->link_tbl,
 						     edesc->dma_len,
 						     DMA_BIDIRECTIONAL);
 
-	return edesc;
+	return 0;
 }
 
-static struct talitos_edesc *aead_edesc_alloc(struct aead_request *areq, u8 *iv,
-					      int icv_stashing, bool encrypt)
+static int aead_edesc_alloc(struct aead_request *areq, u8 *iv, int icv_stashing,
+			    bool encrypt)
 {
 	struct crypto_aead *authenc = crypto_aead_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
 	unsigned int ivsize = crypto_aead_ivsize(authenc);
+	struct talitos_aead_req_ctx *req_ctx = aead_request_ctx(areq);
 
-	return talitos_edesc_alloc(ctx->dev, areq->assoc, areq->src, areq->dst,
-				   iv, areq->assoclen, areq->cryptlen,
-				   ctx->authsize, ivsize, icv_stashing,
-				   areq->base.flags, encrypt);
+	return talitos_edesc_alloc(ctx->dev, &req_ctx->edesc, areq->assoc,
+				   areq->src, areq->dst, iv, areq->assoclen,
+				   areq->cryptlen, ctx->authsize, ivsize,
+				   icv_stashing, areq->base.flags, encrypt);
 }
 
 static int aead_encrypt(struct aead_request *req)
 {
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
-	struct talitos_edesc *edesc;
+	struct talitos_aead_req_ctx *req_ctx = aead_request_ctx(req);
+	struct talitos_edesc *edesc = &req_ctx->edesc;
+	int ret;
 
-	/* allocate extended descriptor */
-	edesc = aead_edesc_alloc(req, req->iv, 0, true);
-	if (IS_ERR(edesc))
-		return PTR_ERR(edesc);
+	ret = aead_edesc_alloc(req, req->iv, 0, true);
+	if (ret)
+		return ret;
 
 	/* set encrypt */
 	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_MODE0_ENCRYPT;
 
-	return ipsec_esp(edesc, req, 0, ipsec_esp_encrypt_done);
+	return ipsec_esp(req, 0, ipsec_esp_encrypt_done);
 }
 
 static int aead_decrypt(struct aead_request *req)
@@ -1249,16 +1246,17 @@ static int aead_decrypt(struct aead_request *req)
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
 	unsigned int authsize = ctx->authsize;
 	struct talitos_private *priv = dev_get_drvdata(ctx->dev);
-	struct talitos_edesc *edesc;
+	struct talitos_aead_req_ctx *req_ctx = aead_request_ctx(req);
+	struct talitos_edesc *edesc = &req_ctx->edesc;
 	struct scatterlist *sg;
 	void *icvdata;
+	int ret;
 
 	req->cryptlen -= authsize;
 
-	/* allocate extended descriptor */
-	edesc = aead_edesc_alloc(req, req->iv, 1, false);
-	if (IS_ERR(edesc))
-		return PTR_ERR(edesc);
+	ret = aead_edesc_alloc(req, req->iv, 1, false);
+	if (ret)
+		return ret;
 
 	if ((priv->features & TALITOS_FTR_HW_AUTH_CHECK) &&
 	    ((!edesc->src_nents && !edesc->dst_nents) ||
@@ -1272,7 +1270,7 @@ static int aead_decrypt(struct aead_request *req)
 		/* reset integrity check result bits */
 		edesc->desc.hdr_lo = 0;
 
-		return ipsec_esp(edesc, req, 0, ipsec_esp_decrypt_hwauth_done);
+		return ipsec_esp(req, 0, ipsec_esp_decrypt_hwauth_done);
 	}
 
 	/* Have to check the ICV with software */
@@ -1284,14 +1282,14 @@ static int aead_decrypt(struct aead_request *req)
 					   edesc->dst_nents + 2 +
 					   edesc->assoc_nents];
 	else
-		icvdata = &edesc->link_tbl[0];
+		icvdata = edesc->link_tbl;
 
 	sg = sg_last(req->src, edesc->src_nents ? : 1);
 
 	memcpy(icvdata, (char *)sg_virt(sg) + sg->length - ctx->authsize,
 	       ctx->authsize);
 
-	return ipsec_esp(edesc, req, 0, ipsec_esp_decrypt_swauth_done);
+	return ipsec_esp(req, 0, ipsec_esp_decrypt_swauth_done);
 }
 
 static int aead_givencrypt(struct aead_givcrypt_request *req)
@@ -1299,12 +1297,13 @@ static int aead_givencrypt(struct aead_givcrypt_request *req)
 	struct aead_request *areq = &req->areq;
 	struct crypto_aead *authenc = crypto_aead_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
-	struct talitos_edesc *edesc;
+	struct talitos_aead_req_ctx *req_ctx = aead_request_ctx(areq);
+	struct talitos_edesc *edesc = &req_ctx->edesc;
+	int ret;
 
-	/* allocate extended descriptor */
-	edesc = aead_edesc_alloc(areq, req->giv, 0, true);
-	if (IS_ERR(edesc))
-		return PTR_ERR(edesc);
+	ret = aead_edesc_alloc(areq, req->giv, 0, true);
+	if (ret)
+		return ret;
 
 	/* set encrypt */
 	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_MODE0_ENCRYPT;
@@ -1313,7 +1312,7 @@ static int aead_givencrypt(struct aead_givcrypt_request *req)
 	/* avoid consecutive packets going out with same IV */
 	*(__be64 *)req->giv ^= cpu_to_be64(req->seq);
 
-	return ipsec_esp(edesc, areq, req->seq, ipsec_esp_encrypt_done);
+	return ipsec_esp(areq, req->seq, ipsec_esp_encrypt_done);
 }
 
 static int ablkcipher_setkey(struct crypto_ablkcipher *cipher,
@@ -1342,31 +1341,30 @@ static void common_nonsnoop_unmap(struct device *dev,
 				 DMA_BIDIRECTIONAL);
 }
 
-static void ablkcipher_done(struct device *dev,
-			    struct talitos_desc *desc, void *context,
-			    int err)
+static void ablkcipher_done(struct device *dev, void *context, int err)
 {
 	struct ablkcipher_request *areq = context;
-	struct talitos_edesc *edesc;
-
-	edesc = container_of(desc, struct talitos_edesc, desc);
+	struct talitos_ablkcipher_req_ctx *req_ctx =
+		ablkcipher_request_ctx(areq);
+	struct talitos_edesc *edesc = &req_ctx->edesc;
 
 	common_nonsnoop_unmap(dev, edesc, areq);
 
-	kfree(edesc);
+	kfree(edesc->link_tbl);
 
 	areq->base.complete(&areq->base, err);
 }
 
-static int common_nonsnoop(struct talitos_edesc *edesc,
-			   struct ablkcipher_request *areq,
-			   void (*callback) (struct device *dev,
-					     struct talitos_desc *desc,
-					     void *context, int error))
+static int common_nonsnoop(struct ablkcipher_request *areq,
+			   void (*callback)(struct device *dev,
+					    void *context, int error))
 {
 	struct crypto_ablkcipher *cipher = crypto_ablkcipher_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_ablkcipher_ctx(cipher);
 	struct device *dev = ctx->dev;
+	struct talitos_ablkcipher_req_ctx *req_ctx =
+		ablkcipher_request_ctx(areq);
+	struct talitos_edesc *edesc = &req_ctx->edesc;
 	struct talitos_desc *desc = &edesc->desc;
 	unsigned int cryptlen = areq->nbytes;
 	unsigned int ivsize = crypto_ablkcipher_ivsize(cipher);
@@ -1401,7 +1399,7 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 		to_talitos_ptr(&desc->ptr[3], sg_dma_address(areq->src));
 	} else {
 		sg_count = sg_to_link_tbl(areq->src, sg_count, cryptlen,
-					  &edesc->link_tbl[0]);
+					  edesc->link_tbl);
 		if (sg_count > 1) {
 			to_talitos_ptr(&desc->ptr[3], edesc->dma_link_tbl);
 			desc->ptr[3].j_extent |= DESC_PTR_LNKTBL_JUMP;
@@ -1449,57 +1447,64 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 	to_talitos_ptr(&desc->ptr[6], 0);
 	desc->ptr[6].j_extent = 0;
 
-	ret = talitos_submit(dev, ctx->ch, desc, callback, areq);
+	req_ctx->req.desc = desc;
+	req_ctx->req.callback = callback;
+	req_ctx->req.context = areq;
+	ret = talitos_submit(dev, ctx->ch, &areq->base);
 	if (ret != -EINPROGRESS) {
 		common_nonsnoop_unmap(dev, edesc, areq);
-		kfree(edesc);
+		kfree(edesc->link_tbl);
 	}
 	return ret;
 }
 
-static struct talitos_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request *
-						    areq, bool encrypt)
+static int ablkcipher_edesc_alloc(struct ablkcipher_request *areq, bool encrypt)
 {
 	struct crypto_ablkcipher *cipher = crypto_ablkcipher_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_ablkcipher_ctx(cipher);
 	unsigned int ivsize = crypto_ablkcipher_ivsize(cipher);
+	struct talitos_ablkcipher_req_ctx *req_ctx =
+		ablkcipher_request_ctx(areq);
 
-	return talitos_edesc_alloc(ctx->dev, NULL, areq->src, areq->dst,
-				   areq->info, 0, areq->nbytes, 0, ivsize, 0,
-				   areq->base.flags, encrypt);
+	return talitos_edesc_alloc(ctx->dev, &req_ctx->edesc, NULL, areq->src,
+				   areq->dst, areq->info, 0, areq->nbytes, 0,
+				   ivsize, 0, areq->base.flags, encrypt);
 }
 
 static int ablkcipher_encrypt(struct ablkcipher_request *areq)
 {
 	struct crypto_ablkcipher *cipher = crypto_ablkcipher_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_ablkcipher_ctx(cipher);
-	struct talitos_edesc *edesc;
+	struct talitos_ablkcipher_req_ctx *req_ctx =
+		ablkcipher_request_ctx(areq);
+	int ret;
 
-	/* allocate extended descriptor */
-	edesc = ablkcipher_edesc_alloc(areq, true);
-	if (IS_ERR(edesc))
-		return PTR_ERR(edesc);
+	ret = ablkcipher_edesc_alloc(areq, true);
+	if (ret)
+		return ret;
 
 	/* set encrypt */
-	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_MODE0_ENCRYPT;
+	req_ctx->edesc.desc.hdr = ctx->desc_hdr_template |
+				  DESC_HDR_MODE0_ENCRYPT;
 
-	return common_nonsnoop(edesc, areq, ablkcipher_done);
+	return common_nonsnoop(areq, ablkcipher_done);
 }
 
 static int ablkcipher_decrypt(struct ablkcipher_request *areq)
 {
 	struct crypto_ablkcipher *cipher = crypto_ablkcipher_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_ablkcipher_ctx(cipher);
-	struct talitos_edesc *edesc;
+	struct talitos_ablkcipher_req_ctx *req_ctx =
+		ablkcipher_request_ctx(areq);
+	int ret;
 
-	/* allocate extended descriptor */
-	edesc = ablkcipher_edesc_alloc(areq, false);
-	if (IS_ERR(edesc))
-		return PTR_ERR(edesc);
+	ret = ablkcipher_edesc_alloc(areq, false);
+	if (ret)
+		return ret;
 
-	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_DIR_INBOUND;
+	req_ctx->edesc.desc.hdr = ctx->desc_hdr_template | DESC_HDR_DIR_INBOUND;
 
-	return common_nonsnoop(edesc, areq, ablkcipher_done);
+	return common_nonsnoop(areq, ablkcipher_done);
 }
 
 static void common_nonsnoop_hash_unmap(struct device *dev,
@@ -1527,14 +1532,11 @@ static void common_nonsnoop_hash_unmap(struct device *dev,
 
 }
 
-static void ahash_done(struct device *dev,
-		       struct talitos_desc *desc, void *context,
-		       int err)
+static void ahash_done(struct device *dev, void *context, int err)
 {
 	struct ahash_request *areq = context;
-	struct talitos_edesc *edesc =
-		 container_of(desc, struct talitos_edesc, desc);
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+	struct talitos_edesc *edesc = &req_ctx->edesc;
 
 	if (!req_ctx->last && req_ctx->to_hash_later) {
 		/* Position any partial block for next update/final/finup */
@@ -1543,21 +1545,20 @@ static void ahash_done(struct device *dev,
 	}
 	common_nonsnoop_hash_unmap(dev, edesc, areq);
 
-	kfree(edesc);
+	kfree(edesc->link_tbl);
 
 	areq->base.complete(&areq->base, err);
 }
 
-static int common_nonsnoop_hash(struct talitos_edesc *edesc,
-				struct ahash_request *areq, unsigned int length,
-				void (*callback) (struct device *dev,
-						  struct talitos_desc *desc,
-						  void *context, int error))
+static int common_nonsnoop_hash(struct ahash_request *areq, unsigned int length,
+				void (*callback)(struct device *dev,
+						 void *context, int error))
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 	struct device *dev = ctx->dev;
+	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+	struct talitos_edesc *edesc = &req_ctx->edesc;
 	struct talitos_desc *desc = &edesc->desc;
 	int sg_count, ret;
 
@@ -1598,7 +1599,7 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 		to_talitos_ptr(&desc->ptr[3], sg_dma_address(req_ctx->psrc));
 	} else {
 		sg_count = sg_to_link_tbl(req_ctx->psrc, sg_count, length,
-					  &edesc->link_tbl[0]);
+					  edesc->link_tbl);
 		if (sg_count > 1) {
 			desc->ptr[3].j_extent |= DESC_PTR_LNKTBL_JUMP;
 			to_talitos_ptr(&desc->ptr[3], edesc->dma_link_tbl);
@@ -1629,23 +1630,26 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 	/* last DWORD empty */
 	desc->ptr[6] = zero_entry;
 
-	ret = talitos_submit(dev, ctx->ch, desc, callback, areq);
+	req_ctx->req.desc = desc;
+	req_ctx->req.callback = callback;
+	req_ctx->req.context = areq;
+	ret = talitos_submit(dev, ctx->ch, &areq->base);
 	if (ret != -EINPROGRESS) {
 		common_nonsnoop_hash_unmap(dev, edesc, areq);
-		kfree(edesc);
+		kfree(edesc->link_tbl);
 	}
 	return ret;
 }
 
-static struct talitos_edesc *ahash_edesc_alloc(struct ahash_request *areq,
-					       unsigned int nbytes)
+static int ahash_edesc_alloc(struct ahash_request *areq, unsigned int nbytes)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 
-	return talitos_edesc_alloc(ctx->dev, NULL, req_ctx->psrc, NULL, NULL, 0,
-				   nbytes, 0, 0, 0, areq->base.flags, false);
+	return talitos_edesc_alloc(ctx->dev, &req_ctx->edesc, NULL,
+				   req_ctx->psrc, NULL, NULL, 0, nbytes, 0, 0,
+				   0, areq->base.flags, false);
 }
 
 static int ahash_init(struct ahash_request *areq)
@@ -1697,13 +1701,14 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
-	struct talitos_edesc *edesc;
+	struct talitos_edesc *edesc = &req_ctx->edesc;
 	unsigned int blocksize =
 			crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
 	unsigned int nbytes_to_hash;
 	unsigned int to_hash_later;
 	unsigned int nsg;
 	bool chained;
+	int ret;
 
 	if (!req_ctx->last && (nbytes + req_ctx->nbuf <= blocksize)) {
 		/* Buffer up to one whole block */
@@ -1749,10 +1754,9 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 	}
 	req_ctx->to_hash_later = to_hash_later;
 
-	/* Allocate extended descriptor */
-	edesc = ahash_edesc_alloc(areq, nbytes_to_hash);
-	if (IS_ERR(edesc))
-		return PTR_ERR(edesc);
+	ret = ahash_edesc_alloc(areq, nbytes_to_hash);
+	if (ret)
+		return ret;
 
 	edesc->desc.hdr = ctx->desc_hdr_template;
 
@@ -1772,8 +1776,7 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 	if (ctx->keylen && (req_ctx->first || req_ctx->last))
 		edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_HMAC;
 
-	return common_nonsnoop_hash(edesc, areq, nbytes_to_hash,
-				    ahash_done);
+	return common_nonsnoop_hash(areq, nbytes_to_hash, ahash_done);
 }
 
 static int ahash_update(struct ahash_request *areq)
@@ -2404,15 +2407,39 @@ static int talitos_cra_init(struct crypto_tfm *tfm)
 	/* select done notification */
 	ctx->desc_hdr_template |= DESC_HDR_DONE_NOTIFY;
 
+	/*
+	 * Need GFP_DMA for:
+	 * -HW descriptor (talitos_*_req_ctx->edesc.desc) and possibly
+	 * -HW S/G table  (talitos_*_req_ctx->edesc.link_tbl)
+	 */
+	crypto_tfm_set_flags(tfm, CRYPTO_TFM_REQ_DMA);
+
+	return 0;
+}
+
+static int talitos_cra_init_ablkcipher(struct crypto_tfm *tfm)
+{
+	struct ablkcipher_tfm *ablkcipher_tfm =
+		crypto_ablkcipher_crt(__crypto_ablkcipher_cast(tfm));
+
+	talitos_cra_init(tfm);
+
+	/* talitos request context - fixed part */
+	ablkcipher_tfm->reqsize = sizeof(struct talitos_ablkcipher_req_ctx);
+
 	return 0;
 }
 
 static int talitos_cra_init_aead(struct crypto_tfm *tfm)
 {
 	struct talitos_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct aead_tfm *aead_tfm = crypto_aead_crt(__crypto_aead_cast(tfm));
 
 	talitos_cra_init(tfm);
 
+	/* talitos request context - fixed part */
+	aead_tfm->reqsize = sizeof(struct talitos_aead_req_ctx);
+
 	/* random first IV */
 	get_random_bytes(ctx->iv, TALITOS_MAX_IV_LENGTH);
 
@@ -2426,6 +2453,8 @@ static int talitos_cra_init_ahash(struct crypto_tfm *tfm)
 	talitos_cra_init(tfm);
 
 	ctx->keylen = 0;
+
+	/* talitos request context - fixed part */
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
 				 sizeof(struct talitos_ahash_req_ctx));
 
@@ -2515,7 +2544,7 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 	switch (t_alg->algt.type) {
 	case CRYPTO_ALG_TYPE_ABLKCIPHER:
 		alg = &t_alg->algt.alg.crypto;
-		alg->cra_init = talitos_cra_init;
+		alg->cra_init = talitos_cra_init_ablkcipher;
 		alg->cra_type = &crypto_ablkcipher_type;
 		alg->cra_ablkcipher.setkey = ablkcipher_setkey;
 		alg->cra_ablkcipher.encrypt = ablkcipher_encrypt;
@@ -2714,7 +2743,7 @@ static int talitos_probe(struct platform_device *ofdev)
 		spin_lock_init(&priv->chan[i].head_lock);
 		spin_lock_init(&priv->chan[i].tail_lock);
 
-		priv->chan[i].fifo = kzalloc(sizeof(struct talitos_request) *
+		priv->chan[i].fifo = kzalloc(sizeof(struct talitos_request *) *
 					     priv->fifo_len, GFP_KERNEL);
 		if (!priv->chan[i].fifo) {
 			dev_err(dev, "failed to allocate request fifo %d\n", i);
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 61a14054aa39..ebae5c3ef0fb 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -57,6 +57,38 @@ struct talitos_desc {
 	struct talitos_ptr ptr[7];      /* ptr/len pair array */
 };
 
+/*
+ * talitos_edesc - s/w-extended descriptor
+ * @assoc_nents: number of segments in associated data scatterlist
+ * @src_nents: number of segments in input scatterlist
+ * @dst_nents: number of segments in output scatterlist
+ * @assoc_chained: whether assoc is chained or not
+ * @src_chained: whether src is chained or not
+ * @dst_chained: whether dst is chained or not
+ * @iv_dma: dma address of iv for checking continuity and link table
+ * @dma_len: length of dma mapped link_tbl space
+ * @dma_link_tbl: bus physical address of link_tbl
+ * @desc: h/w descriptor
+ * @link_tbl: input and output h/w link tables (if {src,dst}_nents > 1)
+ *
+ * if decrypting (with authcheck), or either one of src_nents or dst_nents
+ * is greater than 1, an integrity check value is concatenated to the end
+ * of link_tbl data
+ */
+struct talitos_edesc {
+	int assoc_nents;
+	int src_nents;
+	int dst_nents;
+	bool assoc_chained;
+	bool src_chained;
+	bool dst_chained;
+	dma_addr_t iv_dma;
+	int dma_len;
+	dma_addr_t dma_link_tbl;
+	struct talitos_desc desc;
+	struct talitos_ptr *link_tbl;
+};
+
 /**
  * talitos_request - descriptor submission request
  * @desc: descriptor pointer (kernel virtual)
@@ -67,8 +99,7 @@ struct talitos_desc {
 struct talitos_request {
 	struct talitos_desc *desc;
 	dma_addr_t dma_desc;
-	void (*callback) (struct device *dev, struct talitos_desc *desc,
-			  void *context, int error);
+	void (*callback)(struct device *dev, void *context, int error);
 	void *context;
 };
 
@@ -77,7 +108,7 @@ struct talitos_channel {
 	void __iomem *reg;
 
 	/* request fifo */
-	struct talitos_request *fifo;
+	struct talitos_request **fifo;
 
 	/* number of requests pending in channel h/w fifo */
 	atomic_t submit_count ____cacheline_aligned;
@@ -133,11 +164,18 @@ struct talitos_private {
 	struct hwrng rng;
 };
 
-extern int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
-			  void (*callback)(struct device *dev,
-					   struct talitos_desc *desc,
-					   void *context, int error),
-			  void *context);
+/**
+ * talitos_submit - submits a descriptor to the device for processing
+ * @dev:	the SEC device to be used
+ * @ch:		the SEC device channel to be used
+ * @areq:	crypto request embedding talitos request
+ *
+ * desc must contain valid dma-mapped (bus physical) address pointers.
+ * callback from talitos request must check err and feedback in descriptor
+ * header for device processing status.
+ */
+int talitos_submit(struct device *dev, int ch,
+		   struct crypto_async_request *areq);
 
 /* .features flag */
 #define TALITOS_FTR_SRC_LINK_TBL_LEN_INCLUDES_EXTENT 0x00000001
-- 
1.8.3.1
