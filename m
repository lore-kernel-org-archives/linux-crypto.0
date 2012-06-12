From: Phil Sutter <phil.sutter@viprinet.com>
Subject: [PATCH 11/13] mv_cesa: implement descriptor chaining for hashes, too
Date: Tue, 12 Jun 2012 19:17:25 +0200
Message-ID: <1339521447-17721-12-git-send-email-phil.sutter@viprinet.com>
References: <20120612113941.GA14757@gondor.apana.org.au>
 <1339521447-17721-1-git-send-email-phil.sutter@viprinet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:58637 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819Ab2FLRRx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jun 2012 13:17:53 -0400
In-Reply-To: <1339521447-17721-1-git-send-email-phil.sutter@viprinet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>
---
 drivers/crypto/mv_cesa.c |   89 ++++++++++++++++++----------------------------
 1 files changed, 35 insertions(+), 54 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 9c65980..86b73d1 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -538,34 +538,14 @@ static void mv_init_hash_config(struct ahash_request *req)
 			sizeof(struct sec_accel_sram), DMA_TO_DEVICE);
 	mv_dma_memcpy(cpg->sram_phys + SRAM_CONFIG, cpg->sa_sram_dma,
 			sizeof(struct sec_accel_sram));
-
-	mv_dma_separator();
-
-	if (req->result) {
-		req_ctx->result_dma = dma_map_single(cpg->dev, req->result,
-				req_ctx->digestsize, DMA_FROM_DEVICE);
-		mv_dma_memcpy(req_ctx->result_dma,
-				cpg->sram_phys + SRAM_DIGEST_BUF, req_ctx->digestsize);
-	} else {
-		/* XXX: this fixes some ugly register fuckup bug in the tdma engine
-		 *      (no need to sync since the data is ignored anyway) */
-		mv_dma_memcpy(cpg->sa_sram_dma,
-				cpg->sram_phys + SRAM_CONFIG, 1);
-	}
-
-	/* GO */
-	mv_setup_timer();
-	mv_dma_trigger();
-	writel(SEC_CMD_EN_SEC_ACCL0, cpg->reg + SEC_ACCEL_CMD);
 }
 
-static void mv_update_hash_config(void)
+static void mv_update_hash_config(struct ahash_request *req)
 {
-	struct ahash_request *req = ahash_request_cast(cpg->cur_req);
 	struct mv_req_hash_ctx *req_ctx = ahash_request_ctx(req);
 	struct req_progress *p = &cpg->p;
-	struct sec_accel_config *op = &cpg->sa_sram.op;
 	int is_last;
+	u32 val;
 
 	/* update only the config (for changed fragment state) and
 	 * mac_digest (for changed frag len) fields */
@@ -573,10 +553,10 @@ static void mv_update_hash_config(void)
 	switch (req_ctx->op) {
 	case COP_SHA1:
 	default:
-		op->config = CFG_OP_MAC_ONLY | CFG_MACM_SHA1;
+		val = CFG_OP_MAC_ONLY | CFG_MACM_SHA1;
 		break;
 	case COP_HMAC_SHA1:
-		op->config = CFG_OP_MAC_ONLY | CFG_MACM_HMAC_SHA1;
+		val = CFG_OP_MAC_ONLY | CFG_MACM_HMAC_SHA1;
 		break;
 	}
 
@@ -584,36 +564,11 @@ static void mv_update_hash_config(void)
 		&& (p->hw_processed_bytes + p->crypt_len >= p->hw_nbytes)
 		&& (req_ctx->count <= MAX_HW_HASH_SIZE);
 
-	op->config |= is_last ? CFG_LAST_FRAG : CFG_MID_FRAG;
-	dma_sync_single_for_device(cpg->dev, cpg->sa_sram_dma,
-			sizeof(u32), DMA_TO_DEVICE);
-	mv_dma_memcpy(cpg->sram_phys + SRAM_CONFIG,
-			cpg->sa_sram_dma, sizeof(u32));
-
-	op->mac_digest = MAC_DIGEST_P(SRAM_DIGEST_BUF) | MAC_FRAG_LEN(p->crypt_len);
-	dma_sync_single_for_device(cpg->dev, cpg->sa_sram_dma + 6 * sizeof(u32),
-			sizeof(u32), DMA_TO_DEVICE);
-	mv_dma_memcpy(cpg->sram_phys + SRAM_CONFIG + 6 * sizeof(u32),
-			cpg->sa_sram_dma + 6 * sizeof(u32), sizeof(u32));
-
-	mv_dma_separator();
-
-	if (req->result) {
-		req_ctx->result_dma = dma_map_single(cpg->dev, req->result,
-				req_ctx->digestsize, DMA_FROM_DEVICE);
-		mv_dma_memcpy(req_ctx->result_dma,
-				cpg->sram_phys + SRAM_DIGEST_BUF, req_ctx->digestsize);
-	} else {
-		/* XXX: this fixes some ugly register fuckup bug in the tdma engine
-		 *      (no need to sync since the data is ignored anyway) */
-		mv_dma_memcpy(cpg->sa_sram_dma,
-				cpg->sram_phys + SRAM_CONFIG, 1);
-	}
+	val |= is_last ? CFG_LAST_FRAG : CFG_MID_FRAG;
+	mv_dma_u32_copy(cpg->sram_phys + SRAM_CONFIG, val);
 
-	/* GO */
-	mv_setup_timer();
-	mv_dma_trigger();
-	writel(SEC_CMD_EN_SEC_ACCL0, cpg->reg + SEC_ACCEL_CMD);
+	val = MAC_DIGEST_P(SRAM_DIGEST_BUF) | MAC_FRAG_LEN(p->crypt_len);
+	mv_dma_u32_copy(cpg->sram_phys + SRAM_CONFIG + 6 * sizeof(u32), val);
 }
 
 static inline int mv_hash_import_sha1_ctx(const struct mv_req_hash_ctx *ctx,
@@ -837,7 +792,6 @@ static void mv_start_new_hash_req(struct ahash_request *req)
 
 	p->hw_nbytes = hw_bytes;
 	p->complete = mv_hash_algo_completion;
-	p->process = mv_update_hash_config;
 
 	if (unlikely(old_extra_bytes)) {
 		dma_sync_single_for_device(cpg->dev, ctx->buffer_dma,
@@ -849,6 +803,33 @@ static void mv_start_new_hash_req(struct ahash_request *req)
 
 	setup_data_in();
 	mv_init_hash_config(req);
+	mv_dma_separator();
+	cpg->p.hw_processed_bytes += cpg->p.crypt_len;
+	while (cpg->p.hw_processed_bytes < cpg->p.hw_nbytes) {
+		cpg->p.crypt_len = 0;
+
+		setup_data_in();
+		mv_update_hash_config(req);
+		mv_dma_separator();
+		cpg->p.hw_processed_bytes += cpg->p.crypt_len;
+	}
+	if (req->result) {
+		ctx->result_dma = dma_map_single(cpg->dev, req->result,
+				ctx->digestsize, DMA_FROM_DEVICE);
+		mv_dma_memcpy(ctx->result_dma,
+				cpg->sram_phys + SRAM_DIGEST_BUF,
+				ctx->digestsize);
+	} else {
+		/* XXX: this fixes some ugly register fuckup bug in the tdma engine
+		 *      (no need to sync since the data is ignored anyway) */
+		mv_dma_memcpy(cpg->sa_sram_dma,
+				cpg->sram_phys + SRAM_CONFIG, 1);
+	}
+
+	/* GO */
+	mv_setup_timer();
+	mv_dma_trigger();
+	writel(SEC_CMD_EN_SEC_ACCL0, cpg->reg + SEC_ACCEL_CMD);
 }
 
 static int queue_manag(void *data)
-- 
1.7.3.4
