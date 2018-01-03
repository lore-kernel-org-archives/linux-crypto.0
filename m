From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 18/27] staging: ccree: allocate hash bufs inside req ctx
Date: Wed,  3 Jan 2018 13:35:25 +0000
Message-ID: <1514986544-5888-19-git-send-email-gilad@benyossef.com>
References: <1514986544-5888-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1514986544-5888-1-git-send-email-gilad@benyossef.com>
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

Move to allocating the buffers needed for requests as part of
the request structure instead of malloc'ing each one on it's
own, making for simpler (and more efficient) code.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_hash.c | 68 ++++------------------------------------
 drivers/staging/ccree/ssi_hash.h | 12 +++----
 2 files changed, 12 insertions(+), 68 deletions(-)

diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index a8ea6a2..69fc2fcf3 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -108,7 +108,7 @@ static int cc_map_result(struct device *dev, struct ahash_req_ctx *state,
 			 unsigned int digestsize)
 {
 	state->digest_result_dma_addr =
-		dma_map_single(dev, (void *)state->digest_result_buff,
+		dma_map_single(dev, state->digest_result_buff,
 			       digestsize,
 			       DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(dev, state->digest_result_dma_addr)) {
@@ -129,49 +129,15 @@ static int cc_map_req(struct device *dev, struct ahash_req_ctx *state,
 	bool is_hmac = ctx->is_hmac;
 	int rc = -ENOMEM;
 
-	state->buffers[0] = kzalloc(CC_MAX_HASH_BLCK_SIZE, flags);
-	if (!state->buffers[0])
-		goto fail0;
-
-	state->buffers[1] = kzalloc(CC_MAX_HASH_BLCK_SIZE, flags);
-	if (!state->buffers[1])
-		goto fail_buff0;
-
-	state->digest_result_buff = kzalloc(CC_MAX_HASH_DIGEST_SIZE, flags);
-	if (!state->digest_result_buff)
-		goto fail_buff1;
-
-	state->digest_buff = kzalloc(ctx->inter_digestsize, flags);
-	if (!state->digest_buff)
-		goto fail_digest_result_buff;
-
-	dev_dbg(dev, "Allocated digest-buffer in context ctx->digest_buff=@%p\n",
-		state->digest_buff);
-	if (ctx->hw_mode != DRV_CIPHER_XCBC_MAC) {
-		state->digest_bytes_len = kzalloc(HASH_LEN_SIZE, flags);
-		if (!state->digest_bytes_len)
-			goto fail1;
-
-		dev_dbg(dev, "Allocated digest-bytes-len in context state->>digest_bytes_len=@%p\n",
-			state->digest_bytes_len);
-	} else {
-		state->digest_bytes_len = NULL;
-	}
-
-	state->opad_digest_buff = kzalloc(ctx->inter_digestsize, flags);
-	if (!state->opad_digest_buff)
-		goto fail2;
-
-	dev_dbg(dev, "Allocated opad-digest-buffer in context state->digest_bytes_len=@%p\n",
-		state->opad_digest_buff);
+	memset(state, 0, sizeof(*state));
 
 	state->digest_buff_dma_addr =
-		dma_map_single(dev, (void *)state->digest_buff,
+		dma_map_single(dev, state->digest_buff,
 			       ctx->inter_digestsize, DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(dev, state->digest_buff_dma_addr)) {
 		dev_err(dev, "Mapping digest len %d B at va=%pK for DMA failed\n",
 			ctx->inter_digestsize, state->digest_buff);
-		goto fail3;
+		goto fail0;
 	}
 	dev_dbg(dev, "Mapped digest %d B at va=%pK to dma=%pad\n",
 		ctx->inter_digestsize, state->digest_buff,
@@ -221,7 +187,7 @@ static int cc_map_req(struct device *dev, struct ahash_req_ctx *state,
 
 	if (ctx->hw_mode != DRV_CIPHER_XCBC_MAC) {
 		state->digest_bytes_len_dma_addr =
-			dma_map_single(dev, (void *)state->digest_bytes_len,
+			dma_map_single(dev, state->digest_bytes_len,
 				       HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
 		if (dma_mapping_error(dev, state->digest_bytes_len_dma_addr)) {
 			dev_err(dev, "Mapping digest len %u B at va=%pK for DMA failed\n",
@@ -237,7 +203,7 @@ static int cc_map_req(struct device *dev, struct ahash_req_ctx *state,
 
 	if (is_hmac && ctx->hash_mode != DRV_HASH_NULL) {
 		state->opad_digest_dma_addr =
-			dma_map_single(dev, (void *)state->opad_digest_buff,
+			dma_map_single(dev, state->opad_digest_buff,
 				       ctx->inter_digestsize,
 				       DMA_BIDIRECTIONAL);
 		if (dma_mapping_error(dev, state->opad_digest_dma_addr)) {
@@ -271,21 +237,6 @@ static int cc_map_req(struct device *dev, struct ahash_req_ctx *state,
 				 ctx->inter_digestsize, DMA_BIDIRECTIONAL);
 		state->digest_buff_dma_addr = 0;
 	}
-fail3:
-	kfree(state->opad_digest_buff);
-fail2:
-	kfree(state->digest_bytes_len);
-fail1:
-	 kfree(state->digest_buff);
-fail_digest_result_buff:
-	kfree(state->digest_result_buff);
-	state->digest_result_buff = NULL;
-fail_buff1:
-	kfree(state->buffers[1]);
-	state->buffers[1] = NULL;
-fail_buff0:
-	kfree(state->buffers[0]);
-	state->buffers[0] = NULL;
 fail0:
 	return rc;
 }
@@ -314,13 +265,6 @@ static void cc_unmap_req(struct device *dev, struct ahash_req_ctx *state,
 			&state->opad_digest_dma_addr);
 		state->opad_digest_dma_addr = 0;
 	}
-
-	kfree(state->opad_digest_buff);
-	kfree(state->digest_bytes_len);
-	kfree(state->digest_buff);
-	kfree(state->digest_result_buff);
-	kfree(state->buffers[1]);
-	kfree(state->buffers[0]);
 }
 
 static void cc_unmap_result(struct device *dev, struct ahash_req_ctx *state,
diff --git a/drivers/staging/ccree/ssi_hash.h b/drivers/staging/ccree/ssi_hash.h
index 78f193b..3d3c024 100644
--- a/drivers/staging/ccree/ssi_hash.h
+++ b/drivers/staging/ccree/ssi_hash.h
@@ -39,13 +39,13 @@ struct aeshash_state {
 
 /* ahash state */
 struct ahash_req_ctx {
-	u8 *buffers[2];
-	u8 *digest_result_buff;
-	struct async_gen_req_ctx gen_ctx;
+	u8 buffers[2][CC_MAX_HASH_BLCK_SIZE] ____cacheline_aligned;
+	u8 digest_result_buff[CC_MAX_HASH_DIGEST_SIZE] ____cacheline_aligned;
+	u8 digest_buff[CC_MAX_HASH_DIGEST_SIZE] ____cacheline_aligned;
+	u8 opad_digest_buff[CC_MAX_HASH_DIGEST_SIZE] ____cacheline_aligned;
+	u8 digest_bytes_len[HASH_LEN_SIZE] ____cacheline_aligned;
+	struct async_gen_req_ctx gen_ctx ____cacheline_aligned;
 	enum cc_req_dma_buf_type data_dma_buf_type;
-	u8 *digest_buff;
-	u8 *opad_digest_buff;
-	u8 *digest_bytes_len;
 	dma_addr_t opad_digest_dma_addr;
 	dma_addr_t digest_buff_dma_addr;
 	dma_addr_t digest_bytes_len_dma_addr;
-- 
2.7.4
