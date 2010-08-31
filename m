From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: [PATCH 1/2] crypto: updates to enable omap aes
Date: Tue, 31 Aug 2010 11:52:27 +0300
Message-ID: <4C7CC2CB.5020208@nokia.com>
References: <cover.1282311763.git.dmitry.kasatkin@nokia.com>  <f419b9c0bc0aa64a1a012a57e52aa9477b91b23f.1282311763.git.dmitry.kasatkin@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Kasatkin Dmitry (Nokia-MS/Helsinki)" <Dmitry.Kasatkin@nokia.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	ext Tony Lindgren <tony@atomide.com>
To: "herbert@gondor.hengli.com.au" <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:43181 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab0HaIwh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 Aug 2010 04:52:37 -0400
In-Reply-To: <f419b9c0bc0aa64a1a012a57e52aa9477b91b23f.1282311763.git.dmitry.kasatkin@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Does anyone want to comment on this?

Thanks,
Dmitry


On 20/08/10 16:44, Kasatkin Dmitry (Nokia-MS/Helsinki) wrote:
> Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
> ---
>  arch/arm/mach-omap2/clock2420_data.c |    2 +-
>  arch/arm/mach-omap2/clock2430_data.c |    2 +-
>  arch/arm/mach-omap2/clock3xxx_data.c |    2 +-
>  arch/arm/mach-omap2/devices.c        |   71 ++++++++++++++++++++++++++++++++++
>  4 files changed, 74 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/clock2420_data.c b/arch/arm/mach-omap2/clock2420_data.c
> index 37d65d6..5f2066a 100644
> --- a/arch/arm/mach-omap2/clock2420_data.c
> +++ b/arch/arm/mach-omap2/clock2420_data.c
> @@ -1838,7 +1838,7 @@ static struct omap_clk omap2420_clks[] = {
>  	CLK(NULL,	"des_ick",	&des_ick,	CK_242X),
>  	CLK("omap-sham",	"ick",	&sha_ick,	CK_242X),
>  	CLK("omap_rng",	"ick",		&rng_ick,	CK_242X),
> -	CLK(NULL,	"aes_ick",	&aes_ick,	CK_242X),
> +	CLK("omap-aes",	"ick",	&aes_ick,	CK_242X),
>  	CLK(NULL,	"pka_ick",	&pka_ick,	CK_242X),
>  	CLK(NULL,	"usb_fck",	&usb_fck,	CK_242X),
>  	CLK("musb_hdrc",	"fck",	&osc_ck,	CK_242X),
> diff --git a/arch/arm/mach-omap2/clock2430_data.c b/arch/arm/mach-omap2/clock2430_data.c
> index b33118f..701a171 100644
> --- a/arch/arm/mach-omap2/clock2430_data.c
> +++ b/arch/arm/mach-omap2/clock2430_data.c
> @@ -1926,7 +1926,7 @@ static struct omap_clk omap2430_clks[] = {
>  	CLK(NULL,	"des_ick",	&des_ick,	CK_243X),
>  	CLK("omap-sham",	"ick",	&sha_ick,	CK_243X),
>  	CLK("omap_rng",	"ick",		&rng_ick,	CK_243X),
> -	CLK(NULL,	"aes_ick",	&aes_ick,	CK_243X),
> +	CLK("omap-aes",	"ick",	&aes_ick,	CK_243X),
>  	CLK(NULL,	"pka_ick",	&pka_ick,	CK_243X),
>  	CLK(NULL,	"usb_fck",	&usb_fck,	CK_243X),
>  	CLK("musb_hdrc",	"ick",	&usbhs_ick,	CK_243X),
> diff --git a/arch/arm/mach-omap2/clock3xxx_data.c b/arch/arm/mach-omap2/clock3xxx_data.c
> index dfdce2d..c73906d 100644
> --- a/arch/arm/mach-omap2/clock3xxx_data.c
> +++ b/arch/arm/mach-omap2/clock3xxx_data.c
> @@ -3288,7 +3288,7 @@ static struct omap_clk omap3xxx_clks[] = {
>  	CLK(NULL,	"usbtll_ick",	&usbtll_ick,	CK_3430ES2 | CK_AM35XX),
>  	CLK("mmci-omap-hs.2",	"ick",	&mmchs3_ick,	CK_3430ES2 | CK_AM35XX),
>  	CLK(NULL,	"icr_ick",	&icr_ick,	CK_343X),
> -	CLK(NULL,	"aes2_ick",	&aes2_ick,	CK_343X),
> +	CLK("omap-aes",	"ick",	&aes2_ick,	CK_343X),
>  	CLK("omap-sham",	"ick",	&sha12_ick,	CK_343X),
>  	CLK(NULL,	"des2_ick",	&des2_ick,	CK_343X),
>  	CLK("mmci-omap-hs.1",	"ick",	&mmchs2_ick,	CK_3XXX),
> diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
> index 2dbb265..b27e7cb 100644
> --- a/arch/arm/mach-omap2/devices.c
> +++ b/arch/arm/mach-omap2/devices.c
> @@ -498,6 +498,76 @@ static void omap_init_sham(void)
>  static inline void omap_init_sham(void) { }
>  #endif
>  
> +#if defined(CONFIG_CRYPTO_DEV_OMAP_AES) || defined(CONFIG_CRYPTO_DEV_OMAP_AES_MODULE)
> +
> +#ifdef CONFIG_ARCH_OMAP24XX
> +static struct resource omap2_aes_resources[] = {
> +	{
> +		.start	= OMAP24XX_SEC_AES_BASE,
> +		.end	= OMAP24XX_SEC_AES_BASE + 0x4C,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	{
> +		.start	= OMAP24XX_DMA_AES_TX,
> +		.flags	= IORESOURCE_DMA,
> +	},
> +	{
> +		.start	= OMAP24XX_DMA_AES_RX,
> +		.flags	= IORESOURCE_DMA,
> +	}
> +};
> +static int omap2_aes_resources_sz = ARRAY_SIZE(omap2_aes_resources);
> +#else
> +#define omap2_aes_resources		NULL
> +#define omap2_aes_resources_sz		0
> +#endif
> +
> +#ifdef CONFIG_ARCH_OMAP34XX
> +static struct resource omap3_aes_resources[] = {
> +	{
> +		.start	= OMAP34XX_SEC_AES_BASE,
> +		.end	= OMAP34XX_SEC_AES_BASE + 0x4C,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	{
> +		.start	= OMAP34XX_DMA_AES2_TX,
> +		.flags	= IORESOURCE_DMA,
> +	},
> +	{
> +		.start	= OMAP34XX_DMA_AES2_RX,
> +		.flags	= IORESOURCE_DMA,
> +	}
> +};
> +static int omap3_aes_resources_sz = ARRAY_SIZE(omap3_aes_resources);
> +#else
> +#define omap3_aes_resources		NULL
> +#define omap3_aes_resources_sz		0
> +#endif
> +
> +static struct platform_device aes_device = {
> +	.name		= "omap-aes",
> +	.id		= -1,
> +};
> +
> +static void omap_init_aes(void)
> +{
> +	if (cpu_is_omap24xx()) {
> +		aes_device.resource = omap2_aes_resources;
> +		aes_device.num_resources = omap2_aes_resources_sz;
> +	} else if (cpu_is_omap34xx()) {
> +		aes_device.resource = omap3_aes_resources;
> +		aes_device.num_resources = omap3_aes_resources_sz;
> +	} else {
> +		pr_err("%s: platform not supported\n", __func__);
> +		return;
> +	}
> +	platform_device_register(&aes_device);
> +}
> +
> +#else
> +static inline void omap_init_aes(void) { }
> +#endif
> +
>  /*-------------------------------------------------------------------------*/
>  
>  #if defined(CONFIG_ARCH_OMAP3) || defined(CONFIG_ARCH_OMAP4)
> @@ -854,6 +924,7 @@ static int __init omap2_init_devices(void)
>  	omap_hdq_init();
>  	omap_init_sti();
>  	omap_init_sham();
> +	omap_init_aes();
>  	omap_init_vout();
>  
>  	return 0;
>   
