From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 1/2] crypto: user - Fix lookup of algorithms with IV
 generator
Date: Mon, 26 Mar 2012 09:27:29 +0200
Message-ID: <20120326072729.GA16191@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:50304 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358Ab2CZH1g (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Mar 2012 03:27:36 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We lookup algorithms with crypto_alg_mod_lookup() when instantiating via
crypto_add_alg(). However, algorithms that are wrapped by an IV genearator
(e.g. aead or givcipher type algorithms) need special care. The userspace
process hangs until it gets a timeout when we use crypto_alg_mod_lookup()
to lookup these algorithms. So export the lookup functions for these
algorithms and use them when instantiating via crypto_add_alg().

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/ablkcipher.c                |    4 +-
 crypto/aead.c                      |    4 +-
 crypto/crypto_user.c               |   71 +++++++++++++++++++++++++++++++++++-
 include/crypto/internal/aead.h     |    2 +
 include/crypto/internal/skcipher.h |    2 +
 5 files changed, 78 insertions(+), 5 deletions(-)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index a0f768c..8d3a056 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -613,8 +613,7 @@ out:
 	return err;
 }
 
-static struct crypto_alg *crypto_lookup_skcipher(const char *name, u32 type,
-						 u32 mask)
+struct crypto_alg *crypto_lookup_skcipher(const char *name, u32 type, u32 mask)
 {
 	struct crypto_alg *alg;
 
@@ -652,6 +651,7 @@ static struct crypto_alg *crypto_lookup_skcipher(const char *name, u32 type,
 
 	return ERR_PTR(crypto_givcipher_default(alg, type, mask));
 }
+EXPORT_SYMBOL_GPL(crypto_lookup_skcipher);
 
 int crypto_grab_skcipher(struct crypto_skcipher_spawn *spawn, const char *name,
 			 u32 type, u32 mask)
diff --git a/crypto/aead.c b/crypto/aead.c
index 04add3d..e4cb351 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -470,8 +470,7 @@ out:
 	return err;
 }
 
-static struct crypto_alg *crypto_lookup_aead(const char *name, u32 type,
-					     u32 mask)
+struct crypto_alg *crypto_lookup_aead(const char *name, u32 type, u32 mask)
 {
 	struct crypto_alg *alg;
 
@@ -503,6 +502,7 @@ static struct crypto_alg *crypto_lookup_aead(const char *name, u32 type,
 
 	return ERR_PTR(crypto_nivaead_default(alg, type, mask));
 }
+EXPORT_SYMBOL_GPL(crypto_lookup_aead);
 
 int crypto_grab_aead(struct crypto_aead_spawn *spawn, const char *name,
 		     u32 type, u32 mask)
diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index 3e61cc1..38534aa 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -24,6 +24,9 @@
 #include <net/netlink.h>
 #include <linux/security.h>
 #include <net/net_namespace.h>
+#include <crypto/internal/aead.h>
+#include <crypto/internal/skcipher.h>
+
 #include "internal.h"
 
 DEFINE_MUTEX(crypto_cfg_mutex);
@@ -301,6 +304,60 @@ static int crypto_del_alg(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return crypto_unregister_instance(alg);
 }
 
+static struct crypto_alg *crypto_user_skcipher_alg(const char *name, u32 type,
+						   u32 mask)
+{
+	int err;
+	struct crypto_alg *alg;
+
+	type = crypto_skcipher_type(type);
+	mask = crypto_skcipher_mask(mask);
+
+	for (;;) {
+		alg = crypto_lookup_skcipher(name,  type, mask);
+		if (!IS_ERR(alg))
+			return alg;
+
+		err = PTR_ERR(alg);
+		if (err != -EAGAIN)
+			break;
+		if (signal_pending(current)) {
+			err = -EINTR;
+			break;
+		}
+	}
+
+	return ERR_PTR(err);
+}
+
+static struct crypto_alg *crypto_user_aead_alg(const char *name, u32 type,
+					       u32 mask)
+{
+	int err;
+	struct crypto_alg *alg;
+
+	type &= ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV);
+	type |= CRYPTO_ALG_TYPE_AEAD;
+	mask &= ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV);
+	mask |= CRYPTO_ALG_TYPE_MASK;
+
+	for (;;) {
+		alg = crypto_lookup_aead(name,  type, mask);
+		if (!IS_ERR(alg))
+			return alg;
+
+		err = PTR_ERR(alg);
+		if (err != -EAGAIN)
+			break;
+		if (signal_pending(current)) {
+			err = -EINTR;
+			break;
+		}
+	}
+
+	return ERR_PTR(err);
+}
+
 static int crypto_add_alg(struct sk_buff *skb, struct nlmsghdr *nlh,
 			  struct nlattr **attrs)
 {
@@ -325,7 +382,19 @@ static int crypto_add_alg(struct sk_buff *skb, struct nlmsghdr *nlh,
 	else
 		name = p->cru_name;
 
-	alg = crypto_alg_mod_lookup(name, p->cru_type, p->cru_mask);
+	switch (p->cru_type & p->cru_mask & CRYPTO_ALG_TYPE_MASK) {
+	case CRYPTO_ALG_TYPE_AEAD:
+		alg = crypto_user_aead_alg(name, p->cru_type, p->cru_mask);
+		break;
+	case CRYPTO_ALG_TYPE_GIVCIPHER:
+	case CRYPTO_ALG_TYPE_BLKCIPHER:
+	case CRYPTO_ALG_TYPE_ABLKCIPHER:
+		alg = crypto_user_skcipher_alg(name, p->cru_type, p->cru_mask);
+		break;
+	default:
+		alg = crypto_alg_mod_lookup(name, p->cru_type, p->cru_mask);
+	}
+
 	if (IS_ERR(alg))
 		return PTR_ERR(alg);
 
diff --git a/include/crypto/internal/aead.h b/include/crypto/internal/aead.h
index d838c94..2eba340 100644
--- a/include/crypto/internal/aead.h
+++ b/include/crypto/internal/aead.h
@@ -31,6 +31,8 @@ static inline void crypto_set_aead_spawn(
 	crypto_set_spawn(&spawn->base, inst);
 }
 
+struct crypto_alg *crypto_lookup_aead(const char *name, u32 type, u32 mask);
+
 int crypto_grab_aead(struct crypto_aead_spawn *spawn, const char *name,
 		     u32 type, u32 mask);
 
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index 3a748a6..06e8b32 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -34,6 +34,8 @@ static inline void crypto_set_skcipher_spawn(
 int crypto_grab_skcipher(struct crypto_skcipher_spawn *spawn, const char *name,
 			 u32 type, u32 mask);
 
+struct crypto_alg *crypto_lookup_skcipher(const char *name, u32 type, u32 mask);
+
 static inline void crypto_drop_skcipher(struct crypto_skcipher_spawn *spawn)
 {
 	crypto_drop_spawn(&spawn->base);
-- 
1.7.0.4
