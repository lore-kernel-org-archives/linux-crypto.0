From: Simon Baatz <gmbnomis@gmail.com>
Subject: [PATCH 1/1] mv_dma: mv_cesa: fixes for clock init
Date: Tue, 26 Jun 2012 22:31:52 +0200
Message-ID: <1340742712-5821-2-git-send-email-gmbnomis@gmail.com>
References: <20120618134718.GL9122@philter.vipri.net>
 <1340742712-5821-1-git-send-email-gmbnomis@gmail.com>
Cc: linux-crypto@vger.kernel.org, cloudy.linux@gmail.com
To: phil.sutter@viprinet.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59866 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab2FZUcQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jun 2012 16:32:16 -0400
Received: by wgbdr13 with SMTP id dr13so294604wgb.1
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jun 2012 13:32:15 -0700 (PDT)
In-Reply-To: <1340742712-5821-1-git-send-email-gmbnomis@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

mv_dma tries to access CESA engine registers before the CESA clock is
enabled.  Shift the clock enable code to the proper position.

Additionally, both mv_dma and mv_cesa did not disable the clock if something
went wrong during init.

Signed-off-by: Simon Baatz <gmbnomis@gmail.com>
---
 drivers/crypto/mv_cesa.c |    7 ++++++-
 drivers/crypto/mv_dma.c  |   44 +++++++++++++++++++++++++++++---------------
 2 files changed, 35 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index b75fdf5..aa05567 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -1308,7 +1308,8 @@ static int mv_probe(struct platform_device *pdev)
 		ret = -ENOMEM;
 		goto err_mapping;
 	}
-	if (set_dma_desclist_size(&cpg->desclist, MV_DMA_INIT_POOLSIZE)) {
+	ret = set_dma_desclist_size(&cpg->desclist, MV_DMA_INIT_POOLSIZE);
+	if (ret) {
 		printk(KERN_ERR MV_CESA "failed to initialise poolsize\n");
 		goto err_pool;
 	}
@@ -1350,6 +1351,10 @@ err_mapping:
 	dma_unmap_single(&pdev->dev, cpg->sa_sram_dma,
 			sizeof(struct sec_accel_sram), DMA_TO_DEVICE);
 	free_irq(irq, cp);
+	if (!IS_ERR(cp->clk)) {
+		clk_disable_unprepare(cp->clk);
+		clk_put(cp->clk);
+	}
 err_thread:
 	kthread_stop(cp->queue_th);
 err_unmap_sram:
diff --git a/drivers/crypto/mv_dma.c b/drivers/crypto/mv_dma.c
index dd1ce02..9440fbc 100644
--- a/drivers/crypto/mv_dma.c
+++ b/drivers/crypto/mv_dma.c
@@ -350,23 +350,39 @@ static int mv_init_engine(struct platform_device *pdev, u32 ctrl_init_val,
 	tpg.dev = &pdev->dev;
 	tpg.print_and_clear_irq = pc_irq;
 
+	/* Not all platforms can gate the clock, so it is not
+	   an error if the clock does not exists. */
+	tpg.clk = clk_get(&pdev->dev, NULL);
+	if (!IS_ERR(tpg.clk))
+		clk_prepare_enable(tpg.clk);
+
 	/* setup address decoding */
 	res = platform_get_resource_byname(pdev,
 			IORESOURCE_MEM, "regs deco");
-	if (!res)
-		return -ENXIO;
-	if (!(deco = ioremap(res->start, resource_size(res))))
-		return -ENOMEM;
+	if (!res) {
+		rc = -ENXIO;
+		goto out_disable_clk;
+	}
+	deco = ioremap(res->start, resource_size(res));
+	if (!deco) {
+		rc = -ENOMEM;
+		goto out_disable_clk;
+	}
 	setup_mbus_windows(deco, pdev->dev.platform_data, win_setter);
 	iounmap(deco);
 
 	/* get register start address */
 	res = platform_get_resource_byname(pdev,
 			IORESOURCE_MEM, "regs control and error");
-	if (!res)
-		return -ENXIO;
-	if (!(tpg.reg = ioremap(res->start, resource_size(res))))
-		return -ENOMEM;
+	if (!res) {
+		rc = -ENXIO;
+		goto out_disable_clk;
+	}
+	tpg.reg = ioremap(res->start, resource_size(res));
+	if (!tpg.reg) {
+		rc = -ENOMEM;
+		goto out_disable_clk;
+	}
 
 	/* get the IRQ */
 	tpg.irq = platform_get_irq(pdev, 0);
@@ -375,12 +391,6 @@ static int mv_init_engine(struct platform_device *pdev, u32 ctrl_init_val,
 		goto out_unmap_reg;
 	}
 
-	/* Not all platforms can gate the clock, so it is not
-	   an error if the clock does not exists. */
-	tpg.clk = clk_get(&pdev->dev, NULL);
-	if (!IS_ERR(tpg.clk))
-		clk_prepare_enable(tpg.clk);
-
 	/* initialise DMA descriptor list */
 	if (init_dma_desclist(&tpg.desclist, tpg.dev,
 			sizeof(struct mv_dma_desc), MV_DMA_ALIGN, 0)) {
@@ -421,6 +431,11 @@ out_free_desclist:
 	fini_dma_desclist(&tpg.desclist);
 out_unmap_reg:
 	iounmap(tpg.reg);
+out_disable_clk:
+	if (!IS_ERR(tpg.clk)) {
+		clk_disable_unprepare(tpg.clk);
+		clk_put(tpg.clk);
+	}
 	tpg.dev = NULL;
 	return rc;
 }
@@ -517,4 +532,3 @@ module_exit(mv_dma_exit);
 MODULE_AUTHOR("Phil Sutter <phil.sutter@viprinet.com>");
 MODULE_DESCRIPTION("Support for Marvell's IDMA/TDMA engines");
 MODULE_LICENSE("GPL");
-
-- 
1.7.9.5
