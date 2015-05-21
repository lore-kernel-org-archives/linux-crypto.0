From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 12/16] crypto: gcm - Use default null skcipher
Date: Thu, 21 May 2015 15:11:11 +0800
Message-ID: <E1YvKdL-0005fu-6x@gondolin.me.apana.org.au>
References: <20150521070915.GA20997@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36016 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170AbbEUHLR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 May 2015 03:11:17 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YvKdL-00030R-CX
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2015 17:11:11 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch makes gcm use the default null skcipher instead of
allocating a new one for each tfm.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/gcm.c |   23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index b56200e..fc2b55e 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -12,6 +12,7 @@
 #include <crypto/internal/aead.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/internal/hash.h>
+#include <crypto/null.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/hash.h>
 #include "internal.h"
@@ -39,7 +40,6 @@ struct crypto_rfc4106_ctx {
 
 struct crypto_rfc4543_instance_ctx {
 	struct crypto_aead_spawn aead;
-	struct crypto_skcipher_spawn null;
 };
 
 struct crypto_rfc4543_ctx {
@@ -1246,7 +1246,7 @@ static int crypto_rfc4543_init_tfm(struct crypto_tfm *tfm)
 	if (IS_ERR(aead))
 		return PTR_ERR(aead);
 
-	null = crypto_spawn_blkcipher(&ictx->null.base);
+	null = crypto_get_default_null_skcipher();
 	err = PTR_ERR(null);
 	if (IS_ERR(null))
 		goto err_free_aead;
@@ -1273,7 +1273,7 @@ static void crypto_rfc4543_exit_tfm(struct crypto_tfm *tfm)
 	struct crypto_rfc4543_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	crypto_free_aead(ctx->child);
-	crypto_free_blkcipher(ctx->null);
+	crypto_put_default_null_skcipher();
 }
 
 static struct crypto_instance *crypto_rfc4543_alloc(struct rtattr **tb)
@@ -1311,23 +1311,15 @@ static struct crypto_instance *crypto_rfc4543_alloc(struct rtattr **tb)
 
 	alg = crypto_aead_spawn_alg(spawn);
 
-	crypto_set_skcipher_spawn(&ctx->null, inst);
-	err = crypto_grab_skcipher(&ctx->null, "ecb(cipher_null)", 0,
-				   CRYPTO_ALG_ASYNC);
-	if (err)
-		goto out_drop_alg;
-
-	crypto_skcipher_spawn_alg(&ctx->null);
-
 	err = -EINVAL;
 
 	/* We only support 16-byte blocks. */
 	if (alg->cra_aead.ivsize != 16)
-		goto out_drop_ecbnull;
+		goto out_drop_alg;
 
 	/* Not a stream cipher? */
 	if (alg->cra_blocksize != 1)
-		goto out_drop_ecbnull;
+		goto out_drop_alg;
 
 	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.cra_name, CRYPTO_MAX_ALG_NAME,
@@ -1335,7 +1327,7 @@ static struct crypto_instance *crypto_rfc4543_alloc(struct rtattr **tb)
 	    snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "rfc4543(%s)", alg->cra_driver_name) >=
 	    CRYPTO_MAX_ALG_NAME)
-		goto out_drop_ecbnull;
+		goto out_drop_alg;
 
 	inst->alg.cra_flags = CRYPTO_ALG_TYPE_AEAD;
 	inst->alg.cra_flags |= alg->cra_flags & CRYPTO_ALG_ASYNC;
@@ -1362,8 +1354,6 @@ static struct crypto_instance *crypto_rfc4543_alloc(struct rtattr **tb)
 out:
 	return inst;
 
-out_drop_ecbnull:
-	crypto_drop_skcipher(&ctx->null);
 out_drop_alg:
 	crypto_drop_aead(spawn);
 out_free_inst:
@@ -1377,7 +1367,6 @@ static void crypto_rfc4543_free(struct crypto_instance *inst)
 	struct crypto_rfc4543_instance_ctx *ctx = crypto_instance_ctx(inst);
 
 	crypto_drop_aead(&ctx->aead);
-	crypto_drop_skcipher(&ctx->null);
 
 	kfree(inst);
 }
