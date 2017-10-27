From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH 0/4] add CAAM DMA memcpy driver
Date: Fri, 27 Oct 2017 12:20:32 +0000
Message-ID: <VI1PR0402MB3342607E09BE48F80E074C14985A0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
References: <20171026100008.32169-1-radu.alexe@nxp.com>
 <VI1PR0402MB33422B48B506D7FF6A894AE0985A0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
 <8D3F6266AEB6384E807C6FFC6FE195E333C52210@BGSMSX107.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
To: "Koul, Vinod" <vinod.koul@intel.com>,
        Radu Andrei Alexe <radu.alexe@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Dan Douglass <dan.douglass@nxp.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ve1eur01on0084.outbound.protection.outlook.com ([104.47.1.84]:57696
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752190AbdJ0MUi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Oct 2017 08:20:38 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/27/2017 2:36 PM, Koul, Vinod wrote:=0A=
>> On 10/26/2017 1:01 PM, Radu Alexe wrote:=0A=
>>> This patch-set introduces a new DMA memcpy driver based on the DMA=0A=
>>> capabilities of the CAAM crypto engine. Because of this dependency the=
=0A=
>>> included commits target various parts of the kernel tree.=0A=
>> I don't see the patches on any of the mail lists.=0A=
>> If they are moderated, I would expect this to be mentioned in the=0A=
>> MAINTAINERS file.=0A=
>>=0A=
>>>=0A=
>>> Patch 1.=0A=
>>> Since the CAAM DMA driver is a platform driver it is enabled by a new n=
ode=0A=
>>> in the device tree. This commit adds documentation for the device tree=
=0A=
>>> bindings.=0A=
>>>=0A=
>>> Patch 2.=0A=
>>> This patch adds the "caam-dma" node in the fsl-ls1012a.dtsi file.=0A=
>>>=0A=
>>> Patch 3.=0A=
>>> This commit adds various capabilities in the JR driver of the CAAM that=
 is=0A=
>>> used by the CAAM DMA driver.=0A=
>>>=0A=
>>> Patch 4.=0A=
>>> Adds the CAAM DMA memcpy driver.=0A=
>>>=0A=
>>> Patch 1 and 3 should be merged by the crypto maintainers, patch 2 by=0A=
>>> devicetree maintainers and patch 4 by the DMA maintainers.=0A=
>> I would go with all the patches through the dmaengine tree.=0A=
> =0A=
> Good call, but no one CCed dmaengine folks on this series!=0A=
> =0A=
I see dmaengine@vger.kernel.org Cc-ed on both cover letter and all four=0A=
patches.=0A=
It might be that the sender (Radu) is not subscribed and messages are=0A=
awaiting moderators' approval.=0A=
=0A=
Horia=0A=
