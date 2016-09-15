From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 3/6] crypto-caamhash: Rename a jump label in five functions
Date: Thu, 15 Sep 2016 16:42:20 +0200
Message-ID: <f996c803-dfb7-0344-3acb-6d631feffbb5@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <970e9e1b-c1dc-eb28-b380-92c15e9b1961@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
To: linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Labbe Corentin <clabbe.montjoie@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:56699 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751085AbcIOOmh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Sep 2016 10:42:37 -0400
In-Reply-To: <970e9e1b-c1dc-eb28-b380-92c15e9b1961@users.sourceforge.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 15 Sep 2016 14:43:38 +0200

Adjust jump labels according to the current Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/crypto/caam/caamhash.c | 49 +++++++++++++++++++-----------------------
 1 file changed, 22 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 6017470..933252f 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -889,7 +889,7 @@ static int ahash_update_ctx(struct ahash_request *req)
 		ret = ctx_map_to_sec4_sg(desc, jrdev, state, ctx->ctx_len,
 					 edesc->sec4_sg, DMA_BIDIRECTIONAL);
 		if (ret)
-			goto err;
+			goto unmap_ctx;
 
 		state->buf_dma = try_buf_map_to_sec4_sg(jrdev,
 							edesc->sec4_sg + 1,
@@ -919,7 +919,7 @@ static int ahash_update_ctx(struct ahash_request *req)
 		if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
 			dev_err(jrdev, "unable to map S/G table\n");
 			ret = -ENOMEM;
-			goto err;
+			goto unmap_ctx;
 		}
 
 		append_seq_in_ptr(desc, edesc->sec4_sg_dma, ctx->ctx_len +
@@ -935,7 +935,7 @@ static int ahash_update_ctx(struct ahash_request *req)
 
 		ret = caam_jr_enqueue(jrdev, desc, ahash_done_bi, req);
 		if (ret)
-			goto err;
+			goto unmap_ctx;
 
 		ret = -EINPROGRESS;
 	} else if (*next_buflen) {
@@ -953,8 +953,7 @@ static int ahash_update_ctx(struct ahash_request *req)
 #endif
 
 	return ret;
-
- err:
+ unmap_ctx:
 	ahash_unmap_ctx(jrdev, edesc, req, ctx->ctx_len, DMA_BIDIRECTIONAL);
 	kfree(edesc);
 	return ret;
@@ -996,7 +995,7 @@ static int ahash_final_ctx(struct ahash_request *req)
 	ret = ctx_map_to_sec4_sg(desc, jrdev, state, ctx->ctx_len,
 				 edesc->sec4_sg, DMA_TO_DEVICE);
 	if (ret)
-		goto err;
+		goto unmap_ctx;
 
 	state->buf_dma = try_buf_map_to_sec4_sg(jrdev, edesc->sec4_sg + 1,
 						buf, state->buf_dma, buflen,
@@ -1009,7 +1008,7 @@ static int ahash_final_ctx(struct ahash_request *req)
 	if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
 		dev_err(jrdev, "unable to map S/G table\n");
 		ret = -ENOMEM;
-		goto err;
+		goto unmap_ctx;
 	}
 
 	append_seq_in_ptr(desc, edesc->sec4_sg_dma, ctx->ctx_len + buflen,
@@ -1020,7 +1019,7 @@ static int ahash_final_ctx(struct ahash_request *req)
 	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
 		dev_err(jrdev, "unable to map dst\n");
 		ret = -ENOMEM;
-		goto err;
+		goto unmap_ctx;
 	}
 
 #ifdef DEBUG
@@ -1030,11 +1029,10 @@ static int ahash_final_ctx(struct ahash_request *req)
 
 	ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, req);
 	if (ret)
-		goto err;
+		goto unmap_ctx;
 
 	return -EINPROGRESS;
-
-err:
+ unmap_ctx:
 	ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_FROM_DEVICE);
 	kfree(edesc);
 	return ret;
@@ -1094,7 +1092,7 @@ static int ahash_finup_ctx(struct ahash_request *req)
 	ret = ctx_map_to_sec4_sg(desc, jrdev, state, ctx->ctx_len,
 				 edesc->sec4_sg, DMA_TO_DEVICE);
 	if (ret)
-		goto err;
+		goto unmap_ctx;
 
 	state->buf_dma = try_buf_map_to_sec4_sg(jrdev, edesc->sec4_sg + 1,
 						buf, state->buf_dma, buflen,
@@ -1104,14 +1102,14 @@ static int ahash_finup_ctx(struct ahash_request *req)
 				  sec4_sg_src_index, ctx->ctx_len + buflen,
 				  req->nbytes);
 	if (ret)
-		goto err;
+		goto unmap_ctx;
 
 	edesc->dst_dma = map_seq_out_ptr_result(desc, jrdev, req->result,
 						digestsize);
 	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
 		dev_err(jrdev, "unable to map dst\n");
 		ret = -ENOMEM;
-		goto err;
+		goto unmap_ctx;
 	}
 
 #ifdef DEBUG
@@ -1121,11 +1119,10 @@ static int ahash_finup_ctx(struct ahash_request *req)
 
 	ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, req);
 	if (ret)
-		goto err;
+		goto unmap_ctx;
 
 	return -EINPROGRESS;
-
-err:
+ unmap_ctx:
 	ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_FROM_DEVICE);
 	kfree(edesc);
 	return ret;
@@ -1350,14 +1347,14 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 		if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
 			dev_err(jrdev, "unable to map S/G table\n");
 			ret = -ENOMEM;
-			goto err;
+			goto unmap_ctx;
 		}
 
 		append_seq_in_ptr(desc, edesc->sec4_sg_dma, to_hash, LDST_SGF);
 
 		ret = map_seq_out_ptr_ctx(desc, jrdev, state, ctx->ctx_len);
 		if (ret)
-			goto err;
+			goto unmap_ctx;
 
 #ifdef DEBUG
 		print_hex_dump(KERN_ERR, "jobdesc@"__stringify(__LINE__)": ",
@@ -1367,7 +1364,7 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 
 		ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_dst, req);
 		if (ret)
-			goto err;
+			goto unmap_ctx;
 
 		ret = -EINPROGRESS;
 		state->update = ahash_update_ctx;
@@ -1388,8 +1385,7 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 #endif
 
 	return ret;
-
-err:
+ unmap_ctx:
 	ahash_unmap_ctx(jrdev, edesc, req, ctx->ctx_len, DMA_TO_DEVICE);
 	kfree(edesc);
 	return ret;
@@ -1548,7 +1544,7 @@ static int ahash_update_first(struct ahash_request *req)
 		ret = ahash_edesc_add_src(ctx, edesc, req, mapped_nents, 0, 0,
 					  to_hash);
 		if (ret)
-			goto err;
+			goto unmap_ctx;
 
 		if (*next_buflen)
 			scatterwalk_map_and_copy(next_buf, req->src, to_hash,
@@ -1558,7 +1554,7 @@ static int ahash_update_first(struct ahash_request *req)
 
 		ret = map_seq_out_ptr_ctx(desc, jrdev, state, ctx->ctx_len);
 		if (ret)
-			goto err;
+			goto unmap_ctx;
 
 #ifdef DEBUG
 		print_hex_dump(KERN_ERR, "jobdesc@"__stringify(__LINE__)": ",
@@ -1568,7 +1564,7 @@ static int ahash_update_first(struct ahash_request *req)
 
 		ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_dst, req);
 		if (ret)
-			goto err;
+			goto unmap_ctx;
 
 		ret = -EINPROGRESS;
 		state->update = ahash_update_ctx;
@@ -1588,8 +1584,7 @@ static int ahash_update_first(struct ahash_request *req)
 #endif
 
 	return ret;
-
-err:
+ unmap_ctx:
 	ahash_unmap_ctx(jrdev, edesc, req, ctx->ctx_len, DMA_TO_DEVICE);
 	kfree(edesc);
 	return ret;
-- 
2.10.0
