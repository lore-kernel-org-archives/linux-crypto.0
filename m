From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 8/8] [CRYPTO] gcm: Allow block cipher parameter
Date: Tue, 11 Dec 2007 11:50:27 +0800
Message-ID: <E1J1w8Z-0002es-00@gondolin.me.apana.org.au>
References: <20071211034945.GA10099@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1781 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751817AbXLKDud (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Dec 2007 22:50:33 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J1w8a-0005pr-T7
	for <linux-crypto@vger.kernel.org>; Tue, 11 Dec 2007 14:50:29 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] gcm: Allow block cipher parameter

This patch adds the gcm_base template which takes a block cipher
parameter instead of cipher.  This allows the user to specify a
specific CTR implementation.

This also fixes a leak of the cipher algorithm that was previously
looked up but never freed.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/gcm.c |  122 ++++++++++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 96 insertions(+), 26 deletions(-)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index 1624301..9c29765 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -381,30 +381,24 @@ static void crypto_gcm_exit_tfm(struct crypto_tfm *tfm)
 	crypto_free_ablkcipher(ctx->ctr);
 }
 
-static struct crypto_instance *crypto_gcm_alloc(struct rtattr **tb)
+static struct crypto_instance *crypto_gcm_alloc_common(struct rtattr **tb,
+						       const char *full_name,
+						       const char *ctr_name,
+						       const char *cipher_name)
 {
+	struct crypto_attr_type *algt;
 	struct crypto_instance *inst;
 	struct crypto_alg *ctr;
-	struct crypto_alg *cipher;
 	struct gcm_instance_ctx *ctx;
 	int err;
-	char ctr_name[CRYPTO_MAX_ALG_NAME];
 
-	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_AEAD);
-	if (err)
+	algt = crypto_get_attr_type(tb);
+	err = PTR_ERR(algt);
+	if (IS_ERR(algt))
 		return ERR_PTR(err);
 
-	cipher = crypto_attr_alg(tb[1], CRYPTO_ALG_TYPE_CIPHER,
-			      CRYPTO_ALG_TYPE_MASK);
-
-	inst = ERR_PTR(PTR_ERR(cipher));
-	if (IS_ERR(cipher))
-		return inst;
-
-	inst = ERR_PTR(ENAMETOOLONG);
-	if (snprintf(ctr_name, CRYPTO_MAX_ALG_NAME, "rfc3686(ctr(%s))",
-		     cipher->cra_name) >= CRYPTO_MAX_ALG_NAME)
-		return inst;
+	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
+		return ERR_PTR(-EINVAL);
 
 	ctr = crypto_alg_mod_lookup(ctr_name, CRYPTO_ALG_TYPE_BLKCIPHER,
 				    CRYPTO_ALG_TYPE_MASK);
@@ -412,29 +406,34 @@ static struct crypto_instance *crypto_gcm_alloc(struct rtattr **tb)
 	if (IS_ERR(ctr))
 		return ERR_PTR(PTR_ERR(ctr));
 
+	/* Not a stream cipher? */
+	err = -EINVAL;
+	if (ctr->cra_blocksize != 1)
+		goto out_put_ctr;
+
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	err = -ENOMEM;
 	if (!inst)
 		goto out_put_ctr;
 
 	err = -ENAMETOOLONG;
-	if (snprintf(inst->alg.cra_name, CRYPTO_MAX_ALG_NAME,
-		     "gcm(%s)", cipher->cra_name) >= CRYPTO_MAX_ALG_NAME ||
-	    snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
-		     "gcm(%s)", cipher->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
-		goto err_free_inst;
-
+	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
+		     "gcm_base(%s,%s)", ctr->cra_driver_name, cipher_name) >=
+	    CRYPTO_MAX_ALG_NAME)
+		goto out_put_ctr;
 
 	ctx = crypto_instance_ctx(inst);
 	err = crypto_init_spawn(&ctx->ctr, ctr, inst, CRYPTO_ALG_TYPE_MASK);
 	if (err)
 		goto err_free_inst;
 
-	memcpy(ctx->cipher_name, cipher->cra_driver_name, CRYPTO_MAX_ALG_NAME);
+	memcpy(inst->alg.cra_name, full_name, CRYPTO_MAX_ALG_NAME);
+	memcpy(ctx->cipher_name, cipher_name, CRYPTO_MAX_ALG_NAME);
 
-	inst->alg.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC;
+	inst->alg.cra_flags = CRYPTO_ALG_TYPE_AEAD;
+	inst->alg.cra_flags |= ctr->cra_flags & CRYPTO_ALG_ASYNC;
 	inst->alg.cra_priority = ctr->cra_priority;
-	inst->alg.cra_blocksize = 16;
+	inst->alg.cra_blocksize = 1;
 	inst->alg.cra_alignmask = ctr->cra_alignmask | (__alignof__(u64) - 1);
 	inst->alg.cra_type = &crypto_aead_type;
 	inst->alg.cra_aead.ivsize = 12;
@@ -456,6 +455,29 @@ out_put_ctr:
 	goto out;
 }
 
+static struct crypto_instance *crypto_gcm_alloc(struct rtattr **tb)
+{
+	int err;
+	const char *cipher_name;
+	char ctr_name[CRYPTO_MAX_ALG_NAME];
+	char full_name[CRYPTO_MAX_ALG_NAME];
+
+	cipher_name = crypto_attr_alg_name(tb[1]);
+	err = PTR_ERR(cipher_name);
+	if (IS_ERR(cipher_name))
+		return ERR_PTR(err);
+
+	if (snprintf(ctr_name, CRYPTO_MAX_ALG_NAME, "rfc3686(ctr(%s))",
+		     cipher_name) >= CRYPTO_MAX_ALG_NAME)
+		return ERR_PTR(-ENAMETOOLONG);
+
+	if (snprintf(full_name, CRYPTO_MAX_ALG_NAME, "gcm(%s)", cipher_name) >=
+	    CRYPTO_MAX_ALG_NAME)
+		return ERR_PTR(-ENAMETOOLONG);
+
+	return crypto_gcm_alloc_common(tb, full_name, ctr_name, cipher_name);
+}
+
 static void crypto_gcm_free(struct crypto_instance *inst)
 {
 	struct gcm_instance_ctx *ctx = crypto_instance_ctx(inst);
@@ -471,14 +493,61 @@ static struct crypto_template crypto_gcm_tmpl = {
 	.module = THIS_MODULE,
 };
 
+static struct crypto_instance *crypto_gcm_base_alloc(struct rtattr **tb)
+{
+	int err;
+	const char *ctr_name;
+	const char *cipher_name;
+	char full_name[CRYPTO_MAX_ALG_NAME];
+
+	ctr_name = crypto_attr_alg_name(tb[1]);
+	err = PTR_ERR(ctr_name);
+	if (IS_ERR(ctr_name))
+		return ERR_PTR(err);
+
+	cipher_name = crypto_attr_alg_name(tb[2]);
+	err = PTR_ERR(cipher_name);
+	if (IS_ERR(cipher_name))
+		return ERR_PTR(err);
+
+	if (snprintf(full_name, CRYPTO_MAX_ALG_NAME, "gcm_base(%s,%s)",
+		     ctr_name, cipher_name) >= CRYPTO_MAX_ALG_NAME)
+		return ERR_PTR(-ENAMETOOLONG);
+
+	return crypto_gcm_alloc_common(tb, full_name, ctr_name, cipher_name);
+}
+
+static struct crypto_template crypto_gcm_base_tmpl = {
+	.name = "gcm_base",
+	.alloc = crypto_gcm_base_alloc,
+	.free = crypto_gcm_free,
+	.module = THIS_MODULE,
+};
+
 static int __init crypto_gcm_module_init(void)
 {
-	return crypto_register_template(&crypto_gcm_tmpl);
+	int err;
+
+	err = crypto_register_template(&crypto_gcm_base_tmpl);
+	if (err)
+		goto out;
+
+	err = crypto_register_template(&crypto_gcm_tmpl);
+	if (err)
+		goto out_undo_base;
+
+out:
+	return err;
+
+out_undo_base:
+	crypto_unregister_template(&crypto_gcm_base_tmpl);
+	goto out;
 }
 
 static void __exit crypto_gcm_module_exit(void)
 {
 	crypto_unregister_template(&crypto_gcm_tmpl);
+	crypto_unregister_template(&crypto_gcm_base_tmpl);
 }
 
 module_init(crypto_gcm_module_init);
@@ -487,3 +556,4 @@ module_exit(crypto_gcm_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Galois/Counter Mode");
 MODULE_AUTHOR("Mikko Herranen <mh1@iki.fi>");
+MODULE_ALIAS("gcm_base");
