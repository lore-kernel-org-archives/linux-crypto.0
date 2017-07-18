From: =?UTF-8?q?Simon=20Sandstr=C3=B6m?= <simon@nikanor.nu>
Subject: [PATCH 2/6] staging: ccree: Fix alignment issues in ssi_hash.c
Date: Tue, 18 Jul 2017 22:03:53 +0200
Message-ID: <20170718200357.32646-3-simon@nikanor.nu>
References: <20170718200357.32646-1-simon@nikanor.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: gregkh@linuxfoundation.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        =?UTF-8?q?Simon=20Sandstr=C3=B6m?= <simon@nikanor.nu>
To: gilad@benyossef.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:34559 "EHLO
        mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751839AbdGRUFU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 16:05:20 -0400
Received: by mail-lf0-f54.google.com with SMTP id t72so22157467lff.1
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jul 2017 13:05:19 -0700 (PDT)
In-Reply-To: <20170718200357.32646-1-simon@nikanor.nu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixes checkpatch.pl alignment warnings.

Signed-off-by: Simon Sandström <simon@nikanor.nu>
---
 drivers/staging/ccree/ssi_hash.c | 105 +++++++++++++++++++++------------------
 1 file changed, 56 insertions(+), 49 deletions(-)

diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index fba0643e78fa..a5b3e9bebd95 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -70,8 +70,8 @@ static void ssi_hash_create_xcbc_setup(
 	unsigned int *seq_size);
 
 static void ssi_hash_create_cmac_setup(struct ahash_request *areq,
-				  struct cc_hw_desc desc[],
-				  unsigned int *seq_size);
+				       struct cc_hw_desc desc[],
+				       unsigned int *seq_size);
 
 struct ssi_hash_alg {
 	struct list_head entry;
@@ -117,8 +117,8 @@ static void ssi_hash_create_data_desc(
 static inline void ssi_set_hash_endianity(u32 mode, struct cc_hw_desc *desc)
 {
 	if (unlikely((mode == DRV_HASH_MD5) ||
-		(mode == DRV_HASH_SHA384) ||
-		(mode == DRV_HASH_SHA512))) {
+		     (mode == DRV_HASH_SHA384) ||
+		     (mode == DRV_HASH_SHA512))) {
 		set_bytes_swap(desc, 1);
 	} else {
 		set_cipher_config0(desc, HASH_DIGEST_RESULT_LITTLE_ENDIAN);
@@ -135,7 +135,7 @@ static int ssi_hash_map_result(struct device *dev,
 			       DMA_BIDIRECTIONAL);
 	if (unlikely(dma_mapping_error(dev, state->digest_result_dma_addr))) {
 		SSI_LOG_ERR("Mapping digest result buffer %u B for DMA failed\n",
-			digestsize);
+			    digestsize);
 		return -ENOMEM;
 	}
 	SSI_LOG_DEBUG("Mapped digest result buffer %u B "
@@ -200,12 +200,12 @@ static int ssi_hash_map_request(struct device *dev,
 	state->digest_buff_dma_addr = dma_map_single(dev, (void *)state->digest_buff, ctx->inter_digestsize, DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(dev, state->digest_buff_dma_addr)) {
 		SSI_LOG_ERR("Mapping digest len %d B at va=%pK for DMA failed\n",
-		ctx->inter_digestsize, state->digest_buff);
+			    ctx->inter_digestsize, state->digest_buff);
 		goto fail3;
 	}
 	SSI_LOG_DEBUG("Mapped digest %d B at va=%pK to dma=%pad\n",
-		ctx->inter_digestsize, state->digest_buff,
-		state->digest_buff_dma_addr);
+		      ctx->inter_digestsize, state->digest_buff,
+		      state->digest_buff_dma_addr);
 
 	if (is_hmac) {
 		dma_sync_single_for_cpu(dev, ctx->digest_buff_dma_addr, ctx->inter_digestsize, DMA_BIDIRECTIONAL);
@@ -249,12 +249,12 @@ static int ssi_hash_map_request(struct device *dev,
 		state->digest_bytes_len_dma_addr = dma_map_single(dev, (void *)state->digest_bytes_len, HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
 		if (dma_mapping_error(dev, state->digest_bytes_len_dma_addr)) {
 			SSI_LOG_ERR("Mapping digest len %u B at va=%pK for DMA failed\n",
-			HASH_LEN_SIZE, state->digest_bytes_len);
+				    HASH_LEN_SIZE, state->digest_bytes_len);
 			goto fail4;
 		}
 		SSI_LOG_DEBUG("Mapped digest len %u B at va=%pK to dma=%pad\n",
-			HASH_LEN_SIZE, state->digest_bytes_len,
-			state->digest_bytes_len_dma_addr);
+			      HASH_LEN_SIZE, state->digest_bytes_len,
+			      state->digest_bytes_len_dma_addr);
 	} else {
 		state->digest_bytes_len_dma_addr = 0;
 	}
@@ -263,12 +263,13 @@ static int ssi_hash_map_request(struct device *dev,
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
-			state->opad_digest_dma_addr);
+			      ctx->inter_digestsize, state->opad_digest_buff,
+			      state->opad_digest_dma_addr);
 	} else {
 		state->opad_digest_dma_addr = 0;
 	}
@@ -602,7 +603,7 @@ static int ssi_hash_update(struct ahash_req_ctx *state,
 	if (unlikely(rc)) {
 		if (rc == 1) {
 			SSI_LOG_DEBUG(" data size not require HW update %x\n",
-				     nbytes);
+				      nbytes);
 			/* No hardware updates are required */
 			return 0;
 		}
@@ -1145,17 +1146,17 @@ static int ssi_hash_setkey(void *hash,
 
 	if (ctx->key_params.key_dma_addr) {
 		dma_unmap_single(&ctx->drvdata->plat_dev->dev,
-				ctx->key_params.key_dma_addr,
-				ctx->key_params.keylen, DMA_TO_DEVICE);
+				 ctx->key_params.key_dma_addr,
+				 ctx->key_params.keylen, DMA_TO_DEVICE);
 		SSI_LOG_DEBUG("Unmapped key-buffer: key_dma_addr=%pad keylen=%u\n",
-				ctx->key_params.key_dma_addr,
-				ctx->key_params.keylen);
+			      ctx->key_params.key_dma_addr,
+			      ctx->key_params.keylen);
 	}
 	return rc;
 }
 
 static int ssi_xcbc_setkey(struct crypto_ahash *ahash,
-			const u8 *key, unsigned int keylen)
+			   const u8 *key, unsigned int keylen)
 {
 	struct ssi_crypto_req ssi_req = {};
 	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(ahash);
@@ -1232,18 +1233,18 @@ static int ssi_xcbc_setkey(struct crypto_ahash *ahash,
 		crypto_ahash_set_flags(ahash, CRYPTO_TFM_RES_BAD_KEY_LEN);
 
 	dma_unmap_single(&ctx->drvdata->plat_dev->dev,
-			ctx->key_params.key_dma_addr,
-			ctx->key_params.keylen, DMA_TO_DEVICE);
+			 ctx->key_params.key_dma_addr,
+			 ctx->key_params.keylen, DMA_TO_DEVICE);
 	SSI_LOG_DEBUG("Unmapped key-buffer: key_dma_addr=%pad keylen=%u\n",
-			ctx->key_params.key_dma_addr,
-			ctx->key_params.keylen);
+		      ctx->key_params.key_dma_addr,
+		      ctx->key_params.keylen);
 
 	return rc;
 }
 
 #if SSI_CC_HAS_CMAC
 static int ssi_cmac_setkey(struct crypto_ahash *ahash,
-			const u8 *key, unsigned int keylen)
+			   const u8 *key, unsigned int keylen)
 {
 	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 
@@ -1316,22 +1317,22 @@ static int ssi_hash_alloc_ctx(struct ssi_hash_ctx *ctx)
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
-			ctx->opad_tmp_keys_buff);
+			    sizeof(ctx->opad_tmp_keys_buff),
+			    ctx->opad_tmp_keys_buff);
 		goto fail;
 	}
 	SSI_LOG_DEBUG("Mapped opad_tmp_keys %zu B at va=%pK to dma=%pad\n",
-		sizeof(ctx->opad_tmp_keys_buff), ctx->opad_tmp_keys_buff,
+		      sizeof(ctx->opad_tmp_keys_buff), ctx->opad_tmp_keys_buff,
 		      ctx->opad_tmp_keys_dma_addr);
 
 	ctx->is_hmac = false;
@@ -1353,7 +1354,7 @@ static int ssi_ahash_cra_init(struct crypto_tfm *tfm)
 			container_of(ahash_alg, struct ssi_hash_alg, ahash_alg);
 
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
-				sizeof(struct ahash_req_ctx));
+				 sizeof(struct ahash_req_ctx));
 
 	ctx->hash_mode = ssi_alg->hash_mode;
 	ctx->hw_mode = ssi_alg->hw_mode;
@@ -1394,7 +1395,7 @@ static int ssi_mac_update(struct ahash_request *req)
 	if (unlikely(rc)) {
 		if (rc == 1) {
 			SSI_LOG_DEBUG(" data size not require HW update %x\n",
-				     req->nbytes);
+				      req->nbytes);
 			/* No hardware updates are required */
 			return 0;
 		}
@@ -1837,7 +1838,7 @@ static int ssi_ahash_import(struct ahash_request *req, const void *in)
 }
 
 static int ssi_ahash_setkey(struct crypto_ahash *ahash,
-			const u8 *key, unsigned int keylen)
+			    const u8 *key, unsigned int keylen)
 {
 	return ssi_hash_setkey((void *)ahash, key, keylen, false);
 }
@@ -2119,7 +2120,8 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 
 	/* Copy-to-sram digest-len */
 	ssi_sram_mgr_const2sram_desc(digest_len_init, sram_buff_ofs,
-		ARRAY_SIZE(digest_len_init), larval_seq, &larval_seq_len);
+				     ARRAY_SIZE(digest_len_init),
+				     larval_seq, &larval_seq_len);
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
 	if (unlikely(rc != 0))
 		goto init_digest_const_err;
@@ -2130,7 +2132,8 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 #if (DX_DEV_SHA_MAX > 256)
 	/* Copy-to-sram digest-len for sha384/512 */
 	ssi_sram_mgr_const2sram_desc(digest_len_sha512_init, sram_buff_ofs,
-		ARRAY_SIZE(digest_len_sha512_init), larval_seq, &larval_seq_len);
+				     ARRAY_SIZE(digest_len_sha512_init),
+				     larval_seq, &larval_seq_len);
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
 	if (unlikely(rc != 0))
 		goto init_digest_const_err;
@@ -2144,7 +2147,8 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 
 	/* Copy-to-sram initial SHA* digests */
 	ssi_sram_mgr_const2sram_desc(md5_init, sram_buff_ofs,
-		ARRAY_SIZE(md5_init), larval_seq, &larval_seq_len);
+				     ARRAY_SIZE(md5_init), larval_seq,
+				     &larval_seq_len);
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
 	if (unlikely(rc != 0))
 		goto init_digest_const_err;
@@ -2152,7 +2156,8 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 	larval_seq_len = 0;
 
 	ssi_sram_mgr_const2sram_desc(sha1_init, sram_buff_ofs,
-		ARRAY_SIZE(sha1_init), larval_seq, &larval_seq_len);
+				     ARRAY_SIZE(sha1_init), larval_seq,
+				     &larval_seq_len);
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
 	if (unlikely(rc != 0))
 		goto init_digest_const_err;
@@ -2160,7 +2165,8 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 	larval_seq_len = 0;
 
 	ssi_sram_mgr_const2sram_desc(sha224_init, sram_buff_ofs,
-		ARRAY_SIZE(sha224_init), larval_seq, &larval_seq_len);
+				     ARRAY_SIZE(sha224_init), larval_seq,
+				     &larval_seq_len);
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
 	if (unlikely(rc != 0))
 		goto init_digest_const_err;
@@ -2168,7 +2174,8 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 	larval_seq_len = 0;
 
 	ssi_sram_mgr_const2sram_desc(sha256_init, sram_buff_ofs,
-		ARRAY_SIZE(sha256_init), larval_seq, &larval_seq_len);
+				     ARRAY_SIZE(sha256_init), larval_seq,
+				     &larval_seq_len);
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
 	if (unlikely(rc != 0))
 		goto init_digest_const_err;
@@ -2182,10 +2189,10 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
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
@@ -2200,10 +2207,10 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
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
@@ -2228,7 +2235,7 @@ int ssi_hash_alloc(struct ssi_drvdata *drvdata)
 	hash_handle = kzalloc(sizeof(struct ssi_hash_handle), GFP_KERNEL);
 	if (!hash_handle) {
 		SSI_LOG_ERR("kzalloc failed to allocate %zu B\n",
-			sizeof(struct ssi_hash_handle));
+			    sizeof(struct ssi_hash_handle));
 		rc = -ENOMEM;
 		goto fail;
 	}
@@ -2300,7 +2307,7 @@ int ssi_hash_alloc(struct ssi_drvdata *drvdata)
 		if (IS_ERR(t_alg)) {
 			rc = PTR_ERR(t_alg);
 			SSI_LOG_ERR("%s alg allocation failed\n",
-				 driver_hash[alg].driver_name);
+				    driver_hash[alg].driver_name);
 			goto fail;
 		}
 		t_alg->drvdata = drvdata;
@@ -2346,8 +2353,8 @@ int ssi_hash_free(struct ssi_drvdata *drvdata)
 }
 
 static void ssi_hash_create_xcbc_setup(struct ahash_request *areq,
-				  struct cc_hw_desc desc[],
-				  unsigned int *seq_size)
+				       struct cc_hw_desc desc[],
+				       unsigned int *seq_size)
 {
 	unsigned int idx = *seq_size;
 	struct ahash_req_ctx *state = ahash_request_ctx(areq);
@@ -2404,8 +2411,8 @@ static void ssi_hash_create_xcbc_setup(struct ahash_request *areq,
 }
 
 static void ssi_hash_create_cmac_setup(struct ahash_request *areq,
-				  struct cc_hw_desc desc[],
-				  unsigned int *seq_size)
+				       struct cc_hw_desc desc[],
+				       unsigned int *seq_size)
 {
 	unsigned int idx = *seq_size;
 	struct ahash_req_ctx *state = ahash_request_ctx(areq);
-- 
2.11.0
