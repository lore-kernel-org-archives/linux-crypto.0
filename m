From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 1/4] hw_random: bcm63xx-rng: drop bcm_{readl,writel} macros
Date: Mon, 16 Feb 2015 18:09:13 -0800
Message-ID: <1424138956-11563-2-git-send-email-f.fainelli@gmail.com>
References: <1424138956-11563-1-git-send-email-f.fainelli@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	mpm@selenic.com, herbert@gondor.apana.org.au, wsa@the-dreams.de,
	cernekee@gmail.com, Florian Fainelli <f.fainelli@gmail.com>
To: linux-mips@linux-mips.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:35073 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075AbbBQCJ3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Feb 2015 21:09:29 -0500
In-Reply-To: <1424138956-11563-1-git-send-email-f.fainelli@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

bcm_{readl,writel} macros expand to __raw_{readl,writel}, use these
directly such that we do not rely on the platform to provide these for
us. As a result, we no longer use bcm63xx_io.h, so remove that inclusion
too.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/char/hw_random/bcm63xx-rng.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/char/hw_random/bcm63xx-rng.c b/drivers/char/hw_random/bcm63xx-rng.c
index ba6a65ac023b..ed9b28b35a39 100644
--- a/drivers/char/hw_random/bcm63xx-rng.c
+++ b/drivers/char/hw_random/bcm63xx-rng.c
@@ -13,7 +13,6 @@
 #include <linux/platform_device.h>
 #include <linux/hw_random.h>
 
-#include <bcm63xx_io.h>
 #include <bcm63xx_regs.h>
 
 struct bcm63xx_rng_priv {
@@ -28,9 +27,9 @@ static int bcm63xx_rng_init(struct hwrng *rng)
 	struct bcm63xx_rng_priv *priv = to_rng_priv(rng);
 	u32 val;
 
-	val = bcm_readl(priv->regs + RNG_CTRL);
+	val = __raw_readl(priv->regs + RNG_CTRL);
 	val |= RNG_EN;
-	bcm_writel(val, priv->regs + RNG_CTRL);
+	__raw_writel(val, priv->regs + RNG_CTRL);
 
 	return 0;
 }
@@ -40,23 +39,23 @@ static void bcm63xx_rng_cleanup(struct hwrng *rng)
 	struct bcm63xx_rng_priv *priv = to_rng_priv(rng);
 	u32 val;
 
-	val = bcm_readl(priv->regs + RNG_CTRL);
+	val = __raw_readl(priv->regs + RNG_CTRL);
 	val &= ~RNG_EN;
-	bcm_writel(val, priv->regs + RNG_CTRL);
+	__raw_writel(val, priv->regs + RNG_CTRL);
 }
 
 static int bcm63xx_rng_data_present(struct hwrng *rng, int wait)
 {
 	struct bcm63xx_rng_priv *priv = to_rng_priv(rng);
 
-	return bcm_readl(priv->regs + RNG_STAT) & RNG_AVAIL_MASK;
+	return __raw_readl(priv->regs + RNG_STAT) & RNG_AVAIL_MASK;
 }
 
 static int bcm63xx_rng_data_read(struct hwrng *rng, u32 *data)
 {
 	struct bcm63xx_rng_priv *priv = to_rng_priv(rng);
 
-	*data = bcm_readl(priv->regs + RNG_DATA);
+	*data = __raw_readl(priv->regs + RNG_DATA);
 
 	return 4;
 }
-- 
2.1.0
