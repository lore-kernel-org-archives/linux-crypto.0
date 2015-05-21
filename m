From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/16] crypto: cryptd - Use crypto_grab_aead
Date: Thu, 21 May 2015 15:10:57 +0800
Message-ID: <E1YvKd7-0005cn-Fh@gondolin.me.apana.org.au>
References: <20150521070915.GA20997@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51791 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbbEUHLA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 May 2015 03:11:00 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YvKd7-0002wm-P7
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2015 17:10:58 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As AEAD has switched over to using frontend types, the function
crypto_init_spawn must not be used since it does not specify a
frontend type.  Otherwise it leads to a crash when the spawn is
used.

This patch fixes it by switching over to crypto_grab_aead instead.

Fixes: 5d1d65f8bea6 ("crypto: aead - Convert top level interface to new style")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/cryptd.c |   60 ++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 37 insertions(+), 23 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index e1584fb..4264c8d 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -295,6 +295,23 @@ static void cryptd_blkcipher_exit_tfm(struct crypto_tfm *tfm)
 	crypto_free_blkcipher(ctx->child);
 }
 
+static int cryptd_init_instance(struct crypto_instance *inst,
+				struct crypto_alg *alg)
+{
+	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
+		     "cryptd(%s)",
+		     alg->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
+		return -ENAMETOOLONG;
+
+	memcpy(inst->alg.cra_name, alg->cra_name, CRYPTO_MAX_ALG_NAME);
+
+	inst->alg.cra_priority = alg->cra_priority + 50;
+	inst->alg.cra_blocksize = alg->cra_blocksize;
+	inst->alg.cra_alignmask = alg->cra_alignmask;
+
+	return 0;
+}
+
 static void *cryptd_alloc_instance(struct crypto_alg *alg, unsigned int head,
 				   unsigned int tail)
 {
@@ -308,17 +325,10 @@ static void *cryptd_alloc_instance(struct crypto_alg *alg, unsigned int head,
 
 	inst = (void *)(p + head);
 
-	err = -ENAMETOOLONG;
-	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
-		     "cryptd(%s)", alg->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
+	err = cryptd_init_instance(inst, alg);
+	if (err)
 		goto out_free_inst;
 
-	memcpy(inst->alg.cra_name, alg->cra_name, CRYPTO_MAX_ALG_NAME);
-
-	inst->alg.cra_priority = alg->cra_priority + 50;
-	inst->alg.cra_blocksize = alg->cra_blocksize;
-	inst->alg.cra_alignmask = alg->cra_alignmask;
-
 out:
 	return p;
 
@@ -747,29 +757,34 @@ static int cryptd_create_aead(struct crypto_template *tmpl,
 	struct aead_instance_ctx *ctx;
 	struct crypto_instance *inst;
 	struct crypto_alg *alg;
-	u32 type = CRYPTO_ALG_TYPE_AEAD;
-	u32 mask = CRYPTO_ALG_TYPE_MASK;
+	const char *name;
+	u32 type = 0;
+	u32 mask = 0;
 	int err;
 
 	cryptd_check_internal(tb, &type, &mask);
 
-	alg = crypto_get_attr_alg(tb, type, mask);
-        if (IS_ERR(alg))
-		return PTR_ERR(alg);
+	name = crypto_attr_alg_name(tb[1]);
+	if (IS_ERR(name))
+		return PTR_ERR(name);
 
-	inst = cryptd_alloc_instance(alg, 0, sizeof(*ctx));
-	err = PTR_ERR(inst);
-	if (IS_ERR(inst))
-		goto out_put_alg;
+	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
+	if (!inst)
+		return -ENOMEM;
 
 	ctx = crypto_instance_ctx(inst);
 	ctx->queue = queue;
 
-	err = crypto_init_spawn(&ctx->aead_spawn.base, alg, inst,
-			CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_ASYNC);
+	crypto_set_aead_spawn(&ctx->aead_spawn, inst);
+	err = crypto_grab_aead(&ctx->aead_spawn, name, type, mask);
 	if (err)
 		goto out_free_inst;
 
+	alg = crypto_aead_spawn_alg(&ctx->aead_spawn);
+	err = cryptd_init_instance(inst, alg);
+	if (err)
+		goto out_drop_aead;
+
 	type = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC;
 	if (alg->cra_flags & CRYPTO_ALG_INTERNAL)
 		type |= CRYPTO_ALG_INTERNAL;
@@ -790,12 +805,11 @@ static int cryptd_create_aead(struct crypto_template *tmpl,
 
 	err = crypto_register_instance(tmpl, inst);
 	if (err) {
-		crypto_drop_spawn(&ctx->aead_spawn.base);
+out_drop_aead:
+		crypto_drop_aead(&ctx->aead_spawn);
 out_free_inst:
 		kfree(inst);
 	}
-out_put_alg:
-	crypto_mod_put(alg);
 	return err;
 }
 
