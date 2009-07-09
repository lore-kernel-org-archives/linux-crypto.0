From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 8/16] crypto: shash - Add shash_register_instance
Date: Thu, 09 Jul 2009 12:53:54 +0800
Message-ID: <E1MOldq-0005WZ-7H@gondolin.me.apana.org.au>
References: <20090709045052.GA21092@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44865 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752083AbZGIExz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Jul 2009 00:53:55 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MOldq-0006EE-G8
	for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2009 14:53:54 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: shash - Add shash_register_instance

This patch adds shash_register_instance so that shash instances
can be registered without bypassing the shash checks applied to
normal algorithms.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/shash.c                 |   26 +++++++++++++++++++++++++-
 include/crypto/internal/hash.h |    3 ++-
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index 21bcff6..3d24242 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -480,7 +480,7 @@ struct crypto_shash *crypto_alloc_shash(const char *alg_name, u32 type,
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_shash);
 
-int crypto_register_shash(struct shash_alg *alg)
+static int shash_prepare_alg(struct shash_alg *alg)
 {
 	struct crypto_alg *base = &alg->base;
 
@@ -491,6 +491,17 @@ int crypto_register_shash(struct shash_alg *alg)
 	base->cra_type = &crypto_shash_type;
 	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
 	base->cra_flags |= CRYPTO_ALG_TYPE_SHASH;
+	return 0;
+}
+
+int crypto_register_shash(struct shash_alg *alg)
+{
+	struct crypto_alg *base = &alg->base;
+	int err;
+
+	err = shash_prepare_alg(alg);
+	if (err)
+		return err;
 
 	return crypto_register_alg(base);
 }
@@ -502,6 +513,19 @@ int crypto_unregister_shash(struct shash_alg *alg)
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_shash);
 
+int shash_register_instance(struct crypto_template *tmpl,
+			    struct shash_instance *inst)
+{
+	int err;
+
+	err = shash_prepare_alg(&inst->alg);
+	if (err)
+		return err;
+
+	return crypto_register_instance(tmpl, shash_crypto_instance(inst));
+}
+EXPORT_SYMBOL_GPL(shash_register_instance);
+
 void shash_free_instance(struct crypto_instance *inst)
 {
 	crypto_drop_spawn(crypto_instance_ctx(inst));
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index e2ab35a..fa5c9fb 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -53,7 +53,8 @@ int crypto_hash_walk_first_compat(struct hash_desc *hdesc,
 
 int crypto_register_shash(struct shash_alg *alg);
 int crypto_unregister_shash(struct shash_alg *alg);
