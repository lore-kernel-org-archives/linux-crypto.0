From: Tobias Karnat <tobias.karnat@googlemail.com>
Subject: Re: [PATCH 01/16] crypto: omap-aes: don't treat NULL clk as an
 error
Date: Thu, 13 Jan 2011 03:25:45 +0100
Message-ID: <1294885545.12923.20.camel@Tobias-Karnat>
References: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
	 <1294749833-32019-2-git-send-email-jamie@jamieiles.com>
	 <1294861135.14458.5.camel@Tobias-Karnat>
	 <20110112215140.GA2822@pulham.picochip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
	Aaro Koskinen <aaro.koskinen@nokia.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Jamie Iles <jamie@jamieiles.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53827 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932604Ab1AMCZt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Jan 2011 21:25:49 -0500
In-Reply-To: <20110112215140.GA2822@pulham.picochip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, den 12.01.2011, 21:51 +0000 schrieb Jamie Iles:
> Doh!  Good spot, thanks.  I've checked the rest of the series and this 
> was the only patch with the duplicated include.

It can happen, thanks.

-Tobias

> 8<-------------------------------------------------------------------
> 
> >From 75cef47f02ea19b94203f287eaaddc644c51ce30 Mon Sep 17 00:00:00 2001
> From: Jamie Iles <jamie@jamieiles.com>
> Date: Tue, 11 Jan 2011 09:48:26 +0000
> Subject: [PATCH] crypto: omap-aes: don't treat NULL clk as an error
> 
> clk_get() returns a struct clk cookie to the driver and some platforms
> may return NULL if they only support a single clock.  clk_get() has only
> failed if it returns a ERR_PTR() encoded pointer.
> 
> Cc: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
Reviewed-and-tested-by: Tobias Karnat <tobias.karnat@googlemail.com>
> ---
>  drivers/crypto/omap-aes.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
> index 799ca51..10a9180 100644
> --- a/drivers/crypto/omap-aes.c
> +++ b/drivers/crypto/omap-aes.c
> @@ -830,9 +830,9 @@ static int omap_aes_probe(struct platform_device *pdev)
>  
>  	/* Initializing the clock */
>  	dd->iclk = clk_get(dev, "ick");
> -	if (!dd->iclk) {
> +	if (IS_ERR(dd->iclk)) {
>  		dev_err(dev, "clock intialization failed.\n");
> -		err = -ENODEV;
> +		err = PTR_ERR(dd->iclk);
>  		goto err_res;
>  	}
>  
