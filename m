From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH v4 03/17] crypto: Export crypto_remove_final
Date: Tue, 27 Sep 2011 07:23:07 +0200
Message-ID: <20110927052306.GE1808@secunet.com>
References: <20110927052050.GB1808@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:33948 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582Ab1I0FXJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 Sep 2011 01:23:09 -0400
Content-Disposition: inline
In-Reply-To: <20110927052050.GB1808@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The upcomming crypto usrerspace configuration api needs
to remove the spawns on top on an algorithm, so export
crypto_remove_final.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/algapi.c   |    5 ++---
 crypto/internal.h |    1 +
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 1b54d74..54dd4e3 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -22,8 +22,6 @@
 
 #include "internal.h"
 
-static void crypto_remove_final(struct list_head *list);
-
 static LIST_HEAD(crypto_template_list);
 
 void crypto_larval_error(const char *name, u32 type, u32 mask)
@@ -321,7 +319,7 @@ unlock:
 }
 EXPORT_SYMBOL_GPL(crypto_alg_tested);
 
-static void crypto_remove_final(struct list_head *list)
+void crypto_remove_final(struct list_head *list)
 {
 	struct crypto_alg *alg;
 	struct crypto_alg *n;
@@ -331,6 +329,7 @@ static void crypto_remove_final(struct list_head *list)
 		crypto_alg_put(alg);
 	}
 }
+EXPORT_SYMBOL_GPL(crypto_remove_final);
 
 static void crypto_wait_for_test(struct crypto_larval *larval)
 {
diff --git a/crypto/internal.h b/crypto/internal.h
index b6dcb31..b865ca1 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -88,6 +88,7 @@ void crypto_alg_tested(const char *name, int err);
 
 void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
 			  struct crypto_alg *nalg);
+void crypto_remove_final(struct list_head *list);
 void crypto_shoot_alg(struct crypto_alg *alg);
 struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
 				      u32 mask);
-- 
1.7.0.4
