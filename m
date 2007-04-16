From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/6] [CRYPTO] api: Do not remove users unless new algorithm matches
Date: Mon, 16 Apr 2007 20:52:19 +1000
Message-ID: <E1HdOol-0002uG-00@gondolin.me.apana.org.au>
References: <<20070416105105.GA10188@gondor.apana.org.au>>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4924 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030358AbXDPKwV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Apr 2007 06:52:21 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1HdOol-0004bW-R1
	for <linux-crypto@vger.kernel.org>; Mon, 16 Apr 2007 20:52:19 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1HdOol-0002uG-00
	for <linux-crypto@vger.kernel.org>; Mon, 16 Apr 2007 20:52:19 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] api: Do not remove users unless new algorithm matches

As it is whenever a new algorithm with the same name is registered
users of the old algorithm will be removed so that they can take
advantage of the new algorithm.  This presents a problem when the
new algorithm is not equivalent to the old algorithm.  In particular,
the new algorithm might only function on top of the existing one.

Hence we should not remove users unless they can make use of the
new algorithm.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/algapi.c         |   65 ++++++++++++++++++++++++++++--------------------
 include/crypto/algapi.h |    3 +-
 2 files changed, 41 insertions(+), 27 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -84,36 +84,47 @@ static void crypto_destroy_instance(stru
 	crypto_tmpl_put(tmpl);
 }
 
+static void crypto_remove_spawn(struct crypto_spawn *spawn,
+				struct list_head *list,
+				struct list_head *secondary_spawns)
+{
+	struct crypto_instance *inst = spawn->inst;
+	struct crypto_template *tmpl = inst->tmpl;
+
+	list_del_init(&spawn->list);
+	spawn->alg = NULL;
+
+	if (crypto_is_dead(&inst->alg))
+		return;
+
+	inst->alg.cra_flags |= CRYPTO_ALG_DEAD;
+	if (!tmpl || !crypto_tmpl_get(tmpl))
+		return;
+
+	crypto_notify(CRYPTO_MSG_ALG_UNREGISTER, &inst->alg);
+	list_move(&inst->alg.cra_list, list);
+	hlist_del(&inst->list);
+	inst->alg.cra_destroy = crypto_destroy_instance;
+
+	list_splice(&inst->alg.cra_users, secondary_spawns);
+}
+
 static void crypto_remove_spawns(struct list_head *spawns,
-				 struct list_head *list)
+				 struct list_head *list, u32 new_type)
 {
 	struct crypto_spawn *spawn, *n;
+	LIST_HEAD(secondary_spawns);
 
 	list_for_each_entry_safe(spawn, n, spawns, list) {
-		struct crypto_instance *inst = spawn->inst;
-		struct crypto_template *tmpl = inst->tmpl;
-
-		list_del_init(&spawn->list);
-		spawn->alg = NULL;
-
-		if (crypto_is_dead(&inst->alg))
+		if ((spawn->alg->cra_flags ^ new_type) & spawn->mask)
 			continue;
 
-		inst->alg.cra_flags |= CRYPTO_ALG_DEAD;
-		if (!tmpl || !crypto_tmpl_get(tmpl))
-			continue;
+		crypto_remove_spawn(spawn, list, &secondary_spawns);
+	}
 
-		crypto_notify(CRYPTO_MSG_ALG_UNREGISTER, &inst->alg);
-		list_move(&inst->alg.cra_list, list);
-		hlist_del(&inst->list);
-		inst->alg.cra_destroy = crypto_destroy_instance;
-
-		if (!list_empty(&inst->alg.cra_users)) {
-			if (&n->list == spawns)
-				n = list_entry(inst->alg.cra_users.next,
-					       typeof(*n), list);
-			__list_splice(&inst->alg.cra_users, spawns->prev);
-		}
+	while (!list_empty(&secondary_spawns)) {
+		list_for_each_entry_safe(spawn, n, &secondary_spawns, list)
+			crypto_remove_spawn(spawn, list, &secondary_spawns);
 	}
 }
 
@@ -164,7 +175,7 @@ static int __crypto_register_alg(struct 
 		    q->cra_priority > alg->cra_priority)
 			continue;
 
-		crypto_remove_spawns(&q->cra_users, list);
+		crypto_remove_spawns(&q->cra_users, list, alg->cra_flags);
 	}
 	
 	list_add(&alg->cra_list, &crypto_alg_list);
@@ -214,7 +225,7 @@ static int crypto_remove_alg(struct cryp
 
 	crypto_notify(CRYPTO_MSG_ALG_UNREGISTER, alg);
 	list_del_init(&alg->cra_list);
-	crypto_remove_spawns(&alg->cra_users, list);
+	crypto_remove_spawns(&alg->cra_users, list, alg->cra_flags);
 
 	return 0;
 }
@@ -351,11 +362,12 @@ err:
 EXPORT_SYMBOL_GPL(crypto_register_instance);
 
 int crypto_init_spawn(struct crypto_spawn *spawn, struct crypto_alg *alg,
-		      struct crypto_instance *inst)
+		      struct crypto_instance *inst, u32 mask)
 {
 	int err = -EAGAIN;
 
 	spawn->inst = inst;
+	spawn->mask = mask;
 
 	down_write(&crypto_alg_sem);
 	if (!crypto_is_moribund(alg)) {
@@ -494,7 +506,8 @@ struct crypto_instance *crypto_alloc_ins
 		goto err_free_inst;
 
 	spawn = crypto_instance_ctx(inst);
-	err = crypto_init_spawn(spawn, alg, inst);
+	err = crypto_init_spawn(spawn, alg, inst,
+				CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_ASYNC);
 
 	if (err)
 		goto err_free_inst;
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -51,6 +51,7 @@ struct crypto_spawn {
 	struct list_head list;
 	struct crypto_alg *alg;
 	struct crypto_instance *inst;
+	u32 mask;
 };
 
 struct crypto_queue {
@@ -103,7 +104,7 @@ void crypto_unregister_template(struct c
 struct crypto_template *crypto_lookup_template(const char *name);
 
 int crypto_init_spawn(struct crypto_spawn *spawn, struct crypto_alg *alg,
-		      struct crypto_instance *inst);
+		      struct crypto_instance *inst, u32 mask);
 void crypto_drop_spawn(struct crypto_spawn *spawn);
 struct crypto_tfm *crypto_spawn_tfm(struct crypto_spawn *spawn, u32 type,
 				    u32 mask);
