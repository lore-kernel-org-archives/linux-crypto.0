From: Shannon Nelson <shannon.nelson@oracle.com>
Subject: Re: [PATCH 2/2] n2rng: Combine substrings for two messages in
 n2rng_probe()
Date: Wed, 19 Apr 2017 08:24:49 -0700
Message-ID: <1596e654-4b56-cf62-c5da-491dadb564b4@oracle.com>
References: <4d9fbb01-e12f-eb5c-7ecd-5a2a10fd5110@users.sourceforge.net>
 <fef1883c-4338-5f8a-5dfe-e970b424fbc5@users.sourceforge.net>
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
Received: from userp1040.oracle.com ([156.151.31.81]:19804 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937158AbdDSPYl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Apr 2017 11:24:41 -0400
In-Reply-To: <fef1883c-4338-5f8a-5dfe-e970b424fbc5@users.sourceforge.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 4/19/2017 2:11 AM, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 19 Apr 2017 10:50:04 +0200
>
> The script "checkpatch.pl" pointed information out like the following.
>
> WARNING: quoted string split across lines
>
> Thus fix the affected source code places.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Thanks Markus.

Acked-by: Shannon Nelson <shannon.nelson@oracle.com>


> ---
>  drivers/char/hw_random/n2-drv.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/char/hw_random/n2-drv.c b/drivers/char/hw_random/n2-drv.c
> index 92dd4e925315..f3e67c768101 100644
> --- a/drivers/char/hw_random/n2-drv.c
> +++ b/drivers/char/hw_random/n2-drv.c
> @@ -723,16 +723,16 @@ static int n2rng_probe(struct platform_device *op)
>  		if (sun4v_hvapi_register(HV_GRP_RNG,
>  					 np->hvapi_major,
>  					 &np->hvapi_minor)) {
> -			dev_err(&op->dev, "Cannot register suitable "
> -				"HVAPI version.\n");
> +			dev_err(&op->dev,
> +				"Cannot register suitable HVAPI version.\n");
>  			goto out;
>  		}
>  	}
>
>  	if (np->flags & N2RNG_FLAG_MULTI) {
>  		if (np->hvapi_major < 2) {
> -			dev_err(&op->dev, "multi-unit-capable RNG requires "
> -				"HVAPI major version 2 or later, got %lu\n",
> +			dev_err(&op->dev,
> +				"multi-unit-capable RNG requires HVAPI major version 2 or later, got %lu\n",
>  				np->hvapi_major);
>  			goto out_hvapi_unregister;
>  		}
>
