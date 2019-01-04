Return-Path: <SRS0=8/la=PM=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727719AbfADEUz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jan 2019 23:20:55 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 07/16] crypto: cfb - convert to skcipher_alloc_instance_simple()
Date: Thu,  3 Jan 2019 20:16:16 -0800
Message-Id: <20190104041625.3259-8-ebiggers@kernel.org>
In-Reply-To: <20190104041625.3259-1-ebiggers@kernel.org>
References: <20190104041625.3259-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

The CFB template just wraps a single block cipher algorithm, so simplify
it by converting it to use skcipher_alloc_instance_simple().

Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/cfb.c | 127 ++++-----------------------------------------------
 1 file changed, 9 insertions(+), 118 deletions(-)

diff --git a/crypto/cfb.c b/crypto/cfb.c
index 4abfe32ff8451..03ac847f6d6ab 100644
--- a/crypto/cfb.c
+++ b/crypto/cfb.c
@@ -25,28 +25,17 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/slab.h>
 #include <linux/string.h>
-#include <linux/types.h>
-
-struct crypto_cfb_ctx {
-	struct crypto_cipher *child;
-};
 
 static unsigned int crypto_cfb_bsize(struct crypto_skcipher *tfm)
 {
-	struct crypto_cfb_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct crypto_cipher *child = ctx->child;
-
-	return crypto_cipher_blocksize(child);
+	return crypto_cipher_blocksize(skcipher_cipher_simple(tfm));
 }
 
 static void crypto_cfb_encrypt_one(struct crypto_skcipher *tfm,
 					  const u8 *src, u8 *dst)
 {
-	struct crypto_cfb_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	crypto_cipher_encrypt_one(ctx->child, dst, src);
+	crypto_cipher_encrypt_one(skcipher_cipher_simple(tfm), dst, src);
 }
 
 /* final encrypt and decrypt is the same */
@@ -186,22 +175,6 @@ static int crypto_cfb_decrypt_blocks(struct skcipher_walk *walk,
 		return crypto_cfb_decrypt_segment(walk, tfm);
 }
 
-static int crypto_cfb_setkey(struct crypto_skcipher *parent, const u8 *key,
-			     unsigned int keylen)
-{
-	struct crypto_cfb_ctx *ctx = crypto_skcipher_ctx(parent);
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
-
 static int crypto_cfb_decrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
@@ -224,79 +197,18 @@ static int crypto_cfb_decrypt(struct skcipher_request *req)
 	return err;
 }
 
-static int crypto_cfb_init_tfm(struct crypto_skcipher *tfm)
-{
-	struct skcipher_instance *inst = skcipher_alg_instance(tfm);
-	struct crypto_spawn *spawn = skcipher_instance_ctx(inst);
-	struct crypto_cfb_ctx *ctx = crypto_skcipher_ctx(tfm);
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
-static void crypto_cfb_exit_tfm(struct crypto_skcipher *tfm)
-{
-	struct crypto_cfb_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	crypto_free_cipher(ctx->child);
-}
-
-static void crypto_cfb_free(struct skcipher_instance *inst)
-{
-	crypto_drop_skcipher(skcipher_instance_ctx(inst));
-	kfree(inst);
-}
-
 static int crypto_cfb_create(struct crypto_template *tmpl, struct rtattr **tb)
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
+	inst = skcipher_alloc_instance_simple(tmpl, tb, &alg);
+	if (IS_ERR(inst))
+		return PTR_ERR(inst);
 
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
-	err = crypto_inst_setname(skcipher_crypto_instance(inst), "cfb", alg);
-	if (err)
-		goto err_drop_spawn;
-
-	inst->alg.base.cra_priority = alg->cra_priority;
-	/* we're a stream cipher independend of the crypto cra_blocksize */
+	/* CFB mode is a stream cipher. */
 	inst->alg.base.cra_blocksize = 1;
-	inst->alg.base.cra_alignmask = alg->cra_alignmask;
 
 	/*
 	 * To simplify the implementation, configure the skcipher walk to only
@@ -304,36 +216,15 @@ static int crypto_cfb_create(struct crypto_template *tmpl, struct rtattr **tb)
 	 */
 	inst->alg.chunksize = alg->cra_blocksize;
 
-	inst->alg.ivsize = alg->cra_blocksize;
-	inst->alg.min_keysize = alg->cra_cipher.cia_min_keysize;
-	inst->alg.max_keysize = alg->cra_cipher.cia_max_keysize;
-
-	inst->alg.base.cra_ctxsize = sizeof(struct crypto_cfb_ctx);
-
-	inst->alg.init = crypto_cfb_init_tfm;
-	inst->alg.exit = crypto_cfb_exit_tfm;
-
-	inst->alg.setkey = crypto_cfb_setkey;
 	inst->alg.encrypt = crypto_cfb_encrypt;
 	inst->alg.decrypt = crypto_cfb_decrypt;
 
-	inst->free = crypto_cfb_free;
-
 	err = skcipher_register_instance(tmpl, inst);
 	if (err)
-		goto err_drop_spawn;
-	crypto_mod_put(alg);
-
-out:
-	return err;
+		inst->free(inst);
 
-err_drop_spawn:
-	crypto_drop_spawn(spawn);
-err_put_alg:
 	crypto_mod_put(alg);
-err_free_inst:
-	kfree(inst);
-	goto out;
+	return err;
 }
 
 static struct crypto_template crypto_cfb_tmpl = {
@@ -356,5 +247,5 @@ module_init(crypto_cfb_module_init);
 module_exit(crypto_cfb_module_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("CFB block cipher algorithm");
+MODULE_DESCRIPTION("CFB block cipher mode of operation");
 MODULE_ALIAS_CRYPTO("cfb");
-- 
2.20.1
