Received: from norbury.hmeau.com (helcar.hmeau.com [216.24.177.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B305B629;
	Sat,  6 Jul 2024 00:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.24.177.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720225047; cv=none; b=CYB5zfiX73mW0gVAv8x9kwX0yjdWU9pr3vkd6rRTkQp3aOrs/KXk+w53lXZCIkHS6n9vBRssfOJje6zIboljeh8aLQ92nwiQxPImGnfnhPCU/le94ZnZr6uR7sRh53uN6WiOyf4FS9HUo2AwhuuIvBZOJvFMm/3CCb0irP2sCCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720225047; c=relaxed/simple;
	bh=cMJATAPOvLQoqwfPFRdiXpLFlGIrRlz9nAZQSkU3gS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t6pCmRhQ1zN74D/u5PSGB8dWdnLcWVqE3o2EkXe31RZ1fAyK418zN/HNwrdDdbtoeRAB4+QKQQm36RWkpmxYjr/gvZ5SeFecp+whpKKeYOpiwa51sHy95G8mVcmtWq2unMOZ+jhoIohmaHE4BJ3pDddnAfxlcX0DhBoPlWM8Gi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=216.24.177.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
	by norbury.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sPt5o-006giK-2U;
	Sat, 06 Jul 2024 10:16:11 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 06 Jul 2024 10:15:57 +1000
Date: Sat, 6 Jul 2024 10:15:57 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Aurelien Jarno <aurelien@aurel32.net>,
	Olivia Mackall <olivia@selenic.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@debian.org>,
	Dragan Simic <dsimic@manjaro.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Martin Kaiser <martin@kaiser.cx>, Tony Luck <tony.luck@intel.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/3] hwrng: add hwrng driver for Rockchip RK3568 SoC
Message-ID: <ZoiMvTzXMFxkfcJF@gondor.apana.org.au>
References: <cover.1719365405.git.daniel@makrotopia.org>
 <15b001360cffc0832e7e2748ad900b1336e0fa32.1719365406.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15b001360cffc0832e7e2748ad900b1336e0fa32.1719365406.git.daniel@makrotopia.org>

On Wed, Jun 26, 2024 at 02:37:10AM +0100, Daniel Golle wrote:
>
> +#ifndef CONFIG_PM
> +	rk_rng->rng.init = rk_rng_init;
> +	rk_rng->rng.cleanup = rk_rng_cleanup;
> +#endif

Please rewrite this as

	if (!IS_ENABLED(CONFIG_PM)) {
		...
	}

> +#ifdef CONFIG_PM
> +static int rk_rng_runtime_suspend(struct device *dev)
> +{
> +	struct rk_rng *rk_rng = dev_get_drvdata(dev);
> +
> +	rk_rng_cleanup(&rk_rng->rng);
> +
> +	return 0;
> +}
> +
> +static int rk_rng_runtime_resume(struct device *dev)
> +{
> +	struct rk_rng *rk_rng = dev_get_drvdata(dev);
> +
> +	return rk_rng_init(&rk_rng->rng);
> +}
> +#endif

These ifdefs should just disappear, with __maybe_unused added
instead.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
