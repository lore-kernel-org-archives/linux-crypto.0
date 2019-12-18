Return-Path: <SRS0=NTKo=2I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B26C43603
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Dec 2019 07:53:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B66DF227BF
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Dec 2019 07:53:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbfLRHxE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Dec 2019 02:53:04 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:54942 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726704AbfLRHxE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Dec 2019 02:53:04 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1ihU8k-0004Fc-Fb; Wed, 18 Dec 2019 15:53:02 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ihU8j-0001ac-6C; Wed, 18 Dec 2019 15:53:01 +0800
Date:   Wed, 18 Dec 2019 15:53:01 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [v4 PATCH] crypto: api - Retain alg refcount in crypto_grab_spawn
Message-ID: <20191218075301.t5your6vcxbishm5@gondor.apana.org.au>
References: <20191206063812.ueudgjfwzri5ekpr@gondor.apana.org.au>
 <E1id7G9-00051G-5w@gondobar>
 <20191206224155.GE246840@gmail.com>
 <20191207033059.h6kgx7j7jtnqotuy@gondor.apana.org.au>
 <20191207045234.GA5948@sol.localdomain>
 <20191207145504.gcwc75enxhqfqhxe@gondor.apana.org.au>
 <20191214064404.qlxgabr3k47473uh@gondor.apana.org.au>
 <20191215041119.ndcodt4bw4rr52es@gondor.apana.org.au>
 <20191216044649.GA908@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216044649.GA908@sol.localdomain>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Dec 15, 2019 at 08:46:49PM -0800, Eric Biggers wrote:
>
> There's still code above that uses spawn->inst without verifying that
> spawn->registered is set.
> 
> 		inst = spawn->inst;
> 
> 		BUG_ON(&inst->alg == alg);

This is actually safe because spawn->inst is a real pointer to
a spawn or NULL.  However, I agree that it is needlessly confusing
and I've changed it in the new version.

> Also, the below code looks redundant now that it's only executed when
> spawn->registered.  If it's still needed, maybe the comment needs to be updated?

It's not actually redundant, because we set spawn->registered
before the instance is fully registered.  It could actually fail
during registration which would still trigger this case.  I've
added some more comments for it.

> How about:
> 
> 	if (spawn->dropref && !spawn->registered)
> 		crypto_mod_put(spawn->alg);

Done.
 
> This really should say "Node in list of instances after registration."
> Otherwise it sounds like it's a list, not an element of a list.

Changed.

---8<---
This patch changes crypto_grab_spawn to retain the reference count
on the algorithm.  This is because the caller needs to access the
algorithm parameters and without the reference count the algorithm
can be freed at any time.

The reference count will be subsequently dropped by the crypto API
once the instance has been registered.  The helper crypto_drop_spawn
will also conditionally drop the reference count depending on whether
it has been registered.

Note that the code is actually added to crypto_init_spawn.  However,
unless the caller activates this by setting spawn->dropref beforehand
then nothing happens.  The only caller that sets dropref is currently
crypto_grab_spawn.

Once all legacy users of crypto_init_spawn disappear, then we can
kill the dropref flag.

Internally each instance will maintain a list of its spawns prior
to registration.  This memory used by this list is shared with
other fields that are only used after registration.  In order for
this to work a new flag spawn->registered is added to indicate
whether spawn->inst can be used.

Fixes: d6ef2f198d4c ("crypto: api - Add crypto_grab_spawn primitive")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algapi.c b/crypto/algapi.c
index cd643e294664..8ffaa1dca23b 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -124,8 +124,6 @@ static void crypto_remove_instance(struct crypto_instance *inst,
 		return;
 
 	inst->alg.cra_flags |= CRYPTO_ALG_DEAD;
-	if (hlist_unhashed(&inst->list))
-		return;
 
 	if (!tmpl || !crypto_tmpl_get(tmpl))
 		return;
@@ -175,17 +173,26 @@ void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
 						 list);
 			inst = spawn->inst;
 
-			BUG_ON(&inst->alg == alg);
-
 			list_move(&spawn->list, &stack);
+			spawn->dead = !spawn->registered || &inst->alg != nalg;
+
+			if (!spawn->registered)
+				break;
+
+			BUG_ON(&inst->alg == alg);
 
 			if (&inst->alg == nalg)
 				break;
 
-			spawn->dead = true;
 			spawns = &inst->alg.cra_users;
 
 			/*
+			 * Even if spawn->registered is true, the
+			 * instance itself may still be unregistered.
+			 * This is because it may have failed during
+			 * registration.  Therefore we still need to
+			 * make the following test.
+			 *
 			 * We may encounter an unregistered instance here, since
 			 * an instance's spawns are set up prior to the instance
 			 * being registered.  An unregistered instance will have
@@ -208,7 +215,7 @@ void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
 	list_for_each_entry_safe(spawn, n, &secondary_spawns, list) {
 		if (!spawn->dead)
 			list_move(&spawn->list, &spawn->alg->cra_users);
-		else
+		else if (spawn->registered)
 			crypto_remove_instance(spawn->inst, list);
 	}
 }
@@ -588,6 +595,7 @@ int crypto_register_instance(struct crypto_template *tmpl,
 			     struct crypto_instance *inst)
 {
 	struct crypto_larval *larval;
+	struct crypto_spawn *spawn;
 	int err;
 
 	err = crypto_check_alg(&inst->alg);
@@ -599,6 +607,23 @@ int crypto_register_instance(struct crypto_template *tmpl,
 
 	down_write(&crypto_alg_sem);
 
+	larval = ERR_PTR(-EAGAIN);
+	for (spawn = inst->spawns; spawn;) {
+		struct crypto_spawn *next;
+
+		if (spawn->dead)
+			goto unlock;
+
+		next = spawn->next;
+		spawn->inst = inst;
+		spawn->registered = true;
+
+		if (spawn->dropref)
+			crypto_mod_put(spawn->alg);
+
+		spawn = next;
+	}
+
 	larval = __crypto_register_alg(&inst->alg);
 	if (IS_ERR(larval))
 		goto unlock;
@@ -646,7 +671,9 @@ int crypto_init_spawn(struct crypto_spawn *spawn, struct crypto_alg *alg,
 	if (WARN_ON_ONCE(inst == NULL))
 		return -EINVAL;
 
-	spawn->inst = inst;
+	spawn->next = inst->spawns;
+	inst->spawns = spawn;
+
 	spawn->mask = mask;
 
 	down_write(&crypto_alg_sem);
@@ -688,8 +715,10 @@ int crypto_grab_spawn(struct crypto_spawn *spawn, const char *name,
 	if (IS_ERR(alg))
 		return PTR_ERR(alg);
 
+	spawn->dropref = true;
 	err = crypto_init_spawn(spawn, alg, spawn->inst, mask);
-	crypto_mod_put(alg);
+	if (err)
+		crypto_mod_put(alg);
 	return err;
 }
 EXPORT_SYMBOL_GPL(crypto_grab_spawn);
@@ -700,6 +729,9 @@ void crypto_drop_spawn(struct crypto_spawn *spawn)
 	if (!spawn->dead)
 		list_del(&spawn->list);
 	up_write(&crypto_alg_sem);
+
+	if (spawn->dropref && !spawn->registered)
+		crypto_mod_put(spawn->alg);
 }
 EXPORT_SYMBOL_GPL(crypto_drop_spawn);
 
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 771a295ac755..25bc54121848 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -47,7 +47,13 @@ struct crypto_instance {
 	struct crypto_alg alg;
 
 	struct crypto_template *tmpl;
-	struct hlist_node list;
+
+	union {
+		/* Node in list of instances after registration. */
+		struct hlist_node list;
+		/* List of attached spawns before registration. */
+		struct crypto_spawn *spawns;
+	};
 
 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
 };
@@ -67,10 +73,17 @@ struct crypto_template {
 struct crypto_spawn {
 	struct list_head list;
 	struct crypto_alg *alg;
-	struct crypto_instance *inst;
+	union {
+		/* Back pointer to instance after registration.*/
+		struct crypto_instance *inst;
+		/* Spawn list pointer prior to registration. */
+		struct crypto_spawn *next;
+	};
 	const struct crypto_type *frontend;
 	u32 mask;
 	bool dead;
+	bool dropref;
+	bool registered;
 };
 
 struct crypto_queue {
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
