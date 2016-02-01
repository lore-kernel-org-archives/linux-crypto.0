From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/6] crypto: doc - Use ahash
Date: Mon, 01 Feb 2016 21:36:50 +0800
Message-ID: <E1aQEew-0002op-Fh@gondolin.me.apana.org.au>
References: <20160201133405.GA10754@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47696 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320AbcBANgw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Feb 2016 08:36:52 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1aQEew-0002IL-KO
	for <linux-crypto@vger.kernel.org>; Tue, 02 Feb 2016 00:36:50 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch replaces the crypto_hash example in api-intro.txt with
crypto_ahash.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 Documentation/crypto/api-intro.txt |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/Documentation/crypto/api-intro.txt b/Documentation/crypto/api-intro.txt
index 8b49302..beda682 100644
--- a/Documentation/crypto/api-intro.txt
+++ b/Documentation/crypto/api-intro.txt
@@ -49,28 +49,33 @@ under development.
 
 Here's an example of how to use the API:
 
-	#include <linux/crypto.h>
+	#include <crypto/ahash.h>
 	#include <linux/err.h>
 	#include <linux/scatterlist.h>
 	
 	struct scatterlist sg[2];
 	char result[128];
-	struct crypto_hash *tfm;
-	struct hash_desc desc;
+	struct crypto_ahash *tfm;
+	struct ahash_request *req;
 	
-	tfm = crypto_alloc_hash("md5", 0, CRYPTO_ALG_ASYNC);
+	tfm = crypto_alloc_ahash("md5", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(tfm))
 		fail();
 		
 	/* ... set up the scatterlists ... */
 
-	desc.tfm = tfm;
-	desc.flags = 0;
-	
-	if (crypto_hash_digest(&desc, sg, 2, result))
+	req = ahash_request_alloc(tfm, GFP_ATOMIC);
+	if (!req)
 		fail();
+
+	ahash_request_set_callback(req, 0, NULL, NULL);
+	ahash_request_set_crypt(req, sg, result, 2);
 	
-	crypto_free_hash(tfm);
+	if (crypto_ahash_digest(req))
+		fail();
+
+	ahash_request_free(req);
+	crypto_free_ahash(tfm);
 
     
 Many real examples are available in the regression test module (tcrypt.c).
