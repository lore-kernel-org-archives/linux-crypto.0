From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH] crypto: Unlink and free instances when deleted
Date: Tue, 8 Nov 2011 10:09:17 +0100
Message-ID: <20111108090917.GF22141@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:52831 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796Ab1KHJJV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Nov 2011 04:09:21 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We leak the crypto instance when we unregister an instance with
crypto_del_alg(). Therefore we introduce crypto_unregister_instance()
to unlink the crypto instance from the template's instances list and
to free the recources of the instance properly.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/algapi.c         |   29 +++++++++++++++++++++++++++++
 crypto/crypto_user.c    |    2 +-
 include/crypto/algapi.h |    1 +
 3 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 54dd4e3..9d4a9fe 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -518,6 +518,35 @@ err:
 }
 EXPORT_SYMBOL_GPL(crypto_register_instance);
 
+int crypto_unregister_instance(struct crypto_alg *alg)
+{
+	int err;
+	struct crypto_instance *inst = (void *)alg;
+	struct crypto_template *tmpl = inst->tmpl;
+	LIST_HEAD(users);
+
+	if (!(alg->cra_flags & CRYPTO_ALG_INSTANCE))
+		return -EINVAL;
+
+	BUG_ON(atomic_read(&alg->cra_refcnt) != 1);
+
+	down_write(&crypto_alg_sem);
+
+	hlist_del_init(&inst->list);
+	err = crypto_remove_alg(alg, &users);
+
+	up_write(&crypto_alg_sem);
+
+	if (err)
+		return err;
+
+	tmpl->free(inst);
+	crypto_remove_final(&users);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(crypto_unregister_instance);
+
 int crypto_init_spawn(struct crypto_spawn *spawn, struct crypto_alg *alg,
 		      struct crypto_instance *inst, u32 mask)
 {
diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index 0605a2b..3ba6ef5 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -298,7 +298,7 @@ static int crypto_del_alg(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (atomic_read(&alg->cra_refcnt) != 1)
 		return -EBUSY;
 
-	return crypto_unregister_alg(alg);
+	return crypto_unregister_instance(alg);
 }
 
 static int crypto_add_alg(struct sk_buff *skb, struct nlmsghdr *nlh,
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index ecc721d..418d270 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -134,6 +134,7 @@ struct crypto_template *crypto_lookup_template(const char *name);
 
 int crypto_register_instance(struct crypto_template *tmpl,
 			     struct crypto_instance *inst);
+int crypto_unregister_instance(struct crypto_alg *alg);
 
 int crypto_init_spawn(struct crypto_spawn *spawn, struct crypto_alg *alg,
 		      struct crypto_instance *inst, u32 mask);
-- 
1.7.0.4
