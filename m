From: Andrew Zaborowski <andrew.zaborowski@intel.com>
Subject: [PATCH v5 3/4] crypto: akcipher: add akcipher declarations needed by templates.
Date: Thu, 26 Nov 2015 22:53:27 +0100
Message-ID: <1448574808-11320-1-git-send-email-andrew.zaborowski@intel.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:34706 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbbKZVxi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Nov 2015 16:53:38 -0500
Received: by wmvv187 with SMTP id v187so47239467wmv.1
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2015 13:53:36 -0800 (PST)
Received: from localhost.localdomain (9.Red-2-136-109.dynamicIP.rima-tde.net. [2.136.109.9])
        by smtp.gmail.com with ESMTPSA id 143sm4553713wmv.18.2015.11.26.13.53.35
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 26 Nov 2015 13:53:35 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add a struct akcipher_instance and struct akcipher_spawn similar to
how AEAD declares them and the macros for converting to/from
crypto_instance/crypto_spawn.  Also add register functions to
avoid exposing crypto_akcipher_type.

Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
---
v2: no changes since v1
v3: drop the new crypto_akcipher_type methods and
    add struct akcipher_instance
v4: avoid exposing crypto_akcipher_type after all, add struct akcipher_spawn
    and utilities
v5: add akcipher_instance.free
---
 crypto/akcipher.c                  | 39 ++++++++++++++++++++++++-
 include/crypto/internal/akcipher.h | 60 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 98 insertions(+), 1 deletion(-)

diff --git a/crypto/akcipher.c b/crypto/akcipher.c
index 120ec04..eef68e8 100644
--- a/crypto/akcipher.c
+++ b/crypto/akcipher.c
@@ -21,6 +21,7 @@
 #include <linux/cryptouser.h>
 #include <net/netlink.h>
 #include <crypto/akcipher.h>
+#include <crypto/internal/akcipher.h>
 #include "internal.h"
 
 #ifdef CONFIG_NET
@@ -75,9 +76,22 @@ static int crypto_akcipher_init_tfm(struct crypto_tfm *tfm)
 	return 0;
 }
 
+static void crypto_akcipher_free_instance(struct crypto_instance *inst)
+{
+	struct akcipher_instance *akcipher = akcipher_instance(inst);
+
+	if (!akcipher->free) {
+		inst->tmpl->free(inst);
+		return;
+	}
+
+	akcipher->free(akcipher);
+}
+
 static const struct crypto_type crypto_akcipher_type = {
 	.extsize = crypto_alg_extsize,
 	.init_tfm = crypto_akcipher_init_tfm,
+	.free = crypto_akcipher_free_instance,
 #ifdef CONFIG_PROC_FS
 	.show = crypto_akcipher_show,
 #endif
@@ -88,6 +102,14 @@ static const struct crypto_type crypto_akcipher_type = {
 	.tfmsize = offsetof(struct crypto_akcipher, base),
 };
 
+int crypto_grab_akcipher(struct crypto_akcipher_spawn *spawn, const char *name,
+			 u32 type, u32 mask)
+{
+	spawn->base.frontend = &crypto_akcipher_type;
+	return crypto_grab_spawn(&spawn->base, name, type, mask);
+}
+EXPORT_SYMBOL_GPL(crypto_grab_akcipher);
+
 struct crypto_akcipher *crypto_alloc_akcipher(const char *alg_name, u32 type,
 					      u32 mask)
 {
@@ -95,13 +117,20 @@ struct crypto_akcipher *crypto_alloc_akcipher(const char *alg_name, u32 type,
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_akcipher);
 
-int crypto_register_akcipher(struct akcipher_alg *alg)
+static void akcipher_prepare_alg(struct akcipher_alg *alg)
 {
 	struct crypto_alg *base = &alg->base;
 
 	base->cra_type = &crypto_akcipher_type;
 	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
 	base->cra_flags |= CRYPTO_ALG_TYPE_AKCIPHER;
+}
+
+int crypto_register_akcipher(struct akcipher_alg *alg)
+{
+	struct crypto_alg *base = &alg->base;
+
+	akcipher_prepare_alg(alg);
 	return crypto_register_alg(base);
 }
 EXPORT_SYMBOL_GPL(crypto_register_akcipher);
@@ -112,5 +141,13 @@ void crypto_unregister_akcipher(struct akcipher_alg *alg)
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_akcipher);
 
+int akcipher_register_instance(struct crypto_template *tmpl,
+			       struct akcipher_instance *inst)
+{
+	akcipher_prepare_alg(&inst->alg);
+	return crypto_register_instance(tmpl, akcipher_crypto_instance(inst));
+}
+EXPORT_SYMBOL_GPL(akcipher_register_instance);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Generic public key cipher type");
diff --git a/include/crypto/internal/akcipher.h b/include/crypto/internal/akcipher.h
index 9a2bda1..9e4103d 100644
--- a/include/crypto/internal/akcipher.h
+++ b/include/crypto/internal/akcipher.h
@@ -13,6 +13,22 @@
 #ifndef _CRYPTO_AKCIPHER_INT_H
 #define _CRYPTO_AKCIPHER_INT_H
 #include <crypto/akcipher.h>
+#include <crypto/algapi.h>
+
+struct akcipher_instance {
+	void (*free)(struct akcipher_instance *inst);
+	union {
+		struct {
+			char head[offsetof(struct akcipher_alg, base)];
+			struct crypto_instance base;
+		} s;
+		struct akcipher_alg alg;
+	};
+};
+
+struct crypto_akcipher_spawn {
+	struct crypto_spawn base;
+};
 
 /*
  * Transform internal helpers.
@@ -38,6 +54,38 @@ static inline const char *akcipher_alg_name(struct crypto_akcipher *tfm)
 	return crypto_akcipher_tfm(tfm)->__crt_alg->cra_name;
 }
 
+static inline struct crypto_instance *akcipher_crypto_instance(
+		struct akcipher_instance *inst)
+{
+	return container_of(&inst->alg.base, struct crypto_instance, alg);
+}
+
+static inline struct akcipher_instance *akcipher_instance(
+		struct crypto_instance *inst)
+{
+	return container_of(&inst->alg, struct akcipher_instance, alg.base);
+}
+
+int crypto_grab_akcipher(struct crypto_akcipher_spawn *spawn, const char *name,
+		u32 type, u32 mask);
+
+static inline void crypto_drop_akcipher(struct crypto_akcipher_spawn *spawn)
+{
+	crypto_drop_spawn(&spawn->base);
+}
+
+static inline struct akcipher_alg *crypto_spawn_akcipher_alg(
+		struct crypto_akcipher_spawn *spawn)
+{
+	return container_of(spawn->base.alg, struct akcipher_alg, base);
+}
+
+static inline struct crypto_akcipher *crypto_spawn_akcipher(
+	struct crypto_akcipher_spawn *spawn)
+{
+	return crypto_spawn_tfm2(&spawn->base);
+}
+
 /**
  * crypto_register_akcipher() -- Register public key algorithm
  *
@@ -57,4 +105,16 @@ int crypto_register_akcipher(struct akcipher_alg *alg);
  * @alg:	algorithm definition
  */
 void crypto_unregister_akcipher(struct akcipher_alg *alg);
+
+/**
+ * akcipher_register_instance() -- Unregister public key template instance
+ *
+ * Function registers an implementation of an asymmetric key algorithm
+ * created from a template
+ *
+ * @tmpl:	the template from which the algorithm was created
+ * @inst:	the template instance
+ */
+int akcipher_register_instance(struct crypto_template *tmpl,
+		struct akcipher_instance *inst);
 #endif
-- 
2.1.4
