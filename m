From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 6/16] crypto: cryptd - Add support for skcipher
Date: Sun, 13 Nov 2016 19:45:37 +0800
Message-ID: <E1c5tE9-00029x-Rk@gondolin.me.apana.org.au>
References: <20161113114354.GA8169@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53513 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933668AbcKMLpv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Nov 2016 06:45:51 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6])
        by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
        id 1c5tE9-0007Au-Vv
        for <linux-crypto@vger.kernel.org>; Sun, 13 Nov 2016 22:45:38 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds skcipher support to cryptd alongside ablkcipher.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/cryptd.c         |  284 +++++++++++++++++++++++++++++++++++++++++++++++-
 include/crypto/cryptd.h |   13 ++
 2 files changed, 294 insertions(+), 3 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 3fd2a20..0508c48 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -17,9 +17,9 @@
  *
  */
 
-#include <crypto/algapi.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/aead.h>
+#include <crypto/internal/skcipher.h>
 #include <crypto/cryptd.h>
 #include <crypto/crypto_wq.h>
 #include <linux/atomic.h>
@@ -48,6 +48,11 @@ struct cryptd_instance_ctx {
 	struct cryptd_queue *queue;
 };
 
+struct skcipherd_instance_ctx {
+	struct crypto_skcipher_spawn spawn;
+	struct cryptd_queue *queue;
+};
+
 struct hashd_instance_ctx {
 	struct crypto_shash_spawn spawn;
 	struct cryptd_queue *queue;
@@ -67,6 +72,15 @@ struct cryptd_blkcipher_request_ctx {
 	crypto_completion_t complete;
 };
 
+struct cryptd_skcipher_ctx {
+	atomic_t refcnt;
+	struct crypto_skcipher *child;
+};
+
+struct cryptd_skcipher_request_ctx {
+	crypto_completion_t complete;
+};
+
 struct cryptd_hash_ctx {
 	atomic_t refcnt;
 	struct crypto_shash *child;
@@ -430,6 +444,216 @@ static int cryptd_create_blkcipher(struct crypto_template *tmpl,
 	return err;
 }
 
+static int cryptd_skcipher_setkey(struct crypto_skcipher *parent,
+				  const u8 *key, unsigned int keylen)
+{
+	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(parent);
+	struct crypto_skcipher *child = ctx->child;
+	int err;
+
+	crypto_skcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(child, crypto_skcipher_get_flags(parent) &
+					 CRYPTO_TFM_REQ_MASK);
+	err = crypto_skcipher_setkey(child, key, keylen);
+	crypto_skcipher_set_flags(parent, crypto_skcipher_get_flags(child) &
+					  CRYPTO_TFM_RES_MASK);
+	return err;
+}
+
+static void cryptd_skcipher_complete(struct skcipher_request *req, int err)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct cryptd_skcipher_request_ctx *rctx = skcipher_request_ctx(req);
+	int refcnt = atomic_read(&ctx->refcnt);
+
+	local_bh_disable();
+	rctx->complete(&req->base, err);
+	local_bh_enable();
+
+	if (err != -EINPROGRESS && refcnt && atomic_dec_and_test(&ctx->refcnt))
+		crypto_free_skcipher(tfm);
+}
+
+static void cryptd_skcipher_encrypt(struct crypto_async_request *base,
+				    int err)
+{
+	struct skcipher_request *req = skcipher_request_cast(base);
+	struct cryptd_skcipher_request_ctx *rctx = skcipher_request_ctx(req);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct crypto_skcipher *child = ctx->child;
+	SKCIPHER_REQUEST_ON_STACK(subreq, child);
+
+	if (unlikely(err == -EINPROGRESS))
+		goto out;
+
+	skcipher_request_set_tfm(subreq, child);
+	skcipher_request_set_callback(subreq, CRYPTO_TFM_REQ_MAY_SLEEP,
+				      NULL, NULL);
+	skcipher_request_set_crypt(subreq, req->src, req->dst, req->cryptlen,
+				   req->iv);
+
+	err = crypto_skcipher_encrypt(subreq);
+	skcipher_request_zero(subreq);
+
+	req->base.complete = rctx->complete;
+
+out:
+	cryptd_skcipher_complete(req, err);
+}
+
+static void cryptd_skcipher_decrypt(struct crypto_async_request *base,
+				    int err)
+{
+	struct skcipher_request *req = skcipher_request_cast(base);
+	struct cryptd_skcipher_request_ctx *rctx = skcipher_request_ctx(req);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct crypto_skcipher *child = ctx->child;
+	SKCIPHER_REQUEST_ON_STACK(subreq, child);
+
+	if (unlikely(err == -EINPROGRESS))
+		goto out;
+
+	skcipher_request_set_tfm(subreq, child);
+	skcipher_request_set_callback(subreq, CRYPTO_TFM_REQ_MAY_SLEEP,
+				      NULL, NULL);
+	skcipher_request_set_crypt(subreq, req->src, req->dst, req->cryptlen,
+				   req->iv);
+
+	err = crypto_skcipher_decrypt(subreq);
+	skcipher_request_zero(subreq);
+
+	req->base.complete = rctx->complete;
+
+out:
+	cryptd_skcipher_complete(req, err);
+}
+
+static int cryptd_skcipher_enqueue(struct skcipher_request *req,
+				   crypto_completion_t compl)
+{
+	struct cryptd_skcipher_request_ctx *rctx = skcipher_request_ctx(req);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct cryptd_queue *queue;
+
+	queue = cryptd_get_queue(crypto_skcipher_tfm(tfm));
+	rctx->complete = req->base.complete;
+	req->base.complete = compl;
+
+	return cryptd_enqueue_request(queue, &req->base);
+}
+
+static int cryptd_skcipher_encrypt_enqueue(struct skcipher_request *req)
+{
+	return cryptd_skcipher_enqueue(req, cryptd_skcipher_encrypt);
+}
+
+static int cryptd_skcipher_decrypt_enqueue(struct skcipher_request *req)
+{
+	return cryptd_skcipher_enqueue(req, cryptd_skcipher_decrypt);
+}
+
+static int cryptd_skcipher_init_tfm(struct crypto_skcipher *tfm)
+{
+	struct skcipher_instance *inst = skcipher_alg_instance(tfm);
+	struct skcipherd_instance_ctx *ictx = skcipher_instance_ctx(inst);
+	struct crypto_skcipher_spawn *spawn = &ictx->spawn;
+	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct crypto_skcipher *cipher;
+
+	cipher = crypto_spawn_skcipher(spawn);
+	if (IS_ERR(cipher))
+		return PTR_ERR(cipher);
+
+	ctx->child = cipher;
+	crypto_skcipher_set_reqsize(
+		tfm, sizeof(struct cryptd_skcipher_request_ctx));
+	return 0;
+}
+
+static void cryptd_skcipher_exit_tfm(struct crypto_skcipher *tfm)
+{
+	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	crypto_free_skcipher(ctx->child);
+}
+
+static void cryptd_skcipher_free(struct skcipher_instance *inst)
+{
+	struct skcipherd_instance_ctx *ctx = skcipher_instance_ctx(inst);
+
+	crypto_drop_skcipher(&ctx->spawn);
+}
+
+static int cryptd_create_skcipher(struct crypto_template *tmpl,
+				  struct rtattr **tb,
+				  struct cryptd_queue *queue)
+{
+	struct skcipherd_instance_ctx *ctx;
+	struct skcipher_instance *inst;
+	struct skcipher_alg *alg;
+	const char *name;
+	u32 type;
+	u32 mask;
+	int err;
+
+	type = 0;
+	mask = CRYPTO_ALG_ASYNC;
+
+	cryptd_check_internal(tb, &type, &mask);
+
+	name = crypto_attr_alg_name(tb[1]);
+	if (IS_ERR(name))
+		return PTR_ERR(name);
+
+	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
+	if (!inst)
+		return -ENOMEM;
+
+	ctx = skcipher_instance_ctx(inst);
+	ctx->queue = queue;
+
+	crypto_set_skcipher_spawn(&ctx->spawn, skcipher_crypto_instance(inst));
+	err = crypto_grab_skcipher(&ctx->spawn, name, type, mask);
+	if (err)
+		goto out_free_inst;
+
+	alg = crypto_spawn_skcipher_alg(&ctx->spawn);
+	err = cryptd_init_instance(skcipher_crypto_instance(inst), &alg->base);
+	if (err)
+		goto out_drop_skcipher;
+
+	inst->alg.base.cra_flags = CRYPTO_ALG_ASYNC |
+				   (alg->base.cra_flags & CRYPTO_ALG_INTERNAL);
+
+	inst->alg.ivsize = crypto_skcipher_alg_ivsize(alg);
+	inst->alg.chunksize = crypto_skcipher_alg_chunksize(alg);
+	inst->alg.min_keysize = crypto_skcipher_alg_min_keysize(alg);
+	inst->alg.max_keysize = crypto_skcipher_alg_max_keysize(alg);
+
+	inst->alg.base.cra_ctxsize = sizeof(struct cryptd_skcipher_ctx);
+
+	inst->alg.init = cryptd_skcipher_init_tfm;
+	inst->alg.exit = cryptd_skcipher_exit_tfm;
+
+	inst->alg.setkey = cryptd_skcipher_setkey;
+	inst->alg.encrypt = cryptd_skcipher_encrypt_enqueue;
+	inst->alg.decrypt = cryptd_skcipher_decrypt_enqueue;
+
+	inst->free = cryptd_skcipher_free;
+
+	err = skcipher_register_instance(tmpl, inst);
+	if (err) {
+out_drop_skcipher:
+		crypto_drop_skcipher(&ctx->spawn);
+out_free_inst:
+		kfree(inst);
+	}
+	return err;
+}
+
 static int cryptd_hash_init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_instance *inst = crypto_tfm_alg_instance(tfm);
@@ -893,7 +1117,11 @@ static int cryptd_create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	switch (algt->type & algt->mask & CRYPTO_ALG_TYPE_MASK) {
 	case CRYPTO_ALG_TYPE_BLKCIPHER:
-		return cryptd_create_blkcipher(tmpl, tb, &queue);
+		if ((algt->type & CRYPTO_ALG_TYPE_MASK) ==
+		    CRYPTO_ALG_TYPE_BLKCIPHER)
+			return cryptd_create_blkcipher(tmpl, tb, &queue);
+
+		return cryptd_create_skcipher(tmpl, tb, &queue);
 	case CRYPTO_ALG_TYPE_DIGEST:
 		return cryptd_create_hash(tmpl, tb, &queue);
 	case CRYPTO_ALG_TYPE_AEAD:
@@ -983,6 +1211,58 @@ void cryptd_free_ablkcipher(struct cryptd_ablkcipher *tfm)
 }
 EXPORT_SYMBOL_GPL(cryptd_free_ablkcipher);
 
+struct cryptd_skcipher *cryptd_alloc_skcipher(const char *alg_name,
+					      u32 type, u32 mask)
+{
+	char cryptd_alg_name[CRYPTO_MAX_ALG_NAME];
+	struct cryptd_skcipher_ctx *ctx;
+	struct crypto_skcipher *tfm;
+
+	if (snprintf(cryptd_alg_name, CRYPTO_MAX_ALG_NAME,
+		     "cryptd(%s)", alg_name) >= CRYPTO_MAX_ALG_NAME)
+		return ERR_PTR(-EINVAL);
+
+	tfm = crypto_alloc_skcipher(cryptd_alg_name, type, mask);
+	if (IS_ERR(tfm))
+		return ERR_CAST(tfm);
+
+	if (tfm->base.__crt_alg->cra_module != THIS_MODULE) {
+		crypto_free_skcipher(tfm);
+		return ERR_PTR(-EINVAL);
+	}
+
+	ctx = crypto_skcipher_ctx(tfm);
+	atomic_set(&ctx->refcnt, 1);
+
+	return container_of(tfm, struct cryptd_skcipher, base);
+}
+EXPORT_SYMBOL_GPL(cryptd_alloc_skcipher);
+
+struct crypto_skcipher *cryptd_skcipher_child(struct cryptd_skcipher *tfm)
+{
+	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(&tfm->base);
+
+	return ctx->child;
+}
+EXPORT_SYMBOL_GPL(cryptd_skcipher_child);
+
+bool cryptd_skcipher_queued(struct cryptd_skcipher *tfm)
+{
+	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(&tfm->base);
+
+	return atomic_read(&ctx->refcnt) - 1;
+}
+EXPORT_SYMBOL_GPL(cryptd_skcipher_queued);
+
+void cryptd_free_skcipher(struct cryptd_skcipher *tfm)
+{
+	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(&tfm->base);
+
+	if (atomic_dec_and_test(&ctx->refcnt))
+		crypto_free_skcipher(&tfm->base);
+}
+EXPORT_SYMBOL_GPL(cryptd_free_skcipher);
+
 struct cryptd_ahash *cryptd_alloc_ahash(const char *alg_name,
 					u32 type, u32 mask)
 {
diff --git a/include/crypto/cryptd.h b/include/crypto/cryptd.h
index bc792d5..94418cb 100644
--- a/include/crypto/cryptd.h
+++ b/include/crypto/cryptd.h
@@ -12,10 +12,10 @@
 #ifndef _CRYPTO_CRYPT_H
 #define _CRYPTO_CRYPT_H
 
-#include <linux/crypto.h>
 #include <linux/kernel.h>
 #include <crypto/aead.h>
 #include <crypto/hash.h>
+#include <crypto/skcipher.h>
 
 struct cryptd_ablkcipher {
 	struct crypto_ablkcipher base;
@@ -34,6 +34,17 @@ struct cryptd_ablkcipher *cryptd_alloc_ablkcipher(const char *alg_name,
 bool cryptd_ablkcipher_queued(struct cryptd_ablkcipher *tfm);
 void cryptd_free_ablkcipher(struct cryptd_ablkcipher *tfm);
 
+struct cryptd_skcipher {
+	struct crypto_skcipher base;
+};
+
+struct cryptd_skcipher *cryptd_alloc_skcipher(const char *alg_name,
+					      u32 type, u32 mask);
+struct crypto_skcipher *cryptd_skcipher_child(struct cryptd_skcipher *tfm);
+/* Must be called without moving CPUs. */
+bool cryptd_skcipher_queued(struct cryptd_skcipher *tfm);
+void cryptd_free_skcipher(struct cryptd_skcipher *tfm);
+
 struct cryptd_ahash {
 	struct crypto_ahash base;
 };
