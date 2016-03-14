From: Vladimir Zapolskiy <vz@mleia.com>
Subject: Re: [PATCH] crypto: s5p-sss - Enable COMPILE_TEST
Date: Tue, 15 Mar 2016 00:34:52 +0200
Message-ID: <56E73C8C.80103@mleia.com>
References: <1457929218-22358-1-git-send-email-k.kozlowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <1457929218-22358-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 14.03.2016 06:20, Krzysztof Kozlowski wrote:
> Get some build coverage of S5P/Exynos AES H/W acceleration driver.
> Driver uses DMA and devm_ioremap_resource() so add DMA and IOMEM
> dependencies for the compile testing.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> 
> ---
> 
> Compile-tested on x86, x86_64, ppc64, arm, arm64 and mips.
> ---
>  drivers/crypto/Kconfig | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 477fffdb4f49..7a51ac0ac290 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -342,7 +342,8 @@ config CRYPTO_DEV_SAHARA
>  
>  config CRYPTO_DEV_S5P
>  	tristate "Support for Samsung S5PV210/Exynos crypto accelerator"
> -	depends on ARCH_S5PV210 || ARCH_EXYNOS
> +	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
> +	depends on HAS_IOMEM && HAS_DMA
>  	select CRYPTO_AES
>  	select CRYPTO_BLKCIPHER
>  	help
> 

Acked-by: Vladimir Zapolskiy <vz@mleia.com>

--
With best wishes,
Vladimir
