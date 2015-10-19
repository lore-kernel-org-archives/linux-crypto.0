From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: Re: [PATCH 3/4] hwrng: exynos - Fix missing configuration after
 suspend to RAM
Date: Mon, 19 Oct 2015 14:03:16 +0900
Message-ID: <56247994.5060105@samsung.com>
References: <1445229462-32395-1-git-send-email-k.kozlowski@samsung.com>
 <1445229462-32395-4-git-send-email-k.kozlowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Heiner Kallweit <hkallweit1@gmail.com>
To: Kukjin Kim <kgene@kernel.org>, Matt Mackall <mpm@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, devicetree@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-reply-to: <1445229462-32395-4-git-send-email-k.kozlowski@samsung.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On 19.10.2015 13:37, Krzysztof Kozlowski wrote:
> After suspend to RAM the device stopped to work with ETIMEDOUT error:
> 
> $ dd if=/dev/hwrng of=/dev/null bs=1 count=16
> dd: reading `/dev/hwrng': Connection timed out
> 
> In the STATUS register the bits #5 (PRNG_DONE) and #1
> (SEED_SETTING_DONE) were not set. Instead PRNG_ERROR (seventh bit) was
> high.
> 
> After each system suspend initialize the seed to fix the error.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/char/hw_random/exynos-rng.c | 42 ++++++++++++++++++++++++++++++-------
>  1 file changed, 35 insertions(+), 7 deletions(-)
> 

Oh, I forgot about stable.
Fixes: b329669ea0b5 ("hwrng: exynos - Add support for Exynos random
number generator")
Cc: <stable@vger.kernel.org>

I'll add it in respin (if there would be such).

Best regards,
Krzysztof

> diff --git a/drivers/char/hw_random/exynos-rng.c b/drivers/char/hw_random/exynos-rng.c
> index dfaaaafb8ddd..162adbda1b70 100644
> --- a/drivers/char/hw_random/exynos-rng.c
> +++ b/drivers/char/hw_random/exynos-rng.c
> @@ -53,15 +53,11 @@ static void exynos_rng_writel(struct exynos_rng *rng, u32 val, u32 offset)
>  	__raw_writel(val, rng->mem + offset);
>  }
>  
> -static int exynos_init(struct hwrng *rng)
> +static int exynos_rng_configure(struct exynos_rng *exynos_rng)
>  {
> -	struct exynos_rng *exynos_rng = container_of(rng,
> -						struct exynos_rng, rng);
>  	int i;
>  	int ret = 0;
>  
> -	pm_runtime_get_sync(exynos_rng->dev);
> -
>  	for (i = 0 ; i < 5 ; i++)
>  		exynos_rng_writel(exynos_rng, jiffies,
>  				EXYNOS_PRNG_SEED_OFFSET + 4*i);
> @@ -70,6 +66,17 @@ static int exynos_init(struct hwrng *rng)
>  						 & SEED_SETTING_DONE))
>  		ret = -EIO;
>  
> +	return ret;
> +}
> +
> +static int exynos_init(struct hwrng *rng)
> +{
> +	struct exynos_rng *exynos_rng = container_of(rng,
> +						struct exynos_rng, rng);
> +	int ret = 0;
> +
> +	pm_runtime_get_sync(exynos_rng->dev);
> +	ret = exynos_rng_configure(exynos_rng);
>  	pm_runtime_put_noidle(exynos_rng->dev);
>  
>  	return ret;
> @@ -155,10 +162,31 @@ static int exynos_rng_runtime_resume(struct device *dev)
>  
>  	return clk_prepare_enable(exynos_rng->clk);
>  }
> +
> +static int exynos_rng_suspend(struct device *dev)
> +{
> +	return pm_runtime_force_suspend(dev);
> +}
> +
> +static int exynos_rng_resume(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct exynos_rng *exynos_rng = platform_get_drvdata(pdev);
> +	int ret;
> +
> +	ret = pm_runtime_force_resume(dev);
> +	if (ret)
> +		return ret;
> +
> +	return exynos_rng_configure(exynos_rng);
> +}
>  #endif
>  
> -static UNIVERSAL_DEV_PM_OPS(exynos_rng_pm_ops, exynos_rng_runtime_suspend,
> -					exynos_rng_runtime_resume, NULL);
> +static const struct dev_pm_ops exynos_rng_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(exynos_rng_suspend, exynos_rng_resume)
> +	SET_RUNTIME_PM_OPS(exynos_rng_runtime_suspend,
> +			   exynos_rng_runtime_resume, NULL)
> +};
>  
>  static struct platform_driver exynos_rng_driver = {
>  	.driver		= {
> 
