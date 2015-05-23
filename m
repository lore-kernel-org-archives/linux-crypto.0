From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/8] crypto: echainiv - Use aead_register_instance
Date: Sat, 23 May 2015 15:41:52 +0800
Message-ID: <E1Yw448-0003sT-6A@gondolin.me.apana.org.au>
References: <20150523074058.GA14781@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46601 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757196AbbEWHlz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 23 May 2015 03:41:55 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1Yw448-00032r-LS
	for <linux-crypto@vger.kernel.org>; Sat, 23 May 2015 17:41:52 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

New style AEAD instances must use aead_register_instance.  This
worked by chance because aead_geniv_alloc is still setting things
the old way.

This patch converts the template over to the create model where
we are responsible for instance registration so that we can call
the correct function.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/echainiv.c |   42 +++++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/crypto/echainiv.c b/crypto/echainiv.c
index e5a9878..86e92fa 100644
--- a/crypto/echainiv.c
+++ b/crypto/echainiv.c
@@ -430,26 +430,24 @@ static void echainiv_exit(struct crypto_tfm *tfm)
 	crypto_put_default_null_skcipher();
 }
 
-static struct crypto_template echainiv_tmpl;
-
-static struct crypto_instance *echainiv_aead_alloc(struct rtattr **tb)
+static int echainiv_aead_create(struct crypto_template *tmpl,
+				struct rtattr **tb)
 {
 	struct aead_instance *inst;
 	struct crypto_aead_spawn *spawn;
 	struct aead_alg *alg;
+	int err;
 
-	inst = aead_geniv_alloc(&echainiv_tmpl, tb, 0, 0);
+	inst = aead_geniv_alloc(tmpl, tb, 0, 0);
 
 	if (IS_ERR(inst))
-		goto out;
+		return PTR_ERR(inst);
 
+	err = -EINVAL;
 	if (inst->alg.ivsize < sizeof(u64) ||
 	    inst->alg.ivsize & (sizeof(u32) - 1) ||
-	    inst->alg.ivsize > MAX_IV_SIZE) {
-		aead_geniv_free(inst);
-		inst = ERR_PTR(-EINVAL);
-		goto out;
-	}
+	    inst->alg.ivsize > MAX_IV_SIZE)
+		goto free_inst;
 
 	spawn = aead_instance_ctx(inst);
 	alg = crypto_spawn_aead_alg(spawn);
@@ -474,26 +472,32 @@ static struct crypto_instance *echainiv_aead_alloc(struct rtattr **tb)
 		inst->alg.base.cra_exit = echainiv_compat_exit;
 	}
 
+	err = aead_register_instance(tmpl, inst);
+	if (err)
+		goto free_inst;
+
 out:
-	return aead_crypto_instance(inst);
+	return err;
+
+free_inst:
+	aead_geniv_free(inst);
+	goto out;
 }
 
-static struct crypto_instance *echainiv_alloc(struct rtattr **tb)
+static int echainiv_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
-	struct crypto_instance *inst;
 	int err;
 
 	err = crypto_get_default_rng();
 	if (err)
-		return ERR_PTR(err);
-
-	inst = echainiv_aead_alloc(tb);
+		goto out;
 
-	if (IS_ERR(inst))
+	err = echainiv_aead_create(tmpl, tb);
+	if (err)
 		goto put_rng;
 
 out:
-	return inst;
+	return err;
 
 put_rng:
 	crypto_put_default_rng();
@@ -508,7 +512,7 @@ static void echainiv_free(struct crypto_instance *inst)
 
 static struct crypto_template echainiv_tmpl = {
 	.name = "echainiv",
-	.alloc = echainiv_alloc,
+	.create = echainiv_create,
 	.free = echainiv_free,
 	.module = THIS_MODULE,
 };
