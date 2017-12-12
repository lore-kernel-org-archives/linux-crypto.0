From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 01/24] staging: ccree: remove ahash wrappers
Date: Tue, 12 Dec 2017 14:52:47 +0000
Message-ID: <1513090395-7938-2-git-send-email-gilad@benyossef.com>
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

Remove a no longer needed abstraction around ccree hash crypto API
internals that used to allow same ops to be used in synchronous and
asynchronous fashion.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_hash.c | 260 ++++++++++++---------------------------
 1 file changed, 76 insertions(+), 184 deletions(-)

diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 0c4f3db..a762eef 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -426,13 +426,15 @@ static void ssi_hash_complete(struct device *dev, void *ssi_req)
 	req->base.complete(&req->base, 0);
 }
 
-static int ssi_hash_digest(struct ahash_req_ctx *state,
-			   struct ssi_hash_ctx *ctx,
-			   unsigned int digestsize,
-			   struct scatterlist *src,
-			   unsigned int nbytes, u8 *result,
-			   void *async_req)
+static int ssi_ahash_digest(struct ahash_request *req)
 {
+	struct ahash_req_ctx *state = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	u32 digestsize = crypto_ahash_digestsize(tfm);
+	struct scatterlist *src = req->src;
+	unsigned int nbytes = req->nbytes;
+	u8 *result = req->result;
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	bool is_hmac = ctx->is_hmac;
 	struct ssi_crypto_req ssi_req = {};
@@ -460,11 +462,9 @@ static int ssi_hash_digest(struct ahash_req_ctx *state,
 		return -ENOMEM;
 	}
 
-	if (async_req) {
-		/* Setup DX request structure */
-		ssi_req.user_cb = (void *)ssi_hash_digest_complete;
-		ssi_req.user_arg = (void *)async_req;
-	}
+	/* Setup DX request structure */
+	ssi_req.user_cb = ssi_hash_digest_complete;
+	ssi_req.user_arg = req;
 
 	/* If HMAC then load hash IPAD xor key, if HASH then load initial
 	 * digest
@@ -563,44 +563,32 @@ ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
 	set_cipher_mode(&desc[idx], ctx->hw_mode);
 	/* TODO */
 	set_dout_dlli(&desc[idx], state->digest_result_dma_addr, digestsize,
-		      NS_BIT, (async_req ? 1 : 0));
-	if (async_req)
-		set_queue_last_ind(&desc[idx]);
+		      NS_BIT, 1);
+	set_queue_last_ind(&desc[idx]);
 	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
 	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
 	set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
 	ssi_set_hash_endianity(ctx->hash_mode, &desc[idx]);
 	idx++;
 
-	if (async_req) {
-		rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
-		if (rc != -EINPROGRESS) {
-			dev_err(dev, "send_request() failed (rc=%d)\n", rc);
-			cc_unmap_hash_request(dev, state, src, true);
-			ssi_hash_unmap_result(dev, state, digestsize, result);
-			ssi_hash_unmap_request(dev, state, ctx);
-		}
-	} else {
-		rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 0);
-		if (rc) {
-			dev_err(dev, "send_request() failed (rc=%d)\n", rc);
-			cc_unmap_hash_request(dev, state, src, true);
-		} else {
-			cc_unmap_hash_request(dev, state, src, false);
-		}
+	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
+	if (rc != -EINPROGRESS) {
+		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
+		cc_unmap_hash_request(dev, state, src, true);
 		ssi_hash_unmap_result(dev, state, digestsize, result);
 		ssi_hash_unmap_request(dev, state, ctx);
 	}
 	return rc;
 }
 
-static int ssi_hash_update(struct ahash_req_ctx *state,
-			   struct ssi_hash_ctx *ctx,
-			   unsigned int block_size,
-			   struct scatterlist *src,
-			   unsigned int nbytes,
-			   void *async_req)
+static int ssi_ahash_update(struct ahash_request *req)
 {
+	struct ahash_req_ctx *state = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	unsigned int block_size = crypto_tfm_alg_blocksize(&tfm->base);
+	struct scatterlist *src = req->src;
+	unsigned int nbytes = req->nbytes;
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	struct ssi_crypto_req ssi_req = {};
 	struct cc_hw_desc desc[SSI_MAX_AHASH_SEQ_LEN];
@@ -628,11 +616,9 @@ static int ssi_hash_update(struct ahash_req_ctx *state,
 		return -ENOMEM;
 	}
 
-	if (async_req) {
-		/* Setup DX request structure */
-		ssi_req.user_cb = (void *)ssi_hash_update_complete;
-		ssi_req.user_arg = async_req;
-	}
+	/* Setup DX request structure */
+	ssi_req.user_cb = ssi_hash_update_complete;
+	ssi_req.user_arg = req;
 
 	/* Restore hash digest */
 	hw_desc_init(&desc[idx]);
@@ -666,39 +652,29 @@ static int ssi_hash_update(struct ahash_req_ctx *state,
 	hw_desc_init(&desc[idx]);
 	set_cipher_mode(&desc[idx], ctx->hw_mode);
 	set_dout_dlli(&desc[idx], state->digest_bytes_len_dma_addr,
-		      HASH_LEN_SIZE, NS_BIT, (async_req ? 1 : 0));
-	if (async_req)
-		set_queue_last_ind(&desc[idx]);
+		      HASH_LEN_SIZE, NS_BIT, 1);
+	set_queue_last_ind(&desc[idx]);
 	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
 	set_setup_mode(&desc[idx], SETUP_WRITE_STATE1);
 	idx++;
 
-	if (async_req) {
-		rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
-		if (rc != -EINPROGRESS) {
-			dev_err(dev, "send_request() failed (rc=%d)\n", rc);
-			cc_unmap_hash_request(dev, state, src, true);
-		}
-	} else {
-		rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 0);
-		if (rc) {
-			dev_err(dev, "send_request() failed (rc=%d)\n", rc);
-			cc_unmap_hash_request(dev, state, src, true);
-		} else {
-			cc_unmap_hash_request(dev, state, src, false);
-		}
+	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
+	if (rc != -EINPROGRESS) {
+		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
+		cc_unmap_hash_request(dev, state, src, true);
 	}
 	return rc;
 }
 
-static int ssi_hash_finup(struct ahash_req_ctx *state,
-			  struct ssi_hash_ctx *ctx,
-			  unsigned int digestsize,
-			  struct scatterlist *src,
-			  unsigned int nbytes,
-			  u8 *result,
-			  void *async_req)
+static int ssi_ahash_finup(struct ahash_request *req)
 {
+	struct ahash_req_ctx *state = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	u32 digestsize = crypto_ahash_digestsize(tfm);
+	struct scatterlist *src = req->src;
+	unsigned int nbytes = req->nbytes;
+	u8 *result = req->result;
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	bool is_hmac = ctx->is_hmac;
 	struct ssi_crypto_req ssi_req = {};
@@ -718,11 +694,9 @@ static int ssi_hash_finup(struct ahash_req_ctx *state,
 		return -ENOMEM;
 	}
 
-	if (async_req) {
-		/* Setup DX request structure */
-		ssi_req.user_cb = (void *)ssi_hash_complete;
-		ssi_req.user_arg = async_req;
-	}
+	/* Setup DX request structure */
+	ssi_req.user_cb = ssi_hash_complete;
+	ssi_req.user_arg = req;
 
 	/* Restore hash digest */
 	hw_desc_init(&desc[idx]);
@@ -794,9 +768,8 @@ ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
 	hw_desc_init(&desc[idx]);
 	/* TODO */
 	set_dout_dlli(&desc[idx], state->digest_result_dma_addr, digestsize,
-		      NS_BIT, (async_req ? 1 : 0));
-	if (async_req)
-		set_queue_last_ind(&desc[idx]);
+		      NS_BIT, 1);
+	set_queue_last_ind(&desc[idx]);
 	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
 	set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
 	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
@@ -804,36 +777,24 @@ ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
 	set_cipher_mode(&desc[idx], ctx->hw_mode);
 	idx++;
 
-	if (async_req) {
-		rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
-		if (rc != -EINPROGRESS) {
-			dev_err(dev, "send_request() failed (rc=%d)\n", rc);
-			cc_unmap_hash_request(dev, state, src, true);
-			ssi_hash_unmap_result(dev, state, digestsize, result);
-		}
-	} else {
-		rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 0);
-		if (rc) {
-			dev_err(dev, "send_request() failed (rc=%d)\n", rc);
-			cc_unmap_hash_request(dev, state, src, true);
-			ssi_hash_unmap_result(dev, state, digestsize, result);
-		} else {
-			cc_unmap_hash_request(dev, state, src, false);
-			ssi_hash_unmap_result(dev, state, digestsize, result);
-			ssi_hash_unmap_request(dev, state, ctx);
-		}
+	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
+	if (rc != -EINPROGRESS) {
+		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
+		cc_unmap_hash_request(dev, state, src, true);
+		ssi_hash_unmap_result(dev, state, digestsize, result);
 	}
 	return rc;
 }
 
-static int ssi_hash_final(struct ahash_req_ctx *state,
-			  struct ssi_hash_ctx *ctx,
-			  unsigned int digestsize,
-			  struct scatterlist *src,
-			  unsigned int nbytes,
-			  u8 *result,
-			  void *async_req)
+static int ssi_ahash_final(struct ahash_request *req)
 {
+	struct ahash_req_ctx *state = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	u32 digestsize = crypto_ahash_digestsize(tfm);
+	struct scatterlist *src = req->src;
+	unsigned int nbytes = req->nbytes;
+	u8 *result = req->result;
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	bool is_hmac = ctx->is_hmac;
 	struct ssi_crypto_req ssi_req = {};
@@ -854,11 +815,9 @@ static int ssi_hash_final(struct ahash_req_ctx *state,
 		return -ENOMEM;
 	}
 
-	if (async_req) {
-		/* Setup DX request structure */
-		ssi_req.user_cb = (void *)ssi_hash_complete;
-		ssi_req.user_arg = async_req;
-	}
+	/* Setup DX request structure */
+	ssi_req.user_cb = ssi_hash_complete;
+	ssi_req.user_arg = req;
 
 	/* Restore hash digest */
 	hw_desc_init(&desc[idx]);
@@ -939,9 +898,8 @@ ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
 	/* Get final MAC result */
 	hw_desc_init(&desc[idx]);
 	set_dout_dlli(&desc[idx], state->digest_result_dma_addr, digestsize,
-		      NS_BIT, (async_req ? 1 : 0));
-	if (async_req)
-		set_queue_last_ind(&desc[idx]);
+		      NS_BIT, 1);
+	set_queue_last_ind(&desc[idx]);
 	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
 	set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
 	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
@@ -949,34 +907,25 @@ ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
 	set_cipher_mode(&desc[idx], ctx->hw_mode);
 	idx++;
 
-	if (async_req) {
-		rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
-		if (rc != -EINPROGRESS) {
-			dev_err(dev, "send_request() failed (rc=%d)\n", rc);
-			cc_unmap_hash_request(dev, state, src, true);
-			ssi_hash_unmap_result(dev, state, digestsize, result);
-		}
-	} else {
-		rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 0);
-		if (rc) {
-			dev_err(dev, "send_request() failed (rc=%d)\n", rc);
-			cc_unmap_hash_request(dev, state, src, true);
-			ssi_hash_unmap_result(dev, state, digestsize, result);
-		} else {
-			cc_unmap_hash_request(dev, state, src, false);
-			ssi_hash_unmap_result(dev, state, digestsize, result);
-			ssi_hash_unmap_request(dev, state, ctx);
-		}
+	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
+	if (rc != -EINPROGRESS) {
+		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
+		cc_unmap_hash_request(dev, state, src, true);
+		ssi_hash_unmap_result(dev, state, digestsize, result);
 	}
 	return rc;
 }
 
-static int ssi_hash_init(struct ahash_req_ctx *state, struct ssi_hash_ctx *ctx)
+static int ssi_ahash_init(struct ahash_request *req)
 {
+	struct ahash_req_ctx *state = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 
-	state->xcbc_count = 0;
+	dev_dbg(dev, "===== init (%d) ====\n", req->nbytes);
 
+	state->xcbc_count = 0;
 	ssi_hash_map_request(dev, state, ctx);
 
 	return 0;
@@ -1713,63 +1662,6 @@ static int ssi_mac_digest(struct ahash_request *req)
 	return rc;
 }
 
-//ahash wrap functions
-static int ssi_ahash_digest(struct ahash_request *req)
-{
-	struct ahash_req_ctx *state = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
-	u32 digestsize = crypto_ahash_digestsize(tfm);
-
-	return ssi_hash_digest(state, ctx, digestsize, req->src, req->nbytes,
-			       req->result, (void *)req);
-}
-
-static int ssi_ahash_update(struct ahash_request *req)
-{
-	struct ahash_req_ctx *state = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
-	unsigned int block_size = crypto_tfm_alg_blocksize(&tfm->base);
-
-	return ssi_hash_update(state, ctx, block_size, req->src, req->nbytes,
-			       (void *)req);
-}
-
-static int ssi_ahash_finup(struct ahash_request *req)
-{
-	struct ahash_req_ctx *state = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
-	u32 digestsize = crypto_ahash_digestsize(tfm);
-
-	return ssi_hash_finup(state, ctx, digestsize, req->src, req->nbytes,
-			      req->result, (void *)req);
-}
-
-static int ssi_ahash_final(struct ahash_request *req)
-{
-	struct ahash_req_ctx *state = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
-	u32 digestsize = crypto_ahash_digestsize(tfm);
-
-	return ssi_hash_final(state, ctx, digestsize, req->src, req->nbytes,
-			      req->result, (void *)req);
-}
-
-static int ssi_ahash_init(struct ahash_request *req)
-{
-	struct ahash_req_ctx *state = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-
-	dev_dbg(dev, "===== init (%d) ====\n", req->nbytes);
-
-	return ssi_hash_init(state, ctx);
-}
-
 static int ssi_ahash_export(struct ahash_request *req, void *out)
 {
 	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
@@ -1829,7 +1721,7 @@ static int ssi_ahash_import(struct ahash_request *req, const void *in)
 
 	/* call init() to allocate bufs if the user hasn't */
 	if (!state->digest_buff) {
-		rc = ssi_hash_init(state, ctx);
+		rc = ssi_ahash_init(req);
 		if (rc)
 			goto out;
 	}
-- 
2.7.4
