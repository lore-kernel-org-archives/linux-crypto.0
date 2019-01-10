Return-Path: <SRS0=+HSe=PS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39092 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727753AbfAJN6C (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Jan 2019 08:58:02 -0500
Date: Thu, 10 Jan 2019 14:57:57 +0100
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: Kalyani Akula <kalyani.akula@xilinx.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kalyani Akula <kalyania@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>
Subject: Re: [RFC PATCH V2 3/4] crypto: Add Xilinx SHA3 driver
Message-ID: <20190110135757.GA32218@Red>
References: <1547025985-7228-1-git-send-email-kalyani.akula@xilinx.com>
 <1547025985-7228-4-git-send-email-kalyani.akula@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1547025985-7228-4-git-send-email-kalyani.akula@xilinx.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 09, 2019 at 02:56:24PM +0530, Kalyani Akula wrote:
> This patch adds SHA3 driver support for the Xilinx
> ZynqMP SoC.
> 
> Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
> ---
>  drivers/crypto/Kconfig      |   10 ++
>  drivers/crypto/Makefile     |    1 +
>  drivers/crypto/zynqmp-sha.c |  305 +++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 316 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/crypto/zynqmp-sha.c

Hello

I have some comment below

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

Since kbuf is in dma coherent memory, I dont understand why do you flush cache.

> +	ret = eemi_ops->sha_hash(dma_addr, req->nbytes, ZYNQMP_SHA3_UPDATE);
> +	dma_free_coherent(dd->dev, dma_size, kbuf, dma_addr);

Since your update function does not return/write any result, I suppose that the resulat is kept in hardware, so what happen if two hash process happen in parallel ?
Furthermore, how do you have tested import/export function ?
Anyway, I am sure they are totally buggy.

> +
> +	return ret;
> +}
> +
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

You can do this check at probe time.

> +static int zynqmp_sha_finup(struct ahash_request *req)
> +{
> +	zynqmp_sha_update(req);
> +	zynqmp_sha_final(req);
> +
> +	return 0;
> +}
> +
> +static int zynqmp_sha_digest(struct ahash_request *req)
> +{
> +	zynqmp_sha_init(req);
> +	zynqmp_sha_update(req);
> +	zynqmp_sha_final(req);
> +
> +	return 0;
> +}

So you ignore the return value of zynqmp_sha_init/zynqmp_sha_update/zynqmp_sha_final().

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

As already said in my last review, why init the queue if you do not use it ?


> +	spin_lock(&zynqmp_sha.lock);
> +	list_add_tail(&sha_dd->list, &zynqmp_sha.dev_list);
> +	spin_unlock(&zynqmp_sha.lock);

Why do you maintain a device list ?
Clearly your current driver support only one hardware instance.

Regards
