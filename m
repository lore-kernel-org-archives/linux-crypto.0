Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D0E7C77B73
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Apr 2023 10:05:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234367AbjDTKFz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Apr 2023 06:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234467AbjDTKFk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Apr 2023 06:05:40 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5271FC1
        for <linux-crypto@vger.kernel.org>; Thu, 20 Apr 2023 03:05:23 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1ppRAB-000YDz-RT; Thu, 20 Apr 2023 18:05:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 20 Apr 2023 18:05:16 +0800
Date:   Thu, 20 Apr 2023 18:05:16 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: hash - Add statesize to crypto_ahash
Message-ID: <ZEEOXIHwqKblKfBJ@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As ahash drivers may need to use fallbacks, their state size
is thus variable.  Deal with this by making it an attribute
of crypto_ahash.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ahash.c                 |    3 +++
 include/crypto/hash.h          |    3 ++-
 include/crypto/internal/hash.h |    6 ++++++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index b9e34797175b..ad21101107bd 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -432,6 +432,8 @@ static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
 
 	hash->setkey = ahash_nosetkey;
 
+	crypto_ahash_set_statesize(hash, alg->halg.statesize);
+
 	if (tfm->__crt_alg->cra_type != &crypto_ahash_type)
 		return crypto_init_shash_ops_async(tfm);
 
@@ -563,6 +565,7 @@ struct crypto_ahash *crypto_clone_ahash(struct crypto_ahash *hash)
 	nhash->import = hash->import;
 	nhash->setkey = hash->setkey;
 	nhash->reqsize = hash->reqsize;
+	nhash->statesize = hash->statesize;
 
 	if (tfm->__crt_alg->cra_type != &crypto_ahash_type)
 		return crypto_clone_shash_ops_async(nhash, hash);
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index a641c63ab954..fa0702a71f43 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -260,6 +260,7 @@ struct crypto_ahash {
 	int (*setkey)(struct crypto_ahash *tfm, const u8 *key,
 		      unsigned int keylen);
 
+	unsigned int statesize;
 	unsigned int reqsize;
 	struct crypto_tfm base;
 };
@@ -400,7 +401,7 @@ static inline unsigned int crypto_ahash_digestsize(struct crypto_ahash *tfm)
  */
 static inline unsigned int crypto_ahash_statesize(struct crypto_ahash *tfm)
 {
-	return crypto_hash_alg_common(tfm)->statesize;
+	return tfm->statesize;
 }
 
 static inline u32 crypto_ahash_get_flags(struct crypto_ahash *tfm)
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 37edf3f4e8af..b925f82206ef 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -149,6 +149,12 @@ static inline struct ahash_alg *__crypto_ahash_alg(struct crypto_alg *alg)
 			    halg);
 }
 
+static inline void crypto_ahash_set_statesize(struct crypto_ahash *tfm,
+					      unsigned int size)
+{
+	tfm->statesize = size;
+}
+
 static inline void crypto_ahash_set_reqsize(struct crypto_ahash *tfm,
 					    unsigned int reqsize)
 {
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
