Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384DB30F957;
	Sat, 31 Jan 2026 02:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769828268; cv=none; b=oPC9WGgm2q8WZyDHztglc5zD1qjB/L5XwownJwEzMmcshnG/09L0JA/lQf/lCTx0OnfJlA5YBYwXeqyjG/XVYvxAIYXYSI7pu1BjiGSvs1JgKiSrchPYn+jx9hhWxX7GhcfWBtzRITXPAoFBSXBNFSOnAcOvZ59ixxlaGhsAQHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769828268; c=relaxed/simple;
	bh=Hv6fVzSSkS5TMg+Bv/8xYIUfDlpPRu1M7eFCPb4nc2o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=npSi1hlmzrAMTO9qLz1iZ4t4vVhvo9LrsnSHyX1W7gila6v6RSiNwdwLfGJWXoAf71E8t9nSrCx8RAQy23PK6HWMAmndYxLdhtK+OQnsFaL/RiVsqIlO4fnSd8Tvgr/i1Tu00SafRW5doxES1k4zg4S4eARkHD6XW2h1yGEhDMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=By+Agdnc; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="By+Agdnc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=3wOThwjVEjG7NQ8lLaWkkzYwTr8y0NPlBDgaBGr3XXw=; 
	b=By+AgdncMdzlIMzRIK30y3oQ0fLmq1VtJRb1xEb5FzqSPF7oVWGxezbu5+8YmMtVgwHU0zk/kAH
	d6Xq9+oXd+hdFXjmSoPWZ6BwJqTbbdpg0mkukIXiNJu0KaVjn6T3b9xSe8hNCMO2VMSOhotdrU5dk
	VlcLB8YmlQFCmpvYTh1QAeUrxploNeXWZvVVtOdE9lxpo5P6VQoQhFEWizfUXbKojAgcjvO6jkw6i
	fb7BbYvOGfl11Zh6hxEw86K/wHQDIzMzb+o+Lq1PRkqA4CH6Bsj7POkXoeUiX40Z4Pjcm9GlpDL2c
	h2DtyGc/oFK7fPwNmziDuPkSL8LhPqyLpnDQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vm1Aa-003S1b-1y;
	Sat, 31 Jan 2026 10:57:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 31 Jan 2026 10:57:08 +0800
Date: Sat, 31 Jan 2026 10:57:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Robert Marko <robert.marko@sartura.hr>
Cc: robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
	nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev, davem@davemloft.net, lee@kernel.org,
	andrew+netdev@lunn.ch, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, Steen.Hegelund@microchip.com,
	daniel.machon@microchip.com, UNGLinuxDriver@microchip.com,
	linusw@kernel.org, olivia@selenic.com, richard.genoud@bootlin.com,
	radu_nicolae.pirea@upb.ro, gregkh@linuxfoundation.org,
	richardcochran@gmail.com, horatiu.vultur@microchip.com,
	Ryan.Wanner@microchip.com, tudor.ambarus@linaro.org,
	kavyasree.kotagiri@microchip.com, lars.povlsen@microchip.com,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
	linux-spi@vger.kernel.org, linux-serial@vger.kernel.org,
	luka.perkov@sartura.hr
Subject: Re: [PATCH v5 00/11] Add support for Microchip LAN969x
Message-ID: <aX1vhJ7SCu5JB2ga@gondor.apana.org.au>
References: <20260115114021.111324-1-robert.marko@sartura.hr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115114021.111324-1-robert.marko@sartura.hr>

On Thu, Jan 15, 2026 at 12:37:25PM +0100, Robert Marko wrote:
> This series adds support for the Microchip LAN969x switch SoC family.
> 
> Series is a bit long since after discussions in previous versions, it was
> recommended[1][2] to add SoC specific compatibles for device nodes so it
> includes the required bindings updates.
> 
> [1] https://lore.kernel.org/all/20251203-splendor-cubbyhole-eda2d6982b46@spud/
> [2] https://lore.kernel.org/all/173412c8-c2fb-4c38-8de7-5b1c2eebdbf9@microchip.com/
> [3] https://lore.kernel.org/all/20251203-duly-leotard-86b83bd840c6@spud/
> [4] https://lore.kernel.org/all/756ead5d-8c9b-480d-8ae5-71667575ab7c@kernel.org/
> 
> Signed-off-by: Robert Marko <robert.marko@sartura.hr>
> 
> Changes in v5:
> * Picked Acked-by and Reviewed-by tags
> * Change clock header license to match the DTSI one
> * Alphabetize EV23X71A pin nodes
> * Remove the requirment for all ethernet-port nodes to have phys property
> as when RGMII is used there is no SERDES being used
> * Drop phys from RGMII port on EV23X71A
> * Drop USB, DMA, MIIM, SPI and I2C bindings as those were already picked
> 
> Changes in v4:
> * Pick Acked-by from Andi for I2C bindings
> * Move clock indexes from dt-bindings into a DTS header as suggested by
> Krzysztof[4]
> 
> Changes in v3:
> * Pick Acked-by from Conor
> * Drop HWMON binding as it was picked into hwmon already
> * Document EV23X71A into AT91 binding
> * Drop SparX-5 and AT91 bindings merge
> * Apply remark from Conor on DMA binding regarding merging cases
> 
> Changes in v2:
> * Change LAN969x wildcards to LAN9691 in patches
> * Split SoC DTSI and evaluation board patches
> * Add the suggested binding changes required for SoC specific compatibles
> * Merge SparX-5 and AT91 bindings as suggested[3]
> 
> Robert Marko (11):
>   dt-bindings: mfd: atmel,sama5d2-flexcom: add microchip,lan9691-flexcom
>   dt-bindings: serial: atmel,at91-usart: add microchip,lan9691-usart
>   dt-bindings: rng: atmel,at91-trng: add microchip,lan9691-trng
>   dt-bindings: crypto: atmel,at91sam9g46-aes: add microchip,lan9691-aes
>   dt-bindings: crypto: atmel,at91sam9g46-sha: add microchip,lan9691-sha
>   dt-bindings: pinctrl: pinctrl-microchip-sgpio: add LAN969x
>   arm64: dts: microchip: add LAN969x clock header file
>   arm64: dts: microchip: add LAN969x support
>   dt-bindings: arm: AT91: document EV23X71A board
>   dt-bindings: net: sparx5: do not require phys when RGMII is used
>   arm64: dts: microchip: add EV23X71A board
> 
>  .../devicetree/bindings/arm/atmel-at91.yaml   |   6 +
>  .../crypto/atmel,at91sam9g46-aes.yaml         |   1 +
>  .../crypto/atmel,at91sam9g46-sha.yaml         |   1 +
>  .../bindings/mfd/atmel,sama5d2-flexcom.yaml   |   1 +
>  .../bindings/net/microchip,sparx5-switch.yaml |  15 +-
>  .../pinctrl/microchip,sparx5-sgpio.yaml       |  20 +-
>  .../bindings/rng/atmel,at91-trng.yaml         |   1 +
>  .../bindings/serial/atmel,at91-usart.yaml     |   1 +
>  arch/arm64/boot/dts/microchip/Makefile        |   1 +
>  arch/arm64/boot/dts/microchip/clk-lan9691.h   |  24 +
>  arch/arm64/boot/dts/microchip/lan9691.dtsi    | 488 +++++++++++
>  .../boot/dts/microchip/lan9696-ev23x71a.dts   | 756 ++++++++++++++++++
>  12 files changed, 1309 insertions(+), 6 deletions(-)
>  create mode 100644 arch/arm64/boot/dts/microchip/clk-lan9691.h
>  create mode 100644 arch/arm64/boot/dts/microchip/lan9691.dtsi
>  create mode 100644 arch/arm64/boot/dts/microchip/lan9696-ev23x71a.dts
> 
> -- 
> 2.52.0

Patches 4-5 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
