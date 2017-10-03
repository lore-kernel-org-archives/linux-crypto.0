From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 2/4] staging: ccree: simplify access to struct device
Date: Tue,  3 Oct 2017 11:42:15 +0100
Message-ID: <1507027339-23824-3-git-send-email-gilad@benyossef.com>
References: <1507027339-23824-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1507027339-23824-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Introduce a function to retrieve struct device from private
data structure in preparation to replacing custom logging
macros with proper dev_dbg and friends which require struct
device.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c        | 11 ++++---
 drivers/staging/ccree/ssi_buffer_mgr.c  | 14 ++++-----
 drivers/staging/ccree/ssi_cipher.c      | 13 +++-----
 drivers/staging/ccree/ssi_driver.c      | 22 +++++++-------
 drivers/staging/ccree/ssi_driver.h      |  6 ++++
 drivers/staging/ccree/ssi_hash.c        | 53 ++++++++++++++++-----------------
 drivers/staging/ccree/ssi_pm.c          | 15 +++++-----
 drivers/staging/ccree/ssi_request_mgr.c | 24 ++++++++-------
 8 files changed, 78 insertions(+), 80 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 7a537f8..a51ad55 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -92,13 +92,12 @@ static inline bool valid_assoclen(struct aead_request *req)
 
 static void ssi_aead_exit(struct crypto_aead *tfm)
 {
-	struct device *dev = NULL;
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
 
 	SSI_LOG_DEBUG("Clearing context @%p for %s\n",
 		      crypto_aead_ctx(tfm), crypto_tfm_alg_name(&tfm->base));
 
-	dev = &ctx->drvdata->plat_dev->dev;
 	/* Unmap enckey buffer */
 	if (ctx->enckey) {
 		dma_free_coherent(dev, AES_MAX_KEY_SIZE, ctx->enckey, ctx->enckey_dma_addr);
@@ -146,11 +145,12 @@ static void ssi_aead_exit(struct crypto_aead *tfm)
 
 static int ssi_aead_init(struct crypto_aead *tfm)
 {
-	struct device *dev;
 	struct aead_alg *alg = crypto_aead_alg(tfm);
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct ssi_crypto_alg *ssi_alg =
 			container_of(alg, struct ssi_crypto_alg, aead_alg);
+	struct device *dev = drvdata_to_dev(ssi_alg->drvdata);
+
 	SSI_LOG_DEBUG("Initializing context @%p for %s\n", ctx, crypto_tfm_alg_name(&tfm->base));
 
 	/* Initialize modes in instance */
@@ -158,7 +158,6 @@ static int ssi_aead_init(struct crypto_aead *tfm)
 	ctx->flow_mode = ssi_alg->flow_mode;
 	ctx->auth_mode = ssi_alg->auth_mode;
 	ctx->drvdata = ssi_alg->drvdata;
-	dev = &ctx->drvdata->plat_dev->dev;
 	crypto_aead_set_reqsize(tfm, sizeof(struct aead_req_ctx));
 
 	/* Allocate key buffer, cache line aligned */
@@ -426,7 +425,7 @@ ssi_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key, unsigned int keyl
 {
 	dma_addr_t key_dma_addr = 0;
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	struct device *dev = &ctx->drvdata->plat_dev->dev;
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	u32 larval_addr = ssi_ahash_get_larval_digest_sram_addr(
 					ctx->drvdata, ctx->auth_mode);
 	struct ssi_crypto_req ssi_req = {};
@@ -1952,7 +1951,7 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
-	struct device *dev = &ctx->drvdata->plat_dev->dev;
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	struct ssi_crypto_req ssi_req = {};
 
 	SSI_LOG_DEBUG("%s context=%p req=%p iv=%p src=%p src_ofs=%d dst=%p dst_ofs=%d cryptolen=%d\n",
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 67c3296..8fd588d 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -514,7 +514,7 @@ int ssi_buffer_mgr_map_blkcipher_request(
 	struct blkcipher_req_ctx *req_ctx = (struct blkcipher_req_ctx *)ctx;
 	struct mlli_params *mlli_params = &req_ctx->mlli_params;
 	struct buff_mgr_handle *buff_mgr = drvdata->buff_mgr_handle;
-	struct device *dev = &drvdata->plat_dev->dev;
+	struct device *dev = drvdata_to_dev(drvdata);
 	struct buffer_array sg_data;
 	u32 dummy = 0;
 	int rc = 0;
@@ -770,7 +770,7 @@ static inline int ssi_buffer_mgr_aead_chain_iv(
 {
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	unsigned int hw_iv_size = areq_ctx->hw_iv_size;
-	struct device *dev = &drvdata->plat_dev->dev;
+	struct device *dev = drvdata_to_dev(drvdata);
 	int rc = 0;
 
 	if (unlikely(!req->iv)) {
@@ -1110,7 +1110,7 @@ static inline int ssi_buffer_mgr_aead_chain_data(
 	bool is_last_table, bool do_chain)
 {
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
-	struct device *dev = &drvdata->plat_dev->dev;
+	struct device *dev = drvdata_to_dev(drvdata);
 	enum drv_crypto_direction direct = areq_ctx->gen_ctx.op_type;
 	unsigned int authsize = areq_ctx->req_authsize;
 	int src_last_bytes = 0, dst_last_bytes = 0;
@@ -1279,7 +1279,7 @@ int ssi_buffer_mgr_map_aead_request(
 {
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	struct mlli_params *mlli_params = &areq_ctx->mlli_params;
-	struct device *dev = &drvdata->plat_dev->dev;
+	struct device *dev = drvdata_to_dev(drvdata);
 	struct buffer_array sg_data;
 	unsigned int authsize = areq_ctx->req_authsize;
 	struct buff_mgr_handle *buff_mgr = drvdata->buff_mgr_handle;
@@ -1490,7 +1490,7 @@ int ssi_buffer_mgr_map_hash_request_final(
 	struct ssi_drvdata *drvdata, void *ctx, struct scatterlist *src, unsigned int nbytes, bool do_update)
 {
 	struct ahash_req_ctx *areq_ctx = (struct ahash_req_ctx *)ctx;
-	struct device *dev = &drvdata->plat_dev->dev;
+	struct device *dev = drvdata_to_dev(drvdata);
 	u8 *curr_buff = areq_ctx->buff_index ? areq_ctx->buff1 :
 			areq_ctx->buff0;
 	u32 *curr_buff_cnt = areq_ctx->buff_index ? &areq_ctx->buff1_cnt :
@@ -1580,7 +1580,7 @@ int ssi_buffer_mgr_map_hash_request_update(
 	struct ssi_drvdata *drvdata, void *ctx, struct scatterlist *src, unsigned int nbytes, unsigned int block_size)
 {
 	struct ahash_req_ctx *areq_ctx = (struct ahash_req_ctx *)ctx;
-	struct device *dev = &drvdata->plat_dev->dev;
+	struct device *dev = drvdata_to_dev(drvdata);
 	u8 *curr_buff = areq_ctx->buff_index ? areq_ctx->buff1 :
 			areq_ctx->buff0;
 	u32 *curr_buff_cnt = areq_ctx->buff_index ? &areq_ctx->buff1_cnt :
@@ -1755,7 +1755,7 @@ void ssi_buffer_mgr_unmap_hash_request(
 int ssi_buffer_mgr_init(struct ssi_drvdata *drvdata)
 {
 	struct buff_mgr_handle *buff_mgr_handle;
-	struct device *dev = &drvdata->plat_dev->dev;
+	struct device *dev = drvdata_to_dev(drvdata);
 
 	buff_mgr_handle = kmalloc(sizeof(*buff_mgr_handle), GFP_KERNEL);
 	if (!buff_mgr_handle)
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index a462075..471c571 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -181,7 +181,7 @@ static int ssi_blkcipher_init(struct crypto_tfm *tfm)
 	struct crypto_alg *alg = tfm->__crt_alg;
 	struct ssi_crypto_alg *ssi_alg =
 			container_of(alg, struct ssi_crypto_alg, crypto_alg);
-	struct device *dev;
+	struct device *dev = drvdata_to_dev(ssi_alg->drvdata);
 	int rc = 0;
 	unsigned int max_key_buf_size = get_max_keysize(tfm);
 
@@ -191,7 +191,6 @@ static int ssi_blkcipher_init(struct crypto_tfm *tfm)
 	ctx_p->cipher_mode = ssi_alg->cipher_mode;
 	ctx_p->flow_mode = ssi_alg->flow_mode;
 	ctx_p->drvdata = ssi_alg->drvdata;
-	dev = &ctx_p->drvdata->plat_dev->dev;
 
 	/* Allocate key buffer, cache line aligned */
 	ctx_p->user.key = kmalloc(max_key_buf_size, GFP_KERNEL | GFP_DMA);
@@ -230,7 +229,7 @@ static int ssi_blkcipher_init(struct crypto_tfm *tfm)
 static void ssi_blkcipher_exit(struct crypto_tfm *tfm)
 {
 	struct ssi_ablkcipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
-	struct device *dev = &ctx_p->drvdata->plat_dev->dev;
+	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
 	unsigned int max_key_buf_size = get_max_keysize(tfm);
 
 	SSI_LOG_DEBUG("Clearing context @%p for %s\n",
@@ -298,7 +297,7 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 				unsigned int keylen)
 {
 	struct ssi_ablkcipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
-	struct device *dev = &ctx_p->drvdata->plat_dev->dev;
+	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
 	u32 tmp[DES_EXPKEY_WORDS];
 	unsigned int max_key_buf_size = get_max_keysize(tfm);
 
@@ -738,7 +737,7 @@ static int ssi_blkcipher_process(
 	enum drv_crypto_direction direction)
 {
 	struct ssi_ablkcipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
-	struct device *dev = &ctx_p->drvdata->plat_dev->dev;
+	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
 	struct cc_hw_desc desc[MAX_ABLKCIPHER_SEQ_LEN];
 	struct ssi_crypto_req ssi_req = {};
 	int rc, seq_len = 0, cts_restore_flag = 0;
@@ -1281,10 +1280,6 @@ int ssi_ablkcipher_free(struct ssi_drvdata *drvdata)
 	struct ssi_crypto_alg *t_alg, *n;
 	struct ssi_blkcipher_handle *blkcipher_handle =
 						drvdata->blkcipher_handle;
-	struct device *dev;
-
-	dev = &drvdata->plat_dev->dev;
-
 	if (blkcipher_handle) {
 		/* Remove registered algs */
 		list_for_each_entry_safe(t_alg, n,
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 6d16220..5342ab8 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -229,14 +229,13 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	u32 signature_val;
 	int rc = 0;
 
-	new_drvdata = devm_kzalloc(&plat_dev->dev, sizeof(*new_drvdata),
-				   GFP_KERNEL);
+	new_drvdata = devm_kzalloc(dev, sizeof(*new_drvdata), GFP_KERNEL);
 	if (!new_drvdata) {
 		SSI_LOG_ERR("Failed to allocate drvdata");
 		rc = -ENOMEM;
 		goto post_drvdata_err;
 	}
-	dev_set_drvdata(&plat_dev->dev, new_drvdata);
+	dev_set_drvdata(dev, new_drvdata);
 	new_drvdata->plat_dev = plat_dev;
 
 	new_drvdata->clk = of_clk_get(np, 0);
@@ -246,8 +245,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	/* First CC registers space */
 	req_mem_cc_regs = platform_get_resource(plat_dev, IORESOURCE_MEM, 0);
 	/* Map registers space */
-	new_drvdata->cc_base = devm_ioremap_resource(&plat_dev->dev,
-						     req_mem_cc_regs);
+	new_drvdata->cc_base = devm_ioremap_resource(dev, req_mem_cc_regs);
 	if (IS_ERR(new_drvdata->cc_base)) {
 		SSI_LOG_ERR("Failed to ioremap registers");
 		rc = PTR_ERR(new_drvdata->cc_base);
@@ -271,7 +269,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		goto post_drvdata_err;
 	}
 
-	rc = devm_request_irq(&plat_dev->dev, new_drvdata->irq, cc_isr,
+	rc = devm_request_irq(dev, new_drvdata->irq, cc_isr,
 			      IRQF_SHARED, "arm_cc7x", new_drvdata);
 	if (rc) {
 		SSI_LOG_ERR("Could not register to interrupt %d\n",
@@ -284,11 +282,11 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	if (rc)
 		goto post_drvdata_err;
 
-	if (!new_drvdata->plat_dev->dev.dma_mask)
-		new_drvdata->plat_dev->dev.dma_mask = &new_drvdata->plat_dev->dev.coherent_dma_mask;
+	if (!dev->dma_mask)
+		dev->dma_mask = &dev->coherent_dma_mask;
 
-	if (!new_drvdata->plat_dev->dev.coherent_dma_mask)
-		new_drvdata->plat_dev->dev.coherent_dma_mask = DMA_BIT_MASK(DMA_BIT_MASK_LEN);
+	if (!dev->coherent_dma_mask)
+		dev->coherent_dma_mask = DMA_BIT_MASK(DMA_BIT_MASK_LEN);
 
 	/* Verify correct mapping */
 	signature_val = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_SIGNATURE));
@@ -311,7 +309,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	}
 
 #ifdef ENABLE_CC_SYSFS
-	rc = ssi_sysfs_init(&plat_dev->dev.kobj, new_drvdata);
+	rc = ssi_sysfs_init(&dev->kobj, new_drvdata);
 	if (unlikely(rc != 0)) {
 		SSI_LOG_ERR("init_stat_db failed\n");
 		goto post_regs_err;
@@ -415,7 +413,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	cc_clk_off(new_drvdata);
 post_drvdata_err:
 	SSI_LOG_ERR("ccree init error occurred!\n");
-	dev_set_drvdata(&plat_dev->dev, NULL);
+	dev_set_drvdata(dev, NULL);
 	return rc;
 }
 
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index 81ba827..7cd51aa 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -37,6 +37,7 @@
 #include <crypto/hash.h>
 #include <linux/version.h>
 #include <linux/clk.h>
+#include <linux/platform_device.h>
 
 /* Registers definitions from shared/hw/ree_include */
 #include "dx_reg_base_host.h"
@@ -184,6 +185,11 @@ struct async_gen_req_ctx {
 	enum drv_crypto_direction op_type;
 };
 
+static inline struct device *drvdata_to_dev(struct ssi_drvdata *drvdata)
+{
+	return &drvdata->plat_dev->dev;
+}
+
 #ifdef DX_DUMP_BYTES
 void dump_byte_array(const char *name, const u8 *the_array, unsigned long size);
 #else
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 36495b5..7eb1adc 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -414,7 +414,7 @@ static int ssi_hash_digest(struct ahash_req_ctx *state,
 			   unsigned int nbytes, u8 *result,
 			   void *async_req)
 {
-	struct device *dev = &ctx->drvdata->plat_dev->dev;
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	bool is_hmac = ctx->is_hmac;
 	struct ssi_crypto_req ssi_req = {};
 	struct cc_hw_desc desc[SSI_MAX_AHASH_SEQ_LEN];
@@ -579,7 +579,7 @@ static int ssi_hash_update(struct ahash_req_ctx *state,
 			   unsigned int nbytes,
 			   void *async_req)
 {
-	struct device *dev = &ctx->drvdata->plat_dev->dev;
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	struct ssi_crypto_req ssi_req = {};
 	struct cc_hw_desc desc[SSI_MAX_AHASH_SEQ_LEN];
 	u32 idx = 0;
@@ -676,7 +676,7 @@ static int ssi_hash_finup(struct ahash_req_ctx *state,
 			  u8 *result,
 			  void *async_req)
 {
-	struct device *dev = &ctx->drvdata->plat_dev->dev;
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	bool is_hmac = ctx->is_hmac;
 	struct ssi_crypto_req ssi_req = {};
 	struct cc_hw_desc desc[SSI_MAX_AHASH_SEQ_LEN];
@@ -810,7 +810,7 @@ static int ssi_hash_final(struct ahash_req_ctx *state,
 			  u8 *result,
 			  void *async_req)
 {
-	struct device *dev = &ctx->drvdata->plat_dev->dev;
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	bool is_hmac = ctx->is_hmac;
 	struct ssi_crypto_req ssi_req = {};
 	struct cc_hw_desc desc[SSI_MAX_AHASH_SEQ_LEN];
@@ -948,7 +948,7 @@ ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
 
 static int ssi_hash_init(struct ahash_req_ctx *state, struct ssi_hash_ctx *ctx)
 {
-	struct device *dev = &ctx->drvdata->plat_dev->dev;
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
 
 	state->xcbc_count = 0;
 
@@ -970,10 +970,12 @@ static int ssi_hash_setkey(void *hash,
 	int i, idx = 0, rc = 0;
 	struct cc_hw_desc desc[SSI_MAX_AHASH_SEQ_LEN];
 	ssi_sram_addr_t larval_addr;
+	struct device *dev;
 
 	 SSI_LOG_DEBUG("start keylen: %d", keylen);
 
 	ctx = crypto_ahash_ctx(((struct crypto_ahash *)hash));
+	dev = drvdata_to_dev(ctx->drvdata);
 	blocksize = crypto_tfm_alg_blocksize(&((struct crypto_ahash *)hash)->base);
 	digestsize = crypto_ahash_digestsize(((struct crypto_ahash *)hash));
 
@@ -989,10 +991,9 @@ static int ssi_hash_setkey(void *hash,
 
 	if (keylen != 0) {
 		ctx->key_params.key_dma_addr = dma_map_single(
-						&ctx->drvdata->plat_dev->dev,
-						(void *)key,
+						dev, (void *)key,
 						keylen, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(&ctx->drvdata->plat_dev->dev,
+		if (unlikely(dma_mapping_error(dev,
 					       ctx->key_params.key_dma_addr))) {
 			SSI_LOG_ERR("Mapping key va=0x%p len=%u for"
 				   " DMA failed\n", key, keylen);
@@ -1139,8 +1140,7 @@ static int ssi_hash_setkey(void *hash,
 		crypto_ahash_set_flags((struct crypto_ahash *)hash, CRYPTO_TFM_RES_BAD_KEY_LEN);
 
 	if (ctx->key_params.key_dma_addr) {
-		dma_unmap_single(&ctx->drvdata->plat_dev->dev,
-				 ctx->key_params.key_dma_addr,
+		dma_unmap_single(dev, ctx->key_params.key_dma_addr,
 				 ctx->key_params.keylen, DMA_TO_DEVICE);
 		SSI_LOG_DEBUG("Unmapped key-buffer: key_dma_addr=%pad keylen=%u\n",
 			      ctx->key_params.key_dma_addr,
@@ -1154,6 +1154,7 @@ static int ssi_xcbc_setkey(struct crypto_ahash *ahash,
 {
 	struct ssi_crypto_req ssi_req = {};
 	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(ahash);
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	int idx = 0, rc = 0;
 	struct cc_hw_desc desc[SSI_MAX_AHASH_SEQ_LEN];
 
@@ -1171,11 +1172,9 @@ static int ssi_xcbc_setkey(struct crypto_ahash *ahash,
 	ctx->key_params.keylen = keylen;
 
 	ctx->key_params.key_dma_addr = dma_map_single(
-					&ctx->drvdata->plat_dev->dev,
-					(void *)key,
+					dev, (void *)key,
 					keylen, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(&ctx->drvdata->plat_dev->dev,
-				       ctx->key_params.key_dma_addr))) {
+	if (unlikely(dma_mapping_error(dev, ctx->key_params.key_dma_addr))) {
 		SSI_LOG_ERR("Mapping key va=0x%p len=%u for"
 			   " DMA failed\n", key, keylen);
 		return -ENOMEM;
@@ -1226,8 +1225,7 @@ static int ssi_xcbc_setkey(struct crypto_ahash *ahash,
 	if (rc != 0)
 		crypto_ahash_set_flags(ahash, CRYPTO_TFM_RES_BAD_KEY_LEN);
 
-	dma_unmap_single(&ctx->drvdata->plat_dev->dev,
-			 ctx->key_params.key_dma_addr,
+	dma_unmap_single(dev, ctx->key_params.key_dma_addr,
 			 ctx->key_params.keylen, DMA_TO_DEVICE);
 	SSI_LOG_DEBUG("Unmapped key-buffer: key_dma_addr=%pad keylen=%u\n",
 		      ctx->key_params.key_dma_addr,
@@ -1241,6 +1239,7 @@ static int ssi_cmac_setkey(struct crypto_ahash *ahash,
 			   const u8 *key, unsigned int keylen)
 {
 	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(ahash);
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
 
 	SSI_LOG_DEBUG("===== setkey (%d) ====\n", keylen);
 
@@ -1259,16 +1258,14 @@ static int ssi_cmac_setkey(struct crypto_ahash *ahash,
 
 	/* STAT_PHASE_1: Copy key to ctx */
 
-	dma_sync_single_for_cpu(&ctx->drvdata->plat_dev->dev,
-				ctx->opad_tmp_keys_dma_addr,
+	dma_sync_single_for_cpu(dev, ctx->opad_tmp_keys_dma_addr,
 				keylen, DMA_TO_DEVICE);
 
 	memcpy(ctx->opad_tmp_keys_buff, key, keylen);
 	if (keylen == 24)
 		memset(ctx->opad_tmp_keys_buff + 24, 0, CC_AES_KEY_SIZE_MAX - 24);
 
-	dma_sync_single_for_device(&ctx->drvdata->plat_dev->dev,
-				   ctx->opad_tmp_keys_dma_addr,
+	dma_sync_single_for_device(dev, ctx->opad_tmp_keys_dma_addr,
 				   keylen, DMA_TO_DEVICE);
 
 	ctx->key_params.keylen = keylen;
@@ -1279,7 +1276,7 @@ static int ssi_cmac_setkey(struct crypto_ahash *ahash,
 
 static void ssi_hash_free_ctx(struct ssi_hash_ctx *ctx)
 {
-	struct device *dev = &ctx->drvdata->plat_dev->dev;
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
 
 	if (ctx->digest_buff_dma_addr != 0) {
 		dma_unmap_single(dev, ctx->digest_buff_dma_addr,
@@ -1304,7 +1301,7 @@ static void ssi_hash_free_ctx(struct ssi_hash_ctx *ctx)
 
 static int ssi_hash_alloc_ctx(struct ssi_hash_ctx *ctx)
 {
-	struct device *dev = &ctx->drvdata->plat_dev->dev;
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
 
 	ctx->key_params.keylen = 0;
 
@@ -1371,7 +1368,7 @@ static int ssi_mac_update(struct ahash_request *req)
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct device *dev = &ctx->drvdata->plat_dev->dev;
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	unsigned int block_size = crypto_tfm_alg_blocksize(&tfm->base);
 	struct ssi_crypto_req ssi_req = {};
 	struct cc_hw_desc desc[SSI_MAX_AHASH_SEQ_LEN];
@@ -1431,7 +1428,7 @@ static int ssi_mac_final(struct ahash_request *req)
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct device *dev = &ctx->drvdata->plat_dev->dev;
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	struct ssi_crypto_req ssi_req = {};
 	struct cc_hw_desc desc[SSI_MAX_AHASH_SEQ_LEN];
 	int idx = 0;
@@ -1542,7 +1539,7 @@ static int ssi_mac_finup(struct ahash_request *req)
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct device *dev = &ctx->drvdata->plat_dev->dev;
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	struct ssi_crypto_req ssi_req = {};
 	struct cc_hw_desc desc[SSI_MAX_AHASH_SEQ_LEN];
 	int idx = 0;
@@ -1613,7 +1610,7 @@ static int ssi_mac_digest(struct ahash_request *req)
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct device *dev = &ctx->drvdata->plat_dev->dev;
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	u32 digestsize = crypto_ahash_digestsize(tfm);
 	struct ssi_crypto_req ssi_req = {};
 	struct cc_hw_desc desc[SSI_MAX_AHASH_SEQ_LEN];
@@ -1737,7 +1734,7 @@ static int ssi_ahash_export(struct ahash_request *req, void *out)
 {
 	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
 	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(ahash);
-	struct device *dev = &ctx->drvdata->plat_dev->dev;
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
 	u8 *curr_buff = state->buff_index ? state->buff1 : state->buff0;
 	u32 curr_buff_cnt = state->buff_index ? state->buff1_cnt :
@@ -1778,7 +1775,7 @@ static int ssi_ahash_import(struct ahash_request *req, const void *in)
 {
 	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
 	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(ahash);
-	struct device *dev = &ctx->drvdata->plat_dev->dev;
+	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
 	u32 tmp;
 	int rc;
diff --git a/drivers/staging/ccree/ssi_pm.c b/drivers/staging/ccree/ssi_pm.c
index a50671a..4f522a6 100644
--- a/drivers/staging/ccree/ssi_pm.c
+++ b/drivers/staging/ccree/ssi_pm.c
@@ -121,16 +121,17 @@ int ssi_power_mgr_init(struct ssi_drvdata *drvdata)
 {
 	int rc = 0;
 #if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
-	struct platform_device *plat_dev = drvdata->plat_dev;
+	struct device *dev = drvdata_to_dev(drvdata);
+
 	/* must be before the enabling to avoid resdundent suspending */
-	pm_runtime_set_autosuspend_delay(&plat_dev->dev, SSI_SUSPEND_TIMEOUT);
-	pm_runtime_use_autosuspend(&plat_dev->dev);
+	pm_runtime_set_autosuspend_delay(dev, SSI_SUSPEND_TIMEOUT);
+	pm_runtime_use_autosuspend(dev);
 	/* activate the PM module */
-	rc = pm_runtime_set_active(&plat_dev->dev);
+	rc = pm_runtime_set_active(dev);
 	if (rc != 0)
 		return rc;
 	/* enable the PM module*/
-	pm_runtime_enable(&plat_dev->dev);
+	pm_runtime_enable(dev);
 #endif
 	return rc;
 }
@@ -138,8 +139,6 @@ int ssi_power_mgr_init(struct ssi_drvdata *drvdata)
 void ssi_power_mgr_fini(struct ssi_drvdata *drvdata)
 {
 #if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
-	struct platform_device *plat_dev = drvdata->plat_dev;
-
-	pm_runtime_disable(&plat_dev->dev);
+	pm_runtime_disable(drvdata_to_dev(drvdata));
 #endif
 }
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index daa5432..ec69d9c 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -68,13 +68,13 @@ static void comp_work_handler(struct work_struct *work);
 void request_mgr_fini(struct ssi_drvdata *drvdata)
 {
 	struct ssi_request_mgr_handle *req_mgr_h = drvdata->request_mgr_handle;
+	struct device *dev = drvdata_to_dev(drvdata);
 
 	if (!req_mgr_h)
 		return; /* Not allocated */
 
 	if (req_mgr_h->dummy_comp_buff_dma != 0) {
-		dma_free_coherent(&drvdata->plat_dev->dev,
-				  sizeof(u32), req_mgr_h->dummy_comp_buff,
+		dma_free_coherent(dev, sizeof(u32), req_mgr_h->dummy_comp_buff,
 				  req_mgr_h->dummy_comp_buff_dma);
 	}
 
@@ -97,6 +97,7 @@ void request_mgr_fini(struct ssi_drvdata *drvdata)
 int request_mgr_init(struct ssi_drvdata *drvdata)
 {
 	struct ssi_request_mgr_handle *req_mgr_h;
+	struct device *dev = drvdata_to_dev(drvdata);
 	int rc = 0;
 
 	req_mgr_h = kzalloc(sizeof(*req_mgr_h), GFP_KERNEL);
@@ -134,8 +135,7 @@ int request_mgr_init(struct ssi_drvdata *drvdata)
 	req_mgr_h->max_used_sw_slots = 0;
 
 	/* Allocate DMA word for "dummy" completion descriptor use */
-	req_mgr_h->dummy_comp_buff = dma_alloc_coherent(&drvdata->plat_dev->dev,
-							sizeof(u32),
+	req_mgr_h->dummy_comp_buff = dma_alloc_coherent(dev, sizeof(u32),
 							&req_mgr_h->dummy_comp_buff_dma,
 							GFP_KERNEL);
 	if (!req_mgr_h->dummy_comp_buff) {
@@ -269,6 +269,9 @@ int send_request(
 	unsigned int iv_seq_len = 0;
 	unsigned int total_seq_len = len; /*initial sequence length*/
 	struct cc_hw_desc iv_seq[SSI_IVPOOL_SEQ_LEN];
+#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
+	struct device *dev = drvdata_to_dev(drvdata);
+#endif
 	int rc;
 	unsigned int max_required_seq_len = (total_seq_len +
 					((ssi_req->ivgen_dma_addr_len == 0) ? 0 :
@@ -276,7 +279,7 @@ int send_request(
 					((is_dout == 0) ? 1 : 0));
 
 #if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
-	rc = ssi_power_mgr_runtime_get(&drvdata->plat_dev->dev);
+	rc = ssi_power_mgr_runtime_get(dev);
 	if (rc != 0) {
 		SSI_LOG_ERR("ssi_power_mgr_runtime_get returned %x\n", rc);
 		return rc;
@@ -303,7 +306,7 @@ int send_request(
 			 * (SW queue is full)
 			 */
 #if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
-			ssi_power_mgr_runtime_put_suspend(&drvdata->plat_dev->dev);
+			ssi_power_mgr_runtime_put_suspend(dev);
 #endif
 			return rc;
 		}
@@ -339,7 +342,7 @@ int send_request(
 			SSI_LOG_ERR("Failed to generate IV (rc=%d)\n", rc);
 			spin_unlock_bh(&req_mgr_h->hw_lock);
 #if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
-			ssi_power_mgr_runtime_put_suspend(&drvdata->plat_dev->dev);
+			ssi_power_mgr_runtime_put_suspend(dev);
 #endif
 			return rc;
 		}
@@ -452,7 +455,7 @@ static void comp_work_handler(struct work_struct *work)
 static void proc_completions(struct ssi_drvdata *drvdata)
 {
 	struct ssi_crypto_req *ssi_req;
-	struct platform_device *plat_dev = drvdata->plat_dev;
+	struct device *dev = drvdata_to_dev(drvdata);
 	struct ssi_request_mgr_handle *request_mgr_handle =
 						drvdata->request_mgr_handle;
 #if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
@@ -492,12 +495,13 @@ static void proc_completions(struct ssi_drvdata *drvdata)
 #endif /* COMPLETION_DELAY */
 
 		if (likely(ssi_req->user_cb))
-			ssi_req->user_cb(&plat_dev->dev, ssi_req->user_arg, drvdata->cc_base);
+			ssi_req->user_cb(dev, ssi_req->user_arg,
+					 drvdata->cc_base);
 		request_mgr_handle->req_queue_tail = (request_mgr_handle->req_queue_tail + 1) & (MAX_REQUEST_QUEUE_SIZE - 1);
 		SSI_LOG_DEBUG("Dequeue request tail=%u\n", request_mgr_handle->req_queue_tail);
 		SSI_LOG_DEBUG("Request completed. axi_completed=%d\n", request_mgr_handle->axi_completed);
 #if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
-		rc = ssi_power_mgr_runtime_put_suspend(&plat_dev->dev);
+		rc = ssi_power_mgr_runtime_put_suspend(dev);
 		if (rc != 0)
 			SSI_LOG_ERR("Failed to set runtime suspension %d\n", rc);
 #endif
-- 
2.7.4
