From: Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH 4/5] crypto:s5p-sss: Exynos5 SoCs too can select SSS driver
Date: Wed, 08 Jan 2014 01:30:01 +0100
Message-ID: <1713694.HL69UGM8yf@flatron>
References: <1389095509-14357-1-git-send-email-ch.naveen@samsung.com> <1389095509-14357-5-git-send-email-ch.naveen@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
	herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
	cpgs@samsung.com, "David S. Miller" <davem@davemloft.net>
To: Naveen Krishna Ch <ch.naveen@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1389095509-14357-5-git-send-email-ch.naveen@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tuesday 07 of January 2014 17:21:48 Naveen Krishna Ch wrote:
> This patch modifies Kconfig such that ARCH_EXYNOS5 SoCs
> can also select Samsung SSS(Security SubSystem) driver.
> 
> Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: David S. Miller <davem@davemloft.net>
> CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
> TO: <linux-crypto@vger.kernel.org>
> CC: <linux-samsung-soc@vger.kernel.org>
> ---
>  drivers/crypto/Kconfig |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index f4fd837..137dcd8 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -300,15 +300,15 @@ config CRYPTO_DEV_DCP
>  	  capabilities of the DCP co-processor
>  
>  config CRYPTO_DEV_S5P
> -	tristate "Support for Samsung S5PV210 crypto accelerator"
> -	depends on ARCH_S5PV210
> +	tristate "Support for Samsung crypto accelerator"
> +	depends on ARCH_S5PV210 || ARCH_EXYNOS5
>  	select CRYPTO_AES
>  	select CRYPTO_ALGAPI
>  	select CRYPTO_BLKCIPHER
>  	help
>  	  This option allows you to have support for S5P crypto acceleration.
> -	  Select this to offload Samsung S5PV210 or S5PC110 from AES
> -	  algorithms execution.
> +	  Select this to offload Samsung S5PV210 or S5PC110, Exynos5250
> +	  and Exynos5420 from AES algorithms execution.

What about Exynos4 SoCs?

Best regards,
Tomasz
