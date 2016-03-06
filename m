From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 1/3] crypto: authenc - add TLS type encryption
Date: Sat, 05 Mar 2016 17:20:49 -0800
Message-ID: <20160306012049.6369.99836.stgit@tstruk-mobl1>
References: <20160306012044.6369.63924.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net, tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:63617 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbcCFBZW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 5 Mar 2016 20:25:22 -0500
In-Reply-To: <20160306012044.6369.63924.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds a new authentication mode for TLS type encryption.
During encrypt it generates auth data + padding and then the
plaintext || authdata || padding is encrypted.
This requires the user to provide extra space for the cipher text.
The required space can be calculated as
outlen = assoc len + plaintext len + hash size + cipher block size
On decrypt first the whole buffer is decrypted, and then
verification of the authdata and padding is performed.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/Makefile  |    2 
 crypto/encauth.c |  510 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 511 insertions(+), 1 deletion(-)
 create mode 100644 crypto/encauth.c

diff --git a/crypto/Makefile b/crypto/Makefile
index 4f4ef7e..a372335 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -103,7 +103,7 @@ obj-$(CONFIG_CRYPTO_MICHAEL_MIC) += michael_mic.o
 obj-$(CONFIG_CRYPTO_CRC32C) += crc32c_generic.o
 obj-$(CONFIG_CRYPTO_CRC32) += crc32_generic.o
 obj-$(CONFIG_CRYPTO_CRCT10DIF) += crct10dif_common.o crct10dif_generic.o
-obj-$(CONFIG_CRYPTO_AUTHENC) += authenc.o authencesn.o
+obj-$(CONFIG_CRYPTO_AUTHENC) += authenc.o authencesn.o encauth.o
 obj-$(CONFIG_CRYPTO_LZO) += lzo.o
 obj-$(CONFIG_CRYPTO_LZ4) += lz4.o
 obj-$(CONFIG_CRYPTO_LZ4HC) += lz4hc.o
diff --git a/crypto/encauth.c b/crypto/encauth.c
new file mode 100644
index 0000000..3c0ee1a
--- /dev/null
+++ b/crypto/encauth.c
@@ -0,0 +1,510 @@
+/*
+ * Encauth: Simple AEAD wrapper for TLS.
+ * Derived from authenc.c
+ *
+ * Copyright (c) 2016 Intel Corp.
+ *
+ * Author: Tadeusz Struk <tadeusz.struk@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+#include <crypto/internal/aead.h>
+#include <crypto/internal/hash.h>
+#include <crypto/internal/skcipher.h>
+#include <crypto/authenc.h>
+#include <crypto/null.h>
+#include <crypto/scatterwalk.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/rtnetlink.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+
+struct encauth_instance_ctx {
+	struct crypto_ahash_spawn auth;
+	struct crypto_skcipher_spawn enc;
+	unsigned int reqoff;
+};
+
+struct crypto_encauth_ctx {
+	struct crypto_ahash *auth;
+	struct crypto_ablkcipher *enc;
+	struct crypto_blkcipher *null;
+};
+
+struct encauth_request_ctx {
+	struct scatterlist src[2];
+	struct scatterlist dst[2];
+	int padd_err;
+	u8 paddlen;
+	char tail[];
+};
+
+static void encauth_request_complete(struct aead_request *req, int err)
+{
+	if (err != -EINPROGRESS)
+		aead_request_complete(req, err);
+}
+
+static int crypto_encauth_setkey(struct crypto_aead *encauth, const u8 *key,
+				 unsigned int keylen)
+{
+	struct crypto_encauth_ctx *ctx = crypto_aead_ctx(encauth);
+	struct crypto_ahash *auth = ctx->auth;
+	struct crypto_ablkcipher *enc = ctx->enc;
+	struct crypto_authenc_keys keys;
+	int err = -EINVAL;
+
+	if (crypto_authenc_extractkeys(&keys, key, keylen) != 0)
+		goto badkey;
+
+	crypto_ahash_clear_flags(auth, CRYPTO_TFM_REQ_MASK);
+	crypto_ahash_set_flags(auth, crypto_aead_get_flags(encauth) &
+			       CRYPTO_TFM_REQ_MASK);
+	err = crypto_ahash_setkey(auth, keys.authkey, keys.authkeylen);
+	crypto_aead_set_flags(encauth, crypto_ahash_get_flags(auth) &
+			      CRYPTO_TFM_RES_MASK);
+
+	if (err)
+		goto out;
+
+	crypto_ablkcipher_clear_flags(enc, CRYPTO_TFM_REQ_MASK);
+	crypto_ablkcipher_set_flags(enc, crypto_aead_get_flags(encauth) &
+				    CRYPTO_TFM_REQ_MASK);
+	err = crypto_ablkcipher_setkey(enc, keys.enckey, keys.enckeylen);
+	crypto_aead_set_flags(encauth, crypto_ablkcipher_get_flags(enc) &
+			      CRYPTO_TFM_RES_MASK);
+
+out:
+	return err;
+
+badkey:
+	crypto_aead_set_flags(encauth, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	goto out;
+}
+
+static int crypto_encauth_copy_assoc(struct aead_request *req)
+{
+	struct crypto_aead *encauth = crypto_aead_reqtfm(req);
+	struct crypto_encauth_ctx *ctx = crypto_aead_ctx(encauth);
+	struct blkcipher_desc desc = {
+		.tfm = ctx->null,
+	};
+
+	return crypto_blkcipher_encrypt(&desc, req->dst, req->src,
+					req->assoclen);
+}
+
+static void encauth_encrypt_done(struct crypto_async_request *req, int err)
+{
+	struct aead_request *areq = req->data;
+
+	encauth_request_complete(areq, err);
+}
+
+static int crypto_encauth_encrypt(struct aead_request *req)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct aead_instance *inst = aead_alg_instance(tfm);
+	struct crypto_encauth_ctx *ctx = crypto_aead_ctx(tfm);
+	struct encauth_instance_ctx *ictx = aead_instance_ctx(inst);
+	struct encauth_request_ctx *areq_ctx = aead_request_ctx(req);
+	struct crypto_ablkcipher *enc = ctx->enc;
+	struct ablkcipher_request *abreq = (void *)(areq_ctx->tail +
+						    ictx->reqoff);
+	struct scatterlist *src, *dst;
+	int err;
+
+	sg_init_table(areq_ctx->src, 2);
+	src = scatterwalk_ffwd(areq_ctx->src, req->src, req->assoclen);
+	dst = src;
+
+	if (req->src != req->dst) {
+		err = crypto_encauth_copy_assoc(req);
+		if (err)
+			return err;
+
+		sg_init_table(areq_ctx->dst, 2);
+		dst = scatterwalk_ffwd(areq_ctx->dst, req->dst, req->assoclen);
+	}
+	ablkcipher_request_set_tfm(abreq, enc);
+	ablkcipher_request_set_callback(abreq, aead_request_flags(req),
+					encauth_encrypt_done, req);
+	ablkcipher_request_set_crypt(abreq, src, dst, req->cryptlen +
+				     crypto_aead_authsize(tfm) +
+				     areq_ctx->paddlen, req->iv);
+	return crypto_ablkcipher_encrypt(abreq);
+}
+
+static void encauth_geniv_ahash_done(struct crypto_async_request *areq, int err)
+{
+	struct aead_request *req = areq->data;
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct aead_instance *inst = aead_alg_instance(tfm);
+	struct encauth_instance_ctx *ictx = aead_instance_ctx(inst);
+	struct encauth_request_ctx *areq_ctx = aead_request_ctx(req);
+	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ictx->reqoff);
+
+	if (err)
+		goto out;
+
+	scatterwalk_map_and_copy(ahreq->result, req->dst,
+				 req->assoclen + req->cryptlen,
+				 crypto_aead_authsize(tfm), 1);
+	err = crypto_encauth_encrypt(req);
+out:
+	encauth_request_complete(req, err);
+}
+
+static int crypto_encauth_genicv_encrypt(struct aead_request *req)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct aead_instance *inst = aead_alg_instance(tfm);
+	struct crypto_encauth_ctx *ctx = crypto_aead_ctx(tfm);
+	struct encauth_instance_ctx *ictx = aead_instance_ctx(inst);
+	struct crypto_ahash *auth = ctx->auth;
+	struct encauth_request_ctx *areq_ctx = aead_request_ctx(req);
+	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ictx->reqoff);
+	u8 paddlen, *hash = areq_ctx->tail;
+	const unsigned int bs = crypto_aead_blocksize(tfm);
+	unsigned int as = crypto_aead_authsize(tfm);
+	u8 padd[bs];
+	int err;
+
+	hash = (u8 *)ALIGN((unsigned long)hash + crypto_ahash_alignmask(auth),
+			   crypto_ahash_alignmask(auth) + 1);
+
+	/* apply padding */
+	paddlen = bs - ((req->cryptlen + as) % bs);
+	memset(padd, paddlen - 1, paddlen);
+	if (sg_copy_buffer(req->src, sg_nents(req->src), padd, paddlen,
+			   req->cryptlen + req->assoclen + as, 0) != paddlen)
+		return -EINVAL;
+
+	areq_ctx->paddlen = paddlen;
+	ahash_request_set_tfm(ahreq, auth);
+	ahash_request_set_crypt(ahreq, req->src, hash,
+				req->assoclen + req->cryptlen);
+	ahash_request_set_callback(ahreq, aead_request_flags(req),
+				   encauth_geniv_ahash_done, req);
+	err = crypto_ahash_digest(ahreq);
+	if (err)
+		return err;
+
+	scatterwalk_map_and_copy(hash, req->src, req->assoclen + req->cryptlen,
+				 crypto_aead_authsize(tfm), 1);
+	return crypto_encauth_encrypt(req);
+}
+
+static void encauth_dgst_verify_done(struct crypto_async_request *req, int err)
+{
+	struct aead_request *areq = req->data;
+	struct crypto_aead *tfm = crypto_aead_reqtfm(areq);
+	unsigned int authsize = crypto_aead_authsize(tfm);
+	struct ahash_request *ahreq = (void *)req;
+	struct encauth_request_ctx *areq_ctx = aead_request_ctx(areq);
+	u8 *ihash = ahreq->result + authsize;
+
+	scatterwalk_map_and_copy(ihash, areq->dst, ahreq->nbytes, authsize, 0);
+
+	if (crypto_memneq(ihash, ahreq->result, authsize) || areq_ctx->padd_err)
+		err = -EBADMSG;
+
+	encauth_request_complete(areq, err);
+}
+
+static int crypto_encauth_dgst_verify(struct aead_request *req,
+				      unsigned int flags)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	unsigned int authsize = crypto_aead_authsize(tfm);
+	struct aead_instance *inst = aead_alg_instance(tfm);
+	struct crypto_encauth_ctx *ctx = crypto_aead_ctx(tfm);
+	struct encauth_instance_ctx *ictx = aead_instance_ctx(inst);
+	struct crypto_ahash *auth = ctx->auth;
+	struct encauth_request_ctx *areq_ctx = aead_request_ctx(req);
+	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ictx->reqoff);
+	u8 *hash = areq_ctx->tail;
+	int i, err = 0, padd_err = 0;
+	u8 paddlen, *ihash;
+	u8 padd[255];
+
+	scatterwalk_map_and_copy(&paddlen, req->dst, req->assoclen +
+				 req->cryptlen - 1, 1, 0);
+
+	if (paddlen > 255 || paddlen > req->cryptlen) {
+		paddlen = 1;
+		padd_err = -EBADMSG;
+	}
+
+	scatterwalk_map_and_copy(padd, req->dst, req->assoclen +
+				 req->cryptlen - paddlen, paddlen, 0);
+
+	for (i = 0; i < paddlen; i++) {
+		if (padd[i] != paddlen)
+			padd_err = -EBADMSG;
+	}
+
+	areq_ctx->padd_err = padd_err;
+
+	hash = (u8 *)ALIGN((unsigned long)hash + crypto_ahash_alignmask(auth),
+			   crypto_ahash_alignmask(auth) + 1);
+
+	ahash_request_set_tfm(ahreq, auth);
+	ahash_request_set_crypt(ahreq, req->dst, hash,
+				req->assoclen + req->cryptlen -
+				authsize - paddlen - 1);
+	ahash_request_set_callback(ahreq, aead_request_flags(req),
+				   encauth_dgst_verify_done, req);
+	err = crypto_ahash_digest(ahreq);
+	if (err)
+		return err;
+
+	ihash = ahreq->result + authsize;
+	scatterwalk_map_and_copy(ihash, req->dst, ahreq->nbytes, authsize, 0);
+	if (crypto_memneq(ihash, ahreq->result, authsize) || padd_err)
+		err = -EBADMSG;
+
+	return err;
+}
+
+static void encauth_decrypt_done(struct crypto_async_request *areq, int err)
+{
+	struct aead_request *req = areq->data;
+
+	if (err)
+		goto out;
+
+	err = crypto_encauth_dgst_verify(req, aead_request_flags(req));
+out:
+	encauth_request_complete(req, err);
+}
+
+static int crypto_encauth_decrypt(struct aead_request *req)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct aead_instance *inst = aead_alg_instance(tfm);
+	struct crypto_encauth_ctx *ctx = crypto_aead_ctx(tfm);
+	struct encauth_instance_ctx *ictx = aead_instance_ctx(inst);
+	struct encauth_request_ctx *areq_ctx = aead_request_ctx(req);
+	struct ablkcipher_request *abreq = (void *)(areq_ctx->tail +
+							ictx->reqoff);
+	struct scatterlist *src, *dst;
+	int err;
+
+	sg_init_table(areq_ctx->src, 2);
+	src = scatterwalk_ffwd(areq_ctx->src, req->src, req->assoclen);
+	dst = src;
+
+	if (req->src != req->dst) {
+		err = crypto_encauth_copy_assoc(req);
+		if (err)
+			return err;
+
+		sg_init_table(areq_ctx->dst, 2);
+		dst = scatterwalk_ffwd(areq_ctx->dst, req->dst, req->assoclen);
+	}
+	ablkcipher_request_set_tfm(abreq, ctx->enc);
+	ablkcipher_request_set_callback(abreq, aead_request_flags(req),
+					encauth_decrypt_done, req);
+	ablkcipher_request_set_crypt(abreq, src, dst, req->cryptlen, req->iv);
+	err = crypto_ablkcipher_decrypt(abreq);
+	if (err)
+		return err;
+
+	return crypto_encauth_dgst_verify(req, aead_request_flags(req));
+}
+
+static int crypto_encauth_init_tfm(struct crypto_aead *tfm)
+{
+	struct aead_instance *inst = aead_alg_instance(tfm);
+	struct encauth_instance_ctx *ictx = aead_instance_ctx(inst);
+	struct crypto_encauth_ctx *ctx = crypto_aead_ctx(tfm);
+	struct crypto_ahash *auth;
+	struct crypto_ablkcipher *enc;
+	struct crypto_blkcipher *null;
+	int err;
+
+	auth = crypto_spawn_ahash(&ictx->auth);
+	if (IS_ERR(auth))
+		return PTR_ERR(auth);
+
+	enc = crypto_spawn_skcipher(&ictx->enc);
+	err = PTR_ERR(enc);
+	if (IS_ERR(enc))
+		goto err_free_ahash;
+
+	null = crypto_get_default_null_skcipher();
+	err = PTR_ERR(null);
+	if (IS_ERR(null))
+		goto err_free_skcipher;
+
+	ctx->auth = auth;
+	ctx->enc = enc;
+	ctx->null = null;
+
+	crypto_aead_set_reqsize(tfm, sizeof(struct encauth_request_ctx) +
+				ictx->reqoff +
+				max_t(unsigned int, crypto_ahash_reqsize(auth) +
+				      sizeof(struct ahash_request),
+				      sizeof(struct ablkcipher_request) +
+				      crypto_ablkcipher_reqsize(enc)));
+	return 0;
+
+err_free_skcipher:
+	crypto_free_ablkcipher(enc);
+err_free_ahash:
+	crypto_free_ahash(auth);
+	return err;
+}
+
+static void crypto_encauth_exit_tfm(struct crypto_aead *tfm)
+{
+	struct crypto_encauth_ctx *ctx = crypto_aead_ctx(tfm);
+
+	crypto_free_ahash(ctx->auth);
+	crypto_free_ablkcipher(ctx->enc);
+	crypto_put_default_null_skcipher();
+}
+
+static void crypto_encauth_free(struct aead_instance *inst)
+{
+	struct encauth_instance_ctx *ctx = aead_instance_ctx(inst);
+
+	crypto_drop_skcipher(&ctx->enc);
+	crypto_drop_ahash(&ctx->auth);
+	kfree(inst);
+}
+
+static int crypto_encauth_create(struct crypto_template *tmpl,
+				 struct rtattr **tb)
+{
+	struct crypto_attr_type *algt;
+	struct aead_instance *inst;
+	struct hash_alg_common *auth;
+	struct crypto_alg *auth_base;
+	struct crypto_alg *enc;
+	struct encauth_instance_ctx *ctx;
+	const char *enc_name;
+	int err;
+
+	algt = crypto_get_attr_type(tb);
+	if (IS_ERR(algt))
+		return PTR_ERR(algt);
+
+	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
+		return -EINVAL;
+
+	auth = ahash_attr_alg(tb[1], CRYPTO_ALG_TYPE_HASH,
+			      CRYPTO_ALG_TYPE_AHASH_MASK);
+	if (IS_ERR(auth))
+		return PTR_ERR(auth);
+
+	auth_base = &auth->base;
+
+	enc_name = crypto_attr_alg_name(tb[2]);
+	err = PTR_ERR(enc_name);
+	if (IS_ERR(enc_name))
+		goto out_put_auth;
+
+	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
+	err = -ENOMEM;
+	if (!inst)
+		goto out_put_auth;
+
+	ctx = aead_instance_ctx(inst);
+
+	err = crypto_init_ahash_spawn(&ctx->auth, auth,
+				      aead_crypto_instance(inst));
+	if (err)
+		goto err_free_inst;
+
+	crypto_set_skcipher_spawn(&ctx->enc, aead_crypto_instance(inst));
+	err = crypto_grab_skcipher(&ctx->enc, enc_name, 0,
+				   crypto_requires_sync(algt->type,
+							algt->mask));
+	if (err)
+		goto err_drop_auth;
+
+	enc = crypto_skcipher_spawn_alg(&ctx->enc);
+
+	ctx->reqoff = ALIGN(2 * auth->digestsize + auth_base->cra_alignmask,
+			    auth_base->cra_alignmask + 1);
+
+	err = -ENAMETOOLONG;
+	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
+		     "encauth(%s,%s)", auth_base->cra_name, enc->cra_name) >=
+	    CRYPTO_MAX_ALG_NAME)
+		goto err_drop_enc;
+
+	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
+		     "encauth(%s,%s)", auth_base->cra_driver_name,
+		     enc->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
+		goto err_drop_enc;
+
+	inst->alg.base.cra_flags = enc->cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_priority = enc->cra_priority * 10 +
+				      auth_base->cra_priority;
+	inst->alg.base.cra_blocksize = enc->cra_blocksize;
+	inst->alg.base.cra_alignmask = auth_base->cra_alignmask |
+				       enc->cra_alignmask;
+	inst->alg.base.cra_ctxsize = sizeof(struct crypto_encauth_ctx);
+
+	inst->alg.ivsize = enc->cra_ablkcipher.ivsize;
+	inst->alg.maxauthsize = auth->digestsize;
+
+	inst->alg.init = crypto_encauth_init_tfm;
+	inst->alg.exit = crypto_encauth_exit_tfm;
+
+	inst->alg.setkey = crypto_encauth_setkey;
+	inst->alg.encrypt = crypto_encauth_genicv_encrypt;
+	inst->alg.decrypt = crypto_encauth_decrypt;
+
+	inst->free = crypto_encauth_free;
+
+	err = aead_register_instance(tmpl, inst);
+	if (err)
+		goto err_drop_enc;
+
+out:
+	crypto_mod_put(auth_base);
+	return err;
+
+err_drop_enc:
+	crypto_drop_skcipher(&ctx->enc);
+err_drop_auth:
+	crypto_drop_ahash(&ctx->auth);
+err_free_inst:
+	kfree(inst);
+out_put_auth:
+	goto out;
+}
+
+static struct crypto_template crypto_encauth_tmpl = {
+	.name = "encauth",
+	.create = crypto_encauth_create,
+	.module = THIS_MODULE,
+};
+
+static int __init crypto_encauth_module_init(void)
+{
+	return crypto_register_template(&crypto_encauth_tmpl);
+}
+
+static void __exit crypto_encauth_module_exit(void)
+{
+	crypto_unregister_template(&crypto_encauth_tmpl);
+}
+
+module_init(crypto_encauth_module_init);
+module_exit(crypto_encauth_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Simple AEAD wrapper for TLS");
+MODULE_ALIAS_CRYPTO("encauth");
