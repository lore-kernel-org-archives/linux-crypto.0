From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 8/8] [CRYPTO] gcm: Introduce rfc4106
Date: Mon, 17 Dec 2007 18:31:20 +0800
Message-ID: <E1J4DFo-00039V-00@gondolin.me.apana.org.au>
References: <20071217103037.GA11988@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4846 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760407AbXLQKb2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Dec 2007 05:31:28 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J4DFq-0008Vv-Ty
	for <linux-crypto@vger.kernel.org>; Mon, 17 Dec 2007 21:31:24 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] gcm: Introduce rfc4106

This patch introduces the rfc4106 wrapper for GCM just as we have an
rfc4309 wrapper for CCM.  The purpose of the wrapper is to include part
of the IV in the key so that it can be negotiated by IPsec.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/gcm.c    |  349 ++++++++++++++++++++++++++++++++++++++++++++++++--------
 crypto/tcrypt.c |    8 -
 2 files changed, 308 insertions(+), 49 deletions(-)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index 8f1d08c..8ec72da 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -8,11 +8,11 @@
  * by the Free Software Foundation.
  */
 
-#include <crypto/aead.h>
-#include <crypto/ctr.h>
 #include <crypto/gf128mul.h>
+#include <crypto/internal/aead.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
+#include <linux/completion.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -21,7 +21,6 @@
 
 struct gcm_instance_ctx {
 	struct crypto_skcipher_spawn ctr;
-	char cipher_name[CRYPTO_MAX_ALG_NAME];
 };
 
 struct crypto_gcm_ctx {
@@ -29,6 +28,11 @@ struct crypto_gcm_ctx {
 	struct gf128mul_4k *gf128;
 };
 
+struct crypto_rfc4106_ctx {
+	struct crypto_aead *child;
+	u8 nonce[4];
+};
+
 struct crypto_gcm_ghash_ctx {
 	u32 bytes;
 	u32 flags;
@@ -45,6 +49,11 @@ struct crypto_gcm_req_priv_ctx {
 	struct skcipher_givcrypt_request greq;
 };
 
+struct crypto_gcm_setkey_result {
+	int err;
+	struct completion completion;
+};
+
 static inline struct crypto_gcm_req_priv_ctx *crypto_gcm_reqctx(
 	struct aead_request *req)
 {
@@ -160,16 +169,31 @@ static void crypto_gcm_ghash_final_xor(struct crypto_gcm_ghash_ctx *ctx,
 	crypto_xor(dst, buf, 16);
 }
 
+static void crypto_gcm_setkey_done(struct crypto_async_request *req, int err)
+{
+	struct crypto_gcm_setkey_result *result = req->data;
+
+	if (err == -EINPROGRESS)
+		return;
+
+	result->err = err;
+	complete(&result->completion);
+}
+
 static int crypto_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 			     unsigned int keylen)
 {
-	struct crypto_instance *inst = crypto_tfm_alg_instance(
-		crypto_aead_tfm(aead));
-	struct gcm_instance_ctx *ictx = crypto_instance_ctx(inst);
 	struct crypto_gcm_ctx *ctx = crypto_aead_ctx(aead);
 	struct crypto_ablkcipher *ctr = ctx->ctr;
-	struct crypto_cipher *cipher;
-	be128 hash;
+	struct {
+		be128 hash;
+		u8 iv[8];
+
+		struct crypto_gcm_setkey_result result;
+
+		struct scatterlist sg[1];
+		struct ablkcipher_request req;
+	} *data;
 	int err;
 
 	crypto_ablkcipher_clear_flags(ctr, CRYPTO_TFM_REQ_MASK);
@@ -183,41 +207,64 @@ static int crypto_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 	crypto_aead_set_flags(aead, crypto_ablkcipher_get_flags(ctr) &
 				       CRYPTO_TFM_RES_MASK);
 
-	cipher = crypto_alloc_cipher(ictx->cipher_name, 0, 0);
-	if (IS_ERR(cipher))
-		return PTR_ERR(cipher);
-
-	err = -EINVAL;
-	if (crypto_cipher_blocksize(cipher) != sizeof(hash))
-		goto out;
-
-	crypto_cipher_clear_flags(cipher, CRYPTO_TFM_REQ_MASK);
-	crypto_cipher_set_flags(cipher, crypto_aead_get_flags(aead) &
-					CRYPTO_TFM_REQ_MASK);
-	err = crypto_cipher_setkey(cipher, key,
-				   keylen - CTR_RFC3686_NONCE_SIZE);
-	crypto_aead_set_flags(aead, crypto_cipher_get_flags(cipher) &
-				    CRYPTO_TFM_RES_MASK);
+	data = kzalloc(sizeof(*data) + crypto_ablkcipher_reqsize(ctr),
+		       GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	init_completion(&data->result.completion);
+	sg_init_one(data->sg, &data->hash, sizeof(data->hash));
+	ablkcipher_request_set_tfm(&data->req, ctr);
+	ablkcipher_request_set_callback(&data->req, CRYPTO_TFM_REQ_MAY_SLEEP |
+						    CRYPTO_TFM_REQ_MAY_BACKLOG,
+					crypto_gcm_setkey_done,
+					&data->result);
+	ablkcipher_request_set_crypt(&data->req, data->sg, data->sg,
+				     sizeof(data->hash), data->iv);
+
+	err = crypto_ablkcipher_encrypt(&data->req);
+	if (err == -EINPROGRESS || err == -EBUSY) {
+		err = wait_for_completion_interruptible(
+			&data->result.completion);
+		if (!err)
+			err = data->result.err;
+	}
 
 	if (err)
 		goto out;
 
-	memset(&hash, 0, sizeof(hash));
-	crypto_cipher_encrypt_one(cipher, (u8 *)&hash, (u8 *)&hash);
-
 	if (ctx->gf128 != NULL)
 		gf128mul_free_4k(ctx->gf128);
 
-	ctx->gf128 = gf128mul_init_4k_lle((be128 *)&hash);
+	ctx->gf128 = gf128mul_init_4k_lle(&data->hash);
 
 	if (ctx->gf128 == NULL)
 		err = -ENOMEM;
 
- out:
-	crypto_free_cipher(cipher);
+out:
+	kfree(data);
 	return err;
 }
 
+static int crypto_gcm_setauthsize(struct crypto_aead *tfm,
+				  unsigned int authsize)
+{
+	switch (authsize) {
+	case 4:
+	case 8:
+	case 12:
+	case 13:
+	case 14:
+	case 15:
+	case 16:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static void crypto_gcm_init_crypt(struct ablkcipher_request *ablk_req,
 				  struct aead_request *req,
 				  unsigned int cryptlen)
@@ -228,8 +275,10 @@ static void crypto_gcm_init_crypt(struct ablkcipher_request *ablk_req,
 	u32 flags = req->base.tfm->crt_flags;
 	struct crypto_gcm_ghash_ctx *ghash = &pctx->ghash;
 	struct scatterlist *dst;
+	__be32 counter = cpu_to_be32(1);
 
 	memset(pctx->auth_tag, 0, sizeof(pctx->auth_tag));
+	memcpy(req->iv + 12, &counter, 4);
 
 	sg_init_table(pctx->src, 2);
 	sg_set_buf(pctx->src, pctx->auth_tag, sizeof(pctx->auth_tag));
@@ -451,8 +500,7 @@ static void crypto_gcm_exit_tfm(struct crypto_tfm *tfm)
 
 static struct crypto_instance *crypto_gcm_alloc_common(struct rtattr **tb,
 						       const char *full_name,
-						       const char *ctr_name,
-						       const char *cipher_name)
+						       const char *ctr_name)
 {
 	struct crypto_attr_type *algt;
 	struct crypto_instance *inst;
@@ -482,6 +530,10 @@ static struct crypto_instance *crypto_gcm_alloc_common(struct rtattr **tb,
 
 	ctr = crypto_skcipher_spawn_alg(&ctx->ctr);
 
+	/* We only support 16-byte blocks. */
+	if (ctr->cra_ablkcipher.ivsize != 16)
+		goto out_put_ctr;
+
 	/* Not a stream cipher? */
 	err = -EINVAL;
 	if (ctr->cra_blocksize != 1)
@@ -489,12 +541,11 @@ static struct crypto_instance *crypto_gcm_alloc_common(struct rtattr **tb,
 
 	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
-		     "gcm_base(%s,%s)", ctr->cra_driver_name, cipher_name) >=
+		     "gcm_base(%s)", ctr->cra_driver_name) >=
 	    CRYPTO_MAX_ALG_NAME)
 		goto out_put_ctr;
 
 	memcpy(inst->alg.cra_name, full_name, CRYPTO_MAX_ALG_NAME);
-	memcpy(ctx->cipher_name, cipher_name, CRYPTO_MAX_ALG_NAME);
 
 	inst->alg.cra_flags = CRYPTO_ALG_TYPE_AEAD;
 	inst->alg.cra_flags |= ctr->cra_flags & CRYPTO_ALG_ASYNC;
@@ -502,12 +553,13 @@ static struct crypto_instance *crypto_gcm_alloc_common(struct rtattr **tb,
 	inst->alg.cra_blocksize = 1;
 	inst->alg.cra_alignmask = ctr->cra_alignmask | (__alignof__(u64) - 1);
 	inst->alg.cra_type = &crypto_aead_type;
-	inst->alg.cra_aead.ivsize = 12;
+	inst->alg.cra_aead.ivsize = 16;
 	inst->alg.cra_aead.maxauthsize = 16;
 	inst->alg.cra_ctxsize = sizeof(struct crypto_gcm_ctx);
 	inst->alg.cra_init = crypto_gcm_init_tfm;
 	inst->alg.cra_exit = crypto_gcm_exit_tfm;
 	inst->alg.cra_aead.setkey = crypto_gcm_setkey;
+	inst->alg.cra_aead.setauthsize = crypto_gcm_setauthsize;
 	inst->alg.cra_aead.encrypt = crypto_gcm_encrypt;
 	inst->alg.cra_aead.decrypt = crypto_gcm_decrypt;
 	inst->alg.cra_aead.givencrypt = crypto_gcm_givencrypt;
@@ -536,7 +588,7 @@ static struct crypto_instance *crypto_gcm_alloc(struct rtattr **tb)
 	if (IS_ERR(cipher_name))
 		return ERR_PTR(err);
 
-	if (snprintf(ctr_name, CRYPTO_MAX_ALG_NAME, "rfc3686(ctr(%s))",
+	if (snprintf(ctr_name, CRYPTO_MAX_ALG_NAME, "ctr(%s)",
 		     cipher_name) >= CRYPTO_MAX_ALG_NAME)
 		return ERR_PTR(-ENAMETOOLONG);
 
@@ -544,7 +596,7 @@ static struct crypto_instance *crypto_gcm_alloc(struct rtattr **tb)
 	    CRYPTO_MAX_ALG_NAME)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	return crypto_gcm_alloc_common(tb, full_name, ctr_name, cipher_name);
+	return crypto_gcm_alloc_common(tb, full_name, ctr_name);
 }
 
 static void crypto_gcm_free(struct crypto_instance *inst)
@@ -566,7 +618,6 @@ static struct crypto_instance *crypto_gcm_base_alloc(struct rtattr **tb)
 {
 	int err;
 	const char *ctr_name;
-	const char *cipher_name;
 	char full_name[CRYPTO_MAX_ALG_NAME];
 
 	ctr_name = crypto_attr_alg_name(tb[1]);
@@ -574,16 +625,11 @@ static struct crypto_instance *crypto_gcm_base_alloc(struct rtattr **tb)
 	if (IS_ERR(ctr_name))
 		return ERR_PTR(err);
 
-	cipher_name = crypto_attr_alg_name(tb[2]);
-	err = PTR_ERR(cipher_name);
-	if (IS_ERR(cipher_name))
-		return ERR_PTR(err);
-
-	if (snprintf(full_name, CRYPTO_MAX_ALG_NAME, "gcm_base(%s,%s)",
-		     ctr_name, cipher_name) >= CRYPTO_MAX_ALG_NAME)
+	if (snprintf(full_name, CRYPTO_MAX_ALG_NAME, "gcm_base(%s)",
+		     ctr_name) >= CRYPTO_MAX_ALG_NAME)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	return crypto_gcm_alloc_common(tb, full_name, ctr_name, cipher_name);
+	return crypto_gcm_alloc_common(tb, full_name, ctr_name);
 }
 
 static struct crypto_template crypto_gcm_base_tmpl = {
@@ -593,6 +639,211 @@ static struct crypto_template crypto_gcm_base_tmpl = {
 	.module = THIS_MODULE,
 };
 
+static int crypto_rfc4106_setkey(struct crypto_aead *parent, const u8 *key,
+				 unsigned int keylen)
+{
+	struct crypto_rfc4106_ctx *ctx = crypto_aead_ctx(parent);
+	struct crypto_aead *child = ctx->child;
+	int err;
+
+	if (keylen < 4)
+		return -EINVAL;
+
+	keylen -= 4;
+	memcpy(ctx->nonce, key + keylen, 4);
+
+	crypto_aead_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_aead_set_flags(child, crypto_aead_get_flags(parent) &
+				     CRYPTO_TFM_REQ_MASK);
+	err = crypto_aead_setkey(child, key, keylen);
+	crypto_aead_set_flags(parent, crypto_aead_get_flags(child) &
+				      CRYPTO_TFM_RES_MASK);
+
+	return err;
+}
+
+static int crypto_rfc4106_setauthsize(struct crypto_aead *parent,
+				      unsigned int authsize)
+{
+	struct crypto_rfc4106_ctx *ctx = crypto_aead_ctx(parent);
+
+	switch (authsize) {
+	case 8:
+	case 12:
+	case 16:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return crypto_aead_setauthsize(ctx->child, authsize);
+}
+
+static struct aead_request *crypto_rfc4106_crypt(struct aead_request *req)
+{
+	struct aead_request *subreq = aead_request_ctx(req);
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct crypto_rfc4106_ctx *ctx = crypto_aead_ctx(aead);
+	struct crypto_aead *child = ctx->child;
+	u8 *iv = PTR_ALIGN((u8 *)(subreq + 1) + crypto_aead_reqsize(child),
+			   crypto_aead_alignmask(child) + 1);
+
+	memcpy(iv, ctx->nonce, 4);
+	memcpy(iv + 4, req->iv, 8);
+
+	aead_request_set_tfm(subreq, child);
+	aead_request_set_callback(subreq, req->base.flags, req->base.complete,
+				  req->base.data);
+	aead_request_set_crypt(subreq, req->src, req->dst, req->cryptlen, iv);
+	aead_request_set_assoc(subreq, req->assoc, req->assoclen);
+
+	return subreq;
+}
+
+static int crypto_rfc4106_encrypt(struct aead_request *req)
+{
+	req = crypto_rfc4106_crypt(req);
+
+	return crypto_aead_encrypt(req);
+}
+
+static int crypto_rfc4106_decrypt(struct aead_request *req)
+{
+	req = crypto_rfc4106_crypt(req);
+
+	return crypto_aead_decrypt(req);
+}
+
+static int crypto_rfc4106_init_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_instance *inst = (void *)tfm->__crt_alg;
+	struct crypto_aead_spawn *spawn = crypto_instance_ctx(inst);
+	struct crypto_rfc4106_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_aead *aead;
+	unsigned long align;
+
+	aead = crypto_spawn_aead(spawn);
+	if (IS_ERR(aead))
+		return PTR_ERR(aead);
+
+	ctx->child = aead;
+
+	align = crypto_aead_alignmask(aead);
+	align &= ~(crypto_tfm_ctx_alignment() - 1);
+	tfm->crt_aead.reqsize = sizeof(struct aead_request) +
+				ALIGN(crypto_aead_reqsize(aead),
+				      crypto_tfm_ctx_alignment()) +
+				align + 16;
+
+	return 0;
+}
+
+static void crypto_rfc4106_exit_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_rfc4106_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	crypto_free_aead(ctx->child);
+}
+
+static struct crypto_instance *crypto_rfc4106_alloc(struct rtattr **tb)
+{
+	struct crypto_attr_type *algt;
+	struct crypto_instance *inst;
+	struct crypto_aead_spawn *spawn;
+	struct crypto_alg *alg;
+	const char *ccm_name;
+	int err;
+
+	algt = crypto_get_attr_type(tb);
+	err = PTR_ERR(algt);
+	if (IS_ERR(algt))
+		return ERR_PTR(err);
+
+	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
+		return ERR_PTR(-EINVAL);
+
+	ccm_name = crypto_attr_alg_name(tb[1]);
+	err = PTR_ERR(ccm_name);
+	if (IS_ERR(ccm_name))
+		return ERR_PTR(err);
+
+	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
+	if (!inst)
+		return ERR_PTR(-ENOMEM);
+
+	spawn = crypto_instance_ctx(inst);
+	crypto_set_aead_spawn(spawn, inst);
+	err = crypto_grab_aead(spawn, ccm_name, 0,
+			       crypto_requires_sync(algt->type, algt->mask));
+	if (err)
+		goto out_free_inst;
+
+	alg = crypto_aead_spawn_alg(spawn);
+
+	err = -EINVAL;
+
+	/* We only support 16-byte blocks. */
+	if (alg->cra_aead.ivsize != 16)
+		goto out_drop_alg;
+
+	/* Not a stream cipher? */
+	if (alg->cra_blocksize != 1)
+		goto out_drop_alg;
+
+	err = -ENAMETOOLONG;
+	if (snprintf(inst->alg.cra_name, CRYPTO_MAX_ALG_NAME,
+		     "rfc4106(%s)", alg->cra_name) >= CRYPTO_MAX_ALG_NAME ||
+	    snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
+		     "rfc4106(%s)", alg->cra_driver_name) >=
+	    CRYPTO_MAX_ALG_NAME)
+		goto out_drop_alg;
+
+	inst->alg.cra_flags = CRYPTO_ALG_TYPE_AEAD;
+	inst->alg.cra_flags |= alg->cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.cra_priority = alg->cra_priority;
+	inst->alg.cra_blocksize = 1;
+	inst->alg.cra_alignmask = alg->cra_alignmask;
+	inst->alg.cra_type = &crypto_nivaead_type;
+
+	inst->alg.cra_aead.ivsize = 8;
+	inst->alg.cra_aead.maxauthsize = 16;
+
+	inst->alg.cra_ctxsize = sizeof(struct crypto_rfc4106_ctx);
+
+	inst->alg.cra_init = crypto_rfc4106_init_tfm;
+	inst->alg.cra_exit = crypto_rfc4106_exit_tfm;
+
+	inst->alg.cra_aead.setkey = crypto_rfc4106_setkey;
+	inst->alg.cra_aead.setauthsize = crypto_rfc4106_setauthsize;
+	inst->alg.cra_aead.encrypt = crypto_rfc4106_encrypt;
+	inst->alg.cra_aead.decrypt = crypto_rfc4106_decrypt;
+
+	inst->alg.cra_aead.geniv = "seqiv";
+
+out:
+	return inst;
+
+out_drop_alg:
+	crypto_drop_aead(spawn);
+out_free_inst:
+	kfree(inst);
+	inst = ERR_PTR(err);
+	goto out;
+}
+
+static void crypto_rfc4106_free(struct crypto_instance *inst)
+{
+	crypto_drop_spawn(crypto_instance_ctx(inst));
+	kfree(inst);
+}
+
+static struct crypto_template crypto_rfc4106_tmpl = {
+	.name = "rfc4106",
+	.alloc = crypto_rfc4106_alloc,
+	.free = crypto_rfc4106_free,
+	.module = THIS_MODULE,
+};
+
 static int __init crypto_gcm_module_init(void)
 {
 	int err;
@@ -605,9 +856,15 @@ static int __init crypto_gcm_module_init(void)
 	if (err)
 		goto out_undo_base;
 
+	err = crypto_register_template(&crypto_rfc4106_tmpl);
+	if (err)
+		goto out_undo_gcm;
+
 out:
 	return err;
 
+out_undo_gcm:
+	crypto_unregister_template(&crypto_gcm_tmpl);
 out_undo_base:
 	crypto_unregister_template(&crypto_gcm_base_tmpl);
 	goto out;
@@ -615,6 +872,7 @@ out_undo_base:
 
 static void __exit crypto_gcm_module_exit(void)
 {
+	crypto_unregister_template(&crypto_rfc4106_tmpl);
 	crypto_unregister_template(&crypto_gcm_tmpl);
 	crypto_unregister_template(&crypto_gcm_base_tmpl);
 }
@@ -626,3 +884,4 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Galois/Counter Mode");
 MODULE_AUTHOR("Mikko Herranen <mh1@iki.fi>");
 MODULE_ALIAS("gcm_base");
+MODULE_ALIAS("rfc4106");
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 2b52df7..ab35144 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1213,9 +1213,9 @@ static void do_test(void)
 			    AES_CTR_ENC_TEST_VECTORS);
 		test_cipher("rfc3686(ctr(aes))", DECRYPT, aes_ctr_dec_tv_template,
 			    AES_CTR_DEC_TEST_VECTORS);
-		test_aead("gcm(aes)", ENCRYPT, aes_gcm_enc_tv_template,
+		test_aead("rfc4106(gcm(aes))", ENCRYPT, aes_gcm_enc_tv_template,
 			  AES_GCM_ENC_TEST_VECTORS);
-		test_aead("gcm(aes)", DECRYPT, aes_gcm_dec_tv_template,
+		test_aead("rfc4106(gcm(aes))", DECRYPT, aes_gcm_dec_tv_template,
 			  AES_GCM_DEC_TEST_VECTORS);
 		test_aead("ccm(aes)", ENCRYPT, aes_ccm_enc_tv_template,
 			  AES_CCM_ENC_TEST_VECTORS);
@@ -1566,9 +1566,9 @@ static void do_test(void)
 		break;
 
 	case 35:
-		test_aead("gcm(aes)", ENCRYPT, aes_gcm_enc_tv_template,
+		test_aead("rfc4106(gcm(aes))", ENCRYPT, aes_gcm_enc_tv_template,
 			  AES_GCM_ENC_TEST_VECTORS);
-		test_aead("gcm(aes)", DECRYPT, aes_gcm_dec_tv_template,
+		test_aead("rfc4106(gcm(aes))", DECRYPT, aes_gcm_dec_tv_template,
 			  AES_GCM_DEC_TEST_VECTORS);
 		break;
 
