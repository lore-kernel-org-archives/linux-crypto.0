From: =?UTF-8?q?Simon=20Sandstr=C3=B6m?= <simon@nikanor.nu>
Subject: [PATCH 1/6] staging: ccree: Fix alignment issues in ssi_aead.c
Date: Tue, 18 Jul 2017 22:03:52 +0200
Message-ID: <20170718200357.32646-2-simon@nikanor.nu>
References: <20170718200357.32646-1-simon@nikanor.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: gregkh@linuxfoundation.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        =?UTF-8?q?Simon=20Sandstr=C3=B6m?= <simon@nikanor.nu>
To: gilad@benyossef.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:36555 "EHLO
        mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751815AbdGRUFS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 16:05:18 -0400
Received: by mail-lf0-f52.google.com with SMTP id d78so17766263lfg.3
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jul 2017 13:05:17 -0700 (PDT)
In-Reply-To: <20170718200357.32646-1-simon@nikanor.nu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixes checkpatch.pl alignment warnings.

Signed-off-by: Simon Sandström <simon@nikanor.nu>
---
 drivers/staging/ccree/ssi_aead.c | 47 +++++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index ea29b8a1a71d..ad53126d6705 100644
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
+		      ctx, crypto_tfm_alg_name(crypto_aead_tfm(tfm)),
+		      key, keylen);
 
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
@@ -1183,8 +1184,8 @@ static inline void ssi_aead_load_mlli_to_sram(
 		(req_ctx->data_buff_type == SSI_DMA_BUF_MLLI) ||
 		!req_ctx->is_single_pass)) {
 		SSI_LOG_DEBUG("Copy-to-sram: mlli_dma=%08x, mlli_size=%u\n",
-			(unsigned int)ctx->drvdata->mlli_sram_addr,
-			req_ctx->mlli_params.mlli_len);
+			      (unsigned int)ctx->drvdata->mlli_sram_addr,
+			      req_ctx->mlli_params.mlli_len);
 		/* Copy MLLI table host-to-sram */
 		hw_desc_init(&desc[*seq_size]);
 		set_din_type(&desc[*seq_size], DMA_DLLI,
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
@@ -1960,15 +1962,16 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 	struct ssi_crypto_req ssi_req = {};
 
 	SSI_LOG_DEBUG("%s context=%p req=%p iv=%p src=%p src_ofs=%d dst=%p dst_ofs=%d cryptolen=%d\n",
-		((direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ? "Encrypt" : "Decrypt"), ctx, req, req->iv,
-		sg_virt(req->src), req->src->offset, sg_virt(req->dst), req->dst->offset, req->cryptlen);
+		      ((direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ? "Encrypt" : "Decrypt"),
+		      ctx, req, req->iv, sg_virt(req->src), req->src->offset,
+		      sg_virt(req->dst), req->dst->offset, req->cryptlen);
 
 	/* STAT_PHASE_0: Init and sanity checks */
 
 	/* Check data length according to mode */
 	if (unlikely(validate_data_size(ctx, direct, req) != 0)) {
 		SSI_LOG_ERR("Unsupported crypt/assoc len %d/%d.\n",
-				req->cryptlen, req->assoclen);
+			    req->cryptlen, req->assoclen);
 		crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_BLOCK_LEN);
 		return -EINVAL;
 	}
@@ -1991,7 +1994,7 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 		memcpy(areq_ctx->ctr_iv, ctx->ctr_nonce, CTR_RFC3686_NONCE_SIZE);
 		if (!areq_ctx->backup_giv) /*User none-generated IV*/
 			memcpy(areq_ctx->ctr_iv + CTR_RFC3686_NONCE_SIZE,
-				req->iv, CTR_RFC3686_IV_SIZE);
+			       req->iv, CTR_RFC3686_IV_SIZE);
 		/* Initialize counter portion of counter block */
 		*(__be32 *)(areq_ctx->ctr_iv + CTR_RFC3686_NONCE_SIZE +
 			    CTR_RFC3686_IV_SIZE) = cpu_to_be32(1);
@@ -2245,7 +2248,7 @@ static int ssi_rfc4543_gcm_setkey(struct crypto_aead *tfm, const u8 *key, unsign
 }
 
 static int ssi_gcm_setauthsize(struct crypto_aead *authenc,
-				      unsigned int authsize)
+			       unsigned int authsize)
 {
 	switch (authsize) {
 	case 4:
@@ -2264,7 +2267,7 @@ static int ssi_gcm_setauthsize(struct crypto_aead *authenc,
 }
 
 static int ssi_rfc4106_gcm_setauthsize(struct crypto_aead *authenc,
-				      unsigned int authsize)
+				       unsigned int authsize)
 {
 	SSI_LOG_DEBUG("ssi_rfc4106_gcm_setauthsize()  authsize %d\n", authsize);
 
@@ -2735,14 +2738,14 @@ int ssi_aead_alloc(struct ssi_drvdata *drvdata)
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
-- 
2.11.0
