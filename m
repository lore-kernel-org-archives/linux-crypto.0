From: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v4 5/8] crypto: omap-sham: Remove cpu_is/omap_type
 check from driver
Date: Tue, 20 Nov 2012 17:02:58 -0800
Message-ID: <20121121010257.GR18567@atomide.com>
References: <1353351301-6453-1-git-send-email-mgreer@animalcreek.com>
 <1353351301-6453-6-git-send-email-mgreer@animalcreek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, dmitry.kasatkin@intel.com,
	rmk+kernel@arm.linux.org.uk, paul@pwsan.com,
	khilman@deeprootsystems.com
To: "Mark A. Greer" <mgreer@animalcreek.com>
Return-path: <linux-omap-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1353351301-6453-6-git-send-email-mgreer@animalcreek.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Mark A. Greer <mgreer@animalcreek.com> [121119 10:58]:
> From: "Mark A. Greer" <mgreer@animalcreek.com>
> 
> The omap-sham driver should not check the CPU class or the
> type of OMAP device its on.  The platform code should do
> that instead.

I think I already have a similar patch queued in linux next.

Regards,

Tony
 
> CC: Paul Walmsley <paul@pwsan.com>
> CC: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
> Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
> ---
>  drivers/crypto/omap-sham.c | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
> index a3fd6fc..f50387c 100644
> --- a/drivers/crypto/omap-sham.c
> +++ b/drivers/crypto/omap-sham.c
> @@ -37,7 +37,6 @@
>  #include <crypto/hash.h>
>  #include <crypto/internal/hash.h>
>  
> -#include <plat/cpu.h>
>  #include <plat/dma.h>
>  #include <mach/irqs.h>
>  
> @@ -1289,13 +1288,6 @@ static int __init omap_sham_mod_init(void)
>  {
>  	pr_info("loading %s driver\n", "omap-sham");
>  
> -	if (!cpu_class_is_omap2() ||
> -		(omap_type() != OMAP2_DEVICE_TYPE_SEC &&
> -			omap_type() != OMAP2_DEVICE_TYPE_EMU)) {
> -		pr_err("Unsupported cpu\n");
> -		return -ENODEV;
> -	}
> -
>  	return platform_driver_register(&omap_sham_driver);
>  }
>  
> -- 
> 1.7.12
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
