From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH v1] hw_random : omap3-rom-rng:- Handle return value of clk_prepare_enable
Date: Mon, 15 May 2017 13:52:03 +0530
Message-ID: <1494836523-7438-1-git-send-email-arvind.yadav.cs@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: mpm@selenic.com, herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Here, Clock enable can failed. So adding an error check for
clk_prepare_enable.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/char/hw_random/omap3-rom-rng.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/omap3-rom-rng.c b/drivers/char/hw_random/omap3-rom-rng.c
index 37a58d7..38b7190 100644
--- a/drivers/char/hw_random/omap3-rom-rng.c
+++ b/drivers/char/hw_random/omap3-rom-rng.c
@@ -53,7 +53,10 @@ static int omap3_rom_rng_get_random(void *buf, unsigned int count)
 
 	cancel_delayed_work_sync(&idle_work);
 	if (rng_idle) {
-		clk_prepare_enable(rng_clk);
+		r = clk_prepare_enable(rng_clk);
+		if (r)
+			return r;
+
 		r = omap3_rom_rng_call(0, 0, RNG_GEN_PRNG_HW_INIT);
 		if (r != 0) {
 			clk_disable_unprepare(rng_clk);
@@ -88,6 +91,8 @@ static int omap3_rom_rng_read(struct hwrng *rng, void *data, size_t max, bool w)
 
 static int omap3_rom_rng_probe(struct platform_device *pdev)
 {
+	int ret = 0;
+
 	pr_info("initializing\n");
 
 	omap3_rom_rng_call = pdev->dev.platform_data;
@@ -104,7 +109,9 @@ static int omap3_rom_rng_probe(struct platform_device *pdev)
 	}
 
 	/* Leave the RNG in reset state. */
-	clk_prepare_enable(rng_clk);
+	ret = clk_prepare_enable(rng_clk);
+	if (ret)
+		return ret;
 	omap3_rom_rng_idle(0);
 
 	return hwrng_register(&omap3_rom_rng_ops);
-- 
1.9.1
