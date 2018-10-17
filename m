Return-Path: <SRS0=Iqog=M5=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-oi1-f195.google.com ([209.85.167.195]:44974 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727000AbeJQU6J (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Oct 2018 16:58:09 -0400
MIME-Version: 1.0
References: <cover.1539779579.git.leonard.crestez@nxp.com> <95dce7010676581691b1ac9906e9298470e0aa1a.1539779579.git.leonard.crestez@nxp.com>
 <CAOMZO5BMeHjsyZWhUb5RmEBRCYViUN-Vx8KyLBWtDJGKBHHpCg@mail.gmail.com> <a97517bf72f649915bccf555ab7d3c8c4551298d.camel@nxp.com>
In-Reply-To: <a97517bf72f649915bccf555ab7d3c8c4551298d.camel@nxp.com>
From: Fabio Estevam <festevam@gmail.com>
Date: Wed, 17 Oct 2018 10:02:41 -0300
Message-ID: <CAOMZO5DCzM_NnqD4tHTAn4pAaUdQGo38Ami1h3pu9SzgyQ7GnQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] crypto: mxs-dcp - Add support for dcp clk
To: Leonard Crestez <leonard.crestez@nxp.com>
Cc: NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Franck LENORMAND <franck.lenormand@nxp.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE"
        <linux-arm-kernel@lists.infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Horia Geanta Neag <horia.geanta@nxp.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Marek Vasut <marek.vasut@gmail.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 17, 2018 at 9:59 AM Leonard Crestez <leonard.crestez@nxp.com> wrote:

> There is a changelog in the cover letter.

It did not show up:
https://lkml.org/lkml/2018/10/17/673

> This only looks slightly odd in git diff but it's not unrelated.
>
> I placed clk get/prepare/enable just before stmp_reset_block and made
> stmp_reset_block print a message and goto err_disable_unprepare_clk on
> failure instead of just "if (ret) return ret;"

Got it! Then it looks fine, thanks:

Reviewed-by: Fabio Estevam <festevam@gmail.com>
