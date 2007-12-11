From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/8] [CRYPTO] ctr: Refactor into ctr and rfc3686
Date: Tue, 11 Dec 2007 11:50:23 +0800
Message-ID: <E1J1w8V-0002eX-00@gondolin.me.apana.org.au>
References: <20071211034945.GA10099@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1777 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751810AbXLKDua (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Dec 2007 22:50:30 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J1w8X-0005pe-2y
	for <linux-crypto@vger.kernel.org>; Tue, 11 Dec 2007 14:50:26 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] ctr: Refactor into ctr and rfc3686

As discussed previously, this patch moves the basic CTR functionality
into a chainable algorithm called ctr.  The IPsec-specific variant of
it is now placed on top with the name rfc3686.

So ctr(aes) gives a chainable cipher with IV size 16 while the IPsec
variant will be called rfc3686(ctr(aes)).  This patch also adjusts
gcm accordingly.

This is necessary before we can get gcm to use the cipher-level IV
generator.

eigned-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ctr.c    |  334 ++++++++++++++++++++++++++++++++++----------------------
 crypto/gcm.c    |    5 
 crypto/tcrypt.c |    8 -
 3 files changed, 212 insertions(+), 135 deletions(-)

diff --git a/crypto/ctr.c b/crypto/ctr.c
index 57da7d0..1052b31 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -11,6 +11,7 @@
  */
 
 #include <crypto/algapi.h>
+#include <crypto/ctr.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -19,16 +20,13 @@
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
 
-struct ctr_instance_ctx {
-	struct crypto_spawn alg;
-	unsigned int noncesize;
-	unsigned int ivsize;
-	unsigned int countersize;
-};
-
 struct crypto_ctr_ctx {
 	struct crypto_cipher *child;
-	u8 *nonce;
+};
+
+struct crypto_rfc3686_ctx {
+	struct crypto_blkcipher *child;
+	u8 nonce[CTR_RFC3686_NONCE_SIZE];
 };
 
 static int crypto_ctr_setkey(struct crypto_tfm *parent, const u8 *key,
@@ -36,18 +34,7 @@ static int crypto_ctr_setkey(struct crypto_tfm *parent, const u8 *key,
 {
 	struct crypto_ctr_ctx *ctx = crypto_tfm_ctx(parent);
 	struct crypto_cipher *child = ctx->child;
-	struct ctr_instance_ctx *ictx =
-		crypto_instance_ctx(crypto_tfm_alg_instance(parent));
-	unsigned int noncelen = ictx->noncesize;
-	int err = 0;
-
-	/* the nonce is stored in bytes at end of key */
-	if (keylen < noncelen)
-		return  -EINVAL;
-
-	memcpy(ctx->nonce, key + (keylen - noncelen), noncelen);
-
-	keylen -=  noncelen;
+	int err;
 
 	crypto_cipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
 	crypto_cipher_set_flags(child, crypto_tfm_get_flags(parent) &
@@ -60,11 +47,13 @@ static int crypto_ctr_setkey(struct crypto_tfm *parent, const u8 *key,
 }
 
 static void crypto_ctr_crypt_final(struct blkcipher_walk *walk,
-				   struct crypto_cipher *tfm, u8 *ctrblk,
-				   unsigned int countersize)
+				   struct crypto_cipher *tfm)
 {
 	unsigned int bsize = crypto_cipher_blocksize(tfm);
-	u8 *keystream = ctrblk + bsize;
+	unsigned long alignmask = crypto_cipher_alignmask(tfm);
+	u8 *ctrblk = walk->iv;
+	u8 tmp[bsize + alignmask];
+	u8 *keystream = PTR_ALIGN(tmp + 0, alignmask + 1);
 	u8 *src = walk->src.virt.addr;
 	u8 *dst = walk->dst.virt.addr;
 	unsigned int nbytes = walk->nbytes;
@@ -72,15 +61,17 @@ static void crypto_ctr_crypt_final(struct blkcipher_walk *walk,
 	crypto_cipher_encrypt_one(tfm, keystream, ctrblk);
 	crypto_xor(keystream, src, nbytes);
 	memcpy(dst, keystream, nbytes);
+
+	crypto_inc(ctrblk, bsize);
 }
 
 static int crypto_ctr_crypt_segment(struct blkcipher_walk *walk,
-				    struct crypto_cipher *tfm, u8 *ctrblk,
-				    unsigned int countersize)
+				    struct crypto_cipher *tfm)
 {
 	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
 		   crypto_cipher_alg(tfm)->cia_encrypt;
 	unsigned int bsize = crypto_cipher_blocksize(tfm);
+	u8 *ctrblk = walk->iv;
 	u8 *src = walk->src.virt.addr;
 	u8 *dst = walk->dst.virt.addr;
 	unsigned int nbytes = walk->nbytes;
@@ -91,7 +82,7 @@ static int crypto_ctr_crypt_segment(struct blkcipher_walk *walk,
 		crypto_xor(dst, src, bsize);
 
 		/* increment counter in counterblock */
-		crypto_inc(ctrblk + bsize - countersize, countersize);
+		crypto_inc(ctrblk, bsize);
 
 		src += bsize;
 		dst += bsize;
@@ -101,15 +92,17 @@ static int crypto_ctr_crypt_segment(struct blkcipher_walk *walk,
 }
 
 static int crypto_ctr_crypt_inplace(struct blkcipher_walk *walk,
-				    struct crypto_cipher *tfm, u8 *ctrblk,
-				    unsigned int countersize)
+				    struct crypto_cipher *tfm)
 {
 	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
 		   crypto_cipher_alg(tfm)->cia_encrypt;
 	unsigned int bsize = crypto_cipher_blocksize(tfm);
+	unsigned long alignmask = crypto_cipher_alignmask(tfm);
 	unsigned int nbytes = walk->nbytes;
+	u8 *ctrblk = walk->iv;
 	u8 *src = walk->src.virt.addr;
-	u8 *keystream = ctrblk + bsize;
+	u8 tmp[bsize + alignmask];
+	u8 *keystream = PTR_ALIGN(tmp + 0, alignmask + 1);
 
 	do {
 		/* create keystream */
@@ -117,7 +110,7 @@ static int crypto_ctr_crypt_inplace(struct blkcipher_walk *walk,
 		crypto_xor(src, keystream, bsize);
 
 		/* increment counter in counterblock */
-		crypto_inc(ctrblk + bsize - countersize, countersize);
+		crypto_inc(ctrblk, bsize);
 
 		src += bsize;
 	} while ((nbytes -= bsize) >= bsize);
@@ -134,41 +127,22 @@ static int crypto_ctr_crypt(struct blkcipher_desc *desc,
 	struct crypto_ctr_ctx *ctx = crypto_blkcipher_ctx(tfm);
 	struct crypto_cipher *child = ctx->child;
 	unsigned int bsize = crypto_cipher_blocksize(child);
-	struct ctr_instance_ctx *ictx =
-		crypto_instance_ctx(crypto_tfm_alg_instance(&tfm->base));
-	unsigned long alignmask = crypto_cipher_alignmask(child) |
-				  (__alignof__(u32) - 1);
-	u8 cblk[bsize * 2 + alignmask];
-	u8 *counterblk = (u8 *)ALIGN((unsigned long)cblk, alignmask + 1);
 	int err;
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt_block(desc, &walk, bsize);
 
-	/* set up counter block */
-	memset(counterblk, 0 , bsize);
-	memcpy(counterblk, ctx->nonce, ictx->noncesize);
-	memcpy(counterblk + ictx->noncesize, walk.iv, ictx->ivsize);
-
-	/* initialize counter portion of counter block */
-	crypto_inc(counterblk + bsize - ictx->countersize, ictx->countersize);
-
 	while (walk.nbytes >= bsize) {
 		if (walk.src.virt.addr == walk.dst.virt.addr)
-			nbytes = crypto_ctr_crypt_inplace(&walk, child,
-							  counterblk,
-							  ictx->countersize);
+			nbytes = crypto_ctr_crypt_inplace(&walk, child);
 		else
-			nbytes = crypto_ctr_crypt_segment(&walk, child,
-							  counterblk,
-							  ictx->countersize);
+			nbytes = crypto_ctr_crypt_segment(&walk, child);
 
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
 
 	if (walk.nbytes) {
-		crypto_ctr_crypt_final(&walk, child, counterblk,
-				       ictx->countersize);
+		crypto_ctr_crypt_final(&walk, child);
 		err = blkcipher_walk_done(desc, &walk, 0);
 	}
 
@@ -178,15 +152,11 @@ static int crypto_ctr_crypt(struct blkcipher_desc *desc,
 static int crypto_ctr_init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_instance *inst = (void *)tfm->__crt_alg;
-	struct ctr_instance_ctx *ictx = crypto_instance_ctx(inst);
+	struct crypto_spawn *spawn = crypto_instance_ctx(inst);
 	struct crypto_ctr_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct crypto_cipher *cipher;
 
-	ctx->nonce = kzalloc(ictx->noncesize, GFP_KERNEL);
-	if (!ctx->nonce)
-		return -ENOMEM;
-
-	cipher = crypto_spawn_cipher(&ictx->alg);
+	cipher = crypto_spawn_cipher(spawn);
 	if (IS_ERR(cipher))
 		return PTR_ERR(cipher);
 
@@ -199,7 +169,6 @@ static void crypto_ctr_exit_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_ctr_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	kfree(ctx->nonce);
 	crypto_free_cipher(ctx->child);
 }
 
@@ -207,10 +176,6 @@ static struct crypto_instance *crypto_ctr_alloc(struct rtattr **tb)
 {
 	struct crypto_instance *inst;
 	struct crypto_alg *alg;
-	struct ctr_instance_ctx *ictx;
-	unsigned int noncesize;
-	unsigned int ivsize;
-	unsigned int countersize;
 	int err;
 
 	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_BLKCIPHER);
@@ -222,71 +187,28 @@ static struct crypto_instance *crypto_ctr_alloc(struct rtattr **tb)
 	if (IS_ERR(alg))
 		return ERR_PTR(PTR_ERR(alg));
 
-	err = crypto_attr_u32(tb[2], &noncesize);
-	if (err)
-		goto out_put_alg;
-
-	err = crypto_attr_u32(tb[3], &ivsize);
-	if (err)
-		goto out_put_alg;
-
-	err = crypto_attr_u32(tb[4], &countersize);
-	if (err)
-		goto out_put_alg;
-
-	/* verify size of nonce + iv + counter
-	 * counter must be >= 4 bytes.
-	 */
+	/* Block size must be >= 4 bytes. */
 	err = -EINVAL;
-	if (((noncesize + ivsize + countersize) < alg->cra_blocksize) ||
-	    ((noncesize + ivsize) > alg->cra_blocksize) ||
-	    (countersize > alg->cra_blocksize) || (countersize < 4))
+	if (alg->cra_blocksize < 4)
 		goto out_put_alg;
 
 	/* If this is false we'd fail the alignment of crypto_inc. */
-	if ((alg->cra_blocksize - countersize) % 4)
+	if (alg->cra_blocksize % 4)
 		goto out_put_alg;
 
-	inst = kzalloc(sizeof(*inst) + sizeof(*ictx), GFP_KERNEL);
-	err = -ENOMEM;
-	if (!inst)
-		goto out_put_alg;
-
-	err = -ENAMETOOLONG;
-	if (snprintf(inst->alg.cra_name, CRYPTO_MAX_ALG_NAME,
-		     "ctr(%s,%u,%u,%u)", alg->cra_name, noncesize,
-		     ivsize, countersize) >= CRYPTO_MAX_ALG_NAME) {
-		goto err_free_inst;
-	}
-
-	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
-		     "ctr(%s,%u,%u,%u)", alg->cra_driver_name, noncesize,
-		     ivsize, countersize) >= CRYPTO_MAX_ALG_NAME) {
-		goto err_free_inst;
-	}
-
-	ictx = crypto_instance_ctx(inst);
-	ictx->noncesize = noncesize;
-	ictx->ivsize = ivsize;
-	ictx->countersize = countersize;
-
-	err = crypto_init_spawn(&ictx->alg, alg, inst,
-		CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_ASYNC);
-	if (err)
-		goto err_free_inst;
+	inst = crypto_alloc_instance("ctr", alg);
+	if (IS_ERR(inst))
+		goto out;
 
-	err = 0;
 	inst->alg.cra_flags = CRYPTO_ALG_TYPE_BLKCIPHER;
 	inst->alg.cra_priority = alg->cra_priority;
 	inst->alg.cra_blocksize = 1;
 	inst->alg.cra_alignmask = alg->cra_alignmask | (__alignof__(u32) - 1);
 	inst->alg.cra_type = &crypto_blkcipher_type;
 
-	inst->alg.cra_blkcipher.ivsize = ivsize;
-	inst->alg.cra_blkcipher.min_keysize = alg->cra_cipher.cia_min_keysize
-					      + noncesize;
-	inst->alg.cra_blkcipher.max_keysize = alg->cra_cipher.cia_max_keysize
-					      + noncesize;
+	inst->alg.cra_blkcipher.ivsize = alg->cra_blocksize;
+	inst->alg.cra_blkcipher.min_keysize = alg->cra_cipher.cia_min_keysize;
+	inst->alg.cra_blkcipher.max_keysize = alg->cra_cipher.cia_max_keysize;
 
 	inst->alg.cra_ctxsize = sizeof(struct crypto_ctr_ctx);
 
@@ -297,24 +219,18 @@ static struct crypto_instance *crypto_ctr_alloc(struct rtattr **tb)
 	inst->alg.cra_blkcipher.encrypt = crypto_ctr_crypt;
 	inst->alg.cra_blkcipher.decrypt = crypto_ctr_crypt;
 
-err_free_inst:
-	if (err)
-		kfree(inst);
-
-out_put_alg:
+out:
 	crypto_mod_put(alg);
-
-	if (err)
-		inst = ERR_PTR(err);
-
 	return inst;
+
+out_put_alg:
+	inst = ERR_PTR(err);
+	goto out;
 }
 
 static void crypto_ctr_free(struct crypto_instance *inst)
 {
-	struct ctr_instance_ctx *ictx = crypto_instance_ctx(inst);
-
-	crypto_drop_spawn(&ictx->alg);
+	crypto_drop_spawn(crypto_instance_ctx(inst));
 	kfree(inst);
 }
 
@@ -325,13 +241,174 @@ static struct crypto_template crypto_ctr_tmpl = {
 	.module = THIS_MODULE,
 };
 
+static int crypto_rfc3686_setkey(struct crypto_tfm *parent, const u8 *key,
+				 unsigned int keylen)
+{
+	struct crypto_rfc3686_ctx *ctx = crypto_tfm_ctx(parent);
+	struct crypto_blkcipher *child = ctx->child;
+	int err;
+
+	/* the nonce is stored in bytes at end of key */
+	if (keylen < CTR_RFC3686_NONCE_SIZE)
+		return -EINVAL;
+
+	memcpy(ctx->nonce, key + (keylen - CTR_RFC3686_NONCE_SIZE),
+	       CTR_RFC3686_NONCE_SIZE);
+
+	keylen -= CTR_RFC3686_NONCE_SIZE;
+
+	crypto_blkcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_blkcipher_set_flags(child, crypto_tfm_get_flags(parent) &
+					  CRYPTO_TFM_REQ_MASK);
+	err = crypto_blkcipher_setkey(child, key, keylen);
+	crypto_tfm_set_flags(parent, crypto_blkcipher_get_flags(child) &
+				     CRYPTO_TFM_RES_MASK);
+
+	return err;
+}
+
+static int crypto_rfc3686_crypt(struct blkcipher_desc *desc,
+				struct scatterlist *dst,
+				struct scatterlist *src, unsigned int nbytes)
+{
+	struct crypto_blkcipher *tfm = desc->tfm;
+	struct crypto_rfc3686_ctx *ctx = crypto_blkcipher_ctx(tfm);
+	struct crypto_blkcipher *child = ctx->child;
+	unsigned long alignmask = crypto_blkcipher_alignmask(tfm);
+	u8 ivblk[CTR_RFC3686_BLOCK_SIZE + alignmask];
+	u8 *iv = PTR_ALIGN(ivblk + 0, alignmask + 1);
+	u8 *info = desc->info;
+	int err;
+
+	/* set up counter block */
+	memcpy(iv, ctx->nonce, CTR_RFC3686_NONCE_SIZE);
+	memcpy(iv + CTR_RFC3686_NONCE_SIZE, info, CTR_RFC3686_IV_SIZE);
+
+	/* initialize counter portion of counter block */
+	*(__be32 *)(iv + CTR_RFC3686_NONCE_SIZE + CTR_RFC3686_IV_SIZE) =
+		cpu_to_be32(1);
+
+	desc->tfm = child;
+	desc->info = iv;
+	err = crypto_blkcipher_encrypt_iv(desc, dst, src, nbytes);
+	desc->tfm = tfm;
+	desc->info = info;
+
+	return err;
+}
+
+static int crypto_rfc3686_init_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_instance *inst = (void *)tfm->__crt_alg;
+	struct crypto_spawn *spawn = crypto_instance_ctx(inst);
+	struct crypto_rfc3686_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_blkcipher *cipher;
+
+	cipher = crypto_spawn_blkcipher(spawn);
+	if (IS_ERR(cipher))
+		return PTR_ERR(cipher);
+
+	ctx->child = cipher;
+
+	return 0;
+}
+
+static void crypto_rfc3686_exit_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_rfc3686_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	crypto_free_blkcipher(ctx->child);
+}
+
+static struct crypto_instance *crypto_rfc3686_alloc(struct rtattr **tb)
+{
+	struct crypto_instance *inst;
+	struct crypto_alg *alg;
+	int err;
+
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_BLKCIPHER);
+	if (err)
+		return ERR_PTR(err);
+
+	alg = crypto_attr_alg(tb[1], CRYPTO_ALG_TYPE_BLKCIPHER,
+				  CRYPTO_ALG_TYPE_MASK);
+	err = PTR_ERR(alg);
+	if (IS_ERR(alg))
+		return ERR_PTR(err);
+
+	/* We only support 16-byte blocks. */
+	err = -EINVAL;
+	if (alg->cra_blkcipher.ivsize != CTR_RFC3686_BLOCK_SIZE)
+		goto out_put_alg;
+
+	/* Not a stream cipher? */
+	if (alg->cra_blocksize != 1)
+		goto out_put_alg;
+
+	inst = crypto_alloc_instance("rfc3686", alg);
+	if (IS_ERR(inst))
+		goto out;
+
+	inst->alg.cra_flags = CRYPTO_ALG_TYPE_BLKCIPHER;
+	inst->alg.cra_priority = alg->cra_priority;
+	inst->alg.cra_blocksize = 1;
+	inst->alg.cra_alignmask = alg->cra_alignmask;
+	inst->alg.cra_type = &crypto_blkcipher_type;
+
+	inst->alg.cra_blkcipher.ivsize = CTR_RFC3686_IV_SIZE;
+	inst->alg.cra_blkcipher.min_keysize = alg->cra_blkcipher.min_keysize
+					      + CTR_RFC3686_NONCE_SIZE;
+	inst->alg.cra_blkcipher.max_keysize = alg->cra_blkcipher.max_keysize
+					      + CTR_RFC3686_NONCE_SIZE;
+
+	inst->alg.cra_ctxsize = sizeof(struct crypto_rfc3686_ctx);
+
+	inst->alg.cra_init = crypto_rfc3686_init_tfm;
+	inst->alg.cra_exit = crypto_rfc3686_exit_tfm;
+
+	inst->alg.cra_blkcipher.setkey = crypto_rfc3686_setkey;
+	inst->alg.cra_blkcipher.encrypt = crypto_rfc3686_crypt;
+	inst->alg.cra_blkcipher.decrypt = crypto_rfc3686_crypt;
+
+out:
+	crypto_mod_put(alg);
+	return inst;
+
+out_put_alg:
+	inst = ERR_PTR(err);
+	goto out;
+}
+
+static struct crypto_template crypto_rfc3686_tmpl = {
+	.name = "rfc3686",
+	.alloc = crypto_rfc3686_alloc,
+	.free = crypto_ctr_free,
+	.module = THIS_MODULE,
+};
+
 static int __init crypto_ctr_module_init(void)
 {
-	return crypto_register_template(&crypto_ctr_tmpl);
+	int err;
+
+	err = crypto_register_template(&crypto_ctr_tmpl);
+	if (err)
+		goto out;
+
+	err = crypto_register_template(&crypto_rfc3686_tmpl);
+	if (err)
+		goto out_drop_ctr;
+
+out:
+	return err;
+
+out_drop_ctr:
+	crypto_unregister_template(&crypto_ctr_tmpl);
+	goto out;
 }
 
 static void __exit crypto_ctr_module_exit(void)
 {
+	crypto_unregister_template(&crypto_rfc3686_tmpl);
 	crypto_unregister_template(&crypto_ctr_tmpl);
 }
 
@@ -340,3 +417,4 @@ module_exit(crypto_ctr_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("CTR Counter block mode");
+MODULE_ALIAS("rfc3686");
diff --git a/crypto/gcm.c b/crypto/gcm.c
index 8f35670..1624301 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -402,9 +402,8 @@ static struct crypto_instance *crypto_gcm_alloc(struct rtattr **tb)
 		return inst;
 
 	inst = ERR_PTR(ENAMETOOLONG);
-	if (snprintf(
-		    ctr_name, CRYPTO_MAX_ALG_NAME,
-		    "ctr(%s,4,8,4)", cipher->cra_name) >= CRYPTO_MAX_ALG_NAME)
+	if (snprintf(ctr_name, CRYPTO_MAX_ALG_NAME, "rfc3686(ctr(%s))",
+		     cipher->cra_name) >= CRYPTO_MAX_ALG_NAME)
 		return inst;
 
 	ctr = crypto_alg_mod_lookup(ctr_name, CRYPTO_ALG_TYPE_BLKCIPHER,
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 0cfb8eb..1142b49 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1193,9 +1193,9 @@ static void do_test(void)
 			    AES_XTS_ENC_TEST_VECTORS);
 		test_cipher("xts(aes)", DECRYPT, aes_xts_dec_tv_template,
 			    AES_XTS_DEC_TEST_VECTORS);
-		test_cipher("ctr(aes,4,8,4)", ENCRYPT, aes_ctr_enc_tv_template,
+		test_cipher("rfc3686(ctr(aes))", ENCRYPT, aes_ctr_enc_tv_template,
 			    AES_CTR_ENC_TEST_VECTORS);
-		test_cipher("ctr(aes,4,8,4)", DECRYPT, aes_ctr_dec_tv_template,
+		test_cipher("rfc3686(ctr(aes))", DECRYPT, aes_ctr_dec_tv_template,
 			    AES_CTR_DEC_TEST_VECTORS);
 		test_aead("gcm(aes)", ENCRYPT, aes_gcm_enc_tv_template,
 			  AES_GCM_ENC_TEST_VECTORS);
@@ -1394,9 +1394,9 @@ static void do_test(void)
 			    AES_XTS_ENC_TEST_VECTORS);
 		test_cipher("xts(aes)", DECRYPT, aes_xts_dec_tv_template,
 			    AES_XTS_DEC_TEST_VECTORS);
-		test_cipher("ctr(aes,4,8,4)", ENCRYPT, aes_ctr_enc_tv_template,
+		test_cipher("rfc3686(ctr(aes))", ENCRYPT, aes_ctr_enc_tv_template,
 			    AES_CTR_ENC_TEST_VECTORS);
-		test_cipher("ctr(aes,4,8,4)", DECRYPT, aes_ctr_dec_tv_template,
+		test_cipher("rfc3686(ctr(aes))", DECRYPT, aes_ctr_dec_tv_template,
 			    AES_CTR_DEC_TEST_VECTORS);
 		break;
 
