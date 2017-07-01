From: =?UTF-8?q?Simon=20Sandstr=C3=B6m?= <simon@nikanor.nu>
Subject: [PATCH 02/10] staging: ccree: Fix alignment issues in ssi_buffer_mgr.c
Date: Sun,  2 Jul 2017 01:25:47 +0200
Message-ID: <20170701232555.5538-3-simon@nikanor.nu>
References: <20170701232555.5538-1-simon@nikanor.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: gregkh@linuxfoundation.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        =?UTF-8?q?Simon=20Sandstr=C3=B6m?= <simon@nikanor.nu>
To: gilad@benyossef.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:33839 "EHLO
        mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751976AbdGAX0b (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 1 Jul 2017 19:26:31 -0400
Received: by mail-lf0-f48.google.com with SMTP id l13so86397313lfl.1
        for <linux-crypto@vger.kernel.org>; Sat, 01 Jul 2017 16:26:29 -0700 (PDT)
In-Reply-To: <20170701232555.5538-1-simon@nikanor.nu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixes checkpatch.pl alignment warnings.

Signed-off-by: Simon Sandström <simon@nikanor.nu>
---
 drivers/staging/ccree/ssi_buffer_mgr.c | 295 ++++++++++++++++++---------------
 1 file changed, 164 insertions(+), 131 deletions(-)

diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index b35871eeabd1..3f163d3f3f48 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -162,8 +162,8 @@ static inline int ssi_buffer_mgr_render_buff_to_mlli(
 		cc_lli_set_addr(mlli_entry_p, buff_dma);
 		cc_lli_set_size(mlli_entry_p, CC_MAX_MLLI_ENTRY_SIZE);
 		SSI_LOG_DEBUG("entry[%d]: single_buff=0x%08X size=%08X\n", *curr_nents,
-			   mlli_entry_p[LLI_WORD0_OFFSET],
-			   mlli_entry_p[LLI_WORD1_OFFSET]);
+			      mlli_entry_p[LLI_WORD0_OFFSET],
+			      mlli_entry_p[LLI_WORD1_OFFSET]);
 		buff_dma += CC_MAX_MLLI_ENTRY_SIZE;
 		buff_size -= CC_MAX_MLLI_ENTRY_SIZE;
 		mlli_entry_p = mlli_entry_p + 2;
@@ -173,8 +173,8 @@ static inline int ssi_buffer_mgr_render_buff_to_mlli(
 	cc_lli_set_addr(mlli_entry_p, buff_dma);
 	cc_lli_set_size(mlli_entry_p, buff_size);
 	SSI_LOG_DEBUG("entry[%d]: single_buff=0x%08X size=%08X\n", *curr_nents,
-		   mlli_entry_p[LLI_WORD0_OFFSET],
-		   mlli_entry_p[LLI_WORD1_OFFSET]);
+		      mlli_entry_p[LLI_WORD0_OFFSET],
+		      mlli_entry_p[LLI_WORD1_OFFSET]);
 	mlli_entry_p = mlli_entry_p + 2;
 	*mlli_entry_pp = mlli_entry_p;
 	(*curr_nents)++;
@@ -302,7 +302,7 @@ static inline void ssi_buffer_mgr_add_scatterlist_entry(
 	unsigned int index = sgl_data->num_of_buffers;
 
 	SSI_LOG_DEBUG("index=%u nents=%u sgl=%pK data_len=0x%08X is_last=%d\n",
-		     index, nents, sgl, data_len, is_last_table);
+		      index, nents, sgl, data_len, is_last_table);
 	sgl_data->nents[index] = nents;
 	sgl_data->entry[index].sgl = sgl;
 	sgl_data->offset[index] = data_offset;
@@ -317,7 +317,7 @@ static inline void ssi_buffer_mgr_add_scatterlist_entry(
 
 static int
 ssi_buffer_mgr_dma_map_sg(struct device *dev, struct scatterlist *sg, u32 nents,
-			 enum dma_data_direction direction)
+			  enum dma_data_direction direction)
 {
 	u32 i, j;
 	struct scatterlist *l_sg = sg;
@@ -374,7 +374,7 @@ static int ssi_buffer_mgr_map_scatterlist(
 		if (*nents > max_sg_nents) {
 			*nents = 0;
 			SSI_LOG_ERR("Too many fragments. current %d max %d\n",
-				   *nents, max_sg_nents);
+				    *nents, max_sg_nents);
 			return -ENOMEM;
 		}
 		if (!is_chained) {
@@ -408,10 +408,10 @@ static int ssi_buffer_mgr_map_scatterlist(
 
 static inline int
 ssi_aead_handle_config_buf(struct device *dev,
-	struct aead_req_ctx *areq_ctx,
-	u8 *config_data,
-	struct buffer_array *sg_data,
-	unsigned int assoclen)
+			   struct aead_req_ctx *areq_ctx,
+			   u8 *config_data,
+			   struct buffer_array *sg_data,
+			   unsigned int assoclen)
 {
 	SSI_LOG_DEBUG(" handle additional data config set to   DLLI\n");
 	/* create sg for the current buffer */
@@ -433,19 +433,18 @@ ssi_aead_handle_config_buf(struct device *dev,
 	/* prepare for case of MLLI */
 	if (assoclen > 0) {
 		ssi_buffer_mgr_add_scatterlist_entry(sg_data, 1,
-						    &areq_ctx->ccm_adata_sg,
-						    (AES_BLOCK_SIZE +
-						    areq_ctx->ccm_hdr_size), 0,
-						    false, NULL);
+						     &areq_ctx->ccm_adata_sg,
+						     (AES_BLOCK_SIZE + areq_ctx->ccm_hdr_size),
+						     0, false, NULL);
 	}
 	return 0;
 }
 
 static inline int ssi_ahash_handle_curr_buf(struct device *dev,
-					   struct ahash_req_ctx *areq_ctx,
-					   u8 *curr_buff,
-					   u32 curr_buff_cnt,
-					   struct buffer_array *sg_data)
+					    struct ahash_req_ctx *areq_ctx,
+					    u8 *curr_buff,
+					    u32 curr_buff_cnt,
+					    struct buffer_array *sg_data)
 {
 	SSI_LOG_DEBUG(" handle curr buff %x set to   DLLI\n", curr_buff_cnt);
 	/* create sg for the current buffer */
@@ -469,7 +468,7 @@ static inline int ssi_ahash_handle_curr_buf(struct device *dev,
 	areq_ctx->in_nents = 0;
 	/* prepare for case of MLLI */
 	ssi_buffer_mgr_add_scatterlist_entry(sg_data, 1, areq_ctx->buff_sg,
-				curr_buff_cnt, 0, false, NULL);
+					     curr_buff_cnt, 0, false, NULL);
 	return 0;
 }
 
@@ -484,8 +483,8 @@ void ssi_buffer_mgr_unmap_blkcipher_request(
 
 	if (likely(req_ctx->gen_ctx.iv_dma_addr != 0)) {
 		SSI_LOG_DEBUG("Unmapped iv: iv_dma_addr=0x%llX iv_size=%u\n",
-			(unsigned long long)req_ctx->gen_ctx.iv_dma_addr,
-			ivsize);
+			      (unsigned long long)req_ctx->gen_ctx.iv_dma_addr,
+			      ivsize);
 		dma_unmap_single(dev, req_ctx->gen_ctx.iv_dma_addr,
 				 ivsize,
 				 req_ctx->is_giv ? DMA_BIDIRECTIONAL :
@@ -498,16 +497,12 @@ void ssi_buffer_mgr_unmap_blkcipher_request(
 			      req_ctx->mlli_params.mlli_dma_addr);
 	}
 
-	dma_unmap_sg(dev, src, req_ctx->in_nents,
-		DMA_BIDIRECTIONAL);
-	SSI_LOG_DEBUG("Unmapped req->src=%pK\n",
-		     sg_virt(src));
+	dma_unmap_sg(dev, src, req_ctx->in_nents, DMA_BIDIRECTIONAL);
+	SSI_LOG_DEBUG("Unmapped req->src=%pK\n", sg_virt(src));
 
 	if (src != dst) {
-		dma_unmap_sg(dev, dst, req_ctx->out_nents,
-			DMA_BIDIRECTIONAL);
-		SSI_LOG_DEBUG("Unmapped req->dst=%pK\n",
-			sg_virt(dst));
+		dma_unmap_sg(dev, dst, req_ctx->out_nents, DMA_BIDIRECTIONAL);
+		SSI_LOG_DEBUG("Unmapped req->dst=%pK\n", sg_virt(dst));
 	}
 }
 
@@ -542,22 +537,24 @@ int ssi_buffer_mgr_map_blkcipher_request(
 				       req_ctx->is_giv ? DMA_BIDIRECTIONAL :
 				       DMA_TO_DEVICE);
 		if (unlikely(dma_mapping_error(dev,
-					req_ctx->gen_ctx.iv_dma_addr))) {
+					       req_ctx->gen_ctx.iv_dma_addr))) {
 			SSI_LOG_ERR("Mapping iv %u B at va=%pK "
 				   "for DMA failed\n", ivsize, info);
 			return -ENOMEM;
 		}
 		SSI_LOG_DEBUG("Mapped iv %u B at va=%pK to dma=0x%llX\n",
-			ivsize, info,
-			(unsigned long long)req_ctx->gen_ctx.iv_dma_addr);
+			      ivsize, info,
+			      (unsigned long long)req_ctx->gen_ctx.iv_dma_addr);
 	} else {
 		req_ctx->gen_ctx.iv_dma_addr = 0;
 	}
 
 	/* Map the src SGL */
 	rc = ssi_buffer_mgr_map_scatterlist(dev, src,
-		nbytes, DMA_BIDIRECTIONAL, &req_ctx->in_nents,
-		LLI_MAX_NUM_OF_DATA_ENTRIES, &dummy, &mapped_nents);
+					    nbytes, DMA_BIDIRECTIONAL,
+					    &req_ctx->in_nents,
+					    LLI_MAX_NUM_OF_DATA_ENTRIES, &dummy,
+					    &mapped_nents);
 	if (unlikely(rc != 0)) {
 		rc = -ENOMEM;
 		goto ablkcipher_exit;
@@ -570,8 +567,10 @@ int ssi_buffer_mgr_map_blkcipher_request(
 		if (unlikely(req_ctx->dma_buf_type == SSI_DMA_BUF_MLLI)) {
 			req_ctx->out_nents = 0;
 			ssi_buffer_mgr_add_scatterlist_entry(&sg_data,
-				req_ctx->in_nents, src,
-				nbytes, 0, true, &req_ctx->in_mlli_nents);
+							     req_ctx->in_nents,
+							     src, nbytes, 0,
+							     true,
+							     &req_ctx->in_mlli_nents);
 		}
 	} else {
 		/* Map the dst sg */
@@ -588,13 +587,15 @@ int ssi_buffer_mgr_map_blkcipher_request(
 
 		if (unlikely((req_ctx->dma_buf_type == SSI_DMA_BUF_MLLI))) {
 			ssi_buffer_mgr_add_scatterlist_entry(&sg_data,
-				req_ctx->in_nents, src,
-				nbytes, 0, true,
-				&req_ctx->in_mlli_nents);
+							     req_ctx->in_nents,
+							     src, nbytes, 0,
+							     true,
+							     &req_ctx->in_mlli_nents);
 			ssi_buffer_mgr_add_scatterlist_entry(&sg_data,
-				req_ctx->out_nents, dst,
-				nbytes, 0, true,
-				&req_ctx->out_mlli_nents);
+							     req_ctx->out_nents,
+							     dst, nbytes, 0,
+							     true,
+							     &req_ctx->out_mlli_nents);
 		}
 	}
 
@@ -606,7 +607,7 @@ int ssi_buffer_mgr_map_blkcipher_request(
 	}
 
 	SSI_LOG_DEBUG("areq_ctx->dma_buf_type = %s\n",
-		GET_DMA_BUFFER_TYPE(req_ctx->dma_buf_type));
+		      GET_DMA_BUFFER_TYPE(req_ctx->dma_buf_type));
 
 	return 0;
 
@@ -628,7 +629,7 @@ void ssi_buffer_mgr_unmap_aead_request(
 
 	if (areq_ctx->mac_buf_dma_addr != 0) {
 		dma_unmap_single(dev, areq_ctx->mac_buf_dma_addr,
-			MAX_MAC_SIZE, DMA_BIDIRECTIONAL);
+				 MAX_MAC_SIZE, DMA_BIDIRECTIONAL);
 	}
 
 #if SSI_CC_HAS_AES_GCM
@@ -645,12 +646,12 @@ void ssi_buffer_mgr_unmap_aead_request(
 
 		if (areq_ctx->gcm_iv_inc1_dma_addr != 0) {
 			dma_unmap_single(dev, areq_ctx->gcm_iv_inc1_dma_addr,
-				AES_BLOCK_SIZE, DMA_TO_DEVICE);
+					 AES_BLOCK_SIZE, DMA_TO_DEVICE);
 		}
 
 		if (areq_ctx->gcm_iv_inc2_dma_addr != 0) {
 			dma_unmap_single(dev, areq_ctx->gcm_iv_inc2_dma_addr,
-				AES_BLOCK_SIZE, DMA_TO_DEVICE);
+					 AES_BLOCK_SIZE, DMA_TO_DEVICE);
 		}
 	}
 #endif
@@ -658,7 +659,7 @@ void ssi_buffer_mgr_unmap_aead_request(
 	if (areq_ctx->ccm_hdr_size != ccm_header_size_null) {
 		if (areq_ctx->ccm_iv0_dma_addr != 0) {
 			dma_unmap_single(dev, areq_ctx->ccm_iv0_dma_addr,
-				AES_BLOCK_SIZE, DMA_TO_DEVICE);
+					 AES_BLOCK_SIZE, DMA_TO_DEVICE);
 		}
 
 		dma_unmap_sg(dev, &areq_ctx->ccm_adata_sg, 1, DMA_TO_DEVICE);
@@ -673,8 +674,8 @@ void ssi_buffer_mgr_unmap_aead_request(
 	 */
 	if (areq_ctx->mlli_params.curr_pool) {
 		SSI_LOG_DEBUG("free MLLI buffer: dma=0x%08llX virt=%pK\n",
-			(unsigned long long)areq_ctx->mlli_params.mlli_dma_addr,
-			areq_ctx->mlli_params.mlli_virt_addr);
+			      (unsigned long long)areq_ctx->mlli_params.mlli_dma_addr,
+			      areq_ctx->mlli_params.mlli_virt_addr);
 		dma_pool_free(areq_ctx->mlli_params.curr_pool,
 			      areq_ctx->mlli_params.mlli_virt_addr,
 			      areq_ctx->mlli_params.mlli_dma_addr);
@@ -690,9 +691,13 @@ void ssi_buffer_mgr_unmap_aead_request(
 	dma_unmap_sg(dev, req->src, ssi_buffer_mgr_get_sgl_nents(req->src, size_to_unmap, &dummy, &chained), DMA_BIDIRECTIONAL);
 	if (unlikely(req->src != req->dst)) {
 		SSI_LOG_DEBUG("Unmapping dst sgl: req->dst=%pK\n",
-			sg_virt(req->dst));
-		dma_unmap_sg(dev, req->dst, ssi_buffer_mgr_get_sgl_nents(req->dst, size_to_unmap, &dummy, &chained),
-			DMA_BIDIRECTIONAL);
+			      sg_virt(req->dst));
+		dma_unmap_sg(dev, req->dst,
+			     ssi_buffer_mgr_get_sgl_nents(req->dst,
+							  size_to_unmap,
+							  &dummy,
+							  &chained),
+			     DMA_BIDIRECTIONAL);
 	}
 	if (drvdata->coherent &&
 	    (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT) &&
@@ -753,11 +758,11 @@ static inline int ssi_buffer_mgr_get_aead_icv_nents(
 		*is_icv_fragmented = true;
 	} else {
 		SSI_LOG_ERR("Unsupported num. of ICV fragments (> %d)\n",
-			MAX_ICV_NENTS_SUPPORTED);
+			    MAX_ICV_NENTS_SUPPORTED);
 		nents = -1; /*unsupported*/
 	}
 	SSI_LOG_DEBUG("is_frag=%s icv_nents=%u\n",
-		(*is_icv_fragmented ? "true" : "false"), nents);
+		      (*is_icv_fragmented ? "true" : "false"), nents);
 
 	return nents;
 }
@@ -782,14 +787,14 @@ static inline int ssi_buffer_mgr_aead_chain_iv(
 		hw_iv_size, DMA_BIDIRECTIONAL);
 	if (unlikely(dma_mapping_error(dev, areq_ctx->gen_ctx.iv_dma_addr))) {
 		SSI_LOG_ERR("Mapping iv %u B at va=%pK for DMA failed\n",
-			hw_iv_size, req->iv);
+			    hw_iv_size, req->iv);
 		rc = -ENOMEM;
 		goto chain_iv_exit;
 	}
 
 	SSI_LOG_DEBUG("Mapped iv %u B at va=%pK to dma=0x%llX\n",
-		hw_iv_size, req->iv,
-		(unsigned long long)areq_ctx->gen_ctx.iv_dma_addr);
+		      hw_iv_size, req->iv,
+		      (unsigned long long)areq_ctx->gen_ctx.iv_dma_addr);
 	if (do_chain && areq_ctx->plaintext_authenticate_only) {  // TODO: what about CTR?? ask Ron
 		struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 		unsigned int iv_size_to_authenc = crypto_aead_ivsize(tfm);
@@ -833,8 +838,8 @@ static inline int ssi_buffer_mgr_aead_chain_assoc(
 		areq_ctx->assoc.nents = 0;
 		areq_ctx->assoc.mlli_nents = 0;
 		SSI_LOG_DEBUG("Chain assoc of length 0: buff_type=%s nents=%u\n",
-			GET_DMA_BUFFER_TYPE(areq_ctx->assoc_buff_type),
-			areq_ctx->assoc.nents);
+			      GET_DMA_BUFFER_TYPE(areq_ctx->assoc_buff_type),
+			      areq_ctx->assoc.nents);
 		goto chain_assoc_exit;
 	}
 
@@ -868,10 +873,9 @@ static inline int ssi_buffer_mgr_aead_chain_assoc(
 	if (areq_ctx->ccm_hdr_size != ccm_header_size_null) {
 		if (unlikely((mapped_nents + 1) >
 			LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES)) {
-			SSI_LOG_ERR("CCM case.Too many fragments. "
-				"Current %d max %d\n",
-				(areq_ctx->assoc.nents + 1),
-				LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES);
+			SSI_LOG_ERR("CCM case.Too many fragments. Current %d max %d\n",
+				    (areq_ctx->assoc.nents + 1),
+				    LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES);
 			rc = -ENOMEM;
 			goto chain_assoc_exit;
 		}
@@ -884,10 +888,10 @@ static inline int ssi_buffer_mgr_aead_chain_assoc(
 		areq_ctx->assoc_buff_type = SSI_DMA_BUF_MLLI;
 
 	if (unlikely((do_chain) ||
-		(areq_ctx->assoc_buff_type == SSI_DMA_BUF_MLLI))) {
+		     (areq_ctx->assoc_buff_type == SSI_DMA_BUF_MLLI))) {
 		SSI_LOG_DEBUG("Chain assoc: buff_type=%s nents=%u\n",
-			GET_DMA_BUFFER_TYPE(areq_ctx->assoc_buff_type),
-			areq_ctx->assoc.nents);
+			      GET_DMA_BUFFER_TYPE(areq_ctx->assoc_buff_type),
+			      areq_ctx->assoc.nents);
 		ssi_buffer_mgr_add_scatterlist_entry(
 			sg_data, areq_ctx->assoc.nents,
 			req->src, req->assoclen, 0, is_last,
@@ -951,13 +955,18 @@ static inline int ssi_buffer_mgr_prepare_aead_data_mlli(
 	if (likely(req->src == req->dst)) {
 		/*INPLACE*/
 		ssi_buffer_mgr_add_scatterlist_entry(sg_data,
-			areq_ctx->src.nents, areq_ctx->srcSgl,
-			areq_ctx->cryptlen, areq_ctx->srcOffset, is_last_table,
-			&areq_ctx->src.mlli_nents);
+						     areq_ctx->src.nents,
+						     areq_ctx->srcSgl,
+						     areq_ctx->cryptlen,
+						     areq_ctx->srcOffset,
+						     is_last_table,
+						     &areq_ctx->src.mlli_nents);
 
 		icv_nents = ssi_buffer_mgr_get_aead_icv_nents(areq_ctx->srcSgl,
-			areq_ctx->src.nents, authsize, *src_last_bytes,
-			&areq_ctx->is_icv_fragmented);
+							      areq_ctx->src.nents,
+							      authsize,
+							      *src_last_bytes,
+							      &areq_ctx->is_icv_fragmented);
 		if (unlikely(icv_nents < 0)) {
 			rc = -ENOTSUPP;
 			goto prepare_data_mlli_exit;
@@ -1005,17 +1014,25 @@ static inline int ssi_buffer_mgr_prepare_aead_data_mlli(
 	} else if (direct == DRV_CRYPTO_DIRECTION_DECRYPT) {
 		/*NON-INPLACE and DECRYPT*/
 		ssi_buffer_mgr_add_scatterlist_entry(sg_data,
-			areq_ctx->src.nents, areq_ctx->srcSgl,
-			areq_ctx->cryptlen, areq_ctx->srcOffset, is_last_table,
-			&areq_ctx->src.mlli_nents);
+						     areq_ctx->src.nents,
+						     areq_ctx->srcSgl,
+						     areq_ctx->cryptlen,
+						     areq_ctx->srcOffset,
+						     is_last_table,
+						     &areq_ctx->src.mlli_nents);
 		ssi_buffer_mgr_add_scatterlist_entry(sg_data,
-			areq_ctx->dst.nents, areq_ctx->dstSgl,
-			areq_ctx->cryptlen, areq_ctx->dstOffset, is_last_table,
-			&areq_ctx->dst.mlli_nents);
+						     areq_ctx->dst.nents,
+						     areq_ctx->dstSgl,
+						     areq_ctx->cryptlen,
+						     areq_ctx->dstOffset,
+						     is_last_table,
+						     &areq_ctx->dst.mlli_nents);
 
 		icv_nents = ssi_buffer_mgr_get_aead_icv_nents(areq_ctx->srcSgl,
-			areq_ctx->src.nents, authsize, *src_last_bytes,
-			&areq_ctx->is_icv_fragmented);
+							      areq_ctx->src.nents,
+							      authsize,
+							      *src_last_bytes,
+							      &areq_ctx->is_icv_fragmented);
 		if (unlikely(icv_nents < 0)) {
 			rc = -ENOTSUPP;
 			goto prepare_data_mlli_exit;
@@ -1049,16 +1066,24 @@ static inline int ssi_buffer_mgr_prepare_aead_data_mlli(
 	} else {
 		/*NON-INPLACE and ENCRYPT*/
 		ssi_buffer_mgr_add_scatterlist_entry(sg_data,
-			areq_ctx->dst.nents, areq_ctx->dstSgl,
-			areq_ctx->cryptlen, areq_ctx->dstOffset, is_last_table,
-			&areq_ctx->dst.mlli_nents);
+						     areq_ctx->dst.nents,
+						     areq_ctx->dstSgl,
+						     areq_ctx->cryptlen,
+						     areq_ctx->dstOffset,
+						     is_last_table,
+						     &areq_ctx->dst.mlli_nents);
 		ssi_buffer_mgr_add_scatterlist_entry(sg_data,
-			areq_ctx->src.nents, areq_ctx->srcSgl,
-			areq_ctx->cryptlen, areq_ctx->srcOffset, is_last_table,
-			&areq_ctx->src.mlli_nents);
+						     areq_ctx->src.nents,
+						     areq_ctx->srcSgl,
+						     areq_ctx->cryptlen,
+						     areq_ctx->srcOffset,
+						     is_last_table,
+						     &areq_ctx->src.mlli_nents);
 
 		icv_nents = ssi_buffer_mgr_get_aead_icv_nents(areq_ctx->dstSgl,
-			areq_ctx->dst.nents, authsize, *dst_last_bytes,
+							      areq_ctx->dst.nents,
+							      authsize,
+							      *dst_last_bytes,
 			&areq_ctx->is_icv_fragmented);
 		if (unlikely(icv_nents < 0)) {
 			rc = -ENOTSUPP;
@@ -1137,7 +1162,7 @@ static inline int ssi_buffer_mgr_aead_chain_data(
 	if (unlikely(src_mapped_nents > LLI_MAX_NUM_OF_DATA_ENTRIES))
 	{
 		SSI_LOG_ERR("Too many fragments. current %d max %d\n",
-				src_mapped_nents, LLI_MAX_NUM_OF_DATA_ENTRIES);
+			    src_mapped_nents, LLI_MAX_NUM_OF_DATA_ENTRIES);
 			return -ENOMEM;
 	}
 
@@ -1152,9 +1177,11 @@ static inline int ssi_buffer_mgr_aead_chain_data(
 			size_for_map += crypto_aead_ivsize(tfm);
 
 		rc = ssi_buffer_mgr_map_scatterlist(dev, req->dst, size_for_map,
-			 DMA_BIDIRECTIONAL, &(areq_ctx->dst.nents),
-			 LLI_MAX_NUM_OF_DATA_ENTRIES, &dst_last_bytes,
-						   &dst_mapped_nents);
+						    DMA_BIDIRECTIONAL,
+						    &(areq_ctx->dst.nents),
+						    LLI_MAX_NUM_OF_DATA_ENTRIES,
+						    &dst_last_bytes,
+						    &dst_mapped_nents);
 		if (unlikely(rc != 0)) {
 			rc = -ENOMEM;
 			goto chain_data_exit;
@@ -1189,8 +1216,11 @@ static inline int ssi_buffer_mgr_aead_chain_data(
 	    (dst_mapped_nents  > 1) ||
 	    do_chain) {
 		areq_ctx->data_buff_type = SSI_DMA_BUF_MLLI;
-		rc = ssi_buffer_mgr_prepare_aead_data_mlli(drvdata, req, sg_data,
-			&src_last_bytes, &dst_last_bytes, is_last_table);
+		rc = ssi_buffer_mgr_prepare_aead_data_mlli(drvdata, req,
+							   sg_data,
+							   &src_last_bytes,
+							   &dst_last_bytes,
+							   is_last_table);
 	} else {
 		areq_ctx->data_buff_type = SSI_DMA_BUF_DLLI;
 		ssi_buffer_mgr_prepare_aead_data_dlli(
@@ -1202,7 +1232,7 @@ static inline int ssi_buffer_mgr_aead_chain_data(
 }
 
 static void ssi_buffer_mgr_update_aead_mlli_nents(struct ssi_drvdata *drvdata,
-					   struct aead_request *req)
+						  struct aead_request *req)
 {
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	u32 curr_mlli_size = 0;
@@ -1300,7 +1330,7 @@ int ssi_buffer_mgr_map_aead_request(
 		areq_ctx->mac_buf, MAX_MAC_SIZE, DMA_BIDIRECTIONAL);
 	if (unlikely(dma_mapping_error(dev, areq_ctx->mac_buf_dma_addr))) {
 		SSI_LOG_ERR("Mapping mac_buf %u B at va=%pK for DMA failed\n",
-			MAX_MAC_SIZE, areq_ctx->mac_buf);
+			    MAX_MAC_SIZE, areq_ctx->mac_buf);
 		rc = -ENOMEM;
 		goto aead_map_failure;
 	}
@@ -1319,7 +1349,8 @@ int ssi_buffer_mgr_map_aead_request(
 			goto aead_map_failure;
 		}
 		if (ssi_aead_handle_config_buf(dev, areq_ctx,
-			areq_ctx->ccm_config, &sg_data, req->assoclen) != 0) {
+					       areq_ctx->ccm_config, &sg_data,
+					       req->assoclen) != 0) {
 			rc = -ENOMEM;
 			goto aead_map_failure;
 		}
@@ -1331,7 +1362,7 @@ int ssi_buffer_mgr_map_aead_request(
 			areq_ctx->hkey, AES_BLOCK_SIZE, DMA_BIDIRECTIONAL);
 		if (unlikely(dma_mapping_error(dev, areq_ctx->hkey_dma_addr))) {
 			SSI_LOG_ERR("Mapping hkey %u B at va=%pK for DMA failed\n",
-				AES_BLOCK_SIZE, areq_ctx->hkey);
+				    AES_BLOCK_SIZE, areq_ctx->hkey);
 			rc = -ENOMEM;
 			goto aead_map_failure;
 		}
@@ -1340,7 +1371,7 @@ int ssi_buffer_mgr_map_aead_request(
 			&areq_ctx->gcm_len_block, AES_BLOCK_SIZE, DMA_TO_DEVICE);
 		if (unlikely(dma_mapping_error(dev, areq_ctx->gcm_block_len_dma_addr))) {
 			SSI_LOG_ERR("Mapping gcm_len_block %u B at va=%pK for DMA failed\n",
-				AES_BLOCK_SIZE, &areq_ctx->gcm_len_block);
+				    AES_BLOCK_SIZE, &areq_ctx->gcm_len_block);
 			rc = -ENOMEM;
 			goto aead_map_failure;
 		}
@@ -1491,18 +1522,18 @@ int ssi_buffer_mgr_map_hash_request_final(
 	/* map the previous buffer */
 	if (*curr_buff_cnt != 0) {
 		if (ssi_ahash_handle_curr_buf(dev, areq_ctx, curr_buff,
-					    *curr_buff_cnt, &sg_data) != 0) {
+					      *curr_buff_cnt, &sg_data) != 0) {
 			return -ENOMEM;
 		}
 	}
 
 	if (src && (nbytes > 0) && do_update) {
-		if (unlikely(ssi_buffer_mgr_map_scatterlist(dev, src,
-					  nbytes,
-					  DMA_TO_DEVICE,
-					  &areq_ctx->in_nents,
-					  LLI_MAX_NUM_OF_DATA_ENTRIES,
-					  &dummy, &mapped_nents))){
+		if (unlikely(ssi_buffer_mgr_map_scatterlist(dev, src, nbytes,
+							    DMA_TO_DEVICE,
+							    &areq_ctx->in_nents,
+							    LLI_MAX_NUM_OF_DATA_ENTRIES,
+							    &dummy,
+							    &mapped_nents))){
 			goto unmap_curr_buff;
 		}
 		if (src && (mapped_nents == 1)
@@ -1522,19 +1553,18 @@ int ssi_buffer_mgr_map_hash_request_final(
 		mlli_params->curr_pool = buff_mgr->mlli_buffs_pool;
 		/* add the src data to the sg_data */
 		ssi_buffer_mgr_add_scatterlist_entry(&sg_data,
-					areq_ctx->in_nents,
-					src,
-					nbytes, 0,
-					true, &areq_ctx->mlli_nents);
+						     areq_ctx->in_nents,
+						     src, nbytes, 0, true,
+						     &areq_ctx->mlli_nents);
 		if (unlikely(ssi_buffer_mgr_generate_mlli(dev, &sg_data,
-						  mlli_params) != 0)) {
+							  mlli_params) != 0)) {
 			goto fail_unmap_din;
 		}
 	}
 	/* change the buffer index for the unmap function */
 	areq_ctx->buff_index = (areq_ctx->buff_index ^ 1);
 	SSI_LOG_DEBUG("areq_ctx->data_dma_buf_type = %s\n",
-		GET_DMA_BUFFER_TYPE(areq_ctx->data_dma_buf_type));
+		      GET_DMA_BUFFER_TYPE(areq_ctx->data_dma_buf_type));
 	return 0;
 
 fail_unmap_din:
@@ -1588,8 +1618,8 @@ int ssi_buffer_mgr_map_hash_request_update(
 			&curr_buff[*curr_buff_cnt]);
 		areq_ctx->in_nents =
 			ssi_buffer_mgr_get_sgl_nents(src,
-						    nbytes,
-						    &dummy, NULL);
+						     nbytes,
+						     &dummy, NULL);
 		sg_copy_to_buffer(src, areq_ctx->in_nents,
 				  &curr_buff[*curr_buff_cnt], nbytes);
 		*curr_buff_cnt += nbytes;
@@ -1612,15 +1642,15 @@ int ssi_buffer_mgr_map_hash_request_update(
 			     (update_data_len - *curr_buff_cnt),
 			     *next_buff_cnt);
 		ssi_buffer_mgr_copy_scatterlist_portion(next_buff, src,
-			     (update_data_len - *curr_buff_cnt),
-			     nbytes, SSI_SG_TO_BUF);
+							(update_data_len - *curr_buff_cnt),
+							nbytes, SSI_SG_TO_BUF);
 		/* change the buffer index for next operation */
 		swap_index = 1;
 	}
 
 	if (*curr_buff_cnt != 0) {
 		if (ssi_ahash_handle_curr_buf(dev, areq_ctx, curr_buff,
-					    *curr_buff_cnt, &sg_data) != 0) {
+					      *curr_buff_cnt, &sg_data) != 0) {
 			return -ENOMEM;
 		}
 		/* change the buffer index for next operation */
@@ -1629,11 +1659,12 @@ int ssi_buffer_mgr_map_hash_request_update(
 
 	if (update_data_len > *curr_buff_cnt) {
 		if (unlikely(ssi_buffer_mgr_map_scatterlist(dev, src,
-					  (update_data_len - *curr_buff_cnt),
-					  DMA_TO_DEVICE,
-					  &areq_ctx->in_nents,
-					  LLI_MAX_NUM_OF_DATA_ENTRIES,
-					  &dummy, &mapped_nents))){
+							    (update_data_len - *curr_buff_cnt),
+							    DMA_TO_DEVICE,
+							    &areq_ctx->in_nents,
+							    LLI_MAX_NUM_OF_DATA_ENTRIES,
+							    &dummy,
+							    &mapped_nents))){
 			goto unmap_curr_buff;
 		}
 		if ((mapped_nents == 1)
@@ -1653,12 +1684,14 @@ int ssi_buffer_mgr_map_hash_request_update(
 		mlli_params->curr_pool = buff_mgr->mlli_buffs_pool;
 		/* add the src data to the sg_data */
 		ssi_buffer_mgr_add_scatterlist_entry(&sg_data,
-					areq_ctx->in_nents,
-					src,
-					(update_data_len - *curr_buff_cnt), 0,
-					true, &areq_ctx->mlli_nents);
+						     areq_ctx->in_nents,
+						     src,
+						     (update_data_len - *curr_buff_cnt),
+						     0,
+						     true,
+						     &areq_ctx->mlli_nents);
 		if (unlikely(ssi_buffer_mgr_generate_mlli(dev, &sg_data,
-						  mlli_params) != 0)) {
+							  mlli_params) != 0)) {
 			goto fail_unmap_din;
 		}
 	}
@@ -1688,8 +1721,8 @@ void ssi_buffer_mgr_unmap_hash_request(
 	 */
 	if (areq_ctx->mlli_params.curr_pool) {
 		SSI_LOG_DEBUG("free MLLI buffer: dma=0x%llX virt=%pK\n",
-			     (unsigned long long)areq_ctx->mlli_params.mlli_dma_addr,
-			     areq_ctx->mlli_params.mlli_virt_addr);
+			      (unsigned long long)areq_ctx->mlli_params.mlli_dma_addr,
+			      areq_ctx->mlli_params.mlli_virt_addr);
 		dma_pool_free(areq_ctx->mlli_params.curr_pool,
 			      areq_ctx->mlli_params.mlli_virt_addr,
 			      areq_ctx->mlli_params.mlli_dma_addr);
@@ -1697,9 +1730,9 @@ void ssi_buffer_mgr_unmap_hash_request(
 
 	if ((src) && likely(areq_ctx->in_nents != 0)) {
 		SSI_LOG_DEBUG("Unmapped sg src: virt=%pK dma=0x%llX len=0x%X\n",
-			     sg_virt(src),
-			     (unsigned long long)sg_dma_address(src),
-			     sg_dma_len(src));
+			      sg_virt(src),
+			      (unsigned long long)sg_dma_address(src),
+			      sg_dma_len(src));
 		dma_unmap_sg(dev, src,
 			     areq_ctx->in_nents, DMA_TO_DEVICE);
 	}
-- 
2.11.0
