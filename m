From: Simon Baatz <gmbnomis@gmail.com>
Subject: [PATCH 2/2] ARM: Orion: mv_dma: Add support for clk
Date: Sat, 16 Jun 2012 02:20:21 +0200
Message-ID: <1339806021-14271-3-git-send-email-gmbnomis@gmail.com>
References: <1339521447-17721-1-git-send-email-phil.sutter@viprinet.com>
 <1339806021-14271-1-git-send-email-gmbnomis@gmail.com>
Cc: linux-crypto@vger.kernel.org
To: phil.sutter@viprinet.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52519 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757228Ab2FPAVA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Jun 2012 20:21:00 -0400
Received: by eeit10 with SMTP id t10so1085368eei.19
        for <linux-crypto@vger.kernel.org>; Fri, 15 Jun 2012 17:20:59 -0700 (PDT)
In-Reply-To: <1339806021-14271-1-git-send-email-gmbnomis@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

mv_dma needs the crypto clock. Some orion platforms support gating of the
clock.  If the clock exists enable/disable it as appropriate.

Signed-off-by: Simon Baatz <gmbnomis@gmail.com>
---
 arch/arm/mach-kirkwood/common.c |    1 +
 drivers/crypto/mv_dma.c         |   14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/arch/arm/mach-kirkwood/common.c b/arch/arm/mach-kirkwood/common.c
index 560b920..e7bbc60 100644
--- a/arch/arm/mach-kirkwood/common.c
+++ b/arch/arm/mach-kirkwood/common.c
@@ -234,6 +234,7 @@ void __init kirkwood_clk_init(void)
 	orion_clkdev_add(NULL, "orion-ehci.0", usb0);
 	orion_clkdev_add(NULL, "orion_nand", runit);
 	orion_clkdev_add(NULL, "mvsdio", sdio);
+	orion_clkdev_add(NULL, "mv_tdma", crypto);
 	orion_clkdev_add(NULL, "mv_crypto", crypto);
 	orion_clkdev_add(NULL, MV_XOR_SHARED_NAME ".0", xor0);
 	orion_clkdev_add(NULL, MV_XOR_SHARED_NAME ".1", xor1);
diff --git a/drivers/crypto/mv_dma.c b/drivers/crypto/mv_dma.c
index 125dfee..9fdb7be 100644
--- a/drivers/crypto/mv_dma.c
+++ b/drivers/crypto/mv_dma.c
@@ -13,6 +13,7 @@
 #include <linux/dmapool.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/clk.h>
 #include <linux/slab.h>
 #include <linux/platform_device.h>
 
@@ -36,6 +37,7 @@ struct mv_dma_priv {
 	struct device *dev;
 	void __iomem *reg;
 	int irq;
+	struct clk *clk;
 	/* protecting the dma descriptors and stuff */
 	spinlock_t lock;
 	struct dma_desclist desclist;
@@ -292,6 +294,12 @@ static int mv_init_engine(struct platform_device *pdev,
 		goto out_unmap_reg;
 	}
 
+	/* Not all platforms can gate the clock, so it is not
+	   an error if the clock does not exists. */
+	tpg.clk = clk_get(&pdev->dev, NULL);
+	if (!IS_ERR(tpg.clk))
+		clk_prepare_enable(tpg.clk);
+
 	/* initialise DMA descriptor list */
 	if (init_dma_desclist(&tpg.desclist, tpg.dev,
 			sizeof(struct mv_dma_desc), MV_DMA_ALIGN, 0)) {
@@ -343,6 +351,12 @@ static int mv_remove(struct platform_device *pdev)
 	fini_dma_desclist(&tpg.desclist);
 	free_irq(tpg.irq, &tpg);
 	iounmap(tpg.reg);
+
+	if (!IS_ERR(tpg.clk)) {
+		clk_disable_unprepare(tpg.clk);
+		clk_put(tpg.clk);
+	}
+
 	tpg.dev = NULL;
 	return 0;
 }
-- 
1.7.9.5
