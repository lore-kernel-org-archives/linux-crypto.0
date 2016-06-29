From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 28/28] crypto: cts - Convert to skcipher
Date: Wed, 29 Jun 2016 18:04:15 +0800
Message-ID: <E1bICLv-0006yO-S6@gondolin.me.apana.org.au>
References: <20160629100223.GA26260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55323 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbcF2KET (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2016 06:04:19 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bICLv-0005PA-W7
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jun 2016 20:04:16 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts cts over to the skcipher interface.  It also
optimises the implementation to use one CBC operation for all but
the last block, which is then processed separately.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/cts.c |  494 +++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 284 insertions(+), 210 deletions(-)

diff --git a/crypto/cts.c b/crypto/cts.c
index e467ec0ac..507b093 100644
--- a/crypto/cts.c
+++ b/crypto/cts.c
@@ -40,7 +40,7 @@
  * rfc3962 includes errata information in its Appendix A.
  */
 
-#include <crypto/algapi.h>
+#include <crypto/internal/skcipher.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -51,289 +51,363 @@
 #include <linux/slab.h>
 
 struct crypto_cts_ctx {
-	struct crypto_blkcipher *child;
+	struct crypto_skcipher *child;
 };
 
-static int crypto_cts_setkey(struct crypto_tfm *parent, const u8 *key,
-			     unsigned int keylen)
+struct crypto_cts_reqctx {
+	struct scatterlist sg[2];
+	unsigned offset;
+	struct skcipher_request subreq;
+};
+
+static inline u8 *crypto_cts_reqctx_space(struct skcipher_request *req)
 {
-	struct crypto_cts_ctx *ctx = crypto_tfm_ctx(parent);
-	struct crypto_blkcipher *child = ctx->child;
-	int err;
+	struct crypto_cts_reqctx *rctx = skcipher_request_ctx(req);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_cts_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct crypto_skcipher *child = ctx->child;
 
-	crypto_blkcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
-	crypto_blkcipher_set_flags(child, crypto_tfm_get_flags(parent) &
-				       CRYPTO_TFM_REQ_MASK);
-	err = crypto_blkcipher_setkey(child, key, keylen);
-	crypto_tfm_set_flags(parent, crypto_blkcipher_get_flags(child) &
-				     CRYPTO_TFM_RES_MASK);
-	return err;
+	return PTR_ALIGN((u8 *)(rctx + 1) + crypto_skcipher_reqsize(child),
+			 crypto_skcipher_alignmask(tfm) + 1);
 }
 
-static int cts_cbc_encrypt(struct crypto_cts_ctx *ctx,
-			   struct blkcipher_desc *desc,
-			   struct scatterlist *dst,
-			   struct scatterlist *src,
-			   unsigned int offset,
-			   unsigned int nbytes)
+static int crypto_cts_setkey(struct crypto_skcipher *parent, const u8 *key,
+			     unsigned int keylen)
 {
-	int bsize = crypto_blkcipher_blocksize(desc->tfm);
-	u8 tmp[bsize], tmp2[bsize];
-	struct blkcipher_desc lcldesc;
-	struct scatterlist sgsrc[1], sgdst[1];
-	int lastn = nbytes - bsize;
-	u8 iv[bsize];
-	u8 s[bsize * 2], d[bsize * 2];
+	struct crypto_cts_ctx *ctx = crypto_skcipher_ctx(parent);
+	struct crypto_skcipher *child = ctx->child;
 	int err;
 
-	if (lastn < 0)
-		return -EINVAL;
+	crypto_skcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(child, crypto_skcipher_get_flags(parent) &
+					 CRYPTO_TFM_REQ_MASK);
+	err = crypto_skcipher_setkey(child, key, keylen);
+	crypto_skcipher_set_flags(parent, crypto_skcipher_get_flags(child) &
+					  CRYPTO_TFM_RES_MASK);
+	return err;
+}
 
-	sg_init_table(sgsrc, 1);
-	sg_init_table(sgdst, 1);
+static void cts_cbc_crypt_done(struct crypto_async_request *areq, int err)
+{
+	struct skcipher_request *req = areq->data;
 
-	memset(s, 0, sizeof(s));
-	scatterwalk_map_and_copy(s, src, offset, nbytes, 0);
+	if (err == -EINPROGRESS)
+		return;
 
-	memcpy(iv, desc->info, bsize);
+	req->base.complete(&req->base, err);
+}
 
-	lcldesc.tfm = ctx->child;
-	lcldesc.info = iv;
-	lcldesc.flags = desc->flags;
+static int cts_cbc_encrypt(struct skcipher_request *req)
+{
+	struct crypto_cts_reqctx *rctx = skcipher_request_ctx(req);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct skcipher_request *subreq = &rctx->subreq;
+	int bsize = crypto_skcipher_blocksize(tfm);
+	u8 d[bsize * 2] __attribute__ ((aligned(__alignof__(u32))));
+	struct scatterlist *sg;
+	unsigned int offset;
+	int lastn;
+
+	offset = rctx->offset;
+	lastn = req->cryptlen - offset;
+
+	sg = scatterwalk_ffwd(rctx->sg, req->dst, offset - bsize);
+	scatterwalk_map_and_copy(d + bsize, sg, 0, bsize, 0);
+
+	memset(d, 0, bsize);
+	scatterwalk_map_and_copy(d, req->src, offset, lastn, 0);
+
+	scatterwalk_map_and_copy(d, sg, 0, bsize + lastn, 1);
+	memzero_explicit(d, sizeof(d));
+
+	skcipher_request_set_callback(subreq, req->base.flags &
+					      CRYPTO_TFM_REQ_MAY_BACKLOG,
+				      cts_cbc_crypt_done, req);
+	skcipher_request_set_crypt(subreq, sg, sg, bsize, req->iv);
+	return crypto_skcipher_encrypt(subreq);
+}
 
-	sg_set_buf(&sgsrc[0], s, bsize);
-	sg_set_buf(&sgdst[0], tmp, bsize);
-	err = crypto_blkcipher_encrypt_iv(&lcldesc, sgdst, sgsrc, bsize);
+static void crypto_cts_encrypt_done(struct crypto_async_request *areq, int err)
+{
+	struct skcipher_request *req = areq->data;
 
-	memcpy(d + bsize, tmp, lastn);
+	if (err)
+		goto out;
 
-	lcldesc.info = tmp;
+	err = cts_cbc_encrypt(req);
+	if (err == -EINPROGRESS ||
+	    (err == -EBUSY && req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG))
+		return;
 
-	sg_set_buf(&sgsrc[0], s + bsize, bsize);
-	sg_set_buf(&sgdst[0], tmp2, bsize);
-	err = crypto_blkcipher_encrypt_iv(&lcldesc, sgdst, sgsrc, bsize);
+out:
+	req->base.complete(&req->base, err);
+}
 
-	memcpy(d, tmp2, bsize);
+static int crypto_cts_encrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_cts_reqctx *rctx = skcipher_request_ctx(req);
+	struct crypto_cts_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_request *subreq = &rctx->subreq;
+	int bsize = crypto_skcipher_blocksize(tfm);
+	unsigned int nbytes = req->cryptlen;
+	int cbc_blocks = (nbytes + bsize - 1) / bsize - 1;
+	unsigned int offset;
+
+	skcipher_request_set_tfm(subreq, ctx->child);
+
+	if (cbc_blocks <= 0) {
+		skcipher_request_set_callback(subreq, req->base.flags,
+					      req->base.complete,
+					      req->base.data);
+		skcipher_request_set_crypt(subreq, req->src, req->dst, nbytes,
+					   req->iv);
+		return crypto_skcipher_encrypt(subreq);
+	}
 
-	scatterwalk_map_and_copy(d, dst, offset, nbytes, 1);
+	offset = cbc_blocks * bsize;
+	rctx->offset = offset;
 
-	memcpy(desc->info, tmp2, bsize);
+	skcipher_request_set_callback(subreq, req->base.flags,
+				      crypto_cts_encrypt_done, req);
+	skcipher_request_set_crypt(subreq, req->src, req->dst,
+				   offset, req->iv);
 
-	return err;
+	return crypto_skcipher_encrypt(subreq) ?:
+	       cts_cbc_encrypt(req);
 }
 
-static int crypto_cts_encrypt(struct blkcipher_desc *desc,
-			      struct scatterlist *dst, struct scatterlist *src,
-			      unsigned int nbytes)
+static int cts_cbc_decrypt(struct skcipher_request *req)
 {
-	struct crypto_cts_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	int bsize = crypto_blkcipher_blocksize(desc->tfm);
-	int tot_blocks = (nbytes + bsize - 1) / bsize;
-	int cbc_blocks = tot_blocks > 2 ? tot_blocks - 2 : 0;
-	struct blkcipher_desc lcldesc;
-	int err;
+	struct crypto_cts_reqctx *rctx = skcipher_request_ctx(req);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct skcipher_request *subreq = &rctx->subreq;
+	int bsize = crypto_skcipher_blocksize(tfm);
+	u8 d[bsize * 2] __attribute__ ((aligned(__alignof__(u32))));
+	struct scatterlist *sg;
+	unsigned int offset;
+	u8 *space;
+	int lastn;
+
+	offset = rctx->offset;
+	lastn = req->cryptlen - offset;
+
+	sg = scatterwalk_ffwd(rctx->sg, req->dst, offset - bsize);
+
+	/* 1. Decrypt Cn-1 (s) to create Dn */
+	scatterwalk_map_and_copy(d + bsize, sg, 0, bsize, 0);
+	space = crypto_cts_reqctx_space(req);
+	crypto_xor(d + bsize, space, bsize);
+	/* 2. Pad Cn with zeros at the end to create C of length BB */
+	memset(d, 0, bsize);
+	scatterwalk_map_and_copy(d, req->src, offset, lastn, 0);
+	/* 3. Exclusive-or Dn with C to create Xn */
+	/* 4. Select the first Ln bytes of Xn to create Pn */
+	crypto_xor(d + bsize, d, lastn);
+
+	/* 5. Append the tail (BB - Ln) bytes of Xn to Cn to create En */
+	memcpy(d + lastn, d + bsize + lastn, bsize - lastn);
+	/* 6. Decrypt En to create Pn-1 */
 
-	lcldesc.tfm = ctx->child;
-	lcldesc.info = desc->info;
-	lcldesc.flags = desc->flags;
-
-	if (tot_blocks == 1) {
-		err = crypto_blkcipher_encrypt_iv(&lcldesc, dst, src, bsize);
-	} else if (nbytes <= bsize * 2) {
-		err = cts_cbc_encrypt(ctx, desc, dst, src, 0, nbytes);
-	} else {
-		/* do normal function for tot_blocks - 2 */
-		err = crypto_blkcipher_encrypt_iv(&lcldesc, dst, src,
-							cbc_blocks * bsize);
-		if (err == 0) {
-			/* do cts for final two blocks */
-			err = cts_cbc_encrypt(ctx, desc, dst, src,
-						cbc_blocks * bsize,
-						nbytes - (cbc_blocks * bsize));
-		}
-	}
+	scatterwalk_map_and_copy(d, sg, 0, bsize + lastn, 1);
+	memzero_explicit(d, sizeof(d));
 
-	return err;
+	skcipher_request_set_callback(subreq, req->base.flags &
+					      CRYPTO_TFM_REQ_MAY_BACKLOG,
+				      cts_cbc_crypt_done, req);
+
+	skcipher_request_set_crypt(subreq, sg, sg, bsize, space);
+	return crypto_skcipher_decrypt(subreq);
 }
 
-static int cts_cbc_decrypt(struct crypto_cts_ctx *ctx,
-			   struct blkcipher_desc *desc,
-			   struct scatterlist *dst,
-			   struct scatterlist *src,
-			   unsigned int offset,
-			   unsigned int nbytes)
+static void crypto_cts_decrypt_done(struct crypto_async_request *areq, int err)
 {
-	int bsize = crypto_blkcipher_blocksize(desc->tfm);
-	u8 tmp[bsize];
-	struct blkcipher_desc lcldesc;
-	struct scatterlist sgsrc[1], sgdst[1];
-	int lastn = nbytes - bsize;
-	u8 iv[bsize];
-	u8 s[bsize * 2], d[bsize * 2];
-	int err;
-
-	if (lastn < 0)
-		return -EINVAL;
+	struct skcipher_request *req = areq->data;
 
-	sg_init_table(sgsrc, 1);
-	sg_init_table(sgdst, 1);
+	if (err)
+		goto out;
 
-	scatterwalk_map_and_copy(s, src, offset, nbytes, 0);
+	err = cts_cbc_decrypt(req);
+	if (err == -EINPROGRESS ||
+	    (err == -EBUSY && req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG))
+		return;
 
-	lcldesc.tfm = ctx->child;
-	lcldesc.info = iv;
-	lcldesc.flags = desc->flags;
+out:
+	req->base.complete(&req->base, err);
+}
 
-	/* 1. Decrypt Cn-1 (s) to create Dn (tmp)*/
-	memset(iv, 0, sizeof(iv));
-	sg_set_buf(&sgsrc[0], s, bsize);
-	sg_set_buf(&sgdst[0], tmp, bsize);
-	err = crypto_blkcipher_decrypt_iv(&lcldesc, sgdst, sgsrc, bsize);
-	if (err)
-		return err;
-	/* 2. Pad Cn with zeros at the end to create C of length BB */
-	memset(iv, 0, sizeof(iv));
-	memcpy(iv, s + bsize, lastn);
-	/* 3. Exclusive-or Dn (tmp) with C (iv) to create Xn (tmp) */
-	crypto_xor(tmp, iv, bsize);
-	/* 4. Select the first Ln bytes of Xn (tmp) to create Pn */
-	memcpy(d + bsize, tmp, lastn);
-
-	/* 5. Append the tail (BB - Ln) bytes of Xn (tmp) to Cn to create En */
-	memcpy(s + bsize + lastn, tmp + lastn, bsize - lastn);
-	/* 6. Decrypt En to create Pn-1 */
-	memzero_explicit(iv, sizeof(iv));
+static int crypto_cts_decrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_cts_reqctx *rctx = skcipher_request_ctx(req);
+	struct crypto_cts_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_request *subreq = &rctx->subreq;
+	int bsize = crypto_skcipher_blocksize(tfm);
+	unsigned int nbytes = req->cryptlen;
+	int cbc_blocks = (nbytes + bsize - 1) / bsize - 1;
+	unsigned int offset;
+	u8 *space;
+
+	skcipher_request_set_tfm(subreq, ctx->child);
+
+	if (cbc_blocks <= 0) {
+		skcipher_request_set_callback(subreq, req->base.flags,
+					      req->base.complete,
+					      req->base.data);
+		skcipher_request_set_crypt(subreq, req->src, req->dst, nbytes,
+					   req->iv);
+		return crypto_skcipher_decrypt(subreq);
+	}
 
-	sg_set_buf(&sgsrc[0], s + bsize, bsize);
-	sg_set_buf(&sgdst[0], d, bsize);
-	err = crypto_blkcipher_decrypt_iv(&lcldesc, sgdst, sgsrc, bsize);
+	skcipher_request_set_callback(subreq, req->base.flags,
+				      crypto_cts_decrypt_done, req);
 
-	/* XOR with previous block */
-	crypto_xor(d, desc->info, bsize);
+	space = crypto_cts_reqctx_space(req);
 
-	scatterwalk_map_and_copy(d, dst, offset, nbytes, 1);
+	offset = cbc_blocks * bsize;
+	rctx->offset = offset;
 
-	memcpy(desc->info, s, bsize);
-	return err;
-}
+	if (cbc_blocks <= 1)
+		memcpy(space, req->iv, bsize);
+	else
+		scatterwalk_map_and_copy(space, req->src, offset - 2 * bsize,
+					 bsize, 0);
 
-static int crypto_cts_decrypt(struct blkcipher_desc *desc,
-			      struct scatterlist *dst, struct scatterlist *src,
-			      unsigned int nbytes)
-{
-	struct crypto_cts_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	int bsize = crypto_blkcipher_blocksize(desc->tfm);
-	int tot_blocks = (nbytes + bsize - 1) / bsize;
-	int cbc_blocks = tot_blocks > 2 ? tot_blocks - 2 : 0;
-	struct blkcipher_desc lcldesc;
-	int err;
+	skcipher_request_set_crypt(subreq, req->src, req->dst,
+				   offset, req->iv);
 
-	lcldesc.tfm = ctx->child;
-	lcldesc.info = desc->info;
-	lcldesc.flags = desc->flags;
-
-	if (tot_blocks == 1) {
-		err = crypto_blkcipher_decrypt_iv(&lcldesc, dst, src, bsize);
-	} else if (nbytes <= bsize * 2) {
-		err = cts_cbc_decrypt(ctx, desc, dst, src, 0, nbytes);
-	} else {
-		/* do normal function for tot_blocks - 2 */
-		err = crypto_blkcipher_decrypt_iv(&lcldesc, dst, src,
-							cbc_blocks * bsize);
-		if (err == 0) {
-			/* do cts for final two blocks */
-			err = cts_cbc_decrypt(ctx, desc, dst, src,
-						cbc_blocks * bsize,
-						nbytes - (cbc_blocks * bsize));
-		}
-	}
-	return err;
+	return crypto_skcipher_decrypt(subreq) ?:
+	       cts_cbc_decrypt(req);
 }
 
-static int crypto_cts_init_tfm(struct crypto_tfm *tfm)
+static int crypto_cts_init_tfm(struct crypto_skcipher *tfm)
 {
-	struct crypto_instance *inst = (void *)tfm->__crt_alg;
-	struct crypto_spawn *spawn = crypto_instance_ctx(inst);
-	struct crypto_cts_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct crypto_blkcipher *cipher;
-
-	cipher = crypto_spawn_blkcipher(spawn);
+	struct skcipher_instance *inst = skcipher_alg_instance(tfm);
+	struct crypto_skcipher_spawn *spawn = skcipher_instance_ctx(inst);
+	struct crypto_cts_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct crypto_skcipher *cipher;
+	unsigned reqsize;
+	unsigned bsize;
+	unsigned align;
+
+	cipher = crypto_spawn_skcipher2(spawn);
 	if (IS_ERR(cipher))
 		return PTR_ERR(cipher);
 
 	ctx->child = cipher;
+
+	align = crypto_skcipher_alignmask(tfm);
+	bsize = crypto_skcipher_blocksize(cipher);
+	reqsize = ALIGN(sizeof(struct crypto_cts_reqctx) +
+			crypto_skcipher_reqsize(cipher),
+			crypto_tfm_ctx_alignment()) +
+		  (align & ~(crypto_tfm_ctx_alignment() - 1)) + bsize;
+
+	crypto_skcipher_set_reqsize(tfm, reqsize);
+
 	return 0;
 }
 
-static void crypto_cts_exit_tfm(struct crypto_tfm *tfm)
+static void crypto_cts_exit_tfm(struct crypto_skcipher *tfm)
 {
-	struct crypto_cts_ctx *ctx = crypto_tfm_ctx(tfm);
-	crypto_free_blkcipher(ctx->child);
+	struct crypto_cts_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	crypto_free_skcipher(ctx->child);
 }
 
-static struct crypto_instance *crypto_cts_alloc(struct rtattr **tb)
+static void crypto_cts_free(struct skcipher_instance *inst)
 {
-	struct crypto_instance *inst;
-	struct crypto_alg *alg;
+	crypto_drop_skcipher(skcipher_instance_ctx(inst));
+	kfree(inst);
+}
+
+static int crypto_cts_create(struct crypto_template *tmpl, struct rtattr **tb)
+{
+	struct crypto_skcipher_spawn *spawn;
+	struct skcipher_instance *inst;
+	struct crypto_attr_type *algt;
+	struct skcipher_alg *alg;
+	const char *cipher_name;
 	int err;
 
-	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_BLKCIPHER);
+	algt = crypto_get_attr_type(tb);
+	if (IS_ERR(algt))
+		return PTR_ERR(algt);
+
+	if ((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask)
+		return -EINVAL;
+
+	cipher_name = crypto_attr_alg_name(tb[1]);
+	if (IS_ERR(cipher_name))
+		return PTR_ERR(cipher_name);
+
+	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
+	if (!inst)
+		return -ENOMEM;
+
+	spawn = skcipher_instance_ctx(inst);
+
+	crypto_set_skcipher_spawn(spawn, skcipher_crypto_instance(inst));
+	err = crypto_grab_skcipher2(spawn, cipher_name, 0,
+				    crypto_requires_sync(algt->type,
+							 algt->mask));
 	if (err)
-		return ERR_PTR(err);
+		goto err_free_inst;
 
-	alg = crypto_attr_alg(tb[1], CRYPTO_ALG_TYPE_BLKCIPHER,
-				  CRYPTO_ALG_TYPE_MASK);
-	if (IS_ERR(alg))
-		return ERR_CAST(alg);
+	alg = crypto_spawn_skcipher_alg(spawn);
 
-	inst = ERR_PTR(-EINVAL);
-	if (!is_power_of_2(alg->cra_blocksize))
-		goto out_put_alg;
+	err = -EINVAL;
+	if (crypto_skcipher_alg_ivsize(alg) != alg->base.cra_blocksize)
+		goto err_drop_spawn;
 
-	if (strncmp(alg->cra_name, "cbc(", 4))
-		goto out_put_alg;
+	if (strncmp(alg->base.cra_name, "cbc(", 4))
+		goto err_drop_spawn;
 
-	inst = crypto_alloc_instance("cts", alg);
-	if (IS_ERR(inst))
-		goto out_put_alg;
+	err = crypto_inst_setname(skcipher_crypto_instance(inst), "cts",
+				  &alg->base);
+	if (err)
+		goto err_drop_spawn;
 
-	inst->alg.cra_flags = CRYPTO_ALG_TYPE_BLKCIPHER;
-	inst->alg.cra_priority = alg->cra_priority;
-	inst->alg.cra_blocksize = alg->cra_blocksize;
-	inst->alg.cra_alignmask = alg->cra_alignmask;
-	inst->alg.cra_type = &crypto_blkcipher_type;
+	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_priority = alg->base.cra_priority;
+	inst->alg.base.cra_blocksize = alg->base.cra_blocksize;
+	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
 
 	/* We access the data as u32s when xoring. */
-	inst->alg.cra_alignmask |= __alignof__(u32) - 1;
+	inst->alg.base.cra_alignmask |= __alignof__(u32) - 1;
 
-	inst->alg.cra_blkcipher.ivsize = alg->cra_blocksize;
-	inst->alg.cra_blkcipher.min_keysize = alg->cra_blkcipher.min_keysize;
-	inst->alg.cra_blkcipher.max_keysize = alg->cra_blkcipher.max_keysize;
+	inst->alg.ivsize = alg->base.cra_blocksize;
+	inst->alg.min_keysize = crypto_skcipher_alg_min_keysize(alg);
+	inst->alg.max_keysize = crypto_skcipher_alg_max_keysize(alg);
 
-	inst->alg.cra_ctxsize = sizeof(struct crypto_cts_ctx);
+	inst->alg.base.cra_ctxsize = sizeof(struct crypto_cts_ctx);
 
-	inst->alg.cra_init = crypto_cts_init_tfm;
-	inst->alg.cra_exit = crypto_cts_exit_tfm;
+	inst->alg.init = crypto_cts_init_tfm;
+	inst->alg.exit = crypto_cts_exit_tfm;
 
-	inst->alg.cra_blkcipher.setkey = crypto_cts_setkey;
-	inst->alg.cra_blkcipher.encrypt = crypto_cts_encrypt;
-	inst->alg.cra_blkcipher.decrypt = crypto_cts_decrypt;
+	inst->alg.setkey = crypto_cts_setkey;
+	inst->alg.encrypt = crypto_cts_encrypt;
+	inst->alg.decrypt = crypto_cts_decrypt;
 
-out_put_alg:
-	crypto_mod_put(alg);
-	return inst;
-}
+	inst->free = crypto_cts_free;
 
-static void crypto_cts_free(struct crypto_instance *inst)
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
+	crypto_drop_skcipher(spawn);
+err_free_inst:
 	kfree(inst);
+	goto out;
 }
 
 static struct crypto_template crypto_cts_tmpl = {
 	.name = "cts",
-	.alloc = crypto_cts_alloc,
-	.free = crypto_cts_free,
+	.create = crypto_cts_create,
 	.module = THIS_MODULE,
 };
 
