Received: from hall.aurel32.net (hall.aurel32.net [195.154.113.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D25F63D;
	Sun, 23 Jun 2024 10:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.154.113.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719139422; cv=none; b=CXgvl5Ufv9I8eQfm1+ctcWVhSosi038T/qQvvJp0/izhey/VGx/iqV5qiaDqKjpTXbkX9PuwL4P4WHMElHTzNPFcIhk9ilqfqd7eRNuUBN+VDNJXKzvWevjVNCjyl07ZCT8S4tgazPUaQMDibpx8pKyQrRYTW/98XASufsIjpEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719139422; c=relaxed/simple;
	bh=Qjr+hGbELVoM/PRT/OT/56EzWqjLqLpwPtYcTtfmTfw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PfHazyKnBMD2QVMvadZeI2w1nTv6Opb0HdGiOhVRMiJxUEs587lny5aF1OHl4ndJiLQtHNJ8ONwwprqR6EEmLRMYNsS2/+NwL5jmRmn7/mlSKPKxcV8mXYQz8pHv2yVQGwnWmytgVKq/1FT09pr/Pe7dtKKGRrtTAco7mITjdgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=aurel32.net; spf=pass smtp.mailfrom=aurel32.net; dkim=pass (2048-bit key) header.d=aurel32.net header.i=@aurel32.net header.b=tTGJofW/; arc=none smtp.client-ip=195.154.113.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=aurel32.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aurel32.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aurel32.net header.i=@aurel32.net header.b="tTGJofW/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=aurel32.net
	; s=202004.hall; h=In-Reply-To:Content-Type:MIME-Version:References:
	Message-ID:Subject:Cc:To:From:Date:Content-Transfer-Encoding:From:Reply-To:
	Subject:Content-ID:Content-Description:X-Debbugs-Cc;
	bh=cOPGiZTRLTkSPLlPpnHXwm++QfEHnrjcKdztZiRkX3A=; b=tTGJofW/SnqoWjxA4acUKT5+gG
	Mr4PhiFFC6KqT7c3h2SomxcHqkUoUNzKL6Gsj9JEPfqjc/P3H5AJ6MS7c7HDl8TxeJq1cB0HR1xLL
	wVD2IK2vijGTCx26lZk/fWQan/cjSxrsFGFP8XZ7Hc1VWv8y8o++ro6tkJSdnJ+0gkXR4cukDpu3a
	IYnEvXxLTwZMCzMMjHNhDNv5WufbbugCEWok5HM+VhzXveTHo26izRbQyeY2AUqqEeGyMZqXHTopl
	OLM1pco+3K/9vsAX5rC3eSj8kLBWhC3V8DtmmcepeB4SD3RTgLw/JwmzaU9MhOT19P+9N1ZXvooG5
	Rv2hpWTw==;
Received: from ohm.aurel32.net ([2001:bc8:30d7:111::2] helo=ohm.rr44.fr)
	by hall.aurel32.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <aurelien@aurel32.net>)
	id 1sLKgI-0057EX-1S;
	Sun, 23 Jun 2024 12:42:46 +0200
Date: Sun, 23 Jun 2024 12:42:45 +0200
From: Aurelien Jarno <aurelien@aurel32.net>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Daniel Golle <daniel@makrotopia.org>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <ukleinek@debian.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Dragan Simic <dsimic@manjaro.org>, Martin Kaiser <martin@kaiser.cx>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/3] hwrng: add Rockchip SoC hwrng driver
Message-ID: <Znf8JeBA4mzVa0V1@aurel32.net>
Mail-Followup-To: Krzysztof Kozlowski <krzk@kernel.org>,
	Daniel Golle <daniel@makrotopia.org>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <ukleinek@debian.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Dragan Simic <dsimic@manjaro.org>, Martin Kaiser <martin@kaiser.cx>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1719106472.git.daniel@makrotopia.org>
 <240db6e0ab07e8e2a86da99b0fc085eabaf9f0cc.1719106472.git.daniel@makrotopia.org>
 <612bd49c-c44a-41f2-89e9-c96e62e52a0a@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <612bd49c-c44a-41f2-89e9-c96e62e52a0a@kernel.org>
User-Agent: Mutt/2.2.12 (2023-09-09)

Hi,

On 2024-06-23 09:00, Krzysztof Kozlowski wrote:
> On 23/06/2024 05:33, Daniel Golle wrote:
> > +
> > +	rk_rng->rng.name = dev_driver_string(dev);
> > +#ifndef CONFIG_PM
> > +	rk_rng->rng.init = rk_rng_init;
> > +	rk_rng->rng.cleanup = rk_rng_cleanup;
> > +#endif
> > +	rk_rng->rng.read = rk_rng_read;
> > +	rk_rng->rng.priv = (unsigned long) dev;
> > +	rk_rng->rng.quality = 900;
> 
> I doubt in this value. Usually SoC vendors do not provide datasheet with
> any reliable and verifiable (so one which could be proven by 3rd party)
> information. Can you provide a source? (and vendor downstream tree does
> not really count)

As the original author of the patch, I am the one who have chosen the
value. I did it as explained in the commit message:

| The TRNG device does not seem to have a signal conditionner and the FIPS
| 140-2 test returns a lot of failures. They can be reduced by increasing
| RK_RNG_SAMPLE_CNT, in a tradeoff between quality and speed. This value
| has been adjusted to get ~90% of successes and the quality value has
| been set accordingly.

It is also explained, admittedly more briefly, above the
RK_RNG_SAMPLE_CNT #define, as the commit messages are not really
relevant anymore once the patches are accepted:

| * TRNG collects osc ring output bit every RK_RNG_SAMPLE_CNT time. The value is
| * a tradeoff between speed and quality and has been adjusted to get a quality
| * of ~900 (~90% of FIPS 140-2 successes).
| */

The decision to adjust RK_RNG_SAMPLE_CNT to reach ~90% of FIPS 140-2
successes was based on the quality chosen by most hw_random drivers
currently in the kernel sources. The FIPS 140-2 tests were performed
using rngtest from the rng-tools project.

All that said, I am not an expert in that domain, so feel free to point
to the documentation or provide the correct method to determine the
quality.

Regards
Aurelien

[1] https://git.kernel.org/pub/scm/utils/kernel/rng-tools/rng-tools.git/

-- 
Aurelien Jarno                          GPG: 4096R/1DDD8C9B
aurelien@aurel32.net                     http://aurel32.net
