From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 14/24] staging: ccree: fix ivgen naming convention
Date: Tue, 12 Dec 2017 14:53:00 +0000
Message-ID: <1513090395-7938-15-git-send-email-gilad@benyossef.com>
References: <1513090395-7938-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1513090395-7938-1-git-send-email-gilad@benyossef.com>
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

The ivgen files were using a func naming convention which was
inconsistent (ssi vs. cc), included a long prefix (ssi_ivgen)
and often too long.

Make the code more readable by switching to a simpler, consistent naming
convention.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_driver.c      |  8 ++--
 drivers/staging/ccree/ssi_ivgen.c       | 66 ++++++++++++++++-----------------
 drivers/staging/ccree/ssi_ivgen.h       |  8 ++--
 drivers/staging/ccree/ssi_pm.c          |  2 +-
 drivers/staging/ccree/ssi_request_mgr.c |  7 ++--
 5 files changed, 46 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 2a0dd85..f4164eb 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -344,9 +344,9 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		goto post_buf_mgr_err;
 	}
 
-	rc = ssi_ivgen_init(new_drvdata);
+	rc = cc_ivgen_init(new_drvdata);
 	if (rc) {
-		dev_err(dev, "ssi_ivgen_init failed\n");
+		dev_err(dev, "cc_ivgen_init failed\n");
 		goto post_power_mgr_err;
 	}
 
@@ -383,7 +383,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 post_cipher_err:
 	cc_cipher_free(new_drvdata);
 post_ivgen_err:
-	ssi_ivgen_fini(new_drvdata);
+	cc_ivgen_fini(new_drvdata);
 post_power_mgr_err:
 	cc_pm_fini(new_drvdata);
 post_buf_mgr_err:
@@ -419,7 +419,7 @@ static void cleanup_cc_resources(struct platform_device *plat_dev)
 	cc_aead_free(drvdata);
 	cc_hash_free(drvdata);
 	cc_cipher_free(drvdata);
-	ssi_ivgen_fini(drvdata);
+	cc_ivgen_fini(drvdata);
 	cc_pm_fini(drvdata);
 	cc_buffer_mgr_fini(drvdata);
 	cc_req_mgr_fini(drvdata);
diff --git a/drivers/staging/ccree/ssi_ivgen.c b/drivers/staging/ccree/ssi_ivgen.c
index febee22..ad6cd97 100644
--- a/drivers/staging/ccree/ssi_ivgen.c
+++ b/drivers/staging/ccree/ssi_ivgen.c
@@ -24,15 +24,15 @@
 #include "ssi_buffer_mgr.h"
 
 /* The max. size of pool *MUST* be <= SRAM total size */
-#define SSI_IVPOOL_SIZE 1024
+#define CC_IVPOOL_SIZE 1024
 /* The first 32B fraction of pool are dedicated to the
  * next encryption "key" & "IV" for pool regeneration
  */
-#define SSI_IVPOOL_META_SIZE (CC_AES_IV_SIZE + AES_KEYSIZE_128)
-#define SSI_IVPOOL_GEN_SEQ_LEN	4
+#define CC_IVPOOL_META_SIZE (CC_AES_IV_SIZE + AES_KEYSIZE_128)
+#define CC_IVPOOL_GEN_SEQ_LEN	4
 
 /**
- * struct ssi_ivgen_ctx -IV pool generation context
+ * struct cc_ivgen_ctx -IV pool generation context
  * @pool:          the start address of the iv-pool resides in internal RAM
  * @ctr_key_dma:   address of pool's encryption key material in internal RAM
  * @ctr_iv_dma:    address of pool's counter iv in internal RAM
@@ -40,7 +40,7 @@
  * @pool_meta:     virt. address of the initial enc. key/IV
  * @pool_meta_dma: phys. address of the initial enc. key/IV
  */
-struct ssi_ivgen_ctx {
+struct cc_ivgen_ctx {
 	ssi_sram_addr_t pool;
 	ssi_sram_addr_t ctr_key;
 	ssi_sram_addr_t ctr_iv;
@@ -50,21 +50,21 @@ struct ssi_ivgen_ctx {
 };
 
 /*!
- * Generates SSI_IVPOOL_SIZE of random bytes by
+ * Generates CC_IVPOOL_SIZE of random bytes by
  * encrypting 0's using AES128-CTR.
  *
  * \param ivgen iv-pool context
  * \param iv_seq IN/OUT array to the descriptors sequence
  * \param iv_seq_len IN/OUT pointer to the sequence length
  */
-static int ssi_ivgen_generate_pool(
-	struct ssi_ivgen_ctx *ivgen_ctx,
+static int cc_gen_iv_pool(
+	struct cc_ivgen_ctx *ivgen_ctx,
 	struct cc_hw_desc iv_seq[],
 	unsigned int *iv_seq_len)
 {
 	unsigned int idx = *iv_seq_len;
 
-	if ((*iv_seq_len + SSI_IVPOOL_GEN_SEQ_LEN) > SSI_IVPOOL_SEQ_LEN) {
+	if ((*iv_seq_len + CC_IVPOOL_GEN_SEQ_LEN) > SSI_IVPOOL_SEQ_LEN) {
 		/* The sequence will be longer than allowed */
 		return -EINVAL;
 	}
@@ -97,15 +97,15 @@ static int ssi_ivgen_generate_pool(
 
 	/* Generate IV pool */
 	hw_desc_init(&iv_seq[idx]);
-	set_din_const(&iv_seq[idx], 0, SSI_IVPOOL_SIZE);
-	set_dout_sram(&iv_seq[idx], ivgen_ctx->pool, SSI_IVPOOL_SIZE);
+	set_din_const(&iv_seq[idx], 0, CC_IVPOOL_SIZE);
+	set_dout_sram(&iv_seq[idx], ivgen_ctx->pool, CC_IVPOOL_SIZE);
 	set_flow_mode(&iv_seq[idx], DIN_AES_DOUT);
 	idx++;
 
 	*iv_seq_len = idx; /* Update sequence length */
 
 	/* queue ordering assures pool readiness */
-	ivgen_ctx->next_iv_ofs = SSI_IVPOOL_META_SIZE;
+	ivgen_ctx->next_iv_ofs = CC_IVPOOL_META_SIZE;
 
 	return 0;
 }
@@ -118,15 +118,15 @@ static int ssi_ivgen_generate_pool(
  *
  * \return int Zero for success, negative value otherwise.
  */
-int ssi_ivgen_init_sram_pool(struct ssi_drvdata *drvdata)
+int cc_init_iv_sram(struct ssi_drvdata *drvdata)
 {
-	struct ssi_ivgen_ctx *ivgen_ctx = drvdata->ivgen_handle;
+	struct cc_ivgen_ctx *ivgen_ctx = drvdata->ivgen_handle;
 	struct cc_hw_desc iv_seq[SSI_IVPOOL_SEQ_LEN];
 	unsigned int iv_seq_len = 0;
 	int rc;
 
 	/* Generate initial enc. key/iv */
-	get_random_bytes(ivgen_ctx->pool_meta, SSI_IVPOOL_META_SIZE);
+	get_random_bytes(ivgen_ctx->pool_meta, CC_IVPOOL_META_SIZE);
 
 	/* The first 32B reserved for the enc. Key/IV */
 	ivgen_ctx->ctr_key = ivgen_ctx->pool;
@@ -135,14 +135,14 @@ int ssi_ivgen_init_sram_pool(struct ssi_drvdata *drvdata)
 	/* Copy initial enc. key and IV to SRAM at a single descriptor */
 	hw_desc_init(&iv_seq[iv_seq_len]);
 	set_din_type(&iv_seq[iv_seq_len], DMA_DLLI, ivgen_ctx->pool_meta_dma,
-		     SSI_IVPOOL_META_SIZE, NS_BIT);
+		     CC_IVPOOL_META_SIZE, NS_BIT);
 	set_dout_sram(&iv_seq[iv_seq_len], ivgen_ctx->pool,
-		      SSI_IVPOOL_META_SIZE);
+		      CC_IVPOOL_META_SIZE);
 	set_flow_mode(&iv_seq[iv_seq_len], BYPASS);
 	iv_seq_len++;
 
 	/* Generate initial pool */
-	rc = ssi_ivgen_generate_pool(ivgen_ctx, iv_seq, &iv_seq_len);
+	rc = cc_gen_iv_pool(ivgen_ctx, iv_seq, &iv_seq_len);
 	if (rc)
 		return rc;
 
@@ -155,17 +155,17 @@ int ssi_ivgen_init_sram_pool(struct ssi_drvdata *drvdata)
  *
  * \param drvdata
  */
-void ssi_ivgen_fini(struct ssi_drvdata *drvdata)
+void cc_ivgen_fini(struct ssi_drvdata *drvdata)
 {
-	struct ssi_ivgen_ctx *ivgen_ctx = drvdata->ivgen_handle;
+	struct cc_ivgen_ctx *ivgen_ctx = drvdata->ivgen_handle;
 	struct device *device = &drvdata->plat_dev->dev;
 
 	if (!ivgen_ctx)
 		return;
 
 	if (ivgen_ctx->pool_meta) {
-		memset(ivgen_ctx->pool_meta, 0, SSI_IVPOOL_META_SIZE);
-		dma_free_coherent(device, SSI_IVPOOL_META_SIZE,
+		memset(ivgen_ctx->pool_meta, 0, CC_IVPOOL_META_SIZE);
+		dma_free_coherent(device, CC_IVPOOL_META_SIZE,
 				  ivgen_ctx->pool_meta,
 				  ivgen_ctx->pool_meta_dma);
 	}
@@ -184,9 +184,9 @@ void ssi_ivgen_fini(struct ssi_drvdata *drvdata)
  *
  * \return int Zero for success, negative value otherwise.
  */
-int ssi_ivgen_init(struct ssi_drvdata *drvdata)
+int cc_ivgen_init(struct ssi_drvdata *drvdata)
 {
-	struct ssi_ivgen_ctx *ivgen_ctx;
+	struct cc_ivgen_ctx *ivgen_ctx;
 	struct device *device = &drvdata->plat_dev->dev;
 	int rc;
 
@@ -199,27 +199,27 @@ int ssi_ivgen_init(struct ssi_drvdata *drvdata)
 	ivgen_ctx = drvdata->ivgen_handle;
 
 	/* Allocate pool's header for initial enc. key/IV */
-	ivgen_ctx->pool_meta = dma_alloc_coherent(device, SSI_IVPOOL_META_SIZE,
+	ivgen_ctx->pool_meta = dma_alloc_coherent(device, CC_IVPOOL_META_SIZE,
 						  &ivgen_ctx->pool_meta_dma,
 						  GFP_KERNEL);
 	if (!ivgen_ctx->pool_meta) {
 		dev_err(device, "Not enough memory to allocate DMA of pool_meta (%u B)\n",
-			SSI_IVPOOL_META_SIZE);
+			CC_IVPOOL_META_SIZE);
 		rc = -ENOMEM;
 		goto out;
 	}
 	/* Allocate IV pool in SRAM */
-	ivgen_ctx->pool = cc_sram_alloc(drvdata, SSI_IVPOOL_SIZE);
+	ivgen_ctx->pool = cc_sram_alloc(drvdata, CC_IVPOOL_SIZE);
 	if (ivgen_ctx->pool == NULL_SRAM_ADDR) {
 		dev_err(device, "SRAM pool exhausted\n");
 		rc = -ENOMEM;
 		goto out;
 	}
 
-	return ssi_ivgen_init_sram_pool(drvdata);
+	return cc_init_iv_sram(drvdata);
 
 out:
-	ssi_ivgen_fini(drvdata);
+	cc_ivgen_fini(drvdata);
 	return rc;
 }
 
@@ -236,7 +236,7 @@ int ssi_ivgen_init(struct ssi_drvdata *drvdata)
  *
  * \return int Zero for success, negative value otherwise.
  */
-int ssi_ivgen_getiv(
+int cc_get_iv(
 	struct ssi_drvdata *drvdata,
 	dma_addr_t iv_out_dma[],
 	unsigned int iv_out_dma_len,
@@ -244,7 +244,7 @@ int ssi_ivgen_getiv(
 	struct cc_hw_desc iv_seq[],
 	unsigned int *iv_seq_len)
 {
-	struct ssi_ivgen_ctx *ivgen_ctx = drvdata->ivgen_handle;
+	struct cc_ivgen_ctx *ivgen_ctx = drvdata->ivgen_handle;
 	unsigned int idx = *iv_seq_len;
 	struct device *dev = drvdata_to_dev(drvdata);
 	unsigned int t;
@@ -291,10 +291,10 @@ int ssi_ivgen_getiv(
 	/* Update iv index */
 	ivgen_ctx->next_iv_ofs += iv_out_size;
 
-	if ((SSI_IVPOOL_SIZE - ivgen_ctx->next_iv_ofs) < CC_AES_IV_SIZE) {
+	if ((CC_IVPOOL_SIZE - ivgen_ctx->next_iv_ofs) < CC_AES_IV_SIZE) {
 		dev_dbg(dev, "Pool exhausted, regenerating iv-pool\n");
 		/* pool is drained -regenerate it! */
-		return ssi_ivgen_generate_pool(ivgen_ctx, iv_seq, iv_seq_len);
+		return cc_gen_iv_pool(ivgen_ctx, iv_seq, iv_seq_len);
 	}
 
 	return 0;
diff --git a/drivers/staging/ccree/ssi_ivgen.h b/drivers/staging/ccree/ssi_ivgen.h
index fd28309..fe3d919 100644
--- a/drivers/staging/ccree/ssi_ivgen.h
+++ b/drivers/staging/ccree/ssi_ivgen.h
@@ -29,14 +29,14 @@
  *
  * \return int Zero for success, negative value otherwise.
  */
-int ssi_ivgen_init(struct ssi_drvdata *drvdata);
+int cc_ivgen_init(struct ssi_drvdata *drvdata);
 
 /*!
  * Free iv-pool and ivgen context.
  *
  * \param drvdata
  */
-void ssi_ivgen_fini(struct ssi_drvdata *drvdata);
+void cc_ivgen_fini(struct ssi_drvdata *drvdata);
 
 /*!
  * Generates the initial pool in SRAM.
@@ -46,7 +46,7 @@ void ssi_ivgen_fini(struct ssi_drvdata *drvdata);
  *
  * \return int Zero for success, negative value otherwise.
  */
-int ssi_ivgen_init_sram_pool(struct ssi_drvdata *drvdata);
+int cc_init_iv_sram(struct ssi_drvdata *drvdata);
 
 /*!
  * Acquires 16 Bytes IV from the iv-pool
@@ -61,7 +61,7 @@ int ssi_ivgen_init_sram_pool(struct ssi_drvdata *drvdata);
  *
  * \return int Zero for success, negative value otherwise.
  */
-int ssi_ivgen_getiv(
+int cc_get_iv(
 	struct ssi_drvdata *drvdata,
 	dma_addr_t iv_out_dma[],
 	unsigned int iv_out_dma_len,
diff --git a/drivers/staging/ccree/ssi_pm.c b/drivers/staging/ccree/ssi_pm.c
index d1a6318..f0e3baf 100644
--- a/drivers/staging/ccree/ssi_pm.c
+++ b/drivers/staging/ccree/ssi_pm.c
@@ -81,7 +81,7 @@ int cc_pm_resume(struct device *dev)
 	/* must be after the queue resuming as it uses the HW queue*/
 	cc_init_hash_sram(drvdata);
 
-	ssi_ivgen_init_sram_pool(drvdata);
+	cc_init_iv_sram(drvdata);
 	return 0;
 }
 
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index 91f5e2d..3d25b72 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -329,9 +329,10 @@ int send_request(struct ssi_drvdata *drvdata, struct ssi_crypto_req *ssi_req,
 			ssi_req->ivgen_size);
 
 		/* Acquire IV from pool */
-		rc = ssi_ivgen_getiv(drvdata, ssi_req->ivgen_dma_addr,
-				     ssi_req->ivgen_dma_addr_len,
-				     ssi_req->ivgen_size, iv_seq, &iv_seq_len);
+		rc = cc_get_iv(drvdata, ssi_req->ivgen_dma_addr,
+			       ssi_req->ivgen_dma_addr_len,
+			       ssi_req->ivgen_size,
+			       iv_seq, &iv_seq_len);
 
 		if (rc) {
 			dev_err(dev, "Failed to generate IV (rc=%d)\n", rc);
-- 
2.7.4
