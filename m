From: Kim Phillips <kim.phillips@arm.com>
Subject: Re: [PATCH RESEND 1/4] crypto: caam: add caam-dma node to SEC4.0
 device tree binding
Date: Mon, 13 Nov 2017 09:22:12 -0600
Message-ID: <20171113092212.55d4033b46d622cfaefdc3f5@arm.com>
References: <20171030134654.13729-1-horia.geanta@nxp.com>
        <20171030134654.13729-2-horia.geanta@nxp.com>
        <20171030092424.1279add003c96ced4233bd2d@arm.com>
        <VI1PR04MB1325BAD68A7CC8C7A302D9A48A570@VI1PR04MB1325.eurprd04.prod.outlook.com>
        <20171109103437.834f8ddb5c62e5253002b2d0@arm.com>
        <VI1PR04MB13253DB5164A151D8E4AB8308A540@VI1PR04MB1325.eurprd04.prod.outlook.com>
        <20171110104430.28b2f56f910b7514d778c4b2@arm.com>
        <VI1PR04MB132502335EEB864169926F4E8A2B0@VI1PR04MB1325.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Horia =?UTF-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Douglass <dan.douglass@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
To: Radu Andrei Alexe <radu.alexe@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:47788 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752791AbdKMPWQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Nov 2017 10:22:16 -0500
In-Reply-To: <VI1PR04MB132502335EEB864169926F4E8A2B0@VI1PR04MB1325.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 13 Nov 2017 09:44:06 +0000
Radu Andrei Alexe <radu.alexe@nxp.com> wrote:

> On 11/10/2017 6:44 PM, Kim Phillips wrote:
> > On Fri, 10 Nov 2017 08:02:01 +0000
> > Radu Andrei Alexe <radu.alexe@nxp.com> wrote:
> > 
> >> On 11/9/2017 6:34 PM, Kim Phillips wrote:
> >>> On Thu, 9 Nov 2017 11:54:13 +0000
> >>> Radu Andrei Alexe <radu.alexe@nxp.com> wrote:
> >>>> The next patch version will create the platform device dynamically at
> >>>> run time.
> >>>
> >>> Why create a new device when that h/w already has one?
> >>>
> >>> Why doesn't the existing crypto driver register dma capabilities with
> >>> the dma driver subsystem?
> >>>
> >> I can think of two reasons:
> >>
> >> 1. The code that this driver introduces has nothing to do with crypto
> >> and everything to do with dma.
> > 
> > I would think that at least a crypto "null" algorithm implementation
> > would share code.
> >
> >> Placing the code in the same directory as
> >> the caam subsystem would only create confusion for the reader of an
> >> already complex driver.
> > 
> > this different directory argument seems to be identical to your 2 below:
> > 
> >> 2. I wanted this driver to be tracked by the dma engine team. They have
> >> the right expertise to provide adequate feedback. If all the code was in
> >> the crypto directory they wouldn't know about this driver or any
> >> subsequent changes to it.
> > 
> > dma subsystem bits could still be put in the dma area if deemed
> > necessary but I don't think it is: I see
> > drivers/crypto/ccp/ccp-dmaengine.c calls dma_async_device_register for
> > example.
> > 
> > I also don't see how that complicates things much further.
> > 
> 
> So who made their review? The guys from crypto?

Don't see how that's relevant here, but people applying patches should
solicit acks from the appropriate sources, esp. if a patch is across
multiple subsystems.

> If someone wants to enable only the DMA functionality of the CCP and not 
> the crypto part how do they do it? Look for it in the crypto submenu?

Why would they want to do that?

In any case, I suspect you're thinking about cross-subsystem Kconfig
entries, which is common, but something like that can be a module
parameter, too.

I would say that maybe CRYPTO_DEV_FSL_CAAM should be made to not depend
on CRYPTO_HW, but I think that's overkill for the addition of this
minor feature.

> > What is the rationale for using the crypto h/w as a dma engine anyway?
> > Are there supporting performance figures?
> 
> We have a platform that doesn't have a dedicated DMA controller but has 
> the CAAM hardware block that can perform dma transfers.  We have a

OK, please mention that next time.

> use-case where we need to issue large transfers (hundred of MBs) 
> asynchronously, without using the core.

Curious: what subsystem does that?

Thanks,

Kim
