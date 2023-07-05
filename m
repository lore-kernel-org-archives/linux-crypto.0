Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60097EB64DD
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Jul 2023 05:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjGEFOm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Jul 2023 01:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjGEFOl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Jul 2023 01:14:41 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E032C1700
        for <linux-crypto@vger.kernel.org>; Tue,  4 Jul 2023 22:14:40 -0700 (PDT)
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=drumknott)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <rcz@pengutronix.de>)
        id 1qGuqc-0000A5-Jx; Wed, 05 Jul 2023 07:14:38 +0200
Date:   Wed, 5 Jul 2023 07:14:31 +0200
From:   Rouven Czerwinski <rcz@pengutronix.de>
To:     Martin Kaiser <martin@kaiser.cx>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: imx-rngc - use dev_err_probe
Message-ID: <20230705071431.7487e285@drumknott>
In-Reply-To: <20230704170644.69669-1-martin@kaiser.cx>
References: <20230704170644.69669-1-martin@kaiser.cx>
Organization: Pengutronix e.K.
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: rcz@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue,  4 Jul 2023 19:06:44 +0200
Martin Kaiser <martin@kaiser.cx> wrote:

> Simplify the code by calling dev_err_probe instead of dev_err and
> return.
> 
> While at it, use the same device for all error messages.
> 
> Signed-off-by: Martin Kaiser <martin@kaiser.cx>

Reviewed-by: Rouven Czerwinski <r.czerwinskis@pengutronix.de>

> ---
>  drivers/char/hw_random/imx-rngc.c | 24 ++++++++----------------
>  1 file changed, 8 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/char/hw_random/imx-rngc.c
> b/drivers/char/hw_random/imx-rngc.c index bf07f17f78c8..e4b385b01b11
> 100644 --- a/drivers/char/hw_random/imx-rngc.c
> +++ b/drivers/char/hw_random/imx-rngc.c
> @@ -239,10 +239,8 @@ static int __init imx_rngc_probe(struct
> platform_device *pdev) return PTR_ERR(rngc->base);
>  
>  	rngc->clk = devm_clk_get_enabled(&pdev->dev, NULL);
> -	if (IS_ERR(rngc->clk)) {
> -		dev_err(&pdev->dev, "Can not get rng_clk\n");
> -		return PTR_ERR(rngc->clk);
> -	}
> +	if (IS_ERR(rngc->clk))
> +		return dev_err_probe(&pdev->dev, PTR_ERR(rngc->clk),
> "Cannot get rng_clk\n"); 
>  	irq = platform_get_irq(pdev, 0);
>  	if (irq < 0)
> @@ -272,24 +270,18 @@ static int __init imx_rngc_probe(struct
> platform_device *pdev) 
>  	ret = devm_request_irq(&pdev->dev,
>  			irq, imx_rngc_irq, 0, pdev->name, (void
> *)rngc);
> -	if (ret) {
> -		dev_err(rngc->dev, "Can't get interrupt working.\n");
> -		return ret;
> -	}
> +	if (ret)
> +		return dev_err_probe(&pdev->dev, ret, "Can't get
> interrupt working.\n"); 
>  	if (self_test) {
>  		ret = imx_rngc_self_test(rngc);
> -		if (ret) {
> -			dev_err(rngc->dev, "self test failed\n");
> -			return ret;
> -		}
> +		if (ret)
> +			return dev_err_probe(&pdev->dev, ret, "self
> test failed\n"); }
>  
>  	ret = devm_hwrng_register(&pdev->dev, &rngc->rng);
> -	if (ret) {
> -		dev_err(&pdev->dev, "hwrng registration failed\n");
> -		return ret;
> -	}
> +	if (ret)
> +		return dev_err_probe(&pdev->dev, ret, "hwrng
> registration failed\n"); 
>  	dev_info(&pdev->dev,
>  		"Freescale RNG%c registered (HW revision %d.%02d)\n",

