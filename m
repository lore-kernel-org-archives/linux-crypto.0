From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 01/13] crypto: service function to copy AAD from src to dst
Date: Tue, 10 Jan 2017 02:36:50 +0100
Message-ID: <33729636.uC4JoihLqD@positron.chronox.de>
References: <10526995.lyZ7Je1KMx@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55408 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941456AbdAJBmT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Jan 2017 20:42:19 -0500
In-Reply-To: <10526995.lyZ7Je1KMx@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The service function crypto_aead_copy_ad uses the null cipher to copy
the AAD from teh source to the destination SGL. The copy operation is
prevented when the source and destination SGL is identical.

The required null cipher is allocated during the allocation of the TFM
and released with the TFM. Therefore, a use of the helper function only
requires adding an invocation of this function in the encrypt code path
shortly before the encrypt operation is invoked but after the SGLs are
set with the AEAD request.

The patch converts the authenc implementation to use this service
function instead of its own copy logic.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Kconfig                 |  4 ++--
 crypto/aead.c                  | 36 ++++++++++++++++++++++++++++++++++--
 crypto/authenc.c               | 36 ++++--------------------------------
 include/crypto/aead.h          |  2 ++
 include/crypto/internal/aead.h | 12 ++++++++++++
 5 files changed, 54 insertions(+), 36 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 160f08e..f53928a 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -44,6 +44,8 @@ config CRYPTO_AEAD
 	tristate
 	select CRYPTO_AEAD2
 	select CRYPTO_ALGAPI
+	select CRYPTO_BLKCIPHER
+	select CRYPTO_NULL
 
 config CRYPTO_AEAD2
 	tristate
@@ -227,10 +229,8 @@ config CRYPTO_MCRYPTD
 config CRYPTO_AUTHENC
 	tristate "Authenc support"
 	select CRYPTO_AEAD
-	select CRYPTO_BLKCIPHER
 	select CRYPTO_MANAGER
 	select CRYPTO_HASH
-	select CRYPTO_NULL
 	help
 	  Authenc: Combined mode wrapper for IPsec.
 	  This is required for IPSec.
diff --git a/crypto/aead.c b/crypto/aead.c
index 3f5c5ff..e9291e6 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -79,11 +79,31 @@ int crypto_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
 }
 EXPORT_SYMBOL_GPL(crypto_aead_setauthsize);
 
+int crypto_aead_copy_ad(struct aead_request *req)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	SKCIPHER_REQUEST_ON_STACK(skreq, aead->null);
+
+	/* No copy operation if src and dst are identical. */
+	if (req->src == req->dst)
+		return 0;
+
+	skcipher_request_set_tfm(skreq, aead->null);
+	skcipher_request_set_callback(skreq, aead_request_flags(req),
+				      NULL, NULL);
+	skcipher_request_set_crypt(skreq, req->src, req->dst, req->assoclen,
+				   NULL);
+
+	return crypto_skcipher_encrypt(skreq);
+}
+EXPORT_SYMBOL_GPL(crypto_aead_copy_ad);
+
 static void crypto_aead_exit_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_aead *aead = __crypto_aead_cast(tfm);
 	struct aead_alg *alg = crypto_aead_alg(aead);
 
+	crypto_put_default_null_skcipher2();
 	alg->exit(aead);
 }
 
@@ -91,14 +111,26 @@ static int crypto_aead_init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_aead *aead = __crypto_aead_cast(tfm);
 	struct aead_alg *alg = crypto_aead_alg(aead);
+	struct crypto_skcipher *null;
+	int err;
 
 	aead->authsize = alg->maxauthsize;
 
+	null = crypto_get_default_null_skcipher2();
+	err = PTR_ERR(null);
+	if (IS_ERR(null))
+		return err;
+	aead->null = null;
+
 	if (alg->exit)
 		aead->base.exit = crypto_aead_exit_tfm;
 
-	if (alg->init)
-		return alg->init(aead);
+	if (alg->init) {
+		err = alg->init(aead);
+		if (err)
+			crypto_put_default_null_skcipher2();
+		return err;
+	}
 
 	return 0;
 }
diff --git a/crypto/authenc.c b/crypto/authenc.c
index 875470b..a7a304a 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -14,7 +14,6 @@
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/authenc.h>
-#include <crypto/null.h>
 #include <crypto/scatterwalk.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -33,7 +32,6 @@ struct authenc_instance_ctx {
 struct crypto_authenc_ctx {
 	struct crypto_ahash *auth;
 	struct crypto_skcipher *enc;
-	struct crypto_skcipher *null;
 };
 
 struct authenc_request_ctx {
@@ -180,21 +178,6 @@ static void crypto_authenc_encrypt_done(struct crypto_async_request *req,
 	authenc_request_complete(areq, err);
 }
 
-static int crypto_authenc_copy_assoc(struct aead_request *req)
-{
-	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
-	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
-	SKCIPHER_REQUEST_ON_STACK(skreq, ctx->null);
-
-	skcipher_request_set_tfm(skreq, ctx->null);
-	skcipher_request_set_callback(skreq, aead_request_flags(req),
-				      NULL, NULL);
-	skcipher_request_set_crypt(skreq, req->src, req->dst, req->assoclen,
-				   NULL);
-
-	return crypto_skcipher_encrypt(skreq);
-}
-
 static int crypto_authenc_encrypt(struct aead_request *req)
 {
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
@@ -212,13 +195,12 @@ static int crypto_authenc_encrypt(struct aead_request *req)
 	src = scatterwalk_ffwd(areq_ctx->src, req->src, req->assoclen);
 	dst = src;
 
-	if (req->src != req->dst) {
-		err = crypto_authenc_copy_assoc(req);
-		if (err)
-			return err;
+	err = crypto_aead_copy_ad(req);
+	if (err)
+		return err;
 
+	if (req->src != req->dst)
 		dst = scatterwalk_ffwd(areq_ctx->dst, req->dst, req->assoclen);
-	}
 
 	skcipher_request_set_tfm(skreq, enc);
 	skcipher_request_set_callback(skreq, aead_request_flags(req),
@@ -317,7 +299,6 @@ static int crypto_authenc_init_tfm(struct crypto_aead *tfm)
 	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(tfm);
 	struct crypto_ahash *auth;
 	struct crypto_skcipher *enc;
-	struct crypto_skcipher *null;
 	int err;
 
 	auth = crypto_spawn_ahash(&ictx->auth);
@@ -329,14 +310,8 @@ static int crypto_authenc_init_tfm(struct crypto_aead *tfm)
 	if (IS_ERR(enc))
 		goto err_free_ahash;
 
-	null = crypto_get_default_null_skcipher2();
-	err = PTR_ERR(null);
-	if (IS_ERR(null))
-		goto err_free_skcipher;
-
 	ctx->auth = auth;
 	ctx->enc = enc;
-	ctx->null = null;
 
 	crypto_aead_set_reqsize(
 		tfm,
@@ -350,8 +325,6 @@ static int crypto_authenc_init_tfm(struct crypto_aead *tfm)
 
 	return 0;
 
-err_free_skcipher:
-	crypto_free_skcipher(enc);
 err_free_ahash:
 	crypto_free_ahash(auth);
 	return err;
@@ -363,7 +336,6 @@ static void crypto_authenc_exit_tfm(struct crypto_aead *tfm)
 
 	crypto_free_ahash(ctx->auth);
 	crypto_free_skcipher(ctx->enc);
-	crypto_put_default_null_skcipher2();
 }
 
 static void crypto_authenc_free(struct aead_instance *inst)
diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index 03b9762..9872f92 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -16,6 +16,7 @@
 #include <linux/crypto.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <crypto/skcipher.h>
 
 /**
  * DOC: Authenticated Encryption With Associated Data (AEAD) Cipher API
@@ -155,6 +156,7 @@ struct crypto_aead {
 	unsigned int authsize;
 	unsigned int reqsize;
 
+	struct crypto_skcipher *null;
 	struct crypto_tfm base;
 };
 
diff --git a/include/crypto/internal/aead.h b/include/crypto/internal/aead.h
index 6ad8e31..01050c0 100644
--- a/include/crypto/internal/aead.h
+++ b/include/crypto/internal/aead.h
@@ -187,5 +187,17 @@ void crypto_unregister_aeads(struct aead_alg *algs, int count);
 int aead_register_instance(struct crypto_template *tmpl,
 			   struct aead_instance *inst);
 
+/**
+ * crypto_aead_copy_ad - copy the AAD from src to dst buffers
+ * @req: AEAD cipher request
+ *
+ * This function is intended for the encrypt operation only as the ciphertext
+ * should be accompanied by the AAD. The copy operation is performed with
+ * the null cipher that is allocated during initialization of the AEAD TFM.
+ *
+ * Return: 0 upon success, < 0 in case of error
+ */
+int crypto_aead_copy_ad(struct aead_request *req);
+
 #endif	/* _CRYPTO_INTERNAL_AEAD_H */
 
-- 
2.9.3
