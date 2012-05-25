From: Phil Sutter <phil.sutter@viprinet.com>
Subject: [PATCH 08/13] mv_cesa: fetch extra_bytes via TDMA engine, too
Date: Fri, 25 May 2012 18:08:34 +0200
Message-ID: <1337962119-5509-9-git-send-email-phil.sutter@viprinet.com>
References: <1337962119-5509-1-git-send-email-phil.sutter@viprinet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:47889 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754380Ab2EYQIz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 May 2012 12:08:55 -0400
In-Reply-To: <1337962119-5509-1-git-send-email-phil.sutter@viprinet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>
---
 drivers/crypto/mv_cesa.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index d099aa0..bc2692e 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -156,6 +156,7 @@ struct mv_req_hash_ctx {
 	u64 count;
 	u32 state[SHA1_DIGEST_SIZE / 4];
 	u8 buffer[SHA1_BLOCK_SIZE];
+	dma_addr_t buffer_dma;
 	int first_hash;		/* marks that we don't have previous state */
 	int last_chunk;		/* marks that this is the 'final' request */
 	int extra_bytes;	/* unprocessed bytes in buffer */
@@ -636,6 +637,9 @@ static void mv_hash_algo_completion(void)
 		dma_unmap_single(cpg->dev, ctx->result_dma,
 				ctx->digestsize, DMA_FROM_DEVICE);
 
+		dma_unmap_single(cpg->dev, ctx->buffer_dma,
+				SHA1_BLOCK_SIZE, DMA_TO_DEVICE);
+
 		if (unlikely(ctx->count > MAX_HW_HASH_SIZE)) {
 			mv_save_digest_state(ctx);
 			mv_hash_final_fallback(req);
@@ -755,8 +759,10 @@ static void mv_start_new_hash_req(struct ahash_request *req)
 		p->process = mv_update_hash_config;
 
 		if (unlikely(old_extra_bytes)) {
-			memcpy(cpg->sram + SRAM_DATA_IN_START, ctx->buffer,
-			       old_extra_bytes);
+			dma_sync_single_for_device(cpg->dev, ctx->buffer_dma,
+					SHA1_BLOCK_SIZE, DMA_TO_DEVICE);
+			mv_tdma_memcpy(cpg->sram_phys + SRAM_DATA_IN_START,
+					ctx->buffer_dma, old_extra_bytes);
 			p->crypt_len = old_extra_bytes;
 		}
 
@@ -901,6 +907,8 @@ static void mv_init_hash_req_ctx(struct mv_req_hash_ctx *ctx, int op,
 	ctx->first_hash = 1;
 	ctx->last_chunk = is_last;
 	ctx->count_add = count_add;
+	ctx->buffer_dma = dma_map_single(cpg->dev, ctx->buffer,
+			SHA1_BLOCK_SIZE, DMA_TO_DEVICE);
 }
 
 static void mv_update_hash_req_ctx(struct mv_req_hash_ctx *ctx, int is_last,
-- 
1.7.3.4
