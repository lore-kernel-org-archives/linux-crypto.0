From: Daniel Thompson <daniel.thompson@linaro.org>
Subject: Re: [PATCH] hwrng: stm32: fix maybe uninitialized variable warning
Date: Fri, 27 May 2016 14:46:58 +0100
Message-ID: <fc45dc72-6dd9-071c-5bc0-c2ee01b99511@linaro.org>
References: <1464255297-21090-1-git-send-email-mcoquelin.stm32@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:33441 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960AbcE0NrB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 May 2016 09:47:01 -0400
Received: by mail-wm0-f54.google.com with SMTP id s131so4027182wme.0
        for <linux-crypto@vger.kernel.org>; Fri, 27 May 2016 06:47:01 -0700 (PDT)
In-Reply-To: <1464255297-21090-1-git-send-email-mcoquelin.stm32@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 26/05/16 10:34, Maxime Coquelin wrote:
> This patch fixes the following warning:
> drivers/char/hw_random/stm32-rng.c: In function 'stm32_rng_read':
> drivers/char/hw_random/stm32-rng.c:82:19: warning: 'sr' may be used
>                                         uninitialized in this function
>
> Reported-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Daniel Thompson <daniel.thompson@linaro.org>

Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>


> Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
> ---
>  drivers/char/hw_random/stm32-rng.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
> index 92a810648bd0..63d84e6f1891 100644
> --- a/drivers/char/hw_random/stm32-rng.c
> +++ b/drivers/char/hw_random/stm32-rng.c
> @@ -69,8 +69,12 @@ static int stm32_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
>  		}
>
>  		/* If error detected or data not ready... */
> -		if (sr != RNG_SR_DRDY)
> +		if (sr != RNG_SR_DRDY) {
> +			if (WARN_ONCE(sr & (RNG_SR_SEIS | RNG_SR_CEIS),
> +					"bad RNG status - %x\n", sr))
> +				writel_relaxed(0, priv->base + RNG_SR);
>  			break;
> +		}
>
>  		*(u32 *)data = readl_relaxed(priv->base + RNG_DR);
>
> @@ -79,10 +83,6 @@ static int stm32_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
>  		max -= sizeof(u32);
>  	}
>
> -	if (WARN_ONCE(sr & (RNG_SR_SEIS | RNG_SR_CEIS),
> -		      "bad RNG status - %x\n", sr))
> -		writel_relaxed(0, priv->base + RNG_SR);
> -
>  	pm_runtime_mark_last_busy((struct device *) priv->rng.priv);
>  	pm_runtime_put_sync_autosuspend((struct device *) priv->rng.priv);
>
>
