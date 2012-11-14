From: Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH v3 5/7] crypto: omap-sham: Convert to use pm_runtime API
Date: Tue, 13 Nov 2012 17:12:26 -0800
Message-ID: <87bof1f0n9.fsf@deeprootsystems.com>
References: <1352257033-32495-1-git-send-email-mgreer@animalcreek.com>
	<1352257033-32495-6-git-send-email-mgreer@animalcreek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, dmitry.kasatkin@intel.com,
	rmk+kernel@arm.linux.org.uk, paul@pwsan.com
To: "Mark A. Greer" <mgreer@animalcreek.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43019 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161Ab2KNBMU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Nov 2012 20:12:20 -0500
Received: by mail-pa0-f46.google.com with SMTP id hz1so5431656pad.19
        for <linux-crypto@vger.kernel.org>; Tue, 13 Nov 2012 17:12:19 -0800 (PST)
In-Reply-To: <1352257033-32495-6-git-send-email-mgreer@animalcreek.com> (Mark
	A. Greer's message of "Tue, 6 Nov 2012 19:57:11 -0700")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Mark,

"Mark A. Greer" <mgreer@animalcreek.com> writes:

> From: "Mark A. Greer" <mgreer@animalcreek.com>
>
> Convert the omap-sham crypto driver to use the
> pm_runtime API instead of the clk API.
>
> CC: Kevin Hilman <khilman@deeprootsystems.com>
> CC: Paul Walmsley <paul@pwsan.com>
> CC: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
> Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>

Acked-by: Kevin Hilman <khilman@ti.com>

This looks much better and is more obviously a straight forward clock
API --> runtime PM conversion.

Thanks,

Kevin

> ---
>  drivers/crypto/omap-sham.c | 28 +++++++++++-----------------
>  1 file changed, 11 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
> index a3fd6fc..85d43b2 100644
> --- a/drivers/crypto/omap-sham.c
> +++ b/drivers/crypto/omap-sham.c
> @@ -22,12 +22,12 @@
>  #include <linux/errno.h>
>  #include <linux/interrupt.h>
>  #include <linux/kernel.h>
> -#include <linux/clk.h>
>  #include <linux/irq.h>
>  #include <linux/io.h>
>  #include <linux/platform_device.h>
>  #include <linux/scatterlist.h>
>  #include <linux/dma-mapping.h>
> +#include <linux/pm_runtime.h>
>  #include <linux/delay.h>
>  #include <linux/crypto.h>
>  #include <linux/cryptohash.h>
> @@ -141,7 +141,6 @@ struct omap_sham_dev {
>  	struct device		*dev;
>  	void __iomem		*io_base;
>  	int			irq;
> -	struct clk		*iclk;
>  	spinlock_t		lock;
>  	int			err;
>  	int			dma;
> @@ -238,7 +237,7 @@ static void omap_sham_copy_ready_hash(struct ahash_request *req)
>  
>  static int omap_sham_hw_init(struct omap_sham_dev *dd)
>  {
> -	clk_enable(dd->iclk);
> +	pm_runtime_get_sync(dd->dev);
>  
>  	if (!test_bit(FLAGS_INIT, &dd->flags)) {
>  		omap_sham_write_mask(dd, SHA_REG_MASK,
> @@ -653,7 +652,8 @@ static void omap_sham_finish_req(struct ahash_request *req, int err)
>  	/* atomic operation is not needed here */
>  	dd->flags &= ~(BIT(FLAGS_BUSY) | BIT(FLAGS_FINAL) | BIT(FLAGS_CPU) |
>  			BIT(FLAGS_DMA_READY) | BIT(FLAGS_OUTPUT_READY));
> -	clk_disable(dd->iclk);
> +
> +	pm_runtime_put_sync(dd->dev);
>  
>  	if (req->base.complete)
>  		req->base.complete(&req->base, err);
> @@ -1198,14 +1198,6 @@ static int __devinit omap_sham_probe(struct platform_device *pdev)
>  	if (err)
>  		goto dma_err;
>  
> -	/* Initializing the clock */
> -	dd->iclk = clk_get(dev, "ick");
> -	if (IS_ERR(dd->iclk)) {
> -		dev_err(dev, "clock intialization failed.\n");
> -		err = PTR_ERR(dd->iclk);
> -		goto clk_err;
> -	}
> -
>  	dd->io_base = ioremap(dd->phys_base, SZ_4K);
>  	if (!dd->io_base) {
>  		dev_err(dev, "can't ioremap\n");
> @@ -1213,11 +1205,14 @@ static int __devinit omap_sham_probe(struct platform_device *pdev)
>  		goto io_err;
>  	}
>  
> -	clk_enable(dd->iclk);
> +	pm_runtime_enable(dev);
> +	pm_runtime_get_sync(dev);
> +
>  	dev_info(dev, "hw accel on OMAP rev %u.%u\n",
>  		(omap_sham_read(dd, SHA_REG_REV) & SHA_REG_REV_MAJOR) >> 4,
>  		omap_sham_read(dd, SHA_REG_REV) & SHA_REG_REV_MINOR);
> -	clk_disable(dd->iclk);
> +
> +	pm_runtime_put_sync(&pdev->dev);
>  
>  	spin_lock(&sham.lock);
>  	list_add_tail(&dd->list, &sham.dev_list);
> @@ -1235,9 +1230,8 @@ err_algs:
>  	for (j = 0; j < i; j++)
>  		crypto_unregister_ahash(&algs[j]);
>  	iounmap(dd->io_base);
> +	pm_runtime_disable(dev);
>  io_err:
> -	clk_put(dd->iclk);
> -clk_err:
>  	omap_sham_dma_cleanup(dd);
>  dma_err:
>  	if (dd->irq >= 0)
> @@ -1266,7 +1260,7 @@ static int __devexit omap_sham_remove(struct platform_device *pdev)
>  		crypto_unregister_ahash(&algs[i]);
>  	tasklet_kill(&dd->done_task);
>  	iounmap(dd->io_base);
> -	clk_put(dd->iclk);
> +	pm_runtime_disable(&pdev->dev);
>  	omap_sham_dma_cleanup(dd);
>  	if (dd->irq >= 0)
>  		free_irq(dd->irq, dd);
