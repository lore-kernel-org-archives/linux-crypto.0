From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: Re: [PATCH 3/3] ARM: mxs: dts: Enable DCP for MXS
Date: Thu, 26 Sep 2013 13:36:10 +0200
Message-ID: <21060.7210.127710.800708@ipc1.ka-ro>
References: <1380194306-5243-1-git-send-email-marex@denx.de>
	<1380194306-5243-3-git-send-email-marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Shawn Guo <shawn.guo@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-arm-kernel@lists.infradead.org
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.karo-electronics.de ([81.173.242.67]:62309 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756554Ab3IZLgY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Sep 2013 07:36:24 -0400
In-Reply-To: <1380194306-5243-3-git-send-email-marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Marek Vasut writes:
> Enable the DCP by default on both i.MX23 and i.MX28.
>=20
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Fabio Estevam <fabio.estevam@freescale.com>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> To: linux-crypto@vger.kernel.org
> ---
>  arch/arm/boot/dts/imx23.dtsi | 4 +++-
>  arch/arm/boot/dts/imx28.dtsi | 5 +++--
>  2 files changed, 6 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/arm/boot/dts/imx23.dtsi b/arch/arm/boot/dts/imx23.d=
tsi
> index 87faa6e..0630a9a 100644
> --- a/arch/arm/boot/dts/imx23.dtsi
> +++ b/arch/arm/boot/dts/imx23.dtsi
> @@ -337,8 +337,10 @@
>  			};
> =20
>  			dcp@80028000 {
> +				compatible =3D "fsl,mxs-dcp";
>  				reg =3D <0x80028000 0x2000>;
> -				status =3D "disabled";
> +				interrupts =3D <53 54>;
> +				status =3D "okay";
>  			};
AFAICT the policy seems to be that nodes, that are always enabled
don't get a 'status' property at all.

>  			pxp@8002a000 {
> diff --git a/arch/arm/boot/dts/imx28.dtsi b/arch/arm/boot/dts/imx28.d=
tsi
> index 918d419..8b5ad60 100644
> --- a/arch/arm/boot/dts/imx28.dtsi
> +++ b/arch/arm/boot/dts/imx28.dtsi
> @@ -782,9 +782,10 @@
>  			};
> =20
>  			dcp: dcp@80028000 {
> +				compatible =3D "fsl,mxs-dcp";
>  				reg =3D <0x80028000 0x2000>;
> -				interrupts =3D <52 53 54>;
> -				compatible =3D "fsl-dcp";
>
What about drivers/crypto/dcp.c that is currently using this property?


Lothar Wa=C3=9Fmann
--=20
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstra=C3=9Fe 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Gesch=C3=A4ftsf=C3=BChrer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
