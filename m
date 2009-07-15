From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 28/35] crypto: cryptd - Switch to new style ahash
Date: Wed, 15 Jul 2009 15:16:22 +0800
Message-ID: <E1MQyj0-00051m-Mu@gondolin.me.apana.org.au>
References: <20090715071424.GA19023@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53657 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752643AbZGOHQ3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 03:16:29 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MQyj2-0004uy-5u
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2009 17:16:25 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: cryptd - Switch to new style ahash

This patch changes cryptd to use the new style ahash type.  In
particular, the instance is enlarged to encapsulate the new
ahash_alg structure.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/cryptd.c |   64 ++++++++++++++++++++++++++++++++------------------------
 1 file changed, 37 insertions(+), 27 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index ad58f51..5dabb7d 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -255,17 +255,18 @@ static void cryptd_blkcipher_exit_tfm(struct crypto_tfm *tfm)
 	crypto_free_blkcipher(ctx->child);
 }
 
-static struct crypto_instance *cryptd_alloc_instance(struct crypto_alg *alg,
-						     unsigned int tail)
+static void *cryptd_alloc_instance(struct crypto_alg *alg, unsigned int head,
+				   unsigned int tail)
 {
+	char *p;
 	struct crypto_instance *inst;
 	int err;
 
-	inst = kzalloc(sizeof(*inst) + tail, GFP_KERNEL);
-	if (!inst) {
-		inst = ERR_PTR(-ENOMEM);
-		goto out;
-	}
+	p = kzalloc(head + sizeof(*inst) + tail, GFP_KERNEL);
+	if (!p)
+		return ERR_PTR(-ENOMEM);
+
+	inst = (void *)(p + head);
 
 	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
@@ -279,11 +280,11 @@ static struct crypto_instance *cryptd_alloc_instance(struct crypto_alg *alg,
 	inst->alg.cra_alignmask = alg->cra_alignmask;
 
 out:
-	return inst;
+	return p;
 
 out_free_inst:
-	kfree(inst);
-	inst = ERR_PTR(err);
+	kfree(p);
+	p = ERR_PTR(err);
 	goto out;
 }
 
@@ -301,7 +302,7 @@ static int cryptd_create_blkcipher(struct crypto_template *tmpl,
 	if (IS_ERR(alg))
 		return PTR_ERR(alg);
 
-	inst = cryptd_alloc_instance(alg, sizeof(*ctx));
+	inst = cryptd_alloc_instance(alg, 0, sizeof(*ctx));
 	if (IS_ERR(inst))
 		goto out_put_alg;
 
@@ -509,7 +510,7 @@ static int cryptd_create_hash(struct crypto_template *tmpl, struct rtattr **tb,
 			      struct cryptd_queue *queue)
 {
 	struct hashd_instance_ctx *ctx;
-	struct crypto_instance *inst;
+	struct ahash_instance *inst;
 	struct shash_alg *salg;
 	struct crypto_alg *alg;
 	int err;
@@ -519,33 +520,34 @@ static int cryptd_create_hash(struct crypto_template *tmpl, struct rtattr **tb,
 		return PTR_ERR(salg);
 
 	alg = &salg->base;
-	inst = cryptd_alloc_instance(alg, sizeof(*ctx));
+	inst = cryptd_alloc_instance(alg, ahash_instance_headroom(),
+				     sizeof(*ctx));
 	if (IS_ERR(inst))
 		goto out_put_alg;
 
-	ctx = crypto_instance_ctx(inst);
+	ctx = ahash_instance_ctx(inst);
 	ctx->queue = queue;
 
-	err = crypto_init_shash_spawn(&ctx->spawn, salg, inst);
+	err = crypto_init_shash_spawn(&ctx->spawn, salg,
+				      ahash_crypto_instance(inst));
 	if (err)
 		goto out_free_inst;
 
-	inst->alg.cra_flags = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC;
-	inst->alg.cra_type = &crypto_ahash_type;
+	inst->alg.halg.base.cra_flags = CRYPTO_ALG_ASYNC;
 
-	inst->alg.cra_ahash.digestsize = salg->digestsize;
-	inst->alg.cra_ctxsize = sizeof(struct cryptd_hash_ctx);
+	inst->alg.halg.digestsize = salg->digestsize;
+	inst->alg.halg.base.cra_ctxsize = sizeof(struct cryptd_hash_ctx);
 
-	inst->alg.cra_init = cryptd_hash_init_tfm;
-	inst->alg.cra_exit = cryptd_hash_exit_tfm;
+	inst->alg.halg.base.cra_init = cryptd_hash_init_tfm;
+	inst->alg.halg.base.cra_exit = cryptd_hash_exit_tfm;
 
-	inst->alg.cra_ahash.init   = cryptd_hash_init_enqueue;
-	inst->alg.cra_ahash.update = cryptd_hash_update_enqueue;
-	inst->alg.cra_ahash.final  = cryptd_hash_final_enqueue;
-	inst->alg.cra_ahash.setkey = cryptd_hash_setkey;
-	inst->alg.cra_ahash.digest = cryptd_hash_digest_enqueue;
+	inst->alg.init   = cryptd_hash_init_enqueue;
+	inst->alg.update = cryptd_hash_update_enqueue;
+	inst->alg.final  = cryptd_hash_final_enqueue;
+	inst->alg.setkey = cryptd_hash_setkey;
+	inst->alg.digest = cryptd_hash_digest_enqueue;
 
-	err = crypto_register_instance(tmpl, inst);
+	err = ahash_register_instance(tmpl, inst);
 	if (err) {
 		crypto_drop_shash(&ctx->spawn);
 out_free_inst:
@@ -580,6 +582,14 @@ static int cryptd_create(struct crypto_template *tmpl, struct rtattr **tb)
 static void cryptd_free(struct crypto_instance *inst)
 {
 	struct cryptd_instance_ctx *ctx = crypto_instance_ctx(inst);
+	struct hashd_instance_ctx *hctx = crypto_instance_ctx(inst);
+
+	switch (inst->alg.cra_flags & CRYPTO_ALG_TYPE_MASK) {
+	case CRYPTO_ALG_TYPE_AHASH:
+		crypto_drop_shash(&hctx->spawn);
+		kfree(ahash_instance(inst));
+		return;
+	}
 
 	crypto_drop_spawn(&ctx->spawn);
 	kfree(inst);
