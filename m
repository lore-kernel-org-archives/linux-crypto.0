From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 05/12] staging: ccree: fix split strings
Date: Thu, 13 Jul 2017 11:19:55 +0300
Message-ID: <1499934004-28513-6-git-send-email-gilad@benyossef.com>
References: <1499934004-28513-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1499934004-28513-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Fix strings in log messages being split across lines and the resulting
alignment issues when being fixed.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c        |  9 ++--
 drivers/staging/ccree/ssi_buffer_mgr.c  | 86 ++++++++++++++-------------------
 drivers/staging/ccree/ssi_cipher.c      | 27 +++++------
 drivers/staging/ccree/ssi_driver.c      |  4 +-
 drivers/staging/ccree/ssi_hash.c        | 43 ++++++++---------
 drivers/staging/ccree/ssi_ivgen.c       |  8 +--
 drivers/staging/ccree/ssi_request_mgr.c | 13 ++---
 7 files changed, 81 insertions(+), 109 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 51a2b73..2d6ba8d 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -240,9 +240,8 @@ static void ssi_aead_complete(struct device *dev, void *ssi_req, void __iomem *c
 	if (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT) {
 		if (memcmp(areq_ctx->mac_buf, areq_ctx->icv_virt_addr,
 			   ctx->authsize) != 0) {
-			SSI_LOG_DEBUG("Payload authentication failure, "
-				"(auth-size=%d, cipher=%d).\n",
-				ctx->authsize, ctx->cipher_mode);
+			SSI_LOG_DEBUG("Payload authentication failure, (auth-size=%d, cipher=%d).\n",
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
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index c3960d1..ed3945b 100644
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
@@ -258,11 +258,9 @@ static int ssi_buffer_mgr_generate_mlli(
 	/* Set MLLI size for the bypass operation */
 	mlli_params->mlli_len = (total_nents * LLI_ENTRY_BYTE_SIZE);
 
-	SSI_LOG_DEBUG("MLLI params: "
-		     "virt_addr=%pK dma_addr=%pad mlli_len=0x%X\n",
-		   mlli_params->mlli_virt_addr,
-		   mlli_params->mlli_dma_addr,
-		   mlli_params->mlli_len);
+	SSI_LOG_DEBUG("MLLI params: virt_addr=%pK dma_addr=%pad mlli_len=0x%X\n",
+		      mlli_params->mlli_virt_addr, mlli_params->mlli_dma_addr,
+		      mlli_params->mlli_len);
 
 build_mlli_exit:
 	return rc;
@@ -275,9 +273,8 @@ static inline void ssi_buffer_mgr_add_buffer_entry(
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
@@ -358,8 +355,7 @@ static int ssi_buffer_mgr_map_scatterlist(
 			SSI_LOG_ERR("dma_map_sg() single buffer failed\n");
 			return -ENOMEM;
 		}
-		SSI_LOG_DEBUG("Mapped sg: dma_address=%pad "
-			     "page=%p addr=%pK offset=%u "
+		SSI_LOG_DEBUG("Mapped sg: dma_address=%pad page=%p addr=%pK offset=%u "
 			     "length=%u\n",
 			     sg_dma_address(sg),
 			     sg_page(sg),
@@ -418,12 +414,10 @@ ssi_aead_handle_config_buf(struct device *dev,
 	sg_init_one(&areq_ctx->ccm_adata_sg, config_data, AES_BLOCK_SIZE + areq_ctx->ccm_hdr_size);
 	if (unlikely(dma_map_sg(dev, &areq_ctx->ccm_adata_sg, 1,
 				DMA_TO_DEVICE) != 1)) {
-			SSI_LOG_ERR("dma_map_sg() "
-			   "config buffer failed\n");
+			SSI_LOG_ERR("dma_map_sg() config buffer failed\n");
 			return -ENOMEM;
 	}
-	SSI_LOG_DEBUG("Mapped curr_buff: dma_address=%pad "
-		     "page=%p addr=%pK "
+	SSI_LOG_DEBUG("Mapped curr_buff: dma_address=%pad page=%p addr=%pK "
 		     "offset=%u length=%u\n",
 		     sg_dma_address(&areq_ctx->ccm_adata_sg),
 		     sg_page(&areq_ctx->ccm_adata_sg),
@@ -451,12 +445,10 @@ static inline int ssi_ahash_handle_curr_buf(struct device *dev,
 	sg_init_one(areq_ctx->buff_sg, curr_buff, curr_buff_cnt);
 	if (unlikely(dma_map_sg(dev, areq_ctx->buff_sg, 1,
 				DMA_TO_DEVICE) != 1)) {
-			SSI_LOG_ERR("dma_map_sg() "
-			   "src buffer failed\n");
+			SSI_LOG_ERR("dma_map_sg() src buffer failed\n");
 			return -ENOMEM;
 	}
-	SSI_LOG_DEBUG("Mapped curr_buff: dma_address=%pad "
-		     "page=%p addr=%pK "
+	SSI_LOG_DEBUG("Mapped curr_buff: dma_address=%pad page=%p addr=%pK "
 		     "offset=%u length=%u\n",
 		     sg_dma_address(areq_ctx->buff_sg),
 		     sg_page(areq_ctx->buff_sg),
@@ -538,8 +530,8 @@ int ssi_buffer_mgr_map_blkcipher_request(
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
@@ -1340,9 +1332,9 @@ int ssi_buffer_mgr_map_aead_request(
 							    DMA_TO_DEVICE);
 
 		if (unlikely(dma_mapping_error(dev, areq_ctx->ccm_iv0_dma_addr))) {
-			SSI_LOG_ERR("Mapping mac_buf %u B at va=%pK "
-			"for DMA failed\n", AES_BLOCK_SIZE,
-			(areq_ctx->ccm_config + CCM_CTR_COUNT_0_OFFSET));
+			SSI_LOG_ERR("Mapping mac_buf %u B at va=%pK for DMA failed\n",
+				    AES_BLOCK_SIZE, (areq_ctx->ccm_config +
+						     CCM_CTR_COUNT_0_OFFSET));
 			areq_ctx->ccm_iv0_dma_addr = 0;
 			rc = -ENOMEM;
 			goto aead_map_failure;
@@ -1382,9 +1374,8 @@ int ssi_buffer_mgr_map_aead_request(
 			AES_BLOCK_SIZE, DMA_TO_DEVICE);
 
 		if (unlikely(dma_mapping_error(dev, areq_ctx->gcm_iv_inc1_dma_addr))) {
-			SSI_LOG_ERR("Mapping gcm_iv_inc1 %u B at va=%pK "
-			"for DMA failed\n", AES_BLOCK_SIZE,
-			(areq_ctx->gcm_iv_inc1));
+			SSI_LOG_ERR("Mapping gcm_iv_inc1 %u B at va=%pK for DMA failed\n",
+				    AES_BLOCK_SIZE, (areq_ctx->gcm_iv_inc1));
 			areq_ctx->gcm_iv_inc1_dma_addr = 0;
 			rc = -ENOMEM;
 			goto aead_map_failure;
@@ -1396,9 +1387,8 @@ int ssi_buffer_mgr_map_aead_request(
 								DMA_TO_DEVICE);
 
 		if (unlikely(dma_mapping_error(dev, areq_ctx->gcm_iv_inc2_dma_addr))) {
-			SSI_LOG_ERR("Mapping gcm_iv_inc2 %u B at va=%pK "
-			"for DMA failed\n", AES_BLOCK_SIZE,
-			(areq_ctx->gcm_iv_inc2));
+			SSI_LOG_ERR("Mapping gcm_iv_inc2 %u B at va=%pK for DMA failed\n",
+				    AES_BLOCK_SIZE, (areq_ctx->gcm_iv_inc2));
 			areq_ctx->gcm_iv_inc2_dma_addr = 0;
 			rc = -ENOMEM;
 			goto aead_map_failure;
@@ -1504,8 +1494,7 @@ int ssi_buffer_mgr_map_hash_request_final(
 	u32 dummy = 0;
 	u32 mapped_nents = 0;
 
-	SSI_LOG_DEBUG(" final params : curr_buff=%pK "
-		     "curr_buff_cnt=0x%X nbytes = 0x%X "
+	SSI_LOG_DEBUG(" final params : curr_buff=%pK curr_buff_cnt=0x%X nbytes = 0x%X "
 		     "src=%pK curr_index=%u\n",
 		     curr_buff, *curr_buff_cnt, nbytes,
 		     src, areq_ctx->buff_index);
@@ -1601,8 +1590,7 @@ int ssi_buffer_mgr_map_hash_request_update(
 	u32 dummy = 0;
 	u32 mapped_nents = 0;
 
-	SSI_LOG_DEBUG(" update params : curr_buff=%pK "
-		     "curr_buff_cnt=0x%X nbytes=0x%X "
+	SSI_LOG_DEBUG(" update params : curr_buff=%pK curr_buff_cnt=0x%X nbytes=0x%X "
 		     "src=%pK curr_index=%u\n",
 		     curr_buff, *curr_buff_cnt, nbytes,
 		     src, areq_ctx->buff_index);
@@ -1614,10 +1602,9 @@ int ssi_buffer_mgr_map_hash_request_update(
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
@@ -1633,16 +1620,14 @@ int ssi_buffer_mgr_map_hash_request_update(
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
+			      next_buff, (update_data_len - *curr_buff_cnt),
+			      *next_buff_cnt);
 		ssi_buffer_mgr_copy_scatterlist_portion(next_buff, src,
 							(update_data_len - *curr_buff_cnt),
 							nbytes, SSI_SG_TO_BUF);
@@ -1740,11 +1725,10 @@ void ssi_buffer_mgr_unmap_hash_request(
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
index 06ee66d..7e34236 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -635,11 +635,10 @@ ssi_blkcipher_create_data_desc(
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
@@ -655,21 +654,19 @@ ssi_blkcipher_create_data_desc(
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
+				      (u32)LLI_ENTRY_BYTE_SIZE *
+				      req_ctx->in_nents);
 			set_dout_mlli(&desc[*seq_size],
 				      (ctx_p->drvdata->mlli_sram_addr +
 				       (LLI_ENTRY_BYTE_SIZE *
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index d7b9a63..c07a028 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -257,8 +257,8 @@ static int init_cc_resources(struct platform_device *plat_dev)
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
index 2f70761..d0c8a8d 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -137,10 +137,9 @@ static int ssi_hash_map_result(struct device *dev,
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
@@ -357,11 +356,10 @@ static void ssi_hash_unmap_result(struct device *dev,
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
@@ -999,13 +997,13 @@ static int ssi_hash_setkey(void *hash,
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
@@ -1181,14 +1179,13 @@ static int ssi_xcbc_setkey(struct crypto_ahash *ahash,
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
@@ -1289,8 +1286,7 @@ static void ssi_hash_free_ctx(struct ssi_hash_ctx *ctx)
 	if (ctx->digest_buff_dma_addr != 0) {
 		dma_unmap_single(dev, ctx->digest_buff_dma_addr,
 				 sizeof(ctx->digest_buff), DMA_BIDIRECTIONAL);
-		SSI_LOG_DEBUG("Unmapped digest-buffer: "
-			     "digest_buff_dma_addr=%pad\n",
+		SSI_LOG_DEBUG("Unmapped digest-buffer: digest_buff_dma_addr=%pad\n",
 			      ctx->digest_buff_dma_addr);
 		ctx->digest_buff_dma_addr = 0;
 	}
@@ -1298,8 +1294,7 @@ static void ssi_hash_free_ctx(struct ssi_hash_ctx *ctx)
 		dma_unmap_single(dev, ctx->opad_tmp_keys_dma_addr,
 				 sizeof(ctx->opad_tmp_keys_buff),
 				 DMA_BIDIRECTIONAL);
-		SSI_LOG_DEBUG("Unmapped opad-digest: "
-			     "opad_tmp_keys_dma_addr=%pad\n",
+		SSI_LOG_DEBUG("Unmapped opad-digest: opad_tmp_keys_dma_addr=%pad\n",
 			      ctx->opad_tmp_keys_dma_addr);
 		ctx->opad_tmp_keys_dma_addr = 0;
 	}
diff --git a/drivers/staging/ccree/ssi_ivgen.c b/drivers/staging/ccree/ssi_ivgen.c
index d2123b7..c6f400f 100644
--- a/drivers/staging/ccree/ssi_ivgen.c
+++ b/drivers/staging/ccree/ssi_ivgen.c
@@ -193,8 +193,8 @@ int ssi_ivgen_init(struct ssi_drvdata *drvdata)
 	/* Allocate "this" context */
 	drvdata->ivgen_handle = kzalloc(sizeof(struct ssi_ivgen_ctx), GFP_KERNEL);
 	if (!drvdata->ivgen_handle) {
-		SSI_LOG_ERR("Not enough memory to allocate IVGEN context "
-			   "(%zu B)\n", sizeof(struct ssi_ivgen_ctx));
+		SSI_LOG_ERR("Not enough memory to allocate IVGEN context (%zu B)\n",
+			    sizeof(struct ssi_ivgen_ctx));
 		rc = -ENOMEM;
 		goto out;
 	}
@@ -204,8 +204,8 @@ int ssi_ivgen_init(struct ssi_drvdata *drvdata)
 	ivgen_ctx->pool_meta = dma_alloc_coherent(device, SSI_IVPOOL_META_SIZE,
 						  &ivgen_ctx->pool_meta_dma, GFP_KERNEL);
 	if (!ivgen_ctx->pool_meta) {
-		SSI_LOG_ERR("Not enough memory to allocate DMA of pool_meta "
-			   "(%u B)\n", SSI_IVPOOL_META_SIZE);
+		SSI_LOG_ERR("Not enough memory to allocate DMA of pool_meta (%u B)\n",
+			    SSI_IVPOOL_META_SIZE);
 		rc = -ENOMEM;
 		goto out;
 	}
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index 2eda82f..9a4bb5c 100644
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
@@ -238,12 +238,9 @@ static inline int request_mgr_queues_status_check(
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
+		      req_mgr_h->req_queue_head, MAX_REQUEST_QUEUE_SIZE,
+		      req_mgr_h->q_free_slots, total_seq_len);
 	return -EAGAIN;
 }
 
-- 
2.1.4
