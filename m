From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7/16] crypto: shash - Add shash_attr_alg2 helper
Date: Thu, 09 Jul 2009 12:53:53 +0800
Message-ID: <E1MOldp-0005WQ-4h@gondolin.me.apana.org.au>
References: <20090709045052.GA21092@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44864 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752025AbZGIExz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Jul 2009 00:53:55 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MOldp-0006E6-Hp
	for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2009 14:53:53 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: shash - Add shash_attr_alg2 helper

This patch adds the helper shash_attr_alg2 which locates a shash
algorithm based on the information in the given attribute.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/shash.c                 |   10 ++++++++++
 include/crypto/internal/hash.h |    2 ++
 2 files changed, 12 insertions(+)

diff --git a/crypto/shash.c b/crypto/shash.c
index 97f6c8b..21bcff6 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -518,5 +518,15 @@ int crypto_init_shash_spawn(struct crypto_shash_spawn *spawn,
 }
 EXPORT_SYMBOL_GPL(crypto_init_shash_spawn);
 
+struct shash_alg *shash_attr_alg(struct rtattr *rta, u32 type, u32 mask)
+{
+	struct crypto_alg *alg;
+
+	alg = crypto_attr_alg2(rta, &crypto_shash_type, type, mask);
+	return IS_ERR(alg) ? ERR_CAST(alg) :
+	       container_of(alg, struct shash_alg, base);
+}
+EXPORT_SYMBOL_GPL(shash_attr_alg);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Synchronous cryptographic hash type");
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 6cc824b..e2ab35a 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -60,6 +60,8 @@ int crypto_init_shash_spawn(struct crypto_shash_spawn *spawn,
 			    struct shash_alg *alg,
 			    struct crypto_instance *inst);
 
+struct shash_alg *shash_attr_alg(struct rtattr *rta, u32 type, u32 mask);
+
 static inline void *crypto_ahash_ctx(struct crypto_ahash *tfm)
 {
 	return crypto_tfm_ctx(&tfm->base);
