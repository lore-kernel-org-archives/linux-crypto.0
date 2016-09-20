From: Dave Gerlach <d-gerlach@ti.com>
Subject: [PATCH] hwrng: omap - Only fail if pm_runtime_get_sync returns < 0
Date: Tue, 20 Sep 2016 10:25:40 -0500
Message-ID: <20160920152540.3004-1-d-gerlach@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, Dave Gerlach <d-gerlach@ti.com>
To: Deepak Saxena <dsaxena@plexity.net>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Nishanth Menon <nm@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([198.47.19.11]:50140 "EHLO bear.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753182AbcITP0W (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Sep 2016 11:26:22 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currently omap-rng checks the return value of pm_runtime_get_sync and
reports failure if anything is returned, however it should be checking
if ret < 0 as pm_runtime_get_sync return 0 on success but also can return
1 if the device was already active which is not a failure case. Only
values < 0 are actual failures.

Fixes: 61dc0a446e5d ("hwrng: omap - Fix assumption that runtime_get_sync will always succeed")
Signed-off-by: Dave Gerlach <d-gerlach@ti.com>
---
 drivers/char/hw_random/omap-rng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index 01d4be2c354b..f5c26a5f6875 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -385,7 +385,7 @@ static int omap_rng_probe(struct platform_device *pdev)
 
 	pm_runtime_enable(&pdev->dev);
 	ret = pm_runtime_get_sync(&pdev->dev);
-	if (ret) {
+	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to runtime_get device: %d\n", ret);
 		pm_runtime_put_noidle(&pdev->dev);
 		goto err_ioremap;
@@ -443,7 +443,7 @@ static int __maybe_unused omap_rng_resume(struct device *dev)
 	int ret;
 
 	ret = pm_runtime_get_sync(dev);
-	if (ret) {
+	if (ret < 0) {
 		dev_err(dev, "Failed to runtime_get device: %d\n", ret);
 		pm_runtime_put_noidle(dev);
 		return ret;
-- 
2.9.3
