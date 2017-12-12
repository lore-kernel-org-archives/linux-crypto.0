From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 02/24] staging: ccree: fix hash naming convention
Date: Tue, 12 Dec 2017 14:52:48 +0000
Message-ID: <1513090395-7938-3-git-send-email-gilad@benyossef.com>
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

The hash files were using a naming convention which was inconsistent
(ssi vs. cc), included a useless prefix (ssi_hash) and often used too
long function names producing monster such as
ssi_ahash_get_initial_digest_len_sram_addr() that made the call site
hard to read.

Make the code more readable by switching to a simpler, consistent naming
convention for the file.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c   |  10 +-
 drivers/staging/ccree/ssi_driver.c |   8 +-
 drivers/staging/ccree/ssi_hash.c   | 494 ++++++++++++++++++-------------------
 drivers/staging/ccree/ssi_hash.h   |  16 +-
 drivers/staging/ccree/ssi_pm.c     |   2 +-
 5 files changed, 257 insertions(+), 273 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 5548c7b..408ea24 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -1023,10 +1023,8 @@ static void cc_set_hmac_desc(struct aead_request *req, struct cc_hw_desc desc[],
 	/* Load init. digest len (64 bytes) */
 	hw_desc_init(&desc[idx]);
 	set_cipher_mode(&desc[idx], hash_mode);
-	set_din_sram(&desc[idx],
-		     ssi_ahash_get_initial_digest_len_sram_addr(ctx->drvdata,
-								hash_mode),
-								HASH_LEN_SIZE);
+	set_din_sram(&desc[idx], cc_digest_len_addr(ctx->drvdata, hash_mode),
+		     HASH_LEN_SIZE);
 	set_flow_mode(&desc[idx], S_DIN_to_HASH);
 	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 	idx++;
@@ -1152,9 +1150,7 @@ static void cc_proc_scheme_desc(struct aead_request *req,
 	/* Load init. digest len (64 bytes) */
 	hw_desc_init(&desc[idx]);
 	set_cipher_mode(&desc[idx], hash_mode);
-	set_din_sram(&desc[idx],
-		     ssi_ahash_get_initial_digest_len_sram_addr(ctx->drvdata,
-								hash_mode),
+	set_din_sram(&desc[idx], cc_digest_len_addr(ctx->drvdata, hash_mode),
 		     HASH_LEN_SIZE);
 	set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
 	set_flow_mode(&desc[idx], S_DIN_to_HASH);
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index a0d8eb8..513c5e4 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -358,9 +358,9 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	}
 
 	/* hash must be allocated before aead since hash exports APIs */
-	rc = ssi_hash_alloc(new_drvdata);
+	rc = cc_hash_alloc(new_drvdata);
 	if (rc) {
-		dev_err(dev, "ssi_hash_alloc failed\n");
+		dev_err(dev, "cc_hash_alloc failed\n");
 		goto post_cipher_err;
 	}
 
@@ -379,7 +379,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	return 0;
 
 post_hash_err:
-	ssi_hash_free(new_drvdata);
+	cc_hash_free(new_drvdata);
 post_cipher_err:
 	ssi_ablkcipher_free(new_drvdata);
 post_ivgen_err:
@@ -417,7 +417,7 @@ static void cleanup_cc_resources(struct platform_device *plat_dev)
 		(struct ssi_drvdata *)platform_get_drvdata(plat_dev);
 
 	cc_aead_free(drvdata);
-	ssi_hash_free(drvdata);
+	cc_hash_free(drvdata);
 	ssi_ablkcipher_free(drvdata);
 	ssi_ivgen_fini(drvdata);
 	cc_pm_fini(drvdata);
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index a762eef..6bc42e4 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -31,10 +31,10 @@
 #include "ssi_hash.h"
 #include "ssi_sram_mgr.h"
 
-#define SSI_MAX_AHASH_SEQ_LEN 12
-#define SSI_MAX_OPAD_KEYS_SIZE SSI_MAX_HASH_BLCK_SIZE
+#define CC_MAX_HASH_SEQ_LEN 12
+#define CC_MAX_OPAD_KEYS_SIZE CC_MAX_HASH_BLCK_SIZE
 
-struct ssi_hash_handle {
+struct cc_hash_handle {
 	ssi_sram_addr_t digest_len_sram_addr; /* const value in SRAM*/
 	ssi_sram_addr_t larval_digest_sram_addr;   /* const value in SRAM */
 	struct list_head hash_list;
@@ -64,16 +64,15 @@ static const u64 sha512_init[] = {
 	SHA512_H3, SHA512_H2, SHA512_H1, SHA512_H0 };
 #endif
 
-static void ssi_hash_create_xcbc_setup(
+static void cc_setup_xcbc(
 	struct ahash_request *areq,
 	struct cc_hw_desc desc[],
 	unsigned int *seq_size);
 
-static void ssi_hash_create_cmac_setup(struct ahash_request *areq,
-				       struct cc_hw_desc desc[],
-				       unsigned int *seq_size);
+static void cc_setup_cmac(struct ahash_request *areq, struct cc_hw_desc desc[],
+			  unsigned int *seq_size);
 
-struct ssi_hash_alg {
+struct cc_hash_alg {
 	struct list_head entry;
 	int hash_mode;
 	int hw_mode;
@@ -88,13 +87,13 @@ struct hash_key_req_ctx {
 };
 
 /* hash per-session context */
-struct ssi_hash_ctx {
+struct cc_hash_ctx {
 	struct ssi_drvdata *drvdata;
 	/* holds the origin digest; the digest after "setkey" if HMAC,*
 	 * the initial digest if HASH.
 	 */
-	u8 digest_buff[SSI_MAX_HASH_DIGEST_SIZE]  ____cacheline_aligned;
-	u8 opad_tmp_keys_buff[SSI_MAX_OPAD_KEYS_SIZE]  ____cacheline_aligned;
+	u8 digest_buff[CC_MAX_HASH_DIGEST_SIZE]  ____cacheline_aligned;
+	u8 opad_tmp_keys_buff[CC_MAX_OPAD_KEYS_SIZE]  ____cacheline_aligned;
 
 	dma_addr_t opad_tmp_keys_dma_addr  ____cacheline_aligned;
 	dma_addr_t digest_buff_dma_addr;
@@ -107,14 +106,14 @@ struct ssi_hash_ctx {
 	bool is_hmac;
 };
 
-static void ssi_hash_create_data_desc(
+static void cc_set_desc(
 	struct ahash_req_ctx *areq_ctx,
-	struct ssi_hash_ctx *ctx,
+	struct cc_hash_ctx *ctx,
 	unsigned int flow_mode, struct cc_hw_desc desc[],
 	bool is_not_last_data,
 	unsigned int *seq_size);
 
-static void ssi_set_hash_endianity(u32 mode, struct cc_hw_desc *desc)
+static void cc_set_endianity(u32 mode, struct cc_hw_desc *desc)
 {
 	if (mode == DRV_HASH_MD5 || mode == DRV_HASH_SHA384 ||
 	    mode == DRV_HASH_SHA512) {
@@ -124,9 +123,8 @@ static void ssi_set_hash_endianity(u32 mode, struct cc_hw_desc *desc)
 	}
 }
 
-static int ssi_hash_map_result(struct device *dev,
-			       struct ahash_req_ctx *state,
-			       unsigned int digestsize)
+static int cc_map_result(struct device *dev, struct ahash_req_ctx *state,
+			 unsigned int digestsize)
 {
 	state->digest_result_dma_addr =
 		dma_map_single(dev, (void *)state->digest_result_buff,
@@ -144,9 +142,8 @@ static int ssi_hash_map_result(struct device *dev,
 	return 0;
 }
 
-static int ssi_hash_map_request(struct device *dev,
-				struct ahash_req_ctx *state,
-				struct ssi_hash_ctx *ctx)
+static int cc_map_req(struct device *dev, struct ahash_req_ctx *state,
+		      struct cc_hash_ctx *ctx)
 {
 	bool is_hmac = ctx->is_hmac;
 	ssi_sram_addr_t larval_digest_addr =
@@ -155,15 +152,15 @@ static int ssi_hash_map_request(struct device *dev,
 	struct cc_hw_desc desc;
 	int rc = -ENOMEM;
 
-	state->buff0 = kzalloc(SSI_MAX_HASH_BLCK_SIZE, GFP_KERNEL | GFP_DMA);
+	state->buff0 = kzalloc(CC_MAX_HASH_BLCK_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!state->buff0)
 		goto fail0;
 
-	state->buff1 = kzalloc(SSI_MAX_HASH_BLCK_SIZE, GFP_KERNEL | GFP_DMA);
+	state->buff1 = kzalloc(CC_MAX_HASH_BLCK_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!state->buff1)
 		goto fail_buff0;
 
-	state->digest_result_buff = kzalloc(SSI_MAX_HASH_DIGEST_SIZE,
+	state->digest_result_buff = kzalloc(CC_MAX_HASH_DIGEST_SIZE,
 					    GFP_KERNEL | GFP_DMA);
 	if (!state->digest_result_buff)
 		goto fail_buff1;
@@ -330,9 +327,8 @@ static int ssi_hash_map_request(struct device *dev,
 	return rc;
 }
 
-static void ssi_hash_unmap_request(struct device *dev,
-				   struct ahash_req_ctx *state,
-				   struct ssi_hash_ctx *ctx)
+static void cc_unmap_req(struct device *dev, struct ahash_req_ctx *state,
+			 struct cc_hash_ctx *ctx)
 {
 	if (state->digest_buff_dma_addr) {
 		dma_unmap_single(dev, state->digest_buff_dma_addr,
@@ -364,9 +360,8 @@ static void ssi_hash_unmap_request(struct device *dev,
 	kfree(state->buff0);
 }
 
-static void ssi_hash_unmap_result(struct device *dev,
-				  struct ahash_req_ctx *state,
-				  unsigned int digestsize, u8 *result)
+static void cc_unmap_result(struct device *dev, struct ahash_req_ctx *state,
+			    unsigned int digestsize, u8 *result)
 {
 	if (state->digest_result_dma_addr) {
 		dma_unmap_single(dev,
@@ -383,7 +378,7 @@ static void ssi_hash_unmap_result(struct device *dev,
 	state->digest_result_dma_addr = 0;
 }
 
-static void ssi_hash_update_complete(struct device *dev, void *ssi_req)
+static void cc_update_complete(struct device *dev, void *ssi_req)
 {
 	struct ahash_request *req = (struct ahash_request *)ssi_req;
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
@@ -394,43 +389,43 @@ static void ssi_hash_update_complete(struct device *dev, void *ssi_req)
 	req->base.complete(&req->base, 0);
 }
 
-static void ssi_hash_digest_complete(struct device *dev, void *ssi_req)
+static void cc_digest_complete(struct device *dev, void *ssi_req)
 {
 	struct ahash_request *req = (struct ahash_request *)ssi_req;
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	u32 digestsize = crypto_ahash_digestsize(tfm);
 
 	dev_dbg(dev, "req=%pK\n", req);
 
 	cc_unmap_hash_request(dev, state, req->src, false);
-	ssi_hash_unmap_result(dev, state, digestsize, req->result);
-	ssi_hash_unmap_request(dev, state, ctx);
+	cc_unmap_result(dev, state, digestsize, req->result);
+	cc_unmap_req(dev, state, ctx);
 	req->base.complete(&req->base, 0);
 }
 
-static void ssi_hash_complete(struct device *dev, void *ssi_req)
+static void cc_hash_complete(struct device *dev, void *ssi_req)
 {
 	struct ahash_request *req = (struct ahash_request *)ssi_req;
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	u32 digestsize = crypto_ahash_digestsize(tfm);
 
 	dev_dbg(dev, "req=%pK\n", req);
 
 	cc_unmap_hash_request(dev, state, req->src, false);
-	ssi_hash_unmap_result(dev, state, digestsize, req->result);
-	ssi_hash_unmap_request(dev, state, ctx);
+	cc_unmap_result(dev, state, digestsize, req->result);
+	cc_unmap_req(dev, state, ctx);
 	req->base.complete(&req->base, 0);
 }
 
-static int ssi_ahash_digest(struct ahash_request *req)
+static int cc_hash_digest(struct ahash_request *req)
 {
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	u32 digestsize = crypto_ahash_digestsize(tfm);
 	struct scatterlist *src = req->src;
 	unsigned int nbytes = req->nbytes;
@@ -438,7 +433,7 @@ static int ssi_ahash_digest(struct ahash_request *req)
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	bool is_hmac = ctx->is_hmac;
 	struct ssi_crypto_req ssi_req = {};
-	struct cc_hw_desc desc[SSI_MAX_AHASH_SEQ_LEN];
+	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
 	ssi_sram_addr_t larval_digest_addr =
 		cc_larval_digest_addr(ctx->drvdata, ctx->hash_mode);
 	int idx = 0;
@@ -447,12 +442,12 @@ static int ssi_ahash_digest(struct ahash_request *req)
 	dev_dbg(dev, "===== %s-digest (%d) ====\n", is_hmac ? "hmac" : "hash",
 		nbytes);
 
-	if (ssi_hash_map_request(dev, state, ctx)) {
+	if (cc_map_req(dev, state, ctx)) {
 		dev_err(dev, "map_ahash_source() failed\n");
 		return -ENOMEM;
 	}
 
-	if (ssi_hash_map_result(dev, state, digestsize)) {
+	if (cc_map_result(dev, state, digestsize)) {
 		dev_err(dev, "map_ahash_digest() failed\n");
 		return -ENOMEM;
 	}
@@ -463,7 +458,7 @@ static int ssi_ahash_digest(struct ahash_request *req)
 	}
 
 	/* Setup DX request structure */
-	ssi_req.user_cb = ssi_hash_digest_complete;
+	ssi_req.user_cb = cc_digest_complete;
 	ssi_req.user_arg = req;
 
 	/* If HMAC then load hash IPAD xor key, if HASH then load initial
@@ -501,7 +496,7 @@ static int ssi_ahash_digest(struct ahash_request *req)
 	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 	idx++;
 
-	ssi_hash_create_data_desc(state, ctx, DIN_HASH, desc, false, &idx);
+	cc_set_desc(state, ctx, DIN_HASH, desc, false, &idx);
 
 	if (is_hmac) {
 		/* HW last hash block padding (aka. "DO_PAD") */
@@ -520,7 +515,7 @@ static int ssi_ahash_digest(struct ahash_request *req)
 		set_dout_dlli(&desc[idx], state->digest_buff_dma_addr,
 			      digestsize, NS_BIT, 0);
 		set_flow_mode(&desc[idx], S_HASH_to_DOUT);
-		ssi_set_hash_endianity(ctx->hash_mode, &desc[idx]);
+		cc_set_endianity(ctx->hash_mode, &desc[idx]);
 		set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
 		idx++;
 
@@ -537,8 +532,8 @@ static int ssi_ahash_digest(struct ahash_request *req)
 		hw_desc_init(&desc[idx]);
 		set_cipher_mode(&desc[idx], ctx->hw_mode);
 		set_din_sram(&desc[idx],
-			     ssi_ahash_get_initial_digest_len_sram_addr(
-ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
+			     cc_digest_len_addr(ctx->drvdata, ctx->hash_mode),
+			     HASH_LEN_SIZE);
 		set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
 		set_flow_mode(&desc[idx], S_DIN_to_HASH);
 		set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
@@ -568,30 +563,30 @@ ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
 	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
 	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
 	set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
-	ssi_set_hash_endianity(ctx->hash_mode, &desc[idx]);
+	cc_set_endianity(ctx->hash_mode, &desc[idx]);
 	idx++;
 
 	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
 	if (rc != -EINPROGRESS) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, src, true);
-		ssi_hash_unmap_result(dev, state, digestsize, result);
-		ssi_hash_unmap_request(dev, state, ctx);
+		cc_unmap_result(dev, state, digestsize, result);
+		cc_unmap_req(dev, state, ctx);
 	}
 	return rc;
 }
 
-static int ssi_ahash_update(struct ahash_request *req)
+static int cc_hash_update(struct ahash_request *req)
 {
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	unsigned int block_size = crypto_tfm_alg_blocksize(&tfm->base);
 	struct scatterlist *src = req->src;
 	unsigned int nbytes = req->nbytes;
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	struct ssi_crypto_req ssi_req = {};
-	struct cc_hw_desc desc[SSI_MAX_AHASH_SEQ_LEN];
+	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
 	u32 idx = 0;
 	int rc;
 
@@ -617,7 +612,7 @@ static int ssi_ahash_update(struct ahash_request *req)
 	}
 
 	/* Setup DX request structure */
-	ssi_req.user_cb = ssi_hash_update_complete;
+	ssi_req.user_cb = cc_update_complete;
 	ssi_req.user_arg = req;
 
 	/* Restore hash digest */
@@ -637,7 +632,7 @@ static int ssi_ahash_update(struct ahash_request *req)
 	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 	idx++;
 
-	ssi_hash_create_data_desc(state, ctx, DIN_HASH, desc, false, &idx);
+	cc_set_desc(state, ctx, DIN_HASH, desc, false, &idx);
 
 	/* store the hash digest result in context */
 	hw_desc_init(&desc[idx]);
@@ -666,11 +661,11 @@ static int ssi_ahash_update(struct ahash_request *req)
 	return rc;
 }
 
-static int ssi_ahash_finup(struct ahash_request *req)
+static int cc_hash_finup(struct ahash_request *req)
 {
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	u32 digestsize = crypto_ahash_digestsize(tfm);
 	struct scatterlist *src = req->src;
 	unsigned int nbytes = req->nbytes;
@@ -678,7 +673,7 @@ static int ssi_ahash_finup(struct ahash_request *req)
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	bool is_hmac = ctx->is_hmac;
 	struct ssi_crypto_req ssi_req = {};
-	struct cc_hw_desc desc[SSI_MAX_AHASH_SEQ_LEN];
+	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
 	int idx = 0;
 	int rc;
 
@@ -689,13 +684,13 @@ static int ssi_ahash_finup(struct ahash_request *req)
 		dev_err(dev, "map_ahash_request_final() failed\n");
 		return -ENOMEM;
 	}
-	if (ssi_hash_map_result(dev, state, digestsize)) {
+	if (cc_map_result(dev, state, digestsize)) {
 		dev_err(dev, "map_ahash_digest() failed\n");
 		return -ENOMEM;
 	}
 
 	/* Setup DX request structure */
-	ssi_req.user_cb = ssi_hash_complete;
+	ssi_req.user_cb = cc_hash_complete;
 	ssi_req.user_arg = req;
 
 	/* Restore hash digest */
@@ -717,7 +712,7 @@ static int ssi_ahash_finup(struct ahash_request *req)
 	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 	idx++;
 
-	ssi_hash_create_data_desc(state, ctx, DIN_HASH, desc, false, &idx);
+	cc_set_desc(state, ctx, DIN_HASH, desc, false, &idx);
 
 	if (is_hmac) {
 		/* Store the hash digest result in the context */
@@ -725,7 +720,7 @@ static int ssi_ahash_finup(struct ahash_request *req)
 		set_cipher_mode(&desc[idx], ctx->hw_mode);
 		set_dout_dlli(&desc[idx], state->digest_buff_dma_addr,
 			      digestsize, NS_BIT, 0);
-		ssi_set_hash_endianity(ctx->hash_mode, &desc[idx]);
+		cc_set_endianity(ctx->hash_mode, &desc[idx]);
 		set_flow_mode(&desc[idx], S_HASH_to_DOUT);
 		set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
 		idx++;
@@ -743,8 +738,8 @@ static int ssi_ahash_finup(struct ahash_request *req)
 		hw_desc_init(&desc[idx]);
 		set_cipher_mode(&desc[idx], ctx->hw_mode);
 		set_din_sram(&desc[idx],
-			     ssi_ahash_get_initial_digest_len_sram_addr(
-ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
+			     cc_digest_len_addr(ctx->drvdata, ctx->hash_mode),
+			     HASH_LEN_SIZE);
 		set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
 		set_flow_mode(&desc[idx], S_DIN_to_HASH);
 		set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
@@ -773,7 +768,7 @@ ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
 	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
 	set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
 	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
-	ssi_set_hash_endianity(ctx->hash_mode, &desc[idx]);
+	cc_set_endianity(ctx->hash_mode, &desc[idx]);
 	set_cipher_mode(&desc[idx], ctx->hw_mode);
 	idx++;
 
@@ -781,16 +776,16 @@ ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
 	if (rc != -EINPROGRESS) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, src, true);
-		ssi_hash_unmap_result(dev, state, digestsize, result);
+		cc_unmap_result(dev, state, digestsize, result);
 	}
 	return rc;
 }
 
-static int ssi_ahash_final(struct ahash_request *req)
+static int cc_hash_final(struct ahash_request *req)
 {
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	u32 digestsize = crypto_ahash_digestsize(tfm);
 	struct scatterlist *src = req->src;
 	unsigned int nbytes = req->nbytes;
@@ -798,7 +793,7 @@ static int ssi_ahash_final(struct ahash_request *req)
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	bool is_hmac = ctx->is_hmac;
 	struct ssi_crypto_req ssi_req = {};
-	struct cc_hw_desc desc[SSI_MAX_AHASH_SEQ_LEN];
+	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
 	int idx = 0;
 	int rc;
 
@@ -810,13 +805,13 @@ static int ssi_ahash_final(struct ahash_request *req)
 		return -ENOMEM;
 	}
 
-	if (ssi_hash_map_result(dev, state, digestsize)) {
+	if (cc_map_result(dev, state, digestsize)) {
 		dev_err(dev, "map_ahash_digest() failed\n");
 		return -ENOMEM;
 	}
 
 	/* Setup DX request structure */
-	ssi_req.user_cb = ssi_hash_complete;
+	ssi_req.user_cb = cc_hash_complete;
 	ssi_req.user_arg = req;
 
 	/* Restore hash digest */
@@ -838,7 +833,7 @@ static int ssi_ahash_final(struct ahash_request *req)
 	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 	idx++;
 
-	ssi_hash_create_data_desc(state, ctx, DIN_HASH, desc, false, &idx);
+	cc_set_desc(state, ctx, DIN_HASH, desc, false, &idx);
 
 	/* "DO-PAD" must be enabled only when writing current length to HW */
 	hw_desc_init(&desc[idx]);
@@ -856,7 +851,7 @@ static int ssi_ahash_final(struct ahash_request *req)
 		set_cipher_mode(&desc[idx], ctx->hw_mode);
 		set_dout_dlli(&desc[idx], state->digest_buff_dma_addr,
 			      digestsize, NS_BIT, 0);
-		ssi_set_hash_endianity(ctx->hash_mode, &desc[idx]);
+		cc_set_endianity(ctx->hash_mode, &desc[idx]);
 		set_flow_mode(&desc[idx], S_HASH_to_DOUT);
 		set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
 		idx++;
@@ -874,8 +869,8 @@ static int ssi_ahash_final(struct ahash_request *req)
 		hw_desc_init(&desc[idx]);
 		set_cipher_mode(&desc[idx], ctx->hw_mode);
 		set_din_sram(&desc[idx],
-			     ssi_ahash_get_initial_digest_len_sram_addr(
-ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
+			     cc_digest_len_addr(ctx->drvdata, ctx->hash_mode),
+			     HASH_LEN_SIZE);
 		set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
 		set_flow_mode(&desc[idx], S_DIN_to_HASH);
 		set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
@@ -903,7 +898,7 @@ ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
 	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
 	set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
 	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
-	ssi_set_hash_endianity(ctx->hash_mode, &desc[idx]);
+	cc_set_endianity(ctx->hash_mode, &desc[idx]);
 	set_cipher_mode(&desc[idx], ctx->hw_mode);
 	idx++;
 
@@ -911,36 +906,36 @@ ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
 	if (rc != -EINPROGRESS) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, src, true);
-		ssi_hash_unmap_result(dev, state, digestsize, result);
+		cc_unmap_result(dev, state, digestsize, result);
 	}
 	return rc;
 }
 
-static int ssi_ahash_init(struct ahash_request *req)
+static int cc_hash_init(struct ahash_request *req)
 {
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 
 	dev_dbg(dev, "===== init (%d) ====\n", req->nbytes);
 
 	state->xcbc_count = 0;
-	ssi_hash_map_request(dev, state, ctx);
+	cc_map_req(dev, state, ctx);
 
 	return 0;
 }
 
-static int ssi_ahash_setkey(struct crypto_ahash *ahash, const u8 *key,
-			    unsigned int keylen)
+static int cc_hash_setkey(struct crypto_ahash *ahash, const u8 *key,
+			  unsigned int keylen)
 {
 	unsigned int hmac_pad_const[2] = { HMAC_IPAD_CONST, HMAC_OPAD_CONST };
 	struct ssi_crypto_req ssi_req = {};
-	struct ssi_hash_ctx *ctx = NULL;
+	struct cc_hash_ctx *ctx = NULL;
 	int blocksize = 0;
 	int digestsize = 0;
 	int i, idx = 0, rc = 0;
-	struct cc_hw_desc desc[SSI_MAX_AHASH_SEQ_LEN];
+	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
 	ssi_sram_addr_t larval_addr;
 	struct device *dev;
 
@@ -1006,7 +1001,7 @@ static int ssi_ahash_setkey(struct crypto_ahash *ahash, const u8 *key,
 			set_flow_mode(&desc[idx], S_HASH_to_DOUT);
 			set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
 			set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
-			ssi_set_hash_endianity(ctx->hash_mode, &desc[idx]);
+			cc_set_endianity(ctx->hash_mode, &desc[idx]);
 			idx++;
 
 			hw_desc_init(&desc[idx]);
@@ -1120,14 +1115,14 @@ static int ssi_ahash_setkey(struct crypto_ahash *ahash, const u8 *key,
 	return rc;
 }
 
-static int ssi_xcbc_setkey(struct crypto_ahash *ahash,
-			   const u8 *key, unsigned int keylen)
+static int cc_xcbc_setkey(struct crypto_ahash *ahash,
+			  const u8 *key, unsigned int keylen)
 {
 	struct ssi_crypto_req ssi_req = {};
-	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(ahash);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	int idx = 0, rc = 0;
-	struct cc_hw_desc desc[SSI_MAX_AHASH_SEQ_LEN];
+	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
 
 	dev_dbg(dev, "===== setkey (%d) ====\n", keylen);
 
@@ -1203,10 +1198,10 @@ static int ssi_xcbc_setkey(struct crypto_ahash *ahash,
 }
 
 #if SSI_CC_HAS_CMAC
-static int ssi_cmac_setkey(struct crypto_ahash *ahash,
-			   const u8 *key, unsigned int keylen)
+static int cc_cmac_setkey(struct crypto_ahash *ahash,
+			  const u8 *key, unsigned int keylen)
 {
-	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(ahash);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 
 	dev_dbg(dev, "===== setkey (%d) ====\n", keylen);
@@ -1244,7 +1239,7 @@ static int ssi_cmac_setkey(struct crypto_ahash *ahash,
 }
 #endif
 
-static void ssi_hash_free_ctx(struct ssi_hash_ctx *ctx)
+static void cc_free_ctx(struct cc_hash_ctx *ctx)
 {
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 
@@ -1267,7 +1262,7 @@ static void ssi_hash_free_ctx(struct ssi_hash_ctx *ctx)
 	ctx->key_params.keylen = 0;
 }
 
-static int ssi_hash_alloc_ctx(struct ssi_hash_ctx *ctx)
+static int cc_alloc_ctx(struct cc_hash_ctx *ctx)
 {
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 
@@ -1303,19 +1298,19 @@ static int ssi_hash_alloc_ctx(struct ssi_hash_ctx *ctx)
 	return 0;
 
 fail:
-	ssi_hash_free_ctx(ctx);
+	cc_free_ctx(ctx);
 	return -ENOMEM;
 }
 
-static int ssi_ahash_cra_init(struct crypto_tfm *tfm)
+static int cc_cra_init(struct crypto_tfm *tfm)
 {
-	struct ssi_hash_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct cc_hash_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct hash_alg_common *hash_alg_common =
 		container_of(tfm->__crt_alg, struct hash_alg_common, base);
 	struct ahash_alg *ahash_alg =
 		container_of(hash_alg_common, struct ahash_alg, halg);
-	struct ssi_hash_alg *ssi_alg =
-			container_of(ahash_alg, struct ssi_hash_alg,
+	struct cc_hash_alg *ssi_alg =
+			container_of(ahash_alg, struct cc_hash_alg,
 				     ahash_alg);
 
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
@@ -1326,27 +1321,27 @@ static int ssi_ahash_cra_init(struct crypto_tfm *tfm)
 	ctx->inter_digestsize = ssi_alg->inter_digestsize;
 	ctx->drvdata = ssi_alg->drvdata;
 
-	return ssi_hash_alloc_ctx(ctx);
+	return cc_alloc_ctx(ctx);
 }
 
-static void ssi_hash_cra_exit(struct crypto_tfm *tfm)
+static void cc_cra_exit(struct crypto_tfm *tfm)
 {
-	struct ssi_hash_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct cc_hash_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 
-	dev_dbg(dev, "ssi_hash_cra_exit");
-	ssi_hash_free_ctx(ctx);
+	dev_dbg(dev, "cc_cra_exit");
+	cc_free_ctx(ctx);
 }
 
-static int ssi_mac_update(struct ahash_request *req)
+static int cc_mac_update(struct ahash_request *req)
 {
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	unsigned int block_size = crypto_tfm_alg_blocksize(&tfm->base);
 	struct ssi_crypto_req ssi_req = {};
-	struct cc_hw_desc desc[SSI_MAX_AHASH_SEQ_LEN];
+	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
 	int rc;
 	u32 idx = 0;
 
@@ -1371,11 +1366,11 @@ static int ssi_mac_update(struct ahash_request *req)
 	}
 
 	if (ctx->hw_mode == DRV_CIPHER_XCBC_MAC)
-		ssi_hash_create_xcbc_setup(req, desc, &idx);
+		cc_setup_xcbc(req, desc, &idx);
 	else
-		ssi_hash_create_cmac_setup(req, desc, &idx);
+		cc_setup_cmac(req, desc, &idx);
 
-	ssi_hash_create_data_desc(state, ctx, DIN_AES_DOUT, desc, true, &idx);
+	cc_set_desc(state, ctx, DIN_AES_DOUT, desc, true, &idx);
 
 	/* store the hash digest result in context */
 	hw_desc_init(&desc[idx]);
@@ -1388,7 +1383,7 @@ static int ssi_mac_update(struct ahash_request *req)
 	idx++;
 
 	/* Setup DX request structure */
-	ssi_req.user_cb = (void *)ssi_hash_update_complete;
+	ssi_req.user_cb = (void *)cc_update_complete;
 	ssi_req.user_arg = (void *)req;
 
 	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
@@ -1399,14 +1394,14 @@ static int ssi_mac_update(struct ahash_request *req)
 	return rc;
 }
 
-static int ssi_mac_final(struct ahash_request *req)
+static int cc_mac_final(struct ahash_request *req)
 {
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	struct ssi_crypto_req ssi_req = {};
-	struct cc_hw_desc desc[SSI_MAX_AHASH_SEQ_LEN];
+	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
 	int idx = 0;
 	int rc = 0;
 	u32 key_size, key_len;
@@ -1432,13 +1427,13 @@ static int ssi_mac_final(struct ahash_request *req)
 		return -ENOMEM;
 	}
 
-	if (ssi_hash_map_result(dev, state, digestsize)) {
+	if (cc_map_result(dev, state, digestsize)) {
 		dev_err(dev, "map_ahash_digest() failed\n");
 		return -ENOMEM;
 	}
 
 	/* Setup DX request structure */
-	ssi_req.user_cb = (void *)ssi_hash_complete;
+	ssi_req.user_cb = (void *)cc_hash_complete;
 	ssi_req.user_arg = (void *)req;
 
 	if (state->xcbc_count && rem_cnt == 0) {
@@ -1473,9 +1468,9 @@ static int ssi_mac_final(struct ahash_request *req)
 	}
 
 	if (ctx->hw_mode == DRV_CIPHER_XCBC_MAC)
-		ssi_hash_create_xcbc_setup(req, desc, &idx);
+		cc_setup_xcbc(req, desc, &idx);
 	else
-		ssi_hash_create_cmac_setup(req, desc, &idx);
+		cc_setup_cmac(req, desc, &idx);
 
 	if (state->xcbc_count == 0) {
 		hw_desc_init(&desc[idx]);
@@ -1485,8 +1480,7 @@ static int ssi_mac_final(struct ahash_request *req)
 		set_flow_mode(&desc[idx], S_DIN_to_AES);
 		idx++;
 	} else if (rem_cnt > 0) {
-		ssi_hash_create_data_desc(state, ctx, DIN_AES_DOUT, desc,
-					  false, &idx);
+		cc_set_desc(state, ctx, DIN_AES_DOUT, desc, false, &idx);
 	} else {
 		hw_desc_init(&desc[idx]);
 		set_din_const(&desc[idx], 0x00, CC_AES_BLOCK_SIZE);
@@ -1509,19 +1503,19 @@ static int ssi_mac_final(struct ahash_request *req)
 	if (rc != -EINPROGRESS) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, req->src, true);
-		ssi_hash_unmap_result(dev, state, digestsize, req->result);
+		cc_unmap_result(dev, state, digestsize, req->result);
 	}
 	return rc;
 }
 
-static int ssi_mac_finup(struct ahash_request *req)
+static int cc_mac_finup(struct ahash_request *req)
 {
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	struct ssi_crypto_req ssi_req = {};
-	struct cc_hw_desc desc[SSI_MAX_AHASH_SEQ_LEN];
+	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
 	int idx = 0;
 	int rc = 0;
 	u32 key_len = 0;
@@ -1530,7 +1524,7 @@ static int ssi_mac_finup(struct ahash_request *req)
 	dev_dbg(dev, "===== finup xcbc(%d) ====\n", req->nbytes);
 	if (state->xcbc_count > 0 && req->nbytes == 0) {
 		dev_dbg(dev, "No data to update. Call to fdx_mac_final\n");
-		return ssi_mac_final(req);
+		return cc_mac_final(req);
 	}
 
 	if (cc_map_hash_request_final(ctx->drvdata, state, req->src,
@@ -1538,21 +1532,21 @@ static int ssi_mac_finup(struct ahash_request *req)
 		dev_err(dev, "map_ahash_request_final() failed\n");
 		return -ENOMEM;
 	}
-	if (ssi_hash_map_result(dev, state, digestsize)) {
+	if (cc_map_result(dev, state, digestsize)) {
 		dev_err(dev, "map_ahash_digest() failed\n");
 		return -ENOMEM;
 	}
 
 	/* Setup DX request structure */
-	ssi_req.user_cb = (void *)ssi_hash_complete;
+	ssi_req.user_cb = (void *)cc_hash_complete;
 	ssi_req.user_arg = (void *)req;
 
 	if (ctx->hw_mode == DRV_CIPHER_XCBC_MAC) {
 		key_len = CC_AES_128_BIT_KEY_SIZE;
-		ssi_hash_create_xcbc_setup(req, desc, &idx);
+		cc_setup_xcbc(req, desc, &idx);
 	} else {
 		key_len = ctx->key_params.keylen;
-		ssi_hash_create_cmac_setup(req, desc, &idx);
+		cc_setup_cmac(req, desc, &idx);
 	}
 
 	if (req->nbytes == 0) {
@@ -1563,8 +1557,7 @@ static int ssi_mac_finup(struct ahash_request *req)
 		set_flow_mode(&desc[idx], S_DIN_to_AES);
 		idx++;
 	} else {
-		ssi_hash_create_data_desc(state, ctx, DIN_AES_DOUT, desc,
-					  false, &idx);
+		cc_set_desc(state, ctx, DIN_AES_DOUT, desc, false, &idx);
 	}
 
 	/* Get final MAC result */
@@ -1582,31 +1575,31 @@ static int ssi_mac_finup(struct ahash_request *req)
 	if (rc != -EINPROGRESS) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, req->src, true);
-		ssi_hash_unmap_result(dev, state, digestsize, req->result);
+		cc_unmap_result(dev, state, digestsize, req->result);
 	}
 	return rc;
 }
 
-static int ssi_mac_digest(struct ahash_request *req)
+static int cc_mac_digest(struct ahash_request *req)
 {
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	u32 digestsize = crypto_ahash_digestsize(tfm);
 	struct ssi_crypto_req ssi_req = {};
-	struct cc_hw_desc desc[SSI_MAX_AHASH_SEQ_LEN];
+	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
 	u32 key_len;
 	int idx = 0;
 	int rc;
 
 	dev_dbg(dev, "===== -digest mac (%d) ====\n",  req->nbytes);
 
-	if (ssi_hash_map_request(dev, state, ctx)) {
+	if (cc_map_req(dev, state, ctx)) {
 		dev_err(dev, "map_ahash_source() failed\n");
 		return -ENOMEM;
 	}
-	if (ssi_hash_map_result(dev, state, digestsize)) {
+	if (cc_map_result(dev, state, digestsize)) {
 		dev_err(dev, "map_ahash_digest() failed\n");
 		return -ENOMEM;
 	}
@@ -1618,15 +1611,15 @@ static int ssi_mac_digest(struct ahash_request *req)
 	}
 
 	/* Setup DX request structure */
-	ssi_req.user_cb = (void *)ssi_hash_digest_complete;
+	ssi_req.user_cb = (void *)cc_digest_complete;
 	ssi_req.user_arg = (void *)req;
 
 	if (ctx->hw_mode == DRV_CIPHER_XCBC_MAC) {
 		key_len = CC_AES_128_BIT_KEY_SIZE;
-		ssi_hash_create_xcbc_setup(req, desc, &idx);
+		cc_setup_xcbc(req, desc, &idx);
 	} else {
 		key_len = ctx->key_params.keylen;
-		ssi_hash_create_cmac_setup(req, desc, &idx);
+		cc_setup_cmac(req, desc, &idx);
 	}
 
 	if (req->nbytes == 0) {
@@ -1637,8 +1630,7 @@ static int ssi_mac_digest(struct ahash_request *req)
 		set_flow_mode(&desc[idx], S_DIN_to_AES);
 		idx++;
 	} else {
-		ssi_hash_create_data_desc(state, ctx, DIN_AES_DOUT, desc,
-					  false, &idx);
+		cc_set_desc(state, ctx, DIN_AES_DOUT, desc, false, &idx);
 	}
 
 	/* Get final MAC result */
@@ -1656,16 +1648,16 @@ static int ssi_mac_digest(struct ahash_request *req)
 	if (rc != -EINPROGRESS) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, req->src, true);
-		ssi_hash_unmap_result(dev, state, digestsize, req->result);
-		ssi_hash_unmap_request(dev, state, ctx);
+		cc_unmap_result(dev, state, digestsize, req->result);
+		cc_unmap_req(dev, state, ctx);
 	}
 	return rc;
 }
 
-static int ssi_ahash_export(struct ahash_request *req, void *out)
+static int cc_hash_export(struct ahash_request *req, void *out)
 {
 	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
-	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(ahash);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
 	u8 *curr_buff = state->buff_index ? state->buff1 : state->buff0;
@@ -1703,10 +1695,10 @@ static int ssi_ahash_export(struct ahash_request *req, void *out)
 	return 0;
 }
 
-static int ssi_ahash_import(struct ahash_request *req, const void *in)
+static int cc_hash_import(struct ahash_request *req, const void *in)
 {
 	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
-	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(ahash);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
 	u32 tmp;
@@ -1721,7 +1713,7 @@ static int ssi_ahash_import(struct ahash_request *req, const void *in)
 
 	/* call init() to allocate bufs if the user hasn't */
 	if (!state->digest_buff) {
-		rc = ssi_ahash_init(req);
+		rc = cc_hash_init(req);
 		if (rc)
 			goto out;
 	}
@@ -1750,7 +1742,7 @@ static int ssi_ahash_import(struct ahash_request *req, const void *in)
 
 	/* Sanity check the data as much as possible */
 	memcpy(&tmp, in, sizeof(u32));
-	if (tmp > SSI_MAX_HASH_BLCK_SIZE) {
+	if (tmp > CC_MAX_HASH_BLCK_SIZE) {
 		rc = -EINVAL;
 		goto out;
 	}
@@ -1763,7 +1755,7 @@ static int ssi_ahash_import(struct ahash_request *req, const void *in)
 	return rc;
 }
 
-struct ssi_hash_template {
+struct cc_hash_template {
 	char name[CRYPTO_MAX_ALG_NAME];
 	char driver_name[CRYPTO_MAX_ALG_NAME];
 	char mac_name[CRYPTO_MAX_ALG_NAME];
@@ -1778,10 +1770,10 @@ struct ssi_hash_template {
 };
 
 #define CC_STATE_SIZE(_x) \
-	((_x) + HASH_LEN_SIZE + SSI_MAX_HASH_BLCK_SIZE + (2 * sizeof(u32)))
+	((_x) + HASH_LEN_SIZE + CC_MAX_HASH_BLCK_SIZE + (2 * sizeof(u32)))
 
 /* hash descriptors */
-static struct ssi_hash_template driver_hash[] = {
+static struct cc_hash_template driver_hash[] = {
 	//Asynchronize hash template
 	{
 		.name = "sha1",
@@ -1791,14 +1783,14 @@ static struct ssi_hash_template driver_hash[] = {
 		.blocksize = SHA1_BLOCK_SIZE,
 		.synchronize = false,
 		.template_ahash = {
-			.init = ssi_ahash_init,
-			.update = ssi_ahash_update,
-			.final = ssi_ahash_final,
-			.finup = ssi_ahash_finup,
-			.digest = ssi_ahash_digest,
-			.export = ssi_ahash_export,
-			.import = ssi_ahash_import,
-			.setkey = ssi_ahash_setkey,
+			.init = cc_hash_init,
+			.update = cc_hash_update,
+			.final = cc_hash_final,
+			.finup = cc_hash_finup,
+			.digest = cc_hash_digest,
+			.export = cc_hash_export,
+			.import = cc_hash_import,
+			.setkey = cc_hash_setkey,
 			.halg = {
 				.digestsize = SHA1_DIGEST_SIZE,
 				.statesize = CC_STATE_SIZE(SHA1_DIGEST_SIZE),
@@ -1815,14 +1807,14 @@ static struct ssi_hash_template driver_hash[] = {
 		.mac_driver_name = "hmac-sha256-dx",
 		.blocksize = SHA256_BLOCK_SIZE,
 		.template_ahash = {
-			.init = ssi_ahash_init,
-			.update = ssi_ahash_update,
-			.final = ssi_ahash_final,
-			.finup = ssi_ahash_finup,
-			.digest = ssi_ahash_digest,
-			.export = ssi_ahash_export,
-			.import = ssi_ahash_import,
-			.setkey = ssi_ahash_setkey,
+			.init = cc_hash_init,
+			.update = cc_hash_update,
+			.final = cc_hash_final,
+			.finup = cc_hash_finup,
+			.digest = cc_hash_digest,
+			.export = cc_hash_export,
+			.import = cc_hash_import,
+			.setkey = cc_hash_setkey,
 			.halg = {
 				.digestsize = SHA256_DIGEST_SIZE,
 				.statesize = CC_STATE_SIZE(SHA256_DIGEST_SIZE)
@@ -1839,14 +1831,14 @@ static struct ssi_hash_template driver_hash[] = {
 		.mac_driver_name = "hmac-sha224-dx",
 		.blocksize = SHA224_BLOCK_SIZE,
 		.template_ahash = {
-			.init = ssi_ahash_init,
-			.update = ssi_ahash_update,
-			.final = ssi_ahash_final,
-			.finup = ssi_ahash_finup,
-			.digest = ssi_ahash_digest,
-			.export = ssi_ahash_export,
-			.import = ssi_ahash_import,
-			.setkey = ssi_ahash_setkey,
+			.init = cc_hash_init,
+			.update = cc_hash_update,
+			.final = cc_hash_final,
+			.finup = cc_hash_finup,
+			.digest = cc_hash_digest,
+			.export = cc_hash_export,
+			.import = cc_hash_import,
+			.setkey = cc_hash_setkey,
 			.halg = {
 				.digestsize = SHA224_DIGEST_SIZE,
 				.statesize = CC_STATE_SIZE(SHA224_DIGEST_SIZE),
@@ -1864,14 +1856,14 @@ static struct ssi_hash_template driver_hash[] = {
 		.mac_driver_name = "hmac-sha384-dx",
 		.blocksize = SHA384_BLOCK_SIZE,
 		.template_ahash = {
-			.init = ssi_ahash_init,
-			.update = ssi_ahash_update,
-			.final = ssi_ahash_final,
-			.finup = ssi_ahash_finup,
-			.digest = ssi_ahash_digest,
-			.export = ssi_ahash_export,
-			.import = ssi_ahash_import,
-			.setkey = ssi_ahash_setkey,
+			.init = cc_hash_init,
+			.update = cc_hash_update,
+			.final = cc_hash_final,
+			.finup = cc_hash_finup,
+			.digest = cc_hash_digest,
+			.export = cc_hash_export,
+			.import = cc_hash_import,
+			.setkey = cc_hash_setkey,
 			.halg = {
 				.digestsize = SHA384_DIGEST_SIZE,
 				.statesize = CC_STATE_SIZE(SHA384_DIGEST_SIZE),
@@ -1888,14 +1880,14 @@ static struct ssi_hash_template driver_hash[] = {
 		.mac_driver_name = "hmac-sha512-dx",
 		.blocksize = SHA512_BLOCK_SIZE,
 		.template_ahash = {
-			.init = ssi_ahash_init,
-			.update = ssi_ahash_update,
-			.final = ssi_ahash_final,
-			.finup = ssi_ahash_finup,
-			.digest = ssi_ahash_digest,
-			.export = ssi_ahash_export,
-			.import = ssi_ahash_import,
-			.setkey = ssi_ahash_setkey,
+			.init = cc_hash_init,
+			.update = cc_hash_update,
+			.final = cc_hash_final,
+			.finup = cc_hash_finup,
+			.digest = cc_hash_digest,
+			.export = cc_hash_export,
+			.import = cc_hash_import,
+			.setkey = cc_hash_setkey,
 			.halg = {
 				.digestsize = SHA512_DIGEST_SIZE,
 				.statesize = CC_STATE_SIZE(SHA512_DIGEST_SIZE),
@@ -1913,14 +1905,14 @@ static struct ssi_hash_template driver_hash[] = {
 		.mac_driver_name = "hmac-md5-dx",
 		.blocksize = MD5_HMAC_BLOCK_SIZE,
 		.template_ahash = {
-			.init = ssi_ahash_init,
-			.update = ssi_ahash_update,
-			.final = ssi_ahash_final,
-			.finup = ssi_ahash_finup,
-			.digest = ssi_ahash_digest,
-			.export = ssi_ahash_export,
-			.import = ssi_ahash_import,
-			.setkey = ssi_ahash_setkey,
+			.init = cc_hash_init,
+			.update = cc_hash_update,
+			.final = cc_hash_final,
+			.finup = cc_hash_finup,
+			.digest = cc_hash_digest,
+			.export = cc_hash_export,
+			.import = cc_hash_import,
+			.setkey = cc_hash_setkey,
 			.halg = {
 				.digestsize = MD5_DIGEST_SIZE,
 				.statesize = CC_STATE_SIZE(MD5_DIGEST_SIZE),
@@ -1935,14 +1927,14 @@ static struct ssi_hash_template driver_hash[] = {
 		.mac_driver_name = "xcbc-aes-dx",
 		.blocksize = AES_BLOCK_SIZE,
 		.template_ahash = {
-			.init = ssi_ahash_init,
-			.update = ssi_mac_update,
-			.final = ssi_mac_final,
-			.finup = ssi_mac_finup,
-			.digest = ssi_mac_digest,
-			.setkey = ssi_xcbc_setkey,
-			.export = ssi_ahash_export,
-			.import = ssi_ahash_import,
+			.init = cc_hash_init,
+			.update = cc_mac_update,
+			.final = cc_mac_final,
+			.finup = cc_mac_finup,
+			.digest = cc_mac_digest,
+			.setkey = cc_xcbc_setkey,
+			.export = cc_hash_export,
+			.import = cc_hash_import,
 			.halg = {
 				.digestsize = AES_BLOCK_SIZE,
 				.statesize = CC_STATE_SIZE(AES_BLOCK_SIZE),
@@ -1958,14 +1950,14 @@ static struct ssi_hash_template driver_hash[] = {
 		.mac_driver_name = "cmac-aes-dx",
 		.blocksize = AES_BLOCK_SIZE,
 		.template_ahash = {
-			.init = ssi_ahash_init,
-			.update = ssi_mac_update,
-			.final = ssi_mac_final,
-			.finup = ssi_mac_finup,
-			.digest = ssi_mac_digest,
-			.setkey = ssi_cmac_setkey,
-			.export = ssi_ahash_export,
-			.import = ssi_ahash_import,
+			.init = cc_hash_init,
+			.update = cc_mac_update,
+			.final = cc_mac_final,
+			.finup = cc_mac_finup,
+			.digest = cc_mac_digest,
+			.setkey = cc_cmac_setkey,
+			.export = cc_hash_export,
+			.import = cc_hash_import,
 			.halg = {
 				.digestsize = AES_BLOCK_SIZE,
 				.statesize = CC_STATE_SIZE(AES_BLOCK_SIZE),
@@ -1979,11 +1971,11 @@ static struct ssi_hash_template driver_hash[] = {
 
 };
 
-static struct ssi_hash_alg *
-ssi_hash_create_alg(struct ssi_hash_template *template, struct device *dev,
-		    bool keyed)
+static struct cc_hash_alg *
+cc_alloc_hash_alg(struct cc_hash_template *template, struct device *dev,
+		  bool keyed)
 {
-	struct ssi_hash_alg *t_crypto_alg;
+	struct cc_hash_alg *t_crypto_alg;
 	struct crypto_alg *alg;
 	struct ahash_alg *halg;
 
@@ -2008,13 +2000,13 @@ ssi_hash_create_alg(struct ssi_hash_template *template, struct device *dev,
 			 template->driver_name);
 	}
 	alg->cra_module = THIS_MODULE;
-	alg->cra_ctxsize = sizeof(struct ssi_hash_ctx);
+	alg->cra_ctxsize = sizeof(struct cc_hash_ctx);
 	alg->cra_priority = SSI_CRA_PRIO;
 	alg->cra_blocksize = template->blocksize;
 	alg->cra_alignmask = 0;
-	alg->cra_exit = ssi_hash_cra_exit;
+	alg->cra_exit = cc_cra_exit;
 
-	alg->cra_init = ssi_ahash_cra_init;
+	alg->cra_init = cc_cra_init;
 	alg->cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_TYPE_AHASH |
 			CRYPTO_ALG_KERN_DRIVER_ONLY;
 	alg->cra_type = &crypto_ahash_type;
@@ -2026,9 +2018,9 @@ ssi_hash_create_alg(struct ssi_hash_template *template, struct device *dev,
 	return t_crypto_alg;
 }
 
-int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
+int cc_init_hash_sram(struct ssi_drvdata *drvdata)
 {
-	struct ssi_hash_handle *hash_handle = drvdata->hash_handle;
+	struct cc_hash_handle *hash_handle = drvdata->hash_handle;
 	ssi_sram_addr_t sram_buff_ofs = hash_handle->digest_len_sram_addr;
 	unsigned int larval_seq_len = 0;
 	struct cc_hw_desc larval_seq[CC_DIGEST_SIZE_MAX / sizeof(u32)];
@@ -2146,9 +2138,9 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 	return rc;
 }
 
-int ssi_hash_alloc(struct ssi_drvdata *drvdata)
+int cc_hash_alloc(struct ssi_drvdata *drvdata)
 {
-	struct ssi_hash_handle *hash_handle;
+	struct cc_hash_handle *hash_handle;
 	ssi_sram_addr_t sram_buff;
 	u32 sram_size_to_alloc;
 	struct device *dev = drvdata_to_dev(drvdata);
@@ -2184,7 +2176,7 @@ int ssi_hash_alloc(struct ssi_drvdata *drvdata)
 	hash_handle->digest_len_sram_addr = sram_buff;
 
 	/*must be set before the alg registration as it is being used there*/
-	rc = ssi_hash_init_sram_digest_consts(drvdata);
+	rc = cc_init_hash_sram(drvdata);
 	if (rc) {
 		dev_err(dev, "Init digest CONST failed (rc=%d)\n", rc);
 		goto fail;
@@ -2192,11 +2184,11 @@ int ssi_hash_alloc(struct ssi_drvdata *drvdata)
 
 	/* ahash registration */
 	for (alg = 0; alg < ARRAY_SIZE(driver_hash); alg++) {
-		struct ssi_hash_alg *t_alg;
+		struct cc_hash_alg *t_alg;
 		int hw_mode = driver_hash[alg].hw_mode;
 
 		/* register hmac version */
-		t_alg = ssi_hash_create_alg(&driver_hash[alg], dev, true);
+		t_alg = cc_alloc_hash_alg(&driver_hash[alg], dev, true);
 		if (IS_ERR(t_alg)) {
 			rc = PTR_ERR(t_alg);
 			dev_err(dev, "%s alg allocation failed\n",
@@ -2221,7 +2213,7 @@ int ssi_hash_alloc(struct ssi_drvdata *drvdata)
 			continue;
 
 		/* register hash version */
-		t_alg = ssi_hash_create_alg(&driver_hash[alg], dev, false);
+		t_alg = cc_alloc_hash_alg(&driver_hash[alg], dev, false);
 		if (IS_ERR(t_alg)) {
 			rc = PTR_ERR(t_alg);
 			dev_err(dev, "%s alg allocation failed\n",
@@ -2249,10 +2241,10 @@ int ssi_hash_alloc(struct ssi_drvdata *drvdata)
 	return rc;
 }
 
-int ssi_hash_free(struct ssi_drvdata *drvdata)
+int cc_hash_free(struct ssi_drvdata *drvdata)
 {
-	struct ssi_hash_alg *t_hash_alg, *hash_n;
-	struct ssi_hash_handle *hash_handle = drvdata->hash_handle;
+	struct cc_hash_alg *t_hash_alg, *hash_n;
+	struct cc_hash_handle *hash_handle = drvdata->hash_handle;
 
 	if (hash_handle) {
 		list_for_each_entry_safe(t_hash_alg, hash_n,
@@ -2268,14 +2260,13 @@ int ssi_hash_free(struct ssi_drvdata *drvdata)
 	return 0;
 }
 
-static void ssi_hash_create_xcbc_setup(struct ahash_request *areq,
-				       struct cc_hw_desc desc[],
-				       unsigned int *seq_size)
+static void cc_setup_xcbc(struct ahash_request *areq, struct cc_hw_desc desc[],
+			  unsigned int *seq_size)
 {
 	unsigned int idx = *seq_size;
 	struct ahash_req_ctx *state = ahash_request_ctx(areq);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
-	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 
 	/* Setup XCBC MAC K1 */
 	hw_desc_init(&desc[idx]);
@@ -2326,14 +2317,13 @@ static void ssi_hash_create_xcbc_setup(struct ahash_request *areq,
 	*seq_size = idx;
 }
 
-static void ssi_hash_create_cmac_setup(struct ahash_request *areq,
-				       struct cc_hw_desc desc[],
-				       unsigned int *seq_size)
+static void cc_setup_cmac(struct ahash_request *areq, struct cc_hw_desc desc[],
+			  unsigned int *seq_size)
 {
 	unsigned int idx = *seq_size;
 	struct ahash_req_ctx *state = ahash_request_ctx(areq);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
-	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 
 	/* Setup CMAC Key */
 	hw_desc_init(&desc[idx]);
@@ -2360,12 +2350,10 @@ static void ssi_hash_create_cmac_setup(struct ahash_request *areq,
 	*seq_size = idx;
 }
 
-static void ssi_hash_create_data_desc(struct ahash_req_ctx *areq_ctx,
-				      struct ssi_hash_ctx *ctx,
-				      unsigned int flow_mode,
-				      struct cc_hw_desc desc[],
-				      bool is_not_last_data,
-				      unsigned int *seq_size)
+static void cc_set_desc(struct ahash_req_ctx *areq_ctx,
+			struct cc_hash_ctx *ctx, unsigned int flow_mode,
+			struct cc_hw_desc desc[], bool is_not_last_data,
+			unsigned int *seq_size)
 {
 	unsigned int idx = *seq_size;
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
@@ -2418,7 +2406,7 @@ static void ssi_hash_create_data_desc(struct ahash_req_ctx *areq_ctx,
 ssi_sram_addr_t cc_larval_digest_addr(void *drvdata, u32 mode)
 {
 	struct ssi_drvdata *_drvdata = (struct ssi_drvdata *)drvdata;
-	struct ssi_hash_handle *hash_handle = _drvdata->hash_handle;
+	struct cc_hash_handle *hash_handle = _drvdata->hash_handle;
 	struct device *dev = drvdata_to_dev(_drvdata);
 
 	switch (mode) {
@@ -2462,10 +2450,10 @@ ssi_sram_addr_t cc_larval_digest_addr(void *drvdata, u32 mode)
 }
 
 ssi_sram_addr_t
-ssi_ahash_get_initial_digest_len_sram_addr(void *drvdata, u32 mode)
+cc_digest_len_addr(void *drvdata, u32 mode)
 {
 	struct ssi_drvdata *_drvdata = (struct ssi_drvdata *)drvdata;
-	struct ssi_hash_handle *hash_handle = _drvdata->hash_handle;
+	struct cc_hash_handle *hash_handle = _drvdata->hash_handle;
 	ssi_sram_addr_t digest_len_addr = hash_handle->digest_len_sram_addr;
 
 	switch (mode) {
diff --git a/drivers/staging/ccree/ssi_hash.h b/drivers/staging/ccree/ssi_hash.h
index 32eb473..ade4119 100644
--- a/drivers/staging/ccree/ssi_hash.h
+++ b/drivers/staging/ccree/ssi_hash.h
@@ -27,12 +27,12 @@
 #define HMAC_OPAD_CONST	0x5C5C5C5C
 #if (DX_DEV_SHA_MAX > 256)
 #define HASH_LEN_SIZE 16
-#define SSI_MAX_HASH_DIGEST_SIZE	SHA512_DIGEST_SIZE
-#define SSI_MAX_HASH_BLCK_SIZE SHA512_BLOCK_SIZE
+#define CC_MAX_HASH_DIGEST_SIZE	SHA512_DIGEST_SIZE
+#define CC_MAX_HASH_BLCK_SIZE SHA512_BLOCK_SIZE
 #else
 #define HASH_LEN_SIZE 8
-#define SSI_MAX_HASH_DIGEST_SIZE	SHA256_DIGEST_SIZE
-#define SSI_MAX_HASH_BLCK_SIZE SHA256_BLOCK_SIZE
+#define CC_MAX_HASH_DIGEST_SIZE	SHA256_DIGEST_SIZE
+#define CC_MAX_HASH_BLCK_SIZE SHA256_BLOCK_SIZE
 #endif
 
 #define XCBC_MAC_K1_OFFSET 0
@@ -75,9 +75,9 @@ struct ahash_req_ctx {
 	struct mlli_params mlli_params;
 };
 
-int ssi_hash_alloc(struct ssi_drvdata *drvdata);
-int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata);
-int ssi_hash_free(struct ssi_drvdata *drvdata);
+int cc_hash_alloc(struct ssi_drvdata *drvdata);
+int cc_init_hash_sram(struct ssi_drvdata *drvdata);
+int cc_hash_free(struct ssi_drvdata *drvdata);
 
 /*!
  * Gets the initial digest length
@@ -89,7 +89,7 @@ int ssi_hash_free(struct ssi_drvdata *drvdata);
  * \return u32 returns the address of the initial digest length in SRAM
  */
 ssi_sram_addr_t
-ssi_ahash_get_initial_digest_len_sram_addr(void *drvdata, u32 mode);
+cc_digest_len_addr(void *drvdata, u32 mode);
 
 /*!
  * Gets the address of the initial digest in SRAM
diff --git a/drivers/staging/ccree/ssi_pm.c b/drivers/staging/ccree/ssi_pm.c
index 5e2ef5e..d1a6318 100644
--- a/drivers/staging/ccree/ssi_pm.c
+++ b/drivers/staging/ccree/ssi_pm.c
@@ -79,7 +79,7 @@ int cc_pm_resume(struct device *dev)
 	}
 
 	/* must be after the queue resuming as it uses the HW queue*/
-	ssi_hash_init_sram_digest_consts(drvdata);
+	cc_init_hash_sram(drvdata);
 
 	ssi_ivgen_init_sram_pool(drvdata);
 	return 0;
-- 
2.7.4
