From: Kim Phillips <kim.phillips-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH RESEND 1/4] crypto: caam: add caam-dma node to SEC4.0
 device tree binding
Date: Thu, 9 Nov 2017 10:34:37 -0600
Message-ID: <20171109103437.834f8ddb5c62e5253002b2d0@arm.com>
References: <20171030134654.13729-1-horia.geanta@nxp.com>
        <20171030134654.13729-2-horia.geanta@nxp.com>
        <20171030092424.1279add003c96ced4233bd2d@arm.com>
        <VI1PR04MB1325BAD68A7CC8C7A302D9A48A570@VI1PR04MB1325.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Horia =?UTF-8?B?R2VhbnTEgw==?= <horia.geanta-3arQi8VN3Tc@public.gmane.org>,
        Vinod Koul <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        "Dan Douglass" <dan.douglass-3arQi8VN3Tc@public.gmane.org>,
        Shawn Guo <shawnguo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        "dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Radu Andrei Alexe <radu.alexe-3arQi8VN3Tc@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR04MB1325BAD68A7CC8C7A302D9A48A570-mr6QIVyDiCGGEpojCloM0M9NdZoXdze2vxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Thu, 9 Nov 2017 11:54:13 +0000
Radu Andrei Alexe <radu.alexe-3arQi8VN3Tc@public.gmane.org> wrote:

> On 10/30/2017 4:24 PM, Kim Phillips wrote:
> > On Mon, 30 Oct 2017 15:46:51 +0200
> > Horia Geantă <horia.geanta-3arQi8VN3Tc@public.gmane.org> wrote:
> > 
> >> +=====================================================================
> >> +CAAM DMA Node
> >> +
> >> +    Child node of the crypto node that enables the use of the DMA capabilities
> >> +    of the CAAM by a stand-alone driver. The only required property is the
> >> +    "compatible" property. All the other properties are determined from
> >> +    the job rings on which the CAAM DMA driver depends (ex: the number of
> >> +    dma-channels is equal to the number of defined job rings).
> >> +
> >> +  - compatible
> >> +      Usage: required
> >> +      Value type: <string>
> >> +      Definition: Must include "fsl,sec-v4.0-dma"
> >> +
> >> +EXAMPLE
> >> +  caam-dma {
> >> +    compatible = "fsl,sec-v5.4-dma",
> >> +                 "fsl,sec-v5.0-dma",
> >> +                 "fsl,sec-v4.0-dma";
> >> +  }
> > 
> > If this isn't describing an aspect of the hardware, then what is it
> > doing in the device tree?
> > 
> > Kim
> > 
> 
> Because the caam_dma driver is a platform driver I needed to create a 
> platform device to activate the driver. My thought was that it was 
> simpler to implement it using device tree.
> The next patch version will create the platform device dynamically at 
> run time.

Why create a new device when that h/w already has one?

Why doesn't the existing crypto driver register dma capabilities with
the dma driver subsystem?

Kim
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
