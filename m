From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 14/16] crypto: cbc - Convert to skcipher
Date: Wed, 02 Nov 2016 07:19:17 +0800
Message-ID: <E1c1iKr-0004EW-3k@gondolin.me.apana.org.au>
References: <20161101231648.GA15967@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55390 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753455AbcKAXTU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Nov 2016 19:19:20 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
        by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
        id 1c1iKr-00077V-85
        for <linux-crypto@vger.kernel.org>; Wed, 02 Nov 2016 10:19:17 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts cbc over to the skcipher interface.  It also
rearranges the code to allow it to be reused by drivers.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/cbc.c |  242 +++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 138 insertions(+), 104 deletions(-)

diff --git a/crypto/cbc.c b/crypto/cbc.c
index 780ee27..6539b38 100644
--- a/crypto/cbc.c
+++ b/crypto/cbc.c
@@ -10,42 +10,39 @@
  *
  */
 
-#include <crypto/algapi.h>
+#include <crypto/internal/skcipher.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/log2.h>
 #include <linux/module.h>
-#include <linux/scatterlist.h>
 #include <linux/slab.h>
 
 struct crypto_cbc_ctx {
 	struct crypto_cipher *child;
 };
 
-static int crypto_cbc_setkey(struct crypto_tfm *parent, const u8 *key,
+static int crypto_cbc_setkey(struct crypto_skcipher *parent, const u8 *key,
 			     unsigned int keylen)
 {
-	struct crypto_cbc_ctx *ctx = crypto_tfm_ctx(parent);
+	struct crypto_cbc_ctx *ctx = crypto_skcipher_ctx(parent);
 	struct crypto_cipher *child = ctx->child;
 	int err;
 
 	crypto_cipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
-	crypto_cipher_set_flags(child, crypto_tfm_get_flags(parent) &
+	crypto_cipher_set_flags(child, crypto_skcipher_get_flags(parent) &
 				       CRYPTO_TFM_REQ_MASK);
 	err = crypto_cipher_setkey(child, key, keylen);
-	crypto_tfm_set_flags(parent, crypto_cipher_get_flags(child) &
-				     CRYPTO_TFM_RES_MASK);
+	crypto_skcipher_set_flags(parent, crypto_cipher_get_flags(child) &
+					  CRYPTO_TFM_RES_MASK);
 	return err;
 }
 
-static int crypto_cbc_encrypt_segment(struct blkcipher_desc *desc,
-				      struct blkcipher_walk *walk,
-				      struct crypto_cipher *tfm)
+static inline int crypto_cbc_encrypt_segment(
+	struct skcipher_walk *walk, struct crypto_skcipher *tfm,
+	void (*fn)(struct crypto_skcipher *, const u8 *, u8 *))
 {
-	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
-		crypto_cipher_alg(tfm)->cia_encrypt;
-	int bsize = crypto_cipher_blocksize(tfm);
+	unsigned int bsize = crypto_skcipher_blocksize(tfm);
 	unsigned int nbytes = walk->nbytes;
 	u8 *src = walk->src.virt.addr;
 	u8 *dst = walk->dst.virt.addr;
@@ -53,7 +50,7 @@ static int crypto_cbc_encrypt_segment(struct blkcipher_desc *desc,
 
 	do {
 		crypto_xor(iv, src, bsize);
-		fn(crypto_cipher_tfm(tfm), dst, iv);
+		fn(tfm, iv, dst);
 		memcpy(iv, dst, bsize);
 
 		src += bsize;
@@ -63,20 +60,18 @@ static int crypto_cbc_encrypt_segment(struct blkcipher_desc *desc,
 	return nbytes;
 }
 
-static int crypto_cbc_encrypt_inplace(struct blkcipher_desc *desc,
-				      struct blkcipher_walk *walk,
-				      struct crypto_cipher *tfm)
+static inline int crypto_cbc_encrypt_inplace(
+	struct skcipher_walk *walk, struct crypto_skcipher *tfm,
+	void (*fn)(struct crypto_skcipher *, const u8 *, u8 *))
 {
-	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
-		crypto_cipher_alg(tfm)->cia_encrypt;
-	int bsize = crypto_cipher_blocksize(tfm);
+	unsigned int bsize = crypto_skcipher_blocksize(tfm);
 	unsigned int nbytes = walk->nbytes;
 	u8 *src = walk->src.virt.addr;
 	u8 *iv = walk->iv;
 
 	do {
 		crypto_xor(src, iv, bsize);
-		fn(crypto_cipher_tfm(tfm), src, src);
+		fn(tfm, src, src);
 		iv = src;
 
 		src += bsize;
@@ -87,44 +82,52 @@ static int crypto_cbc_encrypt_inplace(struct blkcipher_desc *desc,
 	return nbytes;
 }
 
-static int crypto_cbc_encrypt(struct blkcipher_desc *desc,
-			      struct scatterlist *dst, struct scatterlist *src,
-			      unsigned int nbytes)
+static inline int crypto_cbc_encrypt_walk(struct skcipher_request *req,
+					  void (*fn)(struct crypto_skcipher *,
+						     const u8 *, u8 *))
 {
-	struct blkcipher_walk walk;
-	struct crypto_blkcipher *tfm = desc->tfm;
-	struct crypto_cbc_ctx *ctx = crypto_blkcipher_ctx(tfm);
-	struct crypto_cipher *child = ctx->child;
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct skcipher_walk walk;
 	int err;
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
+	err = skcipher_walk_virt(&walk, req, false);
 
-	while ((nbytes = walk.nbytes)) {
+	while (walk.nbytes) {
 		if (walk.src.virt.addr == walk.dst.virt.addr)
-			nbytes = crypto_cbc_encrypt_inplace(desc, &walk, child);
+			err = crypto_cbc_encrypt_inplace(&walk, tfm, fn);
 		else
-			nbytes = crypto_cbc_encrypt_segment(desc, &walk, child);
-		err = blkcipher_walk_done(desc, &walk, nbytes);
+			err = crypto_cbc_encrypt_segment(&walk, tfm, fn);
+		err = skcipher_walk_done(&walk, err);
 	}
 
 	return err;
 }
 
-static int crypto_cbc_decrypt_segment(struct blkcipher_desc *desc,
-				      struct blkcipher_walk *walk,
-				      struct crypto_cipher *tfm)
+static inline void crypto_cbc_encrypt_one(struct crypto_skcipher *tfm,
+					  const u8 *src, u8 *dst)
+{
+	struct crypto_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	crypto_cipher_encrypt_one(ctx->child, dst, src);
+}
+
+static int crypto_cbc_encrypt(struct skcipher_request *req)
 {
-	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
-		crypto_cipher_alg(tfm)->cia_decrypt;
-	int bsize = crypto_cipher_blocksize(tfm);
+	return crypto_cbc_encrypt_walk(req, crypto_cbc_encrypt_one);
+}
+
+static inline int crypto_cbc_decrypt_segment(
+	struct skcipher_walk *walk, struct crypto_skcipher *tfm,
+	void (*fn)(struct crypto_skcipher *, const u8 *, u8 *))
+{
+	unsigned int bsize = crypto_skcipher_blocksize(tfm);
 	unsigned int nbytes = walk->nbytes;
 	u8 *src = walk->src.virt.addr;
 	u8 *dst = walk->dst.virt.addr;
 	u8 *iv = walk->iv;
 
 	do {
-		fn(crypto_cipher_tfm(tfm), dst, src);
+		fn(tfm, src, dst);
 		crypto_xor(dst, iv, bsize);
 		iv = src;
 
@@ -137,13 +140,11 @@ static int crypto_cbc_decrypt_segment(struct blkcipher_desc *desc,
 	return nbytes;
 }
 
-static int crypto_cbc_decrypt_inplace(struct blkcipher_desc *desc,
-				      struct blkcipher_walk *walk,
-				      struct crypto_cipher *tfm)
+static inline int crypto_cbc_decrypt_inplace(
+	struct skcipher_walk *walk, struct crypto_skcipher *tfm,
+	void (*fn)(struct crypto_skcipher *, const u8 *, u8 *))
 {
-	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
-		crypto_cipher_alg(tfm)->cia_decrypt;
-	int bsize = crypto_cipher_blocksize(tfm);
+	unsigned int bsize = crypto_skcipher_blocksize(tfm);
 	unsigned int nbytes = walk->nbytes;
 	u8 *src = walk->src.virt.addr;
 	u8 last_iv[bsize];
@@ -153,7 +154,7 @@ static int crypto_cbc_decrypt_inplace(struct blkcipher_desc *desc,
 	memcpy(last_iv, src, bsize);
 
 	for (;;) {
-		fn(crypto_cipher_tfm(tfm), src, src);
+		fn(tfm, src, src);
 		if ((nbytes -= bsize) < bsize)
 			break;
 		crypto_xor(src, src - bsize, bsize);
@@ -166,35 +167,46 @@ static int crypto_cbc_decrypt_inplace(struct blkcipher_desc *desc,
 	return nbytes;
 }
 
-static int crypto_cbc_decrypt(struct blkcipher_desc *desc,
-			      struct scatterlist *dst, struct scatterlist *src,
-			      unsigned int nbytes)
+static inline int crypto_cbc_decrypt_blocks(
+	struct skcipher_walk *walk, struct crypto_skcipher *tfm,
+	void (*fn)(struct crypto_skcipher *, const u8 *, u8 *))
 {
-	struct blkcipher_walk walk;
-	struct crypto_blkcipher *tfm = desc->tfm;
-	struct crypto_cbc_ctx *ctx = crypto_blkcipher_ctx(tfm);
-	struct crypto_cipher *child = ctx->child;
+	if (walk->src.virt.addr == walk->dst.virt.addr)
+		return crypto_cbc_decrypt_inplace(walk, tfm, fn);
+	else
+		return crypto_cbc_decrypt_segment(walk, tfm, fn);
+}
+
+static inline void crypto_cbc_decrypt_one(struct crypto_skcipher *tfm,
+					  const u8 *src, u8 *dst)
+{
+	struct crypto_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	crypto_cipher_decrypt_one(ctx->child, dst, src);
+}
+
+static int crypto_cbc_decrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct skcipher_walk walk;
 	int err;
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
+	err = skcipher_walk_virt(&walk, req, false);
 
-	while ((nbytes = walk.nbytes)) {
-		if (walk.src.virt.addr == walk.dst.virt.addr)
-			nbytes = crypto_cbc_decrypt_inplace(desc, &walk, child);
-		else
-			nbytes = crypto_cbc_decrypt_segment(desc, &walk, child);
-		err = blkcipher_walk_done(desc, &walk, nbytes);
+	while (walk.nbytes) {
+		err = crypto_cbc_decrypt_blocks(&walk, tfm,
+						crypto_cbc_decrypt_one);
+		err = skcipher_walk_done(&walk, err);
 	}
 
 	return err;
 }
 
-static int crypto_cbc_init_tfm(struct crypto_tfm *tfm)
+static int crypto_cbc_init_tfm(struct crypto_skcipher *tfm)
 {
-	struct crypto_instance *inst = (void *)tfm->__crt_alg;
-	struct crypto_spawn *spawn = crypto_instance_ctx(inst);
-	struct crypto_cbc_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct skcipher_instance *inst = skcipher_alg_instance(tfm);
+	struct crypto_spawn *spawn = skcipher_instance_ctx(inst);
+	struct crypto_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct crypto_cipher *cipher;
 
 	cipher = crypto_spawn_cipher(spawn);
@@ -205,72 +217,94 @@ static int crypto_cbc_init_tfm(struct crypto_tfm *tfm)
 	return 0;
 }
 
-static void crypto_cbc_exit_tfm(struct crypto_tfm *tfm)
+static void crypto_cbc_exit_tfm(struct crypto_skcipher *tfm)
 {
-	struct crypto_cbc_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
+
 	crypto_free_cipher(ctx->child);
 }
 
-static struct crypto_instance *crypto_cbc_alloc(struct rtattr **tb)
+static void crypto_cbc_free(struct skcipher_instance *inst)
 {
-	struct crypto_instance *inst;
+	crypto_drop_skcipher(skcipher_instance_ctx(inst));
+	kfree(inst);
+}
+
+static int crypto_cbc_create(struct crypto_template *tmpl, struct rtattr **tb)
+{
+	struct skcipher_instance *inst;
+	struct crypto_spawn *spawn;
 	struct crypto_alg *alg;
 	int err;
 
-	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_BLKCIPHER);
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SKCIPHER);
 	if (err)
-		return ERR_PTR(err);
+		return err;
+
+	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
+	if (!inst)
+		return -ENOMEM;
 
 	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
 				  CRYPTO_ALG_TYPE_MASK);
+	err = PTR_ERR(alg);
 	if (IS_ERR(alg))
-		return ERR_CAST(alg);
+		goto err_free_inst;
 
-	inst = ERR_PTR(-EINVAL);
-	if (!is_power_of_2(alg->cra_blocksize))
-		goto out_put_alg;
+	spawn = skcipher_instance_ctx(inst);
+	err = crypto_init_spawn(spawn, alg, skcipher_crypto_instance(inst),
+				CRYPTO_ALG_TYPE_MASK);
+	crypto_mod_put(alg);
+	if (err)
+		goto err_free_inst;
+
+	err = crypto_inst_setname(skcipher_crypto_instance(inst), "cbc", alg);
+	if (err)
+		goto err_drop_spawn;
 
-	inst = crypto_alloc_instance("cbc", alg);
-	if (IS_ERR(inst))
-		goto out_put_alg;
+	err = -EINVAL;
+	if (!is_power_of_2(alg->cra_blocksize))
+		goto err_drop_spawn;
 
-	inst->alg.cra_flags = CRYPTO_ALG_TYPE_BLKCIPHER;
-	inst->alg.cra_priority = alg->cra_priority;
-	inst->alg.cra_blocksize = alg->cra_blocksize;
-	inst->alg.cra_alignmask = alg->cra_alignmask;
-	inst->alg.cra_type = &crypto_blkcipher_type;
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
 
-	inst->alg.cra_ctxsize = sizeof(struct crypto_cbc_ctx);
+	inst->alg.base.cra_ctxsize = sizeof(struct crypto_cbc_ctx);
 
-	inst->alg.cra_init = crypto_cbc_init_tfm;
-	inst->alg.cra_exit = crypto_cbc_exit_tfm;
+	inst->alg.init = crypto_cbc_init_tfm;
+	inst->alg.exit = crypto_cbc_exit_tfm;
 
-	inst->alg.cra_blkcipher.setkey = crypto_cbc_setkey;
-	inst->alg.cra_blkcipher.encrypt = crypto_cbc_encrypt;
-	inst->alg.cra_blkcipher.decrypt = crypto_cbc_decrypt;
+	inst->alg.setkey = crypto_cbc_setkey;
+	inst->alg.encrypt = crypto_cbc_encrypt;
+	inst->alg.decrypt = crypto_cbc_decrypt;
 
-out_put_alg:
-	crypto_mod_put(alg);
-	return inst;
-}
+	inst->free = crypto_cbc_free;
 
-static void crypto_cbc_free(struct crypto_instance *inst)
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
 
 static struct crypto_template crypto_cbc_tmpl = {
 	.name = "cbc",
-	.alloc = crypto_cbc_alloc,
-	.free = crypto_cbc_free,
+	.create = crypto_cbc_create,
 	.module = THIS_MODULE,
 };
 
