From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH RFC 07/11] crypto: caam: check and use dma_map_sg() return
 code
Date: Mon, 07 Dec 2015 19:12:30 +0000
Message-ID: <E1a61D4-0007ms-UR@rmk-PC.arm.linux.org.uk>
References: <20151207191134.GV8644@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:60529 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307AbbLGTMg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Dec 2015 14:12:36 -0500
In-Reply-To: <20151207191134.GV8644@n2100.arm.linux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Strictly, dma_map_sg() may coalesce SG entries, but in practise on iMX
hardware, this will never happen.  However, dma_map_sg() can fail, and
we completely fail to check its return value.  So, fix this properly.

Arrange the code to map the scatterlist early, so we know how many
scatter table entries to allocate, and then fill them in.  This allows
us to keep relatively simple error cleanup paths.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/caam/caamhash.c | 109 ++++++++++++++++++++++++++++-------------
 1 file changed, 74 insertions(+), 35 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 076cfddf32bb..9638e9f4f001 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -187,15 +187,6 @@ static inline dma_addr_t buf_map_to_sec4_sg(struct device *jrdev,
 	return buf_dma;
 }
 
-/* Map req->src and put it in link table */
-static inline void src_map_to_sec4_sg(struct device *jrdev,
-				      struct scatterlist *src, int src_nents,
-				      struct sec4_sg_entry *sec4_sg)
-{
-	dma_map_sg(jrdev, src, src_nents, DMA_TO_DEVICE);
-	sg_to_sec4_sg_last(src, src_nents, sec4_sg, 0);
-}
-
 /*
  * Only put buffer in link table if it contains data, which is possible,
  * since a buffer has previously been used, and needs to be unmapped,
@@ -791,7 +782,7 @@ static int ahash_update_ctx(struct ahash_request *req)
 	int in_len = *buflen + req->nbytes, to_hash;
 	u32 *sh_desc = ctx->sh_desc_update, *desc;
 	dma_addr_t ptr = ctx->sh_desc_update_dma;
-	int src_nents, sec4_sg_bytes, sec4_sg_src_index;
+	int src_nents, mapped_nents, sec4_sg_bytes, sec4_sg_src_index;
 	struct ahash_edesc *edesc;
 	int ret = 0;
 	int sh_len;
@@ -803,8 +794,19 @@ static int ahash_update_ctx(struct ahash_request *req)
 	if (to_hash) {
 		src_nents = sg_nents_for_len(req->src,
 					     req->nbytes - (*next_buflen));
+		if (src_nents) {
+			mapped_nents = dma_map_sg(jrdev, req->src, src_nents,
+						  DMA_TO_DEVICE);
+			if (!mapped_nents) {
+				dev_err(jrdev, "unable to DMA map source\n");
+				return -ENOMEM;
+			}
+		} else {
+			mapped_nents = 0;
+		}
+
 		sec4_sg_src_index = 1 + (*buflen ? 1 : 0);
-		sec4_sg_bytes = (sec4_sg_src_index + src_nents) *
+		sec4_sg_bytes = (sec4_sg_src_index + mapped_nents) *
 				 sizeof(struct sec4_sg_entry);
 
 		/*
@@ -816,6 +818,7 @@ static int ahash_update_ctx(struct ahash_request *req)
 		if (!edesc) {
 			dev_err(jrdev,
 				"could not allocate extended descriptor\n");
+			dma_unmap_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
 			return -ENOMEM;
 		}
 
@@ -836,9 +839,10 @@ static int ahash_update_ctx(struct ahash_request *req)
 							buf, state->buf_dma,
 							*buflen, last_buflen);
 
-		if (src_nents) {
-			src_map_to_sec4_sg(jrdev, req->src, src_nents,
-					   edesc->sec4_sg + sec4_sg_src_index);
+		if (mapped_nents) {
+			sg_to_sec4_sg_last(req->src, mapped_nents,
+					   edesc->sec4_sg + sec4_sg_src_index,
+					   0);
 			if (*next_buflen)
 				scatterwalk_map_and_copy(next_buf, req->src,
 							 to_hash - *buflen,
@@ -1004,21 +1008,28 @@ static int ahash_finup_ctx(struct ahash_request *req)
 	u32 *sh_desc = ctx->sh_desc_finup, *desc;
 	dma_addr_t ptr = ctx->sh_desc_finup_dma;
 	int sec4_sg_bytes, sec4_sg_src_index;
-	int src_nents;
+	int src_nents, mapped_nents;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct ahash_edesc *edesc;
 	int ret = 0;
 	int sh_len;
 
 	src_nents = sg_nents_for_len(req->src, req->nbytes);
+	mapped_nents = dma_map_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
+	if (!mapped_nents) {
+		dev_err(jrdev, "unable to DMA map source\n");
+		return -ENOMEM;
+	}
+
 	sec4_sg_src_index = 1 + (buflen ? 1 : 0);
-	sec4_sg_bytes = (sec4_sg_src_index + src_nents) *
+	sec4_sg_bytes = (sec4_sg_src_index + mapped_nents) *
 			 sizeof(struct sec4_sg_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
 	edesc = kzalloc(sizeof(*edesc) + sec4_sg_bytes, GFP_DMA | flags);
 	if (!edesc) {
 		dev_err(jrdev, "could not allocate extended descriptor\n");
+		dma_unmap_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
 		return -ENOMEM;
 	}
 
@@ -1041,8 +1052,8 @@ static int ahash_finup_ctx(struct ahash_request *req)
 						buf, state->buf_dma, buflen,
 						last_buflen);
 
-	src_map_to_sec4_sg(jrdev, req->src, src_nents, edesc->sec4_sg +
-			   sec4_sg_src_index);
+	sg_to_sec4_sg_last(req->src, mapped_nents,
+			   edesc->sec4_sg + sec4_sg_src_index, 0);
 
 	edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
 					    sec4_sg_bytes, DMA_TO_DEVICE);
@@ -1091,7 +1102,7 @@ static int ahash_digest(struct ahash_request *req)
 	u32 *sh_desc = ctx->sh_desc_digest, *desc;
 	dma_addr_t ptr = ctx->sh_desc_digest_dma;
 	int digestsize = crypto_ahash_digestsize(ahash);
-	int src_nents, sec4_sg_bytes;
+	int src_nents, mapped_nents, sec4_sg_bytes;
 	dma_addr_t src_dma;
 	struct ahash_edesc *edesc;
 	int ret = 0;
@@ -1099,9 +1110,14 @@ static int ahash_digest(struct ahash_request *req)
 	int sh_len;
 
 	src_nents = sg_nents_for_len(req->src, req->nbytes);
-	dma_map_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
-	if (src_nents > 1)
-		sec4_sg_bytes = src_nents * sizeof(struct sec4_sg_entry);
+	mapped_nents = dma_map_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
+	if (mapped_nents == 0) {
+		dev_err(jrdev, "unable to map source for DMA\n");
+		return -ENOMEM;
+	}
+
+	if (mapped_nents > 1)
+		sec4_sg_bytes = mapped_nents * sizeof(struct sec4_sg_entry);
 	else
 		sec4_sg_bytes = 0;
 
@@ -1109,6 +1125,7 @@ static int ahash_digest(struct ahash_request *req)
 	edesc = kzalloc(sizeof(*edesc) + sec4_sg_bytes, GFP_DMA | flags);
 	if (!edesc) {
 		dev_err(jrdev, "could not allocate extended descriptor\n");
+		dma_unmap_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
 		return -ENOMEM;
 	}
 
@@ -1120,7 +1137,7 @@ static int ahash_digest(struct ahash_request *req)
 	init_job_desc_shared(desc, ptr, sh_len, HDR_SHARE_DEFER | HDR_REVERSE);
 
 	if (src_nents > 1) {
-		sg_to_sec4_sg_last(req->src, src_nents, edesc->sec4_sg, 0);
+		sg_to_sec4_sg_last(req->src, mapped_nents, edesc->sec4_sg, 0);
 		edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
 					    sec4_sg_bytes, DMA_TO_DEVICE);
 		if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
@@ -1243,7 +1260,7 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 	int *next_buflen = state->current_buf ? &state->buflen_0 :
 			   &state->buflen_1;
 	int in_len = *buflen + req->nbytes, to_hash;
-	int sec4_sg_bytes, src_nents;
+	int sec4_sg_bytes, src_nents, mapped_nents;
 	struct ahash_edesc *edesc;
 	u32 *desc, *sh_desc = ctx->sh_desc_update_first;
 	dma_addr_t ptr = ctx->sh_desc_update_first_dma;
@@ -1256,7 +1273,14 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 	if (to_hash) {
 		src_nents = sg_nents_for_len(req->src, req->nbytes -
 						       *next_buflen);
-		sec4_sg_bytes = (1 + src_nents) *
+		mapped_nents = dma_map_sg(jrdev, req->src, src_nents,
+					  DMA_TO_DEVICE);
+		if (!mapped_nents) {
+			dev_err(jrdev, "unable to DMA map source\n");
+			return -ENOMEM;
+		}
+
+		sec4_sg_bytes = (1 + mapped_nents) *
 				sizeof(struct sec4_sg_entry);
 
 		/*
@@ -1268,6 +1292,7 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 		if (!edesc) {
 			dev_err(jrdev,
 				"could not allocate extended descriptor\n");
+			dma_unmap_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
 			return -ENOMEM;
 		}
 
@@ -1277,8 +1302,9 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 
 		state->buf_dma = buf_map_to_sec4_sg(jrdev, edesc->sec4_sg,
 						    buf, *buflen);
-		src_map_to_sec4_sg(jrdev, req->src, src_nents,
-				   edesc->sec4_sg + 1);
+		sg_to_sec4_sg_last(req->src, mapped_nents,
+				   edesc->sec4_sg + 1, 0);
+
 		if (*next_buflen) {
 			scatterwalk_map_and_copy(next_buf, req->src,
 						 to_hash - *buflen,
@@ -1362,21 +1388,28 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 			  state->buflen_1;
 	u32 *sh_desc = ctx->sh_desc_digest, *desc;
 	dma_addr_t ptr = ctx->sh_desc_digest_dma;
-	int sec4_sg_bytes, sec4_sg_src_index, src_nents;
+	int sec4_sg_bytes, sec4_sg_src_index, src_nents, mapped_nents;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct ahash_edesc *edesc;
 	int sh_len;
 	int ret = 0;
 
 	src_nents = sg_nents_for_len(req->src, req->nbytes);
+	mapped_nents = dma_map_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
+	if (!mapped_nents) {
+		dev_err(jrdev, "unable to DMA map source\n");
+		return -ENOMEM;
+	}
+
 	sec4_sg_src_index = 2;
-	sec4_sg_bytes = (sec4_sg_src_index + src_nents) *
+	sec4_sg_bytes = (sec4_sg_src_index + mapped_nents) *
 			 sizeof(struct sec4_sg_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
 	edesc = kzalloc(sizeof(*edesc) + sec4_sg_bytes, GFP_DMA | flags);
 	if (!edesc) {
 		dev_err(jrdev, "could not allocate extended descriptor\n");
+		dma_unmap_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
 		return -ENOMEM;
 	}
 
@@ -1391,7 +1424,7 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 						state->buf_dma, buflen,
 						last_buflen);
 
-	src_map_to_sec4_sg(jrdev, req->src, src_nents, edesc->sec4_sg + 1);
+	sg_to_sec4_sg_last(req->src, mapped_nents, edesc->sec4_sg + 1, 0);
 
 	edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
 					    sec4_sg_bytes, DMA_TO_DEVICE);
@@ -1445,7 +1478,7 @@ static int ahash_update_first(struct ahash_request *req)
 	int to_hash;
 	u32 *sh_desc = ctx->sh_desc_update_first, *desc;
 	dma_addr_t ptr = ctx->sh_desc_update_first_dma;
-	int sec4_sg_bytes, src_nents;
+	int sec4_sg_bytes, src_nents, mapped_nents;
 	dma_addr_t src_dma;
 	u32 options;
 	struct ahash_edesc *edesc;
@@ -1459,9 +1492,14 @@ static int ahash_update_first(struct ahash_request *req)
 	if (to_hash) {
 		src_nents = sg_nents_for_len(req->src, req->nbytes -
 						       *next_buflen);
-		dma_map_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
-		if (src_nents > 1)
-			sec4_sg_bytes = src_nents *
+		mapped_nents = dma_map_sg(jrdev, req->src, src_nents,
+					  DMA_TO_DEVICE);
+		if (mapped_nents == 0) {
+			dev_err(jrdev, "unable to map source for DMA\n");
+			return -ENOMEM;
+		}
+		if (mapped_nents > 1)
+			sec4_sg_bytes = mapped_nents *
 					sizeof(struct sec4_sg_entry);
 		else
 			sec4_sg_bytes = 0;
@@ -1475,6 +1513,7 @@ static int ahash_update_first(struct ahash_request *req)
 		if (!edesc) {
 			dev_err(jrdev,
 				"could not allocate extended descriptor\n");
+			dma_unmap_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
 			return -ENOMEM;
 		}
 
@@ -1483,7 +1522,7 @@ static int ahash_update_first(struct ahash_request *req)
 		edesc->dst_dma = 0;
 
 		if (src_nents > 1) {
-			sg_to_sec4_sg_last(req->src, src_nents,
+			sg_to_sec4_sg_last(req->src, mapped_nents,
 					   edesc->sec4_sg, 0);
 			edesc->sec4_sg_dma = dma_map_single(jrdev,
 							    edesc->sec4_sg,
-- 
2.1.0
