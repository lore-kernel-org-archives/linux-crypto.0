From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: arm/ghash-ce - add missing async
 import/export
Date: Wed, 31 Aug 2016 22:41:35 +0800
Message-ID: <20160831144135.GB26616@gondor.apana.org.au>
References: <1472469594-27315-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43592 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935172AbcHaOlq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Aug 2016 10:41:46 -0400
Content-Disposition: inline
In-Reply-To: <1472469594-27315-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 29, 2016 at 12:19:53PM +0100, Ard Biesheuvel wrote:
> Since commit 8996eafdcbad ("crypto: ahash - ensure statesize is non-zero"),
> all ahash drivers are required to implement import()/export(), and must have
> a non-zero statesize. Fix this for the ARM Crypto Extensions GHASH
> implementation.
> 
> Fixes: 8996eafdcbad ("crypto: ahash - ensure statesize is non-zero")
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm/crypto/ghash-ce-glue.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/arch/arm/crypto/ghash-ce-glue.c b/arch/arm/crypto/ghash-ce-glue.c
> index 1568cb5cd870..212aaa715fdb 100644
> --- a/arch/arm/crypto/ghash-ce-glue.c
> +++ b/arch/arm/crypto/ghash-ce-glue.c
> @@ -220,6 +220,29 @@ static int ghash_async_digest(struct ahash_request *req)
>  	}
>  }
>  
> +static int ghash_async_import(struct ahash_request *req, const void *in)
> +{
> +	struct ahash_request *cryptd_req = ahash_request_ctx(req);
> +	struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
> +	struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
> +
> +	ghash_async_init(req);

Is this really needed?

> +	*dctx = *(const struct ghash_desc_ctx *)in;

I'd prefer to call the underlying shash import/export functions
like we do in cryptd.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
