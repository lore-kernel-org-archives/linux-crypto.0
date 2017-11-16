From: Vinod Koul <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RESEND 1/4] crypto: caam: add caam-dma node to SEC4.0
 device tree binding
Date: Thu, 16 Nov 2017 11:54:19 +0530
Message-ID: <20171116062419.GR3187@localhost>
References: <20171030134654.13729-1-horia.geanta@nxp.com>
 <20171030134654.13729-2-horia.geanta@nxp.com>
 <20171030092424.1279add003c96ced4233bd2d@arm.com>
 <VI1PR04MB1325BAD68A7CC8C7A302D9A48A570@VI1PR04MB1325.eurprd04.prod.outlook.com>
 <20171109103437.834f8ddb5c62e5253002b2d0@arm.com>
 <VI1PR04MB13253DB5164A151D8E4AB8308A540@VI1PR04MB1325.eurprd04.prod.outlook.com>
 <20171110104430.28b2f56f910b7514d778c4b2@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Radu Andrei Alexe <radu.alexe-3arQi8VN3Tc@public.gmane.org>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta-3arQi8VN3Tc@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Dan Douglass <dan.douglass-3arQi8VN3Tc@public.gmane.org>,
        Shawn Guo <shawnguo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        "dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Kim Phillips <kim.phillips-5wv7dgnIgG8@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171110104430.28b2f56f910b7514d778c4b2-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Nov 10, 2017 at 10:44:30AM -0600, Kim Phillips wrote:
> On Fri, 10 Nov 2017 08:02:01 +0000
> Radu Andrei Alexe <radu.alexe-3arQi8VN3Tc@public.gmane.org> wrote:
> 
> > On 11/9/2017 6:34 PM, Kim Phillips wrote:
> > > On Thu, 9 Nov 2017 11:54:13 +0000
> > > Radu Andrei Alexe <radu.alexe-3arQi8VN3Tc@public.gmane.org> wrote:
> > >> The next patch version will create the platform device dynamically at
> > >> run time.
> > > 
> > > Why create a new device when that h/w already has one?
> > > 
> > > Why doesn't the existing crypto driver register dma capabilities with
> > > the dma driver subsystem?
> > >
> > I can think of two reasons:
> > 
> > 1. The code that this driver introduces has nothing to do with crypto 
> > and everything to do with dma.
> 
> I would think that at least a crypto "null" algorithm implementation
> would share code.
> 
> > Placing the code in the same directory as 
> > the caam subsystem would only create confusion for the reader of an 
> > already complex driver.
> 
> this different directory argument seems to be identical to your 2 below:
> 
> > 2. I wanted this driver to be tracked by the dma engine team. They have 
> > the right expertise to provide adequate feedback. If all the code was in 
> > the crypto directory they wouldn't know about this driver or any 
> > subsequent changes to it.
> 
> dma subsystem bits could still be put in the dma area if deemed
> necessary but I don't think it is: I see
> drivers/crypto/ccp/ccp-dmaengine.c calls dma_async_device_register for
> example.

which is a shame as it was sneaked past the dmaengine community!!

This is the *only* example and there and other examples where people use
dmaengine:

$ grep -rl dmaengine_prep* drivers/crypto/* |uniq
drivers/crypto/atmel-aes.c
drivers/crypto/atmel-sha.c
drivers/crypto/atmel-tdes.c
drivers/crypto/img-hash.c
drivers/crypto/omap-aes.c
drivers/crypto/omap-des.c
drivers/crypto/omap-sham.c
drivers/crypto/qce/dma.c
drivers/crypto/stm32/stm32-hash.c
drivers/crypto/ux500/cryp/cryp_core.c
drivers/crypto/ux500/hash/hash_core.c



> 
> I also don't see how that complicates things much further.
> 
> What is the rationale for using the crypto h/w as a dma engine anyway?
> Are there supporting performance figures?

that is a very good question, perf does matter. Given that we have many
folks using it, I think it would help, but yes nothing better than numbers
speak for themselves.

-- 
~Vinod
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
