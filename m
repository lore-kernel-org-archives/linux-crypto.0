From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: aead - Fix corner case in crypto_lookup_aead
Date: Thu, 23 Apr 2015 16:37:46 +0800
Message-ID: <20150423083746.GA20206@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37301 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756098AbbDWIhs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Apr 2015 04:37:48 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When the user explicitly states that they don't care whether the
algorithm has been tested (type = CRYPTO_ALG_TESTED and mask = 0),
there is a corner case where we may erroneously return ENOENT.
    
This patch fixes it by correcting the logic in the test.
    
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/aead.c b/crypto/aead.c
index 2222710..d6ad0c6 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -489,7 +489,7 @@ struct crypto_alg *crypto_lookup_aead(const char *name, u32 type, u32 mask)
 		return alg;
 
 	if (alg->cra_type == &crypto_aead_type) {
-		if ((alg->cra_flags ^ type ^ ~mask) & CRYPTO_ALG_TESTED) {
+		if (~alg->cra_flags & (type ^ ~mask) & CRYPTO_ALG_TESTED) {
 			crypto_mod_put(alg);
 			alg = ERR_PTR(-ENOENT);
 		}
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
