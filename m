From: Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH 2/7] crypto: inside-secure: add SafeXcel EIP197 crypto
 engine driver
Date: Wed, 12 Apr 2017 14:54:13 +0100
Message-ID: <5a016e1e-1443-158a-5ced-58dcb4ad63cc@arm.com>
References: <20170329124432.27457-1-antoine.tenart@free-electrons.com>
 <20170329124432.27457-3-antoine.tenart@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: thomas.petazzoni@free-electrons.com,
        boris.brezillon@free-electrons.com, igall@marvell.com,
        nadavh@marvell.com, linux-crypto@vger.kernel.org,
        oferh@marvell.com, linux-arm-kernel@lists.infradead.org
To: Antoine Tenart <antoine.tenart@free-electrons.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        jason@lakedaemon.net, andrew@lunn.ch,
        gregory.clement@free-electrons.com, sebastian.hesselbarth@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:44532 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751197AbdDLNyS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Apr 2017 09:54:18 -0400
In-Reply-To: <20170329124432.27457-3-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Antoine,

Bit of a drive-by, but since I have it in my head that crypto drivers
are a hotspot for dodgy DMA usage (in part due to the hardware often
being a bit esoteric with embedded RAMs and such), this caught my eye
and I thought I'd give this a quick once-over to check for anything
smelly. Unfortunately, I was not disappointed... ;)

On 29/03/17 13:44, Antoine Tenart wrote:
[...]
> diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
> new file mode 100644
> index 000000000000..00f3f2c85d05
> --- /dev/null
> +++ b/drivers/crypto/inside-secure/safexcel.c
[...]
> +int safexcel_invalidate_cache(struct crypto_async_request *async,
> +			      struct safexcel_context *ctx,
> +			      struct safexcel_crypto_priv *priv,
> +			      dma_addr_t ctxr_dma, int ring,
> +			      struct safexcel_request *request)
> +{
> +	struct safexcel_command_desc *cdesc;
> +	struct safexcel_result_desc *rdesc;
> +	phys_addr_t ctxr_phys;
> +	int ret = 0;
> +
> +	ctxr_phys = dma_to_phys(priv->dev, ctxr_dma);

No no no. This is a SWIOTLB-specific (or otherwise arch-private,
depending on implementation) helper, not a DMA API function, and should
not be called directly by drivers. There is no guarantee it will give
the result you expect, or even compile, in all cases (if the kbuild
robot hasn't already revealed via the COMPILE_TEST dependency).

That said, AFAICS ctxr_phys ends up in a descriptor which is given to
the device, so trying to use a physical address is wrong and it should
still be the DMA address anyway.

> +	spin_lock_bh(&priv->ring[ring].egress_lock);
> +
> +	/* prepare command descriptor */
> +	cdesc = safexcel_add_cdesc(priv, ring, true, true, 0, 0, 0, ctxr_phys);
> +	if (IS_ERR(cdesc)) {
> +		ret = PTR_ERR(cdesc);
> +		goto unlock;
> +	}
> +
> +	cdesc->control_data.type = EIP197_TYPE_EXTENDED;
> +	cdesc->control_data.options = 0;
> +	cdesc->control_data.refresh = 0;
> +	cdesc->control_data.control0 = CONTEXT_CONTROL_INV_TR;
> +
> +	/* prepare result descriptor */
> +	rdesc = safexcel_add_rdesc(priv, ring, true, true, 0, 0);
> +
> +	if (IS_ERR(rdesc)) {
> +		ret = PTR_ERR(rdesc);
> +		goto cdesc_rollback;
> +	}
> +
> +	request->req = async;
> +	goto unlock;
> +
> +cdesc_rollback:
> +	safexcel_ring_rollback_wptr(priv, &priv->ring[ring].cdr);
> +
> +unlock:
> +	spin_unlock_bh(&priv->ring[ring].egress_lock);
> +	return ret;
> +}
[...]
> +static int safexcel_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct resource *res;
> +	struct safexcel_crypto_priv *priv;
> +	int i, ret;
> +
> +	priv = devm_kzalloc(dev, sizeof(struct safexcel_crypto_priv),
> +			    GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	priv->dev = dev;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	priv->base = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(priv->base)) {
> +		dev_err(dev, "failed to get resource\n");
> +		return PTR_ERR(priv->base);
> +	}
> +
> +	priv->clk = of_clk_get(dev->of_node, 0);
> +	if (!IS_ERR(priv->clk)) {
> +		ret = clk_prepare_enable(priv->clk);
> +		if (ret) {
> +			dev_err(dev, "unable to enable clk (%d)\n", ret);
> +			return ret;
> +		}
> +	} else {
> +		/* The clock isn't mandatory */
> +		if (PTR_ERR(priv->clk) == -EPROBE_DEFER)
> +			return -EPROBE_DEFER;
> +	}

You should call dma_set_mask_and_coherent() before any DMA API calls,
both to confirm DMA really is going to work all, and also (since this IP
apparently supports >32-bit addresses) to describe the full inherent
addressing capability, not least to avoid wasting time/space with
unnecessary bounce buffering otherwise.

> +	priv->context_pool = dmam_pool_create("safexcel-context", dev,
> +					      sizeof(struct safexcel_context_record),
> +					      1, 0);
> +	if (!priv->context_pool) {
> +		ret = -ENOMEM;
> +		goto err_clk;
> +	}
> +
> +	safexcel_configure(priv);
> +
> +	for (i = 0; i < priv->config.rings; i++) {
> +		char irq_name[6] = {0}; /* "ringX\0" */
> +		char wq_name[9] = {0}; /* "wq_ringX\0" */
> +		int irq;
> +		struct safexcel_ring_irq_data *ring_irq;
> +
> +		ret = safexcel_init_ring_descriptors(priv,
> +						     &priv->ring[i].cdr,
> +						     &priv->ring[i].rdr);
> +		if (ret)
> +			goto err_pool;
> +
> +		ring_irq = devm_kzalloc(dev, sizeof(struct safexcel_ring_irq_data),
> +					GFP_KERNEL);
> +		if (!ring_irq) {
> +			ret = -ENOMEM;
> +			goto err_pool;
> +		}
> +
> +		ring_irq->priv = priv;
> +		ring_irq->ring = i;
> +
> +		snprintf(irq_name, 6, "ring%d", i);
> +		irq = safexcel_request_ring_irq(pdev, irq_name, safexcel_irq_ring,
> +						ring_irq);
> +
> +		if (irq < 0)
> +			goto err_pool;
> +
> +		priv->ring[i].work_data.priv = priv;
> +		priv->ring[i].work_data.ring = i;
> +		INIT_WORK(&priv->ring[i].work_data.work, safexcel_handle_result_work);
> +
> +		snprintf(wq_name, 9, "wq_ring%d", i);
> +		priv->ring[i].workqueue = create_singlethread_workqueue(wq_name);
> +		if (!priv->ring[i].workqueue) {
> +			ret = -ENOMEM;
> +			goto err_pool;
> +		}
> +
> +		INIT_LIST_HEAD(&priv->ring[i].list);
> +		spin_lock_init(&priv->ring[i].lock);
> +		spin_lock_init(&priv->ring[i].egress_lock);
> +	}
> +
> +	platform_set_drvdata(pdev, priv);
> +	atomic_set(&priv->ring_used, 0);
> +
> +	spin_lock_init(&priv->lock);
> +	crypto_init_queue(&priv->queue, EIP197_DEFAULT_RING_SIZE);
> +
> +	ret = safexcel_hw_init(priv);
> +	if (ret) {
> +		dev_err(dev, "EIP h/w init failed (%d)\n", ret);
> +		goto err_pool;
> +	}
> +
> +	ret = safexcel_register_algorithms(priv);
> +	if (ret) {
> +		dev_err(dev, "Failed to register algorithms (%d)\n", ret);
> +		goto err_pool;
> +	}
> +
> +	return 0;
> +
> +err_pool:
> +	dma_pool_destroy(priv->context_pool);

You used dmam_pool_create(), so not only is an explicit destroy
unnecessary, but doing so with the non-managed version is actively
harmful, since devres would end up double-freeing the pool after you return.

> +err_clk:
> +	clk_disable_unprepare(priv->clk);
> +	return ret;
> +}
[...]
> diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
> new file mode 100644
> index 000000000000..ffe39aaabe1c
> --- /dev/null
> +++ b/drivers/crypto/inside-secure/safexcel.h
[...]
> +/* Result data */
> +struct result_data_desc {
> +	u32 packet_length:17;
> +	u32 error_code:15;
> +
> +	u8 bypass_length:4;
> +	u8 e15:1;
> +	u16 rsvd0;
> +	u8 hash_bytes:1;
> +	u8 hash_length:6;
> +	u8 generic_bytes:1;
> +	u8 checksum:1;
> +	u8 next_header:1;
> +	u8 length:1;
> +
> +	u16 application_id;
> +	u16 rsvd1;
> +
> +	u32 rsvd2;
> +} __packed;
> +
> +
> +/* Basic Result Descriptor format */
> +struct safexcel_result_desc {
> +	u32 particle_size:17;
> +	u8 rsvd0:3;
> +	u8 descriptor_overflow:1;
> +	u8 buffer_overflow:1;
> +	u8 last_seg:1;
> +	u8 first_seg:1;
> +	u16 result_size:8;
> +
> +	u32 rsvd1;
> +
> +	u32 data_lo;
> +	u32 data_hi;
> +
> +	struct result_data_desc result_data;
> +} __packed;
> +
> +struct safexcel_token {
> +	u32 packet_length:17;
> +	u8 stat:2;
> +	u16 instructions:9;
> +	u8 opcode:4;
> +} __packed;

Using bitfields in hardware descriptors seems pretty risky, since you've
no real guarantee two compilers will lay them out the same way (or that
either would be correct WRT what the hardware expects). I'd be more
inclined to construct all these fields with explicit masking and shifting.

[...]
> diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
> new file mode 100644
> index 000000000000..ff42e45ae43e
> --- /dev/null
> +++ b/drivers/crypto/inside-secure/safexcel_cipher.c
[...]
> +static int safexcel_aes_send(struct crypto_async_request *async,
> +			     int ring, struct safexcel_request *request,
> +			     int *commands, int *results)
> +{
> +	struct ablkcipher_request *req = ablkcipher_request_cast(async);
> +	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
> +	struct safexcel_crypto_priv *priv = ctx->priv;
> +	struct safexcel_command_desc *cdesc;
> +	struct safexcel_result_desc *rdesc;
> +	struct scatterlist *sg;
> +	phys_addr_t ctxr_phys;
> +	int nr_src, nr_dst, n_cdesc = 0, n_rdesc = 0, queued = req->nbytes;
> +	int i, ret = 0;
> +
> +	request->req = &req->base;
> +
> +	if (req->src == req->dst) {
> +		nr_src = sg_nents_for_len(req->src, req->nbytes);
> +		nr_dst = nr_src;
> +
> +		if (dma_map_sg(priv->dev, req->src, nr_src, DMA_BIDIRECTIONAL) <= 0)

Nit: you only need to check for zero/nonzero to determine failure
(similarly below) - dma_map_sg() cannot return negative values.

Bigger complaint: you should not ignore the successful return value and
rely on it being equal to nr_src - please see the description of
dma_map_sg() in Documenatation/DMA-API.txt

> +			return -EINVAL;
> +	} else {
> +		nr_src = sg_nents_for_len(req->src, req->nbytes);
> +		nr_dst = sg_nents_for_len(req->dst, req->nbytes);
> +
> +		if (dma_map_sg(priv->dev, req->src, nr_src, DMA_TO_DEVICE) <= 0)
> +			return -EINVAL;
> +
> +		if (dma_map_sg(priv->dev, req->dst, nr_dst, DMA_FROM_DEVICE) <= 0) {
> +			dma_unmap_sg(priv->dev, req->src, nr_src,
> +				     DMA_TO_DEVICE);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	ctxr_phys = dma_to_phys(priv->dev, ctx->base.ctxr_dma);

Once again, wrong and probably unnecessary.

> +	memcpy(ctx->base.ctxr->data, ctx->key, ctx->key_len);
> +
> +	spin_lock_bh(&priv->ring[ring].egress_lock);
> +
> +	/* command descriptors */
> +	for_each_sg(req->src, sg, nr_src, i) {
> +		phys_addr_t sg_phys = dma_to_phys(priv->dev, sg_dma_address(sg));
> +		int len = sg_dma_len(sg);

If dma_map_sg() coalesced any entries into the same mapping such that
count < nents, these could well give bogus values toward the end of the
list once i >= count(if you're lucky, at least len might be 0).

> +		/* Do not overflow the request */
> +		if (queued - len < 0)
> +			len = queued;
> +
> +		cdesc = safexcel_add_cdesc(priv, ring, !n_cdesc, !(queued - len),
> +					   sg_phys, len, req->nbytes, ctxr_phys);
> +		if (IS_ERR(cdesc)) {
> +			/* No space left in the command descriptor ring */
> +			ret = PTR_ERR(cdesc);
> +			goto cdesc_rollback;
> +		}
> +		n_cdesc++;
> +
> +		if (n_cdesc == 1) {
> +			safexcel_context_control(ctx, cdesc);
> +			safexcel_cipher_token(ctx, async, cdesc, req->nbytes);
> +		}
> +
> +		queued -= len;
> +		if (!queued)
> +			break;
> +	}
> +
> +	/* result descriptors */
> +	for_each_sg(req->dst, sg, nr_dst, i) {
> +		bool first = !i, last = (i == nr_dst - 1);
> +		phys_addr_t sg_phys = dma_to_phys(priv->dev, sg_dma_address(sg));

And again, no. Also note that sg_phys() already exists as a function, so
I imagine sparse could get quite cross here.

> +		u32 len = sg_dma_len(sg);

Plus the same comment again about potentially having iterated past the
point where these are valid.

> +
> +		rdesc = safexcel_add_rdesc(priv, ring, first, last, sg_phys, len);
> +		if (IS_ERR(rdesc)) {
> +			/* No space left in the result descriptor ring */
> +			ret = PTR_ERR(rdesc);
> +			goto rdesc_rollback;
> +		}
> +		n_rdesc++;
> +	}
> +
> +	ctx->base.handle_result = safexcel_handle_result;
> +
> +	spin_unlock_bh(&priv->ring[ring].egress_lock);
> +
> +	*commands = n_cdesc;
> +	*results = nr_dst;
> +	return 0;
> +
> +rdesc_rollback:
> +	for (i = 0; i < n_rdesc; i++)
> +		safexcel_ring_rollback_wptr(priv, &priv->ring[ring].rdr);
> +cdesc_rollback:
> +	for (i = 0; i < n_cdesc; i++)
> +		safexcel_ring_rollback_wptr(priv, &priv->ring[ring].cdr);
> +
> +	spin_unlock_bh(&priv->ring[ring].egress_lock);
> +
> +	if (req->src == req->dst) {
> +		dma_unmap_sg(priv->dev, req->src, nr_src, DMA_BIDIRECTIONAL);
> +	} else {
> +		dma_unmap_sg(priv->dev, req->src, nr_src, DMA_TO_DEVICE);
> +		dma_unmap_sg(priv->dev, req->dst, nr_dst, DMA_FROM_DEVICE);

I will note that the unmap_sg calls *should* have the same nents value
as originally passed to map_sg, so these remain correct.

> +	}
> +
> +	return ret;
> +}
[...]
> diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
> new file mode 100644
> index 000000000000..1f44e0a2ddf1
> --- /dev/null
> +++ b/drivers/crypto/inside-secure/safexcel_hash.c
[...]
> +static int safexcel_ahash_send(struct crypto_async_request *async, int ring,
> +			       struct safexcel_request *request, int *commands,
> +			       int *results)
> +{
> +	struct ahash_request *areq = ahash_request_cast(async);
> +	struct crypto_ahash *ahash = crypto_ahash_reqtfm(areq);
> +	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
> +	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
> +	struct safexcel_crypto_priv *priv = ctx->priv;
> +	struct safexcel_command_desc *cdesc, *first_cdesc = NULL;
> +	struct safexcel_result_desc *rdesc;
> +	struct scatterlist *sg;
> +	int i, nents, queued, len, cache_len, extra, n_cdesc = 0, ret = 0;
> +	phys_addr_t ctxr_phys = 0;
> +
> +	queued = len = req->len - req->processed;
> +	if (queued < crypto_ahash_blocksize(ahash))
> +		cache_len = queued;
> +	else
> +		cache_len = queued - areq->nbytes;
> +
> +	/*
> +	 * If this is not the last request and the queued data does not fit
> +	 * into full blocks, cache it for the next send() call.
> +	 */
> +	extra = queued & (crypto_ahash_blocksize(ahash) - 1);
> +	if (!req->last_req && extra) {
> +		sg_pcopy_to_buffer(areq->src, sg_nents(areq->src),
> +				   req->cache_next, extra, areq->nbytes - extra);
> +
> +		queued -= extra;
> +		len -= extra;
> +	}
> +
> +	request->req = &areq->base;
> +	ctx->base.handle_result = safexcel_handle_result;
> +	ctxr_phys = dma_to_phys(priv->dev, ctx->base.ctxr_dma);

No.

> +	spin_lock_bh(&priv->ring[ring].egress_lock);
> +
> +	/* Add a command descriptor for the cached data, if any */
> +	if (cache_len) {
> +		ctx->base.cache_dma = dma_map_single(priv->dev, req->cache,

This is pretty dodgy, since req->cache is inside a live data structure,
adjoining parts of which are updated whilst still mapped (the update of
req->processed below). You just about get away without data corruption
since we *probably* don't invalidate anything when unmapping
DMA_TO_DEVICE, and the coherency hardware *probably* doesn't do anything
crazy, but you've no real guarantee of that - any DMA buffer should
really be separately kmalloced. "That's a nice dirty cache line you've
got there, it'd be a shame if anything were to happen to it..."

> +						     cache_len, DMA_TO_DEVICE);
> +		if (dma_mapping_error(priv->dev, ctx->base.cache_dma)) {
> +			ret = -EINVAL;
> +			goto unlock;
> +		}
> +
> +		ctx->base.cache_sz = cache_len;
> +		first_cdesc = safexcel_add_cdesc(priv, ring, 1,
> +						 (cache_len == len),
> +						 dma_to_phys(priv->dev, ctx->base.cache_dma),

No.

> +						 cache_len, len, ctxr_phys);
> +		if (IS_ERR(first_cdesc)) {
> +			ret = PTR_ERR(first_cdesc);
> +			goto free_cache;
> +		}
> +		n_cdesc++;
> +
> +		queued -= cache_len;
> +		if (!queued)
> +			goto send_command;
> +	}
> +
> +	/* Now handle the current ahash request buffer(s) */
> +	nents = sg_nents_for_len(areq->src, areq->nbytes);
> +	if (dma_map_sg(priv->dev, areq->src, nents, DMA_TO_DEVICE) <= 0) {

Same comments about the return value.

> +		ret = -ENOMEM;
> +		goto cdesc_rollback;
> +	}
> +
> +	for_each_sg(areq->src, sg, nents, i) {
> +		phys_addr_t sg_phys = dma_to_phys(priv->dev, sg_dma_address(sg));

No.

> +		int sglen = sg_dma_len(sg);
> +
> +		/* Do not overflow the request */
> +		if (queued - sglen < 0)
> +			sglen = queued;
> +
> +		cdesc = safexcel_add_cdesc(priv, ring, !n_cdesc,
> +					   !(queued - sglen), sg_phys, sglen,
> +					   len, ctxr_phys);
> +		if (IS_ERR(cdesc)) {
> +			ret = PTR_ERR(cdesc);
> +			goto cdesc_rollback;
> +		}
> +		n_cdesc++;
> +
> +		if (n_cdesc == 1)
> +			first_cdesc = cdesc;
> +
> +		queued -= sglen;
> +		if (!queued)
> +			break;
> +	}
> +
> +send_command:
> +	/* Setup the context options */
> +	safexcel_context_control(ctx, req, first_cdesc, req->state_sz,
> +				 crypto_ahash_blocksize(ahash));
> +
> +	/* Add the token */
> +	safexcel_hash_token(first_cdesc, len, req->state_sz);
> +
> +	ctx->base.result_dma = dma_map_single(priv->dev, areq->result,
> +					      req->state_sz, DMA_FROM_DEVICE);
> +	if (dma_mapping_error(priv->dev, ctx->base.result_dma)) {
> +		ret = -EINVAL;
> +		goto cdesc_rollback;
> +	}
> +
> +	/* Add a result descriptor */
> +	rdesc = safexcel_add_rdesc(priv, ring, 1, 1,
> +				   dma_to_phys(priv->dev, ctx->base.result_dma),
> +				   req->state_sz);
> +	if (IS_ERR(rdesc)) {
> +		ret = PTR_ERR(rdesc);
> +		goto cdesc_rollback;
> +	}
> +
> +	req->processed += len;
> +	spin_unlock_bh(&priv->ring[ring].egress_lock);
> +
> +	*commands = n_cdesc;
> +	*results = 1;
> +	return 0;
> +
> +cdesc_rollback:
> +	for (i = 0; i < n_cdesc; i++)
> +		safexcel_ring_rollback_wptr(priv, &priv->ring[ring].cdr);
> +free_cache:
> +	if (ctx->base.cache_dma)
> +		dma_unmap_single(priv->dev, ctx->base.cache_dma,
> +				 ctx->base.cache_sz, DMA_TO_DEVICE);
> +
> +unlock:
> +	spin_unlock_bh(&priv->ring[ring].egress_lock);
> +	return ret;
> +}
[...]
> diff --git a/drivers/crypto/inside-secure/safexcel_ring.c b/drivers/crypto/inside-secure/safexcel_ring.c
> new file mode 100644
> index 000000000000..5b4ba7a8cc0a
> --- /dev/null
> +++ b/drivers/crypto/inside-secure/safexcel_ring.c
[...]
> +int safexcel_init_ring_descriptors(struct safexcel_crypto_priv *priv,
> +				   struct safexcel_ring *cdr,
> +				   struct safexcel_ring *rdr)
> +{
> +	cdr->offset = sizeof(u32) * priv->config.cd_offset;
> +	cdr->base = dmam_alloc_coherent(priv->dev,
> +					cdr->offset * EIP197_DEFAULT_RING_SIZE,
> +					&cdr->base_dma, GFP_KERNEL);
> +	if (!cdr->base)
> +		return -ENOMEM;
> +	cdr->write = cdr->base;
> +	cdr->base_end = cdr->base + cdr->offset * EIP197_DEFAULT_RING_SIZE;
> +	cdr->read = cdr->base;
> +
> +	rdr->offset = sizeof(u32) * priv->config.rd_offset;
> +	rdr->base = dmam_alloc_coherent(priv->dev,
> +					rdr->offset * EIP197_DEFAULT_RING_SIZE,
> +					&rdr->base_dma, GFP_KERNEL);
> +	if (!rdr->base) {
> +		dmam_free_coherent(priv->dev,
> +				   cdr->offset * EIP197_DEFAULT_RING_SIZE,
> +				   cdr->base, cdr->base_dma);

Returning an error here will abort your probe routine, so devres will
clean these up there and then - there's no need to do free anything
explicitly. That's rather the point of using devm_*() to begin with.

> +		return -ENOMEM;
> +	}
> +	rdr->write = rdr->base;
> +	rdr->base_end = rdr->base + rdr->offset * EIP197_DEFAULT_RING_SIZE;
> +	rdr->read = rdr->base;
> +
> +	return 0;
> +}
> +
> +void safexcel_free_ring_descriptors(struct safexcel_crypto_priv *priv,
> +				    struct safexcel_ring *cdr,
> +				    struct safexcel_ring *rdr)
> +{
> +	dmam_free_coherent(priv->dev,
> +			   cdr->offset * EIP197_DEFAULT_RING_SIZE,
> +			   cdr->base, cdr->base_dma);
> +	dmam_free_coherent(priv->dev,
> +			   rdr->offset * EIP197_DEFAULT_RING_SIZE,
> +			   rdr->base, rdr->base_dma);
> +}

Again, this is only called at device teardown, so the whole function is
redundant.

Robin.
