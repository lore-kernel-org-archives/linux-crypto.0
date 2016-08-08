From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 06/11] crypto: caam: ensure that we clean up after an error
Date: Mon, 08 Aug 2016 18:04:58 +0100
Message-ID: <E1bWnz0-0002Vu-30@rmk-PC.armlinux.org.uk>
References: <20160808170400.GC1041@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:57491 "EHLO
	pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbcHHRFD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Aug 2016 13:05:03 -0400
In-Reply-To: <20160808170400.GC1041@n2100.armlinux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Ensure that we clean up allocations and DMA mappings after encountering
an error rather than just giving up and leaking memory and resources.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/caam/caamhash.c | 132 ++++++++++++++++++++++++-----------------
 1 file changed, 79 insertions(+), 53 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index d2129be43bf1..e1925bf3a7cc 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -829,7 +829,7 @@ static int ahash_update_ctx(struct ahash_request *req)
 		ret = ctx_map_to_sec4_sg(desc, jrdev, state, ctx->ctx_len,
 					 edesc->sec4_sg, DMA_BIDIRECTIONAL);
 		if (ret)
-			return ret;
+			goto err;
 
 		state->buf_dma = try_buf_map_to_sec4_sg(jrdev,
 							edesc->sec4_sg + 1,
@@ -860,7 +860,8 @@ static int ahash_update_ctx(struct ahash_request *req)
 						     DMA_TO_DEVICE);
 		if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
 			dev_err(jrdev, "unable to map S/G table\n");
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto err;
 		}
 
 		append_seq_in_ptr(desc, edesc->sec4_sg_dma, ctx->ctx_len +
@@ -875,13 +876,10 @@ static int ahash_update_ctx(struct ahash_request *req)
 #endif
 
 		ret = caam_jr_enqueue(jrdev, desc, ahash_done_bi, req);
-		if (!ret) {
-			ret = -EINPROGRESS;
-		} else {
-			ahash_unmap_ctx(jrdev, edesc, req, ctx->ctx_len,
-					   DMA_BIDIRECTIONAL);
-			kfree(edesc);
-		}
+		if (ret)
+			goto err;
+
+		ret = -EINPROGRESS;
 	} else if (*next_buflen) {
 		scatterwalk_map_and_copy(buf + *buflen, req->src, 0,
 					 req->nbytes, 0);
@@ -897,6 +895,11 @@ static int ahash_update_ctx(struct ahash_request *req)
 #endif
 
 	return ret;
+
+ err:
+	ahash_unmap_ctx(jrdev, edesc, req, ctx->ctx_len, DMA_BIDIRECTIONAL);
+	kfree(edesc);
+	return ret;
 }
 
 static int ahash_final_ctx(struct ahash_request *req)
@@ -939,7 +942,7 @@ static int ahash_final_ctx(struct ahash_request *req)
 	ret = ctx_map_to_sec4_sg(desc, jrdev, state, ctx->ctx_len,
 				 edesc->sec4_sg, DMA_TO_DEVICE);
 	if (ret)
-		return ret;
+		goto err;
 
 	state->buf_dma = try_buf_map_to_sec4_sg(jrdev, edesc->sec4_sg + 1,
 						buf, state->buf_dma, buflen,
@@ -951,7 +954,8 @@ static int ahash_final_ctx(struct ahash_request *req)
 					    sec4_sg_bytes, DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
 		dev_err(jrdev, "unable to map S/G table\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err;
 	}
 
 	append_seq_in_ptr(desc, edesc->sec4_sg_dma, ctx->ctx_len + buflen,
@@ -961,7 +965,8 @@ static int ahash_final_ctx(struct ahash_request *req)
 						digestsize);
 	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
 		dev_err(jrdev, "unable to map dst\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err;
 	}
 
 #ifdef DEBUG
@@ -970,13 +975,14 @@ static int ahash_final_ctx(struct ahash_request *req)
 #endif
 
 	ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, req);
-	if (!ret) {
-		ret = -EINPROGRESS;
-	} else {
-		ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_FROM_DEVICE);
-		kfree(edesc);
-	}
+	if (ret)
+		goto err;
 
+	return -EINPROGRESS;
+
+err:
+	ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_FROM_DEVICE);
+	kfree(edesc);
 	return ret;
 }
 
@@ -1027,7 +1033,7 @@ static int ahash_finup_ctx(struct ahash_request *req)
 	ret = ctx_map_to_sec4_sg(desc, jrdev, state, ctx->ctx_len,
 				 edesc->sec4_sg, DMA_TO_DEVICE);
 	if (ret)
-		return ret;
+		goto err;
 
 	state->buf_dma = try_buf_map_to_sec4_sg(jrdev, edesc->sec4_sg + 1,
 						buf, state->buf_dma, buflen,
@@ -1040,7 +1046,8 @@ static int ahash_finup_ctx(struct ahash_request *req)
 					    sec4_sg_bytes, DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
 		dev_err(jrdev, "unable to map S/G table\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err;
 	}
 
 	append_seq_in_ptr(desc, edesc->sec4_sg_dma, ctx->ctx_len +
@@ -1050,7 +1057,8 @@ static int ahash_finup_ctx(struct ahash_request *req)
 						digestsize);
 	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
 		dev_err(jrdev, "unable to map dst\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err;
 	}
 
 #ifdef DEBUG
@@ -1059,13 +1067,14 @@ static int ahash_finup_ctx(struct ahash_request *req)
 #endif
 
 	ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, req);
-	if (!ret) {
-		ret = -EINPROGRESS;
-	} else {
-		ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_FROM_DEVICE);
-		kfree(edesc);
-	}
+	if (ret)
+		goto err;
 
+	return -EINPROGRESS;
+
+err:
+	ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_FROM_DEVICE);
+	kfree(edesc);
 	return ret;
 }
 
@@ -1117,6 +1126,8 @@ static int ahash_digest(struct ahash_request *req)
 					    sec4_sg_bytes, DMA_TO_DEVICE);
 		if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
 			dev_err(jrdev, "unable to map S/G table\n");
+			ahash_unmap(jrdev, edesc, req, digestsize);
+			kfree(edesc);
 			return -ENOMEM;
 		}
 		src_dma = edesc->sec4_sg_dma;
@@ -1131,6 +1142,8 @@ static int ahash_digest(struct ahash_request *req)
 						digestsize);
 	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
 		dev_err(jrdev, "unable to map dst\n");
+		ahash_unmap(jrdev, edesc, req, digestsize);
+		kfree(edesc);
 		return -ENOMEM;
 	}
 
@@ -1183,6 +1196,8 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 	state->buf_dma = dma_map_single(jrdev, buf, buflen, DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, state->buf_dma)) {
 		dev_err(jrdev, "unable to map src\n");
+		ahash_unmap(jrdev, edesc, req, digestsize);
+		kfree(edesc);
 		return -ENOMEM;
 	}
 
@@ -1192,6 +1207,8 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 						digestsize);
 	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
 		dev_err(jrdev, "unable to map dst\n");
+		ahash_unmap(jrdev, edesc, req, digestsize);
+		kfree(edesc);
 		return -ENOMEM;
 	}
 	edesc->src_nents = 0;
@@ -1285,14 +1302,15 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 						    DMA_TO_DEVICE);
 		if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
 			dev_err(jrdev, "unable to map S/G table\n");
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto err;
 		}
 
 		append_seq_in_ptr(desc, edesc->sec4_sg_dma, to_hash, LDST_SGF);
 
 		ret = map_seq_out_ptr_ctx(desc, jrdev, state, ctx->ctx_len);
 		if (ret)
-			return ret;
+			goto err;
 
 #ifdef DEBUG
 		print_hex_dump(KERN_ERR, "jobdesc@"__stringify(__LINE__)": ",
@@ -1301,16 +1319,13 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 #endif
 
 		ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_dst, req);
-		if (!ret) {
-			ret = -EINPROGRESS;
-			state->update = ahash_update_ctx;
-			state->finup = ahash_finup_ctx;
-			state->final = ahash_final_ctx;
-		} else {
-			ahash_unmap_ctx(jrdev, edesc, req, ctx->ctx_len,
-					DMA_TO_DEVICE);
-			kfree(edesc);
-		}
+		if (ret)
+			goto err;
+
+		ret = -EINPROGRESS;
+		state->update = ahash_update_ctx;
+		state->finup = ahash_finup_ctx;
+		state->final = ahash_final_ctx;
 	} else if (*next_buflen) {
 		scatterwalk_map_and_copy(buf + *buflen, req->src, 0,
 					 req->nbytes, 0);
@@ -1326,6 +1341,11 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 #endif
 
 	return ret;
+
+err:
+	ahash_unmap_ctx(jrdev, edesc, req, ctx->ctx_len, DMA_TO_DEVICE);
+	kfree(edesc);
+	return ret;
 }
 
 /* submit ahash finup if it the first job descriptor after update */
@@ -1382,6 +1402,8 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 					    sec4_sg_bytes, DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
 		dev_err(jrdev, "unable to map S/G table\n");
+		ahash_unmap(jrdev, edesc, req, digestsize);
+		kfree(edesc);
 		return -ENOMEM;
 	}
 
@@ -1392,6 +1414,8 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 						digestsize);
 	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
 		dev_err(jrdev, "unable to map dst\n");
+		ahash_unmap(jrdev, edesc, req, digestsize);
+		kfree(edesc);
 		return -ENOMEM;
 	}
 
@@ -1476,7 +1500,8 @@ static int ahash_update_first(struct ahash_request *req)
 							    DMA_TO_DEVICE);
 			if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
 				dev_err(jrdev, "unable to map S/G table\n");
-				return -ENOMEM;
+				ret = -ENOMEM;
+				goto err;
 			}
 			src_dma = edesc->sec4_sg_dma;
 			options = LDST_SGF;
@@ -1498,7 +1523,7 @@ static int ahash_update_first(struct ahash_request *req)
 
 		ret = map_seq_out_ptr_ctx(desc, jrdev, state, ctx->ctx_len);
 		if (ret)
-			return ret;
+			goto err;
 
 #ifdef DEBUG
 		print_hex_dump(KERN_ERR, "jobdesc@"__stringify(__LINE__)": ",
@@ -1506,18 +1531,14 @@ static int ahash_update_first(struct ahash_request *req)
 			       desc_bytes(desc), 1);
 #endif
 
-		ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_dst,
-				      req);
-		if (!ret) {
-			ret = -EINPROGRESS;
-			state->update = ahash_update_ctx;
-			state->finup = ahash_finup_ctx;
-			state->final = ahash_final_ctx;
-		} else {
-			ahash_unmap_ctx(jrdev, edesc, req, ctx->ctx_len,
-					DMA_TO_DEVICE);
-			kfree(edesc);
-		}
+		ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_dst, req);
+		if (ret)
+			goto err;
+
+		ret = -EINPROGRESS;
+		state->update = ahash_update_ctx;
+		state->finup = ahash_finup_ctx;
+		state->final = ahash_final_ctx;
 	} else if (*next_buflen) {
 		state->update = ahash_update_no_ctx;
 		state->finup = ahash_finup_no_ctx;
@@ -1532,6 +1553,11 @@ static int ahash_update_first(struct ahash_request *req)
 #endif
 
 	return ret;
+
+err:
+	ahash_unmap_ctx(jrdev, edesc, req, ctx->ctx_len, DMA_TO_DEVICE);
+	kfree(edesc);
+	return ret;
 }
 
 static int ahash_finup_first(struct ahash_request *req)
-- 
2.1.0
