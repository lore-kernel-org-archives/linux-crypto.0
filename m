From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 07/10] ARM: dts: n9/n950: Enable omap crypto support
Date: Sat, 28 Feb 2015 17:41:48 +0100
Message-ID: <20150228164148.GE4978@amd>
References: <1424958600-18881-1-git-send-email-pali.rohar@gmail.com>
 <1424958600-18881-8-git-send-email-pali.rohar@gmail.com>
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
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46449 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbbB1Qlx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 28 Feb 2015 11:41:53 -0500
Content-Disposition: inline
In-Reply-To: <1424958600-18881-8-git-send-email-pali.rohar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu 2015-02-26 14:49:57, Pali Roh=E1r wrote:
> Harmattan system on Nokia N9 and N950 devices uses omap crypto suppor=
t.
> Bootloader on those devices is known that it enables HW crypto suppor=
t.
> This patch just include omap36xx.dtsi directly, so aes and sham is en=
abled.
>=20
> Signed-off-by: Pali Roh=E1r <pali.rohar@gmail.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

> --- a/arch/arm/boot/dts/omap3-n950-n9.dtsi
> +++ b/arch/arm/boot/dts/omap3-n950-n9.dtsi
> @@ -8,7 +8,7 @@
>   * published by the Free Software Foundation.
>   */
> =20
> -#include "omap36xx-hs.dtsi"
> +#include "omap36xx.dtsi"
> =20
>  / {
>  	cpus {

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses=
/blog.html
