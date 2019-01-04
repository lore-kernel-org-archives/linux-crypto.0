Return-Path: <SRS0=8/la=PM=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727731AbfADEU5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jan 2019 23:20:57 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 11/16] crypto: ofb - convert to skcipher_alloc_instance_simple()
Date: Thu,  3 Jan 2019 20:16:20 -0800
Message-Id: <20190104041625.3259-12-ebiggers@kernel.org>
In-Reply-To: <20190104041625.3259-1-ebiggers@kernel.org>
References: <20190104041625.3259-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

The OFB template just wraps a single block cipher algorithm, so simplify
it by converting it to use skcipher_alloc_instance_simple().

Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/ofb.c | 119 +++------------------------------------------------
 1 file changed, 7 insertions(+), 112 deletions(-)

diff --git a/crypto/ofb.c b/crypto/ofb.c
index cab0b80953fed..34b6e1f426f7a 100644
--- a/crypto/ofb.c
+++ b/crypto/ofb.c
@@ -13,35 +13,11 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/scatterlist.h>
-#include <linux/slab.h>
-
-struct crypto_ofb_ctx {
-	struct crypto_cipher *child;
-};
-
-
-static int crypto_ofb_setkey(struct crypto_skcipher *parent, const u8 *key,
-			     unsigned int keylen)
-{
-	struct crypto_ofb_ctx *ctx = crypto_skcipher_ctx(parent);
-	struct crypto_cipher *child = ctx->child;
-	int err;
-
-	crypto_cipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
-	crypto_cipher_set_flags(child, crypto_skcipher_get_flags(parent) &
-				       CRYPTO_TFM_REQ_MASK);
-	err = crypto_cipher_setkey(child, key, keylen);
-	crypto_skcipher_set_flags(parent, crypto_cipher_get_flags(child) &
-				  CRYPTO_TFM_RES_MASK);
-	return err;
-}
 
 static int crypto_ofb_crypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct crypto_ofb_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct crypto_cipher *cipher = ctx->child;
+	struct crypto_cipher *cipher = skcipher_cipher_simple(tfm);
 	const unsigned int bsize = crypto_cipher_blocksize(cipher);
 	struct skcipher_walk walk;
 	int err;
@@ -73,75 +49,15 @@ static int crypto_ofb_crypt(struct skcipher_request *req)
 	return err;
 }
 
-static int crypto_ofb_init_tfm(struct crypto_skcipher *tfm)
-{
-	struct skcipher_instance *inst = skcipher_alg_instance(tfm);
-	struct crypto_spawn *spawn = skcipher_instance_ctx(inst);
-	struct crypto_ofb_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct crypto_cipher *cipher;
-
-	cipher = crypto_spawn_cipher(spawn);
-	if (IS_ERR(cipher))
-		return PTR_ERR(cipher);
-
-	ctx->child = cipher;
-	return 0;
-}
-
-static void crypto_ofb_exit_tfm(struct crypto_skcipher *tfm)
-{
-	struct crypto_ofb_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	crypto_free_cipher(ctx->child);
-}
-
-static void crypto_ofb_free(struct skcipher_instance *inst)
-{
-	crypto_drop_skcipher(skcipher_instance_ctx(inst));
-	kfree(inst);
-}
-
 static int crypto_ofb_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	struct skcipher_instance *inst;
-	struct crypto_attr_type *algt;
-	struct crypto_spawn *spawn;
 	struct crypto_alg *alg;
-	u32 mask;
 	int err;
 
-	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SKCIPHER);
-	if (err)
-		return err;
-
-	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
-	if (!inst)
-		return -ENOMEM;
-
-	algt = crypto_get_attr_type(tb);
-	err = PTR_ERR(algt);
-	if (IS_ERR(algt))
-		goto err_free_inst;
-
-	mask = CRYPTO_ALG_TYPE_MASK |
-		crypto_requires_off(algt->type, algt->mask,
-				    CRYPTO_ALG_NEED_FALLBACK);
-
-	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER, mask);
-	err = PTR_ERR(alg);
-	if (IS_ERR(alg))
-		goto err_free_inst;
-
-	spawn = skcipher_instance_ctx(inst);
-	err = crypto_init_spawn(spawn, alg, skcipher_crypto_instance(inst),
-				CRYPTO_ALG_TYPE_MASK);
-	crypto_mod_put(alg);
-	if (err)
-		goto err_free_inst;
-
-	err = crypto_inst_setname(skcipher_crypto_instance(inst), "ofb", alg);
-	if (err)
-		goto err_drop_spawn;
+	inst = skcipher_alloc_instance_simple(tmpl, tb, &alg);
+	if (IS_ERR(inst))
+		return PTR_ERR(inst);
 
 	/* OFB mode is a stream cipher. */
 	inst->alg.base.cra_blocksize = 1;
@@ -152,36 +68,15 @@ static int crypto_ofb_create(struct crypto_template *tmpl, struct rtattr **tb)
 	 */
 	inst->alg.chunksize = alg->cra_blocksize;
 
-	inst->alg.base.cra_priority = alg->cra_priority;
-	inst->alg.base.cra_alignmask = alg->cra_alignmask;
-
-	inst->alg.ivsize = alg->cra_blocksize;
-	inst->alg.min_keysize = alg->cra_cipher.cia_min_keysize;
-	inst->alg.max_keysize = alg->cra_cipher.cia_max_keysize;
-
-	inst->alg.base.cra_ctxsize = sizeof(struct crypto_ofb_ctx);
-
-	inst->alg.init = crypto_ofb_init_tfm;
-	inst->alg.exit = crypto_ofb_exit_tfm;
-
-	inst->alg.setkey = crypto_ofb_setkey;
 	inst->alg.encrypt = crypto_ofb_crypt;
 	inst->alg.decrypt = crypto_ofb_crypt;
 
-	inst->free = crypto_ofb_free;
-
 	err = skcipher_register_instance(tmpl, inst);
 	if (err)
-		goto err_drop_spawn;
+		inst->free(inst);
 
-out:
+	crypto_mod_put(alg);
 	return err;
-
-err_drop_spawn:
-	crypto_drop_spawn(spawn);
-err_free_inst:
-	kfree(inst);
-	goto out;
 }
 
 static struct crypto_template crypto_ofb_tmpl = {
@@ -204,5 +99,5 @@ module_init(crypto_ofb_module_init);
 module_exit(crypto_ofb_module_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("OFB block cipher algorithm");
+MODULE_DESCRIPTION("OFB block cipher mode of operation");
 MODULE_ALIAS_CRYPTO("ofb");
-- 
2.20.1
