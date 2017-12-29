From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] crypto: algapi - remove unused notifications
Date: Fri, 29 Dec 2017 10:06:46 -0600
Message-ID: <20171229160646.25273-1-ebiggers3@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:46360 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750869AbdL2QHJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Dec 2017 11:07:09 -0500
Received: by mail-io0-f196.google.com with SMTP id x129so41575059iod.13
        for <linux-crypto@vger.kernel.org>; Fri, 29 Dec 2017 08:07:09 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

There is a message posted to the crypto notifier chain when an algorithm
is unregistered, and when a template is registered or unregistered.  But
nothing is listening for those messages; currently there are only
listeners for the algorithm request and registration messages.

Get rid of these unused notifications for now.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/algapi.c   | 5 -----
 crypto/internal.h | 3 ---
 2 files changed, 8 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 8084a76e01d8..9895cafcce7e 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -123,7 +123,6 @@ static void crypto_remove_instance(struct crypto_instance *inst,
 	if (!tmpl || !crypto_tmpl_get(tmpl))
 		return;
 
-	crypto_notify(CRYPTO_MSG_ALG_UNREGISTER, &inst->alg);
 	list_move(&inst->alg.cra_list, list);
 	hlist_del(&inst->list);
 	inst->alg.cra_destroy = crypto_destroy_instance;
@@ -380,7 +379,6 @@ static int crypto_remove_alg(struct crypto_alg *alg, struct list_head *list)
 
 	alg->cra_flags |= CRYPTO_ALG_DEAD;
 
-	crypto_notify(CRYPTO_MSG_ALG_UNREGISTER, alg);
 	list_del_init(&alg->cra_list);
 	crypto_remove_spawns(alg, list, NULL);
 
@@ -458,7 +456,6 @@ int crypto_register_template(struct crypto_template *tmpl)
 	}
 
 	list_add(&tmpl->list, &crypto_template_list);
-	crypto_notify(CRYPTO_MSG_TMPL_REGISTER, tmpl);
 	err = 0;
 out:
 	up_write(&crypto_alg_sem);
@@ -485,8 +482,6 @@ void crypto_unregister_template(struct crypto_template *tmpl)
 		BUG_ON(err);
 	}
 
-	crypto_notify(CRYPTO_MSG_TMPL_UNREGISTER, tmpl);
-
 	up_write(&crypto_alg_sem);
 
 	hlist_for_each_entry_safe(inst, n, list, list) {
diff --git a/crypto/internal.h b/crypto/internal.h
index 1388af6da85a..5ac27fba10e8 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -30,9 +30,6 @@
 enum {
 	CRYPTO_MSG_ALG_REQUEST,
 	CRYPTO_MSG_ALG_REGISTER,
-	CRYPTO_MSG_ALG_UNREGISTER,
-	CRYPTO_MSG_TMPL_REGISTER,
-	CRYPTO_MSG_TMPL_UNREGISTER,
 };
 
 struct crypto_instance;
-- 
2.15.1
