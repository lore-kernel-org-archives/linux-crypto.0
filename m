From: Logan Gunthorpe <logang@deltatee.com>
Subject: [PATCH v11 5/7] ntb: ntb_hw_intel: use io-64-nonatomic instead of in-driver hacks
Date: Mon,  5 Mar 2018 12:08:22 -0700
Message-ID: <20180305190824.847-6-logang@deltatee.com>
References: <20180305190824.847-1-logang@deltatee.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Logan Gunthorpe <logang@deltatee.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-crypto@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180305190824.847-1-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Now that ioread64 and iowrite64 are available in io-64-nonatomic,
we can remove the hack at the top of ntb_hw_intel.c and replace it
with an include.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Acked-by: Dave Jiang <dave.jiang@intel.com>
Acked-by: Allen Hubbe <Allen.Hubbe@dell.com>
Acked-by: Jon Mason <jdmason@kudzu.us>

# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
#
# Date:      Mon Jun 19 12:18:31 2017 -0600
#
# interactive rebase in progress; onto ae64f9bd1d36
# Last commands done (6 commands done):
#    pick cf3e4dab2173 io-64-nonatomic: add io{read|write}64[be]{_lo_hi|_hi_lo} macros
#    r 79b4c4b8490c ntb: ntb_hw_intel: use io-64-nonatomic instead of in-driver hacks
# Next commands to do (2 remaining commands):
#    r 19b6c1f3b15d crypto: caam: cleanup CONFIG_64BIT ifdefs when using io{read|write}64
#    r f3c8723446ef ntb_hw_switchtec: Cleanup 64bit IO defines to use the common header
# You are currently editing a commit while rebasing branch 'io64_v9' on 'ae64f9bd1d36'.
#
# Changes to be committed:
#	modified:   drivers/ntb/hw/intel/ntb_hw_intel.c
#
---
 drivers/ntb/hw/intel/ntb_hw_intel.c | 30 +-----------------------------
 1 file changed, 1 insertion(+), 29 deletions(-)

diff --git a/drivers/ntb/hw/intel/ntb_hw_intel.c b/drivers/ntb/hw/intel/ntb_hw_intel.c
index 156b45cd4a19..5cf40ab21366 100644
--- a/drivers/ntb/hw/intel/ntb_hw_intel.c
+++ b/drivers/ntb/hw/intel/ntb_hw_intel.c
@@ -59,6 +59,7 @@
 #include <linux/random.h>
 #include <linux/slab.h>
 #include <linux/ntb.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
 
 #include "ntb_hw_intel.h"
 
@@ -149,35 +150,6 @@ MODULE_PARM_DESC(xeon_b2b_dsd_bar5_addr32,
 static inline enum ntb_topo xeon_ppd_topo(struct intel_ntb_dev *ndev, u8 ppd);
 static int xeon_init_isr(struct intel_ntb_dev *ndev);
 
-#ifndef ioread64
-#ifdef readq
-#define ioread64 readq
-#else
-#define ioread64 _ioread64
-static inline u64 _ioread64(void __iomem *mmio)
-{
-	u64 low, high;
-
-	low = ioread32(mmio);
-	high = ioread32(mmio + sizeof(u32));
-	return low | (high << 32);
-}
-#endif
-#endif
-
-#ifndef iowrite64
-#ifdef writeq
-#define iowrite64 writeq
-#else
-#define iowrite64 _iowrite64
-static inline void _iowrite64(u64 val, void __iomem *mmio)
-{
-	iowrite32(val, mmio);
-	iowrite32(val >> 32, mmio + sizeof(u32));
-}
-#endif
-#endif
-
 static inline int pdev_is_xeon(struct pci_dev *pdev)
 {
 	switch (pdev->device) {
-- 
2.11.0
