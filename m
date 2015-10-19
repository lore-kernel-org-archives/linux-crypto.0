From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: Re: [PATCH] hwrng: exynos - Fix unbalanced PM runtime get/puts
Date: Mon, 19 Oct 2015 10:41:12 +0900
Message-ID: <56244A38.4040207@samsung.com>
References: <1445011311-32142-1-git-send-email-daniel.thompson@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@linaro.org, linaro-kernel@lists.linaro.org,
	Kukjin Kim <kgene@kernel.org>
To: Daniel Thompson <daniel.thompson@linaro.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Matt Mackall <mpm@selenic.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1445011311-32142-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 17.10.2015 01:01, Daniel Thompson wrote:
> Currently this driver calls pm_runtime_get_sync() rampantly
> but never puts anything back. This makes it impossible for the
> device to autosuspend properly; it will remain fully active
> after the first use.
> 
> Fix in the obvious way.
> 
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: Kukjin Kim <kgene@kernel.org>
> Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
> 
> Notes:
>     Compile tested only (CONFIG_PM=y, CONFIG_HW_RANDOM_EXYNOS=m); I spotted
>     this whilst reviewing the code and don't have an exynos platform to
>     test on.
> 
>  drivers/char/hw_random/exynos-rng.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

To test the patch I had to add OF support to the driver. I have these
patches almost ready and I will send them soon. Anyway:

Tested on Trats2 board (Exynos4412):
Tested-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof
