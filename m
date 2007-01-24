From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/6] [CRYPTO] api: Add type-safe spawns
Date: Wed, 24 Jan 2007 21:29:18 +1100
Message-ID: <E1H9fNW-0005n6-00@gondolin.me.apana.org.au>
References: <20070124102736.GA21977@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2901 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751020AbXAXK3V (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Jan 2007 05:29:21 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1H9fNX-0005wh-1I
	for <linux-crypto@vger.kernel.org>; Wed, 24 Jan 2007 21:29:19 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1H9fNW-0005n6-00
	for <linux-crypto@vger.kernel.org>; Wed, 24 Jan 2007 21:29:18 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] api: Add type-safe spawns

This patch allows spawns of specific types (e.g., cipher) to be allocated.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/algapi.c         |   13 +++++++++++--
 crypto/cbc.c            |    9 +++++----
 crypto/ecb.c            |    9 +++++----
 crypto/hmac.c           |    9 +++++----
 crypto/lrw.c            |   11 ++++++-----
 crypto/pcbc.c           |    9 +++++----
 crypto/xcbc.c           |    9 +++++----
 include/crypto/algapi.h |   20 +++++++++++++++++++-
 8 files changed, 61 insertions(+), 28 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -377,7 +377,8 @@ void crypto_drop_spawn(struct crypto_spa
 }
 EXPORT_SYMBOL_GPL(crypto_drop_spawn);
 
-struct crypto_tfm *crypto_spawn_tfm(struct crypto_spawn *spawn)
+struct crypto_tfm *crypto_spawn_tfm(struct crypto_spawn *spawn, u32 type,
+				    u32 mask)
 {
 	struct crypto_alg *alg;
 	struct crypto_alg *alg2;
@@ -396,10 +397,18 @@ struct crypto_tfm *crypto_spawn_tfm(stru
 		return ERR_PTR(-EAGAIN);
 	}
 
+	tfm = ERR_PTR(-EINVAL);
+	if (unlikely((alg->cra_flags ^ type) & mask))
+		goto out_put_alg;
+
 	tfm = __crypto_alloc_tfm(alg);
 	if (IS_ERR(tfm))
-		crypto_mod_put(alg);
+		goto out_put_alg;
+
+	return tfm;
 
+out_put_alg:
+	crypto_mod_put(alg);
 	return tfm;
 }
 EXPORT_SYMBOL_GPL(crypto_spawn_tfm);
diff --git a/crypto/cbc.c b/crypto/cbc.c
--- a/crypto/cbc.c
+++ b/crypto/cbc.c
@@ -243,6 +243,7 @@ static int crypto_cbc_init_tfm(struct cr
 	struct crypto_instance *inst = (void *)tfm->__crt_alg;
 	struct crypto_spawn *spawn = crypto_instance_ctx(inst);
 	struct crypto_cbc_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_cipher *cipher;
 
 	switch (crypto_tfm_alg_blocksize(tfm)) {
 	case 8:
@@ -260,11 +261,11 @@ static int crypto_cbc_init_tfm(struct cr
 			ctx->xor = xor_quad;
 	}
 
-	tfm = crypto_spawn_tfm(spawn);
-	if (IS_ERR(tfm))
-		return PTR_ERR(tfm);
+	cipher = crypto_spawn_cipher(spawn);
+	if (IS_ERR(cipher))
+		return PTR_ERR(cipher);
 
-	ctx->child = crypto_cipher_cast(tfm);
+	ctx->child = cipher;
 	return 0;
 }
 
diff --git a/crypto/ecb.c b/crypto/ecb.c
--- a/crypto/ecb.c
+++ b/crypto/ecb.c
@@ -99,12 +99,13 @@ static int crypto_ecb_init_tfm(struct cr
 	struct crypto_instance *inst = (void *)tfm->__crt_alg;
 	struct crypto_spawn *spawn = crypto_instance_ctx(inst);
 	struct crypto_ecb_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_cipher *cipher;
 
-	tfm = crypto_spawn_tfm(spawn);
-	if (IS_ERR(tfm))
-		return PTR_ERR(tfm);
+	cipher = crypto_spawn_cipher(spawn);
+	if (IS_ERR(cipher))
+		return PTR_ERR(cipher);
 
-	ctx->child = crypto_cipher_cast(tfm);
+	ctx->child = cipher;
 	return 0;
 }
 
diff --git a/crypto/hmac.c b/crypto/hmac.c
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -172,15 +172,16 @@ static int hmac_digest(struct hash_desc 
 
 static int hmac_init_tfm(struct crypto_tfm *tfm)
 {
+	struct crypto_hash *hash;
 	struct crypto_instance *inst = (void *)tfm->__crt_alg;
 	struct crypto_spawn *spawn = crypto_instance_ctx(inst);
 	struct hmac_ctx *ctx = hmac_ctx(__crypto_hash_cast(tfm));
 
-	tfm = crypto_spawn_tfm(spawn);
-	if (IS_ERR(tfm))
-		return PTR_ERR(tfm);
+	hash = crypto_spawn_hash(spawn);
+	if (IS_ERR(hash))
+		return PTR_ERR(hash);
 
-	ctx->child = crypto_hash_cast(tfm);
+	ctx->child = hash;
 	return 0;
 }
 
diff --git a/crypto/lrw.c b/crypto/lrw.c
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -201,21 +201,22 @@ static int decrypt(struct blkcipher_desc
 
 static int init_tfm(struct crypto_tfm *tfm)
 {
+	struct crypto_cipher *cipher;
 	struct crypto_instance *inst = (void *)tfm->__crt_alg;
 	struct crypto_spawn *spawn = crypto_instance_ctx(inst);
 	struct priv *ctx = crypto_tfm_ctx(tfm);
 	u32 *flags = &tfm->crt_flags;
 
-	tfm = crypto_spawn_tfm(spawn);
-	if (IS_ERR(tfm))
-		return PTR_ERR(tfm);
+	cipher = crypto_spawn_cipher(spawn);
+	if (IS_ERR(cipher))
+		return PTR_ERR(cipher);
 
-	if (crypto_tfm_alg_blocksize(tfm) != 16) {
+	if (crypto_cipher_blocksize(cipher) != 16) {
 		*flags |= CRYPTO_TFM_RES_BAD_BLOCK_LEN;
 		return -EINVAL;
 	}
 
-	ctx->child = crypto_cipher_cast(tfm);
+	ctx->child = cipher;
 	return 0;
 }
 
diff --git a/crypto/pcbc.c b/crypto/pcbc.c
--- a/crypto/pcbc.c
+++ b/crypto/pcbc.c
@@ -247,6 +247,7 @@ static int crypto_pcbc_init_tfm(struct c
 	struct crypto_instance *inst = (void *)tfm->__crt_alg;
 	struct crypto_spawn *spawn = crypto_instance_ctx(inst);
 	struct crypto_pcbc_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_cipher *cipher;
 
 	switch (crypto_tfm_alg_blocksize(tfm)) {
 	case 8:
@@ -264,11 +265,11 @@ static int crypto_pcbc_init_tfm(struct c
 			ctx->xor = xor_quad;
 	}
 
-	tfm = crypto_spawn_tfm(spawn);
-	if (IS_ERR(tfm))
-		return PTR_ERR(tfm);
+	cipher = crypto_spawn_cipher(spawn);
+	if (IS_ERR(cipher))
+		return PTR_ERR(cipher);
 
-	ctx->child = crypto_cipher_cast(tfm);
+	ctx->child = cipher;
 	return 0;
 }
 
diff --git a/crypto/xcbc.c b/crypto/xcbc.c
--- a/crypto/xcbc.c
+++ b/crypto/xcbc.c
@@ -254,14 +254,15 @@ static int crypto_xcbc_digest(struct has
 
 static int xcbc_init_tfm(struct crypto_tfm *tfm)
 {
+	struct crypto_cipher *cipher;
 	struct crypto_instance *inst = (void *)tfm->__crt_alg;
 	struct crypto_spawn *spawn = crypto_instance_ctx(inst);
 	struct crypto_xcbc_ctx *ctx = crypto_hash_ctx_aligned(__crypto_hash_cast(tfm));
 	int bs = crypto_hash_blocksize(__crypto_hash_cast(tfm));
 
-	tfm = crypto_spawn_tfm(spawn);
-	if (IS_ERR(tfm))
-		return PTR_ERR(tfm);
+	cipher = crypto_spawn_cipher(spawn);
+	if (IS_ERR(cipher))
+		return PTR_ERR(cipher);
 
 	switch(bs) {
 	case 16:
@@ -271,7 +272,7 @@ static int xcbc_init_tfm(struct crypto_t
 		return -EINVAL;
 	}
 
-	ctx->child = crypto_cipher_cast(tfm);
+	ctx->child = cipher;
 	ctx->odds = (u8*)(ctx+1);
 	ctx->prev = ctx->odds + bs;
 	ctx->key = ctx->prev + bs;
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -93,7 +93,8 @@ struct crypto_template *crypto_lookup_te
 int crypto_init_spawn(struct crypto_spawn *spawn, struct crypto_alg *alg,
 		      struct crypto_instance *inst);
 void crypto_drop_spawn(struct crypto_spawn *spawn);
-struct crypto_tfm *crypto_spawn_tfm(struct crypto_spawn *spawn);
+struct crypto_tfm *crypto_spawn_tfm(struct crypto_spawn *spawn, u32 type,
+				    u32 mask);
 
 struct crypto_alg *crypto_get_attr_alg(void *param, unsigned int len,
 				       u32 type, u32 mask);
@@ -132,11 +133,28 @@ static inline void *crypto_blkcipher_ctx
 	return crypto_tfm_ctx_aligned(&tfm->base);
 }
 
+static inline struct crypto_cipher *crypto_spawn_cipher(
+	struct crypto_spawn *spawn)
+{
+	u32 type = CRYPTO_ALG_TYPE_CIPHER;
+	u32 mask = CRYPTO_ALG_TYPE_MASK;
+
+	return __crypto_cipher_cast(crypto_spawn_tfm(spawn, type, mask));
+}
+
 static inline struct cipher_alg *crypto_cipher_alg(struct crypto_cipher *tfm)
 {
 	return &crypto_cipher_tfm(tfm)->__crt_alg->cra_cipher;
 }
 
+static inline struct crypto_hash *crypto_spawn_hash(struct crypto_spawn *spawn)
+{
+	u32 type = CRYPTO_ALG_TYPE_HASH;
+	u32 mask = CRYPTO_ALG_TYPE_HASH_MASK;
+
+	return __crypto_hash_cast(crypto_spawn_tfm(spawn, type, mask));
+}
+
 static inline void *crypto_hash_ctx_aligned(struct crypto_hash *tfm)
 {
 	return crypto_tfm_ctx_aligned(&tfm->base);
