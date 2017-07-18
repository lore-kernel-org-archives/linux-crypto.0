From: "Allen Hubbe" <Allen.Hubbe@dell.com>
Subject: RE: [PATCH v4 4/5] ntb: ntb_hw_intel: use io-64-nonatomic instead of in-driver hacks
Date: Tue, 18 Jul 2017 13:49:51 -0400
Message-ID: <000201d2ffee$42c4aa90$c84dffb0$@dell.com>
References: <20170718165528.7383-1-logang@deltatee.com> <20170718165528.7383-5-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "=?utf-8?Q?'Horia_Geant=C4=83'?=" <horia.geanta@nxp.com>,
        "'Stephen Bates'" <sbates@raithlin.com>,
        "'Jon Mason'" <jdmason@kudzu.us>
To: "'Logan Gunthorpe'" <logang@deltatee.com>,
        <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        <linux-ntb@googlegroups.com>, <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170718165528.7383-5-logang@deltatee.com>
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Logan Gunthorpe
> Now that ioread64 and iowrite64 are available in io-64-nonatomic,
> we can remove the hack at the top of ntb_hw_intel.c and replace it
> with an include.
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> Cc: Jon Mason <jdmason@kudzu.us>
> Cc: Allen Hubbe <Allen.Hubbe@emc.com>
> Acked-by: Dave Jiang <dave.jiang@intel.com>

Acked-by: Allen Hubbe <Allen.Hubbe@dell.com>

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
