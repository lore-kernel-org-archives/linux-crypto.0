From: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 07/10] ARM: dts: n9/n950: Enable omap crypto support
Date: Fri, 27 Feb 2015 07:43:20 -0800
Message-ID: <20150227154319.GT11056@atomide.com>
References: <1424958600-18881-1-git-send-email-pali.rohar@gmail.com>
 <1424958600-18881-8-git-send-email-pali.rohar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
	Rob Herring <robh+dt@kernel.org>,
	Russell King <linux@arm.linux.org.uk>,
	Paul Walmsley <paul@pwsan.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Pavel Machek <pavel@ucw.cz>, Nishanth Menon <nm@ti.com>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Sebastian Reichel <sre@kernel.org>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1424958600-18881-8-git-send-email-pali.rohar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Pali Roh=C3=A1r <pali.rohar@gmail.com> [150226 05:54]:
> Harmattan system on Nokia N9 and N950 devices uses omap crypto suppor=
t.
> Bootloader on those devices is known that it enables HW crypto suppor=
t.
> This patch just include omap36xx.dtsi directly, so aes and sham is en=
abled.

Let's also remove omap36xx-hs.dtsi with this patch if no other users.

Regards,

Tony
=20
> Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> ---
>  arch/arm/boot/dts/omap3-n950-n9.dtsi |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/arm/boot/dts/omap3-n950-n9.dtsi b/arch/arm/boot/dts=
/omap3-n950-n9.dtsi
> index c41db94..800b379 100644
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
> --=20
> 1.7.9.5
>=20
