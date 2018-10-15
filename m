From: "A.s. Dong" <aisheng.dong@nxp.com>
Subject: RE: [PATCH v2 0/4] Port mxs-dcp to imx6ull and imx6sll
Date: Mon, 15 Oct 2018 16:11:54 +0000
Message-ID: <AM0PR04MB42113CBC474C64ADE3B3D01780FD0@AM0PR04MB4211.eurprd04.prod.outlook.com>
References: <cover.1539609921.git.leonard.crestez@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Rob Herring <robh+dt@kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S . Miller " <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Leonard Crestez <leonard.crestez@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1539609921.git.leonard.crestez@nxp.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Leonard,

> -----Original Message-----
> From: Leonard Crestez
> Sent: Monday, October 15, 2018 9:28 PM


[...]

> Subject: [PATCH v2 0/4] Port mxs-dcp to imx6ull and imx6sll
>=20
> The DCP block is present on 6sll and 6ull but not enabled. The hardware i=
s
> mostly compatible with 6sl, the only important difference is that explici=
t clock
> enabling is required.
>=20
> There were several issues with the functionality of this driver (it didn'=
t even
> probe properly) but they are fixed in cryptodev/master by this series:
>     https://lore.kernel.org/patchwork/cover/994874/
>=20

Thanks for the work.
I will be glad to help the test if you provide some test guides. :-)

Regards
Dong Aisheng

> ---
> Changes since v1:
>  * Add devicetree maintainers for dt-bindings
>  * Add a patch enabling in imx_v6_v7_defconfig. Since tcrypt now passes t=
his
> shouldn't cause any issues
>  * Link to v1: https://lore.kernel.org/patchwork/cover/994893/
>=20
> Leonard Crestez (4):
>   dt-bindings: crypto: Mention clocks for mxs-dcp
>   crypto: mxs-dcp - Add support for dcp clk
>   ARM: dts: imx6ull: Add dcp node
>   ARM: imx_v6_v7_defconfig: Enable CRYPTO_DEV_MXS_DCP
>=20
>  .../devicetree/bindings/crypto/fsl-dcp.txt     |  2 ++
>  arch/arm/boot/dts/imx6ull.dtsi                 | 10 ++++++++++
>  arch/arm/configs/imx_v6_v7_defconfig           |  1 +
>  drivers/crypto/mxs-dcp.c                       | 18
> ++++++++++++++++++
>  4 files changed, 31 insertions(+)
>=20
> --
> 2.17.1
