From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v4 PATCH 5/8] crypto: rsa-pkcs1pad - Remove bogus page splitting
Date: Wed, 29 Jun 2016 19:32:24 +0800
Message-ID: <E1bIDjE-0007Dc-TR@gondolin.me.apana.org.au>
References: <20160629113125.GA27643@gondor.apana.org.au>
To: Andrzej Zaborowski <andrew.zaborowski@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	Stephan Mueller <smueller@chronox.de>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	Denis Kenzior <denkenz@gmail.com>,
	Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56932 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbcF2Lc2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2016 07:32:28 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The helper pkcs1pad_sg_set_buf tries to split a buffer that crosses
a page boundary into two SG entries.  This is unnecessary.  This
patch removes that.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/rsa-pkcs1pad.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 5c1c78e..d9baefb 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -103,7 +103,7 @@ struct pkcs1pad_inst_ctx {
 struct pkcs1pad_request {
 	struct akcipher_request child_req;
 
-	struct scatterlist in_sg[3], out_sg[2];
+	struct scatterlist in_sg[2], out_sg[1];
 	uint8_t *in_buf, *out_buf;
 };
 
@@ -163,19 +163,10 @@ static int pkcs1pad_get_max_size(struct crypto_akcipher *tfm)
 static void pkcs1pad_sg_set_buf(struct scatterlist *sg, void *buf, size_t len,
 		struct scatterlist *next)
 {
-	int nsegs = next ? 1 : 0;
-
-	if (offset_in_page(buf) + len <= PAGE_SIZE) {
-		nsegs += 1;
-		sg_init_table(sg, nsegs);
-		sg_set_buf(sg, buf, len);
-	} else {
-		nsegs += 2;
-		sg_init_table(sg, nsegs);
-		sg_set_buf(sg + 0, buf, PAGE_SIZE - offset_in_page(buf));
-		sg_set_buf(sg + 1, buf + PAGE_SIZE - offset_in_page(buf),
-				offset_in_page(buf) + len - PAGE_SIZE);
-	}
+	int nsegs = next ? 2 : 1;
+
+	sg_init_table(sg, nsegs);
+	sg_set_buf(sg, buf, len);
 
 	if (next)
 		sg_chain(sg, nsegs, next);
