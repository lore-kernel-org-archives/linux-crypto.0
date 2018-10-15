From: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH v2 3/4] ARM: dts: imx6ull: Add dcp node
Date: Mon, 15 Oct 2018 11:03:33 -0300
Message-ID: <CAOMZO5AMwGakygMT=O9CjN8jyL-FAox3-452C1vpGc9sPCXBHw@mail.gmail.com>
References: <cover.1539609921.git.leonard.crestez@nxp.com> <9365e24504896e58294fd8786acb3c3d4a1a264d.1539609921.git.leonard.crestez@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta Neag <horia.geanta@nxp.com>,
        Franck LENORMAND <franck.lenormand@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE"
        <linux-arm-kernel@lists.infradead.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-kernel <l
To: Leonard Crestez <leonard.crestez@nxp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9365e24504896e58294fd8786acb3c3d4a1a264d.1539609921.git.leonard.crestez@nxp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Oct 15, 2018 at 10:28 AM Leonard Crestez
<leonard.crestez@nxp.com> wrote:

> diff --git a/arch/arm/boot/dts/imx6ull.dtsi b/arch/arm/boot/dts/imx6ull.dtsi
> index 796ed35d4ac9..be610339e933 100644
> --- a/arch/arm/boot/dts/imx6ull.dtsi
> +++ b/arch/arm/boot/dts/imx6ull.dtsi
> @@ -37,10 +37,20 @@
>                         #address-cells = <1>;
>                         #size-cells = <1>;
>                         reg = <0x02200000 0x100000>;
>                         ranges;
>
> +                       dcp: dcp@2280000 {

Node names should be generic, so it would be better to use:

dcp: crypto@2280000 {
