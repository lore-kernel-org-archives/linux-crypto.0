From: Jon Mason <jdmason@kudzu.us>
Subject: Re: [PATCH v5 5/6] ntb: ntb_hw_intel: use io-64-nonatomic instead of
 in-driver hacks
Date: Tue, 1 Aug 2017 13:47:22 -0400
Message-ID: <20170801174722.GB4186@kudzu.us>
References: <20170726231917.6073-1-logang@deltatee.com>
 <20170726231917.6073-6-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-crypto@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Stephen Bates <sbates@raithlin.com>,
        Allen Hubbe <Allen.Hubbe@emc.com>
To: Logan Gunthorpe <logang@deltatee.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:35943 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751910AbdHARrZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Aug 2017 13:47:25 -0400
Received: by mail-qk0-f196.google.com with SMTP id d136so2261857qkg.3
        for <linux-crypto@vger.kernel.org>; Tue, 01 Aug 2017 10:47:25 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170726231917.6073-6-logang@deltatee.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 26, 2017 at 05:19:16PM -0600, Logan Gunthorpe wrote:
> Now that ioread64 and iowrite64 are available in io-64-nonatomic,
> we can remove the hack at the top of ntb_hw_intel.c and replace it
> with an include.
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> Cc: Jon Mason <jdmason@kudzu.us>

This is okay by me, but I'm assuming that this patch will go through
as part of the series (and not via my tree).  If this changes, please
let me know.

Acked-by: Jon Mason <jdmason@kudzu.us>

> Cc: Allen Hubbe <Allen.Hubbe@emc.com>

You already have Allen's Ack below.  So, you can remove this :)

> Acked-by: Dave Jiang <dave.jiang@intel.com>
> Acked-by: Allen Hubbe <Allen.Hubbe@dell.com>
> ---
>  drivers/ntb/hw/intel/ntb_hw_intel.c | 30 +-----------------------------
>  1 file changed, 1 insertion(+), 29 deletions(-)
> 
> diff --git a/drivers/ntb/hw/intel/ntb_hw_intel.c b/drivers/ntb/hw/intel/ntb_hw_intel.c
> index 2557e2c05b90..606c90f59d4b 100644
> --- a/drivers/ntb/hw/intel/ntb_hw_intel.c
> +++ b/drivers/ntb/hw/intel/ntb_hw_intel.c
> @@ -59,6 +59,7 @@
>  #include <linux/random.h>
>  #include <linux/slab.h>
>  #include <linux/ntb.h>
> +#include <linux/io-64-nonatomic-lo-hi.h>
>  
>  #include "ntb_hw_intel.h"
>  
> @@ -155,35 +156,6 @@ MODULE_PARM_DESC(xeon_b2b_dsd_bar5_addr32,
>  static inline enum ntb_topo xeon_ppd_topo(struct intel_ntb_dev *ndev, u8 ppd);
>  static int xeon_init_isr(struct intel_ntb_dev *ndev);
>  
> -#ifndef ioread64
> -#ifdef readq
> -#define ioread64 readq
> -#else
> -#define ioread64 _ioread64
> -static inline u64 _ioread64(void __iomem *mmio)
> -{
> -	u64 low, high;
> -
> -	low = ioread32(mmio);
> -	high = ioread32(mmio + sizeof(u32));
> -	return low | (high << 32);
> -}
> -#endif
> -#endif
> -
> -#ifndef iowrite64
> -#ifdef writeq
> -#define iowrite64 writeq
> -#else
> -#define iowrite64 _iowrite64
> -static inline void _iowrite64(u64 val, void __iomem *mmio)
> -{
> -	iowrite32(val, mmio);
> -	iowrite32(val >> 32, mmio + sizeof(u32));
> -}
> -#endif
> -#endif
> -
>  static inline int pdev_is_atom(struct pci_dev *pdev)
>  {
>  	switch (pdev->device) {
> -- 
> 2.11.0
> 
> -- 
> You received this message because you are subscribed to the Google Groups "linux-ntb" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to linux-ntb+unsubscribe@googlegroups.com.
> To post to this group, send email to linux-ntb@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/linux-ntb/20170726231917.6073-6-logang%40deltatee.com.
> For more options, visit https://groups.google.com/d/optout.
