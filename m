From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/13] crypto: seqiv - Remove seqniv
Date: Thu, 13 Aug 2015 17:28:53 +0800
Message-ID: <E1ZPoof-0005pM-Cb@gondolin.me.apana.org.au>
References: <20150813092520.GA22268@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43304 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbbHMJ25 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Aug 2015 05:28:57 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1ZPoog-00035m-2q
	for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2015 19:28:54 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Now that IPsec no longer uses seqniv we can remove it.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/seqiv.c |  245 ---------------------------------------------------------
 1 file changed, 1 insertion(+), 244 deletions(-)

diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index 45d0563..debf8d3 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -26,11 +26,6 @@
 #include <linux/spinlock.h>
 #include <linux/string.h>
 
-struct seqniv_request_ctx {
-	struct scatterlist dst[2];
-	struct aead_request subreq;
-};
-
 struct seqiv_ctx {
 	spinlock_t lock;
 	u8 salt[] __attribute__ ((aligned(__alignof__(u32))));
@@ -124,50 +119,6 @@ static void seqiv_aead_encrypt_complete(struct crypto_async_request *base,
 	aead_request_complete(req, err);
 }
 
-static void seqniv_aead_encrypt_complete2(struct aead_request *req, int err)
-{
-	unsigned int ivsize = 8;
-	u8 data[20];
-
-	if (err == -EINPROGRESS)
-		return;
-
-	/* Swap IV and ESP header back to correct order. */
-	scatterwalk_map_and_copy(data, req->dst, 0, req->assoclen + ivsize, 0);
-	scatterwalk_map_and_copy(data + ivsize, req->dst, 0, req->assoclen, 1);
-	scatterwalk_map_and_copy(data, req->dst, req->assoclen, ivsize, 1);
-}
-
-static void seqniv_aead_encrypt_complete(struct crypto_async_request *base,
-					int err)
-{
-	struct aead_request *req = base->data;
-
-	seqniv_aead_encrypt_complete2(req, err);
-	aead_request_complete(req, err);
-}
-
-static void seqniv_aead_decrypt_complete2(struct aead_request *req, int err)
-{
-	u8 data[4];
-
-	if (err == -EINPROGRESS)
-		return;
-
-	/* Move ESP header back to correct location. */
-	scatterwalk_map_and_copy(data, req->dst, 16, req->assoclen - 8, 0);
-	scatterwalk_map_and_copy(data, req->dst, 8, req->assoclen - 8, 1);
-}
-
-static void seqniv_aead_decrypt_complete(struct crypto_async_request *base,
-					 int err)
-{
-	struct aead_request *req = base->data;
-
-	seqniv_aead_decrypt_complete2(req, err);
-	aead_request_complete(req, err);
-}
-
 static void seqiv_geniv(struct seqiv_ctx *ctx, u8 *info, u64 seq,
 			unsigned int ivsize)
 {
@@ -273,62 +224,6 @@ static int seqiv_aead_givencrypt(struct aead_givcrypt_request *req)
 	return err;
 }
 
-static int seqniv_aead_encrypt(struct aead_request *req)
-{
-	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
-	struct seqiv_aead_ctx *ctx = crypto_aead_ctx(geniv);
-	struct seqniv_request_ctx *rctx = aead_request_ctx(req);
-	struct aead_request *subreq = &rctx->subreq;
-	struct scatterlist *dst;
-	crypto_completion_t compl;
-	void *data;
-	unsigned int ivsize = 8;
-	u8 buf[20] __attribute__ ((aligned(__alignof__(u32))));
-	int err;
-
-	if (req->cryptlen < ivsize)
-		return -EINVAL;
-
-	/* ESP AD is at most 12 bytes (ESN). */
-	if (req->assoclen > 12)
-		return -EINVAL;
-
-	aead_request_set_tfm(subreq, ctx->geniv.child);
-
-	compl = seqniv_aead_encrypt_complete;
-	data = req;
-
-	if (req->src != req->dst) {
-		struct blkcipher_desc desc = {
-			.tfm = ctx->null,
-		};
-
-		err = crypto_blkcipher_encrypt(&desc, req->dst, req->src,
-					       req->assoclen + req->cryptlen);
-		if (err)
-			return err;
-	}
-
-	dst = scatterwalk_ffwd(rctx->dst, req->dst, ivsize);
-
-	aead_request_set_callback(subreq, req->base.flags, compl, data);
-	aead_request_set_crypt(subreq, dst, dst,
-			       req->cryptlen - ivsize, req->iv);
-	aead_request_set_ad(subreq, req->assoclen);
-
-	memcpy(buf, req->iv, ivsize);
-	crypto_xor(buf, ctx->salt, ivsize);
-	memcpy(req->iv, buf, ivsize);
-
-	/* Swap order of IV and ESP AD for ICV generation. */
-	scatterwalk_map_and_copy(buf + ivsize, req->dst, 0, req->assoclen, 0);
-	scatterwalk_map_and_copy(buf, req->dst, 0, req->assoclen + ivsize, 1);
-
-	err = crypto_aead_encrypt(subreq);
-	seqniv_aead_encrypt_complete2(req, err);
-	return err;
-}
-
 static int seqiv_aead_encrypt(struct aead_request *req)
 {
 	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
@@ -387,63 +282,6 @@ static int seqiv_aead_encrypt(struct aead_request *req)
 	return err;
 }
 
-static int seqniv_aead_decrypt(struct aead_request *req)
-{
-	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
-	struct seqiv_aead_ctx *ctx = crypto_aead_ctx(geniv);
-	struct seqniv_request_ctx *rctx = aead_request_ctx(req);
-	struct aead_request *subreq = &rctx->subreq;
-	struct scatterlist *dst;
-	crypto_completion_t compl;
-	void *data;
-	unsigned int ivsize = 8;
-	u8 buf[20];
-	int err;
-
-	if (req->cryptlen < ivsize + crypto_aead_authsize(geniv))
-		return -EINVAL;
-
-	aead_request_set_tfm(subreq, ctx->geniv.child);
-
-	compl = req->base.complete;
-	data = req->base.data;
-
-	if (req->assoclen > 12)
-		return -EINVAL;
-	else if (req->assoclen > 8) {
-		compl = seqniv_aead_decrypt_complete;
-		data = req;
-	}
-
-	if (req->src != req->dst) {
-		struct blkcipher_desc desc = {
-			.tfm = ctx->null,
-		};
-
-		err = crypto_blkcipher_encrypt(&desc, req->dst, req->src,
-					       req->assoclen + req->cryptlen);
-		if (err)
-			return err;
-	}
-
-	/* Move ESP AD forward for ICV generation. */
-	scatterwalk_map_and_copy(buf, req->dst, 0, req->assoclen + ivsize, 0);
-	memcpy(req->iv, buf + req->assoclen, ivsize);
-	scatterwalk_map_and_copy(buf, req->dst, ivsize, req->assoclen, 1);
-
-	dst = scatterwalk_ffwd(rctx->dst, req->dst, ivsize);
-
-	aead_request_set_callback(subreq, req->base.flags, compl, data);
-	aead_request_set_crypt(subreq, dst, dst,
-			       req->cryptlen - ivsize, req->iv);
-	aead_request_set_ad(subreq, req->assoclen);
-
-	err = crypto_aead_decrypt(subreq);
-	if (req->assoclen > 8)
-		seqniv_aead_decrypt_complete2(req, err);
-	return err;
-}
-
 static int seqiv_aead_decrypt(struct aead_request *req)
 {
 	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
@@ -558,11 +396,6 @@ static int seqiv_aead_init(struct crypto_aead *tfm)
 	return seqiv_aead_init_common(tfm, sizeof(struct aead_request));
 }
 
-static int seqniv_aead_init(struct crypto_aead *tfm)
-{
-	return seqiv_aead_init_common(tfm, sizeof(struct seqniv_request_ctx));
-}
-
 static void seqiv_aead_exit(struct crypto_aead *tfm)
 {
 	struct seqiv_aead_ctx *ctx = crypto_aead_ctx(tfm);
@@ -699,58 +532,6 @@ static int seqiv_create(struct crypto_template *tmpl, struct rtattr **tb)
 	return err;
 }
 
-static int seqniv_create(struct crypto_template *tmpl, struct rtattr **tb)
-{
-	struct aead_instance *inst;
-	struct crypto_aead_spawn *spawn;
-	struct aead_alg *alg;
-	int err;
-
-	inst = aead_geniv_alloc(tmpl, tb, 0, 0);
-	err = PTR_ERR(inst);
-	if (IS_ERR(inst))
-		goto out;
-
-	spawn = aead_instance_ctx(inst);
-	alg = crypto_spawn_aead_alg(spawn);
-
-	if (alg->base.cra_aead.encrypt)
-		goto done;
-
-	err = -EINVAL;
-	if (inst->alg.ivsize != sizeof(u64))
-		goto free_inst;
-
-	inst->alg.encrypt = seqniv_aead_encrypt;
-	inst->alg.decrypt = seqniv_aead_decrypt;
-
-	inst->alg.init = seqniv_aead_init;
-	inst->alg.exit = seqiv_aead_exit;
-
-	if ((alg->base.cra_flags & CRYPTO_ALG_AEAD_NEW)) {
-		inst->alg.encrypt = seqiv_aead_encrypt;
-		inst->alg.decrypt = seqiv_aead_decrypt;
-
-		inst->alg.init = seqiv_aead_init;
-	}
-
-	inst->alg.base.cra_alignmask |= __alignof__(u32) - 1;
-	inst->alg.base.cra_ctxsize = sizeof(struct seqiv_aead_ctx);
-	inst->alg.base.cra_ctxsize += inst->alg.ivsize;
-
-done:
-	err = aead_register_instance(tmpl, inst);
-	if (err)
-		goto free_inst;
-
-out:
-	return err;
-
-free_inst:
-	aead_geniv_free(inst);
-	goto out;
-}
-
 static void seqiv_free(struct crypto_instance *inst)
 {
 	if ((inst->alg.cra_flags ^ CRYPTO_ALG_TYPE_AEAD) & CRYPTO_ALG_TYPE_MASK)
@@ -766,36 +547,13 @@ static struct crypto_template seqiv_tmpl = {
 	.module = THIS_MODULE,
 };
 
-static struct crypto_template seqniv_tmpl = {
-	.name = "seqniv",
-	.create = seqniv_create,
-	.free = seqiv_free,
-	.module = THIS_MODULE,
-};
-
 static int __init seqiv_module_init(void)
 {
-	int err;
-
-	err = crypto_register_template(&seqiv_tmpl);
-	if (err)
-		goto out;
-
-	err = crypto_register_template(&seqniv_tmpl);
-	if (err)
-		goto out_undo_niv;
-
-out:
-	return err;
-
-out_undo_niv:
-	crypto_unregister_template(&seqiv_tmpl);
-	goto out;
+	return crypto_register_template(&seqiv_tmpl);
 }
 
 static void __exit seqiv_module_exit(void)
 {
-	crypto_unregister_template(&seqniv_tmpl);
 	crypto_unregister_template(&seqiv_tmpl);
 }
 
@@ -805,4 +563,3 @@ module_exit(seqiv_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Sequence Number IV Generator");
 MODULE_ALIAS_CRYPTO("seqiv");
-MODULE_ALIAS_CRYPTO("seqniv");
