From: Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCHv2 1/2] crypto: updates omap sham device related platform
 code
Date: Tue, 30 Mar 2010 03:41:30 -0600 (MDT)
Message-ID: <alpine.DEB.2.00.1003300334110.14474@utopia.booyaka.com>
References: <cover.1269524804.git.dmitry.kasatkin@nokia.com> <9e97cb8f5ee608a70bb9c04bc2c22f0d6b749d98.1269524804.git.dmitry.kasatkin@nokia.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tony@atomide.com, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from utopia.booyaka.com ([72.9.107.138]:50302 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab0C3Jla (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 30 Mar 2010 05:41:30 -0400
In-Reply-To: <9e97cb8f5ee608a70bb9c04bc2c22f0d6b749d98.1269524804.git.dmitry.kasatkin@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Dmitry,

a few comments:

On Thu, 25 Mar 2010, Dmitry Kasatkin wrote:

> - registration
> - clocks
> 
> Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
> ---
>  arch/arm/mach-omap2/clock2420_data.c       |    2 +-
>  arch/arm/mach-omap2/clock2430_data.c       |    2 +-
>  arch/arm/mach-omap2/clock3xxx_data.c       |    2 +-
>  arch/arm/mach-omap2/devices.c              |   26 ++++++++++++++++++++++++--
>  arch/arm/plat-omap/include/plat/omap34xx.h |    5 +++++
>  5 files changed, 32 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/clock2420_data.c b/arch/arm/mach-omap2/clock2420_data.c
> index d932b14..1820a55 100644
> --- a/arch/arm/mach-omap2/clock2420_data.c
> +++ b/arch/arm/mach-omap2/clock2420_data.c
> @@ -1836,7 +1836,7 @@ static struct omap_clk omap2420_clks[] = {
>  	CLK(NULL,	"vlynq_ick",	&vlynq_ick,	CK_242X),
>  	CLK(NULL,	"vlynq_fck",	&vlynq_fck,	CK_242X),
>  	CLK(NULL,	"des_ick",	&des_ick,	CK_242X),
> -	CLK(NULL,	"sha_ick",	&sha_ick,	CK_242X),
> +	CLK("omap-sham",	"ick",	&sha_ick,	CK_242X),
>  	CLK("omap_rng",	"ick",		&rng_ick,	CK_242X),
>  	CLK(NULL,	"aes_ick",	&aes_ick,	CK_242X),
>  	CLK(NULL,	"pka_ick",	&pka_ick,	CK_242X),
> diff --git a/arch/arm/mach-omap2/clock2430_data.c b/arch/arm/mach-omap2/clock2430_data.c
> index 0438b6e..5884ac6 100644
> --- a/arch/arm/mach-omap2/clock2430_data.c
> +++ b/arch/arm/mach-omap2/clock2430_data.c
> @@ -1924,7 +1924,7 @@ static struct omap_clk omap2430_clks[] = {
>  	CLK(NULL,	"sdma_ick",	&sdma_ick,	CK_243X),
>  	CLK(NULL,	"sdrc_ick",	&sdrc_ick,	CK_243X),
>  	CLK(NULL,	"des_ick",	&des_ick,	CK_243X),
> -	CLK(NULL,	"sha_ick",	&sha_ick,	CK_243X),
> +	CLK("omap-sham",	"ick",	&sha_ick,	CK_243X),
>  	CLK("omap_rng",	"ick",		&rng_ick,	CK_243X),
>  	CLK(NULL,	"aes_ick",	&aes_ick,	CK_243X),
>  	CLK(NULL,	"pka_ick",	&pka_ick,	CK_243X),
> diff --git a/arch/arm/mach-omap2/clock3xxx_data.c b/arch/arm/mach-omap2/clock3xxx_data.c
> index d5153b6..5a974dc 100644
> --- a/arch/arm/mach-omap2/clock3xxx_data.c
> +++ b/arch/arm/mach-omap2/clock3xxx_data.c
> @@ -3360,7 +3360,7 @@ static struct omap_clk omap3xxx_clks[] = {
>  	CLK("mmci-omap-hs.2",	"ick",	&mmchs3_ick,	CK_3430ES2 | CK_AM35XX),
>  	CLK(NULL,	"icr_ick",	&icr_ick,	CK_343X),
>  	CLK(NULL,	"aes2_ick",	&aes2_ick,	CK_343X),
> -	CLK(NULL,	"sha12_ick",	&sha12_ick,	CK_343X),
> +	CLK("omap-sham",	"ick",	&sha12_ick,	CK_343X),
>  	CLK(NULL,	"des2_ick",	&des2_ick,	CK_343X),
>  	CLK("mmci-omap-hs.1",	"ick",	&mmchs2_ick,	CK_3XXX),
>  	CLK("mmci-omap-hs.0",	"ick",	&mmchs1_ick,	CK_3XXX),

The above changes are all

Acked-by: Paul Walmsley <paul@pwsan.com>

... but ...

> diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
> index 23e4d77..3e20b9c 100644
> --- a/arch/arm/mach-omap2/devices.c
> +++ b/arch/arm/mach-omap2/devices.c
> @@ -26,6 +26,7 @@
>  #include <plat/mux.h>
>  #include <mach/gpio.h>
>  #include <plat/mmc.h>
> +#include <plat/dma.h>
>  
>  #include "mux.h"
>  
> @@ -453,7 +454,9 @@ static void omap_init_mcspi(void)
>  static inline void omap_init_mcspi(void) {}
>  #endif
>  
> -#ifdef CONFIG_OMAP_SHA1_MD5
> +#if defined(CONFIG_CRYPTO_DEV_OMAP_SHAM) || defined(CONFIG_CRYPTO_DEV_OMAP_SHAM_MODULE)
> +
> +#ifdef CONFIG_ARCH_OMAP2
>  static struct resource sha1_md5_resources[] = {
>  	{
>  		.start	= OMAP24XX_SEC_SHA1MD5_BASE,
> @@ -465,9 +468,28 @@ static struct resource sha1_md5_resources[] = {
>  		.flags	= IORESOURCE_IRQ,
>  	}
>  };
> +#endif
> +
> +#ifdef CONFIG_ARCH_OMAP3
> +static struct resource sha1_md5_resources[] = {
> +	{
> +		.start	= OMAP34XX_SEC_SHA1MD5_BASE,
> +		.end	= OMAP34XX_SEC_SHA1MD5_BASE + 0x64,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	{
> +		.start	= INT_34XX_SHA1MD52_IRQ,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +	{
> +		.start	= OMAP34XX_DMA_SHA1MD5_RX,
> +		.flags	= IORESOURCE_DMA,
> +	}
> +};
> +#endif

The above will break multi-OMAP2 kernels.  Please change the above to make 
the variable names unique on a per-SoC basis (e.g., 
omap3_sha1_md5_resources) and modify the SHA1/MD5 device registration code 
to use the appropriate struct resource array at runtime.  For an example, 
see mach-omap2/devices.c:omap_init_mbox().

>  
>  static struct platform_device sha1_md5_device = {
> -	.name		= "OMAP SHA1/MD5",
> +	.name		= "omap-sham",
>  	.id		= -1,
>  	.num_resources	= ARRAY_SIZE(sha1_md5_resources),
>  	.resource	= sha1_md5_resources,
> diff --git a/arch/arm/plat-omap/include/plat/omap34xx.h b/arch/arm/plat-omap/include/plat/omap34xx.h
> index 2845fdc..98fc8b4 100644
> --- a/arch/arm/plat-omap/include/plat/omap34xx.h
> +++ b/arch/arm/plat-omap/include/plat/omap34xx.h
> @@ -82,5 +82,10 @@
>  
>  #define OMAP34XX_MAILBOX_BASE		(L4_34XX_BASE + 0x94000)
>  
> +/* Security */
> +#define OMAP34XX_SEC_BASE	(L4_34XX_BASE + 0xA0000)
> +#define OMAP34XX_SEC_SHA1MD5_BASE	(OMAP34XX_SEC_BASE + 0x23000)
> +#define OMAP34XX_SEC_AES_BASE	(OMAP34XX_SEC_BASE + 0x25000)
> +
>  #endif /* __ASM_ARCH_OMAP3_H */
>  
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


- Paul
