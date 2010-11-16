From: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 3/7] omap-sham: OMAP macros corrected
Date: Tue, 16 Nov 2010 09:21:15 -0800
Message-ID: <20101116172114.GT9264@atomide.com>
References: <cover.1289410038.git.dmitry.kasatkin@nokia.com>
 <948fcc79dd3d31f4930d4b62bb7ca7a19949fd9a.1289410038.git.dmitry.kasatkin@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.hengli.com.au, linux-crypto@vger.kernel.org,
	linux-omap@vger.kernel.org
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:54922 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab0KPRVX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Nov 2010 12:21:23 -0500
Content-Disposition: inline
In-Reply-To: <948fcc79dd3d31f4930d4b62bb7ca7a19949fd9a.1289410038.git.dmitry.kasatkin@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Dmitry Kasatkin <dmitry.kasatkin@nokia.com> [101110 09:20]:
> Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
> ---
>  arch/arm/mach-omap2/devices.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
> index beac46c..79dbf04 100644
> --- a/arch/arm/mach-omap2/devices.c
> +++ b/arch/arm/mach-omap2/devices.c
> @@ -456,7 +456,7 @@ static inline void omap_init_mcspi(void) {}
>  
>  #if defined(CONFIG_CRYPTO_DEV_OMAP_SHAM) || defined(CONFIG_CRYPTO_DEV_OMAP_SHAM_MODULE)
>  
> -#ifdef CONFIG_ARCH_OMAP24XX
> +#ifdef CONFIG_ARCH_OMAP2
>  static struct resource omap2_sham_resources[] = {
>  	{
>  		.start	= OMAP24XX_SEC_SHA1MD5_BASE,
> @@ -474,7 +474,7 @@ static int omap2_sham_resources_sz = ARRAY_SIZE(omap2_sham_resources);
>  #define omap2_sham_resources_sz		0
>  #endif
>  
> -#ifdef CONFIG_ARCH_OMAP34XX
> +#ifdef CONFIG_ARCH_OMAP3
>  static struct resource omap3_sham_resources[] = {
>  	{
>  		.start	= OMAP34XX_SEC_SHA1MD5_BASE,

I think we already fixed these a while back..

Tony
