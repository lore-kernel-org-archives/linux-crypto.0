From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 05/14] staging: ccree: no need for braces for single statements
Date: Tue, 27 Jun 2017 10:27:17 +0300
Message-ID: <1498548449-10803-6-git-send-email-gilad@benyossef.com>
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

Fix several cases of needless braces around single statement blocks.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c        | 38 +++++++-----------
 drivers/staging/ccree/ssi_buffer_mgr.c  | 70 ++++++++++++++-------------------
 drivers/staging/ccree/ssi_cipher.c      | 41 +++++++------------
 drivers/staging/ccree/ssi_driver.c      |  9 +++--
 drivers/staging/ccree/ssi_fips.c        |  6 +--
 drivers/staging/ccree/ssi_fips_ext.c    |  6 +--
 drivers/staging/ccree/ssi_fips_local.c  | 39 +++++++++---------
 drivers/staging/ccree/ssi_hash.c        | 35 ++++++-----------
 drivers/staging/ccree/ssi_ivgen.c       |  4 +-
 drivers/staging/ccree/ssi_request_mgr.c | 20 ++++------
 drivers/staging/ccree/ssi_sysfs.c       |  4 +-
 11 files changed, 110 insertions(+), 162 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 5782c9d..fdb257d 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -243,11 +243,10 @@ static void ssi_aead_complete(struct device *dev, void *ssi_req, void __iomem *c
 
 		/* If an IV was generated, copy it back to the user provided buffer. */
 		if (areq_ctx->backup_giv != NULL) {
-			if (ctx->cipher_mode == DRV_CIPHER_CTR) {
+			if (ctx->cipher_mode == DRV_CIPHER_CTR)
 				memcpy(areq_ctx->backup_giv, areq_ctx->ctr_iv + CTR_RFC3686_NONCE_SIZE, CTR_RFC3686_IV_SIZE);
-			} else if (ctx->cipher_mode == DRV_CIPHER_CCM) {
+			else if (ctx->cipher_mode == DRV_CIPHER_CCM)
 				memcpy(areq_ctx->backup_giv, areq_ctx->ctr_iv + CCM_BLOCK_IV_OFFSET, CCM_BLOCK_IV_SIZE);
-			}
 		}
 	}
 
@@ -521,9 +520,8 @@ ssi_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key, unsigned int keyl
 	if (unlikely(rc != 0))
 		SSI_LOG_ERR("send_request() failed (rc=%d)\n", rc);
 
-	if (likely(key_dma_addr != 0)) {
+	if (likely(key_dma_addr != 0))
 		dma_unmap_single(dev, key_dma_addr, keylen, DMA_TO_DEVICE);
-	}
 
 	return rc;
 }
@@ -928,11 +926,10 @@ static inline void ssi_aead_setup_cipher_desc(
 	set_flow_mode(&desc[idx], ctx->flow_mode);
 	set_din_type(&desc[idx], DMA_DLLI, req_ctx->gen_ctx.iv_dma_addr,
 		     hw_iv_size, NS_BIT);
-	if (ctx->cipher_mode == DRV_CIPHER_CTR) {
+	if (ctx->cipher_mode == DRV_CIPHER_CTR)
 		set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
-	} else {
+	else
 		set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
-	}
 	set_cipher_mode(&desc[idx], ctx->cipher_mode);
 	idx++;
 
@@ -1375,9 +1372,9 @@ static int validate_data_size(struct ssi_aead_ctx *ctx,
 static unsigned int format_ccm_a0(u8 *pA0Buff, u32 headerSize)
 {
 	unsigned int len = 0;
-	if (headerSize == 0) {
+	if (headerSize == 0)
 		return 0;
-	}
+
 	if (headerSize < ((1UL << 16) - (1UL << 8))) {
 		len = 2;
 
@@ -1498,9 +1495,8 @@ static inline int ssi_aead_ccm(
 	}
 
 	/* process the cipher */
-	if (req_ctx->cryptlen != 0) {
+	if (req_ctx->cryptlen != 0)
 		ssi_aead_process_cipher_data_desc(req, cipher_flow_mode, desc, &idx);
-	}
 
 	/* Read temporal MAC */
 	hw_desc_init(&desc[idx]);
@@ -1579,9 +1575,8 @@ static int config_ccm_adata(struct aead_request *req)
 		*b0 |= 64;  /* Enable bit 6 if Adata exists. */
 
 	rc = set_msg_len(b0 + 16 - l, cryptlen, l);  /* Write L'. */
-	if (rc != 0) {
+	if (rc != 0)
 		return rc;
-	}
 	 /* END of "taken from crypto/ccm.c" */
 
 	/* l(a) - size of associated data. */
@@ -1861,9 +1856,8 @@ static inline void ssi_aead_dump_gcm(
 	SSI_LOG_DEBUG("cipher_mode %d, authsize %d, enc_keylen %d, assoclen %d, cryptlen %d\n", \
 				 ctx->cipher_mode, ctx->authsize, ctx->enc_keylen, req->assoclen, req_ctx->cryptlen);
 
-	if (ctx->enckey != NULL) {
+	if (ctx->enckey != NULL)
 		dump_byte_array("mac key", ctx->enckey, 16);
-	}
 
 	dump_byte_array("req->iv", req->iv, AES_BLOCK_SIZE);
 
@@ -1877,13 +1871,11 @@ static inline void ssi_aead_dump_gcm(
 
 	dump_byte_array("gcm_len_block", req_ctx->gcm_len_block.lenA, AES_BLOCK_SIZE);
 
-	if (req->src != NULL && req->cryptlen) {
+	if (req->src != NULL && req->cryptlen)
 		dump_byte_array("req->src", sg_virt(req->src), req->cryptlen + req->assoclen);
-	}
 
-	if (req->dst != NULL) {
+	if (req->dst != NULL)
 		dump_byte_array("req->dst", sg_virt(req->dst), req->cryptlen + ctx->authsize + req->assoclen);
-	}
 }
 #endif
 
@@ -2083,14 +2075,12 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 #if (SSI_CC_HAS_AES_CCM || SSI_CC_HAS_AES_GCM)
 	case DRV_HASH_NULL:
 #if SSI_CC_HAS_AES_CCM
-		if (ctx->cipher_mode == DRV_CIPHER_CCM) {
+		if (ctx->cipher_mode == DRV_CIPHER_CCM)
 			ssi_aead_ccm(req, desc, &seq_len);
-		}
 #endif /*SSI_CC_HAS_AES_CCM*/
 #if SSI_CC_HAS_AES_GCM
-		if (ctx->cipher_mode == DRV_CIPHER_GCTR) {
+		if (ctx->cipher_mode == DRV_CIPHER_GCTR)
 			ssi_aead_gcm(req, desc, &seq_len);
-		}
 #endif /*SSI_CC_HAS_AES_GCM*/
 			break;
 #endif
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 63f057e..9e8a134 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -94,9 +94,8 @@ static unsigned int ssi_buffer_mgr_get_sgl_nents(
 			sg_list = sg_next(sg_list);
 		} else {
 			sg_list = (struct scatterlist *)sg_page(sg_list);
-			if (is_chained != NULL) {
+			if (is_chained != NULL)
 				*is_chained = true;
-			}
 		}
 	}
 	SSI_LOG_DEBUG("nents %d last bytes %d\n", nents, *lbytes);
@@ -155,9 +154,8 @@ static inline int ssi_buffer_mgr_render_buff_to_mlli(
 
 	/* Verify there is no memory overflow*/
 	new_nents = (*curr_nents + buff_size / CC_MAX_MLLI_ENTRY_SIZE + 1);
-	if (new_nents > MAX_NUM_OF_TOTAL_MLLI_ENTRIES) {
+	if (new_nents > MAX_NUM_OF_TOTAL_MLLI_ENTRIES)
 		return -ENOMEM;
-	}
 
 	/*handle buffer longer than 64 kbytes */
 	while (buff_size > CC_MAX_MLLI_ENTRY_SIZE) {
@@ -201,9 +199,9 @@ static inline int ssi_buffer_mgr_render_scatterlist_to_mlli(
 		rc = ssi_buffer_mgr_render_buff_to_mlli(
 			sg_dma_address(curr_sgl) + sglOffset, entry_data_len, curr_nents,
 			&mlli_entry_p);
-		if (rc != 0) {
+		if (rc != 0)
 			return rc;
-		}
+
 		sglOffset = 0;
 	}
 	*mlli_entry_pp = mlli_entry_p;
@@ -244,9 +242,8 @@ static int ssi_buffer_mgr_generate_mlli(
 				sg_data->entry[i].buffer_dma,
 				sg_data->total_data_len[i], &total_nents,
 				&mlli_p);
-		if (rc != 0) {
+		if (rc != 0)
 			return rc;
-		}
 
 		/* set last bit in the current table */
 		if (sg_data->mlli_nents[i] != NULL) {
@@ -326,9 +323,8 @@ ssi_buffer_mgr_dma_map_sg(struct device *dev, struct scatterlist *sg, u32 nents,
 	u32 i, j;
 	struct scatterlist *l_sg = sg;
 	for (i = 0; i < nents; i++) {
-		if (l_sg == NULL) {
+		if (l_sg == NULL)
 			break;
-		}
 		if (unlikely(dma_map_sg(dev, l_sg, 1, direction) != 1)) {
 			SSI_LOG_ERR("dma_map_page() sg buffer failed\n");
 			goto err;
@@ -340,9 +336,8 @@ ssi_buffer_mgr_dma_map_sg(struct device *dev, struct scatterlist *sg, u32 nents,
 err:
 	/* Restore mapped parts */
 	for (j = 0; j < i; j++) {
-		if (sg == NULL) {
+		if (sg == NULL)
 			break;
-		}
 		dma_unmap_sg(dev, sg, 1, direction);
 		sg = sg_next(sg);
 	}
@@ -687,9 +682,8 @@ void ssi_buffer_mgr_unmap_aead_request(
 
 	SSI_LOG_DEBUG("Unmapping src sgl: req->src=%pK areq_ctx->src.nents=%u areq_ctx->assoc.nents=%u assoclen:%u cryptlen=%u\n", sg_virt(req->src), areq_ctx->src.nents, areq_ctx->assoc.nents, req->assoclen, req->cryptlen);
 	size_to_unmap = req->assoclen + req->cryptlen;
-	if (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_ENCRYPT) {
+	if (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_ENCRYPT)
 		size_to_unmap += areq_ctx->req_authsize;
-	}
 	if (areq_ctx->is_gcm4543)
 		size_to_unmap += crypto_aead_ivsize(tfm);
 
@@ -705,9 +699,9 @@ void ssi_buffer_mgr_unmap_aead_request(
 	    likely(req->src == req->dst))
 	{
 		u32 size_to_skip = req->assoclen;
-		if (areq_ctx->is_gcm4543) {
+		if (areq_ctx->is_gcm4543)
 			size_to_skip += crypto_aead_ivsize(tfm);
-		}
+
 		/* copy mac to a temporary location to deal with possible
 		 * data memory overriding that caused by cache coherence problem.
 		 */
@@ -736,15 +730,13 @@ static inline int ssi_buffer_mgr_get_aead_icv_nents(
 	}
 
 	for (i = 0 ; i < (sgl_nents - MAX_ICV_NENTS_SUPPORTED) ; i++) {
-		if (sgl == NULL) {
+		if (sgl == NULL)
 			break;
-		}
 		sgl = sg_next(sgl);
 	}
 
-	if (sgl != NULL) {
+	if (sgl != NULL)
 		icv_max_size = sgl->length;
-	}
 
 	if (last_entry_data_size > authsize) {
 		nents = 0; /* ICV attached to data in last entry (not fragmented!) */
@@ -827,9 +819,8 @@ static inline int ssi_buffer_mgr_aead_chain_assoc(
 	unsigned int sg_index = 0;
 	u32 size_of_assoc = req->assoclen;
 
-	if (areq_ctx->is_gcm4543) {
+	if (areq_ctx->is_gcm4543)
 		size_of_assoc += crypto_aead_ivsize(tfm);
-	}
 
 	if (sg_data == NULL) {
 		rc = -EINVAL;
@@ -1035,9 +1026,9 @@ static inline int ssi_buffer_mgr_prepare_aead_data_mlli(
 			 * MAC verification upon request completion
 			 */
 			  u32 size_to_skip = req->assoclen;
-			  if (areq_ctx->is_gcm4543) {
+			  if (areq_ctx->is_gcm4543)
 				  size_to_skip += crypto_aead_ivsize(tfm);
-			  }
+
 			  ssi_buffer_mgr_copy_scatterlist_portion(
 				  areq_ctx->backup_mac, req->src,
 				  size_to_skip + req->cryptlen - areq_ctx->req_authsize,
@@ -1110,9 +1101,10 @@ static inline int ssi_buffer_mgr_aead_chain_data(
 	bool chained = false;
 	bool is_gcm4543 = areq_ctx->is_gcm4543;
 	u32 size_to_skip = req->assoclen;
-	if (is_gcm4543) {
+
+	if (is_gcm4543)
 		size_to_skip += crypto_aead_ivsize(tfm);
-	}
+
 	offset = size_to_skip;
 
 	if (sg_data == NULL) {
@@ -1122,9 +1114,8 @@ static inline int ssi_buffer_mgr_aead_chain_data(
 	areq_ctx->srcSgl = req->src;
 	areq_ctx->dstSgl = req->dst;
 
-	if (is_gcm4543) {
+	if (is_gcm4543)
 		size_for_map += crypto_aead_ivsize(tfm);
-	}
 
 	size_for_map += (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ? authsize : 0;
 	src_mapped_nents = ssi_buffer_mgr_get_sgl_nents(req->src, size_for_map, &src_last_bytes, &chained);
@@ -1155,9 +1146,8 @@ static inline int ssi_buffer_mgr_aead_chain_data(
 	if (req->src != req->dst) {
 		size_for_map = req->assoclen + req->cryptlen;
 		size_for_map += (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ? authsize : 0;
-		if (is_gcm4543) {
+		if (is_gcm4543)
 			size_for_map += crypto_aead_ivsize(tfm);
-		}
 
 		rc = ssi_buffer_mgr_map_scatterlist(dev, req->dst, size_for_map,
 			 DMA_BIDIRECTIONAL, &(areq_ctx->dst.nents),
@@ -1285,9 +1275,10 @@ int ssi_buffer_mgr_map_aead_request(
 	    likely(req->src == req->dst))
 	{
 		u32 size_to_skip = req->assoclen;
-		if (is_gcm4543) {
+
+		if (is_gcm4543)
 			size_to_skip += crypto_aead_ivsize(tfm);
-		}
+
 		/* copy mac to a temporary location to deal with possible
 		 * data memory overriding that caused by cache coherence problem.
 		 */
@@ -1381,9 +1372,9 @@ int ssi_buffer_mgr_map_aead_request(
 #endif /*SSI_CC_HAS_AES_GCM*/
 
 	size_to_map = req->cryptlen + req->assoclen;
-	if (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_ENCRYPT) {
+	if (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_ENCRYPT)
 		size_to_map += authsize;
-	}
+
 	if (is_gcm4543)
 		size_to_map += crypto_aead_ivsize(tfm);
 	rc = ssi_buffer_mgr_map_scatterlist(dev, req->src,
@@ -1448,9 +1439,8 @@ int ssi_buffer_mgr_map_aead_request(
 		(areq_ctx->data_buff_type == SSI_DMA_BUF_MLLI))) {
 		mlli_params->curr_pool = buff_mgr->mlli_buffs_pool;
 		rc = ssi_buffer_mgr_generate_mlli(dev, &sg_data, mlli_params);
-		if (unlikely(rc != 0)) {
+		if (unlikely(rc != 0))
 			goto aead_map_failure;
-		}
 
 		ssi_buffer_mgr_update_aead_mlli_nents(drvdata, req);
 		SSI_LOG_DEBUG("assoc params mn %d\n", areq_ctx->assoc.mlli_nents);
@@ -1549,9 +1539,9 @@ int ssi_buffer_mgr_map_hash_request_final(
 	dma_unmap_sg(dev, src, areq_ctx->in_nents, DMA_TO_DEVICE);
 
 unmap_curr_buff:
-	if (*curr_buff_cnt != 0) {
+	if (*curr_buff_cnt != 0)
 		dma_unmap_sg(dev, areq_ctx->buff_sg, 1, DMA_TO_DEVICE);
-	}
+
 	return -ENOMEM;
 }
 
@@ -1678,9 +1668,9 @@ int ssi_buffer_mgr_map_hash_request_update(
 	dma_unmap_sg(dev, src, areq_ctx->in_nents, DMA_TO_DEVICE);
 
 unmap_curr_buff:
-	if (*curr_buff_cnt != 0) {
+	if (*curr_buff_cnt != 0)
 		dma_unmap_sg(dev, areq_ctx->buff_sg, 1, DMA_TO_DEVICE);
-	}
+
 	return -ENOMEM;
 }
 
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 722b307..c233b7c 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -165,13 +165,11 @@ static unsigned int get_max_keysize(struct crypto_tfm *tfm)
 {
 	struct ssi_crypto_alg *ssi_alg = container_of(tfm->__crt_alg, struct ssi_crypto_alg, crypto_alg);
 
-	if ((ssi_alg->crypto_alg.cra_flags & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_ABLKCIPHER) {
+	if ((ssi_alg->crypto_alg.cra_flags & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_ABLKCIPHER)
 		return ssi_alg->crypto_alg.cra_ablkcipher.max_keysize;
-	}
 
-	if ((ssi_alg->crypto_alg.cra_flags & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_BLKCIPHER) {
+	if ((ssi_alg->crypto_alg.cra_flags & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_BLKCIPHER)
 		return ssi_alg->crypto_alg.cra_blkcipher.max_keysize;
-	}
 
 	return 0;
 }
@@ -289,9 +287,8 @@ static int ssi_fips_verify_xts_keys(const u8 *key, unsigned int keylen)
 	/* Weak key is define as key that its first half (128/256 lsb) equals its second half (128/256 msb) */
 	int singleKeySize = keylen >> 1;
 
-	if (unlikely(memcmp(key, &key[singleKeySize], singleKeySize) == 0)) {
+	if (unlikely(memcmp(key, &key[singleKeySize], singleKeySize) == 0))
 		return -ENOEXEC;
-	}
 #endif /* CCREE_FIPS_SUPPORT */
 
 	return 0;
@@ -333,9 +330,8 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 
 #if SSI_CC_HAS_MULTI2
 	/*last byte of key buffer is round number and should not be a part of key size*/
-	if (ctx_p->flow_mode == S_DIN_to_MULTI2) {
+	if (ctx_p->flow_mode == S_DIN_to_MULTI2)
 		keylen -= 1;
-	}
 #endif /*SSI_CC_HAS_MULTI2*/
 
 	if (unlikely(validate_keys_sizes(ctx_p, keylen) != 0)) {
@@ -658,9 +654,9 @@ ssi_blkcipher_create_data_desc(
 			     nbytes, NS_BIT);
 		set_dout_dlli(&desc[*seq_size], sg_dma_address(dst),
 			      nbytes, NS_BIT, (!areq ? 0 : 1));
-		if (areq != NULL) {
+		if (areq != NULL)
 			set_queue_last_ind(&desc[*seq_size]);
-		}
+
 		set_flow_mode(&desc[*seq_size], flow_mode);
 		(*seq_size)++;
 	} else {
@@ -707,9 +703,9 @@ ssi_blkcipher_create_data_desc(
 				      req_ctx->out_mlli_nents, NS_BIT,
 				      (!areq ? 0 : 1));
 		}
-		if (areq != NULL) {
+		if (areq != NULL)
 			set_queue_last_ind(&desc[*seq_size]);
-		}
+
 		set_flow_mode(&desc[*seq_size], flow_mode);
 		(*seq_size)++;
 	}
@@ -809,22 +805,13 @@ static int ssi_blkcipher_process(
 
 	/* Setup processing */
 #if SSI_CC_HAS_MULTI2
-	if (ctx_p->flow_mode == S_DIN_to_MULTI2) {
-		ssi_blkcipher_create_multi2_setup_desc(tfm,
-						       req_ctx,
-						       ivsize,
-						       desc,
-						       &seq_len);
-	} else
+	if (ctx_p->flow_mode == S_DIN_to_MULTI2)
+		ssi_blkcipher_create_multi2_setup_desc(tfm, req_ctx, ivsize,
+						       desc, &seq_len);
+	else
 #endif /*SSI_CC_HAS_MULTI2*/
-	{
-		ssi_blkcipher_create_setup_desc(tfm,
-						req_ctx,
-						ivsize,
-						nbytes,
-						desc,
-						&seq_len);
-	}
+		ssi_blkcipher_create_setup_desc(tfm, req_ctx, ivsize, nbytes,
+						desc, &seq_len);
 	/* Data processing */
 	ssi_blkcipher_create_data_desc(tfm,
 			      req_ctx,
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 3168930..330d24d 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -205,16 +205,17 @@ int init_cc_regs(struct ssi_drvdata *drvdata, bool is_probe)
 	cache_params = (drvdata->coherent ? CC_COHERENT_CACHE_PARAMS : 0x0);
 
 	val = CC_HAL_READ_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_CACHE_PARAMS));
-	if (is_probe) {
+
+	if (is_probe)
 		SSI_LOG_INFO("Cache params previous: 0x%08X\n", val);
-	}
+
 	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_CACHE_PARAMS),
 			      cache_params);
 	val = CC_HAL_READ_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_CACHE_PARAMS));
-	if (is_probe) {
+
+	if (is_probe)
 		SSI_LOG_INFO("Cache params current: 0x%08X (expect: 0x%08X)\n",
 			     val, cache_params);
-	}
 
 	return 0;
 }
diff --git a/drivers/staging/ccree/ssi_fips.c b/drivers/staging/ccree/ssi_fips.c
index 60a2452..2e01a0a 100644
--- a/drivers/staging/ccree/ssi_fips.c
+++ b/drivers/staging/ccree/ssi_fips.c
@@ -34,9 +34,8 @@ int ssi_fips_get_state(ssi_fips_state_t *p_state)
 {
 	int rc = 0;
 
-	if (p_state == NULL) {
+	if (p_state == NULL)
 		return -EINVAL;
-	}
 
 	rc = ssi_fips_ext_get_state(p_state);
 
@@ -53,9 +52,8 @@ int ssi_fips_get_error(ssi_fips_error_t *p_err)
 {
 	int rc = 0;
 
-	if (p_err == NULL) {
+	if (p_err == NULL)
 		return -EINVAL;
-	}
 
 	rc = ssi_fips_ext_get_error(p_err);
 
diff --git a/drivers/staging/ccree/ssi_fips_ext.c b/drivers/staging/ccree/ssi_fips_ext.c
index aa90ddd..8b14061 100644
--- a/drivers/staging/ccree/ssi_fips_ext.c
+++ b/drivers/staging/ccree/ssi_fips_ext.c
@@ -41,9 +41,8 @@ int ssi_fips_ext_get_state(ssi_fips_state_t *p_state)
 {
 	int rc = 0;
 
-	if (p_state == NULL) {
+	if (p_state == NULL)
 		return -EINVAL;
-	}
 
 	*p_state = fips_state;
 
@@ -60,9 +59,8 @@ int ssi_fips_ext_get_error(ssi_fips_error_t *p_err)
 {
 	int rc = 0;
 
-	if (p_err == NULL) {
+	if (p_err == NULL)
 		return -EINVAL;
-	}
 
 	*p_err = fips_error;
 
diff --git a/drivers/staging/ccree/ssi_fips_local.c b/drivers/staging/ccree/ssi_fips_local.c
index 33a07e4..84d458a1 100644
--- a/drivers/staging/ccree/ssi_fips_local.c
+++ b/drivers/staging/ccree/ssi_fips_local.c
@@ -72,9 +72,9 @@ static enum ssi_fips_error ssi_fips_get_tee_error(struct ssi_drvdata *drvdata)
 	void __iomem *cc_base = drvdata->cc_base;
 
 	regVal = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, GPR_HOST));
-	if (regVal == (CC_FIPS_SYNC_TEE_STATUS | CC_FIPS_SYNC_MODULE_OK)) {
+	if (regVal == (CC_FIPS_SYNC_TEE_STATUS | CC_FIPS_SYNC_MODULE_OK))
 		return CC_REE_FIPS_ERROR_OK;
-	}
+
 	return CC_REE_FIPS_ERROR_FROM_TEE;
 }
 
@@ -87,11 +87,10 @@ static enum ssi_fips_error ssi_fips_get_tee_error(struct ssi_drvdata *drvdata)
 static void ssi_fips_update_tee_upon_ree_status(struct ssi_drvdata *drvdata, ssi_fips_error_t err)
 {
 	void __iomem *cc_base = drvdata->cc_base;
-	if (err == CC_REE_FIPS_ERROR_OK) {
+	if (err == CC_REE_FIPS_ERROR_OK)
 		CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_GPR0), (CC_FIPS_SYNC_REE_STATUS | CC_FIPS_SYNC_MODULE_OK));
-	} else {
+	else
 		CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_GPR0), (CC_FIPS_SYNC_REE_STATUS | CC_FIPS_SYNC_MODULE_ERROR));
-	}
 }
 
 
@@ -152,9 +151,8 @@ static void fips_dsr(unsigned long devarg)
 
 	if (irq & SSI_GPR0_IRQ_MASK) {
 		teeFipsError = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, GPR_HOST));
-		if (teeFipsError != (CC_FIPS_SYNC_TEE_STATUS | CC_FIPS_SYNC_MODULE_OK)) {
+		if (teeFipsError != (CC_FIPS_SYNC_TEE_STATUS | CC_FIPS_SYNC_MODULE_OK))
 			ssi_fips_set_error(drvdata, CC_REE_FIPS_ERROR_FROM_TEE);
-		}
 	}
 
 	/* after verifing that there is nothing to do, Unmask AXI completion interrupt */
@@ -177,9 +175,9 @@ ssi_fips_error_t cc_fips_run_power_up_tests(struct ssi_drvdata *drvdata)
 	// the dma_handle is the returned phy address - use it in the HW descriptor
 	FIPS_DBG("dma_alloc_coherent \n");
 	cpu_addr_buffer = dma_alloc_coherent(dev, alloc_buff_size, &dma_handle, GFP_KERNEL);
-	if (cpu_addr_buffer == NULL) {
+	if (cpu_addr_buffer == NULL)
 		return CC_REE_FIPS_ERROR_GENERAL;
-	}
+
 	FIPS_DBG("allocated coherent buffer - addr 0x%08X , size = %d \n", (size_t)cpu_addr_buffer, alloc_buff_size);
 
 #if FIPS_POWER_UP_TEST_CIPHER
@@ -269,30 +267,29 @@ int ssi_fips_set_error(struct ssi_drvdata *p_drvdata, ssi_fips_error_t err)
 	FIPS_LOG("ssi_fips_set_error - fips_error = %d \n", err);
 
 	// setting no error is not allowed
-	if (err == CC_REE_FIPS_ERROR_OK) {
+	if (err == CC_REE_FIPS_ERROR_OK)
 		return -ENOEXEC;
-	}
+
 	// If error exists, do not set new error
-	if (ssi_fips_get_error(&current_err) != 0) {
+	if (ssi_fips_get_error(&current_err) != 0)
 		return -ENOEXEC;
-	}
-	if (current_err != CC_REE_FIPS_ERROR_OK) {
+
+	if (current_err != CC_REE_FIPS_ERROR_OK)
 		return -ENOEXEC;
-	}
+
 	// set REE internal error and state
 	rc = ssi_fips_ext_set_error(err);
-	if (rc != 0) {
+	if (rc != 0)
 		return -ENOEXEC;
-	}
+
 	rc = ssi_fips_ext_set_state(CC_FIPS_STATE_ERROR);
-	if (rc != 0) {
+	if (rc != 0)
 		return -ENOEXEC;
-	}
 
 	// push error towards TEE libraray, if it's not TEE error
-	if (err != CC_REE_FIPS_ERROR_FROM_TEE) {
+	if (err != CC_REE_FIPS_ERROR_FROM_TEE)
 		ssi_fips_update_tee_upon_ree_status(p_drvdata, err);
-	}
+
 	return rc;
 }
 
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 9d5e54d..265df94 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -215,11 +215,10 @@ static int ssi_hash_map_request(struct device *dev,
 		} else { /*sha*/
 			memcpy(state->digest_buff, ctx->digest_buff, ctx->inter_digestsize);
 #if (DX_DEV_SHA_MAX > 256)
-			if (unlikely((ctx->hash_mode == DRV_HASH_SHA512) || (ctx->hash_mode == DRV_HASH_SHA384))) {
+			if (unlikely((ctx->hash_mode == DRV_HASH_SHA512) || (ctx->hash_mode == DRV_HASH_SHA384)))
 				memcpy(state->digest_bytes_len, digest_len_sha512_init, HASH_LEN_SIZE);
-			} else {
+			else
 				memcpy(state->digest_bytes_len, digest_len_init, HASH_LEN_SIZE);
-			}
 #else
 			memcpy(state->digest_bytes_len, digest_len_init, HASH_LEN_SIZE);
 #endif
@@ -480,11 +479,10 @@ static int ssi_hash_digest(struct ahash_req_ctx *state,
 			     NS_BIT);
 	} else {
 		set_din_const(&desc[idx], 0, HASH_LEN_SIZE);
-		if (likely(nbytes != 0)) {
+		if (likely(nbytes != 0))
 			set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
-		} else {
+		else
 			set_cipher_do(&desc[idx], DO_PAD);
-		}
 	}
 	set_flow_mode(&desc[idx], S_DIN_to_HASH);
 	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
@@ -553,9 +551,8 @@ ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
 	/* TODO */
 	set_dout_dlli(&desc[idx], state->digest_result_dma_addr, digestsize,
 		      NS_BIT, (async_req ? 1 : 0));
-	if (async_req) {
+	if (async_req)
 		set_queue_last_ind(&desc[idx]);
-	}
 	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
 	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
 	set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
@@ -656,9 +653,8 @@ static int ssi_hash_update(struct ahash_req_ctx *state,
 	set_cipher_mode(&desc[idx], ctx->hw_mode);
 	set_dout_dlli(&desc[idx], state->digest_bytes_len_dma_addr,
 		      HASH_LEN_SIZE, NS_BIT, (async_req ? 1 : 0));
-	if (async_req) {
+	if (async_req)
 		set_queue_last_ind(&desc[idx]);
-	}
 	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
 	set_setup_mode(&desc[idx], SETUP_WRITE_STATE1);
 	idx++;
@@ -786,9 +782,8 @@ ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
 	/* TODO */
 	set_dout_dlli(&desc[idx], state->digest_result_dma_addr, digestsize,
 		      NS_BIT, (async_req ? 1 : 0));
-	if (async_req) {
+	if (async_req)
 		set_queue_last_ind(&desc[idx]);
-	}
 	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
 	set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
 	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
@@ -933,9 +928,8 @@ ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
 	hw_desc_init(&desc[idx]);
 	set_dout_dlli(&desc[idx], state->digest_result_dma_addr, digestsize,
 		      NS_BIT, (async_req ? 1 : 0));
-	if (async_req) {
+	if (async_req)
 		set_queue_last_ind(&desc[idx]);
-	}
 	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
 	set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
 	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
@@ -1423,11 +1417,10 @@ static int ssi_mac_update(struct ahash_request *req)
 		return -ENOMEM;
 	}
 
-	if (ctx->hw_mode == DRV_CIPHER_XCBC_MAC) {
+	if (ctx->hw_mode == DRV_CIPHER_XCBC_MAC)
 		ssi_hash_create_xcbc_setup(req, desc, &idx);
-	} else {
+	else
 		ssi_hash_create_cmac_setup(req, desc, &idx);
-	}
 
 	ssi_hash_create_data_desc(state, ctx, DIN_AES_DOUT, desc, true, &idx);
 
@@ -1525,11 +1518,10 @@ static int ssi_mac_final(struct ahash_request *req)
 		idx++;
 	}
 
-	if (ctx->hw_mode == DRV_CIPHER_XCBC_MAC) {
+	if (ctx->hw_mode == DRV_CIPHER_XCBC_MAC)
 		ssi_hash_create_xcbc_setup(req, desc, &idx);
-	} else {
+	else
 		ssi_hash_create_cmac_setup(req, desc, &idx);
-	}
 
 	if (state->xcbc_count == 0) {
 		hw_desc_init(&desc[idx]);
@@ -2506,9 +2498,8 @@ static void ssi_hash_create_data_desc(struct ahash_req_ctx *areq_ctx,
 		set_flow_mode(&desc[idx], flow_mode);
 		idx++;
 	}
-	if (is_not_last_data) {
+	if (is_not_last_data)
 		set_din_not_last_indication(&desc[(idx - 1)]);
-	}
 	/* return updated desc sequence size */
 	*seq_size = idx;
 }
diff --git a/drivers/staging/ccree/ssi_ivgen.c b/drivers/staging/ccree/ssi_ivgen.c
index 88f2080..d81bf68 100644
--- a/drivers/staging/ccree/ssi_ivgen.c
+++ b/drivers/staging/ccree/ssi_ivgen.c
@@ -143,9 +143,9 @@ int ssi_ivgen_init_sram_pool(struct ssi_drvdata *drvdata)
 
 	/* Generate initial pool */
 	rc = ssi_ivgen_generate_pool(ivgen_ctx, iv_seq, &iv_seq_len);
-	if (unlikely(rc != 0)) {
+	if (unlikely(rc != 0))
 		return rc;
-	}
+
 	/* Fire-and-forget */
 	return send_request_init(drvdata, iv_seq, iv_seq_len);
 }
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index 8f7d2ec..2a39c12 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -215,9 +215,9 @@ static inline int request_mgr_queues_status_check(
 		return -EBUSY;
 	}
 
-	if ((likely(req_mgr_h->q_free_slots >= total_seq_len))) {
+	if ((likely(req_mgr_h->q_free_slots >= total_seq_len)))
 		return 0;
-	}
+
 	/* Wait for space in HW queue. Poll constant num of iterations. */
 	for (poll_queue = 0; poll_queue < SSI_MAX_POLL_ITER ; poll_queue++) {
 		req_mgr_h->q_free_slots =
@@ -349,9 +349,8 @@ int send_request(
 	}
 
 	used_sw_slots = ((req_mgr_h->req_queue_head - req_mgr_h->req_queue_tail) & (MAX_REQUEST_QUEUE_SIZE - 1));
-	if (unlikely(used_sw_slots > req_mgr_h->max_used_sw_slots)) {
+	if (unlikely(used_sw_slots > req_mgr_h->max_used_sw_slots))
 		req_mgr_h->max_used_sw_slots = used_sw_slots;
-	}
 
 	/* Enqueue request - must be locked with HW lock*/
 	req_mgr_h->req_queue[req_mgr_h->req_queue_head] = *ssi_req;
@@ -412,9 +411,9 @@ int send_request_init(
 
 	/* Wait for space in HW and SW FIFO. Poll for as much as FIFO_TIMEOUT. */
 	rc = request_mgr_queues_status_check(req_mgr_h, cc_base, total_seq_len);
-	if (unlikely(rc != 0)) {
+	if (unlikely(rc != 0))
 		return rc;
-	}
+
 	set_queue_last_ind(&desc[(len - 1)]);
 
 	enqueue_seq(cc_base, desc, len);
@@ -480,23 +479,20 @@ static void proc_completions(struct ssi_drvdata *drvdata)
 			u32 axi_err;
 			int i;
 			SSI_LOG_INFO("Delay\n");
-			for (i = 0; i < 1000000; i++) {
+			for (i = 0; i < 1000000; i++)
 				axi_err = READ_REGISTER(drvdata->cc_base + CC_REG_OFFSET(CRY_KERNEL, AXIM_MON_ERR));
-			}
 		}
 #endif /* COMPLETION_DELAY */
 
-		if (likely(ssi_req->user_cb != NULL)) {
+		if (likely(ssi_req->user_cb != NULL))
 			ssi_req->user_cb(&plat_dev->dev, ssi_req->user_arg, drvdata->cc_base);
-		}
 		request_mgr_handle->req_queue_tail = (request_mgr_handle->req_queue_tail + 1) & (MAX_REQUEST_QUEUE_SIZE - 1);
 		SSI_LOG_DEBUG("Dequeue request tail=%u\n", request_mgr_handle->req_queue_tail);
 		SSI_LOG_DEBUG("Request completed. axi_completed=%d\n", request_mgr_handle->axi_completed);
 #if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
 		rc = ssi_power_mgr_runtime_put_suspend(&plat_dev->dev);
-		if (rc != 0) {
+		if (rc != 0)
 			SSI_LOG_ERR("Failed to set runtime suspension %d\n", rc);
-		}
 #endif
 	}
 }
diff --git a/drivers/staging/ccree/ssi_sysfs.c b/drivers/staging/ccree/ssi_sysfs.c
index db70300..749ec36 100644
--- a/drivers/staging/ccree/ssi_sysfs.c
+++ b/drivers/staging/ccree/ssi_sysfs.c
@@ -316,9 +316,9 @@ static ssize_t ssi_sys_help_show(struct kobject *kobj,
 	int i = 0, offset = 0;
 
 	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "Usage:\n");
-	for (i = 0; i < ARRAY_SIZE(help_str); i += 2) {
+	for (i = 0; i < ARRAY_SIZE(help_str); i += 2)
 	   offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s\t\t%s\n", help_str[i], help_str[i + 1]);
-	}
+
 	return offset;
 }
 
-- 
2.1.4
