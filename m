From: Christophe LEROY <christophe.leroy@c-s.fr>
Subject: Re: [PATCH 1/2] crypto: talitos: Use common error handling code in
 talitos_edesc_alloc()
Date: Mon, 12 Mar 2018 15:12:29 +0100
Message-ID: <09aa55b5-1535-b5ce-0682-3c51fdf18387@c-s.fr>
References: <ad256dc9-a064-37f9-fb8e-aea22ba40a2b@users.sourceforge.net>
 <330e4ffc-64dc-5474-4c84-916561cf0783@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <330e4ffc-64dc-5474-4c84-916561cf0783@users.sourceforge.net>
Content-Language: fr
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



Le 12/03/2018 à 14:31, SF Markus Elfring a écrit :
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 12 Mar 2018 14:08:55 +0100
> 
> Add jump targets so that an error message and the setting of a specific
> error code is stored only once at the end of this function.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>   drivers/crypto/talitos.c | 24 ++++++++++++------------
>   1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
> index 6882fa2f8bad..a2271322db34 100644
> --- a/drivers/crypto/talitos.c
> +++ b/drivers/crypto/talitos.c
> @@ -1352,29 +1352,24 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
>   	if (!dst || dst == src) {
>   		src_len = assoclen + cryptlen + authsize;
>   		src_nents = sg_nents_for_len(src, src_len);
> -		if (src_nents < 0) {
> -			dev_err(dev, "Invalid number of src SG.\n");

I don't think this is a good idea to move this dev_err(), just because
the text is identical twice.
The code is more clear when the text of the error is at the error.
Also, as this text is for the case where SRC SG is identical to DST SG,
the text could instead be "Invalid number of SG"

> -			err = ERR_PTR(-EINVAL);
> -			goto error_sg;
> -		}
> +		if (src_nents < 0)
> +			goto report_failure;
> +
>   		src_nents = (src_nents == 1) ? 0 : src_nents;
>   		dst_nents = dst ? src_nents : 0;
>   		dst_len = 0;
>   	} else { /* dst && dst != src*/
>   		src_len = assoclen + cryptlen + (encrypt ? 0 : authsize);
>   		src_nents = sg_nents_for_len(src, src_len);
> -		if (src_nents < 0) {
> -			dev_err(dev, "Invalid number of src SG.\n");
> -			err = ERR_PTR(-EINVAL);
> -			goto error_sg;
> -		}
> +		if (src_nents < 0)
> +			goto report_failure;
> +
>   		src_nents = (src_nents == 1) ? 0 : src_nents;
>   		dst_len = assoclen + cryptlen + (encrypt ? authsize : 0);
>   		dst_nents = sg_nents_for_len(dst, dst_len);
>   		if (dst_nents < 0) {
>   			dev_err(dev, "Invalid number of dst SG.\n");

To be consistant, this one should also go at the end if we want to be 
consistant.

> -			err = ERR_PTR(-EINVAL);
> -			goto error_sg;
> +			goto set_error_code;
>   		}
>   		dst_nents = (dst_nents == 1) ? 0 : dst_nents;
>   	}
> @@ -1424,6 +1419,11 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
>   						     DMA_BIDIRECTIONAL);
>   	}
>   	return edesc;
> +
> +report_failure:
> +	dev_err(dev, "Invalid number of src SG.\n");
> +set_error_code:
> +	err = ERR_PTR(-EINVAL);
>   error_sg:
>   	if (iv_dma)
>   		dma_unmap_single(dev, iv_dma, ivsize, DMA_TO_DEVICE);
> 

Another solution could be to move the dma_map_single() of iv_dma after 
the kmalloc(), in that case we could directly return from the other 
error cases instead of having the unmap iv_dma first.

Christophe
