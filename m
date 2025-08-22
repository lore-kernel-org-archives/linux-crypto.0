Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07728393DE7;
	Fri, 22 Aug 2025 08:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755852890; cv=none; b=P7rGgm1kmdIKY9JDHw8BcZukFSylN9xwYo/Utu/zp6VVJLdezY28qjudLMAmazrCRhWvRHIubn0GW6L04BdgyOcgUjLKbwKo7RShurfv/6MJecNrPxuPwKBLKEccAjnpfj3ig8iyjODzwDhutgDcHnjb8WRH8j7v/s44PW2PDiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755852890; c=relaxed/simple;
	bh=7DRLTvUN8Oydnr7V2W/N7Sny8gya5mniJ0/+hxJRsNs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SazuCz4eBtB8pDVuv/B+No2n8uaIhPgCmJrRFfWg8bYDM1ub58iZRboipXglKUlc2RxiSr3AIn8ds03UDZb0waNWqyrQdVUJJEzGN/++m0WBj2FjeFana8VN0+Le8T3XFTyi/pV+wHhHuXoHp+cg/5zAEqSrbWSxFvYLM+IwRqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=rjOIvWTe; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="rjOIvWTe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=W7WLQSNz7B5RmfHyRA2ZmCbMpTFkCh7ouhNUUgwN4UU=; b=rjOIvWTeS1BXXRyaEyOUnuiorc
	C4wzdLdyBnQEvOi0ZOUsO9KJxrtDxGelvwWby72cJjAYpJzmcaXEzl3ExPqaOSqdpoR6OnDJyk7Nf
	rWpB2acr68Liz0u97C8ZQVlMIGIdIA4fsv6O/Oi8If9FMV3YjfYDYgtn0LowvAoDkQ4Ai+XIBiCCq
	/ziMG5MJl8y6tgCM+vyLQrOv7iEaGKycKr1rgTt+7gXRqCVz/RRUc8PWr9LHivVB2dIyKt/ydKNaS
	my+6SsvHYrqZ1A9gqGXSmdqpVN3oUKXrj8uE+hXg5xipSPtFMr6ByeipDAjHYMTVKm1lHTYkWI2ll
	0ECLA+kQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1upNIM-00GMNJ-2C;
	Fri, 22 Aug 2025 16:54:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 22 Aug 2025 16:54:43 +0800
Date: Fri, 22 Aug 2025 16:54:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, robh@kernel.org, krzk+dt@kernel.org,
	conor+dt@kernel.org, Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com, adityak@vayavyalabs.com,
	Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
Subject: Re: [PATCH v4 4/6] Add SPAcc ahash support
Message-ID: <aKgwU4sVZrAHZ05s@gondor.apana.org.au>
References: <20250808122631.697421-1-pavitrakumarm@vayavyalabs.com>
 <20250808122631.697421-5-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250808122631.697421-5-pavitrakumarm@vayavyalabs.com>

On Fri, Aug 08, 2025 at 05:56:29PM +0530, Pavitrakumar Managutte wrote:
>
> +static int spacc_hash_digest(struct ahash_request *req)
> +{
> +	int rc = 0;
> +	struct crypto_ahash *reqtfm = crypto_ahash_reqtfm(req);
> +	struct spacc_crypto_ctx *tctx = crypto_ahash_ctx(reqtfm);
> +	struct spacc_crypto_reqctx *ctx = ahash_request_ctx(req);
> +	struct spacc_priv *priv = dev_get_drvdata(tctx->dev);
> +	const struct spacc_alg *salg = spacc_tfm_ahash(&reqtfm->base);
> +
> +	/* direct single shot digest call */
> +	ctx->single_shot = 1;
> +	ctx->total_nents = sg_nents(req->src);
> +
> +	/* alloc tmp_sgl */
> +	tctx->tmp_sgl = kmalloc(sizeof(*tctx->tmp_sgl) * 2, GFP_KERNEL);
> +
> +	if (!tctx->tmp_sgl)
> +		return -ENOMEM;

You should use a software fallback to handle the failure case.

Also GFP_KERNEL cannot be used because this path may be called
from softirqs.  Please use GFP_ATOMIC.

> +	sg_init_table(tctx->tmp_sgl, 2);
> +	tctx->tmp_sgl[0].length = 0;
> +
> +	if (tctx->handle < 0 || !tctx->ctx_valid) {
> +		priv = NULL;
> +		priv = dev_get_drvdata(salg->dev);
> +		tctx->dev = get_device(salg->dev);
> +
> +		rc = spacc_is_mode_keysize_supported(&priv->spacc,
> +						     salg->mode->id, 0, 1);
> +		if (rc)
> +			tctx->handle = spacc_open(&priv->spacc,
> +						  CRYPTO_MODE_NULL,
> +						  salg->mode->id, -1, 0,
> +						  spacc_digest_cb,
> +						  reqtfm);

This thing needs to be redesigned.  The digest function can be
called from softirq context, so it must never sleep.  The function
spacc_open tries to obtain a mutex and this cannot possibly work.

I think you should hook this up to crypto_engine which would allow
your driver to sleep.

Another request is that your driver is too big to review.  Please
submit one functionality at a time so that it's easier for me.  Perhaps
start with just skcipher since that's where spacc_open is currently.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
