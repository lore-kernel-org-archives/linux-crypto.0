From: Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH 4/8 v3] crypto:s5p-sss: Kconfig: Let Exynos SoCs select SSS
 driver
Date: Fri, 10 Jan 2014 16:47:49 +0100
Message-ID: <52D01625.8090601@samsung.com>
References: <1389095509-14357-5-git-send-email-ch.naveen@samsung.com>
 <1389354202-31891-1-git-send-email-ch.naveen@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
	herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
	cpgs@samsung.com, tomasz.figa@gmail.com,
	"David S. Miller" <davem@davemloft.net>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
	linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-reply-to: <1389354202-31891-1-git-send-email-ch.naveen@samsung.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Naveen,

On 10.01.2014 12:43, Naveen Krishna Chatradhi wrote:
> From: Naveen Krishna Ch <ch.naveen@samsung.com>
>
> This patch modifies Kconfig such that ARCH_EXYNOS SoCs
> which includes (Exynos4210, Exynos5250 and Exynos5420)
> can also select Samsung SSS(Security SubSystem) driver.
>
> Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: David S. Miller <davem@davemloft.net>
> CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
> TO: <linux-crypto@vger.kernel.org>
> CC: <linux-samsung-soc@vger.kernel.org>
> ---
> Changes since v2:
> None
>
>   drivers/crypto/Kconfig |    8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index f4fd837..193e8b1 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -300,15 +300,15 @@ config CRYPTO_DEV_DCP
>   	  capabilities of the DCP co-processor
>
>   config CRYPTO_DEV_S5P
> -	tristate "Support for Samsung S5PV210 crypto accelerator"
> -	depends on ARCH_S5PV210
> +	tristate "Support for Samsung crypto accelerator"

I'd make this "Support for Samsung S5PV210/Exynos crypto accelerator" 
instead, because there are previous SoCs (S3C64xx and S5PC100) that 
contain a different crypto engine IP.

> +	depends on ARCH_S5PV210 || ARCH_EXYNOS
>   	select CRYPTO_AES
>   	select CRYPTO_ALGAPI
>   	select CRYPTO_BLKCIPHER
>   	help
>   	  This option allows you to have support for S5P crypto acceleration.
> -	  Select this to offload Samsung S5PV210 or S5PC110 from AES
> -	  algorithms execution.
> +	  Select this to offload Samsung S5PV210 or S5PC110, Exynos4210,
> +	  Exynos5250 and Exynos5420 from AES algorithms execution.

I believe you can safely make it S5PV210, S5PC110 and Exynos, without 
listing particular SoCs.

Best regards,
Tomasz
