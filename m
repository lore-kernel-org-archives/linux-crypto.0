From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: algapi - Move larval completion into algboss
Date: Tue, 19 Jun 2012 13:46:12 +0800
Message-ID: <20120619054612.GA31820@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:37883 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751942Ab2FSFqO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Jun 2012 01:46:14 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by fornost.hengli.com.au with esmtp (Exim 4.72 #1 (Debian))
	id 1SgrGW-0000Xv-U2
	for <linux-crypto@vger.kernel.org>; Tue, 19 Jun 2012 15:46:13 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 4.72)
	(envelope-from <herbert@gondor.apana.org.au>)
	id 1SgrGW-0008IO-NN
	for linux-crypto@vger.kernel.org; Tue, 19 Jun 2012 13:46:12 +0800
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

crypto: algapi - Move larval completion into algboss

It has been observed that sometimes the crypto allocation code
will get stuck for 60 seconds or multiples thereof.  This is
usually caused by an algorithm failing to pass the self-test.

If an algorithm fails to be constructed, we will immediately notify
all larval waiters.  However, if it succeeds in construction, but
then fails the self-test, we won't notify anyone at all.

This patch fixes this by merging the notification in the case
where the algorithm fails to be constructed with that of the
the case where it pases the self-test.  This way regardless of
what happens, we'll give the larval waiters an answer.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 056571b..c3b9bfe 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -24,22 +24,6 @@
 
 static LIST_HEAD(crypto_template_list);
 
-void crypto_larval_error(const char *name, u32 type, u32 mask)
-{
-	struct crypto_alg *alg;
-
-	alg = crypto_alg_lookup(name, type, mask);
-
-	if (alg) {
-		if (crypto_is_larval(alg)) {
-			struct crypto_larval *larval = (void *)alg;
-			complete_all(&larval->completion);
-		}
-		crypto_mod_put(alg);
-	}
-}
-EXPORT_SYMBOL_GPL(crypto_larval_error);
-
 static inline int crypto_set_driver_name(struct crypto_alg *alg)
 {
 	static const char suffix[] = "-generic";
@@ -295,7 +279,6 @@ found:
 				continue;
 
 			larval->adult = alg;
-			complete_all(&larval->completion);
 			continue;
 		}
 
diff --git a/crypto/algboss.c b/crypto/algboss.c
index 791d194..368a832 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -11,6 +11,7 @@
  */
 
 #include <crypto/internal/aead.h>
+#include <linux/completion.h>
 #include <linux/ctype.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -47,6 +48,8 @@ struct cryptomgr_param {
 	char larval[CRYPTO_MAX_ALG_NAME];
 	char template[CRYPTO_MAX_ALG_NAME];
 
+	struct completion completion;
+
 	u32 otype;
 	u32 omask;
 };
@@ -66,7 +69,7 @@ static int cryptomgr_probe(void *data)
 
 	tmpl = crypto_lookup_template(param->template);
 	if (!tmpl)
-		goto err;
+		goto out;
 
 	do {
 		if (tmpl->create) {
@@ -83,16 +86,10 @@ static int cryptomgr_probe(void *data)
 
 	crypto_tmpl_put(tmpl);
 
-	if (err)
-		goto err;
-
 out:
+	complete(&param->completion);
 	kfree(param);
 	module_put_and_exit(0);
-
-err:
-	crypto_larval_error(param->larval, param->otype, param->omask);
-	goto out;
 }
 
 static int cryptomgr_schedule_probe(struct crypto_larval *larval)
@@ -192,10 +189,15 @@ static int cryptomgr_schedule_probe(struct crypto_larval *larval)
 
 	memcpy(param->larval, larval->alg.cra_name, CRYPTO_MAX_ALG_NAME);
 
+	init_completion(&param->completion);
+
 	thread = kthread_run(cryptomgr_probe, param, "cryptomgr_probe");
 	if (IS_ERR(thread))
 		goto err_free_param;
 
+	wait_for_completion_interruptible_timeout(&param->completion, 60 * HZ);
+	complete_all(&larval->completion);
+
 	return NOTIFY_STOP;
 
 err_free_param:
diff --git a/crypto/internal.h b/crypto/internal.h
index b865ca1..9ebedae 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -83,7 +83,6 @@ void crypto_exit_compress_ops(struct crypto_tfm *tfm);
 struct crypto_larval *crypto_larval_alloc(const char *name, u32 type, u32 mask);
 void crypto_larval_kill(struct crypto_alg *alg);
 struct crypto_alg *crypto_larval_lookup(const char *name, u32 type, u32 mask);
-void crypto_larval_error(const char *name, u32 type, u32 mask);
 void crypto_alg_tested(const char *name, int err);
 
 void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
