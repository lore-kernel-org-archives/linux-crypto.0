From: "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: Re: [PATCH v2 3/4] fsl-dma: change the release process of dma
 descriptor
Date: Wed, 11 Jul 2012 09:30:58 -0700
Message-ID: <20120711163058.GD17539@ovro.caltech.edu>
References: <1341997285-18459-1-git-send-email-qiang.liu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	Vinod Koul <vinod.koul@intel.com>,
	herbert@gondor.hengli.com.au,
	Dan Williams <dan.j.williams@intel.com>, davem@davemloft.net
To: Qiang Liu <qiang.liu@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:37683 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756418Ab2GKQbD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Jul 2012 12:31:03 -0400
Content-Disposition: inline
In-Reply-To: <1341997285-18459-1-git-send-email-qiang.liu@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 11, 2012 at 05:01:25PM +0800, Qiang Liu wrote:
> Modify the release process of dma descriptor for avoiding exception when
> enable config NET_DMA, release dma descriptor from 1st to last second, the
> last descriptor which is reserved in current descriptor register may not be
> completed, race condition will be raised if free current descriptor.
> 
> A race condition which is raised when use both of talitos and dmaengine to
> offload xor is because napi scheduler (NET_DMA is enabled) will sync all
> pending requests in dma channels, it affects the process of raid operations.
> The descriptor is freed which is submitted just now, but async_tx must check
> whether this depend tx descriptor is acked, there are poison contents in the
> invalid address, then BUG_ON() is thrown, so this descriptor will be freed
> in the next time.
> 

This patch seems to be covering up a bug in the driver, rather than
actually fixing it.

When it was written, it was expected that dma_do_tasklet() would run
only when the controller was idle.

> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Li Yang <leoli@freescale.com>
> Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
> ---
>  drivers/dma/fsldma.c |   15 ++++++++++++---
>  1 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
> index 4f2f212..0ba3e40 100644
> --- a/drivers/dma/fsldma.c
> +++ b/drivers/dma/fsldma.c
> @@ -1035,14 +1035,22 @@ static irqreturn_t fsldma_chan_irq(int irq, void *data)
>  static void dma_do_tasklet(unsigned long data)
>  {
>  	struct fsldma_chan *chan = (struct fsldma_chan *)data;
> -	struct fsl_desc_sw *desc, *_desc;
> +	struct fsl_desc_sw *desc, *_desc, *prev = NULL;
>  	LIST_HEAD(ld_cleanup);
>  	unsigned long flags;
> +	dma_addr_t curr_phys = get_cdar(chan);
> 
>  	chan_dbg(chan, "tasklet entry\n");
> 
>  	spin_lock_irqsave(&chan->desc_lock, flags);
> 
> +	/* find the descriptor which is already completed */
> +	list_for_each_entry_safe(desc, _desc, &chan->ld_running, node) {
> +		if (prev && desc->async_tx.phys == curr_phys)
> +			break;
> +		prev = desc;
> +	}
> +

If the DMA controller was still busy processing transactions, you should
have gotten the printout "irq: controller not idle!" from
fsldma_chan_irq() just before it scheduled the dma_do_tasklet() to run.
If you did not get this printout, how was dma_do_tasklet() entered with
the controller still busy? I don't understand how it can happen.

If you test without your spin_lock_bh() and spin_unlock_bh() conversion
patch, do you still hit the error?

What happens if a user submits exactly one DMA transaction, and then
leaves the system idle? The callback for the last descriptor in the
chain will never get run, right? That's a bug.

>  	/* update the cookie if we have some descriptors to cleanup */
>  	if (!list_empty(&chan->ld_running)) {
>  		dma_cookie_t cookie;
> @@ -1058,13 +1066,14 @@ static void dma_do_tasklet(unsigned long data)
>  	 * move the descriptors to a temporary list so we can drop the lock
>  	 * during the entire cleanup operation
>  	 */
> -	list_splice_tail_init(&chan->ld_running, &ld_cleanup);
> +	list_cut_position(&ld_cleanup, &chan->ld_running, &prev->node);
> 
>  	/* the hardware is now idle and ready for more */
>  	chan->idle = true;
> 
>  	/*
> -	 * Start any pending transactions automatically
> +	 * Start any pending transactions automatically if current descriptor
> +	 * list is completed
>  	 *
>  	 * In the ideal case, we keep the DMA controller busy while we go
>  	 * ahead and free the descriptors below.
> --
> 1.7.5.1
> 
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
