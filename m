From: <qiang.liu@freescale.com>
Subject: [PATCH v7 8/8] carma: remove unnecessary DMA_INTERRUPT capability
Date: Thu, 9 Aug 2012 16:23:31 +0800
Message-ID: <1344500611-11178-1-git-send-email-qiang.liu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <kim.phillips@freescale.com>, <herbert@gondor.hengli.com.au>,
	<davem@davemloft.net>, Qiang Liu <qiang.liu@freescale.com>,
	"Ira W. Snyder" <iws@ovro.caltech.edu>
To: <linux-crypto@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
	<dan.j.williams@intel.com>, <arnd@arndb.de>,
	<gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
	<dan.j.williams@gmail.com>, <vinod.koul@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Qiang Liu <qiang.liu@freescale.com>

These drivers set the DMA_INTERRUPT capability bit when requesting a DMA
controller channel. This was historical, and is no longer needed.

Recent changes to the drivers/dma/fsldma.c driver have removed support
for this flag. This makes the carma drivers unable to find a DMA channel
with the required capabilities.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
Based on git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
against branch char-misc-next.

 drivers/misc/carma/carma-fpga-program.c |    1 -
 drivers/misc/carma/carma-fpga.c         |    2 +-
 2 files changed, 1 insertions(+), 2 deletions(-)

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
index 8c279da..0c43297 100644
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
--
1.7.5.1
