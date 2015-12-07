From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH RFC 03/11] crypto: caam: incorporate job descriptor into
 struct ahash_edesc
Date: Mon, 07 Dec 2015 19:12:10 +0000
Message-ID: <E1a61Ck-0007mS-FH@rmk-PC.arm.linux.org.uk>
References: <20151207191134.GV8644@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:60512 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328AbbLGTMR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Dec 2015 14:12:17 -0500
In-Reply-To: <20151207191134.GV8644@n2100.arm.linux.org.uk>
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
index 6a6d74f38300..cf557e1291b3 100644
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
@@ -811,8 +811,8 @@ static int ahash_update_ctx(struct ahash_request *req)
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
@@ -821,8 +821,7 @@ static int ahash_update_ctx(struct ahash_request *req)
 
 		edesc->src_nents = src_nents;
 		edesc->sec4_sg_bytes = sec4_sg_bytes;
-		edesc->sec4_sg = (void *)edesc + sizeof(struct ahash_edesc) +
-				 DESC_JOB_IO_LEN;
+		edesc->sec4_sg = (void *)(edesc + 1);
 
 		ret = ctx_map_to_sec4_sg(desc, jrdev, state, ctx->ctx_len,
 					 edesc->sec4_sg, DMA_BIDIRECTIONAL);
@@ -921,8 +920,7 @@ static int ahash_final_ctx(struct ahash_request *req)
 	sec4_sg_bytes = sec4_sg_src_index * sizeof(struct sec4_sg_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = kzalloc(sizeof(*edesc) + DESC_JOB_IO_LEN + sec4_sg_bytes,
-			GFP_DMA | flags);
+	edesc = kzalloc(sizeof(*edesc) + sec4_sg_bytes, GFP_DMA | flags);
 	if (!edesc) {
 		dev_err(jrdev, "could not allocate extended descriptor\n");
 		return -ENOMEM;
@@ -933,8 +931,7 @@ static int ahash_final_ctx(struct ahash_request *req)
 	init_job_desc_shared(desc, ptr, sh_len, HDR_SHARE_DEFER | HDR_REVERSE);
 
 	edesc->sec4_sg_bytes = sec4_sg_bytes;
-	edesc->sec4_sg = (void *)edesc + sizeof(struct ahash_edesc) +
-			 DESC_JOB_IO_LEN;
+	edesc->sec4_sg = (void *)(edesc + 1);
 	edesc->src_nents = 0;
 
 	ret = ctx_map_to_sec4_sg(desc, jrdev, state, ctx->ctx_len,
@@ -1007,8 +1004,7 @@ static int ahash_finup_ctx(struct ahash_request *req)
 			 sizeof(struct sec4_sg_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = kzalloc(sizeof(*edesc) + DESC_JOB_IO_LEN + sec4_sg_bytes,
-			GFP_DMA | flags);
+	edesc = kzalloc(sizeof(*edesc) + sec4_sg_bytes, GFP_DMA | flags);
 	if (!edesc) {
 		dev_err(jrdev, "could not allocate extended descriptor\n");
 		return -ENOMEM;
@@ -1020,8 +1016,7 @@ static int ahash_finup_ctx(struct ahash_request *req)
 
 	edesc->src_nents = src_nents;
 	edesc->sec4_sg_bytes = sec4_sg_bytes;
-	edesc->sec4_sg = (void *)edesc + sizeof(struct ahash_edesc) +
-			 DESC_JOB_IO_LEN;
+	edesc->sec4_sg = (void *)(edesc + 1);
 
 	ret = ctx_map_to_sec4_sg(desc, jrdev, state, ctx->ctx_len,
 				 edesc->sec4_sg, DMA_TO_DEVICE);
@@ -1093,14 +1088,12 @@ static int ahash_digest(struct ahash_request *req)
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
 
@@ -1166,7 +1159,7 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 	int sh_len;
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = kzalloc(sizeof(*edesc) + DESC_JOB_IO_LEN, GFP_DMA | flags);
+	edesc = kzalloc(sizeof(*edesc), GFP_DMA | flags);
 	if (!edesc) {
 		dev_err(jrdev, "could not allocate extended descriptor\n");
 		return -ENOMEM;
@@ -1244,8 +1237,8 @@ static int ahash_update_no_ctx(struct ahash_request *req)
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
@@ -1254,8 +1247,7 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 
 		edesc->src_nents = src_nents;
 		edesc->sec4_sg_bytes = sec4_sg_bytes;
-		edesc->sec4_sg = (void *)edesc + sizeof(struct ahash_edesc) +
-				 DESC_JOB_IO_LEN;
+		edesc->sec4_sg = (void *)(edesc + 1);
 		edesc->dst_dma = 0;
 
 		state->buf_dma = buf_map_to_sec4_sg(jrdev, edesc->sec4_sg,
@@ -1350,8 +1342,7 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 			 sizeof(struct sec4_sg_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = kzalloc(sizeof(*edesc) + DESC_JOB_IO_LEN + sec4_sg_bytes,
-			GFP_DMA | flags);
+	edesc = kzalloc(sizeof(*edesc) + sec4_sg_bytes, GFP_DMA | flags);
 	if (!edesc) {
 		dev_err(jrdev, "could not allocate extended descriptor\n");
 		return -ENOMEM;
@@ -1363,8 +1354,7 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 
 	edesc->src_nents = src_nents;
 	edesc->sec4_sg_bytes = sec4_sg_bytes;
-	edesc->sec4_sg = (void *)edesc + sizeof(struct ahash_edesc) +
-			 DESC_JOB_IO_LEN;
+	edesc->sec4_sg = (void *)(edesc + 1);
 
 	state->buf_dma = try_buf_map_to_sec4_sg(jrdev, edesc->sec4_sg, buf,
 						state->buf_dma, buflen,
@@ -1445,8 +1435,8 @@ static int ahash_update_first(struct ahash_request *req)
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
@@ -1455,8 +1445,7 @@ static int ahash_update_first(struct ahash_request *req)
 
 		edesc->src_nents = src_nents;
 		edesc->sec4_sg_bytes = sec4_sg_bytes;
-		edesc->sec4_sg = (void *)edesc + sizeof(struct ahash_edesc) +
-				 DESC_JOB_IO_LEN;
+		edesc->sec4_sg = (void *)(edesc + 1);
 		edesc->dst_dma = 0;
 
 		if (src_nents > 1) {
-- 
2.1.0
