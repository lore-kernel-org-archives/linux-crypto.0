From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6/8] crypto: eseqiv - Offer normal cipher functionality without RNG
Date: Sun, 21 Jun 2015 19:11:47 +0800
Message-ID: <E1Z6dAB-0007qo-VT@gondolin.me.apana.org.au>
References: <20150621110702.GA29747@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53719 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbbFULLv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 21 Jun 2015 07:11:51 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1Z6dAC-0000FM-Gf
	for <linux-crypto@vger.kernel.org>; Sun, 21 Jun 2015 21:11:48 +1000
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

 crypto/eseqiv.c |   31 ++++++++++++-------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/crypto/eseqiv.c b/crypto/eseqiv.c
index 78a7264..16dda72 100644
--- a/crypto/eseqiv.c
+++ b/crypto/eseqiv.c
@@ -152,6 +152,7 @@ static int eseqiv_init(struct crypto_tfm *tfm)
 	struct eseqiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
 	unsigned long alignmask;
 	unsigned int reqsize;
+	int err;
 
 	spin_lock_init(&ctx->lock);
 
@@ -175,9 +176,15 @@ static int eseqiv_init(struct crypto_tfm *tfm)
 	tfm->crt_ablkcipher.reqsize = reqsize +
 				      sizeof(struct ablkcipher_request);
 
-	return crypto_rng_get_bytes(crypto_default_rng, ctx->salt,
-				    crypto_ablkcipher_ivsize(geniv)) ?:
-	       skcipher_geniv_init(tfm);
+	err = 0;
+	if (!crypto_get_default_rng()) {
+		crypto_ablkcipher_crt(geniv)->givencrypt = eseqiv_givencrypt;
+		err = crypto_rng_get_bytes(crypto_default_rng, ctx->salt,
+					   crypto_ablkcipher_ivsize(geniv));
+		crypto_put_default_rng();
+	}
+
+	return err ?: skcipher_geniv_init(tfm);
 }
 
 static struct crypto_template eseqiv_tmpl;
@@ -187,20 +194,14 @@ static struct crypto_instance *eseqiv_alloc(struct rtattr **tb)
 	struct crypto_instance *inst;
 	int err;
 
-	err = crypto_get_default_rng();
-	if (err)
-		return ERR_PTR(err);
-
 	inst = skcipher_geniv_alloc(&eseqiv_tmpl, tb, 0, 0);
 	if (IS_ERR(inst))
-		goto put_rng;
+		goto out;
 
 	err = -EINVAL;
 	if (inst->alg.cra_ablkcipher.ivsize != inst->alg.cra_blocksize)
 		goto free_inst;
 
-	inst->alg.cra_ablkcipher.givencrypt = eseqiv_givencrypt;
-
 	inst->alg.cra_init = eseqiv_init;
 	inst->alg.cra_exit = skcipher_geniv_exit;
 
@@ -213,21 +214,13 @@ out:
 free_inst:
 	skcipher_geniv_free(inst);
 	inst = ERR_PTR(err);
-put_rng:
-	crypto_put_default_rng();
 	goto out;
 }
 
-static void eseqiv_free(struct crypto_instance *inst)
-{
-	skcipher_geniv_free(inst);
-	crypto_put_default_rng();
-}
-
 static struct crypto_template eseqiv_tmpl = {
 	.name = "eseqiv",
 	.alloc = eseqiv_alloc,
-	.free = eseqiv_free,
+	.free = skcipher_geniv_free,
 	.module = THIS_MODULE,
 };
 
