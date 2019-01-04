Return-Path: <SRS0=8/la=PM=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727739AbfADEU5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jan 2019 23:20:57 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 13/16] crypto: pcbc - convert to skcipher_alloc_instance_simple()
Date: Thu,  3 Jan 2019 20:16:22 -0800
Message-Id: <20190104041625.3259-14-ebiggers@kernel.org>
In-Reply-To: <20190104041625.3259-1-ebiggers@kernel.org>
References: <20190104041625.3259-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

The PCBC template just wraps a single block cipher algorithm, so
simplify it by converting it to use skcipher_alloc_instance_simple().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/pcbc.c | 125 +++++---------------------------------------------
 1 file changed, 11 insertions(+), 114 deletions(-)

diff --git a/crypto/pcbc.c b/crypto/pcbc.c
index 4f97a9d069b62..2fa03fc576fe4 100644
--- a/crypto/pcbc.c
+++ b/crypto/pcbc.c
@@ -20,28 +20,6 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/compiler.h>
-
-struct crypto_pcbc_ctx {
-	struct crypto_cipher *child;
-};
-
-static int crypto_pcbc_setkey(struct crypto_skcipher *parent, const u8 *key,
-			      unsigned int keylen)
-{
-	struct crypto_pcbc_ctx *ctx = crypto_skcipher_ctx(parent);
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
 
 static int crypto_pcbc_encrypt_segment(struct skcipher_request *req,
 				       struct skcipher_walk *walk,
@@ -90,8 +68,7 @@ static int crypto_pcbc_encrypt_inplace(struct skcipher_request *req,
 static int crypto_pcbc_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct crypto_pcbc_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct crypto_cipher *child = ctx->child;
+	struct crypto_cipher *cipher = skcipher_cipher_simple(tfm);
 	struct skcipher_walk walk;
 	unsigned int nbytes;
 	int err;
@@ -101,10 +78,10 @@ static int crypto_pcbc_encrypt(struct skcipher_request *req)
 	while ((nbytes = walk.nbytes)) {
 		if (walk.src.virt.addr == walk.dst.virt.addr)
 			nbytes = crypto_pcbc_encrypt_inplace(req, &walk,
-							     child);
+							     cipher);
 		else
 			nbytes = crypto_pcbc_encrypt_segment(req, &walk,
-							     child);
+							     cipher);
 		err = skcipher_walk_done(&walk, nbytes);
 	}
 
@@ -158,8 +135,7 @@ static int crypto_pcbc_decrypt_inplace(struct skcipher_request *req,
 static int crypto_pcbc_decrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct crypto_pcbc_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct crypto_cipher *child = ctx->child;
+	struct crypto_cipher *cipher = skcipher_cipher_simple(tfm);
 	struct skcipher_walk walk;
 	unsigned int nbytes;
 	int err;
@@ -169,113 +145,34 @@ static int crypto_pcbc_decrypt(struct skcipher_request *req)
 	while ((nbytes = walk.nbytes)) {
 		if (walk.src.virt.addr == walk.dst.virt.addr)
 			nbytes = crypto_pcbc_decrypt_inplace(req, &walk,
-							     child);
+							     cipher);
 		else
 			nbytes = crypto_pcbc_decrypt_segment(req, &walk,
-							     child);
+							     cipher);
 		err = skcipher_walk_done(&walk, nbytes);
 	}
 
 	return err;
 }
 
-static int crypto_pcbc_init_tfm(struct crypto_skcipher *tfm)
-{
-	struct skcipher_instance *inst = skcipher_alg_instance(tfm);
-	struct crypto_spawn *spawn = skcipher_instance_ctx(inst);
-	struct crypto_pcbc_ctx *ctx = crypto_skcipher_ctx(tfm);
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
-static void crypto_pcbc_exit_tfm(struct crypto_skcipher *tfm)
-{
-	struct crypto_pcbc_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	crypto_free_cipher(ctx->child);
-}
-
-static void crypto_pcbc_free(struct skcipher_instance *inst)
-{
-	crypto_drop_skcipher(skcipher_instance_ctx(inst));
-	kfree(inst);
-}
-
 static int crypto_pcbc_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	struct skcipher_instance *inst;
-	struct crypto_attr_type *algt;
-	struct crypto_spawn *spawn;
 	struct crypto_alg *alg;
 	int err;
 
-	algt = crypto_get_attr_type(tb);
-	if (IS_ERR(algt))
-		return PTR_ERR(algt);
-
-	if ((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask)
-		return -EINVAL;
-
-	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
-	if (!inst)
-		return -ENOMEM;
-
-	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
-				  CRYPTO_ALG_TYPE_MASK);
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
-	err = crypto_inst_setname(skcipher_crypto_instance(inst), "pcbc", alg);
-	if (err)
-		goto err_drop_spawn;
+	inst = skcipher_alloc_instance_simple(tmpl, tb, &alg);
+	if (IS_ERR(inst))
+		return PTR_ERR(inst);
 
-	inst->alg.base.cra_priority = alg->cra_priority;
-	inst->alg.base.cra_blocksize = alg->cra_blocksize;
-	inst->alg.base.cra_alignmask = alg->cra_alignmask;
-
-	inst->alg.ivsize = alg->cra_blocksize;
-	inst->alg.min_keysize = alg->cra_cipher.cia_min_keysize;
-	inst->alg.max_keysize = alg->cra_cipher.cia_max_keysize;
-
-	inst->alg.base.cra_ctxsize = sizeof(struct crypto_pcbc_ctx);
-
-	inst->alg.init = crypto_pcbc_init_tfm;
-	inst->alg.exit = crypto_pcbc_exit_tfm;
-
-	inst->alg.setkey = crypto_pcbc_setkey;
 	inst->alg.encrypt = crypto_pcbc_encrypt;
 	inst->alg.decrypt = crypto_pcbc_decrypt;
 
-	inst->free = crypto_pcbc_free;
-
 	err = skcipher_register_instance(tmpl, inst);
 	if (err)
-		goto err_drop_spawn;
+		inst->free(inst);
 	crypto_mod_put(alg);
-
-out:
 	return err;
-
-err_drop_spawn:
-	crypto_drop_spawn(spawn);
-err_put_alg:
-	crypto_mod_put(alg);
-err_free_inst:
-	kfree(inst);
-	goto out;
 }
 
 static struct crypto_template crypto_pcbc_tmpl = {
@@ -298,5 +195,5 @@ module_init(crypto_pcbc_module_init);
 module_exit(crypto_pcbc_module_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("PCBC block cipher algorithm");
+MODULE_DESCRIPTION("PCBC block cipher mode of operation");
 MODULE_ALIAS_CRYPTO("pcbc");
-- 
2.20.1
