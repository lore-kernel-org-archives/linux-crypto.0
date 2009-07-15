From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: shash - Fix digest size offset
Date: Wed, 15 Jul 2009 21:18:00 +0800
Message-ID: <20090715131800.GA22807@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:47436 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753922AbZGONSB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 09:18:01 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MR4My-0000jX-IP
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2009 23:18:00 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 4.69)
	(envelope-from <herbert@gondor.apana.org.au>)
	id 1MR4My-0005wM-9k
	for linux-crypto@vger.kernel.org; Wed, 15 Jul 2009 21:18:00 +0800
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

This one fixes failures when using shash algorithms through
ahash.

commit fa64966473830219fe74952029ddb0e981a87749
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Wed Jul 15 21:16:05 2009 +0800

    crypto: shash - Fix digest size offset
    
    When an shash algorithm is exported as ahash, ahash will access
    its digest size through hash_alg_common.  That's why the shash
    layout needs to match hash_alg_common.  This wasn't the case
    because the alignment weren't identical.
    
    This patch fixes the problem.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 3e89ce1..26cb1eb 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -75,7 +75,8 @@ struct shash_alg {
 	unsigned int descsize;
 
 	/* These fields must match hash_alg_common. */
-	unsigned int digestsize;
+	unsigned int digestsize
+		__attribute__ ((aligned(__alignof__(struct hash_alg_common))));
 	unsigned int statesize;
 
 	struct crypto_alg base;

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
