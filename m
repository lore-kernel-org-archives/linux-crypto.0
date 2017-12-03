From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 02/10] staging: ccree: remove unproven likely/unlikely
Date: Sun,  3 Dec 2017 13:58:13 +0000
Message-ID: <1512309503-29766-3-git-send-email-gilad@benyossef.com>
References: <1512309503-29766-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:55150 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752362AbdLCN7Z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 3 Dec 2017 08:59:25 -0500
In-Reply-To: <1512309503-29766-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The ccree code made a lot of use of likely/unlikely qualifiers without
proven measurements showing any benefits. Remove them all until we
see what is justified and what is not.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c        |  57 ++++++------
 drivers/staging/ccree/ssi_buffer_mgr.c  | 154 +++++++++++++++-----------------
 drivers/staging/ccree/ssi_cipher.c      |  54 +++++------
 drivers/staging/ccree/ssi_driver.c      |  34 +++----
 drivers/staging/ccree/ssi_hash.c        | 103 ++++++++++-----------
 drivers/staging/ccree/ssi_ivgen.c       |   2 +-
 drivers/staging/ccree/ssi_request_mgr.c |  28 +++---
 drivers/staging/ccree/ssi_sram_mgr.c    |   4 +-
 8 files changed, 209 insertions(+), 227 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 56a4059..0b085dc 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -251,7 +251,7 @@ static void ssi_aead_complete(struct device *dev, void *ssi_req)
 			err = -EBADMSG;
 		}
 	} else { /*ENCRYPT*/
-		if (unlikely(areq_ctx->is_icv_fragmented)) {
+		if (areq_ctx->is_icv_fragmented) {
 			u32 skip = areq->cryptlen + areq_ctx->dst_offset;
 
 			cc_copy_sg_portion(dev, areq_ctx->mac_buf,
@@ -412,7 +412,7 @@ static int validate_keys_sizes(struct ssi_aead_ctx *ctx)
 		return -EINVAL;
 	}
 	/* Check cipher key size */
-	if (unlikely(ctx->flow_mode == S_DIN_to_DES)) {
+	if (ctx->flow_mode == S_DIN_to_DES) {
 		if (ctx->enc_keylen != DES3_EDE_KEY_SIZE) {
 			dev_err(dev, "Invalid cipher(3DES) key size: %u\n",
 				ctx->enc_keylen);
@@ -465,10 +465,10 @@ ssi_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key,
 		hashmode = DRV_HASH_HW_SHA256;
 	}
 
-	if (likely(keylen != 0)) {
+	if (keylen != 0) {
 		key_dma_addr = dma_map_single(dev, (void *)key, keylen,
 					      DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(dev, key_dma_addr))) {
+		if (dma_mapping_error(dev, key_dma_addr)) {
 			dev_err(dev, "Mapping key va=0x%p len=%u for DMA failed\n",
 				key, keylen);
 			return -ENOMEM;
@@ -547,10 +547,10 @@ ssi_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key,
 	}
 
 	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 0);
-	if (unlikely(rc))
+	if (rc)
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 
-	if (likely(key_dma_addr))
+	if (key_dma_addr)
 		dma_unmap_single(dev, key_dma_addr, keylen, DMA_TO_DEVICE);
 
 	return rc;
@@ -607,7 +607,7 @@ ssi_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 	}
 
 	rc = validate_keys_sizes(ctx);
-	if (unlikely(rc))
+	if (rc)
 		goto badkey;
 
 	/* STAT_PHASE_1: Copy key to ctx */
@@ -646,7 +646,7 @@ ssi_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 
 	if (seq_len > 0) { /* For CCM there is no sequence to setup the key */
 		rc = send_request(ctx->drvdata, &ssi_req, desc, seq_len, 0);
-		if (unlikely(rc)) {
+		if (rc) {
 			dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 			goto setkey_error;
 		}
@@ -818,7 +818,7 @@ ssi_aead_process_authenc_data_desc(
 		ssi_sram_addr_t mlli_addr = areq_ctx->assoc.sram_addr;
 		u32 mlli_nents = areq_ctx->assoc.mlli_nents;
 
-		if (likely(areq_ctx->is_single_pass)) {
+		if (areq_ctx->is_single_pass) {
 			if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) {
 				mlli_addr = areq_ctx->dst.sram_addr;
 				mlli_nents = areq_ctx->dst.mlli_nents;
@@ -1202,10 +1202,9 @@ static void ssi_aead_load_mlli_to_sram(
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 
-	if (unlikely(
-		req_ctx->assoc_buff_type == SSI_DMA_BUF_MLLI ||
-		req_ctx->data_buff_type == SSI_DMA_BUF_MLLI ||
-		!req_ctx->is_single_pass)) {
+	if (req_ctx->assoc_buff_type == SSI_DMA_BUF_MLLI ||
+	    req_ctx->data_buff_type == SSI_DMA_BUF_MLLI ||
+	    !req_ctx->is_single_pass) {
 		dev_dbg(dev, "Copy-to-sram: mlli_dma=%08x, mlli_size=%u\n",
 			(unsigned int)ctx->drvdata->mlli_sram_addr,
 			req_ctx->mlli_params.mlli_len);
@@ -1231,17 +1230,17 @@ static enum cc_flow_mode ssi_aead_get_data_flow_mode(
 
 	if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) {
 		if (setup_flow_mode == S_DIN_to_AES)
-			data_flow_mode = likely(is_single_pass) ?
+			data_flow_mode = is_single_pass ?
 				AES_to_HASH_and_DOUT : DIN_AES_DOUT;
 		else
-			data_flow_mode = likely(is_single_pass) ?
+			data_flow_mode = is_single_pass ?
 				DES_to_HASH_and_DOUT : DIN_DES_DOUT;
 	} else { /* Decrypt */
 		if (setup_flow_mode == S_DIN_to_AES)
-			data_flow_mode = likely(is_single_pass) ?
+			data_flow_mode = is_single_pass ?
 					AES_and_HASH : DIN_AES_DOUT;
 		else
-			data_flow_mode = likely(is_single_pass) ?
+			data_flow_mode = is_single_pass ?
 					DES_and_HASH : DIN_DES_DOUT;
 	}
 
@@ -1367,16 +1366,16 @@ static int validate_data_size(struct ssi_aead_ctx *ctx,
 	unsigned int cipherlen = (direct == DRV_CRYPTO_DIRECTION_DECRYPT) ?
 			(req->cryptlen - ctx->authsize) : req->cryptlen;
 
-	if (unlikely(direct == DRV_CRYPTO_DIRECTION_DECRYPT &&
-		     req->cryptlen < ctx->authsize))
+	if (direct == DRV_CRYPTO_DIRECTION_DECRYPT &&
+	    req->cryptlen < ctx->authsize)
 		goto data_size_err;
 
 	areq_ctx->is_single_pass = true; /*defaulted to fast flow*/
 
 	switch (ctx->flow_mode) {
 	case S_DIN_to_AES:
-		if (unlikely(ctx->cipher_mode == DRV_CIPHER_CBC &&
-			     !IS_ALIGNED(cipherlen, AES_BLOCK_SIZE)))
+		if (ctx->cipher_mode == DRV_CIPHER_CBC &&
+		    !IS_ALIGNED(cipherlen, AES_BLOCK_SIZE))
 			goto data_size_err;
 		if (ctx->cipher_mode == DRV_CIPHER_CCM)
 			break;
@@ -1395,9 +1394,9 @@ static int validate_data_size(struct ssi_aead_ctx *ctx,
 
 		break;
 	case S_DIN_to_DES:
-		if (unlikely(!IS_ALIGNED(cipherlen, DES_BLOCK_SIZE)))
+		if (!IS_ALIGNED(cipherlen, DES_BLOCK_SIZE))
 			goto data_size_err;
-		if (unlikely(!IS_ALIGNED(assoclen, DES_BLOCK_SIZE)))
+		if (!IS_ALIGNED(assoclen, DES_BLOCK_SIZE))
 			areq_ctx->is_single_pass = false;
 		break;
 	default:
@@ -2024,7 +2023,7 @@ static int ssi_aead_process(struct aead_request *req,
 	/* STAT_PHASE_0: Init and sanity checks */
 
 	/* Check data length according to mode */
-	if (unlikely(validate_data_size(ctx, direct, req))) {
+	if (validate_data_size(ctx, direct, req)) {
 		dev_err(dev, "Unsupported crypt/assoc len %d/%d.\n",
 			req->cryptlen, req->assoclen);
 		crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_BLOCK_LEN);
@@ -2073,7 +2072,7 @@ static int ssi_aead_process(struct aead_request *req,
 #if SSI_CC_HAS_AES_CCM
 	if (ctx->cipher_mode == DRV_CIPHER_CCM) {
 		rc = config_ccm_adata(req);
-		if (unlikely(rc)) {
+		if (rc) {
 			dev_dbg(dev, "config_ccm_adata() returned with a failure %d!",
 				rc);
 			goto exit;
@@ -2088,7 +2087,7 @@ static int ssi_aead_process(struct aead_request *req,
 #if SSI_CC_HAS_AES_GCM
 	if (ctx->cipher_mode == DRV_CIPHER_GCTR) {
 		rc = config_gcm_context(req);
-		if (unlikely(rc)) {
+		if (rc) {
 			dev_dbg(dev, "config_gcm_context() returned with a failure %d!",
 				rc);
 			goto exit;
@@ -2097,7 +2096,7 @@ static int ssi_aead_process(struct aead_request *req,
 #endif /*SSI_CC_HAS_AES_GCM*/
 
 	rc = cc_map_aead_request(ctx->drvdata, req);
-	if (unlikely(rc)) {
+	if (rc) {
 		dev_err(dev, "map_request() failed\n");
 		goto exit;
 	}
@@ -2173,7 +2172,7 @@ static int ssi_aead_process(struct aead_request *req,
 
 	rc = send_request(ctx->drvdata, &ssi_req, desc, seq_len, 1);
 
-	if (unlikely(rc != -EINPROGRESS)) {
+	if (rc != -EINPROGRESS) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_aead_request(dev, req);
 	}
@@ -2829,7 +2828,7 @@ int ssi_aead_alloc(struct ssi_drvdata *drvdata)
 		}
 		t_alg->drvdata = drvdata;
 		rc = crypto_register_aead(&t_alg->aead_alg);
-		if (unlikely(rc)) {
+		if (rc) {
 			dev_err(dev, "%s alg registration failed\n",
 				t_alg->aead_alg.base.cra_driver_name);
 			goto fail2;
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index dc45333..7ceee91 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -247,7 +247,7 @@ static int cc_generate_mlli(
 	mlli_params->mlli_virt_addr = dma_pool_alloc(
 			mlli_params->curr_pool, GFP_KERNEL,
 			&mlli_params->mlli_dma_addr);
-	if (unlikely(!mlli_params->mlli_virt_addr)) {
+	if (!mlli_params->mlli_virt_addr) {
 		dev_err(dev, "dma_pool_alloc() failed\n");
 		rc = -ENOMEM;
 		goto build_mlli_exit;
@@ -350,7 +350,7 @@ cc_dma_map_sg(struct device *dev, struct scatterlist *sg, u32 nents,
 	for (i = 0; i < nents; i++) {
 		if (!l_sg)
 			break;
-		if (unlikely(dma_map_sg(dev, l_sg, 1, direction) != 1)) {
+		if (dma_map_sg(dev, l_sg, 1, direction) != 1) {
 			dev_err(dev, "dma_map_page() sg buffer failed\n");
 			goto err;
 		}
@@ -379,7 +379,7 @@ static int cc_map_sg(
 
 	if (sg_is_last(sg)) {
 		/* One entry only case -set to DLLI */
-		if (unlikely(dma_map_sg(dev, sg, 1, direction) != 1)) {
+		if (dma_map_sg(dev, sg, 1, direction) != 1) {
 			dev_err(dev, "dma_map_sg() single buffer failed\n");
 			return -ENOMEM;
 		}
@@ -403,7 +403,7 @@ static int cc_map_sg(
 			 * be changed from the original sgl nents
 			 */
 			*mapped_nents = dma_map_sg(dev, sg, *nents, direction);
-			if (unlikely(*mapped_nents == 0)) {
+			if (*mapped_nents == 0) {
 				*nents = 0;
 				dev_err(dev, "dma_map_sg() sg buffer failed\n");
 				return -ENOMEM;
@@ -414,7 +414,7 @@ static int cc_map_sg(
 			 */
 			*mapped_nents = cc_dma_map_sg(dev, sg, *nents,
 						      direction);
-			if (unlikely(*mapped_nents != *nents)) {
+			if (*mapped_nents != *nents) {
 				*nents = *mapped_nents;
 				dev_err(dev, "dma_map_sg() sg buffer failed\n");
 				return -ENOMEM;
@@ -436,8 +436,7 @@ ssi_aead_handle_config_buf(struct device *dev,
 	/* create sg for the current buffer */
 	sg_init_one(&areq_ctx->ccm_adata_sg, config_data,
 		    AES_BLOCK_SIZE + areq_ctx->ccm_hdr_size);
-	if (unlikely(dma_map_sg(dev, &areq_ctx->ccm_adata_sg, 1,
-				DMA_TO_DEVICE) != 1)) {
+	if (dma_map_sg(dev, &areq_ctx->ccm_adata_sg, 1, DMA_TO_DEVICE) != 1) {
 		dev_err(dev, "dma_map_sg() config buffer failed\n");
 		return -ENOMEM;
 	}
@@ -463,8 +462,7 @@ static int ssi_ahash_handle_curr_buf(struct device *dev,
 	dev_dbg(dev, " handle curr buff %x set to   DLLI\n", curr_buff_cnt);
 	/* create sg for the current buffer */
 	sg_init_one(areq_ctx->buff_sg, curr_buff, curr_buff_cnt);
-	if (unlikely(dma_map_sg(dev, areq_ctx->buff_sg, 1,
-				DMA_TO_DEVICE) != 1)) {
+	if (dma_map_sg(dev, areq_ctx->buff_sg, 1, DMA_TO_DEVICE) != 1) {
 		dev_err(dev, "dma_map_sg() src buffer failed\n");
 		return -ENOMEM;
 	}
@@ -490,7 +488,7 @@ void cc_unmap_blkcipher_request(
 {
 	struct blkcipher_req_ctx *req_ctx = (struct blkcipher_req_ctx *)ctx;
 
-	if (likely(req_ctx->gen_ctx.iv_dma_addr)) {
+	if (req_ctx->gen_ctx.iv_dma_addr) {
 		dev_dbg(dev, "Unmapped iv: iv_dma_addr=%pad iv_size=%u\n",
 			&req_ctx->gen_ctx.iv_dma_addr, ivsize);
 		dma_unmap_single(dev, req_ctx->gen_ctx.iv_dma_addr,
@@ -537,15 +535,14 @@ int cc_map_blkcipher_request(
 	sg_data.num_of_buffers = 0;
 
 	/* Map IV buffer */
-	if (likely(ivsize)) {
+	if (ivsize) {
 		dump_byte_array("iv", (u8 *)info, ivsize);
 		req_ctx->gen_ctx.iv_dma_addr =
 			dma_map_single(dev, (void *)info,
 				       ivsize,
 				       req_ctx->is_giv ? DMA_BIDIRECTIONAL :
 				       DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(dev,
-					       req_ctx->gen_ctx.iv_dma_addr))) {
+		if (dma_mapping_error(dev, req_ctx->gen_ctx.iv_dma_addr)) {
 			dev_err(dev, "Mapping iv %u B at va=%pK for DMA failed\n",
 				ivsize, info);
 			return -ENOMEM;
@@ -559,16 +556,16 @@ int cc_map_blkcipher_request(
 	/* Map the src SGL */
 	rc = cc_map_sg(dev, src, nbytes, DMA_BIDIRECTIONAL, &req_ctx->in_nents,
 		       LLI_MAX_NUM_OF_DATA_ENTRIES, &dummy, &mapped_nents);
-	if (unlikely(rc)) {
+	if (rc) {
 		rc = -ENOMEM;
 		goto ablkcipher_exit;
 	}
 	if (mapped_nents > 1)
 		req_ctx->dma_buf_type = SSI_DMA_BUF_MLLI;
 
-	if (unlikely(src == dst)) {
+	if (src == dst) {
 		/* Handle inplace operation */
-		if (unlikely(req_ctx->dma_buf_type == SSI_DMA_BUF_MLLI)) {
+		if (req_ctx->dma_buf_type == SSI_DMA_BUF_MLLI) {
 			req_ctx->out_nents = 0;
 			cc_add_sg_entry(dev, &sg_data, req_ctx->in_nents, src,
 					nbytes, 0, true,
@@ -576,17 +573,16 @@ int cc_map_blkcipher_request(
 		}
 	} else {
 		/* Map the dst sg */
-		if (unlikely(cc_map_sg(dev, dst, nbytes, DMA_BIDIRECTIONAL,
-				       &req_ctx->out_nents,
-				       LLI_MAX_NUM_OF_DATA_ENTRIES, &dummy,
-				       &mapped_nents))) {
+		if (cc_map_sg(dev, dst, nbytes, DMA_BIDIRECTIONAL,
+			      &req_ctx->out_nents, LLI_MAX_NUM_OF_DATA_ENTRIES,
+			      &dummy, &mapped_nents)) {
 			rc = -ENOMEM;
 			goto ablkcipher_exit;
 		}
 		if (mapped_nents > 1)
 			req_ctx->dma_buf_type = SSI_DMA_BUF_MLLI;
 
-		if (unlikely(req_ctx->dma_buf_type == SSI_DMA_BUF_MLLI)) {
+		if (req_ctx->dma_buf_type == SSI_DMA_BUF_MLLI) {
 			cc_add_sg_entry(dev, &sg_data, req_ctx->in_nents, src,
 					nbytes, 0, true,
 					&req_ctx->in_mlli_nents);
@@ -596,10 +592,10 @@ int cc_map_blkcipher_request(
 		}
 	}
 
-	if (unlikely(req_ctx->dma_buf_type == SSI_DMA_BUF_MLLI)) {
+	if (req_ctx->dma_buf_type == SSI_DMA_BUF_MLLI) {
 		mlli_params->curr_pool = buff_mgr->mlli_buffs_pool;
 		rc = cc_generate_mlli(dev, &sg_data, mlli_params);
-		if (unlikely(rc))
+		if (rc)
 			goto ablkcipher_exit;
 	}
 
@@ -690,7 +686,7 @@ void cc_unmap_aead_request(struct device *dev, struct aead_request *req)
 		     cc_get_sgl_nents(dev, req->src, size_to_unmap,
 				      &dummy, &chained),
 		     DMA_BIDIRECTIONAL);
-	if (unlikely(req->src != req->dst)) {
+	if (req->src != req->dst) {
 		dev_dbg(dev, "Unmapping dst sgl: req->dst=%pK\n",
 			sg_virt(req->dst));
 		dma_unmap_sg(dev, req->dst,
@@ -700,7 +696,7 @@ void cc_unmap_aead_request(struct device *dev, struct aead_request *req)
 	}
 	if (drvdata->coherent &&
 	    areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT &&
-	    likely(req->src == req->dst)) {
+	    req->src == req->dst) {
 		/* copy back mac from temporary location to deal with possible
 		 * data memory overriding that caused by cache coherence
 		 * problem.
@@ -774,7 +770,7 @@ static int cc_aead_chain_iv(
 	struct device *dev = drvdata_to_dev(drvdata);
 	int rc = 0;
 
-	if (unlikely(!req->iv)) {
+	if (!req->iv) {
 		areq_ctx->gen_ctx.iv_dma_addr = 0;
 		goto chain_iv_exit;
 	}
@@ -782,7 +778,7 @@ static int cc_aead_chain_iv(
 	areq_ctx->gen_ctx.iv_dma_addr = dma_map_single(dev, req->iv,
 						       hw_iv_size,
 						       DMA_BIDIRECTIONAL);
-	if (unlikely(dma_mapping_error(dev, areq_ctx->gen_ctx.iv_dma_addr))) {
+	if (dma_mapping_error(dev, areq_ctx->gen_ctx.iv_dma_addr)) {
 		dev_err(dev, "Mapping iv %u B at va=%pK for DMA failed\n",
 			hw_iv_size, req->iv);
 		rc = -ENOMEM;
@@ -831,7 +827,7 @@ static int cc_aead_chain_assoc(
 		goto chain_assoc_exit;
 	}
 
-	if (unlikely(req->assoclen == 0)) {
+	if (req->assoclen == 0) {
 		areq_ctx->assoc_buff_type = SSI_DMA_BUF_NULL;
 		areq_ctx->assoc.nents = 0;
 		areq_ctx->assoc.mlli_nents = 0;
@@ -861,7 +857,7 @@ static int cc_aead_chain_assoc(
 			mapped_nents++;
 		}
 	}
-	if (unlikely(mapped_nents > LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES)) {
+	if (mapped_nents > LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES) {
 		dev_err(dev, "Too many fragments. current %d max %d\n",
 			mapped_nents, LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES);
 		return -ENOMEM;
@@ -872,8 +868,7 @@ static int cc_aead_chain_assoc(
 	 * ccm header configurations
 	 */
 	if (areq_ctx->ccm_hdr_size != ccm_header_size_null) {
-		if (unlikely((mapped_nents + 1) >
-			LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES)) {
+		if ((mapped_nents + 1) > LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES) {
 			dev_err(dev, "CCM case.Too many fragments. Current %d max %d\n",
 				(areq_ctx->assoc.nents + 1),
 				LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES);
@@ -882,14 +877,12 @@ static int cc_aead_chain_assoc(
 		}
 	}
 
-	if (likely(mapped_nents == 1) &&
-	    areq_ctx->ccm_hdr_size == ccm_header_size_null)
+	if (mapped_nents == 1 && areq_ctx->ccm_hdr_size == ccm_header_size_null)
 		areq_ctx->assoc_buff_type = SSI_DMA_BUF_DLLI;
 	else
 		areq_ctx->assoc_buff_type = SSI_DMA_BUF_MLLI;
 
-	if (unlikely((do_chain) ||
-		     areq_ctx->assoc_buff_type == SSI_DMA_BUF_MLLI)) {
+	if ((do_chain) || areq_ctx->assoc_buff_type == SSI_DMA_BUF_MLLI) {
 		dev_dbg(dev, "Chain assoc: buff_type=%s nents=%u\n",
 			cc_dma_buf_type(areq_ctx->assoc_buff_type),
 			areq_ctx->assoc.nents);
@@ -912,7 +905,7 @@ static void cc_prepare_aead_data_dlli(
 	unsigned int authsize = areq_ctx->req_authsize;
 
 	areq_ctx->is_icv_fragmented = false;
-	if (likely(req->src == req->dst)) {
+	if (req->src == req->dst) {
 		/*INPLACE*/
 		areq_ctx->icv_dma_addr = sg_dma_address(
 			areq_ctx->src_sgl) +
@@ -952,7 +945,7 @@ static int cc_prepare_aead_data_mlli(
 	int rc = 0, icv_nents;
 	struct device *dev = drvdata_to_dev(drvdata);
 
-	if (likely(req->src == req->dst)) {
+	if (req->src == req->dst) {
 		/*INPLACE*/
 		cc_add_sg_entry(dev, sg_data, areq_ctx->src.nents,
 				areq_ctx->src_sgl, areq_ctx->cryptlen,
@@ -963,12 +956,12 @@ static int cc_prepare_aead_data_mlli(
 						  areq_ctx->src.nents,
 						  authsize, *src_last_bytes,
 						  &areq_ctx->is_icv_fragmented);
-		if (unlikely(icv_nents < 0)) {
+		if (icv_nents < 0) {
 			rc = -ENOTSUPP;
 			goto prepare_data_mlli_exit;
 		}
 
-		if (unlikely(areq_ctx->is_icv_fragmented)) {
+		if (areq_ctx->is_icv_fragmented) {
 			/* Backup happens only when ICV is fragmented, ICV
 			 * verification is made by CPU compare in order to
 			 * simplify MAC verification upon request completion
@@ -1013,7 +1006,7 @@ static int cc_prepare_aead_data_mlli(
 						  areq_ctx->src.nents,
 						  authsize, *src_last_bytes,
 						  &areq_ctx->is_icv_fragmented);
-		if (unlikely(icv_nents < 0)) {
+		if (icv_nents < 0) {
 			rc = -ENOTSUPP;
 			goto prepare_data_mlli_exit;
 		}
@@ -1022,7 +1015,7 @@ static int cc_prepare_aead_data_mlli(
 		 * verification is made by CPU compare in order to simplify
 		 * MAC verification upon request completion
 		 */
-		if (unlikely(areq_ctx->is_icv_fragmented)) {
+		if (areq_ctx->is_icv_fragmented) {
 			cc_copy_mac(dev, req, SSI_SG_TO_BUF);
 			areq_ctx->icv_virt_addr = areq_ctx->backup_mac;
 
@@ -1051,12 +1044,12 @@ static int cc_prepare_aead_data_mlli(
 						  areq_ctx->dst.nents,
 						  authsize, *dst_last_bytes,
 						  &areq_ctx->is_icv_fragmented);
-		if (unlikely(icv_nents < 0)) {
+		if (icv_nents < 0) {
 			rc = -ENOTSUPP;
 			goto prepare_data_mlli_exit;
 		}
 
-		if (likely(!areq_ctx->is_icv_fragmented)) {
+		if (!areq_ctx->is_icv_fragmented) {
 			/* Contig. ICV */
 			areq_ctx->icv_dma_addr = sg_dma_address(
 				&areq_ctx->dst_sgl[areq_ctx->dst.nents - 1]) +
@@ -1127,7 +1120,7 @@ static int cc_aead_chain_data(
 		sg_index += areq_ctx->src_sgl->length;
 		src_mapped_nents--;
 	}
-	if (unlikely(src_mapped_nents > LLI_MAX_NUM_OF_DATA_ENTRIES)) {
+	if (src_mapped_nents > LLI_MAX_NUM_OF_DATA_ENTRIES) {
 		dev_err(dev, "Too many fragments. current %d max %d\n",
 			src_mapped_nents, LLI_MAX_NUM_OF_DATA_ENTRIES);
 			return -ENOMEM;
@@ -1148,7 +1141,7 @@ static int cc_aead_chain_data(
 			       &areq_ctx->dst.nents,
 			       LLI_MAX_NUM_OF_DATA_ENTRIES, &dst_last_bytes,
 			       &dst_mapped_nents);
-		if (unlikely(rc)) {
+		if (rc) {
 			rc = -ENOMEM;
 			goto chain_data_exit;
 		}
@@ -1171,7 +1164,7 @@ static int cc_aead_chain_data(
 		sg_index += areq_ctx->dst_sgl->length;
 		dst_mapped_nents--;
 	}
-	if (unlikely(dst_mapped_nents > LLI_MAX_NUM_OF_DATA_ENTRIES)) {
+	if (dst_mapped_nents > LLI_MAX_NUM_OF_DATA_ENTRIES) {
 		dev_err(dev, "Too many fragments. current %d max %d\n",
 			dst_mapped_nents, LLI_MAX_NUM_OF_DATA_ENTRIES);
 		return -ENOMEM;
@@ -1271,7 +1264,7 @@ int cc_map_aead_request(
 	 */
 	if (drvdata->coherent &&
 	    areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT &&
-	    likely(req->src == req->dst))
+	    req->src == req->dst)
 		cc_copy_mac(dev, req, SSI_SG_TO_BUF);
 
 	/* cacluate the size for cipher remove ICV in decrypt*/
@@ -1282,7 +1275,7 @@ int cc_map_aead_request(
 
 	dma_addr = dma_map_single(dev, areq_ctx->mac_buf, MAX_MAC_SIZE,
 				  DMA_BIDIRECTIONAL);
-	if (unlikely(dma_mapping_error(dev, dma_addr))) {
+	if (dma_mapping_error(dev, dma_addr)) {
 		dev_err(dev, "Mapping mac_buf %u B at va=%pK for DMA failed\n",
 			MAX_MAC_SIZE, areq_ctx->mac_buf);
 		rc = -ENOMEM;
@@ -1296,7 +1289,7 @@ int cc_map_aead_request(
 		dma_addr = dma_map_single(dev, addr, AES_BLOCK_SIZE,
 					  DMA_TO_DEVICE);
 
-		if (unlikely(dma_mapping_error(dev, dma_addr))) {
+		if (dma_mapping_error(dev, dma_addr)) {
 			dev_err(dev, "Mapping mac_buf %u B at va=%pK for DMA failed\n",
 				AES_BLOCK_SIZE, addr);
 			areq_ctx->ccm_iv0_dma_addr = 0;
@@ -1317,7 +1310,7 @@ int cc_map_aead_request(
 	if (areq_ctx->cipher_mode == DRV_CIPHER_GCTR) {
 		dma_addr = dma_map_single(dev, areq_ctx->hkey, AES_BLOCK_SIZE,
 					  DMA_BIDIRECTIONAL);
-		if (unlikely(dma_mapping_error(dev, dma_addr))) {
+		if (dma_mapping_error(dev, dma_addr)) {
 			dev_err(dev, "Mapping hkey %u B at va=%pK for DMA failed\n",
 				AES_BLOCK_SIZE, areq_ctx->hkey);
 			rc = -ENOMEM;
@@ -1327,7 +1320,7 @@ int cc_map_aead_request(
 
 		dma_addr = dma_map_single(dev, &areq_ctx->gcm_len_block,
 					  AES_BLOCK_SIZE, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(dev, dma_addr))) {
+		if (dma_mapping_error(dev, dma_addr)) {
 			dev_err(dev, "Mapping gcm_len_block %u B at va=%pK for DMA failed\n",
 				AES_BLOCK_SIZE, &areq_ctx->gcm_len_block);
 			rc = -ENOMEM;
@@ -1338,7 +1331,7 @@ int cc_map_aead_request(
 		dma_addr = dma_map_single(dev, areq_ctx->gcm_iv_inc1,
 					  AES_BLOCK_SIZE, DMA_TO_DEVICE);
 
-		if (unlikely(dma_mapping_error(dev, dma_addr))) {
+		if (dma_mapping_error(dev, dma_addr)) {
 			dev_err(dev, "Mapping gcm_iv_inc1 %u B at va=%pK for DMA failed\n",
 				AES_BLOCK_SIZE, (areq_ctx->gcm_iv_inc1));
 			areq_ctx->gcm_iv_inc1_dma_addr = 0;
@@ -1350,7 +1343,7 @@ int cc_map_aead_request(
 		dma_addr = dma_map_single(dev, areq_ctx->gcm_iv_inc2,
 					  AES_BLOCK_SIZE, DMA_TO_DEVICE);
 
-		if (unlikely(dma_mapping_error(dev, dma_addr))) {
+		if (dma_mapping_error(dev, dma_addr)) {
 			dev_err(dev, "Mapping gcm_iv_inc2 %u B at va=%pK for DMA failed\n",
 				AES_BLOCK_SIZE, (areq_ctx->gcm_iv_inc2));
 			areq_ctx->gcm_iv_inc2_dma_addr = 0;
@@ -1372,12 +1365,12 @@ int cc_map_aead_request(
 		       (LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES +
 			LLI_MAX_NUM_OF_DATA_ENTRIES),
 		       &dummy, &mapped_nents);
-	if (unlikely(rc)) {
+	if (rc) {
 		rc = -ENOMEM;
 		goto aead_map_failure;
 	}
 
-	if (likely(areq_ctx->is_single_pass)) {
+	if (areq_ctx->is_single_pass) {
 		/*
 		 * Create MLLI table for:
 		 *   (1) Assoc. data
@@ -1385,13 +1378,13 @@ int cc_map_aead_request(
 		 *   Note: IV is contg. buffer (not an SGL)
 		 */
 		rc = cc_aead_chain_assoc(drvdata, req, &sg_data, true, false);
-		if (unlikely(rc))
+		if (rc)
 			goto aead_map_failure;
 		rc = cc_aead_chain_iv(drvdata, req, &sg_data, true, false);
-		if (unlikely(rc))
+		if (rc)
 			goto aead_map_failure;
 		rc = cc_aead_chain_data(drvdata, req, &sg_data, true, false);
-		if (unlikely(rc))
+		if (rc)
 			goto aead_map_failure;
 	} else { /* DOUBLE-PASS flow */
 		/*
@@ -1415,25 +1408,24 @@ int cc_map_aead_request(
 		 *   (4) MLLI for dst
 		 */
 		rc = cc_aead_chain_assoc(drvdata, req, &sg_data, false, true);
-		if (unlikely(rc))
+		if (rc)
 			goto aead_map_failure;
 		rc = cc_aead_chain_iv(drvdata, req, &sg_data, false, true);
-		if (unlikely(rc))
+		if (rc)
 			goto aead_map_failure;
 		rc = cc_aead_chain_data(drvdata, req, &sg_data, true, true);
-		if (unlikely(rc))
+		if (rc)
 			goto aead_map_failure;
 	}
 
 	/* Mlli support -start building the MLLI according to the above
 	 * results
 	 */
-	if (unlikely(
-		areq_ctx->assoc_buff_type == SSI_DMA_BUF_MLLI ||
-		areq_ctx->data_buff_type == SSI_DMA_BUF_MLLI)) {
+	if (areq_ctx->assoc_buff_type == SSI_DMA_BUF_MLLI ||
+	    areq_ctx->data_buff_type == SSI_DMA_BUF_MLLI) {
 		mlli_params->curr_pool = buff_mgr->mlli_buffs_pool;
 		rc = cc_generate_mlli(dev, &sg_data, mlli_params);
-		if (unlikely(rc))
+		if (rc)
 			goto aead_map_failure;
 
 		cc_update_aead_mlli_nents(drvdata, req);
@@ -1473,7 +1465,7 @@ int cc_map_hash_request_final(struct ssi_drvdata *drvdata, void *ctx,
 	sg_data.num_of_buffers = 0;
 	areq_ctx->in_nents = 0;
 
-	if (unlikely(nbytes == 0 && *curr_buff_cnt == 0)) {
+	if (nbytes == 0 && *curr_buff_cnt == 0) {
 		/* nothing to do */
 		return 0;
 	}
@@ -1488,10 +1480,9 @@ int cc_map_hash_request_final(struct ssi_drvdata *drvdata, void *ctx,
 	}
 
 	if (src && nbytes > 0 && do_update) {
-		if (unlikely(cc_map_sg(dev, src, nbytes, DMA_TO_DEVICE,
-				       &areq_ctx->in_nents,
-				       LLI_MAX_NUM_OF_DATA_ENTRIES,
-				       &dummy, &mapped_nents))) {
+		if (cc_map_sg(dev, src, nbytes, DMA_TO_DEVICE,
+			      &areq_ctx->in_nents, LLI_MAX_NUM_OF_DATA_ENTRIES,
+			      &dummy, &mapped_nents)) {
 			goto unmap_curr_buff;
 		}
 		if (src && mapped_nents == 1 &&
@@ -1507,12 +1498,12 @@ int cc_map_hash_request_final(struct ssi_drvdata *drvdata, void *ctx,
 	}
 
 	/*build mlli */
-	if (unlikely(areq_ctx->data_dma_buf_type == SSI_DMA_BUF_MLLI)) {
+	if (areq_ctx->data_dma_buf_type == SSI_DMA_BUF_MLLI) {
 		mlli_params->curr_pool = buff_mgr->mlli_buffs_pool;
 		/* add the src data to the sg_data */
 		cc_add_sg_entry(dev, &sg_data, areq_ctx->in_nents, src, nbytes,
 				0, true, &areq_ctx->mlli_nents);
-		if (unlikely(cc_generate_mlli(dev, &sg_data, mlli_params)))
+		if (cc_generate_mlli(dev, &sg_data, mlli_params))
 			goto fail_unmap_din;
 	}
 	/* change the buffer index for the unmap function */
@@ -1563,7 +1554,7 @@ int cc_map_hash_request_update(struct ssi_drvdata *drvdata, void *ctx,
 	sg_data.num_of_buffers = 0;
 	areq_ctx->in_nents = 0;
 
-	if (unlikely(total_in_len < block_size)) {
+	if (total_in_len < block_size) {
 		dev_dbg(dev, " less than one block: curr_buff=%pK *curr_buff_cnt=0x%X copy_to=%pK\n",
 			curr_buff, *curr_buff_cnt, &curr_buff[*curr_buff_cnt]);
 		areq_ctx->in_nents =
@@ -1604,11 +1595,10 @@ int cc_map_hash_request_update(struct ssi_drvdata *drvdata, void *ctx,
 	}
 
 	if (update_data_len > *curr_buff_cnt) {
-		if (unlikely(cc_map_sg(dev, src,
-				       (update_data_len - *curr_buff_cnt),
-				       DMA_TO_DEVICE, &areq_ctx->in_nents,
-				       LLI_MAX_NUM_OF_DATA_ENTRIES, &dummy,
-				       &mapped_nents))) {
+		if (cc_map_sg(dev, src, (update_data_len - *curr_buff_cnt),
+			      DMA_TO_DEVICE, &areq_ctx->in_nents,
+			      LLI_MAX_NUM_OF_DATA_ENTRIES, &dummy,
+			      &mapped_nents)) {
 			goto unmap_curr_buff;
 		}
 		if (mapped_nents == 1 &&
@@ -1624,13 +1614,13 @@ int cc_map_hash_request_update(struct ssi_drvdata *drvdata, void *ctx,
 		}
 	}
 
-	if (unlikely(areq_ctx->data_dma_buf_type == SSI_DMA_BUF_MLLI)) {
+	if (areq_ctx->data_dma_buf_type == SSI_DMA_BUF_MLLI) {
 		mlli_params->curr_pool = buff_mgr->mlli_buffs_pool;
 		/* add the src data to the sg_data */
 		cc_add_sg_entry(dev, &sg_data, areq_ctx->in_nents, src,
 				(update_data_len - *curr_buff_cnt), 0, true,
 				&areq_ctx->mlli_nents);
-		if (unlikely(cc_generate_mlli(dev, &sg_data, mlli_params)))
+		if (cc_generate_mlli(dev, &sg_data, mlli_params))
 			goto fail_unmap_din;
 	}
 	areq_ctx->buff_index = (areq_ctx->buff_index ^ swap_index);
@@ -1666,7 +1656,7 @@ void cc_unmap_hash_request(struct device *dev, void *ctx,
 			      areq_ctx->mlli_params.mlli_dma_addr);
 	}
 
-	if ((src) && likely(areq_ctx->in_nents)) {
+	if ((src) && areq_ctx->in_nents) {
 		dev_dbg(dev, "Unmapped sg src: virt=%pK dma=%pad len=0x%X\n",
 			sg_virt(src), &sg_dma_address(src), sg_dma_len(src));
 		dma_unmap_sg(dev, src,
@@ -1707,7 +1697,7 @@ int cc_buffer_mgr_init(struct ssi_drvdata *drvdata)
 				LLI_ENTRY_BYTE_SIZE,
 				MLLI_TABLE_MIN_ALIGNMENT, 0);
 
-	if (unlikely(!buff_mgr_handle->mlli_buffs_pool))
+	if (!buff_mgr_handle->mlli_buffs_pool)
 		goto error;
 
 	return 0;
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 6c4b93d..9019615 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -76,30 +76,30 @@ static int validate_keys_sizes(struct ssi_ablkcipher_ctx *ctx_p, u32 size)
 		switch (size) {
 		case CC_AES_128_BIT_KEY_SIZE:
 		case CC_AES_192_BIT_KEY_SIZE:
-			if (likely(ctx_p->cipher_mode != DRV_CIPHER_XTS &&
-				   ctx_p->cipher_mode != DRV_CIPHER_ESSIV &&
-				   ctx_p->cipher_mode != DRV_CIPHER_BITLOCKER))
+			if (ctx_p->cipher_mode != DRV_CIPHER_XTS &&
+			    ctx_p->cipher_mode != DRV_CIPHER_ESSIV &&
+			    ctx_p->cipher_mode != DRV_CIPHER_BITLOCKER)
 				return 0;
 			break;
 		case CC_AES_256_BIT_KEY_SIZE:
 			return 0;
 		case (CC_AES_192_BIT_KEY_SIZE * 2):
 		case (CC_AES_256_BIT_KEY_SIZE * 2):
-			if (likely(ctx_p->cipher_mode == DRV_CIPHER_XTS ||
-				   ctx_p->cipher_mode == DRV_CIPHER_ESSIV ||
-				   ctx_p->cipher_mode == DRV_CIPHER_BITLOCKER))
+			if (ctx_p->cipher_mode == DRV_CIPHER_XTS ||
+			    ctx_p->cipher_mode == DRV_CIPHER_ESSIV ||
+			    ctx_p->cipher_mode == DRV_CIPHER_BITLOCKER)
 				return 0;
 			break;
 		default:
 			break;
 		}
 	case S_DIN_to_DES:
-		if (likely(size == DES3_EDE_KEY_SIZE || size == DES_KEY_SIZE))
+		if (size == DES3_EDE_KEY_SIZE || size == DES_KEY_SIZE)
 			return 0;
 		break;
 #if SSI_CC_HAS_MULTI2
 	case S_DIN_to_MULTI2:
-		if (likely(size == CC_MULTI2_SYSTEM_N_DATA_KEY_SIZE))
+		if (size == CC_MULTI2_SYSTEM_N_DATA_KEY_SIZE)
 			return 0;
 		break;
 #endif
@@ -122,7 +122,7 @@ static int validate_data_size(struct ssi_ablkcipher_ctx *ctx_p,
 				return 0;
 			break;
 		case DRV_CIPHER_CBC_CTS:
-			if (likely(size >= AES_BLOCK_SIZE))
+			if (size >= AES_BLOCK_SIZE)
 				return 0;
 			break;
 		case DRV_CIPHER_OFB:
@@ -132,7 +132,7 @@ static int validate_data_size(struct ssi_ablkcipher_ctx *ctx_p,
 		case DRV_CIPHER_CBC:
 		case DRV_CIPHER_ESSIV:
 		case DRV_CIPHER_BITLOCKER:
-			if (likely(IS_ALIGNED(size, AES_BLOCK_SIZE)))
+			if (IS_ALIGNED(size, AES_BLOCK_SIZE))
 				return 0;
 			break;
 		default:
@@ -140,14 +140,14 @@ static int validate_data_size(struct ssi_ablkcipher_ctx *ctx_p,
 		}
 		break;
 	case S_DIN_to_DES:
-		if (likely(IS_ALIGNED(size, DES_BLOCK_SIZE)))
+		if (IS_ALIGNED(size, DES_BLOCK_SIZE))
 			return 0;
 		break;
 #if SSI_CC_HAS_MULTI2
 	case S_DIN_to_MULTI2:
 		switch (ctx_p->cipher_mode) {
 		case DRV_MULTI2_CBC:
-			if (likely(IS_ALIGNED(size, CC_MULTI2_BLOCK_SIZE)))
+			if (IS_ALIGNED(size, CC_MULTI2_BLOCK_SIZE))
 				return 0;
 			break;
 		case DRV_MULTI2_OFB:
@@ -272,10 +272,10 @@ static int ssi_verify_3des_keys(const u8 *key, unsigned int keylen)
 	struct tdes_keys *tdes_key = (struct tdes_keys *)key;
 
 	/* verify key1 != key2 and key3 != key2*/
-	if (unlikely((memcmp((u8 *)tdes_key->key1, (u8 *)tdes_key->key2,
-			     sizeof(tdes_key->key1)) == 0) ||
-		     (memcmp((u8 *)tdes_key->key3, (u8 *)tdes_key->key2,
-			     sizeof(tdes_key->key3)) == 0))) {
+	if ((memcmp((u8 *)tdes_key->key1, (u8 *)tdes_key->key2,
+		    sizeof(tdes_key->key1)) == 0) ||
+	    (memcmp((u8 *)tdes_key->key3, (u8 *)tdes_key->key2,
+		    sizeof(tdes_key->key3)) == 0)) {
 		return -ENOEXEC;
 	}
 
@@ -320,7 +320,7 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 		keylen -= 1;
 #endif /*SSI_CC_HAS_MULTI2*/
 
-	if (unlikely(validate_keys_sizes(ctx_p, keylen))) {
+	if (validate_keys_sizes(ctx_p, keylen)) {
 		dev_err(dev, "Unsupported key size %d.\n", keylen);
 		crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
@@ -330,13 +330,13 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 		/* setting HW key slots */
 		struct arm_hw_key_info *hki = (struct arm_hw_key_info *)key;
 
-		if (unlikely(ctx_p->flow_mode != S_DIN_to_AES)) {
+		if (ctx_p->flow_mode != S_DIN_to_AES) {
 			dev_err(dev, "HW key not supported for non-AES flows\n");
 			return -EINVAL;
 		}
 
 		ctx_p->hw.key1_slot = hw_key_to_cc_hw_key(hki->hw_key1);
-		if (unlikely(ctx_p->hw.key1_slot == END_OF_KEYS)) {
+		if (ctx_p->hw.key1_slot == END_OF_KEYS) {
 			dev_err(dev, "Unsupported hw key1 number (%d)\n",
 				hki->hw_key1);
 			return -EINVAL;
@@ -345,14 +345,14 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 		if (ctx_p->cipher_mode == DRV_CIPHER_XTS ||
 		    ctx_p->cipher_mode == DRV_CIPHER_ESSIV ||
 		    ctx_p->cipher_mode == DRV_CIPHER_BITLOCKER) {
-			if (unlikely(hki->hw_key1 == hki->hw_key2)) {
+			if (hki->hw_key1 == hki->hw_key2) {
 				dev_err(dev, "Illegal hw key numbers (%d,%d)\n",
 					hki->hw_key1, hki->hw_key2);
 				return -EINVAL;
 			}
 			ctx_p->hw.key2_slot =
 				hw_key_to_cc_hw_key(hki->hw_key2);
-			if (unlikely(ctx_p->hw.key2_slot == END_OF_KEYS)) {
+			if (ctx_p->hw.key2_slot == END_OF_KEYS) {
 				dev_err(dev, "Unsupported hw key2 number (%d)\n",
 					hki->hw_key2);
 				return -EINVAL;
@@ -367,7 +367,7 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 
 	// verify weak keys
 	if (ctx_p->flow_mode == S_DIN_to_DES) {
-		if (unlikely(!des_ekey(tmp, key)) &&
+		if (!des_ekey(tmp, key) &&
 		    (crypto_tfm_get_flags(tfm) & CRYPTO_TFM_REQ_WEAK_KEY)) {
 			tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
 			dev_dbg(dev, "weak DES key");
@@ -637,7 +637,7 @@ ssi_blkcipher_create_data_desc(
 		return;
 	}
 	/* Process */
-	if (likely(req_ctx->dma_buf_type == SSI_DMA_BUF_DLLI)) {
+	if (req_ctx->dma_buf_type == SSI_DMA_BUF_DLLI) {
 		dev_dbg(dev, " data params addr %pad length 0x%X\n",
 			&sg_dma_address(src), nbytes);
 		dev_dbg(dev, " data params addr %pad length 0x%X\n",
@@ -760,7 +760,7 @@ static int ssi_blkcipher_process(
 	/* STAT_PHASE_0: Init and sanity checks */
 
 	/* TODO: check data length according to mode */
-	if (unlikely(validate_data_size(ctx_p, nbytes))) {
+	if (validate_data_size(ctx_p, nbytes)) {
 		dev_err(dev, "Unsupported data size %d.\n", nbytes);
 		crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_BAD_BLOCK_LEN);
 		rc = -EINVAL;
@@ -806,7 +806,7 @@ static int ssi_blkcipher_process(
 
 	rc = cc_map_blkcipher_request(ctx_p->drvdata, req_ctx, ivsize, nbytes,
 				      req_ctx->iv, src, dst);
-	if (unlikely(rc)) {
+	if (rc) {
 		dev_err(dev, "map_request() failed\n");
 		goto exit_process;
 	}
@@ -839,7 +839,7 @@ static int ssi_blkcipher_process(
 	rc = send_request(ctx_p->drvdata, &ssi_req, desc, seq_len,
 			  (!areq) ? 0 : 1);
 	if (areq) {
-		if (unlikely(rc != -EINPROGRESS)) {
+		if (rc != -EINPROGRESS) {
 			/* Failed to send the request or request completed
 			 * synchronously
 			 */
@@ -1364,7 +1364,7 @@ int ssi_ablkcipher_alloc(struct ssi_drvdata *drvdata)
 		rc = crypto_register_alg(&t_alg->crypto_alg);
 		dev_dbg(dev, "%s alg registration rc = %x\n",
 			t_alg->crypto_alg.cra_driver_name, rc);
-		if (unlikely(rc)) {
+		if (rc) {
 			dev_err(dev, "%s alg registration failed\n",
 				t_alg->crypto_alg.cra_driver_name);
 			kfree(t_alg);
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 3cb2296..6282c37 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -100,7 +100,7 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 	/* read the interrupt status */
 	irr = cc_ioread(drvdata, CC_REG(HOST_IRR));
 	dev_dbg(dev, "Got IRR=0x%08X\n", irr);
-	if (unlikely(irr == 0)) { /* Probably shared interrupt line */
+	if (irr == 0) { /* Probably shared interrupt line */
 		dev_err(dev, "Got interrupt with empty IRR\n");
 		return IRQ_NONE;
 	}
@@ -111,7 +111,7 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 
 	drvdata->irq = irr;
 	/* Completion interrupt - most probable */
-	if (likely((irr & SSI_COMP_IRQ_MASK))) {
+	if ((irr & SSI_COMP_IRQ_MASK)) {
 		/* Mask AXI completion interrupt - will be unmasked in
 		 * Deferred service handler
 		 */
@@ -121,7 +121,7 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 	}
 #ifdef CC_SUPPORT_FIPS
 	/* TEE FIPS interrupt */
-	if (likely((irr & SSI_GPR0_IRQ_MASK))) {
+	if ((irr & SSI_GPR0_IRQ_MASK)) {
 		/* Mask interrupt - will be unmasked in Deferred service
 		 * handler
 		 */
@@ -131,7 +131,7 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 	}
 #endif
 	/* AXI error interrupt */
-	if (unlikely((irr & SSI_AXI_ERR_IRQ_MASK))) {
+	if ((irr & SSI_AXI_ERR_IRQ_MASK)) {
 		u32 axi_err;
 
 		/* Read the AXI error ID */
@@ -142,7 +142,7 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 		irr &= ~SSI_AXI_ERR_IRQ_MASK;
 	}
 
-	if (unlikely(irr)) {
+	if (irr) {
 		dev_dbg(dev, "IRR includes unknown cause bits (0x%08X)\n",
 			irr);
 		/* Just warning */
@@ -295,78 +295,78 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		 DRV_MODULE_VERSION);
 
 	rc = init_cc_regs(new_drvdata, true);
-	if (unlikely(rc)) {
+	if (rc) {
 		dev_err(dev, "init_cc_regs failed\n");
 		goto post_clk_err;
 	}
 
 #ifdef ENABLE_CC_SYSFS
 	rc = ssi_sysfs_init(&dev->kobj, new_drvdata);
-	if (unlikely(rc)) {
+	if (rc) {
 		dev_err(dev, "init_stat_db failed\n");
 		goto post_regs_err;
 	}
 #endif
 
 	rc = ssi_fips_init(new_drvdata);
-	if (unlikely(rc)) {
+	if (rc) {
 		dev_err(dev, "SSI_FIPS_INIT failed 0x%x\n", rc);
 		goto post_sysfs_err;
 	}
 	rc = ssi_sram_mgr_init(new_drvdata);
-	if (unlikely(rc)) {
+	if (rc) {
 		dev_err(dev, "ssi_sram_mgr_init failed\n");
 		goto post_fips_init_err;
 	}
 
 	new_drvdata->mlli_sram_addr =
 		cc_sram_alloc(new_drvdata, MAX_MLLI_BUFF_SIZE);
-	if (unlikely(new_drvdata->mlli_sram_addr == NULL_SRAM_ADDR)) {
+	if (new_drvdata->mlli_sram_addr == NULL_SRAM_ADDR) {
 		dev_err(dev, "Failed to alloc MLLI Sram buffer\n");
 		rc = -ENOMEM;
 		goto post_sram_mgr_err;
 	}
 
 	rc = request_mgr_init(new_drvdata);
-	if (unlikely(rc)) {
+	if (rc) {
 		dev_err(dev, "request_mgr_init failed\n");
 		goto post_sram_mgr_err;
 	}
 
 	rc = cc_buffer_mgr_init(new_drvdata);
-	if (unlikely(rc)) {
+	if (rc) {
 		dev_err(dev, "buffer_mgr_init failed\n");
 		goto post_req_mgr_err;
 	}
 
 	rc = cc_pm_init(new_drvdata);
-	if (unlikely(rc)) {
+	if (rc) {
 		dev_err(dev, "ssi_power_mgr_init failed\n");
 		goto post_buf_mgr_err;
 	}
 
 	rc = ssi_ivgen_init(new_drvdata);
-	if (unlikely(rc)) {
+	if (rc) {
 		dev_err(dev, "ssi_ivgen_init failed\n");
 		goto post_power_mgr_err;
 	}
 
 	/* Allocate crypto algs */
 	rc = ssi_ablkcipher_alloc(new_drvdata);
-	if (unlikely(rc)) {
+	if (rc) {
 		dev_err(dev, "ssi_ablkcipher_alloc failed\n");
 		goto post_ivgen_err;
 	}
 
 	/* hash must be allocated before aead since hash exports APIs */
 	rc = ssi_hash_alloc(new_drvdata);
-	if (unlikely(rc)) {
+	if (rc) {
 		dev_err(dev, "ssi_hash_alloc failed\n");
 		goto post_cipher_err;
 	}
 
 	rc = ssi_aead_alloc(new_drvdata);
-	if (unlikely(rc)) {
+	if (rc) {
 		dev_err(dev, "ssi_aead_alloc failed\n");
 		goto post_hash_err;
 	}
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index c955e50..a33697b 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -116,9 +116,8 @@ static void ssi_hash_create_data_desc(
 
 static void ssi_set_hash_endianity(u32 mode, struct cc_hw_desc *desc)
 {
-	if (unlikely(mode == DRV_HASH_MD5 ||
-		     mode == DRV_HASH_SHA384 ||
-		     mode == DRV_HASH_SHA512)) {
+	if (mode == DRV_HASH_MD5 || mode == DRV_HASH_SHA384 ||
+	    mode == DRV_HASH_SHA512) {
 		set_bytes_swap(desc, 1);
 	} else {
 		set_cipher_config0(desc, HASH_DIGEST_RESULT_LITTLE_ENDIAN);
@@ -133,7 +132,7 @@ static int ssi_hash_map_result(struct device *dev,
 		dma_map_single(dev, (void *)state->digest_result_buff,
 			       digestsize,
 			       DMA_BIDIRECTIONAL);
-	if (unlikely(dma_mapping_error(dev, state->digest_result_dma_addr))) {
+	if (dma_mapping_error(dev, state->digest_result_dma_addr)) {
 		dev_err(dev, "Mapping digest result buffer %u B for DMA failed\n",
 			digestsize);
 		return -ENOMEM;
@@ -219,8 +218,8 @@ static int ssi_hash_map_request(struct device *dev,
 			memcpy(state->digest_buff, ctx->digest_buff,
 			       ctx->inter_digestsize);
 #if (DX_DEV_SHA_MAX > 256)
-			if (unlikely(ctx->hash_mode == DRV_HASH_SHA512 ||
-				     ctx->hash_mode == DRV_HASH_SHA384))
+			if (ctx->hash_mode == DRV_HASH_SHA512 ||
+			    ctx->hash_mode == DRV_HASH_SHA384)
 				memcpy(state->digest_bytes_len,
 				       digest_len_sha512_init, HASH_LEN_SIZE);
 			else
@@ -254,7 +253,7 @@ static int ssi_hash_map_request(struct device *dev,
 		set_flow_mode(&desc, BYPASS);
 
 		rc = send_request(ctx->drvdata, &ssi_req, &desc, 1, 0);
-		if (unlikely(rc)) {
+		if (rc) {
 			dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 			goto fail4;
 		}
@@ -446,18 +445,17 @@ static int ssi_hash_digest(struct ahash_req_ctx *state,
 	dev_dbg(dev, "===== %s-digest (%d) ====\n", is_hmac ? "hmac" : "hash",
 		nbytes);
 
-	if (unlikely(ssi_hash_map_request(dev, state, ctx))) {
+	if (ssi_hash_map_request(dev, state, ctx)) {
 		dev_err(dev, "map_ahash_source() failed\n");
 		return -ENOMEM;
 	}
 
-	if (unlikely(ssi_hash_map_result(dev, state, digestsize))) {
+	if (ssi_hash_map_result(dev, state, digestsize)) {
 		dev_err(dev, "map_ahash_digest() failed\n");
 		return -ENOMEM;
 	}
 
-	if (unlikely(cc_map_hash_request_final(ctx->drvdata, state,
-					       src, nbytes, 1))) {
+	if (cc_map_hash_request_final(ctx->drvdata, state, src, nbytes, 1)) {
 		dev_err(dev, "map_ahash_request_final() failed\n");
 		return -ENOMEM;
 	}
@@ -494,7 +492,7 @@ static int ssi_hash_digest(struct ahash_req_ctx *state,
 			     NS_BIT);
 	} else {
 		set_din_const(&desc[idx], 0, HASH_LEN_SIZE);
-		if (likely(nbytes))
+		if (nbytes)
 			set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
 		else
 			set_cipher_do(&desc[idx], DO_PAD);
@@ -576,7 +574,7 @@ ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
 
 	if (async_req) {
 		rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
-		if (unlikely(rc != -EINPROGRESS)) {
+		if (rc != -EINPROGRESS) {
 			dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 			cc_unmap_hash_request(dev, state, src, true);
 			ssi_hash_unmap_result(dev, state, digestsize, result);
@@ -619,7 +617,7 @@ static int ssi_hash_update(struct ahash_req_ctx *state,
 
 	rc = cc_map_hash_request_update(ctx->drvdata, state, src, nbytes,
 					block_size);
-	if (unlikely(rc)) {
+	if (rc) {
 		if (rc == 1) {
 			dev_dbg(dev, " data size not require HW update %x\n",
 				nbytes);
@@ -677,7 +675,7 @@ static int ssi_hash_update(struct ahash_req_ctx *state,
 
 	if (async_req) {
 		rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
-		if (unlikely(rc != -EINPROGRESS)) {
+		if (rc != -EINPROGRESS) {
 			dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 			cc_unmap_hash_request(dev, state, src, true);
 		}
@@ -711,12 +709,11 @@ static int ssi_hash_finup(struct ahash_req_ctx *state,
 	dev_dbg(dev, "===== %s-finup (%d) ====\n", is_hmac ? "hmac" : "hash",
 		nbytes);
 
-	if (unlikely(cc_map_hash_request_final(ctx->drvdata, state, src,
-					       nbytes, 1))) {
+	if (cc_map_hash_request_final(ctx->drvdata, state, src, nbytes, 1)) {
 		dev_err(dev, "map_ahash_request_final() failed\n");
 		return -ENOMEM;
 	}
-	if (unlikely(ssi_hash_map_result(dev, state, digestsize))) {
+	if (ssi_hash_map_result(dev, state, digestsize)) {
 		dev_err(dev, "map_ahash_digest() failed\n");
 		return -ENOMEM;
 	}
@@ -809,7 +806,7 @@ ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
 
 	if (async_req) {
 		rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
-		if (unlikely(rc != -EINPROGRESS)) {
+		if (rc != -EINPROGRESS) {
 			dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 			cc_unmap_hash_request(dev, state, src, true);
 			ssi_hash_unmap_result(dev, state, digestsize, result);
@@ -847,13 +844,12 @@ static int ssi_hash_final(struct ahash_req_ctx *state,
 	dev_dbg(dev, "===== %s-final (%d) ====\n", is_hmac ? "hmac" : "hash",
 		nbytes);
 
-	if (unlikely(cc_map_hash_request_final(ctx->drvdata, state, src,
-					       nbytes, 0))) {
+	if (cc_map_hash_request_final(ctx->drvdata, state, src, nbytes, 0)) {
 		dev_err(dev, "map_ahash_request_final() failed\n");
 		return -ENOMEM;
 	}
 
-	if (unlikely(ssi_hash_map_result(dev, state, digestsize))) {
+	if (ssi_hash_map_result(dev, state, digestsize)) {
 		dev_err(dev, "map_ahash_digest() failed\n");
 		return -ENOMEM;
 	}
@@ -955,7 +951,7 @@ ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
 
 	if (async_req) {
 		rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
-		if (unlikely(rc != -EINPROGRESS)) {
+		if (rc != -EINPROGRESS) {
 			dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 			cc_unmap_hash_request(dev, state, src, true);
 			ssi_hash_unmap_result(dev, state, digestsize, result);
@@ -1019,8 +1015,7 @@ static int ssi_ahash_setkey(struct crypto_ahash *ahash, const u8 *key,
 		ctx->key_params.key_dma_addr = dma_map_single(
 						dev, (void *)key,
 						keylen, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(dev,
-					       ctx->key_params.key_dma_addr))) {
+		if (dma_mapping_error(dev, ctx->key_params.key_dma_addr)) {
 			dev_err(dev, "Mapping key va=0x%p len=%u for DMA failed\n",
 				key, keylen);
 			return -ENOMEM;
@@ -1105,7 +1100,7 @@ static int ssi_ahash_setkey(struct crypto_ahash *ahash, const u8 *key,
 	}
 
 	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 0);
-	if (unlikely(rc)) {
+	if (rc) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		goto out;
 	}
@@ -1201,7 +1196,7 @@ static int ssi_xcbc_setkey(struct crypto_ahash *ahash,
 	ctx->key_params.key_dma_addr = dma_map_single(
 					dev, (void *)key,
 					keylen, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(dev, ctx->key_params.key_dma_addr))) {
+	if (dma_mapping_error(dev, ctx->key_params.key_dma_addr)) {
 		dev_err(dev, "Mapping key va=0x%p len=%u for DMA failed\n",
 			key, keylen);
 		return -ENOMEM;
@@ -1415,7 +1410,7 @@ static int ssi_mac_update(struct ahash_request *req)
 
 	rc = cc_map_hash_request_update(ctx->drvdata, state, req->src,
 					req->nbytes, block_size);
-	if (unlikely(rc)) {
+	if (rc) {
 		if (rc == 1) {
 			dev_dbg(dev, " data size not require HW update %x\n",
 				req->nbytes);
@@ -1448,7 +1443,7 @@ static int ssi_mac_update(struct ahash_request *req)
 	ssi_req.user_arg = (void *)req;
 
 	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
-	if (unlikely(rc != -EINPROGRESS)) {
+	if (rc != -EINPROGRESS) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, req->src, true);
 	}
@@ -1482,13 +1477,13 @@ static int ssi_mac_final(struct ahash_request *req)
 
 	dev_dbg(dev, "===== final  xcbc reminder (%d) ====\n", rem_cnt);
 
-	if (unlikely(cc_map_hash_request_final(ctx->drvdata, state, req->src,
-					       req->nbytes, 0))) {
+	if (cc_map_hash_request_final(ctx->drvdata, state, req->src,
+				      req->nbytes, 0)) {
 		dev_err(dev, "map_ahash_request_final() failed\n");
 		return -ENOMEM;
 	}
 
-	if (unlikely(ssi_hash_map_result(dev, state, digestsize))) {
+	if (ssi_hash_map_result(dev, state, digestsize)) {
 		dev_err(dev, "map_ahash_digest() failed\n");
 		return -ENOMEM;
 	}
@@ -1562,7 +1557,7 @@ static int ssi_mac_final(struct ahash_request *req)
 	idx++;
 
 	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
-	if (unlikely(rc != -EINPROGRESS)) {
+	if (rc != -EINPROGRESS) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, req->src, true);
 		ssi_hash_unmap_result(dev, state, digestsize, req->result);
@@ -1589,12 +1584,12 @@ static int ssi_mac_finup(struct ahash_request *req)
 		return ssi_mac_final(req);
 	}
 
-	if (unlikely(cc_map_hash_request_final(ctx->drvdata, state, req->src,
-					       req->nbytes, 1))) {
+	if (cc_map_hash_request_final(ctx->drvdata, state, req->src,
+				      req->nbytes, 1)) {
 		dev_err(dev, "map_ahash_request_final() failed\n");
 		return -ENOMEM;
 	}
-	if (unlikely(ssi_hash_map_result(dev, state, digestsize))) {
+	if (ssi_hash_map_result(dev, state, digestsize)) {
 		dev_err(dev, "map_ahash_digest() failed\n");
 		return -ENOMEM;
 	}
@@ -1635,7 +1630,7 @@ static int ssi_mac_finup(struct ahash_request *req)
 	idx++;
 
 	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
-	if (unlikely(rc != -EINPROGRESS)) {
+	if (rc != -EINPROGRESS) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, req->src, true);
 		ssi_hash_unmap_result(dev, state, digestsize, req->result);
@@ -1658,17 +1653,17 @@ static int ssi_mac_digest(struct ahash_request *req)
 
 	dev_dbg(dev, "===== -digest mac (%d) ====\n",  req->nbytes);
 
-	if (unlikely(ssi_hash_map_request(dev, state, ctx))) {
+	if (ssi_hash_map_request(dev, state, ctx)) {
 		dev_err(dev, "map_ahash_source() failed\n");
 		return -ENOMEM;
 	}
-	if (unlikely(ssi_hash_map_result(dev, state, digestsize))) {
+	if (ssi_hash_map_result(dev, state, digestsize)) {
 		dev_err(dev, "map_ahash_digest() failed\n");
 		return -ENOMEM;
 	}
 
-	if (unlikely(cc_map_hash_request_final(ctx->drvdata, state, req->src,
-					       req->nbytes, 1))) {
+	if (cc_map_hash_request_final(ctx->drvdata, state, req->src,
+				      req->nbytes, 1)) {
 		dev_err(dev, "map_ahash_request_final() failed\n");
 		return -ENOMEM;
 	}
@@ -1709,7 +1704,7 @@ static int ssi_mac_digest(struct ahash_request *req)
 	idx++;
 
 	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
-	if (unlikely(rc != -EINPROGRESS)) {
+	if (rc != -EINPROGRESS) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, req->src, true);
 		ssi_hash_unmap_result(dev, state, digestsize, req->result);
@@ -2153,7 +2148,7 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 			 ARRAY_SIZE(digest_len_init), larval_seq,
 			 &larval_seq_len);
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
-	if (unlikely(rc))
+	if (rc)
 		goto init_digest_const_err;
 
 	sram_buff_ofs += sizeof(digest_len_init);
@@ -2165,7 +2160,7 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 			 ARRAY_SIZE(digest_len_sha512_init),
 			 larval_seq, &larval_seq_len);
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
-	if (unlikely(rc))
+	if (rc)
 		goto init_digest_const_err;
 
 	sram_buff_ofs += sizeof(digest_len_sha512_init);
@@ -2180,7 +2175,7 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 			 ARRAY_SIZE(md5_init), larval_seq,
 			 &larval_seq_len);
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
-	if (unlikely(rc))
+	if (rc)
 		goto init_digest_const_err;
 	sram_buff_ofs += sizeof(md5_init);
 	larval_seq_len = 0;
@@ -2189,7 +2184,7 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 			 ARRAY_SIZE(sha1_init), larval_seq,
 			 &larval_seq_len);
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
-	if (unlikely(rc))
+	if (rc)
 		goto init_digest_const_err;
 	sram_buff_ofs += sizeof(sha1_init);
 	larval_seq_len = 0;
@@ -2198,7 +2193,7 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 			 ARRAY_SIZE(sha224_init), larval_seq,
 			 &larval_seq_len);
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
-	if (unlikely(rc))
+	if (rc)
 		goto init_digest_const_err;
 	sram_buff_ofs += sizeof(sha224_init);
 	larval_seq_len = 0;
@@ -2207,7 +2202,7 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 			 ARRAY_SIZE(sha256_init), larval_seq,
 			 &larval_seq_len);
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
-	if (unlikely(rc))
+	if (rc)
 		goto init_digest_const_err;
 	sram_buff_ofs += sizeof(sha256_init);
 	larval_seq_len = 0;
@@ -2228,7 +2223,7 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 		sram_buff_ofs += sizeof(u32);
 	}
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
-	if (unlikely(rc)) {
+	if (rc) {
 		dev_err(dev, "send_request() failed (rc = %d)\n", rc);
 		goto init_digest_const_err;
 	}
@@ -2246,7 +2241,7 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 		sram_buff_ofs += sizeof(u32);
 	}
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
-	if (unlikely(rc)) {
+	if (rc) {
 		dev_err(dev, "send_request() failed (rc = %d)\n", rc);
 		goto init_digest_const_err;
 	}
@@ -2295,7 +2290,7 @@ int ssi_hash_alloc(struct ssi_drvdata *drvdata)
 
 	/*must be set before the alg registration as it is being used there*/
 	rc = ssi_hash_init_sram_digest_consts(drvdata);
-	if (unlikely(rc)) {
+	if (rc) {
 		dev_err(dev, "Init digest CONST failed (rc=%d)\n", rc);
 		goto fail;
 	}
@@ -2316,7 +2311,7 @@ int ssi_hash_alloc(struct ssi_drvdata *drvdata)
 		t_alg->drvdata = drvdata;
 
 		rc = crypto_register_ahash(&t_alg->ahash_alg);
-		if (unlikely(rc)) {
+		if (rc) {
 			dev_err(dev, "%s alg registration failed\n",
 				driver_hash[alg].driver_name);
 			kfree(t_alg);
@@ -2341,7 +2336,7 @@ int ssi_hash_alloc(struct ssi_drvdata *drvdata)
 		t_alg->drvdata = drvdata;
 
 		rc = crypto_register_ahash(&t_alg->ahash_alg);
-		if (unlikely(rc)) {
+		if (rc) {
 			dev_err(dev, "%s alg registration failed\n",
 				driver_hash[alg].driver_name);
 			kfree(t_alg);
@@ -2480,7 +2475,7 @@ static void ssi_hash_create_data_desc(struct ahash_req_ctx *areq_ctx,
 	unsigned int idx = *seq_size;
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 
-	if (likely(areq_ctx->data_dma_buf_type == SSI_DMA_BUF_DLLI)) {
+	if (areq_ctx->data_dma_buf_type == SSI_DMA_BUF_DLLI) {
 		hw_desc_init(&desc[idx]);
 		set_din_type(&desc[idx], DMA_DLLI,
 			     sg_dma_address(areq_ctx->curr_sg),
diff --git a/drivers/staging/ccree/ssi_ivgen.c b/drivers/staging/ccree/ssi_ivgen.c
index 4ca6ca7..febee22 100644
--- a/drivers/staging/ccree/ssi_ivgen.c
+++ b/drivers/staging/ccree/ssi_ivgen.c
@@ -143,7 +143,7 @@ int ssi_ivgen_init_sram_pool(struct ssi_drvdata *drvdata)
 
 	/* Generate initial pool */
 	rc = ssi_ivgen_generate_pool(ivgen_ctx, iv_seq, &iv_seq_len);
-	if (unlikely(rc))
+	if (rc)
 		return rc;
 
 	/* Fire-and-forget */
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index 9883d14..7a653f6 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -115,7 +115,7 @@ int request_mgr_init(struct ssi_drvdata *drvdata)
 #ifdef COMP_IN_WQ
 	dev_dbg(dev, "Initializing completion workqueue\n");
 	req_mgr_h->workq = create_singlethread_workqueue("arm_cc7x_wq");
-	if (unlikely(!req_mgr_h->workq)) {
+	if (!req_mgr_h->workq) {
 		dev_err(dev, "Failed creating work queue\n");
 		rc = -ENOMEM;
 		goto req_mgr_init_err;
@@ -214,27 +214,25 @@ static int request_mgr_queues_status_check(
 	 * be chaned during the poll because the spinlock_bh
 	 * is held by the thread
 	 */
-	if (unlikely(((req_mgr_h->req_queue_head + 1) &
-		      (MAX_REQUEST_QUEUE_SIZE - 1)) ==
-		     req_mgr_h->req_queue_tail)) {
+	if (((req_mgr_h->req_queue_head + 1) & (MAX_REQUEST_QUEUE_SIZE - 1)) ==
+	    req_mgr_h->req_queue_tail) {
 		dev_err(dev, "SW FIFO is full. req_queue_head=%d sw_fifo_len=%d\n",
 			req_mgr_h->req_queue_head, MAX_REQUEST_QUEUE_SIZE);
 		return -EBUSY;
 	}
 
-	if ((likely(req_mgr_h->q_free_slots >= total_seq_len)))
+	if ((req_mgr_h->q_free_slots >= total_seq_len))
 		return 0;
 
 	/* Wait for space in HW queue. Poll constant num of iterations. */
 	for (poll_queue = 0; poll_queue < SSI_MAX_POLL_ITER ; poll_queue++) {
 		req_mgr_h->q_free_slots =
 			cc_ioread(drvdata, CC_REG(DSCRPTR_QUEUE_CONTENT));
-		if (unlikely(req_mgr_h->q_free_slots <
-						req_mgr_h->min_free_hw_slots)) {
+		if (req_mgr_h->q_free_slots < req_mgr_h->min_free_hw_slots) {
 			req_mgr_h->min_free_hw_slots = req_mgr_h->q_free_slots;
 		}
 
-		if (likely(req_mgr_h->q_free_slots >= total_seq_len)) {
+		if (req_mgr_h->q_free_slots >= total_seq_len) {
 			/* If there is enough place return */
 			return 0;
 		}
@@ -296,7 +294,7 @@ int send_request(
 		 */
 		rc = request_mgr_queues_status_check(drvdata, req_mgr_h,
 						     max_required_seq_len);
-		if (likely(rc == 0))
+		if (rc == 0)
 			/* There is enough place in the queue */
 			break;
 		/* something wrong release the spinlock*/
@@ -340,7 +338,7 @@ int send_request(
 				     ssi_req->ivgen_dma_addr_len,
 				     ssi_req->ivgen_size, iv_seq, &iv_seq_len);
 
-		if (unlikely(rc)) {
+		if (rc) {
 			dev_err(dev, "Failed to generate IV (rc=%d)\n", rc);
 			spin_unlock_bh(&req_mgr_h->hw_lock);
 #if defined(CONFIG_PM)
@@ -355,7 +353,7 @@ int send_request(
 	used_sw_slots = ((req_mgr_h->req_queue_head -
 			  req_mgr_h->req_queue_tail) &
 			 (MAX_REQUEST_QUEUE_SIZE - 1));
-	if (unlikely(used_sw_slots > req_mgr_h->max_used_sw_slots))
+	if (used_sw_slots > req_mgr_h->max_used_sw_slots)
 		req_mgr_h->max_used_sw_slots = used_sw_slots;
 
 	/* Enqueue request - must be locked with HW lock*/
@@ -381,7 +379,7 @@ int send_request(
 	enqueue_seq(cc_base, desc, len);
 	enqueue_seq(cc_base, &req_mgr_h->compl_desc, (is_dout ? 0 : 1));
 
-	if (unlikely(req_mgr_h->q_free_slots < total_seq_len)) {
+	if (req_mgr_h->q_free_slots < total_seq_len) {
 		/* This situation should never occur. Maybe indicating problem
 		 * with resuming power. Set the free slot count to 0 and hope
 		 * for the best.
@@ -429,7 +427,7 @@ int send_request_init(
 	 */
 	rc = request_mgr_queues_status_check(drvdata, req_mgr_h,
 					     total_seq_len);
-	if (unlikely(rc))
+	if (rc)
 		return rc;
 
 	set_queue_last_ind(&desc[(len - 1)]);
@@ -489,7 +487,7 @@ static void proc_completions(struct ssi_drvdata *drvdata)
 		request_mgr_handle->axi_completed--;
 
 		/* Dequeue request */
-		if (unlikely(*head == *tail)) {
+		if (*head == *tail) {
 			/* We are supposed to handle a completion but our
 			 * queue is empty. This is not normal. Return and
 			 * hope for the best.
@@ -518,7 +516,7 @@ static void proc_completions(struct ssi_drvdata *drvdata)
 		}
 #endif /* COMPLETION_DELAY */
 
-		if (likely(ssi_req->user_cb))
+		if (ssi_req->user_cb)
 			ssi_req->user_cb(dev, ssi_req->user_arg);
 		*tail = (*tail + 1) & (MAX_REQUEST_QUEUE_SIZE - 1);
 		dev_dbg(dev, "Dequeue request tail=%u\n", *tail);
diff --git a/drivers/staging/ccree/ssi_sram_mgr.c b/drivers/staging/ccree/ssi_sram_mgr.c
index b71460c..0704031 100644
--- a/drivers/staging/ccree/ssi_sram_mgr.c
+++ b/drivers/staging/ccree/ssi_sram_mgr.c
@@ -75,12 +75,12 @@ ssi_sram_addr_t cc_sram_alloc(struct ssi_drvdata *drvdata, u32 size)
 	struct device *dev = drvdata_to_dev(drvdata);
 	ssi_sram_addr_t p;
 
-	if (unlikely((size & 0x3))) {
+	if ((size & 0x3)) {
 		dev_err(dev, "Requested buffer size (%u) is not multiple of 4",
 			size);
 		return NULL_SRAM_ADDR;
 	}
-	if (unlikely(size > (SSI_CC_SRAM_SIZE - smgr_ctx->sram_free_offset))) {
+	if (size > (SSI_CC_SRAM_SIZE - smgr_ctx->sram_free_offset)) {
 		dev_err(dev, "Not enough space to allocate %u B (at offset %llu)\n",
 			size, smgr_ctx->sram_free_offset);
 		return NULL_SRAM_ADDR;
-- 
2.7.4
