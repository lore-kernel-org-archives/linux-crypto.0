From: Varun Wadekar <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v6 1/2] arm: tegra: export tegra_chip_uid
Date: Wed, 16 Nov 2011 14:24:38 +0530
Message-ID: <1321433679-22036-2-git-send-email-vwadekar@nvidia.com>
References: <1321433679-22036-1-git-send-email-vwadekar@nvidia.com>
Cc: linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org, ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org,
	Henning Heinold <heinold-cPcqOTmdTlv31zTM6d8ziw@public.gmane.org>,
	Varun Wadekar <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
To: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1321433679-22036-1-git-send-email-vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Sender: linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

From: Henning Heinold <heinold-cPcqOTmdTlv31zTM6d8ziw@public.gmane.org>

The crypto driver will need this api to use
it in the RNG calculations. In order to build
the crypto driver as a module, tegra_chip_uid
has to be exported.

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
