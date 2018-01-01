From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 17/26] staging: ccree: use array for double buffer
Date: Mon,  1 Jan 2018 12:06:44 +0000
Message-ID: <1514808421-21993-18-git-send-email-gilad@benyossef.com>
References: <1514808421-21993-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1514808421-21993-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The ccree hash code is using a double buffer to hold data
for processing but manages the buffers and their associated
data count in two separate fields and uses a predicate to
chose which to use.

Move to using a proper 2 members array for a much cleaner code.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_buffer_mgr.c | 21 +++++++-------------
 drivers/staging/ccree/ssi_hash.c       | 36 ++++++++++++++++------------------
 drivers/staging/ccree/ssi_hash.h       | 26 ++++++++++++++++++++----
 3 files changed, 46 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index cb3e235..4fa5599 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -1391,10 +1391,8 @@ int cc_map_hash_request_final(struct cc_drvdata *drvdata, void *ctx,
 {
 	struct ahash_req_ctx *areq_ctx = (struct ahash_req_ctx *)ctx;
 	struct device *dev = drvdata_to_dev(drvdata);
-	u8 *curr_buff = areq_ctx->buff_index ? areq_ctx->buff1 :
-			areq_ctx->buff0;
-	u32 *curr_buff_cnt = areq_ctx->buff_index ? &areq_ctx->buff1_cnt :
-			&areq_ctx->buff0_cnt;
+	u8 *curr_buff = cc_hash_buf(areq_ctx);
+	u32 *curr_buff_cnt = cc_hash_buf_cnt(areq_ctx);
 	struct mlli_params *mlli_params = &areq_ctx->mlli_params;
 	struct buffer_array sg_data;
 	struct buff_mgr_handle *buff_mgr = drvdata->buff_mgr_handle;
@@ -1472,14 +1470,10 @@ int cc_map_hash_request_update(struct cc_drvdata *drvdata, void *ctx,
 {
 	struct ahash_req_ctx *areq_ctx = (struct ahash_req_ctx *)ctx;
 	struct device *dev = drvdata_to_dev(drvdata);
-	u8 *curr_buff = areq_ctx->buff_index ? areq_ctx->buff1 :
-			areq_ctx->buff0;
-	u32 *curr_buff_cnt = areq_ctx->buff_index ? &areq_ctx->buff1_cnt :
-			&areq_ctx->buff0_cnt;
-	u8 *next_buff = areq_ctx->buff_index ? areq_ctx->buff0 :
-			areq_ctx->buff1;
-	u32 *next_buff_cnt = areq_ctx->buff_index ? &areq_ctx->buff0_cnt :
-			&areq_ctx->buff1_cnt;
+	u8 *curr_buff = cc_hash_buf(areq_ctx);
+	u32 *curr_buff_cnt = cc_hash_buf_cnt(areq_ctx);
+	u8 *next_buff = cc_next_buf(areq_ctx);
+	u32 *next_buff_cnt = cc_next_buf_cnt(areq_ctx);
 	struct mlli_params *mlli_params = &areq_ctx->mlli_params;
 	unsigned int update_data_len;
 	u32 total_in_len = nbytes + *curr_buff_cnt;
@@ -1585,8 +1579,7 @@ void cc_unmap_hash_request(struct device *dev, void *ctx,
 			   struct scatterlist *src, bool do_revert)
 {
 	struct ahash_req_ctx *areq_ctx = (struct ahash_req_ctx *)ctx;
-	u32 *prev_len = areq_ctx->buff_index ?  &areq_ctx->buff0_cnt :
-						&areq_ctx->buff1_cnt;
+	u32 *prev_len = cc_next_buf_cnt(areq_ctx);
 
 	/*In case a pool was set, a table was
 	 *allocated and should be released
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index c64b4b5..183b6cd 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -129,12 +129,12 @@ static int cc_map_req(struct device *dev, struct ahash_req_ctx *state,
 	bool is_hmac = ctx->is_hmac;
 	int rc = -ENOMEM;
 
-	state->buff0 = kzalloc(CC_MAX_HASH_BLCK_SIZE, flags);
-	if (!state->buff0)
+	state->buffers[0] = kzalloc(CC_MAX_HASH_BLCK_SIZE, flags);
+	if (!state->buffers[0])
 		goto fail0;
 
-	state->buff1 = kzalloc(CC_MAX_HASH_BLCK_SIZE, flags);
-	if (!state->buff1)
+	state->buffers[1] = kzalloc(CC_MAX_HASH_BLCK_SIZE, flags);
+	if (!state->buffers[1])
 		goto fail_buff0;
 
 	state->digest_result_buff = kzalloc(CC_MAX_HASH_DIGEST_SIZE, flags);
@@ -252,8 +252,8 @@ static int cc_map_req(struct device *dev, struct ahash_req_ctx *state,
 	} else {
 		state->opad_digest_dma_addr = 0;
 	}
-	state->buff0_cnt = 0;
-	state->buff1_cnt = 0;
+	state->buf_cnt[0] = 0;
+	state->buf_cnt[1] = 0;
 	state->buff_index = 0;
 	state->mlli_params.curr_pool = NULL;
 
@@ -281,11 +281,11 @@ static int cc_map_req(struct device *dev, struct ahash_req_ctx *state,
 	kfree(state->digest_result_buff);
 	state->digest_result_buff = NULL;
 fail_buff1:
-	kfree(state->buff1);
-	state->buff1 = NULL;
+	kfree(state->buffers[1]);
+	state->buffers[1] = NULL;
 fail_buff0:
-	kfree(state->buff0);
-	state->buff0 = NULL;
+	kfree(state->buffers[0]);
+	state->buffers[0] = NULL;
 fail0:
 	return rc;
 }
@@ -319,8 +319,8 @@ static void cc_unmap_req(struct device *dev, struct ahash_req_ctx *state,
 	kfree(state->digest_bytes_len);
 	kfree(state->digest_buff);
 	kfree(state->digest_result_buff);
-	kfree(state->buff1);
-	kfree(state->buff0);
+	kfree(state->buffers[1]);
+	kfree(state->buffers[0]);
 }
 
 static void cc_unmap_result(struct device *dev, struct ahash_req_ctx *state,
@@ -1375,8 +1375,7 @@ static int cc_mac_final(struct ahash_request *req)
 	u32 key_size, key_len;
 	u32 digestsize = crypto_ahash_digestsize(tfm);
 	gfp_t flags = cc_gfp_flags(&req->base);
-	u32 rem_cnt = state->buff_index ? state->buff1_cnt :
-			state->buff0_cnt;
+	u32 rem_cnt = *cc_hash_buf_cnt(state);
 
 	if (ctx->hw_mode == DRV_CIPHER_XCBC_MAC) {
 		key_size = CC_AES_128_BIT_KEY_SIZE;
@@ -1630,9 +1629,8 @@ static int cc_hash_export(struct ahash_request *req, void *out)
 	struct cc_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
-	u8 *curr_buff = state->buff_index ? state->buff1 : state->buff0;
-	u32 curr_buff_cnt = state->buff_index ? state->buff1_cnt :
-				state->buff0_cnt;
+	u8 *curr_buff = cc_hash_buf(state);
+	u32 curr_buff_cnt = *cc_hash_buf_cnt(state);
 	const u32 tmp = CC_EXPORT_MAGIC;
 
 	memcpy(out, &tmp, sizeof(u32));
@@ -1715,8 +1713,8 @@ static int cc_hash_import(struct ahash_request *req, const void *in)
 	}
 	in += sizeof(u32);
 
-	state->buff0_cnt = tmp;
-	memcpy(state->buff0, in, state->buff0_cnt);
+	state->buf_cnt[0] = tmp;
+	memcpy(state->buffers[0], in, tmp);
 
 out:
 	return rc;
diff --git a/drivers/staging/ccree/ssi_hash.h b/drivers/staging/ccree/ssi_hash.h
index 9387428..18924d3 100644
--- a/drivers/staging/ccree/ssi_hash.h
+++ b/drivers/staging/ccree/ssi_hash.h
@@ -39,8 +39,7 @@ struct aeshash_state {
 
 /* ahash state */
 struct ahash_req_ctx {
-	u8 *buff0;
-	u8 *buff1;
+	u8 *buffers[2];
 	u8 *digest_result_buff;
 	struct async_gen_req_ctx gen_ctx;
 	enum cc_req_dma_buf_type data_dma_buf_type;
@@ -51,8 +50,7 @@ struct ahash_req_ctx {
 	dma_addr_t digest_buff_dma_addr;
 	dma_addr_t digest_bytes_len_dma_addr;
 	dma_addr_t digest_result_dma_addr;
-	u32 buff0_cnt;
-	u32 buff1_cnt;
+	u32 buf_cnt[2];
 	u32 buff_index;
 	u32 xcbc_count; /* count xcbc update operatations */
 	struct scatterlist buff_sg[2];
@@ -62,6 +60,26 @@ struct ahash_req_ctx {
 	struct mlli_params mlli_params;
 };
 
+static inline u32 *cc_hash_buf_cnt(struct ahash_req_ctx *state)
+{
+	return &state->buf_cnt[state->buff_index];
+}
+
+static inline u8 *cc_hash_buf(struct ahash_req_ctx *state)
+{
+	return state->buffers[state->buff_index];
+}
+
+static inline u32 *cc_next_buf_cnt(struct ahash_req_ctx *state)
+{
+	return &state->buf_cnt[state->buff_index ^ 1];
+}
+
+static inline u8 *cc_next_buf(struct ahash_req_ctx *state)
+{
+	return state->buffers[state->buff_index ^ 1];
+}
+
 int cc_hash_alloc(struct cc_drvdata *drvdata);
 int cc_init_hash_sram(struct cc_drvdata *drvdata);
 int cc_hash_free(struct cc_drvdata *drvdata);
-- 
2.7.4
