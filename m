From: Andrew Zaborowski <andrew.zaborowski@intel.com>
Subject: [PATCH v3 3/4] crypto: akcipher: add akcipher declarations useful for templates.
Date: Fri, 20 Nov 2015 04:13:34 +0100
Message-ID: <1447989215-523-3-git-send-email-andrew.zaborowski@intel.com>
References: <1447989215-523-1-git-send-email-andrew.zaborowski@intel.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:36372 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161329AbbKTDOV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 Nov 2015 22:14:21 -0500
Received: by wmww144 with SMTP id w144so3745303wmw.1
        for <linux-crypto@vger.kernel.org>; Thu, 19 Nov 2015 19:14:20 -0800 (PST)
Received: from localhost.localdomain (9.Red-2-136-109.dynamicIP.rima-tde.net. [2.136.109.9])
        by smtp.gmail.com with ESMTPSA id t194sm672803wmt.11.2015.11.19.19.14.19
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 19 Nov 2015 19:14:19 -0800 (PST)
In-Reply-To: <1447989215-523-1-git-send-email-andrew.zaborowski@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Expose crypto_akcipher_type like other crypto types are exposed to be
used from outside akcipher.c.  Add a struct akcipher_instance similar to
aead_instance with just the right size for an akcipher template
instance, and two macros for converting to/from crypto_instance.

Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
---
v2: no changes since v1
v3: drop the new crypto_akcipher_type methods and
    add struct akcipher_instance
---
 crypto/akcipher.c                  |  3 ++-
 include/crypto/algapi.h            |  1 +
 include/crypto/internal/akcipher.h | 23 +++++++++++++++++++++++
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/crypto/akcipher.c b/crypto/akcipher.c
index 120ec04..d4bb42c 100644
--- a/crypto/akcipher.c
+++ b/crypto/akcipher.c
@@ -75,7 +75,7 @@ static int crypto_akcipher_init_tfm(struct crypto_tfm *tfm)
 	return 0;
 }
 
-static const struct crypto_type crypto_akcipher_type = {
+const struct crypto_type crypto_akcipher_type = {
 	.extsize = crypto_alg_extsize,
 	.init_tfm = crypto_akcipher_init_tfm,
 #ifdef CONFIG_PROC_FS
@@ -87,6 +87,7 @@ static const struct crypto_type crypto_akcipher_type = {
 	.type = CRYPTO_ALG_TYPE_AKCIPHER,
 	.tfmsize = offsetof(struct crypto_akcipher, base),
 };
+EXPORT_SYMBOL_GPL(crypto_akcipher_type);
 
 struct crypto_akcipher *crypto_alloc_akcipher(const char *alg_name, u32 type,
 					      u32 mask)
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index c9fe145..1089f20 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -130,6 +130,7 @@ struct ablkcipher_walk {
 
 extern const struct crypto_type crypto_ablkcipher_type;
 extern const struct crypto_type crypto_blkcipher_type;
+extern const struct crypto_type crypto_akcipher_type;
 
 void crypto_mod_put(struct crypto_alg *alg);
 
diff --git a/include/crypto/internal/akcipher.h b/include/crypto/internal/akcipher.h
index 9a2bda1..706aa82 100644
--- a/include/crypto/internal/akcipher.h
+++ b/include/crypto/internal/akcipher.h
@@ -13,6 +13,17 @@
 #ifndef _CRYPTO_AKCIPHER_INT_H
 #define _CRYPTO_AKCIPHER_INT_H
 #include <crypto/akcipher.h>
+#include <crypto/algapi.h>
+
+struct akcipher_instance {
+	union {
+		struct {
+			char head[offsetof(struct akcipher_alg, base)];
+			struct crypto_instance base;
+		} s;
+		struct akcipher_alg alg;
+	};
+};
 
 /*
  * Transform internal helpers.
@@ -57,4 +68,16 @@ int crypto_register_akcipher(struct akcipher_alg *alg);
  * @alg:	algorithm definition
  */
 void crypto_unregister_akcipher(struct akcipher_alg *alg);
+
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
 #endif
-- 
2.1.4
