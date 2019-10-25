Return-Path: <SRS0=9dQ/=YS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E5CCCA9EA0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 08:01:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E3B021929
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 08:01:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437561AbfJYIBr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Oct 2019 04:01:47 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:46021 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730337AbfJYIBr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Oct 2019 04:01:47 -0400
X-Originating-IP: 86.202.229.42
Received: from localhost (lfbn-lyo-1-146-42.w86-202.abo.wanadoo.fr [86.202.229.42])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 28521FF811;
        Fri, 25 Oct 2019 08:01:41 +0000 (UTC)
Date:   Fri, 25 Oct 2019 10:01:36 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mpm@selenic.com, herbert@gondor.apana.org.au, robh+dt@kernel.org,
        mark.rutland@arm.com, nicolas.ferre@microchip.com,
        ludovic.desroches@microchip.com, arnd@arndb.de,
        Tudor.Ambarus@microchip.com
Subject: Re: [PATCH 2/2] hwrng: atmel: add new platform support for sam9x60
Message-ID: <20191025080136.GA3125@piout.net>
References: <20191024170452.2145-1-codrin.ciubotariu@microchip.com>
 <20191024170452.2145-2-codrin.ciubotariu@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024170452.2145-2-codrin.ciubotariu@microchip.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 24/10/2019 20:04:52+0300, Codrin Ciubotariu wrote:
> Add platform support for the new IP found on sam9x60 SoC. For this
> version, if the peripheral clk is above 100MHz, the HALFR bit must be
> set. This bit is available only if the IP can generate a random number
> every 168 cycles (instead of 84).
> 
> Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
> ---
>  drivers/char/hw_random/atmel-rng.c | 39 ++++++++++++++++++++++++++++--
>  1 file changed, 37 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/atmel-rng.c
> index e55705745d5e..0aa9425e6c3e 100644
> --- a/drivers/char/hw_random/atmel-rng.c
> +++ b/drivers/char/hw_random/atmel-rng.c
> @@ -14,14 +14,22 @@
>  #include <linux/clk.h>
>  #include <linux/io.h>
>  #include <linux/hw_random.h>
> +#include <linux/of_device.h>
>  #include <linux/platform_device.h>
>  
>  #define TRNG_CR		0x00
> +#define TRNG_MR		0x04
>  #define TRNG_ISR	0x1c
>  #define TRNG_ODATA	0x50
>  
>  #define TRNG_KEY	0x524e4700 /* RNG */
>  
> +#define TRNG_HALFR	BIT(0) /* generate RN every 168 cycles */
> +
> +struct atmel_trng_pdata {

Could that be just atmel_trng_data?

There is no platform data in this driver and it is DT only.

> +	bool has_half_rate;
> +};
> +
>  struct atmel_trng {
>  	struct clk *clk;
>  	void __iomem *base;
> @@ -63,6 +71,7 @@ static int atmel_trng_probe(struct platform_device *pdev)
>  {
>  	struct atmel_trng *trng;
>  	struct resource *res;
> +	const struct atmel_trng_pdata *pdata;
>  	int ret;
>  
>  	trng = devm_kzalloc(&pdev->dev, sizeof(*trng), GFP_KERNEL);
> @@ -77,6 +86,17 @@ static int atmel_trng_probe(struct platform_device *pdev)
>  	trng->clk = devm_clk_get(&pdev->dev, NULL);
>  	if (IS_ERR(trng->clk))
>  		return PTR_ERR(trng->clk);
> +	pdata = of_device_get_match_data(&pdev->dev);
> +	if (!pdata)
> +		return -ENODEV;
> +
> +	if (pdata->has_half_rate) {
> +		unsigned long rate = clk_get_rate(trng->clk);
> +
> +		/* if peripheral clk is above 100MHz, set HALFR */
> +		if (rate > 100000000)
> +			writel(TRNG_HALFR, trng->base + TRNG_MR);
> +	}
>  
>  	ret = clk_prepare_enable(trng->clk);
>  	if (ret)
> @@ -141,9 +161,24 @@ static const struct dev_pm_ops atmel_trng_pm_ops = {
>  };
>  #endif /* CONFIG_PM */
>  
> +static struct atmel_trng_pdata at91sam9g45_config = {
> +	.has_half_rate = false,
> +};
> +
> +static struct atmel_trng_pdata sam9x60_config = {
> +	.has_half_rate = true,
> +};
> +
>  static const struct of_device_id atmel_trng_dt_ids[] = {
> -	{ .compatible = "atmel,at91sam9g45-trng" },
> -	{ /* sentinel */ }
> +	{
> +		.compatible = "atmel,at91sam9g45-trng",
> +		.data = &at91sam9g45_config,
> +	}, {
> +		.compatible = "microchip,sam9x60-trng",
> +		.data = &sam9x60_config,
> +	}, {
> +		/* sentinel */
> +	}
>  };
>  MODULE_DEVICE_TABLE(of, atmel_trng_dt_ids);
>  
> -- 
> 2.20.1
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
