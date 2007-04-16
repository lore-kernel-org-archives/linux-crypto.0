From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/6] [CRYPTO] templates: Pass type/mask when creating instances
Date: Mon, 16 Apr 2007 20:52:16 +1000
Message-ID: <E1HdOoi-0002u4-00@gondolin.me.apana.org.au>
References: <<20070416105105.GA10188@gondor.apana.org.au>>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4918 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030342AbXDPKwT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Apr 2007 06:52:19 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1HdOoi-0004bH-Hi
	for <linux-crypto@vger.kernel.org>; Mon, 16 Apr 2007 20:52:16 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1HdOoi-0002u4-00
	for <linux-crypto@vger.kernel.org>; Mon, 16 Apr 2007 20:52:16 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] templates: Pass type/mask when creating instances

This patch passes the type/mask along when constructing instances of
templates.  This is in preparation for templates that may support
multiple types of instances depending on what is requested.  For example,
the planned software async crypto driver will use this construct.

For the moment this allows us to check whether the instance constructed
is of the correct type and avoid returning success if the type does not
match.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/algapi.c         |   42 ++++++++++++++++++++++++++++++++++++------
 crypto/cbc.c            |   11 ++++++++---
 crypto/cryptomgr.c      |   28 ++++++++++++++++++----------
 crypto/ecb.c            |   11 ++++++++---
 crypto/hmac.c           |   11 ++++++++---
 crypto/lrw.c            |   11 ++++++++---
 crypto/pcbc.c           |   11 ++++++++---
 crypto/xcbc.c           |   12 +++++++++---
 include/crypto/algapi.h |    8 +++++---
 include/linux/crypto.h  |    9 +++++++++
 10 files changed, 117 insertions(+), 37 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -425,15 +425,45 @@ int crypto_unregister_notifier(struct no
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_notifier);
 
-struct crypto_alg *crypto_get_attr_alg(void *param, unsigned int len,
-				       u32 type, u32 mask)
+struct crypto_attr_type *crypto_get_attr_type(struct rtattr **tb)
 {
-	struct rtattr *rta = param;
+	struct rtattr *rta = tb[CRYPTOA_TYPE - 1];
+	struct crypto_attr_type *algt;
+
+	if (!rta)
+		return ERR_PTR(-ENOENT);
+	if (RTA_PAYLOAD(rta) < sizeof(*algt))
+		return ERR_PTR(-EINVAL);
+
+	algt = RTA_DATA(rta);
+
+	return algt;
+}
+EXPORT_SYMBOL_GPL(crypto_get_attr_type);
+
+int crypto_check_attr_type(struct rtattr **tb, u32 type)
+{
+	struct crypto_attr_type *algt;
+
+	algt = crypto_get_attr_type(tb);
+	if (IS_ERR(algt))
+		return PTR_ERR(algt);
+
+	if ((algt->type ^ type) & algt->mask)
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(crypto_check_attr_type);
+
+struct crypto_alg *crypto_get_attr_alg(struct rtattr **tb, u32 type, u32 mask)
+{
+	struct rtattr *rta = tb[CRYPTOA_ALG - 1];
 	struct crypto_attr_alg *alga;
 
-	if (!RTA_OK(rta, len))
-		return ERR_PTR(-EBADR);
-	if (rta->rta_type != CRYPTOA_ALG || RTA_PAYLOAD(rta) < sizeof(*alga))
+	if (!rta)
+		return ERR_PTR(-ENOENT);
+	if (RTA_PAYLOAD(rta) < sizeof(*alga))
 		return ERR_PTR(-EINVAL);
 
 	alga = RTA_DATA(rta);
diff --git a/crypto/cbc.c b/crypto/cbc.c
--- a/crypto/cbc.c
+++ b/crypto/cbc.c
@@ -275,13 +275,18 @@ static void crypto_cbc_exit_tfm(struct c
 	crypto_free_cipher(ctx->child);
 }
 
-static struct crypto_instance *crypto_cbc_alloc(void *param, unsigned int len)
+static struct crypto_instance *crypto_cbc_alloc(struct rtattr **tb)
 {
 	struct crypto_instance *inst;
 	struct crypto_alg *alg;
+	int err;
 
-	alg = crypto_get_attr_alg(param, len, CRYPTO_ALG_TYPE_CIPHER,
-				  CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_ASYNC);
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_BLKCIPHER);
+	if (err)
+		return ERR_PTR(err);
+
+	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
+				  CRYPTO_ALG_TYPE_MASK);
 	if (IS_ERR(alg))
 		return ERR_PTR(PTR_ERR(alg));
 
diff --git a/crypto/cryptomgr.c b/crypto/cryptomgr.c
--- a/crypto/cryptomgr.c
+++ b/crypto/cryptomgr.c
@@ -26,14 +26,19 @@
 struct cryptomgr_param {
 	struct work_struct work;
 
+	struct rtattr *tb[CRYPTOA_MAX];
+
+	struct {
+		struct rtattr attr;
+		struct crypto_attr_type data;
+	} type;
+
 	struct {
 		struct rtattr attr;
 		struct crypto_attr_alg data;
 	} alg;
 
 	struct {
-		u32 type;
-		u32 mask;
 		char name[CRYPTO_MAX_ALG_NAME];
 	} larval;
 
@@ -53,7 +58,7 @@ static void cryptomgr_probe(struct work_
 		goto err;
 
 	do {
-		inst = tmpl->alloc(&param->alg, sizeof(param->alg));
+		inst = tmpl->alloc(param->tb);
 		if (IS_ERR(inst))
 			err = PTR_ERR(inst);
 		else if ((err = crypto_register_instance(tmpl, inst)))
@@ -70,8 +75,8 @@ out:
 	return;
 
 err:
-	crypto_larval_error(param->larval.name, param->larval.type,
-			    param->larval.mask);
+	crypto_larval_error(param->larval.name, param->type.data.type,
+			    param->type.data.mask);
 	goto out;
 }
 
@@ -82,7 +87,7 @@ static int cryptomgr_schedule_probe(stru
 	const char *p;
 	unsigned int len;
 
-	param = kmalloc(sizeof(*param), GFP_KERNEL);
+	param = kzalloc(sizeof(*param), GFP_KERNEL);
 	if (!param)
 		goto err;
 
@@ -94,7 +99,6 @@ static int cryptomgr_schedule_probe(stru
 		goto err_free_param;
 
 	memcpy(param->template, name, len);
-	param->template[len] = 0;
 
 	name = p + 1;
 	for (p = name; isalnum(*p) || *p == '-' || *p == '_'; p++)
@@ -104,14 +108,18 @@ static int cryptomgr_schedule_probe(stru
 	if (!len || *p != ')' || p[1])
 		goto err_free_param;
 
+	param->type.attr.rta_len = sizeof(param->type);
+	param->type.attr.rta_type = CRYPTOA_TYPE;
+	param->type.data.type = larval->alg.cra_flags;
+	param->type.data.mask = larval->mask;
+	param->tb[CRYPTOA_TYPE - 1] = &param->type.attr;
+
 	param->alg.attr.rta_len = sizeof(param->alg);
 	param->alg.attr.rta_type = CRYPTOA_ALG;
 	memcpy(param->alg.data.name, name, len);
-	param->alg.data.name[len] = 0;
+	param->tb[CRYPTOA_ALG - 1] = &param->alg.attr;
 
 	memcpy(param->larval.name, larval->alg.cra_name, CRYPTO_MAX_ALG_NAME);
-	param->larval.type = larval->alg.cra_flags;
-	param->larval.mask = larval->mask;
 
 	INIT_WORK(&param->work, cryptomgr_probe);
 	schedule_work(&param->work);
diff --git a/crypto/ecb.c b/crypto/ecb.c
--- a/crypto/ecb.c
+++ b/crypto/ecb.c
@@ -115,13 +115,18 @@ static void crypto_ecb_exit_tfm(struct c
 	crypto_free_cipher(ctx->child);
 }
 
-static struct crypto_instance *crypto_ecb_alloc(void *param, unsigned int len)
+static struct crypto_instance *crypto_ecb_alloc(struct rtattr **tb)
 {
 	struct crypto_instance *inst;
 	struct crypto_alg *alg;
+	int err;
 
-	alg = crypto_get_attr_alg(param, len, CRYPTO_ALG_TYPE_CIPHER,
-				  CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_ASYNC);
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_BLKCIPHER);
+	if (err)
+		return ERR_PTR(err);
+
+	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
+				  CRYPTO_ALG_TYPE_MASK);
 	if (IS_ERR(alg))
 		return ERR_PTR(PTR_ERR(alg));
 
diff --git a/crypto/hmac.c b/crypto/hmac.c
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -197,13 +197,18 @@ static void hmac_free(struct crypto_inst
 	kfree(inst);
 }
 
-static struct crypto_instance *hmac_alloc(void *param, unsigned int len)
+static struct crypto_instance *hmac_alloc(struct rtattr **tb)
 {
 	struct crypto_instance *inst;
 	struct crypto_alg *alg;
+	int err;
 
-	alg = crypto_get_attr_alg(param, len, CRYPTO_ALG_TYPE_HASH,
-				  CRYPTO_ALG_TYPE_HASH_MASK | CRYPTO_ALG_ASYNC);
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_HASH);
+	if (err)
+		return ERR_PTR(err);
+
+	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_HASH,
+				  CRYPTO_ALG_TYPE_HASH_MASK);
 	if (IS_ERR(alg))
 		return ERR_PTR(PTR_ERR(alg));
 
diff --git a/crypto/lrw.c b/crypto/lrw.c
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -228,13 +228,18 @@ static void exit_tfm(struct crypto_tfm *
 	crypto_free_cipher(ctx->child);
 }
 
-static struct crypto_instance *alloc(void *param, unsigned int len)
+static struct crypto_instance *alloc(struct rtattr **tb)
 {
 	struct crypto_instance *inst;
 	struct crypto_alg *alg;
+	int err;
 
-	alg = crypto_get_attr_alg(param, len, CRYPTO_ALG_TYPE_CIPHER,
-				  CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_ASYNC);
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_BLKCIPHER);
+	if (err)
+		return ERR_PTR(err);
+
+	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
+				  CRYPTO_ALG_TYPE_MASK);
 	if (IS_ERR(alg))
 		return ERR_PTR(PTR_ERR(alg));
 
diff --git a/crypto/pcbc.c b/crypto/pcbc.c
--- a/crypto/pcbc.c
+++ b/crypto/pcbc.c
@@ -279,13 +279,18 @@ static void crypto_pcbc_exit_tfm(struct 
 	crypto_free_cipher(ctx->child);
 }
 
-static struct crypto_instance *crypto_pcbc_alloc(void *param, unsigned int len)
+static struct crypto_instance *crypto_pcbc_alloc(struct rtattr **tb)
 {
 	struct crypto_instance *inst;
 	struct crypto_alg *alg;
+	int err;
 
-	alg = crypto_get_attr_alg(param, len, CRYPTO_ALG_TYPE_CIPHER,
-				  CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_ASYNC);
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_BLKCIPHER);
+	if (err)
+		return ERR_PTR(err);
+
+	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
+				  CRYPTO_ALG_TYPE_MASK);
 	if (IS_ERR(alg))
 		return ERR_PTR(PTR_ERR(alg));
 
diff --git a/crypto/xcbc.c b/crypto/xcbc.c
--- a/crypto/xcbc.c
+++ b/crypto/xcbc.c
@@ -288,12 +288,18 @@ static void xcbc_exit_tfm(struct crypto_
 	crypto_free_cipher(ctx->child);
 }
 
-static struct crypto_instance *xcbc_alloc(void *param, unsigned int len)
+static struct crypto_instance *xcbc_alloc(struct rtattr **tb)
 {
 	struct crypto_instance *inst;
 	struct crypto_alg *alg;
-	alg = crypto_get_attr_alg(param, len, CRYPTO_ALG_TYPE_CIPHER,
-				  CRYPTO_ALG_TYPE_HASH_MASK | CRYPTO_ALG_ASYNC);
+	int err;
+
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_HASH);
+	if (err)
+		return ERR_PTR(err);
+
+	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
+				  CRYPTO_ALG_TYPE_MASK);
 	if (IS_ERR(alg))
 		return ERR_PTR(PTR_ERR(alg));
 
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -15,6 +15,7 @@
 #include <linux/crypto.h>
 
 struct module;
+struct rtattr;
 struct seq_file;
 
 struct crypto_type {
@@ -38,7 +39,7 @@ struct crypto_template {
 	struct hlist_head instances;
 	struct module *module;
 
-	struct crypto_instance *(*alloc)(void *param, unsigned int len);
+	struct crypto_instance *(*alloc)(struct rtattr **tb);
 	void (*free)(struct crypto_instance *inst);
 
 	char name[CRYPTO_MAX_ALG_NAME];
@@ -96,8 +97,9 @@ void crypto_drop_spawn(struct crypto_spa
 struct crypto_tfm *crypto_spawn_tfm(struct crypto_spawn *spawn, u32 type,
 				    u32 mask);
 
-struct crypto_alg *crypto_get_attr_alg(void *param, unsigned int len,
-				       u32 type, u32 mask);
+struct crypto_attr_type *crypto_get_attr_type(struct rtattr **tb);
+int crypto_check_attr_type(struct rtattr **tb, u32 type);
+struct crypto_alg *crypto_get_attr_alg(struct rtattr **tb, u32 type, u32 mask);
 struct crypto_instance *crypto_alloc_instance(const char *name,
 					      struct crypto_alg *alg);
 
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -372,12 +372,21 @@ struct crypto_hash {
 enum {
 	CRYPTOA_UNSPEC,
 	CRYPTOA_ALG,
+	CRYPTOA_TYPE,
+	__CRYPTOA_MAX,
 };
 
+#define CRYPTOA_MAX (__CRYPTOA_MAX - 1)
+
 struct crypto_attr_alg {
 	char name[CRYPTO_MAX_ALG_NAME];
 };
 
+struct crypto_attr_type {
+	u32 type;
+	u32 mask;
+};
+
 /* 
  * Transform user interface.
  */
