From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: tcrypt - Handle async return from crypto_ahash_init
Date: Wed, 22 Apr 2015 11:02:27 +0800
Message-ID: <20150422030227.GA6646@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51972 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbbDVDCa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Apr 2015 23:02:30 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The function crypto_ahash_init can also be asynchronous just
like update and final.  So all callers must be able to handle
an async return.
    
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 1a28001..bf41c34 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -808,7 +808,7 @@ static int test_ahash_jiffies(struct ahash_request *req, int blen,
 
 	for (start = jiffies, end = start + secs * HZ, bcount = 0;
 	     time_before(jiffies, end); bcount++) {
-		ret = crypto_ahash_init(req);
+		ret = do_one_ahash_op(req, crypto_ahash_init(req));
 		if (ret)
 			return ret;
 		for (pcount = 0; pcount < blen; pcount += plen) {
@@ -877,7 +877,7 @@ static int test_ahash_cycles(struct ahash_request *req, int blen,
 
 	/* Warm-up run. */
 	for (i = 0; i < 4; i++) {
-		ret = crypto_ahash_init(req);
+		ret = do_one_ahash_op(req, crypto_ahash_init(req));
 		if (ret)
 			goto out;
 		for (pcount = 0; pcount < blen; pcount += plen) {
@@ -896,7 +896,7 @@ static int test_ahash_cycles(struct ahash_request *req, int blen,
 
 		start = get_cycles();
 
-		ret = crypto_ahash_init(req);
+		ret = do_one_ahash_op(req, crypto_ahash_init(req));
 		if (ret)
 			goto out;
 		for (pcount = 0; pcount < blen; pcount += plen) {
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
