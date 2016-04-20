From: Vladimir Zapolskiy <vz@mleia.com>
Subject: Re: [PATCH 1/2] crypto: s5p-sss - Fix use after free of copied input
 buffer in error path
Date: Wed, 20 Apr 2016 13:03:43 +0300
Message-ID: <571753FF.9080405@mleia.com>
References: <1461073452-10426-1-git-send-email-k.kozlowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mleia.com ([178.79.152.223]:51036 "EHLO mail.mleia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933282AbcDTKDs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 Apr 2016 06:03:48 -0400
In-Reply-To: <1461073452-10426-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Krzysztof,

On 19.04.2016 16:44, Krzysztof Kozlowski wrote:
> The driver makes copies of memory (input or output scatterlists) if they
> are not aligned. In s5p_aes_crypt_start() error path (on unsuccessful
> initialization of output scatterlist), if input scatterlist was not
> aligned, the driver first freed copied input memory and then unmapped it
> from the device, instead of doing otherwise (unmap and then free).
> 
> This was wrong in two ways:
> 1. Freed pages were still mapped to the device.
> 2. The dma_unmap_sg() iterated over freed scatterlist structure.
> 
> The call to s5p_free_sg_cpy() in this error path is not needed because
> the copied scatterlists will be freed by s5p_aes_complete().
> 
> Fixes: 9e4a1100a445 ("crypto: s5p-sss - Handle unaligned buffers")
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

I see that Herbert have just applied the changes, but anyway I reviewed
them and they are good in my opinion.

Acked-by: Vladimir Zapolskiy <vz@mleia.com>

> ---
>  drivers/crypto/s5p-sss.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index 4f6d5b3ec418..b0484d4d68d9 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c
> @@ -577,7 +577,6 @@ static void s5p_aes_crypt_start(struct s5p_aes_dev *dev, unsigned long mode)
>  	return;
>  
>  outdata_error:
> -	s5p_free_sg_cpy(dev, &dev->sg_src_cpy);
>  	s5p_unset_indata(dev);
>  
>  indata_error:
> 

--
With best wishes,
Vladimir
