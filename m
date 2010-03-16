From: Uri Simchoni <uri@jdland.co.il>
Subject: [PATCH 7/10] crypto mv_cesa : Execute some code via function pointers
 rathr than direct calls
Date: Tue, 16 Mar 2010 16:52:31 +0200
Message-ID: <4B9F9B2F.3030609@jdland.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www011.intervision.co.il ([80.244.168.31]:33526 "EHLO
	www011.intervision.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966380Ab0CPOwq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Mar 2010 10:52:46 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Execute some code via function pointers rathr than direct calls
(to allow customization in the hashing request)

Signed-off-by: Uri Simchoni <uri@jdland.co.il>
---
diff -upr linux-2.6.32.8_p6/drivers/crypto/mv_cesa.c 
linux-2.6.32.8_p7/drivers/crypto/mv_cesa.c
--- linux-2.6.32.8_p6/drivers/crypto/mv_cesa.c    2010-03-16 
11:51:56.372211208 +0200
+++ linux-2.6.32.8_p7/drivers/crypto/mv_cesa.c    2010-03-16 
12:07:31.147897717 +0200
@@ -51,6 +51,8 @@ enum engine_status {
  struct req_progress {
      struct sg_mapping_iter src_sg_it;
      struct sg_mapping_iter dst_sg_it;
+    void (*complete) (void);
+    void (*process) (int is_first);

      /* src mostly */
      int sg_src_left;
@@ -251,6 +253,9 @@ static void mv_crypto_algo_completion(vo
      struct ablkcipher_request *req = 
ablkcipher_request_cast(cpg->cur_req);
      struct mv_req_ctx *req_ctx = ablkcipher_request_ctx(req);

+    sg_miter_stop(&cpg->p.src_sg_it);
+    sg_miter_stop(&cpg->p.dst_sg_it);
+
      if (req_ctx->op != COP_AES_CBC)
          return ;

@@ -294,11 +299,9 @@ static void dequeue_complete_req(void)
      if (cpg->p.hw_processed_bytes < cpg->p.hw_nbytes) {
          /* process next scatter list entry */
          cpg->eng_st = ENGINE_BUSY;
-        mv_process_current_q(0);
+        cpg->p.process(0);
      } else {
-        sg_miter_stop(&cpg->p.src_sg_it);
-        sg_miter_stop(&cpg->p.dst_sg_it);
-        mv_crypto_algo_completion();
+        cpg->p.complete();
          cpg->eng_st = ENGINE_IDLE;
          local_bh_disable();
          req->complete(req, 0);
@@ -331,6 +334,8 @@ static void mv_enqueue_new_req(struct ab
      cpg->cur_req = &req->base;
      memset(p, 0, sizeof(struct req_progress));
      p->hw_nbytes = req->nbytes;
+    p->complete = mv_crypto_algo_completion;
+    p->process = mv_process_current_q;

      num_sgs = count_sgs(req->src, req->nbytes);
      sg_miter_start(&p->src_sg_it, req->src, num_sgs, SG_MITER_FROM_SG);

