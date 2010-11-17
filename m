From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: [PATCH 1/7] crypto: updates omap sham device related platform
 code
Date: Wed, 17 Nov 2010 12:17:04 +0200
Message-ID: <4CE3ABA0.9090309@nokia.com>
References: <cover.1289410038.git.dmitry.kasatkin@nokia.com> <e4868e47717a76b44193fdd71c36629d5785d896.1289410038.git.dmitry.kasatkin@nokia.com> <20101116171948.GS9264@atomide.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "herbert@gondor.hengli.com.au" <herbert@gondor.hengli.com.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
To: ext Tony Lindgren <tony@atomide.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:49414 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932693Ab0KQKQg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Nov 2010 05:16:36 -0500
In-Reply-To: <20101116171948.GS9264@atomide.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

This patch was already applied months ago.
It appeared by mistake as "git format-patch" took it somehow.

Please ignore it...

- Dmitry

On 16/11/10 19:19, ext Tony Lindgren wrote:
> * Dmitry Kasatkin <dmitry.kasatkin@nokia.com> [101110 09:20]:
>   
>> - registration with multi OMAP kernels support
>> - clocks
>>
>> Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
>> ---
>>  arch/arm/mach-omap2/clock2420_data.c       |    2 +-
>>  arch/arm/mach-omap2/clock2430_data.c       |    2 +-
>>  arch/arm/mach-omap2/clock3xxx_data.c       |    2 +-
>>  arch/arm/mach-omap2/devices.c              |   58 +++++++++++++++++++++++-----
>>  arch/arm/plat-omap/include/plat/omap34xx.h |    5 ++
>>  5 files changed, 56 insertions(+), 13 deletions(-)
>>
>> diff --git a/arch/arm/mach-omap2/clock2420_data.c b/arch/arm/mach-omap2/clock2420_data.c
>> index d932b14..1820a55 100644
>> --- a/arch/arm/mach-omap2/clock2420_data.c
>> +++ b/arch/arm/mach-omap2/clock2420_data.c
>> @@ -1836,7 +1836,7 @@ static struct omap_clk omap2420_clks[] = {
>>  	CLK(NULL,	"vlynq_ick",	&vlynq_ick,	CK_242X),
>>  	CLK(NULL,	"vlynq_fck",	&vlynq_fck,	CK_242X),
>>  	CLK(NULL,	"des_ick",	&des_ick,	CK_242X),
>> -	CLK(NULL,	"sha_ick",	&sha_ick,	CK_242X),
>> +	CLK("omap-sham",	"ick",	&sha_ick,	CK_242X),
>>  	CLK("omap_rng",	"ick",		&rng_ick,	CK_242X),
>>  	CLK(NULL,	"aes_ick",	&aes_ick,	CK_242X),
>>  	CLK(NULL,	"pka_ick",	&pka_ick,	CK_242X),
>> diff --git a/arch/arm/mach-omap2/clock2430_data.c b/arch/arm/mach-omap2/clock2430_data.c
>> index 0438b6e..5884ac6 100644
>> --- a/arch/arm/mach-omap2/clock2430_data.c
>> +++ b/arch/arm/mach-omap2/clock2430_data.c
>> @@ -1924,7 +1924,7 @@ static struct omap_clk omap2430_clks[] = {
>>  	CLK(NULL,	"sdma_ick",	&sdma_ick,	CK_243X),
>>  	CLK(NULL,	"sdrc_ick",	&sdrc_ick,	CK_243X),
>>  	CLK(NULL,	"des_ick",	&des_ick,	CK_243X),
>> -	CLK(NULL,	"sha_ick",	&sha_ick,	CK_243X),
>> +	CLK("omap-sham",	"ick",	&sha_ick,	CK_243X),
>>  	CLK("omap_rng",	"ick",		&rng_ick,	CK_243X),
>>  	CLK(NULL,	"aes_ick",	&aes_ick,	CK_243X),
>>  	CLK(NULL,	"pka_ick",	&pka_ick,	CK_243X),
>> diff --git a/arch/arm/mach-omap2/clock3xxx_data.c b/arch/arm/mach-omap2/clock3xxx_data.c
>> index 9cba556..52638df 100644
>> --- a/arch/arm/mach-omap2/clock3xxx_data.c
>> +++ b/arch/arm/mach-omap2/clock3xxx_data.c
>> @@ -3360,7 +3360,7 @@ static struct omap_clk omap3xxx_clks[] = {
>>  	CLK("mmci-omap-hs.2",	"ick",	&mmchs3_ick,	CK_3430ES2 | CK_AM35XX),
>>  	CLK(NULL,	"icr_ick",	&icr_ick,	CK_343X),
>>  	CLK(NULL,	"aes2_ick",	&aes2_ick,	CK_343X),
>> -	CLK(NULL,	"sha12_ick",	&sha12_ick,	CK_343X),
>> +	CLK("omap-sham",	"ick",	&sha12_ick,	CK_343X),
>>  	CLK(NULL,	"des2_ick",	&des2_ick,	CK_343X),
>>  	CLK("mmci-omap-hs.1",	"ick",	&mmchs2_ick,	CK_3XXX),
>>  	CLK("mmci-omap-hs.0",	"ick",	&mmchs1_ick,	CK_3XXX),
>>     
> This looks OK.
>
>   
>> diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
>> index 2271b9b..beac46c 100644
>> --- a/arch/arm/mach-omap2/devices.c
>> +++ b/arch/arm/mach-omap2/devices.c
>> @@ -26,6 +26,7 @@
>>  #include <plat/mux.h>
>>  #include <mach/gpio.h>
>>  #include <plat/mmc.h>
>> +#include <plat/dma.h>
>>  
>>  #include "mux.h"
>>  
>> @@ -453,8 +454,10 @@ static void omap_init_mcspi(void)
>>  static inline void omap_init_mcspi(void) {}
>>  #endif
>>  
>> -#ifdef CONFIG_OMAP_SHA1_MD5
>> -static struct resource sha1_md5_resources[] = {
>> +#if defined(CONFIG_CRYPTO_DEV_OMAP_SHAM) || defined(CONFIG_CRYPTO_DEV_OMAP_SHAM_MODULE)
>> +
>> +#ifdef CONFIG_ARCH_OMAP24XX
>> +static struct resource omap2_sham_resources[] = {
>>  	{
>>  		.start	= OMAP24XX_SEC_SHA1MD5_BASE,
>>  		.end	= OMAP24XX_SEC_SHA1MD5_BASE + 0x64,
>> @@ -465,20 +468,55 @@ static struct resource sha1_md5_resources[] = {
>>  		.flags	= IORESOURCE_IRQ,
>>  	}
>>  };
>> +static int omap2_sham_resources_sz = ARRAY_SIZE(omap2_sham_resources);
>> +#else
>> +#define omap2_sham_resources		NULL
>> +#define omap2_sham_resources_sz		0
>> +#endif
>>  
>> -static struct platform_device sha1_md5_device = {
>> -	.name		= "OMAP SHA1/MD5",
>> +#ifdef CONFIG_ARCH_OMAP34XX
>> +static struct resource omap3_sham_resources[] = {
>> +	{
>> +		.start	= OMAP34XX_SEC_SHA1MD5_BASE,
>> +		.end	= OMAP34XX_SEC_SHA1MD5_BASE + 0x64,
>> +		.flags	= IORESOURCE_MEM,
>> +	},
>> +	{
>> +		.start	= INT_34XX_SHA1MD52_IRQ,
>> +		.flags	= IORESOURCE_IRQ,
>> +	},
>> +	{
>> +		.start	= OMAP34XX_DMA_SHA1MD5_RX,
>> +		.flags	= IORESOURCE_DMA,
>> +	}
>> +};
>> +static int omap3_sham_resources_sz = ARRAY_SIZE(omap3_sham_resources);
>> +#else
>> +#define omap3_sham_resources		NULL
>> +#define omap3_sham_resources_sz		0
>> +#endif
>> +
>> +static struct platform_device sham_device = {
>> +	.name		= "omap-sham",
>>  	.id		= -1,
>> -	.num_resources	= ARRAY_SIZE(sha1_md5_resources),
>> -	.resource	= sha1_md5_resources,
>>  };
>>  
>> -static void omap_init_sha1_md5(void)
>> +static void omap_init_sham(void)
>>  {
>> -	platform_device_register(&sha1_md5_device);
>> +	if (cpu_is_omap24xx()) {
>> +		sham_device.resource = omap2_sham_resources;
>> +		sham_device.num_resources = omap2_sham_resources_sz;
>> +	} else if (cpu_is_omap34xx()) {
>> +		sham_device.resource = omap3_sham_resources;
>> +		sham_device.num_resources = omap3_sham_resources_sz;
>> +	} else {
>> +		pr_err("%s: platform not supported\n", __func__);
>> +		return;
>> +	}
>> +	platform_device_register(&sham_device);
>>  }
>>  #else
>> -static inline void omap_init_sha1_md5(void) { }
>> +static inline void omap_init_sham(void) { }
>>  #endif
>>  
>>  /*-------------------------------------------------------------------------*/
>>     
> Here you might want to look into doing this using hwmod, it would
> clear out a lot of this init code.
>
> Tony
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   
