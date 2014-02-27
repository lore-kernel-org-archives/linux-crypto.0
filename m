From: Nishanth Menon <nm@ti.com>
Subject: Re: [PATCH 1/3] crypto: omap-aes - Use SIMPLE_DEV_PM_OPS macro
Date: Thu, 27 Feb 2014 09:05:14 -0600
Message-ID: <530F542A.8040606@ti.com>
References: <000301cf33af$7ad7cc50$708764f0$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "'David Miller'" <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, "'Joel Fernandes'" <joelf@ti.com>
To: Jingoo Han <jg1.han@samsung.com>,
	"'Herbert Xu'" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:43902 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbaB0PFZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Feb 2014 10:05:25 -0500
In-Reply-To: <000301cf33af$7ad7cc50$708764f0$%han@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/27/2014 05:31 AM, Jingoo Han wrote:
> Use SIMPLE_DEV_PM_OPS macro in order to make the code simpler.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/crypto/omap-aes.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
> index dde41f1d..cb98fa5 100644
> --- a/drivers/crypto/omap-aes.c
> +++ b/drivers/crypto/omap-aes.c
> @@ -1307,9 +1307,7 @@ static int omap_aes_resume(struct device *dev)
>  }
>  #endif
>  
> -static const struct dev_pm_ops omap_aes_pm_ops = {
> -	SET_SYSTEM_SLEEP_PM_OPS(omap_aes_suspend, omap_aes_resume)
> -};
> +static SIMPLE_DEV_PM_OPS(omap_aes_pm_ops, omap_aes_suspend, omap_aes_resume);
>  
>  static struct platform_driver omap_aes_driver = {
>  	.probe	= omap_aes_probe,
> 

looks good to me,
Acked-by: Nishanth Menon <nm@ti.com>

-- 
Regards,
Nishanth Menon
