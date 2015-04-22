From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: drbg - Remove FIPS ifdef from drbg_healthcheck_sanity
Date: Wed, 22 Apr 2015 11:42:35 +0800
Message-ID: <20150422034235.GA6907@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Stephan Mueller <smueller@chronox.de>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55809 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbbDVDml (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Apr 2015 23:42:41 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch removes the unnecessary CRYPTO_FIPS ifdef from
drbg_healthcheck_sanity so that the code always gets checked
by the compiler.
    
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/drbg.c b/crypto/drbg.c
index ec6bffd..23d444e 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1707,7 +1707,6 @@ static int drbg_kcapi_seed(struct crypto_rng *tfm,
  */
 static inline int __init drbg_healthcheck_sanity(void)
 {
-#ifdef CONFIG_CRYPTO_FIPS
 	int len = 0;
 #define OUTBUFLEN 16
 	unsigned char buf[OUTBUFLEN];
@@ -1775,9 +1774,6 @@ static inline int __init drbg_healthcheck_sanity(void)
 outbuf:
 	kzfree(drbg);
 	return rc;
-#else /* CONFIG_CRYPTO_FIPS */
-	return 0;
-#endif /* CONFIG_CRYPTO_FIPS */
 }
 
 static struct rng_alg drbg_algs[22];
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
