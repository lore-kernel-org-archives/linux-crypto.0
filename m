From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v4 1/4] crypto: add template handling for RNGs
Date: Thu, 04 Aug 2016 20:40:01 +0200
Message-ID: <35009855.guO8BxbniF@positron.chronox.de>
References: <2239809.KsND40bFeW@positron.chronox.de> <1908905.sE4dlalNOn@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:33978 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757946AbcHDSl6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Aug 2016 14:41:58 -0400
In-Reply-To: <1908905.sE4dlalNOn@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds the ability to register templates for RNGs. RNGs are
"meta" mechanisms using raw cipher primitives. Thus, RNGs can now be
implemented as templates to allow the complete flexibility the kernel
crypto API provides.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/rng.c                  | 32 ++++++++++++++++++++++++++++++++
 include/crypto/internal/rng.h | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+)

diff --git a/crypto/rng.c b/crypto/rng.c
index b81cffb..e12bd30 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -63,6 +63,13 @@ static int crypto_rng_init_tfm(struct crypto_tfm *tfm)
 	return 0;
 }
 
+static void crypto_rng_free_instance(struct crypto_instance *inst)
+{
+	struct rng_instance *rng = rng_instance(inst);
+
+	rng->free(rng);
+}
+
 static unsigned int seedsize(struct crypto_alg *alg)
 {
 	struct rng_alg *ralg = container_of(alg, struct rng_alg, base);
@@ -105,6 +112,7 @@ static void crypto_rng_show(struct seq_file *m, struct crypto_alg *alg)
 static const struct crypto_type crypto_rng_type = {
 	.extsize = crypto_alg_extsize,
 	.init_tfm = crypto_rng_init_tfm,
+	.free = crypto_rng_free_instance,
 #ifdef CONFIG_PROC_FS
 	.show = crypto_rng_show,
 #endif
@@ -232,5 +240,29 @@ void crypto_unregister_rngs(struct rng_alg *algs, int count)
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_rngs);
 
+static int rng_prepare_alg(struct rng_alg *alg)
+{
+	struct crypto_alg *base = &alg->base;
+
+	base->cra_type = &crypto_rng_type;
+	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
+	base->cra_flags |= CRYPTO_ALG_TYPE_RNG;
+
+	return 0;
+}
+
+int rng_register_instance(struct crypto_template *tmpl,
+			  struct rng_instance *inst)
+{
+	int err;
+
+	err = rng_prepare_alg(&inst->alg);
+	if (err)
+		return err;
+
+	return crypto_register_instance(tmpl, rng_crypto_instance(inst));
+}
+EXPORT_SYMBOL_GPL(rng_register_instance);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Random Number Generator");
diff --git a/include/crypto/internal/rng.h b/include/crypto/internal/rng.h
index a52ef34..30ff076 100644
--- a/include/crypto/internal/rng.h
+++ b/include/crypto/internal/rng.h
@@ -42,4 +42,42 @@ static inline void crypto_rng_set_entropy(struct crypto_rng *tfm,
 	crypto_rng_alg(tfm)->set_ent(tfm, data, len);
 }
 
+struct rng_instance {
+	void (*free)(struct rng_instance *inst);
+	struct rng_alg alg;
+};
+
+static inline struct rng_instance *rng_alloc_instance(
+	const char *name, struct crypto_alg *alg)
+{
+	return crypto_alloc_instance2(name, alg,
+			      sizeof(struct rng_instance) - sizeof(*alg));
+}
+
+static inline struct crypto_instance *rng_crypto_instance(
+	struct rng_instance *inst)
+{
+	return container_of(&inst->alg.base, struct crypto_instance, alg);
+}
+
+static inline void *rng_instance_ctx(struct rng_instance *inst)
+{
+	return crypto_instance_ctx(rng_crypto_instance(inst));
+}
+
+static inline struct rng_alg *__crypto_rng_alg(struct crypto_alg *alg)
+{
+	return container_of(alg, struct rng_alg, base);
+}
+
+static inline struct rng_instance *rng_instance(
+	struct crypto_instance *inst)
+{
+	return container_of(__crypto_rng_alg(&inst->alg),
+			    struct rng_instance, alg);
+}
+
+int rng_register_instance(struct crypto_template *tmpl,
+			  struct rng_instance *inst);
+
 #endif
-- 
2.7.4
