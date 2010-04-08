From: Uri Simchoni <uri@jdland.co.il>
Subject: [PATCHv2 5/10] crypto mv_cesa : Enqueue generic async requests
Date: Thu, 08 Apr 2010 19:27:33 +0300
Message-ID: <4BBE03F5.9010406@jdland.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www011.intervision.co.il ([80.244.168.31]:36900 "EHLO
	www011.intervision.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758818Ab0DHQ1u (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Apr 2010 12:27:50 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Enqueue generic async requests rather than ablkcipher requests
in the driver's queue

Signed-off-by: Uri Simchoni <uri@jdland.co.il>
---
diff -upr linux-2.6.32.8_p4/drivers/crypto/mv_cesa.c linux-2.6.32.8_p5/drivers/crypto/mv_cesa.c
--- linux-2.6.32.8_p4/drivers/crypto/mv_cesa.c	2010-03-16 10:54:07.322816221 +0200
+++ linux-2.6.32.8_p5/drivers/crypto/mv_cesa.c	2010-03-16 11:43:37.443646086 +0200
@@ -39,6 +39,7 @@ enum engine_status {
  * @sg_src_left:	bytes left in src to process (scatter list)
  * @src_start:		offset to add to src start position (scatter list)
  * @crypt_len:		length of current crypt process
+ * @hw_nbytes:		total bytes to process in hw for this request
  * @sg_dst_left:	bytes left dst to process in this scatter list
  * @dst_start:		offset to add to dst start position (scatter list)
  * @total_req_bytes:	total number of bytes processed (request).
@@ -55,6 +56,7 @@ struct req_progress {
 	int sg_src_left;
 	int src_start;
 	int crypt_len;
+	int hw_nbytes;
 	/* dst mostly */
 	int sg_dst_left;
 	int dst_start;
@@ -71,7 +73,7 @@ struct crypto_priv {
 	spinlock_t lock;
 	struct crypto_queue queue;
 	enum engine_status eng_st;
-	struct ablkcipher_request *cur_req;
+	struct crypto_async_request *cur_req;
 	struct req_progress p;
 	int max_req_size;
 	int sram_size;
@@ -175,18 +177,18 @@ static void copy_src_to_buf(struct req_p
 	}
 }
 
-static void setup_data_in(struct ablkcipher_request *req)
+static void setup_data_in(void)
 {
 	struct req_progress *p = &cpg->p;
 	p->crypt_len =
-	    min((int)req->nbytes - p->total_req_bytes, cpg->max_req_size);
+	    min(p->hw_nbytes - p->total_req_bytes, cpg->max_req_size);
 	copy_src_to_buf(p, cpg->sram + SRAM_DATA_IN_START,
 			p->crypt_len);
 }
 
 static void mv_process_current_q(int first_block)
 {
-	struct ablkcipher_request *req = cpg->cur_req;
+	struct ablkcipher_request *req = ablkcipher_request_cast(cpg->cur_req);
 	struct mv_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
 	struct mv_req_ctx *req_ctx = ablkcipher_request_ctx(req);
 	struct sec_accel_config op;
@@ -229,7 +231,7 @@ static void mv_process_current_q(int fir
 		ENC_P_DST(SRAM_DATA_OUT_START);
 	op.enc_key_p = SRAM_DATA_KEY_P;
 
-	setup_data_in(req);
+	setup_data_in();
 	op.enc_len = cpg->p.crypt_len;
 	memcpy(cpg->sram + SRAM_CONFIG, &op,
 			sizeof(struct sec_accel_config));
@@ -246,7 +248,7 @@ static void mv_process_current_q(int fir
 
 static void mv_crypto_algo_completion(void)
 {
-	struct ablkcipher_request *req = cpg->cur_req;
+	struct ablkcipher_request *req = ablkcipher_request_cast(cpg->cur_req);
 	struct mv_req_ctx *req_ctx = ablkcipher_request_ctx(req);
 
 	if (req_ctx->op != COP_AES_CBC)
@@ -257,7 +259,7 @@ static void mv_crypto_algo_completion(vo
 
 static void dequeue_complete_req(void)
 {
-	struct ablkcipher_request *req = cpg->cur_req;
+	struct crypto_async_request *req = cpg->cur_req;
 	void *buf;
 	int ret;
 	int need_copy_len = cpg->p.crypt_len;
@@ -289,7 +291,7 @@ static void dequeue_complete_req(void)
 	} while (need_copy_len > 0);
 
 	BUG_ON(cpg->eng_st != ENGINE_W_DEQUEUE);
-	if (cpg->p.total_req_bytes < req->nbytes) {
+	if (cpg->p.total_req_bytes < cpg->p.hw_nbytes) {
 		/* process next scatter list entry */
 		cpg->eng_st = ENGINE_BUSY;
 		mv_process_current_q(0);
@@ -299,7 +301,7 @@ static void dequeue_complete_req(void)
 		mv_crypto_algo_completion();
 		cpg->eng_st = ENGINE_IDLE;
 		local_bh_disable();
-		req->base.complete(&req->base, 0);
+		req->complete(req, 0);
 		local_bh_enable();
 	}
 }
@@ -323,16 +325,19 @@ static int count_sgs(struct scatterlist 
 
 static void mv_enqueue_new_req(struct ablkcipher_request *req)
 {
+	struct req_progress *p = &cpg->p;
 	int num_sgs;
 
-	cpg->cur_req = req;
-	memset(&cpg->p, 0, sizeof(struct req_progress));
+	cpg->cur_req = &req->base;
+	memset(p, 0, sizeof(struct req_progress));
+	p->hw_nbytes = req->nbytes;
 
 	num_sgs = count_sgs(req->src, req->nbytes);
-	sg_miter_start(&cpg->p.src_sg_it, req->src, num_sgs, SG_MITER_FROM_SG);
+	sg_miter_start(&p->src_sg_it, req->src, num_sgs, SG_MITER_FROM_SG);
 
 	num_sgs = count_sgs(req->dst, req->nbytes);
-	sg_miter_start(&cpg->p.dst_sg_it, req->dst, num_sgs, SG_MITER_TO_SG);
+	sg_miter_start(&p->dst_sg_it, req->dst, num_sgs, SG_MITER_TO_SG);
+
 	mv_process_current_q(1);
 }
 
@@ -378,13 +383,13 @@ static int queue_manag(void *data)
 	return 0;
 }
 
-static int mv_handle_req(struct ablkcipher_request *req)
+static int mv_handle_req(struct crypto_async_request *req)
 {
 	unsigned long flags;
 	int ret;
 
 	spin_lock_irqsave(&cpg->lock, flags);
-	ret = ablkcipher_enqueue_request(&cpg->queue, req);
+	ret = crypto_enqueue_request(&cpg->queue, req);
 	spin_unlock_irqrestore(&cpg->lock, flags);
 	wake_up_process(cpg->queue_th);
 	return ret;
@@ -397,7 +402,7 @@ static int mv_enc_aes_ecb(struct ablkcip
 	req_ctx->op = COP_AES_ECB;
 	req_ctx->decrypt = 0;
 
-	return mv_handle_req(req);
+	return mv_handle_req(&req->base);
 }
 
 static int mv_dec_aes_ecb(struct ablkcipher_request *req)
@@ -409,7 +414,7 @@ static int mv_dec_aes_ecb(struct ablkcip
 	req_ctx->decrypt = 1;
 
 	compute_aes_dec_key(ctx);
-	return mv_handle_req(req);
+	return mv_handle_req(&req->base);
 }
 
 static int mv_enc_aes_cbc(struct ablkcipher_request *req)
@@ -419,7 +424,7 @@ static int mv_enc_aes_cbc(struct ablkcip
 	req_ctx->op = COP_AES_CBC;
 	req_ctx->decrypt = 0;
 
-	return mv_handle_req(req);
+	return mv_handle_req(&req->base);
 }
 
 static int mv_dec_aes_cbc(struct ablkcipher_request *req)
@@ -431,7 +436,7 @@ static int mv_dec_aes_cbc(struct ablkcip
 	req_ctx->decrypt = 1;
 
 	compute_aes_dec_key(ctx);
-	return mv_handle_req(req);
+	return mv_handle_req(&req->base);
 }
 
 static int mv_cra_init(struct crypto_tfm *tfm)


