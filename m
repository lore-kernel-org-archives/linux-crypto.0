From: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH -next] hwrng: atmel - use clk_disable_unprepare instead of
 clk_disable
Date: Mon, 14 Nov 2016 09:02:28 +0100
Message-ID: <b8d6676b-127b-804e-0d77-e4defcdfdff2@atmel.com>
References: <1478876207-29820-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Cc: Wei Yongjun <weiyongjun1@huawei.com>,
        <linux-crypto@vger.kernel.org>
To: Wei Yongjun <weiyj.lk@gmail.com>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Wenyou Yang <wenyou.yang@atmel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:29131 "EHLO
        eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752244AbcKNIDL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Nov 2016 03:03:11 -0500
In-Reply-To: <1478876207-29820-1-git-send-email-weiyj.lk@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Le 11/11/2016 à 15:56, Wei Yongjun a écrit :
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> Since clk_prepare_enable() is used to get trng->clk, we should
> use clk_disable_unprepare() to release it for the error path.
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thank you.

Best regards,

> ---
>  drivers/char/hw_random/atmel-rng.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/atmel-rng.c
> index ae7cae5..661c82c 100644
> --- a/drivers/char/hw_random/atmel-rng.c
> +++ b/drivers/char/hw_random/atmel-rng.c
> @@ -94,7 +94,7 @@ static int atmel_trng_probe(struct platform_device *pdev)
>  	return 0;
>  
>  err_register:
> -	clk_disable(trng->clk);
> +	clk_disable_unprepare(trng->clk);
>  	return ret;
>  }
> 
> 


-- 
Nicolas Ferre
