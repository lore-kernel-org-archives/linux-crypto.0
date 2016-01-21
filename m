From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: skcipher - Add default key size helper
Date: Thu, 21 Jan 2016 17:10:56 +0800
Message-ID: <20160121091056.GA6123@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56375 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbcAUJLA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Jan 2016 04:11:00 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

While converting ecryptfs over to skcipher I found that it needs
to pick a default key size if one isn't given.  Rather than having
it poke into the guts of the algorithm to get max_keysize, let's
provide a helper that is meant to give a sane default (just in
case we ever get an algorithm that has no maximum key size).

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index d199c0b..69230e9 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -118,7 +118,7 @@ static int crypto_init_skcipher_ops_blkcipher(struct crypto_tfm *tfm)
 	skcipher->decrypt = skcipher_decrypt_blkcipher;
 
 	skcipher->ivsize = crypto_blkcipher_ivsize(blkcipher);
-	skcipher->has_setkey = calg->cra_blkcipher.max_keysize;
+	skcipher->keysize = calg->cra_blkcipher.max_keysize;
 
 	return 0;
 }
@@ -211,7 +211,7 @@ static int crypto_init_skcipher_ops_ablkcipher(struct crypto_tfm *tfm)
 	skcipher->ivsize = crypto_ablkcipher_ivsize(ablkcipher);
 	skcipher->reqsize = crypto_ablkcipher_reqsize(ablkcipher) +
 			    sizeof(struct ablkcipher_request);
-	skcipher->has_setkey = calg->cra_ablkcipher.max_keysize;
+	skcipher->keysize = calg->cra_ablkcipher.max_keysize;
 
 	return 0;
 }
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index fd8742a..2f07b4f 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -60,8 +60,7 @@ struct crypto_skcipher {
 
 	unsigned int ivsize;
 	unsigned int reqsize;
-
-	bool has_setkey;
+	unsigned int keysize;
 
 	struct crypto_tfm base;
 };
@@ -309,7 +308,13 @@ static inline int crypto_skcipher_setkey(struct crypto_skcipher *tfm,
 
 static inline bool crypto_skcipher_has_setkey(struct crypto_skcipher *tfm)
 {
-	return tfm->has_setkey;
+	return tfm->keysize;
+}
+
+static inline unsigned int crypto_skcipher_default_keysize(
+	struct crypto_skcipher *tfm)
+{
+	return tfm->keysize;
 }
 
 /**
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
