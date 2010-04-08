From: Uri Simchoni <uri@jdland.co.il>
Subject: [PATCHv2 3/10] crypto mv_cesa : Fix situation where the dest sglist
 is organized differently than the source sglist
Date: Thu, 08 Apr 2010 19:26:34 +0300
Message-ID: <4BBE03BA.90208@jdland.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www011.intervision.co.il ([80.244.168.31]:36881 "EHLO
	www011.intervision.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515Ab0DHQ0u (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Apr 2010 12:26:50 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Bugfix for situations where the destination scatterlist has a different
buffer structure than the source scatterlist (e.g. source has one 2K
buffer and dest has 2 1K buffers)

Signed-off-by: Uri Simchoni <uri@jdland.co.il>
---
diff -upr linux-2.6.32.8_p2/drivers/crypto/mv_cesa.c linux-2.6.32.8_p3/drivers/crypto/mv_cesa.c
--- linux-2.6.32.8_p2/drivers/crypto/mv_cesa.c	2010-03-16 09:04:01.860953458 +0200
+++ linux-2.6.32.8_p3/drivers/crypto/mv_cesa.c	2010-03-16 09:06:10.183753278 +0200
@@ -242,6 +242,8 @@ static void dequeue_complete_req(void)
 	struct ablkcipher_request *req = cpg->cur_req;
 	void *buf;
 	int ret;
+	int need_copy_len = cpg->p.crypt_len;
+	int sram_offset = 0;
 
 	cpg->p.total_req_bytes += cpg->p.crypt_len;
 	do {
@@ -257,14 +259,16 @@ static void dequeue_complete_req(void)
 		buf = cpg->p.dst_sg_it.addr;
 		buf += cpg->p.dst_start;
 
-		dst_copy = min(cpg->p.crypt_len, cpg->p.sg_dst_left);
