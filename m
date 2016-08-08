From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 03/11] crypto: caam: incorporate job descriptor into struct
 ahash_edesc
Date: Mon, 08 Aug 2016 18:04:42 +0100
Message-ID: <E1bWnyk-0002VK-9l@rmk-PC.armlinux.org.uk>
References: <20160808170400.GC1041@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:57478 "EHLO
	pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbcHHREr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Aug 2016 13:04:47 -0400
In-Reply-To: <20160808170400.GC1041@n2100.armlinux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Rather than giving the descriptor as hw_desc[0], give it's real size.
All places where we allocate an ahash_edesc incorporate DESC_JOB_IO_LEN
bytes of job descriptor.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/caam/caamhash.c | 49 ++++++++++++++++--------------------------
 1 file changed, 19 insertions(+), 30 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 47ea7b428156..ce9c1bc23795 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -604,7 +604,7 @@ struct ahash_edesc {
 	int src_nents;
 	int sec4_sg_bytes;
 	struct sec4_sg_entry *sec4_sg;
-	u32 hw_desc[0];
+	u32 hw_desc[DESC_JOB_IO_LEN / sizeof(u32)];
 };
 
 static inline void ahash_unmap(struct device *dev,
@@ -815,8 +815,8 @@ static int ahash_update_ctx(struct ahash_request *req)
 		 * allocate space for base edesc and hw desc commands,
 		 * link tables
 		 */
-		edesc = kzalloc(sizeof(*edesc) + DESC_JOB_IO_LEN +
-				sec4_sg_bytes, GFP_DMA | flags);
+		edesc = kzalloc(sizeof(*edesc) + sec4_sg_bytes,
+				GFP_DMA | flags);
 		if (!edesc) {
 			dev_err(jrdev,
 				"could not allocate extended descriptor\n");
@@ -825,8 +825,7 @@ static int ahash_update_ctx(struct ahash_request *req)
 
 		edesc->src_nents = src_nents;
 		edesc->sec4_sg_bytes = sec4_sg_bytes;
-		edesc->sec4_sg = (void *)edesc + sizeof(struct ahash_edesc) +
-				 DESC_JOB_IO_LEN;
+		edesc->sec4_sg = (void *)(edesc + 1);
 
 		ret = ctx_map_to_sec4_sg(desc, jrdev, state, ctx->ctx_len,
 					 edesc->sec4_sg, DMA_BIDIRECTIONAL);
@@ -925,8 +924,7 @@ static int ahash_final_ctx(struct ahash_request *req)
 	sec4_sg_bytes = sec4_sg_src_index * sizeof(struct sec4_sg_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = kzalloc(sizeof(*edesc) + DESC_JOB_IO_LEN + sec4_sg_bytes,
-			GFP_DMA | flags);
+	edesc = kzalloc(sizeof(*edesc) + sec4_sg_bytes, GFP_DMA | flags);
 	if (!edesc) {
 		dev_err(jrdev, "could not allocate extended descriptor\n");
 		return -ENOMEM;
@@ -937,8 +935,7 @@ static int ahash_final_ctx(struct ahash_request *req)
 	init_job_desc_shared(desc, ptr, sh_len, HDR_SHARE_DEFER | HDR_REVERSE);
 
 	edesc->sec4_sg_bytes = sec4_sg_bytes;
-	edesc->sec4_sg = (void *)edesc + sizeof(struct ahash_edesc) +
-			 DESC_JOB_IO_LEN;
+	edesc->sec4_sg = (void *)(edesc + 1);
 	edesc->src_nents = 0;
 
 	ret = ctx_map_to_sec4_sg(desc, jrdev, state, ctx->ctx_len,
@@ -1016,8 +1013,7 @@ static int ahash_finup_ctx(struct ahash_request *req)
 			 sizeof(struct sec4_sg_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = kzalloc(sizeof(*edesc) + DESC_JOB_IO_LEN + sec4_sg_bytes,
-			GFP_DMA | flags);
+	edesc = kzalloc(sizeof(*edesc) + sec4_sg_bytes, GFP_DMA | flags);
 	if (!edesc) {
 		dev_err(jrdev, "could not allocate extended descriptor\n");
 		return -ENOMEM;
@@ -1029,8 +1025,7 @@ static int ahash_finup_ctx(struct ahash_request *req)
 
 	edesc->src_nents = src_nents;
 	edesc->sec4_sg_bytes = sec4_sg_bytes;
-	edesc->sec4_sg = (void *)edesc + sizeof(struct ahash_edesc) +
-			 DESC_JOB_IO_LEN;
+	edesc->sec4_sg = (void *)(edesc + 1);
 
 	ret = ctx_map_to_sec4_sg(desc, jrdev, state, ctx->ctx_len,
 				 edesc->sec4_sg, DMA_TO_DEVICE);
@@ -1106,14 +1101,12 @@ static int ahash_digest(struct ahash_request *req)
 		sec4_sg_bytes = 0;
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = kzalloc(sizeof(*edesc) + sec4_sg_bytes + DESC_JOB_IO_LEN,
-			GFP_DMA | flags);
+	edesc = kzalloc(sizeof(*edesc) + sec4_sg_bytes, GFP_DMA | flags);
 	if (!edesc) {
 		dev_err(jrdev, "could not allocate extended descriptor\n");
 		return -ENOMEM;
 	}
-	edesc->sec4_sg = (void *)edesc + sizeof(struct ahash_edesc) +
-			  DESC_JOB_IO_LEN;
+	edesc->sec4_sg = (void *)(edesc + 1);
 	edesc->sec4_sg_bytes = sec4_sg_bytes;
 	edesc->src_nents = src_nents;
 
@@ -1179,7 +1172,7 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 	int sh_len;
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = kzalloc(sizeof(*edesc) + DESC_JOB_IO_LEN, GFP_DMA | flags);
+	edesc = kzalloc(sizeof(*edesc), GFP_DMA | flags);
 	if (!edesc) {
 		dev_err(jrdev, "could not allocate extended descriptor\n");
 		return -ENOMEM;
@@ -1261,8 +1254,8 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 		 * allocate space for base edesc and hw desc commands,
 		 * link tables
 		 */
-		edesc = kzalloc(sizeof(*edesc) + DESC_JOB_IO_LEN +
-				sec4_sg_bytes, GFP_DMA | flags);
+		edesc = kzalloc(sizeof(*edesc) + sec4_sg_bytes,
+				GFP_DMA | flags);
 		if (!edesc) {
 			dev_err(jrdev,
 				"could not allocate extended descriptor\n");
@@ -1271,8 +1264,7 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 
 		edesc->src_nents = src_nents;
 		edesc->sec4_sg_bytes = sec4_sg_bytes;
-		edesc->sec4_sg = (void *)edesc + sizeof(struct ahash_edesc) +
-				 DESC_JOB_IO_LEN;
+		edesc->sec4_sg = (void *)(edesc + 1);
 		edesc->dst_dma = 0;
 
 		state->buf_dma = buf_map_to_sec4_sg(jrdev, edesc->sec4_sg,
@@ -1371,8 +1363,7 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 			 sizeof(struct sec4_sg_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = kzalloc(sizeof(*edesc) + DESC_JOB_IO_LEN + sec4_sg_bytes,
-			GFP_DMA | flags);
+	edesc = kzalloc(sizeof(*edesc) + sec4_sg_bytes, GFP_DMA | flags);
 	if (!edesc) {
 		dev_err(jrdev, "could not allocate extended descriptor\n");
 		return -ENOMEM;
@@ -1384,8 +1375,7 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 
 	edesc->src_nents = src_nents;
 	edesc->sec4_sg_bytes = sec4_sg_bytes;
-	edesc->sec4_sg = (void *)edesc + sizeof(struct ahash_edesc) +
-			 DESC_JOB_IO_LEN;
+	edesc->sec4_sg = (void *)(edesc + 1);
 
 	state->buf_dma = try_buf_map_to_sec4_sg(jrdev, edesc->sec4_sg, buf,
 						state->buf_dma, buflen,
@@ -1470,8 +1460,8 @@ static int ahash_update_first(struct ahash_request *req)
 		 * allocate space for base edesc and hw desc commands,
 		 * link tables
 		 */
-		edesc = kzalloc(sizeof(*edesc) + DESC_JOB_IO_LEN +
-				sec4_sg_bytes, GFP_DMA | flags);
+		edesc = kzalloc(sizeof(*edesc) + sec4_sg_bytes,
+				GFP_DMA | flags);
 		if (!edesc) {
 			dev_err(jrdev,
 				"could not allocate extended descriptor\n");
@@ -1480,8 +1470,7 @@ static int ahash_update_first(struct ahash_request *req)
 
 		edesc->src_nents = src_nents;
 		edesc->sec4_sg_bytes = sec4_sg_bytes;
-		edesc->sec4_sg = (void *)edesc + sizeof(struct ahash_edesc) +
-				 DESC_JOB_IO_LEN;
+		edesc->sec4_sg = (void *)(edesc + 1);
 		edesc->dst_dma = 0;
 
 		if (src_nents > 1) {
-- 
2.1.0
