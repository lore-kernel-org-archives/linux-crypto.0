From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 05/27] staging: ccree: pick alloc mem flags based on req
 flags
Date: Sun,  7 Jan 2018 12:14:16 +0000
Message-ID: <1515327285-8948-6-git-send-email-gilad@benyossef.com>
References: <1515327285-8948-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1515327285-8948-1-git-send-email-gilad@benyossef.com>
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

The ccree driver was allocating memory using GFP_KERNEL flag
always, ignoring the flags set in the crypto request. Fix it
by choosing gfp flags based on crypto request flags.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_buffer_mgr.c | 19 +++++++------
 drivers/staging/ccree/ssi_buffer_mgr.h |  6 ++--
 drivers/staging/ccree/ssi_cipher.c     |  8 ++++--
 drivers/staging/ccree/ssi_driver.h     |  6 ++++
 drivers/staging/ccree/ssi_hash.c       | 50 ++++++++++++++++++++--------------
 5 files changed, 54 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index ece17caf..e85bb53 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -217,7 +217,7 @@ static int cc_render_sg_to_mlli(struct device *dev, struct scatterlist *sgl,
 }
 
 static int cc_generate_mlli(struct device *dev, struct buffer_array *sg_data,
-			    struct mlli_params *mlli_params)
+			    struct mlli_params *mlli_params, gfp_t flags)
 {
 	u32 *mlli_p;
 	u32 total_nents = 0, prev_total_nents = 0;
@@ -227,7 +227,7 @@ static int cc_generate_mlli(struct device *dev, struct buffer_array *sg_data,
 
 	/* Allocate memory from the pointed pool */
 	mlli_params->mlli_virt_addr =
-		dma_pool_alloc(mlli_params->curr_pool, GFP_KERNEL,
+		dma_pool_alloc(mlli_params->curr_pool, flags,
 			       &mlli_params->mlli_dma_addr);
 	if (!mlli_params->mlli_virt_addr) {
 		dev_err(dev, "dma_pool_alloc() failed\n");
@@ -483,7 +483,7 @@ void cc_unmap_blkcipher_request(struct device *dev, void *ctx,
 int cc_map_blkcipher_request(struct cc_drvdata *drvdata, void *ctx,
 			     unsigned int ivsize, unsigned int nbytes,
 			     void *info, struct scatterlist *src,
-			     struct scatterlist *dst)
+			     struct scatterlist *dst, gfp_t flags)
 {
 	struct blkcipher_req_ctx *req_ctx = (struct blkcipher_req_ctx *)ctx;
 	struct mlli_params *mlli_params = &req_ctx->mlli_params;
@@ -558,7 +558,7 @@ int cc_map_blkcipher_request(struct cc_drvdata *drvdata, void *ctx,
 
 	if (req_ctx->dma_buf_type == CC_DMA_BUF_MLLI) {
 		mlli_params->curr_pool = buff_mgr->mlli_buffs_pool;
-		rc = cc_generate_mlli(dev, &sg_data, mlli_params);
+		rc = cc_generate_mlli(dev, &sg_data, mlli_params, flags);
 		if (rc)
 			goto ablkcipher_exit;
 	}
@@ -1200,6 +1200,7 @@ int cc_map_aead_request(struct cc_drvdata *drvdata, struct aead_request *req)
 	u32 mapped_nents = 0;
 	u32 dummy = 0; /*used for the assoc data fragments */
 	u32 size_to_map = 0;
+	gfp_t flags = cc_gfp_flags(&req->base);
 
 	mlli_params->curr_pool = NULL;
 	sg_data.num_of_buffers = 0;
@@ -1366,7 +1367,7 @@ int cc_map_aead_request(struct cc_drvdata *drvdata, struct aead_request *req)
 	if (areq_ctx->assoc_buff_type == CC_DMA_BUF_MLLI ||
 	    areq_ctx->data_buff_type == CC_DMA_BUF_MLLI) {
 		mlli_params->curr_pool = buff_mgr->mlli_buffs_pool;
-		rc = cc_generate_mlli(dev, &sg_data, mlli_params);
+		rc = cc_generate_mlli(dev, &sg_data, mlli_params, flags);
 		if (rc)
 			goto aead_map_failure;
 
@@ -1385,7 +1386,7 @@ int cc_map_aead_request(struct cc_drvdata *drvdata, struct aead_request *req)
 
 int cc_map_hash_request_final(struct cc_drvdata *drvdata, void *ctx,
 			      struct scatterlist *src, unsigned int nbytes,
-			      bool do_update)
+			      bool do_update, gfp_t flags)
 {
 	struct ahash_req_ctx *areq_ctx = (struct ahash_req_ctx *)ctx;
 	struct device *dev = drvdata_to_dev(drvdata);
@@ -1445,7 +1446,7 @@ int cc_map_hash_request_final(struct cc_drvdata *drvdata, void *ctx,
 		/* add the src data to the sg_data */
 		cc_add_sg_entry(dev, &sg_data, areq_ctx->in_nents, src, nbytes,
 				0, true, &areq_ctx->mlli_nents);
-		if (cc_generate_mlli(dev, &sg_data, mlli_params))
+		if (cc_generate_mlli(dev, &sg_data, mlli_params, flags))
 			goto fail_unmap_din;
 	}
 	/* change the buffer index for the unmap function */
@@ -1466,7 +1467,7 @@ int cc_map_hash_request_final(struct cc_drvdata *drvdata, void *ctx,
 
 int cc_map_hash_request_update(struct cc_drvdata *drvdata, void *ctx,
 			       struct scatterlist *src, unsigned int nbytes,
-			       unsigned int block_size)
+			       unsigned int block_size, gfp_t flags)
 {
 	struct ahash_req_ctx *areq_ctx = (struct ahash_req_ctx *)ctx;
 	struct device *dev = drvdata_to_dev(drvdata);
@@ -1562,7 +1563,7 @@ int cc_map_hash_request_update(struct cc_drvdata *drvdata, void *ctx,
 		cc_add_sg_entry(dev, &sg_data, areq_ctx->in_nents, src,
 				(update_data_len - *curr_buff_cnt), 0, true,
 				&areq_ctx->mlli_nents);
-		if (cc_generate_mlli(dev, &sg_data, mlli_params))
+		if (cc_generate_mlli(dev, &sg_data, mlli_params, flags))
 			goto fail_unmap_din;
 	}
 	areq_ctx->buff_index = (areq_ctx->buff_index ^ swap_index);
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.h b/drivers/staging/ccree/ssi_buffer_mgr.h
index cc4b173..0ddadd7 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.h
+++ b/drivers/staging/ccree/ssi_buffer_mgr.h
@@ -43,7 +43,7 @@ int cc_buffer_mgr_fini(struct cc_drvdata *drvdata);
 int cc_map_blkcipher_request(struct cc_drvdata *drvdata, void *ctx,
 			     unsigned int ivsize, unsigned int nbytes,
 			     void *info, struct scatterlist *src,
-			     struct scatterlist *dst);
+			     struct scatterlist *dst, gfp_t flags);
 
 void cc_unmap_blkcipher_request(struct device *dev, void *ctx,
 				unsigned int ivsize,
@@ -56,11 +56,11 @@ void cc_unmap_aead_request(struct device *dev, struct aead_request *req);
 
 int cc_map_hash_request_final(struct cc_drvdata *drvdata, void *ctx,
 			      struct scatterlist *src, unsigned int nbytes,
-			      bool do_update);
+			      bool do_update, gfp_t flags);
 
 int cc_map_hash_request_update(struct cc_drvdata *drvdata, void *ctx,
 			       struct scatterlist *src, unsigned int nbytes,
-			       unsigned int block_size);
+			       unsigned int block_size, gfp_t flags);
 
 void cc_unmap_hash_request(struct device *dev, void *ctx,
 			   struct scatterlist *src, bool do_revert);
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 496eb19..933a452 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -639,6 +639,7 @@ static int cc_cipher_process(struct ablkcipher_request *req,
 	struct cc_hw_desc desc[MAX_ABLKCIPHER_SEQ_LEN];
 	struct cc_crypto_req cc_req = {};
 	int rc, seq_len = 0, cts_restore_flag = 0;
+	gfp_t flags = cc_gfp_flags(&req->base);
 
 	dev_dbg(dev, "%s req=%p info=%p nbytes=%d\n",
 		((direction == DRV_CRYPTO_DIRECTION_ENCRYPT) ?
@@ -662,7 +663,7 @@ static int cc_cipher_process(struct ablkcipher_request *req,
 	/* The IV we are handed may be allocted from the stack so
 	 * we must copy it to a DMAable buffer before use.
 	 */
-	req_ctx->iv = kmalloc(ivsize, GFP_KERNEL);
+	req_ctx->iv = kmalloc(ivsize, flags);
 	if (!req_ctx->iv) {
 		rc = -ENOMEM;
 		goto exit_process;
@@ -692,7 +693,7 @@ static int cc_cipher_process(struct ablkcipher_request *req,
 	/* STAT_PHASE_1: Map buffers */
 
 	rc = cc_map_blkcipher_request(ctx_p->drvdata, req_ctx, ivsize, nbytes,
-				      req_ctx->iv, src, dst);
+				      req_ctx->iv, src, dst, flags);
 	if (rc) {
 		dev_err(dev, "map_request() failed\n");
 		goto exit_process;
@@ -751,12 +752,13 @@ static int cc_cipher_decrypt(struct ablkcipher_request *req)
 	struct crypto_ablkcipher *ablk_tfm = crypto_ablkcipher_reqtfm(req);
 	struct blkcipher_req_ctx *req_ctx = ablkcipher_request_ctx(req);
 	unsigned int ivsize = crypto_ablkcipher_ivsize(ablk_tfm);
+	gfp_t flags = cc_gfp_flags(&req->base);
 
 	/*
 	 * Allocate and save the last IV sized bytes of the source, which will
 	 * be lost in case of in-place decryption and might be needed for CTS.
 	 */
-	req_ctx->backup_info = kmalloc(ivsize, GFP_KERNEL);
+	req_ctx->backup_info = kmalloc(ivsize, flags);
 	if (!req_ctx->backup_info)
 		return -ENOMEM;
 
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index 60c1cfd..f71c602 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -184,5 +184,11 @@ static inline u32 cc_ioread(struct cc_drvdata *drvdata, u32 reg)
 	return ioread32(drvdata->cc_base + reg);
 }
 
+static inline gfp_t cc_gfp_flags(struct crypto_async_request *req)
+{
+	return (req->flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+			GFP_KERNEL : GFP_ATOMIC;
+}
+
 #endif /*__CC_DRIVER_H__*/
 
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index f178ffa..7a8a036 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -123,7 +123,7 @@ static int cc_map_result(struct device *dev, struct ahash_req_ctx *state,
 }
 
 static int cc_map_req(struct device *dev, struct ahash_req_ctx *state,
-		      struct cc_hash_ctx *ctx)
+		      struct cc_hash_ctx *ctx, gfp_t flags)
 {
 	bool is_hmac = ctx->is_hmac;
 	cc_sram_addr_t larval_digest_addr =
@@ -132,27 +132,26 @@ static int cc_map_req(struct device *dev, struct ahash_req_ctx *state,
 	struct cc_hw_desc desc;
 	int rc = -ENOMEM;
 
-	state->buff0 = kzalloc(CC_MAX_HASH_BLCK_SIZE, GFP_KERNEL);
+	state->buff0 = kzalloc(CC_MAX_HASH_BLCK_SIZE, flags);
 	if (!state->buff0)
 		goto fail0;
 
-	state->buff1 = kzalloc(CC_MAX_HASH_BLCK_SIZE, GFP_KERNEL);
+	state->buff1 = kzalloc(CC_MAX_HASH_BLCK_SIZE, flags);
 	if (!state->buff1)
 		goto fail_buff0;
 
-	state->digest_result_buff = kzalloc(CC_MAX_HASH_DIGEST_SIZE,
-					    GFP_KERNEL);
+	state->digest_result_buff = kzalloc(CC_MAX_HASH_DIGEST_SIZE, flags);
 	if (!state->digest_result_buff)
 		goto fail_buff1;
 
-	state->digest_buff = kzalloc(ctx->inter_digestsize, GFP_KERNEL);
+	state->digest_buff = kzalloc(ctx->inter_digestsize, flags);
 	if (!state->digest_buff)
 		goto fail_digest_result_buff;
 
 	dev_dbg(dev, "Allocated digest-buffer in context ctx->digest_buff=@%p\n",
 		state->digest_buff);
 	if (ctx->hw_mode != DRV_CIPHER_XCBC_MAC) {
-		state->digest_bytes_len = kzalloc(HASH_LEN_SIZE, GFP_KERNEL);
+		state->digest_bytes_len = kzalloc(HASH_LEN_SIZE, flags);
 		if (!state->digest_bytes_len)
 			goto fail1;
 
@@ -162,7 +161,7 @@ static int cc_map_req(struct device *dev, struct ahash_req_ctx *state,
 		state->digest_bytes_len = NULL;
 	}
 
-	state->opad_digest_buff = kzalloc(ctx->inter_digestsize, GFP_KERNEL);
+	state->opad_digest_buff = kzalloc(ctx->inter_digestsize, flags);
 	if (!state->opad_digest_buff)
 		goto fail2;
 
@@ -415,11 +414,12 @@ static int cc_hash_digest(struct ahash_request *req)
 		cc_larval_digest_addr(ctx->drvdata, ctx->hash_mode);
 	int idx = 0;
 	int rc = 0;
+	gfp_t flags = cc_gfp_flags(&req->base);
 
 	dev_dbg(dev, "===== %s-digest (%d) ====\n", is_hmac ? "hmac" : "hash",
 		nbytes);
 
-	if (cc_map_req(dev, state, ctx)) {
+	if (cc_map_req(dev, state, ctx, flags)) {
 		dev_err(dev, "map_ahash_source() failed\n");
 		return -ENOMEM;
 	}
@@ -429,7 +429,8 @@ static int cc_hash_digest(struct ahash_request *req)
 		return -ENOMEM;
 	}
 
-	if (cc_map_hash_request_final(ctx->drvdata, state, src, nbytes, 1)) {
+	if (cc_map_hash_request_final(ctx->drvdata, state, src, nbytes, 1,
+				      flags)) {
 		dev_err(dev, "map_ahash_request_final() failed\n");
 		return -ENOMEM;
 	}
@@ -566,6 +567,7 @@ static int cc_hash_update(struct ahash_request *req)
 	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
 	u32 idx = 0;
 	int rc;
+	gfp_t flags = cc_gfp_flags(&req->base);
 
 	dev_dbg(dev, "===== %s-update (%d) ====\n", ctx->is_hmac ?
 		"hmac" : "hash", nbytes);
@@ -576,7 +578,7 @@ static int cc_hash_update(struct ahash_request *req)
 	}
 
 	rc = cc_map_hash_request_update(ctx->drvdata, state, src, nbytes,
-					block_size);
+					block_size, flags);
 	if (rc) {
 		if (rc == 1) {
 			dev_dbg(dev, " data size not require HW update %x\n",
@@ -653,11 +655,13 @@ static int cc_hash_finup(struct ahash_request *req)
 	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
 	int idx = 0;
 	int rc;
+	gfp_t flags = cc_gfp_flags(&req->base);
 
 	dev_dbg(dev, "===== %s-finup (%d) ====\n", is_hmac ? "hmac" : "hash",
 		nbytes);
 
-	if (cc_map_hash_request_final(ctx->drvdata, state, src, nbytes, 1)) {
+	if (cc_map_hash_request_final(ctx->drvdata, state, src, nbytes, 1,
+				      flags)) {
 		dev_err(dev, "map_ahash_request_final() failed\n");
 		return -ENOMEM;
 	}
@@ -773,11 +777,13 @@ static int cc_hash_final(struct ahash_request *req)
 	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
 	int idx = 0;
 	int rc;
+	gfp_t flags = cc_gfp_flags(&req->base);
 
 	dev_dbg(dev, "===== %s-final (%d) ====\n", is_hmac ? "hmac" : "hash",
 		nbytes);
 
-	if (cc_map_hash_request_final(ctx->drvdata, state, src, nbytes, 0)) {
+	if (cc_map_hash_request_final(ctx->drvdata, state, src, nbytes, 0,
+				      flags)) {
 		dev_err(dev, "map_ahash_request_final() failed\n");
 		return -ENOMEM;
 	}
@@ -894,11 +900,12 @@ static int cc_hash_init(struct ahash_request *req)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
+	gfp_t flags = cc_gfp_flags(&req->base);
 
 	dev_dbg(dev, "===== init (%d) ====\n", req->nbytes);
 
 	state->xcbc_count = 0;
-	cc_map_req(dev, state, ctx);
+	cc_map_req(dev, state, ctx, flags);
 
 	return 0;
 }
@@ -1317,6 +1324,7 @@ static int cc_mac_update(struct ahash_request *req)
 	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
 	int rc;
 	u32 idx = 0;
+	gfp_t flags = cc_gfp_flags(&req->base);
 
 	if (req->nbytes == 0) {
 		/* no real updates required */
@@ -1326,7 +1334,7 @@ static int cc_mac_update(struct ahash_request *req)
 	state->xcbc_count++;
 
 	rc = cc_map_hash_request_update(ctx->drvdata, state, req->src,
-					req->nbytes, block_size);
+					req->nbytes, block_size, flags);
 	if (rc) {
 		if (rc == 1) {
 			dev_dbg(dev, " data size not require HW update %x\n",
@@ -1379,7 +1387,7 @@ static int cc_mac_final(struct ahash_request *req)
 	int rc = 0;
 	u32 key_size, key_len;
 	u32 digestsize = crypto_ahash_digestsize(tfm);
-
+	gfp_t flags = cc_gfp_flags(&req->base);
 	u32 rem_cnt = state->buff_index ? state->buff1_cnt :
 			state->buff0_cnt;
 
@@ -1395,7 +1403,7 @@ static int cc_mac_final(struct ahash_request *req)
 	dev_dbg(dev, "===== final  xcbc reminder (%d) ====\n", rem_cnt);
 
 	if (cc_map_hash_request_final(ctx->drvdata, state, req->src,
-				      req->nbytes, 0)) {
+				      req->nbytes, 0, flags)) {
 		dev_err(dev, "map_ahash_request_final() failed\n");
 		return -ENOMEM;
 	}
@@ -1493,6 +1501,7 @@ static int cc_mac_finup(struct ahash_request *req)
 	int rc = 0;
 	u32 key_len = 0;
 	u32 digestsize = crypto_ahash_digestsize(tfm);
+	gfp_t flags = cc_gfp_flags(&req->base);
 
 	dev_dbg(dev, "===== finup xcbc(%d) ====\n", req->nbytes);
 	if (state->xcbc_count > 0 && req->nbytes == 0) {
@@ -1501,7 +1510,7 @@ static int cc_mac_finup(struct ahash_request *req)
 	}
 
 	if (cc_map_hash_request_final(ctx->drvdata, state, req->src,
-				      req->nbytes, 1)) {
+				      req->nbytes, 1, flags)) {
 		dev_err(dev, "map_ahash_request_final() failed\n");
 		return -ENOMEM;
 	}
@@ -1565,10 +1574,11 @@ static int cc_mac_digest(struct ahash_request *req)
 	u32 key_len;
 	int idx = 0;
 	int rc;
+	gfp_t flags = cc_gfp_flags(&req->base);
 
 	dev_dbg(dev, "===== -digest mac (%d) ====\n",  req->nbytes);
 
-	if (cc_map_req(dev, state, ctx)) {
+	if (cc_map_req(dev, state, ctx, flags)) {
 		dev_err(dev, "map_ahash_source() failed\n");
 		return -ENOMEM;
 	}
@@ -1578,7 +1588,7 @@ static int cc_mac_digest(struct ahash_request *req)
 	}
 
 	if (cc_map_hash_request_final(ctx->drvdata, state, req->src,
-				      req->nbytes, 1)) {
+				      req->nbytes, 1, flags)) {
 		dev_err(dev, "map_ahash_request_final() failed\n");
 		return -ENOMEM;
 	}
-- 
2.7.4
