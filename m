From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/16] crypto: pcrypt - Use crypto_grab_aead
Date: Thu, 21 May 2015 15:10:58 +0800
Message-ID: <E1YvKd8-0005d6-LO@gondolin.me.apana.org.au>
References: <20150521070915.GA20997@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37267 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbbEUHLB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 May 2015 03:11:01 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YvKd8-0002wu-Ud
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2015 17:10:59 +1000
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

 crypto/pcrypt.c |   71 +++++++++++++++++++++++++++-----------------------------
 1 file changed, 35 insertions(+), 36 deletions(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index ac115d5..3942a9f 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -60,7 +60,7 @@ static struct padata_pcrypt pdecrypt;
 static struct kset           *pcrypt_kset;
 
 struct pcrypt_instance_ctx {
-	struct crypto_spawn spawn;
+	struct crypto_aead_spawn spawn;
 	unsigned int tfm_count;
 };
 
@@ -307,57 +307,50 @@ static void pcrypt_aead_exit_tfm(struct crypto_tfm *tfm)
 	crypto_free_aead(ctx->child);
 }
 
-static struct crypto_instance *pcrypt_alloc_instance(struct crypto_alg *alg)
+static int pcrypt_init_instance(struct crypto_instance *inst,
+				struct crypto_alg *alg)
 {
-	struct crypto_instance *inst;
-	struct pcrypt_instance_ctx *ctx;
-	int err;
-
-	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
-	if (!inst) {
-		inst = ERR_PTR(-ENOMEM);
-		goto out;
-	}
-
-	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "pcrypt(%s)", alg->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
-		goto out_free_inst;
+		return -ENAMETOOLONG;
 
 	memcpy(inst->alg.cra_name, alg->cra_name, CRYPTO_MAX_ALG_NAME);
 
-	ctx = crypto_instance_ctx(inst);
-	err = crypto_init_spawn(&ctx->spawn, alg, inst,
-				CRYPTO_ALG_TYPE_MASK);
-	if (err)
-		goto out_free_inst;
-
 	inst->alg.cra_priority = alg->cra_priority + 100;
 	inst->alg.cra_blocksize = alg->cra_blocksize;
 	inst->alg.cra_alignmask = alg->cra_alignmask;
 
-out:
-	return inst;
-
-out_free_inst:
-	kfree(inst);
-	inst = ERR_PTR(err);
-	goto out;
+	return 0;
 }
 
 static struct crypto_instance *pcrypt_alloc_aead(struct rtattr **tb,
 						 u32 type, u32 mask)
 {
+	struct pcrypt_instance_ctx *ctx;
 	struct crypto_instance *inst;
 	struct crypto_alg *alg;
+	const char *name;
+	int err;
+
+	name = crypto_attr_alg_name(tb[1]);
+	if (IS_ERR(name))
+		return ERR_CAST(name);
+
+	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
+	if (!inst)
+		return ERR_PTR(-ENOMEM);
+
+	ctx = crypto_instance_ctx(inst);
+	crypto_set_aead_spawn(&ctx->spawn, inst);
 
-	alg = crypto_get_attr_alg(tb, type, (mask & CRYPTO_ALG_TYPE_MASK));
-	if (IS_ERR(alg))
-		return ERR_CAST(alg);
+	err = crypto_grab_aead(&ctx->spawn, name, 0, 0);
+	if (err)
+		goto out_free_inst;
 
-	inst = pcrypt_alloc_instance(alg);
-	if (IS_ERR(inst))
-		goto out_put_alg;
+	alg = crypto_aead_spawn_alg(&ctx->spawn);
+	err = pcrypt_init_instance(inst, alg);
+	if (err)
+		goto out_drop_aead;
 
 	inst->alg.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC;
 	inst->alg.cra_type = &crypto_aead_type;
@@ -377,9 +370,15 @@ static struct crypto_instance *pcrypt_alloc_aead(struct rtattr **tb,
 	inst->alg.cra_aead.decrypt = pcrypt_aead_decrypt;
 	inst->alg.cra_aead.givencrypt = pcrypt_aead_givencrypt;
 
-out_put_alg:
-	crypto_mod_put(alg);
+out:
 	return inst;
+
+out_drop_aead:
+	crypto_drop_aead(&ctx->spawn);
+out_free_inst:
+	kfree(inst);
+	inst = ERR_PTR(err);
+	goto out;
 }
 
 static struct crypto_instance *pcrypt_alloc(struct rtattr **tb)
@@ -402,7 +401,7 @@ static void pcrypt_free(struct crypto_instance *inst)
 {
 	struct pcrypt_instance_ctx *ctx = crypto_instance_ctx(inst);
 
-	crypto_drop_spawn(&ctx->spawn);
+	crypto_drop_aead(&ctx->spawn);
 	kfree(inst);
 }
 
