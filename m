From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7/19] [CRYPTO] authenc: Use crypto_grab_skcipher
Date: Tue, 11 Dec 2007 12:02:58 +0800
Message-ID: <E1J1wKg-0002jy-00@gondolin.me.apana.org.au>
References: <20071211040215.GA10360@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1917 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751896AbXLKEDF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Dec 2007 23:03:05 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J1wKi-00062S-Hl
	for <linux-crypto@vger.kernel.org>; Tue, 11 Dec 2007 15:03:01 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] authenc: Use crypto_grab_skcipher

This patch converts the authenc algorithm over to crypto_grab_skcipher
which is a prerequisite for IV generation.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/authenc.c |   62 +++++++++++++++++++++++++++++++------------------------
 1 files changed, 36 insertions(+), 26 deletions(-)

diff --git a/crypto/authenc.c b/crypto/authenc.c
index 394e733..7ef0a58 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -10,7 +10,7 @@
  *
  */
 
-#include <crypto/algapi.h>
+#include <crypto/internal/skcipher.h>
 #include <crypto/authenc.h>
 #include <crypto/scatterwalk.h>
 #include <linux/err.h>
@@ -23,7 +23,7 @@
 
 struct authenc_instance_ctx {
 	struct crypto_spawn auth;
-	struct crypto_spawn enc;
+	struct crypto_skcipher_spawn enc;
 };
 
 struct crypto_authenc_ctx {
@@ -237,7 +237,7 @@ static int crypto_authenc_init_tfm(struct crypto_tfm *tfm)
 	if (IS_ERR(auth))
 		return PTR_ERR(auth);
 
-	enc = crypto_spawn_ablkcipher(&ictx->enc);
+	enc = crypto_spawn_skcipher(&ictx->enc);
 	err = PTR_ERR(enc);
 	if (IS_ERR(enc))
 		goto err_free_hash;
@@ -270,42 +270,36 @@ static void crypto_authenc_exit_tfm(struct crypto_tfm *tfm)
 
 static struct crypto_instance *crypto_authenc_alloc(struct rtattr **tb)
 {
+	struct crypto_attr_type *algt;
 	struct crypto_instance *inst;
 	struct crypto_alg *auth;
 	struct crypto_alg *enc;
 	struct authenc_instance_ctx *ctx;
+	const char *enc_name;
 	int err;
 
-	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_AEAD);
-	if (err)
+	algt = crypto_get_attr_type(tb);
+	err = PTR_ERR(algt);
+	if (IS_ERR(algt))
 		return ERR_PTR(err);
 
+	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
+		return ERR_PTR(-EINVAL);
+
 	auth = crypto_attr_alg(tb[1], CRYPTO_ALG_TYPE_HASH,
 			       CRYPTO_ALG_TYPE_HASH_MASK);
 	if (IS_ERR(auth))
 		return ERR_PTR(PTR_ERR(auth));
 
-	enc = crypto_attr_alg(tb[2], CRYPTO_ALG_TYPE_BLKCIPHER,
-			      CRYPTO_ALG_TYPE_BLKCIPHER_MASK);
-	inst = ERR_PTR(PTR_ERR(enc));
-	if (IS_ERR(enc))
+	enc_name = crypto_attr_alg_name(tb[2]);
+	err = PTR_ERR(enc_name);
+	if (IS_ERR(enc_name))
 		goto out_put_auth;
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	err = -ENOMEM;
 	if (!inst)
-		goto out_put_enc;
-
-	err = -ENAMETOOLONG;
-	if (snprintf(inst->alg.cra_name, CRYPTO_MAX_ALG_NAME,
-		     "authenc(%s,%s)", auth->cra_name, enc->cra_name) >=
-	    CRYPTO_MAX_ALG_NAME)
-		goto err_free_inst;
-
-	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
-		     "authenc(%s,%s)", auth->cra_driver_name,
-		     enc->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
-		goto err_free_inst;
+		goto out_put_auth;
 
 	ctx = crypto_instance_ctx(inst);
 
@@ -313,10 +307,26 @@ static struct crypto_instance *crypto_authenc_alloc(struct rtattr **tb)
 	if (err)
 		goto err_free_inst;
 
-	err = crypto_init_spawn(&ctx->enc, enc, inst, CRYPTO_ALG_TYPE_MASK);
+	crypto_set_skcipher_spawn(&ctx->enc, inst);
+	err = crypto_grab_skcipher(&ctx->enc, enc_name, 0,
+				   (algt->type ^ CRYPTO_ALG_ASYNC) &
+				   algt->mask);
 	if (err)
 		goto err_drop_auth;
 
+	enc = crypto_skcipher_spawn_alg(&ctx->enc);
+
+	err = -ENAMETOOLONG;
+	if (snprintf(inst->alg.cra_name, CRYPTO_MAX_ALG_NAME,
+		     "authenc(%s,%s)", auth->cra_name, enc->cra_name) >=
+	    CRYPTO_MAX_ALG_NAME)
+		goto err_drop_enc;
+
+	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
+		     "authenc(%s,%s)", auth->cra_driver_name,
+		     enc->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
+		goto err_drop_enc;
+
 	inst->alg.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC;
 	inst->alg.cra_priority = enc->cra_priority * 10 + auth->cra_priority;
 	inst->alg.cra_blocksize = enc->cra_blocksize;
@@ -338,16 +348,16 @@ static struct crypto_instance *crypto_authenc_alloc(struct rtattr **tb)
 	inst->alg.cra_aead.decrypt = crypto_authenc_decrypt;
 
 out:
-	crypto_mod_put(enc);
-out_put_auth:
 	crypto_mod_put(auth);
 	return inst;
 
+err_drop_enc:
+	crypto_drop_skcipher(&ctx->enc);
 err_drop_auth:
 	crypto_drop_spawn(&ctx->auth);
 err_free_inst:
 	kfree(inst);
-out_put_enc:
+out_put_auth:
 	inst = ERR_PTR(err);
 	goto out;
 }
@@ -356,7 +366,7 @@ static void crypto_authenc_free(struct crypto_instance *inst)
 {
 	struct authenc_instance_ctx *ctx = crypto_instance_ctx(inst);
 
-	crypto_drop_spawn(&ctx->enc);
+	crypto_drop_skcipher(&ctx->enc);
 	crypto_drop_spawn(&ctx->auth);
 	kfree(inst);
 }
