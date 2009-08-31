From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [PATCH 2/5] aead: Add generic aead wrapper interface
Date: Mon, 31 Aug 2009 15:58:16 +1000
Message-ID: <20090831055816.GA26693@gondor.apana.org.au>
References: <20090605092030.GO20366@secunet.com> <20090605092021.GB8724@gondor.apana.org.au> <20090605093430.GP20366@secunet.com> <20090608052808.GB19826@gondor.apana.org.au> <20090608064518.GQ20366@secunet.com> <20090625065112.GA31869@gondor.apana.org.au> <20090629110410.GE20366@secunet.com> <20090629115950.GA6594@gondor.apana.org.au> <20090629135257.GG20366@secunet.com> <20090819071549.GB14755@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:33815 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754385AbZHaF6W (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 31 Aug 2009 01:58:22 -0400
Content-Disposition: inline
In-Reply-To: <20090819071549.GB14755@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 19, 2009 at 09:15:49AM +0200, Steffen Klassert wrote:
> 
> Any ideas why it's not possible to instantiate pcrypt?

Sorry for the late response.

In fact it was being instantiated, it was just getting killed
immediately after completing its self-test :)

Please let me know if this fixes it for you.

commit 2bf2901669a564b402cd0e40eb3f941c391e64c4
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Mon Aug 31 15:56:54 2009 +1000

    crypto: api - Do not displace newly registered algorithms
    
    We have a mechanism where newly registered algorithms of a higher
    priority can displace existing instances that use a different
    implementation of the same algorithm with a lower priority.
    
    Unfortunately the same mechanism can cause a newly registered
    algorithm to displace itself if it depends on an existing version
    of the same algorithm.
    
    This patch fixes this by keeping all algorithms that the newly
    reigstered algorithm depends on, thus protecting them from being
    removed.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 6a98076..feb77e4 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -81,16 +81,35 @@ static void crypto_destroy_instance(struct crypto_alg *alg)
 	crypto_tmpl_put(tmpl);
 }
 
+static struct list_head *crypto_more_spawns(struct crypto_alg *alg,
+					    struct list_head *stack,
+					    struct list_head *top,
+					    struct list_head *secondary_spawns)
+{
+	struct crypto_spawn *spawn, *n;
+
+	if (list_empty(stack))
+		return NULL;
+
+	spawn = list_first_entry(stack, struct crypto_spawn, list);
+	n = list_entry(spawn->list.next, struct crypto_spawn, list);
+
+	if (spawn->alg && &n->list != stack && !n->alg)
+		n->alg = (n->list.next == stack) ? alg :
+			 &list_entry(n->list.next, struct crypto_spawn,
+				     list)->inst->alg;
+
+	list_move(&spawn->list, secondary_spawns);
+
+	return &n->list == stack ? top : &n->inst->alg.cra_users;
+}
+
 static void crypto_remove_spawn(struct crypto_spawn *spawn,
-				struct list_head *list,
-				struct list_head *secondary_spawns)
+				struct list_head *list)
 {
 	struct crypto_instance *inst = spawn->inst;
 	struct crypto_template *tmpl = inst->tmpl;
 
-	list_del_init(&spawn->list);
-	spawn->alg = NULL;
-
 	if (crypto_is_dead(&inst->alg))
 		return;
 
@@ -106,25 +125,55 @@ static void crypto_remove_spawn(struct crypto_spawn *spawn,
 	hlist_del(&inst->list);
 	inst->alg.cra_destroy = crypto_destroy_instance;
 
-	list_splice(&inst->alg.cra_users, secondary_spawns);
+	BUG_ON(!list_empty(&inst->alg.cra_users));
 }
 
-static void crypto_remove_spawns(struct list_head *spawns,
-				 struct list_head *list, u32 new_type)
+static void crypto_remove_spawns(struct crypto_alg *alg,
+				 struct list_head *list,
+				 struct crypto_alg *nalg)
 {
+	u32 new_type = (nalg ?: alg)->cra_flags;
 	struct crypto_spawn *spawn, *n;
 	LIST_HEAD(secondary_spawns);
+	struct list_head *spawns;
+	LIST_HEAD(stack);
+	LIST_HEAD(top);
 
+	spawns = &alg->cra_users;
 	list_for_each_entry_safe(spawn, n, spawns, list) {
 		if ((spawn->alg->cra_flags ^ new_type) & spawn->mask)
 			continue;
 
-		crypto_remove_spawn(spawn, list, &secondary_spawns);
+		list_move(&spawn->list, &top);
 	}
 
-	while (!list_empty(&secondary_spawns)) {
-		list_for_each_entry_safe(spawn, n, &secondary_spawns, list)
-			crypto_remove_spawn(spawn, list, &secondary_spawns);
+	spawns = &top;
+	do {
+		while (!list_empty(spawns)) {
+			struct crypto_instance *inst;
+
+			spawn = list_first_entry(spawns, struct crypto_spawn,
+						 list);
+			inst = spawn->inst;
+
+			BUG_ON(&inst->alg == alg);
+
+			list_move(&spawn->list, &stack);
+
+			if (&inst->alg == nalg)
+				break;
+
+			spawn->alg = NULL;
+			spawns = &inst->alg.cra_users;
+		}
+	} while ((spawns = crypto_more_spawns(alg, &stack, &top,
+					      &secondary_spawns)));
+
+	list_for_each_entry_safe(spawn, n, &secondary_spawns, list) {
+		if (spawn->alg)
+			list_move(&spawn->list, &spawn->alg->cra_users);
+		else
+			crypto_remove_spawn(spawn, list);
 	}
 }
 
@@ -258,7 +307,7 @@ found:
 		    q->cra_priority > alg->cra_priority)
 			continue;
 
-		crypto_remove_spawns(&q->cra_users, &list, alg->cra_flags);
+		crypto_remove_spawns(q, &list, alg);
 	}
 
 complete:
@@ -330,7 +379,7 @@ static int crypto_remove_alg(struct crypto_alg *alg, struct list_head *list)
 
 	crypto_notify(CRYPTO_MSG_ALG_UNREGISTER, alg);
 	list_del_init(&alg->cra_list);
-	crypto_remove_spawns(&alg->cra_users, list, alg->cra_flags);
+	crypto_remove_spawns(alg, list, NULL);
 
 	return 0;
 }

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
