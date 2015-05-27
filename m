From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 9/11] crypto: seqiv - Use common IV generation code
Date: Wed, 27 May 2015 14:37:37 +0800
Message-ID: <E1YxUy9-0006n5-SF@gondolin.me.apana.org.au>
References: <20150527063539.GA25889@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42808 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbbE0Ghm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 May 2015 02:37:42 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YxUyA-0005dM-N6
	for <linux-crypto@vger.kernel.org>; Wed, 27 May 2015 16:37:38 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch makes use of the new common IV generation code.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/seqiv.c |   92 ++++++++++++++++++++++-----------------------------------
 1 file changed, 36 insertions(+), 56 deletions(-)

diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index b55c685..9c4490b 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -13,7 +13,7 @@
  *
  */
 
-#include <crypto/internal/aead.h>
+#include <crypto/internal/geniv.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/null.h>
 #include <crypto/rng.h>
@@ -37,30 +37,14 @@ struct seqiv_ctx {
 };
 
 struct seqiv_aead_ctx {
-	struct crypto_aead *child;
-	spinlock_t lock;
+	/* aead_geniv_ctx must be first the element */
+	struct aead_geniv_ctx geniv;
 	struct crypto_blkcipher *null;
 	u8 salt[] __attribute__ ((aligned(__alignof__(u32))));
 };
 
 static void seqiv_free(struct crypto_instance *inst);
 
-static int seqiv_aead_setkey(struct crypto_aead *tfm,
-			     const u8 *key, unsigned int keylen)
-{
-	struct seqiv_aead_ctx *ctx = crypto_aead_ctx(tfm);
-
-	return crypto_aead_setkey(ctx->child, key, keylen);
-}
-
-static int seqiv_aead_setauthsize(struct crypto_aead *tfm,
-				  unsigned int authsize)
-{
-	struct seqiv_aead_ctx *ctx = crypto_aead_ctx(tfm);
-
-	return crypto_aead_setauthsize(ctx->child, authsize);
-}
-
 static void seqiv_complete2(struct skcipher_givcrypt_request *req, int err)
 {
 	struct ablkcipher_request *subreq = skcipher_givcrypt_reqctx(req);
@@ -289,7 +273,7 @@ static int seqiv_aead_givencrypt(struct aead_givcrypt_request *req)
 	return err;
 }
 
-static int seqiv_aead_encrypt_compat(struct aead_request *req)
+static int seqniv_aead_encrypt(struct aead_request *req)
 {
 	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
 	struct seqiv_aead_ctx *ctx = crypto_aead_ctx(geniv);
@@ -309,7 +293,7 @@ static int seqiv_aead_encrypt_compat(struct aead_request *req)
 	if (req->assoclen > 12)
 		return -EINVAL;
 
-	aead_request_set_tfm(subreq, ctx->child);
+	aead_request_set_tfm(subreq, ctx->geniv.child);
 
 	compl = seqniv_aead_encrypt_complete;
 	data = req;
@@ -359,7 +343,7 @@ static int seqiv_aead_encrypt(struct aead_request *req)
 	if (req->cryptlen < ivsize)
 		return -EINVAL;
 
-	aead_request_set_tfm(subreq, ctx->child);
+	aead_request_set_tfm(subreq, ctx->geniv.child);
 
 	compl = req->base.complete;
 	data = req->base.data;
@@ -403,7 +387,7 @@ static int seqiv_aead_encrypt(struct aead_request *req)
 	return err;
 }
 
-static int seqiv_aead_decrypt_compat(struct aead_request *req)
+static int seqniv_aead_decrypt(struct aead_request *req)
 {
 	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
 	struct seqiv_aead_ctx *ctx = crypto_aead_ctx(geniv);
@@ -419,7 +403,7 @@ static int seqiv_aead_decrypt_compat(struct aead_request *req)
 	if (req->cryptlen < ivsize + crypto_aead_authsize(geniv))
 		return -EINVAL;
 
-	aead_request_set_tfm(subreq, ctx->child);
+	aead_request_set_tfm(subreq, ctx->geniv.child);
 
 	compl = req->base.complete;
 	data = req->base.data;
@@ -472,7 +456,7 @@ static int seqiv_aead_decrypt(struct aead_request *req)
 	if (req->cryptlen < ivsize + crypto_aead_authsize(geniv))
 		return -EINVAL;
 
-	aead_request_set_tfm(subreq, ctx->child);
+	aead_request_set_tfm(subreq, ctx->geniv.child);
 
 	compl = req->base.complete;
 	data = req->base.data;
@@ -536,27 +520,27 @@ unlock:
 	return seqiv_aead_givencrypt(req);
 }
 
-static int seqiv_aead_encrypt_compat_first(struct aead_request *req)
+static int seqniv_aead_encrypt_first(struct aead_request *req)
 {
 	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
 	struct seqiv_aead_ctx *ctx = crypto_aead_ctx(geniv);
 	int err = 0;
 
-	spin_lock_bh(&ctx->lock);
-	if (geniv->encrypt != seqiv_aead_encrypt_compat_first)
+	spin_lock_bh(&ctx->geniv.lock);
+	if (geniv->encrypt != seqniv_aead_encrypt_first)
 		goto unlock;
 
-	geniv->encrypt = seqiv_aead_encrypt_compat;
+	geniv->encrypt = seqniv_aead_encrypt;
 	err = crypto_rng_get_bytes(crypto_default_rng, ctx->salt,
 				   crypto_aead_ivsize(geniv));
 
 unlock:
-	spin_unlock_bh(&ctx->lock);
+	spin_unlock_bh(&ctx->geniv.lock);
 
 	if (err)
 		return err;
 
-	return seqiv_aead_encrypt_compat(req);
+	return seqniv_aead_encrypt(req);
 }
 
 static int seqiv_aead_encrypt_first(struct aead_request *req)
@@ -565,7 +549,7 @@ static int seqiv_aead_encrypt_first(struct aead_request *req)
 	struct seqiv_aead_ctx *ctx = crypto_aead_ctx(geniv);
 	int err = 0;
 
-	spin_lock_bh(&ctx->lock);
+	spin_lock_bh(&ctx->geniv.lock);
 	if (geniv->encrypt != seqiv_aead_encrypt_first)
 		goto unlock;
 
@@ -574,7 +558,7 @@ static int seqiv_aead_encrypt_first(struct aead_request *req)
 				   crypto_aead_ivsize(geniv));
 
 unlock:
-	spin_unlock_bh(&ctx->lock);
+	spin_unlock_bh(&ctx->geniv.lock);
 
 	if (err)
 		return err;
@@ -613,7 +597,7 @@ static int seqiv_aead_init_common(struct crypto_tfm *tfm, unsigned int reqsize)
 	struct seqiv_aead_ctx *ctx = crypto_aead_ctx(geniv);
 	int err;
 
-	spin_lock_init(&ctx->lock);
+	spin_lock_init(&ctx->geniv.lock);
 
 	crypto_aead_set_reqsize(geniv, sizeof(struct aead_request));
 
@@ -626,7 +610,7 @@ static int seqiv_aead_init_common(struct crypto_tfm *tfm, unsigned int reqsize)
 	if (err)
 		goto drop_null;
 
-	ctx->child = geniv->child;
+	ctx->geniv.child = geniv->child;
 	geniv->child = geniv;
 
 out:
@@ -651,7 +635,7 @@ static void seqiv_aead_exit(struct crypto_tfm *tfm)
 {
 	struct seqiv_aead_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	crypto_free_aead(ctx->child);
+	crypto_free_aead(ctx->geniv.child);
 	crypto_put_default_null_skcipher();
 }
 
@@ -738,15 +722,16 @@ static int seqiv_aead_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (inst->alg.base.cra_aead.encrypt)
 		return seqiv_old_aead_create(tmpl, inst);
 
+	spawn = aead_instance_ctx(inst);
+	alg = crypto_spawn_aead_alg(spawn);
+
+	if (alg->base.cra_aead.encrypt)
+		goto done;
+
 	err = -EINVAL;
 	if (inst->alg.ivsize != sizeof(u64))
 		goto free_inst;
 
-	spawn = aead_instance_ctx(inst);
-	alg = crypto_spawn_aead_alg(spawn);
-
-	inst->alg.setkey = seqiv_aead_setkey;
-	inst->alg.setauthsize = seqiv_aead_setauthsize;
 	inst->alg.encrypt = seqiv_aead_encrypt_first;
 	inst->alg.decrypt = seqiv_aead_decrypt;
 
@@ -756,14 +741,7 @@ static int seqiv_aead_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.base.cra_ctxsize = sizeof(struct seqiv_aead_ctx);
 	inst->alg.base.cra_ctxsize += inst->alg.base.cra_aead.ivsize;
 
-	if (alg->base.cra_aead.encrypt) {
-		inst->alg.encrypt = seqiv_aead_encrypt_compat_first;
-		inst->alg.decrypt = seqiv_aead_decrypt_compat;
-
-		inst->alg.base.cra_init = seqniv_aead_init;
-		inst->alg.base.cra_exit = seqiv_aead_exit;
-	}
-
+done:
 	err = aead_register_instance(tmpl, inst);
 	if (err)
 		goto free_inst;
@@ -816,17 +794,18 @@ static int seqniv_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (IS_ERR(inst))
 		goto put_rng;
 
+	spawn = aead_instance_ctx(inst);
+	alg = crypto_spawn_aead_alg(spawn);
+
+	if (alg->base.cra_aead.encrypt)
+		goto done;
+
 	err = -EINVAL;
 	if (inst->alg.ivsize != sizeof(u64))
 		goto free_inst;
 
-	spawn = aead_instance_ctx(inst);
-	alg = crypto_spawn_aead_alg(spawn);
-
-	inst->alg.setkey = seqiv_aead_setkey;
-	inst->alg.setauthsize = seqiv_aead_setauthsize;
-	inst->alg.encrypt = seqiv_aead_encrypt_compat_first;
-	inst->alg.decrypt = seqiv_aead_decrypt_compat;
+	inst->alg.encrypt = seqniv_aead_encrypt_first;
+	inst->alg.decrypt = seqniv_aead_decrypt;
 
 	inst->alg.base.cra_init = seqniv_aead_init;
 	inst->alg.base.cra_exit = seqiv_aead_exit;
@@ -835,6 +814,7 @@ static int seqniv_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.base.cra_ctxsize = sizeof(struct seqiv_aead_ctx);
 	inst->alg.base.cra_ctxsize += inst->alg.base.cra_aead.ivsize;
 
+done:
 	err = aead_register_instance(tmpl, inst);
 	if (err)
 		goto free_inst;
