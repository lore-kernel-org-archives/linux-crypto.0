From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH v3 02/17] crypto: Export crypto_remove_spawns
Date: Wed, 21 Sep 2011 11:00:27 +0200
Message-ID: <20110921090027.GG1808@secunet.com>
References: <20110921085855.GE1808@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:33803 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041Ab1IUJAc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Sep 2011 05:00:32 -0400
Content-Disposition: inline
In-Reply-To: <20110921085855.GE1808@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The upcomming crypto usrerspace configuration api needs
to remove the spawns on top on an algorithm, so export
crypto_remove_spawns.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/algapi.c   |    6 +++---
 crypto/internal.h |    2 ++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 6fd9bcf..1b54d74 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -129,9 +129,8 @@ static void crypto_remove_spawn(struct crypto_spawn *spawn,
 	BUG_ON(!list_empty(&inst->alg.cra_users));
 }
 
-static void crypto_remove_spawns(struct crypto_alg *alg,
-				 struct list_head *list,
-				 struct crypto_alg *nalg)
+void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
+			  struct crypto_alg *nalg)
 {
 	u32 new_type = (nalg ?: alg)->cra_flags;
 	struct crypto_spawn *spawn, *n;
@@ -177,6 +176,7 @@ static void crypto_remove_spawns(struct crypto_alg *alg,
 			crypto_remove_spawn(spawn, list);
 	}
 }
+EXPORT_SYMBOL_GPL(crypto_remove_spawns);
 
 static struct crypto_larval *__crypto_register_alg(struct crypto_alg *alg)
 {
diff --git a/crypto/internal.h b/crypto/internal.h
index d4384b0..b6dcb31 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -86,6 +86,8 @@ struct crypto_alg *crypto_larval_lookup(const char *name, u32 type, u32 mask);
 void crypto_larval_error(const char *name, u32 type, u32 mask);
 void crypto_alg_tested(const char *name, int err);
 
+void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
+			  struct crypto_alg *nalg);
 void crypto_shoot_alg(struct crypto_alg *alg);
 struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
 				      u32 mask);
-- 
1.7.0.4
