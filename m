From: Phil Sutter <phil.sutter@viprinet.com>
Subject: [PATCH 10/13] mv_cesa: reorganise mv_start_new_hash_req a bit
Date: Fri, 25 May 2012 18:08:36 +0200
Message-ID: <1337962119-5509-11-git-send-email-phil.sutter@viprinet.com>
References: <1337962119-5509-1-git-send-email-phil.sutter@viprinet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:47911 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756171Ab2EYQI7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 May 2012 12:08:59 -0400
In-Reply-To: <1337962119-5509-1-git-send-email-phil.sutter@viprinet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Check and exit early for whether CESA can be used at all.

Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>
---
 drivers/crypto/mv_cesa.c |   61 +++++++++++++++++++++++++---------------------
 1 files changed, 33 insertions(+), 28 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 8e66080..5dba9df 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -804,35 +804,13 @@ static void mv_start_new_hash_req(struct ahash_request *req)
 	else
 		ctx->extra_bytes = 0;
 
-	p->src_sg = req->src;
-	if (req->nbytes) {
-		BUG_ON(!req->src);
-		p->sg_src_left = req->src->length;
-	}
-
-	if (hw_bytes) {
-		p->hw_nbytes = hw_bytes;
-		p->complete = mv_hash_algo_completion;
-		p->process = mv_update_hash_config;
-
-		if (unlikely(old_extra_bytes)) {
-			dma_sync_single_for_device(cpg->dev, ctx->buffer_dma,
-					SHA1_BLOCK_SIZE, DMA_TO_DEVICE);
-			mv_tdma_memcpy(cpg->sram_phys + SRAM_DATA_IN_START,
-					ctx->buffer_dma, old_extra_bytes);
-			p->crypt_len = old_extra_bytes;
+	if (unlikely(!hw_bytes)) { /* too little data for CESA */
+		if (req->nbytes) {
+			p->src_sg = req->src;
+			p->sg_src_left = req->src->length;
+			copy_src_to_buf(p, ctx->buffer + old_extra_bytes,
+					req->nbytes);
 		}
-
-		if (!mv_dma_map_sg(req->src, req->nbytes, DMA_TO_DEVICE)) {
-			printk(KERN_ERR "%s: out of memory\n", __func__);
-			return;
-		}
-
-		setup_data_in();
-		mv_init_hash_config(req);
-	} else {
-		copy_src_to_buf(p, ctx->buffer + old_extra_bytes,
-				ctx->extra_bytes - old_extra_bytes);
 		if (ctx->last_chunk)
 			rc = mv_hash_final_fallback(req);
 		else
@@ -841,7 +819,34 @@ static void mv_start_new_hash_req(struct ahash_request *req)
 		local_bh_disable();
 		req->base.complete(&req->base, rc);
 		local_bh_enable();
+		return;
 	}
+
+	if (likely(req->nbytes)) {
+		BUG_ON(!req->src);
+
+		if (!mv_dma_map_sg(req->src, req->nbytes, DMA_TO_DEVICE)) {
+			printk(KERN_ERR "%s: out of memory\n", __func__);
+			return;
+		}
+		p->sg_src_left = sg_dma_len(req->src);
+		p->src_sg = req->src;
+	}
+
+	p->hw_nbytes = hw_bytes;
+	p->complete = mv_hash_algo_completion;
+	p->process = mv_update_hash_config;
+
+	if (unlikely(old_extra_bytes)) {
+		dma_sync_single_for_device(cpg->dev, ctx->buffer_dma,
+				SHA1_BLOCK_SIZE, DMA_TO_DEVICE);
+		mv_tdma_memcpy(cpg->sram_phys + SRAM_DATA_IN_START,
+				ctx->buffer_dma, old_extra_bytes);
+		p->crypt_len = old_extra_bytes;
+	}
+
+	setup_data_in();
+	mv_init_hash_config(req);
 }
 
 static int queue_manag(void *data)
-- 
1.7.3.4
