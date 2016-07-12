From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v3 1/4] crypto: add template handling for RNGs
Date: Tue, 12 Jul 2016 11:07:18 +0200
Message-ID: <2944776.2qGGKJgDkv@positron.chronox.de>
References: <4161793.TTVXSVQtZL@positron.chronox.de> <1517551.AxEWRg6eD0@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:39018 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090AbcGLJJW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jul 2016 05:09:22 -0400
In-Reply-To: <1517551.AxEWRg6eD0@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds the ability to register templates for RNGs. RNGs are
"meta" mechanisms using raw cipher primitives. Thus, RNGs can now be
implemented as templates to allow the complete flexibility the kernel
crypto API provides.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/rng.c         | 31 +++++++++++++++++++++++++++++++
 include/crypto/rng.h | 39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+)

diff --git a/crypto/rng.c b/crypto/rng.c
index b81cffb..92cc02a 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -232,5 +232,36 @@ void crypto_unregister_rngs(struct rng_alg *algs, int count)
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_rngs);
 
+void rng_free_instance(struct crypto_instance *inst)
+{
+	crypto_drop_spawn(crypto_instance_ctx(inst));
+	kfree(rng_instance(inst));
+}
+EXPORT_SYMBOL_GPL(rng_free_instance);
+
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
diff --git a/include/crypto/rng.h b/include/crypto/rng.h
index b95ede3..b8a6ea3 100644
--- a/include/crypto/rng.h
+++ b/include/crypto/rng.h
@@ -15,6 +15,7 @@
 #define _CRYPTO_RNG_H
 
 #include <linux/crypto.h>
+#include <crypto/algapi.h>
 
 struct crypto_rng;
 
@@ -197,4 +198,42 @@ static inline int crypto_rng_seedsize(struct crypto_rng *tfm)
 	return crypto_rng_alg(tfm)->seedsize;
 }
 
+struct rng_instance {
+	struct rng_alg alg;
+};
+
+static inline struct rng_instance *rng_alloc_instance(
+	const char *name, struct crypto_alg *alg)
+{
+	return crypto_alloc_instance2(name, alg,
+				      sizeof(struct rng_alg) - sizeof(*alg));
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
+void rng_free_instance(struct crypto_instance *inst);
+
 #endif
-- 
2.7.4
