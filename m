From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH v2 2/3] crypto: use ECB to implement CBC decryption
Date: Tue, 25 Feb 2014 08:34:19 +0100
Message-ID: <1393313660-5258-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1393313660-5258-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:64763 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaBYHe3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Feb 2014 02:34:29 -0500
Received: by mail-wg0-f46.google.com with SMTP id z12so17181wgg.5
        for <linux-crypto@vger.kernel.org>; Mon, 24 Feb 2014 23:34:27 -0800 (PST)
In-Reply-To: <1393313660-5258-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch updates the generic CBC implementation so it attempts to use ECB
rather than the core cipher if the available ECB implementation is not the
generic one. This enables the use ECB implementations that are faster but
only if they are allowed to operate on multiple blocks at once.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/cbc.c | 234 +++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 221 insertions(+), 13 deletions(-)

diff --git a/crypto/cbc.c b/crypto/cbc.c
index 61ac42e1e32b..7fa22ea155c8 100644
--- a/crypto/cbc.c
+++ b/crypto/cbc.c
@@ -11,6 +11,7 @@
  */
 
 #include <crypto/algapi.h>
+#include <crypto/internal/skcipher.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -19,15 +20,23 @@
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
 
+struct cbc_instance_ctx {
+	struct crypto_spawn cipher;
+	struct crypto_skcipher_spawn ecb;
+	int have_ecb;
+};
+
 struct crypto_cbc_ctx {
-	struct crypto_cipher *child;
+	struct crypto_cipher *cipher;
+	struct crypto_ablkcipher *ecb;
 };
 
 static int crypto_cbc_setkey(struct crypto_tfm *parent, const u8 *key,
 			     unsigned int keylen)
 {
 	struct crypto_cbc_ctx *ctx = crypto_tfm_ctx(parent);
-	struct crypto_cipher *child = ctx->child;
+	struct crypto_cipher *child = ctx->cipher;
+	struct crypto_ablkcipher *ecb = ctx->ecb;
 	int err;
 
 	crypto_cipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
@@ -36,6 +45,17 @@ static int crypto_cbc_setkey(struct crypto_tfm *parent, const u8 *key,
 	err = crypto_cipher_setkey(child, key, keylen);
 	crypto_tfm_set_flags(parent, crypto_cipher_get_flags(child) &
 				     CRYPTO_TFM_RES_MASK);
+
+	if (err || !ecb)
+		return err;
+
+	crypto_ablkcipher_clear_flags(ecb, CRYPTO_TFM_REQ_MASK);
+	crypto_ablkcipher_set_flags(ecb, crypto_tfm_get_flags(parent) &
+					 CRYPTO_TFM_REQ_MASK);
+	err = crypto_ablkcipher_setkey(ecb, key, keylen);
+	crypto_tfm_set_flags(parent, crypto_ablkcipher_get_flags(ecb) &
+				     CRYPTO_TFM_RES_MASK);
+
 	return err;
 }
 
@@ -94,7 +114,7 @@ static int crypto_cbc_encrypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	struct crypto_blkcipher *tfm = desc->tfm;
 	struct crypto_cbc_ctx *ctx = crypto_blkcipher_ctx(tfm);
-	struct crypto_cipher *child = ctx->child;
+	struct crypto_cipher *child = ctx->cipher;
 	int err;
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
@@ -173,7 +193,7 @@ static int crypto_cbc_decrypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	struct crypto_blkcipher *tfm = desc->tfm;
 	struct crypto_cbc_ctx *ctx = crypto_blkcipher_ctx(tfm);
-	struct crypto_cipher *child = ctx->child;
+	struct crypto_cipher *child = ctx->cipher;
 	int err;
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
@@ -190,37 +210,175 @@ static int crypto_cbc_decrypt(struct blkcipher_desc *desc,
 	return err;
 }
 
+static int crypto_cbc_decrypt_chunked_inplace(struct blkcipher_desc *desc,
+					      struct blkcipher_walk *walk,
+					      int bsize, int csize,
+					      int seglen)
+{
+	struct crypto_cbc_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct {
+		struct ablkcipher_request req;
+		u8 priv[crypto_ablkcipher_reqsize(ctx->ecb)];
+	} ecb_req;
+	struct scatterlist out;
+	u8 *src = walk->src.virt.addr;
+	u8 *iv = walk->iv;
+	u8 buf[2][csize];
+	int err;
+	int i;
+
+	ablkcipher_request_set_tfm(&ecb_req.req, ctx->ecb);
+	ablkcipher_request_set_crypt(&ecb_req.req, &out, &out, csize, NULL);
+
+	for (i = 0; seglen > 0; seglen -= csize, src += csize, i = !i) {
+		memcpy(buf[i], src, csize);
+		sg_init_one(&out, src, csize);
+
+		err = crypto_ablkcipher_decrypt(&ecb_req.req);
+		if (err)
+			return err;
+
+		if (iv + bsize == buf[i]) {
+			crypto_xor(src, iv, csize);
+		} else {
+			crypto_xor(src, iv, bsize);
+			crypto_xor(src + bsize, buf[i], csize - bsize);
+		}
+		iv = buf[i] + csize - bsize;
+	}
+	memcpy(walk->iv, iv, bsize);
+	return 0;
+}
+
+static int crypto_cbc_decrypt_chunked_segment(struct blkcipher_desc *desc,
+					      struct blkcipher_walk *walk,
+					      int bsize, int seglen)
+{
+	struct crypto_cbc_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct {
+		struct ablkcipher_request req;
+		u8 priv[crypto_ablkcipher_reqsize(ctx->ecb)];
+	} ecb_req;
+	struct scatterlist out, in;
+	int err;
+
+	sg_init_one(&out, walk->dst.virt.addr, seglen);
+	sg_init_one(&in, walk->src.virt.addr, seglen);
+
+	ablkcipher_request_set_tfm(&ecb_req.req, ctx->ecb);
+	ablkcipher_request_set_crypt(&ecb_req.req, &in, &out, seglen, NULL);
+
+	err = crypto_ablkcipher_decrypt(&ecb_req.req);
+	if (err)
+		return err;
+
+	crypto_xor(walk->dst.virt.addr, walk->iv, bsize);
+	crypto_xor(walk->dst.virt.addr + bsize, walk->src.virt.addr,
+		   seglen - bsize);
+	memcpy(walk->iv, walk->src.virt.addr + seglen - bsize, bsize);
+	return 0;
+}
+
+#define CHUNKS	8
+
+static int crypto_cbc_decrypt_chunked(struct blkcipher_desc *desc,
+				      struct scatterlist *dst,
+				      struct scatterlist *src,
+				      unsigned int nbytes)
+{
+	struct crypto_cbc_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct crypto_cipher *child = ctx->cipher;
+	int bsize = crypto_cipher_blocksize(ctx->cipher);
+	struct blkcipher_walk walk;
+	int csize = CHUNKS * bsize;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt_block(desc, &walk, csize);
+
+	while (walk.nbytes >= csize) {
+		int seglen = walk.nbytes & ~(csize - 1);
+
+		if (walk.src.virt.addr == walk.dst.virt.addr)
+			err = crypto_cbc_decrypt_chunked_inplace(desc, &walk,
+								 bsize, csize,
+								 seglen);
+		else
+			err = crypto_cbc_decrypt_chunked_segment(desc, &walk,
+								 bsize, seglen);
+		if (err)
+			return err;
+		err = blkcipher_walk_done(desc, &walk, walk.nbytes - seglen);
+	}
+	if ((nbytes = walk.nbytes)) {
+		if (walk.src.virt.addr == walk.dst.virt.addr)
+			nbytes = crypto_cbc_decrypt_inplace(desc, &walk, child);
+		else
+			nbytes = crypto_cbc_decrypt_segment(desc, &walk, child);
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+	return err;
+}
+
 static int crypto_cbc_init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_instance *inst = (void *)tfm->__crt_alg;
-	struct crypto_spawn *spawn = crypto_instance_ctx(inst);
+	struct cbc_instance_ctx *ictx = crypto_instance_ctx(inst);
 	struct crypto_cbc_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct crypto_cipher *cipher;
+	int err;
 
-	cipher = crypto_spawn_cipher(spawn);
+	cipher = crypto_spawn_cipher(&ictx->cipher);
 	if (IS_ERR(cipher))
 		return PTR_ERR(cipher);
 
-	ctx->child = cipher;
+	if (ictx->have_ecb) {
+		struct crypto_ablkcipher *ecb;
+
+		ecb = crypto_spawn_skcipher(&ictx->ecb);
+		err = PTR_ERR(ecb);
+		if (IS_ERR(ecb))
+			goto err_free_cipher;
+		ctx->ecb = ecb;
+	}
+	ctx->cipher = cipher;
 	return 0;
+
+err_free_cipher:
+	crypto_free_cipher(cipher);
+	return err;
 }
 
 static void crypto_cbc_exit_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_cbc_ctx *ctx = crypto_tfm_ctx(tfm);
-	crypto_free_cipher(ctx->child);
+
+	crypto_free_cipher(ctx->cipher);
+	if (ctx->ecb)
+		crypto_free_ablkcipher(ctx->ecb);
 }
 
 static struct crypto_instance *crypto_cbc_alloc(struct rtattr **tb)
 {
 	struct crypto_instance *inst;
 	struct crypto_alg *alg;
+	struct cbc_instance_ctx *ictx;
+	const char *cipher_name;
+	char ecb_name[CRYPTO_MAX_ALG_NAME];
 	int err;
 
 	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_BLKCIPHER);
 	if (err)
 		return ERR_PTR(err);
 
+	cipher_name = crypto_attr_alg_name(tb[1]);
+	if (IS_ERR(cipher_name))
+		return ERR_CAST(cipher_name);
+
+	if (snprintf(ecb_name, CRYPTO_MAX_ALG_NAME, "ecb(%s)",
+		     cipher_name) >= CRYPTO_MAX_ALG_NAME)
+		return ERR_PTR(-ENAMETOOLONG);
+
 	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
 				  CRYPTO_ALG_TYPE_MASK);
 	if (IS_ERR(alg))
@@ -230,9 +388,21 @@ static struct crypto_instance *crypto_cbc_alloc(struct rtattr **tb)
 	if (!is_power_of_2(alg->cra_blocksize))
 		goto out_put_alg;
 
-	inst = crypto_alloc_instance("cbc", alg);
-	if (IS_ERR(inst))
-		goto out_put_alg;
+	inst = kzalloc(sizeof(*inst) + sizeof(*ictx), GFP_KERNEL);
+	err = -ENOMEM;
+	if (!inst)
+		goto out_err;
+
+	err = -ENAMETOOLONG;
+	if (snprintf(inst->alg.cra_name, CRYPTO_MAX_ALG_NAME, "cbc(%s)",
+		     cipher_name) >= CRYPTO_MAX_ALG_NAME)
+		goto err_free_inst;
+
+	ictx = crypto_instance_ctx(inst);
+
+	err = crypto_init_spawn(&ictx->cipher, alg, inst, CRYPTO_ALG_TYPE_MASK);
+	if (err)
+		goto err_free_inst;
 
 	inst->alg.cra_flags = CRYPTO_ALG_TYPE_BLKCIPHER;
 	inst->alg.cra_priority = alg->cra_priority;
@@ -254,16 +424,54 @@ static struct crypto_instance *crypto_cbc_alloc(struct rtattr **tb)
 
 	inst->alg.cra_blkcipher.setkey = crypto_cbc_setkey;
 	inst->alg.cra_blkcipher.encrypt = crypto_cbc_encrypt;
-	inst->alg.cra_blkcipher.decrypt = crypto_cbc_decrypt;
+
+	/*
+	 * If we have an accelerated ecb implementation (i.e., another one than
+	 * 'ecb_generic'), use it to perform CBC decryption in chunks.
+	 */
+	crypto_set_skcipher_spawn(&ictx->ecb, inst);
+	err = crypto_grab_skcipher(&ictx->ecb, ecb_name, 0, CRYPTO_ALG_ASYNC);
+	if (!err) {
+		struct crypto_alg *ecb = crypto_skcipher_spawn_alg(&ictx->ecb);
+
+		if (strncmp(ecb->cra_driver_name, "ecb_generic", 11)) {
+			err = -ENAMETOOLONG;
+			if (snprintf(inst->alg.cra_driver_name, 
+				     CRYPTO_MAX_ALG_NAME, "cbc(%s,%s)",
+				     alg->cra_driver_name, ecb->cra_driver_name)
+			    >= CRYPTO_MAX_ALG_NAME)
+				goto err_drop_ecb;
+
+			inst->alg.cra_alignmask |= ecb->cra_alignmask;
+			ictx->have_ecb = 1;
+		}
+	}
+
+	inst->alg.cra_blkcipher.decrypt = ictx->have_ecb ?
+					  crypto_cbc_decrypt_chunked :
+					  crypto_cbc_decrypt;
 
 out_put_alg:
 	crypto_mod_put(alg);
 	return inst;
+
+err_drop_ecb:
+	crypto_drop_skcipher(&ictx->ecb);
+	crypto_drop_spawn(&ictx->cipher);
+err_free_inst:
+	kfree(inst);
+out_err:
+	inst = ERR_PTR(err);
+	goto out_put_alg;
+
 }
 
 static void crypto_cbc_free(struct crypto_instance *inst)
 {
-	crypto_drop_spawn(crypto_instance_ctx(inst));
+	struct cbc_instance_ctx *ctx = crypto_instance_ctx(inst);
+
+	crypto_drop_spawn(&ctx->cipher);
+	crypto_drop_skcipher(&ctx->ecb);
 	kfree(inst);
 }
 
-- 
1.8.3.2
