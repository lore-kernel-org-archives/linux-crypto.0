From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 5/8] crypto: caam - shorter names
Date: Fri, 8 Jul 2011 17:57:26 -0500
Message-ID: <1310165849-22177-5-git-send-email-kim.phillips@freescale.com>
References: <1310165849-22177-1-git-send-email-kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Yuan Kang <Yuan.Kang@freescale.com>,
	Kim Phillips <kim.phillips@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:45902
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752611Ab1GHW6L (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Jul 2011 18:58:11 -0400
Received: from mail186-va3 (localhost.localdomain [127.0.0.1])	by
 mail186-va3-R.bigfish.com (Postfix) with ESMTP id 793EE6E80C7	for
 <linux-crypto@vger.kernel.org>; Fri,  8 Jul 2011 22:58:10 +0000 (UTC)
Received: from VA3EHSMHS007.bigfish.com (unknown [10.7.14.245])	by
 mail186-va3.bigfish.com (Postfix) with ESMTP id 63D6417D8051	for
 <linux-crypto@vger.kernel.org>; Fri,  8 Jul 2011 22:58:09 +0000 (UTC)
In-Reply-To: <1310165849-22177-1-git-send-email-kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Yuan Kang <Yuan.Kang@freescale.com>

"aead_authenc" and "ipsec_esp" changed to "aead,"
except for function "ipsec_esp," which is changed
to "init_aead_job."

Variable name of aead_request structures changed
to "req" and name of aead_givcrypt_request structure
changed to "areq"

Signed-off-by: Yuan Kang <Yuan.Kang@freescale.com>
Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/caamalg.c |  274 ++++++++++++++++++++--------------------
 1 files changed, 137 insertions(+), 137 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 676d957..4786a20 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -94,7 +94,7 @@ struct caam_ctx {
 	unsigned int authsize;
 };
 
-static int aead_authenc_setauthsize(struct crypto_aead *authenc,
+static int aead_setauthsize(struct crypto_aead *authenc,
 				    unsigned int authsize)
 {
 	struct caam_ctx *ctx = crypto_aead_ctx(authenc);
@@ -286,7 +286,7 @@ static int build_sh_desc_ipsec(struct caam_ctx *ctx)
 	return 0;
 }
 
-static int aead_authenc_setkey(struct crypto_aead *aead,
+static int aead_setkey(struct crypto_aead *aead,
 			       const u8 *key, unsigned int keylen)
 {
 	/* Sizes for MDHA pads (*not* keys): MD5, SHA1, 224, 256, 384, 512 */
@@ -379,7 +379,7 @@ struct link_tbl_entry {
 };
 
 /*
- * ipsec_esp_edesc - s/w-extended ipsec_esp descriptor
+ * aead_edesc - s/w-extended ipsec_esp descriptor
  * @src_nents: number of segments in input scatterlist
  * @dst_nents: number of segments in output scatterlist
  * @assoc_nents: number of segments in associated data (SPI+Seq) scatterlist
@@ -388,7 +388,7 @@ struct link_tbl_entry {
  * @link_tbl_dma: bus physical mapped address of h/w link table
  * @hw_desc: the h/w job descriptor followed by any referenced link tables
  */
-struct ipsec_esp_edesc {
+struct aead_edesc {
 	int assoc_nents;
 	int src_nents;
 	int dst_nents;
@@ -398,19 +398,19 @@ struct ipsec_esp_edesc {
 	u32 hw_desc[0];
 };
 
-static void ipsec_esp_unmap(struct device *dev,
-			    struct ipsec_esp_edesc *edesc,
-			    struct aead_request *areq)
+static void aead_unmap(struct device *dev,
+			    struct aead_edesc *edesc,
+			    struct aead_request *req)
 {
-	dma_unmap_sg(dev, areq->assoc, edesc->assoc_nents, DMA_TO_DEVICE);
+	dma_unmap_sg(dev, req->assoc, edesc->assoc_nents, DMA_TO_DEVICE);
 
-	if (unlikely(areq->dst != areq->src)) {
-		dma_unmap_sg(dev, areq->src, edesc->src_nents,
+	if (unlikely(req->dst != req->src)) {
+		dma_unmap_sg(dev, req->src, edesc->src_nents,
 			     DMA_TO_DEVICE);
-		dma_unmap_sg(dev, areq->dst, edesc->dst_nents,
+		dma_unmap_sg(dev, req->dst, edesc->dst_nents,
 			     DMA_FROM_DEVICE);
 	} else {
-		dma_unmap_sg(dev, areq->src, edesc->src_nents,
+		dma_unmap_sg(dev, req->src, edesc->src_nents,
 			     DMA_BIDIRECTIONAL);
 	}
 
@@ -423,20 +423,20 @@ static void ipsec_esp_unmap(struct device *dev,
 /*
  * ipsec_esp descriptor callbacks
  */
-static void ipsec_esp_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
+static void aead_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 				   void *context)
 {
-	struct aead_request *areq = context;
-	struct ipsec_esp_edesc *edesc;
+	struct aead_request *req = context;
+	struct aead_edesc *edesc;
 #ifdef DEBUG
-	struct crypto_aead *aead = crypto_aead_reqtfm(areq);
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	int ivsize = crypto_aead_ivsize(aead);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 
 	dev_err(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
 #endif
-	edesc = (struct ipsec_esp_edesc *)((char *)desc -
-		 offsetof(struct ipsec_esp_edesc, hw_desc));
+	edesc = (struct aead_edesc *)((char *)desc -
+		 offsetof(struct aead_edesc, hw_desc));
 
 	if (err) {
 		char tmp[CAAM_ERROR_STR_MAX];
@@ -444,39 +444,39 @@ static void ipsec_esp_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 		dev_err(jrdev, "%08x: %s\n", err, caam_jr_strstatus(tmp, err));
 	}
 
-	ipsec_esp_unmap(jrdev, edesc, areq);
+	aead_unmap(jrdev, edesc, req);
 
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "assoc  @"xstr(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(areq->assoc),
-		       areq->assoclen , 1);
+		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->assoc),
+		       req->assoclen , 1);
 	print_hex_dump(KERN_ERR, "dstiv  @"xstr(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(areq->src) - ivsize,
+		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src) - ivsize,
 		       edesc->src_nents ? 100 : ivsize, 1);
 	print_hex_dump(KERN_ERR, "dst    @"xstr(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(areq->src),
-		       edesc->src_nents ? 100 : areq->cryptlen +
+		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),
+		       edesc->src_nents ? 100 : req->cryptlen +
 		       ctx->authsize + 4, 1);
 #endif
 
 	kfree(edesc);
 
-	aead_request_complete(areq, err);
+	aead_request_complete(req, err);
 }
 
-static void ipsec_esp_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
+static void aead_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 				   void *context)
 {
-	struct aead_request *areq = context;
-	struct ipsec_esp_edesc *edesc;
+	struct aead_request *req = context;
+	struct aead_edesc *edesc;
 #ifdef DEBUG
-	struct crypto_aead *aead = crypto_aead_reqtfm(areq);
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 
 	dev_err(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
 #endif
-	edesc = (struct ipsec_esp_edesc *)((char *)desc -
-		 offsetof(struct ipsec_esp_edesc, hw_desc));
+	edesc = (struct aead_edesc *)((char *)desc -
+		 offsetof(struct aead_edesc, hw_desc));
 
 	if (err) {
 		char tmp[CAAM_ERROR_STR_MAX];
@@ -484,7 +484,7 @@ static void ipsec_esp_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 		dev_err(jrdev, "%08x: %s\n", err, caam_jr_strstatus(tmp, err));
 	}
 
-	ipsec_esp_unmap(jrdev, edesc, areq);
+	aead_unmap(jrdev, edesc, req);
 
 	/*
 	 * verify hw auth check passed else return -EBADMSG
@@ -495,12 +495,12 @@ static void ipsec_esp_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "iphdrout@"xstr(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4,
-		       ((char *)sg_virt(areq->assoc) - sizeof(struct iphdr)),
-		       sizeof(struct iphdr) + areq->assoclen +
-		       ((areq->cryptlen > 1500) ? 1500 : areq->cryptlen) +
+		       ((char *)sg_virt(req->assoc) - sizeof(struct iphdr)),
+		       sizeof(struct iphdr) + req->assoclen +
+		       ((req->cryptlen > 1500) ? 1500 : req->cryptlen) +
 		       ctx->authsize + 36, 1);
 	if (!err && edesc->link_tbl_bytes) {
-		struct scatterlist *sg = sg_last(areq->src, edesc->src_nents);
+		struct scatterlist *sg = sg_last(req->src, edesc->src_nents);
 		print_hex_dump(KERN_ERR, "sglastout@"xstr(__LINE__)": ",
 			       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(sg),
 			sg->length + ctx->authsize + 16, 1);
@@ -508,7 +508,7 @@ static void ipsec_esp_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 #endif
 	kfree(edesc);
 
-	aead_request_complete(areq, err);
+	aead_request_complete(req, err);
 }
 
 /*
@@ -537,12 +537,12 @@ static void sg_to_link_tbl(struct scatterlist *sg, int sg_count,
 /*
  * fill in and submit ipsec_esp job descriptor
  */
-static int ipsec_esp(struct ipsec_esp_edesc *edesc, struct aead_request *areq,
+static int init_aead_job(struct aead_edesc *edesc, struct aead_request *req,
 		     u32 encrypt,
 		     void (*callback) (struct device *dev, u32 *desc,
 				       u32 err, void *context))
 {
-	struct crypto_aead *aead = crypto_aead_reqtfm(areq);
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
 	u32 *desc = edesc->hw_desc, options;
@@ -554,27 +554,27 @@ static int ipsec_esp(struct ipsec_esp_edesc *edesc, struct aead_request *areq,
 	u32 *sh_desc = ctx->sh_desc;
 
 	debug("assoclen %d cryptlen %d authsize %d\n",
-	      areq->assoclen, areq->cryptlen, authsize);
+	      req->assoclen, req->cryptlen, authsize);
 	print_hex_dump(KERN_ERR, "assoc  @"xstr(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(areq->assoc),
-		       areq->assoclen , 1);
+		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->assoc),
+		       req->assoclen , 1);
 	print_hex_dump(KERN_ERR, "presciv@"xstr(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(areq->src) - ivsize,
+		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src) - ivsize,
 		       edesc->src_nents ? 100 : ivsize, 1);
 	print_hex_dump(KERN_ERR, "src    @"xstr(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(areq->src),
-			edesc->src_nents ? 100 : areq->cryptlen + authsize, 1);
+		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),
+			edesc->src_nents ? 100 : req->cryptlen + authsize, 1);
 	print_hex_dump(KERN_ERR, "shrdesc@"xstr(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, sh_desc,
 		       desc_bytes(sh_desc), 1);
 #endif
-	assoc_sg_count = dma_map_sg(jrdev, areq->assoc, edesc->assoc_nents ?: 1,
+	assoc_sg_count = dma_map_sg(jrdev, req->assoc, edesc->assoc_nents ?: 1,
 				    DMA_TO_DEVICE);
-	if (areq->src == areq->dst)
-		sg_count = dma_map_sg(jrdev, areq->src, edesc->src_nents ? : 1,
+	if (req->src == req->dst)
+		sg_count = dma_map_sg(jrdev, req->src, edesc->src_nents ? : 1,
 				      DMA_BIDIRECTIONAL);
 	else
-		sg_count = dma_map_sg(jrdev, areq->src, edesc->src_nents ? : 1,
+		sg_count = dma_map_sg(jrdev, req->src, edesc->src_nents ? : 1,
 				      DMA_TO_DEVICE);
 
 	/* start auth operation */
@@ -584,14 +584,14 @@ static int ipsec_esp(struct ipsec_esp_edesc *edesc, struct aead_request *areq,
 	/* Load FIFO with data for Class 2 CHA */
 	options = FIFOLD_CLASS_CLASS2 | FIFOLD_TYPE_MSG;
 	if (!edesc->assoc_nents) {
-		ptr = sg_dma_address(areq->assoc);
+		ptr = sg_dma_address(req->assoc);
 	} else {
-		sg_to_link_tbl(areq->assoc, edesc->assoc_nents,
+		sg_to_link_tbl(req->assoc, edesc->assoc_nents,
 			       edesc->link_tbl, 0);
 		ptr = edesc->link_tbl_dma;
 		options |= LDST_SGF;
 	}
-	append_fifo_load(desc, ptr, areq->assoclen, options);
+	append_fifo_load(desc, ptr, req->assoclen, options);
 
 	/* copy iv from cipher/class1 input context to class2 infifo */
 	append_move(desc, MOVE_SRC_CLASS1CTX | MOVE_DEST_CLASS2INFIFO | ivsize);
@@ -621,31 +621,31 @@ static int ipsec_esp(struct ipsec_esp_edesc *edesc, struct aead_request *areq,
 	/* load payload & instruct to class2 to snoop class 1 if encrypting */
 	options = 0;
 	if (!edesc->src_nents) {
-		src_dma = sg_dma_address(areq->src);
+		src_dma = sg_dma_address(req->src);
 	} else {
-		sg_to_link_tbl(areq->src, edesc->src_nents, edesc->link_tbl +
+		sg_to_link_tbl(req->src, edesc->src_nents, edesc->link_tbl +
 			       edesc->assoc_nents, 0);
 		src_dma = edesc->link_tbl_dma + edesc->assoc_nents *
 			  sizeof(struct link_tbl_entry);
 		options |= LDST_SGF;
 	}
-	append_seq_in_ptr(desc, src_dma, areq->cryptlen + authsize, options);
-	append_seq_fifo_load(desc, areq->cryptlen, FIFOLD_CLASS_BOTH |
+	append_seq_in_ptr(desc, src_dma, req->cryptlen + authsize, options);
+	append_seq_fifo_load(desc, req->cryptlen, FIFOLD_CLASS_BOTH |
 			     FIFOLD_TYPE_LASTBOTH |
 			     (encrypt ? FIFOLD_TYPE_MSG1OUT2
 				      : FIFOLD_TYPE_MSG));
 
 	/* specify destination */
-	if (areq->src == areq->dst) {
+	if (req->src == req->dst) {
 		dst_dma = src_dma;
 	} else {
-		sg_count = dma_map_sg(jrdev, areq->dst, edesc->dst_nents ? : 1,
+		sg_count = dma_map_sg(jrdev, req->dst, edesc->dst_nents ? : 1,
 				      DMA_FROM_DEVICE);
 		if (!edesc->dst_nents) {
-			dst_dma = sg_dma_address(areq->dst);
+			dst_dma = sg_dma_address(req->dst);
 			options = 0;
 		} else {
-			sg_to_link_tbl(areq->dst, edesc->dst_nents,
+			sg_to_link_tbl(req->dst, edesc->dst_nents,
 				       edesc->link_tbl + edesc->assoc_nents +
 				       edesc->src_nents, 0);
 			dst_dma = edesc->link_tbl_dma + (edesc->assoc_nents +
@@ -654,8 +654,8 @@ static int ipsec_esp(struct ipsec_esp_edesc *edesc, struct aead_request *areq,
 			options = LDST_SGF;
 		}
 	}
-	append_seq_out_ptr(desc, dst_dma, areq->cryptlen + authsize, options);
-	append_seq_fifo_store(desc, areq->cryptlen, FIFOST_TYPE_MESSAGE_DATA);
+	append_seq_out_ptr(desc, dst_dma, req->cryptlen + authsize, options);
+	append_seq_fifo_store(desc, req->cryptlen, FIFOST_TYPE_MESSAGE_DATA);
 
 	/* ICV */
 	if (encrypt)
@@ -674,11 +674,11 @@ static int ipsec_esp(struct ipsec_esp_edesc *edesc, struct aead_request *areq,
 			edesc->link_tbl_bytes, 1);
 #endif
 
-	ret = caam_jr_enqueue(jrdev, desc, callback, areq);
+	ret = caam_jr_enqueue(jrdev, desc, callback, req);
 	if (!ret)
 		ret = -EINPROGRESS;
 	else {
-		ipsec_esp_unmap(jrdev, edesc, areq);
+		aead_unmap(jrdev, edesc, req);
 		kfree(edesc);
 	}
 
@@ -708,30 +708,30 @@ static int sg_count(struct scatterlist *sg_list, int nbytes, int *chained)
 /*
  * allocate and map the ipsec_esp extended descriptor
  */
-static struct ipsec_esp_edesc *ipsec_esp_edesc_alloc(struct aead_request *areq,
+static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 						     int desc_bytes)
 {
-	struct crypto_aead *aead = crypto_aead_reqtfm(areq);
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
-	gfp_t flags = areq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
+	gfp_t flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
 		      GFP_ATOMIC;
 	int assoc_nents, src_nents, dst_nents = 0, chained, link_tbl_bytes;
-	struct ipsec_esp_edesc *edesc;
+	struct aead_edesc *edesc;
 
-	assoc_nents = sg_count(areq->assoc, areq->assoclen, &chained);
+	assoc_nents = sg_count(req->assoc, req->assoclen, &chained);
 	BUG_ON(chained);
 	if (likely(assoc_nents == 1))
 		assoc_nents = 0;
 
-	src_nents = sg_count(areq->src, areq->cryptlen + ctx->authsize,
+	src_nents = sg_count(req->src, req->cryptlen + ctx->authsize,
 			     &chained);
 	BUG_ON(chained);
 	if (src_nents == 1)
 		src_nents = 0;
 
-	if (unlikely(areq->dst != areq->src)) {
-		dst_nents = sg_count(areq->dst, areq->cryptlen + ctx->authsize,
+	if (unlikely(req->dst != req->src)) {
+		dst_nents = sg_count(req->dst, req->cryptlen + ctx->authsize,
 				     &chained);
 		BUG_ON(chained);
 		if (dst_nents == 1)
@@ -743,7 +743,7 @@ static struct ipsec_esp_edesc *ipsec_esp_edesc_alloc(struct aead_request *areq,
 	debug("link_tbl_bytes %d\n", link_tbl_bytes);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = kmalloc(sizeof(struct ipsec_esp_edesc) + desc_bytes +
+	edesc = kmalloc(sizeof(struct aead_edesc) + desc_bytes +
 			link_tbl_bytes, GFP_DMA | flags);
 	if (!edesc) {
 		dev_err(jrdev, "could not allocate extended descriptor\n");
@@ -753,7 +753,7 @@ static struct ipsec_esp_edesc *ipsec_esp_edesc_alloc(struct aead_request *areq,
 	edesc->assoc_nents = assoc_nents;
 	edesc->src_nents = src_nents;
 	edesc->dst_nents = dst_nents;
-	edesc->link_tbl = (void *)edesc + sizeof(struct ipsec_esp_edesc) +
+	edesc->link_tbl = (void *)edesc + sizeof(struct aead_edesc) +
 			  desc_bytes;
 	edesc->link_tbl_dma = dma_map_single(jrdev, edesc->link_tbl,
 					     link_tbl_bytes, DMA_TO_DEVICE);
@@ -762,10 +762,10 @@ static struct ipsec_esp_edesc *ipsec_esp_edesc_alloc(struct aead_request *areq,
 	return edesc;
 }
 
-static int aead_authenc_encrypt(struct aead_request *areq)
+static int aead_encrypt(struct aead_request *req)
 {
-	struct ipsec_esp_edesc *edesc;
-	struct crypto_aead *aead = crypto_aead_reqtfm(areq);
+	struct aead_edesc *edesc;
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
 	int ivsize = crypto_aead_ivsize(aead);
@@ -773,7 +773,7 @@ static int aead_authenc_encrypt(struct aead_request *areq)
 	dma_addr_t iv_dma;
 
 	/* allocate extended descriptor */
-	edesc = ipsec_esp_edesc_alloc(areq, DESC_AEAD_ENCRYPT_TEXT_LEN *
+	edesc = aead_edesc_alloc(req, DESC_AEAD_ENCRYPT_TEXT_LEN *
 				      CAAM_CMD_SZ);
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
@@ -784,29 +784,29 @@ static int aead_authenc_encrypt(struct aead_request *areq)
 	init_job_desc_shared(desc, ctx->shared_desc_phys,
 			     desc_len(ctx->sh_desc), HDR_SHARE_DEFER);
 
-	iv_dma = dma_map_single(jrdev, areq->iv, ivsize, DMA_TO_DEVICE);
+	iv_dma = dma_map_single(jrdev, req->iv, ivsize, DMA_TO_DEVICE);
 	/* check dma error */
 
 	append_load(desc, iv_dma, ivsize,
 		    LDST_CLASS_1_CCB | LDST_SRCDST_BYTE_CONTEXT);
 
-	return ipsec_esp(edesc, areq, OP_ALG_ENCRYPT, ipsec_esp_encrypt_done);
+	return init_aead_job(edesc, req, OP_ALG_ENCRYPT, aead_encrypt_done);
 }
 
-static int aead_authenc_decrypt(struct aead_request *req)
+static int aead_decrypt(struct aead_request *req)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	int ivsize = crypto_aead_ivsize(aead);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
-	struct ipsec_esp_edesc *edesc;
+	struct aead_edesc *edesc;
 	u32 *desc;
 	dma_addr_t iv_dma;
 
 	req->cryptlen -= ctx->authsize;
 
 	/* allocate extended descriptor */
-	edesc = ipsec_esp_edesc_alloc(req, DESC_AEAD_DECRYPT_TEXT_LEN *
+	edesc = aead_edesc_alloc(req, DESC_AEAD_DECRYPT_TEXT_LEN *
 				      CAAM_CMD_SZ);
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
@@ -823,26 +823,26 @@ static int aead_authenc_decrypt(struct aead_request *req)
 	append_load(desc, iv_dma, ivsize,
 		    LDST_CLASS_1_CCB | LDST_SRCDST_BYTE_CONTEXT);
 
-	return ipsec_esp(edesc, req, !OP_ALG_ENCRYPT, ipsec_esp_decrypt_done);
+	return init_aead_job(edesc, req, !OP_ALG_ENCRYPT, aead_decrypt_done);
 }
 
-static int aead_authenc_givencrypt(struct aead_givcrypt_request *req)
+static int aead_givencrypt(struct aead_givcrypt_request *areq)
 {
-	struct aead_request *areq = &req->areq;
-	struct ipsec_esp_edesc *edesc;
-	struct crypto_aead *aead = crypto_aead_reqtfm(areq);
+	struct aead_request *req = &areq->areq;
+	struct aead_edesc *edesc;
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
 	int ivsize = crypto_aead_ivsize(aead);
 	dma_addr_t iv_dma;
 	u32 *desc;
 
-	iv_dma = dma_map_single(jrdev, req->giv, ivsize, DMA_FROM_DEVICE);
+	iv_dma = dma_map_single(jrdev, areq->giv, ivsize, DMA_FROM_DEVICE);
 
-	debug("%s: giv %p\n", __func__, req->giv);
+	debug("%s: giv %p\n", __func__, areq->giv);
 
 	/* allocate extended descriptor */
-	edesc = ipsec_esp_edesc_alloc(areq, DESC_AEAD_GIVENCRYPT_TEXT_LEN *
+	edesc = aead_edesc_alloc(req, DESC_AEAD_GIVENCRYPT_TEXT_LEN *
 				      CAAM_CMD_SZ);
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
@@ -881,7 +881,7 @@ static int aead_authenc_givencrypt(struct aead_givcrypt_request *req)
 
 	append_fifo_store(desc, iv_dma, ivsize, FIFOST_TYPE_MESSAGE_DATA);
 
-	return ipsec_esp(edesc, areq, OP_ALG_ENCRYPT, ipsec_esp_encrypt_done);
+	return init_aead_job(edesc, req, OP_ALG_ENCRYPT, aead_encrypt_done);
 }
 
 struct caam_alg_template {
@@ -901,11 +901,11 @@ static struct caam_alg_template driver_algs[] = {
 		.driver_name = "authenc-hmac-sha1-cbc-aes-caam",
 		.blocksize = AES_BLOCK_SIZE,
 		.aead = {
-			.setkey = aead_authenc_setkey,
-			.setauthsize = aead_authenc_setauthsize,
-			.encrypt = aead_authenc_encrypt,
-			.decrypt = aead_authenc_decrypt,
-			.givencrypt = aead_authenc_givencrypt,
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.givencrypt = aead_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
@@ -919,11 +919,11 @@ static struct caam_alg_template driver_algs[] = {
 		.driver_name = "authenc-hmac-sha256-cbc-aes-caam",
 		.blocksize = AES_BLOCK_SIZE,
 		.aead = {
-			.setkey = aead_authenc_setkey,
-			.setauthsize = aead_authenc_setauthsize,
-			.encrypt = aead_authenc_encrypt,
-			.decrypt = aead_authenc_decrypt,
-			.givencrypt = aead_authenc_givencrypt,
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.givencrypt = aead_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
@@ -938,11 +938,11 @@ static struct caam_alg_template driver_algs[] = {
 		.driver_name = "authenc-hmac-sha512-cbc-aes-caam",
 		.blocksize = AES_BLOCK_SIZE,
 		.aead = {
-			.setkey = aead_authenc_setkey,
-			.setauthsize = aead_authenc_setauthsize,
-			.encrypt = aead_authenc_encrypt,
-			.decrypt = aead_authenc_decrypt,
-			.givencrypt = aead_authenc_givencrypt,
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.givencrypt = aead_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA512_DIGEST_SIZE,
@@ -957,11 +957,11 @@ static struct caam_alg_template driver_algs[] = {
 		.driver_name = "authenc-hmac-sha1-cbc-des3_ede-caam",
 		.blocksize = DES3_EDE_BLOCK_SIZE,
 		.aead = {
-			.setkey = aead_authenc_setkey,
-			.setauthsize = aead_authenc_setauthsize,
-			.encrypt = aead_authenc_encrypt,
-			.decrypt = aead_authenc_decrypt,
-			.givencrypt = aead_authenc_givencrypt,
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.givencrypt = aead_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
@@ -975,11 +975,11 @@ static struct caam_alg_template driver_algs[] = {
 		.driver_name = "authenc-hmac-sha256-cbc-des3_ede-caam",
 		.blocksize = DES3_EDE_BLOCK_SIZE,
 		.aead = {
-			.setkey = aead_authenc_setkey,
-			.setauthsize = aead_authenc_setauthsize,
-			.encrypt = aead_authenc_encrypt,
-			.decrypt = aead_authenc_decrypt,
-			.givencrypt = aead_authenc_givencrypt,
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.givencrypt = aead_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
@@ -994,11 +994,11 @@ static struct caam_alg_template driver_algs[] = {
 		.driver_name = "authenc-hmac-sha512-cbc-des3_ede-caam",
 		.blocksize = DES3_EDE_BLOCK_SIZE,
 		.aead = {
-			.setkey = aead_authenc_setkey,
-			.setauthsize = aead_authenc_setauthsize,
-			.encrypt = aead_authenc_encrypt,
-			.decrypt = aead_authenc_decrypt,
-			.givencrypt = aead_authenc_givencrypt,
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.givencrypt = aead_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA512_DIGEST_SIZE,
@@ -1013,11 +1013,11 @@ static struct caam_alg_template driver_algs[] = {
 		.driver_name = "authenc-hmac-sha1-cbc-des-caam",
 		.blocksize = DES_BLOCK_SIZE,
 		.aead = {
-			.setkey = aead_authenc_setkey,
-			.setauthsize = aead_authenc_setauthsize,
-			.encrypt = aead_authenc_encrypt,
-			.decrypt = aead_authenc_decrypt,
-			.givencrypt = aead_authenc_givencrypt,
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.givencrypt = aead_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = DES_BLOCK_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
@@ -1031,11 +1031,11 @@ static struct caam_alg_template driver_algs[] = {
 		.driver_name = "authenc-hmac-sha256-cbc-des-caam",
 		.blocksize = DES_BLOCK_SIZE,
 		.aead = {
-			.setkey = aead_authenc_setkey,
-			.setauthsize = aead_authenc_setauthsize,
-			.encrypt = aead_authenc_encrypt,
-			.decrypt = aead_authenc_decrypt,
-			.givencrypt = aead_authenc_givencrypt,
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.givencrypt = aead_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = DES_BLOCK_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
@@ -1050,11 +1050,11 @@ static struct caam_alg_template driver_algs[] = {
 		.driver_name = "authenc-hmac-sha512-cbc-des-caam",
 		.blocksize = DES_BLOCK_SIZE,
 		.aead = {
-			.setkey = aead_authenc_setkey,
-			.setauthsize = aead_authenc_setauthsize,
-			.encrypt = aead_authenc_encrypt,
-			.decrypt = aead_authenc_decrypt,
-			.givencrypt = aead_authenc_givencrypt,
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.givencrypt = aead_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = DES_BLOCK_SIZE,
 			.maxauthsize = SHA512_DIGEST_SIZE,
-- 
1.7.6
