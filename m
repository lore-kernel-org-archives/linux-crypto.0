From: Joel Fernandes <joelf@ti.com>
Subject: Re: [PATCH V2] crypto: omap-des - use devm_ioremap_resource()
Date: Wed, 9 Apr 2014 10:35:32 -0500
Message-ID: <534568C4.8070102@ti.com>
References: <001d01cf4ed2$494fd0e0$dbef72a0$%han@samsung.com> <008301cf52e6$9b764990$d262dcb0$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "'David Miller'" <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>
To: Jingoo Han <jg1.han@samsung.com>,
	"'Herbert Xu'" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:39071 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932786AbaDIPfo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Apr 2014 11:35:44 -0400
In-Reply-To: <008301cf52e6$9b764990$d262dcb0$%han@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 04/07/2014 11:54 PM, Jingoo Han wrote:
> Use devm_ioremap_resource() because devm_request_and_ioremap() is
> obsoleted by devm_ioremap_resource().
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
> Changes since v1:
> - remove unnecessary error message, because devm_ioremap_resource()
>   already prints one in all failure cases.
> 
>  drivers/crypto/omap-des.c |    7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
> index ec5f131..4a13624 100644
> --- a/drivers/crypto/omap-des.c
> +++ b/drivers/crypto/omap-des.c
> @@ -1074,10 +1074,9 @@ static int omap_des_probe(struct platform_device *pdev)
>  	if (err)
>  		goto err_res;
>  
> -	dd->io_base = devm_request_and_ioremap(dev, res);
> -	if (!dd->io_base) {
> -		dev_err(dev, "can't ioremap\n");
> -		err = -ENOMEM;
> +	dd->io_base = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(dd->io_base)) {
> +		err = PTR_ERR(dd->io_base);
>  		goto err_res;
>  	}
>  	dd->phys_base = res->start;
> 


Acked-by: Joel Fernandes <joelf@ti.com>

Thanks,

-Joel
