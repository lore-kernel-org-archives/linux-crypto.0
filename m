Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8C8207DF3;
	Mon,  5 May 2025 12:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746448095; cv=none; b=M9ZcOu+rvCiC/fi7k+a9i+wanehjMgoZ1cqOYtwGYU50dS7IFw8ynoA7jw9Gw99LhxKshPS1XJWwMzu7flLfTYtfP3ekWKDGMjVXZBTMBvJIyaiEMPqZyQlOE9KzChv/AZNrDxPZxrkdJueQE7/yLfyVG1DO8U9vn88+h1A4Zq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746448095; c=relaxed/simple;
	bh=Z69FCtu1r+ndkYq5XR5rcqeiaNjXG25NQ6VehquV3HU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WgHYFbVhmauXjYHSFFy8RV0C9kiXHcoX3SepzIpBG5Ck5lU00BUdcl/PYG4SUcJECUAEVXopLg4bAj0nGGFcsbH+s+d5kaPf7K1h4EBpVJJeBQMORl0LPUx6P5dxYL1Da5NtwMJOpT3hFP/1wz/SpuYeiC7o6xkIU2RGv3tbs/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=b5O+J/UM; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="b5O+J/UM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=QThOCW+spE4F0Srm+t3y3bO2Fskva0qz0HPI3WJ3OuI=; b=b5O+J/UMfheJprS0FNIu39QNrM
	62+1pNEYJ1B82BoYcJ+BUzBGUN1UtoFblR5Uf/YOCTQX1Zd4Tb8drZNnD+ZN9RgJtZJJHqPgnix3g
	6ttmCpDmKNBmTYsOy3XaD3cCHiUESN0dOhtcVk3msOvK3wwFMQXsAotObNwy68uV5qub6zCZ1jkvE
	pJ1Go73Kk3j7nmi1LXwcyd67gRdst31E8KSUPLR4O+Ls8eJHtotmlYWaPGPItxgFRzySRi1pFeICa
	rQOAmc07b2nnRhn6dKL3ZTGOKomtfl3xoO0ecu+K/misbBAy5+7VXhT0uq0fRzKW/DD73CxINB1qM
	L87UyfGA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uBuv2-003YHw-2t;
	Mon, 05 May 2025 20:27:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 05 May 2025 20:27:36 +0800
Date: Mon, 5 May 2025 20:27:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Cc: Daniel Golle <daniel@makrotopia.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Olivia Mackall <olivia@selenic.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>, Jonas Karlman <jonas@kwiboo.se>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	kernel@collabora.com, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] RK3576 Hardware RNG
Message-ID: <aBiuuOAcq1rCM0Ob@gondor.apana.org.au>
References: <20250430-rk3576-hwrng-v1-0-480c15b5843e@collabora.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250430-rk3576-hwrng-v1-0-480c15b5843e@collabora.com>

On Wed, Apr 30, 2025 at 06:16:33PM +0200, Nicolas Frattaroli wrote:
> Gee Nicolas, how come your mom lets you write two Rockchip HWRNG drivers
> in a year?
> 
> In short, RK3576 (and RK3562 and RK3528) introduce another HWRNG IP. It
> actually has quite a few cool features, but I ignored the cool bits and
> went straight for the true entropy. Some of the cool bits someone else
> may wish to add in the future: AES-CTR PRNG that's regularly reseeded
> from the entropy, adjustments for oscillator and oscillator ring lengths
> to maximise entropy generation, automatic continuous quality checking of
> the produced entropy by the hardware itself, etc.
> 
> In testing, it seems to produce about 2 mbit/s of high quality entropy
> on the RK3576 with its default settings when we read the TRNG entropy
> output directly. That's less than we'd get if we had the hardware use
> the PRNG to stretch it, but I've decided to leave that up to Linux's
> entropy pool implementation for now.
> 
> RK3562 and RK3528 probably just need a compatible and a DTS node to
> enable it as well, but I don't have any RK3562/RK3528 boards to test
> this with, so it's not done in this series.
> 
> Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
> ---
> Nicolas Frattaroli (3):
>       dt-bindings: rng: rockchip,rk3588-rng: add rk3576-rng compatible
>       hwrng: rockchip - add support for RK3576's RNG
>       arm64: dts: rockchip: add RK3576 RNG node
> 
>  .../bindings/rng/rockchip,rk3588-rng.yaml          |  5 +-
>  arch/arm64/boot/dts/rockchip/rk3576.dtsi           |  8 +++
>  drivers/char/hw_random/rockchip-rng.c              | 73 ++++++++++++++++++++++
>  3 files changed, 84 insertions(+), 2 deletions(-)
> ---
> base-commit: 4e0a9c660788594b5b49ac07f0fbdccd2218431e
> change-id: 20250429-rk3576-hwrng-8c308b5711ae
> 
> Best regards,
> -- 
> Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

Patches 1-2 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
