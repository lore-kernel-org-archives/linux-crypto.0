From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 04/14] staging: ccree: remove redundant blank lines
Date: Tue, 27 Jun 2017 10:27:16 +0300
Message-ID: <1498548449-10803-5-git-send-email-gilad@benyossef.com>
References: <1498548449-10803-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-crypto@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
 devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1498548449-10803-1-git-send-email-gilad@benyossef.com>
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

Remove redundant blank lines in brace blocks

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c        | 2 --
 drivers/staging/ccree/ssi_buffer_mgr.c  | 8 --------
 drivers/staging/ccree/ssi_cipher.c      | 5 -----
 drivers/staging/ccree/ssi_driver.c      | 1 -
 drivers/staging/ccree/ssi_hash.c        | 2 --
 drivers/staging/ccree/ssi_pm.c          | 1 -
 drivers/staging/ccree/ssi_request_mgr.c | 1 -
 7 files changed, 20 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 00375b6..5782c9d 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -2042,7 +2042,6 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 
 	/* do we need to generate IV? */
 	if (areq_ctx->backup_giv != NULL) {
-
 		/* set the DMA mapped IV address*/
 		if (ctx->cipher_mode == DRV_CIPHER_CTR) {
 			ssi_req.ivgen_dma_addr[0] = areq_ctx->gen_ctx.iv_dma_addr + CTR_RFC3686_NONCE_SIZE;
@@ -2181,7 +2180,6 @@ static int ssi_aead_decrypt(struct aead_request *req)
 		req->iv = areq_ctx->backup_iv;
 
 	return rc;
-
 }
 
 #if SSI_CC_HAS_AES_CCM
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 3c74ae3..63f057e 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -608,7 +608,6 @@ int ssi_buffer_mgr_map_blkcipher_request(
 		rc = ssi_buffer_mgr_generate_mlli(dev, &sg_data, mlli_params);
 		if (unlikely(rc != 0))
 			goto ablkcipher_exit;
-
 	}
 
 	SSI_LOG_DEBUG("areq_ctx->dma_buf_type = %s\n",
@@ -877,7 +876,6 @@ static inline int ssi_buffer_mgr_aead_chain_assoc(
 	if (areq_ctx->ccm_hdr_size != ccm_header_size_null) {
 		if (unlikely((mapped_nents + 1) >
 			LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES)) {
-
 			SSI_LOG_ERR("CCM case.Too many fragments. "
 				"Current %d max %d\n",
 				(areq_ctx->assoc.nents + 1),
@@ -895,7 +893,6 @@ static inline int ssi_buffer_mgr_aead_chain_assoc(
 
 	if (unlikely((do_chain) ||
 		(areq_ctx->assoc_buff_type == SSI_DMA_BUF_MLLI))) {
-
 		SSI_LOG_DEBUG("Chain assoc: buff_type=%s nents=%u\n",
 			GET_DMA_BUFFER_TYPE(areq_ctx->assoc_buff_type),
 			areq_ctx->assoc.nents);
@@ -1178,7 +1175,6 @@ static inline int ssi_buffer_mgr_aead_chain_data(
 
 	//check where the data starts
 	while (sg_index <= size_to_skip) {
-
 		offset -= areq_ctx->dstSgl->length;
 		areq_ctx->dstSgl = sg_next(areq_ctx->dstSgl);
 		//if have reached the end of the sgl, then this is unexpected
@@ -1450,7 +1446,6 @@ int ssi_buffer_mgr_map_aead_request(
 	if (unlikely(
 		(areq_ctx->assoc_buff_type == SSI_DMA_BUF_MLLI) ||
 		(areq_ctx->data_buff_type == SSI_DMA_BUF_MLLI))) {
-
 		mlli_params->curr_pool = buff_mgr->mlli_buffs_pool;
 		rc = ssi_buffer_mgr_generate_mlli(dev, &sg_data, mlli_params);
 		if (unlikely(rc != 0)) {
@@ -1528,7 +1523,6 @@ int ssi_buffer_mgr_map_hash_request_final(
 		} else {
 			areq_ctx->data_dma_buf_type = SSI_DMA_BUF_MLLI;
 		}
-
 	}
 
 	/*build mlli */
@@ -1675,7 +1669,6 @@ int ssi_buffer_mgr_map_hash_request_update(
 						  mlli_params) != 0)) {
 			goto fail_unmap_din;
 		}
-
 	}
 	areq_ctx->buff_index = (areq_ctx->buff_index ^ swap_index);
 
@@ -1771,7 +1764,6 @@ int ssi_buffer_mgr_fini(struct ssi_drvdata *drvdata)
 		dma_pool_destroy(buff_mgr_handle->mlli_buffs_pool);
 		kfree(drvdata->buff_mgr_handle);
 		drvdata->buff_mgr_handle = NULL;
-
 	}
 	return 0;
 }
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 1dab3e6..722b307 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -104,7 +104,6 @@ static int validate_keys_sizes(struct ssi_ablkcipher_ctx *ctx_p, u32 size) {
 #endif
 	default:
 		break;
-
 	}
 	return -EINVAL;
 }
@@ -158,7 +157,6 @@ static int validate_data_size(struct ssi_ablkcipher_ctx *ctx_p, unsigned int siz
 #endif /*SSI_CC_HAS_MULTI2*/
 	default:
 		break;
-
 	}
 	return -EINVAL;
 }
@@ -498,7 +496,6 @@ ssi_blkcipher_create_setup_desc(
 		set_cipher_mode(&desc[*seq_size], cipher_mode);
 		set_cipher_config0(&desc[*seq_size], direction);
 		if (flow_mode == S_DIN_to_AES) {
-
 			if (ssi_is_hw_key(tfm)) {
 				set_hw_crypto_key(&desc[*seq_size],
 						  ctx_p->hw.key1_slot);
@@ -616,7 +613,6 @@ static inline void ssi_blkcipher_create_multi2_setup_desc(
 	set_cipher_mode(&desc[*seq_size], ctx_p->cipher_mode);
 	set_setup_mode(&desc[*seq_size], SETUP_LOAD_STATE1);
 	(*seq_size)++;
-
 }
 #endif /*SSI_CC_HAS_MULTI2*/
 
@@ -782,7 +778,6 @@ static int ssi_blkcipher_process(
 	}
 	/*For CTS in case of data size aligned to 16 use CBC mode*/
 	if (((nbytes % AES_BLOCK_SIZE) == 0) && (ctx_p->cipher_mode == DRV_CIPHER_CBC_CTS)) {
-
 		ctx_p->cipher_mode = DRV_CIPHER_CBC;
 		cts_restore_flag = 1;
 	}
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 05930e8..3168930 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -444,7 +444,6 @@ void fini_cc_regs(struct ssi_drvdata *drvdata)
 	/* Mask all interrupts */
 	WRITE_REGISTER(drvdata->cc_base +
 		       CC_REG_OFFSET(HOST_RGF, HOST_IMR), 0xFFFFFFFF);
-
 }
 
 static void cleanup_cc_resources(struct platform_device *plat_dev)
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 64e969e..9d5e54d 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -1323,7 +1323,6 @@ static void ssi_hash_free_ctx(struct ssi_hash_ctx *ctx)
 	}
 
 	ctx->key_params.keylen = 0;
-
 }
 
 
@@ -2365,7 +2364,6 @@ int ssi_hash_free(struct ssi_drvdata *drvdata)
 	struct ssi_hash_handle *hash_handle = drvdata->hash_handle;
 
 	if (hash_handle != NULL) {
-
 		list_for_each_entry_safe(t_hash_alg, hash_n, &hash_handle->hash_list, entry) {
 			crypto_unregister_ahash(&t_hash_alg->ahash_alg);
 			list_del(&t_hash_alg->entry);
diff --git a/drivers/staging/ccree/ssi_pm.c b/drivers/staging/ccree/ssi_pm.c
index ae1f7f0..d3ddfb1 100644
--- a/drivers/staging/ccree/ssi_pm.c
+++ b/drivers/staging/ccree/ssi_pm.c
@@ -115,7 +115,6 @@ int ssi_power_mgr_runtime_put_suspend(struct device *dev)
 		BUG();
 	}
 	return rc;
-
 }
 
 #endif
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index 3176578..8f7d2ec 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -549,7 +549,6 @@ static void comp_handler(unsigned long devarg)
 			request_mgr_handle->axi_completed +=
 					cc_axi_comp_count(cc_base);
 		}
-
 	}
 	/* after verifing that there is nothing to do, Unmask AXI completion interrupt */
 	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IMR),
-- 
2.1.4
