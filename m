From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 8/13] crypto: seqiv - Use generic geniv init/exit helpers
Date: Thu, 13 Aug 2015 17:28:59 +0800
Message-ID: <E1ZPool-0005qS-KD@gondolin.me.apana.org.au>
References: <20150813092520.GA22268@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54226 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbbHMJ3D (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Aug 2015 05:29:03 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1ZPoom-00036f-6X
	for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2015 19:29:00 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch replaces the seqiv init/exit handlers with the generic
geniv helpers.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/seqiv.c |   75 +++++----------------------------------------------------
 1 file changed, 7 insertions(+), 68 deletions(-)

diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index 3d8b02b..15a749a 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -15,7 +15,6 @@
 
 #include <crypto/internal/geniv.h>
 #include <crypto/internal/skcipher.h>
-#include <crypto/null.h>
 #include <crypto/rng.h>
 #include <crypto/scatterwalk.h>
 #include <linux/err.h>
@@ -31,13 +30,6 @@ struct seqiv_ctx {
 	u8 salt[] __attribute__ ((aligned(__alignof__(u32))));
 };
 
-struct seqiv_aead_ctx {
-	/* aead_geniv_ctx must be first the element */
-	struct aead_geniv_ctx geniv;
-	struct crypto_blkcipher *null;
-	u8 salt[] __attribute__ ((aligned(__alignof__(u32))));
-};
-
 static void seqiv_free(struct crypto_instance *inst);
 
 static void seqiv_complete2(struct skcipher_givcrypt_request *req, int err)
@@ -155,7 +147,7 @@ static int seqiv_givencrypt(struct skcipher_givcrypt_request *req)
 static int seqiv_aead_encrypt(struct aead_request *req)
 {
 	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
-	struct seqiv_aead_ctx *ctx = crypto_aead_ctx(geniv);
+	struct aead_geniv_ctx *ctx = crypto_aead_ctx(geniv);
 	struct aead_request *subreq = aead_request_ctx(req);
 	crypto_completion_t compl;
 	void *data;
@@ -166,7 +158,7 @@ static int seqiv_aead_encrypt(struct aead_request *req)
 	if (req->cryptlen < ivsize)
 		return -EINVAL;
 
-	aead_request_set_tfm(subreq, ctx->geniv.child);
+	aead_request_set_tfm(subreq, ctx->child);
 
 	compl = req->base.complete;
 	data = req->base.data;
@@ -213,7 +205,7 @@ static int seqiv_aead_encrypt(struct aead_request *req)
 static int seqiv_aead_decrypt(struct aead_request *req)
 {
 	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
-	struct seqiv_aead_ctx *ctx = crypto_aead_ctx(geniv);
+	struct aead_geniv_ctx *ctx = crypto_aead_ctx(geniv);
 	struct aead_request *subreq = aead_request_ctx(req);
 	crypto_completion_t compl;
 	void *data;
@@ -222,7 +214,7 @@ static int seqiv_aead_decrypt(struct aead_request *req)
 	if (req->cryptlen < ivsize + crypto_aead_authsize(geniv))
 		return -EINVAL;
 
-	aead_request_set_tfm(subreq, ctx->geniv.child);
+	aead_request_set_tfm(subreq, ctx->child);
 
 	compl = req->base.complete;
 	data = req->base.data;
@@ -258,59 +250,6 @@ static int seqiv_init(struct crypto_tfm *tfm)
 	return err ?: skcipher_geniv_init(tfm);
 }
 
-static int seqiv_aead_init_common(struct crypto_aead *geniv,
-				  unsigned int reqsize)
-{
-	struct seqiv_aead_ctx *ctx = crypto_aead_ctx(geniv);
-	int err;
-
-	spin_lock_init(&ctx->geniv.lock);
-
-	crypto_aead_set_reqsize(geniv, sizeof(struct aead_request));
-
-	err = crypto_get_default_rng();
-	if (err)
-		goto out;
-
-	err = crypto_rng_get_bytes(crypto_default_rng, ctx->salt,
-				   crypto_aead_ivsize(geniv));
-	crypto_put_default_rng();
-	if (err)
-		goto out;
-
-	ctx->null = crypto_get_default_null_skcipher();
-	err = PTR_ERR(ctx->null);
-	if (IS_ERR(ctx->null))
-		goto out;
-
-	err = aead_geniv_init(crypto_aead_tfm(geniv));
-	if (err)
-		goto drop_null;
-
-	ctx->geniv.child = geniv->child;
-	geniv->child = geniv;
-
-out:
-	return err;
-
-drop_null:
-	crypto_put_default_null_skcipher();
-	goto out;
-}
-
-static int seqiv_aead_init(struct crypto_aead *tfm)
-{
-	return seqiv_aead_init_common(tfm, sizeof(struct aead_request));
-}
-
-static void seqiv_aead_exit(struct crypto_aead *tfm)
-{
-	struct seqiv_aead_ctx *ctx = crypto_aead_ctx(tfm);
-
-	crypto_free_aead(ctx->geniv.child);
-	crypto_put_default_null_skcipher();
-}
-
 static int seqiv_ablkcipher_create(struct crypto_template *tmpl,
 				   struct rtattr **tb)
 {
@@ -370,10 +309,10 @@ static int seqiv_aead_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.encrypt = seqiv_aead_encrypt;
 	inst->alg.decrypt = seqiv_aead_decrypt;
 
-	inst->alg.init = seqiv_aead_init;
-	inst->alg.exit = seqiv_aead_exit;
+	inst->alg.init = aead_init_geniv;
+	inst->alg.exit = aead_exit_geniv;
 
-	inst->alg.base.cra_ctxsize = sizeof(struct seqiv_aead_ctx);
+	inst->alg.base.cra_ctxsize = sizeof(struct aead_geniv_ctx);
 	inst->alg.base.cra_ctxsize += inst->alg.ivsize;
 
 	err = aead_register_instance(tmpl, inst);
