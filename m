From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: [PATCH v3 1/7] ARM: OMAP2xxx: hwmod: Convert SHAM crypto device
 data to hwmod
Date: Fri, 9 Nov 2012 18:10:20 +0200
Message-ID: <CALLzPKY7TCFe0yvpwJFNf8U2=h4k1Jcb8g9Q0UpGM8qv2FcSwg@mail.gmail.com>
References: <1352257033-32495-1-git-send-email-mgreer@animalcreek.com>
	<1352257033-32495-2-git-send-email-mgreer@animalcreek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, rmk+kernel@arm.linux.org.uk, paul@pwsan.com,
	khilman@deeprootsystems.com
To: "Mark A. Greer" <mgreer@animalcreek.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga12.intel.com ([143.182.124.36]:9267 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751565Ab2KIQKW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Nov 2012 11:10:22 -0500
Received: by mail-qa0-f70.google.com with SMTP id s11so1488225qaa.1
        for <linux-crypto@vger.kernel.org>; Fri, 09 Nov 2012 08:10:20 -0800 (PST)
In-Reply-To: <1352257033-32495-2-git-send-email-mgreer@animalcreek.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

On Wed, Nov 7, 2012 at 4:57 AM, Mark A. Greer <mgreer@animalcreek.com> wrote:
> From: "Mark A. Greer" <mgreer@animalcreek.com>
>
> Convert the device data for the OMAP2 SHAM crypto IP from
> explicit platform_data to hwmod.
>
> CC: Paul Walmsley <paul@pwsan.com>
> Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
> ---
>  arch/arm/mach-omap2/clock2430_data.c               |  1 +
>  arch/arm/mach-omap2/devices.c                      | 34 ++++++++------------
>  arch/arm/mach-omap2/omap_hwmod_2420_data.c         |  1 +
>  arch/arm/mach-omap2/omap_hwmod_2430_data.c         |  1 +
>  .../mach-omap2/omap_hwmod_2xxx_interconnect_data.c | 18 +++++++++++
>  arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c | 37 ++++++++++++++++++++++
>  arch/arm/mach-omap2/omap_hwmod_common_data.h       |  2 ++
>  7 files changed, 73 insertions(+), 21 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/clock2430_data.c b/arch/arm/mach-omap2/clock2430_data.c
> index 22404fe..4d52ec6 100644
> --- a/arch/arm/mach-omap2/clock2430_data.c
> +++ b/arch/arm/mach-omap2/clock2430_data.c
> @@ -1993,6 +1993,7 @@ static struct omap_clk omap2430_clks[] = {
>         CLK(NULL,       "sdrc_ick",     &sdrc_ick,      CK_243X),
>         CLK(NULL,       "des_ick",      &des_ick,       CK_243X),
>         CLK("omap-sham",        "ick",  &sha_ick,       CK_243X),
> +       CLK(NULL,       "sha_ick",      &sha_ick,       CK_242X),
>         CLK("omap_rng", "ick",          &rng_ick,       CK_243X),
>         CLK(NULL,       "rng_ick",      &rng_ick,       CK_243X),
>         CLK("omap-aes", "ick",  &aes_ick,       CK_243X),
> diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
> index cba60e0..f18fa50 100644
> --- a/arch/arm/mach-omap2/devices.c
> +++ b/arch/arm/mach-omap2/devices.c
> @@ -34,6 +34,8 @@
>  #include "mux.h"
>  #include "control.h"
>  #include "devices.h"
> +#include "cm2xxx_3xxx.h"
> +#include "cm-regbits-24xx.h"
>
>  #define L3_MODULES_MAX_LEN 12
>  #define L3_MODULES 3
> @@ -453,24 +455,6 @@ static void omap_init_rng(void)
>
>  #if defined(CONFIG_CRYPTO_DEV_OMAP_SHAM) || defined(CONFIG_CRYPTO_DEV_OMAP_SHAM_MODULE)
>
> -#ifdef CONFIG_ARCH_OMAP2
> -static struct resource omap2_sham_resources[] = {
> -       {
> -               .start  = OMAP24XX_SEC_SHA1MD5_BASE,
> -               .end    = OMAP24XX_SEC_SHA1MD5_BASE + 0x64,
> -               .flags  = IORESOURCE_MEM,
> -       },
> -       {
> -               .start  = 51 + OMAP_INTC_START,
> -               .flags  = IORESOURCE_IRQ,
> -       }
> -};
> -static int omap2_sham_resources_sz = ARRAY_SIZE(omap2_sham_resources);
> -#else
> -#define omap2_sham_resources           NULL
> -#define omap2_sham_resources_sz                0
> -#endif
> -
>  #ifdef CONFIG_ARCH_OMAP3
>  static struct resource omap3_sham_resources[] = {
>         {
> @@ -501,16 +485,24 @@ static struct platform_device sham_device = {
>  static void omap_init_sham(void)
>  {
>         if (cpu_is_omap24xx()) {
> -               sham_device.resource = omap2_sham_resources;
> -               sham_device.num_resources = omap2_sham_resources_sz;
> +               struct omap_hwmod *oh;
> +               struct platform_device *pdev;
> +
> +               oh = omap_hwmod_lookup("sham");
> +               if (!oh)
> +                       return;
> +
> +               pdev = omap_device_build("omap-sham", -1, oh, NULL, 0, NULL,
> +                                        0, 0);
> +               WARN(IS_ERR(pdev), "Can't build omap_device for omap-sham\n");
>         } else if (cpu_is_omap34xx()) {
>                 sham_device.resource = omap3_sham_resources;
>                 sham_device.num_resources = omap3_sham_resources_sz;
> +               platform_device_register(&sham_device);

Why changes are only for OMAP2?
OMAP3 is also the same class.

>         } else {
>                 pr_err("%s: platform not supported\n", __func__);
>                 return;
>         }
> -       platform_device_register(&sham_device);
>  }
>  #else
>  static inline void omap_init_sham(void) { }
> diff --git a/arch/arm/mach-omap2/omap_hwmod_2420_data.c b/arch/arm/mach-omap2/omap_hwmod_2420_data.c
> index b5db600..b102a53 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_2420_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_2420_data.c
> @@ -603,6 +603,7 @@ static struct omap_hwmod_ocp_if *omap2420_hwmod_ocp_ifs[] __initdata = {
>         &omap2420_l4_core__mcbsp2,
>         &omap2420_l4_core__msdi1,
>         &omap2xxx_l4_core__rng,
> +       &omap2xxx_l4_core__sham,
>         &omap2420_l4_core__hdq1w,
>         &omap2420_l4_wkup__counter_32k,
>         &omap2420_l3__gpmc,
> diff --git a/arch/arm/mach-omap2/omap_hwmod_2430_data.c b/arch/arm/mach-omap2/omap_hwmod_2430_data.c
> index c455e41..b1ce7b0 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_2430_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_2430_data.c
> @@ -963,6 +963,7 @@ static struct omap_hwmod_ocp_if *omap2430_hwmod_ocp_ifs[] __initdata = {
>         &omap2430_l4_core__mcbsp5,
>         &omap2430_l4_core__hdq1w,
>         &omap2xxx_l4_core__rng,
> +       &omap2xxx_l4_core__sham,
>         &omap2430_l4_wkup__counter_32k,
>         &omap2430_l3__gpmc,
>         NULL,
> diff --git a/arch/arm/mach-omap2/omap_hwmod_2xxx_interconnect_data.c b/arch/arm/mach-omap2/omap_hwmod_2xxx_interconnect_data.c
> index 1a1287d..bb314c5 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_2xxx_interconnect_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_2xxx_interconnect_data.c
> @@ -138,6 +138,15 @@ static struct omap_hwmod_addr_space omap2_rng_addr_space[] = {
>         { }
>  };
>
> +struct omap_hwmod_addr_space omap2xxx_sham_addrs[] = {
> +       {
> +               .pa_start       = 0x480a4000,
> +               .pa_end         = 0x480a4000 + 0x64 - 1,
> +               .flags          = ADDR_TYPE_RT
> +       },
> +       { }
> +};

Why not using macros as it was before?

OMAP24XX_SEC_SHA1MD5_BASE

> +
>  /*
>   * Common interconnect data
>   */
> @@ -389,3 +398,12 @@ struct omap_hwmod_ocp_if omap2xxx_l4_core__rng = {
>         .addr           = omap2_rng_addr_space,
>         .user           = OCP_USER_MPU | OCP_USER_SDMA,
>  };
> +
> +/* l4 core -> sham interface */
> +struct omap_hwmod_ocp_if omap2xxx_l4_core__sham = {
> +       .master         = &omap2xxx_l4_core_hwmod,
> +       .slave          = &omap2xxx_sham_hwmod,
> +       .clk            = "sha_ick",
> +       .addr           = omap2xxx_sham_addrs,
> +       .user           = OCP_USER_MPU,
> +};
> diff --git a/arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c b/arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c
> index bd9220e..a041670 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c
> @@ -851,3 +851,40 @@ struct omap_hwmod omap2xxx_rng_hwmod = {
>         .flags          = HWMOD_INIT_NO_RESET,
>         .class          = &omap2_rng_hwmod_class,
>  };
> +
> +/* SHAM */
> +
> +static struct omap_hwmod_class_sysconfig omap2_sham_sysc = {
> +       .rev_offs       = 0x5c,
> +       .sysc_offs      = 0x60,
> +       .syss_offs      = 0x64,
> +       .sysc_flags     = (SYSC_HAS_SOFTRESET | SYSC_HAS_AUTOIDLE |
> +                          SYSS_HAS_RESET_STATUS),
> +       .sysc_fields    = &omap_hwmod_sysc_type1,
> +};
> +
> +static struct omap_hwmod_class omap2xxx_sham_class = {
> +       .name   = "sham",
> +       .sysc   = &omap2_sham_sysc,
> +};
> +
> +struct omap_hwmod_irq_info omap2_sham_mpu_irqs[] = {
> +       { .irq = 51 + OMAP_INTC_START, },
> +       { .irq = -1 }
> +};
> +
> +struct omap_hwmod omap2xxx_sham_hwmod = {
> +       .name           = "sham",
> +       .mpu_irqs       = omap2_sham_mpu_irqs,
> +       .main_clk       = "l4_ck",
> +       .prcm           = {
> +               .omap2 = {
> +                       .module_offs = CORE_MOD,
> +                       .prcm_reg_id = 4,
> +                       .module_bit = OMAP24XX_EN_SHA_SHIFT,
> +                       .idlest_reg_id = 4,
> +                       .idlest_idle_bit = OMAP24XX_ST_SHA_SHIFT,
> +               },
> +       },
> +       .class          = &omap2xxx_sham_class,
> +};
> diff --git a/arch/arm/mach-omap2/omap_hwmod_common_data.h b/arch/arm/mach-omap2/omap_hwmod_common_data.h
> index 2bc8f17..74a7b7a 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_common_data.h
> +++ b/arch/arm/mach-omap2/omap_hwmod_common_data.h
> @@ -78,6 +78,7 @@ extern struct omap_hwmod omap2xxx_mcspi2_hwmod;
>  extern struct omap_hwmod omap2xxx_counter_32k_hwmod;
>  extern struct omap_hwmod omap2xxx_gpmc_hwmod;
>  extern struct omap_hwmod omap2xxx_rng_hwmod;
> +extern struct omap_hwmod omap2xxx_sham_hwmod;
>
>  /* Common interface data across OMAP2xxx */
>  extern struct omap_hwmod_ocp_if omap2xxx_l3_main__l4_core;
> @@ -105,6 +106,7 @@ extern struct omap_hwmod_ocp_if omap2xxx_l4_core__dss_dispc;
>  extern struct omap_hwmod_ocp_if omap2xxx_l4_core__dss_rfbi;
>  extern struct omap_hwmod_ocp_if omap2xxx_l4_core__dss_venc;
>  extern struct omap_hwmod_ocp_if omap2xxx_l4_core__rng;
> +extern struct omap_hwmod_ocp_if omap2xxx_l4_core__sham;
>
>  /* Common IP block data */
>  extern struct omap_hwmod_dma_info omap2_uart1_sdma_reqs[];
> --
> 1.7.12
>
