Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC4C3770B;
	Sat,  7 Mar 2026 01:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772846354; cv=none; b=ZE5u/wmRBdr84nwK6b42RZCjRYYbPURqpPMp0Z9nNEfq85d+p98sCH+/nz/Kec/5hJInlSm8hQ7Hl+mshUPD9Mj0ZThSVYqjEeuQ5L8YHv/KUGAghfckX/3TCtF/KFylzY/3xcU6pWR2zZTKdB6ir3+Bphq6HKj8IFY33bRdTqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772846354; c=relaxed/simple;
	bh=wxgbKGT1EqgXq+zw8rGKOUxOFQwJnilipuO+pbXJc1M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YLdkpYI2j6hawTeRd3iYAfXBEZHkMZ4DAY9LW/VhBqIukk8wPT0uW4ESGdOKQJrgIvPsTpYWIIES/4Wtrr8DG6bW/cVKJuLtM7k6PXdiFhgOmaSLXo9u9/Jp/t69C/7GKueK0gNuYa15bBW/eDTCxeFY9KJ3ExTVCest6O11wKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=aOkayWuS; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="aOkayWuS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=o/ZxNyA3pn29ikifVsDAjNTe1Wnut0ABulyc6uImSnA=; 
	b=aOkayWuSeO9roHu0iEiaWXlKkxuFRfUXO0oir9srfykWQsP7lDypQQqAtMLZuhM/3zjgYX9n7sO
	+wuz3XYzdgcNSPlNArEwaJB8uneoyCBjKnc6wnyVFWCux1b6k/wL3xB+LWJAMDoCNFrTOkqfTdyB3
	ZjsA9dnQdvG564cimvvpoD2flKRel/FSpFbssA1Ow6aFoHtchlG5q4h+UBbnyE8TKedmHlnI9b+Di
	zTrqw+/YT1Sx/K9x6Bv+F68c9NXD1G7BcwxHsApSo61AESg1SEuEmw1q1NdlyKyxeFanxR6E0LCxM
	LwovuJyAswxf648s3tMctkXx/YDiHRakenGQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vygJv-00CHVo-2e;
	Sat, 07 Mar 2026 09:19:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 07 Mar 2026 10:19:07 +0900
Date: Sat, 7 Mar 2026 10:19:07 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, robh@kernel.org, krzk+dt@kernel.org,
	conor+dt@kernel.org, Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com, adityak@vayavyalabs.com,
	navami.telsang@vayavyalabs.com, bhoomikak@vayavyalabs.com
Subject: Re: [PATCH v10 2/4] crypto: spacc - Add SPAcc ahash support
Message-ID: <aat9C91EwAj2GRhd@gondor.apana.org.au>
References: <20260219114130.779720-1-pavitrakumarm@vayavyalabs.com>
 <20260219114130.779720-3-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260219114130.779720-3-pavitrakumarm@vayavyalabs.com>

On Thu, Feb 19, 2026 at 05:11:28PM +0530, Pavitrakumar Managutte wrote:
>
> +static int spacc_hash_init_tfm(struct crypto_ahash *tfm)
> +{
> +	int rc = 0;
> +	const struct spacc_alg *salg = container_of(crypto_ahash_alg(tfm),
> +						    struct spacc_alg,
> +						    alg.hash.base);
> +	struct spacc_crypto_ctx *tctx = crypto_ahash_ctx(tfm);
> +
> +	tctx->handle    = -1;
> +	tctx->ctx_valid = false;
> +	tctx->keylen    = 0;
> +	tctx->fb.hash   = NULL;
> +	tctx->tmp_sgl   = NULL;
> +	tctx->tmp_sgl_buff = NULL;
> +	tctx->dev       = get_device(salg->dev);
> +
> +	tctx->fb.hash = crypto_alloc_ahash(crypto_ahash_alg_name(tfm), 0,
> +			CRYPTO_ALG_NEED_FALLBACK);

Every async ahash algorithm automatically gets a fallback from
the API so there is no need to allocate one yourself.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
