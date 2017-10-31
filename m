From: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH RESEND 4/4] dma: caam: add dma memcpy driver
Date: Tue, 31 Oct 2017 17:34:23 +0530
Message-ID: <20171031120423.GS3187@localhost>
References: <20171030134654.13729-1-horia.geanta@nxp.com>
 <20171030134654.13729-5-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Douglass <dan.douglass@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Radu Alexe <radu.alexe@nxp.com>, dmaengine@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
        Rajiv Vishwakarma <rajiv.vishwakarma@nxp.com>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:35039 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751746AbdJaMBU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Oct 2017 08:01:20 -0400
Content-Disposition: inline
In-Reply-To: <20171030134654.13729-5-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 30, 2017 at 03:46:54PM +0200, Horia Geantă wrote:

> @@ -600,6 +600,23 @@ config ZX_DMA
>  	help
>  	  Support the DMA engine for ZTE ZX family platform devices.
>  
> +config CRYPTO_DEV_FSL_CAAM_DMA

File is sorted alphabetically

> +	tristate "CAAM DMA engine support"
> +	depends on CRYPTO_DEV_FSL_CAAM_JR
> +	default y

why should it be default?

> --- /dev/null
> +++ b/drivers/dma/caam_dma.c
> @@ -0,0 +1,444 @@
> +/*
> + * caam support for SG DMA
> + *
> + * Copyright 2016 Freescale Semiconductor, Inc
> + * Copyright 2017 NXP
> + */

that is interesting, no license text?

> +
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/interrupt.h>

why do you need this

> +#include <linux/slab.h>
> +#include <linux/debugfs.h>

i didn't see any debugfs code, why do you need this

alphabetical sort pls
> +
> +#include <linux/dmaengine.h>
> +#include "dmaengine.h"
> +
> +#include "../crypto/caam/regs.h"
> +#include "../crypto/caam/jr.h"
> +#include "../crypto/caam/error.h"
> +#include "../crypto/caam/intern.h"
> +#include "../crypto/caam/desc_constr.h"

ah that puts very hard assumptions on locations of the subsystems. Please do
not do that and move the required stuff into common header location in
include/

> +/* This is max chunk size of a DMA transfer. If a buffer is larger than this
> + * value it is internally broken into chunks of max CAAM_DMA_CHUNK_SIZE bytes
> + * and for each chunk a DMA transfer request is issued.
> + * This value is the largest number on 16 bits that is a multiple of 256 bytes
> + * (the largest configurable CAAM DMA burst size).
> + */

Kernel comments style we follow is:

/*
 * this is for
 * multi line comment
 */

Pls fix this in the file

> +#define CAAM_DMA_CHUNK_SIZE	65280
> +
> +struct caam_dma_sh_desc {

sh?

> +struct caam_dma_ctx {
> +	struct dma_chan chan;
> +	struct list_head node;
> +	struct device *jrdev;
> +	struct list_head submit_q;

call it pending

> +static struct dma_device *dma_dev;
> +static struct caam_dma_sh_desc *dma_sh_desc;
> +static LIST_HEAD(dma_ctx_list);

why do you need so many globals?

> +static dma_cookie_t caam_dma_tx_submit(struct dma_async_tx_descriptor *tx)
> +{
> +	struct caam_dma_edesc *edesc = NULL;
> +	struct caam_dma_ctx *ctx = NULL;
> +	dma_cookie_t cookie;
> +
> +	edesc = container_of(tx, struct caam_dma_edesc, async_tx);
> +	ctx = container_of(tx->chan, struct caam_dma_ctx, chan);
> +
> +	spin_lock_bh(&ctx->edesc_lock);

why _bh, i didnt see any irqs or tasklets here which is actually odd, so
what is going on

> +
> +	cookie = dma_cookie_assign(tx);
> +	list_add_tail(&edesc->node, &ctx->submit_q);
> +
> +	spin_unlock_bh(&ctx->edesc_lock);
> +
> +	return cookie;
> +}

we have a virtual channel wrapper where we do the same stuff as above, so
consider reusing that

> +static void caam_dma_memcpy_init_job_desc(struct caam_dma_edesc *edesc)
> +{
> +	u32 *jd = edesc->jd;
> +	u32 *sh_desc = dma_sh_desc->desc;
> +	dma_addr_t desc_dma = dma_sh_desc->desc_dma;
> +
> +	/* init the job descriptor */
> +	init_job_desc_shared(jd, desc_dma, desc_len(sh_desc), HDR_REVERSE);
> +
> +	/* set SEQIN PTR */
> +	append_seq_in_ptr(jd, edesc->src_dma, edesc->src_len, 0);
> +
> +	/* set SEQOUT PTR */
> +	append_seq_out_ptr(jd, edesc->dst_dma, edesc->dst_len, 0);
> +
> +#ifdef DEBUG
> +	print_hex_dump(KERN_ERR, "caam dma desc@" __stringify(__LINE__) ": ",
> +		       DUMP_PREFIX_ADDRESS, 16, 4, jd, desc_bytes(jd), 1);

ah this make you compile kernel. Consider the dynamic printk helpers for
printing

> +/* This function can be called in an interrupt context */
> +static void caam_dma_issue_pending(struct dma_chan *chan)
> +{
> +	struct caam_dma_ctx *ctx = container_of(chan, struct caam_dma_ctx,
> +						chan);
> +	struct caam_dma_edesc *edesc, *_edesc;
> +
> +	spin_lock_bh(&ctx->edesc_lock);
> +	list_for_each_entry_safe(edesc, _edesc, &ctx->submit_q, node) {
> +		if (caam_jr_enqueue(ctx->jrdev, edesc->jd,
> +				    caam_dma_done, edesc) < 0)

what does the caam_jr_enqueue() do?

> +static int caam_dma_jr_chan_bind(void)
> +{
> +	struct device *jrdev;
> +	struct caam_dma_ctx *ctx;
> +	int bonds = 0;
> +	int i;
> +
> +	for (i = 0; i < caam_jr_driver_probed(); i++) {
> +		jrdev = caam_jridx_alloc(i);
> +		if (IS_ERR(jrdev)) {
> +			pr_err("job ring device %d allocation failed\n", i);
> +			continue;
> +		}
> +
> +		ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
> +		if (!ctx) {
> +			caam_jr_free(jrdev);
> +			continue;

you want to continue?

> +	dma_dev->dev = dev;
> +	dma_dev->residue_granularity = DMA_RESIDUE_GRANULARITY_DESCRIPTOR;
> +	dma_cap_set(DMA_MEMCPY, dma_dev->cap_mask);
> +	dma_cap_set(DMA_PRIVATE, dma_dev->cap_mask);
> +	dma_dev->device_tx_status = dma_cookie_status;
> +	dma_dev->device_issue_pending = caam_dma_issue_pending;
> +	dma_dev->device_prep_dma_memcpy = caam_dma_prep_memcpy;
> +	dma_dev->device_free_chan_resources = caam_dma_free_chan_resources;
> +
> +	err = dma_async_device_register(dma_dev);
> +	if (err) {
> +		dev_err(dev, "Failed to register CAAM DMA engine\n");
> +		goto jr_bind_err;
> +	}
> +
> +	dev_info(dev, "caam dma support with %d job rings\n", bonds);

that is very noisy

> +MODULE_LICENSE("Dual BSD/GPL");
> +MODULE_DESCRIPTION("NXP CAAM support for SG DMA");
> +MODULE_AUTHOR("NXP Semiconductors");

No MODULE_ALIAS, how did you load the driver

-- 
~Vinod
