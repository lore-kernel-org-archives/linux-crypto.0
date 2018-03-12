From: Christophe LEROY <christophe.leroy@c-s.fr>
Subject: Re: [PATCH 2/2] crypto: talitos: Delete an error message for a failed
 memory allocation in talitos_edesc_alloc()
Date: Mon, 12 Mar 2018 15:13:04 +0100
Message-ID: <1dcf05e3-1552-68b6-96cf-c5b57cd68e03@c-s.fr>
References: <ad256dc9-a064-37f9-fb8e-aea22ba40a2b@users.sourceforge.net>
 <13bfdc03-1dee-2f1c-da8d-1e452f10c850@users.sourceforge.net>
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
In-Reply-To: <13bfdc03-1dee-2f1c-da8d-1e452f10c850@users.sourceforge.net>
Content-Language: fr
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



Le 12/03/2018 à 14:32, SF Markus Elfring a écrit :
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 12 Mar 2018 14:18:23 +0100
> 
> Omit an extra message for a memory allocation failure in this function.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>

> ---
>   drivers/crypto/talitos.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
> index a2271322db34..4c7318981d28 100644
> --- a/drivers/crypto/talitos.c
> +++ b/drivers/crypto/talitos.c
> @@ -1399,7 +1399,6 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
>   
>   	edesc = kmalloc(alloc_len, GFP_DMA | flags);
>   	if (!edesc) {
> -		dev_err(dev, "could not allocate edescriptor\n");
>   		err = ERR_PTR(-ENOMEM);
>   		goto error_sg;
>   	}
> 
