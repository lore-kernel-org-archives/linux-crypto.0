From: Eric Biggers <ebiggers3@gmail.com>
Subject: [RFC PATCH 9/9] crypto: aead - prevent using AEADs without setting key
Date: Wed,  3 Jan 2018 11:16:30 -0800
Message-ID: <20180103191630.79917-10-ebiggers3@gmail.com>
References: <20180103191630.79917-1-ebiggers3@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:33794 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750819AbeACTSd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jan 2018 14:18:33 -0500
Received: by mail-io0-f194.google.com with SMTP id q188so3162586iod.1
        for <linux-crypto@vger.kernel.org>; Wed, 03 Jan 2018 11:18:33 -0800 (PST)
In-Reply-To: <20180103191630.79917-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Similar to what was done for the hash API, update the AEAD API to track
whether each transform has been keyed, and reject encryption/decryption
if a key is needed but one hasn't been set.

This isn't quite as important as the equivalent fix for the hash API
because AEADs always require a key, so are unlikely to be used without
one.  Still, tracking the key will prevent accidental unkeyed use.
algif_aead also had to track the key anyway, so the new flag replaces
that and slightly simplifies the algif_aead implementation.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/aead.c         | 13 +++++++++++--
 crypto/algif_aead.c   | 11 +++--------
 include/crypto/aead.h | 10 +++++++++-
 3 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index fe00cbd7243d..60b3bbe973e7 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -54,11 +54,18 @@ int crypto_aead_setkey(struct crypto_aead *tfm,
 		       const u8 *key, unsigned int keylen)
 {
 	unsigned long alignmask = crypto_aead_alignmask(tfm);
+	int err;
 
 	if ((unsigned long)key & alignmask)
-		return setkey_unaligned(tfm, key, keylen);
+		err = setkey_unaligned(tfm, key, keylen);
+	else
+		err = crypto_aead_alg(tfm)->setkey(tfm, key, keylen);
+
+	if (err)
+		return err;
 
-	return crypto_aead_alg(tfm)->setkey(tfm, key, keylen);
+	crypto_aead_clear_flags(tfm, CRYPTO_TFM_NEED_KEY);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(crypto_aead_setkey);
 
@@ -93,6 +100,8 @@ static int crypto_aead_init_tfm(struct crypto_tfm *tfm)
 	struct crypto_aead *aead = __crypto_aead_cast(tfm);
 	struct aead_alg *alg = crypto_aead_alg(aead);
 
+	crypto_aead_set_flags(aead, CRYPTO_TFM_NEED_KEY);
+
 	aead->authsize = alg->maxauthsize;
 
 	if (alg->exit)
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index d963c8cf8a55..4b07edd5a9ff 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -42,7 +42,6 @@
 
 struct aead_tfm {
 	struct crypto_aead *aead;
-	bool has_key;
 	struct crypto_skcipher *null_tfm;
 };
 
@@ -398,7 +397,7 @@ static int aead_check_key(struct socket *sock)
 
 	err = -ENOKEY;
 	lock_sock_nested(psk, SINGLE_DEPTH_NESTING);
-	if (!tfm->has_key)
+	if (crypto_aead_get_flags(tfm->aead) & CRYPTO_TFM_NEED_KEY)
 		goto unlock;
 
 	if (!pask->refcnt++)
@@ -523,12 +522,8 @@ static int aead_setauthsize(void *private, unsigned int authsize)
 static int aead_setkey(void *private, const u8 *key, unsigned int keylen)
 {
 	struct aead_tfm *tfm = private;
-	int err;
-
-	err = crypto_aead_setkey(tfm->aead, key, keylen);
-	tfm->has_key = !err;
 
-	return err;
+	return crypto_aead_setkey(tfm->aead, key, keylen);
 }
 
 static void aead_sock_destruct(struct sock *sk)
@@ -589,7 +584,7 @@ static int aead_accept_parent(void *private, struct sock *sk)
 {
 	struct aead_tfm *tfm = private;
 
-	if (!tfm->has_key)
+	if (crypto_aead_get_flags(tfm->aead) & CRYPTO_TFM_NEED_KEY)
 		return -ENOKEY;
 
 	return aead_accept_parent_nokey(private, sk);
diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index 03b97629442c..1e26f790b03f 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -327,7 +327,12 @@ static inline struct crypto_aead *crypto_aead_reqtfm(struct aead_request *req)
  */
 static inline int crypto_aead_encrypt(struct aead_request *req)
 {
-	return crypto_aead_alg(crypto_aead_reqtfm(req))->encrypt(req);
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+
+	if (crypto_aead_get_flags(aead) & CRYPTO_TFM_NEED_KEY)
+		return -ENOKEY;
+
+	return crypto_aead_alg(aead)->encrypt(req);
 }
 
 /**
@@ -356,6 +361,9 @@ static inline int crypto_aead_decrypt(struct aead_request *req)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 
+	if (crypto_aead_get_flags(aead) & CRYPTO_TFM_NEED_KEY)
+		return -ENOKEY;
+
 	if (req->cryptlen < crypto_aead_authsize(aead))
 		return -EINVAL;
 
-- 
2.15.1.620.gb9897f4670-goog
