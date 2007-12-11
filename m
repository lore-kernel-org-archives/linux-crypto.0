From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 8/19] [CRYPTO] skcipher: Remove crypto_spawn_ablkcipher
Date: Tue, 11 Dec 2007 12:02:59 +0800
Message-ID: <E1J1wKh-0002k5-00@gondolin.me.apana.org.au>
References: <20071211040215.GA10360@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1919 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751663AbXLKEDG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Dec 2007 23:03:06 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J1wKj-00062U-Aj
	for <linux-crypto@vger.kernel.org>; Tue, 11 Dec 2007 15:03:01 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] skcipher: Remove crypto_spawn_ablkcipher

Now that gcm and authenc have been converted to crypto_spawn_skcipher,
this patch removes the obsolete crypto_spawn_ablkcipher function.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/crypto/algapi.h |    8 --------
 1 files changed, 8 deletions(-)

diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index f1c9b61..e4e3792 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -198,14 +198,6 @@ static inline struct crypto_instance *crypto_aead_alg_instance(
 	return crypto_tfm_alg_instance(&aead->base);
 }
 
-static inline struct crypto_ablkcipher *crypto_spawn_ablkcipher(
-	struct crypto_spawn *spawn)
-{
-	return __crypto_ablkcipher_cast(
-		crypto_spawn_tfm(spawn, crypto_skcipher_type(0),
-				 crypto_skcipher_mask(0)));
-}
-
 static inline struct crypto_blkcipher *crypto_spawn_blkcipher(
 	struct crypto_spawn *spawn)
 {
