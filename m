From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: [PATCH 2/6] hwrng: OMAP: Convert to devm_kzalloc()
Date: Mon, 5 Aug 2013 20:17:19 +0530
Message-ID: <1375714043-23407-3-git-send-email-lokeshvutla@ti.com>
References: <1375714043-23407-1-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>, <mpm@selenic.com>,
	<herbert@gondor.hengli.com.au>, <dsaxena@plexity.net>,
	<linux-crypto@vger.kernel.org>, Lokesh Vutla <lokeshvutla@ti.com>
To: <linux-omap@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:44828 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115Ab3HEOsN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 5 Aug 2013 10:48:13 -0400
In-Reply-To: <1375714043-23407-1-git-send-email-lokeshvutla@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use devm_kzalloc() to make cleanup paths simpler.

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
---
 drivers/char/hw_random/omap-rng.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index 3e9a7ec..9c19396 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -109,7 +109,8 @@ static int omap_rng_probe(struct platform_device *pdev)
 	struct omap_rng_private_data *priv;
 	int ret;
 
-	priv = kzalloc(sizeof(struct omap_rng_private_data), GFP_KERNEL);
+	priv = devm_kzalloc(&pdev->dev, sizeof(struct omap_rng_private_data),
+			    GFP_KERNEL);
 	if (!priv) {
 		dev_err(&pdev->dev, "could not allocate memory\n");
 		return -ENOMEM;
@@ -144,8 +145,6 @@ err_register:
 	priv->base = NULL;
 	pm_runtime_disable(&pdev->dev);
 err_ioremap:
-	kfree(priv);
-
 	return ret;
 }
 
@@ -160,10 +159,6 @@ static int __exit omap_rng_remove(struct platform_device *pdev)
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
-	release_mem_region(priv->mem_res->start, resource_size(priv->mem_res));
-
-	kfree(priv);
-
 	return 0;
 }
 
-- 
1.7.9.5
