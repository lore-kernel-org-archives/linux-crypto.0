From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH v3 5/5] ARM: dts: imx7s: add CAAM device node
Date: Thu, 1 Feb 2018 11:44:23 +0000
Message-ID: <VI1PR0402MB334269ACFE0805A2E31D604B98FA0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
References: <1517364040-27607-1-git-send-email-pure.logic@nexus-software.ie>
 <1517364040-27607-6-git-send-email-pure.logic@nexus-software.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: Fabio Estevam <fabio.estevam@nxp.com>, Peng Fan <peng.fan@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "lukas.auer@aisec.fraunhofer.de" <lukas.auer@aisec.fraunhofer.de>,
        "rui.silva@linaro.org" <rui.silva@linaro.org>,
        "ryan.harkin@linaro.org" <ryan.harkin@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>
To: Bryan O'Donoghue <pure.logic@nexus-software.ie>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db5eur01on0088.outbound.protection.outlook.com ([104.47.2.88]:61660
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752038AbeBALo2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Feb 2018 06:44:28 -0500
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 1/31/2018 4:00 AM, Bryan O'Donoghue wrote:=0A=
> From: Rui Miguel Silva <rui.silva@linaro.org>=0A=
> =0A=
> Add CAAM device node to the i.MX7s device tree.=0A=
> =0A=
> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>=0A=
> Cc: Shawn Guo <shawnguo@kernel.org>=0A=
> Cc: Sascha Hauer <kernel@pengutronix.de>=0A=
> Cc: linux-arm-kernel@lists.infradead.org=0A=
> Cc: "Horia Geant=E3" <horia.geanta@nxp.com>=0A=
> Cc: Aymen Sghaier <aymen.sghaier@nxp.com>=0A=
> Cc: Fabio Estevam <fabio.estevam@nxp.com>=0A=
> Cc: Peng Fan <peng.fan@nxp.com>=0A=
> Cc: "David S. Miller" <davem@davemloft.net>=0A=
> Cc: Lukas Auer <lukas.auer@aisec.fraunhofer.de>=0A=
> Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>=0A=
> ---=0A=
>  arch/arm/boot/dts/imx7s.dtsi | 31 +++++++++++++++++++++++++++++++=0A=
>  1 file changed, 31 insertions(+)=0A=
> =0A=
> diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi=
=0A=
> index 82ad26e..e38c159 100644=0A=
> --- a/arch/arm/boot/dts/imx7s.dtsi=0A=
> +++ b/arch/arm/boot/dts/imx7s.dtsi=0A=
> @@ -805,6 +805,37 @@=0A=
>  				status =3D "disabled";=0A=
>  			};=0A=
>  =0A=
> +			crypto: caam@30900000 {=0A=
> +				compatible =3D "fsl,sec-v4.0";=0A=
> +				fsl,sec-era =3D <4>;=0A=
CCBVID[CAAM_ERA] =3D 8.=0A=
Either remove this (optional) property and let the bootloader add it=0A=
dynamically, or provide a correct value for it.=0A=
=0A=
Thanks,=0A=
Horia=0A=
=0A=
