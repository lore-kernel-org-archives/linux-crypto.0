From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: tcrypt - Fixed AEAD speed test setup
Date: Wed, 17 Jun 2015 14:05:26 +0800
Message-ID: <20150617060526.GB9227@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41763 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbbFQGF2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Jun 2015 02:05:28 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The AEAD speed test SG list setup did not correctly mark the AD,
potentially causing a crash.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/tcrypt.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 5146367..9f6f10b 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -258,12 +258,12 @@ static void sg_init_aead(struct scatterlist *sg, char *xbuf[XBUFSIZE],
 		rem = buflen % PAGE_SIZE;
 	}
 
-	sg_init_table(sg, np);
+	sg_init_table(sg, np + 1);
 	np--;
 	for (k = 0; k < np; k++)
-		sg_set_buf(&sg[k], xbuf[k], PAGE_SIZE);
+		sg_set_buf(&sg[k + 1], xbuf[k], PAGE_SIZE);
 
-	sg_set_buf(&sg[k], xbuf[k], rem);
+	sg_set_buf(&sg[k + 1], xbuf[k], rem);
 }
 
 static void test_aead_speed(const char *algo, int enc, unsigned int secs,
@@ -337,8 +337,6 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 		do {
 			assoc = axbuf[0];
 			memset(assoc, 0xff, aad_size);
-			sg_set_buf(&sg[0], assoc, aad_size);
-			sg_set_buf(&sgout[0], assoc, aad_size);
 
 			if ((*keysize + *b_size) > TVMEMSIZE * PAGE_SIZE) {
 				pr_err("template (%u) too big for tvmem (%lu)\n",
@@ -374,12 +372,15 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 				goto out;
 			}
 
-			sg_init_aead(&sg[1], xbuf,
+			sg_init_aead(sg, xbuf,
 				    *b_size + (enc ? authsize : 0));
 
-			sg_init_aead(&sgout[1], xoutbuf,
+			sg_init_aead(sgout, xoutbuf,
 				    *b_size + (enc ? authsize : 0));
 
+			sg_set_buf(&sg[0], assoc, aad_size);
+			sg_set_buf(&sgout[0], assoc, aad_size);
+
 			aead_request_set_crypt(req, sg, sgout, *b_size, iv);
 			aead_request_set_ad(req, aad_size);
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
