From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 18/24] staging: ccree: rename all SSI to CC
Date: Tue, 12 Dec 2017 14:53:04 +0000
Message-ID: <1513090395-7938-19-git-send-email-gilad@benyossef.com>
References: <1513090395-7938-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:45196 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752942AbdLLOz6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Dec 2017 09:55:58 -0500
In-Reply-To: <1513090395-7938-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Unify naming convention by renaming all SSI macros to CC.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c        | 26 +++++------
 drivers/staging/ccree/ssi_aead.h        |  6 +--
 drivers/staging/ccree/ssi_buffer_mgr.c  | 78 ++++++++++++++++-----------------
 drivers/staging/ccree/ssi_buffer_mgr.h  | 14 +++---
 drivers/staging/ccree/ssi_cipher.c      |  4 +-
 drivers/staging/ccree/ssi_cipher.h      |  6 +--
 drivers/staging/ccree/ssi_config.h      |  4 +-
 drivers/staging/ccree/ssi_driver.c      | 26 +++++------
 drivers/staging/ccree/ssi_driver.h      | 22 +++++-----
 drivers/staging/ccree/ssi_fips.c        |  2 +-
 drivers/staging/ccree/ssi_fips.h        |  6 +--
 drivers/staging/ccree/ssi_hash.c        |  6 +--
 drivers/staging/ccree/ssi_hash.h        |  6 +--
 drivers/staging/ccree/ssi_ivgen.c       |  8 ++--
 drivers/staging/ccree/ssi_ivgen.h       |  8 ++--
 drivers/staging/ccree/ssi_pm.c          |  2 +-
 drivers/staging/ccree/ssi_pm.h          |  6 +--
 drivers/staging/ccree/ssi_request_mgr.c | 16 +++----
 drivers/staging/ccree/ssi_sram_mgr.c    |  2 +-
 drivers/staging/ccree/ssi_sram_mgr.h    | 10 ++---
 drivers/staging/ccree/ssi_sysfs.h       |  6 +--
 21 files changed, 132 insertions(+), 132 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index ac9961c..d07b38d 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -257,7 +257,7 @@ static void cc_aead_complete(struct device *dev, void *ssi_req)
 			cc_copy_sg_portion(dev, areq_ctx->mac_buf,
 					   areq_ctx->dst_sgl, skip,
 					   (skip + ctx->authsize),
-					   SSI_SG_FROM_BUF);
+					   CC_SG_FROM_BUF);
 		}
 
 		/* If an IV was generated, copy it back to the user provided
@@ -739,7 +739,7 @@ static void cc_set_assoc_desc(struct aead_request *areq, unsigned int flow_mode,
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 
 	switch (assoc_dma_type) {
-	case SSI_DMA_BUF_DLLI:
+	case CC_DMA_BUF_DLLI:
 		dev_dbg(dev, "ASSOC buffer type DLLI\n");
 		hw_desc_init(&desc[idx]);
 		set_din_type(&desc[idx], DMA_DLLI, sg_dma_address(areq->src),
@@ -749,7 +749,7 @@ static void cc_set_assoc_desc(struct aead_request *areq, unsigned int flow_mode,
 		    areq_ctx->cryptlen > 0)
 			set_din_not_last_indication(&desc[idx]);
 		break;
-	case SSI_DMA_BUF_MLLI:
+	case CC_DMA_BUF_MLLI:
 		dev_dbg(dev, "ASSOC buffer type MLLI\n");
 		hw_desc_init(&desc[idx]);
 		set_din_type(&desc[idx], DMA_MLLI, areq_ctx->assoc.sram_addr,
@@ -759,7 +759,7 @@ static void cc_set_assoc_desc(struct aead_request *areq, unsigned int flow_mode,
 		    areq_ctx->cryptlen > 0)
 			set_din_not_last_indication(&desc[idx]);
 		break;
-	case SSI_DMA_BUF_NULL:
+	case CC_DMA_BUF_NULL:
 	default:
 		dev_err(dev, "Invalid ASSOC buffer type\n");
 	}
@@ -780,7 +780,7 @@ static void cc_proc_authen_desc(struct aead_request *areq,
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 
 	switch (data_dma_type) {
-	case SSI_DMA_BUF_DLLI:
+	case CC_DMA_BUF_DLLI:
 	{
 		struct scatterlist *cipher =
 			(direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ?
@@ -797,7 +797,7 @@ static void cc_proc_authen_desc(struct aead_request *areq,
 		set_flow_mode(&desc[idx], flow_mode);
 		break;
 	}
-	case SSI_DMA_BUF_MLLI:
+	case CC_DMA_BUF_MLLI:
 	{
 		/* DOUBLE-PASS flow (as default)
 		 * assoc. + iv + data -compact in one table
@@ -823,7 +823,7 @@ static void cc_proc_authen_desc(struct aead_request *areq,
 		set_flow_mode(&desc[idx], flow_mode);
 		break;
 	}
-	case SSI_DMA_BUF_NULL:
+	case CC_DMA_BUF_NULL:
 	default:
 		dev_err(dev, "AUTHENC: Invalid SRC/DST buffer type\n");
 	}
@@ -847,7 +847,7 @@ static void cc_proc_cipher_desc(struct aead_request *areq,
 		return; /*null processing*/
 
 	switch (data_dma_type) {
-	case SSI_DMA_BUF_DLLI:
+	case CC_DMA_BUF_DLLI:
 		dev_dbg(dev, "CIPHER: SRC/DST buffer type DLLI\n");
 		hw_desc_init(&desc[idx]);
 		set_din_type(&desc[idx], DMA_DLLI,
@@ -860,7 +860,7 @@ static void cc_proc_cipher_desc(struct aead_request *areq,
 			      areq_ctx->cryptlen, NS_BIT, 0);
 		set_flow_mode(&desc[idx], flow_mode);
 		break;
-	case SSI_DMA_BUF_MLLI:
+	case CC_DMA_BUF_MLLI:
 		dev_dbg(dev, "CIPHER: SRC/DST buffer type MLLI\n");
 		hw_desc_init(&desc[idx]);
 		set_din_type(&desc[idx], DMA_MLLI, areq_ctx->src.sram_addr,
@@ -869,7 +869,7 @@ static void cc_proc_cipher_desc(struct aead_request *areq,
 			      areq_ctx->dst.mlli_nents, NS_BIT, 0);
 		set_flow_mode(&desc[idx], flow_mode);
 		break;
-	case SSI_DMA_BUF_NULL:
+	case CC_DMA_BUF_NULL:
 	default:
 		dev_err(dev, "CIPHER: Invalid SRC/DST buffer type\n");
 	}
@@ -1171,8 +1171,8 @@ static void cc_mlli_to_sram(struct aead_request *req,
 	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 
-	if (req_ctx->assoc_buff_type == SSI_DMA_BUF_MLLI ||
-	    req_ctx->data_buff_type == SSI_DMA_BUF_MLLI ||
+	if (req_ctx->assoc_buff_type == CC_DMA_BUF_MLLI ||
+	    req_ctx->data_buff_type == CC_DMA_BUF_MLLI ||
 	    !req_ctx->is_single_pass) {
 		dev_dbg(dev, "Copy-to-sram: mlli_dma=%08x, mlli_size=%u\n",
 			(unsigned int)ctx->drvdata->mlli_sram_addr,
@@ -2670,7 +2670,7 @@ static struct ssi_crypto_alg *cc_create_aead_alg(struct ssi_alg_template *tmpl,
 	snprintf(alg->base.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
 		 tmpl->driver_name);
 	alg->base.cra_module = THIS_MODULE;
-	alg->base.cra_priority = SSI_CRA_PRIO;
+	alg->base.cra_priority = CC_CRA_PRIO;
 
 	alg->base.cra_ctxsize = sizeof(struct cc_aead_ctx);
 	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY |
diff --git a/drivers/staging/ccree/ssi_aead.h b/drivers/staging/ccree/ssi_aead.h
index 5172241..e41040e 100644
--- a/drivers/staging/ccree/ssi_aead.h
+++ b/drivers/staging/ccree/ssi_aead.h
@@ -18,8 +18,8 @@
  * ARM CryptoCell AEAD Crypto API
  */
 
-#ifndef __SSI_AEAD_H__
-#define __SSI_AEAD_H__
+#ifndef __CC_AEAD_H__
+#define __CC_AEAD_H__
 
 #include <linux/kernel.h>
 #include <crypto/algapi.h>
@@ -119,4 +119,4 @@ struct aead_req_ctx {
 int cc_aead_alloc(struct ssi_drvdata *drvdata);
 int cc_aead_free(struct ssi_drvdata *drvdata);
 
-#endif /*__SSI_AEAD_H__*/
+#endif /*__CC_AEAD_H__*/
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index c28ce7c..ee5c086 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -61,11 +61,11 @@ struct buffer_array {
 static inline char *cc_dma_buf_type(enum ssi_req_dma_buf_type type)
 {
 	switch (type) {
-	case SSI_DMA_BUF_NULL:
+	case CC_DMA_BUF_NULL:
 		return "BUF_NULL";
-	case SSI_DMA_BUF_DLLI:
+	case CC_DMA_BUF_DLLI:
 		return "BUF_DLLI";
-	case SSI_DMA_BUF_MLLI:
+	case CC_DMA_BUF_MLLI:
 		return "BUF_MLLI";
 	default:
 		return "BUF_INVALID";
@@ -163,7 +163,7 @@ void cc_copy_sg_portion(struct device *dev, u8 *dest, struct scatterlist *sg,
 
 	nents = cc_get_sgl_nents(dev, sg, end, &lbytes, NULL);
 	sg_copy_buffer(sg, nents, (void *)dest, (end - to_skip + 1), to_skip,
-		       (direct == SSI_SG_TO_BUF));
+		       (direct == CC_SG_TO_BUF));
 }
 
 static int cc_render_buff_to_mlli(struct device *dev, dma_addr_t buff_dma,
@@ -457,7 +457,7 @@ static int ssi_ahash_handle_curr_buf(struct device *dev,
 		&sg_dma_address(areq_ctx->buff_sg), sg_page(areq_ctx->buff_sg),
 		sg_virt(areq_ctx->buff_sg), areq_ctx->buff_sg->offset,
 		areq_ctx->buff_sg->length);
-	areq_ctx->data_dma_buf_type = SSI_DMA_BUF_DLLI;
+	areq_ctx->data_dma_buf_type = CC_DMA_BUF_DLLI;
 	areq_ctx->curr_sg = areq_ctx->buff_sg;
 	areq_ctx->in_nents = 0;
 	/* prepare for case of MLLI */
@@ -481,7 +481,7 @@ void cc_unmap_blkcipher_request(struct device *dev, void *ctx,
 				 DMA_TO_DEVICE);
 	}
 	/* Release pool */
-	if (req_ctx->dma_buf_type == SSI_DMA_BUF_MLLI) {
+	if (req_ctx->dma_buf_type == CC_DMA_BUF_MLLI) {
 		dma_pool_free(req_ctx->mlli_params.curr_pool,
 			      req_ctx->mlli_params.mlli_virt_addr,
 			      req_ctx->mlli_params.mlli_dma_addr);
@@ -510,7 +510,7 @@ int cc_map_blkcipher_request(struct ssi_drvdata *drvdata, void *ctx,
 	int rc = 0;
 	u32 mapped_nents = 0;
 
-	req_ctx->dma_buf_type = SSI_DMA_BUF_DLLI;
+	req_ctx->dma_buf_type = CC_DMA_BUF_DLLI;
 	mlli_params->curr_pool = NULL;
 	sg_data.num_of_buffers = 0;
 
@@ -541,11 +541,11 @@ int cc_map_blkcipher_request(struct ssi_drvdata *drvdata, void *ctx,
 		goto ablkcipher_exit;
 	}
 	if (mapped_nents > 1)
-		req_ctx->dma_buf_type = SSI_DMA_BUF_MLLI;
+		req_ctx->dma_buf_type = CC_DMA_BUF_MLLI;
 
 	if (src == dst) {
 		/* Handle inplace operation */
-		if (req_ctx->dma_buf_type == SSI_DMA_BUF_MLLI) {
+		if (req_ctx->dma_buf_type == CC_DMA_BUF_MLLI) {
 			req_ctx->out_nents = 0;
 			cc_add_sg_entry(dev, &sg_data, req_ctx->in_nents, src,
 					nbytes, 0, true,
@@ -560,9 +560,9 @@ int cc_map_blkcipher_request(struct ssi_drvdata *drvdata, void *ctx,
 			goto ablkcipher_exit;
 		}
 		if (mapped_nents > 1)
-			req_ctx->dma_buf_type = SSI_DMA_BUF_MLLI;
+			req_ctx->dma_buf_type = CC_DMA_BUF_MLLI;
 
-		if (req_ctx->dma_buf_type == SSI_DMA_BUF_MLLI) {
+		if (req_ctx->dma_buf_type == CC_DMA_BUF_MLLI) {
 			cc_add_sg_entry(dev, &sg_data, req_ctx->in_nents, src,
 					nbytes, 0, true,
 					&req_ctx->in_mlli_nents);
@@ -572,7 +572,7 @@ int cc_map_blkcipher_request(struct ssi_drvdata *drvdata, void *ctx,
 		}
 	}
 
-	if (req_ctx->dma_buf_type == SSI_DMA_BUF_MLLI) {
+	if (req_ctx->dma_buf_type == CC_DMA_BUF_MLLI) {
 		mlli_params->curr_pool = buff_mgr->mlli_buffs_pool;
 		rc = cc_generate_mlli(dev, &sg_data, mlli_params);
 		if (rc)
@@ -679,7 +679,7 @@ void cc_unmap_aead_request(struct device *dev, struct aead_request *req)
 		 * data memory overriding that caused by cache coherence
 		 * problem.
 		 */
-		cc_copy_mac(dev, req, SSI_SG_FROM_BUF);
+		cc_copy_mac(dev, req, CC_SG_FROM_BUF);
 	}
 }
 
@@ -771,7 +771,7 @@ static int cc_aead_chain_iv(struct ssi_drvdata *drvdata,
 				    (areq_ctx->gen_ctx.iv_dma_addr + iv_ofs),
 				    iv_size_to_authenc, is_last,
 				    &areq_ctx->assoc.mlli_nents);
-		areq_ctx->assoc_buff_type = SSI_DMA_BUF_MLLI;
+		areq_ctx->assoc_buff_type = CC_DMA_BUF_MLLI;
 	}
 
 chain_iv_exit:
@@ -801,7 +801,7 @@ static int cc_aead_chain_assoc(struct ssi_drvdata *drvdata,
 	}
 
 	if (req->assoclen == 0) {
-		areq_ctx->assoc_buff_type = SSI_DMA_BUF_NULL;
+		areq_ctx->assoc_buff_type = CC_DMA_BUF_NULL;
 		areq_ctx->assoc.nents = 0;
 		areq_ctx->assoc.mlli_nents = 0;
 		dev_dbg(dev, "Chain assoc of length 0: buff_type=%s nents=%u\n",
@@ -851,18 +851,18 @@ static int cc_aead_chain_assoc(struct ssi_drvdata *drvdata,
 	}
 
 	if (mapped_nents == 1 && areq_ctx->ccm_hdr_size == ccm_header_size_null)
-		areq_ctx->assoc_buff_type = SSI_DMA_BUF_DLLI;
+		areq_ctx->assoc_buff_type = CC_DMA_BUF_DLLI;
 	else
-		areq_ctx->assoc_buff_type = SSI_DMA_BUF_MLLI;
+		areq_ctx->assoc_buff_type = CC_DMA_BUF_MLLI;
 
-	if (do_chain || areq_ctx->assoc_buff_type == SSI_DMA_BUF_MLLI) {
+	if (do_chain || areq_ctx->assoc_buff_type == CC_DMA_BUF_MLLI) {
 		dev_dbg(dev, "Chain assoc: buff_type=%s nents=%u\n",
 			cc_dma_buf_type(areq_ctx->assoc_buff_type),
 			areq_ctx->assoc.nents);
 		cc_add_sg_entry(dev, sg_data, areq_ctx->assoc.nents, req->src,
 				req->assoclen, 0, is_last,
 				&areq_ctx->assoc.mlli_nents);
-		areq_ctx->assoc_buff_type = SSI_DMA_BUF_MLLI;
+		areq_ctx->assoc_buff_type = CC_DMA_BUF_MLLI;
 	}
 
 chain_assoc_exit:
@@ -939,7 +939,7 @@ static int cc_prepare_aead_data_mlli(struct ssi_drvdata *drvdata,
 				 * we must neglect this code.
 				 */
 				if (!drvdata->coherent)
-					cc_copy_mac(dev, req, SSI_SG_TO_BUF);
+					cc_copy_mac(dev, req, CC_SG_TO_BUF);
 
 				areq_ctx->icv_virt_addr = areq_ctx->backup_mac;
 			} else {
@@ -981,7 +981,7 @@ static int cc_prepare_aead_data_mlli(struct ssi_drvdata *drvdata,
 		 * MAC verification upon request completion
 		 */
 		if (areq_ctx->is_icv_fragmented) {
-			cc_copy_mac(dev, req, SSI_SG_TO_BUF);
+			cc_copy_mac(dev, req, CC_SG_TO_BUF);
 			areq_ctx->icv_virt_addr = areq_ctx->backup_mac;
 
 		} else { /* Contig. ICV */
@@ -1136,12 +1136,12 @@ static int cc_aead_chain_data(struct ssi_drvdata *drvdata,
 	if (src_mapped_nents > 1 ||
 	    dst_mapped_nents  > 1 ||
 	    do_chain) {
-		areq_ctx->data_buff_type = SSI_DMA_BUF_MLLI;
+		areq_ctx->data_buff_type = CC_DMA_BUF_MLLI;
 		rc = cc_prepare_aead_data_mlli(drvdata, req, sg_data,
 					       &src_last_bytes,
 					       &dst_last_bytes, is_last_table);
 	} else {
-		areq_ctx->data_buff_type = SSI_DMA_BUF_DLLI;
+		areq_ctx->data_buff_type = CC_DMA_BUF_DLLI;
 		cc_prepare_aead_data_dlli(req, &src_last_bytes,
 					  &dst_last_bytes);
 	}
@@ -1156,13 +1156,13 @@ static void cc_update_aead_mlli_nents(struct ssi_drvdata *drvdata,
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	u32 curr_mlli_size = 0;
 
-	if (areq_ctx->assoc_buff_type == SSI_DMA_BUF_MLLI) {
+	if (areq_ctx->assoc_buff_type == CC_DMA_BUF_MLLI) {
 		areq_ctx->assoc.sram_addr = drvdata->mlli_sram_addr;
 		curr_mlli_size = areq_ctx->assoc.mlli_nents *
 						LLI_ENTRY_BYTE_SIZE;
 	}
 
-	if (areq_ctx->data_buff_type == SSI_DMA_BUF_MLLI) {
+	if (areq_ctx->data_buff_type == CC_DMA_BUF_MLLI) {
 		/*Inplace case dst nents equal to src nents*/
 		if (req->src == req->dst) {
 			areq_ctx->dst.mlli_nents = areq_ctx->src.mlli_nents;
@@ -1226,7 +1226,7 @@ int cc_map_aead_request(struct ssi_drvdata *drvdata, struct aead_request *req)
 	if (drvdata->coherent &&
 	    areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT &&
 	    req->src == req->dst)
-		cc_copy_mac(dev, req, SSI_SG_TO_BUF);
+		cc_copy_mac(dev, req, CC_SG_TO_BUF);
 
 	/* cacluate the size for cipher remove ICV in decrypt*/
 	areq_ctx->cryptlen = (areq_ctx->gen_ctx.op_type ==
@@ -1380,8 +1380,8 @@ int cc_map_aead_request(struct ssi_drvdata *drvdata, struct aead_request *req)
 	/* Mlli support -start building the MLLI according to the above
 	 * results
 	 */
-	if (areq_ctx->assoc_buff_type == SSI_DMA_BUF_MLLI ||
-	    areq_ctx->data_buff_type == SSI_DMA_BUF_MLLI) {
+	if (areq_ctx->assoc_buff_type == CC_DMA_BUF_MLLI ||
+	    areq_ctx->data_buff_type == CC_DMA_BUF_MLLI) {
 		mlli_params->curr_pool = buff_mgr->mlli_buffs_pool;
 		rc = cc_generate_mlli(dev, &sg_data, mlli_params);
 		if (rc)
@@ -1419,7 +1419,7 @@ int cc_map_hash_request_final(struct ssi_drvdata *drvdata, void *ctx,
 	dev_dbg(dev, "final params : curr_buff=%pK curr_buff_cnt=0x%X nbytes = 0x%X src=%pK curr_index=%u\n",
 		curr_buff, *curr_buff_cnt, nbytes, src, areq_ctx->buff_index);
 	/* Init the type of the dma buffer */
-	areq_ctx->data_dma_buf_type = SSI_DMA_BUF_NULL;
+	areq_ctx->data_dma_buf_type = CC_DMA_BUF_NULL;
 	mlli_params->curr_pool = NULL;
 	sg_data.num_of_buffers = 0;
 	areq_ctx->in_nents = 0;
@@ -1445,19 +1445,19 @@ int cc_map_hash_request_final(struct ssi_drvdata *drvdata, void *ctx,
 			goto unmap_curr_buff;
 		}
 		if (src && mapped_nents == 1 &&
-		    areq_ctx->data_dma_buf_type == SSI_DMA_BUF_NULL) {
+		    areq_ctx->data_dma_buf_type == CC_DMA_BUF_NULL) {
 			memcpy(areq_ctx->buff_sg, src,
 			       sizeof(struct scatterlist));
 			areq_ctx->buff_sg->length = nbytes;
 			areq_ctx->curr_sg = areq_ctx->buff_sg;
-			areq_ctx->data_dma_buf_type = SSI_DMA_BUF_DLLI;
+			areq_ctx->data_dma_buf_type = CC_DMA_BUF_DLLI;
 		} else {
-			areq_ctx->data_dma_buf_type = SSI_DMA_BUF_MLLI;
+			areq_ctx->data_dma_buf_type = CC_DMA_BUF_MLLI;
 		}
 	}
 
 	/*build mlli */
-	if (areq_ctx->data_dma_buf_type == SSI_DMA_BUF_MLLI) {
+	if (areq_ctx->data_dma_buf_type == CC_DMA_BUF_MLLI) {
 		mlli_params->curr_pool = buff_mgr->mlli_buffs_pool;
 		/* add the src data to the sg_data */
 		cc_add_sg_entry(dev, &sg_data, areq_ctx->in_nents, src, nbytes,
@@ -1507,7 +1507,7 @@ int cc_map_hash_request_update(struct ssi_drvdata *drvdata, void *ctx,
 	dev_dbg(dev, " update params : curr_buff=%pK curr_buff_cnt=0x%X nbytes=0x%X src=%pK curr_index=%u\n",
 		curr_buff, *curr_buff_cnt, nbytes, src, areq_ctx->buff_index);
 	/* Init the type of the dma buffer */
-	areq_ctx->data_dma_buf_type = SSI_DMA_BUF_NULL;
+	areq_ctx->data_dma_buf_type = CC_DMA_BUF_NULL;
 	mlli_params->curr_pool = NULL;
 	areq_ctx->curr_sg = NULL;
 	sg_data.num_of_buffers = 0;
@@ -1539,7 +1539,7 @@ int cc_map_hash_request_update(struct ssi_drvdata *drvdata, void *ctx,
 			*next_buff_cnt);
 		cc_copy_sg_portion(dev, next_buff, src,
 				   (update_data_len - *curr_buff_cnt),
-				   nbytes, SSI_SG_TO_BUF);
+				   nbytes, CC_SG_TO_BUF);
 		/* change the buffer index for next operation */
 		swap_index = 1;
 	}
@@ -1561,19 +1561,19 @@ int cc_map_hash_request_update(struct ssi_drvdata *drvdata, void *ctx,
 			goto unmap_curr_buff;
 		}
 		if (mapped_nents == 1 &&
-		    areq_ctx->data_dma_buf_type == SSI_DMA_BUF_NULL) {
+		    areq_ctx->data_dma_buf_type == CC_DMA_BUF_NULL) {
 			/* only one entry in the SG and no previous data */
 			memcpy(areq_ctx->buff_sg, src,
 			       sizeof(struct scatterlist));
 			areq_ctx->buff_sg->length = update_data_len;
-			areq_ctx->data_dma_buf_type = SSI_DMA_BUF_DLLI;
+			areq_ctx->data_dma_buf_type = CC_DMA_BUF_DLLI;
 			areq_ctx->curr_sg = areq_ctx->buff_sg;
 		} else {
-			areq_ctx->data_dma_buf_type = SSI_DMA_BUF_MLLI;
+			areq_ctx->data_dma_buf_type = CC_DMA_BUF_MLLI;
 		}
 	}
 
-	if (areq_ctx->data_dma_buf_type == SSI_DMA_BUF_MLLI) {
+	if (areq_ctx->data_dma_buf_type == CC_DMA_BUF_MLLI) {
 		mlli_params->curr_pool = buff_mgr->mlli_buffs_pool;
 		/* add the src data to the sg_data */
 		cc_add_sg_entry(dev, &sg_data, areq_ctx->in_nents, src,
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.h b/drivers/staging/ccree/ssi_buffer_mgr.h
index f6411de..77744a6 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.h
+++ b/drivers/staging/ccree/ssi_buffer_mgr.h
@@ -18,8 +18,8 @@
  * Buffer Manager
  */
 
-#ifndef __SSI_BUFFER_MGR_H__
-#define __SSI_BUFFER_MGR_H__
+#ifndef __CC_BUFFER_MGR_H__
+#define __CC_BUFFER_MGR_H__
 
 #include <crypto/algapi.h>
 
@@ -27,14 +27,14 @@
 #include "ssi_driver.h"
 
 enum ssi_req_dma_buf_type {
-	SSI_DMA_BUF_NULL = 0,
-	SSI_DMA_BUF_DLLI,
-	SSI_DMA_BUF_MLLI
+	CC_DMA_BUF_NULL = 0,
+	CC_DMA_BUF_DLLI,
+	CC_DMA_BUF_MLLI
 };
 
 enum ssi_sg_cpy_direct {
-	SSI_SG_TO_BUF = 0,
-	SSI_SG_FROM_BUF = 1
+	CC_SG_TO_BUF = 0,
+	CC_SG_FROM_BUF = 1
 };
 
 struct ssi_mlli {
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 299e73a..c437a79 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -541,7 +541,7 @@ static void cc_setup_cipher_data(struct crypto_tfm *tfm,
 		return;
 	}
 	/* Process */
-	if (req_ctx->dma_buf_type == SSI_DMA_BUF_DLLI) {
+	if (req_ctx->dma_buf_type == CC_DMA_BUF_DLLI) {
 		dev_dbg(dev, " data params addr %pad length 0x%X\n",
 			&sg_dma_address(src), nbytes);
 		dev_dbg(dev, " data params addr %pad length 0x%X\n",
@@ -1091,7 +1091,7 @@ struct ssi_crypto_alg *cc_cipher_create_alg(struct ssi_alg_template *template,
 	snprintf(alg->cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
 		 template->driver_name);
 	alg->cra_module = THIS_MODULE;
-	alg->cra_priority = SSI_CRA_PRIO;
+	alg->cra_priority = CC_CRA_PRIO;
 	alg->cra_blocksize = template->blocksize;
 	alg->cra_alignmask = 0;
 	alg->cra_ctxsize = sizeof(struct cc_cipher_ctx);
diff --git a/drivers/staging/ccree/ssi_cipher.h b/drivers/staging/ccree/ssi_cipher.h
index ef6d6e9..977b543 100644
--- a/drivers/staging/ccree/ssi_cipher.h
+++ b/drivers/staging/ccree/ssi_cipher.h
@@ -18,8 +18,8 @@
  * ARM CryptoCell Cipher Crypto API
  */
 
-#ifndef __SSI_CIPHER_H__
-#define __SSI_CIPHER_H__
+#ifndef __CC_CIPHER_H__
+#define __CC_CIPHER_H__
 
 #include <linux/kernel.h>
 #include <crypto/algapi.h>
@@ -84,4 +84,4 @@ static inline bool cc_is_hw_key(struct crypto_tfm *tfm)
 
 #endif /* CRYPTO_TFM_REQ_HW_KEY */
 
-#endif /*__SSI_CIPHER_H__*/
+#endif /*__CC_CIPHER_H__*/
diff --git a/drivers/staging/ccree/ssi_config.h b/drivers/staging/ccree/ssi_config.h
index ea74845..e97bc68 100644
--- a/drivers/staging/ccree/ssi_config.h
+++ b/drivers/staging/ccree/ssi_config.h
@@ -18,8 +18,8 @@
  * Definitions for ARM CryptoCell Linux Crypto Driver
  */
 
-#ifndef __SSI_CONFIG_H__
-#define __SSI_CONFIG_H__
+#ifndef __CC_CONFIG_H__
+#define __CC_CONFIG_H__
 
 #include <linux/version.h>
 
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index f4164eb..dce12e1 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -110,27 +110,27 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 
 	drvdata->irq = irr;
 	/* Completion interrupt - most probable */
-	if (irr & SSI_COMP_IRQ_MASK) {
+	if (irr & CC_COMP_IRQ_MASK) {
 		/* Mask AXI completion interrupt - will be unmasked in
 		 * Deferred service handler
 		 */
-		cc_iowrite(drvdata, CC_REG(HOST_IMR), imr | SSI_COMP_IRQ_MASK);
-		irr &= ~SSI_COMP_IRQ_MASK;
+		cc_iowrite(drvdata, CC_REG(HOST_IMR), imr | CC_COMP_IRQ_MASK);
+		irr &= ~CC_COMP_IRQ_MASK;
 		complete_request(drvdata);
 	}
 #ifdef CC_SUPPORT_FIPS
 	/* TEE FIPS interrupt */
-	if (irr & SSI_GPR0_IRQ_MASK) {
+	if (irr & CC_GPR0_IRQ_MASK) {
 		/* Mask interrupt - will be unmasked in Deferred service
 		 * handler
 		 */
-		cc_iowrite(drvdata, CC_REG(HOST_IMR), imr | SSI_GPR0_IRQ_MASK);
-		irr &= ~SSI_GPR0_IRQ_MASK;
+		cc_iowrite(drvdata, CC_REG(HOST_IMR), imr | CC_GPR0_IRQ_MASK);
+		irr &= ~CC_GPR0_IRQ_MASK;
 		fips_handler(drvdata);
 	}
 #endif
 	/* AXI error interrupt */
-	if (irr & SSI_AXI_ERR_IRQ_MASK) {
+	if (irr & CC_AXI_ERR_IRQ_MASK) {
 		u32 axi_err;
 
 		/* Read the AXI error ID */
@@ -138,7 +138,7 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 		dev_dbg(dev, "AXI completion error: axim_mon_err=0x%08X\n",
 			axi_err);
 
-		irr &= ~SSI_AXI_ERR_IRQ_MASK;
+		irr &= ~CC_AXI_ERR_IRQ_MASK;
 	}
 
 	if (irr) {
@@ -157,7 +157,7 @@ int init_cc_regs(struct ssi_drvdata *drvdata, bool is_probe)
 
 	/* Unmask all AXI interrupt sources AXI_CFG1 register */
 	val = cc_ioread(drvdata, CC_REG(AXIM_CFG));
-	cc_iowrite(drvdata, CC_REG(AXIM_CFG), val & ~SSI_AXI_IRQ_MASK);
+	cc_iowrite(drvdata, CC_REG(AXIM_CFG), val & ~CC_AXI_IRQ_MASK);
 	dev_dbg(dev, "AXIM_CFG=0x%08X\n",
 		cc_ioread(drvdata, CC_REG(AXIM_CFG)));
 
@@ -167,8 +167,8 @@ int init_cc_regs(struct ssi_drvdata *drvdata, bool is_probe)
 	cc_iowrite(drvdata, CC_REG(HOST_ICR), val);
 
 	/* Unmask relevant interrupt cause */
-	val = (unsigned int)(~(SSI_COMP_IRQ_MASK | SSI_AXI_ERR_IRQ_MASK |
-			       SSI_GPR0_IRQ_MASK));
+	val = (unsigned int)(~(CC_COMP_IRQ_MASK | CC_AXI_ERR_IRQ_MASK |
+			       CC_GPR0_IRQ_MASK));
 	cc_iowrite(drvdata, CC_REG(HOST_IMR), val);
 
 #ifdef DX_HOST_IRQ_TIMER_INIT_VAL_REG_OFFSET
@@ -289,7 +289,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 
 	/* Display HW versions */
 	dev_info(dev, "ARM CryptoCell %s Driver: HW version 0x%08X, Driver version %s\n",
-		 SSI_DEV_NAME_STR,
+		 CC_DEV_NAME_STR,
 		 cc_ioread(new_drvdata, CC_REG(HOST_VERSION)),
 		 DRV_MODULE_VERSION);
 
@@ -309,7 +309,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 
 	rc = ssi_fips_init(new_drvdata);
 	if (rc) {
-		dev_err(dev, "SSI_FIPS_INIT failed 0x%x\n", rc);
+		dev_err(dev, "CC_FIPS_INIT failed 0x%x\n", rc);
 		goto post_sysfs_err;
 	}
 	rc = ssi_sram_mgr_init(new_drvdata);
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index c9fdb89..3d4513b 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -18,8 +18,8 @@
  * ARM CryptoCell Linux Crypto Driver
  */
 
-#ifndef __SSI_DRIVER_H__
-#define __SSI_DRIVER_H__
+#ifndef __CC_DRIVER_H__
+#define __CC_DRIVER_H__
 
 #include "ssi_config.h"
 #ifdef COMP_IN_WQ
@@ -51,17 +51,17 @@
 
 #define DRV_MODULE_VERSION "3.0"
 
-#define SSI_DEV_NAME_STR "cc715ree"
+#define CC_DEV_NAME_STR "cc715ree"
 #define CC_COHERENT_CACHE_PARAMS 0xEEE
 
-#define SSI_AXI_IRQ_MASK ((1 << DX_AXIM_CFG_BRESPMASK_BIT_SHIFT) | \
+#define CC_AXI_IRQ_MASK ((1 << DX_AXIM_CFG_BRESPMASK_BIT_SHIFT) | \
 			  (1 << DX_AXIM_CFG_RRESPMASK_BIT_SHIFT) | \
 			  (1 << DX_AXIM_CFG_INFLTMASK_BIT_SHIFT) | \
 			  (1 << DX_AXIM_CFG_COMPMASK_BIT_SHIFT))
 
-#define SSI_AXI_ERR_IRQ_MASK BIT(DX_HOST_IRR_AXI_ERR_INT_BIT_SHIFT)
+#define CC_AXI_ERR_IRQ_MASK BIT(DX_HOST_IRR_AXI_ERR_INT_BIT_SHIFT)
 
-#define SSI_COMP_IRQ_MASK BIT(DX_HOST_IRR_AXIM_COMP_INT_BIT_SHIFT)
+#define CC_COMP_IRQ_MASK BIT(DX_HOST_IRR_AXIM_COMP_INT_BIT_SHIFT)
 
 #define AXIM_MON_COMP_VALUE GENMASK(DX_AXIM_MON_COMP_VALUE_BIT_SIZE + \
 				    DX_AXIM_MON_COMP_VALUE_BIT_SHIFT, \
@@ -71,9 +71,9 @@
 #define CC_REG(reg_name) DX_ ## reg_name ## _REG_OFFSET
 
 /* TEE FIPS status interrupt */
-#define SSI_GPR0_IRQ_MASK BIT(DX_HOST_IRR_GPR0_BIT_SHIFT)
+#define CC_GPR0_IRQ_MASK BIT(DX_HOST_IRR_GPR0_BIT_SHIFT)
 
-#define SSI_CRA_PRIO 3000
+#define CC_CRA_PRIO 3000
 
 #define MIN_HW_QUEUE_SIZE 50 /* Minimum size required for proper function */
 
@@ -88,11 +88,11 @@
  * field in the HW descriptor. The DMA engine +8 that value.
  */
 
-#define SSI_MAX_IVGEN_DMA_ADDRESSES	3
+#define CC_MAX_IVGEN_DMA_ADDRESSES	3
 struct ssi_crypto_req {
 	void (*user_cb)(struct device *dev, void *req);
 	void *user_arg;
-	dma_addr_t ivgen_dma_addr[SSI_MAX_IVGEN_DMA_ADDRESSES];
+	dma_addr_t ivgen_dma_addr[CC_MAX_IVGEN_DMA_ADDRESSES];
 	/* For the first 'ivgen_dma_addr_len' addresses of this array,
 	 * generated IV would be placed in it by send_request().
 	 * Same generated IV for all addresses!
@@ -192,5 +192,5 @@ static inline u32 cc_ioread(struct ssi_drvdata *drvdata, u32 reg)
 	return ioread32(drvdata->cc_base + reg);
 }
 
-#endif /*__SSI_DRIVER_H__*/
+#endif /*__CC_DRIVER_H__*/
 
diff --git a/drivers/staging/ccree/ssi_fips.c b/drivers/staging/ccree/ssi_fips.c
index 4aea99f..273b414 100644
--- a/drivers/staging/ccree/ssi_fips.c
+++ b/drivers/staging/ccree/ssi_fips.c
@@ -88,7 +88,7 @@ static void fips_dsr(unsigned long devarg)
 	struct device *dev = drvdata_to_dev(drvdata);
 	u32 irq, state, val;
 
-	irq = (drvdata->irq & (SSI_GPR0_IRQ_MASK));
+	irq = (drvdata->irq & (CC_GPR0_IRQ_MASK));
 
 	if (irq) {
 		state = cc_ioread(drvdata, CC_REG(GPR_HOST));
diff --git a/drivers/staging/ccree/ssi_fips.h b/drivers/staging/ccree/ssi_fips.h
index 8cb1893..1889c74 100644
--- a/drivers/staging/ccree/ssi_fips.h
+++ b/drivers/staging/ccree/ssi_fips.h
@@ -14,8 +14,8 @@
  * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
-#ifndef __SSI_FIPS_H__
-#define __SSI_FIPS_H__
+#ifndef __CC_FIPS_H__
+#define __CC_FIPS_H__
 
 #ifdef CONFIG_CRYPTO_FIPS
 
@@ -46,5 +46,5 @@ static inline void fips_handler(struct ssi_drvdata *drvdata) {}
 
 #endif /* CONFIG_CRYPTO_FIPS */
 
-#endif  /*__SSI_FIPS_H__*/
+#endif  /*__CC_FIPS_H__*/
 
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 10c73ef..7458c24 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -1988,7 +1988,7 @@ static struct cc_hash_alg *cc_alloc_hash_alg(struct cc_hash_template *template,
 	}
 	alg->cra_module = THIS_MODULE;
 	alg->cra_ctxsize = sizeof(struct cc_hash_ctx);
-	alg->cra_priority = SSI_CRA_PRIO;
+	alg->cra_priority = CC_CRA_PRIO;
 	alg->cra_blocksize = template->blocksize;
 	alg->cra_alignmask = 0;
 	alg->cra_exit = cc_cra_exit;
@@ -2345,7 +2345,7 @@ static void cc_set_desc(struct ahash_req_ctx *areq_ctx,
 	unsigned int idx = *seq_size;
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 
-	if (areq_ctx->data_dma_buf_type == SSI_DMA_BUF_DLLI) {
+	if (areq_ctx->data_dma_buf_type == CC_DMA_BUF_DLLI) {
 		hw_desc_init(&desc[idx]);
 		set_din_type(&desc[idx], DMA_DLLI,
 			     sg_dma_address(areq_ctx->curr_sg),
@@ -2353,7 +2353,7 @@ static void cc_set_desc(struct ahash_req_ctx *areq_ctx,
 		set_flow_mode(&desc[idx], flow_mode);
 		idx++;
 	} else {
-		if (areq_ctx->data_dma_buf_type == SSI_DMA_BUF_NULL) {
+		if (areq_ctx->data_dma_buf_type == CC_DMA_BUF_NULL) {
 			dev_dbg(dev, " NULL mode\n");
 			/* nothing to build */
 			return;
diff --git a/drivers/staging/ccree/ssi_hash.h b/drivers/staging/ccree/ssi_hash.h
index ade4119..19fc4cf 100644
--- a/drivers/staging/ccree/ssi_hash.h
+++ b/drivers/staging/ccree/ssi_hash.h
@@ -18,8 +18,8 @@
  * ARM CryptoCell Hash Crypto API
  */
 
-#ifndef __SSI_HASH_H__
-#define __SSI_HASH_H__
+#ifndef __CC_HASH_H__
+#define __CC_HASH_H__
 
 #include "ssi_buffer_mgr.h"
 
@@ -103,5 +103,5 @@ cc_digest_len_addr(void *drvdata, u32 mode);
  */
 ssi_sram_addr_t cc_larval_digest_addr(void *drvdata, u32 mode);
 
-#endif /*__SSI_HASH_H__*/
+#endif /*__CC_HASH_H__*/
 
diff --git a/drivers/staging/ccree/ssi_ivgen.c b/drivers/staging/ccree/ssi_ivgen.c
index c499361..d362bf6 100644
--- a/drivers/staging/ccree/ssi_ivgen.c
+++ b/drivers/staging/ccree/ssi_ivgen.c
@@ -62,7 +62,7 @@ static int cc_gen_iv_pool(struct cc_ivgen_ctx *ivgen_ctx,
 {
 	unsigned int idx = *iv_seq_len;
 
-	if ((*iv_seq_len + CC_IVPOOL_GEN_SEQ_LEN) > SSI_IVPOOL_SEQ_LEN) {
+	if ((*iv_seq_len + CC_IVPOOL_GEN_SEQ_LEN) > CC_IVPOOL_SEQ_LEN) {
 		/* The sequence will be longer than allowed */
 		return -EINVAL;
 	}
@@ -119,7 +119,7 @@ static int cc_gen_iv_pool(struct cc_ivgen_ctx *ivgen_ctx,
 int cc_init_iv_sram(struct ssi_drvdata *drvdata)
 {
 	struct cc_ivgen_ctx *ivgen_ctx = drvdata->ivgen_handle;
-	struct cc_hw_desc iv_seq[SSI_IVPOOL_SEQ_LEN];
+	struct cc_hw_desc iv_seq[CC_IVPOOL_SEQ_LEN];
 	unsigned int iv_seq_len = 0;
 	int rc;
 
@@ -247,7 +247,7 @@ int cc_get_iv(struct ssi_drvdata *drvdata, dma_addr_t iv_out_dma[],
 	    iv_out_size != CTR_RFC3686_IV_SIZE) {
 		return -EINVAL;
 	}
-	if ((iv_out_dma_len + 1) > SSI_IVPOOL_SEQ_LEN) {
+	if ((iv_out_dma_len + 1) > CC_IVPOOL_SEQ_LEN) {
 		/* The sequence will be longer than allowed */
 		return -EINVAL;
 	}
@@ -255,7 +255,7 @@ int cc_get_iv(struct ssi_drvdata *drvdata, dma_addr_t iv_out_dma[],
 	/* check that number of generated IV is limited to max dma address
 	 * iv buffer size
 	 */
-	if (iv_out_dma_len > SSI_MAX_IVGEN_DMA_ADDRESSES) {
+	if (iv_out_dma_len > CC_MAX_IVGEN_DMA_ADDRESSES) {
 		/* The sequence will be longer than allowed */
 		return -EINVAL;
 	}
diff --git a/drivers/staging/ccree/ssi_ivgen.h b/drivers/staging/ccree/ssi_ivgen.h
index bbd0245..9890f62 100644
--- a/drivers/staging/ccree/ssi_ivgen.h
+++ b/drivers/staging/ccree/ssi_ivgen.h
@@ -14,12 +14,12 @@
  * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
-#ifndef __SSI_IVGEN_H__
-#define __SSI_IVGEN_H__
+#ifndef __CC_IVGEN_H__
+#define __CC_IVGEN_H__
 
 #include "cc_hw_queue_defs.h"
 
-#define SSI_IVPOOL_SEQ_LEN 8
+#define CC_IVPOOL_SEQ_LEN 8
 
 /*!
  * Allocates iv-pool and maps resources.
@@ -65,4 +65,4 @@ int cc_get_iv(struct ssi_drvdata *drvdata, dma_addr_t iv_out_dma[],
 	      unsigned int iv_out_dma_len, unsigned int iv_out_size,
 	      struct cc_hw_desc iv_seq[], unsigned int *iv_seq_len);
 
-#endif /*__SSI_IVGEN_H__*/
+#endif /*__CC_IVGEN_H__*/
diff --git a/drivers/staging/ccree/ssi_pm.c b/drivers/staging/ccree/ssi_pm.c
index f0e3baf..e387d46 100644
--- a/drivers/staging/ccree/ssi_pm.c
+++ b/drivers/staging/ccree/ssi_pm.c
@@ -123,7 +123,7 @@ int cc_pm_init(struct ssi_drvdata *drvdata)
 	struct device *dev = drvdata_to_dev(drvdata);
 
 	/* must be before the enabling to avoid resdundent suspending */
-	pm_runtime_set_autosuspend_delay(dev, SSI_SUSPEND_TIMEOUT);
+	pm_runtime_set_autosuspend_delay(dev, CC_SUSPEND_TIMEOUT);
 	pm_runtime_use_autosuspend(dev);
 	/* activate the PM module */
 	rc = pm_runtime_set_active(dev);
diff --git a/drivers/staging/ccree/ssi_pm.h b/drivers/staging/ccree/ssi_pm.h
index 50bcf03..940ef2d 100644
--- a/drivers/staging/ccree/ssi_pm.h
+++ b/drivers/staging/ccree/ssi_pm.h
@@ -17,13 +17,13 @@
 /* \file ssi_pm.h
  */
 
-#ifndef __SSI_POWER_MGR_H__
-#define __SSI_POWER_MGR_H__
+#ifndef __CC_POWER_MGR_H__
+#define __CC_POWER_MGR_H__
 
 #include "ssi_config.h"
 #include "ssi_driver.h"
 
-#define SSI_SUSPEND_TIMEOUT 3000
+#define CC_SUSPEND_TIMEOUT 3000
 
 int cc_pm_init(struct ssi_drvdata *drvdata);
 
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index 3d25b72..436e035 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -31,7 +31,7 @@
 #include "ssi_ivgen.h"
 #include "ssi_pm.h"
 
-#define SSI_MAX_POLL_ITER	10
+#define CC_MAX_POLL_ITER	10
 
 struct cc_req_mgr_handle {
 	/* Request manager resources */
@@ -223,7 +223,7 @@ static int cc_queues_status(struct ssi_drvdata *drvdata,
 		return 0;
 
 	/* Wait for space in HW queue. Poll constant num of iterations. */
-	for (poll_queue = 0; poll_queue < SSI_MAX_POLL_ITER ; poll_queue++) {
+	for (poll_queue = 0; poll_queue < CC_MAX_POLL_ITER ; poll_queue++) {
 		req_mgr_h->q_free_slots =
 			cc_ioread(drvdata, CC_REG(DSCRPTR_QUEUE_CONTENT));
 		if (req_mgr_h->q_free_slots < req_mgr_h->min_free_hw_slots)
@@ -265,13 +265,13 @@ int send_request(struct ssi_drvdata *drvdata, struct ssi_crypto_req *ssi_req,
 	unsigned int used_sw_slots;
 	unsigned int iv_seq_len = 0;
 	unsigned int total_seq_len = len; /*initial sequence length*/
-	struct cc_hw_desc iv_seq[SSI_IVPOOL_SEQ_LEN];
+	struct cc_hw_desc iv_seq[CC_IVPOOL_SEQ_LEN];
 	struct device *dev = drvdata_to_dev(drvdata);
 	int rc;
 	unsigned int max_required_seq_len =
 		(total_seq_len +
 		 ((ssi_req->ivgen_dma_addr_len == 0) ? 0 :
-		  SSI_IVPOOL_SEQ_LEN) + (!is_dout ? 1 : 0));
+		  CC_IVPOOL_SEQ_LEN) + (!is_dout ? 1 : 0));
 
 #if defined(CONFIG_PM)
 	rc = cc_pm_get(dev);
@@ -541,13 +541,13 @@ static void comp_handler(unsigned long devarg)
 
 	u32 irq;
 
-	irq = (drvdata->irq & SSI_COMP_IRQ_MASK);
+	irq = (drvdata->irq & CC_COMP_IRQ_MASK);
 
-	if (irq & SSI_COMP_IRQ_MASK) {
+	if (irq & CC_COMP_IRQ_MASK) {
 		/* To avoid the interrupt from firing as we unmask it,
 		 * we clear it now
 		 */
-		cc_iowrite(drvdata, CC_REG(HOST_ICR), SSI_COMP_IRQ_MASK);
+		cc_iowrite(drvdata, CC_REG(HOST_ICR), CC_COMP_IRQ_MASK);
 
 		/* Avoid race with above clear: Test completion counter
 		 * once more
@@ -566,7 +566,7 @@ static void comp_handler(unsigned long devarg)
 			} while (request_mgr_handle->axi_completed > 0);
 
 			cc_iowrite(drvdata, CC_REG(HOST_ICR),
-				   SSI_COMP_IRQ_MASK);
+				   CC_COMP_IRQ_MASK);
 
 			request_mgr_handle->axi_completed +=
 					cc_axi_comp_count(drvdata);
diff --git a/drivers/staging/ccree/ssi_sram_mgr.c b/drivers/staging/ccree/ssi_sram_mgr.c
index 0704031..cbe5e3b 100644
--- a/drivers/staging/ccree/ssi_sram_mgr.c
+++ b/drivers/staging/ccree/ssi_sram_mgr.c
@@ -80,7 +80,7 @@ ssi_sram_addr_t cc_sram_alloc(struct ssi_drvdata *drvdata, u32 size)
 			size);
 		return NULL_SRAM_ADDR;
 	}
-	if (size > (SSI_CC_SRAM_SIZE - smgr_ctx->sram_free_offset)) {
+	if (size > (CC_CC_SRAM_SIZE - smgr_ctx->sram_free_offset)) {
 		dev_err(dev, "Not enough space to allocate %u B (at offset %llu)\n",
 			size, smgr_ctx->sram_free_offset);
 		return NULL_SRAM_ADDR;
diff --git a/drivers/staging/ccree/ssi_sram_mgr.h b/drivers/staging/ccree/ssi_sram_mgr.h
index 76719ec..fdd325b 100644
--- a/drivers/staging/ccree/ssi_sram_mgr.h
+++ b/drivers/staging/ccree/ssi_sram_mgr.h
@@ -14,11 +14,11 @@
  * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
-#ifndef __SSI_SRAM_MGR_H__
-#define __SSI_SRAM_MGR_H__
+#ifndef __CC_SRAM_MGR_H__
+#define __CC_SRAM_MGR_H__
 
-#ifndef SSI_CC_SRAM_SIZE
-#define SSI_CC_SRAM_SIZE 4096
+#ifndef CC_CC_SRAM_SIZE
+#define CC_CC_SRAM_SIZE 4096
 #endif
 
 struct ssi_drvdata;
@@ -75,4 +75,4 @@ void cc_set_sram_desc(const u32 *src, ssi_sram_addr_t dst,
 		      unsigned int nelement, struct cc_hw_desc *seq,
 		      unsigned int *seq_len);
 
-#endif /*__SSI_SRAM_MGR_H__*/
+#endif /*__CC_SRAM_MGR_H__*/
diff --git a/drivers/staging/ccree/ssi_sysfs.h b/drivers/staging/ccree/ssi_sysfs.h
index 5124528..de68bc6 100644
--- a/drivers/staging/ccree/ssi_sysfs.h
+++ b/drivers/staging/ccree/ssi_sysfs.h
@@ -18,8 +18,8 @@
  * ARM CryptoCell sysfs APIs
  */
 
-#ifndef __SSI_SYSFS_H__
-#define __SSI_SYSFS_H__
+#ifndef __CC_SYSFS_H__
+#define __CC_SYSFS_H__
 
 #include <asm/timex.h>
 
@@ -29,4 +29,4 @@ struct ssi_drvdata;
 int ssi_sysfs_init(struct kobject *sys_dev_obj, struct ssi_drvdata *drvdata);
 void ssi_sysfs_fini(void);
 
-#endif /*__SSI_SYSFS_H__*/
+#endif /*__CC_SYSFS_H__*/
-- 
2.7.4
