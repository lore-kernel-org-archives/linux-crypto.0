From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 21/27] staging: ccree: fold common code into service func
Date: Sun,  7 Jan 2018 12:14:32 +0000
Message-ID: <1515327285-8948-22-git-send-email-gilad@benyossef.com>
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

Fold common code in hash call into service functions.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_hash.c | 339 ++++++++++++++-------------------------
 1 file changed, 116 insertions(+), 223 deletions(-)

diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index c04b335..57031c7 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -319,6 +319,84 @@ static void cc_hash_complete(struct device *dev, void *cc_req, int err)
 	req->base.complete(&req->base, err);
 }
 
+static int cc_fin_result(struct cc_hw_desc *desc, struct ahash_request *req,
+			 int idx)
+{
+	struct ahash_req_ctx *state = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	u32 digestsize = crypto_ahash_digestsize(tfm);
+
+	/* Get final MAC result */
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	/* TODO */
+	set_dout_dlli(&desc[idx], state->digest_result_dma_addr, digestsize,
+		      NS_BIT, 1);
+	set_queue_last_ind(&desc[idx]);
+	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
+	set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
+	cc_set_endianity(ctx->hash_mode, &desc[idx]);
+	idx++;
+
+	return idx;
+}
+
+static int cc_fin_hmac(struct cc_hw_desc *desc, struct ahash_request *req,
+		       int idx)
+{
+	struct ahash_req_ctx *state = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	u32 digestsize = crypto_ahash_digestsize(tfm);
+
+	/* store the hash digest result in the context */
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	set_dout_dlli(&desc[idx], state->digest_buff_dma_addr, digestsize,
+		      NS_BIT, 0);
+	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+	cc_set_endianity(ctx->hash_mode, &desc[idx]);
+	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
+	idx++;
+
+	/* Loading hash opad xor key state */
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	set_din_type(&desc[idx], DMA_DLLI, state->opad_digest_dma_addr,
+		     ctx->inter_digestsize, NS_BIT);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
+	idx++;
+
+	/* Load the hash current length */
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	set_din_sram(&desc[idx],
+		     cc_digest_len_addr(ctx->drvdata, ctx->hash_mode),
+		     HASH_LEN_SIZE);
+	set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
+	idx++;
+
+	/* Memory Barrier: wait for IPAD/OPAD axi write to complete */
+	hw_desc_init(&desc[idx]);
+	set_din_no_dma(&desc[idx], 0, 0xfffff0);
+	set_dout_no_dma(&desc[idx], 0, 0, 1);
+	idx++;
+
+	/* Perform HASH update */
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr,
+		     digestsize, NS_BIT);
+	set_flow_mode(&desc[idx], DIN_HASH);
+	idx++;
+
+	return idx;
+}
+
 static int cc_hash_digest(struct ahash_request *req)
 {
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
@@ -414,62 +492,10 @@ static int cc_hash_digest(struct ahash_request *req)
 		set_cipher_do(&desc[idx], DO_PAD);
 		idx++;
 
-		/* store the hash digest result in the context */
-		hw_desc_init(&desc[idx]);
-		set_cipher_mode(&desc[idx], ctx->hw_mode);
-		set_dout_dlli(&desc[idx], state->digest_buff_dma_addr,
-			      digestsize, NS_BIT, 0);
-		set_flow_mode(&desc[idx], S_HASH_to_DOUT);
-		cc_set_endianity(ctx->hash_mode, &desc[idx]);
-		set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
-		idx++;
-
-		/* Loading hash opad xor key state */
-		hw_desc_init(&desc[idx]);
-		set_cipher_mode(&desc[idx], ctx->hw_mode);
-		set_din_type(&desc[idx], DMA_DLLI, state->opad_digest_dma_addr,
-			     ctx->inter_digestsize, NS_BIT);
-		set_flow_mode(&desc[idx], S_DIN_to_HASH);
-		set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
-		idx++;
-
-		/* Load the hash current length */
-		hw_desc_init(&desc[idx]);
-		set_cipher_mode(&desc[idx], ctx->hw_mode);
-		set_din_sram(&desc[idx],
-			     cc_digest_len_addr(ctx->drvdata, ctx->hash_mode),
-			     HASH_LEN_SIZE);
-		set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
-		set_flow_mode(&desc[idx], S_DIN_to_HASH);
-		set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
-		idx++;
-
-		/* Memory Barrier: wait for IPAD/OPAD axi write to complete */
-		hw_desc_init(&desc[idx]);
-		set_din_no_dma(&desc[idx], 0, 0xfffff0);
-		set_dout_no_dma(&desc[idx], 0, 0, 1);
-		idx++;
-
-		/* Perform HASH update */
-		hw_desc_init(&desc[idx]);
-		set_din_type(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr,
-			     digestsize, NS_BIT);
-		set_flow_mode(&desc[idx], DIN_HASH);
-		idx++;
+		idx = cc_fin_hmac(desc, req, idx);
 	}
 
-	/* Get final MAC result */
-	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], ctx->hw_mode);
-	/* TODO */
-	set_dout_dlli(&desc[idx], state->digest_result_dma_addr, digestsize,
-		      NS_BIT, 1);
-	set_queue_last_ind(&desc[idx]);
-	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
-	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
-	set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
-	cc_set_endianity(ctx->hash_mode, &desc[idx]);
-	idx++;
+	idx = cc_fin_result(desc, req, idx);
 
 	rc = cc_send_request(ctx->drvdata, &cc_req, desc, idx, &req->base);
 	if (rc != -EINPROGRESS && rc != -EBUSY) {
@@ -481,6 +507,33 @@ static int cc_hash_digest(struct ahash_request *req)
 	return rc;
 }
 
+static int cc_restore_hash(struct cc_hw_desc *desc, struct cc_hash_ctx *ctx,
+			   struct ahash_req_ctx *state, int idx)
+{
+	/* Restore hash digest */
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	set_din_type(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr,
+		     ctx->inter_digestsize, NS_BIT);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
+	idx++;
+
+	/* Restore hash current length */
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
+	set_din_type(&desc[idx], DMA_DLLI, state->digest_bytes_len_dma_addr,
+		     HASH_LEN_SIZE, NS_BIT);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
+	idx++;
+
+	cc_set_desc(state, ctx, DIN_HASH, desc, false, &idx);
+
+	return idx;
+}
+
 static int cc_hash_update(struct ahash_request *req)
 {
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
@@ -527,24 +580,7 @@ static int cc_hash_update(struct ahash_request *req)
 	cc_req.user_cb = cc_update_complete;
 	cc_req.user_arg = req;
 
-	/* Restore hash digest */
-	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], ctx->hw_mode);
-	set_din_type(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr,
-		     ctx->inter_digestsize, NS_BIT);
-	set_flow_mode(&desc[idx], S_DIN_to_HASH);
-	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
-	idx++;
-	/* Restore hash current length */
-	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], ctx->hw_mode);
-	set_din_type(&desc[idx], DMA_DLLI, state->digest_bytes_len_dma_addr,
-		     HASH_LEN_SIZE, NS_BIT);
-	set_flow_mode(&desc[idx], S_DIN_to_HASH);
-	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
-	idx++;
-
-	cc_set_desc(state, ctx, DIN_HASH, desc, false, &idx);
+	idx = cc_restore_hash(desc, ctx, state, idx);
 
 	/* store the hash digest result in context */
 	hw_desc_init(&desc[idx]);
@@ -616,84 +652,12 @@ static int cc_hash_finup(struct ahash_request *req)
 	cc_req.user_cb = cc_hash_complete;
 	cc_req.user_arg = req;
 
-	/* Restore hash digest */
-	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], ctx->hw_mode);
-	set_din_type(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr,
-		     ctx->inter_digestsize, NS_BIT);
-	set_flow_mode(&desc[idx], S_DIN_to_HASH);
-	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
-	idx++;
-
-	/* Restore hash current length */
-	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], ctx->hw_mode);
-	set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
-	set_din_type(&desc[idx], DMA_DLLI, state->digest_bytes_len_dma_addr,
-		     HASH_LEN_SIZE, NS_BIT);
-	set_flow_mode(&desc[idx], S_DIN_to_HASH);
-	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
-	idx++;
+	idx = cc_restore_hash(desc, ctx, state, idx);
 
-	cc_set_desc(state, ctx, DIN_HASH, desc, false, &idx);
+	if (is_hmac)
+		idx = cc_fin_hmac(desc, req, idx);
 
-	if (is_hmac) {
-		/* Store the hash digest result in the context */
-		hw_desc_init(&desc[idx]);
-		set_cipher_mode(&desc[idx], ctx->hw_mode);
-		set_dout_dlli(&desc[idx], state->digest_buff_dma_addr,
-			      digestsize, NS_BIT, 0);
-		cc_set_endianity(ctx->hash_mode, &desc[idx]);
-		set_flow_mode(&desc[idx], S_HASH_to_DOUT);
-		set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
-		idx++;
-
-		/* Loading hash OPAD xor key state */
-		hw_desc_init(&desc[idx]);
-		set_cipher_mode(&desc[idx], ctx->hw_mode);
-		set_din_type(&desc[idx], DMA_DLLI, state->opad_digest_dma_addr,
-			     ctx->inter_digestsize, NS_BIT);
-		set_flow_mode(&desc[idx], S_DIN_to_HASH);
-		set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
-		idx++;
-
-		/* Load the hash current length */
-		hw_desc_init(&desc[idx]);
-		set_cipher_mode(&desc[idx], ctx->hw_mode);
-		set_din_sram(&desc[idx],
-			     cc_digest_len_addr(ctx->drvdata, ctx->hash_mode),
-			     HASH_LEN_SIZE);
-		set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
-		set_flow_mode(&desc[idx], S_DIN_to_HASH);
-		set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
-		idx++;
-
-		/* Memory Barrier: wait for IPAD/OPAD axi write to complete */
-		hw_desc_init(&desc[idx]);
-		set_din_no_dma(&desc[idx], 0, 0xfffff0);
-		set_dout_no_dma(&desc[idx], 0, 0, 1);
-		idx++;
-
-		/* Perform HASH update on last digest */
-		hw_desc_init(&desc[idx]);
-		set_din_type(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr,
-			     digestsize, NS_BIT);
-		set_flow_mode(&desc[idx], DIN_HASH);
-		idx++;
-	}
-
-	/* Get final MAC result */
-	hw_desc_init(&desc[idx]);
-	/* TODO */
-	set_dout_dlli(&desc[idx], state->digest_result_dma_addr, digestsize,
-		      NS_BIT, 1);
-	set_queue_last_ind(&desc[idx]);
-	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
-	set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
-	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
-	cc_set_endianity(ctx->hash_mode, &desc[idx]);
-	set_cipher_mode(&desc[idx], ctx->hw_mode);
-	idx++;
+	idx = cc_fin_result(desc, req, idx);
 
 	rc = cc_send_request(ctx->drvdata, &cc_req, desc, idx, &req->base);
 	if (rc != -EINPROGRESS && rc != -EBUSY) {
@@ -748,26 +712,7 @@ static int cc_hash_final(struct ahash_request *req)
 	cc_req.user_cb = cc_hash_complete;
 	cc_req.user_arg = req;
 
-	/* Restore hash digest */
-	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], ctx->hw_mode);
-	set_din_type(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr,
-		     ctx->inter_digestsize, NS_BIT);
-	set_flow_mode(&desc[idx], S_DIN_to_HASH);
-	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
-	idx++;
-
-	/* Restore hash current length */
-	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], ctx->hw_mode);
-	set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
-	set_din_type(&desc[idx], DMA_DLLI, state->digest_bytes_len_dma_addr,
-		     HASH_LEN_SIZE, NS_BIT);
-	set_flow_mode(&desc[idx], S_DIN_to_HASH);
-	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
-	idx++;
-
-	cc_set_desc(state, ctx, DIN_HASH, desc, false, &idx);
+	idx = cc_restore_hash(desc, ctx, state, idx);
 
 	/* "DO-PAD" must be enabled only when writing current length to HW */
 	hw_desc_init(&desc[idx]);
@@ -779,62 +724,10 @@ static int cc_hash_final(struct ahash_request *req)
 	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
 	idx++;
 
-	if (is_hmac) {
-		/* Store the hash digest result in the context */
-		hw_desc_init(&desc[idx]);
-		set_cipher_mode(&desc[idx], ctx->hw_mode);
-		set_dout_dlli(&desc[idx], state->digest_buff_dma_addr,
-			      digestsize, NS_BIT, 0);
-		cc_set_endianity(ctx->hash_mode, &desc[idx]);
-		set_flow_mode(&desc[idx], S_HASH_to_DOUT);
-		set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
-		idx++;
-
-		/* Loading hash OPAD xor key state */
-		hw_desc_init(&desc[idx]);
-		set_cipher_mode(&desc[idx], ctx->hw_mode);
-		set_din_type(&desc[idx], DMA_DLLI, state->opad_digest_dma_addr,
-			     ctx->inter_digestsize, NS_BIT);
-		set_flow_mode(&desc[idx], S_DIN_to_HASH);
-		set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
-		idx++;
-
-		/* Load the hash current length */
-		hw_desc_init(&desc[idx]);
-		set_cipher_mode(&desc[idx], ctx->hw_mode);
-		set_din_sram(&desc[idx],
-			     cc_digest_len_addr(ctx->drvdata, ctx->hash_mode),
-			     HASH_LEN_SIZE);
-		set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
-		set_flow_mode(&desc[idx], S_DIN_to_HASH);
-		set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
-		idx++;
-
-		/* Memory Barrier: wait for IPAD/OPAD axi write to complete */
-		hw_desc_init(&desc[idx]);
-		set_din_no_dma(&desc[idx], 0, 0xfffff0);
-		set_dout_no_dma(&desc[idx], 0, 0, 1);
-		idx++;
+	if (is_hmac)
+		idx = cc_fin_hmac(desc, req, idx);
 
-		/* Perform HASH update on last digest */
-		hw_desc_init(&desc[idx]);
-		set_din_type(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr,
-			     digestsize, NS_BIT);
-		set_flow_mode(&desc[idx], DIN_HASH);
-		idx++;
-	}
-
-	/* Get final MAC result */
-	hw_desc_init(&desc[idx]);
-	set_dout_dlli(&desc[idx], state->digest_result_dma_addr, digestsize,
-		      NS_BIT, 1);
-	set_queue_last_ind(&desc[idx]);
-	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
-	set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
-	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
-	cc_set_endianity(ctx->hash_mode, &desc[idx]);
-	set_cipher_mode(&desc[idx], ctx->hw_mode);
-	idx++;
+	idx = cc_fin_result(desc, req, idx);
 
 	rc = cc_send_request(ctx->drvdata, &cc_req, desc, idx, &req->base);
 	if (rc != -EINPROGRESS && rc != -EBUSY) {
-- 
2.7.4
