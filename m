From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/8] crypto: chainiv - Offer normal cipher functionality without RNG
Date: Sun, 21 Jun 2015 19:11:46 +0800
Message-ID: <E1Z6dAA-0007qW-Pg@gondolin.me.apana.org.au>
References: <20150621110702.GA29747@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56806 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbbFULLu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 21 Jun 2015 07:11:50 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1Z6dAB-0000FD-54
	for <linux-crypto@vger.kernel.org>; Sun, 21 Jun 2015 21:11:47 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The RNG may not be available during early boot, e.g., the relevant
modules may not be included in the initramfs.  As the RNG Is only
needed for IPsec, we should not let this prevent use of ciphers
without IV generators, e.g., for disk encryption.

This patch postpones the RNG allocation to the init function so
that one failure during early boot does not make the RNG unavailable
for all subsequent users of the same cipher.

More importantly, it lets the cipher live even if RNG allocation
fails.  Of course we no longer offer IV generation and which will
fail with an error if invoked.  But all other cipher capabilities
will function as usual.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/chainiv.c |   55 +++++++++++++++++++++++++++++--------------------------
 1 file changed, 29 insertions(+), 26 deletions(-)

diff --git a/crypto/chainiv.c b/crypto/chainiv.c
index be0bd52..b434001 100644
--- a/crypto/chainiv.c
+++ b/crypto/chainiv.c
@@ -83,21 +83,34 @@ unlock:
 static int chainiv_init_common(struct crypto_tfm *tfm, char iv[])
 {
 	struct crypto_ablkcipher *geniv = __crypto_ablkcipher_cast(tfm);
+	int err = 0;
 
 	tfm->crt_ablkcipher.reqsize = sizeof(struct ablkcipher_request);
 
-	return crypto_rng_get_bytes(crypto_default_rng, iv,
-				    crypto_ablkcipher_ivsize(geniv)) ?:
-	       skcipher_geniv_init(tfm);
+	if (iv) {
+		err = crypto_rng_get_bytes(crypto_default_rng, iv,
+					   crypto_ablkcipher_ivsize(geniv));
+		crypto_put_default_rng();
+	}
+
+	return err ?: skcipher_geniv_init(tfm);
 }
 
 static int chainiv_init(struct crypto_tfm *tfm)
 {
+	struct crypto_ablkcipher *geniv = __crypto_ablkcipher_cast(tfm);
 	struct chainiv_ctx *ctx = crypto_tfm_ctx(tfm);
+	char *iv;
 
 	spin_lock_init(&ctx->lock);
 
-	return chainiv_init_common(tfm, ctx->iv);
+	iv = NULL;
+	if (!crypto_get_default_rng()) {
+		crypto_ablkcipher_crt(geniv)->givencrypt = chainiv_givencrypt;
+		iv = ctx->iv;
+	}
+
+	return chainiv_init_common(tfm, iv);
 }
 
 static int async_chainiv_schedule_work(struct async_chainiv_ctx *ctx)
@@ -216,14 +229,23 @@ static void async_chainiv_do_postponed(struct work_struct *work)
 
 static int async_chainiv_init(struct crypto_tfm *tfm)
 {
+	struct crypto_ablkcipher *geniv = __crypto_ablkcipher_cast(tfm);
 	struct async_chainiv_ctx *ctx = crypto_tfm_ctx(tfm);
+	char *iv;
 
 	spin_lock_init(&ctx->lock);
 
 	crypto_init_queue(&ctx->queue, 100);
 	INIT_WORK(&ctx->postponed, async_chainiv_do_postponed);
 
-	return chainiv_init_common(tfm, ctx->iv);
+	iv = NULL;
+	if (!crypto_get_default_rng()) {
+		crypto_ablkcipher_crt(geniv)->givencrypt =
+			async_chainiv_givencrypt;
+		iv = ctx->iv;
+	}
+
+	return chainiv_init_common(tfm, iv);
 }
 
 static void async_chainiv_exit(struct crypto_tfm *tfm)
@@ -241,21 +263,14 @@ static struct crypto_instance *chainiv_alloc(struct rtattr **tb)
 {
 	struct crypto_attr_type *algt;
 	struct crypto_instance *inst;
-	int err;
 
 	algt = crypto_get_attr_type(tb);
 	if (IS_ERR(algt))
 		return ERR_CAST(algt);
 
-	err = crypto_get_default_rng();
-	if (err)
-		return ERR_PTR(err);
-
 	inst = skcipher_geniv_alloc(&chainiv_tmpl, tb, 0, 0);
 	if (IS_ERR(inst))
-		goto put_rng;
-
-	inst->alg.cra_ablkcipher.givencrypt = chainiv_givencrypt;
+		goto out;
 
 	inst->alg.cra_init = chainiv_init;
 	inst->alg.cra_exit = skcipher_geniv_exit;
@@ -265,8 +280,6 @@ static struct crypto_instance *chainiv_alloc(struct rtattr **tb)
 	if (!crypto_requires_sync(algt->type, algt->mask)) {
 		inst->alg.cra_flags |= CRYPTO_ALG_ASYNC;
 
-		inst->alg.cra_ablkcipher.givencrypt = async_chainiv_givencrypt;
-
 		inst->alg.cra_init = async_chainiv_init;
 		inst->alg.cra_exit = async_chainiv_exit;
 
@@ -277,22 +290,12 @@ static struct crypto_instance *chainiv_alloc(struct rtattr **tb)
 
 out:
 	return inst;
-
-put_rng:
-	crypto_put_default_rng();
-	goto out;
-}
-
-static void chainiv_free(struct crypto_instance *inst)
-{
-	skcipher_geniv_free(inst);
-	crypto_put_default_rng();
 }
 
 static struct crypto_template chainiv_tmpl = {
 	.name = "chainiv",
 	.alloc = chainiv_alloc,
-	.free = chainiv_free,
+	.free = skcipher_geniv_free,
 	.module = THIS_MODULE,
 };
 
