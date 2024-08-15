Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B15237703;
	Thu, 15 Aug 2024 16:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.11.138.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723739208; cv=none; b=bZB2XGqRsum7+mYcuK/MRojQOOVEEnZabcFFzKRBCEqzrAIuqorZe5yU6NPIfPzSiPhVzSYincfFFniVfJAaU/cXLasFruNs/yOnZ7d61dg6SBI9Tk/GWMZyeC6Qp0yNEmPahFrtfm7vW0SLJGnlnv+cjkgkXInY4R21tYmesw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723739208; c=relaxed/simple;
	bh=bXnopG4k/qbH24Ksi0KyjUHrWN4q58jbmgAwY65EsfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QGgEmBEeQb1tLXSV1Dl1u9Axx3VBgjJM/Jn43OPu2meowMQ1YVS6PDYcFd8CMRBVM1up0JTwAPKPEAXWTxGd5xswucXBReiSyR5aSqC9fpWNemWh6zifIMgx+Qn/4KiRGpFRW4eyPwmp/MwJGvnldjcQB+xjAdDN/Q4ILmLgJaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sntech.de; spf=pass smtp.mailfrom=sntech.de; dkim=pass (2048-bit key) header.d=sntech.de header.i=@sntech.de header.b=CelTMwnS; arc=none smtp.client-ip=185.11.138.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sntech.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sntech.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sntech.de header.i=@sntech.de header.b="CelTMwnS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sntech.de;
	s=gloria202408; h=Content-Type:Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=UCm31tTxU+jGw6jFfVSUx/29jMoVpph6qM7iV+DkIU0=; b=CelTMwnSz8i//OS31LMsADnPBp
	EmtDaANKkHlkzO1+W2uHpBcCE34SLLgsGJ29fRYGJVdVJCFEBGtf4ctCxbCC2ihHKJJrYt+GUEM8K
	dFIOS/3bv/kGuz0l6827BuNfqY2oRgBmUdDfbP+PU4JoNyBSeyokUHFiEsKDrBRblSJ8k9xgLfaoP
	/0cznBwYqh+4MGvRcRhhR8TSIdJ86M0ios7QZsoYBi/fsIwbzEzDLkNafO99FIG8yZA1KEsq5xzcs
	vUnsdDutQMVzyHGFo351QjfrMY9CJ65qyQoE6QLFpHRjWOFX0dC80p6t5mrVgW1ogprFO602Yv0wC
	fkKgSZEg==;
Received: from i53875a9f.versanet.de ([83.135.90.159] helo=diego.localnet)
	by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <heiko@sntech.de>)
	id 1sedIk-0005Ic-4x; Thu, 15 Aug 2024 18:26:14 +0200
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Daniel Golle <daniel@makrotopia.org>, Rob Herring <robh@kernel.org>
Cc: Aurelien Jarno <aurelien@aurel32.net>,
 Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>,
 Philipp Zabel <p.zabel@pengutronix.de>, Dragan Simic <dsimic@manjaro.org>,
 Uwe =?ISO-8859-1?Q?Kleine=2DK=F6nig?= <ukleinek@debian.org>,
 Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
 Sascha Hauer <s.hauer@pengutronix.de>,
 Francesco Dolcini <francesco.dolcini@toradex.com>,
 Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject:
 Re: [PATCH v9 3/3] arm64: dts: rockchip: add DT entry for RNG to RK356x
Date: Thu, 15 Aug 2024 18:26:12 +0200
Message-ID: <861871884.pAmPZ1aGmH@diego>
In-Reply-To:
 <CAL_JsqKG+dMJjPXrWiQ8qZ7yfpdX3R22ntKRBawYZWTaW_9GWA@mail.gmail.com>
References:
 <cover.1722355365.git.daniel@makrotopia.org>
 <d2beb15377dc8b580ca5557b1a4a6f50b74055aa.1722355365.git.daniel@makrotopia.org>
 <CAL_JsqKG+dMJjPXrWiQ8qZ7yfpdX3R22ntKRBawYZWTaW_9GWA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

Am Dienstag, 13. August 2024, 16:17:05 CEST schrieb Rob Herring:
> On Tue, Jul 30, 2024 at 10:11=E2=80=AFAM Daniel Golle <daniel@makrotopia.=
org> wrote:
> >
> > From: Aurelien Jarno <aurelien@aurel32.net>
> >
> > Include the just added Rockchip RNG driver for RK356x SoCs and
> > enable it on RK3568.
> >
> > Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
> > Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> > ---
> >  arch/arm64/boot/dts/rockchip/rk3568.dtsi |  4 ++++
> >  arch/arm64/boot/dts/rockchip/rk356x.dtsi | 10 ++++++++++
> >  2 files changed, 14 insertions(+)
> >
> > diff --git a/arch/arm64/boot/dts/rockchip/rk3568.dtsi b/arch/arm64/boot=
/dts/rockchip/rk3568.dtsi
> > index f1be76a54ceb0..2a6ca20e607fd 100644
> > --- a/arch/arm64/boot/dts/rockchip/rk3568.dtsi
> > +++ b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
> > @@ -257,6 +257,10 @@ power-domain@RK3568_PD_PIPE {
> >         };
> >  };
> >
> > +&rng {
> > +       status =3D "okay";
> > +};
> > +
> >  &usb_host0_xhci {
> >         phys =3D <&usb2phy0_otg>, <&combphy0 PHY_TYPE_USB3>;
> >         phy-names =3D "usb2-phy", "usb3-phy";
> > diff --git a/arch/arm64/boot/dts/rockchip/rk356x.dtsi b/arch/arm64/boot=
/dts/rockchip/rk356x.dtsi
> > index 4690be841a1cd..d160a23fd4959 100644
> > --- a/arch/arm64/boot/dts/rockchip/rk356x.dtsi
> > +++ b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
> > @@ -1113,6 +1113,16 @@ sdhci: mmc@fe310000 {
> >                 status =3D "disabled";
> >         };
> >
> > +       rng: rng@fe388000 {
> > +               compatible =3D "rockchip,rk3568-rng";
> > +               reg =3D <0x0 0xfe388000 0x0 0x4000>;
> > +               clocks =3D <&cru CLK_TRNG_NS>, <&cru HCLK_TRNG_NS>;
> > +               clock-names =3D "core", "ahb";
> > +               resets =3D <&cru SRST_TRNG_NS>;
> > +               reset-names =3D "reset";
>=20
> This adds a new warning:
>=20
> rng@fe388000: 'reset-names' does not match any of the regexes: 'pinctrl-[=
0-9]+'

I've created and sent a patch to remove the reset-names now.



