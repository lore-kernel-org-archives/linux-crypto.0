Return-Path: <SRS0=RobT=Z2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79612C43603
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Dec 2019 09:19:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51D49206DF
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Dec 2019 09:19:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbfLDJTO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Dec 2019 04:19:14 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:42198 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725922AbfLDJTO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Dec 2019 04:19:14 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1icQoS-00071B-U0; Wed, 04 Dec 2019 17:19:12 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1icQoQ-0004mI-BK; Wed, 04 Dec 2019 17:19:10 +0800
Date:   Wed, 4 Dec 2019 17:19:10 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, pvanleeuwen@verimatrix.com
Subject: [v2 PATCH] crypto: api - fix unexpectedly getting generic
 implementation
Message-ID: <20191204091910.67fkpomnav4h5tuw@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202221319.258002-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Organization: Core
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> When CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y, the first lookup of an
> algorithm that needs to be instantiated using a template will always get
> the generic implementation, even when an accelerated one is available.
> 
> This happens because the extra self-tests for the accelerated
> implementation allocate the generic implementation for comparison
> purposes, and then crypto_alg_tested() for the generic implementation
> "fulfills" the original request (i.e. sets crypto_larval::adult).
> 
> Fix this by making crypto_alg_tested() replace an already-set
> crypto_larval::adult when it has lower priority and the larval hasn't
> already been complete()d (by cryptomgr_probe()).
> 
> This also required adding crypto_alg_sem protection to completing the
> larval in cryptomgr_probe().
> 
> Also add some comments to crypto_alg_tested() to make it easier to
> understand what's going on.
> 
> Fixes: 9a8a6b3f0950 ("crypto: testmgr - fuzz hashes against their generic implementation")
> Fixes: d435e10e67be ("crypto: testmgr - fuzz skciphers against their generic implementation")
> Fixes: 40153b10d91c ("crypto: testmgr - fuzz AEADs against their generic implementation")
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> crypto/algapi.c   | 46 +++++++++++++++++++++++++++++++++++++++++-----
> crypto/algboss.c  |  4 ++++
> crypto/api.c      |  5 -----
> crypto/internal.h |  5 +++++
> 4 files changed, 50 insertions(+), 10 deletions(-)

Thanks for the patch! I had forgotten about this problem :)

> @@ -290,26 +302,50 @@ void crypto_alg_tested(const char *name, int err)
>                if (crypto_is_larval(q)) {
>                        struct crypto_larval *larval = (void *)q;
> 
> +                       if (crypto_is_test_larval(larval))
> +                               continue;
> +
>                        /*
> -                        * Check to see if either our generic name or
> -                        * specific name can satisfy the name requested
> -                        * by the larval entry q.
> +                        * Fulfill the request larval 'q' (set larval->adult) if
> +                        * the tested algorithm is compatible with it, i.e. if
> +                        * the request is for the same generic or driver name
> +                        * and for compatible flags.
> +                        *
> +                        * If larval->adult is already set, replace it if the
> +                        * tested algorithm is higher priority and the larval
> +                        * hasn't been completed()d yet.  This is needed to
> +                        * avoid users always getting the generic implementation
> +                        * on first use when the extra self-tests are enabled.
>                         */
> +
>                        if (strcmp(alg->cra_name, q->cra_name) &&
>                            strcmp(alg->cra_driver_name, q->cra_name))
>                                continue;
> 
> -                       if (larval->adult)
> -                               continue;
>                        if ((q->cra_flags ^ alg->cra_flags) & larval->mask)
>                                continue;
> +
> +                       if (larval->adult &&
> +                           larval->adult->cra_priority >= alg->cra_priority)
> +                               continue;
> +
> +                       if (completion_done(&larval->completion))
> +                               continue;
> +
>                        if (!crypto_mod_get(alg))
>                                continue;
> 
> +                       if (larval->adult)
> +                               crypto_mod_put(larval->adult);
>                        larval->adult = alg;
>                        continue;
>                }

I think this is a tad over-complicated.  All we really need to do
is avoid changing larval->adult if we are not the best larval.
Something like this (totally untested!):

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
priority.
 
Fixes: 9a8a6b3f0950 ("crypto: testmgr - fuzz hashes against their generic implementation")
Fixes: d435e10e67be ("crypto: testmgr - fuzz skciphers against their generic implementation")
Fixes: 40153b10d91c ("crypto: testmgr - fuzz AEADs against their generic implementation")
Reported-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algapi.c b/crypto/algapi.c
index b052f38edba6..3e65653735f4 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -280,6 +280,18 @@ void crypto_alg_tested(const char *name, int err)
 
 	alg->cra_flags |= CRYPTO_ALG_TESTED;
 
+	/* Only satisfy larval waiters if we are the best. */
+	list_for_each_entry(q, &crypto_alg_list, cra_list) {
+		if (!crypto_is_larval(q))
+			continue;
+
+		if (strcmp(alg->cra_name, q->cra_name))
+			continue;
+
+		if (q->cra_priority > alg->cra_priority)
+			goto complete;
+	}
+
 	list_for_each_entry(q, &crypto_alg_list, cra_list) {
 		if (q == alg)
 			continue;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
