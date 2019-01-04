Return-Path: <SRS0=8/la=PM=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727715AbfADEU4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jan 2019 23:20:56 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 06/16] crypto: cbc - convert to skcipher_alloc_instance_simple()
Date: Thu,  3 Jan 2019 20:16:15 -0800
Message-Id: <20190104041625.3259-7-ebiggers@kernel.org>
In-Reply-To: <20190104041625.3259-1-ebiggers@kernel.org>
References: <20190104041625.3259-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

The CBC template just wraps a single block cipher algorithm, so simplify
it by converting it to use skcipher_alloc_instance_simple().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/cbc.c | 131 +++++----------------------------------------------
 1 file changed, 13 insertions(+), 118 deletions(-)

diff --git a/crypto/cbc.c b/crypto/cbc.c
index dd5f332fd5668..d12efaac9230b 100644
--- a/crypto/cbc.c
+++ b/crypto/cbc.c
@@ -18,34 +18,11 @@
 #include <linux/kernel.h>
 #include <linux/log2.h>
 #include <linux/module.h>
-#include <linux/slab.h>
-
-struct crypto_cbc_ctx {
-	struct crypto_cipher *child;
-};
-
-static int crypto_cbc_setkey(struct crypto_skcipher *parent, const u8 *key,
-			     unsigned int keylen)
-{
-	struct crypto_cbc_ctx *ctx = crypto_skcipher_ctx(parent);
-	struct crypto_cipher *child = ctx->child;
-	int err;
-
-	crypto_cipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
-	crypto_cipher_set_flags(child, crypto_skcipher_get_flags(parent) &
-				       CRYPTO_TFM_REQ_MASK);
-	err = crypto_cipher_setkey(child, key, keylen);
-	crypto_skcipher_set_flags(parent, crypto_cipher_get_flags(child) &
-					  CRYPTO_TFM_RES_MASK);
-	return err;
-}
 
 static inline void crypto_cbc_encrypt_one(struct crypto_skcipher *tfm,
 					  const u8 *src, u8 *dst)
 {
-	struct crypto_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	crypto_cipher_encrypt_one(ctx->child, dst, src);
+	crypto_cipher_encrypt_one(skcipher_cipher_simple(tfm), dst, src);
 }
 
 static int crypto_cbc_encrypt(struct skcipher_request *req)
@@ -56,9 +33,7 @@ static int crypto_cbc_encrypt(struct skcipher_request *req)
 static inline void crypto_cbc_decrypt_one(struct crypto_skcipher *tfm,
 					  const u8 *src, u8 *dst)
 {
-	struct crypto_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	crypto_cipher_decrypt_one(ctx->child, dst, src);
+	crypto_cipher_decrypt_one(skcipher_cipher_simple(tfm), dst, src);
 }
 
 static int crypto_cbc_decrypt(struct skcipher_request *req)
@@ -78,113 +53,33 @@ static int crypto_cbc_decrypt(struct skcipher_request *req)
 	return err;
 }
 
-static int crypto_cbc_init_tfm(struct crypto_skcipher *tfm)
-{
-	struct skcipher_instance *inst = skcipher_alg_instance(tfm);
-	struct crypto_spawn *spawn = skcipher_instance_ctx(inst);
-	struct crypto_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
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
-static void crypto_cbc_exit_tfm(struct crypto_skcipher *tfm)
-{
-	struct crypto_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	crypto_free_cipher(ctx->child);
-}
-
-static void crypto_cbc_free(struct skcipher_instance *inst)
-{
-	crypto_drop_skcipher(skcipher_instance_ctx(inst));
-	kfree(inst);
-}
-
 static int crypto_cbc_create(struct crypto_template *tmpl, struct rtattr **tb)
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
-	if (err)
-		goto err_put_alg;
-
-	err = crypto_inst_setname(skcipher_crypto_instance(inst), "cbc", alg);
-	if (err)
-		goto err_drop_spawn;
+	inst = skcipher_alloc_instance_simple(tmpl, tb, &alg);
+	if (IS_ERR(inst))
+		return PTR_ERR(inst);
 
 	err = -EINVAL;
 	if (!is_power_of_2(alg->cra_blocksize))
-		goto err_drop_spawn;
-
-	inst->alg.base.cra_priority = alg->cra_priority;
-	inst->alg.base.cra_blocksize = alg->cra_blocksize;
-	inst->alg.base.cra_alignmask = alg->cra_alignmask;
-
-	inst->alg.ivsize = alg->cra_blocksize;
-	inst->alg.min_keysize = alg->cra_cipher.cia_min_keysize;
-	inst->alg.max_keysize = alg->cra_cipher.cia_max_keysize;
-
-	inst->alg.base.cra_ctxsize = sizeof(struct crypto_cbc_ctx);
-
-	inst->alg.init = crypto_cbc_init_tfm;
-	inst->alg.exit = crypto_cbc_exit_tfm;
+		goto out_free_inst;
 
-	inst->alg.setkey = crypto_cbc_setkey;
 	inst->alg.encrypt = crypto_cbc_encrypt;
 	inst->alg.decrypt = crypto_cbc_decrypt;
 
-	inst->free = crypto_cbc_free;
-
 	err = skcipher_register_instance(tmpl, inst);
 	if (err)
-		goto err_drop_spawn;
-	crypto_mod_put(alg);
+		goto out_free_inst;
+	goto out_put_alg;
 
-out:
-	return err;
-
-err_drop_spawn:
-	crypto_drop_spawn(spawn);
-err_put_alg:
+out_free_inst:
+	inst->free(inst);
+out_put_alg:
 	crypto_mod_put(alg);
-err_free_inst:
-	kfree(inst);
-	goto out;
+	return err;
 }
 
 static struct crypto_template crypto_cbc_tmpl = {
@@ -207,5 +102,5 @@ module_init(crypto_cbc_module_init);
 module_exit(crypto_cbc_module_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("CBC block cipher algorithm");
+MODULE_DESCRIPTION("CBC block cipher mode of operation");
 MODULE_ALIAS_CRYPTO("cbc");
-- 
2.20.1
