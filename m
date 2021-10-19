Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 323C7C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Oct 2021 13:28:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13FC161038
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Oct 2021 13:28:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235763AbhJSNaX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Oct 2021 09:30:23 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:56172 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235788AbhJSNaX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Oct 2021 09:30:23 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mcp9z-0006Dx-E4; Tue, 19 Oct 2021 21:28:07 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mcp9u-00046F-8w; Tue, 19 Oct 2021 21:28:02 +0800
Date:   Tue, 19 Oct 2021 21:28:02 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Simo Sorce <ssorce@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>, llvm@lists.linux.dev,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] crypto: api - Do not create test larvals if manager is
 disabled
Message-ID: <20211019132802.GA14233@gondor.apana.org.au>
References: <20210913071251.GA15235@gondor.apana.org.au>
 <20210917002619.GA6407@gondor.apana.org.au>
 <YVNfqUVJ7w4Z3WXK@archlinux-ax161>
 <20211001055058.GA6081@gondor.apana.org.au>
 <YVdNFzs8HUQwHa54@archlinux-ax161>
 <20211003002801.GA5435@gondor.apana.org.au>
 <YV0K+EbrAqDdw2vp@archlinux-ax161>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YV0K+EbrAqDdw2vp@archlinux-ax161>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Oct 05, 2021 at 07:33:28PM -0700, Nathan Chancellor wrote:
>
> I assume this is the diff you mean? This does not resolve the issue. My
> apologies if I am slow to respond, I am on vacation until the middle of
> next week.

Sorry for the delay.  The kernel robot figured out the problem
for me.  It's the crypto_alg_tested call that causes api.c to
depend on algapi.c.  This call is only invoked in the case where
the crypto manager is turned off.  We could instead simply make
test larvals disappear in that case.

---8<---
The delayed boot-time testing patch created a dependency loop
between api.c and algapi.c because it added a crypto_alg_tested
call to the former when the crypto manager is disabled.

We could instead avoid creating the test larvals if the crypto
manager is disabled.  This avoids the dependency loop as well
as saving some unnecessary work, albeit in a very unlikely case.

Reported-by: Nathan Chancellor <nathan@kernel.org>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reported-by: kernel test robot <lkp@intel.com>
Fixes: adad556efcdd ("crypto: api - Fix built-in testing dependency failures")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 422bdca214e1..d379fd91fb7b 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -216,6 +216,32 @@ void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
 }
 EXPORT_SYMBOL_GPL(crypto_remove_spawns);
 
+static struct crypto_larval *crypto_alloc_test_larval(struct crypto_alg *alg)
+{
+	struct crypto_larval *larval;
+
+	if (!IS_ENABLED(CONFIG_CRYPTO_MANAGER))
+		return NULL;
+
+	larval = crypto_larval_alloc(alg->cra_name,
+				     alg->cra_flags | CRYPTO_ALG_TESTED, 0);
+	if (IS_ERR(larval))
+		return larval;
+
+	larval->adult = crypto_mod_get(alg);
+	if (!larval->adult) {
+		kfree(larval);
+		return ERR_PTR(-ENOENT);
+	}
+
+	refcount_set(&larval->alg.cra_refcnt, 1);
+	memcpy(larval->alg.cra_driver_name, alg->cra_driver_name,
+	       CRYPTO_MAX_ALG_NAME);
+	larval->alg.cra_priority = alg->cra_priority;
+
+	return larval;
+}
+
 static struct crypto_larval *__crypto_register_alg(struct crypto_alg *alg)
 {
 	struct crypto_alg *q;
@@ -250,31 +276,20 @@ static struct crypto_larval *__crypto_register_alg(struct crypto_alg *alg)
 			goto err;
 	}
 
-	larval = crypto_larval_alloc(alg->cra_name,
-				     alg->cra_flags | CRYPTO_ALG_TESTED, 0);
+	larval = crypto_alloc_test_larval(alg);
 	if (IS_ERR(larval))
 		goto out;
 
-	ret = -ENOENT;
-	larval->adult = crypto_mod_get(alg);
-	if (!larval->adult)
-		goto free_larval;
-
-	refcount_set(&larval->alg.cra_refcnt, 1);
-	memcpy(larval->alg.cra_driver_name, alg->cra_driver_name,
-	       CRYPTO_MAX_ALG_NAME);
-	larval->alg.cra_priority = alg->cra_priority;
-
 	list_add(&alg->cra_list, &crypto_alg_list);
-	list_add(&larval->alg.cra_list, &crypto_alg_list);
+
+	if (larval)
+		list_add(&larval->alg.cra_list, &crypto_alg_list);
 
 	crypto_stats_init(alg);
 
 out:
 	return larval;
 
-free_larval:
-	kfree(larval);
 err:
 	larval = ERR_PTR(ret);
 	goto out;
@@ -403,10 +418,11 @@ int crypto_register_alg(struct crypto_alg *alg)
 	down_write(&crypto_alg_sem);
 	larval = __crypto_register_alg(alg);
 	test_started = static_key_enabled(&crypto_boot_test_finished);
-	larval->test_started = test_started;
+	if (!IS_ERR_OR_NULL(larval))
+		larval->test_started = test_started;
 	up_write(&crypto_alg_sem);
 
-	if (IS_ERR(larval))
+	if (IS_ERR_OR_NULL(larval))
 		return PTR_ERR(larval);
 
 	if (test_started)
@@ -616,8 +632,8 @@ int crypto_register_instance(struct crypto_template *tmpl,
 	larval = __crypto_register_alg(&inst->alg);
 	if (IS_ERR(larval))
 		goto unlock;
-
-	larval->test_started = true;
+	else if (larval)
+		larval->test_started = true;
 
 	hlist_add_head(&inst->list, &tmpl->instances);
 	inst->tmpl = tmpl;
@@ -626,7 +642,7 @@ int crypto_register_instance(struct crypto_template *tmpl,
 	up_write(&crypto_alg_sem);
 
 	err = PTR_ERR(larval);
-	if (IS_ERR(larval))
+	if (IS_ERR_OR_NULL(larval))
 		goto err;
 
 	crypto_wait_for_test(larval);
diff --git a/crypto/api.c b/crypto/api.c
index ee5991fe11f8..cf0869dd130b 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -167,11 +167,8 @@ void crypto_wait_for_test(struct crypto_larval *larval)
 	int err;
 
 	err = crypto_probing_notify(CRYPTO_MSG_ALG_REGISTER, larval->adult);
-	if (err != NOTIFY_STOP) {
-		if (WARN_ON(err != NOTIFY_DONE))
-			goto out;
-		crypto_alg_tested(larval->alg.cra_driver_name, 0);
-	}
+	if (WARN_ON_ONCE(err != NOTIFY_STOP))
+		goto out;
 
 	err = wait_for_completion_killable(&larval->completion);
 	WARN_ON(err);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
