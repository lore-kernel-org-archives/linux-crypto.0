From: Joel Fernandes <joelf@ti.com>
Subject: Re: [PATCH] crypto: omap-des - make local functions static
Date: Thu, 27 Feb 2014 18:59:48 -0600
Message-ID: <530FDF84.6060705@ti.com>
References: <000701cf33af$e46a9f80$ad3fde80$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "'David Miller'" <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>
To: Jingoo Han <jg1.han@samsung.com>,
	"'Herbert Xu'" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:54774 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbaB1BAC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Feb 2014 20:00:02 -0500
In-Reply-To: <000701cf33af$e46a9f80$ad3fde80$%han@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/27/2014 05:34 AM, Jingoo Han wrote:
> Make omap_des_copy_needed(), omap_des_copy_sgs(), because these
> functions are used only in this file.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Ok with me,
Acked-by: Joel Fernandes <joelf@ti.com>

> ---
>  drivers/crypto/omap-des.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
> index 758919e..ec5f131 100644
> --- a/drivers/crypto/omap-des.c
> +++ b/drivers/crypto/omap-des.c
> @@ -535,7 +535,7 @@ static int omap_des_crypt_dma_stop(struct omap_des_dev *dd)
>  	return err;
>  }
>  
> -int omap_des_copy_needed(struct scatterlist *sg)
> +static int omap_des_copy_needed(struct scatterlist *sg)
>  {
>  	while (sg) {
>  		if (!IS_ALIGNED(sg->offset, 4))
> @@ -547,7 +547,7 @@ int omap_des_copy_needed(struct scatterlist *sg)
>  	return 0;
>  }
>  
> -int omap_des_copy_sgs(struct omap_des_dev *dd)
> +static int omap_des_copy_sgs(struct omap_des_dev *dd)
>  {
>  	void *buf_in, *buf_out;
>  	int pages;
> 
