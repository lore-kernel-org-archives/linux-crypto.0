From: Liu Qiang-B32616 <B32616@freescale.com>
Subject: RE: [PATCH v2 3/4] fsl-dma: change the release process of dma
 descriptor
Date: Thu, 12 Jul 2012 07:12:13 +0000
Message-ID: <BCB48C05FCE8BC4D9E61E841ECBE6DB70C0916@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1341997285-18459-1-git-send-email-qiang.liu@freescale.com>
 <20120711163058.GD17539@ovro.caltech.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	Vinod Koul <vinod.koul@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:23015
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757994Ab2GLHMR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Jul 2012 03:12:17 -0400
In-Reply-To: <20120711163058.GD17539@ovro.caltech.edu>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> -----Original Message-----
> From: Ira W. Snyder [mailto:iws@ovro.caltech.edu]
> Sent: Thursday, July 12, 2012 12:31 AM
> To: Liu Qiang-B32616
> Cc: linux-crypto@vger.kernel.org; linuxppc-dev@lists.ozlabs.org; Vinod
> Koul; herbert@gondor.hengli.com.au; Dan Williams; davem@davemloft.net
> Subject: Re: [PATCH v2 3/4] fsl-dma: change the release process of dma
> descriptor
> 
> On Wed, Jul 11, 2012 at 05:01:25PM +0800, Qiang Liu wrote:
> > Modify the release process of dma descriptor for avoiding exception
> when
> > enable config NET_DMA, release dma descriptor from 1st to last second,
> the
> > last descriptor which is reserved in current descriptor register may
> not be
> > completed, race condition will be raised if free current descriptor.
> >
> > A race condition which is raised when use both of talitos and dmaengine
> to
> > offload xor is because napi scheduler (NET_DMA is enabled) will sync
> all
> > pending requests in dma channels, it affects the process of raid
> operations.
> > The descriptor is freed which is submitted just now, but async_tx must
> check
> > whether this depend tx descriptor is acked, there are poison contents
> in the
> > invalid address, then BUG_ON() is thrown, so this descriptor will be
> freed
> > in the next time.
> >
> 
> This patch seems to be covering up a bug in the driver, rather than
> actually fixing it.
Yes, it's fine for fsl-dma itself, but it cannot work under complex condition.
For example, we enable NET_DMA and SEC xor offload, if NAPI task is waken up to
synchronize pending requests when raid5 dma copy was submitted, the process order
of raid5 tx descriptor is not as our expected. Unfortunately, sometime we have
to check this dependent tx descriptor which has was already released.

> 
> When it was written, it was expected that dma_do_tasklet() would run
> only when the controller was idle.
> 
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: Vinod Koul <vinod.koul@intel.com>
> > Cc: Li Yang <leoli@freescale.com>
> > Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
> > ---
> >  drivers/dma/fsldma.c |   15 ++++++++++++---
> >  1 files changed, 12 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
> > index 4f2f212..0ba3e40 100644
> > --- a/drivers/dma/fsldma.c
> > +++ b/drivers/dma/fsldma.c
> > @@ -1035,14 +1035,22 @@ static irqreturn_t fsldma_chan_irq(int irq,
> void *data)
> >  static void dma_do_tasklet(unsigned long data)
> >  {
> >  	struct fsldma_chan *chan = (struct fsldma_chan *)data;
> > -	struct fsl_desc_sw *desc, *_desc;
> > +	struct fsl_desc_sw *desc, *_desc, *prev = NULL;
> >  	LIST_HEAD(ld_cleanup);
> >  	unsigned long flags;
> > +	dma_addr_t curr_phys = get_cdar(chan);
> >
> >  	chan_dbg(chan, "tasklet entry\n");
> >
> >  	spin_lock_irqsave(&chan->desc_lock, flags);
> >
> > +	/* find the descriptor which is already completed */
> > +	list_for_each_entry_safe(desc, _desc, &chan->ld_running, node) {
> > +		if (prev && desc->async_tx.phys == curr_phys)
> > +			break;
> > +		prev = desc;
> > +	}
> > +
> 
> If the DMA controller was still busy processing transactions, you should
> have gotten the printout "irq: controller not idle!" from
> fsldma_chan_irq() just before it scheduled the dma_do_tasklet() to run.
> If you did not get this printout, how was dma_do_tasklet() entered with
> the controller still busy? I don't understand how it can happen.
Hi ira, this issue should be not related to dma status. The last descriptor
is left as usb null descriptor, actually, this descriptor is used as usb null
descriptor, at any case, I believe it has been already completed, but I
will released it in next chain, it doesn't affect the upper api to use the
data, and make sure async_tx api won't raise an exception 
(BUG_ON(async_tx_test_ack(depend_tx)), this depend_tx is the desc->async_tx).

> 
> If you test without your spin_lock_bh() and spin_unlock_bh() conversion
> patch, do you still hit the error?
The error still happened. spin_lock_bh() and spin_unlock_bh() are modified
after this patch.

> 
> What happens if a user submits exactly one DMA transaction, and then
> leaves the system idle? The callback for the last descriptor in the
> chain will never get run, right? That's a bug.
It won't be happened if use fsl-dma, because the right order is 
xor-copy-xor->callback, The callback which you concerned is implemented 
in talitos driver, callback should be null in fsl-dma.

> 
> >  	/* update the cookie if we have some descriptors to cleanup */
> >  	if (!list_empty(&chan->ld_running)) {
> >  		dma_cookie_t cookie;
> > @@ -1058,13 +1066,14 @@ static void dma_do_tasklet(unsigned long data)
> >  	 * move the descriptors to a temporary list so we can drop the lock
> >  	 * during the entire cleanup operation
> >  	 */
> > -	list_splice_tail_init(&chan->ld_running, &ld_cleanup);
> > +	list_cut_position(&ld_cleanup, &chan->ld_running, &prev->node);
> >
> >  	/* the hardware is now idle and ready for more */
> >  	chan->idle = true;
> >
> >  	/*
> > -	 * Start any pending transactions automatically
> > +	 * Start any pending transactions automatically if current
> descriptor
> > +	 * list is completed
> >  	 *
> >  	 * In the ideal case, we keep the DMA controller busy while we go
> >  	 * ahead and free the descriptors below.
> > --
> > 1.7.5.1
> >
> >
> > _______________________________________________
> > Linuxppc-dev mailing list
> > Linuxppc-dev@lists.ozlabs.org
> > https://lists.ozlabs.org/listinfo/linuxppc-dev
