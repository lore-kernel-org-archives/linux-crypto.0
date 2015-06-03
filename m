From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/8] crypto: seqiv - Move IV seeding into init function
Date: Wed, 03 Jun 2015 14:49:27 +0800
Message-ID: <E1Z02UR-0001Gg-AV@gondolin.me.apana.org.au>
References: <20150603064641.GA4655@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54445 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbbFCGta (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Jun 2015 02:49:30 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We currently do the IV seeding on the first givencrypt call in
order to conserve entropy.  However, this does not work with
DRBG which cannot be called from interrupt context.  In fact,
with DRBG we don't need to conserve entropy anyway.  So this
patch moves the seeding into the init function.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/seqiv.c |  113 +++++++--------------------------------------------------
 1 file changed, 15 insertions(+), 98 deletions(-)

diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index 2333974..42e4ee5 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -474,98 +474,6 @@ static int seqiv_aead_decrypt(struct aead_request *req)
 	return crypto_aead_decrypt(subreq);
 }
 
-static int seqiv_givencrypt_first(struct skcipher_givcrypt_request *req)
-{
-	struct crypto_ablkcipher *geniv = skcipher_givcrypt_reqtfm(req);
-	struct seqiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
-	int err = 0;
-
-	spin_lock_bh(&ctx->lock);
-	if (crypto_ablkcipher_crt(geniv)->givencrypt != seqiv_givencrypt_first)
-		goto unlock;
-
-	crypto_ablkcipher_crt(geniv)->givencrypt = seqiv_givencrypt;
-	err = crypto_rng_get_bytes(crypto_default_rng, ctx->salt,
-				   crypto_ablkcipher_ivsize(geniv));
-
-unlock:
-	spin_unlock_bh(&ctx->lock);
-
-	if (err)
-		return err;
-
-	return seqiv_givencrypt(req);
-}
-
-static int seqiv_aead_givencrypt_first(struct aead_givcrypt_request *req)
-{
-	struct crypto_aead *geniv = aead_givcrypt_reqtfm(req);
-	struct seqiv_ctx *ctx = crypto_aead_ctx(geniv);
-	int err = 0;
-
-	spin_lock_bh(&ctx->lock);
-	if (crypto_aead_crt(geniv)->givencrypt != seqiv_aead_givencrypt_first)
-		goto unlock;
-
-	crypto_aead_crt(geniv)->givencrypt = seqiv_aead_givencrypt;
-	err = crypto_rng_get_bytes(crypto_default_rng, ctx->salt,
-				   crypto_aead_ivsize(geniv));
-
-unlock:
-	spin_unlock_bh(&ctx->lock);
-
-	if (err)
-		return err;
-
-	return seqiv_aead_givencrypt(req);
-}
-
-static int seqniv_aead_encrypt_first(struct aead_request *req)
-{
-	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
-	struct seqiv_aead_ctx *ctx = crypto_aead_ctx(geniv);
-	int err = 0;
-
-	spin_lock_bh(&ctx->geniv.lock);
-	if (geniv->encrypt != seqniv_aead_encrypt_first)
-		goto unlock;
-
-	geniv->encrypt = seqniv_aead_encrypt;
-	err = crypto_rng_get_bytes(crypto_default_rng, ctx->salt,
-				   crypto_aead_ivsize(geniv));
-
-unlock:
-	spin_unlock_bh(&ctx->geniv.lock);
-
-	if (err)
-		return err;
-
-	return seqniv_aead_encrypt(req);
-}
-
-static int seqiv_aead_encrypt_first(struct aead_request *req)
-{
-	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
-	struct seqiv_aead_ctx *ctx = crypto_aead_ctx(geniv);
-	int err = 0;
-
-	spin_lock_bh(&ctx->geniv.lock);
-	if (geniv->encrypt != seqiv_aead_encrypt_first)
-		goto unlock;
-
-	geniv->encrypt = seqiv_aead_encrypt;
-	err = crypto_rng_get_bytes(crypto_default_rng, ctx->salt,
-				   crypto_aead_ivsize(geniv));
-
-unlock:
-	spin_unlock_bh(&ctx->geniv.lock);
-
-	if (err)
-		return err;
-
-	return seqiv_aead_encrypt(req);
-}
-
 static int seqiv_init(struct crypto_tfm *tfm)
 {
 	struct crypto_ablkcipher *geniv = __crypto_ablkcipher_cast(tfm);
@@ -575,7 +483,9 @@ static int seqiv_init(struct crypto_tfm *tfm)
 
 	tfm->crt_ablkcipher.reqsize = sizeof(struct ablkcipher_request);
 
-	return skcipher_geniv_init(tfm);
+	return crypto_rng_get_bytes(crypto_default_rng, ctx->salt,
+				    crypto_ablkcipher_ivsize(geniv)) ?:
+	       skcipher_geniv_init(tfm);
 }
 
 static int seqiv_old_aead_init(struct crypto_tfm *tfm)
@@ -588,7 +498,9 @@ static int seqiv_old_aead_init(struct crypto_tfm *tfm)
 	crypto_aead_set_reqsize(__crypto_aead_cast(tfm),
 				sizeof(struct aead_request));
 
-	return aead_geniv_init(tfm);
+	return crypto_rng_get_bytes(crypto_default_rng, ctx->salt,
+				    crypto_aead_ivsize(geniv)) ?:
+	       aead_geniv_init(tfm);
 }
 
 static int seqiv_aead_init_common(struct crypto_tfm *tfm, unsigned int reqsize)
@@ -601,6 +513,11 @@ static int seqiv_aead_init_common(struct crypto_tfm *tfm, unsigned int reqsize)
 
 	crypto_aead_set_reqsize(geniv, sizeof(struct aead_request));
 
+	err = crypto_rng_get_bytes(crypto_default_rng, ctx->salt,
+				   crypto_aead_ivsize(geniv));
+	if (err)
+		goto out;
+
 	ctx->null = crypto_get_default_null_skcipher();
 	err = PTR_ERR(ctx->null);
 	if (IS_ERR(ctx->null))
@@ -654,7 +571,7 @@ static int seqiv_ablkcipher_create(struct crypto_template *tmpl,
 	if (inst->alg.cra_ablkcipher.ivsize < sizeof(u64))
 		goto free_inst;
 
-	inst->alg.cra_ablkcipher.givencrypt = seqiv_givencrypt_first;
+	inst->alg.cra_ablkcipher.givencrypt = seqiv_givencrypt;
 
 	inst->alg.cra_init = seqiv_init;
 	inst->alg.cra_exit = skcipher_geniv_exit;
@@ -685,7 +602,7 @@ static int seqiv_old_aead_create(struct crypto_template *tmpl,
 	if (inst->alg.cra_aead.ivsize < sizeof(u64))
 		goto free_inst;
 
-	inst->alg.cra_aead.givencrypt = seqiv_aead_givencrypt_first;
+	inst->alg.cra_aead.givencrypt = seqiv_aead_givencrypt;
 
 	inst->alg.cra_init = seqiv_old_aead_init;
 	inst->alg.cra_exit = aead_geniv_exit;
@@ -732,7 +649,7 @@ static int seqiv_aead_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (inst->alg.ivsize != sizeof(u64))
 		goto free_inst;
 
-	inst->alg.encrypt = seqiv_aead_encrypt_first;
+	inst->alg.encrypt = seqiv_aead_encrypt;
 	inst->alg.decrypt = seqiv_aead_decrypt;
 
 	inst->alg.base.cra_init = seqiv_aead_init;
@@ -804,7 +721,7 @@ static int seqniv_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (inst->alg.ivsize != sizeof(u64))
 		goto free_inst;
 
-	inst->alg.encrypt = seqniv_aead_encrypt_first;
+	inst->alg.encrypt = seqniv_aead_encrypt;
 	inst->alg.decrypt = seqniv_aead_decrypt;
 
 	inst->alg.base.cra_init = seqniv_aead_init;
