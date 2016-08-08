From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 07/11] crypto: caam: check and use dma_map_sg() return code
Date: Mon, 08 Aug 2016 18:05:03 +0100
Message-ID: <E1bWnz5-0002W0-7O@rmk-PC.armlinux.org.uk>
References: <20160808170400.GC1041@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:57496 "EHLO
	pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbcHHRFK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Aug 2016 13:05:10 -0400
In-Reply-To: <20160808170400.GC1041@n2100.armlinux.org.uk>
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
 drivers/crypto/caam/caamhash.c | 138 ++++++++++++++++++++++++++++++-----------
 1 file changed, 103 insertions(+), 35 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index e1925bf3a7cc..a639183d0115 100644
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
@@ -807,8 +798,20 @@ static int ahash_update_ctx(struct ahash_request *req)
 			dev_err(jrdev, "Invalid number of src SG.\n");
 			return src_nents;
 		}
+
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
@@ -820,6 +823,7 @@ static int ahash_update_ctx(struct ahash_request *req)
 		if (!edesc) {
 			dev_err(jrdev,
 				"could not allocate extended descriptor\n");
+			dma_unmap_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
 			return -ENOMEM;
 		}
 
@@ -836,9 +840,10 @@ static int ahash_update_ctx(struct ahash_request *req)
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
@@ -1001,7 +1006,7 @@ static int ahash_finup_ctx(struct ahash_request *req)
 	u32 *sh_desc = ctx->sh_desc_finup, *desc;
 	dma_addr_t ptr = ctx->sh_desc_finup_dma;
 	int sec4_sg_bytes, sec4_sg_src_index;
-	int src_nents;
+	int src_nents, mapped_nents;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct ahash_edesc *edesc;
 	int ret = 0;
@@ -1012,14 +1017,27 @@ static int ahash_finup_ctx(struct ahash_request *req)
 		dev_err(jrdev, "Invalid number of src SG.\n");
 		return src_nents;
 	}
+
+	if (src_nents) {
+		mapped_nents = dma_map_sg(jrdev, req->src, src_nents,
+					  DMA_TO_DEVICE);
+		if (!mapped_nents) {
+			dev_err(jrdev, "unable to DMA map source\n");
+			return -ENOMEM;
+		}
+	} else {
+		mapped_nents = 0;
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
 
@@ -1039,8 +1057,8 @@ static int ahash_finup_ctx(struct ahash_request *req)
 						buf, state->buf_dma, buflen,
 						last_buflen);
 
-	src_map_to_sec4_sg(jrdev, req->src, src_nents, edesc->sec4_sg +
-			   sec4_sg_src_index);
+	sg_to_sec4_sg_last(req->src, mapped_nents,
+			   edesc->sec4_sg + sec4_sg_src_index, 0);
 
 	edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
 					    sec4_sg_bytes, DMA_TO_DEVICE);
@@ -1088,7 +1106,7 @@ static int ahash_digest(struct ahash_request *req)
 	u32 *sh_desc = ctx->sh_desc_digest, *desc;
 	dma_addr_t ptr = ctx->sh_desc_digest_dma;
 	int digestsize = crypto_ahash_digestsize(ahash);
-	int src_nents, sec4_sg_bytes;
+	int src_nents, mapped_nents, sec4_sg_bytes;
 	dma_addr_t src_dma;
 	struct ahash_edesc *edesc;
 	int ret = 0;
@@ -1100,9 +1118,20 @@ static int ahash_digest(struct ahash_request *req)
 		dev_err(jrdev, "Invalid number of src SG.\n");
 		return src_nents;
 	}
-	dma_map_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
-	if (src_nents > 1)
-		sec4_sg_bytes = src_nents * sizeof(struct sec4_sg_entry);
+
+	if (src_nents) {
+		mapped_nents = dma_map_sg(jrdev, req->src, src_nents,
+					  DMA_TO_DEVICE);
+		if (!mapped_nents) {
+			dev_err(jrdev, "unable to map source for DMA\n");
+			return -ENOMEM;
+		}
+	} else {
+		mapped_nents = 0;
+	}
+
+	if (mapped_nents > 1)
+		sec4_sg_bytes = mapped_nents * sizeof(struct sec4_sg_entry);
 	else
 		sec4_sg_bytes = 0;
 
@@ -1110,6 +1139,7 @@ static int ahash_digest(struct ahash_request *req)
 	edesc = kzalloc(sizeof(*edesc) + sec4_sg_bytes, GFP_DMA | flags);
 	if (!edesc) {
 		dev_err(jrdev, "could not allocate extended descriptor\n");
+		dma_unmap_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
 		return -ENOMEM;
 	}
 
@@ -1121,7 +1151,7 @@ static int ahash_digest(struct ahash_request *req)
 	init_job_desc_shared(desc, ptr, sh_len, HDR_SHARE_DEFER | HDR_REVERSE);
 
 	if (src_nents > 1) {
-		sg_to_sec4_sg_last(req->src, src_nents, edesc->sec4_sg, 0);
+		sg_to_sec4_sg_last(req->src, mapped_nents, edesc->sec4_sg, 0);
 		edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
 					    sec4_sg_bytes, DMA_TO_DEVICE);
 		if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
@@ -1244,7 +1274,7 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 	int *next_buflen = state->current_buf ? &state->buflen_0 :
 			   &state->buflen_1;
 	int in_len = *buflen + req->nbytes, to_hash;
-	int sec4_sg_bytes, src_nents;
+	int sec4_sg_bytes, src_nents, mapped_nents;
 	struct ahash_edesc *edesc;
 	u32 *desc, *sh_desc = ctx->sh_desc_update_first;
 	dma_addr_t ptr = ctx->sh_desc_update_first_dma;
@@ -1261,7 +1291,19 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 			dev_err(jrdev, "Invalid number of src SG.\n");
 			return src_nents;
 		}
-		sec4_sg_bytes = (1 + src_nents) *
+
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
+		sec4_sg_bytes = (1 + mapped_nents) *
 				sizeof(struct sec4_sg_entry);
 
 		/*
@@ -1273,6 +1315,7 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 		if (!edesc) {
 			dev_err(jrdev,
 				"could not allocate extended descriptor\n");
+			dma_unmap_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
 			return -ENOMEM;
 		}
 
@@ -1282,8 +1325,9 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 
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
@@ -1363,7 +1407,7 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 			  state->buflen_1;
 	u32 *sh_desc = ctx->sh_desc_digest, *desc;
 	dma_addr_t ptr = ctx->sh_desc_digest_dma;
-	int sec4_sg_bytes, sec4_sg_src_index, src_nents;
+	int sec4_sg_bytes, sec4_sg_src_index, src_nents, mapped_nents;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct ahash_edesc *edesc;
 	int sh_len;
@@ -1374,14 +1418,27 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 		dev_err(jrdev, "Invalid number of src SG.\n");
 		return src_nents;
 	}
+
+	if (src_nents) {
+		mapped_nents = dma_map_sg(jrdev, req->src, src_nents,
+					  DMA_TO_DEVICE);
+		if (!mapped_nents) {
+			dev_err(jrdev, "unable to DMA map source\n");
+			return -ENOMEM;
+		}
+	} else {
+		mapped_nents = 0;
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
 
@@ -1396,7 +1453,7 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 						state->buf_dma, buflen,
 						last_buflen);
 
-	src_map_to_sec4_sg(jrdev, req->src, src_nents, edesc->sec4_sg + 1);
+	sg_to_sec4_sg_last(req->src, mapped_nents, edesc->sec4_sg + 1, 0);
 
 	edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
 					    sec4_sg_bytes, DMA_TO_DEVICE);
@@ -1450,7 +1507,7 @@ static int ahash_update_first(struct ahash_request *req)
 	int to_hash;
 	u32 *sh_desc = ctx->sh_desc_update_first, *desc;
 	dma_addr_t ptr = ctx->sh_desc_update_first_dma;
-	int sec4_sg_bytes, src_nents;
+	int sec4_sg_bytes, src_nents, mapped_nents;
 	dma_addr_t src_dma;
 	u32 options;
 	struct ahash_edesc *edesc;
@@ -1468,9 +1525,19 @@ static int ahash_update_first(struct ahash_request *req)
 			dev_err(jrdev, "Invalid number of src SG.\n");
 			return src_nents;
 		}
-		dma_map_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
-		if (src_nents > 1)
-			sec4_sg_bytes = src_nents *
+
+		if (src_nents) {
+			mapped_nents = dma_map_sg(jrdev, req->src, src_nents,
+						  DMA_TO_DEVICE);
+			if (!mapped_nents) {
+				dev_err(jrdev, "unable to map source for DMA\n");
+				return -ENOMEM;
+			}
+		} else {
+			mapped_nents = 0;
+		}
+		if (mapped_nents > 1)
+			sec4_sg_bytes = mapped_nents *
 					sizeof(struct sec4_sg_entry);
 		else
 			sec4_sg_bytes = 0;
@@ -1484,6 +1551,7 @@ static int ahash_update_first(struct ahash_request *req)
 		if (!edesc) {
 			dev_err(jrdev,
 				"could not allocate extended descriptor\n");
+			dma_unmap_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
 			return -ENOMEM;
 		}
 
@@ -1492,7 +1560,7 @@ static int ahash_update_first(struct ahash_request *req)
 		edesc->dst_dma = 0;
 
 		if (src_nents > 1) {
-			sg_to_sec4_sg_last(req->src, src_nents,
+			sg_to_sec4_sg_last(req->src, mapped_nents,
 					   edesc->sec4_sg, 0);
 			edesc->sec4_sg_dma = dma_map_single(jrdev,
 							    edesc->sec4_sg,
-- 
2.1.0
