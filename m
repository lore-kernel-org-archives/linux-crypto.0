Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C854188A39;
	Fri, 30 Aug 2024 09:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725011620; cv=none; b=f4b/C2eUiLcR8lU67ubhkfHWSJyd8x1i5xRvErN0NlNPSLGGoHcdzD66rdYgMiXyQ2U2ovr80QuLrtymHzpfOw3ZfBgxd53MXuLZxXFCGTGDFwx7eR4xGEGr9kQ+nOslERykowAG2uO7l+MdPiCzI7+Jo3kTjTOiEWva9YZFJKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725011620; c=relaxed/simple;
	bh=yFNoWirOsLFaQ2/ZHS0wZXqnaEF6GYGpZvhGR3HGpx8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NznzSFwaP97gfZypucazgV7pMwqGFU9lkrLKUp4CWTR6UauWBwdMWINoKjT6ztL4bMi+OgKeYhh65ye+jgS2aMj6GZQLHUQGBvAJcBt8hdYlv1TsuJoqP1mfQ2Fg4wu3MqhzWJVA02w3CuibOsqqfkMtGKemUcsz5YnrAqUw8Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sjyBK-008Tou-0I;
	Fri, 30 Aug 2024 17:53:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Aug 2024 17:53:23 +0800
Date: Fri, 30 Aug 2024 17:53:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ma Ke <make24@iscas.ac.cn>
Cc: davem@davemloft.net, j-keerthy@ti.com, t-kristo@ti.com,
	akpm@linux-foundation.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RESEND] crypto: sa2ul - fix memory leak in
 sa_cra_init_aead()
Message-ID: <ZtGWkxsMHGihPh81@gondor.apana.org.au>
References: <20240819084843.1012289-1-make24@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240819084843.1012289-1-make24@iscas.ac.cn>

On Mon, Aug 19, 2024 at 04:48:43PM +0800, Ma Ke wrote:
> Currently the resource allocated by crypto_alloc_shash() is not freed in
> case crypto_alloc_aead() fails, resulting in memory leak.
> 
> Add crypto_free_shash() to fix it.
> 
> Found by code review.
> 
> Cc: stable@vger.kernel.org
> Fixes: d2c8ac187fc9 ("crypto: sa2ul - Add AEAD algorithm support")
> Signed-off-by: Ma Ke <make24@iscas.ac.cn>
> ---
>  drivers/crypto/sa2ul.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
> index 461eca40e878..b5af621f7f17 100644
> --- a/drivers/crypto/sa2ul.c
> +++ b/drivers/crypto/sa2ul.c
> @@ -1740,7 +1740,8 @@ static int sa_cra_init_aead(struct crypto_aead *tfm, const char *hash,
>  	ctx->shash = crypto_alloc_shash(hash, 0, CRYPTO_ALG_NEED_FALLBACK);
>  	if (IS_ERR(ctx->shash)) {
>  		dev_err(sa_k3_dev, "base driver %s couldn't be loaded\n", hash);
> -		return PTR_ERR(ctx->shash);
> +		ret = PTR_ERR(ctx->shash);
> +		goto err_free_shash;
>  	}

This hunk is unnecessary and confusing.  Please keep the existing
code.

> @@ -1749,7 +1750,8 @@ static int sa_cra_init_aead(struct crypto_aead *tfm, const char *hash,
>  	if (IS_ERR(ctx->fallback.aead)) {
>  		dev_err(sa_k3_dev, "fallback driver %s couldn't be loaded\n",
>  			fallback);
> -		return PTR_ERR(ctx->fallback.aead);
> +		ret = PTR_ERR(ctx->fallback.aead);
> +		goto err_free_shash;
>  	}
>  
>  	crypto_aead_set_reqsize(tfm, sizeof(struct aead_request) +
> @@ -1757,19 +1759,23 @@ static int sa_cra_init_aead(struct crypto_aead *tfm, const char *hash,
>  
>  	ret = sa_init_ctx_info(&ctx->enc, data);
>  	if (ret)
> -		return ret;
> +		goto err_free_shash;

Shouldn't this free the fallback AEAD?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
