Return-Path: <SRS0=b7+G=PP=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726425AbfAGCtk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 6 Jan 2019 21:49:40 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/3] crypto: hash - set CRYPTO_TFM_NEED_KEY if ->setkey() fails
Date: Sun,  6 Jan 2019 18:47:42 -0800
Message-Id: <20190107024744.4952-2-ebiggers@kernel.org>
In-Reply-To: <20190107024744.4952-1-ebiggers@kernel.org>
References: <20190107024744.4952-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Some algorithms have a ->setkey() method that is not atomic, in the
sense that setting a key can fail after changes were already made to the
tfm context.  In this case, if a key was already set the tfm can end up
in a state that corresponds to neither the old key nor the new key.

It's not feasible to make all ->setkey() methods atomic, especially ones
that have to key multiple sub-tfms.  Therefore, make the crypto API set
CRYPTO_TFM_NEED_KEY if ->setkey() fails and the algorithm requires a
key, to prevent the tfm from being used until a new key is set.

Note: we can't set CRYPTO_TFM_NEED_KEY for OPTIONAL_KEY algorithms, so
->setkey() for those must nevertheless be atomic.  That's fine for now
since only the crc32 and crc32c algorithms set OPTIONAL_KEY, and it's
not intended that OPTIONAL_KEY be used much.

[Cc stable mainly because when introducing the NEED_KEY flag I changed
 AF_ALG to rely on it; and unlike in-kernel crypto API users, AF_ALG
 previously didn't have this problem.  So these "incompletely keyed"
 states became theoretically accessible via AF_ALG -- though, the
 opportunities for causing real mischief seem pretty limited.]

Fixes: 9fa68f620041 ("crypto: hash - prevent using keyed hashes without setting key")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/ahash.c | 28 +++++++++++++++++++---------
 crypto/shash.c | 18 +++++++++++++-----
 2 files changed, 32 insertions(+), 14 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 5d320a811f750..ca0d3e281fefb 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -190,6 +190,21 @@ static int ahash_setkey_unaligned(struct crypto_ahash *tfm, const u8 *key,
 	return ret;
 }
 
+static int ahash_nosetkey(struct crypto_ahash *tfm, const u8 *key,
+			  unsigned int keylen)
+{
+	return -ENOSYS;
+}
+
+static void ahash_set_needkey(struct crypto_ahash *tfm)
+{
+	const struct hash_alg_common *alg = crypto_hash_alg_common(tfm);
+
+	if (tfm->setkey != ahash_nosetkey &&
+	    !(alg->base.cra_flags & CRYPTO_ALG_OPTIONAL_KEY))
+		crypto_ahash_set_flags(tfm, CRYPTO_TFM_NEED_KEY);
+}
+
 int crypto_ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
 			unsigned int keylen)
 {
@@ -201,20 +216,16 @@ int crypto_ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
 	else
 		err = tfm->setkey(tfm, key, keylen);
 
-	if (err)
+	if (unlikely(err)) {
+		ahash_set_needkey(tfm);
 		return err;
+	}
 
 	crypto_ahash_clear_flags(tfm, CRYPTO_TFM_NEED_KEY);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_setkey);
 
-static int ahash_nosetkey(struct crypto_ahash *tfm, const u8 *key,
-			  unsigned int keylen)
-{
-	return -ENOSYS;
-}
-
 static inline unsigned int ahash_align_buffer_size(unsigned len,
 						   unsigned long mask)
 {
@@ -489,8 +500,7 @@ static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
 
 	if (alg->setkey) {
 		hash->setkey = alg->setkey;
-		if (!(alg->halg.base.cra_flags & CRYPTO_ALG_OPTIONAL_KEY))
-			crypto_ahash_set_flags(hash, CRYPTO_TFM_NEED_KEY);
+		ahash_set_needkey(hash);
 	}
 
 	return 0;
diff --git a/crypto/shash.c b/crypto/shash.c
index 44d297b82a8fb..40311ccad3fae 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -53,6 +53,13 @@ static int shash_setkey_unaligned(struct crypto_shash *tfm, const u8 *key,
 	return err;
 }
 
+static void shash_set_needkey(struct crypto_shash *tfm, struct shash_alg *alg)
+{
+	if (crypto_shash_alg_has_setkey(alg) &&
+	    !(alg->base.cra_flags & CRYPTO_ALG_OPTIONAL_KEY))
+		crypto_shash_set_flags(tfm, CRYPTO_TFM_NEED_KEY);
+}
+
 int crypto_shash_setkey(struct crypto_shash *tfm, const u8 *key,
 			unsigned int keylen)
 {
@@ -65,8 +72,10 @@ int crypto_shash_setkey(struct crypto_shash *tfm, const u8 *key,
 	else
 		err = shash->setkey(tfm, key, keylen);
 
-	if (err)
+	if (unlikely(err)) {
+		shash_set_needkey(tfm, shash);
 		return err;
+	}
 
 	crypto_shash_clear_flags(tfm, CRYPTO_TFM_NEED_KEY);
 	return 0;
@@ -373,7 +382,8 @@ int crypto_init_shash_ops_async(struct crypto_tfm *tfm)
 	crt->final = shash_async_final;
 	crt->finup = shash_async_finup;
 	crt->digest = shash_async_digest;
-	crt->setkey = shash_async_setkey;
+	if (crypto_shash_alg_has_setkey(alg))
+		crt->setkey = shash_async_setkey;
 
 	crypto_ahash_set_flags(crt, crypto_shash_get_flags(shash) &
 				    CRYPTO_TFM_NEED_KEY);
@@ -395,9 +405,7 @@ static int crypto_shash_init_tfm(struct crypto_tfm *tfm)
 
 	hash->descsize = alg->descsize;
 
-	if (crypto_shash_alg_has_setkey(alg) &&
-	    !(alg->base.cra_flags & CRYPTO_ALG_OPTIONAL_KEY))
-		crypto_shash_set_flags(hash, CRYPTO_TFM_NEED_KEY);
+	shash_set_needkey(hash, alg);
 
 	return 0;
 }
-- 
2.20.1
