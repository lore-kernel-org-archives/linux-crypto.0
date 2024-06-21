Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC1616EB59;
	Fri, 21 Jun 2024 09:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.11.138.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718963418; cv=none; b=CE1LlYJGary6JlQoFLL1DCwDKvpyUHuWsVMngwJMRVLuUfwFsb7k/KYpTAeMU5ybPauAkR6y3EahG93HeI2p2rNXFIkiSoy4XlrXX1BvJ2viCRQKt5S+W+81WgcU+nWFtsTwc7nSYIWf1/IYdqRMd1qnq9J3O9Glq4ygQf9klwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718963418; c=relaxed/simple;
	bh=xtdLRnYhmq+0nTYyiyr1vnT1az+4mpomWJNS21vlD+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZJyvB6Lzd2jLqtp/8Gv4JyMCDGd1xfFCdC89BEkCTbEfnGn+snRdj4Pe+jPQEuXLDrXZdGrBWcwQWPfEz2nbsIwWXzeTX8wZuz2bKt6iuz8LJkTM8ezgbmJBkeAIBDemu/jkeqtFW1Uc+en9QF79RbdfcfZV9Jjn96YTj1yxcqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sntech.de; spf=pass smtp.mailfrom=sntech.de; arc=none smtp.client-ip=185.11.138.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sntech.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sntech.de
Received: from i5e8616cf.versanet.de ([94.134.22.207] helo=diego.localnet)
	by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <heiko@sntech.de>)
	id 1sKatj-0000eb-JF; Fri, 21 Jun 2024 11:49:35 +0200
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Daniel Golle <daniel@makrotopia.org>,
 Aurelien Jarno <aurelien@aurel32.net>, Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>,
 Philipp Zabel <p.zabel@pengutronix.de>,
 Uwe =?ISO-8859-1?Q?Kleine=2DK=F6nig?= <ukleinek@debian.org>,
 Sebastian Reichel <sebastian.reichel@collabora.com>,
 Anand Moon <linux.amoon@gmail.com>, Dragan Simic <dsimic@manjaro.org>,
 Sascha Hauer <s.hauer@pengutronix.de>, Martin Kaiser <martin@kaiser.cx>,
 Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
 Diederik de Haas <didi.debian@cknow.org>
Cc: Daniel Golle <daniel@makrotopia.org>
Subject:
 Re: [PATCH v3 3/3] arm64: dts: rockchip: add DT entry for RNG to RK356x
Date: Fri, 21 Jun 2024 11:49:33 +0200
Message-ID: <1772829.KUTt5R2Mg1@diego>
In-Reply-To: <5870442.3KgWVfgXFx@bagend>
References:
 <cover.1718921174.git.daniel@makrotopia.org>
 <bd08c142ce6b32cd98014c875c7ccf3657c63f23.1718921174.git.daniel@makrotopia.org>
 <5870442.3KgWVfgXFx@bagend>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Am Freitag, 21. Juni 2024, 11:36:45 CEST schrieb Diederik de Haas:
> On Friday, 21 June 2024 03:25:30 CEST Daniel Golle wrote:
> > diff --git a/arch/arm64/boot/dts/rockchip/rk356x.dtsi
> > b/arch/arm64/boot/dts/rockchip/rk356x.dtsi index d8543b5557ee..57c8103500ea
> > 100644
> > --- a/arch/arm64/boot/dts/rockchip/rk356x.dtsi
> > +++ b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
> > @@ -1855,6 +1855,15 @@ usb2phy1_otg: otg-port {
> >                 };
> >         };
> > 
> > +       rng: rng@fe388000 {
> > +               compatible = "rockchip,rk3568-rng";
> > +               reg = <0x0 0xfe388000 0x0 0x4000>;
> > +               clocks = <&cru CLK_TRNG_NS>, <&cru HCLK_TRNG_NS>;
> > +               clock-names = "core", "ahb";
> > +               resets = <&cru SRST_TRNG_NS>;
> > +               reset-names = "reset";
> > +       };
> > +
> >         pinctrl: pinctrl {
> >                 compatible = "rockchip,rk3568-pinctrl";
> >                 rockchip,grf = <&grf>;
> > --
> 
> I had placed the node between ``sdhci: mmc@fe310000`` and
> ``i2s0_8ch: i2s@fe400000`` which I think is the proper order.

correct.
If a node has an address in its name, sort by that address.


