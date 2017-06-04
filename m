From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 03/18] staging: ccree: remove 48 bit dma addr sim
Date: Sun,  4 Jun 2017 11:02:24 +0300
Message-ID: <1496563362-7954-4-git-send-email-gilad@benyossef.com>
References: <1496563362-7954-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 Joe Perches <joe@perches.com>, Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1496563362-7954-1-git-send-email-gilad@benyossef.com>
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

Remove no longer needed code used to simulate 48 bit dma addresses
on 32 bit platforms for development purposes.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c        | 19 --------
 drivers/staging/ccree/ssi_buffer_mgr.c  | 83 ---------------------------------
 drivers/staging/ccree/ssi_buffer_mgr.h  | 16 -------
 drivers/staging/ccree/ssi_cipher.c      |  4 --
 drivers/staging/ccree/ssi_hash.c        | 35 --------------
 drivers/staging/ccree/ssi_ivgen.c       |  3 --
 drivers/staging/ccree/ssi_request_mgr.c |  3 --
 7 files changed, 163 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index b0db815..a42bb49 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -99,7 +99,6 @@ static void ssi_aead_exit(struct crypto_aead *tfm)
 	dev = &ctx->drvdata->plat_dev->dev;
 	/* Unmap enckey buffer */
 	if (ctx->enckey != NULL) {
-		SSI_RESTORE_DMA_ADDR_TO_48BIT(ctx->enckey_dma_addr);
 		dma_free_coherent(dev, AES_MAX_KEY_SIZE, ctx->enckey, ctx->enckey_dma_addr);
 		SSI_LOG_DEBUG("Freed enckey DMA buffer enckey_dma_addr=0x%llX\n",
 			(unsigned long long)ctx->enckey_dma_addr);
@@ -109,8 +108,6 @@ static void ssi_aead_exit(struct crypto_aead *tfm)
 
 	if (ctx->auth_mode == DRV_HASH_XCBC_MAC) { /* XCBC authetication */
 		if (ctx->auth_state.xcbc.xcbc_keys != NULL) {
-			SSI_RESTORE_DMA_ADDR_TO_48BIT(
-				ctx->auth_state.xcbc.xcbc_keys_dma_addr);
 			dma_free_coherent(dev, CC_AES_128_BIT_KEY_SIZE * 3,
 				ctx->auth_state.xcbc.xcbc_keys,
 				ctx->auth_state.xcbc.xcbc_keys_dma_addr);
@@ -121,8 +118,6 @@ static void ssi_aead_exit(struct crypto_aead *tfm)
 		ctx->auth_state.xcbc.xcbc_keys = NULL;
 	} else if (ctx->auth_mode != DRV_HASH_NULL) { /* HMAC auth. */
 		if (ctx->auth_state.hmac.ipad_opad != NULL) {
-			SSI_RESTORE_DMA_ADDR_TO_48BIT(
-				ctx->auth_state.hmac.ipad_opad_dma_addr);
 			dma_free_coherent(dev, 2 * MAX_HMAC_DIGEST_SIZE,
 				ctx->auth_state.hmac.ipad_opad,
 				ctx->auth_state.hmac.ipad_opad_dma_addr);
@@ -132,8 +127,6 @@ static void ssi_aead_exit(struct crypto_aead *tfm)
 			ctx->auth_state.hmac.ipad_opad = NULL;
 		}
 		if (ctx->auth_state.hmac.padded_authkey != NULL) {
-			SSI_RESTORE_DMA_ADDR_TO_48BIT(
-				ctx->auth_state.hmac.padded_authkey_dma_addr);
 			dma_free_coherent(dev, MAX_HMAC_BLOCK_SIZE,
 				ctx->auth_state.hmac.padded_authkey,
 				ctx->auth_state.hmac.padded_authkey_dma_addr);
@@ -171,7 +164,6 @@ static int ssi_aead_init(struct crypto_aead *tfm)
 		SSI_LOG_ERR("Failed allocating key buffer\n");
 		goto init_failed;
 	}
-	SSI_UPDATE_DMA_ADDR_TO_48BIT(ctx->enckey_dma_addr, AES_MAX_KEY_SIZE);
 	SSI_LOG_DEBUG("Allocated enckey buffer in context ctx->enckey=@%p\n", ctx->enckey);
 
 	/* Set default authlen value */
@@ -186,9 +178,6 @@ static int ssi_aead_init(struct crypto_aead *tfm)
 			SSI_LOG_ERR("Failed allocating buffer for XCBC keys\n");
 			goto init_failed;
 		}
-		SSI_UPDATE_DMA_ADDR_TO_48BIT(
-			ctx->auth_state.xcbc.xcbc_keys_dma_addr,
-			CC_AES_128_BIT_KEY_SIZE * 3);
 	} else if (ctx->auth_mode != DRV_HASH_NULL) { /* HMAC authentication */
 		/* Allocate dma-coherent buffer for IPAD + OPAD */
 		ctx->auth_state.hmac.ipad_opad = dma_alloc_coherent(dev,
@@ -198,9 +187,6 @@ static int ssi_aead_init(struct crypto_aead *tfm)
 			SSI_LOG_ERR("Failed allocating IPAD/OPAD buffer\n");
 			goto init_failed;
 		}
-		SSI_UPDATE_DMA_ADDR_TO_48BIT(
-			ctx->auth_state.hmac.ipad_opad_dma_addr,
-			2 * MAX_HMAC_DIGEST_SIZE);
 		SSI_LOG_DEBUG("Allocated authkey buffer in context ctx->authkey=@%p\n",
 			ctx->auth_state.hmac.ipad_opad);
 
@@ -211,9 +197,6 @@ static int ssi_aead_init(struct crypto_aead *tfm)
 			SSI_LOG_ERR("failed to allocate padded_authkey\n");
 			goto init_failed;
 		}
-		SSI_UPDATE_DMA_ADDR_TO_48BIT(
-			ctx->auth_state.hmac.padded_authkey_dma_addr,
-			MAX_HMAC_BLOCK_SIZE);
 	} else {
 		ctx->auth_state.hmac.ipad_opad = NULL;
 		ctx->auth_state.hmac.padded_authkey = NULL;
@@ -465,7 +448,6 @@ ssi_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key, unsigned int keyl
 				   " DMA failed\n", key, keylen);
 			return -ENOMEM;
 		}
-		SSI_UPDATE_DMA_ADDR_TO_48BIT(key_dma_addr, keylen);
 		if (keylen > blocksize) {
 			/* Load hash initial state */
 			hw_desc_init(&desc[idx]);
@@ -548,7 +530,6 @@ ssi_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key, unsigned int keyl
 		SSI_LOG_ERR("send_request() failed (rc=%d)\n", rc);
 
 	if (likely(key_dma_addr != 0)) {
-		SSI_RESTORE_DMA_ADDR_TO_48BIT(key_dma_addr);
 		dma_unmap_single(dev, key_dma_addr, keylen, DMA_TO_DEVICE);
 	}
 
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index edb8844..f21dd26 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -95,54 +95,6 @@ struct buffer_array {
 	u32 * mlli_nents[MAX_NUM_OF_BUFFERS_IN_MLLI];
 };
 
-#ifdef CC_DMA_48BIT_SIM
-dma_addr_t ssi_buff_mgr_update_dma_addr(dma_addr_t orig_addr, u32 data_len)
-{
-	dma_addr_t tmp_dma_addr;
-#ifdef CC_DMA_48BIT_SIM_FULL
-	/* With this code all addresses will be switched to 48 bits. */
-	/* The if condition protects from double expention */
-	if((((orig_addr >> 16) & 0xFFFF) != 0xFFFF) &&
-		(data_len <= CC_MAX_MLLI_ENTRY_SIZE)) {
-#else
-	if((!(((orig_addr >> 16) & 0xFF) % 2)) &&
-		(data_len <= CC_MAX_MLLI_ENTRY_SIZE)) {
-#endif
-		tmp_dma_addr = ((orig_addr<<16) | 0xFFFF0000 |
-				(orig_addr & U16_MAX));
-			SSI_LOG_DEBUG("MAP DMA: orig address=0x%llX "
-				    "dma_address=0x%llX\n",
-				     orig_addr, tmp_dma_addr);
-			return tmp_dma_addr;
-	}
-	return orig_addr;
-}
-
-dma_addr_t ssi_buff_mgr_restore_dma_addr(dma_addr_t orig_addr)
-{
-	dma_addr_t tmp_dma_addr;
-#ifdef CC_DMA_48BIT_SIM_FULL
-	/* With this code all addresses will be restored from 48 bits. */
-	/* The if condition protects from double restoring */
-	if((orig_addr >> 32) & 0xFFFF ) {
-#else
-	if(((orig_addr >> 32) & 0xFFFF) &&
-		!(((orig_addr >> 32) & 0xFF) % 2) ) {
-#endif
-		/*return high 16 bits*/
-		tmp_dma_addr = ((orig_addr >> 16));
-		/*clean the 0xFFFF in the lower bits (set in the add expansion)*/
-		tmp_dma_addr &= 0xFFFF0000;
-		/* Set the original 16 bits */
-		tmp_dma_addr |= (orig_addr & U16_MAX);
-		SSI_LOG_DEBUG("Release DMA: orig address=0x%llX "
-			     "dma_address=0x%llX\n",
-			     orig_addr, tmp_dma_addr);
-			return tmp_dma_addr;
-	}
-	return orig_addr;
-}
-#endif
 /**
  * ssi_buffer_mgr_get_sgl_nents() - Get scatterlist number of entries.
  *
@@ -234,20 +186,17 @@ static inline int ssi_buffer_mgr_render_buff_to_mlli(
 
 	/*handle buffer longer than 64 kbytes */
 	while (buff_size > CC_MAX_MLLI_ENTRY_SIZE ) {
-		SSI_UPDATE_DMA_ADDR_TO_48BIT(buff_dma, CC_MAX_MLLI_ENTRY_SIZE);
 		LLI_SET_ADDR(mlli_entry_p,buff_dma);
 		LLI_SET_SIZE(mlli_entry_p, CC_MAX_MLLI_ENTRY_SIZE);
 		SSI_LOG_DEBUG("entry[%d]: single_buff=0x%08X size=%08X\n",*curr_nents,
 			   mlli_entry_p[LLI_WORD0_OFFSET],
 			   mlli_entry_p[LLI_WORD1_OFFSET]);
-		SSI_RESTORE_DMA_ADDR_TO_48BIT(buff_dma);
 		buff_dma += CC_MAX_MLLI_ENTRY_SIZE;
 		buff_size -= CC_MAX_MLLI_ENTRY_SIZE;
 		mlli_entry_p = mlli_entry_p + 2;
 		(*curr_nents)++;
 	}
 	/*Last entry */
-	SSI_UPDATE_DMA_ADDR_TO_48BIT(buff_dma, buff_size);
 	LLI_SET_ADDR(mlli_entry_p,buff_dma);
 	LLI_SET_SIZE(mlli_entry_p, buff_size);
 	SSI_LOG_DEBUG("entry[%d]: single_buff=0x%08X size=%08X\n",*curr_nents,
@@ -306,9 +255,6 @@ static int ssi_buffer_mgr_generate_mlli(
 		rc =-ENOMEM;
 		goto build_mlli_exit;
 	}
-	SSI_UPDATE_DMA_ADDR_TO_48BIT(mlli_params->mlli_dma_addr,
-						(MAX_NUM_OF_TOTAL_MLLI_ENTRIES*
-						LLI_ENTRY_BYTE_SIZE));
 	/* Point to start of MLLI */
 	mlli_p = (u32 *)mlli_params->mlli_virt_addr;
 	/* go over all SG's and link it to one MLLI table */
@@ -452,7 +398,6 @@ static int ssi_buffer_mgr_map_scatterlist(
 		*lbytes = nbytes;
 		*nents = 1;
 		*mapped_nents = 1;
-		SSI_UPDATE_DMA_ADDR_TO_48BIT(sg_dma_address(sg), sg_dma_len(sg));
 	} else {  /*sg_is_last*/
 		*nents = ssi_buffer_mgr_get_sgl_nents(sg, nbytes, lbytes,
 						     &is_chained);
@@ -572,7 +517,6 @@ void ssi_buffer_mgr_unmap_blkcipher_request(
 		SSI_LOG_DEBUG("Unmapped iv: iv_dma_addr=0x%llX iv_size=%u\n",
 			(unsigned long long)req_ctx->gen_ctx.iv_dma_addr,
 			ivsize);
-		SSI_RESTORE_DMA_ADDR_TO_48BIT(req_ctx->gen_ctx.iv_dma_addr);
 		dma_unmap_single(dev, req_ctx->gen_ctx.iv_dma_addr,
 				 ivsize,
 				 req_ctx->is_giv ? DMA_BIDIRECTIONAL :
@@ -580,20 +524,17 @@ void ssi_buffer_mgr_unmap_blkcipher_request(
 	}
 	/* Release pool */
 	if (req_ctx->dma_buf_type == SSI_DMA_BUF_MLLI) {
-		SSI_RESTORE_DMA_ADDR_TO_48BIT(req_ctx->mlli_params.mlli_dma_addr);
 		dma_pool_free(req_ctx->mlli_params.curr_pool,
 			      req_ctx->mlli_params.mlli_virt_addr,
 			      req_ctx->mlli_params.mlli_dma_addr);
 	}
 
-	SSI_RESTORE_DMA_ADDR_TO_48BIT(sg_dma_address(src));
 	dma_unmap_sg(dev, src, req_ctx->in_nents,
 		DMA_BIDIRECTIONAL);
 	SSI_LOG_DEBUG("Unmapped req->src=%pK\n",
 		     sg_virt(src));
 
 	if (src != dst) {
-		SSI_RESTORE_DMA_ADDR_TO_48BIT(sg_dma_address(dst));
 		dma_unmap_sg(dev, dst, req_ctx->out_nents,
 			DMA_BIDIRECTIONAL);
 		SSI_LOG_DEBUG("Unmapped req->dst=%pK\n",
@@ -637,8 +578,6 @@ int ssi_buffer_mgr_map_blkcipher_request(
 				   "for DMA failed\n", ivsize, info);
 			return -ENOMEM;
 		}
-		SSI_UPDATE_DMA_ADDR_TO_48BIT(req_ctx->gen_ctx.iv_dma_addr,
-								ivsize);
 		SSI_LOG_DEBUG("Mapped iv %u B at va=%pK to dma=0x%llX\n",
 			ivsize, info,
 			(unsigned long long)req_ctx->gen_ctx.iv_dma_addr);
@@ -718,7 +657,6 @@ void ssi_buffer_mgr_unmap_aead_request(
 	u32 size_to_unmap = 0;
 
 	if (areq_ctx->mac_buf_dma_addr != 0) {
-		SSI_RESTORE_DMA_ADDR_TO_48BIT(areq_ctx->mac_buf_dma_addr);
 		dma_unmap_single(dev, areq_ctx->mac_buf_dma_addr,
 			MAX_MAC_SIZE, DMA_BIDIRECTIONAL);
 	}
@@ -726,25 +664,21 @@ void ssi_buffer_mgr_unmap_aead_request(
 #if SSI_CC_HAS_AES_GCM
 	if (areq_ctx->cipher_mode == DRV_CIPHER_GCTR) {
 		if (areq_ctx->hkey_dma_addr != 0) {
-			SSI_RESTORE_DMA_ADDR_TO_48BIT(areq_ctx->hkey_dma_addr);
 			dma_unmap_single(dev, areq_ctx->hkey_dma_addr,
 					 AES_BLOCK_SIZE, DMA_BIDIRECTIONAL);
 		}
 
 		if (areq_ctx->gcm_block_len_dma_addr != 0) {
-			SSI_RESTORE_DMA_ADDR_TO_48BIT(areq_ctx->gcm_block_len_dma_addr);
 			dma_unmap_single(dev, areq_ctx->gcm_block_len_dma_addr,
 					 AES_BLOCK_SIZE, DMA_TO_DEVICE);
 		}
 
 		if (areq_ctx->gcm_iv_inc1_dma_addr != 0) {
-			SSI_RESTORE_DMA_ADDR_TO_48BIT(areq_ctx->gcm_iv_inc1_dma_addr);
 			dma_unmap_single(dev, areq_ctx->gcm_iv_inc1_dma_addr,
 				AES_BLOCK_SIZE, DMA_TO_DEVICE);
 		}
 
 		if (areq_ctx->gcm_iv_inc2_dma_addr != 0) {
-			SSI_RESTORE_DMA_ADDR_TO_48BIT(areq_ctx->gcm_iv_inc2_dma_addr);
 			dma_unmap_single(dev, areq_ctx->gcm_iv_inc2_dma_addr,
 				AES_BLOCK_SIZE, DMA_TO_DEVICE);
 		}
@@ -753,7 +687,6 @@ void ssi_buffer_mgr_unmap_aead_request(
 
 	if (areq_ctx->ccm_hdr_size != ccm_header_size_null) {
 		if (areq_ctx->ccm_iv0_dma_addr != 0) {
-			SSI_RESTORE_DMA_ADDR_TO_48BIT(areq_ctx->ccm_iv0_dma_addr);
 			dma_unmap_single(dev, areq_ctx->ccm_iv0_dma_addr,
 				AES_BLOCK_SIZE, DMA_TO_DEVICE);
 		}
@@ -761,7 +694,6 @@ void ssi_buffer_mgr_unmap_aead_request(
 		dma_unmap_sg(dev, &areq_ctx->ccm_adata_sg, 1, DMA_TO_DEVICE);
 	}
 	if (areq_ctx->gen_ctx.iv_dma_addr != 0) {
-		SSI_RESTORE_DMA_ADDR_TO_48BIT(areq_ctx->gen_ctx.iv_dma_addr);
 		dma_unmap_single(dev, areq_ctx->gen_ctx.iv_dma_addr,
 				 hw_iv_size, DMA_BIDIRECTIONAL);
 	}
@@ -773,14 +705,12 @@ void ssi_buffer_mgr_unmap_aead_request(
 		SSI_LOG_DEBUG("free MLLI buffer: dma=0x%08llX virt=%pK\n",
 			(unsigned long long)areq_ctx->mlli_params.mlli_dma_addr,
 			areq_ctx->mlli_params.mlli_virt_addr);
-		SSI_RESTORE_DMA_ADDR_TO_48BIT(areq_ctx->mlli_params.mlli_dma_addr);
 		dma_pool_free(areq_ctx->mlli_params.curr_pool,
 			      areq_ctx->mlli_params.mlli_virt_addr,
 			      areq_ctx->mlli_params.mlli_dma_addr);
 	}
 
 	SSI_LOG_DEBUG("Unmapping src sgl: req->src=%pK areq_ctx->src.nents=%u areq_ctx->assoc.nents=%u assoclen:%u cryptlen=%u\n", sg_virt(req->src),areq_ctx->src.nents,areq_ctx->assoc.nents,req->assoclen,req->cryptlen);
-	SSI_RESTORE_DMA_ADDR_TO_48BIT(sg_dma_address(req->src));
 	size_to_unmap = req->assoclen+req->cryptlen;
 	if(areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_ENCRYPT){
 		size_to_unmap += areq_ctx->req_authsize;
@@ -792,7 +722,6 @@ void ssi_buffer_mgr_unmap_aead_request(
 	if (unlikely(req->src != req->dst)) {
 		SSI_LOG_DEBUG("Unmapping dst sgl: req->dst=%pK\n",
 			sg_virt(req->dst));
-		SSI_RESTORE_DMA_ADDR_TO_48BIT(sg_dma_address(req->dst));
 		dma_unmap_sg(dev, req->dst, ssi_buffer_mgr_get_sgl_nents(req->dst,size_to_unmap,&dummy,&chained),
 			DMA_BIDIRECTIONAL);
 	}
@@ -890,7 +819,6 @@ static inline int ssi_buffer_mgr_aead_chain_iv(
 		rc = -ENOMEM;
 		goto chain_iv_exit;
 	}
-	SSI_UPDATE_DMA_ADDR_TO_48BIT(areq_ctx->gen_ctx.iv_dma_addr, hw_iv_size);
 
 	SSI_LOG_DEBUG("Mapped iv %u B at va=%pK to dma=0x%llX\n",
 		hw_iv_size, req->iv,
@@ -1410,7 +1338,6 @@ int ssi_buffer_mgr_map_aead_request(
 		rc = -ENOMEM;
 		goto aead_map_failure;
 	}
-	SSI_UPDATE_DMA_ADDR_TO_48BIT(areq_ctx->mac_buf_dma_addr, MAX_MAC_SIZE);
 
 	if (areq_ctx->ccm_hdr_size != ccm_header_size_null) {
 		areq_ctx->ccm_iv0_dma_addr = dma_map_single(dev,
@@ -1425,8 +1352,6 @@ int ssi_buffer_mgr_map_aead_request(
 			rc = -ENOMEM;
 			goto aead_map_failure;
 		}
-		SSI_UPDATE_DMA_ADDR_TO_48BIT(areq_ctx->ccm_iv0_dma_addr,
-								AES_BLOCK_SIZE);
 		if (ssi_aead_handle_config_buf(dev, areq_ctx,
 			areq_ctx->ccm_config, &sg_data, req->assoclen) != 0) {
 			rc = -ENOMEM;
@@ -1444,7 +1369,6 @@ int ssi_buffer_mgr_map_aead_request(
 			rc = -ENOMEM;
 			goto aead_map_failure;
 		}
-		SSI_UPDATE_DMA_ADDR_TO_48BIT(areq_ctx->hkey_dma_addr, AES_BLOCK_SIZE);
 
 		areq_ctx->gcm_block_len_dma_addr = dma_map_single(dev,
 			&areq_ctx->gcm_len_block, AES_BLOCK_SIZE, DMA_TO_DEVICE);
@@ -1454,7 +1378,6 @@ int ssi_buffer_mgr_map_aead_request(
 			rc = -ENOMEM;
 			goto aead_map_failure;
 		}
-		SSI_UPDATE_DMA_ADDR_TO_48BIT(areq_ctx->gcm_block_len_dma_addr, AES_BLOCK_SIZE);
 
 		areq_ctx->gcm_iv_inc1_dma_addr = dma_map_single(dev,
 			areq_ctx->gcm_iv_inc1,
@@ -1468,8 +1391,6 @@ int ssi_buffer_mgr_map_aead_request(
 			rc = -ENOMEM;
 			goto aead_map_failure;
 		}
-		SSI_UPDATE_DMA_ADDR_TO_48BIT(areq_ctx->gcm_iv_inc1_dma_addr,
-								AES_BLOCK_SIZE);
 
 		areq_ctx->gcm_iv_inc2_dma_addr = dma_map_single(dev,
 			areq_ctx->gcm_iv_inc2,
@@ -1483,8 +1404,6 @@ int ssi_buffer_mgr_map_aead_request(
 			rc = -ENOMEM;
 			goto aead_map_failure;
 		}
-		SSI_UPDATE_DMA_ADDR_TO_48BIT(areq_ctx->gcm_iv_inc2_dma_addr,
-								AES_BLOCK_SIZE);
 	}
 #endif /*SSI_CC_HAS_AES_GCM*/
 
@@ -1809,7 +1728,6 @@ void ssi_buffer_mgr_unmap_hash_request(
 		SSI_LOG_DEBUG("free MLLI buffer: dma=0x%llX virt=%pK\n",
 			     (unsigned long long)areq_ctx->mlli_params.mlli_dma_addr,
 			     areq_ctx->mlli_params.mlli_virt_addr);
-		SSI_RESTORE_DMA_ADDR_TO_48BIT(areq_ctx->mlli_params.mlli_dma_addr);
 		dma_pool_free(areq_ctx->mlli_params.curr_pool,
 			      areq_ctx->mlli_params.mlli_virt_addr,
 			      areq_ctx->mlli_params.mlli_dma_addr);
@@ -1820,7 +1738,6 @@ void ssi_buffer_mgr_unmap_hash_request(
 			     sg_virt(src),
 			     (unsigned long long)sg_dma_address(src),
 			     sg_dma_len(src));
-		SSI_RESTORE_DMA_ADDR_TO_48BIT(sg_dma_address(src));
 		dma_unmap_sg(dev, src,
 			     areq_ctx->in_nents, DMA_TO_DEVICE);
 	}
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.h b/drivers/staging/ccree/ssi_buffer_mgr.h
index 98355dd..bb5f8dc 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.h
+++ b/drivers/staging/ccree/ssi_buffer_mgr.h
@@ -85,21 +85,5 @@ void ssi_buffer_mgr_copy_scatterlist_portion(u8 *dest, struct scatterlist *sg, u
 
 void ssi_buffer_mgr_zero_sgl(struct scatterlist *sgl, u32 data_len);
 
-
-#ifdef CC_DMA_48BIT_SIM
-dma_addr_t ssi_buff_mgr_update_dma_addr(dma_addr_t orig_addr, u32 data_len);
-dma_addr_t ssi_buff_mgr_restore_dma_addr(dma_addr_t orig_addr);
-
-#define SSI_UPDATE_DMA_ADDR_TO_48BIT(addr,size) addr = \
-					ssi_buff_mgr_update_dma_addr(addr,size)
-#define SSI_RESTORE_DMA_ADDR_TO_48BIT(addr) addr = \
-					ssi_buff_mgr_restore_dma_addr(addr)
-#else
-
-#define SSI_UPDATE_DMA_ADDR_TO_48BIT(addr,size) addr = addr
-#define SSI_RESTORE_DMA_ADDR_TO_48BIT(addr) addr = addr
-
-#endif
-
 #endif /*__BUFFER_MGR_H__*/
 
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 8f86fcd..56e441c 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -215,7 +215,6 @@ static int ssi_blkcipher_init(struct crypto_tfm *tfm)
 			max_key_buf_size, ctx_p->user.key);
 		return -ENOMEM;
 	}
-	SSI_UPDATE_DMA_ADDR_TO_48BIT(ctx_p->user.key_dma_addr, max_key_buf_size);
 	SSI_LOG_DEBUG("Mapped key %u B at va=%pK to dma=0x%llX\n",
 		max_key_buf_size, ctx_p->user.key,
 		(unsigned long long)ctx_p->user.key_dma_addr);
@@ -248,7 +247,6 @@ static void ssi_blkcipher_exit(struct crypto_tfm *tfm)
 	}
 
 	/* Unmap key buffer */
-	SSI_RESTORE_DMA_ADDR_TO_48BIT(ctx_p->user.key_dma_addr);
 	dma_unmap_single(dev, ctx_p->user.key_dma_addr, max_key_buf_size,
 								DMA_TO_DEVICE);
 	SSI_LOG_DEBUG("Unmapped key buffer key_dma_addr=0x%llX\n",
@@ -413,7 +411,6 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 
 	/* STAT_PHASE_1: Copy key to ctx */
 	START_CYCLE_COUNT();
-	SSI_RESTORE_DMA_ADDR_TO_48BIT(ctx_p->user.key_dma_addr);
 	dma_sync_single_for_cpu(dev, ctx_p->user.key_dma_addr,
 					max_key_buf_size, DMA_TO_DEVICE);
 #if SSI_CC_HAS_MULTI2
@@ -449,7 +446,6 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 	}
 	dma_sync_single_for_device(dev, ctx_p->user.key_dma_addr,
 					max_key_buf_size, DMA_TO_DEVICE);
-	SSI_UPDATE_DMA_ADDR_TO_48BIT(ctx_p->user.key_dma_addr ,max_key_buf_size);
 	ctx_p->keylen = keylen;
 
 	END_CYCLE_COUNT(STAT_OP_TYPE_SETKEY, STAT_PHASE_1);
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 8ab6b9e..66405e9 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -145,8 +145,6 @@ static int ssi_hash_map_result(struct device *dev,
 			digestsize);
 		return -ENOMEM;
 	}
-	SSI_UPDATE_DMA_ADDR_TO_48BIT(state->digest_result_dma_addr,
-						digestsize);
 	SSI_LOG_DEBUG("Mapped digest result buffer %u B "
 		     "at va=%pK to dma=0x%llX\n",
 		digestsize, state->digest_result_buff,
@@ -212,17 +210,12 @@ static int ssi_hash_map_request(struct device *dev,
 		ctx->inter_digestsize, state->digest_buff);
 		goto fail3;
 	}
-	SSI_UPDATE_DMA_ADDR_TO_48BIT(state->digest_buff_dma_addr,
-							ctx->inter_digestsize);
 	SSI_LOG_DEBUG("Mapped digest %d B at va=%pK to dma=0x%llX\n",
 		ctx->inter_digestsize, state->digest_buff,
 		(unsigned long long)state->digest_buff_dma_addr);
 
 	if (is_hmac) {
-		SSI_RESTORE_DMA_ADDR_TO_48BIT(ctx->digest_buff_dma_addr);
 		dma_sync_single_for_cpu(dev, ctx->digest_buff_dma_addr, ctx->inter_digestsize, DMA_BIDIRECTIONAL);
-		SSI_UPDATE_DMA_ADDR_TO_48BIT(ctx->digest_buff_dma_addr,
-							ctx->inter_digestsize);
 		if ((ctx->hw_mode == DRV_CIPHER_XCBC_MAC) || (ctx->hw_mode == DRV_CIPHER_CMAC)) {
 			memset(state->digest_buff, 0, ctx->inter_digestsize);
 		} else { /*sha*/
@@ -237,17 +230,11 @@ static int ssi_hash_map_request(struct device *dev,
 			memcpy(state->digest_bytes_len, digest_len_init, HASH_LEN_SIZE);
 #endif
 		}
-		SSI_RESTORE_DMA_ADDR_TO_48BIT(state->digest_buff_dma_addr);
 		dma_sync_single_for_device(dev, state->digest_buff_dma_addr, ctx->inter_digestsize, DMA_BIDIRECTIONAL);
-		SSI_UPDATE_DMA_ADDR_TO_48BIT(state->digest_buff_dma_addr,
-							ctx->inter_digestsize);
 
 		if (ctx->hash_mode != DRV_HASH_NULL) {
-			SSI_RESTORE_DMA_ADDR_TO_48BIT(ctx->opad_tmp_keys_dma_addr);
 			dma_sync_single_for_cpu(dev, ctx->opad_tmp_keys_dma_addr, ctx->inter_digestsize, DMA_BIDIRECTIONAL);
 			memcpy(state->opad_digest_buff, ctx->opad_tmp_keys_buff, ctx->inter_digestsize);
-			SSI_UPDATE_DMA_ADDR_TO_48BIT(ctx->opad_tmp_keys_dma_addr,
-							ctx->inter_digestsize);
 		}
 	} else { /*hash*/
 		/* Copy the initial digests if hash flow. The SRAM contains the
@@ -273,8 +260,6 @@ static int ssi_hash_map_request(struct device *dev,
 			HASH_LEN_SIZE, state->digest_bytes_len);
 			goto fail4;
 		}
-		SSI_UPDATE_DMA_ADDR_TO_48BIT(state->digest_bytes_len_dma_addr,
-								HASH_LEN_SIZE);
 		SSI_LOG_DEBUG("Mapped digest len %u B at va=%pK to dma=0x%llX\n",
 			HASH_LEN_SIZE, state->digest_bytes_len,
 			(unsigned long long)state->digest_bytes_len_dma_addr);
@@ -289,8 +274,6 @@ static int ssi_hash_map_request(struct device *dev,
 			ctx->inter_digestsize, state->opad_digest_buff);
 			goto fail5;
 		}
-		SSI_UPDATE_DMA_ADDR_TO_48BIT(state->opad_digest_dma_addr,
-							ctx->inter_digestsize);
 		SSI_LOG_DEBUG("Mapped opad digest %d B at va=%pK to dma=0x%llX\n",
 			ctx->inter_digestsize, state->opad_digest_buff,
 			(unsigned long long)state->opad_digest_dma_addr);
@@ -306,13 +289,11 @@ static int ssi_hash_map_request(struct device *dev,
 
 fail5:
 	if (state->digest_bytes_len_dma_addr != 0) {
-		SSI_RESTORE_DMA_ADDR_TO_48BIT(state->digest_bytes_len_dma_addr);
 		dma_unmap_single(dev, state->digest_bytes_len_dma_addr, HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
 		state->digest_bytes_len_dma_addr = 0;
 	}
 fail4:
 	if (state->digest_buff_dma_addr != 0) {
-		SSI_RESTORE_DMA_ADDR_TO_48BIT(state->digest_buff_dma_addr);
 		dma_unmap_single(dev, state->digest_buff_dma_addr, ctx->inter_digestsize, DMA_BIDIRECTIONAL);
 		state->digest_buff_dma_addr = 0;
 	}
@@ -346,7 +327,6 @@ static void ssi_hash_unmap_request(struct device *dev,
 				   struct ssi_hash_ctx *ctx)
 {
 	if (state->digest_buff_dma_addr != 0) {
-		SSI_RESTORE_DMA_ADDR_TO_48BIT(state->digest_buff_dma_addr);
 		dma_unmap_single(dev, state->digest_buff_dma_addr,
 				 ctx->inter_digestsize, DMA_BIDIRECTIONAL);
 		SSI_LOG_DEBUG("Unmapped digest-buffer: digest_buff_dma_addr=0x%llX\n",
@@ -354,7 +334,6 @@ static void ssi_hash_unmap_request(struct device *dev,
 		state->digest_buff_dma_addr = 0;
 	}
 	if (state->digest_bytes_len_dma_addr != 0) {
-		SSI_RESTORE_DMA_ADDR_TO_48BIT(state->digest_bytes_len_dma_addr);
 		dma_unmap_single(dev, state->digest_bytes_len_dma_addr,
 				 HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
 		SSI_LOG_DEBUG("Unmapped digest-bytes-len buffer: digest_bytes_len_dma_addr=0x%llX\n",
@@ -362,7 +341,6 @@ static void ssi_hash_unmap_request(struct device *dev,
 		state->digest_bytes_len_dma_addr = 0;
 	}
 	if (state->opad_digest_dma_addr != 0) {
-		SSI_RESTORE_DMA_ADDR_TO_48BIT(state->opad_digest_dma_addr);
 		dma_unmap_single(dev, state->opad_digest_dma_addr,
 				 ctx->inter_digestsize, DMA_BIDIRECTIONAL);
 		SSI_LOG_DEBUG("Unmapped opad-digest: opad_digest_dma_addr=0x%llX\n",
@@ -383,7 +361,6 @@ static void ssi_hash_unmap_result(struct device *dev,
 				  unsigned int digestsize, u8 *result)
 {
 	if (state->digest_result_dma_addr != 0) {
-		SSI_RESTORE_DMA_ADDR_TO_48BIT(state->digest_result_dma_addr);
 		dma_unmap_single(dev,
 				 state->digest_result_dma_addr,
 				 digestsize,
@@ -1081,7 +1058,6 @@ static int ssi_hash_setkey(void *hash,
 				   " DMA failed\n", key, keylen);
 			return -ENOMEM;
 		}
-		SSI_UPDATE_DMA_ADDR_TO_48BIT(ctx->key_params.key_dma_addr, keylen);
 		SSI_LOG_DEBUG("mapping key-buffer: key_dma_addr=0x%llX "
 			     "keylen=%u\n",
 			     (unsigned long long)ctx->key_params.key_dma_addr,
@@ -1229,7 +1205,6 @@ static int ssi_hash_setkey(void *hash,
 	}
 
 	if (ctx->key_params.key_dma_addr) {
-		SSI_RESTORE_DMA_ADDR_TO_48BIT(ctx->key_params.key_dma_addr);
 		dma_unmap_single(&ctx->drvdata->plat_dev->dev,
 				ctx->key_params.key_dma_addr,
 				ctx->key_params.keylen, DMA_TO_DEVICE);
@@ -1273,7 +1248,6 @@ static int ssi_xcbc_setkey(struct crypto_ahash *ahash,
 			   " DMA failed\n", key, keylen);
 		return -ENOMEM;
 	}
-	SSI_UPDATE_DMA_ADDR_TO_48BIT(ctx->key_params.key_dma_addr, keylen);
 	SSI_LOG_DEBUG("mapping key-buffer: key_dma_addr=0x%llX "
 		     "keylen=%u\n",
 		     (unsigned long long)ctx->key_params.key_dma_addr,
@@ -1320,7 +1294,6 @@ static int ssi_xcbc_setkey(struct crypto_ahash *ahash,
 	if (rc != 0)
 		crypto_ahash_set_flags(ahash, CRYPTO_TFM_RES_BAD_KEY_LEN);
 
-	SSI_RESTORE_DMA_ADDR_TO_48BIT(ctx->key_params.key_dma_addr);
 	dma_unmap_single(&ctx->drvdata->plat_dev->dev,
 			ctx->key_params.key_dma_addr,
 			ctx->key_params.keylen, DMA_TO_DEVICE);
@@ -1355,7 +1328,6 @@ static int ssi_cmac_setkey(struct crypto_ahash *ahash,
 	/* STAT_PHASE_1: Copy key to ctx */
 	START_CYCLE_COUNT();
 
-	SSI_RESTORE_DMA_ADDR_TO_48BIT(ctx->opad_tmp_keys_dma_addr);
 	dma_sync_single_for_cpu(&ctx->drvdata->plat_dev->dev,
 				ctx->opad_tmp_keys_dma_addr,
 				keylen, DMA_TO_DEVICE);
@@ -1367,7 +1339,6 @@ static int ssi_cmac_setkey(struct crypto_ahash *ahash,
 	dma_sync_single_for_device(&ctx->drvdata->plat_dev->dev,
 				   ctx->opad_tmp_keys_dma_addr,
 				   keylen, DMA_TO_DEVICE);
-	SSI_UPDATE_DMA_ADDR_TO_48BIT(ctx->opad_tmp_keys_dma_addr, keylen);
 
 	ctx->key_params.keylen = keylen;
 
@@ -1382,7 +1353,6 @@ static void ssi_hash_free_ctx(struct ssi_hash_ctx *ctx)
 	struct device *dev = &ctx->drvdata->plat_dev->dev;
 
 	if (ctx->digest_buff_dma_addr != 0) {
-		SSI_RESTORE_DMA_ADDR_TO_48BIT(ctx->digest_buff_dma_addr);
 		dma_unmap_single(dev, ctx->digest_buff_dma_addr,
 				 sizeof(ctx->digest_buff), DMA_BIDIRECTIONAL);
 		SSI_LOG_DEBUG("Unmapped digest-buffer: "
@@ -1391,7 +1361,6 @@ static void ssi_hash_free_ctx(struct ssi_hash_ctx *ctx)
 		ctx->digest_buff_dma_addr = 0;
 	}
 	if (ctx->opad_tmp_keys_dma_addr != 0) {
-		SSI_RESTORE_DMA_ADDR_TO_48BIT(ctx->opad_tmp_keys_dma_addr);
 		dma_unmap_single(dev, ctx->opad_tmp_keys_dma_addr,
 				 sizeof(ctx->opad_tmp_keys_buff),
 				 DMA_BIDIRECTIONAL);
@@ -1418,8 +1387,6 @@ static int ssi_hash_alloc_ctx(struct ssi_hash_ctx *ctx)
 			sizeof(ctx->digest_buff), ctx->digest_buff);
 		goto fail;
 	}
-	SSI_UPDATE_DMA_ADDR_TO_48BIT(ctx->digest_buff_dma_addr,
-						sizeof(ctx->digest_buff));
 	SSI_LOG_DEBUG("Mapped digest %zu B at va=%pK to dma=0x%llX\n",
 		sizeof(ctx->digest_buff), ctx->digest_buff,
 		(unsigned long long)ctx->digest_buff_dma_addr);
@@ -1431,8 +1398,6 @@ static int ssi_hash_alloc_ctx(struct ssi_hash_ctx *ctx)
 			ctx->opad_tmp_keys_buff);
 		goto fail;
 	}
-	SSI_UPDATE_DMA_ADDR_TO_48BIT(ctx->opad_tmp_keys_dma_addr,
-					sizeof(ctx->opad_tmp_keys_buff));
 	SSI_LOG_DEBUG("Mapped opad_tmp_keys %zu B at va=%pK to dma=0x%llX\n",
 		sizeof(ctx->opad_tmp_keys_buff), ctx->opad_tmp_keys_buff,
 		(unsigned long long)ctx->opad_tmp_keys_dma_addr);
diff --git a/drivers/staging/ccree/ssi_ivgen.c b/drivers/staging/ccree/ssi_ivgen.c
index 233666b..cd606ab 100644
--- a/drivers/staging/ccree/ssi_ivgen.c
+++ b/drivers/staging/ccree/ssi_ivgen.c
@@ -165,7 +165,6 @@ void ssi_ivgen_fini(struct ssi_drvdata *drvdata)
 
 	if (ivgen_ctx->pool_meta != NULL) {
 		memset(ivgen_ctx->pool_meta, 0, SSI_IVPOOL_META_SIZE);
-		SSI_RESTORE_DMA_ADDR_TO_48BIT(ivgen_ctx->pool_meta_dma);
 		dma_free_coherent(device, SSI_IVPOOL_META_SIZE,
 			ivgen_ctx->pool_meta, ivgen_ctx->pool_meta_dma);
 	}
@@ -209,8 +208,6 @@ int ssi_ivgen_init(struct ssi_drvdata *drvdata)
 		rc = -ENOMEM;
 		goto out;
 	}
-	SSI_UPDATE_DMA_ADDR_TO_48BIT(ivgen_ctx->pool_meta_dma,
-							SSI_IVPOOL_META_SIZE);
 	/* Allocate IV pool in SRAM */
 	ivgen_ctx->pool = ssi_sram_mgr_alloc(drvdata, SSI_IVPOOL_SIZE);
 	if (ivgen_ctx->pool == NULL_SRAM_ADDR) {
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index 02ad065..2ec296c 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -145,7 +145,6 @@ void request_mgr_fini(struct ssi_drvdata *drvdata)
 		return; /* Not allocated */
 
 	if (req_mgr_h->dummy_comp_buff_dma != 0) {
-		SSI_RESTORE_DMA_ADDR_TO_48BIT(req_mgr_h->dummy_comp_buff_dma);
 		dma_free_coherent(&drvdata->plat_dev->dev,
 				  sizeof(u32), req_mgr_h->dummy_comp_buff,
 				  req_mgr_h->dummy_comp_buff_dma);
@@ -220,8 +219,6 @@ int request_mgr_init(struct ssi_drvdata *drvdata)
 		rc = -ENOMEM;
 		goto req_mgr_init_err;
 	}
-	SSI_UPDATE_DMA_ADDR_TO_48BIT(req_mgr_h->dummy_comp_buff_dma,
-							     sizeof(u32));
 
 	/* Init. "dummy" completion descriptor */
 	hw_desc_init(&req_mgr_h->compl_desc);
-- 
2.1.4
