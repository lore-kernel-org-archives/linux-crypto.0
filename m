From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: [PATCH v3 3/7] ARM: OMAP3xxx: hwmod: Convert SHAM crypto device
 data to hwmod
Date: Fri, 9 Nov 2012 18:11:48 +0200
Message-ID: <CALLzPKZO9Uotd_D4yfJLDDm38oDPw1dPy2jZ_9PvwoLYCxEtcg@mail.gmail.com>
References: <1352257033-32495-1-git-send-email-mgreer@animalcreek.com>
	<1352257033-32495-4-git-send-email-mgreer@animalcreek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, rmk+kernel@arm.linux.org.uk, paul@pwsan.com,
	khilman@deeprootsystems.com
To: "Mark A. Greer" <mgreer@animalcreek.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21536 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565Ab2KIQLz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Nov 2012 11:11:55 -0500
Received: by mail-qa0-f70.google.com with SMTP id s11so1490584qaa.1
        for <linux-crypto@vger.kernel.org>; Fri, 09 Nov 2012 08:11:49 -0800 (PST)
In-Reply-To: <1352257033-32495-4-git-send-email-mgreer@animalcreek.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 7, 2012 at 4:57 AM, Mark A. Greer <mgreer@animalcreek.com> wrote:
> From: "Mark A. Greer" <mgreer@animalcreek.com>
>
> Convert the device data for the OMAP3 SHAM2 (SHA1/MD5) crypto IP
> from explicit platform_data to hwmod.
>
> CC: Paul Walmsley <paul@pwsan.com>
> Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
> ---
>  arch/arm/mach-omap2/clock3xxx_data.c       |  1 +
>  arch/arm/mach-omap2/devices.c              | 42 ++-------------------
>  arch/arm/mach-omap2/omap_hwmod_3xxx_data.c | 60 ++++++++++++++++++++++++++++++
>  3 files changed, 64 insertions(+), 39 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/clock3xxx_data.c b/arch/arm/mach-omap2/clock3xxx_data.c
> index 1f42c9d..6f14d9b 100644
> --- a/arch/arm/mach-omap2/clock3xxx_data.c
> +++ b/arch/arm/mach-omap2/clock3xxx_data.c
> @@ -3342,6 +3342,7 @@ static struct omap_clk omap3xxx_clks[] = {
>         CLK(NULL,       "icr_ick",      &icr_ick,       CK_34XX | CK_36XX),
>         CLK("omap-aes", "ick",  &aes2_ick,      CK_34XX | CK_36XX),
>         CLK("omap-sham",        "ick",  &sha12_ick,     CK_34XX | CK_36XX),
> +       CLK(NULL,       "sha12_ick",    &sha12_ick,     CK_34XX | CK_36XX),
>         CLK(NULL,       "des2_ick",     &des2_ick,      CK_34XX | CK_36XX),
>         CLK("omap_hsmmc.1",     "ick",  &mmchs2_ick,    CK_3XXX),
>         CLK("omap_hsmmc.0",     "ick",  &mmchs1_ick,    CK_3XXX),
> diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
> index f18fa50..f38ac9d 100644
> --- a/arch/arm/mach-omap2/devices.c
> +++ b/arch/arm/mach-omap2/devices.c
> @@ -36,6 +36,7 @@
>  #include "devices.h"
>  #include "cm2xxx_3xxx.h"
>  #include "cm-regbits-24xx.h"
> +#include "cm-regbits-34xx.h"
>
>  #define L3_MODULES_MAX_LEN 12
>  #define L3_MODULES 3
> @@ -453,38 +454,9 @@ static void omap_init_rng(void)
>         WARN(IS_ERR(pdev), "Can't build omap_device for omap_rng\n");
>  }
>
> -#if defined(CONFIG_CRYPTO_DEV_OMAP_SHAM) || defined(CONFIG_CRYPTO_DEV_OMAP_SHAM_MODULE)
> -
> -#ifdef CONFIG_ARCH_OMAP3
> -static struct resource omap3_sham_resources[] = {
> -       {
> -               .start  = OMAP34XX_SEC_SHA1MD5_BASE,
> -               .end    = OMAP34XX_SEC_SHA1MD5_BASE + 0x64,
> -               .flags  = IORESOURCE_MEM,
> -       },
> -       {
> -               .start  = 49 + OMAP_INTC_START,
> -               .flags  = IORESOURCE_IRQ,
> -       },
> -       {
> -               .start  = OMAP34XX_DMA_SHA1MD5_RX,
> -               .flags  = IORESOURCE_DMA,
> -       }
> -};

Ok... it is also for OMAP3..

> -static int omap3_sham_resources_sz = ARRAY_SIZE(omap3_sham_resources);
> -#else
> -#define omap3_sham_resources           NULL
> -#define omap3_sham_resources_sz                0
> -#endif
> -
> -static struct platform_device sham_device = {
> -       .name           = "omap-sham",
> -       .id             = -1,
> -};
> -
> -static void omap_init_sham(void)
> +static void __init omap_init_sham(void)
>  {
> -       if (cpu_is_omap24xx()) {
> +       if (cpu_is_omap24xx() || cpu_is_omap34xx()) {
>                 struct omap_hwmod *oh;
>                 struct platform_device *pdev;
>
> @@ -495,18 +467,10 @@ static void omap_init_sham(void)
>                 pdev = omap_device_build("omap-sham", -1, oh, NULL, 0, NULL,
>                                          0, 0);
>                 WARN(IS_ERR(pdev), "Can't build omap_device for omap-sham\n");
> -       } else if (cpu_is_omap34xx()) {
> -               sham_device.resource = omap3_sham_resources;
> -               sham_device.num_resources = omap3_sham_resources_sz;
> -               platform_device_register(&sham_device);
>         } else {
>                 pr_err("%s: platform not supported\n", __func__);
> -               return;
>         }
>  }
> -#else
> -static inline void omap_init_sham(void) { }
> -#endif
>
>  #if defined(CONFIG_CRYPTO_DEV_OMAP_AES) || defined(CONFIG_CRYPTO_DEV_OMAP_AES_MODULE)
>
> diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
> index f67b7ee..785a0c5 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
> @@ -3543,6 +3543,65 @@ static struct omap_hwmod_ocp_if omap3xxx_l3_main__gpmc = {
>         .user           = OCP_USER_MPU | OCP_USER_SDMA,
>  };
>
> +/* l4_core -> SHAM2 (SHA1/MD5) (similar to omap24xx) */
> +static struct omap_hwmod_class_sysconfig omap3_sham_sysc = {
> +       .rev_offs       = 0x5c,
> +       .sysc_offs      = 0x60,
> +       .syss_offs      = 0x64,
> +       .sysc_flags     = (SYSC_HAS_SOFTRESET | SYSC_HAS_AUTOIDLE |
> +                          SYSS_HAS_RESET_STATUS),
> +       .sysc_fields    = &omap_hwmod_sysc_type1,
> +};
> +
> +static struct omap_hwmod_class omap3xxx_sham_class = {
> +       .name   = "sham",
> +       .sysc   = &omap3_sham_sysc,
> +};
> +
> +struct omap_hwmod_irq_info omap3_sham_mpu_irqs[] = {
> +       { .irq = 49 + OMAP_INTC_START, },
> +       { .irq = -1 }
> +};
> +
> +struct omap_hwmod_dma_info omap3_sham_sdma_reqs[] = {
> +       { .name = "rx", .dma_req = OMAP34XX_DMA_SHA1MD5_RX, },
> +       { .dma_req = -1 }
> +};
> +
> +struct omap_hwmod omap3xxx_sham_hwmod = {
> +       .name           = "sham",
> +       .mpu_irqs       = omap3_sham_mpu_irqs,
> +       .sdma_reqs      = omap3_sham_sdma_reqs,
> +       .main_clk       = "sha12_ick",
> +       .prcm           = {
> +               .omap2 = {
> +                       .module_offs = CORE_MOD,
> +                       .prcm_reg_id = 1,
> +                       .module_bit = OMAP3430_EN_SHA12_SHIFT,
> +                       .idlest_reg_id = 1,
> +                       .idlest_idle_bit = OMAP3430_ST_SHA12_SHIFT,
> +               },
> +       },
> +       .class          = &omap3xxx_sham_class,
> +};
> +
> +static struct omap_hwmod_addr_space omap3xxx_sham_addrs[] = {
> +       {
> +               .pa_start       = 0x480c3000,
> +               .pa_end         = 0x480c3000 + 0x64 - 1,
> +               .flags          = ADDR_TYPE_RT
> +       },
> +       { }
> +};
> +
> +static struct omap_hwmod_ocp_if omap3xxx_l4_core__sham = {
> +       .master         = &omap3xxx_l4_core_hwmod,
> +       .slave          = &omap3xxx_sham_hwmod,
> +       .clk            = "sha12_ick",
> +       .addr           = omap3xxx_sham_addrs,
> +       .user           = OCP_USER_MPU | OCP_USER_SDMA,
> +};
> +
>  static struct omap_hwmod_ocp_if *omap3xxx_hwmod_ocp_ifs[] __initdata = {
>         &omap3xxx_l3_main__l4_core,
>         &omap3xxx_l3_main__l4_per,
> @@ -3596,6 +3655,7 @@ static struct omap_hwmod_ocp_if *omap3xxx_hwmod_ocp_ifs[] __initdata = {
>  /* GP-only hwmod links */
>  static struct omap_hwmod_ocp_if *omap3xxx_gp_hwmod_ocp_ifs[] __initdata = {
>         &omap3xxx_l4_sec__timer12,
> +       &omap3xxx_l4_core__sham,
>         NULL
>  };
>
> --
> 1.7.12
>
