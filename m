From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 9/10] crypto: cryptd - Convert to new AEAD interface
Date: Thu, 28 May 2015 22:08:04 +0800
Message-ID: <E1YxyTc-0002LQ-KP@gondolin.me.apana.org.au>
References: <20150528140311.GA8423@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Adrian Hoban <adrian.hoban@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Stephan Mueller <smueller@chronox.de>,
	Timothy McCaffrey <timothy.mccaffrey@unisys.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47386 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917AbbE1OII (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 May 2015 10:08:08 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts cryptd to the new AEAD interface.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/cryptd.c |   64 +++++++++++++++++++++++++-------------------------------
 1 file changed, 29 insertions(+), 35 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 74c4dcb..22ba81f 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -743,28 +743,26 @@ static int cryptd_aead_decrypt_enqueue(struct aead_request *req)
 	return cryptd_aead_enqueue(req, cryptd_aead_decrypt );
 }
 
-static int cryptd_aead_init_tfm(struct crypto_tfm *tfm)
+static int cryptd_aead_init_tfm(struct crypto_aead *tfm)
 {
-	struct crypto_instance *inst = crypto_tfm_alg_instance(tfm);
-	struct aead_instance_ctx *ictx = crypto_instance_ctx(inst);
+	struct aead_instance *inst = aead_alg_instance(tfm);
+	struct aead_instance_ctx *ictx = aead_instance_ctx(inst);
 	struct crypto_aead_spawn *spawn = &ictx->aead_spawn;
-	struct cryptd_aead_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct cryptd_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct crypto_aead *cipher;
 
 	cipher = crypto_spawn_aead(spawn);
 	if (IS_ERR(cipher))
 		return PTR_ERR(cipher);
 
-	crypto_aead_set_flags(cipher, CRYPTO_TFM_REQ_MAY_SLEEP);
 	ctx->child = cipher;
-	crypto_aead_set_reqsize(__crypto_aead_cast(tfm),
-				sizeof(struct cryptd_aead_request_ctx));
+	crypto_aead_set_reqsize(tfm, sizeof(struct cryptd_aead_request_ctx));
 	return 0;
 }
 
-static void cryptd_aead_exit_tfm(struct crypto_tfm *tfm)
+static void cryptd_aead_exit_tfm(struct crypto_aead *tfm)
 {
-	struct cryptd_aead_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct cryptd_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	crypto_free_aead(ctx->child);
 }
 
@@ -773,8 +771,8 @@ static int cryptd_create_aead(struct crypto_template *tmpl,
 			      struct cryptd_queue *queue)
 {
 	struct aead_instance_ctx *ctx;
-	struct crypto_instance *inst;
-	struct crypto_alg *alg;
+	struct aead_instance *inst;
+	struct aead_alg *alg;
 	const char *name;
 	u32 type = 0;
 	u32 mask = 0;
@@ -790,38 +788,34 @@ static int cryptd_create_aead(struct crypto_template *tmpl,
 	if (!inst)
 		return -ENOMEM;
 
-	ctx = crypto_instance_ctx(inst);
+	ctx = aead_instance_ctx(inst);
 	ctx->queue = queue;
 
-	crypto_set_aead_spawn(&ctx->aead_spawn, inst);
+	crypto_set_aead_spawn(&ctx->aead_spawn, aead_crypto_instance(inst));
 	err = crypto_grab_aead(&ctx->aead_spawn, name, type, mask);
 	if (err)
 		goto out_free_inst;
 
-	alg = crypto_aead_spawn_alg(&ctx->aead_spawn);
-	err = cryptd_init_instance(inst, alg);
+	alg = crypto_spawn_aead_alg(&ctx->aead_spawn);
+	err = cryptd_init_instance(aead_crypto_instance(inst), &alg->base);
 	if (err)
 		goto out_drop_aead;
 
-	type = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC;
-	if (alg->cra_flags & CRYPTO_ALG_INTERNAL)
-		type |= CRYPTO_ALG_INTERNAL;
-	inst->alg.cra_flags = type;
-	inst->alg.cra_type = alg->cra_type;
-	inst->alg.cra_ctxsize = sizeof(struct cryptd_aead_ctx);
-	inst->alg.cra_init = cryptd_aead_init_tfm;
-	inst->alg.cra_exit = cryptd_aead_exit_tfm;
-	inst->alg.cra_aead.setkey      = cryptd_aead_setkey;
-	inst->alg.cra_aead.setauthsize = cryptd_aead_setauthsize;
-	inst->alg.cra_aead.geniv       = alg->cra_aead.geniv;
-	inst->alg.cra_aead.ivsize      = alg->cra_aead.ivsize;
-	inst->alg.cra_aead.maxauthsize = alg->cra_aead.maxauthsize;
-	inst->alg.cra_aead.encrypt     = cryptd_aead_encrypt_enqueue;
-	inst->alg.cra_aead.decrypt     = cryptd_aead_decrypt_enqueue;
-	inst->alg.cra_aead.givencrypt  = alg->cra_aead.givencrypt;
-	inst->alg.cra_aead.givdecrypt  = alg->cra_aead.givdecrypt;
+	inst->alg.base.cra_flags = CRYPTO_ALG_ASYNC |
+				   (alg->base.cra_flags & CRYPTO_ALG_INTERNAL);
+	inst->alg.base.cra_ctxsize = sizeof(struct cryptd_aead_ctx);
 
-	err = crypto_register_instance(tmpl, inst);
+	inst->alg.ivsize = crypto_aead_alg_ivsize(alg);
+	inst->alg.maxauthsize = crypto_aead_alg_maxauthsize(alg);
+
+	inst->alg.init = cryptd_aead_init_tfm;
+	inst->alg.exit = cryptd_aead_exit_tfm;
+	inst->alg.setkey = cryptd_aead_setkey;
+	inst->alg.setauthsize = cryptd_aead_setauthsize;
+	inst->alg.encrypt = cryptd_aead_encrypt_enqueue;
+	inst->alg.decrypt = cryptd_aead_decrypt_enqueue;
+
+	err = aead_register_instance(tmpl, inst);
 	if (err) {
 out_drop_aead:
 		crypto_drop_aead(&ctx->aead_spawn);
@@ -865,8 +859,8 @@ static void cryptd_free(struct crypto_instance *inst)
 		kfree(ahash_instance(inst));
 		return;
 	case CRYPTO_ALG_TYPE_AEAD:
-		crypto_drop_spawn(&aead_ctx->aead_spawn.base);
-		kfree(inst);
+		crypto_drop_aead(&aead_ctx->aead_spawn);
+		kfree(aead_instance(inst));
 		return;
 	default:
 		crypto_drop_spawn(&ctx->spawn);
