From: Fabio Estevam <festevam@gmail.com>
Subject: [PATCH] crypto: sahara - propagate the error on clk_disable_unprepare() failure
Date: Sat, 20 Jun 2015 15:30:22 -0300
Message-ID: <1434825022-5797-1-git-send-email-festevam@gmail.com>
Cc: linux-crypto@vger.kernel.org, s.trumtrar@pengutronix.de,
	Fabio Estevam <fabio.estevam@freescale.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:36259 "EHLO
	mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121AbbFTSa7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 20 Jun 2015 14:30:59 -0400
Received: by qkfe185 with SMTP id e185so78285512qkf.3
        for <linux-crypto@vger.kernel.org>; Sat, 20 Jun 2015 11:30:58 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

clk_prepare_enable() may fail, so we should better check its return value
and propagate it in the case of error.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/crypto/sahara.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 6be377f..397a500b 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1578,8 +1578,12 @@ static int sahara_probe(struct platform_device *pdev)
 
 	init_completion(&dev->dma_completion);
 
-	clk_prepare_enable(dev->clk_ipg);
-	clk_prepare_enable(dev->clk_ahb);
+	err = clk_prepare_enable(dev->clk_ipg);
+	if (err)
+		goto err_link;
+	err = clk_prepare_enable(dev->clk_ahb);
+	if (err)
+		goto clk_ipg_disable;
 
 	version = sahara_read(dev, SAHARA_REG_VERSION);
 	if (of_device_is_compatible(pdev->dev.of_node, "fsl,imx27-sahara")) {
@@ -1619,10 +1623,11 @@ err_algs:
 	dma_free_coherent(&pdev->dev,
 			  SAHARA_MAX_HW_LINK * sizeof(struct sahara_hw_link),
 			  dev->hw_link[0], dev->hw_phys_link[0]);
-	clk_disable_unprepare(dev->clk_ipg);
-	clk_disable_unprepare(dev->clk_ahb);
 	kthread_stop(dev->kthread);
 	dev_ptr = NULL;
+	clk_disable_unprepare(dev->clk_ahb);
+clk_ipg_disable:
+	clk_disable_unprepare(dev->clk_ipg);
 err_link:
 	dma_free_coherent(&pdev->dev,
 			  2 * AES_KEYSIZE_128,
-- 
1.9.1
