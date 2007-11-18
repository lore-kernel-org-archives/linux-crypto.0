From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/4] [CRYPTO] api: Fix potential race in crypto_remove_spawn
Date: Sun, 18 Nov 2007 21:32:02 +0800
Message-ID: <E1ItkFm-0007T9-00@gondolin.me.apana.org.au>
References: <20071118133054.GA28619@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4581 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752247AbXKRNcF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Nov 2007 08:32:05 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1ItkFm-00073d-Qs
	for <linux-crypto@vger.kernel.org>; Mon, 19 Nov 2007 00:32:03 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] api: Fix potential race in crypto_remove_spawn

As it is crypto_remove_spawn may try to unregister an instance which is
yet to be registered.  This patch fixes this by checking whether the
instance has been registered before attempting to remove it.

It also removes a bogus cra_destroy check in crypto_register_instance as
1) it's outside the mutex;
2) we have a check in __crypto_register_alg already.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/algapi.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 8ff8c26..8383282 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -95,6 +95,9 @@ static void crypto_remove_spawn(struct crypto_spawn *spawn,
 		return;
 
 	inst->alg.cra_flags |= CRYPTO_ALG_DEAD;
+	if (hlist_unhashed(&inst->list))
+		return;
+
 	if (!tmpl || !crypto_tmpl_get(tmpl))
 		return;
 
@@ -335,9 +338,6 @@ int crypto_register_instance(struct crypto_template *tmpl,
 	LIST_HEAD(list);
 	int err = -EINVAL;
 
-	if (inst->alg.cra_destroy)
-		goto err;
-
 	err = crypto_check_alg(&inst->alg);
 	if (err)
 		goto err;
