From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH] crypto: skcipher - Get rid of crypto_spawn_skcipher2()
Date: Fri, 28 Oct 2016 09:52:19 -0700
Message-ID: <1477673539-85391-1-git-send-email-ebiggers@google.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:33295 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934937AbcJ1Qw3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Oct 2016 12:52:29 -0400
Received: by mail-pf0-f178.google.com with SMTP id 197so40302205pfu.0
        for <linux-crypto@vger.kernel.org>; Fri, 28 Oct 2016 09:52:28 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Since commit 3a01d0ee2b99 ("crypto: skcipher - Remove top-level
givcipher interface"), crypto_spawn_skcipher2() and
crypto_spawn_skcipher() are equivalent.  So switch callers of
crypto_spawn_skcipher2() to crypto_spawn_skcipher() and remove it.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/authenc.c                   | 2 +-
 crypto/authencesn.c                | 2 +-
 crypto/ccm.c                       | 2 +-
 crypto/chacha20poly1305.c          | 2 +-
 crypto/ctr.c                       | 2 +-
 crypto/cts.c                       | 2 +-
 crypto/gcm.c                       | 2 +-
 include/crypto/internal/skcipher.h | 6 ------
 8 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/crypto/authenc.c b/crypto/authenc.c
index 03d5edc..875470b 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -324,7 +324,7 @@ static int crypto_authenc_init_tfm(struct crypto_aead *tfm)
 	if (IS_ERR(auth))
 		return PTR_ERR(auth);
 
-	enc = crypto_spawn_skcipher2(&ictx->enc);
+	enc = crypto_spawn_skcipher(&ictx->enc);
 	err = PTR_ERR(enc);
 	if (IS_ERR(enc))
 		goto err_free_ahash;
diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index bad6ef4..6f8f6b8 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -342,7 +342,7 @@ static int crypto_authenc_esn_init_tfm(struct crypto_aead *tfm)
 	if (IS_ERR(auth))
 		return PTR_ERR(auth);
 
-	enc = crypto_spawn_skcipher2(&ictx->enc);
+	enc = crypto_spawn_skcipher(&ictx->enc);
 	err = PTR_ERR(enc);
 	if (IS_ERR(enc))
 		goto err_free_ahash;
diff --git a/crypto/ccm.c b/crypto/ccm.c
index 67e3636..26b924d 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -462,7 +462,7 @@ static int crypto_ccm_init_tfm(struct crypto_aead *tfm)
 	if (IS_ERR(cipher))
 		return PTR_ERR(cipher);
 
-	ctr = crypto_spawn_skcipher2(&ictx->ctr);
+	ctr = crypto_spawn_skcipher(&ictx->ctr);
 	err = PTR_ERR(ctr);
 	if (IS_ERR(ctr))
 		goto err_free_cipher;
diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index 66291d4..db1bc31 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -532,7 +532,7 @@ static int chachapoly_init(struct crypto_aead *tfm)
 	if (IS_ERR(poly))
 		return PTR_ERR(poly);
 
-	chacha = crypto_spawn_skcipher2(&ictx->chacha);
+	chacha = crypto_spawn_skcipher(&ictx->chacha);
 	if (IS_ERR(chacha)) {
 		crypto_free_ahash(poly);
 		return PTR_ERR(chacha);
diff --git a/crypto/ctr.c b/crypto/ctr.c
index 57114b1..a9a7a44 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -312,7 +312,7 @@ static int crypto_rfc3686_init_tfm(struct crypto_skcipher *tfm)
 	unsigned long align;
 	unsigned int reqsize;
 
-	cipher = crypto_spawn_skcipher2(spawn);
+	cipher = crypto_spawn_skcipher(spawn);
 	if (IS_ERR(cipher))
 		return PTR_ERR(cipher);
 
diff --git a/crypto/cts.c b/crypto/cts.c
index 8883b62..00254d7 100644
--- a/crypto/cts.c
+++ b/crypto/cts.c
@@ -290,7 +290,7 @@ static int crypto_cts_init_tfm(struct crypto_skcipher *tfm)
 	unsigned bsize;
 	unsigned align;
 
-	cipher = crypto_spawn_skcipher2(spawn);
+	cipher = crypto_spawn_skcipher(spawn);
 	if (IS_ERR(cipher))
 		return PTR_ERR(cipher);
 
diff --git a/crypto/gcm.c b/crypto/gcm.c
index 5f11b80..b7ad808 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -575,7 +575,7 @@ static int crypto_gcm_init_tfm(struct crypto_aead *tfm)
 	if (IS_ERR(ghash))
 		return PTR_ERR(ghash);
 
-	ctr = crypto_spawn_skcipher2(&ictx->ctr);
+	ctr = crypto_spawn_skcipher(&ictx->ctr);
 	err = PTR_ERR(ctr);
 	if (IS_ERR(ctr))
 		goto err_free_hash;
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index 558f5c9..7a7e815 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -91,12 +91,6 @@ static inline struct crypto_skcipher *crypto_spawn_skcipher(
 	return crypto_spawn_tfm2(&spawn->base);
 }
 
-static inline struct crypto_skcipher *crypto_spawn_skcipher2(
-	struct crypto_skcipher_spawn *spawn)
-{
-	return crypto_spawn_skcipher(spawn);
-}
-
 static inline void crypto_skcipher_set_reqsize(
 	struct crypto_skcipher *skcipher, unsigned int reqsize)
 {
-- 
2.8.0.rc3.226.g39d4020
