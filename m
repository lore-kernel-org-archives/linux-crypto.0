From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH] crypto: marvell/cesa - Fix DMA API misuse
Date: Wed, 10 Jan 2018 16:25:22 +0100
Message-ID: <20180110162522.580089a5@bbrezillon>
References: <55d3177407b00dd4a9d51fe4f8e2bf2282fe8e3d.1515596541.git.robin.murphy@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: arno@natisbad.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, hch@lst.de, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
To: Robin Murphy <robin.murphy@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:36511 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965117AbeAJPZe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Jan 2018 10:25:34 -0500
In-Reply-To: <55d3177407b00dd4a9d51fe4f8e2bf2282fe8e3d.1515596541.git.robin.murphy@arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 10 Jan 2018 15:15:43 +0000
Robin Murphy <robin.murphy@arm.com> wrote:

> phys_to_dma() is an internal helper for certain DMA API implementations,
> and is not appropriate for drivers to use. It appears that what the CESA
> driver really wants to be using is dma_map_resource() - admittedly that
> didn't exist when the offending code was first merged, but it does now.
> 
> Signed-off-by: Robin Murphy <robin.murphy@arm.com>

Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

> ---
> 
> Found by inspection and compile-tested only
> 
>  drivers/crypto/marvell/cesa.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
> index 293832488cc9..f81fa4a3e66b 100644
> --- a/drivers/crypto/marvell/cesa.c
> +++ b/drivers/crypto/marvell/cesa.c
> @@ -15,6 +15,7 @@
>   */
>  
>  #include <linux/delay.h>
> +#include <linux/dma-mapping.h>
>  #include <linux/genalloc.h>
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
> @@ -409,8 +410,11 @@ static int mv_cesa_get_sram(struct platform_device *pdev, int idx)
>  	if (IS_ERR(engine->sram))
>  		return PTR_ERR(engine->sram);
>  
> -	engine->sram_dma = phys_to_dma(cesa->dev,
> -				       (phys_addr_t)res->start);
> +	engine->sram_dma = dma_map_resource(cesa->dev, res->start,
> +					    cesa->sram_size,
> +					    DMA_BIDIRECTIONAL, 0);
> +	if (dma_mapping_error(cesa->dev, engine->sram_dma))
> +		return -ENOMEM;
>  
>  	return 0;
>  }
> @@ -420,11 +424,12 @@ static void mv_cesa_put_sram(struct platform_device *pdev, int idx)
>  	struct mv_cesa_dev *cesa = platform_get_drvdata(pdev);
>  	struct mv_cesa_engine *engine = &cesa->engines[idx];
>  
> -	if (!engine->pool)
> -		return;
> -
> -	gen_pool_free(engine->pool, (unsigned long)engine->sram,
> -		      cesa->sram_size);
> +	if (engine->pool)
> +		gen_pool_free(engine->pool, (unsigned long)engine->sram,
> +			      cesa->sram_size);
> +	else
> +		dma_unmap_resource(cesa->dev, engine->sram_dma,
> +				   cesa->sram_size, DMA_BIDIRECTIONAL, 0);
>  }
>  
>  static int mv_cesa_probe(struct platform_device *pdev)
