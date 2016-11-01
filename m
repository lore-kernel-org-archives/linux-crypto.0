From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 8/16] crypto: pcbc - Convert to skcipher
Date: Wed, 02 Nov 2016 07:19:10 +0800
Message-ID: <E1c1iKk-0004Cs-43@gondolin.me.apana.org.au>
References: <20161101231648.GA15967@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34955 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752661AbcKAXTN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Nov 2016 19:19:13 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
        by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
        id 1c1iKk-00074M-7h
        for <linux-crypto@vger.kernel.org>; Wed, 02 Nov 2016 10:19:10 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts lrw over to the skcipher interface.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/pcbc.c |  201 +++++++++++++++++++++++++++++++---------------------------
 1 file changed, 109 insertions(+), 92 deletions(-)

diff --git a/crypto/pcbc.c b/crypto/pcbc.c
index f654965..e4538e0 100644
--- a/crypto/pcbc.c
+++ b/crypto/pcbc.c
@@ -14,40 +14,37 @@
  *
  */
 
-#include <crypto/algapi.h>
+#include <crypto/internal/skcipher.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/scatterlist.h>
 #include <linux/slab.h>
 
 struct crypto_pcbc_ctx {
 	struct crypto_cipher *child;
 };
 
-static int crypto_pcbc_setkey(struct crypto_tfm *parent, const u8 *key,
+static int crypto_pcbc_setkey(struct crypto_skcipher *parent, const u8 *key,
 			      unsigned int keylen)
 {
-	struct crypto_pcbc_ctx *ctx = crypto_tfm_ctx(parent);
+	struct crypto_pcbc_ctx *ctx = crypto_skcipher_ctx(parent);
 	struct crypto_cipher *child = ctx->child;
 	int err;
 
 	crypto_cipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
-	crypto_cipher_set_flags(child, crypto_tfm_get_flags(parent) &
-				CRYPTO_TFM_REQ_MASK);
+	crypto_cipher_set_flags(child, crypto_skcipher_get_flags(parent) &
+				       CRYPTO_TFM_REQ_MASK);
 	err = crypto_cipher_setkey(child, key, keylen);
-	crypto_tfm_set_flags(parent, crypto_cipher_get_flags(child) &
-			     CRYPTO_TFM_RES_MASK);
+	crypto_skcipher_set_flags(parent, crypto_cipher_get_flags(child) &
+					  CRYPTO_TFM_RES_MASK);
 	return err;
 }
 
-static int crypto_pcbc_encrypt_segment(struct blkcipher_desc *desc,
-				       struct blkcipher_walk *walk,
+static int crypto_pcbc_encrypt_segment(struct skcipher_request *req,
+				       struct skcipher_walk *walk,
 				       struct crypto_cipher *tfm)
 {
-	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
-		crypto_cipher_alg(tfm)->cia_encrypt;
 	int bsize = crypto_cipher_blocksize(tfm);
 	unsigned int nbytes = walk->nbytes;
 	u8 *src = walk->src.virt.addr;
@@ -56,7 +53,7 @@ static int crypto_pcbc_encrypt_segment(struct blkcipher_desc *desc,
 
 	do {
 		crypto_xor(iv, src, bsize);
-		fn(crypto_cipher_tfm(tfm), dst, iv);
+		crypto_cipher_encrypt_one(tfm, dst, iv);
 		memcpy(iv, dst, bsize);
 		crypto_xor(iv, src, bsize);
 
@@ -67,12 +64,10 @@ static int crypto_pcbc_encrypt_segment(struct blkcipher_desc *desc,
 	return nbytes;
 }
 
-static int crypto_pcbc_encrypt_inplace(struct blkcipher_desc *desc,
-				       struct blkcipher_walk *walk,
+static int crypto_pcbc_encrypt_inplace(struct skcipher_request *req,
+				       struct skcipher_walk *walk,
 				       struct crypto_cipher *tfm)
 {
-	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
-		crypto_cipher_alg(tfm)->cia_encrypt;
 	int bsize = crypto_cipher_blocksize(tfm);
 	unsigned int nbytes = walk->nbytes;
 	u8 *src = walk->src.virt.addr;
@@ -82,7 +77,7 @@ static int crypto_pcbc_encrypt_inplace(struct blkcipher_desc *desc,
 	do {
 		memcpy(tmpbuf, src, bsize);
 		crypto_xor(iv, src, bsize);
-		fn(crypto_cipher_tfm(tfm), src, iv);
+		crypto_cipher_encrypt_one(tfm, src, iv);
 		memcpy(iv, tmpbuf, bsize);
 		crypto_xor(iv, src, bsize);
 
@@ -94,38 +89,34 @@ static int crypto_pcbc_encrypt_inplace(struct blkcipher_desc *desc,
 	return nbytes;
 }
 
-static int crypto_pcbc_encrypt(struct blkcipher_desc *desc,
-			       struct scatterlist *dst, struct scatterlist *src,
-			       unsigned int nbytes)
+static int crypto_pcbc_encrypt(struct skcipher_request *req)
 {
-	struct blkcipher_walk walk;
-	struct crypto_blkcipher *tfm = desc->tfm;
-	struct crypto_pcbc_ctx *ctx = crypto_blkcipher_ctx(tfm);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_pcbc_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct crypto_cipher *child = ctx->child;
+	struct skcipher_walk walk;
+	unsigned int nbytes;
 	int err;
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
+	err = skcipher_walk_virt(&walk, req, false);
 
 	while ((nbytes = walk.nbytes)) {
 		if (walk.src.virt.addr == walk.dst.virt.addr)
-			nbytes = crypto_pcbc_encrypt_inplace(desc, &walk,
+			nbytes = crypto_pcbc_encrypt_inplace(req, &walk,
 							     child);
 		else
-			nbytes = crypto_pcbc_encrypt_segment(desc, &walk,
+			nbytes = crypto_pcbc_encrypt_segment(req, &walk,
 							     child);
-		err = blkcipher_walk_done(desc, &walk, nbytes);
+		err = skcipher_walk_done(&walk, nbytes);
 	}
 
 	return err;
 }
 
-static int crypto_pcbc_decrypt_segment(struct blkcipher_desc *desc,
-				       struct blkcipher_walk *walk,
+static int crypto_pcbc_decrypt_segment(struct skcipher_request *req,
+				       struct skcipher_walk *walk,
 				       struct crypto_cipher *tfm)
 {
-	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
-		crypto_cipher_alg(tfm)->cia_decrypt;
 	int bsize = crypto_cipher_blocksize(tfm);
 	unsigned int nbytes = walk->nbytes;
 	u8 *src = walk->src.virt.addr;
@@ -133,7 +124,7 @@ static int crypto_pcbc_decrypt_segment(struct blkcipher_desc *desc,
 	u8 *iv = walk->iv;
 
 	do {
-		fn(crypto_cipher_tfm(tfm), dst, src);
+		crypto_cipher_decrypt_one(tfm, dst, src);
 		crypto_xor(dst, iv, bsize);
 		memcpy(iv, src, bsize);
 		crypto_xor(iv, dst, bsize);
@@ -147,21 +138,19 @@ static int crypto_pcbc_decrypt_segment(struct blkcipher_desc *desc,
 	return nbytes;
 }
 
-static int crypto_pcbc_decrypt_inplace(struct blkcipher_desc *desc,
-				       struct blkcipher_walk *walk,
+static int crypto_pcbc_decrypt_inplace(struct skcipher_request *req,
+				       struct skcipher_walk *walk,
 				       struct crypto_cipher *tfm)
 {
-	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
-		crypto_cipher_alg(tfm)->cia_decrypt;
 	int bsize = crypto_cipher_blocksize(tfm);
 	unsigned int nbytes = walk->nbytes;
 	u8 *src = walk->src.virt.addr;
 	u8 *iv = walk->iv;
-	u8 tmpbuf[bsize];
+	u8 tmpbuf[bsize] __attribute__ ((aligned(__alignof__(u32))));
 
 	do {
 		memcpy(tmpbuf, src, bsize);
-		fn(crypto_cipher_tfm(tfm), src, src);
+		crypto_cipher_decrypt_one(tfm, src, src);
 		crypto_xor(src, iv, bsize);
 		memcpy(iv, tmpbuf, bsize);
 		crypto_xor(iv, src, bsize);
@@ -174,37 +163,35 @@ static int crypto_pcbc_decrypt_inplace(struct blkcipher_desc *desc,
 	return nbytes;
 }
 
-static int crypto_pcbc_decrypt(struct blkcipher_desc *desc,
-			       struct scatterlist *dst, struct scatterlist *src,
-			       unsigned int nbytes)
+static int crypto_pcbc_decrypt(struct skcipher_request *req)
 {
-	struct blkcipher_walk walk;
-	struct crypto_blkcipher *tfm = desc->tfm;
-	struct crypto_pcbc_ctx *ctx = crypto_blkcipher_ctx(tfm);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_pcbc_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct crypto_cipher *child = ctx->child;
+	struct skcipher_walk walk;
+	unsigned int nbytes;
 	int err;
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
+	err = skcipher_walk_virt(&walk, req, false);
 
 	while ((nbytes = walk.nbytes)) {
 		if (walk.src.virt.addr == walk.dst.virt.addr)
-			nbytes = crypto_pcbc_decrypt_inplace(desc, &walk,
+			nbytes = crypto_pcbc_decrypt_inplace(req, &walk,
 							     child);
 		else
-			nbytes = crypto_pcbc_decrypt_segment(desc, &walk,
+			nbytes = crypto_pcbc_decrypt_segment(req, &walk,
 							     child);
-		err = blkcipher_walk_done(desc, &walk, nbytes);
+		err = skcipher_walk_done(&walk, nbytes);
 	}
 
 	return err;
 }
 
-static int crypto_pcbc_init_tfm(struct crypto_tfm *tfm)
+static int crypto_pcbc_init_tfm(struct crypto_skcipher *tfm)
 {
-	struct crypto_instance *inst = (void *)tfm->__crt_alg;
-	struct crypto_spawn *spawn = crypto_instance_ctx(inst);
-	struct crypto_pcbc_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct skcipher_instance *inst = skcipher_alg_instance(tfm);
+	struct crypto_spawn *spawn = skcipher_instance_ctx(inst);
+	struct crypto_pcbc_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct crypto_cipher *cipher;
 
 	cipher = crypto_spawn_cipher(spawn);
@@ -215,68 +202,98 @@ static int crypto_pcbc_init_tfm(struct crypto_tfm *tfm)
 	return 0;
 }
 
-static void crypto_pcbc_exit_tfm(struct crypto_tfm *tfm)
+static void crypto_pcbc_exit_tfm(struct crypto_skcipher *tfm)
 {
-	struct crypto_pcbc_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_pcbc_ctx *ctx = crypto_skcipher_ctx(tfm);
+
 	crypto_free_cipher(ctx->child);
 }
 
-static struct crypto_instance *crypto_pcbc_alloc(struct rtattr **tb)
+static void crypto_pcbc_free(struct skcipher_instance *inst)
+{
+	crypto_drop_skcipher(skcipher_instance_ctx(inst));
+	kfree(inst);
+}
+
+static int crypto_pcbc_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
-	struct crypto_instance *inst;
+	struct skcipher_instance *inst;
+	struct crypto_attr_type *algt;
+	struct crypto_spawn *spawn;
 	struct crypto_alg *alg;
 	int err;
 
-	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_BLKCIPHER);
-	if (err)
-		return ERR_PTR(err);
+	algt = crypto_get_attr_type(tb);
+	if (IS_ERR(algt))
+		return PTR_ERR(algt);
+
+	if (((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask) &
+	    ~CRYPTO_ALG_INTERNAL)
+		return -EINVAL;
 
-	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
-				  CRYPTO_ALG_TYPE_MASK);
+	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
+	if (!inst)
+		return -ENOMEM;
+
+	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER |
+				      (algt->type & CRYPTO_ALG_INTERNAL),
+				  CRYPTO_ALG_TYPE_MASK |
+				  (algt->mask & CRYPTO_ALG_INTERNAL));
+	err = PTR_ERR(alg);
 	if (IS_ERR(alg))
-		return ERR_CAST(alg);
+		goto err_free_inst;
+
+	spawn = skcipher_instance_ctx(inst);
+	err = crypto_init_spawn(spawn, alg, skcipher_crypto_instance(inst),
+				CRYPTO_ALG_TYPE_MASK);
+	crypto_mod_put(alg);
+	if (err)
+		goto err_free_inst;
 
-	inst = crypto_alloc_instance("pcbc", alg);
-	if (IS_ERR(inst))
-		goto out_put_alg;
+	err = crypto_inst_setname(skcipher_crypto_instance(inst), "pcbc", alg);
+	if (err)
+		goto err_drop_spawn;
 
-	inst->alg.cra_flags = CRYPTO_ALG_TYPE_BLKCIPHER;
-	inst->alg.cra_priority = alg->cra_priority;
-	inst->alg.cra_blocksize = alg->cra_blocksize;
-	inst->alg.cra_alignmask = alg->cra_alignmask;
-	inst->alg.cra_type = &crypto_blkcipher_type;
+	inst->alg.base.cra_flags = alg->cra_flags & CRYPTO_ALG_INTERNAL;
+	inst->alg.base.cra_priority = alg->cra_priority;
+	inst->alg.base.cra_blocksize = alg->cra_blocksize;
+	inst->alg.base.cra_alignmask = alg->cra_alignmask;
 
 	/* We access the data as u32s when xoring. */
-	inst->alg.cra_alignmask |= __alignof__(u32) - 1;
+	inst->alg.base.cra_alignmask |= __alignof__(u32) - 1;
 
-	inst->alg.cra_blkcipher.ivsize = alg->cra_blocksize;
-	inst->alg.cra_blkcipher.min_keysize = alg->cra_cipher.cia_min_keysize;
-	inst->alg.cra_blkcipher.max_keysize = alg->cra_cipher.cia_max_keysize;
+	inst->alg.ivsize = alg->cra_blocksize;
+	inst->alg.min_keysize = alg->cra_cipher.cia_min_keysize;
+	inst->alg.max_keysize = alg->cra_cipher.cia_max_keysize;
 
-	inst->alg.cra_ctxsize = sizeof(struct crypto_pcbc_ctx);
+	inst->alg.base.cra_ctxsize = sizeof(struct crypto_pcbc_ctx);
 
-	inst->alg.cra_init = crypto_pcbc_init_tfm;
-	inst->alg.cra_exit = crypto_pcbc_exit_tfm;
+	inst->alg.init = crypto_pcbc_init_tfm;
+	inst->alg.exit = crypto_pcbc_exit_tfm;
 
-	inst->alg.cra_blkcipher.setkey = crypto_pcbc_setkey;
-	inst->alg.cra_blkcipher.encrypt = crypto_pcbc_encrypt;
-	inst->alg.cra_blkcipher.decrypt = crypto_pcbc_decrypt;
+	inst->alg.setkey = crypto_pcbc_setkey;
+	inst->alg.encrypt = crypto_pcbc_encrypt;
+	inst->alg.decrypt = crypto_pcbc_decrypt;
 
-out_put_alg:
-	crypto_mod_put(alg);
-	return inst;
-}
+	inst->free = crypto_pcbc_free;
 
-static void crypto_pcbc_free(struct crypto_instance *inst)
-{
-	crypto_drop_spawn(crypto_instance_ctx(inst));
+	err = skcipher_register_instance(tmpl, inst);
+	if (err)
+		goto err_drop_spawn;
+
+out:
+	return err;
+
+err_drop_spawn:
+	crypto_drop_spawn(spawn);
+err_free_inst:
 	kfree(inst);
+	goto out;
 }
 
 static struct crypto_template crypto_pcbc_tmpl = {
 	.name = "pcbc",
-	.alloc = crypto_pcbc_alloc,
-	.free = crypto_pcbc_free,
+	.create = crypto_pcbc_create,
 	.module = THIS_MODULE,
 };
 
