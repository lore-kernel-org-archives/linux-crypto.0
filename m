From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH] crypto: ccp - Register the CCP as a DMA resource
Date: Mon, 4 Apr 2016 16:47:25 -0500
Message-ID: <5702E0ED.4050708@amd.com>
References: <20160404205035.6295.12620.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>
To: Gary R Hook <gary.hook@amd.com>, <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0064.outbound.protection.outlook.com ([157.56.110.64]:3908
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751690AbcDDWC7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Apr 2016 18:02:59 -0400
In-Reply-To: <20160404205035.6295.12620.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 04/04/2016 03:50 PM, Gary R Hook wrote:
> The CCP has the ability to provide DMA services to the
> kernel using pass-through mode of the device. Register
> these services as general purpose DMA channels.
> ---

You're missing a cc: to David Miller, be sure to check who
should be included when emailing.

>  drivers/crypto/ccp/Kconfig         |    1 
>  drivers/crypto/ccp/Makefile        |    6 
>  drivers/crypto/ccp/ccp-dev-v3.c    |   13 +
>  drivers/crypto/ccp/ccp-dev.h       |   49 ++
>  drivers/crypto/ccp/ccp-dmaengine.c |  718 ++++++++++++++++++++++++++++++++++++
>  drivers/crypto/ccp/ccp-ops.c       |   77 ++++
>  6 files changed, 856 insertions(+), 8 deletions(-)
>  create mode 100644 drivers/crypto/ccp/ccp-dmaengine.c

For some reason the diffstat is missing include/linux/ccp.h

> 
> diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
> index 6e37845..79cabfb 100644
> --- a/drivers/crypto/ccp/Kconfig
> +++ b/drivers/crypto/ccp/Kconfig
> @@ -3,6 +3,7 @@ config CRYPTO_DEV_CCP_DD
>  	depends on CRYPTO_DEV_CCP
>  	default m
>  	select HW_RANDOM
> +	select DMA_ENGINE
>  	select CRYPTO_SHA1
>  	select CRYPTO_SHA256
>  	help
> diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
> index b750592..ee4d274 100644
> --- a/drivers/crypto/ccp/Makefile
> +++ b/drivers/crypto/ccp/Makefile
> @@ -1,5 +1,9 @@
>  obj-$(CONFIG_CRYPTO_DEV_CCP_DD) += ccp.o
> -ccp-objs := ccp-dev.o ccp-ops.o ccp-dev-v3.o ccp-platform.o
> +ccp-objs := ccp-dev.o \
> +	    ccp-ops.o \
> +	    ccp-dev-v3.o \
> +	    ccp-platform.o \
> +	    ccp-dmaengine.o
>  ccp-$(CONFIG_PCI) += ccp-pci.o
>  
>  obj-$(CONFIG_CRYPTO_DEV_CCP_CRYPTO) += ccp-crypto.o
> diff --git a/drivers/crypto/ccp/ccp-dev-v3.c b/drivers/crypto/ccp/ccp-dev-v3.c
> index 7d5eab4..65babf4 100644
> --- a/drivers/crypto/ccp/ccp-dev-v3.c
> +++ b/drivers/crypto/ccp/ccp-dev-v3.c
> @@ -290,7 +290,7 @@ static int ccp_init(struct ccp_device *ccp)
>  	struct device *dev = ccp->dev;
>  	struct ccp_cmd_queue *cmd_q;
>  	struct dma_pool *dma_pool;
> -	char dma_pool_name[MAX_DMAPOOL_NAME_LEN];
> +	char dma_pool_name[MAX_DMA_NAME_LEN];
>  	unsigned int qmr, qim, i;
>  	int ret;
>  
> @@ -408,11 +408,19 @@ static int ccp_init(struct ccp_device *ccp)
>  
>  	ccp_add_device(ccp);
>  
> +	/* Register the DMA engine support */
> +	ret = ccp_dmaengine_register(ccp);
> +	if (ret)
> +		goto e_hwrng;
> +

This either needs to be before ccp_add_device() or you need to
remove the device in the error path.

>  	/* Enable interrupts */
>  	iowrite32(qim, ccp->io_regs + IRQ_MASK_REG);
>  
>  	return 0;
>  
> +e_hwrng:
> +	hwrng_unregister(&ccp->hwrng);
> +
>  e_kthread:
>  	for (i = 0; i < ccp->cmd_q_count; i++)
>  		if (ccp->cmd_q[i].kthread)
> @@ -436,6 +444,9 @@ static void ccp_destroy(struct ccp_device *ccp)
>  	/* Remove this device from the list of available units first */
>  	ccp_del_device(ccp);
>  
> +	/* Unregister the DMA engine */
> +	ccp_dmaengine_unregister(ccp);
> +
>  	/* Unregister the RNG */
>  	hwrng_unregister(&ccp->hwrng);
>  
> diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
> index 7745d0b..aa447a7 100644
> --- a/drivers/crypto/ccp/ccp-dev.h
> +++ b/drivers/crypto/ccp/ccp-dev.h
> @@ -22,9 +22,12 @@
>  #include <linux/dmapool.h>
>  #include <linux/hw_random.h>
>  #include <linux/bitops.h>
> +#include <linux/interrupt.h>
> +#include <linux/irqreturn.h>
> +#include <linux/dmaengine.h>
>  
>  #define MAX_CCP_NAME_LEN		16
> -#define MAX_DMAPOOL_NAME_LEN		32
> +#define MAX_DMA_NAME_LEN		40

Any reason this needed to be increased to 40? Though this change
may not be needed based on comment below.

>  
>  #define MAX_HW_QUEUES			5
>  #define MAX_CMD_QLEN			100
> @@ -167,6 +170,39 @@ extern struct ccp_vdata ccpv3;
>  struct ccp_device;
>  struct ccp_cmd;
>  
> +struct ccp_dma_cmd {
> +	struct list_head entry;
> +
> +	struct ccp_cmd ccp_cmd;
> +};
> +
> +struct ccp_dma_desc {
> +	struct list_head entry;
> +
> +	struct ccp_device *ccp;
> +
> +	struct list_head pending;
> +	struct list_head active;
> +
> +	enum dma_status status;
> +	struct dma_async_tx_descriptor tx_desc;
> +	size_t len;
> +};
> +
> +struct ccp_dma_chan {
> +	struct ccp_device *ccp;
> +
> +	spinlock_t lock;
> +	struct list_head pending;
> +	struct list_head active;
> +	struct list_head complete;
> +
> +	struct tasklet_struct cleanup_tasklet;
> +
> +	enum dma_status status;
> +	struct dma_chan dma_chan;
> +};
> +
>  struct ccp_cmd_queue {
>  	struct ccp_device *ccp;
>  
> @@ -261,6 +297,14 @@ struct ccp_device {
>  	unsigned int hwrng_retries;
>  
>  	/*
> +	 * Support for the CCP DMA capabilities
> +	 */
> +	struct dma_device dma_dev;
> +	struct ccp_dma_chan *ccp_dma_chan;
> +	struct kmem_cache *dma_cmd_cache;
> +	struct kmem_cache *dma_desc_cache;
> +
> +	/*
>  	 * A counter used to generate job-ids for cmds submitted to the CCP
>  	 */
>  	atomic_t current_id ____cacheline_aligned;
> @@ -418,4 +462,7 @@ int ccp_cmd_queue_thread(void *data);
>  
>  int ccp_run_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd);
>  
> +int ccp_dmaengine_register(struct ccp_device *ccp);
> +void ccp_dmaengine_unregister(struct ccp_device *ccp);
> +
>  #endif
> diff --git a/drivers/crypto/ccp/ccp-dmaengine.c b/drivers/crypto/ccp/ccp-dmaengine.c
> new file mode 100644
> index 0000000..241ad8a
> --- /dev/null
> +++ b/drivers/crypto/ccp/ccp-dmaengine.c
> @@ -0,0 +1,718 @@
> +/*
> + * AMD Cryptographic Coprocessor (CCP) driver
> + *
> + * Copyright (C) 2015 Advanced Micro Devices, Inc.

2016.

> + *
> + * Author: Tom Lendacky <thomas.lendacky@amd.com>

This should be your name.

> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +

...

> +int ccp_dmaengine_register(struct ccp_device *ccp)
> +{
> +	struct ccp_dma_chan *chan;
> +	struct dma_device *dma_dev = &ccp->dma_dev;
> +	struct dma_chan *dma_chan;
> +	char dma_cache_name[MAX_DMA_NAME_LEN];

This can't be a local function variable.  You'll need to allocate
memory for the cache names and track them (or use devm_kasprintf).

> +	unsigned int i;
> +	int ret;
> +
> +	ccp->ccp_dma_chan = devm_kcalloc(ccp->dev, ccp->cmd_q_count,
> +					 sizeof(*(ccp->ccp_dma_chan)),
> +					 GFP_KERNEL);
> +	if (!ccp->ccp_dma_chan)
> +		return -ENOMEM;
> +
> +	snprintf(dma_cache_name, sizeof(dma_cache_name),
> +		 "%s-dmaengine-cmd-cache", ccp->name);
> +	ccp->dma_cmd_cache = kmem_cache_create(dma_cache_name,
> +					       sizeof(struct ccp_dma_cmd),
> +					       sizeof(void *),
> +					       SLAB_HWCACHE_ALIGN, NULL);
> +	if (!ccp->dma_cmd_cache)
> +		return -ENOMEM;
> +
> +	snprintf(dma_cache_name, sizeof(dma_cache_name),
> +		 "%s-dmaengine-desc-cache", ccp->name);
> +	ccp->dma_desc_cache = kmem_cache_create(dma_cache_name,
> +						sizeof(struct ccp_dma_desc),
> +						sizeof(void *),
> +						SLAB_HWCACHE_ALIGN, NULL);
> +	if (!ccp->dma_desc_cache) {
> +		ret = -ENOMEM;
> +		goto err_cache;
> +	}
> +
> +	dma_dev->dev = ccp->dev;
> +	dma_dev->src_addr_widths = CCP_DMA_WIDTH(dma_get_mask(ccp->dev));
> +	dma_dev->dst_addr_widths = CCP_DMA_WIDTH(dma_get_mask(ccp->dev));
> +	dma_dev->directions = DMA_MEM_TO_MEM;
> +	dma_dev->residue_granularity = DMA_RESIDUE_GRANULARITY_DESCRIPTOR;
> +	dma_cap_set(DMA_MEMCPY, dma_dev->cap_mask);
> +	dma_cap_set(DMA_SG, dma_dev->cap_mask);
> +	dma_cap_set(DMA_INTERRUPT, dma_dev->cap_mask);
> +
> +	INIT_LIST_HEAD(&dma_dev->channels);
> +	for (i = 0; i < ccp->cmd_q_count; i++) {
> +		chan = ccp->ccp_dma_chan + i;
> +		dma_chan = &chan->dma_chan;
> +
> +		chan->ccp = ccp;
> +
> +		spin_lock_init(&chan->lock);
> +		INIT_LIST_HEAD(&chan->pending);
> +		INIT_LIST_HEAD(&chan->active);
> +		INIT_LIST_HEAD(&chan->complete);
> +
> +		tasklet_init(&chan->cleanup_tasklet, ccp_do_cleanup,
> +			     (unsigned long)chan);
> +
> +		dma_chan->device = dma_dev;
> +		dma_cookie_init(dma_chan);
> +
> +		list_add_tail(&dma_chan->device_node, &dma_dev->channels);
> +	}
> +
> +	dma_dev->device_free_chan_resources = ccp_free_chan_resources;
> +	dma_dev->device_prep_dma_memcpy = ccp_prep_dma_memcpy;
> +	dma_dev->device_prep_dma_sg = ccp_prep_dma_sg;
> +	dma_dev->device_prep_dma_interrupt = ccp_prep_dma_interrupt;
> +	dma_dev->device_issue_pending = ccp_issue_pending;
> +	dma_dev->device_tx_status = ccp_tx_status;
> +	dma_dev->device_pause = ccp_pause;
> +	dma_dev->device_resume = ccp_resume;
> +	dma_dev->device_terminate_all = ccp_terminate_all;
> +
> +	ret = dma_async_device_register(dma_dev);
> +	if (ret)
> +		goto err_reg;
> +
> +	return 0;
> +
> +err_reg:
> +	kmem_cache_destroy(ccp->dma_desc_cache);
> +
> +err_cache:
> +	kmem_cache_destroy(ccp->dma_cmd_cache);
> +
> +	return ret;
> +}
> +
> +void ccp_dmaengine_unregister(struct ccp_device *ccp)
> +{
> +	struct dma_device *dma_dev = &ccp->dma_dev;
> +
> +	dma_async_device_unregister(dma_dev);
> +
> +	kmem_cache_destroy(ccp->dma_desc_cache);
> +	kmem_cache_destroy(ccp->dma_cmd_cache);
> +}
> diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
> index eefdf59..3467a1e 100644
> --- a/drivers/crypto/ccp/ccp-ops.c
> +++ b/drivers/crypto/ccp/ccp-ops.c
> @@ -1311,7 +1311,7 @@ static int ccp_run_passthru_cmd(struct ccp_cmd_queue *cmd_q,
>  	if (!pt->final && (pt->src_len & (CCP_PASSTHRU_BLOCKSIZE - 1)))
>  		return -EINVAL;
>  
> -	if (!pt->src || !pt->dst)
> +	if (!pt->src_sg || !pt->dst_sg)

No reason to change this in this patch. If you're trying to distinguish
between sg and dma addr because of the new passthru function you should
change the src and dst name in the new function - src_dma / dst_dma.

>  		return -EINVAL;
>  
>  	if (pt->bit_mod != CCP_PASSTHRU_BITWISE_NOOP) {
> @@ -1351,10 +1351,10 @@ static int ccp_run_passthru_cmd(struct ccp_cmd_queue *cmd_q,
>  	 * operations we need to set the dma direction to BIDIRECTIONAL
>  	 * and copy the src workarea to the dst workarea.
>  	 */
> -	if (sg_virt(pt->src) == sg_virt(pt->dst))
> +	if (sg_virt(pt->src_sg) == sg_virt(pt->dst_sg))
>  		in_place = true;
>  
> -	ret = ccp_init_data(&src, cmd_q, pt->src, pt->src_len,
> +	ret = ccp_init_data(&src, cmd_q, pt->src_sg, pt->src_len,
>  			    CCP_PASSTHRU_MASKSIZE,
>  			    in_place ? DMA_BIDIRECTIONAL : DMA_TO_DEVICE);
>  	if (ret)
> @@ -1363,7 +1363,7 @@ static int ccp_run_passthru_cmd(struct ccp_cmd_queue *cmd_q,
>  	if (in_place) {
>  		dst = src;
>  	} else {
> -		ret = ccp_init_data(&dst, cmd_q, pt->dst, pt->src_len,
> +		ret = ccp_init_data(&dst, cmd_q, pt->dst_sg, pt->src_len,
>  				    CCP_PASSTHRU_MASKSIZE, DMA_FROM_DEVICE);
>  		if (ret)
>  			goto e_src;
> @@ -1427,6 +1427,70 @@ e_mask:
>  	return ret;
>  }
>  
> +static int ccp_run_passthru_nomap_cmd(struct ccp_cmd_queue *cmd_q,
> +				      struct ccp_cmd *cmd)
> +{
> +	struct ccp_passthru_nomap_engine *pt = &cmd->u.passthru_nomap;
> +	struct ccp_dm_workarea mask;
> +	struct ccp_op op;
> +	int ret;
> +
> +	if (!pt->final && (pt->src_len & (CCP_PASSTHRU_BLOCKSIZE - 1)))
> +		return -EINVAL;
> +
> +	if (!pt->src || !pt->dst)
> +		return -EINVAL;
> +
> +	if (pt->bit_mod != CCP_PASSTHRU_BITWISE_NOOP) {
> +		if (pt->mask_len != CCP_PASSTHRU_MASKSIZE)
> +			return -EINVAL;
> +		if (!pt->mask)
> +			return -EINVAL;
> +	}
> +
> +	BUILD_BUG_ON(CCP_PASSTHRU_KSB_COUNT != 1);
> +
> +	memset(&op, 0, sizeof(op));
> +	op.cmd_q = cmd_q;
> +	op.jobid = ccp_gen_jobid(cmd_q->ccp);
> +
> +	if (pt->bit_mod != CCP_PASSTHRU_BITWISE_NOOP) {
> +		/* Load the mask */
> +		op.ksb_key = cmd_q->ksb_key;
> +
> +		mask.length = pt->mask_len;
> +		mask.dma.address = pt->mask;
> +		mask.dma.length = pt->mask_len;
> +
> +		ret = ccp_copy_to_ksb(cmd_q, &mask, op.jobid, op.ksb_key,
> +				     CCP_PASSTHRU_BYTESWAP_NOOP);
> +		if (ret) {
> +			cmd->engine_error = cmd_q->cmd_error;
> +			return ret;
> +		}
> +	}
> +
> +	/* Send data to the CCP Passthru engine */
> +	op.eom = 1;
> +	op.soc = 1;
> +
> +	op.src.type = CCP_MEMTYPE_SYSTEM;
> +	op.src.u.dma.address = pt->src;
> +	op.src.u.dma.offset = 0;
> +	op.src.u.dma.length = pt->src_len;
> +
> +	op.dst.type = CCP_MEMTYPE_SYSTEM;
> +	op.dst.u.dma.address = pt->dst;
> +	op.dst.u.dma.offset = 0;
> +	op.dst.u.dma.length = pt->src_len;
> +
> +	ret = cmd_q->ccp->vdata->perform->perform_passthru(&op);
> +	if (ret)
> +		cmd->engine_error = cmd_q->cmd_error;
> +
> +	return ret;
> +}
> +
>  static int ccp_run_ecc_mm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
>  {
>  	struct ccp_ecc_engine *ecc = &cmd->u.ecc;
> @@ -1762,7 +1826,10 @@ int ccp_run_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
>  		ret = ccp_run_rsa_cmd(cmd_q, cmd);
>  		break;
>  	case CCP_ENGINE_PASSTHRU:
> -		ret = ccp_run_passthru_cmd(cmd_q, cmd);
> +		if (cmd->flags & CCP_CMD_PASSTHRU_NO_DMA_MAP)
> +			ret = ccp_run_passthru_nomap_cmd(cmd_q, cmd);
> +		else
> +			ret = ccp_run_passthru_cmd(cmd_q, cmd);
>  		break;
>  	case CCP_ENGINE_ECC:
>  		ret = ccp_run_ecc_cmd(cmd_q, cmd);
> diff --git a/include/linux/ccp.h b/include/linux/ccp.h
> index 915af30..9584321 100644
> --- a/include/linux/ccp.h
> +++ b/include/linux/ccp.h
> @@ -375,7 +375,36 @@ struct ccp_passthru_engine {
>  	struct scatterlist *mask;
>  	u32 mask_len;		/* In bytes */
>  
> -	struct scatterlist *src, *dst;
> +	struct scatterlist *src_sg, *dst_sg;

As above, no reason for this change.

Thanks,
Tom

> +	u64 src_len;		/* In bytes */
> +
> +	u32 final;
> +};
> +
> +/**
> + * struct ccp_passthru_nomap_engine - CCP pass-through operation
> + *   without performing DMA mapping
> + * @bit_mod: bitwise operation to perform
> + * @byte_swap: byteswap operation to perform
> + * @mask: mask to be applied to data
> + * @mask_len: length in bytes of mask
> + * @src: data to be used for this operation
> + * @dst: data produced by this operation
> + * @src_len: length in bytes of data used for this operation
> + * @final: indicate final pass-through operation
> + *
> + * Variables required to be set when calling ccp_enqueue_cmd():
> + *   - bit_mod, byte_swap, src, dst, src_len
> + *   - mask, mask_len if bit_mod is not CCP_PASSTHRU_BITWISE_NOOP
> + */
> +struct ccp_passthru_nomap_engine {
> +	enum ccp_passthru_bitwise bit_mod;
> +	enum ccp_passthru_byteswap byte_swap;
> +
> +	dma_addr_t mask;
> +	u32 mask_len;		/* In bytes */
> +
> +	dma_addr_t src, dst;
>  	u64 src_len;		/* In bytes */
>  
>  	u32 final;
> @@ -522,7 +551,8 @@ enum ccp_engine {
>  };
>  
>  /* Flag values for flags member of ccp_cmd */
> -#define CCP_CMD_MAY_BACKLOG	0x00000001
> +#define CCP_CMD_MAY_BACKLOG		0x00000001
> +#define CCP_CMD_PASSTHRU_NO_DMA_MAP	0x00000002
>  
>  /**
>   * struct ccp_cmd - CPP operation request
> @@ -562,6 +592,7 @@ struct ccp_cmd {
>  		struct ccp_sha_engine sha;
>  		struct ccp_rsa_engine rsa;
>  		struct ccp_passthru_engine passthru;
> +		struct ccp_passthru_nomap_engine passthru_nomap;
>  		struct ccp_ecc_engine ecc;
>  	} u;
>  
> 
