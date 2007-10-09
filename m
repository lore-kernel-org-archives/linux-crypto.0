From: Sebastian Siewior <sebastian@breakpoint.cc>
Subject: [RFC 1/3] [crypto] add keysize parameter
Date: Tue, 9 Oct 2007 18:17:35 +0200
Message-ID: <E1IfejL-0005Eb-3F@Chamillionaire.breakpoint.cc>
References: <20071010164400.GA19471@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------1.5.3.4"
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:54605 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754665AbXJJQsU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Oct 2007 12:48:20 -0400
In-Reply-To: <20071010164400.GA19471@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This is a multi-part message in MIME format.
--------------1.5.3.4
Content-Type: text/plain; charset=UTF-8; format=fixed
Content-Transfer-Encoding: 8bit


Add the keysize parameter to "lookup" functions within the core
crypto API.
---
 crypto/algapi.c         |    7 +++--
 crypto/api.c            |   52 ++++++++++++++++++++++++++++++++++------------
 crypto/cbc.c            |    2 +-
 crypto/cryptomgr.c      |    3 +-
 crypto/ecb.c            |    4 +-
 crypto/hmac.c           |    2 +-
 crypto/internal.h       |    7 ++++-
 include/crypto/algapi.h |    9 ++++---
 include/linux/crypto.h  |   17 +++++++++------
 9 files changed, 68 insertions(+), 35 deletions(-)
--------------1.5.3.4
Content-Type: text/x-patch; name="79f86e791e1e63d4bb091a02f04362b587606a1f.diff"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline; filename="79f86e791e1e63d4bb091a02f04362b587606a1f.diff"

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 8ff8c26..c22e086 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -28,7 +28,7 @@ void crypto_larval_error(const char *name, u32 type, u32 mask)
 	struct crypto_alg *alg;
 
 	down_read(&crypto_alg_sem);
-	alg = __crypto_alg_lookup(name, type, mask);
+	alg = __crypto_alg_lookup(name, 0, type, mask);
 	up_read(&crypto_alg_sem);
 
 	if (alg) {
@@ -472,7 +472,8 @@ int crypto_check_attr_type(struct rtattr **tb, u32 type)
 }
 EXPORT_SYMBOL_GPL(crypto_check_attr_type);
 
-struct crypto_alg *crypto_attr_alg(struct rtattr *rta, u32 type, u32 mask)
+struct crypto_alg *crypto_attr_alg(struct rtattr *rta, u32 keysize, u32 type,
+		u32 mask)
 {
 	struct crypto_attr_alg *alga;
 
@@ -486,7 +487,7 @@ struct crypto_alg *crypto_attr_alg(struct rtattr *rta, u32 type, u32 mask)
 	alga = RTA_DATA(rta);
 	alga->name[CRYPTO_MAX_ALG_NAME - 1] = 0;
 
-	return crypto_alg_mod_lookup(alga->name, type, mask);
+	return crypto_alg_mod_lookup(alga->name, keysize, type, mask);
 }
 EXPORT_SYMBOL_GPL(crypto_attr_alg);
 
diff --git a/crypto/api.c b/crypto/api.c
index 75b40ec..ddf8a49 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -55,7 +55,25 @@ void crypto_mod_put(struct crypto_alg *alg)
 }
 EXPORT_SYMBOL_GPL(crypto_mod_put);
 
-struct crypto_alg *__crypto_alg_lookup(const char *name, u32 type, u32 mask)
+static int crypto_check_keysize(struct crypto_alg *q, u32 keysize)
+{
+
+	if ((q->cra_flags & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_CIPHER) {
+		if (q->cra_u.cipher.cia_min_keysize <= keysize &&
+				q->cra_u.cipher.cia_max_keysize >= keysize)
+			return 1;
+
+	} else if ((q->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
+			CRYPTO_ALG_TYPE_BLKCIPHER) {
+		if (q->cra_u.blkcipher.min_keysize <= keysize &&
+				q->cra_u.blkcipher.max_keysize >= keysize)
+			return 1;
+	}
+	return 0;
+}
+
+struct crypto_alg *__crypto_alg_lookup(const char *name, u32 keysize,
+		u32 type, u32 mask)
 {
 	struct crypto_alg *q, *alg = NULL;
 	int best = -2;
@@ -78,6 +96,9 @@ struct crypto_alg *__crypto_alg_lookup(const char *name, u32 type, u32 mask)
 		if (!exact && !(fuzzy && q->cra_priority > best))
 			continue;
 
+		if (keysize && !crypto_check_keysize(q, keysize))
+			continue;
+
 		if (unlikely(!crypto_mod_get(q)))
 			continue;
 
@@ -104,8 +125,8 @@ static void crypto_larval_destroy(struct crypto_alg *alg)
 	kfree(larval);
 }
 
-static struct crypto_alg *crypto_larval_alloc(const char *name, u32 type,
-					      u32 mask)
+static struct crypto_alg *crypto_larval_alloc(const char *name,
+		u32 keysize, u32 type, u32 mask)
 {
 	struct crypto_alg *alg;
 	struct crypto_larval *larval;
@@ -115,6 +136,7 @@ static struct crypto_alg *crypto_larval_alloc(const char *name, u32 type,
 		return ERR_PTR(-ENOMEM);
 
 	larval->mask = mask;
+	larval->keysize = keysize;
 	larval->alg.cra_flags = CRYPTO_ALG_LARVAL | type;
 	larval->alg.cra_priority = -1;
 	larval->alg.cra_destroy = crypto_larval_destroy;
@@ -124,7 +146,7 @@ static struct crypto_alg *crypto_larval_alloc(const char *name, u32 type,
 	init_completion(&larval->completion);
 
 	down_write(&crypto_alg_sem);
-	alg = __crypto_alg_lookup(name, type, mask);
+	alg = __crypto_alg_lookup(name, keysize, type, mask);
 	if (!alg) {
 		alg = &larval->alg;
 		list_add(&alg->cra_list, &crypto_alg_list);
@@ -164,19 +186,20 @@ static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg)
 	return alg;
 }
 
-static struct crypto_alg *crypto_alg_lookup(const char *name, u32 type,
-					    u32 mask)
+static struct crypto_alg *crypto_alg_lookup(const char *name, u32 keysize,
+		u32 type, u32 mask)
 {
 	struct crypto_alg *alg;
 
 	down_read(&crypto_alg_sem);
-	alg = __crypto_alg_lookup(name, type, mask);
+	alg = __crypto_alg_lookup(name, keysize, type, mask);
 	up_read(&crypto_alg_sem);
 
 	return alg;
 }
 
-struct crypto_alg *crypto_alg_mod_lookup(const char *name, u32 type, u32 mask)
+struct crypto_alg *crypto_alg_mod_lookup(const char *name, u32 keysize,
+		u32 type, u32 mask)
 {
 	struct crypto_alg *alg;
 	struct crypto_alg *larval;
@@ -188,12 +211,12 @@ struct crypto_alg *crypto_alg_mod_lookup(const char *name, u32 type, u32 mask)
 	mask &= ~(CRYPTO_ALG_LARVAL | CRYPTO_ALG_DEAD);
 	type &= mask;
 
-	alg = try_then_request_module(crypto_alg_lookup(name, type, mask),
-				      name);
+	alg = try_then_request_module(crypto_alg_lookup(name, keysize, type,
+				mask), name);
 	if (alg)
 		return crypto_is_larval(alg) ? crypto_larval_wait(alg) : alg;
 
-	larval = crypto_larval_alloc(name, type, mask);
+	larval = crypto_larval_alloc(name, keysize, type, mask);
 	if (IS_ERR(larval) || !crypto_is_larval(larval))
 		return larval;
 
@@ -361,7 +384,8 @@ EXPORT_SYMBOL_GPL(__crypto_alloc_tfm);
  *
  *	In case of error the return value is an error pointer.
  */
-struct crypto_tfm *crypto_alloc_base(const char *alg_name, u32 type, u32 mask)
+struct crypto_tfm *crypto_alloc_base(const char *alg_name, u32 keysize,
+		u32 type, u32 mask)
 {
 	struct crypto_tfm *tfm;
 	int err;
@@ -369,7 +393,7 @@ struct crypto_tfm *crypto_alloc_base(const char *alg_name, u32 type, u32 mask)
 	for (;;) {
 		struct crypto_alg *alg;
 
-		alg = crypto_alg_mod_lookup(alg_name, type, mask);
+		alg = crypto_alg_mod_lookup(alg_name, keysize, type, mask);
 		if (IS_ERR(alg)) {
 			err = PTR_ERR(alg);
 			goto err;
@@ -426,7 +450,7 @@ EXPORT_SYMBOL_GPL(crypto_free_tfm);
 int crypto_has_alg(const char *name, u32 type, u32 mask)
 {
 	int ret = 0;
-	struct crypto_alg *alg = crypto_alg_mod_lookup(name, type, mask);
+	struct crypto_alg *alg = crypto_alg_mod_lookup(name, 0, type, mask);
 	
 	if (!IS_ERR(alg)) {
 		crypto_mod_put(alg);
diff --git a/crypto/cbc.c b/crypto/cbc.c
index e8618e9..927b854 100644
--- a/crypto/cbc.c
+++ b/crypto/cbc.c
@@ -293,7 +293,7 @@ static struct crypto_instance *crypto_cbc_alloc(struct rtattr **tb)
 	if (err)
 		return ERR_PTR(err);
 
-	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
+	alg = crypto_get_attr_alg(tb, 0, CRYPTO_ALG_TYPE_CIPHER,
 				  CRYPTO_ALG_TYPE_MASK);
 	if (IS_ERR(alg))
 		return ERR_PTR(PTR_ERR(alg));
diff --git a/crypto/cryptomgr.c b/crypto/cryptomgr.c
index e5e3cf8..af358f6 100644
--- a/crypto/cryptomgr.c
+++ b/crypto/cryptomgr.c
@@ -59,7 +59,7 @@ static int cryptomgr_probe(void *data)
 		goto err;
 
 	do {
-		inst = tmpl->alloc(param->tb);
+		inst = tmpl->alloc(param->tb, param->data.keysize);
 		if (IS_ERR(inst))
 			err = PTR_ERR(inst);
 		else if ((err = crypto_register_instance(tmpl, inst)))
@@ -171,6 +171,7 @@ static int cryptomgr_schedule_probe(struct crypto_larval *larval)
 	param->type.attr.rta_type = CRYPTOA_TYPE;
 	param->type.data.type = larval->alg.cra_flags;
 	param->type.data.mask = larval->mask;
+	param->type.data.keysize = larval->keysize;
 	param->tb[0] = &param->type.attr;
 
 	memcpy(param->larval, larval->alg.cra_name, CRYPTO_MAX_ALG_NAME);
diff --git a/crypto/ecb.c b/crypto/ecb.c
index 6310387..5bfbedf 100644
--- a/crypto/ecb.c
+++ b/crypto/ecb.c
@@ -115,7 +115,7 @@ static void crypto_ecb_exit_tfm(struct crypto_tfm *tfm)
 	crypto_free_cipher(ctx->child);
 }
 
-static struct crypto_instance *crypto_ecb_alloc(struct rtattr **tb)
+static struct crypto_instance *crypto_ecb_alloc(struct rtattr **tb, u32 keysize)
 {
 	struct crypto_instance *inst;
 	struct crypto_alg *alg;
@@ -125,7 +125,7 @@ static struct crypto_instance *crypto_ecb_alloc(struct rtattr **tb)
 	if (err)
 		return ERR_PTR(err);
 
-	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
+	alg = crypto_get_attr_alg(tb, keysize, CRYPTO_ALG_TYPE_CIPHER,
 				  CRYPTO_ALG_TYPE_MASK);
 	if (IS_ERR(alg))
 		return ERR_PTR(PTR_ERR(alg));
diff --git a/crypto/hmac.c b/crypto/hmac.c
index 8802fb6..2a6e82a 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -207,7 +207,7 @@ static struct crypto_instance *hmac_alloc(struct rtattr **tb)
 	if (err)
 		return ERR_PTR(err);
 
-	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_HASH,
+	alg = crypto_get_attr_alg(tb, 0, CRYPTO_ALG_TYPE_HASH,
 				  CRYPTO_ALG_TYPE_HASH_MASK);
 	if (IS_ERR(alg))
 		return ERR_PTR(PTR_ERR(alg));
diff --git a/crypto/internal.h b/crypto/internal.h
index abb01f7..58d1999 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -44,6 +44,7 @@ struct crypto_larval {
 	struct crypto_alg *adult;
 	struct completion completion;
 	u32 mask;
+	u32 keysize;
 };
 
 extern struct list_head crypto_alg_list;
@@ -111,8 +112,10 @@ static inline unsigned int crypto_compress_ctxsize(struct crypto_alg *alg)
 }
 
 struct crypto_alg *crypto_mod_get(struct crypto_alg *alg);
-struct crypto_alg *__crypto_alg_lookup(const char *name, u32 type, u32 mask);
-struct crypto_alg *crypto_alg_mod_lookup(const char *name, u32 type, u32 mask);
+struct crypto_alg *__crypto_alg_lookup(const char *name, u32 keysize, u32 type,
+		u32 mask);
+struct crypto_alg *crypto_alg_mod_lookup(const char *name, u32 keysize,
+		u32 type, u32 mask);
 
 int crypto_init_digest_ops(struct crypto_tfm *tfm);
 int crypto_init_cipher_ops(struct crypto_tfm *tfm);
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index b9b05d3..cdeb92d 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -41,7 +41,7 @@ struct crypto_template {
 	struct hlist_head instances;
 	struct module *module;
 
-	struct crypto_instance *(*alloc)(struct rtattr **tb);
+	struct crypto_instance *(*alloc)(struct rtattr **tb, u32 keysize);
 	void (*free)(struct crypto_instance *inst);
 
 	char name[CRYPTO_MAX_ALG_NAME];
@@ -113,7 +113,8 @@ struct crypto_tfm *crypto_spawn_tfm(struct crypto_spawn *spawn, u32 type,
 
 struct crypto_attr_type *crypto_get_attr_type(struct rtattr **tb);
 int crypto_check_attr_type(struct rtattr **tb, u32 type);
-struct crypto_alg *crypto_attr_alg(struct rtattr *rta, u32 type, u32 mask);
+struct crypto_alg *crypto_attr_alg(struct rtattr *rta, u32 keysize, u32 type,
+		u32 mask);
 int crypto_attr_u32(struct rtattr *rta, u32 *num);
 struct crypto_instance *crypto_alloc_instance(const char *name,
 					      struct crypto_alg *alg);
@@ -298,9 +299,9 @@ static inline u32 aead_request_flags(struct aead_request *req)
 }
 
 static inline struct crypto_alg *crypto_get_attr_alg(struct rtattr **tb,
-						     u32 type, u32 mask)
+		u32 keysize, u32 type, u32 mask)
 {
-	return crypto_attr_alg(tb[1], type, mask);
+	return crypto_attr_alg(tb[1], keysize, type, mask);
 }
 
 #endif	/* _CRYPTO_ALGAPI_H */
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 8f9dd29..bbc15d0 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -444,6 +444,7 @@ struct crypto_attr_alg {
 struct crypto_attr_type {
 	u32 type;
 	u32 mask;
+	u32 keysize;
 };
 
 struct crypto_attr_u32 {
@@ -455,7 +456,8 @@ struct crypto_attr_u32 {
  */
  
 struct crypto_tfm *crypto_alloc_tfm(const char *alg_name, u32 tfm_flags);
-struct crypto_tfm *crypto_alloc_base(const char *alg_name, u32 type, u32 mask);
+struct crypto_tfm *crypto_alloc_base(const char *alg_name, u32 keysize,
+		u32 type, u32 mask);
 void crypto_free_tfm(struct crypto_tfm *tfm);
 
 /*
@@ -539,7 +541,7 @@ static inline struct crypto_ablkcipher *crypto_alloc_ablkcipher(
 	mask |= CRYPTO_ALG_TYPE_MASK;
 
 	return __crypto_ablkcipher_cast(
-		crypto_alloc_base(alg_name, type, mask));
+		crypto_alloc_base(alg_name, 0, type, mask));
 }
 
 static inline struct crypto_tfm *crypto_ablkcipher_tfm(
@@ -706,7 +708,7 @@ static inline struct crypto_aead *crypto_alloc_aead(const char *alg_name,
 	type |= CRYPTO_ALG_TYPE_AEAD;
 	mask |= CRYPTO_ALG_TYPE_MASK;
 
-	return __crypto_aead_cast(crypto_alloc_base(alg_name, type, mask));
+	return __crypto_aead_cast(crypto_alloc_base(alg_name, 0, type, mask));
 }
 
 static inline struct crypto_tfm *crypto_aead_tfm(struct crypto_aead *tfm)
@@ -864,7 +866,8 @@ static inline struct crypto_blkcipher *crypto_alloc_blkcipher(
 	type |= CRYPTO_ALG_TYPE_BLKCIPHER;
 	mask |= CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_ASYNC;
 
-	return __crypto_blkcipher_cast(crypto_alloc_base(alg_name, type, mask));
+	return __crypto_blkcipher_cast(crypto_alloc_base(alg_name, 0, type,
+				mask));
 }
 
 static inline struct crypto_tfm *crypto_blkcipher_tfm(
@@ -1016,7 +1019,7 @@ static inline struct crypto_cipher *crypto_alloc_cipher(const char *alg_name,
 	type |= CRYPTO_ALG_TYPE_CIPHER;
 	mask |= CRYPTO_ALG_TYPE_MASK;
 
-	return __crypto_cipher_cast(crypto_alloc_base(alg_name, type, mask));
+	return __crypto_cipher_cast(crypto_alloc_base(alg_name, 0, type, mask));
 }
 
 static inline struct crypto_tfm *crypto_cipher_tfm(struct crypto_cipher *tfm)
@@ -1110,7 +1113,7 @@ static inline struct crypto_hash *crypto_alloc_hash(const char *alg_name,
 	type |= CRYPTO_ALG_TYPE_HASH;
 	mask |= CRYPTO_ALG_TYPE_HASH_MASK;
 
-	return __crypto_hash_cast(crypto_alloc_base(alg_name, type, mask));
+	return __crypto_hash_cast(crypto_alloc_base(alg_name, 0, type, mask));
 }
 
 static inline struct crypto_tfm *crypto_hash_tfm(struct crypto_hash *tfm)
@@ -1216,7 +1219,7 @@ static inline struct crypto_comp *crypto_alloc_comp(const char *alg_name,
 	type |= CRYPTO_ALG_TYPE_COMPRESS;
 	mask |= CRYPTO_ALG_TYPE_MASK;
 
-	return __crypto_comp_cast(crypto_alloc_base(alg_name, type, mask));
+	return __crypto_comp_cast(crypto_alloc_base(alg_name, 0, type, mask));
 }
 
 static inline struct crypto_tfm *crypto_comp_tfm(struct crypto_comp *tfm)

--------------1.5.3.4--
