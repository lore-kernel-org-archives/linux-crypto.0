From: Shannon Nelson <shannon.nelson@oracle.com>
Subject: Re: [PATCH 1/2] n2rng: Use devm_kcalloc() in n2rng_probe()
Date: Wed, 19 Apr 2017 08:24:33 -0700
Message-ID: <1e83c451-4410-8f47-08b6-87f8f59ba5f1@oracle.com>
References: <4d9fbb01-e12f-eb5c-7ecd-5a2a10fd5110@users.sourceforge.net>
 <38c41219-7e7f-3a3e-29dd-04ae2d57beaa@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Matt Mackall <mpm@selenic.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19801 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935244AbdDSPYg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Apr 2017 11:24:36 -0400
In-Reply-To: <38c41219-7e7f-3a3e-29dd-04ae2d57beaa@users.sourceforge.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 4/19/2017 2:10 AM, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 19 Apr 2017 10:30:47 +0200
>
> * A multiplication for the size determination of a memory allocation
>   indicated that an array data structure should be processed.
>   Thus use the corresponding function "devm_kcalloc".
>
> * Replace the specification of a data structure by a pointer dereference
>   to make the corresponding size determination a bit safer according to
>   the Linux coding style convention.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Thanks Markus.

Acked-by: Shannon Nelson <shannon.nelson@oracle.com>

> ---
>  drivers/char/hw_random/n2-drv.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/char/hw_random/n2-drv.c b/drivers/char/hw_random/n2-drv.c
> index 31cbdbbaebfc..92dd4e925315 100644
> --- a/drivers/char/hw_random/n2-drv.c
> +++ b/drivers/char/hw_random/n2-drv.c
> @@ -748,9 +748,7 @@ static int n2rng_probe(struct platform_device *op)
>
>  	dev_info(&op->dev, "Registered RNG HVAPI major %lu minor %lu\n",
>  		 np->hvapi_major, np->hvapi_minor);
> -
> -	np->units = devm_kzalloc(&op->dev,
> -				 sizeof(struct n2rng_unit) * np->num_units,
> +	np->units = devm_kcalloc(&op->dev, np->num_units, sizeof(*np->units),
>  				 GFP_KERNEL);
>  	err = -ENOMEM;
>  	if (!np->units)
>
