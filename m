From: Uri Simchoni <uri@jdland.co.il>
Subject: [PATCHv2 4/10] crypto mv_cesa : Fix situations where the src sglist
 spans more data than the request asks for
Date: Thu, 08 Apr 2010 19:27:02 +0300
Message-ID: <4BBE03D6.3000602@jdland.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www011.intervision.co.il ([80.244.168.31]:36890 "EHLO
	www011.intervision.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758842Ab0DHQ1O (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Apr 2010 12:27:14 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix for situations where the source scatterlist spans more data than the
request nbytes

Signed-off-by: Uri Simchoni <uri@jdland.co.il>
---
diff -upr linux-2.6.32.8_p3/drivers/crypto/mv_cesa.c linux-2.6.32.8_p4/drivers/crypto/mv_cesa.c
--- linux-2.6.32.8_p3/drivers/crypto/mv_cesa.c	2010-03-16 09:06:10.183753278 +0200
+++ linux-2.6.32.8_p4/drivers/crypto/mv_cesa.c	2010-03-16 08:40:09.503257114 +0200
@@ -143,27 +143,45 @@ static int mv_setkey_aes(struct crypto_a
 	return 0;
 }
 
-static void setup_data_in(struct ablkcipher_request *req)
+static void copy_src_to_buf(struct req_progress *p, char *dbuf, int len)
 {
 	int ret;
-	void *buf;
-
-	if (!cpg->p.sg_src_left) {
-		ret = sg_miter_next(&cpg->p.src_sg_it);
-		BUG_ON(!ret);
-		cpg->p.sg_src_left = cpg->p.src_sg_it.length;
-		cpg->p.src_start = 0;
-	}
+	void *sbuf;
+	int copied = 0;
 
-	cpg->p.crypt_len = min(cpg->p.sg_src_left, cpg->max_req_size);
+	while (1) {
+		if (!p->sg_src_left) {
+			ret = sg_miter_next(&p->src_sg_it);
+			BUG_ON(!ret);
+			p->sg_src_left = p->src_sg_it.length;
+			p->src_start = 0;
+		}
 
-	buf = cpg->p.src_sg_it.addr;
-	buf += cpg->p.src_start;
+		sbuf = p->src_sg_it.addr + p->src_start;
 
-	memcpy(cpg->sram + SRAM_DATA_IN_START, buf, cpg->p.crypt_len);
+		if (p->sg_src_left <= len - copied) {
+			memcpy(dbuf + copied, sbuf, p->sg_src_left);
+			copied += p->sg_src_left;
+			p->sg_src_left = 0;
+			if (copied >= len)
+				break;
+		} else {
+			int copy_len = len - copied;
+			memcpy(dbuf + copied, sbuf, copy_len);
+			p->src_start += copy_len;
+			p->sg_src_left -= copy_len;
+			break;
+		}
+	}
+}
 
-	cpg->p.sg_src_left -= cpg->p.crypt_len;
-	cpg->p.src_start += cpg->p.crypt_len;
+static void setup_data_in(struct ablkcipher_request *req)
+{
+	struct req_progress *p = &cpg->p;
+	p->crypt_len =
+	    min((int)req->nbytes - p->total_req_bytes, cpg->max_req_size);
+	copy_src_to_buf(p, cpg->sram + SRAM_DATA_IN_START,
+			p->crypt_len);
 }
 
 static void mv_process_current_q(int first_block)
@@ -289,12 +307,16 @@ static void dequeue_complete_req(void)
 static int count_sgs(struct scatterlist *sl, unsigned int total_bytes)
 {
 	int i = 0;
+	size_t cur_len;
 
-	do {
-		total_bytes -= sl[i].length;
-		i++;
