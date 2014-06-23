From: Ruchika Gupta <ruchika.gupta@freescale.com>
Subject: [PATCH] crypto:caam - Correct the dma mapping for sg table
Date: Mon, 23 Jun 2014 19:50:26 +0530
Message-ID: <1403533226-13240-1-git-send-email-ruchika.gupta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <davem@davemloft.net>, <alexandru.porosanu@freescale.com>,
	<kim.phillips@freescale.com>, <dan.carpenter@oracle.com>,
	<horia.geanta@freescale.com>, <marex@denx.de>,
	Ruchika Gupta <ruchika.gupta@freescale.com>
To: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:55572
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753494AbaFWJDT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Jun 2014 05:03:19 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

At few places in caamhash and caamalg, after allocating a dmable
buffer for sg table , the buffer was being modified.  As per
definition of DMA_FROM_DEVICE ,afer allocation the memory should
be treated as read-only by the driver. This patch shifts the
allocation of dmable buffer for sg table after it is populated
by the  driver, making it read-only as per the DMA API's requirement.

Signed-off-by: Ruchika Gupta <ruchika.gupta@freescale.com>
---
 drivers/crypto/caam/caamalg.c  |  8 ++++----
 drivers/crypto/caam/caamhash.c | 40 +++++++++++++++++++++++-----------------
 2 files changed, 27 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index c09ce1f..87d9de4 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1345,8 +1345,6 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	edesc->sec4_sg_bytes = sec4_sg_bytes;
 	edesc->sec4_sg = (void *)edesc + sizeof(struct aead_edesc) +
 			 desc_bytes;
-	edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
-					    sec4_sg_bytes, DMA_TO_DEVICE);
 	*all_contig_ptr = all_contig;
 
 	sec4_sg_index = 0;
@@ -1369,6 +1367,8 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 		sg_to_sec4_sg_last(req->dst, dst_nents,
 				   edesc->sec4_sg + sec4_sg_index, 0);
 	}
+	edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
+					    sec4_sg_bytes, DMA_TO_DEVICE);
 
 	return edesc;
 }
@@ -1534,8 +1534,6 @@ static struct aead_edesc *aead_giv_edesc_alloc(struct aead_givcrypt_request
 	edesc->sec4_sg_bytes = sec4_sg_bytes;
 	edesc->sec4_sg = (void *)edesc + sizeof(struct aead_edesc) +
 			 desc_bytes;
-	edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
-					    sec4_sg_bytes, DMA_TO_DEVICE);
 	*contig_ptr = contig;
 
 	sec4_sg_index = 0;
@@ -1559,6 +1557,8 @@ static struct aead_edesc *aead_giv_edesc_alloc(struct aead_givcrypt_request
 		sg_to_sec4_sg_last(req->dst, dst_nents,
 				   edesc->sec4_sg + sec4_sg_index, 0);
 	}
+	edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
+					    sec4_sg_bytes, DMA_TO_DEVICE);
 
 	return edesc;
 }
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 0d9284e..2ab057b 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -808,9 +808,6 @@ static int ahash_update_ctx(struct ahash_request *req)
 		edesc->sec4_sg_bytes = sec4_sg_bytes;
 		edesc->sec4_sg = (void *)edesc + sizeof(struct ahash_edesc) +
 				 DESC_JOB_IO_LEN;
-		edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
-						     sec4_sg_bytes,
-						     DMA_TO_DEVICE);
 
 		ctx_map_to_sec4_sg(desc, jrdev, state, ctx->ctx_len,
 				   edesc->sec4_sg, DMA_BIDIRECTIONAL);
@@ -839,6 +836,10 @@ static int ahash_update_ctx(struct ahash_request *req)
 		init_job_desc_shared(desc, ptr, sh_len, HDR_SHARE_DEFER |
 				     HDR_REVERSE);
 
+		edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
+						     sec4_sg_bytes,
+						     DMA_TO_DEVICE);
+
 		append_seq_in_ptr(desc, edesc->sec4_sg_dma, ctx->ctx_len +
 				       to_hash, LDST_SGF);
 
@@ -911,8 +912,6 @@ static int ahash_final_ctx(struct ahash_request *req)
 	edesc->sec4_sg_bytes = sec4_sg_bytes;
 	edesc->sec4_sg = (void *)edesc + sizeof(struct ahash_edesc) +
 			 DESC_JOB_IO_LEN;
-	edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
-					    sec4_sg_bytes, DMA_TO_DEVICE);
 	edesc->src_nents = 0;
 
 	ctx_map_to_sec4_sg(desc, jrdev, state, ctx->ctx_len, edesc->sec4_sg,
@@ -923,6 +922,9 @@ static int ahash_final_ctx(struct ahash_request *req)
 						last_buflen);
 	(edesc->sec4_sg + sec4_sg_bytes - 1)->len |= SEC4_SG_LEN_FIN;
 
+	edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
+					    sec4_sg_bytes, DMA_TO_DEVICE);
+
 	append_seq_in_ptr(desc, edesc->sec4_sg_dma, ctx->ctx_len + buflen,
 			  LDST_SGF);
 
@@ -989,8 +991,6 @@ static int ahash_finup_ctx(struct ahash_request *req)
 	edesc->sec4_sg_bytes = sec4_sg_bytes;
 	edesc->sec4_sg = (void *)edesc + sizeof(struct ahash_edesc) +
 			 DESC_JOB_IO_LEN;
-	edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
-					    sec4_sg_bytes, DMA_TO_DEVICE);
 
 	ctx_map_to_sec4_sg(desc, jrdev, state, ctx->ctx_len, edesc->sec4_sg,
 			   DMA_TO_DEVICE);
@@ -1002,6 +1002,9 @@ static int ahash_finup_ctx(struct ahash_request *req)
 	src_map_to_sec4_sg(jrdev, req->src, src_nents, edesc->sec4_sg +
 			   sec4_sg_src_index, chained);
 
+	edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
+					    sec4_sg_bytes, DMA_TO_DEVICE);
+
 	append_seq_in_ptr(desc, edesc->sec4_sg_dma, ctx->ctx_len +
 			       buflen + req->nbytes, LDST_SGF);
 
@@ -1056,8 +1059,6 @@ static int ahash_digest(struct ahash_request *req)
 	}
 	edesc->sec4_sg = (void *)edesc + sizeof(struct ahash_edesc) +
 			  DESC_JOB_IO_LEN;
-	edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
-					    sec4_sg_bytes, DMA_TO_DEVICE);
 	edesc->src_nents = src_nents;
 	edesc->chained = chained;
 
@@ -1067,6 +1068,8 @@ static int ahash_digest(struct ahash_request *req)
 
 	if (src_nents) {
 		sg_to_sec4_sg_last(req->src, src_nents, edesc->sec4_sg, 0);
+		edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
+					    sec4_sg_bytes, DMA_TO_DEVICE);
 		src_dma = edesc->sec4_sg_dma;
 		options = LDST_SGF;
 	} else {
@@ -1197,9 +1200,6 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 		edesc->sec4_sg_bytes = sec4_sg_bytes;
 		edesc->sec4_sg = (void *)edesc + sizeof(struct ahash_edesc) +
 				 DESC_JOB_IO_LEN;
-		edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
-						    sec4_sg_bytes,
-						    DMA_TO_DEVICE);
 
 		state->buf_dma = buf_map_to_sec4_sg(jrdev, edesc->sec4_sg,
 						    buf, *buflen);
@@ -1216,6 +1216,10 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 		init_job_desc_shared(desc, ptr, sh_len, HDR_SHARE_DEFER |
 				     HDR_REVERSE);
 
+		edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
+						    sec4_sg_bytes,
+						    DMA_TO_DEVICE);
+
 		append_seq_in_ptr(desc, edesc->sec4_sg_dma, to_hash, LDST_SGF);
 
 		map_seq_out_ptr_ctx(desc, jrdev, state, ctx->ctx_len);
@@ -1297,8 +1301,6 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 	edesc->sec4_sg_bytes = sec4_sg_bytes;
 	edesc->sec4_sg = (void *)edesc + sizeof(struct ahash_edesc) +
 			 DESC_JOB_IO_LEN;
-	edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
-					    sec4_sg_bytes, DMA_TO_DEVICE);
 
 	state->buf_dma = try_buf_map_to_sec4_sg(jrdev, edesc->sec4_sg, buf,
 						state->buf_dma, buflen,
@@ -1307,6 +1309,9 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 	src_map_to_sec4_sg(jrdev, req->src, src_nents, edesc->sec4_sg + 1,
 			   chained);
 
+	edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
+					    sec4_sg_bytes, DMA_TO_DEVICE);
+
 	append_seq_in_ptr(desc, edesc->sec4_sg_dma, buflen +
 			       req->nbytes, LDST_SGF);
 
@@ -1380,13 +1385,14 @@ static int ahash_update_first(struct ahash_request *req)
 		edesc->sec4_sg_bytes = sec4_sg_bytes;
 		edesc->sec4_sg = (void *)edesc + sizeof(struct ahash_edesc) +
 				 DESC_JOB_IO_LEN;
-		edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
-						    sec4_sg_bytes,
-						    DMA_TO_DEVICE);
 
 		if (src_nents) {
 			sg_to_sec4_sg_last(req->src, src_nents,
 					   edesc->sec4_sg, 0);
+			edesc->sec4_sg_dma = dma_map_single(jrdev,
+							    edesc->sec4_sg,
+							    sec4_sg_bytes,
+							    DMA_TO_DEVICE);
 			src_dma = edesc->sec4_sg_dma;
 			options = LDST_SGF;
 		} else {
-- 
1.8.1.4
