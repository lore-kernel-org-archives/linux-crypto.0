From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/3] crypto: sahara: Add driver for SAHARA2 accelerator.
Date: Thu, 21 Feb 2013 13:13:45 +0000
Message-ID: <201302211313.46078.arnd@arndb.de>
References: <1361449162-27302-1-git-send-email-javier.martin@vista-silicon.com> <1361449162-27302-3-git-send-email-javier.martin@vista-silicon.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: kernel@pengutronix.de, herbert@gondor.apana.org.au,
	davem@davemloft.net, tony@atomide.com, swarren@nvidia.com,
	shawn.guo@linaro.org, gcembed@gmail.com,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
To: Javier Martin <javier.martin@vista-silicon.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:61773 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab3BUNOF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Feb 2013 08:14:05 -0500
In-Reply-To: <1361449162-27302-3-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thursday 21 February 2013, Javier Martin wrote:
> +
> +struct sahara_dev {
> +	struct device		*device;
> +	void __iomem		*regs_base;
> +	struct clk		*clk_ipg;
> +	struct clk		*clk_ahb;
> +
> +	struct sahara_ctx	*ctx;
> +	spinlock_t		lock;
> +	struct crypto_queue	queue;
> +	unsigned long		flags;
> +
> +	struct tasklet_struct	done_task;
> +	struct tasklet_struct	queue_task;
> +
> +	struct sahara_hw_desc	*hw_desc[SAHARA_MAX_HW_DESC];
> +	dma_addr_t		hw_phys_desc[SAHARA_MAX_HW_DESC];
> +
> +	u8			*key_base;
> +	dma_addr_t		key_phys_base;
> +
> +	u8			*iv_base;
> +	dma_addr_t		iv_phys_base;
> +
> +	struct sahara_hw_link	*hw_link[SAHARA_MAX_HW_LINK];
> +	dma_addr_t		hw_phys_link[SAHARA_MAX_HW_LINK];
> +
> +	struct ablkcipher_request *req;
> +	size_t			total;
> +	struct scatterlist	*in_sg;
> +	unsigned int		nb_in_sg;
> +	struct scatterlist	*out_sg;
> +	unsigned int		nb_out_sg;
> +
> +	u32			error;
> +	struct timer_list	watchdog;
> +};
> +
> +static struct sahara_dev *dev_ptr;

Please remove this global device pointer, it should not be needed, since you
can store the pointer in the context object.


> +#ifdef DEBUG
> +
> +static char *sahara_state[4] = { "Idle", "Busy", "Error", "HW Fault" };
> +
> +static void sahara_decode_status(struct sahara_dev *dev, unsigned int status)
> +{
> +	u8 state = SAHARA_STATUS_GET_STATE(status);

You can simplify the code a lot if you replace the #ifdef around the function
with an

	if (!IS_ENBLED(DEBUG))
		return;

at the start of the function. That will lead to gcc completely removing the
code an everything referenced by it.


> +static void sahara_aes_done_task(unsigned long data)
> +{
> +	struct sahara_dev *dev = (struct sahara_dev *)data;
> +	unsigned long flags;
> +
> +	dma_unmap_sg(dev->device, dev->out_sg, dev->nb_out_sg,
> +		DMA_TO_DEVICE);
> +	dma_unmap_sg(dev->device, dev->in_sg, dev->nb_in_sg,
> +		DMA_FROM_DEVICE);
> +
> +	spin_lock_irqsave(&dev->lock, flags);
> +	clear_bit(FLAGS_BUSY, &dev->flags);
> +	spin_unlock_irqrestore(&dev->lock, flags);
> +
> +	dev->req->base.complete(&dev->req->base, dev->error);
> +}

Does dev->lock have to be irq-disabled? You don't seem to take it
from an interrupt handler.

Also, when you know that code is called without irqs enabled and
you just want to disable them, you can use the cheaper spin_lock_irq()
rather than spin_lock_irqsave().

In short, use either spin_lock_irq or spin_lock here. When protecting
against a tasklet, you will need spin_lock_bh.

> +
> +void sahara_watchdog(unsigned long data)
> +{
> +	struct sahara_dev *dev = (struct sahara_dev *)data;
> +	unsigned int err = sahara_read(dev, SAHARA_REG_ERRSTATUS);
> +#ifdef DEBUG
> +	unsigned int stat = sahara_read(dev, SAHARA_REG_STATUS);
> +	sahara_decode_status(dev, stat);
> +#endif

When you kill off the #ifdef, you should move this sahara_read()
call into the sahara_decode_status() function so it gets
compiled conditionally.

> +static struct platform_device_id sahara_platform_ids[] = {
> +	{ .name = "sahara-imx27" },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(platform, sahara_platform_ids);

You are missing the of_device_ids here. We probably don't even
need the platform_device_id list and can instead mandate that
this is only used by platforms that are already converted to
DT booting.

Please also add a DT binding document for this driver that mentions
the name and the resources that need to be provided.

	Arnd
