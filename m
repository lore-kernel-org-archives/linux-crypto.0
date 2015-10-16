From: Victoria Milhoan <vicki.milhoan@freescale.com>
Subject: [PATCH] crypto: caam - Add support for hashing export and import functions
Date: Fri, 16 Oct 2015 16:19:33 -0700
Message-ID: <1445037573-29667-1-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>, <linux@arm.linux.org.uk>,
	<horia.geanta@freescale.com>, <fabio.estevam@freescale.com>,
	<boris.brezillon@free-electrons.com>, <arno@natisbad.org>,
	<thomas.petazzoni@free-electrons.com>, <jason@lakedaemon.net>,
	<davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0138.outbound.protection.outlook.com ([157.56.110.138]:41264
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751103AbbJPXfV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 16 Oct 2015 19:35:21 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add support for the export and import functions used by hashing algorithms
by specifying the size of the data saved/restored. The size of the data is
provided during algorithm registration.

Also, modify the structures saved/restored in order to meet the size limit
of 512 bytes imposed by the the Crypto API.

Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
---
 drivers/crypto/caam/caamhash.c | 82 ++++++++++++++++++++++++++++++++++--------
 1 file changed, 68 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 9609f66..bb81ab6 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -100,11 +100,11 @@ static struct list_head hash_list;
 /* ahash per-session context */
 struct caam_hash_ctx {
 	struct device *jrdev;
-	u32 sh_desc_update[DESC_HASH_MAX_USED_LEN];
-	u32 sh_desc_update_first[DESC_HASH_MAX_USED_LEN];
-	u32 sh_desc_fin[DESC_HASH_MAX_USED_LEN];
-	u32 sh_desc_digest[DESC_HASH_MAX_USED_LEN];
-	u32 sh_desc_finup[DESC_HASH_MAX_USED_LEN];
+	u32 *sh_desc_update;
+	u32 *sh_desc_update_first;
+	u32 *sh_desc_fin;
+	u32 *sh_desc_digest;
+	u32 *sh_desc_finup;
 	dma_addr_t sh_desc_update_dma;
 	dma_addr_t sh_desc_update_first_dma;
 	dma_addr_t sh_desc_fin_dma;
@@ -123,9 +123,9 @@ struct caam_hash_ctx {
 struct caam_hash_state {
 	dma_addr_t buf_dma;
 	dma_addr_t ctx_dma;
-	u8 buf_0[CAAM_MAX_HASH_BLOCK_SIZE] ____cacheline_aligned;
+	u8 *buf_0;
 	int buflen_0;
-	u8 buf_1[CAAM_MAX_HASH_BLOCK_SIZE] ____cacheline_aligned;
+	u8 *buf_1;
 	int buflen_1;
 	u8 caam_ctx[MAX_CTX_LEN] ____cacheline_aligned;
 	int (*update)(struct ahash_request *req);
@@ -319,7 +319,7 @@ static int ahash_set_sh_desc(struct crypto_ahash *ahash)
 		have_key = OP_ALG_AAI_HMAC_PRECOMP;
 
 	/* ahash_update shared descriptor */
-	desc = ctx->sh_desc_update;
+	desc = kmalloc(DESC_HASH_MAX_USED_BYTES, GFP_KERNEL | GFP_DMA);
 
 	init_sh_desc(desc, HDR_SHARE_SERIAL);
 
@@ -334,6 +334,7 @@ static int ahash_set_sh_desc(struct crypto_ahash *ahash)
 	/* Load data and write to result or context */
 	ahash_append_load_str(desc, ctx->ctx_len);
 
+	ctx->sh_desc_update = desc;
 	ctx->sh_desc_update_dma = dma_map_single(jrdev, desc, desc_bytes(desc),
 						 DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, ctx->sh_desc_update_dma)) {
@@ -347,11 +348,12 @@ static int ahash_set_sh_desc(struct crypto_ahash *ahash)
 #endif
 
 	/* ahash_update_first shared descriptor */
-	desc = ctx->sh_desc_update_first;
+	desc = kmalloc(DESC_HASH_MAX_USED_BYTES, GFP_KERNEL | GFP_DMA);
 
 	ahash_data_to_out(desc, have_key | ctx->alg_type, OP_ALG_AS_INIT,
 			  ctx->ctx_len, ctx);
 
+	ctx->sh_desc_update_first = desc;
 	ctx->sh_desc_update_first_dma = dma_map_single(jrdev, desc,
 						       desc_bytes(desc),
 						       DMA_TO_DEVICE);
@@ -366,11 +368,12 @@ static int ahash_set_sh_desc(struct crypto_ahash *ahash)
 #endif
 
 	/* ahash_final shared descriptor */
-	desc = ctx->sh_desc_fin;
+	desc = kmalloc(DESC_HASH_MAX_USED_BYTES, GFP_KERNEL | GFP_DMA);
 
 	ahash_ctx_data_to_out(desc, have_key | ctx->alg_type,
 			      OP_ALG_AS_FINALIZE, digestsize, ctx);
 
+	ctx->sh_desc_fin = desc;
 	ctx->sh_desc_fin_dma = dma_map_single(jrdev, desc, desc_bytes(desc),
 					      DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, ctx->sh_desc_fin_dma)) {
@@ -384,11 +387,12 @@ static int ahash_set_sh_desc(struct crypto_ahash *ahash)
 #endif
 
 	/* ahash_finup shared descriptor */
-	desc = ctx->sh_desc_finup;
+	desc = kmalloc(DESC_HASH_MAX_USED_BYTES, GFP_KERNEL | GFP_DMA);
 
 	ahash_ctx_data_to_out(desc, have_key | ctx->alg_type,
 			      OP_ALG_AS_FINALIZE, digestsize, ctx);
 
+	ctx->sh_desc_finup = desc;
 	ctx->sh_desc_finup_dma = dma_map_single(jrdev, desc, desc_bytes(desc),
 						DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, ctx->sh_desc_finup_dma)) {
@@ -402,11 +406,12 @@ static int ahash_set_sh_desc(struct crypto_ahash *ahash)
 #endif
 
 	/* ahash_digest shared descriptor */
-	desc = ctx->sh_desc_digest;
+	desc = kmalloc(DESC_HASH_MAX_USED_BYTES, GFP_KERNEL | GFP_DMA);
 
 	ahash_data_to_out(desc, have_key | ctx->alg_type, OP_ALG_AS_INITFINAL,
 			  digestsize, ctx);
 
+	ctx->sh_desc_digest = desc;
 	ctx->sh_desc_digest_dma = dma_map_single(jrdev, desc,
 						 desc_bytes(desc),
 						 DMA_TO_DEVICE);
@@ -631,10 +636,10 @@ static void ahash_done(struct device *jrdev, u32 *desc, u32 err,
 	struct ahash_request *req = context;
 	struct ahash_edesc *edesc;
 	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
+	struct caam_hash_state *state = ahash_request_ctx(req);
 	int digestsize = crypto_ahash_digestsize(ahash);
 #ifdef DEBUG
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
-	struct caam_hash_state *state = ahash_request_ctx(req);
 
 	dev_err(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
 #endif
@@ -657,6 +662,11 @@ static void ahash_done(struct device *jrdev, u32 *desc, u32 err,
 			       digestsize, 1);
 #endif
 
+	kfree(state->buf_0);
+	kfree(state->buf_1);
+	state->buf_0 = NULL;
+	state->buf_1 = NULL;
+
 	req->base.complete(&req->base, err);
 }
 
@@ -701,10 +711,10 @@ static void ahash_done_ctx_src(struct device *jrdev, u32 *desc, u32 err,
 	struct ahash_request *req = context;
 	struct ahash_edesc *edesc;
 	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
+	struct caam_hash_state *state = ahash_request_ctx(req);
 	int digestsize = crypto_ahash_digestsize(ahash);
 #ifdef DEBUG
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
-	struct caam_hash_state *state = ahash_request_ctx(req);
 
 	dev_err(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
 #endif
@@ -727,6 +737,11 @@ static void ahash_done_ctx_src(struct device *jrdev, u32 *desc, u32 err,
 			       digestsize, 1);
 #endif
 
+	kfree(state->buf_0);
+	kfree(state->buf_1);
+	state->buf_0 = NULL;
+	state->buf_1 = NULL;
+
 	req->base.complete(&req->base, err);
 }
 
@@ -1522,6 +1537,9 @@ static int ahash_init(struct ahash_request *req)
 	state->finup = ahash_finup_first;
 	state->final = ahash_final_no_ctx;
 
+	state->buf_0 = kmalloc(CAAM_MAX_HASH_BLOCK_SIZE, GFP_KERNEL | GFP_DMA);
+	state->buf_1 = kmalloc(CAAM_MAX_HASH_BLOCK_SIZE, GFP_KERNEL | GFP_DMA);
+
 	state->current_buf = 0;
 	state->buf_dma = 0;
 	state->buflen_0 = 0;
@@ -1557,6 +1575,20 @@ static int ahash_export(struct ahash_request *req, void *out)
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
 
+	/*
+	 * Do not export the data buffers. New buffers are
+	 * allocated during import.
+	 */
+	kfree(state->buf_0);
+	kfree(state->buf_1);
+	state->buf_0 = NULL;
+	state->buf_1 = NULL;
+
+	state->current_buf = 0;
+	state->buf_dma = 0;
+	state->buflen_0 = 0;
+	state->buflen_1 = 0;
+
 	memcpy(out, ctx, sizeof(struct caam_hash_ctx));
 	memcpy(out + sizeof(struct caam_hash_ctx), state,
 	       sizeof(struct caam_hash_state));
@@ -1569,6 +1601,10 @@ static int ahash_import(struct ahash_request *req, const void *in)
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
 
+	/* Allocate new data buffers to use for this request */
+	state->buf_0 = kmalloc(CAAM_MAX_HASH_BLOCK_SIZE, GFP_KERNEL | GFP_DMA);
+	state->buf_1 = kmalloc(CAAM_MAX_HASH_BLOCK_SIZE, GFP_KERNEL | GFP_DMA);
+
 	memcpy(ctx, in, sizeof(struct caam_hash_ctx));
 	memcpy(state, in + sizeof(struct caam_hash_ctx),
 	       sizeof(struct caam_hash_state));
@@ -1605,6 +1641,8 @@ static struct caam_hash_template driver_hash[] = {
 			.setkey = ahash_setkey,
 			.halg = {
 				.digestsize = SHA1_DIGEST_SIZE,
+				.statesize = sizeof(struct caam_hash_ctx) +
+					     sizeof(struct caam_hash_state),
 				},
 			},
 		.alg_type = OP_ALG_ALGSEL_SHA1,
@@ -1626,6 +1664,8 @@ static struct caam_hash_template driver_hash[] = {
 			.setkey = ahash_setkey,
 			.halg = {
 				.digestsize = SHA224_DIGEST_SIZE,
+				.statesize = sizeof(struct caam_hash_ctx) +
+					     sizeof(struct caam_hash_state),
 				},
 			},
 		.alg_type = OP_ALG_ALGSEL_SHA224,
@@ -1647,6 +1687,8 @@ static struct caam_hash_template driver_hash[] = {
 			.setkey = ahash_setkey,
 			.halg = {
 				.digestsize = SHA256_DIGEST_SIZE,
+				.statesize = sizeof(struct caam_hash_ctx) +
+					     sizeof(struct caam_hash_state),
 				},
 			},
 		.alg_type = OP_ALG_ALGSEL_SHA256,
@@ -1668,6 +1710,8 @@ static struct caam_hash_template driver_hash[] = {
 			.setkey = ahash_setkey,
 			.halg = {
 				.digestsize = SHA384_DIGEST_SIZE,
+				.statesize = sizeof(struct caam_hash_ctx) +
+					     sizeof(struct caam_hash_state),
 				},
 			},
 		.alg_type = OP_ALG_ALGSEL_SHA384,
@@ -1689,6 +1733,8 @@ static struct caam_hash_template driver_hash[] = {
 			.setkey = ahash_setkey,
 			.halg = {
 				.digestsize = SHA512_DIGEST_SIZE,
+				.statesize = sizeof(struct caam_hash_ctx) +
+					     sizeof(struct caam_hash_state),
 				},
 			},
 		.alg_type = OP_ALG_ALGSEL_SHA512,
@@ -1710,6 +1756,8 @@ static struct caam_hash_template driver_hash[] = {
 			.setkey = ahash_setkey,
 			.halg = {
 				.digestsize = MD5_DIGEST_SIZE,
+				.statesize = sizeof(struct caam_hash_ctx) +
+					     sizeof(struct caam_hash_state),
 				},
 			},
 		.alg_type = OP_ALG_ALGSEL_MD5,
@@ -1796,6 +1844,12 @@ static void caam_hash_cra_exit(struct crypto_tfm *tfm)
 		dma_unmap_single(ctx->jrdev, ctx->sh_desc_finup_dma,
 				 desc_bytes(ctx->sh_desc_finup), DMA_TO_DEVICE);
 
+	kfree(ctx->sh_desc_update);
+	kfree(ctx->sh_desc_update_first);
+	kfree(ctx->sh_desc_fin);
+	kfree(ctx->sh_desc_digest);
+	kfree(ctx->sh_desc_finup);
+
 	caam_jr_free(ctx->jrdev);
 }
 
-- 
2.1.4
