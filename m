From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH 12/12] drivers: PMC MSP71xx security engine driver
Date: Fri, 29 Jun 2007 13:50:34 +0400
Message-ID: <20070629095030.GA25077@2ka.mipt.ru>
References: <200706281949.l5SJnDdH029612@pasqua.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
	brian_oostenbrink@pmc-sierra.com, linux-crypto@vger.kernel.org,
	rod_sillett@pmc-sierra.com
To: Marc St-Jean <stjeanma@pmc-sierra.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:32876 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754841AbXF2JvY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Jun 2007 05:51:24 -0400
Content-Disposition: inline
In-Reply-To: <200706281949.l5SJnDdH029612@pasqua.pmc-sierra.bc.ca>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Marc.

On Thu, Jun 28, 2007 at 01:49:13PM -0600, Marc St-Jean (stjeanma@pmc-sierra.com) wrote:
> +static int
> +sec_init_queues(void)
> +{
> +	int i;
> +	struct workq *wq;
> +	struct compq *cq;
> +
> +	/*
> +	 * Allocate uncached space for hw_ptr values.
> +	 * NOTE: status ptr value is not currently used.
> +	 */
> +	status_ptr = dma_alloc_coherent(NULL, sizeof(int), &status_dma_addr,
> +					GFP_KERNEL);
> +	DBG_SEC("Allocated status ptr memory at 0x%p (0x%08x)\n",
> +			status_ptr, status_dma_addr);
> +	if (!status_ptr)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < HW_NR_COMP_QUEUES; i++) {
> +		void *base; /* slowpath virtual address of base */
> +		dma_addr_t base_dma_addr; /* DMA bus address of base */
> +
> +		base = dma_alloc_coherent(NULL, SEC_COMP_Q_SIZE,
> +				&base_dma_addr, GFP_KERNEL);
> +		DBG_SEC("Allocated CQ%d at 0x%p (0x%08x)\n",
> +			i, base, base_dma_addr);
> +		if (!base)
> +			return -ENOMEM;

This leaks allocations.

> +		cq = &sec_comp_queues[i];
> +
> +		cq->compq_lock = SPIN_LOCK_UNLOCKED;
> +		cq->cq_regs = &sec2_regs->cq[i];
> +		cq->base = base;
> +		cq->base_dma_addr = base_dma_addr;
> +		cq->out = 0;
> +
> +		cq->cq_regs->ofst_ptr = (unsigned int *)status_dma_addr;
> +		cq->cq_regs->base = (unsigned char *)cq->base_dma_addr;
> +		cq->cq_regs->size = SEC_COMP_Q_SIZE;
> +		cq->cq_regs->in = 0;
> +		cq->cq_regs->out = 0;
> +	}
> +
> +	for (i = 0; i < HW_NR_WORK_QUEUES; i++) {
> +		void *base; /* slowpath virtual address of base */
> +		dma_addr_t base_dma_addr; /* DMA bus address of base */
> +
> +		base = dma_alloc_coherent(NULL, SEC_WORK_Q_SIZE,
> +					&base_dma_addr, GFP_KERNEL);
> +		DBG_SEC("Allocated WQ%d at 0x%p (0x%08x)\n",
> +			i, base, base_dma_addr);
> +		if (!base)
> +			return -ENOMEM;

This too.

> +		wq = &sec_work_queues[i];
> +
> +		init_waitqueue_head(&wq->space_wait);
> +
> +		wq->workq_lock = SPIN_LOCK_UNLOCKED;
> +		wq->wq_regs = &sec2_regs->wq[i];
> +		wq->base = base;
> +		wq->base_dma_addr = base_dma_addr;
> +		wq->in = 0;
> +		wq->low_water = SEC_WORK_Q_SIZE >> 1; /* wake when half full */
> +
> +		wq->wq_regs->ofst_ptr = (unsigned int *)status_dma_addr;
> +		wq->wq_regs->base = (unsigned char *)wq->base_dma_addr;
> +		wq->wq_regs->size = SEC_WORK_Q_SIZE;
> +		wq->wq_regs->in = 0;
> +		wq->wq_regs->out = 0;
> +	}
> +	
> +	debug_dump_sec_regs();
> +
> +	return 0;
> +}
> +
> +static int __init
> +msp_secv2_init(void)

Shouldn't this and other places be marked as __devinit?

...

> +static irqreturn_t
> +msp_secv2_interrupt(int irq, void *dev_id)
> +{
> +	/*
> +	 * TODO: This clears all interrupts, and assumes
> +	 * that the cause was a completion queue update.
> +	 */
> +	unsigned int status;
> +
> +	status = sec2_regs->sis;
> +	sec2_regs->sis = /* ~status */ 0;
> +
> +	DBG_SEC("interrupt irq %d status was %x\n", irq, status);
> +
> +	poll_completion();
> +
> +	return IRQ_HANDLED;
> +}

Irqs can not be shared?

...

> +static int
> +poll_completion(void)
> +{
> +	struct compq *cq;
> +	int flags;
> +	int work_ct = 0;
> +	
> +	/*
> +	 * Check IPSEC engine register to see if at least one
> +	 * completion element is in completion queue.
> +	 */
> +	cq = sec_comp_queues;
> +	spin_lock_irqsave(&cq->compq_lock, flags);

This lock seems not to protect against desc_do_work() for example, but
there are register/mmio access under both - what is a locking rules
there?

-- 
	Evgeniy Polyakov
