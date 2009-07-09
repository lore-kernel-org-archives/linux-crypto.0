From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/16] crypto: api - Add new style spawn support
Date: Thu, 09 Jul 2009 12:53:49 +0800
Message-ID: <E1MOldl-0005Vz-Sx@gondolin.me.apana.org.au>
References: <20090709045052.GA21092@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44859 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751870AbZGIExw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Jul 2009 00:53:52 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MOldm-0006DK-6I
	for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2009 14:53:50 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: api - Add new style spawn support

This patch modifies the spawn infrastructure to support new style
algorithms like shash.  In particular, this means storing the
frontend type in the spawn and using crypto_create_tfm to allocate
the tfm.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/algapi.c         |   55 +++++++++++++++++++++++++++++++++++++++++++++---
 include/crypto/algapi.h |    6 +++++
 2 files changed, 58 insertions(+), 3 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 429f1a0..17a5fff 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -488,6 +488,23 @@ int crypto_init_spawn(struct crypto_spawn *spawn, struct crypto_alg *alg,
 }
 EXPORT_SYMBOL_GPL(crypto_init_spawn);
 
+int crypto_init_spawn2(struct crypto_spawn *spawn, struct crypto_alg *alg,
+		       struct crypto_instance *inst,
+		       const struct crypto_type *frontend)
+{
+	int err = -EINVAL;
+
+	if (frontend && (alg->cra_flags ^ frontend->type) & frontend->maskset)
+		goto out;
+
+	spawn->frontend = frontend;
+	err = crypto_init_spawn(spawn, alg, inst, frontend->maskset);
+
+out:
+	return err;
+}
+EXPORT_SYMBOL_GPL(crypto_init_spawn2);
+
 void crypto_drop_spawn(struct crypto_spawn *spawn)
 {
 	down_write(&crypto_alg_sem);
@@ -496,12 +513,10 @@ void crypto_drop_spawn(struct crypto_spawn *spawn)
 }
 EXPORT_SYMBOL_GPL(crypto_drop_spawn);
 
-struct crypto_tfm *crypto_spawn_tfm(struct crypto_spawn *spawn, u32 type,
-				    u32 mask)
+static struct crypto_alg *crypto_spawn_alg(struct crypto_spawn *spawn)
 {
 	struct crypto_alg *alg;
 	struct crypto_alg *alg2;
-	struct crypto_tfm *tfm;
 
 	down_read(&crypto_alg_sem);
 	alg = spawn->alg;
@@ -516,6 +531,19 @@ struct crypto_tfm *crypto_spawn_tfm(struct crypto_spawn *spawn, u32 type,
 		return ERR_PTR(-EAGAIN);
 	}
 
+	return alg;
+}
+
+struct crypto_tfm *crypto_spawn_tfm(struct crypto_spawn *spawn, u32 type,
+				    u32 mask)
+{
+	struct crypto_alg *alg;
+	struct crypto_tfm *tfm;
+
+	alg = crypto_spawn_alg(spawn);
+	if (IS_ERR(alg))
+		return ERR_CAST(alg);
+
 	tfm = ERR_PTR(-EINVAL);
 	if (unlikely((alg->cra_flags ^ type) & mask))
 		goto out_put_alg;
@@ -532,6 +560,27 @@ out_put_alg:
 }
 EXPORT_SYMBOL_GPL(crypto_spawn_tfm);
 
+void *crypto_spawn_tfm2(struct crypto_spawn *spawn)
+{
+	struct crypto_alg *alg;
+	struct crypto_tfm *tfm;
+
+	alg = crypto_spawn_alg(spawn);
+	if (IS_ERR(alg))
+		return ERR_CAST(alg);
+
+	tfm = crypto_create_tfm(alg, spawn->frontend);
+	if (IS_ERR(tfm))
+		goto out_put_alg;
+
+	return tfm;
+
+out_put_alg:
+	crypto_mod_put(alg);
+	return tfm;
+}
+EXPORT_SYMBOL_GPL(crypto_spawn_tfm2);
+
 int crypto_register_notifier(struct notifier_block *nb)
 {
 	return blocking_notifier_chain_register(&crypto_chain, nb);
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 99bb297..c9bff92 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -61,6 +61,7 @@ struct crypto_spawn {
 	struct list_head list;
 	struct crypto_alg *alg;
 	struct crypto_instance *inst;
+	const struct crypto_type *frontend;
 	u32 mask;
 };
 
@@ -117,9 +118,14 @@ struct crypto_template *crypto_lookup_template(const char *name);
 
 int crypto_init_spawn(struct crypto_spawn *spawn, struct crypto_alg *alg,
 		      struct crypto_instance *inst, u32 mask);
+int crypto_init_spawn2(struct crypto_spawn *spawn, struct crypto_alg *alg,
+		       struct crypto_instance *inst,
+		       const struct crypto_type *frontend);
+
 void crypto_drop_spawn(struct crypto_spawn *spawn);
 struct crypto_tfm *crypto_spawn_tfm(struct crypto_spawn *spawn, u32 type,
 				    u32 mask);
+void *crypto_spawn_tfm2(struct crypto_spawn *spawn);
 
 static inline void crypto_set_spawn(struct crypto_spawn *spawn,
 				    struct crypto_instance *inst)
