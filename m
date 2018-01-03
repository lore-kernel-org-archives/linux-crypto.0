From: Eric Biggers <ebiggers3@gmail.com>
Subject: [RFC PATCH 8/9] crypto: skcipher - prevent using skciphers without setting key
Date: Wed,  3 Jan 2018 11:16:29 -0800
Message-ID: <20180103191630.79917-9-ebiggers3@gmail.com>
References: <20180103191630.79917-1-ebiggers3@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:36161 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750989AbeACTSc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jan 2018 14:18:32 -0500
Received: by mail-io0-f196.google.com with SMTP id i143so3166506ioa.3
        for <linux-crypto@vger.kernel.org>; Wed, 03 Jan 2018 11:18:32 -0800 (PST)
In-Reply-To: <20180103191630.79917-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Similar to what was done for the hash API, update the skcipher API to
track whether each transform has been keyed, and reject
encryption/decryption if a key is needed but one hasn't been set.

This isn't as important as the equivalent fix for the hash API because
symmetric ciphers almost always require a key (the "null cipher" is the
only exception), so are unlikely to be used without one.  Still,
tracking the key will prevent accidental unkeyed use.  algif_skcipher
also had to track the key anyway, so the new flag replaces that and
simplifies the algif_skcipher implementation.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/algif_skcipher.c   | 59 +++++++++++------------------------------------
 crypto/skcipher.c         | 30 ++++++++++++++++++++----
 include/crypto/skcipher.h | 11 +++++----
 3 files changed, 45 insertions(+), 55 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index c5c47b680152..c88e5e4cd6a6 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -38,11 +38,6 @@
 #include <linux/net.h>
 #include <net/sock.h>
 
-struct skcipher_tfm {
-	struct crypto_skcipher *skcipher;
-	bool has_key;
-};
-
 static int skcipher_sendmsg(struct socket *sock, struct msghdr *msg,
 			    size_t size)
 {
@@ -50,8 +45,7 @@ static int skcipher_sendmsg(struct socket *sock, struct msghdr *msg,
 	struct alg_sock *ask = alg_sk(sk);
 	struct sock *psk = ask->parent;
 	struct alg_sock *pask = alg_sk(psk);
-	struct skcipher_tfm *skc = pask->private;
-	struct crypto_skcipher *tfm = skc->skcipher;
+	struct crypto_skcipher *tfm = pask->private;
 	unsigned ivsize = crypto_skcipher_ivsize(tfm);
 
 	return af_alg_sendmsg(sock, msg, size, ivsize);
@@ -65,8 +59,7 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	struct sock *psk = ask->parent;
 	struct alg_sock *pask = alg_sk(psk);
 	struct af_alg_ctx *ctx = ask->private;
-	struct skcipher_tfm *skc = pask->private;
-	struct crypto_skcipher *tfm = skc->skcipher;
+	struct crypto_skcipher *tfm = pask->private;
 	unsigned int bs = crypto_skcipher_blocksize(tfm);
 	struct af_alg_async_req *areq;
 	int err = 0;
@@ -221,7 +214,7 @@ static int skcipher_check_key(struct socket *sock)
 	int err = 0;
 	struct sock *psk;
 	struct alg_sock *pask;
-	struct skcipher_tfm *tfm;
+	struct crypto_skcipher *tfm;
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
 
@@ -235,7 +228,7 @@ static int skcipher_check_key(struct socket *sock)
 
 	err = -ENOKEY;
 	lock_sock_nested(psk, SINGLE_DEPTH_NESTING);
-	if (!tfm->has_key)
+	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		goto unlock;
 
 	if (!pask->refcnt++)
@@ -314,41 +307,17 @@ static struct proto_ops algif_skcipher_ops_nokey = {
 
 static void *skcipher_bind(const char *name, u32 type, u32 mask)
 {
-	struct skcipher_tfm *tfm;
-	struct crypto_skcipher *skcipher;
-
-	tfm = kzalloc(sizeof(*tfm), GFP_KERNEL);
-	if (!tfm)
-		return ERR_PTR(-ENOMEM);
-
-	skcipher = crypto_alloc_skcipher(name, type, mask);
-	if (IS_ERR(skcipher)) {
-		kfree(tfm);
-		return ERR_CAST(skcipher);
-	}
-
-	tfm->skcipher = skcipher;
-
-	return tfm;
+	return crypto_alloc_skcipher(name, type, mask);
 }
 
 static void skcipher_release(void *private)
 {
-	struct skcipher_tfm *tfm = private;
-
-	crypto_free_skcipher(tfm->skcipher);
-	kfree(tfm);
+	crypto_free_skcipher(private);
 }
 
 static int skcipher_setkey(void *private, const u8 *key, unsigned int keylen)
 {
-	struct skcipher_tfm *tfm = private;
-	int err;
-
-	err = crypto_skcipher_setkey(tfm->skcipher, key, keylen);
-	tfm->has_key = !err;
-
-	return err;
+	return crypto_skcipher_setkey(private, key, keylen);
 }
 
 static void skcipher_sock_destruct(struct sock *sk)
@@ -357,8 +326,7 @@ static void skcipher_sock_destruct(struct sock *sk)
 	struct af_alg_ctx *ctx = ask->private;
 	struct sock *psk = ask->parent;
 	struct alg_sock *pask = alg_sk(psk);
-	struct skcipher_tfm *skc = pask->private;
-	struct crypto_skcipher *tfm = skc->skcipher;
+	struct crypto_skcipher *tfm = pask->private;
 
 	af_alg_pull_tsgl(sk, ctx->used, NULL, 0);
 	sock_kzfree_s(sk, ctx->iv, crypto_skcipher_ivsize(tfm));
@@ -370,22 +338,21 @@ static int skcipher_accept_parent_nokey(void *private, struct sock *sk)
 {
 	struct af_alg_ctx *ctx;
 	struct alg_sock *ask = alg_sk(sk);
-	struct skcipher_tfm *tfm = private;
-	struct crypto_skcipher *skcipher = tfm->skcipher;
+	struct crypto_skcipher *tfm = private;
 	unsigned int len = sizeof(*ctx);
 
 	ctx = sock_kmalloc(sk, len, GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
 
-	ctx->iv = sock_kmalloc(sk, crypto_skcipher_ivsize(skcipher),
+	ctx->iv = sock_kmalloc(sk, crypto_skcipher_ivsize(tfm),
 			       GFP_KERNEL);
 	if (!ctx->iv) {
 		sock_kfree_s(sk, ctx, len);
 		return -ENOMEM;
 	}
 
-	memset(ctx->iv, 0, crypto_skcipher_ivsize(skcipher));
+	memset(ctx->iv, 0, crypto_skcipher_ivsize(tfm));
 
 	INIT_LIST_HEAD(&ctx->tsgl_list);
 	ctx->len = len;
@@ -405,9 +372,9 @@ static int skcipher_accept_parent_nokey(void *private, struct sock *sk)
 
 static int skcipher_accept_parent(void *private, struct sock *sk)
 {
-	struct skcipher_tfm *tfm = private;
+	struct crypto_skcipher *tfm = private;
 
-	if (!tfm->has_key && crypto_skcipher_has_setkey(tfm->skcipher))
+	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		return -ENOKEY;
 
 	return skcipher_accept_parent_nokey(private, sk);
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 11af5fd6a443..0fe2a2923ad0 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -598,8 +598,11 @@ static int skcipher_setkey_blkcipher(struct crypto_skcipher *tfm,
 	err = crypto_blkcipher_setkey(blkcipher, key, keylen);
 	crypto_skcipher_set_flags(tfm, crypto_blkcipher_get_flags(blkcipher) &
 				       CRYPTO_TFM_RES_MASK);
+	if (err)
+		return err;
 
-	return err;
+	crypto_skcipher_clear_flags(tfm, CRYPTO_TFM_NEED_KEY);
+	return 0;
 }
 
 static int skcipher_crypt_blkcipher(struct skcipher_request *req,
@@ -674,6 +677,9 @@ static int crypto_init_skcipher_ops_blkcipher(struct crypto_tfm *tfm)
 	skcipher->ivsize = crypto_blkcipher_ivsize(blkcipher);
 	skcipher->keysize = calg->cra_blkcipher.max_keysize;
 
+	if (skcipher->keysize)
+		crypto_skcipher_set_flags(skcipher, CRYPTO_TFM_NEED_KEY);
+
 	return 0;
 }
 
@@ -692,8 +698,11 @@ static int skcipher_setkey_ablkcipher(struct crypto_skcipher *tfm,
 	crypto_skcipher_set_flags(tfm,
 				  crypto_ablkcipher_get_flags(ablkcipher) &
 				  CRYPTO_TFM_RES_MASK);
+	if (err)
+		return err;
 
-	return err;
+	crypto_skcipher_clear_flags(tfm, CRYPTO_TFM_NEED_KEY);
+	return 0;
 }
 
 static int skcipher_crypt_ablkcipher(struct skcipher_request *req,
@@ -767,6 +776,9 @@ static int crypto_init_skcipher_ops_ablkcipher(struct crypto_tfm *tfm)
 			    sizeof(struct ablkcipher_request);
 	skcipher->keysize = calg->cra_ablkcipher.max_keysize;
 
+	if (skcipher->keysize)
+		crypto_skcipher_set_flags(skcipher, CRYPTO_TFM_NEED_KEY);
+
 	return 0;
 }
 
@@ -796,6 +808,7 @@ static int skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 {
 	struct skcipher_alg *cipher = crypto_skcipher_alg(tfm);
 	unsigned long alignmask = crypto_skcipher_alignmask(tfm);
+	int err;
 
 	if (keylen < cipher->min_keysize || keylen > cipher->max_keysize) {
 		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
@@ -803,9 +816,15 @@ static int skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	}
 
 	if ((unsigned long)key & alignmask)
-		return skcipher_setkey_unaligned(tfm, key, keylen);
+		err = skcipher_setkey_unaligned(tfm, key, keylen);
+	else
+		err = cipher->setkey(tfm, key, keylen);
+
+	if (err)
+		return err;
 
-	return cipher->setkey(tfm, key, keylen);
+	crypto_skcipher_clear_flags(tfm, CRYPTO_TFM_NEED_KEY);
+	return 0;
 }
 
 static void crypto_skcipher_exit_tfm(struct crypto_tfm *tfm)
@@ -834,6 +853,9 @@ static int crypto_skcipher_init_tfm(struct crypto_tfm *tfm)
 	skcipher->ivsize = alg->ivsize;
 	skcipher->keysize = alg->max_keysize;
 
+	if (skcipher->keysize)
+		crypto_skcipher_set_flags(skcipher, CRYPTO_TFM_NEED_KEY);
+
 	if (alg->exit)
 		skcipher->base.exit = crypto_skcipher_exit_tfm;
 
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 562001cb412b..2f327f090c3e 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -401,11 +401,6 @@ static inline int crypto_skcipher_setkey(struct crypto_skcipher *tfm,
 	return tfm->setkey(tfm, key, keylen);
 }
 
-static inline bool crypto_skcipher_has_setkey(struct crypto_skcipher *tfm)
-{
-	return tfm->keysize;
-}
-
 static inline unsigned int crypto_skcipher_default_keysize(
 	struct crypto_skcipher *tfm)
 {
@@ -442,6 +437,9 @@ static inline int crypto_skcipher_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 
+	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
+		return -ENOKEY;
+
 	return tfm->encrypt(req);
 }
 
@@ -460,6 +458,9 @@ static inline int crypto_skcipher_decrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 
+	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
+		return -ENOKEY;
+
 	return tfm->decrypt(req);
 }
 
-- 
2.15.1.620.gb9897f4670-goog
