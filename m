From: Nicolas Pitre <nico@cam.org>
Subject: Re: [PATCH] arm/orion5x: add sram support for crypto
Date: Thu, 11 Jun 2009 15:17:09 -0400 (EDT)
Message-ID: <alpine.LFD.2.00.0906111513420.31536@xanadu.home>
References: <1244728999-8103-1-git-send-email-arm-kernel@ml.breakpoint.cc>
 <1244728999-8103-2-git-send-email-arm-kernel@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: arm-kernel@ml.breakpoint.cc
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relais.videotron.ca ([24.201.245.36]:30998 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbZFKTR1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Jun 2009 15:17:27 -0400
Received: from xanadu.home ([66.131.194.97]) by VL-MH-MR001.ip.videotron.ca
 (Sun Java(tm) System Messaging Server 6.3-4.01 (built Aug  3 2007; 32bit))
 with ESMTP id <0KL3005U59KLFVX0@VL-MH-MR001.ip.videotron.ca> for
 linux-crypto@vger.kernel.org; Thu, 11 Jun 2009 15:17:10 -0400 (EDT)
In-reply-to: <1244728999-8103-2-git-send-email-arm-kernel@ml.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 11 Jun 2009, arm-kernel@ml.breakpoint.cc wrote:

> From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> 
> The security accelerator which can act as a puppet player for the crypto
> engine requires its commands in the sram. This patch adds support for the
> phys mapping and creates a platform device the actual driver.
> 
> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

This one is already merged in the Orion and ARM tree, with a minor fix 
and device renamed to be more generic.  The equivalent registration for 
Kirkwood is merged as well already.


> ---
>  arch/arm/mach-orion5x/addr-map.c             |   14 ++++++++-
>  arch/arm/mach-orion5x/common.c               |   36 ++++++++++++++++++++++++++
>  arch/arm/mach-orion5x/common.h               |    2 +
>  arch/arm/mach-orion5x/include/mach/orion5x.h |    6 ++++
>  4 files changed, 56 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-orion5x/addr-map.c b/arch/arm/mach-orion5x/addr-map.c
> index c14d121..d78731e 100644
> --- a/arch/arm/mach-orion5x/addr-map.c
> +++ b/arch/arm/mach-orion5x/addr-map.c
> @@ -14,6 +14,7 @@
>  #include <linux/init.h>
>  #include <linux/mbus.h>
>  #include <linux/io.h>
> +#include <linux/errno.h>
>  #include <mach/hardware.h>
>  #include "common.h"
>  
> @@ -44,6 +45,7 @@
>  #define TARGET_DEV_BUS		1
>  #define TARGET_PCI		3
>  #define TARGET_PCIE		4
> +#define TARGET_SRAM		9
>  #define ATTR_PCIE_MEM		0x59
>  #define ATTR_PCIE_IO		0x51
>  #define ATTR_PCIE_WA		0x79
> @@ -53,6 +55,7 @@
>  #define ATTR_DEV_CS1		0x1d
>  #define ATTR_DEV_CS2		0x1b
>  #define ATTR_DEV_BOOT		0xf
> +#define ATTR_SRAM		0x0
>  
>  /*
>   * Helpers to get DDR bank info
> @@ -87,13 +90,13 @@ static int __init orion5x_cpu_win_can_remap(int win)
>  	return 0;
>  }
>  
> -static void __init setup_cpu_win(int win, u32 base, u32 size,
> +static int __init setup_cpu_win(int win, u32 base, u32 size,
>  				 u8 target, u8 attr, int remap)
>  {
>  	if (win >= 8) {
>  		printk(KERN_ERR "setup_cpu_win: trying to allocate "
>  				"window %d\n", win);
> -		return;
> +		return -ENOSPC;
>  	}
>  
>  	writel(base & 0xffff0000, CPU_WIN_BASE(win));
> @@ -107,6 +110,7 @@ static void __init setup_cpu_win(int win, u32 base, u32 size,
>  		writel(remap & 0xffff0000, CPU_WIN_REMAP_LO(win));
>  		writel(0, CPU_WIN_REMAP_HI(win));
>  	}
> +	return 0;
>  }
>  
>  void __init orion5x_setup_cpu_mbus_bridge(void)
> @@ -193,3 +197,9 @@ void __init orion5x_setup_pcie_wa_win(u32 base, u32 size)
>  	setup_cpu_win(win_alloc_count++, base, size,
>  		      TARGET_PCIE, ATTR_PCIE_WA, -1);
>  }
> +
> +int __init orion5x_setup_sram_win(void)
> +{
> +	return setup_cpu_win(win_alloc_count++, ORION5X_SRAM_PHYS_BASE,
> +			ORION5X_SRAM_SIZE, TARGET_SRAM, ATTR_SRAM, -1);
> +}
> diff --git a/arch/arm/mach-orion5x/common.c b/arch/arm/mach-orion5x/common.c
> index b1c7778..f290582 100644
> --- a/arch/arm/mach-orion5x/common.c
> +++ b/arch/arm/mach-orion5x/common.c
> @@ -536,6 +536,42 @@ void __init orion5x_xor_init(void)
>  	platform_device_register(&orion5x_xor1_channel);
>  }
>  
> +static struct resource orion5x_crypto_res[] = {
> +	{
> +		.name   = "regs",
> +		.start  = ORION5X_CRYPTO_PHYS_BASE,
> +		.end    = ORION5X_CRYPTO_PHYS_BASE + 0xffff,
> +		.flags  = IORESOURCE_MEM,
> +	}, {
> +		.name   = "sram",
> +		.start  = ORION5X_SRAM_PHYS_BASE,
> +		.end    = ORION5X_SRAM_PHYS_BASE + 8 * 1024,
> +		.flags  = IORESOURCE_MEM,
> +	}, {
> +		.name   = "crypto interrupt",
> +		.start  = IRQ_ORION5X_CESA,
> +		.end    = IRQ_ORION5X_CESA,
> +		.flags  = IORESOURCE_IRQ,
> +	},
> +};
> +
> +static struct platform_device orion5x_crypto_device = {
> +	.name           = "mv,orion5x-crypto",
> +	.id             = 0,
> +	.num_resources  = ARRAY_SIZE(orion5x_crypto_res),
> +	.resource       = orion5x_crypto_res,
> +};
> +
> +int __init orion5x_crypto_init(void)
> +{
> +	int ret;
> +
> +	ret = orion5x_setup_sram_win();
> +	if (ret)
> +		return ret;
> +
> +	return platform_device_register(&orion5x_crypto_device);
> +}
>  
>  /*****************************************************************************
>   * Watchdog
> diff --git a/arch/arm/mach-orion5x/common.h b/arch/arm/mach-orion5x/common.h
> index 798b9a5..de483e8 100644
> --- a/arch/arm/mach-orion5x/common.h
> +++ b/arch/arm/mach-orion5x/common.h
> @@ -26,6 +26,7 @@ void orion5x_setup_dev0_win(u32 base, u32 size);
>  void orion5x_setup_dev1_win(u32 base, u32 size);
>  void orion5x_setup_dev2_win(u32 base, u32 size);
>  void orion5x_setup_pcie_wa_win(u32 base, u32 size);
> +int orion5x_setup_sram_win(void);
>  
>  void orion5x_ehci0_init(void);
>  void orion5x_ehci1_init(void);
> @@ -37,6 +38,7 @@ void orion5x_spi_init(void);
>  void orion5x_uart0_init(void);
>  void orion5x_uart1_init(void);
>  void orion5x_xor_init(void);
> +int orion5x_crypto_init(void);
>  
>  /*
>   * PCIe/PCI functions.
> diff --git a/arch/arm/mach-orion5x/include/mach/orion5x.h b/arch/arm/mach-orion5x/include/mach/orion5x.h
> index 377a773..2d87665 100644
> --- a/arch/arm/mach-orion5x/include/mach/orion5x.h
> +++ b/arch/arm/mach-orion5x/include/mach/orion5x.h
> @@ -24,6 +24,7 @@
>   * f1000000	on-chip peripheral registers
>   * f2000000	PCIe I/O space
>   * f2100000	PCI I/O space
> + * f2200000	SRAM dedicated for the crypto unit
>   * f4000000	device bus mappings (boot)
>   * fa000000	device bus mappings (cs0)
>   * fa800000	device bus mappings (cs2)
> @@ -49,6 +50,9 @@
>  #define ORION5X_PCI_IO_BUS_BASE		0x00100000
>  #define ORION5X_PCI_IO_SIZE		SZ_1M
>  
> +#define ORION5X_SRAM_PHYS_BASE		(0xf2200000)
> +#define ORION5X_SRAM_SIZE		SZ_8K
> +
>  /* Relevant only for Orion-1/Orion-NAS */
>  #define ORION5X_PCIE_WA_PHYS_BASE	0xf0000000
>  #define ORION5X_PCIE_WA_VIRT_BASE	0xfe000000
> @@ -94,6 +98,8 @@
>  #define ORION5X_SATA_PHYS_BASE		(ORION5X_REGS_PHYS_BASE | 0x80000)
>  #define ORION5X_SATA_VIRT_BASE		(ORION5X_REGS_VIRT_BASE | 0x80000)
>  
> +#define ORION5X_CRYPTO_PHYS_BASE	(ORION5X_REGS_PHYS_BASE | 0x90000)
> +
>  #define ORION5X_USB1_PHYS_BASE		(ORION5X_REGS_PHYS_BASE | 0xa0000)
>  #define ORION5X_USB1_VIRT_BASE		(ORION5X_REGS_VIRT_BASE | 0xa0000)
>  
> -- 
> 1.6.0.6
> 
