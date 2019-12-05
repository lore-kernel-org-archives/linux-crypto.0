Return-Path: <SRS0=t288=Z3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B43EEC43603
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 04:55:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BD0922464
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 04:55:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbfLEEzs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Dec 2019 23:55:48 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:55330 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728132AbfLEEzs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Dec 2019 23:55:48 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1icjB5-0007RM-96; Thu, 05 Dec 2019 12:55:47 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1icjB3-0002uk-HA; Thu, 05 Dec 2019 12:55:45 +0800
Date:   Thu, 5 Dec 2019 12:55:45 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, pvanleeuwen@verimatrix.com
Subject: [v4 PATCH] crypto: api - fix unexpectedly getting generic
 implementation
Message-ID: <20191205045545.qernhqet4dx3b47b@gondor.apana.org.au>
References: <20191202221319.258002-1-ebiggers@kernel.org>
 <20191204091910.67fkpomnav4h5tuw@gondor.apana.org.au>
 <20191204172244.GB1023@sol.localdomain>
 <20191205015811.mg6r3qnv7uj3fgpz@gondor.apana.org.au>
 <20191205034301.GA1158@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191205034301.GA1158@sol.localdomain>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 04, 2019 at 07:43:01PM -0800, Eric Biggers wrote:
>
> No, the problem I'm talking about is different and is new to your patch.  If
> tmpl(X-accelerated) is registered while someone is doing crypto_alg_mod_lookup()
> that triggered instantiation of tmpl(X-generic), then crypto_alg_mod_lookup()
> could fail with ENOENT, instead of returning tmpl(X-generic) as it does
> currently.  This is because the proposed new logic will not fulfill the request
> larval if a better implementation of tmpl(X) is still being tested.  But there's
> no guarantee that tmpl(X) will finish being tested by the time cryptomgr_probe()
> thinks it is done and complete()s the request larval with 'adult' still NULL.
> 
> (I think; I haven't actually tested this, this analysis is just based on my
> reading of the code...)

Right.  This is indeed a regression.  How about this patch then?
We can simply punt and retry the lookup if we encounter a better
larval.

---8<---
When CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y, the first lookup of an
algorithm that needs to be instantiated using a template will always get
the generic implementation, even when an accelerated one is available.

This happens because the extra self-tests for the accelerated
implementation allocate the generic implementation for comparison
purposes, and then crypto_alg_tested() for the generic implementation
"fulfills" the original request (i.e. sets crypto_larval::adult).

This patch fixes this by only fulfilling the original request if
we are currently the best outstanding larval as judged by the
priority.  If we're not the best then we will ask all waiters on
that larval request to retry the lookup.

Note that this patch introduces a behaviour change when the module
providing the new algorithm is unregistered during the process.
Previously we would have failed with ENOENT, after the patch we
will instead redo the lookup.
 
Fixes: 9a8a6b3f0950 ("crypto: testmgr - fuzz hashes against...")
Fixes: d435e10e67be ("crypto: testmgr - fuzz skciphers against...")
Fixes: 40153b10d91c ("crypto: testmgr - fuzz AEADs against...")
Reported-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algapi.c b/crypto/algapi.c
index b052f38edba6..c7527ac614af 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -257,6 +257,7 @@ void crypto_alg_tested(const char *name, int err)
 	struct crypto_alg *alg;
 	struct crypto_alg *q;
 	LIST_HEAD(list);
+	bool best;
 
 	down_write(&crypto_alg_sem);
 	list_for_each_entry(q, &crypto_alg_list, cra_list) {
@@ -280,6 +281,21 @@ void crypto_alg_tested(const char *name, int err)
 
 	alg->cra_flags |= CRYPTO_ALG_TESTED;
 
+	/* Only satisfy larval waiters if we are the best. */
+	best = true;
+	list_for_each_entry(q, &crypto_alg_list, cra_list) {
+		if (crypto_is_moribund(q) || !crypto_is_larval(q))
+			continue;
+
+		if (strcmp(alg->cra_name, q->cra_name))
+			continue;
+
+		if (q->cra_priority > alg->cra_priority) {
+			best = false;
+			break;
+		}
+	}
+
 	list_for_each_entry(q, &crypto_alg_list, cra_list) {
 		if (q == alg)
 			continue;
@@ -289,6 +305,7 @@ void crypto_alg_tested(const char *name, int err)
 
 		if (crypto_is_larval(q)) {
 			struct crypto_larval *larval = (void *)q;
+			struct crypto_alg *r;
 
 			/*
 			 * Check to see if either our generic name or
@@ -303,8 +320,10 @@ void crypto_alg_tested(const char *name, int err)
 				continue;
 			if ((q->cra_flags ^ alg->cra_flags) & larval->mask)
 				continue;
-			if (!crypto_mod_get(alg))
-				continue;
+
+			r = ERR_PTR(-EAGAIN);
+			if (best && crypto_mod_get(alg))
+				r = alg;
 
 			larval->adult = alg;
 			continue;
diff --git a/crypto/api.c b/crypto/api.c
index 55bca28df92d..b5ad4cc1198a 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -97,7 +97,7 @@ static void crypto_larval_destroy(struct crypto_alg *alg)
 	struct crypto_larval *larval = (void *)alg;
 
 	BUG_ON(!crypto_is_larval(alg));
-	if (larval->adult)
+	if (!IS_ERR_OR_NULL(larval->adult))
 		crypto_mod_put(larval->adult);
 	kfree(larval);
 }
@@ -178,6 +178,8 @@ static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg)
 		alg = ERR_PTR(-ETIMEDOUT);
 	else if (!alg)
 		alg = ERR_PTR(-ENOENT);
+	else if (IS_ERR(alg))
+		;
 	else if (crypto_is_test_larval(larval) &&
 		 !(alg->cra_flags & CRYPTO_ALG_TESTED))
 		alg = ERR_PTR(-EAGAIN);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
