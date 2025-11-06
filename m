Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853DA2D8781;
	Thu,  6 Nov 2025 06:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762410177; cv=none; b=RktcE6qPeVmZEzQ75sAbTYftZrRNJwrUwrkW7AvyfqDqRnOE7btTQJ68iewLozyRBlloOtMeDoVmKsdHuZNQnFDIAra7C7T44gVPsz7sOwPMfQphNX7op7F2WpEbH+LI5dCHyGqCW6XvE5HuIzpa5dyHsMtswbVEU4Zvh8lHlF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762410177; c=relaxed/simple;
	bh=xw7cqzusGQJsABm+W0f5HlstnoboV0cr2n79VliFK6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cADb7jQsjAWLZPqwVZ0FoIlMe9/6LJAzAfwSrhhY0JHuhBLheU6OuhKfSOW69hUJGv35ykpD7wWwLvmm71TNzua58pddwa2ywnureEqGCttAyEx5+08QRjpiSuJqqTchaj1WIMJTqukABObEKNl6au/9080qQcq2oa5siEUnHqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ibpe+onl; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ibpe+onl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=sDXhdK1CrbJ4L/kNRm/vTNBIYUze39ACTflvTXNHGks=; 
	b=ibpe+onlf3no9I/LLycJ9n+5Gf8jYrEGBWqM4gw8r70M5BI8ezYVozvj9wJVszNn3uxuotpxGKB
	KzpTifdHGxflzDx+ydCj8um2wNj5861dgLmvO7H1ZwJmGVeCvce5bI6DwnYYNoYDW/3V6GKIcUR5C
	gHeQ5oXOwKwLA7YQ5BoNl28EzOcZG4N5tJknM5sX99swwZYom1seD7TKMDQsZ1K2MjC2XH2uh12TD
	svpWse0Oic2TmAgEpKBtvIMtrq/1lpJaysG/66e+JlAr8wvJ5GnLYHzUZLpWWkSzE3HkOwj661zjp
	n+ohadMSrkjtq2au/Ws/i8a5yvskvGO7Hndg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vGtOU-000r41-1A;
	Thu, 06 Nov 2025 14:22:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 06 Nov 2025 14:22:50 +0800
Date: Thu, 6 Nov 2025 14:22:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, robh@kernel.org, krzk+dt@kernel.org,
	conor+dt@kernel.org, Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com, adityak@vayavyalabs.com,
	Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
Subject: Re: [PATCH v8 2/4] crypto: spacc - Add SPAcc ahash support
Message-ID: <aQw-ugxNqclAqDkg@gondor.apana.org.au>
References: <20251031044803.400524-1-pavitrakumarm@vayavyalabs.com>
 <20251031044803.400524-3-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251031044803.400524-3-pavitrakumarm@vayavyalabs.com>

On Fri, Oct 31, 2025 at 10:18:01AM +0530, Pavitrakumar Managutte wrote:
>
> +static int spacc_hash_init_tfm(struct crypto_ahash *tfm)
> +{
> +	const struct spacc_alg *salg = container_of(crypto_ahash_alg(tfm),
> +						    struct spacc_alg,
> +						    alg.hash.base);
> +	struct spacc_crypto_ctx *tctx = crypto_ahash_ctx(tfm);
> +
> +	tctx->handle    = -1;
> +	tctx->ctx_valid = false;
> +	tctx->dev       = get_device(salg->dev);
> +
> +	tctx->fb.hash = crypto_alloc_ahash(crypto_ahash_alg_name(tfm), 0,
> +			CRYPTO_ALG_NEED_FALLBACK);
> +	if (IS_ERR(tctx->fb.hash)) {
> +		dev_err(tctx->dev, "SPAcc ahash fallback tfm is NULL!\n");
> +		put_device(tctx->dev);
> +		return PTR_ERR(tctx->fb.hash);
> +	}
> +
> +	crypto_ahash_set_statesize(tfm,
> +			crypto_ahash_statesize(tctx->fb.hash));
> +
> +	crypto_ahash_set_reqsize(tfm,
> +			sizeof(struct spacc_crypto_reqctx) +
> +			crypto_ahash_reqsize(tctx->fb.hash));

Please stop using dynamic statesize/reqsize values as they are
being phased out.

The API now provides a fallback directly that can be used with
a stack request.  Grep for aspeed_ahash_fallback to see an example
of that being used.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
