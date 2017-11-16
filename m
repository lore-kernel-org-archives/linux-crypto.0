From: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH RESEND 1/4] crypto: caam: add caam-dma node to SEC4.0
 device tree binding
Date: Thu, 16 Nov 2017 11:48:38 +0530
Message-ID: <20171116061838.GQ3187@localhost>
References: <20171030134654.13729-1-horia.geanta@nxp.com>
 <20171030134654.13729-2-horia.geanta@nxp.com>
 <20171030092424.1279add003c96ced4233bd2d@arm.com>
 <VI1PR04MB1325BAD68A7CC8C7A302D9A48A570@VI1PR04MB1325.eurprd04.prod.outlook.com>
 <20171109103437.834f8ddb5c62e5253002b2d0@arm.com>
 <VI1PR04MB13253DB5164A151D8E4AB8308A540@VI1PR04MB1325.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Kim Phillips <kim.phillips@arm.com>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Douglass <dan.douglass@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
To: Radu Andrei Alexe <radu.alexe@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:31077 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758521AbdKPGPT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Nov 2017 01:15:19 -0500
Content-Disposition: inline
In-Reply-To: <VI1PR04MB13253DB5164A151D8E4AB8308A540@VI1PR04MB1325.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 10, 2017 at 08:02:01AM +0000, Radu Andrei Alexe wrote:
> On 11/9/2017 6:34 PM, Kim Phillips wrote:
> > On Thu, 9 Nov 2017 11:54:13 +0000
> > Radu Andrei Alexe <radu.alexe@nxp.com> wrote:
> > 
> >> On 10/30/2017 4:24 PM, Kim Phillips wrote:
> >>> On Mon, 30 Oct 2017 15:46:51 +0200
> >>> Horia Geantă <horia.geanta@nxp.com> wrote:
> >>>
> >>>> +=====================================================================
> >>>> +CAAM DMA Node
> >>>> +
> >>>> +    Child node of the crypto node that enables the use of the DMA capabilities
> >>>> +    of the CAAM by a stand-alone driver. The only required property is the
> >>>> +    "compatible" property. All the other properties are determined from
> >>>> +    the job rings on which the CAAM DMA driver depends (ex: the number of
> >>>> +    dma-channels is equal to the number of defined job rings).
> >>>> +
> >>>> +  - compatible
> >>>> +      Usage: required
> >>>> +      Value type: <string>
> >>>> +      Definition: Must include "fsl,sec-v4.0-dma"
> >>>> +
> >>>> +EXAMPLE
> >>>> +  caam-dma {
> >>>> +    compatible = "fsl,sec-v5.4-dma",
> >>>> +                 "fsl,sec-v5.0-dma",
> >>>> +                 "fsl,sec-v4.0-dma";
> >>>> +  }
> >>>
> >>> If this isn't describing an aspect of the hardware, then what is it
> >>> doing in the device tree?
> >>>
> >>> Kim
> >>>
> >>
> >> Because the caam_dma driver is a platform driver I needed to create a
> >> platform device to activate the driver. My thought was that it was
> >> simpler to implement it using device tree.
> >> The next patch version will create the platform device dynamically at
> >> run time.
> > 
> > Why create a new device when that h/w already has one?
> > 
> > Why doesn't the existing crypto driver register dma capabilities with
> > the dma driver subsystem?
> > 
> > Kim
> > 
> 
> 
> I can think of two reasons:
> 
> 1. The code that this driver introduces has nothing to do with crypto 
> and everything to do with dma. Placing the code in the same directory as 
> the caam subsystem would only create confusion for the reader of an 
> already complex driver.
> 
> 2. I wanted this driver to be tracked by the dma engine team. They have 
> the right expertise to provide adequate feedback. If all the code was in 
> the crypto directory they wouldn't know about this driver or any 
> subsequent changes to it.

These are very good reasons.

We already have one DMA implementation drivers/crypto/ccp/ccp-dmaengine.c
which was sneaked past us and put into kernel with proper review!

On the other hand we have *bunch* of dmaengine users in crypto subsystem
which use dmaengine drivers and APIs and are good citizens. It allows folks
to share code with other usages of dmaengine and the usual arguments for
common code and frameworks...

If there are enough users we can add up a crypto-dmaengine lib which
programs dma controller for crypto users and avoid open coding for everyone.
for example sound-dmaengine layers does that...

HTH
-- 
~Vinod
