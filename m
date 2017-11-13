From: Kim Phillips <kim.phillips@arm.com>
Subject: Re: [PATCH RESEND 1/4] crypto: caam: add caam-dma node to SEC4.0
 device tree binding
Date: Mon, 13 Nov 2017 09:21:32 -0600
Message-ID: <20171113092132.55f13384cede1f283a53434b@arm.com>
References: <20171030134654.13729-1-horia.geanta@nxp.com>
        <20171030134654.13729-2-horia.geanta@nxp.com>
        <20171030092424.1279add003c96ced4233bd2d@arm.com>
        <VI1PR04MB1325BAD68A7CC8C7A302D9A48A570@VI1PR04MB1325.eurprd04.prod.outlook.com>
        <20171109103437.834f8ddb5c62e5253002b2d0@arm.com>
        <VI1PR04MB13253DB5164A151D8E4AB8308A540@VI1PR04MB1325.eurprd04.prod.outlook.com>
        <20171110104430.28b2f56f910b7514d778c4b2@arm.com>
        <VI1PR0402MB3342C1736F492A323096541C982B0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Radu Andrei Alexe <radu.alexe@nxp.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Dan Douglass" <dan.douglass@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
To: Horia =?UTF-8?B?R2VhbnTEgw==?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:47774 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752735AbdKMPVg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Nov 2017 10:21:36 -0500
In-Reply-To: <VI1PR0402MB3342C1736F492A323096541C982B0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 13 Nov 2017 08:32:24 +0000
Horia Geantă <horia.geanta@nxp.com> wrote:

> On 11/10/2017 6:44 PM, Kim Phillips wrote:
> > On Fri, 10 Nov 2017 08:02:01 +0000
> > Radu Andrei Alexe <radu.alexe@nxp.com> wrote:
> [snip]>> 2. I wanted this driver to be tracked by the dma engine team.
> They have
> >> the right expertise to provide adequate feedback. If all the code was in 
> >> the crypto directory they wouldn't know about this driver or any 
> >> subsequent changes to it.
> > 
> > dma subsystem bits could still be put in the dma area if deemed
> > necessary but I don't think it is: I see
> > drivers/crypto/ccp/ccp-dmaengine.c calls dma_async_device_register for
> > example.
> > 
> Please see previous discussion with Vinod:
> https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg21468.html

Vinod says: "If the dma controller is internal to crypto, then it might
be okay to be inside the crypto driver."

Is that the case for the CCP driver?  Isn't it the case here?

In any case, I don't care that much about that, this all begat from new
*devices* coming out of nowhere.

> > What is the rationale for using the crypto h/w as a dma engine anyway?
> SoCs that don't have a system DMA, for e.g. LS1012A.

OK.

Kim
