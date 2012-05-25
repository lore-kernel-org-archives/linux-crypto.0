From: Phil Sutter <phil.sutter@viprinet.com>
Subject: [PATCH 07/13] mv_cesa: have TDMA copy back the digest result
Date: Fri, 25 May 2012 18:08:33 +0200
Message-ID: <1337962119-5509-8-git-send-email-phil.sutter@viprinet.com>
References: <1337962119-5509-1-git-send-email-phil.sutter@viprinet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:47894 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755981Ab2EYQI4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 May 2012 12:08:56 -0400
In-Reply-To: <1337962119-5509-1-git-send-email-phil.sutter@viprinet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>
---
 drivers/crypto/mv_cesa.c |   40 +++++++++++++++++++++++++++++-----------
 1 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index e10da2b..d099aa0 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -159,8 +159,10 @@ struct mv_req_hash_ctx {
 	int first_hash;		/* marks that we don't have previous state */
 	int last_chunk;		/* marks that this is the 'final' request */
 	int extra_bytes;	/* unprocessed bytes in buffer */
+	int digestsize;		/* size of the digest */
 	enum hash_op op;
 	int count_add;
+	dma_addr_t result_dma;
 };
 
 static void mv_completion_timer_callback(unsigned long unused)
@@ -497,9 +499,17 @@ static void mv_init_hash_config(struct ahash_request *req)
 
 	mv_tdma_separator();
 
-	/* XXX: this fixes some ugly register fuckup bug in the tdma engine
-	 *      (no need to sync since the data is ignored anyway) */
-	mv_tdma_memcpy(cpg->sa_sram_dma, cpg->sram_phys + SRAM_CONFIG, 1);
+	if (req->result) {
+		req_ctx->result_dma = dma_map_single(cpg->dev, req->result,
+				req_ctx->digestsize, DMA_FROM_DEVICE);
+		mv_tdma_memcpy(req_ctx->result_dma,
+				cpg->sram_phys + SRAM_DIGEST_BUF, req_ctx->digestsize);
+	} else {
+		/* XXX: this fixes some ugly register fuckup bug in the tdma engine
+		 *      (no need to sync since the data is ignored anyway) */
+		mv_tdma_memcpy(cpg->sa_sram_dma,
+				cpg->sram_phys + SRAM_CONFIG, 1);
+	}
 
 	/* GO */
 	mv_setup_timer();
@@ -546,9 +556,17 @@ static void mv_update_hash_config(void)
 
 	mv_tdma_separator();
 
-	/* XXX: this fixes some ugly register fuckup bug in the tdma engine
-	 *      (no need to sync since the data is ignored anyway) */
-	mv_tdma_memcpy(cpg->sa_sram_dma, cpg->sram_phys + SRAM_CONFIG, 1);
+	if (req->result) {
+		req_ctx->result_dma = dma_map_single(cpg->dev, req->result,
+				req_ctx->digestsize, DMA_FROM_DEVICE);
+		mv_tdma_memcpy(req_ctx->result_dma,
+				cpg->sram_phys + SRAM_DIGEST_BUF, req_ctx->digestsize);
+	} else {
+		/* XXX: this fixes some ugly register fuckup bug in the tdma engine
+		 *      (no need to sync since the data is ignored anyway) */
+		mv_tdma_memcpy(cpg->sa_sram_dma,
+				cpg->sram_phys + SRAM_CONFIG, 1);
+	}
 
 	/* GO */
 	mv_setup_timer();
@@ -615,11 +633,10 @@ static void mv_hash_algo_completion(void)
 		copy_src_to_buf(&cpg->p, ctx->buffer, ctx->extra_bytes);
 
 	if (likely(ctx->last_chunk)) {
-		if (likely(ctx->count <= MAX_HW_HASH_SIZE)) {
-			memcpy(req->result, cpg->sram + SRAM_DIGEST_BUF,
-			       crypto_ahash_digestsize(crypto_ahash_reqtfm
-						       (req)));
-		} else {
+		dma_unmap_single(cpg->dev, ctx->result_dma,
+				ctx->digestsize, DMA_FROM_DEVICE);
+
+		if (unlikely(ctx->count > MAX_HW_HASH_SIZE)) {
 			mv_save_digest_state(ctx);
 			mv_hash_final_fallback(req);
 		}
@@ -717,6 +734,7 @@ static void mv_start_new_hash_req(struct ahash_request *req)
 	memset(p, 0, sizeof(struct req_progress));
 	hw_bytes = req->nbytes + ctx->extra_bytes;
 	old_extra_bytes = ctx->extra_bytes;
+	ctx->digestsize = crypto_ahash_digestsize(crypto_ahash_reqtfm(req));
 
 	ctx->extra_bytes = hw_bytes % SHA1_BLOCK_SIZE;
 	if (ctx->extra_bytes != 0
-- 
1.7.3.4
