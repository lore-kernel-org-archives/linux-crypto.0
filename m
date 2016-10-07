From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH] crypto: api - Remove no-op exit_ops code
Date: Fri,  7 Oct 2016 14:13:35 -0700
Message-ID: <1475874815-136813-2-git-send-email-ebiggers@google.com>
Cc: linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:34656 "EHLO
        mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932452AbcJGVOq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Oct 2016 17:14:46 -0400
Received: by mail-pf0-f179.google.com with SMTP id e6so28600830pfk.1
        for <linux-crypto@vger.kernel.org>; Fri, 07 Oct 2016 14:14:46 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto_exit_cipher_ops() and crypto_exit_compress_ops() are no-ops and
have been for a long time, so remove them.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/api.c      | 20 ++------------------
 crypto/cipher.c   |  4 ----
 crypto/compress.c |  4 ----
 crypto/internal.h |  3 ---
 4 files changed, 2 insertions(+), 29 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index bbc147c..a88729f 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -310,24 +310,8 @@ static void crypto_exit_ops(struct crypto_tfm *tfm)
 {
 	const struct crypto_type *type = tfm->__crt_alg->cra_type;
 
-	if (type) {
-		if (tfm->exit)
-			tfm->exit(tfm);
-		return;
-	}
-
-	switch (crypto_tfm_alg_type(tfm)) {
-	case CRYPTO_ALG_TYPE_CIPHER:
-		crypto_exit_cipher_ops(tfm);
-		break;
-
-	case CRYPTO_ALG_TYPE_COMPRESS:
-		crypto_exit_compress_ops(tfm);
-		break;
-
-	default:
-		BUG();
-	}
+	if (type && tfm->exit)
+		tfm->exit(tfm);
 }
 
 static unsigned int crypto_ctxsize(struct crypto_alg *alg, u32 type, u32 mask)
diff --git a/crypto/cipher.c b/crypto/cipher.c
index 39541e0..94fa355 100644
--- a/crypto/cipher.c
+++ b/crypto/cipher.c
@@ -116,7 +116,3 @@ int crypto_init_cipher_ops(struct crypto_tfm *tfm)
 
 	return 0;
 }
-
-void crypto_exit_cipher_ops(struct crypto_tfm *tfm)
-{
-}
diff --git a/crypto/compress.c b/crypto/compress.c
index c33f076..f2d5229 100644
--- a/crypto/compress.c
+++ b/crypto/compress.c
@@ -42,7 +42,3 @@ int crypto_init_compress_ops(struct crypto_tfm *tfm)
 
 	return 0;
 }
-
-void crypto_exit_compress_ops(struct crypto_tfm *tfm)
-{
-}
diff --git a/crypto/internal.h b/crypto/internal.h
index 7eefcdb..f073204 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -76,9 +76,6 @@ struct crypto_alg *crypto_alg_mod_lookup(const char *name, u32 type, u32 mask);
 int crypto_init_cipher_ops(struct crypto_tfm *tfm);
 int crypto_init_compress_ops(struct crypto_tfm *tfm);
 
-void crypto_exit_cipher_ops(struct crypto_tfm *tfm);
-void crypto_exit_compress_ops(struct crypto_tfm *tfm);
-
 struct crypto_larval *crypto_larval_alloc(const char *name, u32 type, u32 mask);
 void crypto_larval_kill(struct crypto_alg *alg);
 struct crypto_alg *crypto_larval_lookup(const char *name, u32 type, u32 mask);
-- 
2.8.0.rc3.226.g39d4020
