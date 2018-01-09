From: Anson Huang <anson.huang@nxp.com>
Subject: RE: [PATCH V3 1/2] clk: imx: imx7d: add the snvs clock
Date: Tue, 9 Jan 2018 10:10:09 +0000
Message-ID: <AM3PR04MB1315A6E9A645EC6256914285F5100@AM3PR04MB1315.eurprd04.prod.outlook.com>
References: <1515489651-13488-1-git-send-email-Anson.Huang@nxp.com>
 <20180109094348.GG26312@b29396-OptiPlex-7040>
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
In-Reply-To: <20180109094348.GG26312@b29396-OptiPlex-7040>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



Best Regards!
Anson Huang


> -----Original Message-----
> From: Dong Aisheng [mailto:dongas86@gmail.com]
> Sent: 2018-01-09 5:44 PM
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
> Subject: Re: [PATCH V3 1/2] clk: imx: imx7d: add the snvs clock
>=20
> On Tue, Jan 09, 2018 at 05:20:50PM +0800, Anson Huang wrote:
> > According to the i.MX7D Reference Manual, SNVS block has a clock gate,
> > accessing SNVS block would need this clock gate to be enabled, add it
> > into clock tree so that SNVS module driver can operate this clock
> > gate.
> >
> > Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
>=20
> You missed the last round review tags.
>=20
> Regards
> Dong Aisheng


Thanks for reminder, already sent out a V4 patch set to add tags.

Anson.
