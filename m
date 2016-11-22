From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v3 PATCH 4/16] crypto: xts - Convert to skcipher
Date: Tue, 22 Nov 2016 20:08:19 +0800
Message-ID: <E1c99s3-00037c-7s@gondobar>
References: <20161122120703.GA11911@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33723 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932532AbcKVMIb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Nov 2016 07:08:31 -0500
Received: from [192.168.128.4] (helo=gondobar)
        by fornost.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
        id 1c99s9-00060Z-F9
        for <linux-crypto@vger.kernel.org>; Tue, 22 Nov 2016 23:08:26 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts xts over to the skcipher interface.  It also
optimises the implementation to be based on ECB instead of the
underlying cipher.  For compatibility the existing naming scheme
of xts(aes) is maintained as opposed to the more obvious one of
xts(ecb(aes)).

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/xts.c         |  547 ++++++++++++++++++++++++++++++++++++---------------
 include/crypto/xts.h |   26 ++
 2 files changed, 416 insertions(+), 157 deletions(-)

diff --git a/crypto/xts.c b/crypto/xts.c
index 305343f..410a2e2 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -13,7 +13,8 @@
  * Software Foundation; either version 2 of the License, or (at your option)
  * any later version.
  */
-#include <crypto/algapi.h>
+#include <crypto/internal/skcipher.h>
+#include <crypto/scatterwalk.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -25,140 +26,320 @@
 #include <crypto/b128ops.h>
 #include <crypto/gf128mul.h>
 
+#define XTS_BUFFER_SIZE 128u
+
 struct priv {
-	struct crypto_cipher *child;
+	struct crypto_skcipher *child;
 	struct crypto_cipher *tweak;
 };
 
-static int setkey(struct crypto_tfm *parent, const u8 *key,
+struct xts_instance_ctx {
+	struct crypto_skcipher_spawn spawn;
+	char name[CRYPTO_MAX_ALG_NAME];
+};
+
+struct rctx {
+	be128 buf[XTS_BUFFER_SIZE / sizeof(be128)];
+
+	be128 t;
+
+	be128 *ext;
+
+	struct scatterlist srcbuf[2];
+	struct scatterlist dstbuf[2];
+	struct scatterlist *src;
+	struct scatterlist *dst;
+
+	unsigned int left;
+
+	struct skcipher_request subreq;
+};
+
+static int setkey(struct crypto_skcipher *parent, const u8 *key,
 		  unsigned int keylen)
 {
-	struct priv *ctx = crypto_tfm_ctx(parent);
-	struct crypto_cipher *child = ctx->tweak;
+	struct priv *ctx = crypto_skcipher_ctx(parent);
+	struct crypto_skcipher *child;
+	struct crypto_cipher *tweak;
 	int err;
 
-	err = xts_check_key(parent, key, keylen);
+	err = xts_verify_key(parent, key, keylen);
 	if (err)
 		return err;
 
+	keylen /= 2;
+
 	/* we need two cipher instances: one to compute the initial 'tweak'
 	 * by encrypting the IV (usually the 'plain' iv) and the other
 	 * one to encrypt and decrypt the data */
 
 	/* tweak cipher, uses Key2 i.e. the second half of *key */
-	crypto_cipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
-	crypto_cipher_set_flags(child, crypto_tfm_get_flags(parent) &
+	tweak = ctx->tweak;
+	crypto_cipher_clear_flags(tweak, CRYPTO_TFM_REQ_MASK);
+	crypto_cipher_set_flags(tweak, crypto_skcipher_get_flags(parent) &
 				       CRYPTO_TFM_REQ_MASK);
-	err = crypto_cipher_setkey(child, key + keylen/2, keylen/2);
+	err = crypto_cipher_setkey(tweak, key + keylen, keylen);
+	crypto_skcipher_set_flags(parent, crypto_cipher_get_flags(tweak) &
+					  CRYPTO_TFM_RES_MASK);
 	if (err)
 		return err;
 
-	crypto_tfm_set_flags(parent, crypto_cipher_get_flags(child) &
-				     CRYPTO_TFM_RES_MASK);
-
+	/* data cipher, uses Key1 i.e. the first half of *key */
 	child = ctx->child;
+	crypto_skcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(child, crypto_skcipher_get_flags(parent) &
+					 CRYPTO_TFM_REQ_MASK);
+	err = crypto_skcipher_setkey(child, key, keylen);
+	crypto_skcipher_set_flags(parent, crypto_skcipher_get_flags(child) &
+					  CRYPTO_TFM_RES_MASK);
 
-	/* data cipher, uses Key1 i.e. the first half of *key */
-	crypto_cipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
-	crypto_cipher_set_flags(child, crypto_tfm_get_flags(parent) &
-				       CRYPTO_TFM_REQ_MASK);
-	err = crypto_cipher_setkey(child, key, keylen/2);
-	if (err)
-		return err;
+	return err;
+}
 
-	crypto_tfm_set_flags(parent, crypto_cipher_get_flags(child) &
-				     CRYPTO_TFM_RES_MASK);
+static int post_crypt(struct skcipher_request *req)
+{
+	struct rctx *rctx = skcipher_request_ctx(req);
+	be128 *buf = rctx->ext ?: rctx->buf;
+	struct skcipher_request *subreq;
+	const int bs = XTS_BLOCK_SIZE;
+	struct skcipher_walk w;
+	struct scatterlist *sg;
+	unsigned offset;
+	int err;
 
-	return 0;
-}
+	subreq = &rctx->subreq;
+	err = skcipher_walk_virt(&w, subreq, false);
 
-struct sinfo {
-	be128 *t;
-	struct crypto_tfm *tfm;
-	void (*fn)(struct crypto_tfm *, u8 *, const u8 *);
-};
+	while (w.nbytes) {
+		unsigned int avail = w.nbytes;
+		be128 *wdst;
 
-static inline void xts_round(struct sinfo *s, void *dst, const void *src)
-{
-	be128_xor(dst, s->t, src);		/* PP <- T xor P */
-	s->fn(s->tfm, dst, dst);		/* CC <- E(Key1,PP) */
-	be128_xor(dst, dst, s->t);		/* C <- T xor CC */
+		wdst = w.dst.virt.addr;
+
+		do {
+			be128_xor(wdst, buf++, wdst);
+			wdst++;
+		} while ((avail -= bs) >= bs);
+
+		err = skcipher_walk_done(&w, avail);
+	}
+
+	rctx->left -= subreq->cryptlen;
+
+	if (err || !rctx->left)
+		goto out;
+
+	rctx->dst = rctx->dstbuf;
+
+	scatterwalk_done(&w.out, 0, 1);
+	sg = w.out.sg;
+	offset = w.out.offset;
+
+	if (rctx->dst != sg) {
+		rctx->dst[0] = *sg;
+		sg_unmark_end(rctx->dst);
+		scatterwalk_crypto_chain(rctx->dst, sg_next(sg), 0, 2);
+	}
+	rctx->dst[0].length -= offset - sg->offset;
+	rctx->dst[0].offset = offset;
+
+out:
+	return err;
 }
 
-static int crypt(struct blkcipher_desc *d,
-		 struct blkcipher_walk *w, struct priv *ctx,
-		 void (*tw)(struct crypto_tfm *, u8 *, const u8 *),
-		 void (*fn)(struct crypto_tfm *, u8 *, const u8 *))
+static int pre_crypt(struct skcipher_request *req)
 {
-	int err;
-	unsigned int avail;
+	struct rctx *rctx = skcipher_request_ctx(req);
+	be128 *buf = rctx->ext ?: rctx->buf;
+	struct skcipher_request *subreq;
 	const int bs = XTS_BLOCK_SIZE;
-	struct sinfo s = {
-		.tfm = crypto_cipher_tfm(ctx->child),
-		.fn = fn
-	};
-	u8 *wsrc;
-	u8 *wdst;
-
-	err = blkcipher_walk_virt(d, w);
-	if (!w->nbytes)
-		return err;
+	struct skcipher_walk w;
+	struct scatterlist *sg;
+	unsigned cryptlen;
+	unsigned offset;
+	bool more;
+	int err;
 
-	s.t = (be128 *)w->iv;
-	avail = w->nbytes;
+	subreq = &rctx->subreq;
+	cryptlen = subreq->cryptlen;
 
-	wsrc = w->src.virt.addr;
-	wdst = w->dst.virt.addr;
+	more = rctx->left > cryptlen;
+	if (!more)
+		cryptlen = rctx->left;
 
-	/* calculate first value of T */
-	tw(crypto_cipher_tfm(ctx->tweak), w->iv, w->iv);
+	skcipher_request_set_crypt(subreq, rctx->src, rctx->dst,
+				   cryptlen, NULL);
 
-	goto first;
+	err = skcipher_walk_virt(&w, subreq, false);
 
-	for (;;) {
-		do {
-			gf128mul_x_ble(s.t, s.t);
+	while (w.nbytes) {
+		unsigned int avail = w.nbytes;
+		be128 *wsrc;
+		be128 *wdst;
 
-first:
-			xts_round(&s, wdst, wsrc);
+		wsrc = w.src.virt.addr;
+		wdst = w.dst.virt.addr;
 
-			wsrc += bs;
-			wdst += bs;
+		do {
+			*buf++ = rctx->t;
+			be128_xor(wdst++, &rctx->t, wsrc++);
+			gf128mul_x_ble(&rctx->t, &rctx->t);
 		} while ((avail -= bs) >= bs);
 
-		err = blkcipher_walk_done(d, w, avail);
-		if (!w->nbytes)
-			break;
+		err = skcipher_walk_done(&w, avail);
+	}
+
+	skcipher_request_set_crypt(subreq, rctx->dst, rctx->dst,
+				   cryptlen, NULL);
 
-		avail = w->nbytes;
+	if (err || !more)
+		goto out;
 
-		wsrc = w->src.virt.addr;
-		wdst = w->dst.virt.addr;
+	rctx->src = rctx->srcbuf;
+
+	scatterwalk_done(&w.in, 0, 1);
+	sg = w.in.sg;
+	offset = w.in.offset;
+
+	if (rctx->src != sg) {
+		rctx->src[0] = *sg;
+		sg_unmark_end(rctx->src);
+		scatterwalk_crypto_chain(rctx->src, sg_next(sg), 0, 2);
 	}
+	rctx->src[0].length -= offset - sg->offset;
+	rctx->src[0].offset = offset;
 
+out:
 	return err;
 }
 
-static int encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
-		   struct scatterlist *src, unsigned int nbytes)
+static int init_crypt(struct skcipher_request *req, crypto_completion_t done)
 {
-	struct priv *ctx = crypto_blkcipher_ctx(desc->tfm);
-	struct blkcipher_walk w;
+	struct priv *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
+	struct rctx *rctx = skcipher_request_ctx(req);
+	struct skcipher_request *subreq;
+	gfp_t gfp;
+
+	subreq = &rctx->subreq;
+	skcipher_request_set_tfm(subreq, ctx->child);
+	skcipher_request_set_callback(subreq, req->base.flags, done, req);
+
+	gfp = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
+							   GFP_ATOMIC;
+	rctx->ext = NULL;
+
+	subreq->cryptlen = XTS_BUFFER_SIZE;
+	if (req->cryptlen > XTS_BUFFER_SIZE) {
+		subreq->cryptlen = min(req->cryptlen, (unsigned)PAGE_SIZE);
+		rctx->ext = kmalloc(subreq->cryptlen, gfp);
+	}
+
+	rctx->src = req->src;
+	rctx->dst = req->dst;
+	rctx->left = req->cryptlen;
 
-	blkcipher_walk_init(&w, dst, src, nbytes);
-	return crypt(desc, &w, ctx, crypto_cipher_alg(ctx->tweak)->cia_encrypt,
-		     crypto_cipher_alg(ctx->child)->cia_encrypt);
+	/* calculate first value of T */
+	crypto_cipher_encrypt_one(ctx->tweak, (u8 *)&rctx->t, req->iv);
+
+	return 0;
 }
 
-static int decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
-		   struct scatterlist *src, unsigned int nbytes)
+static void exit_crypt(struct skcipher_request *req)
 {
-	struct priv *ctx = crypto_blkcipher_ctx(desc->tfm);
-	struct blkcipher_walk w;
+	struct rctx *rctx = skcipher_request_ctx(req);
+
+	rctx->left = 0;
 
-	blkcipher_walk_init(&w, dst, src, nbytes);
-	return crypt(desc, &w, ctx, crypto_cipher_alg(ctx->tweak)->cia_encrypt,
-		     crypto_cipher_alg(ctx->child)->cia_decrypt);
+	if (rctx->ext)
+		kzfree(rctx->ext);
+}
+
+static int do_encrypt(struct skcipher_request *req, int err)
+{
+	struct rctx *rctx = skcipher_request_ctx(req);
+	struct skcipher_request *subreq;
+
+	subreq = &rctx->subreq;
+
+	while (!err && rctx->left) {
+		err = pre_crypt(req) ?:
+		      crypto_skcipher_encrypt(subreq) ?:
+		      post_crypt(req);
+
+		if (err == -EINPROGRESS ||
+		    (err == -EBUSY &&
+		     req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG))
+			return err;
+	}
+
+	exit_crypt(req);
+	return err;
+}
+
+static void encrypt_done(struct crypto_async_request *areq, int err)
+{
+	struct skcipher_request *req = areq->data;
+	struct skcipher_request *subreq;
+	struct rctx *rctx;
+
+	rctx = skcipher_request_ctx(req);
+	subreq = &rctx->subreq;
+	subreq->base.flags &= CRYPTO_TFM_REQ_MAY_BACKLOG;
+
+	err = do_encrypt(req, err ?: post_crypt(req));
+	if (rctx->left)
+		return;
+
+	skcipher_request_complete(req, err);
+}
+
+static int encrypt(struct skcipher_request *req)
+{
+	return do_encrypt(req, init_crypt(req, encrypt_done));
+}
+
+static int do_decrypt(struct skcipher_request *req, int err)
+{
+	struct rctx *rctx = skcipher_request_ctx(req);
+	struct skcipher_request *subreq;
+
+	subreq = &rctx->subreq;
+
+	while (!err && rctx->left) {
+		err = pre_crypt(req) ?:
+		      crypto_skcipher_decrypt(subreq) ?:
+		      post_crypt(req);
+
+		if (err == -EINPROGRESS ||
+		    (err == -EBUSY &&
+		     req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG))
+			return err;
+	}
+
+	exit_crypt(req);
+	return err;
+}
+
+static void decrypt_done(struct crypto_async_request *areq, int err)
+{
+	struct skcipher_request *req = areq->data;
+	struct skcipher_request *subreq;
+	struct rctx *rctx;
+
+	rctx = skcipher_request_ctx(req);
+	subreq = &rctx->subreq;
+	subreq->base.flags &= CRYPTO_TFM_REQ_MAY_BACKLOG;
+
+	err = do_decrypt(req, err ?: post_crypt(req));
+	if (rctx->left)
+		return;
+
+	skcipher_request_complete(req, err);
+}
+
+static int decrypt(struct skcipher_request *req)
+{
+	return do_decrypt(req, init_crypt(req, decrypt_done));
 }
 
 int xts_crypt(struct blkcipher_desc *desc, struct scatterlist *sdst,
@@ -233,112 +414,168 @@ int xts_crypt(struct blkcipher_desc *desc, struct scatterlist *sdst,
 }
 EXPORT_SYMBOL_GPL(xts_crypt);
 
-static int init_tfm(struct crypto_tfm *tfm)
+static int init_tfm(struct crypto_skcipher *tfm)
 {
-	struct crypto_cipher *cipher;
-	struct crypto_instance *inst = (void *)tfm->__crt_alg;
-	struct crypto_spawn *spawn = crypto_instance_ctx(inst);
-	struct priv *ctx = crypto_tfm_ctx(tfm);
-	u32 *flags = &tfm->crt_flags;
-
-	cipher = crypto_spawn_cipher(spawn);
-	if (IS_ERR(cipher))
-		return PTR_ERR(cipher);
-
-	if (crypto_cipher_blocksize(cipher) != XTS_BLOCK_SIZE) {
-		*flags |= CRYPTO_TFM_RES_BAD_BLOCK_LEN;
-		crypto_free_cipher(cipher);
-		return -EINVAL;
-	}
+	struct skcipher_instance *inst = skcipher_alg_instance(tfm);
+	struct xts_instance_ctx *ictx = skcipher_instance_ctx(inst);
+	struct priv *ctx = crypto_skcipher_ctx(tfm);
+	struct crypto_skcipher *child;
+	struct crypto_cipher *tweak;
 
-	ctx->child = cipher;
+	child = crypto_spawn_skcipher(&ictx->spawn);
+	if (IS_ERR(child))
+		return PTR_ERR(child);
 
-	cipher = crypto_spawn_cipher(spawn);
-	if (IS_ERR(cipher)) {
-		crypto_free_cipher(ctx->child);
-		return PTR_ERR(cipher);
-	}
+	ctx->child = child;
 
-	/* this check isn't really needed, leave it here just in case */
-	if (crypto_cipher_blocksize(cipher) != XTS_BLOCK_SIZE) {
-		crypto_free_cipher(cipher);
-		crypto_free_cipher(ctx->child);
-		*flags |= CRYPTO_TFM_RES_BAD_BLOCK_LEN;
-		return -EINVAL;
+	tweak = crypto_alloc_cipher(ictx->name, 0, 0);
+	if (IS_ERR(tweak)) {
+		crypto_free_skcipher(ctx->child);
+		return PTR_ERR(tweak);
 	}
 
-	ctx->tweak = cipher;
+	ctx->tweak = tweak;
+
+	crypto_skcipher_set_reqsize(tfm, crypto_skcipher_reqsize(child) +
+					 sizeof(struct rctx));
 
 	return 0;
 }
 
-static void exit_tfm(struct crypto_tfm *tfm)
+static void exit_tfm(struct crypto_skcipher *tfm)
 {
-	struct priv *ctx = crypto_tfm_ctx(tfm);
-	crypto_free_cipher(ctx->child);
+	struct priv *ctx = crypto_skcipher_ctx(tfm);
+
+	crypto_free_skcipher(ctx->child);
 	crypto_free_cipher(ctx->tweak);
 }
 
-static struct crypto_instance *alloc(struct rtattr **tb)
+static void free(struct skcipher_instance *inst)
+{
+	crypto_drop_skcipher(skcipher_instance_ctx(inst));
+	kfree(inst);
+}
+
+static int create(struct crypto_template *tmpl, struct rtattr **tb)
 {
-	struct crypto_instance *inst;
-	struct crypto_alg *alg;
+	struct skcipher_instance *inst;
+	struct crypto_attr_type *algt;
+	struct xts_instance_ctx *ctx;
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
+	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
+	if (!inst)
+		return -ENOMEM;
+
+	ctx = skcipher_instance_ctx(inst);
+
+	crypto_set_skcipher_spawn(&ctx->spawn, skcipher_crypto_instance(inst));
+	err = crypto_grab_skcipher(&ctx->spawn, cipher_name, 0,
+				   crypto_requires_sync(algt->type,
+							algt->mask));
+	if (err == -ENOENT) {
+		err = -ENAMETOOLONG;
+		if (snprintf(ctx->name, CRYPTO_MAX_ALG_NAME, "ecb(%s)",
+			     cipher_name) >= CRYPTO_MAX_ALG_NAME)
+			goto err_free_inst;
+
+		err = crypto_grab_skcipher(&ctx->spawn, ctx->name, 0,
+					   crypto_requires_sync(algt->type,
+								algt->mask));
+	}
+
 	if (err)
-		return ERR_PTR(err);
+		goto err_free_inst;
 
-	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
-				  CRYPTO_ALG_TYPE_MASK);
-	if (IS_ERR(alg))
-		return ERR_CAST(alg);
+	alg = crypto_skcipher_spawn_alg(&ctx->spawn);
 
-	inst = crypto_alloc_instance("xts", alg);
-	if (IS_ERR(inst))
-		goto out_put_alg;
+	err = -EINVAL;
+	if (alg->base.cra_blocksize != XTS_BLOCK_SIZE)
+		goto err_drop_spawn;
 
-	inst->alg.cra_flags = CRYPTO_ALG_TYPE_BLKCIPHER;
-	inst->alg.cra_priority = alg->cra_priority;
-	inst->alg.cra_blocksize = alg->cra_blocksize;
+	if (crypto_skcipher_alg_ivsize(alg))
+		goto err_drop_spawn;
 
-	if (alg->cra_alignmask < 7)
-		inst->alg.cra_alignmask = 7;
-	else
-		inst->alg.cra_alignmask = alg->cra_alignmask;
+	err = crypto_inst_setname(skcipher_crypto_instance(inst), "xts",
+				  &alg->base);
+	if (err)
+		goto err_drop_spawn;
 
-	inst->alg.cra_type = &crypto_blkcipher_type;
+	err = -EINVAL;
+	cipher_name = alg->base.cra_name;
 
-	inst->alg.cra_blkcipher.ivsize = alg->cra_blocksize;
-	inst->alg.cra_blkcipher.min_keysize =
-		2 * alg->cra_cipher.cia_min_keysize;
-	inst->alg.cra_blkcipher.max_keysize =
-		2 * alg->cra_cipher.cia_max_keysize;
+	/* Alas we screwed up the naming so we have to mangle the
+	 * cipher name.
+	 */
+	if (!strncmp(cipher_name, "ecb(", 4)) {
+		unsigned len;
 
-	inst->alg.cra_ctxsize = sizeof(struct priv);
+		len = strlcpy(ctx->name, cipher_name + 4, sizeof(ctx->name));
+		if (len < 2 || len >= sizeof(ctx->name))
+			goto err_drop_spawn;
 
-	inst->alg.cra_init = init_tfm;
-	inst->alg.cra_exit = exit_tfm;
+		if (ctx->name[len - 1] != ')')
+			goto err_drop_spawn;
 
-	inst->alg.cra_blkcipher.setkey = setkey;
-	inst->alg.cra_blkcipher.encrypt = encrypt;
-	inst->alg.cra_blkcipher.decrypt = decrypt;
+		ctx->name[len - 1] = 0;
 
-out_put_alg:
-	crypto_mod_put(alg);
-	return inst;
-}
+		if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
+			     "xts(%s)", ctx->name) >= CRYPTO_MAX_ALG_NAME)
+			return -ENAMETOOLONG;
+	} else
+		goto err_drop_spawn;
 
-static void free(struct crypto_instance *inst)
-{
-	crypto_drop_spawn(crypto_instance_ctx(inst));
+	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_priority = alg->base.cra_priority;
+	inst->alg.base.cra_blocksize = XTS_BLOCK_SIZE;
+	inst->alg.base.cra_alignmask = alg->base.cra_alignmask |
+				       (__alignof__(u64) - 1);
+
+	inst->alg.ivsize = XTS_BLOCK_SIZE;
+	inst->alg.min_keysize = crypto_skcipher_alg_min_keysize(alg) * 2;
+	inst->alg.max_keysize = crypto_skcipher_alg_max_keysize(alg) * 2;
+
+	inst->alg.base.cra_ctxsize = sizeof(struct priv);
+
+	inst->alg.init = init_tfm;
+	inst->alg.exit = exit_tfm;
+
+	inst->alg.setkey = setkey;
+	inst->alg.encrypt = encrypt;
+	inst->alg.decrypt = decrypt;
+
+	inst->free = free;
+
+	err = skcipher_register_instance(tmpl, inst);
+	if (err)
+		goto err_drop_spawn;
+
+out:
+	return err;
+
+err_drop_spawn:
+	crypto_drop_skcipher(&ctx->spawn);
+err_free_inst:
 	kfree(inst);
+	goto out;
 }
 
 static struct crypto_template crypto_tmpl = {
 	.name = "xts",
-	.alloc = alloc,
-	.free = free,
+	.create = create,
 	.module = THIS_MODULE,
 };
 
diff --git a/include/crypto/xts.h b/include/crypto/xts.h
index ede6b97..77b6306 100644
--- a/include/crypto/xts.h
+++ b/include/crypto/xts.h
@@ -2,8 +2,7 @@
 #define _CRYPTO_XTS_H
 
 #include <crypto/b128ops.h>
-#include <linux/crypto.h>
-#include <crypto/algapi.h>
+#include <crypto/internal/skcipher.h>
 #include <linux/fips.h>
 
 struct scatterlist;
@@ -51,4 +50,27 @@ static inline int xts_check_key(struct crypto_tfm *tfm,
 	return 0;
 }
 
+static inline int xts_verify_key(struct crypto_skcipher *tfm,
+				 const u8 *key, unsigned int keylen)
+{
+	/*
+	 * key consists of keys of equal size concatenated, therefore
+	 * the length must be even.
+	 */
+	if (keylen % 2) {
+		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	/* ensure that the AES and tweak key are not identical */
+	if ((fips_enabled || crypto_skcipher_get_flags(tfm) &
+			     CRYPTO_TFM_REQ_WEAK_KEY) &&
+	    !crypto_memneq(key, key + (keylen / 2), keylen / 2)) {
+		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_WEAK_KEY);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 #endif  /* _CRYPTO_XTS_H */
