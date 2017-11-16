From: Vinod Koul <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RESEND 4/4] dma: caam: add dma memcpy driver
Date: Thu, 16 Nov 2017 11:41:01 +0530
Message-ID: <20171116061101.GP3187@localhost>
References: <20171030134654.13729-1-horia.geanta@nxp.com>
 <20171030134654.13729-5-horia.geanta@nxp.com>
 <20171031120423.GS3187@localhost>
 <VI1PR04MB1325358D7898120FC0BCEBE88A560@VI1PR04MB1325.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta-3arQi8VN3Tc@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Dan Douglass <dan.douglass-3arQi8VN3Tc@public.gmane.org>,
        Shawn Guo <shawnguo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        "dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Tudor Ambarus <tudor-dan.ambarus-3arQi8VN3Tc@public.gmane.org>,
        Rajiv Vishwakarma <rajiv.vishwakarma-3arQi8VN3Tc@public.gmane.org>
To: Radu Andrei Alexe <radu.alexe-3arQi8VN3Tc@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <VI1PR04MB1325358D7898120FC0BCEBE88A560-mr6QIVyDiCGGEpojCloM0M9NdZoXdze2vxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 08, 2017 at 02:36:31PM +0000, Radu Andrei Alexe wrote:
> On 10/31/2017 2:01 PM, Vinod Koul wrote:
> > On Mon, Oct 30, 2017 at 03:46:54PM +0200, Horia Geantă wrote:
> >> +/*
> >> + * caam support for SG DMA
> >> + *
> >> + * Copyright 2016 Freescale Semiconductor, Inc
> >> + * Copyright 2017 NXP
> >> + */
> > 
> > that is interesting, no license text?
> > 
> 
> Thanks for the catch. The next patch will contain the full license text.

or as is the "new" practice, you may used SPDX tags

> >> +#include "../crypto/caam/regs.h"
> >> +#include "../crypto/caam/jr.h"
> >> +#include "../crypto/caam/error.h"
> >> +#include "../crypto/caam/intern.h"
> >> +#include "../crypto/caam/desc_constr.h"
> > 
> > ah that puts very hard assumptions on locations of the subsystems. Please do
> > not do that and move the required stuff into common header location in
> > include/
> > 
> 
> Unfortunately this is not possible. The functionality used by CAAM DMA 
> from the CAAM subsystem should not be exported to be used by other 
> modules. It is because this driver is so tightly coupled with the CAAM 
> driver(s) that it needs access to it's 'internal' functionality (that 
> should not be otherwise shared with anyone).

Which other driver would be interested in your CAM implementation except
you. Realistically speaking none, so it is perfectly fine to do so in a
header at a right place!

> >> +struct caam_dma_sh_desc {
> > 
> > sh?
> > 
> 
> It means "shared". It is obvious to anyone who is familiar with the CAAM 
> system.

Unfortunately I am not. As a patch writer you have the onus to explain it to
people who live outside the CAAM world

> >> +static struct dma_device *dma_dev;
> >> +static struct caam_dma_sh_desc *dma_sh_desc;
> >> +static LIST_HEAD(dma_ctx_list);
> > 
> > why do you need so many globals?
> > 
> 
> How many globals are too many? I can group them in a common structure. 
> But I'm not sure how would that help.

I prefer none. Make sure the struct instance is not global and allocated in
your driver probe routine.


> >> +static dma_cookie_t caam_dma_tx_submit(struct dma_async_tx_descriptor *tx)
> >> +{
> >> +	struct caam_dma_edesc *edesc = NULL;
> >> +	struct caam_dma_ctx *ctx = NULL;
> >> +	dma_cookie_t cookie;
> >> +
> >> +	edesc = container_of(tx, struct caam_dma_edesc, async_tx);
> >> +	ctx = container_of(tx->chan, struct caam_dma_ctx, chan);
> >> +
> >> +	spin_lock_bh(&ctx->edesc_lock);
> > 
> > why _bh, i didnt see any irqs or tasklets here which is actually odd, so
> > what is going on
> > 
> 
> The tasklet is hidden inside the JR driver from the CAAM subsystem (see 
> drivers/crypto/caam/jr.c). The function caam_dma_done(), which is called 
> from the JR tasklet handler, also uses the spin_lock. I need to disable 
> bottom half to make sure that I don't run into a deadlock when I'm 
> preempted.

This would be the right time to explain why. I understand that your subsystem
has tightly coupled DMA but that doesn't really mean the DMA controller should
not have its own IRQ and bh. This makes things harder to review and follow.

> >> +	cookie = dma_cookie_assign(tx);
> >> +	list_add_tail(&edesc->node, &ctx->submit_q);
> >> +
> >> +	spin_unlock_bh(&ctx->edesc_lock);
> >> +
> >> +	return cookie;
> >> +}
> > 
> > we have a virtual channel wrapper where we do the same stuff as above, so
> > consider reusing that
> > 
> 
> Some of the functionality that the virtual channel might provide cannot 
> be extracted because it is embedded into the JR driver (e.g. the 
> tasklet). Therefore the use of the virtual channel is inefficient at 
> best if not even impossible.

Which itself is problematic in first place and no explanation provided on
why. Yes you have a special hardware, so does every second person!

> >> +static void caam_dma_issue_pending(struct dma_chan *chan)
> >> +{
> >> +	struct caam_dma_ctx *ctx = container_of(chan, struct caam_dma_ctx,
> >> +						chan);
> >> +	struct caam_dma_edesc *edesc, *_edesc;
> >> +
> >> +	spin_lock_bh(&ctx->edesc_lock);
> >> +	list_for_each_entry_safe(edesc, _edesc, &ctx->submit_q, node) {
> >> +		if (caam_jr_enqueue(ctx->jrdev, edesc->jd,
> >> +				    caam_dma_done, edesc) < 0)
> > 
> > what does the caam_jr_enqueue() do?
> > 
> 
> Enqueues a job descriptor (jd) into a job ring (jr). Additionally the 
> "caam_dma_done()" function is registered to be used as a callback when 
> the job finishes. For more details see drivers/crypto/caam/jr.c.

Sorry I am going to refuse to look at other references. A patch should
provide enough explanation on its own for me to review.

> >> +	err = dma_async_device_register(dma_dev);
> >> +	if (err) {
> >> +		dev_err(dev, "Failed to register CAAM DMA engine\n");
> >> +		goto jr_bind_err;
> >> +	}
> >> +
> >> +	dev_info(dev, "caam dma support with %d job rings\n", bonds);
> > 
> > that is very noisy
> > 
> 
> I want to print a line that informs that the caam_dma driver has been 
> successfully probed. Do you have any other suggestion?

Please remove the line, or worst make this debug print

Overall I am not very excited about this implementation. I think things can
be improved and decoupled from crypto driver and things done independently.
If you do so this driver can be reused across different crypto
implementations where you have the same DMA controller.

Thanks
-- 
~Vinod
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
