From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 05/10] ARM: dts: omap3 hs: Remove timer12
Date: Sat, 28 Feb 2015 17:54:23 +0100
Message-ID: <20150228165423.GJ4978@amd>
References: <1424958600-18881-1-git-send-email-pali.rohar@gmail.com>
 <1424958600-18881-6-git-send-email-pali.rohar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
	Tony Lindgren <tony@atomide.com>,
	Rob Herring <robh+dt@kernel.org>,
	Russell King <linux@arm.linux.org.uk>,
	Paul Walmsley <paul@pwsan.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Nishanth Menon <nm@ti.com>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Sebastian Reichel <sre@kernel.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46978 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbbB1Qya (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 28 Feb 2015 11:54:30 -0500
Content-Disposition: inline
In-Reply-To: <1424958600-18881-6-git-send-email-pali.rohar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu 2015-02-26 14:49:55, Pali Roh=E1r wrote:
> Device timer12 is automatically disabled on all HS devices via DTS pr=
operty
> "ti,timer-secure" in file omap3.dtsi so it can be safely removed. We =
do not
> need to disable it on another place.

Dunno. Theoretically, Linux is not the only user of dts... so even if
linux handles ti,timer-secure as "don't use it", that may not be right
for bootloaders etc.

> diff --git a/arch/arm/boot/dts/omap34xx-hs.dtsi b/arch/arm/boot/dts/o=
map34xx-hs.dtsi
> index 1ff6264..d4be302 100644
> --- a/arch/arm/boot/dts/omap34xx-hs.dtsi
> +++ b/arch/arm/boot/dts/omap34xx-hs.dtsi
> @@ -10,7 +10,3 @@
>  &sham {
>  	status =3D "disabled";
>  };
> -
> -&timer12 {
> -	status =3D "disabled";
> -};
> diff --git a/arch/arm/boot/dts/omap36xx-hs.dtsi b/arch/arm/boot/dts/o=
map36xx-hs.dtsi
> index 2c7febb..e93ff8d 100644
> --- a/arch/arm/boot/dts/omap36xx-hs.dtsi
> +++ b/arch/arm/boot/dts/omap36xx-hs.dtsi
> @@ -10,7 +10,3 @@
>  &sham {
>  	status =3D "disabled";
>  };
> -
> -&timer12 {
> -	status =3D "disabled";
> -};

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses=
/blog.html
