From: Huang Ying <ying.huang@intel.com>
Subject: [RFC 3/7] crypto: Add crypto_spawn_shash
Date: Thu, 11 Jun 2009 15:10:30 +0800
Message-ID: <1244704230.5320.126.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:23482 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757507AbZFKHKb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Jun 2009 03:10:31 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Needed to use shash in cryptd hash.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 crypto/shash.c          |    6 ++++++
 include/crypto/algapi.h |    8 ++++++++
 2 files changed, 14 insertions(+)

--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -240,6 +240,14 @@ static inline struct cipher_alg *crypto_
 	return &crypto_cipher_tfm(tfm)->__crt_alg->cra_cipher;
 }
 
+static inline struct crypto_shash *crypto_spawn_shash(struct crypto_spawn *spawn)
+{
+	u32 type = CRYPTO_ALG_TYPE_SHASH;
+	u32 mask = CRYPTO_ALG_TYPE_MASK;
+
+	return (struct crypto_shash *)(crypto_spawn_tfm(spawn, type, mask));
+}
+
 static inline struct crypto_hash *crypto_spawn_hash(struct crypto_spawn *spawn)
 {
 	u32 type = CRYPTO_ALG_TYPE_HASH;
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -408,6 +408,9 @@ static int crypto_init_shash_ops_compat(
 	return 0;
 }
 
+static int crypto_shash_init_tfm(struct crypto_tfm *tfm,
+				 const struct crypto_type *frontend);
+
 static int crypto_init_shash_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 {
 	switch (mask & CRYPTO_ALG_TYPE_MASK) {
@@ -415,6 +418,9 @@ static int crypto_init_shash_ops(struct 
 		return crypto_init_shash_ops_compat(tfm);
 	case CRYPTO_ALG_TYPE_AHASH_MASK:
 		return crypto_init_shash_ops_async(tfm);
+	case CRYPTO_ALG_TYPE_MASK:
+		if ((type & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_SHASH)
+			return crypto_shash_init_tfm(tfm, &crypto_shash_type);
 	}
 
 	return -EINVAL;


