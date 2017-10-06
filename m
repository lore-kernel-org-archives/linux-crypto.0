From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH 17/18] crypto: talitos - chain in buffered data for ahash on
 SEC1
Date: Fri,  6 Oct 2017 15:05:06 +0200 (CEST)
Message-ID: <28d351a973d31d140239c7e7e64999d95a011e8c.1507284818.git.christophe.leroy@c-s.fr>
References: <cover.1507284818.git.christophe.leroy@c-s.fr>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1507284818.git.christophe.leroy@c-s.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

SEC1 doesn't support S/G in descriptors so for hash operations,
the CPU has to build a buffer containing the buffered block and
the incoming data. This generates a lot of memory copies which
represents more than 50% of CPU time of a md5sum operation as
shown below with a 'perf record'.

|--86.24%-- kcapi_md_digest
|          |
|          |--86.18%-- _kcapi_common_vmsplice_chunk_fd
|          |          |
|          |          |--83.68%-- splice
|          |          |          |
|          |          |          |--83.59%-- ret_from_syscall
|          |          |          |          |
|          |          |          |          |--83.52%-- sys_splice
|          |          |          |          |          |
|          |          |          |          |          |--83.49%-- splice_from_pipe
|          |          |          |          |          |          |
|          |          |          |          |          |          |--83.04%-- __splice_from_pipe
|          |          |          |          |          |          |          |
|          |          |          |          |          |          |          |--80.67%-- pipe_to_sendpage
|          |          |          |          |          |          |          |          |
|          |          |          |          |          |          |          |          |--78.25%-- hash_sendpage
|          |          |          |          |          |          |          |          |          |
|          |          |          |          |          |          |          |          |          |--60.08%-- ahash_process_req
|          |          |          |          |          |          |          |          |          |          |
|          |          |          |          |          |          |          |          |          |          |--56.36%-- sg_copy_buffer
|          |          |          |          |          |          |          |          |          |          |          |
|          |          |          |          |          |          |          |          |          |          |          |--55.29%-- memcpy
|          |          |          |          |          |          |          |          |          |          |          |

However, unlike SEC2+, SEC1 offers the possibility to chain
descriptors. It is therefore possible to build a first descriptor
pointing to the buffered data and a second descriptor pointing to
the incoming data, hence avoiding the memory copy to a single
buffer.

With this patch, the time necessary for a md5sum on a 90Mbytes file
is approximately 3 seconds. Without the patch it takes 6 seconds.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 139 ++++++++++++++++++++++++++++++++++++++++++-----
 drivers/crypto/talitos.h |   1 +
 2 files changed, 127 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index d495649d5267..5c4499a85611 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -160,6 +160,10 @@ static int reset_channel(struct device *dev, int ch)
 	/* set 36-bit addressing, done writeback enable and done IRQ enable */
 	setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO, TALITOS_CCCR_LO_EAE |
 		  TALITOS_CCCR_LO_CDWE | TALITOS_CCCR_LO_CDIE);
+	/* enable chaining descriptors */
+	if (is_sec1)
+		setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO,
+			  TALITOS_CCCR_LO_NE);
 
 	/* and ICCR writeback, if available */
 	if (priv->features & TALITOS_FTR_HW_AUTH_CHECK)
@@ -333,7 +337,12 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 
 		/* descriptors with their done bits set don't get the error */
 		rmb();
-		hdr = is_sec1 ? request->desc->hdr1 : request->desc->hdr;
+		if (!is_sec1)
+			hdr = request->desc->hdr;
+		else if (request->desc->next_desc)
+			hdr = (request->desc + 1)->hdr1;
+		else
+			hdr = request->desc->hdr1;
 
 		if ((hdr & DESC_HDR_DONE) == DESC_HDR_DONE)
 			status = 0;
@@ -454,7 +463,8 @@ static u32 current_desc_hdr(struct device *dev, int ch)
 	tail = priv->chan[ch].tail;
 
 	iter = tail;
-	while (priv->chan[ch].fifo[iter].dma_desc != cur_desc) {
+	while (priv->chan[ch].fifo[iter].dma_desc != cur_desc &&
+	       priv->chan[ch].fifo[iter].desc->next_desc != cur_desc) {
 		iter = (iter + 1) & (priv->fifo_len - 1);
 		if (iter == tail) {
 			dev_err(dev, "couldn't locate current descriptor\n");
@@ -462,6 +472,9 @@ static u32 current_desc_hdr(struct device *dev, int ch)
 		}
 	}
 
+	if (priv->chan[ch].fifo[iter].desc->next_desc == cur_desc)
+		return (priv->chan[ch].fifo[iter].desc + 1)->hdr;
+
 	return priv->chan[ch].fifo[iter].desc->hdr;
 }
 
@@ -819,6 +832,7 @@ struct talitos_ctx {
 	unsigned int keylen;
 	unsigned int enckeylen;
 	unsigned int authkeylen;
+	dma_addr_t dma_buf;
 	dma_addr_t dma_hw_context;
 };
 
@@ -1380,6 +1394,10 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 		alloc_len += icv_stashing ? authsize : 0;
 	}
 
+	/* if its a ahash, add space for a second desc next to the first one */
+	if (is_sec1 && !dst)
+		alloc_len += sizeof(struct talitos_desc);
+
 	edesc = kmalloc(alloc_len, GFP_DMA | flags);
 	if (!edesc) {
 		dev_err(dev, "could not allocate edescriptor\n");
@@ -1392,11 +1410,15 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 	edesc->dst_nents = dst_nents;
 	edesc->iv_dma = iv_dma;
 	edesc->dma_len = dma_len;
-	if (dma_len)
-		edesc->dma_link_tbl = dma_map_single(dev, &edesc->link_tbl[0],
+	if (dma_len) {
+		void *addr = &edesc->link_tbl[0];
+
+		if (is_sec1 && !dst)
+			addr += sizeof(struct talitos_desc);
+		edesc->dma_link_tbl = dma_map_single(dev, addr,
 						     edesc->dma_len,
 						     DMA_BIDIRECTIONAL);
-
+	}
 	return edesc;
 error_sg:
 	if (iv_dma)
@@ -1671,6 +1693,9 @@ static void common_nonsnoop_hash_unmap(struct device *dev,
 		dma_unmap_single(dev, edesc->dma_link_tbl, edesc->dma_len,
 				 DMA_BIDIRECTIONAL);
 
+	if (edesc->desc.next_desc)
+		dma_unmap_single(dev, be32_to_cpu(edesc->desc.next_desc),
+				 TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
 }
 
 static void ahash_done(struct device *dev,
@@ -1717,6 +1742,7 @@ static void talitos_handle_buggy_hash(struct talitos_ctx *ctx,
 
 static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 				struct ahash_request *areq, unsigned int length,
+				unsigned int offset,
 				void (*callback) (struct device *dev,
 						  struct talitos_desc *desc,
 						  void *context, int error))
@@ -1748,19 +1774,29 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 		to_talitos_ptr(&desc->ptr[2], ctx->dma_key, ctx->keylen,
 			       is_sec1);
 
+	if (is_sec1 && req_ctx->nbuf)
+		length -= req_ctx->nbuf;
+
 	sg_count = edesc->src_nents ?: 1;
 	if (is_sec1 && sg_count > 1)
-		sg_copy_to_buffer(req_ctx->psrc, sg_count, edesc->buf, length);
-	else
+		sg_pcopy_to_buffer(req_ctx->psrc, sg_count,
+				   edesc->buf + sizeof(struct talitos_desc),
+				   length, req_ctx->nbuf);
+	else if (length)
 		sg_count = dma_map_sg(dev, req_ctx->psrc, sg_count,
 				      DMA_TO_DEVICE);
 	/*
 	 * data in
 	 */
-	sg_count = talitos_sg_map(dev, req_ctx->psrc, length, edesc,
-				  &desc->ptr[3], sg_count, 0, 0);
-	if (sg_count > 1)
-		sync_needed = true;
+	if (is_sec1 && req_ctx->nbuf) {
+		to_talitos_ptr(&desc->ptr[3], ctx->dma_buf, req_ctx->nbuf,
+			       is_sec1);
+	} else {
+		sg_count = talitos_sg_map(dev, req_ctx->psrc, length, edesc,
+					  &desc->ptr[3], sg_count, offset, 0);
+		if (sg_count > 1)
+			sync_needed = true;
+	}
 
 	/* fifth DWORD empty */
 
@@ -1778,6 +1814,36 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 	if (is_sec1 && from_talitos_ptr_len(&desc->ptr[3], true) == 0)
 		talitos_handle_buggy_hash(ctx, edesc, &desc->ptr[3]);
 
+	if (is_sec1 && req_ctx->nbuf && length) {
+		struct talitos_desc *desc2 = desc + 1;
+		dma_addr_t next_desc;
+
+		memset(desc2, 0, sizeof(*desc2));
+		desc2->hdr = desc->hdr;
+		desc2->hdr &= ~DESC_HDR_MODE0_MDEU_INIT;
+		desc2->hdr1 = desc2->hdr;
+		desc->hdr &= ~DESC_HDR_MODE0_MDEU_PAD;
+		desc->hdr |= DESC_HDR_MODE0_MDEU_CONT;
+		desc->hdr &= ~DESC_HDR_DONE_NOTIFY;
+
+		to_talitos_ptr(&desc2->ptr[1], ctx->dma_hw_context,
+			       req_ctx->hw_context_size, is_sec1);
+
+		copy_talitos_ptr(&desc2->ptr[2], &desc->ptr[2], is_sec1);
+		sg_count = talitos_sg_map(dev, req_ctx->psrc, length, edesc,
+					  &desc2->ptr[3], sg_count, offset, 0);
+		if (sg_count > 1)
+			sync_needed = true;
+		copy_talitos_ptr(&desc2->ptr[5], &desc->ptr[5], is_sec1);
+		if (req_ctx->last)
+			to_talitos_ptr(&desc->ptr[5], ctx->dma_hw_context,
+				       req_ctx->hw_context_size, is_sec1);
+
+		next_desc = dma_map_single(dev, &desc2->hdr1, TALITOS_DESC_SIZE,
+					   DMA_BIDIRECTIONAL);
+		desc->next_desc = cpu_to_be32(next_desc);
+	}
+
 	if (sync_needed)
 		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
 					   edesc->dma_len, DMA_BIDIRECTIONAL);
@@ -1796,6 +1862,11 @@ static struct talitos_edesc *ahash_edesc_alloc(struct ahash_request *areq,
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+	struct talitos_private *priv = dev_get_drvdata(ctx->dev);
+	bool is_sec1 = has_ftr_sec1(priv);
+
+	if (is_sec1)
+		nbytes -= req_ctx->nbuf;
 
 	return talitos_edesc_alloc(ctx->dev, req_ctx->psrc, NULL, NULL, 0,
 				   nbytes, 0, 0, 0, areq->base.flags, false);
@@ -1808,6 +1879,8 @@ static int ahash_init(struct ahash_request *areq)
 	struct device *dev = ctx->dev;
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 	unsigned int size;
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	bool is_sec1 = has_ftr_sec1(priv);
 
 	/* Initialize the context */
 	req_ctx->nbuf = 0;
@@ -1823,6 +1896,13 @@ static int ahash_init(struct ahash_request *areq)
 				 DMA_BIDIRECTIONAL);
 	ctx->dma_hw_context = dma_map_single(dev, req_ctx->hw_context, size,
 					     DMA_BIDIRECTIONAL);
+	if (ctx->dma_buf)
+		dma_unmap_single(dev, ctx->dma_buf, sizeof(req_ctx->buf),
+				 DMA_TO_DEVICE);
+	if (is_sec1)
+		ctx->dma_buf = dma_map_single(dev, req_ctx->buf,
+					      sizeof(req_ctx->buf),
+					      DMA_TO_DEVICE);
 	return 0;
 }
 
@@ -1871,6 +1951,10 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 	unsigned int to_hash_later;
 	unsigned int nsg;
 	int nents;
+	struct device *dev = ctx->dev;
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	bool is_sec1 = has_ftr_sec1(priv);
+	int offset = 0;
 
 	if (!req_ctx->last && (nbytes + req_ctx->nbuf <= blocksize)) {
 		/* Buffer up to one whole block */
@@ -1901,13 +1985,27 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 	}
 
 	/* Chain in any previously buffered data */
-	if (req_ctx->nbuf) {
+	if (!is_sec1 && req_ctx->nbuf) {
 		nsg = (req_ctx->nbuf < nbytes_to_hash) ? 2 : 1;
 		sg_init_table(req_ctx->bufsl, nsg);
 		sg_set_buf(req_ctx->bufsl, req_ctx->buf, req_ctx->nbuf);
 		if (nsg > 1)
 			sg_chain(req_ctx->bufsl, 2, areq->src);
 		req_ctx->psrc = req_ctx->bufsl;
+	} else if (is_sec1 && req_ctx->nbuf && req_ctx->nbuf < blocksize) {
+		if (nbytes_to_hash > blocksize)
+			offset = blocksize - req_ctx->nbuf;
+		else
+			offset = nbytes_to_hash - req_ctx->nbuf;
+		nents = sg_nents_for_len(areq->src, offset);
+		if (nents < 0) {
+			dev_err(ctx->dev, "Invalid number of src SG.\n");
+			return nents;
+		}
+		sg_copy_to_buffer(areq->src, nents,
+				  req_ctx->buf + req_ctx->nbuf, offset);
+		req_ctx->nbuf += offset;
+		req_ctx->psrc = areq->src;
 	} else
 		req_ctx->psrc = areq->src;
 
@@ -1940,6 +2038,9 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 	/* request SEC to INIT hash. */
 	if (req_ctx->first && !req_ctx->swinit)
 		edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_INIT;
+	if (is_sec1)
+		dma_sync_single_for_device(dev, ctx->dma_buf,
+					   req_ctx->nbuf, DMA_TO_DEVICE);
 
 	/* When the tfm context has a keylen, it's an HMAC.
 	 * A first or last (ie. not middle) descriptor must request HMAC.
@@ -1947,7 +2048,7 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 	if (ctx->keylen && (req_ctx->first || req_ctx->last))
 		edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_HMAC;
 
-	return common_nonsnoop_hash(edesc, areq, nbytes_to_hash,
+	return common_nonsnoop_hash(edesc, areq, nbytes_to_hash, offset,
 				    ahash_done);
 }
 
@@ -2019,6 +2120,8 @@ static int ahash_import(struct ahash_request *areq, const void *in)
 	unsigned int size;
 	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct device *dev = ctx->dev;
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	bool is_sec1 = has_ftr_sec1(priv);
 
 	memset(req_ctx, 0, sizeof(*req_ctx));
 	size = (crypto_ahash_digestsize(tfm) <= SHA256_DIGEST_SIZE)
@@ -2032,7 +2135,14 @@ static int ahash_import(struct ahash_request *areq, const void *in)
 	memcpy(req_ctx->hw_context, export->hw_context, size);
 	ctx->dma_hw_context = dma_map_single(dev, req_ctx->hw_context, size,
 					     DMA_BIDIRECTIONAL);
+	if (ctx->dma_buf)
+		dma_unmap_single(dev, ctx->dma_buf, sizeof(req_ctx->buf),
+				 DMA_TO_DEVICE);
 	memcpy(req_ctx->buf, export->buf, export->nbuf);
+	if (is_sec1)
+		ctx->dma_buf = dma_map_single(dev, req_ctx->buf,
+					      sizeof(req_ctx->buf),
+					      DMA_TO_DEVICE);
 	req_ctx->swinit = export->swinit;
 	req_ctx->first = export->first;
 	req_ctx->last = export->last;
@@ -2986,6 +3096,9 @@ static void talitos_cra_exit_ahash(struct crypto_tfm *tfm)
 	if (ctx->dma_hw_context)
 		dma_unmap_single(dev, ctx->dma_hw_context, size,
 				 DMA_BIDIRECTIONAL);
+	if (ctx->dma_buf)
+		dma_unmap_single(dev, ctx->dma_buf, HASH_MAX_BLOCK_SIZE,
+				 DMA_TO_DEVICE);
 }
 
 /*
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 2f04d83c3062..a65a63e0d6c1 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -236,6 +236,7 @@ static inline bool has_ftr_sec1(struct talitos_private *priv)
 #define   TALITOS_CCCR_LO_IWSE		0x80   /* chan. ICCR writeback enab. */
 #define   TALITOS_CCCR_LO_EAE		0x20   /* extended address enable */
 #define   TALITOS_CCCR_LO_CDWE		0x10   /* chan. done writeback enab. */
+#define   TALITOS_CCCR_LO_NE		0x8    /* fetch next descriptor enab. */
 #define   TALITOS_CCCR_LO_NT		0x4    /* notification type */
 #define   TALITOS_CCCR_LO_CDIE		0x2    /* channel done IRQ enable */
 #define   TALITOS1_CCCR_LO_RESET	0x1    /* channel reset on SEC1 */
-- 
2.13.3
