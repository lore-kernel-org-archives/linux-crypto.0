Return-Path: <SRS0=8/la=PM=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727710AbfADEU4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jan 2019 23:20:56 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 05/16] crypto: skcipher - add helper for simple block cipher modes
Date: Thu,  3 Jan 2019 20:16:14 -0800
Message-Id: <20190104041625.3259-6-ebiggers@kernel.org>
In-Reply-To: <20190104041625.3259-1-ebiggers@kernel.org>
References: <20190104041625.3259-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

The majority of skcipher templates (including both the existing ones and
the ones remaining to be converted from the "blkcipher" API) just wrap a
single block cipher algorithm.  This includes cbc, cfb, ctr, ecb, kw,
ofb, and pcbc.  Add a helper function skcipher_alloc_instance_simple()
that handles allocating an skcipher instance for this common case.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/skcipher.c                  | 131 +++++++++++++++++++++++++++++
 include/crypto/internal/skcipher.h |  15 ++++
 2 files changed, 146 insertions(+)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 2a969296bc248..040ae6377b32b 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -1058,5 +1058,136 @@ int skcipher_register_instance(struct crypto_template *tmpl,
 }
 EXPORT_SYMBOL_GPL(skcipher_register_instance);
 
+static int skcipher_setkey_simple(struct crypto_skcipher *tfm, const u8 *key,
+				  unsigned int keylen)
+{
+	struct crypto_cipher *cipher = skcipher_cipher_simple(tfm);
+	int err;
+
+	crypto_cipher_clear_flags(cipher, CRYPTO_TFM_REQ_MASK);
+	crypto_cipher_set_flags(cipher, crypto_skcipher_get_flags(tfm) &
+				CRYPTO_TFM_REQ_MASK);
+	err = crypto_cipher_setkey(cipher, key, keylen);
+	crypto_skcipher_set_flags(tfm, crypto_cipher_get_flags(cipher) &
+				  CRYPTO_TFM_RES_MASK);
+	return err;
+}
+
+static int skcipher_init_tfm_simple(struct crypto_skcipher *tfm)
+{
+	struct skcipher_instance *inst = skcipher_alg_instance(tfm);
+	struct crypto_spawn *spawn = skcipher_instance_ctx(inst);
+	struct skcipher_ctx_simple *ctx = crypto_skcipher_ctx(tfm);
+	struct crypto_cipher *cipher;
+
+	cipher = crypto_spawn_cipher(spawn);
+	if (IS_ERR(cipher))
+		return PTR_ERR(cipher);
+
+	ctx->cipher = cipher;
+	return 0;
+}
+
+static void skcipher_exit_tfm_simple(struct crypto_skcipher *tfm)
+{
+	struct skcipher_ctx_simple *ctx = crypto_skcipher_ctx(tfm);
+
+	crypto_free_cipher(ctx->cipher);
+}
+
+static void skcipher_free_instance_simple(struct skcipher_instance *inst)
+{
+	crypto_drop_spawn(skcipher_instance_ctx(inst));
+	kfree(inst);
+}
+
+/**
+ * skcipher_alloc_instance_simple - allocate instance of simple block cipher mode
+ *
+ * Allocate an skcipher_instance for a simple block cipher mode of operation,
+ * e.g. cbc or ecb.  The instance context will have just a single crypto_spawn,
+ * that for the underlying cipher.  The {min,max}_keysize, ivsize, blocksize,
+ * alignmask, and priority are set from the underlying cipher but can be
+ * overridden if needed.  The tfm context defaults to skcipher_ctx_simple, and
+ * default ->setkey(), ->init(), and ->exit() methods are installed.
+ *
+ * @tmpl: the template being instantiated
+ * @tb: the template parameters
+ * @cipher_alg_ret: on success, a pointer to the underlying cipher algorithm is
+ *		    returned here.  It must be dropped with crypto_mod_put().
+ *
+ * Return: a pointer to the new instance, or an ERR_PTR().  The caller still
+ *	   needs to register the instance.
+ */
+struct skcipher_instance *
+skcipher_alloc_instance_simple(struct crypto_template *tmpl, struct rtattr **tb,
+			       struct crypto_alg **cipher_alg_ret)
+{
+	struct crypto_attr_type *algt;
+	struct crypto_alg *cipher_alg;
+	struct skcipher_instance *inst;
+	struct crypto_spawn *spawn;
+	u32 mask;
+	int err;
+
+	algt = crypto_get_attr_type(tb);
+	if (IS_ERR(algt))
+		return ERR_CAST(algt);
+
+	if ((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask)
+		return ERR_PTR(-EINVAL);
+
+	mask = CRYPTO_ALG_TYPE_MASK |
+		crypto_requires_off(algt->type, algt->mask,
+				    CRYPTO_ALG_NEED_FALLBACK);
+
+	cipher_alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER, mask);
+	if (IS_ERR(cipher_alg))
+		return ERR_CAST(cipher_alg);
+
+	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
+	if (!inst) {
+		err = -ENOMEM;
+		goto err_put_cipher_alg;
+	}
+	spawn = skcipher_instance_ctx(inst);
+
+	err = crypto_inst_setname(skcipher_crypto_instance(inst), tmpl->name,
+				  cipher_alg);
+	if (err)
+		goto err_free_inst;
+
+	err = crypto_init_spawn(spawn, cipher_alg,
+				skcipher_crypto_instance(inst),
+				CRYPTO_ALG_TYPE_MASK);
+	if (err)
+		goto err_free_inst;
+	inst->free = skcipher_free_instance_simple;
+
+	/* Default algorithm properties, can be overridden */
+	inst->alg.base.cra_blocksize = cipher_alg->cra_blocksize;
+	inst->alg.base.cra_alignmask = cipher_alg->cra_alignmask;
+	inst->alg.base.cra_priority = cipher_alg->cra_priority;
+	inst->alg.min_keysize = cipher_alg->cra_cipher.cia_min_keysize;
+	inst->alg.max_keysize = cipher_alg->cra_cipher.cia_max_keysize;
+	inst->alg.ivsize = cipher_alg->cra_blocksize;
+
+	/* Use skcipher_ctx_simple by default, can be overridden */
+	inst->alg.base.cra_ctxsize = sizeof(struct skcipher_ctx_simple);
+	inst->alg.setkey = skcipher_setkey_simple;
+	inst->alg.init = skcipher_init_tfm_simple;
+	inst->alg.exit = skcipher_exit_tfm_simple;
+
+	*cipher_alg_ret = cipher_alg;
+	return inst;
+
+err_free_inst:
+	kfree(inst);
+err_put_cipher_alg:
+	crypto_mod_put(cipher_alg);
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL_GPL(skcipher_alloc_instance_simple);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Symmetric key cipher type");
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index 453e867b4bd92..9de6032209cb1 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -205,5 +205,20 @@ static inline unsigned int crypto_skcipher_alg_max_keysize(
 	return alg->max_keysize;
 }
 
+/* Helpers for simple block cipher modes of operation */
+struct skcipher_ctx_simple {
+	struct crypto_cipher *cipher;	/* underlying block cipher */
+};
+static inline struct crypto_cipher *
+skcipher_cipher_simple(struct crypto_skcipher *tfm)
+{
+	struct skcipher_ctx_simple *ctx = crypto_skcipher_ctx(tfm);
+
+	return ctx->cipher;
+}
+struct skcipher_instance *
+skcipher_alloc_instance_simple(struct crypto_template *tmpl, struct rtattr **tb,
+			       struct crypto_alg **cipher_alg_ret);
+
 #endif	/* _CRYPTO_INTERNAL_SKCIPHER_H */
 
-- 
2.20.1
