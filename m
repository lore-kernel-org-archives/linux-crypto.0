Return-Path: <SRS0=eKEb=OU=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:43580 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbeLKJ0Q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Dec 2018 04:26:16 -0500
Date: Tue, 11 Dec 2018 17:26:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: "David S. Miller" <davem@davemloft.net>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] crypto: talitos - fix ablkcipher for CONFIG_VMAP_STACK
Message-ID: <20181211092606.il7a2gc4jlsnij3n@gondor.apana.org.au>
References: <20181211072940.4E0B0716F4@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181211072940.4E0B0716F4@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 11, 2018 at 07:29:40AM +0000, Christophe Leroy wrote:
>
> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
> index 6988012deca4..385ec970b639 100644
> --- a/drivers/crypto/talitos.c
> +++ b/drivers/crypto/talitos.c
> @@ -1668,8 +1668,11 @@ static struct talitos_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request *
>  	struct talitos_ctx *ctx = crypto_ablkcipher_ctx(cipher);
>  	unsigned int ivsize = crypto_ablkcipher_ivsize(cipher);
>  
> +	if (ivsize)
> +		memcpy(ctx->iv, areq->info, ivsize);

The ctx is per-tfm, not per-request.  So you cannot write to it.
This needs to go into a pre-request area.

>  	return talitos_edesc_alloc(ctx->dev, areq->src, areq->dst,
> -				   areq->info, 0, areq->nbytes, 0, ivsize, 0,
> +				   ctx->iv, 0, areq->nbytes, 0, ivsize, 0,
>  				   areq->base.flags, encrypt);
>  }

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
