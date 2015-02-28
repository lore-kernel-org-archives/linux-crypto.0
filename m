From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 09/10] ARM: dts: omap3-tao3530: Include directly
 omap34xx.dtsi
Date: Sat, 28 Feb 2015 17:44:51 +0100
Message-ID: <20150228164451.GG4978@amd>
References: <1424958600-18881-1-git-send-email-pali.rohar@gmail.com>
 <1424958600-18881-10-git-send-email-pali.rohar@gmail.com>
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
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46559 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbbB1Qo6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 28 Feb 2015 11:44:58 -0500
Content-Disposition: inline
In-Reply-To: <1424958600-18881-10-git-send-email-pali.rohar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu 2015-02-26 14:49:59, Pali Roh=E1r wrote:
> This patch just move content of file omap34xx-hs.dtsi into omap3-tao3=
530.dts.
> There is no code change, patch is just preparation for removing -hs f=
ile.
>=20
> Signed-off-by: Pali Roh=E1r <pali.rohar@gmail.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

> --- a/arch/arm/boot/dts/omap3-tao3530.dtsi
> +++ b/arch/arm/boot/dts/omap3-tao3530.dtsi
> @@ -8,7 +8,16 @@
>   */
>  /dts-v1/;
> =20
> -#include "omap34xx-hs.dtsi"
> +#include "omap34xx.dtsi"
> +
> +/* Secure omaps have some devices inaccessible depending on the firm=
ware */
> +&aes {
> +	status =3D "disabled";
> +};
> +
> +&sham {
> +	status =3D "disabled";
> +};
> =20
>  / {
>  	cpus {

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses=
/blog.html
