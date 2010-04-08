From: Uri Simchoni <uri@jdland.co.il>
Subject: [PATCHv2 8/10] crypto mv_cesa : Make the copy-back of data optional
Date: Thu, 08 Apr 2010 19:31:48 +0300
Message-ID: <4BBE04F4.4010701@jdland.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www011.intervision.co.il ([80.244.168.31]:36967 "EHLO
	www011.intervision.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758818Ab0DHQcE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Apr 2010 12:32:04 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Make the copy-back of data optional (not done in hashing requests)

Signed-off-by: Uri Simchoni <uri@jdland.co.il>
---
diff -upr linux-2.6.32.8_p7/drivers/crypto/mv_cesa.c linux-2.6.32.8_p8/drivers/crypto/mv_cesa.c
--- linux-2.6.32.8_p7/drivers/crypto/mv_cesa.c	2010-03-16 12:07:31.147897717 +0200
+++ linux-2.6.32.8_p8/drivers/crypto/mv_cesa.c	2010-03-16 12:25:34.815950170 +0200
@@ -40,6 +40,7 @@ enum engine_status {
  * @src_start:		offset to add to src start position (scatter list)
  * @crypt_len:		length of current crypt process
  * @hw_nbytes:		total bytes to process in hw for this request
+ * @copy_back:		whether to copy data back (crypt) or not (hash)
  * @sg_dst_left:	bytes left dst to process in this scatter list
  * @dst_start:		offset to add to dst start position (scatter list)
  * @hw_processed_bytes:	number of bytes processed by hw (request).
@@ -60,6 +61,7 @@ struct req_progress {
 	int crypt_len;
 	int hw_nbytes;
 	/* dst mostly */
+	int copy_back;
 	int sg_dst_left;
 	int dst_start;
 	int hw_processed_bytes;
@@ -267,33 +269,35 @@ static void dequeue_complete_req(void)
 	struct crypto_async_request *req = cpg->cur_req;
 	void *buf;
 	int ret;
-	int need_copy_len = cpg->p.crypt_len;
-	int sram_offset = 0;
-
 	cpg->p.hw_processed_bytes += cpg->p.crypt_len;
-	do {
-		int dst_copy;
+	if (cpg->p.copy_back) {
+		int need_copy_len = cpg->p.crypt_len;
+		int sram_offset = 0;
+		do {
+			int dst_copy;
+
+			if (!cpg->p.sg_dst_left) {
+				ret = sg_miter_next(&cpg->p.dst_sg_it);
+				BUG_ON(!ret);
+				cpg->p.sg_dst_left = cpg->p.dst_sg_it.length;
+				cpg->p.dst_start = 0;
+			}
 
-		if (!cpg->p.sg_dst_left) {
-			ret = sg_miter_next(&cpg->p.dst_sg_it);
-			BUG_ON(!ret);
-			cpg->p.sg_dst_left = cpg->p.dst_sg_it.length;
-			cpg->p.dst_start = 0;
-		}
+			buf = cpg->p.dst_sg_it.addr;
+			buf += cpg->p.dst_start;
 
-		buf = cpg->p.dst_sg_it.addr;
-		buf += cpg->p.dst_start;
+			dst_copy = min(need_copy_len, cpg->p.sg_dst_left);
 
-		dst_copy = min(need_copy_len, cpg->p.sg_dst_left);
+			memcpy(buf,
+			       cpg->sram + SRAM_DATA_OUT_START + sram_offset,
+			       dst_copy);
+			sram_offset += dst_copy;
+			cpg->p.sg_dst_left -= dst_copy;
+			need_copy_len -= dst_copy;
+			cpg->p.dst_start += dst_copy;
+		} while (need_copy_len > 0);
+	}
 
-		memcpy(buf,
-		       cpg->sram + SRAM_DATA_OUT_START + sram_offset,
-		       dst_copy);
-		sram_offset += dst_copy;
-		cpg->p.sg_dst_left -= dst_copy;
-		need_copy_len -= dst_copy;
-		cpg->p.dst_start += dst_copy;
-	} while (need_copy_len > 0);
 
 	BUG_ON(cpg->eng_st != ENGINE_W_DEQUEUE);
 	if (cpg->p.hw_processed_bytes < cpg->p.hw_nbytes) {
@@ -336,6 +340,7 @@ static void mv_enqueue_new_req(struct ab
 	p->hw_nbytes = req->nbytes;
 	p->complete = mv_crypto_algo_completion;
 	p->process = mv_process_current_q;
+	p->copy_back = 1;
 
 	num_sgs = count_sgs(req->src, req->nbytes);
 	sg_miter_start(&p->src_sg_it, req->src, num_sgs, SG_MITER_FROM_SG);


