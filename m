Return-Path: <SRS0=wI/w=Z4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00A7AC2BBE2
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Dec 2019 14:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D600320706
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Dec 2019 14:39:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbfLFOjz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Dec 2019 09:39:55 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:46974 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726195AbfLFOjz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Dec 2019 09:39:55 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1idElt-0007yX-V0
        for <linux-crypto@vger.kernel.org>; Fri, 06 Dec 2019 22:39:53 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1idElt-0001VY-O3; Fri, 06 Dec 2019 22:39:53 +0800
Subject: [PATCH 2/2] crypto: api - Do not zap spawn->alg
References: <20191206143914.hfggirmmnjk27kx4@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1idElt-0001VY-O3@gondobar>
From:   Herbert Xu <herbert@gondor.apana.org.au>
Date:   Fri, 06 Dec 2019 22:39:53 +0800
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently when a spawn is removed we will zap its alg field.
This is racy because the spawn could belong to an unregistered
instance which may dereference the spawn->alg field.

This patch fixes this by keeping spawn->alg constant and instead
adding a new spawn->dead field to indicate that a spawn is going
away.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/algapi.c         |   21 +++++++++++----------
 include/crypto/algapi.h |    1 +
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index cc55301beef4..2d0697c4f69c 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -93,15 +93,16 @@ static struct list_head *crypto_more_spawns(struct crypto_alg *alg,
 	if (!spawn)
 		return NULL;
 
-	n = list_next_entry(spawn, list);
+	list_move(&spawn->list, secondary_spawns);
 
-	if (spawn->alg && &n->list != stack && !n->alg)
-		n->alg = (n->list.next == stack) ? alg :
-			 &list_next_entry(n, list)->inst->alg;
+	if (list_is_last(&spawn->list, stack))
+		return top;
 
-	list_move(&spawn->list, secondary_spawns);
+	n = list_next_entry(spawn, list);
+	if (!spawn->dead)
+		n->dead = false;
 
-	return &n->list == stack ? top : &n->inst->alg.cra_users;
+	return &n->inst->alg.cra_users;
 }
 
 static void crypto_remove_instance(struct crypto_instance *inst,
@@ -160,7 +161,7 @@ void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
 			if (&inst->alg == nalg)
 				break;
 
-			spawn->alg = NULL;
+			spawn->dead = true;
 			spawns = &inst->alg.cra_users;
 
 			/*
@@ -179,7 +180,7 @@ void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
 					      &secondary_spawns)));
 
 	list_for_each_entry_safe(spawn, n, &secondary_spawns, list) {
-		if (spawn->alg)
+		if (!spawn->dead)
 			list_move(&spawn->list, &spawn->alg->cra_users);
 		else
 			crypto_remove_instance(spawn->inst, list);
@@ -669,7 +670,7 @@ EXPORT_SYMBOL_GPL(crypto_grab_spawn);
 void crypto_drop_spawn(struct crypto_spawn *spawn)
 {
 	down_write(&crypto_alg_sem);
-	if (spawn->alg)
+	if (!spawn->dead)
 		list_del(&spawn->list);
 	up_write(&crypto_alg_sem);
 }
@@ -681,7 +682,7 @@ static struct crypto_alg *crypto_spawn_alg(struct crypto_spawn *spawn)
 
 	down_read(&crypto_alg_sem);
 	alg = spawn->alg;
-	if (alg && !crypto_mod_get(alg)) {
+	if (!spawn->dead && !crypto_mod_get(alg)) {
 		alg->cra_flags |= CRYPTO_ALG_DYING;
 		alg = NULL;
 	}
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 5cd846defdd6..771a295ac755 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -70,6 +70,7 @@ struct crypto_spawn {
 	struct crypto_instance *inst;
 	const struct crypto_type *frontend;
 	u32 mask;
+	bool dead;
 };
 
 struct crypto_queue {
