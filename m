From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 13/22] staging: ccree: fix line indentation and breaks
Date: Tue, 15 Aug 2017 09:26:41 +0300
Message-ID: <1502778412-16255-14-git-send-email-gilad@benyossef.com>
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

Fix source line indentation and breaks

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_hash.c | 494 ++++++++++++++++++++++-----------------
 1 file changed, 284 insertions(+), 210 deletions(-)

diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index b95c3ce..e2dc5d8 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -33,7 +33,6 @@
 
 #define SSI_MAX_AHASH_SEQ_LEN 12
 #define SSI_MAX_HASH_OPAD_TMP_KEYS_SIZE MAX(SSI_MAX_HASH_BLCK_SIZE, 3 * AES_BLOCK_SIZE)
-
 struct ssi_hash_handle {
 	ssi_sram_addr_t digest_len_sram_addr; /* const value in SRAM*/
 	ssi_sram_addr_t larval_digest_sram_addr;   /* const value in SRAM */
@@ -64,10 +63,9 @@ static const u64 sha512_init[] = {
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
 				       struct cc_hw_desc desc[],
@@ -94,7 +92,8 @@ struct ssi_hash_ctx {
 	 * the initial digest if HASH.
 	 */
 	u8 digest_buff[SSI_MAX_HASH_DIGEST_SIZE]  ____cacheline_aligned;
-	u8 opad_tmp_keys_buff[SSI_MAX_HASH_OPAD_TMP_KEYS_SIZE]  ____cacheline_aligned;
+	u8 opad_tmp_keys_buff[SSI_MAX_HASH_OPAD_TMP_KEYS_SIZE]
+	    ____cacheline_aligned;
 
 	dma_addr_t opad_tmp_keys_dma_addr  ____cacheline_aligned;
 	dma_addr_t digest_buff_dma_addr;
@@ -107,18 +106,17 @@ struct ssi_hash_ctx {
 	bool is_hmac;
 };
 
-static void ssi_hash_create_data_desc(
-	struct ahash_req_ctx *areq_ctx,
-	struct ssi_hash_ctx *ctx,
-	unsigned int flow_mode, struct cc_hw_desc desc[],
-	bool is_not_last_data,
-	unsigned int *seq_size);
+static void ssi_hash_create_data_desc(struct ahash_req_ctx *areq_ctx,
+				      struct ssi_hash_ctx *ctx,
+				      unsigned int flow_mode,
+				      struct cc_hw_desc desc[],
+				      bool is_not_last_data,
+				      unsigned int *seq_size);
 
 static inline void ssi_set_hash_endianity(u32 mode, struct cc_hw_desc *desc)
 {
 	if (unlikely((mode == DRV_HASH_MD5) ||
-		     (mode == DRV_HASH_SHA384) ||
-		     (mode == DRV_HASH_SHA512))) {
+		     (mode == DRV_HASH_SHA384) || (mode == DRV_HASH_SHA512))) {
 		set_bytes_swap(desc, 1);
 	} else {
 		set_cipher_config0(desc, HASH_DIGEST_RESULT_LITTLE_ENDIAN);
@@ -130,17 +128,18 @@ static int ssi_hash_map_result(struct device *dev,
 			       unsigned int digestsize)
 {
 	state->digest_result_dma_addr =
-		dma_map_single(dev, (void *)state->digest_result_buff,
-			       digestsize,
-			       DMA_BIDIRECTIONAL);
+	    dma_map_single(dev, (void *)state->digest_result_buff,
+			   digestsize, DMA_BIDIRECTIONAL);
 	if (unlikely(dma_mapping_error(dev, state->digest_result_dma_addr))) {
-		SSI_LOG_ERR("Mapping digest result buffer %u B for DMA failed\n",
-			    digestsize);
+		SSI_LOG_ERR
+		    ("Mapping digest result buffer %u B for DMA failed\n",
+		     digestsize);
 		return -ENOMEM;
 	}
-	SSI_LOG_DEBUG("Mapped digest result buffer %u B at va=%pK to dma=%pad\n",
-		      digestsize, state->digest_result_buff,
-		      &state->digest_result_dma_addr);
+	SSI_LOG_DEBUG
+	    ("Mapped digest result buffer %u B at va=%pK to dma=%pad\n",
+	     digestsize, state->digest_result_buff,
+	     &state->digest_result_dma_addr);
 
 	return 0;
 }
@@ -150,8 +149,8 @@ static int ssi_hash_map_request(struct device *dev,
 				struct ssi_hash_ctx *ctx)
 {
 	bool is_hmac = ctx->is_hmac;
-	ssi_sram_addr_t larval_digest_addr = ssi_ahash_get_larval_digest_sram_addr(
-					ctx->drvdata, ctx->hash_mode);
+	ssi_sram_addr_t larval_digest_addr =
+	    ssi_ahash_get_larval_digest_sram_addr(ctx->drvdata, ctx->hash_mode);
 	struct ssi_crypto_req ssi_req = {};
 	struct cc_hw_desc desc;
 	int rc = -ENOMEM;
@@ -166,40 +165,56 @@ static int ssi_hash_map_request(struct device *dev,
 		SSI_LOG_ERR("Allocating buff1 in context failed\n");
 		goto fail_buff0;
 	}
-	state->digest_result_buff = kzalloc(SSI_MAX_HASH_DIGEST_SIZE, GFP_KERNEL | GFP_DMA);
+	state->digest_result_buff =
+	    kzalloc(SSI_MAX_HASH_DIGEST_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!state->digest_result_buff) {
-		SSI_LOG_ERR("Allocating digest_result_buff in context failed\n");
+		SSI_LOG_ERR
+		    ("Allocating digest_result_buff in context failed\n");
 		goto fail_buff1;
 	}
-	state->digest_buff = kzalloc(ctx->inter_digestsize, GFP_KERNEL | GFP_DMA);
+	state->digest_buff =
+	    kzalloc(ctx->inter_digestsize, GFP_KERNEL | GFP_DMA);
 	if (!state->digest_buff) {
 		SSI_LOG_ERR("Allocating digest-buffer in context failed\n");
 		goto fail_digest_result_buff;
 	}
 
-	SSI_LOG_DEBUG("Allocated digest-buffer in context ctx->digest_buff=@%p\n", state->digest_buff);
+	SSI_LOG_DEBUG
+	    ("Allocated digest-buffer in context ctx->digest_buff=@%p\n",
+	     state->digest_buff);
 	if (ctx->hw_mode != DRV_CIPHER_XCBC_MAC) {
-		state->digest_bytes_len = kzalloc(HASH_LEN_SIZE, GFP_KERNEL | GFP_DMA);
+		state->digest_bytes_len =
+		    kzalloc(HASH_LEN_SIZE, GFP_KERNEL | GFP_DMA);
 		if (!state->digest_bytes_len) {
-			SSI_LOG_ERR("Allocating digest-bytes-len in context failed\n");
+			SSI_LOG_ERR
+			    ("Allocating digest-bytes-len in context failed\n");
 			goto fail1;
 		}
-		SSI_LOG_DEBUG("Allocated digest-bytes-len in context state->>digest_bytes_len=@%p\n", state->digest_bytes_len);
+		SSI_LOG_DEBUG
+		    ("Allocated digest-bytes-len in context state->>digest_bytes_len=@%p\n",
+		     state->digest_bytes_len);
 	} else {
 		state->digest_bytes_len = NULL;
 	}
 
-	state->opad_digest_buff = kzalloc(ctx->inter_digestsize, GFP_KERNEL | GFP_DMA);
+	state->opad_digest_buff =
+	    kzalloc(ctx->inter_digestsize, GFP_KERNEL | GFP_DMA);
 	if (!state->opad_digest_buff) {
-		SSI_LOG_ERR("Allocating opad-digest-buffer in context failed\n");
+		SSI_LOG_ERR
+		    ("Allocating opad-digest-buffer in context failed\n");
 		goto fail2;
 	}
-	SSI_LOG_DEBUG("Allocated opad-digest-buffer in context state->digest_bytes_len=@%p\n", state->opad_digest_buff);
+	SSI_LOG_DEBUG
+	    ("Allocated opad-digest-buffer in context state->digest_bytes_len=@%p\n",
+	     state->opad_digest_buff);
 
-	state->digest_buff_dma_addr = dma_map_single(dev, (void *)state->digest_buff, ctx->inter_digestsize, DMA_BIDIRECTIONAL);
+	state->digest_buff_dma_addr =
+	    dma_map_single(dev, (void *)state->digest_buff,
+			   ctx->inter_digestsize, DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(dev, state->digest_buff_dma_addr)) {
-		SSI_LOG_ERR("Mapping digest len %d B at va=%pK for DMA failed\n",
-			    ctx->inter_digestsize, state->digest_buff);
+		SSI_LOG_ERR
+		    ("Mapping digest len %d B at va=%pK for DMA failed\n",
+		     ctx->inter_digestsize, state->digest_buff);
 		goto fail3;
 	}
 	SSI_LOG_DEBUG("Mapped digest %d B at va=%pK to dma=%pad\n",
@@ -207,27 +222,42 @@ static int ssi_hash_map_request(struct device *dev,
 		      &state->digest_buff_dma_addr);
 
 	if (is_hmac) {
-		dma_sync_single_for_cpu(dev, ctx->digest_buff_dma_addr, ctx->inter_digestsize, DMA_BIDIRECTIONAL);
-		if ((ctx->hw_mode == DRV_CIPHER_XCBC_MAC) || (ctx->hw_mode == DRV_CIPHER_CMAC)) {
+		dma_sync_single_for_cpu(dev, ctx->digest_buff_dma_addr,
+					ctx->inter_digestsize,
+					DMA_BIDIRECTIONAL);
+		if ((ctx->hw_mode == DRV_CIPHER_XCBC_MAC) ||
+		    (ctx->hw_mode == DRV_CIPHER_CMAC)) {
 			memset(state->digest_buff, 0, ctx->inter_digestsize);
-		} else { /*sha*/
-			memcpy(state->digest_buff, ctx->digest_buff, ctx->inter_digestsize);
+		} else {	/*sha */
+			memcpy(state->digest_buff, ctx->digest_buff,
+			       ctx->inter_digestsize);
 #if (DX_DEV_SHA_MAX > 256)
-			if (unlikely((ctx->hash_mode == DRV_HASH_SHA512) || (ctx->hash_mode == DRV_HASH_SHA384)))
-				memcpy(state->digest_bytes_len, digest_len_sha512_init, HASH_LEN_SIZE);
+			if (unlikely
+			    ((ctx->hash_mode == DRV_HASH_SHA512) ||
+			     (ctx->hash_mode == DRV_HASH_SHA384)))
+				memcpy(state->digest_bytes_len,
+				       digest_len_sha512_init, HASH_LEN_SIZE);
 			else
-				memcpy(state->digest_bytes_len, digest_len_init, HASH_LEN_SIZE);
+				memcpy(state->digest_bytes_len, digest_len_init,
+				       HASH_LEN_SIZE);
 #else
-			memcpy(state->digest_bytes_len, digest_len_init, HASH_LEN_SIZE);
+			memcpy(state->digest_bytes_len, digest_len_init,
+			       HASH_LEN_SIZE);
 #endif
 		}
-		dma_sync_single_for_device(dev, state->digest_buff_dma_addr, ctx->inter_digestsize, DMA_BIDIRECTIONAL);
+		dma_sync_single_for_device(dev, state->digest_buff_dma_addr,
+					   ctx->inter_digestsize,
+					   DMA_BIDIRECTIONAL);
 
 		if (ctx->hash_mode != DRV_HASH_NULL) {
-			dma_sync_single_for_cpu(dev, ctx->opad_tmp_keys_dma_addr, ctx->inter_digestsize, DMA_BIDIRECTIONAL);
-			memcpy(state->opad_digest_buff, ctx->opad_tmp_keys_buff, ctx->inter_digestsize);
+			dma_sync_single_for_cpu(dev,
+						ctx->opad_tmp_keys_dma_addr,
+						ctx->inter_digestsize,
+						DMA_BIDIRECTIONAL);
+			memcpy(state->opad_digest_buff, ctx->opad_tmp_keys_buff,
+			       ctx->inter_digestsize);
 		}
-	} else { /*hash*/
+	} else {		/*hash */
 		/* Copy the initial digests if hash flow. The SRAM contains the
 		 * initial digests in the expected order for all SHA*
 		 */
@@ -245,10 +275,13 @@ static int ssi_hash_map_request(struct device *dev,
 	}
 
 	if (ctx->hw_mode != DRV_CIPHER_XCBC_MAC) {
-		state->digest_bytes_len_dma_addr = dma_map_single(dev, (void *)state->digest_bytes_len, HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
+		state->digest_bytes_len_dma_addr =
+		    dma_map_single(dev, (void *)state->digest_bytes_len,
+				   HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
 		if (dma_mapping_error(dev, state->digest_bytes_len_dma_addr)) {
-			SSI_LOG_ERR("Mapping digest len %u B at va=%pK for DMA failed\n",
-				    HASH_LEN_SIZE, state->digest_bytes_len);
+			SSI_LOG_ERR
+			    ("Mapping digest len %u B at va=%pK for DMA failed\n",
+			     HASH_LEN_SIZE, state->digest_bytes_len);
 			goto fail4;
 		}
 		SSI_LOG_DEBUG("Mapped digest len %u B at va=%pK to dma=%pad\n",
@@ -259,11 +292,13 @@ static int ssi_hash_map_request(struct device *dev,
 	}
 
 	if (is_hmac && ctx->hash_mode != DRV_HASH_NULL) {
-		state->opad_digest_dma_addr = dma_map_single(dev, (void *)state->opad_digest_buff, ctx->inter_digestsize, DMA_BIDIRECTIONAL);
+		state->opad_digest_dma_addr =
+		    dma_map_single(dev, (void *)state->opad_digest_buff,
+				   ctx->inter_digestsize, DMA_BIDIRECTIONAL);
 		if (dma_mapping_error(dev, state->opad_digest_dma_addr)) {
-			SSI_LOG_ERR("Mapping opad digest %d B at va=%pK for DMA failed\n",
-				    ctx->inter_digestsize,
-				    state->opad_digest_buff);
+			SSI_LOG_ERR
+			    ("Mapping opad digest %d B at va=%pK for DMA failed\n",
+			     ctx->inter_digestsize, state->opad_digest_buff);
 			goto fail5;
 		}
 		SSI_LOG_DEBUG("Mapped opad digest %d B at va=%pK to dma=%pad\n",
@@ -281,12 +316,14 @@ static int ssi_hash_map_request(struct device *dev,
 
 fail5:
 	if (state->digest_bytes_len_dma_addr != 0) {
-		dma_unmap_single(dev, state->digest_bytes_len_dma_addr, HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
+		dma_unmap_single(dev, state->digest_bytes_len_dma_addr,
+				 HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
 		state->digest_bytes_len_dma_addr = 0;
 	}
 fail4:
 	if (state->digest_buff_dma_addr != 0) {
-		dma_unmap_single(dev, state->digest_buff_dma_addr, ctx->inter_digestsize, DMA_BIDIRECTIONAL);
+		dma_unmap_single(dev, state->digest_buff_dma_addr,
+				 ctx->inter_digestsize, DMA_BIDIRECTIONAL);
 		state->digest_buff_dma_addr = 0;
 	}
 fail3:
@@ -294,7 +331,7 @@ static int ssi_hash_map_request(struct device *dev,
 fail2:
 	kfree(state->digest_bytes_len);
 fail1:
-	 kfree(state->digest_buff);
+	kfree(state->digest_buff);
 fail_digest_result_buff:
 	kfree(state->digest_result_buff);
 	state->digest_result_buff = NULL;
@@ -315,22 +352,25 @@ static void ssi_hash_unmap_request(struct device *dev,
 	if (state->digest_buff_dma_addr != 0) {
 		dma_unmap_single(dev, state->digest_buff_dma_addr,
 				 ctx->inter_digestsize, DMA_BIDIRECTIONAL);
-		SSI_LOG_DEBUG("Unmapped digest-buffer: digest_buff_dma_addr=%pad\n",
-			      &state->digest_buff_dma_addr);
+		SSI_LOG_DEBUG
+		    ("Unmapped digest-buffer: digest_buff_dma_addr=%pad\n",
+		     &state->digest_buff_dma_addr);
 		state->digest_buff_dma_addr = 0;
 	}
 	if (state->digest_bytes_len_dma_addr != 0) {
 		dma_unmap_single(dev, state->digest_bytes_len_dma_addr,
 				 HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
-		SSI_LOG_DEBUG("Unmapped digest-bytes-len buffer: digest_bytes_len_dma_addr=%pad\n",
-			      &state->digest_bytes_len_dma_addr);
+		SSI_LOG_DEBUG
+		    ("Unmapped digest-bytes-len buffer: digest_bytes_len_dma_addr=%pad\n",
+		     &state->digest_bytes_len_dma_addr);
 		state->digest_bytes_len_dma_addr = 0;
 	}
 	if (state->opad_digest_dma_addr != 0) {
 		dma_unmap_single(dev, state->opad_digest_dma_addr,
 				 ctx->inter_digestsize, DMA_BIDIRECTIONAL);
-		SSI_LOG_DEBUG("Unmapped opad-digest: opad_digest_dma_addr=%pad\n",
-			      &state->opad_digest_dma_addr);
+		SSI_LOG_DEBUG
+		    ("Unmapped opad-digest: opad_digest_dma_addr=%pad\n",
+		     &state->opad_digest_dma_addr);
 		state->opad_digest_dma_addr = 0;
 	}
 
@@ -349,20 +389,18 @@ static void ssi_hash_unmap_result(struct device *dev,
 	if (state->digest_result_dma_addr != 0) {
 		dma_unmap_single(dev,
 				 state->digest_result_dma_addr,
-				 digestsize,
-				  DMA_BIDIRECTIONAL);
-		SSI_LOG_DEBUG("unmpa digest result buffer va (%pK) pa (%pad) len %u\n",
-			      state->digest_result_buff,
-			      &state->digest_result_dma_addr,
-			      digestsize);
-		memcpy(result,
-		       state->digest_result_buff,
-		       digestsize);
+				 digestsize, DMA_BIDIRECTIONAL);
+		SSI_LOG_DEBUG
+		    ("unmpa digest result buffer va (%pK) pa (%pad) len %u\n",
+		     state->digest_result_buff, &state->digest_result_dma_addr,
+		     digestsize);
+		memcpy(result, state->digest_result_buff, digestsize);
 	}
 	state->digest_result_dma_addr = 0;
 }
 
-static void ssi_hash_update_complete(struct device *dev, void *ssi_req, void __iomem *cc_base)
+static void ssi_hash_update_complete(struct device *dev, void *ssi_req,
+				     void __iomem *cc_base)
 {
 	struct ahash_request *req = (struct ahash_request *)ssi_req;
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
@@ -373,7 +411,8 @@ static void ssi_hash_update_complete(struct device *dev, void *ssi_req, void __i
 	req->base.complete(&req->base, 0);
 }
 
-static void ssi_hash_digest_complete(struct device *dev, void *ssi_req, void __iomem *cc_base)
+static void ssi_hash_digest_complete(struct device *dev, void *ssi_req,
+				     void __iomem *cc_base)
 {
 	struct ahash_request *req = (struct ahash_request *)ssi_req;
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
@@ -389,7 +428,8 @@ static void ssi_hash_digest_complete(struct device *dev, void *ssi_req, void __i
 	req->base.complete(&req->base, 0);
 }
 
-static void ssi_hash_complete(struct device *dev, void *ssi_req, void __iomem *cc_base)
+static void ssi_hash_complete(struct device *dev, void *ssi_req,
+			      void __iomem *cc_base)
 {
 	struct ahash_request *req = (struct ahash_request *)ssi_req;
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
@@ -409,19 +449,19 @@ static int ssi_hash_digest(struct ahash_req_ctx *state,
 			   struct ssi_hash_ctx *ctx,
 			   unsigned int digestsize,
 			   struct scatterlist *src,
-			   unsigned int nbytes, u8 *result,
-			   void *async_req)
+			   unsigned int nbytes, u8 *result, void *async_req)
 {
 	struct device *dev = &ctx->drvdata->plat_dev->dev;
 	bool is_hmac = ctx->is_hmac;
 	struct ssi_crypto_req ssi_req = {};
 	struct cc_hw_desc desc[SSI_MAX_AHASH_SEQ_LEN];
-	ssi_sram_addr_t larval_digest_addr = ssi_ahash_get_larval_digest_sram_addr(
-					ctx->drvdata, ctx->hash_mode);
+	ssi_sram_addr_t larval_digest_addr =
+	    ssi_ahash_get_larval_digest_sram_addr(ctx->drvdata, ctx->hash_mode);
 	int idx = 0;
 	int rc = 0;
 
-	SSI_LOG_DEBUG("===== %s-digest (%d) ====\n", is_hmac ? "hmac" : "hash", nbytes);
+	SSI_LOG_DEBUG("===== %s-digest (%d) ====\n", is_hmac ? "hmac" : "hash",
+		      nbytes);
 
 	if (unlikely(ssi_hash_map_request(dev, state, ctx) != 0)) {
 		SSI_LOG_ERR("map_ahash_source() failed\n");
@@ -433,7 +473,9 @@ static int ssi_hash_digest(struct ahash_req_ctx *state,
 		return -ENOMEM;
 	}
 
-	if (unlikely(ssi_buffer_mgr_map_hash_request_final(ctx->drvdata, state, src, nbytes, 1) != 0)) {
+	if (unlikely
+	    (ssi_buffer_mgr_map_hash_request_final
+	     (ctx->drvdata, state, src, nbytes, 1) != 0)) {
 		SSI_LOG_ERR("map_ahash_request_final() failed\n");
 		return -ENOMEM;
 	}
@@ -513,8 +555,9 @@ static int ssi_hash_digest(struct ahash_req_ctx *state,
 		hw_desc_init(&desc[idx]);
 		set_cipher_mode(&desc[idx], ctx->hw_mode);
 		set_din_sram(&desc[idx],
-			     ssi_ahash_get_initial_digest_len_sram_addr(
-ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
+			     ssi_ahash_get_initial_digest_len_sram_addr(ctx->drvdata,
+									ctx->hash_mode),
+			     HASH_LEN_SIZE);
 		set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
 		set_flow_mode(&desc[idx], S_DIN_to_HASH);
 		set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
@@ -552,7 +595,8 @@ ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
 		rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
 		if (unlikely(rc != -EINPROGRESS)) {
 			SSI_LOG_ERR("send_request() failed (rc=%d)\n", rc);
-			ssi_buffer_mgr_unmap_hash_request(dev, state, src, true);
+			ssi_buffer_mgr_unmap_hash_request(dev, state, src,
+							  true);
 			ssi_hash_unmap_result(dev, state, digestsize, result);
 			ssi_hash_unmap_request(dev, state, ctx);
 		}
@@ -560,9 +604,11 @@ ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
 		rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 0);
 		if (rc != 0) {
 			SSI_LOG_ERR("send_request() failed (rc=%d)\n", rc);
-			ssi_buffer_mgr_unmap_hash_request(dev, state, src, true);
+			ssi_buffer_mgr_unmap_hash_request(dev, state, src,
+							  true);
 		} else {
-			ssi_buffer_mgr_unmap_hash_request(dev, state, src, false);
+			ssi_buffer_mgr_unmap_hash_request(dev, state, src,
+							  false);
 		}
 		ssi_hash_unmap_result(dev, state, digestsize, result);
 		ssi_hash_unmap_request(dev, state, ctx);
@@ -574,8 +620,7 @@ static int ssi_hash_update(struct ahash_req_ctx *state,
 			   struct ssi_hash_ctx *ctx,
 			   unsigned int block_size,
 			   struct scatterlist *src,
-			   unsigned int nbytes,
-			   void *async_req)
+			   unsigned int nbytes, void *async_req)
 {
 	struct device *dev = &ctx->drvdata->plat_dev->dev;
 	struct ssi_crypto_req ssi_req = {};
@@ -584,14 +629,15 @@ static int ssi_hash_update(struct ahash_req_ctx *state,
 	int rc;
 
 	SSI_LOG_DEBUG("===== %s-update (%d) ====\n", ctx->is_hmac ?
-					"hmac" : "hash", nbytes);
+		      "hmac" : "hash", nbytes);
 
 	if (nbytes == 0) {
 		/* no real updates required */
 		return 0;
 	}
 
-	rc = ssi_buffer_mgr_map_hash_request_update(ctx->drvdata, state, src, nbytes, block_size);
+	rc = ssi_buffer_mgr_map_hash_request_update(ctx->drvdata, state, src,
+						    nbytes, block_size);
 	if (unlikely(rc)) {
 		if (rc == 1) {
 			SSI_LOG_DEBUG(" data size not require HW update %x\n",
@@ -652,15 +698,18 @@ static int ssi_hash_update(struct ahash_req_ctx *state,
 		rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
 		if (unlikely(rc != -EINPROGRESS)) {
 			SSI_LOG_ERR("send_request() failed (rc=%d)\n", rc);
-			ssi_buffer_mgr_unmap_hash_request(dev, state, src, true);
+			ssi_buffer_mgr_unmap_hash_request(dev, state, src,
+							  true);
 		}
 	} else {
 		rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 0);
 		if (rc != 0) {
 			SSI_LOG_ERR("send_request() failed (rc=%d)\n", rc);
-			ssi_buffer_mgr_unmap_hash_request(dev, state, src, true);
+			ssi_buffer_mgr_unmap_hash_request(dev, state, src,
+							  true);
 		} else {
-			ssi_buffer_mgr_unmap_hash_request(dev, state, src, false);
+			ssi_buffer_mgr_unmap_hash_request(dev, state, src,
+							  false);
 		}
 	}
 	return rc;
@@ -670,9 +719,7 @@ static int ssi_hash_finup(struct ahash_req_ctx *state,
 			  struct ssi_hash_ctx *ctx,
 			  unsigned int digestsize,
 			  struct scatterlist *src,
-			  unsigned int nbytes,
-			  u8 *result,
-			  void *async_req)
+			  unsigned int nbytes, u8 *result, void *async_req)
 {
 	struct device *dev = &ctx->drvdata->plat_dev->dev;
 	bool is_hmac = ctx->is_hmac;
@@ -681,9 +728,12 @@ static int ssi_hash_finup(struct ahash_req_ctx *state,
 	int idx = 0;
 	int rc;
 
-	SSI_LOG_DEBUG("===== %s-finup (%d) ====\n", is_hmac ? "hmac" : "hash", nbytes);
+	SSI_LOG_DEBUG("===== %s-finup (%d) ====\n", is_hmac ? "hmac" : "hash",
+		      nbytes);
 
-	if (unlikely(ssi_buffer_mgr_map_hash_request_final(ctx->drvdata, state, src, nbytes, 1) != 0)) {
+	if (unlikely
+	    (ssi_buffer_mgr_map_hash_request_final
+	     (ctx->drvdata, state, src, nbytes, 1) != 0)) {
 		SSI_LOG_ERR("map_ahash_request_final() failed\n");
 		return -ENOMEM;
 	}
@@ -743,8 +793,9 @@ static int ssi_hash_finup(struct ahash_req_ctx *state,
 		hw_desc_init(&desc[idx]);
 		set_cipher_mode(&desc[idx], ctx->hw_mode);
 		set_din_sram(&desc[idx],
-			     ssi_ahash_get_initial_digest_len_sram_addr(
-ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
+			     ssi_ahash_get_initial_digest_len_sram_addr(ctx->drvdata,
+									ctx->hash_mode),
+			     HASH_LEN_SIZE);
 		set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
 		set_flow_mode(&desc[idx], S_DIN_to_HASH);
 		set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
@@ -782,17 +833,20 @@ ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
 		rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
 		if (unlikely(rc != -EINPROGRESS)) {
 			SSI_LOG_ERR("send_request() failed (rc=%d)\n", rc);
-			ssi_buffer_mgr_unmap_hash_request(dev, state, src, true);
+			ssi_buffer_mgr_unmap_hash_request(dev, state, src,
+							  true);
 			ssi_hash_unmap_result(dev, state, digestsize, result);
 		}
 	} else {
 		rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 0);
 		if (rc != 0) {
 			SSI_LOG_ERR("send_request() failed (rc=%d)\n", rc);
-			ssi_buffer_mgr_unmap_hash_request(dev, state, src, true);
+			ssi_buffer_mgr_unmap_hash_request(dev, state, src,
+							  true);
 			ssi_hash_unmap_result(dev, state, digestsize, result);
 		} else {
-			ssi_buffer_mgr_unmap_hash_request(dev, state, src, false);
+			ssi_buffer_mgr_unmap_hash_request(dev, state, src,
+							  false);
 			ssi_hash_unmap_result(dev, state, digestsize, result);
 			ssi_hash_unmap_request(dev, state, ctx);
 		}
@@ -804,9 +858,7 @@ static int ssi_hash_final(struct ahash_req_ctx *state,
 			  struct ssi_hash_ctx *ctx,
 			  unsigned int digestsize,
 			  struct scatterlist *src,
-			  unsigned int nbytes,
-			  u8 *result,
-			  void *async_req)
+			  unsigned int nbytes, u8 *result, void *async_req)
 {
 	struct device *dev = &ctx->drvdata->plat_dev->dev;
 	bool is_hmac = ctx->is_hmac;
@@ -815,9 +867,12 @@ static int ssi_hash_final(struct ahash_req_ctx *state,
 	int idx = 0;
 	int rc;
 
-	SSI_LOG_DEBUG("===== %s-final (%d) ====\n", is_hmac ? "hmac" : "hash", nbytes);
+	SSI_LOG_DEBUG("===== %s-final (%d) ====\n", is_hmac ? "hmac" : "hash",
+		      nbytes);
 
-	if (unlikely(ssi_buffer_mgr_map_hash_request_final(ctx->drvdata, state, src, nbytes, 0) != 0)) {
+	if (unlikely
+	    (ssi_buffer_mgr_map_hash_request_final
+	     (ctx->drvdata, state, src, nbytes, 0) != 0)) {
 		SSI_LOG_ERR("map_ahash_request_final() failed\n");
 		return -ENOMEM;
 	}
@@ -888,8 +943,9 @@ static int ssi_hash_final(struct ahash_req_ctx *state,
 		hw_desc_init(&desc[idx]);
 		set_cipher_mode(&desc[idx], ctx->hw_mode);
 		set_din_sram(&desc[idx],
-			     ssi_ahash_get_initial_digest_len_sram_addr(
-ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
+			     ssi_ahash_get_initial_digest_len_sram_addr(ctx->drvdata,
+									ctx->hash_mode),
+			     HASH_LEN_SIZE);
 		set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
 		set_flow_mode(&desc[idx], S_DIN_to_HASH);
 		set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
@@ -926,17 +982,20 @@ ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
 		rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
 		if (unlikely(rc != -EINPROGRESS)) {
 			SSI_LOG_ERR("send_request() failed (rc=%d)\n", rc);
-			ssi_buffer_mgr_unmap_hash_request(dev, state, src, true);
+			ssi_buffer_mgr_unmap_hash_request(dev, state, src,
+							  true);
 			ssi_hash_unmap_result(dev, state, digestsize, result);
 		}
 	} else {
 		rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 0);
 		if (rc != 0) {
 			SSI_LOG_ERR("send_request() failed (rc=%d)\n", rc);
-			ssi_buffer_mgr_unmap_hash_request(dev, state, src, true);
+			ssi_buffer_mgr_unmap_hash_request(dev, state, src,
+							  true);
 			ssi_hash_unmap_result(dev, state, digestsize, result);
 		} else {
-			ssi_buffer_mgr_unmap_hash_request(dev, state, src, false);
+			ssi_buffer_mgr_unmap_hash_request(dev, state, src,
+							  false);
 			ssi_hash_unmap_result(dev, state, digestsize, result);
 			ssi_hash_unmap_request(dev, state, ctx);
 		}
@@ -957,8 +1016,7 @@ static int ssi_hash_init(struct ahash_req_ctx *state, struct ssi_hash_ctx *ctx)
 
 static int ssi_hash_setkey(void *hash,
 			   const u8 *key,
-			   unsigned int keylen,
-			   bool synchronize)
+			   unsigned int keylen, bool synchronize)
 {
 	unsigned int hmac_pad_const[2] = { HMAC_IPAD_CONST, HMAC_OPAD_CONST };
 	struct ssi_crypto_req ssi_req = {};
@@ -969,14 +1027,15 @@ static int ssi_hash_setkey(void *hash,
 	struct cc_hw_desc desc[SSI_MAX_AHASH_SEQ_LEN];
 	ssi_sram_addr_t larval_addr;
 
-	 SSI_LOG_DEBUG("start keylen: %d", keylen);
+	SSI_LOG_DEBUG("start keylen: %d", keylen);
 
 	ctx = crypto_ahash_ctx(((struct crypto_ahash *)hash));
-	blocksize = crypto_tfm_alg_blocksize(&((struct crypto_ahash *)hash)->base);
+	blocksize =
+	    crypto_tfm_alg_blocksize(&((struct crypto_ahash *)hash)->base);
 	digestsize = crypto_ahash_digestsize(((struct crypto_ahash *)hash));
 
-	larval_addr = ssi_ahash_get_larval_digest_sram_addr(
-					ctx->drvdata, ctx->hash_mode);
+	larval_addr =
+	    ssi_ahash_get_larval_digest_sram_addr(ctx->drvdata, ctx->hash_mode);
 
 	/* The keylen value distinguishes HASH in case keylen is ZERO bytes,
 	 * any NON-ZERO value utilizes HMAC flow
@@ -986,19 +1045,21 @@ static int ssi_hash_setkey(void *hash,
 	ctx->is_hmac = true;
 
 	if (keylen != 0) {
-		ctx->key_params.key_dma_addr = dma_map_single(
-						&ctx->drvdata->plat_dev->dev,
-						(void *)key,
-						keylen, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(&ctx->drvdata->plat_dev->dev,
-					       ctx->key_params.key_dma_addr))) {
-			SSI_LOG_ERR("Mapping key va=0x%p len=%u for DMA failed\n",
-				    key, keylen);
+		ctx->key_params.key_dma_addr =
+		    dma_map_single(&ctx->drvdata->plat_dev->dev, (void *)key,
+				   keylen, DMA_TO_DEVICE);
+		if (unlikely
+		    (dma_mapping_error
+		     (&ctx->drvdata->plat_dev->dev,
+		      ctx->key_params.key_dma_addr))) {
+			SSI_LOG_ERR
+			    ("Mapping key va=0x%p len=%u for DMA failed\n", key,
+			     keylen);
 			return -ENOMEM;
 		}
-		SSI_LOG_DEBUG("mapping key-buffer: key_dma_addr=%pad keylen=%u\n",
-			      &ctx->key_params.key_dma_addr,
-			      ctx->key_params.keylen);
+		SSI_LOG_DEBUG
+		    ("mapping key-buffer: key_dma_addr=%pad keylen=%u\n",
+		     &ctx->key_params.key_dma_addr, ctx->key_params.keylen);
 
 		if (keylen > blocksize) {
 			/* Load hash initial state */
@@ -1134,15 +1195,16 @@ static int ssi_hash_setkey(void *hash,
 
 out:
 	if (rc)
-		crypto_ahash_set_flags((struct crypto_ahash *)hash, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		crypto_ahash_set_flags((struct crypto_ahash *)hash,
+				       CRYPTO_TFM_RES_BAD_KEY_LEN);
 
 	if (ctx->key_params.key_dma_addr) {
 		dma_unmap_single(&ctx->drvdata->plat_dev->dev,
 				 ctx->key_params.key_dma_addr,
 				 ctx->key_params.keylen, DMA_TO_DEVICE);
-		SSI_LOG_DEBUG("Unmapped key-buffer: key_dma_addr=%pad keylen=%u\n",
-			      &ctx->key_params.key_dma_addr,
-			      ctx->key_params.keylen);
+		SSI_LOG_DEBUG
+		    ("Unmapped key-buffer: key_dma_addr=%pad keylen=%u\n",
+		     &ctx->key_params.key_dma_addr, ctx->key_params.keylen);
 	}
 	return rc;
 }
@@ -1168,19 +1230,18 @@ static int ssi_xcbc_setkey(struct crypto_ahash *ahash,
 
 	ctx->key_params.keylen = keylen;
 
-	ctx->key_params.key_dma_addr = dma_map_single(
-					&ctx->drvdata->plat_dev->dev,
-					(void *)key,
-					keylen, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(&ctx->drvdata->plat_dev->dev,
-				       ctx->key_params.key_dma_addr))) {
-		SSI_LOG_ERR("Mapping key va=0x%p len=%u for DMA failed\n",
-			    key, keylen);
+	ctx->key_params.key_dma_addr =
+	    dma_map_single(&ctx->drvdata->plat_dev->dev, (void *)key, keylen,
+			   DMA_TO_DEVICE);
+	if (unlikely
+	    (dma_mapping_error
+	     (&ctx->drvdata->plat_dev->dev, ctx->key_params.key_dma_addr))) {
+		SSI_LOG_ERR("Mapping key va=0x%p len=%u for DMA failed\n", key,
+			    keylen);
 		return -ENOMEM;
 	}
 	SSI_LOG_DEBUG("mapping key-buffer: key_dma_addr=%pad keylen=%u\n",
-		      &ctx->key_params.key_dma_addr,
-		      ctx->key_params.keylen);
+		      &ctx->key_params.key_dma_addr, ctx->key_params.keylen);
 
 	ctx->is_hmac = true;
 	/* 1. Load the AES key */
@@ -1198,24 +1259,24 @@ static int ssi_xcbc_setkey(struct crypto_ahash *ahash,
 	set_din_const(&desc[idx], 0x01010101, CC_AES_128_BIT_KEY_SIZE);
 	set_flow_mode(&desc[idx], DIN_AES_DOUT);
 	set_dout_dlli(&desc[idx], (ctx->opad_tmp_keys_dma_addr +
-					   XCBC_MAC_K1_OFFSET),
-			      CC_AES_128_BIT_KEY_SIZE, NS_BIT, 0);
+				   XCBC_MAC_K1_OFFSET),
+		      CC_AES_128_BIT_KEY_SIZE, NS_BIT, 0);
 	idx++;
 
 	hw_desc_init(&desc[idx]);
 	set_din_const(&desc[idx], 0x02020202, CC_AES_128_BIT_KEY_SIZE);
 	set_flow_mode(&desc[idx], DIN_AES_DOUT);
 	set_dout_dlli(&desc[idx], (ctx->opad_tmp_keys_dma_addr +
-					   XCBC_MAC_K2_OFFSET),
-			      CC_AES_128_BIT_KEY_SIZE, NS_BIT, 0);
+				   XCBC_MAC_K2_OFFSET),
+		      CC_AES_128_BIT_KEY_SIZE, NS_BIT, 0);
 	idx++;
 
 	hw_desc_init(&desc[idx]);
 	set_din_const(&desc[idx], 0x03030303, CC_AES_128_BIT_KEY_SIZE);
 	set_flow_mode(&desc[idx], DIN_AES_DOUT);
 	set_dout_dlli(&desc[idx], (ctx->opad_tmp_keys_dma_addr +
-					   XCBC_MAC_K3_OFFSET),
-			       CC_AES_128_BIT_KEY_SIZE, NS_BIT, 0);
+				   XCBC_MAC_K3_OFFSET),
+		      CC_AES_128_BIT_KEY_SIZE, NS_BIT, 0);
 	idx++;
 
 	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 0);
@@ -1227,8 +1288,7 @@ static int ssi_xcbc_setkey(struct crypto_ahash *ahash,
 			 ctx->key_params.key_dma_addr,
 			 ctx->key_params.keylen, DMA_TO_DEVICE);
 	SSI_LOG_DEBUG("Unmapped key-buffer: key_dma_addr=%pad keylen=%u\n",
-		      &ctx->key_params.key_dma_addr,
-		      ctx->key_params.keylen);
+		      &ctx->key_params.key_dma_addr, ctx->key_params.keylen);
 
 	return rc;
 }
@@ -1262,7 +1322,8 @@ static int ssi_cmac_setkey(struct crypto_ahash *ahash,
 
 	memcpy(ctx->opad_tmp_keys_buff, key, keylen);
 	if (keylen == 24)
-		memset(ctx->opad_tmp_keys_buff + 24, 0, CC_AES_KEY_SIZE_MAX - 24);
+		memset(ctx->opad_tmp_keys_buff + 24, 0,
+		       CC_AES_KEY_SIZE_MAX - 24);
 
 	dma_sync_single_for_device(&ctx->drvdata->plat_dev->dev,
 				   ctx->opad_tmp_keys_dma_addr,
@@ -1281,16 +1342,18 @@ static void ssi_hash_free_ctx(struct ssi_hash_ctx *ctx)
 	if (ctx->digest_buff_dma_addr != 0) {
 		dma_unmap_single(dev, ctx->digest_buff_dma_addr,
 				 sizeof(ctx->digest_buff), DMA_BIDIRECTIONAL);
-		SSI_LOG_DEBUG("Unmapped digest-buffer: digest_buff_dma_addr=%pad\n",
-			      &ctx->digest_buff_dma_addr);
+		SSI_LOG_DEBUG
+		    ("Unmapped digest-buffer: digest_buff_dma_addr=%pad\n",
+		     &ctx->digest_buff_dma_addr);
 		ctx->digest_buff_dma_addr = 0;
 	}
 	if (ctx->opad_tmp_keys_dma_addr != 0) {
 		dma_unmap_single(dev, ctx->opad_tmp_keys_dma_addr,
 				 sizeof(ctx->opad_tmp_keys_buff),
 				 DMA_BIDIRECTIONAL);
-		SSI_LOG_DEBUG("Unmapped opad-digest: opad_tmp_keys_dma_addr=%pad\n",
-			      &ctx->opad_tmp_keys_dma_addr);
+		SSI_LOG_DEBUG
+		    ("Unmapped opad-digest: opad_tmp_keys_dma_addr=%pad\n",
+		     &ctx->opad_tmp_keys_dma_addr);
 		ctx->opad_tmp_keys_dma_addr = 0;
 	}
 
@@ -1303,21 +1366,26 @@ static int ssi_hash_alloc_ctx(struct ssi_hash_ctx *ctx)
 
 	ctx->key_params.keylen = 0;
 
-	ctx->digest_buff_dma_addr = dma_map_single(dev, (void *)ctx->digest_buff, sizeof(ctx->digest_buff), DMA_BIDIRECTIONAL);
+	ctx->digest_buff_dma_addr =
+	    dma_map_single(dev, (void *)ctx->digest_buff,
+			   sizeof(ctx->digest_buff), DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(dev, ctx->digest_buff_dma_addr)) {
-		SSI_LOG_ERR("Mapping digest len %zu B at va=%pK for DMA failed\n",
-			    sizeof(ctx->digest_buff), ctx->digest_buff);
+		SSI_LOG_ERR
+		    ("Mapping digest len %zu B at va=%pK for DMA failed\n",
+		     sizeof(ctx->digest_buff), ctx->digest_buff);
 		goto fail;
 	}
 	SSI_LOG_DEBUG("Mapped digest %zu B at va=%pK to dma=%pad\n",
 		      sizeof(ctx->digest_buff), ctx->digest_buff,
 		      &ctx->digest_buff_dma_addr);
 
-	ctx->opad_tmp_keys_dma_addr = dma_map_single(dev, (void *)ctx->opad_tmp_keys_buff, sizeof(ctx->opad_tmp_keys_buff), DMA_BIDIRECTIONAL);
+	ctx->opad_tmp_keys_dma_addr =
+	    dma_map_single(dev, (void *)ctx->opad_tmp_keys_buff,
+			   sizeof(ctx->opad_tmp_keys_buff), DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(dev, ctx->opad_tmp_keys_dma_addr)) {
-		SSI_LOG_ERR("Mapping opad digest %zu B at va=%pK for DMA failed\n",
-			    sizeof(ctx->opad_tmp_keys_buff),
-			    ctx->opad_tmp_keys_buff);
+		SSI_LOG_ERR
+		    ("Mapping opad digest %zu B at va=%pK for DMA failed\n",
+		     sizeof(ctx->opad_tmp_keys_buff), ctx->opad_tmp_keys_buff);
 		goto fail;
 	}
 	SSI_LOG_DEBUG("Mapped opad_tmp_keys %zu B at va=%pK to dma=%pad\n",
@@ -1336,11 +1404,11 @@ static int ssi_ahash_cra_init(struct crypto_tfm *tfm)
 {
 	struct ssi_hash_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct hash_alg_common *hash_alg_common =
-		container_of(tfm->__crt_alg, struct hash_alg_common, base);
+	    container_of(tfm->__crt_alg, struct hash_alg_common, base);
 	struct ahash_alg *ahash_alg =
-		container_of(hash_alg_common, struct ahash_alg, halg);
+	    container_of(hash_alg_common, struct ahash_alg, halg);
 	struct ssi_hash_alg *ssi_alg =
-			container_of(ahash_alg, struct ssi_hash_alg, ahash_alg);
+	    container_of(ahash_alg, struct ssi_hash_alg, ahash_alg);
 
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
 				 sizeof(struct ahash_req_ctx));
@@ -1380,7 +1448,9 @@ static int ssi_mac_update(struct ahash_request *req)
 
 	state->xcbc_count++;
 
-	rc = ssi_buffer_mgr_map_hash_request_update(ctx->drvdata, state, req->src, req->nbytes, block_size);
+	rc = ssi_buffer_mgr_map_hash_request_update(ctx->drvdata, state,
+						    req->src, req->nbytes,
+						    block_size);
 	if (unlikely(rc)) {
 		if (rc == 1) {
 			SSI_LOG_DEBUG(" data size not require HW update %x\n",
@@ -1434,21 +1504,22 @@ static int ssi_mac_final(struct ahash_request *req)
 	u32 key_size, key_len;
 	u32 digestsize = crypto_ahash_digestsize(tfm);
 
-	u32 rem_cnt = state->buff_index ? state->buff1_cnt :
-			state->buff0_cnt;
+	u32 rem_cnt = state->buff_index ? state->buff1_cnt : state->buff0_cnt;
 
 	if (ctx->hw_mode == DRV_CIPHER_XCBC_MAC) {
 		key_size = CC_AES_128_BIT_KEY_SIZE;
-		key_len  = CC_AES_128_BIT_KEY_SIZE;
+		key_len = CC_AES_128_BIT_KEY_SIZE;
 	} else {
 		key_size = (ctx->key_params.keylen == 24) ? AES_MAX_KEY_SIZE :
-			ctx->key_params.keylen;
-		key_len =  ctx->key_params.keylen;
+		    ctx->key_params.keylen;
+		key_len = ctx->key_params.keylen;
 	}
 
 	SSI_LOG_DEBUG("===== final  xcbc reminder (%d) ====\n", rem_cnt);
 
-	if (unlikely(ssi_buffer_mgr_map_hash_request_final(ctx->drvdata, state, req->src, req->nbytes, 0) != 0)) {
+	if (unlikely
+	    (ssi_buffer_mgr_map_hash_request_final
+	     (ctx->drvdata, state, req->src, req->nbytes, 0) != 0)) {
 		SSI_LOG_ERR("map_ahash_request_final() failed\n");
 		return -ENOMEM;
 	}
@@ -1504,7 +1575,8 @@ static int ssi_mac_final(struct ahash_request *req)
 		set_flow_mode(&desc[idx], S_DIN_to_AES);
 		idx++;
 	} else if (rem_cnt > 0) {
-		ssi_hash_create_data_desc(state, ctx, DIN_AES_DOUT, desc, false, &idx);
+		ssi_hash_create_data_desc(state, ctx, DIN_AES_DOUT, desc, false,
+					  &idx);
 	} else {
 		hw_desc_init(&desc[idx]);
 		set_din_const(&desc[idx], 0x00, CC_AES_BLOCK_SIZE);
@@ -1551,7 +1623,9 @@ static int ssi_mac_finup(struct ahash_request *req)
 		return ssi_mac_final(req);
 	}
 
-	if (unlikely(ssi_buffer_mgr_map_hash_request_final(ctx->drvdata, state, req->src, req->nbytes, 1) != 0)) {
+	if (unlikely
+	    (ssi_buffer_mgr_map_hash_request_final
+	     (ctx->drvdata, state, req->src, req->nbytes, 1) != 0)) {
 		SSI_LOG_ERR("map_ahash_request_final() failed\n");
 		return -ENOMEM;
 	}
@@ -1580,7 +1654,8 @@ static int ssi_mac_finup(struct ahash_request *req)
 		set_flow_mode(&desc[idx], S_DIN_to_AES);
 		idx++;
 	} else {
-		ssi_hash_create_data_desc(state, ctx, DIN_AES_DOUT, desc, false, &idx);
+		ssi_hash_create_data_desc(state, ctx, DIN_AES_DOUT, desc, false,
+					  &idx);
 	}
 
 	/* Get final MAC result */
@@ -1616,7 +1691,7 @@ static int ssi_mac_digest(struct ahash_request *req)
 	int idx = 0;
 	int rc;
 
-	SSI_LOG_DEBUG("===== -digest mac (%d) ====\n",  req->nbytes);
+	SSI_LOG_DEBUG("===== -digest mac (%d) ====\n", req->nbytes);
 
 	if (unlikely(ssi_hash_map_request(dev, state, ctx) != 0)) {
 		SSI_LOG_ERR("map_ahash_source() failed\n");
@@ -1627,7 +1702,9 @@ static int ssi_mac_digest(struct ahash_request *req)
 		return -ENOMEM;
 	}
 
-	if (unlikely(ssi_buffer_mgr_map_hash_request_final(ctx->drvdata, state, req->src, req->nbytes, 1) != 0)) {
+	if (unlikely
+	    (ssi_buffer_mgr_map_hash_request_final
+	     (ctx->drvdata, state, req->src, req->nbytes, 1) != 0)) {
 		SSI_LOG_ERR("map_ahash_request_final() failed\n");
 		return -ENOMEM;
 	}
@@ -1652,7 +1729,8 @@ static int ssi_mac_digest(struct ahash_request *req)
 		set_flow_mode(&desc[idx], S_DIN_to_AES);
 		idx++;
 	} else {
-		ssi_hash_create_data_desc(state, ctx, DIN_AES_DOUT, desc, false, &idx);
+		ssi_hash_create_data_desc(state, ctx, DIN_AES_DOUT, desc, false,
+					  &idx);
 	}
 
 	/* Get final MAC result */
@@ -1684,7 +1762,8 @@ static int ssi_ahash_digest(struct ahash_request *req)
 	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	u32 digestsize = crypto_ahash_digestsize(tfm);
 
-	return ssi_hash_digest(state, ctx, digestsize, req->src, req->nbytes, req->result, (void *)req);
+	return ssi_hash_digest(state, ctx, digestsize, req->src, req->nbytes,
+			       req->result, (void *)req);
 }
 
 static int ssi_ahash_update(struct ahash_request *req)
@@ -1694,7 +1773,8 @@ static int ssi_ahash_update(struct ahash_request *req)
 	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	unsigned int block_size = crypto_tfm_alg_blocksize(&tfm->base);
 
-	return ssi_hash_update(state, ctx, block_size, req->src, req->nbytes, (void *)req);
+	return ssi_hash_update(state, ctx, block_size, req->src, req->nbytes,
+			       (void *)req);
 }
 
 static int ssi_ahash_finup(struct ahash_request *req)
@@ -1704,7 +1784,8 @@ static int ssi_ahash_finup(struct ahash_request *req)
 	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	u32 digestsize = crypto_ahash_digestsize(tfm);
 
-	return ssi_hash_finup(state, ctx, digestsize, req->src, req->nbytes, req->result, (void *)req);
+	return ssi_hash_finup(state, ctx, digestsize, req->src, req->nbytes,
+			      req->result, (void *)req);
 }
 
 static int ssi_ahash_final(struct ahash_request *req)
@@ -1714,7 +1795,8 @@ static int ssi_ahash_final(struct ahash_request *req)
 	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	u32 digestsize = crypto_ahash_digestsize(tfm);
 
-	return ssi_hash_final(state, ctx, digestsize, req->src, req->nbytes, req->result, (void *)req);
+	return ssi_hash_final(state, ctx, digestsize, req->src, req->nbytes,
+			      req->result, (void *)req);
 }
 
 static int ssi_ahash_init(struct ahash_request *req)
@@ -1736,7 +1818,7 @@ static int ssi_ahash_export(struct ahash_request *req, void *out)
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
 	u8 *curr_buff = state->buff_index ? state->buff1 : state->buff0;
 	u32 curr_buff_cnt = state->buff_index ? state->buff1_cnt :
-				state->buff0_cnt;
+	    state->buff0_cnt;
 	const u32 tmp = CC_EXPORT_MAGIC;
 
 	memcpy(out, &tmp, sizeof(u32));
@@ -1848,7 +1930,6 @@ struct ssi_hash_template {
 
 #define CC_STATE_SIZE(_x) \
 	((_x) + HASH_LEN_SIZE + SSI_MAX_HASH_BLCK_SIZE + (2 * sizeof(u32)))
-
 /* hash descriptors */
 static struct ssi_hash_template driver_hash[] = {
 	//Asynchronize hash template
@@ -2048,8 +2129,8 @@ static struct ssi_hash_template driver_hash[] = {
 
 };
 
-static struct ssi_hash_alg *
-ssi_hash_create_alg(struct ssi_hash_template *template, bool keyed)
+static struct ssi_hash_alg *ssi_hash_create_alg(struct ssi_hash_template
+						*template, bool keyed)
 {
 	struct ssi_hash_alg *t_crypto_alg;
 	struct crypto_alg *alg;
@@ -2086,7 +2167,7 @@ ssi_hash_create_alg(struct ssi_hash_template *template, bool keyed)
 
 	alg->cra_init = ssi_ahash_cra_init;
 	alg->cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_TYPE_AHASH |
-			CRYPTO_ALG_KERN_DRIVER_ONLY;
+	    CRYPTO_ALG_KERN_DRIVER_ONLY;
 	alg->cra_type = &crypto_ahash_type;
 
 	t_crypto_alg->hash_mode = template->hash_mode;
@@ -2234,14 +2315,11 @@ int ssi_hash_alloc(struct ssi_drvdata *drvdata)
 
 	sram_size_to_alloc = sizeof(digest_len_init) +
 #if (DX_DEV_SHA_MAX > 256)
-			sizeof(digest_len_sha512_init) +
-			sizeof(sha384_init) +
-			sizeof(sha512_init) +
+	    sizeof(digest_len_sha512_init) +
+	    sizeof(sha384_init) + sizeof(sha512_init) +
 #endif
-			sizeof(md5_init) +
-			sizeof(sha1_init) +
-			sizeof(sha224_init) +
-			sizeof(sha256_init);
+	    sizeof(md5_init) +
+	    sizeof(sha1_init) + sizeof(sha224_init) + sizeof(sha256_init);
 
 	sram_buff = ssi_sram_mgr_alloc(drvdata, sram_size_to_alloc);
 	if (sram_buff == NULL_SRAM_ADDR) {
@@ -2282,8 +2360,7 @@ int ssi_hash_alloc(struct ssi_drvdata *drvdata)
 			kfree(t_alg);
 			goto fail;
 		} else {
-			list_add_tail(&t_alg->entry,
-				      &hash_handle->hash_list);
+			list_add_tail(&t_alg->entry, &hash_handle->hash_list);
 		}
 
 		if ((hw_mode == DRV_CIPHER_XCBC_MAC) ||
@@ -2325,7 +2402,8 @@ int ssi_hash_free(struct ssi_drvdata *drvdata)
 	struct ssi_hash_handle *hash_handle = drvdata->hash_handle;
 
 	if (hash_handle) {
-		list_for_each_entry_safe(t_hash_alg, hash_n, &hash_handle->hash_list, entry) {
+		list_for_each_entry_safe(t_hash_alg, hash_n,
+					 &hash_handle->hash_list, entry) {
 			crypto_unregister_ahash(&t_hash_alg->ahash_alg);
 			list_del(&t_hash_alg->entry);
 			kfree(t_hash_alg);
@@ -2490,7 +2568,7 @@ ssi_sram_addr_t ssi_ahash_get_larval_digest_sram_addr(void *drvdata, u32 mode)
 
 	switch (mode) {
 	case DRV_HASH_NULL:
-		break; /*Ignore*/
+		break; /*Ignore */
 	case DRV_HASH_MD5:
 		return (hash_handle->larval_digest_sram_addr);
 	case DRV_HASH_SHA1:
@@ -2498,27 +2576,23 @@ ssi_sram_addr_t ssi_ahash_get_larval_digest_sram_addr(void *drvdata, u32 mode)
 			sizeof(md5_init));
 	case DRV_HASH_SHA224:
 		return (hash_handle->larval_digest_sram_addr +
-			sizeof(md5_init) +
-			sizeof(sha1_init));
+			sizeof(md5_init) + sizeof(sha1_init));
 	case DRV_HASH_SHA256:
 		return (hash_handle->larval_digest_sram_addr +
 			sizeof(md5_init) +
-			sizeof(sha1_init) +
-			sizeof(sha224_init));
+			sizeof(sha1_init) + sizeof(sha224_init));
 #if (DX_DEV_SHA_MAX > 256)
 	case DRV_HASH_SHA384:
 		return (hash_handle->larval_digest_sram_addr +
 			sizeof(md5_init) +
 			sizeof(sha1_init) +
-			sizeof(sha224_init) +
-			sizeof(sha256_init));
+			sizeof(sha224_init) + sizeof(sha256_init));
 	case DRV_HASH_SHA512:
 		return (hash_handle->larval_digest_sram_addr +
 			sizeof(md5_init) +
 			sizeof(sha1_init) +
 			sizeof(sha224_init) +
-			sizeof(sha256_init) +
-			sizeof(sha384_init));
+			sizeof(sha256_init) + sizeof(sha384_init));
 #endif
 	default:
 		SSI_LOG_ERR("Invalid hash mode (%d)\n", mode);
-- 
2.1.4
