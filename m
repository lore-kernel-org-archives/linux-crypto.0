From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 07/14] staging: ccree: remove comparisons to NULL
Date: Tue, 27 Jun 2017 10:27:19 +0300
Message-ID: <1498548449-10803-8-git-send-email-gilad@benyossef.com>
References: <1498548449-10803-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1498548449-10803-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Remove explicit comparisons to NULL in ccree driver.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c        | 34 ++++++++++++-------------
 drivers/staging/ccree/ssi_buffer_mgr.c  | 44 ++++++++++++++++-----------------
 drivers/staging/ccree/ssi_cipher.c      | 12 ++++-----
 drivers/staging/ccree/ssi_driver.c      | 20 +++++++--------
 drivers/staging/ccree/ssi_fips.c        |  4 +--
 drivers/staging/ccree/ssi_fips_ext.c    |  4 +--
 drivers/staging/ccree/ssi_fips_local.c  | 10 ++++----
 drivers/staging/ccree/ssi_hash.c        | 12 ++++-----
 drivers/staging/ccree/ssi_ivgen.c       |  4 +--
 drivers/staging/ccree/ssi_request_mgr.c |  8 +++---
 drivers/staging/ccree/ssi_sram_mgr.c    |  2 +-
 drivers/staging/ccree/ssi_sysfs.c       |  2 +-
 12 files changed, 78 insertions(+), 78 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index fdb257d..53105dd 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -98,7 +98,7 @@ static void ssi_aead_exit(struct crypto_aead *tfm)
 
 	dev = &ctx->drvdata->plat_dev->dev;
 	/* Unmap enckey buffer */
-	if (ctx->enckey != NULL) {
+	if (ctx->enckey) {
 		dma_free_coherent(dev, AES_MAX_KEY_SIZE, ctx->enckey, ctx->enckey_dma_addr);
 		SSI_LOG_DEBUG("Freed enckey DMA buffer enckey_dma_addr=0x%llX\n",
 			(unsigned long long)ctx->enckey_dma_addr);
@@ -107,7 +107,7 @@ static void ssi_aead_exit(struct crypto_aead *tfm)
 	}
 
 	if (ctx->auth_mode == DRV_HASH_XCBC_MAC) { /* XCBC authetication */
-		if (ctx->auth_state.xcbc.xcbc_keys != NULL) {
+		if (ctx->auth_state.xcbc.xcbc_keys) {
 			dma_free_coherent(dev, CC_AES_128_BIT_KEY_SIZE * 3,
 				ctx->auth_state.xcbc.xcbc_keys,
 				ctx->auth_state.xcbc.xcbc_keys_dma_addr);
@@ -117,7 +117,7 @@ static void ssi_aead_exit(struct crypto_aead *tfm)
 		ctx->auth_state.xcbc.xcbc_keys_dma_addr = 0;
 		ctx->auth_state.xcbc.xcbc_keys = NULL;
 	} else if (ctx->auth_mode != DRV_HASH_NULL) { /* HMAC auth. */
-		if (ctx->auth_state.hmac.ipad_opad != NULL) {
+		if (ctx->auth_state.hmac.ipad_opad) {
 			dma_free_coherent(dev, 2 * MAX_HMAC_DIGEST_SIZE,
 				ctx->auth_state.hmac.ipad_opad,
 				ctx->auth_state.hmac.ipad_opad_dma_addr);
@@ -126,7 +126,7 @@ static void ssi_aead_exit(struct crypto_aead *tfm)
 			ctx->auth_state.hmac.ipad_opad_dma_addr = 0;
 			ctx->auth_state.hmac.ipad_opad = NULL;
 		}
-		if (ctx->auth_state.hmac.padded_authkey != NULL) {
+		if (ctx->auth_state.hmac.padded_authkey) {
 			dma_free_coherent(dev, MAX_HMAC_BLOCK_SIZE,
 				ctx->auth_state.hmac.padded_authkey,
 				ctx->auth_state.hmac.padded_authkey_dma_addr);
@@ -160,7 +160,7 @@ static int ssi_aead_init(struct crypto_aead *tfm)
 	/* Allocate key buffer, cache line aligned */
 	ctx->enckey = dma_alloc_coherent(dev, AES_MAX_KEY_SIZE,
 		&ctx->enckey_dma_addr, GFP_KERNEL);
-	if (ctx->enckey == NULL) {
+	if (!ctx->enckey) {
 		SSI_LOG_ERR("Failed allocating key buffer\n");
 		goto init_failed;
 	}
@@ -174,7 +174,7 @@ static int ssi_aead_init(struct crypto_aead *tfm)
 		ctx->auth_state.xcbc.xcbc_keys = dma_alloc_coherent(dev,
 			CC_AES_128_BIT_KEY_SIZE * 3,
 			&ctx->auth_state.xcbc.xcbc_keys_dma_addr, GFP_KERNEL);
-		if (ctx->auth_state.xcbc.xcbc_keys == NULL) {
+		if (!ctx->auth_state.xcbc.xcbc_keys) {
 			SSI_LOG_ERR("Failed allocating buffer for XCBC keys\n");
 			goto init_failed;
 		}
@@ -183,7 +183,7 @@ static int ssi_aead_init(struct crypto_aead *tfm)
 		ctx->auth_state.hmac.ipad_opad = dma_alloc_coherent(dev,
 			2 * MAX_HMAC_DIGEST_SIZE,
 			&ctx->auth_state.hmac.ipad_opad_dma_addr, GFP_KERNEL);
-		if (ctx->auth_state.hmac.ipad_opad == NULL) {
+		if (!ctx->auth_state.hmac.ipad_opad) {
 			SSI_LOG_ERR("Failed allocating IPAD/OPAD buffer\n");
 			goto init_failed;
 		}
@@ -193,7 +193,7 @@ static int ssi_aead_init(struct crypto_aead *tfm)
 		ctx->auth_state.hmac.padded_authkey = dma_alloc_coherent(dev,
 			MAX_HMAC_BLOCK_SIZE,
 			&ctx->auth_state.hmac.padded_authkey_dma_addr, GFP_KERNEL);
-		if (ctx->auth_state.hmac.padded_authkey == NULL) {
+		if (!ctx->auth_state.hmac.padded_authkey) {
 			SSI_LOG_ERR("failed to allocate padded_authkey\n");
 			goto init_failed;
 		}
@@ -242,7 +242,7 @@ static void ssi_aead_complete(struct device *dev, void *ssi_req, void __iomem *c
 				areq->cryptlen + areq_ctx->dstOffset + ctx->authsize, SSI_SG_FROM_BUF);
 
 		/* If an IV was generated, copy it back to the user provided buffer. */
-		if (areq_ctx->backup_giv != NULL) {
+		if (areq_ctx->backup_giv) {
 			if (ctx->cipher_mode == DRV_CIPHER_CTR)
 				memcpy(areq_ctx->backup_giv, areq_ctx->ctr_iv + CTR_RFC3686_NONCE_SIZE, CTR_RFC3686_IV_SIZE);
 			else if (ctx->cipher_mode == DRV_CIPHER_CCM)
@@ -1848,7 +1848,7 @@ static inline void ssi_aead_dump_gcm(
 	if (ctx->cipher_mode != DRV_CIPHER_GCTR)
 		return;
 
-	if (title != NULL) {
+	if (title) {
 		SSI_LOG_DEBUG("----------------------------------------------------------------------------------");
 		SSI_LOG_DEBUG("%s\n", title);
 	}
@@ -1856,7 +1856,7 @@ static inline void ssi_aead_dump_gcm(
 	SSI_LOG_DEBUG("cipher_mode %d, authsize %d, enc_keylen %d, assoclen %d, cryptlen %d\n", \
 				 ctx->cipher_mode, ctx->authsize, ctx->enc_keylen, req->assoclen, req_ctx->cryptlen);
 
-	if (ctx->enckey != NULL)
+	if (ctx->enckey)
 		dump_byte_array("mac key", ctx->enckey, 16);
 
 	dump_byte_array("req->iv", req->iv, AES_BLOCK_SIZE);
@@ -1871,10 +1871,10 @@ static inline void ssi_aead_dump_gcm(
 
 	dump_byte_array("gcm_len_block", req_ctx->gcm_len_block.lenA, AES_BLOCK_SIZE);
 
-	if (req->src != NULL && req->cryptlen)
+	if (req->src && req->cryptlen)
 		dump_byte_array("req->src", sg_virt(req->src), req->cryptlen + req->assoclen);
 
-	if (req->dst != NULL)
+	if (req->dst)
 		dump_byte_array("req->dst", sg_virt(req->dst), req->cryptlen + ctx->authsize + req->assoclen);
 }
 #endif
@@ -1981,7 +1981,7 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 		 * CTR key to first 4 bytes in CTR IV
 		 */
 		memcpy(areq_ctx->ctr_iv, ctx->ctr_nonce, CTR_RFC3686_NONCE_SIZE);
-		if (areq_ctx->backup_giv == NULL) /*User none-generated IV*/
+		if (!areq_ctx->backup_giv) /*User none-generated IV*/
 			memcpy(areq_ctx->ctr_iv + CTR_RFC3686_NONCE_SIZE,
 				req->iv, CTR_RFC3686_IV_SIZE);
 		/* Initialize counter portion of counter block */
@@ -2033,7 +2033,7 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 	}
 
 	/* do we need to generate IV? */
-	if (areq_ctx->backup_giv != NULL) {
+	if (areq_ctx->backup_giv) {
 		/* set the DMA mapped IV address*/
 		if (ctx->cipher_mode == DRV_CIPHER_CTR) {
 			ssi_req.ivgen_dma_addr[0] = areq_ctx->gen_ctx.iv_dma_addr + CTR_RFC3686_NONCE_SIZE;
@@ -2685,7 +2685,7 @@ int ssi_aead_free(struct ssi_drvdata *drvdata)
 	struct ssi_aead_handle *aead_handle =
 		(struct ssi_aead_handle *)drvdata->aead_handle;
 
-	if (aead_handle != NULL) {
+	if (aead_handle) {
 		/* Remove registered algs */
 		list_for_each_entry_safe(t_alg, n, &aead_handle->aead_list, entry) {
 			crypto_unregister_aead(&t_alg->aead_alg);
@@ -2707,7 +2707,7 @@ int ssi_aead_alloc(struct ssi_drvdata *drvdata)
 	int alg;
 
 	aead_handle = kmalloc(sizeof(struct ssi_aead_handle), GFP_KERNEL);
-	if (aead_handle == NULL) {
+	if (!aead_handle) {
 		rc = -ENOMEM;
 		goto fail0;
 	}
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index f9720fc..e060ea1 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -94,7 +94,7 @@ static unsigned int ssi_buffer_mgr_get_sgl_nents(
 			sg_list = sg_next(sg_list);
 		} else {
 			sg_list = (struct scatterlist *)sg_page(sg_list);
-			if (is_chained != NULL)
+			if (is_chained)
 				*is_chained = true;
 		}
 	}
@@ -113,7 +113,7 @@ void ssi_buffer_mgr_zero_sgl(struct scatterlist *sgl, u32 data_len)
 	int sg_index = 0;
 
 	while (sg_index <= data_len) {
-		if (current_sg == NULL) {
+		if (!current_sg) {
 			/* reached the end of the sgl --> just return back */
 			return;
 		}
@@ -190,7 +190,7 @@ static inline int ssi_buffer_mgr_render_scatterlist_to_mlli(
 	u32 *mlli_entry_p = *mlli_entry_pp;
 	s32 rc = 0;
 
-	for ( ; (curr_sgl != NULL) && (sgl_data_len != 0);
+	for ( ; (curr_sgl) && (sgl_data_len != 0);
 	      curr_sgl = sg_next(curr_sgl)) {
 		u32 entry_data_len =
 			(sgl_data_len > sg_dma_len(curr_sgl) - sglOffset) ?
@@ -223,7 +223,7 @@ static int ssi_buffer_mgr_generate_mlli(
 	mlli_params->mlli_virt_addr = dma_pool_alloc(
 			mlli_params->curr_pool, GFP_KERNEL,
 			&(mlli_params->mlli_dma_addr));
-	if (unlikely(mlli_params->mlli_virt_addr == NULL)) {
+	if (unlikely(!mlli_params->mlli_virt_addr)) {
 		SSI_LOG_ERR("dma_pool_alloc() failed\n");
 		rc = -ENOMEM;
 		goto build_mlli_exit;
@@ -246,7 +246,7 @@ static int ssi_buffer_mgr_generate_mlli(
 			return rc;
 
 		/* set last bit in the current table */
-		if (sg_data->mlli_nents[i] != NULL) {
+		if (sg_data->mlli_nents[i]) {
 			/*Calculate the current MLLI table length for the
 			 *length field in the descriptor
 			 */
@@ -286,7 +286,7 @@ static inline void ssi_buffer_mgr_add_buffer_entry(
 	sgl_data->type[index] = DMA_BUFF_TYPE;
 	sgl_data->is_last[index] = is_last_entry;
 	sgl_data->mlli_nents[index] = mlli_nents;
-	if (sgl_data->mlli_nents[index] != NULL)
+	if (sgl_data->mlli_nents[index])
 		*sgl_data->mlli_nents[index] = 0;
 	sgl_data->num_of_buffers++;
 }
@@ -311,7 +311,7 @@ static inline void ssi_buffer_mgr_add_scatterlist_entry(
 	sgl_data->type[index] = DMA_SGL_TYPE;
 	sgl_data->is_last[index] = is_last_table;
 	sgl_data->mlli_nents[index] = mlli_nents;
-	if (sgl_data->mlli_nents[index] != NULL)
+	if (sgl_data->mlli_nents[index])
 		*sgl_data->mlli_nents[index] = 0;
 	sgl_data->num_of_buffers++;
 }
@@ -323,7 +323,7 @@ ssi_buffer_mgr_dma_map_sg(struct device *dev, struct scatterlist *sg, u32 nents,
 	u32 i, j;
 	struct scatterlist *l_sg = sg;
 	for (i = 0; i < nents; i++) {
-		if (l_sg == NULL)
+		if (!l_sg)
 			break;
 		if (unlikely(dma_map_sg(dev, l_sg, 1, direction) != 1)) {
 			SSI_LOG_ERR("dma_map_page() sg buffer failed\n");
@@ -336,7 +336,7 @@ ssi_buffer_mgr_dma_map_sg(struct device *dev, struct scatterlist *sg, u32 nents,
 err:
 	/* Restore mapped parts */
 	for (j = 0; j < i; j++) {
-		if (sg == NULL)
+		if (!sg)
 			break;
 		dma_unmap_sg(dev, sg, 1, direction);
 		sg = sg_next(sg);
@@ -672,7 +672,7 @@ void ssi_buffer_mgr_unmap_aead_request(
 	/*In case a pool was set, a table was
 	 *allocated and should be released
 	 */
-	if (areq_ctx->mlli_params.curr_pool != NULL) {
+	if (areq_ctx->mlli_params.curr_pool) {
 		SSI_LOG_DEBUG("free MLLI buffer: dma=0x%08llX virt=%pK\n",
 			(unsigned long long)areq_ctx->mlli_params.mlli_dma_addr,
 			areq_ctx->mlli_params.mlli_virt_addr);
@@ -731,12 +731,12 @@ static inline int ssi_buffer_mgr_get_aead_icv_nents(
 	}
 
 	for (i = 0 ; i < (sgl_nents - MAX_ICV_NENTS_SUPPORTED) ; i++) {
-		if (sgl == NULL)
+		if (!sgl)
 			break;
 		sgl = sg_next(sgl);
 	}
 
-	if (sgl != NULL)
+	if (sgl)
 		icv_max_size = sgl->length;
 
 	if (last_entry_data_size > authsize) {
@@ -773,7 +773,7 @@ static inline int ssi_buffer_mgr_aead_chain_iv(
 	struct device *dev = &drvdata->plat_dev->dev;
 	int rc = 0;
 
-	if (unlikely(req->iv == NULL)) {
+	if (unlikely(!req->iv)) {
 		areq_ctx->gen_ctx.iv_dma_addr = 0;
 		goto chain_iv_exit;
 	}
@@ -823,7 +823,7 @@ static inline int ssi_buffer_mgr_aead_chain_assoc(
 	if (areq_ctx->is_gcm4543)
 		size_of_assoc += crypto_aead_ivsize(tfm);
 
-	if (sg_data == NULL) {
+	if (!sg_data) {
 		rc = -EINVAL;
 		goto chain_assoc_exit;
 	}
@@ -847,7 +847,7 @@ static inline int ssi_buffer_mgr_aead_chain_assoc(
 		while (sg_index <= size_of_assoc) {
 			current_sg = sg_next(current_sg);
 			//if have reached the end of the sgl, then this is unexpected
-			if (current_sg == NULL) {
+			if (!current_sg) {
 				SSI_LOG_ERR("reached end of sg list. unexpected\n");
 				BUG();
 			}
@@ -1108,7 +1108,7 @@ static inline int ssi_buffer_mgr_aead_chain_data(
 
 	offset = size_to_skip;
 
-	if (sg_data == NULL) {
+	if (!sg_data) {
 		rc = -EINVAL;
 		goto chain_data_exit;
 	}
@@ -1126,7 +1126,7 @@ static inline int ssi_buffer_mgr_aead_chain_data(
 		offset -= areq_ctx->srcSgl->length;
 		areq_ctx->srcSgl = sg_next(areq_ctx->srcSgl);
 		//if have reached the end of the sgl, then this is unexpected
-		if (areq_ctx->srcSgl == NULL) {
+		if (!areq_ctx->srcSgl) {
 			SSI_LOG_ERR("reached end of sg list. unexpected\n");
 			BUG();
 		}
@@ -1169,7 +1169,7 @@ static inline int ssi_buffer_mgr_aead_chain_data(
 		offset -= areq_ctx->dstSgl->length;
 		areq_ctx->dstSgl = sg_next(areq_ctx->dstSgl);
 		//if have reached the end of the sgl, then this is unexpected
-		if (areq_ctx->dstSgl == NULL) {
+		if (!areq_ctx->dstSgl) {
 			SSI_LOG_ERR("reached end of sg list. unexpected\n");
 			BUG();
 		}
@@ -1685,7 +1685,7 @@ void ssi_buffer_mgr_unmap_hash_request(
 	/*In case a pool was set, a table was
 	 *allocated and should be released
 	 */
-	if (areq_ctx->mlli_params.curr_pool != NULL) {
+	if (areq_ctx->mlli_params.curr_pool) {
 		SSI_LOG_DEBUG("free MLLI buffer: dma=0x%llX virt=%pK\n",
 			     (unsigned long long)areq_ctx->mlli_params.mlli_dma_addr,
 			     areq_ctx->mlli_params.mlli_virt_addr);
@@ -1726,7 +1726,7 @@ int ssi_buffer_mgr_init(struct ssi_drvdata *drvdata)
 
 	buff_mgr_handle = (struct buff_mgr_handle *)
 		kmalloc(sizeof(struct buff_mgr_handle), GFP_KERNEL);
-	if (buff_mgr_handle == NULL)
+	if (!buff_mgr_handle)
 		return -ENOMEM;
 
 	drvdata->buff_mgr_handle = buff_mgr_handle;
@@ -1737,7 +1737,7 @@ int ssi_buffer_mgr_init(struct ssi_drvdata *drvdata)
 				LLI_ENTRY_BYTE_SIZE,
 				MLLI_TABLE_MIN_ALIGNMENT, 0);
 
-	if (unlikely(buff_mgr_handle->mlli_buffs_pool == NULL))
+	if (unlikely(!buff_mgr_handle->mlli_buffs_pool))
 		goto error;
 
 	return 0;
@@ -1751,7 +1751,7 @@ int ssi_buffer_mgr_fini(struct ssi_drvdata *drvdata)
 {
 	struct buff_mgr_handle *buff_mgr_handle = drvdata->buff_mgr_handle;
 
-	if (buff_mgr_handle  != NULL) {
+	if (buff_mgr_handle) {
 		dma_pool_destroy(buff_mgr_handle->mlli_buffs_pool);
 		kfree(drvdata->buff_mgr_handle);
 		drvdata->buff_mgr_handle = NULL;
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 88ed777..1baa215 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -653,7 +653,7 @@ ssi_blkcipher_create_data_desc(
 			     nbytes, NS_BIT);
 		set_dout_dlli(&desc[*seq_size], sg_dma_address(dst),
 			      nbytes, NS_BIT, (!areq ? 0 : 1));
-		if (areq != NULL)
+		if (areq)
 			set_queue_last_ind(&desc[*seq_size]);
 
 		set_flow_mode(&desc[*seq_size], flow_mode);
@@ -702,7 +702,7 @@ ssi_blkcipher_create_data_desc(
 				      req_ctx->out_mlli_nents, NS_BIT,
 				      (!areq ? 0 : 1));
 		}
-		if (areq != NULL)
+		if (areq)
 			set_queue_last_ind(&desc[*seq_size]);
 
 		set_flow_mode(&desc[*seq_size], flow_mode);
@@ -829,8 +829,8 @@ static int ssi_blkcipher_process(
 
 	/* STAT_PHASE_3: Lock HW and push sequence */
 
-	rc = send_request(ctx_p->drvdata, &ssi_req, desc, seq_len, (areq == NULL) ? 0 : 1);
-	if (areq != NULL) {
+	rc = send_request(ctx_p->drvdata, &ssi_req, desc, seq_len, (!areq) ? 0 : 1);
+	if (areq) {
 		if (unlikely(rc != -EINPROGRESS)) {
 			/* Failed to send the request or request completed synchronously */
 			ssi_buffer_mgr_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
@@ -1292,7 +1292,7 @@ int ssi_ablkcipher_free(struct ssi_drvdata *drvdata)
 	struct device *dev;
 	dev = &drvdata->plat_dev->dev;
 
-	if (blkcipher_handle != NULL) {
+	if (blkcipher_handle) {
 		/* Remove registered algs */
 		list_for_each_entry_safe(t_alg, n,
 				&blkcipher_handle->blkcipher_alg_list,
@@ -1318,7 +1318,7 @@ int ssi_ablkcipher_alloc(struct ssi_drvdata *drvdata)
 
 	ablkcipher_handle = kmalloc(sizeof(struct ssi_blkcipher_handle),
 		GFP_KERNEL);
-	if (ablkcipher_handle == NULL)
+	if (!ablkcipher_handle)
 		return -ENOMEM;
 
 	drvdata->blkcipher_handle = ablkcipher_handle;
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 330d24d..5c1d295 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -81,7 +81,7 @@ void dump_byte_array(const char *name, const u8 *the_array, unsigned long size)
 	const u8 *cur_byte;
 	char line_buf[80];
 
-	if (the_array == NULL) {
+	if (!the_array) {
 		SSI_LOG_ERR("cannot dump_byte_array - NULL pointer\n");
 		return;
 	}
@@ -231,7 +231,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	u32 signature_val;
 	int rc = 0;
 
-	if (unlikely(new_drvdata == NULL)) {
+	if (unlikely(!new_drvdata)) {
 		SSI_LOG_ERR("Failed to allocate drvdata");
 		rc = -ENOMEM;
 		goto init_cc_res_err;
@@ -247,7 +247,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	/* Get device resources */
 	/* First CC registers space */
 	new_drvdata->res_mem = platform_get_resource(plat_dev, IORESOURCE_MEM, 0);
-	if (unlikely(new_drvdata->res_mem == NULL)) {
+	if (unlikely(!new_drvdata->res_mem)) {
 		SSI_LOG_ERR("Failed getting IO memory resource\n");
 		rc = -ENODEV;
 		goto init_cc_res_err;
@@ -258,14 +258,14 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		(unsigned long long)new_drvdata->res_mem->end);
 	/* Map registers space */
 	req_mem_cc_regs = request_mem_region(new_drvdata->res_mem->start, resource_size(new_drvdata->res_mem), "arm_cc7x_regs");
-	if (unlikely(req_mem_cc_regs == NULL)) {
+	if (unlikely(!req_mem_cc_regs)) {
 		SSI_LOG_ERR("Couldn't allocate registers memory region at "
 			     "0x%08X\n", (unsigned int)new_drvdata->res_mem->start);
 		rc = -EBUSY;
 		goto init_cc_res_err;
 	}
 	cc_base = ioremap(new_drvdata->res_mem->start, resource_size(new_drvdata->res_mem));
-	if (unlikely(cc_base == NULL)) {
+	if (unlikely(!cc_base)) {
 		SSI_LOG_ERR("ioremap[CC](0x%08X,0x%08X) failed\n",
 			(unsigned int)new_drvdata->res_mem->start, (unsigned int)resource_size(new_drvdata->res_mem));
 		rc = -ENOMEM;
@@ -277,7 +277,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 
 	/* Then IRQ */
 	new_drvdata->res_irq = platform_get_resource(plat_dev, IORESOURCE_IRQ, 0);
-	if (unlikely(new_drvdata->res_irq == NULL)) {
+	if (unlikely(!new_drvdata->res_irq)) {
 		SSI_LOG_ERR("Failed getting IRQ resource\n");
 		rc = -ENODEV;
 		goto init_cc_res_err;
@@ -302,7 +302,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	if (rc)
 		goto init_cc_res_err;
 
-	if (new_drvdata->plat_dev->dev.dma_mask == NULL)
+	if (!new_drvdata->plat_dev->dev.dma_mask)
 	{
 		new_drvdata->plat_dev->dev.dma_mask = &new_drvdata->plat_dev->dev.coherent_dma_mask;
 	}
@@ -408,7 +408,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 init_cc_res_err:
 	SSI_LOG_ERR("Freeing CC HW resources!\n");
 
-	if (new_drvdata != NULL) {
+	if (new_drvdata) {
 		ssi_aead_free(new_drvdata);
 		ssi_hash_free(new_drvdata);
 		ssi_ablkcipher_free(new_drvdata);
@@ -422,7 +422,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		ssi_sysfs_fini();
 #endif
 
-		if (req_mem_cc_regs != NULL) {
+		if (req_mem_cc_regs) {
 			if (irq_registered) {
 				free_irq(new_drvdata->res_irq->start, new_drvdata);
 				new_drvdata->res_irq = NULL;
@@ -470,7 +470,7 @@ static void cleanup_cc_resources(struct platform_device *plat_dev)
 	free_irq(drvdata->res_irq->start, drvdata);
 	drvdata->res_irq = NULL;
 
-	if (drvdata->cc_base != NULL) {
+	if (drvdata->cc_base) {
 		iounmap(drvdata->cc_base);
 		release_mem_region(drvdata->res_mem->start,
 			resource_size(drvdata->res_mem));
diff --git a/drivers/staging/ccree/ssi_fips.c b/drivers/staging/ccree/ssi_fips.c
index 2e01a0a..2b8a616 100644
--- a/drivers/staging/ccree/ssi_fips.c
+++ b/drivers/staging/ccree/ssi_fips.c
@@ -34,7 +34,7 @@ int ssi_fips_get_state(ssi_fips_state_t *p_state)
 {
 	int rc = 0;
 
-	if (p_state == NULL)
+	if (!p_state)
 		return -EINVAL;
 
 	rc = ssi_fips_ext_get_state(p_state);
@@ -52,7 +52,7 @@ int ssi_fips_get_error(ssi_fips_error_t *p_err)
 {
 	int rc = 0;
 
-	if (p_err == NULL)
+	if (!p_err)
 		return -EINVAL;
 
 	rc = ssi_fips_ext_get_error(p_err);
diff --git a/drivers/staging/ccree/ssi_fips_ext.c b/drivers/staging/ccree/ssi_fips_ext.c
index 8b14061..b897c03 100644
--- a/drivers/staging/ccree/ssi_fips_ext.c
+++ b/drivers/staging/ccree/ssi_fips_ext.c
@@ -41,7 +41,7 @@ int ssi_fips_ext_get_state(ssi_fips_state_t *p_state)
 {
 	int rc = 0;
 
-	if (p_state == NULL)
+	if (!p_state)
 		return -EINVAL;
 
 	*p_state = fips_state;
@@ -59,7 +59,7 @@ int ssi_fips_ext_get_error(ssi_fips_error_t *p_err)
 {
 	int rc = 0;
 
-	if (p_err == NULL)
+	if (!p_err)
 		return -EINVAL;
 
 	*p_err = fips_error;
diff --git a/drivers/staging/ccree/ssi_fips_local.c b/drivers/staging/ccree/ssi_fips_local.c
index 84d458a1..c571b85 100644
--- a/drivers/staging/ccree/ssi_fips_local.c
+++ b/drivers/staging/ccree/ssi_fips_local.c
@@ -99,11 +99,11 @@ void ssi_fips_fini(struct ssi_drvdata *drvdata)
 {
 	struct ssi_fips_handle *fips_h = drvdata->fips_handle;
 
-	if (fips_h == NULL)
+	if (!fips_h)
 		return; /* Not allocated */
 
 #ifdef COMP_IN_WQ
-	if (fips_h->workq != NULL) {
+	if (fips_h->workq) {
 		flush_workqueue(fips_h->workq);
 		destroy_workqueue(fips_h->workq);
 	}
@@ -175,7 +175,7 @@ ssi_fips_error_t cc_fips_run_power_up_tests(struct ssi_drvdata *drvdata)
 	// the dma_handle is the returned phy address - use it in the HW descriptor
 	FIPS_DBG("dma_alloc_coherent \n");
 	cpu_addr_buffer = dma_alloc_coherent(dev, alloc_buff_size, &dma_handle, GFP_KERNEL);
-	if (cpu_addr_buffer == NULL)
+	if (!cpu_addr_buffer)
 		return CC_REE_FIPS_ERROR_GENERAL;
 
 	FIPS_DBG("allocated coherent buffer - addr 0x%08X , size = %d \n", (size_t)cpu_addr_buffer, alloc_buff_size);
@@ -303,7 +303,7 @@ int ssi_fips_init(struct ssi_drvdata *p_drvdata)
 	FIPS_DBG("CC FIPS code ..  (fips=%d) \n", ssi_fips_support);
 
 	fips_h = kzalloc(sizeof(struct ssi_fips_handle), GFP_KERNEL);
-	if (fips_h == NULL) {
+	if (!fips_h) {
 		ssi_fips_set_error(p_drvdata, CC_REE_FIPS_ERROR_GENERAL);
 		return -ENOMEM;
 	}
@@ -313,7 +313,7 @@ int ssi_fips_init(struct ssi_drvdata *p_drvdata)
 #ifdef COMP_IN_WQ
 	SSI_LOG_DEBUG("Initializing fips workqueue\n");
 	fips_h->workq = create_singlethread_workqueue("arm_cc7x_fips_wq");
-	if (unlikely(fips_h->workq == NULL)) {
+	if (unlikely(!fips_h->workq)) {
 		SSI_LOG_ERR("Failed creating fips work queue\n");
 		ssi_fips_set_error(p_drvdata, CC_REE_FIPS_ERROR_GENERAL);
 		rc = -ENOMEM;
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 265df94..7a70d87 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -297,17 +297,17 @@ static int ssi_hash_map_request(struct device *dev,
 fail1:
 	 kfree(state->digest_buff);
 fail_digest_result_buff:
-	 if (state->digest_result_buff != NULL) {
+	 if (state->digest_result_buff) {
 		 kfree(state->digest_result_buff);
 	     state->digest_result_buff = NULL;
 	 }
 fail_buff1:
-	 if (state->buff1 != NULL) {
+	 if (state->buff1) {
 		 kfree(state->buff1);
 	     state->buff1 = NULL;
 	 }
 fail_buff0:
-	 if (state->buff0 != NULL) {
+	 if (state->buff0) {
 		 kfree(state->buff0);
 	     state->buff0 = NULL;
 	 }
@@ -2249,7 +2249,7 @@ int ssi_hash_alloc(struct ssi_drvdata *drvdata)
 	int alg;
 
 	hash_handle = kzalloc(sizeof(struct ssi_hash_handle), GFP_KERNEL);
-	if (hash_handle == NULL) {
+	if (!hash_handle) {
 		SSI_LOG_ERR("kzalloc failed to allocate %zu B\n",
 			sizeof(struct ssi_hash_handle));
 		rc = -ENOMEM;
@@ -2343,7 +2343,7 @@ int ssi_hash_alloc(struct ssi_drvdata *drvdata)
 
 fail:
 
-	if (drvdata->hash_handle != NULL) {
+	if (drvdata->hash_handle) {
 		kfree(drvdata->hash_handle);
 		drvdata->hash_handle = NULL;
 	}
@@ -2355,7 +2355,7 @@ int ssi_hash_free(struct ssi_drvdata *drvdata)
 	struct ssi_hash_alg *t_hash_alg, *hash_n;
 	struct ssi_hash_handle *hash_handle = drvdata->hash_handle;
 
-	if (hash_handle != NULL) {
+	if (hash_handle) {
 		list_for_each_entry_safe(t_hash_alg, hash_n, &hash_handle->hash_list, entry) {
 			crypto_unregister_ahash(&t_hash_alg->ahash_alg);
 			list_del(&t_hash_alg->entry);
diff --git a/drivers/staging/ccree/ssi_ivgen.c b/drivers/staging/ccree/ssi_ivgen.c
index d81bf68..a275151 100644
--- a/drivers/staging/ccree/ssi_ivgen.c
+++ b/drivers/staging/ccree/ssi_ivgen.c
@@ -160,10 +160,10 @@ void ssi_ivgen_fini(struct ssi_drvdata *drvdata)
 	struct ssi_ivgen_ctx *ivgen_ctx = drvdata->ivgen_handle;
 	struct device *device = &(drvdata->plat_dev->dev);
 
-	if (ivgen_ctx == NULL)
+	if (!ivgen_ctx)
 		return;
 
-	if (ivgen_ctx->pool_meta != NULL) {
+	if (ivgen_ctx->pool_meta) {
 		memset(ivgen_ctx->pool_meta, 0, SSI_IVPOOL_META_SIZE);
 		dma_free_coherent(device, SSI_IVPOOL_META_SIZE,
 			ivgen_ctx->pool_meta, ivgen_ctx->pool_meta_dma);
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index 2a39c12..ecd4a8b 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -71,7 +71,7 @@ void request_mgr_fini(struct ssi_drvdata *drvdata)
 {
 	struct ssi_request_mgr_handle *req_mgr_h = drvdata->request_mgr_handle;
 
-	if (req_mgr_h == NULL)
+	if (!req_mgr_h)
 		return; /* Not allocated */
 
 	if (req_mgr_h->dummy_comp_buff_dma != 0) {
@@ -102,7 +102,7 @@ int request_mgr_init(struct ssi_drvdata *drvdata)
 	int rc = 0;
 
 	req_mgr_h = kzalloc(sizeof(struct ssi_request_mgr_handle), GFP_KERNEL);
-	if (req_mgr_h == NULL) {
+	if (!req_mgr_h) {
 		rc = -ENOMEM;
 		goto req_mgr_init_err;
 	}
@@ -113,7 +113,7 @@ int request_mgr_init(struct ssi_drvdata *drvdata)
 #ifdef COMP_IN_WQ
 	SSI_LOG_DEBUG("Initializing completion workqueue\n");
 	req_mgr_h->workq = create_singlethread_workqueue("arm_cc7x_wq");
-	if (unlikely(req_mgr_h->workq == NULL)) {
+	if (unlikely(!req_mgr_h->workq)) {
 		SSI_LOG_ERR("Failed creating work queue\n");
 		rc = -ENOMEM;
 		goto req_mgr_init_err;
@@ -484,7 +484,7 @@ static void proc_completions(struct ssi_drvdata *drvdata)
 		}
 #endif /* COMPLETION_DELAY */
 
-		if (likely(ssi_req->user_cb != NULL))
+		if (likely(ssi_req->user_cb))
 			ssi_req->user_cb(&plat_dev->dev, ssi_req->user_arg, drvdata->cc_base);
 		request_mgr_handle->req_queue_tail = (request_mgr_handle->req_queue_tail + 1) & (MAX_REQUEST_QUEUE_SIZE - 1);
 		SSI_LOG_DEBUG("Dequeue request tail=%u\n", request_mgr_handle->req_queue_tail);
diff --git a/drivers/staging/ccree/ssi_sram_mgr.c b/drivers/staging/ccree/ssi_sram_mgr.c
index c8ab55e..cf03df3 100644
--- a/drivers/staging/ccree/ssi_sram_mgr.c
+++ b/drivers/staging/ccree/ssi_sram_mgr.c
@@ -37,7 +37,7 @@ void ssi_sram_mgr_fini(struct ssi_drvdata *drvdata)
 	struct ssi_sram_mgr_ctx *smgr_ctx = drvdata->sram_mgr_handle;
 
 	/* Free "this" context */
-	if (smgr_ctx != NULL) {
+	if (smgr_ctx) {
 		memset(smgr_ctx, 0, sizeof(struct ssi_sram_mgr_ctx));
 		kfree(smgr_ctx);
 	}
diff --git a/drivers/staging/ccree/ssi_sysfs.c b/drivers/staging/ccree/ssi_sysfs.c
index 749ec36..8de4353 100644
--- a/drivers/staging/ccree/ssi_sysfs.c
+++ b/drivers/staging/ccree/ssi_sysfs.c
@@ -408,7 +408,7 @@ static void sys_free_dir(struct sys_dir *sys_dir)
 
 	kfree(sys_dir->sys_dir_attr_list);
 
-	if (sys_dir->sys_dir_kobj != NULL)
+	if (sys_dir->sys_dir_kobj)
 		kobject_put(sys_dir->sys_dir_kobj);
 }
 
-- 
2.1.4
