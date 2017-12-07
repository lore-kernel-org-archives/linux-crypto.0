From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] crypto: null - Get rid of crypto_{get,put}_default_null_skcipher2()
Date: Thu,  7 Dec 2017 10:56:34 -0800
Message-ID: <20171207185634.17283-1-ebiggers3@gmail.com>
Cc: Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:41210 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750922AbdLGS4k (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Dec 2017 13:56:40 -0500
Received: by mail-it0-f67.google.com with SMTP id x28so17192641ita.0
        for <linux-crypto@vger.kernel.org>; Thu, 07 Dec 2017 10:56:39 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Since commit 499a66e6b689 ("crypto: null - Remove default null
blkcipher"), crypto_get_default_null_skcipher2() and
crypto_put_default_null_skcipher2() are the same as their non-2
equivalents.  So switch callers of the "2" versions over to the original
versions and remove the "2" versions.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/aead.c         |  6 +++---
 crypto/algif_aead.c   |  4 ++--
 crypto/authenc.c      |  4 ++--
 crypto/authencesn.c   |  4 ++--
 crypto/gcm.c          |  4 ++--
 include/crypto/null.h | 10 ----------
 6 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index f794b30a9407..fe00cbd7243d 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -295,7 +295,7 @@ int aead_init_geniv(struct crypto_aead *aead)
 	if (err)
 		goto out;
 
-	ctx->sknull = crypto_get_default_null_skcipher2();
+	ctx->sknull = crypto_get_default_null_skcipher();
 	err = PTR_ERR(ctx->sknull);
 	if (IS_ERR(ctx->sknull))
 		goto out;
@@ -315,7 +315,7 @@ int aead_init_geniv(struct crypto_aead *aead)
 	return err;
 
 drop_null:
-	crypto_put_default_null_skcipher2();
+	crypto_put_default_null_skcipher();
 	goto out;
 }
 EXPORT_SYMBOL_GPL(aead_init_geniv);
@@ -325,7 +325,7 @@ void aead_exit_geniv(struct crypto_aead *tfm)
 	struct aead_geniv_ctx *ctx = crypto_aead_ctx(tfm);
 
 	crypto_free_aead(ctx->child);
-	crypto_put_default_null_skcipher2();
+	crypto_put_default_null_skcipher();
 }
 EXPORT_SYMBOL_GPL(aead_exit_geniv);
 
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 48b34e9c6834..1078061c49a2 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -485,7 +485,7 @@ static void *aead_bind(const char *name, u32 type, u32 mask)
 		return ERR_CAST(aead);
 	}
 
-	null_tfm = crypto_get_default_null_skcipher2();
+	null_tfm = crypto_get_default_null_skcipher();
 	if (IS_ERR(null_tfm)) {
 		crypto_free_aead(aead);
 		kfree(tfm);
@@ -503,7 +503,7 @@ static void aead_release(void *private)
 	struct aead_tfm *tfm = private;
 
 	crypto_free_aead(tfm->aead);
-	crypto_put_default_null_skcipher2();
+	crypto_put_default_null_skcipher();
 	kfree(tfm);
 }
 
diff --git a/crypto/authenc.c b/crypto/authenc.c
index 875470b0e026..d3d6d72fe649 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -329,7 +329,7 @@ static int crypto_authenc_init_tfm(struct crypto_aead *tfm)
 	if (IS_ERR(enc))
 		goto err_free_ahash;
 
-	null = crypto_get_default_null_skcipher2();
+	null = crypto_get_default_null_skcipher();
 	err = PTR_ERR(null);
 	if (IS_ERR(null))
 		goto err_free_skcipher;
@@ -363,7 +363,7 @@ static void crypto_authenc_exit_tfm(struct crypto_aead *tfm)
 
 	crypto_free_ahash(ctx->auth);
 	crypto_free_skcipher(ctx->enc);
-	crypto_put_default_null_skcipher2();
+	crypto_put_default_null_skcipher();
 }
 
 static void crypto_authenc_free(struct aead_instance *inst)
diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index 0cf5fefdb859..15f91ddd7f0e 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -352,7 +352,7 @@ static int crypto_authenc_esn_init_tfm(struct crypto_aead *tfm)
 	if (IS_ERR(enc))
 		goto err_free_ahash;
 
-	null = crypto_get_default_null_skcipher2();
+	null = crypto_get_default_null_skcipher();
 	err = PTR_ERR(null);
 	if (IS_ERR(null))
 		goto err_free_skcipher;
@@ -389,7 +389,7 @@ static void crypto_authenc_esn_exit_tfm(struct crypto_aead *tfm)
 
 	crypto_free_ahash(ctx->auth);
 	crypto_free_skcipher(ctx->enc);
-	crypto_put_default_null_skcipher2();
+	crypto_put_default_null_skcipher();
 }
 
 static void crypto_authenc_esn_free(struct aead_instance *inst)
diff --git a/crypto/gcm.c b/crypto/gcm.c
index 8589681fb9f6..0ad879e1f9b2 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -1101,7 +1101,7 @@ static int crypto_rfc4543_init_tfm(struct crypto_aead *tfm)
 	if (IS_ERR(aead))
 		return PTR_ERR(aead);
 
-	null = crypto_get_default_null_skcipher2();
+	null = crypto_get_default_null_skcipher();
 	err = PTR_ERR(null);
 	if (IS_ERR(null))
 		goto err_free_aead;
@@ -1129,7 +1129,7 @@ static void crypto_rfc4543_exit_tfm(struct crypto_aead *tfm)
 	struct crypto_rfc4543_ctx *ctx = crypto_aead_ctx(tfm);
 
 	crypto_free_aead(ctx->child);
-	crypto_put_default_null_skcipher2();
+	crypto_put_default_null_skcipher();
 }
 
 static void crypto_rfc4543_free(struct aead_instance *inst)
diff --git a/include/crypto/null.h b/include/crypto/null.h
index 5757c0a4b321..15aeef6e30ef 100644
--- a/include/crypto/null.h
+++ b/include/crypto/null.h
@@ -12,14 +12,4 @@
 struct crypto_skcipher *crypto_get_default_null_skcipher(void);
 void crypto_put_default_null_skcipher(void);
 
-static inline struct crypto_skcipher *crypto_get_default_null_skcipher2(void)
-{
-	return crypto_get_default_null_skcipher();
-}
-
-static inline void crypto_put_default_null_skcipher2(void)
-{
-	crypto_put_default_null_skcipher();
-}
-
 #endif
-- 
2.15.1.424.g9478a66081-goog
