From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/8] [CRYPTO] api: Add support for multiple template parameters
Date: Thu, 30 Aug 2007 16:41:18 +0800
Message-ID: <E1IQfaY-0004BH-00@gondolin.me.apana.org.au>
References: <20070830083900.GA15936@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Thomas Graf <tgraf@suug.ch>,
	Herbgert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1403 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756142AbXH3IlW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Aug 2007 04:41:22 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] api: Add support for multiple template parameters

This patch adds support for having multiple parameters to
a template, separated by a comma.  It also adds support
for integer parameters in addition to the current algorithm
parameter type.

This will be used by the authenc template which will have
four parameters: the authentication algorithm, the encryption
algorithm, the authentication size and the encryption key
length.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/algapi.c        |    8 +++-
 crypto/cryptomgr.c     |   95 ++++++++++++++++++++++++++++++++++++-------------
 include/linux/crypto.h |    8 ++++
 3 files changed, 84 insertions(+), 27 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 38aa9e9..d955960 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -439,13 +439,15 @@ EXPORT_SYMBOL_GPL(crypto_unregister_notifier);
 
 struct crypto_attr_type *crypto_get_attr_type(struct rtattr **tb)
 {
-	struct rtattr *rta = tb[CRYPTOA_TYPE - 1];
+	struct rtattr *rta = tb[0];
 	struct crypto_attr_type *algt;
 
 	if (!rta)
 		return ERR_PTR(-ENOENT);
 	if (RTA_PAYLOAD(rta) < sizeof(*algt))
 		return ERR_PTR(-EINVAL);
+	if (rta->rta_type != CRYPTOA_TYPE)
+		return ERR_PTR(-EINVAL);
 
 	algt = RTA_DATA(rta);
 
@@ -470,13 +472,15 @@ EXPORT_SYMBOL_GPL(crypto_check_attr_type);
 
 struct crypto_alg *crypto_get_attr_alg(struct rtattr **tb, u32 type, u32 mask)
 {
-	struct rtattr *rta = tb[CRYPTOA_ALG - 1];
+	struct rtattr *rta = tb[1];
 	struct crypto_attr_alg *alga;
 
 	if (!rta)
 		return ERR_PTR(-ENOENT);
 	if (RTA_PAYLOAD(rta) < sizeof(*alga))
 		return ERR_PTR(-EINVAL);
+	if (rta->rta_type != CRYPTOA_ALG)
+		return ERR_PTR(-EINVAL);
 
 	alga = RTA_DATA(rta);
 	alga->name[CRYPTO_MAX_ALG_NAME - 1] = 0;
diff --git a/crypto/cryptomgr.c b/crypto/cryptomgr.c
index e5fb7cc..c83884f 100644
--- a/crypto/cryptomgr.c
+++ b/crypto/cryptomgr.c
@@ -24,22 +24,26 @@
 #include "internal.h"
 
 struct cryptomgr_param {
-	struct rtattr *tb[CRYPTOA_MAX];
+	struct rtattr *tb[CRYPTO_MAX_ATTRS + 2];
 
 	struct {
 		struct rtattr attr;
 		struct crypto_attr_type data;
 	} type;
 
-	struct {
+	union {
 		struct rtattr attr;
-		struct crypto_attr_alg data;
-	} alg;
-
-	struct {
-		char name[CRYPTO_MAX_ALG_NAME];
-	} larval;
-
+		struct {
+			struct rtattr attr;
+			struct crypto_attr_alg data;
+		} alg;
+		struct {
+			struct rtattr attr;
+			struct crypto_attr_u32 data;
+		} nu32;
+	} attrs[CRYPTO_MAX_ATTRS];
+
+	char larval[CRYPTO_MAX_ALG_NAME];
 	char template[CRYPTO_MAX_ALG_NAME];
 };
 
@@ -72,7 +76,7 @@ out:
 	module_put_and_exit(0);
 
 err:
-	crypto_larval_error(param->larval.name, param->type.data.type,
+	crypto_larval_error(param->larval, param->type.data.type,
 			    param->type.data.mask);
 	goto out;
 }
@@ -84,6 +88,7 @@ static int cryptomgr_schedule_probe(struct crypto_larval *larval)
 	const char *name = larval->alg.cra_name;
 	const char *p;
 	unsigned int len;
+	int i;
 
 	if (!try_module_get(THIS_MODULE))
 		goto err;
@@ -101,33 +106,73 @@ static int cryptomgr_schedule_probe(struct crypto_larval *larval)
 
 	memcpy(param->template, name, len);
 
-	name = p + 1;
-	len = 0;
-	for (p = name; *p; p++) {
-		for (; isalnum(*p) || *p == '-' || *p == '_' || *p == '('; p++)
-			;
+	i = 0;
+	for (;;) {
+		int notnum = 0;
 
-		if (*p != ')')
-			goto err_free_param;
+		name = ++p;
+		len = 0;
+
+		for (; isalnum(*p) || *p == '-' || *p == '_'; p++)
+			notnum |= !isdigit(*p);
+
+		if (*p == '(') {
+			int recursion = 0;
+
+			for (;;) {
+				if (!*++p)
+					goto err_free_param;
+				if (*p == '(')
+					recursion++;
+				else if (*p == ')' && !recursion--)
+					break;
+			}
+
+			notnum = 1;
+		}
 
 		len = p - name;
+		if (!len)
+			goto err_free_param;
+
+		if (notnum) {
+			param->attrs[i].alg.attr.rta_len =
+				sizeof(param->attrs[i].alg);
+			param->attrs[i].alg.attr.rta_type = CRYPTOA_ALG;
+			memcpy(param->attrs[i].alg.data.name, name, len);
+		} else {
+			param->attrs[i].nu32.attr.rta_len =
+				sizeof(param->attrs[i].nu32);
+			param->attrs[i].nu32.attr.rta_type = CRYPTOA_U32;
+			param->attrs[i].nu32.data.num =
+				simple_strtol(name, NULL, 0);
+		}
+
+		param->tb[i + 1] = &param->attrs[i].attr;
+		i++;
+
+		if (WARN_ON(i >= CRYPTO_MAX_ATTRS))
+			goto err_free_param;
+
+		if (*p == ')')
+			break;
+
+		if (*p != ',')
+			goto err_free_param;
 	}
 
-	if (!len || name[len + 1])
+	if (!i)
 		goto err_free_param;
 
+	param->tb[i + 1] = NULL;
+
 	param->type.attr.rta_len = sizeof(param->type);
 	param->type.attr.rta_type = CRYPTOA_TYPE;
 	param->type.data.type = larval->alg.cra_flags;
 	param->type.data.mask = larval->mask;
-	param->tb[CRYPTOA_TYPE - 1] = &param->type.attr;
-
-	param->alg.attr.rta_len = sizeof(param->alg);
-	param->alg.attr.rta_type = CRYPTOA_ALG;
-	memcpy(param->alg.data.name, name, len);
-	param->tb[CRYPTOA_ALG - 1] = &param->alg.attr;
+	param->tb[0] = &param->type.attr;
 
-	memcpy(param->larval.name, larval->alg.cra_name, CRYPTO_MAX_ALG_NAME);
+	memcpy(param->larval, larval->alg.cra_name, CRYPTO_MAX_ALG_NAME);
 
 	thread = kthread_run(cryptomgr_probe, param, "cryptomgr");
 	if (IS_ERR(thread))
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 1072f9a..da09b4a 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -425,11 +425,15 @@ enum {
 	CRYPTOA_UNSPEC,
 	CRYPTOA_ALG,
 	CRYPTOA_TYPE,
+	CRYPTOA_U32,
 	__CRYPTOA_MAX,
 };
 
 #define CRYPTOA_MAX (__CRYPTOA_MAX - 1)
 
+/* Maximum number of (rtattr) parameters for each template. */
+#define CRYPTO_MAX_ATTRS 32
+
 struct crypto_attr_alg {
 	char name[CRYPTO_MAX_ALG_NAME];
 };
@@ -439,6 +443,10 @@ struct crypto_attr_type {
 	u32 mask;
 };
 
+struct crypto_attr_u32 {
+	u32 num;
+};
+
 /* 
  * Transform user interface.
  */
