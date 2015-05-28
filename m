From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6/10] crypto: pcrypt - Add support for new AEAD interface
Date: Thu, 28 May 2015 22:08:00 +0800
Message-ID: <E1YxyTY-0002Kb-Fy@gondolin.me.apana.org.au>
References: <20150528140311.GA8423@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Adrian Hoban <adrian.hoban@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Stephan Mueller <smueller@chronox.de>,
	Timothy McCaffrey <timothy.mccaffrey@unisys.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45147 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633AbbE1OIE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 May 2015 10:08:04 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts pcrypt over to the new AEAD interface.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/pcrypt.c |  135 ++++++++++++++++----------------------------------------
 1 file changed, 40 insertions(+), 95 deletions(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index ff174b6..45e7d51 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -123,14 +123,6 @@ static void pcrypt_aead_serial(struct padata_priv *padata)
 	aead_request_complete(req->base.data, padata->info);
 }
 
-static void pcrypt_aead_giv_serial(struct padata_priv *padata)
-{
-	struct pcrypt_request *preq = pcrypt_padata_request(padata);
-	struct aead_givcrypt_request *req = pcrypt_request_ctx(preq);
-
-	aead_request_complete(req->areq.base.data, padata->info);
-}
-
 static void pcrypt_aead_done(struct crypto_async_request *areq, int err)
 {
 	struct aead_request *req = areq->data;
@@ -176,7 +168,7 @@ static int pcrypt_aead_encrypt(struct aead_request *req)
 				  pcrypt_aead_done, req);
 	aead_request_set_crypt(creq, req->src, req->dst,
 			       req->cryptlen, req->iv);
-	aead_request_set_assoc(creq, req->assoc, req->assoclen);
+	aead_request_set_ad(creq, req->assoclen);
 
 	err = pcrypt_do_parallel(padata, &ctx->cb_cpu, &pencrypt);
 	if (!err)
@@ -218,7 +210,7 @@ static int pcrypt_aead_decrypt(struct aead_request *req)
 				  pcrypt_aead_done, req);
 	aead_request_set_crypt(creq, req->src, req->dst,
 			       req->cryptlen, req->iv);
-	aead_request_set_assoc(creq, req->assoc, req->assoclen);
+	aead_request_set_ad(creq, req->assoclen);
 
 	err = pcrypt_do_parallel(padata, &ctx->cb_cpu, &pdecrypt);
 	if (!err)
@@ -227,56 +219,12 @@ static int pcrypt_aead_decrypt(struct aead_request *req)
 	return err;
 }
 
-static void pcrypt_aead_givenc(struct padata_priv *padata)
-{
-	struct pcrypt_request *preq = pcrypt_padata_request(padata);
-	struct aead_givcrypt_request *req = pcrypt_request_ctx(preq);
-
-	padata->info = crypto_aead_givencrypt(req);
-
-	if (padata->info == -EINPROGRESS)
-		return;
-
-	padata_do_serial(padata);
-}
-
-static int pcrypt_aead_givencrypt(struct aead_givcrypt_request *req)
-{
-	int err;
-	struct aead_request *areq = &req->areq;
-	struct pcrypt_request *preq = aead_request_ctx(areq);
-	struct aead_givcrypt_request *creq = pcrypt_request_ctx(preq);
-	struct padata_priv *padata = pcrypt_request_padata(preq);
-	struct crypto_aead *aead = aead_givcrypt_reqtfm(req);
-	struct pcrypt_aead_ctx *ctx = crypto_aead_ctx(aead);
-	u32 flags = aead_request_flags(areq);
-
-	memset(padata, 0, sizeof(struct padata_priv));
-
-	padata->parallel = pcrypt_aead_givenc;
-	padata->serial = pcrypt_aead_giv_serial;
-
-	aead_givcrypt_set_tfm(creq, ctx->child);
-	aead_givcrypt_set_callback(creq, flags & ~CRYPTO_TFM_REQ_MAY_SLEEP,
-				   pcrypt_aead_done, areq);
-	aead_givcrypt_set_crypt(creq, areq->src, areq->dst,
-				areq->cryptlen, areq->iv);
-	aead_givcrypt_set_assoc(creq, areq->assoc, areq->assoclen);
-	aead_givcrypt_set_giv(creq, req->giv, req->seq);
-
-	err = pcrypt_do_parallel(padata, &ctx->cb_cpu, &pencrypt);
-	if (!err)
-		return -EINPROGRESS;
-
-	return err;
-}
-
-static int pcrypt_aead_init_tfm(struct crypto_tfm *tfm)
+static int pcrypt_aead_init_tfm(struct crypto_aead *tfm)
 {
 	int cpu, cpu_index;
-	struct crypto_instance *inst = crypto_tfm_alg_instance(tfm);
-	struct pcrypt_instance_ctx *ictx = crypto_instance_ctx(inst);
-	struct pcrypt_aead_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct aead_instance *inst = aead_alg_instance(tfm);
+	struct pcrypt_instance_ctx *ictx = aead_instance_ctx(inst);
+	struct pcrypt_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct crypto_aead *cipher;
 
 	cpu_index = (unsigned int)atomic_inc_return(&ictx->tfm_count) %
@@ -286,23 +234,22 @@ static int pcrypt_aead_init_tfm(struct crypto_tfm *tfm)
 	for (cpu = 0; cpu < cpu_index; cpu++)
 		ctx->cb_cpu = cpumask_next(ctx->cb_cpu, cpu_online_mask);
 
-	cipher = crypto_spawn_aead(crypto_instance_ctx(inst));
+	cipher = crypto_spawn_aead(&ictx->spawn);
 
 	if (IS_ERR(cipher))
 		return PTR_ERR(cipher);
 
 	ctx->child = cipher;
-	crypto_aead_set_reqsize(__crypto_aead_cast(tfm),
-		sizeof(struct pcrypt_request) +
-		sizeof(struct aead_givcrypt_request) +
-		crypto_aead_reqsize(cipher));
+	crypto_aead_set_reqsize(tfm, sizeof(struct pcrypt_request) +
+				     sizeof(struct aead_request) +
+				     crypto_aead_reqsize(cipher));
 
 	return 0;
 }
 
-static void pcrypt_aead_exit_tfm(struct crypto_tfm *tfm)
+static void pcrypt_aead_exit_tfm(struct crypto_aead *tfm)
 {
-	struct pcrypt_aead_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct pcrypt_aead_ctx *ctx = crypto_aead_ctx(tfm);
 
 	crypto_free_aead(ctx->child);
 }
@@ -323,78 +270,76 @@ static int pcrypt_init_instance(struct crypto_instance *inst,
 	return 0;
 }
 
-static struct crypto_instance *pcrypt_alloc_aead(struct rtattr **tb,
-						 u32 type, u32 mask)
+static int pcrypt_create_aead(struct crypto_template *tmpl, struct rtattr **tb,
+			      u32 type, u32 mask)
 {
 	struct pcrypt_instance_ctx *ctx;
-	struct crypto_instance *inst;
-	struct crypto_alg *alg;
+	struct aead_instance *inst;
+	struct aead_alg *alg;
 	const char *name;
 	int err;
 
 	name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(name))
-		return ERR_CAST(name);
+		return PTR_ERR(name);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 
-	ctx = crypto_instance_ctx(inst);
-	crypto_set_aead_spawn(&ctx->spawn, inst);
+	ctx = aead_instance_ctx(inst);
+	crypto_set_aead_spawn(&ctx->spawn, aead_crypto_instance(inst));
 
 	err = crypto_grab_aead(&ctx->spawn, name, 0, 0);
 	if (err)
 		goto out_free_inst;
 
-	alg = crypto_aead_spawn_alg(&ctx->spawn);
-	err = pcrypt_init_instance(inst, alg);
+	alg = crypto_spawn_aead_alg(&ctx->spawn);
+	err = pcrypt_init_instance(aead_crypto_instance(inst), &alg->base);
 	if (err)
 		goto out_drop_aead;
 
-	inst->alg.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC;
-	inst->alg.cra_type = &crypto_aead_type;
+	inst->alg.ivsize = crypto_aead_alg_ivsize(alg);
+	inst->alg.maxauthsize = crypto_aead_alg_maxauthsize(alg);
 
-	inst->alg.cra_aead.ivsize = alg->cra_aead.ivsize;
-	inst->alg.cra_aead.geniv = alg->cra_aead.geniv;
-	inst->alg.cra_aead.maxauthsize = alg->cra_aead.maxauthsize;
+	inst->alg.base.cra_ctxsize = sizeof(struct pcrypt_aead_ctx);
 
-	inst->alg.cra_ctxsize = sizeof(struct pcrypt_aead_ctx);
+	inst->alg.init = pcrypt_aead_init_tfm;
+	inst->alg.exit = pcrypt_aead_exit_tfm;
 
-	inst->alg.cra_init = pcrypt_aead_init_tfm;
-	inst->alg.cra_exit = pcrypt_aead_exit_tfm;
+	inst->alg.setkey = pcrypt_aead_setkey;
+	inst->alg.setauthsize = pcrypt_aead_setauthsize;
+	inst->alg.encrypt = pcrypt_aead_encrypt;
+	inst->alg.decrypt = pcrypt_aead_decrypt;
 
-	inst->alg.cra_aead.setkey = pcrypt_aead_setkey;
-	inst->alg.cra_aead.setauthsize = pcrypt_aead_setauthsize;
-	inst->alg.cra_aead.encrypt = pcrypt_aead_encrypt;
-	inst->alg.cra_aead.decrypt = pcrypt_aead_decrypt;
-	inst->alg.cra_aead.givencrypt = pcrypt_aead_givencrypt;
+	err = aead_register_instance(tmpl, inst);
+	if (err)
+		goto out_drop_aead;
 
 out:
-	return inst;
+	return err;
 
 out_drop_aead:
 	crypto_drop_aead(&ctx->spawn);
 out_free_inst:
 	kfree(inst);
-	inst = ERR_PTR(err);
 	goto out;
 }
 
-static struct crypto_instance *pcrypt_alloc(struct rtattr **tb)
+static int pcrypt_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	struct crypto_attr_type *algt;
 
 	algt = crypto_get_attr_type(tb);
 	if (IS_ERR(algt))
-		return ERR_CAST(algt);
+		return PTR_ERR(algt);
 
 	switch (algt->type & algt->mask & CRYPTO_ALG_TYPE_MASK) {
 	case CRYPTO_ALG_TYPE_AEAD:
-		return pcrypt_alloc_aead(tb, algt->type, algt->mask);
+		return pcrypt_create_aead(tmpl, tb, algt->type, algt->mask);
 	}
 
-	return ERR_PTR(-EINVAL);
+	return -EINVAL;
 }
 
 static void pcrypt_free(struct crypto_instance *inst)
@@ -516,7 +461,7 @@ static void pcrypt_fini_padata(struct padata_pcrypt *pcrypt)
 
 static struct crypto_template pcrypt_tmpl = {
 	.name = "pcrypt",
-	.alloc = pcrypt_alloc,
+	.create = pcrypt_create,
 	.free = pcrypt_free,
 	.module = THIS_MODULE,
 };
