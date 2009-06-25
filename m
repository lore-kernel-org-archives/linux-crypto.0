From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: skcipher - Fix request for sync algorithms
Date: Thu, 25 Jun 2009 14:48:35 +0800
Message-ID: <20090625064835.GA31834@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:54037 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751273AbZFYGse (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Jun 2009 02:48:34 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MJilA-0003nv-8s
	for <linux-crypto@vger.kernel.org>; Thu, 25 Jun 2009 16:48:36 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 4.69)
	(envelope-from <herbert@gondor.apana.org.au>)
	id 1MJil9-0008Hj-K3
	for linux-crypto@vger.kernel.org; Thu, 25 Jun 2009 14:48:35 +0800
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

Found this while playing with pcrypt.

commit 435578aeaad5859dda8657e3ed2c1a5bc1e524ec
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu Jun 25 14:46:31 2009 +0800

    crypto: skcipher - Fix request for sync algorithms
    
    When a sync givcipher algorithm is requested, if an async version
    of the same algorithm already exists, then we will loop forever
    without ever constructing the sync version based on a blkcipher.
    
    This is because we did not include the requested type/mask when
    getting a larval for the geniv algorithm that is to be constructed.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index e11ce37..43fc8fb 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -201,8 +201,9 @@ static int crypto_givcipher_default(struct crypto_alg *alg, u32 type, u32 mask)
 	int err;
 
 	larval = crypto_larval_lookup(alg->cra_driver_name,
+				      (type & ~CRYPTO_ALG_TYPE_MASK) |
 				      CRYPTO_ALG_TYPE_GIVCIPHER,
-				      CRYPTO_ALG_TYPE_MASK);
+				      mask | CRYPTO_ALG_TYPE_MASK);
 	err = PTR_ERR(larval);
 	if (IS_ERR(larval))
 		goto out;

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
