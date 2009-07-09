From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/16] crypto: shash - Add shash_instance
Date: Thu, 09 Jul 2009 12:53:48 +0800
Message-ID: <E1MOldk-0005Vq-QM@gondolin.me.apana.org.au>
References: <20090709045052.GA21092@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44858 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751556AbZGIExu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Jul 2009 00:53:50 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MOldl-0006DG-3q
	for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2009 14:53:49 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: shash - Add shash_instance

This patch adds shash_instance and the associated alloc/free
functions.  This is meant to be an instance that with a shash
algorithm under it.  Note that the instance itself doesn't have
to be shash.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/shash.c                 |    7 +++++++
 include/crypto/internal/hash.h |   26 ++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/crypto/shash.c b/crypto/shash.c
index 2ccc8b0..8f9d883 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -502,5 +502,12 @@ int crypto_unregister_shash(struct shash_alg *alg)
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_shash);
 
+void shash_free_instance(struct crypto_instance *inst)
+{
+	crypto_drop_spawn(crypto_instance_ctx(inst));
+	kfree(shash_instance(inst));
+}
+EXPORT_SYMBOL_GPL(shash_free_instance);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Synchronous cryptographic hash type");
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 82b7056..44d3bcd 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -34,6 +34,10 @@ struct crypto_hash_walk {
 	unsigned int flags;
 };
 
+struct shash_instance {
+	struct shash_alg alg;
+};
+
 extern const struct crypto_type crypto_ahash_type;
 
 int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err);
@@ -46,6 +50,8 @@ int crypto_hash_walk_first_compat(struct hash_desc *hdesc,
 int crypto_register_shash(struct shash_alg *alg);
 int crypto_unregister_shash(struct shash_alg *alg);
 
+void shash_free_instance(struct crypto_instance *inst);
+
 static inline void *crypto_ahash_ctx(struct crypto_ahash *tfm)
 {
 	return crypto_tfm_ctx(&tfm->base);
@@ -80,5 +86,25 @@ static inline void *crypto_shash_ctx(struct crypto_shash *tfm)
 	return crypto_tfm_ctx(&tfm->base);
 }
 
+static inline struct crypto_instance *shash_crypto_instance(
+	struct shash_instance *inst)
+{
+	return container_of(&inst->alg.base, struct crypto_instance, alg);
+}
+
+static inline struct shash_instance *shash_instance(
+	struct crypto_instance *inst)
+{
+	return container_of(__crypto_shash_alg(&inst->alg),
+			    struct shash_instance, alg);
+}
+
+static inline struct shash_instance *shash_alloc_instance(
+	const char *name, struct crypto_alg *alg)
+{
+	return crypto_alloc_instance2(name, alg,
+				      sizeof(struct shash_alg) - sizeof(*alg));
+}
+
 #endif	/* _CRYPTO_INTERNAL_HASH_H */
 
