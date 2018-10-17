Return-Path: <SRS0=Iqog=M5=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-oi1-f194.google.com ([209.85.167.194]:40279 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727142AbeJQUnq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Oct 2018 16:43:46 -0400
MIME-Version: 1.0
References: <cover.1539779579.git.leonard.crestez@nxp.com> <95dce7010676581691b1ac9906e9298470e0aa1a.1539779579.git.leonard.crestez@nxp.com>
In-Reply-To: <95dce7010676581691b1ac9906e9298470e0aa1a.1539779579.git.leonard.crestez@nxp.com>
From: Fabio Estevam <festevam@gmail.com>
Date: Wed, 17 Oct 2018 09:48:21 -0300
Message-ID: <CAOMZO5BMeHjsyZWhUb5RmEBRCYViUN-Vx8KyLBWtDJGKBHHpCg@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] crypto: mxs-dcp - Add support for dcp clk
To: Leonard Crestez <leonard.crestez@nxp.com>
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
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Leonard,

On Wed, Oct 17, 2018 at 9:38 AM Leonard Crestez <leonard.crestez@nxp.com> wrote:
>
> On 6ull and 6sll the DCP block has a clock which needs to be explicitly
> enabled.
>
> Add minimal handling for this at probe/remove time.
>
> Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
> ---

Please always explain what changed from the previous patch version.

> +       /* Restart the DCP block. */
> +       ret = stmp_reset_block(sdcp->base);
> +       if (ret) {
> +               dev_err(dev, "Failed reset\n");
> +               goto err_disable_unprepare_clk;
> +       }

This seems like an unrelated change that should be in a separate patch.

Also, this was not present in v3, so it is better to explain that this
has been introduced in v4.
