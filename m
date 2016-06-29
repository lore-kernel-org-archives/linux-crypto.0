From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 26/28] crypto: api - Add crypto_inst_setname
Date: Wed, 29 Jun 2016 18:04:13 +0800
Message-ID: <E1bICLt-0006xq-Mu@gondolin.me.apana.org.au>
References: <20160629100223.GA26260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38012 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbcF2KEQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2016 06:04:16 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bICLt-0005Ou-R3
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jun 2016 20:04:13 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds the helper crypto_inst_setname because the current
helper crypto_alloc_instance2 is no longer useful given that we
now look up the algorithm after we allocate the instance object.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/algapi.c         |   24 +++++++++++++++++-------
 include/crypto/algapi.h |    2 ++
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 731255a..df939b5 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -811,6 +811,21 @@ int crypto_attr_u32(struct rtattr *rta, u32 *num)
 }
 EXPORT_SYMBOL_GPL(crypto_attr_u32);
 
+int crypto_inst_setname(struct crypto_instance *inst, const char *name,
+			struct crypto_alg *alg)
+{
+	if (snprintf(inst->alg.cra_name, CRYPTO_MAX_ALG_NAME, "%s(%s)", name,
+		     alg->cra_name) >= CRYPTO_MAX_ALG_NAME)
+		return -ENAMETOOLONG;
+
+	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s(%s)",
+		     name, alg->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
+		return -ENAMETOOLONG;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(crypto_inst_setname);
+
 void *crypto_alloc_instance2(const char *name, struct crypto_alg *alg,
 			     unsigned int head)
 {
@@ -825,13 +840,8 @@ void *crypto_alloc_instance2(const char *name, struct crypto_alg *alg,
 
 	inst = (void *)(p + head);
 
-	err = -ENAMETOOLONG;
-	if (snprintf(inst->alg.cra_name, CRYPTO_MAX_ALG_NAME, "%s(%s)", name,
-		     alg->cra_name) >= CRYPTO_MAX_ALG_NAME)
-		goto err_free_inst;
-
-	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s(%s)",
-		     name, alg->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
+	err = crypto_inst_setname(inst, name, alg);
+	if (err)
 		goto err_free_inst;
 
 	return p;
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index eeafd21..0483f65 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -244,6 +244,8 @@ static inline struct crypto_alg *crypto_attr_alg(struct rtattr *rta,
 }
 
 int crypto_attr_u32(struct rtattr *rta, u32 *num);
+int crypto_inst_setname(struct crypto_instance *inst, const char *name,
+			struct crypto_alg *alg);
 void *crypto_alloc_instance2(const char *name, struct crypto_alg *alg,
 			     unsigned int head);
 struct crypto_instance *crypto_alloc_instance(const char *name,
