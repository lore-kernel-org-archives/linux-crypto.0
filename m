From: "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: [PATCH 7/7] carma: remove unnecessary DMA_INTERRUPT capability
Date: Tue, 31 Jul 2012 16:45:52 -0700
Message-ID: <1343778352-5549-8-git-send-email-iws@ovro.caltech.edu>
References: <1343778352-5549-1-git-send-email-iws@ovro.caltech.edu>
Cc: linuxppc-dev@lists.ozlabs.org, B32616@freescale.com,
	"Ira W. Snyder" <iws@ovro.caltech.edu>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:59640 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756462Ab2GaXqB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 Jul 2012 19:46:01 -0400
In-Reply-To: <1343778352-5549-1-git-send-email-iws@ovro.caltech.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: "Ira W. Snyder" <iws@ovro.caltech.edu>

These drivers set the DMA_INTERRUPT capability bit when requesting a DMA
controller channel. This was historical, and is no longer needed.

Recent changes to the drivers/dma/fsldma.c driver have removed support
for this flag. This makes the carma drivers unable to find a DMA channel
with the required capabilities.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 drivers/misc/carma/carma-fpga-program.c |    1 -
 drivers/misc/carma/carma-fpga.c         |    3 +--
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/carma/carma-fpga-program.c b/drivers/misc/carma/carma-fpga-program.c
index a2d25e4..eaddfe9 100644
--- a/drivers/misc/carma/carma-fpga-program.c
+++ b/drivers/misc/carma/carma-fpga-program.c
@@ -978,7 +978,6 @@ static int fpga_of_probe(struct platform_device *op)
 	dev_set_drvdata(priv->dev, priv);
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_MEMCPY, mask);
-	dma_cap_set(DMA_INTERRUPT, mask);
 	dma_cap_set(DMA_SLAVE, mask);
 	dma_cap_set(DMA_SG, mask);
 
diff --git a/drivers/misc/carma/carma-fpga.c b/drivers/misc/carma/carma-fpga.c
index 8c279da..861b298 100644
--- a/drivers/misc/carma/carma-fpga.c
+++ b/drivers/misc/carma/carma-fpga.c
@@ -666,7 +666,7 @@ static int data_submit_dma(struct fpga_device *priv, struct data_buf *buf)
 	src = SYS_FPGA_BLOCK;
 	tx = chan->device->device_prep_dma_memcpy(chan, dst, src,
 						  REG_BLOCK_SIZE,
-						  DMA_PREP_INTERRUPT);
+						  0);
 	if (!tx) {
 		dev_err(priv->dev, "unable to prep SYS-FPGA DMA\n");
 		return -ENOMEM;
@@ -1333,7 +1333,6 @@ static int data_of_probe(struct platform_device *op)
 
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_MEMCPY, mask);
-	dma_cap_set(DMA_INTERRUPT, mask);
 	dma_cap_set(DMA_SLAVE, mask);
 	dma_cap_set(DMA_SG, mask);
 
-- 
1.7.8.6
