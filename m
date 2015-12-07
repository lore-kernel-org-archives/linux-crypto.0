From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH RFC 05/11] crypto: caam: replace sec4_sg pointer with array
Date: Mon, 07 Dec 2015 19:12:20 +0000
Message-ID: <E1a61Cu-0007me-Mp@rmk-PC.arm.linux.org.uk>
References: <20151207191134.GV8644@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:60521 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843AbbLGTM1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Dec 2015 14:12:27 -0500
In-Reply-To: <20151207191134.GV8644@n2100.arm.linux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Since the extended descriptor includes the hardware descriptor, and the
sec4 scatterlist immediately follows this, we can declare it as a array
at the very end of the extended descriptor.  This allows us to get rid
of an initialiser for every site where we allocate an extended
descriptor.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/caam/caamhash.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 0a9665140d26..d48974d1897d 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -595,16 +595,16 @@ static int ahash_setkey(struct crypto_ahash *ahash,
  * @sec4_sg_dma: physical mapped address of h/w link table
  * @src_nents: number of segments in input scatterlist
  * @sec4_sg_bytes: length of dma mapped sec4_sg space
- * @sec4_sg: pointer to h/w link table
  * @hw_desc: the h/w job descriptor followed by any referenced link tables
+ * @sec4_sg: h/w link table
  */
 struct ahash_edesc {
 	dma_addr_t dst_dma;
 	dma_addr_t sec4_sg_dma;
 	int src_nents;
 	int sec4_sg_bytes;
-	struct sec4_sg_entry *sec4_sg;
 	u32 hw_desc[DESC_JOB_IO_LEN / sizeof(u32)] ____cacheline_aligned;
+	struct sec4_sg_entry sec4_sg[0];
 };
 
 static inline void ahash_unmap(struct device *dev,
@@ -821,7 +821,6 @@ static int ahash_update_ctx(struct ahash_request *req)
 
 		edesc->src_nents = src_nents;
 		edesc->sec4_sg_bytes = sec4_sg_bytes;
-		edesc->sec4_sg = (void *)(edesc + 1);
 
 		ret = ctx_map_to_sec4_sg(desc, jrdev, state, ctx->ctx_len,
 					 edesc->sec4_sg, DMA_BIDIRECTIONAL);
@@ -931,7 +930,6 @@ static int ahash_final_ctx(struct ahash_request *req)
 	init_job_desc_shared(desc, ptr, sh_len, HDR_SHARE_DEFER | HDR_REVERSE);
 
 	edesc->sec4_sg_bytes = sec4_sg_bytes;
-	edesc->sec4_sg = (void *)(edesc + 1);
 	edesc->src_nents = 0;
 
 	ret = ctx_map_to_sec4_sg(desc, jrdev, state, ctx->ctx_len,
@@ -1016,7 +1014,6 @@ static int ahash_finup_ctx(struct ahash_request *req)
 
 	edesc->src_nents = src_nents;
 	edesc->sec4_sg_bytes = sec4_sg_bytes;
-	edesc->sec4_sg = (void *)(edesc + 1);
 
 	ret = ctx_map_to_sec4_sg(desc, jrdev, state, ctx->ctx_len,
 				 edesc->sec4_sg, DMA_TO_DEVICE);
@@ -1093,7 +1090,7 @@ static int ahash_digest(struct ahash_request *req)
 		dev_err(jrdev, "could not allocate extended descriptor\n");
 		return -ENOMEM;
 	}
-	edesc->sec4_sg = (void *)(edesc + 1);
+
 	edesc->sec4_sg_bytes = sec4_sg_bytes;
 	edesc->src_nents = src_nents;
 
@@ -1247,7 +1244,6 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 
 		edesc->src_nents = src_nents;
 		edesc->sec4_sg_bytes = sec4_sg_bytes;
-		edesc->sec4_sg = (void *)(edesc + 1);
 		edesc->dst_dma = 0;
 
 		state->buf_dma = buf_map_to_sec4_sg(jrdev, edesc->sec4_sg,
@@ -1354,7 +1350,6 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 
 	edesc->src_nents = src_nents;
 	edesc->sec4_sg_bytes = sec4_sg_bytes;
-	edesc->sec4_sg = (void *)(edesc + 1);
 
 	state->buf_dma = try_buf_map_to_sec4_sg(jrdev, edesc->sec4_sg, buf,
 						state->buf_dma, buflen,
@@ -1445,7 +1440,6 @@ static int ahash_update_first(struct ahash_request *req)
 
 		edesc->src_nents = src_nents;
 		edesc->sec4_sg_bytes = sec4_sg_bytes;
-		edesc->sec4_sg = (void *)(edesc + 1);
 		edesc->dst_dma = 0;
 
 		if (src_nents > 1) {
-- 
2.1.0
