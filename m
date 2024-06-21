Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF82216E885;
	Fri, 21 Jun 2024 09:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718962612; cv=none; b=a19w2cbfDa+xu4AursrYpsWm3ijQtjDyjunCcFQUS2y4UWWfNrlJvvfVgMbi7bo+g8cvcHAd9PlKbU4vDE7i1aGOYKvuE7oE2DKPeuPyDkVFHw6Be3HerxZfFTFioeUd31dkGwOdFiWr/Su25TxKn4aUPcKExsMQR+NN8LIfbr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718962612; c=relaxed/simple;
	bh=ylbZICfxbniUhJiXjboEvGYMsTr7jOnhrJ7HtvySKxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FtPeS7depQo2oVXDlK+y6L/ccqMlRk3h2rqNREio6ugQl0MxjmSzQTfm4ueoxiTB89JehWJsMaJqkS+k3WhACfBMEizcC7EBXW49CJmrGs/zU34KVAW1cqNQzQ41hBKLuiqhZFFGpebgJQOvHJAuapaQTZB6lZ8jrqSOr151Qhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org; spf=pass smtp.mailfrom=cknow.org; dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b=UTGblEpV; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cknow.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b="UTGblEpV"
X-Envelope-To: daniel@makrotopia.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cknow.org; s=key1;
	t=1718962608;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7tocwp9lNfOnGFlQhgrKD+Lp7CcVz+tHpAKPZsWSJzg=;
	b=UTGblEpVdd3T+psQYU9COc2q3jV5L5PhuGGv2162hEoex83pduUNObt1D5UEm/fv7Jj39H
	cgAwnVpYY54HNcEc7qlPAM6jZ6Ullzwc6AQ4ltqbeeyOJYvuRSLFWsdXtPknfR8ZPQdtkq
	6g44YJSyOaDW8mAL+EdmTlOwzzog1LMdMLho/hYfSqHpwPj/I66Bxc6x/s0gnmNPdis+Y1
	VYBwo4Kpkw+msHIBUTxd9Dygl1SIgx1QZWIyWytFO73/7YptRo//l8XkyrvdPjZ1Yv1mP7
	KjrYoFl4Y1h8FJveU68MBYGwtSJ3GBQozEwb+NlcqOFR8Yrr8GsRJ8ItLGoWNg==
X-Envelope-To: aurelien@aurel32.net
X-Envelope-To: olivia@selenic.com
X-Envelope-To: herbert@gondor.apana.org.au
X-Envelope-To: robh@kernel.org
X-Envelope-To: krzk+dt@kernel.org
X-Envelope-To: conor+dt@kernel.org
X-Envelope-To: heiko@sntech.de
X-Envelope-To: p.zabel@pengutronix.de
X-Envelope-To: ukleinek@debian.org
X-Envelope-To: sebastian.reichel@collabora.com
X-Envelope-To: linux.amoon@gmail.com
X-Envelope-To: dsimic@manjaro.org
X-Envelope-To: s.hauer@pengutronix.de
X-Envelope-To: martin@kaiser.cx
X-Envelope-To: ardb@kernel.org
X-Envelope-To: linux-crypto@vger.kernel.org
X-Envelope-To: devicetree@vger.kernel.org
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: linux-rockchip@lists.infradead.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: daniel@makrotopia.org
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Diederik de Haas <didi.debian@cknow.org>
To: Daniel Golle <daniel@makrotopia.org>,
 Aurelien Jarno <aurelien@aurel32.net>, Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>,
 Heiko Stuebner <heiko@sntech.de>, Philipp Zabel <p.zabel@pengutronix.de>,
 Uwe =?ISO-8859-1?Q?Kleine=2DK=F6nig?= <ukleinek@debian.org>,
 Sebastian Reichel <sebastian.reichel@collabora.com>,
 Anand Moon <linux.amoon@gmail.com>, Dragan Simic <dsimic@manjaro.org>,
 Sascha Hauer <s.hauer@pengutronix.de>, Martin Kaiser <martin@kaiser.cx>,
 Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Daniel Golle <daniel@makrotopia.org>
Subject:
 Re: [PATCH v3 3/3] arm64: dts: rockchip: add DT entry for RNG to RK356x
Date: Fri, 21 Jun 2024 11:36:45 +0200
Message-ID: <5870442.3KgWVfgXFx@bagend>
Organization: Connecting Knowledge
In-Reply-To:
 <bd08c142ce6b32cd98014c875c7ccf3657c63f23.1718921174.git.daniel@makrotopia.org>
References:
 <cover.1718921174.git.daniel@makrotopia.org>
 <bd08c142ce6b32cd98014c875c7ccf3657c63f23.1718921174.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2326598.u92GhurISB";
 micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Migadu-Flow: FLOW_OUT

--nextPart2326598.u92GhurISB
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Diederik de Haas <didi.debian@cknow.org>
Cc: Daniel Golle <daniel@makrotopia.org>
Date: Fri, 21 Jun 2024 11:36:45 +0200
Message-ID: <5870442.3KgWVfgXFx@bagend>
Organization: Connecting Knowledge
MIME-Version: 1.0

On Friday, 21 June 2024 03:25:30 CEST Daniel Golle wrote:
> diff --git a/arch/arm64/boot/dts/rockchip/rk356x.dtsi
> b/arch/arm64/boot/dts/rockchip/rk356x.dtsi index d8543b5557ee..57c8103500ea
> 100644
> --- a/arch/arm64/boot/dts/rockchip/rk356x.dtsi
> +++ b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
> @@ -1855,6 +1855,15 @@ usb2phy1_otg: otg-port {
>                 };
>         };
> 
> +       rng: rng@fe388000 {
> +               compatible = "rockchip,rk3568-rng";
> +               reg = <0x0 0xfe388000 0x0 0x4000>;
> +               clocks = <&cru CLK_TRNG_NS>, <&cru HCLK_TRNG_NS>;
> +               clock-names = "core", "ahb";
> +               resets = <&cru SRST_TRNG_NS>;
> +               reset-names = "reset";
> +       };
> +
>         pinctrl: pinctrl {
>                 compatible = "rockchip,rk3568-pinctrl";
>                 rockchip,grf = <&grf>;
> --

I had placed the node between ``sdhci: mmc@fe310000`` and
``i2s0_8ch: i2s@fe400000`` which I think is the proper order.

Cheers,
  Diederik
--nextPart2326598.u92GhurISB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQT1sUPBYsyGmi4usy/XblvOeH7bbgUCZnVJrQAKCRDXblvOeH7b
biBSAQCMa4hNIGCHuiNhbaI8GKE6K+tGfAz4PV8PCWjZL2SX8gEAp/afD39PReUl
9q2MBI5TXF+g0+JU6oBWjxcSlvzXcAw=
=IJaH
-----END PGP SIGNATURE-----

--nextPart2326598.u92GhurISB--



