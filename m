From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 10/11] crypto: caam: add ahash_edesc_add_src()
Date: Mon, 08 Aug 2016 18:05:19 +0100
Message-ID: <E1bWnzL-0002WL-As@rmk-PC.armlinux.org.uk>
References: <20160808170400.GC1041@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:57510 "EHLO
	pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbcHHRFZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Aug 2016 13:05:25 -0400
In-Reply-To: <20160808170400.GC1041@n2100.armlinux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add a helper to map the source scatterlist into the descriptor.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/caam/caamhash.c | 137 +++++++++++++++++------------------------
 1 file changed, 57 insertions(+), 80 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 9c3e74e4088e..ea284e3909ef 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -789,6 +789,41 @@ static struct ahash_edesc *ahash_edesc_alloc(struct caam_hash_ctx *ctx,
 	return edesc;
 }
 
+static int ahash_edesc_add_src(struct caam_hash_ctx *ctx,
+			       struct ahash_edesc *edesc,
+			       struct ahash_request *req, int nents,
+			       unsigned int first_sg,
+			       unsigned int first_bytes, size_t to_hash)
+{
+	dma_addr_t src_dma;
+	u32 options;
+
+	if (nents > 1 || first_sg) {
+		struct sec4_sg_entry *sg = edesc->sec4_sg;
+		unsigned int sgsize = sizeof(*sg) * (first_sg + nents);
+
+		sg_to_sec4_sg_last(req->src, nents, sg + first_sg, 0);
+
+		src_dma = dma_map_single(ctx->jrdev, sg, sgsize, DMA_TO_DEVICE);
+		if (dma_mapping_error(ctx->jrdev, src_dma)) {
+			dev_err(ctx->jrdev, "unable to map S/G table\n");
+			return -ENOMEM;
+		}
+
+		edesc->sec4_sg_bytes = sgsize;
+		edesc->sec4_sg_dma = src_dma;
+		options = LDST_SGF;
+	} else {
+		src_dma = sg_dma_address(req->src);
+		options = 0;
+	}
+
+	append_seq_in_ptr(edesc->hw_desc, src_dma, first_bytes + to_hash,
+			  options);
+
+	return 0;
+}
+
 /* submit update job descriptor */
 static int ahash_update_ctx(struct ahash_request *req)
 {
@@ -1018,7 +1053,7 @@ static int ahash_finup_ctx(struct ahash_request *req)
 	int last_buflen = state->current_buf ? state->buflen_0 :
 			  state->buflen_1;
 	u32 *desc;
-	int sec4_sg_bytes, sec4_sg_src_index;
+	int sec4_sg_src_index;
 	int src_nents, mapped_nents;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct ahash_edesc *edesc;
@@ -1042,8 +1077,6 @@ static int ahash_finup_ctx(struct ahash_request *req)
 	}
 
 	sec4_sg_src_index = 1 + (buflen ? 1 : 0);
-	sec4_sg_bytes = (sec4_sg_src_index + mapped_nents) *
-			 sizeof(struct sec4_sg_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
 	edesc = ahash_edesc_alloc(ctx, sec4_sg_src_index + mapped_nents,
@@ -1057,7 +1090,6 @@ static int ahash_finup_ctx(struct ahash_request *req)
 	desc = edesc->hw_desc;
 
 	edesc->src_nents = src_nents;
-	edesc->sec4_sg_bytes = sec4_sg_bytes;
 
 	ret = ctx_map_to_sec4_sg(desc, jrdev, state, ctx->ctx_len,
 				 edesc->sec4_sg, DMA_TO_DEVICE);
@@ -1068,19 +1100,11 @@ static int ahash_finup_ctx(struct ahash_request *req)
 						buf, state->buf_dma, buflen,
 						last_buflen);
 
-	sg_to_sec4_sg_last(req->src, mapped_nents,
-			   edesc->sec4_sg + sec4_sg_src_index, 0);
-
-	edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
-					    sec4_sg_bytes, DMA_TO_DEVICE);
-	if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
-		dev_err(jrdev, "unable to map S/G table\n");
-		ret = -ENOMEM;
+	ret = ahash_edesc_add_src(ctx, edesc, req, mapped_nents,
+				  sec4_sg_src_index, ctx->ctx_len + buflen,
+				  req->nbytes);
+	if (ret)
 		goto err;
-	}
-
-	append_seq_in_ptr(desc, edesc->sec4_sg_dma, ctx->ctx_len +
-			       buflen + req->nbytes, LDST_SGF);
 
 	edesc->dst_dma = map_seq_out_ptr_result(desc, jrdev, req->result,
 						digestsize);
@@ -1116,11 +1140,9 @@ static int ahash_digest(struct ahash_request *req)
 		       CRYPTO_TFM_REQ_MAY_SLEEP)) ? GFP_KERNEL : GFP_ATOMIC;
 	u32 *desc;
 	int digestsize = crypto_ahash_digestsize(ahash);
-	int src_nents, mapped_nents, sec4_sg_bytes;
-	dma_addr_t src_dma;
+	int src_nents, mapped_nents;
 	struct ahash_edesc *edesc;
 	int ret = 0;
-	u32 options;
 
 	src_nents = sg_nents_for_len(req->src, req->nbytes);
 	if (src_nents < 0) {
@@ -1139,11 +1161,6 @@ static int ahash_digest(struct ahash_request *req)
 		mapped_nents = 0;
 	}
 
-	if (mapped_nents > 1)
-		sec4_sg_bytes = mapped_nents * sizeof(struct sec4_sg_entry);
-	else
-		sec4_sg_bytes = 0;
-
 	/* allocate space for base edesc and hw desc commands, link tables */
 	edesc = ahash_edesc_alloc(ctx, mapped_nents > 1 ? mapped_nents : 0,
 				  ctx->sh_desc_digest, ctx->sh_desc_digest_dma,
@@ -1153,28 +1170,17 @@ static int ahash_digest(struct ahash_request *req)
 		return -ENOMEM;
 	}
 
-	edesc->sec4_sg_bytes = sec4_sg_bytes;
 	edesc->src_nents = src_nents;
 
-	desc = edesc->hw_desc;
-
-	if (src_nents > 1) {
-		sg_to_sec4_sg_last(req->src, mapped_nents, edesc->sec4_sg, 0);
-		edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
-					    sec4_sg_bytes, DMA_TO_DEVICE);
-		if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
-			dev_err(jrdev, "unable to map S/G table\n");
-			ahash_unmap(jrdev, edesc, req, digestsize);
-			kfree(edesc);
-			return -ENOMEM;
-		}
-		src_dma = edesc->sec4_sg_dma;
-		options = LDST_SGF;
-	} else {
-		src_dma = sg_dma_address(req->src);
-		options = 0;
+	ret = ahash_edesc_add_src(ctx, edesc, req, mapped_nents, 0, 0,
+				  req->nbytes);
+	if (ret) {
+		ahash_unmap(jrdev, edesc, req, digestsize);
+		kfree(edesc);
+		return ret;
 	}
-	append_seq_in_ptr(desc, src_dma, req->nbytes, options);
+
+	desc = edesc->hw_desc;
 
 	edesc->dst_dma = map_seq_out_ptr_result(desc, jrdev, req->result,
 						digestsize);
@@ -1447,20 +1453,15 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 						state->buf_dma, buflen,
 						last_buflen);
 
-	sg_to_sec4_sg_last(req->src, mapped_nents, edesc->sec4_sg + 1, 0);
-
-	edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
-					    sec4_sg_bytes, DMA_TO_DEVICE);
-	if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
+	ret = ahash_edesc_add_src(ctx, edesc, req, mapped_nents, 1, buflen,
+				  req->nbytes);
+	if (ret) {
 		dev_err(jrdev, "unable to map S/G table\n");
 		ahash_unmap(jrdev, edesc, req, digestsize);
 		kfree(edesc);
 		return -ENOMEM;
 	}
 
-	append_seq_in_ptr(desc, edesc->sec4_sg_dma, buflen +
-			       req->nbytes, LDST_SGF);
-
 	edesc->dst_dma = map_seq_out_ptr_result(desc, jrdev, req->result,
 						digestsize);
 	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
@@ -1500,9 +1501,7 @@ static int ahash_update_first(struct ahash_request *req)
 		&state->buflen_1 : &state->buflen_0;
 	int to_hash;
 	u32 *desc;
-	int sec4_sg_bytes, src_nents, mapped_nents;
-	dma_addr_t src_dma;
-	u32 options;
+	int src_nents, mapped_nents;
 	struct ahash_edesc *edesc;
 	int ret = 0;
 
@@ -1528,11 +1527,6 @@ static int ahash_update_first(struct ahash_request *req)
 		} else {
 			mapped_nents = 0;
 		}
-		if (mapped_nents > 1)
-			sec4_sg_bytes = mapped_nents *
-					sizeof(struct sec4_sg_entry);
-		else
-			sec4_sg_bytes = 0;
 
 		/*
 		 * allocate space for base edesc and hw desc commands,
@@ -1549,27 +1543,12 @@ static int ahash_update_first(struct ahash_request *req)
 		}
 
 		edesc->src_nents = src_nents;
-		edesc->sec4_sg_bytes = sec4_sg_bytes;
 		edesc->dst_dma = 0;
 
-		if (src_nents > 1) {
-			sg_to_sec4_sg_last(req->src, mapped_nents,
-					   edesc->sec4_sg, 0);
-			edesc->sec4_sg_dma = dma_map_single(jrdev,
-							    edesc->sec4_sg,
-							    sec4_sg_bytes,
-							    DMA_TO_DEVICE);
-			if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
-				dev_err(jrdev, "unable to map S/G table\n");
-				ret = -ENOMEM;
-				goto err;
-			}
-			src_dma = edesc->sec4_sg_dma;
-			options = LDST_SGF;
-		} else {
-			src_dma = sg_dma_address(req->src);
-			options = 0;
-		}
+		ret = ahash_edesc_add_src(ctx, edesc, req, mapped_nents, 0, 0,
+					  to_hash);
+		if (ret)
+			goto err;
 
 		if (*next_buflen)
 			scatterwalk_map_and_copy(next_buf, req->src, to_hash,
@@ -1577,8 +1556,6 @@ static int ahash_update_first(struct ahash_request *req)
 
 		desc = edesc->hw_desc;
 
-		append_seq_in_ptr(desc, src_dma, to_hash, options);
-
 		ret = map_seq_out_ptr_ctx(desc, jrdev, state, ctx->ctx_len);
 		if (ret)
 			goto err;
-- 
2.1.0
