From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: tcrypt - Allow speed testing of arbitrary hash functions
Date: Thu, 4 Dec 2014 16:43:29 +0800
Message-ID: <20141204084329.GA19494@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:57056 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045AbaLDInd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Dec 2014 03:43:33 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch allows the testing of arbitrary hash functions specified
by the alg module parameter by using them in mode 300 (for sync hash)
and mode 400 (for async hash).
    
For example, you could do
	modprobe tcrypt mode=300 alg='vmac(aes)'
    
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 890449e..1d864e9 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1225,15 +1225,22 @@ static inline int tcrypt_test(const char *alg)
 	return ret;
 }
 
-static int do_test(int m)
+static int do_test(const char *alg, u32 type, u32 mask, int m)
 {
 	int i;
 	int ret = 0;
 
 	switch (m) {
 	case 0:
+		if (alg) {
+			if (!crypto_has_alg(alg, type,
+					    mask ?: CRYPTO_ALG_TYPE_MASK))
+				ret = -ENOENT;
+			break;
+		}
+
 		for (i = 1; i < 200; i++)
-			ret += do_test(i);
+			ret += do_test(NULL, 0, 0, i);
 		break;
 
 	case 1:
@@ -1752,6 +1759,11 @@ static int do_test(int m)
 		break;
 
 	case 300:
+		if (alg) {
+			test_hash_speed(alg, sec, generic_hash_speed_template);
+			break;
+		}
+
 		/* fall through */
 
 	case 301:
@@ -1838,6 +1850,11 @@ static int do_test(int m)
 		break;
 
 	case 400:
+		if (alg) {
+			test_ahash_speed(alg, sec, generic_hash_speed_template);
+			break;
+		}
+
 		/* fall through */
 
 	case 401:
@@ -2127,12 +2144,6 @@ static int do_test(int m)
 	return ret;
 }
 
-static int do_alg_test(const char *alg, u32 type, u32 mask)
-{
-	return crypto_has_alg(alg, type, mask ?: CRYPTO_ALG_TYPE_MASK) ?
-	       0 : -ENOENT;
-}
-
 static int __init tcrypt_mod_init(void)
 {
 	int err = -ENOMEM;
@@ -2144,10 +2155,7 @@ static int __init tcrypt_mod_init(void)
 			goto err_free_tv;
 	}
 
-	if (alg)
-		err = do_alg_test(alg, type, mask);
-	else
-		err = do_test(mode);
+	err = do_test(alg, type, mask, mode);
 
 	if (err) {
 		printk(KERN_ERR "tcrypt: one or more tests failed!\n");

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
