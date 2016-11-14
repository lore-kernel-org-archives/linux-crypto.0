From: Alex Cope <alexcope@google.com>
Subject: [RFC][PATCH 4/7] crypto: shash - Add crypto_grab_shash() and crypto_spawn_shash_alg()
Date: Mon, 14 Nov 2016 13:01:15 -0800
Message-ID: <1479157277-10251-5-git-send-email-alexcope@google.com>
References: <1479157277-10251-1-git-send-email-alexcope@google.com>
Cc: mhalcrow@google.com, edknapp@google.com,
        Alex Cope <alexcope@google.com>,
        Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:35314 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753274AbcKNVBv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Nov 2016 16:01:51 -0500
Received: by mail-pf0-f181.google.com with SMTP id i88so31318523pfk.2
        for <linux-crypto@vger.kernel.org>; Mon, 14 Nov 2016 13:01:50 -0800 (PST)
In-Reply-To: <1479157277-10251-1-git-send-email-alexcope@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Analogous to crypto_grab_skcipher() and crypto_spawn_skcipher_alg(),
these are useful for algorithms that need to use a shash sub-algorithm,
possibly in addition to other sub-algorithms.

Signed-off-by: Alex Cope <alexcope@google.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/shash.c                 | 8 ++++++++
 include/crypto/internal/hash.h | 8 ++++++++
 2 files changed, 16 insertions(+)

diff --git a/crypto/shash.c b/crypto/shash.c
index a051541..55a5535 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -536,6 +536,14 @@ void shash_free_instance(struct crypto_instance *inst)
 }
 EXPORT_SYMBOL_GPL(shash_free_instance);
 
+int crypto_grab_shash(struct crypto_shash_spawn *spawn,
+		      const char *name, u32 type, u32 mask)
+{
+	spawn->base.frontend = &crypto_shash_type;
+	return crypto_grab_spawn(&spawn->base, name, type, mask);
+}
+EXPORT_SYMBOL_GPL(crypto_grab_shash);
+
 int crypto_init_shash_spawn(struct crypto_shash_spawn *spawn,
 			    struct shash_alg *alg,
 			    struct crypto_instance *inst)
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 1d4f365..54e4425 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -99,6 +99,8 @@ int shash_register_instance(struct crypto_template *tmpl,
 			    struct shash_instance *inst);
 void shash_free_instance(struct crypto_instance *inst);
 
+int crypto_grab_shash(struct crypto_shash_spawn *spawn,
+		      const char *name, u32 type, u32 mask);
 int crypto_init_shash_spawn(struct crypto_shash_spawn *spawn,
 			    struct shash_alg *alg,
 			    struct crypto_instance *inst);
@@ -108,6 +110,12 @@ static inline void crypto_drop_shash(struct crypto_shash_spawn *spawn)
 	crypto_drop_spawn(&spawn->base);
 }
 
+static inline struct shash_alg *crypto_spawn_shash_alg(
+	struct crypto_shash_spawn *spawn)
+{
+	return container_of(spawn->base.alg, struct shash_alg, base);
+}
+
 struct shash_alg *shash_attr_alg(struct rtattr *rta, u32 type, u32 mask);
 
 int shash_ahash_update(struct ahash_request *req, struct shash_desc *desc);
-- 
2.8.0.rc3.226.g39d4020
