From: Uri Simchoni <uri@jdland.co.il>
Subject: [PATCH 6/10] crypto mv_cesa : Rename a variable to a more suitable
 name
Date: Tue, 16 Mar 2010 16:51:07 +0200
Message-ID: <4B9F9ADB.4020906@jdland.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www011.intervision.co.il ([80.244.168.31]:33489 "EHLO
	www011.intervision.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966284Ab0CPOvX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Mar 2010 10:51:23 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Rename a variable to a more suitable name

Signed-off-by: Uri Simchoni <uri@jdland.co.il>
---
diff -upr linux-2.6.32.8_p5/drivers/crypto/mv_cesa.c 
linux-2.6.32.8_p6/drivers/crypto/mv_cesa.c
--- linux-2.6.32.8_p5/drivers/crypto/mv_cesa.c    2010-03-16 
11:43:37.443646086 +0200
+++ linux-2.6.32.8_p6/drivers/crypto/mv_cesa.c    2010-03-16 
11:51:56.372211208 +0200
@@ -42,7 +42,7 @@ enum engine_status {
   * @hw_nbytes:        total bytes to process in hw for this request
   * @sg_dst_left:    bytes left dst to process in this scatter list
   * @dst_start:        offset to add to dst start position (scatter list)
- * @total_req_bytes:    total number of bytes processed (request).
+ * @hw_processed_bytes:    number of bytes processed by hw (request).
   *
   * sg helper are used to iterate over the scatterlist. Since the size 
of the
   * SRAM may be less than the scatter size, this struct struct is used 
to keep
@@ -60,7 +60,7 @@ struct req_progress {
      /* dst mostly */
      int sg_dst_left;
      int dst_start;
-    int total_req_bytes;
+    int hw_processed_bytes;
  };

  struct crypto_priv {
@@ -181,7 +181,7 @@ static void setup_data_in(void)
  {
      struct req_progress *p = &cpg->p;
      p->crypt_len =
-        min(p->hw_nbytes - p->total_req_bytes, cpg->max_req_size);
+        min(p->hw_nbytes - p->hw_processed_bytes, cpg->max_req_size);
      copy_src_to_buf(p, cpg->sram + SRAM_DATA_IN_START,
              p->crypt_len);
  }
@@ -265,7 +265,7 @@ static void dequeue_complete_req(void)
      int need_copy_len = cpg->p.crypt_len;
      int sram_offset = 0;

-    cpg->p.total_req_bytes += cpg->p.crypt_len;
+    cpg->p.hw_processed_bytes += cpg->p.crypt_len;
      do {
          int dst_copy;

@@ -291,7 +291,7 @@ static void dequeue_complete_req(void)
      } while (need_copy_len > 0);

      BUG_ON(cpg->eng_st != ENGINE_W_DEQUEUE);
-    if (cpg->p.total_req_bytes < cpg->p.hw_nbytes) {
+    if (cpg->p.hw_processed_bytes < cpg->p.hw_nbytes) {
          /* process next scatter list entry */
          cpg->eng_st = ENGINE_BUSY;
          mv_process_current_q(0);

