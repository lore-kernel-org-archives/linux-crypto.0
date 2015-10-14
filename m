From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 1/3] crypto: add key wrapping block chaining mode
Date: Wed, 14 Oct 2015 17:55:41 +0800
Message-ID: <20151014095541.GA15794@gondor.apana.org.au>
References: <3564891.reL3VOPkWo@tachyon.chronox.de>
 <1605449.C9hLtSfyhH@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41457 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025AbbJNJzs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Oct 2015 05:55:48 -0400
Content-Disposition: inline
In-Reply-To: <1605449.C9hLtSfyhH@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Sep 21, 2015 at 08:58:23PM +0200, Stephan Mueller wrote:
>
> +/*
> + * Fast forward the SGL to the "end" length minus SEMIBSIZE.
> + * The start in the SGL defined by the fast-forward is returned with
> + * the walk variable
> + */
> +static void crypto_kw_scatterlist_ff(struct scatter_walk *walk,
> +				     struct scatterlist *sg,
> +				     unsigned int end)
> +{
> +	unsigned int skip = 0;
> +
> +	/* The caller should only operate on full SEMIBLOCKs. */
> +	BUG_ON(end < SEMIBSIZE);
> +
> +	skip = end - SEMIBSIZE;
> +	while (sg) {
> +		if (sg->length > skip) {
> +			scatterwalk_start(walk, sg);
> +			scatterwalk_advance(walk, skip);
> +			break;
> +		} else
> +			skip -= sg->length;
> +
> +		sg = sg_next(sg);
> +	}
> +}

This looks very slow but it's conceptually nice and I like it :)
I'll apply this today.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
