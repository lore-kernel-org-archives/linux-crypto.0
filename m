Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD91224C6
	for <linux-crypto@vger.kernel.org>; Tue, 13 Feb 2024 09:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707815815; cv=none; b=MUMZuR5Y4Bk4FHYDRwr7rdGNwB45fLTY33Cui9bm2GKwNDl8Q65PXGJgmaKHjGEcYW7yep/G0X5aLY/sjq/CALs8wGu+R57cCVWm84mKsun6tUAe4afTkqH6qM+I2iluVXG0Ow/OwW3SjasPC73S835rTQzCoRy5qUKrNowEu8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707815815; c=relaxed/simple;
	bh=KiwcXcBfA4UAn+K6yzRYaiApU0KxeqRj7RS3lPW2JNQ=;
	h=Message-Id:In-Reply-To:References:From:Date:Subject:To; b=uiVCF/GiLosZSN4D/qo58HCYzLB2EY2ZVmFG4uV4Zx5knZ1/W8LtQBISX95A+9fpMpTXHbBbrxuE2ZqdlWNS2AGFoUxG3VrA8R2DJpzCN8KD0N1I7NrteDOwv/VF0lTgEpwZ6x5/6IUrQ9eQOr3v4RUwFy2abG/t6fw7e9l6aC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rZouH-00D1so-38; Tue, 13 Feb 2024 17:16:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 Feb 2024 17:17:03 +0800
Message-Id: <796780bd8213eb74574519edf38743b681391b18.1707815065.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1707815065.git.herbert@gondor.apana.org.au>
References: <cover.1707815065.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Thu, 7 Dec 2023 18:13:38 +0800
Subject: [PATCH 12/15] crypto: cts - Convert from skcipher to lskcipher
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Replace skcipher implementation with lskcipher.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/cts.c | 355 +++++++++++++--------------------------------------
 1 file changed, 89 insertions(+), 266 deletions(-)

diff --git a/crypto/cts.c b/crypto/cts.c
index f5b42156b6c7..4ead59de59c8 100644
--- a/crypto/cts.c
+++ b/crypto/cts.c
@@ -40,166 +40,81 @@
  * rfc3962 includes errata information in its Appendix A.
  */
 
-#include <crypto/algapi.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/err.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/log2.h>
 #include <linux/module.h>
-#include <linux/scatterlist.h>
-#include <crypto/scatterwalk.h>
-#include <linux/slab.h>
-#include <linux/compiler.h>
+#include <linux/string.h>
 
 struct crypto_cts_ctx {
-	struct crypto_skcipher *child;
+	struct crypto_lskcipher *child;
 };
 
-struct crypto_cts_reqctx {
-	struct scatterlist sg[2];
-	unsigned offset;
-	struct skcipher_request subreq;
-};
-
-static inline u8 *crypto_cts_reqctx_space(struct skcipher_request *req)
+static int cts_cbc_encrypt(struct crypto_lskcipher *tfm,
+			   const u8 *src, u8 *dst,
+			   unsigned offset, unsigned lastn, u8 *iv)
 {
-	struct crypto_cts_reqctx *rctx = skcipher_request_ctx(req);
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct crypto_cts_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct crypto_skcipher *child = ctx->child;
+	const unsigned bsize = crypto_lskcipher_blocksize(tfm);
+	u8 d[MAX_CIPHER_BLOCKSIZE * 2];
 
-	return PTR_ALIGN((u8 *)(rctx + 1) + crypto_skcipher_reqsize(child),
-			 crypto_skcipher_alignmask(tfm) + 1);
-}
-
-static int crypto_cts_setkey(struct crypto_skcipher *parent, const u8 *key,
-			     unsigned int keylen)
-{
-	struct crypto_cts_ctx *ctx = crypto_skcipher_ctx(parent);
-	struct crypto_skcipher *child = ctx->child;
-
-	crypto_skcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
-	crypto_skcipher_set_flags(child, crypto_skcipher_get_flags(parent) &
-					 CRYPTO_TFM_REQ_MASK);
-	return crypto_skcipher_setkey(child, key, keylen);
-}
-
-static void cts_cbc_crypt_done(void *data, int err)
-{
-	struct skcipher_request *req = data;
-
-	if (err == -EINPROGRESS)
-		return;
-
-	skcipher_request_complete(req, err);
-}
-
-static int cts_cbc_encrypt(struct skcipher_request *req)
-{
-	struct crypto_cts_reqctx *rctx = skcipher_request_ctx(req);
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct skcipher_request *subreq = &rctx->subreq;
-	int bsize = crypto_skcipher_blocksize(tfm);
-	u8 d[MAX_CIPHER_BLOCKSIZE * 2] __aligned(__alignof__(u32));
-	struct scatterlist *sg;
-	unsigned int offset;
-	int lastn;
-
-	offset = rctx->offset;
-	lastn = req->cryptlen - offset;
-
-	sg = scatterwalk_ffwd(rctx->sg, req->dst, offset - bsize);
-	scatterwalk_map_and_copy(d + bsize, sg, 0, bsize, 0);
+	memcpy(d + bsize, dst + offset - bsize, bsize);
 
 	memset(d, 0, bsize);
-	scatterwalk_map_and_copy(d, req->src, offset, lastn, 0);
+	memcpy(d, src + offset, lastn);
 
-	scatterwalk_map_and_copy(d, sg, 0, bsize + lastn, 1);
+	memcpy(dst + offset - bsize, d, bsize + lastn);
 	memzero_explicit(d, sizeof(d));
 
-	skcipher_request_set_callback(subreq, req->base.flags &
-					      CRYPTO_TFM_REQ_MAY_BACKLOG,
-				      cts_cbc_crypt_done, req);
-	skcipher_request_set_crypt(subreq, sg, sg, bsize, req->iv);
-	return crypto_skcipher_encrypt(subreq);
+	return crypto_lskcipher_encrypt(tfm, dst + offset - bsize,
+					dst + offset - bsize, bsize, iv);
 }
 
-static void crypto_cts_encrypt_done(void *data, int err)
+static int crypto_cts_encrypt(struct crypto_lskcipher *tfm,
+			      const u8 *src, u8 *dst, unsigned nbytes,
+			      u8 *iv, u32 flags)
 {
-	struct skcipher_request *req = data;
+	struct crypto_cts_ctx *ctx = crypto_lskcipher_ctx(tfm);
+	struct crypto_lskcipher *child = ctx->child;
+	unsigned bsize;
+	unsigned len;
+	int err;
 
-	if (err)
-		goto out;
-
-	err = cts_cbc_encrypt(req);
-	if (err == -EINPROGRESS || err == -EBUSY)
-		return;
-
-out:
-	skcipher_request_complete(req, err);
-}
-
-static int crypto_cts_encrypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct crypto_cts_reqctx *rctx = skcipher_request_ctx(req);
-	struct crypto_cts_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct skcipher_request *subreq = &rctx->subreq;
-	int bsize = crypto_skcipher_blocksize(tfm);
-	unsigned int nbytes = req->cryptlen;
-	unsigned int offset;
-
-	skcipher_request_set_tfm(subreq, ctx->child);
+	bsize = crypto_lskcipher_blocksize(child);
 
 	if (nbytes < bsize)
 		return -EINVAL;
 
-	if (nbytes == bsize) {
-		skcipher_request_set_callback(subreq, req->base.flags,
-					      req->base.complete,
-					      req->base.data);
-		skcipher_request_set_crypt(subreq, req->src, req->dst, nbytes,
-					   req->iv);
-		return crypto_skcipher_encrypt(subreq);
-	}
+	if (nbytes == bsize)
+		len = nbytes;
+	else if ((flags & CRYPTO_LSKCIPHER_FLAG_FINAL))
+		len = rounddown(nbytes - 1, bsize);
+	else
+		len = rounddown(nbytes, bsize);
 
-	offset = rounddown(nbytes - 1, bsize);
-	rctx->offset = offset;
+	nbytes -= len;
 
-	skcipher_request_set_callback(subreq, req->base.flags,
-				      crypto_cts_encrypt_done, req);
-	skcipher_request_set_crypt(subreq, req->src, req->dst,
-				   offset, req->iv);
+	err = crypto_lskcipher_encrypt(child, src, dst, len, iv);
+	if (err)
+		return err;
 
-	return crypto_skcipher_encrypt(subreq) ?:
-	       cts_cbc_encrypt(req);
+	if (!(flags & CRYPTO_LSKCIPHER_FLAG_FINAL) || !nbytes)
+		return nbytes;
+
+	return cts_cbc_encrypt(child, src, dst, len, nbytes, iv);
 }
 
-static int cts_cbc_decrypt(struct skcipher_request *req)
+static int cts_cbc_decrypt(struct crypto_lskcipher *tfm,
+			   const u8 *src, u8 *dst,
+			   unsigned offset, unsigned lastn, u8 *iv)
 {
-	struct crypto_cts_reqctx *rctx = skcipher_request_ctx(req);
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct skcipher_request *subreq = &rctx->subreq;
-	int bsize = crypto_skcipher_blocksize(tfm);
-	u8 d[MAX_CIPHER_BLOCKSIZE * 2] __aligned(__alignof__(u32));
-	struct scatterlist *sg;
-	unsigned int offset;
-	u8 *space;
-	int lastn;
-
-	offset = rctx->offset;
-	lastn = req->cryptlen - offset;
-
-	sg = scatterwalk_ffwd(rctx->sg, req->dst, offset - bsize);
+	const unsigned bsize = crypto_lskcipher_blocksize(tfm);
+	u8 d[MAX_CIPHER_BLOCKSIZE * 2];
 
 	/* 1. Decrypt Cn-1 (s) to create Dn */
-	scatterwalk_map_and_copy(d + bsize, sg, 0, bsize, 0);
-	space = crypto_cts_reqctx_space(req);
-	crypto_xor(d + bsize, space, bsize);
+	crypto_xor_cpy(d + bsize, dst + offset - bsize, iv, bsize);
 	/* 2. Pad Cn with zeros at the end to create C of length BB */
 	memset(d, 0, bsize);
-	scatterwalk_map_and_copy(d, req->src, offset, lastn, 0);
+	memcpy(d, src + offset, lastn);
 	/* 3. Exclusive-or Dn with C to create Xn */
 	/* 4. Select the first Ln bytes of Xn to create Pn */
 	crypto_xor(d + bsize, d, lastn);
@@ -208,180 +123,88 @@ static int cts_cbc_decrypt(struct skcipher_request *req)
 	memcpy(d + lastn, d + bsize + lastn, bsize - lastn);
 	/* 6. Decrypt En to create Pn-1 */
 
-	scatterwalk_map_and_copy(d, sg, 0, bsize + lastn, 1);
+	memcpy(dst + offset - bsize, d, bsize + lastn);
 	memzero_explicit(d, sizeof(d));
 
-	skcipher_request_set_callback(subreq, req->base.flags &
-					      CRYPTO_TFM_REQ_MAY_BACKLOG,
-				      cts_cbc_crypt_done, req);
-
-	skcipher_request_set_crypt(subreq, sg, sg, bsize, space);
-	return crypto_skcipher_decrypt(subreq);
+	return crypto_lskcipher_decrypt(tfm, dst + offset - bsize,
+					dst + offset - bsize, bsize, iv);
 }
 
-static void crypto_cts_decrypt_done(void *data, int err)
+static int crypto_cts_decrypt(struct crypto_lskcipher *tfm,
+			      const u8 *src, u8 *dst, unsigned nbytes,
+			      u8 *iv, u32 flags)
 {
-	struct skcipher_request *req = data;
 
-	if (err)
-		goto out;
+	struct crypto_cts_ctx *ctx = crypto_lskcipher_ctx(tfm);
+	struct crypto_lskcipher *child = ctx->child;
+	u8 d[MAX_CIPHER_BLOCKSIZE * 2];
+	unsigned bsize;
+	unsigned len;
+	int err;
 
-	err = cts_cbc_decrypt(req);
-	if (err == -EINPROGRESS || err == -EBUSY)
-		return;
-
-out:
-	skcipher_request_complete(req, err);
-}
-
-static int crypto_cts_decrypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct crypto_cts_reqctx *rctx = skcipher_request_ctx(req);
-	struct crypto_cts_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct skcipher_request *subreq = &rctx->subreq;
-	int bsize = crypto_skcipher_blocksize(tfm);
-	unsigned int nbytes = req->cryptlen;
-	unsigned int offset;
-	u8 *space;
-
-	skcipher_request_set_tfm(subreq, ctx->child);
+	bsize = crypto_lskcipher_blocksize(child);
 
 	if (nbytes < bsize)
 		return -EINVAL;
 
-	if (nbytes == bsize) {
-		skcipher_request_set_callback(subreq, req->base.flags,
-					      req->base.complete,
-					      req->base.data);
-		skcipher_request_set_crypt(subreq, req->src, req->dst, nbytes,
-					   req->iv);
-		return crypto_skcipher_decrypt(subreq);
-	}
+	if (nbytes == bsize)
+		len = nbytes;
+	else if ((flags & CRYPTO_LSKCIPHER_FLAG_FINAL)) {
+		len = rounddown(nbytes - 1, bsize);
 
-	skcipher_request_set_callback(subreq, req->base.flags,
-				      crypto_cts_decrypt_done, req);
+		if (len <= bsize)
+			memcpy(d, iv, bsize);
+		else
+			memcpy(d, src + len - 2 * bsize, bsize);
+	} else
+		len = rounddown(nbytes, bsize);
 
-	space = crypto_cts_reqctx_space(req);
+	nbytes -= len;
 
-	offset = rounddown(nbytes - 1, bsize);
-	rctx->offset = offset;
+	err = crypto_lskcipher_decrypt(child, src, dst, len, iv);
+	if (err)
+		return err;
 
-	if (offset <= bsize)
-		memcpy(space, req->iv, bsize);
-	else
-		scatterwalk_map_and_copy(space, req->src, offset - 2 * bsize,
-					 bsize, 0);
+	if (!(flags & CRYPTO_LSKCIPHER_FLAG_FINAL) || !nbytes)
+		return nbytes;
 
-	skcipher_request_set_crypt(subreq, req->src, req->dst,
-				   offset, req->iv);
+	memcpy(iv, d, bsize);
+	memzero_explicit(d, sizeof(d));
 
-	return crypto_skcipher_decrypt(subreq) ?:
-	       cts_cbc_decrypt(req);
-}
-
-static int crypto_cts_init_tfm(struct crypto_skcipher *tfm)
-{
-	struct skcipher_instance *inst = skcipher_alg_instance(tfm);
-	struct crypto_skcipher_spawn *spawn = skcipher_instance_ctx(inst);
-	struct crypto_cts_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct crypto_skcipher *cipher;
-	unsigned reqsize;
-	unsigned bsize;
-	unsigned align;
-
-	cipher = crypto_spawn_skcipher(spawn);
-	if (IS_ERR(cipher))
-		return PTR_ERR(cipher);
-
-	ctx->child = cipher;
-
-	align = crypto_skcipher_alignmask(tfm);
-	bsize = crypto_skcipher_blocksize(cipher);
-	reqsize = ALIGN(sizeof(struct crypto_cts_reqctx) +
-			crypto_skcipher_reqsize(cipher),
-			crypto_tfm_ctx_alignment()) +
-		  (align & ~(crypto_tfm_ctx_alignment() - 1)) + bsize;
-
-	crypto_skcipher_set_reqsize(tfm, reqsize);
-
-	return 0;
-}
-
-static void crypto_cts_exit_tfm(struct crypto_skcipher *tfm)
-{
-	struct crypto_cts_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	crypto_free_skcipher(ctx->child);
-}
-
-static void crypto_cts_free(struct skcipher_instance *inst)
-{
-	crypto_drop_skcipher(skcipher_instance_ctx(inst));
-	kfree(inst);
+	return cts_cbc_decrypt(child, src, dst, len, nbytes, iv);
 }
 
 static int crypto_cts_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
-	struct crypto_skcipher_spawn *spawn;
-	struct skcipher_alg_common *alg;
-	struct skcipher_instance *inst;
-	u32 mask;
+	struct lskcipher_instance *inst;
+	struct lskcipher_alg *alg;
 	int err;
 
-	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SKCIPHER, &mask);
-	if (err)
-		return err;
+	inst = lskcipher_alloc_instance_simple(tmpl, tb);
+	if (IS_ERR(inst))
+		return PTR_ERR(inst);
 
-	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
-	if (!inst)
-		return -ENOMEM;
-
-	spawn = skcipher_instance_ctx(inst);
-
-	err = crypto_grab_skcipher(spawn, skcipher_crypto_instance(inst),
-				   crypto_attr_alg_name(tb[1]), 0, mask);
-	if (err)
-		goto err_free_inst;
-
-	alg = crypto_spawn_skcipher_alg_common(spawn);
+	alg = &inst->alg;
 
 	err = -EINVAL;
-	if (alg->ivsize != alg->base.cra_blocksize)
+	if (alg->co.ivsize != alg->co.base.cra_blocksize)
 		goto err_free_inst;
 
-	if (strncmp(alg->base.cra_name, "cbc(", 4))
+	if (strncmp(alg->co.base.cra_name, "cts(cbc(", 8))
 		goto err_free_inst;
 
-	err = crypto_inst_setname(skcipher_crypto_instance(inst), "cts",
-				  &alg->base);
-	if (err)
-		goto err_free_inst;
+	alg->co.base.cra_blocksize = 1;
 
-	inst->alg.base.cra_priority = alg->base.cra_priority;
-	inst->alg.base.cra_blocksize = alg->base.cra_blocksize;
-	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
+	alg->co.chunksize = alg->co.ivsize;
+	alg->co.tailsize = alg->co.ivsize * 2;
 
-	inst->alg.ivsize = alg->base.cra_blocksize;
-	inst->alg.chunksize = alg->chunksize;
-	inst->alg.min_keysize = alg->min_keysize;
-	inst->alg.max_keysize = alg->max_keysize;
+	alg->encrypt = crypto_cts_encrypt;
+	alg->decrypt = crypto_cts_decrypt;
 
-	inst->alg.base.cra_ctxsize = sizeof(struct crypto_cts_ctx);
-
-	inst->alg.init = crypto_cts_init_tfm;
-	inst->alg.exit = crypto_cts_exit_tfm;
-
-	inst->alg.setkey = crypto_cts_setkey;
-	inst->alg.encrypt = crypto_cts_encrypt;
-	inst->alg.decrypt = crypto_cts_decrypt;
-
-	inst->free = crypto_cts_free;
-
-	err = skcipher_register_instance(tmpl, inst);
+	err = lskcipher_register_instance(tmpl, inst);
 	if (err) {
 err_free_inst:
-		crypto_cts_free(inst);
+		inst->free(inst);
 	}
 	return err;
 }
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

