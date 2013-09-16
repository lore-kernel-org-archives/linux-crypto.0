From: Stephen Warren <swarren-3lzwWm7+Weoh9ZMKESR00Q@public.gmane.org>
Subject: [PATCH] ARM: tegra: remove tegra_chip_uid()
Date: Mon, 16 Sep 2013 09:34:19 -0600
Message-ID: <1379345659-9528-1-git-send-email-swarren@wwwdotorg.org>
Cc: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
	Stephen Warren <swarren-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

From: Stephen Warren <swarren-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>

Following commit f5b38c5 "crypto: tegra - use kernel entropy instead
of ad-hoc", this function is no longer used. It's also only accurate
for Tegra20 and not later SoCs. So, remove it.

Signed-off-by: Stephen Warren <swarren-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
---
Herbert, this is a patch for the crypto tree, since it depends on a
patch to the tegra-aes crypto driver that's in your tree.

 arch/arm/mach-tegra/fuse.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/arch/arm/mach-tegra/fuse.c b/arch/arm/mach-tegra/fuse.c
index e035cd2..64652b3 100644
--- a/arch/arm/mach-tegra/fuse.c
+++ b/arch/arm/mach-tegra/fuse.c
@@ -155,13 +155,3 @@ void tegra_init_fuse(void)
 		tegra_sku_id, tegra_cpu_process_id,
 		tegra_core_process_id);
 }
-
-unsigned long long tegra_chip_uid(void)
-{
-	unsigned long long lo, hi;
-
-	lo = tegra_fuse_readl(FUSE_UID_LOW);
-	hi = tegra_fuse_readl(FUSE_UID_HIGH);
-	return (hi << 32ull) | lo;
-}
-EXPORT_SYMBOL(tegra_chip_uid);
-- 
1.8.1.5
