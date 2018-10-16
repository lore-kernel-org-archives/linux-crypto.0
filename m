Return-Path: <SRS0=anrJ=M4=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-ot1-f65.google.com ([209.85.210.65]:42052 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbeJPXzX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Oct 2018 19:55:23 -0400
MIME-Version: 1.0
References: <cover.1539705285.git.leonard.crestez@nxp.com> <ef03e230d0bb76d830c123bc47e6bd6e7bf17826.1539705286.git.leonard.crestez@nxp.com>
In-Reply-To: <ef03e230d0bb76d830c123bc47e6bd6e7bf17826.1539705286.git.leonard.crestez@nxp.com>
From: Fabio Estevam <festevam@gmail.com>
Date: Tue, 16 Oct 2018 13:04:24 -0300
Message-ID: <CAOMZO5A+Uc5in-PXnfe+XoFMtRmCxGOryXE9=mjB+aRHo+ZBEQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] ARM: dts: imx6ull: Add dcp node
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

On Tue, Oct 16, 2018 at 12:59 PM Leonard Crestez
<leonard.crestez@nxp.com> wrote:
>
> The DCP block on 6ull has no major differences other than requiring
> explicit clock enabling.
>
> Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>

Reviewed-by: Fabio Estevam <festevam@gmail.com>
