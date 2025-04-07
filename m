Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C423079FD;
	Mon,  7 Apr 2025 03:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743997076; cv=none; b=nCVYCwt4DtFT3hfPCO5gt028eYZ7H4yw7pvibxVTX+NK1j2Cqo/+oyPwEiFVrdQiFvP3xyyMOgzOyAdDJ72B5GkY/zClmjpj/ZH8VC1+s1uZsNjfn9mJ1tB5Y40r24d/fi84ktNi4exym5z2/n9cwZ3iApPmoyO/mYvGt6KwSNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743997076; c=relaxed/simple;
	bh=PyuwHWmTOOmVj1ltBrX/9lsDSMce3Xq03MY1eBoT2Ug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dLpv0EXzqC9A9e2/yEJlJA01UtskE9fTWL68BmRXmWYZT5c613Ge5XizaD14OfEiZnvbR/VhStTDkJ+EUc785B46f0/Kd4w7U5Hog7TEimXZPHbmfN3ROyXaOJnNnpreaq/4MM6JKULBN0Go1p9ZmYza6WIMsGcl5AV5tNgg41s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=IsdxRras; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="IsdxRras"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=j5LtAP9dH0se3Aa+dj5UG/sESuo0SmU97FCP6hGcPME=; b=IsdxRras8/9Ro0ZiSNQ4QHrRBI
	lTpxyE5+DAGAeVziAF+y2ckcROmb7slyNm9SmC6bhaIx1lAMp45YpRHlODod6TmLrAJDNpKzwmU4b
	h56EaQ75YFS2cbHbMsDTxfAj+Y8+Blqy5ck2OGO08qO6UtQonZVP9cZR05k3OJQrl4Auyqk7XWXCN
	mA8tnqY7yyh1yZCvUvKges+sUq4lrsJ65l9hAJh0qAkKRvn8ZhUpcd+R31KjfUY5Rts4izoE72opK
	cYDaGv/5CL7gw71FGPphOepmPjY5QUZeuErWt+IDW+YMeQDGIfUqb9H1gw2v48zUVs32a8mAN9Ek/
	cfI7YOgw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1dIl-00DMJi-0A;
	Mon, 07 Apr 2025 11:37:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 11:37:35 +0800
Date: Mon, 7 Apr 2025 11:37:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Zixun LI <admin@hifiphile.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel - add CRYPTO_ALG_KERN_DRIVER_ONLY flag to
 atmel-aes, atmel-sha, atmel-tdes drivers
Message-ID: <Z_NIf4EEeLRv4fFT@gondor.apana.org.au>
References: <20250319150657.2698916-1-zli@ogga.fr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250319150657.2698916-1-zli@ogga.fr>

On Wed, Mar 19, 2025 at 04:06:56PM +0100, Zixun LI wrote:
> 
> diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
> index 90dcae7049b7..8a6ee5ac9956 100644
> --- a/drivers/crypto/atmel-aes.c
> +++ b/drivers/crypto/atmel-aes.c
> @@ -1948,7 +1948,8 @@ static struct skcipher_alg aes_xts_alg = {
>  	.base.cra_driver_name	= "atmel-xts-aes",
>  	.base.cra_blocksize	= AES_BLOCK_SIZE,
>  	.base.cra_ctxsize	= sizeof(struct atmel_aes_xts_ctx),
> -	.base.cra_flags		= CRYPTO_ALG_NEED_FALLBACK,
> +	.base.cra_flags		= CRYPTO_ALG_NEED_FALLBACK |
> +						  CRYPTO_ALG_KERN_DRIVER_ONLY,

This should be indented like this:

	.base.cra_flags		= CRYPTO_ALG_NEED_FALLBACK |
				  CRYPTO_ALG_KERN_DRIVER_ONLY,

> diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
> index 3622120add62..40f6ed5b20ee 100644
> --- a/drivers/crypto/atmel-sha.c
> +++ b/drivers/crypto/atmel-sha.c
> @@ -1254,7 +1254,8 @@ static int atmel_sha_cra_init(struct crypto_tfm *tfm)
>  static void atmel_sha_alg_init(struct ahash_alg *alg)
>  {
>  	alg->halg.base.cra_priority = ATMEL_SHA_PRIORITY;
> -	alg->halg.base.cra_flags = CRYPTO_ALG_ASYNC;
> +	alg->halg.base.cra_flags = CRYPTO_ALG_ASYNC |
> +							   CRYPTO_ALG_KERN_DRIVER_ONLY;

	alg->halg.base.cra_flags = CRYPTO_ALG_ASYNC |
				   CRYPTO_ALG_KERN_DRIVER_ONLY;

> @@ -2043,7 +2044,8 @@ static void atmel_sha_hmac_cra_exit(struct crypto_tfm *tfm)
>  static void atmel_sha_hmac_alg_init(struct ahash_alg *alg)
>  {
>  	alg->halg.base.cra_priority = ATMEL_SHA_PRIORITY;
> -	alg->halg.base.cra_flags = CRYPTO_ALG_ASYNC;
> +	alg->halg.base.cra_flags = CRYPTO_ALG_ASYNC |
> +							   CRYPTO_ALG_KERN_DRIVER_ONLY;

	alg->halg.base.cra_flags = CRYPTO_ALG_ASYNC |
				   CRYPTO_ALG_KERN_DRIVER_ONLY;

> diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
> index 099b32a10dd7..3a6a890172cd 100644
> --- a/drivers/crypto/atmel-tdes.c
> +++ b/drivers/crypto/atmel-tdes.c
> @@ -898,7 +898,8 @@ static int atmel_tdes_init_tfm(struct crypto_skcipher *tfm)
>  static void atmel_tdes_skcipher_alg_init(struct skcipher_alg *alg)
>  {
>  	alg->base.cra_priority = ATMEL_TDES_PRIORITY;
> -	alg->base.cra_flags = CRYPTO_ALG_ASYNC;
> +	alg->base.cra_flags = CRYPTO_ALG_ASYNC |
> +						  CRYPTO_ALG_KERN_DRIVER_ONLY;

This fits on one line, no need to split.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
