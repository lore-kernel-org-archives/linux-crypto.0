From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 7/8] staging: ccree: remove compare to none zero
Date: Tue,  7 Nov 2017 09:40:03 +0000
Message-ID: <1510047606-5589-8-git-send-email-gilad@benyossef.com>
References: <1510047606-5589-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1510047606-5589-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The driver was full of code checking "if (x != 0)".
Replace by "if (x)" for better readability.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c        | 34 +++++++-------
 drivers/staging/ccree/ssi_buffer_mgr.c  | 74 ++++++++++++++---------------
 drivers/staging/ccree/ssi_cipher.c      | 14 +++---
 drivers/staging/ccree/ssi_driver.c      | 34 +++++++-------
 drivers/staging/ccree/ssi_hash.c        | 82 ++++++++++++++++-----------------
 drivers/staging/ccree/ssi_ivgen.c       |  2 +-
 drivers/staging/ccree/ssi_pm.c          |  8 ++--
 drivers/staging/ccree/ssi_request_mgr.c | 12 ++---
 drivers/staging/ccree/ssi_sram_mgr.c    |  2 +-
 9 files changed, 131 insertions(+), 131 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index f1a3976..e9d03ee 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -240,7 +240,7 @@ static void ssi_aead_complete(struct device *dev, void *ssi_req, void __iomem *c
 
 	if (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT) {
 		if (memcmp(areq_ctx->mac_buf, areq_ctx->icv_virt_addr,
-			   ctx->authsize) != 0) {
+			   ctx->authsize)) {
 			dev_dbg(dev, "Payload authentication failure, (auth-size=%d, cipher=%d)\n",
 				ctx->authsize, ctx->cipher_mode);
 			/* In case of payload authentication failure, MUST NOT
@@ -458,7 +458,7 @@ ssi_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key, unsigned int keyl
 		hashmode = DRV_HASH_HW_SHA256;
 	}
 
-	if (likely(keylen != 0)) {
+	if (likely(keylen)) {
 		key_dma_addr = dma_map_single(dev, (void *)key, keylen, DMA_TO_DEVICE);
 		if (unlikely(dma_mapping_error(dev, key_dma_addr))) {
 			dev_err(dev, "Mapping key va=0x%p len=%u for DMA failed\n",
@@ -517,7 +517,7 @@ ssi_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key, unsigned int keyl
 				      keylen, NS_BIT, 0);
 			idx++;
 
-			if ((blocksize - keylen) != 0) {
+			if (blocksize - keylen) {
 				hw_desc_init(&desc[idx]);
 				set_din_const(&desc[idx], 0,
 					      (blocksize - keylen));
@@ -539,10 +539,10 @@ ssi_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key, unsigned int keyl
 	}
 
 	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 0);
-	if (unlikely(rc != 0))
+	if (unlikely(rc))
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 
-	if (likely(key_dma_addr != 0))
+	if (likely(key_dma_addr))
 		dma_unmap_single(dev, key_dma_addr, keylen, DMA_TO_DEVICE);
 
 	return rc;
@@ -598,7 +598,7 @@ ssi_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 	}
 
 	rc = validate_keys_sizes(ctx);
-	if (unlikely(rc != 0))
+	if (unlikely(rc))
 		goto badkey;
 
 	/* STAT_PHASE_1: Copy key to ctx */
@@ -611,7 +611,7 @@ ssi_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 		memcpy(ctx->auth_state.xcbc.xcbc_keys, key, ctx->auth_keylen);
 	} else if (ctx->auth_mode != DRV_HASH_NULL) { /* HMAC */
 		rc = ssi_get_plain_hmac_key(tfm, key, ctx->auth_keylen);
-		if (rc != 0)
+		if (rc)
 			goto badkey;
 	}
 
@@ -637,7 +637,7 @@ ssi_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 
 	if (seq_len > 0) { /* For CCM there is no sequence to setup the key */
 		rc = send_request(ctx->drvdata, &ssi_req, desc, seq_len, 0);
-		if (unlikely(rc != 0)) {
+		if (unlikely(rc)) {
 			dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 			goto setkey_error;
 		}
@@ -1520,7 +1520,7 @@ static inline int ssi_aead_ccm(
 	}
 
 	/* process the cipher */
-	if (req_ctx->cryptlen != 0)
+	if (req_ctx->cryptlen)
 		ssi_aead_process_cipher_data_desc(req, cipher_flow_mode, desc, &idx);
 
 	/* Read temporal MAC */
@@ -1602,7 +1602,7 @@ static int config_ccm_adata(struct aead_request *req)
 		*b0 |= 64;  /* Enable bit 6 if Adata exists. */
 
 	rc = set_msg_len(b0 + 16 - l, cryptlen, l);  /* Write L'. */
-	if (rc != 0) {
+	if (rc) {
 		dev_err(dev, "message len overflow detected");
 		return rc;
 	}
@@ -1739,7 +1739,7 @@ static inline void ssi_aead_gcm_setup_gctr_desc(
 	set_flow_mode(&desc[idx], S_DIN_to_AES);
 	idx++;
 
-	if ((req_ctx->cryptlen != 0) && (!req_ctx->plaintext_authenticate_only)) {
+	if (req_ctx->cryptlen && !req_ctx->plaintext_authenticate_only) {
 		/* load AES/CTR initial CTR value inc by 2*/
 		hw_desc_init(&desc[idx]);
 		set_cipher_mode(&desc[idx], DRV_CIPHER_GCTR);
@@ -1854,7 +1854,7 @@ static inline int ssi_aead_gcm(
 		ssi_aead_create_assoc_desc(req, DIN_HASH, desc, seq_size);
 	ssi_aead_gcm_setup_gctr_desc(req, desc, seq_size);
 	/* process(gctr+ghash) */
-	if (req_ctx->cryptlen != 0)
+	if (req_ctx->cryptlen)
 		ssi_aead_process_cipher_data_desc(req, cipher_flow_mode, desc, seq_size);
 	ssi_aead_process_gcm_result_desc(req, desc, seq_size);
 
@@ -1984,7 +1984,7 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 	/* STAT_PHASE_0: Init and sanity checks */
 
 	/* Check data length according to mode */
-	if (unlikely(validate_data_size(ctx, direct, req) != 0)) {
+	if (unlikely(validate_data_size(ctx, direct, req))) {
 		dev_err(dev, "Unsupported crypt/assoc len %d/%d.\n",
 			req->cryptlen, req->assoclen);
 		crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_BLOCK_LEN);
@@ -2031,7 +2031,7 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 #if SSI_CC_HAS_AES_CCM
 	if (ctx->cipher_mode == DRV_CIPHER_CCM) {
 		rc = config_ccm_adata(req);
-		if (unlikely(rc != 0)) {
+		if (unlikely(rc)) {
 			dev_dbg(dev, "config_ccm_adata() returned with a failure %d!",
 				rc);
 			goto exit;
@@ -2046,7 +2046,7 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 #if SSI_CC_HAS_AES_GCM
 	if (ctx->cipher_mode == DRV_CIPHER_GCTR) {
 		rc = config_gcm_context(req);
-		if (unlikely(rc != 0)) {
+		if (unlikely(rc)) {
 			dev_dbg(dev, "config_gcm_context() returned with a failure %d!",
 				rc);
 			goto exit;
@@ -2055,7 +2055,7 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 #endif /*SSI_CC_HAS_AES_GCM*/
 
 	rc = cc_map_aead_request(ctx->drvdata, req);
-	if (unlikely(rc != 0)) {
+	if (unlikely(rc)) {
 		dev_err(dev, "map_request() failed\n");
 		goto exit;
 	}
@@ -2774,7 +2774,7 @@ int ssi_aead_alloc(struct ssi_drvdata *drvdata)
 		}
 		t_alg->drvdata = drvdata;
 		rc = crypto_register_aead(&t_alg->aead_alg);
-		if (unlikely(rc != 0)) {
+		if (unlikely(rc)) {
 			dev_err(dev, "%s alg registration failed\n",
 				t_alg->aead_alg.base.cra_driver_name);
 			goto fail2;
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index f3076f3..838e973 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -98,8 +98,8 @@ static unsigned int cc_get_sgl_nents(
 {
 	unsigned int nents = 0;
 
-	while (nbytes != 0) {
-		if (sg_list->length != 0) {
+	while (nbytes) {
+		if (sg_list->length) {
 			nents++;
 			/* get the number of bytes in the last entry */
 			*lbytes = nbytes;
@@ -203,7 +203,7 @@ static inline int cc_render_sg_to_mlli(
 	u32 *mlli_entry_p = *mlli_entry_pp;
 	s32 rc = 0;
 
-	for ( ; (curr_sgl) && (sgl_data_len != 0);
+	for ( ; (curr_sgl && sgl_data_len);
 	      curr_sgl = sg_next(curr_sgl)) {
 		u32 entry_data_len =
 			(sgl_data_len > sg_dma_len(curr_sgl) - sgl_offset) ?
@@ -213,7 +213,7 @@ static inline int cc_render_sg_to_mlli(
 		rc = cc_render_buff_to_mlli(dev, sg_dma_address(curr_sgl) +
 					    sgl_offset, entry_data_len,
 					    curr_nents, &mlli_entry_p);
-		if (rc != 0)
+		if (rc)
 			return rc;
 
 		sgl_offset = 0;
@@ -258,7 +258,7 @@ static int cc_generate_mlli(
 			rc = cc_render_buff_to_mlli(dev, entry->buffer_dma,
 						    tot_len, &total_nents,
 						    &mlli_p);
-		if (rc != 0)
+		if (rc)
 			return rc;
 
 		/* set last bit in the current table */
@@ -480,7 +480,7 @@ void cc_unmap_blkcipher_request(
 {
 	struct blkcipher_req_ctx *req_ctx = (struct blkcipher_req_ctx *)ctx;
 
-	if (likely(req_ctx->gen_ctx.iv_dma_addr != 0)) {
+	if (likely(req_ctx->gen_ctx.iv_dma_addr)) {
 		dev_dbg(dev, "Unmapped iv: iv_dma_addr=%pad iv_size=%u\n",
 			&req_ctx->gen_ctx.iv_dma_addr, ivsize);
 		dma_unmap_single(dev, req_ctx->gen_ctx.iv_dma_addr,
@@ -527,7 +527,7 @@ int cc_map_blkcipher_request(
 	sg_data.num_of_buffers = 0;
 
 	/* Map IV buffer */
-	if (likely(ivsize != 0)) {
+	if (likely(ivsize)) {
 		dump_byte_array("iv", (u8 *)info, ivsize);
 		req_ctx->gen_ctx.iv_dma_addr =
 			dma_map_single(dev, (void *)info,
@@ -549,7 +549,7 @@ int cc_map_blkcipher_request(
 	/* Map the src SGL */
 	rc = cc_map_sg(dev, src, nbytes, DMA_BIDIRECTIONAL, &req_ctx->in_nents,
 		       LLI_MAX_NUM_OF_DATA_ENTRIES, &dummy, &mapped_nents);
-	if (unlikely(rc != 0)) {
+	if (unlikely(rc)) {
 		rc = -ENOMEM;
 		goto ablkcipher_exit;
 	}
@@ -589,7 +589,7 @@ int cc_map_blkcipher_request(
 	if (unlikely(req_ctx->dma_buf_type == SSI_DMA_BUF_MLLI)) {
 		mlli_params->curr_pool = buff_mgr->mlli_buffs_pool;
 		rc = cc_generate_mlli(dev, &sg_data, mlli_params);
-		if (unlikely(rc != 0))
+		if (unlikely(rc))
 			goto ablkcipher_exit;
 	}
 
@@ -613,29 +613,29 @@ void cc_unmap_aead_request(struct device *dev, struct aead_request *req)
 	bool chained;
 	u32 size_to_unmap = 0;
 
-	if (areq_ctx->mac_buf_dma_addr != 0) {
+	if (areq_ctx->mac_buf_dma_addr) {
 		dma_unmap_single(dev, areq_ctx->mac_buf_dma_addr,
 				 MAX_MAC_SIZE, DMA_BIDIRECTIONAL);
 	}
 
 #if SSI_CC_HAS_AES_GCM
 	if (areq_ctx->cipher_mode == DRV_CIPHER_GCTR) {
-		if (areq_ctx->hkey_dma_addr != 0) {
+		if (areq_ctx->hkey_dma_addr) {
 			dma_unmap_single(dev, areq_ctx->hkey_dma_addr,
 					 AES_BLOCK_SIZE, DMA_BIDIRECTIONAL);
 		}
 
-		if (areq_ctx->gcm_block_len_dma_addr != 0) {
+		if (areq_ctx->gcm_block_len_dma_addr) {
 			dma_unmap_single(dev, areq_ctx->gcm_block_len_dma_addr,
 					 AES_BLOCK_SIZE, DMA_TO_DEVICE);
 		}
 
-		if (areq_ctx->gcm_iv_inc1_dma_addr != 0) {
+		if (areq_ctx->gcm_iv_inc1_dma_addr) {
 			dma_unmap_single(dev, areq_ctx->gcm_iv_inc1_dma_addr,
 					 AES_BLOCK_SIZE, DMA_TO_DEVICE);
 		}
 
-		if (areq_ctx->gcm_iv_inc2_dma_addr != 0) {
+		if (areq_ctx->gcm_iv_inc2_dma_addr) {
 			dma_unmap_single(dev, areq_ctx->gcm_iv_inc2_dma_addr,
 					 AES_BLOCK_SIZE, DMA_TO_DEVICE);
 		}
@@ -643,14 +643,14 @@ void cc_unmap_aead_request(struct device *dev, struct aead_request *req)
 #endif
 
 	if (areq_ctx->ccm_hdr_size != ccm_header_size_null) {
-		if (areq_ctx->ccm_iv0_dma_addr != 0) {
+		if (areq_ctx->ccm_iv0_dma_addr) {
 			dma_unmap_single(dev, areq_ctx->ccm_iv0_dma_addr,
 					 AES_BLOCK_SIZE, DMA_TO_DEVICE);
 		}
 
 		dma_unmap_sg(dev, &areq_ctx->ccm_adata_sg, 1, DMA_TO_DEVICE);
 	}
-	if (areq_ctx->gen_ctx.iv_dma_addr != 0) {
+	if (areq_ctx->gen_ctx.iv_dma_addr) {
 		dma_unmap_single(dev, areq_ctx->gen_ctx.iv_dma_addr,
 				 hw_iv_size, DMA_BIDIRECTIONAL);
 	}
@@ -1124,7 +1124,7 @@ static inline int cc_aead_chain_data(
 			       &areq_ctx->dst.nents,
 			       LLI_MAX_NUM_OF_DATA_ENTRIES, &dst_last_bytes,
 			       &dst_mapped_nents);
-		if (unlikely(rc != 0)) {
+		if (unlikely(rc)) {
 			rc = -ENOMEM;
 			goto chain_data_exit;
 		}
@@ -1283,7 +1283,7 @@ int cc_map_aead_request(
 		}
 		if (ssi_aead_handle_config_buf(dev, areq_ctx,
 					       areq_ctx->ccm_config, &sg_data,
-					       req->assoclen) != 0) {
+					       req->assoclen)) {
 			rc = -ENOMEM;
 			goto aead_map_failure;
 		}
@@ -1352,7 +1352,7 @@ int cc_map_aead_request(
 		       (LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES +
 			LLI_MAX_NUM_OF_DATA_ENTRIES),
 		       &dummy, &mapped_nents);
-	if (unlikely(rc != 0)) {
+	if (unlikely(rc)) {
 		rc = -ENOMEM;
 		goto aead_map_failure;
 	}
@@ -1365,13 +1365,13 @@ int cc_map_aead_request(
 		 *   Note: IV is contg. buffer (not an SGL)
 		 */
 		rc = cc_aead_chain_assoc(drvdata, req, &sg_data, true, false);
-		if (unlikely(rc != 0))
+		if (unlikely(rc))
 			goto aead_map_failure;
 		rc = cc_aead_chain_iv(drvdata, req, &sg_data, true, false);
-		if (unlikely(rc != 0))
+		if (unlikely(rc))
 			goto aead_map_failure;
 		rc = cc_aead_chain_data(drvdata, req, &sg_data, true, false);
-		if (unlikely(rc != 0))
+		if (unlikely(rc))
 			goto aead_map_failure;
 	} else { /* DOUBLE-PASS flow */
 		/*
@@ -1395,13 +1395,13 @@ int cc_map_aead_request(
 		 *   (4) MLLI for dst
 		 */
 		rc = cc_aead_chain_assoc(drvdata, req, &sg_data, false, true);
-		if (unlikely(rc != 0))
+		if (unlikely(rc))
 			goto aead_map_failure;
 		rc = cc_aead_chain_iv(drvdata, req, &sg_data, false, true);
-		if (unlikely(rc != 0))
+		if (unlikely(rc))
 			goto aead_map_failure;
 		rc = cc_aead_chain_data(drvdata, req, &sg_data, true, true);
-		if (unlikely(rc != 0))
+		if (unlikely(rc))
 			goto aead_map_failure;
 	}
 
@@ -1411,7 +1411,7 @@ int cc_map_aead_request(
 		(areq_ctx->data_buff_type == SSI_DMA_BUF_MLLI))) {
 		mlli_params->curr_pool = buff_mgr->mlli_buffs_pool;
 		rc = cc_generate_mlli(dev, &sg_data, mlli_params);
-		if (unlikely(rc != 0))
+		if (unlikely(rc))
 			goto aead_map_failure;
 
 		cc_update_aead_mlli_nents(drvdata, req);
@@ -1458,9 +1458,9 @@ int cc_map_hash_request_final(struct ssi_drvdata *drvdata, void *ctx,
 
 	/*TODO: copy data in case that buffer is enough for operation */
 	/* map the previous buffer */
-	if (*curr_buff_cnt != 0) {
+	if (*curr_buff_cnt) {
 		if (ssi_ahash_handle_curr_buf(dev, areq_ctx, curr_buff,
-					      *curr_buff_cnt, &sg_data) != 0) {
+					      *curr_buff_cnt, &sg_data)) {
 			return -ENOMEM;
 		}
 	}
@@ -1490,7 +1490,7 @@ int cc_map_hash_request_final(struct ssi_drvdata *drvdata, void *ctx,
 		/* add the src data to the sg_data */
 		cc_add_sg_entry(dev, &sg_data, areq_ctx->in_nents, src, nbytes,
 				0, true, &areq_ctx->mlli_nents);
-		if (unlikely(cc_generate_mlli(dev, &sg_data, mlli_params) != 0)) {
+		if (unlikely(cc_generate_mlli(dev, &sg_data, mlli_params))) {
 			goto fail_unmap_din;
 		}
 	}
@@ -1504,7 +1504,7 @@ int cc_map_hash_request_final(struct ssi_drvdata *drvdata, void *ctx,
 	dma_unmap_sg(dev, src, areq_ctx->in_nents, DMA_TO_DEVICE);
 
 unmap_curr_buff:
-	if (*curr_buff_cnt != 0)
+	if (*curr_buff_cnt)
 		dma_unmap_sg(dev, areq_ctx->buff_sg, 1, DMA_TO_DEVICE);
 
 	return -ENOMEM;
@@ -1562,7 +1562,7 @@ int cc_map_hash_request_update(struct ssi_drvdata *drvdata, void *ctx,
 		*next_buff_cnt, update_data_len);
 
 	/* Copy the new residue to next buffer */
-	if (*next_buff_cnt != 0) {
+	if (*next_buff_cnt) {
 		dev_dbg(dev, " handle residue: next buff %pK skip data %u residue %u\n",
 			next_buff, (update_data_len - *curr_buff_cnt),
 			*next_buff_cnt);
@@ -1573,9 +1573,9 @@ int cc_map_hash_request_update(struct ssi_drvdata *drvdata, void *ctx,
 		swap_index = 1;
 	}
 
-	if (*curr_buff_cnt != 0) {
+	if (*curr_buff_cnt) {
 		if (ssi_ahash_handle_curr_buf(dev, areq_ctx, curr_buff,
-					      *curr_buff_cnt, &sg_data) != 0) {
+					      *curr_buff_cnt, &sg_data)) {
 			return -ENOMEM;
 		}
 		/* change the buffer index for next operation */
@@ -1609,7 +1609,7 @@ int cc_map_hash_request_update(struct ssi_drvdata *drvdata, void *ctx,
 		cc_add_sg_entry(dev, &sg_data, areq_ctx->in_nents, src,
 				(update_data_len - *curr_buff_cnt), 0, true,
 				&areq_ctx->mlli_nents);
-		if (unlikely(cc_generate_mlli(dev, &sg_data, mlli_params) != 0)) {
+		if (unlikely(cc_generate_mlli(dev, &sg_data, mlli_params))) {
 			goto fail_unmap_din;
 		}
 	}
@@ -1621,7 +1621,7 @@ int cc_map_hash_request_update(struct ssi_drvdata *drvdata, void *ctx,
 	dma_unmap_sg(dev, src, areq_ctx->in_nents, DMA_TO_DEVICE);
 
 unmap_curr_buff:
-	if (*curr_buff_cnt != 0)
+	if (*curr_buff_cnt)
 		dma_unmap_sg(dev, areq_ctx->buff_sg, 1, DMA_TO_DEVICE);
 
 	return -ENOMEM;
@@ -1646,14 +1646,14 @@ void cc_unmap_hash_request(struct device *dev, void *ctx,
 			      areq_ctx->mlli_params.mlli_dma_addr);
 	}
 
-	if ((src) && likely(areq_ctx->in_nents != 0)) {
+	if ((src) && likely(areq_ctx->in_nents)) {
 		dev_dbg(dev, "Unmapped sg src: virt=%pK dma=%pad len=0x%X\n",
 			sg_virt(src), &sg_dma_address(src), sg_dma_len(src));
 		dma_unmap_sg(dev, src,
 			     areq_ctx->in_nents, DMA_TO_DEVICE);
 	}
 
-	if (*prev_len != 0) {
+	if (*prev_len) {
 		dev_dbg(dev, "Unmapped buffer: areq_ctx->buff_sg=%pK dma=%pad len 0x%X\n",
 			sg_virt(areq_ctx->buff_sg),
 			&sg_dma_address(areq_ctx->buff_sg),
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 721acf4..4d05b4a 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -311,7 +311,7 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 		keylen -= 1;
 #endif /*SSI_CC_HAS_MULTI2*/
 
-	if (unlikely(validate_keys_sizes(ctx_p, keylen) != 0)) {
+	if (unlikely(validate_keys_sizes(ctx_p, keylen))) {
 		dev_err(dev, "Unsupported key size %d.\n", keylen);
 		crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
@@ -365,13 +365,13 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 		}
 	}
 	if ((ctx_p->cipher_mode == DRV_CIPHER_XTS) &&
-	    xts_check_key(tfm, key, keylen) != 0) {
+	    xts_check_key(tfm, key, keylen)) {
 		dev_dbg(dev, "weak XTS key");
 		return -EINVAL;
 	}
 	if ((ctx_p->flow_mode == S_DIN_to_DES) &&
 	    (keylen == DES3_EDE_KEY_SIZE) &&
-	    ssi_verify_3des_keys(key, keylen) != 0) {
+	    ssi_verify_3des_keys(key, keylen)) {
 		dev_dbg(dev, "weak 3DES key");
 		return -EINVAL;
 	}
@@ -788,7 +788,7 @@ static int ssi_blkcipher_process(
 
 	rc = cc_map_blkcipher_request(ctx_p->drvdata, req_ctx, ivsize, nbytes,
 				      req_ctx->iv, src, dst);
-	if (unlikely(rc != 0)) {
+	if (unlikely(rc)) {
 		dev_err(dev, "map_request() failed\n");
 		goto exit_process;
 	}
@@ -827,7 +827,7 @@ static int ssi_blkcipher_process(
 		}
 
 	} else {
-		if (rc != 0) {
+		if (rc) {
 			cc_unmap_blkcipher_request(dev, req_ctx, ivsize, src,
 						   dst);
 		} else {
@@ -838,7 +838,7 @@ static int ssi_blkcipher_process(
 	}
 
 exit_process:
-	if (cts_restore_flag != 0)
+	if (cts_restore_flag)
 		ctx_p->cipher_mode = DRV_CIPHER_CBC_CTS;
 
 	if (rc != -EINPROGRESS) {
@@ -1338,7 +1338,7 @@ int ssi_ablkcipher_alloc(struct ssi_drvdata *drvdata)
 		rc = crypto_register_alg(&t_alg->crypto_alg);
 		dev_dbg(dev, "%s alg registration rc = %x\n",
 			t_alg->crypto_alg.cra_driver_name, rc);
-		if (unlikely(rc != 0)) {
+		if (unlikely(rc)) {
 			dev_err(dev, "%s alg registration failed\n",
 				t_alg->crypto_alg.cra_driver_name);
 			kfree(t_alg);
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index b9d1352..7b77f3f 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -111,7 +111,7 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 
 	drvdata->irq = irr;
 	/* Completion interrupt - most probable */
-	if (likely((irr & SSI_COMP_IRQ_MASK) != 0)) {
+	if (likely((irr & SSI_COMP_IRQ_MASK))) {
 		/* Mask AXI completion interrupt - will be unmasked in Deferred service handler */
 		cc_iowrite(drvdata, CC_REG(HOST_IMR), imr | SSI_COMP_IRQ_MASK);
 		irr &= ~SSI_COMP_IRQ_MASK;
@@ -119,7 +119,7 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 	}
 #ifdef CC_SUPPORT_FIPS
 	/* TEE FIPS interrupt */
-	if (likely((irr & SSI_GPR0_IRQ_MASK) != 0)) {
+	if (likely((irr & SSI_GPR0_IRQ_MASK))) {
 		/* Mask interrupt - will be unmasked in Deferred service handler */
 		cc_iowrite(drvdata, CC_REG(HOST_IMR), imr | SSI_GPR0_IRQ_MASK);
 		irr &= ~SSI_GPR0_IRQ_MASK;
@@ -127,7 +127,7 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 	}
 #endif
 	/* AXI error interrupt */
-	if (unlikely((irr & SSI_AXI_ERR_IRQ_MASK) != 0)) {
+	if (unlikely((irr & SSI_AXI_ERR_IRQ_MASK))) {
 		u32 axi_err;
 
 		/* Read the AXI error ID */
@@ -138,7 +138,7 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 		irr &= ~SSI_AXI_ERR_IRQ_MASK;
 	}
 
-	if (unlikely(irr != 0)) {
+	if (unlikely(irr)) {
 		dev_dbg(dev, "IRR includes unknown cause bits (0x%08X)\n",
 			irr);
 		/* Just warning */
@@ -292,26 +292,26 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		 DRV_MODULE_VERSION);
 
 	rc = init_cc_regs(new_drvdata, true);
-	if (unlikely(rc != 0)) {
+	if (unlikely(rc)) {
 		dev_err(dev, "init_cc_regs failed\n");
 		goto post_clk_err;
 	}
 
 #ifdef ENABLE_CC_SYSFS
 	rc = ssi_sysfs_init(&dev->kobj, new_drvdata);
-	if (unlikely(rc != 0)) {
+	if (unlikely(rc)) {
 		dev_err(dev, "init_stat_db failed\n");
 		goto post_regs_err;
 	}
 #endif
 
 	rc = ssi_fips_init(new_drvdata);
-	if (unlikely(rc != 0)) {
+	if (unlikely(rc)) {
 		dev_err(dev, "SSI_FIPS_INIT failed 0x%x\n", rc);
 		goto post_sysfs_err;
 	}
 	rc = ssi_sram_mgr_init(new_drvdata);
-	if (unlikely(rc != 0)) {
+	if (unlikely(rc)) {
 		dev_err(dev, "ssi_sram_mgr_init failed\n");
 		goto post_fips_init_err;
 	}
@@ -325,45 +325,45 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	}
 
 	rc = request_mgr_init(new_drvdata);
-	if (unlikely(rc != 0)) {
+	if (unlikely(rc)) {
 		dev_err(dev, "request_mgr_init failed\n");
 		goto post_sram_mgr_err;
 	}
 
 	rc = cc_buffer_mgr_init(new_drvdata);
-	if (unlikely(rc != 0)) {
+	if (unlikely(rc)) {
 		dev_err(dev, "buffer_mgr_init failed\n");
 		goto post_req_mgr_err;
 	}
 
 	rc = cc_pm_init(new_drvdata);
-	if (unlikely(rc != 0)) {
-		dev_err(dev, "cc_pm_init failed\n");
+	if (unlikely(rc)) {
+		dev_err(dev, "ssi_power_mgr_init failed\n");
 		goto post_buf_mgr_err;
 	}
 
 	rc = ssi_ivgen_init(new_drvdata);
-	if (unlikely(rc != 0)) {
+	if (unlikely(rc)) {
 		dev_err(dev, "ssi_ivgen_init failed\n");
 		goto post_power_mgr_err;
 	}
 
 	/* Allocate crypto algs */
 	rc = ssi_ablkcipher_alloc(new_drvdata);
-	if (unlikely(rc != 0)) {
+	if (unlikely(rc)) {
 		dev_err(dev, "ssi_ablkcipher_alloc failed\n");
 		goto post_ivgen_err;
 	}
 
 	/* hash must be allocated before aead since hash exports APIs */
 	rc = ssi_hash_alloc(new_drvdata);
-	if (unlikely(rc != 0)) {
+	if (unlikely(rc)) {
 		dev_err(dev, "ssi_hash_alloc failed\n");
 		goto post_cipher_err;
 	}
 
 	rc = ssi_aead_alloc(new_drvdata);
-	if (unlikely(rc != 0)) {
+	if (unlikely(rc)) {
 		dev_err(dev, "ssi_aead_alloc failed\n");
 		goto post_hash_err;
 	}
@@ -477,7 +477,7 @@ static int cc7x_probe(struct platform_device *plat_dev)
 
 	/* Map registers space */
 	rc = init_cc_resources(plat_dev);
-	if (rc != 0)
+	if (rc)
 		return rc;
 
 	dev_info(dev, "ARM ccree device initialized\n");
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index eb9cb56..5485372 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -234,7 +234,7 @@ static int ssi_hash_map_request(struct device *dev,
 		set_flow_mode(&desc, BYPASS);
 
 		rc = send_request(ctx->drvdata, &ssi_req, &desc, 1, 0);
-		if (unlikely(rc != 0)) {
+		if (unlikely(rc)) {
 			dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 			goto fail4;
 		}
@@ -276,12 +276,12 @@ static int ssi_hash_map_request(struct device *dev,
 	return 0;
 
 fail5:
-	if (state->digest_bytes_len_dma_addr != 0) {
+	if (state->digest_bytes_len_dma_addr) {
 		dma_unmap_single(dev, state->digest_bytes_len_dma_addr, HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
 		state->digest_bytes_len_dma_addr = 0;
 	}
 fail4:
-	if (state->digest_buff_dma_addr != 0) {
+	if (state->digest_buff_dma_addr) {
 		dma_unmap_single(dev, state->digest_buff_dma_addr, ctx->inter_digestsize, DMA_BIDIRECTIONAL);
 		state->digest_buff_dma_addr = 0;
 	}
@@ -308,21 +308,21 @@ static void ssi_hash_unmap_request(struct device *dev,
 				   struct ahash_req_ctx *state,
 				   struct ssi_hash_ctx *ctx)
 {
-	if (state->digest_buff_dma_addr != 0) {
+	if (state->digest_buff_dma_addr) {
 		dma_unmap_single(dev, state->digest_buff_dma_addr,
 				 ctx->inter_digestsize, DMA_BIDIRECTIONAL);
 		dev_dbg(dev, "Unmapped digest-buffer: digest_buff_dma_addr=%pad\n",
 			&state->digest_buff_dma_addr);
 		state->digest_buff_dma_addr = 0;
 	}
-	if (state->digest_bytes_len_dma_addr != 0) {
+	if (state->digest_bytes_len_dma_addr) {
 		dma_unmap_single(dev, state->digest_bytes_len_dma_addr,
 				 HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
 		dev_dbg(dev, "Unmapped digest-bytes-len buffer: digest_bytes_len_dma_addr=%pad\n",
 			&state->digest_bytes_len_dma_addr);
 		state->digest_bytes_len_dma_addr = 0;
 	}
-	if (state->opad_digest_dma_addr != 0) {
+	if (state->opad_digest_dma_addr) {
 		dma_unmap_single(dev, state->opad_digest_dma_addr,
 				 ctx->inter_digestsize, DMA_BIDIRECTIONAL);
 		dev_dbg(dev, "Unmapped opad-digest: opad_digest_dma_addr=%pad\n",
@@ -342,7 +342,7 @@ static void ssi_hash_unmap_result(struct device *dev,
 				  struct ahash_req_ctx *state,
 				  unsigned int digestsize, u8 *result)
 {
-	if (state->digest_result_dma_addr != 0) {
+	if (state->digest_result_dma_addr) {
 		dma_unmap_single(dev,
 				 state->digest_result_dma_addr,
 				 digestsize,
@@ -419,18 +419,18 @@ static int ssi_hash_digest(struct ahash_req_ctx *state,
 	dev_dbg(dev, "===== %s-digest (%d) ====\n", is_hmac ? "hmac" : "hash",
 		nbytes);
 
-	if (unlikely(ssi_hash_map_request(dev, state, ctx) != 0)) {
+	if (unlikely(ssi_hash_map_request(dev, state, ctx))) {
 		dev_err(dev, "map_ahash_source() failed\n");
 		return -ENOMEM;
 	}
 
-	if (unlikely(ssi_hash_map_result(dev, state, digestsize) != 0)) {
+	if (unlikely(ssi_hash_map_result(dev, state, digestsize))) {
 		dev_err(dev, "map_ahash_digest() failed\n");
 		return -ENOMEM;
 	}
 
 	if (unlikely(cc_map_hash_request_final(ctx->drvdata, state,
-					       src, nbytes, 1) != 0)) {
+					       src, nbytes, 1))) {
 		dev_err(dev, "map_ahash_request_final() failed\n");
 		return -ENOMEM;
 	}
@@ -465,7 +465,7 @@ static int ssi_hash_digest(struct ahash_req_ctx *state,
 			     NS_BIT);
 	} else {
 		set_din_const(&desc[idx], 0, HASH_LEN_SIZE);
-		if (likely(nbytes != 0))
+		if (likely(nbytes))
 			set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
 		else
 			set_cipher_do(&desc[idx], DO_PAD);
@@ -555,7 +555,7 @@ ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
 		}
 	} else {
 		rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 0);
-		if (rc != 0) {
+		if (rc) {
 			dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 			cc_unmap_hash_request(dev, state, src, true);
 		} else {
@@ -654,7 +654,7 @@ static int ssi_hash_update(struct ahash_req_ctx *state,
 		}
 	} else {
 		rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 0);
-		if (rc != 0) {
+		if (rc) {
 			dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 			cc_unmap_hash_request(dev, state, src, true);
 		} else {
@@ -683,11 +683,11 @@ static int ssi_hash_finup(struct ahash_req_ctx *state,
 		nbytes);
 
 	if (unlikely(cc_map_hash_request_final(ctx->drvdata, state, src,
-					       nbytes, 1) != 0)) {
+					       nbytes, 1))) {
 		dev_err(dev, "map_ahash_request_final() failed\n");
 		return -ENOMEM;
 	}
-	if (unlikely(ssi_hash_map_result(dev, state, digestsize) != 0)) {
+	if (unlikely(ssi_hash_map_result(dev, state, digestsize))) {
 		dev_err(dev, "map_ahash_digest() failed\n");
 		return -ENOMEM;
 	}
@@ -787,7 +787,7 @@ ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
 		}
 	} else {
 		rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 0);
-		if (rc != 0) {
+		if (rc) {
 			dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 			cc_unmap_hash_request(dev, state, src, true);
 			ssi_hash_unmap_result(dev, state, digestsize, result);
@@ -819,12 +819,12 @@ static int ssi_hash_final(struct ahash_req_ctx *state,
 		nbytes);
 
 	if (unlikely(cc_map_hash_request_final(ctx->drvdata, state, src,
-					       nbytes, 0) != 0)) {
+					       nbytes, 0))) {
 		dev_err(dev, "map_ahash_request_final() failed\n");
 		return -ENOMEM;
 	}
 
-	if (unlikely(ssi_hash_map_result(dev, state, digestsize) != 0)) {
+	if (unlikely(ssi_hash_map_result(dev, state, digestsize))) {
 		dev_err(dev, "map_ahash_digest() failed\n");
 		return -ENOMEM;
 	}
@@ -933,7 +933,7 @@ ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
 		}
 	} else {
 		rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 0);
-		if (rc != 0) {
+		if (rc) {
 			dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 			cc_unmap_hash_request(dev, state, src, true);
 			ssi_hash_unmap_result(dev, state, digestsize, result);
@@ -989,7 +989,7 @@ static int ssi_hash_setkey(void *hash,
 	ctx->key_params.key_dma_addr = 0;
 	ctx->is_hmac = true;
 
-	if (keylen != 0) {
+	if (keylen) {
 		ctx->key_params.key_dma_addr = dma_map_single(
 						dev, (void *)key,
 						keylen, DMA_TO_DEVICE);
@@ -1056,7 +1056,7 @@ static int ssi_hash_setkey(void *hash,
 				      keylen, NS_BIT, 0);
 			idx++;
 
-			if ((blocksize - keylen) != 0) {
+			if ((blocksize - keylen)) {
 				hw_desc_init(&desc[idx]);
 				set_din_const(&desc[idx], 0,
 					      (blocksize - keylen));
@@ -1078,7 +1078,7 @@ static int ssi_hash_setkey(void *hash,
 	}
 
 	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 0);
-	if (unlikely(rc != 0)) {
+	if (unlikely(rc)) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		goto out;
 	}
@@ -1218,7 +1218,7 @@ static int ssi_xcbc_setkey(struct crypto_ahash *ahash,
 
 	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 0);
 
-	if (rc != 0)
+	if (rc)
 		crypto_ahash_set_flags(ahash, CRYPTO_TFM_RES_BAD_KEY_LEN);
 
 	dma_unmap_single(dev, ctx->key_params.key_dma_addr,
@@ -1273,14 +1273,14 @@ static void ssi_hash_free_ctx(struct ssi_hash_ctx *ctx)
 {
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 
-	if (ctx->digest_buff_dma_addr != 0) {
+	if (ctx->digest_buff_dma_addr) {
 		dma_unmap_single(dev, ctx->digest_buff_dma_addr,
 				 sizeof(ctx->digest_buff), DMA_BIDIRECTIONAL);
 		dev_dbg(dev, "Unmapped digest-buffer: digest_buff_dma_addr=%pad\n",
 			&ctx->digest_buff_dma_addr);
 		ctx->digest_buff_dma_addr = 0;
 	}
-	if (ctx->opad_tmp_keys_dma_addr != 0) {
+	if (ctx->opad_tmp_keys_dma_addr) {
 		dma_unmap_single(dev, ctx->opad_tmp_keys_dma_addr,
 				 sizeof(ctx->opad_tmp_keys_buff),
 				 DMA_BIDIRECTIONAL);
@@ -1446,12 +1446,12 @@ static int ssi_mac_final(struct ahash_request *req)
 	dev_dbg(dev, "===== final  xcbc reminder (%d) ====\n", rem_cnt);
 
 	if (unlikely(cc_map_hash_request_final(ctx->drvdata, state, req->src,
-					       req->nbytes, 0) != 0)) {
+					       req->nbytes, 0))) {
 		dev_err(dev, "map_ahash_request_final() failed\n");
 		return -ENOMEM;
 	}
 
-	if (unlikely(ssi_hash_map_result(dev, state, digestsize) != 0)) {
+	if (unlikely(ssi_hash_map_result(dev, state, digestsize))) {
 		dev_err(dev, "map_ahash_digest() failed\n");
 		return -ENOMEM;
 	}
@@ -1550,11 +1550,11 @@ static int ssi_mac_finup(struct ahash_request *req)
 	}
 
 	if (unlikely(cc_map_hash_request_final(ctx->drvdata, state, req->src,
-					       req->nbytes, 1) != 0)) {
+					       req->nbytes, 1))) {
 		dev_err(dev, "map_ahash_request_final() failed\n");
 		return -ENOMEM;
 	}
-	if (unlikely(ssi_hash_map_result(dev, state, digestsize) != 0)) {
+	if (unlikely(ssi_hash_map_result(dev, state, digestsize))) {
 		dev_err(dev, "map_ahash_digest() failed\n");
 		return -ENOMEM;
 	}
@@ -1617,17 +1617,17 @@ static int ssi_mac_digest(struct ahash_request *req)
 
 	dev_dbg(dev, "===== -digest mac (%d) ====\n",  req->nbytes);
 
-	if (unlikely(ssi_hash_map_request(dev, state, ctx) != 0)) {
+	if (unlikely(ssi_hash_map_request(dev, state, ctx))) {
 		dev_err(dev, "map_ahash_source() failed\n");
 		return -ENOMEM;
 	}
-	if (unlikely(ssi_hash_map_result(dev, state, digestsize) != 0)) {
+	if (unlikely(ssi_hash_map_result(dev, state, digestsize))) {
 		dev_err(dev, "map_ahash_digest() failed\n");
 		return -ENOMEM;
 	}
 
 	if (unlikely(cc_map_hash_request_final(ctx->drvdata, state, req->src,
-					       req->nbytes, 1) != 0)) {
+					       req->nbytes, 1))) {
 		dev_err(dev, "map_ahash_request_final() failed\n");
 		return -ENOMEM;
 	}
@@ -2117,7 +2117,7 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 			 ARRAY_SIZE(digest_len_init), larval_seq,
 			 &larval_seq_len);
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
-	if (unlikely(rc != 0))
+	if (unlikely(rc))
 		goto init_digest_const_err;
 
 	sram_buff_ofs += sizeof(digest_len_init);
@@ -2129,7 +2129,7 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 			 ARRAY_SIZE(digest_len_sha512_init),
 			 larval_seq, &larval_seq_len);
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
-	if (unlikely(rc != 0))
+	if (unlikely(rc))
 		goto init_digest_const_err;
 
 	sram_buff_ofs += sizeof(digest_len_sha512_init);
@@ -2144,7 +2144,7 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 			 ARRAY_SIZE(md5_init), larval_seq,
 			 &larval_seq_len);
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
-	if (unlikely(rc != 0))
+	if (unlikely(rc))
 		goto init_digest_const_err;
 	sram_buff_ofs += sizeof(md5_init);
 	larval_seq_len = 0;
@@ -2153,7 +2153,7 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 			 ARRAY_SIZE(sha1_init), larval_seq,
 			 &larval_seq_len);
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
-	if (unlikely(rc != 0))
+	if (unlikely(rc))
 		goto init_digest_const_err;
 	sram_buff_ofs += sizeof(sha1_init);
 	larval_seq_len = 0;
@@ -2162,7 +2162,7 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 			 ARRAY_SIZE(sha224_init), larval_seq,
 			 &larval_seq_len);
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
-	if (unlikely(rc != 0))
+	if (unlikely(rc))
 		goto init_digest_const_err;
 	sram_buff_ofs += sizeof(sha224_init);
 	larval_seq_len = 0;
@@ -2171,7 +2171,7 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 			 ARRAY_SIZE(sha256_init), larval_seq,
 			 &larval_seq_len);
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
-	if (unlikely(rc != 0))
+	if (unlikely(rc))
 		goto init_digest_const_err;
 	sram_buff_ofs += sizeof(sha256_init);
 	larval_seq_len = 0;
@@ -2190,7 +2190,7 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 		sram_buff_ofs += sizeof(u32);
 	}
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
-	if (unlikely(rc != 0)) {
+	if (unlikely(rc)) {
 		dev_err(dev, "send_request() failed (rc = %d)\n", rc);
 		goto init_digest_const_err;
 	}
@@ -2208,7 +2208,7 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 		sram_buff_ofs += sizeof(u32);
 	}
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
-	if (unlikely(rc != 0)) {
+	if (unlikely(rc)) {
 		dev_err(dev, "send_request() failed (rc = %d)\n", rc);
 		goto init_digest_const_err;
 	}
@@ -2257,7 +2257,7 @@ int ssi_hash_alloc(struct ssi_drvdata *drvdata)
 
 	/*must be set before the alg registration as it is being used there*/
 	rc = ssi_hash_init_sram_digest_consts(drvdata);
-	if (unlikely(rc != 0)) {
+	if (unlikely(rc)) {
 		dev_err(dev, "Init digest CONST failed (rc=%d)\n", rc);
 		goto fail;
 	}
diff --git a/drivers/staging/ccree/ssi_ivgen.c b/drivers/staging/ccree/ssi_ivgen.c
index 0d85bce..a33fd76 100644
--- a/drivers/staging/ccree/ssi_ivgen.c
+++ b/drivers/staging/ccree/ssi_ivgen.c
@@ -143,7 +143,7 @@ int ssi_ivgen_init_sram_pool(struct ssi_drvdata *drvdata)
 
 	/* Generate initial pool */
 	rc = ssi_ivgen_generate_pool(ivgen_ctx, iv_seq, &iv_seq_len);
-	if (unlikely(rc != 0))
+	if (unlikely(rc))
 		return rc;
 
 	/* Fire-and-forget */
diff --git a/drivers/staging/ccree/ssi_pm.c b/drivers/staging/ccree/ssi_pm.c
index d60143c..5517d2b 100644
--- a/drivers/staging/ccree/ssi_pm.c
+++ b/drivers/staging/ccree/ssi_pm.c
@@ -43,7 +43,7 @@ int cc_pm_suspend(struct device *dev)
 	dev_dbg(dev, "set HOST_POWER_DOWN_EN\n");
 	cc_iowrite(drvdata, CC_REG(HOST_POWER_DOWN_EN), POWER_DOWN_ENABLE);
 	rc = cc_suspend_req_queue(drvdata);
-	if (rc != 0) {
+	if (rc) {
 		dev_err(dev, "cc_suspend_req_queue (%x)\n",
 			rc);
 		return rc;
@@ -69,13 +69,13 @@ int cc_pm_resume(struct device *dev)
 	}
 
 	rc = init_cc_regs(drvdata, false);
-	if (rc != 0) {
+	if (rc) {
 		dev_err(dev, "init_cc_regs (%x)\n", rc);
 		return rc;
 	}
 
 	rc = cc_resume_req_queue(drvdata);
-	if (rc != 0) {
+	if (rc) {
 		dev_err(dev, "cc_resume_req_queue (%x)\n", rc);
 		return rc;
 	}
@@ -131,7 +131,7 @@ int cc_pm_init(struct ssi_drvdata *drvdata)
 	pm_runtime_use_autosuspend(dev);
 	/* activate the PM module */
 	rc = pm_runtime_set_active(dev);
-	if (rc != 0)
+	if (rc)
 		return rc;
 	/* enable the PM module*/
 	pm_runtime_enable(dev);
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index f5d51c1..8fa3fc1 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -73,7 +73,7 @@ void request_mgr_fini(struct ssi_drvdata *drvdata)
 	if (!req_mgr_h)
 		return; /* Not allocated */
 
-	if (req_mgr_h->dummy_comp_buff_dma != 0) {
+	if (req_mgr_h->dummy_comp_buff_dma) {
 		dma_free_coherent(dev, sizeof(u32), req_mgr_h->dummy_comp_buff,
 				  req_mgr_h->dummy_comp_buff_dma);
 	}
@@ -275,8 +275,8 @@ int send_request(
 
 #if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
 	rc = cc_pm_get(dev);
-	if (rc != 0) {
-		dev_err(dev, "cc_pm_get returned %x\n", rc);
+	if (rc) {
+		dev_err(dev, "ssi_power_mgr_runtime_get returned %x\n", rc);
 		return rc;
 	}
 #endif
@@ -333,7 +333,7 @@ int send_request(
 				     ssi_req->ivgen_dma_addr_len,
 				     ssi_req->ivgen_size, iv_seq, &iv_seq_len);
 
-		if (unlikely(rc != 0)) {
+		if (unlikely(rc)) {
 			dev_err(dev, "Failed to generate IV (rc=%d)\n", rc);
 			spin_unlock_bh(&req_mgr_h->hw_lock);
 #if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
@@ -412,7 +412,7 @@ int send_request_init(
 	/* Wait for space in HW and SW FIFO. Poll for as much as FIFO_TIMEOUT. */
 	rc = request_mgr_queues_status_check(drvdata, req_mgr_h,
 					     total_seq_len);
-	if (unlikely(rc != 0))
+	if (unlikely(rc))
 		return rc;
 
 	set_queue_last_ind(&desc[(len - 1)]);
@@ -500,7 +500,7 @@ static void proc_completions(struct ssi_drvdata *drvdata)
 			request_mgr_handle->axi_completed);
 #if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
 		rc = cc_pm_put_suspend(dev);
-		if (rc != 0)
+		if (rc)
 			dev_err(dev, "Failed to set runtime suspension %d\n",
 				rc);
 #endif
diff --git a/drivers/staging/ccree/ssi_sram_mgr.c b/drivers/staging/ccree/ssi_sram_mgr.c
index 51513248..2263433 100644
--- a/drivers/staging/ccree/ssi_sram_mgr.c
+++ b/drivers/staging/ccree/ssi_sram_mgr.c
@@ -75,7 +75,7 @@ ssi_sram_addr_t cc_sram_alloc(struct ssi_drvdata *drvdata, u32 size)
 	struct device *dev = drvdata_to_dev(drvdata);
 	ssi_sram_addr_t p;
 
-	if (unlikely((size & 0x3) != 0)) {
+	if (unlikely((size & 0x3))) {
 		dev_err(dev, "Requested buffer size (%u) is not multiple of 4",
 			size);
 		return NULL_SRAM_ADDR;
-- 
2.7.4
