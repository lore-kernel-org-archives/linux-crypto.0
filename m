From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: AF_ALG - fix memory management of aio with
 multiple iocbs
Date: Fri, 16 Dec 2016 19:54:36 +0800
Message-ID: <20161216115436.GA19917@gondor.apana.org.au>
References: <4632372.rm33NXUfDp@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40439 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755003AbcLPLyv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Dec 2016 06:54:51 -0500
Content-Disposition: inline
In-Reply-To: <4632372.rm33NXUfDp@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 13, 2016 at 09:42:45PM +0100, Stephan Müller wrote:
>
> +		/*
> +		 * The async operation may have processed only a subset of
> +		 * the data that was initially received from the caller.
> +		 * Thus, we only can release the data that a cipher operation
> +		 * processed.
> +		 */
> +		if (len < sg->length) {
> +			/* ensure that empty SGLs are not referenced any more */
> +			sreq->tsg = sg;

Hmm if you change sreq->tsg how is the original tsg ever going to
get freed?

> +
> +			/* advance the buffers to the unprocessed data */
> +			sg->length -= len;
> +			sg->offset += len;
> +			return;
> +		}
> +
> +		len -= sg->length;
> +		put_page(page);
> +	}
>  
>  	kfree(sreq->tsg);

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
