Return-Path: <SRS0=8/la=PM=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727722AbfADEU5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jan 2019 23:20:57 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 09/16] crypto: ecb - convert to skcipher API
Date: Thu,  3 Jan 2019 20:16:18 -0800
Message-Id: <20190104041625.3259-10-ebiggers@kernel.org>
In-Reply-To: <20190104041625.3259-1-ebiggers@kernel.org>
References: <20190104041625.3259-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Convert the ECB template from the deprecated "blkcipher" API to the
"skcipher" API, taking advantage of skcipher_alloc_instance_simple() to
simplify it considerably.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/ecb.c | 151 ++++++++++++---------------------------------------
 1 file changed, 36 insertions(+), 115 deletions(-)

diff --git a/crypto/ecb.c b/crypto/ecb.c
index 12011aff09713..0732715c8d915 100644
--- a/crypto/ecb.c
+++ b/crypto/ecb.c
@@ -11,162 +11,83 @@
  */
 
 #include <crypto/algapi.h>
+#include <crypto/internal/skcipher.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/scatterlist.h>
-#include <linux/slab.h>
 
-struct crypto_ecb_ctx {
-	struct crypto_cipher *child;
-};
-
-static int crypto_ecb_setkey(struct crypto_tfm *parent, const u8 *key,
-			     unsigned int keylen)
-{
-	struct crypto_ecb_ctx *ctx = crypto_tfm_ctx(parent);
-	struct crypto_cipher *child = ctx->child;
-	int err;
-
-	crypto_cipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
-	crypto_cipher_set_flags(child, crypto_tfm_get_flags(parent) &
-				       CRYPTO_TFM_REQ_MASK);
-	err = crypto_cipher_setkey(child, key, keylen);
-	crypto_tfm_set_flags(parent, crypto_cipher_get_flags(child) &
-				     CRYPTO_TFM_RES_MASK);
-	return err;
-}
-
-static int crypto_ecb_crypt(struct blkcipher_desc *desc,
-			    struct blkcipher_walk *walk,
-			    struct crypto_cipher *tfm,
+static int crypto_ecb_crypt(struct skcipher_request *req,
+			    struct crypto_cipher *cipher,
 			    void (*fn)(struct crypto_tfm *, u8 *, const u8 *))
 {
-	int bsize = crypto_cipher_blocksize(tfm);
+	const unsigned int bsize = crypto_cipher_blocksize(cipher);
+	struct skcipher_walk walk;
 	unsigned int nbytes;
 	int err;
 
-	err = blkcipher_walk_virt(desc, walk);
+	err = skcipher_walk_virt(&walk, req, false);
 
-	while ((nbytes = walk->nbytes)) {
-		u8 *wsrc = walk->src.virt.addr;
-		u8 *wdst = walk->dst.virt.addr;
+	while ((nbytes = walk.nbytes) != 0) {
+		const u8 *src = walk.src.virt.addr;
+		u8 *dst = walk.dst.virt.addr;
 
 		do {
-			fn(crypto_cipher_tfm(tfm), wdst, wsrc);
+			fn(crypto_cipher_tfm(cipher), dst, src);
 
-			wsrc += bsize;
-			wdst += bsize;
+			src += bsize;
+			dst += bsize;
 		} while ((nbytes -= bsize) >= bsize);
 
-		err = blkcipher_walk_done(desc, walk, nbytes);
+		err = skcipher_walk_done(&walk, nbytes);
 	}
 
 	return err;
 }
 
-static int crypto_ecb_encrypt(struct blkcipher_desc *desc,
-			      struct scatterlist *dst, struct scatterlist *src,
-			      unsigned int nbytes)
+static int crypto_ecb_encrypt(struct skcipher_request *req)
 {
-	struct blkcipher_walk walk;
-	struct crypto_blkcipher *tfm = desc->tfm;
-	struct crypto_ecb_ctx *ctx = crypto_blkcipher_ctx(tfm);
-	struct crypto_cipher *child = ctx->child;
-
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return crypto_ecb_crypt(desc, &walk, child,
-				crypto_cipher_alg(child)->cia_encrypt);
-}
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_cipher *cipher = skcipher_cipher_simple(tfm);
 
-static int crypto_ecb_decrypt(struct blkcipher_desc *desc,
-			      struct scatterlist *dst, struct scatterlist *src,
-			      unsigned int nbytes)
-{
-	struct blkcipher_walk walk;
-	struct crypto_blkcipher *tfm = desc->tfm;
-	struct crypto_ecb_ctx *ctx = crypto_blkcipher_ctx(tfm);
-	struct crypto_cipher *child = ctx->child;
-
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return crypto_ecb_crypt(desc, &walk, child,
-				crypto_cipher_alg(child)->cia_decrypt);
+	return crypto_ecb_crypt(req, cipher,
+				crypto_cipher_alg(cipher)->cia_encrypt);
 }
 
-static int crypto_ecb_init_tfm(struct crypto_tfm *tfm)
+static int crypto_ecb_decrypt(struct skcipher_request *req)
 {
-	struct crypto_instance *inst = (void *)tfm->__crt_alg;
-	struct crypto_spawn *spawn = crypto_instance_ctx(inst);
-	struct crypto_ecb_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct crypto_cipher *cipher;
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_cipher *cipher = skcipher_cipher_simple(tfm);
 
-	cipher = crypto_spawn_cipher(spawn);
-	if (IS_ERR(cipher))
-		return PTR_ERR(cipher);
-
-	ctx->child = cipher;
-	return 0;
+	return crypto_ecb_crypt(req, cipher,
+				crypto_cipher_alg(cipher)->cia_decrypt);
 }
 
-static void crypto_ecb_exit_tfm(struct crypto_tfm *tfm)
+static int crypto_ecb_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
-	struct crypto_ecb_ctx *ctx = crypto_tfm_ctx(tfm);
-	crypto_free_cipher(ctx->child);
-}
-
-static struct crypto_instance *crypto_ecb_alloc(struct rtattr **tb)
-{
-	struct crypto_instance *inst;
+	struct skcipher_instance *inst;
 	struct crypto_alg *alg;
 	int err;
 
-	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_BLKCIPHER);
-	if (err)
-		return ERR_PTR(err);
-
-	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
-				  CRYPTO_ALG_TYPE_MASK);
-	if (IS_ERR(alg))
-		return ERR_CAST(alg);
-
-	inst = crypto_alloc_instance("ecb", alg);
+	inst = skcipher_alloc_instance_simple(tmpl, tb, &alg);
 	if (IS_ERR(inst))
-		goto out_put_alg;
-
-	inst->alg.cra_flags = CRYPTO_ALG_TYPE_BLKCIPHER;
-	inst->alg.cra_priority = alg->cra_priority;
-	inst->alg.cra_blocksize = alg->cra_blocksize;
-	inst->alg.cra_alignmask = alg->cra_alignmask;
-	inst->alg.cra_type = &crypto_blkcipher_type;
-
-	inst->alg.cra_blkcipher.min_keysize = alg->cra_cipher.cia_min_keysize;
-	inst->alg.cra_blkcipher.max_keysize = alg->cra_cipher.cia_max_keysize;
+		return PTR_ERR(inst);
 
-	inst->alg.cra_ctxsize = sizeof(struct crypto_ecb_ctx);
+	inst->alg.ivsize = 0; /* ECB mode doesn't take an IV */
 
-	inst->alg.cra_init = crypto_ecb_init_tfm;
-	inst->alg.cra_exit = crypto_ecb_exit_tfm;
+	inst->alg.encrypt = crypto_ecb_encrypt;
+	inst->alg.decrypt = crypto_ecb_decrypt;
 
-	inst->alg.cra_blkcipher.setkey = crypto_ecb_setkey;
-	inst->alg.cra_blkcipher.encrypt = crypto_ecb_encrypt;
-	inst->alg.cra_blkcipher.decrypt = crypto_ecb_decrypt;
-
-out_put_alg:
+	err = skcipher_register_instance(tmpl, inst);
+	if (err)
+		inst->free(inst);
 	crypto_mod_put(alg);
-	return inst;
-}
-
-static void crypto_ecb_free(struct crypto_instance *inst)
-{
-	crypto_drop_spawn(crypto_instance_ctx(inst));
-	kfree(inst);
+	return err;
 }
 
 static struct crypto_template crypto_ecb_tmpl = {
 	.name = "ecb",
-	.alloc = crypto_ecb_alloc,
-	.free = crypto_ecb_free,
+	.create = crypto_ecb_create,
 	.module = THIS_MODULE,
 };
 
@@ -184,5 +105,5 @@ module_init(crypto_ecb_module_init);
 module_exit(crypto_ecb_module_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("ECB block cipher algorithm");
+MODULE_DESCRIPTION("ECB block cipher mode of operation");
 MODULE_ALIAS_CRYPTO("ecb");
-- 
2.20.1
