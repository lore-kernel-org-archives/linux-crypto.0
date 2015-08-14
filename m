From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: amcc: Do a NULL check for pointer
Date: Fri, 14 Aug 2015 11:08:14 +0800
Message-ID: <20150814030814.GA1220@gondor.apana.org.au>
References: <1439521558-17214-1-git-send-email-festevam@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
To: Fabio Estevam <festevam@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54757 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbbHNDIS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Aug 2015 23:08:18 -0400
Content-Disposition: inline
In-Reply-To: <1439521558-17214-1-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 14, 2015 at 12:05:58AM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Compare pointer-typed values to NULL rather than 0.
> 
> The semantic patch that makes this change is available
> in scripts/coccinelle/null/badzero.cocci
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/crypto/amcc/crypto4xx_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
> index 3b28e8c..47c4b08 100644
> --- a/drivers/crypto/amcc/crypto4xx_core.c
> +++ b/drivers/crypto/amcc/crypto4xx_core.c
> @@ -1113,7 +1113,7 @@ static irqreturn_t crypto4xx_ce_interrupt_handler(int irq, void *data)
>  	struct device *dev = (struct device *)data;
>  	struct crypto4xx_core_device *core_dev = dev_get_drvdata(dev);
>  
> -	if (core_dev->dev->ce_base == 0)
> +	if (core_dev->dev->ce_base == NULL)

Please use ! instead.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
