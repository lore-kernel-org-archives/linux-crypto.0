From: Tobias Karnat <tobias.karnat@googlemail.com>
Subject: Re: [PATCH 01/16] crypto: omap-aes: don't treat NULL clk as an
 error
Date: Wed, 12 Jan 2011 20:38:55 +0100
Message-ID: <1294861135.14458.5.camel@Tobias-Karnat>
References: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
	 <1294749833-32019-2-git-send-email-jamie@jamieiles.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
	Aaro Koskinen <aaro.koskinen@nokia.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Jamie Iles <jamie@jamieiles.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:32912 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab1ALTjW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Jan 2011 14:39:22 -0500
In-Reply-To: <1294749833-32019-2-git-send-email-jamie@jamieiles.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

You have included linux/err.h a second time.

-Tobias

Am Dienstag, den 11.01.2011, 12:43 +0000 schrieb Jamie Iles:
> clk_get() returns a struct clk cookie to the driver and some platforms
> may return NULL if they only support a single clock.  clk_get() has only
> failed if it returns a ERR_PTR() encoded pointer.
> 
> Cc: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> ---
>  drivers/crypto/omap-aes.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
> index 799ca51..24d0f3f 100644
> --- a/drivers/crypto/omap-aes.c
> +++ b/drivers/crypto/omap-aes.c
> @@ -17,6 +17,7 @@
>  #include <linux/err.h>
>  #include <linux/module.h>
>  #include <linux/init.h>
> +#include <linux/err.h>
>  #include <linux/errno.h>
>  #include <linux/kernel.h>
>  #include <linux/clk.h>
> @@ -830,9 +831,9 @@ static int omap_aes_probe(struct platform_device *pdev)
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
