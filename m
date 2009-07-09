From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/16] crypto: shash - Add spawn support
Date: Thu, 09 Jul 2009 12:53:50 +0800
Message-ID: <E1MOldm-0005W8-Vm@gondolin.me.apana.org.au>
References: <20090709045052.GA21092@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44860 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751588AbZGIExw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Jul 2009 00:53:52 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MOldn-0006DX-9r
	for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2009 14:53:51 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: shash - Add spawn support

This patch adds the functions needed to create and use shash
spawns, i.e., to use shash algorithms in a template.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/shash.c                 |    9 +++++++++
 include/crypto/internal/hash.h |   14 ++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/crypto/shash.c b/crypto/shash.c
index 8f9d883..97f6c8b 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -509,5 +509,14 @@ void shash_free_instance(struct crypto_instance *inst)
 }
 EXPORT_SYMBOL_GPL(shash_free_instance);
 
+int crypto_init_shash_spawn(struct crypto_shash_spawn *spawn,
+			    struct shash_alg *alg,
+			    struct crypto_instance *inst)
+{
+	return crypto_init_spawn2(&spawn->base, &alg->base, inst,
+				  &crypto_shash_type);
+}
+EXPORT_SYMBOL_GPL(crypto_init_shash_spawn);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Synchronous cryptographic hash type");
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 44d3bcd..6cc824b 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -38,6 +38,10 @@ struct shash_instance {
 	struct shash_alg alg;
 };
 
+struct crypto_shash_spawn {
+	struct crypto_spawn base;
+};
+
 extern const struct crypto_type crypto_ahash_type;
 
 int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err);
@@ -52,6 +56,10 @@ int crypto_unregister_shash(struct shash_alg *alg);
 
 void shash_free_instance(struct crypto_instance *inst);
 
+int crypto_init_shash_spawn(struct crypto_shash_spawn *spawn,
+			    struct shash_alg *alg,
+			    struct crypto_instance *inst);
+
 static inline void *crypto_ahash_ctx(struct crypto_ahash *tfm)
 {
 	return crypto_tfm_ctx(&tfm->base);
@@ -106,5 +114,11 @@ static inline struct shash_instance *shash_alloc_instance(
 				      sizeof(struct shash_alg) - sizeof(*alg));
 }
 
+static inline struct crypto_shash *crypto_spawn_shash(
+	struct crypto_shash_spawn *spawn)
+{
+	return crypto_spawn_tfm2(&spawn->base);
+}
+
 #endif	/* _CRYPTO_INTERNAL_HASH_H */
 
