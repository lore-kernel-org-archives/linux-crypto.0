From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/16] crypto: api - Add crypto_alloc_instance2
Date: Thu, 09 Jul 2009 12:53:47 +0800
Message-ID: <E1MOldj-0005Vh-Nt@gondolin.me.apana.org.au>
References: <20090709045052.GA21092@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44857 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751399AbZGIExt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Jul 2009 00:53:49 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MOldk-0006DD-0u
	for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2009 14:53:48 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: api - Add crypto_alloc_instance2

This patch adds a new argument to crypto_alloc_instance which
sets aside some space before the instance for use by algorithms
such as shash that place type-specific data before crypto_alg.

For compatibility the function has been renamed so that existing
users aren't affected.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/algapi.c         |   37 +++++++++++++++++++++++++++++++------
 include/crypto/algapi.h |    2 ++
 2 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 56c62e2..429f1a0 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -627,17 +627,20 @@ int crypto_attr_u32(struct rtattr *rta, u32 *num)
 }
 EXPORT_SYMBOL_GPL(crypto_attr_u32);
 
-struct crypto_instance *crypto_alloc_instance(const char *name,
-					      struct crypto_alg *alg)
+void *crypto_alloc_instance2(const char *name, struct crypto_alg *alg,
+			     unsigned int head)
 {
 	struct crypto_instance *inst;
-	struct crypto_spawn *spawn;
+	char *p;
 	int err;
 
-	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
-	if (!inst)
+	p = kzalloc(head + sizeof(*inst) + sizeof(struct crypto_spawn),
+		    GFP_KERNEL);
+	if (!p)
 		return ERR_PTR(-ENOMEM);
 
+	inst = (void *)(p + head);
+
 	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.cra_name, CRYPTO_MAX_ALG_NAME, "%s(%s)", name,
 		     alg->cra_name) >= CRYPTO_MAX_ALG_NAME)
@@ -647,6 +650,25 @@ struct crypto_instance *crypto_alloc_instance(const char *name,
 		     name, alg->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
+	return p;
+
+err_free_inst:
+	kfree(p);
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL_GPL(crypto_alloc_instance2);
+
+struct crypto_instance *crypto_alloc_instance(const char *name,
+					      struct crypto_alg *alg)
+{
+	struct crypto_instance *inst;
+	struct crypto_spawn *spawn;
+	int err;
+
+	inst = crypto_alloc_instance2(name, alg, 0);
+	if (IS_ERR(inst))
+		goto out;
+
 	spawn = crypto_instance_ctx(inst);
 	err = crypto_init_spawn(spawn, alg, inst,
 				CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_ASYNC);
@@ -658,7 +680,10 @@ struct crypto_instance *crypto_alloc_instance(const char *name,
 
 err_free_inst:
 	kfree(inst);
-	return ERR_PTR(err);
+	inst = ERR_PTR(err);
+
+out:
+	return inst;
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_instance);
 
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index ce010a3..99bb297 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -132,6 +132,8 @@ int crypto_check_attr_type(struct rtattr **tb, u32 type);
 const char *crypto_attr_alg_name(struct rtattr *rta);
 struct crypto_alg *crypto_attr_alg(struct rtattr *rta, u32 type, u32 mask);
 int crypto_attr_u32(struct rtattr *rta, u32 *num);
+void *crypto_alloc_instance2(const char *name, struct crypto_alg *alg,
+			     unsigned int head);
 struct crypto_instance *crypto_alloc_instance(const char *name,
 					      struct crypto_alg *alg);
 
