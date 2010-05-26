From: David Miller <davem@davemloft.net>
Subject: [PATCH 7/7] n2_crypto: Add HMAC support.
Date: Tue, 25 May 2010 17:43:49 -0700 (PDT)
Message-ID: <20100525.174349.179931419.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37738
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758463Ab0EZAnj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 May 2010 20:43:39 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


One note is that, unlike with non-HMAC hashes, we can't support
hmac(sha224) using the HMAC_SHA256 opcode.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/crypto/n2_core.c |  210 +++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 206 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index d01a2af..b99c38f 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -246,6 +246,7 @@ struct n2_ahash_alg {
 	u8			hw_op_hashsz;
 	u8			digest_size;
 	u8			auth_type;
+	u8			hmac_type;
 	struct ahash_alg	alg;
 };
 
@@ -259,10 +260,36 @@ static inline struct n2_ahash_alg *n2_ahash_alg(struct crypto_tfm *tfm)
 	return container_of(ahash_alg, struct n2_ahash_alg, alg);
 }
 
+struct n2_hmac_alg {
+	const char		*child_alg;
+	struct n2_ahash_alg	derived;
+};
+
+static inline struct n2_hmac_alg *n2_hmac_alg(struct crypto_tfm *tfm)
+{
+	struct crypto_alg *alg = tfm->__crt_alg;
+	struct ahash_alg *ahash_alg;
+
+	ahash_alg = container_of(alg, struct ahash_alg, halg.base);
+
+	return container_of(ahash_alg, struct n2_hmac_alg, derived.alg);
+}
+
 struct n2_hash_ctx {
 	struct crypto_ahash		*fallback_tfm;
 };
 
+#define N2_HASH_KEY_MAX			32 /* HW limit for all HMAC requests */
+
+struct n2_hmac_ctx {
+	struct n2_hash_ctx		base;
+
+	struct crypto_shash		*child_shash;
+
+	int				hash_key_len;
+	unsigned char			hash_key[N2_HASH_KEY_MAX];
+};
+
 struct n2_hash_req_ctx {
 	union {
 		struct md5_state	md5;
@@ -362,6 +389,94 @@ static void n2_hash_cra_exit(struct crypto_tfm *tfm)
 	crypto_free_ahash(ctx->fallback_tfm);
 }
 
+static int n2_hmac_cra_init(struct crypto_tfm *tfm)
+{
+	const char *fallback_driver_name = tfm->__crt_alg->cra_name;
+	struct crypto_ahash *ahash = __crypto_ahash_cast(tfm);
+	struct n2_hmac_ctx *ctx = crypto_ahash_ctx(ahash);
+	struct n2_hmac_alg *n2alg = n2_hmac_alg(tfm);
+	struct crypto_ahash *fallback_tfm;
+	struct crypto_shash *child_shash;
+	int err;
+
+	fallback_tfm = crypto_alloc_ahash(fallback_driver_name, 0,
+					  CRYPTO_ALG_NEED_FALLBACK);
+	if (IS_ERR(fallback_tfm)) {
+		pr_warning("Fallback driver '%s' could not be loaded!\n",
+			   fallback_driver_name);
+		err = PTR_ERR(fallback_tfm);
+		goto out;
+	}
+
+	child_shash = crypto_alloc_shash(n2alg->child_alg, 0, 0);
+	if (IS_ERR(child_shash)) {
+		pr_warning("Child shash '%s' could not be loaded!\n",
+			   n2alg->child_alg);
+		err = PTR_ERR(child_shash);
+		goto out_free_fallback;
+	}
+
+	crypto_ahash_set_reqsize(ahash, (sizeof(struct n2_hash_req_ctx) +
+					 crypto_ahash_reqsize(fallback_tfm)));
+
+	ctx->child_shash = child_shash;
+	ctx->base.fallback_tfm = fallback_tfm;
+	return 0;
+
+out_free_fallback:
+	crypto_free_ahash(fallback_tfm);
+
+out:
+	return err;
+}
+
+static void n2_hmac_cra_exit(struct crypto_tfm *tfm)
+{
+	struct crypto_ahash *ahash = __crypto_ahash_cast(tfm);
+	struct n2_hmac_ctx *ctx = crypto_ahash_ctx(ahash);
+
+	crypto_free_ahash(ctx->base.fallback_tfm);
+	crypto_free_shash(ctx->child_shash);
+}
+
+static int n2_hmac_async_setkey(struct crypto_ahash *tfm, const u8 *key,
+				unsigned int keylen)
+{
+	struct n2_hmac_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct crypto_shash *child_shash = ctx->child_shash;
+	struct crypto_ahash *fallback_tfm;
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(child_shash)];
+	} desc;
+	int err, bs, ds;
+
+	fallback_tfm = ctx->base.fallback_tfm;
+	err = crypto_ahash_setkey(fallback_tfm, key, keylen);
+	if (err)
+		return err;
+
+	desc.shash.tfm = child_shash;
+	desc.shash.flags = crypto_ahash_get_flags(tfm) &
+		CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	bs = crypto_shash_blocksize(child_shash);
+	ds = crypto_shash_digestsize(child_shash);
+	BUG_ON(ds > N2_HASH_KEY_MAX);
+	if (keylen > bs) {
+		err = crypto_shash_digest(&desc.shash, key, keylen,
+					  ctx->hash_key);
+		if (err)
+			return err;
+		keylen = ds;
+	} else if (keylen <= N2_HASH_KEY_MAX)
+		memcpy(ctx->hash_key, key, keylen);
+
+	ctx->hash_key_len = keylen;
+
+	return err;
+}
+
 static unsigned long wait_for_tail(struct spu_queue *qp)
 {
 	unsigned long head, hv_ret;
@@ -393,7 +508,8 @@ static unsigned long submit_and_wait_for_tail(struct spu_queue *qp,
 
 static int n2_do_async_digest(struct ahash_request *req,
 			      unsigned int auth_type, unsigned int digest_size,
-			      unsigned int result_size, void *hash_loc)
+			      unsigned int result_size, void *hash_loc,
+			      unsigned long auth_key, unsigned int auth_key_len)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct cwq_initial_entry *ent;
@@ -434,13 +550,13 @@ static int n2_do_async_digest(struct ahash_request *req,
 	 */
 	ent = qp->q + qp->tail;
 
-	ent->control = control_word_base(nbytes, 0, 0,
+	ent->control = control_word_base(nbytes, auth_key_len, 0,
 					 auth_type, digest_size,
 					 false, true, false, false,
 					 OPCODE_INPLACE_BIT |
 					 OPCODE_AUTH_MAC);
 	ent->src_addr = __pa(walk.data);
-	ent->auth_key_addr = 0UL;
+	ent->auth_key_addr = auth_key;
 	ent->auth_iv_addr = __pa(hash_loc);
 	ent->final_auth_state_addr = 0UL;
 	ent->enc_key_addr = 0UL;
@@ -494,7 +610,40 @@ static int n2_hash_async_digest(struct ahash_request *req)
 
 	return n2_do_async_digest(req, n2alg->auth_type,
 				  n2alg->hw_op_hashsz, ds,
-				  &rctx->u);
+				  &rctx->u, 0UL, 0);
+}
+
+static int n2_hmac_async_digest(struct ahash_request *req)
+{
+	struct n2_hmac_alg *n2alg = n2_hmac_alg(req->base.tfm);
+	struct n2_hash_req_ctx *rctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct n2_hmac_ctx *ctx = crypto_ahash_ctx(tfm);
+	int ds;
+
+	ds = n2alg->derived.digest_size;
+	if (unlikely(req->nbytes == 0) ||
+	    unlikely(ctx->hash_key_len > N2_HASH_KEY_MAX)) {
+		struct n2_hash_req_ctx *rctx = ahash_request_ctx(req);
+		struct n2_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+
+		ahash_request_set_tfm(&rctx->fallback_req, ctx->fallback_tfm);
+		rctx->fallback_req.base.flags =
+			req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP;
+		rctx->fallback_req.nbytes = req->nbytes;
+		rctx->fallback_req.src = req->src;
+		rctx->fallback_req.result = req->result;
+
+		return crypto_ahash_digest(&rctx->fallback_req);
+	}
+	memcpy(&rctx->u, n2alg->derived.hash_init,
+	       n2alg->derived.hw_op_hashsz);
+
+	return n2_do_async_digest(req, n2alg->derived.hmac_type,
+				  n2alg->derived.hw_op_hashsz, ds,
+				  &rctx->u,
+				  __pa(&ctx->hash_key),
+				  ctx->hash_key_len);
 }
 
 struct n2_cipher_context {
@@ -1127,6 +1276,7 @@ struct n2_hash_tmpl {
 	u8		digest_size;
 	u8		block_size;
 	u8		auth_type;
+	u8		hmac_type;
 };
 
 static const char md5_zero[MD5_DIGEST_SIZE] = {
@@ -1173,6 +1323,7 @@ static const struct n2_hash_tmpl hash_tmpls[] = {
 	  .hash_zero	= md5_zero,
 	  .hash_init	= md5_init,
 	  .auth_type	= AUTH_TYPE_MD5,
+	  .hmac_type	= AUTH_TYPE_HMAC_MD5,
 	  .hw_op_hashsz	= MD5_DIGEST_SIZE,
 	  .digest_size	= MD5_DIGEST_SIZE,
 	  .block_size	= MD5_HMAC_BLOCK_SIZE },
@@ -1180,6 +1331,7 @@ static const struct n2_hash_tmpl hash_tmpls[] = {
 	  .hash_zero	= sha1_zero,
 	  .hash_init	= sha1_init,
 	  .auth_type	= AUTH_TYPE_SHA1,
+	  .hmac_type	= AUTH_TYPE_HMAC_SHA1,
 	  .hw_op_hashsz	= SHA1_DIGEST_SIZE,
 	  .digest_size	= SHA1_DIGEST_SIZE,
 	  .block_size	= SHA1_BLOCK_SIZE },
@@ -1187,6 +1339,7 @@ static const struct n2_hash_tmpl hash_tmpls[] = {
 	  .hash_zero	= sha256_zero,
 	  .hash_init	= sha256_init,
 	  .auth_type	= AUTH_TYPE_SHA256,
+	  .hmac_type	= AUTH_TYPE_HMAC_SHA256,
 	  .hw_op_hashsz	= SHA256_DIGEST_SIZE,
 	  .digest_size	= SHA256_DIGEST_SIZE,
 	  .block_size	= SHA256_BLOCK_SIZE },
@@ -1194,6 +1347,7 @@ static const struct n2_hash_tmpl hash_tmpls[] = {
 	  .hash_zero	= sha224_zero,
 	  .hash_init	= sha224_init,
 	  .auth_type	= AUTH_TYPE_SHA256,
+	  .hmac_type	= AUTH_TYPE_RESERVED,
 	  .hw_op_hashsz	= SHA256_DIGEST_SIZE,
 	  .digest_size	= SHA224_DIGEST_SIZE,
 	  .block_size	= SHA224_BLOCK_SIZE },
@@ -1201,6 +1355,7 @@ static const struct n2_hash_tmpl hash_tmpls[] = {
 #define NUM_HASH_TMPLS ARRAY_SIZE(hash_tmpls)
 
 static LIST_HEAD(ahash_algs);
+static LIST_HEAD(hmac_algs);
 
 static int algs_registered;
 
@@ -1208,12 +1363,18 @@ static void __n2_unregister_algs(void)
 {
 	struct n2_cipher_alg *cipher, *cipher_tmp;
 	struct n2_ahash_alg *alg, *alg_tmp;
+	struct n2_hmac_alg *hmac, *hmac_tmp;
 
 	list_for_each_entry_safe(cipher, cipher_tmp, &cipher_algs, entry) {
 		crypto_unregister_alg(&cipher->alg);
 		list_del(&cipher->entry);
 		kfree(cipher);
 	}
+	list_for_each_entry_safe(hmac, hmac_tmp, &hmac_algs, derived.entry) {
+		crypto_unregister_ahash(&hmac->derived.alg);
+		list_del(&hmac->derived.entry);
+		kfree(hmac);
+	}
 	list_for_each_entry_safe(alg, alg_tmp, &ahash_algs, entry) {
 		crypto_unregister_ahash(&alg->alg);
 		list_del(&alg->entry);
@@ -1262,6 +1423,44 @@ static int __devinit __n2_register_one_cipher(const struct n2_cipher_tmpl *tmpl)
 	return err;
 }
 
+static int __devinit __n2_register_one_hmac(struct n2_ahash_alg *n2ahash)
+{
+	struct n2_hmac_alg *p = kzalloc(sizeof(*p), GFP_KERNEL);
+	struct ahash_alg *ahash;
+	struct crypto_alg *base;
+	int err;
+
+	if (!p)
+		return -ENOMEM;
+
+	p->child_alg = n2ahash->alg.halg.base.cra_name;
+	memcpy(&p->derived, n2ahash, sizeof(struct n2_ahash_alg));
+	INIT_LIST_HEAD(&p->derived.entry);
+
+	ahash = &p->derived.alg;
+	ahash->digest = n2_hmac_async_digest;
+	ahash->setkey = n2_hmac_async_setkey;
+
+	base = &ahash->halg.base;
+	snprintf(base->cra_name, CRYPTO_MAX_ALG_NAME, "hmac(%s)", p->child_alg);
+	snprintf(base->cra_driver_name, CRYPTO_MAX_ALG_NAME, "hmac-%s-n2", p->child_alg);
+
+	base->cra_ctxsize = sizeof(struct n2_hmac_ctx);
+	base->cra_init = n2_hmac_cra_init;
+	base->cra_exit = n2_hmac_cra_exit;
+
+	list_add(&p->derived.entry, &hmac_algs);
+	err = crypto_register_ahash(ahash);
+	if (err) {
+		pr_err("%s alg registration failed\n", base->cra_name);
+		list_del(&p->derived.entry);
+		kfree(p);
+	} else {
+		pr_info("%s alg registered\n", base->cra_name);
+	}
+	return err;
+}
+
 static int __devinit __n2_register_one_ahash(const struct n2_hash_tmpl *tmpl)
 {
 	struct n2_ahash_alg *p = kzalloc(sizeof(*p), GFP_KERNEL);
@@ -1276,6 +1475,7 @@ static int __devinit __n2_register_one_ahash(const struct n2_hash_tmpl *tmpl)
 	p->hash_zero = tmpl->hash_zero;
 	p->hash_init = tmpl->hash_init;
 	p->auth_type = tmpl->auth_type;
+	p->hmac_type = tmpl->hmac_type;
 	p->hw_op_hashsz = tmpl->hw_op_hashsz;
 	p->digest_size = tmpl->digest_size;
 
@@ -1309,6 +1509,8 @@ static int __devinit __n2_register_one_ahash(const struct n2_hash_tmpl *tmpl)
 	} else {
 		pr_info("%s alg registered\n", base->cra_name);
 	}
+	if (!err && p->hmac_type != AUTH_TYPE_RESERVED)
+		err = __n2_register_one_hmac(p);
 	return err;
 }
 
-- 
1.7.0.4
