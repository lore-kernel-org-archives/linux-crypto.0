Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2637A145FE5;
	Sun, 23 Jun 2024 13:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719148151; cv=none; b=cnrm0Tfo5ssV7BQ6SVgbLJy9vHi3cagWMtP0HSoMI5wyMXYititWh+cABoct1nsi7GKElQcQsuENgJLbngb5Z0IztBcquB03zDdlfJRAQaQmpsK1dqnLSvQMmGrec9dgajeRspmiDc/EKpZmBR7dMgAQe3wsSxiByDgJ/CE8hT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719148151; c=relaxed/simple;
	bh=Glj3PVhq07s9ybEWPOZIinwXH1m+JqkijiqUrCCJCbw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EOooGQuuBsJ9suhd8JFdl+OFD/d7DkLTi1fCD/nBXclOSabAY9h21AZZPMzI720NSjiqIE+fmHKIzu73KHIevMk6iUIXa6QT6wVOQ8QoU7lzuUSIc/R2Mptg1p0hkebzgNlPP8G3ZMAvI4/ehHaDDok/FRTpJE3Zqr+nB3s3Kok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.97.1)
	(envelope-from <daniel@makrotopia.org>)
	id 1sLMxY-0000000081f-4C5p;
	Sun, 23 Jun 2024 13:08:45 +0000
Date: Sun, 23 Jun 2024 14:08:35 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Aurelien Jarno <aurelien@aurel32.net>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@debian.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Dragan Simic <dsimic@manjaro.org>, Martin Kaiser <martin@kaiser.cx>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] dt-bindings: rng: Add Rockchip RNG bindings
Message-ID: <ZngeUxK6r0qqBj28@makrotopia.org>
References: <cover.1719106472.git.daniel@makrotopia.org>
 <b28ccedac0a51f8a437f7ceb5175e3b70696c8c2.1719106472.git.daniel@makrotopia.org>
 <a31bc0f2-4f82-4e15-95b8-c17dc46e7bf5@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a31bc0f2-4f82-4e15-95b8-c17dc46e7bf5@kernel.org>

Hi Krzysztof,

thank you for your patiente and repeated review of this series.

On Sun, Jun 23, 2024 at 09:03:15AM +0200, Krzysztof Kozlowski wrote:
> On 23/06/2024 05:32, Daniel Golle wrote:
> > From: Aurelien Jarno <aurelien@aurel32.net>
> > 
> > Add the True Random Number Generator on the Rockchip RK3568 SoC.
> > 
> > Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
> > Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> 
> My comments from v2, which I reminded at v3, were not addressed.
> 
> Respond to each of them and acknowledge that you are going to implement
> the change.

Your comments to v1which I'm aware of are:
https://patchwork.kernel.org/comment/25087874/

> > +++ b/Documentation/devicetree/bindings/rng/rockchip-rng.yaml
> Filename matching compatible, so "rockchip,rk3568-rng.yaml"

I've changed the filename.

> > +title: Rockchip TRNG bindings

> Drop "bindings"

I've changed the title accordingly (now: "Rockchip TRNG" in v4).

> > +description:
> > +  This driver interface with the True Random Number Generator present in some
> 
> Drop "This driver interface" and make it a proper sentence. Bindings are
> not about drivers.

This has been addressed by Aurelien and further improved by me in v3.

> > +  clocks:
> > +    minItems: 2

> Drop minItems.

Aurelien did that in v2.

> > +  clock-names:
> > +    items:
> > +      - const: clk
> > +      - const: hclk
> 
> You need to explain what are these in clocks. Also you need better
> names. A clock name "clk" is useless.

Clocks now have meaningful names and descriptions.

> > +  reset-names:
> > +    items:
> > +      - const: reset
> 
> Drop reset-names entirely, not useful.

Aurelien did so in v2.

Your comments to v2 which I'm aware of are:
https://patchwork.kernel.org/comment/25111597/

> > Add the RNG bindings for the RK3568 SoC from Rockchip

> Use subject prefixes matching the subsystem (git log --oneline -- ...),
> so it is rng, not RNG. Also, you are not adding all-Rockhip RNG but a
> specific device.
> 
> Subject: drop second, redundant "bindings".

I've changed 'RNG' into 'rng' in the subject and spelled it out in the
commit message.

> > +description: True Random Number Generator for some Rockchip SoCs
> 
> s/for some Rockchip SoCs/on Rokchip RK3568 SoC/

I've adopted your suggestion in v3 and then fixed the typo in v4.

> 
> > +  clock-names:
> > +    items:
> > +      - const: trng_clk
> > +      - const: trng_hclk

> These are too vague names. Everything is a clk in clock-names, so no
> need usually to add it as name suffix. Give them some descriptive names,
> e.g. core and ahb.

If changed the names to the suggested 'core' and 'ahb'.

Before sending another round of patches, just to make sure we are on
the same page, please confirm that what remains is
Subject: dt-bindings: rng: Add Rockchip RNG bindings
which not only should be 'rng' in small letters but also name the exact
chip, eg.:
Subject: dt-bindings: rng: add TRNG on the Rockchip RK3568 SoC

If there are any other comments you made which I'm not aware of, please
point me to them.


Cheers


Daniel
