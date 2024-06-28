Received: from norbury.hmeau.com (helcar.hmeau.com [216.24.177.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626ECA55
	for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2024 01:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.24.177.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719537385; cv=none; b=gAoZLmDPUVlIZhHI4KBksdqQOQQxF+3UEkHAd5lIaJOIKGP9mc164Yn2hf1/41ZivkKoBF3TtydKvc4kFdBnXbymXpUptjVjmDxnD1QQ2qmcmVQ7L+Cry5bhHJnXerNdLoRuK2cscINv1JN5MRLvf2ANT+PJxn5JTMB4wZa+Scg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719537385; c=relaxed/simple;
	bh=xQmmFK5O/1B8iuEeEXmF66svscDD5YAMT28Xi/0PLfg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tsKVQBt4vGmzwomNIen+ypBFm+imPYUMbDhGte/JopraYBJmiXPry0JWqXaF8jEK5Wo9i1vo5qfBS9fzgDhxsJGNDDoEHRS7VI2bH8pcMQMpvlQ0Tl0PO0CZ1v/9RrYrOiLM0FKaBz3OXel5JeMmmP7opx7MItfm6tcMDzalyj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=216.24.177.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
	by norbury.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sN0Dc-004Ftq-2O;
	Fri, 28 Jun 2024 11:16:05 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 28 Jun 2024 11:16:05 +1000
Date: Fri, 28 Jun 2024 11:16:05 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Cc: linux-crypto@vger.kernel.org, Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com, bhoomikak@vayavyalabs.com,
	shwetar <shwetar@vayavyalabs.com>
Subject: Re: [PATCH v5 3/7] Add SPAcc ahash support
Message-ID: <Zn4O1bCwLLc8kk1N@gondor.apana.org.au>
References: <20240621082053.638952-1-pavitrakumarm@vayavyalabs.com>
 <20240621082053.638952-4-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240621082053.638952-4-pavitrakumarm@vayavyalabs.com>

On Fri, Jun 21, 2024 at 01:50:49PM +0530, Pavitrakumar M wrote:
>
> +static int spacc_hash_cra_init(struct crypto_tfm *tfm)
> +{
> +	const struct spacc_alg *salg = spacc_tfm_ahash(tfm);
> +	struct spacc_crypto_ctx *tctx = crypto_tfm_ctx(tfm);
> +	struct spacc_priv *priv = NULL;
> +
> +	tctx->handle    = -1;
> +	tctx->ctx_valid = false;
> +	tctx->dev       = get_device(salg->dev[0]);
> +
> +	if (salg->mode->sw_fb) {
> +		tctx->fb.hash = crypto_alloc_ahash(salg->calg->cra_name, 0,
> +						   CRYPTO_ALG_NEED_FALLBACK);
> +
> +		if (IS_ERR(tctx->fb.hash)) {
> +			if (tctx->handle >= 0)
> +				spacc_close(&priv->spacc, tctx->handle);
> +			put_device(tctx->dev);
> +			return PTR_ERR(tctx->fb.hash);
> +		}
> +
> +		crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
> +					 sizeof(struct spacc_crypto_reqctx) +
> +					 crypto_ahash_reqsize(tctx->fb.hash));

You should also set the statesize here.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
