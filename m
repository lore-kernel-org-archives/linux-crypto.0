Received: from norbury.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9A061FE0
	for <linux-crypto@vger.kernel.org>; Fri, 12 Jul 2024 23:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720827576; cv=none; b=GCdqYaa5cjyAkq9nZmga1YCktU7QiDKJ2RoCzh+3od0hr3Ez1iDKc/5hfBjjQw4InelslJIXd44G/GnASkoye5KGSGw2QtcxbLz2l2du+wBSfsMcGUnfhDjdB3g6JxnET3/4s3JVULpsSW71WDqu4T3QcUxEWjQkwt69pbPcnSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720827576; c=relaxed/simple;
	bh=ydxQOepsgzU2qYIJCrNRR2+WLzGVfLBrxhwFryyTsQ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZIwsKrTf1jNQ52joeYvQSO+KQTSVUsxeW8rpbCb9dPqeRbBSaqupWmFsbP6dpxOTJ4Z7jCA5STqWSk/rc73hNleQYozbJX9Xup34PmBFPFi6F3mJXn2TfEWvSFpVtOsA7OsnevGtS97V02CNp48oKGHbe+Yo+VfFOoUS8VbNu+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
	by norbury.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sSPr1-001pla-1M;
	Sat, 13 Jul 2024 09:39:08 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 13 Jul 2024 11:39:07 +1200
Date: Sat, 13 Jul 2024 11:39:07 +1200
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Cc: linux-crypto@vger.kernel.org, Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com, bhoomikak@vayavyalabs.com,
	shwetar <shwetar@vayavyalabs.com>
Subject: Re: [PATCH v6 3/6] Add SPAcc ahash support
Message-ID: <ZpG+m8mnbsikdM+D@gondor.apana.org.au>
References: <20240705171255.2618994-1-pavitrakumarm@vayavyalabs.com>
 <20240705171255.2618994-4-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240705171255.2618994-4-pavitrakumarm@vayavyalabs.com>

On Fri, Jul 05, 2024 at 10:42:52PM +0530, Pavitrakumar M wrote:
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

I thought you added set_statesize based on the fallback state
size, but it appears to be missing?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
