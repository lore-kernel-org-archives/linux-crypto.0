Return-Path: <SRS0=wI/w=Z4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BAF5C43603
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Dec 2019 21:47:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45B4F2173E
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Dec 2019 21:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575668866;
	bh=GAO5LfVFJEIL8emkZCr2F8AShuWJfvvlJZ1fI9wH9Gw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=drOqnWsE+NTfOpErSvu1pMN+4l0LIHXRYTanBj1EdJuQVJGnAQ5sObtVl47JWpE8B
	 0FrqQ3Wu0wfL4sz+ywQHlzgaBXYiqYNwd3tjkJ7SXjKuKWpoBS45iOozEnzPnqudZT
	 XW3jGQFSNQvqvMdw6NUcwUPiZpYiL6LV4cIKwl54=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfLFVrp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Dec 2019 16:47:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:60780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726353AbfLFVrp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Dec 2019 16:47:45 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F310620867;
        Fri,  6 Dec 2019 21:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575668865;
        bh=GAO5LfVFJEIL8emkZCr2F8AShuWJfvvlJZ1fI9wH9Gw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kVoPXmoT/SjK35kHgVZ56yPSDsURznwMnq3O3Xn/gyXgrPKZjYDoj2X7JnGkaFbjI
         dzA9VqPSjbAtq648YrPNY622X6ZgXnJZuNmZQlrwqxyuLcBL4xfHOj54LyZcIwFLVM
         En6ANq4L84CzzX0gmofPa1SHTkTAHlFmPz+vYKGA=
Date:   Fri, 6 Dec 2019 13:47:43 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: skcipher - Add skcipher_ialg_simple helper
Message-ID: <20191206214742.GA246840@gmail.com>
References: <20191206055704.g2g5y2e5dakxj7za@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191206055704.g2g5y2e5dakxj7za@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 06, 2019 at 01:57:04PM +0800, Herbert Xu wrote:
> This patch introduces the skcipher_ialg_simple helper which fetches
> the crypto_alg structure from a simple skcpiher instance's spawn.
> 
> This allows us to remove the third argument from the function
> skcipher_alloc_instance_simple.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/crypto/cbc.c b/crypto/cbc.c
> index dd96bcf4d4b6..b9c718fe9d7d 100644
> --- a/crypto/cbc.c
> +++ b/crypto/cbc.c
> @@ -54,10 +54,12 @@ static int crypto_cbc_create(struct crypto_template *tmpl, struct rtattr **tb)
>  	struct crypto_alg *alg;
>  	int err;
>  
> -	inst = skcipher_alloc_instance_simple(tmpl, tb, &alg);
> +	inst = skcipher_alloc_instance_simple(tmpl, tb);
>  	if (IS_ERR(inst))
>  		return PTR_ERR(inst);
>  
> +	alg = skcipher_ialg_simple(inst);
> +
>  	err = -EINVAL;
>  	if (!is_power_of_2(alg->cra_blocksize))
>  		goto out_free_inst;

This doesn't seem like an improvement, because skcipher_alloc_instance_simple()
takes a reference to 'alg' which the caller must drop.  It's better to make this
explicit by having 'alg' be one of the return values.

- Eric
