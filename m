Return-Path: <SRS0=IyTV=2B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DDF7C43603
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 02:26:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61F0520836
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 02:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576031177;
	bh=IUd6C6u6egK51iR7bm9ziQuwkKFXLT5gxllgdwyQYb8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=VXnQnxwWd78+F++yxiwc4VvmGcL6B7haG8fwCkk3r51hyFptcKPmTgdZ+IUb0f3ZX
	 GaVqxnDkE/nGXYWjT0qs6HFeSPCYivqHzXZEp5N7zDC42RG28t2us/JrC3+64RJLsG
	 zEflNU2nLb6e7FyCzdBW9NYe6ZD9ixwPqLbJpvO4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbfLKC0Q (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Dec 2019 21:26:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:56724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727230AbfLKC0Q (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Dec 2019 21:26:16 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C82202073B;
        Wed, 11 Dec 2019 02:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576031174;
        bh=IUd6C6u6egK51iR7bm9ziQuwkKFXLT5gxllgdwyQYb8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hxDhEjq5xqnSShsOxjMje3ld5cCl7OB1boVJn4vE9P0wZfa0wQDqDew65H+2Krgit
         FMrJjXxQB6LtA9Ce82NPkmAanYkNQqv38l5cJpPE63x9qHpqB+JXtl98iVeK/Idbke
         czSa5xwjAdsnoMYxt7L1tCqSGtOb1VUxxbZYsRKw=
Date:   Tue, 10 Dec 2019 18:26:13 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, pvanleeuwen@verimatrix.com
Subject: Re: [v4 PATCH] crypto: api - fix unexpectedly getting generic
 implementation
Message-ID: <20191211022613.GA732@sol.localdomain>
References: <20191202221319.258002-1-ebiggers@kernel.org>
 <20191204091910.67fkpomnav4h5tuw@gondor.apana.org.au>
 <20191204172244.GB1023@sol.localdomain>
 <20191205015811.mg6r3qnv7uj3fgpz@gondor.apana.org.au>
 <20191205034301.GA1158@sol.localdomain>
 <20191205045545.qernhqet4dx3b47b@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191205045545.qernhqet4dx3b47b@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 05, 2019 at 12:55:45PM +0800, Herbert Xu wrote:
> On Wed, Dec 04, 2019 at 07:43:01PM -0800, Eric Biggers wrote:
> >
> > No, the problem I'm talking about is different and is new to your patch.  If
> > tmpl(X-accelerated) is registered while someone is doing crypto_alg_mod_lookup()
> > that triggered instantiation of tmpl(X-generic), then crypto_alg_mod_lookup()
> > could fail with ENOENT, instead of returning tmpl(X-generic) as it does
> > currently.  This is because the proposed new logic will not fulfill the request
> > larval if a better implementation of tmpl(X) is still being tested.  But there's
> > no guarantee that tmpl(X) will finish being tested by the time cryptomgr_probe()
> > thinks it is done and complete()s the request larval with 'adult' still NULL.
> > 
> > (I think; I haven't actually tested this, this analysis is just based on my
> > reading of the code...)
> 
> Right.  This is indeed a regression.  How about this patch then?
> We can simply punt and retry the lookup if we encounter a better
> larval.
> 
> ---8<---
> When CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y, the first lookup of an
> algorithm that needs to be instantiated using a template will always get
> the generic implementation, even when an accelerated one is available.
> 
> This happens because the extra self-tests for the accelerated
> implementation allocate the generic implementation for comparison
> purposes, and then crypto_alg_tested() for the generic implementation
> "fulfills" the original request (i.e. sets crypto_larval::adult).
> 
> This patch fixes this by only fulfilling the original request if
> we are currently the best outstanding larval as judged by the
> priority.  If we're not the best then we will ask all waiters on
> that larval request to retry the lookup.
> 
> Note that this patch introduces a behaviour change when the module
> providing the new algorithm is unregistered during the process.
> Previously we would have failed with ENOENT, after the patch we
> will instead redo the lookup.
>  
> Fixes: 9a8a6b3f0950 ("crypto: testmgr - fuzz hashes against...")
> Fixes: d435e10e67be ("crypto: testmgr - fuzz skciphers against...")
> Fixes: 40153b10d91c ("crypto: testmgr - fuzz AEADs against...")
> Reported-by: Eric Biggers <ebiggers@google.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/crypto/algapi.c b/crypto/algapi.c
> index b052f38edba6..c7527ac614af 100644
> --- a/crypto/algapi.c
> +++ b/crypto/algapi.c
> @@ -257,6 +257,7 @@ void crypto_alg_tested(const char *name, int err)
>  	struct crypto_alg *alg;
>  	struct crypto_alg *q;
>  	LIST_HEAD(list);
> +	bool best;
>  
>  	down_write(&crypto_alg_sem);
>  	list_for_each_entry(q, &crypto_alg_list, cra_list) {
> @@ -280,6 +281,21 @@ void crypto_alg_tested(const char *name, int err)
>  
>  	alg->cra_flags |= CRYPTO_ALG_TESTED;
>  
> +	/* Only satisfy larval waiters if we are the best. */
> +	best = true;
> +	list_for_each_entry(q, &crypto_alg_list, cra_list) {
> +		if (crypto_is_moribund(q) || !crypto_is_larval(q))
> +			continue;
> +
> +		if (strcmp(alg->cra_name, q->cra_name))
> +			continue;
> +
> +		if (q->cra_priority > alg->cra_priority) {
> +			best = false;
> +			break;
> +		}
> +	}
> +
>  	list_for_each_entry(q, &crypto_alg_list, cra_list) {
>  		if (q == alg)
>  			continue;
> @@ -289,6 +305,7 @@ void crypto_alg_tested(const char *name, int err)
>  
>  		if (crypto_is_larval(q)) {
>  			struct crypto_larval *larval = (void *)q;
> +			struct crypto_alg *r;
>  
>  			/*
>  			 * Check to see if either our generic name or
> @@ -303,8 +320,10 @@ void crypto_alg_tested(const char *name, int err)
>  				continue;
>  			if ((q->cra_flags ^ alg->cra_flags) & larval->mask)
>  				continue;
> -			if (!crypto_mod_get(alg))
> -				continue;
> +
> +			r = ERR_PTR(-EAGAIN);
> +			if (best && crypto_mod_get(alg))
> +				r = alg;
>  
>  			larval->adult = alg;
>  			continue;
> diff --git a/crypto/api.c b/crypto/api.c
> index 55bca28df92d..b5ad4cc1198a 100644
> --- a/crypto/api.c
> +++ b/crypto/api.c
> @@ -97,7 +97,7 @@ static void crypto_larval_destroy(struct crypto_alg *alg)
>  	struct crypto_larval *larval = (void *)alg;
>  
>  	BUG_ON(!crypto_is_larval(alg));
> -	if (larval->adult)
> +	if (!IS_ERR_OR_NULL(larval->adult))
>  		crypto_mod_put(larval->adult);
>  	kfree(larval);
>  }
> @@ -178,6 +178,8 @@ static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg)
>  		alg = ERR_PTR(-ETIMEDOUT);
>  	else if (!alg)
>  		alg = ERR_PTR(-ENOENT);
> +	else if (IS_ERR(alg))
> +		;
>  	else if (crypto_is_test_larval(larval) &&
>  		 !(alg->cra_flags & CRYPTO_ALG_TESTED))
>  		alg = ERR_PTR(-EAGAIN);

Sorry, I didn't notice you had already sent another patch for this.  I think
this patch is okay, except that it's broken because it doesn't actually do
anything with the 'r' variable in crypto_alg_tested().  I suggest just removing
that variable and doing:

		if (best && crypto_mod_get(alg))
			larval->adult = alg;
		else
			larval->adult = ERR_PTR(-EAGAIN);

Also, it would be nice to also add a function comment for crypto_alg_tested(),
like I had in my original patch.  It's hard to understand this code.

- Eric
