From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6/19] [CRYPTO] gcm: Use crypto_grab_skcipher
Date: Tue, 11 Dec 2007 12:02:57 +0800
Message-ID: <E1J1wKf-0002jr-00@gondolin.me.apana.org.au>
References: <20071211040215.GA10360@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1916 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751633AbXLKEDF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Dec 2007 23:03:05 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J1wKh-00062N-58
	for <linux-crypto@vger.kernel.org>; Tue, 11 Dec 2007 15:03:00 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] gcm: Use crypto_grab_skcipher

This patch converts the gcm algorithm over to crypto_grab_skcipher
which is a prerequisite for IV generation.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/gcm.c |   41 +++++++++++++++++++----------------------
 1 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index 9c29765..1fdefe5 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -8,9 +8,9 @@
  * by the Free Software Foundation.
  */
 
-#include <crypto/algapi.h>
 #include <crypto/ctr.h>
 #include <crypto/gf128mul.h>
+#include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -18,10 +18,8 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 
-#include "internal.h"
-
 struct gcm_instance_ctx {
-	struct crypto_spawn ctr;
+	struct crypto_skcipher_spawn ctr;
 	char cipher_name[CRYPTO_MAX_ALG_NAME];
 };
 
@@ -353,7 +351,7 @@ static int crypto_gcm_init_tfm(struct crypto_tfm *tfm)
 	unsigned long align;
 	int err;
 
-	ctr = crypto_spawn_ablkcipher(&ictx->ctr);
+	ctr = crypto_spawn_skcipher(&ictx->ctr);
 	err = PTR_ERR(ctr);
 	if (IS_ERR(ctr))
 		return err;
@@ -400,33 +398,31 @@ static struct crypto_instance *crypto_gcm_alloc_common(struct rtattr **tb,
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return ERR_PTR(-EINVAL);
 
-	ctr = crypto_alg_mod_lookup(ctr_name, CRYPTO_ALG_TYPE_BLKCIPHER,
-				    CRYPTO_ALG_TYPE_MASK);
+	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
+	if (!inst)
+		return ERR_PTR(-ENOMEM);
 
-	if (IS_ERR(ctr))
-		return ERR_PTR(PTR_ERR(ctr));
+	ctx = crypto_instance_ctx(inst);
+	crypto_set_skcipher_spawn(&ctx->ctr, inst);
+	err = crypto_grab_skcipher(&ctx->ctr, ctr_name, 0,
+				   (algt->type ^ CRYPTO_ALG_ASYNC) &
+				   algt->mask);
+	if (err)
+		goto err_free_inst;
+
+	ctr = crypto_skcipher_spawn_alg(&ctx->ctr);
 
 	/* Not a stream cipher? */
 	err = -EINVAL;
 	if (ctr->cra_blocksize != 1)
 		goto out_put_ctr;
 
-	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
-	err = -ENOMEM;
-	if (!inst)
-		goto out_put_ctr;
-
 	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "gcm_base(%s,%s)", ctr->cra_driver_name, cipher_name) >=
 	    CRYPTO_MAX_ALG_NAME)
 		goto out_put_ctr;
 
-	ctx = crypto_instance_ctx(inst);
-	err = crypto_init_spawn(&ctx->ctr, ctr, inst, CRYPTO_ALG_TYPE_MASK);
-	if (err)
-		goto err_free_inst;
-
 	memcpy(inst->alg.cra_name, full_name, CRYPTO_MAX_ALG_NAME);
 	memcpy(ctx->cipher_name, cipher_name, CRYPTO_MAX_ALG_NAME);
 
@@ -446,11 +442,12 @@ static struct crypto_instance *crypto_gcm_alloc_common(struct rtattr **tb,
 	inst->alg.cra_aead.decrypt = crypto_gcm_decrypt;
 
 out:
-	crypto_mod_put(ctr);
 	return inst;
+
+out_put_ctr:
+	crypto_drop_skcipher(&ctx->ctr);
 err_free_inst:
 	kfree(inst);
-out_put_ctr:
 	inst = ERR_PTR(err);
 	goto out;
 }
@@ -482,7 +479,7 @@ static void crypto_gcm_free(struct crypto_instance *inst)
 {
 	struct gcm_instance_ctx *ctx = crypto_instance_ctx(inst);
 
-	crypto_drop_spawn(&ctx->ctr);
+	crypto_drop_skcipher(&ctx->ctr);
 	kfree(inst);
 }
 
