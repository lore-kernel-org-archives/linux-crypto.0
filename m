From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 26/35] crypto: hash - Add helpers to free spawns
Date: Wed, 15 Jul 2009 15:16:20 +0800
Message-ID: <E1MQyiy-00051U-Hk@gondolin.me.apana.org.au>
References: <20090715071424.GA19023@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53654 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752700AbZGOHQ2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 03:16:28 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MQyiz-0004uM-M4
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2009 17:16:22 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: hash - Add helpers to free spawns

This patch adds the helpers crypto_drop_ahash and crypto_drop_shash
so that these spawns can be dropped without ugly casts.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/crypto/internal/hash.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 34eda23..9d30316 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -69,6 +69,11 @@ int crypto_init_ahash_spawn(struct crypto_ahash_spawn *spawn,
 			    struct hash_alg_common *alg,
 			    struct crypto_instance *inst);
 
+static inline void crypto_drop_ahash(struct crypto_ahash_spawn *spawn)
+{
+	crypto_drop_spawn(&spawn->base);
+}
+
 struct hash_alg_common *ahash_attr_alg(struct rtattr *rta, u32 type, u32 mask);
 
 int crypto_register_shash(struct shash_alg *alg);
@@ -81,6 +86,11 @@ int crypto_init_shash_spawn(struct crypto_shash_spawn *spawn,
 			    struct shash_alg *alg,
 			    struct crypto_instance *inst);
 
+static inline void crypto_drop_shash(struct crypto_shash_spawn *spawn)
+{
+	crypto_drop_spawn(&spawn->base);
+}
+
 struct shash_alg *shash_attr_alg(struct rtattr *rta, u32 type, u32 mask);
 
 int shash_ahash_update(struct ahash_request *req, struct shash_desc *desc);
