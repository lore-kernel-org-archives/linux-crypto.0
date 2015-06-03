From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/8] crypto: eseqiv - Move IV seeding into init function
Date: Wed, 03 Jun 2015 14:49:25 +0800
Message-ID: <E1Z02UP-0001GG-Va@gondolin.me.apana.org.au>
References: <20150603064641.GA4655@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33011 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbbFCGt3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Jun 2015 02:49:29 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We currently do the IV seeding on the first givencrypt call in
order to conserve entropy.  However, this does not work with
DRBG which cannot be called from interrupt context.  In fact,
with DRBG we don't need to conserve entropy anyway.  So this
patch moves the seeding into the init function.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/eseqiv.c |   29 ++++-------------------------
 1 file changed, 4 insertions(+), 25 deletions(-)

diff --git a/crypto/eseqiv.c b/crypto/eseqiv.c
index f116fae..78a7264 100644
--- a/crypto/eseqiv.c
+++ b/crypto/eseqiv.c
@@ -146,29 +146,6 @@ out:
 	return err;
 }
 
-static int eseqiv_givencrypt_first(struct skcipher_givcrypt_request *req)
-{
-	struct crypto_ablkcipher *geniv = skcipher_givcrypt_reqtfm(req);
-	struct eseqiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
-	int err = 0;
-
-	spin_lock_bh(&ctx->lock);
-	if (crypto_ablkcipher_crt(geniv)->givencrypt != eseqiv_givencrypt_first)
-		goto unlock;
-
-	crypto_ablkcipher_crt(geniv)->givencrypt = eseqiv_givencrypt;
-	err = crypto_rng_get_bytes(crypto_default_rng, ctx->salt,
-				   crypto_ablkcipher_ivsize(geniv));
-
-unlock:
-	spin_unlock_bh(&ctx->lock);
-
-	if (err)
-		return err;
-
-	return eseqiv_givencrypt(req);
-}
-
 static int eseqiv_init(struct crypto_tfm *tfm)
 {
 	struct crypto_ablkcipher *geniv = __crypto_ablkcipher_cast(tfm);
@@ -198,7 +175,9 @@ static int eseqiv_init(struct crypto_tfm *tfm)
 	tfm->crt_ablkcipher.reqsize = reqsize +
 				      sizeof(struct ablkcipher_request);
 
-	return skcipher_geniv_init(tfm);
+	return crypto_rng_get_bytes(crypto_default_rng, ctx->salt,
+				    crypto_ablkcipher_ivsize(geniv)) ?:
+	       skcipher_geniv_init(tfm);
 }
 
 static struct crypto_template eseqiv_tmpl;
@@ -220,7 +199,7 @@ static struct crypto_instance *eseqiv_alloc(struct rtattr **tb)
 	if (inst->alg.cra_ablkcipher.ivsize != inst->alg.cra_blocksize)
 		goto free_inst;
 
-	inst->alg.cra_ablkcipher.givencrypt = eseqiv_givencrypt_first;
+	inst->alg.cra_ablkcipher.givencrypt = eseqiv_givencrypt;
 
 	inst->alg.cra_init = eseqiv_init;
 	inst->alg.cra_exit = skcipher_geniv_exit;
