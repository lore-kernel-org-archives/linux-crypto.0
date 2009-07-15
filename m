From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 27/35] crypto: cryptd - Switch to template create API
Date: Wed, 15 Jul 2009 15:16:21 +0800
Message-ID: <E1MQyiz-00051d-KJ@gondolin.me.apana.org.au>
References: <20090715071424.GA19023@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53656 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752725AbZGOHQ3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 03:16:29 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MQyj1-0004ub-Ax
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2009 17:16:24 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: cryptd - Switch to template create API

This patch changes cryptd to use the template->create function
instead of alloc in anticipation for the switch to new style
ahash algorithms.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/cryptd.c         |   53 ++++++++++++++++++++++++++----------------------
 crypto/internal.h       |    3 --
 include/crypto/algapi.h |    3 ++
 3 files changed, 32 insertions(+), 27 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 6e6722e..ad58f51 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -287,8 +287,9 @@ out_free_inst:
 	goto out;
 }
 
-static struct crypto_instance *cryptd_alloc_blkcipher(
-	struct rtattr **tb, struct cryptd_queue *queue)
+static int cryptd_create_blkcipher(struct crypto_template *tmpl,
+				   struct rtattr **tb,
+				   struct cryptd_queue *queue)
 {
 	struct cryptd_instance_ctx *ctx;
 	struct crypto_instance *inst;
@@ -298,7 +299,7 @@ static struct crypto_instance *cryptd_alloc_blkcipher(
 	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_BLKCIPHER,
 				  CRYPTO_ALG_TYPE_MASK);
 	if (IS_ERR(alg))
-		return ERR_CAST(alg);
+		return PTR_ERR(alg);
 
 	inst = cryptd_alloc_instance(alg, sizeof(*ctx));
 	if (IS_ERR(inst))
@@ -330,14 +331,16 @@ static struct crypto_instance *cryptd_alloc_blkcipher(
 	inst->alg.cra_ablkcipher.encrypt = cryptd_blkcipher_encrypt_enqueue;
 	inst->alg.cra_ablkcipher.decrypt = cryptd_blkcipher_decrypt_enqueue;
 
+	err = crypto_register_instance(tmpl, inst);
+	if (err) {
+		crypto_drop_spawn(&ctx->spawn);
+out_free_inst:
+		kfree(inst);
+	}
+
 out_put_alg:
 	crypto_mod_put(alg);
-	return inst;
-
-out_free_inst:
-	kfree(inst);
-	inst = ERR_PTR(err);
-	goto out_put_alg;
+	return err;
 }
 
 static int cryptd_hash_init_tfm(struct crypto_tfm *tfm)
@@ -502,8 +505,8 @@ static int cryptd_hash_digest_enqueue(struct ahash_request *req)
 	return cryptd_hash_enqueue(req, cryptd_hash_digest);
 }
 
-static struct crypto_instance *cryptd_alloc_hash(
-	struct rtattr **tb, struct cryptd_queue *queue)
+static int cryptd_create_hash(struct crypto_template *tmpl, struct rtattr **tb,
+			      struct cryptd_queue *queue)
 {
 	struct hashd_instance_ctx *ctx;
 	struct crypto_instance *inst;
@@ -513,7 +516,7 @@ static struct crypto_instance *cryptd_alloc_hash(
 
 	salg = shash_attr_alg(tb[1], 0, 0);
 	if (IS_ERR(salg))
-		return ERR_CAST(salg);
+		return PTR_ERR(salg);
 
 	alg = &salg->base;
 	inst = cryptd_alloc_instance(alg, sizeof(*ctx));
@@ -542,34 +545,36 @@ static struct crypto_instance *cryptd_alloc_hash(
 	inst->alg.cra_ahash.setkey = cryptd_hash_setkey;
 	inst->alg.cra_ahash.digest = cryptd_hash_digest_enqueue;
 
+	err = crypto_register_instance(tmpl, inst);
+	if (err) {
+		crypto_drop_shash(&ctx->spawn);
+out_free_inst:
+		kfree(inst);
+	}
+
 out_put_alg:
 	crypto_mod_put(alg);
-	return inst;
-
-out_free_inst:
-	kfree(inst);
-	inst = ERR_PTR(err);
-	goto out_put_alg;
+	return err;
 }
 
 static struct cryptd_queue queue;
 
-static struct crypto_instance *cryptd_alloc(struct rtattr **tb)
+static int cryptd_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	struct crypto_attr_type *algt;
 
 	algt = crypto_get_attr_type(tb);
 	if (IS_ERR(algt))
-		return ERR_CAST(algt);
+		return PTR_ERR(algt);
 
 	switch (algt->type & algt->mask & CRYPTO_ALG_TYPE_MASK) {
 	case CRYPTO_ALG_TYPE_BLKCIPHER:
-		return cryptd_alloc_blkcipher(tb, &queue);
+		return cryptd_create_blkcipher(tmpl, tb, &queue);
 	case CRYPTO_ALG_TYPE_DIGEST:
-		return cryptd_alloc_hash(tb, &queue);
+		return cryptd_create_hash(tmpl, tb, &queue);
 	}
 
-	return ERR_PTR(-EINVAL);
+	return -EINVAL;
 }
 
 static void cryptd_free(struct crypto_instance *inst)
@@ -582,7 +587,7 @@ static void cryptd_free(struct crypto_instance *inst)
 
 static struct crypto_template cryptd_tmpl = {
 	.name = "cryptd",
-	.alloc = cryptd_alloc,
+	.create = cryptd_create,
 	.free = cryptd_free,
 	.module = THIS_MODULE,
 };
diff --git a/crypto/internal.h b/crypto/internal.h
index 030e229..2d22636 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -97,9 +97,6 @@ struct crypto_alg *crypto_find_alg(const char *alg_name,
 void *crypto_alloc_tfm(const char *alg_name,
 		       const struct crypto_type *frontend, u32 type, u32 mask);
 
-int crypto_register_instance(struct crypto_template *tmpl,
-			     struct crypto_instance *inst);
