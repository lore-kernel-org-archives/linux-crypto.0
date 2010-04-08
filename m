From: Uri Simchoni <uri@jdland.co.il>
Subject: [PATCHv2 1/10] crypto mv_cesa : Invoke the user callback from a softirq
 context
Date: Thu, 08 Apr 2010 19:25:37 +0300
Message-ID: <4BBE0381.6080002@jdland.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www011.intervision.co.il ([80.244.168.31]:36862 "EHLO
	www011.intervision.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932887Ab0DHQZu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Apr 2010 12:25:50 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Invoke the user callback from a softirq context

Signed-off-by: Uri Simchoni <uri@jdland.co.il>
---
diff -upr linux-2.6.32.8_orig/drivers/crypto/mv_cesa.c linux-2.6.32.8_p1/drivers/crypto/mv_cesa.c
--- linux-2.6.32.8_orig/drivers/crypto/mv_cesa.c	2010-02-09 14:57:19.000000000 +0200
+++ linux-2.6.32.8_p1/drivers/crypto/mv_cesa.c	2010-03-16 08:59:12.074583163 +0200
@@ -275,7 +275,9 @@ static void dequeue_complete_req(void)
 		sg_miter_stop(&cpg->p.dst_sg_it);
 		mv_crypto_algo_completion();
 		cpg->eng_st = ENGINE_IDLE;
+		local_bh_disable();
 		req->base.complete(&req->base, 0);
+		local_bh_enable();
 	}
 }
 


