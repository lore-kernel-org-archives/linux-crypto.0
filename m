From: Uri Simchoni <uri@jdland.co.il>
Subject: [PATCHv2 9/10] crypto mv_cesa : Support processing of data from previous
 requests
Date: Thu, 08 Apr 2010 19:33:26 +0300
Message-ID: <4BBE0556.3080501@jdland.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www011.intervision.co.il ([80.244.168.31]:36985 "EHLO
	www011.intervision.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758788Ab0DHQdp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Apr 2010 12:33:45 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Support processing of data from previous requests (as in hashing
update/final requests).

Signed-off-by: Uri Simchoni <uri@jdland.co.il>
---
diff -upr linux-2.6.32.8_p8/drivers/crypto/mv_cesa.c linux-2.6.32.8_p9/drivers/crypto/mv_cesa.c
--- linux-2.6.32.8_p8/drivers/crypto/mv_cesa.c	2010-03-16 12:25:34.815950170 +0200
+++ linux-2.6.32.8_p9/drivers/crypto/mv_cesa.c	2010-03-16 12:33:45.504199755 +0200
@@ -184,10 +184,11 @@ static void copy_src_to_buf(struct req_p
 static void setup_data_in(void)
 {
 	struct req_progress *p = &cpg->p;
-	p->crypt_len =
+	int data_in_sram =
 	    min(p->hw_nbytes - p->hw_processed_bytes, cpg->max_req_size);
-	copy_src_to_buf(p, cpg->sram + SRAM_DATA_IN_START,
-			p->crypt_len);
+	copy_src_to_buf(p, cpg->sram + SRAM_DATA_IN_START + p->crypt_len,
+			data_in_sram - p->crypt_len);
+	p->crypt_len = data_in_sram;
 }
 
 static void mv_process_current_q(int first_block)
@@ -298,6 +299,7 @@ static void dequeue_complete_req(void)
 		} while (need_copy_len > 0);
 	}
 
+	cpg->p.crypt_len = 0;
 
 	BUG_ON(cpg->eng_st != ENGINE_W_DEQUEUE);
 	if (cpg->p.hw_processed_bytes < cpg->p.hw_nbytes) {


