From: Anson Huang <anson.huang@nxp.com>
Subject: RE: [PATCH V3 2/2] ARM: dts: imx7s: add snvs rtc clock
Date: Tue, 9 Jan 2018 10:03:18 +0000
Message-ID: <AM3PR04MB13150428BE76FF16EA9C15DDF5100@AM3PR04MB1315.eurprd04.prod.outlook.com>
References: <1515489651-13488-1-git-send-email-Anson.Huang@nxp.com>
 <1515489651-13488-2-git-send-email-Anson.Huang@nxp.com>
 <20180109094716.GH26312@b29396-OptiPlex-7040>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "mturquette@baylibre.com" <mturquette@baylibre.com>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        Adriana Reus <adriana.reus@nxp.com>,
        "stefan@agner.ch" <stefan@agner.ch>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
To: Dong Aisheng <dongas86@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180109094716.GH26312@b29396-OptiPlex-7040>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



Best Regards!
Anson Huang


> -----Original Message-----
> From: Dong Aisheng [mailto:dongas86@gmail.com]
> Sent: 2018-01-09 5:47 PM
> To: Anson Huang <anson.huang@nxp.com>
> Cc: Horia Geant=E3 <horia.geanta@nxp.com>; Aymen Sghaier
> <aymen.sghaier@nxp.com>; herbert@gondor.apana.org.au;
> davem@davemloft.net; robh+dt@kernel.org; mark.rutland@arm.com;
> shawnguo@kernel.org; kernel@pengutronix.de; Fabio Estevam
> <fabio.estevam@nxp.com>; linux@armlinux.org.uk;
> mturquette@baylibre.com; sboyd@codeaurora.org; Adriana Reus
> <adriana.reus@nxp.com>; stefan@agner.ch; linux-crypto@vger.kernel.org;
> devicetree@vger.kernel.org; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; linux-clk@vger.kernel.org; dl-linux-imx <linu=
x-
> imx@nxp.com>
> Subject: Re: [PATCH V3 2/2] ARM: dts: imx7s: add snvs rtc clock
>=20
> On Tue, Jan 09, 2018 at 05:20:51PM +0800, Anson Huang wrote:
> > Add i.MX7 SNVS RTC clock.
> >
> > Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
> > ---
> > changes since v2:
> > 	improve the binding doc statement about clocks.
> >  Documentation/devicetree/bindings/crypto/fsl-sec4.txt | 15
> +++++++++++++++
> >  arch/arm/boot/dts/imx7s.dtsi                          |  2 ++
> >  2 files changed, 17 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
> > b/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
> > index 76aec8a..7329f29 100644
> > --- a/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
> > +++ b/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
> > @@ -415,12 +415,25 @@ Secure Non-Volatile Storage (SNVS) Low Power (LP)
> RTC Node
> >  	value type: <u32>
> >  	Definition: LP register offset. default it is 0x34.
> >
> > +   - clocks
> > +      Usage: required if SNVS LP RTC requires explicit enablement of c=
locks
> > +      Value type: <prop_encoded-array>
> > +      Definition:  a clock specifier describing the clock required for
> > +          enabling and disabling SNVS LP RTC.
> > +
>=20
> This clock seem optional.
> Should we indicate it here explicitly?

Will add a optional in usage.


>=20
> BTW, i thought we probably could update poweroff and key as well at the s=
ame
> time since device tree changes can go separately.
> Does it make sense?

I think this patch set is only for RTC case since snvs-rtc driver already h=
andle the clock.
But for poweroff and powerkey, their drivers are NOT handling clocks curren=
tly, we
can add them when driver ready to handle clocks. Should be in another patch=
 set later.

Anson.

>=20
> Regards
> Dong Aisheng
>=20
> > +   - clock-names
> > +      Usage: required if SNVS LP RTC requires explicit enablement of c=
locks
> > +      Value type: <string>
> > +      Definition: clock name string should be "snvs-rtc".
> > +
> >  EXAMPLE
> >  	sec_mon_rtc_lp@1 {
> >  		compatible =3D "fsl,sec-v4.0-mon-rtc-lp";
> >  		interrupts =3D <93 2>;
> >  		regmap =3D <&snvs>;
> >  		offset =3D <0x34>;
> > +		clocks =3D <&clks IMX7D_SNVS_CLK>;
> > +		clock-names =3D "snvs-rtc";
> >  	};
> >
> >
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D=3D=3D=3D=3D=3D=3D=3D=3D
> > @@ -543,6 +556,8 @@ FULL EXAMPLE
> >  			regmap =3D <&sec_mon>;
> >  			offset =3D <0x34>;
> >  			interrupts =3D <93 2>;
> > +			clocks =3D <&clks IMX7D_SNVS_CLK>;
> > +			clock-names =3D "snvs-rtc";
> >  		};
> >
> >  		snvs-pwrkey@020cc000 {
> > diff --git a/arch/arm/boot/dts/imx7s.dtsi
> > b/arch/arm/boot/dts/imx7s.dtsi index 9aa2bb9..02baf42 100644
> > --- a/arch/arm/boot/dts/imx7s.dtsi
> > +++ b/arch/arm/boot/dts/imx7s.dtsi
> > @@ -551,6 +551,8 @@
> >  					offset =3D <0x34>;
> >  					interrupts =3D <GIC_SPI 19
> IRQ_TYPE_LEVEL_HIGH>,
> >  						     <GIC_SPI 20
> IRQ_TYPE_LEVEL_HIGH>;
> > +					clocks =3D <&clks IMX7D_SNVS_CLK>;
> > +					clock-names =3D "snvs-rtc";
> >  				};
> >
> >  				snvs_poweroff: snvs-poweroff {
> > --
> > 1.9.1
> >
