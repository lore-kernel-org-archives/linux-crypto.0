From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH RESEND 1/4] crypto: caam: add caam-dma node to SEC4.0
 device tree binding
Date: Mon, 13 Nov 2017 08:32:24 +0000
Message-ID: <VI1PR0402MB3342C1736F492A323096541C982B0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
References: <20171030134654.13729-1-horia.geanta@nxp.com>
 <20171030134654.13729-2-horia.geanta@nxp.com>
 <20171030092424.1279add003c96ced4233bd2d@arm.com>
 <VI1PR04MB1325BAD68A7CC8C7A302D9A48A570@VI1PR04MB1325.eurprd04.prod.outlook.com>
 <20171109103437.834f8ddb5c62e5253002b2d0@arm.com>
 <VI1PR04MB13253DB5164A151D8E4AB8308A540@VI1PR04MB1325.eurprd04.prod.outlook.com>
 <20171110104430.28b2f56f910b7514d778c4b2@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: Vinod Koul <vinod.koul@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Dan Douglass" <dan.douglass@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
To: Kim Phillips <kim.phillips@arm.com>,
        Radu Andrei Alexe <radu.alexe@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-eopbgr00072.outbound.protection.outlook.com ([40.107.0.72]:10684
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751905AbdKMIc3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Nov 2017 03:32:29 -0500
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 11/10/2017 6:44 PM, Kim Phillips wrote:=0A=
> On Fri, 10 Nov 2017 08:02:01 +0000=0A=
> Radu Andrei Alexe <radu.alexe@nxp.com> wrote:=0A=
[snip]>> 2. I wanted this driver to be tracked by the dma engine team.=0A=
They have=0A=
>> the right expertise to provide adequate feedback. If all the code was in=
 =0A=
>> the crypto directory they wouldn't know about this driver or any =0A=
>> subsequent changes to it.=0A=
> =0A=
> dma subsystem bits could still be put in the dma area if deemed=0A=
> necessary but I don't think it is: I see=0A=
> drivers/crypto/ccp/ccp-dmaengine.c calls dma_async_device_register for=0A=
> example.=0A=
> =0A=
Please see previous discussion with Vinod:=0A=
https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg21468.html=0A=
=0A=
> What is the rationale for using the crypto h/w as a dma engine anyway?=0A=
SoCs that don't have a system DMA, for e.g. LS1012A.=0A=
=0A=
Horia=0A=
