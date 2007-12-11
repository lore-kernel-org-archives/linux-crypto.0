From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/19] [CRYPTO] skcipher: Add crypto_grab_skcipher interface
Date: Tue, 11 Dec 2007 12:02:56 +0800
Message-ID: <E1J1wKe-0002jk-00@gondolin.me.apana.org.au>
References: <20071211040215.GA10360@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1913 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751862AbXLKEDB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Dec 2007 23:03:01 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J1wKf-00062J-17
	for <linux-crypto@vger.kernel.org>; Tue, 11 Dec 2007 15:02:57 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] skcipher: Add crypto_grab_skcipher interface

This patch adds the function crypto_grab_skcipher as a new way of getting
an ablkcipher spawn.  The problem is that previously we did this in two
steps, first getting the algorithm and then calling crypto_init_spawn.

This meant that each spawn user had to be aware of what type and mask to
use for these two steps.  This is difficult and also presents a problem
when the type/mask changes as they're about to be for IV generators.

The new interface does both steps together just like crypto_alloc_ablkcipher.

As a side-effect this also allows us to be stronger on type enforcement
for spawns.  For now this is only done for ablkcipher but it's trivial
to extend for other types.

This patch also moves the type/mask logic for skcipher into the helpers
crypto_skcipher_type and crypto_skcipher_mask.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ablkcipher.c                |   23 +++++++++++++++++++++--
 include/crypto/algapi.h            |   13 +++++++++----
 include/crypto/internal/skcipher.h |   32 ++++++++++++++++++++++++++++++++
 include/linux/crypto.h             |   26 ++++++++++++++++----------
 4 files changed, 78 insertions(+), 16 deletions(-)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index 66e3922..76801c4 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -13,14 +13,16 @@
  *
  */
 
-#include <crypto/algapi.h>
-#include <linux/errno.h>
+#include <crypto/internal/skcipher.h>
+#include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
 
+#include "internal.h"
+
 static int setkey_unaligned(struct crypto_ablkcipher *tfm, const u8 *key,
 			    unsigned int keylen)
 {
@@ -153,5 +155,22 @@ const struct crypto_type crypto_givcipher_type = {
 };
 EXPORT_SYMBOL_GPL(crypto_givcipher_type);
 
+int crypto_grab_skcipher(struct crypto_skcipher_spawn *spawn, const char *name,
+			 u32 type, u32 mask)
+{
+	struct crypto_alg *alg;
+	int err;
+
+	alg = crypto_alg_mod_lookup(name, crypto_skcipher_type(type),
+				    crypto_skcipher_mask(mask));
+	if (IS_ERR(alg))
+		return PTR_ERR(alg);
+
+	err = crypto_init_spawn(&spawn->base, alg, spawn->base.inst, mask);
+	crypto_mod_put(alg);
+	return err;
+}
+EXPORT_SYMBOL_GPL(crypto_grab_skcipher);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Asynchronous block chaining cipher type");
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 726a765..f1c9b61 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -111,6 +111,12 @@ void crypto_drop_spawn(struct crypto_spawn *spawn);
 struct crypto_tfm *crypto_spawn_tfm(struct crypto_spawn *spawn, u32 type,
 				    u32 mask);
 
+static inline void crypto_set_spawn(struct crypto_spawn *spawn,
+				    struct crypto_instance *inst)
+{
+	spawn->inst = inst;
+}
+
 struct crypto_attr_type *crypto_get_attr_type(struct rtattr **tb);
 int crypto_check_attr_type(struct rtattr **tb, u32 type);
 const char *crypto_attr_alg_name(struct rtattr *rta);
@@ -195,10 +201,9 @@ static inline struct crypto_instance *crypto_aead_alg_instance(
 static inline struct crypto_ablkcipher *crypto_spawn_ablkcipher(
 	struct crypto_spawn *spawn)
 {
-	u32 type = CRYPTO_ALG_TYPE_BLKCIPHER;
-	u32 mask = CRYPTO_ALG_TYPE_BLKCIPHER_MASK;
-
-	return __crypto_ablkcipher_cast(crypto_spawn_tfm(spawn, type, mask));
+	return __crypto_ablkcipher_cast(
+		crypto_spawn_tfm(spawn, crypto_skcipher_type(0),
+				 crypto_skcipher_mask(0)));
 }
 
 static inline struct crypto_blkcipher *crypto_spawn_blkcipher(
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index 04951cb..c9402dd 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -16,8 +16,40 @@
 #include <crypto/algapi.h>
 #include <crypto/skcipher.h>
 
+struct crypto_skcipher_spawn {
+	struct crypto_spawn base;
+};
+
 extern const struct crypto_type crypto_givcipher_type;
 
+static inline void crypto_set_skcipher_spawn(
+	struct crypto_skcipher_spawn *spawn, struct crypto_instance *inst)
+{
+	crypto_set_spawn(&spawn->base, inst);
+}
+
+int crypto_grab_skcipher(struct crypto_skcipher_spawn *spawn, const char *name,
+			 u32 type, u32 mask);
+
+static inline void crypto_drop_skcipher(struct crypto_skcipher_spawn *spawn)
+{
+	crypto_drop_spawn(&spawn->base);
+}
+
+static inline struct crypto_alg *crypto_skcipher_spawn_alg(
+	struct crypto_skcipher_spawn *spawn)
+{
+	return spawn->base.alg;
+}
+
+static inline struct crypto_ablkcipher *crypto_spawn_skcipher(
+	struct crypto_skcipher_spawn *spawn)
+{
+	return __crypto_ablkcipher_cast(
+		crypto_spawn_tfm(&spawn->base, crypto_skcipher_type(0),
+				 crypto_skcipher_mask(0)));
+}
+
 static inline void *skcipher_givcrypt_reqctx(
 	struct skcipher_givcrypt_request *req)
 {
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 5462711..facafa1 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -539,16 +539,26 @@ static inline struct crypto_ablkcipher *__crypto_ablkcipher_cast(
 	return (struct crypto_ablkcipher *)tfm;
 }
 
-static inline struct crypto_ablkcipher *crypto_alloc_ablkcipher(
-	const char *alg_name, u32 type, u32 mask)
+static inline u32 crypto_skcipher_type(u32 type)
 {
 	type &= ~CRYPTO_ALG_TYPE_MASK;
-	mask &= ~CRYPTO_ALG_TYPE_MASK;
 	type |= CRYPTO_ALG_TYPE_BLKCIPHER;
+	return type;
+}
+
+static inline u32 crypto_skcipher_mask(u32 mask)
+{
+	mask &= ~CRYPTO_ALG_TYPE_MASK;
 	mask |= CRYPTO_ALG_TYPE_BLKCIPHER_MASK;
+	return mask;
+}
 
+static inline struct crypto_ablkcipher *crypto_alloc_ablkcipher(
+	const char *alg_name, u32 type, u32 mask)
+{
 	return __crypto_ablkcipher_cast(
-		crypto_alloc_base(alg_name, type, mask));
+		crypto_alloc_base(alg_name, crypto_skcipher_type(type),
+				  crypto_skcipher_mask(mask)));
 }
 
 static inline struct crypto_tfm *crypto_ablkcipher_tfm(
@@ -565,12 +575,8 @@ static inline void crypto_free_ablkcipher(struct crypto_ablkcipher *tfm)
 static inline int crypto_has_ablkcipher(const char *alg_name, u32 type,
 					u32 mask)
 {
-	type &= ~CRYPTO_ALG_TYPE_MASK;
-	mask &= ~CRYPTO_ALG_TYPE_MASK;
-	type |= CRYPTO_ALG_TYPE_BLKCIPHER;
-	mask |= CRYPTO_ALG_TYPE_BLKCIPHER_MASK;
-
-	return crypto_has_alg(alg_name, type, mask);
+	return crypto_has_alg(alg_name, crypto_skcipher_type(type),
+			      crypto_skcipher_mask(mask));
 }
 
 static inline struct ablkcipher_tfm *crypto_ablkcipher_crt(
