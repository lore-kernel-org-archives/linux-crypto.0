From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 24/35] crypto: ahash - Add instance/spawn support
Date: Wed, 15 Jul 2009 15:16:18 +0800
Message-ID: <E1MQyiw-00051C-C2@gondolin.me.apana.org.au>
References: <20090715071424.GA19023@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53650 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752181AbZGOHQ0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 03:16:26 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MQyix-0004th-IN
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2009 17:16:20 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: ahash - Add instance/spawn support

This patch adds support for creating ahash instances and using
ahash as spawns.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ahash.c                 |   72 +++++++++++++++++++++++++++++++++++++++++
 include/crypto/internal/hash.h |   51 +++++++++++++++++++++++++++++
 2 files changed, 123 insertions(+)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 8385193..7f599d2 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -259,5 +259,77 @@ struct crypto_ahash *crypto_alloc_ahash(const char *alg_name, u32 type,
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_ahash);
 
+static int ahash_prepare_alg(struct ahash_alg *alg)
+{
+	struct crypto_alg *base = &alg->halg.base;
+
+	if (alg->halg.digestsize > PAGE_SIZE / 8 ||
+	    alg->halg.statesize > PAGE_SIZE / 8)
+		return -EINVAL;
+
+	base->cra_type = &crypto_ahash_type;
+	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
+	base->cra_flags |= CRYPTO_ALG_TYPE_AHASH;
+
+	return 0;
+}
+
+int crypto_register_ahash(struct ahash_alg *alg)
+{
+	struct crypto_alg *base = &alg->halg.base;
+	int err;
+
+	err = ahash_prepare_alg(alg);
+	if (err)
+		return err;
+
+	return crypto_register_alg(base);
+}
+EXPORT_SYMBOL_GPL(crypto_register_ahash);
+
+int crypto_unregister_ahash(struct ahash_alg *alg)
+{
+	return crypto_unregister_alg(&alg->halg.base);
+}
+EXPORT_SYMBOL_GPL(crypto_unregister_ahash);
+
+int ahash_register_instance(struct crypto_template *tmpl,
+			    struct ahash_instance *inst)
+{
+	int err;
+
+	err = ahash_prepare_alg(&inst->alg);
+	if (err)
+		return err;
+
+	return crypto_register_instance(tmpl, ahash_crypto_instance(inst));
+}
+EXPORT_SYMBOL_GPL(ahash_register_instance);
+
+void ahash_free_instance(struct crypto_instance *inst)
+{
+	crypto_drop_spawn(crypto_instance_ctx(inst));
+	kfree(ahash_instance(inst));
+}
+EXPORT_SYMBOL_GPL(ahash_free_instance);
+
+int crypto_init_ahash_spawn(struct crypto_ahash_spawn *spawn,
+			    struct hash_alg_common *alg,
+			    struct crypto_instance *inst)
+{
+	return crypto_init_spawn2(&spawn->base, &alg->base, inst,
+				  &crypto_ahash_type);
+}
+EXPORT_SYMBOL_GPL(crypto_init_ahash_spawn);
+
+struct hash_alg_common *ahash_attr_alg(struct rtattr *rta, u32 type, u32 mask)
+{
+	struct crypto_alg *alg;
+
+	alg = crypto_attr_alg2(rta, &crypto_ahash_type, type, mask);
+	return IS_ERR(alg) ? ERR_CAST(alg) : __crypto_hash_alg_common(alg);
+}
+EXPORT_SYMBOL_GPL(ahash_attr_alg);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Asynchronous cryptographic hash type");
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 08bdffa..34eda23 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -34,10 +34,18 @@ struct crypto_hash_walk {
 	unsigned int flags;
 };
 
+struct ahash_instance {
+	struct ahash_alg alg;
+};
+
 struct shash_instance {
 	struct shash_alg alg;
 };
 
+struct crypto_ahash_spawn {
+	struct crypto_spawn base;
+};
+
 struct crypto_shash_spawn {
 	struct crypto_spawn base;
 };
@@ -53,6 +61,15 @@ int crypto_hash_walk_first_compat(struct hash_desc *hdesc,
 
 int crypto_register_ahash(struct ahash_alg *alg);
 int crypto_unregister_ahash(struct ahash_alg *alg);
+int ahash_register_instance(struct crypto_template *tmpl,
+			    struct ahash_instance *inst);
+void ahash_free_instance(struct crypto_instance *inst);
+
+int crypto_init_ahash_spawn(struct crypto_ahash_spawn *spawn,
+			    struct hash_alg_common *alg,
+			    struct crypto_instance *inst);
+
+struct hash_alg_common *ahash_attr_alg(struct rtattr *rta, u32 type, u32 mask);
 
 int crypto_register_shash(struct shash_alg *alg);
 int crypto_unregister_shash(struct shash_alg *alg);
@@ -88,6 +105,40 @@ static inline void crypto_ahash_set_reqsize(struct crypto_ahash *tfm,
 	tfm->reqsize = reqsize;
 }
 
+static inline struct crypto_instance *ahash_crypto_instance(
+	struct ahash_instance *inst)
+{
+	return container_of(&inst->alg.halg.base, struct crypto_instance, alg);
+}
+
+static inline struct ahash_instance *ahash_instance(
+	struct crypto_instance *inst)
+{
+	return container_of(&inst->alg, struct ahash_instance, alg.halg.base);
+}
+
+static inline void *ahash_instance_ctx(struct ahash_instance *inst)
+{
+	return crypto_instance_ctx(ahash_crypto_instance(inst));
+}
+
+static inline unsigned int ahash_instance_headroom(void)
+{
+	return sizeof(struct ahash_alg) - sizeof(struct crypto_alg);
+}
+
+static inline struct ahash_instance *ahash_alloc_instance(
+	const char *name, struct crypto_alg *alg)
+{
+	return crypto_alloc_instance2(name, alg, ahash_instance_headroom());
+}
+
+static inline struct crypto_ahash *crypto_spawn_ahash(
+	struct crypto_ahash_spawn *spawn)
+{
+	return crypto_spawn_tfm2(&spawn->base);
+}
+
 static inline int ahash_enqueue_request(struct crypto_queue *queue,
 					     struct ahash_request *request)
 {
