From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7/8] [CRYPTO] api: Add crypto_attr_alg_name
Date: Tue, 11 Dec 2007 11:50:26 +0800
Message-ID: <E1J1w8Y-0002el-00@gondolin.me.apana.org.au>
References: <20071211034945.GA10099@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1779 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751859AbXLKDuf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Dec 2007 22:50:35 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J1w8Z-0005pn-Jv
	for <linux-crypto@vger.kernel.org>; Tue, 11 Dec 2007 14:50:28 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] api: Add crypto_attr_alg_name

This patch adds a new helper crypto_attr_alg_name which is basically the
first half of crypto_attr_alg.  That is, it returns an algorithm name
parameter as a string without looking it up.  The caller can then look it
up immediately or defer it until later.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/algapi.c         |   18 ++++++++++++++++--
 include/crypto/algapi.h |    1 +
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 08eca6d..e65cb50 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -472,7 +472,7 @@ int crypto_check_attr_type(struct rtattr **tb, u32 type)
 }
 EXPORT_SYMBOL_GPL(crypto_check_attr_type);
 
-struct crypto_alg *crypto_attr_alg(struct rtattr *rta, u32 type, u32 mask)
+const char *crypto_attr_alg_name(struct rtattr *rta)
 {
 	struct crypto_attr_alg *alga;
 
@@ -486,7 +486,21 @@ struct crypto_alg *crypto_attr_alg(struct rtattr *rta, u32 type, u32 mask)
 	alga = RTA_DATA(rta);
 	alga->name[CRYPTO_MAX_ALG_NAME - 1] = 0;
 
-	return crypto_alg_mod_lookup(alga->name, type, mask);
+	return alga->name;
+}
+EXPORT_SYMBOL_GPL(crypto_attr_alg_name);
+
+struct crypto_alg *crypto_attr_alg(struct rtattr *rta, u32 type, u32 mask)
+{
+	const char *name;
+	int err;
+
+	name = crypto_attr_alg_name(rta);
+	err = PTR_ERR(name);
+	if (IS_ERR(name))
+		return ERR_PTR(err);
+
+	return crypto_alg_mod_lookup(name, type, mask);
 }
 EXPORT_SYMBOL_GPL(crypto_attr_alg);
 
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 2cdb227..726a765 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -113,6 +113,7 @@ struct crypto_tfm *crypto_spawn_tfm(struct crypto_spawn *spawn, u32 type,
 
 struct crypto_attr_type *crypto_get_attr_type(struct rtattr **tb);
 int crypto_check_attr_type(struct rtattr **tb, u32 type);
+const char *crypto_attr_alg_name(struct rtattr *rta);
 struct crypto_alg *crypto_attr_alg(struct rtattr *rta, u32 type, u32 mask);
 int crypto_attr_u32(struct rtattr *rta, u32 *num);
 struct crypto_instance *crypto_alloc_instance(const char *name,
