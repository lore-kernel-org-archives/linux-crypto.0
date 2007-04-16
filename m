From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/6] [CRYPTO] cryptomgr: Fix parsing of nested templates
Date: Mon, 16 Apr 2007 20:52:18 +1000
Message-ID: <E1HdOok-0002uC-00@gondolin.me.apana.org.au>
References: <<20070416105105.GA10188@gondor.apana.org.au>>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4922 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030342AbXDPKwU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Apr 2007 06:52:20 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1HdOok-0004bR-Oc
	for <linux-crypto@vger.kernel.org>; Mon, 16 Apr 2007 20:52:18 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1HdOok-0002uC-00
	for <linux-crypto@vger.kernel.org>; Mon, 16 Apr 2007 20:52:18 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] cryptomgr: Fix parsing of nested templates 

This patch allows the use of nested templates by allowing the use of
brackets inside a template parameter.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/cryptomgr.c |   38 +++++++++++++++++++++++++-------------
 1 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/crypto/cryptomgr.c b/crypto/cryptomgr.c
--- a/crypto/cryptomgr.c
+++ b/crypto/cryptomgr.c
@@ -14,17 +14,17 @@
 #include <linux/ctype.h>
 #include <linux/err.h>
 #include <linux/init.h>
+#include <linux/kthread.h>
 #include <linux/module.h>
 #include <linux/notifier.h>
 #include <linux/rtnetlink.h>
 #include <linux/sched.h>
 #include <linux/string.h>
-#include <linux/workqueue.h>
 
 #include "internal.h"
 
 struct cryptomgr_param {
-	struct work_struct work;
+	struct task_struct *thread;
 
 	struct rtattr *tb[CRYPTOA_MAX];
 
@@ -45,10 +45,9 @@ struct cryptomgr_param {
 	char template[CRYPTO_MAX_ALG_NAME];
 };
 
-static void cryptomgr_probe(struct work_struct *work)
+static int cryptomgr_probe(void *data)
 {
-	struct cryptomgr_param *param =
-		container_of(work, struct cryptomgr_param, work);
+	struct cryptomgr_param *param = data;
 	struct crypto_template *tmpl;
 	struct crypto_instance *inst;
 	int err;
@@ -72,7 +71,7 @@ static void cryptomgr_probe(struct work_
 
 out:
 	kfree(param);
-	return;
+	module_put_and_exit(0);
 
 err:
 	crypto_larval_error(param->larval.name, param->type.data.type,
@@ -87,9 +86,12 @@ static int cryptomgr_schedule_probe(stru
 	const char *p;
 	unsigned int len;
 
+	if (!try_module_get(THIS_MODULE))
+		goto err;
+
 	param = kzalloc(sizeof(*param), GFP_KERNEL);
 	if (!param)
-		goto err;
+		goto err_put_module;
 
 	for (p = name; isalnum(*p) || *p == '-' || *p == '_'; p++)
 		;
@@ -101,11 +103,18 @@ static int cryptomgr_schedule_probe(stru
 	memcpy(param->template, name, len);
 
 	name = p + 1;
-	for (p = name; isalnum(*p) || *p == '-' || *p == '_'; p++)
-		;
+	len = 0;
+	for (p = name; *p; p++) {
+		for (; isalnum(*p) || *p == '-' || *p == '_' || *p == '('; p++)
+			;
 
-	len = p - name;
-	if (!len || *p != ')' || p[1])
+		if (*p != ')')
+			goto err_free_param;
+
+		len = p - name;
+	}
+
+	if (!len || name[len + 1])
 		goto err_free_param;
 
 	param->type.attr.rta_len = sizeof(param->type);
@@ -121,13 +130,16 @@ static int cryptomgr_schedule_probe(stru
 
 	memcpy(param->larval.name, larval->alg.cra_name, CRYPTO_MAX_ALG_NAME);
 
-	INIT_WORK(&param->work, cryptomgr_probe);
-	schedule_work(&param->work);
+	param->thread = kthread_run(cryptomgr_probe, param, "cryptomgr");
+	if (IS_ERR(param->thread))
+		goto err_free_param;
 
 	return NOTIFY_STOP;
 
 err_free_param:
 	kfree(param);
+err_put_module:
+	module_put(THIS_MODULE);
 err:
 	return NOTIFY_OK;
 }
