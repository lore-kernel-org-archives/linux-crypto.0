From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/4] crypto: inside-secure - only update the result
 buffer when provided
Date: Mon, 11 Dec 2017 18:29:46 +1100
Message-ID: <20171211072946.GA8823@gondor.apana.org.au>
References: <20171128090518.12469-1-antoine.tenart@free-electrons.com>
 <20171128090518.12469-4-antoine.tenart@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:43762 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751281AbdLKHaV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Dec 2017 02:30:21 -0500
Content-Disposition: inline
In-Reply-To: <20171128090518.12469-4-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 28, 2017 at 10:05:17AM +0100, Antoine Tenart wrote:
> The patch fixes the ahash support by only updating the result buffer
> when provided. Otherwise the driver could crash with NULL pointer
> exceptions, because the ahash caller isn't required to supply a result
> buffer on all calls.
> 
> Fixes: 1b44c5a60c13 ("crypto: inside-secure - add SafeXcel EIP197 crypto engine driver")
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> ---
>  drivers/crypto/inside-secure/safexcel_hash.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
> index 6135c9f5742c..424f4c5d4d25 100644
> --- a/drivers/crypto/inside-secure/safexcel_hash.c
> +++ b/drivers/crypto/inside-secure/safexcel_hash.c
> @@ -150,7 +150,12 @@ static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv, int rin
>  
>  	if (sreq->finish)
>  		result_sz = crypto_ahash_digestsize(ahash);
> -	memcpy(sreq->state, areq->result, result_sz);
> +
> +	/* The called isn't required to supply a result buffer. Updated it only
> +	 * when provided.
> +	 */
> +	if (areq->result)
> +		memcpy(sreq->state, areq->result, result_sz);

I don't think you should use whether areq->result is NULL to
determine whether to copy data into it.  For example, I could
be making an update call with a non-NULL areq->result and it would
be completely wrong if you overwrote that with the above memcpy.

IOW areq->result should not be touched at all unless you are doing
a finalisation.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
