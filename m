From: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 1/2] ARM: OMAP: Trivial driver changes to
 remove include plat/cpu.h
Date: Mon, 8 Oct 2012 11:09:00 -0700
Message-ID: <20121008180900.GL3874@atomide.com>
References: <20121008173452.10603.53886.stgit@muffinssi>
 <20121008173557.10603.18539.stgit@muffinssi>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: alsa-devel@alsa-project.org, Deepak Saxena <dsaxena@plexity.net>,
 Herbert Xu <herbert@gondor.apana.org.au>, Venkatraman S <svenkatr@ti.com>,
 Vinod Koul <vinod.koul@intel.com>, Matt Mackall <mpm@selenic.com>,
 Mark Brown <broonie@opensource.wolfsonmicro.com>, linux-mmc@vger.kernel.org,
 linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 Peter Ujfalusi <peter.ujfalusi@ti.com>, Chris Ball <cjb@laptop.org>,
 Dan Williams <djbw@fb.com>, linux-omap@vger.kernel.org,
 Liam Girdwood <lrg@ti.com>, Jarkko Nikula <jarkko.nikula@bitmer.com>,
 linux-crypto@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Return-path: <alsa-devel-bounces@alsa-project.org>
Content-Disposition: inline
In-Reply-To: <20121008173557.10603.18539.stgit@muffinssi>
List-Unsubscribe: <http://mailman.alsa-project.org/mailman/options/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=unsubscribe>
List-Archive: <http://mailman.alsa-project.org/pipermail/alsa-devel/>
List-Post: <mailto:alsa-devel@alsa-project.org>
List-Help: <mailto:alsa-devel-request@alsa-project.org?subject=help>
List-Subscribe: <http://mailman.alsa-project.org/mailman/listinfo/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=subscribe>
Errors-To: alsa-devel-bounces@alsa-project.org
Sender: alsa-devel-bounces@alsa-project.org
List-Id: linux-crypto.vger.kernel.org

* Tony Lindgren <tony@atomide.com> [121008 10:37]:
> Drivers should not use cpu_is_omap or cpu_class_is_omap macros,
> they should be private to the platform init code. And we'll be
> removing plat/cpu.h and only have a private soc.h for the
> arch/arm/*omap* code.
> 
> This patch is intended as preparation for the core omap changes
> and removes the need to include plat/cpu.h from several drivers.
> This is needed for the ARM common zImage support.
> 
> These changes are OK to do because:
> 
> - omap-rng.c and hsmmc.c don't need plat/cpu.h
> 
> - omap-aes.c and omap-sham.c get the proper platform_data
>   passed to them so they don't need extra checks in the driver
> 
> - omap-dma.c and omap-pcm.c can test the arch locally as
>   omap1 and omap2 cannot be compiled together because of
>   conflicting compiler flags


> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -40,7 +40,6 @@
>  #include <linux/pm_runtime.h>
>  #include <linux/platform_data/mmc-omap.h>
>  #include <mach/hardware.h>
> -#include <plat/cpu.h>
>  
>  /* OMAP HSMMC Host Controller Registers */
>  #define OMAP_HSMMC_SYSSTATUS	0x0014

Actually I'll fold this mmc change into an earlier patch
I've posted as "ARM: OMAP: Split plat/mmc.h into local headers
and platform_data".

Regards,

Tony
