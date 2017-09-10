From: Joe Perches <joe@perches.com>
Subject: [PATCH] staging: ccree: Add missing newlines
Date: Sat,  9 Sep 2017 23:18:02 -0700
Message-ID: <250d3f881f7a02ff4a0a7650446499be48b52691.1505024246.git.joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Logging without newlines are still prone to interleaving.
Add newlines where necessary.

Miscellanea:

o Coalesce formats
o Realign arguments
o Fix a couple misindented lines with the above logging changes

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/ccree/ssi_aead.c        |  17 ++--
 drivers/staging/ccree/ssi_buffer_mgr.c  | 135 ++++++++++++++------------------
 drivers/staging/ccree/ssi_cipher.c      |  40 +++++-----
 drivers/staging/ccree/ssi_driver.c      |   6 +-
 drivers/staging/ccree/ssi_hash.c        |  47 +++++------
 drivers/staging/ccree/ssi_ivgen.c       |   8 +-
 drivers/staging/ccree/ssi_request_mgr.c |  15 ++--
 drivers/staging/ccree/ssi_sram_mgr.c    |   2 +-
 8 files changed, 122 insertions(+), 148 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 5abe6b24ff8c..61ecfe59195a 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -240,9 +240,8 @@ static void ssi_aead_complete(struct device *dev, void *ssi_req, void __iomem *c
 	if (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT) {
 		if (memcmp(areq_ctx->mac_buf, areq_ctx->icv_virt_addr,
 			   ctx->authsize) != 0) {
-			SSI_LOG_DEBUG("Payload authentication failure, "
-				"(auth-size=%d, cipher=%d).\n",
-				ctx->authsize, ctx->cipher_mode);
+			SSI_LOG_DEBUG("Payload authentication failure, (auth-size=%d, cipher=%d)\n",
+				      ctx->authsize, ctx->cipher_mode);
 			/* In case of payload authentication failure, MUST NOT
 			 * revealed the decrypted message --> zero its memory.
 			 */
@@ -455,8 +454,8 @@ ssi_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key, unsigned int keyl
 	if (likely(keylen != 0)) {
 		key_dma_addr = dma_map_single(dev, (void *)key, keylen, DMA_TO_DEVICE);
 		if (unlikely(dma_mapping_error(dev, key_dma_addr))) {
-			SSI_LOG_ERR("Mapping key va=0x%p len=%u for"
-				   " DMA failed\n", key, keylen);
+			SSI_LOG_ERR("Mapping key va=0x%p len=%u for DMA failed\n",
+				    key, keylen);
 			return -ENOMEM;
 		}
 		if (keylen > blocksize) {
@@ -1861,7 +1860,7 @@ static inline void ssi_aead_dump_gcm(
 		return;
 
 	if (title) {
-		SSI_LOG_DEBUG("----------------------------------------------------------------------------------");
+		SSI_LOG_DEBUG("----------------------------------------------------------------------------------\n");
 		SSI_LOG_DEBUG("%s\n", title);
 	}
 
@@ -2017,7 +2016,8 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 	if (ctx->cipher_mode == DRV_CIPHER_CCM) {
 		rc = config_ccm_adata(req);
 		if (unlikely(rc != 0)) {
-			SSI_LOG_ERR("config_ccm_adata() returned with a failure %d!", rc);
+			SSI_LOG_ERR("config_ccm_adata() returned with a failure %d!\n",
+				    rc);
 			goto exit;
 		}
 	} else {
@@ -2031,7 +2031,8 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 	if (ctx->cipher_mode == DRV_CIPHER_GCTR) {
 		rc = config_gcm_context(req);
 		if (unlikely(rc != 0)) {
-			SSI_LOG_ERR("config_gcm_context() returned with a failure %d!", rc);
+			SSI_LOG_ERR("config_gcm_context() returned with a failure %d!\n",
+				    rc);
 			goto exit;
 		}
 	}
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 63936091d524..d41ec19856bf 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -82,8 +82,8 @@ static unsigned int ssi_buffer_mgr_get_sgl_nents(
 
 	while (nbytes != 0) {
 		if (sg_is_chain(sg_list)) {
-			SSI_LOG_ERR("Unexpected chained entry "
-				   "in sg (entry =0x%X)\n", nents);
+			SSI_LOG_ERR("Unexpected chained entry in sg (entry =0x%X)\n",
+				    nents);
 			BUG();
 		}
 		if (sg_list->length != 0) {
@@ -259,11 +259,10 @@ static int ssi_buffer_mgr_generate_mlli(
 	/* Set MLLI size for the bypass operation */
 	mlli_params->mlli_len = (total_nents * LLI_ENTRY_BYTE_SIZE);
 
-	SSI_LOG_DEBUG("MLLI params: "
-		     "virt_addr=%pK dma_addr=%pad mlli_len=0x%X\n",
-		   mlli_params->mlli_virt_addr,
-		   mlli_params->mlli_dma_addr,
-		   mlli_params->mlli_len);
+	SSI_LOG_DEBUG("MLLI params: virt_addr=%pK dma_addr=%pad mlli_len=0x%X\n",
+		      mlli_params->mlli_virt_addr,
+		      mlli_params->mlli_dma_addr,
+		      mlli_params->mlli_len);
 
 build_mlli_exit:
 	return rc;
@@ -276,9 +275,8 @@ static inline void ssi_buffer_mgr_add_buffer_entry(
 {
 	unsigned int index = sgl_data->num_of_buffers;
 
-	SSI_LOG_DEBUG("index=%u single_buff=%pad "
-		     "buffer_len=0x%08X is_last=%d\n",
-		     index, buffer_dma, buffer_len, is_last_entry);
+	SSI_LOG_DEBUG("index=%u single_buff=%pad buffer_len=0x%08X is_last=%d\n",
+		      index, buffer_dma, buffer_len, is_last_entry);
 	sgl_data->nents[index] = 1;
 	sgl_data->entry[index].buffer_dma = buffer_dma;
 	sgl_data->offset[index] = 0;
@@ -359,13 +357,11 @@ static int ssi_buffer_mgr_map_scatterlist(
 			SSI_LOG_ERR("dma_map_sg() single buffer failed\n");
 			return -ENOMEM;
 		}
-		SSI_LOG_DEBUG("Mapped sg: dma_address=%pad "
-			     "page=%p addr=%pK offset=%u "
-			     "length=%u\n",
-			     sg_dma_address(sg),
-			     sg_page(sg),
-			     sg_virt(sg),
-			     sg->offset, sg->length);
+		SSI_LOG_DEBUG("Mapped sg: dma_address=%pad page=%p addr=%pK offset=%u length=%u\n",
+			      sg_dma_address(sg),
+			      sg_page(sg),
+			      sg_virt(sg),
+			      sg->offset, sg->length);
 		*lbytes = nbytes;
 		*nents = 1;
 		*mapped_nents = 1;
@@ -419,18 +415,15 @@ ssi_aead_handle_config_buf(struct device *dev,
 	sg_init_one(&areq_ctx->ccm_adata_sg, config_data, AES_BLOCK_SIZE + areq_ctx->ccm_hdr_size);
 	if (unlikely(dma_map_sg(dev, &areq_ctx->ccm_adata_sg, 1,
 				DMA_TO_DEVICE) != 1)) {
-			SSI_LOG_ERR("dma_map_sg() "
-			   "config buffer failed\n");
-			return -ENOMEM;
+		SSI_LOG_ERR("dma_map_sg() config buffer failed\n");
+		return -ENOMEM;
 	}
-	SSI_LOG_DEBUG("Mapped curr_buff: dma_address=%pad "
-		     "page=%p addr=%pK "
-		     "offset=%u length=%u\n",
-		     sg_dma_address(&areq_ctx->ccm_adata_sg),
-		     sg_page(&areq_ctx->ccm_adata_sg),
-		     sg_virt(&areq_ctx->ccm_adata_sg),
-		     areq_ctx->ccm_adata_sg.offset,
-		     areq_ctx->ccm_adata_sg.length);
+	SSI_LOG_DEBUG("Mapped curr_buff: dma_address=%pad page=%p addr=%pK offset=%u length=%u\n",
+		      sg_dma_address(&areq_ctx->ccm_adata_sg),
+		      sg_page(&areq_ctx->ccm_adata_sg),
+		      sg_virt(&areq_ctx->ccm_adata_sg),
+		      areq_ctx->ccm_adata_sg.offset,
+		      areq_ctx->ccm_adata_sg.length);
 	/* prepare for case of MLLI */
 	if (assoclen > 0) {
 		ssi_buffer_mgr_add_scatterlist_entry(sg_data, 1,
@@ -452,18 +445,15 @@ static inline int ssi_ahash_handle_curr_buf(struct device *dev,
 	sg_init_one(areq_ctx->buff_sg, curr_buff, curr_buff_cnt);
 	if (unlikely(dma_map_sg(dev, areq_ctx->buff_sg, 1,
 				DMA_TO_DEVICE) != 1)) {
-			SSI_LOG_ERR("dma_map_sg() "
-			   "src buffer failed\n");
-			return -ENOMEM;
+		SSI_LOG_ERR("dma_map_sg() src buffer failed\n");
+		return -ENOMEM;
 	}
-	SSI_LOG_DEBUG("Mapped curr_buff: dma_address=%pad "
-		     "page=%p addr=%pK "
-		     "offset=%u length=%u\n",
-		     sg_dma_address(areq_ctx->buff_sg),
-		     sg_page(areq_ctx->buff_sg),
-		     sg_virt(areq_ctx->buff_sg),
-		     areq_ctx->buff_sg->offset,
-		     areq_ctx->buff_sg->length);
+	SSI_LOG_DEBUG("Mapped curr_buff: dma_address=%pad page=%p addr=%pK offset=%u length=%u\n",
+		      sg_dma_address(areq_ctx->buff_sg),
+		      sg_page(areq_ctx->buff_sg),
+		      sg_virt(areq_ctx->buff_sg),
+		      areq_ctx->buff_sg->offset,
+		      areq_ctx->buff_sg->length);
 	areq_ctx->data_dma_buf_type = SSI_DMA_BUF_DLLI;
 	areq_ctx->curr_sg = areq_ctx->buff_sg;
 	areq_ctx->in_nents = 0;
@@ -539,8 +529,8 @@ int ssi_buffer_mgr_map_blkcipher_request(
 				       DMA_TO_DEVICE);
 		if (unlikely(dma_mapping_error(dev,
 					       req_ctx->gen_ctx.iv_dma_addr))) {
-			SSI_LOG_ERR("Mapping iv %u B at va=%pK "
-				   "for DMA failed\n", ivsize, info);
+			SSI_LOG_ERR("Mapping iv %u B at va=%pK for DMA failed\n",
+				    ivsize, info);
 			return -ENOMEM;
 		}
 		SSI_LOG_DEBUG("Mapped iv %u B at va=%pK to dma=%pad\n",
@@ -1340,9 +1330,9 @@ int ssi_buffer_mgr_map_aead_request(
 							    DMA_TO_DEVICE);
 
 		if (unlikely(dma_mapping_error(dev, areq_ctx->ccm_iv0_dma_addr))) {
-			SSI_LOG_ERR("Mapping mac_buf %u B at va=%pK "
-			"for DMA failed\n", AES_BLOCK_SIZE,
-			(areq_ctx->ccm_config + CCM_CTR_COUNT_0_OFFSET));
+			SSI_LOG_ERR("Mapping mac_buf %u B at va=%pK for DMA failed\n",
+				    AES_BLOCK_SIZE,
+				    areq_ctx->ccm_config + CCM_CTR_COUNT_0_OFFSET);
 			areq_ctx->ccm_iv0_dma_addr = 0;
 			rc = -ENOMEM;
 			goto aead_map_failure;
@@ -1385,9 +1375,9 @@ int ssi_buffer_mgr_map_aead_request(
 								DMA_TO_DEVICE);
 
 		if (unlikely(dma_mapping_error(dev, areq_ctx->gcm_iv_inc1_dma_addr))) {
-			SSI_LOG_ERR("Mapping gcm_iv_inc1 %u B at va=%pK "
-			"for DMA failed\n", AES_BLOCK_SIZE,
-			(areq_ctx->gcm_iv_inc1));
+			SSI_LOG_ERR("Mapping gcm_iv_inc1 %u B at va=%pK for DMA failed\n",
+				    AES_BLOCK_SIZE,
+				    areq_ctx->gcm_iv_inc1);
 			areq_ctx->gcm_iv_inc1_dma_addr = 0;
 			rc = -ENOMEM;
 			goto aead_map_failure;
@@ -1399,9 +1389,9 @@ int ssi_buffer_mgr_map_aead_request(
 								DMA_TO_DEVICE);
 
 		if (unlikely(dma_mapping_error(dev, areq_ctx->gcm_iv_inc2_dma_addr))) {
-			SSI_LOG_ERR("Mapping gcm_iv_inc2 %u B at va=%pK "
-			"for DMA failed\n", AES_BLOCK_SIZE,
-			(areq_ctx->gcm_iv_inc2));
+			SSI_LOG_ERR("Mapping gcm_iv_inc2 %u B at va=%pK for DMA failed\n",
+				    AES_BLOCK_SIZE,
+				    areq_ctx->gcm_iv_inc2);
 			areq_ctx->gcm_iv_inc2_dma_addr = 0;
 			rc = -ENOMEM;
 			goto aead_map_failure;
@@ -1507,11 +1497,9 @@ int ssi_buffer_mgr_map_hash_request_final(
 	u32 dummy = 0;
 	u32 mapped_nents = 0;
 
-	SSI_LOG_DEBUG(" final params : curr_buff=%pK "
-		     "curr_buff_cnt=0x%X nbytes = 0x%X "
-		     "src=%pK curr_index=%u\n",
-		     curr_buff, *curr_buff_cnt, nbytes,
-		     src, areq_ctx->buff_index);
+	SSI_LOG_DEBUG(" final params : curr_buff=%pK curr_buff_cnt=0x%X nbytes = 0x%X src=%pK curr_index=%u\n",
+		      curr_buff, *curr_buff_cnt, nbytes,
+		      src, areq_ctx->buff_index);
 	/* Init the type of the dma buffer */
 	areq_ctx->data_dma_buf_type = SSI_DMA_BUF_NULL;
 	mlli_params->curr_pool = NULL;
@@ -1604,11 +1592,9 @@ int ssi_buffer_mgr_map_hash_request_update(
 	u32 dummy = 0;
 	u32 mapped_nents = 0;
 
-	SSI_LOG_DEBUG(" update params : curr_buff=%pK "
-		     "curr_buff_cnt=0x%X nbytes=0x%X "
-		     "src=%pK curr_index=%u\n",
-		     curr_buff, *curr_buff_cnt, nbytes,
-		     src, areq_ctx->buff_index);
+	SSI_LOG_DEBUG(" update params : curr_buff=%pK curr_buff_cnt=0x%X nbytes=0x%X src=%pK curr_index=%u\n",
+		      curr_buff, *curr_buff_cnt, nbytes,
+		      src, areq_ctx->buff_index);
 	/* Init the type of the dma buffer */
 	areq_ctx->data_dma_buf_type = SSI_DMA_BUF_NULL;
 	mlli_params->curr_pool = NULL;
@@ -1617,10 +1603,9 @@ int ssi_buffer_mgr_map_hash_request_update(
 	areq_ctx->in_nents = 0;
 
 	if (unlikely(total_in_len < block_size)) {
-		SSI_LOG_DEBUG(" less than one block: curr_buff=%pK "
-			     "*curr_buff_cnt=0x%X copy_to=%pK\n",
-			curr_buff, *curr_buff_cnt,
-			&curr_buff[*curr_buff_cnt]);
+		SSI_LOG_DEBUG(" less than one block: curr_buff=%pK *curr_buff_cnt=0x%X copy_to=%pK\n",
+			      curr_buff, *curr_buff_cnt,
+			      &curr_buff[*curr_buff_cnt]);
 		areq_ctx->in_nents =
 			ssi_buffer_mgr_get_sgl_nents(src,
 						     nbytes,
@@ -1636,16 +1621,15 @@ int ssi_buffer_mgr_map_hash_request_update(
 	/* update data len */
 	update_data_len = total_in_len - *next_buff_cnt;
 
-	SSI_LOG_DEBUG(" temp length : *next_buff_cnt=0x%X "
-		     "update_data_len=0x%X\n",
-		*next_buff_cnt, update_data_len);
+	SSI_LOG_DEBUG(" temp length : *next_buff_cnt=0x%X update_data_len=0x%X\n",
+		      *next_buff_cnt, update_data_len);
 
 	/* Copy the new residue to next buffer */
 	if (*next_buff_cnt != 0) {
-		SSI_LOG_DEBUG(" handle residue: next buff %pK skip data %u"
-			     " residue %u\n", next_buff,
-			     (update_data_len - *curr_buff_cnt),
-			     *next_buff_cnt);
+		SSI_LOG_DEBUG(" handle residue: next buff %pK skip data %u residue %u\n",
+			      next_buff,
+			      update_data_len - *curr_buff_cnt,
+			      *next_buff_cnt);
 		ssi_buffer_mgr_copy_scatterlist_portion(next_buff, src,
 							(update_data_len - *curr_buff_cnt),
 							nbytes, SSI_SG_TO_BUF);
@@ -1743,11 +1727,10 @@ void ssi_buffer_mgr_unmap_hash_request(
 	}
 
 	if (*prev_len != 0) {
-		SSI_LOG_DEBUG("Unmapped buffer: areq_ctx->buff_sg=%pK"
-			     " dma=%pad len 0x%X\n",
-				sg_virt(areq_ctx->buff_sg),
-				sg_dma_address(areq_ctx->buff_sg),
-				sg_dma_len(areq_ctx->buff_sg));
+		SSI_LOG_DEBUG("Unmapped buffer: areq_ctx->buff_sg=%pK dma=%pad len 0x%X\n",
+			      sg_virt(areq_ctx->buff_sg),
+			      sg_dma_address(areq_ctx->buff_sg),
+			      sg_dma_len(areq_ctx->buff_sg));
 		dma_unmap_sg(dev, areq_ctx->buff_sg, 1, DMA_TO_DEVICE);
 		if (!do_revert) {
 			/* clean the previous data length for update operation */
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 8d31a93fd8b7..235a6132ba79 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -306,7 +306,7 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 		      ctx_p, crypto_tfm_alg_name(tfm), keylen);
 	dump_byte_array("key", (u8 *)key, keylen);
 
-	SSI_LOG_DEBUG("after FIPS check");
+	SSI_LOG_DEBUG("after FIPS check\n");
 
 	/* STAT_PHASE_0: Init and sanity checks */
 
@@ -352,7 +352,7 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 		}
 
 		ctx_p->keylen = keylen;
-		SSI_LOG_DEBUG("ssi_is_hw_key ret 0");
+		SSI_LOG_DEBUG("ssi_is_hw_key ret 0\n");
 
 		return 0;
 	}
@@ -362,19 +362,19 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 		if (unlikely(!des_ekey(tmp, key)) &&
 		    (crypto_tfm_get_flags(tfm) & CRYPTO_TFM_REQ_WEAK_KEY)) {
 			tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
-			SSI_LOG_DEBUG("weak DES key");
+			SSI_LOG_DEBUG("weak DES key\n");
 			return -EINVAL;
 		}
 	}
 	if ((ctx_p->cipher_mode == DRV_CIPHER_XTS) &&
 	    xts_check_key(tfm, key, keylen) != 0) {
-		SSI_LOG_DEBUG("weak XTS key");
+		SSI_LOG_DEBUG("weak XTS key\n");
 		return -EINVAL;
 	}
 	if ((ctx_p->flow_mode == S_DIN_to_DES) &&
 	    (keylen == DES3_EDE_KEY_SIZE) &&
 	    ssi_verify_3des_keys(key, keylen) != 0) {
-		SSI_LOG_DEBUG("weak 3DES key");
+		SSI_LOG_DEBUG("weak 3DES key\n");
 		return -EINVAL;
 	}
 
@@ -389,7 +389,7 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 		if (ctx_p->key_round_number < CC_MULTI2_MIN_NUM_ROUNDS ||
 		    ctx_p->key_round_number > CC_MULTI2_MAX_NUM_ROUNDS) {
 			crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-			SSI_LOG_DEBUG("SSI_CC_HAS_MULTI2 einval");
+			SSI_LOG_DEBUG("SSI_CC_HAS_MULTI2 einval\n");
 			return -EINVAL;
 #endif /*SSI_CC_HAS_MULTI2*/
 	} else {
@@ -416,7 +416,7 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 				   max_key_buf_size, DMA_TO_DEVICE);
 	ctx_p->keylen = keylen;
 
-	 SSI_LOG_DEBUG("return safely");
+	 SSI_LOG_DEBUG("return safely\n");
 	return 0;
 }
 
@@ -637,11 +637,10 @@ ssi_blkcipher_create_data_desc(
 		(*seq_size)++;
 	} else {
 		/* bypass */
-		SSI_LOG_DEBUG(" bypass params addr %pad "
-			     "length 0x%X addr 0x%08X\n",
-			req_ctx->mlli_params.mlli_dma_addr,
-			req_ctx->mlli_params.mlli_len,
-			(unsigned int)ctx_p->drvdata->mlli_sram_addr);
+		SSI_LOG_DEBUG(" bypass params addr %pad length 0x%X addr 0x%08X\n",
+			      req_ctx->mlli_params.mlli_dma_addr,
+			      req_ctx->mlli_params.mlli_len,
+			      (unsigned int)ctx_p->drvdata->mlli_sram_addr);
 		hw_desc_init(&desc[*seq_size]);
 		set_din_type(&desc[*seq_size], DMA_DLLI,
 			     req_ctx->mlli_params.mlli_dma_addr,
@@ -657,21 +656,18 @@ ssi_blkcipher_create_data_desc(
 			     ctx_p->drvdata->mlli_sram_addr,
 			     req_ctx->in_mlli_nents, NS_BIT);
 		if (req_ctx->out_nents == 0) {
-			SSI_LOG_DEBUG(" din/dout params addr 0x%08X "
-				     "addr 0x%08X\n",
-			(unsigned int)ctx_p->drvdata->mlli_sram_addr,
-			(unsigned int)ctx_p->drvdata->mlli_sram_addr);
+			SSI_LOG_DEBUG(" din/dout params addr 0x%08X addr 0x%08X\n",
+				      (unsigned int)ctx_p->drvdata->mlli_sram_addr,
+				      (unsigned int)ctx_p->drvdata->mlli_sram_addr);
 			set_dout_mlli(&desc[*seq_size],
 				      ctx_p->drvdata->mlli_sram_addr,
 				      req_ctx->in_mlli_nents, NS_BIT,
 				      (!areq ? 0 : 1));
 		} else {
-			SSI_LOG_DEBUG(" din/dout params "
-				     "addr 0x%08X addr 0x%08X\n",
-				(unsigned int)ctx_p->drvdata->mlli_sram_addr,
-				(unsigned int)ctx_p->drvdata->mlli_sram_addr +
-				(u32)LLI_ENTRY_BYTE_SIZE *
-							req_ctx->in_nents);
+			SSI_LOG_DEBUG(" din/dout params addr 0x%08X addr 0x%08X\n",
+				      (unsigned int)ctx_p->drvdata->mlli_sram_addr,
+				      (unsigned int)ctx_p->drvdata->mlli_sram_addr +
+				      (u32)LLI_ENTRY_BYTE_SIZE * req_ctx->in_nents);
 			set_dout_mlli(&desc[*seq_size],
 				      (ctx_p->drvdata->mlli_sram_addr +
 				       (LLI_ENTRY_BYTE_SIZE *
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 9c6f1200c130..cd830c344412 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -231,7 +231,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	int rc = 0;
 
 	if (unlikely(!new_drvdata)) {
-		SSI_LOG_ERR("Failed to allocate drvdata");
+		SSI_LOG_ERR("Failed to allocate drvdata\n");
 		rc = -ENOMEM;
 		goto init_cc_res_err;
 	}
@@ -258,8 +258,8 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	/* Map registers space */
 	req_mem_cc_regs = request_mem_region(new_drvdata->res_mem->start, resource_size(new_drvdata->res_mem), "arm_cc7x_regs");
 	if (unlikely(!req_mem_cc_regs)) {
-		SSI_LOG_ERR("Couldn't allocate registers memory region at "
-			     "0x%08X\n", (unsigned int)new_drvdata->res_mem->start);
+		SSI_LOG_ERR("Couldn't allocate registers memory region at 0x%08X\n",
+			    (unsigned int)new_drvdata->res_mem->start);
 		rc = -EBUSY;
 		goto init_cc_res_err;
 	}
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 13291aeaf350..18d85e8ad6cf 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -138,10 +138,9 @@ static int ssi_hash_map_result(struct device *dev,
 			    digestsize);
 		return -ENOMEM;
 	}
-	SSI_LOG_DEBUG("Mapped digest result buffer %u B "
-		     "at va=%pK to dma=%pad\n",
-		digestsize, state->digest_result_buff,
-		state->digest_result_dma_addr);
+	SSI_LOG_DEBUG("Mapped digest result buffer %u B at va=%pK to dma=%pad\n",
+		      digestsize, state->digest_result_buff,
+		      state->digest_result_dma_addr);
 
 	return 0;
 }
@@ -352,11 +351,10 @@ static void ssi_hash_unmap_result(struct device *dev,
 				 state->digest_result_dma_addr,
 				 digestsize,
 				  DMA_BIDIRECTIONAL);
-		SSI_LOG_DEBUG("unmpa digest result buffer "
-			     "va (%pK) pa (%pad) len %u\n",
-			     state->digest_result_buff,
-			     state->digest_result_dma_addr,
-			     digestsize);
+		SSI_LOG_DEBUG("unmpa digest result buffer va (%pK) pa (%pad) len %u\n",
+			      state->digest_result_buff,
+			      state->digest_result_dma_addr,
+			      digestsize);
 		memcpy(result,
 		       state->digest_result_buff,
 		       digestsize);
@@ -971,7 +969,7 @@ static int ssi_hash_setkey(void *hash,
 	struct cc_hw_desc desc[SSI_MAX_AHASH_SEQ_LEN];
 	ssi_sram_addr_t larval_addr;
 
-	 SSI_LOG_DEBUG("start keylen: %d", keylen);
+	 SSI_LOG_DEBUG("start keylen: %d\n", keylen);
 
 	ctx = crypto_ahash_ctx(((struct crypto_ahash *)hash));
 	blocksize = crypto_tfm_alg_blocksize(&((struct crypto_ahash *)hash)->base);
@@ -994,13 +992,13 @@ static int ssi_hash_setkey(void *hash,
 						keylen, DMA_TO_DEVICE);
 		if (unlikely(dma_mapping_error(&ctx->drvdata->plat_dev->dev,
 					       ctx->key_params.key_dma_addr))) {
-			SSI_LOG_ERR("Mapping key va=0x%p len=%u for"
-				   " DMA failed\n", key, keylen);
+			SSI_LOG_ERR("Mapping key va=0x%p len=%u for DMA failed\n",
+				    key, keylen);
 			return -ENOMEM;
 		}
-		SSI_LOG_DEBUG("mapping key-buffer: key_dma_addr=%pad "
-			     "keylen=%u\n", ctx->key_params.key_dma_addr,
-			     ctx->key_params.keylen);
+		SSI_LOG_DEBUG("mapping key-buffer: key_dma_addr=%pad keylen=%u\n",
+			      ctx->key_params.key_dma_addr,
+			      ctx->key_params.keylen);
 
 		if (keylen > blocksize) {
 			/* Load hash initial state */
@@ -1176,14 +1174,13 @@ static int ssi_xcbc_setkey(struct crypto_ahash *ahash,
 					keylen, DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(&ctx->drvdata->plat_dev->dev,
 				       ctx->key_params.key_dma_addr))) {
-		SSI_LOG_ERR("Mapping key va=0x%p len=%u for"
-			   " DMA failed\n", key, keylen);
+		SSI_LOG_ERR("Mapping key va=0x%p len=%u for DMA failed\n",
+			    key, keylen);
 		return -ENOMEM;
 	}
-	SSI_LOG_DEBUG("mapping key-buffer: key_dma_addr=%pad "
-		     "keylen=%u\n",
-		     ctx->key_params.key_dma_addr,
-		     ctx->key_params.keylen);
+	SSI_LOG_DEBUG("mapping key-buffer: key_dma_addr=%pad keylen=%u\n",
+		      ctx->key_params.key_dma_addr,
+		      ctx->key_params.keylen);
 
 	ctx->is_hmac = true;
 	/* 1. Load the AES key */
@@ -1284,8 +1281,7 @@ static void ssi_hash_free_ctx(struct ssi_hash_ctx *ctx)
 	if (ctx->digest_buff_dma_addr != 0) {
 		dma_unmap_single(dev, ctx->digest_buff_dma_addr,
 				 sizeof(ctx->digest_buff), DMA_BIDIRECTIONAL);
-		SSI_LOG_DEBUG("Unmapped digest-buffer: "
-			     "digest_buff_dma_addr=%pad\n",
+		SSI_LOG_DEBUG("Unmapped digest-buffer: digest_buff_dma_addr=%pad\n",
 			      ctx->digest_buff_dma_addr);
 		ctx->digest_buff_dma_addr = 0;
 	}
@@ -1293,8 +1289,7 @@ static void ssi_hash_free_ctx(struct ssi_hash_ctx *ctx)
 		dma_unmap_single(dev, ctx->opad_tmp_keys_dma_addr,
 				 sizeof(ctx->opad_tmp_keys_buff),
 				 DMA_BIDIRECTIONAL);
-		SSI_LOG_DEBUG("Unmapped opad-digest: "
-			     "opad_tmp_keys_dma_addr=%pad\n",
+		SSI_LOG_DEBUG("Unmapped opad-digest: opad_tmp_keys_dma_addr=%pad\n",
 			      ctx->opad_tmp_keys_dma_addr);
 		ctx->opad_tmp_keys_dma_addr = 0;
 	}
@@ -1362,7 +1357,7 @@ static void ssi_hash_cra_exit(struct crypto_tfm *tfm)
 {
 	struct ssi_hash_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	SSI_LOG_DEBUG("ssi_hash_cra_exit");
+	SSI_LOG_DEBUG("ssi_hash_cra_exit\n");
 	ssi_hash_free_ctx(ctx);
 }
 
diff --git a/drivers/staging/ccree/ssi_ivgen.c b/drivers/staging/ccree/ssi_ivgen.c
index b01e03231947..19bfb8b2e0a7 100644
--- a/drivers/staging/ccree/ssi_ivgen.c
+++ b/drivers/staging/ccree/ssi_ivgen.c
@@ -194,8 +194,8 @@ int ssi_ivgen_init(struct ssi_drvdata *drvdata)
 	drvdata->ivgen_handle = kzalloc(sizeof(*drvdata->ivgen_handle),
 					GFP_KERNEL);
 	if (!drvdata->ivgen_handle) {
-		SSI_LOG_ERR("Not enough memory to allocate IVGEN context "
-			   "(%zu B)\n", sizeof(*drvdata->ivgen_handle));
+		SSI_LOG_ERR("Not enough memory to allocate IVGEN context (%zu B)\n",
+			    sizeof(*drvdata->ivgen_handle));
 		rc = -ENOMEM;
 		goto out;
 	}
@@ -206,8 +206,8 @@ int ssi_ivgen_init(struct ssi_drvdata *drvdata)
 						  &ivgen_ctx->pool_meta_dma,
 						  GFP_KERNEL);
 	if (!ivgen_ctx->pool_meta) {
-		SSI_LOG_ERR("Not enough memory to allocate DMA of pool_meta "
-			   "(%u B)\n", SSI_IVPOOL_META_SIZE);
+		SSI_LOG_ERR("Not enough memory to allocate DMA of pool_meta (%u B)\n",
+			    SSI_IVPOOL_META_SIZE);
 		rc = -ENOMEM;
 		goto out;
 	}
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index e5c2f92857f6..7df0110186c5 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -140,8 +140,8 @@ int request_mgr_init(struct ssi_drvdata *drvdata)
 							&req_mgr_h->dummy_comp_buff_dma,
 							GFP_KERNEL);
 	if (!req_mgr_h->dummy_comp_buff) {
-		SSI_LOG_ERR("Not enough memory to allocate DMA (%zu) dropped "
-			   "buffer\n", sizeof(u32));
+		SSI_LOG_ERR("Not enough memory to allocate DMA (%zu) dropped buffer\n",
+			    sizeof(u32));
 		rc = -ENOMEM;
 		goto req_mgr_init_err;
 	}
@@ -238,12 +238,11 @@ static inline int request_mgr_queues_status_check(
 			      req_mgr_h->q_free_slots, total_seq_len);
 	}
 	/* No room in the HW queue try again later */
-	SSI_LOG_DEBUG("HW FIFO full, timeout. req_queue_head=%d "
-		   "sw_fifo_len=%d q_free_slots=%d total_seq_len=%d\n",
-		     req_mgr_h->req_queue_head,
-		   MAX_REQUEST_QUEUE_SIZE,
-		   req_mgr_h->q_free_slots,
-		   total_seq_len);
+	SSI_LOG_DEBUG("HW FIFO full, timeout. req_queue_head=%d sw_fifo_len=%d q_free_slots=%d total_seq_len=%d\n",
+		      req_mgr_h->req_queue_head,
+		      MAX_REQUEST_QUEUE_SIZE,
+		      req_mgr_h->q_free_slots,
+		      total_seq_len);
 	return -EAGAIN;
 }
 
diff --git a/drivers/staging/ccree/ssi_sram_mgr.c b/drivers/staging/ccree/ssi_sram_mgr.c
index f11116afe89a..de8aef4c8abe 100644
--- a/drivers/staging/ccree/ssi_sram_mgr.c
+++ b/drivers/staging/ccree/ssi_sram_mgr.c
@@ -89,7 +89,7 @@ ssi_sram_addr_t ssi_sram_mgr_alloc(struct ssi_drvdata *drvdata, u32 size)
 	ssi_sram_addr_t p;
 
 	if (unlikely((size & 0x3) != 0)) {
-		SSI_LOG_ERR("Requested buffer size (%u) is not multiple of 4",
+		SSI_LOG_ERR("Requested buffer size (%u) is not multiple of 4\n",
 			    size);
 		return NULL_SRAM_ADDR;
 	}
-- 
2.10.0.rc2.1.g053435c
