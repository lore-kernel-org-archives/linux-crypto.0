From: Nishanth Menon <nm@ti.com>
Subject: [PATCH] hwrng: OMAP: Fix assumption that runtime_get_sync will always succeed
Date: Fri, 24 Jun 2016 10:57:47 -0500
Message-ID: <1466783867-25743-1-git-send-email-nm@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-omap@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, Nishanth Menon <nm@ti.com>,
	Paul Walmsley <paul@pwsan.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Matt Mackall <mpm@selenic.com>,
	Deepak Saxena <dsaxena@plexity.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:44027 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbcFXP6b (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jun 2016 11:58:31 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

pm_runtime_get_sync does return a error value that must be checked for
error conditions, else, due to various reasons, the device maynot be
enabled and the system will crash due to lack of clock to the hardware
module.

Before:
12.562784] [00000000] *pgd=fe193835
12.562792] Internal error: : 1406 [#1] SMP ARM
[...]
12.562864] CPU: 1 PID: 241 Comm: modprobe Not tainted 4.7.0-rc4-next-20160624 #2
12.562867] Hardware name: Generic DRA74X (Flattened Device Tree)
12.562872] task: ed51f140 ti: ed44c000 task.ti: ed44c000
12.562886] PC is at omap4_rng_init+0x20/0x84 [omap_rng]
12.562899] LR is at set_current_rng+0xc0/0x154 [rng_core]
[...]

After the proper checks:
[   94.366705] omap_rng 48090000.rng: _od_fail_runtime_resume: FIXME:
missing hwmod/omap_dev info
[   94.375767] omap_rng 48090000.rng: Failed to runtime_get device -19
[   94.382351] omap_rng 48090000.rng: initialization failed.

Fixes: 665d92fa85b5 ("hwrng: OMAP: convert to use runtime PM")
Cc: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
---

Patch based on: next-20160624
Issue seen with next-20160624
Full crash log: http://pastebin.ubuntu.com/17801376/

 drivers/char/hw_random/omap-rng.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index 8a1432e8bb80..f30a1870cb64 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -384,7 +384,11 @@ static int omap_rng_probe(struct platform_device *pdev)
 	}
 
 	pm_runtime_enable(&pdev->dev);
-	pm_runtime_get_sync(&pdev->dev);
+	ret = pm_runtime_get_sync(&pdev->dev);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to runtime_get device: %d\n", ret);
+		goto err_ioremap;
+	}
 
 	ret = (dev->of_node) ? of_get_omap_rng_device_details(priv, pdev) :
 				get_omap_rng_device_details(priv);
@@ -435,8 +439,14 @@ static int __maybe_unused omap_rng_suspend(struct device *dev)
 static int __maybe_unused omap_rng_resume(struct device *dev)
 {
 	struct omap_rng_dev *priv = dev_get_drvdata(dev);
+	int ret;
+
+	ret = pm_runtime_get_sync(dev);
+	if (ret) {
+		dev_err(dev, "Failed to runtime_get device: %d\n", ret);
+		return ret;
+	}
 
-	pm_runtime_get_sync(dev);
 	priv->pdata->init(priv);
 
 	return 0;
-- 
2.9.0
