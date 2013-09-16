From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH 2/2] crypto: tegra-aes: Use devm_clk_get
Date: Mon, 16 Sep 2013 09:01:11 +0530
Message-ID: <1379302271-22438-2-git-send-email-sachin.kamat@linaro.org>
References: <1379302271-22438-1-git-send-email-sachin.kamat@linaro.org>
Cc: linux-tegra@vger.kernel.org, herbert@gondor.apana.org.au,
	swarren@wwwdotorg.org, sachin.kamat@linaro.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:65467 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756226Ab3IPDta (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 15 Sep 2013 23:49:30 -0400
Received: by mail-pa0-f50.google.com with SMTP id fb10so4806374pad.23
        for <linux-crypto@vger.kernel.org>; Sun, 15 Sep 2013 20:49:29 -0700 (PDT)
In-Reply-To: <1379302271-22438-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

devm_clk_get is device managed and makes code simpler.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/crypto/tegra-aes.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/crypto/tegra-aes.c b/drivers/crypto/tegra-aes.c
index 33f9530..d8c7a13 100644
--- a/drivers/crypto/tegra-aes.c
+++ b/drivers/crypto/tegra-aes.c
@@ -917,7 +917,7 @@ static int tegra_aes_probe(struct platform_device *pdev)
 	}
 
 	/* Initialize the vde clock */
-	dd->aes_clk = clk_get(dev, "vde");
+	dd->aes_clk = devm_clk_get(dev, "vde");
 	if (IS_ERR(dd->aes_clk)) {
 		dev_err(dev, "iclock intialization failed.\n");
 		err = -ENODEV;
@@ -1026,8 +1026,6 @@ out:
 	if (dd->buf_out)
 		dma_free_coherent(dev, AES_HW_DMA_BUFFER_SIZE_BYTES,
 			dd->buf_out, dd->dma_buf_out);
-	if (!IS_ERR(dd->aes_clk))
-		clk_put(dd->aes_clk);
 	if (aes_wq)
 		destroy_workqueue(aes_wq);
 	spin_lock(&list_lock);
@@ -1061,7 +1059,6 @@ static int tegra_aes_remove(struct platform_device *pdev)
 			  dd->buf_in, dd->dma_buf_in);
 	dma_free_coherent(dev, AES_HW_DMA_BUFFER_SIZE_BYTES,
 			  dd->buf_out, dd->dma_buf_out);
-	clk_put(dd->aes_clk);
 	aes_dev = NULL;
 
 	return 0;
-- 
1.7.9.5
