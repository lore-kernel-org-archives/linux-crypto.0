From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/13] crypto: algboss - Remove reference to nivaead
Date: Thu, 13 Aug 2015 17:28:49 +0800
Message-ID: <E1ZPoob-0005oV-J5@gondolin.me.apana.org.au>
References: <20150813092520.GA22268@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49045 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbbHMJ2w (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Aug 2015 05:28:52 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1ZPoob-00035N-UM
	for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2015 19:28:50 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch removes a legacy reference to nivaead which is no longer
used.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/algboss.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/crypto/algboss.c b/crypto/algboss.c
index 76fc0b2..6e39d9c 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -248,13 +248,11 @@ static int cryptomgr_schedule_test(struct crypto_alg *alg)
 	type = alg->cra_flags;
 
 	/* This piece of crap needs to disappear into per-type test hooks. */
-	if ((!((type ^ CRYPTO_ALG_TYPE_BLKCIPHER) &
-	       CRYPTO_ALG_TYPE_BLKCIPHER_MASK) && !(type & CRYPTO_ALG_GENIV) &&
-	     ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
-	      CRYPTO_ALG_TYPE_BLKCIPHER ? alg->cra_blkcipher.ivsize :
-					  alg->cra_ablkcipher.ivsize)) ||
-	    (!((type ^ CRYPTO_ALG_TYPE_AEAD) & CRYPTO_ALG_TYPE_MASK) &&
-	     alg->cra_type == &crypto_nivaead_type && alg->cra_aead.ivsize))
+	if (!((type ^ CRYPTO_ALG_TYPE_BLKCIPHER) &
+	      CRYPTO_ALG_TYPE_BLKCIPHER_MASK) && !(type & CRYPTO_ALG_GENIV) &&
+	    ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
+	     CRYPTO_ALG_TYPE_BLKCIPHER ? alg->cra_blkcipher.ivsize :
+					 alg->cra_ablkcipher.ivsize))
 		type |= CRYPTO_ALG_TESTED;
 
 	param->type = type;
