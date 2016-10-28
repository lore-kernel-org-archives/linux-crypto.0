From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH] crypto: skcipher - Get rid of crypto_grab_skcipher2()
Date: Fri, 28 Oct 2016 09:51:13 -0700
Message-ID: <1477673473-85207-1-git-send-email-ebiggers@google.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:34100 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934937AbcJ1QwN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Oct 2016 12:52:13 -0400
Received: by mail-pf0-f182.google.com with SMTP id n85so40124233pfi.1
        for <linux-crypto@vger.kernel.org>; Fri, 28 Oct 2016 09:52:13 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Since commit 3a01d0ee2b99 ("crypto: skcipher - Remove top-level
givcipher interface"), crypto_grab_skcipher2() and
crypto_grab_skcipher() are equivalent.  So switch callers of
crypto_grab_skcipher2() to crypto_grab_skcipher() and remove it.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/authenc.c                   | 6 +++---
 crypto/authencesn.c                | 6 +++---
 crypto/ccm.c                       | 6 +++---
 crypto/chacha20poly1305.c          | 6 +++---
 crypto/ctr.c                       | 6 +++---
 crypto/cts.c                       | 6 +++---
 crypto/gcm.c                       | 6 +++---
 include/crypto/internal/skcipher.h | 6 ------
 8 files changed, 21 insertions(+), 27 deletions(-)

diff --git a/crypto/authenc.c b/crypto/authenc.c
index a7e1ac7..03d5edc 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -420,9 +420,9 @@ static int crypto_authenc_create(struct crypto_template *tmpl,
 		goto err_free_inst;
 
 	crypto_set_skcipher_spawn(&ctx->enc, aead_crypto_instance(inst));
-	err = crypto_grab_skcipher2(&ctx->enc, enc_name, 0,
-				    crypto_requires_sync(algt->type,
-							 algt->mask));
+	err = crypto_grab_skcipher(&ctx->enc, enc_name, 0,
+				   crypto_requires_sync(algt->type,
+							algt->mask));
 	if (err)
 		goto err_drop_auth;
 
diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index 121010a..bad6ef4 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -441,9 +441,9 @@ static int crypto_authenc_esn_create(struct crypto_template *tmpl,
 		goto err_free_inst;
 
 	crypto_set_skcipher_spawn(&ctx->enc, aead_crypto_instance(inst));
-	err = crypto_grab_skcipher2(&ctx->enc, enc_name, 0,
-				    crypto_requires_sync(algt->type,
-							 algt->mask));
+	err = crypto_grab_skcipher(&ctx->enc, enc_name, 0,
+				   crypto_requires_sync(algt->type,
+							algt->mask));
 	if (err)
 		goto err_drop_auth;
 
diff --git a/crypto/ccm.c b/crypto/ccm.c
index 006d857..67e3636 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -544,9 +544,9 @@ static int crypto_ccm_create_common(struct crypto_template *tmpl,
 		goto err_free_inst;
 
 	crypto_set_skcipher_spawn(&ictx->ctr, aead_crypto_instance(inst));
-	err = crypto_grab_skcipher2(&ictx->ctr, ctr_name, 0,
-				    crypto_requires_sync(algt->type,
-							 algt->mask));
+	err = crypto_grab_skcipher(&ictx->ctr, ctr_name, 0,
+				   crypto_requires_sync(algt->type,
+							algt->mask));
 	if (err)
 		goto err_drop_cipher;
 
diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index e899ef5..66291d4 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -625,9 +625,9 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 		goto err_free_inst;
 
 	crypto_set_skcipher_spawn(&ctx->chacha, aead_crypto_instance(inst));
-	err = crypto_grab_skcipher2(&ctx->chacha, chacha_name, 0,
-				    crypto_requires_sync(algt->type,
-							 algt->mask));
+	err = crypto_grab_skcipher(&ctx->chacha, chacha_name, 0,
+				   crypto_requires_sync(algt->type,
+							algt->mask));
 	if (err)
 		goto err_drop_poly;
 
diff --git a/crypto/ctr.c b/crypto/ctr.c
index ff4d21e..57114b1 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -370,9 +370,9 @@ static int crypto_rfc3686_create(struct crypto_template *tmpl,
 	spawn = skcipher_instance_ctx(inst);
 
 	crypto_set_skcipher_spawn(spawn, skcipher_crypto_instance(inst));
-	err = crypto_grab_skcipher2(spawn, cipher_name, 0,
-				    crypto_requires_sync(algt->type,
-							 algt->mask));
+	err = crypto_grab_skcipher(spawn, cipher_name, 0,
+				   crypto_requires_sync(algt->type,
+							algt->mask));
 	if (err)
 		goto err_free_inst;
 
diff --git a/crypto/cts.c b/crypto/cts.c
index 5197618..8883b62 100644
--- a/crypto/cts.c
+++ b/crypto/cts.c
@@ -348,9 +348,9 @@ static int crypto_cts_create(struct crypto_template *tmpl, struct rtattr **tb)
 	spawn = skcipher_instance_ctx(inst);
 
 	crypto_set_skcipher_spawn(spawn, skcipher_crypto_instance(inst));
-	err = crypto_grab_skcipher2(spawn, cipher_name, 0,
-				    crypto_requires_sync(algt->type,
-							 algt->mask));
+	err = crypto_grab_skcipher(spawn, cipher_name, 0,
+				   crypto_requires_sync(algt->type,
+							algt->mask));
 	if (err)
 		goto err_free_inst;
 
diff --git a/crypto/gcm.c b/crypto/gcm.c
index 39c261d..5f11b80 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -663,9 +663,9 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
 		goto err_drop_ghash;
 
 	crypto_set_skcipher_spawn(&ctx->ctr, aead_crypto_instance(inst));
-	err = crypto_grab_skcipher2(&ctx->ctr, ctr_name, 0,
-				    crypto_requires_sync(algt->type,
-							 algt->mask));
+	err = crypto_grab_skcipher(&ctx->ctr, ctr_name, 0,
+				   crypto_requires_sync(algt->type,
+							algt->mask));
 	if (err)
 		goto err_drop_ghash;
 
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index 95d2a18..558f5c9 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -68,12 +68,6 @@ static inline void crypto_set_skcipher_spawn(
 int crypto_grab_skcipher(struct crypto_skcipher_spawn *spawn, const char *name,
 			 u32 type, u32 mask);
 
-static inline int crypto_grab_skcipher2(struct crypto_skcipher_spawn *spawn,
-					const char *name, u32 type, u32 mask)
-{
-	return crypto_grab_skcipher(spawn, name, type, mask);
-}
-
 static inline void crypto_drop_skcipher(struct crypto_skcipher_spawn *spawn)
 {
 	crypto_drop_spawn(&spawn->base);
-- 
2.8.0.rc3.226.g39d4020
