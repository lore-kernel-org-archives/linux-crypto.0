From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: skcipher - Fix corner case in crypto_lookup_skcipher
Date: Thu, 23 Apr 2015 16:34:47 +0800
Message-ID: <20150423083447.GA20123@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55382 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756872AbbDWIev (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Apr 2015 04:34:51 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When the user explicitly states that they don't care whether the
algorithm has been tested (type = CRYPTO_ALG_TESTED and mask = 0),
there is a corner case where we may erroneously return ENOENT.
    
This patch fixes it by correcting the logic in the test.
    
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index db201bca..b3dded4 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -636,7 +636,7 @@ struct crypto_alg *crypto_lookup_skcipher(const char *name, u32 type, u32 mask)
 
 	if ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
 	    CRYPTO_ALG_TYPE_GIVCIPHER) {
-		if ((alg->cra_flags ^ type ^ ~mask) & CRYPTO_ALG_TESTED) {
+		if (~alg->cra_flags & (type ^ ~mask) & CRYPTO_ALG_TESTED) {
 			crypto_mod_put(alg);
 			alg = ERR_PTR(-ENOENT);
 		}
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
