From: Henning Heinold <heinold-cPcqOTmdTlv31zTM6d8ziw@public.gmane.org>
Subject: Re: [PATCH] crypto: driver for tegra AES hardware
Date: Fri, 4 Nov 2011 14:54:36 +0100
Message-ID: <20111104135436.GA29112@mail.familie-heinold.de>
References: <1320405256-29374-1-git-send-email-vwadekar@nvidia.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="NzB8fVQJ5HfG6fxh"
Cc: herbert-F6s6mLieUQo7FNHlEwC/lvQIK84fMopw@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1320405256-29374-1-git-send-email-vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Sender: linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Varun,

thanks that you come up with an "official" patch for the aes-stuff.

Against which tree you did test the patch?

I tested it against  git://git.kernel.org/pub/scm/linux/kernel/git/olof/tegra.git for-next
choose to build it as module and got the following errors:

drivers/crypto/tegra-aes.c: In function 'aes_start_crypt':
drivers/crypto/tegra-aes.c:226:13: error: 'eng' undeclared (first use in this function)
drivers/crypto/tegra-aes.c:226:13: note: each undeclared identifier is reported only once for each function it appears in
drivers/crypto/tegra-aes.c: In function 'aes_irq':
drivers/crypto/tegra-aes.c:614:18: error: 'intr_err_mask' undeclared (first use in this function)
drivers/crypto/tegra-aes.c:620:1: warning: label 'done' defined but not used

Which are problems inside the driver it self, which can be easy fixed:

-       aes_writel(eng, 0xFFFFFFFF, INTR_STATUS);
+       aes_writel(dd, 0xFFFFFFFF, INTR_STATUS);

-       aes_writel(dd, intr_err_mask, INTR_STATUS);
+       aes_writel(dd, INT_ERROR_MASK, INTR_STATUS);

Second problem it don't build as modul 

first:
typo in
MODULE_LICENSE("GPLv2") it needs a space MODULE_LICENSE("GPL v2")

second:
tegra_chip_uid function is not exported

I have attched patch which fixes all the stuff besides the not used variable. 
I did not runtime test it for 3.x kernels, but works backported to
the 2.6.38-chromeos tree.

Bye Henning 

--NzB8fVQJ5HfG6fxh
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-arm-tegra-aes-fix-building-as-module.patch"

>From 96d513a1688e4d1f53f79d099950cb0ad2899848 Mon Sep 17 00:00:00 2001
From: Henning Heinold <heinold-cPcqOTmdTlv31zTM6d8ziw@public.gmane.org>
Date: Fri, 4 Nov 2011 14:52:58 +0100
Subject: [PATCH] arm:tegra:aes: fix building as module

Signed-off-by: Henning Heinold <heinold-cPcqOTmdTlv31zTM6d8ziw@public.gmane.org>
---
 arch/arm/mach-tegra/fuse.c |    2 ++
 drivers/crypto/tegra-aes.c |    6 +++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-tegra/fuse.c b/arch/arm/mach-tegra/fuse.c
index 1fa26d9..ea49bd9 100644
--- a/arch/arm/mach-tegra/fuse.c
+++ b/arch/arm/mach-tegra/fuse.c
@@ -19,6 +19,7 @@
 
 #include <linux/kernel.h>
 #include <linux/io.h>
+#include <linux/module.h>
 
 #include <mach/iomap.h>
 
@@ -58,6 +59,7 @@ unsigned long long tegra_chip_uid(void)
 	hi = fuse_readl(FUSE_UID_HIGH);
 	return (hi << 32ull) | lo;
 }
+EXPORT_SYMBOL(tegra_chip_uid);
 
 int tegra_sku_id(void)
 {
diff --git a/drivers/crypto/tegra-aes.c b/drivers/crypto/tegra-aes.c
index b180a93..c34bc94 100644
--- a/drivers/crypto/tegra-aes.c
+++ b/drivers/crypto/tegra-aes.c
@@ -223,7 +223,7 @@ static int aes_start_crypt(struct tegra_aes_dev *dd, u32 in_addr, u32 out_addr,
 	u32 value;
 
 	/* reset all the interrupt bits */
-	aes_writel(eng, 0xFFFFFFFF, INTR_STATUS);
+	aes_writel(dd, 0xFFFFFFFF, INTR_STATUS);
 
 	/* enable error, dma xfer complete interrupts */
 	aes_writel(dd, 0x33, INT_ENB);
@@ -611,7 +611,7 @@ static irqreturn_t aes_irq(int irq, void *dev_id)
 
 	dev_dbg(dd->dev, "irq_stat: 0x%x", value);
 	if (value & INT_ERROR_MASK)
-		aes_writel(dd, intr_err_mask, INTR_STATUS);
+		aes_writel(dd, INT_ERROR_MASK, INTR_STATUS);
 
 	value = aes_readl(dd, INTR_STATUS);
 	if (!(value & ENGINE_BUSY_FIELD))
@@ -1117,4 +1117,4 @@ module_exit(tegra_aes_module_exit);
 
 MODULE_DESCRIPTION("Tegra AES/OFB/CPRNG hw acceleration support.");
 MODULE_AUTHOR("NVIDIA Corporation");
-MODULE_LICENSE("GPLv2");
+MODULE_LICENSE("GPL v2");
-- 
1.7.7.1


--NzB8fVQJ5HfG6fxh--
