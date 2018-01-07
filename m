From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 19/27] staging: ccree: do not map bufs in ahash_init
Date: Sun,  7 Jan 2018 12:14:30 +0000
Message-ID: <1515327285-8948-20-git-send-email-gilad@benyossef.com>
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

hash_init was mapping DMA memory that were then being unmap in
hash_digest/final/finup callbacks, which is against the Crypto API
usage rules (see discussion at
https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg30077.html)

Fix it by moving all buffer mapping/unmapping or each Crypto API op.

This also properly deals with hash_import() not knowing if
hash_init was called or not as it now no longer matters.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_hash.c | 192 +++++++++++++++++++++------------------
 1 file changed, 103 insertions(+), 89 deletions(-)

diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index b557db2..1cc3fae 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -123,34 +123,20 @@ static int cc_map_result(struct device *dev, struct ahash_req_ctx *state,
 	return 0;
 }
 
-static int cc_map_req(struct device *dev, struct ahash_req_ctx *state,
-		      struct cc_hash_ctx *ctx, gfp_t flags)
+static void cc_init_req(struct device *dev, struct ahash_req_ctx *state,
+			struct cc_hash_ctx *ctx)
 {
 	bool is_hmac = ctx->is_hmac;
-	int rc = -ENOMEM;
 
 	memset(state, 0, sizeof(*state));
 
-	state->digest_buff_dma_addr =
-		dma_map_single(dev, state->digest_buff,
-			       ctx->inter_digestsize, DMA_BIDIRECTIONAL);
-	if (dma_mapping_error(dev, state->digest_buff_dma_addr)) {
-		dev_err(dev, "Mapping digest len %d B at va=%pK for DMA failed\n",
-			ctx->inter_digestsize, state->digest_buff);
-		goto fail0;
-	}
-	dev_dbg(dev, "Mapped digest %d B at va=%pK to dma=%pad\n",
-		ctx->inter_digestsize, state->digest_buff,
-		&state->digest_buff_dma_addr);
-
 	if (is_hmac) {
-		dma_sync_single_for_cpu(dev, ctx->digest_buff_dma_addr,
-					ctx->inter_digestsize,
-					DMA_BIDIRECTIONAL);
-		if (ctx->hw_mode == DRV_CIPHER_XCBC_MAC ||
-		    ctx->hw_mode == DRV_CIPHER_CMAC) {
-			memset(state->digest_buff, 0, ctx->inter_digestsize);
-		} else { /*sha*/
+		if (ctx->hw_mode != DRV_CIPHER_XCBC_MAC &&
+		    ctx->hw_mode != DRV_CIPHER_CMAC) {
+			dma_sync_single_for_cpu(dev, ctx->digest_buff_dma_addr,
+						ctx->inter_digestsize,
+						DMA_BIDIRECTIONAL);
+
 			memcpy(state->digest_buff, ctx->digest_buff,
 			       ctx->inter_digestsize);
 #if (CC_DEV_SHA_MAX > 256)
@@ -181,9 +167,24 @@ static int cc_map_req(struct device *dev, struct ahash_req_ctx *state,
 
 		memcpy(state->digest_buff, larval, ctx->inter_digestsize);
 	}
+}
 
-	dma_sync_single_for_device(dev, state->digest_buff_dma_addr,
-				   ctx->inter_digestsize, DMA_BIDIRECTIONAL);
+static int cc_map_req(struct device *dev, struct ahash_req_ctx *state,
+		      struct cc_hash_ctx *ctx)
+{
+	bool is_hmac = ctx->is_hmac;
+
+	state->digest_buff_dma_addr =
+		dma_map_single(dev, state->digest_buff,
+			       ctx->inter_digestsize, DMA_BIDIRECTIONAL);
+	if (dma_mapping_error(dev, state->digest_buff_dma_addr)) {
+		dev_err(dev, "Mapping digest len %d B at va=%pK for DMA failed\n",
+			ctx->inter_digestsize, state->digest_buff);
+		return -EINVAL;
+	}
+	dev_dbg(dev, "Mapped digest %d B at va=%pK to dma=%pad\n",
+		ctx->inter_digestsize, state->digest_buff,
+		&state->digest_buff_dma_addr);
 
 	if (ctx->hw_mode != DRV_CIPHER_XCBC_MAC) {
 		state->digest_bytes_len_dma_addr =
@@ -192,13 +193,11 @@ static int cc_map_req(struct device *dev, struct ahash_req_ctx *state,
 		if (dma_mapping_error(dev, state->digest_bytes_len_dma_addr)) {
 			dev_err(dev, "Mapping digest len %u B at va=%pK for DMA failed\n",
 				HASH_LEN_SIZE, state->digest_bytes_len);
-			goto fail4;
+			goto unmap_digest_buf;
 		}
 		dev_dbg(dev, "Mapped digest len %u B at va=%pK to dma=%pad\n",
 			HASH_LEN_SIZE, state->digest_bytes_len,
 			&state->digest_bytes_len_dma_addr);
-	} else {
-		state->digest_bytes_len_dma_addr = 0;
 	}
 
 	if (is_hmac && ctx->hash_mode != DRV_HASH_NULL) {
@@ -210,35 +209,29 @@ static int cc_map_req(struct device *dev, struct ahash_req_ctx *state,
 			dev_err(dev, "Mapping opad digest %d B at va=%pK for DMA failed\n",
 				ctx->inter_digestsize,
 				state->opad_digest_buff);
-			goto fail5;
+			goto unmap_digest_len;
 		}
 		dev_dbg(dev, "Mapped opad digest %d B at va=%pK to dma=%pad\n",
 			ctx->inter_digestsize, state->opad_digest_buff,
 			&state->opad_digest_dma_addr);
-	} else {
-		state->opad_digest_dma_addr = 0;
 	}
-	state->buf_cnt[0] = 0;
-	state->buf_cnt[1] = 0;
-	state->buff_index = 0;
-	state->mlli_params.curr_pool = NULL;
 
 	return 0;
 
-fail5:
+unmap_digest_len:
 	if (state->digest_bytes_len_dma_addr) {
 		dma_unmap_single(dev, state->digest_bytes_len_dma_addr,
 				 HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
 		state->digest_bytes_len_dma_addr = 0;
 	}
-fail4:
+unmap_digest_buf:
 	if (state->digest_buff_dma_addr) {
 		dma_unmap_single(dev, state->digest_buff_dma_addr,
 				 ctx->inter_digestsize, DMA_BIDIRECTIONAL);
 		state->digest_buff_dma_addr = 0;
 	}
-fail0:
-	return rc;
+
+	return -EINVAL;
 }
 
 static void cc_unmap_req(struct device *dev, struct ahash_req_ctx *state,
@@ -289,10 +282,13 @@ static void cc_update_complete(struct device *dev, void *cc_req, int err)
 {
 	struct ahash_request *req = (struct ahash_request *)cc_req;
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 
 	dev_dbg(dev, "req=%pK\n", req);
 
 	cc_unmap_hash_request(dev, state, req->src, false);
+	cc_unmap_req(dev, state, ctx);
 	req->base.complete(&req->base, err);
 }
 
@@ -350,19 +346,24 @@ static int cc_hash_digest(struct ahash_request *req)
 	dev_dbg(dev, "===== %s-digest (%d) ====\n", is_hmac ? "hmac" : "hash",
 		nbytes);
 
-	if (cc_map_req(dev, state, ctx, flags)) {
+	cc_init_req(dev, state, ctx);
+
+	if (cc_map_req(dev, state, ctx)) {
 		dev_err(dev, "map_ahash_source() failed\n");
 		return -ENOMEM;
 	}
 
 	if (cc_map_result(dev, state, digestsize)) {
 		dev_err(dev, "map_ahash_digest() failed\n");
+		cc_unmap_req(dev, state, ctx);
 		return -ENOMEM;
 	}
 
 	if (cc_map_hash_request_final(ctx->drvdata, state, src, nbytes, 1,
 				      flags)) {
 		dev_err(dev, "map_ahash_request_final() failed\n");
+		cc_unmap_result(dev, state, digestsize, result);
+		cc_unmap_req(dev, state, ctx);
 		return -ENOMEM;
 	}
 
@@ -521,6 +522,12 @@ static int cc_hash_update(struct ahash_request *req)
 		return -ENOMEM;
 	}
 
+	if (cc_map_req(dev, state, ctx)) {
+		dev_err(dev, "map_ahash_source() failed\n");
+		cc_unmap_hash_request(dev, state, src, true);
+		return -EINVAL;
+	}
+
 	/* Setup DX request structure */
 	cc_req.user_cb = cc_update_complete;
 	cc_req.user_arg = req;
@@ -567,6 +574,7 @@ static int cc_hash_update(struct ahash_request *req)
 	if (rc != -EINPROGRESS && rc != -EBUSY) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, src, true);
+		cc_unmap_req(dev, state, ctx);
 	}
 	return rc;
 }
@@ -591,13 +599,21 @@ static int cc_hash_finup(struct ahash_request *req)
 	dev_dbg(dev, "===== %s-finup (%d) ====\n", is_hmac ? "hmac" : "hash",
 		nbytes);
 
+	if (cc_map_req(dev, state, ctx)) {
+		dev_err(dev, "map_ahash_source() failed\n");
+		return -EINVAL;
+	}
+
 	if (cc_map_hash_request_final(ctx->drvdata, state, src, nbytes, 1,
 				      flags)) {
 		dev_err(dev, "map_ahash_request_final() failed\n");
+		cc_unmap_req(dev, state, ctx);
 		return -ENOMEM;
 	}
 	if (cc_map_result(dev, state, digestsize)) {
 		dev_err(dev, "map_ahash_digest() failed\n");
+		cc_unmap_hash_request(dev, state, src, true);
+		cc_unmap_req(dev, state, ctx);
 		return -ENOMEM;
 	}
 
@@ -689,6 +705,7 @@ static int cc_hash_finup(struct ahash_request *req)
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, src, true);
 		cc_unmap_result(dev, state, digestsize, result);
+		cc_unmap_req(dev, state, ctx);
 	}
 	return rc;
 }
@@ -713,14 +730,22 @@ static int cc_hash_final(struct ahash_request *req)
 	dev_dbg(dev, "===== %s-final (%d) ====\n", is_hmac ? "hmac" : "hash",
 		nbytes);
 
+	if (cc_map_req(dev, state, ctx)) {
+		dev_err(dev, "map_ahash_source() failed\n");
+		return -EINVAL;
+	}
+
 	if (cc_map_hash_request_final(ctx->drvdata, state, src, nbytes, 0,
 				      flags)) {
 		dev_err(dev, "map_ahash_request_final() failed\n");
+		cc_unmap_req(dev, state, ctx);
 		return -ENOMEM;
 	}
 
 	if (cc_map_result(dev, state, digestsize)) {
 		dev_err(dev, "map_ahash_digest() failed\n");
+		cc_unmap_hash_request(dev, state, src, true);
+		cc_unmap_req(dev, state, ctx);
 		return -ENOMEM;
 	}
 
@@ -821,6 +846,7 @@ static int cc_hash_final(struct ahash_request *req)
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, src, true);
 		cc_unmap_result(dev, state, digestsize, result);
+		cc_unmap_req(dev, state, ctx);
 	}
 	return rc;
 }
@@ -831,12 +857,10 @@ static int cc_hash_init(struct ahash_request *req)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
-	gfp_t flags = cc_gfp_flags(&req->base);
 
 	dev_dbg(dev, "===== init (%d) ====\n", req->nbytes);
 
-	state->xcbc_count = 0;
-	cc_map_req(dev, state, ctx, flags);
+	cc_init_req(dev, state, ctx);
 
 	return 0;
 }
@@ -1277,6 +1301,11 @@ static int cc_mac_update(struct ahash_request *req)
 		return -ENOMEM;
 	}
 
+	if (cc_map_req(dev, state, ctx)) {
+		dev_err(dev, "map_ahash_source() failed\n");
+		return -EINVAL;
+	}
+
 	if (ctx->hw_mode == DRV_CIPHER_XCBC_MAC)
 		cc_setup_xcbc(req, desc, &idx);
 	else
@@ -1302,6 +1331,7 @@ static int cc_mac_update(struct ahash_request *req)
 	if (rc != -EINPROGRESS && rc != -EBUSY) {
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, req->src, true);
+		cc_unmap_req(dev, state, ctx);
 	}
 	return rc;
 }
@@ -1332,14 +1362,22 @@ static int cc_mac_final(struct ahash_request *req)
 
 	dev_dbg(dev, "===== final  xcbc reminder (%d) ====\n", rem_cnt);
 
+	if (cc_map_req(dev, state, ctx)) {
+		dev_err(dev, "map_ahash_source() failed\n");
+		return -EINVAL;
+	}
+
 	if (cc_map_hash_request_final(ctx->drvdata, state, req->src,
 				      req->nbytes, 0, flags)) {
 		dev_err(dev, "map_ahash_request_final() failed\n");
+		cc_unmap_req(dev, state, ctx);
 		return -ENOMEM;
 	}
 
 	if (cc_map_result(dev, state, digestsize)) {
 		dev_err(dev, "map_ahash_digest() failed\n");
+		cc_unmap_hash_request(dev, state, req->src, true);
+		cc_unmap_req(dev, state, ctx);
 		return -ENOMEM;
 	}
 
@@ -1415,6 +1453,7 @@ static int cc_mac_final(struct ahash_request *req)
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, req->src, true);
 		cc_unmap_result(dev, state, digestsize, req->result);
+		cc_unmap_req(dev, state, ctx);
 	}
 	return rc;
 }
@@ -1439,13 +1478,21 @@ static int cc_mac_finup(struct ahash_request *req)
 		return cc_mac_final(req);
 	}
 
+	if (cc_map_req(dev, state, ctx)) {
+		dev_err(dev, "map_ahash_source() failed\n");
+		return -EINVAL;
+	}
+
 	if (cc_map_hash_request_final(ctx->drvdata, state, req->src,
 				      req->nbytes, 1, flags)) {
 		dev_err(dev, "map_ahash_request_final() failed\n");
+		cc_unmap_req(dev, state, ctx);
 		return -ENOMEM;
 	}
 	if (cc_map_result(dev, state, digestsize)) {
 		dev_err(dev, "map_ahash_digest() failed\n");
+		cc_unmap_hash_request(dev, state, req->src, true);
+		cc_unmap_req(dev, state, ctx);
 		return -ENOMEM;
 	}
 
@@ -1488,6 +1535,7 @@ static int cc_mac_finup(struct ahash_request *req)
 		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
 		cc_unmap_hash_request(dev, state, req->src, true);
 		cc_unmap_result(dev, state, digestsize, req->result);
+		cc_unmap_req(dev, state, ctx);
 	}
 	return rc;
 }
@@ -1508,18 +1556,22 @@ static int cc_mac_digest(struct ahash_request *req)
 
 	dev_dbg(dev, "===== -digest mac (%d) ====\n",  req->nbytes);
 
-	if (cc_map_req(dev, state, ctx, flags)) {
+	cc_init_req(dev, state, ctx);
+
+	if (cc_map_req(dev, state, ctx)) {
 		dev_err(dev, "map_ahash_source() failed\n");
 		return -ENOMEM;
 	}
 	if (cc_map_result(dev, state, digestsize)) {
 		dev_err(dev, "map_ahash_digest() failed\n");
+		cc_unmap_req(dev, state, ctx);
 		return -ENOMEM;
 	}
 
 	if (cc_map_hash_request_final(ctx->drvdata, state, req->src,
 				      req->nbytes, 1, flags)) {
 		dev_err(dev, "map_ahash_request_final() failed\n");
+		cc_unmap_req(dev, state, ctx);
 		return -ENOMEM;
 	}
 
@@ -1571,7 +1623,6 @@ static int cc_hash_export(struct ahash_request *req, void *out)
 {
 	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
 	struct cc_hash_ctx *ctx = crypto_ahash_ctx(ahash);
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
 	u8 *curr_buff = cc_hash_buf(state);
 	u32 curr_buff_cnt = *cc_hash_buf_cnt(state);
@@ -1580,19 +1631,10 @@ static int cc_hash_export(struct ahash_request *req, void *out)
 	memcpy(out, &tmp, sizeof(u32));
 	out += sizeof(u32);
 
-	dma_sync_single_for_cpu(dev, state->digest_buff_dma_addr,
-				ctx->inter_digestsize, DMA_BIDIRECTIONAL);
 	memcpy(out, state->digest_buff, ctx->inter_digestsize);
 	out += ctx->inter_digestsize;
 
-	if (state->digest_bytes_len_dma_addr) {
-		dma_sync_single_for_cpu(dev, state->digest_bytes_len_dma_addr,
-					HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
-		memcpy(out, state->digest_bytes_len, HASH_LEN_SIZE);
-	} else {
-		/* Poison the unused exported digest len field. */
-		memset(out, 0x5F, HASH_LEN_SIZE);
-	}
+	memcpy(out, state->digest_bytes_len, HASH_LEN_SIZE);
 	out += HASH_LEN_SIZE;
 
 	memcpy(out, &curr_buff_cnt, sizeof(u32));
@@ -1600,10 +1642,6 @@ static int cc_hash_export(struct ahash_request *req, void *out)
 
 	memcpy(out, curr_buff, curr_buff_cnt);
 
-	/* No sync for device ineeded since we did not change the data,
-	 * we only copy it
-	 */
-
 	return 0;
 }
 
@@ -1614,54 +1652,30 @@ static int cc_hash_import(struct ahash_request *req, const void *in)
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
 	u32 tmp;
-	int rc;
 
 	memcpy(&tmp, in, sizeof(u32));
-	if (tmp != CC_EXPORT_MAGIC) {
-		rc = -EINVAL;
-		goto out;
-	}
+	if (tmp != CC_EXPORT_MAGIC)
+		return -EINVAL;
 	in += sizeof(u32);
 
-	rc = cc_hash_init(req);
-	if (rc)
-		goto out;
+	cc_init_req(dev, state, ctx);
 
-	dma_sync_single_for_cpu(dev, state->digest_buff_dma_addr,
-				ctx->inter_digestsize, DMA_BIDIRECTIONAL);
 	memcpy(state->digest_buff, in, ctx->inter_digestsize);
 	in += ctx->inter_digestsize;
 
-	if (state->digest_bytes_len_dma_addr) {
-		dma_sync_single_for_cpu(dev, state->digest_bytes_len_dma_addr,
-					HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
-		memcpy(state->digest_bytes_len, in, HASH_LEN_SIZE);
-	}
+	memcpy(state->digest_bytes_len, in, HASH_LEN_SIZE);
 	in += HASH_LEN_SIZE;
 
-	dma_sync_single_for_device(dev, state->digest_buff_dma_addr,
-				   ctx->inter_digestsize, DMA_BIDIRECTIONAL);
-
-	if (state->digest_bytes_len_dma_addr)
-		dma_sync_single_for_device(dev,
-					   state->digest_bytes_len_dma_addr,
-					   HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
-
-	state->buff_index = 0;
-
 	/* Sanity check the data as much as possible */
 	memcpy(&tmp, in, sizeof(u32));
-	if (tmp > CC_MAX_HASH_BLCK_SIZE) {
-		rc = -EINVAL;
-		goto out;
-	}
+	if (tmp > CC_MAX_HASH_BLCK_SIZE)
+		return -EINVAL;
 	in += sizeof(u32);
 
 	state->buf_cnt[0] = tmp;
 	memcpy(state->buffers[0], in, tmp);
 
-out:
-	return rc;
+	return 0;
 }
 
 struct cc_hash_template {
-- 
2.7.4
