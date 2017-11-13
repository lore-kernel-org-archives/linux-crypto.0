From: Radu Andrei Alexe <radu.alexe@nxp.com>
Subject: Re: [PATCH RESEND 1/4] crypto: caam: add caam-dma node to SEC4.0
 device tree binding
Date: Mon, 13 Nov 2017 09:44:06 +0000
Message-ID: <VI1PR04MB132502335EEB864169926F4E8A2B0@VI1PR04MB1325.eurprd04.prod.outlook.com>
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
Cc: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Douglass <dan.douglass@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
To: Kim Phillips <kim.phillips@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db5eur01on0052.outbound.protection.outlook.com ([104.47.2.52]:3398
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750972AbdKMJoM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Nov 2017 04:44:12 -0500
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 11/10/2017 6:44 PM, Kim Phillips wrote:=0A=
> On Fri, 10 Nov 2017 08:02:01 +0000=0A=
> Radu Andrei Alexe <radu.alexe@nxp.com> wrote:=0A=
> =0A=
>> On 11/9/2017 6:34 PM, Kim Phillips wrote:=0A=
>>> On Thu, 9 Nov 2017 11:54:13 +0000=0A=
>>> Radu Andrei Alexe <radu.alexe@nxp.com> wrote:=0A=
>>>> The next patch version will create the platform device dynamically at=
=0A=
>>>> run time.=0A=
>>>=0A=
>>> Why create a new device when that h/w already has one?=0A=
>>>=0A=
>>> Why doesn't the existing crypto driver register dma capabilities with=
=0A=
>>> the dma driver subsystem?=0A=
>>>=0A=
>> I can think of two reasons:=0A=
>>=0A=
>> 1. The code that this driver introduces has nothing to do with crypto=0A=
>> and everything to do with dma.=0A=
> =0A=
> I would think that at least a crypto "null" algorithm implementation=0A=
> would share code.=0A=
>=0A=
>> Placing the code in the same directory as=0A=
>> the caam subsystem would only create confusion for the reader of an=0A=
>> already complex driver.=0A=
> =0A=
> this different directory argument seems to be identical to your 2 below:=
=0A=
> =0A=
>> 2. I wanted this driver to be tracked by the dma engine team. They have=
=0A=
>> the right expertise to provide adequate feedback. If all the code was in=
=0A=
>> the crypto directory they wouldn't know about this driver or any=0A=
>> subsequent changes to it.=0A=
> =0A=
> dma subsystem bits could still be put in the dma area if deemed=0A=
> necessary but I don't think it is: I see=0A=
> drivers/crypto/ccp/ccp-dmaengine.c calls dma_async_device_register for=0A=
> example.=0A=
> =0A=
> I also don't see how that complicates things much further.=0A=
> =0A=
=0A=
So who made their review? The guys from crypto?=0A=
=0A=
If someone wants to enable only the DMA functionality of the CCP and not =
=0A=
the crypto part how do they do it? Look for it in the crypto submenu?=0A=
=0A=
> What is the rationale for using the crypto h/w as a dma engine anyway?=0A=
> Are there supporting performance figures?=0A=
=0A=
We have a platform that doesn't have a dedicated DMA controller but has =0A=
the CAAM hardware block that can perform dma transfers. We have a =0A=
use-case where we need to issue large transfers (hundred of MBs) =0A=
asynchronously, without using the core.=0A=
=0A=
> =0A=
> Kim=0A=
> =0A=
=0A=
=0A=
BR,=0A=
Radu=0A=
