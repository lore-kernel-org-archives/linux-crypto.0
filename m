From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 03/12] staging: ccree: use proper printk format for dma_addr_t
Date: Thu, 13 Jul 2017 11:19:53 +0300
Message-ID: <1499934004-28513-4-git-send-email-gilad@benyossef.com>
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

Fix needless casting to unsigned long long in printk for
DMA addresses by using proper %pad format.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c        | 16 ++++----
 drivers/staging/ccree/ssi_buffer_mgr.c  | 48 ++++++++++++------------
 drivers/staging/ccree/ssi_cipher.c      | 20 +++++-----
 drivers/staging/ccree/ssi_driver.c      |  6 +--
 drivers/staging/ccree/ssi_hash.c        | 65 ++++++++++++++++-----------------
 drivers/staging/ccree/ssi_request_mgr.c |  8 ++--
 6 files changed, 81 insertions(+), 82 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index fd37dde..43455b9 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -102,8 +102,8 @@ static void ssi_aead_exit(struct crypto_aead *tfm)
 	/* Unmap enckey buffer */
 	if (ctx->enckey) {
 		dma_free_coherent(dev, AES_MAX_KEY_SIZE, ctx->enckey, ctx->enckey_dma_addr);
-		SSI_LOG_DEBUG("Freed enckey DMA buffer enckey_dma_addr=0x%llX\n",
-			(unsigned long long)ctx->enckey_dma_addr);
+		SSI_LOG_DEBUG("Freed enckey DMA buffer enckey_dma_addr=%pad\n",
+			      ctx->enckey_dma_addr);
 		ctx->enckey_dma_addr = 0;
 		ctx->enckey = NULL;
 	}
@@ -116,8 +116,8 @@ static void ssi_aead_exit(struct crypto_aead *tfm)
 					  xcbc->xcbc_keys,
 					  xcbc->xcbc_keys_dma_addr);
 		}
-		SSI_LOG_DEBUG("Freed xcbc_keys DMA buffer xcbc_keys_dma_addr=0x%llX\n",
-			      (unsigned long long)xcbc->xcbc_keys_dma_addr);
+		SSI_LOG_DEBUG("Freed xcbc_keys DMA buffer xcbc_keys_dma_addr=%pad\n",
+			      xcbc->xcbc_keys_dma_addr);
 		xcbc->xcbc_keys_dma_addr = 0;
 		xcbc->xcbc_keys = NULL;
 	} else if (ctx->auth_mode != DRV_HASH_NULL) { /* HMAC auth. */
@@ -127,8 +127,8 @@ static void ssi_aead_exit(struct crypto_aead *tfm)
 			dma_free_coherent(dev, 2 * MAX_HMAC_DIGEST_SIZE,
 					  hmac->ipad_opad,
 					  hmac->ipad_opad_dma_addr);
-			SSI_LOG_DEBUG("Freed ipad_opad DMA buffer ipad_opad_dma_addr=0x%llX\n",
-				      (unsigned long long)hmac->ipad_opad_dma_addr);
+			SSI_LOG_DEBUG("Freed ipad_opad DMA buffer ipad_opad_dma_addr=%pad\n",
+				      hmac->ipad_opad_dma_addr);
 			hmac->ipad_opad_dma_addr = 0;
 			hmac->ipad_opad = NULL;
 		}
@@ -136,8 +136,8 @@ static void ssi_aead_exit(struct crypto_aead *tfm)
 			dma_free_coherent(dev, MAX_HMAC_BLOCK_SIZE,
 					  hmac->padded_authkey,
 					  hmac->padded_authkey_dma_addr);
-			SSI_LOG_DEBUG("Freed padded_authkey DMA buffer padded_authkey_dma_addr=0x%llX\n",
-				(unsigned long long)hmac->padded_authkey_dma_addr);
+			SSI_LOG_DEBUG("Freed padded_authkey DMA buffer padded_authkey_dma_addr=%pad\n",
+				      hmac->padded_authkey_dma_addr);
 			hmac->padded_authkey_dma_addr = 0;
 			hmac->padded_authkey = NULL;
 		}
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 4127f9f..dcd78f6 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -259,9 +259,9 @@ static int ssi_buffer_mgr_generate_mlli(
 	mlli_params->mlli_len = (total_nents * LLI_ENTRY_BYTE_SIZE);
 
 	SSI_LOG_DEBUG("MLLI params: "
-		     "virt_addr=%pK dma_addr=0x%llX mlli_len=0x%X\n",
+		     "virt_addr=%pK dma_addr=%pad mlli_len=0x%X\n",
 		   mlli_params->mlli_virt_addr,
-		   (unsigned long long)mlli_params->mlli_dma_addr,
+		   mlli_params->mlli_dma_addr,
 		   mlli_params->mlli_len);
 
 build_mlli_exit:
@@ -275,9 +275,9 @@ static inline void ssi_buffer_mgr_add_buffer_entry(
 {
 	unsigned int index = sgl_data->num_of_buffers;
 
-	SSI_LOG_DEBUG("index=%u single_buff=0x%llX "
+	SSI_LOG_DEBUG("index=%u single_buff=%pad "
 		     "buffer_len=0x%08X is_last=%d\n",
-		     index, (unsigned long long)buffer_dma, buffer_len, is_last_entry);
+		     index, buffer_dma, buffer_len, is_last_entry);
 	sgl_data->nents[index] = 1;
 	sgl_data->entry[index].buffer_dma = buffer_dma;
 	sgl_data->offset[index] = 0;
@@ -358,10 +358,10 @@ static int ssi_buffer_mgr_map_scatterlist(
 			SSI_LOG_ERR("dma_map_sg() single buffer failed\n");
 			return -ENOMEM;
 		}
-		SSI_LOG_DEBUG("Mapped sg: dma_address=0x%llX "
+		SSI_LOG_DEBUG("Mapped sg: dma_address=%pad "
 			     "page=%p addr=%pK offset=%u "
 			     "length=%u\n",
-			     (unsigned long long)sg_dma_address(sg),
+			     sg_dma_address(sg),
 			     sg_page(sg),
 			     sg_virt(sg),
 			     sg->offset, sg->length);
@@ -422,10 +422,10 @@ ssi_aead_handle_config_buf(struct device *dev,
 			   "config buffer failed\n");
 			return -ENOMEM;
 	}
-	SSI_LOG_DEBUG("Mapped curr_buff: dma_address=0x%llX "
+	SSI_LOG_DEBUG("Mapped curr_buff: dma_address=%pad "
 		     "page=%p addr=%pK "
 		     "offset=%u length=%u\n",
-		     (unsigned long long)sg_dma_address(&areq_ctx->ccm_adata_sg),
+		     sg_dma_address(&areq_ctx->ccm_adata_sg),
 		     sg_page(&areq_ctx->ccm_adata_sg),
 		     sg_virt(&areq_ctx->ccm_adata_sg),
 		     areq_ctx->ccm_adata_sg.offset,
@@ -455,10 +455,10 @@ static inline int ssi_ahash_handle_curr_buf(struct device *dev,
 			   "src buffer failed\n");
 			return -ENOMEM;
 	}
-	SSI_LOG_DEBUG("Mapped curr_buff: dma_address=0x%llX "
+	SSI_LOG_DEBUG("Mapped curr_buff: dma_address=%pad "
 		     "page=%p addr=%pK "
 		     "offset=%u length=%u\n",
-		     (unsigned long long)sg_dma_address(areq_ctx->buff_sg),
+		     sg_dma_address(areq_ctx->buff_sg),
 		     sg_page(areq_ctx->buff_sg),
 		     sg_virt(areq_ctx->buff_sg),
 		     areq_ctx->buff_sg->offset,
@@ -482,8 +482,8 @@ void ssi_buffer_mgr_unmap_blkcipher_request(
 	struct blkcipher_req_ctx *req_ctx = (struct blkcipher_req_ctx *)ctx;
 
 	if (likely(req_ctx->gen_ctx.iv_dma_addr != 0)) {
-		SSI_LOG_DEBUG("Unmapped iv: iv_dma_addr=0x%llX iv_size=%u\n",
-			      (unsigned long long)req_ctx->gen_ctx.iv_dma_addr,
+		SSI_LOG_DEBUG("Unmapped iv: iv_dma_addr=%pad iv_size=%u\n",
+			      req_ctx->gen_ctx.iv_dma_addr,
 			      ivsize);
 		dma_unmap_single(dev, req_ctx->gen_ctx.iv_dma_addr,
 				 ivsize,
@@ -542,9 +542,9 @@ int ssi_buffer_mgr_map_blkcipher_request(
 				   "for DMA failed\n", ivsize, info);
 			return -ENOMEM;
 		}
-		SSI_LOG_DEBUG("Mapped iv %u B at va=%pK to dma=0x%llX\n",
+		SSI_LOG_DEBUG("Mapped iv %u B at va=%pK to dma=%pad\n",
 			      ivsize, info,
-			      (unsigned long long)req_ctx->gen_ctx.iv_dma_addr);
+			      req_ctx->gen_ctx.iv_dma_addr);
 	} else {
 		req_ctx->gen_ctx.iv_dma_addr = 0;
 	}
@@ -673,8 +673,8 @@ void ssi_buffer_mgr_unmap_aead_request(
 	 *allocated and should be released
 	 */
 	if (areq_ctx->mlli_params.curr_pool) {
-		SSI_LOG_DEBUG("free MLLI buffer: dma=0x%08llX virt=%pK\n",
-			      (unsigned long long)areq_ctx->mlli_params.mlli_dma_addr,
+		SSI_LOG_DEBUG("free MLLI buffer: dma=%pad virt=%pK\n",
+			      areq_ctx->mlli_params.mlli_dma_addr,
 			      areq_ctx->mlli_params.mlli_virt_addr);
 		dma_pool_free(areq_ctx->mlli_params.curr_pool,
 			      areq_ctx->mlli_params.mlli_virt_addr,
@@ -791,9 +791,9 @@ static inline int ssi_buffer_mgr_aead_chain_iv(
 		goto chain_iv_exit;
 	}
 
-	SSI_LOG_DEBUG("Mapped iv %u B at va=%pK to dma=0x%llX\n",
+	SSI_LOG_DEBUG("Mapped iv %u B at va=%pK to dma=%pad\n",
 		      hw_iv_size, req->iv,
-		      (unsigned long long)areq_ctx->gen_ctx.iv_dma_addr);
+		      areq_ctx->gen_ctx.iv_dma_addr);
 	if (do_chain && areq_ctx->plaintext_authenticate_only) {  // TODO: what about CTR?? ask Ron
 		struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 		unsigned int iv_size_to_authenc = crypto_aead_ivsize(tfm);
@@ -1716,8 +1716,8 @@ void ssi_buffer_mgr_unmap_hash_request(
 	 *allocated and should be released
 	 */
 	if (areq_ctx->mlli_params.curr_pool) {
-		SSI_LOG_DEBUG("free MLLI buffer: dma=0x%llX virt=%pK\n",
-			      (unsigned long long)areq_ctx->mlli_params.mlli_dma_addr,
+		SSI_LOG_DEBUG("free MLLI buffer: dma=%pad virt=%pK\n",
+			      areq_ctx->mlli_params.mlli_dma_addr,
 			      areq_ctx->mlli_params.mlli_virt_addr);
 		dma_pool_free(areq_ctx->mlli_params.curr_pool,
 			      areq_ctx->mlli_params.mlli_virt_addr,
@@ -1725,9 +1725,9 @@ void ssi_buffer_mgr_unmap_hash_request(
 	}
 
 	if ((src) && likely(areq_ctx->in_nents != 0)) {
-		SSI_LOG_DEBUG("Unmapped sg src: virt=%pK dma=0x%llX len=0x%X\n",
+		SSI_LOG_DEBUG("Unmapped sg src: virt=%pK dma=%pad len=0x%X\n",
 			      sg_virt(src),
-			      (unsigned long long)sg_dma_address(src),
+			      sg_dma_address(src),
 			      sg_dma_len(src));
 		dma_unmap_sg(dev, src,
 			     areq_ctx->in_nents, DMA_TO_DEVICE);
@@ -1735,9 +1735,9 @@ void ssi_buffer_mgr_unmap_hash_request(
 
 	if (*prev_len != 0) {
 		SSI_LOG_DEBUG("Unmapped buffer: areq_ctx->buff_sg=%pK"
-			     " dma=0x%llX len 0x%X\n",
+			     " dma=%pad len 0x%X\n",
 				sg_virt(areq_ctx->buff_sg),
-				(unsigned long long)sg_dma_address(areq_ctx->buff_sg),
+				sg_dma_address(areq_ctx->buff_sg),
 				sg_dma_len(areq_ctx->buff_sg));
 		dma_unmap_sg(dev, areq_ctx->buff_sg, 1, DMA_TO_DEVICE);
 		if (!do_revert) {
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index f05ba70..10be927 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -209,9 +209,9 @@ static int ssi_blkcipher_init(struct crypto_tfm *tfm)
 			    max_key_buf_size, ctx_p->user.key);
 		return -ENOMEM;
 	}
-	SSI_LOG_DEBUG("Mapped key %u B at va=%pK to dma=0x%llX\n",
+	SSI_LOG_DEBUG("Mapped key %u B at va=%pK to dma=%pad\n",
 		      max_key_buf_size, ctx_p->user.key,
-		      (unsigned long long)ctx_p->user.key_dma_addr);
+		      ctx_p->user.key_dma_addr);
 
 	if (ctx_p->cipher_mode == DRV_CIPHER_ESSIV) {
 		/* Alloc hash tfm for essiv */
@@ -243,8 +243,8 @@ static void ssi_blkcipher_exit(struct crypto_tfm *tfm)
 	/* Unmap key buffer */
 	dma_unmap_single(dev, ctx_p->user.key_dma_addr, max_key_buf_size,
 			 DMA_TO_DEVICE);
-	SSI_LOG_DEBUG("Unmapped key buffer key_dma_addr=0x%llX\n",
-		      (unsigned long long)ctx_p->user.key_dma_addr);
+	SSI_LOG_DEBUG("Unmapped key buffer key_dma_addr=%pad\n",
+		      ctx_p->user.key_dma_addr);
 
 	/* Free key buffer in context */
 	kfree(ctx_p->user.key);
@@ -619,10 +619,10 @@ ssi_blkcipher_create_data_desc(
 	}
 	/* Process */
 	if (likely(req_ctx->dma_buf_type == SSI_DMA_BUF_DLLI)) {
-		SSI_LOG_DEBUG(" data params addr 0x%llX length 0x%X \n",
-			      (unsigned long long)sg_dma_address(src), nbytes);
-		SSI_LOG_DEBUG(" data params addr 0x%llX length 0x%X \n",
-			      (unsigned long long)sg_dma_address(dst), nbytes);
+		SSI_LOG_DEBUG(" data params addr %pad length 0x%X \n",
+			      sg_dma_address(src), nbytes);
+		SSI_LOG_DEBUG(" data params addr %pad length 0x%X \n",
+			      sg_dma_address(dst), nbytes);
 		hw_desc_init(&desc[*seq_size]);
 		set_din_type(&desc[*seq_size], DMA_DLLI, sg_dma_address(src),
 			     nbytes, NS_BIT);
@@ -635,9 +635,9 @@ ssi_blkcipher_create_data_desc(
 		(*seq_size)++;
 	} else {
 		/* bypass */
-		SSI_LOG_DEBUG(" bypass params addr 0x%llX "
+		SSI_LOG_DEBUG(" bypass params addr %pad "
 			     "length 0x%X addr 0x%08X\n",
-			(unsigned long long)req_ctx->mlli_params.mlli_dma_addr,
+			req_ctx->mlli_params.mlli_dma_addr,
 			req_ctx->mlli_params.mlli_len,
 			(unsigned int)ctx_p->drvdata->mlli_sram_addr);
 		hw_desc_init(&desc[*seq_size]);
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 4246c9b..d7b9a63 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -250,10 +250,10 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		rc = -ENODEV;
 		goto init_cc_res_err;
 	}
-	SSI_LOG_DEBUG("Got MEM resource (%s): start=0x%llX end=0x%llX\n",
+	SSI_LOG_DEBUG("Got MEM resource (%s): start=%pad end=%pad\n",
 		      new_drvdata->res_mem->name,
-		      (unsigned long long)new_drvdata->res_mem->start,
-		      (unsigned long long)new_drvdata->res_mem->end);
+		      new_drvdata->res_mem->start,
+		      new_drvdata->res_mem->end);
 	/* Map registers space */
 	req_mem_cc_regs = request_mem_region(new_drvdata->res_mem->start, resource_size(new_drvdata->res_mem), "arm_cc7x_regs");
 	if (unlikely(!req_mem_cc_regs)) {
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index ffd1f98..658e198 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -139,9 +139,9 @@ static int ssi_hash_map_result(struct device *dev,
 		return -ENOMEM;
 	}
 	SSI_LOG_DEBUG("Mapped digest result buffer %u B "
-		     "at va=%pK to dma=0x%llX\n",
+		     "at va=%pK to dma=%pad\n",
 		digestsize, state->digest_result_buff,
-		(unsigned long long)state->digest_result_dma_addr);
+		state->digest_result_dma_addr);
 
 	return 0;
 }
@@ -203,9 +203,9 @@ static int ssi_hash_map_request(struct device *dev,
 		ctx->inter_digestsize, state->digest_buff);
 		goto fail3;
 	}
-	SSI_LOG_DEBUG("Mapped digest %d B at va=%pK to dma=0x%llX\n",
+	SSI_LOG_DEBUG("Mapped digest %d B at va=%pK to dma=%pad\n",
 		ctx->inter_digestsize, state->digest_buff,
-		(unsigned long long)state->digest_buff_dma_addr);
+		state->digest_buff_dma_addr);
 
 	if (is_hmac) {
 		dma_sync_single_for_cpu(dev, ctx->digest_buff_dma_addr, ctx->inter_digestsize, DMA_BIDIRECTIONAL);
@@ -252,9 +252,9 @@ static int ssi_hash_map_request(struct device *dev,
 			HASH_LEN_SIZE, state->digest_bytes_len);
 			goto fail4;
 		}
-		SSI_LOG_DEBUG("Mapped digest len %u B at va=%pK to dma=0x%llX\n",
+		SSI_LOG_DEBUG("Mapped digest len %u B at va=%pK to dma=%pad\n",
 			HASH_LEN_SIZE, state->digest_bytes_len,
-			(unsigned long long)state->digest_bytes_len_dma_addr);
+			state->digest_bytes_len_dma_addr);
 	} else {
 		state->digest_bytes_len_dma_addr = 0;
 	}
@@ -266,9 +266,9 @@ static int ssi_hash_map_request(struct device *dev,
 			ctx->inter_digestsize, state->opad_digest_buff);
 			goto fail5;
 		}
-		SSI_LOG_DEBUG("Mapped opad digest %d B at va=%pK to dma=0x%llX\n",
+		SSI_LOG_DEBUG("Mapped opad digest %d B at va=%pK to dma=%pad\n",
 			ctx->inter_digestsize, state->opad_digest_buff,
-			(unsigned long long)state->opad_digest_dma_addr);
+			state->opad_digest_dma_addr);
 	} else {
 		state->opad_digest_dma_addr = 0;
 	}
@@ -321,22 +321,22 @@ static void ssi_hash_unmap_request(struct device *dev,
 	if (state->digest_buff_dma_addr != 0) {
 		dma_unmap_single(dev, state->digest_buff_dma_addr,
 				 ctx->inter_digestsize, DMA_BIDIRECTIONAL);
-		SSI_LOG_DEBUG("Unmapped digest-buffer: digest_buff_dma_addr=0x%llX\n",
-			(unsigned long long)state->digest_buff_dma_addr);
+		SSI_LOG_DEBUG("Unmapped digest-buffer: digest_buff_dma_addr=%pad\n",
+			      state->digest_buff_dma_addr);
 		state->digest_buff_dma_addr = 0;
 	}
 	if (state->digest_bytes_len_dma_addr != 0) {
 		dma_unmap_single(dev, state->digest_bytes_len_dma_addr,
 				 HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
-		SSI_LOG_DEBUG("Unmapped digest-bytes-len buffer: digest_bytes_len_dma_addr=0x%llX\n",
-			(unsigned long long)state->digest_bytes_len_dma_addr);
+		SSI_LOG_DEBUG("Unmapped digest-bytes-len buffer: digest_bytes_len_dma_addr=%pad\n",
+			      state->digest_bytes_len_dma_addr);
 		state->digest_bytes_len_dma_addr = 0;
 	}
 	if (state->opad_digest_dma_addr != 0) {
 		dma_unmap_single(dev, state->opad_digest_dma_addr,
 				 ctx->inter_digestsize, DMA_BIDIRECTIONAL);
-		SSI_LOG_DEBUG("Unmapped opad-digest: opad_digest_dma_addr=0x%llX\n",
-			(unsigned long long)state->opad_digest_dma_addr);
+		SSI_LOG_DEBUG("Unmapped opad-digest: opad_digest_dma_addr=%pad\n",
+			      state->opad_digest_dma_addr);
 		state->opad_digest_dma_addr = 0;
 	}
 
@@ -358,9 +358,9 @@ static void ssi_hash_unmap_result(struct device *dev,
 				 digestsize,
 				  DMA_BIDIRECTIONAL);
 		SSI_LOG_DEBUG("unmpa digest result buffer "
-			     "va (%pK) pa (%llx) len %u\n",
+			     "va (%pK) pa (%pad) len %u\n",
 			     state->digest_result_buff,
-			     (unsigned long long)state->digest_result_dma_addr,
+			     state->digest_result_dma_addr,
 			     digestsize);
 		memcpy(result,
 		       state->digest_result_buff,
@@ -1003,9 +1003,8 @@ static int ssi_hash_setkey(void *hash,
 				   " DMA failed\n", key, keylen);
 			return -ENOMEM;
 		}
-		SSI_LOG_DEBUG("mapping key-buffer: key_dma_addr=0x%llX "
-			     "keylen=%u\n",
-			     (unsigned long long)ctx->key_params.key_dma_addr,
+		SSI_LOG_DEBUG("mapping key-buffer: key_dma_addr=%pad "
+			     "keylen=%u\n", ctx->key_params.key_dma_addr,
 			     ctx->key_params.keylen);
 
 		if (keylen > blocksize) {
@@ -1148,8 +1147,8 @@ static int ssi_hash_setkey(void *hash,
 		dma_unmap_single(&ctx->drvdata->plat_dev->dev,
 				ctx->key_params.key_dma_addr,
 				ctx->key_params.keylen, DMA_TO_DEVICE);
-		SSI_LOG_DEBUG("Unmapped key-buffer: key_dma_addr=0x%llX keylen=%u\n",
-				(unsigned long long)ctx->key_params.key_dma_addr,
+		SSI_LOG_DEBUG("Unmapped key-buffer: key_dma_addr=%pad keylen=%u\n",
+				ctx->key_params.key_dma_addr,
 				ctx->key_params.keylen);
 	}
 	return rc;
@@ -1186,9 +1185,9 @@ static int ssi_xcbc_setkey(struct crypto_ahash *ahash,
 			   " DMA failed\n", key, keylen);
 		return -ENOMEM;
 	}
-	SSI_LOG_DEBUG("mapping key-buffer: key_dma_addr=0x%llX "
+	SSI_LOG_DEBUG("mapping key-buffer: key_dma_addr=%pad "
 		     "keylen=%u\n",
-		     (unsigned long long)ctx->key_params.key_dma_addr,
+		     ctx->key_params.key_dma_addr,
 		     ctx->key_params.keylen);
 
 	ctx->is_hmac = true;
@@ -1235,8 +1234,8 @@ static int ssi_xcbc_setkey(struct crypto_ahash *ahash,
 	dma_unmap_single(&ctx->drvdata->plat_dev->dev,
 			ctx->key_params.key_dma_addr,
 			ctx->key_params.keylen, DMA_TO_DEVICE);
-	SSI_LOG_DEBUG("Unmapped key-buffer: key_dma_addr=0x%llX keylen=%u\n",
-			(unsigned long long)ctx->key_params.key_dma_addr,
+	SSI_LOG_DEBUG("Unmapped key-buffer: key_dma_addr=%pad keylen=%u\n",
+			ctx->key_params.key_dma_addr,
 			ctx->key_params.keylen);
 
 	return rc;
@@ -1291,8 +1290,8 @@ static void ssi_hash_free_ctx(struct ssi_hash_ctx *ctx)
 		dma_unmap_single(dev, ctx->digest_buff_dma_addr,
 				 sizeof(ctx->digest_buff), DMA_BIDIRECTIONAL);
 		SSI_LOG_DEBUG("Unmapped digest-buffer: "
-			     "digest_buff_dma_addr=0x%llX\n",
-			(unsigned long long)ctx->digest_buff_dma_addr);
+			     "digest_buff_dma_addr=%pad\n",
+			      ctx->digest_buff_dma_addr);
 		ctx->digest_buff_dma_addr = 0;
 	}
 	if (ctx->opad_tmp_keys_dma_addr != 0) {
@@ -1300,8 +1299,8 @@ static void ssi_hash_free_ctx(struct ssi_hash_ctx *ctx)
 				 sizeof(ctx->opad_tmp_keys_buff),
 				 DMA_BIDIRECTIONAL);
 		SSI_LOG_DEBUG("Unmapped opad-digest: "
-			     "opad_tmp_keys_dma_addr=0x%llX\n",
-			(unsigned long long)ctx->opad_tmp_keys_dma_addr);
+			     "opad_tmp_keys_dma_addr=%pad\n",
+			      ctx->opad_tmp_keys_dma_addr);
 		ctx->opad_tmp_keys_dma_addr = 0;
 	}
 
@@ -1320,9 +1319,9 @@ static int ssi_hash_alloc_ctx(struct ssi_hash_ctx *ctx)
 			sizeof(ctx->digest_buff), ctx->digest_buff);
 		goto fail;
 	}
-	SSI_LOG_DEBUG("Mapped digest %zu B at va=%pK to dma=0x%llX\n",
+	SSI_LOG_DEBUG("Mapped digest %zu B at va=%pK to dma=%pad\n",
 		sizeof(ctx->digest_buff), ctx->digest_buff,
-		(unsigned long long)ctx->digest_buff_dma_addr);
+		      ctx->digest_buff_dma_addr);
 
 	ctx->opad_tmp_keys_dma_addr = dma_map_single(dev, (void *)ctx->opad_tmp_keys_buff, sizeof(ctx->opad_tmp_keys_buff), DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(dev, ctx->opad_tmp_keys_dma_addr)) {
@@ -1331,9 +1330,9 @@ static int ssi_hash_alloc_ctx(struct ssi_hash_ctx *ctx)
 			ctx->opad_tmp_keys_buff);
 		goto fail;
 	}
-	SSI_LOG_DEBUG("Mapped opad_tmp_keys %zu B at va=%pK to dma=0x%llX\n",
+	SSI_LOG_DEBUG("Mapped opad_tmp_keys %zu B at va=%pK to dma=%pad\n",
 		sizeof(ctx->opad_tmp_keys_buff), ctx->opad_tmp_keys_buff,
-		(unsigned long long)ctx->opad_tmp_keys_dma_addr);
+		      ctx->opad_tmp_keys_dma_addr);
 
 	ctx->is_hmac = false;
 	return 0;
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index 0c8988c..3f39150 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -322,11 +322,11 @@ int send_request(
 	}
 
 	if (ssi_req->ivgen_dma_addr_len > 0) {
-		SSI_LOG_DEBUG("Acquire IV from pool into %d DMA addresses 0x%llX, 0x%llX, 0x%llX, IV-size=%u\n",
+		SSI_LOG_DEBUG("Acquire IV from pool into %d DMA addresses %pad, %pad, %pad, IV-size=%u\n",
 			      ssi_req->ivgen_dma_addr_len,
-			      (unsigned long long)ssi_req->ivgen_dma_addr[0],
-			      (unsigned long long)ssi_req->ivgen_dma_addr[1],
-			      (unsigned long long)ssi_req->ivgen_dma_addr[2],
+			      ssi_req->ivgen_dma_addr[0],
+			      ssi_req->ivgen_dma_addr[1],
+			      ssi_req->ivgen_dma_addr[2],
 			      ssi_req->ivgen_size);
 
 		/* Acquire IV from pool */
-- 
2.1.4
