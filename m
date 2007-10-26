From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1]: Add countersize to CTR
Date: Fri, 26 Oct 2007 14:59:31 +0800
Message-ID: <20071026065931.GA27800@gondor.apana.org.au>
References: <200710232026.l9NKQTkC000737@faith.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, mikko.herranen@cs.helsinki.fi
To: Joy Latten <latten@austin.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1086 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762950AbXJZHAB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Oct 2007 03:00:01 -0400
Content-Disposition: inline
In-Reply-To: <200710232026.l9NKQTkC000737@faith.austin.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Oct 23, 2007 at 03:26:29PM -0500, Joy Latten wrote:
>
> +	err = crypto_attr_u32(tb[4], &countersize);
> +	if (err)
> +		goto out_put_alg;
> +
>  	/* verify size of nonce + iv + counter */
>  	err = -EINVAL;
> -	if ((noncesize + ivsize) >= alg->cra_blocksize)
> +	if (((noncesize + ivsize) > alg->cra_blocksize) ||
> +	    (countersize > alg->cra_blocksize))
>  		goto out_put_alg;

Probably should check whether

	noncesize + ivsize + countersize == blocksize

if

	noncesize + ivsize < blocksize

Actually let's also require that countersize >= 4 as otherwise
wrapping will be a problem.  This would also weed out stream
algorithms but we wouldn't want to apply CTR to them anyway.

Otherwise this looks pretty good to me.  Thanks Joy!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
