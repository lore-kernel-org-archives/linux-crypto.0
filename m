From: Varun Wadekar <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1] arm: tegra: export tegra_chip_uid
Date: Tue, 15 Nov 2011 09:49:32 +0530
Message-ID: <1321330772-2750-1-git-send-email-vwadekar@nvidia.com>
Cc: heinold-cPcqOTmdTlv31zTM6d8ziw@public.gmane.org, linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Varun Wadekar <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
To: swarren-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

The crypto driver will need this api to use
it in the RNG calculations. In order to build
the crypto driver as a module, tegra_chip_uid
has to be exported.

Original author: Henning Heinold <heinold-cPcqOTmdTlv31zTM6d8ziw@public.gmane.org>

Signed-off-by: Henning Heinold <heinold-cPcqOTmdTlv31zTM6d8ziw@public.gmane.org>
Signed-off-by: Varun Wadekar <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
---
 arch/arm/mach-tegra/fuse.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

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
-- 
1.7.1
