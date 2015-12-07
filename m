From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH RFC 08/11] crypto: caam: add ahash_edesc_alloc() for
 descriptor allocation
Date: Mon, 07 Dec 2015 19:12:36 +0000
Message-ID: <E1a61DA-0007n1-29@rmk-PC.arm.linux.org.uk>
References: <20151207191134.GV8644@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:60533 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307AbbLGTMl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Dec 2015 14:12:41 -0500
In-Reply-To: <20151207191134.GV8644@n2100.arm.linux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add a helper function to perform the descriptor allocation.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/caam/caamhash.c | 60 +++++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 9638e9f4f001..f35f4cfc27a7 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -765,6 +765,25 @@ static void ahash_done_ctx_dst(struct device *jrdev, u32 *desc, u32 err,
 	req->base.complete(&req->base, err);
 }
 
+/*
+ * Allocate an enhanced descriptor, which contains the hardware descriptor
+ * and space for hardware scatter table containing sg_num entries.
+ */
+static struct ahash_edesc *ahash_edesc_alloc(struct caam_hash_ctx *ctx,
+					     int sg_num, gfp_t flags)
+{
+	struct ahash_edesc *edesc;
+	unsigned int sg_size = sg_num * sizeof(struct sec4_sg_entry);
+
+	edesc = kzalloc(sizeof(*edesc) + sg_size, GFP_DMA | flags);
+	if (!edesc) {
+		dev_err(ctx->jrdev, "could not allocate extended descriptor\n");
+		return NULL;
+	}
+
+	return edesc;
+}
+
 /* submit update job descriptor */
 static int ahash_update_ctx(struct ahash_request *req)
 {
@@ -813,11 +832,9 @@ static int ahash_update_ctx(struct ahash_request *req)
 		 * allocate space for base edesc and hw desc commands,
 		 * link tables
 		 */
-		edesc = kzalloc(sizeof(*edesc) + sec4_sg_bytes,
-				GFP_DMA | flags);
+		edesc = ahash_edesc_alloc(ctx, sec4_sg_src_index + mapped_nents,
+					  flags);
 		if (!edesc) {
-			dev_err(jrdev,
-				"could not allocate extended descriptor\n");
 			dma_unmap_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
 			return -ENOMEM;
 		}
@@ -930,11 +947,9 @@ static int ahash_final_ctx(struct ahash_request *req)
 	sec4_sg_bytes = sec4_sg_src_index * sizeof(struct sec4_sg_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = kzalloc(sizeof(*edesc) + sec4_sg_bytes, GFP_DMA | flags);
-	if (!edesc) {
-		dev_err(jrdev, "could not allocate extended descriptor\n");
+	edesc = ahash_edesc_alloc(ctx, sec4_sg_src_index, flags);
+	if (!edesc)
 		return -ENOMEM;
-	}
 
 	sh_len = desc_len(sh_desc);
 	desc = edesc->hw_desc;
@@ -1026,9 +1041,9 @@ static int ahash_finup_ctx(struct ahash_request *req)
 			 sizeof(struct sec4_sg_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = kzalloc(sizeof(*edesc) + sec4_sg_bytes, GFP_DMA | flags);
+	edesc = ahash_edesc_alloc(ctx, sec4_sg_src_index + mapped_nents,
+				  flags);
 	if (!edesc) {
-		dev_err(jrdev, "could not allocate extended descriptor\n");
 		dma_unmap_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
 		return -ENOMEM;
 	}
@@ -1122,9 +1137,9 @@ static int ahash_digest(struct ahash_request *req)
 		sec4_sg_bytes = 0;
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = kzalloc(sizeof(*edesc) + sec4_sg_bytes, GFP_DMA | flags);
+	edesc = ahash_edesc_alloc(ctx, mapped_nents > 1 ? mapped_nents : 0,
+				  flags);
 	if (!edesc) {
-		dev_err(jrdev, "could not allocate extended descriptor\n");
 		dma_unmap_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
 		return -ENOMEM;
 	}
@@ -1198,13 +1213,10 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 	int sh_len;
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = kzalloc(sizeof(*edesc), GFP_DMA | flags);
-	if (!edesc) {
-		dev_err(jrdev, "could not allocate extended descriptor\n");
+	edesc = ahash_edesc_alloc(ctx, 0, flags);
+	if (!edesc)
 		return -ENOMEM;
-	}
 
-	edesc->sec4_sg_bytes = 0;
 	sh_len = desc_len(sh_desc);
 	desc = edesc->hw_desc;
 	init_job_desc_shared(desc, ptr, sh_len, HDR_SHARE_DEFER | HDR_REVERSE);
@@ -1287,11 +1299,8 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 		 * allocate space for base edesc and hw desc commands,
 		 * link tables
 		 */
-		edesc = kzalloc(sizeof(*edesc) + sec4_sg_bytes,
-				GFP_DMA | flags);
+		edesc = ahash_edesc_alloc(ctx, 1 + mapped_nents, flags);
 		if (!edesc) {
-			dev_err(jrdev,
-				"could not allocate extended descriptor\n");
 			dma_unmap_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
 			return -ENOMEM;
 		}
@@ -1406,9 +1415,8 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 			 sizeof(struct sec4_sg_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = kzalloc(sizeof(*edesc) + sec4_sg_bytes, GFP_DMA | flags);
+	edesc = ahash_edesc_alloc(ctx, sec4_sg_src_index + mapped_nents, flags);
 	if (!edesc) {
-		dev_err(jrdev, "could not allocate extended descriptor\n");
 		dma_unmap_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
 		return -ENOMEM;
 	}
@@ -1508,11 +1516,9 @@ static int ahash_update_first(struct ahash_request *req)
 		 * allocate space for base edesc and hw desc commands,
 		 * link tables
 		 */
-		edesc = kzalloc(sizeof(*edesc) + sec4_sg_bytes,
-				GFP_DMA | flags);
+		edesc = ahash_edesc_alloc(ctx, mapped_nents > 1 ?
+					  mapped_nents : 0, flags);
 		if (!edesc) {
-			dev_err(jrdev,
-				"could not allocate extended descriptor\n");
 			dma_unmap_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
 			return -ENOMEM;
 		}
-- 
2.1.0
