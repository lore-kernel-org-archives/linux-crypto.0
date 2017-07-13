From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 04/12] staging: ccree: fix parenthesis alignment
Date: Thu, 13 Jul 2017 11:19:54 +0300
Message-ID: <1499934004-28513-5-git-send-email-gilad@benyossef.com>
References: <1499934004-28513-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-crypto@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
 devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1499934004-28513-1-git-send-email-gilad@benyossef.com>
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

Fix various remaining parenthesis alignment issues.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c        | 46 +++++++++--------
 drivers/staging/ccree/ssi_buffer_mgr.c  | 30 ++++++-----
 drivers/staging/ccree/ssi_cipher.c      |  2 +-
 drivers/staging/ccree/ssi_hash.c        | 88 +++++++++++++++++----------------
 drivers/staging/ccree/ssi_ivgen.c       |  5 +-
 drivers/staging/ccree/ssi_request_mgr.c |  4 +-
 6 files changed, 96 insertions(+), 79 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 43455b9..51a2b73 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -96,7 +96,7 @@ static void ssi_aead_exit(struct crypto_aead *tfm)
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 
 	SSI_LOG_DEBUG("Clearing context @%p for %s\n",
-		crypto_aead_ctx(tfm), crypto_tfm_alg_name(&tfm->base));
+		      crypto_aead_ctx(tfm), crypto_tfm_alg_name(&tfm->base));
 
 	dev = &ctx->drvdata->plat_dev->dev;
 	/* Unmap enckey buffer */
@@ -163,7 +163,7 @@ static int ssi_aead_init(struct crypto_aead *tfm)
 
 	/* Allocate key buffer, cache line aligned */
 	ctx->enckey = dma_alloc_coherent(dev, AES_MAX_KEY_SIZE,
-		&ctx->enckey_dma_addr, GFP_KERNEL);
+					 &ctx->enckey_dma_addr, GFP_KERNEL);
 	if (!ctx->enckey) {
 		SSI_LOG_ERR("Failed allocating key buffer\n");
 		goto init_failed;
@@ -239,7 +239,7 @@ static void ssi_aead_complete(struct device *dev, void *ssi_req, void __iomem *c
 
 	if (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT) {
 		if (memcmp(areq_ctx->mac_buf, areq_ctx->icv_virt_addr,
-			ctx->authsize) != 0) {
+			   ctx->authsize) != 0) {
 			SSI_LOG_DEBUG("Payload authentication failure, "
 				"(auth-size=%d, cipher=%d).\n",
 				ctx->authsize, ctx->cipher_mode);
@@ -378,7 +378,7 @@ static int hmac_setkey(struct cc_hw_desc *desc, struct ssi_aead_ctx *ctx)
 static int validate_keys_sizes(struct ssi_aead_ctx *ctx)
 {
 	SSI_LOG_DEBUG("enc_keylen=%u  authkeylen=%u\n",
-		ctx->enc_keylen, ctx->auth_keylen);
+		      ctx->enc_keylen, ctx->auth_keylen);
 
 	switch (ctx->auth_mode) {
 	case DRV_HASH_SHA1:
@@ -402,7 +402,7 @@ static int validate_keys_sizes(struct ssi_aead_ctx *ctx)
 	if (unlikely(ctx->flow_mode == S_DIN_to_DES)) {
 		if (ctx->enc_keylen != DES3_EDE_KEY_SIZE) {
 			SSI_LOG_ERR("Invalid cipher(3DES) key size: %u\n",
-				ctx->enc_keylen);
+				    ctx->enc_keylen);
 			return -EINVAL;
 		}
 	} else { /* Default assumed to be AES ciphers */
@@ -410,7 +410,7 @@ static int validate_keys_sizes(struct ssi_aead_ctx *ctx)
 		    (ctx->enc_keylen != AES_KEYSIZE_192) &&
 		    (ctx->enc_keylen != AES_KEYSIZE_256)) {
 			SSI_LOG_ERR("Invalid cipher(AES) key size: %u\n",
-				ctx->enc_keylen);
+				    ctx->enc_keylen);
 			return -EINVAL;
 		}
 	}
@@ -553,7 +553,8 @@ ssi_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 	int seq_len = 0, rc = -EINVAL;
 
 	SSI_LOG_DEBUG("Setting key in context @%p for %s. key=%p keylen=%u\n",
-		ctx, crypto_tfm_alg_name(crypto_aead_tfm(tfm)), key, keylen);
+		      ctx, crypto_tfm_alg_name(crypto_aead_tfm(tfm)), key,
+		      keylen);
 
 	/* STAT_PHASE_0: Init and sanity checks */
 
@@ -684,7 +685,7 @@ static int ssi_aead_setauthsize(
 
 #if SSI_CC_HAS_AES_CCM
 static int ssi_rfc4309_ccm_setauthsize(struct crypto_aead *authenc,
-				      unsigned int authsize)
+				       unsigned int authsize)
 {
 	switch (authsize) {
 	case 8:
@@ -699,7 +700,7 @@ static int ssi_rfc4309_ccm_setauthsize(struct crypto_aead *authenc,
 }
 
 static int ssi_ccm_setauthsize(struct crypto_aead *authenc,
-				      unsigned int authsize)
+			       unsigned int authsize)
 {
 	switch (authsize) {
 	case 4:
@@ -1183,7 +1184,7 @@ static inline void ssi_aead_load_mlli_to_sram(
 		(req_ctx->data_buff_type == SSI_DMA_BUF_MLLI) ||
 		!req_ctx->is_single_pass)) {
 		SSI_LOG_DEBUG("Copy-to-sram: mlli_dma=%08x, mlli_size=%u\n",
-			(unsigned int)ctx->drvdata->mlli_sram_addr,
+			      (unsigned int)ctx->drvdata->mlli_sram_addr,
 			req_ctx->mlli_params.mlli_len);
 		/* Copy MLLI table host-to-sram */
 		hw_desc_init(&desc[*seq_size]);
@@ -1328,7 +1329,8 @@ ssi_aead_xcbc_authenc(
 }
 
 static int validate_data_size(struct ssi_aead_ctx *ctx,
-	enum drv_crypto_direction direct, struct aead_request *req)
+			      enum drv_crypto_direction direct,
+			      struct aead_request *req)
 {
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	unsigned int assoclen = req->assoclen;
@@ -1336,7 +1338,7 @@ static int validate_data_size(struct ssi_aead_ctx *ctx,
 			(req->cryptlen - ctx->authsize) : req->cryptlen;
 
 	if (unlikely((direct == DRV_CRYPTO_DIRECTION_DECRYPT) &&
-		(req->cryptlen < ctx->authsize)))
+		     (req->cryptlen < ctx->authsize)))
 		goto data_size_err;
 
 	areq_ctx->is_single_pass = true; /*defaulted to fast flow*/
@@ -1344,7 +1346,7 @@ static int validate_data_size(struct ssi_aead_ctx *ctx,
 	switch (ctx->flow_mode) {
 	case S_DIN_to_AES:
 		if (unlikely((ctx->cipher_mode == DRV_CIPHER_CBC) &&
-			!IS_ALIGNED(cipherlen, AES_BLOCK_SIZE)))
+			     !IS_ALIGNED(cipherlen, AES_BLOCK_SIZE)))
 			goto data_size_err;
 		if (ctx->cipher_mode == DRV_CIPHER_CCM)
 			break;
@@ -1959,15 +1961,17 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 	struct ssi_crypto_req ssi_req = {};
 
 	SSI_LOG_DEBUG("%s context=%p req=%p iv=%p src=%p src_ofs=%d dst=%p dst_ofs=%d cryptolen=%d\n",
-		((direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ? "Encrypt" : "Decrypt"), ctx, req, req->iv,
-		sg_virt(req->src), req->src->offset, sg_virt(req->dst), req->dst->offset, req->cryptlen);
+		      ((direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ?
+		       "Encrypt" : "Decrypt"), ctx, req, req->iv,
+		      sg_virt(req->src), req->src->offset, sg_virt(req->dst),
+		      req->dst->offset, req->cryptlen);
 
 	/* STAT_PHASE_0: Init and sanity checks */
 
 	/* Check data length according to mode */
 	if (unlikely(validate_data_size(ctx, direct, req) != 0)) {
 		SSI_LOG_ERR("Unsupported crypt/assoc len %d/%d.\n",
-				req->cryptlen, req->assoclen);
+			    req->cryptlen, req->assoclen);
 		crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_BLOCK_LEN);
 		return -EINVAL;
 	}
@@ -1990,7 +1994,7 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 		memcpy(areq_ctx->ctr_iv, ctx->ctr_nonce, CTR_RFC3686_NONCE_SIZE);
 		if (!areq_ctx->backup_giv) /*User none-generated IV*/
 			memcpy(areq_ctx->ctr_iv + CTR_RFC3686_NONCE_SIZE,
-				req->iv, CTR_RFC3686_IV_SIZE);
+			       req->iv, CTR_RFC3686_IV_SIZE);
 		/* Initialize counter portion of counter block */
 		*(__be32 *)(areq_ctx->ctr_iv + CTR_RFC3686_NONCE_SIZE +
 			    CTR_RFC3686_IV_SIZE) = cpu_to_be32(1);
@@ -2244,7 +2248,7 @@ static int ssi_rfc4543_gcm_setkey(struct crypto_aead *tfm, const u8 *key, unsign
 }
 
 static int ssi_gcm_setauthsize(struct crypto_aead *authenc,
-				      unsigned int authsize)
+			       unsigned int authsize)
 {
 	switch (authsize) {
 	case 4:
@@ -2263,7 +2267,7 @@ static int ssi_gcm_setauthsize(struct crypto_aead *authenc,
 }
 
 static int ssi_rfc4106_gcm_setauthsize(struct crypto_aead *authenc,
-				      unsigned int authsize)
+				       unsigned int authsize)
 {
 	SSI_LOG_DEBUG("ssi_rfc4106_gcm_setauthsize()  authsize %d\n", authsize);
 
@@ -2734,14 +2738,14 @@ int ssi_aead_alloc(struct ssi_drvdata *drvdata)
 		if (IS_ERR(t_alg)) {
 			rc = PTR_ERR(t_alg);
 			SSI_LOG_ERR("%s alg allocation failed\n",
-				 aead_algs[alg].driver_name);
+				    aead_algs[alg].driver_name);
 			goto fail1;
 		}
 		t_alg->drvdata = drvdata;
 		rc = crypto_register_aead(&t_alg->aead_alg);
 		if (unlikely(rc != 0)) {
 			SSI_LOG_ERR("%s alg registration failed\n",
-				t_alg->aead_alg.base.cra_driver_name);
+				    t_alg->aead_alg.base.cra_driver_name);
 			goto fail2;
 		} else {
 			list_add_tail(&t_alg->entry, &aead_handle->aead_list);
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index dcd78f6..c3960d1 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -370,7 +370,7 @@ static int ssi_buffer_mgr_map_scatterlist(
 		*mapped_nents = 1;
 	} else {  /*sg_is_last*/
 		*nents = ssi_buffer_mgr_get_sgl_nents(sg, nbytes, lbytes,
-						     &is_chained);
+						      &is_chained);
 		if (*nents > max_sg_nents) {
 			*nents = 0;
 			SSI_LOG_ERR("Too many fragments. current %d max %d\n",
@@ -392,7 +392,7 @@ static int ssi_buffer_mgr_map_scatterlist(
 			 * must have the same nents before and after map
 			 */
 			*mapped_nents = ssi_buffer_mgr_dma_map_sg(dev,
-								 sg,
+								  sg,
 								 *nents,
 								 direction);
 			if (unlikely(*mapped_nents != *nents)) {
@@ -783,7 +783,7 @@ static inline int ssi_buffer_mgr_aead_chain_iv(
 	}
 
 	areq_ctx->gen_ctx.iv_dma_addr = dma_map_single(dev, req->iv,
-		hw_iv_size, DMA_BIDIRECTIONAL);
+						       hw_iv_size, DMA_BIDIRECTIONAL);
 	if (unlikely(dma_mapping_error(dev, areq_ctx->gen_ctx.iv_dma_addr))) {
 		SSI_LOG_ERR("Mapping iv %u B at va=%pK for DMA failed\n",
 			    hw_iv_size, req->iv);
@@ -1322,8 +1322,9 @@ int ssi_buffer_mgr_map_aead_request(
 				req->cryptlen :
 				(req->cryptlen - authsize);
 
-	areq_ctx->mac_buf_dma_addr = dma_map_single(dev,
-		areq_ctx->mac_buf, MAX_MAC_SIZE, DMA_BIDIRECTIONAL);
+	areq_ctx->mac_buf_dma_addr = dma_map_single(dev, areq_ctx->mac_buf,
+						    MAX_MAC_SIZE,
+						    DMA_BIDIRECTIONAL);
 	if (unlikely(dma_mapping_error(dev, areq_ctx->mac_buf_dma_addr))) {
 		SSI_LOG_ERR("Mapping mac_buf %u B at va=%pK for DMA failed\n",
 			    MAX_MAC_SIZE, areq_ctx->mac_buf);
@@ -1333,8 +1334,10 @@ int ssi_buffer_mgr_map_aead_request(
 
 	if (areq_ctx->ccm_hdr_size != ccm_header_size_null) {
 		areq_ctx->ccm_iv0_dma_addr = dma_map_single(dev,
-			(areq_ctx->ccm_config + CCM_CTR_COUNT_0_OFFSET),
-			AES_BLOCK_SIZE, DMA_TO_DEVICE);
+							    (areq_ctx->ccm_config +
+							     CCM_CTR_COUNT_0_OFFSET),
+							    AES_BLOCK_SIZE,
+							    DMA_TO_DEVICE);
 
 		if (unlikely(dma_mapping_error(dev, areq_ctx->ccm_iv0_dma_addr))) {
 			SSI_LOG_ERR("Mapping mac_buf %u B at va=%pK "
@@ -1355,7 +1358,9 @@ int ssi_buffer_mgr_map_aead_request(
 #if SSI_CC_HAS_AES_GCM
 	if (areq_ctx->cipher_mode == DRV_CIPHER_GCTR) {
 		areq_ctx->hkey_dma_addr = dma_map_single(dev,
-			areq_ctx->hkey, AES_BLOCK_SIZE, DMA_BIDIRECTIONAL);
+							 areq_ctx->hkey,
+							 AES_BLOCK_SIZE,
+							 DMA_BIDIRECTIONAL);
 		if (unlikely(dma_mapping_error(dev, areq_ctx->hkey_dma_addr))) {
 			SSI_LOG_ERR("Mapping hkey %u B at va=%pK for DMA failed\n",
 				    AES_BLOCK_SIZE, areq_ctx->hkey);
@@ -1364,7 +1369,7 @@ int ssi_buffer_mgr_map_aead_request(
 		}
 
 		areq_ctx->gcm_block_len_dma_addr = dma_map_single(dev,
-			&areq_ctx->gcm_len_block, AES_BLOCK_SIZE, DMA_TO_DEVICE);
+								  &areq_ctx->gcm_len_block, AES_BLOCK_SIZE, DMA_TO_DEVICE);
 		if (unlikely(dma_mapping_error(dev, areq_ctx->gcm_block_len_dma_addr))) {
 			SSI_LOG_ERR("Mapping gcm_len_block %u B at va=%pK for DMA failed\n",
 				    AES_BLOCK_SIZE, &areq_ctx->gcm_len_block);
@@ -1373,7 +1378,7 @@ int ssi_buffer_mgr_map_aead_request(
 		}
 
 		areq_ctx->gcm_iv_inc1_dma_addr = dma_map_single(dev,
-			areq_ctx->gcm_iv_inc1,
+								areq_ctx->gcm_iv_inc1,
 			AES_BLOCK_SIZE, DMA_TO_DEVICE);
 
 		if (unlikely(dma_mapping_error(dev, areq_ctx->gcm_iv_inc1_dma_addr))) {
@@ -1386,8 +1391,9 @@ int ssi_buffer_mgr_map_aead_request(
 		}
 
 		areq_ctx->gcm_iv_inc2_dma_addr = dma_map_single(dev,
-			areq_ctx->gcm_iv_inc2,
-			AES_BLOCK_SIZE, DMA_TO_DEVICE);
+								areq_ctx->gcm_iv_inc2,
+								AES_BLOCK_SIZE,
+								DMA_TO_DEVICE);
 
 		if (unlikely(dma_mapping_error(dev, areq_ctx->gcm_iv_inc2_dma_addr))) {
 			SSI_LOG_ERR("Mapping gcm_iv_inc2 %u B at va=%pK "
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 10be927..06ee66d 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -203,7 +203,7 @@ static int ssi_blkcipher_init(struct crypto_tfm *tfm)
 
 	/* Map key buffer */
 	ctx_p->user.key_dma_addr = dma_map_single(dev, (void *)ctx_p->user.key,
-					     max_key_buf_size, DMA_TO_DEVICE);
+						  max_key_buf_size, DMA_TO_DEVICE);
 	if (dma_mapping_error(dev, ctx_p->user.key_dma_addr)) {
 		SSI_LOG_ERR("Mapping Key %u B at va=%pK for DMA failed\n",
 			    max_key_buf_size, ctx_p->user.key);
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 658e198..2f70761 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -64,14 +64,13 @@ static const u64 sha512_init[] = {
 	SHA512_H3, SHA512_H2, SHA512_H1, SHA512_H0 };
 #endif
 
-static void ssi_hash_create_xcbc_setup(
-	struct ahash_request *areq,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size);
+static void ssi_hash_create_xcbc_setup(struct ahash_request *areq,
+				       struct cc_hw_desc desc[],
+				       unsigned int *seq_size);
 
 static void ssi_hash_create_cmac_setup(struct ahash_request *areq,
-				  struct cc_hw_desc desc[],
-				  unsigned int *seq_size);
+				       struct cc_hw_desc desc[],
+				       unsigned int *seq_size);
 
 struct ssi_hash_alg {
 	struct list_head entry;
@@ -117,7 +116,7 @@ static void ssi_hash_create_data_desc(
 static inline void ssi_set_hash_endianity(u32 mode, struct cc_hw_desc *desc)
 {
 	if (unlikely((mode == DRV_HASH_MD5) ||
-		(mode == DRV_HASH_SHA384) ||
+		     (mode == DRV_HASH_SHA384) ||
 		(mode == DRV_HASH_SHA512))) {
 		set_bytes_swap(desc, 1);
 	} else {
@@ -135,7 +134,7 @@ static int ssi_hash_map_result(struct device *dev,
 			       DMA_BIDIRECTIONAL);
 	if (unlikely(dma_mapping_error(dev, state->digest_result_dma_addr))) {
 		SSI_LOG_ERR("Mapping digest result buffer %u B for DMA failed\n",
-			digestsize);
+			    digestsize);
 		return -ENOMEM;
 	}
 	SSI_LOG_DEBUG("Mapped digest result buffer %u B "
@@ -200,11 +199,11 @@ static int ssi_hash_map_request(struct device *dev,
 	state->digest_buff_dma_addr = dma_map_single(dev, (void *)state->digest_buff, ctx->inter_digestsize, DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(dev, state->digest_buff_dma_addr)) {
 		SSI_LOG_ERR("Mapping digest len %d B at va=%pK for DMA failed\n",
-		ctx->inter_digestsize, state->digest_buff);
+			    ctx->inter_digestsize, state->digest_buff);
 		goto fail3;
 	}
 	SSI_LOG_DEBUG("Mapped digest %d B at va=%pK to dma=%pad\n",
-		ctx->inter_digestsize, state->digest_buff,
+		      ctx->inter_digestsize, state->digest_buff,
 		state->digest_buff_dma_addr);
 
 	if (is_hmac) {
@@ -249,11 +248,11 @@ static int ssi_hash_map_request(struct device *dev,
 		state->digest_bytes_len_dma_addr = dma_map_single(dev, (void *)state->digest_bytes_len, HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
 		if (dma_mapping_error(dev, state->digest_bytes_len_dma_addr)) {
 			SSI_LOG_ERR("Mapping digest len %u B at va=%pK for DMA failed\n",
-			HASH_LEN_SIZE, state->digest_bytes_len);
+				    HASH_LEN_SIZE, state->digest_bytes_len);
 			goto fail4;
 		}
 		SSI_LOG_DEBUG("Mapped digest len %u B at va=%pK to dma=%pad\n",
-			HASH_LEN_SIZE, state->digest_bytes_len,
+			      HASH_LEN_SIZE, state->digest_bytes_len,
 			state->digest_bytes_len_dma_addr);
 	} else {
 		state->digest_bytes_len_dma_addr = 0;
@@ -263,11 +262,12 @@ static int ssi_hash_map_request(struct device *dev,
 		state->opad_digest_dma_addr = dma_map_single(dev, (void *)state->opad_digest_buff, ctx->inter_digestsize, DMA_BIDIRECTIONAL);
 		if (dma_mapping_error(dev, state->opad_digest_dma_addr)) {
 			SSI_LOG_ERR("Mapping opad digest %d B at va=%pK for DMA failed\n",
-			ctx->inter_digestsize, state->opad_digest_buff);
+				    ctx->inter_digestsize,
+				    state->opad_digest_buff);
 			goto fail5;
 		}
 		SSI_LOG_DEBUG("Mapped opad digest %d B at va=%pK to dma=%pad\n",
-			ctx->inter_digestsize, state->opad_digest_buff,
+			      ctx->inter_digestsize, state->opad_digest_buff,
 			state->opad_digest_dma_addr);
 	} else {
 		state->opad_digest_dma_addr = 0;
@@ -602,7 +602,7 @@ static int ssi_hash_update(struct ahash_req_ctx *state,
 	if (unlikely(rc)) {
 		if (rc == 1) {
 			SSI_LOG_DEBUG(" data size not require HW update %x\n",
-				     nbytes);
+				      nbytes);
 			/* No hardware updates are required */
 			return 0;
 		}
@@ -1145,17 +1145,17 @@ static int ssi_hash_setkey(void *hash,
 
 	if (ctx->key_params.key_dma_addr) {
 		dma_unmap_single(&ctx->drvdata->plat_dev->dev,
-				ctx->key_params.key_dma_addr,
+				 ctx->key_params.key_dma_addr,
 				ctx->key_params.keylen, DMA_TO_DEVICE);
 		SSI_LOG_DEBUG("Unmapped key-buffer: key_dma_addr=%pad keylen=%u\n",
-				ctx->key_params.key_dma_addr,
+			      ctx->key_params.key_dma_addr,
 				ctx->key_params.keylen);
 	}
 	return rc;
 }
 
 static int ssi_xcbc_setkey(struct crypto_ahash *ahash,
-			const u8 *key, unsigned int keylen)
+			   const u8 *key, unsigned int keylen)
 {
 	struct ssi_crypto_req ssi_req = {};
 	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(ahash);
@@ -1232,10 +1232,10 @@ static int ssi_xcbc_setkey(struct crypto_ahash *ahash,
 		crypto_ahash_set_flags(ahash, CRYPTO_TFM_RES_BAD_KEY_LEN);
 
 	dma_unmap_single(&ctx->drvdata->plat_dev->dev,
-			ctx->key_params.key_dma_addr,
+			 ctx->key_params.key_dma_addr,
 			ctx->key_params.keylen, DMA_TO_DEVICE);
 	SSI_LOG_DEBUG("Unmapped key-buffer: key_dma_addr=%pad keylen=%u\n",
-			ctx->key_params.key_dma_addr,
+		      ctx->key_params.key_dma_addr,
 			ctx->key_params.keylen);
 
 	return rc;
@@ -1243,7 +1243,7 @@ static int ssi_xcbc_setkey(struct crypto_ahash *ahash,
 
 #if SSI_CC_HAS_CMAC
 static int ssi_cmac_setkey(struct crypto_ahash *ahash,
-			const u8 *key, unsigned int keylen)
+			   const u8 *key, unsigned int keylen)
 {
 	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 
@@ -1316,22 +1316,22 @@ static int ssi_hash_alloc_ctx(struct ssi_hash_ctx *ctx)
 	ctx->digest_buff_dma_addr = dma_map_single(dev, (void *)ctx->digest_buff, sizeof(ctx->digest_buff), DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(dev, ctx->digest_buff_dma_addr)) {
 		SSI_LOG_ERR("Mapping digest len %zu B at va=%pK for DMA failed\n",
-			sizeof(ctx->digest_buff), ctx->digest_buff);
+			    sizeof(ctx->digest_buff), ctx->digest_buff);
 		goto fail;
 	}
 	SSI_LOG_DEBUG("Mapped digest %zu B at va=%pK to dma=%pad\n",
-		sizeof(ctx->digest_buff), ctx->digest_buff,
+		      sizeof(ctx->digest_buff), ctx->digest_buff,
 		      ctx->digest_buff_dma_addr);
 
 	ctx->opad_tmp_keys_dma_addr = dma_map_single(dev, (void *)ctx->opad_tmp_keys_buff, sizeof(ctx->opad_tmp_keys_buff), DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(dev, ctx->opad_tmp_keys_dma_addr)) {
 		SSI_LOG_ERR("Mapping opad digest %zu B at va=%pK for DMA failed\n",
-			sizeof(ctx->opad_tmp_keys_buff),
+			    sizeof(ctx->opad_tmp_keys_buff),
 			ctx->opad_tmp_keys_buff);
 		goto fail;
 	}
 	SSI_LOG_DEBUG("Mapped opad_tmp_keys %zu B at va=%pK to dma=%pad\n",
-		sizeof(ctx->opad_tmp_keys_buff), ctx->opad_tmp_keys_buff,
+		      sizeof(ctx->opad_tmp_keys_buff), ctx->opad_tmp_keys_buff,
 		      ctx->opad_tmp_keys_dma_addr);
 
 	ctx->is_hmac = false;
@@ -1353,7 +1353,7 @@ static int ssi_ahash_cra_init(struct crypto_tfm *tfm)
 			container_of(ahash_alg, struct ssi_hash_alg, ahash_alg);
 
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
-				sizeof(struct ahash_req_ctx));
+				 sizeof(struct ahash_req_ctx));
 
 	ctx->hash_mode = ssi_alg->hash_mode;
 	ctx->hw_mode = ssi_alg->hw_mode;
@@ -1394,7 +1394,7 @@ static int ssi_mac_update(struct ahash_request *req)
 	if (unlikely(rc)) {
 		if (rc == 1) {
 			SSI_LOG_DEBUG(" data size not require HW update %x\n",
-				     req->nbytes);
+				      req->nbytes);
 			/* No hardware updates are required */
 			return 0;
 		}
@@ -1836,7 +1836,7 @@ static int ssi_ahash_import(struct ahash_request *req, const void *in)
 }
 
 static int ssi_ahash_setkey(struct crypto_ahash *ahash,
-			const u8 *key, unsigned int keylen)
+			    const u8 *key, unsigned int keylen)
 {
 	return ssi_hash_setkey((void *)ahash, key, keylen, false);
 }
@@ -2118,7 +2118,8 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 
 	/* Copy-to-sram digest-len */
 	ssi_sram_mgr_const2sram_desc(digest_len_init, sram_buff_ofs,
-		ARRAY_SIZE(digest_len_init), larval_seq, &larval_seq_len);
+				     ARRAY_SIZE(digest_len_init), larval_seq,
+				     &larval_seq_len);
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
 	if (unlikely(rc != 0))
 		goto init_digest_const_err;
@@ -2129,7 +2130,8 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 #if (DX_DEV_SHA_MAX > 256)
 	/* Copy-to-sram digest-len for sha384/512 */
 	ssi_sram_mgr_const2sram_desc(digest_len_sha512_init, sram_buff_ofs,
-		ARRAY_SIZE(digest_len_sha512_init), larval_seq, &larval_seq_len);
+				     ARRAY_SIZE(digest_len_sha512_init),
+				     larval_seq, &larval_seq_len);
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
 	if (unlikely(rc != 0))
 		goto init_digest_const_err;
@@ -2143,7 +2145,8 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 
 	/* Copy-to-sram initial SHA* digests */
 	ssi_sram_mgr_const2sram_desc(md5_init, sram_buff_ofs,
-		ARRAY_SIZE(md5_init), larval_seq, &larval_seq_len);
+				     ARRAY_SIZE(md5_init), larval_seq,
+				     &larval_seq_len);
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
 	if (unlikely(rc != 0))
 		goto init_digest_const_err;
@@ -2151,7 +2154,8 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 	larval_seq_len = 0;
 
 	ssi_sram_mgr_const2sram_desc(sha1_init, sram_buff_ofs,
-		ARRAY_SIZE(sha1_init), larval_seq, &larval_seq_len);
+				     ARRAY_SIZE(sha1_init), larval_seq,
+				     &larval_seq_len);
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
 	if (unlikely(rc != 0))
 		goto init_digest_const_err;
@@ -2159,7 +2163,7 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 	larval_seq_len = 0;
 
 	ssi_sram_mgr_const2sram_desc(sha224_init, sram_buff_ofs,
-		ARRAY_SIZE(sha224_init), larval_seq, &larval_seq_len);
+				     ARRAY_SIZE(sha224_init), larval_seq, &larval_seq_len);
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
 	if (unlikely(rc != 0))
 		goto init_digest_const_err;
@@ -2167,7 +2171,7 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 	larval_seq_len = 0;
 
 	ssi_sram_mgr_const2sram_desc(sha256_init, sram_buff_ofs,
-		ARRAY_SIZE(sha256_init), larval_seq, &larval_seq_len);
+				     ARRAY_SIZE(sha256_init), larval_seq, &larval_seq_len);
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
 	if (unlikely(rc != 0))
 		goto init_digest_const_err;
@@ -2181,10 +2185,10 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 		const u32 const1 = ((u32 *)((u64 *)&sha384_init[i]))[0];
 
 		ssi_sram_mgr_const2sram_desc(&const0, sram_buff_ofs, 1,
-			larval_seq, &larval_seq_len);
+					     larval_seq, &larval_seq_len);
 		sram_buff_ofs += sizeof(u32);
 		ssi_sram_mgr_const2sram_desc(&const1, sram_buff_ofs, 1,
-			larval_seq, &larval_seq_len);
+					     larval_seq, &larval_seq_len);
 		sram_buff_ofs += sizeof(u32);
 	}
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
@@ -2199,10 +2203,10 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 		const u32 const1 = ((u32 *)((u64 *)&sha512_init[i]))[0];
 
 		ssi_sram_mgr_const2sram_desc(&const0, sram_buff_ofs, 1,
-			larval_seq, &larval_seq_len);
+					     larval_seq, &larval_seq_len);
 		sram_buff_ofs += sizeof(u32);
 		ssi_sram_mgr_const2sram_desc(&const1, sram_buff_ofs, 1,
-			larval_seq, &larval_seq_len);
+					     larval_seq, &larval_seq_len);
 		sram_buff_ofs += sizeof(u32);
 	}
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
@@ -2227,7 +2231,7 @@ int ssi_hash_alloc(struct ssi_drvdata *drvdata)
 	hash_handle = kzalloc(sizeof(struct ssi_hash_handle), GFP_KERNEL);
 	if (!hash_handle) {
 		SSI_LOG_ERR("kzalloc failed to allocate %zu B\n",
-			sizeof(struct ssi_hash_handle));
+			    sizeof(struct ssi_hash_handle));
 		rc = -ENOMEM;
 		goto fail;
 	}
@@ -2299,7 +2303,7 @@ int ssi_hash_alloc(struct ssi_drvdata *drvdata)
 		if (IS_ERR(t_alg)) {
 			rc = PTR_ERR(t_alg);
 			SSI_LOG_ERR("%s alg allocation failed\n",
-				 driver_hash[alg].driver_name);
+				    driver_hash[alg].driver_name);
 			goto fail;
 		}
 		t_alg->drvdata = drvdata;
@@ -2345,7 +2349,7 @@ int ssi_hash_free(struct ssi_drvdata *drvdata)
 }
 
 static void ssi_hash_create_xcbc_setup(struct ahash_request *areq,
-				  struct cc_hw_desc desc[],
+				       struct cc_hw_desc desc[],
 				  unsigned int *seq_size)
 {
 	unsigned int idx = *seq_size;
@@ -2403,7 +2407,7 @@ static void ssi_hash_create_xcbc_setup(struct ahash_request *areq,
 }
 
 static void ssi_hash_create_cmac_setup(struct ahash_request *areq,
-				  struct cc_hw_desc desc[],
+				       struct cc_hw_desc desc[],
 				  unsigned int *seq_size)
 {
 	unsigned int idx = *seq_size;
diff --git a/drivers/staging/ccree/ssi_ivgen.c b/drivers/staging/ccree/ssi_ivgen.c
index 025bff5..d2123b7 100644
--- a/drivers/staging/ccree/ssi_ivgen.c
+++ b/drivers/staging/ccree/ssi_ivgen.c
@@ -166,7 +166,8 @@ void ssi_ivgen_fini(struct ssi_drvdata *drvdata)
 	if (ivgen_ctx->pool_meta) {
 		memset(ivgen_ctx->pool_meta, 0, SSI_IVPOOL_META_SIZE);
 		dma_free_coherent(device, SSI_IVPOOL_META_SIZE,
-			ivgen_ctx->pool_meta, ivgen_ctx->pool_meta_dma);
+				  ivgen_ctx->pool_meta,
+				  ivgen_ctx->pool_meta_dma);
 	}
 
 	ivgen_ctx->pool = NULL_SRAM_ADDR;
@@ -201,7 +202,7 @@ int ssi_ivgen_init(struct ssi_drvdata *drvdata)
 
 	/* Allocate pool's header for intial enc. key/IV */
 	ivgen_ctx->pool_meta = dma_alloc_coherent(device, SSI_IVPOOL_META_SIZE,
-			&ivgen_ctx->pool_meta_dma, GFP_KERNEL);
+						  &ivgen_ctx->pool_meta_dma, GFP_KERNEL);
 	if (!ivgen_ctx->pool_meta) {
 		SSI_LOG_ERR("Not enough memory to allocate DMA of pool_meta "
 			   "(%u B)\n", SSI_IVPOOL_META_SIZE);
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index 3f39150..2eda82f 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -136,7 +136,9 @@ int request_mgr_init(struct ssi_drvdata *drvdata)
 
 	/* Allocate DMA word for "dummy" completion descriptor use */
 	req_mgr_h->dummy_comp_buff = dma_alloc_coherent(&drvdata->plat_dev->dev,
-		sizeof(u32), &req_mgr_h->dummy_comp_buff_dma, GFP_KERNEL);
+							sizeof(u32),
+							&req_mgr_h->dummy_comp_buff_dma,
+							GFP_KERNEL);
 	if (!req_mgr_h->dummy_comp_buff) {
 		SSI_LOG_ERR("Not enough memory to allocate DMA (%zu) dropped "
 			   "buffer\n", sizeof(u32));
-- 
2.1.4
