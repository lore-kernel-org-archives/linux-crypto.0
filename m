From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/16] crypto: lrw - Convert to skcipher
Date: Wed, 02 Nov 2016 07:19:04 +0800
Message-ID: <E1c1iKe-0004BV-K2@gondolin.me.apana.org.au>
References: <20161101231648.GA15967@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57517 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751263AbcKAXTH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Nov 2016 19:19:07 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
        by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
        id 1c1iKe-00072y-P6
        for <linux-crypto@vger.kernel.org>; Wed, 02 Nov 2016 10:19:04 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts lrw over to the skcipher interface.  It also
optimises the implementation to be based on ECB instead of the
underlying cipher.  For compatibility the existing naming scheme
of lrw(aes) is maintained as opposed to the more obvious one of
lrw(ecb(aes)).

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/lrw.c |  506 ++++++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 379 insertions(+), 127 deletions(-)

diff --git a/crypto/lrw.c b/crypto/lrw.c
index 6f9908a..164e758 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -17,7 +17,8 @@
  *
  * The test vectors are included in the testing module tcrypt.[ch] */
 
-#include <crypto/algapi.h>
+#include <crypto/internal/skcipher.h>
+#include <crypto/scatterwalk.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -29,11 +30,30 @@
 #include <crypto/gf128mul.h>
 #include <crypto/lrw.h>
 
+#define LRW_BUFFER_SIZE 128u
+
 struct priv {
-	struct crypto_cipher *child;
+	struct crypto_skcipher *child;
 	struct lrw_table_ctx table;
 };
 
+struct rctx {
+	be128 buf[LRW_BUFFER_SIZE / sizeof(be128)];
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
 static inline void setbit128_bbe(void *b, int bit)
 {
 	__set_bit(bit ^ (0x80 -
@@ -76,32 +96,26 @@ void lrw_free_table(struct lrw_table_ctx *ctx)
 }
 EXPORT_SYMBOL_GPL(lrw_free_table);
 
-static int setkey(struct crypto_tfm *parent, const u8 *key,
+static int setkey(struct crypto_skcipher *parent, const u8 *key,
 		  unsigned int keylen)
 {
-	struct priv *ctx = crypto_tfm_ctx(parent);
-	struct crypto_cipher *child = ctx->child;
+	struct priv *ctx = crypto_skcipher_ctx(parent);
+	struct crypto_skcipher *child = ctx->child;
 	int err, bsize = LRW_BLOCK_SIZE;
 	const u8 *tweak = key + keylen - bsize;
 
-	crypto_cipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
-	crypto_cipher_set_flags(child, crypto_tfm_get_flags(parent) &
-				       CRYPTO_TFM_REQ_MASK);
-	err = crypto_cipher_setkey(child, key, keylen - bsize);
+	crypto_skcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(child, crypto_skcipher_get_flags(parent) &
+					 CRYPTO_TFM_REQ_MASK);
+	err = crypto_skcipher_setkey(child, key, keylen - bsize);
+	crypto_skcipher_set_flags(parent, crypto_skcipher_get_flags(child) &
+					  CRYPTO_TFM_RES_MASK);
 	if (err)
 		return err;
-	crypto_tfm_set_flags(parent, crypto_cipher_get_flags(child) &
-				     CRYPTO_TFM_RES_MASK);
 
 	return lrw_init_table(&ctx->table, tweak);
 }
 
-struct sinfo {
-	be128 t;
-	struct crypto_tfm *tfm;
-	void (*fn)(struct crypto_tfm *, u8 *, const u8 *);
-};
-
 static inline void inc(be128 *iv)
 {
 	be64_add_cpu(&iv->b, 1);
@@ -109,13 +123,6 @@ static inline void inc(be128 *iv)
 		be64_add_cpu(&iv->a, 1);
 }
 
-static inline void lrw_round(struct sinfo *s, void *dst, const void *src)
-{
-	be128_xor(dst, &s->t, src);		/* PP <- T xor P */
-	s->fn(s->tfm, dst, dst);		/* CC <- E(Key2,PP) */
-	be128_xor(dst, dst, &s->t);		/* C <- T xor CC */
-}
-
 /* this returns the number of consequative 1 bits starting
  * from the right, get_index128(00 00 00 00 00 00 ... 00 00 10 FB) = 2 */
 static inline int get_index128(be128 *block)
@@ -135,83 +142,263 @@ static inline int get_index128(be128 *block)
 	return x;
 }
 
-static int crypt(struct blkcipher_desc *d,
-		 struct blkcipher_walk *w, struct priv *ctx,
-		 void (*fn)(struct crypto_tfm *, u8 *, const u8 *))
+static int post_crypt(struct skcipher_request *req)
 {
+	struct rctx *rctx = skcipher_request_ctx(req);
+	be128 *buf = rctx->ext ?: rctx->buf;
+	struct skcipher_request *subreq;
+	const int bs = LRW_BLOCK_SIZE;
+	struct skcipher_walk w;
+	struct scatterlist *sg;
+	unsigned offset;
 	int err;
-	unsigned int avail;
+
+	subreq = &rctx->subreq;
+	err = skcipher_walk_virt(&w, subreq, false);
+
+	while (w.nbytes) {
+		unsigned int avail = w.nbytes;
+		be128 *wdst;
+
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
+}
+
+static int pre_crypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct rctx *rctx = skcipher_request_ctx(req);
+	struct priv *ctx = crypto_skcipher_ctx(tfm);
+	be128 *buf = rctx->ext ?: rctx->buf;
+	struct skcipher_request *subreq;
 	const int bs = LRW_BLOCK_SIZE;
-	struct sinfo s = {
-		.tfm = crypto_cipher_tfm(ctx->child),
-		.fn = fn
-	};
+	struct skcipher_walk w;
+	struct scatterlist *sg;
+	unsigned cryptlen;
+	unsigned offset;
 	be128 *iv;
-	u8 *wsrc;
-	u8 *wdst;
+	bool more;
+	int err;
 
-	err = blkcipher_walk_virt(d, w);
-	if (!(avail = w->nbytes))
-		return err;
+	subreq = &rctx->subreq;
+	skcipher_request_set_tfm(subreq, tfm);
 
-	wsrc = w->src.virt.addr;
-	wdst = w->dst.virt.addr;
+	cryptlen = subreq->cryptlen;
+	more = rctx->left > cryptlen;
+	if (!more)
+		cryptlen = rctx->left;
 
-	/* calculate first value of T */
-	iv = (be128 *)w->iv;
-	s.t = *iv;
+	skcipher_request_set_crypt(subreq, rctx->src, rctx->dst,
+				   cryptlen, req->iv);
 
-	/* T <- I*Key2 */
-	gf128mul_64k_bbe(&s.t, ctx->table.table);
+	err = skcipher_walk_virt(&w, subreq, false);
+	iv = w.iv;
 
-	goto first;
+	while (w.nbytes) {
+		unsigned int avail = w.nbytes;
+		be128 *wsrc;
+		be128 *wdst;
+
+		wsrc = w.src.virt.addr;
+		wdst = w.dst.virt.addr;
 
-	for (;;) {
 		do {
+			*buf++ = rctx->t;
+			be128_xor(wdst++, &rctx->t, wsrc++);
+
 			/* T <- I*Key2, using the optimization
 			 * discussed in the specification */
-			be128_xor(&s.t, &s.t,
+			be128_xor(&rctx->t, &rctx->t,
 				  &ctx->table.mulinc[get_index128(iv)]);
 			inc(iv);
+		} while ((avail -= bs) >= bs);
 
-first:
-			lrw_round(&s, wdst, wsrc);
+		err = skcipher_walk_done(&w, avail);
+	}
 
-			wsrc += bs;
-			wdst += bs;
-		} while ((avail -= bs) >= bs);
+	skcipher_request_set_tfm(subreq, ctx->child);
+	skcipher_request_set_crypt(subreq, rctx->dst, rctx->dst,
+				   cryptlen, NULL);
 
-		err = blkcipher_walk_done(d, w, avail);
-		if (!(avail = w->nbytes))
-			break;
+	if (err || !more)
+		goto out;
+
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
+	}
+	rctx->src[0].length -= offset - sg->offset;
+	rctx->src[0].offset = offset;
+
+out:
+	return err;
+}
+
+static int init_crypt(struct skcipher_request *req, crypto_completion_t done)
+{
+	struct priv *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
+	struct rctx *rctx = skcipher_request_ctx(req);
+	struct skcipher_request *subreq;
+	gfp_t gfp;
+
+	subreq = &rctx->subreq;
+	skcipher_request_set_callback(subreq, req->base.flags, done, req);
+
+	gfp = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
+							   GFP_ATOMIC;
+	rctx->ext = NULL;
+
+	subreq->cryptlen = LRW_BUFFER_SIZE;
+	if (req->cryptlen > LRW_BUFFER_SIZE) {
+		subreq->cryptlen = min(req->cryptlen, (unsigned)PAGE_SIZE);
+		rctx->ext = kmalloc(subreq->cryptlen, gfp);
+	}
+
+	rctx->src = req->src;
+	rctx->dst = req->dst;
+	rctx->left = req->cryptlen;
+
+	/* calculate first value of T */
+	memcpy(&rctx->t, req->iv, sizeof(rctx->t));
+
+	/* T <- I*Key2 */
+	gf128mul_64k_bbe(&rctx->t, ctx->table.table);
 
-		wsrc = w->src.virt.addr;
-		wdst = w->dst.virt.addr;
+	return 0;
+}
+
+static void exit_crypt(struct skcipher_request *req)
+{
+	struct rctx *rctx = skcipher_request_ctx(req);
+
+	rctx->left = 0;
+
+	if (rctx->ext)
+		kfree(rctx->ext);
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
 	}
 
+	exit_crypt(req);
 	return err;
 }
 
-static int encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
-		   struct scatterlist *src, unsigned int nbytes)
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
 {
-	struct priv *ctx = crypto_blkcipher_ctx(desc->tfm);
-	struct blkcipher_walk w;
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
 
-	blkcipher_walk_init(&w, dst, src, nbytes);
-	return crypt(desc, &w, ctx,
-		     crypto_cipher_alg(ctx->child)->cia_encrypt);
+	exit_crypt(req);
+	return err;
 }
 
-static int decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
-		   struct scatterlist *src, unsigned int nbytes)
+static void decrypt_done(struct crypto_async_request *areq, int err)
 {
-	struct priv *ctx = crypto_blkcipher_ctx(desc->tfm);
-	struct blkcipher_walk w;
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
 
-	blkcipher_walk_init(&w, dst, src, nbytes);
-	return crypt(desc, &w, ctx,
-		     crypto_cipher_alg(ctx->child)->cia_decrypt);
+	skcipher_request_complete(req, err);
+}
+
+static int decrypt(struct skcipher_request *req)
+{
+	return do_decrypt(req, init_crypt(req, decrypt_done));
 }
 
 int lrw_crypt(struct blkcipher_desc *desc, struct scatterlist *sdst,
@@ -293,95 +480,160 @@ int lrw_crypt(struct blkcipher_desc *desc, struct scatterlist *sdst,
 }
 EXPORT_SYMBOL_GPL(lrw_crypt);
 
-static int init_tfm(struct crypto_tfm *tfm)
+static int init_tfm(struct crypto_skcipher *tfm)
 {
-	struct crypto_cipher *cipher;
-	struct crypto_instance *inst = (void *)tfm->__crt_alg;
-	struct crypto_spawn *spawn = crypto_instance_ctx(inst);
-	struct priv *ctx = crypto_tfm_ctx(tfm);
-	u32 *flags = &tfm->crt_flags;
+	struct skcipher_instance *inst = skcipher_alg_instance(tfm);
+	struct crypto_skcipher_spawn *spawn = skcipher_instance_ctx(inst);
+	struct priv *ctx = crypto_skcipher_ctx(tfm);
+	struct crypto_skcipher *cipher;
 
-	cipher = crypto_spawn_cipher(spawn);
+	cipher = crypto_spawn_skcipher(spawn);
 	if (IS_ERR(cipher))
 		return PTR_ERR(cipher);
 
-	if (crypto_cipher_blocksize(cipher) != LRW_BLOCK_SIZE) {
-		*flags |= CRYPTO_TFM_RES_BAD_BLOCK_LEN;
-		crypto_free_cipher(cipher);
-		return -EINVAL;
-	}
-
 	ctx->child = cipher;
+
+	crypto_skcipher_set_reqsize(tfm, crypto_skcipher_reqsize(cipher) +
+					 sizeof(struct rctx));
+
 	return 0;
 }
 
-static void exit_tfm(struct crypto_tfm *tfm)
+static void exit_tfm(struct crypto_skcipher *tfm)
 {
-	struct priv *ctx = crypto_tfm_ctx(tfm);
+	struct priv *ctx = crypto_skcipher_ctx(tfm);
 
 	lrw_free_table(&ctx->table);
-	crypto_free_cipher(ctx->child);
+	crypto_free_skcipher(ctx->child);
+}
+
+static void free(struct skcipher_instance *inst)
+{
+	crypto_drop_skcipher(skcipher_instance_ctx(inst));
+	kfree(inst);
 }
 
-static struct crypto_instance *alloc(struct rtattr **tb)
+static int create(struct crypto_template *tmpl, struct rtattr **tb)
 {
-	struct crypto_instance *inst;
-	struct crypto_alg *alg;
+	struct crypto_skcipher_spawn *spawn;
+	struct skcipher_instance *inst;
+	struct crypto_attr_type *algt;
+	struct skcipher_alg *alg;
+	const char *cipher_name;
+	char ecb_name[CRYPTO_MAX_ALG_NAME];
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
+	err = crypto_grab_skcipher(spawn, cipher_name, 0,
+				   crypto_requires_sync(algt->type,
+							algt->mask));
+	if (err == -ENOENT) {
+		err = -ENAMETOOLONG;
+		if (snprintf(ecb_name, CRYPTO_MAX_ALG_NAME, "ecb(%s)",
+			     cipher_name) >= CRYPTO_MAX_ALG_NAME)
+			goto err_free_inst;
+
+		err = crypto_grab_skcipher(spawn, ecb_name, 0,
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
+	alg = crypto_skcipher_spawn_alg(spawn);
 
-	inst = crypto_alloc_instance("lrw", alg);
-	if (IS_ERR(inst))
-		goto out_put_alg;
+	err = -EINVAL;
+	if (alg->base.cra_blocksize != LRW_BLOCK_SIZE)
+		goto err_drop_spawn;
 
-	inst->alg.cra_flags = CRYPTO_ALG_TYPE_BLKCIPHER;
-	inst->alg.cra_priority = alg->cra_priority;
-	inst->alg.cra_blocksize = alg->cra_blocksize;
+	if (crypto_skcipher_alg_ivsize(alg))
+		goto err_drop_spawn;
 
-	if (alg->cra_alignmask < 7) inst->alg.cra_alignmask = 7;
-	else inst->alg.cra_alignmask = alg->cra_alignmask;
-	inst->alg.cra_type = &crypto_blkcipher_type;
+	err = crypto_inst_setname(skcipher_crypto_instance(inst), "lrw",
+				  &alg->base);
+	if (err)
+		goto err_drop_spawn;
 
-	if (!(alg->cra_blocksize % 4))
-		inst->alg.cra_alignmask |= 3;
-	inst->alg.cra_blkcipher.ivsize = alg->cra_blocksize;
-	inst->alg.cra_blkcipher.min_keysize =
-		alg->cra_cipher.cia_min_keysize + alg->cra_blocksize;
-	inst->alg.cra_blkcipher.max_keysize =
-		alg->cra_cipher.cia_max_keysize + alg->cra_blocksize;
+	cipher_name = alg->base.cra_name;
 
-	inst->alg.cra_ctxsize = sizeof(struct priv);
+	/* Alas we screwed up the naming so we have to mangle the
+	 * cipher name.
+	 */
+	if (!strncmp(cipher_name, "ecb(", 4)) {
+		unsigned len;
 
-	inst->alg.cra_init = init_tfm;
-	inst->alg.cra_exit = exit_tfm;
+		len = strlcpy(ecb_name, cipher_name + 4, sizeof(ecb_name));
+		if (len < 2 || len >= sizeof(ecb_name))
+			goto err_drop_spawn;
 
-	inst->alg.cra_blkcipher.setkey = setkey;
-	inst->alg.cra_blkcipher.encrypt = encrypt;
-	inst->alg.cra_blkcipher.decrypt = decrypt;
+		if (ecb_name[len - 1] != ')')
+			goto err_drop_spawn;
 
-out_put_alg:
-	crypto_mod_put(alg);
-	return inst;
-}
+		ecb_name[len - 1] = 0;
 
-static void free(struct crypto_instance *inst)
-{
-	crypto_drop_spawn(crypto_instance_ctx(inst));
+		if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
+			     "lrw(%s)", ecb_name) >= CRYPTO_MAX_ALG_NAME)
+			return -ENAMETOOLONG;
+	}
+
+	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_priority = alg->base.cra_priority;
+	inst->alg.base.cra_blocksize = LRW_BLOCK_SIZE;
+	inst->alg.base.cra_alignmask = alg->base.cra_alignmask |
+				       (__alignof__(u64) - 1);
+
+	inst->alg.ivsize = LRW_BLOCK_SIZE;
+	inst->alg.min_keysize = crypto_skcipher_alg_min_keysize(alg) +
+				LRW_BLOCK_SIZE;
+	inst->alg.max_keysize = crypto_skcipher_alg_max_keysize(alg) +
+				LRW_BLOCK_SIZE;
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
+	crypto_drop_skcipher(spawn);
+err_free_inst:
 	kfree(inst);
+	goto out;
 }
 
 static struct crypto_template crypto_tmpl = {
 	.name = "lrw",
-	.alloc = alloc,
-	.free = free,
+	.create = create,
 	.module = THIS_MODULE,
 };
 
