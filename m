Return-Path: <SRS0=t288=Z3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0142EC43603
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 01:58:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D12D1214B2
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 01:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbfLEB6O (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Dec 2019 20:58:14 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:34212 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728121AbfLEB6O (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Dec 2019 20:58:14 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1icgPE-0005EF-RV; Thu, 05 Dec 2019 09:58:12 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1icgPD-0007L7-Lc; Thu, 05 Dec 2019 09:58:11 +0800
Date:   Thu, 5 Dec 2019 09:58:11 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, pvanleeuwen@verimatrix.com
Subject: [v3 PATCH] crypto: api - fix unexpectedly getting generic
 implementation
Message-ID: <20191205015811.mg6r3qnv7uj3fgpz@gondor.apana.org.au>
References: <20191202221319.258002-1-ebiggers@kernel.org>
 <20191204091910.67fkpomnav4h5tuw@gondor.apana.org.au>
 <20191204172244.GB1023@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191204172244.GB1023@sol.localdomain>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 04, 2019 at 09:22:44AM -0800, Eric Biggers wrote:
>
> I was going to do something like this originally (but also checking that 'q' is
> not "moribund", is a test larval, and has compatible cra_flags).  But I don't

You are right.  I'll add these tests to the patch.

> think it will work because a higher priority implementation could be registered
> while a lower priority one is being instantiated and tested.  Based on this
> logic, when the lower priority implementation finishes being tested,
> larval->adult wouldn't be set since a higher priority implementation is still
> being tested.  But then cryptomgr_probe() will complete() the larval anyway and
> for the user crypto_alloc_foo() will fail with ENOENT.

I think this is a different problem, one which we probably should
address but it already exists regardless of what we do here.  For
example, assuming that tmpl(X) does not currently exist, and I
request tmpl(X-generic) then tmpl(X-generic) along with X-generic
will be created in the system.  If someone then comes along and
asks for tmpl(X) then we'll simply give them tmpl(X-generic) even
if there exists an accelerated version of X.

The problem you describe is simply a racy version of the above
scenario where the requests for tmpl(X) and tmpl(X-generic) occur
about the same time.

We should certainly fix this, as otherwise anyone could force
the whole system to use the generic (or some other non-optimal
variant).  One possible solution is to mark any instance created
by a request like tmpl(X-generic) as non-optimal so that a subsequent
request for tmpl(X) has to go through the whole process again before
being fulfilled.

The hardest part of this is actually ensuring that X-generic does
not fulfil a subsequent request for X.  This is because X-generic
is probably going to be created by a module-load and the crypto
API is not driving the registration of X-generic.  We could
probably use some form of larvals that get created at registration
time to resolve this.

Cheers,

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
 
Fixes: 9a8a6b3f0950 ("crypto: testmgr - fuzz hashes against...")
Fixes: d435e10e67be ("crypto: testmgr - fuzz skciphers against...")
Fixes: 40153b10d91c ("crypto: testmgr - fuzz AEADs against...")
Reported-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algapi.c b/crypto/algapi.c
index b052f38edba6..390bdc874b61 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -280,6 +280,24 @@ void crypto_alg_tested(const char *name, int err)
 
 	alg->cra_flags |= CRYPTO_ALG_TESTED;
 
+	/* Only satisfy larval waiters if we are the best. */
+	list_for_each_entry(q, &crypto_alg_list, cra_list) {
+		struct crypto_larval *larval;
+
+		if (crypto_is_moribund(q) || !crypto_is_larval(q))
+			continue;
+
+		if (strcmp(alg->cra_name, q->cra_name))
+			continue;
+
+		larval = (void *)q;
+		if ((q->cra_flags ^ alg->cra_flags) & larval->mask)
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
