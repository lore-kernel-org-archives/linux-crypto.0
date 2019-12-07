Return-Path: <SRS0=Odag=Z5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C48FC43603
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Dec 2019 14:33:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A76E24679
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Dec 2019 14:33:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfLGOdy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 7 Dec 2019 09:33:54 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:55008 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726397AbfLGOdy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 7 Dec 2019 09:33:54 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1idb9d-00086Z-AZ; Sat, 07 Dec 2019 22:33:53 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1idb9b-0002v9-TJ; Sat, 07 Dec 2019 22:33:51 +0800
Date:   Sat, 7 Dec 2019 22:33:51 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: api - Add more comments to crypto_remove_spawns
Message-ID: <20191207143351.wno3o63z5lgvbcme@gondor.apana.org.au>
References: <20191206143914.hfggirmmnjk27kx4@gondor.apana.org.au>
 <E1idElt-0001VY-O3@gondobar>
 <20191206225021.GF246840@gmail.com>
 <20191207034017.6hy4wuua6f4ekmdr@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191207034017.6hy4wuua6f4ekmdr@gondor.apana.org.au>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Dec 07, 2019 at 11:40:17AM +0800, Herbert Xu wrote:
>
> > Also, some comments (e.g. for struct crypto_spawn and crypto_remove_spawns())
> > would be really helpful to understand what's going on here.
> 
> crypto_remove_spawns is performing a depth-first walk on cra_users
> without recursion.  In the specific case of a spawn removal triggered
> by a new registration, we will halt the walk when we hit the
> newly registered algorithm, and undo any actions that we did
> on the path leading to that object.  The function crypto_more_spawns
> performs the undo action.
> 
> I'll add this to crypto_remove_spawns.

Here is the patch:

---8<---
This patch explains the logic behind crypto_remove_spawns and its
underling crypto_more_spawns.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algapi.c b/crypto/algapi.c
index adb516380be9..8ef771ab0ee3 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -82,6 +82,15 @@ static void crypto_destroy_instance(struct crypto_alg *alg)
 	crypto_tmpl_put(tmpl);
 }
 
+/*
+ * This function adds a spawn to the list secondary_spawns which
+ * will be used at the end of crypto_remove_spawns to unregister
+ * instances, unless the spawn happens to be one that is depended
+ * on by the new algorithm (nalg in crypto_remove_spawns).
+ *
+ * This function is also responsible for resurrecting any algorithms
+ * in the dependency chain of nalg by unsetting n->dead.
+ */
 static struct list_head *crypto_more_spawns(struct crypto_alg *alg,
 					    struct list_head *stack,
 					    struct list_head *top,
@@ -128,6 +137,12 @@ static void crypto_remove_instance(struct crypto_instance *inst,
 	BUG_ON(!list_empty(&inst->alg.cra_users));
 }
 
+/*
+ * Given an algorithm alg, remove all algorithms that depend on it
+ * through spawns.  If nalg is not null, then exempt any algorithms
+ * that is depended on by nalg.  This is useful when nalg itself
+ * depends on alg.
+ */
 void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
 			  struct crypto_alg *nalg)
 {
@@ -146,6 +161,11 @@ void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
 		list_move(&spawn->list, &top);
 	}
 
+	/*
+	 * Perform a depth-first walk starting from alg through
+	 * the cra_users tree.  The list stack records the path
+	 * from alg to the current spawn.
+	 */
 	spawns = &top;
 	do {
 		while (!list_empty(spawns)) {
@@ -180,6 +200,11 @@ void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
 	} while ((spawns = crypto_more_spawns(alg, &stack, &top,
 					      &secondary_spawns)));
 
+	/*
+	 * Remove all instances that are marked as dead.  Also
+	 * complete the resurrection of the others by moving them
+	 * back to the cra_users list.
+	 */
 	list_for_each_entry_safe(spawn, n, &secondary_spawns, list) {
 		if (!spawn->dead)
 			list_move(&spawn->list, &spawn->alg->cra_users);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
