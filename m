From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: shash - Remove superfluous check in init_tfm
Date: Wed, 14 Jan 2009 17:03:57 +1100
Message-ID: <20090114060357.GA15666@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:49106 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754606AbZANGD7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Jan 2009 01:03:59 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1LMyr8-00018N-4p
	for <linux-crypto@vger.kernel.org>; Wed, 14 Jan 2009 17:03:58 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 4.69)
	(envelope-from <herbert@gondor.apana.org.au>)
	id 1LMyr7-000451-CE
	for linux-crypto@vger.kernel.org; Wed, 14 Jan 2009 17:03:57 +1100
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

I'll added this to cryptodev-2.6.

commit 1f4cfc229e0e8c3b48cfada9aecfc72ff438fa61
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Wed Jan 14 13:34:48 2009 +1100

    crypto: shash - Remove superfluous check in init_tfm
    
    We're currently checking the frontend type in init_tfm.  This is
    completely pointless because the fact that we're called at all
    means that the frontend is ours so the type must match as well.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/shash.c b/crypto/shash.c
index c9df367..b96b6e5 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -437,8 +437,6 @@ static unsigned int crypto_shash_ctxsize(struct crypto_alg *alg, u32 type,
 static int crypto_shash_init_tfm(struct crypto_tfm *tfm,
 				 const struct crypto_type *frontend)
 {
-	if (frontend->type != CRYPTO_ALG_TYPE_SHASH)
-		return -EINVAL;
 	return 0;
 }
 
Cheres,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
