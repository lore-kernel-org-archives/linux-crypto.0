Return-Path: <SRS0=b7+G=PP=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-ed1-f65.google.com ([209.85.208.65]:37198 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbfAGKNS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Jan 2019 05:13:18 -0500
Date: Mon, 7 Jan 2019 11:13:13 +0100
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: Kalyani Akula <kalyani.akula@xilinx.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kalyani Akula <kalyania@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>
Subject: Re: [RFC PATCH 2/3] crypto: Add Xilinx SHA3 driver
Message-ID: <20190107101313.GA17747@Red>
References: <1546851776-3456-1-git-send-email-kalyani.akula@xilinx.com>
 <1546851776-3456-3-git-send-email-kalyani.akula@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1546851776-3456-3-git-send-email-kalyani.akula@xilinx.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 07, 2019 at 02:32:55PM +0530, Kalyani Akula wrote:
> This patch adds SHA3 driver suuport for the Xilinx
> ZynqMP SoC.
> 
> Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>

Hello

I have some comment below

> +static int zynqmp_sha_init(struct ahash_request *req)
> +{
> +	const struct zynqmp_eemi_ops *eemi_ops = zynqmp_pm_get_eemi_ops();
> +	struct zynqmp_sha_reqctx *ctx = ahash_request_ctx(req);
> +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> +	struct zynqmp_sha_ctx *tctx = crypto_ahash_ctx(tfm);
> +	struct zynqmp_sha_dev *dd = NULL;
> +	struct zynqmp_sha_dev *tmp;
> +	int ret;
> +
> +	if (!eemi_ops || !eemi_ops->sha_hash)
> +		return -ENOTSUPP;
> +

Where can I find sha_hash() ?
It seems that your serie miss some patchs.

> +	spin_lock_bh(&zynqmp_sha.lock);
> +	if (!tctx->dd) {
> +		list_for_each_entry(tmp, &zynqmp_sha.dev_list, list) {
> +			dd = tmp;
> +			break;
> +		}
> +		tctx->dd = dd;
> +	} else {
> +		dd = tctx->dd;
> +	}
> +	spin_unlock_bh(&zynqmp_sha.lock);
> +
> +	ctx->dd = dd;
> +	dev_dbg(dd->dev, "init: digest size: %d\n",
> +		crypto_ahash_digestsize(tfm));
> +
> +	ret = eemi_ops->sha_hash(0, 0, ZYNQMP_SHA3_INIT);
> +
> +	return ret;
> +}
> +
> +static int zynqmp_sha_update(struct ahash_request *req)
> +{
> +	const struct zynqmp_eemi_ops *eemi_ops = zynqmp_pm_get_eemi_ops();
> +	struct zynqmp_sha_ctx *tctx = crypto_tfm_ctx(req->base.tfm);
> +	struct zynqmp_sha_dev *dd = tctx->dd;
> +	size_t dma_size = req->nbytes;
> +	dma_addr_t dma_addr;
> +	char *kbuf;
> +	int ret;
> +
> +	if (!req->nbytes)
> +		return 0;
> +
> +	if (!eemi_ops || !eemi_ops->sha_hash)
> +		return -ENOTSUPP;
> +
> +	kbuf = dma_alloc_coherent(dd->dev, dma_size, &dma_addr, GFP_KERNEL);
> +	if (!kbuf)
> +		return -ENOMEM;
> +
> +	scatterwalk_map_and_copy(kbuf, req->src, 0, req->nbytes, 0);
> +	 __flush_cache_user_range((unsigned long)kbuf,
> +				  (unsigned long)kbuf + dma_size);
> +	ret = eemi_ops->sha_hash(dma_addr, req->nbytes, ZYNQMP_SHA3_UPDATE);

Even with the sha_hash prototype missing, I think your driver have a problem:
You support having more than one device, but sha_hash lacks any reference on the device doing the request.

> +static int zynqmp_sha_final(struct ahash_request *req)
> +{
> +	const struct zynqmp_eemi_ops *eemi_ops = zynqmp_pm_get_eemi_ops();
> +	struct zynqmp_sha_ctx *tctx = crypto_tfm_ctx(req->base.tfm);
> +	struct zynqmp_sha_dev *dd = tctx->dd;
> +	size_t dma_size = SHA384_DIGEST_SIZE;
> +	dma_addr_t dma_addr;
> +	char *kbuf;
> +	int ret;
> +
> +	if (!eemi_ops || !eemi_ops->sha_hash)
> +		return -ENOTSUPP;
> +
> +	kbuf = dma_alloc_coherent(dd->dev, dma_size, &dma_addr, GFP_KERNEL);
> +	if (!kbuf)
> +		return -ENOMEM;
> +
> +	ret = eemi_ops->sha_hash(dma_addr, dma_size, ZYNQMP_SHA3_FINAL);
> +	memcpy(req->result, kbuf, 48);

It is better to use SHA384_DIGEST_SIZE instead of 48

[...]
> +static int zynqmp_sha_probe(struct platform_device *pdev)
> +{
> +	struct zynqmp_sha_dev *sha_dd;
> +	struct device *dev = &pdev->dev;
> +	int err;
> +
> +	sha_dd = devm_kzalloc(&pdev->dev, sizeof(*sha_dd), GFP_KERNEL);
> +	if (!sha_dd)
> +		return -ENOMEM;
> +
> +	sha_dd->dev = dev;
> +	platform_set_drvdata(pdev, sha_dd);
> +	INIT_LIST_HEAD(&sha_dd->list);
> +	spin_lock_init(&sha_dd->lock);
> +	crypto_init_queue(&sha_dd->queue, ZYNQMP_SHA_QUEUE_LENGTH);

You create a queue, but you didnt use it.

[...]
> +	spin_lock(&zynqmp_sha.lock);
> +	list_add_tail(&sha_dd->list, &zynqmp_sha.dev_list);
> +	spin_unlock(&zynqmp_sha.lock);
> +
> +	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(44));
> +	if (err < 0)
> +		dev_err(dev, "no usable DMA configuration");

It is an error that you ignore, you miss some goto errxxx.

Regards
