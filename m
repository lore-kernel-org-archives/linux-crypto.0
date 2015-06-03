From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/8] crypto: chainiv - Move IV seeding into init function
Date: Wed, 03 Jun 2015 14:49:23 +0800
Message-ID: <E1Z02UN-0001FN-Mo@gondolin.me.apana.org.au>
References: <20150603064641.GA4655@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55924 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbbFCGt1 (ORCPT
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

 crypto/chainiv.c |   66 +++++++------------------------------------------------
 1 file changed, 9 insertions(+), 57 deletions(-)

diff --git a/crypto/chainiv.c b/crypto/chainiv.c
index 63c17d5..be0bd52 100644
--- a/crypto/chainiv.c
+++ b/crypto/chainiv.c
@@ -80,35 +80,15 @@ unlock:
 	return err;
 }
 
-static int chainiv_givencrypt_first(struct skcipher_givcrypt_request *req)
+static int chainiv_init_common(struct crypto_tfm *tfm, char iv[])
 {
-	struct crypto_ablkcipher *geniv = skcipher_givcrypt_reqtfm(req);
-	struct chainiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
-	int err = 0;
-
-	spin_lock_bh(&ctx->lock);
-	if (crypto_ablkcipher_crt(geniv)->givencrypt !=
-	    chainiv_givencrypt_first)
-		goto unlock;
-
-	crypto_ablkcipher_crt(geniv)->givencrypt = chainiv_givencrypt;
-	err = crypto_rng_get_bytes(crypto_default_rng, ctx->iv,
-				   crypto_ablkcipher_ivsize(geniv));
-
-unlock:
-	spin_unlock_bh(&ctx->lock);
+	struct crypto_ablkcipher *geniv = __crypto_ablkcipher_cast(tfm);
 
-	if (err)
-		return err;
-
-	return chainiv_givencrypt(req);
-}
-
-static int chainiv_init_common(struct crypto_tfm *tfm)
-{
 	tfm->crt_ablkcipher.reqsize = sizeof(struct ablkcipher_request);
 
-	return skcipher_geniv_init(tfm);
+	return crypto_rng_get_bytes(crypto_default_rng, iv,
+				    crypto_ablkcipher_ivsize(geniv)) ?:
+	       skcipher_geniv_init(tfm);
 }
 
 static int chainiv_init(struct crypto_tfm *tfm)
@@ -117,7 +97,7 @@ static int chainiv_init(struct crypto_tfm *tfm)
 
 	spin_lock_init(&ctx->lock);
 
-	return chainiv_init_common(tfm);
+	return chainiv_init_common(tfm, ctx->iv);
 }
 
 static int async_chainiv_schedule_work(struct async_chainiv_ctx *ctx)
@@ -205,33 +185,6 @@ postpone:
 	return async_chainiv_postpone_request(req);
 }
 
-static int async_chainiv_givencrypt_first(struct skcipher_givcrypt_request *req)
-{
-	struct crypto_ablkcipher *geniv = skcipher_givcrypt_reqtfm(req);
-	struct async_chainiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
-	int err = 0;
-
-	if (test_and_set_bit(CHAINIV_STATE_INUSE, &ctx->state))
-		goto out;
-
-	if (crypto_ablkcipher_crt(geniv)->givencrypt !=
-	    async_chainiv_givencrypt_first)
-		goto unlock;
-
-	crypto_ablkcipher_crt(geniv)->givencrypt = async_chainiv_givencrypt;
-	err = crypto_rng_get_bytes(crypto_default_rng, ctx->iv,
-				   crypto_ablkcipher_ivsize(geniv));
-
-unlock:
-	clear_bit(CHAINIV_STATE_INUSE, &ctx->state);
-
-	if (err)
-		return err;
-
-out:
-	return async_chainiv_givencrypt(req);
-}
-
 static void async_chainiv_do_postponed(struct work_struct *work)
 {
 	struct async_chainiv_ctx *ctx = container_of(work,
@@ -270,7 +223,7 @@ static int async_chainiv_init(struct crypto_tfm *tfm)
 	crypto_init_queue(&ctx->queue, 100);
 	INIT_WORK(&ctx->postponed, async_chainiv_do_postponed);
 
-	return chainiv_init_common(tfm);
+	return chainiv_init_common(tfm, ctx->iv);
 }
 
 static void async_chainiv_exit(struct crypto_tfm *tfm)
@@ -302,7 +255,7 @@ static struct crypto_instance *chainiv_alloc(struct rtattr **tb)
 	if (IS_ERR(inst))
 		goto put_rng;
 
-	inst->alg.cra_ablkcipher.givencrypt = chainiv_givencrypt_first;
+	inst->alg.cra_ablkcipher.givencrypt = chainiv_givencrypt;
 
 	inst->alg.cra_init = chainiv_init;
 	inst->alg.cra_exit = skcipher_geniv_exit;
@@ -312,8 +265,7 @@ static struct crypto_instance *chainiv_alloc(struct rtattr **tb)
 	if (!crypto_requires_sync(algt->type, algt->mask)) {
 		inst->alg.cra_flags |= CRYPTO_ALG_ASYNC;
 
-		inst->alg.cra_ablkcipher.givencrypt =
-			async_chainiv_givencrypt_first;
+		inst->alg.cra_ablkcipher.givencrypt = async_chainiv_givencrypt;
 
 		inst->alg.cra_init = async_chainiv_init;
 		inst->alg.cra_exit = async_chainiv_exit;
