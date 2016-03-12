From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: Re: [PATCH 5/5] hwrng: exynos - Disable runtime PM on driver unbind
Date: Sat, 12 Mar 2016 14:26:31 +0900
Message-ID: <56E3A887.1000807@samsung.com>
References: <1457682562-21219-1-git-send-email-k.kozlowski@samsung.com>
 <1457682562-21219-5-git-send-email-k.kozlowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Cc: k.kozlowski.k@gmail.com
To: Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Kukjin Kim <kgene@kernel.org>, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <1457682562-21219-5-git-send-email-k.kozlowski@samsung.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

W dniu 11.03.2016 o 16:49, Krzysztof Kozlowski pisze:
> Driver enabled runtime PM but did not revert this on removal. Re-binding
> of a device triggered warning:
> 	exynos-rng 10830400.rng: Unbalanced pm_runtime_enable!
> 
> Fixes: b329669ea0b5 ("hwrng: exynos - Add support for Exynos random number generator")
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/char/hw_random/exynos-rng.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/char/hw_random/exynos-rng.c b/drivers/char/hw_random/exynos-rng.c
> index 68c349bf66a0..cba1ff538c46 100644
> --- a/drivers/char/hw_random/exynos-rng.c
> +++ b/drivers/char/hw_random/exynos-rng.c
> @@ -154,6 +154,13 @@ static int exynos_rng_probe(struct platform_device *pdev)
>  	return ret;
>  }
>  
> +static int exynos_rng_remove(struct platform_device *pdev)
> +{
> +	pm_runtime_disable(&pdev->dev);
> +

This is not sufficient. pm_runtime_dont_use_autosuspend() is also
necessary here. I will send a v2.

BTW, no problem if it is too late for taking this for v4.6. If this
patchset misses merge window I'll resend it later.

Best regards,
Krzysztof
