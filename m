Return-Path: <SRS0=8/la=PM=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727730AbfADEU5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jan 2019 23:20:57 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 10/16] crypto: keywrap - convert to skcipher API
Date: Thu,  3 Jan 2019 20:16:19 -0800
Message-Id: <20190104041625.3259-11-ebiggers@kernel.org>
In-Reply-To: <20190104041625.3259-1-ebiggers@kernel.org>
References: <20190104041625.3259-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Convert the keywrap template from the deprecated "blkcipher" API to the
"skcipher" API, taking advantage of skcipher_alloc_instance_simple() to
simplify it considerably.

Cc: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/keywrap.c | 198 ++++++++++++++++-------------------------------
 1 file changed, 65 insertions(+), 133 deletions(-)

diff --git a/crypto/keywrap.c b/crypto/keywrap.c
index ec5c6a087c901..a5cfe610d8f40 100644
--- a/crypto/keywrap.c
+++ b/crypto/keywrap.c
@@ -56,7 +56,7 @@
  *	u8 *iv = data;
  *	u8 *pt = data + crypto_skcipher_ivsize(tfm);
  *		<ensure that pt contains the plaintext of size ptlen>
- *	sg_init_one(&sg, ptdata, ptlen);
+ *	sg_init_one(&sg, pt, ptlen);
  *	skcipher_request_set_crypt(req, &sg, &sg, ptlen, iv);
  *
  *	==> After encryption, data now contains full KW result as per SP800-38F.
@@ -70,8 +70,8 @@
  *	u8 *iv = data;
  *	u8 *ct = data + crypto_skcipher_ivsize(tfm);
  *	unsigned int ctlen = datalen - crypto_skcipher_ivsize(tfm);
- *	sg_init_one(&sg, ctdata, ctlen);
- *	skcipher_request_set_crypt(req, &sg, &sg, ptlen, iv);
+ *	sg_init_one(&sg, ct, ctlen);
+ *	skcipher_request_set_crypt(req, &sg, &sg, ctlen, iv);
  *
  *	==> After decryption (which hopefully does not return EBADMSG), the ct
  *	pointer now points to the plaintext of size ctlen.
@@ -87,10 +87,6 @@
 #include <crypto/scatterwalk.h>
 #include <crypto/internal/skcipher.h>
 
-struct crypto_kw_ctx {
-	struct crypto_cipher *child;
-};
-
 struct crypto_kw_block {
 #define SEMIBSIZE 8
 	__be64 A;
@@ -124,16 +120,13 @@ static void crypto_kw_scatterlist_ff(struct scatter_walk *walk,
 	}
 }
 
-static int crypto_kw_decrypt(struct blkcipher_desc *desc,
-			     struct scatterlist *dst, struct scatterlist *src,
-			     unsigned int nbytes)
+static int crypto_kw_decrypt(struct skcipher_request *req)
 {
-	struct crypto_blkcipher *tfm = desc->tfm;
-	struct crypto_kw_ctx *ctx = crypto_blkcipher_ctx(tfm);
-	struct crypto_cipher *child = ctx->child;
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_cipher *cipher = skcipher_cipher_simple(tfm);
 	struct crypto_kw_block block;
-	struct scatterlist *lsrc, *ldst;
-	u64 t = 6 * ((nbytes) >> 3);
+	struct scatterlist *src, *dst;
+	u64 t = 6 * ((req->cryptlen) >> 3);
 	unsigned int i;
 	int ret = 0;
 
@@ -141,27 +134,27 @@ static int crypto_kw_decrypt(struct blkcipher_desc *desc,
 	 * Require at least 2 semiblocks (note, the 3rd semiblock that is
 	 * required by SP800-38F is the IV.
 	 */
-	if (nbytes < (2 * SEMIBSIZE) || nbytes % SEMIBSIZE)
+	if (req->cryptlen < (2 * SEMIBSIZE) || req->cryptlen % SEMIBSIZE)
 		return -EINVAL;
 
 	/* Place the IV into block A */
-	memcpy(&block.A, desc->info, SEMIBSIZE);
+	memcpy(&block.A, req->iv, SEMIBSIZE);
 
 	/*
 	 * src scatterlist is read-only. dst scatterlist is r/w. During the
-	 * first loop, lsrc points to src and ldst to dst. For any
-	 * subsequent round, the code operates on dst only.
+	 * first loop, src points to req->src and dst to req->dst. For any
+	 * subsequent round, the code operates on req->dst only.
 	 */
-	lsrc = src;
-	ldst = dst;
+	src = req->src;
+	dst = req->dst;
 
 	for (i = 0; i < 6; i++) {
 		struct scatter_walk src_walk, dst_walk;
-		unsigned int tmp_nbytes = nbytes;
+		unsigned int nbytes = req->cryptlen;
 
-		while (tmp_nbytes) {
-			/* move pointer by tmp_nbytes in the SGL */
-			crypto_kw_scatterlist_ff(&src_walk, lsrc, tmp_nbytes);
+		while (nbytes) {
+			/* move pointer by nbytes in the SGL */
+			crypto_kw_scatterlist_ff(&src_walk, src, nbytes);
 			/* get the source block */
 			scatterwalk_copychunks(&block.R, &src_walk, SEMIBSIZE,
 					       false);
@@ -170,21 +163,21 @@ static int crypto_kw_decrypt(struct blkcipher_desc *desc,
 			block.A ^= cpu_to_be64(t);
 			t--;
 			/* perform KW operation: decrypt block */
-			crypto_cipher_decrypt_one(child, (u8*)&block,
-						  (u8*)&block);
+			crypto_cipher_decrypt_one(cipher, (u8 *)&block,
+						  (u8 *)&block);
 
-			/* move pointer by tmp_nbytes in the SGL */
-			crypto_kw_scatterlist_ff(&dst_walk, ldst, tmp_nbytes);
+			/* move pointer by nbytes in the SGL */
+			crypto_kw_scatterlist_ff(&dst_walk, dst, nbytes);
 			/* Copy block->R into place */
 			scatterwalk_copychunks(&block.R, &dst_walk, SEMIBSIZE,
 					       true);
 
-			tmp_nbytes -= SEMIBSIZE;
+			nbytes -= SEMIBSIZE;
 		}
 
 		/* we now start to operate on the dst SGL only */
-		lsrc = dst;
-		ldst = dst;
+		src = req->dst;
+		dst = req->dst;
 	}
 
 	/* Perform authentication check */
@@ -196,15 +189,12 @@ static int crypto_kw_decrypt(struct blkcipher_desc *desc,
 	return ret;
 }
 
-static int crypto_kw_encrypt(struct blkcipher_desc *desc,
-			     struct scatterlist *dst, struct scatterlist *src,
-			     unsigned int nbytes)
+static int crypto_kw_encrypt(struct skcipher_request *req)
 {
-	struct crypto_blkcipher *tfm = desc->tfm;
-	struct crypto_kw_ctx *ctx = crypto_blkcipher_ctx(tfm);
-	struct crypto_cipher *child = ctx->child;
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_cipher *cipher = skcipher_cipher_simple(tfm);
 	struct crypto_kw_block block;
-	struct scatterlist *lsrc, *ldst;
+	struct scatterlist *src, *dst;
 	u64 t = 1;
 	unsigned int i;
 
@@ -214,7 +204,7 @@ static int crypto_kw_encrypt(struct blkcipher_desc *desc,
 	 * This means that the dst memory must be one semiblock larger than src.
 	 * Also ensure that the given data is aligned to semiblock.
 	 */
-	if (nbytes < (2 * SEMIBSIZE) || nbytes % SEMIBSIZE)
+	if (req->cryptlen < (2 * SEMIBSIZE) || req->cryptlen % SEMIBSIZE)
 		return -EINVAL;
 
 	/*
@@ -225,26 +215,26 @@ static int crypto_kw_encrypt(struct blkcipher_desc *desc,
 
 	/*
 	 * src scatterlist is read-only. dst scatterlist is r/w. During the
-	 * first loop, lsrc points to src and ldst to dst. For any
-	 * subsequent round, the code operates on dst only.
+	 * first loop, src points to req->src and dst to req->dst. For any
+	 * subsequent round, the code operates on req->dst only.
 	 */
-	lsrc = src;
-	ldst = dst;
+	src = req->src;
+	dst = req->dst;
 
 	for (i = 0; i < 6; i++) {
 		struct scatter_walk src_walk, dst_walk;
-		unsigned int tmp_nbytes = nbytes;
+		unsigned int nbytes = req->cryptlen;
 
-		scatterwalk_start(&src_walk, lsrc);
-		scatterwalk_start(&dst_walk, ldst);
+		scatterwalk_start(&src_walk, src);
+		scatterwalk_start(&dst_walk, dst);
 
-		while (tmp_nbytes) {
+		while (nbytes) {
 			/* get the source block */
 			scatterwalk_copychunks(&block.R, &src_walk, SEMIBSIZE,
 					       false);
 
 			/* perform KW operation: encrypt block */
-			crypto_cipher_encrypt_one(child, (u8 *)&block,
+			crypto_cipher_encrypt_one(cipher, (u8 *)&block,
 						  (u8 *)&block);
 			/* perform KW operation: modify IV with counter */
 			block.A ^= cpu_to_be64(t);
@@ -254,117 +244,59 @@ static int crypto_kw_encrypt(struct blkcipher_desc *desc,
 			scatterwalk_copychunks(&block.R, &dst_walk, SEMIBSIZE,
 					       true);
 
-			tmp_nbytes -= SEMIBSIZE;
+			nbytes -= SEMIBSIZE;
 		}
 
 		/* we now start to operate on the dst SGL only */
-		lsrc = dst;
-		ldst = dst;
+		src = req->dst;
+		dst = req->dst;
 	}
 
 	/* establish the IV for the caller to pick up */
-	memcpy(desc->info, &block.A, SEMIBSIZE);
+	memcpy(req->iv, &block.A, SEMIBSIZE);
 
 	memzero_explicit(&block, sizeof(struct crypto_kw_block));
 
 	return 0;
 }
 
-static int crypto_kw_setkey(struct crypto_tfm *parent, const u8 *key,
-			    unsigned int keylen)
+static int crypto_kw_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
-	struct crypto_kw_ctx *ctx = crypto_tfm_ctx(parent);
-	struct crypto_cipher *child = ctx->child;
+	struct skcipher_instance *inst;
+	struct crypto_alg *alg;
 	int err;
 
-	crypto_cipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
-	crypto_cipher_set_flags(child, crypto_tfm_get_flags(parent) &
-				       CRYPTO_TFM_REQ_MASK);
-	err = crypto_cipher_setkey(child, key, keylen);
-	crypto_tfm_set_flags(parent, crypto_cipher_get_flags(child) &
-				     CRYPTO_TFM_RES_MASK);
-	return err;
-}
-
-static int crypto_kw_init_tfm(struct crypto_tfm *tfm)
-{
-	struct crypto_instance *inst = crypto_tfm_alg_instance(tfm);
-	struct crypto_spawn *spawn = crypto_instance_ctx(inst);
-	struct crypto_kw_ctx *ctx = crypto_tfm_ctx(tfm);
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
-static void crypto_kw_exit_tfm(struct crypto_tfm *tfm)
-{
-	struct crypto_kw_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	crypto_free_cipher(ctx->child);
-}
-
-static struct crypto_instance *crypto_kw_alloc(struct rtattr **tb)
-{
-	struct crypto_instance *inst = NULL;
-	struct crypto_alg *alg = NULL;
-	int err;
-
-	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_BLKCIPHER);
-	if (err)
-		return ERR_PTR(err);
-
-	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
-				  CRYPTO_ALG_TYPE_MASK);
-	if (IS_ERR(alg))
-		return ERR_CAST(alg);
+	inst = skcipher_alloc_instance_simple(tmpl, tb, &alg);
+	if (IS_ERR(inst))
+		return PTR_ERR(inst);
 
-	inst = ERR_PTR(-EINVAL);
+	err = -EINVAL;
 	/* Section 5.1 requirement for KW */
 	if (alg->cra_blocksize != sizeof(struct crypto_kw_block))
-		goto err;
+		goto out_free_inst;
 
-	inst = crypto_alloc_instance("kw", alg);
-	if (IS_ERR(inst))
-		goto err;
+	inst->alg.base.cra_blocksize = SEMIBSIZE;
+	inst->alg.base.cra_alignmask = 0;
+	inst->alg.ivsize = SEMIBSIZE;
 
-	inst->alg.cra_flags = CRYPTO_ALG_TYPE_BLKCIPHER;
-	inst->alg.cra_priority = alg->cra_priority;
-	inst->alg.cra_blocksize = SEMIBSIZE;
-	inst->alg.cra_alignmask = 0;
-	inst->alg.cra_type = &crypto_blkcipher_type;
-	inst->alg.cra_blkcipher.ivsize = SEMIBSIZE;
-	inst->alg.cra_blkcipher.min_keysize = alg->cra_cipher.cia_min_keysize;
-	inst->alg.cra_blkcipher.max_keysize = alg->cra_cipher.cia_max_keysize;
+	inst->alg.encrypt = crypto_kw_encrypt;
+	inst->alg.decrypt = crypto_kw_decrypt;
 
-	inst->alg.cra_ctxsize = sizeof(struct crypto_kw_ctx);
-
-	inst->alg.cra_init = crypto_kw_init_tfm;
-	inst->alg.cra_exit = crypto_kw_exit_tfm;
-
-	inst->alg.cra_blkcipher.setkey = crypto_kw_setkey;
-	inst->alg.cra_blkcipher.encrypt = crypto_kw_encrypt;
-	inst->alg.cra_blkcipher.decrypt = crypto_kw_decrypt;
+	err = skcipher_register_instance(tmpl, inst);
+	if (err)
+		goto out_free_inst;
+	goto out_put_alg;
 
-err:
+out_free_inst:
+	inst->free(inst);
+out_put_alg:
 	crypto_mod_put(alg);
-	return inst;
-}
-
-static void crypto_kw_free(struct crypto_instance *inst)
-{
-	crypto_drop_spawn(crypto_instance_ctx(inst));
-	kfree(inst);
+	return err;
 }
 
 static struct crypto_template crypto_kw_tmpl = {
 	.name = "kw",
-	.alloc = crypto_kw_alloc,
-	.free = crypto_kw_free,
+	.create = crypto_kw_create,
 	.module = THIS_MODULE,
 };
 
-- 
2.20.1
