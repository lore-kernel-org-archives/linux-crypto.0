From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v10 1/2] crypto: skcipher AF_ALG - overhaul memory
 management
Date: Fri, 23 Jun 2017 14:10:48 +0800
Message-ID: <20170623061048.GA28869@gondor.apana.org.au>
References: <16464524.Q9cOxD7cVH@positron.chronox.de>
 <8143872.gWNkduROBH@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:35906 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754412AbdFWGLK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jun 2017 02:11:10 -0400
Content-Disposition: inline
In-Reply-To: <8143872.gWNkduROBH@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 21, 2017 at 10:03:02PM +0200, Stephan Müller wrote:
>
> +	/* convert iovecs of output buffers into RX SGL */
> +	while (len < ctx->used && msg_data_left(msg)) {

How are we supposed to reach the wait path when ctx->used == 0?

> +		/*
> +		 * This error covers -EIOCBQUEUED which implies that we can
> +		 * only handle one AIO request. If the caller wants to have
> +		 * multiple AIO requests in parallel, he must make multiple
> +		 * separate AIO calls.
> +		 */
> +		if (err < 0) {
> +			if (err == -EIOCBQUEUED)
> +				ret = err;
> +			goto out;
>  		}
> +		if (!err)
> +			goto out;

You can combine the two now as err <= 0.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
