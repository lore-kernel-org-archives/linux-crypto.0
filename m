From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6/16] crypto: api - Add crypto_attr_alg2 helper
Date: Thu, 09 Jul 2009 12:53:52 +0800
Message-ID: <E1MOldo-0005WH-2E@gondolin.me.apana.org.au>
References: <20090709045052.GA21092@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44862 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751876AbZGIExy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Jul 2009 00:53:54 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MOldo-0006Dm-Ek
	for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2009 14:53:52 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: api - Add crypto_attr_alg2 helper

This patch adds the helper crypto_attr_alg2 which is similar to
crypto_attr_alg but takes an extra frontend argument.  This is
intended to be used by new style algorithm types such as shash.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/algapi.c         |    8 +++++---
 crypto/api.c            |   31 ++++++++++++++++++++++---------
 crypto/internal.h       |    3 +++
 include/crypto/algapi.h |   11 ++++++++++-
 4 files changed, 40 insertions(+), 13 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 17a5fff..2154815 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -644,7 +644,9 @@ const char *crypto_attr_alg_name(struct rtattr *rta)
 }
 EXPORT_SYMBOL_GPL(crypto_attr_alg_name);
 
-struct crypto_alg *crypto_attr_alg(struct rtattr *rta, u32 type, u32 mask)
+struct crypto_alg *crypto_attr_alg2(struct rtattr *rta,
+				    const struct crypto_type *frontend,
+				    u32 type, u32 mask)
 {
 	const char *name;
 	int err;
@@ -654,9 +656,9 @@ struct crypto_alg *crypto_attr_alg(struct rtattr *rta, u32 type, u32 mask)
 	if (IS_ERR(name))
 		return ERR_PTR(err);
 
-	return crypto_alg_mod_lookup(name, type, mask);
+	return crypto_find_alg(name, frontend, type, mask);
 }
-EXPORT_SYMBOL_GPL(crypto_attr_alg);
+EXPORT_SYMBOL_GPL(crypto_attr_alg2);
 
 int crypto_attr_u32(struct rtattr *rta, u32 *num)
 {
diff --git a/crypto/api.c b/crypto/api.c
index d5944f9..ba81221 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -503,6 +503,27 @@ out:
 }
 EXPORT_SYMBOL_GPL(crypto_create_tfm);
 
+struct crypto_alg *crypto_find_alg(const char *alg_name,
+				   const struct crypto_type *frontend,
+				   u32 type, u32 mask)
+{
+	struct crypto_alg *(*lookup)(const char *name, u32 type, u32 mask) =
+		crypto_alg_mod_lookup;
+
+	if (frontend) {
+		type &= frontend->maskclear;
+		mask &= frontend->maskclear;
+		type |= frontend->type;
+		mask |= frontend->maskset;
+
+		if (frontend->lookup)
+			lookup = frontend->lookup;
+	}
+
+	return lookup(alg_name, type, mask);
+}
+EXPORT_SYMBOL_GPL(crypto_find_alg);
+
 /*
  *	crypto_alloc_tfm - Locate algorithm and allocate transform
  *	@alg_name: Name of algorithm
@@ -526,21 +547,13 @@ EXPORT_SYMBOL_GPL(crypto_create_tfm);
 void *crypto_alloc_tfm(const char *alg_name,
 		       const struct crypto_type *frontend, u32 type, u32 mask)
 {
-	struct crypto_alg *(*lookup)(const char *name, u32 type, u32 mask);
 	void *tfm;
 	int err;
 
-	type &= frontend->maskclear;
-	mask &= frontend->maskclear;
-	type |= frontend->type;
-	mask |= frontend->maskset;
-
-	lookup = frontend->lookup ?: crypto_alg_mod_lookup;
-
 	for (;;) {
 		struct crypto_alg *alg;
 
-		alg = lookup(alg_name, type, mask);
+		alg = crypto_find_alg(alg_name, frontend, type, mask);
 		if (IS_ERR(alg)) {
 			err = PTR_ERR(alg);
 			goto err;
diff --git a/crypto/internal.h b/crypto/internal.h
index 95baaea..7efa4d0 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -106,6 +106,9 @@ struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
 				      u32 mask);
 void *crypto_create_tfm(struct crypto_alg *alg,
 			const struct crypto_type *frontend);
+struct crypto_alg *crypto_find_alg(const char *alg_name,
+				   const struct crypto_type *frontend,
+				   u32 type, u32 mask);
 void *crypto_alloc_tfm(const char *alg_name,
 		       const struct crypto_type *frontend, u32 type, u32 mask);
 
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index c9bff92..1d15a92 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -136,7 +136,16 @@ static inline void crypto_set_spawn(struct crypto_spawn *spawn,
 struct crypto_attr_type *crypto_get_attr_type(struct rtattr **tb);
 int crypto_check_attr_type(struct rtattr **tb, u32 type);
 const char *crypto_attr_alg_name(struct rtattr *rta);
-struct crypto_alg *crypto_attr_alg(struct rtattr *rta, u32 type, u32 mask);
+struct crypto_alg *crypto_attr_alg2(struct rtattr *rta,
+				    const struct crypto_type *frontend,
+				    u32 type, u32 mask);
+
+static inline struct crypto_alg *crypto_attr_alg(struct rtattr *rta,
+						 u32 type, u32 mask)
+{
+	return crypto_attr_alg2(rta, NULL, type, mask);
+}
+
 int crypto_attr_u32(struct rtattr *rta, u32 *num);
 void *crypto_alloc_instance2(const char *name, struct crypto_alg *alg,
 			     unsigned int head);
