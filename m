From: Fabio Estevam <festevam@gmail.com>
Subject: Re: [RESEND PATCH v2 0/5] Enable CAAM on i.MX7s fix TrustZone issues
Date: Fri, 26 Jan 2018 22:42:46 -0200
Message-ID: <CAOMZO5BdCyS-spEuD6rFxBhqCStH7uOcJ7XQT_xc-GP4ru4apg@mail.gmail.com>
References: <1516993501-29646-1-git-send-email-pure.logic@nexus-software.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Horia Geanta Neag <horia.geanta@nxp.com>, aymen.sghaier@nxp.com,
        linux-crypto@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Peng Fan <peng.fan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        lukas.auer@aisec.fraunhofer.de, rui.silva@linaro.org,
        Ryan Harkin <ryan.harkin@linaro.org>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ot0-f176.google.com ([74.125.82.176]:43373 "EHLO
        mail-ot0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751946AbeA0Amr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jan 2018 19:42:47 -0500
In-Reply-To: <1516993501-29646-1-git-send-email-pure.logic@nexus-software.ie>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Bryan,

On Fri, Jan 26, 2018 at 5:04 PM, Bryan O'Donoghue
<pure.logic@nexus-software.ie> wrote:

> Bryan O'Donoghue (1):
>   crypto: caam: Fix endless loop when RNG is already initialized
>
> Rui Miguel Silva (4):
>   crypto: caam: Fix null dereference at error path
>   crypto: caam: do not use mem and emi_slow clock for imx7x

Thanks for your series!

>   clk: imx7d: add CAAM clock

This one should be posted to the clock driver maintainers.

>   ARM: dts: imx7s: add CAAM device node

This one should be posted to the i.MX arch maintainers.
