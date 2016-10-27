From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: [PATCH stable 3.10.y 05/18] crypto: hash - Add crypto_ahash_has_setkey
Date: Thu, 27 Oct 2016 17:29:38 +0300
Message-ID: <1477578591-28924-6-git-send-email-aryabinin@virtuozzo.com>
References: <1477578591-28924-1-git-send-email-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>
To: Willy Tarreau <w@1wt.eu>, <stable@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ve1eur01on0105.outbound.protection.outlook.com ([104.47.1.105]:13440
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S936503AbcJ0SEA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Oct 2016 14:04:00 -0400
In-Reply-To: <1477578591-28924-1-git-send-email-aryabinin@virtuozzo.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Herbert Xu <herbert@gondor.apana.org.au>

commit a5596d6332787fd383b3b5427b41f94254430827 upstream.

This patch adds a way for ahash users to determine whether a key
is required by a crypto_ahash transform.

Cc: stable@vger.kernel.org
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
---
 crypto/ahash.c        | 5 ++++-
 crypto/shash.c        | 4 +++-
 include/crypto/hash.h | 6 ++++++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index bcd5efc..781a8a7 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -370,6 +370,7 @@ static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
 	struct ahash_alg *alg = crypto_ahash_alg(hash);
 
 	hash->setkey = ahash_nosetkey;
+	hash->has_setkey = false;
 	hash->export = ahash_no_export;
 	hash->import = ahash_no_import;
 
@@ -382,8 +383,10 @@ static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
 	hash->finup = alg->finup ?: ahash_def_finup;
 	hash->digest = alg->digest;
 
-	if (alg->setkey)
+	if (alg->setkey) {
 		hash->setkey = alg->setkey;
+		hash->has_setkey = true;
+	}
 	if (alg->export)
 		hash->export = alg->export;
 	if (alg->import)
diff --git a/crypto/shash.c b/crypto/shash.c
index 929058a..8e4256a 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -354,8 +354,10 @@ int crypto_init_shash_ops_async(struct crypto_tfm *tfm)
 	crt->finup = shash_async_finup;
 	crt->digest = shash_async_digest;
 
-	if (alg->setkey)
+	if (alg->setkey) {
 		crt->setkey = shash_async_setkey;
+		crt->has_setkey = true;
+	}
 	if (alg->export)
 		crt->export = shash_async_export;
 	if (alg->import)
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 26cb1eb..c8c7987 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -94,6 +94,7 @@ struct crypto_ahash {
 		      unsigned int keylen);
 
 	unsigned int reqsize;
+	bool has_setkey;
 	struct crypto_tfm base;
 };
 
@@ -181,6 +182,11 @@ static inline void *ahash_request_ctx(struct ahash_request *req)
 
 int crypto_ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
 			unsigned int keylen);
+static inline bool crypto_ahash_has_setkey(struct crypto_ahash *tfm)
+{
+	return tfm->has_setkey;
+}
+
 int crypto_ahash_finup(struct ahash_request *req);
 int crypto_ahash_final(struct ahash_request *req);
 int crypto_ahash_digest(struct ahash_request *req);
-- 
2.7.3
