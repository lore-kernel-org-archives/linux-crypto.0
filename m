From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 30/35] crypto: ahash - Remove old_ahash_alg
Date: Wed, 15 Jul 2009 15:16:24 +0800
Message-ID: <E1MQyj2-000524-SB@gondolin.me.apana.org.au>
References: <20090715071424.GA19023@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:48345 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752935AbZGOHgd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 03:36:33 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MQyj4-0004vc-60
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2009 17:16:27 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: ahash - Remove old_ahash_alg

Now that all ahash implementations have been converted to the new
ahash type, we can remove old_ahash_alg and its associated support.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ahash.c                 |   27 ---------------------------
 crypto/shash.c                 |    2 --
 include/crypto/hash.h          |    3 +--
 include/crypto/internal/hash.h |    6 ------
 include/linux/crypto.h         |   16 ----------------
 5 files changed, 1 insertion(+), 53 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 7f599d2..cc824ef 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -175,46 +175,19 @@ static int ahash_nosetkey(struct crypto_ahash *tfm, const u8 *key,
 	return -ENOSYS;
 }
 
-static int crypto_init_ahash_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
-{
-	struct old_ahash_alg *alg = &tfm->__crt_alg->cra_ahash;
-	struct crypto_ahash *crt = __crypto_ahash_cast(tfm);
-	struct ahash_alg *nalg = crypto_ahash_alg(crt);
-
-	if (alg->digestsize > PAGE_SIZE / 8)
-		return -EINVAL;
-
-	crt->init = alg->init;
-	crt->update = alg->update;
-	crt->final  = alg->final;
-	crt->digest = alg->digest;
-	crt->setkey = alg->setkey ? ahash_setkey : ahash_nosetkey;
-	crt->digestsize = alg->digestsize;
-
-	nalg->setkey = alg->setkey;
-	nalg->halg.digestsize = alg->digestsize;
-
-	return 0;
-}
-
 static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_ahash *hash = __crypto_ahash_cast(tfm);
 	struct ahash_alg *alg = crypto_ahash_alg(hash);
-	struct old_ahash_alg *oalg = crypto_old_ahash_alg(hash);
 
 	if (tfm->__crt_alg->cra_type != &crypto_ahash_type)
 		return crypto_init_shash_ops_async(tfm);
 
-	if (oalg->init)
-		return crypto_init_ahash_ops(tfm, 0, 0);
-
 	hash->init = alg->init;
 	hash->update = alg->update;
 	hash->final  = alg->final;
 	hash->digest = alg->digest;
 	hash->setkey = alg->setkey ? ahash_setkey : ahash_nosetkey;
-	hash->digestsize = alg->halg.digestsize;
 
 	return 0;
 }
diff --git a/crypto/shash.c b/crypto/shash.c
index 615a5f4..fd92c03 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -270,7 +270,6 @@ static void crypto_exit_shash_ops_async(struct crypto_tfm *tfm)
 int crypto_init_shash_ops_async(struct crypto_tfm *tfm)
 {
 	struct crypto_alg *calg = tfm->__crt_alg;
-	struct shash_alg *alg = __crypto_shash_alg(calg);
 	struct crypto_ahash *crt = __crypto_ahash_cast(tfm);
 	struct crypto_shash **ctx = crypto_tfm_ctx(tfm);
 	struct crypto_shash *shash;
@@ -293,7 +292,6 @@ int crypto_init_shash_ops_async(struct crypto_tfm *tfm)
 	crt->digest = shash_async_digest;
 	crt->setkey = shash_async_setkey;
 
-	crt->digestsize = alg->digestsize;
 	crt->reqsize = sizeof(struct shash_desc) + crypto_shash_descsize(shash);
 
 	return 0;
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 262861d..45c2bdd 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -89,7 +89,6 @@ struct crypto_ahash {
 	int (*setkey)(struct crypto_ahash *tfm, const u8 *key,
 		      unsigned int keylen);
 
-	unsigned int digestsize;
 	unsigned int reqsize;
 	struct crypto_tfm base;
 };
@@ -137,7 +136,7 @@ static inline struct hash_alg_common *crypto_hash_alg_common(
 
 static inline unsigned int crypto_ahash_digestsize(struct crypto_ahash *tfm)
 {
-	return tfm->digestsize;
+	return crypto_hash_alg_common(tfm)->digestsize;
 }
 
 static inline unsigned int crypto_ahash_statesize(struct crypto_ahash *tfm)
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index e3a8251..179dd8f 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -109,12 +109,6 @@ static inline struct ahash_alg *__crypto_ahash_alg(struct crypto_alg *alg)
 			    halg);
 }
 
-static inline struct old_ahash_alg *crypto_old_ahash_alg(
-	struct crypto_ahash *tfm)
-{
-	return &crypto_ahash_tfm(tfm)->__crt_alg->cra_ahash;
-}
-
 static inline void crypto_ahash_set_reqsize(struct crypto_ahash *tfm,
 					    unsigned int reqsize)
 {
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 9e7e9b6..fd92988 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -115,12 +115,10 @@ struct crypto_async_request;
 struct crypto_aead;
 struct crypto_blkcipher;
 struct crypto_hash;
-struct crypto_ahash;
 struct crypto_rng;
 struct crypto_tfm;
 struct crypto_type;
 struct aead_givcrypt_request;
-struct ahash_request;
 struct skcipher_givcrypt_request;
 
 typedef void (*crypto_completion_t)(struct crypto_async_request *req, int err);
@@ -211,18 +209,6 @@ struct ablkcipher_alg {
 	unsigned int ivsize;
 };
 
-struct old_ahash_alg {
-	int (*init)(struct ahash_request *req);
-	int (*reinit)(struct ahash_request *req);
-	int (*update)(struct ahash_request *req);
-	int (*final)(struct ahash_request *req);
-	int (*digest)(struct ahash_request *req);
-	int (*setkey)(struct crypto_ahash *tfm, const u8 *key,
-			unsigned int keylen);
-
-	unsigned int digestsize;
-};
