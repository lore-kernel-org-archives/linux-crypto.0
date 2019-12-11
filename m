Return-Path: <SRS0=IyTV=2B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38215C43603
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 02:50:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C31F205ED
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 02:50:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbfLKCuO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Dec 2019 21:50:14 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:52824 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726619AbfLKCuO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Dec 2019 21:50:14 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1ies4q-00024e-Q3; Wed, 11 Dec 2019 10:50:12 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ies4p-00065d-10; Wed, 11 Dec 2019 10:50:11 +0800
Date:   Wed, 11 Dec 2019 10:50:11 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, pvanleeuwen@verimatrix.com
Subject: [v5 PATCH] crypto: api - fix unexpectedly getting generic
 implementation
Message-ID: <20191211025010.advtedzhazvx52ij@gondor.apana.org.au>
References: <20191202221319.258002-1-ebiggers@kernel.org>
 <20191204091910.67fkpomnav4h5tuw@gondor.apana.org.au>
 <20191204172244.GB1023@sol.localdomain>
 <20191205015811.mg6r3qnv7uj3fgpz@gondor.apana.org.au>
 <20191205034301.GA1158@sol.localdomain>
 <20191205045545.qernhqet4dx3b47b@gondor.apana.org.au>
 <20191211022613.GA732@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211022613.GA732@sol.localdomain>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Dec 10, 2019 at 06:26:13PM -0800, Eric Biggers wrote:
>
> Sorry, I didn't notice you had already sent another patch for this.  I think
> this patch is okay, except that it's broken because it doesn't actually do
> anything with the 'r' variable in crypto_alg_tested().  I suggest just removing

Oops.

> that variable and doing:
> 
> 		if (best && crypto_mod_get(alg))
> 			larval->adult = alg;
> 		else
> 			larval->adult = ERR_PTR(-EAGAIN);

OK I have made this change.

> Also, it would be nice to also add a function comment for crypto_alg_tested(),
> like I had in my original patch.  It's hard to understand this code.

Your original comments no longer apply but if you wish to make
another patch to add more comments that would certainly be welcome.

Thanks,

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
index cd643e294664..9589b3f0041b 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -284,6 +284,7 @@ void crypto_alg_tested(const char *name, int err)
 	struct crypto_alg *alg;
 	struct crypto_alg *q;
 	LIST_HEAD(list);
+	bool best;
 
 	down_write(&crypto_alg_sem);
 	list_for_each_entry(q, &crypto_alg_list, cra_list) {
@@ -307,6 +308,21 @@ void crypto_alg_tested(const char *name, int err)
 
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
@@ -330,10 +346,12 @@ void crypto_alg_tested(const char *name, int err)
 				continue;
 			if ((q->cra_flags ^ alg->cra_flags) & larval->mask)
 				continue;
-			if (!crypto_mod_get(alg))
-				continue;
 
-			larval->adult = alg;
+			if (best && crypto_mod_get(alg))
+				larval->adult = alg;
+			else
+				larval->adult = ERR_PTR(-EAGAIN);
+
 			continue;
 		}
 
diff --git a/crypto/api.c b/crypto/api.c
index 0ef9f2a37d3d..c00af5ad1b16 100644
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
