From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH RFC 06/11] crypto: caam: ensure that we clean up after an
 error
Date: Mon, 07 Dec 2015 19:12:25 +0000
Message-ID: <E1a61Cz-0007mm-QP@rmk-PC.arm.linux.org.uk>
References: <20151207191134.GV8644@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:60525 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307AbbLGTMb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Dec 2015 14:12:31 -0500
In-Reply-To: <20151207191134.GV8644@n2100.arm.linux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Ensure that we clean up allocations and DMA mappings after encountering
an error rather than just giving up and leaking memory and resources.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/caam/caamhash.c | 57 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 52 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index d48974d1897d..076cfddf32bb 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -824,8 +824,12 @@ static int ahash_update_ctx(struct ahash_request *req)
 
 		ret = ctx_map_to_sec4_sg(desc, jrdev, state, ctx->ctx_len,
 					 edesc->sec4_sg, DMA_BIDIRECTIONAL);
-		if (ret)
+		if (ret) {
+			ahash_unmap_ctx(jrdev, edesc, req, ctx->ctx_len,
+					DMA_BIDIRECTIONAL);
+			kfree(edesc);
 			return ret;
+		}
 
 		state->buf_dma = try_buf_map_to_sec4_sg(jrdev,
 							edesc->sec4_sg + 1,
@@ -856,6 +860,9 @@ static int ahash_update_ctx(struct ahash_request *req)
 						     DMA_TO_DEVICE);
 		if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
 			dev_err(jrdev, "unable to map S/G table\n");
+			ahash_unmap_ctx(jrdev, edesc, req, ctx->ctx_len,
+					DMA_BIDIRECTIONAL);
+			kfree(edesc);
 			return -ENOMEM;
 		}
 
@@ -934,8 +941,11 @@ static int ahash_final_ctx(struct ahash_request *req)
 
 	ret = ctx_map_to_sec4_sg(desc, jrdev, state, ctx->ctx_len,
 				 edesc->sec4_sg, DMA_TO_DEVICE);
-	if (ret)
+	if (ret) {
+		ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_FROM_DEVICE);
+		kfree(edesc);
 		return ret;
+	}
 
 	state->buf_dma = try_buf_map_to_sec4_sg(jrdev, edesc->sec4_sg + 1,
 						buf, state->buf_dma, buflen,
@@ -946,6 +956,8 @@ static int ahash_final_ctx(struct ahash_request *req)
 					    sec4_sg_bytes, DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
 		dev_err(jrdev, "unable to map S/G table\n");
+		ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_FROM_DEVICE);
+		kfree(edesc);
 		return -ENOMEM;
 	}
 
@@ -956,6 +968,8 @@ static int ahash_final_ctx(struct ahash_request *req)
 						digestsize);
 	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
 		dev_err(jrdev, "unable to map dst\n");
+		ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_FROM_DEVICE);
+		kfree(edesc);
 		return -ENOMEM;
 	}
 
@@ -1017,8 +1031,11 @@ static int ahash_finup_ctx(struct ahash_request *req)
 
 	ret = ctx_map_to_sec4_sg(desc, jrdev, state, ctx->ctx_len,
 				 edesc->sec4_sg, DMA_TO_DEVICE);
-	if (ret)
+	if (ret) {
+		ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_FROM_DEVICE);
+		kfree(edesc);
 		return ret;
+	}
 
 	state->buf_dma = try_buf_map_to_sec4_sg(jrdev, edesc->sec4_sg + 1,
 						buf, state->buf_dma, buflen,
@@ -1031,6 +1048,8 @@ static int ahash_finup_ctx(struct ahash_request *req)
 					    sec4_sg_bytes, DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
 		dev_err(jrdev, "unable to map S/G table\n");
+		ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_FROM_DEVICE);
+		kfree(edesc);
 		return -ENOMEM;
 	}
 
@@ -1041,6 +1060,8 @@ static int ahash_finup_ctx(struct ahash_request *req)
 						digestsize);
 	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
 		dev_err(jrdev, "unable to map dst\n");
+		ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_FROM_DEVICE);
+		kfree(edesc);
 		return -ENOMEM;
 	}
 
@@ -1104,6 +1125,8 @@ static int ahash_digest(struct ahash_request *req)
 					    sec4_sg_bytes, DMA_TO_DEVICE);
 		if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
 			dev_err(jrdev, "unable to map S/G table\n");
+			ahash_unmap(jrdev, edesc, req, digestsize);
+			kfree(edesc);
 			return -ENOMEM;
 		}
 		src_dma = edesc->sec4_sg_dma;
@@ -1118,6 +1141,8 @@ static int ahash_digest(struct ahash_request *req)
 						digestsize);
 	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
 		dev_err(jrdev, "unable to map dst\n");
+		ahash_unmap(jrdev, edesc, req, digestsize);
+		kfree(edesc);
 		return -ENOMEM;
 	}
 
@@ -1170,6 +1195,8 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 	state->buf_dma = dma_map_single(jrdev, buf, buflen, DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, state->buf_dma)) {
 		dev_err(jrdev, "unable to map src\n");
+		ahash_unmap(jrdev, edesc, req, digestsize);
+		kfree(edesc);
 		return -ENOMEM;
 	}
 
@@ -1179,6 +1206,8 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 						digestsize);
 	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
 		dev_err(jrdev, "unable to map dst\n");
+		ahash_unmap(jrdev, edesc, req, digestsize);
+		kfree(edesc);
 		return -ENOMEM;
 	}
 	edesc->src_nents = 0;
@@ -1268,14 +1297,21 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 						    DMA_TO_DEVICE);
 		if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
 			dev_err(jrdev, "unable to map S/G table\n");
+			ahash_unmap_ctx(jrdev, edesc, req, ctx->ctx_len,
+					DMA_TO_DEVICE);
+			kfree(edesc);
 			return -ENOMEM;
 		}
 
 		append_seq_in_ptr(desc, edesc->sec4_sg_dma, to_hash, LDST_SGF);
 
 		ret = map_seq_out_ptr_ctx(desc, jrdev, state, ctx->ctx_len);
-		if (ret)
+		if (ret) {
+			ahash_unmap_ctx(jrdev, edesc, req, ctx->ctx_len,
+					DMA_TO_DEVICE);
+			kfree(edesc);
 			return ret;
+		}
 
 #ifdef DEBUG
 		print_hex_dump(KERN_ERR, "jobdesc@"__stringify(__LINE__)": ",
@@ -1361,6 +1397,8 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 					    sec4_sg_bytes, DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
 		dev_err(jrdev, "unable to map S/G table\n");
+		ahash_unmap(jrdev, edesc, req, digestsize);
+		kfree(edesc);
 		return -ENOMEM;
 	}
 
@@ -1371,6 +1409,8 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 						digestsize);
 	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
 		dev_err(jrdev, "unable to map dst\n");
+		ahash_unmap(jrdev, edesc, req, digestsize);
+		kfree(edesc);
 		return -ENOMEM;
 	}
 
@@ -1451,6 +1491,9 @@ static int ahash_update_first(struct ahash_request *req)
 							    DMA_TO_DEVICE);
 			if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
 				dev_err(jrdev, "unable to map S/G table\n");
+				ahash_unmap_ctx(jrdev, edesc, req, ctx->ctx_len,
+						DMA_TO_DEVICE);
+				kfree(edesc);
 				return -ENOMEM;
 			}
 			src_dma = edesc->sec4_sg_dma;
@@ -1472,8 +1515,12 @@ static int ahash_update_first(struct ahash_request *req)
 		append_seq_in_ptr(desc, src_dma, to_hash, options);
 
 		ret = map_seq_out_ptr_ctx(desc, jrdev, state, ctx->ctx_len);
-		if (ret)
+		if (ret) {
+			ahash_unmap_ctx(jrdev, edesc, req, ctx->ctx_len,
+					DMA_TO_DEVICE);
+			kfree(edesc);
 			return ret;
+		}
 
 #ifdef DEBUG
 		print_hex_dump(KERN_ERR, "jobdesc@"__stringify(__LINE__)": ",
-- 
2.1.0
