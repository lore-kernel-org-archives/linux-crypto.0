From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Subject: Re: [PATCH 1/2] crypto: Add Imagination Technologies hw hash accelerator
Date: Mon, 10 Nov 2014 17:09:52 +0200
Message-ID: <5460D540.6070205@mentor.com>
References: <1415621455-10468-1-git-send-email-james.hartley@imgtec.com> <1415621455-10468-2-git-send-email-james.hartley@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <devicetree@vger.kernel.org>, <pawel.moll@arm.com>,
	<mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
	<galak@codeaurora.org>, <abrestic@chromium.org>,
	<ezequiel.garcia@imgtec.com>
To: James Hartley <james.hartley@imgtec.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<grant.likely@linaro.org>, <robh+dt@kernel.org>,
	<akpm@linux-foundation.org>, <gregkh@linuxfoundation.org>,
	<joe@perches.com>, <mchehab@osg.samsung.com>, <crope@iki.fi>,
	<jg1.han@samsung.com>, <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:53262 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbaKJPKB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Nov 2014 10:10:01 -0500
In-Reply-To: <1415621455-10468-2-git-send-email-james.hartley@imgtec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello James,

On 10.11.2014 14:10, James Hartley wrote:
> This adds support for the Imagination Technologies hash
> accelerator that provides hardware acceleration for
> SHA1 SHA224 SHA256 and MD5 Hashes.
> 
> Signed-off-by: James Hartley <james.hartley@imgtec.com>
> ---

[snip]

> diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
> new file mode 100644
> index 0000000..e58c81a
> --- /dev/null
> +++ b/drivers/crypto/img-hash.c
> @@ -0,0 +1,1048 @@
> +/*
> +* Copyright (c) 2014 Imagination Technologies
> +* Author:  Will Thomas
> +*
> +* This program is free software; you can redistribute it and/or modify
> +* it under the terms of the GNU General Public License version 2 as published
> +* by the Free Software Foundation.
> +*
> +*	Interface structure taken from omap-sham driver
> +*/
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/clk.h>
> +#include <linux/platform_device.h>
> +#include <linux/io.h>
> +#include <linux/scatterlist.h>
> +#include <linux/interrupt.h>
> +#include <linux/of_device.h>
> +#include <crypto/sha.h>
> +#include <crypto/md5.h>
> +#include <crypto/internal/hash.h>
> +
> +#define MD5_BLOCK_SIZE			64
> +
> +#define CR_RESET			0
> +#define CR_RESET_SET			1
> +#define CR_RESET_UNSET			0
> +
> +#define CR_MESSAGE_LENGTH_H		0x4
> +#define CR_MESSAGE_LENGTH_L		0x8
> +
> +#define	CR_CONTROL			0xc

Tab symbol instead of space after #define.

> +#define CR_CONTROL_BYTE_ORDER_3210	0
> +#define CR_CONTROL_BYTE_ORDER_0123	1
> +#define CR_CONTROL_BYTE_ORDER_2310	2
> +#define CR_CONTROL_BYTE_ORDER_1032	3
> +#define CR_CONTROL_ALGO_MD5	0
> +#define CR_CONTROL_ALGO_SHA1	1
> +#define CR_CONTROL_ALGO_SHA224	2
> +#define CR_CONTROL_ALGO_SHA256	3
> +

[snip]

> +static int img_hash_hw_init(struct img_hash_dev *hdev)
> +{
> +	unsigned long long nbits;
> +	u32 u, l;
> +
> +	clk_prepare_enable(hdev->iclk);

This call may fail, please add a check.

> +
> +	img_hash_write(hdev, CR_RESET, CR_RESET_SET);
> +	img_hash_write(hdev, CR_RESET, CR_RESET_UNSET);
> +	img_hash_write(hdev, CR_INTENAB, CR_INT_NEW_RESULTS_SET);
> +
> +	nbits = (hdev->req->nbytes << 3);
> +	u = nbits >> 32;
> +	l = nbits;
> +	img_hash_write(hdev, CR_MESSAGE_LENGTH_H, u);
> +	img_hash_write(hdev, CR_MESSAGE_LENGTH_L, l);
> +
> +	if (!(DRIVER_FLAGS_INIT & hdev->flags)) {
> +		hdev->flags |= DRIVER_FLAGS_INIT;
> +		hdev->err = 0;
> +	}
> +	pr_debug("hw initialized, nbits: %llx\n", nbits);
> +	return 0;
> +}
> +

[snip]

> +static void img_hash_xmit_dma(struct img_hash_dev *hdev, struct scatterlist *sg)
> +{
> +	struct dma_async_tx_descriptor *desc;
> +	struct img_hash_request_ctx *ctx = ahash_request_ctx(hdev->req);
> +
> +	ctx->dma_ct = dma_map_sg(hdev->dev, sg, 1, DMA_MEM_TO_DEV);
> +	if (ctx->dma_ct == 0) {
> +		dev_err(hdev->dev, "Invalid DMA sg\n");
> +		hdev->err = -EINVAL;
> +		return;
> +	}
> +
> +	desc = dmaengine_prep_slave_sg(hdev->dma_lch,
> +					sg,
> +					ctx->dma_ct,
> +					DMA_MEM_TO_DEV,
> +					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
> +	if (!desc) {
> +		dev_err(hdev->dev, "Null DMA descriptor\n");
> +		hdev->err = -EINVAL;

Missing dma_unmap_sg()

> +		return;
> +	}
> +	desc->callback = img_hash_dma_callback;
> +	desc->callback_param = hdev;
> +	dmaengine_submit(desc);
> +	dma_async_issue_pending(hdev->dma_lch);
> +}
> +
> +static void img_hash_dma_task(unsigned long d)
> +{
> +	struct img_hash_dev *hdev = (struct img_hash_dev *) d;
> +	struct img_hash_request_ctx *ctx = ahash_request_ctx(hdev->req);
> +	char *addr;
> +	size_t nbytes, bleft, bsend, len, tbc;
> +	struct scatterlist tsg;
> +
> +	if (!ctx->sg)
> +		return;
> +	if (!hdev)
> +		pr_err("invalid ptr for hash device");
> +
> +	addr = sg_virt(ctx->sg);
> +	nbytes = ctx->sg->length - ctx->offset;
> +	bleft = nbytes % 4;
> +	bsend = (nbytes / 4);
> +
> +
> +	if (bsend) {
> +		sg_init_one(&tsg, addr + ctx->offset, bsend * 4);
> +		img_hash_xmit_dma(hdev, &tsg);

What happens, if img_hash_xmit_dma() fails?

> +		ctx->sent += bsend * 4;
> +	}
> +
> +	if (bleft) {
> +		ctx->bufcnt = sg_pcopy_to_buffer(ctx->sgfirst, ctx->nents,
> +					ctx->buffer, bleft, ctx->sent);
> +		tbc = 0;
> +		ctx->sg = sg_next(ctx->sg);
> +		while (ctx->sg && (ctx->bufcnt < 4)) {
> +			len = ctx->sg->length;
> +			if (likely(len > (4 - ctx->bufcnt)))
> +				len = 4 - ctx->bufcnt;
> +			tbc = sg_pcopy_to_buffer(ctx->sgfirst, ctx->nents,
> +					ctx->buffer + ctx->bufcnt, len,
> +					ctx->sent + ctx->bufcnt);
> +			ctx->bufcnt += tbc;
> +			if (tbc >= ctx->sg->length) {
> +				ctx->sg = sg_next(ctx->sg);
> +				tbc = 0;
> +			}
> +		}
> +
> +		ctx->sent += ctx->bufcnt;
> +		ctx->offset = tbc;
> +
> +		if (!bsend)
> +			img_hash_dma_callback(hdev);
> +	} else {
> +		ctx->offset = 0;
> +		ctx->sg = sg_next(ctx->sg);
> +
> +	}
> +}
> +
> +static int img_hash_dma_init(struct img_hash_dev *hdev)
> +{
> +	int err = -EINVAL;
> +
> +	hdev->dma_lch = dma_request_slave_channel(hdev->dev, "tx");
> +	if (!hdev->dma_lch) {
> +		dev_err(hdev->dev, "Couldn't aquire a slave DMA channel.\n");
> +		return -EBUSY;
> +	}
> +	hdev->dma_conf.direction = DMA_MEM_TO_DEV;
> +	hdev->dma_conf.dst_addr = hdev->bus_addr;
> +	hdev->dma_conf.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
> +	hdev->dma_conf.dst_maxburst = 16;
> +	hdev->dma_conf.device_fc = false;
> +
> +	err = dmaengine_slave_config(hdev->dma_lch,  &hdev->dma_conf);
> +	if (err) {
> +		dev_err(hdev->dev, "Couldn't configure DMA slave.\n");
> +		return err;

Missing dma_release_channel(hdev->dma_lch);

> +	}
> +	return 0;
> +}
> +
> +static const struct of_device_id img_hash_match[] = {
> +	{ .compatible = "img,img-hash-accelerator-rev1" },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(of, img_hash_match)
> +
> +static int img_hash_probe(struct platform_device *pdev)
> +{
> +	struct img_hash_dev *hdev;
> +	struct device *dev = &pdev->dev;
> +	struct resource *hash_res;
> +	int err;
> +
> +	hdev = devm_kzalloc(dev, sizeof(*hdev), GFP_KERNEL);
> +	if (hdev == NULL) {
> +		err = -ENOMEM;
> +		goto sha_dev_err;
> +	}
> +	spin_lock_init(&hdev->lock);
> +
> +	hdev->dev = dev;
> +
> +	platform_set_drvdata(pdev, hdev);
> +
> +	INIT_LIST_HEAD(&hdev->list);
> +
> +	tasklet_init(&hdev->done_task, img_hash_done_task,
> +		(unsigned long) hdev);
> +	tasklet_init(&hdev->dma_task, img_hash_dma_task,
> +		(unsigned long) hdev);
> +
> +	crypto_init_queue(&hdev->queue, IMG_HASH_QUEUE_LENGTH);
> +
> +	hash_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!hash_res) {
> +		dev_err(dev, "no MEM resource info\n");
> +		err = -ENODEV;
> +		goto res_err;
> +	}
> +
> +	hdev->io_base = devm_ioremap_resource(dev, hash_res);
> +	if (!hdev->io_base) {
> +		dev_err(dev, "can't ioremap\n");
> +		err = -ENOMEM;
> +		goto hash_io_err;
> +	}
> +
> +	hash_res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	if (!hash_res) {
> +		dev_err(dev, "no MEM resource info\n");
> +		err = -ENODEV;
> +		goto res_err;
> +	}
> +	hdev->bus_addr = hash_res->start;
> +	hdev->cpu_addr = devm_ioremap_resource(dev, hash_res);
> +
> +	hdev->irq = platform_get_irq(pdev, 0);
> +	if (hdev->irq < 0) {
> +		dev_err(dev, "no IRQ resource info\n");
> +		err = hdev->irq;
> +		goto res_err;
> +	}
> +
> +	err = devm_request_irq(dev, hdev->irq, img_irq_handler, 0,
> +			"img-hash-accelerator-rev1", hdev);
> +	if (err) {
> +		dev_err(dev, "unable to request img-hash-accelerator irq\n");
> +		goto res_err;
> +	}
> +	dev_info(dev, "using IRQ channel %d\n", hdev->irq);
> +
> +	hdev->iclk = devm_clk_get(&pdev->dev, "hash_clk");
> +	if (IS_ERR(hdev->iclk)) {
> +		dev_err(dev, "clock initialization failed.\n");
> +		err = PTR_ERR(hdev->iclk);
> +		goto clk_err;

goto res_err is good enough, no need to introduce another label.

> +	}
> +
> +	err = img_hash_dma_init(hdev);
> +	if (err)
> +		goto err_dma;
> +
> +	dev_info(dev, "using %s for DMA transfers\n",
> +			dma_chan_name(hdev->dma_lch));
> +
> +	spin_lock(&img_hash.lock);
> +	list_add_tail(&hdev->list, &img_hash.dev_list);
> +	spin_unlock(&img_hash.lock);
> +
> +	err = img_register_algs(hdev);
> +	if (err)
> +		goto err_algs;
> +	dev_info(dev, "data bus: 0x%x;\tsize:0x%x\n", hdev->bus_addr, 0x4);
> +	dev_info(dev, "Img MD5/SHA1/SHA224/SHA256 Hardware accelerator initialized\n");
> +
> +	return 0;
> +
> +err_algs:
> +	spin_lock(&img_hash.lock);
> +	list_del(&hdev->list);
> +	spin_unlock(&img_hash.lock);
> +	dma_release_channel(hdev->dma_lch);
> +err_dma:
> +	iounmap(hdev->io_base);

Mixing of devm_* resource initialization and commodity resource release
leads to double decrement of clock usage count reference.

> +hash_io_err:
> +	clk_put(hdev->iclk);

Same as above.

> +clk_err:
> +res_err:
> +	tasklet_kill(&hdev->done_task);

What is about killing &hdev->dma_task?

> +sha_dev_err:
> +	dev_err(dev, "initialization failed.\n");
> +	return err;
> +}
> +
> +static void img_hash_dma_cleanup(struct img_hash_dev *hdev)
> +{
> +	dma_release_channel(hdev->dma_lch);
> +}

The function is used only once in img_hash_remove(), probably it can be
removed.

> +
> +static int img_hash_remove(struct platform_device *pdev)
> +{
> +	static struct img_hash_dev *hdev;
> +
> +	hdev = platform_get_drvdata(pdev);
> +	if (!hdev)
> +		return -ENODEV;
> +	spin_lock(&img_hash.lock);
> +	list_del(&hdev->list);
> +	spin_unlock(&img_hash.lock);
> +
> +	img_unregister_algs(hdev);
> +
> +	tasklet_kill(&hdev->done_task);
> +	tasklet_kill(&hdev->dma_task);
> +	img_hash_dma_cleanup(hdev);
> +
> +	iounmap(hdev->io_base);

Same as above, devres iounmap() is good enough.

> +	return 0;
> +}
> +
> +static struct platform_driver img_hash_driver = {
> +	.probe		= img_hash_probe,
> +	.remove		= img_hash_remove,
> +	.driver		= {
> +		.name	= "img-hash-accelerator-rev1",
> +		.of_match_table	= of_match_ptr(img_hash_match),
> +	}
> +};
> +module_platform_driver(img_hash_driver);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("Imgtec SHA1/224/256 & MD5 hw accelerator driver");
> +MODULE_AUTHOR("Will Thomas.");
> +
> 

Also please check the whole patch for DOS line endings.

--
With best wishes,
Vladimir
