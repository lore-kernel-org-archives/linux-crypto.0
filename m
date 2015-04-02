From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: api - Fix races in crypto_unregister_instance
Date: Thu, 2 Apr 2015 22:31:22 +0800
Message-ID: <20150402143122.GA9699@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	Stephan Mueller <smueller@chronox.de>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34749 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbbDBOb2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Apr 2015 10:31:28 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

There are multiple problems in crypto_unregister_instance:

1) The cra_refcnt BUG_ON check is racy and can cause crashes.
2) The cra_refcnt check shouldn't exist at all.
3) There is no reference on tmpl to protect the tmpl->free call.

This patch rewrites the function using crypto_remove_spawn which
now morphs into crypto_remove_instance.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 83b04e0..0f1976e 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -99,10 +99,9 @@ static struct list_head *crypto_more_spawns(struct crypto_alg *alg,
 	return &n->list == stack ? top : &n->inst->alg.cra_users;
 }
 
-static void crypto_remove_spawn(struct crypto_spawn *spawn,
-				struct list_head *list)
+static void crypto_remove_instance(struct crypto_instance *inst,
+				   struct list_head *list)
 {
-	struct crypto_instance *inst = spawn->inst;
 	struct crypto_template *tmpl = inst->tmpl;
 
 	if (crypto_is_dead(&inst->alg))
@@ -167,7 +166,7 @@ void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
 		if (spawn->alg)
 			list_move(&spawn->list, &spawn->alg->cra_users);
 		else
-			crypto_remove_spawn(spawn, list);
+			crypto_remove_instance(spawn->inst, list);
 	}
 }
 EXPORT_SYMBOL_GPL(crypto_remove_spawns);
@@ -554,28 +553,20 @@ EXPORT_SYMBOL_GPL(crypto_register_instance);
 
 int crypto_unregister_instance(struct crypto_alg *alg)
 {
-	int err;
 	struct crypto_instance *inst = (void *)alg;
-	struct crypto_template *tmpl = inst->tmpl;
-	LIST_HEAD(users);
+	LIST_HEAD(list);
 
 	if (!(alg->cra_flags & CRYPTO_ALG_INSTANCE))
 		return -EINVAL;
 
-	BUG_ON(atomic_read(&alg->cra_refcnt) != 1);
-
 	down_write(&crypto_alg_sem);
 
-	hlist_del_init(&inst->list);
-	err = crypto_remove_alg(alg, &users);
+	crypto_remove_spawns(alg, &list, NULL);
+	crypto_remove_instance(inst, &list);
 
 	up_write(&crypto_alg_sem);
 
-	if (err)
-		return err;
-
-	tmpl->free(inst);
-	crypto_remove_final(&users);
+	crypto_remove_final(&list);
 
 	return 0;
 }
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
