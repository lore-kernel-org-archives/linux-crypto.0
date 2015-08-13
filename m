From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/13] crypto: seqiv - Remove AEAD compatibility code
Date: Thu, 13 Aug 2015 17:28:54 +0800
Message-ID: <E1ZPoog-0005pd-QA@gondolin.me.apana.org.au>
References: <20150813092520.GA22268@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57986 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbbHMJ27 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Aug 2015 05:28:59 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1ZPooh-000363-VA
	for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2015 19:28:56 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Now that we no longer have any legacy AEAD implementations the
compatibility code path can no longer be triggered.  This patch
removes it.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/seqiv.c |  127 ---------------------------------------------------------
 1 file changed, 127 deletions(-)

diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index debf8d3..3d8b02b 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -66,32 +66,6 @@ static void seqiv_complete(struct crypto_async_request *base, int err)
 	skcipher_givcrypt_complete(req, err);
 }
 
-static void seqiv_aead_complete2(struct aead_givcrypt_request *req, int err)
-{
-	struct aead_request *subreq = aead_givcrypt_reqctx(req);
-	struct crypto_aead *geniv;
-
-	if (err == -EINPROGRESS)
-		return;
-
-	if (err)
-		goto out;
-
-	geniv = aead_givcrypt_reqtfm(req);
-	memcpy(req->areq.iv, subreq->iv, crypto_aead_ivsize(geniv));
-
-out:
-	kfree(subreq->iv);
-}
-
-static void seqiv_aead_complete(struct crypto_async_request *base, int err)
-{
-	struct aead_givcrypt_request *req = base->data;
-
-	seqiv_aead_complete2(req, err);
-	aead_givcrypt_complete(req, err);
-}
-
 static void seqiv_aead_encrypt_complete2(struct aead_request *req, int err)
 {
 	struct aead_request *subreq = aead_request_ctx(req);
@@ -178,52 +152,6 @@ static int seqiv_givencrypt(struct skcipher_givcrypt_request *req)
 	return err;
 }
 
-static int seqiv_aead_givencrypt(struct aead_givcrypt_request *req)
-{
-	struct crypto_aead *geniv = aead_givcrypt_reqtfm(req);
-	struct seqiv_ctx *ctx = crypto_aead_ctx(geniv);
-	struct aead_request *areq = &req->areq;
-	struct aead_request *subreq = aead_givcrypt_reqctx(req);
-	crypto_completion_t compl;
-	void *data;
-	u8 *info;
-	unsigned int ivsize;
-	int err;
-
-	aead_request_set_tfm(subreq, aead_geniv_base(geniv));
-
-	compl = areq->base.complete;
-	data = areq->base.data;
-	info = areq->iv;
-
-	ivsize = crypto_aead_ivsize(geniv);
-
-	if (unlikely(!IS_ALIGNED((unsigned long)info,
-				 crypto_aead_alignmask(geniv) + 1))) {
-		info = kmalloc(ivsize, areq->base.flags &
-				       CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL:
-								  GFP_ATOMIC);
-		if (!info)
-			return -ENOMEM;
-
-		compl = seqiv_aead_complete;
-		data = req;
-	}
-
-	aead_request_set_callback(subreq, areq->base.flags, compl, data);
-	aead_request_set_crypt(subreq, areq->src, areq->dst, areq->cryptlen,
-			       info);
-	aead_request_set_assoc(subreq, areq->assoc, areq->assoclen);
-
-	seqiv_geniv(ctx, info, req->seq, ivsize);
-	memcpy(req->giv, info, ivsize);
-
-	err = crypto_aead_encrypt(subreq);
-	if (unlikely(info != areq->iv))
-		seqiv_aead_complete2(req, err);
-	return err;
-}
-
 static int seqiv_aead_encrypt(struct aead_request *req)
 {
 	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
@@ -330,27 +258,6 @@ static int seqiv_init(struct crypto_tfm *tfm)
 	return err ?: skcipher_geniv_init(tfm);
 }
 
-static int seqiv_old_aead_init(struct crypto_tfm *tfm)
-{
-	struct crypto_aead *geniv = __crypto_aead_cast(tfm);
-	struct seqiv_ctx *ctx = crypto_aead_ctx(geniv);
-	int err;
-
-	spin_lock_init(&ctx->lock);
-
-	crypto_aead_set_reqsize(__crypto_aead_cast(tfm),
-				sizeof(struct aead_request));
-	err = 0;
-	if (!crypto_get_default_rng()) {
-		geniv->givencrypt = seqiv_aead_givencrypt;
-		err = crypto_rng_get_bytes(crypto_default_rng, ctx->salt,
-					   crypto_aead_ivsize(geniv));
-		crypto_put_default_rng();
-	}
-
-	return err ?: aead_geniv_init(tfm);
-}
-
 static int seqiv_aead_init_common(struct crypto_aead *geniv,
 				  unsigned int reqsize)
 {
@@ -439,33 +346,6 @@ free_inst:
 	goto out;
 }
 
-static int seqiv_old_aead_create(struct crypto_template *tmpl,
-				 struct aead_instance *aead)
-{
-	struct crypto_instance *inst = aead_crypto_instance(aead);
-	int err = -EINVAL;
-
-	if (inst->alg.cra_aead.ivsize < sizeof(u64))
-		goto free_inst;
-
-	inst->alg.cra_init = seqiv_old_aead_init;
-	inst->alg.cra_exit = aead_geniv_exit;
-
-	inst->alg.cra_ctxsize = inst->alg.cra_aead.ivsize;
-	inst->alg.cra_ctxsize += sizeof(struct seqiv_ctx);
-
-	err = crypto_register_instance(tmpl, inst);
-	if (err)
-		goto free_inst;
-
-out:
-	return err;
-
-free_inst:
-	aead_geniv_free(aead);
-	goto out;
-}
-
 static int seqiv_aead_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	struct aead_instance *inst;
@@ -480,15 +360,9 @@ static int seqiv_aead_create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	inst->alg.base.cra_alignmask |= __alignof__(u32) - 1;
 
-	if (inst->alg.base.cra_aead.encrypt)
-		return seqiv_old_aead_create(tmpl, inst);
-
 	spawn = aead_instance_ctx(inst);
 	alg = crypto_spawn_aead_alg(spawn);
 
-	if (alg->base.cra_aead.encrypt)
-		goto done;
-
 	err = -EINVAL;
 	if (inst->alg.ivsize != sizeof(u64))
 		goto free_inst;
@@ -502,7 +376,6 @@ static int seqiv_aead_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.base.cra_ctxsize = sizeof(struct seqiv_aead_ctx);
 	inst->alg.base.cra_ctxsize += inst->alg.ivsize;
 
-done:
 	err = aead_register_instance(tmpl, inst);
 	if (err)
 		goto free_inst;
