From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH 3/3] ARM: mxs: dts: Enable DCP for MXS
Date: Mon, 30 Sep 2013 00:11:43 +0200
Message-ID: <201309300011.44070.marex@denx.de>
References: <1380194306-5243-1-git-send-email-marex@denx.de> <1380194306-5243-3-git-send-email-marex@denx.de> <21060.7210.127710.800708@ipc1.ka-ro>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Shawn Guo <shawn.guo@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-arm-kernel@lists.infradead.org
To: Lothar =?iso-8859-1?q?Wa=DFmann?= <LW@karo-electronics.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:59319 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab3I2WLz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 29 Sep 2013 18:11:55 -0400
In-Reply-To: <21060.7210.127710.800708@ipc1.ka-ro>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dear Lothar Wa=DFmann,

> Hi,
>=20
> Marek Vasut writes:
> > Enable the DCP by default on both i.MX23 and i.MX28.
> >=20
> > Signed-off-by: Marek Vasut <marex@denx.de>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: David S. Miller <davem@davemloft.net>
> > Cc: Fabio Estevam <fabio.estevam@freescale.com>
> > Cc: Shawn Guo <shawn.guo@linaro.org>
> > To: linux-crypto@vger.kernel.org
> > ---
> >=20
> >  arch/arm/boot/dts/imx23.dtsi | 4 +++-
> >  arch/arm/boot/dts/imx28.dtsi | 5 +++--
> >  2 files changed, 6 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/arch/arm/boot/dts/imx23.dtsi b/arch/arm/boot/dts/imx23=
=2Edtsi
> > index 87faa6e..0630a9a 100644
> > --- a/arch/arm/boot/dts/imx23.dtsi
> > +++ b/arch/arm/boot/dts/imx23.dtsi
> > @@ -337,8 +337,10 @@
> >=20
> >  			};
> >  		=09
> >  			dcp@80028000 {
> >=20
> > +				compatible =3D "fsl,mxs-dcp";
> >=20
> >  				reg =3D <0x80028000 0x2000>;
> >=20
> > -				status =3D "disabled";
> > +				interrupts =3D <53 54>;
> > +				status =3D "okay";
> >=20
> >  			};
>=20
> AFAICT the policy seems to be that nodes, that are always enabled
> don't get a 'status' property at all.

Is this documented somewhere ?

Best regards,
Marek Vasut
