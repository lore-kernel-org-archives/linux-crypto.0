From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 09/11] crypto: caam: move job descriptor initialisation to
 ahash_edesc_alloc()
Date: Mon, 08 Aug 2016 18:05:13 +0100
Message-ID: <E1bWnzF-0002WE-VC@rmk-PC.armlinux.org.uk>
References: <20160808170400.GC1041@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:57505 "EHLO
	pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbcHHRFU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Aug 2016 13:05:20 -0400
In-Reply-To: <20160808170400.GC1041@n2100.armlinux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/caam/caamhash.c | 84 +++++++++++++++++-------------------------
 1 file changed, 34 insertions(+), 50 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 2c2c15b63059..9c3e74e4088e 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -770,7 +770,9 @@ static void ahash_done_ctx_dst(struct device *jrdev, u32 *desc, u32 err,
  * and space for hardware scatter table containing sg_num entries.
  */
 static struct ahash_edesc *ahash_edesc_alloc(struct caam_hash_ctx *ctx,
-					     int sg_num, gfp_t flags)
+					     int sg_num, u32 *sh_desc,
+					     dma_addr_t sh_desc_dma,
+					     gfp_t flags)
 {
 	struct ahash_edesc *edesc;
 	unsigned int sg_size = sg_num * sizeof(struct sec4_sg_entry);
@@ -781,6 +783,9 @@ static struct ahash_edesc *ahash_edesc_alloc(struct caam_hash_ctx *ctx,
 		return NULL;
 	}
 
+	init_job_desc_shared(edesc->hw_desc, sh_desc_dma, desc_len(sh_desc),
+			     HDR_SHARE_DEFER | HDR_REVERSE);
+
 	return edesc;
 }
 
@@ -799,12 +804,10 @@ static int ahash_update_ctx(struct ahash_request *req)
 	int *next_buflen = state->current_buf ? &state->buflen_0 :
 			   &state->buflen_1, last_buflen;
 	int in_len = *buflen + req->nbytes, to_hash;
-	u32 *sh_desc = ctx->sh_desc_update, *desc;
-	dma_addr_t ptr = ctx->sh_desc_update_dma;
+	u32 *desc;
 	int src_nents, mapped_nents, sec4_sg_bytes, sec4_sg_src_index;
 	struct ahash_edesc *edesc;
 	int ret = 0;
-	int sh_len;
 
 	last_buflen = *next_buflen;
 	*next_buflen = in_len & (crypto_tfm_alg_blocksize(&ahash->base) - 1);
@@ -838,7 +841,8 @@ static int ahash_update_ctx(struct ahash_request *req)
 		 * link tables
 		 */
 		edesc = ahash_edesc_alloc(ctx, sec4_sg_src_index + mapped_nents,
-					  flags);
+					  ctx->sh_desc_update,
+					  ctx->sh_desc_update_dma, flags);
 		if (!edesc) {
 			dma_unmap_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
 			return -ENOMEM;
@@ -872,10 +876,7 @@ static int ahash_update_ctx(struct ahash_request *req)
 
 		state->current_buf = !state->current_buf;
 
-		sh_len = desc_len(sh_desc);
 		desc = edesc->hw_desc;
-		init_job_desc_shared(desc, ptr, sh_len, HDR_SHARE_DEFER |
-				     HDR_REVERSE);
 
 		edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
 						     sec4_sg_bytes,
@@ -936,25 +937,23 @@ static int ahash_final_ctx(struct ahash_request *req)
 	int buflen = state->current_buf ? state->buflen_1 : state->buflen_0;
 	int last_buflen = state->current_buf ? state->buflen_0 :
 			  state->buflen_1;
-	u32 *sh_desc = ctx->sh_desc_fin, *desc;
-	dma_addr_t ptr = ctx->sh_desc_fin_dma;
+	u32 *desc;
 	int sec4_sg_bytes, sec4_sg_src_index;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct ahash_edesc *edesc;
 	int ret = 0;
-	int sh_len;
 
 	sec4_sg_src_index = 1 + (buflen ? 1 : 0);
 	sec4_sg_bytes = sec4_sg_src_index * sizeof(struct sec4_sg_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = ahash_edesc_alloc(ctx, sec4_sg_src_index, flags);
+	edesc = ahash_edesc_alloc(ctx, sec4_sg_src_index,
+				  ctx->sh_desc_fin, ctx->sh_desc_fin_dma,
+				  flags);
 	if (!edesc)
 		return -ENOMEM;
 
-	sh_len = desc_len(sh_desc);
 	desc = edesc->hw_desc;
-	init_job_desc_shared(desc, ptr, sh_len, HDR_SHARE_DEFER | HDR_REVERSE);
 
 	edesc->sec4_sg_bytes = sec4_sg_bytes;
 	edesc->src_nents = 0;
@@ -1018,14 +1017,12 @@ static int ahash_finup_ctx(struct ahash_request *req)
 	int buflen = state->current_buf ? state->buflen_1 : state->buflen_0;
 	int last_buflen = state->current_buf ? state->buflen_0 :
 			  state->buflen_1;
-	u32 *sh_desc = ctx->sh_desc_finup, *desc;
-	dma_addr_t ptr = ctx->sh_desc_finup_dma;
+	u32 *desc;
 	int sec4_sg_bytes, sec4_sg_src_index;
 	int src_nents, mapped_nents;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct ahash_edesc *edesc;
 	int ret = 0;
-	int sh_len;
 
 	src_nents = sg_nents_for_len(req->src, req->nbytes);
 	if (src_nents < 0) {
@@ -1050,15 +1047,14 @@ static int ahash_finup_ctx(struct ahash_request *req)
 
 	/* allocate space for base edesc and hw desc commands, link tables */
 	edesc = ahash_edesc_alloc(ctx, sec4_sg_src_index + mapped_nents,
+				  ctx->sh_desc_finup, ctx->sh_desc_finup_dma,
 				  flags);
 	if (!edesc) {
 		dma_unmap_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
 		return -ENOMEM;
 	}
 
-	sh_len = desc_len(sh_desc);
 	desc = edesc->hw_desc;
-	init_job_desc_shared(desc, ptr, sh_len, HDR_SHARE_DEFER | HDR_REVERSE);
 
 	edesc->src_nents = src_nents;
 	edesc->sec4_sg_bytes = sec4_sg_bytes;
@@ -1118,15 +1114,13 @@ static int ahash_digest(struct ahash_request *req)
 	struct device *jrdev = ctx->jrdev;
 	gfp_t flags = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
 		       CRYPTO_TFM_REQ_MAY_SLEEP)) ? GFP_KERNEL : GFP_ATOMIC;
-	u32 *sh_desc = ctx->sh_desc_digest, *desc;
-	dma_addr_t ptr = ctx->sh_desc_digest_dma;
+	u32 *desc;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	int src_nents, mapped_nents, sec4_sg_bytes;
 	dma_addr_t src_dma;
 	struct ahash_edesc *edesc;
 	int ret = 0;
 	u32 options;
-	int sh_len;
 
 	src_nents = sg_nents_for_len(req->src, req->nbytes);
 	if (src_nents < 0) {
@@ -1152,6 +1146,7 @@ static int ahash_digest(struct ahash_request *req)
 
 	/* allocate space for base edesc and hw desc commands, link tables */
 	edesc = ahash_edesc_alloc(ctx, mapped_nents > 1 ? mapped_nents : 0,
+				  ctx->sh_desc_digest, ctx->sh_desc_digest_dma,
 				  flags);
 	if (!edesc) {
 		dma_unmap_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
@@ -1161,9 +1156,7 @@ static int ahash_digest(struct ahash_request *req)
 	edesc->sec4_sg_bytes = sec4_sg_bytes;
 	edesc->src_nents = src_nents;
 
-	sh_len = desc_len(sh_desc);
 	desc = edesc->hw_desc;
-	init_job_desc_shared(desc, ptr, sh_len, HDR_SHARE_DEFER | HDR_REVERSE);
 
 	if (src_nents > 1) {
 		sg_to_sec4_sg_last(req->src, mapped_nents, edesc->sec4_sg, 0);
@@ -1219,21 +1212,18 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 		       CRYPTO_TFM_REQ_MAY_SLEEP)) ? GFP_KERNEL : GFP_ATOMIC;
 	u8 *buf = state->current_buf ? state->buf_1 : state->buf_0;
 	int buflen = state->current_buf ? state->buflen_1 : state->buflen_0;
-	u32 *sh_desc = ctx->sh_desc_digest, *desc;
-	dma_addr_t ptr = ctx->sh_desc_digest_dma;
+	u32 *desc;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct ahash_edesc *edesc;
 	int ret = 0;
-	int sh_len;
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = ahash_edesc_alloc(ctx, 0, flags);
+	edesc = ahash_edesc_alloc(ctx, 0, ctx->sh_desc_digest,
+				  ctx->sh_desc_digest_dma, flags);
 	if (!edesc)
 		return -ENOMEM;
 
-	sh_len = desc_len(sh_desc);
 	desc = edesc->hw_desc;
-	init_job_desc_shared(desc, ptr, sh_len, HDR_SHARE_DEFER | HDR_REVERSE);
 
 	state->buf_dma = dma_map_single(jrdev, buf, buflen, DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, state->buf_dma)) {
@@ -1288,10 +1278,8 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 	int in_len = *buflen + req->nbytes, to_hash;
 	int sec4_sg_bytes, src_nents, mapped_nents;
 	struct ahash_edesc *edesc;
-	u32 *desc, *sh_desc = ctx->sh_desc_update_first;
-	dma_addr_t ptr = ctx->sh_desc_update_first_dma;
+	u32 *desc;
 	int ret = 0;
-	int sh_len;
 
 	*next_buflen = in_len & (crypto_tfm_alg_blocksize(&ahash->base) - 1);
 	to_hash = in_len - *next_buflen;
@@ -1322,7 +1310,10 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 		 * allocate space for base edesc and hw desc commands,
 		 * link tables
 		 */
-		edesc = ahash_edesc_alloc(ctx, 1 + mapped_nents, flags);
+		edesc = ahash_edesc_alloc(ctx, 1 + mapped_nents,
+					  ctx->sh_desc_update_first,
+					  ctx->sh_desc_update_first_dma,
+					  flags);
 		if (!edesc) {
 			dma_unmap_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
 			return -ENOMEM;
@@ -1345,10 +1336,7 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 
 		state->current_buf = !state->current_buf;
 
-		sh_len = desc_len(sh_desc);
 		desc = edesc->hw_desc;
-		init_job_desc_shared(desc, ptr, sh_len, HDR_SHARE_DEFER |
-				     HDR_REVERSE);
 
 		edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
 						    sec4_sg_bytes,
@@ -1414,12 +1402,10 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 	int buflen = state->current_buf ? state->buflen_1 : state->buflen_0;
 	int last_buflen = state->current_buf ? state->buflen_0 :
 			  state->buflen_1;
-	u32 *sh_desc = ctx->sh_desc_digest, *desc;
-	dma_addr_t ptr = ctx->sh_desc_digest_dma;
+	u32 *desc;
 	int sec4_sg_bytes, sec4_sg_src_index, src_nents, mapped_nents;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct ahash_edesc *edesc;
-	int sh_len;
 	int ret = 0;
 
 	src_nents = sg_nents_for_len(req->src, req->nbytes);
@@ -1444,15 +1430,15 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 			 sizeof(struct sec4_sg_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = ahash_edesc_alloc(ctx, sec4_sg_src_index + mapped_nents, flags);
+	edesc = ahash_edesc_alloc(ctx, sec4_sg_src_index + mapped_nents,
+				  ctx->sh_desc_digest, ctx->sh_desc_digest_dma,
+				  flags);
 	if (!edesc) {
 		dma_unmap_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
 		return -ENOMEM;
 	}
 
-	sh_len = desc_len(sh_desc);
 	desc = edesc->hw_desc;
-	init_job_desc_shared(desc, ptr, sh_len, HDR_SHARE_DEFER | HDR_REVERSE);
 
 	edesc->src_nents = src_nents;
 	edesc->sec4_sg_bytes = sec4_sg_bytes;
@@ -1513,14 +1499,12 @@ static int ahash_update_first(struct ahash_request *req)
 	int *next_buflen = state->current_buf ?
 		&state->buflen_1 : &state->buflen_0;
 	int to_hash;
-	u32 *sh_desc = ctx->sh_desc_update_first, *desc;
-	dma_addr_t ptr = ctx->sh_desc_update_first_dma;
+	u32 *desc;
 	int sec4_sg_bytes, src_nents, mapped_nents;
 	dma_addr_t src_dma;
 	u32 options;
 	struct ahash_edesc *edesc;
 	int ret = 0;
-	int sh_len;
 
 	*next_buflen = req->nbytes & (crypto_tfm_alg_blocksize(&ahash->base) -
 				      1);
@@ -1555,7 +1539,10 @@ static int ahash_update_first(struct ahash_request *req)
 		 * link tables
 		 */
 		edesc = ahash_edesc_alloc(ctx, mapped_nents > 1 ?
-					  mapped_nents : 0, flags);
+					  mapped_nents : 0,
+					  ctx->sh_desc_update_first,
+					  ctx->sh_desc_update_first_dma,
+					  flags);
 		if (!edesc) {
 			dma_unmap_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
 			return -ENOMEM;
@@ -1588,10 +1575,7 @@ static int ahash_update_first(struct ahash_request *req)
 			scatterwalk_map_and_copy(next_buf, req->src, to_hash,
 						 *next_buflen, 0);
 
-		sh_len = desc_len(sh_desc);
 		desc = edesc->hw_desc;
-		init_job_desc_shared(desc, ptr, sh_len, HDR_SHARE_DEFER |
-				     HDR_REVERSE);
 
 		append_seq_in_ptr(desc, src_dma, to_hash, options);
 
-- 
2.1.0
