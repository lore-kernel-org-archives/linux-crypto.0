From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/8] crypto: echainiv - Move IV seeding into init function
Date: Wed, 03 Jun 2015 14:49:24 +0800
Message-ID: <E1Z02UO-0001Fs-S6@gondolin.me.apana.org.au>
References: <20150603064641.GA4655@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58971 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbbFCGt1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Jun 2015 02:49:27 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We currently do the IV seeding on the first givencrypt call in
order to conserve entropy.  However, this does not work with
DRBG which cannot be called from interrupt context.  In fact,
with DRBG we don't need to conserve entropy anyway.  So this
patch moves the seeding into the init function.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/echainiv.c |   30 ++++++------------------------
 1 file changed, 6 insertions(+), 24 deletions(-)

diff --git a/crypto/echainiv.c b/crypto/echainiv.c
index 62a817f..08d3336 100644
--- a/crypto/echainiv.c
+++ b/crypto/echainiv.c
@@ -187,29 +187,6 @@ static int echainiv_decrypt(struct aead_request *req)
 	return crypto_aead_decrypt(subreq);
 }
 
-static int echainiv_encrypt_first(struct aead_request *req)
-{
-	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
-	struct echainiv_ctx *ctx = crypto_aead_ctx(geniv);
-	int err = 0;
-
-	spin_lock_bh(&ctx->geniv.lock);
-	if (geniv->encrypt != echainiv_encrypt_first)
-		goto unlock;
-
-	geniv->encrypt = echainiv_encrypt;
-	err = crypto_rng_get_bytes(crypto_default_rng, ctx->salt,
-				   crypto_aead_ivsize(geniv));
-
-unlock:
-	spin_unlock_bh(&ctx->geniv.lock);
-
-	if (err)
-		return err;
-
-	return echainiv_encrypt(req);
-}
-
 static int echainiv_init(struct crypto_tfm *tfm)
 {
 	struct crypto_aead *geniv = __crypto_aead_cast(tfm);
@@ -220,6 +197,11 @@ static int echainiv_init(struct crypto_tfm *tfm)
 
 	crypto_aead_set_reqsize(geniv, sizeof(struct aead_request));
 
+	err = crypto_rng_get_bytes(crypto_default_rng, ctx->salt,
+				   crypto_aead_ivsize(geniv));
+	if (err)
+		goto out;
+
 	ctx->null = crypto_get_default_null_skcipher();
 	err = PTR_ERR(ctx->null);
 	if (IS_ERR(ctx->null))
@@ -272,7 +254,7 @@ static int echainiv_aead_create(struct crypto_template *tmpl,
 	    inst->alg.ivsize > MAX_IV_SIZE)
 		goto free_inst;
 
-	inst->alg.encrypt = echainiv_encrypt_first;
+	inst->alg.encrypt = echainiv_encrypt;
 	inst->alg.decrypt = echainiv_decrypt;
 
 	inst->alg.base.cra_init = echainiv_init;
