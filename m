From: Liu Qiang-B32616 <B32616@freescale.com>
Subject: RE: [PATCH v4 3/7] fsl-dma: change release process of dma
 descriptor for supporting async_tx
Date: Wed, 1 Aug 2012 03:29:40 +0000
Message-ID: <BCB48C05FCE8BC4D9E61E841ECBE6DB70C6242@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1343380569-12013-1-git-send-email-qiang.liu@freescale.com>
 <20120730211004.GA12430@ovro.caltech.edu>
 <BCB48C05FCE8BC4D9E61E841ECBE6DB70C5D24@039-SN2MPN1-011.039d.mgd.msft.net>
 <20120731221331.GH12430@ovro.caltech.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Li Yang-R58472 <r58472@freescale.com>, Vinod Koul <vinod.koul@intel.com>,
 Phillips Kim-R1AAHA <R1AAHA@freescale.com>,
 "dan.j.williams@gmail.com" <dan.j.williams@gmail.com>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
 "davem@davemloft.net" <davem@davemloft.net>,
 "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <20120731221331.GH12430@ovro.caltech.edu>
Content-Language: en-US
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-crypto.vger.kernel.org

> -----Original Message-----
> From: Ira W. Snyder [mailto:iws@ovro.caltech.edu]
> Sent: Wednesday, August 01, 2012 6:14 AM
> To: Liu Qiang-B32616
> Cc: linux-crypto@vger.kernel.org; linuxppc-dev@lists.ozlabs.org; Phillips
> Kim-R1AAHA; davem@davemloft.net; dan.j.williams@gmail.com; Vinod Koul; Li
> Yang-R58472; herbert@gondor.apana.org.au
> Subject: Re: [PATCH v4 3/7] fsl-dma: change release process of dma
> descriptor for supporting async_tx
> 
> On Tue, Jul 31, 2012 at 04:09:28AM +0000, Liu Qiang-B32616 wrote:
> > > -----Original Message-----
> > > From: Ira W. Snyder [mailto:iws@ovro.caltech.edu]
> > > Sent: Tuesday, July 31, 2012 5:10 AM
> > > To: Liu Qiang-B32616
> > > Cc: linux-crypto@vger.kernel.org; linuxppc-dev@lists.ozlabs.org;
> Phillips
> > > Kim-R1AAHA; herbert@gondor.hengli.com.au; davem@davemloft.net; Dan
> > > Williams; Vinod Koul; Li Yang-R58472
> > > Subject: Re: [PATCH v4 3/7] fsl-dma: change release process of dma
> > > descriptor for supporting async_tx
> > >
> > > On Fri, Jul 27, 2012 at 05:16:09PM +0800, qiang.liu@freescale.com
> wrote:
> > > > From: Qiang Liu <qiang.liu@freescale.com>
> > > >
> > > > Fix the potential risk when enable config NET_DMA and ASYNC_TX.
> > > > Async_tx is lack of support in current release process of dma
> > > descriptor,
> > > > all descriptors will be released whatever is acked or no-acked by
> > > async_tx,
> > > > so there is a potential race condition when dma engine is uesd by
> > > others
> > > > clients (e.g. when enable NET_DMA to offload TCP).
> > > >
> > > > In our case, a race condition which is raised when use both of
> talitos
> > > > and dmaengine to offload xor is because napi scheduler will sync
> all
> > > > pending requests in dma channels, it affects the process of raid
> > > operations
> > > > due to ack_tx is not checked in fsl dma. The no-acked descriptor is
> > > freed
> > > > which is submitted just now, as a dependent tx, this freed
> descriptor
> > > trigger
> > > > BUG_ON(async_tx_test_ack(depend_tx)) in async_tx_submit().
> > > >
> > >
> > > I'm preparing an alternative version of this patch that I think is
> > > easier to understand (it is much shorter). I'll post it up here as
> soon
> > > as I finish testing.
> > Can you give a simple description/idea about your patch? My patch is
> for fix the
> > problems when I build a raid environment with talitos offload xor.
> > I think the new interface is clear enough and similar with the
> implement of other dma devices.
> >
> > And do you have any comments about this patch?
> >
> 
> My patch will fix the same problem, in a simpler way. It will not
> involve checking if the hardware is finished with a descriptor on
> ld_running.
> 
> > >
> > > It would be nice to know how to easily reproduce this bug, without
> > > needing to set up a RAID system. I don't have access to any such
> > > hardware. A driver similar to drivers/dma/dmatest.c (using the
> async_tx
> > > API instead) would be wonderful.
> > You can refer to raid5.c if you do not want to use hardware. Or you can
> use
> > you ram (or other storage devices) to build a raid env to test.
> > Thanks.
> >
> > >
> > > Thanks,
> > > Ira
> > >
> > > > TASK = ee1a94a0[1390] 'md0_raid5' THREAD: ecf40000 CPU: 0
> > > > GPR00: 00000001 ecf41ca0 ee44/921a94a0 0000003f 00000001 c00593e4
> > > 00000000 00000001
> > > > GPR08: 00000000 a7a7a7a7 00000001 045/920000002 42028042 100a38d4
> > > ed576d98 00000000
> > > > GPR16: ed5a11b0 00000000 2b162000 00000200 046/920000000 2d555000
> > > ed3015e8 c15a7aa0
> > > > GPR24: 00000000 c155fc40 00000000 ecb63220 ecf41d28 e47/92f640bb0
> > > ef640c30 ecf41ca0
> > > > NIP [c02b048c] async_tx_submit+0x6c/0x2b4
> > > > LR [c02b068c] async_tx_submit+0x26c/0x2b4
> > > > Call Trace:
> > > > [ecf41ca0] [c02b068c] async_tx_submit+0x26c/0x2b448/92 (unreliable)
> > > > [ecf41cd0] [c02b0a4c] async_memcpy+0x240/0x25c
> > > > [ecf41d20] [c0421064] async_copy_data+0xa0/0x17c
> > > > [ecf41d70] [c0421cf4] __raid_run_ops+0x874/0xe10
> > > > [ecf41df0] [c0426ee4] handle_stripe+0x820/0x25e8
> > > > [ecf41e90] [c0429080] raid5d+0x3d4/0x5b4
> > > > [ecf41f40] [c04329b8] md_thread+0x138/0x16c
> > > > [ecf41f90] [c008277c] kthread+0x8c/0x90
> > > > [ecf41ff0] [c0011630] kernel_thread+0x4c/0x68
> > > >
> > > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > > Cc: Vinod Koul <vinod.koul@intel.com>
> > > > Cc: Li Yang <leoli@freescale.com>
> > > > Cc: Ira W. Snyder <iws@ovro.caltech.edu>
> > > > Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
> > > > ---
> > > >  drivers/dma/fsldma.c |  242 +++++++++++++++++++++++++++++++++++---
> ----
> > > --------
> > > >  drivers/dma/fsldma.h |    1 +
> > > >  2 files changed, 172 insertions(+), 71 deletions(-)
> > > >
> > > > diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
> > > > index 4f2f212..87f52c0 100644
> > > > --- a/drivers/dma/fsldma.c
> > > > +++ b/drivers/dma/fsldma.c
> > > > @@ -400,6 +400,125 @@ out_splice:
> > > >  	list_splice_tail_init(&desc->tx_list, &chan->ld_pending);
> > > >  }
> > > >
> > > > +static void fsldma_cleanup_descriptor(struct fsldma_chan *chan);
> > > > +static void fsl_chan_xfer_ld_queue(struct fsldma_chan *chan);
> > > > +
> 
> You should have re-arranged the patches to avoid introducing these
> forward declarations in this patch and then deleting them in the next
> patch. I reversed the order in my patch series.
I split it up according to Li Yang's advice. Maybe you miss the mail, please refer to:
http://patchwork.ozlabs.org/patch/173605/
Thanks.

> > > > +/**
> > > > + * fsldma_clean_completed_descriptor - free all descriptors which
> > > > + * has been completed and acked
> > > > + * @chan: Freescale DMA channel
> > > > + *
> > > > + * This function is used on all completed and acked descriptors.
> > > > + * All descriptors should only be freed in this function.
> > > > + */
> > > > +static int
> > > > +fsldma_clean_completed_descriptor(struct fsldma_chan *chan)
> > > > +{
> > > > +	struct fsl_desc_sw *desc, *_desc;
> > > > +
> > > > +	/* Run the callback for each descriptor, in order */
> > > > +	list_for_each_entry_safe(desc, _desc, &chan->ld_completed,
> node) {
> > > > +
> > > > +		if (async_tx_test_ack(&desc->async_tx)) {
> > > > +			/* Remove from the list of transactions */
> > > > +			list_del(&desc->node);
> > > > +#ifdef FSL_DMA_LD_DEBUG
> > > > +			chan_dbg(chan, "LD %p free\n", desc);
> > > > +#endif
> > > > +			dma_pool_free(chan->desc_pool, desc,
> > > > +					desc->async_tx.phys);
> > > > +		}
> > > > +	}
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +/**
> > > > + * fsldma_run_tx_complete_actions - cleanup and free a single link
> > > descriptor
> > > > + * @chan: Freescale DMA channel
> > > > + * @desc: descriptor to cleanup and free
> > > > + * @cookie: Freescale DMA transaction identifier
> > > > + *
> > > > + * This function is used on a descriptor which has been executed
> by
> > > the DMA
> > > > + * controller. It will run any callbacks, submit any dependencies.
> > > > + */
> > > > +static dma_cookie_t fsldma_run_tx_complete_actions(struct
> fsl_desc_sw
> > > *desc,
> > > > +		struct fsldma_chan *chan, dma_cookie_t cookie)
> > > > +{
> > > > +	struct dma_async_tx_descriptor *txd = &desc->async_tx;
> > > > +	struct device *dev = chan->common.device->dev;
> > > > +	dma_addr_t src = get_desc_src(chan, desc);
> > > > +	dma_addr_t dst = get_desc_dst(chan, desc);
> > > > +	u32 len = get_desc_cnt(chan, desc);
> > > > +
> > > > +	BUG_ON(txd->cookie < 0);
> > > > +
> > > > +	if (txd->cookie > 0) {
> > > > +		cookie = txd->cookie;
> > > > +
> > > > +		/* Run the link descriptor callback function */
> > > > +		if (txd->callback) {
> > > > +#ifdef FSL_DMA_LD_DEBUG
> > > > +			chan_dbg(chan, "LD %p callback\n", desc);
> > > > +#endif
> > > > +			txd->callback(txd->callback_param);
> > > > +		}
> > > > +
> > > > +		/* Unmap the dst buffer, if requested */
> > > > +		if (!(txd->flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
> > > > +			if (txd->flags & DMA_COMPL_DEST_UNMAP_SINGLE)
> > > > +				dma_unmap_single(dev, dst, len,
> DMA_FROM_DEVICE);
> > > > +			else
> > > > +				dma_unmap_page(dev, dst, len,
> DMA_FROM_DEVICE);
> > > > +		}
> > > > +
> > > > +		/* Unmap the src buffer, if requested */
> > > > +		if (!(txd->flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
> > > > +			if (txd->flags & DMA_COMPL_SRC_UNMAP_SINGLE)
> > > > +				dma_unmap_single(dev, src, len,
> DMA_TO_DEVICE);
> > > > +			else
> > > > +				dma_unmap_page(dev, src, len,
> DMA_TO_DEVICE);
> > > > +		}
> > > > +	}
> > > > +
> > > > +	/* Run any dependencies */
> > > > +	dma_run_dependencies(txd);
> > > > +
> > > > +	return cookie;
> > > > +}
> > > > +
> > > > +/**
> > > > + * fsldma_clean_running_descriptor - move the completed descriptor
> > > from
> > > > + * ld_running to ld_completed
> > > > + * @chan: Freescale DMA channel
> > > > + * @desc: the descriptor which is completed
> > > > + *
> > > > + * Free the descriptor directly if acked by async_tx api, or move
> it
> > > to
> > > > + * queue ld_completed.
> > > > + */
> > > > +static int
> > > > +fsldma_clean_running_descriptor(struct fsldma_chan *chan,
> > > > +		struct fsl_desc_sw *desc)
> > > > +{
> > > > +	/* Remove from the list of transactions */
> > > > +	list_del(&desc->node);
> > > > +	/*
> > > > +	 * the client is allowed to attach dependent operations
> > > > +	 * until 'ack' is set
> > > > +	 */
> > > > +	if (!async_tx_test_ack(&desc->async_tx)) {
> > > > +		/*
> > > > +		 * Move this descriptor to the list of descriptors
> which is
> > > > +		 * completed, but still awaiting the 'ack' bit to be
> set.
> > > > +		 */
> > > > +		list_add_tail(&desc->node, &chan->ld_completed);
> > > > +		return 0;
> > > > +	}
> > > > +
> > > > +	dma_pool_free(chan->desc_pool, desc, desc->async_tx.phys);
> > > > +	return 0;
> > > > +}
> > > > +
> > > >  static dma_cookie_t fsl_dma_tx_submit(struct
> dma_async_tx_descriptor
> > > *tx)
> > > >  {
> > > >  	struct fsldma_chan *chan = to_fsl_chan(tx->chan);
> > > > @@ -534,8 +653,10 @@ static void fsl_dma_free_chan_resources(struct
> > > dma_chan *dchan)
> > > >
> > > >  	chan_dbg(chan, "free all channel resources\n");
> > > >  	spin_lock_irqsave(&chan->desc_lock, flags);
> > > > +	fsldma_cleanup_descriptor(chan);
> > > >  	fsldma_free_desc_list(chan, &chan->ld_pending);
> > > >  	fsldma_free_desc_list(chan, &chan->ld_running);
> > > > +	fsldma_free_desc_list(chan, &chan->ld_completed);
> > > >  	spin_unlock_irqrestore(&chan->desc_lock, flags);
> > > >
> > > >  	dma_pool_destroy(chan->desc_pool);
> > > > @@ -819,46 +940,53 @@ static int fsl_dma_device_control(struct
> dma_chan
> > > *dchan,
> > > >   * controller. It will run any callbacks, submit any dependencies,
> and
> > > then
> > > >   * free the descriptor.
> > > >   */
> > > > -static void fsldma_cleanup_descriptor(struct fsldma_chan *chan,
> > > > -				      struct fsl_desc_sw *desc)
> > > > +static void fsldma_cleanup_descriptor(struct fsldma_chan *chan)
> > > >  {
> > > > -	struct dma_async_tx_descriptor *txd = &desc->async_tx;
> > > > -	struct device *dev = chan->common.device->dev;
> > > > -	dma_addr_t src = get_desc_src(chan, desc);
> > > > -	dma_addr_t dst = get_desc_dst(chan, desc);
> > > > -	u32 len = get_desc_cnt(chan, desc);
> > > > +	struct fsl_desc_sw *desc, *_desc;
> > > > +	dma_cookie_t cookie = 0;
> > > > +	dma_addr_t curr_phys = get_cdar(chan);
> > > > +	int idle = dma_is_idle(chan);
> > > > +	int seen_current = 0;
> > > >
> > > > -	/* Run the link descriptor callback function */
> > > > -	if (txd->callback) {
> > > > -#ifdef FSL_DMA_LD_DEBUG
> > > > -		chan_dbg(chan, "LD %p callback\n", desc);
> > > > -#endif
> > > > -		txd->callback(txd->callback_param);
> > > > -	}
> > > > +	fsldma_clean_completed_descriptor(chan);
> > > >
> > > > -	/* Run any dependencies */
> > > > -	dma_run_dependencies(txd);
> > > > +	/* Run the callback for each descriptor, in order */
> > > > +	list_for_each_entry_safe(desc, _desc, &chan->ld_running, node)
> {
> > > > +		/*
> > > > +		 * do not advance past the current descriptor loaded
> into the
> > > > +		 * hardware channel, subsequent descriptors are either
> in
> > > > +		 * process or have not been submitted
> > > > +		 */
> > > > +		if (seen_current)
> > > > +			break;
> > > >
> > > > -	/* Unmap the dst buffer, if requested */
> > > > -	if (!(txd->flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
> > > > -		if (txd->flags & DMA_COMPL_DEST_UNMAP_SINGLE)
> > > > -			dma_unmap_single(dev, dst, len, DMA_FROM_DEVICE);
> > > > -		else
> > > > -			dma_unmap_page(dev, dst, len, DMA_FROM_DEVICE);
> > > > -	}
> > > > +		/*
> > > > +		 * stop the search if we reach the current descriptor
> and the
> > > > +		 * channel is busy
> > > > +		 */
> > > > +		if (desc->async_tx.phys == curr_phys) {
> > > > +			seen_current = 1;
> > > > +			if (!idle)
> > > > +				break;
> > > > +		}
> 
> I really don't like the idea of trying to guess what the hardware is
> doing. Variables curr_phys and idle can be stale by the time the
> processor gets here. The DMA engine is very fast at processing
> descriptors.
I know hardware is very fast, but you cannot assume it has already been completed.
Below is the description about current list descriptor,

Current List Descriptor Address Registers (CLSDARn and ECLSDARn)
After finishing the last link descriptor in the current list, the DMA controller loads
the contents of the next list descriptor address register into the current list descriptor address register. If
NLSDARn[EOLSD] in the next list descriptor address register is clear, the DMA controller reads the new
current list descriptor from memory to process that list. If EOLSD in the next list descriptor address
register is set and the last link in the current list is finished, all DMA transfers are complete.

So it's a bug which you think the whole list is completed when an interrupt is raised, there is a potential
risk when an interrupt is raised by "Programmed Error". The "ld_running" is a s/w concept, we should not
depend on it to judge the status of descriptors list.

I know you don't like this process, but it's a safe and common process. You can refer to other dma
drivers, like ioap-adma, mv-xor and ibm-ppc440x-adma.
Said far point, usb also take this method to judge which descriptor is completed, I don't know which device
can use a s/w list to free all descriptors, you can refer to the implement of dl_reverse_done_list().

Thanks.

> 
> It is much easier to reason about the hardware state if you have it tell
> you (via an interrupt) when it is ready for more descriptors. My patch
> takes this approach. I'll be posting it in a few minutes.
No, the interrupt is only report the state of hardware, we cannot assume all descriptors
are finished when an interrupt is raised :)

> 
> > > > +
> > > > +		cookie = fsldma_run_tx_complete_actions(desc, chan,
> cookie);
> > > > +
> > > > +		if (fsldma_clean_running_descriptor(chan, desc))
> > > > +			break;
> > > >
> > > > -	/* Unmap the src buffer, if requested */
> > > > -	if (!(txd->flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
> > > > -		if (txd->flags & DMA_COMPL_SRC_UNMAP_SINGLE)
> > > > -			dma_unmap_single(dev, src, len, DMA_TO_DEVICE);
> > > > -		else
> > > > -			dma_unmap_page(dev, src, len, DMA_TO_DEVICE);
> > > >  	}
> > > >
> > > > -#ifdef FSL_DMA_LD_DEBUG
> > > > -	chan_dbg(chan, "LD %p free\n", desc);
> > > > -#endif
> > > > -	dma_pool_free(chan->desc_pool, desc, txd->phys);
> > > > +	/*
> > > > +	 * Start any pending transactions automatically
> > > > +	 *
> > > > +	 * In the ideal case, we keep the DMA controller busy while
> we go
> > > > +	 * ahead and free the descriptors below.
> > > > +	 */
> > > > +	fsl_chan_xfer_ld_queue(chan);
> > > > +
> > > > +	if (cookie > 0)
> > > > +		chan->common.completed_cookie = cookie;
> > > >  }
> > > >
> > > >  /**
> > > > @@ -954,11 +1082,15 @@ static enum dma_status fsl_tx_status(struct
> > > dma_chan *dchan,
> > > >  	enum dma_status ret;
> > > >  	unsigned long flags;
> > > >
> > > > -	spin_lock_irqsave(&chan->desc_lock, flags);
> > > >  	ret = dma_cookie_status(dchan, cookie, txstate);
> > > > +	if (ret == DMA_SUCCESS)
> > > > +		return ret;
> > > > +
> > > > +	spin_lock_irqsave(&chan->desc_lock, flags);
> > > > +	fsldma_cleanup_descriptor(chan);
> > > >  	spin_unlock_irqrestore(&chan->desc_lock, flags);
> > > >
> > > > -	return ret;
> > > > +	return dma_cookie_status(dchan, cookie, txstate);
> > > >  }
> > > >
> > > >  /*----------------------------------------------------------------
> ----
> > > --------*/
> > > > @@ -1035,52 +1167,19 @@ static irqreturn_t fsldma_chan_irq(int irq,
> > > void *data)
> > > >  static void dma_do_tasklet(unsigned long data)
> > > >  {
> > > >  	struct fsldma_chan *chan = (struct fsldma_chan *)data;
> > > > -	struct fsl_desc_sw *desc, *_desc;
> > > > -	LIST_HEAD(ld_cleanup);
> > > >  	unsigned long flags;
> > > >
> > > >  	chan_dbg(chan, "tasklet entry\n");
> > > >
> > > >  	spin_lock_irqsave(&chan->desc_lock, flags);
> > > >
> > > > -	/* update the cookie if we have some descriptors to cleanup
> */
> > > > -	if (!list_empty(&chan->ld_running)) {
> > > > -		dma_cookie_t cookie;
> > > > -
> > > > -		desc = to_fsl_desc(chan->ld_running.prev);
> > > > -		cookie = desc->async_tx.cookie;
> > > > -		dma_cookie_complete(&desc->async_tx);
> > > > -
> > > > -		chan_dbg(chan, "completed_cookie=%d\n", cookie);
> > > > -	}
> > > > -
> > > > -	/*
> > > > -	 * move the descriptors to a temporary list so we can drop
> the lock
> > > > -	 * during the entire cleanup operation
> > > > -	 */
> > > > -	list_splice_tail_init(&chan->ld_running, &ld_cleanup);
> > > > -
> > > >  	/* the hardware is now idle and ready for more */
> > > >  	chan->idle = true;
> > > >
> > > > -	/*
> > > > -	 * Start any pending transactions automatically
> > > > -	 *
> > > > -	 * In the ideal case, we keep the DMA controller busy while
> we go
> > > > -	 * ahead and free the descriptors below.
> > > > -	 */
> > > > -	fsl_chan_xfer_ld_queue(chan);
> > > > -	spin_unlock_irqrestore(&chan->desc_lock, flags);
> > > > -
> > > > -	/* Run the callback for each descriptor, in order */
> > > > -	list_for_each_entry_safe(desc, _desc, &ld_cleanup, node) {
> > > > +	/* Run all cleanup for this descriptor */
> > > > +	fsldma_cleanup_descriptor(chan);
> > > >
> > > > -		/* Remove from the list of transactions */
> > > > -		list_del(&desc->node);
> > > > -
> > > > -		/* Run all cleanup for this descriptor */
> > > > -		fsldma_cleanup_descriptor(chan, desc);
> > > > -	}
> > > > +	spin_unlock_irqrestore(&chan->desc_lock, flags);
> > > >
> > > >  	chan_dbg(chan, "tasklet exit\n");
> > > >  }
> > > > @@ -1262,6 +1361,7 @@ static int __devinit
> fsl_dma_chan_probe(struct
> > > fsldma_device *fdev,
> > > >  	spin_lock_init(&chan->desc_lock);
> > > >  	INIT_LIST_HEAD(&chan->ld_pending);
> > > >  	INIT_LIST_HEAD(&chan->ld_running);
> > > > +	INIT_LIST_HEAD(&chan->ld_completed);
> > > >  	chan->idle = true;
> > > >
> > > >  	chan->common.device = &fdev->common;
> > > > diff --git a/drivers/dma/fsldma.h b/drivers/dma/fsldma.h
> > > > index f5c3879..7ede908 100644
> > > > --- a/drivers/dma/fsldma.h
> > > > +++ b/drivers/dma/fsldma.h
> > > > @@ -140,6 +140,7 @@ struct fsldma_chan {
> > > >  	spinlock_t desc_lock;		/* Descriptor operation lock */
> > > >  	struct list_head ld_pending;	/* Link descriptors queue */
> > > >  	struct list_head ld_running;	/* Link descriptors queue */
> > > > +	struct list_head ld_completed;	/* Link descriptors queue
> */
> > > >  	struct dma_chan common;		/* DMA common channel */
> > > >  	struct dma_pool *desc_pool;	/* Descriptors pool */
> > > >  	struct device *dev;		/* Channel device */
> > > > --
> > > > 1.7.5.1
> > > >
> > > >
> >
> >
