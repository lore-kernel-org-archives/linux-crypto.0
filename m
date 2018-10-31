Return-Path: <SRS0=nKf/=NL=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-eopbgr70049.outbound.protection.outlook.com ([40.107.7.49]:53248
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727980AbeJaToa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Oct 2018 15:44:30 -0400
From: Leonard Crestez <leonard.crestez@nxp.com>
To: Fabio Estevam <festevam@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC: dl-linux-imx <linux-imx@nxp.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE"
        <linux-arm-kernel@lists.infradead.org>,
        Horia Geanta <horia.geanta@nxp.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Marek Vasut <marek.vasut@gmail.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v4 2/4] crypto: mxs-dcp - Add support for dcp clk
Date: Wed, 31 Oct 2018 10:46:52 +0000
Message-ID: <AM0PR04MB4290A361A92B782DC5A9F8BDEECD0@AM0PR04MB4290.eurprd04.prod.outlook.com>
References: <cover.1539779579.git.leonard.crestez@nxp.com>
 <95dce7010676581691b1ac9906e9298470e0aa1a.1539779579.git.leonard.crestez@nxp.com>
 <CAOMZO5BMeHjsyZWhUb5RmEBRCYViUN-Vx8KyLBWtDJGKBHHpCg@mail.gmail.com>
 <a97517bf72f649915bccf555ab7d3c8c4551298d.camel@nxp.com>
 <CAOMZO5DCzM_NnqD4tHTAn4pAaUdQGo38Ami1h3pu9SzgyQ7GnQ@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/17/2018 4:02 PM, Fabio Estevam wrote:=0A=
> On Wed, Oct 17, 2018 at 9:59 AM Leonard Crestez <leonard.crestez@nxp.com>=
 wrote:=0A=
> =0A=
>> There is a changelog in the cover letter.=0A=
> =0A=
> It did not show up:=0A=
> https://lkml.org/lkml/2018/10/17/673=0A=
=0A=
Sorry, I forgot to copy the changelog for v4. The only change is the one =
=0A=
we discussed earlier in this thread.=0A=
=0A=
>> This only looks slightly odd in git diff but it's not unrelated.=0A=
>>=0A=
>> I placed clk get/prepare/enable just before stmp_reset_block and made=0A=
>> stmp_reset_block print a message and goto err_disable_unprepare_clk on=
=0A=
>> failure instead of just "if (ret) return ret;"=0A=
> =0A=
> Got it! Then it looks fine, thanks:=0A=
> =0A=
> Reviewed-by: Fabio Estevam <festevam@gmail.com>=0A=
=0A=
Thanks for looking at this series.=0A=
=0A=
Shawn already applied patches 3/4, I guess parts 1/2 should go through =0A=
the crypto tree? I don't know how crypto treats patches in the merge =0A=
window, I can resend with all the ack/review tags after rc1 is out.=0A=
