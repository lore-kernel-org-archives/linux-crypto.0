From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7/8] crypto: seqiv - Add compatibility support without RNG
Date: Sun, 21 Jun 2015 19:11:49 +0800
Message-ID: <E1Z6dAD-0007r5-AN@gondolin.me.apana.org.au>
References: <20150621110702.GA29747@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49499 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262AbbFULLx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 21 Jun 2015 07:11:53 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1Z6dAD-0000FU-Vw
	for <linux-crypto@vger.kernel.org>; Sun, 21 Jun 2015 21:11:50 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When seqiv is used in compatibility mode, this patch allows it
to function even when an RNG Is not available.  It also changes
the RNG allocation for the new explicit seqiv interface so that
we only hold a reference to the RNG during initialisation.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/seqiv.c |   50 +++++++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index 42e4ee5..122c56e 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -478,29 +478,42 @@ static int seqiv_init(struct crypto_tfm *tfm)
 {
 	struct crypto_ablkcipher *geniv = __crypto_ablkcipher_cast(tfm);
 	struct seqiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
+	int err;
 
 	spin_lock_init(&ctx->lock);
 
 	tfm->crt_ablkcipher.reqsize = sizeof(struct ablkcipher_request);
 
-	return crypto_rng_get_bytes(crypto_default_rng, ctx->salt,
-				    crypto_ablkcipher_ivsize(geniv)) ?:
-	       skcipher_geniv_init(tfm);
+	err = 0;
+	if (!crypto_get_default_rng()) {
+		crypto_ablkcipher_crt(geniv)->givencrypt = seqiv_givencrypt;
+		err = crypto_rng_get_bytes(crypto_default_rng, ctx->salt,
+					   crypto_ablkcipher_ivsize(geniv));
+		crypto_put_default_rng();
+	}
+
+	return err ?: skcipher_geniv_init(tfm);
 }
 
 static int seqiv_old_aead_init(struct crypto_tfm *tfm)
 {
 	struct crypto_aead *geniv = __crypto_aead_cast(tfm);
 	struct seqiv_ctx *ctx = crypto_aead_ctx(geniv);
+	int err;
 
 	spin_lock_init(&ctx->lock);
 
 	crypto_aead_set_reqsize(__crypto_aead_cast(tfm),
 				sizeof(struct aead_request));
+	err = 0;
+	if (!crypto_get_default_rng()) {
+		geniv->givencrypt = seqiv_aead_givencrypt;
+		err = crypto_rng_get_bytes(crypto_default_rng, ctx->salt,
+					   crypto_aead_ivsize(geniv));
+		crypto_put_default_rng();
+	}
 
-	return crypto_rng_get_bytes(crypto_default_rng, ctx->salt,
-				    crypto_aead_ivsize(geniv)) ?:
-	       aead_geniv_init(tfm);
+	return err ?: aead_geniv_init(tfm);
 }
 
 static int seqiv_aead_init_common(struct crypto_tfm *tfm, unsigned int reqsize)
@@ -513,8 +526,13 @@ static int seqiv_aead_init_common(struct crypto_tfm *tfm, unsigned int reqsize)
 
 	crypto_aead_set_reqsize(geniv, sizeof(struct aead_request));
 
+	err = crypto_get_default_rng();
+	if (err)
+		goto out;
+
 	err = crypto_rng_get_bytes(crypto_default_rng, ctx->salt,
 				   crypto_aead_ivsize(geniv));
+	crypto_put_default_rng();
 	if (err)
 		goto out;
 
@@ -571,8 +589,6 @@ static int seqiv_ablkcipher_create(struct crypto_template *tmpl,
 	if (inst->alg.cra_ablkcipher.ivsize < sizeof(u64))
 		goto free_inst;
 
-	inst->alg.cra_ablkcipher.givencrypt = seqiv_givencrypt;
-
 	inst->alg.cra_init = seqiv_init;
 	inst->alg.cra_exit = skcipher_geniv_exit;
 
@@ -602,8 +618,6 @@ static int seqiv_old_aead_create(struct crypto_template *tmpl,
 	if (inst->alg.cra_aead.ivsize < sizeof(u64))
 		goto free_inst;
 
-	inst->alg.cra_aead.givencrypt = seqiv_aead_givencrypt;
-
 	inst->alg.cra_init = seqiv_old_aead_init;
 	inst->alg.cra_exit = aead_geniv_exit;
 
@@ -680,18 +694,11 @@ static int seqiv_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (IS_ERR(algt))
 		return PTR_ERR(algt);
 
-	err = crypto_get_default_rng();
-	if (err)
-		return err;
-
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & CRYPTO_ALG_TYPE_MASK)
 		err = seqiv_ablkcipher_create(tmpl, tb);
 	else
 		err = seqiv_aead_create(tmpl, tb);
 
-	if (err)
-		crypto_put_default_rng();
-
 	return err;
 }
 
@@ -702,14 +709,10 @@ static int seqniv_create(struct crypto_template *tmpl, struct rtattr **tb)
 	struct aead_alg *alg;
 	int err;
 
-	err = crypto_get_default_rng();
-	if (err)
-		return err;
-
 	inst = aead_geniv_alloc(tmpl, tb, 0, 0);
 	err = PTR_ERR(inst);
 	if (IS_ERR(inst))
-		goto put_rng;
+		goto out;
 
 	spawn = aead_instance_ctx(inst);
 	alg = crypto_spawn_aead_alg(spawn);
@@ -741,8 +744,6 @@ out:
 
 free_inst:
 	aead_geniv_free(inst);
-put_rng:
-	crypto_put_default_rng();
 	goto out;
 }
 
@@ -752,7 +753,6 @@ static void seqiv_free(struct crypto_instance *inst)
 		skcipher_geniv_free(inst);
 	else
 		aead_geniv_free(aead_instance(inst));
-	crypto_put_default_rng();
 }
 
 static struct crypto_template seqiv_tmpl = {
