From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 9/13] crypto: echainiv - Use generic geniv init/exit helpers
Date: Thu, 13 Aug 2015 17:29:01 +0800
Message-ID: <E1ZPoon-0005qj-0q@gondolin.me.apana.org.au>
References: <20150813092520.GA22268@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46000 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbbHMJ3F (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Aug 2015 05:29:05 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1ZPoon-00036n-T9
	for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2015 19:29:02 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch replaces the echainiv init/exit handlers with the generic
geniv helpers.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/echainiv.c |   70 +++++-------------------------------------------------
 1 file changed, 7 insertions(+), 63 deletions(-)

diff --git a/crypto/echainiv.c b/crypto/echainiv.c
index 806ebe7..b96a8456 100644
--- a/crypto/echainiv.c
+++ b/crypto/echainiv.c
@@ -19,8 +19,6 @@
  */
 
 #include <crypto/internal/geniv.h>
-#include <crypto/null.h>
-#include <crypto/rng.h>
 #include <crypto/scatterwalk.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -33,13 +31,6 @@
 
 #define MAX_IV_SIZE 16
 
-struct echainiv_ctx {
-	/* aead_geniv_ctx must be first the element */
-	struct aead_geniv_ctx geniv;
-	struct crypto_blkcipher *null;
-	u8 salt[] __attribute__ ((aligned(__alignof__(u32))));
-};
-
 static DEFINE_PER_CPU(u32 [MAX_IV_SIZE / sizeof(u32)], echainiv_iv);
 
 /* We don't care if we get preempted and read/write IVs from the next CPU. */
@@ -103,7 +94,7 @@ static void echainiv_encrypt_complete(struct crypto_async_request *base,
 static int echainiv_encrypt(struct aead_request *req)
 {
 	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
-	struct echainiv_ctx *ctx = crypto_aead_ctx(geniv);
+	struct aead_geniv_ctx *ctx = crypto_aead_ctx(geniv);
 	struct aead_request *subreq = aead_request_ctx(req);
 	crypto_completion_t compl;
 	void *data;
@@ -114,7 +105,7 @@ static int echainiv_encrypt(struct aead_request *req)
 	if (req->cryptlen < ivsize)
 		return -EINVAL;
 
-	aead_request_set_tfm(subreq, ctx->geniv.child);
+	aead_request_set_tfm(subreq, ctx->child);
 
 	compl = echainiv_encrypt_complete;
 	data = req;
@@ -160,7 +151,7 @@ static int echainiv_encrypt(struct aead_request *req)
 static int echainiv_decrypt(struct aead_request *req)
 {
 	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
-	struct echainiv_ctx *ctx = crypto_aead_ctx(geniv);
+	struct aead_geniv_ctx *ctx = crypto_aead_ctx(geniv);
 	struct aead_request *subreq = aead_request_ctx(req);
 	crypto_completion_t compl;
 	void *data;
@@ -169,7 +160,7 @@ static int echainiv_decrypt(struct aead_request *req)
 	if (req->cryptlen < ivsize)
 		return -EINVAL;
 
-	aead_request_set_tfm(subreq, ctx->geniv.child);
+	aead_request_set_tfm(subreq, ctx->child);
 
 	compl = req->base.complete;
 	data = req->base.data;
@@ -184,53 +175,6 @@ static int echainiv_decrypt(struct aead_request *req)
 	return crypto_aead_decrypt(subreq);
 }
 
-static int echainiv_init(struct crypto_aead *geniv)
-{
-	struct echainiv_ctx *ctx = crypto_aead_ctx(geniv);
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
-static void echainiv_exit(struct crypto_aead *tfm)
-{
-	struct echainiv_ctx *ctx = crypto_aead_ctx(tfm);
-
-	crypto_free_aead(ctx->geniv.child);
-	crypto_put_default_null_skcipher();
-}
-
 static int echainiv_aead_create(struct crypto_template *tmpl,
 				struct rtattr **tb)
 {
@@ -255,11 +199,11 @@ static int echainiv_aead_create(struct crypto_template *tmpl,
 	inst->alg.encrypt = echainiv_encrypt;
 	inst->alg.decrypt = echainiv_decrypt;
 
-	inst->alg.init = echainiv_init;
-	inst->alg.exit = echainiv_exit;
+	inst->alg.init = aead_init_geniv;
+	inst->alg.exit = aead_exit_geniv;
 
 	inst->alg.base.cra_alignmask |= __alignof__(u32) - 1;
-	inst->alg.base.cra_ctxsize = sizeof(struct echainiv_ctx);
+	inst->alg.base.cra_ctxsize = sizeof(struct aead_geniv_ctx);
 	inst->alg.base.cra_ctxsize += inst->alg.ivsize;
 
 	inst->free = aead_geniv_free;
