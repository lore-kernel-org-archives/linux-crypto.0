From: Fabio Estevam <festevam@gmail.com>
Subject: [PATCH 3/3] crypto: dcp: Fix the path for releasing the resources
Date: Sun, 22 Sep 2013 14:42:27 -0300
Message-ID: <1379871747-17570-3-git-send-email-festevam@gmail.com>
References: <1379871747-17570-1-git-send-email-festevam@gmail.com>
Cc: tobias.rauter@gmail.com, linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ye0-f173.google.com ([209.85.213.173]:54362 "EHLO
	mail-ye0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab3IVRmj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 22 Sep 2013 13:42:39 -0400
Received: by mail-ye0-f173.google.com with SMTP id m3so907518yen.18
        for <linux-crypto@vger.kernel.org>; Sun, 22 Sep 2013 10:42:38 -0700 (PDT)
In-Reply-To: <1379871747-17570-1-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

tasklet_kill() is not being called in probe and the remove function releases
the resources in the wrong order.

Fix these issues.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/crypto/dcp.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/dcp.c b/drivers/crypto/dcp.c
index 93ab753..38d7a9f 100644
--- a/drivers/crypto/dcp.c
+++ b/drivers/crypto/dcp.c
@@ -842,6 +842,8 @@ err_unregister:
 	for (j = 0; j < i; j++)
 		crypto_unregister_alg(&algs[j]);
 err_free_key_iv:
+	tasklet_kill(&dev->done_task);
+	tasklet_kill(&dev->queue_task);
 	dma_free_coherent(&pdev->dev, 2 * AES_KEYSIZE_128, dev->payload_base,
 			dev->payload_base_dma);
 err_free_hw_packet:
@@ -857,21 +859,21 @@ static int dcp_remove(struct platform_device *pdev)
 	struct dcp_dev *dev;
 	int j;
 	dev = platform_get_drvdata(pdev);
+
+	misc_deregister(&dev->dcp_bootstream_misc);
 
-	dma_free_coherent(&pdev->dev,
-			DCP_MAX_PKG * sizeof(struct dcp_hw_packet),
-			dev->hw_pkg[0],	dev->hw_phys_pkg);
-
-	dma_free_coherent(&pdev->dev, 2 * AES_KEYSIZE_128, dev->payload_base,
-			dev->payload_base_dma);
+	for (j = 0; j < ARRAY_SIZE(algs); j++)
+		crypto_unregister_alg(&algs[j]);
 
 	tasklet_kill(&dev->done_task);
 	tasklet_kill(&dev->queue_task);
 
-	for (j = 0; j < ARRAY_SIZE(algs); j++)
-		crypto_unregister_alg(&algs[j]);
+	dma_free_coherent(&pdev->dev, 2 * AES_KEYSIZE_128, dev->payload_base,
+			dev->payload_base_dma);
 
-	misc_deregister(&dev->dcp_bootstream_misc);
+	dma_free_coherent(&pdev->dev,
+			DCP_MAX_PKG * sizeof(struct dcp_hw_packet),
+			dev->hw_pkg[0],	dev->hw_phys_pkg);
 
 	return 0;
 }
-- 
1.8.1.2
