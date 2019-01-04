Return-Path: <SRS0=8/la=PM=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726132AbfADEU4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jan 2019 23:20:56 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 08/16] crypto: ctr - convert to skcipher API
Date: Thu,  3 Jan 2019 20:16:17 -0800
Message-Id: <20190104041625.3259-9-ebiggers@kernel.org>
In-Reply-To: <20190104041625.3259-1-ebiggers@kernel.org>
References: <20190104041625.3259-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Convert the CTR template from the deprecated "blkcipher" API to the
"skcipher" API, taking advantage of skcipher_alloc_instance_simple() to
simplify it considerably.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/ctr.c | 160 +++++++++++++--------------------------------------
 1 file changed, 41 insertions(+), 119 deletions(-)

diff --git a/crypto/ctr.c b/crypto/ctr.c
index 30f3946efc6da..4c743a96faa49 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -17,14 +17,8 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/random.h>
-#include <linux/scatterlist.h>
 #include <linux/slab.h>
 
-struct crypto_ctr_ctx {
-	struct crypto_cipher *child;
-};
-
 struct crypto_rfc3686_ctx {
 	struct crypto_skcipher *child;
 	u8 nonce[CTR_RFC3686_NONCE_SIZE];
@@ -35,24 +29,7 @@ struct crypto_rfc3686_req_ctx {
 	struct skcipher_request subreq CRYPTO_MINALIGN_ATTR;
 };
 
-static int crypto_ctr_setkey(struct crypto_tfm *parent, const u8 *key,
-			     unsigned int keylen)
-{
-	struct crypto_ctr_ctx *ctx = crypto_tfm_ctx(parent);
-	struct crypto_cipher *child = ctx->child;
-	int err;
-
-	crypto_cipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
-	crypto_cipher_set_flags(child, crypto_tfm_get_flags(parent) &
-				CRYPTO_TFM_REQ_MASK);
-	err = crypto_cipher_setkey(child, key, keylen);
-	crypto_tfm_set_flags(parent, crypto_cipher_get_flags(child) &
-			     CRYPTO_TFM_RES_MASK);
-
-	return err;
-}
-
-static void crypto_ctr_crypt_final(struct blkcipher_walk *walk,
+static void crypto_ctr_crypt_final(struct skcipher_walk *walk,
 				   struct crypto_cipher *tfm)
 {
 	unsigned int bsize = crypto_cipher_blocksize(tfm);
@@ -70,7 +47,7 @@ static void crypto_ctr_crypt_final(struct blkcipher_walk *walk,
 	crypto_inc(ctrblk, bsize);
 }
 
-static int crypto_ctr_crypt_segment(struct blkcipher_walk *walk,
+static int crypto_ctr_crypt_segment(struct skcipher_walk *walk,
 				    struct crypto_cipher *tfm)
 {
 	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
@@ -96,7 +73,7 @@ static int crypto_ctr_crypt_segment(struct blkcipher_walk *walk,
 	return nbytes;
 }
 
-static int crypto_ctr_crypt_inplace(struct blkcipher_walk *walk,
+static int crypto_ctr_crypt_inplace(struct skcipher_walk *walk,
 				    struct crypto_cipher *tfm)
 {
 	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
@@ -123,135 +100,80 @@ static int crypto_ctr_crypt_inplace(struct blkcipher_walk *walk,
 	return nbytes;
 }
 
-static int crypto_ctr_crypt(struct blkcipher_desc *desc,
-			      struct scatterlist *dst, struct scatterlist *src,
-			      unsigned int nbytes)
+static int crypto_ctr_crypt(struct skcipher_request *req)
 {
-	struct blkcipher_walk walk;
-	struct crypto_blkcipher *tfm = desc->tfm;
-	struct crypto_ctr_ctx *ctx = crypto_blkcipher_ctx(tfm);
-	struct crypto_cipher *child = ctx->child;
-	unsigned int bsize = crypto_cipher_blocksize(child);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_cipher *cipher = skcipher_cipher_simple(tfm);
+	const unsigned int bsize = crypto_cipher_blocksize(cipher);
+	struct skcipher_walk walk;
+	unsigned int nbytes;
 	int err;
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt_block(desc, &walk, bsize);
+	err = skcipher_walk_virt(&walk, req, false);
 
 	while (walk.nbytes >= bsize) {
 		if (walk.src.virt.addr == walk.dst.virt.addr)
-			nbytes = crypto_ctr_crypt_inplace(&walk, child);
+			nbytes = crypto_ctr_crypt_inplace(&walk, cipher);
 		else
-			nbytes = crypto_ctr_crypt_segment(&walk, child);
+			nbytes = crypto_ctr_crypt_segment(&walk, cipher);
 
-		err = blkcipher_walk_done(desc, &walk, nbytes);
+		err = skcipher_walk_done(&walk, nbytes);
 	}
 
 	if (walk.nbytes) {
-		crypto_ctr_crypt_final(&walk, child);
-		err = blkcipher_walk_done(desc, &walk, 0);
+		crypto_ctr_crypt_final(&walk, cipher);
+		err = skcipher_walk_done(&walk, 0);
 	}
 
 	return err;
 }
 
-static int crypto_ctr_init_tfm(struct crypto_tfm *tfm)
+static int crypto_ctr_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
-	struct crypto_instance *inst = (void *)tfm->__crt_alg;
-	struct crypto_spawn *spawn = crypto_instance_ctx(inst);
-	struct crypto_ctr_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct crypto_cipher *cipher;
-
-	cipher = crypto_spawn_cipher(spawn);
-	if (IS_ERR(cipher))
-		return PTR_ERR(cipher);
-
-	ctx->child = cipher;
-
-	return 0;
-}
-
-static void crypto_ctr_exit_tfm(struct crypto_tfm *tfm)
-{
-	struct crypto_ctr_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	crypto_free_cipher(ctx->child);
-}
-
-static struct crypto_instance *crypto_ctr_alloc(struct rtattr **tb)
-{
-	struct crypto_instance *inst;
-	struct crypto_attr_type *algt;
+	struct skcipher_instance *inst;
 	struct crypto_alg *alg;
-	u32 mask;
 	int err;
 
-	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_BLKCIPHER);
-	if (err)
-		return ERR_PTR(err);
-
-	algt = crypto_get_attr_type(tb);
-	if (IS_ERR(algt))
-		return ERR_CAST(algt);
-
-	mask = CRYPTO_ALG_TYPE_MASK |
-		crypto_requires_off(algt->type, algt->mask,
-				    CRYPTO_ALG_NEED_FALLBACK);
-
-	alg = crypto_attr_alg(tb[1], CRYPTO_ALG_TYPE_CIPHER, mask);
-	if (IS_ERR(alg))
-		return ERR_CAST(alg);
+	inst = skcipher_alloc_instance_simple(tmpl, tb, &alg);
+	if (IS_ERR(inst))
+		return PTR_ERR(inst);
 
 	/* Block size must be >= 4 bytes. */
 	err = -EINVAL;
 	if (alg->cra_blocksize < 4)
-		goto out_put_alg;
+		goto out_free_inst;
 
 	/* If this is false we'd fail the alignment of crypto_inc. */
 	if (alg->cra_blocksize % 4)
-		goto out_put_alg;
-
-	inst = crypto_alloc_instance("ctr", alg);
-	if (IS_ERR(inst))
-		goto out;
-
-	inst->alg.cra_flags = CRYPTO_ALG_TYPE_BLKCIPHER;
-	inst->alg.cra_priority = alg->cra_priority;
-	inst->alg.cra_blocksize = 1;
-	inst->alg.cra_alignmask = alg->cra_alignmask;
-	inst->alg.cra_type = &crypto_blkcipher_type;
+		goto out_free_inst;
 
-	inst->alg.cra_blkcipher.ivsize = alg->cra_blocksize;
-	inst->alg.cra_blkcipher.min_keysize = alg->cra_cipher.cia_min_keysize;
-	inst->alg.cra_blkcipher.max_keysize = alg->cra_cipher.cia_max_keysize;
-
-	inst->alg.cra_ctxsize = sizeof(struct crypto_ctr_ctx);
+	/* CTR mode is a stream cipher. */
+	inst->alg.base.cra_blocksize = 1;
 
-	inst->alg.cra_init = crypto_ctr_init_tfm;
-	inst->alg.cra_exit = crypto_ctr_exit_tfm;
+	/*
+	 * To simplify the implementation, configure the skcipher walk to only
+	 * give a partial block at the very end, never earlier.
+	 */
+	inst->alg.chunksize = alg->cra_blocksize;
 
-	inst->alg.cra_blkcipher.setkey = crypto_ctr_setkey;
-	inst->alg.cra_blkcipher.encrypt = crypto_ctr_crypt;
-	inst->alg.cra_blkcipher.decrypt = crypto_ctr_crypt;
+	inst->alg.encrypt = crypto_ctr_crypt;
+	inst->alg.decrypt = crypto_ctr_crypt;
 
-out:
-	crypto_mod_put(alg);
-	return inst;
+	err = skcipher_register_instance(tmpl, inst);
+	if (err)
+		goto out_free_inst;
+	goto out_put_alg;
 
+out_free_inst:
+	inst->free(inst);
 out_put_alg:
-	inst = ERR_PTR(err);
-	goto out;
-}
-
-static void crypto_ctr_free(struct crypto_instance *inst)
-{
-	crypto_drop_spawn(crypto_instance_ctx(inst));
-	kfree(inst);
+	crypto_mod_put(alg);
+	return err;
 }
 
 static struct crypto_template crypto_ctr_tmpl = {
 	.name = "ctr",
-	.alloc = crypto_ctr_alloc,
-	.free = crypto_ctr_free,
+	.create = crypto_ctr_create,
 	.module = THIS_MODULE,
 };
 
@@ -480,6 +402,6 @@ module_init(crypto_ctr_module_init);
 module_exit(crypto_ctr_module_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("CTR Counter block mode");
+MODULE_DESCRIPTION("CTR block cipher mode of operation");
 MODULE_ALIAS_CRYPTO("rfc3686");
 MODULE_ALIAS_CRYPTO("ctr");
-- 
2.20.1
