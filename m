Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7C11C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Sep 2021 18:16:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B33F610E7
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Sep 2021 18:16:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240675AbhIMSRX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Sep 2021 14:17:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:55594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240439AbhIMSRV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Sep 2021 14:17:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D086A60F6D;
        Mon, 13 Sep 2021 18:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631556964;
        bh=b2ydYqtesqNfeF1nyuSDZqGvnqYCkvMNPgaDstAEJcE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OH6jOX9eX+divlvfEh9ZF5OJzam1zSkg7M/5D31WZUKaFvtdTExYGbOq1+IFWGEHi
         x2tXYOT/MjasCQMq2xHhWlcD+PbVd+fA1XW18+gzWiVHEJzar6KvyykY6LAfURGPo2
         MI1H6aL8KCbPp16K7co+aSvjnRAHbRRGiNC9kHxVJGDSX7ybxFZxzkva8qVC9Lmcm4
         tZmhHko5VM7Q9BzahMpE9lIixgf0AnqagsqhBPad0e22NIRxldGYPbyh+UkAR55WoO
         IEov+YN3JgYs/zq1ppTsvtkd124jfFSX88DzMk1oGVivXygFQRUv6QC70QM3Y78L2Z
         C/TunRBPxJhGg==
Date:   Mon, 13 Sep 2021 11:16:03 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Simo Sorce <ssorce@redhat.com>
Subject: Re: [PATCH] crypto: api - Fix built-in testing dependency failures
Message-ID: <YT+VYx7OKELJafYz@sol.localdomain>
References: <20210913071251.GA15235@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210913071251.GA15235@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 13, 2021 at 03:12:51PM +0800, Herbert Xu wrote:
> When complex algorithms that depend on other algorithms are built
> into the kernel, the order of registration must be done such that
> the underlying algorithms are ready before the ones on top are
> registered.  As otherwise they would fail during the self-test
> which is required during registration.
> 
> In the past we have used subsystem initialisation ordering to
> guarantee this.  The number of such precedence levels are limited
> and they may cause ripple effects in other subsystems.
> 
> This patch solves this problem by delaying all self-tests during
> boot-up for built-in algorithms.  They will be tested either when
> something else in the kernel requests for them, or when we have
> finished registering all built-in algorithms, whichever comes
> earlier.

Are there any specific examples that you could give?

>  int crypto_register_alg(struct crypto_alg *alg)
>  {
>  	struct crypto_larval *larval;
> +	bool tested;
>  	int err;
>  
>  	alg->cra_flags &= ~CRYPTO_ALG_DEAD;
> @@ -421,12 +402,15 @@ int crypto_register_alg(struct crypto_alg *alg)
>  
>  	down_write(&crypto_alg_sem);
>  	larval = __crypto_register_alg(alg);
> +	tested = static_key_enabled(&crypto_boot_test_finished);
> +	larval->tested = tested;

'tested' is set before the algorithm has actually been tested, and it sounds
like the same as CRYPTO_ALG_TESTED which already exists.  Maybe it should be
called something else, like 'test_started'?

> +static void __init crypto_start_tests(void)
> +{
> +	for (;;) {
> +		struct crypto_larval *larval = NULL;
> +		struct crypto_alg *q;
> +
> +		down_write(&crypto_alg_sem);
> +
> +		list_for_each_entry(q, &crypto_alg_list, cra_list) {
> +			struct crypto_larval *l;
> +
> +			if (!crypto_is_larval(q))
> +				continue;
> +
> +			l = (void *)q;
> +
> +			if (!crypto_is_test_larval(l))
> +				continue;
> +
> +			if (l->tested)
> +				continue;
> +
> +			l->tested = true;
> +			larval = l;
> +			break;
> +		}
> +
> +		up_write(&crypto_alg_sem);
> +
> +		if (!larval)
> +			break;
> +
> +		crypto_wait_for_test(larval);
> +	}

Is there a way to continue iterating from the previous algorithm, so that this
doesn't take quadratic time?

> +
> +	static_branch_enable(&crypto_boot_test_finished);
> +}
> +
>  static int __init crypto_algapi_init(void)
>  {
>  	crypto_init_proc();
> +	crypto_start_tests();

A comment explaining why the tests aren't run until late_initcall would be
helpful.  People shouldn't have to dig through commit messages to understand the
code.

Also, did you check whether there is anything that relies on the crypto API
being available before or during late_initcall?  That wouldn't work with this
new approach, right?

- Eric
