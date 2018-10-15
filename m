From: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH v2 2/4] crypto: mxs-dcp - Add support for dcp clk
Date: Mon, 15 Oct 2018 11:02:39 -0300
Message-ID: <CAOMZO5DcBbr7THgCCGtsymYVj_fPFQ9WH7XO5bbQHZLtjOL3Ag@mail.gmail.com>
References: <cover.1539609921.git.leonard.crestez@nxp.com> <fda62f939da082d640a27e506e7a3defac4f123f.1539609921.git.leonard.crestez@nxp.com>
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
In-Reply-To: <fda62f939da082d640a27e506e7a3defac4f123f.1539609921.git.leonard.crestez@nxp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Oct 15, 2018 at 10:28 AM Leonard Crestez
<leonard.crestez@nxp.com> wrote:

> +       /* DCP clock is optional, only used on some SOCs */
> +       sdcp->dcp_clk = devm_clk_get(dev, "dcp");
> +       if (IS_ERR(sdcp->dcp_clk)) {
> +               if (sdcp->dcp_clk != ERR_PTR(-ENOENT))
> +                       return PTR_ERR(sdcp->dcp_clk);
> +               sdcp->dcp_clk = NULL;
> +       }
> +
> +       ret = clk_prepare(sdcp->dcp_clk);
> +       if (ret)
> +               return ret;
> +       ret = clk_enable(sdcp->dcp_clk);
> +       if (ret)
> +               return ret;

Couldn't you use clk_prepare_enable() instead?
