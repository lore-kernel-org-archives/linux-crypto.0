From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: skcipher - Fix skcipher_walk_aead_common
Date: Fri, 24 Nov 2017 16:07:40 +1100
Message-ID: <20171124050740.GA14836@gondor.apana.org.au>
References: <20171123124906.15754-1-omosnacek@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, stable@vger.kernel.org
To: Ondrej Mosnacek <omosnacek@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:39082 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1750715AbdKXFHu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Nov 2017 00:07:50 -0500
Content-Disposition: inline
In-Reply-To: <20171123124906.15754-1-omosnacek@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 23, 2017 at 01:49:06PM +0100, Ondrej Mosnacek wrote:
> The skcipher_walk_aead_common function calls scatterwalk_copychunks on
> the input and output walks to skip the associated data. If the AD end
> at an SG list entry boundary, then after these calls the walks will
> still be pointing to the end of the skipped region.
> 
> These offsets are later checked for alignment in skcipher_walk_next,
> so the skcipher_walk may detect the alignment incorrectly.
> 
> This patch fixes it by calling scatterwalk_done after the copychunks
> calls to ensure that the offsets refer to the right SG list entry.
> 
> Fixes: b286d8b1a690 ("crypto: skcipher - Add skcipher walk interface")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Ondrej Mosnacek <omosnacek@gmail.com>

Good catch!

> diff --git a/crypto/skcipher.c b/crypto/skcipher.c
> index 4faa0fd53b0c..6c45ed536664 100644
> --- a/crypto/skcipher.c
> +++ b/crypto/skcipher.c
> @@ -517,6 +517,9 @@ static int skcipher_walk_aead_common(struct skcipher_walk *walk,
>  	scatterwalk_copychunks(NULL, &walk->in, req->assoclen, 2);
>  	scatterwalk_copychunks(NULL, &walk->out, req->assoclen, 2);
>  
> +	scatterwalk_done(&walk->in, 0, walk->total);
> +	scatterwalk_done(&walk->out, 0, walk->total);

That should be 1 instead of 0 for walk->out.

Could you please fix and resubmit?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
