From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 15/22] staging: ccree: fix line indentation and breaks
Date: Tue, 15 Aug 2017 09:26:43 +0300
Message-ID: <1502778412-16255-16-git-send-email-gilad@benyossef.com>
References: <1502778412-16255-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502778412-16255-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Fix source line indentation and breaks in ssi_aead.c

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c | 1024 ++++++++++++++++++++------------------
 1 file changed, 532 insertions(+), 492 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 03533c8..515a603 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -101,7 +101,8 @@ static void ssi_aead_exit(struct crypto_aead *tfm)
 	dev = &ctx->drvdata->plat_dev->dev;
 	/* Unmap enckey buffer */
 	if (ctx->enckey) {
-		dma_free_coherent(dev, AES_MAX_KEY_SIZE, ctx->enckey, ctx->enckey_dma_addr);
+		dma_free_coherent(dev, AES_MAX_KEY_SIZE, ctx->enckey,
+				  ctx->enckey_dma_addr);
 		SSI_LOG_DEBUG("Freed enckey DMA buffer enckey_dma_addr=%pad\n",
 			      &ctx->enckey_dma_addr);
 		ctx->enckey_dma_addr = 0;
@@ -116,8 +117,9 @@ static void ssi_aead_exit(struct crypto_aead *tfm)
 					  xcbc->xcbc_keys,
 					  xcbc->xcbc_keys_dma_addr);
 		}
-		SSI_LOG_DEBUG("Freed xcbc_keys DMA buffer xcbc_keys_dma_addr=%pad\n",
-			      &xcbc->xcbc_keys_dma_addr);
+		SSI_LOG_DEBUG
+		    ("Freed xcbc_keys DMA buffer xcbc_keys_dma_addr=%pad\n",
+		     &xcbc->xcbc_keys_dma_addr);
 		xcbc->xcbc_keys_dma_addr = 0;
 		xcbc->xcbc_keys = NULL;
 	} else if (ctx->auth_mode != DRV_HASH_NULL) { /* HMAC auth. */
@@ -127,8 +129,9 @@ static void ssi_aead_exit(struct crypto_aead *tfm)
 			dma_free_coherent(dev, 2 * MAX_HMAC_DIGEST_SIZE,
 					  hmac->ipad_opad,
 					  hmac->ipad_opad_dma_addr);
-			SSI_LOG_DEBUG("Freed ipad_opad DMA buffer ipad_opad_dma_addr=%pad\n",
-				      &hmac->ipad_opad_dma_addr);
+			SSI_LOG_DEBUG
+			    ("Freed ipad_opad DMA buffer ipad_opad_dma_addr=%pad\n",
+			     &hmac->ipad_opad_dma_addr);
 			hmac->ipad_opad_dma_addr = 0;
 			hmac->ipad_opad = NULL;
 		}
@@ -136,8 +139,9 @@ static void ssi_aead_exit(struct crypto_aead *tfm)
 			dma_free_coherent(dev, MAX_HMAC_BLOCK_SIZE,
 					  hmac->padded_authkey,
 					  hmac->padded_authkey_dma_addr);
-			SSI_LOG_DEBUG("Freed padded_authkey DMA buffer padded_authkey_dma_addr=%pad\n",
-				      &hmac->padded_authkey_dma_addr);
+			SSI_LOG_DEBUG
+			    ("Freed padded_authkey DMA buffer padded_authkey_dma_addr=%pad\n",
+			     &hmac->padded_authkey_dma_addr);
 			hmac->padded_authkey_dma_addr = 0;
 			hmac->padded_authkey = NULL;
 		}
@@ -150,8 +154,9 @@ static int ssi_aead_init(struct crypto_aead *tfm)
 	struct aead_alg *alg = crypto_aead_alg(tfm);
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct ssi_crypto_alg *ssi_alg =
-			container_of(alg, struct ssi_crypto_alg, aead_alg);
-	SSI_LOG_DEBUG("Initializing context @%p for %s\n", ctx, crypto_tfm_alg_name(&tfm->base));
+	    container_of(alg, struct ssi_crypto_alg, aead_alg);
+	SSI_LOG_DEBUG("Initializing context @%p for %s\n", ctx,
+		      crypto_tfm_alg_name(&tfm->base));
 
 	/* Initialize modes in instance */
 	ctx->cipher_mode = ssi_alg->cipher_mode;
@@ -168,7 +173,8 @@ static int ssi_aead_init(struct crypto_aead *tfm)
 		SSI_LOG_ERR("Failed allocating key buffer\n");
 		goto init_failed;
 	}
-	SSI_LOG_DEBUG("Allocated enckey buffer in context ctx->enckey=@%p\n", ctx->enckey);
+	SSI_LOG_DEBUG("Allocated enckey buffer in context ctx->enckey=@%p\n",
+		      ctx->enckey);
 
 	/* Set default authlen value */
 
@@ -200,13 +206,13 @@ static int ssi_aead_init(struct crypto_aead *tfm)
 			goto init_failed;
 		}
 
-		SSI_LOG_DEBUG("Allocated authkey buffer in context ctx->authkey=@%p\n",
-			      hmac->ipad_opad);
+		SSI_LOG_DEBUG
+		    ("Allocated authkey buffer in context ctx->authkey=@%p\n",
+		     hmac->ipad_opad);
 
 		hmac->padded_authkey = dma_alloc_coherent(dev,
 							  MAX_HMAC_BLOCK_SIZE,
-							  pkey_dma,
-							  GFP_KERNEL);
+							  pkey_dma, GFP_KERNEL);
 
 		if (!hmac->padded_authkey) {
 			SSI_LOG_ERR("failed to allocate padded_authkey\n");
@@ -224,7 +230,8 @@ static int ssi_aead_init(struct crypto_aead *tfm)
 	return -ENOMEM;
 }
 
-static void ssi_aead_complete(struct device *dev, void *ssi_req, void __iomem *cc_base)
+static void ssi_aead_complete(struct device *dev, void *ssi_req,
+			      void __iomem *cc_base)
 {
 	struct aead_request *areq = (struct aead_request *)ssi_req;
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(areq);
@@ -240,8 +247,9 @@ static void ssi_aead_complete(struct device *dev, void *ssi_req, void __iomem *c
 	if (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT) {
 		if (memcmp(areq_ctx->mac_buf, areq_ctx->icv_virt_addr,
 			   ctx->authsize) != 0) {
-			SSI_LOG_DEBUG("Payload authentication failure, (auth-size=%d, cipher=%d).\n",
-				      ctx->authsize, ctx->cipher_mode);
+			SSI_LOG_DEBUG
+			    ("Payload authentication failure, (auth-size=%d, cipher=%d).\n",
+			     ctx->authsize, ctx->cipher_mode);
 			/* In case of payload authentication failure, MUST NOT
 			 * revealed the decrypted message --> zero its memory.
 			 */
@@ -250,16 +258,26 @@ static void ssi_aead_complete(struct device *dev, void *ssi_req, void __iomem *c
 		}
 	} else { /*ENCRYPT*/
 		if (unlikely(areq_ctx->is_icv_fragmented))
-			ssi_buffer_mgr_copy_scatterlist_portion(
-				areq_ctx->mac_buf, areq_ctx->dst_sgl, areq->cryptlen + areq_ctx->dst_offset,
-				areq->cryptlen + areq_ctx->dst_offset + ctx->authsize, SSI_SG_FROM_BUF);
+			ssi_buffer_mgr_copy_scatterlist_portion(areq_ctx->mac_buf,
+								areq_ctx->dst_sgl,
+								areq->cryptlen +
+								areq_ctx->dst_offset,
+								areq->cryptlen +
+								areq_ctx->dst_offset +
+								ctx->authsize,
+								SSI_SG_FROM_BUF);
 
 		/* If an IV was generated, copy it back to the user provided buffer. */
 		if (areq_ctx->backup_giv) {
 			if (ctx->cipher_mode == DRV_CIPHER_CTR)
-				memcpy(areq_ctx->backup_giv, areq_ctx->ctr_iv + CTR_RFC3686_NONCE_SIZE, CTR_RFC3686_IV_SIZE);
+				memcpy(areq_ctx->backup_giv,
+				       areq_ctx->ctr_iv +
+				       CTR_RFC3686_NONCE_SIZE,
+				       CTR_RFC3686_IV_SIZE);
 			else if (ctx->cipher_mode == DRV_CIPHER_CCM)
-				memcpy(areq_ctx->backup_giv, areq_ctx->ctr_iv + CCM_BLOCK_IV_OFFSET, CCM_BLOCK_IV_SIZE);
+				memcpy(areq_ctx->backup_giv,
+				       areq_ctx->ctr_iv + CCM_BLOCK_IV_OFFSET,
+				       CCM_BLOCK_IV_SIZE);
 		}
 	}
 
@@ -292,15 +310,15 @@ static int xcbc_setkey(struct cc_hw_desc *desc, struct ssi_aead_ctx *ctx)
 	set_din_const(&desc[2], 0x02020202, CC_AES_128_BIT_KEY_SIZE);
 	set_flow_mode(&desc[2], DIN_AES_DOUT);
 	set_dout_dlli(&desc[2], (ctx->auth_state.xcbc.xcbc_keys_dma_addr
-					 + AES_KEYSIZE_128),
-			      AES_KEYSIZE_128, NS_BIT, 0);
+				 + AES_KEYSIZE_128),
+		      AES_KEYSIZE_128, NS_BIT, 0);
 
 	hw_desc_init(&desc[3]);
 	set_din_const(&desc[3], 0x03030303, CC_AES_128_BIT_KEY_SIZE);
 	set_flow_mode(&desc[3], DIN_AES_DOUT);
 	set_dout_dlli(&desc[3], (ctx->auth_state.xcbc.xcbc_keys_dma_addr
-					  + 2 * AES_KEYSIZE_128),
-			      AES_KEYSIZE_128, NS_BIT, 0);
+				 + 2 * AES_KEYSIZE_128),
+		      AES_KEYSIZE_128, NS_BIT, 0);
 
 	return 4;
 }
@@ -310,9 +328,9 @@ static int hmac_setkey(struct cc_hw_desc *desc, struct ssi_aead_ctx *ctx)
 	unsigned int hmac_pad_const[2] = { HMAC_IPAD_CONST, HMAC_OPAD_CONST };
 	unsigned int digest_ofs = 0;
 	unsigned int hash_mode = (ctx->auth_mode == DRV_HASH_SHA1) ?
-			DRV_HASH_HW_SHA1 : DRV_HASH_HW_SHA256;
+	    DRV_HASH_HW_SHA1 : DRV_HASH_HW_SHA256;
 	unsigned int digest_size = (ctx->auth_mode == DRV_HASH_SHA1) ?
-			CC_SHA1_DIGEST_SIZE : CC_SHA256_DIGEST_SIZE;
+	    CC_SHA1_DIGEST_SIZE : CC_SHA256_DIGEST_SIZE;
 	struct cc_hmac_s *hmac = &ctx->auth_state.hmac;
 
 	int idx = 0;
@@ -324,8 +342,8 @@ static int hmac_setkey(struct cc_hw_desc *desc, struct ssi_aead_ctx *ctx)
 		hw_desc_init(&desc[idx]);
 		set_cipher_mode(&desc[idx], hash_mode);
 		set_din_sram(&desc[idx],
-			     ssi_ahash_get_larval_digest_sram_addr(
-				ctx->drvdata, ctx->auth_mode),
+			     ssi_ahash_get_larval_digest_sram_addr(ctx->drvdata,
+								   ctx->auth_mode),
 			     digest_size);
 		set_flow_mode(&desc[idx], S_DIN_to_HASH);
 		set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
@@ -421,13 +439,14 @@ static int validate_keys_sizes(struct ssi_aead_ctx *ctx)
  * (copy to intenral buffer or hash in case of key longer than block
  */
 static int
-ssi_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
+ssi_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key,
+		       unsigned int keylen)
 {
 	dma_addr_t key_dma_addr = 0;
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct device *dev = &ctx->drvdata->plat_dev->dev;
-	u32 larval_addr = ssi_ahash_get_larval_digest_sram_addr(
-					ctx->drvdata, ctx->auth_mode);
+	u32 larval_addr =
+	    ssi_ahash_get_larval_digest_sram_addr(ctx->drvdata, ctx->auth_mode);
 	struct ssi_crypto_req ssi_req = {};
 	unsigned int blocksize;
 	unsigned int digestsize;
@@ -436,9 +455,9 @@ ssi_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key, unsigned int keyl
 	int rc = 0;
 	struct cc_hw_desc desc[MAX_AEAD_SETKEY_SEQ];
 	dma_addr_t padded_authkey_dma_addr =
-		ctx->auth_state.hmac.padded_authkey_dma_addr;
+	    ctx->auth_state.hmac.padded_authkey_dma_addr;
 
-	switch (ctx->auth_mode) { /* auth_key required and >0 */
+	switch (ctx->auth_mode) {	/* auth_key required and >0 */
 	case DRV_HASH_SHA1:
 		blocksize = SHA1_BLOCK_SIZE;
 		digestsize = SHA1_DIGEST_SIZE;
@@ -452,10 +471,12 @@ ssi_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key, unsigned int keyl
 	}
 
 	if (likely(keylen != 0)) {
-		key_dma_addr = dma_map_single(dev, (void *)key, keylen, DMA_TO_DEVICE);
+		key_dma_addr =
+		    dma_map_single(dev, (void *)key, keylen, DMA_TO_DEVICE);
 		if (unlikely(dma_mapping_error(dev, key_dma_addr))) {
-			SSI_LOG_ERR("Mapping key va=0x%p len=%u for DMA failed\n",
-				    key, keylen);
+			SSI_LOG_ERR
+			    ("Mapping key va=0x%p len=%u for DMA failed\n", key,
+			     keylen);
 			return -ENOMEM;
 		}
 		if (keylen > blocksize) {
@@ -498,8 +519,8 @@ ssi_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key, unsigned int keyl
 			set_din_const(&desc[idx], 0, (blocksize - digestsize));
 			set_flow_mode(&desc[idx], BYPASS);
 			set_dout_dlli(&desc[idx], (padded_authkey_dma_addr +
-				      digestsize), (blocksize - digestsize),
-				      NS_BIT, 0);
+						   digestsize),
+				      (blocksize - digestsize), NS_BIT, 0);
 			idx++;
 		} else {
 			hw_desc_init(&desc[idx]);
@@ -580,8 +601,9 @@ ssi_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 			/* Copy nonce from last 4 bytes in CTR key to
 			 *  first 4 bytes in CTR IV
 			 */
-			memcpy(ctx->ctr_nonce, key + ctx->auth_keylen + ctx->enc_keylen -
-				CTR_RFC3686_NONCE_SIZE, CTR_RFC3686_NONCE_SIZE);
+			memcpy(ctx->ctr_nonce,
+			       key + ctx->auth_keylen + ctx->enc_keylen -
+			       CTR_RFC3686_NONCE_SIZE, CTR_RFC3686_NONCE_SIZE);
 			/* Set CTR key size */
 			ctx->enc_keylen -= CTR_RFC3686_NONCE_SIZE;
 		}
@@ -647,7 +669,8 @@ ssi_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 }
 
 #if SSI_CC_HAS_AES_CCM
-static int ssi_rfc4309_ccm_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
+static int ssi_rfc4309_ccm_setkey(struct crypto_aead *tfm, const u8 *key,
+				  unsigned int keylen)
 {
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	int rc = 0;
@@ -664,17 +687,14 @@ static int ssi_rfc4309_ccm_setkey(struct crypto_aead *tfm, const u8 *key, unsign
 }
 #endif /*SSI_CC_HAS_AES_CCM*/
 
-static int ssi_aead_setauthsize(
-	struct crypto_aead *authenc,
-	unsigned int authsize)
+static int ssi_aead_setauthsize(struct crypto_aead *authenc,
+				unsigned int authsize)
 {
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(authenc);
 
 	/* Unsupported auth. sizes */
-	if ((authsize == 0) ||
-	    (authsize > crypto_aead_maxauthsize(authenc))) {
+	if ((authsize == 0) || (authsize > crypto_aead_maxauthsize(authenc)))
 		return -ENOTSUPP;
-	}
 
 	ctx->authsize = authsize;
 	SSI_LOG_DEBUG("authlen=%d\n", ctx->authsize);
@@ -719,11 +739,9 @@ static int ssi_ccm_setauthsize(struct crypto_aead *authenc,
 #endif /*SSI_CC_HAS_AES_CCM*/
 
 static inline void
-ssi_aead_create_assoc_desc(
-	struct aead_request *areq,
-	unsigned int flow_mode,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size)
+ssi_aead_create_assoc_desc(struct aead_request *areq,
+			   unsigned int flow_mode,
+			   struct cc_hw_desc desc[], unsigned int *seq_size)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(areq);
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
@@ -736,8 +754,8 @@ ssi_aead_create_assoc_desc(
 		SSI_LOG_DEBUG("ASSOC buffer type DLLI\n");
 		hw_desc_init(&desc[idx]);
 		set_din_type(&desc[idx], DMA_DLLI, sg_dma_address(areq->src),
-			     areq->assoclen, NS_BIT); set_flow_mode(&desc[idx],
-			     flow_mode);
+			     areq->assoclen, NS_BIT);
+		set_flow_mode(&desc[idx], flow_mode);
 		if ((ctx->auth_mode == DRV_HASH_XCBC_MAC) &&
 		    (areq_ctx->cryptlen > 0))
 			set_din_not_last_indication(&desc[idx]);
@@ -761,12 +779,10 @@ ssi_aead_create_assoc_desc(
 }
 
 static inline void
-ssi_aead_process_authenc_data_desc(
-	struct aead_request *areq,
-	unsigned int flow_mode,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size,
-	int direct)
+ssi_aead_process_authenc_data_desc(struct aead_request *areq,
+				   unsigned int flow_mode,
+				   struct cc_hw_desc desc[],
+				   unsigned int *seq_size, int direct)
 {
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(areq);
 	enum ssi_req_dma_buf_type data_dma_type = areq_ctx->data_buff_type;
@@ -774,48 +790,48 @@ ssi_aead_process_authenc_data_desc(
 
 	switch (data_dma_type) {
 	case SSI_DMA_BUF_DLLI:
-	{
-		struct scatterlist *cipher =
-			(direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ?
-			areq_ctx->dst_sgl : areq_ctx->src_sgl;
-
-		unsigned int offset =
-			(direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ?
-			areq_ctx->dst_offset : areq_ctx->src_offset;
-		SSI_LOG_DEBUG("AUTHENC: SRC/DST buffer type DLLI\n");
-		hw_desc_init(&desc[idx]);
-		set_din_type(&desc[idx], DMA_DLLI,
-			     (sg_dma_address(cipher) + offset),
-			     areq_ctx->cryptlen, NS_BIT);
-		set_flow_mode(&desc[idx], flow_mode);
-		break;
-	}
+		{
+			struct scatterlist *cipher =
+			    (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ?
+			    areq_ctx->dst_sgl : areq_ctx->src_sgl;
+
+			unsigned int offset =
+			    (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ?
+			    areq_ctx->dst_offset : areq_ctx->src_offset;
+			SSI_LOG_DEBUG("AUTHENC: SRC/DST buffer type DLLI\n");
+			hw_desc_init(&desc[idx]);
+			set_din_type(&desc[idx], DMA_DLLI,
+				     (sg_dma_address(cipher) + offset),
+				     areq_ctx->cryptlen, NS_BIT);
+			set_flow_mode(&desc[idx], flow_mode);
+			break;
+		}
 	case SSI_DMA_BUF_MLLI:
-	{
-		/* DOUBLE-PASS flow (as default)
-		 * assoc. + iv + data -compact in one table
-		 * if assoclen is ZERO only IV perform
-		 */
-		ssi_sram_addr_t mlli_addr = areq_ctx->assoc.sram_addr;
-		u32 mlli_nents = areq_ctx->assoc.mlli_nents;
-
-		if (likely(areq_ctx->is_single_pass)) {
-			if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) {
-				mlli_addr = areq_ctx->dst.sram_addr;
-				mlli_nents = areq_ctx->dst.mlli_nents;
-			} else {
-				mlli_addr = areq_ctx->src.sram_addr;
-				mlli_nents = areq_ctx->src.mlli_nents;
+		{
+			/* DOUBLE-PASS flow (as default)
+			 * assoc. + iv + data -compact in one table
+			 * if assoclen is ZERO only IV perform
+			 */
+			ssi_sram_addr_t mlli_addr = areq_ctx->assoc.sram_addr;
+			u32 mlli_nents = areq_ctx->assoc.mlli_nents;
+
+			if (likely(areq_ctx->is_single_pass)) {
+				if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) {
+					mlli_addr = areq_ctx->dst.sram_addr;
+					mlli_nents = areq_ctx->dst.mlli_nents;
+				} else {
+					mlli_addr = areq_ctx->src.sram_addr;
+					mlli_nents = areq_ctx->src.mlli_nents;
+				}
 			}
-		}
 
-		SSI_LOG_DEBUG("AUTHENC: SRC/DST buffer type MLLI\n");
-		hw_desc_init(&desc[idx]);
-		set_din_type(&desc[idx], DMA_MLLI, mlli_addr, mlli_nents,
-			     NS_BIT);
-		set_flow_mode(&desc[idx], flow_mode);
-		break;
-	}
+			SSI_LOG_DEBUG("AUTHENC: SRC/DST buffer type MLLI\n");
+			hw_desc_init(&desc[idx]);
+			set_din_type(&desc[idx], DMA_MLLI, mlli_addr,
+				     mlli_nents, NS_BIT);
+			set_flow_mode(&desc[idx], flow_mode);
+			break;
+		}
 	case SSI_DMA_BUF_NULL:
 	default:
 		SSI_LOG_ERR("AUTHENC: Invalid SRC/DST buffer type\n");
@@ -825,11 +841,10 @@ ssi_aead_process_authenc_data_desc(
 }
 
 static inline void
-ssi_aead_process_cipher_data_desc(
-	struct aead_request *areq,
-	unsigned int flow_mode,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size)
+ssi_aead_process_cipher_data_desc(struct aead_request *areq,
+				  unsigned int flow_mode,
+				  struct cc_hw_desc desc[],
+				  unsigned int *seq_size)
 {
 	unsigned int idx = *seq_size;
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(areq);
@@ -844,11 +859,12 @@ ssi_aead_process_cipher_data_desc(
 		hw_desc_init(&desc[idx]);
 		set_din_type(&desc[idx], DMA_DLLI,
 			     (sg_dma_address(areq_ctx->src_sgl) +
-			      areq_ctx->src_offset), areq_ctx->cryptlen, NS_BIT);
+			      areq_ctx->src_offset), areq_ctx->cryptlen,
+			     NS_BIT);
 		set_dout_dlli(&desc[idx],
 			      (sg_dma_address(areq_ctx->dst_sgl) +
-			       areq_ctx->dst_offset),
-			      areq_ctx->cryptlen, NS_BIT, 0);
+			       areq_ctx->dst_offset), areq_ctx->cryptlen,
+			      NS_BIT, 0);
 		set_flow_mode(&desc[idx], flow_mode);
 		break;
 	case SSI_DMA_BUF_MLLI:
@@ -868,17 +884,16 @@ ssi_aead_process_cipher_data_desc(
 	*seq_size = (++idx);
 }
 
-static inline void ssi_aead_process_digest_result_desc(
-	struct aead_request *req,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size)
+static inline void ssi_aead_process_digest_result_desc(struct aead_request *req,
+						       struct cc_hw_desc desc[],
+						       unsigned int *seq_size)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
 	unsigned int idx = *seq_size;
 	unsigned int hash_mode = (ctx->auth_mode == DRV_HASH_SHA1) ?
-				DRV_HASH_HW_SHA1 : DRV_HASH_HW_SHA256;
+	    DRV_HASH_HW_SHA1 : DRV_HASH_HW_SHA256;
 	int direct = req_ctx->gen_ctx.op_type;
 
 	/* Get final ICV result */
@@ -919,10 +934,9 @@ static inline void ssi_aead_process_digest_result_desc(
 	*seq_size = (++idx);
 }
 
-static inline void ssi_aead_setup_cipher_desc(
-	struct aead_request *req,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size)
+static inline void ssi_aead_setup_cipher_desc(struct aead_request *req,
+					      struct cc_hw_desc desc[],
+					      unsigned int *seq_size)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
@@ -965,11 +979,10 @@ static inline void ssi_aead_setup_cipher_desc(
 	*seq_size = idx;
 }
 
-static inline void ssi_aead_process_cipher(
-	struct aead_request *req,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size,
-	unsigned int data_flow_mode)
+static inline void ssi_aead_process_cipher(struct aead_request *req,
+					   struct cc_hw_desc desc[],
+					   unsigned int *seq_size,
+					   unsigned int data_flow_mode)
 {
 	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
 	int direct = req_ctx->gen_ctx.op_type;
@@ -991,17 +1004,16 @@ static inline void ssi_aead_process_cipher(
 	*seq_size = idx;
 }
 
-static inline void ssi_aead_hmac_setup_digest_desc(
-	struct aead_request *req,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size)
+static inline void ssi_aead_hmac_setup_digest_desc(struct aead_request *req,
+						   struct cc_hw_desc desc[],
+						   unsigned int *seq_size)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	unsigned int hash_mode = (ctx->auth_mode == DRV_HASH_SHA1) ?
-				DRV_HASH_HW_SHA1 : DRV_HASH_HW_SHA256;
+	    DRV_HASH_HW_SHA1 : DRV_HASH_HW_SHA256;
 	unsigned int digest_size = (ctx->auth_mode == DRV_HASH_SHA1) ?
-				CC_SHA1_DIGEST_SIZE : CC_SHA256_DIGEST_SIZE;
+	    CC_SHA1_DIGEST_SIZE : CC_SHA256_DIGEST_SIZE;
 	unsigned int idx = *seq_size;
 
 	/* Loading hash ipad xor key state */
@@ -1020,7 +1032,7 @@ static inline void ssi_aead_hmac_setup_digest_desc(
 	set_din_sram(&desc[idx],
 		     ssi_ahash_get_initial_digest_len_sram_addr(ctx->drvdata,
 								hash_mode),
-								HASH_LEN_SIZE);
+		     HASH_LEN_SIZE);
 	set_flow_mode(&desc[idx], S_DIN_to_HASH);
 	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 	idx++;
@@ -1028,10 +1040,9 @@ static inline void ssi_aead_hmac_setup_digest_desc(
 	*seq_size = idx;
 }
 
-static inline void ssi_aead_xcbc_setup_digest_desc(
-	struct aead_request *req,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size)
+static inline void ssi_aead_xcbc_setup_digest_desc(struct aead_request *req,
+						   struct cc_hw_desc desc[],
+						   unsigned int *seq_size)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
@@ -1090,10 +1101,9 @@ static inline void ssi_aead_xcbc_setup_digest_desc(
 	*seq_size = idx;
 }
 
-static inline void ssi_aead_process_digest_header_desc(
-	struct aead_request *req,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size)
+static inline void ssi_aead_process_digest_header_desc(struct aead_request *req,
+						       struct cc_hw_desc desc[],
+						       unsigned int *seq_size)
 {
 	unsigned int idx = *seq_size;
 	/* Hash associated data */
@@ -1104,18 +1114,17 @@ static inline void ssi_aead_process_digest_header_desc(
 	*seq_size = idx;
 }
 
-static inline void ssi_aead_process_digest_scheme_desc(
-	struct aead_request *req,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size)
+static inline void ssi_aead_process_digest_scheme_desc(struct aead_request *req,
+						       struct cc_hw_desc desc[],
+						       unsigned int *seq_size)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct ssi_aead_handle *aead_handle = ctx->drvdata->aead_handle;
 	unsigned int hash_mode = (ctx->auth_mode == DRV_HASH_SHA1) ?
-				DRV_HASH_HW_SHA1 : DRV_HASH_HW_SHA256;
+	    DRV_HASH_HW_SHA1 : DRV_HASH_HW_SHA256;
 	unsigned int digest_size = (ctx->auth_mode == DRV_HASH_SHA1) ?
-				CC_SHA1_DIGEST_SIZE : CC_SHA256_DIGEST_SIZE;
+	    CC_SHA1_DIGEST_SIZE : CC_SHA256_DIGEST_SIZE;
 	unsigned int idx = *seq_size;
 
 	hw_desc_init(&desc[idx]);
@@ -1161,27 +1170,24 @@ static inline void ssi_aead_process_digest_scheme_desc(
 
 	/* Perform HASH update */
 	hw_desc_init(&desc[idx]);
-	set_din_sram(&desc[idx], aead_handle->sram_workspace_addr,
-		     digest_size);
+	set_din_sram(&desc[idx], aead_handle->sram_workspace_addr, digest_size);
 	set_flow_mode(&desc[idx], DIN_HASH);
 	idx++;
 
 	*seq_size = idx;
 }
 
-static inline void ssi_aead_load_mlli_to_sram(
-	struct aead_request *req,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size)
+static inline void ssi_aead_load_mlli_to_sram(struct aead_request *req,
+					      struct cc_hw_desc desc[],
+					      unsigned int *seq_size)
 {
 	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 
-	if (unlikely(
-		(req_ctx->assoc_buff_type == SSI_DMA_BUF_MLLI) ||
-		(req_ctx->data_buff_type == SSI_DMA_BUF_MLLI) ||
-		!req_ctx->is_single_pass)) {
+	if (unlikely((req_ctx->assoc_buff_type == SSI_DMA_BUF_MLLI) ||
+		     (req_ctx->data_buff_type == SSI_DMA_BUF_MLLI) ||
+		     !req_ctx->is_single_pass)) {
 		SSI_LOG_DEBUG("Copy-to-sram: mlli_dma=%08x, mlli_size=%u\n",
 			      (unsigned int)ctx->drvdata->mlli_sram_addr,
 			      req_ctx->mlli_params.mlli_len);
@@ -1198,43 +1204,45 @@ static inline void ssi_aead_load_mlli_to_sram(
 	}
 }
 
-static inline enum cc_flow_mode ssi_aead_get_data_flow_mode(
-	enum drv_crypto_direction direct,
-	enum cc_flow_mode setup_flow_mode,
-	bool is_single_pass)
+static inline enum cc_flow_mode ssi_aead_get_data_flow_mode(enum
+							    drv_crypto_direction
+							    direct,
+							    enum cc_flow_mode
+							    setup_flow_mode,
+							    bool is_single_pass)
 {
 	enum cc_flow_mode data_flow_mode;
 
 	if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) {
 		if (setup_flow_mode == S_DIN_to_AES)
 			data_flow_mode = likely(is_single_pass) ?
-				AES_to_HASH_and_DOUT : DIN_AES_DOUT;
+			    AES_to_HASH_and_DOUT : DIN_AES_DOUT;
 		else
 			data_flow_mode = likely(is_single_pass) ?
-				DES_to_HASH_and_DOUT : DIN_DES_DOUT;
+			    DES_to_HASH_and_DOUT : DIN_DES_DOUT;
 	} else { /* Decrypt */
 		if (setup_flow_mode == S_DIN_to_AES)
 			data_flow_mode = likely(is_single_pass) ?
-					AES_and_HASH : DIN_AES_DOUT;
+			    AES_and_HASH : DIN_AES_DOUT;
 		else
 			data_flow_mode = likely(is_single_pass) ?
-					DES_and_HASH : DIN_DES_DOUT;
+			    DES_and_HASH : DIN_DES_DOUT;
 	}
 
 	return data_flow_mode;
 }
 
-static inline void ssi_aead_hmac_authenc(
-	struct aead_request *req,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size)
+static inline void ssi_aead_hmac_authenc(struct aead_request *req,
+					 struct cc_hw_desc desc[],
+					 unsigned int *seq_size)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
 	int direct = req_ctx->gen_ctx.op_type;
-	unsigned int data_flow_mode = ssi_aead_get_data_flow_mode(
-		direct, ctx->flow_mode, req_ctx->is_single_pass);
+	unsigned int data_flow_mode =
+	    ssi_aead_get_data_flow_mode(direct, ctx->flow_mode,
+					req_ctx->is_single_pass);
 
 	if (req_ctx->is_single_pass) {
 		/**
@@ -1243,7 +1251,8 @@ static inline void ssi_aead_hmac_authenc(
 		ssi_aead_hmac_setup_digest_desc(req, desc, seq_size);
 		ssi_aead_setup_cipher_desc(req, desc, seq_size);
 		ssi_aead_process_digest_header_desc(req, desc, seq_size);
-		ssi_aead_process_cipher_data_desc(req, data_flow_mode, desc, seq_size);
+		ssi_aead_process_cipher_data_desc(req, data_flow_mode, desc,
+						  seq_size);
 		ssi_aead_process_digest_scheme_desc(req, desc, seq_size);
 		ssi_aead_process_digest_result_desc(req, desc, seq_size);
 		return;
@@ -1257,16 +1266,19 @@ static inline void ssi_aead_hmac_authenc(
 	if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) {
 		/* encrypt first.. */
 		ssi_aead_process_cipher(req, desc, seq_size, data_flow_mode);
-		/* authenc after..*/
+		/* authenc after.. */
 		ssi_aead_hmac_setup_digest_desc(req, desc, seq_size);
-		ssi_aead_process_authenc_data_desc(req, DIN_HASH, desc, seq_size, direct);
+		ssi_aead_process_authenc_data_desc(req, DIN_HASH, desc,
+						   seq_size, direct);
 		ssi_aead_process_digest_scheme_desc(req, desc, seq_size);
 		ssi_aead_process_digest_result_desc(req, desc, seq_size);
 
-	} else { /*DECRYPT*/
-		/* authenc first..*/
+	} else {
+		/*DECRYPT*/
+		/* authenc first.. */
 		ssi_aead_hmac_setup_digest_desc(req, desc, seq_size);
-		ssi_aead_process_authenc_data_desc(req, DIN_HASH, desc, seq_size, direct);
+		ssi_aead_process_authenc_data_desc(req, DIN_HASH, desc,
+						   seq_size, direct);
 		ssi_aead_process_digest_scheme_desc(req, desc, seq_size);
 		/* decrypt after.. */
 		ssi_aead_process_cipher(req, desc, seq_size, data_flow_mode);
@@ -1278,17 +1290,16 @@ static inline void ssi_aead_hmac_authenc(
 }
 
 static inline void
-ssi_aead_xcbc_authenc(
-	struct aead_request *req,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size)
+ssi_aead_xcbc_authenc(struct aead_request *req,
+		      struct cc_hw_desc desc[], unsigned int *seq_size)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
 	int direct = req_ctx->gen_ctx.op_type;
-	unsigned int data_flow_mode = ssi_aead_get_data_flow_mode(
-		direct, ctx->flow_mode, req_ctx->is_single_pass);
+	unsigned int data_flow_mode =
+	    ssi_aead_get_data_flow_mode(direct, ctx->flow_mode,
+					req_ctx->is_single_pass);
 
 	if (req_ctx->is_single_pass) {
 		/**
@@ -1297,7 +1308,8 @@ ssi_aead_xcbc_authenc(
 		ssi_aead_xcbc_setup_digest_desc(req, desc, seq_size);
 		ssi_aead_setup_cipher_desc(req, desc, seq_size);
 		ssi_aead_process_digest_header_desc(req, desc, seq_size);
-		ssi_aead_process_cipher_data_desc(req, data_flow_mode, desc, seq_size);
+		ssi_aead_process_cipher_data_desc(req, data_flow_mode, desc,
+						  seq_size);
 		ssi_aead_process_digest_result_desc(req, desc, seq_size);
 		return;
 	}
@@ -1312,13 +1324,16 @@ ssi_aead_xcbc_authenc(
 		ssi_aead_process_cipher(req, desc, seq_size, data_flow_mode);
 		/* authenc after.. */
 		ssi_aead_xcbc_setup_digest_desc(req, desc, seq_size);
-		ssi_aead_process_authenc_data_desc(req, DIN_HASH, desc, seq_size, direct);
+		ssi_aead_process_authenc_data_desc(req, DIN_HASH, desc,
+						   seq_size, direct);
 		ssi_aead_process_digest_result_desc(req, desc, seq_size);
-	} else { /*DECRYPT*/
+	} else {
+		/*DECRYPT*/
 		/* authenc first.. */
 		ssi_aead_xcbc_setup_digest_desc(req, desc, seq_size);
-		ssi_aead_process_authenc_data_desc(req, DIN_HASH, desc, seq_size, direct);
-		/* decrypt after..*/
+		ssi_aead_process_authenc_data_desc(req, DIN_HASH, desc,
+						   seq_size, direct);
+		/* decrypt after.. */
 		ssi_aead_process_cipher(req, desc, seq_size, data_flow_mode);
 		/* read the digest result with setting the completion bit
 		 * must be after the cipher operation
@@ -1334,7 +1349,7 @@ static int validate_data_size(struct ssi_aead_ctx *ctx,
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	unsigned int assoclen = req->assoclen;
 	unsigned int cipherlen = (direct == DRV_CRYPTO_DIRECTION_DECRYPT) ?
-			(req->cryptlen - ctx->authsize) : req->cryptlen;
+	    (req->cryptlen - ctx->authsize) : req->cryptlen;
 
 	if (unlikely((direct == DRV_CRYPTO_DIRECTION_DECRYPT) &&
 		     (req->cryptlen < ctx->authsize)))
@@ -1425,10 +1440,8 @@ static int set_msg_len(u8 *block, unsigned int msglen, unsigned int csize)
 	return 0;
 }
 
-static inline int ssi_aead_ccm(
-	struct aead_request *req,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size)
+static inline int ssi_aead_ccm(struct aead_request *req,
+			       struct cc_hw_desc desc[], unsigned int *seq_size)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
@@ -1507,7 +1520,8 @@ static inline int ssi_aead_ccm(
 
 	/* process the cipher */
 	if (req_ctx->cryptlen != 0)
-		ssi_aead_process_cipher_data_desc(req, cipher_flow_mode, desc, &idx);
+		ssi_aead_process_cipher_data_desc(req, cipher_flow_mode, desc,
+						  &idx);
 
 	/* Read temporal MAC */
 	hw_desc_init(&desc[idx]);
@@ -1564,8 +1578,7 @@ static int config_ccm_adata(struct aead_request *req)
 	u8 *ctr_count_0 = req_ctx->ccm_config + CCM_CTR_COUNT_0_OFFSET;
 	unsigned int cryptlen = (req_ctx->gen_ctx.op_type ==
 				 DRV_CRYPTO_DIRECTION_ENCRYPT) ?
-				req->cryptlen :
-				(req->cryptlen - ctx->authsize);
+	    req->cryptlen : (req->cryptlen - ctx->authsize);
 	int rc;
 
 	memset(req_ctx->mac_buf, 0, AES_BLOCK_SIZE);
@@ -1589,7 +1602,7 @@ static int config_ccm_adata(struct aead_request *req)
 	rc = set_msg_len(b0 + 16 - l, cryptlen, l);  /* Write L'. */
 	if (rc != 0)
 		return rc;
-	 /* END of "taken from crypto/ccm.c" */
+	/* END of "taken from crypto/ccm.c" */
 
 	/* l(a) - size of associated data. */
 	req_ctx->ccm_hdr_size = format_ccm_a0(a0, req->assoclen);
@@ -1614,8 +1627,10 @@ static void ssi_rfc4309_ccm_process(struct aead_request *req)
 	areq_ctx->ctr_iv[0] = 3;  /* For RFC 4309, always use 4 bytes for message length (at most 2^32-1 bytes). */
 
 	/* In RFC 4309 there is an 11-bytes nonce+IV part, that we build here. */
-	memcpy(areq_ctx->ctr_iv + CCM_BLOCK_NONCE_OFFSET, ctx->ctr_nonce, CCM_BLOCK_NONCE_SIZE);
-	memcpy(areq_ctx->ctr_iv + CCM_BLOCK_IV_OFFSET,    req->iv,        CCM_BLOCK_IV_SIZE);
+	memcpy(areq_ctx->ctr_iv + CCM_BLOCK_NONCE_OFFSET, ctx->ctr_nonce,
+	       CCM_BLOCK_NONCE_SIZE);
+	memcpy(areq_ctx->ctr_iv + CCM_BLOCK_IV_OFFSET, req->iv,
+	       CCM_BLOCK_IV_SIZE);
 	req->iv = areq_ctx->ctr_iv;
 	req->assoclen -= CCM_BLOCK_IV_SIZE;
 }
@@ -1623,10 +1638,9 @@ static void ssi_rfc4309_ccm_process(struct aead_request *req)
 
 #if SSI_CC_HAS_AES_GCM
 
-static inline void ssi_aead_gcm_setup_ghash_desc(
-	struct aead_request *req,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size)
+static inline void ssi_aead_gcm_setup_ghash_desc(struct aead_request *req,
+						 struct cc_hw_desc desc[],
+						 unsigned int *seq_size)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
@@ -1701,10 +1715,9 @@ static inline void ssi_aead_gcm_setup_ghash_desc(
 	*seq_size = idx;
 }
 
-static inline void ssi_aead_gcm_setup_gctr_desc(
-	struct aead_request *req,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size)
+static inline void ssi_aead_gcm_setup_gctr_desc(struct aead_request *req,
+						struct cc_hw_desc desc[],
+						unsigned int *seq_size)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
@@ -1739,10 +1752,9 @@ static inline void ssi_aead_gcm_setup_gctr_desc(
 	*seq_size = idx;
 }
 
-static inline void ssi_aead_process_gcm_result_desc(
-	struct aead_request *req,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size)
+static inline void ssi_aead_process_gcm_result_desc(struct aead_request *req,
+						    struct cc_hw_desc desc[],
+						    unsigned int *seq_size)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
@@ -1805,10 +1817,8 @@ static inline void ssi_aead_process_gcm_result_desc(
 	*seq_size = idx;
 }
 
-static inline int ssi_aead_gcm(
-	struct aead_request *req,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size)
+static inline int ssi_aead_gcm(struct aead_request *req,
+			       struct cc_hw_desc desc[], unsigned int *seq_size)
 {
 	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
 	unsigned int idx = *seq_size;
@@ -1831,7 +1841,6 @@ static inline int ssi_aead_gcm(
 		idx = *seq_size;
 		return 0;
 	}
-
 	// for gcm and rfc4106.
 	ssi_aead_gcm_setup_ghash_desc(req, desc, seq_size);
 	/* process(ghash) assoc data */
@@ -1840,7 +1849,8 @@ static inline int ssi_aead_gcm(
 	ssi_aead_gcm_setup_gctr_desc(req, desc, seq_size);
 	/* process(gctr+ghash) */
 	if (req_ctx->cryptlen != 0)
-		ssi_aead_process_cipher_data_desc(req, cipher_flow_mode, desc, seq_size);
+		ssi_aead_process_cipher_data_desc(req, cipher_flow_mode, desc,
+						  seq_size);
 	ssi_aead_process_gcm_result_desc(req, desc, seq_size);
 
 	idx = *seq_size;
@@ -1848,9 +1858,8 @@ static inline int ssi_aead_gcm(
 }
 
 #ifdef CC_DEBUG
-static inline void ssi_aead_dump_gcm(
-	const char *title,
-	struct aead_request *req)
+static inline void ssi_aead_dump_gcm(const char *title,
+				     struct aead_request *req)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
@@ -1860,13 +1869,15 @@ static inline void ssi_aead_dump_gcm(
 		return;
 
 	if (title) {
-		SSI_LOG_DEBUG("----------------------------------------------------------------------------------");
+		SSI_LOG_DEBUG
+		    ("----------------------------------------------------------------------------------");
 		SSI_LOG_DEBUG("%s\n", title);
 	}
 
-	SSI_LOG_DEBUG("cipher_mode %d, authsize %d, enc_keylen %d, assoclen %d, cryptlen %d\n",
-		      ctx->cipher_mode, ctx->authsize, ctx->enc_keylen,
-		      req->assoclen, req_ctx->cryptlen);
+	SSI_LOG_DEBUG
+	    ("cipher_mode %d, authsize %d, enc_keylen %d, assoclen %d, cryptlen %d\n",
+	     ctx->cipher_mode, ctx->authsize, ctx->enc_keylen, req->assoclen,
+	     req_ctx->cryptlen);
 
 	if (ctx->enckey)
 		dump_byte_array("mac key", ctx->enckey, 16);
@@ -1881,13 +1892,16 @@ static inline void ssi_aead_dump_gcm(
 
 	dump_byte_array("mac_buf", req_ctx->mac_buf, AES_BLOCK_SIZE);
 
-	dump_byte_array("gcm_len_block", req_ctx->gcm_len_block.len_a, AES_BLOCK_SIZE);
+	dump_byte_array("gcm_len_block", req_ctx->gcm_len_block.len_a,
+			AES_BLOCK_SIZE);
 
 	if (req->src && req->cryptlen)
-		dump_byte_array("req->src", sg_virt(req->src), req->cryptlen + req->assoclen);
+		dump_byte_array("req->src", sg_virt(req->src),
+				req->cryptlen + req->assoclen);
 
 	if (req->dst)
-		dump_byte_array("req->dst", sg_virt(req->dst), req->cryptlen + ctx->authsize + req->assoclen);
+		dump_byte_array("req->dst", sg_virt(req->dst),
+				req->cryptlen + ctx->authsize + req->assoclen);
 }
 #endif
 
@@ -1899,11 +1913,12 @@ static int config_gcm_context(struct aead_request *req)
 
 	unsigned int cryptlen = (req_ctx->gen_ctx.op_type ==
 				 DRV_CRYPTO_DIRECTION_ENCRYPT) ?
-				req->cryptlen :
-				(req->cryptlen - ctx->authsize);
+	    req->cryptlen : (req->cryptlen - ctx->authsize);
 	__be32 counter = cpu_to_be32(2);
 
-	SSI_LOG_DEBUG("%s() cryptlen = %d, req->assoclen = %d ctx->authsize = %d\n", __func__, cryptlen, req->assoclen, ctx->authsize);
+	SSI_LOG_DEBUG
+	    ("%s() cryptlen = %d, req->assoclen = %d ctx->authsize = %d\n",
+	     __func__, cryptlen, req->assoclen, ctx->authsize);
 
 	memset(req_ctx->hkey, 0, AES_BLOCK_SIZE);
 
@@ -1926,7 +1941,9 @@ static int config_gcm_context(struct aead_request *req)
 	} else { //rfc4543=>  all data(AAD,IV,Plain) are considered additional data that is nothing is encrypted.
 		__be64 temp64;
 
-		temp64 = cpu_to_be64((req->assoclen + GCM_BLOCK_RFC4_IV_SIZE + cryptlen) * 8);
+		temp64 =
+		    cpu_to_be64((req->assoclen + GCM_BLOCK_RFC4_IV_SIZE +
+				 cryptlen) * 8);
 		memcpy(&req_ctx->gcm_len_block.len_a, &temp64, sizeof(temp64));
 		temp64 = 0;
 		memcpy(&req_ctx->gcm_len_block.len_c, &temp64, 8);
@@ -1941,15 +1958,18 @@ static void ssi_rfc4_gcm_process(struct aead_request *req)
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 
-	memcpy(areq_ctx->ctr_iv + GCM_BLOCK_RFC4_NONCE_OFFSET, ctx->ctr_nonce, GCM_BLOCK_RFC4_NONCE_SIZE);
-	memcpy(areq_ctx->ctr_iv + GCM_BLOCK_RFC4_IV_OFFSET,    req->iv, GCM_BLOCK_RFC4_IV_SIZE);
+	memcpy(areq_ctx->ctr_iv + GCM_BLOCK_RFC4_NONCE_OFFSET, ctx->ctr_nonce,
+	       GCM_BLOCK_RFC4_NONCE_SIZE);
+	memcpy(areq_ctx->ctr_iv + GCM_BLOCK_RFC4_IV_OFFSET, req->iv,
+	       GCM_BLOCK_RFC4_IV_SIZE);
 	req->iv = areq_ctx->ctr_iv;
 	req->assoclen -= GCM_BLOCK_RFC4_IV_SIZE;
 }
 
 #endif /*SSI_CC_HAS_AES_GCM*/
 
-static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction direct)
+static int ssi_aead_process(struct aead_request *req,
+			    enum drv_crypto_direction direct)
 {
 	int rc = 0;
 	int seq_len = 0;
@@ -1960,10 +1980,11 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 	struct device *dev = &ctx->drvdata->plat_dev->dev;
 	struct ssi_crypto_req ssi_req = {};
 
-	SSI_LOG_DEBUG("%s context=%p req=%p iv=%p src=%p src_ofs=%d dst=%p dst_ofs=%d cryptolen=%d\n",
-		      ((direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ? "Encrypt" : "Decrypt"),
-		      ctx, req, req->iv, sg_virt(req->src), req->src->offset,
-		      sg_virt(req->dst), req->dst->offset, req->cryptlen);
+	SSI_LOG_DEBUG
+	    ("%s context=%p req=%p iv=%p src=%p src_ofs=%d dst=%p dst_ofs=%d cryptolen=%d\n",
+	     ((direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ? "Encrypt" : "Decrypt"),
+	     ctx, req, req->iv, sg_virt(req->src), req->src->offset,
+	     sg_virt(req->dst), req->dst->offset, req->cryptlen);
 
 	/* STAT_PHASE_0: Init and sanity checks */
 
@@ -1990,13 +2011,14 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 		/* Build CTR IV - Copy nonce from last 4 bytes in
 		 * CTR key to first 4 bytes in CTR IV
 		 */
-		memcpy(areq_ctx->ctr_iv, ctx->ctr_nonce, CTR_RFC3686_NONCE_SIZE);
+		memcpy(areq_ctx->ctr_iv, ctx->ctr_nonce,
+		       CTR_RFC3686_NONCE_SIZE);
 		if (!areq_ctx->backup_giv) /*User none-generated IV*/
 			memcpy(areq_ctx->ctr_iv + CTR_RFC3686_NONCE_SIZE,
 			       req->iv, CTR_RFC3686_IV_SIZE);
 		/* Initialize counter portion of counter block */
 		*(__be32 *)(areq_ctx->ctr_iv + CTR_RFC3686_NONCE_SIZE +
-			    CTR_RFC3686_IV_SIZE) = cpu_to_be32(1);
+			     CTR_RFC3686_IV_SIZE) = cpu_to_be32(1);
 
 		/* Replace with counter iv */
 		req->iv = areq_ctx->ctr_iv;
@@ -2005,10 +2027,11 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 		   (ctx->cipher_mode == DRV_CIPHER_GCTR)) {
 		areq_ctx->hw_iv_size = AES_BLOCK_SIZE;
 		if (areq_ctx->ctr_iv != req->iv) {
-			memcpy(areq_ctx->ctr_iv, req->iv, crypto_aead_ivsize(tfm));
+			memcpy(areq_ctx->ctr_iv, req->iv,
+			       crypto_aead_ivsize(tfm));
 			req->iv = areq_ctx->ctr_iv;
 		}
-	}  else {
+	} else {
 		areq_ctx->hw_iv_size = crypto_aead_ivsize(tfm);
 	}
 
@@ -2016,7 +2039,9 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 	if (ctx->cipher_mode == DRV_CIPHER_CCM) {
 		rc = config_ccm_adata(req);
 		if (unlikely(rc != 0)) {
-			SSI_LOG_ERR("config_ccm_adata() returned with a failure %d!", rc);
+			SSI_LOG_ERR
+			    ("config_ccm_adata() returned with a failure %d!",
+			     rc);
 			goto exit;
 		}
 	} else {
@@ -2030,7 +2055,9 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 	if (ctx->cipher_mode == DRV_CIPHER_GCTR) {
 		rc = config_gcm_context(req);
 		if (unlikely(rc != 0)) {
-			SSI_LOG_ERR("config_gcm_context() returned with a failure %d!", rc);
+			SSI_LOG_ERR
+			    ("config_gcm_context() returned with a failure %d!",
+			     rc);
 			goto exit;
 		}
 	}
@@ -2046,7 +2073,9 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 	if (areq_ctx->backup_giv) {
 		/* set the DMA mapped IV address*/
 		if (ctx->cipher_mode == DRV_CIPHER_CTR) {
-			ssi_req.ivgen_dma_addr[0] = areq_ctx->gen_ctx.iv_dma_addr + CTR_RFC3686_NONCE_SIZE;
+			ssi_req.ivgen_dma_addr[0] =
+			    areq_ctx->gen_ctx.iv_dma_addr +
+			    CTR_RFC3686_NONCE_SIZE;
 			ssi_req.ivgen_dma_addr_len = 1;
 		} else if (ctx->cipher_mode == DRV_CIPHER_CCM) {
 			/* In ccm, the IV needs to exist both inside B0 and inside the counter.
@@ -2054,12 +2083,18 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 			 * it to the user).
 			 * So, using 3 (identical) IV outputs.
 			 */
-			ssi_req.ivgen_dma_addr[0] = areq_ctx->gen_ctx.iv_dma_addr + CCM_BLOCK_IV_OFFSET;
-			ssi_req.ivgen_dma_addr[1] = sg_dma_address(&areq_ctx->ccm_adata_sg) + CCM_B0_OFFSET          + CCM_BLOCK_IV_OFFSET;
-			ssi_req.ivgen_dma_addr[2] = sg_dma_address(&areq_ctx->ccm_adata_sg) + CCM_CTR_COUNT_0_OFFSET + CCM_BLOCK_IV_OFFSET;
+			ssi_req.ivgen_dma_addr[0] =
+			    areq_ctx->gen_ctx.iv_dma_addr + CCM_BLOCK_IV_OFFSET;
+			ssi_req.ivgen_dma_addr[1] =
+			    sg_dma_address(&areq_ctx->ccm_adata_sg) +
+			    CCM_B0_OFFSET + CCM_BLOCK_IV_OFFSET;
+			ssi_req.ivgen_dma_addr[2] =
+			    sg_dma_address(&areq_ctx->ccm_adata_sg) +
+			    CCM_CTR_COUNT_0_OFFSET + CCM_BLOCK_IV_OFFSET;
 			ssi_req.ivgen_dma_addr_len = 3;
 		} else {
-			ssi_req.ivgen_dma_addr[0] = areq_ctx->gen_ctx.iv_dma_addr;
+			ssi_req.ivgen_dma_addr[0] =
+			    areq_ctx->gen_ctx.iv_dma_addr;
 			ssi_req.ivgen_dma_addr_len = 1;
 		}
 
@@ -2091,7 +2126,7 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 		if (ctx->cipher_mode == DRV_CIPHER_GCTR)
 			ssi_aead_gcm(req, desc, &seq_len);
 #endif /*SSI_CC_HAS_AES_GCM*/
-			break;
+		break;
 #endif
 	default:
 		SSI_LOG_ERR("Unsupported authenc (%d)\n", ctx->auth_mode);
@@ -2210,7 +2245,8 @@ static int ssi_rfc4309_ccm_decrypt(struct aead_request *req)
 
 #if SSI_CC_HAS_AES_GCM
 
-static int ssi_rfc4106_gcm_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
+static int ssi_rfc4106_gcm_setkey(struct crypto_aead *tfm, const u8 *key,
+				  unsigned int keylen)
 {
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	int rc = 0;
@@ -2228,7 +2264,8 @@ static int ssi_rfc4106_gcm_setkey(struct crypto_aead *tfm, const u8 *key, unsign
 	return rc;
 }
 
-static int ssi_rfc4543_gcm_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
+static int ssi_rfc4543_gcm_setkey(struct crypto_aead *tfm, const u8 *key,
+				  unsigned int keylen)
 {
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	int rc = 0;
@@ -2401,259 +2438,260 @@ static int ssi_rfc4543_gcm_decrypt(struct aead_request *req)
 /* DX Block aead alg */
 static struct ssi_alg_template aead_algs[] = {
 	{
-		.name = "authenc(hmac(sha1),cbc(aes))",
-		.driver_name = "authenc-hmac-sha1-cbc-aes-dx",
-		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
-			.setkey = ssi_aead_setkey,
-			.setauthsize = ssi_aead_setauthsize,
-			.encrypt = ssi_aead_encrypt,
-			.decrypt = ssi_aead_decrypt,
-			.init = ssi_aead_init,
-			.exit = ssi_aead_exit,
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = SHA1_DIGEST_SIZE,
-		},
-		.cipher_mode = DRV_CIPHER_CBC,
-		.flow_mode = S_DIN_to_AES,
-		.auth_mode = DRV_HASH_SHA1,
-	},
+	 .name = "authenc(hmac(sha1),cbc(aes))",
+	 .driver_name = "authenc-hmac-sha1-cbc-aes-dx",
+	 .blocksize = AES_BLOCK_SIZE,
+	 .type = CRYPTO_ALG_TYPE_AEAD,
+	 .template_aead = {
+			   .setkey = ssi_aead_setkey,
+			   .setauthsize = ssi_aead_setauthsize,
+			   .encrypt = ssi_aead_encrypt,
+			   .decrypt = ssi_aead_decrypt,
+			   .init = ssi_aead_init,
+			   .exit = ssi_aead_exit,
+			   .ivsize = AES_BLOCK_SIZE,
+			   .maxauthsize = SHA1_DIGEST_SIZE,
+			   },
+	 .cipher_mode = DRV_CIPHER_CBC,
+	 .flow_mode = S_DIN_to_AES,
+	 .auth_mode = DRV_HASH_SHA1,
+	 },
 	{
-		.name = "authenc(hmac(sha1),cbc(des3_ede))",
-		.driver_name = "authenc-hmac-sha1-cbc-des3-dx",
-		.blocksize = DES3_EDE_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
-			.setkey = ssi_aead_setkey,
-			.setauthsize = ssi_aead_setauthsize,
-			.encrypt = ssi_aead_encrypt,
-			.decrypt = ssi_aead_decrypt,
-			.init = ssi_aead_init,
-			.exit = ssi_aead_exit,
-			.ivsize = DES3_EDE_BLOCK_SIZE,
-			.maxauthsize = SHA1_DIGEST_SIZE,
-		},
-		.cipher_mode = DRV_CIPHER_CBC,
-		.flow_mode = S_DIN_to_DES,
-		.auth_mode = DRV_HASH_SHA1,
-	},
+	 .name = "authenc(hmac(sha1),cbc(des3_ede))",
+	 .driver_name = "authenc-hmac-sha1-cbc-des3-dx",
+	 .blocksize = DES3_EDE_BLOCK_SIZE,
+	 .type = CRYPTO_ALG_TYPE_AEAD,
+	 .template_aead = {
+			   .setkey = ssi_aead_setkey,
+			   .setauthsize = ssi_aead_setauthsize,
+			   .encrypt = ssi_aead_encrypt,
+			   .decrypt = ssi_aead_decrypt,
+			   .init = ssi_aead_init,
+			   .exit = ssi_aead_exit,
+			   .ivsize = DES3_EDE_BLOCK_SIZE,
+			   .maxauthsize = SHA1_DIGEST_SIZE,
+			   },
+	 .cipher_mode = DRV_CIPHER_CBC,
+	 .flow_mode = S_DIN_to_DES,
+	 .auth_mode = DRV_HASH_SHA1,
+	 },
 	{
-		.name = "authenc(hmac(sha256),cbc(aes))",
-		.driver_name = "authenc-hmac-sha256-cbc-aes-dx",
-		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
-			.setkey = ssi_aead_setkey,
-			.setauthsize = ssi_aead_setauthsize,
-			.encrypt = ssi_aead_encrypt,
-			.decrypt = ssi_aead_decrypt,
-			.init = ssi_aead_init,
-			.exit = ssi_aead_exit,
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = SHA256_DIGEST_SIZE,
-		},
-		.cipher_mode = DRV_CIPHER_CBC,
-		.flow_mode = S_DIN_to_AES,
-		.auth_mode = DRV_HASH_SHA256,
-	},
+	 .name = "authenc(hmac(sha256),cbc(aes))",
+	 .driver_name = "authenc-hmac-sha256-cbc-aes-dx",
+	 .blocksize = AES_BLOCK_SIZE,
+	 .type = CRYPTO_ALG_TYPE_AEAD,
+	 .template_aead = {
+			   .setkey = ssi_aead_setkey,
+			   .setauthsize = ssi_aead_setauthsize,
+			   .encrypt = ssi_aead_encrypt,
+			   .decrypt = ssi_aead_decrypt,
+			   .init = ssi_aead_init,
+			   .exit = ssi_aead_exit,
+			   .ivsize = AES_BLOCK_SIZE,
+			   .maxauthsize = SHA256_DIGEST_SIZE,
+			   },
+	 .cipher_mode = DRV_CIPHER_CBC,
+	 .flow_mode = S_DIN_to_AES,
+	 .auth_mode = DRV_HASH_SHA256,
+	 },
 	{
-		.name = "authenc(hmac(sha256),cbc(des3_ede))",
-		.driver_name = "authenc-hmac-sha256-cbc-des3-dx",
-		.blocksize = DES3_EDE_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
-			.setkey = ssi_aead_setkey,
-			.setauthsize = ssi_aead_setauthsize,
-			.encrypt = ssi_aead_encrypt,
-			.decrypt = ssi_aead_decrypt,
-			.init = ssi_aead_init,
-			.exit = ssi_aead_exit,
-			.ivsize = DES3_EDE_BLOCK_SIZE,
-			.maxauthsize = SHA256_DIGEST_SIZE,
-		},
-		.cipher_mode = DRV_CIPHER_CBC,
-		.flow_mode = S_DIN_to_DES,
-		.auth_mode = DRV_HASH_SHA256,
-	},
+	 .name = "authenc(hmac(sha256),cbc(des3_ede))",
+	 .driver_name = "authenc-hmac-sha256-cbc-des3-dx",
+	 .blocksize = DES3_EDE_BLOCK_SIZE,
+	 .type = CRYPTO_ALG_TYPE_AEAD,
+	 .template_aead = {
+			   .setkey = ssi_aead_setkey,
+			   .setauthsize = ssi_aead_setauthsize,
+			   .encrypt = ssi_aead_encrypt,
+			   .decrypt = ssi_aead_decrypt,
+			   .init = ssi_aead_init,
+			   .exit = ssi_aead_exit,
+			   .ivsize = DES3_EDE_BLOCK_SIZE,
+			   .maxauthsize = SHA256_DIGEST_SIZE,
+			   },
+	 .cipher_mode = DRV_CIPHER_CBC,
+	 .flow_mode = S_DIN_to_DES,
+	 .auth_mode = DRV_HASH_SHA256,
+	 },
 	{
-		.name = "authenc(xcbc(aes),cbc(aes))",
-		.driver_name = "authenc-xcbc-aes-cbc-aes-dx",
-		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
-			.setkey = ssi_aead_setkey,
-			.setauthsize = ssi_aead_setauthsize,
-			.encrypt = ssi_aead_encrypt,
-			.decrypt = ssi_aead_decrypt,
-			.init = ssi_aead_init,
-			.exit = ssi_aead_exit,
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = AES_BLOCK_SIZE,
-		},
-		.cipher_mode = DRV_CIPHER_CBC,
-		.flow_mode = S_DIN_to_AES,
-		.auth_mode = DRV_HASH_XCBC_MAC,
-	},
+	 .name = "authenc(xcbc(aes),cbc(aes))",
+	 .driver_name = "authenc-xcbc-aes-cbc-aes-dx",
+	 .blocksize = AES_BLOCK_SIZE,
+	 .type = CRYPTO_ALG_TYPE_AEAD,
+	 .template_aead = {
+			   .setkey = ssi_aead_setkey,
+			   .setauthsize = ssi_aead_setauthsize,
+			   .encrypt = ssi_aead_encrypt,
+			   .decrypt = ssi_aead_decrypt,
+			   .init = ssi_aead_init,
+			   .exit = ssi_aead_exit,
+			   .ivsize = AES_BLOCK_SIZE,
+			   .maxauthsize = AES_BLOCK_SIZE,
+			   },
+	 .cipher_mode = DRV_CIPHER_CBC,
+	 .flow_mode = S_DIN_to_AES,
+	 .auth_mode = DRV_HASH_XCBC_MAC,
+	 },
 	{
-		.name = "authenc(hmac(sha1),rfc3686(ctr(aes)))",
-		.driver_name = "authenc-hmac-sha1-rfc3686-ctr-aes-dx",
-		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
-			.setkey = ssi_aead_setkey,
-			.setauthsize = ssi_aead_setauthsize,
-			.encrypt = ssi_aead_encrypt,
-			.decrypt = ssi_aead_decrypt,
-			.init = ssi_aead_init,
-			.exit = ssi_aead_exit,
-			.ivsize = CTR_RFC3686_IV_SIZE,
-			.maxauthsize = SHA1_DIGEST_SIZE,
-		},
-		.cipher_mode = DRV_CIPHER_CTR,
-		.flow_mode = S_DIN_to_AES,
-		.auth_mode = DRV_HASH_SHA1,
-	},
+	 .name = "authenc(hmac(sha1),rfc3686(ctr(aes)))",
+	 .driver_name = "authenc-hmac-sha1-rfc3686-ctr-aes-dx",
+	 .blocksize = 1,
+	 .type = CRYPTO_ALG_TYPE_AEAD,
+	 .template_aead = {
+			   .setkey = ssi_aead_setkey,
+			   .setauthsize = ssi_aead_setauthsize,
+			   .encrypt = ssi_aead_encrypt,
+			   .decrypt = ssi_aead_decrypt,
+			   .init = ssi_aead_init,
+			   .exit = ssi_aead_exit,
+			   .ivsize = CTR_RFC3686_IV_SIZE,
+			   .maxauthsize = SHA1_DIGEST_SIZE,
+			   },
+	 .cipher_mode = DRV_CIPHER_CTR,
+	 .flow_mode = S_DIN_to_AES,
+	 .auth_mode = DRV_HASH_SHA1,
+	 },
 	{
-		.name = "authenc(hmac(sha256),rfc3686(ctr(aes)))",
-		.driver_name = "authenc-hmac-sha256-rfc3686-ctr-aes-dx",
-		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
-			.setkey = ssi_aead_setkey,
-			.setauthsize = ssi_aead_setauthsize,
-			.encrypt = ssi_aead_encrypt,
-			.decrypt = ssi_aead_decrypt,
-			.init = ssi_aead_init,
-			.exit = ssi_aead_exit,
-			.ivsize = CTR_RFC3686_IV_SIZE,
-			.maxauthsize = SHA256_DIGEST_SIZE,
-		},
-		.cipher_mode = DRV_CIPHER_CTR,
-		.flow_mode = S_DIN_to_AES,
-		.auth_mode = DRV_HASH_SHA256,
-	},
+	 .name = "authenc(hmac(sha256),rfc3686(ctr(aes)))",
+	 .driver_name = "authenc-hmac-sha256-rfc3686-ctr-aes-dx",
+	 .blocksize = 1,
+	 .type = CRYPTO_ALG_TYPE_AEAD,
+	 .template_aead = {
+			   .setkey = ssi_aead_setkey,
+			   .setauthsize = ssi_aead_setauthsize,
+			   .encrypt = ssi_aead_encrypt,
+			   .decrypt = ssi_aead_decrypt,
+			   .init = ssi_aead_init,
+			   .exit = ssi_aead_exit,
+			   .ivsize = CTR_RFC3686_IV_SIZE,
+			   .maxauthsize = SHA256_DIGEST_SIZE,
+			   },
+	 .cipher_mode = DRV_CIPHER_CTR,
+	 .flow_mode = S_DIN_to_AES,
+	 .auth_mode = DRV_HASH_SHA256,
+	 },
 	{
-		.name = "authenc(xcbc(aes),rfc3686(ctr(aes)))",
-		.driver_name = "authenc-xcbc-aes-rfc3686-ctr-aes-dx",
-		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
-			.setkey = ssi_aead_setkey,
-			.setauthsize = ssi_aead_setauthsize,
-			.encrypt = ssi_aead_encrypt,
-			.decrypt = ssi_aead_decrypt,
-			.init = ssi_aead_init,
-			.exit = ssi_aead_exit,
-			.ivsize = CTR_RFC3686_IV_SIZE,
-			.maxauthsize = AES_BLOCK_SIZE,
-		},
-		.cipher_mode = DRV_CIPHER_CTR,
-		.flow_mode = S_DIN_to_AES,
-		.auth_mode = DRV_HASH_XCBC_MAC,
-	},
+	 .name = "authenc(xcbc(aes),rfc3686(ctr(aes)))",
+	 .driver_name = "authenc-xcbc-aes-rfc3686-ctr-aes-dx",
+	 .blocksize = 1,
+	 .type = CRYPTO_ALG_TYPE_AEAD,
+	 .template_aead = {
+			   .setkey = ssi_aead_setkey,
+			   .setauthsize = ssi_aead_setauthsize,
+			   .encrypt = ssi_aead_encrypt,
+			   .decrypt = ssi_aead_decrypt,
+			   .init = ssi_aead_init,
+			   .exit = ssi_aead_exit,
+			   .ivsize = CTR_RFC3686_IV_SIZE,
+			   .maxauthsize = AES_BLOCK_SIZE,
+			   },
+	 .cipher_mode = DRV_CIPHER_CTR,
+	 .flow_mode = S_DIN_to_AES,
+	 .auth_mode = DRV_HASH_XCBC_MAC,
+	 },
 #if SSI_CC_HAS_AES_CCM
 	{
-		.name = "ccm(aes)",
-		.driver_name = "ccm-aes-dx",
-		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
-			.setkey = ssi_aead_setkey,
-			.setauthsize = ssi_ccm_setauthsize,
-			.encrypt = ssi_aead_encrypt,
-			.decrypt = ssi_aead_decrypt,
-			.init = ssi_aead_init,
-			.exit = ssi_aead_exit,
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = AES_BLOCK_SIZE,
-		},
-		.cipher_mode = DRV_CIPHER_CCM,
-		.flow_mode = S_DIN_to_AES,
-		.auth_mode = DRV_HASH_NULL,
-	},
+	 .name = "ccm(aes)",
+	 .driver_name = "ccm-aes-dx",
+	 .blocksize = 1,
+	 .type = CRYPTO_ALG_TYPE_AEAD,
+	 .template_aead = {
+			   .setkey = ssi_aead_setkey,
+			   .setauthsize = ssi_ccm_setauthsize,
+			   .encrypt = ssi_aead_encrypt,
+			   .decrypt = ssi_aead_decrypt,
+			   .init = ssi_aead_init,
+			   .exit = ssi_aead_exit,
+			   .ivsize = AES_BLOCK_SIZE,
+			   .maxauthsize = AES_BLOCK_SIZE,
+			   },
+	 .cipher_mode = DRV_CIPHER_CCM,
+	 .flow_mode = S_DIN_to_AES,
+	 .auth_mode = DRV_HASH_NULL,
+	 },
 	{
-		.name = "rfc4309(ccm(aes))",
-		.driver_name = "rfc4309-ccm-aes-dx",
-		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
-			.setkey = ssi_rfc4309_ccm_setkey,
-			.setauthsize = ssi_rfc4309_ccm_setauthsize,
-			.encrypt = ssi_rfc4309_ccm_encrypt,
-			.decrypt = ssi_rfc4309_ccm_decrypt,
-			.init = ssi_aead_init,
-			.exit = ssi_aead_exit,
-			.ivsize = CCM_BLOCK_IV_SIZE,
-			.maxauthsize = AES_BLOCK_SIZE,
-		},
-		.cipher_mode = DRV_CIPHER_CCM,
-		.flow_mode = S_DIN_to_AES,
-		.auth_mode = DRV_HASH_NULL,
-	},
-#endif /*SSI_CC_HAS_AES_CCM*/
+	 .name = "rfc4309(ccm(aes))",
+	 .driver_name = "rfc4309-ccm-aes-dx",
+	 .blocksize = 1,
+	 .type = CRYPTO_ALG_TYPE_AEAD,
+	 .template_aead = {
+			   .setkey = ssi_rfc4309_ccm_setkey,
+			   .setauthsize = ssi_rfc4309_ccm_setauthsize,
+			   .encrypt = ssi_rfc4309_ccm_encrypt,
+			   .decrypt = ssi_rfc4309_ccm_decrypt,
+			   .init = ssi_aead_init,
+			   .exit = ssi_aead_exit,
+			   .ivsize = CCM_BLOCK_IV_SIZE,
+			   .maxauthsize = AES_BLOCK_SIZE,
+			   },
+	 .cipher_mode = DRV_CIPHER_CCM,
+	 .flow_mode = S_DIN_to_AES,
+	 .auth_mode = DRV_HASH_NULL,
+	 },
+#endif /*SSI_CC_HAS_AES_CCM */
 #if SSI_CC_HAS_AES_GCM
 	{
-		.name = "gcm(aes)",
-		.driver_name = "gcm-aes-dx",
-		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
-			.setkey = ssi_aead_setkey,
-			.setauthsize = ssi_gcm_setauthsize,
-			.encrypt = ssi_aead_encrypt,
-			.decrypt = ssi_aead_decrypt,
-			.init = ssi_aead_init,
-			.exit = ssi_aead_exit,
-			.ivsize = 12,
-			.maxauthsize = AES_BLOCK_SIZE,
-		},
-		.cipher_mode = DRV_CIPHER_GCTR,
-		.flow_mode = S_DIN_to_AES,
-		.auth_mode = DRV_HASH_NULL,
-	},
+	 .name = "gcm(aes)",
+	 .driver_name = "gcm-aes-dx",
+	 .blocksize = 1,
+	 .type = CRYPTO_ALG_TYPE_AEAD,
+	 .template_aead = {
+			   .setkey = ssi_aead_setkey,
+			   .setauthsize = ssi_gcm_setauthsize,
+			   .encrypt = ssi_aead_encrypt,
+			   .decrypt = ssi_aead_decrypt,
+			   .init = ssi_aead_init,
+			   .exit = ssi_aead_exit,
+			   .ivsize = 12,
+			   .maxauthsize = AES_BLOCK_SIZE,
+			   },
+	 .cipher_mode = DRV_CIPHER_GCTR,
+	 .flow_mode = S_DIN_to_AES,
+	 .auth_mode = DRV_HASH_NULL,
+	 },
 	{
-		.name = "rfc4106(gcm(aes))",
-		.driver_name = "rfc4106-gcm-aes-dx",
-		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
-			.setkey = ssi_rfc4106_gcm_setkey,
-			.setauthsize = ssi_rfc4106_gcm_setauthsize,
-			.encrypt = ssi_rfc4106_gcm_encrypt,
-			.decrypt = ssi_rfc4106_gcm_decrypt,
-			.init = ssi_aead_init,
-			.exit = ssi_aead_exit,
-			.ivsize = GCM_BLOCK_RFC4_IV_SIZE,
-			.maxauthsize = AES_BLOCK_SIZE,
-		},
-		.cipher_mode = DRV_CIPHER_GCTR,
-		.flow_mode = S_DIN_to_AES,
-		.auth_mode = DRV_HASH_NULL,
-	},
+	 .name = "rfc4106(gcm(aes))",
+	 .driver_name = "rfc4106-gcm-aes-dx",
+	 .blocksize = 1,
+	 .type = CRYPTO_ALG_TYPE_AEAD,
+	 .template_aead = {
+			   .setkey = ssi_rfc4106_gcm_setkey,
+			   .setauthsize = ssi_rfc4106_gcm_setauthsize,
+			   .encrypt = ssi_rfc4106_gcm_encrypt,
+			   .decrypt = ssi_rfc4106_gcm_decrypt,
+			   .init = ssi_aead_init,
+			   .exit = ssi_aead_exit,
+			   .ivsize = GCM_BLOCK_RFC4_IV_SIZE,
+			   .maxauthsize = AES_BLOCK_SIZE,
+			   },
+	 .cipher_mode = DRV_CIPHER_GCTR,
+	 .flow_mode = S_DIN_to_AES,
+	 .auth_mode = DRV_HASH_NULL,
+	 },
 	{
-		.name = "rfc4543(gcm(aes))",
-		.driver_name = "rfc4543-gcm-aes-dx",
-		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
-			.setkey = ssi_rfc4543_gcm_setkey,
-			.setauthsize = ssi_rfc4543_gcm_setauthsize,
-			.encrypt = ssi_rfc4543_gcm_encrypt,
-			.decrypt = ssi_rfc4543_gcm_decrypt,
-			.init = ssi_aead_init,
-			.exit = ssi_aead_exit,
-			.ivsize = GCM_BLOCK_RFC4_IV_SIZE,
-			.maxauthsize = AES_BLOCK_SIZE,
-		},
-		.cipher_mode = DRV_CIPHER_GCTR,
-		.flow_mode = S_DIN_to_AES,
-		.auth_mode = DRV_HASH_NULL,
-	},
-#endif /*SSI_CC_HAS_AES_GCM*/
+	 .name = "rfc4543(gcm(aes))",
+	 .driver_name = "rfc4543-gcm-aes-dx",
+	 .blocksize = 1,
+	 .type = CRYPTO_ALG_TYPE_AEAD,
+	 .template_aead = {
+			   .setkey = ssi_rfc4543_gcm_setkey,
+			   .setauthsize = ssi_rfc4543_gcm_setauthsize,
+			   .encrypt = ssi_rfc4543_gcm_encrypt,
+			   .decrypt = ssi_rfc4543_gcm_decrypt,
+			   .init = ssi_aead_init,
+			   .exit = ssi_aead_exit,
+			   .ivsize = GCM_BLOCK_RFC4_IV_SIZE,
+			   .maxauthsize = AES_BLOCK_SIZE,
+			   },
+	 .cipher_mode = DRV_CIPHER_GCTR,
+	 .flow_mode = S_DIN_to_AES,
+	 .auth_mode = DRV_HASH_NULL,
+	 },
+#endif /*SSI_CC_HAS_AES_GCM */
 };
 
-static struct ssi_crypto_alg *ssi_aead_create_alg(struct ssi_alg_template *template)
+static struct ssi_crypto_alg *ssi_aead_create_alg(struct ssi_alg_template
+						  *template)
 {
 	struct ssi_crypto_alg *t_alg;
 	struct aead_alg *alg;
@@ -2673,7 +2711,7 @@ static struct ssi_crypto_alg *ssi_aead_create_alg(struct ssi_alg_template *templ
 
 	alg->base.cra_ctxsize = sizeof(struct ssi_aead_ctx);
 	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY |
-			 template->type;
+	    template->type;
 	alg->init = ssi_aead_init;
 	alg->exit = ssi_aead_exit;
 
@@ -2690,11 +2728,12 @@ int ssi_aead_free(struct ssi_drvdata *drvdata)
 {
 	struct ssi_crypto_alg *t_alg, *n;
 	struct ssi_aead_handle *aead_handle =
-		(struct ssi_aead_handle *)drvdata->aead_handle;
+	    (struct ssi_aead_handle *)drvdata->aead_handle;
 
 	if (aead_handle) {
 		/* Remove registered algs */
-		list_for_each_entry_safe(t_alg, n, &aead_handle->aead_list, entry) {
+		list_for_each_entry_safe(t_alg, n, &aead_handle->aead_list,
+					 entry) {
 			crypto_unregister_aead(&t_alg->aead_alg);
 			list_del(&t_alg->entry);
 			kfree(t_alg);
@@ -2722,8 +2761,8 @@ int ssi_aead_alloc(struct ssi_drvdata *drvdata)
 	INIT_LIST_HEAD(&aead_handle->aead_list);
 	drvdata->aead_handle = aead_handle;
 
-	aead_handle->sram_workspace_addr = ssi_sram_mgr_alloc(
-		drvdata, MAX_HMAC_DIGEST_SIZE);
+	aead_handle->sram_workspace_addr =
+	    ssi_sram_mgr_alloc(drvdata, MAX_HMAC_DIGEST_SIZE);
 	if (aead_handle->sram_workspace_addr == NULL_SRAM_ADDR) {
 		SSI_LOG_ERR("SRAM pool exhausted\n");
 		rc = -ENOMEM;
@@ -2747,7 +2786,8 @@ int ssi_aead_alloc(struct ssi_drvdata *drvdata)
 			goto fail2;
 		} else {
 			list_add_tail(&t_alg->entry, &aead_handle->aead_list);
-			SSI_LOG_DEBUG("Registered %s\n", t_alg->aead_alg.base.cra_driver_name);
+			SSI_LOG_DEBUG("Registered %s\n",
+				      t_alg->aead_alg.base.cra_driver_name);
 		}
 	}
 
-- 
2.1.4
