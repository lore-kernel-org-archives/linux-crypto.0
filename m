From: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH v2] char: hw_random: atmel-rng: disable TRNG during
 suspend
Date: Tue, 25 Oct 2016 10:49:55 +0200
Message-ID: <231367f2-03e2-5bf3-2358-135fec438676@atmel.com>
References: <1477356993-27778-1-git-send-email-wenyou.yang@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Cc: <linux-crypto@vger.kernel.org>,
        Wenyou Yang <wenyou.yang@microchip.com>,
        <linux-arm-kernel@lists.infradead.org>
To: Wenyou Yang <wenyou.yang@atmel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Matt Mackall <mpm@selenic.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:12494 "EHLO
        eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758525AbcJYIuA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Oct 2016 04:50:00 -0400
In-Reply-To: <1477356993-27778-1-git-send-email-wenyou.yang@atmel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Le 25/10/2016 à 02:56, Wenyou Yang a écrit :
> To fix the over consumption on the VDDCore due to the TRNG enabled,
> disable the TRNG during suspend, not only disable the user interface
> clock (which is controlled by PMC). Because the user interface clock
> is independent from any clock that may be used in the entropy source
> logic circuitry.
> 
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thanks

> ---
> 
> Changes in v2:
>  - Enable the user interface first, then enable the internal clock
>    when resume.
> 
>  drivers/char/hw_random/atmel-rng.c | 24 +++++++++++++++++++++---
>  1 file changed, 21 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/atmel-rng.c
> index 0fcc9e6..ae7cae5 100644
> --- a/drivers/char/hw_random/atmel-rng.c
> +++ b/drivers/char/hw_random/atmel-rng.c
> @@ -48,6 +48,16 @@ static int atmel_trng_read(struct hwrng *rng, void *buf, size_t max,
>  		return 0;
>  }
>  
> +static void atmel_trng_enable(struct atmel_trng *trng)
> +{
> +	writel(TRNG_KEY | 1, trng->base + TRNG_CR);
> +}
> +
> +static void atmel_trng_disable(struct atmel_trng *trng)
> +{
> +	writel(TRNG_KEY, trng->base + TRNG_CR);
> +}
> +
>  static int atmel_trng_probe(struct platform_device *pdev)
>  {
>  	struct atmel_trng *trng;
> @@ -71,7 +81,7 @@ static int atmel_trng_probe(struct platform_device *pdev)
>  	if (ret)
>  		return ret;
>  
> -	writel(TRNG_KEY | 1, trng->base + TRNG_CR);
> +	atmel_trng_enable(trng);
>  	trng->rng.name = pdev->name;
>  	trng->rng.read = atmel_trng_read;
>  
> @@ -94,7 +104,7 @@ static int atmel_trng_remove(struct platform_device *pdev)
>  
>  	hwrng_unregister(&trng->rng);
>  
> -	writel(TRNG_KEY, trng->base + TRNG_CR);
> +	atmel_trng_disable(trng);
>  	clk_disable_unprepare(trng->clk);
>  
>  	return 0;
> @@ -105,6 +115,7 @@ static int atmel_trng_suspend(struct device *dev)
>  {
>  	struct atmel_trng *trng = dev_get_drvdata(dev);
>  
> +	atmel_trng_disable(trng);
>  	clk_disable_unprepare(trng->clk);
>  
>  	return 0;
> @@ -113,8 +124,15 @@ static int atmel_trng_suspend(struct device *dev)
>  static int atmel_trng_resume(struct device *dev)
>  {
>  	struct atmel_trng *trng = dev_get_drvdata(dev);
> +	int ret;
> +
> +	ret = clk_prepare_enable(trng->clk);
> +	if (ret)
> +		return ret;
>  
> -	return clk_prepare_enable(trng->clk);
> +	atmel_trng_enable(trng);
> +
> +	return 0;
>  }
>  
>  static const struct dev_pm_ops atmel_trng_pm_ops = {
> 


-- 
Nicolas Ferre
