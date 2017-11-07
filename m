From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 2/8] staging: ccree: use more readable func names
Date: Tue,  7 Nov 2017 09:39:58 +0000
Message-ID: <1510047606-5589-3-git-send-email-gilad@benyossef.com>
References: <1510047606-5589-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1510047606-5589-1-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

The driver was using a function naming scheme
including common prefixes for driver global
functions based on the code module they came from.

The combination of long names with long common
prefixes made the whole thing hard for a human
to parse.

Make the semantic change of switching to simple
function naming scheme and shorten function
name for better readabilty.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c        |  32 +--
 drivers/staging/ccree/ssi_buffer_mgr.c  | 430 ++++++++++++++------------------
 drivers/staging/ccree/ssi_buffer_mgr.h  |  49 ++--
 drivers/staging/ccree/ssi_cipher.c      |  13 +-
 drivers/staging/ccree/ssi_driver.c      |  18 +-
 drivers/staging/ccree/ssi_hash.c        | 116 +++++----
 drivers/staging/ccree/ssi_ivgen.c       |   2 +-
 drivers/staging/ccree/ssi_pm.c          |  26 +-
 drivers/staging/ccree/ssi_pm.h          |  12 +-
 drivers/staging/ccree/ssi_request_mgr.c |  16 +-
 drivers/staging/ccree/ssi_request_mgr.h |   6 +-
 drivers/staging/ccree/ssi_sram_mgr.c    |  11 +-
 drivers/staging/ccree/ssi_sram_mgr.h    |   6 +-
 13 files changed, 345 insertions(+), 392 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index ba0954e..0b5b230 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -233,7 +233,7 @@ static void ssi_aead_complete(struct device *dev, void *ssi_req, void __iomem *c
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	int err = 0;
 
-	ssi_buffer_mgr_unmap_aead_request(dev, areq);
+	cc_unmap_aead_request(dev, areq);
 
 	/* Restore ordinary iv pointer */
 	areq->iv = areq_ctx->backup_iv;
@@ -246,17 +246,20 @@ static void ssi_aead_complete(struct device *dev, void *ssi_req, void __iomem *c
 			/* In case of payload authentication failure, MUST NOT
 			 * revealed the decrypted message --> zero its memory.
 			 */
-			ssi_buffer_mgr_zero_sgl(areq->dst, areq_ctx->cryptlen);
+			cc_zero_sgl(areq->dst, areq_ctx->cryptlen);
 			err = -EBADMSG;
 		}
 	} else { /*ENCRYPT*/
-		if (unlikely(areq_ctx->is_icv_fragmented))
-			ssi_buffer_mgr_copy_scatterlist_portion(
-				dev, areq_ctx->mac_buf, areq_ctx->dst_sgl,
-				areq->cryptlen + areq_ctx->dst_offset,
-				(areq->cryptlen + areq_ctx->dst_offset +
-				 ctx->authsize),
-				SSI_SG_FROM_BUF);
+		if (unlikely(areq_ctx->is_icv_fragmented)) {
+			cc_copy_sg_portion(dev, areq_ctx->mac_buf,
+					   areq_ctx->dst_sgl,
+					   (areq->cryptlen +
+					    areq_ctx->dst_offset),
+					   (areq->cryptlen +
+					    areq_ctx->dst_offset +
+					    ctx->authsize),
+					   SSI_SG_FROM_BUF);
+		}
 
 		/* If an IV was generated, copy it back to the user provided buffer. */
 		if (areq_ctx->backup_giv) {
@@ -2053,7 +2056,7 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 	}
 #endif /*SSI_CC_HAS_AES_GCM*/
 
-	rc = ssi_buffer_mgr_map_aead_request(ctx->drvdata, req);
+	rc = cc_map_aead_request(ctx->drvdata, req);
 	if (unlikely(rc != 0)) {
 		dev_err(dev, "map_request() failed\n");
 		goto exit;
@@ -2112,7 +2115,7 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 #endif
 	default:
 		dev_err(dev, "Unsupported authenc (%d)\n", ctx->auth_mode);
-		ssi_buffer_mgr_unmap_aead_request(dev, req);
+		cc_unmap_aead_request(dev, req);
 		rc = -ENOTSUPP;
 		goto exit;
 	}
@@ -2123,7 +2126,7 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 
 	if (unlikely(rc != -EINPROGRESS)) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
-		ssi_buffer_mgr_unmap_aead_request(dev, req);
+		cc_unmap_aead_request(dev, req);
 	}
 
 exit:
@@ -2753,8 +2756,9 @@ int ssi_aead_alloc(struct ssi_drvdata *drvdata)
 	INIT_LIST_HEAD(&aead_handle->aead_list);
 	drvdata->aead_handle = aead_handle;
 
-	aead_handle->sram_workspace_addr = ssi_sram_mgr_alloc(
-		drvdata, MAX_HMAC_DIGEST_SIZE);
+	aead_handle->sram_workspace_addr = cc_sram_alloc(drvdata,
+							 MAX_HMAC_DIGEST_SIZE);
+
 	if (aead_handle->sram_workspace_addr == NULL_SRAM_ADDR) {
 		dev_err(dev, "SRAM pool exhausted\n");
 		rc = -ENOMEM;
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 1f8a225..2d971f2 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -65,13 +65,13 @@ struct buffer_array {
 };
 
 /**
- * ssi_buffer_mgr_get_sgl_nents() - Get scatterlist number of entries.
+ * cc_get_sgl_nents() - Get scatterlist number of entries.
  *
  * @sg_list: SG list
  * @nbytes: [IN] Total SGL data bytes.
  * @lbytes: [OUT] Returns the amount of bytes at the last entry
  */
-static unsigned int ssi_buffer_mgr_get_sgl_nents(
+static unsigned int cc_get_sgl_nents(
 	struct device *dev, struct scatterlist *sg_list,
 	unsigned int nbytes, u32 *lbytes, bool *is_chained)
 {
@@ -95,11 +95,11 @@ static unsigned int ssi_buffer_mgr_get_sgl_nents(
 }
 
 /**
- * ssi_buffer_mgr_zero_sgl() - Zero scatter scatter list data.
+ * cc_zero_sgl() - Zero scatter scatter list data.
  *
  * @sgl:
  */
-void ssi_buffer_mgr_zero_sgl(struct scatterlist *sgl, u32 data_len)
+void cc_zero_sgl(struct scatterlist *sgl, u32 data_len)
 {
 	struct scatterlist *current_sg = sgl;
 	int sg_index = 0;
@@ -116,7 +116,7 @@ void ssi_buffer_mgr_zero_sgl(struct scatterlist *sgl, u32 data_len)
 }
 
 /**
- * ssi_buffer_mgr_copy_scatterlist_portion() - Copy scatter list data,
+ * cc_copy_sg_portion() - Copy scatter list data,
  * from to_skip to end, to dest and vice versa
  *
  * @dest:
@@ -125,19 +125,19 @@ void ssi_buffer_mgr_zero_sgl(struct scatterlist *sgl, u32 data_len)
  * @end:
  * @direct:
  */
-void ssi_buffer_mgr_copy_scatterlist_portion(
+void cc_copy_sg_portion(
 	struct device *dev, u8 *dest,
 	struct scatterlist *sg, u32 to_skip,
 	u32 end, enum ssi_sg_cpy_direct direct)
 {
 	u32 nents, lbytes;
 
-	nents = ssi_buffer_mgr_get_sgl_nents(dev, sg, end, &lbytes, NULL);
+	nents = cc_get_sgl_nents(dev, sg, end, &lbytes, NULL);
 	sg_copy_buffer(sg, nents, (void *)dest, (end - to_skip + 1), to_skip,
 		       (direct == SSI_SG_TO_BUF));
 }
 
-static inline int ssi_buffer_mgr_render_buff_to_mlli(
+static inline int cc_render_buff_to_mlli(
 	struct device *dev, dma_addr_t buff_dma, u32 buff_size,
 	u32 *curr_nents, u32 **mlli_entry_pp)
 {
@@ -173,7 +173,7 @@ static inline int ssi_buffer_mgr_render_buff_to_mlli(
 	return 0;
 }
 
-static inline int ssi_buffer_mgr_render_scatterlist_to_mlli(
+static inline int cc_render_sg_to_mlli(
 	struct device *dev, struct scatterlist *sgl,
 	u32 sgl_data_len, u32 sgl_offset, u32 *curr_nents,
 	u32 **mlli_entry_pp)
@@ -189,9 +189,9 @@ static inline int ssi_buffer_mgr_render_scatterlist_to_mlli(
 				sg_dma_len(curr_sgl) - sgl_offset :
 				sgl_data_len;
 		sgl_data_len -= entry_data_len;
-		rc = ssi_buffer_mgr_render_buff_to_mlli(
-			dev, sg_dma_address(curr_sgl) + sgl_offset,
-			entry_data_len, curr_nents, &mlli_entry_p);
+		rc = cc_render_buff_to_mlli(dev, sg_dma_address(curr_sgl) +
+					    sgl_offset, entry_data_len,
+					    curr_nents, &mlli_entry_p);
 		if (rc != 0)
 			return rc;
 
@@ -201,7 +201,7 @@ static inline int ssi_buffer_mgr_render_scatterlist_to_mlli(
 	return 0;
 }
 
-static int ssi_buffer_mgr_generate_mlli(
+static int cc_generate_mlli(
 	struct device *dev,
 	struct buffer_array *sg_data,
 	struct mlli_params *mlli_params)
@@ -226,15 +226,15 @@ static int ssi_buffer_mgr_generate_mlli(
 	/* go over all SG's and link it to one MLLI table */
 	for (i = 0; i < sg_data->num_of_buffers; i++) {
 		if (sg_data->type[i] == DMA_SGL_TYPE)
-			rc = ssi_buffer_mgr_render_scatterlist_to_mlli(
-				dev, sg_data->entry[i].sgl,
-				sg_data->total_data_len[i], sg_data->offset[i],
-				&total_nents, &mlli_p);
+			rc = cc_render_sg_to_mlli(dev, sg_data->entry[i].sgl,
+						  sg_data->total_data_len[i],
+						  sg_data->offset[i],
+						  &total_nents, &mlli_p);
 		else /*DMA_BUFF_TYPE*/
-			rc = ssi_buffer_mgr_render_buff_to_mlli(
-				dev, sg_data->entry[i].buffer_dma,
-				sg_data->total_data_len[i], &total_nents,
-				&mlli_p);
+			rc = cc_render_buff_to_mlli(dev,
+						    sg_data->entry[i].buffer_dma,
+						    sg_data->total_data_len[i],
+						    &total_nents, &mlli_p);
 		if (rc != 0)
 			return rc;
 
@@ -260,7 +260,7 @@ static int ssi_buffer_mgr_generate_mlli(
 	return rc;
 }
 
-static inline void ssi_buffer_mgr_add_buffer_entry(
+static inline void cc_add_buffer_entry(
 	struct device *dev, struct buffer_array *sgl_data,
 	dma_addr_t buffer_dma, unsigned int buffer_len,
 	bool is_last_entry, u32 *mlli_nents)
@@ -281,7 +281,7 @@ static inline void ssi_buffer_mgr_add_buffer_entry(
 	sgl_data->num_of_buffers++;
 }
 
-static inline void ssi_buffer_mgr_add_scatterlist_entry(
+static inline void cc_add_sg_entry(
 	struct device *dev,
 	struct buffer_array *sgl_data,
 	unsigned int nents,
@@ -308,8 +308,8 @@ static inline void ssi_buffer_mgr_add_scatterlist_entry(
 }
 
 static int
-ssi_buffer_mgr_dma_map_sg(struct device *dev, struct scatterlist *sg, u32 nents,
-			  enum dma_data_direction direction)
+cc_dma_map_sg(struct device *dev, struct scatterlist *sg, u32 nents,
+	      enum dma_data_direction direction)
 {
 	u32 i, j;
 	struct scatterlist *l_sg = sg;
@@ -336,7 +336,7 @@ ssi_buffer_mgr_dma_map_sg(struct device *dev, struct scatterlist *sg, u32 nents,
 	return 0;
 }
 
-static int ssi_buffer_mgr_map_scatterlist(
+static int cc_map_sg(
 	struct device *dev, struct scatterlist *sg,
 	unsigned int nbytes, int direction,
 	u32 *nents, u32 max_sg_nents,
@@ -357,8 +357,8 @@ static int ssi_buffer_mgr_map_scatterlist(
 		*nents = 1;
 		*mapped_nents = 1;
 	} else {  /*sg_is_last*/
-		*nents = ssi_buffer_mgr_get_sgl_nents(dev, sg, nbytes, lbytes,
-						      &is_chained);
+		*nents = cc_get_sgl_nents(dev, sg, nbytes, lbytes,
+					  &is_chained);
 		if (*nents > max_sg_nents) {
 			*nents = 0;
 			dev_err(dev, "Too many fragments. current %d max %d\n",
@@ -379,10 +379,8 @@ static int ssi_buffer_mgr_map_scatterlist(
 			/*In this case the driver maps entry by entry so it
 			 * must have the same nents before and after map
 			 */
-			*mapped_nents = ssi_buffer_mgr_dma_map_sg(dev,
-								  sg,
-								  *nents,
-								  direction);
+			*mapped_nents = cc_dma_map_sg(dev, sg, *nents,
+						      direction);
 			if (unlikely(*mapped_nents != *nents)) {
 				*nents = *mapped_nents;
 				dev_err(dev, "dma_map_sg() sg buffer failed\n");
@@ -416,10 +414,9 @@ ssi_aead_handle_config_buf(struct device *dev,
 		areq_ctx->ccm_adata_sg.offset, areq_ctx->ccm_adata_sg.length);
 	/* prepare for case of MLLI */
 	if (assoclen > 0) {
-		ssi_buffer_mgr_add_scatterlist_entry(dev, sg_data, 1,
-						     &areq_ctx->ccm_adata_sg,
-						     (AES_BLOCK_SIZE + areq_ctx->ccm_hdr_size),
-						     0, false, NULL);
+		cc_add_sg_entry(dev, sg_data, 1, &areq_ctx->ccm_adata_sg,
+				(AES_BLOCK_SIZE + areq_ctx->ccm_hdr_size),
+				0, false, NULL);
 	}
 	return 0;
 }
@@ -446,12 +443,12 @@ static inline int ssi_ahash_handle_curr_buf(struct device *dev,
 	areq_ctx->curr_sg = areq_ctx->buff_sg;
 	areq_ctx->in_nents = 0;
 	/* prepare for case of MLLI */
-	ssi_buffer_mgr_add_scatterlist_entry(dev, sg_data, 1, areq_ctx->buff_sg,
-					     curr_buff_cnt, 0, false, NULL);
+	cc_add_sg_entry(dev, sg_data, 1, areq_ctx->buff_sg, curr_buff_cnt, 0,
+			false, NULL);
 	return 0;
 }
 
-void ssi_buffer_mgr_unmap_blkcipher_request(
+void cc_unmap_blkcipher_request(
 	struct device *dev,
 	void *ctx,
 	unsigned int ivsize,
@@ -484,7 +481,7 @@ void ssi_buffer_mgr_unmap_blkcipher_request(
 	}
 }
 
-int ssi_buffer_mgr_map_blkcipher_request(
+int cc_map_blkcipher_request(
 	struct ssi_drvdata *drvdata,
 	void *ctx,
 	unsigned int ivsize,
@@ -527,11 +524,8 @@ int ssi_buffer_mgr_map_blkcipher_request(
 	}
 
 	/* Map the src SGL */
-	rc = ssi_buffer_mgr_map_scatterlist(dev, src,
-					    nbytes, DMA_BIDIRECTIONAL,
-					    &req_ctx->in_nents,
-					    LLI_MAX_NUM_OF_DATA_ENTRIES, &dummy,
-					    &mapped_nents);
+	rc = cc_map_sg(dev, src, nbytes, DMA_BIDIRECTIONAL, &req_ctx->in_nents,
+		       LLI_MAX_NUM_OF_DATA_ENTRIES, &dummy, &mapped_nents);
 	if (unlikely(rc != 0)) {
 		rc = -ENOMEM;
 		goto ablkcipher_exit;
@@ -543,19 +537,16 @@ int ssi_buffer_mgr_map_blkcipher_request(
 		/* Handle inplace operation */
 		if (unlikely(req_ctx->dma_buf_type == SSI_DMA_BUF_MLLI)) {
 			req_ctx->out_nents = 0;
-			ssi_buffer_mgr_add_scatterlist_entry(dev, &sg_data,
-							     req_ctx->in_nents,
-							     src, nbytes, 0,
-							     true,
-							     &req_ctx->in_mlli_nents);
+			cc_add_sg_entry(dev, &sg_data, req_ctx->in_nents, src,
+					nbytes, 0, true,
+					&req_ctx->in_mlli_nents);
 		}
 	} else {
 		/* Map the dst sg */
-		if (unlikely(ssi_buffer_mgr_map_scatterlist(
-			dev, dst, nbytes,
-			DMA_BIDIRECTIONAL, &req_ctx->out_nents,
-			LLI_MAX_NUM_OF_DATA_ENTRIES, &dummy,
-			&mapped_nents))){
+		if (unlikely(cc_map_sg(dev, dst, nbytes, DMA_BIDIRECTIONAL,
+				       &req_ctx->out_nents,
+				       LLI_MAX_NUM_OF_DATA_ENTRIES, &dummy,
+				       &mapped_nents))) {
 			rc = -ENOMEM;
 			goto ablkcipher_exit;
 		}
@@ -563,22 +554,18 @@ int ssi_buffer_mgr_map_blkcipher_request(
 			req_ctx->dma_buf_type = SSI_DMA_BUF_MLLI;
 
 		if (unlikely((req_ctx->dma_buf_type == SSI_DMA_BUF_MLLI))) {
-			ssi_buffer_mgr_add_scatterlist_entry(dev, &sg_data,
-							     req_ctx->in_nents,
-							     src, nbytes, 0,
-							     true,
-							     &req_ctx->in_mlli_nents);
-			ssi_buffer_mgr_add_scatterlist_entry(dev, &sg_data,
-							     req_ctx->out_nents,
-							     dst, nbytes, 0,
-							     true,
-							     &req_ctx->out_mlli_nents);
+			cc_add_sg_entry(dev, &sg_data, req_ctx->in_nents, src,
+					nbytes, 0, true,
+					&req_ctx->in_mlli_nents);
+			cc_add_sg_entry(dev, &sg_data, req_ctx->out_nents, dst,
+					nbytes, 0, true,
+					&req_ctx->out_mlli_nents);
 		}
 	}
 
 	if (unlikely(req_ctx->dma_buf_type == SSI_DMA_BUF_MLLI)) {
 		mlli_params->curr_pool = buff_mgr->mlli_buffs_pool;
-		rc = ssi_buffer_mgr_generate_mlli(dev, &sg_data, mlli_params);
+		rc = cc_generate_mlli(dev, &sg_data, mlli_params);
 		if (unlikely(rc != 0))
 			goto ablkcipher_exit;
 	}
@@ -589,12 +576,11 @@ int ssi_buffer_mgr_map_blkcipher_request(
 	return 0;
 
 ablkcipher_exit:
-	ssi_buffer_mgr_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
+	cc_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
 	return rc;
 }
 
-void ssi_buffer_mgr_unmap_aead_request(
-	struct device *dev, struct aead_request *req)
+void cc_unmap_aead_request(struct device *dev, struct aead_request *req)
 {
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	unsigned int hw_iv_size = areq_ctx->hw_iv_size;
@@ -668,16 +654,15 @@ void ssi_buffer_mgr_unmap_aead_request(
 		size_to_unmap += crypto_aead_ivsize(tfm);
 
 	dma_unmap_sg(dev, req->src,
-		     ssi_buffer_mgr_get_sgl_nents(dev, req->src, size_to_unmap,
-						  &dummy, &chained),
+		     cc_get_sgl_nents(dev, req->src, size_to_unmap,
+				      &dummy, &chained),
 		     DMA_BIDIRECTIONAL);
 	if (unlikely(req->src != req->dst)) {
 		dev_dbg(dev, "Unmapping dst sgl: req->dst=%pK\n",
 			sg_virt(req->dst));
 		dma_unmap_sg(dev, req->dst,
-			     ssi_buffer_mgr_get_sgl_nents(dev, req->dst,
-							  size_to_unmap,
-							  &dummy, &chained),
+			     cc_get_sgl_nents(dev, req->dst, size_to_unmap,
+					      &dummy, &chained),
 			     DMA_BIDIRECTIONAL);
 	}
 	if (drvdata->coherent &&
@@ -691,14 +676,15 @@ void ssi_buffer_mgr_unmap_aead_request(
 		/* copy mac to a temporary location to deal with possible
 		 * data memory overriding that caused by cache coherence problem.
 		 */
-		ssi_buffer_mgr_copy_scatterlist_portion(
-			dev, areq_ctx->backup_mac, req->src,
-			size_to_skip + req->cryptlen - areq_ctx->req_authsize,
-			size_to_skip + req->cryptlen, SSI_SG_FROM_BUF);
+		cc_copy_sg_portion(dev, areq_ctx->backup_mac, req->src,
+				   (size_to_skip + req->cryptlen -
+				    areq_ctx->req_authsize),
+				   (size_to_skip + req->cryptlen),
+				   SSI_SG_FROM_BUF);
 	}
 }
 
-static inline int ssi_buffer_mgr_get_aead_icv_nents(
+static inline int cc_get_aead_icv_nents(
 	struct device *dev,
 	struct scatterlist *sgl,
 	unsigned int sgl_nents,
@@ -748,7 +734,7 @@ static inline int ssi_buffer_mgr_get_aead_icv_nents(
 	return nents;
 }
 
-static inline int ssi_buffer_mgr_aead_chain_iv(
+static inline int cc_aead_chain_iv(
 	struct ssi_drvdata *drvdata,
 	struct aead_request *req,
 	struct buffer_array *sg_data,
@@ -780,11 +766,10 @@ static inline int ssi_buffer_mgr_aead_chain_iv(
 		unsigned int iv_size_to_authenc = crypto_aead_ivsize(tfm);
 		unsigned int iv_ofs = GCM_BLOCK_RFC4_IV_OFFSET;
 		/* Chain to given list */
-		ssi_buffer_mgr_add_buffer_entry(
-			dev, sg_data,
-			areq_ctx->gen_ctx.iv_dma_addr + iv_ofs,
-			iv_size_to_authenc, is_last,
-			&areq_ctx->assoc.mlli_nents);
+		cc_add_buffer_entry(dev, sg_data,
+				    (areq_ctx->gen_ctx.iv_dma_addr + iv_ofs),
+				    iv_size_to_authenc, is_last,
+				    &areq_ctx->assoc.mlli_nents);
 		areq_ctx->assoc_buff_type = SSI_DMA_BUF_MLLI;
 	}
 
@@ -792,7 +777,7 @@ static inline int ssi_buffer_mgr_aead_chain_iv(
 	return rc;
 }
 
-static inline int ssi_buffer_mgr_aead_chain_assoc(
+static inline int cc_aead_chain_assoc(
 	struct ssi_drvdata *drvdata,
 	struct aead_request *req,
 	struct buffer_array *sg_data,
@@ -874,10 +859,9 @@ static inline int ssi_buffer_mgr_aead_chain_assoc(
 		dev_dbg(dev, "Chain assoc: buff_type=%s nents=%u\n",
 			GET_DMA_BUFFER_TYPE(areq_ctx->assoc_buff_type),
 			areq_ctx->assoc.nents);
-		ssi_buffer_mgr_add_scatterlist_entry(
-			dev, sg_data, areq_ctx->assoc.nents,
-			req->src, req->assoclen, 0, is_last,
-			&areq_ctx->assoc.mlli_nents);
+		cc_add_sg_entry(dev, sg_data, areq_ctx->assoc.nents, req->src,
+				req->assoclen, 0, is_last,
+				&areq_ctx->assoc.mlli_nents);
 		areq_ctx->assoc_buff_type = SSI_DMA_BUF_MLLI;
 	}
 
@@ -885,7 +869,7 @@ static inline int ssi_buffer_mgr_aead_chain_assoc(
 	return rc;
 }
 
-static inline void ssi_buffer_mgr_prepare_aead_data_dlli(
+static inline void cc_prepare_aead_data_dlli(
 	struct aead_request *req,
 	u32 *src_last_bytes, u32 *dst_last_bytes)
 {
@@ -921,7 +905,7 @@ static inline void ssi_buffer_mgr_prepare_aead_data_dlli(
 	}
 }
 
-static inline int ssi_buffer_mgr_prepare_aead_data_mlli(
+static inline int cc_prepare_aead_data_mlli(
 	struct ssi_drvdata *drvdata,
 	struct aead_request *req,
 	struct buffer_array *sg_data,
@@ -937,20 +921,15 @@ static inline int ssi_buffer_mgr_prepare_aead_data_mlli(
 
 	if (likely(req->src == req->dst)) {
 		/*INPLACE*/
-		ssi_buffer_mgr_add_scatterlist_entry(dev, sg_data,
-						     areq_ctx->src.nents,
-						     areq_ctx->src_sgl,
-						     areq_ctx->cryptlen,
-						     areq_ctx->src_offset,
-						     is_last_table,
-						     &areq_ctx->src.mlli_nents);
-
-		icv_nents = ssi_buffer_mgr_get_aead_icv_nents(dev,
-							      areq_ctx->src_sgl,
-							      areq_ctx->src.nents,
-							      authsize,
-							      *src_last_bytes,
-							      &areq_ctx->is_icv_fragmented);
+		cc_add_sg_entry(dev, sg_data, areq_ctx->src.nents,
+				areq_ctx->src_sgl, areq_ctx->cryptlen,
+				areq_ctx->src_offset, is_last_table,
+				&areq_ctx->src.mlli_nents);
+
+		icv_nents = cc_get_aead_icv_nents(dev, areq_ctx->src_sgl,
+						  areq_ctx->src.nents,
+						  authsize, *src_last_bytes,
+						  &areq_ctx->is_icv_fragmented);
 		if (unlikely(icv_nents < 0)) {
 			rc = -ENOTSUPP;
 			goto prepare_data_mlli_exit;
@@ -973,13 +952,12 @@ static inline int ssi_buffer_mgr_prepare_aead_data_mlli(
 					if (areq_ctx->is_gcm4543)
 						skip += crypto_aead_ivsize(tfm);
 
-					ssi_buffer_mgr_copy_scatterlist_portion(
-						dev, areq_ctx->backup_mac,
-						req->src,
-						(skip + req->cryptlen -
-						 areq_ctx->req_authsize),
-						skip + req->cryptlen,
-						SSI_SG_TO_BUF);
+					cc_copy_sg_portion(dev,
+							   areq_ctx->backup_mac,
+							   req->src,
+							   (skip + req->cryptlen - areq_ctx->req_authsize),
+							   (skip + req->cryptlen),
+							   SSI_SG_TO_BUF);
 				}
 				areq_ctx->icv_virt_addr = areq_ctx->backup_mac;
 			} else {
@@ -998,27 +976,19 @@ static inline int ssi_buffer_mgr_prepare_aead_data_mlli(
 
 	} else if (direct == DRV_CRYPTO_DIRECTION_DECRYPT) {
 		/*NON-INPLACE and DECRYPT*/
-		ssi_buffer_mgr_add_scatterlist_entry(dev, sg_data,
-						     areq_ctx->src.nents,
-						     areq_ctx->src_sgl,
-						     areq_ctx->cryptlen,
-						     areq_ctx->src_offset,
-						     is_last_table,
-						     &areq_ctx->src.mlli_nents);
-		ssi_buffer_mgr_add_scatterlist_entry(dev, sg_data,
-						     areq_ctx->dst.nents,
-						     areq_ctx->dst_sgl,
-						     areq_ctx->cryptlen,
-						     areq_ctx->dst_offset,
-						     is_last_table,
-						     &areq_ctx->dst.mlli_nents);
-
-		icv_nents = ssi_buffer_mgr_get_aead_icv_nents(dev,
-							      areq_ctx->src_sgl,
-							      areq_ctx->src.nents,
-							      authsize,
-							      *src_last_bytes,
-							      &areq_ctx->is_icv_fragmented);
+		cc_add_sg_entry(dev, sg_data, areq_ctx->src.nents,
+				areq_ctx->src_sgl, areq_ctx->cryptlen,
+				areq_ctx->src_offset, is_last_table,
+				&areq_ctx->src.mlli_nents);
+		cc_add_sg_entry(dev, sg_data, areq_ctx->dst.nents,
+				areq_ctx->dst_sgl, areq_ctx->cryptlen,
+				areq_ctx->dst_offset, is_last_table,
+				&areq_ctx->dst.mlli_nents);
+
+		icv_nents = cc_get_aead_icv_nents(dev, areq_ctx->src_sgl,
+						  areq_ctx->src.nents,
+						  authsize, *src_last_bytes,
+						  &areq_ctx->is_icv_fragmented);
 		if (unlikely(icv_nents < 0)) {
 			rc = -ENOTSUPP;
 			goto prepare_data_mlli_exit;
@@ -1034,10 +1004,11 @@ static inline int ssi_buffer_mgr_prepare_aead_data_mlli(
 			if (areq_ctx->is_gcm4543)
 				size_to_skip += crypto_aead_ivsize(tfm);
 
-			ssi_buffer_mgr_copy_scatterlist_portion(
-				dev, areq_ctx->backup_mac, req->src,
-				size_to_skip + req->cryptlen - areq_ctx->req_authsize,
-				size_to_skip + req->cryptlen, SSI_SG_TO_BUF);
+			  cc_copy_sg_portion(dev, areq_ctx->backup_mac,
+					     req->src,
+					     (size_to_skip + req->cryptlen - areq_ctx->req_authsize),
+					     (size_to_skip + req->cryptlen),
+					     SSI_SG_TO_BUF);
 			areq_ctx->icv_virt_addr = areq_ctx->backup_mac;
 		} else { /* Contig. ICV */
 			/*Should hanlde if the sg is not contig.*/
@@ -1051,27 +1022,19 @@ static inline int ssi_buffer_mgr_prepare_aead_data_mlli(
 
 	} else {
 		/*NON-INPLACE and ENCRYPT*/
-		ssi_buffer_mgr_add_scatterlist_entry(dev, sg_data,
-						     areq_ctx->dst.nents,
-						     areq_ctx->dst_sgl,
-						     areq_ctx->cryptlen,
-						     areq_ctx->dst_offset,
-						     is_last_table,
-						     &areq_ctx->dst.mlli_nents);
-		ssi_buffer_mgr_add_scatterlist_entry(dev, sg_data,
-						     areq_ctx->src.nents,
-						     areq_ctx->src_sgl,
-						     areq_ctx->cryptlen,
-						     areq_ctx->src_offset,
-						     is_last_table,
-						     &areq_ctx->src.mlli_nents);
-
-		icv_nents = ssi_buffer_mgr_get_aead_icv_nents(dev,
-							      areq_ctx->dst_sgl,
-							      areq_ctx->dst.nents,
-							      authsize,
-							      *dst_last_bytes,
-			&areq_ctx->is_icv_fragmented);
+		cc_add_sg_entry(dev, sg_data, areq_ctx->dst.nents,
+				areq_ctx->dst_sgl, areq_ctx->cryptlen,
+				areq_ctx->dst_offset, is_last_table,
+				&areq_ctx->dst.mlli_nents);
+		cc_add_sg_entry(dev, sg_data, areq_ctx->src.nents,
+				areq_ctx->src_sgl, areq_ctx->cryptlen,
+				areq_ctx->src_offset, is_last_table,
+				&areq_ctx->src.mlli_nents);
+
+		icv_nents = cc_get_aead_icv_nents(dev, areq_ctx->dst_sgl,
+						  areq_ctx->dst.nents,
+						  authsize, *dst_last_bytes,
+						  &areq_ctx->is_icv_fragmented);
 		if (unlikely(icv_nents < 0)) {
 			rc = -ENOTSUPP;
 			goto prepare_data_mlli_exit;
@@ -1095,7 +1058,7 @@ static inline int ssi_buffer_mgr_prepare_aead_data_mlli(
 	return rc;
 }
 
-static inline int ssi_buffer_mgr_aead_chain_data(
+static inline int cc_aead_chain_data(
 	struct ssi_drvdata *drvdata,
 	struct aead_request *req,
 	struct buffer_array *sg_data,
@@ -1131,10 +1094,8 @@ static inline int ssi_buffer_mgr_aead_chain_data(
 		size_for_map += crypto_aead_ivsize(tfm);
 
 	size_for_map += (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ? authsize : 0;
-	src_mapped_nents = ssi_buffer_mgr_get_sgl_nents(dev, req->src,
-							size_for_map,
-							&src_last_bytes,
-							&chained);
+	src_mapped_nents = cc_get_sgl_nents(dev, req->src, size_for_map,
+					    &src_last_bytes, &chained);
 	sg_index = areq_ctx->src_sgl->length;
 	//check where the data starts
 	while (sg_index <= size_to_skip) {
@@ -1164,22 +1125,18 @@ static inline int ssi_buffer_mgr_aead_chain_data(
 		if (is_gcm4543)
 			size_for_map += crypto_aead_ivsize(tfm);
 
-		rc = ssi_buffer_mgr_map_scatterlist(dev, req->dst, size_for_map,
-						    DMA_BIDIRECTIONAL,
-						    &areq_ctx->dst.nents,
-						    LLI_MAX_NUM_OF_DATA_ENTRIES,
-						    &dst_last_bytes,
-						    &dst_mapped_nents);
+		rc = cc_map_sg(dev, req->dst, size_for_map, DMA_BIDIRECTIONAL,
+			       &areq_ctx->dst.nents,
+			       LLI_MAX_NUM_OF_DATA_ENTRIES, &dst_last_bytes,
+			       &dst_mapped_nents);
 		if (unlikely(rc != 0)) {
 			rc = -ENOMEM;
 			goto chain_data_exit;
 		}
 	}
 
-	dst_mapped_nents = ssi_buffer_mgr_get_sgl_nents(dev, req->dst,
-							size_for_map,
-							&dst_last_bytes,
-							&chained);
+	dst_mapped_nents = cc_get_sgl_nents(dev, req->dst, size_for_map,
+					    &dst_last_bytes, &chained);
 	sg_index = areq_ctx->dst_sgl->length;
 	offset = size_to_skip;
 
@@ -1206,23 +1163,21 @@ static inline int ssi_buffer_mgr_aead_chain_data(
 	    (dst_mapped_nents  > 1) ||
 	    do_chain) {
 		areq_ctx->data_buff_type = SSI_DMA_BUF_MLLI;
-		rc = ssi_buffer_mgr_prepare_aead_data_mlli(drvdata, req,
-							   sg_data,
-							   &src_last_bytes,
-							   &dst_last_bytes,
-							   is_last_table);
+		rc = cc_prepare_aead_data_mlli(drvdata, req, sg_data,
+					       &src_last_bytes,
+					       &dst_last_bytes, is_last_table);
 	} else {
 		areq_ctx->data_buff_type = SSI_DMA_BUF_DLLI;
-		ssi_buffer_mgr_prepare_aead_data_dlli(
-				req, &src_last_bytes, &dst_last_bytes);
+		cc_prepare_aead_data_dlli(req, &src_last_bytes,
+					  &dst_last_bytes);
 	}
 
 chain_data_exit:
 	return rc;
 }
 
-static void ssi_buffer_mgr_update_aead_mlli_nents(struct ssi_drvdata *drvdata,
-						  struct aead_request *req)
+static void cc_update_aead_mlli_nents(struct ssi_drvdata *drvdata,
+				      struct aead_request *req)
 {
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	u32 curr_mlli_size = 0;
@@ -1272,7 +1227,7 @@ static void ssi_buffer_mgr_update_aead_mlli_nents(struct ssi_drvdata *drvdata,
 	}
 }
 
-int ssi_buffer_mgr_map_aead_request(
+int cc_map_aead_request(
 	struct ssi_drvdata *drvdata, struct aead_request *req)
 {
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
@@ -1303,10 +1258,10 @@ int ssi_buffer_mgr_map_aead_request(
 		/* copy mac to a temporary location to deal with possible
 		 * data memory overriding that caused by cache coherence problem.
 		 */
-		ssi_buffer_mgr_copy_scatterlist_portion(
-			dev, areq_ctx->backup_mac, req->src,
-			size_to_skip + req->cryptlen - areq_ctx->req_authsize,
-			size_to_skip + req->cryptlen, SSI_SG_TO_BUF);
+		cc_copy_sg_portion(dev, areq_ctx->backup_mac, req->src,
+				   (size_to_skip + req->cryptlen - areq_ctx->req_authsize),
+				   (size_to_skip + req->cryptlen),
+				   SSI_SG_TO_BUF);
 	}
 
 	/* cacluate the size for cipher remove ICV in decrypt*/
@@ -1406,9 +1361,11 @@ int ssi_buffer_mgr_map_aead_request(
 
 	if (is_gcm4543)
 		size_to_map += crypto_aead_ivsize(tfm);
-	rc = ssi_buffer_mgr_map_scatterlist(dev, req->src,
-					    size_to_map, DMA_BIDIRECTIONAL, &areq_ctx->src.nents,
-					    LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES + LLI_MAX_NUM_OF_DATA_ENTRIES, &dummy, &mapped_nents);
+	rc = cc_map_sg(dev, req->src, size_to_map, DMA_BIDIRECTIONAL,
+		       &areq_ctx->src.nents,
+		       (LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES +
+			LLI_MAX_NUM_OF_DATA_ENTRIES),
+		       &dummy, &mapped_nents);
 	if (unlikely(rc != 0)) {
 		rc = -ENOMEM;
 		goto aead_map_failure;
@@ -1421,13 +1378,13 @@ int ssi_buffer_mgr_map_aead_request(
 		 *   (2) Src/Dst SGLs
 		 *   Note: IV is contg. buffer (not an SGL)
 		 */
-		rc = ssi_buffer_mgr_aead_chain_assoc(drvdata, req, &sg_data, true, false);
+		rc = cc_aead_chain_assoc(drvdata, req, &sg_data, true, false);
 		if (unlikely(rc != 0))
 			goto aead_map_failure;
-		rc = ssi_buffer_mgr_aead_chain_iv(drvdata, req, &sg_data, true, false);
+		rc = cc_aead_chain_iv(drvdata, req, &sg_data, true, false);
 		if (unlikely(rc != 0))
 			goto aead_map_failure;
-		rc = ssi_buffer_mgr_aead_chain_data(drvdata, req, &sg_data, true, false);
+		rc = cc_aead_chain_data(drvdata, req, &sg_data, true, false);
 		if (unlikely(rc != 0))
 			goto aead_map_failure;
 	} else { /* DOUBLE-PASS flow */
@@ -1451,13 +1408,13 @@ int ssi_buffer_mgr_map_aead_request(
 		 *   (3) MLLI for src
 		 *   (4) MLLI for dst
 		 */
-		rc = ssi_buffer_mgr_aead_chain_assoc(drvdata, req, &sg_data, false, true);
+		rc = cc_aead_chain_assoc(drvdata, req, &sg_data, false, true);
 		if (unlikely(rc != 0))
 			goto aead_map_failure;
-		rc = ssi_buffer_mgr_aead_chain_iv(drvdata, req, &sg_data, false, true);
+		rc = cc_aead_chain_iv(drvdata, req, &sg_data, false, true);
 		if (unlikely(rc != 0))
 			goto aead_map_failure;
-		rc = ssi_buffer_mgr_aead_chain_data(drvdata, req, &sg_data, true, true);
+		rc = cc_aead_chain_data(drvdata, req, &sg_data, true, true);
 		if (unlikely(rc != 0))
 			goto aead_map_failure;
 	}
@@ -1467,11 +1424,11 @@ int ssi_buffer_mgr_map_aead_request(
 		(areq_ctx->assoc_buff_type == SSI_DMA_BUF_MLLI) ||
 		(areq_ctx->data_buff_type == SSI_DMA_BUF_MLLI))) {
 		mlli_params->curr_pool = buff_mgr->mlli_buffs_pool;
-		rc = ssi_buffer_mgr_generate_mlli(dev, &sg_data, mlli_params);
+		rc = cc_generate_mlli(dev, &sg_data, mlli_params);
 		if (unlikely(rc != 0))
 			goto aead_map_failure;
 
-		ssi_buffer_mgr_update_aead_mlli_nents(drvdata, req);
+		cc_update_aead_mlli_nents(drvdata, req);
 		dev_dbg(dev, "assoc params mn %d\n",
 			areq_ctx->assoc.mlli_nents);
 		dev_dbg(dev, "src params mn %d\n", areq_ctx->src.mlli_nents);
@@ -1480,12 +1437,13 @@ int ssi_buffer_mgr_map_aead_request(
 	return 0;
 
 aead_map_failure:
-	ssi_buffer_mgr_unmap_aead_request(dev, req);
+	cc_unmap_aead_request(dev, req);
 	return rc;
 }
 
-int ssi_buffer_mgr_map_hash_request_final(
-	struct ssi_drvdata *drvdata, void *ctx, struct scatterlist *src, unsigned int nbytes, bool do_update)
+int cc_map_hash_request_final(struct ssi_drvdata *drvdata, void *ctx,
+			      struct scatterlist *src, unsigned int nbytes,
+			      bool do_update)
 {
 	struct ahash_req_ctx *areq_ctx = (struct ahash_req_ctx *)ctx;
 	struct device *dev = drvdata_to_dev(drvdata);
@@ -1522,12 +1480,10 @@ int ssi_buffer_mgr_map_hash_request_final(
 	}
 
 	if (src && (nbytes > 0) && do_update) {
-		if (unlikely(ssi_buffer_mgr_map_scatterlist(dev, src, nbytes,
-							    DMA_TO_DEVICE,
-							    &areq_ctx->in_nents,
-							    LLI_MAX_NUM_OF_DATA_ENTRIES,
-							    &dummy,
-							    &mapped_nents))){
+		if (unlikely(cc_map_sg(dev, src, nbytes, DMA_TO_DEVICE,
+				       &areq_ctx->in_nents,
+				       LLI_MAX_NUM_OF_DATA_ENTRIES,
+				       &dummy, &mapped_nents))) {
 			goto unmap_curr_buff;
 		}
 		if (src && (mapped_nents == 1)
@@ -1546,12 +1502,9 @@ int ssi_buffer_mgr_map_hash_request_final(
 	if (unlikely(areq_ctx->data_dma_buf_type == SSI_DMA_BUF_MLLI)) {
 		mlli_params->curr_pool = buff_mgr->mlli_buffs_pool;
 		/* add the src data to the sg_data */
-		ssi_buffer_mgr_add_scatterlist_entry(dev, &sg_data,
-						     areq_ctx->in_nents,
-						     src, nbytes, 0, true,
-						     &areq_ctx->mlli_nents);
-		if (unlikely(ssi_buffer_mgr_generate_mlli(dev, &sg_data,
-							  mlli_params) != 0)) {
+		cc_add_sg_entry(dev, &sg_data, areq_ctx->in_nents, src, nbytes,
+				0, true, &areq_ctx->mlli_nents);
+		if (unlikely(cc_generate_mlli(dev, &sg_data, mlli_params) != 0)) {
 			goto fail_unmap_din;
 		}
 	}
@@ -1571,8 +1524,9 @@ int ssi_buffer_mgr_map_hash_request_final(
 	return -ENOMEM;
 }
 
-int ssi_buffer_mgr_map_hash_request_update(
-	struct ssi_drvdata *drvdata, void *ctx, struct scatterlist *src, unsigned int nbytes, unsigned int block_size)
+int cc_map_hash_request_update(struct ssi_drvdata *drvdata, void *ctx,
+			       struct scatterlist *src, unsigned int nbytes,
+			       unsigned int block_size)
 {
 	struct ahash_req_ctx *areq_ctx = (struct ahash_req_ctx *)ctx;
 	struct device *dev = drvdata_to_dev(drvdata);
@@ -1606,8 +1560,7 @@ int ssi_buffer_mgr_map_hash_request_update(
 		dev_dbg(dev, " less than one block: curr_buff=%pK *curr_buff_cnt=0x%X copy_to=%pK\n",
 			curr_buff, *curr_buff_cnt, &curr_buff[*curr_buff_cnt]);
 		areq_ctx->in_nents =
-			ssi_buffer_mgr_get_sgl_nents(dev, src, nbytes, &dummy,
-						     NULL);
+			cc_get_sgl_nents(dev, src, nbytes, &dummy, NULL);
 		sg_copy_to_buffer(src, areq_ctx->in_nents,
 				  &curr_buff[*curr_buff_cnt], nbytes);
 		*curr_buff_cnt += nbytes;
@@ -1627,9 +1580,9 @@ int ssi_buffer_mgr_map_hash_request_update(
 		dev_dbg(dev, " handle residue: next buff %pK skip data %u residue %u\n",
 			next_buff, (update_data_len - *curr_buff_cnt),
 			*next_buff_cnt);
-		ssi_buffer_mgr_copy_scatterlist_portion(dev, next_buff, src,
-							(update_data_len - *curr_buff_cnt),
-							nbytes, SSI_SG_TO_BUF);
+		cc_copy_sg_portion(dev, next_buff, src,
+				   (update_data_len - *curr_buff_cnt),
+				   nbytes, SSI_SG_TO_BUF);
 		/* change the buffer index for next operation */
 		swap_index = 1;
 	}
@@ -1644,13 +1597,11 @@ int ssi_buffer_mgr_map_hash_request_update(
 	}
 
 	if (update_data_len > *curr_buff_cnt) {
-		if (unlikely(ssi_buffer_mgr_map_scatterlist(dev, src,
-							    (update_data_len - *curr_buff_cnt),
-							    DMA_TO_DEVICE,
-							    &areq_ctx->in_nents,
-							    LLI_MAX_NUM_OF_DATA_ENTRIES,
-							    &dummy,
-							    &mapped_nents))){
+		if (unlikely(cc_map_sg(dev, src,
+				       (update_data_len - *curr_buff_cnt),
+				       DMA_TO_DEVICE, &areq_ctx->in_nents,
+				       LLI_MAX_NUM_OF_DATA_ENTRIES, &dummy,
+				       &mapped_nents))) {
 			goto unmap_curr_buff;
 		}
 		if ((mapped_nents == 1)
@@ -1669,15 +1620,10 @@ int ssi_buffer_mgr_map_hash_request_update(
 	if (unlikely(areq_ctx->data_dma_buf_type == SSI_DMA_BUF_MLLI)) {
 		mlli_params->curr_pool = buff_mgr->mlli_buffs_pool;
 		/* add the src data to the sg_data */
-		ssi_buffer_mgr_add_scatterlist_entry(dev, &sg_data,
-						     areq_ctx->in_nents,
-						     src,
-						     (update_data_len - *curr_buff_cnt),
-						     0,
-						     true,
-						     &areq_ctx->mlli_nents);
-		if (unlikely(ssi_buffer_mgr_generate_mlli(dev, &sg_data,
-							  mlli_params) != 0)) {
+		cc_add_sg_entry(dev, &sg_data, areq_ctx->in_nents, src,
+				(update_data_len - *curr_buff_cnt), 0, true,
+				&areq_ctx->mlli_nents);
+		if (unlikely(cc_generate_mlli(dev, &sg_data, mlli_params) != 0)) {
 			goto fail_unmap_din;
 		}
 	}
@@ -1695,8 +1641,8 @@ int ssi_buffer_mgr_map_hash_request_update(
 	return -ENOMEM;
 }
 
-void ssi_buffer_mgr_unmap_hash_request(
-	struct device *dev, void *ctx, struct scatterlist *src, bool do_revert)
+void cc_unmap_hash_request(struct device *dev, void *ctx,
+			   struct scatterlist *src, bool do_revert)
 {
 	struct ahash_req_ctx *areq_ctx = (struct ahash_req_ctx *)ctx;
 	u32 *prev_len = areq_ctx->buff_index ?  &areq_ctx->buff0_cnt :
@@ -1736,7 +1682,7 @@ void ssi_buffer_mgr_unmap_hash_request(
 	}
 }
 
-int ssi_buffer_mgr_init(struct ssi_drvdata *drvdata)
+int cc_buffer_mgr_init(struct ssi_drvdata *drvdata)
 {
 	struct buff_mgr_handle *buff_mgr_handle;
 	struct device *dev = drvdata_to_dev(drvdata);
@@ -1759,11 +1705,11 @@ int ssi_buffer_mgr_init(struct ssi_drvdata *drvdata)
 	return 0;
 
 error:
-	ssi_buffer_mgr_fini(drvdata);
+	cc_buffer_mgr_fini(drvdata);
 	return -ENOMEM;
 }
 
-int ssi_buffer_mgr_fini(struct ssi_drvdata *drvdata)
+int cc_buffer_mgr_fini(struct ssi_drvdata *drvdata)
 {
 	struct buff_mgr_handle *buff_mgr_handle = drvdata->buff_mgr_handle;
 
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.h b/drivers/staging/ccree/ssi_buffer_mgr.h
index 1032f25..f6411de 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.h
+++ b/drivers/staging/ccree/ssi_buffer_mgr.h
@@ -50,42 +50,39 @@ struct mlli_params {
 	u32 mlli_len;
 };
 
-int ssi_buffer_mgr_init(struct ssi_drvdata *drvdata);
+int cc_buffer_mgr_init(struct ssi_drvdata *drvdata);
 
-int ssi_buffer_mgr_fini(struct ssi_drvdata *drvdata);
+int cc_buffer_mgr_fini(struct ssi_drvdata *drvdata);
 
-int ssi_buffer_mgr_map_blkcipher_request(
-	struct ssi_drvdata *drvdata,
-	void *ctx,
-	unsigned int ivsize,
-	unsigned int nbytes,
-	void *info,
-	struct scatterlist *src,
-	struct scatterlist *dst);
+int cc_map_blkcipher_request(struct ssi_drvdata *drvdata, void *ctx,
+			     unsigned int ivsize, unsigned int nbytes,
+			     void *info, struct scatterlist *src,
+			     struct scatterlist *dst);
 
-void ssi_buffer_mgr_unmap_blkcipher_request(
-	struct device *dev,
-	void *ctx,
-	unsigned int ivsize,
-	struct scatterlist *src,
-	struct scatterlist *dst);
+void cc_unmap_blkcipher_request(struct device *dev, void *ctx,
+				unsigned int ivsize,
+				struct scatterlist *src,
+				struct scatterlist *dst);
 
-int ssi_buffer_mgr_map_aead_request(struct ssi_drvdata *drvdata, struct aead_request *req);
+int cc_map_aead_request(struct ssi_drvdata *drvdata, struct aead_request *req);
 
-void ssi_buffer_mgr_unmap_aead_request(struct device *dev, struct aead_request *req);
+void cc_unmap_aead_request(struct device *dev, struct aead_request *req);
 
-int ssi_buffer_mgr_map_hash_request_final(struct ssi_drvdata *drvdata, void *ctx, struct scatterlist *src, unsigned int nbytes, bool do_update);
+int cc_map_hash_request_final(struct ssi_drvdata *drvdata, void *ctx,
+			      struct scatterlist *src, unsigned int nbytes,
+			      bool do_update);
 
-int ssi_buffer_mgr_map_hash_request_update(struct ssi_drvdata *drvdata, void *ctx, struct scatterlist *src, unsigned int nbytes, unsigned int block_size);
+int cc_map_hash_request_update(struct ssi_drvdata *drvdata, void *ctx,
+			       struct scatterlist *src, unsigned int nbytes,
+			       unsigned int block_size);
 
-void ssi_buffer_mgr_unmap_hash_request(struct device *dev, void *ctx, struct scatterlist *src, bool do_revert);
+void cc_unmap_hash_request(struct device *dev, void *ctx,
+			   struct scatterlist *src, bool do_revert);
 
-void ssi_buffer_mgr_copy_scatterlist_portion(struct device *dev, u8 *dest,
-					     struct scatterlist *sg,
-					     u32 to_skip, u32 end,
-					     enum ssi_sg_cpy_direct direct);
+void cc_copy_sg_portion(struct device *dev, u8 *dest, struct scatterlist *sg,
+			u32 to_skip, u32 end, enum ssi_sg_cpy_direct direct);
 
-void ssi_buffer_mgr_zero_sgl(struct scatterlist *sgl, u32 data_len);
+void cc_zero_sgl(struct scatterlist *sgl, u32 data_len);
 
 #endif /*__BUFFER_MGR_H__*/
 
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index ee85cbf..721acf4 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -694,7 +694,7 @@ static int ssi_blkcipher_complete(struct device *dev,
 	int completion_error = 0;
 	struct ablkcipher_request *req = (struct ablkcipher_request *)areq;
 
-	ssi_buffer_mgr_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
+	cc_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
 	kfree(req_ctx->iv);
 
 	if (areq) {
@@ -786,9 +786,8 @@ static int ssi_blkcipher_process(
 
 	/* STAT_PHASE_1: Map buffers */
 
-	rc = ssi_buffer_mgr_map_blkcipher_request(ctx_p->drvdata, req_ctx,
-						  ivsize, nbytes, req_ctx->iv,
-						  src, dst);
+	rc = cc_map_blkcipher_request(ctx_p->drvdata, req_ctx, ivsize, nbytes,
+				      req_ctx->iv, src, dst);
 	if (unlikely(rc != 0)) {
 		dev_err(dev, "map_request() failed\n");
 		goto exit_process;
@@ -823,12 +822,14 @@ static int ssi_blkcipher_process(
 	if (areq) {
 		if (unlikely(rc != -EINPROGRESS)) {
 			/* Failed to send the request or request completed synchronously */
-			ssi_buffer_mgr_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
+			cc_unmap_blkcipher_request(dev, req_ctx, ivsize, src,
+						   dst);
 		}
 
 	} else {
 		if (rc != 0) {
-			ssi_buffer_mgr_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
+			cc_unmap_blkcipher_request(dev, req_ctx, ivsize, src,
+						   dst);
 		} else {
 			rc = ssi_blkcipher_complete(dev, ctx_p, req_ctx, dst,
 						    src, ivsize, NULL,
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 1a3c481..b9d1352 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -317,7 +317,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	}
 
 	new_drvdata->mlli_sram_addr =
-		ssi_sram_mgr_alloc(new_drvdata, MAX_MLLI_BUFF_SIZE);
+		cc_sram_alloc(new_drvdata, MAX_MLLI_BUFF_SIZE);
 	if (unlikely(new_drvdata->mlli_sram_addr == NULL_SRAM_ADDR)) {
 		dev_err(dev, "Failed to alloc MLLI Sram buffer\n");
 		rc = -ENOMEM;
@@ -330,15 +330,15 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		goto post_sram_mgr_err;
 	}
 
-	rc = ssi_buffer_mgr_init(new_drvdata);
+	rc = cc_buffer_mgr_init(new_drvdata);
 	if (unlikely(rc != 0)) {
 		dev_err(dev, "buffer_mgr_init failed\n");
 		goto post_req_mgr_err;
 	}
 
-	rc = ssi_power_mgr_init(new_drvdata);
+	rc = cc_pm_init(new_drvdata);
 	if (unlikely(rc != 0)) {
-		dev_err(dev, "ssi_power_mgr_init failed\n");
+		dev_err(dev, "cc_pm_init failed\n");
 		goto post_buf_mgr_err;
 	}
 
@@ -383,9 +383,9 @@ static int init_cc_resources(struct platform_device *plat_dev)
 post_ivgen_err:
 	ssi_ivgen_fini(new_drvdata);
 post_power_mgr_err:
-	ssi_power_mgr_fini(new_drvdata);
+	cc_pm_fini(new_drvdata);
 post_buf_mgr_err:
-	 ssi_buffer_mgr_fini(new_drvdata);
+	 cc_buffer_mgr_fini(new_drvdata);
 post_req_mgr_err:
 	request_mgr_fini(new_drvdata);
 post_sram_mgr_err:
@@ -418,8 +418,8 @@ static void cleanup_cc_resources(struct platform_device *plat_dev)
 	ssi_hash_free(drvdata);
 	ssi_ablkcipher_free(drvdata);
 	ssi_ivgen_fini(drvdata);
-	ssi_power_mgr_fini(drvdata);
-	ssi_buffer_mgr_fini(drvdata);
+	cc_pm_fini(drvdata);
+	cc_buffer_mgr_fini(drvdata);
 	request_mgr_fini(drvdata);
 	ssi_sram_mgr_fini(drvdata);
 	ssi_fips_fini(drvdata);
@@ -500,7 +500,7 @@ static int cc7x_remove(struct platform_device *plat_dev)
 
 #if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
 static const struct dev_pm_ops arm_cc7x_driver_pm = {
-	SET_RUNTIME_PM_OPS(ssi_power_mgr_runtime_suspend, ssi_power_mgr_runtime_resume, NULL)
+	SET_RUNTIME_PM_OPS(cc_pm_suspend, cc_pm_resume, NULL)
 };
 #endif
 
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 1799d3f..eb9cb56 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -364,7 +364,7 @@ static void ssi_hash_update_complete(struct device *dev, void *ssi_req, void __i
 
 	dev_dbg(dev, "req=%pK\n", req);
 
-	ssi_buffer_mgr_unmap_hash_request(dev, state, req->src, false);
+	cc_unmap_hash_request(dev, state, req->src, false);
 	req->base.complete(&req->base, 0);
 }
 
@@ -378,7 +378,7 @@ static void ssi_hash_digest_complete(struct device *dev, void *ssi_req, void __i
 
 	dev_dbg(dev, "req=%pK\n", req);
 
-	ssi_buffer_mgr_unmap_hash_request(dev, state, req->src, false);
+	cc_unmap_hash_request(dev, state, req->src, false);
 	ssi_hash_unmap_result(dev, state, digestsize, req->result);
 	ssi_hash_unmap_request(dev, state, ctx);
 	req->base.complete(&req->base, 0);
@@ -394,7 +394,7 @@ static void ssi_hash_complete(struct device *dev, void *ssi_req, void __iomem *c
 
 	dev_dbg(dev, "req=%pK\n", req);
 
-	ssi_buffer_mgr_unmap_hash_request(dev, state, req->src, false);
+	cc_unmap_hash_request(dev, state, req->src, false);
 	ssi_hash_unmap_result(dev, state, digestsize, req->result);
 	ssi_hash_unmap_request(dev, state, ctx);
 	req->base.complete(&req->base, 0);
@@ -429,7 +429,8 @@ static int ssi_hash_digest(struct ahash_req_ctx *state,
 		return -ENOMEM;
 	}
 
-	if (unlikely(ssi_buffer_mgr_map_hash_request_final(ctx->drvdata, state, src, nbytes, 1) != 0)) {
+	if (unlikely(cc_map_hash_request_final(ctx->drvdata, state,
+					       src, nbytes, 1) != 0)) {
 		dev_err(dev, "map_ahash_request_final() failed\n");
 		return -ENOMEM;
 	}
@@ -548,7 +549,7 @@ ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
 		rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
 		if (unlikely(rc != -EINPROGRESS)) {
 			dev_err(dev, "send_request() failed (rc=%d)\n", rc);
-			ssi_buffer_mgr_unmap_hash_request(dev, state, src, true);
+			cc_unmap_hash_request(dev, state, src, true);
 			ssi_hash_unmap_result(dev, state, digestsize, result);
 			ssi_hash_unmap_request(dev, state, ctx);
 		}
@@ -556,9 +557,9 @@ ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
 		rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 0);
 		if (rc != 0) {
 			dev_err(dev, "send_request() failed (rc=%d)\n", rc);
-			ssi_buffer_mgr_unmap_hash_request(dev, state, src, true);
+			cc_unmap_hash_request(dev, state, src, true);
 		} else {
-			ssi_buffer_mgr_unmap_hash_request(dev, state, src, false);
+			cc_unmap_hash_request(dev, state, src, false);
 		}
 		ssi_hash_unmap_result(dev, state, digestsize, result);
 		ssi_hash_unmap_request(dev, state, ctx);
@@ -587,7 +588,8 @@ static int ssi_hash_update(struct ahash_req_ctx *state,
 		return 0;
 	}
 
-	rc = ssi_buffer_mgr_map_hash_request_update(ctx->drvdata, state, src, nbytes, block_size);
+	rc = cc_map_hash_request_update(ctx->drvdata, state, src, nbytes,
+					block_size);
 	if (unlikely(rc)) {
 		if (rc == 1) {
 			dev_dbg(dev, " data size not require HW update %x\n",
@@ -648,15 +650,15 @@ static int ssi_hash_update(struct ahash_req_ctx *state,
 		rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
 		if (unlikely(rc != -EINPROGRESS)) {
 			dev_err(dev, "send_request() failed (rc=%d)\n", rc);
-			ssi_buffer_mgr_unmap_hash_request(dev, state, src, true);
+			cc_unmap_hash_request(dev, state, src, true);
 		}
 	} else {
 		rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 0);
 		if (rc != 0) {
 			dev_err(dev, "send_request() failed (rc=%d)\n", rc);
-			ssi_buffer_mgr_unmap_hash_request(dev, state, src, true);
+			cc_unmap_hash_request(dev, state, src, true);
 		} else {
-			ssi_buffer_mgr_unmap_hash_request(dev, state, src, false);
+			cc_unmap_hash_request(dev, state, src, false);
 		}
 	}
 	return rc;
@@ -680,7 +682,8 @@ static int ssi_hash_finup(struct ahash_req_ctx *state,
 	dev_dbg(dev, "===== %s-finup (%d) ====\n", is_hmac ? "hmac" : "hash",
 		nbytes);
 
-	if (unlikely(ssi_buffer_mgr_map_hash_request_final(ctx->drvdata, state, src, nbytes, 1) != 0)) {
+	if (unlikely(cc_map_hash_request_final(ctx->drvdata, state, src,
+					       nbytes, 1) != 0)) {
 		dev_err(dev, "map_ahash_request_final() failed\n");
 		return -ENOMEM;
 	}
@@ -779,17 +782,17 @@ ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
 		rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
 		if (unlikely(rc != -EINPROGRESS)) {
 			dev_err(dev, "send_request() failed (rc=%d)\n", rc);
-			ssi_buffer_mgr_unmap_hash_request(dev, state, src, true);
+			cc_unmap_hash_request(dev, state, src, true);
 			ssi_hash_unmap_result(dev, state, digestsize, result);
 		}
 	} else {
 		rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 0);
 		if (rc != 0) {
 			dev_err(dev, "send_request() failed (rc=%d)\n", rc);
-			ssi_buffer_mgr_unmap_hash_request(dev, state, src, true);
+			cc_unmap_hash_request(dev, state, src, true);
 			ssi_hash_unmap_result(dev, state, digestsize, result);
 		} else {
-			ssi_buffer_mgr_unmap_hash_request(dev, state, src, false);
+			cc_unmap_hash_request(dev, state, src, false);
 			ssi_hash_unmap_result(dev, state, digestsize, result);
 			ssi_hash_unmap_request(dev, state, ctx);
 		}
@@ -815,7 +818,8 @@ static int ssi_hash_final(struct ahash_req_ctx *state,
 	dev_dbg(dev, "===== %s-final (%d) ====\n", is_hmac ? "hmac" : "hash",
 		nbytes);
 
-	if (unlikely(ssi_buffer_mgr_map_hash_request_final(ctx->drvdata, state, src, nbytes, 0) != 0)) {
+	if (unlikely(cc_map_hash_request_final(ctx->drvdata, state, src,
+					       nbytes, 0) != 0)) {
 		dev_err(dev, "map_ahash_request_final() failed\n");
 		return -ENOMEM;
 	}
@@ -924,17 +928,17 @@ ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
 		rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
 		if (unlikely(rc != -EINPROGRESS)) {
 			dev_err(dev, "send_request() failed (rc=%d)\n", rc);
-			ssi_buffer_mgr_unmap_hash_request(dev, state, src, true);
+			cc_unmap_hash_request(dev, state, src, true);
 			ssi_hash_unmap_result(dev, state, digestsize, result);
 		}
 	} else {
 		rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 0);
 		if (rc != 0) {
 			dev_err(dev, "send_request() failed (rc=%d)\n", rc);
-			ssi_buffer_mgr_unmap_hash_request(dev, state, src, true);
+			cc_unmap_hash_request(dev, state, src, true);
 			ssi_hash_unmap_result(dev, state, digestsize, result);
 		} else {
-			ssi_buffer_mgr_unmap_hash_request(dev, state, src, false);
+			cc_unmap_hash_request(dev, state, src, false);
 			ssi_hash_unmap_result(dev, state, digestsize, result);
 			ssi_hash_unmap_request(dev, state, ctx);
 		}
@@ -1372,7 +1376,8 @@ static int ssi_mac_update(struct ahash_request *req)
 
 	state->xcbc_count++;
 
-	rc = ssi_buffer_mgr_map_hash_request_update(ctx->drvdata, state, req->src, req->nbytes, block_size);
+	rc = cc_map_hash_request_update(ctx->drvdata, state, req->src,
+					req->nbytes, block_size);
 	if (unlikely(rc)) {
 		if (rc == 1) {
 			dev_dbg(dev, " data size not require HW update %x\n",
@@ -1408,7 +1413,7 @@ static int ssi_mac_update(struct ahash_request *req)
 	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
 	if (unlikely(rc != -EINPROGRESS)) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
-		ssi_buffer_mgr_unmap_hash_request(dev, state, req->src, true);
+		cc_unmap_hash_request(dev, state, req->src, true);
 	}
 	return rc;
 }
@@ -1440,7 +1445,8 @@ static int ssi_mac_final(struct ahash_request *req)
 
 	dev_dbg(dev, "===== final  xcbc reminder (%d) ====\n", rem_cnt);
 
-	if (unlikely(ssi_buffer_mgr_map_hash_request_final(ctx->drvdata, state, req->src, req->nbytes, 0) != 0)) {
+	if (unlikely(cc_map_hash_request_final(ctx->drvdata, state, req->src,
+					       req->nbytes, 0) != 0)) {
 		dev_err(dev, "map_ahash_request_final() failed\n");
 		return -ENOMEM;
 	}
@@ -1518,7 +1524,7 @@ static int ssi_mac_final(struct ahash_request *req)
 	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
 	if (unlikely(rc != -EINPROGRESS)) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
-		ssi_buffer_mgr_unmap_hash_request(dev, state, req->src, true);
+		cc_unmap_hash_request(dev, state, req->src, true);
 		ssi_hash_unmap_result(dev, state, digestsize, req->result);
 	}
 	return rc;
@@ -1543,7 +1549,8 @@ static int ssi_mac_finup(struct ahash_request *req)
 		return ssi_mac_final(req);
 	}
 
-	if (unlikely(ssi_buffer_mgr_map_hash_request_final(ctx->drvdata, state, req->src, req->nbytes, 1) != 0)) {
+	if (unlikely(cc_map_hash_request_final(ctx->drvdata, state, req->src,
+					       req->nbytes, 1) != 0)) {
 		dev_err(dev, "map_ahash_request_final() failed\n");
 		return -ENOMEM;
 	}
@@ -1589,7 +1596,7 @@ static int ssi_mac_finup(struct ahash_request *req)
 	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
 	if (unlikely(rc != -EINPROGRESS)) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
-		ssi_buffer_mgr_unmap_hash_request(dev, state, req->src, true);
+		cc_unmap_hash_request(dev, state, req->src, true);
 		ssi_hash_unmap_result(dev, state, digestsize, req->result);
 	}
 	return rc;
@@ -1619,7 +1626,8 @@ static int ssi_mac_digest(struct ahash_request *req)
 		return -ENOMEM;
 	}
 
-	if (unlikely(ssi_buffer_mgr_map_hash_request_final(ctx->drvdata, state, req->src, req->nbytes, 1) != 0)) {
+	if (unlikely(cc_map_hash_request_final(ctx->drvdata, state, req->src,
+					       req->nbytes, 1) != 0)) {
 		dev_err(dev, "map_ahash_request_final() failed\n");
 		return -ENOMEM;
 	}
@@ -1661,7 +1669,7 @@ static int ssi_mac_digest(struct ahash_request *req)
 	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
 	if (unlikely(rc != -EINPROGRESS)) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
-		ssi_buffer_mgr_unmap_hash_request(dev, state, req->src, true);
+		cc_unmap_hash_request(dev, state, req->src, true);
 		ssi_hash_unmap_result(dev, state, digestsize, req->result);
 		ssi_hash_unmap_request(dev, state, ctx);
 	}
@@ -2105,9 +2113,9 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 #endif
 
 	/* Copy-to-sram digest-len */
-	ssi_sram_mgr_const2sram_desc(digest_len_init, sram_buff_ofs,
-				     ARRAY_SIZE(digest_len_init),
-				     larval_seq, &larval_seq_len);
+	cc_set_sram_desc(digest_len_init, sram_buff_ofs,
+			 ARRAY_SIZE(digest_len_init), larval_seq,
+			 &larval_seq_len);
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
 	if (unlikely(rc != 0))
 		goto init_digest_const_err;
@@ -2117,9 +2125,9 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 
 #if (DX_DEV_SHA_MAX > 256)
 	/* Copy-to-sram digest-len for sha384/512 */
-	ssi_sram_mgr_const2sram_desc(digest_len_sha512_init, sram_buff_ofs,
-				     ARRAY_SIZE(digest_len_sha512_init),
-				     larval_seq, &larval_seq_len);
+	cc_set_sram_desc(digest_len_sha512_init, sram_buff_ofs,
+			 ARRAY_SIZE(digest_len_sha512_init),
+			 larval_seq, &larval_seq_len);
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
 	if (unlikely(rc != 0))
 		goto init_digest_const_err;
@@ -2132,36 +2140,36 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 	hash_handle->larval_digest_sram_addr = sram_buff_ofs;
 
 	/* Copy-to-sram initial SHA* digests */
-	ssi_sram_mgr_const2sram_desc(md5_init, sram_buff_ofs,
-				     ARRAY_SIZE(md5_init), larval_seq,
-				     &larval_seq_len);
+	cc_set_sram_desc(md5_init, sram_buff_ofs,
+			 ARRAY_SIZE(md5_init), larval_seq,
+			 &larval_seq_len);
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
 	if (unlikely(rc != 0))
 		goto init_digest_const_err;
 	sram_buff_ofs += sizeof(md5_init);
 	larval_seq_len = 0;
 
-	ssi_sram_mgr_const2sram_desc(sha1_init, sram_buff_ofs,
-				     ARRAY_SIZE(sha1_init), larval_seq,
-				     &larval_seq_len);
+	cc_set_sram_desc(sha1_init, sram_buff_ofs,
+			 ARRAY_SIZE(sha1_init), larval_seq,
+			 &larval_seq_len);
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
 	if (unlikely(rc != 0))
 		goto init_digest_const_err;
 	sram_buff_ofs += sizeof(sha1_init);
 	larval_seq_len = 0;
 
-	ssi_sram_mgr_const2sram_desc(sha224_init, sram_buff_ofs,
-				     ARRAY_SIZE(sha224_init), larval_seq,
-				     &larval_seq_len);
+	cc_set_sram_desc(sha224_init, sram_buff_ofs,
+			 ARRAY_SIZE(sha224_init), larval_seq,
+			 &larval_seq_len);
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
 	if (unlikely(rc != 0))
 		goto init_digest_const_err;
 	sram_buff_ofs += sizeof(sha224_init);
 	larval_seq_len = 0;
 
-	ssi_sram_mgr_const2sram_desc(sha256_init, sram_buff_ofs,
-				     ARRAY_SIZE(sha256_init), larval_seq,
-				     &larval_seq_len);
+	cc_set_sram_desc(sha256_init, sram_buff_ofs,
+			 ARRAY_SIZE(sha256_init), larval_seq,
+			 &larval_seq_len);
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
 	if (unlikely(rc != 0))
 		goto init_digest_const_err;
@@ -2174,11 +2182,11 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 		const u32 const0 = ((u32 *)((u64 *)&sha384_init[i]))[1];
 		const u32 const1 = ((u32 *)((u64 *)&sha384_init[i]))[0];
 
-		ssi_sram_mgr_const2sram_desc(&const0, sram_buff_ofs, 1,
-					     larval_seq, &larval_seq_len);
+		cc_set_sram_desc(&const0, sram_buff_ofs, 1, larval_seq,
+				 &larval_seq_len);
 		sram_buff_ofs += sizeof(u32);
-		ssi_sram_mgr_const2sram_desc(&const1, sram_buff_ofs, 1,
-					     larval_seq, &larval_seq_len);
+		cc_set_sram_desc(&const1, sram_buff_ofs, 1, larval_seq,
+				 &larval_seq_len);
 		sram_buff_ofs += sizeof(u32);
 	}
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
@@ -2192,11 +2200,11 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 		const u32 const0 = ((u32 *)((u64 *)&sha512_init[i]))[1];
 		const u32 const1 = ((u32 *)((u64 *)&sha512_init[i]))[0];
 
-		ssi_sram_mgr_const2sram_desc(&const0, sram_buff_ofs, 1,
-					     larval_seq, &larval_seq_len);
+		cc_set_sram_desc(&const0, sram_buff_ofs, 1, larval_seq,
+				 &larval_seq_len);
 		sram_buff_ofs += sizeof(u32);
-		ssi_sram_mgr_const2sram_desc(&const1, sram_buff_ofs, 1,
-					     larval_seq, &larval_seq_len);
+		cc_set_sram_desc(&const1, sram_buff_ofs, 1, larval_seq,
+				 &larval_seq_len);
 		sram_buff_ofs += sizeof(u32);
 	}
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
@@ -2237,7 +2245,7 @@ int ssi_hash_alloc(struct ssi_drvdata *drvdata)
 			sizeof(sha224_init) +
 			sizeof(sha256_init);
 
-	sram_buff = ssi_sram_mgr_alloc(drvdata, sram_size_to_alloc);
+	sram_buff = cc_sram_alloc(drvdata, sram_size_to_alloc);
 	if (sram_buff == NULL_SRAM_ADDR) {
 		dev_err(dev, "SRAM pool exhausted\n");
 		rc = -ENOMEM;
diff --git a/drivers/staging/ccree/ssi_ivgen.c b/drivers/staging/ccree/ssi_ivgen.c
index 3f082f4..0d85bce 100644
--- a/drivers/staging/ccree/ssi_ivgen.c
+++ b/drivers/staging/ccree/ssi_ivgen.c
@@ -209,7 +209,7 @@ int ssi_ivgen_init(struct ssi_drvdata *drvdata)
 		goto out;
 	}
 	/* Allocate IV pool in SRAM */
-	ivgen_ctx->pool = ssi_sram_mgr_alloc(drvdata, SSI_IVPOOL_SIZE);
+	ivgen_ctx->pool = cc_sram_alloc(drvdata, SSI_IVPOOL_SIZE);
 	if (ivgen_ctx->pool == NULL_SRAM_ADDR) {
 		dev_err(device, "SRAM pool exhausted\n");
 		rc = -ENOMEM;
diff --git a/drivers/staging/ccree/ssi_pm.c b/drivers/staging/ccree/ssi_pm.c
index 36a4980..e1bc4c5 100644
--- a/drivers/staging/ccree/ssi_pm.c
+++ b/drivers/staging/ccree/ssi_pm.c
@@ -34,7 +34,7 @@
 #define POWER_DOWN_ENABLE 0x01
 #define POWER_DOWN_DISABLE 0x00
 
-int ssi_power_mgr_runtime_suspend(struct device *dev)
+int cc_pm_suspend(struct device *dev)
 {
 	struct ssi_drvdata *drvdata =
 		(struct ssi_drvdata *)dev_get_drvdata(dev);
@@ -42,9 +42,9 @@ int ssi_power_mgr_runtime_suspend(struct device *dev)
 
 	dev_dbg(dev, "set HOST_POWER_DOWN_EN\n");
 	cc_iowrite(drvdata, CC_REG(HOST_POWER_DOWN_EN), POWER_DOWN_ENABLE);
-	rc = ssi_request_mgr_runtime_suspend_queue(drvdata);
+	rc = cc_suspend_req_queue(drvdata);
 	if (rc != 0) {
-		dev_err(dev, "ssi_request_mgr_runtime_suspend_queue (%x)\n",
+		dev_err(dev, "cc_suspend_req_queue (%x)\n",
 			rc);
 		return rc;
 	}
@@ -53,7 +53,7 @@ int ssi_power_mgr_runtime_suspend(struct device *dev)
 	return 0;
 }
 
-int ssi_power_mgr_runtime_resume(struct device *dev)
+int cc_pm_resume(struct device *dev)
 {
 	int rc;
 	struct ssi_drvdata *drvdata =
@@ -74,9 +74,9 @@ int ssi_power_mgr_runtime_resume(struct device *dev)
 		return rc;
 	}
 
-	rc = ssi_request_mgr_runtime_resume_queue(drvdata);
+	rc = cc_resume_req_queue(drvdata);
 	if (rc != 0) {
-		dev_err(dev, "ssi_request_mgr_runtime_resume_queue (%x)\n", rc);
+		dev_err(dev, "cc_resume_req_queue (%x)\n", rc);
 		return rc;
 	}
 
@@ -87,12 +87,11 @@ int ssi_power_mgr_runtime_resume(struct device *dev)
 	return 0;
 }
 
-int ssi_power_mgr_runtime_get(struct device *dev)
+int cc_pm_get(struct device *dev)
 {
 	int rc = 0;
 
-	if (ssi_request_mgr_is_queue_runtime_suspend(
-				(struct ssi_drvdata *)dev_get_drvdata(dev))) {
+	if (cc_req_queue_suspended((struct ssi_drvdata *)dev_get_drvdata(dev))) {
 		rc = pm_runtime_get_sync(dev);
 	} else {
 		pm_runtime_get_noresume(dev);
@@ -100,12 +99,11 @@ int ssi_power_mgr_runtime_get(struct device *dev)
 	return rc;
 }
 
-int ssi_power_mgr_runtime_put_suspend(struct device *dev)
+int cc_pm_put_suspend(struct device *dev)
 {
 	int rc = 0;
 
-	if (!ssi_request_mgr_is_queue_runtime_suspend(
-				(struct ssi_drvdata *)dev_get_drvdata(dev))) {
+	if (!cc_req_queue_suspended((struct ssi_drvdata *)dev_get_drvdata(dev))) {
 		pm_runtime_mark_last_busy(dev);
 		rc = pm_runtime_put_autosuspend(dev);
 	} else {
@@ -118,7 +116,7 @@ int ssi_power_mgr_runtime_put_suspend(struct device *dev)
 
 #endif
 
-int ssi_power_mgr_init(struct ssi_drvdata *drvdata)
+int cc_pm_init(struct ssi_drvdata *drvdata)
 {
 	int rc = 0;
 #if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
@@ -137,7 +135,7 @@ int ssi_power_mgr_init(struct ssi_drvdata *drvdata)
 	return rc;
 }
 
-void ssi_power_mgr_fini(struct ssi_drvdata *drvdata)
+void cc_pm_fini(struct ssi_drvdata *drvdata)
 {
 #if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
 	pm_runtime_disable(drvdata_to_dev(drvdata));
diff --git a/drivers/staging/ccree/ssi_pm.h b/drivers/staging/ccree/ssi_pm.h
index 63673f6..557ec98 100644
--- a/drivers/staging/ccree/ssi_pm.h
+++ b/drivers/staging/ccree/ssi_pm.h
@@ -25,18 +25,18 @@
 
 #define SSI_SUSPEND_TIMEOUT 3000
 
-int ssi_power_mgr_init(struct ssi_drvdata *drvdata);
+int cc_pm_init(struct ssi_drvdata *drvdata);
 
-void ssi_power_mgr_fini(struct ssi_drvdata *drvdata);
+void cc_pm_fini(struct ssi_drvdata *drvdata);
 
 #if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
-int ssi_power_mgr_runtime_suspend(struct device *dev);
+int cc_pm_suspend(struct device *dev);
 
-int ssi_power_mgr_runtime_resume(struct device *dev);
+int cc_pm_resume(struct device *dev);
 
-int ssi_power_mgr_runtime_get(struct device *dev);
+int cc_pm_get(struct device *dev);
 
-int ssi_power_mgr_runtime_put_suspend(struct device *dev);
+int cc_pm_put_suspend(struct device *dev);
 #endif
 
 #endif /*__POWER_MGR_H__*/
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index a8a7dc6..f5d51c1 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -274,9 +274,9 @@ int send_request(
 					(!is_dout ? 1 : 0));
 
 #if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
-	rc = ssi_power_mgr_runtime_get(dev);
+	rc = cc_pm_get(dev);
 	if (rc != 0) {
-		dev_err(dev, "ssi_power_mgr_runtime_get returned %x\n", rc);
+		dev_err(dev, "cc_pm_get returned %x\n", rc);
 		return rc;
 	}
 #endif
@@ -301,7 +301,7 @@ int send_request(
 			 * (SW queue is full)
 			 */
 #if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
-			ssi_power_mgr_runtime_put_suspend(dev);
+			cc_pm_put_suspend(dev);
 #endif
 			return rc;
 		}
@@ -337,7 +337,7 @@ int send_request(
 			dev_err(dev, "Failed to generate IV (rc=%d)\n", rc);
 			spin_unlock_bh(&req_mgr_h->hw_lock);
 #if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
-			ssi_power_mgr_runtime_put_suspend(dev);
+			cc_pm_put_suspend(dev);
 #endif
 			return rc;
 		}
@@ -499,7 +499,7 @@ static void proc_completions(struct ssi_drvdata *drvdata)
 		dev_dbg(dev, "Request completed. axi_completed=%d\n",
 			request_mgr_handle->axi_completed);
 #if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
-		rc = ssi_power_mgr_runtime_put_suspend(dev);
+		rc = cc_pm_put_suspend(dev);
 		if (rc != 0)
 			dev_err(dev, "Failed to set runtime suspension %d\n",
 				rc);
@@ -565,7 +565,7 @@ static void comp_handler(unsigned long devarg)
  * the spin lock protection
  */
 #if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
-int ssi_request_mgr_runtime_resume_queue(struct ssi_drvdata *drvdata)
+int cc_resume_req_queue(struct ssi_drvdata *drvdata)
 {
 	struct ssi_request_mgr_handle *request_mgr_handle = drvdata->request_mgr_handle;
 
@@ -580,7 +580,7 @@ int ssi_request_mgr_runtime_resume_queue(struct ssi_drvdata *drvdata)
  * suspend the queue configuration. Since it is used for the runtime suspend
  * only verify that the queue can be suspended.
  */
-int ssi_request_mgr_runtime_suspend_queue(struct ssi_drvdata *drvdata)
+int cc_suspend_req_queue(struct ssi_drvdata *drvdata)
 {
 	struct ssi_request_mgr_handle *request_mgr_handle =
 						drvdata->request_mgr_handle;
@@ -598,7 +598,7 @@ int ssi_request_mgr_runtime_suspend_queue(struct ssi_drvdata *drvdata)
 	return 0;
 }
 
-bool ssi_request_mgr_is_queue_runtime_suspend(struct ssi_drvdata *drvdata)
+bool cc_req_queue_suspended(struct ssi_drvdata *drvdata)
 {
 	struct ssi_request_mgr_handle *request_mgr_handle =
 						drvdata->request_mgr_handle;
diff --git a/drivers/staging/ccree/ssi_request_mgr.h b/drivers/staging/ccree/ssi_request_mgr.h
index bdbbf89..ba44ab4 100644
--- a/drivers/staging/ccree/ssi_request_mgr.h
+++ b/drivers/staging/ccree/ssi_request_mgr.h
@@ -50,11 +50,11 @@ void complete_request(struct ssi_drvdata *drvdata);
 void request_mgr_fini(struct ssi_drvdata *drvdata);
 
 #if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
-int ssi_request_mgr_runtime_resume_queue(struct ssi_drvdata *drvdata);
+int cc_resume_req_queue(struct ssi_drvdata *drvdata);
 
-int ssi_request_mgr_runtime_suspend_queue(struct ssi_drvdata *drvdata);
+int cc_suspend_req_queue(struct ssi_drvdata *drvdata);
 
-bool ssi_request_mgr_is_queue_runtime_suspend(struct ssi_drvdata *drvdata);
+bool cc_req_queue_suspended(struct ssi_drvdata *drvdata);
 #endif
 
 #endif /*__REQUEST_MGR_H__*/
diff --git a/drivers/staging/ccree/ssi_sram_mgr.c b/drivers/staging/ccree/ssi_sram_mgr.c
index 07260d1..51513248 100644
--- a/drivers/staging/ccree/ssi_sram_mgr.c
+++ b/drivers/staging/ccree/ssi_sram_mgr.c
@@ -69,7 +69,7 @@ int ssi_sram_mgr_init(struct ssi_drvdata *drvdata)
  * \param drvdata
  * \param size The requested bytes to allocate
  */
-ssi_sram_addr_t ssi_sram_mgr_alloc(struct ssi_drvdata *drvdata, u32 size)
+ssi_sram_addr_t cc_sram_alloc(struct ssi_drvdata *drvdata, u32 size)
 {
 	struct ssi_sram_mgr_ctx *smgr_ctx = drvdata->sram_mgr_handle;
 	struct device *dev = drvdata_to_dev(drvdata);
@@ -93,7 +93,7 @@ ssi_sram_addr_t ssi_sram_mgr_alloc(struct ssi_drvdata *drvdata, u32 size)
 }
 
 /**
- * ssi_sram_mgr_const2sram_desc() - Create const descriptors sequence to
+ * cc_set_sram_desc() - Create const descriptors sequence to
  *	set values in given array into SRAM.
  * Note: each const value can't exceed word size.
  *
@@ -103,10 +103,9 @@ ssi_sram_addr_t ssi_sram_mgr_alloc(struct ssi_drvdata *drvdata, u32 size)
  * @seq:	  A pointer to the given IN/OUT descriptor sequence
  * @seq_len:	  A pointer to the given IN/OUT sequence length
  */
-void ssi_sram_mgr_const2sram_desc(
-	const u32 *src, ssi_sram_addr_t dst,
-	unsigned int nelement,
-	struct cc_hw_desc *seq, unsigned int *seq_len)
+void cc_set_sram_desc(const u32 *src, ssi_sram_addr_t dst,
+		      unsigned int nelement, struct cc_hw_desc *seq,
+		      unsigned int *seq_len)
 {
 	u32 i;
 	unsigned int idx = *seq_len;
diff --git a/drivers/staging/ccree/ssi_sram_mgr.h b/drivers/staging/ccree/ssi_sram_mgr.h
index 9ba1d59..9e39262 100644
--- a/drivers/staging/ccree/ssi_sram_mgr.h
+++ b/drivers/staging/ccree/ssi_sram_mgr.h
@@ -58,10 +58,10 @@ void ssi_sram_mgr_fini(struct ssi_drvdata *drvdata);
  * \param drvdata
  * \param size The requested bytes to allocate
  */
-ssi_sram_addr_t ssi_sram_mgr_alloc(struct ssi_drvdata *drvdata, u32 size);
+ssi_sram_addr_t cc_sram_alloc(struct ssi_drvdata *drvdata, u32 size);
 
 /**
- * ssi_sram_mgr_const2sram_desc() - Create const descriptors sequence to
+ * cc_set_sram_desc() - Create const descriptors sequence to
  *	set values in given array into SRAM.
  * Note: each const value can't exceed word size.
  *
@@ -71,7 +71,7 @@ ssi_sram_addr_t ssi_sram_mgr_alloc(struct ssi_drvdata *drvdata, u32 size);
  * @seq:	  A pointer to the given IN/OUT descriptor sequence
  * @seq_len:	  A pointer to the given IN/OUT sequence length
  */
-void ssi_sram_mgr_const2sram_desc(
+void cc_set_sram_desc(
 	const u32 *src, ssi_sram_addr_t dst,
 	unsigned int nelement,
 	struct cc_hw_desc *seq, unsigned int *seq_len);
-- 
2.7.4
