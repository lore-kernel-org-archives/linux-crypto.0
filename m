From: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [PATCH v2] hw_random: omap3-rom-rng: convert timer to delayed work
Date: Wed, 18 Nov 2015 21:59:01 +0200
Message-ID: <1447876741-24114-1-git-send-email-aaro.koskinen@iki.fi>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
	linux-omap@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:32980 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403AbbKRT7O (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Nov 2015 14:59:14 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We cannot put the HW RNG to idle using a timer because we cannot disable
clocks from atomic context. Use a delayed work instead.

Fixes a warning with CONFIG_DEBUG_MUTEXES on Nokia N900 during boot.

Reported-by: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---

	v2: Include workqueue.h instead of timer.h.

 drivers/char/hw_random/omap3-rom-rng.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/char/hw_random/omap3-rom-rng.c b/drivers/char/hw_random/omap3-rom-rng.c
index a405cdc..8da14f1 100644
--- a/drivers/char/hw_random/omap3-rom-rng.c
+++ b/drivers/char/hw_random/omap3-rom-rng.c
@@ -17,7 +17,7 @@
 #include <linux/init.h>
 #include <linux/random.h>
 #include <linux/hw_random.h>
-#include <linux/timer.h>
+#include <linux/workqueue.h>
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/platform_device.h>
@@ -29,11 +29,11 @@
 /* param1: ptr, param2: count, param3: flag */
 static u32 (*omap3_rom_rng_call)(u32, u32, u32);
 
-static struct timer_list idle_timer;
+static struct delayed_work idle_work;
 static int rng_idle;
 static struct clk *rng_clk;
 
-static void omap3_rom_rng_idle(unsigned long data)
+static void omap3_rom_rng_idle(struct work_struct *work)
 {
 	int r;
 
@@ -51,7 +51,7 @@ static int omap3_rom_rng_get_random(void *buf, unsigned int count)
 	u32 r;
 	u32 ptr;
 
-	del_timer_sync(&idle_timer);
+	cancel_delayed_work_sync(&idle_work);
 	if (rng_idle) {
 		clk_prepare_enable(rng_clk);
 		r = omap3_rom_rng_call(0, 0, RNG_GEN_PRNG_HW_INIT);
@@ -65,7 +65,7 @@ static int omap3_rom_rng_get_random(void *buf, unsigned int count)
 
 	ptr = virt_to_phys(buf);
 	r = omap3_rom_rng_call(ptr, count, RNG_GEN_HW);
-	mod_timer(&idle_timer, jiffies + msecs_to_jiffies(500));
+	schedule_delayed_work(&idle_work, msecs_to_jiffies(500));
 	if (r != 0)
 		return -EINVAL;
 	return 0;
@@ -102,7 +102,7 @@ static int omap3_rom_rng_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	setup_timer(&idle_timer, omap3_rom_rng_idle, 0);
+	INIT_DELAYED_WORK(&idle_work, omap3_rom_rng_idle);
 	rng_clk = devm_clk_get(&pdev->dev, "ick");
 	if (IS_ERR(rng_clk)) {
 		pr_err("unable to get RNG clock\n");
@@ -118,6 +118,7 @@ static int omap3_rom_rng_probe(struct platform_device *pdev)
 
 static int omap3_rom_rng_remove(struct platform_device *pdev)
 {
+	cancel_delayed_work_sync(&idle_work);
 	hwrng_unregister(&omap3_rom_rng_ops);
 	clk_disable_unprepare(rng_clk);
 	return 0;
-- 
2.4.0
