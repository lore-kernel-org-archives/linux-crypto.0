Return-Path: <SRS0=RobT=Z2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1997AC43603
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Dec 2019 17:22:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DED2A207DD
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Dec 2019 17:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575480166;
	bh=tmAwJTjw5Tq9DG/xnWXduONC60qc1/lG8nrSI5bdTqU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=NZlJKOK57x0SHGZYzyVihfMdEAt4qRdRW3Sbr4ZpnDS4gjRbteCj8Br6L7f9TIHDB
	 QsWZ1T1FsFzHY2UE9xFQQ6uU8O3vjI0I29QSsW3zo5/Rr08+UDpXxoYAHfO59C4Qmq
	 ZOZQTpSkDwnY+pjXLwNb+waCFL0egbBoEkUMHGMk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbfLDRWq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Dec 2019 12:22:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:58028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727033AbfLDRWq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Dec 2019 12:22:46 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCFA82077B;
        Wed,  4 Dec 2019 17:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575480165;
        bh=tmAwJTjw5Tq9DG/xnWXduONC60qc1/lG8nrSI5bdTqU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qhhnGnJEoYf3qXaI4j/4izQgXPfh65fS62e/PC66BdWeKCmYH7gh5h5vb+WZz6mXe
         17m1q3wJhqTHmtjNW+BNpFLyOAxZ31uQ6ZRGBL7IWnXCM6587UsFn4VXjl0GF6w2Z1
         cI4J2PwWG05oRtrhAdbeyWtOVBp5FwylGQgkLl04=
Date:   Wed, 4 Dec 2019 09:22:44 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, pvanleeuwen@verimatrix.com
Subject: Re: [v2 PATCH] crypto: api - fix unexpectedly getting generic
 implementation
Message-ID: <20191204172244.GB1023@sol.localdomain>
References: <20191202221319.258002-1-ebiggers@kernel.org>
 <20191204091910.67fkpomnav4h5tuw@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191204091910.67fkpomnav4h5tuw@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 04, 2019 at 05:19:10PM +0800, Herbert Xu wrote:
> I think this is a tad over-complicated.  All we really need to do
> is avoid changing larval->adult if we are not the best larval.
> Something like this (totally untested!):
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
> priority.
>  
> Fixes: 9a8a6b3f0950 ("crypto: testmgr - fuzz hashes against their generic implementation")
> Fixes: d435e10e67be ("crypto: testmgr - fuzz skciphers against their generic implementation")
> Fixes: 40153b10d91c ("crypto: testmgr - fuzz AEADs against their generic implementation")
> Reported-by: Eric Biggers <ebiggers@google.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/crypto/algapi.c b/crypto/algapi.c
> index b052f38edba6..3e65653735f4 100644
> --- a/crypto/algapi.c
> +++ b/crypto/algapi.c
> @@ -280,6 +280,18 @@ void crypto_alg_tested(const char *name, int err)
>  
>  	alg->cra_flags |= CRYPTO_ALG_TESTED;
>  
> +	/* Only satisfy larval waiters if we are the best. */
> +	list_for_each_entry(q, &crypto_alg_list, cra_list) {
> +		if (!crypto_is_larval(q))
> +			continue;
> +
> +		if (strcmp(alg->cra_name, q->cra_name))
> +			continue;
> +
> +		if (q->cra_priority > alg->cra_priority)
> +			goto complete;
> +	}
> +

I was going to do something like this originally (but also checking that 'q' is
not "moribund", is a test larval, and has compatible cra_flags).  But I don't
think it will work because a higher priority implementation could be registered
while a lower priority one is being instantiated and tested.  Based on this
logic, when the lower priority implementation finishes being tested,
larval->adult wouldn't be set since a higher priority implementation is still
being tested.  But then cryptomgr_probe() will complete() the larval anyway and
for the user crypto_alloc_foo() will fail with ENOENT.

With my patch the user would get the lower priority implementation in this case,
since it would be the best one ready at the time cryptomgr_probe() finished.

- Eric
