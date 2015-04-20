From: Stephan Mueller <smueller@chronox.de>
Subject: Re: crypto: drbg - Initialise mutex in drbg_healthcheck_sanity
Date: Mon, 20 Apr 2015 05:27:58 +0200
Message-ID: <2572182.aBsMvubqLD@myon.chronox.de>
References: <20150420032648.GA17746@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34220 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359AbbDTD2E (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 19 Apr 2015 23:28:04 -0400
In-Reply-To: <20150420032648.GA17746@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 20. April 2015, 11:26:48 schrieb Herbert Xu:

Hi Herbert,

> As we moved the mutex init out of drbg_instantiate and into cra_init
> we need to explicitly initialise the mutex in drbg_healthcheck_sanity.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Stephan Mueller <smueller@chronox.de>
> 
> diff --git a/crypto/drbg.c b/crypto/drbg.c
> index 30ec2a6..57fd479 100644
> --- a/crypto/drbg.c
> +++ b/crypto/drbg.c
> @@ -1741,6 +1741,8 @@ static inline int __init drbg_healthcheck_sanity(void)
> if (!drbg)
>  		return -ENOMEM;
> 
> +	mutex_init(&drbg->drbg_mutex);
> +
>  	/*
>  	 * if the following tests fail, it is likely that there is a buffer
>  	 * overflow as buf is much smaller than the requested or provided


-- 
Ciao
Stephan
