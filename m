From: Phil Sutter <phil.sutter@viprinet.com>
Subject: [PATCH 04/13] mv_cesa: split up processing callbacks
Date: Fri, 25 May 2012 18:08:30 +0200
Message-ID: <1337962119-5509-5-git-send-email-phil.sutter@viprinet.com>
References: <1337962119-5509-1-git-send-email-phil.sutter@viprinet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:47876 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752957Ab2EYQIx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 May 2012 12:08:53 -0400
In-Reply-To: <1337962119-5509-1-git-send-email-phil.sutter@viprinet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Have a dedicated function initialising the full SRAM config, then use a
minimal callback for changing only relevant parts of it.

Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>
---
 drivers/crypto/mv_cesa.c |   87 +++++++++++++++++++++++++++++++++------------
 1 files changed, 64 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 68b83d8..4a989ea 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -62,7 +62,7 @@ struct req_progress {
 	struct scatterlist *src_sg;
 	struct scatterlist *dst_sg;
 	void (*complete) (void);
-	void (*process) (int is_first);
+	void (*process) (void);
 
 	/* src mostly */
 	int sg_src_left;
@@ -265,9 +265,8 @@ static void setup_data_in(void)
 	p->crypt_len = data_in_sram;
 }
 
-static void mv_process_current_q(int first_block)
+static void mv_init_crypt_config(struct ablkcipher_request *req)
 {
-	struct ablkcipher_request *req = ablkcipher_request_cast(cpg->cur_req);
 	struct mv_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
 	struct mv_req_ctx *req_ctx = ablkcipher_request_ctx(req);
 	struct sec_accel_config *op = &cpg->sa_sram.op;
@@ -281,8 +280,6 @@ static void mv_process_current_q(int first_block)
 		op->config = CFG_OP_CRYPT_ONLY | CFG_ENCM_AES | CFG_ENC_MODE_CBC;
 		op->enc_iv = ENC_IV_POINT(SRAM_DATA_IV) |
 			ENC_IV_BUF_POINT(SRAM_DATA_IV_BUF);
-		if (!first_block)
-			memcpy(req->info, cpg->sram + SRAM_DATA_IV_BUF, 16);
 		memcpy(cpg->sa_sram.sa_iv, req->info, 16);
 		break;
 	}
@@ -308,9 +305,8 @@ static void mv_process_current_q(int first_block)
 	op->enc_p = ENC_P_SRC(SRAM_DATA_IN_START) |
 		ENC_P_DST(SRAM_DATA_OUT_START);
 	op->enc_key_p = SRAM_DATA_KEY_P;
-
-	setup_data_in();
 	op->enc_len = cpg->p.crypt_len;
+
 	memcpy(cpg->sram + SRAM_CONFIG, &cpg->sa_sram,
 			sizeof(struct sec_accel_sram));
 
@@ -319,6 +315,17 @@ static void mv_process_current_q(int first_block)
 	writel(SEC_CMD_EN_SEC_ACCL0, cpg->reg + SEC_ACCEL_CMD);
 }
 
+static void mv_update_crypt_config(void)
+{
+	/* update the enc_len field only */
+	memcpy(cpg->sram + SRAM_CONFIG + 2 * sizeof(u32),
+			&cpg->p.crypt_len, sizeof(u32));
+
+	/* GO */
+	mv_setup_timer();
+	writel(SEC_CMD_EN_SEC_ACCL0, cpg->reg + SEC_ACCEL_CMD);
+}
+
 static void mv_crypto_algo_completion(void)
 {
 	struct ablkcipher_request *req = ablkcipher_request_cast(cpg->cur_req);
@@ -330,9 +337,8 @@ static void mv_crypto_algo_completion(void)
 	memcpy(req->info, cpg->sram + SRAM_DATA_IV_BUF, 16);
 }
 
-static void mv_process_hash_current(int first_block)
+static void mv_init_hash_config(struct ahash_request *req)
 {
-	struct ahash_request *req = ahash_request_cast(cpg->cur_req);
 	const struct mv_tfm_hash_ctx *tfm_ctx = crypto_tfm_ctx(req->base.tfm);
 	struct mv_req_hash_ctx *req_ctx = ahash_request_ctx(req);
 	struct req_progress *p = &cpg->p;
@@ -355,8 +361,6 @@ static void mv_process_hash_current(int first_block)
 		MAC_SRC_DATA_P(SRAM_DATA_IN_START) |
 		MAC_SRC_TOTAL_LEN((u32)req_ctx->count);
 
-	setup_data_in();
-
 	op->mac_digest =
 		MAC_DIGEST_P(SRAM_DIGEST_BUF) | MAC_FRAG_LEN(p->crypt_len);
 	op->mac_iv =
@@ -379,13 +383,11 @@ static void mv_process_hash_current(int first_block)
 		else
 			op->config |= CFG_MID_FRAG;
 
-		if (first_block) {
-			writel(req_ctx->state[0], cpg->reg + DIGEST_INITIAL_VAL_A);
-			writel(req_ctx->state[1], cpg->reg + DIGEST_INITIAL_VAL_B);
-			writel(req_ctx->state[2], cpg->reg + DIGEST_INITIAL_VAL_C);
-			writel(req_ctx->state[3], cpg->reg + DIGEST_INITIAL_VAL_D);
-			writel(req_ctx->state[4], cpg->reg + DIGEST_INITIAL_VAL_E);
-		}
+		writel(req_ctx->state[0], cpg->reg + DIGEST_INITIAL_VAL_A);
+		writel(req_ctx->state[1], cpg->reg + DIGEST_INITIAL_VAL_B);
+		writel(req_ctx->state[2], cpg->reg + DIGEST_INITIAL_VAL_C);
+		writel(req_ctx->state[3], cpg->reg + DIGEST_INITIAL_VAL_D);
+		writel(req_ctx->state[4], cpg->reg + DIGEST_INITIAL_VAL_E);
 	}
 
 	memcpy(cpg->sram + SRAM_CONFIG, &cpg->sa_sram,
@@ -396,6 +398,42 @@ static void mv_process_hash_current(int first_block)
 	writel(SEC_CMD_EN_SEC_ACCL0, cpg->reg + SEC_ACCEL_CMD);
 }
 
+static void mv_update_hash_config(void)
+{
+	struct ahash_request *req = ahash_request_cast(cpg->cur_req);
+	struct mv_req_hash_ctx *req_ctx = ahash_request_ctx(req);
+	struct req_progress *p = &cpg->p;
+	struct sec_accel_config *op = &cpg->sa_sram.op;
+	int is_last;
+
+	/* update only the config (for changed fragment state) and
+	 * mac_digest (for changed frag len) fields */
+
+	switch (req_ctx->op) {
+	case COP_SHA1:
+	default:
+		op->config = CFG_OP_MAC_ONLY | CFG_MACM_SHA1;
+		break;
+	case COP_HMAC_SHA1:
+		op->config = CFG_OP_MAC_ONLY | CFG_MACM_HMAC_SHA1;
+		break;
+	}
+
+	is_last = req_ctx->last_chunk
+		&& (p->hw_processed_bytes + p->crypt_len >= p->hw_nbytes)
+		&& (req_ctx->count <= MAX_HW_HASH_SIZE);
+
+	op->config |= is_last ? CFG_LAST_FRAG : CFG_MID_FRAG;
+	memcpy(cpg->sram + SRAM_CONFIG, &op->config, sizeof(u32));
+
+	op->mac_digest = MAC_DIGEST_P(SRAM_DIGEST_BUF) | MAC_FRAG_LEN(p->crypt_len);
+	memcpy(cpg->sram + SRAM_CONFIG + 6 * sizeof(u32), &op->mac_digest, sizeof(u32));
+
+	/* GO */
+	mv_setup_timer();
+	writel(SEC_CMD_EN_SEC_ACCL0, cpg->reg + SEC_ACCEL_CMD);
+}
+
 static inline int mv_hash_import_sha1_ctx(const struct mv_req_hash_ctx *ctx,
 					  struct shash_desc *desc)
 {
@@ -507,7 +545,8 @@ static void dequeue_complete_req(void)
 	if (cpg->p.hw_processed_bytes < cpg->p.hw_nbytes) {
 		/* process next scatter list entry */
 		cpg->eng_st = ENGINE_BUSY;
-		cpg->p.process(0);
+		setup_data_in();
+		cpg->p.process();
 	} else {
 		cpg->p.complete();
 		cpg->eng_st = ENGINE_IDLE;
@@ -542,7 +581,7 @@ static void mv_start_new_crypt_req(struct ablkcipher_request *req)
 	memset(p, 0, sizeof(struct req_progress));
 	p->hw_nbytes = req->nbytes;
 	p->complete = mv_crypto_algo_completion;
-	p->process = mv_process_current_q;
+	p->process = mv_update_crypt_config;
 	p->copy_back = 1;
 
 	p->src_sg = req->src;
@@ -554,7 +593,8 @@ static void mv_start_new_crypt_req(struct ablkcipher_request *req)
 		p->sg_dst_left = req->dst->length;
 	}
 
-	mv_process_current_q(1);
+	setup_data_in();
+	mv_init_crypt_config(req);
 }
 
 static void mv_start_new_hash_req(struct ahash_request *req)
@@ -583,7 +623,7 @@ static void mv_start_new_hash_req(struct ahash_request *req)
 	if (hw_bytes) {
 		p->hw_nbytes = hw_bytes;
 		p->complete = mv_hash_algo_completion;
-		p->process = mv_process_hash_current;
+		p->process = mv_update_hash_config;
 
 		if (unlikely(old_extra_bytes)) {
 			memcpy(cpg->sram + SRAM_DATA_IN_START, ctx->buffer,
@@ -591,7 +631,8 @@ static void mv_start_new_hash_req(struct ahash_request *req)
 			p->crypt_len = old_extra_bytes;
 		}
 
-		mv_process_hash_current(1);
+		setup_data_in();
+		mv_init_hash_config(req);
 	} else {
 		copy_src_to_buf(p, ctx->buffer + old_extra_bytes,
 				ctx->extra_bytes - old_extra_bytes);
-- 
1.7.3.4
