Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794477926;
	b=JWgPYTgTb5aA1J55CDZ2PfWB1n9v++32MC48sdYH+WQEpwACM5E+1GCeMNnbzNTb6pvg
	 04u18clHZ97i75i2ObL9ypZEIHO3M6+xwj+tDka77azpg8Vl9zpKqZpEYsGMTv6LWkiS1
	 fIwnF8qC8RwY1OkE+qupgJKQNQY21aQGYN/xqIloVlsO/mMX8EqXEsFbcbb7ABswOvaSJ
	 GXDcJeMY95JqXkZWvB/4tHN0sWhYMr5jf4Bx7e2Rgfo08JR7fLJBArkazvJYS5CkRUvzw
	 9R4H8NdSXBdT45AI2nnJ7+hJ676m90sD25l1wjmaiTRMuafEcFbIKQWfAx93N47sE8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794477926;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=Ghmp6AutYLYldBifLkalyI9ACbjFKHJIiuKIAmtfZNQ=;
	b=hAT16ASMhKxRu9XZMMPl3BcZP0adhYAEDdrOHrMC6RNvBlujA1zOH8K3YwAbWap0oKCo
	 hdGIcCsvJ9nAkfTjJ25qqnxyxXzdyeFWnZ7NkCSN/Wb4rJkTilQvDgI6BrEuHfGa9vXKg
	 7T+9jseWKdhUju3JAEu9d5WnpNftcJMttCaf7dGt6cb7bdHrfp0iMj9oYrWc6mzr0vZ0P
	 LaJV04f/45Pbv0loHg5gtlPI5mRGszuCSf5OZzbLszZjd3UEEY9W3ny9CYkCoL75zVYrm
	 GfHsAMeGlzygEIheWgGEXpm/mtf4MnXVJuU4Nil50UNle1imh8NJPiVKrMPBqJCjm8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=TOR46HFS;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD22606A32A;
	Thu, 12 Nov 2026 10:05:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7FD22606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=TOR46HFS
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Ghmp6AutYLYldBifLkalyI9ACbjFKHJIiuKIAmtfZNQ=; 
	b=TOR46HFSrpgQJDCvxSt9ySHTidPkV/0yfR2ECn+XHS8BHRg3elzg6yPWFBF9IHW9kjvxVvAznrU
	Qq01p7VCdW5EklQEdWHvEyp1lwDI2NedJT/mtNMv6A1sPsWGdoLWIUaE9dcyrbKELEqv9X1YTcSCs
	50sOSIAkau02qKTRN5hM9MKG9ugb2e89IwVuypmCBLflhAiu3d6qPozr8k7bEWXgUc29oGStsgSvi
	8FHQHCGxIfgfJS/Y91x8kgswmOtiArSBv/fOKh3buJNHfNmZ+ie13/WN+yqYPWkzJyGOg8N1gMLJf
	BFgSGk+X4lWf3J/LzI+1IbATGCd4FOlx8ILg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xRRgI-0000000EE0u-1p6I;
	Thu, 12 Nov 2026 18:05:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 12 Nov 2026 18:05:22 +0800
Date: Thu, 12 Nov 2026 18:05:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Fabio Estevam <festevam@gmail.com>
Cc: horia.geanta@nxp.com, pankaj.gupta@nxp.com, sahil.malhotra@nxp.com,
	gaurav.jain@nxp.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Fabio Estevam <festevam@nabladev.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] crypto: caam: jr: Use dedicated shutdown callback
Message-ID: <avWPYp6fA_Y5pgCq@gondor.apana.org.au>
References: <20261028132825.657546-1-festevam@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028132825.657546-1-festevam@gmail.com>

On Wed, Oct 28, 2026 at 10:28:25AM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <festevam@nabladev.com>
> 
> The CAAM job ring platform driver uses caam_jr_remove() as its
> shutdown callback.
> 
> The remove path refuses to shut down a job ring while crypto
> consumers still hold references to it. This is necessary during
> driver unbinding, but causes the following warning on reboot:
> 
> caam_jr 30903000.jr: Device is busy; consumers might start to crash
> 
> Unlike driver removal, system shutdown does not require
> unregistering crypto algorithms or releasing driver resources.
> 
> Introduce a dedicated platform shutdown callback that shuts down
> the hardware job ring without checking consumer references.
> 
> Keep the reference checks and algorithm unregistration in the
> remove path.
> 
> Tested on a i.MX8MP custom-board.
> 
> Cc: stable@vger.kernel.org 
> Fixes: c007e720989e ("crypto: caam/jr - add .shutdown hook")
> Signed-off-by: Fabio Estevam <festevam@nabladev.com>
> ---
>  drivers/crypto/caam/jr.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
