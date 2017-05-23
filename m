From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 04/11] crypto: dh - fix dh_max_size
Date: Tue, 23 May 2017 12:07:44 +0800
Message-ID: <20170523040744.GC12788@gondor.apana.org.au>
References: <1495033238-26016-1-git-send-email-tudor.ambarus@microchip.com>
 <1495033238-26016-5-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, dhowells@redhat.com,
        linux-crypto@vger.kernel.org, keyrings@vger.kernel.org,
        Nicolas.Ferre@microchip.com
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:47864 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751088AbdEWEIC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 May 2017 00:08:02 -0400
Content-Disposition: inline
In-Reply-To: <1495033238-26016-5-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 17, 2017 at 06:00:31PM +0300, Tudor Ambarus wrote:
> The function should return minimum size for output buffer
> or error code if key hasn't been set.
> 
> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
> ---
>  crypto/dh.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/crypto/dh.c b/crypto/dh.c
> index 7cec0498..325a5dd 100644
> --- a/crypto/dh.c
> +++ b/crypto/dh.c
> @@ -148,7 +148,7 @@ static int dh_max_size(struct crypto_kpp *tfm)
>  {
>  	struct dh_ctx *ctx = dh_get_ctx(tfm);
>  
> -	return mpi_get_size(ctx->p);
> +	return ctx->p ? mpi_get_size(ctx->p) : -EINVAL;

How about ENOKEY?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
