From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/14] crypto: api - Add instance free function to crypto_type
Date: Thu, 09 Jul 2015 07:17:15 +0800
Message-ID: <E1ZCyaZ-0007XD-VS@gondolin.me.apana.org.au>
References: <20150708231330.GA28797@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36336 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbbGHXRS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jul 2015 19:17:18 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1ZCyaa-0005DX-6s
	for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2015 09:17:16 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currently the task of freeing an instance is given to the crypto
template.  However, it has no type information on the instance so
we have to resort to checking type information at runtime.

This patch introduces a free function to crypto_type that will be
used to free an instance.  This can then be used to free an instance
in a type-safe manner.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/algapi.c         |   14 ++++++++++++--
 include/crypto/algapi.h |    2 ++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index ceebfcf..d130b41 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -67,12 +67,22 @@ static int crypto_check_alg(struct crypto_alg *alg)
 	return crypto_set_driver_name(alg);
 }
 
+static void crypto_free_instance(struct crypto_instance *inst)
+{
+	if (!inst->alg.cra_type->free) {
+		inst->tmpl->free(inst);
+		return;
+	}
+
+	inst->alg.cra_type->free(inst);
+}
+
 static void crypto_destroy_instance(struct crypto_alg *alg)
 {
 	struct crypto_instance *inst = (void *)alg;
 	struct crypto_template *tmpl = inst->tmpl;
 
-	tmpl->free(inst);
+	crypto_free_instance(inst);
 	crypto_tmpl_put(tmpl);
 }
 
@@ -481,7 +491,7 @@ void crypto_unregister_template(struct crypto_template *tmpl)
 
 	hlist_for_each_entry_safe(inst, n, list, list) {
 		BUG_ON(atomic_read(&inst->alg.cra_refcnt) != 1);
-		tmpl->free(inst);
+		crypto_free_instance(inst);
 	}
 	crypto_remove_final(&users);
 }
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 9041a84..c9fe145 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -18,6 +18,7 @@
 #include <linux/skbuff.h>
 
 struct crypto_aead;
+struct crypto_instance;
 struct module;
 struct rtattr;
 struct seq_file;
@@ -30,6 +31,7 @@ struct crypto_type {
 	void (*show)(struct seq_file *m, struct crypto_alg *alg);
 	int (*report)(struct sk_buff *skb, struct crypto_alg *alg);
 	struct crypto_alg *(*lookup)(const char *name, u32 type, u32 mask);
+	void (*free)(struct crypto_instance *inst);
 
 	unsigned int type;
 	unsigned int maskclear;
