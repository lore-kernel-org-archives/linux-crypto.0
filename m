From: Victoria Milhoan <vicki.milhoan@freescale.com>
Subject: Re: [PATCH v2 11/14] ARM: dts: mx6sx: Add CAAM device node
Date: Thu, 6 Aug 2015 11:37:35 -0700
Message-ID: <20150806113735.c20c3abf2d662652c7485389@freescale.com>
References: <1438228709-27650-1-git-send-email-vicki.milhoan@freescale.com>
	<1438799328-10757-1-git-send-email-vicki.milhoan@freescale.com>
	<1438799328-10757-12-git-send-email-vicki.milhoan@freescale.com>
	<55C321F6.1040801@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
	<ruchika.gupta@freescale.com>, <shawnguo@kernel.org>,
	<kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
	<robh+dt@kernel.org>
To: Horia =?UTF-8?B?R2VhbnTEgw==?= <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0117.outbound.protection.outlook.com ([65.55.169.117]:37088
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755623AbbHFShr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Aug 2015 14:37:47 -0400
In-Reply-To: <55C321F6.1040801@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 6 Aug 2015 11:59:34 +0300
Horia Geant=C4=83 <horia.geanta@freescale.com> wrote:

> On 8/5/2015 9:28 PM, Victoria Milhoan wrote:
> > Add CAAM device node to the i.MX6SX device tree.
> >=20
> > Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
> > ---
> >  arch/arm/boot/dts/imx6sx.dtsi | 28 ++++++++++++++++++++++++++++
> >  1 file changed, 28 insertions(+)
> >=20
> > diff --git a/arch/arm/boot/dts/imx6sx.dtsi b/arch/arm/boot/dts/imx6=
sx.dtsi
> > index 708175d..20851cb 100644
> > --- a/arch/arm/boot/dts/imx6sx.dtsi
> > +++ b/arch/arm/boot/dts/imx6sx.dtsi
> > @@ -738,6 +738,34 @@
> >  			reg =3D <0x02100000 0x100000>;
> >  			ranges;
> > =20
> > +			crypto: caam@2100000 {
> > +				compatible =3D "fsl,sec-v4.0";
> > +				fsl,sec-era =3D <4>;
> > +				#address-cells =3D <1>;
> > +				#size-cells =3D <1>;
> > +				reg =3D <0x2100000 0x10000>;
> > +				ranges =3D <0 0x2100000 0x10000>;
> > +				interrupt-parent =3D <&intc>;
> > +				clocks =3D <&clks IMX6SX_CLK_CAAM_MEM>,
> > +					 <&clks IMX6SX_CLK_CAAM_ACLK>,
> > +					 <&clks IMX6SX_CLK_CAAM_IPG>,
> > +					 <&clks IMX6SX_CLK_EIM_SLOW>;
> > +				clock-names =3D "mem", "aclk", "ipg", "emi_slow";
> > +
> > +				sec_jr0: jr0@1000 {
> > +					compatible =3D "fsl,sec-v4.0-job-ring";
> > +					reg =3D <0x1000 0x1000>;
> > +					interrupts =3D <GIC_SPI 105 IRQ_TYPE_LEVEL_HIGH>;
> > +				};
> > +
> > +				sec_jr1: jr1@2000 {
> > +					compatible =3D "fsl,sec-v4.0-job-ring";
> > +					reg =3D <0x2000 0x1000>;
> > +					interrupts =3D <0 106 0x4>;
> > +					interrupts =3D <GIC_SPI 106 IRQ_TYPE_LEVEL_HIGH>;
>=20
> Typo - duplicate property. Remove the first one.

I will send out a replacement patch shortly.

>=20
> Horia
>=20
>=20


--=20
Victoria Milhoan <vicki.milhoan@freescale.com>
