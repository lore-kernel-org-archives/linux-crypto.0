From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH RFC 10/11] crypto: caam: add ahash_edesc_add_src()
Date: Mon, 07 Dec 2015 19:12:46 +0000
Message-ID: <E1a61DK-0007nF-BJ@rmk-PC.arm.linux.org.uk>
References: <20151207191134.GV8644@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:60541 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307AbbLGTMv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Dec 2015 14:12:51 -0500
In-Reply-To: <20151207191134.GV8644@n2100.arm.linux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add a helper to map the source scatterlist into the descriptor.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/caam/caamhash.c | 106 +++++++++++++++++++----------------------
 1 file changed, 49 insertions(+), 57 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 241268d108ec..4e73d3218481 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -789,6 +789,40 @@ static struct ahash_edesc *ahash_edesc_alloc(struct caam_hash_ctx *ctx,
 	return edesc;
 }
 
+static int ahash_edesc_add_src(struct caam_hash_ctx *ctx,
+			       struct ahash_edesc *edesc,
+			       struct ahash_request *req, int nents,
+			       unsigned int first_sg, unsigned int first_bytes)
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
+	append_seq_in_ptr(edesc->hw_desc, src_dma, first_bytes + req->nbytes,
+			  options);
+
+	return 0;
+}
+
 /* submit update job descriptor */
 static int ahash_update_ctx(struct ahash_request *req)
 {
@@ -1112,11 +1146,9 @@ static int ahash_digest(struct ahash_request *req)
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
 	mapped_nents = dma_map_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
@@ -1125,11 +1157,6 @@ static int ahash_digest(struct ahash_request *req)
 		return -ENOMEM;
 	}
 
-	if (mapped_nents > 1)
-		sec4_sg_bytes = mapped_nents * sizeof(struct sec4_sg_entry);
-	else
-		sec4_sg_bytes = 0;
-
 	/* allocate space for base edesc and hw desc commands, link tables */
 	edesc = ahash_edesc_alloc(ctx, mapped_nents > 1 ? mapped_nents : 0,
 				  ctx->sh_desc_digest, ctx->sh_desc_digest_dma,
@@ -1139,28 +1166,16 @@ static int ahash_digest(struct ahash_request *req)
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
+	ret = ahash_edesc_add_src(ctx, edesc, req, mapped_nents, 0, 0);
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
@@ -1471,9 +1486,7 @@ static int ahash_update_first(struct ahash_request *req)
 		&state->buflen_1 : &state->buflen_0;
 	int to_hash;
 	u32 *desc;
-	int sec4_sg_bytes, src_nents, mapped_nents;
-	dma_addr_t src_dma;
-	u32 options;
+	int src_nents, mapped_nents;
 	struct ahash_edesc *edesc;
 	int ret = 0;
 
@@ -1490,11 +1503,6 @@ static int ahash_update_first(struct ahash_request *req)
 			dev_err(jrdev, "unable to map source for DMA\n");
 			return -ENOMEM;
 		}
-		if (mapped_nents > 1)
-			sec4_sg_bytes = mapped_nents *
-					sizeof(struct sec4_sg_entry);
-		else
-			sec4_sg_bytes = 0;
 
 		/*
 		 * allocate space for base edesc and hw desc commands,
@@ -1511,28 +1519,14 @@ static int ahash_update_first(struct ahash_request *req)
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
-				ahash_unmap_ctx(jrdev, edesc, req, ctx->ctx_len,
-						DMA_TO_DEVICE);
-				kfree(edesc);
-				return -ENOMEM;
-			}
-			src_dma = edesc->sec4_sg_dma;
-			options = LDST_SGF;
-		} else {
-			src_dma = sg_dma_address(req->src);
-			options = 0;
+		ret = ahash_edesc_add_src(ctx, edesc, req, mapped_nents, 0, 0);
+		if (ret) {
+			ahash_unmap_ctx(jrdev, edesc, req, ctx->ctx_len,
+					DMA_TO_DEVICE);
+			kfree(edesc);
+			return ret;
 		}
 
 		if (*next_buflen)
@@ -1541,8 +1535,6 @@ static int ahash_update_first(struct ahash_request *req)
 
 		desc = edesc->hw_desc;
 
-		append_seq_in_ptr(desc, src_dma, to_hash, options);
-
 		ret = map_seq_out_ptr_ctx(desc, jrdev, state, ctx->ctx_len);
 		if (ret) {
 			ahash_unmap_ctx(jrdev, edesc, req, ctx->ctx_len,
-- 
2.1.0
