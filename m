From: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: [PATCH 2/3] crypto: sahara: Add driver for SAHARA2 accelerator.
Date: Thu, 21 Feb 2013 15:35:25 +0100
Message-ID: <CACKLOr2ytmqB3NtPy6+0feGcGux7-PtR47RVYe1RMu6ftJXtqQ@mail.gmail.com>
References: <1361449162-27302-1-git-send-email-javier.martin@vista-silicon.com>
	<1361449162-27302-3-git-send-email-javier.martin@vista-silicon.com>
	<201302211313.46078.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: kernel@pengutronix.de, herbert@gondor.apana.org.au,
	davem@davemloft.net, tony@atomide.com, swarren@nvidia.com,
	shawn.guo@linaro.org, gcembed@gmail.com,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:62191 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab3BUOf1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Feb 2013 09:35:27 -0500
Received: by mail-we0-f179.google.com with SMTP id p43so5719839wea.38
        for <linux-crypto@vger.kernel.org>; Thu, 21 Feb 2013 06:35:25 -0800 (PST)
In-Reply-To: <201302211313.46078.arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Arnd,
thanks for your review.

On 21 February 2013 14:13, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 21 February 2013, Javier Martin wrote:
>> +
>> +struct sahara_dev {
>> +     struct device           *device;
>> +     void __iomem            *regs_base;
>> +     struct clk              *clk_ipg;
>> +     struct clk              *clk_ahb;
>> +
>> +     struct sahara_ctx       *ctx;
>> +     spinlock_t              lock;
>> +     struct crypto_queue     queue;
>> +     unsigned long           flags;
>> +
>> +     struct tasklet_struct   done_task;
>> +     struct tasklet_struct   queue_task;
>> +
>> +     struct sahara_hw_desc   *hw_desc[SAHARA_MAX_HW_DESC];
>> +     dma_addr_t              hw_phys_desc[SAHARA_MAX_HW_DESC];
>> +
>> +     u8                      *key_base;
>> +     dma_addr_t              key_phys_base;
>> +
>> +     u8                      *iv_base;
>> +     dma_addr_t              iv_phys_base;
>> +
>> +     struct sahara_hw_link   *hw_link[SAHARA_MAX_HW_LINK];
>> +     dma_addr_t              hw_phys_link[SAHARA_MAX_HW_LINK];
>> +
>> +     struct ablkcipher_request *req;
>> +     size_t                  total;
>> +     struct scatterlist      *in_sg;
>> +     unsigned int            nb_in_sg;
>> +     struct scatterlist      *out_sg;
>> +     unsigned int            nb_out_sg;
>> +
>> +     u32                     error;
>> +     struct timer_list       watchdog;
>> +};
>> +
>> +static struct sahara_dev *dev_ptr;
>
> Please remove this global device pointer, it should not be needed, since you
> can store the pointer in the context object.

Ok. Looks cleaner this way.


>
>> +#ifdef DEBUG
>> +
>> +static char *sahara_state[4] = { "Idle", "Busy", "Error", "HW Fault" };
>> +
>> +static void sahara_decode_status(struct sahara_dev *dev, unsigned int status)
>> +{
>> +     u8 state = SAHARA_STATUS_GET_STATE(status);
>
> You can simplify the code a lot if you replace the #ifdef around the function
> with an
>
>         if (!IS_ENBLED(DEBUG))
>                 return;
>
> at the start of the function. That will lead to gcc completely removing the
> code an everything referenced by it.
>

Great. Thank you for the tip.

>> +static void sahara_aes_done_task(unsigned long data)
>> +{
>> +     struct sahara_dev *dev = (struct sahara_dev *)data;
>> +     unsigned long flags;
>> +
>> +     dma_unmap_sg(dev->device, dev->out_sg, dev->nb_out_sg,
>> +             DMA_TO_DEVICE);
>> +     dma_unmap_sg(dev->device, dev->in_sg, dev->nb_in_sg,
>> +             DMA_FROM_DEVICE);
>> +
>> +     spin_lock_irqsave(&dev->lock, flags);
>> +     clear_bit(FLAGS_BUSY, &dev->flags);
>> +     spin_unlock_irqrestore(&dev->lock, flags);
>> +
>> +     dev->req->base.complete(&dev->req->base, dev->error);
>> +}
>
> Does dev->lock have to be irq-disabled? You don't seem to take it
> from an interrupt handler.
>
> Also, when you know that code is called without irqs enabled and
> you just want to disable them, you can use the cheaper spin_lock_irq()
> rather than spin_lock_irqsave().
>
> In short, use either spin_lock_irq or spin_lock here. When protecting
> against a tasklet, you will need spin_lock_bh.

You are right, dev->lock is only held by encrypt()/decrypt() callbacks
and some tasklets so spin_lock() and spin_lock_bh() seem suitable
here.

>> +
>> +void sahara_watchdog(unsigned long data)
>> +{
>> +     struct sahara_dev *dev = (struct sahara_dev *)data;
>> +     unsigned int err = sahara_read(dev, SAHARA_REG_ERRSTATUS);
>> +#ifdef DEBUG
>> +     unsigned int stat = sahara_read(dev, SAHARA_REG_STATUS);
>> +     sahara_decode_status(dev, stat);
>> +#endif
>
> When you kill off the #ifdef, you should move this sahara_read()
> call into the sahara_decode_status() function so it gets
> compiled conditionally.
>

All right.

>> +static struct platform_device_id sahara_platform_ids[] = {
>> +     { .name = "sahara-imx27" },
>> +     { /* sentinel */ }
>> +};
>> +MODULE_DEVICE_TABLE(platform, sahara_platform_ids);
>
> You are missing the of_device_ids here. We probably don't even
> need the platform_device_id list and can instead mandate that
> this is only used by platforms that are already converted to
> DT booting.
>
> Please also add a DT binding document for this driver that mentions
> the name and the resources that need to be provided.

Please, take a look at 0/3 to discuss about this matter.

Regards.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
