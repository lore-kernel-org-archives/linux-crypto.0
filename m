From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: ahash - Fix setkey crash
Date: Wed, 15 Jul 2009 20:42:52 +0800
Message-ID: <20090715124252.GA22403@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:52511 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752089AbZGONQu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 09:16:50 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MR4Lo-0000i7-VI
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2009 23:16:49 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 4.69)
	(envelope-from <herbert@gondor.apana.org.au>)
	id 1MR4Lo-0005vm-PJ
	for linux-crypto@vger.kernel.org; Wed, 15 Jul 2009 21:16:48 +0800
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

This patch fixes a crash caused by the new ahash code and hmac.

commit a70c522520d967844c01fa01459edc698fc54544
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Wed Jul 15 20:39:05 2009 +0800

    crypto: ahash - Fix setkey crash
    
    When the alignment check was made unconditional for ahash we
    may end up crashing on shash algorithms because we're always
    calling alg->setkey instead of tfm->setkey.
    
    This patch fixes it.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/ahash.c b/crypto/ahash.c
index ac0798d..28a33d0 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -145,7 +145,6 @@ int crypto_hash_walk_first_compat(struct hash_desc *hdesc,
 static int ahash_setkey_unaligned(struct crypto_ahash *tfm, const u8 *key,
 				unsigned int keylen)
 {
-	struct ahash_alg *ahash = crypto_ahash_alg(tfm);
 	unsigned long alignmask = crypto_ahash_alignmask(tfm);
 	int ret;
 	u8 *buffer, *alignbuffer;
@@ -158,7 +157,7 @@ static int ahash_setkey_unaligned(struct crypto_ahash *tfm, const u8 *key,
 
 	alignbuffer = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
 	memcpy(alignbuffer, key, keylen);
-	ret = ahash->setkey(tfm, alignbuffer, keylen);
+	ret = tfm->setkey(tfm, alignbuffer, keylen);
 	kzfree(buffer);
 	return ret;
 }
@@ -166,13 +165,12 @@ static int ahash_setkey_unaligned(struct crypto_ahash *tfm, const u8 *key,
 int crypto_ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
 			unsigned int keylen)
 {
-	struct ahash_alg *ahash = crypto_ahash_alg(tfm);
 	unsigned long alignmask = crypto_ahash_alignmask(tfm);
 
 	if ((unsigned long)key & alignmask)
 		return ahash_setkey_unaligned(tfm, key, keylen);
 
-	return ahash->setkey(tfm, key, keylen);
+	return tfm->setkey(tfm, key, keylen);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_setkey);

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
