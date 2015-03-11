From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/4] hwrng: omap - remove #ifdefery around PM methods
Date: Wed, 11 Mar 2015 21:59:57 +1100
Message-ID: <20150311105957.GA5351@gondor.apana.org.au>
References: <1425922598-16538-1-git-send-email-dmitry.torokhov@gmail.com>
 <1425922598-16538-2-git-send-email-dmitry.torokhov@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Deepak Saxena <dsaxena@plexity.net>,
	linux-kernel@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:58257 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbbCKLAK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Mar 2015 07:00:10 -0400
Content-Disposition: inline
In-Reply-To: <1425922598-16538-2-git-send-email-dmitry.torokhov@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 09, 2015 at 10:36:36AM -0700, Dmitry Torokhov wrote:
> Instead of using #ifdefs let's mark suspend and resume methods as
> __maybe_unused which will suppress compiler warnings about them being
> unused and provide better compile coverage. This will not increase image
> size.
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>  drivers/char/hw_random/omap-rng.c | 15 +++------------
>  1 file changed, 3 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
> index 7f3597d..5c171b1 100644
> --- a/drivers/char/hw_random/omap-rng.c
> +++ b/drivers/char/hw_random/omap-rng.c
> @@ -422,9 +422,7 @@ static int omap_rng_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> -#ifdef CONFIG_PM_SLEEP
> -
> -static int omap_rng_suspend(struct device *dev)
> +static int __maybe_unused omap_rng_suspend(struct device *dev)
>  {
>  	struct omap_rng_dev *priv = dev_get_drvdata(dev);
>  
> @@ -434,7 +432,7 @@ static int omap_rng_suspend(struct device *dev)
>  	return 0;
>  }
>  
> -static int omap_rng_resume(struct device *dev)
> +static int __maybe_unused omap_rng_resume(struct device *dev)
>  {
>  	struct omap_rng_dev *priv = dev_get_drvdata(dev);
>  
> @@ -445,18 +443,11 @@ static int omap_rng_resume(struct device *dev)
>  }
>  
>  static SIMPLE_DEV_PM_OPS(omap_rng_pm, omap_rng_suspend, omap_rng_resume);
> -#define	OMAP_RNG_PM	(&omap_rng_pm)
> -
> -#else
> -
> -#define	OMAP_RNG_PM	NULL
> -
> -#endif
>  
>  static struct platform_driver omap_rng_driver = {
>  	.driver = {
>  		.name		= "omap_rng",
> -		.pm		= OMAP_RNG_PM,
> +		.pm		= &omap_rng_pm,

This will cause omap_rng_suspend/omap_rng_resume to be referenced
always, thus rendering the __maybe_unused moot, no?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
