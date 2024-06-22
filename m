Received: from hall.aurel32.net (hall.aurel32.net [195.154.113.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B6E14B09C;
	Sat, 22 Jun 2024 10:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.154.113.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719053013; cv=none; b=rLHsTEClA9l5leN4pSkcx/K8KELhqTWGse99RZhNtgZ2V55364Vhcx3qLscImfz0LtgbOHgAO+XtD934zwfzGJA5oFDeC/8YGZexx6tTzypJM+5g29L9CHg+uQFOS5SlaFAD47e5EJEUKp4DSx3e7nTidX10ZEtocMEZ83e8720=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719053013; c=relaxed/simple;
	bh=LVfYR8/jFkVpAgI5c9DnudXm1sPcC5/oQYIYNdp8Jys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mfrpAsHEHqTRB6X2IOHRVfQniHPxGcZi5b78H8RujVF4MC3xSNwrNBt6oed/IvZZUVqW61Zz5KHF5i8licOe1LfjmNmN82l98oQOaX7VOhbhrVOstYr8frNfSSfBFX0o6DUPAQmNTdA9swFnfUmn/qR4PApCX5VgKg8JLpwRI3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=aurel32.net; spf=pass smtp.mailfrom=aurel32.net; dkim=pass (2048-bit key) header.d=aurel32.net header.i=@aurel32.net header.b=bTv1y0xU; arc=none smtp.client-ip=195.154.113.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=aurel32.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aurel32.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aurel32.net header.i=@aurel32.net header.b="bTv1y0xU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=aurel32.net
	; s=202004.hall; h=In-Reply-To:Content-Type:MIME-Version:References:
	Message-ID:Subject:Cc:To:From:Date:Content-Transfer-Encoding:From:Reply-To:
	Subject:Content-ID:Content-Description:X-Debbugs-Cc;
	bh=L7GES3nlJ/mbxpjgjMloPbQ6xU28njSFXetD3IW/C9k=; b=bTv1y0xUMPOFAGcp8NXNG5sAri
	9Wuf4Hr94UiZ7MZR0BqUJALKC7GisIpFxsW4LjUzSTu1FQa6X6/y1SDljDg3i+o2SYsmilCnpGMmt
	CbkRrHufQlZoVG/xB9JElfWnkZp8zN4O9JUqJfB+BjT42Xt+9oCe/VUU5TuPkmepcyVGseWADjq2b
	cj2nad8/d1eEV2nuXGQo+5U/ebwR2rLenZBgHimL1u9n/wlKqDQcyCZZCZY+GI+SnPDQFkaePavUf
	KzQEhPT/Mso/7rXN/RH21FOxsdKDOYvAKYTGT2lc97Jjyt56u0C1qbY7b2LoeI6bbTsFUMb5cK9mp
	KNunQfcw==;
Received: from [2a01:e34:ec5d:a741:1ee1:92ff:feb4:5ec0] (helo=ohm.rr44.fr)
	by hall.aurel32.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <aurelien@aurel32.net>)
	id 1sKxVY-003oby-0i;
	Sat, 22 Jun 2024 11:58:08 +0200
Date: Sat, 22 Jun 2024 11:58:06 +0200
From: Aurelien Jarno <aurelien@aurel32.net>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <ukleinek@debian.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Anand Moon <linux.amoon@gmail.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Martin Kaiser <martin@kaiser.cx>, Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] hwrng: add hwrng support for Rockchip RK3568
Message-ID: <ZnagLpqZS4UjDR6T@aurel32.net>
Mail-Followup-To: Daniel Golle <daniel@makrotopia.org>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <ukleinek@debian.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Anand Moon <linux.amoon@gmail.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Martin Kaiser <martin@kaiser.cx>, Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1718921174.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1718921174.git.daniel@makrotopia.org>
User-Agent: Mutt/2.2.12 (2023-09-09)

Hi Daniel,

On 2024-06-21 02:24, Daniel Golle wrote:
> Rockchip SoCs used to have a random number generator as part of their
> crypto device, and support for it has to be added to the corresponding
> driver.
> 
> However newer Rockchip SoCs like the RK3568 have an independent True
> Random Number Generator device. This patchset adds a driver for it and
> enable it in the device tree.
> 
> v2 of this patchset has been submitted by Aurelien Jarno in November
> 2022. A follow-up submission addressing the comments received for v2
> never happened.

I didn't have the time or energy to continue working on this. Thanks for
continuing the work, I'll give it a try at some point.

Regards
Aurelien

-- 
Aurelien Jarno                          GPG: 4096R/1DDD8C9B
aurelien@aurel32.net                     http://aurel32.net
